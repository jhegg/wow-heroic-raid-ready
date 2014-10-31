local addonName, _ = ...

HeroicRaidReady = {
    name = addonName,
    version = GetAddOnMetadata(addonName, "Version"),
    author = GetAddOnMetadata(addonName, "Author"),
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
        {statisticId10 = 6799, statisticId25 = 7926, mapId = 896}, -- Mogu'shan Vaults: Will of the Emperor
        {statisticId10 = 6811, statisticId25 = 7963, mapId = 897}, -- Heart of Fear: Grand Empress Shek'zeer
        {statisticId10 = 6819, statisticId25 = 7971, mapId = 886}, -- Terrace of Endless Spring: Sha of Fear
        -- Throne of Thunder - is not locked
        -- Siege of Orgrimmar - is not locked

        -- Expansion: Warlords of Draenor
        -- Highmaul - Mythic is locked, Heroic is not. Not sure how to determine a clear of Normal or Heroic yet.
        -- Blackrock Foundry - Unsure on lockout status.
    },
    frame = {},
    ITEM_HEIGHT,
    selectedCharacter,
}

HeroicRaidReady.addon = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceEvent-3.0")
local addon = HeroicRaidReady.addon

SLASH_HEROICRAIDREADY1 = "/heroicraidready";
SLASH_HEROICRAIDREADY2 = "/heroicrr";

SlashCmdList["HEROICRAIDREADY"] = function()
    HeroicRaidReady:DisplayHeroicReadiness();
end

function HeroicRaidReady:DisplayHeroicReadiness()
    HeroicRaidReady:RefreshAchievementData()
    HeroicRaidReady:UpdateEntries();
    HeroicRaidReady.frame:Show();
end

function HeroicRaidReady:SwitchCharacter(name)
    HeroicRaidReady.selectedCharacter = name
    HeroicRaidReady:UpdateEntries();
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

local numberOfAchievements = TableLength(HeroicRaidReady.requiredAchievements)

local function GetCharacterNamesFromDb()
    local names = {}
    local numberOfNames = 0
    for characterName in pairs(HeroicRaidReady.db.factionrealm.character) do
        numberOfNames = numberOfNames + 1
        names[numberOfNames] = characterName
    end
    return names, numberOfNames
end

local function CharacterNameDropDown_OnClick(_, arg1, _, _)
    HeroicRaidReady.selectedCharacter = arg1
    UIDropDownMenu_SetText(HeroicRaidReady.frame.dropDown, arg1)
    HeroicRaidReady:UpdateEntries();
end

local function CreateCharacterNameDropDown(frame)
    frame.dropDown = CreateFrame("Frame", "HeroicRaidReadyDropDown", frame, "UIDropDownMenuTemplate")
    frame.dropDown:SetPoint("BOTTOMLEFT", 0, 6)
    UIDropDownMenu_SetWidth(frame.dropDown, 150)
    UIDropDownMenu_SetText(frame.dropDown, "Select Character...")

    UIDropDownMenu_Initialize(frame.dropDown, function(self, level, menuList)
        local info = UIDropDownMenu_CreateInfo()
        local names, _ = GetCharacterNamesFromDb()
        for _, name in pairs(names) do
            info.text = name
            info.arg1 = name
            info.checked = name == HeroicRaidReady.selectedCharacter
            info.func = CharacterNameDropDown_OnClick
            UIDropDownMenu_AddButton(info, level)
        end
    end)
end

function HeroicRaidReady:CreateReadinessFrame()
    local frame = HeroicRaidReady:CreateMainFrame()

    CreateCharacterNameDropDown(frame)

    frame.close = CreateFrame("Button",nil,frame,"UIPanelCloseButton");
    frame.close:SetPoint("TOPRIGHT", -5, -5);
    frame.close:SetScript("OnClick", function() frame:Hide() end);

    frame.outline = HeroicRaidReady:CreateFrameOutline(frame);

    frame.header = frame:CreateFontString(nil,"ARTWORK","GameFontHighlight");
    frame.header:SetFont(frame.header:GetFont(),24,"THICKOUTLINE");
    frame.header:SetPoint("TOPLEFT",12,-12);
    frame.header:SetText(format("%s %s - By %s", HeroicRaidReady.name, HeroicRaidReady.version, HeroicRaidReady.author));

    frame.root = frame:CreateFontString(nil,"ARTWORK","GameFontHighlight");
    frame.root:SetFont(frame.header:GetFont(),16,"OUTLINE");
    frame.root:SetPoint("RIGHT",frame.close,"LEFT",-8,-1);
    frame.root:SetJustifyH("RIGHT");

    frame.rootFrame = HeroicRaidReady:CreateRootFrame(frame);

    frame.entries = HeroicRaidReady:CreateEntryFrames(frame);

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
    HeroicRaidReady.ITEM_HEIGHT = (frame.outline:GetHeight() - 16) / numberOfAchievements - 1;
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

