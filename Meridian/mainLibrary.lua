--alt's function (mine!!!!)
directionFromInputs = function(player)
	local directionGround
	if player:get("moveLeft") == 1 then 
		directionGround = 180
	elseif player:get("moveRight") == 1 then
		directionGround = 0
	end
	local directionAir
	if player:get("ropeUp") == 1 then 
		directionAir = 90
	elseif player:get("ropeDown") == 1 then
		directionAir = 270
	end
	local direction = player:getFacingDirection()
	if not directionGround then 
		if directionAir then
			direction = directionAir
		end
	elseif not directionAir then 
		direction = directionGround
	else
		direction = 45 * math.sign(180 - directionAir) * math.sign(90 - directionGround) + directionGround
	end
	return direction
end

directionFromVariousInputs = function(player)
	local direction
	if input.getPlayerGamepad(player) then 
		local gamepad = input.getPlayerGamepad(player)
		local xJoy = input.getGamepadAxis("lh", gamepad)
		local yJoy = input.getGamepadAxis("lv", gamepad)
		local dirJoy = posToAngle(0, 0, xJoy, yJoy)
		if math.abs(xJoy) < 0.1 and math.abs(yJoy) < 0.1 then 
			direction = player:getFacingDirection()
		else
			direction = dirJoy
		end
	else
		direction = directionFromInputs(player)
	end
	return direction
end
--alt's function ends


-- Contains
function contains(t, value)
	if t then
		for _, v in pairs(t) do
			if v == value then
				return true
			end
		end
		return false
	else
		return false
	end
end

-- Reverse Table
function reverseTable(tbl)
	local i, j = 1, #tbl

	while i < j do
		tbl[i], tbl[j] = tbl[j], tbl[i]

		i = i + 1
		j = j - 1
	end
end

