--Depth Change so you can actually see the player when infront of an interactable
obj.Chest1.depth = 5
obj.Chest2.depth = 5
obj.Chest3.depth = 5
obj.Chest4.depth = 5
obj.Chest5.depth = 5

obj.Shrine1.depth = 5
obj.Shrine2.depth = 5
obj.Shrine3.depth = 5
obj.Shrine4.depth = 5
obj.Shrine5.depth = 5

Sprite.find("Water1"):replace(Sprite.load("Stages/vanilla/Water1", 1, 0, 0))
Sprite.find("Water2"):replace(Sprite.load("Stages/vanilla/Water2", 1, 0, 0))
