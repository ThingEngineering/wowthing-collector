local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Lockouts')


Module.db = {}

local C_QuestLog_IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted

function Module:OnEnable()
    self:RegisterBucketEvent(
        {
            'LFG_UPDATE_RANDOM_INFO',
            'LOOT_CLOSED',
            'SHOW_LOOT_TOAST',
            'UPDATE_INSTANCE_INFO',
        },
        1,
        'UpdateLockouts'
    )

    self:BuildEJData()
end

function Module:OnEnteringWorld()
    self:UpdateLockouts()
end

function Module:BuildEJData()
    self.instanceNameToId = {}
    for tier = 1, EJ_GetNumTiers() do
        EJ_SelectTier(tier)

        for i = 1, 2 do
            local isRaid = i == 1
            local index = 1
            local instanceId, name = EJ_GetInstanceByIndex(index, isRaid)

            while instanceId do
                self.instanceNameToId[name] = instanceId
                index = index + 1
                instanceId, name = EJ_GetInstanceByIndex(index, isRaid)
            end
        end
    end
end

function Module:UpdateLockouts()
    local now = time()
    Addon.charData.scanTimes["lockouts"] = now

    local dailyReset = now + C_DateAndTime.GetSecondsUntilDailyReset()
    local weeklyReset = now + C_DateAndTime.GetSecondsUntilWeeklyReset()
    
    local lockouts = {}
    local instanceDone = {}

    -- Instances
    for i = 1, GetNumSavedInstances() do
        local instanceName, _, instanceReset, instanceDifficulty, locked, _, _,
            _, _, _, maxBosses, defeatedBosses = GetSavedInstanceInfo(i)

        if instanceReset > 0 then
            instanceReset = now + instanceReset
        end

        -- Get saved boss names
        local bosses, j = {}, 1
        local name, _, dead = GetSavedInstanceEncounterInfo(i, j)
        while name do
            bosses[#bosses + 1] = table.concat({
                dead and 1 or 0,
                name,
            }, ':')

            j = j + 1
            name, _, dead = GetSavedInstanceEncounterInfo(i, j)
        end

        table.insert(lockouts, {
            id = self.instanceNameToId[instanceName],
            name = instanceName,
            resetTime = instanceReset,
            bosses = bosses,
            difficulty = instanceDifficulty,
            defeatedBosses = defeatedBosses,
            locked = locked,
            maxBosses = maxBosses,
        })
    end

    -- World bosses
    --for i = 1, GetNumSavedWorldBosses() do
    --    local instanceName, worldBossID, instanceReset = GetSavedWorldBossInfo(i)
    --    charData.lockouts[#charData.lockouts+1] = {
    --        name = instanceName,
    --        resetTime = now + instanceReset,
    --        difficulty = 0,
    --        defeatedBosses = 1,
    --        maxBosses = 1,
    --    }
    --end

    -- LFG lockouts are weird
    for _, instance in pairs(self.db.instances) do
        local availableAll, availablePlayer = IsLFGDungeonJoinable(instance.dungeonId)
        if availableAll then
            local instanceName, _ = GetLFGDungeonInfo(instance.dungeonId)
            local locked, _ = GetLFGDungeonRewards(instance.dungeonId)

            if instance.progressKey then
                table.insert(instanceDone, {
                    key = instance.progressKey,
                    locked = locked,
                    name = instanceName,
                    resetTime = instance.weekly and weeklyReset or dailyReset,
                })
            else
                if locked then
                    table.insert(lockouts, {
                        id = 200000 + instance.dungeonId,
                        name = instanceName,
                        resetTime = dailyReset,
                        bosses = {
                            "1:"..instanceName,
                        },
                        difficulty = 1,
                        defeatedBosses = 1,
                        locked = true,
                        maxBosses = 1,
                    })
                end
            end
        end
    end

    -- Other world bosses
    for questID, questData in pairs(self.db.worldBosses) do
        local groupId, groupName, bossName, isDaily = unpack(questData)
        if C_QuestLog_IsQuestFlaggedCompleted(questID) then
            local resetTime
            if isDaily == true then
                resetTime = dailyReset
            else
                resetTime = weeklyReset
            end

            table.insert(lockouts, {
                id = groupId,
                name = groupName,
                resetTime = resetTime,
                bosses = {
                    "1:"..bossName,
                },
                difficulty = 0,
                defeatedBosses = 1,
                locked = true,
                maxBosses = 1,
                weeklyQuest = true,
            })
        end
    end

    Addon.charData.instanceDone = instanceDone
    Addon.charData.lockouts = lockouts
end
