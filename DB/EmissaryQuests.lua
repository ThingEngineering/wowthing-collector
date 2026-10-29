local Module = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector'):GetModule('EmissaryQuests')


Module.db.expansions = {
    -- Legion
    {
        id = 6,
        uiMapId = 627, -- Dalaran
    },
    -- Battle for Azeroth
    {
        id = 7,
        uiMapId = 862, -- Zuldazar
    },
}

-- Map horde quest ID to alliance quest ID for consistency
Module.db.questMap = {
    [50598] = 50599, -- Zandalari Empire -> Proudmoore Admiralty
    [50603] = 50600, -- Voldunai -> Order of Embers
    [50602] = 50601, -- Talanji's Expedition -> Storm's Wake
    [50606] = 50605, -- The Honorbound -> 7th Legion
    [56120] = 56119, -- The Unshackled -> The Waveblade Ankoan
}
