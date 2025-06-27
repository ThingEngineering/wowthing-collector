local Addon = LibStub("AceAddon-3.0"):NewAddon("WoWthing_Collector", "AceConsole-3.0", "AceEvent-3.0")
Addon:SetDefaultModuleLibraries("AceBucket-3.0", "AceEvent-3.0", "AceTimer-3.0")

local ModulePrototype = {
    UniqueTimer = function(self, name, seconds, callback, ...)
        self.__timers = self.__timers or {}
        
        if self.__timers[name] and self:TimeLeft(self.__timers[name]) > 0 then
            -- print('Timer '..name..' already exists')
            return
        end

        self.__timers[name] = self:ScheduleTimer(callback, seconds, ...)
    end
}
Addon:SetDefaultModulePrototype(ModulePrototype)

local CI_GetDetailedItemLevelInfo = C_Item.GetDetailedItemLevelInfo
local CI_GetItemInfo = C_Item.GetItemInfo
local CT_After = C_Timer.After

-- Default SavedVariables
local defaultWWTCSaved = {
    version = 9158,
    chars = {},
    guilds = {},
    heirloomsV2 = {},
    questsV2 = {},
    scanTimes = {},
    toys = {},
    warbank = {},
    worldQuestIds = {},
}

function Addon:OnInitialize()
    -- Initialize saved variables to default if required
    if WWTCSaved == nil or WWTCSaved.version < defaultWWTCSaved.version then
        WWTCSaved = defaultWWTCSaved
    end

    Addon:Cleanup()

    WWTCSaved.heirloomsV2 = WWTCSaved.heirloomsV2 or {}
    WWTCSaved.questsV2 = WWTCSaved.questsV2 or {}
    WWTCSaved.scanTimes = WWTCSaved.scanTimes or {}
    WWTCSaved.warbank = WWTCSaved.warbank or {}
    WWTCSaved.worldQuestIds = WWTCSaved.worldQuestIds or {}

    WWTCSaved.honorCurrent = WWTCSaved.honorCurrent or 0
    WWTCSaved.honorLevel = WWTCSaved.honorLevel or 0
    WWTCSaved.honorMax = WWTCSaved.honorMax or 0

    self.hasAccountLock = false
    self.parseItemLinkCache = {}
    self.working = false
    self.workloads = {}

    self.regionName = GetCurrentRegion()
    self.charName = UnitGUID('player')
    self.charClassID = select(3, UnitClass("player"))

    -- Set up character data table
    self.charData = WWTCSaved.chars[self.charName] or {}
    self.charData.name = UnitName('player')
    self.charData.scanTimes = self.charData.scanTimes or {}

    local now = time()
    self.charData.dailyReset = now + C_DateAndTime.GetSecondsUntilDailyReset()
    self.charData.weeklyReset = now + C_DateAndTime.GetSecondsUntilWeeklyReset()

    WWTCSaved.chars[self.charName] = self.charData

    self:RegisterChatCommand('wwtc', 'SlashCommand')

    self:RegisterEvent('PLAYER_ENTERING_WORLD')
    self:RegisterEvent('PLAYER_LOGOUT')

    self:RegisterEvent('ACCOUNT_MONEY')
    self:RegisterEvent('PLAYER_MONEY')
end

function Addon:Cleanup()
    WWTCSaved.heirlooms = nil
    WWTCSaved.quests = nil
    WWTCSaved.transmogSources = nil
    WWTCSaved.transmogSourcesV2 = nil
    WWTCSaved.transmogSourcesSquish = nil
    
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
            charData.equipment = nil
            charData.hiddenDungeons = nil
            charData.hiddenKills = nil
            charData.hiddenWorldQuests = nil
            charData.illusions = nil
            charData.mythicPlus = nil
            charData.name = nil
            charData.transmog = nil
            charData.transmogSquish = nil
            charData.weeklyQuests = nil
            charData.weeklyUghQuests = nil
            
            charData.activeQuests = nil
            charData.dailyQuests = nil
            charData.otherQuests = nil

            if charData.vault ~= nil and
                (charData.vault[1] ~= nil or
                charData.vault[2] ~= nil or
                charData.vault[3] ~= nil)
            then
                charData.vault = {}
            end
        end
    end
end

function Addon:SlashCommand(command)
    if command == 'transmog' then
        print('Running full transmog scan')
        self.charData.scanTimes.transmog = 0
        
        local transmogModule = self:GetModule('Transmog')
        transmogModule:UpdateTransmog(true)
    end
end

function Addon:UpdateLastSeen()
    self.charData.lastSeen = time()
end

function Addon:PLAYER_ENTERING_WORLD()
    self.hasAccountLock = C_PlayerInfo.HasAccountInventoryLock()
    self:UpdateLastSeen()

    C_Timer.After(2, function()
        self:ACCOUNT_MONEY()
        self:PLAYER_MONEY()
    end)

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

function Addon:ACCOUNT_MONEY()
    if self.hasAccountLock then
        WWTCSaved.scanTimes.warbankGold = time()
        WWTCSaved.warbank.copper = C_Bank.FetchDepositedMoney(Enum.BankType.Account)
    end
end

function Addon:PLAYER_MONEY()
    self.charData.copper = GetMoney()
end

-- Utils
function Addon:Round(n)
    return math.floor(n + 0.5)
end

function Addon:TableKeys(tbl)
    local index = 1
    local keys = {}
    for key, _ in pairs(tbl) do
        keys[index] = key
        index = index + 1
    end
    return keys
end

function Addon:PlayerGuidToId(guid)
    local parts = strsplittable('-', guid, 3)
    if #parts == 3 then
        return parts[3]
    else
        return guid
    end
