-- Things
local wwtc = {}
local charData, charName, guildName, playedLevelUpdated, playedTotal, playedTotalUpdated
local bankOpen, crafterOpen, guildBankOpen, loggingOut, toyBoxHooked = false, false, false, false, false
local dirtyBags, dirtyBuildings, dirtyShipments, dirtyVoid = {}, false, false, false

-- Default SavedVariables
local defaultWWTCSaved = {
    version = 10,
    chars = {},
    guilds = {},
    toys = {},
}

-- Currencies
local currencies = {
    789, -- Bloody Coin
    241, -- Champion's Seal
    390, -- Conquest Points
     61, -- Dalarn Jewelcrafter's Token
    515, -- Darkmoon Prize Ticket
    697, -- Elder Charm of Good Fortune
     81, -- Epicurean's Award
    615, -- Essence of Corrupted Deathwing
    392, -- Honor Points
    361, -- Illustrious Jewelcrafter's Token
    402, -- Ironpaw Token
    738, -- Lesser Charm of Good Fortune
    416, -- Mark of the World Tree
    752, -- Mogu Rune of Fate
    614, -- Mote of Darkness
    777, -- Timeless Coin
    391, -- Tol Barad Commendation
    776, -- Warforged Seal
    -- WoD
    823, -- Apexis Crystal
    824, -- Garrison Resources
    910, -- Secret of Draenor Alchemy
    980, -- Dingy Iron Coins
    994, -- Seal of Tempered Fate
    999, -- Secret of Draenor Tailoring
   1008, -- Secret of Draenor Jewelcrafting
   1017, -- Secret of Draenor Leatherworking
   1020, -- Secret of Draenor Blacksmithing
}

