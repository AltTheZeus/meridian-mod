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

-- Hive Savanna --
Sprite.load("Tile16Savanna", path.."HiveSavanna/tileset", 1, 0, 0)
Sprite.load("SavannaSky", path.."HiveSavanna/sky", 1, 0, 0)
Sprite.load("TempleHill", path.."HiveSavanna/bg1", 1, 0, 0)
Sprite.load("CloudsSavanna", path.."HiveSavanna/clouds", 1, 0, 0)
Sprite.load("Planets1_4", path.."HiveSavanna/planet", 1, 0, 0)

local HiveSavanna = require("Stages.HiveSavanna.stage")
local savanna1 = require("Stages.HiveSavanna.variant1")
local savanna2 = require("Stages.HiveSavanna.variant2")
Stage.progression[1]:add(HiveSavanna)
HiveSavanna.rooms:add(savanna1)
HiveSavanna.rooms:add(savanna2)

--Music
HiveSavanna.music = Sound.load("musicHiveSavanna", "Misc/Music/stageHiveSavanna.ogg")

-- Snowy Spires --
Sprite.load("Tile16Ice", path.."SnowySpires/tileset", 1, 0, 0)
Sprite.load("glacier1", path.."SnowySpires/glacier1", 1, 0, 0)
Sprite.load("snowgroundClouds", path.."SnowySpires/clouds", 1, 0, 0)
Sprite.load("snowskyClouds", path.."SnowySpires/clouds2", 1, 0, 0)
Sprite.load("glacier2", path.."SnowySpires/glacier2", 1, 0, 0)
Sprite.load("glacierSky", path.."SnowySpires/sky", 1, 0, 0)
Sprite.load("snowSun", path.."SnowySpires/sun", 1, 0, 0)
require("Stages.SnowySpires.Clouds")

--require("Misc.StageObjects.Snowflakes")

local SnowySpires = require("Stages.SnowySpires.stage")
local glacier1 = require("Stages.SnowySpires.variant")
Stage.progression[2]:add(SnowySpires)
SnowySpires.rooms:add(glacier1)


--Music
SnowySpires.music = Sound.load("musicSnowySpires", "Misc/Music/stageSnowySpires.ogg")

--Vanilla Stages
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

-- Starstorm Stages
local SlateMines
local StrayTarn
local TorridOutlands
local UnchartedMountain
local VerdantWoodland
local WhistlingBasin
-- Starstorm Interactables
local brokenpod
local activator
local shocker
local hax
local dupeglitch
local dronekiller
local relic
-- Starstorm Enemies 
local admonitor
local exploder
local follower
local elver
local eel
local wayfarer
local wyvern
local bughive
local overseer

-- Meridian Enemies 
local con1
--local con2 --the con1 monster card spawns both constructs 
local dog
local giant
local BC
local Lizard
local icicle
local m1
local m2
local m3

