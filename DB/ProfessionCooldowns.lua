local Module = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector'):GetModule('ProfessionCooldowns')


Module.db.cooldowns = {
    -- Alchemy
    [171] = {
        -- The War Within
        ['twwAlchemyMeticulous'] = { { 430345 } },
        -- Dragonflight
        ['dfTransmute'] = { {
            370707, -- Transmute: Awakened Fire
            370708, -- Transmute: Awakened Frost
            370710, -- Transmute: Awakened Earth
            370711, -- Transmute: Awakened Air
            370714, -- Transmute: Decay to Elements
            370715, -- Transmute: Order to Elements
            405847, -- Transmute: Dracothyst
        } },
        -- Warlords of Draenor
        ['wodAlchemySecrets'] = { { 175880 }, true },
        ['wodAlchemyCatalyst'] = { { 156587 } },
        -- Mists of Pandaria
        ['mopAlchemyLivingSteel'] = { { 114780 } },
    },

    -- Blacksmithing
    [164] = {
        -- The War Within
        ['twwBlacksmithingEverburning'] = { { 453727 } },
        -- Warlords of Draenor
        ['wodBlacksmithingSecrets'] = { { 176090 }, true },
        ['wodBlacksmithingTruesteel'] = { { 171690 } },
        -- Mists of Pandaria
        ['mopBlacksmithingTrillium'] = { { 143255 } },
        ['mopBlacksmithingLightning'] = { { 138646 } },
    },

    -- Enchanting
    [333] = {
        -- Warlords of Draenor
        ['wodEnchantingSecrets'] = { { 177043 }, true },
    },

    -- Engineering
    [202] = {
        -- The War Within
        ['twwBoxOBooms'] = { { 447374 } },
        ['twwInvent'] = { { 447312 } },
        -- Dragonflight
        ['dfSuspiciouslySilent'] = { { 382358 } },
        ['dfSuspiciouslyTicking'] = { { 382354 } },
        -- Warlords of Draenor
        ['wodEngineeringSecrets'] = { { 176054 }, true },
        -- Mists of Pandaria
        ['mopEngineeringPeculiar'] = { { 139176 } },
    },

    -- Inscription
    [773] = {
        -- Warlords of Draenor
        ['wodInscriptionSecrets'] = { { 176045 }, true },
        -- Mists of Pandaria
        ['mopInscriptionWisdom'] = { { 112996 } },
    },

    -- Jewelcrafting
    [755] = {
        -- The War Within
        ['twwAlgariAmberPrism'] = { { 435337 } },
        ['twwAlgariEmeraldPrism'] = { { 435338 } },
        ['twwAlgariOnyxPrism'] = { { 435369 } },
        ['twwAlgariRubyPrism'] = { { 435339 } },
        ['twwAlgariSapphirePrism'] = { { 435370 } },
        -- Dragonflight
        ['dfDreamersVision'] = { { 374547 } },
        ['dfEarthwardensPrize'] = { { 374549 } },
        ['dfJeweledDragonsHeart'] = { { 374551 } },
        ['dfKeepersGlory'] = { { 374548 } },
        ['dfQueensGift'] = { { 374546 } },
        ['dfTimewatchersPatience'] = { { 374550 } },
        -- Warlords of Draenor
        ['wodJewelcraftingSecrets'] = { { 176087 }, true },
        -- Mists of Pandaria
        ['mopJewelcraftingResearch'] = { {
            131691, -- Imperial Amethyst
            131686, -- Primordial Ruby
            131593, -- River's Heart
            131695, -- Sun's Radiance
            131690, -- Vermilion Onyx
            131688, -- Wild Jade
        }, true },
        ['mopJewelcraftingSerpents'] = { { 140050 } },
    },

    -- Leatherworking
    [165] = {
        -- Warlords of Draenor
        ['wodLeatherworkingSecrets'] = { { 176089 }, true },
        -- Mists of Pandaria
        ['mopLeatherworkingHardened'] = { { 142976 }, true },
        ['mopLeatherworkingMagnificence'] = { {
            140040, -- Magnificence of Leather
            140041, -- Magnificence of Scales
        }, true },
    },

    -- Tailoring
    [197] = {
        -- The War Within
        ['twwDawnweave'] = { { 446928 } },
        ['twwDuskweave'] = { { 446927 } },
        -- Dragonflight
        ['dfAzureweave'] = { { 376556 } },
        ['dfChronocloth'] = { { 376557 } },
        -- Warlords of Draenor
        ['wodTailoringSecrets'] = { { 176058 }, true },
        -- Mists of Pandaria
        ['mopTailoringCelestial'] = { { 143011 } },
        ['mopTailoringImperial'] = { { 125557 } },
        -- Cataclysm
        ['cataTailoringAzshara'] = { { 75146 } },
        ['cataTailoringDeepholm'] = { { 75142 } },
        ['cataTailoringHyjal'] = { { 75144 } },
        ['cataTailoringRagnaros'] = { { 75145 } },
        ['cataTailoringSkywall'] = { { 75141 } },
    },
}
