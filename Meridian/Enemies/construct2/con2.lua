local path = "Enemies/construct2/"

local bulletCheck = Object.new("bCon2Bullet")
bulletCheck.sprite = Sprite.load("bConBullet", path .. "bConBullet", 1, 0, 7)

local headSprites = {
	idle = Sprite.load("con2Idle_B", path .. "con2Idle_B", 1, 7, 13),
	walk = Sprite.load("con2Walk_B", path .. "con2Walk_B", 6, 7, 20),
	shoot = Sprite.load("con2Shoot_B", path .. "con2Shoot_B", 12, 7, 18),
	palette = Sprite.load("con2Pal_B", path .. "con2Pal_B", 1, 0, 0),
	jump = Sprite.load("con2Jump_B", path .. "con2Jump_B", 1, 7, 14),
	death = Sprite.load("con2Death_B", path .. "con2Death_B", 9, 10, 14),
	spawn = Sprite.load("con2Spawn_B", path .. "con2Spawn_B", 15, 8, 16),
	mask = Sprite.load("con2Mask_B", path .. "con2Mask_B", 1, 0, 0)
}

local everyonelol = ParentObject.find("actors")

bulletCheck:addCallback("step", function(self)
	self:destroy()
end)

local sprites = {
	idle = Sprite.load("con2Idle", path .. "con2Idle", 1, 7, 13),
	walk = Sprite.load("con2Walk", path .. "con2Walk", 6, 7, 20),
	shoot = Sprite.load("con2Shoot", path .. "con2Shoot", 12, 7, 18),
	log = Sprite.load("con2Shoot_LOG", path .. "con2Shoot_LOG", 12, 7, 18),
	spawn = Sprite.load("con2Spawn", path .. "con2Spawn", 15, 8, 16),
	death = Sprite.load("con2Death", path .. "con2Death", 9, 10, 14),
	mask = Sprite.load("con2Mask", path .. "con2Mask", 1, 7, 13),
	palette = Sprite.load("con2Pal", path .. "con2Pal", 1, 0, 0),
	jump = Sprite.load("con2Jump", path .. "con2Jump", 1, 7, 14),
	portrait = Sprite.load("con2Portrait", path .. "con2Portrait", 1, 119, 119)
}

