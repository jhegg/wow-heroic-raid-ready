local addonName, _ = ...

local function GetMapName(worldMapAreaId, uiMapId)
  return GetMapNameByID and GetMapNameByID(worldMapAreaId) or C_Map.GetMapInfo(uiMapId).name
end

HeroicRaidReady = {
    name = addonName,
    version = GetAddOnMetadata(addonName, "Version"),
    author = GetAddOnMetadata(addonName, "Author"),
    requiredAchievements = {
        -- Expansion: Wrath of the Lich King
        -- We found out that you must do 25N to do 25H, and 10N to do 10H; they are separate lockouts.
        {achievementId = 4530, mapName = GetMapName(604, 186)}, -- Icecrown Citadel 10: The Frozen Throne
        {achievementId = 4597, mapName = GetMapName(604, 186)}, -- Icecrown Citadel 25: The Frozen Throne

        -- Expansion: Cataclysm
        {achievementId = 4842, mapName = nil}, -- Blackwing Descent
        {achievementId = 4850, mapName = nil}, -- Bastion of Twilight
        {achievementId = 4851, mapName = nil}, -- Throne of the Four Winds
        {achievementId = 5802, mapName = nil}, -- Firelands
        {achievementId = 6177, mapName = GetMapName(824, 409)}, -- Dragon Soul: Destroyer's End

        -- Expansion: Mists of Pandaria
        {statisticId10 = 6799, statisticId25 = 7926, mapName = GetMapName(896, 471)}, -- Mogu'shan Vaults: Will of the Emperor
        {statisticId10 = 6811, statisticId25 = 7963, mapName = GetMapName(897, 474)}, -- Heart of Fear: Grand Empress Shek'zeer
        {statisticId10 = 6819, statisticId25 = 7971, mapName = GetMapName(886, 456)}, -- Terrace of Endless Spring: Sha of Fear
        -- Throne of Thunder - is not locked
        -- Siege of Orgrimmar - is not locked

        -- Expansion: Warlords of Draenor
        -- Highmaul - Mythic is locked, Heroic is not. Not sure how to determine a clear of Normal or Heroic yet.
        -- Blackrock Foundry - Unsure on lockout status.
    },
    frame = {},
    ITEM_HEIGHT,
    selectedCharacter,
    numberOfAchievements,
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

local function TableLength(T)
    local count = 0
    for _ in pairs(T) do
        count = count + 1
    end
    return count
end

HeroicRaidReady.numberOfAchievements = TableLength(HeroicRaidReady.requiredAchievements)

function HeroicRaidReady:GetCharacterNamesFromDb()
    local names = {}
    local numberOfNames = 0
    for characterName in pairs(HeroicRaidReady.db.factionrealm.character) do
        numberOfNames = numberOfNames + 1
        names[numberOfNames] = characterName
    end
    return names, numberOfNames
end

function HeroicRaidReady:GetRaidInformation(raid)
    if (raid.achievementId) then
        local _, achievementName, _, _, _, _, _, _, _, _, _, _, wasEarnedByMe, _ = GetAchievementInfo(raid.achievementId)
        if (raid.mapName and raid.achievementId) then
            return raid.mapName.." - "..achievementName, wasEarnedByMe
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
            return raid.mapName, true
        else
            return raid.mapName, false
        end
    end
end

function HeroicRaidReady:RefreshAchievementData()
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
