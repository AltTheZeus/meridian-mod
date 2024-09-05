local elite = EliteType.new("forsaken")
local sprPal = Sprite.load("Elites/forsakenPal", 1, 0, 0)
local ID = elite.ID
local bID = EliteType.find("blessed").ID

elite.displayName = "Forsaken"
elite.color = Color.fromRGB(228, 205, 123)
elite.palette = sprPal

for _, i in ipairs(MonsterCard.findAll("vanilla")) do
	i.eliteTypes:add(elite)
end

registercallback("postLoad", function()
for _, m in ipairs(modloader.getMods()) do
	for _, i in ipairs(MonsterCard.findAll(m)) do
		i.eliteTypes:add(elite)
	end
end
end)

local enemies = ParentObject.find("enemies")

registercallback("onPlayerInit", function(player)
	local pD = player:getData()
	pD.lockTimer = {0,0,0,0,0}
end)

--manifreakinglovethemacrobestheyreliterallythebest

function CheckValid(anInstance)
	return anInstance and anInstance:isValid()
end

registercallback("onDamage", function(target, damage, source)
if Difficulty.getActive().forceHardElites == true or misc.director:get("stages_passed") >= 2 then
	if not CheckValid(source) then return end
	if isa(source, "Instance") and (source:getObject() == Object.find("ChainLightning") or source:getObject() == Object.find("MushDust") or source:getObject() == Object.find("FireTrail") or source:getObject() == Object.find("DoT")) then return end
	if target:isValid() and isa(target, "PlayerInstance") then
		if source:get("elite_type") == ID or ((source:get("parent") and CheckValid(Object.findInstance(source:get("parent")))) and source:getParent():get("elite_type") == ID) then
			local tD = target:getData()
			if tD.lockTimer[1] < 1 and tD.lockTimer[2] < 1 and tD.lockTimer[3] < 1 and tD.lockTimer[4] < 1 then 
				local lockedSkill = math.random(2,5)
				target:setAlarm(lockedSkill, target:getAlarm(lockedSkill) + 120)
				tD.lockTimer[lockedSkill] = tD.lockTimer[lockedSkill] + 120
			end
		end
	end
	if not CheckValid(source) then return end
	if isa(source, "Instance") and (source:getObject() == Object.find("ChainLightning") or source:getObject() == Object.find("MushDust") or source:getObject() == Object.find("FireTrail") or source:getObject() == Object.find("DoT")) then return end
	if target:isValid() and isa(target, "PlayerInstance") then
		if source:get("elite_type") == ID or ((source:get("parent") and CheckValid(Object.findInstance(source:get("parent")))) and source:getParent():get("elite_type") == ID) then
			local lockedSkill = math.random(2,5)
			local tD = target:getData()
			target:setAlarm(lockedSkill, target:getAlarm(lockedSkill) + 120)
			tD.lockTimer[lockedSkill] = tD.lockTimer[lockedSkill] + 120
		end
	end
end
end)

registercallback("onPlayerStep", function(player)
	local pD = player:getData()
	if pD.lockTimer[2] > 0 then
		pD.lockTimer[2] = pD.lockTimer[2] - 1
		if pD.lockTimer[2] <= 0 then
			pD.lockTimer[2] = 0
		end
	end
	if pD.lockTimer[3] > 0 then
		pD.lockTimer[3] = pD.lockTimer[3] - 1
		if pD.lockTimer[3] <= 0 then
			pD.lockTimer[3] = 0
		end
	end
	if pD.lockTimer[4] > 0 then
		pD.lockTimer[4] = pD.lockTimer[4] - 1
		if pD.lockTimer[4] <= 0 then
			pD.lockTimer[4] = 0
		end
	end
	if pD.lockTimer[5] > 0 then
		pD.lockTimer[5] = pD.lockTimer[5] - 1
		if pD.lockTimer[5] <= 0 then
			pD.lockTimer[5] = 0
		end
	end
end)

