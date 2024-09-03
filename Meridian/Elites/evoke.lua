--TODO: stop enemies spawning in the ground/walls

local elite = EliteType.new("summon")
local sprPal = Sprite.load("Elites/evokePal", 1, 0, 0)
local ID = elite.ID

local eliteBaby = EliteType.new("clay")
local sprPalBaby = Sprite.load("Elites/moldedPal", 1, 0, 0)
local IDb = eliteBaby.ID

local bID = EliteType.find("blessed").ID

local eliteBabyBlessed = EliteType.new("gildedclay")
local sprPalBabyBlessed = Sprite.load("Elites/moldedBlessedPal", 1, 0, 0)
local bIDb = eliteBabyBlessed.ID

elite.displayName = "Molding"
elite.color = Color.fromRGB(97, 90, 187)
elite.palette = sprPal

eliteBaby.displayName = "Molded"
eliteBaby.color = Color.fromRGB(152, 171, 192)
eliteBaby.palette = sprPalBaby

eliteBabyBlessed.displayName = "Gold-Leafed Creation:"
eliteBabyBlessed.color = Color.fromRGB(152, 171, 192)
eliteBabyBlessed.palette = sprPalBabyBlessed


for _, i in ipairs(MonsterCard.findAll("vanilla")) do
	if i.isBoss == false and i.type == "classic" then
		i.eliteTypes:add(elite)
		i.eliteTypes:add(eliteBaby)
		i.eliteTypes:add(eliteBabyBlessed)
	end
end

registercallback("postLoad", function()
for _, m in ipairs(modloader.getMods()) do
	for _, i in ipairs(MonsterCard.findAll(m)) do
		if i.isBoss == false and i.type == "classic" then
			i.eliteTypes:add(elite)
			i.eliteTypes:add(eliteBaby)
			i.eliteTypes:add(eliteBabyBlessed)
		end
	end
end
end)

registercallback("onEliteInit", function(actor)
	local aD = actor:getData()
	if actor:get("elite_type") == ID or actor:get("elite_type") == bID then
		aD.pointTimer = 0
		aD.points = 0
		local enemyOptions = Stage.getCurrentStage().enemies:toTable()
		local failsafe = 0
		repeat
			failsafe = failsafe + 1
			aD.card = table.random(enemyOptions)
		until (aD.card.cost < 500 and aD.card.type == "classic") or failsafe >= 30
		if failsafe >= 30 then
			aD.card = MonsterCard.find("Sand Crab")
		end
		aD.timer = aD.card.cost
		aD.minionCount = 0
	end
end)

local enemies = ParentObject.find("enemies")

