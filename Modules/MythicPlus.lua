local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('MythicPlus')


local ACTIVITY_ID_TO_CHALLENGE_MAP_ID = {
    [1782] = 197, -- Eye of Azshara
    [1783] = 200, -- Halls of Valor
    [1785] = 206, -- Neltharion's Lair
    [1786] = 239, -- Seat of the Triumvirate
    [1787] = 208, -- Maw of Souls
    [1788] = 198, -- Darkheart Thicket
    [1789] = 210, -- Court of Stars
    [1790] = 199, -- Black Rook Hold
    [1791] = 209, -- Arcway
    [1793] = 234, -- Upper Kara
    [1794] = 227, -- Lower Kara
    [1795] = 207, -- Vault of the Wardens
}

function Module:OnEnable()
    Addon.charData.mythicPlusV2 = Addon.charData.mythicPlusV2 or {}
    Addon.charData.mythicPlusV2.seasons = Addon.charData.mythicPlusV2.seasons or {}
    Addon.charData.mythicPlusV2.weeks = Addon.charData.mythicPlusV2.weeks or {}

    self:RegisterEvent('WEEKLY_REWARDS_UPDATE', 'UpdateMythicPlus')

    self:RegisterBucketEvent(
        {
            'BAG_UPDATE_DELAYED',
            'CHALLENGE_MODE_COMPLETED',
            'CHALLENGE_MODE_RESET',
            'CHALLENGE_MODE_START',
        },
        2,
        'UpdateKeystone'
    )
    self:RegisterBucketEvent(
        {
            'CHALLENGE_MODE_COMPLETED',
            'CHALLENGE_MODE_LEADERS_UPDATE',
            'CHALLENGE_MODE_MAPS_UPDATE',
            'CHALLENGE_MODE_MEMBER_INFO_UPDATED',
        },
        1,
        'UpdateMythicPlusData'
    )
end

function Module:OnEnteringWorld()
    self:UpdateKeystone()
    self:UpdateMythicPlus()
end

function Module:UpdateKeystone()
    local keystoneInstance = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
    local keystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel()

    -- try TW key if we didn't find a normal one
    if keystoneInstance == nil and keystoneLevel == nil then
        local activityId, groupId, level = C_LFGList.GetOwnedKeystoneActivityAndGroupAndLevel(true)
        if activityId ~= nil and level ~= nil then
            keystoneInstance = ACTIVITY_ID_TO_CHALLENGE_MAP_ID[activityId]
            keystoneLevel = level
        end
    end

    Addon.charData.keystoneInstance = keystoneInstance
    Addon.charData.keystoneLevel = keystoneLevel
end

function Module:UpdateMythicPlusData()
    C_MythicPlus.RequestMapInfo()
    C_WeeklyRewards.OnUIInteract()
end

-- Scan mythic plus dungeons
function Module:UpdateMythicPlus()
    local now = time()
    Addon.charData.scanTimes["mythicPlus"] = now

    local maps = C_ChallengeMode.GetMapTable()
    local seasonId = C_MythicPlus.GetCurrentSeason()

    local season = {}
    for i = 1, #maps do
        local affixScores, overallScore = C_MythicPlus.GetSeasonBestAffixScoreInfoForMap(maps[i])
        table.insert(season, {
            mapId = maps[i],
            affixScores = affixScores,
            overallScore = overallScore,
        })
    end

    Addon.charData.mythicPlusV2.seasons[seasonId] = season
    
    -- Mythic dungeons
    local runHistory = C_MythicPlus.GetRunHistory(false, true)
    local weeklyReset = now + C_DateAndTime.GetSecondsUntilWeeklyReset()

    local rescan = false
    local mythicDungeons = {}
    local week = {}
    for _, run in ipairs(runHistory) do
        if run.mapChallengeModeID == nil or run.mapChallengeModeID == 0 then
            rescan = true
        end

        table.insert(mythicDungeons, {
            map = run.mapChallengeModeID,
            level = run.level,
        })

        table.insert(week, table.concat({
            run.mapChallengeModeID,
            run.completed and 1 or 0,
            run.level,
            run.runScore,
        }, ':'))
    end

    Addon.charData.mythicDungeons = mythicDungeons
    Addon.charData.mythicPlusV2.weeks[weeklyReset] = week

    if not rescan then
        local vault = C_WeeklyRewards.GetActivities(Enum.WeeklyRewardChestThresholdType.Activities)
        for _, tier in ipairs(vault or {}) do
            if tier.index == 3 and tier.progress < tier.threshold and tier.progress ~= #week then
                rescan = true
            end
        end
    end

    if rescan then
        C_Timer.After(2, function() self:UpdateMythicPlusData() end)
    end
end
