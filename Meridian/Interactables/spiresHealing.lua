local path = "Interactables/"
local shrine = Object.base("MapObject", "spiresHealing")
shrine.depth = -7
shrine.sprite = Sprite.load("SpiresHealing", path.."spiresHealing", 1, 23, 26)
local mask = Sprite.load("SpiresHealingMask", path.."spiresHealingMask", 1, 23, 6)

shrine:addCallback("create", function(self)
	local selfData = self:getData()
	
	selfData.spiresHealAmount = 9 * Difficulty.getScaling("hp")
	self.mask = mask
end)

shrine:addCallback("step", function(self)
	local selfData = self:getData()
	
	if global.timer % 60 == 0 then 
		local icicle = MonsterCard.find("Icicle", "meridian")
		if icicle then 
			local r = shrine.sprite.width
			local icicles = icicle.object:findAllEllipse(self.x - r, self.y - r, self.x + r, self.y + r)
			for _, actor in ipairs(icicles) do 
				if self:collidesWith(actor, self.x, self.y) and actor:get("hp") < actor:get("maxhp") then 
					actor:set("hp", math.min(actor:get("maxhp"), actor:get("hp") + selfData.spiresHealAmount))
					misc.damage(selfData.spiresHealAmount, actor.x, actor.y - 8, false, Color.DAMAGE_HEAL)
				end
			end
		end
	end
end)

