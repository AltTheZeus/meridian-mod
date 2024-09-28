local item = Item("Arc Pen")

item.pickupText = "Chance to write something electric." 

item.sprite = Sprite.load("Items/pen.png", 1, 16, 16)
local itemEf = Sprite.load("Items/penEf.png", 3, 27, 23)
littleGuy = Sprite.load("Items/penEf2.png", 2, 0, 4)
item:setTier("uncommon")

local penBuff = Buff.new("Shocked")
penBuff.sprite = Sprite.load("Items/penBuff.png", 1, 10, 0)

local penBuff2 = Buff.new("Very Shocked")
penBuff2.sprite = Sprite.load("Items/penBuff2.png", 1, 10, 0)

penBuff:addCallback("start", function(self)
	local sD = self:getData()
	sD.penStorage = self:get("pHmax")*0.2
	self:set("pHmax", self:get("pHmax") - sD.penStorage)
end)

penBuff2:addCallback("end", function(self)
	local sD = self:getData()
	self:set("pHmax", self:get("pHmax") + sD.penStorage)
	sD.penStorage = 0
end)

registercallback("onPlayerInit", function(player)
	player:getData().penMode = 1
end)

registercallback("onFireSetProcs", function(damager, player)
	if player:getObject() == Object.find("p") and player:countItem(item) > 0 then
		if math.random(100) <= 15 + ((player:countItem(item) - 1) * 7.5) then
			damager:getData().pen = 1
		end
	end
end)

registercallback("onHit", function(damager, hit, x, y)
	if damager:getData().pen and damager:getData().pen == 1 then
		if hit:hasBuff(penBuff2) then
			hit:removeBuff(penBuff2)
			Object.findInstance(damager:get("parent")):fireExplosion(hit.x, hit.y, 2, 2.5, 3, itemEf)
		elseif hit:hasBuff(penBuff) then
			hit:removeBuff(penBuff)
			hit:applyBuff(penBuff2, 300)
		else
			hit:applyBuff(penBuff, 300)
		end
		Sound.find("ChainLightning"):play(1, 1)
		Object.findInstance(damager:get("parent")):getData().penMode = 5
	end
end)

registercallback("onPlayerDrawAbove", function(player)
	if player:countItem(item) > 0 then
		local subCalc
		if player:getData().penMode > 1 then
			subCalc = 2
		end
		graphics.drawImage{
			image = littleGuy,
			subimage = subCalc,
			x = player.x - (6 * player.xscale),
			y = player.y + 6,
			angle = math.round(15 * (player:get("pHspeed")))
			}
		if player:getData().penMode > 1 then
			player:getData().penMode = player:getData().penMode - 1
		end
	end
end)

item:setLog{
    group = "uncommon",
    description = "&y&15% chance&!& to inflict a stacking debuff on enemies. At &y&3 stacks&!&, explodes in a small area for &y&300% damage&!&.",
    priority = "&w&Standard&!&",
    destination = "The Great Furnace,\nDying Star,\nDeep Space",
    date = "--",
    story = "Regrettably, I've started to feel excitement when I see a Bison. Though they are tough to fell, I can utilize almost every part of their corpse. Their meat reminds me of home. Their bones are sturdy and well-used in my tools. Their metallic growths... exhibit some strange properties. I'm sure they're valuable, if nothing else."
}