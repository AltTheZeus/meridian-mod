local pStardust = ParticleType.new("pStardust")

pStardust:sprite(Sprite.load("Misc/StageObjects/Stardust", 6, 3, 3), true, true, true)
pStardust:gravity(0, 0)
pStardust:alpha(1, 0)
pStardust:life(200, 300)

local objStardust = Object.new("pStardust")

objStardust:addCallback("step", function(self)
    if math.chance(10) then
        pStardust:burst("above", camera.x + math.random(1920, 0), camera.y + math.random(1080, 0), 1, nil)
    end
end)


