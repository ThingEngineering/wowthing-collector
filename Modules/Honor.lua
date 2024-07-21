local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Honor')


function Module:OnEnable()
    self:RegisterEvent('HONOR_XP_UPDATE')
end

function Module:OnEnteringWorld()
    self:UpdateHonor()
end

function Module:HONOR_XP_UPDATE(_, unitId)
    if unitId == 'player' then
        self:UpdateHonor()
    end
end

function Module:UpdateHonor()
    WWTCSaved.honorCurrent = UnitHonor('player')
    WWTCSaved.honorLevel = UnitHonorLevel('player')
    WWTCSaved.honorMax = UnitHonorMax('player')
end
