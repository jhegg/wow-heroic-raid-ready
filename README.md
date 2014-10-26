HeroicRaidReady
=====================

A World of Warcraft addon that indicates whether your character is ready for specific Heroic difficulty raids.

## What does it do?

HeroicRaidReady checks whether you have completed the achievements required to enter Heroic difficulty raids. 
Note that only certain raids have entrance restrictions. The raids that are currently tracked are:

* Wrath of the Lich King
  * ICC 10/25
    * The Frozen Throne (technically just the Lich King)
* Cataclysm
  * Blackwing Descent
  * The Bastion of Twilight
  * Throne of the Four Winds
  * Firelands
  * Dragon Soul
    * Destroyer's End
* Mists of Pandaria
  * Mogu'Shan Vaults
    * Part 2 - The Vault of Mysteries (technically just Will of the Emperor)
  * Heart of Fear
    * Part 2 - Nightmare of Shek'zeer (technically just Grand Empress Shek'zeer)
  * Terrace of Endless Spring

## How do I use it?

Use the slash command /heroicrr or /heroicraidready, and the addon will display which Heroic raids are ready
(or not ready). Or, if you have a LibDataBroker-enabled addon such as TitanPanel or Bazooka, a clickable icon
should show up on the panel/bar.

## Why would I use this?

If you have several alts, you may not know which of those characters are able to enter ICC 25H, for example, without
attempting to zone in. Or, you might know that such a raid requires a certain achievement, but not remember which
specific achievement. This addon allows you to quickly and easily check your Heroic Raid Ready status.

## Language Support

The addon should theoretically work with non-English game clients, but it has not been tested. It uses
achievement IDs and map IDs to get the raid names, so those should be translated automatically, although the 
'Ready!' and 'Not Ready' text is not currently translated.

## Where can I download official releases of this addon?

* [WoWInterface](http://www.wowinterface.com/downloads/info23231-HeroicRaidReady.html)
* [Curse](http://www.curse.com/addons/wow/heroicraidready/)
* [GitHub (development site)](https://github.com/jhegg/wow-heroic-raid-ready/)
