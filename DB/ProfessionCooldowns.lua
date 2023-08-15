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
    },
}
