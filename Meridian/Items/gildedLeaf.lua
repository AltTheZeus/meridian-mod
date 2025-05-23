local item = Item("Gilded Leaf")
item.pickupText = "Become an aspect of Divinity." 
item.sprite = Sprite.load("Items/gildedLeaf.png", 1, 15, 15)
item.isUseItem = true
item.useCooldown = 240
item.color = "y"
local playa = Object.find("p")
local enemies = ParentObject.find("enemies")

-- HALO
local halo = Sprite.find("blessedEf")
registercallback("onDraw", function()
	for _, i in ipairs(playa:findAll()) do
		if i.useItem == item then
			local iD = i:getData()
			local idle = i:getAnimation("idle")
			graphics.drawImage{
			image = halo,
			x = i.x,
			y = i.y - idle.yorigin - 5,
			xscale = i.xscale,
			alpha = 1
			}
		end
	end
end)

-- RIPPLING
local bubbleObj = Object.find("bubble")
local spawn = Sound.find("Use", "vanilla")
registercallback("onPlayerStep", function(player)
	local iD = player:getData()
	if player.useItem == item then
		if not iD.bubbleCooldown then iD.bubbleCooldown = 0 end
		if iD.bubbleCooldown > 0 then
			iD.bubbleCooldown = iD.bubbleCooldown - 1
		end
	end
end)

local goldBub = Sprite.find("bubbleBlessed")

registercallback("onDamage", function(target, damage, source)
	if target:isValid() and target:getObject() == playa and target.useItem == item then
		local tD = target:getData()
		if tD.bubbleCooldown <= 0 then
			local bubbleAmount = math.random(1, 3)
			bubbleAmount = math.round(bubbleAmount * (target.sprite.height/8))
			if bubbleAmount <= 1 then bubbleAmount = 1 end
			tD.bubbleCooldown = bubbleAmount * 120
			repeat
				local baby = bubbleObj:create(target.x, target.y)
				local bD = baby:getData()
				bD.owner = target
				bD.friendly = 1
				bD.damage = target:get("damage")
				bD.locX = target.x + math.random(-50, 50)
				bD.locY = target.y + math.random(-50, 50)
				bubbleAmount = bubbleAmount - 1
				baby.sprite = goldBub
				bD.swag = "awesome"
			until bubbleAmount <= 0
			spawn:play()
		end
	end
end)

--FORSAKEN
registercallback("onDraw", function()
	for _, i in ipairs(playa:findAll()) do
		if i.useItem == item then
			local iD = i:getData()
			local radiusInner = 50
			local radiusOuter = 75
			graphics.color(Color.fromRGB(255, 237, 187))
			graphics.alpha(1)
			graphics.circle(i.x, i.y, radiusInner, true)
			graphics.circle(i.x, i.y, radiusOuter, true)
		end
	end
end)

local slimed = Buff.find("slow")
local everyone = ParentObject.find("actors")

registercallback("onPlayerStep", function(player)
	if player.useItem == item then
		local iD = player:getData()
		local radiusInner = 50
		local radiusOuter = 75
		for _, a in ipairs(everyone:findAllEllipse(player.x + radiusOuter, player.y + radiusOuter, player.x - radiusOuter, player.y - radiusOuter)) do
			if ((((math.sign(a.x - player.x) * (a.x - player.x)) * (math.sign(a.x - player.x) * (a.x - player.x))) + ((math.sign(a.y - player.y) * (a.y - player.y)) * (math.sign(a.y - player.y) * (a.y - player.y)))) ^ 0.5) >= radiusInner then
				if a:getAccessor().team == "enemy" then
					a:applyBuff(slimed, 2)
				end
			end
		end
	end
end)

--SORROWFUL
local shieldEf = Object.find("sorrowShield")
local shieldBlessed = Sprite.find("sorrowEfBlessed")