local sounds = {
	attack = Sound.load(path .. "shootCon2"),
	spawn = Sound.load(path .. "spawnCon2"),
	hit = Sound.load(path .. "hitCon2"),
	death = Sound.load(path .. "deathCon2")
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
	actorAc.damage = 9 * Difficulty.getScaling("damage")
	actorAc.pHmax = 1.3
	actorAc.walk_speed_coeff = 1.1
	actor:setAnimations {
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
end)

registercallback("onDraw", function() --thanks nk!!!! :D :D :D :D :D
for _, i in ipairs(con2:findAll()) do
	local playerData = i:getData()
	if playerData.fakeSprite and playerData.fakeSprite:isValid() then
		ac = playerData.fakeSprite:getAccessor()
		playerData.fakeSprite.sprite = Sprite.find(i.sprite:getName() .. "_B")
		playerData.fakeSprite.subimage = i.subimage
		playerData.fakeSprite.depth = i.depth - 1
		playerData.fakeSprite.x = i.x
		playerData.fakeSprite.y = i.y
		playerData.fakeSprite.alpha = i.alpha
--		playerData.fakeSprite.angle = i.angle
		playerData.fakeSprite.xscale = i.xscale
	else
		local fakeSprite = Object.find("Spawn"):create(math.round(100), math.round(100))
		local fakeSpriteAc = fakeSprite:getAccessor()
		local fsd = fakeSprite:getData() --no way free smiley dealer!!
		fakeSpriteAc.alarm = -1
		fakeSpriteAc.child = 353
		fakeSpriteAc.sprite_palette = (i:get("sprite_palette") or 1)
		fakeSpriteAc.persistent = 1
		fakeSpriteAc.prefix_type = i:get("prefix_type")
		fakeSpriteAc.elite_type = i:get("elite_type")
		if i:get("ghost") == 1 then
			fakeSprite.visible = false
		end
		fakeSprite.spriteSpeed = 0
		fakeSprite.xscale = i.xscale
		fakeSprite.sprite = Sprite.find(i.sprite:getName() .. "_B")
		fakeSprite.subimage = i.subimage
		fsd.body = i
		fsd.shot = false
		fsd.angleLocked = false
		playerData.fakeSprite = fakeSprite
	end
	if i:get("ghost") == 1 then
		graphics.setBlendMode("additive")
		local head = playerData.fakeSprite
		if misc.getOption("video.quality") == 3 then
			graphics.drawImage{head.sprite, head.x, head.y, head.subimage,
				color = Color.fromRGB(142, 129, 190),
				alpha = 0.8,
				angle = head.angle,
				xscale = i.xscale,
				yscale = i.yscale}
		else
			graphics.drawImage{head.sprite, head.x, head.y, head.subimage,
				color = Color.fromGML(14344898),
				alpha = 0.6,
				angle = head.angle,
				xscale = i.xscale,
				yscale = i.yscale}
			graphics.drawImage{head.sprite, head.x, head.y, head.subimage,
				color = Color.fromGML(14344898),
				alpha = 0.3,
				angle = head.angle,
				xscale = i.xscale,
				yscale = i.yscale}
		end
		graphics.setBlendMode("normal")
	end
end
end)

registercallback("onStep", function()
	for _, self in ipairs(Object.find("Spawn"):findAll()) do
		local sD = self:getData()
		if not sD.body then return end
		local targ = Object.findInstance(sD.body:get("target"))
		if sD.angleLocked == false then
			if targ ~= nil and targ.y < self.y then
				local directionToPlayer = {
					x = targ.x - self.x,
					y = targ.y - self.y
				}
	
				local angleToPlayer = math.deg(math.atan2(-self.xscale * (targ.y - self.y), math.abs(targ.x - self.x)))
	
				local maxAngle = 75
				angleToPlayer = math.clamp(angleToPlayer, -maxAngle, maxAngle)
				self.angle = angleToPlayer
	
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
			local explosion = bulletCheck:create(self.x + (6 * self.xscale), self.y - (8 * self.yscale))
			explosion.mask = explosion.sprite
			explosion.angle = self.angle
			explosion.xscale = self.xscale
			explosion.yscale = self.yscale
--					explosion.alpha = 0.2
			explosion:set("visible", 0)
			for _, i in ipairs(everyonelol:findAll()) do
				if i:get("team") ~= sD.body:get("team") and explosion:collidesWith(i, explosion.x, explosion.y) then
					local bullet = sD.body:fireBullet(i.x, i.y, 0, 5, 1)
					bullet:set("specific_target", i.id)
				end
			end
			sD.shot = true
		end
		if self.sprite ~= headSprites.shoot then
			sD.angleLocked = false
		end
	end
end)

registercallback("onGameStart", function()
	local dD = misc.director:getData()
	dD.newGhostsX = {}
	dD.newGhostsY = {}
	dD.newGhostsSprite = {}
	dD.newGhostsSubimage = {}
	dD.newGhostsXs = {}
	dD.newGhostsYs = {}
end)

con2:addCallback("destroy", function(self)
	if self:get("ghost") == 1 then
		local shadow = Object.find("EfTrail"):create(self:getData().fakeSprite.x, self:getData().fakeSprite.y)
		shadow.sprite = self:getData().fakeSprite.sprite
		shadow.subimage = math.floor(self:getData().fakeSprite.subimage)
		shadow.xscale = self:getData().fakeSprite.xscale
		shadow.yscale = self:getData().fakeSprite.yscale
		shadow:set("ghost", 1)
		shadow:getData().coolGhost = true
	end
	self:getData().fakeSprite:destroy()
end)

registercallback("onNPCDeath", function(self)
	if self:get("ghost") == 1 then
		local dD = misc.director:getData()
		dD.newGhostsX[self.id] = self.x
		dD.newGhostsY[self.id] = self.y
		dD.newGhostsSprite[self.id] = self.sprite
		dD.newGhostsSubimage[self.id] = math.floor(self.subimage)
		dD.newGhostsXs[self.id] = self.xscale
		dD.newGhostsYs[self.id] = self.yscale
	end
end)

registercallback("onStep", function()
	local dD = misc.director:getData()
	for id, x in pairs(dD.newGhostsX) do
		local shadow = Object.find("EfTrail"):create(x, dD.newGhostsY[id])
		shadow.sprite = dD.newGhostsSprite[id]
		shadow.subimage = dD.newGhostsSubimage[id]
		shadow.xscale = dD.newGhostsXs[id]
		shadow.yscale = dD.newGhostsYs[id]
		shadow:set("ghost", 1)
		shadow:getData().coolGhost = true
		dD.newGhostsX[id] = nil
		dD.newGhostsY[id] = nil
		dD.newGhostsSprite[id] = nil
		dD.newGhostsSubimage[id] = nil
		dD.newGhostsXs[id] = nil
		dD.newGhostsYs[id] = nil
	end
end)

Object.find("EfTrail"):addCallback("create", function(self)
	if self:get("ghost") == 1 and not self:getData().coolGhost then
		self:destroy()
	end
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

con2:addCallback("draw", function(self)

	-- graphics.color(Color.RED)
	-- graphics.line(self.x, self.y - 4, self.x + (210 * self.xscale), self.y - 4, 1)
	
	
end)

registercallback("onStep", function()
	for _, i in ipairs(Object.find("Spawn"):findAll()) do
		if i:get("child") == con2.id and not i:getData().twinned then
			local twin = Object.find("Spawn"):create(i.x, i.y + 4)
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
card.canBlight = false
card.type = "classic"
card.cost = 12
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

local monsLog = MonsterLog.find("Beta Construct2")
MonsterLog.map[con2] = monsLog

monsLog.displayName = "Beta Construct"
monsLog.story =
"Malformed constructs whizz past me, shaky legs carrying their crumbling bodies at speeds too reckless to be safe, for it or myself. Their shield-like plates are covered in cracks and blemishes, no doubt from running into obstacles. The imperfections in their shield lend themselves to combat; the energy blasts they launch are chaotic and dispersed like light through a prism."
monsLog.statHP = 70
monsLog.statDamage = 12
monsLog.statSpeed = 1.3
monsLog.sprite = sprites.log
monsLog.portrait = sprites.portrait
