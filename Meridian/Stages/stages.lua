local path = "Stages/" 

-- General --
Sprite.load("statues1", path.."statues1", 1, 0, 0)

-- Basalt Quarry --
Sprite.load("Tile16Basalt", path.."BasaltQuarry/tileset", 1, 0, 0)
Sprite.load("basaltSky", path.."BasaltQuarry/sky", 1, 0, 0)
Sprite.load("caveTopBasalt", path.."BasaltQuarry/caveTop", 1, 0, 0)
Sprite.load("duneBasalt", path.."BasaltQuarry/dune", 1, 0, 0)
Sprite.load("basaltMoon", path.."BasaltQuarry/moon", 1, 0, 0)
Sprite.load("BasaltClouds1", path.."BasaltQuarry/cloud1", 1, 0, 0)
Sprite.load("BasaltClouds2", path.."BasaltQuarry/cloud2", 1, 0, 0)
Sprite.load("BasaltClouds3", path.."BasaltQuarry/cloud3", 1, 0, 0)

local BasaltQuarry = require("Stages.BasaltQuarry.stage")
Stage.progression[3]:add(BasaltQuarry)
local BasaltQuarryVar = require("Stages.BasaltQuarry.variant")
BasaltQuarry.rooms:add(BasaltQuarryVar)

BasaltQuarry.music = Sound.load("musicBasaltQuarry", "Misc/Music/stageBasaltQuarry.ogg")

-- Starswept Valley --
Sprite.load("Tile16Star", path.."StarsweptValley/tileset", 1, 0, 0)
Sprite.load("Tile16StarBridge", path.."StarsweptValley/bridge", 1, 0, 0)
Sprite.load("SolarEclipse", path.."StarsweptValley/solarEclipse", 1, 0, 0)
Sprite.load("skyStar", path.."StarsweptValley/sky", 1, 0, 0)
Sprite.load("pillarsStar", path.."StarsweptValley/pillars", 1, 0, 0)
Sprite.load("valleyStar", path.."StarsweptValley/valley", 1, 0, 0)

require("Misc.StageObjects.Stardust")

local StarsweptValley = require("Stages.StarsweptValley.stage")
Stage.progression[2]:add(StarsweptValley)
local StarsweptValleyVar = require("Stages.StarsweptValley.variant")
StarsweptValley.rooms:add(StarsweptValleyVar)

StarsweptValley.music = Sound.load("musicStarsweptValley", "Misc/Music/stageStarsweptValley.ogg")

-- Marshland Sanctuary --
Sprite.load("Tile16Marshland", path.."MarshlandSanctuary/tileset", 1, 0, 0)
Sprite.load("64Marshland", path.."MarshlandSanctuary/tilesetBG", 1, 0, 0)
Sprite.load("MarshlandPlanet", path.."MarshlandSanctuary/planet", 1, 0, 0)
Sprite.load("GreenSky", path.."MarshlandSanctuary/sky", 1, 0, 0)
Sprite.load("MarshlandBG1", path.."MarshlandSanctuary/bg1", 1, 0, 0)
Sprite.load("MarshlandBG2", path.."MarshlandSanctuary/bg2", 1, 0, 0)
Sprite.load("MarshlandClouds", path.."MarshlandSanctuary/clouds", 1, 0, 0)

--Objects
require("Misc.StageObjects.Rain")

local MarshlandSanctuary = require("Stages.MarshlandSanctuary.stage")
local MarshlandSanctuaryVariant = require("Stages.MarshlandSanctuary.variant")
Stage.progression[4]:add(MarshlandSanctuary)
MarshlandSanctuary.rooms:add(MarshlandSanctuaryVariant)

MarshlandSanctuary.music = Sound.load("musicMarshlandSanctuary", "Misc/Music/stageMarshlandSanctuary.ogg")

-- Dissonant Reliquary --
Sprite.load("Tile16Reliquary", path.."DissonantReliquary/tileset", 1, 0, 0)
Sprite.load("HugePlanet", path.."DissonantReliquary/planet", 1, 0, 0)
Sprite.load("Reliquarysky", path.."DissonantReliquary/sky", 1, 0, 0)
Sprite.load("ReliquaryBG1", path.."DissonantReliquary/bg1", 1, 0, 0)
Sprite.load("ReliquaryBG2", path.."DissonantReliquary/bg2", 1, 0, 0)
Sprite.load("Beacon", path.."DissonantReliquary/Beacon", 1, 0, 0)

