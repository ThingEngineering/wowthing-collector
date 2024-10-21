local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('BattlePets')


local CPJ_GetPetInfoByIndex = C_PetJournal.GetPetInfoByIndex
local CPJ_GetPetInfoByPetID = C_PetJournal.GetPetInfoByPetID
local CPJ_GetPetStats = C_PetJournal.GetPetStats

function Module:OnEnable()
    WWTCSaved.battlePets = WWTCSaved.battlePets or {}

    self:RegisterEvent('NEW_PET_ADDED')
    self:RegisterEvent('PET_JOURNAL_PET_DELETED')
end

function Module:OnEnteringWorld()
    C_Timer.After(5, function() self:UpdateBattlePets() end)
end

function Module:NEW_PET_ADDED(_, guid)
    local speciesId, _, level = CPJ_GetPetInfoByPetID(guid)
    WWTCSaved.battlePets[Module:ParseGUID(guid)] = table.concat({
        speciesId,
        level,
    }, ':')
end

function Module:PET_JOURNAL_PET_DELETED(_, guid)
    WWTCSaved.battlePets[Module:ParseGUID(guid)] = nil
end

function Module:UpdateBattlePets()
    if not C_PetJournal.IsJournalUnlocked() then return end

    C_PetJournal.SetDefaultFilters()

    local _, numOwned = C_PetJournal.GetNumPets()
    local pets = {}
    for petIndex = 1, numOwned do
        local guid, speciesId, owned, _, level = CPJ_GetPetInfoByIndex(petIndex)
        if guid ~= nil and owned then
            local _, _, _, _, quality = CPJ_GetPetStats(guid)
            pets[Module:ParseGUID(guid)] = table.concat({
                speciesId,
                level,
                quality - 1, -- GetPetStats returns 1 higher than expected, weird
            }, ':')
        end
    end

    WWTCSaved.battlePets = pets
end

function Module:ParseGUID(guid)
    local parts = { strsplit('-', guid) }
    return tonumber(parts[3], 16)
end
