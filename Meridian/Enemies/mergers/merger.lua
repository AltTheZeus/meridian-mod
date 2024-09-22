local path = "Enemies/mergers/"
local sprites = {
    idle = Sprite.load("mergerIdle", path.."mergerIdle", 1, 12, 18),
    walk = Sprite.load("mergerWalk", path.."mergerWalk", 8, 12, 19),
    spawn = Sprite.load("mergerSpawn", path.."mergerSpawn", 21, 111, 40),
    death = Sprite.load("mergerDeath", path.."mergerDeath", 15, 61, 81),
    shoot = Sprite.load("mergerShoot", path.."mergerShoot", 8, 34, 27),
    mask = Sprite.load("mergerMask", path.."mergerMask", 1, 11, 18),
    palette = Sprite.load("mergerPal", path.."mergerPal", 1, 0, 0),
    jump = Sprite.load("mergerJump", path.."mergerJump", 1, 14, 21)--,
--    portrait = Sprite.load("con1Portrait", path.."con1Portrait", 1, 119, 119)
}

local sounds = {
    attack = Sound.find("CrabDeath"),
    spawn = Sound.find("GuardSpawn"),
    death = Sound.find("GuardDeath")
}

local m3 = Object.base("EnemyClassic", "merger")
m3.sprite = sprites.idle

EliteType.registerPalette(sprites.palette, m3)

registercallback("onStageEntry", function()
	local dD = misc.director:getData()
	dD.mergins3_1 = {}
	dD.mergins3_2 = {}
	dD.mergins3_3 = {}
	dD.mergins3_4 = {}
end)

registercallback("onStep", function()
	local dD = misc.director:getData()
	for _, i in ipairs(m3:findAll()) do
		local iD = i:getData()
		if iD.DNA == 1 then
			if iD.partnered < 3 then
				dD.mergins3_1[i] = i.id
			elseif iD.partnered == 3 then
				dD.mergins3_1[i] = nil
			end
		elseif iD.DNA == 2 then
			if iD.partnered < 3 then
				dD.mergins3_2[i] = i.id
			elseif iD.partnered == 3 then
				dD.mergins3_2[i] = nil
			end
		elseif iD.DNA == 3 then
			if iD.partnered < 3 then
				dD.mergins3_3[i] = i.id
			elseif iD.partnered == 3 then
				dD.mergins3_3[i] = nil
			end
		elseif iD.DNA == 4 then
			if iD.partnered < 3 then
				dD.mergins3_4[i] = i.id
			elseif iD.partnered == 3 then
				dD.mergins3_4[i] = nil
			end
		end
	end
	for i, id in pairs(dD.mergins3_1) do
		if not i or not i:isValid() then
			dD.mergins3_1[i] = nil
		end
	end
	for i, id in pairs(dD.mergins3_2) do
		if not i or not i:isValid() then
			dD.mergins3_1[2] = nil
		end
	end
	for i, id in pairs(dD.mergins3_3) do
		if not i or not i:isValid() then
			dD.mergins3_1[3] = nil
		end
	end
	for i, id in pairs(dD.mergins3_4) do
		if not i or not i:isValid() then
			dD.mergins3_1[4] = nil
		end
	end
--	print(dD.mergins3_1)
--	print(dD.mergins3_2)
--	print(dD.mergins3_3)
--	print(dD.mergins3_4)
end)

m3:addCallback("create", function(self)
    local actorAc = self:getAccessor()
    local data = self:getData()
    actorAc.name = "Dewdrop"
    actorAc.maxhp = 250 * Difficulty.getScaling("hp")
    actorAc.hp = actorAc.maxhp
    actorAc.damage = 22 * Difficulty.getScaling("damage")
    actorAc.pHmax = 1.2
	actorAc.walk_speed_coeff = 1.1
    self:setAnimations{
        idle = sprites.idle,
        jump = sprites.jump,
        walk = sprites.walk,
        shoot = sprites.shoot,
        death = sprites.death,
	palette = sprites.palette
    }
    actorAc.sound_hit = Sound.find("MushHit","vanilla").id
    actorAc.sound_death = sounds.death.id
    self.mask = sprites.mask
    actorAc.health_tier_threshold = 3
    actorAc.knockback_cap = 15 * Difficulty.getScaling("hp")
    actorAc.exp_worth = 5 * Difficulty.getScaling()
    actorAc.can_drop = 1
    actorAc.can_jump = 1
    data.mergeTime = 0
    data.partner1 = "none"
    data.partner2 = "none"
    data.partner3 = "none"
    data.partner4 = "none"
    data.partnerSuccess = 0
    data.id = self.id
    data.partnered = 0
    data.mergeSlowed = 0
    data.DNA = math.random(1, 4)
    self:set("partner" .. data.DNA, "i am this")
    data.family = 0
    if data.DNA == 1 then
        data.family = self.id
	data.COMETOME = "false" -- my awesome false string
    else
	data.coming = false -- my boring false boolean
    end
    data.imdonenow = false
end)

