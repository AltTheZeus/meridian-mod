local elite = EliteType.new("sorrow")
local sprPal = Sprite.load("Elites/sorrowPal", 1, 0, 0)
local ID = elite.ID
local bID = EliteType.find("blessed").ID

elite.displayName = "Sorrowful"
elite.color = Color.fromRGB(146, 66, 63)
elite.palette = sprPal

for _, i in ipairs(MonsterCard.findAll("vanilla")) do
	if i ~= MonsterCard.find("Magma Worm", "vanilla") then
		i.eliteTypes:add(elite)
	end
end

registercallback("postLoad", function()
for _, m in ipairs(modloader.getMods()) do
	for _, i in ipairs(MonsterCard.findAll(m)) do
		if m == "Starstorm" then
			if i ~= MonsterCard.find("Squall Elver") then
				i.eliteTypes:add(elite)
			end
		else
			i.eliteTypes:add(elite)
		end
	end
end
end)

local enemies = ParentObject.find("enemies")
local shat1 = Buff.find("sunder1", "vanilla")

function CheckValid(anInstance)
	return anInstance and anInstance:isValid()
end

--[[registercallback("onDamage", function(target, damage, source)
	if source == target then return end
	if not CheckValid(source) then return end
	if isa(source, "Instance") and (source:getObject() == Object.find("ChainLightning") or source:getObject() == Object.find("MushDust") or source:getObject() == Object.find("FireTrail") or source:getObject() == Object.find("DoT")) then return end
	if target:isValid() and isa(target, "PlayerInstance") then
		if source:get("elite_type") == ID or ((source:get("parent") and CheckValid(Object.findInstance(source:get("parent")))) and source:getParent():get("elite_type") == ID) then
			target:applyBuff(shat1, 120)
		end
	end
	if isa(source, "Instance") and (source:getObject() == Object.find("ChainLightning") or source:getObject() == Object.find("MushDust") or source:getObject() == Object.find("FireTrail") or source:getObject() == Object.find("DoT")) then return end
	if target:isValid() and isa(target, "PlayerInstance") then
		if source:get("elite_type") == bID or ((source:get("parent") and CheckValid(Object.findInstance(source:get("parent")))) and source:getParent():get("elite_type") == bID) then
			target:applyBuff(shat1, 120)
		end
	end
end)]]

local shieldEf = Object.new("sorrowShield")
shieldEf.sprite = Sprite.load("Elites/sorrowEf.png", 3, 13, 28)
local shieldBlessed = Sprite.load("Elites/sorrowEfBlessed.png", 3, 13, 28)

shieldEf:addCallback("create", function(self)
	local sD = self:getData()
	sD.life = 0
	self.spriteSpeed = 0
end)

shieldEf:addCallback("step", function(self)
	local sD = self:getData()
	sD.life = sD.life + 1
	if sD.life >= 10 and sD.life < 22 then
		self.subimage = 2
	end
	if sD.life >= 22 then
		self.subimage = 3
	end
	if sD.life >= 45 then
		self.y = self.y - 0.2
	end
	if sD.life >= 60 then
		self.alpha = self.alpha - 0.04
	end
	if self.alpha <= 0 then
		self:destroy()
	end
end)

registercallback("preHit", function(damager, hit)
	if Difficulty.getActive().forceHardElites == true or misc.director:get("stages_passed") >= 2 then
		if hit:isValid() and (hit:get("elite_type") == ID or hit:get("elite_type") == bID) then
			if damager:get("damage") > math.round(hit:get("maxhp") * 0.05) then
				damager:set("damage", math.round(hit:get("maxhp") * 0.05))
				damager:set("damage_fake", math.round(hit:get("maxhp") * 0.05))
				Sound.find("Crit"):play(0.4, 1.2)
				local shield = Object.find("EfOutline"):create(hit.x, hit.y)
				shield:set("parent", hit.id)
				if (hit:get("elite_type")) == ID then
					shield.blendColor = Color.fromRGB(104, 90, 90)
					shieldEf:create(hit.x, hit.y - 20)
				elseif (hit:get("elite_type")) == bID then
					shield.blendColor = Color.fromRGB(255, 237, 187)
					local bShield = shieldEf:create(hit.x, hit.y - 20)
					bShield.sprite = shieldBlessed
				end
			end
			damager:set("damage", damager:get("damage") * (100 / (100 + hit:getData().sorrowArmor)))
			damager:set("damage_fake", damager:get("damage_fake") * (100 / (100 + hit:getData().sorrowArmor)))
			hit:getData().sorrowArmor = hit:getData().sorrowArmor + 5
		end
	end
end)

registercallback("onStep", function()
	for _, i in ipairs(enemies:findAll()) do
	if i:get("elite_type") == ID or i:get("elite_type") == bID then
		local sD = i:getData()
		if sD.sorrowArmorTimer < 20 then
			sD.sorrowArmorTimer = sD.sorrowArmorTimer + 1
		elseif sD.sorrowArmorTimer >= 20 then
			sD.sorrowArmorTimer = 0
			if sD.sorrowArmor > 0 then
				sD.sorrowArmor = sD.sorrowArmor - 1
			end
		end
		print(sD.sorrowArmor)
	end
	end
end)

registercallback("onEliteInit", function(self)
	local sD = self:getData()
	sD.sorrowBuffTimer = 0
	if self:get("elite_type") == ID or self:get("elite_type") == bID then
		sD.sorrowArmor = 0
		sD.sorrowArmorTimer = 0
	end
end)

local sorrowBuff = Buff.new("sorrowBuff")
sorrowBuff.sprite = Sprite.load("Elites/sorrowBuff.png", 1, 10, 0)

