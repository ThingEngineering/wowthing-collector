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

    -- Shadowlands: Soulshapes
    64982, -- Cat (Well Fed)
    64938, -- Corgi

    -- Shadowlands: Path of Ascension: Kalisthene
    60917, -- Courage
    61023, -- Loyalty
    61033, -- Wisdom
    61043, -- Humility - no charms
    63102, -- Humility - Pelagos
    63103, -- Humility - Kleia
    63104, -- Humility - Mikanikos

    -- Shadowlands: Path of Ascension: Echthra
    60918, -- Courage
    61022, -- Loyalty
    61032, -- Wisdom
    61042, -- Humility - no charms
    63105, -- Humility - Pelagos
    63106, -- Humility - Kleia
    63107, -- Humility - Mikanikos

    -- Shadowlands: Path of Ascension: Alderyn and Myn'ir
    60919, -- Courage
    61021, -- Loyalty
    61031, -- Wisdom
    61041, -- Humility - no charms
    63108, -- Humility - Pelagos
    63109, -- Humility - Kleia
    63110, -- Humility - Mikanikos

    -- Shadowlands: Path of Ascension: Nuuminuuru
    60921, -- Courage
    61020, -- Loyalty
    61030, -- Wisdom
    61040, -- Humility - no charms
    63111, -- Humility - Pelagos
    63112, -- Humility - Kleia
    63113, -- Humility - Mikanikos

    -- Shadowlands: Path of Ascension: Craven Corinth
    60922, -- Courage
    61019, -- Loyalty
    61029, -- Wisdom
    61039, -- Humility - no charms
    63114, -- Humility - Pelagos
    63115, -- Humility - Kleia
    63116, -- Humility - Mikanikos

    -- Shadowlands: Path of Ascension: Splinterbark Nightmare
    60923, -- Courage
    61018, -- Loyalty
    61028, -- Wisdom
    61038, -- Humility - no charms
    63117, -- Humility - Pelagos
    63118, -- Humility - Kleia
    63119, -- Humility - Mikanikos

    -- Shadowlands: Path of Ascension: Thran'tiok
    60924, -- Courage
    61017, -- Loyalty
    61027, -- Wisdom
    61037, -- Humility - no charms
    63120, -- Humility - Pelagos
    63121, -- Humility - Kleia
    63122, -- Humility - Mikanikos

    -- Shadowlands: Path of Ascension: Mad Mortimer
    60925, -- Courage
    61016, -- Loyalty
    61026, -- Wisdom
    61036, -- Humility - no charms
    63123, -- Humility - Pelagos
    63124, -- Humility - Kleia
    63125, -- Humility - Mikanikos

    -- Shadowlands: Path of Ascension: Athanos
    60926, -- Courage
    61015, -- Loyalty
    61025, -- Wisdom
    61035, -- Humility - no charms
    63126, -- Humility - Pelagos
    63127, -- Humility - Kleia
    63128, -- Humility - Mikanikos

    -- Shadowlands: Path of Ascension: Azaruux
    60927, -- Courage
    61014, -- Loyalty
    61024, -- Wisdom
    61034, -- Humility - no charms
    63129, -- Humility - Pelagos
    63130, -- Humility - Kleia
    63131, -- Humility - Mikanikos
    
    -- Shadowlands: Ember Court: RSVP
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

    -- Shadowlands: Ember Court: Unlocks
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

    -- Shadowlands: Ember Court: Be Our Guest tracking?
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

    -- Shadowlands: Torghast
    61144, -- Possibility Matrix
    63183, -- Extradimensional Pockets
    63193, -- Bangle of Seniority
    63200, -- Rank Insignia: Acquisitionist
    63201, -- Loupe of Unusual Charm
    63202, -- Vessel of Unfortunate Spirits
    63204, -- Ritual Prism of Fortune
    63523, -- Broker Traversal Enhancer

    -- Shadowlands: The Maw
    61600, -- Animaflow Stabilizer
    63091, -- Soul-Stabilizing Talisman
    63092, -- Sigil of the Unseen
    63217, -- Animated Levitating Chain
    63177, -- Encased Riftwalker Essence

    -- Shadowlands: Korthia
    64027, -- Treatise: The Study of Anima and Harnessing Every Drop
    64300, -- Research Report: Adaptive Alloys
    64303, -- Research Report: First Alloys
    64307, -- Treatise: Recognizing Stygia and its Uses
    64366, -- Treatise: Relics Abound in the Shadowlands
    64367, -- Research Report: Relic Examination Techniques
    64828, -- Treatise: Bonds of Stygia in Mortals

    -- Shadowlands: Zereth Mortis
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

    -- 65753, -- Cosmic Gladiator's Devouring Malediction
    -- 65754, -- Cosmic Gladiator's Eternal Aegis
    -- 65755, -- Cosmic Gladiator's Resonator
    -- 65756, -- Cosmic Gladiator's Echoing Resolve
    -- 65757, -- Cosmic Gladiator's Fastidious Resolve

    -- Dragonflight: Drake Customization
    69161, -- Cliffside Wylderdrake: Armor
    69191, -- Cliffside Wylderdrake: Black Horns
    69186, -- Cliffside Wylderdrake: Black Hair
    69213, -- Cliffside Wylderdrake: Black Scales
    69187, -- Cliffside Wylderdrake: Blonde Hair
    69212, -- Cliffside Wylderdrake: Blue Scales
    69219, -- Cliffside Wylderdrake: Blunt Spiked Tail
    69196, -- Cliffside Wylderdrake: Branched Horns
    69165, -- Cliffside Wylderdrake: Bronze and Teal Armor
    69200, -- Cliffside Wylderdrake: Coiled Horns
    69181, -- Cliffside Wylderdrake: Conical Head
    69162, -- Cliffside Wylderdrake: Silver and Purple Armor
    69179, -- Cliffside Wylderdrake: Curled Head Horns
    69215, -- Cliffside Wylderdrake: Dark Skin Variation
    69173, -- Cliffside Wylderdrake: Dual Horned Chin
    69182, -- Cliffside Wylderdrake: Ears
    69169, -- Cliffside Wylderdrake: Finned Back
    69201, -- Cliffside Wylderdrake: Finned Cheek
    69184, -- Cliffside Wylderdrake: Finned Jaw
    69222, -- Cliffside Wylderdrake: Finned Neck
    69218, -- Cliffside Wylderdrake: Finned Tail
    69202, -- Cliffside Wylderdrake: Flared Cheek
    69174, -- Cliffside Wylderdrake: Four Horned Chin
    69164, -- Cliffside Wylderdrake: Gold and Black Armor
    69166, -- Cliffside Wylderdrake: Gold and Orange Armor
    69167, -- Cliffside Wylderdrake: Gold and White Armor
    69211, -- Cliffside Wylderdrake: Green Scales
    69175, -- Cliffside Wylderdrake: Head Fin
    69176, -- Cliffside Wylderdrake: Head Mane
    69192, -- Cliffside Wylderdrake: Heavy Horns
    69190, -- Cliffside Wylderdrake: Helm
    69198, -- Cliffside Wylderdrake: Hook Horns
    69185, -- Cliffside Wylderdrake: Horned Jaw
    69205, -- Cliffside Wylderdrake: Horned Nose
    69217, -- Cliffside Wylderdrake: Large Tail Spikes
    69183, -- Cliffside Wylderdrake: Maned Jaw
    69223, -- Cliffside Wylderdrake: Maned Neck
    69216, -- Cliffside Wylderdrake: Maned Tail
    69208, -- Cliffside Wylderdrake: Narrow Stripes Pattern
    69172, -- Cliffside Wylderdrake: Plated Brow
    69206, -- Cliffside Wylderdrake: Plated Nose
    69188, -- Cliffside Wylderdrake: Red Mane
    69209, -- Cliffside Wylderdrake: Scaled Pattern
    69194, -- Cliffside Wylderdrake: Short Horns
    69163, -- Cliffside Wylderdrake: Silver and Blue Armor
    69193, -- Cliffside Wylderdrake: Sleek Horns
    69178, -- Cliffside Wylderdrake: Small Head Spikes
    69220, -- Cliffside Wylderdrake: Spear Tail
    69170, -- Cliffside Wylderdrake: Spiked Back
    69171, -- Cliffside Wylderdrake: Spiked Brow
    69203, -- Cliffside Wylderdrake: Spiked Cheek
    69221, -- Cliffside Wylderdrake: Spiked Club Tail
    69195, -- Cliffside Wylderdrake: Spiked Horns
    69204, -- Cliffside Wylderdrake: Spiked Legs
    69177, -- Cliffside Wylderdrake: Split Head Horns
    69197, -- Cliffside Wylderdrake: Split Horns
    69168, -- Cliffside Wylderdrake: Steel and Yellow Armor
    69199, -- Cliffside Wylderdrake: Swept Horns
    69180, -- Cliffside Wylderdrake: Triple Head Horns
    69189, -- Cliffside Wylderdrake: White Hair
    69214, -- Cliffside Wylderdrake: White Scales
    69207, -- Cliffside Wylderdrake: Wide Stripes Pattern
    69210, -- Cliffside Wylderdrake: Red Scales
    69300, -- Highland Drake: Armor
    69318, -- Highland Drake: Black Hair
    69343, -- Highland Drake: Black Scales
    69354, -- Highland Drake: Bladed Tail
    69346, -- Highland Drake: Bronze Scales
    69319, -- Highland Drake: Brown Hair
    69302, -- Highland Drake: Bushy Brow
    69350, -- Highland Drake: Club Tail
    69326, -- Highland Drake: Coiled Horns
    69301, -- Highland Drake: Crested Brow
    69329, -- Highland Drake: Curled Back Horns
    69317, -- Highland Drake: Ears
    69299, -- Highland Drake: Finned Back
    69307, -- Highland Drake: Finned Head
    69356, -- Highland Drake: Finned Neck
    69290, -- Highland Drake: Gold and Black Armor
    69357, -- Highland Drake: Gold and Green Armor
    69295, -- Highland Drake: Gold and Red Armor
    69296, -- Highland Drake: Gold and White Armor
    69328, -- Highland Drake: Grand Thorn Horns
    69344, -- Highland Drake: Green Scales
    69332, -- Highland Drake: Hairy Cheek
    69323, -- Highland Drake: Heavy Horns
    69348, -- Highland Drake: Heavy Scales
    69320, -- Highland Drake: Helm
    69327, -- Highland Drake: Hooked Horns
    69353, -- Highland Drake: Hooked Tail
    69303, -- Highland Drake: Horned Chin
    69304, -- Highland Drake: Maned Chin
    69312, -- Highland Drake: Maned Head
    69315, -- Highland Drake: Multi-Horned Head
    69321, -- Highland Drake: Ornate Helm
    69339, -- Highland Drake: Pattern 1
    69340, -- Highland Drake: Pattern 2
    69341, -- Highland Drake: Pattern 3
    69311, -- Highland Drake: Plated Head
    69345, -- Highland Drake: Red Scales
    69342, -- Highland Drake: Scaled Pattern
    69291, -- Highland Drake: Silver and Blue Armor
    69294, -- Highland Drake: Silver and Purple Armor
    69313, -- Highland Drake: Single Horned Head
    69330, -- Highland Drake: Sleek Horns
    69310, -- Highland Drake: Spiked Head
    69333, -- Highland Drake: Spiked Cheek
    69351, -- Highland Drake: Spiked Club Tail
    69335, -- Highland Drake: Spiked Legs
    69352, -- Highland Drake: Spiked Tail
    69298, -- Highland Drake: Spined Back
    69334, -- Highland Drake: Spined Cheek
    69306, -- Highland Drake: Spined Chin
    69309, -- Highland Drake: Spined Head
    69355, -- Highland Drake: Spined Neck
    69338, -- Highland Drake: Spined Nose
    69331, -- Highland Drake: Stag Horns
    69297, -- Highland Drake: Steel and Yellow Armor
    69325, -- Highland Drake: Swept Horns
    69314, -- Highland Drake: Swept Spiked Head
    69322, -- Highland Drake: Tan Horns
    69305, -- Highland Drake: Tapered Chin
    69324, -- Highland Drake: Thorn Horns
    69316, -- Highland Drake: Thorned Jaw
    69308, -- Highland Drake: Triple Finned Head
    69336, -- Highland Drake: Toothy Mouth
    69337, -- Highland Drake: Taperered Nose
    69349, -- Highland Drake: Vertical Finned Tail
    69347, -- Highland Drake: White Scales
    69558, -- Renewed Proto-Drake: Armor
    69602, -- Renewed Proto-Drake: Beaked Snout
    69549, -- Renewed Proto-Drake: Black and Red Armor
    69593, -- Renewed Proto-Drake: Black Scales
    69569, -- Renewed Proto-Drake: Blue Hair
    69591, -- Renewed Proto-Drake: Blue Scales
    69578, -- Renewed Proto-Drake: Bovine Horns
    69592, -- Renewed Proto-Drake: Bronze Scales
    69554, -- Renewed Proto-Drake: Bronze and Pink Armor
    69570, -- Renewed Proto-Drake: Brown Hair
    69604, -- Renewed Proto-Drake: Club Tail
    69576, -- Renewed Proto-Drake: Curled Horns
    69581, -- Renewed Proto-Drake: Curved Horns
    69559, -- Renewed Proto-Drake: Curved Spiked Brow
    69567, -- Renewed Proto-Drake: Dual Horned Crest
    69577, -- Renewed Proto-Drake: Ears
    69556, -- Renewed Proto-Drake: Finned Back
    69566, -- Renewed Proto-Drake: Finned Crest
    69589, -- Renewed Proto-Drake: Finned Jaw
    69605, -- Renewed Proto-Drake: Finned Tail
    69609, -- Renewed Proto-Drake: Finned Throat
    69547, -- Renewed Proto-Drake: Gold and Black Armor
    69552, -- Renewed Proto-Drake: Gold and Red Armor
    69550, -- Renewed Proto-Drake: Gold and White Armor
    69582, -- Renewed Proto-Drake: Gradiant Horns
    69568, -- Renewed Proto-Drake: Gray Hair
    69572, -- Renewed Proto-Drake: Green Hair
    66720, -- Renewed Proto-Drake: Green Scales
    69557, -- Renewed Proto-Drake: Hairy Back
    69560, -- Renewed Proto-Drake: Hairy Brow
    69596, -- Renewed Proto-Drake: Harrier Pattern
    69584, -- Renewed Proto-Drake: Heavy Horns
    69598, -- Renewed Proto-Drake: Heavy Scales
    69574, -- Renewed Proto-Drake: Helm
    69555, -- Renewed Proto-Drake: Horned Back
    69586, -- Renewed Proto-Drake: Horned Jaw
    69580, -- Renewed Proto-Drake: Impaler Horns
    69564, -- Renewed Proto-Drake: Maned Crest
    69606, -- Renewed Proto-Drake: Maned Tail
    69595, -- Renewed Proto-Drake: Predator Pattern
    69573, -- Renewed Proto-Drake: Purple Hair
    69600, -- Renewed Proto-Drake: Razor Snout
    69571, -- Renewed Proto-Drake: Red Hair
    69601, -- Renewed Proto-Drake: Shark Snout
    69565, -- Renewed Proto-Drake: Short Spiked Crest
    69548, -- Renewed Proto-Drake: Silver and Blue Armor
    69551, -- Renewed Proto-Drake: Silver and Purple Armor
    69597, -- Renewed Proto-Drake: Skyterror Pattern
    69599, -- Renewed Proto-Drake: Snub Snout
    69603, -- Renewed Proto-Drake: Spiked Club Tail
    69562, -- Renewed Proto-Drake: Spiked Crest
    69587, -- Renewed Proto-Drake: Spiked Jaw
    69608, -- Renewed Proto-Drake: Spiked Throat
    69561, -- Renewed Proto-Drake: Spined Brow
    69563, -- Renewed Proto-Drake: Spined Crest
    69607, -- Renewed Proto-Drake: Spined Tail
    69553, -- Renewed Proto-Drake: Steel and Yellow Armor
    69579, -- Renewed Proto-Drake: Subtle Horns
    69575, -- Renewed Proto-Drake: Swept Horns
    69585, -- Renewed Proto-Drake: Thick Spined Jaw
    69588, -- Renewed Proto-Drake: Thin Spined Jaw
    69583, -- Renewed Proto-Drake: White Horns
    69594, -- Renewed Proto-Drake: White Scales
    69792, -- Windborne Velocidrake: Armor
    69824, -- Windborne Velocidrake: Beaked Snout
    69801, -- Windborne Velocidrake: Black Fur
    69815, -- Windborne Velocidrake: Black Scales
    69816, -- Windborne Velocidrake: Blue Scales
    69817, -- Windborne Velocidrake: Bronze Scales
    69828, -- Windborne Velocidrake: Club Tail
    69806, -- Windborne Velocidrake: Cluster Horns
    69809, -- Windborne Velocidrake: Curled Horns
    69807, -- Windborne Velocidrake: Curved Horns
    69787, -- Windborne Velocidrake: Exposed Finned Back
    69831, -- Windborne Velocidrake: Exposed Finned Neck
    69825, -- Windborne Velocidrake: Exposed Finned Tail
    69791, -- Windborne Velocidrake: Feathered Back
    69836, -- Windborne Velocidrake: Feathered Neck
    69797, -- Windborne Velocidrake: Feathery Head
    69829, -- Windborne Velocidrake: Feathery Tail
    69788, -- Windborne Velocidrake: Finned Back
    69799, -- Windborne Velocidrake: Finned Ears
    69832, -- Windborne Velocidrake: Finned Neck
    69826, -- Windborne Velocidrake: Finned Tail
    69781, -- Windborne Velocidrake: Gold and Brown Armor
    69784, -- Windborne Velocidrake: Gold and Red Armor
    69802, -- Windborne Velocidrake: Gray Fur
    69812, -- Windborne Velocidrake: Gray Horns
    69795, -- Windborne Velocidrake: Hairy Head
    69821, -- Windborne Velocidrake: Heavy Scales
    69804, -- Windborne Velocidrake: Helm
    69823, -- Windborne Velocidrake: Hooked Snout
    69800, -- Windborne Velocidrake: Horned Jaw
    69793, -- Windborne Velocidrake: Large Head Fin
    69822, -- Windborne Velocidrake: Long Snout
    69789, -- Windborne Velocidrake: Maned Back
    69808, -- Windborne Velocidrake: Ox Horns
    69834, -- Windborne Velocidrake: Plated Neck
    69846, -- Windborne Velocidrake: Reaver Pattern
    69803, -- Windborne Velocidrake: Red Fur
    69818, -- Windborne Velocidrake: Red Scales
    69847, -- Windborne Velocidrake: Shrieker Pattern
    69782, -- Windborne Velocidrake: Silver and Blue Armor
    69785, -- Windborne Velocidrake: Silver and Purple Armor
    69798, -- Windborne Velocidrake: Small Ears
    69794, -- Windborne Velocidrake: Small Head Fin
    69790, -- Windborne Velocidrake: Spiked Back
    69835, -- Windborne Velocidrake: Spiked Neck
    69827, -- Windborne Velocidrake: Spiked Tail
    69796, -- Windborne Velocidrake: Spined Head
    69811, -- Windborne Velocidrake: Split Horns
    69783, -- Windborne Velocidrake: Steel and Orange Armor
    69810, -- Windborne Velocidrake: Swept Horns
    69819, -- Windborne Velocidrake: Teal Scales
    69805, -- Windborne Velocidrake: Wavy Horns
    69813, -- Windborne Velocidrake: White Horns
    69820, -- Windborne Velocidrake: White Scales
    69786, -- Windborne Velocidrake: White and Pink Armor
    69845, -- Windborne Velocidrake: Windswept Pattern
    69814, -- Windborne Velocidrake: Yellow Horns
}

