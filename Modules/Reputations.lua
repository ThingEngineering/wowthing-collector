local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Reputations')


Module.db = {}

function Module:OnEnable()
    self:RegisterBucketEvent('UPDATE_FACTION', 1, 'UpdateReputations')
end

function Module:OnEnteringWorld()
    self:UpdateReputations()
end

function Module:UpdateReputations()
    Addon.charData.scanTimes['reputations'] = time()

    Addon.charData.paragons = {}
    Addon.charData.reputations = {}
    
    for _, factionID in ipairs(self.db.reputations) do
        local _, _, _, _, _, barValue = GetFactionInfoByID(factionID)
        Addon.charData.reputations[factionID] = barValue
    end

    for _, friendshipID in ipairs(self.db.friendships) do
        local _, friendRep = C_GossipInfo.GetFriendshipReputation(friendshipID)
        Addon.charData.reputations[friendshipID] = friendRep
    end

    for i, factionID in ipairs(self.db.paragon) do
        if C_Reputation.IsFactionParagon(factionID) then 
            local currentValue, threshold, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID)
            -- value:max:hasReward
            Addon.charData.paragons[factionID] = table.concat({
                currentValue or 0,
                threshold or 0,
                hasRewardPending and 1 or 0,
            }, ':')
        end
    end
end
