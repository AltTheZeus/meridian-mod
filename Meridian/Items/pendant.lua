local item = Item("Viridian Pendant")
item.color = "p"

item.pickupText = "Seems to do nothing..." 

item.sprite = Sprite.load("Items/pendant.png", 1, 16, 16)

registercallback("postLoad", function()
item:setLog{
    group = "end",
    description = "--",
    priority = "&p&Field-Found&!&",
    destination = "Unknown,\nUnknown,\nUnknown",
    date = "--",
    story = "At first, I thought the symbol was rigid. The ways I saw it engraved on those dilapidated halls, towering pillars, and the beacon. But when it clattered into my still-shaking hand, I felt it... shift. Reconfigure, its rings and moons rotating in impossible ways around its center, a response to my grasp.\n\nAs I tilted it, its directions changed in ways I could not parse. Its motion reminded me of the navigation tools that I fear I may never hold again. Its twisting shape reminding me that I am alien to this world, and could never belong to it.\n\nIn this... I feel that it guides me. In my satchel, and occasionally around my neck, a step closer to... my destination. Beyond this plain, towards something still waiting for me."
}
end)