local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Garrisons')


Module.db = {}

function Module:OnEnable()
    Addon.charData.garrisons = Addon.charData.garrisons or {}
    Addon.charData.garrisonTrees = Addon.charData.garrisonTrees or {}

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
    -- Shadowlands are annoying
    local findType = garrisonData.type
    if garrisonData.type == Enum.GarrisonType.Type_9_0_Garrison then
        local covenantId = C_Covenants.GetActiveCovenantID() or 0
        findType = findType + (covenantId * 1000000)
    end

    local garrison
    for _, charGarrison in ipairs(Addon.charData.garrisons) do
        if charGarrison.type == findType then
            garrison = charGarrison
            break
        end
    end

    if garrison == nil then
        garrison = {
            type = findType
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

    garrison.followers = {}
    for _, followerType in ipairs(garrisonData.followerTypes) do
        local followers = C_Garrison.GetFollowers(followerType) or {}
        for _, follower in ipairs(followers) do
            -- DevTools_Dump(follower)
            tinsert(garrison.followers, table.concat({
                follower.garrFollowerID or 0,
                follower.quality,
                follower.level,
                follower.xp or 0,
                follower.levelXP or 0,
                follower.iLevel or 0,
                follower.name,
            }, ':'))
        end
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

    if #talents > 0 or Addon.charData.garrisonTrees[treeId] == nil then
        Addon.charData.garrisonTrees[treeId] = talents
    end
end
