OnScreenMessage = {}
OnScreenMessage.__index = OnScreenMessage
setmetatable(OnScreenMessage, {__call = function (cls, ...) return cls.new(...) end,})
OnScreenMessage.instances = {}
OnScreenMessage.x, OnScreenMessage.y =  guiGetScreenSize()
OnScreenMessage.relX, OnScreenMessage.relY =  (OnScreenMessage.x/800), (OnScreenMessage.y/600)

function OnScreenMessage.new(message, horizontalPosition, color, scale, lifetime, fade, countdown)

    local self = setmetatable({}, OnScreenMessage)
	self.x = 0
	self.y = OnScreenMessage.y * horizontalPosition
	self.fontSize = scale
	self.font = "default"
	self.width = OnScreenMessage.x
	self.height = OnScreenMessage.y
	self.r, self.g, self.b = Util.hex2rgb(color or "#ffffff")
	self.alpha = 255
	self.postGUI = false
	self.message = message
	self.lifetime = lifetime
	self.countdown = countdown
	self.countValue = ""
	self.startTime = getTickCount()
	self.fade = fade
	self.fadeSpeed = 0.2
	self.delta = 0
	self.lastTick = nil
	self.lastCount = 0
	self.expired = false

	if self.fade then
	
		self.alpha = 0
		
	end
	
	OnScreenMessage.instances[self] = true
	
	return self
	
end


function OnScreenMessage:setText(message)

	self.message = message

end


function OnScreenMessage.draw()
	
	for self, _ in pairs(OnScreenMessage.instances) do
		
		if self.lastTick then
	
			self.delta = getTickCount() - self.lastTick
			self.delta = math.min(self.delta, (1/60)*1000)
		
		end
			
		self.lastTick = getTickCount()

		if not self.expired and self.alpha < 255 then
		
			self.alpha = self.alpha + self.fadeSpeed * self.delta
			self.alpha = math.min(self.alpha, 255)
		
		end
		
		if self.lifetime and getTickCount() - self.startTime > self.lifetime then
			
			self.expired = true
			
			if not self.fade then
			
				self:destroy()
				return
				
			else
				
				if self.alpha > 0 then
				
					self.alpha = self.alpha - self.fadeSpeed * self.delta
					self.alpha = math.max(self.alpha, 0)
			
				else
				
					self:destroy()
					return
			
				end
				
			end
			
		end

		if self.countdown and self.lifetime then
		
			self.countValue = math.round((self.lifetime - (getTickCount() - self.startTime))/1000)

		end
		
		dxDrawText(self.message:gsub('#%x%x%x%x%x%x', '')..self.countValue, self.x+1, self.y+1, self.x+self.width+1, self.y+self.height+1, tocolor (0, 0, 0, self.alpha), self.fontSize, self.font, "center", "top", false, false, self.postGUI, true, false)	
		dxDrawText(self.message..self.countValue, self.x, self.y, self.x+self.width, self.y+self.height, tocolor(self.r, self.g, self.b, self.alpha), self.fontSize, self.font, "center", "top", false, false, self.postGUI, true, false)

	end
		
end
addEventHandler("onClientRender", root, OnScreenMessage.draw)


function OnScreenMessage:destroy()

	OnScreenMessage.instances[self] = nil
	self = nil

end