local path = "Elites/"

require(path.."blessed")
require(path.."forsaken")
require(path.."bubble")
require(path.."sorrow")
require(path.."evoke")
--require(path.."erupt")
if not modloader.checkFlag("mn_disable_items") then 
	require("Items/gildedLeaf")
end
require(path.."blessedTree")
require(path.."blessedTree_E")

require(path.."eliteManager")

require(path.."eliteDefs")
require(path.."eliteChecker")