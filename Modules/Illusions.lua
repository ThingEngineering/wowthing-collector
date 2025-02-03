local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Illusions')

local CT_GetIllusions = C_TransmogCollection.GetIllusions

function Module:OnEnable()
    WWTCSaved.illusions = WWTCSaved.illusions or {}
    
    self.illusionHash = {}
    for _, illusionId in ipairs(WWTCSaved.illusions) do
        self.illusionHash[illusionId] = true
    end

    self:RegisterBucketEvent(
        {
            'TRANSMOG_COLLECTION_SOURCE_ADDED',
            'TRANSMOG_COLLECTION_UPDATED',
        },
        2,
        'UpdateIllusions'
    )
end

function Module:OnEnteringWorld()
    self:UpdateIllusions()
end

function Module:UpdateIllusions()
    Addon.charData.scanTimes["illusions"] = time()

    local illusionData = CT_GetIllusions()
    for _, illusion in ipairs(illusionData) do
        if illusion.isCollected then
            self.illusionHash[illusion.sourceID] = true
        end
    end

    WWTCSaved.illusions = Addon:TableKeys(self.illusionHash)
end
