local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('GarrisonTrees')


Module.db = {}

function Module:OnEnable()
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
    self:UpdateGarrisonTrees()
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
