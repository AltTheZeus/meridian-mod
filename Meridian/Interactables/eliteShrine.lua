--shoutout to zarah she helped enormously with this code :]!!!

local path = "Interactables/"
local shrine = Object.base("MapObject", eliteShrine)
local shrineInt = Interactable.new(shrine, "Shrine of Bestowal")
shrineInt.spawnCost = 100
shrine.depth = -9

registercallback("onStageEntry", function()
	local dD = misc.director:getData()
	dD.shrineBabies = {}
end)

shrine.sprite = Sprite.load(path .. "eliteShrine", 7, 12, 53)
registercallback("onGameStart", function()
	if Artifact.find("Honor").active == true then
		for _, s in ipairs(Stage.findAll("Vanilla")) do
			s.interactables:remove(shrineInt)
		end
	else
		for _, s in ipairs(Stage.findAll("Vanilla")) do
			if s ~= Stage.find("Risk of Rain") then
				s.interactables:add(shrineInt)
			end
		end
	end
end)

shrine:addCallback("create", function(self)
	local sA = self:getAccessor()
	local sD = self:getData()
	self:set("cost", 0)
	self:set("text", "to call upon greatness.")
	sD.opened = 0
	sD.childrenkilled = 0
	self.spriteSpeed = 0
	sD.errorCD = 0
	sD.item = false
	sD.shrineBabies = {}
end)

local enemies = ParentObject.find("classicEnemies")

local shrinesplosion = Object.new("eliteShrineEf")
shrinesplosion.sprite = Sprite.load(path .. "eliteShrineEf", 6, 26, 66)

shrinesplosion:addCallback("create", function(self)
	self.spriteSpeed = 0.2
end)

shrinesplosion:addCallback("step", function(self)
	if self.subimage >= 6 then
		self:destroy()
	end
end)

local chestNoise = Sound.find("Chest1", "vanilla")
local shrineNoise = Sound.find("Shrine1", "vanilla")
local errorNoise = Sound.find("Error", "vanilla")
local playerobj = Object.find("P")

shrine:addCallback("draw", function(self)
	local sD = self:getData()
	if self:collidesWith(playerobj, self.x, self.y) and sD.opened == 0 then
		local nonElites = enemies:findMatching("prefix_type", 0)
		for a, i in pairs(nonElites) do
			if i:get("team") == "player" or i:get("ghost") == 1 or i:get("show_boss_health") == 1 or i:getObject() == Object.find("LizardF") or i:getObject() == Object.find("LizardFG") then
				table.remove(nonElites, a)
			end
		end
		local diffBonus = math.round(misc.director:get("stages_passed") * 0.4)
		if #nonElites < (3 + diffBonus) then
			graphics.color(Color.GREY)
			graphics.printColor("Not enough eligible enemies.", self.x - 75, self.y - 50)
		else
			local key = input.getControlString("enter")
			graphics.color(Color.WHITE)
			graphics.printColor("Press '&y&" .. key .. "&!&' " .. self:get("text"), self.x - 90, self.y - 50) --should be -95 but that period throws me off
		end
	end
end)

local arrowBuff = Buff.new("shrineBuff")
arrowBuff.sprite = Sprite.load(path .. "shrineIndicator", 1, 8, 7)

local red = ItemPool.find("rare")
local green = ItemPool.find("uncommon")
local white = ItemPool.find("common")

