-- Things
local wwtc = {}
local charClassID, charData, charName, guildName, playedLevel, playedLevelUpdated, playedTotal, playedTotalUpdated, regionName, zoneDiff
local artifactsHooked, collectionsHooked, loggingOut = false, false, false
local artifactOpen, bankOpen, crafterOpen, guildBankOpen = false, false, false, false
local maxScannedToys = 0
local dirtyArtifacts, dirtyBags, dirtyFollowers, dirtyHonor, dirtyLockouts, dirtyMissions, dirtyMounts, dirtyPets, dirtyReputations, dirtyVoid, dirtyWorldQuests =
    false, {}, false, false, false, false, false, false, false, false, false, false, false

-- Libs
local LibRealmInfo = LibStub('LibRealmInfo10Fixed')

-- Default SavedVariables
local defaultWWTCSaved = {
    version = 11,
    chars = {},
    guilds = {},
    heirlooms = {},
    toys = {},
}

-- Currencies
local currencies = {
    -- Player vs Player
     390, -- Conquest Points
     392, -- Honor Points
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
     789, -- Bloody Coin
     697, -- Elder Charm of Good Fortune
     738, -- Lesser Charm of Good Fortune
     752, -- Mogu Rune of Fate
     777, -- Timeless Coin
     776, -- Warforged Seal
    -- WoD
     823, -- Apexis Crystal
     944, -- Artifact Fragment
     980, -- Dingy Iron Coins
     824, -- Garrison Resources
    1101, -- Oil
    1129, -- Seal of Inevitable Fate
     994, -- Seal of Tempered Fate
    -- Legion
    1155, -- Ancient Mana
    1299, -- Brawler's Gold
    1416, -- Coins of Air
    1275, -- Curious Coin
    1356, -- Echoes of Battle
    1357, -- Echoes of Domination
    1342, -- Legionfall War Supplies
    1314, -- Lingering Soul Fragment
    1226, -- Nethershard
    1220, -- Order Resources
    1273, -- Seal of Broken Fate
    1154, -- Shadowy Coins
    1149, -- Sightless Eye
    1268, -- Timeworn Artifact
    1508, -- Veiled Argunite
    1533, -- Wakening Essence
    1501, -- Writhing Essence
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

-- LFR instances
local LFRInstances = {
    {
        name = 'The Emerald Nightmare',
        instances = {
            {1287, 3}, -- Darkbough
            {1288, 3}, -- Tormented Guardians
            {1289, 1}, -- Rift of Aln
        },
    },
    {
        name = 'Trial of Valor',
        instances ={
            {1411, 3}, -- Trial of Valor
        },
    },
    {
        name = 'The Nighthold',
        instances = {
            {1290, 3}, -- Arcing Aqueducts
            {1291, 3}, -- Royal Athenaeum
            {1292, 3}, -- Nightspire
            {1293, 1}, -- Betrayer's Rise
        },
    },
    {
        name = 'Tomb of Sargeras',
        instances = {
            {1494, 3}, -- The Gates of Hell
            {1495, 3}, -- Wailing Halls
            {1496, 2}, -- Chamber of the Avatar
            {1497, 1}, -- Deceiver's Fall
        },
    },
    {
        name = 'Antorus, the Burning Throne',
        instances = {
            {1610, 3}, -- Light's Breach
            {1611, 3}, -- Forbidden Descent
            {1612, 3}, -- Hope's End
            {1613, 2}, -- Seat of the Pantheon
        },
    },
}

-- World boss quests
local worldBossQuests = {
    [37460] = "Gorgrond Bosses", -- Drov the Ruinator
    [37462] = "Gorgrond Bosses", -- Tarlna
    [37464] = "Rukhmar",
    [94015] = "Supreme Lord Kazzak",

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
}
-- Weekly quests
local weeklyQuests = {
    [37638] = "Bronze Invasion",
    [37639] = "Silver Invasion",
    [37640] = "Gold Invasion",
    [38482] = "Platinum Invasion",
}

-- Check things the Battle.net API is bugged for
local checkMounts = {
    --[458] = true, -- Brown Horse
    [229376] = true, -- Archmage's Prismatic Disc (Mage Order Hall)
    [229377] = true, -- Gift of the Holy Keepers (Priest Order Hall)
    [229417] = true, -- Slayer's Felbroken Shrieker (Demon Hunter Order Hall)
    [232412] = true, -- Netherlord's Chaotic Wrathsteed (Warlock Order Hall)
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
    1492, -- Emperor Shaohao
}
local paragonReputations = {
    1828, -- Highmountain Tribe
    1859, -- The Nightfallen
    1883, -- Dreamweavers
    1894, -- The Wardens
    1900, -- Court of Farondis
    1948, -- Valarjar
    2045, -- Armies of Legionfall
    2165, -- Army of the Light
    2170, -- Argussian Reach
}
local artifactWeapons = {
    [128832] = true, -- Aldrachi Warblades
    [127857] = true, -- Aluneth
    [139275] = true, -- Aluneth
    [139891] = true, -- Aluneth
    [128403] = true, -- Apocalypse
    [120978] = true, -- Ashbringer
    [137582] = true, -- Ashbringer
    [128292] = true, -- Blades of the Fallen Prince
    [128821] = true, -- Claws of Ursoc
    [128819] = true, -- Doomhammer
    [128862] = true, -- Ebonchill
    [128860] = true, -- Fangs of Ashamane
    [128476] = true, -- Fangs of the Devourer
    [128820] = true, -- Felo'melorn
    [128940] = true, -- Fists of the Heavens
    [128938] = true, -- Fu Zan, the Wanderer's Companion
    [128306] = true, -- G'Hanir, the Mother Tree
    [128868] = true, -- Light's Wrath
    [128402] = true, -- Maw of the Damned
    [134562] = true, -- Odyn's Fury
    [128289] = true, -- Scale of the Earth-Warder
    [128941] = true, -- Scepter of Sargeras
    [128858] = true, -- Scythe of Elune
    [128911] = true, -- Sharas'dal, Scepter of Tides
    [128937] = true, -- Sheilun, Staff of the Mists
    [128943] = true, -- Skull of the Man'ari
    [128910] = true, -- Strom'kar, the Warbreaker
    [128808] = true, -- Talonclaw
    [128826] = true, -- Thas'dorah, Legacy of the Windrunners
    [128872] = true, -- The Dreadblades
    [128935] = true, -- The Fist of Ra-den
    [128870] = true, -- The Kingslayers
    [128823] = true, -- The Silver Hand
    [137660] = true, -- The Silver Hand
    [128861] = true, -- Titanstrike
    [128866] = true, -- Truthguard
    [137661] = true, -- Truthguard
    [128825] = true, -- T'uure, Beacon of the Naaru
    [127829] = true, -- Twinblades of the Deceiver
    [128942] = true, -- Ulthalesh, the Deadwind Harvester
    [133755] = true, -- Underlight Angler
    [129738] = true, -- Verus
    [128908] = true, -- Warswords of the Valarjar
    [128827] = true, -- Xal'atath, Blade of the Black Empire
}


-- Misc constants
local CURRENCY_GARRISON = 824
local SLOTS_PER_GUILD_BANK_TAB = 98
local SLOTS_PER_VOID_STORAGE_TAB = 80

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
        WWTCSaved = WWTCSaved or defaultWWTCSaved
        -- WWTCSaved = defaultWWTCSaved -- DEBUG

        -- Overwrite with default if out of date
        if not WWTCSaved.version or WWTCSaved.version < defaultWWTCSaved.version then
            WWTCSaved = defaultWWTCSaved
        end

        -- Backwards compat hacks
        WWTCSaved.heirlooms = WWTCSaved.heirlooms or {}
        WWTCSaved.toys = WWTCSaved.toys or {}

        -- Timezones suck
        wwtc:CalculateTimeZoneDiff()

        -- Perform any cleanup
        wwtc:Cleanup()

    -- Damn Artifacts!
    elseif name == "Blizzard_ArtifactUI" then
        wwtc:HookArtifacts()

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
    dirtyArtifacts = true
    dirtyHonor = true
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
-- Fires when the player gains XP
function events:PLAYER_XP_UPDATE()
    wwtc:UpdateXP()
end
-- Fires when the player's rest state or amount of rested XP changes
function events:UPDATE_EXHAUSTION()
    wwtc:UpdateExhausted()
end
-- Fires when stuff is looted
function events:SHOW_LOOT_TOAST(...)
    local typeIdentifier, itemLink, quantity = ...
    if typeIdentifier == "currency" and itemLink then
        local currencyID = string.match(itemLink, "currency:(%d+)")
        if currencyID == tostring(CURRENCY_GARRISON) then
            charData.scanTimes["garrisonCache"] = time()
        end
    end
end
-- Fires when guild stats changes
function events:PLAYER_GUILD_UPDATE(unitID)
    if unitID == "player" then
        wwtc:UpdateGuildData()
    end
end
-- Fires when the player changes the LFG bonus faction
function events:LFG_BONUS_FACTION_ID_UPDATED()
    local bonusFaction, _ = GetLFGBonusFactionID()
    charData.bonusFaction = bonusFaction
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
function events:TRADE_SKILL_UPDATE()
    wwtc:ScanTradeSkills()
end
-- Fires when a unit casts a spell - used for trade skill updating
function events:UNIT_SPELLCAST_SUCCEEDED(evt, unit, spellName, rank, lineID, spellID)
    -- We only care about the player's trade skills
    if unit == "player" and tradeSkills[spellID] == true then
        C_Timer.NewTimer(0.5, function() wwtc:ScanTradeSkills() end)
    end
end
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
-- Fires when void storage opens
function events:VOID_STORAGE_OPEN()
    if IsVoidStorageReady() then
        dirtyVoid = true
    end
end
-- Fires when void storage data is available?
function events:VOID_STORAGE_UPDATE()
    dirtyVoid = true
end
-- Fires when something changes in void storage
function events:VOID_STORAGE_CONTENTS_UPDATE()
    dirtyVoid = true
end
-- Fires when a void storage transfer completes
function events:VOID_TRANSFER_DONE()
    dirtyVoid = true
end
-- ??
function events:GARRISON_UPDATE()
    dirtyFollowers = true
end
-- Fires whenever the available follower list changes
function events:GARRISON_FOLLOWER_LIST_UPDATE()
    dirtyFollowers = true
end
-- Fires when a follower is added
function events:GARRISON_FOLLOWER_ADDED()
    dirtyFollowers = true
end
-- Fires when a follower is removed
function events:GARRISON_FOLLOWER_REMOVED()
    dirtyFollowers = true
end
-- ?? Probably when shipments show up
function events:GARRISON_LANDINGPAGE_SHIPMENTS()
    wwtc:ScanOrderHallResearch()
end
-- Fires when a follower gains XP
function events:GARRISON_FOLLOWER_XP_CHANGED()
    dirtyFollowers = true
end
-- Fires when the garrison mission list updates?
function events:GARRISON_MISSION_LIST_UPDATE()
    dirtyFollowers = true
    dirtyMissions = true
end
--
function events:GARRISON_MISSION_NPC_OPENED()
    dirtyFollowers = true
    dirtyMissions = true
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
-- Fires when artifact.. updates?
function events:ARTIFACT_UPDATE()
    dirtyArtifacts = true
end
-- Fires when Netherlight Crucible updates?
function events:ARTIFACT_RELIC_FORGE_UPDATE()
    dirtyArtifacts = true
end
-- Fires when the player (or inspected unit) equips or unequips items
function events:UNIT_INVENTORY_CHANGED(unit)
    if unit == 'player' then
        dirtyArtifacts = true
    end
end
-- Fires when Honor XP updates
function events:HONOR_XP_UPDATE()
    dirtyHonor = true
end
-- Fires when Honor level updates
function events:HONOR_LEVEL_UPDATE()
    dirtyHonor = true
end
-- Fires when Prestige level updates
function events:HONOR_PRESTIGE_UPDATE()
    dirtyHonor = true
end
-- Fires when Mythic dungeon map information updates
function events:CHALLENGE_MODE_MAPS_UPDATE()
    wwtc:ScanMythicDungeons()
end
-- Fires A LOT, whenever just about anything happens with quests
function events:QUEST_LOG_UPDATE()
    dirtyWorldQuests = true
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
    -- Scan dirty bags
    for bagID, dirty in pairs(dirtyBags) do
        dirtyBags[bagID] = nil
        wwtc:ScanBag(bagID)
    end
    -- Scan dirty void storage
    if dirtyVoid then
        dirtyVoid = false
        wwtc:ScanVoidStorage()
    end

    -- Scan dirty artifacts
    if dirtyArtifacts then
        dirtyArtifacts = false
        wwtc:ScanEquippedArtifact()
    end
    -- Scan dirty followers
    if dirtyFollowers then
        dirtyFollowers = false
        wwtc:ScanFollowers()
    end
    -- Scan dirty honor
    if dirtyHonor then
        dirtyHonor = false
        wwtc:ScanHonor()
    end
    -- Scan dirty lockouts
    if dirtyLockouts then
        dirtyLockouts = false
        wwtc:ScanLockouts()
    end
    -- Scan dirty missions
    if dirtyMissions then
        dirtyMissions = false
        wwtc:ScanMissions()
    end
    -- Scan dirty mounts
    if dirtyMounts then
        dirtyMounts = false
        wwtc:ScanMounts()
    end
    -- Scan dirty pets
    if dirtyPets then
        dirtyPets = false
        wwtc:ScanPets()
    end
    -- Scan dirty reputations
    if dirtyReputations then
        dirtyReputations = false
        wwtc:ScanReputations()
    end
    -- Scan dirty world quests
    if dirtyWorldQuests then
        dirtyWorldQuests = false
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
    charName = regionName .. " - " .. realm .. " - " .. UnitName("player")
    charClassID = select(3, UnitClass("player"))

    -- Set up character data table
    charData = WWTCSaved.chars[charName] or {}
    WWTCSaved.chars[charName] = charData

    charData.bonusFaction = 0
    charData.copper = 0
    charData.flightSpeed = 0
    charData.groundSpeed = 0
    charData.lastSeen = 0
    charData.playedLevel = 0
    charData.playedTotal = 0
    charData.currentXP = 0
    charData.levelXP = 0
    charData.restedXP = 0
    charData.garrisonLevel = 0
    charData.keystoneInstance = 0
    charData.keystoneLevel = 0
    charData.keystoneMax = 0

    charData.biggerFishToFry = {}
    charData.hiddenDungeons = 0
    charData.hiddenKills = 0
    charData.hiddenWorldQuests = 0
    charData.balanceUnleashedMonstrosities = {}
    charData.balanceMythic15 = false

    charData.artifacts = charData.artifacts or {}
    charData.currencies = charData.currencies or {}
    charData.followers = charData.followers or {}
    charData.honor = charData.honor or {}
    charData.items = charData.items or {}
    charData.lockouts = charData.lockouts or {}
    charData.missions = charData.missions or {}
    charData.mounts = charData.mounts or {}
    charData.orderHallResearch = charData.orderHallResearch or {}
    charData.pets = charData.pets or {}
    charData.quests = charData.quests or {}
    charData.reputations = charData.reputations or {}
    charData.scanTimes = charData.scanTimes or {}
    charData.tradeSkills = charData.tradeSkills or {}
    charData.weeklyQuests = charData.weeklyQuests or {}
    charData.worldQuests = charData.worldQuests or {}
    charData.workOrders = charData.workOrders or {}

    charData.dailyResetTime = wwtc:GetDailyResetTime()

    wwtc:UpdateGuildData()
end

function wwtc:Login()
    wwtc:Initialise()

    -- Try to hook things
    wwtc:HookArtifacts()
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
    for i, currencyID in ipairs(currencies) do
        local _, amount, _, earnedThisWeek, weeklyMax, totalMax, _ = GetCurrencyInfo(currencyID)
        -- Hack to work around buggy GetCurrencyInfo
        if currencyID == 392 or currencyID == 395 or currencyID == 396 then
            weeklyMax = math.floor(weeklyMax / 100)
            totalMax = math.floor(totalMax / 100)
        end
        charData.currencies[currencyID] = { amount, totalMax, earnedThisWeek, weeklyMax }
    end

    -- Master Riding
    if IsSpellKnown(90265) then
        charData.flightSpeed = 310
        charData.groundSpeed = 100
    -- Artisan Riding
    elseif IsSpellKnown(34091) then
        charData.flightSpeed = 280
        charData.groundSpeed = 100
    -- Expert Riding
    elseif IsSpellKnown(34090) then
        charData.flightSpeed = 150
        charData.groundSpeed = 100
    -- Journeyman Riding
    elseif IsSpellKnown(33391) then
        charData.groundSpeed = 100
    -- Apprentice Riding
    elseif IsSpellKnown(33388) then
        charData.groundSpeed = 60
    end

    -- LFG bonus faction
    local bonusFaction, _ = GetLFGBonusFactionID()
    charData.bonusFaction = bonusFaction

    if not loggingOut then
        charData.copper = GetMoney()

        wwtc:UpdateXP()
        wwtc:UpdateExhausted()

        wwtc:ScanCriteria()
        wwtc:ScanQuests()
        wwtc:ScanWorldQuests()

        RequestRaidInfo()
        C_ChallengeMode.RequestMapInfo()
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
        guildName = regionName .. " - " .. GetRealmName() .. " - " .. gName

        WWTCSaved.guilds[guildName] = WWTCSaved.guilds[guildName] or {}
        WWTCSaved.guilds[guildName].copper = WWTCSaved.guilds[guildName].copper or 0
        WWTCSaved.guilds[guildName].items = WWTCSaved.guilds[guildName].items or {}
        WWTCSaved.guilds[guildName].tabs = WWTCSaved.guilds[guildName].tabs or {}
    else
        guildName = nil
    end
end

-- Update current/level XP
function wwtc:UpdateXP()
    if charData == nil then return end

    charData.currentXP = UnitXP("player")
    charData.levelXP = UnitXPMax("player")
end

-- Update resting status and rested XP
function wwtc:UpdateExhausted()
    if charData == nil then return end

    charData.resting = IsResting()

    local rested = GetXPExhaustion()
    if rested and rested > 0 then
        charData.restedXP = rested
    else
        charData.restedXP = 0
    end
end

-- Update information on the equipped artifact
function wwtc:ScanEquippedArtifact()
    wwtc:CheckEquippedArtifact(16) -- Main hand
    wwtc:CheckEquippedArtifact(17) -- Off hand

    local itemId, _, _, _, powerAvailable, traitsPurchased = C_ArtifactUI.GetEquippedArtifactInfo()
    if itemId ~= nil then
        charData.artifacts[itemId].numTraits = traitsPurchased
        charData.artifacts[itemId].xp = powerAvailable
    end

    if artifactOpen then
        wwtc:ScanArtifactTraits()
    end
end

-- Update information on the open artifact
function wwtc:ScanOpenArtifact()
    local itemId, _, _, _, powerAvailable, traitsPurchased = C_ArtifactUI.GetArtifactInfo()
    if itemId ~= nil then
        charData.artifacts[itemId].numTraits = traitsPurchased
        charData.artifacts[itemId].xp = powerAvailable
    end
end

-- Scan a specific bag
function wwtc:ScanBag(bagID)
    if charData == nil then return end

    -- Short circuit if bank isn't open
    if (bagID == -1 or (bagID >= 5 and bagID <= 11)) and not bankOpen then
        return
    end

    local now = time()
    if bagID >= 0 and bagID <= 4 then
        charData.scanTimes["bags"] = now
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
                local itemID = wwtc:GetItemID(link)
                bag["s"..i] = { count, itemID }

                -- Bags
                if bagID >= 0 and bagID <= 4 then
                    if quality == 6 then
                        wwtc:ParseArtifactLink(link)
                    else
                        wwtc:ParseKeystoneLink(link)
                    end
                end
            end
        end
    end
end

function wwtc:CheckEquippedArtifact(slot)
    local quality = GetInventoryItemQuality('player', slot)
    if quality ~= nil and tonumber(quality) == 6 then
        wwtc:ParseArtifactLink(GetInventoryItemLink('player', slot))
    end
end

function wwtc:ParseArtifactLink(link)
    -- |cffe6cc80|Hitem:128826::143704:143682:143821::::110:253:256:9:1:727:114:3:3473:1512:3336:3:3474:1512:3336:3:3462:1647:1813|h[Thas'dorah, Legacy of the Windrunners]|h|r"
    --                 2      34      5      6      7890   1   2   3 4 5   6   7 8    9    0    1 2    3    4    5 6    7    8
    -- |cffe6cc80|Hitem:128808::143688:143705:143798::::110:253:256:9:1:728:125:3:3474:1507:1674:3:3473:1522:3337:3:3462:1647:1813|h[Talonclaw]|h|r"
    --                 2      34      5      6      7890   1   2   3 4 5   6   7 8    9    0    1 2    3    4    5 6    7    8
    -- |cffe6cc80|Hitem:128861::137008:140810:137543::::110:253:16777472:9:1:726:918:1:3:1805:1492:3336:3:3516:1492:3336:3:3412:1512:3336|h[Titanstrike]|h|r
    --                 2      34      5      6      7890   1   2        3 4 5   6   7 8 9    0    1    2 3    4    5    6 7    8    9
    -- |cffe6cc80|Hitem:128860::::::::110:103:256:9:1:723:430:::|h[Fangs of Ashamane]|h|r" (T1 cat)
    --                 2      34567890   1   2   3 4 5   6   789
    -- |cffe6cc80|Hitem:128821::147090:136718:137327::::110:103:16777472:9:1:724:274:1:3:3562:1507:3336:3:1727:1532:3337:3:1727:1522:3336|h[Claws of Ursoc]|h|r" (T2 bear)
    --                 2      34      5      6      7890   1   2        3 4 5   6   7 8 9    0    1    2 3    4    5    6 7    8    9
    -- |cffe6cc80|Hitem:128941::141277:143701:::::110:64:16777472:::188:1:3:3394:1487:3338:3:1824:1482:3338:|h[Scepter of Sargeras]|h|r (T2 destro)
    --                 2      34      5      67890   1  2        345   6 7 8    9    0    1 2    3    4
    -- |cffe6cc80|Hitem:128937::142060:143698:141270::::110:64:16777472:9:1:733:123:1::3:3394:1522:3528:3:3394:1512:3336|h[Sheilun, Staff of the Mists]|h|r
    --                 2      34      5      6      7890   1  2        3 4 5   6   7 89 0    1    2    3 4    5    6
    local itemString = string.match(link, 'item[%-?%d:]+')
    local itemParts = { strsplit(':', itemString) }
    local itemId, relic1Id, relic2Id, relic3Id, itemBonusCount = itemParts[2], itemParts[4], itemParts[5], itemParts[6], itemParts[14]

    itemId = tonumber(itemId)
    if artifactWeapons[itemId] ~= true then return end

    local artifact = charData.artifacts[itemId] or {}
    artifact.relics = { {}, {}, {} }
    artifact.bonusId = 0
    artifact.tier = 1

    local bonusCountIndex = 16
    if itemBonusCount ~= '' then
        artifact.bonusId = tonumber(itemParts[15]) -- might need to check for multiple in future
        bonusCountIndex = bonusCountIndex + tonumber(itemBonusCount)
    end

    -- Tier 2 artifacts have a 1 randomly, fun times
    if tonumber(itemParts[bonusCountIndex]) == 1 and (itemParts[bonusCountIndex+1] == '' or tonumber(itemParts[bonusCountIndex+1]) <= 3) then
        bonusCountIndex = bonusCountIndex + 1
        artifact.tier = 2
    end

    artifact.itemLevel = wwtc:GetItemLevel(link)

    if relic1Id ~= '' then
        local relic = { relic1Id }
        local bonusCount = itemParts[bonusCountIndex]
        if tonumber(bonusCount) then
            bonusCount = tonumber(bonusCount)
            for j = bonusCountIndex + 1, bonusCountIndex + bonusCount do
                relic[#relic + 1] = itemParts[j]
            end
            bonusCountIndex = bonusCountIndex + bonusCount
        end
        artifact.relics[1] = relic
    end
    bonusCountIndex = bonusCountIndex + 1

    if relic2Id ~= '' then
        local relic = { relic2Id }
        local bonusCount = itemParts[bonusCountIndex]
        if tonumber(bonusCount) then
            bonusCount = tonumber(bonusCount)
            for j = bonusCountIndex + 1, bonusCountIndex + bonusCount do
                relic[#relic + 1] = itemParts[j]
            end
            bonusCountIndex = bonusCountIndex + bonusCount
        end
        artifact.relics[2] = relic
    end
    bonusCountIndex = bonusCountIndex + 1

    if relic3Id ~= '' then
        local relic = { relic3Id }
        local bonusCount = itemParts[bonusCountIndex]
        if tonumber(bonusCount) then
            bonusCount = tonumber(bonusCount)
            for j = bonusCountIndex + 1, bonusCountIndex + bonusCount do
                relic[#relic + 1] = itemParts[j]
            end
            bonusCountIndex = bonusCountIndex + bonusCount
        end
        artifact.relics[3] = relic
    end

    charData.artifacts[itemId] = artifact
end

function wwtc:ParseKeystoneLink(link)
    local instance, difficulty = link:match("keystone:(%d+):(%d+):")
    if tonumber(instance) and tonumber(difficulty) then
        charData.keystoneInstance = instance
        charData.keystoneLevel = difficulty
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
            local texture, count, locked = GetGuildBankItemInfo(tabID, i)
            tab["s"..i] = { count, wwtc:GetItemID(link) }
        end
    end
end

-- Scan void storage
function wwtc:ScanVoidStorage()
    if charData == nil then return end

    charData.scanTimes["void"] = time()

    -- NOTE: constants appear to not be global, woo
    for i = 1, 2 do
        charData.items["void "..i] = {}
        local void = charData.items["void "..i]

        for j = 1, SLOTS_PER_VOID_STORAGE_TAB do
            local itemID, texture, locked, recentDeposit, isFiltered = GetVoidItemInfo(i, j)
            if itemID ~= nil then
                void["s"..j] = { 1, itemID }
            end
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

-- Scan instance/LFR/world boss lockouts
function wwtc:ScanLockouts()
    if charData == nil then return end

    charData.lockouts = {}

    local now = time()

    -- Instances
    for i = 1, GetNumSavedInstances() do
        local instanceName, instanceID, instanceReset, instanceDifficulty, locked, extended, instanceIDMostSig,
            isRaid, maxPlayers, difficultyName, maxBosses, defeatedBosses = GetSavedInstanceInfo(i)

        if instanceReset > 0 then
            instanceReset = now + instanceReset
        end

        -- Get saved boss names
        local bosses, j = {}, 1
        local name, something, dead = GetSavedInstanceEncounterInfo(i, j)
        while name do
            bosses[#bosses + 1] = { name, dead }

            j = j + 1
            name, something, dead = GetSavedInstanceEncounterInfo(i, j)
        end

        charData.lockouts[#charData.lockouts+1] = {
            name = instanceName,
            resetTime = instanceReset,
            bosses = bosses,
            difficulty = instanceDifficulty,
            defeatedBosses = defeatedBosses,
            locked = locked,
            maxBosses = maxBosses,
        }
    end

    -- LFR
    for i = 1, #LFRInstances do
        local instanceData = LFRInstances[i]

        local bosses, count, defeated = {}, 0, 0
        for j = 1, #instanceData.instances do
            local instanceID, numBosses = unpack(instanceData.instances[j])
            for k = 1 + count, numBosses + count do
                local bossName, _, isKilled = GetLFGDungeonEncounterInfo(instanceID, k)
                bosses[#bosses + 1] = { bossName, isKilled }
                if isKilled then
                    defeated = defeated + 1
                end
            end

            count = count + numBosses
        end

        charData.lockouts[#charData.lockouts+1] = {
            name = instanceData.name,
            bosses = bosses,
            weeklyQuest = true,
            difficulty = 17, -- LFR
            defeatedBosses = defeated,
            locked = defeated > 0,
            maxBosses = count,
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
        if IsQuestFlaggedCompleted(questID) then
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

-- Scan mythic dungeon completion
function wwtc:ScanMythicDungeons()
    if charData == nil then return end

    charData.keystoneMax = 0

    local maps = C_ChallengeMode.GetMapTable()
    for i = 1, #maps do
        local _, _, level = C_ChallengeMode.GetMapPlayerStats(maps[i]);
        if level and level > charData.keystoneMax then
            charData.keystoneMax = level
        end
    end
end

-- Scan quests
function wwtc:ScanQuests()
    if charData == nil then return end

    charData.quests = {}
    charData.weeklyQuests = {}

    for _, questID in ipairs(checkQuests) do
        charData.quests[questID] = IsQuestFlaggedCompleted(questID)
    end

    for questID, _ in ipairs(weeklyQuests) do
        charData.weeklyQuests[questID] = IsQuestFlaggedCompleted(questID)
    end
end

-- Scan world quests
function wwtc:ScanWorldQuests()
    if charData == nil then return end

    local now = time()
    charData.scanTimes["worldQuests"] = now
    charData.worldQuests = {}

    local bountyQuests = GetQuestBountyInfoForMapID(1014) -- Dalaran City
    for _, bountyInfo in ipairs(bountyQuests) do
        -- factionID => 1883
        -- icon => 1394953
        -- numObjectives => 1
        -- questID => 42170
        local timeLeft = C_TaskQuest.GetQuestTimeLeftMinutes(bountyInfo.questID)
        local _, _, finished, numFulfilled, numRequired = GetQuestObjectiveInfo(bountyInfo.questID, 1, false)

        local index = 3
        if timeLeft < 1440 then
            index = 1
        elseif timeLeft < 2880 then
            index = 2
        end

        -- Not sure why factionID is 0 for these, zzz
        local factionID = bountyInfo.factionID
        if bountyInfo.questID == 48639 then
            factionID = 2165 -- Army of the Light
        elseif bountyInfo.questID == 48642 then
            factionID = 2170
        end
        
        charData.worldQuests['day ' .. index] = {
            faction = factionID,
            expires = now + (timeLeft * 60),
            finished = finished,
            numCompleted = numFulfilled,
            numRequired = numRequired,
        }
    end

    -- World Quest unlock quest
    if #charData.worldQuests < 3 and IsQuestFlaggedCompleted(43341) then
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

-- Hook Blizzard_ArtifactUI for scanning
function wwtc:HookArtifacts()
    if not IsAddOnLoaded("Blizzard_ArtifactUI") then
        UIParentLoadAddOn("Blizzard_ArtifactUI")
    else
        if not artifactsHooked then
            -- Hook artifacts
            local aFrame = _G["ArtifactFrame"]
            if aFrame then
                aFrame:HookScript("OnShow", function(self)
                    wwtc:ScanArtifactTraits()
                    wwtc:ScanOpenArtifact()
                    artifactOpen = true
                end)
                aFrame:HookScript("OnHide", function(self)
                    artifactOpen = false
                end)
            else
                print("WoWthing_Collector: unable to hook 'ArtifactFrame' frame!")
            end

            -- Hook Netherlight Crucible
            local nfFrame = _G["ArtifactRelicForgeFrame"]
            if nfFrame then
                nfFrame:HookScript("OnShow", function(self)
                    wwtc:ScanArtifactTraits()
                    wwtc:ScanOpenArtifact()
                    artifactOpen = true
                end)
                nfFrame:HookScript("OnHide", function(self)
                    artifactOpen = false
                end)
            else
                print("WoWthing_Collector: unable to hook 'ArtifactRelicForgeFrame' frame!")
            end

            artifactsHooked = true
        end
    end
end

function wwtc:ScanArtifactTraits()
    local itemId, _ = C_ArtifactUI.GetArtifactInfo()
    local artifact = charData.artifacts[itemId] or {}

    local powers = C_ArtifactUI.GetPowers()
    if powers ~= nil then
        artifact.traits = {}
        for _, powerId in ipairs(powers) do
            local powerData = C_ArtifactUI.GetPowerInfo(powerId)
            artifact.traits[powerId] = powerData.currentRank - powerData.bonusRanks
        end
    end

    -- Scan Netherlight Crucible traits too
    if C_ArtifactRelicForgeUI.IsAtForge() then
        artifact.crucible = { {}, {}, {} }
        for i = 1, 3 do
            local relicTalents = C_ArtifactRelicForgeUI.GetSocketedRelicTalents(i)
            if relicTalents ~= nil then
                local relic = {}
                for _, relicTalent in ipairs(relicTalents) do
                    if relicTalent.isChosen then
                        relic[#relic+1] = relicTalent.powerID
                    end
                end
                artifact.crucible[i] = relic
            end
        end
    end

    charData.artifacts[itemId] = artifact
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
    charData.reputations = {}
    charData.paragons = {}

    for i, factionID in ipairs(checkReputations) do
        local _, _, standingID, _, barMax, barValue = GetFactionInfoByID(factionID)
        charData.reputations[factionID] = {
            level = standingID,
            current = barValue,
            max_value = barMax,
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

    local talentTreeIDs = C_Garrison.GetTalentTreeIDsByClassID(LE_GARRISON_TYPE_7_0, charClassID)
    if talentTreeIDs and talentTreeIDs[1] then
        charData.orderHallResearch = {}

        local talentTree = select(3, C_Garrison.GetTalentTreeInfoForID(talentTreeIDs[1]))
        for _, talent in ipairs(talentTree) do
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
        prestige = UnitPrestige("player"),
   }
end

-------------------------------------------------------------------------------
-- Util functions
-------------------------------------------------------------------------------
-- Get a numeric itemID from an item link
function wwtc:GetItemID(link)
    return tonumber(link:match("item:(%d+)"))
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
    wwtc:ScanWorldQuests()
end

SLASH_RL1 = "/rl"
SlashCmdList["RL"] = function(msg)
    ReloadUI()
end
