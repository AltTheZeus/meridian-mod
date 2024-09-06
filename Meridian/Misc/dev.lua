--Stage Counter
callback.register("onStageEntry", function(room)
	local stg = Stage.getCurrentStage().displayName
	local crtrm = Room.getCurrentRoom()
	local rm = crtrm:getName()

	StageValue = StageValue + 1
	
	print("StageValue " .. StageValue .." | "..stg.. " | "..rm)
end)
