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
	shoot1_4 = Sprite.load("DuelistShoot1_4", path.."shoot1_4", 7, 8, 15)
}

local sounds = {

}

local sprSkills = Sprite.load("DuelistSkills", path.."idle", 4, 0, 0) -- placeholder

survivor.loadoutColor = Color.fromHex(0x8BACE0)

survivor.loadoutSprite = Sprite.load("ReaperSelect", path.."idle", 1, 2, 0) -- placeholder

callback.register("postLoad", function()
	if modloader.checkMod("Starstorm") then
		SurvivorVariant.setInfoStats(SurvivorVariant.getSurvivorDefault(survivor), {{"Strength", 5}, {"Vitality", 6}, {"Toughness", 3}, {"Agility", 7}, {"Difficulty", 6}, {"Placeholder", 8}})
		SurvivorVariant.setDescription(SurvivorVariant.getSurvivorDefault(survivor), "Placeholder")
	end
end)

survivor:setLoadoutInfo(
[[The ]]..colorString("Duelist", survivor.loadoutColor)..[[ is placeholder.
]]
, sprSkills)

survivor:setLoadoutSkill(1, "1",
[[.
]])

survivor:setLoadoutSkill(2, "2",
[[.
]])

survivor:setLoadoutSkill(3, "3",
[[.
]])

survivor:setLoadoutSkill(4, "4",
[[.
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
	
	playerAc.pHmax = 1.45
	player:set("walk_speed_coeff", 1)
	
    player:setSkill(1, "1", ".",
    sprSkills, 1, 30)
	
    player:setSkill(2, "2", ".",
    sprSkills, 2, 60 * 2)

    player:setSkill(3, "3", ".",
    sprSkills, 3, 60 * 6)

    player:setSkill(4, "4", ".",
    sprSkills, 4, 60 * 8)
end)

survivor:addCallback("levelUp", function(player)
	player:survivorLevelUpStats(24, 3, 0.0016, 1)
end)

objAfterimage = Object.new("DuelistAfterimage") 
local startAlpha = 0.6
objAfterimage:addCallback("create", function(self)
	local selfData = self:getData()
	
	self.sprite = sprites.idle 
	self.spriteSpeed = 0.3
	self.alpha = 0
	selfData.alpha = startAlpha
	selfData.multiple = 0
	selfData.parent = nil
	selfData.attack = false
end)
objAfterimage:addCallback("step", function(self)
	local selfData = self:getData()
	local parent = selfData.parent 
	
	if parent and not selfData.attack then 
		local n = 0
		if self.sprite == sprites.shoot1_3 or self.sprite == sprites.shoot1_4 then 
			n = 0.5
		end
		local dmg = parent:get("damage") * (1.5 + n) * ((selfData.multiple + 1) / 4) * 0.5
		if self.sprite == sprites.shoot1_3 then 
			if self.subimage >= 4 then  
				local bullet = misc.fireExplosion(self.x + self.xscale * 5, self.y, 20/19, 15/4, dmg, parent:get("team"))
				bullet:set("climb", (2 - selfData.multiple) * 4)
				selfData.attack = true
			end
		else
			if self.subimage >= 3 then 
				local bullet = misc.fireExplosion(self.x + self.xscale * 5, self.y, 20/19, 15/4, dmg, parent:get("team"))
				bullet:set("climb", (2 - selfData.multiple) * 4)
				selfData.attack = true
			end			
		end
	end
	
	if math.floor(self.subimage) == self.sprite.frames then 
		if selfData.alpha == startAlpha and selfData.multiple > 0 then 
			local vfx = objAfterimage:create(self.x, self.y) 
			vfx.sprite = self.sprite 
			vfx.xscale = self.xscale
			vfx.yscale = self.yscale
			vfx:getData().multiple = selfData.multiple - 1
			vfx.spriteSpeed = self.spriteSpeed * 0.8
			if parent then 
				vfx:getData().parent = parent
			end
		end
		self.spriteSpeed = 0
		selfData.alpha = selfData.alpha - 1/60
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
	solidColor = Color.fromHex(0x8BACE0)
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
		if skill == 1 then 
			player:survivorActivityState(1, player:getAnimation("shoot1_"..playerData.combo), 0.24, true, true)
			playerData.combo = playerData.combo % 4 + 1
			playerData.comboReset = 90
		end
	end
end)

survivor:addCallback("onSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	if skill == 1 then 
		if playerData.combo == 3 then 
			if relevantFrame == 4 then 
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
				for i = 0, playerAc.sp do
					local bullet = player:fireExplosion(player.x + player.xscale * 5, player.y, 20/19, 15/4, 1.5 + n)
					bullet:set("climb", (playerData.combo - 1) * 2)
					if i ~= 0 then
						bullet:set("climb", bullet:get("climb") + i * 8)
					end
				end				
			end
		end
		if relevantFrame == player.sprite.frames - 1 then 
			local vfx = objAfterimage:create(player.x, player.y) 
			vfx.sprite = player.sprite 
			vfx.xscale = player.xscale
			vfx.yscale = player.yscale
			vfx:getData().multiple = 2
			vfx.depth = player.depth + 1
			vfx:getData().parent = player
		end
	end
end)