callback.register("postLoad", function()

	if modloader.checkMod("starstorm") then
		-- Starstorm Stages
		SlateMines = Stage.find("Slate Mines", "starstorm")
		StrayTarn = Stage.find("Stray Tarn", "starstorm")
		TorridOutlands = Stage.find("Torrid Outlands", "starstorm")
		UnchartedMountain = Stage.find("Uncharted Mountain", "starstorm")
		VerdantWoodland = Stage.find("Verdant Woodland", "starstorm")
		WhistlingBasin = Stage.find("Whistling Basin", "starstorm")
		-- Starstorm Interactables
		brokenpod = Interactable.find("Broken Escape Pod", "starstorm")
		activator = Interactable.find("Activator", "starstorm")
		shocker = Interactable.find("Shocker Drone", "starstorm")
		hax = Interactable.find("Hacking Drone", "starstorm")
		dupeglitch = Interactable.find("Duplicator Drone", "starstorm")
		dronekiller = Interactable.find("Refabricator", "starstorm")
		relic = Interactable.find("Relic Shrine", "starstorm")
		-- Starstorm Enemies
		admonitor = MonsterCard.find("Clay Admonitor", "starstorm")
		exploder = MonsterCard.find("Exploder", "Starstorm")
		follower = MonsterCard.find("Follower", "Starstorm")
		elver = MonsterCard.find("Squall Elver", "Starstorm")
		eel = MonsterCard.find("SquallEel", "Starstorm")
		wayfarer = MonsterCard.find("Wayfarer", "Starstorm")
		wyvern = MonsterCard.find("Wyvern", "Starstorm")
		bughive = MonsterCard.find("Archer Bug Hive", "Starstorm")
		overseer = MonsterCard.find("Overseer", "Starstorm")
		
		-- Starstorm Interactables in Meridian Stages
		
		--Shallow Rotlands
		ShallowRotlands.interactables:add(shocker)
		ShallowRotlands.interactables:add(dronekiller)
		ShallowRotlands.interactables:add(brokenpod)
		ShallowRotlands.interactables:add(hax)

		--Desert Peaks
		DesertPeaks.interactables:add(dupeglitch)
		DesertPeaks.interactables:add(dronekiller)
		DesertPeaks.interactables:add(brokenpod)

		--Marshland Sanctuary
		MarshlandSanctuary.interactables:add(dupeglitch)
		MarshlandSanctuary.interactables:add(shocker)
		MarshlandSanctuary.interactables:add(dronekiller)
		MarshlandSanctuary.interactables:add(brokenpod)

		--Basalt Quarry
		BasaltQuarry.interactables:add(dupeglitch)
		BasaltQuarry.interactables:add(dronekiller)
		BasaltQuarry.interactables:add(brokenpod)
		BasaltQuarry.interactables:add(hax)

		--Dissonant Reliquary
		DissonantReliquary.interactables:add(relic)
		DissonantReliquary.interactables:add(dupeglitch)
		DissonantReliquary.interactables:add(dronekiller)
		DissonantReliquary.interactables:add(brokenpod)
		
		--Starswept Valley
		StarsweptValley.interactables:add(shocker)
		StarsweptValley.interactables:add(hax)
		StarsweptValley.interactables:add(dronekiller)
		StarsweptValley.interactables:add(brokenpod)

		--Serpentine Rainforest
		SerpentineRainforest.interactables:add(dronekiller)
		SerpentineRainforest.interactables:add(brokenpod)

		--Hive Savanna
		HiveSavanna.interactables:add(dronekiller)
		HiveSavanna.interactables:add(brokenpod)		
	end
	
	if not modloader.checkFlag("mn_disable_enemies") then
		con1 = MonsterCard.find("con1", "meridian")
		dog = MonsterCard.find("dog", "meridian")
		giant = MonsterCard.find("giant", "meridian")
		BC = MonsterCard.find("Basalt Crab", "meridian")
		Lizard = MonsterCard.find("Lacertian", "meridian")
		icicle = MonsterCard.find("Icicle", "meridian")
		m1 = MonsterCard.find("m1", "meridian")
		m2 = MonsterCard.find("m2", "meridian")
		m3 = MonsterCard.find("m3", "meridian")	
	end
	
end)

--Stage Counter

callback.register("globalRoomStart", function(room)
	if room == Room.find("Start") then
		DF.enemies:remove(MonsterCard.find("Scavenger"))
		DL.enemies:remove(MonsterCard.find("Scavenger"))
		SerpentineRainforest.enemies:remove(MonsterCard.find("Scavenger"))
		DF.enemies:remove(MonsterCard.find("Archaic Wisp"))
		DL.enemies:remove(MonsterCard.find("Archaic Wisp"))
		SerpentineRainforest.enemies:remove(MonsterCard.find("Archaic Wisp"))
	end
end)

