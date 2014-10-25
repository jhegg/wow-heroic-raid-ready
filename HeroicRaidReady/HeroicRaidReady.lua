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
    local _, Name, _, Completed = GetAchievementInfo(4842)
    DEFAULT_CHAT_FRAME:AddMessage(format("%s -- %s", Name, Completed and "Ready!" or "Not ready."));
end