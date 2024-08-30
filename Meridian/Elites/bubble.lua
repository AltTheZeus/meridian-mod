local elite = EliteType.new("bubble")
local sprPal = Sprite.load("Elites/bubblePal", 1, 0, 0)
local ID = elite.ID
local bID = EliteType.find("blessed").ID

elite.displayName = "Rippling"
elite.color = Color.fromRGB(87, 70, 168)
elite.palette = sprPal

for _, i in ipairs(MonsterCard.findAll("vanilla")) do
	if i ~= MonsterCard.find("Magma Worm", "vanilla") then
		i.eliteTypes:add(elite)
	end
end

registercallback("postLoad", function()
for _, m in ipairs(modloader.getMods()) do
	for _, i in ipairs(MonsterCard.findAll(m)) do
		i.eliteTypes:add(elite)
	end
end
end)

registercallback("onEliteInit", function(actor)
	local aD = actor:getData()
	if actor:get("elite_type") == ID or actor:get("elite_type") == bID then
		aD.bubbleCooldown = 0
	end
end)

local enemies = ParentObject.find("enemies")

local bubbleObj = Object.new("bubble")
bubbleObj.sprite = Sprite.load("Elites/bubble", 4, 7, 7)
local bubblePop = Sprite.load("Elites/bubblePop", 4, 17, 21)

local spawn = Sound.find("Use", "vanilla")
local pop = Sound.find("JellyHit", "vanilla")

bubbleObj:addCallback("create", function(self)
	local sD = self:getData()
	self.spriteSpeed = 0.12 + (0.01 * math.random(-1,1))
	sD.life = 0
	sD.lifeLim = math.random(180,250)
end)

bubbleObj:addCallback("step", function(self)
	local sD = self:getData()
	sD.life = sD.life + 1
	if sD.life >= sD.lifeLim then
--			sD.owner:fireExplosion(self.x, self.y, 25/19, 25/4, 0.6, bubblePop)
			if sD.friendly then
				misc.fireExplosion(self.x, self.y, 20/19, 20/4, math.round(sD.damage * 0.6), "player", bubblePop)
			else
				misc.fireExplosion(self.x, self.y, 20/19, 20/4, math.round(sD.damage * 0.6), "enemy", bubblePop)
			end
			self:destroy()
			pop:play()
	end
	if not sD.owner:isValid() then
--		misc.fireExplosion(self.x, self.y, 20/19, 20/4, math.round(sD.damage * 0.6), "enemy", bubblePop)
		self:destroy()
		pop:play()
	end
	for _, p in ipairs(misc.players) do
		if self:collidesWith(p, self.x, self.y) and not sD.friendly then
--			sD.owner:fireExplosion(self.x, self.y, 25/19, 25/4, 1.2, bubblePop)
--			misc.fireExplosion(self.x, self.y, 20/19, 20/4, math.round(sD.damage * 0.6), "enemy", bubblePop)
--			self:destroy()
--			pop:play()
		else
			self.x = math.approach(self.x, sD.locX, math.abs(math.round((self.x - sD.locX) * 0.1)))
			self.y = math.approach(self.y, sD.locY, math.abs(math.round((self.y - sD.locY) * 0.1)))
		end
	end
end)

registercallback("onStep", function()
	for _, i in ipairs(enemies:findMatching("elite_type", ID)) do
		local iD = i:getData()
		if iD.bubbleCooldown > 0 then
			iD.bubbleCooldown = iD.bubbleCooldown - 1
		end
	end
	for _, i in ipairs(enemies:findMatching("elite_type", bID)) do
		local iD = i:getData()
		if iD.bubbleCooldown > 0 then
			iD.bubbleCooldown = iD.bubbleCooldown - 1
		end
	end
end)

registercallback("onDamage", function(target, damage, source)
--if Difficulty.getActive().forceHardElites == true or misc.director:get("stages_passed") >= 2 then
	if not CheckValid(source) then return end
	if target:isValid() and (target:get("elite_type") == ID or target:get("elite_type") == bID) then
		local tD = target:getData()
		if tD.bubbleCooldown <= 0 then
			local bubbleAmount = math.random(1, 3)
			bubbleAmount = math.round(bubbleAmount * (target.sprite.height/8))
			if bubbleAmount <= 1 then bubbleAmount = 1 end
			tD.bubbleCooldown = bubbleAmount * 40
			repeat
				local baby = bubbleObj:create(target.x, target.y)
				local bD = baby:getData()
				bD.owner = target
				bD.damage = target:get("damage")
				bD.locX = target.x + math.random(-50, 50)
				bD.locY = target.y + math.random(-50, 50)
				bubbleAmount = bubbleAmount - 1
			until bubbleAmount <= 0
			spawn:play()
		end
	end
--end
end)
