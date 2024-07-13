local path = "Enemies/BasaltCrab/"
local sprites = {
    idle = Sprite.load("BasaltCrabIdle", path.."basaltIdle", 1, 24, 10),
    walk = Sprite.load("BasaltCrabWalk", path.."basaltWalk", 4, 24, 10),
    spawn = Sprite.load("BasaltCrabSpawn", path.."basaltSpawn", 6, 24, 10),
	jump = Sprite.load("BasaltCrabFall", path.."basaltIdle", 1, 24, 10),
    death = Sprite.load("BasaltCrabDeath", path.."basaltDeath", 15, 32, 30),
	shoot1 = Sprite.load("BasaltCrabShoot1", path.."basaltShoot1", 9, 36, 10),
	shoot2 = Sprite.load("BasaltCrabShoot2", path.."basaltShoot2", 18, 24, 10),
    mask = Sprite.load("BasaltCrabMask", path.."basaltMask", 1, 24, 10),
    palette = Sprite.load("BasaltCrabPalette", path.."basaltPal", 1, 0, 0),
    portrait = Sprite.load("BasaltCrabPortrait", path.."basaltPortrait", 1, 119, 199)
}	


-- PosToAngle
function posToAngle(x1, y1, x2, y2, rad)
	local deltaX = x2 - x1
	local deltaY = y1 - y2
	local result = math.atan2(deltaY, deltaX)
	
	if not rad then
		result = math.deg(result)
	end
	
	return result
end

-- Angledif
function angleDif(current, target)
	return ((((current - target) % 360) + 540) % 360) - 180
end

-- On-screen Function
function onScreen(instance)
	if instance and instance:isValid() then
		local add = 20
		if instance.x > camera.x - add and instance.x < camera.x + camera.width + add and
		instance.y > camera.y - add and instance.y < camera.y + camera.height + add then
			return true
		end
	end
end
function onScreenPos(x, y)
	local add = 20
	if x > camera.x - add and x < camera.x + camera.width + add and
	y > camera.y - add and y < camera.y + camera.height + add then
		return true
	end
end

local sounds = {
	spawn = Sound.find("CrabSpawn"),
}

local BasaltCrab = Object.base("EnemyClassic", "BasaltCrab")
BasaltCrab.sprite = sprites.idle

EliteType.registerPalette(sprites.palette, BasaltCrab)

BasaltCrab:addCallback("create", function(actor)
    local actorAc = actor:getAccessor()
    local data = actor:getData()
    actorAc.name = "Basalt Crab"
    actorAc.maxhp = 400 * Difficulty.getScaling("hp")
    actorAc.hp = actorAc.maxhp
    actorAc.damage = 57 * Difficulty.getScaling("damage")
    actorAc.pHmax = 0.8
	actorAc.walk_speed_coeff = 1.25
	data.attackFrames = 0
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
    actorAc.sound_death = Sound.find("GolemDeath","vanilla").id
    actor.mask = sprites.mask
    actorAc.health_tier_threshold = 3
    actorAc.knockback_cap = actorAc.maxhp
    actorAc.exp_worth = 30 * Difficulty.getScaling()
    actorAc.can_drop = 0
    actorAc.can_jump = 0
end)
Monster.giveAI(BasaltCrab)

local eyes = {
maineye = {x = 2, y = 10},
eye1 = {x = -12, y = 11},
eye2 = {x = 12, y = 12},
eye3 = {x = 2, y = -1}
}

local sndClap = Sound.find("GolemAttack1", "Vanilla")
local sndLaser = Sound.find("JanitorShoot1_2", "Vanilla")

Monster.setSkill(BasaltCrab, 1, 30, 2 * 60, function(actor)
	Monster.setActivityState(actor, 1, actor:getAnimation("shoot1"), 0.2, true, true)
	Monster.activateSkillCooldown(actor, 1)
end)
Monster.skillCallback(BasaltCrab, 1, function(actor, relevantFrame)
	if relevantFrame == 5 then 
		sndClap:play(0.5, 1.25)
		actor:fireExplosion(actor.x, actor.y + 35, 20/19, 20/4, 1)
	end
end)

