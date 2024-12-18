local item = Item("Arc Pen")

item.pickupText = "...and that's all she wrote." 

item.sprite = Sprite.load("Items/pen.png", 1, 16, 16)
local itemEf = Sprite.load("Items/penEf.png", 3, 27, 23)
littleGuy = Sprite.load("Items/penEf2.png", 2, 0, 4)
item:setTier("uncommon")

local penBuff = Buff.new("Shocked")
penBuff.sprite = Sprite.load("Items/penBuff.png", 1, 10, 0)

local penBuff2 = Buff.new("Very Shocked")
penBuff2.sprite = Sprite.load("Items/penBuff2.png", 1, 10, 0)

if modloader.checkMod("Starstorm") then
	table.insert(ss.whitelist.vaccine, penBuff)
	table.insert(ss.whitelist.vaccine, penBuff2)
end

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
	if player:getObject() == Object.find("p") and player:countItem(item) > 0 and net.host then
		if math.random(100) <= 15 + ((player:countItem(item) - 1) * 7.5) then
			damager:getData().pen = 1
		end
	end
end)

local penPacket = net.Packet.new("Arc Pen Packet", function(sender, netActor, rBuff, aBuff, netPlayer, x, y)
	local actor = netActor:resolve()
	local player = netPlayer:resolve()
	if actor and actor:isValid() then
		if rBuff then
			actor:removeBuff(Buff.find(rBuff))
		end
		if aBuff then
			actor:applyBuff(Buff.find(aBuff), 300)
		end
	end
	Sound.find("ChainLightning"):play()
	player:getData().penMode = 5
	if x and y then
		player:fireExplosion(x, y, 2, 2.5, 3, itemEf)
	end
end)

registercallback("onHit", function(damager, hit, x, y)
	if damager:getData().pen and damager:getData().pen == 1 then
		local parent = damager:getParent()
		if hit:hasBuff(penBuff2) then
			hit:removeBuff(penBuff2)
			parent:fireExplosion(hit.x, hit.y, 2, 2.5, 3, itemEf)
			penPacket:sendAsHost(net.ALL, nil, hit:getNetIdentity(), "Very Shocked", false, parent:getNetIdentity(), hit.x, hit.y)
		elseif hit:hasBuff(penBuff) then
			hit:removeBuff(penBuff)
			hit:applyBuff(penBuff2, 300)
			penPacket:sendAsHost(net.ALL, nil, hit:getNetIdentity(), "Shocked", "Very Shocked", parent:getNetIdentity())
		else
			hit:applyBuff(penBuff, 300)
			penPacket:sendAsHost(net.ALL, nil, hit:getNetIdentity(), false, "Shocked", parent:getNetIdentity())
		end
		Sound.find("ChainLightning"):play()
		parent:getData().penMode = 5
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
    destination = "P.O. Box 27,\nRedview,\nMars",
    date = "6/7/2056",
    story = "Yes, yes, I know, you told me not to send it back until I'd gotten every word down. But! I'm throwin' in the towel here.\n\nNot on the story, nonono! I just. Can't, write it like this-. I think too hard about what I'm, burning into these pages, and then instead of writing fire, I reinvent fire. As much as I wanna keep the memento-, with the kinda work you guys are doing, I just can't believe that little Ms. Author me over here is truly realizing its potential. I think the only potential I'm realizing is minmaxing work done to emergency evacuations.\n\nP.S., For the love of all gods whatever you find in these batteries can you send THAT to me INSTEAD pleasethankyouverymuch? We'd get SO much more value from slamming these into a lamp or something, compared to the ZERO work I'm doing right now!!!"
}
