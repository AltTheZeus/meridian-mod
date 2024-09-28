local path = "Enemies/"

-- enemies
require(path.."BasaltCrab.basaltCrab")
require(path.."construct1.con1")
require(path.."construct2.con2")
require(path.."guardDog.dog")
require(path.."stoneGiant.giant")
if modloader.checkFlag("enable_mergers") then
	require(path.."mergers.mergerG")
	require(path.."mergers.merger")
	require(path.."mergers.mergerM")
	require(path.."mergers.mergerS")
end

-- bosses
require(path.."Lacertian.lacertian")

registercallback("onStageEntry", function()
	local dD = misc.director:getData()
	if misc.director:get("stages_passed") >= 6 and dD.PLstages == false then
		dD.PLstages = true
	end
end)
