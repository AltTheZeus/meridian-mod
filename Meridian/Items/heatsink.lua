local item = Item.new("OverclockedHeatsink")

item.pickupText = "Use items have a chance to not go on cooldown." 
item.displayName = "Overclocked Heatsink"

item.sprite = Sprite.load("Items/heatsink.png", 1, 10, 11)
item:setTier("rare")

callback.register("postUseItemUse", function(player, use)
	local amount = player:countItem(item)
	local chance = math.floor((1 - 0.75^amount) * 100)
	
	if chance > 0 and math.chance(chance) then 
		player:setAlarm(0, 20)
	end
end)

item:setLog{
    group = "rare",
    description = ".",
    priority = "&w&Standard&!&",
    destination = "Stepped Terraces,\n3rd Colony,\nMars",
    date = "8/12/2056",
    story = "."
}