local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Delves')


local CUIWM_GetSpellDisplayVisualizationInfo = C_UIWidgetManager.GetSpellDisplayVisualizationInfo

function Module:OnEnable()
    Addon.charData.delvesGilded = Addon.charData.delvesGilded or 0

    self:RegisterEvent('CURRENCY_DISPLAY_UPDATE')
end

function Module:OnEnteringWorld()
    self:UpdateGilded()
end

function Module:CURRENCY_DISPLAY_UPDATE(_, currencyId)
    -- Gilded Undermine Crest
    if currencyId == 3290 then
        C_Timer.After(2, function() self:UpdateGilded() end)
    end
end

function Module:UpdateGilded()
    local visInfo = CUIWM_GetSpellDisplayVisualizationInfo(7591)
    if visInfo ~= nil and visInfo.spellInfo ~= nil and visInfo.spellInfo.tooltip ~= nil then
        local gilded = strmatch(visInfo.spellInfo.tooltip, '(%d)/4') or '0'
        Addon.charData.delvesGilded = tonumber(gilded)
    end
end