Monster.setSkill(BasaltCrab, 2, 300, 8 * 60, function(actor)
	Monster.setActivityState(actor, 2, actor:getAnimation("shoot2"), 0.2, true, true)
	Monster.activateSkillCooldown(actor, 2)
	actor:getData().loop = 0
	actor:getData().targetAngle = nil
	actor:getData().targeting = nil
	actor:getData().curTargeting = nil
	actor:getData().attackFrames = 0
end)
Monster.skillCallback(BasaltCrab, 2, function(actor, relevantFrame)
	local data = actor:getData()
	
	if relevantFrame == 1 then 
		local target = Object.findInstance(actor:get("target"))
		if target and target:getObject() == Object.find("POI") then target = Object.findInstance(target:get("parent")) end
		if target and target:isValid() then 
			local angletrue = posToAngle(actor.x + eyes.maineye.x * actor.xscale, actor.y + eyes.maineye.y, target.x, target.y)
			data.targetAngle = angletrue
			data.targeting = target
		end
	end
	
	if relevantFrame == 13 and data.loop == 0 then 
		data.loop = 1 
		actor.subimage = 6
	end
	if actor.subimage >= 6 and actor.subimage <= 13 then 
		if data.targeting and data.targeting:isValid() then 
			data.curTargeting = true
			local target = data.targeting
			local angletrue = posToAngle(actor.x + eyes.maineye.x * actor.xscale, actor.y + eyes.maineye.y, target.x, target.y)
			turn = 0.015 * (data.loop + 1)
			if angletrue then 
				data.targetAngle = (data.targetAngle - angleDif(data.targetAngle, angletrue) * turn + 360) % 360
			end
		else
			data.curTargeting = false
		end
	end
	if relevantFrame == 14 then 
		data.attackFrames = 12
		sndLaser:play(2, 1)
		for _, eye in pairs(eyes) do 
			actor:fireBullet(actor.x + eye.x * actor.xscale, actor.y + eye.y, data.targetAngle, 300, 1)
		end
		data.curTargeting = false
		if onScreen(actor) then misc.shakeScreen(2) end
	end
end)

BasaltCrab:addCallback("step", function(actor)
	local data = actor:getData()
	
	if data.attackFrames > 0 then 
		data.attackFrames = data.attackFrames - 1
	end
end)

BasaltCrab:addCallback("draw", function(actor)
	local data = actor:getData()
	
	if actor:get("activity") == 2 and (data.curTargeting or data.attackFrames > 0) then 
		graphics.color(Color.RED)
		if data.attackFrames > 0 then 
			graphics.alpha(data.attackFrames / 8)
		else
			graphics.alpha(0.3 * (data.loop + 1))
		end
		
		for _, eye in pairs(eyes) do
			local r = 0
			while r < 320 do
				newx = actor.x + eye.x * actor.xscale + math.cos(math.rad(data.targetAngle)) * r
				newy = actor.y + eye.y - math.sin(math.rad(data.targetAngle)) * r
				local tile = Stage.collidesPoint(newx, newy)
				if tile then
					break
				else
					r = math.floor(r + 16)
				end
			end
			if data.attackFrames > 0 then 
				graphics.line(actor.x + eye.x * actor.xscale, actor.y + eye.y, newx, newy, data.attackFrames)
			else
				graphics.line(actor.x + eye.x * actor.xscale, actor.y + eye.y, newx, newy, data.loop + 1)
			end	
		end
	end
end)

-------------------------------------

local card = MonsterCard.new("Basalt Crab", BasaltCrab)
card.sprite = sprites.idle
card.sprite = sprites.spawn
card.sound = sounds.spawn
card.canBlight = true
card.type = "classic"
card.cost = 160
for _, elite in ipairs(EliteType.findAll("vanilla")) do
    card.eliteTypes:add(elite)
end

local stages
if modloader.checkMod("Starstorm") then
stages = {
	Stage.find("Sunken Tombs"),
	Stage.find("Magma Barracks"),
	Stage.find("Uncharted Mountain"),
	Stage.find("Stray Tarn")
	}
else
stages = {
	Stage.find("Sunken Tombs"),
	Stage.find("Magma Barracks")
}
end

for _, stage in ipairs(stages) do
	stage.enemies:add(card)
end

local stages2
if modloader.checkMod("Starstorm") then
stages2 = {
	Stage.find("Dried Lake"),
	Stage.find("Whistling Basin")
	}
else
stages2 = {
	Stage.find("Dried Lake")
}
end

registercallback("onGameStart", function()
	local dD = misc.director:getData()
	dD.PLstages = false
end)

registercallback("onStageEntry", function()
	local dD = misc.director:getData()
	if misc.director:get("stages_passed") >= 5 and dD.PLstages == false then
		for _, stage in ipairs(stages2) do
			stage.enemies:add(card)
		end
	end
end)

registercallback("onGameEnd", function()
	for _, stage in ipairs(stages) do
		stage.enemies:remove(card)
	end
	for _, stage in ipairs(stages2) do
		stage.enemies:remove(card)
	end
end)

local monsLog = MonsterLog.new("Basalt Crab")
MonsterLog.map[BasaltCrab] = monsLog

monsLog.displayName = "Basalt Crab"
monsLog.story = "//DATA-FAILED-TO-EXPORT//"
monsLog.statHP = 400
monsLog.statDamage = 16
monsLog.statSpeed = 0.8
monsLog.sprite = sprites.walk
monsLog.portrait = sprites.portrait