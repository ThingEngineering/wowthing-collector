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

    65471, -- Pocopoc's Bronze and Gold Body
    65472, -- Pocopoc's Beryllium and Silver Body
    65473, -- Pocopoc's Cobalt and Copper Body
    65474, -- Pocopoc's Ruby and Platinum Body
    65476, -- Pocopoc's Gold and Ruby Components
    65477, -- Pocopoc's Silver and Beryllium Components
    65478, -- Pocopoc's Copper and Cobalt Components
    65479, -- Pocopoc's Platinum and Emerald Components
    65481, -- Pocopoc's Diamond Vambraces
    65482, -- Pocopoc's Face Decoration
    65483, -- Pocopoc's Shielded Core
    65484, -- Pocopoc's Upgraded Core

    65524, -- Chef Pocopoc
    65525, -- Peaceful Pocopoc
    65526, -- Pirate Pocopoc
    65527, -- Adventurous Pocopoc
    65528, -- Dapper Pocopoc
    65529, -- Admiral Pocopoc
    65534, -- Pocobold
    65538, -- Pepepec

    65753, -- Cosmic Gladiator's Devouring Malediction
    65754, -- Cosmic Gladiator's Eternal Aegis
    65755, -- Cosmic Gladiator's Resonator
    65756, -- Cosmic Gladiator's Echoing Resolve
    65757, -- Cosmic Gladiator's Fastidious Resolve

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

    -- Path of Ascension: Kalisthene
    60917, -- Courage
    61023, -- Loyalty
    61033, -- Wisdom
    61043, -- Humility - no charms
    63102, -- Humility - Pelagos
    63103, -- Humility - Kleia
    63104, -- Humility - Mikanikos

    -- Path of Ascension: Echthra
    60918, -- Courage
    61022, -- Loyalty
    61032, -- Wisdom
    61042, -- Humility - no charms
    63105, -- Humility - Pelagos
    63106, -- Humility - Kleia
    63107, -- Humility - Mikanikos

    -- Path of Ascension: Alderyn and Myn'ir
    60919, -- Courage
    61021, -- Loyalty
    61031, -- Wisdom
    61041, -- Humility - no charms
    63108, -- Humility - Pelagos
    63109, -- Humility - Kleia
    63110, -- Humility - Mikanikos

    -- Path of Ascension: Nuuminuuru
    60921, -- Courage
    61020, -- Loyalty
    61030, -- Wisdom
    61040, -- Humility - no charms
    63111, -- Humility - Pelagos
    63112, -- Humility - Kleia
    63113, -- Humility - Mikanikos

    -- Path of Ascension: Craven Corinth
    60922, -- Courage
    61019, -- Loyalty
    61029, -- Wisdom
    61039, -- Humility - no charms
    63114, -- Humility - Pelagos
    63115, -- Humility - Kleia
    63116, -- Humility - Mikanikos

    -- Path of Ascension: Splinterbark Nightmare
    60923, -- Courage
    61018, -- Loyalty
    61028, -- Wisdom
    61038, -- Humility - no charms
    63117, -- Humility - Pelagos
    63118, -- Humility - Kleia
    63119, -- Humility - Mikanikos

    -- Path of Ascension: Thran'tiok
    60924, -- Courage
    61017, -- Loyalty
    61027, -- Wisdom
    61037, -- Humility - no charms
    63120, -- Humility - Pelagos
    63121, -- Humility - Kleia
    63122, -- Humility - Mikanikos

    -- Path of Ascension: Mad Mortimer
    60925, -- Courage
    61016, -- Loyalty
    61026, -- Wisdom
    61036, -- Humility - no charms
    63123, -- Humility - Pelagos
    63124, -- Humility - Kleia
    63125, -- Humility - Mikanikos

    -- Path of Ascension: Athanos
    60926, -- Courage
    61015, -- Loyalty
    61025, -- Wisdom
    61035, -- Humility - no charms
    63126, -- Humility - Pelagos
    63127, -- Humility - Kleia
    63128, -- Humility - Mikanikos

    -- Path of Ascension: Azaruux
    60927, -- Courage
    61014, -- Loyalty
    61024, -- Wisdom
    61034, -- Humility - no charms
    63129, -- Humility - Pelagos
    63130, -- Humility - Kleia
    63131, -- Humility - Mikanikos
    
    -- Ember Court: RSVP
    59383, -- Baroness Vashj
    59386, -- Lady Moonberry
    59389, -- Mikanikos
    59392, -- The Countess
    59395, -- Alexandros Mograine
    59398, -- Hunt-Captain Korayn
    59401, -- Polemarch Adrestes
    59404, -- Rendle & Cudgelface
    59407, -- Choofa
    59410, -- Cryptkeeper Kassir
    59413, -- Droman Aliothe
    59416, -- Grandmaster Vole
    59419, -- Kleia & Pelagos
    59422, -- Plague Deviser Marileth
    59425, -- Sika
    59619, -- Stonehead

    -- Ember Court: Unlocks
    61458, -- Visions of Sire Denathrius
    61493, -- Decorations
    61494, -- Security
    61497, -- Stock: Greeting Kits
    61498, -- Stock: Appetizers
    61499, -- Stock: Anima Samples
    61500, -- Stock: Comfy Chairs
    61501, -- Staff: Revendreth Ambassador
    61502, -- Staff: Ardenweald Ambassador
    61887, -- Staff: Maldraxxus Ambassador
    61888, -- Staff: Bastion Ambassador
    -- 61705, -- Refreshments
    -- 61706, -- Entertainment

    -- Ember Court: Be Our Guest tracking?
    62487, -- Baroness Vashj
    62488, -- Lady Moonberry
    62489, -- Mikanikos
    62490, -- The Countess
    62491, -- Alexandros Mograine
    62492, -- Hunt-Captain Korayn
    62493, -- Polemarch Adrestes
    62494, -- Rendle & Cudgelface
    62495, -- Choofa
    62496, -- Cryptkeeper Kassir
    62497, -- Droman Aliothe
    62498, -- Grandmaster Vole
    62499, -- Kleia & Pelagos
    62500, -- Plague Deviser Marileth
    62501, -- Sika
    62502, -- Stonehead

    -- Ember Court: Friend of a Friend
    -- 65121, -- Baroness Vashj
    -- 65123, -- Lady Moonberry
    -- 65124, -- Mikanikos
    -- 65126, -- The Countess
    -- 65128, -- Alexandros Mograine
    -- 65129, -- Hunt-Captain Korayn
    -- 65130, -- Polemarch Adrestes
    -- 65131, -- Rendle & Cudgelface
    -- 65132, -- Choofa
    -- 65134, -- Cryptkeeper Kassir
    -- 65135, -- Droman Aliothe
    -- 65136, -- Grandmaster Vole
    -- 65137, -- Kleia & Pelagos
    -- 65138, -- Plague Deviser Marileth
    -- 65140, -- Sika
    -- 65141, -- Stonehead

    -- Legion: Artifact Hidden Appearances
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
        --62631, -- "The World Awaits", World Quests [SL]
        62632, -- "A Burning Path Through Time", TBC Timewalking
        62633, -- "A Frozen Path Through Time", Wrath Timewalking
        62634, -- "A Shattered Path Through Time", Cata Timewalking
        --62635, -- "A Shrouded Path Through Time", MoP Timewalking
        --62636, -- "A Savage Path Through Time", WoD Timewalking
        64709, -- "A Fel Path Through Time", Legion Timewalking
        --62637, -- "A Call to Battle", Battlegrounds
        --62638, -- "Emissary of War", Mythic Dungeons
        62639, -- "The Very Best", PvP Pet Battles
        62640, -- "The Arena Calls", Arena Skirmishes

        -- Dragonflight
        72722, -- "Emissary of War", Mythic Dungeons
        72723, -- "A Call to Battle", Battlegrounds
        72724, -- "A Savage Path Through Time", WoD Timewalking
        72725, -- "A Shrouded Path Through Time", MoP Timewalking
        72728, -- "The World Awaits", World Quests
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

    -- PvP Brawl
    ["somethingDifferent"] = {"weekly", {47148}},

    -- Timewalking turn-ins
    ["timewalking"] = {"weekly", {
        40168, -- The Swirling Vial, TBC
        40173, -- The Unstable Prism, Wrath
        40786, -- The Smoldering Ember, Cata [Horde]
        40787, -- The Smoldering Ember, Cata [Alliance]
        45563, -- The Shrouded Coin, MoP
        55498, -- The Shimmering Crystal, WoD
        64710, -- Whispering Fel Crystal, Legion
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

    -- Legion: Misc
    ["legionWitheredTraining"] = {"wq", {43943}},

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
    ["slTormentors"] = {"weekly", {63854}},
    ["slMawAssault"] = {"biweekly", {
        63543, -- Necrolord
        63822, -- Venthyr
        63823, -- Night Fae
        63824, -- Kyrian
    }},

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

    -- Dragonflight
    ["dfAidingAccord"] = {"weekly", {
        70750, -- Aiding the Accord
        --71243
        72068, -- Aiding the Accord: A Feast For All
        --72369
        72373, -- Aiding the Accord: A Hunt Is On
        72374, -- Aiding the Accord: Dragonbane Keep
        72375, -- Aiding the Accord: The Isles Call
        --72892
    }},

    ["dfCatchIslefin"] = {"weekly", {72823}}, -- Catch and Release: Islefin Dorado
    ["dfCatchTemporal"] = {"weekly", {72824}}, -- Catch and Release: Temporal Dragonhead
    ["dfCatchCerulean"] = {"weekly", {72825}}, -- Catch and Release: Cerulean Spinefish
    ["dfCatchAileron"] = {"weekly", {72826}}, -- Catch and Release: Aileron Seamoth
    ["dfCatchThousandbite"] = {"weekly", {72827}}, -- Catch and Release: Thousandbite Piranha
    ["dfCatchScalebelly"] = {"weekly", {72828}}, -- Catch and Release: Scalebelly Mackerel

    ["dfDungeonPreserving"] = {"weekly", {
        66868, -- Preserving the Past: Legacy of Tyr
        66869, -- Preserving the Past: Court of Stars (?)
        66870, -- Preserving the Past: Ruby Life Pools
        66871, -- Preserving the Past: The Nokhud Offensive
        66872, -- Preserving the Past: Brackenhide Hollow (?)
        66873, -- Preserving the Past: The Azure Vault (?)
        66874, -- Preserving the Past: Halls of Infusion
        66875, -- Preserving the Past: Algeth'ar Academy
    }},
    ["dfDungeonRelic"] = {"weekly", {
        66860, -- Relic Recovery: Legacy of Tyr
        66861, -- Relic Recovery: Court of Stars (?)
        66862, -- Relic Recovery: Ruby Life Pools
        66863, -- Relic Recovery: The Nokhud Offensive (?)
        66864, -- Relic Recovery: Brackenhide Hollow
        66865, -- Relic Recovery: The Azure Vault
        66866, -- Relic Recovery: Halls of Infusion
        66867, -- Relic Recovery: Algeth'ar Academy
    }},

    ["dfProfessionMettle"] = {"weekly", { 70221 }},

    ["dfProfessionAlchemyCraft"] = {"weekly", {
        70530, -- 
        70531, -- 
        70532, -- 
        70533, -- 
    }},
    ["dfProfessionAlchemyGather"] = {"weekly", {
        66937, -- 
        66938, -- 
        66940, -- Elixir Experiment
        72427, -- Animated Infusion
    }},
    ["dfProfessionAlchemyTreatise"] = {"weekly", { 74108 }},

    ["dfProfessionBlacksmithingCraft"] = {"weekly", {
        70211, -- Stomping Explorers
        70233, -- Axe Shortage
        70234, -- All This Hammering
        70235, -- Repair Bill
    }},
    ["dfProfessionBlacksmithingGather"] = {"weekly", {
        66517, -- A New Source of Weapons
        66897, -- Fuel for the Forge
        66941, -- Tremendous Tools
        72398, -- Rock and Stone
    }},
    ["dfProfessionBlacksmithingOrders"] = {"weekly", { 70589 }},
    ["dfProfessionBlacksmithingTreatise"] = {"weekly", { 74109 }},

    ["dfProfessionEnchantingCraft"] = {"weekly", {
        72155, -- 
        72172, -- 
        72173, -- 
        72175, -- 
    }},
    ["dfProfessionEnchantingGather"] = {"weekly", {
        66884, -- 
        66900, -- 
        66935, -- 
        72423, -- 
    }},
    ["dfProfessionEnchantingTreatise"] = {"weekly", { 74110 }},

    ["dfProfessionEngineeringCraft"] = {"weekly", {
        70539, --
        70540, --
        70545, --
        70557, --
    }},
    ["dfProfessionEngineeringGather"] = {"weekly", {
        66890, -- 
        66891, -- Explosive Ash
        66942, -- Enemy Engineering
        72396, -- 
    }},
    ["dfProfessionEngineeringOrders"] = {"weekly", { 70591 }},
    ["dfProfessionEngineeringTreatise"] = {"weekly", { 74111 }},

    ["dfProfessionInscriptionCraft"] = {"weekly", {
        70558, -- 
        70559, -- 
        70560, -- 
        70561, -- 
    }},
    ["dfProfessionInscriptionGather"] = {"weekly", {
        66943, -- 
        66944, -- Peacock Pigments
        66945, -- 
    }},
    ["dfProfessionInscriptionOrders"] = {"weekly", { 70592 }},
    ["dfProfessionInscriptionTreatise"] = {"weekly", { 74105 }},

    ["dfProfessionJewelcraftingCraft"] = {"weekly", {
        70562, -- 
        70563, -- 
        70564, -- 
        70565, -- 
    }},
    ["dfProfessionJewelcraftingGather"] = {"weekly", {
        66516, -- Mundane Gems, I Think Not!
        66949, -- 
        66950, -- 
        72428, -- 
    }},
    ["dfProfessionJewelcraftingOrders"] = {"weekly", { 70593 }},
    ["dfProfessionJewelcraftingTreatise"] = {"weekly", { 74112 }},

    ["dfProfessionLeatherworkingCraft"] = {"weekly", {
        70567, -- When You Give Bakar a Bone
        70568, -- Tipping the Scales
        70569, -- For Trisket, a Task Kit
        70571, -- Drums Here!
    }},
    ["dfProfessionLeatherworkingGather"] = {"weekly", {
        66363, -- Basilisk Bucklers
        66364, -- To Fly a Kite
        66951, -- Population Control
        72407, -- Soaked in Success
    }},
    ["dfProfessionLeatherworkingOrders"] = {"weekly", { 70594 }},
    ["dfProfessionLeatherworkingTreatise"] = {"weekly", { 74113 }},

    ["dfProfessionTailoringCraft"] = {"weekly", {
        70572, -- 
        70582, -- 
        70586, -- Sew Many Cooks
        70587, -- 
    }},
    ["dfProfessionTailoringGather"] = {"weekly", {
        66952, -- 
        66899, -- 
        66953, -- 
        72410, -- Pincers and Needles
    }},
    ["dfProfessionTailoringOrders"] = {"weekly", { 70595 }},
    ["dfProfessionTailoringTreatise"] = {"weekly", { 74115 }},

    ["dfProfessionHerbalismGather"] = {"weekly", {
        70613, -- Get Their Bark Before They Bite
        70614, -- Bubble Craze
        70615, -- The Case of the Missing Herbs
        70616, -- How Many??
    }},
    ["dfProfessionHerbalismTreatise"] = {"weekly", { 74107 }},

    ["dfProfessionMiningGather"] = {"weekly", {
        70617, -- All Mine, Mine, Mine
        70618, -- The Call of the Forge
        72156, -- A Fiery Fight
        72157, -- The Weight of Earth
    }},
    ["dfProfessionMiningTreatise"] = {"weekly", { 74106 }},

    ["dfProfessionSkinningGather"] = {"weekly", {
        70619, -- A Study of Leather
        70620, -- Scaling Up
        72158, -- A Dense Delivery
        72159, -- Scaling Down
    }},
    ["dfProfessionSkinningTreatise"] = {"weekly", { 74114 }},

    ["dfSparks"] = {"weekly", {
        72646, -- Sparks of Life: The Waking Shores
        72647, -- Sparks of Life: Ohn'ahran Plains
        72648, -- Sparks of Life: Azure Span
        72649, -- Sparks of Life: Thaldraszus
    }},

    ["dfCommunityFeast"] = {"weekly", {70893}},
    ["dfDragonAllegiance"] = {"weekly", {66419}}, -- choose a dragon
    ["dfDragonKey"] = {"weekly", {66133, 66805}}, -- hand in key (wrathion, sabellian)
    ["dfGrandHuntMythic"] = {"weekly", {70906}},
    ["dfGrandHuntRare"] = {"weekly", {71136}},
    ["dfGrandHuntUncommon"] = {"weekly", {71137}},
    ["dfPrimalEarth"] = {"weekly", {70723}},
    ["dfPrimalFire"] = {"weekly", {70754}},
    ["dfPrimalStorm"] = {"weekly", {70753}},
    ["dfPrimalWater"] = {"weekly", {70752}},
    ["dfSiegeDragonbaneKeep"] = {"weekly", {70866}},
    ["dfTrialElements"] = {"weekly", {71995}},
    ["dfTrialFlood"] = {"weekly", {71033}},
}
