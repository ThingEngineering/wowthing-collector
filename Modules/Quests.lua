local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Quests')


Module.db = {}

local CQL_GetInfo = C_QuestLog.GetInfo
local CQL_GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries
local CQL_GetQuestObjectives = C_QuestLog.GetQuestObjectives
local CQL_IsOnQuest = C_QuestLog.IsOnQuest
local CQL_IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted
local CTQ_GetQuestTimeLeftSeconds = C_TaskQuest.GetQuestTimeLeftSeconds

local HALF_WEEK = 3.5 * 24 * 60 * 60
local OPTIONAL_OBJECTIVE = OPTIONAL_QUEST_OBJECTIVE_DESCRIPTION:gsub('%%s', '.+'):gsub('([%(%)])', '%%%1')

function Module:OnEnable()
    Addon.charData.progressQuests = Addon.charData.progressQuests or {}

    self:RegisterBucketEvent(
        {
            'QUEST_LOG_UPDATE', -- spammy quest log updates
            'ITEM_PUSH',        -- tracking quests
            'LOOT_CLOSED',      -- tracking quests
            'SHOW_LOOT_TOAST',  -- tracking quests
        },
        2,
        'UpdateQuests'
    )
end

function Module:OnEnteringWorld()
    self:UpdateQuests()
end

function Module:UpdateCompletedQuests()
    Addon.charData.scanTimes["completedQuests"] = time()

    local completedQuestIds = C_QuestLog.GetAllCompletedQuestIDs()
    Addon:DeltaEncode(completedQuestIds, function(output)
        Addon.charData.completedQuestsSquish = output
    end)
end