-- Clone Table
function table.clone(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == "table" then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[table.clone(orig_key)] = table.clone(orig_value)
        end
    else
        copy = orig
    end
    return copy
end

-- Distance
function distance(x1, y1, x2, y2)
	local distance = math.sqrt(math.pow(x2 - x1, 2) + math.pow(y2 - y1, 2))
	return distance
end

-- Point in Line
function pointInLine(x1, y1, x2, y2, ratio)
	local distance = distance(x1, y1, x2, y2)
	local ratio = ratio / distance

	local xx = ratio * x2 + (1 - ratio) * x1
	local yy = ratio * y2 + (1 - ratio) * y1
	return xx, yy
end

-- Clone Sprite
function Sprite.clone(sprite, name, xoff, yoff)
	if not isa(sprite, "Sprite") then typeCheckError("Sprite.clone", 1, "sprite", "Sprite", sprite) end
	if name and not isa(name, "string") then typeCheckError("Sprite.clone", 2, "name", "string", name) end
	if xoff and not isa(xoff, "number") then typeCheckError("Sprite.clone", 3, "xoff", "number", xoff) end
	if yoff and not isa(yoff, "number") then typeCheckError("Sprite.clone", 4, "yoff", "number", yoff) end
	
	local currentSprite = nil
	
	for i = 1, sprite.frames do
		local imageSurface = Surface.new(sprite.width, sprite.height)
		
		graphics.setTarget(imageSurface)
		imageSurface:clear()
		
		local x, y = xoff or sprite.xorigin, yoff or sprite.yorigin
		
		graphics.drawImage{
			image = sprite,
			x = sprite.xorigin,
			y = sprite.yorigin,
			subimage = i
		}

		graphics.resetTarget()
		
		if currentSprite then
			currentSprite:addFrame(imageSurface)
		else
			currentSprite = imageSurface:createSprite(x, y)
		end
		imageSurface:free()
	end
	
	return currentSprite:finalise(name or sprite:getName().."_2")
end

-- yeee nek function!!
function disableDamager(damager)
	damager.x = 0
	damager.y = 0
	damager:set("damage", 0)
	damager:set("damage_fake", 0)
	damager:set("poison_dot", 0)
	damager:set("knockback", 0)
	damager:set("stun", 0)
	damager:set("critical", 0)
	damager:set("knockup", 0)
	damager:set("steam", 0)
	damager:set("oil", 0)
	damager:set("fire", 0)
	damager:set("lifesteal", 0)
	damager:set("explosive_shot", 0)
	damager:set("scythe", 0)
	damager:set("skull_ring", 0)
	damager:set("crowbar_hit", 0)
	damager:set("blaster", 0)
	damager:set("sunder", 0)
	damager:set("wolfblood", 0)
	damager:set("axe", 0)
	damager:set("slow_on_hit", 0)
	damager:set("horn", 0)
	damager:set("spark", 0)
	damager:set("sticky", 0)
	damager:set("nugget", 0)
	damager:set("thallium", 0)
	damager:set("mortar", 0)
	damager:set("taser", 0)
	damager:set("lightning", 0)
	damager:set("missile", 0)
	damager:set("missile_tri", 0)
	damager:set("bleed", 0)
	damager:set("scope", 0)
	damager:set("freeze", 0)
	damager:set("stun_ef", 0)
	damager:set("fear", 0)
	damager:set("taunt", 0)
	damager:set("knockback_glove", 0)
	damager:set("plasma", 0)
	damager:set("gold_gun", 0)
	damager:set("gold", 0)
	damager:set("dynamite_on_hit", 0)
	damager:set("poison", 0)
	damager:set("parent", -4)
end

-- Replace Subimage
function Sprite.replaceSubimage(baseSprite, sprite, subimage, name)
	if not isa(baseSprite, "Sprite") then typeCheckError("Sprite.replaceSubimage", 1, "baseSprite", "Sprite", baseSprite) end
	if not isa(sprite, "Sprite") then typeCheckError("Sprite.replaceSubimage", 2, "sprite", "Sprite", sprite) end
	if subimage and not isa(subimage, "number") then typeCheckError("Sprite.replaceSubimage", 3, "subimage", "number", subimage) end
	if name and not isa(name, "string") then typeCheckError("Sprite.replaceSubimage", 4, "name", "string", name) end
	
	local currentSprite = nil
	
	for i = 1, baseSprite.frames do
		local imageSurface = Surface.new(baseSprite.width, baseSprite.height)
		
		graphics.setTarget(imageSurface)
		imageSurface:clear()
		
		if i == subimage then
			graphics.drawImage{
				image = sprite,
				x = 0 + sprite.xorigin,
				y = 0 + sprite.yorigin,
				subimage = 1
			}
		else
			graphics.drawImage{
				image = baseSprite,
				x = 0 + baseSprite.xorigin,
				y = 0 + baseSprite.yorigin,
				subimage = i
			}
		end
		
		graphics.resetTarget()
		
		if currentSprite then
			currentSprite:addFrame(imageSurface)
		else
			currentSprite = imageSurface:createSprite(sprite.xorigin, sprite.yorigin)
		end
		imageSurface:free()
	end
	
	return currentSprite:finalise(sprite:getName().."_2")
end

function Sprite.addSubimage(baseSprite, sprite)
	if not isa(baseSprite, "Sprite") then typeCheckError("Sprite.addSubimage", 1, "baseSprite", "Sprite", baseSprite) end
	if not isa(sprite, "Sprite") then typeCheckError("Sprite.addSubimage", 2, "sprite", "Sprite", sprite) end
	local currentSprite = nil
	
	for i = 1, baseSprite.frames + 1 do
		local imageSurface = Surface.new(baseSprite.width, baseSprite.height)
		
		graphics.setTarget(imageSurface)
		imageSurface:clear()
		
		if baseSprite.frames + 1 then
			graphics.drawImage{
				image = sprite,
				x = 0 + sprite.xorigin,
				y = 0 + sprite.yorigin,
				subimage = 1
			}
		else
			graphics.drawImage{
				image = baseSprite,
				x = 0 + baseSprite.xorigin,
				y = 0 + baseSprite.yorigin,
				subimage = i
			}
		end
		
		graphics.resetTarget()
		
		if currentSprite then
			currentSprite:addFrame(imageSurface)
		else
			currentSprite = imageSurface:createSprite(sprite.xorigin, sprite.yorigin)
		end
		imageSurface:free()
	end
	
	return currentSprite:finalise(name or sprite:getName().."_2")
end

-- Debug Print
if modloader.checkFlag("ss_debug") then
	global.debug = true
end
function debugPrint(string)
	if global.debug then print(string) end
end

-- Create From ID
function createFromId(id, x, y)
	local obj = obj.Spawn:create(x, y)
	obj:set("child", id)
	obj.sprite = spr.Nothing
end

-- Camera Object
misc.camera = {x = 0, y = 0, height = 0, width = 0}
callback.register("onCameraUpdate", function()
	misc.camera = camera -- stupid - i know
end) 

-- Net ID
function setID(instance)
	if instance:get("m_id") then
		local instanceObject = instance:getObject()
		local id = 0
		for _, i in ipairs(instanceObject:findAll()) do
			local iid = i:get("m_id")
			if iid > id then
				id = iid
			end
		end
		
		local currentID = id + 1
		instance:set("m_id", currentID)
		return currentID
	end
	return false
end

-- PosToAngle
function posToAngle(x1, y1, x2, y2, rad)
	local deltaX = x2 - x1
	local deltaY = y1 - y2
	local result = math.atan2(deltaY, deltaX)
	
	if not rad then
		result = math.deg(result)
	end
	
	return result
end

-- Angledif
function angleDif(current, target)
	return ((((current - target) % 360) + 540) % 360) - 180
end

-- IsaDrone
function isaDrone(actor)
	if actor:get("name") and string.lower(actor:get("name")):find("drone") then -- lol
		return true
	else
		return false
	end
end

-- Color String
function colorString(str, color)
    return "&" .. tostring(color.gml) .. "&" .. str .. "&!&"
end

-- Rainbow String
function rainbowStr(str, sat, mult)
	local m = mult or 1
    local s = ""
	local disp = global.timer
    for i = 1, str:len() do
        s = s .. "&" .. tostring(Colour.fromHSV(((i * 20 * m) + disp * m) % 255, sat, 250).gml) .. "&"
        s = s .. str:sub(i, i)
    end
    return s .. "&!&"
end

-- Corrupt String
function corruptStr(str, power)
	local s = ""
	for i = 1, string.len(str) do
		local nstr = str:sub(i, i)
		if nstr ~= " " and math.chance(power) then
			nstr = string.char(math.random(48, 122))--97, 122))
		end
		s = s .. nstr
	end
	return s
end

-- Outlined Print
function outlinedPrint(str, x, y, bkcol, font, halign, valign)
	local col = graphics.getColor()
	graphics.color(bkcol)
	graphics.print(str, x + 1, y, font, halign, valign)
	graphics.print(str, x, y + 1, font, halign, valign)
	graphics.print(str, x - 1, y, font, halign, valign)
	graphics.print(str, x, y - 1, font, halign, valign)
	graphics.color(col)
	graphics.print(str, x, y, font, halign, valign)
end
function outlinedPrint2(str, x, y, bkcol, font, halign, valign)
	local col = graphics.getColor()
	graphics.color(bkcol)
	graphics.print(str, x + 1, y, font, halign, valign)
	graphics.print(str, x + 1, y + 1, font, halign, valign)
	graphics.print(str, x, y + 1, font, halign, valign)
	graphics.print(str, x - 1, y + 1, font, halign, valign)
	graphics.print(str, x - 1, y, font, halign, valign)
	graphics.print(str, x - 1, y - 1, font, halign, valign)
	graphics.print(str, x, y - 1, font, halign, valign)
	graphics.print(str, x + 1, y - 1, font, halign, valign)
	-- ouch my performance
	graphics.color(col)
	graphics.print(str, x, y, font, halign, valign)
end

-- Debug Nudge (sucks)
local nudgeVals = {}
function debugNudge(value, threshold)
	if not nudgeVals[value] then nudgeVals[value] = value end
	
	if not threshold then threshold = 1 end
	local newVal = nudgeVals[value]
	
	if input.checkKeyboard("9") == input.PRESSED then
		nudgeVals[value] = newVal - threshold
		print(nudgeVals[value])
	elseif input.checkKeyboard("0") == input.PRESSED then
		nudgeVals[value] = newVal + threshold
		print(nudgeVals[value])
	end
	return newVal
