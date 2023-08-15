local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('ProfessionCooldowns')


Module.db = {}

local C_TradeSkillUI_GetRecipeCooldown = C_TradeSkillUI.GetRecipeCooldown
local C_TradeSkillUI_GetRecipeInfo = C_TradeSkillUI.GetRecipeInfo

function Module:OnEnable()
    Addon.charData.professionCooldowns = Addon.charData.professionCooldowns or {}

    self:RegisterBucketEvent(
        {
            'TRADE_SKILL_ITEM_CRAFTED_RESULT',
            'TRADE_SKILL_LIST_UPDATE',
        },
        1,
        'UpdateCooldowns'
    )
end

function Module:UpdateCooldowns()
    local now = time()
    Addon.charData.scanTimes['professionCooldowns'] = now

    for professionId, subProfessions in pairs(self.db.cooldowns) do
        -- check for profession learned?
        for subProfessionId, cooldowns in pairs(subProfessions) do
            for key, spellIds in pairs(cooldowns) do
                for _, spellId in ipairs(spellIds) do
                    local recipeInfo = C_TradeSkillUI_GetRecipeInfo(spellId)
                    if recipeInfo ~= nil and recipeInfo.learned == true then
                        local remainingSeconds, _, currentValue, maxValue = C_TradeSkillUI_GetRecipeCooldown(spellId)
                        local nextAvailable = 0
                        if remainingSeconds ~= nil and remainingSeconds > 0 then
                            nextAvailable = math.floor(now + remainingSeconds + 0.5) -- round() hack
                        end

                        -- Blizzard lies about these, whee
                        if currentValue == 0 and maxValue == 0 then
                            if remainingSeconds == nil then
                                currentValue = 1
                            end
                            maxValue = 1
                        end
                    

                        local newString = table.concat({
                            key,
                            nextAvailable,
                            currentValue,
                            maxValue,
                        }, ':')

                        local found = false
                        for i, existingString in pairs(Addon.charData.professionCooldowns) do
                            local existingParts = { strsplit(':', existingString) }
                            if existingParts[1] == key then
                                found = true
                                Addon.charData.professionCooldowns[i] = newString
                            end
                        end

                        if found == false then
                            table.insert(Addon.charData.professionCooldowns, newString)
                        end

                        break
                    end
                end
            end
        end
    end
end
