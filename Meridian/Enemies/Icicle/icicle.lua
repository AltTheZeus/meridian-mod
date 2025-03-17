local path = "Enemies/Icicle/"
local sprites = {
	idle = Sprite.load("IcicleIdle", path.."idle", 1, 14, 29),
	walk = Sprite.load("IcicleWalk", path.."walk", 6, 21, 31),
	death = Sprite.load("IcicleDeath", path.."death", 13, 44, 38),
	spawn = Sprite.load("IcicleSpawn", path.."spawn", 17, 29, 41),
	jump = Sprite.load("IcicleJump", path.."jump", 1, 16, 29),
	mask = Sprite.load("IcicleMask", path.."icicleMask", 1, 14, 29),
	palette = Sprite.load("IciclePalette", path.."palette", 1, 0, 0),
	portrait = Sprite.load("IciclePortrait", path.."portrait", 1, 119, 119),
	
	shoot1 = Sprite.load("IcicleShoot1", path.."shoot1", 9, 16, 34),
	shoot2 = Sprite.load("IcicleShoot2", path.."shoot2", 11, 20, 29),
	
	snowball = Sprite.load("IcicleSnowball", path.."snowball", 1, 13, 2),
	snowballMask = Sprite.load("IcicleSnowballMask", path.."snowballMask", 1, 10, -1),
	
	spike = Sprite.load("IcicleSpike", path.."spike", 4, 7, 32),
	spikeBreak = Sprite.load("IcicleSpikeBreak", path.."spikeBreak", 5, 8, 30),
	spikeMask = Sprite.load("IcicleSpikeMask", path.."spikeMask", 1, 7, 32)
}

local sounds = {
	spawn = Sound.load("IcicleSpawnSound", path.."golemIceSpawn"),
	death = Sound.load("IcicleDeathSound", path.."golemIceDeath"),
	shoot1 = Sound.load("IcicleShoot1Sound", path.."golemIceAttack1"),
	ice1 = Sound.load("IcicleIce1Sound", path.."golemIceIcicle"),
	ice2 = Sound.load("IcicleIce2Sound", path.."golemIceIcicleDespawn"),
	shoot2 = Sound.load("IcicleShoot2Sound", path.."golemIceAttack2"),
	snowball = Sound.load("IcicleSnowballSound", path.."golemSnowball")
}

local icicle = Object.base("EnemyClassic", "Icicle")
icicle.sprite = sprites.idle

local particleSnowball = ParticleType.new("particleSnowball")
particleSnowball:sprite(sprites.snowball, false, false, false)
particleSnowball:scale(0.4, 0.4)
particleSnowball:size(0.5, 1, 0, 0)
particleSnowball:angle(0, 360, 0, 0, false)
particleSnowball:speed(1, 2, 0, 0)
particleSnowball:direction(0, 180, 0, 0)
particleSnowball:gravity(0.05, 270)
particleSnowball:alpha(1, 1, 0)
particleSnowball:life(60, 90)

local particleSnowballSmall = ParticleType.new("particleSnowballSmall")
particleSnowballSmall:sprite(sprites.snowball, false, false, false)
particleSnowballSmall:scale(0.2, 0.2)
particleSnowballSmall:size(0.5, 1, 0, 0)
particleSnowballSmall:angle(0, 360, 0, 0, false)
particleSnowballSmall:speed(0.5, 1, 0, 0)
particleSnowballSmall:direction(0, 180, 0, 0)
particleSnowballSmall:gravity(0.05, 270)
particleSnowballSmall:alpha(1, 1, 0)
particleSnowballSmall:life(20, 30)

local iceCloud = ParticleType.new("IcicleIceCloud")
iceCloud:shape("Cloud")
iceCloud:size(1, 1.5, 0, 0)
iceCloud:color(Color.fromHex(0xCEFFFD), nil, nil)
iceCloud:alpha(0, 1, 0)
iceCloud:scale(0.8, 0.8)
iceCloud:life(90, 120)

EliteType.registerPalette(sprites.palette, icicle)

