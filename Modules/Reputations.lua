local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Reputations')


Module.db = {}

local CGI_GetFriendshipReputation = C_GossipInfo.GetFriendshipReputation
local CMF_GetMajorFactionRenownInfo = C_MajorFactions.GetMajorFactionRenownInfo
local CR_GetFactionDataByID = C_Reputation.GetFactionDataByID
local CR_GetFactionParagonInfo = C_Reputation.GetFactionParagonInfo
local CR_IsFactionParagon = C_Reputation.IsFactionParagon

function Module:OnEnable()
    self:RegisterBucketEvent('UPDATE_FACTION', 1, 'UpdateReputations')
end

function Module:OnEnteringWorld()
    self:UpdateReputations()
end

function Module:UpdateReputations()
    local reputations = {}
    local paragons = {}
    
    for _, factionID in ipairs(self.db.reputations) do
        local renownData = CMF_GetMajorFactionRenownInfo(factionID)
        if renownData ~= nil then
            reputations[factionID] = (renownData.renownLevel * renownData.renownLevelThreshold) + renownData.renownReputationEarned
        else
            local factionData = CR_GetFactionDataByID(factionID)
            if factionData ~= nil then
                reputations[factionID] = factionData.currentStanding
            end
        end
    end

    for _, friendshipID in ipairs(self.db.friendships) do
        local friendRep = CGI_GetFriendshipReputation(friendshipID)
        reputations[friendshipID] = friendRep.standing
    end

    for i, factionID in ipairs(self.db.paragon) do
        if CR_IsFactionParagon(factionID) then 
            local currentValue, threshold, _, hasRewardPending = CR_GetFactionParagonInfo(factionID)
            -- value:max:hasReward
            paragons[factionID] = table.concat({
                currentValue or 0,
                threshold or 0,
                hasRewardPending and 1 or 0,
            }, ':')
        end
    end

    Addon.charData.paragons = paragons
    Addon.charData.reputations = reputations

    Addon.charData.scanTimes.reputations = time()
end