local lockSprite = Sprite.find("mobSkills")
registercallback("onPlayerHUDDraw", function(player, x, y)
	local pD = player:getData()
	for i, k in pairs(pD.lockTimer) do
		if pD.lockTimer[i] > 0 then
			graphics.drawImage{lockSprite, x + ((23 * i) - 46), y, 2}
		end
	end
end)

--math.round(((i:get("maxhp") / Difficulty.getScaling(hp)) * 0.15))

registercallback("onDraw", function()
	for _, i in ipairs(enemies:findMatching("elite_type", ID)) do
		local iD = i:getData()
		local radiusInner
		local radiusOuter
		if i:get("show_boss_health") == 1 then
			radiusInner = 80
			radiusOuter = 120
		else
			radiusInner = 50
			radiusOuter = 75
		end
		graphics.color(Color.fromRGB(57, 92, 90))
--		graphics.alpha(0.2)
--		graphics.circle(i.x, i.y, radius, false)
		graphics.alpha(1)
		graphics.circle(i.x, i.y, radiusInner, true)
		graphics.circle(i.x, i.y, radiusOuter, true)
	end
	for _, i in ipairs(enemies:findMatching("elite_type", bID)) do
		local iD = i:getData()
		local radiusInner
		local radiusOuter
		if i:get("show_boss_health") == 1 then
			radiusInner = 80
			radiusOuter = 120
		else
			radiusInner = 50
			radiusOuter = 75
		end
		graphics.color(Color.fromRGB(255, 237, 187))
--		graphics.alpha(0.2)
--		graphics.circle(i.x, i.y, radius, false)
		graphics.alpha(1)
		graphics.circle(i.x, i.y, radiusInner, true)
		graphics.circle(i.x, i.y, radiusOuter, true)
	end

end)

local slimed = Buff.find("slow")
local everyone = ParentObject.find("actors")

registercallback("onStep", function()
	for _, i in ipairs(enemies:findMatching("elite_type", ID)) do
		local iD = i:getData()
		local radiusInner
		local radiusOuter
		if i:get("show_boss_health") == 1 then
			radiusInner = 80
			radiusOuter = 120
		else
			radiusInner = 50
			radiusOuter = 75
		end
		for _, a in ipairs(everyone:findAllEllipse(i.x + radiusOuter, i.y + radiusOuter, i.x - radiusOuter, i.y - radiusOuter)) do
			if ((((math.sign(a.x - i.x) * (a.x - i.x)) * (math.sign(a.x - i.x) * (a.x - i.x))) + ((math.sign(a.y - i.y) * (a.y - i.y)) * (math.sign(a.x - i.y) * (a.y - i.y)))) ^ 0.5) >= radiusInner then
				if i:getAccessor().team == "enemy" then
					if a:getAccessor().team == "player" then
						a:applyBuff(slimed, 2)
					end
				elseif i:getAccessor().team == "player" then
					if a:getAccessor().team == "enemy" then
						a:applyBuff(slimed, 2)
					end
				end
			end
		end
	end
	for _, i in ipairs(enemies:findMatching("elite_type", bID)) do
		local iD = i:getData()
		local radiusInner
		local radiusOuter
		if i:get("show_boss_health") == 1 then
			radiusInner = 80
			radiusOuter = 120
		else
			radiusInner = 50
			radiusOuter = 75
		end
		for _, a in ipairs(everyone:findAllEllipse(i.x + radiusOuter, i.y + radiusOuter, i.x - radiusOuter, i.y - radiusOuter)) do
			if ((((math.sign(a.x - i.x) * (a.x - i.x)) * (math.sign(a.x - i.x) * (a.x - i.x))) + ((math.sign(a.y - i.y) * (a.y - i.y)) * (math.sign(a.x - i.y) * (a.y - i.y)))) ^ 0.5) >= radiusInner then
				if i:getAccessor().team == "enemy" then
					if a:getAccessor().team == "player" then
						a:applyBuff(slimed, 2)
					end
				elseif i:getAccessor().team == "player" then
					if a:getAccessor().team == "enemy" then
						a:applyBuff(slimed, 2)
					end
				end
			end
		end
	end

end)