icicle:addCallback("create", function(actor)
	local actorAc = actor:getAccessor()
	local actorData = actor:getData()
	
	actor.mask = sprites.mask
	
	actorAc.name = "Ice Golem"
    actorAc.maxhp = 450 * Difficulty.getScaling("hp")
    actorAc.hp = actorAc.maxhp
    actorAc.damage = 20 * Difficulty.getScaling("damage")
    actorAc.pHmax = 0.95
	actorAc.walk_speed_coeff = 1.05
    actor:setAnimations{
        idle = sprites.idle,
        jump = sprites.jump,
        walk = sprites.walk,
        death = sprites.death,
		shoot1 = sprites.shoot1,
		shoot2 = sprites.shoot2,
		palette = sprites.palette
    }
    actorAc.sound_hit = Sound.find("GolemHit","vanilla").id
    actorAc.sound_death = sounds.death.id
    actorAc.health_tier_threshold = 3
    actorAc.knockback_cap = actorAc.maxhp
    actorAc.exp_worth = 30 * Difficulty.getScaling()
    actorAc.can_drop = 0
    actorAc.can_jump = 0
end) 

Monster.giveAI(icicle)

local icicleTargetFind = function(actor)
	local r = 200
	local target
	local minDis
	for _, player in ipairs(pobj.actors:findAllRectangle(actor.x - r, actor.y - r, actor.x + r, actor.y + r)) do 
		if player and player:isValid() and actor:getData().team ~= player:get("team") then 
			local dis = distance(actor.x, actor.y, player.x, player.y)
			if not minDis or dis < minDis then 
				minDis = dis 
				target = player
			end
		end
	end
	return target
end

local icicleSlow = Buff.new("IcicleSlow") 
icicleSlow:addCallback("start", function(actor)
	actor:getData().icicleSlow = 0
end) 
icicleSlow:addCallback("step", function(actor, timer)
	local debuff = 0.005
	if actor:get("pHmax") > 0.6 then
		actor:set("pHmax", actor:get("pHmax") - debuff)
		actor:getData().icicleSlow = actor:getData().icicleSlow + debuff
	end
end)
icicleSlow:addCallback("end", function(actor)
	actor:set("pHmax", actor:get("pHmax") + actor:getData().icicleSlow)
end)

local cloudx = 40
local cloudy = 30
local cloudObj = Object.new("IcicleIceCloud")
cloudObj:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	self.sprite = sprites.snowball
	self.alpha = 0 
	selfData.life = 5 * 60
	selfData.cloudTeam = nil 
end)
cloudObj:addCallback("step", function(self)
	local selfData = self:getData()
	
	if selfData.life % 15 == 0 then 
		iceCloud:burst("middle", self.x + math.random(-15, 15), self.y + math.random(-5, 5), 1)
	end
	
	if selfData.cloudTeam then 
		for _, act in ipairs(pobj.actors:findAllRectangle(self.x - cloudx, self.y + cloudy, self.x + cloudx, self.y - cloudy)) do 
			if act and act:isValid() and selfData.cloudTeam ~= act:get("team") then 
				act:applyBuff(icicleSlow, 20)
			end
		end			
	end
	
	selfData.life = selfData.life - 1 
	if selfData.life <= 0 then 
		self:destroy()
	end
end)

local xrsnow = sprites.snowballMask.width / 2
local yrsnow = sprites.snowballMask.height / 2
local snowball = Object.new("IcicleSnowball")
snowball:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	self.sprite = sprites.snowball
	self.mask = sprites.snowballMask
	
	selfData.snowballSpeed = 4
	selfData.snowballGravity = -2.5
	selfData.snowballGravitySpeed = 0.15
	selfData.snowballDamage = 0 
	selfData.snowballTeam = nil
	selfData.parent = nil
	selfData.life = 150
	selfData.hitTargets = {}
