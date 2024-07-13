local path = "Enemies."

require(path.."monsterLib")
require(path.."BasaltCrab.basaltCrab")
require(path.."construct1.con1")
require(path.."construct2.con2")
require(path.."guardDog.dog")
require(path.."stoneGiant.giant")

registercallback("onStageEntry", function()
	local dD = misc.director:getData()
	if misc.director:get("stages_passed") >= 6 and dD.PLstages == false then
		dD.PLstages = true
	end
end)