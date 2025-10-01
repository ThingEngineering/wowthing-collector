local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Transmog')


Module.db = {}

local CTC_GetAllAppearanceSources = C_TransmogCollection.GetAllAppearanceSources
local CTC_GetAppearanceInfoBySource = C_TransmogCollection.GetAppearanceInfoBySource
local CTC_GetAppearanceSourceInfo = C_TransmogCollection.GetAppearanceSourceInfo
local CTC_PlayerHasTransmogItemModifiedAppearance = C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance

local MAX_APPEARANCE_ID = 130000 -- 121732
local CHUNK_SIZE = 50

function Module:OnEnable()
    if IsPublicTestClient() or IsOnTournamentRealm() then
        Module:Disable()
        return
    end

    self.isScanning = false
    self.modifiedAppearances = {}
    self.sourceToAppearance = {}
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
    if IsPublicTestClient() or IsOnTournamentRealm() then
        Module:Disable()
        return
    end

    self:UnregisterEvent('LOADING_SCREEN_DISABLED')

    local workload = {
        function()
            C_Timer.After(10, function() self:UpdateTransmog() end)
        end
    }

    if WWTCSaved.transmogIdsSquish ~= nil then
        self.transmog = Addon:DeltaDecode(WWTCSaved.transmogIdsSquish)
    end

    if WWTCSaved.transmogSourcesSquishV2 ~= nil and WWTCSaved.fix_11_0_2_11_v2 then
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
        WWTCSaved.fix_11_0_2_11_v2 = true
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

function Module:UpdateTransmog(beMouthy)
    if self.isScanning then return end

    local lastScan = Addon.charData.scanTimes.transmog or 0
    if (time() - lastScan) < 43200 then return end

    self.isScanning = true

    -- local startTime = debugprofilestop()
    local workload = {}

    local sourceIndex = 1
    local sourceToAppearance = self.sourceToAppearance
    wipe(sourceToAppearance)

    for chunkIndex = 1, MAX_APPEARANCE_ID, CHUNK_SIZE do
        table.insert(workload, function()
            -- local startTime = debugprofilestop()
            for appearanceId = chunkIndex, chunkIndex + CHUNK_SIZE - 1 do
                local sourceIds = CTC_GetAllAppearanceSources(appearanceId)
                if sourceIds then
                    for _, sourceId in ipairs(sourceIds) do
                        sourceToAppearance[sourceIndex] = { sourceId, appearanceId }
                        sourceIndex = sourceIndex + 1
                    end
                end
            end
            -- print('transmog '..(debugprofilestop() - startTime))
        end)
    end

    Addon:QueueWorkload(workload, function()
        Module:ScanSources(beMouthy)
        -- print(debugprofilestop() - startTime)
    end)
end

function Module:ScanSources(beMouthy)
    -- local startTime = debugprofilestop()
    local workload = {}

    local sourceToAppearance = self.sourceToAppearance
    local modifiedAppearances = self.modifiedAppearances
    local transmog = self.transmog

    -- wipe the data if they're doing a manual scan
    if beMouthy then
        wipe(modifiedAppearances)
        wipe(transmog)
    end

    local sourceToAppearanceSize = #sourceToAppearance
    for chunkIndex = 1, sourceToAppearanceSize, CHUNK_SIZE do
        tinsert(workload, function()
            -- local startTime = debugprofilestop()
            for i = chunkIndex, min(sourceToAppearanceSize, chunkIndex + CHUNK_SIZE - 1) do
                local sourceId, appearanceId = unpack(sourceToAppearance[i])
                if modifiedAppearances[sourceId] ~= true then
                    -- This is accurate and _slow_ (35-45s scan)
                    -- local _, _, _, _, isCollected = CTC_GetAppearanceSourceInfo(sourceId)
                    -- This is very very wrong but it is fast I guess
                    -- local isCollected = CTC_PlayerKnowsSource(sourceId)
                    -- This is accurate and fast! (1.5s complete scan)
                    local isCollected = CTC_PlayerHasTransmogItemModifiedAppearance(sourceId)

                    if isCollected then
                        modifiedAppearances[sourceId] = true
                        transmog[appearanceId] = true
                    end
                else
                    transmog[appearanceId] = true
                end
            end
            -- print('transmog '..(debugprofilestop() - startTime))
        end)
    end
  
    Addon:QueueWorkload(workload, function()
        Module:ScanEnd(beMouthy)
        -- print(debugprofilestop() - startTime)
    end)
end

function Module:ScanEnd(beMouthy)
    self.isScanning = false

    self:SaveTransmog(beMouthy)
end

function Module:SaveTransmog(beMouthy)
    if self.isScanning then return end

    local appearanceIds = Addon:TableKeys(self.transmog)
    table.sort(appearanceIds)

    Addon:DeltaEncode(appearanceIds, function(output)
        WWTCSaved.transmogIdsSquish = output
    end)

    local modifiedAppearanceIds = Addon:TableKeys(self.modifiedAppearances)
    table.sort(modifiedAppearanceIds)

    Addon:DeltaEncode(modifiedAppearanceIds, function(output)
        WWTCSaved.transmogSourcesSquishV2 = output
    end)

    Addon.charData.scanTimes.transmog = time()

    if beMouthy == true then
        print('Found '..#appearanceIds..' appearance IDs and '..#modifiedAppearanceIds..' sources')
    end
end
