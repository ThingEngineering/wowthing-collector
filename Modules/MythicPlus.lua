local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('MythicPlus')


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
    Addon.charData.keystoneInstance = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
    Addon.charData.keystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel()
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
