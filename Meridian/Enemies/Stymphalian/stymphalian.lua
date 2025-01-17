local path = "Enemies/Stymphalian/"
local sprites = {
	idle = Sprite.load("StymphalianIdle", path.."idle", 1, 80, 80),
	
	shoot1 = Sprite.load("StymphalianShoot1", path.."shoot1", 8, 80, 80),
	
	feather = Sprite.load("StymphalianFeather", path.."feather", 1, 20, 1),
	featherMask = Sprite.load("StymphalianFeatherMask", path.."featherMask", 1, 1, 1)
}

local sounds = {

}

local stym = Object.base("Boss", "Stymphalian")
stym.sprite = sprites.idle

--EliteType.registerPalette(sprites.palette, stym) 

local shoot1Cd = 4 * 60
local shoot2Cd = 12 * 60
local shoot3Cd = 14 * 60
local shoot4Cd = 26 * 60

local dashCd = 12 * 60

local flyRadius = 80
local flyRadiusSpeed = 3

stym:addCallback("create", function(actor)
    local actorAc = actor:getAccessor()
    local actorData = actor:getData()
	
	actor.mask = sprites.idle
	
	actorData.spawnAnim = true
	
	--sounds.spawn:play(1, 1)
		
	actorAc.name = "Stymphalian"
	actorAc.name2 = "Wings of Stone"
	actorAc.maxhp = 1200 * Difficulty.getScaling("hp")
	actorAc.hp = actorAc.maxhp
	actorAc.damage = 20 * Difficulty.getScaling("damage")
	actorAc.pHmax = 1.2
	actorAc.walk_speed_coeff = 1
	--actor:setAnimations{
	--	palette = sprites.palette
	--}
	--actorAc.sound_hit = Sound.find("GolemHit","vanilla").id
	--  actorAc.sound_death = Sound.find("GolemDeath","vanilla").id
	-- actor.mask = sprites.mask
	actorAc.health_tier_threshold = 1
	actorAc.knockback_cap = actorAc.maxhp
	actorAc.exp_worth = 60 * Difficulty.getScaling()
	actorAc.can_drop = 0
	actorAc.can_jump = 0
	actor:setAlarm(2, shoot1Cd / 2)
	actor:setAlarm(3, shoot2Cd / 2)
	actor:setAlarm(4, 1 * 60)
	actorData.state = "idle"
	actorData.dashCd = 0
	--actorData.goal = {x = 0, y = 0}
	actorData.angle = 0
	actorData.dashDis = 0
	actorData.speed = 6
	actorData.goalSpeed = 6
	actorData.goalAngle = 0 
	actorData.goalDistance = 0
	actorData.curDistance = 0
	actorData.radiusCenter = {x = 0, y = 0}
	actorData.radiusAngle = 0
	actorData.radiusMovement = -1 * 80
	actorData.radiusDir = 1
	actorData.primaryType = true
end)

local objFeather = Object.new("StymFeather")
objFeather:addCallback("create", function(self)
	local selfData = self:getData()
	
	selfData.parent = nil 
	self.sprite = sprites.feather 
	selfData.length = 0
	selfData.maxLength = 120
	selfData.exploded = false
	self.angle = 0
	selfData.noColY = 0
	selfData.dealtDamage = false
	self.mask = sprites.featherMask
end)
objFeather:addCallback("step", function(self)
	local selfData = self:getData()
	local parent = selfData.parent
	
	if parent then 
		local r = 12
		local colCheck 
		local dis = 0
		if not selfData.exploded then
			for i = 1, 10 do 
				colCheck = self:collidesMap(self.x + math.cos(math.rad(self.angle)) * i, self.y - math.sin(math.rad(self.angle)) * i) and self.y - math.sin(math.rad(self.angle)) * i > selfData.noColY
				if colCheck then 
					break
				end
				dis = dis + 1
			end 
			self.x = self.x + math.cos(math.rad(self.angle)) * dis 
			self.y = self.y - math.sin(math.rad(self.angle)) * dis
		end
		if not selfData.dealtDamage then 
			for _, act in ipairs(pobj.actors:findAllEllipse(self.x - r, self.y + r, self.x + r, self.y - r)) do 
				if act and act:isValid() and parent:get("team") ~= act:get("team") then 
					local bullet = parent:fireExplosion(self.x, self.y, r/38, r/8, 1)
					selfData.dealtDamage = true	
				end
			end		
		end
		if colCheck then 
			local bullet = parent:fireExplosion(self.x, self.y, r/38, r/8, 1)
			selfData.exploded = true
			selfData.dealtDamage = true
		end
		if self:isValid() then 
			selfData.length = selfData.length + 1
			if selfData.length >= selfData.maxLength then 
				self:destroy()
			end
		end
	end
end)