-- Region names
local regionNames = {
    [1] = "US",
    [2] = "KR",
    [3] = "EU",
    [4] = "TW",
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

        -- Backwards compat hack
        WWTCSaved.toys = WWTCSaved.toys or {}

        -- Try to hook the ToyBox
        wwtc:HookToyBox()

    -- Damn Pet Journal!
    elseif name == "Blizzard_PetJournal" then
        wwtc:HookToyBox()

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
    wwtc:Initialise()

    wwtc:UpdateCharacterData()

    -- Hook ToyBox OnShow
    wwtc:ScanToys()
    -- wwtc:HookToyBox()
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
    wwtc:UpdateLockouts()
end
-- Fires when player money changes
function events:PLAYER_MONEY()
    charData.copper = GetMoney()
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
    -- Scan dirty shipments
    if dirtyShipments and not crafterOpen then
        dirtyShipments = false
        C_Garrison.RequestLandingPageShipmentInfo()
        --wwtc:ScanShipments()
    end
end

_ = C_Timer.NewTicker(1, function() wwtc:Timer() end, nil)

-------------------------------------------------------------------------------

function wwtc:Initialise()
    -- Build a unique ID for this character
    charName = regionNames[GetCurrentRegion()] .. " - " .. GetRealmName() .. " - " .. UnitName("player")

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

    charData.buildings = {}
    charData.currencies = {}
    charData.followers = {}
    charData.items = charData.items or {}
    charData.lockouts = {}
    charData.scanTimes = charData.scanTimes or {}
    charData.workOrders = {}

    charData.dailyResetTime = wwtc:GetDailyResetTime()
    --charData.weeklyResetTime = addon:GetWeeklyResetTime()

    wwtc:UpdateGuildData()
end

function wwtc:Login()
    RequestTimePlayed()
    C_Garrison.RequestLandingPageShipmentInfo()
end

function wwtc:Logout()
    loggingOut = true
    wwtc:UpdateCharacterData()
end

-- Update various character data
function wwtc:UpdateCharacterData()
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

    -- Followers?
    wwtc:ScanFollowers()

    if not loggingOut then
        charData.copper = GetMoney()

        wwtc:UpdateXP()
        wwtc:UpdateExhausted()

        RequestRaidInfo()
    end
end

function wwtc:UpdateGuildData()
    -- Build a unique ID for this character's guild
    local gName, gRankName, gRankIndex = GetGuildInfo("player")
    if gName then
        guildName = regionNames[GetCurrentRegion()] .. " - " .. GetRealmName() .. " - " .. gName

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
    charData.currentXP = UnitXP("player")
    charData.levelXP = UnitXPMax("player")
end

-- Update resting status and rested XP
function wwtc:UpdateExhausted()
    charData.resting = IsResting()

    local rested = GetXPExhaustion()
    if rested and rested > 0 then
        charData.restedXP = rested
    else
        charData.restedXP = 0
    end
end

function wwtc:ScanBag(bagID)
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
    -- Short circuit if guild bank isn't open
    if not guildBankOpen then
        return
    end

    local tabID = GetCurrentGuildBankTab()

    charData.scanTimes["tab "..tabID] = time()

    WWTCSaved.guilds[guildName].items["tab "..tabID] = {}
    local tab = WWTCSaved.guilds[guildName].items["tab "..tabID]

    for i = 1, MAX_GUILDBANK_SLOTS_PER_TAB do
        local link = GetGuildBankItemLink(tabID, i)
        if link ~= nil then
            local texture, count, locked = GetGuildBankItemInfo(tabID, i)
            tab["s"..i] = { count, wwtc:GetItemID(link) }
        end
    end
end

-- Scan void storage
function wwtc:ScanVoidStorage()
    charData.scanTimes["void"] = time()

    -- NOTE: constants appear to not be global, woo
    for i = 1, 2 do
        charData.items["void "..i] = {}
        local void = charData.items["void "..i]

        for j = 1, 80 do
            local itemID, texture, locked, recentDeposit, isFiltered = GetVoidItemInfo(i, j)
            if itemID ~= nil then
                void["s"..j] = { 1, itemID }
            end
        end
    end
end


function wwtc:UpdateLockouts()
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
        local name, _, dead = GetSavedInstanceEncounterInfo(i, j)
        while name do
            bosses[#bosses + 1] = { name, dead }

            j = j + 1
            name, _, dead = GetSavedInstanceEncounterInfo(i, j)
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
end

-- Hook ToyBox.OnShow
function wwtc:HookToyBox()
    if not IsAddOnLoaded("Blizzard_PetJournal") then
        LoadAddOn("Blizzard_PetJournal")
    else
        if not toyBoxHooked then
            local tbframe = _G["ToyBox"]
            if tbframe then
                tbframe:HookScript("OnShow", function(self)
                    wwtc:ScanToys()
                end)
                toyBoxHooked = true
            end
        end
    end
end

-- Scan toys, obviously
function wwtc:ScanToys()
    for i = 1, C_ToyBox.GetNumToys() do
        itemID = C_ToyBox.GetToyFromIndex(i)
        if itemID > 0 and PlayerHasToy(itemID) then
            WWTCSaved.toys[itemID] = true
        end
    end
end

-- Scan garrison buildings
function wwtc:ScanBuildings()
    charData.scanTimes['buildings'] = time()
    charData.buildings = {}

    local buildings = C_Garrison.GetBuildings()
    for i = 1, #buildings do
        charData.buildings[#charData.buildings+1] = buildings[i].buildingID
    end
end

-- Scan garrison followers
function wwtc:ScanFollowers()
    charData.scanTimes['followers'] = time()
    charData.followers = {}

    local followers = C_Garrison.GetFollowers()
    for i = 1, #followers do
        local follower = followers[i]
        if follower.isCollected then
            charData.followers[#charData.followers+1] = {
                tonumber(follower.garrFollowerID, 16),
                follower.quality,
                follower.level,
                follower.xp,
                follower.levelXP,
            }
        end
    end
end

-- Scan garrison shipments
function wwtc:ScanShipments()
    charData.scanTimes['shipments'] = time()
    charData.workOrders = {}

    local buildings = C_Garrison.GetBuildings()
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

-- Returns the daily quest reset time in the local timezone
function wwtc:GetDailyResetTime()
  local resetTime = GetQuestResetTime()
  if not resetTime or resetTime <= 0 or resetTime > (24 * 60 * 60) + 30 then
    return nil
  end
  return time() + resetTime
end

-- Get a numeric itemID from an item link
function wwtc:GetItemID(link)
    return tonumber(link:match("item:(%d+)"))
end