registercallback("onStep", function()
	if misc.getTimeStop() == 0 then
	for _, i in ipairs(enemies:findMatching("elite_type", ID)) do
		local aD = i:getData()
		if aD.minionCount < 3 then
			aD.pointTimer = aD.pointTimer + 1
		end
		if aD.pointTimer >= 60 then
			aD.points = aD.points + 1 + misc.director:get("stages_passed")
			aD.pointTimer = 0
		end
		if aD.points >= aD.timer and aD.minionCount < 3 then
			aD.points = aD.points - aD.timer
			local height = aD.card.object.sprite.height
			height = height + i.sprite.yorigin
			local newGuy = aD.card.object:create(i.x, i.y - height)
			local nD = newGuy:getData()
			nD.evoker = i.id
			aD.minionCount = aD.minionCount + 1
			newGuy:makeElite(eliteBaby)
				newGuy:set("maxhp", (math.round(((newGuy:get("maxhp") / 2.6) * 0.75))))
				newGuy:set("hp", newGuy:get("maxhp"))
				newGuy:set("damage", (math.round(((newGuy:get("damage") / 1.7) * 0.75))))
				newGuy:set("exp_worth", (math.round(((newGuy:get("exp_worth") / 2) * 0.5))))
				nD.terezi = 1
			local enemyOptions = Stage.getCurrentStage().enemies:toTable()
			repeat
				aD.card = table.random(enemyOptions)
			until aD.card.cost < 500 and aD.card.type == "classic"
			aD.timer = aD.card.cost
		end
	end
	for _, i in ipairs(enemies:findMatching("elite_type", bID)) do
		local aD = i:getData()
		if aD.minionCount < 4 then
			aD.pointTimer = aD.pointTimer + 1
		end
		if aD.pointTimer >= 60 then
			aD.points = aD.points + 1 + misc.director:get("stages_passed")
			aD.pointTimer = 0
		end
		if aD.points >= aD.timer and aD.minionCount < 4 then
			aD.points = aD.points - aD.timer
			local height = aD.card.object.sprite.height
			height = height + i.sprite.yorigin
			local newGuy = aD.card.object:create(i.x, i.y - height)
			local nD = newGuy:getData()
			nD.evoker = i.id
			aD.minionCount = aD.minionCount + 1
			newGuy:makeElite(eliteBabyBlessed)
				newGuy:set("maxhp", (math.round(((newGuy:get("maxhp") / 2.6) * 0.75))))
				newGuy:set("hp", newGuy:get("maxhp"))
				newGuy:set("damage", (math.round(((newGuy:get("damage") / 1.7) * 0.75))))
				newGuy:set("exp_worth", (math.round(((newGuy:get("exp_worth") / 2) * 0.5))))
				nD.terezi = 1
				nD.sparkleCD = 15
			local enemyOptions = Stage.getCurrentStage().enemies:toTable()
			repeat
				aD.card = table.random(enemyOptions)
			until aD.card.cost < 500 and aD.card.type == "classic"
			aD.timer = aD.card.cost
		end
	end
	end
end)

registercallback("onNPCDeath", function(npc)
	local nD = npc:getData()
	if nD.evoker ~= nil and Object.findInstance(nD.evoker) and Object.findInstance(nD.evoker):isValid() then
		local eD = Object.findInstance(nD.evoker):getData()
		eD.minionCount = eD.minionCount - 1
	end
end)

local shiny1 = Sprite.load("Elites/kirikiri1", 4, 3, 3)
local shint2 = Sprite.load("Elites/kirikiri2", 4, 3, 3)

local sparkle = ParticleType.new("sparkle")
sparkle:alpha(1, 0.75, 0)
sparkle:scale(1, 1)
sparkle:size(0.8, 1.2, 0, 0)
sparkle:speed(0, 0, 0, 0)
sparkle:direction(0, 0, 0, 0)
sparkle:gravity(0, 0)
sparkle:life(60 * 1, 60 * 1)

registercallback("onStep", function()
	for _, i in ipairs(enemies:findMatching("elite_type", bIDb)) do
		local aD = i:getData()
		if not aD.terezi then
			if i:get("team") == "enemy" then
				local replacement = i:getObject():create(i.x, i.y)
				replacement:makeElite()
				i:delete()
			end
		end
	end
	for _, i in ipairs(enemies:findMatching("elite_type", IDb)) do
		local aD = i:getData()
		if not aD.terezi then
			local replacement = i:getObject():create(i.x, i.y)
			replacement:makeElite()
			i:delete()
		end
	end
end, 500)

registercallback("onStep", function()
	for _, i in ipairs(enemies:findMatching("elite_type", bIDb)) do
		local aD = i:getData()
		if aD.sparkleCD > 0 then aD.sparkleCD = aD.sparkleCD - 1 end
		if aD.sparkleCD <= 0 then
			if math.random(100) >= 95 then
				local imageX = (i:getObject().sprite.width * 0.5) * math.random(-1, 1)
				local imageY = (i:getObject().sprite.height * 0.5) * math.random(-1, 1)
				xOffset = math.random(-10, 10)
				yOffset = math.random(-10, 10)
				local twinkle = math.random(1,2)
				if twinkle == 1 then
					sparkle:sprite(shiny1, true, true, false)
				else
					sparkle:sprite(shint2, true, true, false)
				end
				sparkle:burst("above", i.x + xOffset + imageX, i.y + yOffset + imageY, 1)
				aD.sparkleCD = 21
			end
		end
	end
end)
