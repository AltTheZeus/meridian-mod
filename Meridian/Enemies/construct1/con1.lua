local path = "Enemies/construct1/"
local sprites = {
    idle = Sprite.load("con1Idle", path.."con1Idle", 1, 6, 7),
    walk = Sprite.load("con1Walk", path.."con1Walk", 12, 8, 8),
    shoot = Sprite.load("con1Shoot", path.."con1Shoot", 11, 9, 8),
    spawn = Sprite.load("con1Spawn", path.."con1Spawn", 6, 12, 11),
    death = Sprite.load("con1Death", path.."con1Death", 12, 13, 13),
    mask = Sprite.load("con1Mask", path.."con1Mask", 1, 6, 7),
    palette = Sprite.load("con1Pal", path.."con1Pal", 1, 0, 0),
    jump = Sprite.load("con1Jump", path.."con1Jump", 1, 6, 8),
    portrait = Sprite.load("con1Portrait", path.."con1Portrait", 1, 119, 119)
}

local sounds = {
    attack = Sound.load( path.."shootCon1"),
    spawn = Sound.load( path.."spawnCon1"),
    hit = Sound.load( path.."hitCon1"),
    death = Sound.load( path.."deathCon1")
}

local con1 = Object.base("EnemyClassic", "Beta Construct1")
con1.sprite = sprites.idle

EliteType.registerPalette(sprites.palette, con1)

con1:addCallback("create", function(actor)
    local actorAc = actor:getAccessor()
    local data = actor:getData()
    actorAc.name = "Beta Construct"
    actorAc.maxhp = 90 * Difficulty.getScaling("hp")
    actorAc.hp = actorAc.maxhp
    actorAc.damage = 12 * Difficulty.getScaling("damage")
    actorAc.pHmax = 1.2
	actorAc.walk_speed_coeff = 1.1
    actor:setAnimations{
        idle = sprites.idle,
        jump = sprites.jump,
        walk = sprites.walk,
        shoot = sprites.shoot,
        death = sprites.death,
	palette = sprites.palette
    }
    actorAc.sound_hit = sounds.hit.id
    actorAc.sound_death = sounds.death.id
    actor.mask = sprites.mask
    actorAc.health_tier_threshold = 3
    actorAc.knockback_cap = 9 * Difficulty.getScaling("hp")
    actorAc.exp_worth = 5 * Difficulty.getScaling()
    actorAc.can_drop = 1
    actorAc.can_jump = 1
end)

Monster.giveAI(con1)

Monster.setSkill(con1, 1, 30, 1.3 * 60, function(actor)
	Monster.setActivityState(actor, 1, actor:getAnimation("shoot"), 0.2, true, true)
	Monster.activateSkillCooldown(actor, 1)
end)
Monster.skillCallback(con1, 1, function(actor, relevantFrame)
	if relevantFrame == 6 then
		sounds.attack:play(1, 1)
		actor:fireExplosion(actor.x + actor.xscale * 15, actor.y + 2, 15/19, 8/4, 1, nil)
	end
end)

--[[con1:addCallback("draw", function(self)
	graphics.color(Color.RED)
	graphics.line(self.x, self.y - 4, self.x + (210 * self.xscale), self.y - 4, 1)
end)]]

registercallback("onStep", function()
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
end)

--------------------------------------

local card = MonsterCard.new("con1", con1)
card.sprite = sprites.idle
card.sprite = sprites.spawn
card.sound = sounds.spawn
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

local monsLog = MonsterLog.find("Beta Construct1")
MonsterLog.map[con1] = monsLog

monsLog.displayName = "Beta Construct"
monsLog.story = "These 'creatures' are many, but weak. I can find no trace of biological components within them, but they act on their own, as if they were individuals. Every instance of the small constructs seems to be damaged and scuffed, abandoned in the environment. My compassion for them ends there, as their ferocity is not dampened by their hindrances."
monsLog.statHP = 90
monsLog.statDamage = 9
monsLog.statSpeed = 1.2
monsLog.sprite = sprites.shoot
monsLog.portrait = sprites.portrait
