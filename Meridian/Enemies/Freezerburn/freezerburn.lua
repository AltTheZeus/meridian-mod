local path = "Enemies/Freezerburn/"
local sprites = {
	idle = Sprite.load("FreezerburnIdle", path.."idle", 1, 21, 53),
	walk = Sprite.load("FreezerburnWalk", path.."walk", 6, 25, 55),
	
	shoot1_swipe = Sprite.load("FreezerburnShoot1Swipe", path.."shoot1_swipe", 23, 32, 53),
	shoot1_stun = Sprite.load("FreezerburtnShoot1Stun", path.."shoot1_stun", 9, 15, 38),
	shoot1_getup = Sprite.load("FreezerburnShoot1GetUp", path.."shoot1_getup", 12, 19, 54),
	
	mask = Sprite.load("FreezerburnMask", path.."mask", 1, 21, 53),
	
	spike = Sprite.find("IcicleSpike", "meridian"),
	spikeMask = Sprite.find("IcicleSpikeMask", "meridian"),
	spikeProjMask = Sprite.load("FreezerburnSpikeProjectileMask", path.."spikeProjMask", 1, 1, 4)
}

local sounds = {
	ice1 = Sound.find("IcicleIce1Sound", "meridian")
}

local freezer = Object.base("EnemyClassic", "Freezerburn")
freezer.sprite = sprites.idle

freezer:addCallback("create", function(actor)
	local actorAc = actor:getAccessor()
	local actorData = actor:getData()
	
	actor.mask = sprites.mask
	
	actorAc.name = "Freezerburn"
    actorAc.maxhp = 1000 * Difficulty.getScaling("hp")
    actorAc.hp = actorAc.maxhp
    actorAc.damage = 20 * Difficulty.getScaling("damage")
    actorAc.pHmax = 0.8
	actorAc.walk_speed_coeff = 1
    actor:setAnimations{
        idle = sprites.idle,
        --jump = sprites.jump,
        walk = sprites.walk,
        --death = sprites.death,
		shoot1 = sprites.shoot1_swipe,
		--shoot2 = sprites.shoot2,
		--palette = sprites.palette
    }
    actorAc.sound_hit = Sound.find("GolemHit","vanilla").id
    --actorAc.sound_death = sounds.death.id
    actorAc.health_tier_threshold = 3
    actorAc.knockback_cap = actorAc.maxhp
    actorAc.exp_worth = 90 * Difficulty.getScaling()
    actorAc.can_drop = 0
    actorAc.can_jump = 0
end) 

Monster.giveAI(freezer)

local findSpikeGround = function(x, y)
	local checkDown = obj.B:findLine(x, y, x, y + 12)
	checkDown = checkDown or obj.BNoSpawn:findLine(x, y, x, y + 12)
	local checkUp = obj.B:findLine(x, y - 2, x, y - 12)
	checkUp = checkUp or obj.BNoSpawn:findLine(x, y - 2, x, y - 12)
	return checkDown and not checkUp
end

local findSpikeSpawn = function(width, x, y)
	local disX1 = 0
	local disX2 = 0 
	local x1
	local x2
	while findSpikeGround(x + disX1, y) do 
		disX1 = disX1 + width
	end
	while findSpikeGround(x - disX2, y) do 
		disX2 = disX2 + width
	end
	if disX1 + disX2 > width then 
		x1 = x + disX1
		x2 = x - disX2
	end
	return x2, x1
end

local spikeObj = Object.find("IcicleSpike", "meridian")
local particleSnowballSmall = ParticleType.find("particleSnowballSmall", "meridian")
local spikeWarnObj = Object.find("IcicleSpikeWarning", "meridian")

--local spikeWarnObj = Object.new("FreezerburnSpikeWarning")
--[[spikeWarnObj:addCallback("create", function(self)
	local selfData = self:getData()
	
	selfData.team = nil 
	selfData.damage = 0
	selfData.life = 60
	--selfData.chasing = 0
	self.alpha = 0
	self.sprite = sprites.spike
	self.mask = sprites.spikeMask
	selfData.travel = nil 
	selfData.spikeExplode = nil
end)
spikeWarnObj:addCallback("step", function(self)
	local selfData = self:getData()
	
	particleSnowballSmall:burst("middle", self.x, self.y - self.mask.yorigin + self.mask.height, 2)
	selfData.life = selfData.life - 1 
	if selfData.travel then 
		local actor = nearestMatchingOp(self, obj.P, "team", "~=", selfData.team)
		local dis
		if actor then 
			dis = distance(self.x, self.y - self.mask.yorigin + self.mask.height, actor.x, actor.y)
		end
		if not (dis and dis < 3) and findSpikeGround(self.x + self.xscale, self.y) then 
			self.x = self.x + self.xscale 
		else
			selfData.life = 15
			selfData.travel = false
		end
	end
	if selfData.spikeExplode then 
		
	end
	if selfData.life <= 0 then 
		local actualSpike = spikeObj:create(self.x, self.y)
		actualSpike:getData().team = selfData.team 
		actualSpike:getData().damage = selfData.damage 	
		sounds.ice1:play(1, 1)
		self:destroy()
	end
end)]]

Monster.setSkill(freezer, 1, 40, 9 * 60, function(actor)
	Monster.setActivityState(actor, 1, actor:getAnimation("shoot1"), 0.2, true, true)
	Monster.activateSkillCooldown(actor, 1)
end)
Monster.skillCallback(freezer, 1, function(actor, relevantFrame)
	local actorData = actor:getData()
	
	if actor.sprite == sprites.shoot1_swipe then 
		if relevantFrame == 7 then 
			local spikeWidth = sprites.spikeMask.width 
			local spikeAmount = math.random(4, 6)
			local x1, x2 = findSpikeSpawn(spikeWidth, actor.x, actor.y - 6)
			for i = 1, spikeAmount do 
				local spike = spikeWarnObj:create(math.random(x1, x2), actor.y - 6)
				spike:getData().team = actor:get("team")
				spike:getData().damage = actor:get("damage")
				spike:getData().life = math.random(60, 90)
			end
		end
		if relevantFrame == 15 then 
			local bullet = actor:fireExplosion(actor.x + 10 * actor.xscale, actor.y + 10, 20/19, 15/4, 2)
			local spike = spikeWarnObj:create(actor.x, actor.y - 6)
			spike:getData().team = actor:get("team")
			spike:getData().damage = actor:get("damage")
			spike:getData().life = 120
			spike:getData().travel = true
			spike.xscale = actor.xscale
		end
		if actor.subimage >= actor.sprite.frames - 1 then 
			actor.subimage = 1 
			--actor.sprite = sprites.shoot1_stun
			actorData._attackAnimation = sprites.shoot1_stun
			actor.spriteSpeed = 0.2
			actorData.stunLoop = 4
		end
	end
	
	if actor.sprite == sprites.shoot1_stun and actor.subimage >= actor.sprite.frames - 1 then 
		actor.subimage = 1 
		actorData.stunLoop = actorData.stunLoop - 1
		if actorData.stunLoop <= 0 then 
			--actor.sprite = sprites.shoot1_getup
			actorData._attackAnimation = sprites.shoot1_getup
			actor.spriteSpeed = 0.2
		end
	end	
end)

local card = MonsterCard.new("Freezerburn", freezer)
card.sprite = sprites.idle
--card.sound = sounds.spawn
--card.canBlight = true
card.type = "classic"
card.cost = 120
