local elite = EliteType.new("forsaken")
local sprPal = Sprite.load("Elites/forsakenPal", 1, 0, 0)
local ID = elite.ID
local bID = EliteType.find("blessed").ID

elite.displayName = "Forsaken"
elite.color = Color.fromRGB(228, 205, 123)
elite.palette = sprPal

registercallback("onEliteInit", function(actor)
	local aD = actor:getData()
	if actor:get("elite_type") == ID or actor:get("elite_type") == bID then
		aD.eliteVar = 1
	end
end)

local enemies = ParentObject.find("enemies")

registercallback("onPlayerInit", function(player)
	local pD = player:getData()
	pD.lockCountdown = 0
	pD.lockTimer = {0,0,0,0,0}
	pD.lockEfTimer = 0
end)

--manifreakinglovethemacrobestheyreliterallythebest

function CheckValid(anInstance)
	return anInstance and anInstance:isValid()
end

local chainsEf = Object.new("forsakenChains")
chainsEf.sprite = Sprite.load("Elites/forsakenEf.png", 13, 23, 60)
local chainsBlessed = Sprite.load("Elites/forsakenEfBlessed.png", 13, 23, 60)
local clang = Sound.load("Elites/ForsakenChains")
chainsEf.depth = -14

chainsEf:addCallback("create", function(self)
	local sD = self:getData()
	sD.life = 0
	self.spriteSpeed = 0.26
	sD.life2 = 0
end)

chainsEf:addCallback("step", function(self)
	local sD = self:getData()
	sD.life2 = sD.life2 + 1
	if sD.life2 >= 60 then
		self.spriteSpeed = 0.26
	end
	if self.subimage >= 10 and self.subimage < 11 then
		self.spriteSpeed = 0.05
	end
	if self.subimage >= 13 then
		sD.life = 1
	end
	if sD.life == 1 and self.subimage <= 2 then
		self:destroy()
	end
end)


