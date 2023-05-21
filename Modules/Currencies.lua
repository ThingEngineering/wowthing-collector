local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Currencies')


Module.db = {}

local C_CurrencyInfo_GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo

function Module:OnEnable()
    self:RegisterBucketEvent({ 'CURRENCY_DISPLAY_UPDATE' }, 1, 'UpdateCurrencies')
end

function Module:OnEnteringWorld()
    self:UpdateCurrencies()
end

function Module:UpdateCurrencies()
    Addon.charData.scanTimes["currencies"] = time()

    local currencies = {}
    for _, currencyID in ipairs(self.db.currencies) do
        local currencyInfo = C_CurrencyInfo_GetCurrencyInfo(currencyID)
        if currencyInfo ~= nil then
            -- quantity:max:isWeekly:weekQuantity:weekMax:isMovingMax:totalQuantity
            currencies[currencyID] = table.concat({
                currencyInfo.quantity,
                currencyInfo.maxQuantity,
                currencyInfo.canEarnPerWeek and 1 or 0,
                currencyInfo.quantityEarnedThisWeek,
                currencyInfo.maxWeeklyQuantity,
                currencyInfo.useTotalEarnedForMaxQty and 1 or 0,
                currencyInfo.totalEarned,
            }, ':')
        end
    end

    Addon.charData.currencies = currencies
end
