local item = Item("Discarded Homunculus")

item.pickupText = "Collate a damaging hunk of flesh near the teleporter." 

item.sprite = Sprite.load("Items/homunculus.png", 1, 15, 15)
item:setTier("rare")

local fleshSound1 = Sound.load("Items/fleshmono")
local fleshSound2 = Sound.load("Items/fleshboommono")

local miniFlesh = Object.new("Flesh Chunk")
miniFlesh.sprite = Sprite.load("Items/homunculusEf_1.png", 4, 10, 11)

miniFlesh:addCallback("create", function(self)
	local sD = self:getData()
	self.subimage = math.random(1, 4)
	self.spriteSpeed = 0
end)

local bit = ParticleType.new("Flesh Bit")
local bitSpr = Sprite.load("Items/homunculusEf_3.png", 5, 3, 3)
bit:sprite(bitSpr, false, false, true)
bit:size(0.9, 1.3, 0, 0)
bit:angle(0, 360, 1, 0, true)
bit:speed(2.5, 3.2, 0, 0)
bit:direction(65, 115, 0, 0)
bit:gravity(0.26, 270)
bit:life(60, 60)

local bigFlesh = Object.new("Flesh Amalgamate")
bigFlesh.sprite = Sprite.load("Items/homunculusEf_2.png", 1, 31, 28)
bigFlesh.depth = 20
fleshActive = Sprite.load("Items/homunculusEf_2_2.png", 5, 31, 32)

bigFlesh:addCallback("create", function(self)
	local sD = self:getData()
	sD.finished = true
end)

bigFlesh:addCallback("step", function(self)
	local sD = self:getData()
	if self.sprite == fleshActive and self.subimage >= 5 then
		sD.finished = true
	elseif self.sprite == fleshActive and self.subimage <= 2 and sD.finished == true then
		self.spriteSpeed = 0
		self.sprite = bigFlesh.sprite
		sD.finished = false
	end
end)

registercallback("onNPCDeathProc", function(npc, player)
	local npcX = npc.x
	local npcY = npc.y
	local bf
	if not bigFlesh:find(1) then return else bf = bigFlesh:find(1) end
	local sD = npc:getData()
	local tp = Object.find("Teleporter"):find(1)
	if tp:get("active") == 1 then
		local xVar = (math.sign(npcX - bf.x) * (npcX - bf.x))
		local yVar = (math.sign(npcY - bf.y - 10) * (npcY - bf.y - 10))
		local c2 = (xVar * xVar) + (yVar * yVar)
		c = c2 ^ 0.5
		if c <= 100 then
			local fCount = 0
			local fMult = 1
			for _, i in ipairs(misc.players) do
				fCount = fCount + player:countItem(item)
			end
			if fCount > 1 then
				for i = 1, fCount - 1 do
					fMult = fMult * 1.6
				end
			end
			local damageAvg = 0
			for _, i in ipairs(misc.players) do
				damageAvg = damageAvg + i:get("damage")
			end
			damageAvg = damageAvg / #misc.players
			misc.fireExplosion(npcX, npcY, 3, 6, damageAvg * 8 * fMult, "player") --, [explosionSprite], [hitSprite], [properties])
			fleshSound2:play(math.random(0.9, 1.1), 1)
			bf.sprite = fleshActive
			bf.spriteSpeed = 0.15
			for i = 1, math.random(1, 3) do
				bit:burst("middle", npcX, npcY - 6, math.random(3, 6))
--				blob.blendColor = Color.fromRGB(math.random(111, 186), math.random(23, 49), math.random(21, 85))
			end
--			print(damageAvg * 8 * fMult)
		end
	end
end)

local fleshActivationPacket
fleshActivationPacket = net.Packet("Flesh Bit Activation Packet", function(sender, x, y)
	miniFlesh:findNearest(x, y):destroy()
	fleshSound1:play(math.random(0.7, 1.1), 1.2)
	
	if net.host then
		local dD = misc.director:getData()
		dD.flesh = dD.flesh + 1
		fleshActivationPacket:sendAsHost(net.EXCLUDE, sender, x, y)
	end
end)

