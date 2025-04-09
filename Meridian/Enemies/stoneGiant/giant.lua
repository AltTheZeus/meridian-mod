local eliteList = {}
for _, e in ipairs(EliteType.findAll()) do
	eliteList[e.id + 1] = e
end

local path = "Enemies/stoneGiant/"
local sprites = {
    idle = Sprite.load("giantIdle", path.."giantIdle", 1, 13, 35),
    walk = Sprite.load("giantWalk", path.."giantWalk", 4, 21, 36),
    shoot = Sprite.load("giantAttack", path.."giantShoot", 12, 15, 35),
    shoot2 = Sprite.load("giantAttack2", path.."giantShoot2", 11, 26, 38),
    spawn = Sprite.load("giantSpawn", path.."giantSpawn", 17, 21, 41),
    death = Sprite.load("giantDeath", path.."giantDeath", 10, 81, 44),
    mask = Sprite.load("giantMask", path.."giantMask", 1, 14, 35),
    palette = Sprite.load("giantPal", path.."giantPal", 1, 0, 0),
    jump = Sprite.load("giantJump", path.."giantJump", 1, 17, 34),
    hit = Sprite.load("giantBlast", path.."giantBlast", 3, 13, 18),
    portrait = Sprite.load("giantPortrait", path.."giantPortrait", 1, 119, 119)
}

local sounds = {
    attack = Sound.load("giantAttack1Snd", path.."golemBigAttack1"), 
	attack2_1 = Sound.load("giantAttack2_1Snd", path.."golemBigAttack2_1"), 
	attack2_2 = Sound.load("giantAttack2_2Snd", path.."golemBigAttack2_2"), 
    spawn = Sound.load("giantSpawnSnd", path.."golemBigSpawn"),
    death = Sound.load("giantDeathSnd", path.."golemBigDeath")
}

local giant = Object.base("EnemyClassic", "Stone Giant")
giant.sprite = sprites.idle

EliteType.registerPalette(sprites.palette, giant)

giant:addCallback("create", function(actor)
    local actorAc = actor:getAccessor()
    local data = actor:getData()
    actorAc.name = "Stone Giant"
    actorAc.maxhp = 670 * Difficulty.getScaling("hp")
    actorAc.hp = actorAc.maxhp
    actorAc.damage = 34 * Difficulty.getScaling("damage")
    actorAc.pHmax = 0.6
	actorAc.walk_speed_coeff = 1.1
    actor:setAnimations{
        idle = sprites.idle,
        jump = sprites.jump,
        walk = sprites.walk,
        shoot = sprites.shoot,
        shoot2 = sprites.shoot2,
        death = sprites.death,
	palette = sprites.palette
    }
    actorAc.sound_hit = Sound.find("GolemHit","vanilla").id
    actorAc.sound_death = sounds.death.id
    actor.mask = sprites.mask
    actorAc.health_tier_threshold = 3
    actorAc.knockback_cap = 30 * Difficulty.getScaling("hp")
    actorAc.exp_worth = 26 * Difficulty.getScaling()
    actorAc.can_drop = 0
    actorAc.can_jump = 0
end)

Monster.giveAI(giant)

Monster.setSkill(giant, 1, 33, 3 * 60, function(actor)
	Monster.setActivityState(actor, 1, actor:getAnimation("shoot"), 0.2, true, true)
	Monster.activateSkillCooldown(actor, 1)
end)
Monster.skillCallback(giant, 1, function(actor, relevantFrame)
	if relevantFrame == 1 then 
		sounds.attack:play(1 + 1)
	end
	if relevantFrame == 6 or relevantFrame == 8 then
		actor:fireExplosion(actor.x + (20 * actor.xscale), actor.y + 7, 1, 1, 0.7, sprites.hit, nil)
	end
end)

local warning = Object.new("giantwarning")
warning.sprite = Sprite.load("giantWarning", path.."giantWarning", 2, 9, 20)
local warningElite = Sprite.load("giantWarningElite", path.."giantWarningElite", 2, 9, 20)

local fist = Object.new("giantfist")
fist.sprite = Sprite.load("giantFist", path.."giantFist", 9, 6, 16)
local fistElite = Sprite.load("giantFistElite", path.."giantFistElite", 9, 6, 16)

fist:addCallback("create", function(self)
	local sD = self:getData()
	self.spriteSpeed = 0.2
	sounds.attack2_2:play(1 + 1)
end)

