local an, ns = ...


ns.garrisons = {
    -- Warlords of Draenor
    {
        mustBeInGarrison = true,
        type = Enum.GarrisonType.Type_6_0,
    },
    -- Legion
    {
        mustBeInGarrison = false,
        type = Enum.GarrisonType.Type_7_0,
    }
}

ns.garrisonTrees = {
    461, -- The Box of Many Things
    474, -- Cypher Research Console
    476, -- Pocopoc Customization
}