local DissonantReliquary = require("Stages.DissonantReliquary.stage")
local DissonantReliquaryVariant = require("Stages.DissonantReliquary.variant")
Stage.progression[5]:add(DissonantReliquary)
DissonantReliquary.rooms:add(DissonantReliquaryVariant)

DissonantReliquary.music = Sound.load("musicDissonantReliquary", "Misc/Music/stageDissonantReliquary.ogg")

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
local ShallowRotlands = require("Stages.ShallowRotlands.stage")
local ShallowRotlandsVariant = require("Stages.ShallowRotlands.variant")
ShallowRotlands.rooms:add(ShallowRotlandsVariant)

Stage.progression[3]:add(ShallowRotlands)

--Music
ShallowRotlands.music = Sound.load("musicShallowRotlands", "Misc/Music/stageShallowRotlands.ogg")

-- Serpentine Rainforest --
Sprite.load("Tile16Rainforest", path.."SerpentineRainforest/tileset", 1, 0, 0)
Sprite.load("Tile16RainforestBG", path.."SerpentineRainforest/ruins1", 1, 0, 0)
Sprite.load("Mountains1_3", path.."SerpentineRainforest/Mountains", 1, 0, 0)
Sprite.load("Planets1_3", path.."SerpentineRainforest/Planets", 1, 0, 0)
Sprite.load("Stars1_3", path.."SerpentineRainforest/Stars", 1, 0, 0)
Sprite.load("Clouds1_3", path.."SerpentineRainforest/clouds1", 1, 0, 0)
Sprite.load("Clouds2_1_3", path.."SerpentineRainforest/clouds2", 1, 0, 0)

require("Misc.StageObjects.RainSerpentine")

local SerpentineRainforest = require("Stages.SerpentineRainforest.stage")
local Rainforest1 = require("Stages.SerpentineRainforest.variant1")
local Rainforest2 = require("Stages.SerpentineRainforest.variant2")
SerpentineRainforest.rooms:add(Rainforest1)
SerpentineRainforest.rooms:add(Rainforest2)
Stage.progression[1]:add(SerpentineRainforest)

SerpentineRainforest.music = Sound.load("musicSerpentineRainforest", "Misc/Music/stageSerpentineRainforest.ogg")

-- Desert Peaks --
Sprite.load("Tile16Desert", path.."DesertPeaks/tileset", 1, 0, 0)
Sprite.load("64Desert", path.."DesertPeaks/64Desert", 1, 0, 0)
Sprite.load("sandhill", path.."DesertPeaks/sandhill", 1, 0, 0)
Sprite.load("sandmountains", path.."DesertPeaks/sandmountains", 1, 0, 0)
Sprite.load("sandsky", path.."DesertPeaks/sandsky", 1, 0, 0)
Sprite.load("sandplanet", path.."DesertPeaks/sandplanet", 1, 0, 0)


local DesertPeaks = require("Stages.DesertPeaks.stage")
local desert1 = require("Stages.DesertPeaks.variant")
DesertPeaks.rooms:add(desert1)
Stage.progression[4]:add(DesertPeaks)

--Music
DesertPeaks.music = Sound.load("musicDesertPeaks", "Misc/Music/stageDesertPeaks.ogg")

--Meridian Enemies
local DF = Stage.find("Desolate Forest")
local DL = Stage.find("Dried Lake")
local SM = Stage.find("Sky Meadow")
local DC = Stage.find("Damp Caverns")
local ST = Stage.find("Sunken Tombs")
local AV = Stage.find("Ancient Valley")
local MB = Stage.find("Magma Barracks")
local HC = Stage.find("Hive Cluster")
local TOTE = Stage.find("Temple of the Elders")
local ROR = Stage.find("Risk of Rain")

StageValue = 0

--Stage Counter
callback.register("onStageEntry", function(room)
	StageValue = StageValue + 1
end)

callback.register("globalRoomStart", function(room)
	if room == Room.find("Start") then
		StageValue = 0
		DF.enemies:remove(MonsterCard.find("Scavenger"))
		DL.enemies:remove(MonsterCard.find("Scavenger"))
		SerpentineRainforest.enemies:remove(MonsterCard.find("Scavenger"))
		DF.enemies:remove(MonsterCard.find("Archaic Wisp"))
		DL.enemies:remove(MonsterCard.find("Archaic Wisp"))
		SerpentineRainforest.enemies:remove(MonsterCard.find("Archaic Wisp"))
	end
end)

local m1
local m2
local m3

callback.register("globalRoomStart", function(room)
	if room == Room.find("Start") and not modloader.checkFlag("mn_disable_enemies") then
		if modloader.checkFlag("enable_mergers") then
			m1 = MonsterCard.find("m1", "meridian")
			m2 = MonsterCard.find("m2", "meridian")
			m3 = MonsterCard.find("m3", "meridian")
		end
	end
end)

