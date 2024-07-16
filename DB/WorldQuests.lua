local Module = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector'):GetModule('WorldQuests')

-- zones are UiMap IDs
Module.db.expansions = {
    -- Battle for Azeroth
    {
        id = 7,
        minimumLevel = 10,
        zones = {
            862, -- Zuldazar
            863, -- Nazmir
            864, -- Vol'dun
            895, -- Tiragarde Sound
            896, -- Drustvar
            942, -- Stormsong Valley
            1355, -- Nazjatar
            1462, -- Mechagon Island
        },
    },
    -- Shadowlands
    {
        id = 8,
        minimumLevel = 10,
        zones = {
            1525, -- Revendreth
            1533, -- Bastion
            1536, -- Maldraxxus
            1565, -- Ardenweald
        },
    },
    -- Dragonflight
    {
        id = 9,
        minimumLevel = 60,
        -- UiMap
        zones = {
            2022, -- The Waking Shores
            2023, -- Ohn'ahran Plains
            2024, -- Azure Span
            2025, -- Thaldraszus
            2133, -- Zaralek Cavern
            2151, -- The Forbidden Reach
            2200, -- Emerald Dream
        },
    },
}
