require("Items/battery")
require("Items/berries")
require("Items/cable")
require("Items/cards")
require("Items/chaos")
require("Items/chrome")
require("Items/emberfly")
require("Items/gas")
require("Items/homunculus")
require("Items/iron")
require("Items/lacertianfang")
require("Items/misshapenflesh")
require("Items/opal")
require("Items/paddle")
require("Items/pen")
require("Items/pendant")
require("Items/snowball")
require("Items/minifridge")
require("Items/heatsink")

--Starstorm tab menu stuff
if modloader.checkMod("Starstorm") then
	TabMenu.setItemInfo(Item.find("Arc Pen"), 13, "15% chance to apply a stacking debuff on hit which slows enemies by 20%.\nAt 3 stacks, the enemy explodes for 300% damage.", "+7.5% chance.")
	TabMenu.setItemInfo(Item.find("Bidder's Paddle"), 50, "Picking up an item reduces the cost of all chests on the stage by 2%.", "+2% cost reduction")
	TabMenu.setItemInfo(Item.find("Chaos Drive"), nil, "While attacking, build up 0.25% health per second, to a cap of 15% max hp.\nWhen under 33% health, rapidly heal 15% health per second.", "+15% stored health.")
	TabMenu.setItemInfo(Item.find("Collectible Cards"), nil, "Every 5 seconds, increase the value of enemies by $1 (scales with time).", "+$1 every 5 seconds.")
	TabMenu.setItemInfo(Item.find("Chrome Finish"), nil, "Gain 10 shield. Your drones gain 20 scaling shield. While shield is\nactive, you and your drones gain 10 armor.", "+10 player shield. +5 drone shield.")
	TabMenu.setItemInfo(Item.find("Discarded Homunculus"), nil, "Spawn 4 chunks of flesh on every stage. Collecting them spawns a\nflesh amalgamate at the teleporter. While the teleport is active, killing\nan enemy near the flesh amalgamate will cause it to explode for 800% damage.", "Damage stacks multiplicatively.")
	TabMenu.setItemInfo(Item.find("Emberfly Pin"), nil, "20% chance on taking damage to spawn an Embercloud, which deals 50%\ndamage 10 times over the course of 5 seconds.", "+50% damage.")
	TabMenu.setItemInfo(Item.find("Foraged Spoils"), 39, "5% chance for a boss kill to yield a unique item.", "+2.5% drop chance.")
	TabMenu.setItemInfo(Item.find("Jumpstart Cable"), nil, "Purchase 1 drone for free per stage.", "+1 free drones.")
	TabMenu.setItemInfo(Item.find("Misshapen Flesh"), nil, "Deal an extra 10% damage to enemies in contact with other enemies.", "+10% damage.")
	TabMenu.setItemInfo(Item.find("Portable Battery"), nil, "While equipment is off cooldown, increase health regeneration by 3.", "+3 health regeneration.")
	TabMenu.setItemInfo(Item.find("Relentless Fang"), nil, "Reduce skill cooldowns by 3% for every skill currently on cooldown.", "Cooldown reduction stacks multiplicatively.")
	TabMenu.setItemInfo(Item.find("Snowball"), nil, "Multiplicitavely increase damage of all attacks, based on the attack's base damage.", "Multiplicative damage increase stacks multiplicatively.")
	TabMenu.setItemInfo(Item.find("Tear Gas"), nil, "Deal 10% more damage to stunned enemies.", "+10% damage.")
	TabMenu.setItemInfo(Item.find("Viridian Pendant"), nil, "???????", "???")
	TabMenu.setItemInfo(Item.find("Worn Iron"), 39, "5% to ground enemies on hit for 3.5 seconds, stopping them from flying, jumping, or dropping down ledges.", "+2.5% chance.")
	TabMenu.setItemInfo(Item.find("Xenial Opal"), nil, "For every minute you spend on a stage, gain 8% speed, up to a maximum of 300%.\nResets at the end of the stage.", "+4% speed.")
	TabMenu.setItemInfo(Item.find("Mini Fridge"), nil, "When you get hit, damage and freeze nearby enemies.\n5 second cooldown.", "30% cooldown reduction, multiplicative.")
	TabMenu.setItemInfo(Item.find("Overclocked Heatsink"), nil, "Use items have a 25% chance to not go on cooldown.", "Multiplicative.")
end

--Category Chests compat
registercallback("postLoad", function()
	if modloader.checkMod("categorychests") then
		local damage1 = ItemPool.find("damagePoolCommon", categorychests)
		local damage2 = ItemPool.find("damagePoolUncommon", categorychests)
		local damage3 = ItemPool.find("damagePoolRare", categorychests)
		local health1 = ItemPool.find("healthPoolCommon", categorychests)
		local health2 = ItemPool.find("healthPoolUncommon", categorychests)
		local health3 = ItemPool.find("healthPoolRare", categorychests)
		local utility1 = ItemPool.find("utilityPoolCommon", categorychests)
		local utility2 = ItemPool.find("utilityPoolUncommon", categorychests)
		local utility3 = ItemPool.find("utilityPoolRare", categorychests)

--		damage1:add(Item.find("Armed Backpack"))

		damage2:add(Item.find("Arc Pen"))
		damage2:add(Item.find("Tear Gas"))

		damage3:add(Item.find("Discarded Homunculus"))
		damage3:add(Item.find("Emberfly Pin"))
		damage3:add(Item.find("Snowball"))

		health1:add(Item.find("Chaos Drive"))
		health1:add(Item.find("Portable Battery"))

--		health2:add(Item.find("Armed Backpack"))

--		health3:add(Item.find("Armed Backpack"))

		utility1:add(Item.find("Bidder's Paddle"))
		utility1:add(Item.find("Xenial Opal"))

		utility2:add(Item.find("Collectible Cards"))
		utility2:add(Item.find("Chrome Finish"))
		utility2:add(Item.find("Foraged Spoils"))
		utility2:add(Item.find("Jumpstart Cable"))
		utility2:add(Item.find("Worn Iron"))

--		utility3:add(Item.find("Armed Backpack"))
	end
end)
