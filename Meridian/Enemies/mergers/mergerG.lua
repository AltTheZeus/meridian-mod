local path = "Enemies/mergers/"
local sprites = {
    idle = Sprite.load("mergerGIdle", path.."mergerGIdle", 1, 37, 22),
    walk = Sprite.load("mergerGWalk", path.."mergerGWalk", 8, 42, 28),
--    spawn = Sprite.load("mergerGSpawn", path.."mergerGSpawn", 7, 7, 6),
    death = Sprite.load("mergerGDeath", path.."mergerGDeath", 2, 40, 25),
    shoot1 = Sprite.load("mergerGShoot1", path.."mergerGShoot1", 13, 40, 42),
    shoot2 = Sprite.load("mergerGShoot2", path.."mergerGShoot2", 6, 41, 33),
    mask = Sprite.load("mergerGMask", path.."mergerGMask", 1, 37, 22),
    palette = Sprite.load("mergerGPal", path.."mergerGPal", 1, 0, 0),
    jump = Sprite.load("mergerGJump", path.."mergerGJump", 1, 36, 26),
    portrait = Sprite.load("mergerGPortrait", path.."mergerGPortrait", 1, 119, 119)
}

local mergeBit = ParticleType.new("merge")
local mergeSpr = Sprite.load(path.."mergeEf", 1, 2, 2)
--mergeBit:shape("pixel")
mergeBit:sprite(mergeSpr, false, false, false)
mergeBit:color(Color.BLACK, Color.fromRGB(96, 71, 207))
mergeBit:alpha(1)
mergeBit:scale(1, 1)
mergeBit:size(1, 1, 0, 0)
mergeBit:angle(0, 360, 0, 30, false)
mergeBit:speed(1, 3, -0.01, 0.01)
mergeBit:direction(0, 360, 0, 30)
mergeBit:gravity(0, 0)
mergeBit:life(60, 80)

local mTrail = ParticleType.new("mergeTrail")
mTrail:sprite(mergeSpr, false, false, false)
mTrail:size(0.7, 0.7, 0, 0.1)
mTrail:color(Color.BLACK)
mTrail:alpha(1, 0)
mTrail:life(14, 14)

mergeBit:createOnStep(mTrail, -4)

local blood = ParticleType.find("Blood2")
local bit = ParticleType.new("Doomdroplets")
local bitSpr = Sprite.load(path.."mergerGDeathEf", 3, 4, 3)
bit:sprite(bitSpr, false, false, true)
bit:size(0.9, 2.5, 0, 0)
bit:angle(0, 360, 1, 0, true)
bit:speed(2.5, 3.2, 0, 0)
bit:direction(55, 125, 0, 0)
bit:gravity(0.26, 270)
bit:life(60, 60)
--bit:createOnStep(blood, 1)

local sounds = {
    attack = Sound.find("CrabDeath"),
    spawn = Sound.find("GuardSpawn"),
    death = Sound.find("GuardDeath"),
	merge = Sound.load("mergerGMergeSound", path.."mGconnect")
}

local mG = Object.base("EnemyClassic", "mergerG")
mG.sprite = sprites.idle

EliteType.registerPalette(sprites.palette, mG)

registercallback("onStageEntry", function()
	local dD = misc.director:getData()
	dD.merginsG = {}
	dD.doomItem = {}
end)

local red = ItemPool.find("rare")
local green = ItemPool.find("uncommon")
local white = ItemPool.find("common")
local yellow
if modloader.checkMod("Starstorm") then
	yellow = ItemPool.find("legendary")
end

registercallback("onStep", function()
	local dD = misc.director:getData()
	for _, i in ipairs(mG:findAll()) do
		local iD = i:getData()
		if iD.partnered == false and not iD.bossedUp then
			dD.merginsG[i] = i.id
		elseif iD.partnered == true or iD.bossedUp then
			dD.merginsG[i] = nil
		end
	end
	for x, y in pairs(dD.doomItem) do
--		print(x)
--		print(y)
		local chestMath = math.random(100)
		if Artifact.find("Command").active == true then
			if math.chance(15) and modloader.checkMod("Starstorm") then
				yellow:getCrate():create(x, y)
			else
			if chestMath <= 1 then
				red:getCrate().create(x, y)
			elseif chestMath >= 2 and chestMath <= 30 then
				green:getCrate():create(x, y)
			else
				white:getCrate():create(x, y)
			end
			end
		else
			if math.chance(15) then
				Item.find("Misshapen Flesh"):create(x, y)
			else
			if chestMath <= 1 then
				red:roll():getObject():create(x, y)
			elseif chestMath >= 2 and chestMath <= 30 then
				green:roll():getObject():create(x, y)
			else
				white:roll():getObject():create(x, y)
			end
			end
		end
		dD.doomItem[x] = nil
	end
--	print(dD.merginsG)
end)

