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

local things = ParentObject.find("chests")
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
    group = "common_locked",
    description = "When picking up an item, decrease the cost of all chests on the stage by &y&2%&!& &dg&(+2% per stack)&!&.",
    priority = "&w&Standard&!&",
    destination = "Lot 2,\nEx-Shipping District,\nStorage Planet",
    date = "6/25/2056",
    story = "Here, a bit of a meta-delivery for you folks back at the gig. This is the very same paddle Rando Jarkins used in the infamous episode which almost got us canned. Plant this in one of the lockers, it's sure to get people talking about us again!"
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
