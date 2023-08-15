local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('ProfessionOrders')


function Module:OnEnable()
    self:RegisterBucketEvent(
        {
            'CRAFTINGORDERS_FULFILL_ORDER_RESPONSE',
        },
        1,
        'UpdateOrders'
    )
end

function Module:OnEnteringWorld()
    self:UpdateOrders()
end

function Module:UpdateOrders()
    local now = time()
    Addon.charData.scanTimes['professionOrders'] = now
    Addon.charData.professionOrders = {}

    local profession1, profession2 = GetProfessions()
    self:UpdateOrdersForProfession(now, profession1)
    self:UpdateOrdersForProfession(now, profession2)
end

function Module:UpdateOrdersForProfession(now, spellbookIndex)
    if spellbookIndex == nil then return end

    local skillLineId = select(7, GetProfessionInfo(spellbookIndex))
    local professionInfo = C_TradeSkillUI.GetProfessionInfoBySkillLineID(skillLineId)
    if professionInfo == nil then return end

    local claimInfo = C_CraftingOrders.GetOrderClaimInfo(professionInfo.profession)
    if claimInfo ~= nil and (claimInfo.claimsRemaining > 0 or claimInfo.secondsToRecharge ~= nil) then
        local nextAvailable = 0
        if claimInfo.secondsToRecharge ~= nil and claimInfo.secondsToRecharge > 0 then
            nextAvailable = now + claimInfo.secondsToRecharge
        end

        table.insert(Addon.charData.professionOrders, table.concat({
            skillLineId,
            claimInfo.claimsRemaining,
            nextAvailable,
        }, ':'))
    end
end
