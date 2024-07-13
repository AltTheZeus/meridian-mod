local path = "Stages/resources/" 

require("Stages.resources.LivelyWorld.LivelyWorldSupport")

-- General --
Sprite.load("statues1", path.."statues1", 1, 0, 0)

--[[Desolate Forest
Sprite.load("resources/DesolateForest/Tile16DeadExpanded", "Stages/resources/DesolateForest/Tile16DeadExpanded", 1, 0, 0)

local DesolateForest = Stage.find("Desolate Forest", "Vanilla")

--Dried Lake
Sprite.load("resources/DriedLake/Tile16DryExpanded", "Stages/resources/DriedLake/Tile16DryExpanded", 1, 0, 0)

local DriedLake = Stage.find("Dried Lake", "Vanilla")
local r1_2_4 = require("Stages.resources.DriedLake.1_2_4")
local r1_2_5 = require("Stages.resources.DriedLake.1_2_5")
DriedLake.rooms:add(r1_2_4)
--DriedLake.rooms:add(r1_2_5)

--Sunken Tombs
Sprite.load("Stages/resources/SunkenTombs/Tile16WaterExpanded", 1, 0, 0)
Sprite.load("Stages/resources/SunkenTombs/WaterSky", 1, 0, 0)

local SunkenTombs = Stage.find("Sunken Tombs", "Vanilla")
local SunkenTombs1 = require("Stages.resources.SunkenTombs.sunkenTombs1")
local SunkenTombs2 = require("Stages.resources.SunkenTombs.sunkenTombs2")
SunkenTombs.rooms:add(SunkenTombs1)
SunkenTombs.rooms:add(SunkenTombs2)]]

-- Basalt Quarry --
Sprite.load("Tile16Basalt", path.."BasaltQuarry/tileset", 1, 0, 0)
Sprite.load("basaltSky", path.."BasaltQuarry/sky", 1, 0, 0)
Sprite.load("caveTopBasalt", path.."BasaltQuarry/caveTop", 1, 0, 0)
Sprite.load("duneBasalt", path.."BasaltQuarry/dune", 1, 0, 0)
Sprite.load("basaltMoon", path.."BasaltQuarry/moon", 1, 0, 0)
Sprite.load("BasaltClouds1", path.."BasaltQuarry/cloud1", 1, 0, 0)
Sprite.load("BasaltClouds2", path.."BasaltQuarry/cloud2", 1, 0, 0)
Sprite.load("BasaltClouds3", path.."BasaltQuarry/cloud3", 1, 0, 0)

local BasaltQuarry = require("Stages.resources.BasaltQuarry.stage")
Stage.progression[3]:add(BasaltQuarry)
local BasaltQuarryVar = require("Stages.resources.BasaltQuarry.variant")
BasaltQuarry.rooms:add(BasaltQuarryVar)

BasaltQuarry.music = Sound.load("musicBasaltQuarry", path.."Music/stageBasaltQuarry.ogg")

-- Starswept Valley --
Sprite.load("Tile16Star", path.."StarsweptValley/tileset", 1, 0, 0)
Sprite.load("Tile16StarBridge", path.."StarsweptValley/bridge", 1, 0, 0)
Sprite.load("SolarEclipse", path.."StarsweptValley/solarEclipse", 1, 0, 0)
Sprite.load("skyStar", path.."StarsweptValley/sky", 1, 0, 0)
Sprite.load("pillarsStar", path.."StarsweptValley/pillars", 1, 0, 0)
Sprite.load("valleyStar", path.."StarsweptValley/valley", 1, 0, 0)

local StarsweptValley = require("Stages.resources.StarsweptValley.stage")
Stage.progression[2]:add(StarsweptValley)
local StarsweptValleyVar = require("Stages.resources.StarsweptValley.variant")
StarsweptValley.rooms:add(StarsweptValleyVar)

StarsweptValley.music = Sound.load("musicStarsweptValley", path.."Music/stageStarsweptValley.ogg")
--[[
-- Desert Peaks --
Sprite.load("Tile16Desert", path.."DesertPeaks/tileset", 1, 0, 0)
Sprite.load("64Desert", path.."DesertPeaks/64Desert", 1, 0, 0)

local DesertPeaks = require("Stages.resources.DesertPeaks.stage")
Stage.progression[3]:add(DesertPeaks)
]]
-- Marshland Sanctuary --
Sprite.load("Tile16Marshland", path.."MarshlandSanctuary/tileset", 1, 0, 0)
Sprite.load("64Marshland", path.."MarshlandSanctuary/tilesetBG", 1, 0, 0)
Sprite.load("MarshlandPlanet", path.."MarshlandSanctuary/planet", 1, 0, 0)
Sprite.load("GreenSky", path.."MarshlandSanctuary/sky", 1, 0, 0)
Sprite.load("MarshlandBG1", path.."MarshlandSanctuary/bg1", 1, 0, 0)
Sprite.load("MarshlandBG2", path.."MarshlandSanctuary/bg2", 1, 0, 0)
Sprite.load("MarshlandClouds", path.."MarshlandSanctuary/clouds", 1, 0, 0)

--Objects
require("Stages.resources.Objects.Rain")

local MarshlandSanctuary = require("Stages.resources.MarshlandSanctuary.stage")
local MarshlandSanctuaryVariant = require("Stages.resources.MarshlandSanctuary.variant")
Stage.progression[4]:add(MarshlandSanctuary)
MarshlandSanctuary.rooms:add(MarshlandSanctuaryVariant)

