local item = Item("Tear Gas")

item.pickupText = "Increase damage against stunned enemies." 

item.sprite = Sprite.load("Items/gas.png", 1, 15, 15)
item:setTier("uncommon")

local star = ParticleType.new("stun star")
local starSpr = Sprite.load("Items/gasEf.png", 1, 2, 2)
star:sprite(starSpr, false, false, false)
star:alpha(1, 0)
star:scale(1, 1)
star:size(1, 1, 0, 0)
star:angle(0, 360, 3, 0, true)
star:speed(3, 2, -0.25, 0)
star:direction(0, 360, 0, 0)
star:gravity(0, 0)
star:life(30, 30)

registercallback("onFireSetProcs", function(damager, parent)
	if parent:getObject() == Object.find("p") then
		if parent:countItem(item) > 0 then
			local dD = damager:getData()
			dD.gassed = parent:countItem(item)
		end
	end
end)

registercallback("preHit", function(damager, hit)
	local dD = damager:getData()
	if dD.gassed and dD.gassed > 0 and hit:get("stunned") == 1 then
		local mult = damager:get("damage") * 0.1
		damager:set("damage", damager:get("damage") + (mult * dD.gassed))
		damager:set("damage_fake", damager:get("damage_fake") + (mult * dD.gassed))
		star:burst("above", hit.x, hit.y, 5)
	end
end)

item:setLog{
    group = "uncommon",
    description = "Increase damage against stunned enemies by &y&10%&!&.",
    priority = "&g&MILITARY&!&",
    destination = "Militia Operations,\n[REDACTED],\nNewcorps",
    date = "[REDACTED]",
    story = "Kick 'em while they're down, I say. Heh."
}