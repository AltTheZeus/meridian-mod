callback.register("postLoad", function()
	if modloader.checkMod("LivelyWorld") then
        local ShallowRotlands = Stage.find("Shallow Rotlands", "Meridian")
        local MarshlandSanctuary = Stage.find("Marshland Sanctuary", "Meridian")
        local StarsweptValley = Stage.find("Starswept Valley", "Meridian")
        local BasaltQuarry = Stage.find("Basalt Quarry", "Meridian")
        local DissonantReliquary = Stage.find("Dissonant Reliquary", "Meridian")
        local DesertPeaks = Stage.find("Desert Peaks", "Meridian")
        local SerpentineRainforest = Stage.find("Serpentine Rainforest", "Meridian")

		--Lively World Tables
		LW.setStageData(ShallowRotlands, Color.fromHex(0x5A9978), false, true, 0.05)
		LW.setStageData(MarshlandSanctuary, Color.fromHex(0x8A995A), false, true, 0.12)
		LW.setStageData(StarsweptValley, Color.fromHex(0xFFFFFF), false, true, 0.09)
		LW.setStageData(BasaltQuarry, Color.fromHex(0x301B1B), false, true, 0.09)
		LW.setStageData(DissonantReliquary, Color.fromHex(0x3F626A), false, true, 0.01)
		LW.setStageData(DesertPeaks, Color.fromHex(0x984F41), false, true, 0.05)
        LW.setStageData(SerpentineRainforest, Color.fromHex(0x5A9978), false, true, 0.05)
        --[[
        LW.backgroundData["Marshland Sanctuary"] = {
            skyColor = Color.fromHex(0xE6EAC2),
            elements = {
                {
                    baseSprite = Sprite.find("MarshlandBG1", "Meridian"),
                    xRepeat = true,
                    yRepeat = false,
                    xParallax = 0.95,
                    yParallax = 0.95,
                    xOffset = -200,
                    yOffset = -200,
                    xOffsetPercent = 0.20,
                    yOffsetPercent = 1,
                    xSpeed = 0,
                    ySpeed = 0
                },
                {
                    baseSprite = Sprite.find("MarshlandBG2", "Meridian"),
                    xRepeat = true,
                    yRepeat = false,
                    xParallax = 0.97,
                    yParallax = 0.97,
                    xOffset = -200,
                    yOffset = -200,
                    xOffsetPercent = 0.20,
                    yOffsetPercent = 1,
                    xSpeed = 0,
                    ySpeed = 0
                },
                {
                    baseSprite = Sprite.find("MarshlandClouds", "Meridian"),
                    xRepeat = true,
                    yRepeat = false,
                    xParallax = 0.9,
                    yParallax = 0.9,
                    xOffset = 0,
                    yOffset = 1,
                    xOffsetPercent = 0,
                    yOffsetPercent = 0.20,
                    xSpeed = 2,
                    ySpeed = 0
                },
                {
                    baseSprite = Sprite.find("MarshlandPlanet", "Meridian"),
                    xRepeat = false,
                    yRepeat = false,
                    xParallax = 1,
                    yParallax = 1,
                    xOffset = 0,
                    yOffset = -15,
                    xOffsetPercent = 0.6,
                    yOffsetPercent = 0.1,
                    xSpeed = 0,
                    ySpeed = 0
                },
                {
                    baseSprite = Sprite.find("GreenSky", "Meridian"),
                    xRepeat = true,
                    yRepeat = true,
                    xParallax = 1,
                    yParallax = 1,
                    xOffset = 0,
                    yOffset = 0,
                    xOffsetPercent = 0,
                    yOffsetPercent = 0,
                    xSpeed = 0,
                    ySpeed = 0
                }
            }
        }
	end
end)
]]
		--Ambience
		local LushRainAmb = Sound.load("Misc/Sounds/LivelyWorld/LushRainAmb.ogg")
		local LushAmb = Sound.load("Misc/Sounds/LivelyWorld/LushAmb.ogg")
		local WindAmb = Sound.load("Misc/Sounds/LivelyWorld/WindAmb.ogg")
		local WindCalmAmb = Sound.load("Misc/Sounds/LivelyWorld/WindCalmAmb.ogg")
		local WindCrystalAmb = Sound.load("Misc/Sounds/LivelyWorld/WindCrystalAmb.ogg")
		local WindDryAmb = Sound.load("Misc/Sounds/LivelyWorld/WindDryAmb.ogg")
        local LushHeavyRainAmb = Sound.load("Misc/Sounds/LivelyWorld/LushHeavyRainAmb.ogg")

		callback.register("onStageEntry", function()
            local Stag = Stage.getCurrentStage()
			--print(Stage.getCurrentStage().displayName)
			if Stag == ShallowRotlands then
				LushAmb:loop()
			else
				LushAmb:stop()
			end
				
			if Stag == MarshlandSanctuary then
				LushRainAmb:loop()
			else
				LushRainAmb:stop()
			end

			if Stag == StarsweptValley then
				WindCrystalAmb:loop()
			else
				WindCrystalAmb:stop()
			end

			if Stag == DissonantReliquary then
				WindCalmAmb:loop()
			else
				WindCalmAmb:stop()
			end
			
			if Stag == BasaltQuarry then
				WindAmb:loop()
			else
				WindAmb:stop()
			end
			if Stag == DesertPeaks then
				WindDryAmb:loop()
			else
				WindDryAmb:stop()
			end
            if Stag == SerpentineRainforest then
				LushHeavyRainAmb:loop()
			else
				LushHeavyRainAmb:stop()
			end
		end)
		callback.register("globalRoomEnd", function()
			WindAmb:stop()
			WindCalmAmb:stop()
			WindCrystalAmb:stop()
			LushRainAmb:stop()
			LushAmb:stop()
            LushHeavyRainAmb:stop()
		end)
    end
end)