local item = Item.new("MiniFridge")

item.pickupText = "Freeze the enemy that hits you." 
item.displayName = "Mini Fridge"

item.sprite = Sprite.load("Items/minifridge.png", 1, 15, 15)
item:setTier("uncommon")

local freezeBuff = Buff.find("slow2")

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

registercallback("onDamage", function(target, damage, source)
    if source == target then return end
    if not CheckValid(source) then return end
    if isa(source, "Instance") and (source:getObject() == Object.find("ChainLightning") or source:getObject() == Object.find("MushDust") or source:getObject() == Object.find("FireTrail") or source:getObject() == Object.find("DoT")) then return end
    if target:isValid() and isa(target, "PlayerInstance") then
		local it = target:countItem(item)
        if it > 0 and source:get("parent") then
			local parent = Object.findInstance(source:get("parent"))
			if CheckValid(parent) and not parent:hasBuff(freezeBuff) then 
				parent:applyBuff(freezeBuff, 45 + 45 * it)
			end
        end
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