local path = "Enemies/Lacertian/"
local sprites = {
    idle = Sprite.load("LacertianIdle", path.."idle", 1, 85, 51),
    walk = Sprite.load("LacertianWalk", path.."walk", 8, 85, 53),
    spawn = Sprite.load("LacertianSpawn", path.."spawn", 10, 100, 107),
    death = Sprite.load("LacertianDeath", path.."death", 8, 85, 71),
	jump = Sprite.load("LacertianJump", path.."fall", 1, 85, 57),
	shoot1 = Sprite.load("LacertianShoot1", path.."shoot1", 7, 85, 60),
	burrow = Sprite.load("LacertianBurrow", path.."burrow", 10, 85, 51),
	shoot2 = Sprite.load("LacertianShoot2", path.."shoot2", 7, 90, 80), -- 
	shoot2neutral = Sprite.load("LacertianShoot2Neutral", path.."shoot2neutral", 7, 90, 80),
	mask = Sprite.load("LacertianMask", path.."mask", 1, 85, 51),
	mask2 = Sprite.load("LacertianMask2", path.."maskBelow", 1, 30, 51),
	mask3 = Sprite.load("LacertianMask3", path.."maskAbove", 1, 15, 31),
	maskNone = Sprite.load("LacertianMaskNone", path.."maskNone", 1, 0, 50),
	warn1 = Sprite.load("LacertianWarning1", path.."shoot2warning", 6, 74, 51),
	warn2 = Sprite.load("LacertianWarning2", path.."shoot2neutralWarning", 6, 74, 51),
	palette = Sprite.load("LacertianPalette", path.."palette", 1, 0, 0),
	portrait = Sprite.load("LacertianPortrait", path.."portrait", 1, 119, 199) --
}	

local sounds = {
	spawn = Sound.load("LacertianSpawnSound", path.."sndSpawn")
}

local lacertian = Object.base("Boss", "Lacertian")
lacertian.sprite = sprites.idle

EliteType.registerPalette(sprites.palette, lacertian)

local shoot1Cd = 6 * 60
local shoot2Cd = 9 * 60
local burrowCd = 4 * 60

