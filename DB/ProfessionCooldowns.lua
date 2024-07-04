local Module = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector'):GetModule('ProfessionCooldowns')


Module.db.cooldowns = {
    -- Alchemy
    [171] = {
        -- Dragonflight
        ['dfTransmute'] = {
            370707, -- Transmute: Awakened Fire
            370708, -- Transmute: Awakened Frost
            370710, -- Transmute: Awakened Earth
            370711, -- Transmute: Awakened Air
            370714, -- Transmute: Decay to Elements
            370715, -- Transmute: Order to Elements
            405847, -- Transmute: Dracothyst
        },
        -- Warlords of Draenor
        ['wodAlchemySecrets'] = { 175880 },
    },

    -- Blacksmithing
    [164] = {
        -- Warlords of Draenor
        ['wodBlacksmithingSecrets'] = { 176090 },
    },

    -- Enchanting
    [333] = {
        -- Warlords of Draenor
        ['wodEnchantingSecrets'] = { 177043 },
    },

    -- Engineering
    [202] = {
        -- Warlords of Draenor
        ['wodEngineeringSecrets'] = { 176054 },
    },

    -- Inscription
    [773] = {
        -- Warlords of Draenor
        ['wodInscriptionSecrets'] = { 176045 },
    },

    -- Jewelcrafting
    [755] = {
        -- Dragonflight
        ['dfDreamersVision'] = { 374547 },
        ['dfEarthwardensPrize'] = { 374549 },
        ['dfJeweledDragonsHeart'] = { 374551 },
        ['dfKeepersGlory'] = { 374548 },
        ['dfQueensGift'] = { 374546 },
        ['dfTimewatchersPatience'] = { 374550 },
        -- Warlords of Draenor
        ['wodJewelcraftingSecrets'] = { 176087 },
    },

    -- Leatherworking
    [165] = {
        -- Warlords of Draenor
        ['wodLeatherworkingSecrets'] = { 176089 },
    },

    -- Tailoring
    [197] = {
         -- Dragonflight
        ['dfAzureweave'] = {
            376556, -- Azureweave Bolt
        },
        ['dfChronocloth'] = {
            376557, -- Chronocloth Bolt
        },
        -- Warlords of Draenor
        ['wodTailoringSecrets'] = { 176058 },
    },
}
