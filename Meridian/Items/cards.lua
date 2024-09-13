local item = Item("Collectible Cards")

item.pickupText = "Enemies become more valuable over time." 

item.sprite = Sprite.load("Items/cards.png", 1, 15,  15)

registercallback("onGameStart", function()
	local dD = misc.director:getData()
	dD.cardTimer = 0
end)

local enemies = ParentObject.find("enemies")
registercallback("onStep", function()
	local cardCount = 0
	for _, i in ipairs(misc.players) do
		cardCount = cardCount + i:countItem(item)
	end
	if cardCount > 0 then
	local dD = misc.director:getData()
		dD.cardTimer = dD.cardTimer + 1
		if dD.cardTimer >= 5 * 60 then
			for _, i in ipairs(enemies:findAll()) do
				if i:get("team") == "enemy" and i:get("exp_worth") and i:get("exp_worth") > 0 then
					i:set("exp_worth", i:get("exp_worth") + ((1 * Difficulty.getScaling("cost")) * cardCount))
				end
			end
		dD.cardTimer = 0
		end
	end
end)

item:setLog{
    group = "uncommon",
    description = "Every 5 seconds, enemies become worth &y&1&!& &dg&(+1 per stack)&!& more gold, scaling with time.",
    priority = "&g&Priority&!&",
    destination = "The Great Furnace,\nDying Star,\nDeep Space",
    date = "--",
    story = "Regrettably, I've started to feel excitement when I see a Bison. Though they are tough to fell, I can utilize almost every part of their corpse. Their meat reminds me of home. Their bones are sturdy and well-used in my tools. Their metallic growths... exhibit some strange properties. I'm sure they're valuable, if nothing else."
}