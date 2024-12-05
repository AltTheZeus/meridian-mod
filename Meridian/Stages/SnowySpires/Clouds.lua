--CODE BY NK (NEIK) HOLY SHIT THANK U!!!!!!!!!

local sprMovingClouds = Sprite.find("snowgroundClouds", "Meridian")
local drawCloudsSnow = Object.new("drawCloudsSnow")
drawCloudsSnow.depth = 9800
drawCloudsSnow:addCallback("create", function(self)
    self:getData().move = 2 -- How fast it moves
    self:getData().moveStep = 0 --idfk too afraid to touch it
end)
drawCloudsSnow:addCallback("step", function(self)
    if misc.getTimeStop() == 0 then
        self:getData().moveStep = self:getData().moveStep + self:getData().move * 0.1
    end
end)
drawCloudsSnow:addCallback("draw", function(self)
    local width = sprMovingClouds.width
    local height = sprMovingClouds.height
    
    local roomWidth, roomHeight = Stage.getDimensions()
    
    local move = (self:getData().moveStep) % sprMovingClouds.width
    
    local xParallax = 0.85  
    for i = -1, math.floor((roomWidth * xParallax) / width) do
        graphics.drawImage{
            image = sprMovingClouds,
            x = move + misc.camera.x * xParallax + i * width,
            y = (misc.camera.y * xParallax) + (roomHeight * 0.15) + 150,
        }
    end
    graphics.color(Color.fromHex(0x619AA8))
    graphics.alpha(1)
    graphics.rectangle(0, (misc.camera.y * xParallax) + (roomHeight * 0.15) + 150 + height, roomWidth, roomHeight, false)
end)

local sprClouds1 = Sprite.find("snowskyClouds", "Meridian")
local DrawClouds1 = Object.new("Clouds1")
DrawClouds1.depth = 9970
DrawClouds1:addCallback("create", function(self)
    self:getData().move = 1 -- How fast it moves
    self:getData().moveStep = 0 --idfk too afraid to touch it
end)
DrawClouds1:addCallback("step", function(self)
    if misc.getTimeStop() == 0 then
        self:getData().moveStep = self:getData().moveStep + self:getData().move * 0.1
    end
end)
DrawClouds1:addCallback("draw", function(self)
    local width = sprClouds1.width
    local height = sprClouds1.height
    
    local roomWidth, roomHeight = Stage.getDimensions()
    
    local move = (self:getData().moveStep) % sprClouds1.width
    
    local xParallax = 0.99
    local yParallax = 0.99
    for i = -1, math.floor((roomWidth * xParallax) / width) do
        graphics.drawImage{
            image = sprClouds1,
            x = move + misc.camera.x * xParallax + i * width,
            y = (misc.camera.y * yParallax - 20),
        }
    end
end)

callback.register("onStageEntry", function()
    if Stage.getCurrentStage().displayName == "Snowy Spires" then
        drawCloudsSnow:create(0, 0)
        DrawClouds1:create(0, 0)
        print("created clouds")
    end
 end)