sorrowBuff:addCallback("start", function(actor)
	local aD = actor:getData()
	aD.sorrowBuffDam = actor:get("damage") / 5 --buffed from 10%... is it too strong?
	actor:set("damage", actor:get("damage") + aD.sorrowBuffDam)
end)

sorrowBuff:addCallback("step", function(actor)
	local aD = actor:getData()
	aD.sorrowBuffTimer = aD.sorrowBuffTimer - 1
end)

sorrowBuff:addCallback("end", function(actor)
	local aD = actor:getData()
	actor:set("damage", actor:get("damage") - aD.sorrowBuffDam)
end)

local sBoonPart = ParticleType.new("sBoonParticle")
sBoonPart:shape("Smoke")
sBoonPart:scale(0.13, 0.13)
sBoonPart:size(1, 1, -0.01, 0)
sBoonPart:alpha(1, 0.8, 0)
sBoonPart:angle(0, 360, 0, 5, false)
sBoonPart:speed(0, 0, 0, 0)
sBoonPart:direction(0, 0, 0, 0)
sBoonPart:gravity(0, 0)
sBoonPart:life(60, 60)

local sorrowBoon = Object.new("sorrowBoon")

sorrowBoon:addCallback("create", function(self)
	local sD = self:getData()
	sD.life = 0
end)

sorrowBoon:addCallback("step", function(self)
	local sD = self:getData()
	if not sD.targ or sD.targ == nil or not sD.targ:isValid() then self:destroy() return end
	local xVar = (math.sign(self.x - sD.targ.x) * (self.x - sD.targ.x))
	local yVar = (math.sign(self.y - sD.targ.y) * (self.y - sD.targ.y))
	local c2 = (xVar * xVar) + (yVar * yVar)
	sD.cCurrent = c2 ^ 0.5
	sD.life = sD.life + 1
	if not sD.targ or not sD.targ:isValid() then self:destroy() return end
	if sD.life >= 30 then
		local xMath
		local yMath
--[[		if sD.cCurrent <= sD.distance * 0.2 then
			xMath = math.abs(self.x - sD.targ.x)/4
			yMath = math.abs(self.y - sD.targ.y)/4
		elseif sD.cCurrent <= sD.distance/2 then
			xMath = math.abs(self.x - sD.targ.x)/10
			yMath = math.abs(self.y - sD.targ.y)/10
		else
			xMath = math.abs(self.x - sD.targ.x)/100
			yMath = math.abs(self.y - sD.targ.y)/100
		end]]
		xMath = math.abs(self.x - sD.targ.x)/20
		yMath = math.abs(self.y - sD.targ.y)/20
		self.x = math.approach(self.x, sD.targ.x, xMath)
		self.y = math.approach(self.y, sD.targ.y, yMath)
	else
		self.x = math.approach(self.x, sD.dirX, 5)
		self.y = math.approach(self.y, sD.dirY, 5)
	end
	if sD.cCurrent <= 5 then
		sD.targ:getData().sorrowBuffTimer = sD.targ:getData().sorrowBuffTimer + 180
		sD.targ:applyBuff(sorrowBuff, sD.targ:getData().sorrowBuffTimer)
		self:destroy()
--		print("absorbed")
	end
end)

sorrowBoon:addCallback("draw", function(self)
	local sD = self:getData()
	graphics.alpha(0.3)
	graphics.color(sD.type)
	graphics.circle(self.x, self.y, 6, false)
	graphics.alpha(1)
	graphics.circle(self.x, self.y, 3, true)
	local colorCalc = Color.mix(sD.type, Color.WHITE, (sD.cCurrent/sD.distance))
	if sD.cCurrent <= sD.distance and sD.life >= 30 then
		sBoonPart:burst("above", self.x, self.y, 1, colorCalc)
	end
end)

local enemies = ParentObject.find("enemies")
registercallback("onNPCDeath", function(npc)
	local npcX = npc.x
	local npcY = npc.y
	local dD = misc.director:getData()
	if npc:get("team") == "enemy" then
		dD.sorrowSpawnEnemy = 1
		dD.sorrowSpawnEnemyX = npcX
		dD.sorrowSpawnEnemyY = npcY
	end
end)

registercallback("onStep", function()
	local dD = misc.director:getData()
	if dD.sorrowSpawnEnemy and dD.sorrowSpawnEnemy == 1 then
		for _, i in ipairs(enemies:findAll()) do
			if i:get("elite_type") == ID or i:get("elite_type") == bID then
				local xVar = (math.sign(dD.sorrowSpawnEnemyX - i.x) * (dD.sorrowSpawnEnemyX - i.x))
				local yVar = (math.sign(dD.sorrowSpawnEnemyY - i.y) * (dD.sorrowSpawnEnemyY - i.y))
				local c2 = (xVar * xVar) + (yVar * yVar)
				local c = c2 ^ 0.5
				if c <= 100 then
					local myBoon = sorrowBoon:create(dD.sorrowSpawnEnemyX, dD.sorrowSpawnEnemyY)
					local bD = myBoon:getData()
					bD.targ = i
					if i:get("elite_type") == ID then
						bD.type = elite.color
					else
						bD.type = EliteType.find("blessed").color
					end
					bD.dirX = dD.sorrowSpawnEnemyX + math.random(-25, 25)
					bD.dirY = dD.sorrowSpawnEnemyY + math.random(-25, 25)
					bD.distance = c
					bD.cCurrent = 0
					dD.sorrowSpawnEnemy = 0
				end
			end
		end
	end
end)