Training = {}
local lastVisible
local lobbyActive

function Training.load()

	lobbyActive = false
	lastVisible = false
	setTime(9,00)
	setWeather(3)
	setSkyGradient(60, 100, 196, 60, 100, 196 )
	setCameraMatrix(-1360, 1618, 100, -1450, 1200, 100)
	
	Training.trainingWindow = TrainingWindow.new()

	bindKey("F3", "down", Training.showMapsChooseWindow)
	addEventHandler("onClientLobbyEnable", root, Training.disableWindow)
	addEventHandler("onClientLobbyDisable", root, Training.enableWindow)
	addEventHandler("onRecieveMapList", root, Training.recieveMaps)
	addEventHandler("showMapsChooseWindow", root, Training.showMapsChooseWindow)
	addEventHandler("onClientPlayerTrainingWasted", root, Training.reset)
	addEventHandler("onClientSetDownTrainingDefinitions", root, Training.unload)
	
	setTimer(Training.showMapsChooseWindow, 1000, 1)
	
	triggerServerEvent("onRequestMapList", localPlayer, getElementData(getElementParent(localPlayer), "type"))	
	
	triggerEvent("onClientCreateNotification", localPlayer, "Press F3 to show the map selection!", "information")
	
end
addEvent("onClientSetUpTrainingDefinitions", true)
addEventHandler("onClientSetUpTrainingDefinitions", root, Training.load)


function Training.unload()
	
	if getKeyBoundToFunction(Training.showMapsChooseWindow) then unbindKey("F3", "down", Training.showMapsChooseWindow) end
	if Training.trainingWindow then Training.trainingWindow.destroy() end
	removeEventHandler("onClientLobbyEnable", root, Training.disableWindow)
	removeEventHandler("onClientLobbyDisable", root, Training.enableWindow)
	removeEventHandler("onRecieveMapList", root, Training.recieveMaps)
	removeEventHandler("showMapsChooseWindow", root, Training.showMapsChooseWindow)
	removeEventHandler("onClientPlayerTrainingWasted", root, Training.reset)
	removeEventHandler("onClientSetDownTrainingDefinitions", root, Training.unload)	
	
end
addEvent("onClientSetDownTrainingDefinitions", true)


function Training.recieveMaps(maps)

	Training.trainingWindow.update(maps)

end
addEvent("onRecieveMapList", true)


function Training.showMapsChooseWindow()

	if lobbyActive then return end

	if Training.trainingWindow.isVisible() then
		Training.trainingWindow.setVisible(false)
	else
		Training.trainingWindow.setVisible(true)
	end

end
addEvent("showMapsChooseWindow", true)


function Training.disableWindow()

	lastVisible = Training.trainingWindow.isVisible()
	if Training.trainingWindow.isVisible() then Training.showMapsChooseWindow() end
	lobbyActive = true

end
addEvent("onClientLobbyEnable")


function Training.enableWindow()

	lobbyActive = false
	if lastVisible then Training.showMapsChooseWindow() end
	lastVisible = false	

end
addEvent("onClientLobbyDisable")


function Training.reset()
	
	--If its a race map, player will be in Waiting state for respawn
	if getElementData(localPlayer, "state") ~= "Dead" then return end
	
	Training.showMapsChooseWindow()
	
end
addEvent("onClientPlayerTrainingWasted", true)
