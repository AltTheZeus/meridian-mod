local item = Item("Snowball")

item.pickupText = "The snowball effect." 

item.sprite = Sprite.load("Items/snowball.png", 1, 15, 15)
item:setTier("rare")

local Ef1 = ParticleType.new("snowballEf1")
Ef1:sprite(Sprite.load("Items/snowballEf1.png", 1, 0, 0), false, false, false)
Ef1:alpha(1, 0.7, 0)
Ef1:size(0.8, 1.2, 0, 0)
Ef1:angle(0, 360, 0, 3, true)
Ef1:speed(0.4, 1, 0, 0)
Ef1:direction(180, 360, 0, 1)
Ef1:gravity(0.02, 270)
Ef1:life(120, 180)

local Ef2 = ParticleType.new("snowballEf2")
Ef2:sprite(Sprite.load("Items/snowballEf2.png", 2, 1, 1), false, false, true)
Ef2:alpha(1, 0.7, 0)
Ef2:size(0.8, 1.2, 0, 0)
Ef2:angle(0, 360, 0, 3, true)
Ef2:speed(0.4, 1, 0, 0)
Ef2:direction(180, 360, 0, 1)
Ef2:gravity(0.02, 270)
Ef2:life(120, 180)

local Ef3 = ParticleType.new("snowballEf3")
Ef3:sprite(Sprite.load("Items/snowballEf3.png", 2, 1, 1), false, false, true)
Ef3:alpha(1, 0.7, 0)
Ef3:size(0.8, 1.2, 0, 0)
Ef3:angle(0, 360, 0, 3, true)
Ef3:speed(0.4, 1, 0, 0)
Ef3:direction(180, 360, 0, 1)
Ef3:gravity(0.02, 270)
Ef3:life(120, 180)

local Ef4 = ParticleType.new("snowballEf4")
Ef4:sprite(Sprite.load("Items/snowballEf4.png", 2, 2, 2), false, false, true)
Ef4:alpha(1, 0.7, 0)
Ef4:size(0.8, 1.2, 0, 0)
Ef4:angle(0, 360, 0, 3, true)
Ef4:speed(0.4, 1, 0, 0)
Ef4:direction(180, 360, 0, 1)
Ef4:gravity(0.02, 270)
Ef4:life(120, 180)

local Ef5 = ParticleType.new("snowballEf5")
Ef5:sprite(Sprite.load("Items/snowballEf5.png", 1, 4, 4), false, false, false)
Ef5:alpha(1, 0.7, 0)
Ef5:size(0.8, 1.2, 0, 0)
Ef5:angle(0, 360, 0, 3, true)
Ef5:speed(0.4, 1, 0, 0)
Ef5:direction(180, 360, 0, 1)
Ef5:gravity(0.02, 270)
Ef5:life(120, 180)

registercallback("onFireSetProcs", function(damager, parent)
	if parent:getObject() == Object.find("p") then
		if parent:countItem(item) > 0 then
			local dD = damager:getData()
			dD.balling = parent:countItem(item)
			dD.ballParent = parent
		end
	end
end)

registercallback("preHit", function(damager, hit)
	local dD = damager:getData()
	if dD.balling and dD.balling > 0 then
--		print(damager:get("damage"))
		local raw = damager:get("damage") / dD.ballParent:get("damage")
--		print("raw: "..raw)
		local damCheck = 0
		local counter = 0
			repeat
				damCheck = damCheck + 0.02 + (dD.balling * 0.01)
				counter = counter + 0.1
			until counter >= raw
		damager:set("damage", damager:get("damage") + damCheck)
		damager:set("damage_fake", damager:get("damage_fake") + damCheck)
		local pX = dD.ballParent.x
		local pY = dD.ballParent.y
		local tX = hit.x
		local tY = hit.y
		local inbetween = math.round(damCheck + 1)
		if inbetween > 5 then
			inbetween = 5
		end
		local efType = "snowballEf" .. inbetween
		if pX < tX then
			for i = pX, tX, 5 do
				local yMult
				if pY < tY then
					yMult = 1
				elseif pY > tY then
					yMult = -1
				else
					yMult = 0
				end
				local totChecker = math.round(math.abs(pX - tX)/5)
				local yLimiter = math.abs(pY - tY)
				local yCalc = math.abs(pX - i)
				local yAmount = yLimiter/totChecker
				ParticleType.find(efType):burst("above", i, pY + (yMult * (yAmount * (math.abs(yCalc/5)))), 1)
			end
		elseif pX > tX then
			for i = tX, pX, 5 do
				local yMult
				if pY < tY then
					yMult = 1
				elseif pY > tY then
					yMult = -1
				else
					yMult = 0
				end
				local totChecker = math.round(math.abs(pX - tX)/5)
				local yLimiter = math.abs(pY - tY)
				local yCalc = math.abs(pX - i)
				local yAmount = yLimiter/totChecker
				ParticleType.find(efType):burst("above", i, pY + (yMult * (yAmount * (math.abs(yCalc/5)))), 1)
			end
		elseif pX == tX then
			ParticleType.find(efType):burst("above", pX, pY, 20)
		end
--		print(damager:get("damage"))
	end
end)

item:setLog{
    group = "rare_locked",
    description = "Increase the damage of attacks based on the damage of the attack. The higher the damage, the more extra damage is added.",
    priority = "&r&High Priority/Fragile&!&",
    destination = "7 Backways Crescent,\nWintersphere,\nPluto",
    date = "2/7/2056",
    story = "haha! think fast!"
}

local ach = Achievement.new("snowballitem")
ach.requirement = 1
ach.deathReset = true
ach.description = "Visit 3 Meridian Stages in one run."
ach:assignUnlockable(item)

registercallback("onPlayerInit", function(player)
	local pD = player:getData()
	pD.achSnow = 0
end)

registercallback("onStageEntry", function()
	if Stage.getCurrentStage():getOrigin() == "meridian" then
		for _, i in ipairs (misc.players) do
			local iD = i:getData()
			iD.achSnow = iD.achSnow + 1
			if iD.achSnow == 3 then
				ach:increment(1)
			end
		end
	end
end)