end)
snowball:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()	
	
	local selfDestroy = false 	
	self.x = self.x + selfData.snowballSpeed * self.xscale
	self.y = self.y + selfData.snowballGravity
	selfData.snowballGravity = selfData.snowballGravity + selfData.snowballGravitySpeed
	self.angle = (self.angle + self.xscale * 4) % 360
	if selfData.life < 140 and self:collidesMap(self.x, self.y) then 
		selfDestroy = true
	end
	
	if self:isValid() and selfData.snowballTeam then 
		for _, act in ipairs(pobj.actors:findAllRectangle(self.x - xrsnow, self.y + yrsnow, self.x + xrsnow, self.y - yrsnow)) do 
			if act and act:isValid() and not contains(selfData.hitTargets, act) and selfData.snowballTeam ~= act:get("team") then 
				local bullet = misc.fireBullet(self.x, self.y, 0, 1, selfData.snowballDamage, selfData.snowballTeam)
				bullet:set("specific_target", act.id)
				table.insert(selfData.hitTargets, act)
			end
		end		
	end
	
	if self:isValid() then 
		selfData.life = selfData.life - 1
		if selfDestroy or selfData.life <= 0 then 
			--[[if selfData.snowballTeam then 
				local bullet = misc.fireExplosion(self.x, self.y, (xrsnow + 5)/19, (yrsnow + 5)/4, selfData.snowballDamage, selfData.snowballTeam)
			end]]
			particleSnowball:burst("middle", self.x, self.y, 10)
			local vfx = cloudObj:create(self.x, self.y)
			vfx:getData().cloudTeam = selfData.snowballTeam
			sounds.snowball:play(1, 1)
			self:destroy()
		end
	end
end)

local spikeObj = Object.new("IcicleSpike")
spikeObj:addCallback("create", function(self)
	local selfData = self:getData()
	
	selfData.team = nil 
	selfData.damage = 0 
	selfData.life = 60
	self.sprite = sprites.spike 
	self.mask = sprites.mask 
	selfData.attack = true 
	self.spriteSpeed = 0.2
end)
spikeObj:addCallback("step", function(self)
	local selfData = self:getData()
	
	if selfData.attack and self.subimage >= 2 then 
		selfData.attack = false 
		particleSnowball:burst("middle", self.x, self.y, 5)
		if selfData.team then 
			local bullet = misc.fireExplosion(self.x, self.y - self.mask.yorigin + self.mask.height/2, self.mask.width/2/19, self.mask.height/2/4, selfData.damage, selfData.team)
		end		
	end
	
	if self.subimage >= 3 and selfData.life > 0 then 
		self.subimage = 3
	end
	
	selfData.life = selfData.life - 1
	
	if self.subimage >= 4 then 
		local vfx = obj.EfSparks:create(self.x, self.y)
		vfx.spriteSpeed = 0.2
		vfx.sprite = sprites.spikeBreak
		vfx.xscale = self.xscale
		vfx.yscale = self.yscale
		sounds.ice2:play(1, 1)
		self:destroy()
	end
end)

local spikeWarnObj = Object.new("IcicleSpikeWarning")
spikeWarnObj:addCallback("create", function(self)
	local selfData = self:getData()
	
	selfData.team = nil 
	selfData.damage = 0
	selfData.life = 60
	selfData.chasing = 0
	self.alpha = 0
	self.sprite = sprites.spike
	self.mask = sprites.spikeMask
end)
spikeWarnObj:addCallback("step", function(self)
	local selfData = self:getData()
	
	particleSnowballSmall:burst("middle", self.x, self.y - self.mask.yorigin + self.mask.height, 2)
	selfData.life = selfData.life - 1 
	if selfData.life == 40 then 
		local target = icicleTargetFind(self)
		if target and target:isValid() and selfData.chasing > 0 then 
			local dir = math.sign(target.x - self.x) 
			local newx = self.x + dir * self.mask.width 
			local trgx = self.x 
			if self:collidesMap(newx, self.y + 2) and not self:collidesMap(newx, self.y) then 
				trgx = newx
			end
			local spike2 = spikeWarnObj:create(trgx, self.y)
			spike2:getData().team = selfData.team 
			spike2:getData().damage = selfData.damage 
			spike2:getData().chasing = selfData.chasing - 1
		end
	end
	if selfData.life <= 0 then 
		local actualSpike = spikeObj:create(self.x, self.y)
		actualSpike:getData().team = selfData.team 
		actualSpike:getData().damage = selfData.damage 	
		sounds.ice1:play(1, 1)
		self:destroy()
	end
end)

