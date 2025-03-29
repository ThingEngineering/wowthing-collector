local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Delves')


local CUIWM_GetSpellDisplayVisualizationInfo = C_UIWidgetManager.GetSpellDisplayVisualizationInfo

function Module:OnEnable()
    Addon.charData.delves = Addon.charData.delves or { [0] = { '0' } }
    Addon.charData.delvesGilded = Addon.charData.delvesGilded or 0

    self:RegisterEvent('CURRENCY_DISPLAY_UPDATE')
    self:RegisterBucketEvent({ 'SCENARIO_COMPLETED' }, 2, 'UpdateScenario')
end

function Module:OnEnteringWorld()
    self:UpdateGilded()
end

function Module:CURRENCY_DISPLAY_UPDATE(_, currencyId)
    -- Gilded Undermine Crest
    if currencyId == 3110 then
        C_Timer.After(2, function() self:UpdateGilded() end)
    end
end

function Module:UpdateGilded()
    local visInfo = CUIWM_GetSpellDisplayVisualizationInfo(6659)
    if visInfo ~= nil and visInfo.spellInfo ~= nil and visInfo.spellInfo.tooltip ~= nil then
        local gilded = strmatch(visInfo.spellInfo.tooltip, '(%d)/3') or '0'
        Addon.charData.delvesGilded = tonumber(gilded)
    end
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
