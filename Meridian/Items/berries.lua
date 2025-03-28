local item = Item("Foraged Spoils")

item.pickupText = "Living off the land." 
item:setTier("uncommon")

item.sprite = Sprite.load("Items/berries.png", 1, 15, 15)
local itemEf = Sprite.load("Items/berriesEf.png", 3, 5, 5)
local itemAssignments = {
	GolemG = Item.find("Colossal Knurl"),
	GiantJelly = Item.find("Nematocyst Nozzle"),
	Worm = Item.find("Burning Witness"),
	WispB = Item.find("Legendary Spark"),
	ImpG = Item.find("Imp Overlord's Tentacle"),
	ImpGS = Item.find("Imp Overlord's Tentacle"),
	Ifrit = Item.find("Ifrit's Horn")
	}
local mysticAssignments = {}
local sdAssignments = {}
registercallback("postLoad", function()
	itemAssignments["Lacertian"] = Item.find("Relentless Fang")
	itemAssignments["doomdrop"] = Item.find("Misshapen Flesh")
	if modloader.checkMod("Starstorm") then
		itemAssignments["Boar"] = Item.find("Toxic Tail")
		itemAssignments["Turtle"] = Item.find("Scalding Scale")
		itemAssignments["Scavenger"] = Item.find("Lifetime Fortune")
		itemAssignments["SandCrabKing"] = Item.find("Shell Piece")
		itemAssignments["Post"] = Item.find("Unearthly Lamp")
		itemAssignments["TotemController"] = Item.find("Animated Mechanism")
		itemAssignments["TotemPart"] = Item.find("Animated Mechanism")
		itemAssignments["SquallEel"] = Item.find("Regurgitated Rock")
		itemAssignments["Wyvern"] = Item.find("Wyvernling")
	end
	if modloader.checkMod("MysticsExtras") then
		itemAssignments["CosmicVanguard"] = Item.find("Stardust Shield")
		mysticAssignments["GolemG"] = Item.find("Earth Essence")
		mysticAssignments["GiantJelly"] = Item.find("Tentacle Branch")
		mysticAssignments["WispB"] = Item.find("Archaic Mask")
		mysticAssignments["ImpG"] = Item.find("Ghastly Eye")
		mysticAssignments["ImpGS"] = Item.find("Ghastly Eye")
		mysticAssignments["Ifrit"] = Item.find("Ifrit's Tail")
	end
	if modloader.checkMod("rorsd") then
		sdAssignments["Scavenger"] = Item.find("Freebee Membership")
		itemAssignments["ImpGS"] = Item.find("All Seer")
	end
end)

local berrySplash = ParticleType.new("bushDebris")
berrySplash:sprite(itemEf, false, false, true)
berrySplash:alpha(1, 1, 0)
berrySplash:scale(1, 1)
berrySplash:size(1.1, 0.9, -0.02, 0)
berrySplash:angle(0, 360, 1, 0, true)
berrySplash:speed(0.8, 1, -0.001, 0)
berrySplash:direction(0, 360, 0, 0)
berrySplash:gravity(0, 0)
berrySplash:life(60, 80)

local berryBush = Object.new("Berry Bush")
berryBush.sprite = Sprite.load("Items/berriesObj.png", 1, 17, 19)

local bushCreationPacket
bushCreationPacket = net.Packet("Berry Bush Creation Packet", function(sender, x, y, item)
	local bush = berryBush:create(x, y)
	bush:getData().payload = item
end)

berryBush:addCallback("create", function(self)
	if not self:collidesMap(self.x, self.y) then
		local UHOHcheck = 0
		repeat
			self.y = self.y + 1
			UHOHcheck = UHOHcheck + 1
		until self:collidesMap(self.x, self.y) or UHOHcheck >= 200
		self.y = self.y - 1
	end
end)

local bushActivationPacket
bushActivationPacket = net.Packet("Berry Bush Activation Packet", function(sender, x, y, newItem)
	local bush = berryBush:findNearest(x, y)
	if newItem then
		newItem:create(bush.x, bush.y)
	end
	berrySplash:burst("above", bush.x, bush.y - 6, 20)
	bush:destroy()
	
	if net.host then
		bushActivationPacket:sendAsHost(net.EXCLUDE, sender, x, y)
	end
end)

berryBush:addCallback("draw", function(self)
	local sD = self:getData()
	for _, i in ipairs(misc.players) do
		if self:collidesWith(i, self.x, self.y) then
			graphics.alpha(1)
			graphics.color(Color.WHITE)
			local offset = graphics.textWidth("Press '" .. input.getControlString("enter", i) .. "' to forage.", graphics.FONT_DEFAULT) / 2
			graphics.printColor("Press &y&'" .. input.getControlString("enter", i) .. "'&!& to forage.", self.x - offset + 5, self.y - 30, graphics.FONT_DEFAULT)
			if input.checkControl("enter", i) == 2 or input.checkControl("enter", i) == 3 then
				local newItem = Artifact.find("Command").active and (modloader.checkMod("Starstorm") and ItemPool.find("legendary"):getCrate() or ItemPool.find("uncommon"):getCrate()) or (sD.payload or item)
				if net.host then
					newItem:create(self.x, self.y)
					bushActivationPacket:sendAsHost(net.ALL, nil, self.x, self.y)
				else
					bushActivationPacket:sendAsClient(self.x, self.y, newItem)
				end
				berrySplash:burst("above", self.x, self.y - 6, 20)
				self:destroy()
			end
		end
	end
end)

