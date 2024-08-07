local RainP = ParticleType.find("Rain")
local RotColor = Color.fromHex(0x6C754d)

local RainGreen = Object.new("RainGreen")

RainGreen:addCallback("step", function(self)
    RainP:burst("below", camera.x + math.random(1920, 0), camera.y, 1, RotColor)
    RainP:burst("below", camera.x + math.random(1920, 0), camera.y, 1, RotColor)
    RainP:burst("below", camera.x + math.random(1920, 0), camera.y, 1, RotColor)
    RainP:burst("below", camera.x + math.random(1920, 0), camera.y, 1, RotColor)
end)


