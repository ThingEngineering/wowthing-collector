local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Remix')


local CT_GetConfigIDBySystemID = C_Traits.GetConfigIDBySystemID
local CT_GetNodeInfo = C_Traits.GetNodeInfo
local CUIWM_GetStatusBarWidgetVisualizationInfo = C_UIWidgetManager.GetStatusBarWidgetVisualizationInfo

local ARTIFACT_SYSTEM_ID = 33
local LIMITS_UNBOUND_NODE_ID = 108700
local RESEARCH_WIDGET_ID = 7330

function Module:OnEnable()
    self:RegisterEvent('TRAIT_CONFIG_UPDATED', 'UpdateArtifact')
    self:RegisterBucketEvent({ 'QUEST_LOG_UPDATE' }, 2, 'UpdateResearch')
end

function Module:OnEnteringWorld()
    self:UpdateArtifact()
    self:UpdateResearch()
end

function Module:UpdateArtifact()
    local configId = CT_GetConfigIDBySystemID(ARTIFACT_SYSTEM_ID)
    if configId ~= nil then
        local nodeInfo = CT_GetNodeInfo(configId, LIMITS_UNBOUND_NODE_ID)
        if nodeInfo ~= nil then
            Addon.charData.remixArtifactRank = nodeInfo.currentRank
        end
    end
end

function Module:UpdateResearch()
    local visInfo = CUIWM_GetStatusBarWidgetVisualizationInfo(RESEARCH_WIDGET_ID)
    if visInfo == nil then return end

    Addon.charData.remixResearchHave = visInfo.barValue
    Addon.charData.remixResearchTotal = visInfo.barMax
end
