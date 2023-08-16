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
        1,
        'UpdateVault'
    )
end

function Module:OnEnteringWorld()
    self:UpdateVault()
end

function Module:OnLogout()
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
        --      threshold=10,
        --      type=1,
        --      index=3,
        --      progress=8,
        --      level=0,
        --      rewards={
        --      },
        --      id=34
        -- },
        local activity = activities[i]
        -- We only care about 1 (MythicPlus), 2 (RankedPvP), 3 (Raid)
        if activity.type >= 1 and activity.type <= 3 then
            vault[activity.type] = vault[activity.type] or {}
            vault[activity.type][activity.index] = {
                level = activity.level,
                progress = activity.progress,
                threshold = activity.threshold,
            }
        end
    end

    -- TODO rescan later?
    -- if vault[1] and vault[1][3] and vault[1][3].progress > 0 then
    --     local runHistory = C_MythicPlus.GetRunHistory(false, true)
    --     if #runHistory < vault[1][3].progress then
    --         dirtyMythicPlus = true
    --     end
    -- end

    Addon.charData.vault = vault
    Addon.charData.vaultHasRewards = C_WeeklyRewards.HasAvailableRewards()
end
