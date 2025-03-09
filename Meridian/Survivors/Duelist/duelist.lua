local path = "Survivors/Duelist/"

local survivor = Survivor.new("Duelist") 

local sprites = {
	idle = Sprite.load("DuelistIdle", path.."idle", 1, 9, 6),
	walk = Sprite.load("DuelistWalk", path.."walk", 8, 8, 6),
	jump = Sprite.load("DuelistJump", path.."jump", 6, 5, 8),
	death = Sprite.load("DuelistDeath", path.."death", 13, 9, 16),
	climb = Sprite.load("DuelistClimb", path.."idle", 1, 5, 6),  -- placeholder
	decoy = Sprite.load("DuelistDecoy", path.."idle", 1, 7, 11), -- placeholder
	
	shoot1_1 = Sprite.load("DuelistShoot1_1", path.."shoot1_1", 7, 10, 12),
	shoot1_2 = Sprite.load("DuelistShoot1_2", path.."shoot1_2", 7, 11, 11),
	shoot1_3 = Sprite.load("DuelistShoot1_3", path.."shoot1_3", 7, 8, 12),
	shoot1_4 = Sprite.load("DuelistShoot1_4", path.."shoot1_4", 7, 8, 15),
	
	shoot3 = Sprite.load("DuelistShoot3", path.."shoot3", 20, 39, 12),
	sparks1 = Sprite.load("DuelistShoot3Sparks1", path.."sparks1", 4, 39, 12),
	sparks2 = Sprite.load("DuelistShoot3Sparks2", path.."sparks2", 4, 39, 12)
}

local sounds = {

}

local spriteCombo = {}
table.insert(spriteCombo, sprites.shoot1_1)
table.insert(spriteCombo, sprites.shoot1_2)
table.insert(spriteCombo, sprites.shoot1_3)
table.insert(spriteCombo, sprites.shoot1_4)

local duelistColors = {
	Color.fromHex(0x8BACE0),
	Color.fromHex(0x2D99EC),
	Color.fromHex(0x3CDAF0),
	Color.fromHex(0x29EADB),
	Color.fromHex(0x76B1F3)
}

local sprSkills = Sprite.load("DuelistSkills", path.."idle", 4, 0, 0) -- placeholder

survivor.loadoutColor = Color.fromHex(0x8BACE0)

survivor.loadoutSprite = Sprite.load("DuelistSelect", path.."idle", 1, 2, 0) -- placeholder

callback.register("postLoad", function()
	if modloader.checkMod("Starstorm") then
		SurvivorVariant.setInfoStats(SurvivorVariant.getSurvivorDefault(survivor), {{"Strength", 5}, {"Vitality", 6}, {"Toughness", 3}, {"Agility", 7}, {"Difficulty", 6}, {"Placeholder", 8}})
		SurvivorVariant.setDescription(SurvivorVariant.getSurvivorDefault(survivor), "Placeholder")
	end
end)

survivor:setLoadoutInfo(
[[The ]]..colorString("Duelist", survivor.loadoutColor)..[[ is placeholder.
Hologram tech allows you to overwhelm your enemies.]]
, sprSkills)

survivor:setLoadoutSkill(1, "1",
[[Slash with your twinblade in a combo for X%. 
Each slash causes a hologram to attack for half the damage.
]])

survivor:setLoadoutSkill(2, "2",
[[Slash for X% and perform an evasive maneuver.
A hologram lingers in your place.
]])

survivor:setLoadoutSkill(3, "3",
[[Dash forward, slashing all enemies for X%.
Holograms linger at the start and end of the dash.
]])

survivor:setLoadoutSkill(4, "4",
[[Activate all lingering holograms to attack nearby enemies.
]])

survivor.idleSprite = sprites.idle

survivor.titleSprite = sprites.walk

survivor.endingQuote = "..and so she left, placeholder."

survivor:addCallback("init", function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	player:setAnimations(sprites)
	
	if Difficulty.getActive() == dif.Drizzle then
		player:survivorSetInitialStats(180, 15, 0.06)
	else
		player:survivorSetInitialStats(120, 15, 0.03)
	end
	
	playerData.combo = 1
	playerData.comboReset = 0
	playerData.utilityDis = 0
	
	playerAc.pHmax = 1.45
	player:set("walk_speed_coeff", 1)
	
    player:setSkill(1, "1", "Slash for X% damage. Hologram follows up with half damage.",
    sprSkills, 1, 30)
	
    player:setSkill(2, "2", ".Slash for X% damage, spawn a hologram and backstep.",
    sprSkills, 2, 60 * 2)

    player:setSkill(3, "3", "Dash for X% damage. Spawn hologram at the start and end of the dash.",
    sprSkills, 3, 60 * 3)

    player:setSkill(4, "4", "Cause all lingering holograms to attack nearby enemies.",
    sprSkills, 4, 60 * 8)
end)

