
local path = "Interactables/"
local shrine = Object.base("MapObject", "weatherStation")
local shrineInt = Interactable.new(shrine, "Weather Station")
shrineInt.spawnCost = 100
shrine.depth = -9
shrine.sprite = Sprite.load("WeatherStation", path.."weatherStation", 8, 15, 44)

local invasionWeatherType = {
	lightningStorm = {name = "Lightning Storm", elites = {EliteType.find("Overloading", "vanilla"), EliteType.find("bubble", "meridian")}, tint = Color.BLUE},
	eruption = {name = "Eruption", elites = {EliteType.find("Blazing", "vanilla"), EliteType.find("erupt", "meridian")}, tint = Color.RED},
	heatwave = {name = "Heatwave", elites = {EliteType.find("Frenzied", "vanilla"), EliteType.find("Blazing", "vanilla")}, tint = Color.YELLOW},
	earthquake = {name = "Earthquake", elites = {EliteType.find("Volatile", "vanilla"), EliteType.find("sorrow", "meridian")}, tint = Color.DARK_GRAY},
}

local invasionTypeLemurian = {
	bossCard = {card = MonsterCard.find("Elder Lemurian"), cost = 1300},
	fodderCard = {card = MonsterCard.find("Lemurian"), cost = 450}
}

local invasionTypeCrab = {
	bossCard = {card = MonsterCard.find("Basalt Crab"), cost = 1800},
	fodderCard = {card = MonsterCard.find("Sand Crab"), cost = 800}
}

local invasionTypeGolem = {
	bossCard = {card = MonsterCard.find("giant"), cost = 1700},
	fodderCard = {card = MonsterCard.find("Stone Golem"), cost = 600}
}

local invasionTypeIce = {
	bossCard = {card = MonsterCard.find("Icicle"), cost = 1400},
	fodderCard = {card = MonsterCard.find("Snow Golem"), cost = 600}
}

local invasionTypeTable = {
	lemurian = {name = "Lemurians", cards = invasionTypeLemurian},
	crab = {name = "Crabs", cards = invasionTypeCrab},
	golem = {name = "Golems", cards = invasionTypeGolem},
	icicle = {name = "Icicles", cards = invasionTypeIce}
}

callback.register("onStageEntry", function()
	local tps = obj.Teleporter:findAll()
	if #tps > 0 and net.host then 
		if math.chance(100) then
			local grounds = {}
										
			for _, ground in ipairs(obj.B:findAll()) do
				if --[[ground.sprite.width * ground.xscale > shrine.sprite.width / 3 and ]] not ground:collidesWith(obj.Base, ground.x, ground.y + 1) and not ground:collidesWith(obj.TeleporterFake, ground.x, ground.y - 1) then
					table.insert(grounds, ground) 
				end
			end
			--print(#grounds)
			--print(shrine.sprite.width)
										
			if #grounds > 0 then
				local ground, groundL, groundR, x, y
											
				local ww = shrine.sprite.width / 2
											
				ground = table.irandom(grounds)
				groundL = ground.x - (ground.sprite.boundingBoxLeft * ground.xscale) + ww
				groundR = ground.x + (ground.sprite.boundingBoxRight * ground.xscale) - ww
				x = math.random(groundL, groundR)
				y = ground.y
											
				for i = 0, 20 do
					if pobj.mapObjects:findRectangle(x - ww, y - 20, x + ww, y + 10) then
						ground = table.irandom(grounds)
						groundL = ground.x - (ground.sprite.boundingBoxLeft * ground.xscale) + ww
						groundR = ground.x + (ground.sprite.boundingBoxRight * ground.xscale) - ww
						x = math.random(groundL, groundR)
						y = ground.y
					else
						break
					end
				end
				shrine:create(x, y)
				--print("x = "..x.." / y = "..y)
			end 
		end 
	end
end)

shrine:addCallback("create", function(self)
	local selfData = self:getData()
	self:set("cost", 0)
	self:set("text", "to determine the weather.")
	selfData.activated = 0
	self.spriteSpeed = 0 
	--[[for i = 0, 500 do
		if self:collidesMap(self.x, self.y + i) then
			self.y = self.y + i - 1 
			break
		end
	end]]
end)

shrine:addCallback("step", function(self)
	local selfData = self:getData()
	local dirData = misc.director:getData()
	
	if selfData.activated == 1 then 
		if self.subimage >= self.sprite.frames then 
			self.spriteSpeed = 0
			selfData.activated = 2
		end
	elseif selfData.activated == 0 then 
		local tele = nearestMatchingOp(self, obj.Teleporter, "active", "==", 1)
		if tele then 
			self:destroy()
		else
			for _, player in ipairs(misc.players) do
				if self:collidesWith(player, self.x, self.y) and player:control("enter") == input.PRESSED then 
					self.spriteSpeed = 0.18
					selfData.activated = 1 
					dirData.initInvasion = true
					dirData.invasionEnemyType = table.random(invasionTypeTable)
					dirData.invasionWeatherType = table.random(invasionWeatherType)
					dirData.weatherStationActivate = 120
					print(dirData.invasionEnemyType.name)
					break
				end
			end
		end
	end
end)

shrine:addCallback("draw", function(self)
	local selfData = self:getData()
	
	if self:collidesWith(obj.P, self.x, self.y) and selfData.activated == 0 then 
		local key = input.getControlString("enter")
		graphics.color(Color.WHITE)
		graphics.printColor("Press '&y&" .. key .. "&!&' " .. self:get("text"), self.x - 95, self.y - 55)
	end
end)

callback.register("preHUDDraw", function()
	local dirData = misc.director:getData()
	
	if dirData.weatherStationActivate then 
		local w, h = graphics.getGameResolution()
		local weatherAlpha = dirData.weatherStationActivate / 120 / 3
		graphics.color(dirData.invasionWeatherType.tint)
		--graphics.setBlendMode("additive")
		graphics.alpha(weatherAlpha)
		graphics.rectangle(0, 0, w, h)		
		dirData.weatherStationActivate = dirData.weatherStationActivate - 1
		if dirData.weatherStationActivate <= 0 then 
			dirData.weatherStationActivate = nil
		end
	end
end)