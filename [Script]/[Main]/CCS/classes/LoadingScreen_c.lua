LoadingScreen = {}
LoadingScreen.__index = LoadingScreen
setmetatable(LoadingScreen, {__call = function (cls, ...) return cls.new(...) end,})
LoadingScreen.instances = {}
LoadingScreen.x, LoadingScreen.y =  guiGetScreenSize()
LoadingScreen.relX, LoadingScreen.relY =  (LoadingScreen.x/800), (LoadingScreen.y/600)
LoadingScreen.url = "http://mta/CCS/img/loadingscreen/html/index.html"
LoadingScreen.browser = createBrowser(LoadingScreen.x, LoadingScreen.y, true, false)

function LoadingScreen.new()

    local self = setmetatable({}, LoadingScreen)
	
	self.x = 0
	self.y = 0
	self.width = LoadingScreen.x
	self.height = LoadingScreen.y
	self.currentTick = getTickCount()
	self.updateInterval = 500
	fadeCamera(false, 0)
	executeBrowserJavascript(LoadingScreen.browser, "setProgress('0%');")
	setBrowserRenderingPaused(LoadingScreen.browser, false)
	LoadingScreen.instances[self] = true

	return self
	
end 


function LoadingScreen.update()

	for self, _ in pairs(LoadingScreen.instances) do
	
		if getTickCount() - self.currentTick > self.updateInterval then
		
			self.currentTick = getTickCount()
			triggerServerEvent("onDownloadProgress", localPlayer)
		
		end
		
		local arenaElement = getElementParent(localPlayer)
		
		local color = getElementData(arenaElement, "color") or "#ffffff"
	
		executeBrowserJavascript(LoadingScreen.browser, "changeColor('"..color.."');")
		
		dxDrawImage(0, 0, LoadingScreen.x, LoadingScreen.y, LoadingScreen.browser, 0, 0, 0, tocolor(255,255,255,255), false)
		
	end
	
end
addEventHandler("onClientRender", root, LoadingScreen.update, true, "low-2")


function LoadingScreen.setProgress(percent)
	
	executeBrowserJavascript(LoadingScreen.browser, "setProgress('"..percent.."%');")
	
end
addEvent("onClientDownloadProgress", true)
addEventHandler("onClientDownloadProgress", root, LoadingScreen.setProgress)


function LoadingScreen.browserCreated()
	
	loadBrowserURL(source, LoadingScreen.url)
		
end
addEventHandler("onClientBrowserCreated", LoadingScreen.browser, LoadingScreen.browserCreated)

	
function LoadingScreen:destroy()
	
	LoadingScreen.instances[self] = nil
	fadeCamera(true, 3.0)
	setBrowserRenderingPaused(LoadingScreen.browser, true)
	self = nil
	
end
