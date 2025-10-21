local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Currencies')


Module.db = {}

local CCI_FetchCurrencyDataFromAccountCharacters = C_CurrencyInfo.FetchCurrencyDataFromAccountCharacters
local CCI_GetBasicCurrencyInfo = C_CurrencyInfo.GetBasicCurrencyInfo
local CCI_GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo
local CCI_IsAccountTransferableCurrency = C_CurrencyInfo.IsAccountTransferableCurrency

local MAX_CURRENCY_ID = 4000
local CHUNK_SIZE = 100

function Module:OnEnable()
    Addon.charData.currencies = Addon.charData.currencies or {}
    WWTCSaved.transferCurrencies = WWTCSaved.transferCurrencies or {}

    self.accountWide = {}
    self.currencies = {}
    self.waiting = false

    self:RegisterBucketEvent({ 'CURRENCY_DISPLAY_UPDATE' }, 2, 'UpdateCurrencies')
    self:RegisterEvent('ACCOUNT_CHARACTER_CURRENCY_DATA_RECEIVED', 'UpdateTransferCurrencies')
    self:RegisterEvent('CURRENCY_TRANSFER_LOG_UPDATE', 'RequestOrUpdateTransferCurrencies')
end

function Module:OnEnteringWorld()
    self:GetCurrencyData()
end

function Module:ScanData()
    self:UpdateCurrencies()
    -- self:RequestOrUpdateTransferCurrencies()
end

function Module:GetCurrencyData()
    if #self.currencies == 0 then
        local workload = {}

        for chunkIndex = 1, MAX_CURRENCY_ID, CHUNK_SIZE do
            tinsert(workload, function()
                -- local startTime = debugprofilestop()
                for currencyID = chunkIndex, chunkIndex + CHUNK_SIZE - 1 do
                    local currencyInfo = CCI_GetBasicCurrencyInfo(currencyID)
                    if currencyInfo ~= nil then
                        self.currencies[currencyID] = true
                    end
                    
                    if CCI_IsAccountTransferableCurrency(currencyID) then
                        self.accountWide[currencyID] = true
                    end
                end
                -- print('currencies '..(debugprofilestop() - startTime))
            end)
        end

        Addon:QueueWorkload(workload, function() Module:ScanData() end)
    else
        Module:ScanData()
    end
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

    WWTCSaved.scanTimes.transferCurrencies = time()
end

function Module:UpdateCurrencies()
    Addon.charData.scanTimes["currencies"] = time()

    local currencies = Addon.charData.currencies
    wipe(currencies)

    local foundAny = false
    for currencyID, _ in pairs(self.currencies) do
        local currencyInfo = CCI_GetCurrencyInfo(currencyID)
        if currencyInfo ~= nil and (
            currencyInfo.quantity > 0 or
            currencyInfo.maxQuantity > 0 or
            currencyInfo.quantityEarnedThisWeek > 0 or
            currencyInfo.maxWeeklyQuantity > 0 or
            currencyInfo.totalEarned > 0
        ) then
            currencies[currencyID] = table.concat({
                currencyInfo.quantity,
                currencyInfo.maxQuantity,
                currencyInfo.canEarnPerWeek and 1 or 0,
                currencyInfo.quantityEarnedThisWeek,
                currencyInfo.maxWeeklyQuantity,
                currencyInfo.useTotalEarnedForMaxQty and 1 or 0,
                currencyInfo.totalEarned,
            }, ':')
            foundAny = true
        end
    end

    if foundAny == false then
        currencies[0] = "0:0:0:0:0:0:0"
    end

    Addon.charData.currencies = currencies
end
