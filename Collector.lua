local an, ns = ...

local _G = getfenv(0)


-- Things
local wwtc = {}
local charClassID, charData, charName, guildName, playedLevel, playedLevelUpdated, playedTotal, playedTotalUpdated, regionName
local hookedCollections, loggingOut = false, false, false
local bankOpen, crafterOpen, guildBankOpen, reagentBankUpdated = false, false, false, false
local maxScannedToys = 0
local oldScannedTransmog = 0
local dirtyBags, dirtyCovenant, dirtyCurrencies, dirtyLockouts, dirtyMounts, dirtyMythicPlus, dirtyPets, dirtyQuests, dirtyReputations, dirtyToys, dirtyTransmog, dirtyVault =
    {}, false, false, false, false, false, false, false, false, false, false, false, false
local dirtyCallings, callingData = false, nil
local dirtyGuildBank, guildBankQueried, requestingPlayedTime = false, false, true

-- Libs
local LibRealmInfo = LibStub('LibRealmInfo17janekjl')

-- Tooltips?
local scanTooltip = CreateFrame('GameTooltip', 'WWTCTooltip', nil, 'GameTooltipTemplate')
scanTooltip:SetOwner(WorldFrame, 'ANCHOR_NONE')

-- Default SavedVariables
local defaultWWTCSaved = {
    version = 9158,
    chars = {},
    guilds = {},
    heirlooms = {},
    toys = {},
    transmogSourcesV2 = {},
}

local instanceNameToId = {}


-- Trade skill cooldowns
local tradeSkills = {
    [156587] = true, -- Alchemical Catalyst
    [175880] = true, -- Secrets of Draenor Alchemy

    [171690] = true, -- Truesteel Ingot
    [176090] = true, -- Secrets of Draenor Blacksmithing

    [169092] = true, -- Temporal Crystal
    [177043] = true, -- Secrets of Draenor Enchanting

    [169080] = true, -- Gearspring Parts
    [177054] = true, -- Secrets of Draenor Engineering

    [169081] = true, -- War Paints
    [177045] = true, -- Secrets of Draenor Inscription

    [170700] = true, -- Taladite Crystal
    [176087] = true, -- Secrets of Draenor Jewelcrafting

    [171391] = true, -- Burnished Leather
    [176089] = true, -- Secrets of Draenor Leatherworking

    [168835] = true, -- Hexweave Cloth
    [176058] = true, -- Secrets of Draenor Tailoring
}

-- Check things the Battle.net API is bugged for
local checkMounts = {
    --[458] = true, -- Brown Horse
    --[229376] = true, -- Archmage's Prismatic Disc (Mage Order Hall)
    --[229377] = true, -- Gift of the Holy Keepers (Priest Order Hall)
    --[229417] = true, -- Slayer's Felbroken Shrieker (Demon Hunter Order Hall)
    --[232412] = true, -- Netherlord's Chaotic Wrathsteed (Warlock Order Hall)
    --[215545] = true, -- Mastercraft Gravewing (Korthia rare)
}
local checkPets = {
    [216] = 33239, -- Argent Gruntling
    [1350] = 73809, -- Sky Lantern
}
local checkReputations = {
    --1492, -- Emperor Shaohao
}
local checkFriendships = {
    2463, -- Marasmius
}
local paragonReputations = {
    -- Legion
    1828, -- Highmountain Tribe
    1859, -- The Nightfallen
    1883, -- Dreamweavers
    1894, -- The Wardens
    1900, -- Court of Farondis
    1948, -- Valarjar
    2045, -- Armies of Legionfall
    2165, -- Army of the Light
    2170, -- Argussian Reach

    -- Battle for Azeroth
    2103, -- Zandalari Empire
    2156, -- Talanji's Expedition
    2157, -- The Honorbound
    2158, -- Voldunai
    2159, -- 7th Legion
    2160, -- Proudmoore Admiralty
    2161, -- Order of Embers
    2162, -- Storm's Wake
    2163, -- Tortollan Seekers
    2164, -- Champions of Azeroth
    2373, -- The Unshackled
    2391, -- Rustbolt Resistance
    2400, -- Waveblade Ankoan
    2415, -- Rajani
    2417, -- Uldum Accord

    -- Shadowlands
    2407, -- The Ascended
    2410, -- The Undying Army
    2413, -- Court of Harvesters
    2432, -- Ve'nari
    2465, -- The Wild Hunt
    2470, -- Death's Advance
    2472, -- The Archivists' Codex
}
local worldQuestFactions = {
    -- Both
    [50562] = 2164, -- Champions of Azeroth
    [50604] = 2163, -- Tortollan Seekers

    -- Alliance
    [50605] = 2157, -- 7th Legion => The Honorbound
    [50600] = 2158, -- Order of Embers => Voldunai
    [50599] = 2103, -- Proudmoore Admiralty => Zandalari Empire
    [50601] = 2156, -- Storm's Wake => Talanji's Expedition

    -- Horde
    [50602] = 2156, -- Talanji's Expedition
    [50606] = 2157, -- The Honorbound
    [50603] = 2158, -- Voldunai
    [50598] = 2103, -- Zandalari Empire
}

local torghastWidgets = {
    {name = 2927, level = 2936}, -- Coldheart Interstitia
    {name = 2925, level = 2930}, -- Fracture Chambers
    {name = 2928, level = 2938}, -- Mort'regar
    {name = 2926, level = 2932}, -- Skoldus Hall
    {name = 2924, level = 2934}, -- Soulforges
    {name = 2929, level = 2940}, -- The Upper Reaches
}


-- Misc constants
local MAP_KULTIRAS = 876
local SLOTS_PER_GUILD_BANK_TAB = 98

-- Hook the time played message so that we don't print it to chat every time
do
    local originalDisplayTimePlayed = _G.ChatFrame_DisplayTimePlayed
    _G.ChatFrame_DisplayTimePlayed = function(...)
        if requestingPlayedTime then
            requestingPlayedTime = false
            return
        end
        return originalDisplayTimePlayed(...)
    end
end

-- Need a frame for events
local frame, events = CreateFrame("FRAME"), {}

-- Fires when the addon has finished loading
function events:ADDON_LOADED(name)
    -- Damn Pet Journal!
    if name == "Blizzard_Collections" then
        wwtc:HookCollections()
    end
