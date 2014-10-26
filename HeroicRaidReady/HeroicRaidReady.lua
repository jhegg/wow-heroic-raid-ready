HeroicRaidReady = {
    name = "HeroicRaidReady",
    requiredAchievements = {
        -- Expansion: Wrath of the Lich King
        -- todo For ICC, do you only need to kill Arthas on 10N, to access 10H?
        -- We found out that you must do 25N to do 25H, and 10N to do 10H, they are separate lockouts.
        {achievementId = 4530, mapId = 604}, -- Icecrown Citadel 10: The Frozen Throne
        {achievementId = 4597, mapId = 604}, -- Icecrown Citadel 25: The Frozen Throne

        -- Expansion: Cataclysm
        {achievementId = 4842, mapId = nil}, -- Blackwing Descent
        {achievementId = 4850, mapId = nil}, -- Bastion of Twilight
        {achievementId = 4851, mapId = nil}, -- Throne of the Four Winds
        {achievementId = 5802, mapId = nil}, -- Firelands
        {achievementId = 6177, mapId = 824}, -- Dragon Soul: Destroyer's End

        -- Expansion: Mists of Pandaria
        {achievementId = 6844, mapId = 896}, -- Mogu'shan Vaults: The Vault of Mysteries
        {achievementId = 6845, mapId = 897}, -- Heart of Fear: Nightmare of Shek'zeer
        {achievementId = 6689, mapId = nil}, -- Terrace of Endless Spring
        -- Throne of Thunder - is not locked
        -- Siege of Orgrimmar - is not locked

        -- Expansion: Warlords of Draenor
        -- Highmaul - Mythic is locked, Heroic is not. Not sure how to determine a clear of Normal or Heroic yet.
        -- Blackrock Foundry - Unsure on lockout status.
    },
    frame = {},
    ITEM_HEIGHT,
}

SLASH_HEROICRAIDREADY1 = "/heroicraidready";
SLASH_HEROICRAIDREADY2 = "/heroicrr";

SlashCmdList["HEROICRAIDREADY"] = function()
    HeroicRaidReady:UpdateEntries();
    HeroicRaidReady:DisplayHeroicReadiness();
end

function HeroicRaidReady:DisplayHeroicReadiness()
    HeroicRaidReady.frame:Show();
end

local function OnMouseDown(self,button)
    HeroicRaidReady.frame:StartMoving();
end

local function OnMouseUp(self,button)
    HeroicRaidReady.frame:StopMovingOrSizing();
end

local function TableLength(T)
    local count = 0
    for _ in pairs(T) do
        count = count + 1
    end
    return count
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
    frame.header:SetText(format("%s - By Marihk", HeroicRaidReady.name));

    frame.root = frame:CreateFontString(nil,"ARTWORK","GameFontHighlight");
    frame.root:SetFont(frame.header:GetFont(),16,"OUTLINE");
    frame.root:SetPoint("RIGHT",frame.close,"LEFT",-8,-1);
    frame.root:SetJustifyH("RIGHT");

    frame.rootFrame = HeroicRaidReady:CreateRootFrame(frame);

    frame.entries = HeroicRaidReady:CreateEntries(frame);

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
    HeroicRaidReady.ITEM_HEIGHT =
        (frame.outline:GetHeight() - 16) / TableLength(HeroicRaidReady.requiredAchievements) - 1;
    return frame.outline;
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
    return frame.rootFrame;
end

function HeroicRaidReady:CreateEntries(frame)
    local entries = {};
    local i = 1;
    for _, raid in pairs(HeroicRaidReady.requiredAchievements) do
        local _, name, _, _, _, _, _, _, _, _, _, _, wasEarnedByMe, _ = GetAchievementInfo(raid.achievementId)
        local raidName
        if (raid.mapId) then
            raidName = GetMapNameByID(raid.mapId).." - "..name
        else
            raidName = name
        end
        local raidEntry = CreateFrame("Button", nil, frame.outline);
        raidEntry:SetWidth(HeroicRaidReady.ITEM_HEIGHT);
        raidEntry:SetHeight(HeroicRaidReady.ITEM_HEIGHT);
        raidEntry:RegisterForClicks("AnyUp");
        raidEntry:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight");

        if (i == 1) then
            raidEntry:SetPoint("TOPLEFT", 8, -8);
            raidEntry:SetPoint("TOPRIGHT", -8, -8);
        else
            raidEntry:SetPoint("TOPLEFT", entries[i - 1], "BOTTOMLEFT", 0, -1);
            raidEntry:SetPoint("TOPRIGHT", entries[i - 1], "BOTTOMRIGHT", 0, -1);
        end

        raidEntry.name = raidEntry:CreateFontString(nil, "ARTWORK", "GameFontNormal");
        raidEntry.name:SetPoint("TOPLEFT");
        raidEntry.name:SetPoint("BOTTOMLEFT");
        raidEntry.name:SetJustifyH("LEFT");
        raidEntry.name:SetText(raidName);

        raidEntry.value = raidEntry:CreateFontString(nil, "ARTWORK", "GameFontNormal");
        raidEntry.value:SetPoint("RIGHT", -4, 0);
        raidEntry.value:SetPoint("LEFT", raidEntry.name, "RIGHT", 12, 0);
        raidEntry.value:SetJustifyH("RIGHT");
        raidEntry.value:SetText(format("%s", wasEarnedByMe and "Ready!" or "Not ready."));

        if (wasEarnedByMe) then
            raidEntry.name:SetTextColor(0, 1.0, 0);
            raidEntry.value:SetTextColor(0, 1.0, 0);
        else
            raidEntry.name:SetTextColor(1.0, 0, 0);
            raidEntry.value:SetTextColor(1.0, 0, 0);
        end

        raidEntry.achievementId = raid.achievementId;
        raidEntry.raidName = raidName

        entries[i] = raidEntry;
        i = i + 1;
    end
    return entries;
end

function HeroicRaidReady:UpdateEntries()
    for _, raidEntry in pairs(HeroicRaidReady.frame.entries) do
        local _, _, _, _, _, _, _, _, _, _, _, _, wasEarnedByMe, _ = GetAchievementInfo(raidEntry.achievementId)
        raidEntry.name:SetText(raidEntry.raidName);
        raidEntry.value:SetText(format("%s", wasEarnedByMe and "Ready!" or "Not ready."));
        if (wasEarnedByMe) then
            raidEntry.name:SetTextColor(0, 1.0, 0);
            raidEntry.value:SetTextColor(0, 1.0, 0);
        else
            raidEntry.name:SetTextColor(1.0, 0, 0);
            raidEntry.value:SetTextColor(1.0, 0, 0);
        end
    end
end

HeroicRaidReady.frame = HeroicRaidReady:CreateReadinessFrame();
