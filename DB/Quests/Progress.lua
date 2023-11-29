local Module = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector'):GetModule('Quests')


Module.db.progress = {
    -- Weekly Holidays
    ["holidayArena"] = { "weekly", { 72720 } }, -- "The Arena Calls", Arena Skirmishes
    ["holidayBattlegrounds"] = { "weekly", { 72723 } }, -- "A Call to Battle", Battlegrounds
    ["holidayDungeons"] = { "weekly", { 72722 } }, -- "Emissary of War", Mythic Dungeons
    ["holidayPetPvp"] = { "weekly", { 72721 } }, -- "The Very Best", PvP Pet Battles
    ["holidayTimewalking"] = { "weekly", {
        72719, -- "A Fel Path Through Time", Legion Timewalking
        72724, -- "A Savage Path Through Time", WoD Timewalking
        72725, -- "A Shrouded Path Through Time", MoP Timewalking
        72726, -- "A Frozen Path Through Time", Wrath Timewalking
        72727, -- "A Burning Path Through Time", TBC Timewalking
        72810, -- "A Shattered Path Through Time", Cata Timewalking [Heroic]
    } },
    ["holidayTimewalkingItem"] = { "weekly", {
        40168, -- The Swirling Vial, TBC
        40173, -- The Unstable Prism, Wrath
        40786, -- The Smoldering Ember, Cata [Horde]
        40787, -- The Smoldering Ember, Cata [Alliance]
        45563, -- The Shrouded Coin, MoP
        55498, -- The Shimmering Crystal, WoD
        64710, -- Whispering Fel Crystal, Legion
    } },
    ["holidayWorldQuests"] = { "weekly", { 72728 } }, -- "The World Awaits", World Quests
    -- Weekly PvP
    ["pvpArenas"] = { "weekly", { 72169 } }, -- Proving in Arenas (Rated Arenas)
    ["pvpBattle"] = { "weekly", { 72166 } }, -- Proving in Battle (Random Battlegrounds)
    ["pvpBrawl"] = { "weekly", { 47148 } }, -- Something Different (Brawl)
    ["pvpOverwhelmingOdds"] = { "weekly", {
        71025, -- Against Overwhelming Odds [H]
        71026, -- Against Overwhelming Odds [A]
    } },
    ["pvpSkirmishes"] = { "weekly", { 72168 } }, -- Proving in Skirmishes (Arena Skirmishes)
    ["pvpSolo"] = { "weekly", { 72171 } }, -- Proving Solo (Solo Shuffle)
    ["pvpTeamwork"] = { "weekly", { 72170 } }, -- Proving Teamwork (Rated Battlegrounds)
    ["pvpWar"] = { "weekly", { 72167 } }, -- Proving in War (Epic Battlegrounds)
    -- Warlords of Draenor
    ["invasionBoss"] = { "weekly", { 38276 } },
    ["invasionBronze"] = { "weekly", { 37638 } },
    ["invasionSilver"] = { "weekly", { 37639 } },
    ["invasionGold"] = { "weekly", { 37640 } },
    ["invasionPlatinum"] = { "weekly", { 38482 } },
    -- Warlords of Draenor: Raids
    ["legBlackrock1Normal"] = { "once", { 37029 } },
    ["legBlackrock1Heroic"] = { "once", { 37030 } },
    ["legBlackrock1Mythic"] = { "once", { 37031 } },
    ["legHellfire1Normal"] = { "once", { 39499 } },
    ["legHellfire2Normal"] = { "once", { 39502 } },
    ["legHellfire1Heroic"] = { "once", { 39500 } },
    ["legHellfire2Heroic"] = { "once", { 39504 } },
    ["legHellfire1Mythic"] = { "once", { 39501 } },
    ["legHellfire2Mythic"] = { "once", { 39505 } },
    -- Legion: Misc
    ["legionWitheredTraining"] = { "wq", { 43943 } },
    -- Legion: Raids
    ["legEmerald1Normal"] = { "once", { 44283 } },
    ["legEmerald1Heroic"] = { "once", { 44284 } },
    ["legEmerald1Mythic"] = { "once", { 44285 } },
    ["legNighthold1Normal"] = { "once", { 45381 } },
    ["legNighthold1Heroic"] = { "once", { 45382 } },
    ["legNighthold1Mythic"] = { "once", { 45383 } },
    ["legTomb1Normal"] = { "once", { 47725 } },
    ["legTomb1Heroic"] = { "once", { 47726 } },
    ["legTomb1Mythic"] = { "once", { 47727 } },
    ["legAntorus1Normal"] = { "once", { 49032 } },
    ["legAntorus2Normal"] = { "once", { 49133 } },
    ["legAntorus1Heroic"] = { "once", { 49075 } },
    ["legAntorus2Heroic"] = { "once", { 49134 } },
    ["legAntorus1Mythic"] = { "once", { 49076 } },
    ["legAntorus2Mythic"] = { "once", { 49135 } },
    -- Battle for Azeroth: Raids
    ["bfaNyalotha1Normal"] = { "once", { 58373 } },
    ["bfaNyalotha1Heroic"] = { "once", { 58374 } },
    ["bfaNyalotha1Mythic"] = { "once", { 58375 } },
    -- Shadowlands
    ["slAnima"] = { "weekly", {
        61982, -- Kyrian
        61983, -- Necrolord
        61984, -- Night Fae
        61981, -- Venthyr
    } },
    ["slSouls"] = { "weekly", {
        62863, -- Kyrian
        62866, -- Necrolord
        62860, -- Night Fae
        62869, -- Venthyr
    } },
    -- Shadowlands: 9.1
    ["slShapingFate"] = { "weekly", { 63949 } },
    ["slTormentors"] = { "weekly", { 63854 } },
    ["slMawAssault"] = { "biweekly", {
        63543, -- Necrolord
        63822, -- Venthyr
        63823, -- Night Fae
        63824, -- Kyrian
    } },
    -- Shadowlands: 9.2
    ["slNewDeal"] = { "weekly", { 65649 } },
    ["slPatterns"] = { "weekly", { 66042 } },
    -- Shadowlands: Raids
    ["slNathria1Normal"] = { "once", { 62054 } },
    ["slNathria1Heroic"] = { "once", { 62055 } },
    ["slNathria1Mythic"] = { "once", { 62056 } },
    ["slSanctum1Normal"] = { "once", { 64597 } },
    ["slSanctum1Heroic"] = { "once", { 64598 } },
    ["slSanctum1Mythic"] = { "once", { 64599 } },
    ["slSepulcher1Normal"] = { "once", { 65764 } },
    ["slSepulcher1Heroic"] = { "once", { 65763 } },
    ["slSepulcher1Mythic"] = { "once", { 65762 } },

    -- Dragonflight
    ["dfAidingAccord"] = { "weekly", {
        70750, -- Aiding the Accord
        72068, -- Aiding the Accord: A Feast For All
        72373, -- Aiding the Accord: A Hunt Is On
        72374, -- Aiding the Accord: Dragonbane Keep
        72375, -- Aiding the Accord: The Isles Call
        75259, -- Aiding the Accord: Zskera Vaults
        75859, -- Aiding the Accord: Sniffenseeking
        75860, -- Aiding the Accord: Researchers Under Fire
        75861, -- Aiding the Accord: Suffusion Camp
        77254, -- Aiding the Accord: Time Rift
        77976, -- Aiding the Accord: Dreamsurge
        78446, -- Aiding the Accord: Superbloom
        78447, -- Aiding the Accord: Emerald Bounty
    } },
    ["dfCatchAileron"] = { "weekly", { 72826 } }, -- Catch and Release: Aileron Seamoth
    ["dfCatchCerulean"] = { "weekly", { 72825 } }, -- Catch and Release: Cerulean Spinefish
    ["dfCatchIslefin"] = { "weekly", { 72823 } }, -- Catch and Release: Islefin Dorado
    ["dfCatchScalebelly"] = { "weekly", { 72828 } }, -- Catch and Release: Scalebelly Mackerel
    ["dfCatchTemporal"] = { "weekly", { 72824 } }, -- Catch and Release: Temporal Dragonhead
    ["dfCatchThousandbite"] = { "weekly", { 72827 } }, -- Catch and Release: Thousandbite Piranha
    ["dfDungeonPreserving"] = { "weekly", {
        66868, -- Preserving the Past: Legacy of Tyr
        66869, -- Preserving the Past: Court of Stars (?)
        66870, -- Preserving the Past: Ruby Life Pools
        66871, -- Preserving the Past: The Nokhud Offensive
        66872, -- Preserving the Past: Brackenhide Hollow (?)
        66873, -- Preserving the Past: The Azure Vault (?)
        66874, -- Preserving the Past: Halls of Infusion
        66875, -- Preserving the Past: Algeth'ar Academy
    } },
    ["dfDungeonRelic"] = { "weekly", {
        66860, -- Relic Recovery: Legacy of Tyr
        66861, -- Relic Recovery: Court of Stars (?)
        66862, -- Relic Recovery: Ruby Life Pools
        66863, -- Relic Recovery: The Nokhud Offensive (?)
        66864, -- Relic Recovery: Brackenhide Hollow
        66865, -- Relic Recovery: The Azure Vault
        66866, -- Relic Recovery: Halls of Infusion
        66867, -- Relic Recovery: Algeth'ar Academy
    } },
    ["dfFighting"] = { "weekly", { 76122 } }, -- Fighting is its Own Reward
    ["dfSparks"] = { "weekly", {
        72646, -- Sparks of Life: The Waking Shores
        72647, -- Sparks of Life: Ohn'ahran Plains
        72648, -- Sparks of Life: Azure Span
        72649, -- Sparks of Life: Thaldraszus
        74871, -- Sparks of Life: The Forbidden Reach
        75305, -- Sparks of Life: Zaralek Cavern
        78097, -- Sparks of Life: Emerald Dream
    } },
    ["dfWorthyAllyLoammNiffen"] = { "weekly", { 75665 } }, -- A Worthy Ally: Loamm Niffen
    -- Dragonflight: Chores
    ["dfCommunityFeast"] = { "weekly", { 70893 } },
    ["dfDragonAllegiance"] = { "weekly", { 66419 } }, -- choose a dragon
    ["dfDragonKey"] = { "weekly", { 66133, 66805 } }, -- hand in key (wrathion, sabellian)
    ["dfGrandHuntMythic"] = { "weekly", { 70906 } },
    ["dfGrandHuntRare"] = { "weekly", { 71136 } },
    ["dfGrandHuntUncommon"] = { "weekly", { 71137 } },
    ["dfPrimalEarth"] = { "weekly", { 70723 } },
    ["dfPrimalFire"] = { "weekly", { 70754 } },
    ["dfPrimalStorm"] = { "weekly", { 70753 } },
    ["dfPrimalWater"] = { "weekly", { 70752 } },
    ["dfReachStormsChest"] = { "weekly", { 74567 } },
    ["dfReachStormsEvent"] = { "weekly", {
        75399, -- Water
        75400, -- Fire
        75401, -- Earth
        75402, -- Air
    } },
    ["dfSiegeDragonbaneKeep"] = { "weekly", { 70866 } },
    ["dfStormsFury"] = { "weekly", { 73162 } },
    ["dfTrialElements"] = { "weekly", { 71995 } },
    ["dfTrialFlood"] = { "weekly", { 71033 } },
    -- Dragonflight: 10.1
    ["dfFyrakkAssault"] = { "weekly", {
        75157, -- First completion tracking quest?
        75280, -- Frostburn (AS)
        74501, -- Cinderwind (OP)
    } },
    ["dfFyrakkDisciple"] = { "weekly", {
        75467, -- Killed disciple
    } },
    ["dfFyrakkShipment"] = { "weekly", {
        74526, -- (AS)
        75525, -- (OP)
    } },
    ["dfResearchersUnderFire1"] = { "weekly", { 75627 } },
    ["dfResearchersUnderFire2"] = { "weekly", { 75628 } },
    ["dfResearchersUnderFire3"] = { "weekly", { 75629 } },
    ["dfResearchersUnderFire4"] = { "weekly", { 75630 } },
    ["dfSniffenDig1"] = { "weekly", { 75749 } },
    ["dfSniffenDig2"] = { "weekly", { 75748 } },
    ["dfSniffenDig3"] = { "weekly", { 75747 } },
    -- Dragonflight: 10.1.5
    ["dfTimeRift"] = { "weekly", { 77836 } },
    ["dfWhenTimeNeedsMending"] = { "weekly", { 77236 } },
    -- Dragonflight: 10.1.7
    ["dfDreamsurge"] = { "weekly", { 77251 } },
    -- Dragonflight: 10.2.0
    ["dfBloomingDreamseeds"] = { "weekly", { 78821 } }, -- Blooming Dreamseeds
    ["dfGoodsShipments1"] = { "weekly", { 78427 } }, -- Great Crates!
    ["dfGoodsShipments5"] = { "weekly", { 78428 } }, -- Crate of the Art
    ["dfSuperbloom"] = { "weekly", { 78319 } }, -- The Superbloom
    ["dfWorthyAllyDreamWardens"] = { "weekly", { 78444 } }, -- A Worthy Ally: Dream Wardens
    -- Dragonflight: Professions
    ["dfProfessionMettle"] = { "weekly", { 70221 } },
    -- Dragonflight: Professions: Alchemy
    ["dfProfessionAlchemyDrop1"] = { "weekly", { 66373 } },
    ["dfProfessionAlchemyDrop2"] = { "weekly", { 66374 } },
    ["dfProfessionAlchemyDrop3"] = { "weekly", { 70504 } },
    ["dfProfessionAlchemyDrop4"] = { "weekly", { 70511 } },
    ["dfProfessionAlchemyDrop5"] = { "weekly", { 74935 } }, -- FR: Blazehoof Ashes
    ["dfProfessionAlchemyProvide"] = { "weekly", {
        70530, --
        70531, --
        70532, --
        70533, --
    } },
    ["dfProfessionAlchemyTask"] = { "weekly", {
        66937, --
        66938, --
        66940, -- Elixir Experiment
        72427, -- Animated Infusion
        75363, -- [ZC] Deepflayer Dust
        75371, -- [ZC] Fascinating Fungi
        77932, -- [ED] Warmth of Life
    } },
    ["dfProfessionAlchemyTreatise"] = { "weekly", { 74108 } },
    -- Dragonflight: Professions: Blacksmithing
    ["dfProfessionBlacksmithingDrop1"] = { "weekly", { 66381 } },
    ["dfProfessionBlacksmithingDrop2"] = { "weekly", { 66382 } },
    ["dfProfessionBlacksmithingDrop3"] = { "weekly", { 70512 } },
    ["dfProfessionBlacksmithingDrop4"] = { "weekly", { 70513 } },
    ["dfProfessionBlacksmithingDrop5"] = { "weekly", { 74931 } }, -- FR: Dense Seaforged Javelin
    ["dfProfessionBlacksmithingProvide"] = { "weekly", {
        70211, -- Stomping Explorers
        70233, -- Axe Shortage
        70234, -- All This Hammering
        70235, -- Repair Bill
    } },
    ["dfProfessionBlacksmithingTask"] = { "weekly", {
        66517, -- A New Source of Weapons
        66897, -- Fuel for the Forge
        66941, -- Tremendous Tools
        72398, -- Rock and Stone
        75148, -- [ZC] Ancient Techniques
        75569, -- [ZC] Blacksmith, Black Dragon
        77935, -- [ED] A-Sword-ed Needs
        77936, -- [ED] A Warm Harvest
    } },
    ["dfProfessionBlacksmithingOrders"] = { "weekly", { 70589 } },
    ["dfProfessionBlacksmithingTreatise"] = { "weekly", { 74109 } },
    -- Dragonflight: Professions: Enchanting
    ["dfProfessionEnchantingDrop1"] = { "weekly", { 66377 } },
    ["dfProfessionEnchantingDrop2"] = { "weekly", { 66378 } },
    ["dfProfessionEnchantingDrop3"] = { "weekly", { 70514 } },
    ["dfProfessionEnchantingDrop4"] = { "weekly", { 70515 } },
    ["dfProfessionEnchantingDrop5"] = { "weekly", { 74927 } }, -- FR: Speck of Arcane Awareness
    ["dfProfessionEnchantingProvide"] = { "weekly", {
        72155, --
        72172, --
        72173, --
        72175, --
    } },
    ["dfProfessionEnchantingTask"] = { "weekly", {
        66884, --
        66900, --
        66935, --
        72423, --
        75150, -- [ZC] Incandescence
        75865, -- [ZC] Relic Rustler
        77910, -- [ED] Enchanted Shrubbery
        77937, -- [ED] Forbidden Sugar
    } },
    ["dfProfessionEnchantingTreatise"] = { "weekly", { 74110 } },
    -- Dragonflight: Professions: Engineering
    ["dfProfessionEngineeringDrop1"] = { "weekly", { 66379 } },
    ["dfProfessionEngineeringDrop2"] = { "weekly", { 66380 } },
    ["dfProfessionEngineeringDrop3"] = { "weekly", { 70516 } },
    ["dfProfessionEngineeringDrop4"] = { "weekly", { 70517 } },
    ["dfProfessionEngineeringDrop5"] = { "weekly", { 74934 } }, -- FR: Everflowing Antifreeze
    ["dfProfessionEngineeringOrders"] = { "weekly", { 70591 } },
    ["dfProfessionEngineeringProvide"] = { "weekly", {
        70539, --
        70540, --
        70545, --
        70557, --
    } },
    ["dfProfessionEngineeringTask"] = { "weekly", {
        66890, --
        66891, -- Explosive Ash
        66942, -- Enemy Engineering
        72396, --
        75575, -- [ZC] Ballistae Bits
        75608, -- [ZC] Titan Trash or Titan Treasure?
        77891, -- [ED] An Unlikely Engineer
        77938, -- [ED] Fixing the Dream
    } },
    ["dfProfessionEngineeringTreatise"] = { "weekly", { 74111 } },
    -- Dragonflight: Professions: Inscription
    ["dfProfessionInscriptionDrop1"] = { "weekly", { 66375 } },
    ["dfProfessionInscriptionDrop2"] = { "weekly", { 66376 } },
    ["dfProfessionInscriptionDrop3"] = { "weekly", { 70518 } },
    ["dfProfessionInscriptionDrop4"] = { "weekly", { 70519 } },
    ["dfProfessionInscriptionDrop5"] = { "weekly", { 74932 } }, -- FR: Glimmering Rune of Arcantrix
    ["dfProfessionInscriptionOrders"] = { "weekly", { 70592 } },
    ["dfProfessionInscriptionProvide"] = { "weekly", {
        70558, --
        70559, --
        70560, --
        70561, --
    } },
    ["dfProfessionInscriptionTask"] = { "weekly", {
        66943, --
        66944, -- Peacock Pigments
        66945, --
        72438, -- Tarasek Intentions
        75149, -- [ZC] Obsidian Essays
        75573, -- [ZC] Proclamation Reclamation
        77889, -- [ED] A Fiery Proposal
        77914, -- [ED] Burning Runes
    } },
    ["dfProfessionInscriptionTreatise"] = { "weekly", { 74105 } },
    -- Dragonflight: Professions: Jewelcrafting
    ["dfProfessionJewelcraftingDrop1"] = { "weekly", { 66388 } },
    ["dfProfessionJewelcraftingDrop2"] = { "weekly", { 66389 } },
    ["dfProfessionJewelcraftingDrop3"] = { "weekly", { 70520 } },
    ["dfProfessionJewelcraftingDrop4"] = { "weekly", { 70521 } },
    ["dfProfessionJewelcraftingDrop5"] = { "weekly", { 74936 } }, -- FR: Conductive Ametrine Shard
    ["dfProfessionJewelcraftingOrders"] = { "weekly", { 70593 } },
    ["dfProfessionJewelcraftingProvide"] = { "weekly", {
        70562, --
        70563, --
        70564, --
        70565, --
    } },
    ["dfProfessionJewelcraftingTask"] = { "weekly", {
        66516, -- Mundane Gems, I Think Not!
        66949, --
        66950, --
        72428, --
        75362, -- [ZC] Cephalo-crystalization
        75602, -- [ZC] Chips off the Old Crystal Block
        77892, -- [ED] Pearls of Great Value
        77912, -- [ED] Unmodern Jewelry
    } },
    ["dfProfessionJewelcraftingTreatise"] = { "weekly", { 74112 } },
    -- Dragonflight: Professions: Leatherworking
    ["dfProfessionLeatherworkingDrop1"] = { "weekly", { 66384 } },
    ["dfProfessionLeatherworkingDrop2"] = { "weekly", { 66385 } },
    ["dfProfessionLeatherworkingDrop3"] = { "weekly", { 70522 } },
    ["dfProfessionLeatherworkingDrop4"] = { "weekly", { 70523 } },
    ["dfProfessionLeatherworkingDrop5"] = { "weekly", { 74928 } }, -- FR: Sylvern Alpha Claw
    ["dfProfessionLeatherworkingProvide"] = { "weekly", {
        70567, -- When You Give Bakar a Bone
        70568, -- Tipping the Scales
        70569, -- For Trisket, a Task Kit
        70571, -- Drums Here!
    } },
    ["dfProfessionLeatherworkingTask"] = { "weekly", {
        66363, -- Basilisk Bucklers
        66364, -- To Fly a Kite
        66951, -- Population Control
        72407, -- Soaked in Success
        75354, -- [ZC] Mycelium Mastery
        75368, -- [ZC] Stones and Scales
        77945, -- [ED] Boots on the Ground
        77946, -- [ED] Fibrous Thread
    } },
    ["dfProfessionLeatherworkingOrders"] = { "weekly", { 70594 } },
    ["dfProfessionLeatherworkingTreatise"] = { "weekly", { 74113 } },
    -- Dragonflight: Professions: Tailoring
    ["dfProfessionTailoringDrop1"] = { "weekly", { 66386 } },
    ["dfProfessionTailoringDrop2"] = { "weekly", { 66387 } },
    ["dfProfessionTailoringDrop3"] = { "weekly", { 70524 } },
    ["dfProfessionTailoringDrop4"] = { "weekly", { 70525 } },
    ["dfProfessionTailoringDrop5"] = { "weekly", { 74929 } }, -- FR: Perfect Windfeather
    ["dfProfessionTailoringProvide"] = { "weekly", {
        70572, --
        70582, --
        70586, -- Sew Many Cooks
        70587, --
    } },
    ["dfProfessionTailoringTask"] = { "weekly", {
        66952, --
        66899, --
        66953, --
        72410, -- Pincers and Needles
        75407, -- [ZC] Silk Scavenging
        75600, -- [ZC] Silk's Silk
        77947, -- [ED] Primalist Fashion
        77949, -- [ED] Fashion Feathers
    } },
    ["dfProfessionTailoringOrders"] = { "weekly", { 70595 } },
    ["dfProfessionTailoringTreatise"] = { "weekly", { 74115 } },
    -- Dragonflight: Professions: Herbalism
    ["dfProfessionHerbalismDrop1"] = { "weekly", { 71857 } },
    ["dfProfessionHerbalismDrop2"] = { "weekly", { 71858 } },
    ["dfProfessionHerbalismDrop3"] = { "weekly", { 71859 } },
    ["dfProfessionHerbalismDrop4"] = { "weekly", { 71860 } },
    ["dfProfessionHerbalismDrop5"] = { "weekly", { 71861 } },
    ["dfProfessionHerbalismDrop6"] = { "weekly", { 71864 } },
    ["dfProfessionHerbalismDrop7"] = { "weekly", { 74933 } }, -- FR: Undigested Hochenblume Petal
    ["dfProfessionHerbalismProvide"] = { "weekly", {
        70613, -- Get Their Bark Before They Bite
        70614, -- Bubble Craze
        70615, -- The Case of the Missing Herbs
        70616, -- How Many??
    } },
    ["dfProfessionHerbalismTreatise"] = { "weekly", { 74107 } },
    -- Dragonflight: Professions: Mining
    ["dfProfessionMiningDrop1"] = { "weekly", { 72160 } },
    ["dfProfessionMiningDrop2"] = { "weekly", { 72161 } },
    ["dfProfessionMiningDrop3"] = { "weekly", { 72162 } },
    ["dfProfessionMiningDrop4"] = { "weekly", { 72163 } },
    ["dfProfessionMiningDrop5"] = { "weekly", { 72164 } },
    ["dfProfessionMiningDrop6"] = { "weekly", { 72165 } },
    ["dfProfessionMiningDrop7"] = { "weekly", { 74926 } }, -- FR: Impenetrable Elemental Core
    ["dfProfessionMiningProvide"] = { "weekly", {
        70617, -- All Mine, Mine, Mine
        70618, -- The Call of the Forge
        72156, -- A Fiery Fight
        72157, -- The Weight of Earth
    } },
    ["dfProfessionMiningTreatise"] = { "weekly", { 74106 } },
    -- Dragonflight: Professions: Skinning
    ["dfProfessionSkinningDrop1"] = { "weekly", { 70381 } },
    ["dfProfessionSkinningDrop2"] = { "weekly", { 70383 } },
    ["dfProfessionSkinningDrop3"] = { "weekly", { 70384 } },
    ["dfProfessionSkinningDrop4"] = { "weekly", { 70385 } },
    ["dfProfessionSkinningDrop5"] = { "weekly", { 70386 } },
    ["dfProfessionSkinningDrop6"] = { "weekly", { 70389 } },
    ["dfProfessionSkinningDrop7"] = { "weekly", { 74930 } }, -- FR: Kingly Sheepskin Pelt
    ["dfProfessionSkinningProvide"] = { "weekly", {
        70619, -- A Study of Leather
        70620, -- Scaling Up
        72158, -- A Dense Delivery
        72159, -- Scaling Down
    } },
    ["dfProfessionSkinningTreatise"] = { "weekly", { 74114 } },
    ["dfProfessionSkinningMagmaCobra"] = { "daily", { 74235 } },
    -- Dragonflight: Raids
    ["dfVault1Normal"] = { "once", { 71018 } },
    ["dfVault1Heroic"] = { "once", { 71019 } },
    ["dfVault1Mythic"] = { "once", { 71020 } },
    ["dfAberrus1Normal"] = { "once", { 76083 } },
    ["dfAberrus1Heroic"] = { "once", { 76085 } },
    ["dfAberrus1Mythic"] = { "once", { 76086 } },
}
