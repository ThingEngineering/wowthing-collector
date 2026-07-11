local Module = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector'):GetModule('Quests')


-- Annoying quests that don't show up in quest log OR as POIs
Module.db.manualCheck = {
    85460, -- Ecological Succession
}

Module.db.progressUnlock = {
    [82414] = 82159, -- Special Assignment: A Pound of Cure
    [82531] = 82161, -- Special Assignment: Bombs From Behind
    [82355] = 82146, -- Special Assignment: Cinderbee Surge
    [82852] = 82158, -- Special Assignment: Lynx Rescue
    [82787] = 82157, -- Special Assignment: Rise of the Colossals
    [81691] = 82155, -- Special Assignment: Shadows Below
    [81647] = 82154, -- Special Assignment: Titanic Resurgence #1
    [81649] = 83069, -- Special Assignment: Titanic Resurgence #2
    [81650] = 83070, -- Special Assignment: Titanic Resurgence #3
    [83229] = 82156, -- Special Assignment: When the Deeps Stir
}
