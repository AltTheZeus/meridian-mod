local findGround = function(actor, x, y)	
	local checkDown = actor:collidesMap(x, y + 6)
	local checkUp = not actor:collidesMap(x, y - 6)
	return checkDown and checkUp
end

local red = ItemPool.find("rare")

local rainP = ParticleType.find("Rain2")
local rainColor = Color.BLUE

local spawnTheCreature = function(x, y, monster_card, elite_type)
	local actor = Object.find("Spawn"):create(x, y + monster_card.sprite.yorigin - monster_card.sprite.height)
	actor:set("child", monster_card.object.id)
	actor.sprite = monster_card.sprite
	if elite_type and not monster_card.eliteTypes:contains(elite_type) then 
		local elite_timer = math.ceil(60 / (60 * actor.spriteSpeed)) * (actor.sprite.frames + 1)
		misc.director:getData().elites_pass[monster_card] = {elite = elite_type, timer = elite_timer}
		monster_card.eliteTypes:add(elite_type)
	end	
	if elite_type then 
		actor:set("prefix_type", 1)
		actor:set("elite_type", elite_type.id)
		if elite_type == EliteType.find("blessed", "meridian") then 
			actor:getData().invasionBoss = true
		end
	end
	monster_card.sound:play(1, 1)
	for i = 0, 100 do 
		if findGround(actor, actor.x + i, actor.y) then
			actor.x = actor.x + i
			break
		end
		if findGround(actor, actor.x - i, actor.y) then 
			actor.x = actor.x - i 
			break
		end
	end
end

Object.find("Spawn"):addCallback("destroy", function(self)
	local selfData = self:getData()
	
	if selfData.invasionBoss then 
		local child = Object.fromID(self:get("child"))
		local actor = nearestMatchingOp(self, child, "elite_type", "==", EliteType.find("blessed", "meridian").id)
		if actor then 
			actor:getData().invasionBoss = true 
			--misc.director:getData().invasionBoss = actor
			local tele = nearestMatchingOp(actor, obj.Teleporter, "active", "==", 1)
			if tele then 
				if modloader.checkMod("starstorm") then	
					tele:getModData("starstorm").mainBoss = actor
				end
			end
			--print("invasion boss identified")
		end
	end
end)

callback.register("onNPCDeath", function(npc)
	local dirData = misc.director:getData()

	if npc and npc:isValid() and npc:getData().invasionBoss then 
		if dirData.invasionBlesseds > 0 then 
			dirData.blessedLimit = dirData.blessedLimit - dirData.invasionBlesseds
			dirData.invasionBlesseds = 0
		end		
	end
end)

callback.register("onStageEntry", function()
	local dirData = misc.director:getData()
	
	dirData.initInvasion = false -- turn off for release 
	
	dirData.ongoingInvasion = false
	if dirData.invasionBlesseds and dirData.invasionBlesseds > 0 then 
		dirData.blessedLimit = dirData.blessedLimit - dirData.invasionBlesseds
	end
	dirData.invasionBlesseds = 0
	if not dirData.elites_pass then 
		dirData.elites_pass = {}
	end
	dirData.invasionEnemyType = nil
	dirData.invasionWeatherType = nil
	dirData.invasionWeatherTintAlpha = 0
	dirData.postInvasion = false
end)

callback.register("postStep", function()
	local dirData = misc.director:getData()
	
	if dirData.initInvasion then 
		local tps = obj.Teleporter:findAll()
		local init 
		for _, tp in ipairs(tps) do 
			init = tp:get("active") > 0
			if init then break end 
		end
		if init then 
			print("invasion started")
			dirData.initInvasion = false 
			dirData.ongoingInvasion = true 
			dirData.invasionScaling = math.max(math.sqrt(misc.director:get("enemy_buff")) - 1, 1)
			misc.director:set("spawn_boss", 0)
		end
	end

end)

callback.register("onStep", function()
	local dirData = misc.director:getData()
	
	if dirData.elites_pass then
		for mc, et in pairs(dirData.elites_pass) do 
			et.timer = et.timer - 1
			if et.timer <= 0 then 
				mc.eliteTypes:remove(et.elite)
				dirData.elites_pass[mc] = nil
			end
		end
	end
	if dirData.ongoingInvasion then 
		local tps = obj.Teleporter:findAll()
		local tele 
		for _, tp in ipairs(tps) do 
			if tp:get("active") >= 3 then 
				print("invasion finished")
				dirData.ongoingInvasion = false
				dirData.postInvasion = true
				red:roll():create(tp.x, tp.y - 6)
				break
			elseif tp:get("active") > 0 then
				tele = tp
			end
		end
		
		if tele then 
			-- weather type
			if dirData.invasionWeatherType.name == "Lightning Storm" then 
				for i = 1, 3 do 
					rainP:burst("below", camera.x + math.random(0, camera.width), camera.y, 1, rainColor)
				end
			end
			-- enemy invasion boss
			--if dirData.invasionEnemyType.name == "lemurian" then 
				if tele:get("time") == 180 then 
					print("blessed spawned")
					dirData.blessedLimit = dirData.blessedLimit + 1
					dirData.invasionBlesseds = dirData.invasionBlesseds + 1
					spawnTheCreature(tele.x, tele.y, dirData.invasionEnemyType.cards.bossCard.card, EliteType.find("blessed", "meridian"))		
				end
			--end
			-- enemy invasion fodder
			if tele:get("active") == 1 and tele:get("time") >= 240 then 
				for cardName, cardData in pairs(dirData.invasionEnemyType.cards) do 
					if tele:get("time") % math.ceil(cardData.cost / dirData.invasionScaling) == 0 then 
						local elite
						if math.chance(math.max(100 - (cardData.cost / dirData.invasionScaling) / 10, 0)) then 
							elite = table.irandom(dirData.invasionWeatherType.elites)
						end
						spawnTheCreature(tele.x, tele.y, cardData.card, elite)
					end
				end
			end
		end
	end
end)

callback.register("preHUDDraw", function()
	local dirData = misc.director:getData()
	
	if dirData.ongoingInvasion or dirData.postInvasion then 
		local w, h = graphics.getGameResolution()
		if dirData.ongoingInvasion then 
			dirData.invasionWeatherTintAlpha = math.min(0.1, dirData.invasionWeatherTintAlpha + 0.0003)
		else	
			dirData.invasionWeatherTintAlpha = math.max(0, dirData.invasionWeatherTintAlpha - 0.0002)
		end
		graphics.color(dirData.invasionWeatherType.tint)
		--graphics.setBlendMode("additive")
		graphics.alpha(dirData.invasionWeatherTintAlpha)
		graphics.rectangle(0, 0, w, h)		
	end
end)

