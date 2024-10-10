local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('ProfessionOrders')


function Module:OnEnable()
    Addon.charData.patronOrders = Addon.charData.patronOrders or {}

    self.requestStarted = nil

    self:RegisterEvent('CRAFTINGORDERS_UPDATE_ORDER_COUNT')
    self:RegisterEvent('TRADE_SKILL_SHOW')
    self:RegisterBucketEvent(
        {
            'CRAFTINGORDERS_FULFILL_ORDER_RESPONSE',
        },
        1,
        function()
            self:UpdateOrders()
            self:RequestOrders()
        end
    )
end

function Module:OnEnteringWorld()
    self:UpdateOrders()
end

function Module:CRAFTINGORDERS_UPDATE_ORDER_COUNT(_, orderType)
    if orderType == Enum.CraftingOrderType.Npc then
        self:RequestOrders()
    end
end

function Module:TRADE_SKILL_SHOW()
    self:RequestOrders()
end

function Module:RequestOrders()
    if self.requestStarted ~= nil then return end

    local professionInfo = C_TradeSkillUI.GetBaseProfessionInfo()
    if professionInfo == nil or
        professionInfo.profession == nil or
        professionInfo.professionID == nil or
        professionInfo.professionID == 0 or
        not C_TradeSkillUI.IsNearProfessionSpellFocus(professionInfo.profession)
    then
        return
    end

    -- Ask for patron orders after a slight delay (0 results sometimes otherwise)
    local now = time()
    self.requestStarted = now

    local request = {
        orderType = Enum.CraftingOrderType.Npc,
        searchFavorites = false,
        initialNonPublicSearch = true,
        primarySort = {
            sortType = Enum.CraftingOrderSortType.TimeRemaining,
            reversed = false,
        },
        secondarySort = {
            sortType = Enum.CraftingOrderSortType.TimeRemaining,
            reversed = false,
        },
        forCrafter = true,
        offset = 0,
        profession = professionInfo.profession,
        callback = C_FunctionContainers.CreateCallback(function(result, ...)
            if result == Enum.CraftingOrderResult.Ok then
                self.requestStarted = nil
                self:UpdatePatronOrders()
            end
        end),
    }
    C_Timer.After(1, function() C_CraftingOrders.RequestCrafterOrders(request) end)

    -- Reset if nothing happened after 4 seconds
    C_Timer.After(4, function()
        if self.requestStarted == now then
            self.requestStarted = nil
        end
    end)
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

function Module:UpdatePatronOrders()
    local professionInfo = C_TradeSkillUI.GetBaseProfessionInfo()
    if professionInfo == nil or professionInfo.professionID == 0 then return end

    local patronOrders = {}
    local orders = C_CraftingOrders.GetCrafterOrders()
    for _, order in ipairs(orders) do
        local rewards = {}
        for _, reward in ipairs(order.npcOrderRewards or {}) do
            local parsed = Addon:ParseItemLink(reward.itemLink, -1, reward.count)
            tinsert(rewards, parsed)
        end

        local reagents = {}
        for _, reagent in ipairs(order.reagents or {}) do
            tinsert(reagents, table.concat({
                reagent.reagent.quantity,
                reagent.reagent.itemID,
            }, ':'))
        end

        if order.orderType == Enum.CraftingOrderType.Npc then
            tinsert(patronOrders, table.concat({
                order.expirationTime,
                order.skillLineAbilityID,
                order.itemID,
                order.minQuality,
                order.tipAmount,
                table.concat(rewards, '_'),
                table.concat(reagents, '_'),
            }, '|'))
        end
    end

    if #patronOrders == 0 then
        patronOrders[1] = ''
    end

    Addon.charData.scanTimes['patronOrders'] = time()
    Addon.charData.patronOrders[professionInfo.professionID] = patronOrders
end