local objFeatherDecoy = Object.new("StymFeatherDecoy")
objFeatherDecoy:addCallback("create", function(self)
	local selfData = self:getData()
	
	selfData.parent = nil 
	self.sprite = sprites.feather 
	selfData.length = 0
	selfData.maxLength = 30
	self.angle = 90
	selfData.noColY = 0
	selfData.targetX = 0
end)
objFeatherDecoy:addCallback("step", function(self)
	local selfData = self:getData()
	
	if selfData.parent then 
		self.alpha = (selfData.maxLength - selfData.length) / selfData.maxLength
		self.x = self.x + math.cos(math.rad(self.angle)) * 15
		self.y = self.y - math.sin(math.rad(self.angle)) * 15
		if self:isValid() then 
			selfData.length = selfData.length + 1
			if selfData.length >= selfData.maxLength then 
				--for i = 1, 2 do
					local bullet = objFeather:create(math.random(selfData.targetX - 60, selfData.targetX + 60), self.y)
					local n = math.random(-2, 2)
					bullet:getData().parent = selfData.parent
					bullet:getData().noColY = selfData.noColY
					bullet.angle = 270 + n
					bullet.depth = self.depth
					self:destroy()
				--end
			end
		end
	end
end)

findStymTarget = function(actor)
	local trg 
	local dis  
	local player
	--local r1 = 900
	--local r2 = 900
	for _, act in ipairs(pobj.actors:findAll()) do 
		if act and act:isValid() and actor:get("team") ~= act:get("team") then 
			local play = isa(act, "PlayerInstance")
			local ds = distance(actor.x, actor.y, act.x, act.y) 
			if not dis or dis > ds then 
				if play and not player then 
					player = true
				end
				if not player or (player and play) then
					dis = ds 
					trg = act
				end
			end
		end
	end 
	return trg
end

