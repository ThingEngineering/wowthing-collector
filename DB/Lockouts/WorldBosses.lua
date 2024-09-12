local Module = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector'):GetModule('Lockouts')


-- [questId] = { wowthingBossId, lockoutName, bossName, isDaily=false }
Module.db.worldBosses = {
    -- Anniversary bosses
    [47461] = { 100001, "Lord Kazzak", "Lord Kazzak", true },
    [47462] = { 100002, "Azuregos", "Azuregos", true },
    [47463] = { 100003, "Dragon of Nightmare", "Dragon of Nightmare", true },
    [60214] = { 100017, "Doomwalker", "Doomwalker", true },

    -- Mists of Pandaria
    [32099] = { 104001, "Sha of Anger", "Sha of Anger" },
    [32098] = { 104002, "Galleon", "Galleon" },
    [32518] = { 104003, "Nalak", "Nalak" },
    [32519] = { 104004, "Oondasta", "Oondasta" },
    [33117] = { 104005, "The Four Celestials", "A Big Beastie" },
    [33118] = { 104006, "Ordos", "Ordos" },

    -- Warlords of Draenor
    [37460] = { 105001, "Gorgrond World Bosses", "Drov the Ruinator" },
    [37462] = { 105001, "Gorgrond World Bosses", "Tarlna the Ageless" },
    [37464] = { 105002, "Rukhmar", "Rukhmar" },
    [39380] = { 105003, "Supreme Lord Kazzak", "Supreme Lord Kazzak" },

    -- Legion
    [42269] = { 106001, "Legion World Bosses", "The Soultakers" },
    [42270] = { 106001, "Legion World Bosses", "Nithogg" },
    [42779] = { 106001, "Legion World Bosses", "Shar'thos" },
    [42819] = { 106001, "Legion World Bosses", "Humongris" },
    [43192] = { 106001, "Legion World Bosses", "Levantus" },
    [43193] = { 106001, "Legion World Bosses", "Calamir" },
    [43448] = { 106001, "Legion World Bosses", "Drugon the Frostblood" },
    [43512] = { 106001, "Legion World Bosses", "Ana-Mouz" },
    [43513] = { 106001, "Legion World Bosses", "Na'zak the Fiend" },
    [43985] = { 106001, "Legion World Bosses", "Flotsam" },
    [44287] = { 106001, "Legion World Bosses", "Withered Jim" },

    [46945] = { 106002, "Broken Shore World Bosses", "Si'vash" },
    [46947] = { 106002, "Broken Shore World Bosses", "Brutallus" },
    [46948] = { 106002, "Broken Shore World Bosses", "Malificus" },
    [47061] = { 106002, "Broken Shore World Bosses", "Apocron" },

    [49166] = { 106003, "Argus Greater Invasions", "Inquisitor Meto" },
    [49167] = { 106003, "Argus Greater Invasions", "Mistress Alluradel" },
    [49168] = { 106003, "Argus Greater Invasions", "Pit Lord Vilemus" },
    [49169] = { 106003, "Argus Greater Invasions", "Matron Folnuna" },
    [49170] = { 106003, "Argus Greater Invasions", "Occularus" },
    [49171] = { 106003, "Argus Greater Invasions", "Sotanathor" },

    -- Battle for Azeroth
    [52181] = { 107001, "BfA World Bosses", "T'Zane" },
    [52169] = { 107001, "BfA World Bosses", "Ji'arak" },
    [52157] = { 107001, "BfA World Bosses", "Hailstone Construct" },
    [52163] = { 107001, "BfA World Bosses", "Azurethos" },
    [52166] = { 107001, "BfA World Bosses", "Warbringer Yenajz" },
    [52196] = { 107001, "BfA World Bosses", "Dunegorger Kraulok" },

    [52848] = { 107002, "Arathi World Bosses", "The Lion's Roar" },
    [52847] = { 107002, "Arathi World Bosses", "Doom's Howl" },

    [54896] = { 107003, "Darkshore World Bosses", "Ivus the Forest Lord" },
    [54895] = { 107003, "Darkshore World Bosses", "Ivus the Decayed" },

    [56058] = { 107004, "Nazjatar World Bosses", "Ulmath, the Soulbinder" },
    [56055] = { 107004, "Nazjatar World Bosses", "Wekemara" },

    [55466] = { 107005, "Uldum World Bosses", "Vuk'laz the Earthbreaker" },

    [58705] = { 107005, "Vale World Bosses", "Grand Empress Shek'zara" },

    -- Shadowlands
    [61813] = { 108001, "Shadowlands World Bosses", "Valinor, the Light of Eons" },
    [61814] = { 108001, "Shadowlands World Bosses", "Nurgash Muckformed" },
    [61815] = { 108001, "Shadowlands World Bosses", "Oranomonos the Everbranching" },
    [61816] = { 108001, "Shadowlands World Bosses", "Mortanis" },

    [63414] = { 108002, "Wrath of the Jailer", "Wrath of the Jailer" },

    [63854] = { 108003, "Tormentors of Torghast", "Tormentors of Torghast" },

    [64531] = { 108004, "Mor'geth", "Mor'geth, Tormentor of the Damned" },

    [65143] = { 108005, "Antros", "Antros" },

    -- [66614] = { 108006, "Fated Shadowlands World Bosses", "Valinor, the Light of Eons" },
    -- [66615] = { 108006, "Fated Shadowlands World Bosses", "Nurgash Muckformed" },
    -- [66616] = { 108006, "Fated Shadowlands World Bosses", "Oranomonos the Everbranching" },
    -- [66617] = { 108006, "Fated Shadowlands World Bosses", "Mortanis" },
    -- [66618] = { 108006, "Fated Shadowlands World Bosses", "Mor'geth, Tormentor of the Damned" },
    -- [66619] = { 108006, "Fated Shadowlands World Bosses", "Antros" },

    -- Dragonflight
    [69927] = { 109001, "Dragonflight World Bosses", "Bazual, The Dreaded Flame" },
    [69928] = { 109001, "Dragonflight World Bosses", "Liskanoth, The Futurebane" },
    [69929] = { 109001, "Dragonflight World Bosses", "Strunraan, The Sky's Misery" },
    [69930] = { 109001, "Dragonflight World Bosses", "Basrikron, The Shale Wing" },

    [74892] = { 109002, "Zaqali Elders", "The Zaqali Elders" },

    [76367] = { 109003, "Aurostor", "Aurostor, The Hibernator" },

    -- The War Within
    [81624] = { 110001, "War Within World Bosses", "Orta, the Broken Mountain" },
    [81630] = { 110001, "War Within World Bosses", "Kordac, the Dormant Protector" },
    [81653] = { 110001, "War Within World Bosses", "Shurrai, Atrocity of the Undersea" },
    [83466] = { 110001, "War Within World Bosses", "Aggregation of Horrors" },
}
