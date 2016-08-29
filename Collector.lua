-- Things
local wwtc = {}
local charData, charName, guildName, playedLevel, playedLevelUpdated, playedTotal, playedTotalUpdated, regionName
local bankOpen, collectionsHooked, crafterOpen, guildBankOpen, loggingOut = false, false, false, false, false
local dirtyBags, dirtyBuildings, dirtyFollowers, dirtyLockouts, dirtyMissions, dirtyMounts, dirtyPets, dirtyReputations, dirtyShipments, dirtyVoid =
    {}, false, false, false, false, false, false, false, false, false

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
    1275, -- Curious Coin
    1226, -- Nethershard
    1220, -- Order Resources
    1273, -- Seal of Broken Fate
    1154, -- Shadowy Coins
    1149, -- Sightless Eye
    1268, -- Timeworn Artifact
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
        name = 'Highmaul',
        instances = {
            { 849, 3 }, -- Walled City
            { 850, 3 }, -- Arcane Sanctum
            { 851, 1 }, -- Imperator's Rise
        },
    },
    {
        name = 'Blackrock Foundry',
        instances = {
            { 847, 3 }, -- Slagworks
            { 846, 3 }, -- The Black Forge
            { 848, 3 }, -- Iron Assembly
            { 823, 1 }, -- Blackhand's Crucible
        },
    },
    {
        name = 'Hellfire Citadel',
        instances = {
            { 982, 3 }, -- Hellbreach
            { 983, 3 }, -- Halls of Blood
            { 984, 3 }, -- Bastion of Shadows
            { 985, 3 }, -- Destructor's Rise
            { 986, 1 }, -- The Black Gate
        },
    },
}

