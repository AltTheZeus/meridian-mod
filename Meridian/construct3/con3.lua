local path = "Enemies/construct3/"
local sprites = {
    idle = Sprite.load("con3Idle", path.."con3Idle", 1, 9, 21),
    walk = Sprite.load("con3Walk", path.."con3Walk", 5, 13, 26),
    shoot = Sprite.load("con3Shoot", path.."con3Shoot", 9, 11, 24),
    idle2 = Sprite.load("con3Idle2", path.."con3Idle2", 1, 6, 19),
    shoot2 = Sprite.load("con3Shoot2", path.."con3Shoot2", 7, 11, 24),
--    spawn = Sprite.load("con1Spawn", path.."con1Spawn", 6, 12, 11),
--    death = Sprite.load("con1Death", path.."con1Death", 12, 13, 13),
    mask = Sprite.load("con3Mask", path.."con3Mask", 1, 9, 21),
    mask2 = Sprite.load("con3Mask2", path.."con3Mask2", 1, 10, 19),
    palette = Sprite.load("con3Pal", path.."con3Pal", 1, 0, 0),
    jump = Sprite.load("con3Jump", path.."con3Jump", 1, 9, 22),
--    portrait = Sprite.load("con1Portrait", path.."con1Portrait", 1, 119, 119)
}

--[[local sounds = {
    attack = Sound.load( path.."shootCon1"),
    spawn = Sound.load( path.."spawnCon1"),
    hit = Sound.load( path.."hitCon1"),
    death = Sound.load( path.."deathCon1")
}]]

local con3 = Object.base("EnemyClassic", "Beta Construct3")
con3.sprite = sprites.idle

EliteType.registerPalette(sprites.palette, con3)

con3:addCallback("create", function(actor)
    local actorAc = actor:getAccessor()
    local data = actor:getData()
    actorAc.name = "Beta Construct"
    actorAc.maxhp = 120 * Difficulty.getScaling("hp")
    actorAc.hp = actorAc.maxhp
    actorAc.damage = 7 * Difficulty.getScaling("damage")
    actorAc.pHmax = 1.1
	actorAc.walk_speed_coeff = 1.1
    actor:setAnimations{
        idle = sprites.idle,
        jump = sprites.jump,
        walk = sprites.walk,
        shoot = sprites.shoot,
--        death = sprites.death,
	palette = sprites.palette
    }
--    actorAc.sound_hit = sounds.hit.id
--    actorAc.sound_death = sounds.death.id
    actor.mask = sprites.mask
    actorAc.health_tier_threshold = 3
    actorAc.knockback_cap = 30 * Difficulty.getScaling("hp")
    actorAc.exp_worth = 5 * Difficulty.getScaling()
    actorAc.can_drop = 1
    actorAc.can_jump = 0
    data.burrowed = "false"
    data.pHmax2 = 1.1
    data.xscalestorage = "a"
    data.myCol = "a"
end)

Monster.giveAI(con3)

Monster.setSkill(con3, 1, 1200, 2 * 60, function(actor)
	if (actor:getData().burrowed == "false" and ((math.abs((math.abs(Object.findInstance(actor:get("target")).x) - math.abs(actor.x)))) <= 90)) or (actor:getData().burrowed == "true" and ((math.abs((math.abs(Object.findInstance(actor:get("target")).x) - math.abs(actor.x)))) >= 400)) then
		Monster.setActivityState(actor, 1, actor:getAnimation("shoot"), 0.2, true, true)
		Monster.activateSkillCooldown(actor, 1)
	end
end)
Monster.skillCallback(con3, 1, function(actor, relevantFrame)
	if relevantFrame == 4 then
		if actor:getData().burrowed == "false" then
--			actor.x = actor.x + (actor.xscale * math.abs(actor.x % 16)) + 8
--			sounds.attack:play(1, 1)
			actor:getData().burrowed = "true"
			actor:getData().pHmax2 = actor:get("pHmax")
			actor:set("pHmax", 0)
			actor:getData().xscalestorage = actor.xscale
			actor:setAnimations{idle = sprites.idle2, shoot = sprites.shoot2}
			actor:set("knockback_cap", 120 * Difficulty.getScaling("hp"))
			local colX = math.round(actor.x/16) * 16
--			print(actor.x, colX)
			actor.x = colX + 8
			local block = Object.find("BNoSpawn2"):create(colX, actor.y - 16)
			local block2 = Object.find("BNoSpawn2"):create(colX, actor.y - 32)
			actor:getData().myCol = block2
			actor.mask = sprites.mask2
		elseif actor:getData().burrowed == "true" then
			actor:getData().burrowed = "false"
			actor:set("pHmax", actor:getData().pHmax2)
			actor:setAnimations{idle = sprites.idle, shoot = sprites.shoot}
			actor:set("knockback_cap", 30 * Difficulty.getScaling("hp"))
			actor:getData().myCol:destroy()
			actor:getData().myCol = "a"
--			actor.y = actor.y - 2
			actor.mask = sprites.mask
		end
	end
end)

registercallback("onStep", function()
	for _, i in ipairs(con3:findAll()) do
		if i:getData().burrowed == "true" then
			i.xscale = i:getData().xscalestorage
			i:set("stunned", 0)
		end
	end
end)

con3:addCallback("destroy", function(actor)
	if actor:getData().myCol ~= "a" then actor:getData().myCol:destroy() end
end)

--[[registercallback("onStep", function()
	for _, i in ipairs(Object.find("Spawn"):findAll()) do
		if i:get("child") == con1.id and not i:getData().twinned then
			local twin = Object.find("Spawn"):create(i.x, i.y - 4)
			twin:getData().twinned = true
			twin:set("child", Object.find("Beta Construct2").id)
			twin:set("prefix_type", i:get("prefix_type"))
			twin:set("blight_type", i:get("blight_type"))
			twin:set("elite_type", i:get("elite_type"))
			twin.sprite = MonsterCard.find("con2").sprite
			i:getData().twinned = true
		end
	end
end)]]

--------------------------------------

local card = MonsterCard.new("con3", con3)
card.sprite = sprites.idle
--card.sprite = sprites.spawn
--card.sound = sounds.spawn
card.canBlight = false
card.type = "classic"
card.cost = 12
for _, elite in ipairs(EliteType.findAll("vanilla")) do
    card.eliteTypes:add(elite)
end

local stages
if modloader.checkMod("Starstorm") then
stages = {
	Stage.find("Sky Meadow"),
	Stage.find("Temple of the Elders")
	}
else
stages = {
	Stage.find("Sky Meadow"),
	Stage.find("Temple of the Elders")
}
end

for _, stage in ipairs(stages) do
	stage.enemies:add(card)
end

local stages2
if modloader.checkMod("Starstorm") then
stages2 = {
	Stage.find("Dried Lake"),
	Stage.find("Uncharted Mountain")
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

local monsLog = MonsterLog.find("Beta Construct3")
MonsterLog.map[con3] = monsLog

monsLog.displayName = "Beta Construct"
monsLog.story = "These 'creatures' are many, but weak. I can find no trace of biological components within them, but they act on their own, as if they were individuals. Every instance of the small constructs seems to be damaged and scuffed, abandoned in the environment. My compassion for them ends there, as their ferocity is not dampened by their hindrances."
monsLog.statHP = 90
monsLog.statDamage = 9
monsLog.statSpeed = 1.2
monsLog.sprite = sprites.shoot
--monsLog.portrait = sprites.portrait
