local item = Item("Portable Battery")

item.pickupText = "Increase regen while equipment is off cooldown." 

item.sprite = Sprite.load("Items/battery.png", 1, 10, 11)
local itemEf = Sprite.load("Items/batteryEf.png", 1, 0, 0)
item:setTier("common")

registercallback("onPlayerInit", function(player)
	local sD = player:getData()
	sD.batteryTracker = "false"
	sD.batteryAddition = 0
	sD.highlightTimer = 0
end)

registercallback("onPlayerStep", function(self)
	local sD = self:getData()
	if self:countItem(item) >= 1 and self.useItem ~= nil and self:getAlarm(0) == -1 and sD.batteryTracker == "false" then
--		print("boosting")
		sD.batteryAddition = 0.03 * self:countItem(item)
		self:set("hp_regen", self:get("hp_regen") + sD.batteryAddition)
		sD.batteryTracker = "true"
	end
	if self:countItem(item) >= 1 and self.useItem ~= nil and self:getAlarm(0) ~= -1 and sD.batteryTracker == "true" then
--		print("unboosting")
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

registercallback("onPlayerHUDDraw", function(player, x, y)
	if player:countItem(item) > 0 and player:getAlarm(0) == -1 and player.useItem ~= nil then
		graphics.drawImage{itemEf, x + 89, y - 20}
	end
end)

item:setLog{
    group = "common_locked",
    description = "While your equipment is off cooldown, increase &g&health regeneration&!& by &g&1.8&!& hp per second.",
    priority = "&w&Standard&!&",
    destination = "Stepped Terraces,\n3rd Colony,\nMars",
    date = "8/12/2056",
    story = "I know it's a bit antiquated by this point, but my pops gave me this battery for my first 'bot, so I'll do the same for you. You might have it running slower than others, but boy howdy does it last. This thing hasn't been refreshed since I first got it way back when, and it's still kicking! I know you'll get some better use out of it than I do."
}

local ach = Achievement.new("batteryitem")
ach.requirement = 1
ach.deathReset = true
ach.description = "Activate 5 unique equipments in one run."
ach:assignUnlockable(item)

local achBatteryTracker = {}
registercallback("onPlayerInit", function(player)
	local pD = player:getData()
	pD.achBattery = 0
	achBatteryTracker = {}
end)

registercallback("onUseItemUse", function(player, item2)
	local itemCheck = 0
--	print(achBatteryTracker)
	for i, id in pairs(achBatteryTracker) do
		if id == player.id and i == item2 then
			itemCheck = itemCheck + 1
		end
	end
	if itemCheck == 0 then
		achBatteryTracker[item2] = player.id
		local itemChecker = 0
		for _, id in pairs(achBatteryTracker) do
			if id == player.id then
				itemChecker = itemChecker + 1
			end
			if itemChecker == 5 then
				ach:increment(1)
			end
		end
	end

end)
