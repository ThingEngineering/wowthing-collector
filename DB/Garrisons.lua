local Module = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector'):GetModule('Garrisons')


Module.db.garrisons = {
    -- Warlords of Draenor
    {
        mustBeInGarrison = false,
        type = Enum.GarrisonType.Type_6_0_Garrison,
        followerTypes = {
            Enum.GarrisonFollowerType.FollowerType_6_0_GarrisonFollower,
        },
    },
    -- Legion
    {
        mustBeInGarrison = false,
        type = Enum.GarrisonType.Type_7_0_Garrison,
        followerTypes = {
            Enum.GarrisonFollowerType.FollowerType_7_0_GarrisonFollower,
        },
    },
    -- Battle for Azeroth
    {
        mustBeInGarrison = false,
        type = Enum.GarrisonType.Type_8_0_Garrison,
        followerTypes = {
            Enum.GarrisonFollowerType.FollowerType_8_0_GarrisonFollower,
        },
    },
    -- Shadowlands
    {
        mustBeInGarrison = false,
        type = Enum.GarrisonType.Type_9_0_Garrison,
        followerTypes = {
            Enum.GarrisonFollowerType.FollowerType_9_0_GarrisonFollower,
        },
    },
}

Module.db.trees = {
    461, -- The Box of Many Things
    474, -- Cypher Research Console
    476, -- Pocopoc Customization
}