registercallback("onDamage", function(target, damage, source)
if Difficulty.getActive().forceHardElites == true or misc.director:get("stages_passed") >= 2 then
	if source == target then return end
	if not CheckValid(source) then return end
	if isa(source, "Instance") and (source:getObject() == Object.find("ChainLightning") or source:getObject() == Object.find("MushDust") or source:getObject() == Object.find("FireTrail") or source:getObject() == Object.find("DoT")) then return end
	if target:isValid() and isa(target, "PlayerInstance") then
		if (source:get("elite_type") == ID and (source:getData().eliteVar == 1 or source:getObject() == Object.find("Worm") or source:getObject() == Object.find("WormHead") or source:getObject() == Object.find("WormBody"))) or (((source:get("parent") and CheckValid(Object.findInstance(source:get("parent")))) and source:getParent():get("elite_type") == ID) and (source:getParent():getData().eliteVar == 1 or source:getParent():getObject() == Object.find("Worm") or source:getParent():getObject() == Object.find("WormHead") or source:getParent():getObject() == Object.find("WormBody"))) then
			local tD = target:getData()
			if tD.lockTimer[1] < 1 and tD.lockTimer[2] < 1 and tD.lockTimer[3] < 1 and tD.lockTimer[4] < 1 and tD.lockCountdown <= 1 then 
				tD.lockCountdown = 60
				tD.nextChains = nil
			end
		end
		if (source:get("elite_type") == bID and source:getData().eliteVar == 1) or (((source:get("parent") and CheckValid(Object.findInstance(source:get("parent")))) and source:getParent():get("elite_type") == bID) and source:getParent():getData().eliteVar == 1) then
			local tD = target:getData()
			if tD.lockTimer[1] < 1 and tD.lockTimer[2] < 1 and tD.lockTimer[3] < 1 and tD.lockTimer[4] < 1 and tD.lockCountdown <= 1 then
				tD.lockCountdown = 60
				tD.nextChains = chainsBlessed
			end
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

local warnLock = Sprite.load("Elites/forsakenEf3", 0, 0, 0)
local lockSprite = Sprite.load("Elites/forsakenEf2", 4, 0, 0)
registercallback("onPlayerDrawAbove", function(player)
	local pD = player:getData()
	if pD.lockCountdown > 0 then
		pD.lockCountdown = pD.lockCountdown - 1
	end
	if pD.lockCountdown == 1 then
		local lockedSkill = math.random(2,5)
		player:setAlarm(lockedSkill, player:getAlarm(lockedSkill) + 120)
		pD.lockTimer[lockedSkill] = pD.lockTimer[lockedSkill] + 120
		pD.lockEfTimer = 0
		local chainsYay = chainsEf:create(player.x, player.y)
		if pD.nextChains and pD.nextChains == chainsBlessed then
			chainsYay.sprite = chainsBlessed
		end
		clang:play(1, 0.6)
	end
	if pD.lockCountdown >= 1 then
		graphics.drawImage{warnLock, player.x + 9, player.y - 5, alpha = 1 - (pD.lockCountdown/100)}
	end
end)

registercallback("onPlayerHUDDraw", function(player, x, y)
	local pD = player:getData()
	for i, k in pairs(pD.lockTimer) do
		if pD.lockTimer[i] > 0 then
			local sub
			if pD.lockEfTimer <= 9 then
				sub = 1
			elseif pD.lockEfTimer <= 19 then
				sub = 2
			elseif pD.lockEfTimer <= 29 then
				sub = 3
			else
				sub = 4
			end
			graphics.drawImage{lockSprite, x + ((23 * i) - 46), y, sub}
			pD.lockEfTimer = pD.lockEfTimer + 1
		end
	end
end)

--math.round(((i:get("maxhp") / Difficulty.getScaling(hp)) * 0.15))

registercallback("onDraw", function()
	for _, i in ipairs(enemies:findMatching("elite_type", ID)) do
		local iD = i:getData()
		if (i:getData().eliteVar == 1 or i:getObject() == Object.find("Worm") or i:getObject() == Object.find("WormHead") or i:getObject() == Object.find("WormBody")) and i.visible == true then
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
--			graphics.alpha(0.2)
--			graphics.circle(i.x, i.y, radius, false)
			graphics.alpha(1)
			graphics.circle(i.x, i.y, radiusInner, true)
			graphics.circle(i.x, i.y, radiusOuter, true)
		end
	end
	for _, i in ipairs(enemies:findMatching("elite_type", bID)) do
		local iD = i:getData()
		if i:getData().eliteVar == 1 and i.visible == true then
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
--			graphics.alpha(0.2)
--			graphics.circle(i.x, i.y, radius, false)
			graphics.alpha(1)
			graphics.circle(i.x, i.y, radiusInner, true)
			graphics.circle(i.x, i.y, radiusOuter, true)
		end
	end
end)

local slimed = Buff.find("slow")
local everyone = ParentObject.find("actors")

registercallback("onStep", function()
	for _, i in ipairs(enemies:findMatching("elite_type", ID)) do
		local iD = i:getData()
		if i:getData().eliteVar == 1 or i:getObject() == Object.find("Worm") or i:getObject() == Object.find("WormHead") or i:getObject() == Object.find("WormBody") then
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
			if ((((math.sign(a.x - i.x) * (a.x - i.x)) * (math.sign(a.x - i.x) * (a.x - i.x))) + ((math.sign(a.y - i.y) * (a.y - i.y)) * (math.sign(a.y - i.y) * (a.y - i.y)))) ^ 0.5) >= radiusInner then
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
	end
	for _, i in ipairs(enemies:findMatching("elite_type", bID)) do
		local iD = i:getData()
		if i:getData().eliteVar == 1 then
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
			if ((((math.sign(a.x - i.x) * (a.x - i.x)) * (math.sign(a.x - i.x) * (a.x - i.x))) + ((math.sign(a.y - i.y) * (a.y - i.y)) * (math.sign(a.y - i.y) * (a.y - i.y)))) ^ 0.5) >= radiusInner then
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
	end

end)

--oh, worm?
local bodySpr = Sprite.load("Elites/forsakenWormBody", 3, 15, 19)
local headSpr = Sprite.load("Elites/forsakenWormHead", 6, 15, 19)

registercallback("onStep", function()
	for _, i in ipairs(Object.find("Worm"):findAll()) do
		if i:get("elite_type") == ID and not i:getData().changed then
			i:set("name", "Forsaken Worm")
			i:set("name2", "The Great Inhibitor")
			i.blendColor = Color.WHITE
			i:getData().changed = 1
		end
	end
	for _, i in ipairs(Object.find("WormBody"):findAll()) do
		if i:get("elite_type") == ID and not i:getData().changed then
			i.sprite = bodySpr
			i.blendColor = Color.WHITE
			i:getData().changed = 1
		end
	end
	for _, i in ipairs(Object.find("WormHead"):findAll()) do
		if i:get("elite_type") == ID and not i:getData().changed then
			i.sprite = headSpr
			i.blendColor = Color.WHITE
			i:getData().changed = 1
		end
	end
end)