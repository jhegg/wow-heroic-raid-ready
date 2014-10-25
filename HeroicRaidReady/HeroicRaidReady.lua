HeroicRaidReady = {
    name = "HeroicRaidReady",
    requiredAchievements = {
        4842, -- Blackwing Descent
        4850, -- Bastion of Twilight
        4851, -- Throne of the Four Winds
    }
}

SLASH_HEROICRAIDREADY1 = "/heroicraidready";
SLASH_HEROICRAIDREADY2 = "/heroicrr";

SlashCmdList["HEROICRAIDREADY"] = function()
    HeroicRaidReady:DisplayHeroicReadiness();
end

function HeroicRaidReady:DisplayHeroicReadiness()
    for _,achievementId in pairs(HeroicRaidReady.requiredAchievements) do
        local id, name, points, completed, month, day, year, description, flags, icon, rewardText,
            isGuildAch, wasEarnedByMe, earnedBy = GetAchievementInfo(achievementId)
        DEFAULT_CHAT_FRAME:AddMessage(format("%s -- %s", name, wasEarnedByMe and "Ready!" or "Not ready."));
    end
end
