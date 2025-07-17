local path = "Interactables/"
local shrine = Object.base("MapObject", "spiresGenerator")
local shrineInt = Interactable.new(shrine, "Spires Generator")
shrineInt.spawnCost = 100
shrine.depth = -7
shrine.sprite = Sprite.load("SpiresGenerator", path.."spiresGenerator", 1, 29, 46)