end

-- Fires when the player logs in, surprisingly
function events:PLAYER_LOGIN()
    wwtc:Login()
end
-- Fires when the player logs out, surprisingly
function events:PLAYER_LOGOUT()
    wwtc:Logout()
end
-- Fires any time the player sees a loading screen
function events:PLAYER_ENTERING_WORLD()
    -- FIXME: goes in PLAYER_LOGIN when not dev?
    --wwtc:Initialise()

    wwtc:UpdateCharacterData()
    dirtyCovenant = true
    dirtyCurrencies = true
    dirtyTransmog = true
    dirtyVault = true
end
-- Fires when /played information is available
function events:TIME_PLAYED_MSG(total, level)
    playedLevel, playedLevelUpdated, playedTotal, playedTotalUpdated = level, time(), total, time()
    -- Unregister since we no longer care
    frame:UnregisterEvent("TIME_PLAYED_MSG")
end
-- Fires when the player gains a character level
function events:PLAYER_LEVEL_UP()
    playedLevel, playedLevelUpdated = 0, time()
end
-- Fires when the player's rest state or amount of rested XP changes
function events:UPDATE_EXHAUSTION()
    wwtc:UpdateExhausted()
end
-- Fires when guild stats changes
function events:PLAYER_GUILD_UPDATE(unitID)
    if unitID == "player" then
        wwtc:UpdateGuildData()
    end
end
-- Fires when LFG something
function events:LFG_UPDATE_RANDOM_INFO()
    dirtyLockouts = true
end
-- Fires when RequestRaidInfo() completes
function events:UPDATE_INSTANCE_INFO()
    dirtyLockouts = true
end
-- Fires when currency changes
function events:CURRENCY_DISPLAY_UPDATE(currencyType)
    -- Redeemed Soul, Reservoir Anima
    if currencyType == 1810 or currencyType == 1813 then
        dirtyCovenant = true
    end

    dirtyCurrencies = true
end

-- Fires when player money changes
function events:PLAYER_MONEY()
    charData.copper = GetMoney()
end
-- Fires when information about the contents of a trade skill recipe list changes or becomes available
--function events:TRADE_SKILL_UPDATE()
--    wwtc:ScanTradeSkills()
--end
-- Fires when a unit casts a spell - used for trade skill updating
--function events:UNIT_SPELLCAST_SUCCEEDED(evt, unit, spellName, rank, lineID, spellID)
--    -- We only care about the player's trade skills
--    if unit == "player" and tradeSkills[spellID] == true then
--        C_Timer.NewTimer(0.5, function() wwtc:ScanTradeSkills() end)
--    end
--end
-- Fires when the contents of a bag changes
function events:BAG_UPDATE(bagID)
    dirtyBags[bagID] = true
end
-- Fires when the bank is opened
function events:BANKFRAME_OPENED()
    -- Force a bag scan of the bank now that it's open
    bankOpen = true
    dirtyBags[-1] = true
    dirtyBags[-3] = true
    for i = 5, 11 do
        dirtyBags[i] = true
    end
end
-- Fires when the bank is closed
function events:BANKFRAME_CLOSED()
    bankOpen = false
end
-- Fires when something changes in the reagent bank
function events:PLAYERREAGENTBANKSLOTS_CHANGED()
    dirtyBags[-3] = true
    reagentBankUpdated = true
end
-- Fires when the guild bank opens
function events:GUILDBANKFRAME_OPENED()
    guildBankOpen = true
    guildBankQueried = false
    wwtc:UpdateGuildBank()
end
-- Fires when the guild bank closes
function events:GUILDBANKFRAME_CLOSED()
    guildBankOpen = false
end
-- Fires when something changes in a guild bank tab, including when it is first filled
function events:GUILDBANKBAGSLOTS_CHANGED()
    dirtyGuildBank = true
end
-- Fires ??
function events:COMPANION_UPDATE()
    dirtyMounts = true
    dirtyPets = true
end
-- Fires when a new companion is learned
function events:COMPANION_LEARNED()
    dirtyMounts = true
    dirtyPets = true
end
-- Fires when the mount journal usability list changes (move between inside/outside/water/etc)
function events:MOUNT_JOURNAL_USABILITY_CHANGED()
    dirtyMounts = true
end
-- Fires when the pet journal list updates
function events:PET_JOURNAL_LIST_UPDATE()
    dirtyPets = true
end
-- Fires when the contents of the reputation listing change or become available
function events:UPDATE_FACTION()
    dirtyReputations = true
end
-- Fires when Mythic dungeon ends
function events:CHALLENGE_MODE_COMPLETED()
    C_MythicPlus.RequestMapInfo()
end
-- Fires when Mythic dungeon map information updates
function events:CHALLENGE_MODE_MAPS_UPDATE()
    dirtyMythicPlus = true
    dirtyVault = true
end
-- Vault
function events:WEEKLY_REWARDS_HIDE()
    dirtyVault = true
end
function events:WEEKLY_REWARDS_SHOW()
    dirtyVault = true
end
function events:WEEKLY_REWARDS_UPDATE()
    dirtyVault = true
end
-- Quest changes, spammy
function events:QUEST_LOG_UPDATE()
    dirtyQuests = true
end
-- Finished looting something
function events:LOOT_CLOSED()
    dirtyLockouts = true
    dirtyQuests = true
end
-- Popup "you got loot" box
function events:SHOW_LOOT_TOAST()
    dirtyLockouts = true
    dirtyQuests = true
end
-- Chromie time
function events:CHROMIE_TIME_CLOSE()
    wwtc:UpdateChromieTime()
end
function events:CHROMIE_TIME_OPEN()
    wwtc:UpdateChromieTime()
end
-- Vague about what this does, but it includes war mode
function events:PLAYER_FLAGS_CHANGED(unitId)
    if unitId == 'player' then
        wwtc:UpdateWarMode()
    end
end
-- Quests
function events:COVENANT_CALLINGS_UPDATED(callings)
    dirtyCallings = true
    callingData = callings
end
-- Shadowlands: Covenants
function events:COVENANT_CHOSEN()
    dirtyCovenant = true
end
function events:COVENANT_SANCTUM_RENOWN_LEVEL_CHANGED()
    dirtyCovenant = true
