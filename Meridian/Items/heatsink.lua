local item = Item.new("Overclocked Heatsink")

item.pickupText = "Use items have a chance to not go on cooldown." 
item.displayName = "Overclocked Heatsink"

item.sprite = Sprite.load("Items/heatsink.png", 1, 15, 17)
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
    description = "Use items have a &y&25% chance to not go on cooldown&!&.",
    priority = "&r&High Priority&!&",
    destination = "Dorm 212,\nUniversity of New Washington,\nMars",
    date = "03/29/2056",
    story = "Yeah man, I completely upgraded my whole rig, nothing special really. Two brand new motherboards, quad SSDs, 640 gigabytes of RAM, I got three of the newest graphics card in there, and it's ALL soda-cooled. Heh, yeah. I'm KINDA a pro at this. \n\nHere, you can have some of the junk from my old rig, since I know you struggle to hit 3000 FPS on a word document. What with my super sweet soda-cooled rig, I won't be needing this hunk of junk anymore. See you when you get back from university, scrub."
}