m3:addCallback("step", function(self)
	local sD = self:getData()
	local dD = misc.director:getData()
	if self.sprite == sprites.death then
		self.spriteSpeed = 0.2
	end
	if sD.DNA == 1 then
		if not Object.findInstance(self:get("target")) or not Object.findInstance(self:get("target")):isValid() then self:set("target", -4) end
		if sD.partner2 ~= "none" and (not sD.partner2 or not sD.partner2:isValid()) then self:set("target", -4) sD.partner2 = "none" sD.COMETOME = "false" end
		if sD.partner3 ~= "none" and (not sD.partner3 or not sD.partner3:isValid()) then self:set("target", -4) sD.partner3 = "none" sD.COMETOME = "false" end
		if sD.partner4 ~= "none" and (not sD.partner4 or not sD.partner4:isValid()) then self:set("target", -4) sD.partner4 = "none" sD.COMETOME = "false" end
	end
	if sD.DNA ~= 1 then
		if not Object.findInstance(self:get("target")) or not Object.findInstance(self:get("target")):isValid() then self:set("target", -4) end
		if sD.coming == true then
			if not Object.findInstance(sD.family) or not Object.findInstance(sD.family):isValid() then	
				sD.coming = false
				self:set("target", -4)
				sD.family = 0
			elseif Object.findInstance(sD.family):getData().COMETOME == "false" then
				sD.coming = false
				self:set("target", -4)
			end
		end
	end
	if sD.DNA == 1 then
		for i, id in pairs(dD.mergins3_2) do
			if sD.partner2 == "none" and i:getData().family == 0 then
				sD.partner2 = i
				i:getData().family = sD.family
			end
		end
		for i, id in pairs(dD.mergins3_3) do
			if sD.partner3 == "none" and i:getData().family == 0 then
				sD.partner3 = i
				i:getData().family = sD.family
			end
		end
		for i, id in pairs(dD.mergins3_4) do
			if sD.partner4 == "none" and i:getData().family == 0 then
				sD.partner4 = i
				i:getData().family = sD.family
			end
		end
	end
	if sD.DNA == 1 then
		if sD.partner2 ~= "none" and sD.partner3 ~= "none" and sD.partner4 ~= "none" then
			sD.COMETOME = "the freaking beacon is lit"
			self:set("target", sD.partner2.id)
		end
	else
		if sD.family ~= 0 and Object.findInstance(sD.family):getData().COMETOME == "the freaking beacon is lit" then
			sD.coming = true
			self:set("target", sD.family)
		end
	end
	if sD.DNA == 1 and sD.COMETOME == "the freaking beacon is lit" then
		if (sD.partner2:isValid() and self:collidesWith(sD.partner2, self.x, self.y)) and (sD.partner3:isValid() and self:collidesWith(sD.partner3, self.x, self.y)) and (sD.partner4:isValid() and self:collidesWith(sD.partner4, self.x, self.y)) then
			if sD.mergeSlowed == 0 then
				self:set("pHmax", self:get("pHmax") - 1.1)
			end
			sD.mergeSlowed = 1
			sD.mergeTime = sD.mergeTime + 1
			if sD.mergeTime >= 180 then
				local combo = Object.find("GiantJelly"):create(self.x, self.y - 10)
				for _, killme in ipairs(m3:findAll()) do
					local kD = killme:getData()
					if kD.family == sD.family then
						kD.imdonenow = true
					end
				end
			end
		elseif (sD.partner2:isValid() and self:collidesWith(sD.partner2, self.x, self.y)) or (sD.partner3:isValid() and self:collidesWith(sD.partner3, self.x, self.y)) or (sD.partner4:isValid() and self:collidesWith(sD.partner4, self.x, self.y)) then
		else
			if sD.mergeSlowed == 1 then
				self:set("pHmax", self:get("pHmax") + 1.1)
			end
			sD.mergeSlowed = 0
			sD.mergeTime = 0
		end
	else

	end
	if sD.imdonenow == true then
		self:destroy()
	end
end)

