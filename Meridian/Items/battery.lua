local item = Item("Portable Battery")

item.pickupText = "Increase regen while equipment is off cooldown." 

item.sprite = Sprite.load("Items/battery.png", 1, 10, 11)

registercallback("onPlayerInit", function(player)
	local sD = player:getData()
	sD.batteryTracker = "false"
	sD.batteryAddition = 0
	sD.highlightTimer = 0
end)

registercallback("onPlayerStep", function(self)
	local sD = self:getData()
	if self:countItem(item) >= 1 and self.useItem ~= nil and self:getAlarm(0) == -1 and sD.batteryTracker == "false" then
		print("boosting")
		sD.batteryAddition = 0.005 * self:countItem(item)
		self:set("hp_regen", self:get("hp_regen") + sD.batteryAddition)
		sD.batteryTracker = "true"
	end
	if self:countItem(item) >= 1 and self.useItem ~= nil and self:getAlarm(0) ~= -1 and sD.batteryTracker == "true" then
		print("unboosting")
		self:set("hp_regen", self:get("hp_regen") - sD.batteryAddition)
		sD.batteryAddition = 0
		sD.batteryTracker = "false"
		sD.highlightTimer = 0
	end
	if self:countItem(item) < 1 and sD.batteryTracker == "true" then
		self:set("hp_regen", self:get("hp_regen") - sD.batteryAddition)
		sD.batteryAddition = 0
		sD.batteryTracker = "false"
		sD.highlightTimer = 0
	end
	if sD.batteryTracker == "true" then
		sD.highlightTimer = sD.highlightTimer + 1
		if sD.highlightTimer >= 20 and sD.highlightTimer <= 50 then
			local o = Object.find("EfOutline"):create(0, 0):set("parent", self.id)
			o.blendColor = Color.DAMAGE_HEAL
			o.alpha = 0.1
		elseif sD.highlightTimer >= 80 then
			sD.highlightTimer = 0
		end
	end
end)

item:setLog{
    group = "common",
    description = "While your equipment is off cooldown, increase &g&health regen&!& by &g&0.3&!& &dg&(+0.3 per stack)&!& per second.",
    priority = "&w&Standard&!&",
    destination = "The Great Furnace,\nDying Star,\nDeep Space",
    date = "--",
    story = "Regrettably, I've started to feel excitement when I see a Bison. Though they are tough to fell, I can utilize almost every part of their corpse. Their meat reminds me of home. Their bones are sturdy and well-used in my tools. Their metallic growths... exhibit some strange properties. I'm sure they're valuable, if nothing else."
}