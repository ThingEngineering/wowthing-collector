local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('BlackMarket')


function Module:OnEnable()
    Addon.charData.blackMarket = Addon.charData.blackMarket or {}

    self:RegisterBucketEvent({ 'BLACK_MARKET_ITEM_UPDATE' }, 1, 'UpdateBlackMarket')
end

function Module:UpdateBlackMarket()
    Addon.charData.scanTimes['blackMarket'] = time()

    local blackMarket = Addon.charData.blackMarket
    wipe(blackMarket)

    for i = 1, C_BlackMarket.GetNumItems() do
        local _, _, quantity, _, _, _, _, _, minBid, _, currBid, _, numBids, timeLeft, link, _, quality = C_BlackMarket.GetItemInfoByIndex(i)
        if link ~= nil then
            local parsed = Addon:ParseItemLink(link, quality, quantity, 0)
            tinsert(blackMarket, table.concat({
                timeLeft,
                numBids,
                currBid / 10000,
                minBid / 10000,
                parsed,
            }, ';'))
        end
    end

    if #blackMarket == 0 then
        tinsert(blackMarket, '')
    end
end
