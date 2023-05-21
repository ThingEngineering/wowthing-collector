local Addon = LibStub("AceAddon-3.0"):NewAddon("WoWthing_Collector", "AceEvent-3.0")
Addon:SetDefaultModuleLibraries("AceBucket-3.0", "AceEvent-3.0")

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
    worldQuestIds = {},
}

function Addon:OnInitialize()
    -- Initialize saved variables to default if required
    if WWTCSaved == nil or WWTCSaved.version < defaultWWTCSaved.version then
        WWTCSaved = defaultWWTCSaved
    end

    Addon:Cleanup()

    WWTCSaved.heirloomsV2 = WWTCSaved.heirloomsV2 or {}
    WWTCSaved.quests = WWTCSaved.quests or {}
    WWTCSaved.transmogSourcesV2 = WWTCSaved.transmogSourcesV2 or {}
    WWTCSaved.worldQuestIds = WWTCSaved.worldQuestIds or {}

    WWTCSaved.honorCurrent = WWTCSaved.honorCurrent or 0
    WWTCSaved.honorLevel = WWTCSaved.honorLevel or 0
    WWTCSaved.honorMax = WWTCSaved.honorMax or 0

    -- Build a unique ID for this character
    -- id, name, nameForAPI, rules, locale, nil, region, timezone, connections, englishName, englishNameForAPI
    local _, realm, _, _, _, _, region, _, _, realmEnglish = LibRealmInfo:GetRealmInfoByUnit("player")
    self.regionName = region or GetCurrentRegion()
    self.charName = self.regionName .. "/" .. (realmEnglish or realm)  .. "/" .. UnitName("player")
    self.charClassID = select(3, UnitClass("player"))

    -- Set up character data table
    self.charData = WWTCSaved.chars[self.charName] or {}
    self.charData.scanTimes = self.charData.scanTimes or {}

    WWTCSaved.chars[self.charName] = self.charData

    self:RegisterEvent('PLAYER_ENTERING_WORLD')
    self:RegisterEvent('PLAYER_LOGOUT')
    self:RegisterEvent('PLAYER_MONEY')
end

function Addon:Cleanup()
    WWTCSaved.heirlooms = nil
    WWTCSaved.transmogSources = nil

    -- Remove data for any characters not seen in the last 3 days
    local old = time() - (3 * 24 * 60 * 60)
    for charName, charData in pairs(WWTCSaved.chars) do
        if not charData.lastSeen or charData.lastSeen < old then
            WWTCSaved.chars[charName] = nil
        else
            -- Wipe any deprecated data
            charData.auras = nil
            charData.balanceMythic15 = nil
            charData.balanceUnleashedMonstrosities = nil
            charData.biggerFishToFry = nil
            charData.hiddenDungeons = nil
            charData.hiddenKills = nil
            charData.hiddenWorldQuests = nil
            charData.mythicPlus = nil
            charData.weeklyQuests = nil
            charData.weeklyUghQuests = nil
        end
    end
end

function Addon:UpdateLastSeen()
    self.charData.lastSeen = time()
end

function Addon:PLAYER_ENTERING_WORLD()
    self:UpdateLastSeen()

    self:PLAYER_MONEY()

    for _, module in Addon:IterateModules() do
        if module.OnEnteringWorld ~= nil then
            module:OnEnteringWorld()
        end
    end
end

function Addon:PLAYER_LOGOUT()
    self:UpdateLastSeen()

    for _, module in Addon:IterateModules() do
        if module.OnLogout ~= nil then
            module:OnLogout()
        end
    end
end

function Addon:PLAYER_MONEY()
    self.charData.copper = GetMoney()
end

-- Utils

function Addon:TableKeys(tbl)
    local keys = {}
    for key in pairs(tbl) do
        keys[#keys + 1] = key
    end
    return keys
end
