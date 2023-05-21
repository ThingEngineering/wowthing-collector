local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Location')


function Module:OnEnable()
    self:RegisterEvent('HEARTHSTONE_BOUND', 'UpdateHearth')

    self:RegisterBucketEvent(
        { 'ZONE_CHANGED', 'ZONE_CHANGED_INDOORS', 'ZONE_CHANGED_NEW_AREA' },
        1,
        'UpdateCurrent'
    )
end

function Module:OnEnteringWorld()
    self:UpdateCurrent()
    self:UpdateHearth()
end

function Module:UpdateCurrent()
    local areaText = GetAreaText()
    if areaText == nil then
        return
    end

    local zoneParts = {
        areaText,
    }

    local realZoneText = GetRealZoneText()
    if realZoneText ~= nil and realZoneText ~= '' and realZoneText ~= zoneParts[#zoneParts] then
        table.insert(zoneParts, realZoneText)
    end

    local subZoneText = GetSubZoneText()
    if subZoneText ~= nil and subZoneText ~= '' and subZoneText ~= zoneParts[#zoneParts] then
        table.insert(zoneParts, subZoneText)
    end

    Addon.charData.currentLocation = table.concat(zoneParts, ' > ')
end

function Module:UpdateHearth()
    Addon.charData.bindLocation = GetBindLocation()
end