ns.progressQuests = {
    -- Weekly Holidays
    ["weeklyHoliday"] = {"weekly", {
        -- 62632, -- "A Burning Path Through Time", TBC Timewalking
        -- 62633, -- "A Frozen Path Through Time", Wrath Timewalking
        -- 62634, -- "A Shattered Path Through Time", Cata Timewalking
        -- 62639, -- "The Very Best", PvP Pet Battles

        -- Dragonflight
        72719, -- "A Fel Path Through Time", Legion Timewalking
        72720, -- "The Arena Calls", Arena Skirmishes
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
    ["dfProfessionAlchemyDrop1"] = {"weekly", { 66373 }},
    ["dfProfessionAlchemyDrop2"] = {"weekly", { 66374 }},
    ["dfProfessionAlchemyDrop3"] = {"weekly", { 70504 }},
    ["dfProfessionAlchemyDrop4"] = {"weekly", { 70511 }},
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
    ["dfProfessionBlacksmithingDrop1"] = {"weekly", { 66381 }},
    ["dfProfessionBlacksmithingDrop2"] = {"weekly", { 66382 }},
    ["dfProfessionBlacksmithingDrop3"] = {"weekly", { 70512 }},
    ["dfProfessionBlacksmithingDrop4"] = {"weekly", { 70513 }},
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
    ["dfProfessionEnchantingDrop1"] = {"weekly", { 66377 }},
    ["dfProfessionEnchantingDrop2"] = {"weekly", { 66378 }},
    ["dfProfessionEnchantingDrop3"] = {"weekly", { 70514 }},
    ["dfProfessionEnchantingDrop4"] = {"weekly", { 70515 }},
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
    ["dfProfessionEngineeringDrop1"] = {"weekly", { 66379 }},
    ["dfProfessionEngineeringDrop2"] = {"weekly", { 66380 }},
    ["dfProfessionEngineeringDrop3"] = {"weekly", { 70516 }},
    ["dfProfessionEngineeringDrop4"] = {"weekly", { 70517 }},
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
    ["dfProfessionInscriptionDrop1"] = {"weekly", { 66375 }},
    ["dfProfessionInscriptionDrop2"] = {"weekly", { 66376 }},
    ["dfProfessionInscriptionDrop3"] = {"weekly", { 70518 }},
    ["dfProfessionInscriptionDrop4"] = {"weekly", { 70519 }},
    ["dfProfessionInscriptionGather"] = {"weekly", {
        66943, -- 
        66944, -- Peacock Pigments
        66945, -- 
        72438, -- Tarasek Intentions
    }},
    ["dfProfessionInscriptionOrders"] = {"weekly", { 70592 }},
    ["dfProfessionInscriptionTreatise"] = {"weekly", { 74105 }},

    ["dfProfessionJewelcraftingCraft"] = {"weekly", {
        70562, -- 
        70563, -- 
        70564, -- 
        70565, -- 
    }},
    ["dfProfessionJewelcraftingDrop1"] = {"weekly", { 66388 }},
    ["dfProfessionJewelcraftingDrop2"] = {"weekly", { 66389 }},
    ["dfProfessionJewelcraftingDrop3"] = {"weekly", { 70520 }},
    ["dfProfessionJewelcraftingDrop4"] = {"weekly", { 70521 }},
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
    ["dfProfessionLeatherworkingDrop1"] = {"weekly", { 66384 }},
    ["dfProfessionLeatherworkingDrop2"] = {"weekly", { 66385 }},
    ["dfProfessionLeatherworkingDrop3"] = {"weekly", { 70522 }},
    ["dfProfessionLeatherworkingDrop4"] = {"weekly", { 70523 }},
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
    ["dfProfessionTailoringDrop1"] = {"weekly", { 66386 }},
    ["dfProfessionTailoringDrop2"] = {"weekly", { 66387 }},
    ["dfProfessionTailoringDrop3"] = {"weekly", { 70524 }},
    ["dfProfessionTailoringDrop4"] = {"weekly", { 70525 }},
    ["dfProfessionTailoringGather"] = {"weekly", {
        66952, -- 
        66899, -- 
        66953, -- 
        72410, -- Pincers and Needles
    }},
    ["dfProfessionTailoringOrders"] = {"weekly", { 70595 }},
    ["dfProfessionTailoringTreatise"] = {"weekly", { 74115 }},

    ["dfProfessionHerbalismDrop1"] = {"weekly", { 71857 }},
    ["dfProfessionHerbalismDrop2"] = {"weekly", { 71858 }},
    ["dfProfessionHerbalismDrop3"] = {"weekly", { 71859 }},
    ["dfProfessionHerbalismDrop4"] = {"weekly", { 71860 }},
    ["dfProfessionHerbalismDrop5"] = {"weekly", { 71861 }},
    ["dfProfessionHerbalismDrop6"] = {"weekly", { 71864 }},
    ["dfProfessionHerbalismGather"] = {"weekly", {
        70613, -- Get Their Bark Before They Bite
        70614, -- Bubble Craze
        70615, -- The Case of the Missing Herbs
        70616, -- How Many??
    }},
    ["dfProfessionHerbalismTreatise"] = {"weekly", { 74107 }},

    ["dfProfessionMiningDrop1"] = {"weekly", { 72160 }},
    ["dfProfessionMiningDrop2"] = {"weekly", { 72161 }},
    ["dfProfessionMiningDrop3"] = {"weekly", { 72162 }},
    ["dfProfessionMiningDrop4"] = {"weekly", { 72163 }},
    ["dfProfessionMiningDrop5"] = {"weekly", { 72164 }},
    ["dfProfessionMiningDrop6"] = {"weekly", { 72165 }},
    ["dfProfessionMiningGather"] = {"weekly", {
        70617, -- All Mine, Mine, Mine
        70618, -- The Call of the Forge
        72156, -- A Fiery Fight
        72157, -- The Weight of Earth
    }},
    ["dfProfessionMiningTreatise"] = {"weekly", { 74106 }},

    ["dfProfessionSkinningDrop1"] = {"weekly", { 70381 }},
    ["dfProfessionSkinningDrop2"] = {"weekly", { 70383 }},
    ["dfProfessionSkinningDrop3"] = {"weekly", { 70384 }},
    ["dfProfessionSkinningDrop4"] = {"weekly", { 70385 }},
    ["dfProfessionSkinningDrop5"] = {"weekly", { 70386 }},
    ["dfProfessionSkinningDrop6"] = {"weekly", { 70389 }},
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
    ["dfStormsFury"] = {"weekly", {73162}},
    ["dfTrialElements"] = {"weekly", {71995}},
    ["dfTrialFlood"] = {"weekly", {71033}},
}
