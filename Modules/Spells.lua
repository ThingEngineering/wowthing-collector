local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Spells', 'AceHook-3.0')


Module.db = {}

local C_UnitAuras_GetPlayerAuraBySpellID = C_UnitAuras.GetPlayerAuraBySpellID

function Module:OnEnable()
    self:RegisterBucketEvent({ 'LEARNED_SPELL_IN_TAB' }, 1, 'UpdateSpells')
    self:RegisterBucketEvent({ 'UNIT_AURA' }, 1, 'UNIT_AURA')
end

function Module:OnEnteringWorld()
    self:UpdateAuras()
    self:UpdateSpells()
end

function Module:UNIT_AURA(targets)
    if targets.player then
        self:UpdateAuras()
    end
end

function Module:UpdateAuras()
    local now = time()
    local uptime = GetTime() -- Blizzard why
    
    local auras = {}
    for _, spellId in ipairs(self.db.auras) do
        local auraInfo = C_UnitAuras_GetPlayerAuraBySpellID(spellId)
        if auraInfo ~= nil then
            local expire = 0
            if auraInfo.expirationTime > 0 then
                expire = math.floor(now + (auraInfo.expirationTime - uptime))
            end

            table.insert(auras, table.concat({
                spellId,
                expire,
            }, ':'))
        end
    end

    Addon.charData.aurasV2 = auras
end

function Module:UpdateSpells()
    -- Master Riding
    if IsSpellKnown(90265) then
        Addon.charData.mountSkill = 5
    -- Artisan Riding (DEPRECATED but still gives 280%)
    elseif IsSpellKnown(34091) then
        Addon.charData.mountSkill = 4
    -- Expert Riding
    elseif IsSpellKnown(34090) then
        Addon.charData.mountSkill = 3
    -- Journeyman Riding
    elseif IsSpellKnown(33391) then
        Addon.charData.mountSkill = 2
    -- Apprentice Riding
    elseif IsSpellKnown(33388) then
        Addon.charData.mountSkill = 1
    end
end
