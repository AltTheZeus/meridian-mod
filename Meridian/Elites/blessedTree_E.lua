treeE = Object.base("Enemy", "Auric Tree (evil)")
local treeIdle_E = Sprite.load("Elites/auricIdle_E", 8, 17, 48)
local treeSpawn_E = Sprite.load("Elites/auricSpawn_E", 14, 44, 77)
local treeMask_E = Sprite.load("Elites/auricMask_E", 1, 17, 48)
local treeDeath_E = Sprite.load("Elites/auricDeath_E", 8, 29, 52)
local shing = Sound.find("tree")
local gogobalga = Sound.find("treeDeath")
if not modloader.checkFlag("mn_disable_items") then
	local aspect = Item.find("Gilded Leaf")
end

treeDeadE = Object.new("tree but its DEAD (still evil)")
treeDeadE:addCallback("create", function(self)
	local data = self:getData()
	data.timer = 0
	data.timerActive = 0
	self.sprite = treeDeath_E
	self.spriteSpeed = 0.2
	data.age = 0
end)
treeDeadE:addCallback("step", function(self)
	local iD = self:getData()
	print(self.subimage)
	if iD.timerActive == 0 and self.subimage >= 8 then
		iD.timerActive = 1
	end
	if iD.timerActive == 1 then
		iD.timer = iD.timer + 1
		if iD.timer >= 5 then
			self.spriteSpeed = 0
		end
	end
end)

treeSpawnerE = Object.new("tree spawner (sinister)")
treeSpawnerE:addCallback("create", function(self)
	local data = self:getData()
	data.timer = 0
end)
treeSpawnerE:addCallback("step", function(self)
	local data = self:getData()
	data.timer = data.timer + 1
	if data.timer >= 60 then
		local ad = treeE:create(self.x, self.y):getData()
		ad.isPlayer = 0
		self:destroy()
	end
end)

local leafEF = ParticleType.find("auricLeaf")

treeE:addCallback("create", function(self)
	shing:play()
	local data = self:getData()
	local ac = self:getAccessor()
	data.efTimer = 0
	data.timer = 0
	data.timerActive = 0
	self.sprite = treeSpawn_E
	self.spriteSpeed = 0.2
	ac.pHmax = 0
	ac.can_jump = 0
	ac.name = "Auric Tree"
	ac.maxhp = 300 * Difficulty.getScaling("hp")
	ac.hp = ac.maxhp
	ac.damage = 0
	ac.knockback_cap = 9999999
	ac.team = "enemy"
	ac.exp_worth = 0
	ac.point_value = 0
	ac.state = "idle"
	data.age = 0
	self.mask = treeMask_E
	self:setAnimations{
		idle = treeIdle_E,
		jump = treeIdle_E
	}
	if not self:collidesMap(self.x, self.y) then
		local UHOHcheck = 0
		repeat
			self.y = self.y + 1
			UHOHcheck = UHOHcheck + 1
		until self:collidesMap(self.x, self.y) or UHOHcheck >= 200
		self.y = self.y - 1
	end
	local leafCount = 0
	repeat
		if math.random(1,2) == 1 then
			leafEF:scale(1, 1)
		else
			leafEF:scale(-1, 1)
		end
		local xOffset = math.random(10)
		local yOffset = math.random(4)
		local mult1
		local mult2
		if math.random(1,2) == 1 then mult1 = 1 else mult1 = -1 end
		if math.random(1,2) == 1 then mult2 = 1 else mult2 = -1 end
		leafEF:gravity(0.03, 270)
		leafEF:direction(math.random(220,320), 0, 0, 0)
		leafEF:burst("middle", self.x + (xOffset * mult1), self.y - 21 + (yOffset * mult2), 1)
		leafCount = leafCount + 1
	until leafCount == 8
end)

treeE:addCallback("destroy", function(self)
	local leafCount = 0
	gogobalga:play()
	treeDeadE:create(self.x, self.y)
	if not modloader.checkFlag("mn_disable_items") then
	if math.random(1,4000) == 1 then
		aspect:create(self.x, self.y - 15)
	end
	end
	repeat
		if math.random(1,2) == 1 then
			leafEF:scale(1, 1)
		else
			leafEF:scale(-1, 1)
		end
		local xOffset = math.random(15)
		local yOffset = math.random(8)
		local mult1
		local mult2
		if math.random(1,2) == 1 then mult1 = 1 else mult1 = -1 end
		if math.random(1,2) == 1 then mult2 = 1 else mult2 = -1 end
		leafEF:gravity(0.03, 270)
		leafEF:direction(math.random(220,320), 0, 0, 0)
		leafEF:burst("middle", self.x + (xOffset * mult1), self.y - 21 + (yOffset * mult2), 1)
		leafCount = leafCount + 1
	until leafCount == 20
end)

local circle = Object.find("efCircle")
local enemies = ParentObject.find("enemies")
local treegen = Buff.find("Auric Blessing")
local treeArmor = Buff.find("Auric Distinction")

treeE:addCallback("step", function(self)
	local iD = self:getData()
	if iD.timerActive == 0 and self.sprite == treeSpawn_E and self.subimage >= 14 then
		iD.timerActive = 1
	end
	if iD.timerActive == 1 then
		iD.timer = iD.timer + 1
		if iD.timer >= 5 then
			self.sprite = treeIdle_E
		end
	end
	iD.efTimer = iD.efTimer + 1
	if iD.efTimer >= 90 then
		local eehee = circle:create(self.x - 2, self.y - 5)
		local eD = eehee:getAccessor()
		eD.radius = 65
		eehee.blendColor = Color.fromRGB(255, 237, 187)
		iD.efTimer = 0
		if iD.isPlayer == 0 then
			for _, a in ipairs(ParentObject.find("actors"):findAllEllipse(self.x - 2 - 87, self.y - 5 - 87, self.x - 2 + 87, self.y - 5 + 87)) do
				if a:getObject() ==E tree then
				elseif a:getAccessor().team == "enemy" then
					a:applyBuff(treeArmor, 95)
					a:applyBuff(treegen, 95)
				end
			end
		elseif iD.isPlayer == 1 then
			for _, a in ipairs(ParentObject.find("actors"):findAllEllipse(self.x - 2 - 61, self.y - 5 - 61, self.x - 2 + 61, self.y - 5 + 61)) do
				if a:getObject() == treeE then
				elseif a:getAccessor().team == "player" then
					a:applyBuff(treeArmor, 95)
					a:applyBuff(treegen, 95)
				end
			end
		end
	end
	if not self then
		self:destroy()
	else
		self.xscale = 1
	end
end)

local bID = EliteType.find("blessed").ID

registercallback("onNPCDeath", function(npc)
	local nD = npc:getData()
	if npc:get("elite_type") == bID then
		treeSpawnerE:create(npc.x, npc.y - 3)
	end
end)
