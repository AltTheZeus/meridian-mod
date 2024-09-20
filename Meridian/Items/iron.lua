local item = Item("Worn Iron")

item.pickupText = "Chance to ground enemies." 

item.sprite = Sprite.load("Items/iron.png", 1, 15, 15)
local itemEf = Sprite.load("Items/ironEf.png", 1, 0, 0)
local buffSpr = Sprite.load("Items/ironBuff.png", 1, 0, 0)
item:setTier("uncommon")

local shackled = Buff.new("ball and chain")
shackled.sprite = buffSpr
shackled:addCallback("start", function(victim)
	local vD = victim:getData()
	vD.jumpStorage = victim:get("can_jump")
	victim:set("can_jump", 0)
	if victim:get("direction") ~= (0 or 1) then
		vD.ironSpeedStorage = victim:get("pHmax")
		vD.ironFallStorage = victim:get("pVmax")
		victim:set("pHmax", 0)
		victim:set("pVmax", 0)
	end
end)

shackled:addCallback("step", function(victim)
	local vD = victim:getData()
	if victim:get("direction") ~= (0 or 1) then
		if not victim:collidesMap(victim.x, victim.y + 1) then
			if vD.fakeFall then
				vD.fakeFall = vD.fakeFall + 0.26
				if vD.fakeFall > 15 then vD.fakeFall = 15 end
			else
				vD.fakeFall = 0.26
			end
			victim.y = victim.y + vD.fakeFall
		end
	end
end)

shackled:addCallback("end", function(victim)
	local vD = victim:getData()
	victim:set("can_jump", vD.jumpStorage)
	if victim:get("direction") ~= (0 or 1) then
		victim:set("pHmax", vD.ironSpeedStorage)
		victim:set("pVmax", vD.ironFallStorage)
	end
end)

registercallback("onFireSetProcs", function(damager, parent)
	if parent:getObject() == Object.find("p") and parent:countItem(item) > 0 then
		if math.chance((parent:countItem(item) * 2.5) + 2.5) then
			local dD = damager:getData()
			dD.chainball = "im balls"
		end
	end
end)

registercallback("onHit", function(damager, hit, x, y)
	local dD = damager:getData()
	if dD.chainball then
		if hit:get("show_boss_health") == 0 or (hit:get("show_boss_health") == 1 and hit:get("blight_type") ~= -1) then
			hit:applyBuff(shackled, 3.5 * 60)
		end
	end
end)

local enemies = ParentObject.find("enemies")
registercallback("onDraw", function()
	for _, i in ipairs(enemies:findAll()) do
		local iD = i:getData()
		if i:hasBuff(shackled) then
			graphics.drawImage{itemEf, i.x, i.y + i:getAnimation("idle").yorigin - 5, xscale = (i.xscale * -1)}
		end
	end
end)

item:setLog{
    group = "uncommon_locked",
    description = "5% chance on hit to stop enemies from jumping or flying.",
    priority = "&g&Priority&!&",
    destination = "Great Memorial,\nCanada 2,\nPluto",
    date = "12/9/2056",
    story = "The sample you requested has successfully been analyzed and confirmed as a genuine artifact from the period of the Plutonian convict uprisings of 2000. You have this item leased for 12 months, after which point we will send someone to reclaim it, or re-negotiate further possession.\n\nThank you."
}

local ach = Achievement.new("ironitem")
ach.requirement = 1
ach.deathReset = true
ach.description = "Overwhelm a Lacertian, and kill it while it's stunned."
ach:assignUnlockable(item)

registercallback("onNPCDeath", function(npc)
	if npc:getObject() == Object.find("Lacertian") then
		local lA = npc:getAccessor()
		if lA.state == "stun" then
			ach:increment(1)
		end
	end
end)