survivor:addCallback("levelUp", function(player)
	player:survivorLevelUpStats(24, 3, 0.0016, 1)
end)

objAfterimage = Object.new("DuelistAfterimage") 
local startAlpha = 0.8
objAfterimage:addCallback("create", function(self)
	local selfData = self:getData()
	
	self.sprite = sprites.idle 
	self.spriteSpeed = 0.24
	self.alpha = 0
	selfData.alpha = startAlpha
	selfData.parent = nil
	selfData.attack = false
	selfData.fullCombo = false
	selfData.curSprite = 1
	--selfData.afterimageDamage = 1
	selfData.special = false
	selfData.targeting = true
	selfData.lasting = false
	selfData.outline = true
	selfData.afterimageColor = duelistColors[math.random(1, #duelistColors)]
	selfData.afterimageBlack = false
end)
objAfterimage:addCallback("step", function(self)
	local selfData = self:getData()
	local parent = selfData.parent 
	
	if selfData.outline then 
		selfData.outline = false
		local outline = obj.EfOutline:create(0, 0)
		outline:set("rate", 0)
		outline:set("parent", self.id)
		outline.alpha = selfData.alpha
		outline.blendColor = Color.fromHex(0x0F82DC)
		if selfData.afterimageBlack then 
			outline.blendColor = Color.BLACK
			selfData.afterimageColor = Color.BLACK
		end
		outline.depth = self.depth + 1
		selfData.outlineObj = outline
	else
		local outline = selfData.outlineObj
		if outline and outline:isValid() then 
			outline.alpha = selfData.alpha
		end
	end
	
	if parent and selfData.special and selfData.targeting then 
		print("targeting")
		local dis = 80
		local minDis
		local target
		local actors = pobj.actors:findAllRectangle(self.x - dis, self.y + 10, self.x + dis, self.y - 10)
		for _, act in ipairs(actors) do 
			if act and act:isValid() and act:get("team") ~= parent:get("team") then 
				local actDis = distance(self.x, self.y, act.x, act.y)
				print("team check passed")
				if not minDis or actDis < minDis then 
					minDis = actDis 
					target = act 
				end
			end
		end
		if target then
			print("target found")
			self.xscale = math.sign(target.x - self.x) 
			if self.xscale == 0 then self.xscale = 1 end 
			if minDis > 2 then 
				self.x = self.x + self.xscale * math.min(minDis, 20)
			end
		end
		selfData.targeting = false
	end
	
	if parent and not selfData.attack then 
		local n = 0
		if selfData.curSprite >= 3 then 
			n = 0.5
		end
		local dmg = parent:get("damage") * (1.5 + n) * 0.5 --[[* ((selfData.multiple + 1) / 4)]]
		--local dmg = selfData.afterimageDamage
		if self.sprite == sprites.shoot1_3 then 
			if self.subimage >= 4 then  
				local bullet = misc.fireExplosion(self.x + self.xscale * 5, self.y, 20/19, 15/4, dmg, parent:get("team"))
				--bullet:set("climb", (2 - selfData.multiple) * 4)
				selfData.attack = true
			end
		else
			if self.subimage >= 3 then 
				local bullet = misc.fireExplosion(self.x + self.xscale * 5, self.y, 20/19, 15/4, dmg, parent:get("team"))
				--bullet:set("climb", (2 - selfData.multiple) * 4)
				selfData.attack = true
			end			
		end
	end
	
	if math.floor(self.subimage) == self.sprite.frames then 
		--[[if selfData.alpha == startAlpha and selfData.multiple > 0 then 
			local vfx = objAfterimage:create(self.x, self.y) 
			vfx.sprite = self.sprite 
			vfx.xscale = self.xscale
			vfx.yscale = self.yscale
			vfx:getData().multiple = selfData.multiple - 1
			vfx.spriteSpeed = self.spriteSpeed * 0.8
			if parent then 
				vfx:getData().parent = parent
			end
			vfx:getData().curSprite = selfData.curSprite
			vfx:getData().fullCombo = selfData.fullCombo
		end]]
		if selfData.alpha == startAlpha and selfData.curSprite < 4 and selfData.fullCombo then 
			print("done")
			selfData.fullCombo = false 
			local vfx = objAfterimage:create(self.x, self.y) 
			vfx.xscale = self.xscale
			vfx.yscale = self.yscale
			--vfx:getData().multiple = 0
			if parent then 
				vfx:getData().parent = parent
			end			
			vfx:getData().curSprite = selfData.curSprite + 1
			vfx.sprite = spriteCombo[selfData.curSprite + 1]
			vfx:getData().fullCombo = true 
			vfx:getData().special = selfData.special
			vfx:getData().lasting = selfData.lasting
			vfx:getData().afterimageColor = selfData.afterimageColor
			selfData.lasting = false
		end
		if selfData.alpha == startAlpha and selfData.lasting then 
			local vfx = objLastingAfterimage:create(self.x, self.y)
			vfx.sprite = self.sprite 
			vfx.subimage = self.subimage
			vfx.xscale = self.xscale 
			vfx:getData().parent = parent
			vfx:getData().afterimageColor = selfData.afterimageColor
			vfx:getData().afterimageBlack = selfData.afterimageBlack
		end
		self.spriteSpeed = 0
		selfData.alpha = selfData.alpha - 1/75
	end	
	
	if selfData.alpha <= 0 then 
		self:destroy()
	end
end)
objAfterimage:addCallback("draw", function(self)
	local selfData = self:getData()
	
	graphics.drawImage{
	x = self.x,
	y = self.y,
	image = self.sprite,
	subimage = self.subimage,
	xscale = self.xscale,
	yscale = self.yscale,
	angle = self.angle,
	alpha = selfData.alpha,
	solidColor = selfData.afterimageColor
	}
end)

objLastingAfterimage = Object.new("DuelistLastingAfterimage")
objLastingAfterimage:addCallback("create", function(self)
	local selfData = self:getData()
	
	self.sprite = sprites.idle 
	self.alpha = 0
	selfData.alpha = 2
	selfData.parent = nil
	self.spriteSpeed = 0
	selfData.dying = false
	selfData.life = 540
	selfData.specialStart = false
	selfData.outline = true
	selfData.afterimageColor = duelistColors[math.random(1, #duelistColors)]
	selfData.afterimageBlack = false
end)
objLastingAfterimage:addCallback("step", function(self)
	local selfData = self:getData()
	local parent = selfData.parent
	
	if selfData.outline then 
		selfData.outline = false
		local outline = obj.EfOutline:create(0, 0)
		outline:set("rate", 0)
		outline:set("parent", self.id)
		outline.alpha = selfData.alpha
		outline.blendColor = Color.fromHex(0x0F82DC)
		if selfData.afterimageBlack then 
			outline.blendColor = Color.BLACK
			selfData.afterimageColor = Color.BLACK
		end
		outline.depth = self.depth + 1
		selfData.outlineObj = outline
	else
		local outline = selfData.outlineObj
		if outline and outline:isValid() then 
			outline.alpha = selfData.alpha
		end
	end
	
	if selfData.life > 0 then 
		selfData.life = selfData.life - 1
	else
		selfData.dying = true
	end	
	
	if selfData.dying then 
		selfData.alpha = selfData.alpha - 1/30
		
		if selfData.alpha <= 0 then 
			self:destroy()
		end	
	end
	
	if self:isValid() and selfData.specialStart then 
		local vfx = objAfterimage:create(self.x, self.y) 
		vfx.xscale = self.xscale
		vfx.yscale = self.yscale
		if parent then 
			vfx:getData().parent = parent
		end			
		vfx:getData().curSprite = 1
		vfx.sprite = spriteCombo[1]
		vfx:getData().fullCombo = true		
		vfx:getData().special = true
		vfx:getData().afterimageColor = selfData.afterimageColor
		vfx:getData().afterimageBlack = selfData.afterimageBlack
		self:destroy()
	end
end)
objLastingAfterimage:addCallback("draw", function(self)
	local selfData = self:getData()
	
	local clr = selfData.afterimageColor
	if selfData.life % 20 >= 15 then 
		clr = Color.WHITE
	end
	
	graphics.drawImage{
	x = self.x,
	y = self.y,
	image = self.sprite,
	subimage = self.subimage,
	xscale = self.xscale,
	yscale = self.yscale,
	angle = self.angle,
	alpha = selfData.alpha,
	solidColor = clr
	}
end)

objAfterimageUtility = Object.new("DuelistAfterimageUtility")
objAfterimageUtility:addCallback("create", function(self)
	local selfData = self:getData()
	
	self.sprite = sprites.idle 
	self.alpha = 0
	selfData.alpha = 2
	selfData.parent = nil
	self.spriteSpeed = 0
	selfData.outline = true
	selfData.afterimageColor = duelistColors[math.random(1, #duelistColors)]
	selfData.afterimageBlack = false
end)
objAfterimageUtility:addCallback("step", function(self)
	local selfData = self:getData()
	
	if selfData.outline then 
		selfData.outline = false
		local outline = obj.EfOutline:create(0, 0)
		outline:set("rate", 0)
		outline:set("parent", self.id)
		outline.alpha = selfData.alpha
		outline.blendColor = Color.fromHex(0x0F82DC)
		if selfData.afterimageBlack then 
			outline.blendColor = Color.BLACK
			selfData.afterimageColor = Color.BLACK
		end
		outline.depth = self.depth + 1
		selfData.outlineObj = outline
	else
		local outline = selfData.outlineObj
		if outline and outline:isValid() then 
			outline.alpha = selfData.alpha
		end
	end
	
	selfData.alpha = selfData.alpha - 1/30
		
	if selfData.alpha <= 0 then 
		self:destroy()
	end	
end)
objAfterimageUtility:addCallback("draw", function(self)
	local selfData = self:getData()
	
	graphics.drawImage{
	x = self.x,
	y = self.y,
	image = self.sprite,
	subimage = self.subimage,
	xscale = self.xscale,
	yscale = self.yscale,
	angle = self.angle,
	alpha = selfData.alpha,
	solidColor = selfData.afterimageColor
	}
end)

survivor:addCallback("step", function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	if playerData.comboReset and playerData.comboReset > 0 then 
		playerData.comboReset = playerData.comboReset - 1
		if 	playerData.comboReset == 0 then 
			playerData.combo = 1
		end
	end
end)

survivor:addCallback("useSkill", function(player, skill)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	if playerAc.activity == 0 then
		local cd = true
		if skill == 1 then 
			player:survivorActivityState(1, player:getAnimation("shoot1_"..playerData.combo), 0.24, true, true)
			playerData.comboReset = 90
			cd = false
		elseif skill == 2 then 
			player:survivorActivityState(2, player:getAnimation("shoot1_2"), 0.24, true, true)
		elseif skill == 3 then 
			player:survivorActivityState(3, player:getAnimation("shoot3"), 0.24, true, true)
		elseif skill == 4 then 
			local images = objLastingAfterimage:findAll()
			for _, img in ipairs(images) do 
				local parent = img:getData().parent
				if parent and parent:isValid() and parent == player then 
					img:getData().specialStart = true
				end
			end
		end
		if cd then 
			player:activateSkillCooldown(skill)
		end
	end
end)

survivor:addCallback("onSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	if skill == 1 then 
		local dir = playerAc.moveRight - playerAc.moveLeft
		if playerData.combo == 3 then 
			if relevantFrame == 4 then 
				local newx = player.x + dir * 3
				if not player:collidesMap(newx, player.y) then 
					player.x = newx
				end
				for i = 0, playerAc.sp do
					local bullet = player:fireExplosion(player.x + player.xscale * 5, player.y, 20/19, 15/4, 2)
					bullet:set("climb", (playerData.combo - 1) * 2)
					if i ~= 0 then
						bullet:set("climb", bullet:get("climb") + i * 8)
					end
				end			
			end
		else
			if relevantFrame == 3 then 
				local n = 0 
				if playerData.combo == 4 then 
					n = 0.5
				end
				local newx = player.x + dir * 3
				if not player:collidesMap(newx, player.y) then 
					player.x = newx
				end
				for i = 0, playerAc.sp do
					local bullet = player:fireExplosion(player.x + player.xscale * 5, player.y, 20/19, 15/4, 1.5 + n)
					bullet:set("climb", (playerData.combo - 1) * 2)
					if i ~= 0 then
						bullet:set("climb", bullet:get("climb") + i * 8)
					end
				end				
			end
		end
		if (playerData.combo == 3 and relevantFrame == 4) or (playerData.combo ~= 3 and relevantFrame == 3) then 
			for i = 0, playerAc.sp do 
				local vfx = objAfterimage:create(player.x - player.xscale * i * 5, player.y) 
				vfx.sprite = player.sprite 
				vfx.xscale = player.xscale
				vfx.yscale = player.yscale
				vfx.depth = player.depth + 1
				vfx:getData().parent = player
				vfx:getData().curSprite = playerData.combo
				vfx:getData().afterimageBlack = i > 0
			end
		end
		if relevantFrame == player.sprite.frames - 1 then 
			playerData.combo = playerData.combo % 4 + 1
		end
	elseif skill == 2 then 
		if relevantFrame == 3 then 
			playerData.xAccel = -3 * player.xscale
			for i = 0, playerAc.sp do
				local vfx = objAfterimage:create(player.x - player.xscale * i * 5, player.y) 
				vfx.sprite = player.sprite 
				vfx.xscale = player.xscale
				vfx.yscale = player.yscale
				vfx.depth = player.depth + 1
				vfx:getData().parent = player
				vfx:getData().lasting = true
				vfx:getData().curSprite = 2
				vfx:getData().fullCombo = true
				vfx:getData().afterimageBlack = i > 0
				local bullet = player:fireExplosion(player.x + player.xscale * 5, player.y, 20/19, 15/4, 1.5)
				if i ~= 0 then
					bullet:set("climb", bullet:get("climb") + i * 8)
				end
			end				
		end	
	elseif skill == 3 then 
		local maxDis = 80
		if relevantFrame == 9 then 
			playerData.stuckX = player.x 
			playerData.stuckY = player.y 
		end
		if player.subimage >= 9 and player.subimage < 13 then 
			if playerAc.invincible <= 8 then 
				playerAc.invincible = 8
			end
			player.x = playerData.stuckX
			player.y = playerData.stuckY
		end
		if relevantFrame == 10 then 
			local dis = 0
			while dis < maxDis and not player:collidesMap(player.x + player.xscale * dis, player.y) do 
				dis = dis + 1
			end
			playerData.utilityDis = dis 
			
			local vfx = obj.EfSparks:create(player.x, player.y)
			vfx.spriteSpeed = 0.24
			vfx.sprite = sprites.sparks1
			vfx.xscale = player.xscale
			vfx.yscale = player.yscale
			
			local vfx = obj.EfSparks:create(player.x + player.xscale * dis, player.y)
			vfx.spriteSpeed = 0.24
			vfx.sprite = sprites.sparks2
			vfx.xscale = player.xscale
			vfx.yscale = player.yscale
		end
		if relevantFrame == 13 then 
			local dis = playerData.utilityDis
			player.x = player.x + dis * player.xscale
			local bullet = player:fireExplosion(player.x - player.xscale * dis / 2, player.y, dis/19, 15/4, 2)
			bullet:getData().duelistAfterimage = true 
			bullet:getData().duelistY = player.y
			bullet:getData().duelistDirection = player.xscale
			bullet:getData().afterimageBlack = playerAc.sp > 0 
			playerData.xAccel = player.xscale * 3
		end
		if relevantFrame == 5 or relevantFrame == 13 then 
			for i = 0, playerAc.sp do 
				local vfx = objAfterimage:create(player.x - player.xscale * i * 5, player.y) 
				vfx.sprite = sprites.shoot1_1
				vfx.spriteSpeed = player.spriteSpeed
				vfx.xscale = player.xscale
				vfx.yscale = player.yscale
				vfx.depth = player.depth + 1
				vfx:getData().parent = player
				vfx:getData().curSprite = 1
				if relevantFrame == 13 then 
					vfx:getData().curSprite = 2
					vfx.sprite = sprites.shoot1_2
				end
				vfx:getData().fullCombo = true
				vfx:getData().lasting = true
				vfx:getData().afterimageBlack = i > 0
				
				local bullet = player:fireExplosion(player.x + player.xscale * 5, player.y, 20/19, 15/4, 1.5)
				if i ~= 0 then
					bullet:set("climb", bullet:get("climb") + i * 8)
				end
			end
		end
	elseif skill == 4 then 
	
	end
end)

callback.register("preHit", function(damager, hit)
	if damager and hit and hit:isValid() and damager:getData().duelistAfterimage then 
		local vfx = objAfterimageUtility:create(hit.x, damager:getData().duelistY)
		vfx.xscale = damager:getData().duelistDirection
		local rng = math.random(1, 4)
		vfx.sprite = spriteCombo[rng]
		vfx.subimage = 3
		vfx.depth = hit.depth - 1
		vfx:getData().afterimageBlack = damager:getData().afterimageBlack
		if rng == 3 then 
			vfx.subimage = 4
		end
	end
end)

