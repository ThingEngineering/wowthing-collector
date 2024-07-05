local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Professions')


Module.db = {}

local C_TradeSkillUI_GetProfessionInfoBySkillLineID = C_TradeSkillUI.GetProfessionInfoBySkillLineID
local C_TradeSkillUI_GetRecipeInfo = C_TradeSkillUI.GetRecipeInfo

function Module:OnEnable()
    self:RegisterBucketEvent(
        {
            'SKILL_LINES_CHANGED',
        },
        2,
        'UpdateProfessions'
    )
end

function Module:OnEnteringWorld()
    self:UpdateProfessions()
end

function Module:UpdateProfessions()
    local professions = {}

    for skillLineId, spellIds in pairs(self.db.wonkyProfessions) do
        local info = C_TradeSkillUI_GetProfessionInfoBySkillLineID(skillLineId)
        if info.professionID > 0 then
            local data = {
                id = skillLineId,
                currentSkill = info.skillLevel,
                maxSkill = info.maxSkillLevel,
                knownRecipes = {},
            }

            for _, spellId in ipairs(spellIds) do
                local recipeInfo = C_TradeSkillUI_GetRecipeInfo(spellId)
                if recipeInfo ~= nil and recipeInfo.learned then
                    table.insert(data.knownRecipes, recipeInfo.skillLineAbilityID)
                end
            end

            table.insert(professions, data)
        end
    end

    Addon.charData.professions = professions
end
