local path = "Enemies/"
--logs
MonsterLog.new("Beta Construct1")
MonsterLog.new("Beta Construct2")
MonsterLog.new("Dewdrop")
MonsterLog.new("Stone Giant")
MonsterLog.new("Temple Marauder")
MonsterLog.new("Basalt Crab")
MonsterLog.new("Doomdrop")
MonsterLog.new("Lacertian")

-- enemies
require(path.."BasaltCrab.basaltCrab")
require(path.."construct1.con1")
require(path.."construct2.con2")
require(path.."guardDog.dog")
require(path.."stoneGiant.giant")
require(path.."mergers.mergerG")
require(path.."mergers.merger")
require(path.."mergers.mergerM")
require(path.."mergers.mergerS")

-- bosses
require(path.."Lacertian.lacertian")

registercallback("onStageEntry", function()
	local dD = misc.director:getData()
	if misc.director:get("stages_passed") >= 6 and dD.PLstages == false then
		dD.PLstages = true
	end
end)
