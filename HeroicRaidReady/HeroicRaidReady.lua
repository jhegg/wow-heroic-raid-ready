HeroicRaidReady = {
    name = "HeroicRaidReady",
    requiredAchievements = {
        -- Expansion: Wrath of the Lich King
        -- todo For ICC, do you only need to kill Arthas on 10N, to access 10H/25H?
        -- todo And can you just do 25N to access both 10H/25H?
        4531, -- Icecrown Citadel 10: Storming the Citadel
        4529, -- Icecrown Citadel 10: The Crimson Hall
        4527, -- Icecrown Citadel 10: The Frostwing Halls
        4528, -- Icecrown Citadel 10: The Plagueworks
        4530, -- Icecrown Citadel 10: The Frozen Throne
        4604, -- Icecrown Citadel 25: Storming the Citadel
        4606, -- Icecrown Citadel 25: The Crimson Hall
        4607, -- Icecrown Citadel 25: The Frostwing Halls
        4605, -- Icecrown Citadel 25: The Plagueworks
        4597, -- Icecrown Citadel 25: The Frozen Throne
        -- todo Eye of Eternity
        -- todo Naxxramas?

        -- Expansion: Cataclysm
        4842, -- Blackwing Descent
        4850, -- Bastion of Twilight
        4851, -- Throne of the Four Winds
        5802, -- Firelands
        6106, -- Dragon Soul: Siege of Wyrmrest Temple (Part 1)
        6107, -- Dragon Soul: Fall of Deathwing (Part 2)

        -- Expansion: Mists of Pandaria
        6718, -- Heart of Fear: The Dread Approach
        6845, -- Heart of Fear: Nightmare of Shek'zeer
        6458, -- Mogu'shan Vaults: Guardians of Mogu'shan
        6844, -- Mogu'shan Vaults: The Vault of Mysteries
        6689, -- Terrace of Endless Spring
        8070, -- Throne of Thunder: Forgotten Depths
        8069, -- Throne of Thunder: Last Stand of the Zandalari
        8071, -- Throne of Thunder: Halls of Flesh-Shaping
        8072, -- Throne of Thunder: Pinnacle of Storms
        -- Siege of Orgrimmar - is not locked
    }
}

SLASH_HEROICRAIDREADY1 = "/heroicraidready";
SLASH_HEROICRAIDREADY2 = "/heroicrr";

SlashCmdList["HEROICRAIDREADY"] = function()
    HeroicRaidReady:DisplayHeroicReadiness();
end

function HeroicRaidReady:DisplayHeroicReadiness()
    -- todo Group these by raid
    for _,achievementId in pairs(HeroicRaidReady.requiredAchievements) do
        local id, name, points, completed, month, day, year, description, flags, icon, rewardText,
            isGuildAch, wasEarnedByMe, earnedBy = GetAchievementInfo(achievementId)
        DEFAULT_CHAT_FRAME:AddMessage(format("%s -- %s", name, wasEarnedByMe and "Ready!" or "Not ready."));
    end
end
