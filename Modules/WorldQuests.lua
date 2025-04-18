local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('WorldQuests')


Module.db = {}

local CTQ_GetQuestTimeLeftSeconds = C_TaskQuest.GetQuestTimeLeftSeconds
local CTQ_GetQuestsOnMap = C_TaskQuest.GetQuestsOnMap

function Module:OnEnable()
    Addon.charData.worldQuests = Addon.charData.worldQuests or {}

    self:RegisterBucketEvent({ 'QUEST_LOG_UPDATE' }, 5, 'UpdateWorldQuests')
end

-- function Module:OnEnteringWorld()
--     C_Timer.After(5, function() self:UpdateWorldQuests() end)
-- end

function Module:UpdateWorldQuests()
    local now = time()
    Addon.charData.scanTimes['worldQuests'] = now

    local workload = {}

    for _, expansion in pairs(self.db.expansions) do
        if Addon.charData.level >= expansion.minimumLevel then
            Addon.charData.worldQuests[expansion.id] = Addon.charData.worldQuests[expansion.id] or {}
            for _, zoneId in ipairs(expansion.zones) do
                table.insert(workload, function()
                    Addon.charData.worldQuests[expansion.id][zoneId] = Addon.charData.worldQuests[expansion.id][zoneId] or {}
                    
                    local questMap = {}
                    for _, quest in pairs(Addon.charData.worldQuests[expansion.id][zoneId]) do
                        local questId, expires = strsplit(':', quest)
                        if tonumber(expires) > now then
                            questMap[tonumber(questId)] = quest
                        end
                    end

                    local quests = CTQ_GetQuestsOnMap(zoneId)
                    if quests ~= nil then
                        for _, quest in pairs(quests) do
                            if quest.mapID == zoneId then
                                local questId = quest.questID
                                local timeRemaining = CTQ_GetQuestTimeLeftSeconds(questId)
                                if timeRemaining ~= nil and timeRemaining > 0 then
                                    WWTCSaved.worldQuestIds[questId] = true

                                    local expires = now + timeRemaining
                                    -- Clamp to the nearest 30 minutes
                                    local mod = expires % 1800
                                    if mod > 900 then
                                        expires = expires + (1800 - mod)
                                    else
                                        expires = expires - mod
                                    end

                                    local rewardCurrencies = C_QuestLog.GetQuestRewardCurrencies(questId)
                                    local rewardItemCount = GetNumQuestLogRewards(questId)
                                    local rewardMoney = GetQuestLogRewardMoney(questId)

                                    if #rewardCurrencies > 0 or rewardItemCount > 0 or rewardMoney > 0 then
                                        local rewards = {}

                                        for _, currencyInfo in ipairs(rewardCurrencies) do
                                            tinsert(rewards, table.concat({
                                                11, -- Currency
                                                currencyInfo.currencyID,
                                                currencyInfo.totalRewardAmount,
                                            }, '-'))
                                        end

                                        for i = 1, rewardItemCount do
                                            local _, _, quantity, _, _, itemId, _ = GetQuestLogRewardInfo(i, questId)
                                            tinsert(rewards, table.concat({
                                                9, -- Item
                                                itemId,
                                                quantity,
                                            }, '-'))
                                        end

                                        if rewardMoney > 0 then
                                            tinsert(rewards, table.concat({
                                                11, -- Currency
                                                0,
                                                rewardMoney
                                            }, '-'))
                                        end

                                        questMap[questId] = table.concat({
                                            questId,
                                            expires,
                                            string.format('%.1f', quest.x * 100),
                                            string.format('%.1f', quest.y * 100),
                                            table.concat(rewards, '|')
                                        }, ':')
                                    end
                                end
                            end
                        end

                        local zoneQuests = {}
                        for _, quest in pairs(questMap) do
                            tinsert(zoneQuests, quest)
                        end
                        Addon.charData.worldQuests[expansion.id][zoneId] = zoneQuests
                    end
                end)
            end
        end
    end    

    Addon:QueueWorkload(workload)
end
