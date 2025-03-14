tree = Object.base("Enemy", "Auric Tree")
local treeIdle = Sprite.load("Elites/auricIdle", 1, 11, 27)
local treeSpawn = Sprite.load("Elites/auricSpawn", 3, 11, 27)
local treeMask = Sprite.load("Elites/auricMask", 1, 11, 27)
local treeDeath = Sprite.load("Elites/auricDeath", 7, 16, 33)
local shing = Sound.load("Elites/tree.ogg")
local gogobalga = Sound.load("Elites/treeDeath.ogg")
if not modloader.checkFlag("mn_disable_items") then
	local aspect = Item.find("Gilded Leaf")
end

treeDead = Object.new("tree but its DEAD")
treeDead:addCallback("create", function(self)
	local data = self:getData()
	data.timer = 0
	data.timerActive = 0
	self.sprite = treeDeath
	self.spriteSpeed = 0.2
	data.age = 0
end)
treeDead:addCallback("step", function(self)
	local iD = self:getData()
	print(self.subimage)
	if iD.timerActive == 0 and self.subimage >= 7 then
		iD.timerActive = 1
	end
	if iD.timerActive == 1 then
		iD.timer = iD.timer + 1
		if iD.timer >= 5 then
			self.spriteSpeed = 0
		end
	end
end)

treeSpawner = Object.new("tree spawner")
treeSpawner:addCallback("create", function(self)
	local data = self:getData()
	data.timer = 0
end)
treeSpawner:addCallback("step", function(self)
	local data = self:getData()
	data.timer = data.timer + 1
	if data.timer >= 60 then
		local ad = tree:create(self.x, self.y):getData()
		ad.isPlayer = 0
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
	ac.maxhp = 670 * Difficulty.getScaling("hp")
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
	treeDead:create(self.x, self.y)
	if not modloader.checkFlag("mn_disable_items") then
--	if math.random(1,4000) == 1 then
--		aspect:create(self.x, self.y - 15)
--	end
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

registercallback("onHit", function(damager, hit, x, y)
	if hit:getObject() == tree then
		hit:setAlarm(6, 360)
	end
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
	gD.treeBuff1 = gA.maxhp / 6000
	gA.hp_regen = gA.hp_regen + gD.treeBuff1
end)

treegen:addCallback("step", function(guy)
	local gA = guy:getAccessor()
	local gD = guy:getData()
	if guy:getObject() == Object.find("p") then
	else
		gA.hp = gA.hp + gD.treeBuff1
		if gA.hp > gA.maxhp then gA.hp = gA.maxhp end
	end
end)

treegen:addCallback("end", function(guy)
	local gA = guy:getAccessor()
	local gD = guy:getData()
	gA.hp_regen = gA.hp_regen - gD.treeBuff1
	gD.treeBuff1 = 0
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
	if self:getAlarm(6) > -1 then
		self:setAlarm(6, self:getAlarm(6) - 1)
	end
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
		if iD.isPlayer == 0 then
			for _, a in ipairs(ParentObject.find("actors"):findAllEllipse(self.x - 2 - 61, self.y - 5 - 61, self.x - 2 + 61, self.y - 5 + 61)) do
				if a:getObject() == tree then
				elseif a:getAccessor().team == "enemy" then
					a:applyBuff(treeArmor, 95)
					a:applyBuff(treegen, 95)
				end
			end
		elseif iD.isPlayer == 1 then
			for _, a in ipairs(ParentObject.find("actors"):findAllEllipse(self.x - 2 - 61, self.y - 5 - 61, self.x - 2 + 61, self.y - 5 + 61)) do
				if a:getObject() == tree then
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
