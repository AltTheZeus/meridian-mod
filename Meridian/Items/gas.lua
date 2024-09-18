local item = Item("Tear Gas")

item.pickupText = "Increase damage against stunned enemies." 

item.sprite = Sprite.load("Items/gas.png", 1, 15, 15)
item:setTier("uncommon")

registercallback("onFireSetProcs", function(damager, parent)
	if parent:getObject() == Object.find("p") then
		if parent:countItem(item) > 0 then
			local dD = damager:getData()
			dD.gassed = parent:countItem(item)
		end
	end
end)

registercallback("preHit", function(damager, hit)
	local dD = damager:getData()
	if dD.gassed and dD.gassed > 0 and hit:get("stunned") == 1 then
		local mult = damager:get("damage") * 0.1
		damager:set("damage", damager:get("damage") + (mult * dD.gassed))
		damager:set("damage_fake", damager:get("damage_fake") + (mult * dD.gassed))
	end
end)

item:setLog{
    group = "uncommon",
    description = "Increase damage against stunned enemies by &y&10%&!& &dg&(+0.3 per stack)&!&.",
    priority = "&g&Priority&!&",
    destination = "The Great Furnace,\nDying Star,\nDeep Space",
    date = "--",
    story = "Regrettably, I've started to feel excitement when I see a Bison. Though they are tough to fell, I can utilize almost every part of their corpse. Their meat reminds me of home. Their bones are sturdy and well-used in my tools. Their metallic growths... exhibit some strange properties. I'm sure they're valuable, if nothing else."
}