function Module:UpdateQuests()
    wipe(Addon.charData.progressQuests)

    local now = time()
    Addon.charData.scanTimes["quests"] = now

    local dailyReset = now + C_DateAndTime.GetSecondsUntilDailyReset()
    local weeklyReset = now + C_DateAndTime.GetSecondsUntilWeeklyReset()

    local biweeklyReset = weeklyReset - HALF_WEEK
    if biweeklyReset < now then
        biweeklyReset = weeklyReset
    end

    for _, questId in ipairs(self.db.account) do
        if CQL_IsQuestFlaggedCompleted(questId) then
            WWTCSaved.questsV2[questId] = 1
        end
    end

    local progressQuests = Addon.charData.progressQuests

    for _, questId in ipairs(self.db.manualCheck) do
        if CQL_IsQuestFlaggedCompleted(questId) == false then
            local objectives = CQL_GetQuestObjectives(questId)
            if objectives ~= nil then
                local prog = {
                    id = questId,
                    name = QuestUtils_GetQuestName(questId),
                    status = 1,
                    objectives = {},
                }
                self:AddData(prog, questId, objectives)

                tinsert(progressQuests, table.concat({
                    'q'..prog.id,
                    prog.id,
                    prog.name,
                    prog.status,
                    0,
                    table.concat(prog.objectives, '_'),
                }, '|'))
            end
        end
    end


    local questCount = CQL_GetNumQuestLogEntries()
    for i = 1, questCount do
        local info = CQL_GetInfo(i)
        if info ~= nil and info.questID > 0 then
            local prog = {
                id = info.questID,
                name = QuestUtils_GetQuestName(info.questID),
                status = 1,
                objectives = {},
            }

            local objectives = CQL_GetQuestObjectives(info.questID)
            if objectives ~= nil then
                self:AddData(prog, info.questID, objectives)
            end

            tinsert(progressQuests, table.concat({
                'q'..prog.id,
                prog.id,
                prog.name,
                prog.status,
                0,
                table.concat(prog.objectives, '_'),
            }, '|'))
        end
    end

    for questKey, questData in pairs(self.db.progress) do
        local index = 0
        local prog = {
            reset = 0,
            status = 0,
            objectives = {}
        }

        -- { weekly/biweekly/daily, { ids }, multi? }
        if questData[1] == 'weekly' or questData[1] == 'weeklyWorldQuest' then
            prog.reset = weeklyReset
        elseif questData[1] == 'biweekly' then
            prog.reset = biweeklyReset
        elseif questData[1] == 'daily' then
            prog.reset = dailyReset
        end

        local isWorldQuest = questData[1] == 'weeklyWorldQuest'

        for _, questId in ipairs(questData[2]) do
            if isWorldQuest and prog.reset == 0 then
                local timeLeft = CTQ_GetQuestTimeLeftSeconds(questId)
                if timeLeft ~= nil then
                    prog.reset = now + timeLeft
                end
            end

            -- Quest is completed
            if CQL_IsQuestFlaggedCompleted(questId) then
                prog.id = questId
                prog.name = QuestUtils_GetQuestName(questId)
                prog.status = 2

            -- Quest is in progress, check progress
            elseif CQL_IsOnQuest(questId) then
                local objectives = CQL_GetQuestObjectives(questId)
                if objectives ~= nil then
                    self:AddData(prog, questId, objectives)
                end
            elseif isWorldQuest then
                local altId = self.db.progressUnlock[questId]
                local timeLeft = CTQ_GetQuestTimeLeftSeconds(questId)

                if timeLeft == nil and altId ~= nil then
                    timeLeft = CTQ_GetQuestTimeLeftSeconds(altId)
                end

                if timeLeft ~= nil then
                    prog.reset = now + timeLeft

                    local objectives

                    -- If the unlock quest hasn't been completed we want to use
                    -- the objectives from that instead
                    if altId ~= nil and not CQL_IsQuestFlaggedCompleted(altId) then
                        objectives = CQL_GetQuestObjectives(altId)
                    else
                        objectives = CQL_GetQuestObjectives(questId)
                    end
    
                    if objectives ~= nil then
                        self:AddData(prog, questId, objectives)
                    end
                end
            end

            if prog.status > 0 then
                local actualKey = questKey
                if questData[3] == true then
                    index = index + 1
                    actualKey = questKey..index
                end

                tinsert(progressQuests, table.concat({
                    actualKey,
                    prog.id,
                    prog.name,
                    prog.status,
                    prog.reset,
                    table.concat(prog.objectives, '_'),
                }, '|'))

                -- If it's not a multi-select we can bail now
                if questData[3] ~= true then
                    break
                end
            end

            prog = {
                reset = prog.reset,
                status = 0,
                objectives = {},
            }
        end
    end

    C_Timer.After(0, function() Module:UpdateCompletedQuests() end)
end

function Module:AddData(prog, questId, objectives)
    prog.id = questId
    prog.name = QuestUtils_GetQuestName(questId)
    prog.status = 1

    for _, objective in ipairs(objectives) do
        if objective ~= nil and
            objective.type ~= nil and
            not string.match(objective.text, OPTIONAL_OBJECTIVE)
        then
            local objectiveData = {
                ['type'] = objective.type,
                ['text'] = gsub(
                    objective.text,
                    "%|A:Professions%-Icon%-Quality%-Tier(%d)%-Small:18:18:0:2%|a",
                    "[[tier%1]]"
                ),
            }

            if objective.type == 'progressbar' then
                objectiveData.have = GetQuestProgressBarPercent(questId)
                objectiveData.need = 100
            else
                objectiveData.have = objective.numFulfilled
                objectiveData.need = objective.numRequired
            end

            tinsert(prog.objectives, table.concat({
                objectiveData.type,
                objectiveData.text,
                objectiveData.have,
                objectiveData.need,
            }, ';'))
        end
    end

    -- Backup plan for weird quests like Timewalking item turnins
    if #prog.objectives == 0 then
        local oldQuestId = C_QuestLog.GetSelectedQuest()
        C_QuestLog.SetSelectedQuest(questId)

        tinsert(prog.objectives, table.concat({
            'object',
            GetQuestLogCompletionText() or '',
            1,
            1,
        }, ';'))

        C_QuestLog.SetSelectedQuest(oldQuestId)
    end
end
