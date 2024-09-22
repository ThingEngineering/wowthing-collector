local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('ProfessionEquipment')


local C_Item_IsItemDataCachedByID = C_Item.IsItemDataCachedByID
local C_Item_RequestLoadItemDataByID = C_Item.RequestLoadItemDataByID

function Module:OnEnable()
    self:RegisterBucketEvent({
        'ENCHANT_SPELL_COMPLETED',
        'PLAYER_EQUIPMENT_CHANGED',
        'PROFESSION_EQUIPMENT_CHANGED',
        'SOCKET_INFO_SUCCESS',
    }, 2, 'UpdateEquipment')
end

function Module:OnEnteringWorld()
    self:UpdateEquipment()
end

function Module:UpdateEquipment()
    Addon.charData.equipmentV2 = {}

    local rescan = false

    for slot = 1, 30 do
        local itemId = GetInventoryItemID('player', slot)
        if itemId ~= nil then
            if C_Item_IsItemDataCachedByID(itemId) then
                local itemLink = GetInventoryItemLink('player', slot)
                local itemQuality = GetInventoryItemQuality('player', slot)
                local parsed = Addon:ParseItemLink(itemLink, itemQuality or -1, 1)
                Addon.charData.equipmentV2["s" .. slot] = parsed
            else
                C_Item_RequestLoadItemDataByID(itemId)
                rescan = true
            end
        else
            Addon.charData.equipmentV2["s" .. slot] = nil
        end
    end

    if rescan then
        self:UniqueTimer('UpdateEquipment', 2, 'UpdateEquipment')
    end
end
