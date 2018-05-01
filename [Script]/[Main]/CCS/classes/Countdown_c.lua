Countdown = {}
Countdown.x, Countdown.y =  guiGetScreenSize()
Countdown.relX, Countdown.relY =  (Countdown.x/800), (Countdown.y/600)

function Countdown.new(r, g, b)

    local self = {};
	self.x = Countdown.x/2
	self.y =  Countdown.y/2
	self.width = 474
	self.height = 204
	self.currentTick = 0
	self.currentCount = 4
	self.minCount = 0
	self.finished = false
	self.r = r or 255
	self.g = g or 255
	self.b = b or 255
	self.alpha = 255
	self.delta = 0
	self.lastTick = nil
	self.fadeSpeed = 0.2
	
	function self.start()
	
		self.currentTick = getTickCount()
		playSoundFrontEnd(43)
	
	end

	function self.draw()
	
		if self.lastTick then
		
			self.delta = getTickCount() - self.lastTick
			self.delta = math.min(self.delta, (1/60)*1000)
			
		end
		
		self.lastTick = getTickCount()
	
		if self.finished then return end
	
		if getTickCount() - self.currentTick > 1000 then
			
			self.currentTick = getTickCount()
			self.currentCount = self.currentCount - 1
			
			if self.currentCount > self.minCount then
			
				self.alpha = 255
				playSoundFrontEnd(43)
				
			elseif self.currentCount == self.minCount then
			
				self.alpha = 255
				playSoundFrontEnd(45)
			
			else 
			
				self.currentCount = self.minCount
			
				if self.alpha <= 0 then
				
					self.finished = true
					removeEventHandler("onClientRender", root, self.draw)
					return
				
				end
			
			end
		
		end
		
		self.alpha = self.alpha - self.fadeSpeed * self.delta
		dxDrawImage(self.x-(self.width/2), self.y-(self.height/2), self.width, self.height, "img/countdown/countdown_bg.png", 0, 0, 0, tocolor(self.r, self.g, self.b, math.max(0, self.alpha)), false)
		dxDrawImage(self.x-(self.width/2), self.y-(self.height/2), self.width, self.height, "img/countdown/countdown_"..self.currentCount..".png", 0, 0, 0, tocolor(255, 255, 255, math.max(0, self.alpha)), false)

	end
	addEventHandler("onClientRender", root, self.draw)

	function self.destroy()

		removeEventHandler("onClientRender", root, self.draw)
	
	end	
	
	return self
	
end


