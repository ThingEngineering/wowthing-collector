local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('TravelersLog')


function Module:OnEnable()
    WWTCSaved.travelersLogActivities = WWTCSaved.travelersLogActivities or ''
    WWTCSaved.travelersLogCurrent = WWTCSaved.travelersLogCurrent or 0
    WWTCSaved.travelersLogMax = WWTCSaved.travelersLogMax or 0

    self:RegisterBucketEvent(
        { 'PERKS_ACTIVITIES_UPDATED', 'PERKS_ACTIVITY_COMPLETED' },
        2,
        'UpdatePerks'
    )
end

-- seems to trigger automatically?
-- function Module:OnEnteringWorld()
--     C_Timer.After(10, function()
--         print('timer')
--         self:UpdatePerks()
--     end)
-- end

function Module:UpdatePerks()
    if not C_PlayerInfo.IsTravelersLogAvailable() then return end

    local info = C_PerksActivities.GetPerksActivitiesInfo()
    if info == nil then return end

    local endsAt = Addon:RoundToNearest(time() + info.secondsRemaining, 60)
    local activities = {}
    for _, activity in ipairs(info.activities) do
        tinsert(activities, activity.ID)
    end

    table.sort(activities)
    tinsert(activities, 1, endsAt)
    WWTCSaved.travelersLogActivities = table.concat(activities, ':')

    local thresholdMax = 0
    for _, threshold in ipairs(info.thresholds) do
        if threshold.requiredContributionAmount > thresholdMax then
            thresholdMax = threshold.requiredContributionAmount
        end
    end
    WWTCSaved.travelersLogMax = thresholdMax or 1000

    WWTCSaved.travelersLogCurrent = tonumber(GetCVar('perksActivitiesLastPoints'))
end
