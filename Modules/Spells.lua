local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Spells', 'AceHook-3.0')


Module.db = {}

local AURA_TYPES = { 'HELPFUL', 'HARMFUL' }

local CUA_GetAuraDataByIndex = C_UnitAuras.GetAuraDataByIndex
local CUA_GetPlayerAuraBySpellID = C_UnitAuras.GetPlayerAuraBySpellID
local IsSpellKnown = IsSpellKnown

function Module:OnEnable()
    Addon.charData.knownSpells = Addon.charData.knownSpells or {}

    self.inCombat = false

    self:RegisterEvent('PLAYER_ENTER_COMBAT')
    self:RegisterEvent('PLAYER_LEAVE_COMBAT')
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

function Module:PLAYER_ENTER_COMBAT()
    self.inCombat = true
end

function Module:PLAYER_LEAVE_COMBAT()
    self.inCombat = false
end

function Module:UNIT_AURA(targets)
    if self.inCombat == false and targets.player then
        self:UpdateAuras()
    end
end

function Module:UpdateAuras()
    local now = time()
    local uptime = GetTime() -- Blizzard why
    
    local auras = {}
    
    for _, auraType in ipairs(AURA_TYPES) do
        for i = 1, 50 do
            local auraInfo = CUA_GetAuraDataByIndex('PLAYER', i, auraType)
            if auraInfo == nil then break end

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

    Addon.charData.aurasV2 = auras
end

function Module:UpdateSpells()
    local knownSpells = Addon.charData.knownSpells
    wipe(knownSpells)

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

    for _, spellId in ipairs(self.db.known) do
        if IsSpellKnown(spellId) then
            tinsert(knownSpells, spellId)
        end
    end
end