end

-- Nearest Instance Matching
function nearestMatchingOp(instance, object, variable1, op, variable2)
	local nearestInstance = nil
	for _, instance2 in ipairs(object:findAll()) do
		if not isa(instance2, "PlayerInstance") or instance2:get("dead") == 0 then
			if op == "~=" and instance2:get(variable1) ~= variable2 or op == "==" and instance2:get(variable1) == variable2 or op == ">" and instance2:get(variable) > variable2 or op == "<" and instance2:get(variable) < variable2 then
				local dis = distance(instance.x, instance.y, instance2.x, instance2.y)
				if not nearestInstance or dis < nearestInstance.dis then
					nearestInstance = {inst = instance2, dis = dis}
				end
			end
		end
	end
	if nearestInstance then
		nearestInstance = nearestInstance.inst
		if nearestInstance:isValid() then
			return nearestInstance
		end
	end
	return nil
end

-- Sync Instance Delete
syncInstanceDelete = net.Packet.new("SSInstDel", function(player, inst)
	if inst then
		local insti = inst:resolve()
		if insti and insti:isValid() then
			insti:delete()
		end
	end
end)
syncInstanceDestroy = net.Packet.new("SSInstDes", function(player, instance)
	local instanceI = instance:resolve()
	if instanceI and instanceI:isValid() then
		instanceI:destroy()
	end
end)
function syncDelete(inst)
	if net.online and net.host then
		syncInstanceDelete:sendAsHost(net.ALL, nil, inst:getNetIdentity())
	end
end
function syncDestroy(inst)
	if net.online and net.host then
		syncInstanceDestroy:sendAsHost(net.ALL, nil, inst:getNetIdentity())
	end
end

-- Sync Actor Kill
syncActorKill = net.Packet.new("SSActorKill", function(player, inst)
	if inst then
		local insti = inst:resolve()
		if insti and insti:isValid() then
			insti:kill()
		end
	end
end)

-- Sync Instance Position
syncInstancePosition = net.Packet.new("SSInstPos", function(player, inst, x, y)
	if inst then
		local insti = inst:resolve()
		if insti and insti:isValid() then
			insti.x = x
			insti.y = y
		end
	end
end)

-- Sync Input Release
local syncInputRelease = net.Packet.new("SSInputRelease", function(sender, player, key)
	local playerI = player:resolve()
	if playerI and playerI:isValid() and key then
		playerI:getData()._keyRelease = key
	end
end)
local hostSyncInputRelease = net.Packet.new("SSInputRelease2", function(sender, player, key)
	local playerI = player:resolve()
	if playerI and playerI:isValid() and key then
		playerI:getData()._keyRelease = key
		syncInputRelease:sendAsHost(net.EXCLUDE, sender, player, key)
	end
end)
function syncControlRelease(player, control)
	if player:control(control) == input.RELEASED then
		if net.online and net.localPlayer == player then
			if net.host then
				syncInputRelease:sendAsHost(net.ALL, nil, player:getNetIdentity(), control)
			else
				hostSyncInputRelease:sendAsClient(player:getNetIdentity(), control)
			end
		end
			
		return true
		
	elseif player:getData()._keyRelease == control then
		player:getData()._keyRelease = nil
		
		return true
	else
	
		return false
	end
end

--a 
function syncControlPress(player, control)
	if player:control(control) == input.PRESSED then
		if net.online and net.localPlayer == player then
			if net.host then
				syncInputRelease:sendAsHost(net.ALL, nil, player:getNetIdentity(), control)
			else
				hostSyncInputRelease:sendAsClient(player:getNetIdentity(), control)
			end
		end
			
		return true
		
	elseif player:getData()._keyRelease == control then
		player:getData()._keyRelease = nil
		
		return true
	else
	
		return false
	end
end

-- Sync Var
syncInstanceVar = net.Packet.new("SSInstanceVar", function(player, instance, var, val)
	if instance and var and val then
		local instanceRes = instance:resolve()
		if instanceRes and instanceRes:isValid() then
			instanceRes:set(var, val)
		end
	end
end)
hostSyncInstanceVar = net.Packet.new("SSInstanceVar2", function(player, instance, var, val)
	if instance and var and val then
		local instanceRes = instance:resolve()
		if instanceRes and instanceRes:isValid() then
			instanceRes:set(var, val)
		end
		syncInstanceVar:sendAsHost(net.EXCLUDE, player, instance, var, val)
	end
end)

-- Sync Data
syncInstanceData = net.Packet.new("SSInstanceData", function(sender, instance, var, val)
	if instance and var and val then
		local instanceRes = instance:resolve()
		if instanceRes and instanceRes:isValid() then
			instanceRes:getData()[var] = val
		end
	end
end)
hostSyncInstanceData = net.Packet.new("SSInstanceData2", function(sender, instance, var, val)
	if instance and var and val then
		syncInstanceData:sendAsHost(net.EXCLUDE, sender, instance, var, val)
		local instanceRes = instance:resolve()
		if instanceRes and instanceRes:isValid() then
			instanceRes:getData()[var] = val
		end
	end
end)

-- Sync Sound
syncSound = net.Packet.new("SSSound", function(player, sound)
	if sound then
		sound:play()
	end
end)