callback.register("onGameStart", function()
	if not modloader.checkFlag("mn_disable_enemies") then	
		-- Meridian Enemies in Vanilla and Meridian Stages 
		
		--Desolate Forest
		DF.enemies:add(Lizard)
		DF.enemies:remove(con1)
		DF.enemies:remove(giant)

		--Dried Lake
		DL.enemies:add(Lizard)
		DL.enemies:remove(BC)

		--Sunken Tombs
		ST.enemies:add(Lizard)
		ST.enemies:add(m1)
		ST.enemies:add(m2)
		ST.enemies:remove(m3)
		ST.enemies:remove(BC)

		--Hive Cluster
		HC.enemies:add(m1)
		HC.enemies:add(m2)
		HC.enemies:remove(m3)
		
		--Sky Meadow
		SM.enemies:add(con1)
		SM.enemies:remove(m2)
		SM.enemies:remove(m3)
		SM.enemies:remove(giant)
		
		--Ancient Valley
		AV.enemies:add(icicle)
		AV.enemies:remove(dog)
		
		--Magma Barracks
		MB.enemies:add(BC)
		MB.enemies:add(giant)

		--Temple of the Elders
		TOTE.enemies:add(Lizard)
		TOTE.enemies:add(giant)
		TOTE.enemies:add(dog)

		--Risk of Rain
		--ROR.enemies:add(Lizard)
		ROR.enemies:add(giant)
		ROR.enemies:add(dog)

		--Serpentine Rainforest
		SerpentineRainforest.enemies:add(Lizard)
		
		--Hive Savanna
		HiveSavanna.enemies:add(Lizard)
		
		--Shallow Rotlands
		ShallowRotlands.enemies:add(con1)
		ShallowRotlands.enemies:add(Lizard)
		ShallowRotlands.enemies:add(m1)
		ShallowRotlands.enemies:add(m2)
		ShallowRotlands.enemies:remove(m3)

		--Marshland Sanctuary
		MarshlandSanctuary.enemies:add(giant)
		MarshlandSanctuary.enemies:add(Lizard)
		
		--Basalt Quarry
		BasaltQuarry.enemies:add(con1)
		BasaltQuarry.enemies:add(BC)
		BasaltQuarry.enemies:add(giant)

		--Dissonant Reliquary
		DissonantReliquary.enemies:add(giant)
		DissonantReliquary.enemies:add(dog)

		--Starswept Valley
		StarsweptValley.enemies:add(con1)
		
		--Snowy Spires 
		SnowySpires.enemies:add(icicle)			
	end
	
	if modloader.checkMod("starstorm") then
		-- Starstorm Enemies in Meridian Stages 
		
		--Shallow Rotlands
		--ShallowRotlands.enemies:add(bughive)
		ShallowRotlands.enemies:add(exploder)
		ShallowRotlands.enemies:add(wayfarer)
		ShallowRotlands.enemies:add(eel)

		--Desert Peaks
		DesertPeaks.enemies:add(admonitor)
		DesertPeaks.enemies:add(overseer)

		--Marshland Sanctuary
		MarshlandSanctuary.enemies:add(exploder)
		MarshlandSanctuary.enemies:add(follower)
		MarshlandSanctuary.enemies:add(admonitor)
		MarshlandSanctuary.enemies:add(overseer)

		--Basalt Quarry
		BasaltQuarry.enemies:add(follower)
		BasaltQuarry.enemies:add(wayfarer)
		BasaltQuarry.enemies:add(overseer)

		--Dissonant Reliquary
		DissonantReliquary.enemies:add(overseer)
		DissonantReliquary.enemies:add(elver)
		DissonantReliquary.enemies:add(wyvern)
		
		--Starswept Valley
		StarsweptValley.enemies:add(overseer)
		StarsweptValley.enemies:add(wayfarer)
		StarsweptValley.enemies:add(follower)
		StarsweptValley.enemies:add(admonitor)	
		
		if not modloader.checkFlag("mn_disable_enemies") then	
			-- Meridian enemies in Starstorm stages 
			
			-- Slate Mines 
			SlateMines.enemies:add(BC)
			
			-- Stray Tarn
			StrayTarn.enemies:add(BC)
			
			-- Torrid Outlands
			TorridOutlands.enemies:add(con1)
			TorridOutlands.enemies:add(giant)
			
			-- Uncharted Mountain
			UnchartedMountain.enemies:add(icicle)
			
			-- Verdant Woodland
			
			-- Whistling Basin	
			WhistlingBasin.enemies:remove(BC)
			
		end
	end
end)