MarshlandSanctuary.music = Sound.load("musicMarshlandSanctuary", path.."Music/stageMarshlandSanctuary.ogg")

-- Dissonant Reliquary --
Sprite.load("Tile16Reliquary", path.."DissonantReliquary/tileset", 1, 0, 0)
Sprite.load("HugePlanet", path.."DissonantReliquary/planet", 1, 0, 0)
Sprite.load("Reliquarysky", path.."DissonantReliquary/sky", 1, 0, 0)
Sprite.load("ReliquaryBG1", path.."DissonantReliquary/bg1", 1, 0, 0)
Sprite.load("ReliquaryBG2", path.."DissonantReliquary/bg2", 1, 0, 0)

local DissonantReliquary = require("Stages.resources.DissonantReliquary.stage")
Stage.progression[5]:add(DissonantReliquary)

DissonantReliquary.music = Sound.load("musicDissonantReliquary", path.."Music/stageDissonantReliquary.ogg")

-- Hive Savanna --
Sprite.load("bTile16Savannah", path.."HiveSavanna/tileset", 1, 0, 0)
Sprite.load("SavannaSky", path.."HiveSavanna/sky", 1, 0, 0)
Sprite.load("Planets_C1_2", path.."HiveSavanna/planet", 1, 0, 0)
Sprite.load("TempleHill", path.."HiveSavanna/bg1", 1, 0, 0)
Sprite.load("CloudsSavanna", path.."HiveSavanna/clouds", 1, 0, 0)

--Objects
require("Stages.resources.Objects.TempleSnow")

local HiveSavanna = require("Stages.resources.HiveSavanna.stage")
Stage.progression[1]:add(HiveSavanna)

HiveSavanna.music = Sound.load("musicHiveSavanna", path.."Music/stageHiveSavanna.ogg")

-- Shallow Rotlands --
--Sprites
Sprite.load("Tile16Rotland", path.."ShallowRotlands/tileset", 1, 0, 0)
Sprite.load("RotlandTrees64b", path.."ShallowRotlands/RotlandTrees64b", 1, 0, 0)
Sprite.load("DeepForest1", path.."ShallowRotlands/DeepForest1", 1, 0, 0)
Sprite.load("DeepForest2", path.."ShallowRotlands/DeepForest2", 1, 0, 0)
Sprite.load("DeepForest3", path.."ShallowRotlands/DeepForest3", 1, 0, 0)
Sprite.load("SRFill", path.."ShallowRotlands/fill", 1, 0, 0)
Sprite.load("ShallowTop", path.."ShallowRotlands/top", 1, 0, 0)
Sprite.load("ShallowValley", path.."ShallowRotlands/mountains", 1, 0, 0)
Sprite.load("Geysex", path.."ShallowRotlands/Geysex", 6, 13, 62)

--Rooms
local ShallowRotlands = require("Stages.resources.ShallowRotlands.stage")
local ShallowRotlandsVariant = require("Stages.resources.ShallowRotlands.variant")
ShallowRotlands.rooms:add(ShallowRotlandsVariant)

Stage.progression[3]:add(ShallowRotlands)

--Music
ShallowRotlands.music = Sound.load("musicShallowRotlands", path.."Music/stageShallowRotlands.ogg")
--[[
-- Poisonous Beach --
Sprite.load(path.."PoisonousBeach/tile16sulfur", 1, 0, 0)
Sprite.load(path.."PoisonousBeach/Sulfursky", 1, 0, 0)
Sprite.load(path.."PoisonousBeach/Sulfurdune", 1, 0, 0)
Sprite.load(path.."PoisonousBeach/SulfurClouds1", 1, 0, 0)
Sprite.load(path.."PoisonousBeach/SulfurClouds2", 1, 0, 0)
Sprite.load(path.."PoisonousBeach/SulfurPlanet", 1, 0, 0)

local PoisonousBeach = require("Stages.resources.PoisonousBeach.var1")
Stage.progression[3]:add(PoisonousBeach)
PoisonousBeach.displayName = "Poisonous Beach"
PoisonousBeach.music = Sound.load(path.."Music/musicPoisonousBeach.ogg")
]]

--Meridian Enemies

callback.register("postLoad", function()
	if not modloader.checkFlag("mn_disable_enemies") then
		local con1 = MonsterCard.find("con1", "meridian")
		local con2 = MonsterCard.find("con2", "meridian")
		local dog = MonsterCard.find("dog", "meridian")
		local giant = MonsterCard.find("giant", "meridian")
		local BC = MonsterCard.find("Basalt Crab", "meridian")

		--Shallow Rotlands
		ShallowRotlands.enemies:add(con1)

		--Marshland Sanctuary
		MarshlandSanctuary.enemies:add(con2)
		MarshlandSanctuary.enemies:add(con1)
		MarshlandSanctuary.enemies:add(giant)

		--Basalt Quarry
		BasaltQuarry.enemies:add(BC)
		BasaltQuarry.enemies:add(giant)

		--Dissonant Reliquary
		DissonantReliquary.enemies:add(giant)
		DissonantReliquary.enemies:add(dog)

		--Starswept Valley
		StarsweptValley.enemies:add(con1)
		StarsweptValley.enemies:add(giant)
		--print("MERIDIAN ENEMIES DETECTED!")
	end
end)