local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Covenants')


Module.db = {}

function Module:OnEnable()
    Addon.charData.covenants = Addon.charData.covenants or {}

    self:RegisterBucketEvent(
        {
            'COVENANT_CHOSEN',
            'COVENANT_SANCTUM_RENOWN_LEVEL_CHANGED',
            'SOULBIND_ACTIVATED',
            'SOULBIND_FORGE_INTERACTION_ENDED',
            'SOULBIND_FORGE_INTERACTION_STARTED',
        },
        1,
        'UpdateCovenants'
    )
    self:RegisterBucketEvent({ 'CURRENCY_DISPLAY_UPDATE' }, 1, 'CheckCurrencies')

    self:RegisterBucketMessage({ 'WWTC_SCAN_COVENANT' }, 1, 'UpdateCovenants')
end

function Module:OnEnteringWorld()
    self:SendMessage('WWTC_SCAN_COVENANT')
end

function Module:CheckCurrencies(currencyIds)
    -- Redeemed Soul, Reservoir Anima
    if currencyIds[1810] or currencyIds[1813] then
        self:SendMessage('WWTC_SCAN_COVENANT')
    end
end

local function SortTalents(talentA, talentB)
    return talentA.tier < talentB.tier
end

function Module:UpdateCovenants()
    local now = time()
    Addon.charData.scanTimes["covenants"] = now

    -- 1=Kyrian 2=Venthyr 3=NightFae 4=Necrolord
    local covenantId = C_Covenants.GetActiveCovenantID()
    if covenantId == 0 then return end

    Addon.charData.activeCovenantId = covenantId

    local covenantData = {
        id = covenantId,
        renown = C_CovenantSanctumUI.GetRenownLevel(),
        anima = 0,
        souls = 0,
        conductor = {},
        transport = {},
        missions = {},
        unique = {},
        soulbinds = {},
    }

    -- Currencies
    local animaInfo = C_CurrencyInfo.GetCurrencyInfo(1813)
    if animaInfo ~= nil then
        covenantData.anima = animaInfo.quantity
    end

    local soulsInfo = C_CurrencyInfo.GetCurrencyInfo(1810)
    if soulsInfo ~= nil then
        covenantData.souls = soulsInfo.quantity
    end

    -- Features
    local covenant = self.db.covenants[covenantId]
    for thing, talentTreeId in pairs(covenant.features) do
        local talentData = C_Garrison.GetTalentTreeInfo(talentTreeId)
        table.sort(talentData.talents, SortTalents)

        local thingData = {
            name = talentData.title,
            rank = 0,
            researchEnds = 0,
        }

        for _, talent in ipairs(talentData.talents) do
            if talent.researched == true then
                thingData.rank = talent.tier + 1
            else
                if talent.isBeingResearched == true then
                    thingData.researchEnds = now + talent.timeRemaining
                end
                break
            end
        end

        covenantData[thing] = thingData
    end

    -- Soulbinds
    local soulbindIds = C_Covenants.GetCovenantData(covenantId)['soulbindIDs']
    for _, soulbindId in ipairs(soulbindIds) do
        local soulbindData = C_Soulbinds.GetSoulbindData(soulbindId)
        local soulbind = {
            id = soulbindData.ID,
            unlocked = soulbindData.unlocked,
            specs = C_Soulbinds.GetSpecsAssignedToSoulbind(soulbindId),
            tree = {},
        }

        for _, node in ipairs(soulbindData.tree.nodes) do
            if node.state == 3 then
                soulbind.tree[node.row + 1] = {
                    node.column + 1,
                    C_Soulbinds.GetConduitSpellID(node.conduitID, node.conduitRank),
                    node.conduitRank,
                }
            end
        end

        covenantData.soulbinds[#covenantData.soulbinds + 1] = soulbind
    end

    local found = false
    for i, _ in ipairs(Addon.charData.covenants) do
        if Addon.charData.covenants[i].id == covenantId then
            Addon.charData.covenants[i] = covenantData
            found = true
            break
        end
    end

    if found == false then
        Addon.charData.covenants[#Addon.charData.covenants + 1] = covenantData
    end
end
