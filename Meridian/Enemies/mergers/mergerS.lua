local path = "Enemies/mergers/"
local sprites = {
    idle = Sprite.load("mergerSIdle", path.."mergerSIdle", 1, 3, 0),
    walk = Sprite.load("mergerSWalk", path.."mergerSWalk", 5, 4, 1),
    spawn = Sprite.load("mergerSSpawn", path.."mergerSSpawn", 7, 7, 6),
    death = Sprite.load("mergerSDeath", path.."mergerSDeath", 5, 10, 9),
    mask = Sprite.load("mergerSMask", path.."mergerSMask", 1, 4, 7),
    palette = Sprite.load("mergerSPal", path.."mergerSPal", 1, 0, 0),
    jump = Sprite.load("mergerSJump", path.."mergerSJump", 1, 4, 1)--,
--    portrait = Sprite.load("con1Portrait", path.."con1Portrait", 1, 119, 119)
}

local sounds = {
    hit = Sound.load("mergerSHitSound", path.."m1hit"),
    spawn = Sound.load("mergerSSpawnSound", path.."m1spawn"),
    death = Sound.load("mergerSDeathSound", path.."m1death"),
	merge = Sound.load("mergerSMergeSound", path.."m1connect")
}

local m1 = Object.base("EnemyClassic", "mergerS")
m1.sprite = sprites.idle

EliteType.registerPalette(sprites.palette, m1)

registercallback("onStageEntry", function()
	local dD = misc.director:getData()
	dD.mergins1 = {}
end)

registercallback("onStep", function()
	local dD = misc.director:getData()
	for _, i in ipairs(m1:findAll()) do
		local iD = i:getData()
		if iD.partnered == false then
			dD.mergins1[i] = i.id
		elseif iD.partnered == true then
			dD.mergins1[i] = nil
		end
	end
--	print(dD.mergins1)
end)

m1:addCallback("create", function(self)
    local actorAc = self:getAccessor()
    local data = self:getData()
    actorAc.name = "Dewdrop"
    actorAc.maxhp = 40 * Difficulty.getScaling("hp")
    actorAc.hp = actorAc.maxhp
    actorAc.damage = 1
    actorAc.pHmax = 1.3
	actorAc.walk_speed_coeff = 1.1
    self:setAnimations{
        idle = sprites.idle,
        jump = sprites.jump,
        walk = sprites.walk,
        shoot = sprites.shoot,
        death = sprites.death,
	palette = sprites.palette
    }
    actorAc.sound_hit = sounds.hit.id
    actorAc.sound_death = sounds.death.id
    self.mask = sprites.mask
    actorAc.health_tier_threshold = 3
    actorAc.knockback_cap = 1 * Difficulty.getScaling("hp")
    actorAc.exp_worth = 0
    actorAc.can_drop = 1
    actorAc.can_jump = 1
    data.mergeTime = 0
    data.partner = "none"
    data.partnerSuccess = 0
    data.id = self.id
    data.partnered = false
    data.mergeSlowed = 0
end)

m1:addCallback("step", function(self)
	local sD = self:getData()
	local actorAc = self:getAccessor()
	if sD.partnered == false then
		sD.partner = table.random(misc.director:getData().mergins1)
--		print(sD.partner)
		if sD.partner == self.id then
			sD.partner = "none"
		elseif sD.partner ~= nil and sD.partner ~= self and sD.partner ~= "none" and Object.findInstance(sD.partner):get("team") == actorAc.team and Object.findInstance(sD.partner):get("ghost") == actorAc.ghost then
			sD.partnered = true
			self:set("target", sD.partner)
			Object.findInstance(sD.partner):getData().partner = self.id
			Object.findInstance(sD.partner):getData().partnered = true
			Object.findInstance(sD.partner):set("target", self.id)
		end
	end

	if sD.partner and sD.partner ~= nil and sD.partner ~= "none" and Object.findInstance(sD.partner) and Object.findInstance(sD.partner):isValid() and self:collidesWith(Object.findInstance(sD.partner), self.x, self.y) then
		if sD.mergeSlowed == 0 then
			self:set("pHmax", self:get("pHmax") - 1.25)
			sounds.merge:play(1, 1)
		end
		sD.mergeSlowed = 1
		if self:get("stunned") == 0 and misc.getTimeStop() == 0 then
			sD.mergeTime = sD.mergeTime + 1
			if math.random(100) <= 2 then
				ParticleType.find("merge"):burst("above", self.x, self.y + 1, 1)
			end
		elseif (misc.getTimeStop() > 0 and self:get("stunned") > 0) or self:get("stunned") > 0 then
			sD.mergeTime = 0
			Object.findInstance(sD.partner):getData().mergeTime = 0
		end
		if sD.mergeTime >= 180 then
			local combo = Object.find("mergerM"):create(self.x, self.y - 10)
			combo:set("team", actorAc.team)
			combo:set("ghost", actorAc.ghost)
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

--[[m1:addCallback("draw", function(self)
	local sD = self:getData()
	if sD.partner and sD.partner ~= nil and sD.partner ~= "none" then
		graphics.color(Color.WHITE)
		graphics.line(self.x, self.y, Object.findInstance(sD.partner).x, Object.findInstance(sD.partner).y)
	end
end)]]

m1:addCallback("draw", function(self)
	local sD = self:getData()
	if sD.mergeTime > 0 then
		graphics.setBlendMode("subtract")
		graphics.color(Color.BLACK)
		graphics.alpha(0.7 - (1/sD.mergeTime))
		graphics.circle(self.x, self.y + 1, (sD.mergeTime / 18) + math.random(-3, 3) - 15)
		graphics.setBlendMode("normal")
		graphics.color(Color.fromRGB(96 - (sD.mergeTime/2), 71 - (sD.mergeTime/3), 207 - (sD.mergeTime)))
		graphics.alpha(0.5 - (1/sD.mergeTime))
		graphics.circle(self.x, self.y + 1, (sD.mergeTime / 15) + math.random(-2, 2))
	end
end)

m1:addCallback("destroy", function(self)
	local sD = self:getData()
	if sD.partnered == true and Object.findInstance(sD.partner) and Object.findInstance(sD.partner):isValid() then
		Object.findInstance(sD.partner):getData().partnered = false
		Object.findInstance(sD.partner):getData().partner = "none"
		Object.findInstance(sD.partner):set("target", -4)
	end
	local dD = misc.director:getData()
	dD.mergins1[self] = nil
end)

Monster.giveAI(m1)

--------------------------------------

local card = MonsterCard.new("m1", m1)
card.sprite = sprites.idle
card.sprite = sprites.spawn
card.sound = sounds.spawn
card.canBlight = false
card.type = "classic"
card.cost = 6

MonsterLog.map[m1] = MonsterLog.find("Dewdrop")
