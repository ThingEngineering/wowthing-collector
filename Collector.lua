-- Things
local wwtc = {}
local charClassID, charData, charName, guildName, playedLevel, playedLevelUpdated, playedTotal, playedTotalUpdated, regionName, zoneDiff
local collectionsHooked, loggingOut = false, false
local bankOpen, crafterOpen, guildBankOpen, reagentBankUpdated = false, false, false, false
local maxScannedToys = 0
local dirtyBags, dirtyFollowers, dirtyHonor, dirtyLockouts, dirtyMissions, dirtyMounts, dirtyPets, dirtyQuests, dirtyReputations, dirtyVault =
    {}, false, false, false, false, false, false, false, false, false, false, false

-- Libs
local LibRealmInfo = LibStub('LibRealmInfo17janekjl')

-- Default SavedVariables
local defaultWWTCSaved = {
    version = 9101,
    chars = {},
    guilds = {},
    heirlooms = {},
    toys = {},
}

local instanceNameToId = {}

-- Currencies
local currencies = {
    -- Player vs Player
    -- 390, -- Conquest Points
    -- 392, -- Honor Points
    391, -- Tol Barad Commendation
    -- Dungeon and Raid
    615, -- Essence of Corrupted Deathwing
    614, -- Mote of Darkness
    1166, -- Timewarped Badge

    -- Miscellaneous
    241, -- Champion's Seal
    61, -- Dalaran Jewelcrafter's Token
    515, -- Darkmoon Prize Ticket
    81, -- Epicurean's Award
    402, -- Ironpaw Token
    416, -- Mark of the World Tree

    -- Cataclysm
    361, -- Illustrious Jewelcrafter's Token

    -- Mists of Pandaria
    697, -- Elder Charm of Good Fortune
    738, -- Lesser Charm of Good Fortune
    752, -- Mogu Rune of Fate
    776, -- Warforged Seal
    777, -- Timeless Coin
    789, -- Bloody Coin

    -- Warlords of Draenor
    823, -- Apexis Crystal
    824, -- Garrison Resources
    944, -- Artifact Fragment
    980, -- Dingy Iron Coins
    994, -- Seal of Tempered Fate
    1101, -- Oil
    1129, -- Seal of Inevitable Fate

    -- Legion
    1149, -- Sightless Eye
    1154, -- Shadowy Coins
    1155, -- Ancient Mana
    1220, -- Order Resources
    1226, -- Nethershard
    1268, -- Timeworn Artifact
    1273, -- Seal of Broken Fate
    1275, -- Curious Coin
    1299, -- Brawler's Gold
    1314, -- Lingering Soul Fragment
    1342, -- Legionfall War Supplies
    1356, -- Echoes of Battle
    1357, -- Echoes of Domination
    1416, -- Coins of Air
    1501, -- Writhing Essence
    1508, -- Veiled Argunite
    1533, -- Wakening Essence

    -- Battle for Azeroth
    1560, -- War Resources
    1565, -- Rich Azerite Fragment
    1580, -- Seal of Wartorn Fate
    1587, -- War Supplies
    1710, -- Seafarer's Dubloon
    1716, -- Honorbound Service Medal
    1717, -- 7th Legion Service Medal
    1718, -- Titan Residuum
    1719, -- Corrupted Memento
    1721, -- Prismatic Manapearl
    1755, -- Coalescing Visions
    1803, -- Echoes of Ny'alotha

    -- Shadowlands
    1191, -- Valor
    1754, -- Argent Commendation
    1767, -- Stygia
    1810, -- Redeemed Soul
    1813, -- Reservoir Anima
    1816, -- Sinstone Fragments
    1819, -- Medallion of Service
    1820, -- Infused Ruby
    1822, -- Renown
    1828, -- Soul Ash
    1885, -- Grateful Offering
    1904, -- Tower Knowledge
    1906, -- Soul Cinders
    1931, -- Cataloged Research
    1977, -- Stygian Ember
}

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

