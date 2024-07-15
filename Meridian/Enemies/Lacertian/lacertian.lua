local path = "Enemies/Lacertian/"
local sprites = {
    idle = Sprite.load("LacertianIdle", path.."idle", 1, 85, 51),
    walk = Sprite.load("LacertianWalk", path.."walk", 8, 85, 53),
    spawn = Sprite.load("LacertianSpawn", path.."spawn", 10, 100, 107),
    death = Sprite.load("LacertianDeath", path.."death", 8, 85, 71),
	jump = Sprite.load("LacertianJump", path.."fall", 1, 85, 57),
	shoot1 = Sprite.load("LacertianShoot1", path.."shoot1", 7, 85, 60),
	mask = Sprite.load("LacertianMask", path.."mask", 1, 85, 51)
}	

local lacertian = Object.base("BossClassic", "Lacertian")
lacertian.sprite = sprites.idle

lacertian:addCallback("create", function(actor)
    local actorAc = actor:getAccessor()
    local data = actor:getData()
	
	actor.mask = sprites.mask
	local ground = obj.BossSpawn:findNearest(actor.x, actor.y)
	if ground then
		local xx = ground.x + (ground.xscale * 15 * 16 * 0.5)
		actor.x = xx
		actor.y = ground.y - actor.mask.height + actor.mask.yorigin - 1
		actorAc.ghost_x = actor.x
		actorAc.ghost_y = actor.y
	end	
	
    actorAc.name = "Lacertian"
	actorAc.name2 = "Da Lizord"
    actorAc.maxhp = 1200 * Difficulty.getScaling("hp")
    actorAc.hp = actorAc.maxhp
    actorAc.damage = 30 * Difficulty.getScaling("damage")
    actorAc.pHmax = 0.9
	actorAc.walk_speed_coeff = 1
    actor:setAnimations{
        idle = sprites.idle,
        jump = sprites.jump,
        walk = sprites.walk,
        death = sprites.death,
		shoot1 = sprites.shoot1
    }
    --actorAc.sound_hit = Sound.find("GolemHit","vanilla").id
  --  actorAc.sound_death = Sound.find("GolemDeath","vanilla").id
   -- actor.mask = sprites.mask
    actorAc.health_tier_threshold = 1
    actorAc.knockback_cap = actorAc.maxhp
    actorAc.exp_worth = 60 * Difficulty.getScaling()
    actorAc.can_drop = 0
    actorAc.can_jump = 0
end)
Monster.giveAI(lacertian)

Monster.setSkill(lacertian, 1, 90, 8 * 60, function(actor)
	actor:getData().theTarget = obj.POI:findNearest(actor.x, actor.y)
	Monster.setActivityState(actor, 1, actor:getAnimation("shoot1"), 0.2, true, true)
	Monster.activateSkillCooldown(actor, 1)
	actor:getData().chompCount = 2
end)
Monster.skillCallback(lacertian, 1, function(actor, relevantFrame)
	if relevantFrame == 5 then 		
		actor:fireExplosion(actor.x + actor.xscale * 50, actor.y - 5, 25/19, 15/4, 1)
		actor:getData().xAccel = actor.xscale * 3
	end
	if relevantFrame == 6 and actor:getData().chompCount > 0 then 
		actor.xscale = math.sign(actor:getData().theTarget.x - actor.x)
		if actor.xscale == 0 then 
			actor.xscale = 1
		end
		actor:getData().chompCount = actor:getData().chompCount - 1
		actor:getAccessor().activity = 0 
		Monster.setActivityState(actor, 1, actor:getAnimation("shoot1"), 0.2, true, true)
		Monster.activateSkillCooldown(actor, 1)
	end
end)

lacertian:addCallback("step", function(actor)
	if actor:get("activity") ~= 30 then
		local n = 0
		while actor:collidesMap(actor.x, actor.y) and n < 100 do
			--[[if not actor:collidesMap(actor.x + 5, actor.y) then
				actor.x = actor.x + 5
			elseif not actor:collidesMap(actor.x - 5, actor.y) then
				actor.x = actor.x - 5
			elseif not actor:collidesMap(actor.x, actor.y + 6) then
				--actor.y = actor.y + 6
			else
				--actor.y = actor.y - 1
				n = n + 1
			end]]
			if not actor:collidesMap(actor.x + n, actor.y) then 
				actor.x = actor.x + n
			elseif not actor:collidesMap(actor.x - n, actor.y) then 
				actor.x = actor.x - n
			end
			n = n + 1
		end
	end	
end)

-------------------------------------

local card = MonsterCard.new("Lacertian", lacertian)
card.sprite = sprites.spawn
--card.sound = sounds.spawn
--card.canBlight = true
card.type = "player"
card.cost = 600
card.isBoss = true