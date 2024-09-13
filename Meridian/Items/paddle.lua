local item = Item("Bidder's Paddle")

item.pickupText = "Picking up an item reduces the price of chests." 

item.sprite = Sprite.load("Items/paddle.png", 1, 10,  11)

local things = ParentObject.find("mapObjects")
registercallback("onItemPickup", function(itemHey, player)
	if player:countItem(item) > 0 then
		for _, i in ipairs(things:findAll()) do
			if i:get("cost") and i:get("cost") > 0 then
				print("old: "..i:get("cost"))
				local costNew = math.round(((i:get("cost") * 0.02) * player:countItem(item)))
				if costNew < 1 then costNew = 1 end
				i:set("cost", i:get("cost") - costNew)
				print("new: "..i:get("cost"))
			end
		end
	end
end)

item:setLog{
    group = "common",
    description = "When picking up an item, decrease the cost of all interactables on the stage by &y&2%&!& &dg&(+2% per stack)&!&.",
    priority = "&w&Standard&!&",
    destination = "The Great Furnace,\nDying Star,\nDeep Space",
    date = "--",
    story = "Regrettably, I've started to feel excitement when I see a Bison. Though they are tough to fell, I can utilize almost every part of their corpse. Their meat reminds me of home. Their bones are sturdy and well-used in my tools. Their metallic growths... exhibit some strange properties. I'm sure they're valuable, if nothing else."
}