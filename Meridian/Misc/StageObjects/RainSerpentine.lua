local RainP = ParticleType.find("Rain2")
local RotColor = Color.fromHex(0x577248)

local RainSerpentine = Object.new("RainSerpentine")

RainSerpentine:addCallback("step", function(self)
    RainP:burst("below", camera.x + math.random(1920, 0), camera.y, 1, RotColor)
    RainP:burst("below", camera.x + math.random(1920, 0), camera.y, 1, RotColor)
    RainP:burst("below", camera.x + math.random(1920, 0), camera.y, 1, RotColor)
    RainP:burst("below", camera.x + math.random(1920, 0), camera.y, 1, RotColor)
    RainP:burst("below", camera.x + math.random(1920, 0), camera.y, 1, RotColor)
    RainP:burst("below", camera.x + math.random(1920, 0), camera.y, 1, RotColor)
    RainP:burst("below", camera.x + math.random(1920, 0), camera.y, 1, RotColor)
    RainP:burst("below", camera.x + math.random(1920, 0), camera.y, 1, RotColor)
end)