fist:addCallback("step", function(self)
	local sD = self:getData()
	if self.subimage == 2 then
		if not sD.damage then
			sD.damage = 34 * Difficulty.getScaling("damage")
		end
		misc.fireExplosion(self.x, self.y, 15/19, 20/4, sD.damage * 0.6, "enemy")
	elseif self.subimage >= 8 then
		self:destroy()
	end
end)

warning:addCallback("create", function(self)
	local sD = self:getData()
	self.spriteSpeed = 0.2
	sD.life = 0
end)

warning:addCallback("step", function(self)
	local sD = self:getData()
	sD.life = sD.life + 1
	if sD.life >= 61 then
		local f = fist:create(self.x, self.y + 5)
		local fD = f:getData()
		if sD.elite ~= nil then
			if eliteList[sD.elite + 1] ~= nil and eliteList[sD.elite + 1].color ~= nil then
				f.blendColor = eliteList[sD.elite + 1].color
				fD.elite = sD.elite
				f.sprite = fistElite
			end
		end
		fD.damage = sD.damage
		self:destroy()
	end
end)

Monster.setSkill(giant, 2, 900, 3 * 60, function(actor)
	Monster.setActivityState(actor, 2, actor:getAnimation("shoot2"), 0.2, true, true)
	Monster.activateSkillCooldown(actor, 2)
end)
Monster.skillCallback(giant, 2, function(actor, relevantFrame)
	local aA = actor:getAccessor()
	if relevantFrame == 1 then 
		sounds.attack2_1:play(1 + 1)
	end
	if relevantFrame == 6 then
--		actor:fireExplosion(actor.x + (20 * actor.xscale), actor.y, 1, 1, 2, sprites.hit, nil)
		local player = Object.findInstance(aA.target)
		if not player then return end
		local pickedGround = Object.find("b"):findLine(player.x, player.y, player.x, player.y + 100) or Object.find("bNoSpawn"):findLine(player.x, player.y, player.x, player.y + 100) or Object.find("b"):findNearest(player.x, player.y)
		local w = warning:create(math.clamp(player.x + math.random(-45, 45), pickedGround.x, pickedGround.x + (pickedGround.xscale * 16)), pickedGround.y - 5)
		local wD = w:getData() --no way wd gaster from undertale
		wD.damage = aA.damage
		if aA.elite_type > -1 then
			if eliteList[aA.elite_type + 1] ~= nil and eliteList[aA.elite_type + 1].color ~= nil then
				wD.elite = aA.elite_type
				w.sprite = warningElite
				w.blendColor = eliteList[aA.elite_type + 1].color
			end
--			print(eliteList[aA.elite_type + 1])
		end
	end
end)

--------------------------------------

local card = MonsterCard.new("giant", giant)
card.sprite = sprites.idle
card.sprite = sprites.spawn
card.sound = sounds.spawn
card.canBlight = true
card.type = "classic"
card.cost = 190
for _, elite in ipairs(EliteType.findAll("vanilla")) do
    card.eliteTypes:add(elite)
end

local stages
if modloader.checkMod("Starstorm") then
stages = {
	Stage.find("Sky Meadow"),
	Stage.find("Ancient Valley"),
	Stage.find("Verdant Woodlands")
	}
else
stages = {
	Stage.find("Sky Meadow"),
	Stage.find("Ancient Valley")
}
end

for _, stage in ipairs(stages) do
	stage.enemies:add(card)
end

local stages2
if modloader.checkMod("Starstorm") then
stages2 = {
	Stage.find("Desolate Forest"),
	Stage.find("Dried Lake"),
	Stage.find("Sunken Tombs"),
	Stage.find("Torrid Outlands"),
	Stage.find("Uncharted Mountain"),
	Stage.find("Stray Tarn")
	}
else
stages2 = {
	Stage.find("Desolate Forest"),
	Stage.find("Dried Lake"),
	Stage.find("Sunken Tombs")
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

local monsLog = MonsterLog.find("Stone Giant")
MonsterLog.map[giant] = monsLog

monsLog.displayName = "Stone Giant"
monsLog.story = "I thought the golems were large. I wish that were still the case. Comparatively enormous, these Stone Giants are simply monumental. Their terrifying triple-gaze follows unblinking, tracking my movements precisely for swift destruction.\n\nAs if that wasn't enough, their arms are laser cannons of some kind, and though I have only seen one activate, I know it would surely decimate me, based on what it did to the terrain it was unleashed upon. I must take great care not to disturb these behemoth guardians.."
monsLog.statHP = 670
monsLog.statDamage = 34
monsLog.statSpeed = 0.6
monsLog.sprite = sprites.shoot
monsLog.portrait = sprites.portrait