registercallback("onGameStart", function()
	local dD = misc.director:getData()
	dD.bushTableX = {}
	dD.bushTableY = {}
	dD.bushTableI = {}
end)

registercallback("onNPCDeathProc", function(npc, player)
	if player:countItem(item) > 0 and net.host then
		local dD = misc.director:getData()
		if modloader.checkMod("Starstorm") and Artifact.find("Command").active == true then 
				if math.chance(2.5 + (player:countItem(item) * 2.5)) then
					dD.bushTableX[npc.id] = npc.x
					dD.bushTableY[npc.id] = npc.y - 20
					dD.bushTableI[npc.id] = "nothing"
				end
		else
		for a, b in pairs(itemAssignments) do
--			print(a)
			if a == "SquallEel" then
				if npc:getObject() == Object.find("Squall Eel") then
					if math.chance(2.5 + (player:countItem(item) * 2.5)) then
						dD.bushTableX[npc.id] = npc.x
						dD.bushTableY[npc.id] = npc.y - 20
						dD.bushTableI[npc.id] = b
					end
				end
			end
			if a == "CosmicVanguard" then
				if npc:getObject() == Object.find("Cosmic Vanguard") then
					if math.chance(2.5 + (player:countItem(item) * 2.5)) then
						dD.bushTableX[npc.id] = npc.x
						dD.bushTableY[npc.id] = npc.y - 20
						dD.bushTableI[npc.id] = b
					end
				end
			end
			if a == "Worm" then
				if npc:getObject() == Object.find("Worm") or npc:getObject() == Object.find("WormBody") or npc:getObject() == Object.find("WormController") or npc:getObject() == Object.find("WormHead") then
					if math.chance(2.5 + (player:countItem(item) * 2.5)) then
						dD.bushTableX[npc.id] = npc.x
						dD.bushTableY[npc.id] = npc.y - 20
						if modloader.checkMod("MysticsExtras") and math.random(100) <= 50 then
							dD.bushTableI[npc.id] = Item.find("Fiery Gland")
						else
							dD.bushTableI[npc.id] = b
						end
					end
				end
			end
			if a == "doomdrop" then
				if npc:getObject() == Object.find("mergerG") then
					local aD = npc:getData()
					if aD.bossedUp ~= nil and math.chance(2.5 + (player:countItem(item) * 2.5)) then
						dD.bushTableX[npc.id] = npc.x
						dD.bushTableY[npc.id] = npc.y - 20
						dD.bushTableI[npc.id] = b
					end
				end
			end
			if npc:getObject():getName() == a then
				if math.random(100) <= (2.5 + (player:countItem(item) * 2.5)) then
					if a == "Wyvern" then
						dD.bushTableX[npc.id] = npc.x
						dD.bushTableY[npc.id] = npc.y - 20
						dD.bushTableI[npc.id] = b
					else
						if modloader.checkMod("rorsd") and modloader.checkMod("Starstorm") and math.random(100) <= 50 and a == "Scavenger" then
							for i, j in pairs(sdAssignments) do
								if npc:getObject():getName() == i then
									dD.bushTableX[npc.id] = npc.x
									dD.bushTableY[npc.id] = npc.y - 20
									dD.bushTableI[npc.id] = j
								end
							end
						elseif modloader.checkMod("rorsd") and not modloader.checkMod("Starstorm") and a == "Scavenger" then
							for g, h in pairs(sdAssignments) do
								if npc:getObject():getName() == g then
									dD.bushTableX[npc.id] = npc.x
									dD.bushTableY[npc.id] = npc.y - 20
									dD.bushTableI[npc.id] = h
								end
							end
						elseif modloader.checkMod("MysticsExtras") and math.random(100) <= 50 and (a == "WispB" or a == "GolemG" or a == "ImpG" or a == "ImpGS" or a == "Ifrit" or a == "GiantJelly") then
							for c, d in pairs(mysticAssignments) do
								if npc:getObject():getName() == c then
									dD.bushTableX[npc.id] = npc.x
									dD.bushTableY[npc.id] = npc.y - 20
									dD.bushTableI[npc.id] = d
								end
							end
						else
							dD.bushTableX[npc.id] = npc.x
							dD.bushTableY[npc.id] = npc.y - 20
							dD.bushTableI[npc.id] = b
						end
					end
				end
			end
		end
		end
	end
end)

registercallback("onStep", function()
	local dD = misc.director:getData()
	for id, x in pairs(dD.bushTableX) do
		local bush = berryBush:create(dD.bushTableX[id], dD.bushTableY[id])
		local bD = bush:getData()
		bD.payload = dD.bushTableI[id]
		dD.bushTableX[id] = nil
		dD.bushTableY[id] = nil
		dD.bushTableI[id] = nil
		
		bushCreationPacket:sendAsHost(net.ALL, nil, bush.x, bush.y, bD.payload)
	end
end)

item:setLog{
    group = "uncommon",
    description = "Bosses have a 5% chance to drop a &r&unique item&!&.",
    priority = "&g&Field-Found&!&",
    destination = "Bio-Analysis Lab,\nCaledew,\n25 and 4th Quadrant",
    date = "6/5/2056",
    story = "My time on this planet has taught me many things. Among them, resourcefulness. Finding food is a constant struggle, and I'm left desperate enough to consume alien plants such as this. To my delight, they don't seem to have had any ill-effects yet, and they only taste bad if I think about it too hard.\n\n...Which is hard to do on an empty stomach."
}
