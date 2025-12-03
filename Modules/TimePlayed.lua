local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('TimePlayed', 'AceHook-3.0')


-- Hook the time played message so that we don't print it to chat every time
do
    local originalDisplayTimePlayed = _G.ChatFrameUtil.DisplayTimePlayed
    _G.ChatFrameUtil.DisplayTimePlayed = function(...)
        if Module.requestingPlayedTime then
            C_Timer.After(0.2, function()
                Module.requestingPlayedTime = false
            end)
            return
        end
        return originalDisplayTimePlayed(...)
    end
end

function Module:OnEnable()
    -- self:RawHook('ChatFrame_DisplayTimePlayed', true)
    self:RegisterEvent('PLAYER_LEVEL_UP')
    self:RegisterEvent('TIME_PLAYED_MSG')
end

function Module:OnEnteringWorld()
    self:RequestTimePlayed()
end

function Module:OnLogout()
    self:SaveData()
end

function Module:RequestTimePlayed()
    self.requestingPlayedTime = true
    RequestTimePlayed()
end

function Module:SaveData()
    local now = time()

    if self.playedLevel ~= nil then
        Addon.charData.playedLevel = self.playedLevel + (now - self.playedLevelUpdated)
    end
    if self.playedTotal ~= nil then
        Addon.charData.playedTotal = self.playedTotal + (now - self.playedTotalUpdated)
    end
end

-- Don't display the chat message if we're asking for the data
-- function Module:ChatFrame_DisplayTimePlayed(...)
--     if self.requestingPlayedTime then
--         self.requestingPlayedTime = false
--         return
--     end
    
--     self.hooks.ChatFrame_DisplayTimePlayed(...)
-- end

function Module:PLAYER_LEVEL_UP()
    self.playedLevel, self.playedLevelUpdated = 0, time()
end

function Module:TIME_PLAYED_MSG(_, total, level)
    local now = time()
    self.playedLevel, self.playedLevelUpdated = level, now
    self.playedTotal, self.playedTotalUpdated = total, now
    self:SaveData()
end
