local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Housing')


local MODE_IDLE = 0
local MODE_HOUSES = 1
local MODE_SCAN1 = 2
local MODE_SCAN2 = 3

function Module:OnEnable()
    WWTCSaved.houses = WWTCSaved.houses or {}

    self.houseCount = 0
    self.houses = {}
    self.mode = MODE_IDLE
    self.originalHouse = nil
    self.scanningHouse = nil

    -- I see that we forgot about our I before E except after C
    -- self:RegisterEvent('HOUSE_FINDER_NEIGHBORHOOD_DATA_RECIEVED')
    self:RegisterEvent('NEIGHBORHOOD_INITIATIVE_UPDATED')
    self:RegisterEvent('PLAYER_HOUSE_LIST_UPDATED')
end

function Module:OnEnteringWorld()
    if C_Housing.HasHousingExpansionAccess() then
        self.mode = MODE_HOUSES
        self.originalHouse = C_NeighborhoodInitiative.GetActiveNeighborhood()
        C_Housing.GetPlayerOwnedHouses()
    end
end

-- triggered by GetPlayerOwnedHouses
function Module:PLAYER_HOUSE_LIST_UPDATED(_, houseInfos)
    if self.mode ~= MODE_HOUSES then return end

    wipe(WWTCSaved.houses)
    wipe(self.houses)

    self.houseCount = #houseInfos
    for _, houseInfo in ipairs(houseInfos) do
        self.houses[houseInfo.neighborhoodGUID] = houseInfo
    end

    if #houseInfos > 0 then
        self.mode = MODE_SCAN1
        self.scanningHouse = C_NeighborhoodInitiative.GetActiveNeighborhood()
        C_NeighborhoodInitiative.RequestNeighborhoodInitiativeInfo()
    end
end

-- triggered by RequestNeighborhoodInitiativeInfo
function Module:NEIGHBORHOOD_INITIATIVE_UPDATED()
    if self.mode ~= MODE_SCAN1 and self.mode ~= MODE_SCAN2 then return end

    local info = C_NeighborhoodInitiative.GetNeighborhoodInitiativeInfo()
    if info.neighborhoodGUID ~= self.scanningHouse then return end

    local house = self.houses[info.neighborhoodGUID]
    tinsert(WWTCSaved.houses, table.concat({
        info.neighborhoodGUID,
        house.neighborhoodName,
        house.plotID,
        house.houseName,
        info.initiativeID,
        info.duration,
        info.progressRequired,
        math.floor(info.currentProgress or 0),
        math.floor(info.playerTotalContribution or 0)
    }, ':'))

    if self.mode == MODE_SCAN1 and self.houseCount == 2 then
        for _, house in pairs(self.houses) do
            if house.neighborhoodGUID ~= self.scanningHouse then
                self.mode = MODE_SCAN2
                self.scanningHouse = house.neighborhoodGUID

                C_NeighborhoodInitiative.SetViewingNeighborhood(house.neighborhoodGUID)
                C_NeighborhoodInitiative.RequestNeighborhoodInitiativeInfo()

                break
            end
        end
    else
        self.mode = MODE_IDLE
        WWTCSaved.scanTimes.housing = time()

        if #WWTCSaved.houses == 0 then
            tinsert(WWTCSaved.houses, "")
        end

        if self.originalHouse ~= nil and self.scanningHouse ~= self.originalHouse then
            C_NeighborhoodInitiative.SetViewingNeighborhood(self.originalHouse)
        end
    end
end
