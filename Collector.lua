local an, ns = ...

local _G = getfenv(0)


-- Things
local wwtc = {}
local charClassID, charData, charName, guildName, playedLevel, playedLevelUpdated, playedTotal, playedTotalUpdated, regionName
local loggingOut = false
local bankOpen, guildBankOpen, reagentBankUpdated, transmogOpen = false, false, false, false
local maxScannedToys = 0
local dirtyAchievements, dirtyAuras, dirtyBags, dirtyChromieTime, dirtyCovenant, dirtyCurrencies,
    dirtyEquipment, dirtyGarrisonTrees, dirtyHeirlooms, dirtyLocation, dirtyLockouts, dirtyMounts,
    dirtyMythicPlus, dirtyPets, dirtyQuests, dirtyReputations, dirtyRested, dirtySpells, dirtyToys,
    dirtyTransmog, dirtyVault, dirtyXp =
    false, false, false, false, false, false, false, false, false, false, false, false, false, false,
    false, false, false, false, false, false, false, false
local dirtyCallings, callingData = false, nil
local dirtyBag, dirtyGuildBank, guildBankQueried, requestingPlayedTime = {}, false, false, true

local transmogLocation = TransmogUtil.GetTransmogLocation("HEADSLOT", Enum.TransmogType.Appearance, Enum.TransmogModification.Main)
local transmogSlots = {}

-- Local globals
local C_CurrencyInfo_GetCurrencyInfo, C_TransmogCollection_GetAppearanceSources, C_TransmogCollection_GetCategoryAppearances, C_QuestLog_IsQuestFlaggedCompleted = C_CurrencyInfo.GetCurrencyInfo, C_TransmogCollection.GetAppearanceSources, C_TransmogCollection.GetCategoryAppearances, C_QuestLog.IsQuestFlaggedCompleted

local NUM_TOTAL_BAG_FRAMES = _G.NUM_TOTAL_BAG_FRAMES

-- Libs
local LibRealmInfo = LibStub('LibRealmInfo17janekjl')

-- Default SavedVariables
local defaultWWTCSaved = {
    version = 9158,
    chars = {},
    guilds = {},
    heirloomsV2 = {},
    quests = {},
    toys = {},
    transmogSourcesV2 = {},
}

local instanceNameToId = {}


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


-- Misc constants
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
local frame, events = CreateFrame("FRAME", "WoWthing_Collector"), {}

-- Fires when the addon has finished loading
-- function events:ADDON_LOADED(name)
--     -- Damn Pet Journal!
--     if name == "Blizzard_Collections" then
--         wwtc:HookCollections()
--     end
-- end

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
    wwtc:UpdateCharacterData()
    
    dirtyAuras = true
    dirtyChromieTime = true
    dirtyCovenant = true
    dirtyCurrencies = true
    dirtyEquipment = true
    dirtyGarrisonTrees = true
    dirtyHeirlooms = true
    dirtyLocation = true
    dirtyTransmog = true
    dirtyVault = true
    dirtyXp = true

    wwtc:SetPlayerBagsDirty()
end
--
function events:PLAYER_XP_UPDATE(target)
    dirtyXp = true
end
-- Zone changed
function events:ZONE_CHANGED()
    dirtyLocation = true
end
function events:ZONE_CHANGED_INDOORS()
    dirtyLocation = true
end
function events:ZONE_CHANGED_NEW_AREA()
    dirtyLocation = true
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
-- Fires when the player starts or stops resting
function events:PLAYER_UPDATE_RESTING()
    dirtyRested = true
end
-- Fires when the player's amount of rested XP changes
function events:UPDATE_EXHAUSTION()
    dirtyRested = true
end
-- Fires when a new spell/ability is added to the spellbook
function events:LEARNED_SPELL_IN_TAB()
    dirtySpells = true
end
-- Fires when auras update
function events:UNIT_AURA(unitTarget)
    if unitTarget == 'player' then
        dirtyAuras = true
    end
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
-- Fires when achievement criteria updates
function events:CRITERIA_UPDATE()
    dirtyAchievements = true
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
-- Fires when the contents of a bag changes
-- function events:BAG_UPDATE(bagID)
--     dirtyBag[bagID] = true
--     dirtyBags = true -- TODO remove this if Blizzard ever fixes DELAYED not triggering
-- end
function events:BAG_UPDATE_DELAYED()
    dirtyBags = true
end
-- ITEM_CHANGED
-- Fires when the bank is opened
function events:BANKFRAME_OPENED()
    -- Force a bag scan of the bank now that it's open
    bankOpen = true
    dirtyBag[Enum.BagIndex.Bank] = true
    dirtyBag[Enum.BagIndex.Reagentbank] = true
    for i = Enum.BagIndex.BankBag_1, Enum.BagIndex.BankBag_7 do
        dirtyBag[i] = true
    end
    dirtyBags = true
