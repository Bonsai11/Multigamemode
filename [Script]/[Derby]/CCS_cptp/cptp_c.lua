CPTP = {}
CPTP.data = {}
CPTP.state = false
CPTP.releaseTimer = nil

function CPTP.create()

	local arenaElement = getElementParent(localPlayer)

	if not getElementData(arenaElement, "cptp") then return end

	local vehicle = getPedOccupiedVehicle(localPlayer)
	
	if not vehicle then return end

	CPTP.data = {}
	
	table.insert(CPTP.data, {posX = select(1, getElementPosition(vehicle)), posY = select(2, getElementPosition(vehicle)), posZ = select(3, getElementPosition(vehicle)),
							   rotX = select(1, getElementRotation(vehicle)), rotY = select(2, getElementRotation(vehicle)), rotZ = select(3, getElementRotation(vehicle)),
							   velX = select(1, getElementVelocity(vehicle)), velY = select(2, getElementVelocity(vehicle)), velZ = select(3, getElementVelocity(vehicle)),
							   turX = select(1, getElementAngularVelocity(vehicle)), turY = select(2, getElementAngularVelocity(vehicle)), turZ = select(3, getElementAngularVelocity(vehicle)),
							   nitro = getVehicleUpgradeOnSlot(vehicle, 8), model = getElementModel(vehicle), isNosActive = isVehicleNitroActivated(vehicle),
							   camX = select(1, getCameraMatrix()), camY = select(2, getCameraMatrix()), camZ = select(3, getCameraMatrix()), roll = select(7, getCameraMatrix()),
							   camLX = select(4, getCameraMatrix()), camLY = select(5, getCameraMatrix()), camLZ = select(6, getCameraMatrix()), fov = select(8, getCameraMatrix()),
							   nitroLevel = getVehicleNitroLevel(vehicle), health = getElementHealth(vehicle)})

	CPTP.state = true
	
	outputChatBox("CP/TP: Successfully create a checkpoint!", 255, 215, 0, true)
	
end


function CPTP.teleport()

	local arenaElement = getElementParent(localPlayer)

	if not getElementData(arenaElement, "cptp") then return end

	local vehicle = getPedOccupiedVehicle(localPlayer)
	
	if not vehicle then return end

	if not CPTP.state then
	
		outputChatBox("CP/TP: You need to create a checkpoint first!", 255, 215, 0, true)
		return
		
	end

	setElementFrozen(vehicle, true)
	setElementHealth(vehicle, CPTP.data[1].health)
	setElementModel(vehicle, CPTP.data[1].model)
	setElementPosition(vehicle, CPTP.data[1].posX, CPTP.data[1].posY, CPTP.data[1].posZ)
	setElementRotation(vehicle, CPTP.data[1].rotX, CPTP.data[1].rotY, CPTP.data[1].rotZ)
	addVehicleUpgrade(vehicle, CPTP.data[1].nitro)
	setVehicleNitroActivated(vehicle, CPTP.data[1].isNosActive)
	
	if CPTP.data[1].nitroLevel then
	
		setVehicleNitroLevel(vehicle, CPTP.data[1].nitroLevel)
		
	end
	
	setCameraMatrix(CPTP.data[1].camX, CPTP.data[1].camY, CPTP.data[1].camZ, CPTP.data[1].camLX, CPTP.data[1].camLY, CPTP.data[1].camLZ, CPTP.data[1].roll, CPTP.data[1].fov)
	setCameraTarget(localPlayer)
	
	triggerServerEvent('onSyncModel', localPlayer, CPTP.data[1].model)
		
	CPTP.releaseTimer = setTimer(CPTP.release, 1000, 1)
	
	outputChatBox("CP/TP: Successfully teleported! Get Ready...", 255, 215, 0, true)
	
end



function CPTP.release()

	local vehicle = getPedOccupiedVehicle(localPlayer)
	
	if not vehicle then return end

	setElementFrozen(vehicle, false)
	setElementVelocity(vehicle, CPTP.data[1].velX, CPTP.data[1].velY, CPTP.data[1].velZ)
	setElementAngularVelocity(vehicle, CPTP.data[1].turX, CPTP.data[1].turY, CPTP.data[1].turZ)

end


function CPTP.spawn()

	if not getElementData(source, "cptp") then return end

	addCommandHandler("tp", CPTP.teleport)
	addCommandHandler("cp", CPTP.create)
	
	outputChatBox("CP/TP: Use #00ff00/cp#ffd700 to create a checkpoint, #00ff00/tp#ffd700 to teleport to it!", 255, 215, 0, true)
	
end
addEvent('onClientMapStart', true)
addEventHandler('onClientMapStart', root, CPTP.spawn)


function CPTP.reset()

	removeCommandHandler("tp", CPTP.teleport)
	removeCommandHandler("cp", CPTP.create)
	CPTP.state = false
	CPTP.data = {}
	if isTimer(CPTP.releaseTimer) then killTimer(CPTP.releaseTimer) end
	
end
addEvent('onClientArenaReset', true)
addEventHandler('onClientArenaReset', root, CPTP.reset)
