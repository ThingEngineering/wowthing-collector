local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Delves')


function Module:OnEnable()
    Addon.charData.delves = Addon.charData.delves or { [0] = { '0' } }

    self:RegisterBucketEvent({ 'SCENARIO_COMPLETED' }, 2, 'UpdateScenario')
end

function Module:UpdateScenario()
    local scenarioInfo = C_ScenarioInfo.GetScenarioInfo()
    local widgetInfo = C_UIWidgetManager.GetScenarioHeaderDelvesWidgetVisualizationInfo(6183)
    if scenarioInfo == nil or widgetInfo == nil then return end

    local weeklyReset = time() + C_DateAndTime.GetSecondsUntilWeeklyReset()
    Addon.charData.delves[weeklyReset] = Addon.charData.delves[weeklyReset] or {}

    tinsert(Addon.charData.delves[weeklyReset], table.concat({
        scenarioInfo.scenarioID,
        GetZoneText(),
        widgetInfo.tierText,
    }, '|'))
end