registercallback("onPlayerStep", function(player)
	if player.useItem == item then
		local sD = player:getData()
		if not sD.sorrowArmorTimer then sD.sorrowArmorTimer = 0 end
		if not sD.sorrowArmor then sD.sorrowArmor = 0 end
		if sD.sorrowArmorTimer < 20 then
			sD.sorrowArmorTimer = sD.sorrowArmorTimer + 1
		elseif sD.sorrowArmorTimer >= 20 then
			sD.sorrowArmorTimer = 0
			if sD.sorrowArmor > 0 then
				sD.sorrowArmor = sD.sorrowArmor - 1
			end
		end
	end
end)

registercallback("preHit", function(damager, hit)
	if hit:isValid() and hit:getObject() == playa and hit.useItem == item then
		if damager:get("damage") > math.round(hit:get("maxhp") * 0.4) then
			damager:set("damage", math.round(hit:get("maxhp") * 0.4))
			damager:set("damage_fake", math.round(hit:get("maxhp") * 0.4))
			Sound.find("Crit"):play(0.4, 1.2)
			local shield = Object.find("EfOutline"):create(hit.x, hit.y)
			shield:set("parent", hit.id)
			shield.blendColor = Color.fromRGB(255, 237, 187)
			local bShield = shieldEf:create(hit.x, hit.y - 20)
			bShield.sprite = shieldBlessed
		end
		damager:set("damage", damager:get("damage") * (100 / (100 + hit:getData().sorrowArmor)))
		damager:set("damage_fake", damager:get("damage_fake") * (100 / (100 + hit:getData().sorrowArmor))) 
		hit:getData().sorrowArmor = hit:getData().sorrowArmor + 5
		if hit:getData().sorrowArmor >= 30 then
			hit:getData().sorrowArmor = 30
		end
	end
end)

local sorrowBoon = Object.find("sorrowBoon")
local everyoneever = ParentObject.find("actors")
registercallback("onNPCDeath", function(npc)
	local npcX = npc.x
	local npcY = npc.y
	local dD = misc.director:getData()
	if npc:get("team") == "player" then
		dD.sorrowSpawnPlayer = 1
		dD.sorrowSpawnPlayerX = npcX
		dD.sorrowSpawnPlayerY = npcY
	end
end)

registercallback("onStep", function()
	local dD = misc.director:getData()
	if dD.sorrowSpawnPlayer and dD.sorrowSpawnPlayer == 1 then
		for _, i in ipairs(misc.players) do
			if i.useItem == item then
				local xVar = (math.sign(dD.sorrowSpawnPlayerX - i.x) * (dD.sorrowSpawnPlayerX - i.x))
				local yVar = (math.sign(dD.sorrowSpawnPlayerY - i.y) * (dD.sorrowSpawnPlayerY - i.y))
				local c2 = (xVar * xVar) + (yVar * yVar)
				local c = c2 ^ 0.5
				if c <= 100 then
					local myBoon = sorrowBoon:create(dD.sorrowSpawnPlayerX, dD.sorrowSpawnPlayerY)
					local bD = myBoon:getData()
					bD.targ = i
					bD.type = EliteType.find("blessed").color
					bD.dirX = dD.sorrowSpawnPlayerX + math.random(-25, 25)
					bD.dirY = dD.sorrowSpawnPlayerY + math.random(-25, 25)
					bD.distance = c
					bD.cCurrent = 0
					dD.sorrowSpawnPlayer = 0
				end
			end
		end
	end
end)

--MOLDING
registercallback("onStageEntry", function()
	for _, i in ipairs(playa:findAll()) do
		local aD = i:getData()
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
			aD.minionCount = 0
	end
end)

local eliteBabyBlessed = EliteType.find("gildedClay")

