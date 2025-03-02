local blessed = EliteType.find("blessed")
local rippling = EliteType.find("bubble")
local erupt = EliteType.find("erupt")
local molding = EliteType.find("summon")
local forsaken = EliteType.find("forsaken")
local sorrow = EliteType.find("sorrow")

------- BLESSED :D
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
			i.eliteTypes:add(blessed)
		end
	end
	for _, m in ipairs(modloader.getMods()) do
		for _, i in ipairs(MonsterCard.findAll(m)) do
			if i.isBoss == false then
		if m == "Starstorm" then
			if i ~= MonsterCard.find("Squall Elver") then
				i.eliteTypes:add(blessed)
			end
		else
			i.eliteTypes:add(blessed)
		end
			end
		end
	end
	dD.blessed1 = 1
elseif misc.director:get("stages_passed") >= 15 and dD.blessed2 == 0 then
	for _, i in ipairs(MonsterCard.findAll("vanilla")) do
		if i ~= MonsterCard.find("Magma Worm") then
			i.eliteTypes:add(blessed)
		end
	end
	for _, m in ipairs(modloader.getMods()) do
		for _, i in ipairs(MonsterCard.findAll(m)) do
		if m == "Starstorm" then
			if i ~= MonsterCard.find("Squall Elver") then
				i.eliteTypes:add(blessed)
			end
		else
			i.eliteTypes:add(blessed)
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
	for _, i in ipairs(MonsterCard.findAll()) do
		i.eliteTypes:remove(blessed)
	end
end)

------- Standard Elites
registercallback("onGameStart", function()
	for _, i in ipairs(MonsterCard.findAll()) do
		i.eliteTypes:remove(rippling)
		i.eliteTypes:remove(erupt)
		i.eliteTypes:remove(molding)
		i.eliteTypes:remove(forsaken)
		i.eliteTypes:remove(sorrow)
	end
	for _, i in ipairs(MonsterCard.findAll("vanilla")) do
		if i.type == "classic" then
			if i.isBoss == false then
				i.eliteTypes:add(molding)
			end
			i.eliteTypes:add(erupt)
		end
		if i ~= MonsterCard.find("Magma Worm", "vanilla") then
			i.eliteTypes:add(rippling)
			i.eliteTypes:add(sorrow)
		end
		i.eliteTypes:add(forsaken)
	end
	for _, m in ipairs(modloader.getMods()) do
		for _, i in ipairs(MonsterCard.findAll(m)) do
			if i.type == "classic" then
				if i.isBoss == false then
					i.eliteTypes:add(molding)
				end
				i.eliteTypes:add(erupt)
			end
			if i ~= MonsterCard.find("Squall Elver") then
				i.eliteTypes:add(forsaken)
			end
			i.eliteTypes:add(rippling)
			i.eliteTypes:add(sorrow)
		end
	end
end)

--Starstorm-style Scaling
if modloader.checkMod("Starstorm") then
	registercallback("onGameStart", function()
		misc.director:getData().meridianElite1 = false
		misc.director:getData().meridianElite2 = false
	end)
	registercallback("onStep", function()
		local dD = misc.director:getData()
		if dD.meridianElite1 == false and misc.director:get("enemy_buff") > 13 then
			for _, i in ipairs(MonsterCard.findAll()) do
				i.eliteTypes:remove(rippling)
			end
			dD.meridianElite1 = true
		end
		if dD.meridianElite2 == false and misc.director:get("enemy_buff") > 16 then
			for _, i in ipairs(MonsterCard.findAll()) do
				i.eliteTypes:remove(erupt)
				i.eliteTypes:remove(molding)
				i.eliteTypes:remove(forsaken)
				i.eliteTypes:remove(sorrow)
			end
			dD.meridianElite1 = false
		end
	end)
end

--Blighted fix...! Courtesy of me (tryagain), myself (also tryagain), and I (you'll never guess)!
local newBlightedPacket
newBlightedPacket = net.Packet("Blighted Spawn Packet", function(sender, child, blight_type, value, xscale, mId, x, y)
	local newBlighted = child:create(x, y)
	newBlighted.visible = false
	newBlighted.xscale = xscale
	newBlighted:set("point_value", value)
	newBlighted:makeBlighted(blight_type)
	newBlighted:set("m_id", mId)
end)

local blightedSpawn = Object.new("BlightedSpawn")
local backupSprite = Sprite.find("GolemSpawn", "Vanilla")
local backupObject = Object.find("Golem", "Vanilla")
blightedSpawn:addCallback("create", function(self)
	self.spriteSpeed = 0.2
	self.sprite = backupSprite
	self:getData().frame = 1
	self:getData().child = backupObject
	self:getData().blight_type = 1
	self:getData().point_value = 0
	self.blendColor = Color.BLACK
end)
blightedSpawn:addCallback("step", function(self)
	 self:getData().frame = self:getData().frame + self.spriteSpeed
	 if self:getData().frame > self.sprite.frames + 1 then
		if net.host then
			local newBlighted = self:getData().child:create(self.x, self.y)
			newBlighted.visible = false
			newBlighted.xscale = self.xscale
			newBlighted:set("point_value", self:getData().point_value)
			newBlighted:makeBlighted(self:getData().blight_type)
			if net.online then
				local mId = setID(self)
				newBlightedPacket:sendAsHost(net.ALL, nil, self:getData().child, self:getData().blight_type, self:getData().point_value, self.xscale, mId, self.x, self.y)
			end
		end
		self:destroy()
	 end
end)

local objSpawn = Object.find("Spawn", "Vanilla")
callback.register("onStep", function()
	for _, blighted in ipairs(obj.Spawn:findMatching("prefix_type", 2)) do
		if not blighted:getData().checked then
			local child = Object.fromID(blighted:get("child"))
			if child:getOrigin() ~= "Vanilla" then
				local newBlighted = blightedSpawn:create(blighted.x, blighted.y)
				newBlighted.sprite = blighted.sprite
				newBlighted.xscale = blighted.xscale
				newBlighted:getData().child = child
				newBlighted:getData().point_value = blighted:get("point_value")
				newBlighted:getData().blight_type = blighted:get("blight_type")
				if blighted:get("sound_spawn") and onScreenPos(blighted.x, blighted.y) then
					Sound.fromID(blighted:get("sound_spawn")):play()
				end
				blighted:destroy()
			end
			blighted:getData().checked = true
		end
	end
end)
