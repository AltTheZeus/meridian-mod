local DustP = ParticleType.find("Dust1")
local RotColor = Color.fromHex(0x6C754d)

local Dust1 = Object.new("Dust1")

Dust1:addCallback("step", function(self)
    DustP:burst("below", camera.x + math.random(1920, 0), camera.y + math.random(1080, 0), 1, nil)
end)


