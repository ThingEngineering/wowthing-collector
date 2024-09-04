local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Currencies')


Module.db = {}

local CCI_FetchCurrencyDataFromAccountCharacters = C_CurrencyInfo.FetchCurrencyDataFromAccountCharacters
local CCI_GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo

function Module:OnEnable()
    WWTCSaved.transferCurrencies = WWTCSaved.transferCurrencies or {}

    self.accountWide = {}
    self.waiting = false

    self:RegisterBucketEvent({ 'CURRENCY_DISPLAY_UPDATE' }, 1, 'UpdateCurrencies')
    self:RegisterEvent('ACCOUNT_CHARACTER_CURRENCY_DATA_RECEIVED', 'UpdateTransferCurrencies')
    self:RegisterEvent('CURRENCY_TRANSFER_LOG_UPDATE', 'RequestOrUpdateTransferCurrencies')
end

function Module:OnEnteringWorld()
    self:GetAccountWideIds()
    self:UpdateCurrencies()
    self:RequestOrUpdateTransferCurrencies()
end

function Module:RequestOrUpdateTransferCurrencies()
    if C_CurrencyInfo.IsAccountCharacterCurrencyDataReady() then
        self:UpdateTransferCurrencies()
    else
        if self.waiting == false then
            self.waiting = true
            C_CurrencyInfo.RequestCurrencyDataForAccountCharacters()
        end
        C_Timer.After(1, function() self:RequestOrUpdateTransferCurrencies() end)
    end
end

function Module:GetAccountWideIds()
    wipe(self.accountWide)
    for _, currencyID in ipairs(self.db.currencies) do
        if C_CurrencyInfo.IsAccountTransferableCurrency(currencyID) then
            self.accountWide[currencyID] = true
        end
    end
end

function Module:UpdateTransferCurrencies()
    local currencies = WWTCSaved.transferCurrencies
    wipe(currencies)

    for currencyId, _ in pairs(self.accountWide) do
        local currency = {}
        currencies[currencyId] = currency

        local characterDatas = CCI_FetchCurrencyDataFromAccountCharacters(currencyId)
        -- { characterGUID, characterName, currencyID, fullCharacterName, quantity }
        for _, characterData in ipairs(characterDatas or {}) do
            tinsert(
                currency,
                Addon:PlayerGuidToId(characterData.characterGUID) .. ':' .. (characterData.quantity or 0)
            )
        end
    end

    WWTCSaved.scanTimes.transferCUrrencies = time()
end

function Module:UpdateCurrencies()
    Addon.charData.scanTimes["currencies"] = time()

    local currencies = {}
    for _, currencyID in ipairs(self.db.currencies) do
        local currencyInfo = CCI_GetCurrencyInfo(currencyID)
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
