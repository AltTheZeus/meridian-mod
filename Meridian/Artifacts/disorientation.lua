local path = "Artifacts/"
local artifact = Artifact.new("Disorientation")
artifact.loadoutSprite = Sprite.load("DisorientationLoadoutSprite", path.."disorientation.png", 2, 18, 19)
artifact.loadoutText = "All stages are shuffled."
artifact.pickupSprite = Sprite.load("DisorientationPickup", path.."disorientationPickup.png", 1, 14, 13)
artifact.pickupName = "Artifact of Disorientation"

local artifactObj = artifact:getObject()

local stageBlacklist = {
	Stage.find("Risk of Rain", "vanilla")
}

if modloader.checkMod("ToolMaster") then 
	table.insert(stageBlacklist, Stage.find("DummyStage", "ToolMaster"))
end

if modloader.checkMod("Starstorm") then 
	table.insert(stageBlacklist, Stage.find("Mount of the Goats", "Starstorm"))
	table.insert(stageBlacklist, Stage.find("The Red Plane", "Starstorm"))
	table.insert(stageBlacklist, Stage.find("The Unknown", "Starstorm"))
	table.insert(stageBlacklist, Stage.find("The Void Shop", "Starstorm"))
	table.insert(stageBlacklist, Stage.find("Void End", "Starstorm"))
	table.insert(stageBlacklist, Stage.find("Void Gates", "Starstorm"))
	table.insert(stageBlacklist, Stage.find("Void Paths", "Starstorm"))
	table.insert(stageBlacklist, Stage.find("Void4", "Starstorm"))
end

callback.register("postLoad", function()

	local room = Room.find("Raininglake1", "meridian")
	if room then
		room:createInstance(artifactObj, 196, 516)
		room:createInstance(obj.ArtifactNoise, 196, 516)
	end

	prevStageProgression = {}
	local num = 1
	while Stage.getProgression(num) do
		prevStageProgression[num] = {}
		local stageAmount = Stage.getProgression(num):len()
		for j = 1, stageAmount do 
			table.insert(prevStageProgression[num], Stage.getProgression(num)[j])
		end	
		num = num + 1
	end
 
	disorientationActive = false
end)

callback.register("onGameStart", function()
	if artifact.active then 
		local MNAllStages = Stage.findAll()
		for i = 1, #stageBlacklist do 
			for j, stage in pairs(MNAllStages) do 
				if stage == stageBlacklist[i] then 
					table.remove(MNAllStages, j)
					break
				end
			end
		end
		print(#MNAllStages)
		disorientationStage1 = true 
		disorientationActive = true
		local stgAll = MNAllStages
		local num = 1
		while Stage.getProgression(num) do
			local stageAmount = Stage.getProgression(num):len()
			for j = 1, stageAmount do 
				Stage.getProgression(num):remove(Stage.getProgression(num)[1])
			end	
			num = num + 1
		end
		local stagesAmount = #MNAllStages
		for i = 1, stagesAmount do 	
			local stg = (i - 1) % 5 + 1
			local randomStage = math.random(1, #stgAll)
			Stage.getProgression(stg):add(stgAll[randomStage])
			table.remove(stgAll, randomStage)
		end
	elseif disorientationActive then
		disorientationStage1 = true 
		disorientationActive = false
		local num = 1
		while Stage.getProgression(num) do
			local stageAmount = Stage.getProgression(num):len()
			for j = 1, stageAmount do 
				Stage.getProgression(num):remove(Stage.getProgression(num)[1])
			end	
			num = num + 1
		end	
		for i = 1, #prevStageProgression do 
			for j = 1, #prevStageProgression[i] do 
				Stage.getProgression(i):add(prevStageProgression[i][j])
			end	
		end	
	end
end)

callback.register("onStageEntry", function()
	if disorientationStage1 then 
		disorientationStage1 = false
		if net.host then 
			--print("Stage ones:")
			--for _, stage in ipairs(Stage.getProgression(1):toTable()) do 
			--	print(stage.displayName)
			--end
			misc.director:set("stages_passed", misc.director:get("stages_passed") - 1)
			Stage.transport(Stage.progression[1][math.random(1, Stage.progression[1]:len())])
		end
	end
end)
