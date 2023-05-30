local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('ProfessionTraits')


Module.db = {}

function Module:OnEnable()
    self:RegisterBucketEvent(
        {
            'SKILL_LINES_CHANGED',
            'SKILL_LINE_SPECS_RANKS_CHANGED',
            'TRAIT_CONFIG_UPDATED',
        },
        2,
        'UpdateProfessions'
    )
end

function Module:OnEnteringWorld()
    self:UpdateProfessions()
end

function Module:UpdateProfessions()
    Addon.charData.professionTraits = {}

    local profession1, profession2 = GetProfessions()
    self:UpdateTraits(profession1)
    self:UpdateTraits(profession2)
end

function Module:UpdateTraits(spellbookIndex)
    if spellbookIndex == nil then return end

    local professionSkillLineId = select(7, GetProfessionInfo(spellbookIndex))
    if not self.db.skillLines[professionSkillLineId] then
        return
    end

    for _, skillLineId in ipairs(self.db.skillLines[professionSkillLineId]) do
        local skillLineData = { skillLineId }

        local configId = C_ProfSpecs.GetConfigIDForSkillLine(skillLineId)
        local specTabIds = C_ProfSpecs.GetSpecTabIDsForSkillLine(skillLineId)

        for _, specTabId in ipairs(specTabIds) do
            local pathQueue = {
                C_ProfSpecs.GetRootPathForTab(specTabId),
            }

            while #pathQueue > 0 do
                local pathId = tremove(pathQueue, 1)

                local childPathIds = C_ProfSpecs.GetChildrenForPath(pathId)
                for _, childPathId in ipairs(childPathIds) do
                    table.insert(pathQueue, childPathId)
                end

                local nodeInfo = C_Traits.GetNodeInfo(configId, pathId)
                if nodeInfo ~= nil then
                    table.insert(skillLineData, table.concat({
                        nodeInfo.ID,
                        nodeInfo.ranksPurchased,
                    }, ':'))
                end
            end
        end

        table.insert(Addon.charData.professionTraits, table.concat(skillLineData, '|'))
    end
end
