local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Vault')


function Module:OnEnable()
    self:RegisterBucketEvent(
        {
            'BOSS_KILL',
            'CHALLENGE_MODE_COMPLETED',
            'CHALLENGE_MODE_MAPS_UPDATE',
            'PVP_MATCH_COMPLETE',
            'UPDATE_INSTANCE_INFO',
            'WEEKLY_REWARDS_UPDATE',
        },
        2,
        'UpdateVault'
    )
end

function Module:OnEnteringWorld()
    self:UpdateVault()
end

function Module:UpdateVault()
    local now = time()
    
    Addon.charData.scanTimes["vault"] = now
    local vault = {}

    -- Vault completion
    local activities = C_WeeklyRewards.GetActivities()
    for i = 1, #activities do
        -- [1]={
        --      type=1,
        --      index=3,
        --      activityTierID=0,
        --      progress=8,
        --      rewards={
        --          [1]={
        --              id=193686,
        --              type=1,
        --              quantity=1,
        --              itemDBID="0x123456",
        --          },
        --      },
        --      threshold=10,
        --      level=0,
        --      id=34
        -- },
        local activity = activities[i]
        -- We only care about 1 (Activity), 3 (Raid), 6 (World)
        if activity.type == 1 or activity.type == 3 or activity.type == 6 then
            local key = 't'..activity.type
            local data = {
                level = activity.level,
                progress = activity.progress,
                threshold = activity.threshold,
                tier = activity.activityTierID or 0,
                rewards = {},
            }

            local itemLink, upgradeItemLink = C_WeeklyRewards.GetExampleRewardItemHyperlinks(activity.id)
            if itemLink ~= nil then
                data.itemLevel = C_Item.GetDetailedItemLevelInfo(itemLink)
            end
            if upgradeItemLink ~= nil then
                data.upgradeItemLevel = C_Item.GetDetailedItemLevelInfo(upgradeItemLink)
            end

            for _, reward in ipairs(activity.rewards) do
                local itemLink = C_WeeklyRewards.GetItemHyperlink(reward.itemDBID)
                local parsed = Addon:ParseItemLink(itemLink, -1, 1, 0)
                tinsert(data.rewards, parsed)
            end

            vault[key] = vault[key] or {}
            vault[key][activity.index] = data
        end
    end

    if vault['t1'] and vault['t1'][3] and vault['t1'][3].progress > 0 then
        local runHistory = C_MythicPlus.GetRunHistory(false, true)
        if #runHistory < vault['t1'][3].progress then
            C_Timer.After(2, function() C_WeeklyRewards.OnUIInteract() end)
        end
    end

    Addon.charData.vault = vault
    Addon.charData.vaultAvailableRewards = C_WeeklyRewards.HasAvailableRewards()
    Addon.charData.vaultGeneratedRewards = C_WeeklyRewards.HasGeneratedRewards()
end
