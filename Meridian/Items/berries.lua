local item = Item("Foraged Spoils")

item.pickupText = "Living off the land." 

item.sprite = Sprite.load("Items/berries.png", 1, 15, 15)
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

registercallback("onNPCDeathProc", function(npc, player)
	if player:countItem(item) > 0 then
		for a, b in pairs(itemAssignments) do
			if a == "SquallEel" then
				if npc:getObject() == Object.find("Squall Eel") then
					if math.chance(2.5 + (player:countItem(item) * 2.5)) then
						b:create(npc.x, npc.y)
					end
				end
			end
			if a == "CosmicVanguard" then
				if npc:getObject() == Object.find("Cosmic Vanguard") then
					if math.chance(2.5 + (player:countItem(item) * 2.5)) then
						b:create(npc.x, npc.y)
					end
				end
			end
			if a == "Worm" then
				if npc:getObject() == Object.find("Worm") or npc:getObject() == Object.find("WormBody") or npc:getObject() == Object.find("WormController") or npc:getObject() == Object.find("WormHead") then
					if math.chance(2.5 + (player:countItem(item) * 2.5)) then
						b:create(player.x, player.y)
					end
				end
			end
			if npc:getObject():getName() == a then
				if math.random(100) <= (2.5 + (player:countItem(item) * 2.5)) then
					if a == "Wyvern" then
						b:create(player.x, player.y)
					else
						b:create(npc.x, npc.y)
					end
				end
			end
		end
	end
end)

--TODO: add mystic's extras alternate drop compat

item:setLog{
    group = "uncommon",
    description = "Bosses have a 5% &dg&(+2.5% per stack)&!& chance to drop a &r&unique item&!&.",
    priority = "&g&Field Found&!&",
    destination = "The Great Furnace,\nDying Star,\nDeep Space",
    date = "--",
    story = "Regrettably, I've started to feel excitement when I see a Bison. Though they are tough to fell, I can utilize almost every part of their corpse. Their meat reminds me of home. Their bones are sturdy and well-used in my tools. Their metallic growths... exhibit some strange properties. I'm sure they're valuable, if nothing else."
}