Monster.setSkill(icicle, 1, 30, 4 * 60, function(actor)
	Monster.setActivityState(actor, 1, actor:getAnimation("shoot1"), 0.2, true, true)
	Monster.activateSkillCooldown(actor, 1)
end)
Monster.skillCallback(icicle, 1, function(actor, relevantFrame)
	if relevantFrame == 1 then 
		sounds.shoot1:play(1, 1)
	end
	if relevantFrame == 5 then 
		local bullet = actor:fireExplosion(actor.x + 10 * actor.xscale, actor.y + 10, 15/19, 10/4, 1)
		local spike = spikeWarnObj:create(actor.x + 10 * actor.xscale, actor.y)
		spike:getData().team = actor:get("team")
		spike:getData().damage = actor:get("damage")
		spike:getData().chasing = 2
	end
end)

Monster.setSkill(icicle, 2, 180, 7 * 60, function(actor)
	Monster.setActivityState(actor, 2, actor:getAnimation("shoot2"), 0.2, true, true)
	Monster.activateSkillCooldown(actor, 2)
end)
Monster.skillCallback(icicle, 2, function(actor, relevantFrame)
	local actorAc = actor:getAccessor()
	if relevantFrame == 1 then 
		sounds.shoot2:play(1, 1)
		if actorAc.target then 
			local trg = Object.findInstance(actorAc.target)
			if trg and trg:isValid() then 
				local n = trg.x - actor.x 
				if n ~= 0 then 
					actor.xscale = math.sign(n)
				end
			end
		end
	end
	if relevantFrame == 5 then 
		local bullet = actor:fireExplosion(actor.x + 5 * actor.xscale, actor.y - 5, 20/19, 15/4, 1)
		bullet:getData().iciclePush = 3 * actor.xscale
		local snow = snowball:create(actor.x, actor.y - 5)
		snow.xscale = actor.xscale 
		snow:getData().parent = actor 
		snow:getData().snowballTeam = actor:get("team")
		snow:getData().snowballDamage = actor:get("damage")
	end
end)

icicle:addCallback("step", function(actor)
	local actorAc = actor:getAccessor()
	local timesMax = 0
	local n = 0
	local m = 0
	while actor:collidesMap(actor.x + n, actor.y) and timesMax < 100 do
		n = n + 1
		timesMax = timesMax + 1
	end 
	timesMax = 0
	while actor:collidesMap(actor.x - m, actor.y) and timesMax < 100 do 
		m = m + 1
		timesMax = timesMax + 1	
	end 
	if n < m then 
		actor.x = actor.x + n 
	else
		actor.x = actor.x - m
	end
	
	if actorAc.target then 
		local trg = Object.findInstance(actorAc.target)
		if trg and trg:isValid() then 
			local dis = distance(actor.x, actor.y, trg.x, trg.y)
			if dis < 30 and actor:getAlarm(3) < 5 then 
				actor:setAlarm(3, 5)
			end
		end
	end
end)

callback.register("preHit", function(damager, hit)
	if damager:getData().iciclePush and hit and hit:isValid() and not hit:isBoss() then
		hit:getData().xAccel = damager:getData().iciclePush
	end
end)

local card = MonsterCard.new("Icicle", icicle)
card.sprite = sprites.spawn
card.sound = sounds.spawn
card.canBlight = true
card.type = "classic"
card.cost = 120
for _, elite in ipairs(EliteType.findAll("vanilla")) do
    card.eliteTypes:add(elite)
end
if modloader.checkMod("Starstorm") then 
	for _, elite in ipairs(EliteType.findAll("Starstorm")) do
		card.eliteTypes:add(elite)
	end
end 
if not modloader.checkFlag("mn_disable_elites") then 
	for _, elite in ipairs(EliteType.findAll("meridian")) do
		card.eliteTypes:add(elite)
	end
end

local monsLog = MonsterLog.find("Icicle")
MonsterLog.map[icicle] = monsLog

monsLog.displayName = "Icicle"
monsLog.story = "Icicle."
monsLog.statHP = 450
monsLog.statDamage = 20
monsLog.statSpeed = 0.95
monsLog.sprite = sprites.walk
monsLog.portrait = sprites.portrait
