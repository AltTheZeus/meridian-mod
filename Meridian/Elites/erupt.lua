local elite = EliteType.new("erupt")
local sprPal = Sprite.load("Elites/eruptPal", 1, 0, 0)
local ID = elite.ID
local bID = EliteType.find("blessed").ID

elite.displayName = "Eruptive"
elite.color = Color.fromRGB(184, 20, 56)
elite.palette = sprPal

registercallback("onEliteInit", function(actor)
	local aD = actor:getData()
	if actor:get("elite_type") == ID or actor:get("elite_type") == bID then
		aD.lavaThreshold = 0
		aD.lavad = false
		aD.eliteVar = 1
	end
end)

local enemies = ParentObject.find("enemies")

local lavaObj = Object.new("eruptLava")
lavaObj.sprite = Sprite.load("Elites/eruptEf", 1, 2, 2)
local blessedLava = Sprite.load("Elites/eruptEfBlessed", 1, 2, 2)
local sparkle = ParticleType.find("sparkle")

lavaObj:addCallback("create", function(self)
	local sD = self:getData()
	sD.life = 0
	sD.damageTimer = 0
end)

lavaObj:addCallback("step", function(self)
	local sD = self:getData()
	for _, i in ipairs(lavaObj:findAll()) do
		if self:collidesWith(i, self.x, self.y) and i.id ~= self.id and sD.life == 0 then
			if sD.owner:isValid() then
				sD.owner:getData().lavaThreshold = sD.owner:getData().lavaThreshold + 0.5
			end
			self:destroy()
		end
	end
--	if not sD.owner:isValid() or not sD.owner then
--		self:destroy()
--	end
	sD.life = sD.life + 1
	if sD.life >= 300 then
		self:destroy()
	end
	sD.damageTimer = sD.damageTimer + 1
	if sD.damageTimer == 15 and self:isValid() then
		misc.fireExplosion(self.x + 23, self.y - 4, 22/19, 1, sD.damage * 0.3, sD.team)
		sD.damageTimer = 0
	end
	if sD.life >= 250 then
		self.alpha = self.alpha - 0.02
	end
--[[	if sD.blessed == true then
				local imageX = (self:getObject().sprite.width * 0.5) * math.random(-1, 1)
				local imageY = (self:getObject().sprite.height * 0.5) * math.random(-1, 1)
				xOffset = math.random(-10, 10)
				yOffset = math.random(-10, 10)
				sparkle:burst("above", self.x + xOffset + imageX, self.y + yOffset + imageY, 1)
	end]]
end)

registercallback("onHit", function(damager, hit, x, y)
	if hit:get("elite_type") == ID or hit:get("elite_type") == bID and hit:getData().eliteVar == 1 then
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
				if hit:get("elite_type") == bID then
					myLava.sprite = blessedLava
					myLava:getData().blessed = true
				end
				myLava:getData().team = hit:get("team")
				myLava:getData().owner = hit
				myLava:getData().damage = hit:get("damage") / 2
				hD.lavaThreshold = 0
			end
		end
	end
end)

local smoke = ParticleType.new("eruptDoTSmoke")
smoke:shape("smoke")
smoke:color(Color.fromRGB(235, 126, 12), Color.fromRGB(107, 107, 107), Color.WHITE)
smoke:alpha(0.8, 0.2, 0)
smoke:additive(false)
smoke:size(0.05, 0.1, -0.001, 0.02)
smoke:speed(0.4, 0.6, -0.01, 0)
smoke:direction(75, 105, 0, math.random(0,10))
smoke:gravity(0, 0)
smoke:life(60, 120)
smoke:angle(0, 360, 0, 5, false)

local eruptDoT = Buff.new("eruptDoT")
eruptDoT.sprite = Sprite.load("Elites/eruptBuff.png", 1, 10, 0)

eruptDoT:addCallback("start", function(actor)
	local aD = actor:getData()
	aD.eruptDoTTimer = 0
end)

eruptDoT:addCallback("step", function(actor)
	local aD = actor:getData()
	aD.eruptDoTTimer = aD.eruptDoTTimer + 1
	if aD.eruptDoTTimer % 20 == 0 then
		local bullet = misc.fireBullet(actor.x, actor.y, 180, 3, 2 * Difficulty.getScaling("damage"), "neutral")
		bullet:set("specific_target", actor.id)
	end
	smoke:burst("middle", actor.x, actor.y, 1)
end)

registercallback("onDamage", function(target, damage, source)
if Difficulty.getActive().forceHardElites == true or misc.director:get("stages_passed") >= 2 then
	if source == target then return end
	if not CheckValid(source) then return end
	if isa(source, "Instance") and (source:getObject() == Object.find("ChainLightning") or source:getObject() == Object.find("MushDust") or source:getObject() == Object.find("FireTrail") or source:getObject() == Object.find("DoT")) then return end
	if target:isValid() and isa(target, "PlayerInstance") then
		if (source:get("elite_type") == ID and (source:getData().eliteVar == 1 or source:getObject() == Object.find("Worm") or source:getObject() == Object.find("WormHead") or source:getObject() == Object.find("WormBody"))) or (((source:get("parent") and CheckValid(Object.findInstance(source:get("parent")))) and source:getParent():get("elite_type") == ID) and (source:getParent():getData().eliteVar == 1 or source:getParent():getObject() == Object.find("Worm") or source:getParent():getObject() == Object.find("WormHead") or source:getParent():getObject() == Object.find("WormBody"))) then
			target:applyBuff(eruptDoT, 201)
		end
		if (source:get("elite_type") == bID and source:getData().eliteVar == 1) or (((source:get("parent") and CheckValid(Object.findInstance(source:get("parent")))) and source:getParent():get("elite_type") == bID) and source:getParent():getData().eliteVar == 1) then
			target:applyBuff(eruptDoT, 201)
		end
	end
end
end)