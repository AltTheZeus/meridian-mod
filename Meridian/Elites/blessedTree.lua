tree = Object.base("Enemy", "Auric Tree")
local treeIdle = Sprite.load("Elites/auricIdle", 1, 11, 27)
local treeSpawn = Sprite.load("Elites/auricSpawn", 3, 11, 27)
local treeMask = Sprite.load("Elites/auricMask", 1, 11, 27)
local shing = Sound.load("Elites/tree.ogg")
local gogobalga = Sound.load("Elites/treeDeath.ogg")

treeSpawner = Object.new("tree spawner")
treeSpawner:addCallback("create", function(self)
	local data = self:getData()
	data.timer = 0
end)
treeSpawner:addCallback("step", function(self)
	local data = self:getData()
	data.timer = data.timer + 1
	if data.timer >= 60 then
		tree:create(self.x, self.y)
		self:destroy()
	end
end)

local leaf = Sprite.load("Elites/leafEf", 1, 2, 2)
local leafEF = ParticleType.new("auricLeaf")
	leafEF:sprite(leaf, false, false, false)
	leafEF:scale(1, -1)
	leafEF:alpha(1, 0.75, 0)
	leafEF:angle(-20, 20, 0, 0, true)
	leafEF:speed(-1, 1, -0.02, 0.02)
	leafEF:direction(0, 0, 0, 0)
	leafEF:gravity(0.08, 270)
	leafEF:life(60 * 1, 60 * 1.5)

tree:addCallback("create", function(self)
	shing:play()
	local data = self:getData()
	local ac = self:getAccessor()
	data.efTimer = 0
	data.timer = 0
	data.timerActive = 0
	self.sprite = treeSpawn
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
	self.mask = treeMask
	self:setAnimations{
		spawn = treeSpawn,
		idle = treeIdle,
		jump = treeIdle
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

tree:addCallback("destroy", function(self)
	local leafCount = 0
	gogobalga:play()
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
local treegen = Buff.new("Auric Blessing")
	treegen.sprite = Sprite.load("Elites/treeHP", 1, 10, 0)
local treeArmor = Buff.new("Auric Distinction")
	treeArmor.sprite = Sprite.load("Elites/treeShield", 1, 10, 0)

treegen:addCallback("start", function(guy)
	local gA = guy:getAccessor()
	local gD = guy:getData()
	gD.treeBuff1 = gA.maxhp / 600
	gA.hp_regen = gA.hp_regen + gD.treeBuff1
end)

treegen:addCallback("step", function(guy)
	local gA = guy:getAccessor()
	local gD = guy:getData()
	gA.hp = gA.hp + gD.treeBuff1
	if gA.hp > gA.maxhp then gA.hp = gA.maxhp end
end)

treeArmor:addCallback("start", function(guy)
	local gA = guy:getAccessor()
	gA.armor = gA.armor + 25
end)

treeArmor:addCallback("end", function(guy)
	local gA = guy:getAccessor()
	gA.armor = gA.armor - 25
end)

tree:addCallback("step", function(self)
	local iD = self:getData()
	if iD.timerActive == 0 and self.sprite == treeSpawn and self.subimage >= 3 then
		iD.timerActive = 1
	end
	if iD.timerActive == 1 then
		iD.timer = iD.timer + 1
		if iD.timer >= 5 then
			self.sprite = treeIdle
		end
	end
	iD.efTimer = iD.efTimer + 1
	if iD.efTimer >= 90 then
		local eehee = circle:create(self.x - 2, self.y - 5)
		local eD = eehee:getAccessor()
		eD.radius = 40
		eehee.blendColor = Color.fromRGB(255, 237, 187)
		iD.efTimer = 0
		for _, a in ipairs(enemies:findAllEllipse(self.x - 2 - 61, self.y - 5 - 61, self.x - 2 + 61, self.y - 5 + 61)) do
			if a:getObject() == tree then
			else
				a:applyBuff(treeArmor, 95)
				a:applyBuff(treegen, 95)
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
		treeSpawner:create(npc.x, npc.y - 3)
	end
end)
