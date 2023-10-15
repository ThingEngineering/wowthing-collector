local Module = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector'):GetModule('Quests')


Module.db.account = {
    -- Shadowlands: Torghast
    61144, -- Possibility Matrix
    63183, -- Extradimensional Pockets
    63193, -- Bangle of Seniority
    63200, -- Rank Insignia: Acquisitionist
    63201, -- Loupe of Unusual Charm
    63202, -- Vessel of Unfortunate Spirits
    63204, -- Ritual Prism of Fortune
    63523, -- Broker Traversal Enhancer

    -- Dragonflight: Unlocks
    67030, -- Adventure Mode unlock?
    75658, -- Zaralek Cavern world quests

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
    72371, -- Highland Drake: Embodiment of the Crimson Gladiator
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
    72367, -- Renewed Proto-Drake: Embodiment of the Storm-Eater
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
    73829, -- Winding Slitherdrake: Antler Horns
    73810, -- Winding Slitherdrake: Blonde Hair
    73788, -- Winding Slitherdrake: Blue and Silver Armor
    73841, -- Winding Slitherdrake: Blue Scales
    73842, -- Winding Slitherdrake: Bronze Scales
    73811, -- Winding Slitherdrake: Brown Hair
    73800, -- Winding Slitherdrake: Cluster Chin Horn
    73820, -- Winding Slitherdrake: Cluster Horns
    73831, -- Winding Slitherdrake: Cluster Jaw Horns
    73809, -- Winding Slitherdrake: Curled Cheek Horn
    73824, -- Winding Slitherdrake: Curled Horns
    73837, -- Winding Slitherdrake: Curled Nose
    73802, -- Winding Slitherdrake: Curved Chin Horn
    73825, -- Winding Slitherdrake: Curved Horns
    73840, -- Winding Slitherdrake: Curved Nose Horn
    73808, -- Winding Slitherdrake: Ears
    75941, -- Winding Slitherdrake: Embodiment of the Obsidian Gladiator
    73807, -- Winding Slitherdrake: Finned Cheek
    73853, -- Winding Slitherdrake: Finned Tip Tail
    73798, -- Winding Slitherdrake: Grand Chin Thorn
    73787, -- Winding Slitherdrake: Green and Bronze Armor
    73843, -- Winding Slitherdrake: Green Scales
    73796, -- Winding Slitherdrake: Hairy Brow
    73799, -- Winding Slitherdrake: Hairy Chin
    73806, -- Winding Slitherdrake: Hairy Crest
    73834, -- Winding Slitherdrake: Hairy Jaw
    73854, -- Winding Slitherdrake: Hairy Tail
    73857, -- Winding Slitherdrake: Hairy Throat
    73817, -- Winding Slitherdrake: Heavy Horns
    75743, -- Winding Slitherdrake: Heavy Scales
    73794, -- Winding Slitherdrake: Horned Brow
    73830, -- Winding Slitherdrake: Impaler Horns
    73804, -- Winding Slitherdrake: Large Finned Crest
    73852, -- Winding Slitherdrake: Large Finned Tail
    73855, -- Winding Slitherdrake: Large Finned Throat
    73838, -- Winding Slitherdrake: Large Spiked Nose
    73797, -- Winding Slitherdrake: Long Chin Horn
    73832, -- Winding Slitherdrake: Long Jaw Horns
    73826, -- Winding Slitherdrake: Paired Horns
    73795, -- Winding Slitherdrake: Plated Brow
    73839, -- Winding Slitherdrake: Pointed Nose
    73791, -- Winding Slitherdrake: Red and Gold Armor
    73813, -- Winding Slitherdrake: Red Hair
    73844, -- Winding Slitherdrake: Red Scales
    73851, -- Winding Slitherdrake: Shark Finned Tail
    73822, -- Winding Slitherdrake: Short Horns
    73835, -- Winding Slitherdrake: Single Jaw Horn
    73805, -- Winding Slitherdrake: Small Finned Crest
    73850, -- Winding Slitherdrake: Small Finned Tail
    73856, -- Winding Slitherdrake: Small Finned Throat
    73803, -- Winding Slitherdrake: Small Spiked Crest
    73801, -- Winding Slitherdrake: Spiked Chin
    73821, -- Winding Slitherdrake: Spiked Horns
    73849, -- Winding Slitherdrake: Spiked Tail
    73836, -- Winding Slitherdrake: Split Jaw Horns
    73818, -- Winding Slitherdrake: Swept Horns
    73815, -- Winding Slitherdrake: Tan Horns
    73827, -- Winding Slitherdrake: Thorn Horns
    73833, -- Winding Slitherdrake: Triple Jaw Horns
    73812, -- Winding Slitherdrake: White Hair
    73816, -- Winding Slitherdrake: White Horns
    73845, -- Winding Slitherdrake: White Scales
    73792, -- Winding Slitherdrake: Yellow and Silver Armor
    73846, -- Winding Slitherdrake: Yellow Scales
}
