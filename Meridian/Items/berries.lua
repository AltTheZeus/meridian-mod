local item = Item("Foraged Spoils")

item.pickupText = "Living off the land." 

item.sprite = Sprite.load("Items/berries.png", 1, 15, 15)
itemEf = Sprite.load("Items/berriesEf.png", 3, 5, 5)
local itemAssignments = {
	GolemG = Item.find("Colossal Knurl"),
	GiantJelly = Item.find("Nematocyst Nozzle"),
	Worm = Item.find("Burning Witness"),
	WispB = Item.find("Legendary Spark"),
	ImpG = Item.find("Imp Overlord's Tentacle"),
	ImpGS = Item.find("Imp Overlord's Tentacle"),
	Ifrit = Item.find("Ifrit's Horn"),
	Lacertian = Item.find("Relentless Fang")
	}
registercallback("postLoad", function()
	if modloader.checkMod("Starstorm") then
		itemAssignments["Boar"] = Item.find("Toxic Tail")
		itemAssignments["Turtle"] = Item.find("Scalding Scale")
		itemAssignments["Scavenger"] = Item.find("Scavenger's Fortune")
		itemAssignments["SandCrabKing"] = Item.find("Shell Piece")
		itemAssignments["Post"] = Item.find("Unearthly Lamp")
		itemAssignments["TotemController"] = Item.find("Animated Mechanism")
		itemAssignments["TotemPart"] = Item.find("Animated Mechanism")
		itemAssignments["SquallEel"] = Item.find("Regurgitated Rock")
		itemAssignments["Wyvern"] = Item.find("Wyvernling")
	end
	if modloader.checkMod("MysticsExtras") then
		itemAssignments["CosmicVanguard"] = Item.find("Stardust Shield")
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

berryBush:addCallback("draw", function(self)
	local sD = self:getData()
	for _, i in ipairs(misc.players) do
		if self:collidesWith(i, self.x, self.y) then
			graphics.alpha(1)
			local offset = graphics.textWidth("Press '" .. input.getControlString("enter", i) .. "' to forage.", graphics.FONT_DEFAULT) / 2
			graphics.printColor("&w&Press &y&'" .. input.getControlString("enter", i) .. "'&w& to forage.&!&", self.x - offset + 5, self.y - 30, graphics.FONT_DEFAULT)
			if input.checkControl("enter", i) == 2 or input.checkControl("enter", i) == 3 then
				if sD.payload then
					sD.payload:create(self.x, self.y - 16)
					berrySplash:burst("above", self.x, self.y - 6, 20)
					self:destroy()
				else
					item:create(self.x, self.y - 16)
					berrySplash:burst("above", self.x, self.y - 6, 20)
					self:destroy()
				end
			end
		end
	end
end)

registercallback("onNPCDeathProc", function(npc, player)
	if player:countItem(item) > 0 then
		for a, b in pairs(itemAssignments) do
			if a == "SquallEel" then
				if npc:getObject() == Object.find("Squall Eel") then
					if math.chance(2.5 + (player:countItem(item) * 2.5)) then
						local bush = berryBush:create(npc.x, npc.y - 20)
						local bD = bush:getData()
						bD.payload = b
					end
				end
			end
			if a == "CosmicVanguard" then
				if npc:getObject() == Object.find("Cosmic Vanguard") then
					if math.chance(2.5 + (player:countItem(item) * 2.5)) then
						local bush = berryBush:create(npc.x, npc.y - 20)
						local bD = bush:getData()
						bD.payload = b
					end
				end
			end
			if a == "Worm" then
				if npc:getObject() == Object.find("Worm") or npc:getObject() == Object.find("WormBody") or npc:getObject() == Object.find("WormController") or npc:getObject() == Object.find("WormHead") then
					if math.chance(2.5 + (player:countItem(item) * 2.5)) then
						local bush = berryBush:create(player.x, player.y - 20)
						local bD = bush:getData()
						bD.payload = b
					end
				end
			end
			if npc:getObject():getName() == a then
				if math.random(100) <= (2.5 + (player:countItem(item) * 2.5)) then
					if a == "Wyvern" then
						local bush = berryBush:create(player.x, player.y - 20)
						local bD = bush:getData()
						bD.payload = b
					else
						local bush = berryBush:create(npc.x, npc.y - 20)
						local bD = bush:getData()
						bD.payload = b
					end
				end
			end
		end
	end
end)

--TODO: add mystic's extras alternate drop compat
--TODO: blacklist from command runs?

item:setLog{
    group = "uncommon",
    description = "Bosses have a 5% &dg&(+2.5% per stack)&!& chance to drop a &r&unique item&!&.",
    priority = "&g&Field Found&!&",
    destination = "The Great Furnace,\nDying Star,\nDeep Space",
    date = "--",
    story = "Regrettably, I've started to feel excitement when I see a Bison. Though they are tough to fell, I can utilize almost every part of their corpse. Their meat reminds me of home. Their bones are sturdy and well-used in my tools. Their metallic growths... exhibit some strange properties. I'm sure they're valuable, if nothing else."
}