stym:addCallback("step", function(actor)
	local actorAc = actor:getAccessor()
	local actorData = actor:getData()
	actorAc.hp = math.min(actorAc.hp, actorAc.maxhp)
	if misc.getTimeStop() == 0 then
		if not modloader.checkMod("Starstorm") then
			if actor:get("invincible") and actor:get("invincible") > 0 then
				actor:set("invincible", actor:get("invincible") - 1)
			end
		end	
		if actorData.dashCd > 0 then 
			actorData.dashCd = actorData.dashCd - 1
		end
		if actorData.radiusAngle then 
			actorData.radiusAngle = (actorData.radiusAngle + flyRadiusSpeed) % 360
		end
		if actorData.radiusDir > 0 then 
			actorData.radiusMovement = actorData.radiusMovement + actorData.radiusDir
			if actorData.radiusMovement >= 80 then 
				actorData.radiusDir = -1
			end
		else
			actorData.radiusMovement = actorData.radiusMovement + actorData.radiusDir
			if actorData.radiusMovement <= -80 then 
				actorData.radiusDir = 1
			end			
		end
		if actorData.state == "idle" or actorData.state == "chase" or actorData.state == "dash" then 
			local x1 = actor.x
			local y1 = actor.y
			--local dis = distance(x1, y1, actorData.radiusCenter.x, actorData.radiusCenter.y)
			--if actorData.state == "chase" and dis <= flyRadius then 
				
			--end
			if actorData.state == "chase" then 
				local x2 = actorData.radiusCenter.x + math.cos(math.rad(actorData.radiusAngle)) * flyRadius
				local y2 = actorData.radiusCenter.y - math.sin(math.rad(actorData.radiusAngle)) * flyRadius
				actorData.goalAngle = posToAngle(x1, y1, x2, y2)
			end
			
			actor.x = actor.x + math.cos(math.rad(actorData.angle)) * actorData.speed
			actor.y = actor.y - math.sin(math.rad(actorData.angle)) * actorData.speed
			actorData.curDistance = actorData.curDistance + distance(x1, y1, actor.x, actor.y)
			actorData.speed = math.approach(actorData.speed, actorData.goalSpeed, math.sign((actorData.goalSpeed - actorData.speed)) * 3/60)
			actorData.angle = (actorData.angle - angleDif(actorData.angle, actorData.goalAngle) * 0.05) % 360
			local n = math.sign(math.cos(math.rad(actorData.goalAngle)))
			if actorAc.target and not actorData.state == "dash" then 
				local trg = Object.findInstance(actorAc.target)
				if trg and trg:isValid() then 
					n = math.sign(actor.x - trg.x)
				end
			end
			if n ~= 0 then 
				actor.xscale = n
			end
		end
		if actorData.state == "idle" then 
			actor.sprite = sprites.idle 
			local trg = findStymTarget(actor) 
			if trg then 
				if isa(trg, "PlayerInstance") then 
					actorAc.target = trg:get("child_poi")
				else
					actorAc.target = trg.id
				end
				if distance(actor.x, actor.y, trg.x, trg.y) > 300 and actorData.dashCd == 0 then 
					actorData.state = "dash"
					
					local angle = posToAngle(actor.x, actor.y, trg.x, trg.y)
					local dis = distance(actor.x, actor.y, trg.x, trg.y) + 150
					
					--[[local rng = math.random(-50, 50)
					if rng == 0 then rng = rng + 1 end
					local xx = trg.x + rng + 100 * math.sign(rng)
					local yy = trg.y - rng - 100]]
					
					actorData.speed = 7
					actorData.goalSpeed = 7
					
					actorData.curDistance = 0 
					actorData.goalDistance = dis
					actorData.angle = angle
					actorData.goalAngle = actorData.angle
				else
					actorData.state = "chase"
					actorData.curDistance = 0 
				end
			else
			
			end
		elseif actorData.state == "dash" then 
			actor.sprite = sprites.idle 
			if actorData.curDistance > actorData.goalDistance then 
				actorData.state = "idle"
				actorData.dashCd = dashCd
				actorData.goalSpeed = 4
			end
		elseif actorData.state == "chase" then 
			actor.sprite = sprites.idle 
			if actorAc.target then 
				local trg = Object.findInstance(actorAc.target)
				if trg and trg:isValid() then 
					actorData.radiusCenter.x = trg.x + actorData.radiusMovement
					actorData.radiusCenter.y = trg.y - 50
					local atkDis = distance(actor.x, actor.y, trg.x, trg.y)
					local atkAngle = math.abs(posToAngle(actor.x, actor.y, trg.x, trg.y) - 180)
					if atkDis > 60 then 
						if actor:getAlarm(2) == -1 then 
							if (atkAngle >= 210 and atkAngle <= 255) or (atkAngle >= 285 and atkAngle <= 330) then 
								actorData.state = "shoot1"
								actorData.shoot1Angle = posToAngle(actor.x, actor.y, trg.x, trg.y)
								actorData.shoot1TargetX = trg.x
								actorData.shoot1TargetY = trg.y
								actor:setAlarm(2, shoot1Cd)
								actor.subimage = 1
								actorData.shoot1Timer = 0
								if actorData.primaryType then 
									actorData.shoot1Choice = "arti" 
								else	
									actorData.shoot1Choice = "direct" 
								end
								actorData.primaryType = not actorData.primaryType
							end
						elseif actorData.dashCd == 0 then 
							actorData.state = "dash"
							local angle = posToAngle(actor.x, actor.y, trg.x, trg.y)
							local dis = distance(actor.x, actor.y, trg.x, trg.y) + 150
							
							--[[local rng = math.random(-50, 50)
							if rng == 0 then rng = 1 end
							local yrng = math.random(-2, 1) 
							if yrng == 0 then yrng = 1 end
							local xx = trg.x + rng + 100 * math.sign(rng)
							local yy = trg.y - rng - 100 * math.sign(yrng)]]
							
							actorData.speed = 7
							actorData.goalSpeed = 7
							
							actorData.curDistance = 0 
							actorData.goalDistance = dis
							actorData.angle = angle
							actorData.goalAngle = actorData.angle							
						end
					end
				else
					actorData.state = "idle"
				end
			else
				actorData.state = "idle"
			end
		elseif actorData.state == "shoot1" then 
			actor.sprite = sprites.shoot1
			actor.spriteSpeed = 0.2
			
			
			if math.floor(actor.subimage) == 6 then 
				if actorData.shoot1Timer < 3 then 
					for i = 1, 2 do 
						if actorData.shoot1Choice == "direct" then 
							local bullet = objFeather:create(math.random(actor.x - 20, actor.x + 20), math.random(actor.y - 20, actor.y + 20))
							local n = math.random(-2, 2)
							bullet:getData().parent = actor
							bullet:getData().noColY = actorData.shoot1TargetY
							bullet.angle = actorData.shoot1Angle + n
							bullet.depth = actor.depth - 1
						elseif actorData.shoot1Choice == "arti" then 
							for j = 1, 2 do
								local bullet = objFeatherDecoy:create(math.random(actor.x - 20, actor.x + 20), math.random(actor.y - 20, actor.y + 20))
								bullet:getData().parent = actor
								bullet:getData().noColY = actorData.shoot1TargetY
								bullet:getData().targetX = actorData.shoot1TargetX	
								bullet.depth = actor.depth - 1	
							end
						end
					end
				end
				actorData.shoot1Timer = actorData.shoot1Timer + 1
			end
			
			if math.floor(actor.subimage) == actor.sprite.frames then 
				actorData.state = "idle"
			end
		end
	end
end)

-------------------------------------

local card = MonsterCard.new("Stymphalian", stym)
--card.sprite = sprites.spawn
--card.sound = sounds.spawn
--card.canBlight = true
card.type = "offscreen"
card.cost = 800
card.isBoss = true