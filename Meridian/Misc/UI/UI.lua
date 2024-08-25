--Main Menu

local title = Sprite.load("Misc/UI/sprTitleMeridian", 1, 205, 50)
local titleSS = Sprite.load("Misc/UI/sprTitleMeridianSS", 1, 205, 50)

callback.register("postLoad", function()
    if modloader.checkMod("starstorm") then
        Sprite.find("sprTitle", "Vanilla"):replace(titleSS)
    else
        Sprite.find("sprTitle", "Vanilla"):replace(title)
    end
end)


local sprites = {}
do
	local nameMap = {
		["Magma Barracks"] = "magma",
		["Sunken Tombs"] = "tombs",
		["Risk of Rain"] = "ror",
		["Desolate Forest"] = "desolate",
		["Sky Meadow"] = "meadow",
		["Temple of the Elders"] = "temple",
		["Hive Cluster"] = "hive",
		["Boar Beach"] = "boar",
		["Dried Lake"] = "lake",
		["Ancient Valley"] = "valley",
		["Damp Caverns"] = "caverns",
        ["Serpentine Rainforest"] = "rainforest",
        ["Basalt Quarry"] = "basalt",
        ["Desert Peaks"] = "desert",
        ["Shallow Rotlands"] = "rotlands",
        ["Marshland Sanctuary"] = "marshland",
        ["Dissonant Reliquary"] = "reliquary",
        ["Starswept Valley"] = "starswept",
	}
	for k, v in pairs(nameMap) do 
		sprites[k] = Sprite.load("title_" .. v, "Misc/UI/" .. v, 1, 0, 1)
	end
end
local default = sprites["Desolate Forest"]

local groundStrip = Sprite.find("groundStrip", "vanilla")
local function updateTitle()
	local variant = save.read("titleVariant")
	local sprite = nil
	
	if variant ~= nil then
		sprite = sprites[variant]
	end
	
	if sprite == nil then
		sprite = default
	end

	groundStrip:replace(sprite)
end

callback.register("onStageEntry", function()
	local stage = Stage.getCurrentStage()
	save.write("titleVariant", stage:getName())
end)

callback.register("postLoad", function()
	callback.register("onGameEnd", updateTitle)
	updateTitle()
end)

local stars = Sprite.find("Titlescreen", "Vanilla") 
local starsobj = Object.new("starsobj") 
starsobj.depth = 9700 
starsobj:addCallback("create", function(self)
    self:getData().move = -0.7 
    self:getData().moveStep = 0 
end)
starsobj:addCallback("step", function(self) 
    self:getData().moveStep = self:getData().moveStep + self:getData().move * 0.1
end)
starsobj:addCallback("draw", function(self) 
    local width = stars.width 
    local height = stars.height
    
    local roomWidth, roomHeight = Stage.getDimensions()
    
    local moveX = (self:getData().moveStep) % width

    local xParallax = 1 
    local yParallax = 1 

    for i = -1, math.floor((roomWidth * xParallax * 50) / width) do
        for j = -1, math.floor((roomHeight * yParallax * 50) / height) do
            graphics.drawImage{
                image = stars,
                x = moveX * xParallax + i * width,
                y = yParallax + j * height,
            }
        end
    end
end)
--[[
local ShootingStar = ParticleType.new("ShootingStar")

local ShootingStarSprite = Sprite.load("Misc/UI/ShootingStar", 5, 0, 0)

ShootingStar:sprite(ShootingStarSprite, true, true, false)
ShootingStar:life(30, 30)


local ShootingStarObj = Object.new("ShootingStar")

ShootingStarObj:addCallback("step", function(self)
    if math.chance(5) then
        ShootingStar:burst("middle", camera.x + math.random(1920, 0), camera.y + math.random(1080, 0), 1, nil)
    end
end)

]]
registercallback("globalRoomStart", function(room)
    if room == Room.find("Start", "vanilla") then
        starsobj:create(0, 0)
        --ShootingStarObj:create(0, 0)
    end
end)