-- POST-LOOP
callback.register("onStageEntry", function()
	if misc.director:get("stages_passed") == 5 then 
		if not modloader.checkFlag("mn_disable_enemies") then
			-- POST-LOOP Meridian Enemies in Vanilla and Meridian Stages 
			--Desolate Forest
			DF.enemies:add(con1)
			DF.enemies:add(giant)

			--Dried Lake
			DL.enemies:add(BC)

			--Sunken Tombs
			ST.enemies:add(m3)
			ST.enemies:remove(m1)
			ST.enemies:add(BC)

			--Hive Cluster
			HC.enemies:add(m3)
			HC.enemies:remove(m1)
			
			--Sky Meadow
			SM.enemies:add(m2)
			SM.enemies:add(m3)
			SM.enemies:add(giant)
			
			--Ancient Valley
			AV.enemies:add(dog)

			--Temple of the Elders

			--Risk of Rain

			--Serpentine Rainforest

			--Hive Savanna
			
			--Shallow Rotlands
			ShallowRotlands.enemies:add(m3)
			ShallowRotlands.enemies:remove(m1)

			--Marshland Sanctuary
			
			--Basalt Quarry

			--Dissonant Reliquary

			--Starswept Valley
			
			--Snowy Spires 
			
		end
		if modloader.checkMod("starstorm") then
			-- POST-LOOP Starstorm Enemies in Meridian Stages 
			--Serpentine Rainforest

			--Hive Savanna
			
			--Shallow Rotlands

			--Marshland Sanctuary
			
			--Basalt Quarry

			--Dissonant Reliquary

			--Starswept Valley
			
			--Snowy Spires 		
			
			if not modloader.checkFlag("mn_disable_enemies") then	
				-- POST-LOOP Meridian enemies in Starstorm stages 
				
				-- Slate Mines 
				
				-- Stray Tarn
				
				-- Torrid Outlands
				
				-- Uncharted Mountain
				
				-- Verdant Woodland
				
				-- Whistling Basin		
				WhistlingBasin.enemies:add(BC)
				
			end		
		end
	end
end)

callback.register("onStageEntry", function()
	if misc.director:get("stages_passed") == 5 then
		DF.enemies:add(MonsterCard.find("Scavenger"))
		DL.enemies:add(MonsterCard.find("Scavenger"))
		SerpentineRainforest.enemies:add(MonsterCard.find("Scavenger"))
		HiveSavanna.enemies:add(MonsterCard.find("Scavenger"))
		DF.enemies:add(MonsterCard.find("Archaic Wisp"))
		DL.enemies:add(MonsterCard.find("Archaic Wisp"))
		SerpentineRainforest.enemies:add(MonsterCard.find("Archaic Wisp"))
		HiveSavanna.enemies:add(MonsterCard.find("Archaic Wisp"))
		
	end
end)

--Teleporter Fake replacer 3000
local specificStages = {
    "Serpentine Rainforest",
	"Hive Savanna"
}

local telefake = Object.find("TeleporterFake", "vanilla")
local base = Object.find("Base", "vanilla")

callback.register("onStageEntry", function()
	if --[[Stage.getCurrentStage():getName() == "Serpentine Rainforest" and]] misc.director:get("stages_passed") == 0 then
		for _, telefakeinst in ipairs(telefake:findAll()) do
			local x, y = telefakeinst.x, telefakeinst.y
			base:create(x - 64, y)
			telefakeinst:destroy()
			enteredStage = true
		end
	end
end)
