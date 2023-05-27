local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Transmog')


Module.db = {}

local C_TransmogCollection_GetAppearanceSources = C_TransmogCollection.GetAppearanceSources
local C_TransmogCollection_GetCategoryAppearances = C_TransmogCollection.GetCategoryAppearances

function Module:OnEnable()
    self.isOpen = false
    self.isScanning = false

    self.transmogLocation = TransmogUtil.GetTransmogLocation('HEADSLOT', Enum.TransmogType.Appearance, Enum.TransmogModification.Main)

    self.transmogSlots = {}
    for categoryID = 1, 29 do
        local slot = CollectionWardrobeUtil.GetSlotFromCategoryID(categoryID)
        if slot ~= nil then
            self.transmogSlots[categoryID] = slot
        end
    end

    self:RegisterEvent('TRANSMOGRIFY_OPEN')
    self:RegisterEvent('TRANSMOGRIFY_CLOSE')

    self:RegisterBucketEvent(
        {
            'TRANSMOG_COLLECTION_SOURCE_ADDED',
            'TRANSMOG_COLLECTION_SOURCE_REMOVED',
            'TRANSMOG_COLLECTION_UPDATED',
        },
        2,
        'UpdateTransmog'
    )
end

function Module:OnEnteringWorld()
    self:UpdateTransmog()
end

function Module:TRANSMOGRIFY_OPEN()
    self.isOpen = true
end

function Module:TRANSMOGRIFY_CLOSE()
    self.isOpen = false
end

function Module:UpdateTransmog()
    if self.isScanning then return end

    Addon.charData.scanTimes["transmog"] = time()
    self.isScanning = true
    self.scanQueue = {}
    self.transmog = {}

    -- Save current settings to reset later
    self.oldSettings = {}
    self.oldSettings.showCollected = C_TransmogCollection.GetCollectedShown()
    self.oldSettings.showUncollected = C_TransmogCollection.GetUncollectedShown()

    self.oldSettings.sourceTypes = {}
    for index = 1, 6 do
        self.oldSettings.sourceTypes[index] = C_TransmogCollection.IsSourceTypeFilterChecked(index)
    end
    
    if self.isOpen == false then
        C_TransmogCollection.SetAllCollectionTypeFilters(true)
        C_TransmogCollection.SetAllSourceTypeFilters(true)
    end

    -- Run this in a timer so that the filter changes take effect
    C_Timer.After(0, function()
        -- Manual checks
        for _, manualTransmog in ipairs(self.db.manual) do
            local have = C_TransmogCollection.PlayerHasTransmog(manualTransmog.itemId, manualTransmog.modifierId)
            if have then
                self.transmog[manualTransmog.appearanceId] = true

                local sourceKey = string.format("%d_%d", manualTransmog.itemId, manualTransmog.modifierId)
                WWTCSaved.transmogSourcesV2[sourceKey] = true
            end
        end

        for categoryID, _ in pairs(self.transmogSlots) do
            table.insert(self.scanQueue, categoryID)
        end

        self:ScanQueue()
    end)
end

function Module:ScanQueue()
    local categoryID = tremove(self.scanQueue)

    local appearances = C_TransmogCollection_GetCategoryAppearances(categoryID, self.transmogLocation)
    for _, appearance in pairs(appearances) do
        if appearance.isCollected then
            local visualId = appearance.visualID
            self.transmog[visualId] = true

            local sources = C_TransmogCollection_GetAppearanceSources(visualId, categoryID, self.transmogLocation)
            for _, source in ipairs(sources) do
                if source.isCollected then
                    local sourceKey = string.format("%d_%d", source.itemID, source.itemModID)
                    WWTCSaved.transmogSourcesV2[sourceKey] = true
                end
            end
        end
    end

    -- Still categories to scan, schedule next
    if #self.scanQueue > 0 then
        C_Timer.After(0, function() self:ScanQueue() end)
    -- All done
    else
        local keys = Addon:TableKeys(self.transmog)
        table.sort(keys)
        Addon.charData.transmog = table.concat(keys, ':')

        self.isScanning = false
        self.transmog = {}

        -- Reset settings
        if self.isOpen == false then
            C_TransmogCollection.SetCollectedShown(self.oldSettings.showCollected)
            C_TransmogCollection.SetUncollectedShown(self.oldSettings.showUncollected)
            for index = 1, 6 do
                C_TransmogCollection.SetSourceTypeFilter(index, self.oldSettings.sourceTypes[index])
            end
        end
    end
end
