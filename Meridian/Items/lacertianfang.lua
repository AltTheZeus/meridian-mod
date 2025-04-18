local item = Item("Relentless Fang")
item.color = "y"

item.pickupText = "For every skill on cooldown, reduce your other skills' cooldowns." 

item.sprite = Sprite.load("Items/lacertianfang.png", 1, 15, 15)
local ef = Sprite.load("Items/lacertianfangEf.png", 1, 0, 0)
if modloader.checkMod("Starstorm") then
	ItemPool.find("legendary", "Starstorm"):add(item)
end

registercallback("onPlayerStep", function(player)
    local itemAmount = player:countItem(item)
    local skillAmount = 0 
    local itemCd = 0
    if itemAmount > 0 then 
        for i = 1, itemAmount do 
            itemCd = math.approach(itemCd, 1, (1 - itemCd) * 0.07)
        end
        for i = 3, 5 do 
            if player:getAlarm(i) > -1 then 
                skillAmount = skillAmount + 1
            end
        end
        itemCd = itemCd * (skillAmount - 1)
        for i = 3, 5 do 
            if player:getAlarm(i) > -1 then 
                player:setAlarm(i, math.max(player:getAlarm(i) - itemCd, 0))
            end
        end
    end
end)

registercallback("onPlayerHUDDraw", function(player, x, y)
	if player:countItem(item) > 0 then
		if player:getAlarm(3) > 0 then
			graphics.drawImage{ef, x + 21, y - 2}
		end
		if player:getAlarm(4) > 0 then
			graphics.drawImage{ef, x + 44, y - 2}
		end
		if player:getAlarm(5) > 0 then
			graphics.drawImage{ef, x + 67, y - 2}
		end
	end
end)

item:setLog{
    group = "boss",
    description = "For every skill on cooldown, reduce skill cooldowns by &y&7%&!&.",
    priority = "&b&Field-Found&!&",
    destination = "8009,\nImperceptible Fields,\nUnknown",
    date = "--",
    story = "Through every environment this beast tailed me. Always moving, always chasing.\n\nIt's said humans were as prevalent as we were because of our persistence hunting style.\n\nThis tooth is evidence that we can outhunt the hunter itself."
}
