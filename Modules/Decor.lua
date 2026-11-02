local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Decor')


local CHC_GetCatalogEntryInfoByRecordID = C_HousingCatalog.GetCatalogEntryInfoByRecordID
local EntryType_Decor = Enum.HousingCatalogEntryType.Decor
local EntryType_Room = Enum.HousingCatalogEntryType.Room

local MAX_DECOR_IDS = {
    [EntryType_Decor] = 40000,
    [EntryType_Room] = 1000,
}

local CHUNK_SIZE = 100

function Module:OnEnable()
    WWTCSaved.decor = WWTCSaved.decor or {}

    self.decor = {}
    self.searching = false

    self:RegisterBucketEvent(
        { 'HOUSING_STORAGE_UPDATED', 'HOUSING_STORAGE_ENTRY_UPDATED' },
        5,
        'UpdateDecor'
    )
end

function Module:UpdateDecor()
    if self.searching then return end

    self.searching = true
    
    local decor = WWTCSaved.decor
    local workload = {}
    for entryType, maxId in pairs(MAX_DECOR_IDS) do
        for chunkIndex = 1, maxId, CHUNK_SIZE do
            tinsert(workload, function()
                -- local startTime = debugprofilestop()
                for recordID = chunkIndex, chunkIndex + CHUNK_SIZE - 1 do
                    local entryInfo = CHC_GetCatalogEntryInfoByRecordID(entryType, recordID)
                    if entryInfo ~= nil then
                        local available = (entryInfo.totalNumStored or 0) + (entryInfo.remainingRedeemable or 0)
                        local dataString = available..';'..entryInfo.totalNumPlaced

                        if entryType == EntryType_Room then
                            decor[1000000 + recordID] = dataString
                        else
                            decor[recordID] = dataString
                        end
                    end
                end
                -- print('decor '..entryType..' '..chunkIndex..' '..(debugprofilestop() - startTime))
            end)
        end
    end

    Addon:QueueWorkload(workload, function()
        self.searching = false
        WWTCSaved.scanTimes.decor = time()
    end)
end
