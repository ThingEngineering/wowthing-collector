local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Guild')


function Module:OnEnable()
    self:RegisterEvent('PLAYER_GUILD_UPDATE')
end

function Module:PLAYER_GUILD_UPDATE(_, unitTarget)
    if unitTarget == 'player' then
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
    end

    Addon.charData.guildName = guildName
end
