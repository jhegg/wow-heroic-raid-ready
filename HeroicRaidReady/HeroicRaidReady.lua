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
        local _, name, _, _, _, _, _, _, _, _, _, _, wasEarnedByMe, _ = GetAchievementInfo(achievementId)
        DEFAULT_CHAT_FRAME:AddMessage(format("%s -- %s", name, wasEarnedByMe and "Ready!" or "Not ready."));
    end

    HeroicRaidReady.frame:Show();
end

local function OnMouseDown(self,button)
    HeroicRaidReady.frame:StartMoving();
end

local function OnMouseUp(self,button)
    HeroicRaidReady.frame:StopMovingOrSizing();
end

function HeroicRaidReady:CreateReadinessFrame()
    local frame = HeroicRaidReady:CreateMainFrame()

    frame.close = CreateFrame("Button",nil,frame,"UIPanelCloseButton");
    frame.close:SetPoint("TOPRIGHT", -5, -5);
    frame.close:SetScript("OnClick", function() frame:Hide() end);

    frame.outline = HeroicRaidReady:CreateFrameOutline(frame);

    frame.header = frame:CreateFontString(nil,"ARTWORK","GameFontHighlight");
    frame.header:SetFont(frame.header:GetFont(),24,"THICKOUTLINE");
    frame.header:SetPoint("TOPLEFT",12,-12);

    frame.root = frame:CreateFontString(nil,"ARTWORK","GameFontHighlight");
    frame.root:SetFont(frame.header:GetFont(),16,"OUTLINE");
    frame.root:SetPoint("RIGHT",frame.close,"LEFT",-8,-1);
    frame.root:SetJustifyH("RIGHT");

    frame.rootFrame = HeroicRaidReady:CreateRootFrame(frame);

    return frame;
end

function HeroicRaidReady:CreateMainFrame()
    local frame = CreateFrame("Frame", HeroicRaidReady.name, UIParent);
    frame:SetWidth(520);
    frame:SetHeight(420);
    frame:EnableMouse(1);
    frame:SetMovable(1);
    frame:SetFrameStrata("HIGH");
    --HeroicRaidReady.frame:SetTopLevel(1);
    frame:SetPoint("CENTER");
    frame:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = 1,
        tileSize = 16,
        edgeSize = 16,
        insets = {
            left = 3,
            right = 3,
            top = 3,
            bottom = 3
        }
    });
    frame:SetBackdropColor(0,0,0,1);
    frame:SetBackdropBorderColor(0.1,0.1,0.1,1);
    frame:SetScript("OnMouseDown",OnMouseDown);
    frame:SetScript("OnMouseUp",OnMouseUp);
    frame:Hide();
    return frame;
end

function HeroicRaidReady:CreateFrameOutline(frame)
    frame.outline = CreateFrame("Frame",nil,frame);
    frame.outline:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = 1,
        tileSize = 16,
        edgeSize = 16,
        insets = {
            left = 4,
            right = 4,
            top = 4,
            bottom = 4
        }
    });
    frame.outline:SetBackdropColor(0.1,0.1,0.2,1);
    frame.outline:SetBackdropBorderColor(0.8,0.8,0.9,0.4);
    frame.outline:SetPoint("TOPLEFT",12,-38);
    frame.outline:SetPoint("BOTTOMRIGHT",-12,42);
end

function HeroicRaidReady:CreateRootFrame(frame)
    frame.rootFrame = CreateFrame("Frame",nil,frame);
    frame.rootFrame:SetHeight(20);
    frame.rootFrame:SetPoint("LEFT",frame.root);
    frame.rootFrame:SetPoint("RIGHT",frame.root);
    frame.rootFrame:EnableMouse(1);
    frame.rootFrame:SetScript("OnLeave",function(self) GameTooltip:Hide(); end);
    frame.rootFrame:SetScript("OnEnter",RootFrame_OnEnter);
    frame.rootFrame:SetScript("OnMouseDown",OnMouseDown);
    frame.rootFrame:SetScript("OnMouseUp",OnMouseUp);
end

HeroicRaidReady.frame = HeroicRaidReady:CreateReadinessFrame();
