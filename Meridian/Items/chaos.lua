local item = Item("Chaos Drive")

item.pickupText = "Heal faster at low health." 

item.sprite = Sprite.load("Items/chaos.png", 1, 15, 15)
local itemEf = Sprite.load("Items/chaosEf.png", 1, 6, 11)
item:setTier("common")

registercallback("onPlayerInit", function(player)
	local sD = player:getData()
	sD.chaosTimer = 0
	sD.chaosCounter = 0
end)

registercallback("onPlayerStep", function(self)
	local sD = self:getData()
	if self:countItem(item) >= 1 and self:get("activity") > 0 and self:get("activity") < 6 then
		sD.chaosTimer = sD.chaosTimer + 1
		if sD.chaosTimer >= 12 then
			sD.chaosCounter = sD.chaosCounter + 1
			sD.chaosTimer = 0
		end
	end
--	print(sD.chaosCounter)
	if sD.chaosCounter > (45 + (15 * self:countItem(item))) then
		sD.chaosCounter = (45 + (15 * self:countItem(item)))
	end
	if self:get("hp") <= self:get("maxhp") * 0.33 and sD.chaosCounter > 0 then
--		print("hp: " .. self:get("hp") .. ", ic: " .. sD.chaosCounter)
		self:set("hp", self:get("hp") + (self:get("maxhp") / 400))
		sD.chaosCounter = sD.chaosCounter - 1
--		print("hp: " .. self:get("hp") .. ", ic: " .. sD.chaosCounter)
	end
end)

registercallback("onPlayerDrawAbove", function(self)
	local sD = self:getData()
	if sD.chaosCounter > 0 then
		local aCalc1 = sD.chaosCounter / (45 + (15 * self:countItem(item)))
		local aCalc = aCalc1 * 0.6
--		if aCalc > 0.6 then
--			aCalc = 0.6
--		end
		graphics.drawImage{
			image = itemEf,
			x = self.x,
			y = self.y,
			alpha = aCalc
			}
	end
end)

item:setLog{
    group = "common",
    description = "Heal faster at low health.",
    priority = "&w&Standard&!&",
    destination = "The Great Furnace,\nDying Star,\nDeep Space",
    date = "--",
    story = "Regrettably, I've started to feel excitement when I see a Bison. Though they are tough to fell, I can utilize almost every part of their corpse. Their meat reminds me of home. Their bones are sturdy and well-used in my tools. Their metallic growths... exhibit some strange properties. I'm sure they're valuable, if nothing else."
}