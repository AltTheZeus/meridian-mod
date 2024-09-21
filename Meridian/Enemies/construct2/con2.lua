local eliteClones = {}
registercallback("postLoad", function()
	for _, i in ipairs(EliteType.findAll()) do
		local i2 = EliteType.new(i:getName() .. "_Clone")
		i2.displayName = i.displayName
		i2.color = i.color
		i2.colorHard = i.colorHard
		i2.palette = i.palette
--		print(i.palette)
--		print(i2.palette)
		eliteClones[i] = i2
	end
	EliteType.refreshPalettes()
--	print(eliteClones)
end)
		

local path = "Enemies/construct2/"

local bulletCheck = Object.new("bCon2Bullet")
bulletCheck.sprite = Sprite.load("bConBullet", path.."bConBullet", 1, 0, 9)

local headSprites = {
    idle = Sprite.load("con2Idle_B", path.."con2Idle_B", 1, 8, 6),
    walk = Sprite.load("con2Walk_B", path.."con2Walk_B", 6, 8, 13),
    shoot = Sprite.load("con2Shoot_B", path.."con2Shoot_B", 12, 8, 11),
    palette = Sprite.load("con2Pal_B", path.."con2Pal_B", 1, 0, 0),
    jump = Sprite.load("con2Jump_B", path.."con2Jump_B", 1, 8, 6),
    death = Sprite.load("con2Death_B", path.."con2Death_B", 9, 11, 6),
    spawn = Sprite.load("con2Spawn_B", path.."con2Spawn_B", 15, 8, 26),
    mask = Sprite.load("con2Mask_B", path.."con2Mask_B", 1, 0, 0)
}

local head = Object.base("Enemy", "Beta Construct Head")
head.sprite = headSprites.idle

EliteType.registerPalette(headSprites.palette, head)

head:addCallback("create", function(actor)
    local actorAc = actor:getAccessor()
    local data = actor:getData()
    actorAc.name = "Beta Construct"
--    actorAc.maxhp = data.body:get("maxhp")
--    actorAc.hp = data.body:get("maxhp")
--    actorAc.damage = data.body:get("damage")
    actorAc.pHmax = 0
    actorAc.walk_speed_coeff = 0
    actor:setAnimations{
        idle = headSprites.idle,
        jump = headSprites.jump,
        walk = headSprites.walk,
        shoot = headSprites.shoot,
        death = headSprites.death,
        spawn = headSprites.spawn,
	palette = headSprites.palette
    }
--    actorAc.sound_hit = Sound.find("MushHit","vanilla").id
--    actorAc.sound_death = sounds.death.id
--    actor.mask = sprites.mask
    actorAc.health_tier_threshold = 3
    actorAc.knockback_cap = 6 * Difficulty.getScaling("hp")
    actorAc.exp_worth = 0
    actorAc.can_drop = 0
    actorAc.can_jump = 0
    data.shot = false
    data.angleLocked = false
    actor.mask = headSprites.mask
end)

local everyonelol = ParentObject.find("actors")
head:addCallback("step", function(self)
	local sD = self:getData()
	local actorAc = self:getAccessor()
	self:setAlarm(6, -1)
	if not sD.body or not sD.body:isValid() then self:destroy() return end
	if self:get("prefix_type") ~= sD.body:get("prefix_type") then
		if sD.body:get("prefix_type") == 1 then
			local key = sD.body:get("elite_type")
			self:makeElite(eliteClones[key])
		elseif sD.body:get("prefix_type") == 2 then
--			self:makeBlighted(sD.body:getBlighted())
			actorAc.prefix_type = 2
		end
	end
	actorAc.team = sD.body:get("team")
	actorAc.maxhp = sD.body:get("maxhp")
	actorAc.hp = sD.body:get("maxhp")
	actorAc.damage = sD.body:get("damage")
	self.sprite = Sprite.find(sD.body.sprite:getName() .. "_B")
	self.subimage = sD.body.subimage
	self.xscale = sD.body.xscale
	self.yscale = sD.body.yscale
	self.x = sD.body.x + (1 * sD.body.xscale)
	self.y = sD.body.y - (17 * sD.body.yscale)
	local targ = Object.findInstance(sD.body:get("target"))
	if sD.angleLocked == false then
	if targ ~= nil and targ.y < self.y then
		local xVar = (math.sign(self.x - targ.x) * (self.x - targ.x))
		local yVar = (math.sign(self.y - targ.y) * (self.y - targ.y))
		local c2 = (xVar * xVar) + (yVar * yVar)
		local h = c2 ^ 0.5
		local a = xVar
		self.angle = math.deg(math.asin(a/h))/2 * self.xscale
--		print(self.angle)
		if math.abs(self.angle) > 75 then
			self.angle = 75 * self.xscale
		end
	else
		self.angle = 0
	end
	end
	if self.sprite == headSprites.shoot and self.subimage <= 2 then
		sD.shot = false
	elseif self.sprite == headSprites.shoot and self.subimage >= 8 then
		sD.angleLocked = true
	end
	if self.sprite == headSprites.shoot and self.subimage >= 9 and self.subimage <= 10 and sD.shot == false then
		local explosion = bulletCheck:create(self.x + (9 * self.xscale), self.y - (3 * self.yscale))
		explosion.mask = explosion.sprite
		explosion.angle = self.angle
		explosion.xscale = self.xscale
		explosion.yscale = self.yscale
--		explosion.alpha = 0.2
		explosion:set("visible", 0)
		for _, i in ipairs(everyonelol:findAll()) do
			if i:get("team") ~= self:get("team") and explosion:collidesWith(i, explosion.x, explosion.y) then
				local bullet = sD.body:fireBullet(i.x, i.y, 0, 5, 1)
				bullet:set("specific_target", i.id)
			end
		end
		sD.shot = true
	end
	if self.sprite ~= headSprites.shoot then
		sD.angleLocked = false
	end
end)

