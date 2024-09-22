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
	dD.loopCount = 0
	dD.blessedLimit = 1
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
		if m == "Starstorm" then
			if i ~= MonsterCard.find("Squall Elver") then
				i.eliteTypes:add(elite)
			end
		else
			i.eliteTypes:add(elite)
		end
			end
		end
	end
	dD.blessed1 = 1
elseif misc.director:get("stages_passed") >= 15 and dD.blessed2 == 0 then
	for _, i in ipairs(MonsterCard.findAll("vanilla")) do
		if i ~= MonsterCard.find("Magma Worm") then
			i.eliteTypes:add(elite)
		end
	end
	for _, m in ipairs(modloader.getMods()) do
		for _, i in ipairs(MonsterCard.findAll(m)) do
		if m == "Starstorm" then
			if i ~= MonsterCard.find("Squall Elver") then
				i.eliteTypes:add(elite)
			end
		else
			i.eliteTypes:add(elite)
		end
		end
	end
	dD.blessed2 = 1
end
for _, stage in ipairs(Stage.progression[1]:toTable()) do
	if stage == Stage.getCurrentStage() then
		dD.loopCount = dD.loopCount + 1
		dD.blessedLimit = dD.loopCount - 1
	end
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
	local dD = misc.director:getData()
	if actor:get("elite_type") == ID then
		actor:set("maxhp", actor:get("maxhp") * 3)
		actor:set("hp", actor:get("maxhp"))
		actor:set("damage", actor:get("damage") * 1.8)
		actor:set("exp_worth", actor:get("exp_worth") * 2.5)
		actor:set("show_boss_health", 1)
		actor:set("name2", "Divine Creation")
		local blesseddudes = 0
		for _, i in ipairs(enemies:findMatching("elite_type", ID)) do
			blesseddudes = blesseddudes + 1
		end
		if blesseddudes > dD.blessedLimit then
			local replacement = actor:getObject():create(actor.x, actor.y)
			replacement:makeElite()
			actor:delete()
		end
		aD.eliteVar = 1
	end
end, -10)

registercallback("onDraw", function()
	for _, i in ipairs(enemies:findMatching("elite_type", ID)) do
		if i:getObject() ~= Object.find("Beta Construct Head") then
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
end)
