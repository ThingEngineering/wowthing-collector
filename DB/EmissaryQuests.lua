local Module = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector'):GetModule('EmissaryQuests')


Module.db.expansions = {
    -- Legion
    {
        id = 6,
        uiMapId = 627, -- Dalaran
    },
    -- Battle for Azeroth
    {
        id = 7,
        uiMapId = 875, -- Zandalar
    },
    -- Shadowlands
    {
        id = 8,
        uiMapId = 1670, -- Oribos
    },
}

-- Map horde quest ID to alliance quest ID for consistency
Module.db.questMap = {
    [50598] = 50599, -- Zandalari Empire -> Proudmoore Admiralty
    [50603] = 50600, -- Voldunai -> Order of Embers
    [50602] = 50601, -- Talanji's Expedition -> Storm's Wake
    [50606] = 50605, -- The Honorbound -> 7th Legion
    [56120] = 56119, -- The Unshackled -> The Waveblade Ankoan

    -- Anima Salvage (Kyrian)
    [60459] = 60458, -- Necrolord
    [60457] = 60458, -- Night Fae
    [60460] = 60458, -- Venthyr
    -- Rare Resources (Kyrian)
    [60416] = 60415, -- Necrolord
    [60414] = 60415, -- Night Fae
    [60417] = 60415, -- Venthyr
    -- Storm the Maw (Kyrian)
    [60455] = 60454, -- Necrolord
    [60452] = 60454, -- Night Fae
    [60456] = 60454, -- Venthyr

    -- Aiding Ardenweald (Kyrian)
    [60390] = 60391, -- Necrolord
    [60381] = 60391, -- Night Fae
    [60389] = 60391, -- Venthyr
    -- Aiding Bastion (Kyrian)
    [60393] = 60392, -- Necrolord
    [60384] = 60392, -- Night Fae
    [60394] = 60392, -- Venthyr
    -- Aiding Maldraxxus (Kyrian)
    [60396] = 60395, -- Necrolord
    [60383] = 60395, -- Night Fae
    [60397] = 60395, -- Venthyr
    -- Aiding Revendreth (Kyrian)
    [60398] = 60400, -- Necrolord
    [60382] = 60400, -- Night Fae
    [60399] = 60400, -- Venthyr

    -- A Call to Ardenweald (Kyrian)
    [60423] = 60424, -- Necrolord
    [60419] = 60424, -- Night Fae
    [60422] = 60424, -- Venthyr
    -- A Call to Bastion (Necrolord)
    [60425] = 60426, -- Kyrian
    [60418] = 60426, -- Night Fae
    [60427] = 60426, -- Venthyr
    -- A Call to Maldraxxus (Kyrian)
    [60429] = 60430, -- Necrolord
    [60420] = 60430, -- Night Fae
    [60431] = 60430, -- Venthyr
    -- A Call to Revendreth (Kyrian)
    [60433] = 60434, -- Necrolord
    [60421] = 60434, -- Night Fae
    [60432] = 60434, -- Venthyr

    -- Challenges in Ardenweald (Kyrian)
    [60440] = 60439, -- Necrolord
    [60438] = 60439, -- Night Fae
    [60441] = 60439, -- Venthyr
    -- Challenges in Bastion (Kyrian)
    [60443] = 60442, -- Necrolord
    [60437] = 60442, -- Night Fae
    [60444] = 60442, -- Venthyr
    -- Challenges in Maldraxxus (Kyrian)
    [60445] = 60447, -- Necrolord
    [60436] = 60447, -- Night Fae
    [60446] = 60447, -- Venthyr
    -- Challenges in Revendreth (Kyrian)
    [60449] = 60450, -- Necrolord
    [60435] = 60450, -- Night Fae
    [60448] = 60450, -- Venthyr

    -- Training in Ardenweald (Kyrian)
    [60402] = 60403, -- Necrolord
    [60388] = 60403, -- Night Fae
    [60401] = 60403, -- Venthyr
    -- Training in Bastion (Necrolord)
    [60404] = 60405, -- Kyrian
    [60387] = 60405, -- Night Fae
    [60406] = 60405, -- Venthyr
    -- Training in Maldraxxus (Kyrian)
    [60408] = 60407, -- Necrolord
    [60386] = 60407, -- Night Fae
    [60409] = 60407, -- Venthyr
    -- Training in Revendreth (Kyrian)
    [60411] = 60412, -- Necrolord
    [60385] = 60412, -- Night Fae
    [60410] = 60412, -- Venthyr
}