mG:addCallback("create", function(self)
    local actorAc = self:getAccessor()
    local data = self:getData()
    actorAc.name = "Doomdrop"
    actorAc.maxhp = 1200 * Difficulty.getScaling("hp")
    actorAc.hp = actorAc.maxhp
    actorAc.damage = 50
    actorAc.pHmax = 1
	actorAc.walk_speed_coeff = 1.1
    self:setAnimations{
        idle = sprites.idle,
        walk = sprites.walk,
        shoot1 = sprites.shoot1,
        shoot2 = sprites.shoot2,
        jump = sprites.jump,
        death = sprites.death,
	palette = sprites.palette
    }
    actorAc.sound_hit = Sound.find("MushHit","vanilla").id
    actorAc.sound_death = sounds.death.id
    self.mask = sprites.mask
    actorAc.health_tier_threshold = 3
    actorAc.knockback_cap = 100 * Difficulty.getScaling("hp")
    actorAc.exp_worth = 50 * Difficulty.getScaling()
    actorAc.can_drop = 0
    actorAc.can_jump = 0
    data.mergeTime = 0
    data.partner = "none"
    data.partnerSuccess = 0
    data.id = self.id
    data.partnered = false
    data.mergeSlowed = 0
end)

mG:addCallback("step", function(self)
	local sD = self:getData()
	local actorAc = self:getAccessor()
    if sD.bossedUp and sD.bossedUp == true then
	actorAc.maxhp = 2500 * Difficulty.getScaling("hp")
	actorAc.hp = actorAc.maxhp
	actorAc.damage = 120
	actorAc.pHmax = 0.8
	actorAc.exp_worth = 150 * Difficulty.getScaling()
	actorAc.show_boss_health = 1
	actorAc.name2 = "Err of Procrastination"
	actorAc.health_tier_threshold = 1
	actorAc.knockback_cap = 320 * Difficulty.getScaling("hp")
	self.xscale = self.xscale * 2
	self.yscale = self.yscale * 2
	actorAc.stun_immune = 1
	sD.bossedUp = false
    end
--	if sD.bossedUp ~= nil then print("boss") return end
	if sD.partnered == false and sD.bossedUp == nil then
		sD.partner = table.random(misc.director:getData().merginsG)
--		print(sD.partner)
		if sD.partner == self.id or (sD.partner and Object.findInstance(sD.partner):getData().bossedUp ~= nil) then
			sD.partner = "none"
		elseif sD.partner ~= nil and sD.partner ~= self and sD.partner ~= "none" and Object.findInstance(sD.partner):get("team") == actorAc.team and Object.findInstance(sD.partner):get("ghost") == actorAc.ghost and not Object.findInstance(sD.partner):getData().bossedUp ~= nil then
			sD.partnered = true
			self:set("target", sD.partner)
			Object.findInstance(sD.partner):getData().partner = self.id
			Object.findInstance(sD.partner):getData().partnered = true
			Object.findInstance(sD.partner):set("target", self.id)
		end
	end

	if sD.partner and sD.partner ~= nil and sD.partner ~= "none" and Object.findInstance(sD.partner) and Object.findInstance(sD.partner):isValid() and self:collidesWith(Object.findInstance(sD.partner), self.x, self.y) then
		if sD.mergeSlowed == 0 then
			self:set("pHmax", self:get("pHmax") - 0.95)
			sounds.merge:play(1, 1)
		end
		sD.mergeSlowed = 1
		if self:get("stunned") == 0 and misc.getTimeStop() == 0 then
			sD.mergeTime = sD.mergeTime + 1
			if math.random(100) <= 2 then
				mergeBit:burst("above", self.x, self.y - 5, 1)
			end
		elseif (misc.getTimeStop() > 0 and self:get("stunned") > 0) or self:get("stunned") > 0 then
			sD.mergeTime = 0
			Object.findInstance(sD.partner):getData().mergeTime = 0
		end
		if sD.mergeTime >= 180 then
			misc.shakeScreen(10)
			local combo = mG:create(self.x, self.y - 10)
			combo:getData().bossedUp = true
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
			if Object.findInstance(sD.partner) then Object.findInstance(sD.partner):set("exp_worth", 0) Object.findInstance(sD.partner):destroy() end
			if self then self:set("exp_worth", 0) self:destroy() end
		end
	else
		if sD.mergeSlowed == 1 then
			self:set("pHmax", self:get("pHmax") + 0.95)
		end
		sD.mergeSlowed = 0
		sD.mergeTime = 0
	end
end)

--[[mG:addCallback("draw", function(self)
	local sD = self:getData()
	if sD.partner and sD.partner ~= nil and sD.partner ~= "none" then
		graphics.color(Color.WHITE)
		graphics.line(self.x, self.y, Object.findInstance(sD.partner).x, Object.findInstance(sD.partner).y)
	end
end)]]

mG:addCallback("draw", function(self)
	local sD = self:getData()
	if sD.mergeTime > 0 then
		graphics.setBlendMode("subtract")
		graphics.color(Color.BLACK)
		graphics.alpha(0.7 - (1/sD.mergeTime))
		graphics.circle(self.x, self.y - 5, (sD.mergeTime * 0.14) + math.random(-3, 3) - 15)
		graphics.setBlendMode("normal")
		graphics.color(Color.fromRGB(96 - (sD.mergeTime/2), 71 - (sD.mergeTime/3), 207 - (sD.mergeTime)))
		graphics.alpha(0.5 - (1/sD.mergeTime))
		graphics.circle(self.x, self.y - 5, (sD.mergeTime * 0.17) + math.random(-2, 2))
	end
end)

