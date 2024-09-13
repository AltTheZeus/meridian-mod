local item = Item("Jumpstart Cable")

item.pickupText = "Once per stage, purchase a drone for free." 

item.sprite = Sprite.load("Items/cable.png", 1, 13, 13)

registercallback("onGameStart", function()
	local dD = misc.director:getData()
	dD.freedrones = 0
end)

local drones = ParentObject.find("droneItems")
registercallback("onStageEntry", function()
	local dD = misc.director:getData()
	dD.freedrones = 0
	for _, p in ipairs(misc.players) do
		dD.freedrones = dD.freedrones + p:countItem(item)
	end
	if dD.freedrones > 0 then
		for _, i in ipairs(drones:findAll()) do
			local iD = i:getData()
			iD.IMADRONE = "i sure am"
			iD.truecost = i:get("cost")
			i:set("cost", 0)
		end
	end
end)

registercallback("onMapObjectActivate", function(self, player)
	local sD = self:getData()
	local dD = misc.director:getData()
	if sD.IMADRONE == "i sure am" and dD.freedrones > 0 then
		misc.setGold(misc.getGold() + self:get("cost"))
		dD.freedrones = dD.freedrones -1
		if dD.freedrones <= 0 then
			for _, i in ipairs(drones:findAll()) do
				local iD = i:getData()
				i:set("cost", iD.truecost)
				iD.truecost = nil
			end
			dD.freedrones = 0
		end
	end
end)

item:addCallback("pickup", function(player)
	local pD = player:getData()
	local dD = misc.director:getData()
	dD.freedrones = dD.freedrones + 1
	for _, i in ipairs(drones:findAll()) do
		local iD = i:getData()
		if not iD.truecost then
			iD.IMADRONE = "i sure am"
			iD.truecost = i:get("cost")
			i:set("cost", 0)
		end
	end
end)

item:setLog{
    group = "uncommon",
    description = "Purchase one drone &g&for free&!& per stage.",
    priority = "&g&Priority&!&",
    destination = "The Great Furnace,\nDying Star,\nDeep Space",
    date = "--",
    story = "Regrettably, I've started to feel excitement when I see a Bison. Though they are tough to fell, I can utilize almost every part of their corpse. Their meat reminds me of home. Their bones are sturdy and well-used in my tools. Their metallic growths... exhibit some strange properties. I'm sure they're valuable, if nothing else."
}