end
-- Fires when the bank is closed
function events:BANKFRAME_CLOSED()
    bankOpen = false
end
-- Fires when something changes in the reagent bank
function events:PLAYERREAGENTBANKSLOTS_CHANGED()
    dirtyBag[Enum.BagIndex.Reagentbank] = true
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
-- function events:COMPANION_UPDATE()
--     dirtyMounts = true
--     dirtyPets = true
-- end
-- -- Fires when a new companion is learned
-- function events:COMPANION_LEARNED()
--     dirtyMounts = true
--     dirtyPets = true
-- end
-- -- Fires when the mount journal usability list changes (move between inside/outside/water/etc)
-- function events:MOUNT_JOURNAL_USABILITY_CHANGED()
--     dirtyMounts = true
-- end
-- -- Fires when the pet journal list updates
-- function events:PET_JOURNAL_LIST_UPDATE()
--     dirtyPets = true
-- end
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
-- Fires when you stop using a fancy frame
function events:PLAYER_INTERACTION_MANAGER_FRAME_HIDE(type)
    if type == Enum.PlayerInteractionType.ChromieTime then
        dirtyChromieTime = true
    end
end
-- Vault
function events:WEEKLY_REWARDS_UPDATE()
    dirtyVault = true
end
-- Quest changes, spammy
function events:QUEST_LOG_UPDATE()
    dirtyChromieTime = true
    dirtyQuests = true
end
-- Finished looting something
function events:LOOT_CLOSED()
    dirtyLockouts = true
    dirtyQuests = true
end
-- Popup "you got loot" box
function events:SHOW_LOOT_TOAST()
    wwtc:SetPlayerBagsDirty()
    dirtyLockouts = true
    dirtyQuests = true
end
-- Vague about what this does, but it includes war mode
function events:PLAYER_FLAGS_CHANGED(unitId)
    if unitId == 'player' then
        dirtyRested = true
        wwtc:UpdateWarMode()
    end
end
-- Garrisons
function events:GARRISON_TALENT_COMPLETE()
    dirtyGarrisonTrees = true
end
function events:GARRISON_TALENT_RESEARCH_STARTED()
    dirtyGarrisonTrees = true
end
function events:GARRISON_TALENT_UPDATE()
    dirtyGarrisonTrees = true
end
-- Items
function events:PROFESSION_EQUIPMENT_CHANGED()
    dirtyEquipment = true
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
function events:TRANSMOGRIFY_OPEN()
    transmogOpen = true
end
function events:TRANSMOGRIFY_CLOSE()
    transmogOpen = false
end
function events:TRANSMOG_COLLECTION_SOURCE_ADDED()
    dirtyTransmog = true
end
function events:TRANSMOG_COLLECTION_SOURCE_REMOVED()
    dirtyTransmog = true
end
function events:TRANSMOG_COLLECTION_UPDATED()
    dirtyTransmog = true
end
function events:HEIRLOOMS_UPDATED()
    dirtyHeirlooms = true
end

-------------------------------------------------------------------------------
-- Call functions in the events table for events
frame:SetScript("OnEvent", function(self, event, ...)
    -- if event ~= "CRITERIA_UPDATE" and event ~= "UNIT_AURA" then print(event) end
    events[event](self, ...)
end)

-- Register every event in the events table
for k, v in pairs(events) do
    frame:RegisterEvent(k)
end

-------------------------------------------------------------------------------
-- Timer to do spammy things
function wwtc:Timer()
    if charData == nil then return end

    if dirtyAchievements then
        dirtyAchievements = false
        wwtc:ScanAchievements()
    end

    if dirtyAuras then
        dirtyAuras = false
        wwtc:ScanAuras()
    end

    if dirtyBags then
        dirtyBags = false
        wwtc:ScanBags()
    end

    if dirtyCallings then
        dirtyCallings = false
        wwtc:ScanCallings()
    end

    if dirtyChromieTime then
        dirtyChromieTime = false
        wwtc:ScanChromieTime()
    end

    if dirtyCovenant then
        dirtyCovenant = false
        wwtc:ScanCovenants()
    end

    if dirtyCurrencies then
        dirtyCurrencies = false
        wwtc:ScanCurrencies()
    end

    if dirtyEquipment then
        dirtyEquipment = false
        wwtc:ScanEquipment()
    end

    if dirtyGarrisonTrees then
        dirtyGarrisonTrees = false
        wwtc:ScanGarrisonTrees()
    end

    if dirtyGuildBank then
        dirtyGuildBank = false
        wwtc:ScanGuildBankTabs()
    end

    if dirtyHeirlooms then
        dirtyHeirlooms = false
        wwtc:ScanHeirlooms()
    end

    if dirtyLocation then
        dirtyLocation = false
        wwtc:ScanGarrisons()
        wwtc:ScanLocation()
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

    if dirtyQuests then
        dirtyQuests = false
        C_CovenantCallings.RequestCallings()
        wwtc:ScanQuests()
    end

    if dirtyReputations then
        dirtyReputations = false
        wwtc:ScanReputations()
    end

    if dirtyRested then
        dirtyRested = false
        wwtc:UpdateExhausted()
    end

    if dirtySpells then
        dirtySpells = false
        wwtc:ScanSpells()
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

    if dirtyXp then
        dirtyXp = false
        wwtc:ScanXP()
    end
