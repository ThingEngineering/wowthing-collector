local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('CharacterFlags')


function Module:OnEnable()
    self:RegisterEvent('PLAYER_FLAGS_CHANGED')
    self:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_HIDE')

    self:RegisterBucketEvent({ 'QUEST_LOG_UPDATE' }, 2, 'UpdateChromieTime')
end

function Module:OnEnteringWorld()
    self:UpdateChromieTime()
    self:UpdateWarMode()
end

function Module:PLAYER_FLAGS_CHANGED(_, unitId)
    if unitId == 'player' then
        self:UpdateWarMode()
    end
end

function Module:PLAYER_INTERACTION_MANAGER_FRAME_HIDE(_, interactionType)
    if interactionType == Enum.PlayerInteractionType.ChromieTime then
        self:UpdateChromieTime()
    end
end

function Module:UpdateChromieTime()
    Addon.charData.chromieTime = UnitChromieTimeID("player")
end

function Module:UpdateWarMode()
    Addon.charData.isWarMode = C_PvP.IsWarModeDesired()
end
