local elite = EliteType.new("blessed")
local sprPal = Sprite.load("Elites/blessedPal", 1, 0, 0)
local ID = elite.ID
local halo = Sprite.load("Elites/blessedEf", 1, 5, 8)

elite.displayName = "Blessed"
elite.color = Color.fromRGB(255, 237, 187)
elite.palette = sprPal

registercallback("onGameStart", function()
	local dD = misc.director:getData()
	dD.blessed1 = 0
	dD.blessed2 = 0
	dD.blessed3 = 0
end)

registercallback("onStageEntry", function()
local dD = misc.director:getData()
if misc.director:get("stages_passed") >= 5 and dD.blessed1 == 0 then
	for _, i in ipairs(MonsterCard.findAll("vanilla")) do
		if i.isBoss == false then
			i.eliteTypes:add(elite)
		end
	end
	for _, m in ipairs(modloader.getMods()) do
		for _, i in ipairs(MonsterCard.findAll(m)) do
			if i.isBoss == false then
				i.eliteTypes:add(elite)
			end
		end
	end
	dD.blessed1 = 1
elseif misc.director:get("stages_passed") >= 15 and dD.blessed2 == 0 then
	for _, i in ipairs(MonsterCard.findAll("vanilla")) do
		i.eliteTypes:add(elite)
	end
	for _, m in ipairs(modloader.getMods()) do
		for _, i in ipairs(MonsterCard.findAll(m)) do
			i.eliteTypes:add(elite)
		end
	end
	dD.blessed2 = 1
end
end)

registercallback("onGameStart", function()
	local dD = misc.director:getData()
	for _, i in ipairs(MonsterCard.findAll("vanilla")) do
		if i.isBoss == false then
			i.eliteTypes:remove(elite)
		end
	end
	for _, m in ipairs(modloader.getMods()) do
		for _, i in ipairs(MonsterCard.findAll(m)) do
			if i.isBoss == false then
				i.eliteTypes:remove(elite)
			end
		end
	end
end)


local enemies = ParentObject.find("enemies")

registercallback("onEliteInit", function(actor)
	local aD = actor:getData()
	if actor:get("elite_type") == ID then
		actor:set("maxhp", actor:get("maxhp") * 2.2)
		actor:set("hp", actor:get("maxhp"))
		actor:set("damage", actor:get("damage") * 1.6)
		actor:set("show_boss_health", 1)
		actor:set("name2", "Divine Creation")
		local blesseddudes = 0
		for _, i in ipairs(enemies:findMatching("elite_type", ID)) do
			blesseddudes = blesseddudes + 1
		end
		if blesseddudes > 1 then
			local replacement = actor:getObject():create(actor.x, actor.y)
			replacement:makeElite()
			actor:delete()
		end
	end
end, -10)

registercallback("onDraw", function()
	for _, i in ipairs(enemies:findMatching("elite_type", ID)) do
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
end)