end
-- Run the timer once per 1 second to do chunky things
local _ = C_Timer.NewTicker(1, function() wwtc:Timer() end, nil)

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

    WWTCSaved.heirloomsV2 = WWTCSaved.heirloomsV2 or {}
    WWTCSaved.quests = WWTCSaved.quests or {}
    WWTCSaved.transmogSourcesV2 = WWTCSaved.transmogSourcesV2 or {}

    WWTCSaved.honorLevel = 0
    WWTCSaved.honorCurrent = 0
    WWTCSaved.honorMax = 0

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
    charData.level = 0
    charData.levelXp = 0
    charData.mountSkill = 0
    charData.playedLevel = 0
    charData.playedTotal = 0
    charData.restedXP = 0

    charData.achievements = charData.achievements or {}
    charData.aurasV2 = charData.auras or {}
    charData.bags = charData.bags or {}
    charData.callings = charData.callings or {}
    charData.covenants = charData.covenants or {}
    charData.currencies = charData.currencies or {}
    charData.dailyQuests = charData.dailyQuests or {}
    charData.emissaries = charData.emissaries or {}
    charData.equipment = charData.equipment or {}
    charData.garrisons = charData.garrisons or {}
    charData.garrisonTrees = charData.garrisonTrees or {}
    charData.illusions = charData.illusions or ''
    charData.items = charData.items or {}
    charData.lockouts = charData.lockouts or {}
    charData.mounts = charData.mounts or {}
    charData.mythicDungeons = charData.mythicDungeons or {}
    charData.mythicPlusV2 = charData.mythicPlusV2 or {}
    charData.orderHallResearch = charData.orderHallResearch or {}
    charData.otherQuests = charData.otherQuests or {}
    charData.paragons = charData.paragons or {}
    charData.pets = charData.pets or {}
    charData.progressQuests = charData.progressQuests or {}
    charData.reputations = charData.reputations or {}
    charData.scanTimes = charData.scanTimes or {}
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

    -- Transmog slots shouldn't change?
    for categoryID = 1, 29 do
        local slot = CollectionWardrobeUtil.GetSlotFromCategoryID(categoryID)
        if slot ~= nil then
            transmogSlots[categoryID] = slot
        end
    end
end

function wwtc:Login()
    wwtc:Initialise()

    -- Try to hook things
    -- wwtc:HookCollections()

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
    WWTCSaved.heirlooms = nil
    WWTCSaved.transmogSources = nil

    -- Remove data for any characters not seen in the last 3 days
    local old = time() - (3 * 24 * 60 * 60)
    for cName, cData in pairs(WWTCSaved.chars) do
        if not cData.lastSeen or cData.lastSeen < old then
            WWTCSaved.chars[cName] = nil
        else
            cData.auras = nil
            cData.mythicPlus = nil
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

function wwtc:SetPlayerBagsDirty()
    for i = 0, NUM_TOTAL_BAG_FRAMES do
        dirtyBag[i] = true
    end
    dirtyBags = true
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

    if not loggingOut then
        dirtyQuests = true
        dirtyRested = true
        dirtySpells = true

        charData.copper = GetMoney()

        wwtc:UpdateHonor()
        wwtc:UpdateWarMode()

        wwtc:ScanAchievements()

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

function wwtc:ScanChromieTime()
    if charData == nil then return end

    charData.chromieTime = UnitChromieTimeID("player")
end

-- Update resting status and rested XP
function wwtc:UpdateExhausted()
    if charData == nil then return end

    charData.isResting = IsResting()
    charData.restedXP = GetXPExhaustion() or 0
end

function wwtc:UpdateHonor()
    WWTCSaved.honorLevel = UnitHonorLevel('player')
    WWTCSaved.honorCurrent = UnitHonor('player')
    WWTCSaved.honorMax = UnitHonorMax('player')
end

function wwtc:UpdateWarMode()
    if charData == nil then return end

    charData.isWarMode = C_PvP.IsWarModeDesired()
end

local scanningBags = false
local bagScanQueue
function wwtc:ScanBags()
    if scanningBags then return end

    bagScanQueue = {}
    for bagID, _ in pairs(dirtyBag) do
        tinsert(bagScanQueue, bagID)
        dirtyBag[bagID] = nil
    end

    C_Timer.After(0, function()
        wwtc:ScanBagQueue()
    end)

    scanningBags = true