-- World boss quests
local worldBossQuests = {
    -- Warlords of Draenor
    [37460] = "Gorgrond Bosses", -- Drov the Ruinator
    [37462] = "Gorgrond Bosses", -- Tarlna
    [37464] = "Rukhmar",
    [94015] = "Supreme Lord Kazzak",

    -- Legion
    [42269] = "Legion Bosses", -- The Soultakers
    [42270] = "Legion Bosses", -- Nithogg
    [42779] = "Legion Bosses", -- Shar'thos
    [42819] = "Legion Bosses", -- Humongris
    [43192] = "Legion Bosses", -- Levantus
    [43193] = "Legion Bosses", -- Calamir
    [43448] = "Legion Bosses", -- Drugon the Frostblood
    [43512] = "Legion Bosses", -- Ana-Mouz
    [43513] = "Legion Bosses", -- Na'zak the Fiend
    [43985] = "Legion Bosses", -- Flotsam
    [44287] = "Legion Bosses", -- Withered Jim

    [49166] = "Greater Invasions", -- Inquisitor Meto
    [49167] = "Greater Invasions", -- Mistress Alluradel
    [49168] = "Greater Invasions", -- Pit Lord Vilemus
    [49169] = "Greater Invasions", -- Matron Folnuna
    [49170] = "Greater Invasions", -- Occularus
    [49171] = "Greater Invasions", -- Sotanathor

    [48799] = "Pristine Argunite", -- Fuel of a Doomed World weekly

    -- Battle for Azeroth

    -- Shadowlands
    [61813] = "Shadowlands Bosses", -- Valinor, the Light of Eons
    [61814] = "Shadowlands Bosses", -- Nurgash Muckformed
    [61815] = "Shadowlands Bosses", -- Oranomonos the Everbranching
    [61816] = "Shadowlands Bosses", -- Mortanis
}
-- Weekly quests
local weeklyQuests = {
    [37638] = "Bronze Invasion",
    [37639] = "Silver Invasion",
    [37640] = "Gold Invasion",
    [38482] = "Platinum Invasion",
}
local weeklyUghQuests = {
    ["anima"] = {61981, 61982, 61983, 61984},
    ["souls"] = {61331, 61332, 61333, 61334, 62858, 62859, 62860, 62861, 62862, 62863, 62864, 62865, 62866, 62867, 62868, 62869},
    ["shapingFate"] = {63949}
}