-- Draw Out of Screen
function drawOutOfScreen(object, txt)
	if not onScreen(object) then
		local camera = misc.camera
		local camerax = misc.camera.x + (misc.camera.width / 2)
		local cameray = misc.camera.y + (misc.camera.height / 2)
		
		local w, h = graphics.getGameResolution()
		local sw, sh = Stage.getDimensions()
		local border = 12
		local ox, oy = object.x - camerax + (w * 0.5), object.y - cameray + (h * 0.5)
		local xx = math.clamp(ox, border, w - border)			
		local yy = math.clamp(oy, border, h - border)	
		
		local color = object.blendColor
		if isa(object, "ActorInstance") then
			for _, elitetype in ipairs(allElites) do
				if object:get("elite_type") == elitetype.id then
					color = elitetype.color
				end
			end
		end
		
		local image = object.sprite
		local divide = 3
		if object.mask then
			image = object.mask
			divide = 2.7
		end
		
		graphics.drawImage{
			image = object.sprite,
			angle = object.angle,
			xscale = object.xscale,
			yscale = object.yscale,
			subimage = object.subimage,
			color = color,
			alpha = object.alpha,
			x = xx - image.xorigin + (image.width / 2),
			y = yy + image.yorigin - (image.height / 2),
			alpha = 0.75
		}
		graphics.circle(xx, yy, (image.height + image.width) / divide, true)
		
		if txt then
			local border = 29
			local mid = graphics.textWidth(txt, graphics.FONT_SMALL) / 2
			local xx = math.clamp(ox, border + mid, w - (border + mid))			
			local yy = math.clamp(oy, border, h - border)
			graphics.print(txt, xx, yy, graphics.FONT_SMALL, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTER)
		end
	end
end

-- Typewriter (tctctctctctc)
function typewriter(text1, text2)
	local ttype = obj.Typewriter:create(0, 0)
	local typeAc = ttype:getAccessor()
	typeAc.text1 = text1 or ""
	typeAc.text2 = text2 or ""
	return ttype
end

-- Check Progression Limit
function getMaxStageProgression()
	local progressionLimit = 0
	while Stage.getProgression(progressionLimit + 1) ~= nil do
		progressionLimit = progressionLimit + 1
	end
	return progressionLimit
end

-- On-screen Function
function onScreen(instance)
	if instance and instance:isValid() then
		local add = 20
		if instance.x > camera.x - add and instance.x < camera.x + camera.width + add and
		instance.y > camera.y - add and instance.y < camera.y + camera.height + add then
			return true
		end
	end
end
function onScreenPos(x, y)
	local add = 20
	if x > camera.x - add and x < camera.x + camera.width + add and
	y > camera.y - add and y < camera.y + camera.height + add then
		return true
	end
end

-- Draw Custom Bar Function
function customBar(x1, y1, x2, y2, current, maximum, horizontal, color1, color2)
	graphics.color(Color.DARK_GRAY)
	graphics.rectangle(x1, y1 - 1, x2, y2 + 1, true)
	graphics.color(Color.BLACK)
	graphics.rectangle(x1 + 1, y1, x2 - 1, y2, false)
	if color1 ~= nil then
		if color2 ~= nil then
			graphics.color(Color.mix(color1, color2, (current / maximum)))
		else
			graphics.color(Color.mix(color1, color1, (current / maximum)))
		end
	else
		graphics.color(Color.mix(Color.RED, Color.YELLOW, (current / maximum)))
	end
	if horizontal then
		local barVal = (x2 - x1) * math.min(current / maximum, 1)
		graphics.rectangle(x1 + 1, y1, x1 + barVal - 1, y2, false)
	else
		local barVal = (y2 - y1) * math.min(current / maximum, 1)
		graphics.rectangle(x1 + 1, y2 - barVal, x2 - 1, y2, false)
	end
end

-- Draw Rod Lightning
function drawRodLightning(x1, y1, x2, y2, steps, range, color)
	local dis = distance(x1, y1, x2, y2)
	local useSteps
	if steps then
		useSteps = math.min(math.max(math.ceil(dis / 40), 2), steps)
	else
		useSteps = math.clamp(math.ceil(dis / 40), 2, 20)
	end
	--local useSteps = math.min(math.max(math.ceil(dis / 40), 2), steps) or math.clamp(math.ceil(dis / 40), 2, 20)
	local useRange = range or 6
	local useColor = color or Color.fromHex(0x8BB8C1)
	
	local stepSize = dis / useSteps
	
	local stepTable = {}
	
	local hStep = useSteps / 2
	
	for i = 1, (useSteps - 1) do
		local midCalc = hStep - math.abs(i - hStep)
		local newRange = useRange + midCalc * 0.5
		local randx = math.random(-newRange, newRange)
		local randy = math.random(-newRange, newRange)
		local newx, newy = pointInLine(x1, y1, x2, y2, stepSize * i)
		stepTable[i] = {x = newx + randx, y = newy + randy}
	end
	
	if global.quality == 3 then
		graphics.alpha(0.4)
		graphics.color(useColor)
		for i = 1, (useSteps) do
			if i == 1 then
				graphics.line(x1, y1, stepTable[i].x, stepTable[i].y, 4)
			elseif i == useSteps then
				graphics.line(stepTable[i - 1].x, stepTable[i - 1].y, x2, y2, 4)
			else
				graphics.line(stepTable[i - 1].x, stepTable[i - 1].y, stepTable[i].x, stepTable[i].y, 4)
			end
		end
	end
	
	graphics.alpha(0.8)
	graphics.color(Color.WHITE)
	for i = 1, (useSteps) do
		if i == 1 then
			graphics.line(x1, y1, stepTable[i].x, stepTable[i].y, 1)
		elseif i == useSteps then
			graphics.line(stepTable[i - 1].x, stepTable[i - 1].y, x2, y2, 1)
		else
			graphics.line(stepTable[i - 1].x, stepTable[i - 1].y, stepTable[i].x, stepTable[i].y, 1)
		end
	end
end

-- Type Check Error
-- Totally not stolen from RoRML!
function typeCheckError(fname, argn, aname, expected, got)
	error(string.format("bad argument #%i ('%s') to '%s' (%s expected, got %s)", argn, aname, fname, expected, type(got)), 2)
end

-- Create Achievement Popup
function createAchievementPopup(achievement)
	obj.Achievement:create(0, 0):set("text1", achievement.description).sprite = achievement.sprite
end

