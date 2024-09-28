local item = Item("Misshapen Flesh")
item.color = "y"
local enemies = ParentObject.find("enemies")

item.pickupText = "Deal extra damage to enemies in close proximity." 

item.sprite = Sprite.load("Items/misshapenflesh.png", 1, 15, 15)
if modloader.checkMod("Starstorm") then
	ItemPool.find("legendary", "Starstorm"):add(item)
end

registercallback("onGameStart", function()
	local dD = misc.director:getData()
	dD.fleshTargs = {}
end)

registercallback("onFireSetProcs", function(damager, parent)
	if parent:getObject() == Object.find("p") and parent:countItem(item) > 0 and math.random(100) <= 20 then
		damager:getData().fleshy = 1
	end
end)

registercallback("onHit", function(damager, hit, x, y)
	if damager:getData().fleshy == 1 then
		local tracker = 0
		for _, i in ipairs(enemies:findAll()) do
			if i ~= hit and hit:collidesWith(i, hit.x, hit.y) and i:get("team") ~= "player" then
				tracker = 1
			end
		end
		if tracker == 1 then
			if hit:getData().fleshTimer == 0 or not hit:getData().fleshTimer then
				hit:getData().fleshTimer = 31
				hit:getData().fleshOwner = damager:get("parent")
			end
		end
	end
end)

registercallback("onStep", function()
	local dD = misc.director:getData()
	for _, i in ipairs(enemies:findAll()) do
		local iD = i:getData()
		if iD.fleshTimer and iD.fleshTimer > 0 then
			iD.fleshTimer = iD.fleshTimer - 1
		end
		if iD.fleshTimer == 1 then
			local blast = Object.findInstance(iD.fleshOwner):fireBullet(i.x, i.y, 0, 1, Object.findInstance(iD.fleshOwner):countItem(item) * 0.1, nil, DAMAGER_NO_PROC, DAMAGER_NO_RECALCULATE)
			blast:getAccessor().specific_target = i.id
			dD.fleshTargs[i] = blast:get("damage")
		end
	end
	if misc.getOption("video.show_damage") then
	for o, num in pairs(dD.fleshTargs) do
--		Object.find("EfDamage"):findNearest(o.x, o.y):destroy()
		local n = Object.find("EfDamage"):create(o.x, o.y)
		n:set("damage", num)
		n:set("textColor", 6309839)
--		n:set("damage_hue", 6309839)
--		n.blendColor = Color.fromRGB(96, 71, 207)
		dD.fleshTargs[o] = nil
		local c = Object.find("EfCircle"):create(o.x, o.y)
		c.blendColor = Color.fromRGB(96, 71, 207)
		c:set("radius", 14)
		c:set("rate", -3)
		local c2 = Object.find("EfCircle"):create(o.x, o.y)
		c2.blendColor = Color.BLACK
		c2:set("radius", 12)
		c2:set("rate", -3.2)
	end
	end
end)

item:setLog{
    group = "boss",
    description = "For every skill on cooldown, reduce skill cooldowns by &y&7%&!&.",
    priority = "&b&Field-Found&!&",
    destination = "8009,\nImperceptible Fields,\nUnknown",
    date = "--",
    story = "Through every environment this beast tailed me. Always moving, always chasing.\n\nIt's said humans were as prevalent as we were because of our persistence hunting style.\n\nThis tooth is evidence that we can outhunt the hunter itself."
}