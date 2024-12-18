local item = Item("Collectible Cards")

item.pickupText = "Enemies become more valuable over time." 

item.sprite = Sprite.load("Items/cards.png", 1, 15,  15)
item:setTier("uncommon")

registercallback("onGameStart", function()
	local dD = misc.director:getData()
	dD.cardTimer = 0
end)

local enemies = ParentObject.find("enemies")
registercallback("onActorInit", function(self)
	local sD = self:getData()
	sD.cardCoins = 0
end)

registercallback("onStep", function()
	local cardCount = 0
	for _, i in ipairs(misc.players) do
		cardCount = cardCount + i:countItem(item)
	end
	if cardCount > 0 then
	local dD = misc.director:getData()
		dD.cardTimer = dD.cardTimer + 1
		if dD.cardTimer >= 5 * 60 then
			for _, i in ipairs(enemies:findAll()) do
				if i:get("team") == "enemy" and i:get("exp_worth") and i:get("exp_worth") > 0 then
					i:set("exp_worth", i:get("exp_worth") + ((1 * Difficulty.getScaling("cost")) * cardCount))
				end
				local iD = i:getData()
				iD.cardCoins = 1
				i:set("blast", 1)
			end
		dD.cardTimer = 0
		end
	end
end)

registercallback("onNPCDeathProc", function(npc, player)
	local sD = npc:getData()
	if sD.cardCoins == 1 then
		Sound.find("Coins"):play(1 + math.random(-0.2, 0.2), 0.8)
	end
end)

item:setLog{
    group = "uncommon_locked",
    description = "Every 5 seconds, enemies become worth &y&1&!& more gold, scaling with time.",
    priority = "&g&High Priority&!&",
    destination = "12 Cherish Place,\nThe Landing Strip,\nJupiter",
    date = "12/28/2056",
    story = "DO NOT TAKE THEM OUT OF THE PACKAGING! Give this box STRAIGHT to the graders. These cards are worth a fortune, look at them! First edition, mint condition, half of them damn near may as well be sealed! These are collector's items, prime material. I'm gonna be so rich when these get back to me!"
}

local ach = Achievement.new("cardsitem")
ach.requirement = 1
ach.deathReset = true
ach.description = "Kill an enemy worth over 5000 gold."
ach:assignUnlockable(item)

registercallback("onNPCDeath", function(npc)
	if not net.online and npc:get("exp_worth") > 5000 then
		ach:increment(1)
	end
end)

registercallback("onHit", function(damager, hit) --Alternate callback for online use, could be slightly more unstable so it'll only be active in multiplayer. Only way to find out who killed what.
	if net.online then
		local parent = damager:getParent()
		if parent and parent:isValid() and (parent:get("dead") or 0) == 0 and parent == net.localPlayer then
			if (hit:get("hp") - damager:get("damage")) < 0 and (hit:get("invincible") or 0) <= 0 and hit:get("exp_worth") > 5000 then
				ach:increment(1)
			end
		end
	end
end, 1700)
