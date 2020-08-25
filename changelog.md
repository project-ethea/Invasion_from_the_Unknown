Invasion from the Unknown - Changelog
=====================================

Version 2.1.8+dev:
------------------
* S13 - Face Your Fate:
  * Fixed incorrect references to the western keep in prose and code.


Version 2.1.8:
--------------
* General:
  * Update to Naia 20200816.


Version 2.1.7:
--------------
* General:
  * Update to Naia 20200814.


Version 2.1.6:
--------------
* General:
  * Update to Naia 20200810.

* Language and i18n:
  * Updated translations: Russian.

* Scenarios:
  * Removed no-op `recruitment_ignore_bad_combat` AI aspect.
  * S24 - Epilogue:
    * Record hero units' final stats.


Version 2.1.5:
--------------
* General:
  * Update to Naia 20200808.
  * Replaced instances of `[unit] placement=` deprecated in 1.14 with newer
    syntax.

* Language and i18n:
  * Updated translations: Russian.

* Scenarios:
  * Updated maps for the following scenarios to use (or not use) the sconce
    terrain overlay instead of the Lit Stone Wall terrain deprecated in 1.16:
    S7, S21, S22A, S23B.
  * S8 - Errand of Hope:
    * Fixed the poisonous bow animation using the unit's original baseframe
      even after leveling up (issue #69).
  * S14 - Bye and Behold:
    * Fixed "turns run out" not being listed as a loss condition.
  * S15 - Shadows of Time:
    * Fixed "turns run out" not being listed as a loss condition.
  * S23Bx/S23By - Do Us Part:
    * Merged scenarios (issue #66).
    * Minor UI and scripting refinements.


Version 2.1.4.1:
----------------
* General:
  * Update to Naia 20200724.1.

* Language and i18n:
  * Updated translations: Russian (complete).


Version 2.1.4:
--------------
* General:
  * Update to Naia 20200724.
  * Replaced deprecated Lua API calls.
  * Made first-time character introductions prompt replay-safe.

* Scenarios:
  * Cosmetic changes to the maps for the following scenarios: S1, S2, S3, S4,
    S5a, S5b, S6, S7, S8, S8x, S9, S10, S10x, S11, S12, S13, S14, S15, S16,
    S17, S19, S19x, S20, S21, S22B, S14x, S14z.
  * S23A - Into the Lair:
    * Added snowfall effect to the starting area.
  * S24 - Epilogue:
    * Minor UI tweaks.


Version 2.1.3:
--------------
* General:
  * Update to Naia 20200625.
  * Fixed OOS errors caused by Naia's cutscene skip functionality, first
    introduced in version 2.1.1.

* Scenarios:
  * Added a hint to all scenarios about browsing through unit AMLAs. This is
    only displayed once per save and it is triggered by Anlindë reaching level
    4 for the first time, or by Elynia existing on the game map.


Version 2.1.2:
--------------
* General:
  * Update to Naia 20200621.
  * Updated art licenses for CC BY-NC-ND 4.0, CC BY-SA 4.0 and CC0 content.

* Graphics:
  * New or updated unit graphics: Anlindë Elvish Avatar.

* Language and i18n:
  * Updated translations: French (Naia only), Russian (complete).

* Music:
  * Added Telaron's Climactic Contemplation and Western_Theme2 to IftU Music
    0.3.2.

* Scenarios:
  * S2 - A Real Confrontation:
    * Don't scroll back to Lédinor when he remarks on the newly recruited demon
      (fixes #64)
  * S7 - Goliath:
    * Made it more practical to find and obtain the Void Armor item.
  * S10 - The Source of Light:
    * Fixed Berserker Potion increasing the unit's HP pool without increasing
      its current HP as well.
  * S16 - Dawn of War
    * Properly displayed gold carryover bonus in the objectives after defeating
      enemies (fixes #50).
  * S19 - Under the Sands
    * Clarified objectives (fixes #52).

* Units:
  * Chaos Cardinal migrated to Naia and expanded with a new baseframe by VYNLT
    and slightly different stats over the mainline Ancient Lich.
  * Use 1.14 rodent fangs icon for the Rabbit's incisors attack.
  * Chaos Hound line is now considered part of the wolves race and receives
    names and traits accordingly.
  * Implemented a more elegant way to disable Enchantress advancement to Sylph
    (fixes #38).
  * Terror ability no longer affects same-level units.


Version 2.1.1:
--------------
* General:
  * Update to Naia 20180722.

* Units:
  * Revised Elvish Avatar (Anlindë)'s AMLA tree:
    * XP increase for all AMLAs is 15%.
  * Revised Lady of Light (Elynia)'s AMLA tree:
    * XP increase for all AMLAs is 15%.
    * Base XP decreased from 90 XP to 70 XP.
    * Strength I: HP +4, melee dmg +1.
    * Strength II: HP +4, melee str +1.
    * Strength III: HP +5.
    * Strength IV: HP +5, melee dmg +1.
    * Strength V: HP +7.
    * Focus I: faerie fire dmg +1, requires Strength I.
    * Focus II: faerie fire str +1, requires Strength III.
    * Focus III: ensnare str +1, requires Strength IV.
    * Shielding I: arcane res +10%, requires Focus I.
    * Shielding II: arcane res +10%, impact res +10%, requires Focus II.
    * Shielding III: arcane res +10%, cold res +10%, requires Strength IV.
    * Thorns I: new attack - ranged pierce magical+drain 10-2.
    * Thorns II: thorns str +1.
    * Thorns III: thorns dmg +2.


Version 2.1.0:
--------------
* General:
  * Wesnoth 1.14 support implememented, raising the minimum version requirement
    to Wesnoth 1.13.12 (Wesnoth 1.15.x is *not* supported yet). Some large
    chunks of code (in particular FOREACH loops) were rewritten in the
    process.
  * Shared units, assets, code, and translations are now part of the Naia
    library, also used by AtS version 0.10.0 and later.

* Language and i18n:
  * Removed empty Dutch translation.

* Music:
  * Added Aleksi's gameplay06.ogg to IftU Music 0.3.1.

* Scenarios:
  * General:
    * Revised a few maps to use 1.14 terrains.
    * The old IftU/AtS gates have been replaced with the new mainline gates.
      Special event gates are now recolored mainline rusty gates. While the
      open version does exist, it's not currently used since event gates are
      handled as barriers that get completely removed by scenarios.
    * Added wall moss overlays from Naia/AtS to hive maps.
    * Unit loyalty in boss/finale scenarios is now controlled using temporary
      or permanent [object] modifications instead of direct attribute
      manipulation, as the latter causes issues in 1.14. The same applies to
      the hidden loyal trait for special characters such as Mal Keshar,
      Anlindë, and Elynia (issue #27).
  * S2 - A Real Confrontation:
    * Lédinor's supporter now starts with 0 moves and outside his castle (see
      issue #29).
  * S7 - Goliath:
    * Removed demon embedded in a wall (issue #36).
    * Kill all Automaton-line units at the same time at the end (issue #36).
  * S10 - The Source of Light:
    * Disallow IftU's special brand of Elvish Enchantress from using the
      Berserker Potion, for what little good it does.
  * S13 - Face Your Fate:
    * Dwarvish Ulfserkers can no longer be recruited once the Warlord arrives
      (issue #44).
  * S20 - The Heart:
    * Unhide side 6 as its leader arrives to the battlefield after turn 1
      (issue #54).
  * S23A - Into the Lair:
    * Now using Aleksi's gameplay06.ogg as the initial track.
  * S23B - Until Death:
    * Using mainline's frantic.ogg during the last part of stage 1.
    * Fixed issues with team color ellipses when Galas gets possessed during
      stage 1 (issue #60).
  * S24 - Epilogue:
    * Minor music and UI tweaks.

* Units:
  * Balancing:
    * Elynia's Thorns I base damage increased by 1 (9-3), Thorns II increase by
      2 instead of 1 (fully upgraded total is now 11-3).
  * Synced descriptions with AtS for a few units that were somehow not already
    synced between IftU 2.0.1 and AtS 0.9.17+.
  * Fixed female Elvish Civilian making male sounds when hit (not killed).
  * Staff-wielding units use the new staff sounds in 1.14.


Version 2.0.1:
--------------
* Graphics:
  * New or updated unit graphics: Faerie Forest Spirit, Elvish Ascetic, Elvish
    Mystic.

* Scenarios:
  * S3 - Memories from the Depths:
    * Keep Mal Keshar's current facing when transferring him at the end of the
      scenario.
  * S5b - Cursed Plateau:
    * Increased turn limit.
    * Remove gold piles when acquired.
  * S14 - Bye and Behold:
    * Increased enemy gold.
  * S21 - Innuendo:
    * Increased turn limit.
  * S22B - The Dark Hive:
    * Replaced the beginning of a pivotal line by Elynia with a rephrased
      version provided by vultraz.
  * S23A - Into the Lair:
    * Increased turn limit.
  * S23B - Until Death:
    * Decreased base HP for the boss from 217 to 208.
    * Shifted boss guards around to delay them engaging in combat with player
      units.
    * The boss can now only recruit up to one Goliath on Hard instead of two.
    * Possessed units regenerate less health.
    * Reduced frequency of Psy Crawler spawns.
    * The boss can only spawn Shaxthal Worms when hit during the last stage on
      Easy difficulty. Also reduced the chance for spawns on all difficulties.
    * The boss can no longer remove negative effects (which is to say, the
      slowed effect) while absorbing damage during the second stage of the
      boss fight. The justification is that this boss does not have the same
      physical prowess as the Chaos Warlord.

* Units:
  * Reworked description and WML for the Intimidates ability granted by the
    special Shardia's Meteor item from S5b.
  * Elvish Avatar (Anlindë) now has AMLAs:
    * Add drains special to melee attack (+25% XP)
    * Increase gossamer strikes by 1 (+25% XP)
  * Redone Lady of Light (Elynia) AMLA tree:
    * Strength I: +5 HP (+25% XP)
      * Thorns I: 8-3 ranged pierce, magical (+25% XP)
    * Strength II: melee damage +1 (+25% XP)
      * Focus I: faerie fire damage +1 (+35% XP)
      * Thorns II: thorns damage +1, drains (+35% XP)
    * Strength III: melee strikes +1 (+25% XP)
      * Focus II: faerie fire strikes +1 (+40% XP)
    * Strength IV: +10 HP, melee damage +1 (+30% XP)
      * Focus III: ensnare strikes +1 (+40% XP)
    * Shielding I: +10% arcane resistance (+30% XP), requires both Focus I and
      Strength III
    * Shielding II: +20% arcane resistance (+50% XP), requires Focus II
  * Removed Thorns attack from the unit type used for Elynia after S23B.
  * Increased base Shaxthal resistances to arcane from -20% to -10%.
  * Increased Chaos Warlord's resistances to arcane from -10% to 0%.
  * Shadow Spawn resistances changed and HP reduced from 29 to 26:
    * Blade/pierce/impact 50% -> 20%
    * Fire 10% -> -20%
    * Cold 70% -> 50%
  * Fixed a cutscene unit type used for Anlindë being always visible in the
    help browser and unit tree.
  * New unit type descriptions: Chaos Cataphract, Hound of Chaos, Demonic
    Hound, Hellhound.
  * Made it so the full list of advancements for the Elvish Civilian display
    in the help browser/unit tree instead of only the male advancements.
  * Rabbits can no longer move into village tiles.


Version 2.0.0:
--------------
* Scenarios:
  * S21 - Innuendo:
    * Minor balancing changes.
  * 22A - Face of the Enemy:
    * Lift shroud prior to highlighting the exit gate during the boss fight.

* Units:
  * New unit type descriptions
    * Shaxthal Assault Drone, Minor Imp, Imp, Blood Imp, Gutwrencher Imp,
      Armageddon Imp, Skeleton Rider (taken from Liberty), Bone Knight.


Version 1.99.8 (codename Reconstruction RC 9):
----------------------------------------------
* Scenarios:
  * Rolled back change from versions 1.99.3 and 1.99.5 that causes auto-recalls
    to become loyal for the remainder of the campaign due to an engine bug in
    the implementation of [object] duration=scenario with certain effects. This
    causes auto-recalls to cost upkeep again in scenarios 2, 3, 4, 5a, 5b, 6,
    8, and 10.
  * S21 - Innuendo:
    * Cleaner (but functionally-equivalent) fix for the SLF issue fixed
      in RC 8.


Version 1.99.7 (codename Reconstruction RC 8):
----------------------------------------------
* Scenarios:
  * S14 - Bye and Behold:
    * Fixed incorrect secondary damage amount in the Explosive Runic Arrows'
      description (50% instead of the actual 80%).
  * S15 - Shadows of Time:
    * Fixed typo in prose.
  * S21 - Innuendo:
    * Make sure the Shaxthal Sentry Drone miniboss doesn't run off to the
      nearest keep.
    * Fix an inexplicable issue where a radial SLF gets doubled when [or]'d,
      resulting in the first chamber near the starting area being matched by
      a late event trigger filter.

* Units:
  * New unit type descriptions:
    * Shaxthal Sentry Drone.
  * Fixed typo in the Chaos Invoker's description.


Version 1.99.6 (codename Reconstruction RC 7):
----------------------------------------------
* Scenarios:
  * S22A - Face of the Enemy:
    * Fixed boss escape countdown in Objectives not updating at the start of
      every turn.
  * S23C - Broken Heart:
    * Added a "Checkpont cleared" alert when clearing checkpoints.

* Units:
  * Balancing:
    * Increased base Union damage from 28-3 to 29-3.
  * New unit type descriptions:
    * Faerie Sprite, Fire Faerie, Faerie Dryad, Faerie Forest Spirit,
      Shaxthal Rayblade.
    * Merged Orcish Nightblade unit description from mainline Wesnoth 1.13.2.
  * Minor tweaks to unit type descriptions:
    * Shaxthal Drone.


Version 1.99.5 (codename Reconstruction RC 6):
----------------------------------------------
* Graphics:
  * New or improved unit animations: Elynia (ranged attack, defense).

* Scenarios:
  * S2 - A Real Confrontation:
    * Forbid Lédinor from abandoning his keep to do something stupid.
  * S7 - Goliath:
    * Force the enemy boss to engage the player by enabling the
      leader_ignores_keep aspect.
  * S9 - The Library:
    * Minor map layout tweaks.
  * S10 - The Source of Light:
    * Auto-recalled units no longer require upkeep for this scenario.
    * Minor map layout tweaks.
  * S13 - Face your Fate:
    * Minor gold tweaks.
  * S14 - Bye and Behold:
    * Mudcrawlers and Water Serpents are not supposed to speak when encountered
      by the player.
  * S19 - Under the Sands:
    * Minor prose tweaks.
  * S20 - The Heart:
    * Minor prose tweaks.
  * S21 - Innuendo:
    * Minor prose tweaks.
  * S22A - Face of the Enemy:
    * Minor prose tweaks.
  * S22B - Dark Hive:
    * Minor prose tweaks.
  * S23A - Into the Lair:
    * Minor prose tweaks.
  * S23B - Until Death:
    * Minor prose tweaks.
  * S23Bx/S23By - Do Us Part:
    * Major prose changes by vultraz.

* Units:
  * New unit type descriptions:
    * Chaos Emperor, Chaos Warlord, Chaos Hound, Demonic Hound, Hellhound,
      Chaos Longbowman, Chaos Heavy Longbowman, Chaos Cavalier, Chaos
      Cataphract, Shadow Minion, Fungoid, Rabbit.
  * Removed E2 Shaxthal Drone variation formerly used in S7 and S9 in versions
    prior to Reconstruction RC 1.


Version 1.99.4 (codename Reconstruction RC 5):
----------------------------------------------
* Graphics:
  * New or updated unit graphics: Chaos Headhunter, Chaos Marauder, Chaos
    Soulhunter.

* Scenarios:
  * S2 - A Real Confrontation:
    * Negligible dialogue tweaks.
  * S8 - Errand of Hope:
    * Clear Althurin's statuses at the end if necessary, so that he does not
      reappear poisoned or slowed in the subsequent cutscene scenario.
  * S23B - Until Death:
    * Make the final boss able to spawn units when damaged during stage 3
      (accidentally disabled in RC 1).
    * Decreased amount of damage regenerated by the final boss when killed by
      the wrong unit during stage 3.
    * Fix Mal Keshar potentially appearing embedded in a wall in stage 3.

* Units:
  * New unit type descriptions:
    * Chaos Arbalestier, Chaos Crossbowman, Chaos Invader, Chaos Bowman, Chaos
      Raider, Chaos Headhunter, Chaos Doom Guard, Chaos Hell Guardian, Chaos
      Dark Knight, Chaos Razerman, Chaos Overlord, Shaxthal Drone, Lady of
      Light, Chaos Invoker, Chaos Magus, Sylvan Warden, Chaos Lorekeeper, Chaos
      Marauder, Chaos Soulhunter.


Version 1.99.3 (codename Reconstruction RC 4):
----------------------------------------------
* Scenarios:
  * Fixed a few typos reported on the forum thread.
  * Auto-recalled speaking units in scenarios 2, 3, 4, 5a/5b, 6 and 8 no longer
    require upkeep for the duration of the scenario in which they were
    auto-recalled.
  * S1 - Border Patrol:
    * Fixed late objectives claiming there is no early finish bonus.
  * S4 - Over the Sands:
    * Re-enabled option to advance to S5b.
  * S5b - Cursed Plateau:
    * Revised scenario.
  * S6 - The Moon Valley:
    * Disabled two unnecessary mid-battle dialogue events.
  * S7 - Goliath:
    * Very minor balancing changes to the boss fight.
  * S10 - The Source of Light:
    * Fixed objectives claiming there is an early finish bonus.
  * S11 - Strike on Herthgar:
    * Removed gold carryover and bonus carryover for this scenario, and changed
      the bonus objective to be a bonusless alternative instead.
  * S12 - The Escape:
    * Adjusted initial settings to permit the most inefficient recruitment
      pattern even without gold carryover from S11.
  * S13 - Face your Fate:
    * Ensured there isn't any gold carried over to S14.
  * S23B - Until Death:
    * Balancing changes to make the fight slightly less of an uphill battle.

* Units:
  * New unit type descriptions:
    * Chaos Arbalestier, Chaos Crossbowman, Chaos Invader.


Version 1.99.2 (codename Reconstruction RC 3):
----------------------------------------------
* Scenarios:
  * Fixed boss AI engine breaking when AtS is not installed.
  * Changed the savegame prefix for both episodes to "IftU", dropping the
    episode number since it's effectively meaningless in practice.
  * S7 - Goliath:
    * Removed all healing glyphs.
  * S14 - Bye and Behold:
    * Added a bare-bones attack animation to the Explosive Arrows item
      (issue #17).


Version 1.99.1 (codename Reconstruction RC 2):
----------------------------------------------
* Scenarios:
  * Removed redundant "(Bonus)" annotation for some objectives in S9, S11, and
    S16.
  * S2 - A Real Confrontation:
    * Fixed pre-captured elven villages not being counted for the scenario
      defeat condition.
  * S3 - Memories from the Depths:
    * Fixed Mal Keshar not speaking one of his lines.
  * S20 - The Heart:
    * Fixed alternate victory by defeating all enemy leaders never triggering
      without using cheats.
  * S21 - Innuendo:
    * Increased turn limit.
  * S23A - Into the Lair:
    * Added a somewhat more elaborate initial sound transition.
  * S23B - Until Death:
    * Fixed an oversight so that player recruits no longer require upkeep.

* Terrains:
  * Ported gate fix from AtS 0.9.1 meant to solve clipping issues for gates
    adjacent to (convex) stone wall corners.

* Units:
  * Door units now clear terrain beneath them on 'last breath' rather than
    'die' events, in order to ensure shroud is correctly cleared before
    scenario-specific event handlers are run.
  * Replaced Chaos Crossbowman and Arbalestier's sword attack with an axe to
    match the sprites.


Version 1.99.0 (codename Reconstruction RC 1):
----------------------------------------------
* General:
  * Raised minimum Wesnoth version requirement from 1.9.10 to 1.12.0.
  * Removed remaining code implementing/referencing the glamour ability.
  * Removed code for story maps that's gone unused for who knows how many years
    due to the campaign's chronic lack of proper story map artwork.
  * Many changes are missing in this changelog, either because they were
    forgotten or because they constitute spoilers.

* Graphics:
  * New or updated terrain graphics: Dark Hive, Dark Hive Surface, Dark Hive
    Depths.
  * New or improved unit animations: Elynia (melee).
  * New or updated unit graphics: Anlindë, Chaos Arbalestier, Chaos Warlord,
    Demon, Demon Zephyr, Demon Grunt, Demon Warrior, Sprite, Fire Faerie,
    Forest Spirit, Dryad, Rabbit, Chaos Emperor.

* Music:
  * All music tracks have been moved to a separate add-on, named "IftU Music".
    This add-on is now an optional dependency for those who can't afford
    downloading it or don't play with music enabled. When absent, the IftU
    campaign menu entries for each episode will include a notice stating so.

* Scenarios:
  * Rewritten or revised all scenarios, including maps. As a result, there are
    too many changes that will not be listed here.
  * Fixed several instances of sighted events taking place prematurely on
    Wesnoth 1.11.x.
  * S2 - A Real Confrontation:
    * Removed Sprites from the player's recruit list.
  * S3 - Memories from the Depths:
    * The Ring of Swiftness now increases movement points by one instead of two.
  * S4 - Over the Sands:
    * Removed Ghouls and Elvish Warrior Spirits from the player's recruit list.
  * S14 - Bye and Behold:
    * Sprites are now added to the player's recruit list here instead of S2.

* Units:
  * Walking Corpses no longer can advance to Ghouls.
  * Elynia's alternate AMLAs heal her.
  * Imps are now immune to the plague weapon special.
  * Removed units:
    * Tiger
    * Verlissh Prong Bug
    * Verlissh Spearbearer line
    * Steppe Orcs faction
    * Aragwaith Peasant
    * Dwarvish Gyrocopter and Dwarvish Steamcopter
  * Renamed Chaos Advanced Crossbowman to Chaos Arbalestier.
  * Renamed Errant Spirit to Errant Soul.
  * Balancing:
    * The Protection ability affects own units of any lower level again instead
      of only level 0 and 1.
    * Granted the new 'precision' weapon special to the Greatbow's ranged
      attack.
    * Increased Psy Mindraider's HP from 58 to 59.
    * Gave feeding ability to Psy Mindraider.
    * Decreased Demon Zephyr's movement cost on deep water terrains from 2 to 1.
    * Decreased Demon Zephyr's movement cost on unwalkable terrains from 3 to 1.
    * Increased arcane damage resistance for most Shaxthal units from -50% to
      -20%.
    * Decreased Shaxthal elusivefoot defense on Deep Water from 20% to 10%
      (Shaxthal Rayblade, Shaxthal Stormblade, Elyssa).
    * Increased Errant Soul's ranged attack strength from 2-1 to 2-2.
    * Changed Leech's alignment from 'lawful' to 'neutral'.
    * Decreased Leech's HP from 62 to 42.
    * Decreased Leech's melee damage from 11-2 to 9-2.
    * Decreased Leech's unit level from 3 to 1.
    * Disabled Elvish Sylph advancement from Elvish Enchantress.
    * Elvish Trapper has skirmisher instead of ambush again.
    * Increased arcane resistance for mechanical units (Worker Droid,
      Automaton, Iron Golem, Goliath) from 30% to 50%.
    * Increased Elynia's resistance to impact damage from -10% to 0%.
    * Decreased the Chaos Emperor's max moves from 6 to 5.
    * Removed skirmisher ability from the Chaos Emperor.
  * Applied changes from bumbadadabum's "The Aragwaithi" add-on, versions 1.0.6
    through 1.0.9, and "Era of Chaos" version 1.3.1+dev up to commit
    9dedeba7cddc2a027745c9994a917fdcb78ed341:
    * Archer HP increased from 26 to 28.
    * Granted the new 'precision' weapon special to the Greatbow's ranged
      attack.
    * Increased Guard's blade resistance from 10% to 20%.
    * Increased Guard's XP from 64 to 74.
    * Decreased Guard's cost from 28 to 27.
    * Decreased Pikeman's cost from 38 to 28.
    * Increased Shield Guard's cost from 37 to 45.
    * Increased Shield Guard's blade and pierce resistances from 10% to 20%.
    * Granted the 'marksman' weapon special to the Swordsmaster.
    * Renamed the Aragwaith Witch's image files.
  * Fixed Chaos Arbalestier ranged attack animation failing to trigger.
  * Fixed unit types with missing faction prefixes in their names:
    * Arbalestier -> Chaos Arbalestier
    * Cataphract -> Chaos Cataphract
    * Crossbowman -> Chaos Crossbowman
    * Heavy Longbowman -> Chaos Heavy Longbowman
  * Fixed multiple "Descriptions should no longer include the name as the first
    line" warnings on 1.11.1 and later.
  * Fixed "Terrain '**' has evaluated to 100 (cost) [...]" warnings on Wesnoth
    1.11.x caused by Aragwaith units.
  * Replaced old bird NPC behavior code with the newer Lua-based implementation
    from AtS.
  * Removed help markup from the Sylvan Essence ability special notes to avoid
    issues in Pango contexts (e.g. sidebar tooltips).
  * Removed references to nonexistent image files in the defense animations for
    female Elvish Trapper and Elvish Prowler units.
  * Fixed recruited elvish units from scenario 4 onwards belonging to hidden
    unit types.
  * New unit type descriptions:
    * Demon, Demon Zephyr, Demon Grunt, Demon Warrior
    * Elvish Civilian
    * Elvish Hunter, Elvish Trapper, Elvish Prowler
    * Sylvan Warden
  * Fixed a minor inaccuracy at the beginning of the Terror ability
    description.
  * New or improved unit animations: multiple Aragwaith units.

* User interface:
  * Made sure cutscene theme with menu bar works on Wesnoth 1.11.5 and later
    (affecting S8x, S14xA, S14xB, S16x, S20x, S23By).
  * Cutscene themes now use the 1.11.10 [theme] id attribute on 1.11.10 and
    later.


; kate: indent-mode normal; encoding utf-8; space-indent on; word-wrap on;
; kate: indent-width 2;
