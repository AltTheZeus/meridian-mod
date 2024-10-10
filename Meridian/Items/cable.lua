local item = Item("Jumpstart Cable")

item.pickupText = "Once per stage, purchase a drone for free." 

item.sprite = Sprite.load("Items/cable.png", 1, 13, 13)
item:setTier("uncommon")

registercallback("onGameStart", function()
	local dD = misc.director:getData()
	dD.freedrones = 0
	dD.pickupSilencer = 0
end)

registercallback("onStep", function()
	local dD = misc.director:getData()
	if dD.pickupSilencer > 0
		then dD.pickupSilencer = dD.pickupSilencer - 1
	end
	if dD.pickupSilencer == 1 then
		Sound.find("Pickup"):stop()
	end
end)

local drones = ParentObject.find("droneItems")
registercallback("onStageEntry", function()
	local dD = misc.director:getData()
	dD.freedrones = 0
	for _, p in ipairs(misc.players) do
		dD.freedrones = dD.freedrones + p:countItem(item)
	end
	if dD.freedrones > 0 then
		for _, i in ipairs(drones:findAll()) do
			local iD = i:getData()
			iD.IMADRONE = "i sure am"
			iD.truecost = i:get("cost")
			i:set("cost", 0)
		end
	end
end)

registercallback("onMapObjectActivate", function(self, player)
	local sD = self:getData()
	local dD = misc.director:getData()
	if sD.IMADRONE == "i sure am" and dD.freedrones > 0 then
		ParticleType.find("Spark"):burst("above", self.x, self.y - 6, 20)
		Sound.find("BubbleShield"):play(1.2, 1)
		dD.pickupSilencer = 5
		misc.setGold(misc.getGold() + self:get("cost"))
		dD.freedrones = dD.freedrones -1
		if dD.freedrones <= 0 then
			for _, i in ipairs(drones:findAll()) do
				local iD = i:getData()
				if iD.truecost then
					i:set("cost", iD.truecost)
				end
				iD.truecost = nil
			end
			dD.freedrones = 0
		end
	end
end)

item:addCallback("pickup", function(player)
	local pD = player:getData()
	local dD = misc.director:getData()
	dD.freedrones = dD.freedrones + 1
	for _, i in ipairs(drones:findAll()) do
		local iD = i:getData()
		if not iD.truecost then
			iD.IMADRONE = "i sure am"
			iD.truecost = i:get("cost")
			i:set("cost", 0)
		end
	end
end)

item:setLog{
    group = "uncommon_locked",
    description = "Purchase one drone &g&for free&!& per stage.",
    priority = "&g&Priority&!&",
    destination = "18a Grenthik Highrise,\nNeo-Neo York,\nYun Star A",
    date = "5/20/2056",
    story = "Look, we both know what they're for. A car breaks down? I got you. Fridge breaks down? Unorthodox, but I got you. A top-of-the-line multitool assistance droid breaks down? Well, clearly I have you. But this one's not on the record, got it?"
}

local ach = Achievement.new("cableitem")
ach.requirement = 1
ach.deathReset = true
ach.description = "Repair 6 re-broken drones in one run."
ach:assignUnlockable(item)

registercallback("onPlayerInit", function(player)
	local pD = player:getData()
	pD.achCable = 0
end)

registercallback("onGameStart", function()
	local dD = misc.director:getData()
	dD.checkedDrones = {}
end)

local dronesReal = ParentObject.find("drones")
registercallback("onStep", function(self)
	local dD = misc.director:getData()
	for _, d in ipairs(dronesReal:findAll()) do
		local me = 0
		for dID, c in pairs(dD.checkedDrones) do
			if dID == d.id then
				me = me + 1
			end
		end
		if me == 0 then
			if d:get("value") > 40 then
				local player = Object.findInstance(d:get("master"))
				if player:getObject() == Object.find("p") then
					local pD = player:getData()
					pD.achCable = pD.achCable + 1
					if pD.achCable == 6 then
						ach:increment(1)
					end
				end
			end
		end
		dD.checkedDrones[d.id] = "checked"
	end
end)