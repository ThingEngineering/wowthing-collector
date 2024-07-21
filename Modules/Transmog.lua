local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Transmog')


Module.db = {}

local C_TransmogCollection_GetAllAppearanceSources = C_TransmogCollection.GetAllAppearanceSources
local C_TransmogCollection_GetCategoryAppearances = C_TransmogCollection.GetCategoryAppearances
local C_TransmogCollection_GetSourceInfo = C_TransmogCollection.GetSourceInfo

function Module:OnEnable()
    self.isOpen = false
    self.isScanning = false
    self.allAppearances = {}
    self.sources = {}
    
    self.transmogLocation = TransmogUtil.GetTransmogLocation('HEADSLOT', Enum.TransmogType.Appearance, Enum.TransmogModification.Main)

    self.transmogSlots = {}
    for categoryID = 1, 29 do
        local slot = CollectionWardrobeUtil.GetSlotFromCategoryID(categoryID)
        if slot ~= nil then
            self.transmogSlots[categoryID] = slot
        end
    end

    self:RegisterEvent('LOADING_SCREEN_DISABLED')
    self:RegisterEvent('TRANSMOGRIFY_OPEN')
    self:RegisterEvent('TRANSMOGRIFY_CLOSE')
end

-- function Module:OnEnteringWorld()
--     self:UpdateTransmog()
-- end

function Module:LOADING_SCREEN_DISABLED()
    self:UnregisterEvent('LOADING_SCREEN_DISABLED')

    if WWTCSaved.transmogSourcesSquish ~= nil then
        local workload = {}
        
        for modifier, squished in pairs(WWTCSaved.transmogSourcesSquish) do
            tinsert(workload, function()
                local itemIds = Addon:DeltaDecode(squished)
                local temp = {}
                for _, itemId in ipairs(itemIds) do
                    temp[itemId] = true
                end
                self.sources[tonumber(strsub(modifier, 2))] = temp
            end)
        end

        Addon:BatchWork(workload)
    end

    C_Timer.After(5, function()
        self:UpdateTransmog()

        self:RegisterBucketEvent(
            {
                'TRANSMOG_COLLECTION_SOURCE_ADDED',
                'TRANSMOG_COLLECTION_SOURCE_REMOVED',
                -- 'TRANSMOG_COLLECTION_UPDATED',
            },
            2,
            'UpdateTransmog'
        )
    end)
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

            self.sources[manualTransmog.modifierId] = self.sources[manualTransmog.modifierId] or {}
            self.sources[manualTransmog.modifierId][manualTransmog.itemId] = true
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

                    local sourceIds = C_TransmogCollection_GetAllAppearanceSources(visualId) -- itemModifiedAppearenceID[]
                    for _, sourceId in ipairs(sourceIds or {}) do
                        local sourceInfo = C_TransmogCollection_GetSourceInfo(sourceId)
                        if sourceInfo.isCollected then
                            self.sources[sourceInfo.itemModID] = self.sources[sourceInfo.itemModID] or {}
                            self.sources[sourceInfo.itemModID][sourceInfo.itemID] = true
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
    local appearanceIds = Addon:TableKeys(self.transmog)
    table.sort(appearanceIds)

    self.isScanning = false
    self.transmog = {}

    Addon:DeltaEncode(appearanceIds, function(output)
        Addon.charData.transmogSquish = output
    end)

    WWTCSaved.transmogSourcesSquish = {}
    for modifier, itemIdTable in pairs(self.sources) do
        local itemIds = Addon:TableKeys(itemIdTable)
        sort(itemIds)
        Addon:DeltaEncode(itemIds, function(output)
            WWTCSaved.transmogSourcesSquish['m' .. modifier] = output
        end)
    end

    -- Reset settings
    if self.isOpen == false then
        C_TransmogCollection.SetCollectedShown(self.oldSettings.showCollected)
        C_TransmogCollection.SetUncollectedShown(self.oldSettings.showUncollected)
        for index = 1, 6 do
            C_TransmogCollection.SetSourceTypeFilter(index, self.oldSettings.sourceTypes[index])
        end
    end
end
