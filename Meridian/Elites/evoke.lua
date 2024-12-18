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

registercallback("onEliteInit", function(actor)
	local aD = actor:getData()
	if actor:get("elite_type") == ID or actor:get("elite_type") == bID then
		if net.host then
			aD.pointTimer = 0
			aD.points = 0
			local enemyOptions = Stage.getCurrentStage().enemies:toTable()
			if #enemyOptions < 1 then
				aD.card = MonsterCard.find("Sand Crab")
			else
				local failsafe = 0
				repeat
					failsafe = failsafe + 1
					aD.card = table.random(enemyOptions)
				until (aD.card.cost < 500 and aD.card.type == "classic") or failsafe >= 30
				if failsafe >= 30 then
					aD.card = MonsterCard.find("Sand Crab")
				end
			end
			aD.timer = aD.card.cost
		end
		aD.minionCount = 0
		aD.eliteVar = 1
	end
end)

local enemies = ParentObject.find("enemies")

spawnBabyFunc = setFunc(function(actor, parent, eID, cardID)
	local eliteType = EliteType.fromID(eID)
	local monsterCard = MonsterCard.fromID(cardID)
	local actorData = actor:getData()
	monsterCard.eliteTypes:add(eliteType)
	actorData.evoker = parent.id
	parent:getData().minionCount = parent:getData().minionCount + 1
	actor:makeElite(eliteType)
	monsterCard.eliteTypes:remove(eliteType)
	actor:set("maxhp", (math.round(((actor:get("maxhp") / 2.6) * 0.75))))
	actor:set("hp", actor:get("maxhp"))
	actor:set("damage", (math.round(((actor:get("damage") / 1.7) * 0.75))))
	actor:set("exp_worth", (math.round(((actor:get("exp_worth") / 2) * 0.5))))
	actor:set("cdr", actor:get("cdr") - 0.3)
	actor:set("knockback_cap", actor:get("knockback_cap") / 3)
	actorData.terezi = 1
	if eID == bIDb then
		actorData.sparkleCD = 15
	end
end)