callback.register("globalRoomStart", function(room)
	if room == Room.find("Start") and not modloader.checkFlag("mn_disable_enemies") then
		if modloader.checkFlag("enable_mergers") then
			SM.enemies:remove(m2)
			SM.enemies:remove(m3)
			ShallowRotlands.enemies:remove(m3)
			HC.enemies:remove(m3)
			ST.enemies:remove(m3)

			HC.enemies:add(m1)
			ST.enemies:add(m1)
			ShallowRotlands.enemies:add(m1)
		end
	end
end)

callback.register("postLoad", function()
		if not modloader.checkFlag("mn_disable_enemies") and modloader.checkFlag("enable_mergers") then
			local m1 = MonsterCard.find("m1", "meridian")
			local m2 = MonsterCard.find("m2", "meridian")
			local m3 = MonsterCard.find("m3", "meridian")

			ST.enemies:add(m1)
			ST.enemies:add(m2)

			HC.enemies:add(m1)
			HC.enemies:add(m2)

			ShallowRotlands.enemies:add(m1)
			ShallowRotlands.enemies:add(m2)
		end
end)

callback.register("onStageEntry", function()
	if StageValue == 5 and not modloader.checkFlag("mn_disable_enemies") and modloader.checkFlag("enable_mergers")then
		SM.enemies:add(m2)
		SM.enemies:add(m3)
		ShallowRotlands.enemies:add(m3)
		HC.enemies:add(m3)
		ST.enemies:add(m3)

		HC.enemies:remove(m1)
		ST.enemies:remove(m1)
		ShallowRotlands.enemies:remove(m1)
		
	end
end)