shrine:addCallback("step", function(self)
	local sD = self:getData()
	local dD = misc.director:getData()
	local nonElites = enemies:findMatching("prefix_type", 0)
	for a, i in pairs(nonElites) do
		if i:get("team") == "player" or i:get("ghost") == 1 or i:get("show_boss_health") == 1 or i:getObject() == Object.find("LizardF") or i:getObject() == Object.find("LizardFG") then
			table.remove(nonElites, a)
		end
	end
	local diffBonus = math.round(misc.director:get("stages_passed") * 0.4)
	if self.subimage >= 2 and sD.opened == 0 then
		shrineNoise:play()
		local elited = 0
		for _, i in ipairs(nonElites) do
			if elited < (3 + diffBonus) then
				local card
				local elites
				local elite
				for _, c in ipairs(MonsterCard.findAll()) do
					if c.object == i:getObject() then
						elites = c.eliteTypes:toTable()
						local failsafe = 0
						repeat
							elite = table.random(elites)
							failsafe = failsafe + 1
						until elite ~= EliteType.find("blessed") or failsafe >= 100
						if failsafe >= 100 then
							elite = EliteType.find("blazing")
						end
					end
				end
				local iD = i:getData()
				iD.shrineborn = self.id
				i:makeElite(elite)
				local spriteMaths = i.sprite.height - i.sprite.yorigin
				shrinesplosion:create(i.x, i.y + spriteMaths)
				elited = elited + 1
				dD.shrineBabies[i.id] = i
				sD.shrineBabies[i.id] = i
			end
		end
		sD.opened = 1
	elseif self.subimage >= 7 then
		self.spriteSpeed = 0
	end
	if sD.errorCD > 0 then
		sD.errorCD = sD.errorCD - 1
	end
	for _, player in ipairs(misc.players) do
		if self:collidesWith(player, self.x, self.y) then
			if player:control("enter") == input.PRESSED then --or player:control("enter") == input.HELD then
				local nonElites = enemies:findMatching("prefix_type", 0)
				for a, i in pairs(nonElites) do
					if i:get("team") == "player" or i:get("ghost") == 1 or i:get("show_boss_health") == 1 or i:getObject() == Object.find("LizardF") or i:getObject() == Object.find("LizardFG") then
						table.remove(nonElites, a)
					end
				end
				local diffBonus = math.round(misc.director:get("stages_passed") * 0.4)
				if #nonElites < (3 + diffBonus) then
					local pickedShrine = shrine:findNearest(player.x, player.y)
					local sD = pickedShrine:getData()
					if sD.errorCD == 0 then
						errorNoise:play()
						sD.errorCD = 20
					end
				else
					local pickedShrine = shrine:findNearest(player.x, player.y)
					local sD = pickedShrine:getData()
					if sD.opened == 0 then
						pickedShrine.spriteSpeed = 0.35
						sD.activator = player.id
					end
				end
			end
		end
	end
	if sD.childrenkilled >= 3 + diffBonus and sD.item == false then
		local p = Object.findInstance(sD.activator)
		local chestMath = math.random(0,100)
		if Artifact.find("Command").active == true then
			if chestMath <= 1 then
				red:getCrate().create(p.x, p.y)
			elseif chestMath >= 2 and chestMath <= 30 then
				green:getCrate():create(p.x, p.y)
			else
				white:getCrate():create(p.x, p.y)
			end
		else
			if chestMath <= 1 then
				red:roll():getObject():create(p.x, p.y - 8)
			elseif chestMath >= 2 and chestMath <= 30 then
				green:roll():getObject():create(p.x, p.y - 8)
			else
				white:roll():getObject():create(p.x, p.y - 8)
			end
		end
		sD.item = true
	end	
end)

--straight up genuinely dont know how the code below works. none of the indexes show up in game <3

registercallback("onNPCDeath", function(npc)
	local nD = npc:getData()
	local dD = misc.director:getData()
	if nD.shrineborn then --accidentally wrote shrimpborne while writing this. they should have done that for skyrim instead
		local sD = Object.findInstance(nD.shrineborn):getData()
		local sA = Object.findInstance(nD.shrineborn):getAccessor()
		sD.childrenkilled = sD.childrenkilled + 1
		dD.shrineBabies[npc.id] = nil
		sD.shrineBabies[npc.id] = nil
	end
end)

function distance(x1, y1, x2, y2)
	local distance = math.sqrt(math.pow(x2 - x1, 2) + math.pow(y2 - y1, 2))
	return distance
end

registercallback("onPlayerDrawAbove", function(player)
	local dD = misc.director:getData()
	if dD.shrineBabies ~= nil then
		local targetDist
		local target
		for a, i in pairs(dD.shrineBabies) do
			local newDist = distance(i.x, i.y, player.x, player.y)
			if not targetDist or newDist < targetDist then
				targetDist = newDist
				target = i
			end
		end
--		print(target)
--		print(dD.shrineBabies)
		if target ~= nil then
		local angle = math.atan2(target.y - player.y, target.x - player.x)
		local xPosition = math.cos(angle) * 20
		local yPosition = math.sin(angle) * 20
		graphics.drawImage{
			image = arrowBuff.sprite,
			x = player.x + xPosition,
			y = player.y + yPosition,
			angle = -math.deg(angle)
		}
		end
	end
end)

registercallback("onStep", function()
	for _, i in ipairs(enemies:findAll()) do
		local iD = i:getData()
		if iD.shrineborn then
			i:set("death_timer", 300)
		end
	end
end)