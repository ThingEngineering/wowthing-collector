local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('ProfessionEquipment')


local CI_IsItemDataCachedByID = C_Item.IsItemDataCachedByID
local CI_RequestLoadItemDataByID = C_Item.RequestLoadItemDataByID
local CIU_GetHighWatermarkForSlot = C_ItemUpgrade.GetHighWatermarkForSlot

function Module:OnEnable()
    Addon.charData.equipmentV2 = Addon.charData.equipmentV2 or {}
    Addon.charData.highestItemLevel = Addon.charData.highestItemLevel or {}

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
    WWTCSaved.scanTimes.equipment = time()

    local equipmentV2 = Addon.charData.equipmentV2
    local highestItemLevel = Addon.charData.highestItemLevel
    wipe(equipmentV2)
    wipe(highestItemLevel)

    -- Enum.ItemRedundancySlot
    for slot = 0, 16 do
        local characterHigh = CIU_GetHighWatermarkForSlot(slot)
        tinsert(highestItemLevel, table.concat({
            slot,
            characterHigh or 0
        }, ':'))
    end

    local rescan = false
    for slot = 1, 30 do
        local itemId = GetInventoryItemID('player', slot)
        if itemId ~= nil then
            if CI_IsItemDataCachedByID(itemId) then
                local itemLink = GetInventoryItemLink('player', slot)
                local itemQuality = GetInventoryItemQuality('player', slot)
                local parsed = Addon:ParseItemLink(itemLink, itemQuality or -1, 1, 1)
                equipmentV2["s" .. slot] = parsed
            else
                CI_RequestLoadItemDataByID(itemId)
                rescan = true
            end
        end
    end

    if rescan then
        self:UniqueTimer('UpdateEquipment', 2, 'UpdateEquipment')
    end
end
