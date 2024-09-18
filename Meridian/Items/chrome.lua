local item = Item("Chrome Finish")
--you gain 5% max health as shield, drones gain 10%. you and your drones have +10(%?) armor while you have shield

item.pickupText = "You and your drones gain a regenerating shield." 

item.sprite = Sprite.load("Items/chrome.png", 1, 15,  15)
item:setTier("uncommon")

local drones = ParentObject.find("drones")
item:addCallback("pickup", function(player)
	player:set("maxshield", player:get("maxshield") + 10)
	for _, d in ipairs(drones:findAll()) do
		if Object.findInstance(d:get("master")) == player then
			d:set("maxshield", d:get("maxshield") + ((15 + (5 * player:countItem(item))) * Difficulty.getScaling(hp)))
			d:set("shield", d:get("shield") + ((15 + (5 * player:countItem(item))) * Difficulty.getScaling(hp)))
		end
	end
end)

registercallback("onHit", function(damager, hit, x, y)
	for _, d in ipairs(drones:findAll()) do
		if hit == d then
			local dD = d:getData()
			dD.shield_cooldown = 420
--			print("on_cd")
		end
	end
end)

registercallback("onActorInit", function(self)
	for _, d in ipairs(drones:findAll()) do
		if self == d then
			local player = Object.findInstance(d:get("master"))
			if player:getObject() == Object.find("p") then
				if player:countItem(item) > 0 then
					d:set("maxshield", d:get("maxshield") + ((15 + (5 * player:countItem(item))) * Difficulty.getScaling(hp)))
					d:set("shield", d:get("shield") + ((15 + (5 * player:countItem(item))) * Difficulty.getScaling(hp)))
				end
			end
			local dD = d:getData()
			dD.shield_cooldown = 0
			dD.chromeArmor = 0
			return
		end
	end
end)

local outlineInstances = {}

registercallback("onStep", function()
	for _, d in ipairs(drones:findAll()) do
		local dD = d:getData()
		local id = d.id
		if not dD.shield_cooldown then dD.shield_cooldown = 0 end
		if not dD.chromeArmor then dD.chromeArmor = 0 end
		if dD.shield_cooldown > 0 then
			dD.shield_cooldown = dD.shield_cooldown - 1
			if dD.shield_cooldown == 1 then
				dD.shield_cooldown = dD.shield_cooldown - 1
			end
		else
			d:set("shield", d:get("maxshield"))
--			print("off_cd")
		end
		if d:get("shield") > d:get("maxshield") then
			d:set("shield", d:get("maxshield"))
		end
		if (outlineInstances[id] and outlineInstances[id]:isValid()) then
			outlineInstances[id]:destroy()
			outlineInstances[id] = nil
		end
		if d:get("shield") > 0 then
			local trail = Object.find("EfOutline"):create(d.x, d.y)
			trail:set("parent", d.id)
			trail.sprite = d.sprite
			trail.subimage = d.subimage
			trail.xscale = d.xscale
			trail:set("rate", 1)
			trail.blendColor = Color.fromRGB(68, 170, 115)
			trail.alpha = 10
			outlineInstances[id] = trail
		end
		if d:get("maxshield") > 0 and d:get("shield") > 0 and dD.chromeArmor == 0 then
			d:set("armor", d:get("armor") + 10)
			dD.chromeArmor = 1
		end
		if d:get("maxshield") > 0 and d:get("shield") <= 0 and dD.chromeArmor == 1 then
			d:set("armor", d:get("armor") - 10)
			dD.chromeArmor = 0
		end
	end
end)

registercallback("onPlayerInit", function(player)
	local pD = player:getData()
	pD.chromeArmor = 0
end)

registercallback("onPlayerStep", function(player)
	local pD = player:getData()
	if player:countItem(item) > 0 and player:get("shield") > 0 and pD.chromeArmor == 0 then
		player:set("armor", player:get("armor") + 10)
		pD.chromeArmor = 1
	end
	if player:countItem(item) > 0 and player:get("shield") <= 0 and pD.chromeArmor == 1 then
		player:set("armor", player:get("armor") - 10)
		pD.chromeArmor = 0
	end
end)


item:setLog{
    group = "uncommon",
    description = "Gain &g&10 shield&!&. Your drones gain &g&20 shield&!& &dg&(+5 per stack)&!&. You and your drones gain &g&10 armor&!& while you have shield.",
    priority = "&g&Priority&!&",
    destination = "The Great Furnace,\nDying Star,\nDeep Space",
    date = "--",
    story = "Regrettably, I've started to feel excitement when I see a Bison. Though they are tough to fell, I can utilize almost every part of their corpse. Their meat reminds me of home. Their bones are sturdy and well-used in my tools. Their metallic growths... exhibit some strange properties. I'm sure they're valuable, if nothing else."
}