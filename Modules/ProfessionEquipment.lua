local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('ProfessionEquipment')


function Module:OnEnable()
    self:RegisterEvent('PROFESSION_EQUIPMENT_CHANGED', 'UpdateEquipment')
end

function Module:OnEnteringWorld()
    self:UpdateEquipment()
end

function Module:UpdateEquipment()
    Addon.charData.equipment = {}

    for slot = 20, 30 do
        local itemLink = GetInventoryItemLink('player', slot)

        if itemLink ~= nil then
            local itemQuality = GetInventoryItemQuality('player', slot)
            -- Item isn't loaded yet, try again in a bit
            if itemQuality == nil then
                C_Timer.After(2, function() self:UpdateEquipment() end)
            else
                Addon.charData.equipment[slot] = Addon:ParseItemLink(itemLink, itemQuality, 1)
            end
        end
    end
end
