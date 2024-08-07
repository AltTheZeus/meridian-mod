--Main Menu

local title = Sprite.load("Misc/UI/sprTitleMeridian", 1, 205, 50)
local titleSS = Sprite.load("Misc/UI/sprTitleMeridianSS", 1, 205, 50)

callback.register("postLoad", function()
    if modloader.checkMod("starstorm") then
        Sprite.find("sprTitle", "Vanilla"):replace(titleSS)
    else
        Sprite.find("sprTitle", "Vanilla"):replace(title)
    end
end)