miniFlesh:addCallback("draw", function(self)
	local sD = self:getData()
	local dD = misc.director:getData()
	for _, i in ipairs(misc.players) do
		if self:collidesWith(i, self.x, self.y) then
			graphics.alpha(1)
			local offset = graphics.textWidth("Press '" .. input.getControlString("enter", i) .. "' to collect flesh.", graphics.FONT_DEFAULT) / 2
			graphics.printColor("&w&Press &y&'" .. input.getControlString("enter", i) .. "'&w& to  collect flesh.&!&", self.x - offset + 5, self.y - 45, graphics.FONT_DEFAULT)
			if input.checkControl("enter", i) == 2 or input.checkControl("enter", i) == 3 then
				self:destroy()
				fleshSound1:play(math.random(0.7, 1.1), 1.2)
				
				if net.host then
					dD.flesh = dD.flesh + 1
					fleshActivationPacket:sendAsHost(net.ALL, nil, self.x, self.y)
				else
					fleshActivationPacket:sendAsClient(self.x, self.y)
				end
			end
		end
	end
end)

local fleshCreationPacket
fleshCreationPacket = net.Packet("Flesh Creation Packet", function(sender, object, x, y)
	object:create(x, y) --It's as simunculuple as that
end)

local spawnFlesh = function()
	local fCount = 0
	for _, i in ipairs(misc.players) do
		if i:countItem(item) > 0 then fCount = fCount + 1 end
	end
	if fCount > 0 then
		if not (Object.find("Teleporter"):find(1) or Object.find("Command"):find(1)) then return end
		for i = 1, 4 do
			local ground = table.random(Object.find("B"):findAll())
			local flesh = miniFlesh:create(ground.x + math.random(10, (16 * ground:get("width_box"))), ground.y)
			fleshCreationPacket:sendAsHost(net.ALL, nil, miniFlesh, flesh.x, flesh.y)
		end
	end
end

registercallback("onStageEntry", function()
	misc.director:getData().flesh = 0
	if not net.online then
		spawnFlesh()
	elseif net.host then
		net.localPlayer:getData().fleshTimer = 5
	end
end)

callback.register("onPlayerStep", function(player)
	if player:getData().fleshTimer then
		player:getData().fleshTimer = player:getData().fleshTimer - 1
		if player:getData().fleshTimer <= 0 then
			spawnFlesh()
			player:getData().fleshTimer = nil
		end
	end
end)

registercallback("onStep", function()
	local dD = misc.director:getData()
	if dD.flesh >= 4 then
		dD.flesh = 0
		local groundRand = math.random(-50, 50)
		local tp = Object.find("Teleporter"):find(1) or Object.find("Command"):find(1)
		local bf = bigFlesh:create(tp.x + groundRand, tp.y)
		if not bf:collidesMap(bf.x, bf.y) then
				local failsafe = 0
			repeat
				bf.y = bf.y + 1
				failsafe = failsafe + 1
			until bf:collidesMap(bf.x, bf.y) or failsafe >= 100
			bf.y = bf.y - 1
		end
		fleshCreationPacket:sendAsHost(net.ALL, nil, bigFlesh, bf.x, bf.y)
	end
end)

item:setLog{
    group = "rare_locked",
    description = "Spawn 4 &r&chunks of flesh&!& around the map. Collecting all 4 will summon a &r&Flesh Amalgamate&!& near the Teleporter. While the Telporter is active, killing an enemy near the &r&Flesh Amalgamate&!& will create an explosion for &y&800% damage&!&.",
    priority = "&r&High Priority/Biological?&!&",
    destination = "Caroline Williams,\nRare/Extinct\nStudy Center,\nVenus",
    date = "8/4/2056",
    story = "Hey Car, me again. I know it's not your usual thing and all, but this little freak of nature was too cute! It was all whining and begging at me in the alleyway- Stop asking me where I find them -and I just *need* you to look at it! At least let me know how long it's gonna last... I wanna keep it!"
}

local ach = Achievement.new("homunculusitem")
ach.requirement = 300
ach.deathReset = false
ach.description = "Kill 300 enemies while charging Teleporters."
ach:assignUnlockable(item)

registercallback("onNPCDeath", function()
	local tp = Object.find("Teleporter"):find(1)
	if not tp then return end
	if tp:get("active") == 1 then
		ach:increment(1)
	end
end)
