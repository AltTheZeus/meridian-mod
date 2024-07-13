--TODO: stop enemies spawning in the ground/walls

local elite = EliteType.new("summon")
local sprPal = Sprite.load("Elites/evokePal", 1, 0, 0)
local ID = elite.ID
local bID = EliteType.find("blessed").ID

elite.displayName = "Beckoning"
elite.color = Color.fromRGB(87, 70, 168)
elite.palette = sprPal

for _, i in ipairs(MonsterCard.findAll("vanilla")) do
	if i.isBoss == false and i.type == "classic" then
		i.eliteTypes:add(elite)
	end
end

registercallback("postLoad", function()
for _, m in ipairs(modloader.getMods()) do
	for _, i in ipairs(MonsterCard.findAll(m)) do
		if i.isBoss == false and i.type == "classic" then
			i.eliteTypes:add(elite)
		end
	end
end
end)

local babies = {}
local normals = {}

registercallback("postLoad", function()
	local everything = MonsterCard.findAll()
	for _, m in ipairs(everything) do
		if m.isBoss == false then
			if m.cost < 500 then
				normals[m] = m
			end
		end
	end
end)

registercallback("onEliteInit", function(actor)
	local aD = actor:getData()
	if actor:get("elite_type") == ID or actor:get("elite_type") == bID then
		aD.pointTimer = 0
		aD.points = 0
		aD.card = table.random(normals)
		aD.timer = aD.card.cost
		aD.minionCount = 0
	end
end)

local enemies = ParentObject.find("enemies")

registercallback("onStep", function()
	for _, i in ipairs(enemies:findMatching("elite_type", ID)) do
		local aD = i:getData()
		aD.pointTimer = aD.pointTimer + 1
		if aD.pointTimer >= 60 then
			aD.points = aD.points + 1 + misc.director:get("stages_passed")
			aD.pointTimer = 0
		end
		if aD.points >= aD.timer and aD.minionCount < 3 then
			aD.points = aD.points - aD.timer
			local height = aD.card.object.sprite.height
			height = height + i.sprite.yorigin
			local newGuy = aD.card.object:create(i.x, i.y - height)
			local nD = newGuy:getData()
			nD.evoker = i.id
			aD.minionCount = aD.minionCount + 1
			if Artifact.find("Honor").active == true then
				local eType
				local types = aD.card.eliteTypes:toTable()
				repeat
					eType = table.random(types)
				until eType ~= elite and eType ~= EliteType.find("blessed")
				newGuy:makeElite(eType)
			end
			aD.card = table.random(normals)
			aD.timer = aD.card.cost
		end
	end
	for _, i in ipairs(enemies:findMatching("elite_type", bID)) do
		local aD = i:getData()
		aD.pointTimer = aD.pointTimer + 1
		if aD.pointTimer >= 60 then
			aD.points = aD.points + 1 + misc.director:get("stages_passed")
			aD.pointTimer = 0
		end
		if aD.points >= aD.timer and aD.minionCount < 4 then
			aD.points = aD.points - aD.timer
			local height = aD.card.object.sprite.height
			height = height + i.sprite.yorigin
			local newGuy = aD.card.object:create(i.x, i.y - height)
			local nD = newGuy:getData()
			nD.evoker = i.id
			aD.minionCount = aD.minionCount + 1
			if Artifact.find("Honor").active == true or math.random(1,10) == 1 then
				local eType
				local types = aD.card.eliteTypes:toTable()
				repeat
					eType = table.random(types)
				until eType ~= elite and eType ~= EliteType.find("blessed")
				newGuy:makeElite(eType)
			end
			aD.card = table.random(normals)
			aD.timer = aD.card.cost
		end
	end
end)

registercallback("onNPCDeath", function(npc)
	local nD = npc:getData()
	if nD.evoker ~= nil and Object.findInstance(nD.evoker) and Object.findInstance(nD.evoker):isValid() then
		local eD = Object.findInstance(nD.evoker):getData()
		eD.minionCount = eD.minionCount - 1
	end
end)