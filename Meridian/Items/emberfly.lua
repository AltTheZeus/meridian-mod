local item = Item("Emberfly Pin")

item.pickupText = "Rain fire from the skies." 

item.sprite = Sprite.load("Items/emberfly.png", 1, 15, 15)
item:setTier("rare")

local rain = ParticleType.new("Fire Rain")
local rainSpr = Sprite.load("Items/emberflyEf1.png", 4, 0, 2)
rain:sprite(rainSpr, false, false, true)
rain:alpha(1)
rain:additive(true)
rain:size(1, 1, 0, 0)
rain:angle(-90, -90, 0, 0, true)
rain:speed(2.5, 2.5, 0, 0)
rain:direction(245, 245, 0, 0)
rain:gravity(0.01, 245)
rain:life(60, 60)

local cloud = Object.new("Embercloud")
cloud.sprite = Sprite.load("Items/emberflyEf2.png", 1, 24, 8)

cloud:addCallback("create", function(self)
	local sD = self:getData()
	sD.timer = 0
	sD.life = 0
end)

cloud:addCallback("step", function(self)
	local sD = self:getData()
	if not sD.owner then self:destroy() return end
	if math.random(100) <= 75 then
		rain:burst("below", self.x - math.random(2, 16), self.y, 1)
	end
	if math.random(100) <= 75 then
		rain:burst("below", self.x + 1 + math.random(-8, 8), self.y, 1)
	end
	if math.random(100) <= 75 then
		rain:burst("below", self.x + 2 + math.random(2, 16), self.y, 1)
	end
	sD.timer = sD.timer + 1
	if sD.timer >= 30 then
		sD.owner:fireExplosion(self.x - 8, self.y + 20, 24/19, 20/4, 0.5 * sD.mult, nil, nil, DAMAGER_NO_PROC, DAMAGER_NO_RECALC)
		sD.timer = 0
	end
	sD.life = sD.life + 1
	if sD.life >= 5 * 60 then
		self:destroy()
	end
end)

local emberflyPacket
emberflyPacket = net.Packet("Emberfly Pin Packet", function(sender, netPlayer, x, y)
	local player = netPlayer:resolve()
	local cD = cloud:create(x, y)
	cD.owner = player
	cD.mult = player:countItem(item)
end)

registercallback("onHit", function(damager, hit, x, y)
	if net.host and hit:getObject() == Object.find("p") and hit:countItem(item) > 0 and math.random(100) <= 20 then
		local cD = cloud:create(x + 8, y - 40):getData()
		cD.owner = hit
		cD.mult = hit:countItem(item)
		
		if net.online then
			emberflyPacket:sendAsHost(net.ALL, nil, hit:getNetIdentity(), cD.x, cD.y)
		end
	end
end)

item:setLog{
    group = "rare",
    description = "20% chance on being hit to spawn an &y&Embercloud&!& which deals &y&100% damage per second&!&.",
    priority = "&r&High Priority&!&",
    destination = "The Cave In The Hills,\nContrue\nIron-Ef",
    date = "4/30/2056",
    story = "I thought this was a neat knickknack you might appreciate... It's got such a unique luster! I'm not even sure what material it is, get back to me on that I'm dying to know. And let me know if you have any issues or complaints; Free goods doesn't mean service-free!"
}
