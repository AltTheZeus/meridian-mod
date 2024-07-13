local elite = EliteType.new("sorrow")
local sprPal = Sprite.load("Elites/sorrowPal", 1, 0, 0)
local ID = elite.ID
local bID = EliteType.find("blessed").ID

elite.displayName = "Sorrowful"
elite.color = Color.fromRGB(87, 70, 168)
elite.palette = sprPal

for _, i in ipairs(MonsterCard.findAll("vanilla")) do
	i.eliteTypes:add(elite)
end

registercallback("postLoad", function()
for _, m in ipairs(modloader.getMods()) do
	for _, i in ipairs(MonsterCard.findAll(m)) do
		i.eliteTypes:add(elite)
	end
end
end)

local enemies = ParentObject.find("enemies")
local shat1 = Buff.find("sunder1", "vanilla")

function CheckValid(anInstance)
	return anInstance and anInstance:isValid()
end

registercallback("onDamage", function(target, damage, source)
	if not CheckValid(source) then return end
	if isa(source, "Instance") and (source:getObject() == Object.find("ChainLightning") or source:getObject() == Object.find("MushDust") or source:getObject() == Object.find("FireTrail")) then return end
	if target:isValid() and isa(target, "PlayerInstance") then
		if source:get("elite_type") == ID or ((source:get("parent") and CheckValid(Object.findInstance(source:get("parent"))))) then
			if source:get("elite_type") == ID or Object.findInstance(source:get("parent")):get("elite_type") == ID or source:getParent():get("elite_type") == ID then
				target:applyBuff(shat1, 120)
			end
		end
	end
	if not CheckValid(source) then return end
	if isa(source, "Instance") and (source:getObject() == Object.find("ChainLightning") or source:getObject() == Object.find("MushDust") or source:getObject() == Object.find("FireTrail")) then return end
	if target:isValid() and isa(target, "PlayerInstance") then
		if source:get("elite_type") == bID or ((source:get("parent") and CheckValid(Object.findInstance(source:get("parent"))))) then
			if source:get("elite_type") == bID or Object.findInstance(source:get("parent")):get("elite_type") == bID or source:getParent():get("elite_type") == bID then
				target:applyBuff(shat1, 120)
			end
		end
	end
end)

registercallback("preHit", function(damager, hit)
	if Difficulty.getActive().forceHardElites == true or misc.director:get("stages_passed") >= 2 then
		if hit:isValid() and (hit:get("elite_type") == ID or hit:get("elite_type") == bID) then
			if damager:get("damage") > math.round(hit:get("maxhp") * 0.05) then
				damager:set("damage", math.round(hit:get("maxhp") * 0.05))
				damager:set("damage_fake", math.round(hit:get("maxhp") * 0.05))
			end
		end
	end
end)