end

-- Scan a specific bag
function wwtc:ScanBagQueue()
    if charData == nil then return end

    local bagID = tremove(bagScanQueue)
    if bagID == nil then
        scanningBags = false
        return
    end

    -- Short circuit if bank isn't open
    local isBank = (
        bagID == Enum.BagIndex.Bank or
        bagID == Enum.BagIndex.Reagentbank or
        (bagID >= Enum.BagIndex.BankBag_1 and bagID <= Enum.BagIndex.BankBag_7)
    )
    local scan = true

    if isBank and not bankOpen then
        scan = false
    end
    -- Reagent bank is weird, make sure that the bank is open or it was actually updated
    if bagID == Enum.BagIndex.Reagentbank then
        if not (bankOpen or reagentBankUpdated) then
            scan = false
        end
        reagentBankUpdated = false
    end

    local requestedData = false
    if scan then
        local now = time()

        if isBank then
            charData.scanTimes["bank"] = now
        else
            charData.scanTimes["bags"] = now

            -- Update mythic plus keystone since bags changed
            charData.keystoneInstance = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
            charData.keystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel()
        end

        charData.items["b"..bagID] = {}
        local bag = charData.items["b"..bagID]

        -- Update bag ID
        if bagID >= 1 then
            local bagItemID, _ = GetInventoryItemID('player', C_Container.ContainerIDToInventoryID(bagID))
            charData.bags["b"..bagID] = bagItemID
        end

        local numSlots = C_Container.GetContainerNumSlots(bagID)
        if numSlots > 0 then
            for slot = 1, numSlots do
                -- This always works, even if the full item data isn't cached
                local itemID = C_Container.GetContainerItemID(bagID, slot)
                if itemID then
                    if C_Item.IsItemDataCachedByID(itemID) then
                        local itemInfo = C_Container.GetContainerItemInfo(bagID, slot)
                        if itemInfo ~= nil and itemInfo.hyperlink ~= nil then
                            local parsed = wwtc:ParseItemLink(itemInfo.hyperlink, itemInfo.quality or -1, itemInfo.stackCount or 1)
                            bag["s"..slot] = parsed
                        end
                    else
                        C_Item.RequestLoadItemDataByID(itemID)
                        requestedData = true
                    end
                end
            end
        end
    end

    -- If we requested item data, come back and scan this bag again later
    if requestedData then
        dirtyBag[bagID] = true
    end

    -- If the scan queue still has bags, add a timer for the next one
    if #bagScanQueue > 0 then
        C_Timer.After(0, function()
            wwtc:ScanBagQueue()
        end)
    else
        scanningBags = false

        -- Queue another scan if any bags are dirty
        local bagKeys = wwtc:TableKeys(dirtyBag)
        if #bagKeys > 0 then
            dirtyBags = true
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
    -- if not guildBankOpen then
    --     return
    -- end

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
                    local tooltipData = C_TooltipInfo.GetGuildBankItem(tabIndex, slotIndex)

                    tab["s"..slotIndex] = table.concat({
                        'pet',
                        tooltipData['battlePetSpeciesID'],
                        tooltipData['battlePetLevel'],
                        tooltipData['battlePetBreedQuality'],
                    }, ':')

                else
                    local _, itemCount, _, _, itemQuality = GetGuildBankItemInfo(tabIndex, slotIndex)
                    local parsed = wwtc:ParseItemLink(link, itemQuality or -1, itemCount or 1)
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
    local animaInfo = C_CurrencyInfo_GetCurrencyInfo(1813)
    if animaInfo ~= nil then
        covenantData.anima = animaInfo.quantity
    end

    local soulsInfo = C_CurrencyInfo_GetCurrencyInfo(1810)
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
        -- This is nil if the achievement doesn't exist somehow
        if earnedByCharacter ~= nil then
            if not earnedByCharacter then
                local numCriteria = ns.achievementCriteria[achievementId] or GetAchievementNumCriteria(achievementId)
                for i = 1, numCriteria do
                    local success, _, _, _, quantity = pcall(GetAchievementCriteriaInfo, achievementId, i, true)
                    if success == false then
                        criteria = {}
                        break
                    end
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
end

function wwtc:ScanAuras()
    if charData == nil then return end

    charData.aurasV2 = {}

    local now = time()
    local uptime = GetTime() -- Blizzard why

    for _, spellID in ipairs(ns.auras) do
        local auraInfo = C_UnitAuras.GetPlayerAuraBySpellID(spellID)
        if auraInfo ~= nil then
            local expire = 0
            if auraInfo.expirationTime > 0 then
                expire = math.floor(now + (auraInfo.expirationTime - uptime))
            end

            charData.aurasV2[#charData.aurasV2 + 1] = table.concat({
                spellID,
                expire,
            }, ':')
        end
    end
