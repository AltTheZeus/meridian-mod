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

--Sky Meadow
Sprite.find("LandCloud1"):replace(Sprite.find("BFloat"))

local sprPurpleClouds = Sprite.load("Stages/vanilla/LandCloud1", 1, 0, 0)
local PurpleClouds = Object.new("PurpleClouds")
PurpleClouds.depth = 30
PurpleClouds:addCallback("create", function(self)
    self:getData().move = 10 -- How fast it moves
    self:getData().moveStep = 0 --idfk too afraid to touch it
end)
PurpleClouds:addCallback("step", function(self)
    if misc.getTimeStop() == 0 then
        self:getData().moveStep = self:getData().moveStep + self:getData().move * 0.1
    end
end)
PurpleClouds:addCallback("draw", function(self)
    local width = sprPurpleClouds.width
    local height = sprPurpleClouds.height
    
    local roomWidth, roomHeight = Stage.getDimensions()
    
    local move = (self:getData().moveStep) % sprPurpleClouds.width
    
    for i = -1, math.floor((roomWidth) / width) do
        graphics.drawImage{
            image = sprPurpleClouds,
            x = move + i * width,
            y = 630,
        }
    end
    for i = -1, math.floor((roomWidth) / width) do
        graphics.drawImage{
            image = sprPurpleClouds,
            x = i * width,
            y = 630,
        }
    end
    for i = -1, math.floor((roomWidth) / width) do
        graphics.drawImage{
            image = sprPurpleClouds,
            x = i * width + 50,
            y = 630,
        }
    end
end)


callback.register("onStageEntry", function()
    if Stage.getCurrentStage().displayName == "Sky Meadow" then
        PurpleClouds:create(0, 0)
    end
 end)