end
function events:COVENANT_SANCTUM_INTERACTION_STARTED()
    dirtyCovenant = true
end
function events:COVENANT_SANCTUM_INTERACTION_ENDED()
    dirtyCovenant = true
end
function events:SOULBIND_ACTIVATED()
    dirtyCovenant = true
end
function events:SOULBIND_FORGE_INTERACTION_STARTED()
    dirtyCovenant = true
end
function events:SOULBIND_FORGE_INTERACTION_ENDED()
    dirtyCovenant = true
end
-- Toys
function events:NEW_TOY_ADDED()
    dirtyToys = true
end
function events:TOYS_UPDATED()
    dirtyToys = true
end
-- Transmog
function events:TRANSMOG_COLLECTION_SOURCE_ADDED()
    dirtyTransmog = true
end
function events:TRANSMOG_COLLECTION_SOURCE_REMOVED()
    dirtyTransmog = true
end
function events:TRANSMOG_COLLECTION_UPDATED()
    dirtyTransmog = true
end

-------------------------------------------------------------------------------
-- Call functions in the events table for events
frame:SetScript("OnEvent", function(self, event, ...)
    events[event](self, ...)
end)

-- Register every event in the events table
for k, v in pairs(events) do
    frame:RegisterEvent(k)
end

-------------------------------------------------------------------------------
-- Timer to do spammy things
function wwtc:Timer()
    for bagID, dirty in pairs(dirtyBags) do
        dirtyBags[bagID] = nil
        wwtc:ScanBag(bagID)
    end

    if dirtyCovenant then
        dirtyCovenant = false
        wwtc:ScanCovenants()
    end

    if dirtyCurrencies then
        dirtyCurrencies = false
        wwtc:ScanCurrencies()
    end

    if dirtyGuildBank then
        dirtyGuildBank = false
        wwtc:ScanGuildBankTabs()
    end

    if dirtyLockouts then
        dirtyLockouts = false
        wwtc:ScanLockouts()
    end

    if dirtyMounts then
        dirtyMounts = false
        wwtc:ScanMounts()
    end

    if dirtyMythicPlus then
        dirtyMythicPlus = false
        wwtc:ScanMythicPlus()
    end

    if dirtyPets then
        dirtyPets = false
        wwtc:ScanPets()
    end

    if dirtyReputations then
        dirtyReputations = false
        wwtc:ScanReputations()
    end

    if dirtyToys then
        dirtyToys = false
        wwtc:ScanToys(false)
    end

    if dirtyTransmog then
        dirtyTransmog = false
        wwtc:ScanTransmog()
    end

    if dirtyVault then
        dirtyVault = false
        wwtc:ScanVault()
    end

    if dirtyQuests then
        dirtyQuests = false
        C_CovenantCallings.RequestCallings()
        wwtc:ScanQuests()
    end

    if dirtyCallings then
        dirtyCallings = false
        wwtc:ScanCallings()
    end
end
-- Run the timer once per 2 seconds to do chunky things
local _ = C_Timer.NewTicker(2, function() wwtc:Timer() end, nil)

-------------------------------------------------------------------------------

function wwtc:Initialise()
    if WWTCSaved == nil or WWTCSaved.version < defaultWWTCSaved.version then
        WWTCSaved = defaultWWTCSaved
    end

    -- Perform any cleanup
    wwtc:Cleanup()

    -- Build a unique ID for this character
    -- id, name, nameForAPI, rules, locale, nil, region, timezone, connections, englishName, englishNameForAPI
    local _, realm, _, _, _, _, region, _, _, realmEnglish = LibRealmInfo:GetRealmInfoByUnit("player")
    regionName = region or GetCurrentRegion()
    charName = regionName .. "/" .. (realmEnglish or realm)  .. "/" .. UnitName("player")
    charClassID = select(3, UnitClass("player"))

    WWTCSaved.transmogSourcesV2 = WWTCSaved.transmogSourcesV2 or {}

    -- Set up character data table
    charData = WWTCSaved.chars[charName] or {}
    WWTCSaved.chars[charName] = charData

    charData.chromieTime = 0
    charData.copper = 0
    charData.isResting = false
    charData.isWarMode = false
    charData.keystoneInstance = 0
    charData.keystoneLevel = 0
    charData.lastSeen = 0
    charData.mountSkill = 0
    charData.playedLevel = 0
    charData.playedTotal = 0
    charData.restedXP = 0

    charData.achievements = charData.achievements or {}
    charData.bags = charData.bags or {}
    charData.callings = charData.callings or {}
    charData.covenants = charData.covenants or {}
    charData.currencies = charData.currencies or {}
    charData.dailyQuests = charData.dailyQuests or {}
    charData.items = charData.items or {}
    charData.lockouts = charData.lockouts or {}
    charData.mounts = charData.mounts or {}
    charData.mythicDungeons = charData.mythicDungeons or {}
    charData.mythicPlus = charData.mythicPlus or {}
    charData.orderHallResearch = charData.orderHallResearch or {}
    charData.otherQuests = charData.otherQuests or {}
    charData.paragons = charData.paragons or {}
    charData.pets = charData.pets or {}
    charData.progressQuests = charData.progressQuests or {}
    charData.reputations = charData.reputations or {}
    charData.scanTimes = charData.scanTimes or {}
    charData.torghast = charData.torghast or {}
    charData.tradeSkills = charData.tradeSkills or {}
    charData.transmog = charData.transmog or nil
    charData.vault = charData.vault or {}

    -- Deprecated
    charData.biggerFishToFry = nil
    charData.hiddenDungeons = nil
    charData.hiddenKills = nil
    charData.hiddenWorldQuests = nil
    charData.balanceUnleashedMonstrosities = nil
    charData.balanceMythic15 = nil
    charData.worldQuests = nil

    charData.dailyResetTime = wwtc:GetDailyResetTime()

    wwtc:BuildEJData()
    wwtc:UpdateGuildData()
end

function wwtc:Login()
    wwtc:Initialise()

    -- Try to hook things
    wwtc:HookCollections()

    RequestTimePlayed()
    C_Garrison.RequestLandingPageShipmentInfo()
    wwtc:ScanMounts()
    wwtc:ScanToys(true)
end

function wwtc:Logout()
    loggingOut = true
    wwtc:UpdateCharacterData()
end

