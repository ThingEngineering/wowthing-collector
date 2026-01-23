local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Achievements')


Module.db = {}

function Module:OnEnable()
    self:RegisterBucketEvent({ 'CRITERIA_UPDATE' }, 1, 'UpdateAchievements')
end

function Module:OnEnteringWorld()
    self:UpdateAchievements()
end

function Module:UpdateAchievements()
    Addon.charData.scanTimes['achievements'] = time()

    local achievements = {}
    for _, achievement in ipairs(self.db.achievements) do
        local achievementId, alwaysSaveCriteria = unpack(achievement)
        local criteria = {}
        local earnedByCharacter = select(13, GetAchievementInfo(achievementId))

        -- This is nil if the achievement doesn't exist somehow
        if earnedByCharacter ~= nil then
            if alwaysSaveCriteria or not earnedByCharacter then
                local numCriteria = self.db.criteria[achievementId] or GetAchievementNumCriteria(achievementId)
                for i = 1, numCriteria do
                    -- offset by 1 due to pcall result
                    local success, _, _, _, quantity, _, characterName = pcall(GetAchievementCriteriaInfo, achievementId, i, true)
                    if success == false then
                        criteria = {}
                        break
                    end
                    
                    -- characterName will be nil if the criteria is lying about being complete
                    table.insert(criteria, characterName == nil and 0 or quantity)
                end
            end

            table.insert(achievements, {
                id = achievementId,
                earned = earnedByCharacter,
                criteria = criteria,
            })
        end
    end

    Addon.charData.achievements = achievements
end
