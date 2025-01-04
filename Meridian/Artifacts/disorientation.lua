local path = "Artifacts/"
local artifact = Artifact.new("Disorientation")
artifact.loadoutSprite = Sprite.load("DisorientationLoadoutSprite", path.."disorientation.png", 2, 18, 19)
artifact.loadoutText = "All stages are shuffled."
artifact.pickupSprite = Sprite.load("DisorientationPickup", path.."disorientationPickup.png", 1, 14, 13)
artifact.pickupName = "Artifact of Disorientation"
artifact.unlocked = true

callback.register("postLoad", function()
	prevStageProgression = {}
	for i = 1, 5 do 
		prevStageProgression[i] = {}
		for j = 1, Stage.progression[i]:len() do 
			table.insert(prevStageProgression[i], Stage.progression[i][j])
		end	
	end	
end)

callback.register("onGameStart", function()
	disorientationStage1 = true 
	if artifact.active then 
		local stgAll = {}
		for i = 1, 5 do 
			for j = 1, Stage.progression[i]:len() do 
				table.insert(stgAll, Stage.progression[i][j])
			end	
		end
		for i = 1, 5 do 
			for j = 1, #prevStageProgression[i] do 
				Stage.progression[i]:remove(Stage.progression[i][1])
			end
		end
		for i = 1, 5 do 
			for j = 1, #prevStageProgression[i] do 
				local rng = math.random(1, #stgAll)
				Stage.progression[i]:add(stgAll[rng])
				table.remove(stgAll, rng)
			end
		end
	else
		for i = 1, 5 do 
			local progrAmount = Stage.progression[i]:len()
			for j = 1, progrAmount do 
				Stage.progression[i]:remove(Stage.progression[i][1])
			end
		end
		for i = 1, 5 do 
			for j = 1, #prevStageProgression[i] do 
				Stage.progression[i]:add(prevStageProgression[i][j])
			end	
		end	
	end
end)

callback.register("onStageEntry", function()
	if disorientationStage1 then 
		disorientationStage1 = false
		if net.host then 
			Stage.transport(Stage.progression[1][math.random(1, Stage.progression[1]:len())])
		end
	end
end)