function wwtc:Cleanup()
    WWTCSaved.transmogSources = nil

    -- Remove data for any characters not seen in the last 3 days
    local old = time() - (3 * 24 * 60 * 60)
    for cName, cData in pairs(WWTCSaved.chars) do
        if not cData.lastSeen or cData.lastSeen < old then
            WWTCSaved.chars[cName] = nil
        else
            cData.weeklyQuests = nil
            cData.weeklyUghQuests = nil
        end
    end
end

-- Build a mapping of instanceName => instanceId
function wwtc:BuildEJData()
    for tier = 1, EJ_GetNumTiers() do
        EJ_SelectTier(tier)

        for i = 1, 2 do
            local isRaid = i == 1
            local index = 1
            local instanceId, name = EJ_GetInstanceByIndex(index, isRaid)

            while instanceId do
                instanceNameToId[name] = instanceId
                index = index + 1
                instanceId, name = EJ_GetInstanceByIndex(index, isRaid)
            end
        end
    end
end

-- Update various character data
function wwtc:UpdateCharacterData()
    if charData == nil then return end

    local now = time()
    charData.lastSeen = now

    -- Played time
    if playedLevel and playedTotal then
        charData.playedLevel = playedLevel + (now - playedLevelUpdated)
        charData.playedTotal = playedTotal + (now - playedTotalUpdated)
    end

    -- Master Riding
    if IsSpellKnown(90265) then
        charData.mountSkill = 5
    -- Artisan Riding (DEPRECATED but still gives 280%)
    elseif IsSpellKnown(34091) then
        charData.mountSkill = 4
    -- Expert Riding
    elseif IsSpellKnown(34090) then
        charData.mountSkill = 3
    -- Journeyman Riding
    elseif IsSpellKnown(33391) then
        charData.mountSkill = 2
    -- Apprentice Riding
    elseif IsSpellKnown(33388) then
        charData.mountSkill = 1
    end

    if not loggingOut then
        dirtyQuests = true

        charData.copper = GetMoney()

        wwtc:UpdateChromieTime()
        wwtc:UpdateExhausted()
        wwtc:UpdateWarMode()

        wwtc:ScanAchievements()
        wwtc:ScanTorghast()

        C_MythicPlus.RequestMapInfo()
        RequestRaidInfo()
    end
end

function wwtc:UpdateGuildData()
    if charData == nil then return end

    -- Sometimes this fires before region is checked? Weird
    if not regionName then
        return
    end

    -- Build a unique ID for this character's guild
    charData.guildName = nil
    local gName, _, _, gRealm = GetGuildInfo("player")
    if gName then
        if gRealm == nil then
            gRealm = GetRealmName()
        end

        guildName = regionName .. "/" .. gRealm .. "/" .. gName
        charData.guildName = guildName

        WWTCSaved.guilds[guildName] = WWTCSaved.guilds[guildName] or {}
        WWTCSaved.guilds[guildName].copper = WWTCSaved.guilds[guildName].copper or 0
        WWTCSaved.guilds[guildName].items = WWTCSaved.guilds[guildName].items or {}
        WWTCSaved.guilds[guildName].scanTimes = WWTCSaved.guilds[guildName].scanTimes or {}
        WWTCSaved.guilds[guildName].tabs = WWTCSaved.guilds[guildName].tabs or {}
    else
        guildName = nil
    end
end

function wwtc:UpdateChromieTime()
    if charData == nil then return end

    charData.chromieTime = UnitChromieTimeID("player")
end

-- Update resting status and rested XP
function wwtc:UpdateExhausted()
    if charData == nil then return end

    charData.isResting = IsResting()

    local rested = GetXPExhaustion()
    if rested and rested > 0 then
        charData.restedXP = rested
    else
        charData.restedXP = 0
    end
end

function wwtc:UpdateWarMode()
    if charData == nil then return end

    charData.isWarMode = C_PvP.IsWarModeDesired()
end

-- Scan a specific bag
function wwtc:ScanBag(bagID)
    if charData == nil then return end

    -- Short circuit if bank isn't open
    if (bagID == -1 or (bagID >= 5 and bagID <= 11)) and not bankOpen then
        return
    end
    -- Reagent bank is weird, make sure that the bank is open or it was actually updated
    if bagID == -3 then
        if not (bankOpen or reagentBankUpdated) then
            return
        end
        reagentBankUpdated = false
    end

    local now = time()
    if bagID >= 0 and bagID <= 4 then
        charData.scanTimes["bags"] = now

        -- Update mythic plus keystone since bags changed
        charData.keystoneInstance = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
        charData.keystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel()
    else
        charData.scanTimes["bank"] = now
    end

    charData.items["b"..bagID] = {}
    local bag = charData.items["b"..bagID]

    -- Update bag ID
    if bagID >= 1 then
        local bagItemID, _ = GetInventoryItemID('player', ContainerIDToInventoryID(bagID))
        charData.bags["b"..bagID] = bagItemID
    end

    local numSlots = GetContainerNumSlots(bagID)
    if numSlots > 0 then
        for i = 1, numSlots do
            local _, count, _, _, _, _, link, _ = GetContainerItemInfo(bagID, i)
            if count ~= nil and link ~= nil then
                local parsed = wwtc:ParseItemLink(link, count)
                bag["s"..i] = parsed
            end
        end
    end
end

function wwtc:UpdateGuildBank()
    WWTCSaved.guilds[guildName].copper = GetGuildBankMoney()

    for i = 1, GetNumGuildBankTabs() do
        local name, icon, isViewable, canDeposit, numWithdrawals, remainingWithdrawals = GetGuildBankTabInfo(i)
        WWTCSaved.guilds[guildName].tabs["tab "..i] = { name, icon }
    end
end

