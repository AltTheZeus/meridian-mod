local item = Item("Snowball")

item.pickupText = "The snowball effect." 

item.sprite = Sprite.load("Items/snowball.png", 1, 15, 15)

registercallback("onFireSetProcs", function(damager, parent)
	if parent:getObject() == Object.find("p") then
		if parent:countItem(item) > 0 then
			local dD = damager:getData()
			dD.balling = parent:countItem(item)
			dD.ballParent = parent
		end
	end
end)

registercallback("preHit", function(damager, hit)
	local dD = damager:getData()
	if dD.balling and dD.balling > 0 then
--		print(damager:get("damage"))
		local raw = damager:get("damage") / dD.ballParent:get("damage")
--		print("raw: "..raw)
		local damCheck = 0
		local counter = 0
			repeat
				damCheck = damCheck + 0.02 + (dD.balling * 0.01)
				counter = counter + 0.1
			until counter >= raw
		damager:set("damage", damager:get("damage") + (damCheck * dD.ballParent:get("damage")))
		damager:set("damage_fake", (damager:get("damage_fake") + (damCheck * dD.ballParent:get("damage"))))
--		print(damager:get("damage"))
	end
end)

item:setLog{
    group = "rare",
    description = "Increase the damage of attacks based on the damage of the attack. The higher the damage, the more extra damage is added.",
    priority = "&r&High Priority&!&",
    destination = "The Great Furnace,\nDying Star,\nDeep Space",
    date = "--",
    story = "Regrettably, I've started to feel excitement when I see a Bison. Though they are tough to fell, I can utilize almost every part of their corpse. Their meat reminds me of home. Their bones are sturdy and well-used in my tools. Their metallic growths... exhibit some strange properties. I'm sure they're valuable, if nothing else."
}