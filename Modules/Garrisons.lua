local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Garrisons')


Module.db = {}

function Module:OnEnable()
    self:RegisterBucketEvent(
        {
            'ZONE_CHANGED',
            'ZONE_CHANGED_INDOORS',
            'ZONE_CHANGED_NEW_AREA',
        },
        1,
        'UpdateGarrisons'
    )

    self:RegisterBucketEvent(
        {
            'GARRISON_TALENT_COMPLETE',
            'GARRISON_TALENT_RESEARCH_STARTED',
            'GARRISON_TALENT_UPDATE',
        },
        1,
        'UpdateGarrisonTrees'
    )
end

function Module:OnEnteringWorld()
    self:UpdateGarrisons()
    self:UpdateGarrisonTrees()
end

function Module:UpdateGarrisons()
    Addon.charData.scanTimes["garrisons"] = time()

    for _, garrisonData in ipairs(self.db.garrisons) do
        if garrisonData.mustBeInGarrison == false or C_Garrison.IsPlayerInGarrison(garrisonData.type) then
            self:ScanGarrison(garrisonData)
        end
    end
end

function Module:ScanGarrison(garrisonData)
    local garrison
    for _, charGarrison in ipairs(Addon.charData.garrisons) do
        if charGarrison.type == garrisonData.type then
            garrison = charGarrison
            break
        end
    end

    if garrison == nil then
        garrison = {
            type = garrisonData.type
        }
        Addon.charData.garrisons[#Addon.charData.garrisons + 1] = garrison
    end

    garrison.scannedAt = time()

    local level, _ = C_Garrison.GetGarrisonInfo(garrisonData.type)
    garrison.level = level

    garrison.buildings = {}
    local buildings = C_Garrison.GetBuildings(garrisonData.type) or {}

    for _, building in ipairs(buildings) do
        -- id, name, textureKit, icon, description, rank, currencyID, currencyQty, goldQty,
        -- buildTime, needsPlan, isPrebuilt, possSpecs, upgrades, canUpgrade, isMaxLevel, hasFollowerSlot
        local _, name, _, _, _, rank = C_Garrison.GetBuildingInfo(building.buildingID)

        tinsert(garrison.buildings, {
            buildingId = building.buildingID,
            plotId = building.plotID,
            name = name,
            rank = rank,
        })
    end

    local treeIds = C_Garrison.GetTalentTreeIDsByClassID(garrisonData.type, Addon.charClassID)
    for _, treeId in ipairs(treeIds or {}) do
        self:ScanGarrisonTree(treeId)
    end
end

function Module:UpdateGarrisonTrees()
    Addon.charData.scanTimes["garrisonTrees"] = time()

    Addon.charData.garrisonTrees = {}
    for _, treeId in ipairs(self.db.trees) do
        self:ScanGarrisonTree(treeId)
    end
end

function Module:ScanGarrisonTree(treeId)
    local talentTree = C_Garrison.GetTalentTreeInfo(treeId)
    local talents = {}
    for _, talent in ipairs(talentTree.talents) do
        local finishes = 0
        if talent.isBeingResearched and talent.researchStartTime and talent.researchDuration then
            finishes = talent.researchStartTime + talent.researchDuration
        end

        table.insert(talents, table.concat({
            talent.id,
            talent.talentRank,
            finishes,
        }, ':'))
    end

    Addon.charData.garrisonTrees[treeId] = talents
end
