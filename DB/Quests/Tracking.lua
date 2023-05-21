local Module = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector'):GetModule('Quests')


Module.db.tracking = {
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

    -- Dragonflight: Artisan's Consortium books
    71893, -- Alchemy 1
    71904, -- Alchemy 2
    71915, -- Alchemy 3
    71894, -- Blacksmithing 1
    71905, -- Blacksmithing 2
    71916, -- Blacksmithing 3
    71895, -- Enchanting 1
    71906, -- Enchanting 2
    71917, -- Enchanting 3
    71896, -- Engineering 1
    71907, -- Engineering 2
    71918, -- Engineering 3
    71897, -- Herbalism 1
    71908, -- Herbalism 2
    71919, -- Herbalism 3
    71898, -- Inscription 1
    71909, -- Inscription 2
    71920, -- Inscription 3
    71899, -- Jewelcrafting 1
    71910, -- Jewelcrafting 2
    71921, -- Jewelcrafting 3
    71900, -- Leatherworking 1
    71911, -- Leatherworking 2
    71922, -- Leatherworking 3
    71901, -- Mining 1
    71912, -- Mining 2
    71923, -- Mining 3
    71902, -- Skinning 1
    71913, -- Skinning 2
    71924, -- Skinning 3
    71903, -- Tailoring 1
    71914, -- Tailoring 2
    71925, -- Tailoring 3

    -- Dragonflight: Loamm Niffen books
    75756, -- Alchemy
    75755, -- Blacksmithing
    75752, -- Enchanting
    75759, -- Engineering
    75753, -- Herbalism
    75761, -- Inscription
    75754, -- Jewelcrafting
    75751, -- Leatherworking
    75758, -- Mining
    75760, -- Skinning
    75757, -- Tailoring

    -- Dragonflight: Zaralek Cavern bartering books
    75848, -- Alchemy Journal
    75847, -- Alchemy Notes
    75849, -- Blacksmithing Journal
    75846, -- Blacksmthing Notes
    75850, -- Enchanting Journal
    75845, -- Enchanting Notes
    75851, -- Engineering Journal
    75844, -- Engineering Notes
    75852, -- Herbalism Journal
    75843, -- Herbalism Notes
    75853, -- Inscription Journal
    75842, -- Inscription Notes
    75854, -- Jewelcrafting Journal
    75841, -- Jewelcrafting Notes
    75855, -- Leatherworking Journal
    75840, -- Leatherworking Notes
    75856, -- Mining Journal
    75839, -- Mining Notes
    75857, -- Skinning Journal
    75838, -- Skinning Notes
    75858, -- Tailoring Journal
    75837, -- Tailoring Notes
}
