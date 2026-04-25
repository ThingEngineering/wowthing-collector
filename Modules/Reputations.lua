local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Reputations')


Module.db = {}

local CGI_GetFriendshipReputation = C_GossipInfo.GetFriendshipReputation
local CMF_GetMajorFactionRenownInfo = C_MajorFactions.GetMajorFactionRenownInfo
local CR_GetFactionDataByID = C_Reputation.GetFactionDataByID
local CR_GetFactionParagonInfo = C_Reputation.GetFactionParagonInfo
local CR_IsAccountWideReputation = C_Reputation.IsAccountWideReputation
local CR_IsFactionParagon = C_Reputation.IsFactionParagon
local CR_IsMajorFaction = C_Reputation.IsMajorFaction

local MAX_FACTION_ID = 3000
local INIT_CHUNK_SIZE = 100
local SCAN_CHUNK_SIZE = 50

local TYPE_REPUTATION = 1
local TYPE_MAJOR = 2
local TYPE_FRIEND = 3

function Module:OnEnable()
    Addon.charData.paragons = Addon.charData.paragons or {}
    Addon.charData.reputationsV2 = Addon.charData.reputationsV2 or {}
    WWTCSaved.paragons = WWTCSaved.paragons or {}
    WWTCSaved.reputations = WWTCSaved.reputations or {}

    self.factions = {}
    self.factionIds = {}
    self.updatedFactions = false

    self:RegisterBucketEvent('UPDATE_FACTION', 2, 'UpdateReputations')
end

function Module:OnEnteringWorld()
    self:GetFactionData()
end

function Module:GetFactionData()
    if self.updatedFactions == true then
        Module:UpdateReputations()
        return
    end

    local workload = {}

    for chunkIndex = 1, MAX_FACTION_ID, INIT_CHUNK_SIZE do
        tinsert(workload, function()
            -- local startTime = debugprofilestop()
            for factionID = chunkIndex, chunkIndex + INIT_CHUNK_SIZE - 1 do
                local factionType = nil
                local isAccountWide = CR_IsAccountWideReputation(factionID)
                local isParagon = CR_IsFactionParagon(factionID)

                if CR_IsMajorFaction(factionID) then
                    factionType = TYPE_MAJOR
                else
                    local friendshipInfo = CGI_GetFriendshipReputation(factionID)
                    if friendshipInfo ~= nil and friendshipInfo.maxRep > 0 then
                        factionType = TYPE_FRIEND
                    else
                        local reputationInfo = CR_GetFactionDataByID(factionID)
                        if reputationInfo ~= nil then
                            factionType = TYPE_REPUTATION
                        end
                    end
                end

                if factionType ~= nil then
                    self.factions[factionID] = { factionType, isAccountWide, isParagon }
                    tinsert(self.factionIds, factionID)
                end
            end
            -- print('factions '..(debugprofilestop() - startTime))
        end)
    end

    Addon:QueueWorkload(workload, function()
        self.updatedFactions = true
        Module:UpdateReputations()
    end)
end

function Module:UpdateReputations()
    if self.updatedFactions == false then return end

    local now = time()
    Addon.charData.scanTimes.reputations = now
    WWTCSaved.scanTimes.reputations = now

    local accountParagons = WWTCSaved.paragons
    local accountReputations = WWTCSaved.reputations
    local charParagons = Addon.charData.paragons
    local charReputations = Addon.charData.reputationsV2
    wipe(accountParagons)
    wipe(accountReputations)
    wipe(charParagons)
    wipe(charReputations)

    local workload = {}

    for chunkIndex = 1, #self.factionIds, SCAN_CHUNK_SIZE do
        tinsert(workload, function()
            -- local startTime = debugprofilestop()
            for factionIndex = chunkIndex, chunkIndex + SCAN_CHUNK_SIZE - 1 do
                local factionID = self.factionIds[factionIndex]
                if factionID ~= nil then
                    local factionType, isAccountWide, isParagon = unpack(self.factions[factionID])
                    local repValue = -1

                    if factionType == TYPE_REPUTATION then
                        local factionInfo = CR_GetFactionDataByID(factionID)
                        if factionInfo ~= nil then
                            repValue = factionInfo.currentStanding
                        end
                    elseif factionType == TYPE_MAJOR then
                        local renownInfo = CMF_GetMajorFactionRenownInfo(factionID)
                        if renownInfo ~= nil then
                            repValue = (renownInfo.renownLevel * renownInfo.renownLevelThreshold) + renownInfo.renownReputationEarned
                        end
                    elseif factionType == TYPE_FRIEND then
                        local friendshipInfo = CGI_GetFriendshipReputation(factionID)
                        if friendshipInfo ~= nil then
                            repValue = friendshipInfo.standing
                        end
                    end

                    if repValue ~= nil and repValue ~= -1 then
                        local repString = table.concat({ factionID, repValue }, ':')
                        if isAccountWide then
                            tinsert(accountReputations, repString)
                        else
                            tinsert(charReputations, repString)
                        end

                        if isParagon then
                            local currentValue, threshold, _, hasRewardPending = CR_GetFactionParagonInfo(factionID)
                            -- value:max:hasReward
                            local paragonString = table.concat({
                                currentValue or 0,
                                threshold or 0,
                                hasRewardPending and 1 or 0,
                            }, ':')
                            if isAccountWide then
                                accountParagons[factionID] = paragonString
                            else
                                charParagons[factionID] = paragonString
                            end
                        end
                    end
                end
            end
            -- print('reputations '..(debugprofilestop() - startTime))
        end)
    end

    Addon:QueueWorkload(workload)
end