end

-- Scan currencies
function wwtc:ScanCurrencies()
    if charData == nil then return end

    charData.currencies = {}
    charData.scanTimes["currencies"] = time()

    for _, currencyID in ipairs(ns.currencies) do
        local currencyInfo = C_CurrencyInfo_GetCurrencyInfo(currencyID)
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

function wwtc:ScanEquipment()
    if charData == nil then return end

    charData.equipment = {}
    for slot = 20, 30 do
        local itemLink = GetInventoryItemLink('player', slot)

        if itemLink ~= nil then
            local itemQuality = GetInventoryItemQuality('player', slot)
            -- Item isn't loaded yet, try again in a bit
            if itemQuality == nil then
                dirtyEquipment = true
            else
                charData.equipment[slot] = wwtc:ParseItemLink(itemLink, itemQuality, 1)
            end
        end
    end
end

function wwtc:ScanLocation()
    if charData == nil then return end

    charData.bindLocation = GetBindLocation()
    
    local areaText = GetAreaText()

    if areaText == nil then
        dirtyLocation = true
        return
    end

    local zoneParts = {
        areaText,
    }

    local realZoneText = GetRealZoneText()
    if realZoneText ~= nil and realZoneText ~= '' and realZoneText ~= zoneParts[#zoneParts] then
        table.insert(zoneParts, realZoneText)
    end

    local subZoneText = GetSubZoneText()
    if subZoneText ~= nil and subZoneText ~= '' and subZoneText ~= zoneParts[#zoneParts] then
        table.insert(zoneParts, subZoneText)
    end

    charData.currentLocation = table.concat(zoneParts, ' > ')
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
        local groupId, groupName, bossName, isDaily = unpack(questData)
        if C_QuestLog_IsQuestFlaggedCompleted(questID) then
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
    charData.emissaries = {}
    charData.otherQuests = {}
    charData.progressQuests = {}

    local now = time()
    charData.scanTimes["quests"] = now

    local dailyReset = now + C_DateAndTime.GetSecondsUntilDailyReset()
    local weeklyReset = now + C_DateAndTime.GetSecondsUntilWeeklyReset()

    local biweeklyReset = weeklyReset - (3.5 * 24 * 60 * 60)
    if biweeklyReset < now then
        biweeklyReset = weeklyReset
    end

    local accountQuests = {}
    for _, questID in ipairs(ns.accountQuests) do
        if C_QuestLog_IsQuestFlaggedCompleted(questID) then
            table.insert(accountQuests, questID)
        end
    end
    WWTCSaved.quests = accountQuests

    for _, questID in ipairs(ns.otherQuests) do
        if C_QuestLog_IsQuestFlaggedCompleted(questID) then
            charData.otherQuests[#charData.otherQuests + 1] = questID
        end
    end

    for _, questID in ipairs(ns.scanQuests) do
        if C_QuestLog_IsQuestFlaggedCompleted(questID) then
            charData.dailyQuests[#charData.dailyQuests + 1] = questID
        end
    end

    for questKey, questData in pairs(ns.progressQuests) do
        local prog = {
            reset = 0,
            status = 0,
            objectives = {}
        }

        if questData[1] == 'weekly' then
            prog.reset = weeklyReset
        elseif questData[1] == 'biweekly' then
            prog.reset = biweeklyReset
        end

        for _, questId in ipairs(questData[2]) do
            if questData[1] == 'wq' and prog.reset == 0 then
                local timeLeft = C_TaskQuest.GetQuestTimeLeftSeconds(questId)
                if timeLeft ~= nil then
                    prog.reset = now + timeLeft
                end
            end

            -- Quest is completed
            if C_QuestLog_IsQuestFlaggedCompleted(questId) then
                prog.id = questId
                prog.name = QuestUtils_GetQuestName(questId)
                prog.status = 2
                break

            -- Quest is in progress, check progress
            elseif C_QuestLog.IsOnQuest(questId) then
                local objectives = C_QuestLog.GetQuestObjectives(questId)
                if objectives ~= nil then
                    prog.id = questId
                    prog.name = QuestUtils_GetQuestName(questId)
                    prog.status = 1

                    for _, objective in ipairs(objectives) do
                        if objective ~= nil then
                            local objectiveData = {
                                ['type'] = objective.type,
                                ['text'] = gsub(
                                    objective.text,
                                    "%|A:Professions%-Icon%-Quality%-Tier(%d)%-Small:18:18:0:2%|a",
                                    "[[tier%1]]"
                                ),
                            }
    
                            if objective.type == 'progressbar' then
                                objectiveData.have = GetQuestProgressBarPercent(questId)
                                objectiveData.need = 100
                            else
                                objectiveData.have = objective.numFulfilled
                                objectiveData.need = objective.numRequired
                            end

                            table.insert(prog.objectives, table.concat({
                                objectiveData.type,
                                objectiveData.text,
                                objectiveData.have,
                                objectiveData.need,
                            }, ';'))
                        end
                    end
                    
                    -- Backup plan for weird quests like Timewalking item turnins
                    if #prog.objectives == 0 then
                        local oldQuestId = C_QuestLog.GetSelectedQuest()
                        C_QuestLog.SetSelectedQuest(questId)

                        table.insert(prog.objectives, table.concat({
                            'object',
                            GetQuestLogCompletionText() or '',
                            1,
                            1,
                        }, ';'))

                        C_QuestLog.SetSelectedQuest(oldQuestId)
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
                table.concat(prog.objectives, '_'),
            }, '|')
        end
    end

    -- Emissaries
    for _, emissary in ipairs(ns.emissaries) do
        charData.emissaries[emissary.expansion] = {}
        if C_QuestLog_IsQuestFlaggedCompleted(emissary.questId) then
            local bounties = C_QuestLog.GetBountiesForMapID(emissary.mapId)
            if bounties and #bounties > 0 then
                for i = 1, 3 do
                    charData.emissaries[emissary.expansion][i] = {
                        completed = true,
                        expires = dailyReset + ((i - 1) * 24 * 60 * 60),
                    }
                end

                -- { questID, factionID, icon, numObjectives, turninRequirementText }[]
                for i, bounty in ipairs(bounties) do
                    local timeLeft = C_TaskQuest.GetQuestTimeLeftMinutes(bounty.questID) or 0

                    local index = 3
                    if timeLeft < 1440 then
                        index = 1
                    elseif timeLeft < 2880 then
                        index = 2
                    end

                    local emissary = charData.emissaries[emissary.expansion][index]
                    emissary.completed = C_QuestLog_IsQuestFlaggedCompleted(bounty.questID)
                    emissary.questId = bounty.questID

                    local rewardCurrencyCount = GetNumQuestLogRewardCurrencies(bounty.questID)
                    local rewardItemCount = GetNumQuestLogRewards(bounty.questID)
                    local rewardMoney = GetQuestLogRewardMoney(bounty.questID)
                    
                    if rewardCurrencyCount > 0 or rewardItemCount > 0 or rewardMoney > 0 then
                        emissary.reward = {}
                        
                        if rewardMoney > 0 then
                            emissary.reward.money = rewardMoney
                        elseif rewardItemCount > 0 then
                            local itemIndex = QuestUtils_GetBestQualityItemRewardIndex(bounty.questID)
                            local _, _, quantity, quality, _, itemId, _ = GetQuestLogRewardInfo(itemIndex, bounty.questID)
                            emissary.reward.itemId = itemId
                            emissary.reward.quality = quality
                            emissary.reward.quantity = quantity
                        else
                            local _, _, quantity, currencyId = GetQuestLogRewardCurrencyInfo(1, bounty.questID)
                            emissary.reward.currencyId = currencyId
                            emissary.reward.quantity = quantity
                        end
                    end
                end
            end
        end
    end
end

-- Scan mythic plus dungeons
function wwtc:ScanMythicPlus()
    if charData == nil then return end

    local now = time()
    charData.scanTimes["mythicPlus"] = now

    charData.mythicPlusV2.seasons = charData.mythicPlusV2.seasons or {}
    charData.mythicPlusV2.weeks = charData.mythicPlusV2.weeks or {}

    local season = C_MythicPlus.GetCurrentSeason()
    charData.mythicPlusV2.seasons[season] = {}

    local maps = C_ChallengeMode.GetMapTable()
    for i = 1, #maps do
        local affixScores, overallScore = C_MythicPlus.GetSeasonBestAffixScoreInfoForMap(maps[i])
        charData.mythicPlusV2.seasons[season][i] = {
            mapId = maps[i],
            affixScores = affixScores,
            overallScore = overallScore,
        }
    end

    local weeklyReset = now + C_DateAndTime.GetSecondsUntilWeeklyReset()
    charData.mythicPlusV2.weeks[weeklyReset] = {}

    local runs = charData.mythicPlusV2.weeks[weeklyReset]
    local runHistory = C_MythicPlus.GetRunHistory(false, true)
    for _, run in ipairs(runHistory) do
        table.insert(runs, table.concat({
            run.mapChallengeModeID,
            run.completed and 1 or 0,
            run.level,
            run.runScore,
        }, ':'))
    end
end

-- Scan transmog
local scanningTransmog = false
local transmogScanQueue, transmogSettings, transmogTemp
function wwtc:ScanTransmog()
    if scanningTransmog then return end
    if charData == nil then return end

    charData.scanTimes["transmog"] = time()

    -- Illusions
    local illusions = {}
    local illusionData = C_TransmogCollection.GetIllusions()
    for _, illusion in ipairs(illusionData) do
        if illusion.isCollected then
            table.insert(illusions, illusion.sourceID)
        end
    end
    
    table.sort(illusions)
    charData.illusions = table.concat(illusions, ':')

    -- Save this to reset later
    transmogSettings = {}
    transmogSettings.showCollected = C_TransmogCollection.GetCollectedShown()
    transmogSettings.showUncollected = C_TransmogCollection.GetUncollectedShown()
    transmogSettings.sourceTypes = {}
    for index = 1, 6 do
        transmogSettings.sourceTypes[index] = C_TransmogCollection.IsSourceTypeFilterChecked(index)
    end
    
    if transmogOpen == false then
        C_TransmogCollection.SetAllCollectionTypeFilters(true)
        C_TransmogCollection.SetAllSourceTypeFilters(true)
    end

    -- Run this in a timer so that the filter changes take effect
    C_Timer.After(0, function()
        scanningTransmog = true
        transmogTemp = {}

        -- Manual checks
        for _, manualTransmog in ipairs(ns.transmog) do
            local have = C_TransmogCollection.PlayerHasTransmog(manualTransmog.itemId, manualTransmog.modifierId)
            if have then
                transmogTemp[manualTransmog.appearanceId] = true

                local sourceKey = string.format("%d_%d", manualTransmog.itemId, manualTransmog.modifierId)
                WWTCSaved.transmogSourcesV2[sourceKey] = true
            end
        end

        transmogScanQueue = {}
        for categoryID, _ in pairs(transmogSlots) do
            table.insert(transmogScanQueue, categoryID)
        end

        wwtc:ScanTransmogQueue()
    end)
end

function wwtc:ScanTransmogQueue()
    local categoryID = tremove(transmogScanQueue)

    local appearances = C_TransmogCollection_GetCategoryAppearances(categoryID, transmogLocation)
    for _, appearance in pairs(appearances) do
        if appearance.isCollected then
            local visualId = appearance.visualID
            transmogTemp[visualId] = true

            local sources = C_TransmogCollection_GetAppearanceSources(visualId, categoryID, transmogLocation)
            for _, source in ipairs(sources) do
                if source.isCollected then
                    local sourceKey = string.format("%d_%d", source.itemID, source.itemModID)
                    WWTCSaved.transmogSourcesV2[sourceKey] = true
                end
            end
        end
    end

    -- Still categories to scan, schedule next
    if #transmogScanQueue > 0 then
        C_Timer.After(0, function() wwtc:ScanTransmogQueue() end)
    -- All done
    else
        local keys = wwtc:TableKeys(transmogTemp)
        table.sort(keys)
        charData.transmog = table.concat(keys, ':')

        -- Reset settings
        if transmogOpen == false then
            C_TransmogCollection.SetCollectedShown(transmogSettings.showCollected)
            C_TransmogCollection.SetUncollectedShown(transmogSettings.showUncollected)
            for index = 1, 6 do
                C_TransmogCollection.SetSourceTypeFilter(index, transmogSettings.sourceTypes[index])
            end
        end

        scanningTransmog = false
    end
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

        callings[index].completed = C_QuestLog_IsQuestFlaggedCompleted(calling.questID)
        callings[index].questId = calling.questID
    end

    charData.callings = callings
end

-- Scan heirlooms
function wwtc:ScanHeirlooms()
    if charData == nil then return end

    WWTCSaved.heirloomsV2 = {}

    local itemIds = C_Heirloom.GetHeirloomItemIDs()
    for _, itemId in ipairs(itemIds) do
        local collected = C_Heirloom.PlayerHasHeirloom(itemId)
        local _, _, _, _, upgradeLevel = C_Heirloom.GetHeirloomInfo(itemId)
        WWTCSaved.heirloomsV2[#WWTCSaved.heirloomsV2 + 1] = table.concat({
            itemId,
            collected and 1 or 0,
            upgradeLevel or 0,
        }, ':')
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

    for _, factionID in ipairs(ns.reputations) do
        local _, _, _, _, _, barValue = GetFactionInfoByID(factionID)
        charData.reputations[factionID] = barValue
    end

    for _, friendshipID in ipairs(ns.friendships) do
        local _, friendRep = C_GossipInfo.GetFriendshipReputation(friendshipID)
        charData.reputations[friendshipID] = friendRep
    end

    for i, factionID in ipairs(ns.paragonReputations) do
        if C_Reputation.IsFactionParagon(factionID) then 
            local currentValue, threshold, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID)
            -- value:max:hasReward
            charData.paragons[factionID] = table.concat({
                currentValue or 0,
                threshold or 0,
                hasRewardPending and 1 or 0,
            }, ':')
        end
    end
