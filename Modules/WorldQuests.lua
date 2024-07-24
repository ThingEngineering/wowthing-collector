local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('WorldQuests')


Module.db = {}

local C_TaskQuest_GetQuestsForPlayerByMapID = C_TaskQuest.GetQuestsForPlayerByMapID
local C_TaskQuest_GetQuestTimeLeftSeconds = C_TaskQuest.GetQuestTimeLeftSeconds

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

                    local quests = C_TaskQuest_GetQuestsForPlayerByMapID(zoneId)
                    if quests ~= nil then
                        for _, quest in pairs(quests) do
                            if quest.mapID == zoneId then
                                local timeRemaining = C_TaskQuest_GetQuestTimeLeftSeconds(quest.questId)
                                if timeRemaining ~= nil and timeRemaining > 0 then
                                    WWTCSaved.worldQuestIds[quest.questId] = true

                                    local expires = now + timeRemaining
                                    -- Clamp to the nearest 30 minutes
                                    local mod = expires % 1800
                                    if mod > 900 then
                                        expires = expires + (1800 - mod)
                                    else
                                        expires = expires - mod
                                    end

                                    local questRewardCurrencies = C_QuestLog.GetQuestRewardCurrencies(quest.questId)
                                    local rewardCurrencyCount = getn(questRewardCurrencies)
                                    local rewardItemCount = GetNumQuestLogRewards(quest.questId)
                                    local rewardMoney = GetQuestLogRewardMoney(quest.questId)

                                    if rewardCurrencyCount > 0 or rewardItemCount > 0 or rewardMoney > 0 then
                                        local rewards = {}

                                        for i = 1, rewardCurrencyCount do
                                            local quantity, currencyId = questRewardCurrencies[i].totalRewardAmount, questRewardCurrencies[i].currencyID
                                            tinsert(rewards, table.concat({
                                                11, -- Currency
                                                currencyId,
                                                quantity,
                                            }, '-'))
                                        end

                                        for i = 1, rewardItemCount do
                                            local _, _, quantity, _, _, itemId, _ = GetQuestLogRewardInfo(i, quest.questId)
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

                                        questMap[quest.questId] = table.concat({
                                            quest.questId,
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

    Addon:BatchWork(workload)
end
