callback.register("postLoad", function()
	if modloader.checkMod("LivelyWorld") then
        local ShallowRotlands = Stage.find("Shallow Rotlands", "meridian_stages")
        local MarshlandSanctuary = Stage.find("Marshland Sanctuary", "meridian_stages")
        local StarsweptValley = Stage.find("Starswept Valley", "meridian_stages")
        local BasaltQuarry = Stage.find("Basalt Quarry", "meridian_stages")
        local DissonantReliquary = Stage.find("Dissonant Reliquary", "meridian_stages")
        local HiveSavanna = Stage.find("Hive Savanna", "meridian_stages")

		--Lively World Tables
		LW.setStageData(ShallowRotlands, Color.fromHex(0x5A9978), false, true, 0.05)
		LW.setStageData(MarshlandSanctuary, Color.fromHex(0x8A995A), false, true, 0.12)
		LW.setStageData(StarsweptValley, Color.fromHex(0xFFFFFF), false, true, 0.09)
		LW.setStageData(BasaltQuarry, Color.fromHex(0x301B1B), false, true, 0.09)
		LW.setStageData(DissonantReliquary, Color.fromHex(0x3F626A), false, true, 0.01)
		LW.setStageData(HiveSavanna, Color.fromHex(0x984F41), false, true, 0.05)
--


		--Ambience
		local LushRainAmb = Sound.load("resources/LivelyWorld/LushRainAmb.ogg")
		local LushAmb = Sound.load("resources/LivelyWorld/LushAmb.ogg")
		local WindAmb = Sound.load("resources/LivelyWorld/WindAmb.ogg")
		local WindCalmAmb = Sound.load("resources/LivelyWorld/WindCalmAmb.ogg")
		local WindCrystalAmb = Sound.load("resources/LivelyWorld/WindCrystalAmb.ogg")
		local WindDryAmb = Sound.load("resources/LivelyWorld/WindDryAmb.ogg")

		callback.register("onStageEntry", function()
			--print(Stage.getCurrentStage().displayName)
			if Stage.getCurrentStage().displayName == "Shallow Rotlands" then
				LushAmb:loop()
			else
				LushAmb:stop()
			end
				
			if Stage.getCurrentStage().displayName == "Marshland Sanctuary" then
				LushRainAmb:loop()
			else
				LushRainAmb:stop()
			end

			if Stage.getCurrentStage().displayName == "Starswept Valley" then
				WindCrystalAmb:loop()
			else
				WindCrystalAmb:stop()
			end

			if Stage.getCurrentStage().displayName == "Dissonant Reliquary" then
				WindCalmAmb:loop()
			else
				WindCalmAmb:stop()
			end
			
			if Stage.getCurrentStage().displayName == "Basalt Quarry" then
				WindAmb:loop()
			else
				WindAmb:stop()
			end
			if Stage.getCurrentStage().displayName == "Hive Savanna" then
				WindDryAmb:loop()
			else
				WindDryAmb:stop()
			end
		end)
		callback.register("globalRoomEnd", function()
			WindAmb:stop()
			WindCalmAmb:stop()
			WindCrystalAmb:stop()
			LushRainAmb:stop()
			LushAmb:stop()
		end)

        --[[
        LW.backgroundData["Marshland Sanctuary"] = {
            skyColor = Color.fromHex(0xE6EAC2),
            elements = {
                {
                    baseSprite = Sprite.find("MarshlandBG1", "meridian_stages"),
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
                    baseSprite = Sprite.find("MarshlandBG2", "meridian_stages"),
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
                    baseSprite = Sprite.find("MarshlandClouds", "meridian_stages"),
                    xRepeat = true,
                    yRepeat = false,
                    xParallax = 0.9,
                    yParallax = 0.9,
                    xOffset = 0,
                    yOffset = 1,
                    xOffsetPercent = 0,
                    yOffsetPercent = 0.20,
                    xSpeed = 0.1,
                    ySpeed = 0
                },
                {
                    baseSprite = Sprite.find("MarshlandPlanet", "meridian_stages"),
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
                    baseSprite = Sprite.find("GreenSky", "meridian_stages"),
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
        ]]
	end
end)