local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('ProfessionOrders')


function Module:OnEnable()
    Addon.charData.patronOrders = Addon.charData.patronOrders or {}

    self.isRequesting = false

    self:RegisterEvent('CRAFTINGORDERS_UPDATE_ORDER_COUNT')
    self:RegisterEvent('TRADE_SKILL_SHOW')
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

function Module:CRAFTINGORDERS_UPDATE_ORDER_COUNT(_, orderType)
    if orderType == Enum.CraftingOrderType.Npc then
        self:RequestOrders()
    end
end

function Module:TRADE_SKILL_SHOW()
    self:RequestOrders()
end

function Module:RequestOrders()
    if self.isRequesting then return end

    local professionInfo = C_TradeSkillUI.GetBaseProfessionInfo()
    if professionInfo == nil or
        professionInfo.professionID == 0 or
        not C_TradeSkillUI.IsNearProfessionSpellFocus(professionInfo.profession)
    then
        return
    end

    -- Ask for patron orders after a slight delay (0 results sometimes otherwise)
    self.isRequesting = true

    local request = {
        orderType = Enum.CraftingOrderType.Npc,
        searchFavorites = false,
        initialNonPublicSearch = true,
        primarySort = {
            sortType = Enum.CraftingOrderSortType.ItemName,
            reversed = false,
        },
        secondarySort = {
            sortType = Enum.CraftingOrderSortType.MaxTip,
            reversed = false,
        },
        forCrafter = true,
        offset = 0,
        profession = professionInfo.profession,
        callback = C_FunctionContainers.CreateCallback(function(result, ...)
            if result == Enum.CraftingOrderResult.Ok then
                self.isRequesting = false
                self:UpdatePatronOrders()
            end
        end),
    }
    C_Timer.After(1, function() C_CraftingOrders.RequestCrafterOrders(request) end)
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

-- [2]={
--     orderState=2,
--     orderType=3,
--     npcOrderRewards={
--       [1]={
--         count=1,
--         itemLink="|cffffffff|Hitem:225670::::::::80:73:::::::::|h[Apprentice's Crafting License]|h|r"
--       },
--       [2]={
--         count=1,
--         itemLink="|cffffffff|Hitem:228727::::::::80:73:::::::::|h[]|h|r"
--       }
--     },
--     npcCustomerCreatureID=217091,
--     expirationTime=1727276400,
--     consortiumCut=43744,
--     npcTreasureID=128322,
--     skillLineAbilityID=50978,
--     customerNotes="",
--     crafterGuid="Player-76-09ED68C8",
--     reagents={
--       [1]={
--         slotIndex=3,
--         reagent={
--           quantity=1,
--           itemID=211296,
--           dataSlotIndex=3
--         },
--         source=1,
--         isBasicReagent=false
--       },
--       [2]={
--         slotIndex=7,
--         reagent={
--           quantity=6,
--           itemID=222424,
--           dataSlotIndex=7
--         },
--         source=0,
--         isBasicReagent=true
--       }
--     },
--     isFulfillable=false,
--     customerName="Vokgret",
--     orderID=98981691,
--     crafterName="Yaken",
--     npcCraftingOrderSetID=31,
--     reagentState=1,
--     minQuality=4,
--     itemID=222437,
--     isRecraft=false,
--     claimEndTime=0,
--     tipAmount=874884,
--     spellID=450228
-- }
