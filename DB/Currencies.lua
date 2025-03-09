local Module = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector'):GetModule('Currencies')


Module.db.currencies = {
    -- Player vs Player
    391, -- Tol Barad Commendation
    1602, -- Conquest Points
    1792, -- Honor Points
    2123, -- Bloody Tokens

    -- Dungeon and Raid
    614, -- Mote of Darkness
    615, -- Essence of Corrupted Deathwing
    1166, -- Timewarped Badge

    -- Miscellaneous
    61, -- Dalaran Jewelcrafter's Token
    81, -- Epicurean's Award
    241, -- Champion's Seal
    402, -- Ironpaw Token
    416, -- Mark of the World Tree
    515, -- Darkmoon Prize Ticket
    1379, -- Trial of Style Token
    3100, -- Bronze Celebration Token
    3102, -- Bronze Celebration Token [Hidden]
    3144, -- 11.0.5 20th Anniversary - Tracker
    3145, -- 11.0.5 20th Anniversary - Tracker
    3146, -- 11.0.5 20th Anniversary - Tracker

    -- Cataclysm
    361, -- Illustrious Jewelcrafter's Token

    -- Mists of Pandaria
    697, -- Elder Charm of Good Fortune
    738, -- Lesser Charm of Good Fortune
    752, -- Mogu Rune of Fate
    776, -- Warforged Seal
    777, -- Timeless Coin
    789, -- Bloody Coin

    -- Warlords of Draenor
    823, -- Apexis Crystal
    824, -- Garrison Resources
    944, -- Artifact Fragment
    980, -- Dingy Iron Coins
    994, -- Seal of Tempered Fate
    1101, -- Oil
    1129, -- Seal of Inevitable Fate

    -- Legion
    1149, -- Sightless Eye
    1154, -- Shadowy Coins
    1155, -- Ancient Mana
    1220, -- Order Resources
    1226, -- Nethershard
    1268, -- Timeworn Artifact
    1273, -- Seal of Broken Fate
    1275, -- Curious Coin
    1299, -- Brawler's Gold
    1314, -- Lingering Soul Fragment
    1342, -- Legionfall War Supplies
    1356, -- Echoes of Battle
    1357, -- Echoes of Domination
    1416, -- Coins of Air
    1501, -- Writhing Essence
    1508, -- Veiled Argunite
    1533, -- Wakening Essence

    -- Battle for Azeroth
    1560, -- War Resources
    1565, -- Rich Azerite Fragment
    1580, -- Seal of Wartorn Fate
    1587, -- War Supplies
    1710, -- Seafarer's Dubloon
    1716, -- Honorbound Service Medal
    1717, -- 7th Legion Service Medal
    1718, -- Titan Residuum
    1719, -- Corrupted Memento
    1721, -- Prismatic Manapearl
    1755, -- Coalescing Visions
    1803, -- Echoes of Ny'alotha

    -- Shadowlands
    1191, -- Valor
    1754, -- Argent Commendation
    1767, -- Stygia
    1810, -- Redeemed Soul
    1813, -- Reservoir Anima
    1816, -- Sinstone Fragments
    1819, -- Medallion of Service
    1820, -- Infused Ruby
    1822, -- Renown
    1828, -- Soul Ash
    1885, -- Grateful Offering
    1889, -- Adventure Campaign Progress
    1904, -- Tower Knowledge
    1906, -- Soul Cinders
    1931, -- Cataloged Research
    1977, -- Stygian Ember
    1979, -- Cyphers of the First Ones
    2000, -- Motes of Fate?
    2009, -- Cosmic Flux
    2010, -- Valor 2?
    
    -- Dragonflight
    2003, -- Dragon Isles Supplies
    2011, -- Effigy Adornments
    2023, -- Blacksmithing Knowledge
    2024, -- Alchemy Knowledge
    2025, -- Leatherworking Knowledge
    2026, -- Tailoring Knowledge
    2027, -- Engineering Knowledge
    2028, -- Inscription Knowledge
    2029, -- Jewelcrafting Knowledge
    2030, -- Enchanting Knowledge
    2033, -- Skinning Knowledge
    2034, -- Herbalism Knowledge
    2035, -- Mining Knowledge
    2045, -- Dragon Glyph Embers
    2118, -- Elemental Overflow
    2122, -- Storm Sigil
    2133, -- Dragonriding - Accepting Passengers
    -- 2134, -- Cobalt Assembly
    2167, -- Catalyst Charges
    2245, -- Flightstones
    2533, -- Renascent Shadowflame
    2588, -- Riders of Azeroth Badge
    2594, -- Paracausal Flakes
    2650, -- Emerald Dewdrop
    2651, -- Seedbloom
    2657, -- Mysterious Fragment
    2706, -- Whelpling's Dreaming Crests (capped?)
    2707, -- Drake's Dreaming Crests (capped?)
    2708, -- Wyrm's Dreaming Crests (capped?)
    2709, -- Aspect's Dreaming Crests (capped?)
    2715, -- Whelpling's Dreaming Crests (?)
    2716, -- Drake's Dreaming Crests (?)
    2717, -- Wyrm's Dreaming Crests (?)
    2718, -- Aspect's Dreaming Crests (?)
    2777, -- Dream Infusion
    2778, -- Bronze
    2796, -- Renascent Dream
    2797, -- Trophy of Strife
    2806, -- Whelpling's Awakened Crest
    2807, -- Drake's Awakened Crest
    2809, -- Wyrm's Awakened Crest
    2812, -- Aspect's Awakened Crest
    2912, -- Renascent Awakening

    2264, -- Account HWM - Helm [DNT]
    2265, -- Account HWM - Neck [DNT]
    2266, -- Account HWM - Shoulders [DNT]
    2267, -- Account HWM - Chest [DNT]
    2268, -- Account HWM - Waist [DNT]
    2269, -- Account HWM - Legs [DNT]
    2270, -- Account HWM - Feet [DNT]
    2271, -- Account HWM - Wrist [DNT]
    2272, -- Account HWM - Hands [DNT]
    2273, -- Account HWM - Ring [DNT]
    2274, -- Account HWM - Trinket [DNT]
    2275, -- Account HWM - Cloak [DNT]
    2276, -- Account HWM - Two Hand [DNT]
    2277, -- Account HWM - Main Hand [DNT]
    2278, -- Account HWM - One Hand [DNT]
    2279, -- Account HWM - One Hand (Second) [DNT]
    2280, -- Account HWM - Off Hand [DNT]
    2409, -- Whelpling Crest Fragment Tracker [DNT]
    2410, -- Drake Crest Fragment Tracker [DNT]
    2411, -- Wyrm Crest Fragment Tracker [DNT]
    2412, -- Aspect Crest Fragment Tracker [DNT]
    2413, -- 10.1 Professions - Personal Tracker - S2 Spark Drops (Hidden)
    2774, -- 10.2 Professions - Personal Tracker - S3 Spark Drops (Hidden)
    2780, -- Echoed Ephemera Tracker [DNT]
    2784, -- 10.2 Legendary - Progressive Advance - Tracker
    2800, -- 10.2.6 Professions - Personal Tracker - S4 Spark Drops (Hidden)
    2805, -- Whelpling's Awakened Crest (Hidden)
    2808, -- Drake's Awakened Crest (Hidden)
    2810, -- Wyrm's Awakened Crest (Hidden)
    2811, -- Aspect's Awakened Crest (Hidden)
    2853, -- 10.2.7 Timewalking Season - Artifact - Cloak - Primary
    2854, -- 10.2.7 Timewalking Season - Artifact - Cloak - Stamina
    2855, -- 10.2.7 Timewalking Season - Artifact - Cloak - Critical Strike
    2856, -- 10.2.7 Timewalking Season - Artifact - Cloak - Haste
    2857, -- 10.2.7 Timewalking Season - Artifact - Cloak - Leech
    2858, -- 10.2.7 Timewalking Season - Artifact - Cloak - Mastery
    2859, -- 10.2.7 Timewalking Season - Artifact - Cloak - Speed
    2860, -- 10.2.7 Timewalking Season - Artifact - Cloak - Versatility
    2861, -- 10.2.7 Timewalking Season - Artifact - Head - Aberration
    2862, -- 10.2.7 Timewalking Season - Artifact - Head - Beast
    2863, -- 10.2.7 Timewalking Season - Artifact - Head - Demon
    2864, -- 10.2.7 Timewalking Season - Artifact - Head - Dragonkin
    2865, -- 10.2.7 Timewalking Season - Artifact - Head - Elemental
    2866, -- 10.2.7 Timewalking Season - Artifact - Head - Giant
    2867, -- 10.2.7 Timewalking Season - Artifact - Head - Humanoid
    2868, -- 10.2.7 Timewalking Season - Artifact - Head - Mechanical
    2869, -- 10.2.7 Timewalking Season - Artifact - Head - Undead
    2870, -- 10.2.7 Timewalking Season - Artifact - Waist - Physical
    2871, -- 10.2.7 Timewalking Season - Artifact - Waist - Arcane
    2872, -- 10.2.7 Timewalking Season - Artifact - Waist - Fire
    2873, -- 10.2.7 Timewalking Season - Artifact - Waist - Frost
    2874, -- 10.2.7 Timewalking Season - Artifact - Waist - Holy
    2875, -- 10.2.7 Timewalking Season - Artifact - Waist - Shadow
    2876, -- 10.2.7 Timewalking Season - Artifact - Waist - Nature
    2878, -- 10.2 Professions - Personal Tracker - Legendary - Restored Leaf
    3000, -- 10.2.7 Timewalking Season - Random Gem Counter
    3001, -- 10.2.7 Timewalking Season - Artifact - Cloak - Experience Gain
    3010, -- 10.2.6 Rewards - Personal Tracker - S4 Dinar Drops (Hidden)

    -- The Waking Shores
    2042, 2044, 2154, 2421, 2422, -- Ruby Lifeshrine Loop
    2048, 2049, 2176, 2423, 2424, -- Wild Preserve Slalom
    2052, 2053, 2177, 2425, 2426, -- Emberflow Flight
    2054, 2055, 2178, 2427, 2428, -- Apex Canopy River Run
    2056, 2057, 2179, 2429, 2430, -- Uktulut Coaster
    2058, 2059, 2180, 2431, 2432, -- Wingrest Roundabout
    2046, 2047, 2181, 2433, 2434, -- Flashfrost Flyover
    2050, 2051, 2182, 2435, 2436, -- Wild Preserve Circuit

    -- Ohn'ahran Plains
    2060, 2061, 2183, 2437, 2439, -- Sundapple Copse Circuit
    2062, 2063, 2184, 2440, 2441, -- Fen Flythrough
    2064, 2065, 2185, 2442, 2443, -- Ravine River Run
    2066, 2067, 2186, 2444, 2445, -- Emerald Garden Ascent
    2069,             2446,       -- Maruukai Dash
    2070,             2447,       -- Mirror of the Sky Dash
    2119, 2120, 2187, 2448, 2449, -- River Rapids Route

    -- Azure Span
    2074, 2075, 2188, 2450, 2451, -- The Azure Span Sprint
    2076, 2077, 2189, 2452, 2453, -- The Azure Span Slalom
    2078, 2079, 2190, 2454, 2455, -- The Vakthros Ascent
    2083, 2084, 2191, 2456, 2457, -- Iskaara Tour
    2085, 2086, 2192, 2458, 2459, -- Frostland Flyover
    2089, 2090, 2193, 2460, 2461, -- Archive Ambit

    -- Thaldraszus
    2080, 2081, 2194, 2462, 2463, -- The Flowing Forest Flight
    2092, 2093, 2195, 2464, 2465, -- Tyrhold Trial
    2096, 2097, 2196, 2466, 2467, -- Cliffside Circuit
    2098, 2099, 2197, 2468, 2469, -- Academy Ascent
    2101, 2102, 2198, 2470, 2471, -- Garden Gallivant
    2103, 2104, 2199, 2472, 2473, -- Caverns Criss-Cross

    -- Forbidden Reach
    2201, 2207, 2213, 2474, 2475, -- Stormsunder Crate Circuit
    2202, 2208, 2214, 2476, 2477, -- Morqut Ascent
    2203, 2209, 2215, 2478, 2479, -- Aerie Chasm Cruise
    2204, 2210, 2216, 2480, 2481, -- Southern Reach Route
    2205, 2211, 2217, 2482, 2483, -- Caldera Coaster
    2206, 2212, 2218, 2484, 2485, -- Forbidden Reach Rush

    -- Zaralek Cavern
    2246, 2252, 2258, 2486, 2487, -- Crystal Circuit
    2247, 2253, 2259, 2488, 2489, -- Caldera Cruise
    2248, 2254, 2260, 2490, 2491, -- Brimstone Scramble
    2249, 2255, 2261, 2492, 2493, -- Shimmering Slalom
    2250, 2256, 2262, 2494, 2495, -- Loamm Roamm
    2251, 2257, 2263, 2496, 2497, -- Sulfur Sprint

    -- Emerald Dream
    2676, 2682, 2688, 2694, 2695, -- Ysera Invitational
    2677, 2683, 2689, 2696, 2697, -- Smoldering Sprint
    2678, 2684, 2690, 2698, 2699, -- Viridescent Venture
    2679, 2685, 2691, 2700, 2701, -- Shoreline Switchback
    2680, 2686, 2692, 2702, 2703, -- Canopy Concours
    2681, 2687, 2693, 2704, 2705, -- Emerald Amble

    -- Isle of Dorn
    2923, 2929, 2935, -- Dornogal Drift
    2924, 2930, 2936, -- Storm's Watch Survey
    2925, 2931, 2937, -- Basin Bypass
    2926, 2932, 2938, -- The Wold Ways
    2927, 2933, 2939, -- Thunderhead Trail
    2928, 2934, 2940, -- Orecreg's Doglegs

    -- The Ringing Deeps
    2941, 2947, 2953, -- Earthenworks Weave
    2942, 2948, 2954, -- Ringing Deeps Ramble
    2943, 2949, 2955, -- Chittering Concourse
    2944, 2950, 2956, -- Cataract River Cruise
    2945, 2951, 2957, -- Taelloch Twist
    2946, 2952, 2958, -- Opportunity Point Amble

    -- Hallowfall
    2959, 2965, 2971, -- Dunelle's Detour
    2960, 2966, 2972, -- Tenir's Traversal
    2961, 2967, 2973, -- Light's Redoubt Descent
    2962, 2968, 2974, -- Stillstone Slalom
    2963, 2969, 2975, -- Mereldar Meander
    2964, 2970, 2976, -- Velhan's Venture

    -- Azj-Kahet
    2977, 2983, 2989, -- City of Threads Twist
    2978, 2984, 2990, -- Maddening Deep Dip
    2979, 2985, 2991, -- The Weaver's Wing
    2980, 2986, 2992, -- Rak-Ahat Rush
    2981, 2987, 2993, -- Pit Plunge
    2982, 2988, 2994, -- Siegehold Scuttle

    -- The War Within
    2803, -- Undercoin
    2815, -- Resonance Crystals
    2914, -- Weathered Harbinger Crest
    2915, -- Carved Harbinger Crest
    2916, -- Runed Harbinger Crest
    2917, -- Gilded Harbinger Crest
    3008, -- Valorstones
    3028, -- Restored Coffer Key
    3055, -- Mereldar Derby Mark
    3056, -- Kej
    3068, -- Delver's Journey [S1]
    3089, -- Residual Memories
    3090, -- Flame-Blessed Iron
    3093, -- Nerub-ar Finery
    3107, -- Weathered Undermine Crest
    3108, -- Carved Undermine Crest
    3109, -- Runed Undermine Crest
    3110, -- Gilded Undermine Crest
    3116, -- Essence of Kaja'mite
    3131, -- Delver's Journey [S2]
    3136, -- Gallagio Loyalty Rewards Club
    3216, -- Bounty's Remnants
    3218, -- Empty Kaja'Cola Can
    3220, -- Vintage Kaja'Cola Can
    3226, -- Market Research
    3253, -- 11.1 Delves - Bountiful Tracker - Progress Cap - Mislaid
    3279, -- 11.1 Raid Renown - Gallagio - Raid Buff Acct Tracker
    3280, -- 11.1 Raid Renown - Gallagio - Speed Buff Acct Tracker

    2785, -- Alchemy Knowledge
    2786, -- Blacksmithing Knowledge
    2787, -- Enchanting Knowledge
    2788, -- Engineering Knowledge
    2789, -- Herbalism Knowledge
    2790, -- Inscription Knowledge
    2791, -- Jewelcrafting Knowledge
    2792, -- Leatherworking Knowledge
    2793, -- Mining Knowledge
    2794, -- Skinning Knowledge
    2795, -- Tailoring Knowledge
    2813, -- Harmonized Silk
    3013, -- Jewelcrafting Concentration
    3023, -- 11.0 Professions - Personal Tracker - S1 Spark Drops (Hidden)
    3040, -- Blacksmithing Concentration
    3041, -- Tailoring Concentration
    3042, -- Leatherworking Concentration
    3043, -- Inscription Concentration
    3044, -- Engineering Concentration
    3045, -- Alchemy Concentration
    3046, -- Enchanting Concentration
    3047, -- Jewelcrafting Concentration
    3048, -- Tailoring Concentration
    3049, -- Leatherworking Concentration
    3050, -- Blacksmithing Concentration
    3051, -- Enchanting Concentration
    3052, -- Engineering Concentration
    3053, -- Inscription Concentration
    3054, -- Alchemy Concentration
    3057, -- 11.0 Professions - Tracker - Weekly Alchemy Knowledge
    3058, -- ^ Blacksmithing
    3059, -- ^ Enchanting
    3060, -- ^ Engineering
    3061, -- ^ Herbalism
    3062, -- ^ Inscription
    3063, -- ^ Jewelcrafting
    3064, -- ^ Leatherworking
    3065, -- ^ Mining
    3066, -- ^ Skinning
    3067, -- ^ Tailoring
    3073, -- 11.0 Professions - Tracker - Insc Book - Tailoring Knowledge
    3074, -- ^ Skinning
    3075, -- ^ Mining
    3076, -- ^ Leatherworking
    3077, -- ^ Jewelcrafting
    3078, -- ^ Inscription
    3079, -- ^ Herbalism
    3080, -- ^ Engineering
    3081, -- ^ Enchanting
    3082, -- ^ Blacksmithing
    3083, -- ^ Alchemy	
    3084, -- ^ Inscription 2?
    3132, -- 11.1 Professions - Personal Tracker - S2 Spark Drops (Hidden)
}