-- Check things the Battle.net API is bugged for
local checkMounts = {
    --[458] = true, -- Brown Horse
    --[229376] = true, -- Archmage's Prismatic Disc (Mage Order Hall)
    --[229377] = true, -- Gift of the Holy Keepers (Priest Order Hall)
    --[229417] = true, -- Slayer's Felbroken Shrieker (Demon Hunter Order Hall)
    --[232412] = true, -- Netherlord's Chaotic Wrathsteed (Warlock Order Hall)
}
local checkPets = {
    [216] = 33239, -- Argent Gruntling
    [1350] = 73809, -- Sky Lantern
}
local checkQuests = {
    -- Artifact Hidden Appearances
    43646,
    43647,
    43648,
    43649,
    43650,
    43651,
    43652,
    43653,
    43654,
    43655,
    43656,
    43657,
    43658,
    43659,
    43660,
    43661,
    43662,
    43663,
    43664,
    43665,
    43666,
    43667,
    43668,
    43669,
    43670,
    43671,
    43672,
    43673,
    43674,
    43675,
    43676,
    43677,
    43678,
    43679,
    43680,
    43681,
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

-- Blizzard_GarrisonUI/Blizzard_GarrisonSharedTemplates.lua::477
local statusPriority = {
    [GARRISON_FOLLOWER_IN_PARTY] = 1,
    [GARRISON_FOLLOWER_WORKING] = 2,
    [GARRISON_FOLLOWER_ON_MISSION] = 3,
    [GARRISON_FOLLOWER_EXHAUSTED] = 4,
    [GARRISON_FOLLOWER_INACTIVE] = 5,
}

-- Need a frame for events
local frame, events = CreateFrame("FRAME"), {}

-- Fires when the addon has finished loading
function events:ADDON_LOADED(name)
    -- Us!
    if name == "WoWthing_Collector" then
        if WWTCSaved == nil or WWTCSaved.version < defaultWWTCSaved.version then
            WWTCSaved = defaultWWTCSaved
        end

        -- Timezones suck
        wwtc:CalculateTimeZoneDiff()

        -- Perform any cleanup
        wwtc:Cleanup()

    -- Damn Pet Journal!
    elseif name == "Blizzard_Collections" then
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
    dirtyHonor = true
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
-- Fires when RequestRaidInfo() completes
function events:UPDATE_INSTANCE_INFO()
    dirtyLockouts = true
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
    wwtc:UpdateGuildBank()
end
-- Fires when the guild bank closes
function events:GUILDBANKFRAME_CLOSED()
    guildBankOpen = false
end
-- Fires when something changes in a guild bank tab, including when it is first filled
function events:GUILDBANKBAGSLOTS_CHANGED()
    wwtc:ScanGuildBankTab()
end
-- ??
--function events:GARRISON_UPDATE()
--    dirtyFollowers = true
--end
-- Fires whenever the available follower list changes
--function events:GARRISON_FOLLOWER_LIST_UPDATE()
--    dirtyFollowers = true
--end
-- Fires when a follower is added
--function events:GARRISON_FOLLOWER_ADDED()
--    dirtyFollowers = true
--end
-- Fires when a follower is removed
--function events:GARRISON_FOLLOWER_REMOVED()
--    dirtyFollowers = true
--end
-- ?? Probably when shipments show up
--function events:GARRISON_LANDINGPAGE_SHIPMENTS()
--    wwtc:ScanOrderHallResearch()
--end
-- Fires when a follower gains XP
--function events:GARRISON_FOLLOWER_XP_CHANGED()
--    dirtyFollowers = true
--end
-- Fires when the garrison mission list updates?
--function events:GARRISON_MISSION_LIST_UPDATE()
--    dirtyFollowers = true
--    dirtyMissions = true
--end
--
--function events:GARRISON_MISSION_NPC_OPENED()
--    dirtyFollowers = true
--    dirtyMissions = true
--end
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
-- Fires when Honor XP updates
--function events:HONOR_XP_UPDATE()
--    dirtyHonor = true
--end
-- Fires when Honor level updates
--function events:HONOR_LEVEL_UPDATE()
--    dirtyHonor = true
--end
-- Fires when Mythic dungeon ends
function events:CHALLENGE_MODE_COMPLETED()
    C_MythicPlus.RequestMapInfo()
end
-- Fires when Mythic dungeon map information updates
function events:CHALLENGE_MODE_MAPS_UPDATE()
    dirtyVault = true
end
-- ?
function events:WEEKLY_REWARDS_HIDE()
    dirtyVault = true
end
function events:WEEKLY_REWARDS_SHOW()
    dirtyVault = true
end
function events:WEEKLY_REWARDS_UPDATE()
    dirtyVault = true
end
-- Fires A LOT, whenever just about anything happens with quests
function events:QUEST_LOG_UPDATE()
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

    if dirtyFollowers then
        dirtyFollowers = false
        wwtc:ScanFollowers()
    end

    if dirtyHonor then
        dirtyHonor = false
        wwtc:ScanHonor()
    end

    if dirtyLockouts then
        dirtyLockouts = false
        wwtc:ScanLockouts()
    end

    if dirtyMissions then
        dirtyMissions = false
        wwtc:ScanMissions()
    end

    if dirtyMounts then
        dirtyMounts = false
        wwtc:ScanMounts()
    end

    if dirtyPets then
        dirtyPets = false
        wwtc:ScanPets()
    end

    if dirtyReputations then
        dirtyReputations = false
        wwtc:ScanReputations()
    end

    if dirtyVault then
        dirtyVault = false
        wwtc:ScanVault()
    end

    if dirtyQuests then
        dirtyQuests = false
        wwtc:ScanQuests()
        wwtc:ScanWorldQuests()
    end
end
-- Run the timer once per second to do chunky things
local _ = C_Timer.NewTicker(1, function() wwtc:Timer() end, nil)

-------------------------------------------------------------------------------

function wwtc:Initialise()
    -- Build a unique ID for this character
    local _, realm, _, _, _, _, region = LibRealmInfo:GetRealmInfoByUnit("player")
    regionName = region or GetCurrentRegion()
    charName = regionName .. "/" .. realm .. "/" .. UnitName("player")
    charClassID = select(3, UnitClass("player"))

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

    charData.biggerFishToFry = {}
    charData.hiddenDungeons = 0
    charData.hiddenKills = 0
    charData.hiddenWorldQuests = 0
    charData.balanceUnleashedMonstrosities = {}
    charData.balanceMythic15 = false

    charData.currencies = charData.currencies or {}
    charData.followers = charData.followers or {}
    charData.honor = charData.honor or {}
    charData.items = charData.items or {}
    charData.lockouts = charData.lockouts or {}
    charData.missions = charData.missions or {}
    charData.mounts = charData.mounts or {}
    charData.mythicDungeons = charData.mythicDungeons or {}
    charData.orderHallResearch = charData.orderHallResearch or {}
    charData.paragons = charData.paragons or {}
    charData.pets = charData.pets or {}
    charData.quests = charData.quests or {}
    charData.reputations = charData.reputations or {}
    charData.scanTimes = charData.scanTimes or {}
    charData.torghast = charData.torghast or {}
    charData.tradeSkills = charData.tradeSkills or {}
    charData.vault = charData.vault or {}
    charData.weeklyQuests = charData.weeklyQuests or {}
    charData.weeklyUghQuests = charData.weeklyUghQuests or {}
    charData.worldQuests = charData.worldQuests or {}

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
end

function wwtc:Logout()
    loggingOut = true
    wwtc:UpdateCharacterData()
end

function wwtc:CalculateTimeZoneDiff()
    local now = time()
    local d1 = date("*t", now)
    local d2 = date("!*t", now)
    zoneDiff = difftime(time(d1), time(d2))
end

function wwtc:Cleanup()
    local old = time() - (3 * 24 * 60 * 60)

    for cName, cData in pairs(WWTCSaved.chars) do
        if not cData.lastSeen or cData.lastSeen < old then
            WWTCSaved.chars[cName] = nil
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
    if playedLevel then
        charData.playedLevel = playedLevel + (now - playedLevelUpdated)
    end
    if playedTotal then
        charData.playedTotal = playedTotal + (now - playedTotalUpdated)
    end

    -- Currencies
    charData.currencies = {}
    for i, currencyID in ipairs(currencies) do
        local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(currencyID)
        if currencyInfo ~= nil then
            charData.currencies[#charData.currencies + 1] = {
                id = currencyID,
                total = currencyInfo.quantity,
                maxTotal = currencyInfo.maxQuantity,
                week = currencyInfo.quantityEarnedThisWeek,
                maxWeek = currencyInfo.maxWeeklyQuantity,
            }
        end
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
        charData.copper = GetMoney()

        wwtc:UpdateChromieTime()
        wwtc:UpdateExhausted()
        wwtc:UpdateWarMode()

        wwtc:ScanCriteria()
        wwtc:ScanQuests()
        wwtc:ScanTorghast()
        wwtc:ScanWorldQuests()

        RequestRaidInfo()
        C_MythicPlus.RequestMapInfo()
    end
end

function wwtc:UpdateGuildData()
    if charData == nil then return end

    -- Sometimes this fires before region is checked? Weird
    if not regionName then
        return
    end

    -- Build a unique ID for this character's guild
    local gName, gRankName, gRankIndex = GetGuildInfo("player")
    if gName then
        guildName = regionName .. "/" .. GetRealmName() .. "/" .. gName

        WWTCSaved.guilds[guildName] = WWTCSaved.guilds[guildName] or {}
        WWTCSaved.guilds[guildName].copper = WWTCSaved.guilds[guildName].copper or 0
        WWTCSaved.guilds[guildName].items = WWTCSaved.guilds[guildName].items or {}
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

    charData.items["bag "..bagID] = {}
    local bag = charData.items["bag "..bagID]

    -- Update bag ID
    if bagID >= 1 then
        local bagItemID, _ = GetInventoryItemID('player', ContainerIDToInventoryID(bagID))
        bag['bagItemID'] = bagItemID
    end

    local numSlots = GetContainerNumSlots(bagID)
    if numSlots > 0 then
        for i = 1, numSlots do
            local texture, count, locked, quality, readable, lootable, link, isFiltered = GetContainerItemInfo(bagID, i)
            if count ~= nil and link ~= nil then
                local itemID, extra = wwtc:ParseItemLink(link)
                bag["s"..i] = {
                    count = count,
                    itemID = itemID,
                    quality = quality,
                    extra = extra,
                }
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

-- Scan the current guild bank tab
function wwtc:ScanGuildBankTab()
    if charData == nil then return end

    -- Short circuit if guild bank isn't open
    if not guildBankOpen then
        return
    end

    local tabID = GetCurrentGuildBankTab()

    charData.scanTimes["tab "..tabID] = time()

    WWTCSaved.guilds[guildName].items["tab "..tabID] = {}
    local tab = WWTCSaved.guilds[guildName].items["tab "..tabID]

    -- SIGH constants
    for i = 1, SLOTS_PER_GUILD_BANK_TAB do
        local link = GetGuildBankItemLink(tabID, i)
        if link ~= nil then
            local _, count = GetGuildBankItemInfo(tabID, i)
            local link = GetGuildBankItemLink(tabID, i)
            local itemID, extra = wwtc:ParseItemLink(link)
            local _, _, quality = GetItemInfo(link)
            tab["s"..i] = { count, itemID, quality, extra }
        end
    end
end

-- Scan achievement criteria
function wwtc:ScanCriteria()
    if charData == nil then return end

    -- Legion rare fish
    local fishEarnedByMe = select(13, GetAchievementInfo(10596))
    charData.biggerFishToFry = {}
    local numCriteria = GetAchievementNumCriteria(10596)
    for i = 1, numCriteria do
        local _, _, completed = GetAchievementCriteriaInfo(10596, i)
        if fishEarnedByMe or completed then
            charData.biggerFishToFry[#charData.biggerFishToFry + 1] = i
        end
    end

    -- Hidden variations
    charData.hiddenDungeons = 0
    local numCriteria = GetAchievementNumCriteria(11152)
    for i = 1, numCriteria do
        local _, _, _, quantity = GetAchievementCriteriaInfo(11152, i)
        charData.hiddenDungeons = charData.hiddenDungeons + quantity
    end

    local _, _, _, quantity = GetAchievementCriteriaInfo(11153, 1)
    charData.hiddenWorldQuests = quantity

    local _, _, _, quantity = GetAchievementCriteriaInfo(11154, 1)
    charData.hiddenKills = quantity

    -- Balance of Power variations
    charData.balanceUnleashedMonstrosities = {}
    local numCriteria = GetAchievementNumCriteria(11160)
    for i = 1, numCriteria do
        local _, _, completed = GetAchievementCriteriaInfo(11160, i)
        if completed then
            charData.balanceUnleashedMonstrosities[#charData.balanceUnleashedMonstrosities + 1] = i
        end
    end

    local wasEarnedByMe = select(13, GetAchievementInfo(11162))
    charData.balanceMythic15 = wasEarnedByMe
end

-- Scan instance/world boss lockouts
function wwtc:ScanLockouts()
    if charData == nil then return end

    charData.lockouts = {}

    local now = time()
    charData.scanTimes["lockouts"] = now

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
            bosses[#bosses + 1] = {
                name = name,
                dead = dead,
            }

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
    for i = 1, GetNumSavedWorldBosses() do
        local instanceName, worldBossID, instanceReset = GetSavedWorldBossInfo(i)
        charData.lockouts[#charData.lockouts+1] = {
            name = instanceName,
            resetTime = now + instanceReset,
            difficulty = 0,
            defeatedBosses = 1,
            maxBosses = 1,
        }
    end

    -- Other world bosses
    for questID, instanceName in pairs(worldBossQuests) do
        if C_QuestLog.IsQuestFlaggedCompleted(questID) then
            charData.lockouts[#charData.lockouts+1] = {
                name = instanceName,
                weeklyQuest = true,
                difficulty = 0,
                defeatedBosses = 1,
                maxBosses = 1,
            }
        end
    end
end

-- Scan quests
function wwtc:ScanQuests()
    if charData == nil then return end

    charData.quests = {}
    charData.weeklyQuests = {}
    charData.weeklyUghQuests = {}

    for _, questID in ipairs(checkQuests) do
        charData.quests[questID] = C_QuestLog.IsQuestFlaggedCompleted(questID)
    end

    for questID, _ in ipairs(weeklyQuests) do
        charData.weeklyQuests[questID] = C_QuestLog.IsQuestFlaggedCompleted(questID)
    end

    for name, questIds in pairs(weeklyUghQuests) do
        local ugh = { status = 0 }

        for _, questId in ipairs(questIds) do
            -- Quest is completed
            if C_QuestLog.IsQuestFlaggedCompleted(questId) then
                ugh.status = 2
                break
            -- Quest is in progress, check progress
            elseif C_QuestLog.IsOnQuest(questId) then
                --local index = C_QuestLog.GetLogIndexForQuestID(questId)
                --local description, _, _ = GetQuestLogLeaderBoard(1, index)
                local objectives = C_QuestLog.GetQuestObjectives(questId)
                if objectives ~= nil then
                    local obj = objectives[1]
                    ugh.status = 1
                    ugh.text = obj.text
                    ugh.type = obj.type

                    if obj.type == 'progressbar' then
                        ugh.have = GetQuestProgressBarPercent(questId)
                        ugh.need = 100
                    else
                        ugh.have = obj.numFulfilled
                        ugh.need = obj.numRequired
                    end

                    break
                end
            end
        end

        charData.weeklyUghQuests[name] = ugh
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

        charData.vault[activity.type] = charData.vault[activity.type] or {}
        charData.vault[activity.type][activity.index] = {
            level = activity.level,
            progress = activity.progress,
            threshold = activity.threshold,
        }
    end
end

-- Scan world quests
function wwtc:ScanWorldQuests()
    if nil == nil then return end -- FIXME scan callings

    if charData == nil then return end

    local now = time()
    charData.scanTimes["worldQuests"] = now
    charData.worldQuests = {}

    local bountyQuests = GetQuestBountyInfoForMapID(MAP_KULTIRAS)
    for _, bountyInfo in ipairs(bountyQuests) do
        -- for k, v in pairs(bountyInfo) do
        --     print(k, "=>", v)
        -- end
        
        -- factionID => 1883
        -- icon => 1394953
        -- numObjectives => 1
        -- questID => 42170

        local timeLeft = C_TaskQuest.GetQuestTimeLeftMinutes(bountyInfo.questID)
        if timeLeft ~= nil then
            local _, _, finished, numFulfilled, numRequired = GetQuestObjectiveInfo(bountyInfo.questID, 1, false)

            local index = 3
            if timeLeft < 1440 then
                index = 1
            elseif timeLeft < 2880 then
                index = 2
            end

            -- print(timeLeft, index, finished, numFulfilled, numRequired)

            -- This seems to be 0 all the time now, cool
            local factionID = 0 --bountyInfo.factionID
            if worldQuestFactions[bountyInfo.questID] then
                factionID = worldQuestFactions[bountyInfo.questID]
            end
            
            charData.worldQuests['day ' .. index] = {
                quest = bountyInfo.questID,
                faction = factionID,
                expires = now + (timeLeft * 60),
                finished = finished,
                numCompleted = numFulfilled,
                numRequired = numRequired,
            }
        end
    end

    -- World Quest unlock quest. 51916=Horde, 51918=Alliance, both return true?
    if #charData.worldQuests < 3 and C_QuestLog.IsQuestFlaggedCompleted(51916) then
        local resetDates = {}

        local nowDate = date("!*t", now) -- reset is 15:00:00 UTC, 08:00:00 PST?
        local addDay = (nowDate.hour >= 15)
        
        nowDate.sec = zoneDiff -- we need UTC times, add the stupid timezone difference
        nowDate.min = 0
        nowDate.hour = 15

        resetDates[1] = time(nowDate)
        if addDay then
            resetDates[1] = resetDates[1] + 86400
        end
        resetDates[2] = resetDates[1] + 86400
        resetDates[3] = resetDates[2] + 86400

        for i = 1, 3 do
            local key = 'day ' .. i
            if charData.worldQuests[key] == nil then
                charData.worldQuests[key] = {
                    faction = 0,
                    expires = resetDates[i],
                    finished = true,
                    numCompleted = 1,
                    numRequired = 1,
                }                
            end
        end
    end
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
    else
        if not collectionsHooked then
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
                    wwtc:ScanToys()
                end)
            else
                print("WoWthing_Collector: unable to hook 'ToyBox' frame!")
            end

            collectionsHooked = true
        end
    end
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

    for i, factionID in ipairs(checkReputations) do
        local _, _, _, _, _, barValue = GetFactionInfoByID(factionID)
        charData.reputations[#charData.reputations + 1] = {
            id = factionID,
            value = barValue,
        }
    end

    for i, factionID in ipairs(checkFriendships) do
        _, friendRep = GetFriendshipReputation(factionID)
        charData.reputations[#charData.reputations + 1] = {
            id = factionID,
            value = friendRep,
        }
    end

    for i, factionID in ipairs(paragonReputations) do
        if C_Reputation.IsFactionParagon(factionID) then 
            local currentValue, threshold, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID) 
            charData.paragons[factionID] = { 
                value = mod(currentValue, threshold), 
                maxValue = threshold, 
                hasReward = hasRewardPending, 
            } 
        end 
    end
end

-- Scan Torghast
function wwtc:ScanTorghast()
    if charData == nil then return end

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
function wwtc:ScanToys()
    if charData == nil then return end

    charData.scanTimes['toys'] = time()
    WWTCSaved.toys = {}

    for i = 1, C_ToyBox.GetNumToys() do
        local itemID = C_ToyBox.GetToyFromIndex(i)
        if itemID > 0 and PlayerHasToy(itemID) then
            WWTCSaved.toys[#WWTCSaved.toys+1] = itemID
        end
    end

    if #WWTCSaved.toys > maxScannedToys then
        maxScannedToys = #WWTCSaved.toys
        print("WoWthing_Collector: scanned", maxScannedToys, "toys")
    end
end

-- Scan order hall followers
function wwtc:ScanFollowers()
    if nil == nil then return end -- FIXME missions v17
    if charData == nil then return end

    charData.scanTimes['followers'] = time()
    charData.followers = {}

    -- Followers
    local followers = C_Garrison.GetFollowers(LE_FOLLOWER_TYPE_GARRISON_7_0)
    if followers == nil then return end

    for i = 1, #followers do
        local follower = followers[i]
        if follower.isCollected then
            -- Fetch abilities
            local abilityList, equipmentList = {}, {}

            local abilities = C_Garrison.GetFollowerAbilities(follower.followerID)
            for j = 1, #abilities do
                local ability = abilities[j]
                if ability.isTrait then
                    equipmentList[#equipmentList+1] = ability.id
                else
                    abilityList[#abilityList+1] = ability.id
                end
            end

            active = true
            if follower.status == "Inactive" then active = false end

            charData.followers[#charData.followers+1] = {
                id = follower.garrFollowerID,
                quality = follower.quality,
                level = follower.level,
                itemLevel = follower.iLevel,
                currentXP = follower.xp,
                levelXP = follower.levelXP,
                isTroop = follower.isTroop,
                isActive = follower.status ~= "Inactive",
                spec = follower.classSpec,
                abilities = abilityList,
                equipment = equipmentList,
                vitality = follower.durability,
                maxVitality = follower.maxDurability,
            }
        end
    end
end

-- Scan garrison missions
function wwtc:ScanMissions()
    if nil == nil then return end -- FIXME missions v17

    if charData == nil then return end

    charData.scanTimes['missions'] = time()
    charData.missions = {}

    -- Scan followers first
    local followerMap = {}
    local followers = C_Garrison.GetFollowers(LE_GARRISON_TYPE_6_0)
    if followers == nil then return end

    for i = 1, #followers do
        local follower = followers[i]
        if follower.isCollected then
            local followerID = tonumber(follower.garrFollowerID, 16)
            followerMap[follower.followerID] = followerID
        end
    end

    -- description = "blah blah blah"
    -- cost = 15
    -- duration = "4 hr"
    -- durationSeconds = 14400
    -- level = 100
    -- timeLeft = "4 hr 48 min", "59 min", "46 sec"
    -- type = "Combat"
    -- inProgress = true
    -- locPrefix = "blah"
    -- rewards = {}
    -- numRewards = 1
    -- numFollowers = 2
    -- state = -1 ??
    -- iLevel = 0
    -- name = "Hefty Metal"
    -- followers = {}
    -- location = "Gorgrond"
    -- isRare = false
    -- typeAtlas = "blah"
    -- missionID = 385
    local inProgressMissions = C_Garrison.GetInProgressMissions(LE_GARRISON_TYPE_6_0)
    local now = time()
    
    if inProgressMissions then
        for i = 1, #inProgressMissions do
            local mission = inProgressMissions[i]

            local followerIDs = {}
            for j = 1, mission.numFollowers do
                followerIDs[j] = followerMap[mission.followers[j]]
                if not followerIDs[j] then
                    print("missing follower?", mission.followers[j])
                end
            end

            local timeLeft = wwtc:ParseMissionTime(mission.timeLeft)
            -- Pad minute resolution times by 60s as we have no idea when they'll actually finish
            if timeLeft >= 60 then
                timeLeft = timeLeft + 60
            end

            charData.missions[#charData.missions+1] = {
                id = mission.missionID,
                followers = followerIDs,
                finishes = now + timeLeft,
            }
        end
    end

    local availableMissions = C_Garrison.GetAvailableMissions(LE_GARRISON_TYPE_6_0)
    if availableMissions then
        for _, mission in pairs(availableMissions) do
            charData.missions[#charData.missions+1] = {
                id = mission.missionID,
            }
        end
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

-- Scan honor stuff
function wwtc:ScanHonor()
    if charData == nil then return end

    charData.honor = {
        level = UnitHonorLevel("player"),
        current = UnitHonor("player"),
        max = UnitHonorMax("player"),
   }
end

-------------------------------------------------------------------------------
-- Util functions
-------------------------------------------------------------------------------
-- Parse an item link and return useful information
function wwtc:ParseItemLink(link)
    local parts = { strsplit(":", link) }
    local itemID = tonumber(parts[2])
    local extra = {
        enchant = tonumber(parts[3]),
        gem1 = tonumber(parts[4]),
        gem2 = tonumber(parts[5]),
        gem3 = tonumber(parts[6]),
        gem4 = tonumber(parts[7]),
        suffix = tonumber(parts[8]),
        difficulty = tonumber(parts[13]),
    }

    local numBonusIDs = tonumber(parts[14])
    if numBonusIDs ~= nil then
        for i = 1, numBonusIDs do
            extra["bonus"..i] = tonumber(parts[14 + i])
        end
    end

    return itemID, extra
end

-- Returns the daily quest reset time in the local timezone
function wwtc:GetDailyResetTime()
    local resetTime = GetQuestResetTime()
    if not resetTime or resetTime <= 0 or resetTime > (24 * 60 * 60) + 30 then
        return nil
    end
    return time() + resetTime
end

-- Parses annoying mission remaining times
function wwtc:ParseMissionTime(t)
    local hours = tonumber(t:match("(%d+) hr")) or 0
    local minutes = tonumber(t:match("(%d+) min")) or 0
    local seconds = tonumber(t:match("(%d+) sec")) or 0
    return (hours * 3600) + (minutes * 60) + seconds
end

function wwtc:GetItemLevel(itemLink)
    local effectiveLevel, _, _ = GetDetailedItemLevelInfo(itemLink)
    return effectiveLevel
end

-------------------------------------------------------------------------------

SLASH_WWTC1 = "/wwtc"
SlashCmdList["WWTC"] = function(msg)
    print('sigh')
    wwtc:ScanTorghast()
end

SLASH_RL1 = "/rl"
SlashCmdList["RL"] = function(msg)
    ReloadUI()
end
