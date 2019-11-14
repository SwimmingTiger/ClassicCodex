ClassicCodex [![Build Status](https://travis-ci.com/SwimmingTiger/ClassicCodex.svg)](https://travis-ci.com/SwimmingTiger/ClassicCodex)
===================

This is a partial rewrite of pfQuest/ShaguDB. It is an addon to show you where you can pickup quests, where to turn in quests, where to find mobs / items required for quests, etc.

Features
--------

* Display available quests on your map and minimap
* Display active quests on your map and minimap
* Display spawn markers on your map and minimap that show exact spawn locations for mobs/npcs/objects needed for your quests
* Updated tooltips to display quest progress when hovering over mobs/npcs/objects
* Auto-accept quests (can be disabled by holding control)
* Auto-turnin quests (can be disabled by holding control)
* Quest icon above enemy nameplates that are required for your quests
* Shift-clicking markers on the map will hide them
* Be careful while shift-clicking quest markers as it will mark them as "done" and they will not show up anymore for that character
* Clicking spawn markers on the map will change the color of the markers
* Questlog buttons to show/hide/reset markers
* Database Browser window to search for items/npcs/quests/objects.
* Chat commands


Configurations
--------------

* Toggle auto-accept
* Toggle auto-turnin
* Toggle quest icon above enemy nameplates
* Toggle showing questgivers
* Toggle showing questgives for active quests
* Show/hide low-level quests
* Show/hide high-level quests
* Show/hide seasonal quests
* Color spawn markers by spawn type or by quest
* Adjust the size of quest markers (pickup / turnin)
* Adjust the size of spawn markers
* Control what to display on your map/minimap
* Show all quests?
* Show only tracked quests?
* Only show things manually added
* Hide everything


Chat Commands
-------------
Accessed through /codex

* /codex show: Show database browser interface
* /codex unit &lt;unit&gt;: Search for an npc/mob by name and display best location on map
* /codex object &lt;gameObject&gt;: Seach for an object by name and display location on map (ex: /codex object copper vein)
* /codex item &lt;item&gt;: Search for an item and display location of mobs that drop it
* /codex vendor &lt;item&gt;: Search for an item and display location of vendors that sell it
* /codex quest &lt;questName&gt;: Search for a specific quest by name
* /codex quests: Show all quests on the map
* /codex meta &lt;relation&gt; &lt;min&gt; &lt;max&gt;: Search for objects with relations on the map (ex: /codex meta mines 50 175 will display ores mineable with from skill 50 to 175 in mining)
* Available relations: chests, herbs, mines
* /codex clean: Clean the map
* /codex reset: Reset the map and display only current quests
* /codex &lt;something&gt;: Will attempt to search through the database browser
