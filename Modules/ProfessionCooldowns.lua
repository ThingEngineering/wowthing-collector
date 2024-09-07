local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('ProfessionCooldowns')


Module.db = {}

local CS_GetSpellCooldown = C_Spell.GetSpellCooldown
local C_TradeSkillUI_GetRecipeCooldown = C_TradeSkillUI.GetRecipeCooldown
local C_TradeSkillUI_GetRecipeInfo = C_TradeSkillUI.GetRecipeInfo

function Module:OnEnable()
    Addon.charData.professionCooldowns = Addon.charData.professionCooldowns or {}

    self:RegisterBucketEvent({ 'SPELL_UPDATE_COOLDOWN' }, 2, 'UpdateSpells')
    self:RegisterBucketEvent(
        {
            'TRADE_SKILL_ITEM_CRAFTED_RESULT',
            'TRADE_SKILL_LIST_UPDATE',
        },
        1,
        'UpdateCooldowns'
    )
end

function Module:UpdateSpells()
    local now = time()
    Addon.charData.scanTimes['professionCooldowns'] = now

    -- System uptime?? BUT WHY
    local wtfTime = GetTime()

    local professions = { GetProfessions() }
    for i = 1, 2 do
        local profession = professions[i]
        if profession ~= nil then
            local skillLineId = select(7, GetProfessionInfo(profession))
            local professionCooldowns = self.db.cooldowns[skillLineId]
            for key, cooldownData in pairs(professionCooldowns or {}) do
                local spellIds, cooldownType = unpack(cooldownData)
                if cooldownType == 'spell' then
                    local cooldownInfo = CS_GetSpellCooldown(spellIds[1])
                    if cooldownInfo ~= nil then
                        local currentValue = 0
                        local maxValue = 1
                        local nextAvailable = 0
                        if cooldownInfo.duration > 0 and cooldownInfo.startTime ~= 0 then
                            local remainingSeconds = cooldownInfo.duration - (wtfTime - cooldownInfo.startTime)
                            nextAvailable = Addon:Round(now + remainingSeconds)
                        else
                            currentValue = 1
                        end

                        local newString = table.concat({
                            key,
                            nextAvailable,
                            currentValue,
                            maxValue,
                        }, ':')
                        self:AddOrUpdate(key, newString)
                    end
                end
            end
        end
    end
end

function Module:UpdateCooldowns()
    -- professionID = id, profession = enum
    local profInfo = C_TradeSkillUI.GetBaseProfessionInfo()
    if profInfo == nil or profInfo.isPrimaryProfession == false then return end

    local now = time()
    Addon.charData.scanTimes['professionCooldowns'] = now

    local professionCooldowns = self.db.cooldowns[profInfo.professionID]
    if professionCooldowns == nil then return end

    local untilDailyReset = C_DateAndTime.GetSecondsUntilDailyReset()

    for key, cooldownData in pairs(professionCooldowns) do
        local spellIds, cooldownType = unpack(cooldownData)
        for _, spellId in ipairs(spellIds) do
            local recipeInfo = C_TradeSkillUI_GetRecipeInfo(spellId)
            if recipeInfo ~= nil and recipeInfo.learned == true then
                local remainingSeconds, _, currentValue, maxValue = C_TradeSkillUI_GetRecipeCooldown(spellId)
                
                -- Many "resets daily" cooldowns claim to reset at midnight, override that
                if cooldownType == 'daily' and (remainingSeconds or 0) > 0 then
                    remainingSeconds = untilDailyReset
                end
                
                local nextAvailable = 0
                if remainingSeconds ~= nil and remainingSeconds > 0 then
                    nextAvailable = Addon:Round(now + remainingSeconds)
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
                self:AddOrUpdate(key, newString)

                break
            end
        end
    end
end

function Module:AddOrUpdate(key, newString)
    local found = false

    for i, existingString in pairs(Addon.charData.professionCooldowns) do
        local existingParts = { strsplit(':', existingString) }
        if existingParts[1] == key then
            found = true
            Addon.charData.professionCooldowns[i] = newString
        end
    end

    if found == false then
        tinsert(Addon.charData.professionCooldowns, newString)
    end
end