local sprites = {
    idle = Sprite.load("con2Idle", path.."con2Idle", 1, 7, 23),
    walk = Sprite.load("con2Walk", path.."con2Walk", 6, 7, 30),
    shoot = Sprite.load("con2Shoot", path.."con2Shoot", 12, 7, 28),
    log = Sprite.load("con2Shoot_LOG", path.."con2Shoot_LOG", 12, 7, 28),
    spawn = Sprite.load("con2Spawn", path.."con2Spawn", 15, 8, 26),
    death = Sprite.load("con2Death", path.."con2Death", 9, 10, 24),
    mask = Sprite.load("con2Mask", path.."con2Mask", 1, 7, 23),
    palette = Sprite.load("con2Pal", path.."con2Pal", 1, 0, 0),
    jump = Sprite.load("con2Jump", path.."con2Jump", 1, 7, 24),
    portrait = Sprite.load("con2Portrait", path.."con2Portrait", 1, 119, 119)
}

local sounds = {
    attack = Sound.load( path.."shootCon2"),
    spawn = Sound.load( path.."spawnCon2"),
    hit = Sound.load( path.."hitCon2"),
    death = Sound.load( path.."deathCon2")
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
    actorAc.sound_hit = sounds.hit.id
    actorAc.sound_death = sounds.death.id
    actor.mask = sprites.mask
    actorAc.health_tier_threshold = 3
    actorAc.knockback_cap = 6 * Difficulty.getScaling("hp")
    actorAc.exp_worth = 5 * Difficulty.getScaling()
    actorAc.can_drop = 1
    actorAc.can_jump = 1
    local mD = head:create(actor.x, actor.y):getData()
    mD.body = actor
end)

Monster.giveAI(con2)

Monster.setSkill(con2, 1, 50, 1.5 * 60, function(actor)
	Monster.setActivityState(actor, 1, actor:getAnimation("shoot"), 0.2, true, true)
	Monster.activateSkillCooldown(actor, 1)
end)
Monster.skillCallback(con2, 1, function(actor, relevantFrame)
	if relevantFrame == 9 then
		sounds.attack:play(1, 1)
--		actor:fireExplosion(actor.x + actor.xscale * 30, actor.y - 18, 30/19, 5/4, 1)
	end
end)

--[[con2:addCallback("draw", function(self)
	graphics.color(Color.RED)
	graphics.line(self.x, self.y - 4, self.x + (210 * self.xscale), self.y - 4, 1)
end)]]

registercallback("onStep", function()
	for _, i in ipairs(Object.find("Spawn"):findAll()) do
		if i:get("child") == con2.id and not i:getData().twinned then
			local twin = Object.find("Spawn"):create(i.x, i.y)
			twin:getData().twinned = true
			twin:set("child", Object.find("Beta Construct1").id)
			twin:set("prefix_type", i:get("prefix_type"))
			twin:set("blight_type", i:get("blight_type"))
			twin:set("elite_type", i:get("elite_type"))
			twin.sprite = MonsterCard.find("con1").sprite
			i:getData().twinned = true
		end
	end
end)

--------------------------------------

local card = MonsterCard.new("con2", con2)
card.sprite = sprites.idle
card.sprite = sprites.spawn
card.sound = sounds.spawn
card.canBlight = true
card.type = "classic"
card.cost = 12
for _, elite in ipairs(EliteType.findAll("vanilla")) do
    card.eliteTypes:add(elite)
end

local headCard = MonsterCard.new("con2Head", head)
headCard.sprite = sprites.idle
headCard.sprite = sprites.spawn
headCard.sound = sounds.spawn
headCard.canBlight = true
headCard.type = "classic"
registercallback("onStageEntry", function()
	for _, elite in ipairs(headCard.eliteTypes:toTable()) do
		headCard.eliteTypes:remove(elite)
	end
	for _, elite in ipairs(card.eliteTypes:toTable()) do
		headCard.eliteTypes:add(elite)
	end
end, -100)

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
monsLog.story = "Malformed constructs whizz past me, shaky legs carrying their crumbling bodies at speeds too reckless to be safe, for it or myself. Their shield-like plates are covered in cracks and blemishes, no doubt from running into obstacles. The imperfections in their shield lend themselves to combat; the energy blasts they launch are chaotic and dispersed like light through a prism."
monsLog.statHP = 70
monsLog.statDamage = 12
monsLog.statSpeed = 1.3
monsLog.sprite = sprites.log
monsLog.portrait = sprites.portrait
