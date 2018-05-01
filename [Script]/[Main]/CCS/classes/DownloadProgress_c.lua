DownloadProgress = {}
DownloadProgress.__index = DownloadProgress
setmetatable(DownloadProgress, {__call = function (cls, ...) return cls.new(...) end,})
DownloadProgress.instances = {}
DownloadProgress.x, DownloadProgress.y =  guiGetScreenSize()
DownloadProgress.relX, DownloadProgress.relY =  (DownloadProgress.x/800), (DownloadProgress.y/600)

function DownloadProgress.new()

    local self = setmetatable({}, DownloadProgress)
	self.fontSize = scale
	self.font = "default"
	self.width = DownloadProgress.x
	self.height = DownloadProgress.y
	self.currentTick = getTickCount()
	self.updateInterval = 500
	self.message = "Downloading, Please wait.."
	self.progress = 0
	self.displayMessage = OnScreenMessage.new(self.message, 0.9, "#ffffff", 1)
	
	DownloadProgress.instances[self] = true
	
	return self
	
end


function DownloadProgress.update()
	
	for self, _ in pairs(DownloadProgress.instances) do
	
		if getTickCount() - self.currentTick > self.updateInterval then
		
			self.currentTick = getTickCount()
			triggerServerEvent("onDownloadProgress", localPlayer)
		
		end

	end
		
end
addEventHandler("onClientRender", root, DownloadProgress.update, true, "low-2")


function DownloadProgress.setProgress(percent)
	
	for self, _ in pairs(DownloadProgress.instances) do
	
		self.progress = percent
		self.displayMessage:setText(self.message.."\n"..self.progress.."%")

	end
	
end
addEvent("onClientDownloadProgress", true)
addEventHandler("onClientDownloadProgress", root, DownloadProgress.setProgress)


function DownloadProgress:destroy()

	if self.displayMessage then
	
		self.displayMessage:destroy()
		self.displayMessage = nil
	
	end
	
	DownloadProgress.instances[self] = nil
	self = nil

end