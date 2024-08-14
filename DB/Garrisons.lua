local Module = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector'):GetModule('Garrisons')


Module.db.garrisons = {
    -- Warlords of Draenor
    {
        mustBeInGarrison = true,
        type = Enum.GarrisonType.Type_6_0_Garrison,
    },
    -- Legion
    {
        mustBeInGarrison = false,
        type = Enum.GarrisonType.Type_7_0_Garrison,
    }
}

Module.db.trees = {
    461, -- The Box of Many Things
    474, -- Cypher Research Console
    476, -- Pocopoc Customization
}
