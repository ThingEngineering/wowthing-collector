local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Bags')


function Module:OnEnable()
    Addon.charData.bags = Addon.charData.bags or {}
    Addon.charData.items = Addon.charData.items or {}

    self.isBankOpen = false
    self.isScanning = false
    self.wasReagentBankChanged = false
    self.scanBags = {}

    self:RegisterEvent('BAG_UPDATE')
    self:RegisterEvent('BANKFRAME_CLOSED')
    self:RegisterEvent('BANKFRAME_OPENED')
    self:RegisterEvent('PLAYERREAGENTBANKSLOTS_CHANGED')

    self:RegisterBucketEvent({ 'BAG_UPDATE_DELAYED' }, 1, 'UpdateBags')
    self:RegisterBucketMessage({ 'WWTC_SCAN_BAGS' }, 1, 'UpdateBags')
end

function Module:BAG_UPDATE(_, bagId)
    self.scanBags[bagId] = true
end

function Module:BANKFRAME_CLOSED()
    self.isBankOpen = false
end

-- Mark bank and bank bags for scanning
function Module:BANKFRAME_OPENED()
    self.isBankOpen = true
    self.scanBags[Enum.BagIndex.Bank] = true
    self.scanBags[Enum.BagIndex.Reagentbank] = true
    for i = Enum.BagIndex.BankBag_1, Enum.BagIndex.BankBag_7 do
        self.scanBags[i] = true
    end

    self:SendMessage('WWTC_SCAN_BAGS')
end

function Module:PLAYERREAGENTBANKSLOTS_CHANGED()
    self.scanBags[Enum.BagIndex.Reagentbank] = true
    self.wasReagentBankChanged = false
end

function Module:UpdateBags()
    print('gday')

    if self.isScanning then return end

    self.isScanning = true
    self.scanQueue = {}
    for bagId, _ in pairs(self.scanBags) do
        tinsert(self.scanQueue, bagId)
        self.scanBags[bagId] = nil
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
            local bagItemID, _ = GetInventoryItemID('player', C_Container.ContainerIDToInventoryID(bagId))
            Addon.charData.bags["b"..bagId] = bagItemID
        end

        local numSlots = C_Container.GetContainerNumSlots(bagId)
        if numSlots > 0 then
            for slot = 1, numSlots do
                -- This always works, even if the full item data isn't cached
                local itemId = C_Container.GetContainerItemID(bagId, slot)
                if itemId then
                    if C_Item.IsItemDataCachedByID(itemId) then
                        local itemInfo = C_Container.GetContainerItemInfo(bagId, slot)
                        if itemInfo ~= nil and itemInfo.hyperlink ~= nil then
                            local parsed = Addon:ParseItemLink(itemInfo.hyperlink, itemInfo.quality or -1, itemInfo.stackCount or 1)
                            bag["s"..slot] = parsed
                        end
                    else
                        C_Item.RequestLoadItemDataByID(itemId)
                        requestedData = true
                    end
                end
            end
        end
    end

    -- If we requested item data, come back and scan this bag again later
    if requestedData then
        self.scanBags[bagId] = true
    end

    -- If the scan queue still has bags, add a timer for the next one
    if #self.scanQueue > 0 then
        C_Timer.After(0, function() self:ScanBagQueue() end)
    else
        self.isScanning = false

        -- Queue another scan if any bags are dirty
        local bagKeys = Addon:TableKeys(self.scanBags)
        if #bagKeys > 0 then
            self:SendMessage('WWTC_SCAN_BAGS')
        end
    end
end