-- Damage Font 2 Electric Boogaloo
--FONT_DAMAGE2 = graphics.fontFromSprite(Sprite.load("DamageFont", "Misc/Menus/damageFont.png", 81, 0, 1), [[ABCDEFGHIJKLMNOPQRSTUVWXYZÅÄÖ0123456789/!”#¤%&()=?+-§@£$€{[]}\’*.,_<>^~¨ÜÏËŸ¿¡:;|]], 0, false)

function getAlivePlayer()
	for _, p in ipairs(misc.players) do
		if p:get("dead") == 0 then
			return p
		end
	end
end

function getTrueItems(actor)
	local items = actor:getData().items
	if items then
		local trueItems = {}
		for _, item in ipairs(items) do
			if not itp.curse:contains(item.item) then
				table.insert(trueItems, item)
			end
		end
		return(trueItems)
	end
end

-- Dumb solution to a rorml bug we (saturnyoshi and me (myself (the person who wrote this (but who am i?!?!!?! (AAAAAAAAAAAA))))) just couldnt figure out and its super dumb and i really hate it and i want to cry because its really bad and i am sad and i wish it wasnt a thing but it is a thing so i guess i have depression now. wait, thats an exaggeration im sorry please move on but give me a hug whenever possible please please
-- shut up
onNPCDeath = {}
callback.register("onNPCDeath", function(actor)
	if actor and actor:isValid() then
	local object = actor:getObject()
	for i, func in pairs(onNPCDeath) do
		pcall(func, actor, object)
	end
	end
end)

-- Synced Object Spawn (with function!)
local funcs = {}
local syncInst = net.Packet.new("SSInstSpawn", function(player, object, x, y, instid, funcid, other)
	local inst = object:create(x, y)
	if instid ~= false then
		inst:set("m_id", instid)
	end
	
	local arg
	if other then 
		if isa(other, "NetInstance") then
			arg = other:resolve()
		else
			arg = other
		end
	end
	if funcid then
		if funcs[funcid] then
			funcs[funcid](inst, arg)
		else
			error("Invalid ID: "..funcid, 2)
		end
	end
end)
function setFunc(func)
	table.insert(funcs, func)
	return #funcs
end
function createSynced(object, x, y, id, otherv)
	if net.host then
		local inst = object:create(x, y):set("sync", 0)
		if id then
			funcs[id](inst, otherv)
		end
		if net.online then
			local instid = setID(inst)
			local other = otherv
			if otherv and isa(otherv, "Instance") then
				if otherv.getNetIdentity then
					other = otherv:getNetIdentity()
				else
					other = nil
				end
			end
			syncInst:sendAsHost(net.ALL, nil, object, x, y, instid, id, other)
		end
	end
end

-- Buff syncing
local syncBuff = net.Packet.new("SSBuff", function(player, actor, buffname, duration)
	local inst = actor:resolve()
	if inst and inst:isValid() then
		local buff = Buff.find(buffname)
		if buff then
			inst:applyBuff(buff, duration)
		end
	end
end)
local hostSyncBuff = net.Packet.new("SSBuff2", function(player, actor, buffname, duration)
	local inst = actor:resolve()
	if inst and inst:isValid() then
		local buff = Buff.find(buffname)
		if buff then
			inst:applyBuff(buff, duration)
		end
		syncBuff:sendAsHost(net.EXCLUDE, player, actor, buffname, duration)
	end
end)
function applySyncedBuff(actor, buff, duration, onlyHost)
	if net.host then
		if net.online then
			syncBuff:sendAsHost(net.ALL, nil, actor:getNetIdentity(), buff:getName(), duration)
		end
		actor:applyBuff(buff, duration)
	elseif not onlyHost then
		hostSyncBuff:sendAsClient(actor:getNetIdentity(), buff:getName(), duration)
		actor:applyBuff(buff, duration)
	end
end

-- Get Rule Function :)
function getRule(category, index)
	local activeRuleset = global.activeRules
	if activeRuleset then
		if activeRuleset[category][index] ~= nil then
			return activeRuleset[category][index]
		else
			return global.rules[category].content[index].default
		end
	end
end
--[[function getRule(category, index)
	local activeRuleset = global.activeRuleset
	
	if global.rulesets and activeRuleset and global.rulesets[activeRuleset].rules then
		local isSub = global.rules[category].content[index].isSub
		local parentRule = nil
		if isSub then
			parentRule = global.rulesets[activeRuleset].rules[category][isSub]
		end
		if global.rulesets[activeRuleset].rules[category][index] ~= nil then
			if parentRule == nil or parentRule ~= false then
				return global.rulesets[activeRuleset].rules[category][index]
			else
				if type(global.rulesets[activeRuleset].rules[category][index]) == "boolean" then
					return false
				else
					return global.rules[category].content[index].default
				end
			end
		else
			if parentRule == nil or parentRule ~= false then
				return global.rules[category].content[index].default
			else
				if type(global.rulesets[activeRuleset].rules[category][index]) == "boolean" then
					return false
				else
					return global.rules[category].content[index].default
				end
			end
		end
	end
end]] -- cringe!

-- Global PVP Versus Stuff
global.pvp = false
global.versus = false
global.teams = 1
global.pvpKills = {}
callback.register("postSelection", function()
	global.pvp = getRule(2, 15)
	global.versus = getRule(2, 16)
end)

-- Player Colors
playerColors = {
	Color.fromHex(0xCF6666),Color.fromHex(0x7C88B8),Color.fromHex(0xEFD27B),
	Color.fromHex(0x7EB686),Color.fromHex(0xC1803E),Color.fromHex(0x7C96C5),
	Color.fromHex(0xCD7BD7),Color.fromHex(0xCF6666),Color.fromHex(0x8EAEB0),
	Color.fromHex(0x8D73A6),Color.fromHex(0xC1B13E),Color.fromHex(0x4E506F),
	Color.fromHex(0xC9F24D),Color.fromHex(0xABE2F8),Color.WHITE
}

playerTeamColors = {
	Color.fromHex(0xCF6666),Color.fromHex(0x7C88B8),Color.fromHex(0xEFD27B),
	Color.fromHex(0x7EB686),Color.fromHex(0xC1803E),Color.fromHex(0xA37BC4),
	Color.fromHex(0x5ED4CC),Color.fromHex(0xE08FD0),Color.fromHex(0x8A9330),
	Color.fromHex(0x826D82),Color.fromHex(0xB7A73C),Color.fromHex(0xC9F24D),
	Color.fromHex(0xB64CEF),Color.fromHex(0x00F7A9),Color.WHITE
} -- cute tables huh

-- Player Color Getter
function playerColor(player, i)
	if player and player:isValid() then
		local index = nil
		if net.online then
			index = player:get("m_id")
		else
			index = i
		end
		
		if global.versus and player:getData().versusTeam then
			index = player:getData().versusTeam
		end
		
		index = math.clamp(index, 1, 15)
		
		local color = playerColors[index]
		if global.versus and getRule(2, 17) ~= "Free for All" then
			color = playerTeamColors[index]
		end
		
		return color
	end
end

-- Bullet Tracing
local objBulletTrail = Object.new("BulletTrail")
objBulletTrail.depth = -9
objBulletTrail:addCallback("draw", function(self)
	local selfData = self:getData()
	if selfData.origin and selfData.target then
		if not selfData.timer then
			selfData.timer = 20
		else
			if selfData.timer <= 0 then
				self:destroy()
			else
				selfData.timer = selfData.timer - 1
				if selfData.anim then
					selfData.origin.y = selfData.origin.y - 0.05
					selfData.target.y = selfData.target.y - 0.14
				end
			end
		end
		
		graphics.color(selfData.color or Color.WHITE)
		graphics.alpha(selfData.timer / 100)
		graphics.line(selfData.origin.x, selfData.origin.y, selfData.target.x, selfData.target.y, selfData.size or 1)
	else
		self:destroy()
	end
end)
table.insert(call.onImpact, function(damager, x, y)
	local damagerData = damager:getData()
	
	if damagerData.bulletTrail then
		if not damagerData.t_pierce then
			if damagerData.bulletTrail == 1 then
				local target = {x = x, y = y}
				local trail = objBulletTrail:create(damager.x, damager.y):getData()
				trail.color = damagerData.t_color
				trail.size = damagerData.t_size
				trail.origin = damagerData.originPos
				trail.target = target
				trail.timer = damagerData.t_duration
				trail.anim = damagerData.t_anim
				
				damagerData.t_collision = true
			else
				local origin = damagerData.originPos
				local dis = distance(origin.x, origin.y, x, y)
				local amount = dis / damagerData.t_amount --math.ceil(dis % 30)
				for i = 1, amount do
					local ratio = (i * dis) / amount
					local xx, yy = pointInLine(origin.x, origin.y, x, y, ratio)
					damagerData.t_particle:burst("above", xx, yy, 1, damagerData.t_color)
				end
				damagerData.t_collision = true
			end
		end
	end
end)
obj.Bullet:addCallback("create", function(damager)
	damager:getData().originPos = {x = damager.x, y = damager.y - 4}
end)
obj.Explosion:addCallback("create", function(damager)
	damager:getData().originPos = {x = damager.x, y = damager.y - 4}
end)
obj.Bullet:addCallback("destroy", function(damager)
	local damagerData = damager:getData()
	
	if damagerData.bulletTrail then
		if not damagerData.t_collision or damagerData.t_pierce then
			if damagerData.bulletTrail == 1 then
				local distance = damager:get("bullet_speed")

				local target = {x = damager.x, y = damager.y}
				
				local origin = damagerData.originPos
				
				if damagerData.t_pierce then
					local i = 0
					local xx, yy = origin.x, origin.y
					
					while not Stage.collidesPoint(xx, yy) and i < distance do
						i = math.approach(i, distance, 6)
						xx, yy = pointInLine(origin.x, origin.y, target.x, target.y, i)
					end
					target.x, target.y = xx, yy
				end
				
				local trail = objBulletTrail:create(damager.x, damager.y):getData()
				trail.color = damagerData.t_color
				trail.size = damagerData.t_size
				trail.origin = origin
				trail.target = target
				trail.timer = damagerData.t_duration
				trail.anim = damagerData.t_anim
			else
				local distance = damager:get("bullet_speed")

				local target = {x = damager.x, y = damager.y}
				
				local origin = damagerData.originPos
				
				if damagerData.t_pierce then
					local i = 0
					local xx, yy = origin.x, origin.y
					
					while not Stage.collidesPoint(xx, yy) and i < distance do
						i = math.approach(i, distance, 6)
						xx, yy = pointInLine(origin.x, origin.y, target.x, target.y, i)
					end
					target.x, target.y = xx, yy
				end
				
				local amount = distance / damagerData.t_amount --math.ceil(dis % 30)
				for i = 1, amount do
					local ratio = (i * distance) / amount
					local xx, yy = pointInLine(origin.x, origin.y, target.x, target.y, ratio)
					damagerData.t_particle:burst("above", xx, yy, 1, damagerData.t_color)
				end
			end
		end
	end
end)
function addBulletTrailLine(damager, color, size, duration, pierce, animate)
	if damager then
		local damagerData = damager:getData()
		damagerData.bulletTrail = 1
		damagerData.t_color = color
		damagerData.t_size = size
		damagerData.t_duration = duration
		damagerData.t_pierce = pierce
		damagerData.t_anim = animate
	end
end
function addBulletTrailParticle(damager, particle, color, amount, pierce)
	if damager then
		local damagerData = damager:getData()
		damagerData.bulletTrail = 2
		damagerData.t_particle = particle
		damagerData.t_color = color
		damagerData.t_amount = amount
		damagerData.t_pierce = pierce
	end
end
addBulletTrail = addBulletTrailLine
export("addBulletTrailLine")
export("addBulletTrail")

-- Custom NPC Stuff
-- I should rewrite this :(
NPC = {}
export("NPC")
NPC.skills = {}
function NPC.setSkill(object, index, range, cooldown, sprite, speed, startFunc, updateFunc)
	local key = nil
	if index == 1 then key = "z"
	elseif index == 2 then key = "x"
	elseif index == 3 then key = "c"
	else key = "v" end
	
	if not NPC.skills[object] then
		NPC.skills[object] = {}
	end
	if not NPC.skills[object][index] then
		NPC.skills[object][index] = {key = key, range = range, cooldown = cooldown, sprite = sprite, speed = speed, start = startFunc, update = updateFunc}
	end
end
table.insert(call.postStep, function()
	for object, _ in pairs(NPC.skills) do
		for _, npcInstance in ipairs(object:findAll()) do
			if not npcInstance:getData()._checked then
				local obj = npcInstance:getObject()
				
				if NPC.skills[obj] then
					for k, i in pairs(NPC.skills[obj]) do
						npcInstance:set(i.key.."_range", i.range)
						if i.sprite then
							npcInstance:setAnimation("shoot"..k, i.sprite)
						end
					end
				end
				
				npcInstance:getData().attackFrameLast = 0
				npcInstance:getData()._checked = true
			end
		end
	end
end)

-- Roll ItemPool
function rollItemPool(rareChance, useChance, uncommonChance, commonChance)
	local item = nil
	if math.chance(rareChance) then
		item = itp.rare
	elseif math.chance(useChance) then
		item = itp.use
	elseif math.chance(uncommonChance) then
		item = itp.uncommon
	elseif math.chance(commonChance) then
		item = itp.common
	end  
	
	return item
end

-- Spawn Item Function
local syncItemSpawn = net.Packet.new("SSItemSpawn", function(player, item, x, y)
	if item then
		spawnedItem = item:create(x, y)
	end
end)
function spawnItem(rareChance, useChance, uncommonChance, commonChance, x, y)
	local item = nil
	if math.chance(rareChance) then
		item = itp.rare
	elseif math.chance(useChance) then
		item = itp.use
	elseif math.chance(uncommonChance) then
		item = itp.uncommon
	elseif math.chance(commonChance) then
		item = itp.common
	end  
	
	if ar.Command.active and item ~= nil then
		item = item:getCrate()
	else
		item = item:roll():getObject()
	end
	
	local spawnedItem = nil
	if net.online then 
		if net.host then
			spawnedItem = item:create(x, y)
		else
			syncItemSpawn:sendAsClient(item, x, y)
		end
	else
		spawnedItem = item:create(x, y)
	end
	return spawnedItem
end

-- Fake Item Function
syncFakeItem2 = net.Packet.new("SSFakeItem2", function(player, item, owner, text1, text2)
	local ownerID = owner:resolve()
	if ownerID then ownerID = ownerID.id end
	
	if item then
		local itemi = item:resolve()
		if itemi and itemi:isValid() then
			itemi:set("used", 1)
			itemi:set("owner", ownerID)
			itemi:set("sound_played", 1)
			itemi:set("text1", text1)
			itemi:set("text2", text2)
		end
	end
end)
it.DummyItem = Item.new("Dummy Item")
it.DummyItem.pickupText = "" 
it.DummyItem.sprite = spr.Nothing
local objItem = it.DummyItem:getObject()
function createFakeItem(x, y, ownerID, text1, text2)
	local display = objItem:create(x, y)
	if display:isValid() then
		display:set("used", 1)
		display:set("owner", ownerID)
		display:set("sound_played", 1)
		display:set("text1", text1)
		display:set("text2", text2)
		if net.online and net.host then
			syncFakeItem2:sendAsHost(net.ALL, nil, display:getNetIdentity(), Object.findInstance(ownerID):getNetIdentity(), text1, text2)
		end
	end
end
syncFakeItem = net.Packet.new("SSFakeItem", function(player, x, y, player, text1, text2)
	if player:resolve() then
		createFakeItem(x, y, player:resolve().id, text1, text2)
	end
end)

-- CAMERA CUTSCENES
local onCutscene = false
local cutscenePosition = nil
local cutsceneSpeed = 0
local lastPosition = nil
local newCamPos = nil
local lastPosTimer = 0
function cameraCutscene(x, y, speed)
	local rwidth, rheight = Stage.getDimensions()
	onCutscene = true
	local xx = math.clamp(x - (misc.camera.width / 2), 0, rwidth - misc.camera.width)
	local yy = math.clamp(y - (misc.camera.height / 2), 0, rheight - misc.camera.height)
	cutscenePosition = {x = xx, y = yy}
	if speed then
		cutsceneSpeed = speed
	else
		cutsceneSpeed = 1
	end
	lastPosition = {x = misc.camera.x, y = misc.camera.y}
	newCamPos = {x = misc.camera.x, y = misc.camera.y}
end
function resetCameraCutscene()
	onCutscene = false
	lastPosTimer = 500
	cutscenePosition = nil
	newCamPos = {x = misc.camera.x, y = misc.camera.y}
end
callback.register("onCameraUpdate", function()
	if onCutscene then
		local dify = newCamPos.y - cutscenePosition.y
		local difx = newCamPos.x - cutscenePosition.x
		
		newCamPos.y = math.approach(newCamPos.y, cutscenePosition.y, dify * (0.1 * cutsceneSpeed))
		newCamPos.x = math.approach(newCamPos.x, cutscenePosition.x, difx * (0.1 * cutsceneSpeed))
		
		camera.y = newCamPos.y
		camera.x = newCamPos.x
		
	elseif lastPosition then
		local sw, sh = Stage.getDimensions()
		local xx = math.clamp(misc.players[1].x - (misc.camera.width / 2), 0, sw - misc.camera.width)
		local yy = math.clamp(misc.players[1].y - (misc.camera.height / 2), 0, sh - misc.camera.height)
		if math.round(newCamPos.x * 10) / 10 ~= math.round(xx * 10) / 10 and math.round(newCamPos.y * 10) / 10 ~= math.round(yy * 100) / 100 then
			if lastPosTimer > 0 then
				lastPosTimer = lastPosTimer - 1
				local dify = newCamPos.y - yy
				local difx = newCamPos.x - xx
				
				newCamPos.y = math.approach(newCamPos.y, yy, (dify * (0.1 * cutsceneSpeed)))
				newCamPos.x = math.approach(newCamPos.x, xx, (difx * (0.1 * cutsceneSpeed)))
				
				camera.y = newCamPos.y
				camera.x = newCamPos.x
			else
				lastPosition = nil
			end
		else
			lastPosition = nil
		end
	end
end)
callback.register("onGameEnd", function()
	onCutscene = false
	cutscenePosition = nil
	lastPosition = nil
end)

-- Taming?
function tameSetElite(actor)
	local actorAc = actor:getAccessor()
	if actor:getAnimation("palette") then
		actor:set("prefix_type", 1)
		actor:set("elite_type", elt.Tamed.id)
	else
		actor.blendColor = elt.Tamed.color
	end
end
function makeTamed(actor, parent) -- this function sucks bad
	local actorAc = actor:getAccessor()
	parent:getData().tameChild_elite = actor:getElite()
	actorAc.tameParent = parent.id
	if not actorAc.parent then
		actorAc.parent = parent.id
	end
	actorAc.persistent = 1
	actorAc.show_boss_health = 0
	actorAc.tamed = 1
	actorAc.team = parent:get("team")
	actorAc.name = "Friendly "..actorAc.name
	actorAc.maxhp = actorAc.maxhp * 1.25
	actorAc.hp = actorAc.maxhp
	if actorAc.damage then
		actorAc.damage = actorAc.damage * 1.25
	end
	actorAc.knockback_cap = actorAc.maxhp * 0.75
	actor:getData().still_timer = 0
	actor:getData().jumpTimer = 0
	parent:getData().tameChild = actor
	parent:getData().tameObject = actor:getObject()
	actor:getData().parent = parent
	
	if misc.hud:get("boss_id") == actor.id then
		misc.hud:set("boss_id", -4)
	end
	
	for _, itemData in ipairs(parent:getData().items) do
		NPCItems.giveItem(actor, itemData.item, itemData.count)
	end
	copyParentVariables(actor, parent)
	
	local nearenemy = pobj.enemies:findMatchingOp("team", "~=", actorAc.team)
	if nearenemy and isa(nearenemy, "ActorInstance") then
		actorAc.target = nearenemy
	end
	if modloader.checkFlag("ss_disable_elites") then
		actor.blendColor = Color.LIGHT_GREEN
	else
		tameSetElite(actor)
	end
	
	local providenceObjects = {[obj.Boss1] = true, [obj.Boss3] = true}
	if providenceObjects[actor:getObject()] then
		friendProvidence(actor)
	end
	
	if actor:getObject() == obj.GiantJelly then
		for _, leg in ipairs(obj.JellyLegs:findMatching("parent", actor.id)) do
			leg:set("persistent", 1)
			for _, leg2 in ipairs(obj.JellyLegs:findMatching("parent", leg.id)) do
				leg2:set("persistent", 1)
				for _, leg3 in ipairs(obj.JellyLegs:findMatching("parent", leg2.id)) do
					leg3:set("persistent", 1)
				end
			end
		end
	elseif actor:getObject() == obj.JellyG2 then
		for _, leg in ipairs(obj.JellyLegs:findMatching("parent", actor.id)) do
			leg:set("persistent", 1)
			for _, leg2 in ipairs(obj.JellyLegs:findMatching("parent", leg.id)) do
				leg2:set("persistent", 1)
			end
		end
	end
end

-- Temporary Shield Manager
table.insert(call.onPlayerStep, function(player)
	local playerData = player:getData()
	if playerData.tempShield then
		local playerAc = player:getAccessor()
		if not playerData._lastTempShield then playerData._lastTempShield = 0 end
		if playerData.tempShield ~= playerData._lastTempShield then
			local isFull = playerAc.shield >= playerAc.maxshield
			
			local dif = playerData.tempShield - playerData._lastTempShield
			playerAc.maxshield = playerAc.maxshield + dif
			if playerAc.shield > playerAc.maxshield or isFull then
				playerAc.shield = playerAc.maxshield
				playerData.lastShield = math.max(playerAc.shield, 0)
			end
			playerData._lastTempShield = playerData.tempShield
		end
		if playerData.tempShield > 0 then
			if misc.director:getAlarm(0) == 30 then
				playerData.tempShield = math.approach(playerData.tempShield, 0, 1)
			end
			local ls = playerData.lastShield
			if ls and playerAc.shield < ls then
				local dif = math.min(playerData.lastShield - playerAc.shield, playerData.tempShield)
				--print("dif", dif)
				playerAc.maxshield = playerAc.maxshield - dif
				playerData.tempShield = playerData.tempShield - dif
				playerData._lastTempShield = playerData.tempShield
			end
		end
		--[[if playerAc.shield < playerData.tempShield then
			playerAc.maxshield = playerAc.maxshield - playerData.tempShield
			playerData.tempShield = 0
			playerData._lastTempShield = 0
		end]]
		
		--print(playerAc.shield, playerData.lastShield)
		playerData.lastShield = playerAc.shield
	end
end)

-- xAcceleration
callback.register("onActorStep", function(actor)
	local actorData = actor:getData()
	if actorData.xAccel and not actorData.positionOverride then
		if actorData.xAccel ~= 0 then
			actorData.xAccel = math.approach(actorData.xAccel, 0, 0.1)
			local newx = actor.x + actorData.xAccel
			if actor:collidesMap(newx, actor.y) then
				if actor:collidesMap(newx, actor.y - 1) then
					actorData.xAccel = nil
				end
			elseif actor:get("activity") == 30 then
				actorData.xAccel = nil
			else
				actor.x = newx
			end
		else
			actorData.xAccel = nil
		end
	end
end)

-- Vestige Scaling
getVestigeScaling = function(setting)
	if setting == "items" then
		return math.max(((Difficulty.getScaling() * math.max(Difficulty.getScaling() * 0.08, 1)) - 0.6) * 2, 1)
	else
		return (1 + (0.5 * (#misc.players - 1))) * (Difficulty.getScaling("hp") * math.min(Difficulty.getScaling() * 0.2, 1))
	end
end

-- Item Rarity String (for sorting)
function getRarityString(item)
	local c = item.color
	if isa(c, "Color") then
		return "z"..tostring(c.gml)
	else
		if c == "w" then c = "a"..c
		elseif c == "g" then c = "b"..c
		elseif c == "r" then c = "c"..c
		elseif c == "or" then c = "d"..c
		elseif c == "y" then c = "e"..c
		elseif c == "p" then c = "f"..c 
		elseif c == "b" then c = "g"..c 
		elseif c == "bl" then c = "h"..c 
		elseif c == "lt" then c = "i"..c
		elseif c == "dk" then c = "j"..c end
		return c
	end
end -- weird, I know