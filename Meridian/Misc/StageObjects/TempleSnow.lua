local ParticleP = ParticleType.find("TempleSnow")

local TempleSnow = Object.new("TempleSnow")

TempleSnow:addCallback("step", function(self)
    ParticleP:burst("above", camera.x + math.random(1920, 0), camera.y + math.random(1080, 0), 1, RotColor)
    ParticleP:burst("above", camera.x + math.random(1920, 0), camera.y + math.random(1080, 0), 1, RotColor)
    ParticleP:burst("above", camera.x + math.random(1920, 0), camera.y + math.random(1080, 0), 1, RotColor)
    ParticleP:burst("above", camera.x + math.random(1920, 0), camera.y + math.random(1080, 0), 1, RotColor)
end)


