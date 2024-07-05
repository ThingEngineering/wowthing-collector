local Module = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector'):GetModule('Professions')


-- [skillLineId] = { spellIds }
Module.db.wonkyProfessions = {
    -- Pandaria professions don't exist in the external API
    [975] = { -- Way of the Grill
        104298, -- Charbroiled Tiger Steak
        104299, -- Eternal Blossom Fish
        104300, -- Black Pepper Ribs and Shrimp
        125141, -- Banquet of the Grill
        125142, -- Great Banquet of the Grill
        145311, -- Fluffy Silkfeather Omelet
    },
    [976] = { -- Way of the Wok
        104301, -- Sauteed Carrots
        104302, -- Valley Stir Fry    
        104303, -- Sea Mist Rice Noodles
        125594, -- Banquet of the Wok
        125595, -- Great Banquet of the Wok
        145305, -- Seasoned Pomfruit Slices
    },
    [977] = { -- Way of the Pot
        104305, -- Braised Turtle
        104306, -- Mogu Fish Stew
        104307, -- Shrimp Dumplings
        125596, -- Banquet of the Pot
        125597, -- Great Banquet of the Pot
        145307, -- Spiced Blossom Soup
    },
    [978] = { -- Way of the Steamer
        104304, -- Swirling Mist Soup
        104308, -- Fire Spirit Salmon
        104309, -- Steamed Crab Surprise
        125598, -- Banquet of the Steamer
        125599, -- Great Banquet of the Steamer
        145309, -- Farmer's Delight
    },
    [979] = { -- Way of the Oven
        104310, -- Wildfowl Roast
        104311, -- Twin Fish Platter
        104312, -- Chun Tian Spring Rolls
        125600, -- Banquet of the Oven
        125601, -- Great Banquet of the Oven
        145310, -- Stuffed Lushrooms
    },
    [980] = { -- Way of the Brew
        124052, -- Ginseng Tea
        124053, -- Jade Witch Brew
        124054, -- Mad Brewer's Breakfast
        125602, -- Banquet of the Brew
        125603, -- Great Banquet of the Brew
        126654, -- Four Senses Brew
        126655, -- Banana Infused Rum
    },
}
