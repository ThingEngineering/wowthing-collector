local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Remix')


local CUIWM_GetStatusBarWidgetVisualizationInfo = C_UIWidgetManager.GetStatusBarWidgetVisualizationInfo

local RESEARCH_WIDGET_ID = 7330

function Module:OnEnable()
    self:RegisterBucketEvent(
        {
            'QUEST_LOG_UPDATE', -- spammy quest log updates
        },
        2,
        'UpdateResearch'
    )
end

function Module:OnEnteringWorld()
    self:UpdateResearch()
end

function Module:UpdateResearch()
    local visInfo = CUIWM_GetStatusBarWidgetVisualizationInfo(RESEARCH_WIDGET_ID)
    if visInfo == nil then return end

    Addon.charData.remixResearchHave = visInfo.barValue
    Addon.charData.remixResearchTotal = visInfo.barMax
end