registercallback("onStep", function()
	if net.host and misc.getTimeStop() == 0 then
		for _, i in ipairs(enemies:findMatching("elite_type", ID)) do
			local aD = i:getData()
			if aD.eliteVar == 1 then
			if aD.minionCount < 3 then
				aD.pointTimer = aD.pointTimer + 1
			end
			if aD.pointTimer >= 60 then
				aD.points = aD.points + 1 + misc.director:get("stages_passed")
				aD.pointTimer = 0
			end
			if aD.points >= aD.timer and aD.minionCount < 3 then
				local heightLevel = 1

				local groundLevel = 1
				local groundC1 = Object.find("B"):findLine(i.x, i.y, i.x, i.y + 20)
				if groundC1 then groundC1 = groundC1.y end
					local groundC2 = Object.find("BNoSpawn"):findLine(i.x, i.y, i.x, i.y + 20)
					if groundC2 then groundC2 = groundC2.y end
					if groundC1 and groundC2 then
						if groundC2 < groundC1 then
							groundLevel = groundC2
						else
							groundLevel = groundC1
						end
					elseif groundC1 then
						groundLevel = groundC1
					elseif groundC2 then
						groundLevel = groundC2
					end

					local ceilLevel = 1
					local ceilC1 = Object.find("B"):findLine(i.x, i.y, i.x, i.y - 50)
					if ceilC1 then
						ceilC1 = ceilC1.y + (ceilC1:get("height_box") * 16)
					end
					local ceilC2 = Object.find("BNoSpawn"):findLine(i.x, i.y, i.x, i.y - 50)
					if ceilC2 then
						ceilC2 = ceilC2.y + (ceilC2:get("height_box") * 16)
					end
					if ceilC1 and ceilC2 then
						if ceilC2 > ceilC1 then
							ceilLevel = ceilC2
						else
							ceilLevel = ceilC1
						end
					elseif ceilC1 then
						ceilLevel = ceilC1
					elseif ceilC2 then
						ceilLevel = ceilC2
					end

					if ceilLevel and groundLevel then
						heightLevel = groundLevel - ceilLevel
					end
					if aD.card.object.sprite.height < heightLevel then
						--print("aaaaaaaah")
						--print("Ground at Y"..groundLevel)
						--print("Ceiling at Y"..ceilLevel)
						--print(heightLevel)
						aD.points = aD.points - aD.timer
						local newGuy = createSynced(aD.card.object, i.x, groundLevel - aD.card.object.sprite.height + aD.card.object.sprite.yorigin, spawnBabyFunc, i, IDb, aD.card.id)
						local enemyOptions = Stage.getCurrentStage().enemies:toTable()
						if #enemyOptions < 1 then
							aD.card = MonsterCard.find("Sand Crab")
						else
							local failsafe = 0
							repeat
								failsafe = failsafe + 1
								aD.card = table.random(enemyOptions)
							until (aD.card.cost < 500 and aD.card.type == "classic") or failsafe >= 30
							if failsafe >= 30 then
								aD.card = MonsterCard.find("Sand Crab")
							end
						end
						aD.timer = aD.card.cost
					end
				end
			end
		end
		for _, i in ipairs(enemies:findMatching("elite_type", bID)) do
				local aD = i:getData()
				if aD.eliteVar == 1 then
					if aD.minionCount < 4 then
						aD.pointTimer = aD.pointTimer + 1
					end
					if aD.pointTimer >= 60 then
						aD.points = aD.points + 1 + misc.director:get("stages_passed")
						aD.pointTimer = 0
					end
					if aD.points >= aD.timer and aD.minionCount < 4 then
						local heightLevel = 1
						
						local groundLevel = 1
						local groundC1 = Object.find("B"):findLine(i.x, i.y, i.x, i.y + 20)
						if groundC1 then groundC1 = groundC1.y end
						local groundC2 = Object.find("BNoSpawn"):findLine(i.x, i.y, i.x, i.y + 20)
						if groundC2 then groundC2 = groundC2.y end
						if groundC1 and groundC2 then
							if groundC2 < groundC1 then
								groundLevel = groundC2
							else
								groundLevel = groundC1
							end
					elseif groundC1 then
						groundLevel = groundC1
					elseif groundC2 then
						groundLevel = groundC2
					end
					
					local ceilLevel = 1
					local ceilC1 = Object.find("B"):findLine(i.x, i.y, i.x, i.y - 50)
					if ceilC1 then
						ceilC1 = ceilC1.y + (ceilC1:get("height_box") * 16)
					end
					local ceilC2 = Object.find("BNoSpawn"):findLine(i.x, i.y, i.x, i.y - 50)
					if ceilC2 then
						ceilC2 = ceilC2.y + (ceilC2:get("height_box") * 16)
					end
					if ceilC1 and ceilC2 then
						if ceilC2 > ceilC1 then
							ceilLevel = ceilC2
						else
							ceilLevel = ceilC1
						end
					elseif ceilC1 then
						ceilLevel = ceilC1
					elseif ceilC2 then
						ceilLevel = ceilC2
					end

					if ceilLevel and groundLevel then
						heightLevel = groundLevel - ceilLevel
					end
					if aD.card.object.sprite.height < heightLevel then
						aD.points = aD.points - aD.timer
						local newGuy = createSynced(aD.card.object, i.x, groundLevel - aD.card.object.sprite.height + aD.card.object.sprite.yorigin, spawnBabyFunc, i, bIDb, aD.card.id)
						local enemyOptions = Stage.getCurrentStage().enemies:toTable()
						if #enemyOptions < 1 then
							aD.card = MonsterCard.find("Sand Crab")
						else
							local failsafe = 0
							repeat
								failsafe = failsafe + 1
								aD.card = table.random(enemyOptions)
							until (aD.card.cost < 500 and aD.card.type == "classic") or failsafe >= 30
							if failsafe >= 30 then
								aD.card = MonsterCard.find("Sand Crab")
							end
						end
						aD.timer = aD.card.cost
					end
				end
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
		if not aD.terezi and i:getObject() ~= Object.find("Beta Construct Head") then
			if i:get("team") == "enemy" then
				local replacement = i:getObject():create(i.x, i.y)
				replacement:makeElite()
				i:delete()
			end
		end
	end
	for _, i in ipairs(enemies:findMatching("elite_type", IDb)) do
		local aD = i:getData()
		if not aD.terezi and i:getObject() ~= Object.find("Beta Construct Head") then
			local replacement = i:getObject():create(i.x, i.y)
			replacement:makeElite()
			i:delete()
		end
	end
	for _, i in ipairs(enemies:findMatching("elite_type", bIDb)) do
		local aD = i:getData()
		if aD.sparkleCD and aD.sparkleCD > 0 then aD.sparkleCD = aD.sparkleCD - 1 end
		if aD.sparkleCD and aD.sparkleCD <= 0 then
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
end, 500)