end

-- Scan spells
function wwtc:ScanSpells()
    if charData == nil then return end

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

-- Garrison weirdness
function wwtc:ScanGarrisons()
    if charData == nil then return end

    for _, garrisonData in ipairs(ns.garrisons) do
        if garrisonData.mustBeInGarrison == false or C_Garrison.IsPlayerInGarrison(garrisonData.type) then
            wwtc:ScanGarrison(garrisonData)
        end
    end
end

function wwtc:ScanGarrison(garrisonData)
    local garrison
    for _, charGarrison in ipairs(charData.garrisons) do
        if charGarrison.type == garrisonData.type then
            garrison = charGarrison
            break
        end
    end

    if garrison == nil then
        garrison = {
            type = garrisonData.type
        }
        charData.garrisons[#charData.garrisons + 1] = garrison
    end

    garrison.scannedAt = time()

    local level, _ = C_Garrison.GetGarrisonInfo(garrisonData.type)
    garrison.level = level

    garrison.buildings = {}
    local buildings = C_Garrison.GetBuildings(garrisonData.type) or {}

    for _, building in ipairs(buildings) do
        -- id, name, textureKit, icon, description, rank, currencyID, currencyQty, goldQty,
        -- buildTime, needsPlan, isPrebuilt, possSpecs, upgrades, canUpgrade, isMaxLevel, hasFollowerSlot
        local _, name, _, _, _, rank = C_Garrison.GetBuildingInfo(building.buildingID)

        tinsert(garrison.buildings, {
            buildingId = building.buildingID,
            plotId = building.plotID,
            name = name,
            rank = rank,
        })
    end

    local treeIds = C_Garrison.GetTalentTreeIDsByClassID(garrisonData.type, charClassID)
    for _, treeId in ipairs(treeIds or {}) do
        wwtc:ScanGarrisonTree(treeId)
    end
end

function wwtc:ScanGarrisonTrees()
    if charData == nil then return end

    charData.scanTimes["garrisonTrees"] = time()
    charData.garrisonTrees = {}

    for _, treeId in ipairs(ns.garrisonTrees) do
        wwtc:ScanGarrisonTree(treeId)
    end
end

function wwtc:ScanGarrisonTree(treeId)
    charData.garrisonTrees[treeId] = {}

    local talentTree = C_Garrison.GetTalentTreeInfo(treeId)
    for _, talent in ipairs(talentTree.talents) do
        local finishes = 0
        if talent.isBeingResearched and talent.researchStartTime and talent.researchDuration then
            finishes = talent.researchStartTime + talent.researchDuration
        end

        charData.garrisonTrees[treeId][#charData.garrisonTrees[treeId] + 1] = table.concat({
            talent.id,
            talent.talentRank,
            finishes,
        }, ':')
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

