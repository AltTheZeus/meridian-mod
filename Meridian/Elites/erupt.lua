local elite = EliteType.new("erupt")
local sprPal = Sprite.load("Elites/eruptPal", 1, 0, 0)
local ID = elite.ID
local bID = EliteType.find("blessed").ID

elite.displayName = "Eruptive"
elite.color = Color.fromRGB(184, 20, 56)
elite.palette = sprPal

registercallback("onEliteInit", function(actor)
	local aD = actor:getData()
	if actor:get("elite_type") == ID or actor:get("elite_type") == bID then
		aD.lavaThreshold = 0
		aD.lavad = false
		aD.eliteVar = 1
	end
end)

local enemies = ParentObject.find("enemies")

local lavaObj = Object.new("eruptLava")
lavaObj.sprite = Sprite.load("Elites/eruptEf", 1, 2, 2)

lavaObj:addCallback("create", function(self)
	local sD = self:getData()
	sD.life = 0
	sD.damageTimer = 0
end)

lavaObj:addCallback("step", function(self)
	local sD = self:getData()
	sD.life = sD.life + 1
	if sD.life >= 300 then
		self:destroy()
	end
	for _, i in ipairs(lavaObj:findAll()) do
		if self:collidesWith(i, self.x, self.y) and i.id ~= self.id then
			if sD.owner:isValid() then
				sD.owner:getData().lavaThreshold = sD.owner:getData().lavaThreshold + 0.5
			end
			self:destroy()
		end
	end
	sD.damageTimer = sD.damageTimer + 1
	if sD.damageTimer == 15 then
		misc.fireExplosion(self.x + 23, self.y - 4, 22/19, 1, sD.damage * 0.3, "enemy")
		sD.damageTimer = 0
	end
end)

registercallback("onHit", function(damager, hit, x, y)
	if hit:get("elite_type") == ID or hit:get("elite_type") == bID and hit:getData().eliteVar == 1 then
		local hD = hit:getData()
		hD.lavaThreshold = hD.lavaThreshold + ((damager:get("damage")/hit:get("maxhp")) * 10)
		if hD.lavaThreshold >= 1 then
			local spawnPot
			if hit:collidesWith(Object.find("B"), hit.x, hit.y + (hit.sprite.height - hit.sprite.yorigin) + 1) then
				spawnPot = Object.find("B"):findLine(hit.x, hit.y, hit.x, hit.y + (hit.sprite.height - hit.sprite.yorigin) + 1)
			else return end
			local cSpawn = spawnPot.x
			for i = spawnPot.x, spawnPot.x + (spawnPot:get("width_box") * 16) - 32, 16 do
				if math.abs(hit.x - i) < math.abs(hit.x - cSpawn) then
					cSpawn = i
				end
			end
			if spawnPot:get("width_box") >= 3 then
				local myLava = lavaObj:create(cSpawn - 16, spawnPot.y)
				myLava:getData().owner = hit
				myLava:getData().damage = hit:get("damage") / 2
				hD.lavaThreshold = 0
			end
		end
	end
end)