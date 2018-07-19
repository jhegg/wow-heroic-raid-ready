local function OnMouseDown(_,_)
    HeroicRaidReady.frame:StartMoving();
end

local function OnMouseUp(_,_)
    HeroicRaidReady.frame:StopMovingOrSizing();
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

    UIDropDownMenu_Initialize(frame.dropDown, function(_, level, _)
        local info = UIDropDownMenu_CreateInfo()
        local names, _ = HeroicRaidReady:GetCharacterNamesFromDb()
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
    local frame = CreateFrame("Frame", "HeroicRaidReadyMainFrame", UIParent);
    table.insert(UISpecialFrames, "HeroicRaidReadyMainFrame") -- Allow the frame to be closed by the ESC key.
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
    HeroicRaidReady.ITEM_HEIGHT = (frame.outline:GetHeight() - 16) / HeroicRaidReady.numberOfAchievements - 1;
    return frame.outline;
end

function HeroicRaidReady:CreateRootFrame(frame)
    frame.rootFrame = CreateFrame("Frame",nil,frame);
    frame.rootFrame:SetHeight(20);
    frame.rootFrame:SetPoint("LEFT",frame.root);
    frame.rootFrame:SetPoint("RIGHT",frame.root);
    frame.rootFrame:EnableMouse(1);
    frame.rootFrame:SetScript("OnLeave",function(_) GameTooltip:Hide(); end);
    frame.rootFrame:SetScript("OnEnter",RootFrame_OnEnter);
    frame.rootFrame:SetScript("OnMouseDown",OnMouseDown);
    frame.rootFrame:SetScript("OnMouseUp",OnMouseUp);
    return frame.rootFrame;
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
    for i=1, HeroicRaidReady.numberOfAchievements do
        entries[i] = HeroicRaidReady:CreateEntryFrame(frame,entries,i)
    end
    return entries;
end

function HeroicRaidReady:UpdateEntries()
    -- Requires the achievement data to be populated
    local characterData = HeroicRaidReady.db.factionrealm.character[HeroicRaidReady.selectedCharacter]
    for i=1, HeroicRaidReady.numberOfAchievements do
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