-- Scan guild bank tabs
function wwtc:ScanGuildBankTabs()
    if charData == nil then return end

    -- Short circuit if guild bank isn't open
    if not guildBankOpen then
        return
    end

    local now = time()
    WWTCSaved.guilds[guildName].scanTimes['bank'] = now

    -- Request data for every tab, but only once per guild bank opening or we scan infinitely
    if guildBankQueried == false then
        for tabIndex = 1, GetNumGuildBankTabs() do
            QueryGuildBankTab(tabIndex)
        end
        guildBankQueried = true
    end

    for tabIndex = 1, GetNumGuildBankTabs() do
        local tabKey = "t"..tabIndex

        WWTCSaved.guilds[guildName].items[tabKey] = {}
        local tab = WWTCSaved.guilds[guildName].items[tabKey]

        for slotIndex = 1, SLOTS_PER_GUILD_BANK_TAB do
            local link = GetGuildBankItemLink(tabIndex, slotIndex)
            if link ~= nil then
                if string.find(link, '\Hitem:82800:') then
                    scanTooltip:ClearLines()
                    local speciesId, level, breedQuality = scanTooltip:SetGuildBankItem(tabIndex, slotIndex)
                    tab["s"..slotIndex] = table.concat({
                        'pet',
                        speciesId,
                        level,
                        breedQuality,
                    }, ':')

                else
                    local _, itemCount, _, _, _ = GetGuildBankItemInfo(tabIndex, slotIndex)
                    local parsed = wwtc:ParseItemLink(link, itemCount)
                    tab["s"..slotIndex] = parsed
                end
            end
        end
    end
end

-- Scan covenant
local function SortTalents(talentA, talentB)
    return talentA.tier < talentB.tier
end

function wwtc:ScanCovenants()
    if charData == nil then return end

    local now = time()

    -- 1=Kyrian 2=Venthyr 3=NightFae 4=Necrolord
    local covenantId = C_Covenants.GetActiveCovenantID()
    if covenantId == 0 then return end

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
    local covenant = ns.covenants[covenantId]
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
    for i = 1, #charData.covenants do
        if charData.covenants[i].id == covenantId then
            charData.covenants[i] = covenantData
            found = true
            break
        end
    end

    if found == false then
        charData.covenants[#charData.covenants + 1] = covenantData
    end
end

-- Scan achievements
function wwtc:ScanAchievements()
    if charData == nil then return end

    charData.achievements = {}
    charData.scanTimes['achievements'] = time()

    for _, achievementId in ipairs(ns.achievements) do
        local criteria = {}
        local earnedByCharacter = select(13, GetAchievementInfo(achievementId))

        if not earnedByCharacter then
            local numCriteria = GetAchievementNumCriteria(achievementId)
            for i = 1, numCriteria do
                local _, _, _, quantity = GetAchievementCriteriaInfo(achievementId, i)
                table.insert(criteria, quantity)
            end
        end

        charData.achievements[#charData.achievements + 1] = {
            id = achievementId,
            earned = earnedByCharacter,
            criteria = criteria,
        }
    end
end

-- Scan currencies
function wwtc:ScanCurrencies()
    if charData == nil then return end

    charData.currencies = {}
    charData.scanTimes["currencies"] = time()

    for _, currencyID in ipairs(ns.currencies) do
        local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(currencyID)
        if currencyInfo ~= nil then
            -- quantity:max:isWeekly:weekQuantity:weekMax:isMovingMax:totalQuantity
            charData.currencies[currencyID] = table.concat({
                currencyInfo.quantity,
                currencyInfo.maxQuantity,
                currencyInfo.canEarnPerWeek and 1 or 0,
                currencyInfo.quantityEarnedThisWeek,
                currencyInfo.maxWeeklyQuantity,
                currencyInfo.useTotalEarnedForMaxQty and 1 or 0,
                currencyInfo.totalEarned,
            }, ':')
        end
    end
end

-- Scan instance/world boss lockouts
function wwtc:ScanLockouts()
    if charData == nil then return end

    charData.lockouts = {}

    local now = time()
    charData.scanTimes["lockouts"] = now

    local dailyReset = now + C_DateAndTime.GetSecondsUntilDailyReset()
    local weeklyReset = now + C_DateAndTime.GetSecondsUntilWeeklyReset()

    -- Instances
    for i = 1, GetNumSavedInstances() do
        local instanceName, _, instanceReset, instanceDifficulty, locked, _, _,
            _, _, _, maxBosses, defeatedBosses = GetSavedInstanceInfo(i)

        if instanceReset > 0 then
            instanceReset = now + instanceReset
        end

        -- Get saved boss names
        local bosses, j = {}, 1
        local name, _, dead = GetSavedInstanceEncounterInfo(i, j)
        while name do
            bosses[#bosses + 1] = table.concat({
                dead and 1 or 0,
                name,
            }, ':')

            j = j + 1
            name, _, dead = GetSavedInstanceEncounterInfo(i, j)
        end

        charData.lockouts[#charData.lockouts+1] = {
            id = instanceNameToId[instanceName],
            name = instanceName,
            resetTime = instanceReset,
            bosses = bosses,
            difficulty = instanceDifficulty,
            defeatedBosses = defeatedBosses,
            locked = locked,
            maxBosses = maxBosses,
        }
    end

    -- World bosses
    --for i = 1, GetNumSavedWorldBosses() do
    --    local instanceName, worldBossID, instanceReset = GetSavedWorldBossInfo(i)
    --    charData.lockouts[#charData.lockouts+1] = {
    --        name = instanceName,
    --        resetTime = now + instanceReset,
    --        difficulty = 0,
    --        defeatedBosses = 1,
    --        maxBosses = 1,
    --    }
    --end

    -- LFG lockouts are weird
    for _, instance in pairs(ns.instances) do
        local availableAll, availablePlayer = IsLFGDungeonJoinable(instance.dungeonId)
        if availableAll then
            local locked, _ = GetLFGDungeonRewards(instance.dungeonId)
            if locked then
                local instanceName, _ = GetLFGDungeonInfo(instance.dungeonId)
                charData.lockouts[#charData.lockouts+1] = {
                    id = 200000 + instance.dungeonId,
                    name = instanceName,
                    resetTime = dailyReset,
                    bosses = {
                        "1:"..instanceName,
                    },
                    difficulty = 1,
                    defeatedBosses = 1,
                    locked = true,
                    maxBosses = 1,
                }
            end
        end
    end

    -- Other world bosses
    for questID, questData in pairs(ns.worldBossQuests) do
        groupId, groupName, bossName, isDaily = unpack(questData)
        if C_QuestLog.IsQuestFlaggedCompleted(questID) then
            local resetTime
            if isDaily == true then
                resetTime = dailyReset
            else
                resetTime = weeklyReset
            end

            charData.lockouts[#charData.lockouts+1] = {
                id = groupId,
                name = groupName,
                resetTime = resetTime,
                bosses = {
                    "1:"..bossName,
                },
                difficulty = 0,
                defeatedBosses = 1,
                locked = true,
                maxBosses = 1,
                weeklyQuest = true,
            }
        end
    end
