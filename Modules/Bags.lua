local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Bags')


local C_Container_ContainerIDToInventoryID = C_Container.ContainerIDToInventoryID
local C_Container_GetContainerItemID = C_Container.GetContainerItemID
local C_Container_GetContainerItemInfo = C_Container.GetContainerItemInfo
local C_Container_GetContainerNumSlots = C_Container.GetContainerNumSlots
local C_Item_IsItemDataCachedByID = C_Item.IsItemDataCachedByID
local C_Item_RequestLoadItemDataByID = C_Item.RequestLoadItemDataByID

function Module:OnEnable()
    Addon.charData.bags = Addon.charData.bags or {}
    Addon.charData.items = Addon.charData.items or {}

    self.isBankOpen = false
    self.isRequesting = false
    self.isScanning = false
    self.wasReagentBankChanged = false
    self.dirtyBags = {}
    self.requested = {}

    self:RegisterEvent('BAG_UPDATE')
    self:RegisterEvent('BANKFRAME_CLOSED')
    self:RegisterEvent('BANKFRAME_OPENED')
    self:RegisterEvent('ITEM_LOCKED')
    self:RegisterEvent('ITEM_UNLOCKED')
    self:RegisterEvent('PLAYERREAGENTBANKSLOTS_CHANGED')

    self:RegisterBucketEvent({ 'BAG_UPDATE_DELAYED' }, 1, 'UpdateBags')
    self:RegisterBucketEvent({ 'ITEM_DATA_LOAD_RESULT' }, 2, 'UpdateRequested')
end

function Module:OnEnteringWorld()
    C_Timer.After(5, function() self:SetPlayerBagsDirty() end)
end

function Module:BAG_UPDATE(_, bagId)
    self.dirtyBags[bagId] = true
end

function Module:BANKFRAME_CLOSED()
    self.isBankOpen = false
end

-- Mark bank and bank bags for scanning
function Module:BANKFRAME_OPENED()
    self.isBankOpen = true
    self.dirtyBags[Enum.BagIndex.Bank] = true
    self.dirtyBags[Enum.BagIndex.Reagentbank] = true
    for i = Enum.BagIndex.BankBag_1, Enum.BagIndex.BankBag_7 do
        self.dirtyBags[i] = true
    end

    self:StartUpdateBagsTimer()
end

function Module:ITEM_LOCKED(_, bag, slot)
    if slot ~= nil then
        self.dirtyBags[bag] = true
        self:StartUpdateBagsTimer()
    end
end

function Module:ITEM_UNLOCKED(_, bag, slot)
    if slot ~= nil then
        self.dirtyBags[bag] = true
        self:StartUpdateBagsTimer()
    end
end

function Module:PLAYERREAGENTBANKSLOTS_CHANGED()
    self.wasReagentBankChanged = true
    self.dirtyBags[Enum.BagIndex.Reagentbank] = true

    self:StartUpdateBagsTimer()
end

function Module:SetPlayerBagsDirty()
    for i = 0, NUM_TOTAL_BAG_FRAMES do
        self.dirtyBags[i] = true
    end

    self:StartUpdateBagsTimer()
end

function Module:StartUpdateBagsTimer()
    self:UniqueTimer('UpdateBags', 2, 'UpdateBags')
end

function Module:UpdateRequested(items)
    if not self.isRequesting then return end

    for itemId, _ in pairs(items) do
        self.requested[itemId] = nil
    end

    local keys = Addon:TableKeys(self.requested)
    if #keys == 0 then
        self.isRequesting = false
        self:StartUpdateBagsTimer()
    end
end

function Module:UpdateBags()
    if self.isRequesting or self.isScanning then
        return
    end

    self.isScanning = true
    self.scanQueue = {}
    for bagId, _ in pairs(self.dirtyBags) do
        tinsert(self.scanQueue, bagId)
        self.dirtyBags[bagId] = nil
    end

    C_Timer.After(0, function() self:ScanBagQueue() end)
end

function Module:ScanBagQueue()
    local bagId = tremove(self.scanQueue)
    if bagId == nil then
        self.isScanning = false
        return
    end

    -- Short circuit if bank isn't open
    local isBank = (
        bagId == Enum.BagIndex.Bank or
        bagId == Enum.BagIndex.Reagentbank or
        (bagId >= Enum.BagIndex.BankBag_1 and bagId <= Enum.BagIndex.BankBag_7)
    )
    local scan = true

    if isBank and not self.isBankOpen then
        scan = false
    end
    -- Reagent bank is weird, make sure that the bank is open or it was actually updated
    if bagId == Enum.BagIndex.Reagentbank then
        if not (self.isBankOpen or self.wasReagentBankChanged) then
            scan = false
        end
        self.wasReagentBankChanged = false
    end

    local requestedData = false
    if scan then
        local now = time()

        if isBank then
            Addon.charData.scanTimes["bank"] = now
        else
            Addon.charData.scanTimes["bags"] = now
        end

        Addon.charData.items["b"..bagId] = {}
        local bag = Addon.charData.items["b"..bagId]

        -- Update bag ID
        if bagId >= 1 then
            local bagItemID, _ = GetInventoryItemID('player', C_Container_ContainerIDToInventoryID(bagId))
            Addon.charData.bags["b"..bagId] = bagItemID
        end

        local numSlots = C_Container_GetContainerNumSlots(bagId)
        if numSlots > 0 then
            for slot = 1, numSlots do
                -- This always works, even if the full item data isn't cached
                local itemId = C_Container_GetContainerItemID(bagId, slot)
                if itemId then
                    if C_Item_IsItemDataCachedByID(itemId) then
                        local itemInfo = C_Container_GetContainerItemInfo(bagId, slot)
                        if itemInfo ~= nil and itemInfo.hyperlink ~= nil then
                            local parsed = Addon:ParseItemLink(itemInfo.hyperlink, itemInfo.quality or -1, itemInfo.stackCount or 1)
                            bag["s"..slot] = parsed
                        end
                    elseif self.requested[itemId] == nil then
                        requestedData = true
                        self.requested[itemId] = true
                        C_Item_RequestLoadItemDataByID(itemId)
                    end
                end
            end
        end
    end

    -- If we requested item data, come back and scan this bag again later
    if requestedData then
        self.dirtyBags[bagId] = true
        self.isRequesting = true
    end

    -- If the scan queue still has bags, add a timer for the next one
    if #self.scanQueue > 0 then
        C_Timer.After(0, function() self:ScanBagQueue() end)
    else
        self.isScanning = false

        -- Queue another scan if any bags are dirty
        local bagKeys = Addon:TableKeys(self.dirtyBags)
        if #bagKeys > 0 then
            self:StartUpdateBagsTimer()
        end
    end
end