function wwtc:ScanXP()
    if charData == nil then return end

    charData.level = UnitLevel('player')
    charData.levelXp = UnitXP('player')
end

-------------------------------------------------------------------------------
-- Util functions
-------------------------------------------------------------------------------
-- Parse an item link and return useful information
local parseItemLinkCache = {}
function wwtc:ParseItemLink(link, quality, count)
    local cached = parseItemLinkCache[link]
    if cached ~= nil then
        return table.concat({ count, cached }, ':')
    end

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
        modifiers = {},
        quality = quality,
    }

    if quality < 0 then
        item.quality = C_Item.GetItemQualityByID(link)
    end

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
    local startModifiers = 15 + (numBonusIDs or 0)
    local numModifiers = tonumber(parts[startModifiers])
    if numModifiers ~= nil then
        for i = startModifiers + 1, startModifiers + (numModifiers * 2), 2 do
           item.modifiers[#item.modifiers + 1] = parts[i] .. '_' .. parts[i + 1]
        end
    end

    local effectiveILvl, _, _ = GetDetailedItemLevelInfo(link)
    item.itemLevel = effectiveILvl

    -- count:id:context:enchant:ilvl:quality:suffix:bonusIDs:gems
    local ret = table.concat({
        item.itemID,
        item.context or 0,
        item.enchantID or 0,
        item.itemLevel or 0,
        item.quality or 0,
        item.suffixID or 0,
        table.concat(item.bonusIDs, ','),
        table.concat(item.gems, ','),
        table.concat(item.modifiers, ','),
    }, ':')

    parseItemLinkCache[link] = ret

    return table.concat({ count, ret }, ':')
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

function wwtc:TableKeys(tbl)
    local keys = {}
    for key in pairs(tbl) do
        keys[#keys + 1] = key
    end
    return keys
end

-------------------------------------------------------------------------------

SLASH_WWTC1 = "/wwtc"
SlashCmdList["WWTC"] = function(msg)
    wwtc:ScanAuras()
end

SLASH_RL1 = "/rl"
SlashCmdList["RL"] = function(msg)
    ReloadUI()
end
