local item = Item("Xenial Opal")

item.pickupText = "Gain speed the longer you've been on a stage." 

item.sprite = Sprite.load("Items/opal.png", 1, 15, 15)
item:setTier("common")

local opalSound = Sound.load("Items/opalEf")

local opalEf = Sprite.load("Items/opalEf.png", 14, 2, 2)
local opalEfP = ParticleType.new("Opal Particle")
opalEfP:sprite(opalEf, false, false, true)
opalEfP:alpha(0.7, 0)
opalEfP:additive(true)
opalEfP:scale(1, 1)
opalEfP:size(0.5, 1, -0.02, 0)
opalEfP:angle(0, 0, 0, 0, false)
opalEfP:speed(0, 0, 0, 0)
opalEfP:direction(270, 270, 0, 0)
opalEfP:gravity(0.01, 270)
opalEfP:life(40, 80)

registercallback("onPlayerInit", function(player)
	local sD = player:getData()
	sD.opalSpeed = 0
	sD.opalTimer = 0
	sD.opalEfTimer = 0
end)

registercallback("onStageEntry", function()
	for _, i in ipairs(misc.players) do
		local sA = i:getAccessor()
		local sD = i:getData()
		sA.pHmax = sA.pHmax - sD.opalSpeed
		sD.opalSpeed = 0
		sD.opalTimer = 0
		sD.opalEfTimer = 0
	end
end)

registercallback("onPlayerStep", function(self)
	local sD = self:getData()
	if self:countItem(item) >= 1 then
		if math.ceil(sD.opalSpeed) < 4 * self:countItem(item) then --cap feels weird. it takes like 30 minutes to reach this cap with 1 opal
			sD.opalTimer = sD.opalTimer + 1
			if sD.opalTimer >= 60 * 60 then
				sD.opalSpeed = sD.opalSpeed + (0.052 * self:countItem(item)) + 0.052
				self:set("pHmax", self:get("pHmax") + (0.052 * self:countItem(item)) + 0.052)
				opalSound:play(1.4, 0.7)
				sD.opalTimer = 0
			end
		end
--		print(math.ceil(sD.opalSpeed))
		if sD.opalSpeed > 0 and (self:get("pHspeed") ~= 0 or self:get("pVspeed") ~= 0) then
			sD.opalEfTimer = sD.opalEfTimer + 1
			if sD.opalEfTimer >= 10/math.ceil(sD.opalSpeed) then
				for i = 1, math.ceil(sD.opalSpeed) do
					opalEfP:burst("middle", self.x - (math.random(0, 6 * math.ceil(sD.opalSpeed)) * self.xscale), self.y + math.random(-3, 5), 1)
				end
				sD.opalEfTimer = 0
			end
		end
	end
end)

item:setLog{
    group = "common",
    description = "Gain &b&8% speed&!& every minute you spend on a stage.",
    priority = "&w&Standard&!&",
    destination = "The Great Furnace,\nDying Star,\nDeep Space",
    date = "--",
    story = "Regrettably, I've started to feel excitement when I see a Bison. Though they are tough to fell, I can utilize almost every part of their corpse. Their meat reminds me of home. Their bones are sturdy and well-used in my tools. Their metallic growths... exhibit some strange properties. I'm sure they're valuable, if nothing else."
}