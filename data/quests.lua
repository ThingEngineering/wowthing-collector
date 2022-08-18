local an, ns = ...


-- Emissaries
ns.emissaries = {
    {
        expansion = 6,
        mapId = 627,
        questId = 43341,
    },
    {
        expansion = 7,
        mapId = 876,
        questId = 51722,
    },
}

-- Hidden quests
ns.otherQuests = {
    -- Zereth Mortis
    65282, -- Improved Cypher Analysis Tool

    -- Korthia
    64027, -- Treatise: The Study of Anima and Harnessing Every Drop
    64300, -- Research Report: Adaptive Alloys
    64303, -- Research Report: First Alloys
    64307, -- Treatise: Recognizing Stygia and its Uses
    64366, -- Treatise: Relics Abound in the Shadowlands
    64367, -- Research Report: Relic Examination Techniques
    64828, -- Treatise: Bonds of Stygia in Mortals

    -- Torghast
    61144, -- Possibility Matrix
    63183, -- Extradimensional Pockets
    63193, -- Bangle of Seniority
    63200, -- Rank Insignia: Acquisitionist
    63201, -- Loupe of Unusual Charm
    63202, -- Vessel of Unfortunate Spirits
    63204, -- Ritual Prism of Fortune
    63523, -- Broker Traversal Enhancer

    -- The Maw
    61600, -- Animaflow Stabilizer
    63091, -- Soul-Stabilizing Talisman
    63092, -- Sigil of the Unseen
    63217, -- Animated Levitating Chain
    63177, -- Encased Riftwalker Essence

    -- Soulshapes
    64982, -- Cat (Well Fed)
    64938, -- Corgi

    -- Artifact Hidden Appearances
    43646,
    43647,
    43648,
    43649,
    43650,
    43651,
    43652,
    43653,
    43654,
    43655,
    43656,
    43657,
    43658,
    43659,
    43660,
    43661,
    43662,
    43663,
    43664,
    43665,
    43666,
    43667,
    43668,
    43669,
    43670,
    43671,
    43672,
    43673,
    43674,
    43675,
    43676,
    43677,
    43678,
    43679,
    43680,
    43681,
}

ns.progressQuests = {
    -- Weekly Holidays
    ["weeklyHoliday"] = {"weekly", {
        62631, -- "The World Awaits", World Quests
        62632, -- "A Burning Path Through Time", TBC Timewalking
        62633, -- "A Frozen Path Through Time", Wrath Timewalking
        62634, -- "A Shattered Path Through Time", Cata Timewalking
        62635, -- "A Shattered Path Through Time", MoP Timewalking
        62636, -- "A Savage Path Through Time", WoD Timewalking
        64709, -- "A Fel Path Through Time", Legion Timewalking
        62637, -- "A Call to Battle", Battlegrounds
        62638, -- "Emissary of War", Mythic Dungeons
        62639, -- "The Very Best", PvP Pet Battles
        62640, -- "The Arena Calls", Arena Skirmishes
    }},

    -- Weekly PvP
    ["weeklyPvp"] = {"weekly", {
        62284, -- Observing Battle
        62285, -- Observing War
        62286, -- Observing Skirmishes
        62287, -- Observing Arenas
        62288, -- Observing Teamwork
        --64527, -- Observing the Chase
        65773, -- Solo Mission
        65775, -- Soloing Strategy
    }},

    -- Warlords of Draenor
    ["invasionBoss"] = {"weekly", {38276}},
    ["invasionBronze"] = {"weekly", {37638}},
    ["invasionSilver"] = {"weekly", {37639}},
    ["invasionGold"] = {"weekly", {37640}},
    ["invasionPlatinum"] = {"weekly", {38482}},

    -- Warlords of Draenor: Raids
    ["legBlackrock1Normal"] = {"once", {37029}},
    ["legBlackrock1Heroic"] = {"once", {37030}},
    ["legBlackrock1Mythic"] = {"once", {37031}},

    ["legHellfire1Normal"] = {"once", {39499}},
    ["legHellfire2Normal"] = {"once", {39502}},
    ["legHellfire1Heroic"] = {"once", {39500}},
    ["legHellfire2Heroic"] = {"once", {39504}},
    ["legHellfire1Mythic"] = {"once", {39501}},
    ["legHellfire2Mythic"] = {"once", {39505}},

    -- Legion: Raids
    ["legEmerald1Normal"] = {"once", {44283}},
    ["legEmerald1Heroic"] = {"once", {44284}},
    ["legEmerald1Mythic"] = {"once", {44285}},

    ["legNighthold1Normal"] = {"once", {45381}},
    ["legNighthold1Heroic"] = {"once", {45382}},
    ["legNighthold1Mythic"] = {"once", {45383}},

    ["legTomb1Normal"] = {"once", {47725}},
    ["legTomb1Heroic"] = {"once", {47726}},
    ["legTomb1Mythic"] = {"once", {47727}},
    
    ["legAntorus1Normal"] = {"once", {49032}},
    ["legAntorus2Normal"] = {"once", {49133}},
    ["legAntorus1Heroic"] = {"once", {49075}},
    ["legAntorus2Heroic"] = {"once", {49134}},
    ["legAntorus1Mythic"] = {"once", {49076}},
    ["legAntorus2Mythic"] = {"once", {49135}},

    -- Battle for Azeroth: Raids
    ["bfaNyalotha1Normal"] = {"once", {58373}},
    ["bfaNyalotha1Heroic"] = {"once", {58374}},
    ["bfaNyalotha1Mythic"] = {"once", {58375}},

    -- Shadowlands
    ["kyrianAnima"] = {"weekly", {61982}},
    ["kyrianSouls"] = {"weekly", {62863}},

    ["necrolordAnima"] = {"weekly", {61983}},
    ["necrolordSouls"] = {"weekly", {62866}},

    ["nightFaeAnima"] = {"weekly", {61984}},
    ["nightFaeSouls"] = {"weekly", {62860}},

    ["venthyrAnima"] = {"weekly", {61981}},
    ["venthyrSouls"] = {"weekly", {62869}},

    -- Shadowlands: 9.1
    ["shapingFate"] = {"weekly", {63949}},

    -- Shadowlands: 9.2
    ["newDeal"] = {"weekly", {65649}},
    ["patterns"] = {"weekly", {66042}},

    -- Shadowlands: Raids
    ["slNathria1Normal"] = {"once", {62054}},
    ["slNathria1Heroic"] = {"once", {62055}},
    ["slNathria1Mythic"] = {"once", {62056}},

    ["slSanctum1Normal"] = {"once", {64597}},
    ["slSanctum1Heroic"] = {"once", {64598}},
    ["slSanctum1Mythic"] = {"once", {64599}},

    ["slSepulcher1Normal"] = {"once", {65764}},
    ["slSepulcher1Heroic"] = {"once", {65763}},
    ["slSepulcher1Mythic"] = {"once", {65762}},
}
