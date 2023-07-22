local Addon = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector')
local Module = Addon:NewModule('Illusions')


function Module:OnEnable()
    self:RegisterBucketEvent(
        {
            'TRANSMOG_COLLECTION_SOURCE_ADDED',
            'TRANSMOG_COLLECTION_SOURCE_REMOVED',
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

    local illusions = {}
    local illusionData = C_TransmogCollection.GetIllusions()
    for _, illusion in ipairs(illusionData) do
        if illusion.isCollected then
            table.insert(illusions, illusion.sourceID)
        end
    end

    table.sort(illusions)
    Addon.charData.illusions = table.concat(illusions, ':')
end
