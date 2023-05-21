local Module = LibStub('AceAddon-3.0'):GetAddon('WoWthing_Collector'):GetModule('Achievements')


Module.db.achievements = {
    -- Warlords of Draenor
    9452, -- Trap Superstar

    -- Legion
    10596, -- Bigger Fish to Fry
    10747, -- Fighting with Style: Upgraded
    11152, -- Artifact - Hidden - Dungeons
    11153, -- Artifact - Hidden - World Quests
    11154, -- Artifact - Hidden - Kills?
    11160, -- Artifact - Balance of Power - World Bosses
    11162, -- Artifact - Balance of Power - Mythic+ 15 timed
    11657, -- Artifact - Challenge - Color 2
    11661, -- Artifact - Challenge - Color 3
    11665, -- Artifact - Challenge - Color 4

    -- Shadowlands
    14765, -- Ramparts Racer
    14766, -- Parasoling
    14799, -- Sojourner of Maldraxxus
}

Module.db.criteria = {
    [11657] = 1, -- Artifact - Challenge - Color 2
    [11661] = 1, -- Artifact - Challenge - Color 3
    [11665] = 15, -- Artifact - Challenge - Color 4
}