-- World boss quests
local worldBossQuests = {
    [37460] = "Gorgrond Bosses", -- Drov the Ruinator
    [37462] = "Gorgrond Bosses", -- Tarlna
    [37464] = "Rukhmar",
    [94015] = "Supreme Lord Kazzak",
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
    [458] = 5656, -- Brown Horse
    [10799] = 8592, -- Violet Raptor
    [35028] = 34129, -- Swift Warstrider
    [97501] = 69226, -- Felfire Hawk
}
local checkPets = {
    [216] = 33239, -- Argent Gruntling
    [1350] = 73809, -- Sky Lantern
}
local checkReputations = {
    [1492] = "Emperor Shaohao",
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
    dirtyBuildings = true
    dirtyFollowers = true
end
-- ??
function events:GARRISON_BUILDING_UPDATE()
    dirtyBuildings = true
end
-- ?? Fires when a garrison building is placed
function events:GARRISON_BUILDING_PLACED()
    dirtyBuildings = true
end
-- ?? Fires when a garrison building is removed
function events:GARRISON_BUILDING_REMOVED()
    dirtyBuildings = true
end
-- ?? Fires when a garrison building is updated
function events:GARRISON_BUILDING_ACTIVATED()
    dirtyBuildings = true
end
-- Fires when the garrison shipment information has arrived
function events:GARRISON_LANDINGPAGE_SHIPMENTS()
    wwtc:ScanShipments()
end
-- Fires when the garrison mission list updates?
function events:GARRISON_MISSION_LIST_UPDATE()
    dirtyMissions = true
end
-- Fires when a work order crafter frame is opened
function events:SHIPMENT_CRAFTER_OPENED()
    crafterOpen = true
end
-- Fires when a work order crafter frame is closed
function events:SHIPMENT_CRAFTER_CLOSED()
    crafterOpen = false
end
-- ?? Fires ALL THE DAMN TIME
function events:SHIPMENT_UPDATE()
    dirtyShipments = true
end
-- Fires when a new follower is added
function events:GARRISON_FOLLOWER_ADDED()
    dirtyFollowers = true
end
-- Fires when a follower gains XP
function events:GARRISON_FOLLOWER_XP_CHANGED()
    dirtyFollowers = true
end
-- Fires whenever the available follower list changes
function events:GARRISON_FOLLOWER_LIST_UPDATE()
    dirtyFollowers = true
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
    -- Scan dirty buildings
    if dirtyBuildings then
        dirtyBuildings = false
        wwtc:ScanBuildings()
    end
    -- Scan dirty followers
    if dirtyFollowers then
        dirtyFollowers = false
        wwtc:ScanFollowers()
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
    -- Scan dirty shipments
    if dirtyShipments and not crafterOpen then
        dirtyShipments = false
        C_Garrison.RequestLandingPageShipmentInfo()
        --wwtc:ScanShipments()
    end
end

local _ = C_Timer.NewTicker(1, function() wwtc:Timer() end, nil)

-------------------------------------------------------------------------------

function wwtc:Initialise()
    -- Build a unique ID for this character
    local _, realm, _, _, _, _, region = LibRealmInfo:GetRealmInfoByUnit("player")
    regionName = region or GetCurrentRegion()
    charName = regionName .. " - " .. realm .. " - " .. UnitName("player")

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

    charData.buildings = charData.buildings or {}
    charData.currencies = charData.currencies or {}
    charData.followers = charData.followers or {}
    charData.items = charData.items or {}
    charData.lockouts = charData.lockouts or {}
    charData.missions = charData.missions or {}
    charData.mounts = charData.mounts or {}
    charData.pets = charData.pets or {}
    charData.reputations = charData.reputations or {}
    charData.scanTimes = charData.scanTimes or {}
    charData.ships = charData.ships or {}
    charData.tradeSkills = charData.tradeSkills or {}
    charData.weeklyQuests = charData.weeklyQuests or {}
    charData.workOrders = charData.workOrders or {}

    charData.dailyResetTime = wwtc:GetDailyResetTime()

    wwtc:UpdateGuildData()
end

function wwtc:Login()
    wwtc:Initialise()

    -- Try to hook the Collections addon thing
    wwtc:HookCollections()

    RequestTimePlayed()
    C_Garrison.RequestLandingPageShipmentInfo()
    wwtc:ScanMounts()
end

function wwtc:Logout()
    loggingOut = true
    wwtc:UpdateCharacterData()
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

        wwtc:ScanWeeklyQuests()

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

function wwtc:ScanBag(bagID)
    if charData == nil then return end

    -- Short circuit if bank isn't open
    if (bagID == -3 or bagID == -1 or (bagID >= 5 and bagID <= 11)) and not bankOpen then
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
                bag["s"..i] = { count, wwtc:GetItemID(link) }
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

-- Scan weekly quests
function wwtc:ScanWeeklyQuests()
    if charData == nil then return end

    charData.weeklyQuests = {}

    for questID, _ in pairs(weeklyQuests) do
        charData.weeklyQuests[questID] = IsQuestFlaggedCompleted(questID)
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
            charData.mounts[#charData.mounts+1] = checkMounts[spellID]
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

    for factionID, _ in pairs(checkReputations) do
        local _, _, standingID, _, barMax, barValue = GetFactionInfoByID(factionID)
        charData.reputations[factionID] = {
            level = standingID,
            current = barValue,
            max_value = barMax,
        }
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

    print("WoWthing_Collector: scanned", #WWTCSaved.toys, "toys")
end

-- Scan garrison buildings
function wwtc:ScanBuildings()
    if charData == nil then return end

    charData.scanTimes['buildings'] = time()
    charData.buildings = {}

    local level, _, _, _ = C_Garrison.GetGarrisonInfo(LE_GARRISON_TYPE_6_0)
    charData.garrisonLevel = level or 0

    local buildings = C_Garrison.GetBuildings(LE_GARRISON_TYPE_6_0)
    if buildings == nil then return end

    for i = 1, #buildings do
        charData.buildings[#charData.buildings+1] = buildings[i].buildingID
    end
end

-- Scan garrison followers
function wwtc:ScanFollowers()
    if charData == nil then return end

    charData.scanTimes['followers'] = time()
    charData.followers = {}
    charData.ships = {}

    -- Followers
    local followers = C_Garrison.GetFollowers(LE_GARRISON_TYPE_6_0)
    if followers == nil then return end

    for i = 1, #followers do
        local follower = followers[i]
        if follower.isCollected then
            -- Fetch gear
            local _, weaponItemLevel, _, armorItemLevel = C_Garrison.GetFollowerItems(follower.followerID)

            -- Fetch abilities
            local abilityList = {}
            local abilities = C_Garrison.GetFollowerAbilities(follower.followerID)
            for j = 1, #abilities do
                -- description, counters, id, name, icon, isTrait
                abilityList[#abilityList+1] = abilities[j].id
            end

            local followerID = tonumber(follower.garrFollowerID, 16)
            charData.followers[#charData.followers+1] = {
                id = followerID,
                quality = follower.quality,
                status = statusPriority[follower.status] or -1,
                level = follower.level,
                currentXP = follower.xp,
                levelXP = follower.levelXP,
                weaponLevel = weaponItemLevel,
                armorLevel = armorItemLevel,
                abilities = abilityList,
            }
        end
    end

    -- Ships
    local ships = C_Garrison.GetFollowers(LE_GARRISON_TYPE_6_0)
    if ships == nil then return end

    for i = 1, #ships do
        local ship = ships[i]
        if ship.isCollected then
            -- Fetch abilities
            local abilityList = {}
            local abilities = C_Garrison.GetFollowerAbilities(ship.followerID)
            for j = 1, #abilities do
                abilityList[#abilityList+1] = abilities[j].id
            end

            local followerID = tonumber(ship.garrFollowerID, 16)
            charData.ships[#charData.ships+1] = {
                id = followerID,
                quality = ship.quality,
                status = statusPriority[ship.status] or -1,
                currentXP = ship.xp,
                levelXP = ship.levelXP,
                abilities = abilityList,
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

-- Scan garrison shipments
function wwtc:ScanShipments()
    if charData == nil then return end

    charData.scanTimes['shipments'] = time()
    charData.workOrders = {}

    local buildings = C_Garrison.GetBuildings(LE_GARRISON_TYPE_6_0)
    if buildings == nil then return end

    for i = 1, #buildings do
        local buildingID = buildings[i].buildingID
        if buildingID then
            -- local name, texture, shipmentCapacity, shipmentsReady, shipmentsTotal, creationTime, duration, timeleftString, itemName, itemIcon, itemQuality, itemID = C_Garrison.GetLandingPageShipmentInfo(buildingID)
            local _, _, shipmentCapacity, shipmentsReady, shipmentsTotal, creationTime, duration = C_Garrison.GetLandingPageShipmentInfo(buildingID)
            if shipmentCapacity and shipmentCapacity > 0 then
                charData.workOrders[#charData.workOrders+1] = {
                    buildingID,
                    shipmentCapacity,
                    shipmentsReady,
                    shipmentsTotal,
                    creationTime,
                    duration,
                }
            end
        end
    end
end

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
