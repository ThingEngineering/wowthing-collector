local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Delves')


Module.db = {}

local CAPI_GetAreaPOIInfo = C_AreaPoiInfo.GetAreaPOIInfo
local CQL_IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted
local CUIWM_GetAllWidgetsBySetID = C_UIWidgetManager.GetAllWidgetsBySetID
local CUIWM_GetSpellDisplayVisualizationInfo = C_UIWidgetManager.GetSpellDisplayVisualizationInfo
local CUIWM_GetTextWithStateWidgetVisualizationInfo = C_UIWidgetManager.GetTextWithStateWidgetVisualizationInfo

function Module:OnEnable()
    Addon.charData.delvesGilded = Addon.charData.delvesGilded or 0

    self:RegisterEvent('CURRENCY_DISPLAY_UPDATE')
    self:RegisterBucketEvent(
        {
            'AREA_POIS_UPDATED',
        },
        2,
        'UpdateDelves'
    )
end

function Module:OnEnteringWorld()
    self:UpdateDelves()
    self:UpdateGilded()
end

function Module:CURRENCY_DISPLAY_UPDATE(_, currencyId)
    -- Gilded Undermine Crest
    if currencyId == 3290 then
        C_Timer.After(2, function() self:UpdateGilded() end)
    end
end

function Module:UpdateDelves()
    local delves = WWTCSaved.delves
    wipe(delves)

    for _, zone in ipairs(self.db.zones) do
        for _, poi in ipairs(zone.pois) do
            local poiInfo = CAPI_GetAreaPOIInfo(zone.uiMapId, poi.active)
            -- already completed = shows as a normal delve
            if poiInfo == nil and CQL_IsQuestFlaggedCompleted(poi.quest) then
                poiInfo = CAPI_GetAreaPOIInfo(zone.uiMapId, poi.inactive)
            end

            if poiInfo ~= nil and poiInfo.tooltipWidgetSet ~= nil then
                local widgets = CUIWM_GetAllWidgetsBySetID(poiInfo.tooltipWidgetSet)
                for _, widget in ipairs(widgets or {}) do
                    if widget.widgetType == Enum.UIWidgetVisualizationType.TextWithState then
                        local widgetInfo = CUIWM_GetTextWithStateWidgetVisualizationInfo(widget.widgetID)
                        if widgetInfo ~= nil and widgetInfo.text ~= nil then
                            -- Story Variant: |cnWHITE_FONT_COLOR:Ritual Interrupted
                            local parts = { strsplit(':', widgetInfo.text) }
                            if #parts == 3 then
                                tinsert(delves, table.concat({
                                    Addon.charData.dailyReset,
                                    poi.active,
                                    parts[3]
                                }, ':'))
                            end
                        end
                    end
                end
            end
        end
    end

    if #delves == 0 then
        tinsert(delves, '')
    end
end

function Module:UpdateGilded()
    local visInfo = CUIWM_GetSpellDisplayVisualizationInfo(7591)
    if visInfo ~= nil and visInfo.spellInfo ~= nil and visInfo.spellInfo.tooltip ~= nil then
        local gilded = strmatch(visInfo.spellInfo.tooltip, '(%d)/4') or '0'
        Addon.charData.delvesGilded = tonumber(gilded)
    end
end