end

-- Scan quests
function wwtc:ScanQuests()
    if charData == nil then return end

    charData.dailyQuests = {}
    charData.otherQuests = {}
    charData.progressQuests = {}

    local now = time()
    charData.scanTimes["quests"] = time()

    local dailyReset = now + C_DateAndTime.GetSecondsUntilDailyReset()
    local weeklyReset = now + C_DateAndTime.GetSecondsUntilWeeklyReset()

    local biweeklyReset = weeklyReset - (3.5 * 24 * 60 * 60)
    if biweeklyReset < now then
        biweeklyReset = weeklyReset
    end

    for _, questID in ipairs(ns.otherQuests) do
        if C_QuestLog.IsQuestFlaggedCompleted(questID) then
            charData.otherQuests[#charData.otherQuests + 1] = questID
        end
    end

    for _, questID in ipairs(ns.scanQuests) do
        if C_QuestLog.IsQuestFlaggedCompleted(questID) then
            charData.dailyQuests[#charData.dailyQuests + 1] = questID
        end
    end

    for questKey, questData in pairs(ns.progressQuests) do
        local prog = { status = 0 }
        if questData[1] == 'weekly' then
            prog.reset = weeklyReset
        elseif questData[1] == 'biweekly' then
            prog.reset = biweeklyReset
        end

        for _, questId in ipairs(questData[2]) do
            -- Quest is completed
            if C_QuestLog.IsQuestFlaggedCompleted(questId) then
                prog.id = questId
                prog.name = QuestUtils_GetQuestName(questId)
                prog.status = 2
                break

            -- Quest is in progress, check progress
            elseif C_QuestLog.IsOnQuest(questId) then
                --local index = C_QuestLog.GetLogIndexForQuestID(questId)
                --local description, _, _ = GetQuestLogLeaderBoard(1, index)
                local objectives = C_QuestLog.GetQuestObjectives(questId)
                if objectives ~= nil then
                    local obj = objectives[1]
                    prog.id = questId
                    prog.name = QuestUtils_GetQuestName(questId)
                    prog.status = 1
                    prog.text = obj.text
                    prog.type = obj.type

                    if obj.type == 'progressbar' then
                        prog.have = GetQuestProgressBarPercent(questId)
                        prog.need = 100
                    else
                        prog.have = obj.numFulfilled
                        prog.need = obj.numRequired
                    end

                    break
                end
            end
        end

        if prog.status > 0 then
            charData.progressQuests[#charData.progressQuests + 1] = table.concat({
                questKey,
                prog.id,
                prog.name,
                prog.status,
                prog.reset,
                prog.have,
                prog.need,
                prog.type,
                prog.text,
            }, '|')
        end
    end
end

-- Scan mythic plus dungeons
function wwtc:ScanMythicPlus()
    if charData == nil then return end

    local now = time()
    charData.scanTimes["mythicPlus"] = now
    charData.mythicPlus = {
        maps = {},
        season = C_MythicPlus.GetCurrentSeason(),
    }

    local maps = C_ChallengeMode.GetMapTable()
    for i = 1, #maps do
        local affixScores, overallScore = C_MythicPlus.GetSeasonBestAffixScoreInfoForMap(maps[i])
        charData.mythicPlus.maps[#charData.mythicPlus.maps + 1] = {
            mapId = maps[i],
            affixScores = affixScores,
            overallScore = overallScore,
        }
    end
end

-- Scan transmog
function wwtc:ScanTransmog()
    if charData == nil then return end

    charData.scanTimes["transmog"] = time()
    local sources = {}
    local transmog = {}

    -- Try the hack that TransmogRoulette uses to fix the category bug
    -- https://github.com/semlar/TransmogRoulette/blob/181615d0bb7fb19992bbcefae7f5c6970865e52b/TransmogRoulette.xml#L119
    --C_Timer.After(1, function()
    for categoryID = 0, 29 do
        local appearances = C_TransmogCollection.GetCategoryAppearances(categoryID)
        for _, appearance in pairs(appearances) do
            if appearance.isCollected then
                transmog[appearance.visualID] = true
            end
        end
    end
    --end)

    for appearanceId, _ in pairs(transmog) do
        local sources = C_TransmogCollection.GetAppearanceSources(appearanceId)
        for _, source in ipairs(sources) do
            if source.isCollected then
                local sourceKey = string.format("%d_%d", source.itemID, source.itemModID)
                WWTCSaved.transmogSourcesV2[sourceKey] = true
            end
        end
    end

    if oldScannedTransmog ~= #transmog then
        print("WoWthing_Collector: found", #transmog, "transmog appearances")
        oldScannedTransmog = #transmog
    end

    local keys = {}
    for key in pairs(transmog) do
        keys[#keys + 1] = key
    end

    table.sort(keys)
    charData.transmog = table.concat(keys, ':')
end

-- Scan dirtyVault
function wwtc:ScanVault()
    if charData == nil then return end

    local now = time()
    charData.scanTimes["vault"] = now
    charData.vault = {}

    -- Mythic dungeons
    charData.mythicDungeons = {}
    local runs = C_MythicPlus.GetRunHistory(false, true) -- includePreviousWeeks, includeIncompleteRuns
    for i = 1, #runs do
        local run = runs[i]
        charData.mythicDungeons[i] = {
            map = run.mapChallengeModeID,
            level = run.level,
        }
    end

    -- Vault completion
    local activities = C_WeeklyRewards.GetActivities()
    for i = 1, #activities do
        -- [1]={
        --      threshold=10,
        --      type=1,
        --      index=3,
        --      progress=8,
        --      level=0,
        --      rewards={
        --      },
        --      id=34
        -- },
        local activity = activities[i]
        -- We only care about 1 (MythicPlus), 2 (RankedPvP), 3 (Raid)
        if activity.type >= 1 and activity.type <= 3 then
            charData.vault[activity.type] = charData.vault[activity.type] or {}
            charData.vault[activity.type][activity.index] = {
                level = activity.level,
                progress = activity.progress,
                threshold = activity.threshold,
            }
        end
    end
end

-- Scan callings
function wwtc:ScanCallings()
    if charData == nil then return end

    local now = time()
    charData.scanTimes["callings"] = now

    if callingData == nil then return end
    if not C_CovenantCallings.AreCallingsUnlocked() then return end

    local callings = {}
    local dailyReset = now + C_DateAndTime.GetSecondsUntilDailyReset()
    for i = 1, 3 do
        callings[i] = {
            completed = true,
            expires = dailyReset + ((i - 1) * 24 * 60 * 60),
        }
    end

    -- questID                  number
    -- factionID                number
    -- icon                     number
    -- numObjectives            number
    -- turninRequirementText    string?
    for _, calling in ipairs(callingData) do
        local timeLeft = C_TaskQuest.GetQuestTimeLeftMinutes(calling.questID)
        if not timeLeft then
            C_CovenantCallings.RequestCallings()
            return
        end

        local index = 3
        if timeLeft < 1440 then
            index = 1
        elseif timeLeft < 2880 then
            index = 2
        end

        callings[index].completed = C_QuestLog.IsQuestFlaggedCompleted(calling.questID)
    end

    charData.callings = callings

    return
end

-- Scan trade skills for cooldowns
function wwtc:ScanTradeSkills()
    if charData == nil then return end

    -- Don't care about tradeskills that aren't our own
    if IsTradeSkillGuild() or IsTradeSkillLinked() then
        return
    end

    local now = time()
    for i = 1, GetNumTradeSkills() do
        local link = GetTradeSkillRecipeLink(i)
        if link then
            local spellID = tonumber(link:match("\|Henchant:(%d+)\|h"))
            if spellID and tradeSkills[spellID] == true then
                local cooldown = GetTradeSkillCooldown(i)
                if cooldown then
                    charData.tradeSkills[spellID] = now + cooldown
                else
                    charData.tradeSkills[spellID] = nil
                end
            end
        end
    end
end

-- Hook various Blizzard_Collections things for scanning
function wwtc:HookCollections()
    if not IsAddOnLoaded("Blizzard_Collections") then
        UIParentLoadAddOn("Blizzard_Collections")
        return
    end

    if hookedCollections then return end

    -- Hook heirlooms
    local hlframe = _G["HeirloomsJournal"]
    if hlframe then
        hlframe:HookScript("OnShow", function(self)
            wwtc:ScanHeirlooms()
        end)
    else
        print("WoWthing_Collector: unable to hook 'HeirloomsJournal' frame!")
    end

    -- Hook toys
    local tbframe = _G["ToyBox"]
    if tbframe then
        tbframe:HookScript("OnShow", function(self)
            wwtc:ScanToys(false)
        end)
    else
        print("WoWthing_Collector: unable to hook 'ToyBox' frame!")
    end

    -- Hook transmog
    local tmogframe = _G["WardrobeCollectionFrame"]
    if tmogframe then
        tmogframe:HookScript("OnShow", function(self)
            dirtyTransmog = true
        end)
    else
        print("WoWthing_Collector: unable to hook 'WardrobeCollectionFrame' frame!")
    end

    hookedCollections = true
end

-- Scan heirlooms
function wwtc:ScanHeirlooms()
    if charData == nil then return end

    charData.scanTimes['heirlooms'] = time()
    WWTCSaved.heirlooms = {}

    for i = 1, C_Heirloom.GetNumDisplayedHeirlooms() do
        local itemID = C_Heirloom.GetHeirloomItemIDFromDisplayedIndex(i)
        -- name, itemEquipLoc, isPvP, itemTexture, upgradeLevel, source, searchFiltered, effectiveLevel, minLevel, maxLevel
        if C_Heirloom.PlayerHasHeirloom(itemID) then
            local _, _, _, _, upgradeLevel = C_Heirloom.GetHeirloomInfo(itemID)
            WWTCSaved.heirlooms[itemID] = upgradeLevel
        end
    end
end

-- Scan mounts
function wwtc:ScanMounts()
    if charData == nil then return end

    charData.scanTimes['mounts'] = time()
    charData.mounts = {}

    local mountIDs = C_MountJournal.GetMountIDs()
    for _, mountID in ipairs(mountIDs) do
        local _, spellID, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(mountID)
        if isCollected and checkMounts[spellID] then
            charData.mounts[#charData.mounts+1] = spellID
        end
    end
end

-- Scan pets
function wwtc:ScanPets()
    if charData == nil then return end

    charData.scanTimes['pets'] = time()
    charData.pets = {}

    for i = 1, C_PetJournal.GetNumPets() do
        local petID, speciesID, owned = C_PetJournal.GetPetInfoByIndex(i)
        if owned and checkPets[speciesID] then
            local _, customName, level, _, _, _, isFavorite, petName = C_PetJournal.GetPetInfoByPetID(petID)
            local _, _, _, _, rarity = C_PetJournal.GetPetStats(petID)
            charData.pets[#charData.pets+1] = {
                petID = checkPets[speciesID],
                favourite = isFavorite,
                guid = petID,
                level = level,
                name = customName or petName,
                quality = rarity,
            }
        end
    end
end

-- Scan reputations
function wwtc:ScanReputations()
    if charData == nil then return end

    charData.scanTimes['reputations'] = time()

    charData.paragons = {}
    charData.reputations = {}

    for _, factionID in ipairs(checkReputations) do
        local _, _, _, _, _, barValue = GetFactionInfoByID(factionID)
        charData.reputations[factionID] = barValue
    end

    for _, friendshipID in ipairs(checkFriendships) do
        local _, friendRep = GetFriendshipReputation(friendshipID)
        charData.reputations[friendshipID] = friendRep
    end

    for i, factionID in ipairs(paragonReputations) do
        if C_Reputation.IsFactionParagon(factionID) then 
            local currentValue, threshold, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID)
            -- value:max:hasReward
            charData.paragons[factionID] = table.concat({
                currentValue,
                threshold,
                hasRewardPending and 1 or 0,
            }, ':')
        end
    end
end

-- Scan Torghast
function wwtc:ScanTorghast()
    if charData == nil then return end

    local now = time()
    charData.scanTimes["torghast"] = now

    charData.torghast = {}

    -- Into Torghast, intro quest
    if C_QuestLog.IsQuestFlaggedCompleted(60136) then
        for _, widget in ipairs(torghastWidgets) do
            local name = C_UIWidgetManager.GetTextWithStateWidgetVisualizationInfo(widget.name)
            local level = C_UIWidgetManager.GetTextWithStateWidgetVisualizationInfo(widget.level)

            if name and level and name.shownState == 1 then
                charData.torghast[#charData.torghast + 1] = {
                    level = tonumber(strmatch(level.text, '|cFF00FF00.-(%d+).+|r')),
                    name = strmatch(name.text, '|n|cffffffff(.+)|r'),
                }
            end
        end
    end
end

-- Scan toys
function wwtc:ScanToys(resetToyBox)
    if charData == nil then return end

    charData.scanTimes['toys'] = time()

    local toys = {}
    for _, toyId in pairs(WWTCSaved.toys) do
        toys[toyId] = true
    end

    -- Reset toy box to show everything
    if resetToyBox == true then
        C_ToyBox.SetAllSourceTypeFilters(true)
        C_ToyBox.SetCollectedShown(true)
        C_ToyBox.SetUncollectedShown(true)
        C_ToyBox.SetUnusableShown(true)
        C_ToyBox.SetFilterString("")
    end

    local numToys = C_ToyBox.GetNumToys()
    for i = 1, numToys do
        local itemID = C_ToyBox.GetToyFromIndex(i)
        if itemID > 0 and PlayerHasToy(itemID) then
            toys[itemID] = true
        end
    end

    WWTCSaved.toys = {}
    for itemID, _ in pairs(toys) do
        WWTCSaved.toys[#WWTCSaved.toys + 1] = itemID
    end

    if #WWTCSaved.toys > maxScannedToys then
        if maxScannedToys > 0 then
            print("WoWthing_Collector: scanned", maxScannedToys, "toys")
        end
        maxScannedToys = #WWTCSaved.toys
    end
end

function wwtc:ScanOrderHallResearch()
    if charData == nil then return end

    local talentTreeIDs = C_Garrison.GetTalentTreeIDsByClassID(Enum.GarrisonType.Type_7_0, charClassID)
    if talentTreeIDs and talentTreeIDs[1] then
        charData.orderHallResearch = {}

        local talentTree = C_Garrison.GetTalentTreeInfo(talentTreeIDs[1])
        for _, talent in ipairs(talentTree.talents) do
            if talent.selected then
                local finishes = 0
                if talent.isBeingResearched then
                    finishes = talent.researchStartTime + talent.researchDuration
                end
                charData.orderHallResearch[talent.tier+1] = {
                    id = talent.id,
                    finishes = finishes,
                }
            end
        end
    end
    -- {
    --     ["isBeingResearched"] = true,
    --     ["description"] = "Increase the number of Legendary items you can equip by 1.",
    --     ["perkSpellID"] = 0,
    --     ["researchCost"] = 5000,
    --     ["researchDuration"] = 86400,
    --     ["tier"] = 5,
    --     ["selected"] = true,
    --     ["icon"] = 1247265,
    --     ["researched"] = false,
    --     ["talentAvailability"] = 8,
    --     ["id"] = 423,
    --     ["researchCurrency"] = 1220,
    --     ["name"] = "Demonic Fate",
    --     ["researchTimeRemaining"] = 35918,
    --     ["uiOrder"] = 0,
    --     ["researchGoldCost"] = 0,
    --     ["researchStartTime"] = 1524344516,
    -- }, -- [14]
end

-------------------------------------------------------------------------------
-- Util functions
-------------------------------------------------------------------------------
-- Parse an item link and return useful information
function wwtc:ParseItemLink(link, count)
    local parts = { strsplit(":", link) }

    if string.find(parts[1], '\|Hbattlepet') then
        return table.concat({
            'pet',
            parts[2], -- speciesID
            parts[3], -- level
            parts[4], -- quality
        }, ':')
    end

    local item = {
        count = count,
        itemID = tonumber(parts[2]),
        bonusIDs = {},
        gems = {},
    }

    if parts[3] ~= '' then
        item.enchantID = tonumber(parts[3])
    end

    if parts[4] ~= '' then
        for i = 4, 7 do
            if parts[i] then
                item.gems[#item.gems + 1] = tonumber(parts[i])
            end
        end
    end

    if parts[8] ~= '' then
        item.suffixID = tonumber(parts[8])
    end

    -- 9 = uniqueID
    -- 10 = linkLevel
    -- 11 = specializationID
    -- 12 = modifiersMask

    if parts[13] ~= '' then
        item.context = tonumber(parts[13])
    end

    local numBonusIDs = tonumber(parts[14])
    if numBonusIDs ~= nil then
        for i = 15, 14 + numBonusIDs do
            item.bonusIDs[#item.bonusIDs + 1] = tonumber(parts[i])
        end
    end

    -- 15 + numBonusIds = numModifiers
    -- <modifiers>

    local effectiveILvl, _, _ = GetDetailedItemLevelInfo(link)
    item.itemLevel = effectiveILvl

    item.quality = C_Item.GetItemQualityByID(link)

    -- count:id:context:enchant:ilvl:quality:suffix:bonusIDs:gems
    return table.concat({
        item.count,
        item.itemID,
        item.context or 0,
        item.enchantID or 0,
        item.itemLevel or 0,
        item.quality or 0,
        item.suffixID or 0,
        table.concat(item.bonusIDs, ','),
        table.concat(item.gems, ','),
    }, ':')

    --return item
end

-- Returns the daily quest reset time in the local timezone
function wwtc:GetDailyResetTime()
    local resetTime = GetQuestResetTime()
    if not resetTime or resetTime <= 0 or resetTime > (24 * 60 * 60) + 30 then
        return nil
    end
    return time() + resetTime
end

function wwtc:GetItemLevel(itemLink)
    local effectiveLevel, _, _ = GetDetailedItemLevelInfo(itemLink)
    return effectiveLevel
end

-------------------------------------------------------------------------------

SLASH_WWTC1 = "/wwtc"
SlashCmdList["WWTC"] = function(msg)
    wwtc:ScanAchievements()
end

SLASH_RL1 = "/rl"
SlashCmdList["RL"] = function(msg)
    ReloadUI()
end
