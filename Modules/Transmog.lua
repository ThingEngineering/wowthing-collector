local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Transmog')


Module.db = {}

local C_TransmogCollection_GetAppearanceSources = C_TransmogCollection.GetAppearanceSources
local C_TransmogCollection_GetCategoryAppearances = C_TransmogCollection.GetCategoryAppearances

function Module:OnEnable()
    self.isOpen = false
    self.isScanning = false

    self.transmogLocation = TransmogUtil.GetTransmogLocation('HEADSLOT', Enum.TransmogType.Appearance, Enum.TransmogModification.Main)

    self.allAppearances = {}
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
    C_Timer.After(0, function() self:ScanInitialize() end)
end

function Module:ScanInitialize()
    -- Manual checks for buggy appearances
    for _, manualTransmog in ipairs(self.db.manual) do
        local have = C_TransmogCollection.PlayerHasTransmog(manualTransmog.itemId, manualTransmog.modifierId)
        if have then
            self.transmog[manualTransmog.appearanceId] = true

            local sourceKey = string.format("%d_%d", manualTransmog.itemId, manualTransmog.modifierId)
            WWTCSaved.transmogSourcesV2[sourceKey] = true
        end
    end

    -- Load all appearance categories into chunks of 100 appearances
    self.allAppearances = { {} }

    local workload = { }
    for categoryID, _ in pairs(self.transmogSlots) do
        table.insert(workload, function()
            local appearances = C_TransmogCollection_GetCategoryAppearances(categoryID, self.transmogLocation)
            local currentTable = self.allAppearances[#self.allAppearances]
            for _, appearance in ipairs(appearances) do
                table.insert(currentTable, appearance)
                if #currentTable == 100 then
                    currentTable = {}
                    table.insert(self.allAppearances, currentTable)
                end
            end
        end)
    end

    Addon:BatchWork(workload, function() Module:ScanBegin() end)
end

function Module:ScanBegin()
    local workload = {}
    
    -- Scan all appearances
    for _, chunk in ipairs(self.allAppearances) do
        table.insert(workload, function()
            -- local startTime = debugprofilestop()
            for _, appearance in ipairs(chunk) do
                if appearance.isCollected then
                    local visualId = appearance.visualID
                    self.transmog[visualId] = true

                    local sources = C_TransmogCollection_GetAppearanceSources(visualId)--, categoryID, self.transmogLocation)
                    for _, source in ipairs(sources) do
                        if source.isCollected then
                            local sourceKey = string.format("%d_%d", source.itemID, source.itemModID)
                            WWTCSaved.transmogSourcesV2[sourceKey] = true
                        end
                    end
                end
            end
            -- print('chunk '..(debugprofilestop() - startTime))
        end)
    end

    Addon:BatchWork(workload, function() Module:ScanEnd() end)
end

function Module:ScanEnd()
    local keys = Addon:TableKeys(self.transmog)
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