callback.register("postLoad", function()


	if not modloader.checkFlag("mn_disable_enemies") then
		local con1 = MonsterCard.find("con1", "meridian")
		local con2 = MonsterCard.find("con2", "meridian")
		local dog = MonsterCard.find("dog", "meridian")
		local giant = MonsterCard.find("giant", "meridian")
		local BC = MonsterCard.find("Basalt Crab", "meridian")
		local Lizard = MonsterCard.find("Lacertian", "meridian")

		--Desolate Forest
		DF.enemies:add(Lizard)

		--Dried Lake
		DL.enemies:add(Lizard)

		--Sunken Tombs
		ST.enemies:add(Lizard)

		--Hive Cluster


		--Sky Meadow
		--none <3

		--Temple of the Elders
		TOTE.enemies:add(Lizard)
		TOTE.enemies:add(giant)

		--Risk of Rain
		--ROR.enemies:add(Lizard)
		ROR.enemies:add(giant)

		--Serpentine Rainforest
		SerpentineRainforest.enemies:add(Lizard)
		
		--Shallow Rotlands
		ShallowRotlands.enemies:add(con1)
		ShallowRotlands.enemies:add(Lizard)


		--Marshland Sanctuary
		MarshlandSanctuary.enemies:add(giant)
		MarshlandSanctuary.enemies:add(Lizard)
		
		--Basalt Quarry
		BasaltQuarry.enemies:add(con2)
		BasaltQuarry.enemies:add(con1)
		BasaltQuarry.enemies:add(BC)
		BasaltQuarry.enemies:add(giant)

		--Dissonant Reliquary
		DissonantReliquary.enemies:add(giant)
		DissonantReliquary.enemies:add(dog)

		--Starswept Valley
		StarsweptValley.enemies:add(con1)
		--print("MERIDIAN ENEMIES DETECTED!")
	end
	if modloader.checkMod("starstorm") then
		local brokenpod = Interactable.find("Broken Escape Pod", "starstorm")
		local activator = Interactable.find("Activator", "starstorm")
		local stunner = Interactable.find("Shocker Drone", "starstorm")
		local hax = Interactable.find("Hacking Drone", "starstorm")
		local dupeglitch = Interactable.find("Duplicator Drone", "starstorm")
		local dronekiller = Interactable.find("Refabricator", "starstorm")
		local relic = Interactable.find("Relic Shrine", "starstorm")

		local admonitor = MonsterCard.find("Clay Admonitor", "starstorm")
		local exploder = MonsterCard.find("Exploder", "Starstorm")
		local follower = MonsterCard.find("Follower", "Starstorm")
		local elver = MonsterCard.find("Squall Elver", "Starstorm")
		local eel = MonsterCard.find("SquallEel", "Starstorm")
		local wayfarer = MonsterCard.find("Wayfarer", "Starstorm")
		local wyvern = MonsterCard.find("Wyvern", "Starstorm")
		local bughive = MonsterCard.find("Archer Bug Hive", "Starstorm")
		local overseer = MonsterCard.find("Overseer", "Starstorm")

		--Shallow Rotlands
		ShallowRotlands.enemies:add(bughive)
		ShallowRotlands.enemies:add(exploder)
		ShallowRotlands.enemies:add(wayfarer)
		ShallowRotlands.enemies:add(eel)
		ShallowRotlands.interactables:add(stunner)
		ShallowRotlands.interactables:add(dronekiller)
		ShallowRotlands.interactables:add(brokenpod)
		ShallowRotlands.interactables:add(hax)

		--Desert Peaks
		DesertPeaks.enemies:add(admonitor)
		DesertPeaks.enemies:add(overseer)
		DesertPeaks.interactables:add(dupeglitch)
		DesertPeaks.interactables:add(dronekiller)
		DesertPeaks.interactables:add(brokenpod)

		--Marshland Sanctuary
		MarshlandSanctuary.enemies:add(exploder)
		MarshlandSanctuary.enemies:add(follower)
		MarshlandSanctuary.enemies:add(admonitor)
		MarshlandSanctuary.enemies:add(overseer)
		MarshlandSanctuary.interactables:add(dupeglitch)
		MarshlandSanctuary.interactables:add(stunner)
		MarshlandSanctuary.interactables:add(dronekiller)
		MarshlandSanctuary.interactables:add(brokenpod)

		--Basalt Quarry
		BasaltQuarry.enemies:add(follower)
		BasaltQuarry.enemies:add(wayfarer)
		BasaltQuarry.enemies:add(overseer)
		BasaltQuarry.interactables:add(dupeglitch)
		BasaltQuarry.interactables:add(dronekiller)
		BasaltQuarry.interactables:add(brokenpod)
		BasaltQuarry.interactables:add(hax)

		--Dissonant Reliquary
		DissonantReliquary.enemies:add(overseer)
		DissonantReliquary.enemies:add(elver)
		DissonantReliquary.enemies:add(wyvern)
		DissonantReliquary.interactables:add(relic)
		DissonantReliquary.interactables:add(dupeglitch)
		DissonantReliquary.interactables:add(dronekiller)
		DissonantReliquary.interactables:add(brokenpod)
		
		--Starswept Valley
		StarsweptValley.enemies:add(overseer)
		StarsweptValley.enemies:add(wayfarer)
		StarsweptValley.enemies:add(follower)
		StarsweptValley.enemies:add(admonitor)
		StarsweptValley.interactables:add(stunner)
		StarsweptValley.interactables:add(hax)
		StarsweptValley.interactables:add(dronekiller)
		StarsweptValley.interactables:add(brokenpod)

		--Serpentine Rainforest
		SerpentineRainforest.interactables:add(dronekiller)
		SerpentineRainforest.interactables:add(brokenpod)
	end
end)

callback.register("onStageEntry", function()
	if StageValue == 5 then
		DF.enemies:add(MonsterCard.find("Scavenger"))
		DL.enemies:add(MonsterCard.find("Scavenger"))
		SerpentineRainforest.enemies:add(MonsterCard.find("Scavenger"))
		DF.enemies:add(MonsterCard.find("Archaic Wisp"))
		DL.enemies:add(MonsterCard.find("Archaic Wisp"))
		SerpentineRainforest.enemies:add(MonsterCard.find("Archaic Wisp"))
		
	end
end)

--Teleporter Fake replacer 3000
local specificStages = {
    "Serpentine Rainforest",
}

local telefake = Object.find("TeleporterFake", "vanilla")
local base = Object.find("Base", "vanilla")

enteredStage = false

local function isSpecificStage(stageName)
    for _, specificStage in ipairs(specificStages) do
        if stageName == specificStage then
            return true
        end
    end
    return false
end

callback.register("onStageEntry", function()

    local currentStageName = Stage.getCurrentStage():getName()

    if isSpecificStage(currentStageName) and enteredStage == false then
        for _, telefakeinst in ipairs(telefake:findAll()) do
            local x, y = telefakeinst.x, telefakeinst.y

            base:create(x - 64, y)

            telefakeinst:destroy()
		enteredStage = true
        end
    end
end)

callback.register("globalRoomStart", function(room)
	if room == Room.find("Start") then
		enteredStage = false
	end
end)

callback.register("onPlayerDeath", function()
	enteredStage = false
end)
