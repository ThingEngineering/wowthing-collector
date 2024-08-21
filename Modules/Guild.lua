local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Guild')


local C_TooltipInfo_GetGuildBankItem = C_TooltipInfo.GetGuildBankItem
-- There's probably a Blizzard constant for this somewhere
local SLOTS_PER_GUILD_BANK_TAB = 98

function Module:OnEnable()
    self.hasQueried = false
    self.isBankOpen = false

    self:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_HIDE')
    self:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_SHOW')
    self:RegisterBucketEvent({ 'PLAYER_GUILD_UPDATE' }, 2, 'PLAYER_GUILD_UPDATE')

    self:RegisterBucketEvent({ 'GUILDBANKBAGSLOTS_CHANGED' }, 2, 'UpdateGuildBank')
end

function Module:OnEnteringWorld()
    C_Timer.After(0, function() self:UpdateGuild() end)
end

function Module:PLAYER_INTERACTION_MANAGER_FRAME_HIDE(_, interactionType)
    if interactionType ~= Enum.PlayerInteractionType.GuildBanker then return end

    self.isBankOpen = false
end

function Module:PLAYER_INTERACTION_MANAGER_FRAME_SHOW(_, interactionType)
    if interactionType ~= Enum.PlayerInteractionType.GuildBanker then return end

    self.hasQueried = false
    self.isBankOpen = true

    self.guild.copper = GetGuildBankMoney()
end

function Module:PLAYER_GUILD_UPDATE(unitTargets)
    if unitTargets['player'] ~= nil then
        self:UpdateGuild()
    end
end

function Module:UpdateGuild()
    -- Build a unique ID for this character's guild
    local guildName
    local gName, _, _, gRealm = GetGuildInfo("player")

    if gName then
        if gRealm == nil then
            gRealm = GetRealmName()
        end

        guildName = Addon.regionName .. "/" .. gRealm .. "/" .. gName

        WWTCSaved.guilds[guildName] = WWTCSaved.guilds[guildName] or {}
        WWTCSaved.guilds[guildName].copper = WWTCSaved.guilds[guildName].copper or 0
        WWTCSaved.guilds[guildName].items = WWTCSaved.guilds[guildName].items or {}
        WWTCSaved.guilds[guildName].scanTimes = WWTCSaved.guilds[guildName].scanTimes or {}
        WWTCSaved.guilds[guildName].tabs = WWTCSaved.guilds[guildName].tabs or {}
        self.guild = WWTCSaved.guilds[guildName]
    else
        self.guild = nil
    end

    Addon.charData.guildName = guildName
end

-- Scan guild bank tabs
function Module:UpdateGuildBank()
    -- Short circuit if guild bank isn't open
    if not self.isBankOpen then
        return
    end

    local now = time()
    self.guild.scanTimes['bank'] = now

    local workload = {}

    -- Request data for every tab, but only once per guild bank opening or we scan infinitely
    if self.hasQueried == false then
        for tabIndex = 1, GetNumGuildBankTabs() do
            QueryGuildBankTab(tabIndex)
        end
        self.hasQueried = true
    end

    for tabIndex = 1, GetNumGuildBankTabs() do
        table.insert(workload, function()
            local tabName, tabIcon, canView = GetGuildBankTabInfo(tabIndex)
            self.guild.tabs['tab ' .. tabIndex] = { tabName, tabIcon }
            if canView == false then return end

            local tabKey = 't' .. tabIndex
            self.guild.items[tabKey] = {}
            local tab = self.guild.items[tabKey]

            for slotIndex = 1, SLOTS_PER_GUILD_BANK_TAB do
                local link = GetGuildBankItemLink(tabIndex, slotIndex)
                if link ~= nil then
                    if string.find(link, '\Hitem:82800:') then
                        local tooltipData = C_TooltipInfo_GetGuildBankItem(tabIndex, slotIndex)

                        tab["s" .. slotIndex] = table.concat({
                            'pet',
                            tooltipData['battlePetSpeciesID'],
                            tooltipData['battlePetLevel'],
                            tooltipData['battlePetBreedQuality'],
                        }, ':')
                    else
                        local _, itemCount, _, _, itemQuality = GetGuildBankItemInfo(tabIndex, slotIndex)
                        local parsed = Addon:ParseItemLink(link, itemQuality or -1, itemCount or 1)
                        tab["s" .. slotIndex] = parsed
                    end
                end
            end
        end)
    end
    
    Addon:QueueWorkload(workload)
end