function HeroicRaidReady:GetRaidInformation(raid)
    if (raid.achievementId) then
        local _, achievementName, _, _, _, _, _, _, _, _, _, _, wasEarnedByMe, _ = GetAchievementInfo(raid.achievementId)
        if (raid.mapId and raid.achievementId) then
            return GetMapNameByID(raid.mapId).." - "..achievementName, wasEarnedByMe
        else
            return achievementName, wasEarnedByMe
        end
    else
        local killsOn10, _, _ = GetStatistic(raid.statisticId10)
        local killsOn25, _, _ = GetStatistic(raid.statisticId25)
        local numericKillsOn10 = tonumber(killsOn10)
        local numericKillsOn25 = tonumber(killsOn25)
        if ((numericKillsOn10 and numericKillsOn10 > 0) or
                (numericKillsOn25 and numericKillsOn25 > 0)) then
            return GetMapNameByID(raid.mapId), true
        else
            return GetMapNameByID(raid.mapId), false
        end
    end
end

function HeroicRaidReady:CreateEntryFrame(frame,entries,i)
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

    raidEntry.value = raidEntry:CreateFontString(nil, "ARTWORK", "GameFontNormal");
    raidEntry.value:SetPoint("RIGHT", -4, 0);
    raidEntry.value:SetPoint("LEFT", raidEntry.name, "RIGHT", 12, 0);
    raidEntry.value:SetJustifyH("RIGHT");

    return raidEntry
end

function HeroicRaidReady:CreateEntryFrames(frame)
    local entries = {};
    for i=1,numberOfAchievements do
        entries[i] = HeroicRaidReady:CreateEntryFrame(frame,entries,i)
    end
    return entries;
end

function HeroicRaidReady:UpdateEntries()
    -- Requires the achievement data to be populated
    local characterData = HeroicRaidReady.db.factionrealm.character[HeroicRaidReady.selectedCharacter]
    for i=1,numberOfAchievements do
        local raidEntry = HeroicRaidReady.frame.entries[i]
        raidEntry.name:SetText(characterData[i].raidName)
        raidEntry.value:SetText(format("%s", characterData[i].ready and "Ready!" or "Not ready."));
        if (characterData[i].ready) then
            raidEntry.name:SetTextColor(0, 1.0, 0);
            raidEntry.value:SetTextColor(0, 1.0, 0);
        else
            raidEntry.name:SetTextColor(1.0, 0, 0);
            raidEntry.value:SetTextColor(1.0, 0, 0);
        end
    end
end

function HeroicRaidReady:RefreshAchievementData()
    print("DEBUG: Invoking HeroicRaidReady:GetRaidInformation") -- todo remove debug

    local characterData = HeroicRaidReady.db.factionrealm.character[UnitName("player")]
    local i = 1
    for _, theRaid in pairs(HeroicRaidReady.requiredAchievements) do
        characterData[i] = characterData[i] or { ready = false }
        if (characterData[i].ready == false) then
            local raidName, isReady = HeroicRaidReady:GetRaidInformation(theRaid)
            characterData[i] = {
                raid = theRaid,
                raidName = raidName,
                ready = isReady,
            }
        end
        i = i + 1
    end
    HeroicRaidReady.db.factionrealm.character[UnitName("player")].lastUpdate = time()
end

local function AreAllRaidsReady()
    local i = 1
    for _, _ in pairs(HeroicRaidReady.requiredAchievements) do
        if (HeroicRaidReady.db.factionrealm.character[UnitName("player")][i].ready == false) then
            return false
        end
        i = i + 1
    end
end

local function OnPlayerLeavingCombat()
    HeroicRaidReady:RefreshAchievementData()
end

local function OnPlayerAlive()
    addon:UnregisterEvent("PLAYER_ALIVE") -- Only fire the first time at login.
    HeroicRaidReady:RefreshAchievementData()

    if (AreAllRaidsReady() == false) then
        -- Note: this still updates more frequently than I would like, but I can't find a specific enough event
        -- to either only fire when logging out (that also happens when achievement data is still available), or
        -- only when a boss dies and not everything else.
        -- todo Consider limiting this registration until after zoning into a raid instance, and then unregistering when leaving.
        addon:RegisterEvent("PLAYER_LEAVE_COMBAT", OnPlayerLeavingCombat)
    end
end

function addon:OnInitialize()
    HeroicRaidReady.db = LibStub("AceDB-3.0"):New("HeroicRaidReadyDB")
    HeroicRaidReady.db.factionrealm.character = HeroicRaidReady.db.factionrealm.character or {}
    HeroicRaidReady.db.factionrealm.character[UnitName("player")] =
        HeroicRaidReady.db.factionrealm.character[UnitName("player")] or {}
    HeroicRaidReady.selectedCharacter = UnitName("player")
end

function addon:OnEnable()
    HeroicRaidReady.frame = HeroicRaidReady:CreateReadinessFrame();
    addon:RegisterEvent("PLAYER_ALIVE", OnPlayerAlive) -- Note: this only fires on login, not from reloading the UI.
end
