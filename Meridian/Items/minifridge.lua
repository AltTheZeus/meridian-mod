local item = Item.new("MiniFridge")

item.pickupText = "Freeze the enemy that hits you." 
item.displayName = "Mini Fridge"

item.sprite = Sprite.load("Items/minifridge.png", 1, 15, 15)
item:setTier("uncommon")

local freezeBuff = Buff.find("slow2")

local iceParticles = {
	ParticleType.find("snowballEf1", "meridian"),
	ParticleType.find("snowballEf2", "meridian"),
	ParticleType.find("snowballEf3", "meridian"),
	ParticleType.find("snowballEf4", "meridian"),
	ParticleType.find("snowballEf5", "meridian")
}

--[[callback.register("onDamage", function(target, damage, source)
	if target and target:isValid() and isa(target, "PlayerInstance") then 
		local it = target:countItem(item)
		local parent
		if source and source:isValid() then 
			if isa(source, "ActorInstance") or isa(source, "PlayerInstance") then 
				parent = source
			else
				parent = source:getParent()
			end
		end
		if parent and it > 0 then 
			if not parent:hasBuff(freezeBuff) then 
				parent:applyBuff(freezeBuff, 45 + 45 * it)
			end
		end
	end
end)]]

local minifridgeEfObject = Object.new("MinifridgeEfObject")
local r = 30
minifridgeEfObject:addCallback("create", function(self)
	local selfData = self:getData()
	
	selfData.life = 90
	self.alpha = 0 
end)
minifridgeEfObject:addCallback("step", function(self)
	local selfData = self:getData()
	
	local angle = math.random(0, 360)
	if selfData.life > 15 and selfData.life % 3 == 0 then 
		local xx = self.x + math.cos(math.rad(angle)) * r 
		local yy = self.y - math.sin(math.rad(angle)) * r
		iceParticles[math.random(1, 5)]:burst("middle", xx, yy, 1)
	end
	selfData.life = selfData.life - 1
	if selfData.life <= 0 then 
		self:destroy()
	end
end)
minifridgeEfObject:addCallback("draw", function(self)
	local selfData = self:getData()
	
	graphics.color(Color.fromHex(0x22F4EE))
	graphics.alpha(selfData.life / 90)
	graphics.circle(self.x, self.y, r, true)
	graphics.alpha(selfData.life / 180)
	graphics.circle(self.x, self.y, r)
end)

registercallback("onDamage", function(target, damage, source)
    if source == target then return end
    if not CheckValid(source) then return end
    if isa(source, "Instance") and (source:getObject() == Object.find("ChainLightning") or source:getObject() == Object.find("MushDust") or source:getObject() == Object.find("FireTrail") or source:getObject() == Object.find("DoT")) then return end
    if target:isValid() and isa(target, "PlayerInstance") and not target:getData().minifridgeCooldown then
		local it = target:countItem(item)
        if it > 0 then
			target:getData().minifridgeCooldown = 120
			local bullet = misc.fireExplosion(target.x, target.y, r/19, r/4, target:get("damage") / 2, target:get("team")) -- replace with misc.fireExplosion
			bullet:getData().minifridgeBullet = true 
			local vfx = minifridgeEfObject:create(target.x, target.y)
        end
    end
end)

callback.register("onPlayerStep", function(player)
	local playerData = player:getData()
	if playerData.minifridgeCooldown then 
		playerData.minifridgeCooldown = playerData.minifridgeCooldown - 1
		if playerData.minifridgeCooldown <= 0 then 
			playerData.minifridgeCooldown = nil
		end
	end
end)

callback.register("preHit", function(damager, hit)
	if hit and hit:isValid() and damager and damager:getData().minifridgeBullet then 
		hit:applyBuff(freezeBuff, 90)
	end
end)

item:setLog{
    group = "uncommon",
    description = "Freeze the enemy that hits you.",
    priority = "&w&Standard&!&",
    destination = "Stepped Terraces,\n3rd Colony,\nMars",
    date = "8/12/2056",
    story = "."
}