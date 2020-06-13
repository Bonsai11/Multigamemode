Events = {}
Events.data = {}

function Events.requestAccess()

	local arenaElement = getElementParent(source)

	local access = false
	
	if exports["CCS"]:export_acl_check(source, "adminpanel") then 
	
		access = true
	
	end
	
	triggerClientEvent(source, "onClientEventsReceiveAccess", arenaElement, access)

end
addEvent("onEventsRequestAccess", true)
addEventHandler("onEventsRequestAccess", root, Events.requestAccess)


function Events.update(data)

	local arenaElement = getElementParent(source)
	
	if not Events.data[arenaElement] then
	
		Events.data[arenaElement] = {}
		
	end
	
	Events.data[arenaElement] = data
	
	triggerClientEvent(arenaElement, "onClientEventUpdate", arenaElement, data)

end
addEvent("onEventUpdate", true)
addEventHandler("onEventUpdate", root, Events.update)


function Events.send(arenaElement)

	if not Events.data[arenaElement] then return end

	triggerClientEvent(source, "onClientEventUpdate", arenaElement, Events.data[arenaElement])

end
addEvent("onPlayerJoinArena", true)
addEventHandler("onPlayerJoinArena", root, Events.send)


function Events.chat()

	local arenaElement = getElementParent(source)
	
	if not Events.data[arenaElement] then return end

	if Events.data[arenaElement].whitelist[source] then return end

	if Events.data[arenaElement].arenaChatDisable then
	
		outputChatBox("Error: Chat only allowed for players on whitelist!", source, 255, 0, 128)
		cancelEvent()
		
	end

end
addEvent("onPlayerArenaChat", false)
addEventHandler("onPlayerArenaChat", root, Events.chat)


function Events.spawn()

	local arenaElement = getElementParent(source)

	if not Events.data[arenaElement] then return end

	if not Events.data[arenaElement].sameSpawnpoint then return end

	local spawnpoints = exports["CCS"]:export_getSpawnPoints(arenaElement)

	if not spawnpoints then return end

	local vehicle = getPedOccupiedVehicle(source)

	setElementPosition(vehicle, spawnpoints[1].posX, spawnpoints[1].posY, spawnpoints[1].posZ)

	setElementRotation(vehicle, spawnpoints[1].rotX, spawnpoints[1].rotY, spawnpoints[1].rotZ)

end
addEvent("onPlayerDerbySpawn", false)
addEventHandler("onPlayerDerbySpawn", root, Events.spawn)


function Events.switchSpawnpoint()

	local arenaElement = getElementParent(source)

	if not Events.data[arenaElement] then return end

	if Events.data[arenaElement].spawnpointSwitching then return end

	outputChatBox("Error: Spawnpoint switching is disabled!", source, 255, 0, 128)

	cancelEvent()

end
addEvent("onPlayerSwitchSpawnpoint", false)
addEventHandler("onPlayerSwitchSpawnpoint", root, Events.switchSpawnpoint)

