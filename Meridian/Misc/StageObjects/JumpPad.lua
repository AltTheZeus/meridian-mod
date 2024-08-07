local sprJumpP = Sprite.load("resources/Objects/JumpPad", 1, 0, 0)
local JumpPad = Object.new("JumpPadBig")
local windCol = Color.fromHex(0xF32CFF)

JumpPad:addCallback("create", function(self)
    self.sprite = sprJumpP
	self.x = math.floor(self.x/16) * 16
	self.y = math.floor(self.y/16) * 16
	self:getData().speed = 0.12
end)
JumpPad:addCallback("step", function(self)
	for _, actor in ipairs(ParentObject.find("actors"):findAllRectangle(self.x, self.y, self.x + self.sprite.width * self.xscale, self.y + self.sprite.height * self.yscale)) do
		if actor:get("pVspeed") then
			actor:set("pVspeed", -13)
		end
        Sound.find("Geyser"):play()
	end
end)