mG:addCallback("destroy", function(self)
	local sD = self:getData()
	local dD = misc.director:getData()
	if sD.bossedUp ~= nil then --== true or sD.bossedUp == false then
		dD.doomItem[self.x] = self.y
	end
	if sD.partnered == true and Object.findInstance(sD.partner) and Object.findInstance(sD.partner):isValid() then
		Object.findInstance(sD.partner):getData().partnered = false
		Object.findInstance(sD.partner):getData().partner = "none"
		Object.findInstance(sD.partner):set("target", -4)
	end
	dD.merginsG[self] = nil
--[[		for i = 1, math.random(5) do
			bit:burst("above", self.x + math.random(-14, 14), self.y + math.random(-10, 2), math.random(3, 6))
--			local new = Object.find("mergerS"):create(actor.x + ((i * 6) * actor.xscale), actor.y - i)
--			local nA = new:getAccessor()
--			nA.pHspeed = --math.random(3, 5)
		end]]
end)

registercallback("onNPCDeath", function(npc)
	if npc:getObject() == mG then
		for i = 1, math.random(5) do
			bit:burst("above", npc.x + math.random(-14, 14), npc.y + math.random(-10, 2), math.random(3, 6))
		end
	end
end)

Monster.giveAI(mG)

Monster.setSkill(mG, 1, 53, 2 * 60, function(actor)
	if actor:get("target") and actor:get("target") ~= nil and Object.findInstance(actor:get("target")):get("team") ~= actor:get("team") then
		Monster.setActivityState(actor, 1, actor:getAnimation("shoot1"), 0.26, true, true)
		Monster.activateSkillCooldown(actor, 1)
	end
end)
Monster.skillCallback(mG, 1, function(actor, relevantFrame)
	if relevantFrame == 6 then
		sounds.attack:play(1 + 1)
		actor:fireExplosion(actor.x + actor.xscale * 51, actor.y + (actor.yscale * 10), (30/19) * actor.xscale, 6/4, 1, nil)
	end
end)

Monster.setSkill(mG, 2, 200, 5.5 * 60, function(actor)
	if actor:get("target") and actor:get("target") ~= nil and Object.findInstance(actor:get("target")):get("team") ~= actor:get("team") then
		Monster.setActivityState(actor, 2, actor:getAnimation("shoot2"), 0.2, true, true)
		Monster.activateSkillCooldown(actor, 2)
	end
end)
Monster.skillCallback(mG, 2, function(actor, relevantFrame)
	if relevantFrame == 2 then
		if actor:getData().bossedUp == false or actor:getData().bossedUp == true then
				local new = Object.find("mergerM"):create(actor.x, actor.y)
				local nA = new:getAccessor()
				nA.team = actor:get("team")
				nA.ghost = actor:get("ghost")
		else
--			for i = 1, math.random(4) do
--				local new = Object.find("mergerS"):create(actor.x + ((i * 6) * actor.xscale), actor.y - i)
--				local nA = new:getAccessor()
--				nA.pHspeed = --math.random(3, 5)
--				nA.pVspeed = --math.random(0, 3)
				local new = Object.find("mergerS"):create(actor.x, actor.y)
				local nA = new:getAccessor()
				nA.team = actor:get("team")
				nA.ghost = actor:get("ghost")
--			end
		end
	end
end)

--------------------------------------

local card = MonsterCard.new("mG", mG)
card.sprite = sprites.idle
--card.sprite = sprites.spawn
card.sound = sounds.spawn
card.canBlight = false
card.type = "classic"
card.cost = 800
--[[for _, elite in ipairs(EliteType.findAll("vanilla")) do
    card.eliteTypes:add(elite)
end]]

local monsLog = MonsterLog.find("Doomdrop")
MonsterLog.map[mG] = monsLog

monsLog.displayName = "Doomdrop"
monsLog.story = "As fortune would have it, the grotesque creatures do have a peak. A monstrosity, it must be composed of hundreds of smaller Dewdrops. Every direction has an eye. And if it has a blind spot, it will rearrange its sliding flesh to compensate for this flaw. Ever-changing, the fluidity of its composition makes it impossible to ambush, impossible to hide from..\n\nAnd what they lack in mobility, in this unstable and trembling apex, they make up for with.. Projectile vomit. From meters away, it gargles and spits- like it's brushing it's teeth. If only it was saliva. A new dewdrop, composited from mass redistributed.\n\nIn any situation other than this, there might be a humor in seeing the way they splatter when they hit the ground in front of me."
monsLog.statHP = 1200
monsLog.statDamage = 50
monsLog.statSpeed = 1
monsLog.sprite = sprites.walk
monsLog.portrait = sprites.portrait
