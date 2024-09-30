local elite = EliteType.new("blessed")
local sprPal = Sprite.load("Elites/blessedPal", 1, 0, 0)
local ID = elite.ID
local halo = Sprite.load("Elites/blessedEf", 1, 5, 8)

elite.displayName = "Blessed"
elite.color = Color.fromRGB(255, 237, 187)
elite.palette = sprPal

local enemies = ParentObject.find("enemies")

registercallback("onEliteInit", function(actor)
	local aD = actor:getData()
	local dD = misc.director:getData()
	if actor:get("elite_type") == ID then
		actor:set("maxhp", actor:get("maxhp") * 3)
		actor:set("hp", actor:get("maxhp"))
		actor:set("damage", actor:get("damage") * 1.8)
		actor:set("exp_worth", actor:get("exp_worth") * 2.5)
		actor:set("show_boss_health", 1)
		actor:set("name2", "Divine Creation")
		aD.eliteVar = 1
		local checks = enemies:findMatching("elite_type", ID)
		for a, i in pairs(checks) do
			if not i:getData().eliteVar then
				table.remove(checks, a)
			end
		end
		if #checks > dD.blessedLimit then
			local replacement = actor:getObject():create(actor.x, actor.y)
			replacement:makeElite()
			actor:delete()
		end
--		print(checks)
	end
end, -10)

registercallback("onDraw", function()
	for _, i in ipairs(enemies:findMatching("elite_type", ID)) do
		if i:getObject() ~= Object.find("Beta Construct Head") and i:getObject() ~= Object.find("Beta Construct2") then
			local iD = i:getData()
			local idle = i:getAnimation("idle")
			graphics.drawImage{
			image = halo,
			x = i.x,
			y = i.y - idle.yorigin - 5,--i.y - 10,
			xscale = i.xscale,
			alpha = 1
			}
		end
	end
	for _, i in ipairs(enemies:findMatching("elite_type", ID)) do
		if i:getObject() == Object.find("Beta Construct Head") then
			local iD = i:getData()
			local idle = i:getAnimation("idle")
			local haloDistance = 12
			local haloPosition = {
				x = i.x - math.sin(math.rad(i.angle)) * haloDistance,
				y = i.y - math.cos(math.rad(i.angle)) * haloDistance,
			}
			graphics.drawImage{
			image = halo,
			x = haloPosition.x,
			y = haloPosition.y,
			xscale = i.xscale,
			angle = i.angle,
			alpha = 1
			}
		end
	end
end)
