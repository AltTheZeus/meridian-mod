local Fire4 = ParticleType.find("Fire4")
local Fire3 = ParticleType.find("Fire3")
local Mortar = ParticleType.find("Mortar")
local Smoke = ParticleType.find("Smoke")
local Spark = ParticleType.find("Spark")
local Ash = ParticleType.new("Ash")

local Color = Color.fromHex(0x494949)

local PixelNew = Sprite.load("resources/Objects/PixelNew", 3, 0, 0)

Ash:sprite(PixelNew, false, false, true)
Ash:color(Color)
Ash:speed(math.random(-0.1, 0.1), math.random(-0.1, 0.1), math.random(-0.1, 0.1), math.random(-0.1, 0.1))
Ash:life(30, 60)


local Fire = Object.new("MuspelheimFire")

Fire:addCallback("step", function(self)
    if math.chance(2) then
        Fire4:burst("above", camera.x + math.random(1920, 0), camera.y + math.random(1080, 0), 1, nil)
        Spark:burst("above", camera.x + math.random(1920, 0), camera.y + math.random(1080, 0), 1, nil)
        Fire3:burst("above", camera.x + math.random(1920, 0), camera.y + math.random(1080, 0), 1, nil)
        Mortar:burst("above", camera.x + math.random(1920, 0), camera.y + math.random(1080, 0), 1, nil)
        Smoke:burst("above", camera.x + math.random(1920, 0), camera.y + math.random(1080, 0), 1, nil)
    end
end)


