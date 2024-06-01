local Module = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector'):GetModule('Lockouts')


Module.db.instances = {
    {
        dungeonId = 285,
    }, -- The Headless Horseman
    {
        dungeonId = 286,
    }, -- The Frost Lord Ahune
    {
        dungeonId = 287,
    }, -- Coren Direbrew
    {
        dungeonId = 288,
    }, -- Crown Chemical Co.

    -- MoP Remix
    {
        dungeonId = 2538,
        progressKey = 'remixNormalDungeon',
    }, -- Random Normal Dungeon
    {
        dungeonId = 2539,
        progressKey = 'remixHeroicDungeon',
    }, -- Random Heroic Dungeon
    {
        dungeonId = 2558,
        progressKey = 'remixNormalScenario',
    }, -- Random Normal Scenario
    {
        dungeonId = 2559,
        progressKey = 'remixHeroicScenario',
    }, -- Random Heroic Scenario
    {
        dungeonId = 2597,
        progressKey = 'remixMSV1',
    }, -- Mogu'shan Vaults: The Vault of Mysteries
    {
        dungeonId = 2598,
        progressKey = 'remixMSV2',
    }, -- Mogu'shan Vaults: Guardians of Mogu'shan
    {
        dungeonId = 2599,
        progressKey = 'remixToES1',
    }, -- Terrace of Endless Spring
    {
        dungeonId = 2596,
        progressKey = 'remixHoF1',
    }, -- Heart of Fear: The Dread Approach
    {
        dungeonId = 2595,
        progressKey = 'remixHoF2',
    }, -- Heart of Fear: Nightmare of Shek'zeer
    {
        dungeonId = 2594,
        progressKey = 'remixToT1',
    }, -- Throne of Thunder: Last Stand of the Zandalari
    {
        dungeonId = 2593,
        progressKey = 'remixToT2',
    }, -- Throne of Thunder: Forgotten Depths
    {
        dungeonId = 2592,
        progressKey = 'remixToT3',
    }, -- Throne of Thunder: Halls of Flesh-Shaping
    {
        dungeonId = 2591,
        progressKey = 'remixToT4',
    }, -- Throne of Thunder: Pinnacle of Storms
    {
        dungeonId = 2590,
        progressKey = 'remixSoO1',
    }, -- Siege of Orgrimmar: Vale of Eternal Sorrows
    {
        dungeonId = 2589,
        progressKey = 'remixSoO2',
    }, -- Siege of Orgrimmar: Gates of Retribution
    {
        dungeonId = 2588,
        progressKey = 'remixSoO3',
    }, -- Siege of Orgrimmar: The Underhold
    {
        dungeonId = 25,
        progressKey = 'remixSoO4',
    }, -- Siege of Orgrimmar: Downfall
}
