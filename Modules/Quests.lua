local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Quests')


Module.db = {}

local C_QuestLog_IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted

function Module:OnEnable()
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
    Addon.charData.activeQuests = {}
    Addon.charData.dailyQuests = {}
    Addon.charData.otherQuests = {}
    Addon.charData.progressQuests = {}

    local now = time()
    Addon.charData.scanTimes["quests"] = now

    local dailyReset = now + C_DateAndTime.GetSecondsUntilDailyReset()
    local weeklyReset = now + C_DateAndTime.GetSecondsUntilWeeklyReset()

    local biweeklyReset = weeklyReset - (3.5 * 24 * 60 * 60)
    if biweeklyReset < now then
        biweeklyReset = weeklyReset
    end

    for _, questId in ipairs(self.db.account) do
        if C_QuestLog_IsQuestFlaggedCompleted(questId) then
            WWTCSaved.questsV2[questId] = 1
        end
    end

    local dailyQuests = {}
    for _, autoQuestIds in pairs(self.db.auto) do
        for _, questId in ipairs(autoQuestIds) do
            if C_QuestLog_IsQuestFlaggedCompleted(questId) then
                table.insert(dailyQuests, questId)
            end
        end
    end

    for questId, _ in pairs(WWTCSaved.worldQuestIds or {}) do
        if C_QuestLog_IsQuestFlaggedCompleted(questId) then
            table.insert(dailyQuests, questId)
        end
    end

    Addon.charData.dailyQuests = dailyQuests

    local otherQuests = {}
    for _, questId in ipairs(self.db.tracking) do
        if C_QuestLog_IsQuestFlaggedCompleted(questId) then
            table.insert(otherQuests, questId)
        end
    end
    Addon.charData.otherQuests = otherQuests

    local progressQuests = {}
    for questKey, questData in pairs(self.db.progress) do
        local index = 0
        local prog = {
            reset = 0,
            status = 0,
            objectives = {}
        }

        -- { weekly/biweekly/daily, { ids }, multi? }
        if questData[1] == 'weekly' then
            prog.reset = weeklyReset
        elseif questData[1] == 'biweekly' then
            prog.reset = biweeklyReset
        elseif questData[1] == 'daily' then
            prog.reset = dailyReset
        end

        for _, questId in ipairs(questData[2]) do
            if questData[1] == 'wq' and prog.reset == 0 then
                local timeLeft = C_TaskQuest.GetQuestTimeLeftSeconds(questId)
                if timeLeft ~= nil then
                    prog.reset = now + timeLeft
                end
            end

            -- Quest is completed
            if C_QuestLog_IsQuestFlaggedCompleted(questId) then
                prog.id = questId
                prog.name = QuestUtils_GetQuestName(questId)
                prog.status = 2

            -- Quest is in progress, check progress
            elseif C_QuestLog.IsOnQuest(questId) then
                local objectives = C_QuestLog.GetQuestObjectives(questId)
                if objectives ~= nil then
                    prog.id = questId
                    prog.name = QuestUtils_GetQuestName(questId)
                    prog.status = 1

                    for _, objective in ipairs(objectives) do
                        if objective ~= nil then
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

                            table.insert(prog.objectives, table.concat({
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

                        table.insert(prog.objectives, table.concat({
                            'object',
                            GetQuestLogCompletionText() or '',
                            1,
                            1,
                        }, ';'))

                        C_QuestLog.SetSelectedQuest(oldQuestId)
                    end
                end
            end

            if prog.status > 0 then
                local actualKey = questKey
                if questData[3] == true then
                    index = index + 1
                    actualKey = questKey..index
                end

                table.insert(progressQuests, table.concat({
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
    
    Addon.charData.progressQuests = progressQuests

    C_Timer.After(0, function() Module:UpdateCompletedQuests() end)
end
