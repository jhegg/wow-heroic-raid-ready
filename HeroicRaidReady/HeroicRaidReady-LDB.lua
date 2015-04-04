local libDataBroker = LibStub:GetLibrary("LibDataBroker-1.1", true)
if not libDataBroker then return end

local ldb = libDataBroker:NewDataObject("HeroicRaidReady", {
    type = "launcher",
    icon = "Interface\\Icons\\Achievement_Dungeon_GloryoftheRaider",
    label = "HeroicRaidReady",
})

function ldb:OnClick(clickedFrame, button)
    if (HeroicRaidReady.frame:IsVisible()) then
        HeroicRaidReady.frame:Hide();
    else
        HeroicRaidReady:DisplayHeroicReadiness();
    end
end

function ldb:OnTooltipShow()
  self:AddLine(format("%s %s", HeroicRaidReady.name, HeroicRaidReady.version))
  self:AddLine("------------------------------")
  self:AddLine(UnitName("player"))
  local characterData = HeroicRaidReady.db.factionrealm.character[UnitName("player")]
  for raid = 1, HeroicRaidReady.numberOfAchievements do
    if characterData[raid].ready then
      self:AddLine(format("   |cFF00FF00%s - Ready!|r", characterData[raid].raidName))
    else
      self:AddLine(format("   |cFFFF0000%s - Not Ready|r", characterData[raid].raidName))
    end
  end
end