lacertian:addCallback("create", function(actor)
    local actorAc = actor:getAccessor()
    local actorData = actor:getData()
	
	actor.mask = sprites.mask
	--[[local ground = obj.BossSpawn:findNearest(actor.x, actor.y)
	if ground then
		local xx = ground.x + (ground.xscale * 15 * 16 * 0.5)
		actor.x = xx
		actor.y = ground.y - actor.mask.height + actor.mask.yorigin
		actorAc.ghost_x = actor.x
		actorAc.ghost_y = actor.y
	end]]
	
	actorData.spawnAnim = true
	
	local x1, y1
	local player = misc.players[math.random(1, #misc.players)]
	if player then 
		x1, y1 = findLacertianSpawn(actor, player.x, player.y)
	end
	
	if x1 and y1 then 
		sounds.spawn:play(1, 1)
		actor.x = x1
		actor.y = y1
		actorAc.ghost_x = actor.x
		actorAc.ghost_y = actor.y
		
		actorAc.name = "Lacertian"
		actorAc.name2 = "Relentless Pursuer"
		actorAc.maxhp = 900 * Difficulty.getScaling("hp")
		actorAc.hp = actorAc.maxhp
		actorAc.damage = 25 * Difficulty.getScaling("damage")
		actorAc.pHmax = 0.9
		actorAc.walk_speed_coeff = 1
	--[[    actor:setAnimations{
			idle = sprites.idle,
			jump = sprites.jump,
			walk = sprites.walk,
			death = sprites.death,
			shoot1 = sprites.shoot1,
			palette = sprites.palette
		}]]
		--actorAc.sound_hit = Sound.find("GolemHit","vanilla").id
	  --  actorAc.sound_death = Sound.find("GolemDeath","vanilla").id
	   -- actor.mask = sprites.mask
		actorAc.health_tier_threshold = 1
		actorAc.knockback_cap = actorAc.maxhp
		actorAc.exp_worth = 60 * Difficulty.getScaling()
		actorAc.can_drop = 0
		actorAc.can_jump = 0
		actorData.inIdle = 0
		actorData.shoot1Cd = shoot1Cd / 2
		actorData.shoot2Cd = shoot2Cd / 2
		actorData.burrowCd = burrowCd
		actorData.animLoop = 0
		
	else
		actor:destroy()
	end
	
end)

findLacertianSpawn = function(actor, x, y)
	local xFinal = x
	local yFinal = y
	
	local disMin
	local grounds = getAllGround()
	for _, ground in ipairs(grounds) do 
		--local groundY = ground.y - ground.mask.height + ground.mask.yorigin - 1
		--local groundX1 = ground.x - ground.mask.width + ground.mask.xorigin
		--local groundX2 = ground.x + ground.mask.width - ground.mask.xorigin
		local groundY = ground.y - actor.mask.height + actor.mask.yorigin
		local groundX1 = ground.x 
		local groundX2 = ground.x + ground.xscale * 16
		--for i = groundX1, groundX2, 16 do 
			i = (groundX1 + groundX2) / 2
			local x1, x2 = findLacertianWalk(actor, i, groundY)
			if x1 and x2 then 
				local dis = distance(i, groundY, x, y)
				if not disMin or dis < disMin then 
					xFinal = (x1 + x2) / 2
					yFinal = groundY
					disMin = dis
				end
			end
		--end
	end	
	return xFinal, yFinal
end

getAllGround = function()
	local grounds = {}
	grounds = obj.B:findAll()
	for _, i in ipairs(obj.BossSpawn:findAll()) do 
		table.insert(grounds, i) 
	end
	for _, i in ipairs(obj.BossSpawn2:findAll()) do 
		table.insert(grounds, i) 
	end
	return grounds
end

--[[Monster.giveAI(lacertian)

Monster.setSkill(lacertian, 1, 90, 6 * 60, function(actor)
	actor:getData().theTarget = obj.POI:findNearest(actor.x, actor.y)
	Monster.setActivityState(actor, 1, actor:getAnimation("shoot1"), 0.2, true, true)
	Monster.activateSkillCooldown(actor, 1)
	actor:getData().chompCount = 2
end)
Monster.skillCallback(lacertian, 1, function(actor, relevantFrame)
	if relevantFrame == 5 then 		
		actor:fireExplosion(actor.x + actor.xscale * 50, actor.y - 5, 25/19, 15/4, 1)
		actor:getData().xLacertAccel = actor.xscale * 3
	end
	if relevantFrame == 6 and actor:getData().chompCount > 0 then 
		actor.xscale = math.sign(actor:getData().theTarget.x - actor.x)
		if actor.xscale == 0 then 
			actor.xscale = 1
		end
		actor:getData().chompCount = actor:getData().chompCount - 1
		actor:getAccessor().activity = 0 
		Monster.setActivityState(actor, 1, actor:getAnimation("shoot1"), 0.2, true, true)
		Monster.activateSkillCooldown(actor, 1)
	end
end)]]

findLacertianGround = function(actor, x, y)
--[[	local disX1 = 0
	local disX2 = 0 
	local x1
	local x2
	while obj.B:findLine(x + disX1, y, x + disX1, y + 12) and not obj.B:findLine(x + disX1, y - 12, x + disX1, y - 12 - sprites.mask.height) do 
		disX1 = disX1 + 1 
	end
	while obj.B:findLine(x - disX2, y, x - disX2, y + 12) and not obj.B:findLine(x - disX2, y - 12, x - disX2, y - 12 - sprites.mask.height) do 
		disX2 = disX2 + 1 
	end	
	print(disX1 + disX2)
	print(sprites.mask.width / 2)
	if disX1 + disX2 > sprites.mask.width / 2 then 
		x1 = x + disX1 - sprites.mask.width / 4
		x2 = x - disX2 + sprites.mask.width / 4
	end
	return x2, x1]]
	
	actor.mask = sprites.mask2
	local checkDown = actor:collidesMap(x, y + 12)
	actor.mask = sprites.mask3
	local checkUp = not actor:collidesMap(x, y - 12)
	actor.mask = sprites.mask
	return checkDown and checkUp
end

findLacertianWalk = function(actor, x, y)
	local disX1 = 0
	local disX2 = 0 
	local x1
	local x2
	while findLacertianGround(actor, x + disX1, y) do 
		disX1 = disX1 + 1
	end
	while findLacertianGround(actor, x - disX2, y) do 
		disX2 = disX2 + 1
	end
	if disX1 + disX2 > sprites.mask2.width then 
		x1 = x + disX1
		x2 = x - disX2
	end
	return x2, x1
end

findLacertianTarget = function(actor)
	local trg 
	local dis  
	local movement
	local flying = true
	local r1 = 600
	local r2 = 600
	for _, act in ipairs(pobj.actors:findAllEllipse(actor.x - r1, actor.y + r2, actor.x + r1, actor.y - r2)) do 
		if act and act:isValid() and actor:get("team") ~= act:get("team") then 
			local onFoot = true 	
			local dir = math.sign(act.x - actor.x) 
			for i = 0, math.abs(act.x - actor.x) do 
				local xx = actor.x + i * dir
				onFoot = findLacertianGround(actor, xx, actor.y)
				--onFoot = obj.B:findLine(xx, actor.y, xx, actor.y + 12) and not obj.B:findLine(xx, actor.y - 12, xx, actor.y - 12 - actor.sprite.height)
				if not onFoot then 
					break
				end
			end
			local ground
			if not onFoot and not movement then 
				ground = findLacertianGround(actor, act.x, act.y)
			end
			if onFoot and not movement then 
				movement = true 
			end
			flying = flying and not (ground or onFoot) and not actor:getAccessor().state == "burrow"
			if onFoot or ground or flying then  
				local ds = distance(actor.x, actor.y, act.x, act.y) 
				if not dis or dis > ds then 
					dis = ds 
					trg = act
				end
			end
		end
	end 
	return trg
end

lacertianPathfind = function(actor, target)
	local moveType
	local r1 = 600
	local r2 = 600
	if target and target:isValid() then 
		if actor.x - r1 < target.x and actor.x + r1 > target.x and actor.y - r2 < target.y and actor.y + r2 > target.y then 
			local onFoot = true 	
			local dir = math.sign(target.x - actor.x) 
			for i = 0, math.abs(target.x - actor.x) do 
				local xx = actor.x + i * dir
				onFoot = findLacertianGround(actor, xx, actor.y)
				--onFoot = obj.B:findLine(xx, actor.y, xx, actor.y + 12) and not obj.B:findLine(xx, actor.y - 12, xx, actor.y - 12 - actor.sprite.height)
				if not onFoot then 
					break
				end
			end
			local ground
			if not onFoot then 
				ground = findLacertianGround(actor, target.x, target.y)
				if ground then 
					moveType = "burrow"
				else 
					moveType = "observe"
				end
			else
				moveType = "walk"
			end
		end
	end
	return moveType
end

lacertian:addCallback("step", function(actor)
	local actorAc = actor:getAccessor()
	local actorData = actor:getData()
	
	if actor and actor:isValid() then 
		if actorData.spawnAnim then 
			actor.spriteSpeed = 0.2
			actor.sprite = sprites.spawn 
			if math.floor(actor.subimage) == actor.sprite.frames then 
				actorData.spawnAnim = nil
				actorAc.state = "idle"
			end		
		else
			if actorData.xLacertAccel then
				if actorData.xLacertAccel ~= 0 then
					actorData.xLacertAccel = math.approach(actorData.xLacertAccel, 0, 0.1)
					local newx = actor.x + actorData.xLacertAccel
					actor.mask = sprites.mask2
					local xPass = actor:collidesMap(actor.x + math.sign(actorData.xLacertAccel) * actor.mask.width, actor.y + 12)
					actor.mask = sprites.mask3
					local yPass = not actor:collidesMap(newx, actor.y - 12)
					if xPass and yPass then 
						actor.x = newx
					else 
						actorData.xLacertAccel = nil
					end
					actor.mask = sprites.mask 
				else
					actorData.xLacertAccel = nil
				end
			end		
		
			local timesMax = 0
			local n = 0
			local m = 0
			while actor:collidesMap(actor.x + n, actor.y) and actor:collidesMap(actor.x - m, actor.y) and timesMax < 100 do
				if actor:collidesMap(actor.x + n, actor.y) then 
					n = n + 1
				elseif actor:collidesMap(actor.x - m, actor.y) then 
					m = m + 1
				end
				timesMax = timesMax + 1
			end 
			if n < m then 
				actor.x = actor.x + n 
			else
				actor.x = actor.x - m
			end
			
			--[[timesMax = 0
			n = 0
			m = 0
			while timesMax < 100 do
				actor.mask = sprites.mask3 
				if actor:collidesMap(actor.x, actor.y - n) then 
					n = n + 1
				else
					break
				end
				actor.mask = sprites.mask2
				if not actor:collidesMap(actor.x, actor.y + m) then 
					m = m + 1
				else
					break
				end
				timesMax = timesMax + 1
			end 
			if n < m then 
				actor.y = actor.y - n 
			else
				actor.y = actor.y + m
			end	
			actor.mask = sprites.mask]]
			
			if actorData.shoot1Cd > 0 then 
				actorData.shoot1Cd = actorData.shoot1Cd - 1
			end
			
			if actorData.shoot2Cd > 0 then 
				actorData.shoot2Cd = actorData.shoot2Cd - 1
			end
			
			if actorData.burrowCd > 0 then 
				actorData.burrowCd = actorData.burrowCd - 1
			end
			
			if actorAc.state == "idle" or actorAc.state == "chase" then
				local n = actorAc.moveRight - actorAc.moveLeft
				if n ~= 0 and findLacertianGround(actor, actor.x + sprites.mask.width / 2 * n, actor.y) then 
					n = actorAc.moveRight - actorAc.moveLeft
					actor.x = actor.x + n * actorAc.pHmax 
					actor.xscale = n 
					actor.sprite = sprites.walk
					actor.spriteSpeed = 0.2
				else
					actor.sprite = sprites.idle 
				end
			end
			
			if actorAc.state == "idle" then 
				local trg = findLacertianTarget(actor)
				if trg then 
					if isa(trg, "PlayerInstance") then 
						actorAc.target = trg:get("child_poi")
					else
						actorAc.target = trg.id
					end
					actorAc.state = "chase"
					actorData.inIdle = 0
				else
					actorData.inIdle = math.min(actorData.inIdle + 1, 600)
					if actorData.burrowCd == 0 and actorData.inIdle == 600 then 
						actorData.inIdle = 0 
						actorAc.state = "burrowAnim"
					else 
						if global.timer % 120 == 0 then 
							local x1, x2 = findLacertianWalk(actor, actor.x, actor.y)
							if x1 and x2 then 
								actorData.wander = math.random(x1, x2)
							end
						end
						if actorData.wander then 
							local n = actorData.wander - actor.x
							if math.abs(n) > 20 then 
								if math.sign(n) == 1 then 
									actorAc.moveLeft = 0
									actorAc.moveRight = 1 
								else 
									actorAc.moveRight = 0
									actorAc.moveLeft = 1
								end
							else 
								actorAc.moveRight = 0
								actorAc.moveLeft = 0
							end
						end
					end
				end
			elseif actorAc.state == "burrowAnim" then 
				actorAc.moveRight = 0
				actorAc.moveLeft = 0
				actor.sprite = sprites.burrow 
				actor.spriteSpeed = 0.2 
				if math.floor(actor.subimage) == actor.sprite.frames then 
					actorAc.state = "burrow"
				end
			elseif actorAc.state == "burrow" then 
				actor:set("invincible", math.max(8, actor:get("invincible")))
				actorAc.moveRight = 0
				actorAc.moveLeft = 0
				actor.alpha = 0 
				actor.mask = sprites.maskNone
				local trg = findLacertianTarget(actor)
				if trg then 
					if isa(trg, "PlayerInstance") then 
						actorAc.target = trg:get("child_poi")
					else
						actorAc.target = trg.id
					end
					local mv = lacertianPathfind(actor, trg)
					local x1, x2 = findLacertianWalk(actor, trg.x, trg.y) 
					if mv and x1 and x2 and actorData.burrowCd == 0 and trg:get("activity") ~= 30 and trg:get("free") == 0 then 
						actor.xscale = math.sign(trg.x - actor.x)
						local n
						local minDis
						local yy = trg.y + trg.sprite.yorigin
						for i = x1, x2 do 
							local groundCheck = findLacertianGround(actor, i, yy)
							local dis = distance(i, yy, trg.x, yy) 
							if (not minDis or (minDis > dis and dis > 5)) and groundCheck then 
								minDis = dis 
								n = i 
							end
						end
						if n then 
							actor.x = n
							actor.y = yy
							actorAc.ghost_x = actor.x
							actorAc.ghost_y = actor.y
							actorData.animLoop = 2
							actorData.shoot2Atk = nil
							if actorData.shoot2Cd == 0 then 
								actorData.animLoop = 3
								actorData.shoot2Atk = true
							end
							actorAc.state = "unburrow"
						else
							print("burrow unsuccessful")
						end
					end
				end
				actor.mask = sprites.maskNone
			elseif actorAc.state == "unburrow" then 
				actor.alpha = 1
				actor:set("invincible", math.max(8, actor:get("invincible")))
				actorAc.moveRight = 0
				actorAc.moveLeft = 0
				actor.mask = sprites.maskNone
				if actorData.shoot2Atk then 
					actor.sprite = sprites.warn1
					actor.spriteSpeed = 0.2 
				else 
					actor.sprite = sprites.warn2
					actor.spriteSpeed = 0.2 			
				end
				if math.floor(actor.subimage) == actor.sprite.frames - 1 and actorData.animLoop > 0 then 
					actor.subimage = 1
					actorData.animLoop = actorData.animLoop - 1
				end		
				if math.floor(actor.subimage) == actor.sprite.frames then 
					actor.mask = sprites.mask
					actorData.shoot2frame1 = true 
					actorData.shoot2frame4 = true
					actorAc.state = "shoot2"
					actor.subimage = 1
				end
			elseif actorAc.state == "chase" then 
				if actorAc.target then 
					local trg = Object.findInstance(actorAc.target)
					if trg and trg:isValid() then 
						local mv = lacertianPathfind(actor, trg)
						if mv then
							if mv == "walk" or mv == "observe" then 
								local n = trg.x - actor.x
								local x1, x2 = findLacertianWalk(actor, actor.x, actor.y)
								if not (x1 and x2) then 
									x1 = actor.x 
									x2 = actor.x 
								end
								if actor.x > x1 and actor.x < x2 and math.abs(trg.y - actor.y) < 60 then 
									if actorData.shoot1Cd == 0 and (mv == "walk" and math.abs(n) < 150) or (mv == "observe" and math.abs(n) < 120) then 
										actorData.shoot1Key = true
										actorAc.state = "shoot1"
										actorData.chompCount = 3
										actorData.shoot1Target = trg
									elseif (mv == "observe" and math.abs(n) > 45) or (mv == "walk" and math.abs(n) > 30) then 
										if (mv == "walk" and math.abs(n) > 300) or (mv == "observe" and math.abs(n) > 240) and actorData.burrowCd == 0 then 
											if n ~= 0 then 
												actor.xscale = math.sign(n)
											end
											actorAc.moveRight = 0
											actorAc.moveLeft = 0
											actorAc.state = "burrowAnim"
										else
											if math.sign(n) == 1 then 
												actorAc.moveLeft = 0
												actorAc.moveRight = 1 
											else 
												actorAc.moveRight = 0
												actorAc.moveLeft = 1
											end	
										end
									else 
										if n ~= 0 then 
											actor.xscale = math.sign(n)
										end
										actorAc.moveRight = 0
										actorAc.moveLeft = 0
									end
								else
									if n ~= 0 then 
										actor.xscale = math.sign(n)
									end
									actorAc.moveRight = 0
									actorAc.moveLeft = 0
									if actorData.burrowCd == 0 then 
										actorAc.state = "burrowAnim"
									end
								end
							elseif actorData.burrowCd == 0 then 
								actorAc.state = "burrowAnim"
							else 
								actorAc.state = "idle"
							end
						else
							actorAc.state = "idle"
						end
					else 
						actorAc.state = "idle"
					end
				else 
					actorAc.state = "idle"
				end
			elseif actorAc.state == "shoot1" then
				actorData.shoot1Cd = shoot1Cd
				
				actor.sprite = sprites.shoot1
				actor.spriteSpeed = 0.2		
				
				actorAc.moveRight = 0
				actorAc.moveLeft = 0
			
				if actorData.shoot1Key then 
					actorData.shoot1Key = nil
					actor.subimage = 1
					actorData.shoot1frame5 = true 
					actorData.shoot1frame6 = true
				elseif math.floor(actor.subimage) == actor.sprite.frames then 
					actorData.burrowCd = actorData.burrowCd + 1 * 60
					actorData.shoot2Cd = actorData.shoot2Cd + 2 * 60
					actorAc.state = "idle"
				end

				if math.floor(actor.subimage) == 5 and actorData.shoot1frame5 then 
					actorData.shoot1frame5 = false
					actor:fireExplosion(actor.x + actor.xscale * 50, actor.y - 5, 25/19, 15/4, 1)
					actor.mask = sprites.mask2
					local dir = actorData.xLacertAccel
					if not dir then 
						dir = actor.xscale
					end
					local checkDown = actor:collidesMap(actor.x + math.sign(dir) * actor.mask.width, actor.y + 12)
					if checkDown then 
						actorData.xLacertAccel = actor.xscale * 3
					else
						actorData.xLacertAccel = 0
						actorData.chompCount = 0
					end
					actor.mask = sprites.mask
				end
				if math.floor(actor.subimage) == 6 and actorData.shoot1frame6 and actorData.chompCount > 0 then 
					local trg = actorData.shoot1Target
					if trg and trg:isValid() then 
						local n = trg.x - actor.x 
						actor.xscale = math.sign(n)
						if actor.xscale == 0 then 
							actor.xscale = 1
						end
						local mv = lacertianPathfind(actor, trg)
						local dis = distance(actor.x, actor.y, trg.x, trg.y)
						if mv and ((mv == "walk" and dis < 150) or (mv == "observe" and dis < 120)) then 
							actorData.chompCount = actorData.chompCount - 1
							actorData.shoot1Key = true 
						end
					end
				end
			elseif actorAc.state == "shoot2" then 
				if actorData.shoot2Atk then 
					actor.sprite = sprites.shoot2
					actor.spriteSpeed = 0.2 
				else 
					actor.sprite = sprites.shoot2neutral
					actor.spriteSpeed = 0.2 			
				end				
				if math.floor(actor.subimage) == 1 and actorData.shoot2frame1 then 
					actorData.shoot2frame1 = false
					if actorData.shoot2Atk then 
						actor:fireExplosion(actor.x - actor.xscale * 40, actor.y - 30, (actor.sprite.width / 2 - 20)/19, 30/4, 0.5)
					end
				end
				if math.floor(actor.subimage) == 4 and actorData.shoot2frame4 then 
					actorData.shoot2frame4 = false
					local charge = 3
					if actorData.shoot2Atk then 
						actor:fireExplosion(actor.x + actor.xscale * 50, actor.y - 5, 25/19, 15/4, 1)
						charge = 4
					end
					actor.mask = sprites.mask2
					local checkDown = actor:collidesMap(actor.x + math.sign(actor.xscale) * actor.mask.width, actor.y + 12)
					if checkDown then 
						actorData.xLacertAccel = actor.xscale * charge
					else
						actorData.xLacertAccel = 0
					end
					actor.mask = sprites.mask
				end
				if math.floor(actor.subimage) == actor.sprite.frames then 
					actorAc.state = "idle"
					if actorData.shoot2Atk then 
						actorData.shoot2Cd = shoot2Cd
					end
					actorData.burrowCd = burrowCd
					actorData.shoot1Cd = actorData.shoot1Cd + 2 * 60
				end
			end
		end
	end
end)

-------------------------------------

local card = MonsterCard.new("Lacertian", lacertian)
card.sprite = sprites.spawn
card.sound = sounds.spawn
--card.canBlight = true
card.type = "origin"
card.cost = 750
card.isBoss = true

for _, elite in ipairs(EliteType.findAll("vanilla")) do
    card.eliteTypes:add(elite)
end
if modloader.checkMod("Starstorm") then 
	card.eliteTypes:add(EliteType.find("Poisoning", "Starstorm"))
	card.eliteTypes:add(EliteType.find("Weakening", "Starstorm"))
end 
if not modloader.checkFlag("mn_disable_elites") then 
	card.eliteTypes:add(EliteType.find("bubble", "meridian"))
	card.eliteTypes:add(EliteType.find("sorrow", "meridian"))
end

