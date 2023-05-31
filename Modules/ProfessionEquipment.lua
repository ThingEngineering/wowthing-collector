local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('ProfessionEquipment')


function Module:OnEnable()
    self:RegisterBucketEvent({ 'PROFESSION_EQUIPMENT_CHANGED' }, 2, 'UpdateEquipment')
end

function Module:OnEnteringWorld()
    self:UpdateEquipment()
end

function Module:UpdateEquipment()
    Addon.charData.equipment = {}

    local rescan = false

    for slot = 20, 30 do
        local itemLink = GetInventoryItemLink('player', slot)
        if itemLink ~= nil then
            local name = C_Item.GetItemNameByID(itemLink)
            if name == nil then
                C_Item.RequestLoadItemDataByID(itemLink)
                rescan = true
            else
                local itemQuality = GetInventoryItemQuality('player', slot)
                Addon.charData.equipment[slot] = Addon:ParseItemLink(itemLink, itemQuality, 1)
            end
        end
    end

    if rescan then
        self:UniqueTimer('UpdateEquipment', 2, 'UpdateEquipment')
    end
end
