-- functions and such from Neik's Library
require("resources")

-- Elites
if not modloader.checkFlag("mn_disable_elites") then 
	require("Elites/elites")
end

-- Enemies 
if not modloader.checkFlag("mn_disable_enemies") then 
	require("monsterLib")
	require("Enemies/enemies")
end

-- Stages 
if not modloader.checkFlag("mn_disable_stages") then 
	require("Stages/stages")
end

require("Misc.UI.UI")
require("qols")

if modloader.checkMod("LivelyWorld") then
	require("LivelyWorldSupport")
end
-- Survivors (none, yet)
