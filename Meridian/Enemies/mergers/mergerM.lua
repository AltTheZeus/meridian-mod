local path = "Enemies/mergers/"
local sprites = {
    idle = Sprite.load("mergerMIdle", path.."mergerMIdle", 1, 5, 2),
    walk = Sprite.load("mergerMWalk", path.."mergerMWalk", 6, 6, 2),
    spawn = Sprite.load("mergerMSpawn", path.."mergerMSpawn", 10, 15, 18),
    death = Sprite.load("mergerMDeath", path.."mergerMDeath", 6, 8, 6),
    shoot = Sprite.load("mergerMShoot", path.."mergerMShoot", 9, 6, 3),
    mask = Sprite.load("mergerMMask", path.."mergerMMask", 1, 6, 5),
    palette = Sprite.load("mergerMPal", path.."mergerMPal", 1, 0, 0),
    jump = Sprite.load("mergerMJump", path.."mergerMJump", 1, 5, 2)--,
--    portrait = Sprite.load("con1Portrait", path.."con1Portrait", 1, 119, 119)
}

local sounds = {
    attack = Sound.find("CrabDeath"),
    spawn = Sound.find("GuardSpawn"),
    death = Sound.find("GuardDeath")
}

local m2 = Object.base("EnemyClassic", "mergerM")
m2.sprite = sprites.idle

EliteType.registerPalette(sprites.palette, m2)

registercallback("onStageEntry", function()
	local dD = misc.director:getData()
	dD.mergins2 = {}
end)

registercallback("onStep", function()
	local dD = misc.director:getData()
	for _, i in ipairs(m2:findAll()) do
		local iD = i:getData()
		if iD.partnered == false then
			dD.mergins2[i] = i.id
		elseif iD.partnered == true then
			dD.mergins2[i] = nil
		end
	end
--	print(dD.mergins2)
end)

m2:addCallback("create", function(self)
    local actorAc = self:getAccessor()
    local data = self:getData()
    actorAc.name = "Dewdrop"
    actorAc.maxhp = 100 * Difficulty.getScaling("hp")
    actorAc.hp = actorAc.maxhp
    actorAc.damage = 10 * Difficulty.getScaling("damage")
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
    data.partner = "none"
    data.partnerSuccess = 0
    data.id = self.id
    data.partnered = false
    data.mergeSlowed = 0
end)

m2:addCallback("step", function(self)
	local sD = self:getData()
	if sD.partnered == false then
		sD.partner = table.random(misc.director:getData().mergins2)
--		print(sD.partner)
		if sD.partner == self.id then
			sD.partner = "none"
		elseif sD.partner ~= nil and sD.partner ~= self and sD.partner ~= "none" then
			sD.partnered = true
			self:set("target", sD.partner)
			Object.findInstance(sD.partner):getData().partner = self.id
			Object.findInstance(sD.partner):getData().partnered = true
			Object.findInstance(sD.partner):set("target", self.id)
		end
	end

	if sD.partner and sD.partner ~= nil and sD.partner ~= "none" and self:collidesWith(Object.findInstance(sD.partner), self.x, self.y) then
		if sD.mergeSlowed == 0 then
			self:set("pHmax", self:get("pHmax") - 1.25)
		end
		sD.mergeSlowed = 1
		sD.mergeTime = sD.mergeTime + 1
		if sD.mergeTime >= 180 then
			local combo = Object.find("merger"):create(self.x, self.y - 10)
			if self.id > sD.partner then
				combo:getData().spawnedFrom = self.id
			else
				combo:getData().spawnedFrom = sD.partner
			end
			for _, new in ipairs(combo:getObject():findAll()) do
				local nD = new:getData()
				if new ~= combo and nD.spawnedFrom == combo:getData().spawnedFrom then
					if new.id > combo.id then
						combo:delete()
					else
						new:delete()
					end
				end
			end
			if Object.findInstance(sD.partner) then Object.findInstance(sD.partner):destroy() end
			if self then self:destroy() end
		end
	else
		if sD.mergeSlowed == 1 then
			self:set("pHmax", self:get("pHmax") + 1.25)
		end
		sD.mergeSlowed = 0
		sD.mergeTime = 0
	end
end)

if modloader.checkFlag("meridian_debug") then
m2:addCallback("draw", function(self)
	local sD = self:getData()
	if sD.partner and sD.partner ~= nil and sD.partner ~= "none" then
		graphics.color(Color.WHITE)
		graphics.line(self.x, self.y, Object.findInstance(sD.partner).x, Object.findInstance(sD.partner).y)
	end
end)
end

m2:addCallback("draw", function(self)
	local sD = self:getData()
	if sD.mergeTime > 0 then
		graphics.setBlendMode("subtract")
		graphics.color(Color.BLACK)
		graphics.alpha(0.7 - (1/sD.mergeTime))
		graphics.circle(self.x, self.y + 2, (sD.mergeTime / 18) + math.random(-3, 3) - 15)
		graphics.setBlendMode("normal")
		graphics.color(Color.fromRGB(96 - (sD.mergeTime/2), 71 - (sD.mergeTime/3), 207 - (sD.mergeTime)))
		graphics.alpha(0.5 - (1/sD.mergeTime))
		graphics.circle(self.x, self.y + 2, (sD.mergeTime / 15) + math.random(-2, 2))
	end
end)

m2:addCallback("destroy", function(self)
	local sD = self:getData()
	if sD.partnered == true then
		Object.findInstance(sD.partner):getData().partnered = false
		Object.findInstance(sD.partner):getData().partner = "none"
		Object.findInstance(sD.partner):set("target", -4)
	end
	local dD = misc.director:getData()
	dD.mergins2[self] = nil
end)

Monster.giveAI(m2)

Monster.setSkill(m2, 1, 30, 1.3 * 60, function(actor)
	local sD = actor:getData()
	if Object.findInstance(actor:get("target")):getObject() ~= m2 and Object.findInstance(actor:get("target")):get("team") ~= "enemy" then
		Monster.setActivityState(actor, 1, actor:getAnimation("shoot"), 0.2, true, true)
		Monster.activateSkillCooldown(actor, 1)
	end
end)
Monster.skillCallback(m2, 1, function(actor, relevantFrame)
	if relevantFrame == 3 then
		sounds.attack:play(1 + 1)
		actor:fireExplosion(actor.x + actor.xscale * 15, actor.y + 3, 15/19, 8/4, 1, nil)
	end
end)

--------------------------------------

local card = MonsterCard.new("m2", m2)
card.sprite = sprites.idle
card.sprite = sprites.spawn
card.sound = sounds.spawn
card.canBlight = true
card.type = "classic"
card.cost = 20
--[[for _, elite in ipairs(EliteType.findAll("vanilla")) do
    card.eliteTypes:add(elite)
end]]

local monsLog = MonsterLog.new("Dewdrop2")
MonsterLog.map[m2] = monsLog

monsLog.displayName = "Dewdrop"
monsLog.story = "These 'creatures' are many, but weak. I can find no trace of biological components within them, but they act on their own, as if they were individuals. Every instance of the small constructs seems to be damaged and scuffed, abandoned in the environment. My compassion for them ends there, as their ferocity is not dampened by their hindrances."
monsLog.statHP = 100
monsLog.statDamage = 10
monsLog.statSpeed = 1.2
monsLog.sprite = sprites.idle
--monsLog.portrait = sprites.portrait
