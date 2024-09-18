local item = Item("Bidder's Paddle")

item.pickupText = "Picking up an item reduces the price of chests." 

item.sprite = Sprite.load("Items/paddle.png", 1, 10, 11)
item:setTier("common")

local paddleEf = Object.new("paddleEf")
paddleEf.sprite = Sprite.load("Items/paddleEf.png", 12, 18, 61)

paddleEf:addCallback("create", function(self)
	local sD = self:getData()
	self.spriteSpeed = 0.2
	sD.looped = false
end)

paddleEf:addCallback("step", function(self)
	local sD = self:getData()
	if self.subimage >= 12 and sD.looped == false then
		sD.looped = true
	end
	if self.subimage < 2 and sD.looped == true then
		self:destroy()
	end
end)

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
		paddleEf:create(player.x, player.y)
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

local ach = Achievement.new("paddleitem")
ach.requirement = 1
ach.deathReset = true
ach.description = "Fully loot a stage."
ach:assignUnlockable(item)

registercallback("onGameStart", function()
	local dD = misc.director:getData()
	dD.achPaddleTracker = {}
end)

registercallback("onStageEntry", function()
	local dD = misc.director:getData()
	dD.achPaddleTracker = {}
	for _, i in ipairs(things:findAll()) do
		if i:get("cost") and i:get("cost") > 0 then
			dD.achPaddleTracker[i.id] = "init"
		end
	end
--	print(dD.achPaddleTracker)
end)

registercallback("onStep", function()
	local dD = misc.director:getData()
	local goal = 0
	local actual = 0
	for id, a in pairs(dD.achPaddleTracker) do
		goal = goal + 1
	end
	for id, a in pairs(dD.achPaddleTracker) do
		if Object.findInstance(id) then
			local obby = Object.findInstance(id)
			if obby:get("active") and obby:get("active") >= 2 then
				dD.achPaddleTracker[id] = "opened"
--				print(dD.achPaddleTracker)
			elseif obby:get("active") and obby:get("active") < 2 then
				dD.achPaddleTracker[id] = "init"
			end
			if not obby:get("active") then
				print(obby:getObject())
			end
		else
			dD.achPaddleTracker[id] = nil
		end
		if a == "opened" then
			actual = actual + 1
		end
--		print("Goal: " .. goal)
--		print("Actual: " .. actual)
		if actual == goal then ach:increment(1) end
	end
end)