end

function Addon:ParseItemLink(link, quality, count, bound)
    local cached = self.parseItemLinkCache[link]
    if cached ~= nil then
        return table.concat({ count, cached }, ':')
    end

    -- |cnIQ4:|Hitem:blah
    local pipeParts = { strsplit("|", link) }
    local parts = { strsplit(":", pipeParts[3]) }

    if string.find(parts[1], 'Hbattlepet') then
        return table.concat({
            'pet',
            parts[2], -- speciesID
            parts[3], -- level
            parts[4], -- quality
        }, ':')
    end

    local item = {
        bindType = 0,
        count = count,
        itemID = tonumber(parts[2]),
        quality = quality,
        bonusIDs = {},
        gems = {},
        modifiers = {},
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

    local effectiveILvl, _, _ = CI_GetDetailedItemLevelInfo(link)
    local _, _, _, _, _, _, _, _, _, _, _, _, _, bindType = CI_GetItemInfo(link)
    item.itemLevel = effectiveILvl
    item.bindType = bindType

    -- count:id:context:enchant:ilvl:quality:suffix:bonusIDs:gems:modifiers:bound:bindType
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
        bound,
        item.bindType or 0,
    }, ':')

    self.parseItemLinkCache[link] = ret

    return table.concat({ count, ret }, ':')
end

-- https://www.wowinterface.com/forums/showthread.php?t=58916
--  Budgets 50% of target or current FPS to perform a workload. 
--  finished = start(workload, onFinish, onDelay)
--  Arguments:
--      workload        table       Stack (last in, first out) of functions to call.
--      onFinish        function?   Optional callback when the table is empty.
--      onDelay         function?   Optional callback each time work delays to the next frame.
--  Returns:
--      finished        boolean     True when finished without any delay; false otherwise.
function Addon:QueueWorkload(workload, onFinish, onDelay)
    -- If there's no workload provided we don't even need to queue
    if #workload == 0 then
        if onFinish then
            onFinish()
        end
        return
    end

    tinsert(self.workloads, { workload = workload, onFinish = onFinish, onDelay = onDelay })
    if self.working == false then
        self.working = true
        Addon:BatchWork()
    end
end

function Addon:BatchWork()
    local maxDuration = 250 / (tonumber(C_CVar.GetCVar("targetFPS")) or GetFrameRate())
    -- local startTime = debugprofilestop()
    local function continue()
        local startTime = debugprofilestop()
        while true do
            local workloadData = tremove(self.workloads)
            if workloadData == nil then
                self.working = false
                return true
            end
            
            local task = tremove(workloadData.workload)
            if task == nil then
                self.working = false
                return true
            end

            task()
            
            if #workloadData.workload > 0 then
                tinsert(self.workloads, 1, workloadData)
            else
                if workloadData.onFinish then
                    workloadData.onFinish()
                end

                if #self.workloads == 0 then
                    self.working = false
                    return true
                end
            end

            if (debugprofilestop() - startTime) > maxDuration then
                CT_After(0.05, continue)
                if workloadData.onDelay then
                    workloadData.onDelay()
                end
                return false
            end
        end
    end
    return continue()
end

-- Encode a sorted run of numbers into a moderately space-efficient format
--   [questID1].[encoded deltas]|[questID2].[deltas]|...
local CHAR_VALUES = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789`~!@#$%^&*()-_=+[{]};:,<.>/?'
local CHAR_TO_VALUE = {}
local VALUE_TO_CHAR = {}
for index = 1, strlen(CHAR_VALUES) do
    local char = strbyte(CHAR_VALUES, index)
    CHAR_TO_VALUE[char] = index
    VALUE_TO_CHAR[index] = strchar(char)
end

function Addon:DeltaEncode(ids, onFinish)
    local count = #ids
    local maxDiff = strlen(CHAR_VALUES)

    local anyDiffed = false
    local index = 1
    local lastId = nil
    local output = {}
    local workload = {}

    for i = 1, count, 1000 do
        tinsert(workload, 1, function()
            for j = i, min(i + 999, count) do
                local currentId = ids[j]
                if lastId ~= nil then
                    local diff = currentId - lastId
                    if diff <= maxDiff then
                        if anyDiffed == false then
                            anyDiffed = true
                            output[index] = '.'
                            index = index + 1
                        end

                        output[index] = VALUE_TO_CHAR[diff]
                    else
                        output[index] = '|'
                        index = index + 1
                        lastId = nil
                    end
                end

                if lastId == nil then
                    anyDiffed = false
                    output[index] = currentId
                end

                index = index + 1
                lastId = currentId
            end
        end)
    end

    tinsert(workload, 1, function()
        onFinish(table.concat(output, ''))
    end)

    Addon:QueueWorkload(workload)
end

function Addon:DeltaDecode(squished)
    local data = {}
    local index = 1
    -- local startTime = debugprofilestop()
    
    local parts = { strsplit('|', squished) }
    for _, part in ipairs(parts) do
        local deltaParts = { strsplit('.', part, 2) }

        local id = tonumber(deltaParts[1])
        data[index] = id
        index = index + 1

        local deltas = deltaParts[2]
        if deltas ~= nil then
            for i = 1, #deltas do
                local byte = strbyte(deltas, i)
                id = id + CHAR_TO_VALUE[byte]
                data[index] = id
                index = index + 1
            end
        end
    end

    -- local endTime = debugprofilestop()
    -- print('DeltaDecode: '..#squished.. ' bytes in '..endTime - startTime..'ms')

    return data
end