registercallback("onStep", function()
	for _, i in ipairs(playa:findAll()) do
	if i.useItem == item then
		local aD = i:getData()
		if aD.minionCount < 5 then
			aD.pointTimer = aD.pointTimer + 1
		end
		if aD.pointTimer >= 60 then
			aD.points = aD.points + 1 + misc.director:get("stages_passed")
			aD.pointTimer = 0
		end
		if aD.points >= aD.timer and aD.minionCount < 5 then
			aD.points = aD.points - aD.timer
			local height = aD.card.object.sprite.height
			height = height + i.sprite.yorigin
			aD.card.eliteTypes:add(eliteBabyBlessed)
			local newGuy = aD.card.object:create(i.x, i.y - height)
			newGuy:set("team", "player")
			local nD = newGuy:getData()
			nD.terezi = 1
			nD.evoker = i.id
			aD.minionCount = aD.minionCount + 1
			newGuy:makeElite(eliteBabyBlessed)
			aD.card.eliteTypes:remove(eliteBabyBlessed)
				newGuy:set("maxhp", (math.round(((newGuy:get("maxhp") / 2.6) * 0.75))))
				newGuy:set("hp", newGuy:get("maxhp"))
				newGuy:set("damage", (math.round(((newGuy:get("damage") / 1.7) * 0.75))))
				newGuy:set("exp_worth", (math.round(((newGuy:get("exp_worth") / 2) * 0.5))))
				newGuy:set("cdr", newGuy:get("cdr") - 0.3)
				newGuy:set("knockback_cap", newGuy:get("knockback_cap") / 3)
				nD.sparkleCD = 15
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
end)

--ERUPTIVE
registercallback("onPlayerInit", function(player)
	local aD = player:getData()
	aD.lavaThreshold = 0
end)

local lavaObj = Object.find("eruptLava")
local blessedLava = Sprite.find("eruptEfBlessed")

registercallback("onHit", function(damager, hit, x, y)
	if hit:isValid() and hit:getObject() == playa and hit.useItem == item then
		local hD = hit:getData()
		if not hD.lavaThreshold then return end
		hD.lavaThreshold = hD.lavaThreshold + ((damager:get("damage")/hit:get("maxhp")) * 10)
		if hD.lavaThreshold >= 1 then
			local spawnPot
			if hit:collidesWith(Object.find("B"), hit.x, hit.y + (hit.sprite.height - hit.sprite.yorigin) + 1) then
				spawnPot = Object.find("B"):findLine(hit.x, hit.y, hit.x, hit.y + (hit.sprite.height - hit.sprite.yorigin) + 1)
			else return end
			local cSpawn = spawnPot.x
			for i = spawnPot.x, spawnPot.x + (spawnPot:get("width_box") * 16) - 32, 16 do
				if math.abs(hit.x - i) < math.abs(hit.x - cSpawn) then
					cSpawn = i
				end
			end
			if spawnPot:get("width_box") >= 3 then
				local myLava = lavaObj:create(cSpawn - 16, spawnPot.y)
				myLava.sprite = blessedLava
				myLava:getData().blessed = true
				myLava:getData().team = hit:get("team")
				myLava:getData().owner = hit
				myLava:getData().damage = hit:get("damage") / 2
				hD.lavaThreshold = 0
			end
		end
	end
end)

local eruptDoT = Buff.find("eruptDoT")

registercallback("onFireSetProcs", function(damager, parent)
	if parent:getObject() == Object.find("p") and parent.useItem == item then
		local dD = damager:getData()
		dD.erupt = "im erupting"
	end
end)

registercallback("onHit", function(damager, hit, x, y)
	local dD = damager:getData()
	if dD.erupt then
		if hit:get("show_boss_health") == 0 or (hit:get("show_boss_health") == 1 and hit:get("blight_type") ~= -1) then
			hit:applyBuff(eruptDoT, 60)
		end
	end
end)

