Freeroam = {}
local lastVisible
local lobbyActive

function Freeroam.load()

	lobbyActive = false
	lastVisible = false
	setTime(9,00)
	setWeather(3)
	setSkyGradient(60, 100, 196, 60, 100, 196 )
	setCameraMatrix(-1360, 1618, 100, -1450, 1200, 100)
	
	Freeroam.pvpZone = createColPolygon(-1436.8759765625, -354.572265625,
										-1227.5185546875, -695.99609375,
										-1227.171875, -552.2138671875,
										-1155.4853515625, -476.3330078125,
										-1119.13671875, -382.115234375,
										-1134.7119140625, -241.4609375,
										-1077.9892578125, -219.259765625,
										-1212.1474609375, -28.1845703125,
										-1154.376953125, 30.2353515625,
										-1243.763671875, 120.435546875,
										-1184.8935546875, 179.5234375,				
										-1229.25, 223.25,				
										-999.515625, 453.296875,				
										-1039.8232421875, 493.546875,				
										-1717.3935546875, -192.4453125,	
										-1733.7646484375, -618.2734375,
										-1624.259765625, -695.63671875)

	Freeroam.window = FreeroamWindow.new()

	bindKey("F3", "down", Freeroam.showPositionMap)
	setPlayerHudComponentVisible("weapon", true)
	setPlayerHudComponentVisible("ammo", true)
	setPlayerHudComponentVisible("radio", true)
	setPlayerHudComponentVisible("health", true)
	setPlayerHudComponentVisible("crosshair", true)
	setPlayerHudComponentVisible("armour", true)
	setPlayerHudComponentVisible("clock", true)
	addEventHandler("onClientSetDownFreeroamDefinitions", root, Freeroam.unload)
	addEventHandler("onClientLobbyDisable", root, Freeroam.enablePositionMap)	
	addEventHandler("onClientLobbyEnable", root, Freeroam.disablePositionMap)
	addEventHandler("onClientColShapeHit", Freeroam.pvpZone, Freeroam.enterZone)
	addEventHandler("onClientColShapeLeave", Freeroam.pvpZone, Freeroam.leaveZone)
	addEventHandler("onClientKey", root, Freeroam.shoot)	
	addEventHandler("onClientVehicleEnter", root, Freeroam.heliBlades)
	
	triggerEvent("onClientCreateNotification", localPlayer, "Press F3 to show the menu!", "information")
	
end
addEvent("onClientSetUpFreeroamDefinitions", true)
addEventHandler("onClientSetUpFreeroamDefinitions", root, Freeroam.load)


function Freeroam.unload()

	Freeroam.window.destroy()
	removeEventHandler("onClientLobbyDisable", root, Freeroam.enablePositionMap)
	removeEventHandler("onClientLobbyEnable", root, Freeroam.disablePositionMap)
	removeEventHandler("onClientSetDownFreeroamDefinitions", root, Freeroam.unload)
	removeEventHandler("onClientColShapeHit", Freeroam.pvpZone, Freeroam.enterZone)
	removeEventHandler("onClientColShapeLeave", Freeroam.pvpZone, Freeroam.leaveZone)
	removeEventHandler("onClientKey", root, Freeroam.shoot)
	removeEventHandler("onClientVehicleEnter", root, Freeroam.heliBlades)
	if getKeyBoundToFunction(Freeroam.showPositionMap) then unbindKey("F3", "down", Freeroam.showPositionMap) end
	setPlayerHudComponentVisible("weapon", false)
	setPlayerHudComponentVisible("ammo", false)
	setPlayerHudComponentVisible("health", false)
	setPlayerHudComponentVisible("armour", false)
	setPlayerHudComponentVisible("clock", false)
	setPlayerHudComponentVisible("radio", false)
	destroyElement(Freeroam.pvpZone)
	setRadioChannel(0)
	
end
addEvent("onClientSetDownFreeroamDefinitions", true)


function Freeroam.showPositionMap()

	if lobbyActive then return end

	if Freeroam.window.isVisible() then	
		Freeroam.window.setVisible(false)
		isVisible = false
	else
		Freeroam.window.setVisible(true)
		isVisible = true		
	end

end

function Freeroam.disablePositionMap()

	lastVisible = isVisible
	if Freeroam.window.isVisible() then Freeroam.showPositionMap() end
	lobbyActive = true	

end
addEvent("onClientLobbyEnable")


function Freeroam.enablePositionMap()

	lobbyActive = false	
	if lastVisible then Freeroam.showPositionMap() end
	lastVisible = false

end
addEvent("onClientLobbyDisable")


function Freeroam.enterZone(hitElement)
	
	if hitElement ~= localPlayer then return end

	outputChatBox("You have entered a PVP zone!", 255, 0, 0)
	
	toggleControl("fire", true)
	toggleControl("action", true)
	toggleControl("aim_weapon", true)
	
end


function Freeroam.leaveZone(leaveElement)

	if leaveElement ~= localPlayer then return end

	outputChatBox("You have left a PVP zone!", 0, 240, 0)

	toggleControl("fire", false)
	toggleControl("action", false)
	toggleControl("aim_weapon", false)
	
	setPedControlState(localPlayer, "fire", false)
	setPedControlState(localPlayer, "vehicle_fire", false)
	setPedControlState(localPlayer, "vehicle_secondary_fire", false)
		
end


function Freeroam.shoot(button, pressOrRelease)
	
	if not pressOrRelease then return end

	if isElementWithinColShape(localPlayer, Freeroam.pvpZone) then return end
	
	local vehicle = getPedOccupiedVehicle(localPlayer)
	
	if not vehicle then return end
	
	if getElementModel(vehicle) ~= 425 and getElementModel(vehicle) ~= 447 and getElementModel(vehicle) ~= 520 and getElementModel(vehicle) ~= 476 then return end
	
	local found = false
	
	for key, state in pairs(getBoundKeys("vehicle_fire")) do
			
		if key == button then
		
			found = true
			break
			
		end
		
	end	
	
	for key, state in pairs(getBoundKeys("vehicle_secondary_fire")) do
			
		if key == button then
		
			found = true
			break
			
		end
		
	end	
	
	if found then 
	
		cancelEvent()
		outputChatBox("You can only fight in a PVP zone!", 255, 0, 0)
	
	end
	
end


function Freeroam.getWeapon()

	if isElementWithinColShape(localPlayer, Freeroam.pvpZone) then return end
	
	setPedWeaponSlot(localPlayer, 0)
	
	outputChatBox("You can only fight in a PVP zone!", 255, 0, 0)

end
addEvent("onPlayerReceiveWeapon", true)
addEventHandler("onPlayerReceiveWeapon", root, Freeroam.getWeapon)


function Freeroam.heliBlades()

	setHeliBladeCollisionsEnabled(source, false)

end