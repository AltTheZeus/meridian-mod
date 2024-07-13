local path = "Enemies/construct2/"
local sprites = {
    idle = Sprite.load("con2Idle", path.."con2Idle", 1, 7, 23),
    walk = Sprite.load("con2Walk", path.."con2Walk", 6, 7, 30),
    shoot = Sprite.load("con2Shoot", path.."con2Shoot", 12, 7, 28),
    spawn = Sprite.load("con2Spawn", path.."con2Spawn", 15, 8, 26),
    death = Sprite.load("con2Death", path.."con2Death", 9, 10, 24),
    mask = Sprite.load("con2Mask", path.."con2Mask", 1, 7, 23),
    palette = Sprite.load("con2Pal", path.."con2Pal", 1, 0, 0),
    jump = Sprite.load("con2Jump", path.."con2Jump", 1, 7, 24)
--    portrait = Sprite.load("con2Portrait", path.."con2Portrait", 1, 119, 199)
}

local sounds = {
    attack = Sound.find("CrabDeath"),
    spawn = Sound.find("GuardSpawn"),
    death = Sound.find("GuardDeath")
}

local con2 = Object.base("EnemyClassic", "Beta Construct2")
con2.sprite = sprites.idle

EliteType.registerPalette(sprites.palette, con2)

con2:addCallback("create", function(actor)
    local actorAc = actor:getAccessor()
    local data = actor:getData()
    actorAc.name = "Beta Construct"
    actorAc.maxhp = 70 * Difficulty.getScaling("hp")
    actorAc.hp = actorAc.maxhp
    actorAc.damage = 12 * Difficulty.getScaling("damage")
    actorAc.pHmax = 1.3
	actorAc.walk_speed_coeff = 1.1
    actor:setAnimations{
        idle = sprites.idle,
        jump = sprites.jump,
        walk = sprites.walk,
        shoot = sprites.shoot,
        death = sprites.death,
	palette = sprites.palette
    }
    actorAc.sound_hit = Sound.find("MushHit","vanilla").id
    actorAc.sound_death = sounds.death.id
    actor.mask = sprites.mask
    actorAc.health_tier_threshold = 3
    actorAc.knockback_cap = 6 * Difficulty.getScaling("hp")
    actorAc.exp_worth = 5 * Difficulty.getScaling()
    actorAc.can_drop = 1
    actorAc.can_jump = 1
end)

Monster.giveAI(con2)

Monster.setSkill(con2, 1, 50, 1.5 * 60, function(actor)
	Monster.setActivityState(actor, 1, actor:getAnimation("shoot"), 0.2, true, true)
	Monster.activateSkillCooldown(actor, 1)
end)
Monster.skillCallback(con2, 1, function(actor, relevantFrame)
	if relevantFrame == 9 then
		sounds.attack:play(1 + 1)
		actor:fireExplosion(actor.x + actor.xscale * 30, actor.y - 18, 30/19, 5/4, 1)
	end
end)

--[[con2:addCallback("draw", function(self)
	graphics.color(Color.RED)
	graphics.line(self.x, self.y - 4, self.x + (210 * self.xscale), self.y - 4, 1)
end)]]

--------------------------------------

local card = MonsterCard.new("con2", con2)
card.sprite = sprites.idle
card.sprite = sprites.spawn
card.sound = sounds.spawn
card.canBlight = true
card.type = "classic"
card.cost = 8
for _, elite in ipairs(EliteType.findAll("vanilla")) do
    card.eliteTypes:add(elite)
end

local stages
if modloader.checkMod("Starstorm") then
stages = {
	Stage.find("Magma Barracks"),
	Stage.find("Temple of the Elders")
	}
else
stages = {
	Stage.find("Magma Barracks"),
	Stage.find("Temple of the Elders")
}
end

for _, stage in ipairs(stages) do
	stage.enemies:add(card)
end

local stages2
if modloader.checkMod("Starstorm") then
stages2 = {
	Stage.find("Damp Caverns"),
	Stage.find("Uncharted Mountain")
	}
else
stages2 = {
	Stage.find("Damp Caverns")
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

local monsLog = MonsterLog.new("Beta Construct2")
MonsterLog.map[con2] = monsLog

monsLog.displayName = "Beta Construct"
monsLog.story = "The ferocity of these things chills my blood. I do not know if they are machine or beast, and I am not willing to inspect them to find out. They seem to sense my presence through some means, and by then it's too late. Scores of them materialise, assembling themselves and instantly sprinting towards me. The noises they emit are unlike all else, unholy screeches and roars of composition unknown.\n\nI hope to never encounter one again. Their extendable necks give me the willies."
monsLog.statHP = 70
monsLog.statDamage = 12
monsLog.statSpeed = 1.3
monsLog.sprite = sprites.shoot
--monsLog.portrait = sprites.portrait