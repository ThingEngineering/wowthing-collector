local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Vault')


local TYPE_ACTIVITIES = Enum.WeeklyRewardChestThresholdType.Activities
local TYPE_RAID = Enum.WeeklyRewardChestThresholdType.Raid
local TYPE_WORLD = Enum.WeeklyRewardChestThresholdType.World
local ACTIVITY_TYPES = { TYPE_ACTIVITIES, TYPE_RAID, TYPE_WORLD }

local CI_GetDetailedItemLevelInfo = C_Item.GetDetailedItemLevelInfo
local CI_RequestLoadItemDataByID = C_Item.RequestLoadItemDataByID
local CWR_GetActivities = C_WeeklyRewards.GetActivities
local CWR_GetExampleRewardItemHyperlinks = C_WeeklyRewards.GetExampleRewardItemHyperlinks
local CWR_GetItemHyperlink = C_WeeklyRewards.GetItemHyperlink
local CWR_GetSortedProgressForActivity = C_WeeklyRewards.GetSortedProgressForActivity

function Module:OnEnable()
    Addon.charData.vaultV2 = Addon.charData.vaultV2 or {}

    self:RegisterBucketEvent(
        {
            'BOSS_KILL',
            'CHALLENGE_MODE_COMPLETED',
            'CHALLENGE_MODE_MAPS_UPDATE',
            'PVP_MATCH_COMPLETE',
            'UPDATE_INSTANCE_INFO',
            'WEEKLY_REWARDS_ITEM_CHANGED',
            'WEEKLY_REWARDS_UPDATE',
        },
        2,
        'UpdateVault'
    )
end

function Module:OnEnteringWorld()
    C_Timer.After(2, function()
        C_WeeklyRewards.OnUIInteract()
    end)
end

function Module:UpdateVault()
    local now = time()
    
    Addon.charData.scanTimes["vault"] = now
    
    local vault = Addon.charData.vaultV2
    wipe(vault)

    -- Vault completion
    for _, activityType in ipairs(ACTIVITY_TYPES) do
        local key = 't'..activityType
        local vaultData = {
            activities = {},
            tiers = {},
        }
        vault[key] = vaultData

        local tiers = CWR_GetActivities(activityType) or {}
        for _, tier in ipairs(tiers) do
            local data = {
                level = tier.level,
                progress = tier.progress,
                threshold = tier.threshold,
                tier = tier.activityTierID or 0,
                rewards = {},
            }

            if data.progress >= data.threshold then
                local itemLink, upgradeItemLink = CWR_GetExampleRewardItemHyperlinks(tier.id)

                if itemLink ~= nil or upgradeItemLink ~= nil then
                    if itemLink ~= nil then
                        data.itemLevel = CI_GetDetailedItemLevelInfo(itemLink)
                    end
                    if upgradeItemLink ~= nil then
                        data.upgradeItemLevel = CI_GetDetailedItemLevelInfo(upgradeItemLink)
                    end

                    -- item data probably isn't loaded, try again in a bit
                    if data.itemLevel == nil and data.upgradeItemLevel == nil then
                        if itemLink ~= nil and data.itemLevel == nil then
                            CI_RequestLoadItemDataByID(itemLink)
                        end
                        if upgradeItemLink ~= nil and data.upgradeItemLevel == nil then
                            CI_RequestLoadItemDataByID(upgradeItemLink)
                        end

                        C_MythicPlus.RequestMapInfo()
                        self:UniqueTimer('UpdateVault', 2, 'UpdateVault')
                    end
                end
            end

            for _, reward in ipairs(tier.rewards) do
                local itemLink = CWR_GetItemHyperlink(reward.itemDBID)
                local parsed = Addon:ParseItemLink(itemLink, -1, 1, 0)
                tinsert(data.rewards, parsed)
            end

            vaultData.tiers[tier.index] = data
        end

        local activityProgresses = CWR_GetSortedProgressForActivity(activityType, false) or {}
        for _, activityProgress in ipairs(activityProgresses) do
            tinsert(vaultData.activities, table.concat({
                activityProgress.activityTierID,
                activityProgress.difficulty,
                activityProgress.numPoints
            }, ':'))
        end

    end

    if vault['t1'] and vault['t1'][3] and vault['t1'][3].progress > 0 then
        local runHistory = C_MythicPlus.GetRunHistory(false, true)
        if #runHistory < vault['t1'][3].progress then
            C_Timer.After(2, function() C_WeeklyRewards.OnUIInteract() end)
        end
    end

    Addon.charData.vaultAvailableRewards = C_WeeklyRewards.HasAvailableRewards()
    Addon.charData.vaultGeneratedRewards = C_WeeklyRewards.HasGeneratedRewards()
end
