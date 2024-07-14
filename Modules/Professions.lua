local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Professions')


Module.db = {}

local C_TradeSkillUI_GetProfessionInfoBySkillLineID = C_TradeSkillUI.GetProfessionInfoBySkillLineID
local C_TradeSkillUI_GetRecipeInfo = C_TradeSkillUI.GetRecipeInfo

function Module:OnEnable()
    Addon.charData.professions = Addon.charData.professions or {}

    self:RegisterBucketEvent(
        {
            'SKILL_LINES_CHANGED',
            'TRADE_SKILL_LIST_UPDATE',
        },
        2,
        'UpdateProfessions'
    )
end

function Module:OnEnteringWorld()
    self:UpdateProfessions()
end

function Module:UpdateProfessions()
    local skillLineMap = {}
    for _, skillLineData in ipairs(Addon.charData.professions) do
        skillLineMap[skillLineData.id] = skillLineData
    end

    for skillLineId, spellIds in pairs(self.db.wonkyProfessions) do
        local info = C_TradeSkillUI_GetProfessionInfoBySkillLineID(skillLineId)
        if info.professionID > 0 then
            if skillLineMap[skillLineId] == nil then
                skillLineMap[skillLineId] = {
                    id = skillLineId,
                    currentSkill = 0,
                    maxSkill = 0,
                    knownRecipes = {},
                }
                table.insert(Addon.charData.professions, skillLineMap[skillLineId])
            end
            local skillLineData = skillLineMap[skillLineId]

            if info.skillLevel > 0 then
                skillLineData.currentSkill = info.skillLevel
            end
            if info.maxSkillLevel > 0 then
                skillLineData.maxSkill = info.maxSkillLevel
            end

            local knownRecipes = {}
            for _, spellId in ipairs(spellIds) do
                local recipeInfo = C_TradeSkillUI_GetRecipeInfo(spellId)
                if recipeInfo ~= nil and recipeInfo.learned then
                    table.insert(knownRecipes, recipeInfo.skillLineAbilityID)
                end
            end

            if #knownRecipes > 0 then
                skillLineData.knownRecipes = knownRecipes
            end
        end
    end
end
