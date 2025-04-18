local Module = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector'):GetModule('WorldQuests')

-- zones are UiMap IDs
Module.db.expansions = {
    -- Legion
    {
        id = 6,
        minimumLevel = 10,
        zones = {
            627, -- Dalaran
            630, -- Azsuna
            634, -- Stormheim
            641, -- Val'sharah
            646, -- Broken Shore
            650, -- Highmountain
            680, -- Suramar
            790, -- Eye of Azshara
            830, -- Krokuun
            882, -- Eredath
            885, -- Antoran Wastes
        },
    },
    -- Battle for Azeroth
    {
        id = 7,
        minimumLevel = 10,
        zones = {
            14, -- Arathi Highlands
            62, -- Darkshore
            862, -- Zuldazar
            863, -- Nazmir
            864, -- Vol'dun
            895, -- Tiragarde Sound
            896, -- Drustvar
            942, -- Stormsong Valley
            1161, -- Boralus
            1165, -- Dazar'alor
            1355, -- Nazjatar
            1462, -- Mechagon Island
            1527, -- Uldum
            1530  -- Vale of Eternal Blossoms
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
            1543, -- The Maw
            1565, -- Ardenweald
            1961, -- Korthia
            1970, -- Zereth Mortis
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
            2085, -- Primalist Tomorrow
            2112, -- Valdrakken
            2133, -- Zaralek Cavern
            2151, -- The Forbidden Reach
            2200, -- Emerald Dream
        },
    },
    -- The War Within
    {
        id = 10,
        minimumLevel = 70,
        -- UiMap
        zones = {
            2213, -- The City of Threads
            2214, -- The Ringing Deeps
            2215, -- Hallowfall
            2216, -- The City of Threads - Lower
            2248, -- Isle of Dorn
            2255, -- Azj-Kahet
            2256, -- Azj-Kahet - Lower
            2339, -- Dornogal
            2369, -- Siren Isle
            2346, -- Undermine
        },
    },
}
