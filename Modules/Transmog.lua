local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Transmog')


Module.db = {}

local CTC_GetAllAppearanceSources = C_TransmogCollection.GetAllAppearanceSources
local CTC_GetAppearanceInfoBySource = C_TransmogCollection.GetAppearanceInfoBySource
local CTC_PlayerKnowsSource = C_TransmogCollection.PlayerKnowsSource

local MAX_APPEARANCE_ID = 100000 -- actually 94162 currently
local CHUNK_SIZE = 20

function Module:OnEnable()
    self.isScanning = false
    self.modifiedAppearances = {}
    self.transmog = {}
    self.transmogSlots = {}
    self.transmogLocation = TransmogUtil.GetTransmogLocation('HEADSLOT', Enum.TransmogType.Appearance, Enum.TransmogModification.Main)
 
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
            C_Timer.After(10, function() self:UpdateTransmog() end)
        end
    }

    if WWTCSaved.transmogSourcesSquishV2 ~= nil then
        if type(WWTCSaved.transmogSourcesSquishV2) ~= 'string' then
            WWTCSaved.transmogSourcesSquishV2 = ''
        end

        local modifiedAppearanceIds = Addon:DeltaDecode(WWTCSaved.transmogSourcesSquishV2)
        local temp = {}
        for _, modifiedApperanceId in ipairs(modifiedAppearanceIds) do
            temp[modifiedApperanceId] = true
        end
        self.modifiedAppearances = temp
    else
        WWTCSaved.transmogSourcesSquishV2 = ''
    end

    Addon:QueueWorkload(workload)
end

function Module:TRANSMOG_COLLECTION_SOURCE_ADDED(_, sourceId)
    self.modifiedAppearances[sourceId] = true

    local info = CTC_GetAppearanceInfoBySource(sourceId)
    if info ~= nil then
        self.transmog[info.appearanceID] = true
    end

    -- print('Added item '..sourceInfo.itemID..'/'..sourceInfo.itemModID..' with appearance '..info.appearanceID)

    self:UniqueTimer('SaveTransmog', 2, 'SaveTransmog')
end

function Module:TRANSMOG_COLLECTION_SOURCE_REMOVED(_, sourceId)
    self.modifiedAppearances[sourceId] = nil

    -- This appearance may be completely uncollected now, wipe it out if so
    local info = CTC_GetAppearanceInfoBySource(sourceId)
    if info ~= nil and info.appearanceIsCollected == false then
        self.transmog[info.appearanceID] = nil
    end

    -- print('Removed item '..sourceInfo.itemID..'/'..sourceInfo.itemModID..' with appearance '..info.appearanceID)

    self:UniqueTimer('SaveTransmog', 2, 'SaveTransmog')
end

function Module:UpdateTransmog()
    if self.isScanning then return end

    -- Only do a full scan once per client build
    local _, currentBuild = GetBuildInfo()
    if currentBuild == WWTCSaved.transmogScanBuild then return end

    print('|cFF00FFFFWoWthing_Collector|r Scanning all available transmog for build #'..currentBuild)

    Addon.charData.scanTimes["transmog"] = time()
    self.isScanning = true

    local modifiedAppearances = self.modifiedAppearances
    local transmog = self.transmog
    wipe(transmog)

    -- local startTime = debugprofilestop()
    local workload = {}
    for chunkIndex = 1, MAX_APPEARANCE_ID, CHUNK_SIZE do
        table.insert(workload, function()
            -- local startTime = debugprofilestop()
            for appearanceId = chunkIndex, chunkIndex + CHUNK_SIZE - 1 do
                local sourceIds = CTC_GetAllAppearanceSources(appearanceId)
                if sourceIds then
                    for _, sourceId in ipairs(sourceIds) do
                        if modifiedAppearances[sourceId] ~= true then
                            local isCollected = CTC_PlayerKnowsSource(sourceId)
                            if isCollected then
                                modifiedAppearances[sourceId] = true
                                transmog[appearanceId] = true
                            end
                        else
                            transmog[appearanceId] = true
                        end
                    end
                end
            end
            -- print('transmog '..(debugprofilestop() - startTime))
        end)
    end

    Addon:QueueWorkload(workload, function()
        Module:ScanEnd()
        WWTCSaved.transmogScanBuild = currentBuild
        -- print(debugprofilestop() - startTime)
    end)
end

function Module:ScanEnd()
    self.isScanning = false

    self:SaveTransmog()
end

function Module:SaveTransmog()
    if self.isScanning then return end

    local appearanceIds = Addon:TableKeys(self.transmog)
    wipe(self.transmog)
    table.sort(appearanceIds)

    Addon:DeltaEncode(appearanceIds, function(output)
        Addon.charData.transmogSquish = output
    end)

    local modifiedAppearanceIds = Addon:TableKeys(self.modifiedAppearances)
    table.sort(modifiedAppearanceIds)

    Addon:DeltaEncode(modifiedAppearanceIds, function(output)
        WWTCSaved.scanTimes['transmog'] = time()
        WWTCSaved.transmogSourcesSquishV2 = output
    end)
end
