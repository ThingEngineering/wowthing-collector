local Module = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector'):GetModule('Delves')


Module.db.zones = {
    -- Silvermoon City
    {
        uiMapId = 2393,
        pois = {
            { active = 8426, inactive = 8425, quest = 91186 }, -- Collegiate Calamity
            { active = 8440, inactive = 8439, quest = 92444 }, -- The Darkway
        },
    },
    -- Isle of Quel'Danas
    {
        uiMapId = 2424,
        pois = {
            { active = 8428, inactive = 8427, quest = 91182 }, -- Parhelion Plaza
        },
    },
    -- Eversong Woods
    {
        uiMapId = 2395,
        pois = {
            { active = 8438, inactive = 8437, quest = 91189 }, -- The Shadow Enclave
        },
    },
    -- Voidstorm
    {
        uiMapId = 2405,
        pois = {
            { active = 8432, inactive = 8431, quest = 91184 }, -- Shadowguard Point
            { active = 8430, inactive = 8429, quest = 91183 }, -- Sunkiller Sanctum
        },
    },
    -- Harandar
    {
        uiMapId = 2413,
        pois = {
            { active = 8434, inactive = 8433, quest = 91185 }, -- The Grudge Pit
            { active = 8436, inactive = 8435, quest = 91187 }, -- The Gulf of Memory
        },
    },
    -- Zul'Aman
    {
        uiMapId = 2437,
        pois = {
            { active = 8444, inactive = 8443, quest = 91188 }, -- Atal'Aman
            { active = 8442, inactive = 8441, quest = 91190 }, -- Twilight Crypts
        },
    },
}
