local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Transmog')


Module.db = {}

local C_TransmogCollection_GetAllAppearanceSources = C_TransmogCollection.GetAllAppearanceSources
local C_TransmogCollection_GetAppearanceInfoBySource = C_TransmogCollection.GetAppearanceInfoBySource
local C_TransmogCollection_GetSourceInfo = C_TransmogCollection.GetSourceInfo

local MAX_APPEARANCE_ID = 100000 -- actually 94162 currently

function Module:OnEnable()
    self.isScanning = false
    self.sources = {}
    self.transmog = {}
    self.transmogSlots = {}
    self.transmogLocation = TransmogUtil.GetTransmogLocation('HEADSLOT', Enum.TransmogType.Appearance, Enum.TransmogModification.Main)

    setmetatable(Module.sources, {
        __index = function(t, k)
            t[k] = {}
            return t[k]
        end })

    for categoryID = 1, 29 do
        local slot = CollectionWardrobeUtil.GetSlotFromCategoryID(categoryID)
        if slot ~= nil then
            self.transmogSlots[categoryID] = slot
        end
    end

    self:RegisterEvent('LOADING_SCREEN_DISABLED')
    self:RegisterEvent('TRANSMOG_COLLECTION_SOURCE_ADDED')
    self:RegisterEvent('TRANSMOG_COLLECTION_SOURCE_REMOVED')
end

-- function Module:OnEnteringWorld()
--     self:UpdateTransmog()
-- end

function Module:LOADING_SCREEN_DISABLED()
    self:UnregisterEvent('LOADING_SCREEN_DISABLED')

    local workload = {
        function()
            C_Timer.After(5, function() self:UpdateTransmog() end)
        end
    }

    if WWTCSaved.transmogSourcesSquish ~= nil then
        
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
    else
        WWTCSaved.transmogSourcesSquish = {}
    end

    Addon:BatchWork(workload)
end

function Module:TRANSMOG_COLLECTION_SOURCE_ADDED(_, sourceId)
    local sourceInfo = C_TransmogCollection_GetSourceInfo(sourceId)
    self.sources[sourceInfo.itemModID][sourceInfo.itemID] = true

    local info = C_TransmogCollection_GetAppearanceInfoBySource(sourceId)
    if info ~= nil then
        self.transmog[info.appearanceID] = true
    end

    -- print('Added item '..sourceInfo.itemID..'/'..sourceInfo.itemModID..' with appearance '..info.appearanceID)

    self:UniqueTimer('SaveTransmog', 2, 'SaveTransmog')
end

function Module:TRANSMOG_COLLECTION_SOURCE_REMOVED(_, sourceId)
    local sourceInfo = C_TransmogCollection_GetSourceInfo(sourceId)
    self.sources[sourceInfo.itemModID][sourceInfo.itemID] = nil

    -- This appearance may be completely uncollected now, wipe it out if so
    local info = C_TransmogCollection_GetAppearanceInfoBySource(sourceId)
    if info ~= nil and info.appearanceIsCollected == false then
        self.transmog[info.appearanceID] = nil
    end

    -- print('Removed item '..sourceInfo.itemID..'/'..sourceInfo.itemModID..' with appearance '..info.appearanceID)

    self:UniqueTimer('SaveTransmog', 2, 'SaveTransmog')
end

function Module:UpdateTransmog()
    if self.isScanning then return end

    Addon.charData.scanTimes["transmog"] = time()
    self.isScanning = true

    local sources = self.sources
    local transmog = self.transmog
    wipe(transmog)

    -- Manual checks for buggy appearances
    for _, manualTransmog in ipairs(self.db.manual) do
        local have = C_TransmogCollection.PlayerHasTransmog(manualTransmog.itemId, manualTransmog.modifierId)
        if have then
            transmog[manualTransmog.appearanceId] = true
            sources[manualTransmog.modifierId][manualTransmog.itemId] = true
        end
    end

    local workload = {}
    -- 200 is a completely arbitrary chunk size, idk
    for chunkIndex = 1, MAX_APPEARANCE_ID, 200 do
        table.insert(workload, function()
            -- local startTime = debugprofilestop()
            for appearanceId = chunkIndex, chunkIndex + 199 do
                local sourceIds = C_TransmogCollection_GetAllAppearanceSources(appearanceId)
                if sourceIds then
                    for _, sourceId in ipairs(sourceIds) do
                        local sourceInfo = C_TransmogCollection_GetSourceInfo(sourceId)
                        if sourceInfo.isCollected then
                            transmog[sourceInfo.visualID] = true
                            sources[sourceInfo.itemModID][sourceInfo.itemID] = true
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
    self.isScanning = false

    self:SaveTransmog()
end

function Module:SaveTransmog()
    if self.isScanning then return end

    local appearanceIds = Addon:TableKeys(self.transmog)
    table.sort(appearanceIds)

    Addon:DeltaEncode(appearanceIds, function(output)
        Addon.charData.transmogSquish = output
    end)

    wipe(WWTCSaved.transmogSourcesSquish)
    for modifier, itemIdTable in pairs(self.sources) do
        local itemIds = Addon:TableKeys(itemIdTable)
        sort(itemIds)
        Addon:DeltaEncode(itemIds, function(output)
            WWTCSaved.transmogSourcesSquish['m' .. modifier] = output
        end)
    end
end