--the below code has not been adjusted to use the new y origin coords
if modloader.checkFlag("meridian_debug") then
m3:addCallback("draw", function(self)
	local sD = self:getData()
	graphics.color(Color.WHITE)
	graphics.print(sD.DNA, self.x, self.y - 20, graphics.FONT_LARGE, graphics.ALIGN_MIDDLE, graphics.ALIGN_BOTTOM)
	graphics.print("Family:", self.x - 10, self.y + 15, graphics.FONT_DEFAULT, graphics.ALIGN_LEFT, graphics.ALIGN_TOP)
	local famCount = 23
	for _, m in ipairs(m3:findAll()) do
		local mD = m:getData()
		if mD.family ~= 0 and mD.family == sD.family then
			graphics.color(Color.WHITE)
			graphics.print("ID: " .. mD.id .. ", DNA: " .. mD.DNA, self.x - 10, self.y + famCount, graphics.FONT_DEFAULT, graphics.ALIGN_LEFT, graphics.ALIGN_TOP)
			if m == self then
				graphics.color(Color.YELLOW)
				graphics.print("ME", self.x - 25, self.y + famCount, graphics.FONT_DEFAULT, graphics.ALIGN_LEFT, graphics.ALIGN_TOP)
			else
				graphics.color(Color.WHITE)
				graphics.line(self.x, self.y, m.x, m.y)
			end
			famCount = famCount + 8
		end
	end
end)
end

m3:addCallback("draw", function(self)
	local sD = self:getData()
	if sD.mergeTime > 0 then
		graphics.setBlendMode("subtract")
		graphics.color(Color.BLACK)
		graphics.alpha(0.7 - (1/sD.mergeTime))
		graphics.circle(self.x, self.y, (sD.mergeTime / 18) + math.random(-3, 3) - 15)
		graphics.setBlendMode("normal")
		graphics.color(Color.fromRGB(96 - (sD.mergeTime/2), 71 - (sD.mergeTime/3), 207 - (sD.mergeTime)))
		graphics.alpha(0.5 - (1/sD.mergeTime))
		graphics.circle(self.x, self.y, (sD.mergeTime / 15) + math.random(-2, 2))
	end
end)

m3:addCallback("destroy", function(self)
	local sD = self:getData()
	if sD.DNA == 1 then
		for _, i in ipairs(m3:findAll()) do
			local iD = i:getData()
			if iD.family == self.id then
				iD.family = 0
				if sD.COMETOME == "the freaking beacon is lit" then
					i:set("target", -4)
					iD.coming = false
				end
			end
		end
	else
		for _, i in ipairs(m3:findAll()) do
			local iD = i:getData()
			if iD.family ~= 0 and iD.family == sD.family then
				if Object.findInstance(sD.family):getData().COMETOME == "the freaking beacon is lit" then
					if iD.DNA == 1 then
						i:set("target", -4)
						iD.COMETOME = "false"
					else
						i:set("target", -4)
						iD.coming = false
					end
				end
			end
		end
	end
end)

Monster.giveAI(m3)

Monster.setSkill(m3, 1, 30, 1.3 * 60, function(actor)
	local sD = actor:getData()
	if actor:get("target") and actor:get("target") ~= nil and Object.findInstance(actor:get("target")):getObject() ~= m3 and Object.findInstance(actor:get("target")):get("team") ~= "enemy" then
		Monster.setActivityState(actor, 1, actor:getAnimation("shoot"), 0.2, true, true)
		Monster.activateSkillCooldown(actor, 1)
	end
end)
Monster.skillCallback(m3, 1, function(actor, relevantFrame)
	if relevantFrame == 3 then
		sounds.attack:play(1 + 1)
		actor:fireExplosion(actor.x + actor.xscale * 15, actor.y + 1, 15/19, 8/4, 1, nil)
	end
end)

--------------------------------------

local card = MonsterCard.new("m3", m3)
card.sprite = sprites.idle
card.sprite = sprites.spawn
card.sound = sounds.spawn
card.canBlight = true
card.type = "classic"
card.cost = 50
--[[for _, elite in ipairs(EliteType.findAll("vanilla")) do
    card.eliteTypes:add(elite)
end]]

local monsLog = MonsterLog.new("Dewdrop3")
MonsterLog.map[m3] = monsLog

monsLog.displayName = "Dewdrop"
monsLog.story = "These 'creatures' are many, but weak. I can find no trace of biological components within them, but they act on their own, as if they were individuals. Every instance of the small constructs seems to be damaged and scuffed, abandoned in the environment. My compassion for them ends there, as their ferocity is not dampened by their hindrances."
monsLog.statHP = 250
monsLog.statDamage = 22
monsLog.statSpeed = 1.2
monsLog.sprite = sprites.idle
--monsLog.portrait = sprites.portrait
