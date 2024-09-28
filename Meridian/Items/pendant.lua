local item = Item("Viridian Pendant")
item.color = "p"

item.pickupText = "Seems to do nothing..." 

item.sprite = Sprite.load("Items/pendant.png", 1, 16, 16)

item:setLog{
    group = "boss",
    description = "&y&15% chance&!& to inflict a stacking debuff on enemies. At &y&3 stacks&!&, explodes in a small area for &y&300% damage&!&.",
    priority = "&w&Standard&!&",
    destination = "The Great Furnace,\nDying Star,\nDeep Space",
    date = "--",
    story = "Regrettably, I've started to feel excitement when I see a Bison. Though they are tough to fell, I can utilize almost every part of their corpse. Their meat reminds me of home. Their bones are sturdy and well-used in my tools. Their metallic growths... exhibit some strange properties. I'm sure they're valuable, if nothing else."
}