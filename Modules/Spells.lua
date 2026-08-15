local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Spells', 'AceHook-3.0')


Module.db = {}

local CUA_GetUnitAuras = C_UnitAuras.GetUnitAuras
local CS_ShouldAurasBeSecret = C_Secrets.ShouldAurasBeSecret
local CSB_IsSpellKnown = C_SpellBook.IsSpellKnown

function Module:OnEnable()
    Addon.charData.aurasV2 = Addon.charData.aurasV2 or {}
    Addon.charData.knownSpells = Addon.charData.knownSpells or {}

    self:RegisterBucketEvent(
        {
            'LEARNED_SPELL_IN_SKILL_LINE',
            'SPELLS_CHANGED',
        },
        2,
        'UpdateSpells'
    )
    self:RegisterBucketEvent({ 'UNIT_AURA' }, 2, 'UNIT_AURA')
end

function Module:OnEnteringWorld()
    self:UpdateAuras()
    self:UpdateSpells()
end

function Module:UNIT_AURA(unitTargets)
    if unitTargets.player then
        self:UpdateAuras()
    end
end

-- The secrets system sucks asssssss
function Module:UpdateAuras()
    if CS_ShouldAurasBeSecret() then return end

    local buffAuras = CUA_GetUnitAuras('player', 'HELPFUL') or {}
    local debuffAuras = CUA_GetUnitAuras('player', 'HARMFUL') or {}

    local now = time()
    local uptime = GetTime() -- Blizzard why

    local auras = Addon.charData.aurasV2
    wipe(auras)

    for _, unitAuras in ipairs({ buffAuras, debuffAuras }) do
        for _, auraInfo in ipairs(unitAuras) do
            if canaccesstable(auraInfo) and canaccessvalue(auraInfo.expirationTime) then
                local duration = 0
                local expiresAt = 0
                if auraInfo.expirationTime > 0 then
                    duration = math.floor(auraInfo.expirationTime - uptime)
                    expiresAt = math.floor(now + (auraInfo.expirationTime - uptime))
                end

                table.insert(auras, table.concat({
                    auraInfo.spellId,
                    expiresAt,
                    auraInfo.applications,
                    duration,
                }, ':'))
            end
        end
    end
end

function Module:UpdateSpells()
    local knownSpells = Addon.charData.knownSpells
    wipe(knownSpells)

    -- Master Riding
    if CSB_IsSpellKnown(90265) then
        Addon.charData.mountSkill = 5
    -- Artisan Riding (DEPRECATED but still gives 280%)
    elseif CSB_IsSpellKnown(34091) then
        Addon.charData.mountSkill = 4
    -- Expert Riding
    elseif CSB_IsSpellKnown(34090) then
        Addon.charData.mountSkill = 3
    -- Journeyman Riding
    elseif CSB_IsSpellKnown(33391) then
        Addon.charData.mountSkill = 2
    -- Apprentice Riding
    elseif CSB_IsSpellKnown(33388) then
        Addon.charData.mountSkill = 1
    end

    for _, spellId in ipairs(self.db.known) do
        if CSB_IsSpellKnown(spellId) then
            tinsert(knownSpells, spellId)
        end
    end
end