--TREE
tree = Object.find("Enemy")
item:addCallback("use", function(player, embryo)
		local theTree = tree:create(player.x, player.y)
		local ac = theTree:getAccessor()
		local ad = theTree:getData()
		ac.team = "player"
		ac.maxhp = 300 * Difficulty.getScaling("hp") * 0.5
		ac.hp = ac.maxhp
		ad.isPlayer = 1
	if embryo then
		ac.maxhp = 300 * Difficulty.getScaling("hp")
		ac.hp = ac.maxhp
	end
end)

registercallback("onStageEntry", function()
	for _, i in ipairs(playa:findAll()) do
		if i.useItem == item then
			i:setAlarm(0, 30)
		end
	end
end)

isGilded = false

registercallback("onItemPickup", function(thisItem, thisPlayer)
	local temp = false
	for _, i in ipairs(misc.players) do
		if i.useItem == item then
			temp = true
		end
	end
	isGilded = temp
end)

registercallback("onGameStart", function()
	isGilded = false
end)

local boxArt = Sprite.load("Elites/gildedBox.png", 1, 0, 0)
local box = Object.new("gildedCredits")
box.sprite = boxArt
box.depth = -10000

registercallback("globalRoomStart", function(room)
	if room == Room.find("Credits") and isGilded == true then
		box:create(35, 2)
	end
end)

--color palette :O
--[[registercallback("onPlayerStep", function(player)
	local pD = player:getData()
	if player.useItem == item then
	if not Sprite.find(player.sprite:getName() .. "WHITE") then
	local whiteSpriteSurface = Surface.new(player.sprite.width * player.sprite.frames, player.sprite.height)
	graphics.setTarget(whiteSpriteSurface)
	graphics.setBlendMode("additive")
	for i = 1, player.sprite.frames do
	graphics.drawImage{
		image = player.sprite,
		x = player.sprite.xorigin + (player.sprite.width * (i - 1)),
		y = player.sprite.yorigin,
		subimage = i,
		color = Color.WHITE,
		xscale = 1,
		yscale = 1
		}
	graphics.drawImage{
		image = player.sprite,
		x = player.sprite.xorigin + (player.sprite.width * (i - 1)),
		y = player.sprite.yorigin,
		subimage = i,
		color = Color.WHITE,
		xscale = 1,
		yscale = 1
		}
	graphics.drawImage{
		image = player.sprite,
		x = player.sprite.xorigin + (player.sprite.width * (i - 1)),
		y = player.sprite.yorigin,
		subimage = i,
		color = Color.WHITE,
		xscale = 1,
		yscale = 1
		}
	graphics.drawImage{
		image = player.sprite,
		x = player.sprite.xorigin + (player.sprite.width * (i - 1)),
		y = player.sprite.yorigin,
		subimage = i,
		color = Color.WHITE,
		xscale = 1,
		yscale = 1
		}
	end
	graphics.resetTarget()
	graphics.setBlendMode("normal")
	local temp = whiteSpriteSurface:createSprite(player.sprite.xorigin, player.sprite.yorigin, 0, 0, player.sprite.width, player.sprite.height)
	for i = 1, player.sprite.frames do
--		if i ~= 1 then
			temp:addFrame(whiteSpriteSurface, player.sprite.width * i, 0, player.sprite.width, player.sprite.height)
--		end
	end
	temp:finalize(player.sprite:getName() .. "WHITE")
	end
	end
end)

registercallback("onPlayerDrawAbove", function(player)
	local dD = misc.director:getData()
	if Sprite.find(player.sprite:getName() .. "WHITE") and player.useItem == item then
		local swagSprite = Sprite.find(player.sprite:getName() .. "WHITE")
		graphics.drawImage{
			image = swagSprite,
			x = player.x,
			y = player.y,
			subimage = player.subimage,
			alpha = 0.4, --looks bad with 0.4, looks bad with 0.8.......
			color = Color.fromRGB(255, 237, 187),
			xscale = player.xscale,
			yscale = player.yscale
			}
	end
end)

--TODO: if this is worth keeping, add it to engi turrets, too (or make them look molded? might be fun.) (and make it work with huntress)]]
