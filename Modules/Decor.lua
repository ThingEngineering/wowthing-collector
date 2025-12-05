local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Decor')


local MAX_DECOR_ID = 20000 -- 17740

function Module:OnEnable()
    WWTCSaved.decor = WWTCSaved.decor or {}

    self.searching = false

    self:RegisterEvent('LOADING_SCREEN_DISABLED')
    self:RegisterEvent('HOUSING_STORAGE_UPDATED', 'UpdateDecor')
    self:RegisterEvent('HOUSING_STORAGE_ENTRY_UPDATED')
end

function Module:LOADING_SCREEN_DISABLED()
    self:UnregisterEvent('LOADING_SCREEN_DISABLED')

    local catalogSearcher = C_HousingCatalog.CreateCatalogSearcher()

    catalogSearcher:SetResultsUpdatedCallback(function() self:OnEntryResultsUpdated() end)

    catalogSearcher:SetEditorModeContext(Enum.HouseEditorMode.BasicDecor)
	catalogSearcher:SetAllowedIndoors(true)
	catalogSearcher:SetAllowedOutdoors(true)
    catalogSearcher:SetAutoUpdateOnParamChanges(false)
    catalogSearcher:SetCollected(true)
    catalogSearcher:SetCustomizableOnly(false)
    catalogSearcher:SetFirstAcquisitionBonusOnly(false)
    catalogSearcher:SetIncludeMarketEntries(true)
    catalogSearcher:SetUncollected(true)

    self.catalogSearcher = catalogSearcher
end

function Module:HOUSING_STORAGE_ENTRY_UPDATED(_, entryId)
    -- TODO: this should probably do something other than a full rescan
    self:UpdateDecor()
end

function Module:UpdateDecor()
    if not self.searching then
        self.searching = true
        self.catalogSearcher:RunSearch()
    end
end

function Module:OnEntryResultsUpdated()
    local decor = WWTCSaved.decor

    -- { recordID, subtypeIdentifier, entrySubtype, entryType }[]
    local entries = self.catalogSearcher:GetCatalogSearchResults()
    for _, entry in ipairs(entries) do
        local entryInfo = C_HousingCatalog.GetCatalogEntryInfo(entry)
        if entryInfo ~= nil then
            decor[entryInfo.entryID.recordID] = entryInfo.numStored..';'..entryInfo.numPlaced
        end
    end

    -- print('Found '..#decor..' decors')

    self.searching = false
    WWTCSaved.scanTimes.decor = time()
end
