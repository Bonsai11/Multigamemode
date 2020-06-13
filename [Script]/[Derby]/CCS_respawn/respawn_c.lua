Respawn = {}
Respawn.data = {}
Respawn.fetchTimer = nil
Respawn.toggleKey = "enter"
Respawn.state = false
Respawn.fetchInterval = 50
Respawn.rewindKey = "backspace"
Respawn.isRewinding = false
Respawn.recording = false
Respawn.speed = 1
Respawn.lastTick = 0
Respawn.respawned = false
Respawn.waitingForRelease = false
Respawn.releaseKeys = {}
Respawn.forbiddenModels = {425, 447, 520, 464, 432, 476}

function Respawn.main()
	
	if getElementData(localPlayer, "Spectator") then return end

	if not getElementData(source, "GhostMode") then return end

	--no respawn if its a racemap
	if exports["CCS"]:export_isRaceMap() then return end

	for key, state in pairs(getBoundKeys("accelerate")) do

		table.insert(Respawn.releaseKeys, key)

	end

	Respawn.state = true
	Respawn.data = {}
	Respawn.currentIndex = 1
	Respawn.fetchData()
	addEventHandler("onClientMapStart", root, Respawn.start)
	addEventHandler("onClientArenaReset", root, Respawn.reset)
	addEventHandler("onClientColShapeHit", root, Respawn.pickupHit, true, "high")
	addEventHandler("onClientPlayerWasted", localPlayer, Respawn.ready)
	bindKey(Respawn.rewindKey, "both", Respawn.rewind)

	local spawnpoint = exports["CCS"]:export_getSpawnPoints()[1]

	table.insert(Respawn.data, {posX = spawnpoint.posX, posY = spawnpoint.posY, posZ = spawnpoint.posZ,
							   rotX = spawnpoint.rotX, rotY = spawnpoint.rotY, rotZ = spawnpoint.rotZ,
							   velX = 0, velY = 0, velZ = 0,
							   turX = 0, turY = 0, turZ = 0,
							   nitro = 0, model = spawnpoint.modelID, isNosActive = false,
							   camX = 0, camY = 0, camZ = 0, roll = 0,
							   camLX = 0, camLY = 0, camLZ = 0, fov = 0})
	
	if not getPedOccupiedVehicle(localPlayer) then
		
		Respawn.ready()	
		
	end
	
	Respawn.recording = true	
	
end
addEvent("onClientPlayerReady", true)
addEventHandler("onClientPlayerReady", localPlayer, Respawn.main)


function Respawn.start()

	addEventHandler("onClientRender", root, Respawn.fetchData)

end
addEvent("onClientMapStart", true)


function Respawn.reset()

	if not Respawn.state then return end
	
	Respawn.state = false
	Respawn.data = {}
	Respawn.isRewinding = false
	Respawn.recording = false
	Respawn.respawned = false
	Respawn.waitingForRelease = false
	unbindKey(Respawn.toggleKey, "down", "res")
	unbindKey(Respawn.rewindKey, "both", Respawn.rewind)
		
	for i, key in pairs(Respawn.releaseKeys) do
	
		unbindKey(key, "down", Respawn.release)
	
	end
	
	Respawn.releaseKeys = {}
	
	removeEventHandler("onClientMapStart", root, Respawn.start)
	removeEventHandler("onClientRender", root, Respawn.fetchData)
	removeEventHandler("onClientColShapeHit", root, Respawn.pickupHit)
	removeCommandHandler("res", Respawn.request)
	unbindKey("enter", "down", Respawn.suicide)
	removeEventHandler("onClientArenaReset", root, Respawn.reset)
	removeEventHandler("onClientPlayerWasted", localPlayer, Respawn.ready)
	
end
addEvent("onClientArenaReset", true)


function Respawn.ready()

	if not Respawn.state then return end

	triggerEvent("onClientCreateNotification", localPlayer, "Press Enter to respawn!", "information")	
		
	if Respawn.respawned then
	
		triggerEvent("onClientRequestSpectatorMode", source)
	
	end
		
	Respawn.recording = false
	Respawn.respawned = false
	unbindKey("enter", "down", Respawn.suicide)
	unbindKey(Respawn.rewindKey, "both", Respawn.rewind)
	addCommandHandler("res", Respawn.request)
	bindKey(Respawn.toggleKey, "down", "res")

	Respawn.currentIndex = #Respawn.data
	
end


function Respawn.stop()

	Respawn.isRewinding = false
	setCameraTarget(localPlayer)
	
	if not Respawn.waitingForRelease then
		
		Respawn.release()

	end
		
end


function Respawn.rewind(key, keyState)

	local arenaElement = getElementParent(localPlayer)

	if not getElementData(arenaElement, "rewind") and not Respawn.respawned then return end

	local vehicle = getPedOccupiedVehicle(localPlayer)

	if not vehicle then return end

	if keyState == "down" then

		Respawn.currentIndex = math.max(#Respawn.data, Respawn.speed)
		Respawn.isRewinding = true
		Respawn.recording = false
		toggleAllControls(false, true, false)

	else

		Respawn.stop()

	end

end


function Respawn.suicide()

	setElementHealth(localPlayer, 0)

end


function Respawn.fetchData()

	local vehicle = getPedOccupiedVehicle(localPlayer)

	if not vehicle then return end

	if Respawn.isRewinding then

		for i=0, Respawn.speed-1, 1 do

			Respawn.data[Respawn.currentIndex-i] = nil

		end

		Respawn.currentIndex = Respawn.currentIndex - Respawn.speed

		if Respawn.currentIndex <= Respawn.speed then


			Respawn.currentIndex = Respawn.speed
			Respawn.stop()
			return

		end

		Respawn.useData(Respawn.currentIndex)

		return

	end

	if not Respawn.recording then return end

	if getTickCount() - Respawn.lastTick < Respawn.fetchInterval then return end

	Respawn.lastTick = getTickCount()

	table.insert(Respawn.data, {posX = select(1, getElementPosition(vehicle)), posY = select(2, getElementPosition(vehicle)), posZ = select(3, getElementPosition(vehicle)),
							   rotX = select(1, getElementRotation(vehicle)), rotY = select(2, getElementRotation(vehicle)), rotZ = select(3, getElementRotation(vehicle)),
							   velX = select(1, getElementVelocity(vehicle)), velY = select(2, getElementVelocity(vehicle)), velZ = select(3, getElementVelocity(vehicle)),
							   turX = select(1, getElementAngularVelocity(vehicle)), turY = select(2, getElementAngularVelocity(vehicle)), turZ = select(3, getElementAngularVelocity(vehicle)),
							   nitro = getVehicleUpgradeOnSlot(vehicle, 8), model = getElementModel(vehicle), isNosActive = isVehicleNitroActivated(vehicle),
							   camX = select(1, getCameraMatrix()), camY = select(2, getCameraMatrix()), camZ = select(3, getCameraMatrix()), roll = select(7, getCameraMatrix()),
							   camLX = select(4, getCameraMatrix()), camLY = select(5, getCameraMatrix()), camLZ = select(6, getCameraMatrix()), fov = select(8, getCameraMatrix()),
							   nitroLevel = getVehicleNitroLevel(vehicle), health = getElementHealth(vehicle)})

end


function Respawn.request()
	
	for i = 50, 1, -1 do
	
		if Respawn.currentIndex == 1 then break end

		Respawn.data[Respawn.currentIndex] = nil
		
		Respawn.currentIndex = Respawn.currentIndex - 1
		
	end	
	
	for i, model in pairs(Respawn.forbiddenModels) do
	
		if Respawn.data[Respawn.currentIndex].model == model then

			Respawn.data[Respawn.currentIndex].model = 594
			break
			
		end
	
	end
	
	triggerServerEvent("onPlayerRequestRespawn", localPlayer, Respawn.data[Respawn.currentIndex].model)

end


function Respawn.respawn()

	if not Respawn.state then return end

	Respawn.useData(Respawn.currentIndex)
	toggleAllControls(false, true, false)
	
	for i, key in pairs(Respawn.releaseKeys) do
	
		bindKey(key, "down", Respawn.release)
	
	end
	
	Respawn.waitingForRelease = true
	unbindKey(Respawn.toggleKey, "down", "res")
	bindKey(Respawn.rewindKey, "both", Respawn.rewind)
	removeCommandHandler("res", Respawn.request)
	Respawn.respawned = true

	triggerEvent("onClientCreateNotification", localPlayer, "Press accelerate to drive, hold backspace to rewind.", "success")

end
addEvent("onClientPlayerRespawn", true)
addEventHandler("onClientPlayerRespawn", root, Respawn.respawn)


function Respawn.useData()

	local vehicle = getPedOccupiedVehicle(localPlayer)

	if not vehicle then return end

	for i, model in pairs(Respawn.forbiddenModels) do
	
		if Respawn.data[Respawn.currentIndex].model == model then

			Respawn.data[Respawn.currentIndex].model = 594
			break
			
		end
	
	end

	setElementHealth(vehicle, Respawn.data[Respawn.currentIndex].health)
	setElementModel(vehicle, Respawn.data[Respawn.currentIndex].model)
	setElementPosition(vehicle, Respawn.data[Respawn.currentIndex].posX, Respawn.data[Respawn.currentIndex].posY, Respawn.data[Respawn.currentIndex].posZ)
	setElementRotation(vehicle, Respawn.data[Respawn.currentIndex].rotX, Respawn.data[Respawn.currentIndex].rotY, Respawn.data[Respawn.currentIndex].rotZ)
	addVehicleUpgrade(vehicle, Respawn.data[Respawn.currentIndex].nitro)
	setVehicleNitroActivated(vehicle, Respawn.data[Respawn.currentIndex].isNosActive)
	
	if Respawn.data[Respawn.currentIndex].nitroLevel then
	
		setVehicleNitroLevel(vehicle, Respawn.data[Respawn.currentIndex].nitroLevel)
		
	end
	
	setCameraMatrix(Respawn.data[Respawn.currentIndex].camX, Respawn.data[Respawn.currentIndex].camY, Respawn.data[Respawn.currentIndex].camZ, Respawn.data[Respawn.currentIndex].camLX, Respawn.data[Respawn.currentIndex].camLY, Respawn.data[Respawn.currentIndex].camLZ, Respawn.data[Respawn.currentIndex].roll, Respawn.data[Respawn.currentIndex].fov)
	setCameraTarget(localPlayer)
	setElementFrozen(vehicle, true)

end


function Respawn.release() 

	if not Respawn.currentIndex then return end

	local vehicle = getPedOccupiedVehicle(localPlayer)

	if not vehicle then return end

	Respawn.waitingForRelease = false
	setElementFrozen(vehicle, false)
	toggleAllControls(true)
	
	bindKey("enter", "down", Respawn.suicide)

	for i, key in pairs(Respawn.releaseKeys) do
	
		unbindKey(key, "down", Respawn.release)
	
	end
	
	setElementVelocity(vehicle, Respawn.data[Respawn.currentIndex].velX, Respawn.data[Respawn.currentIndex].velY, Respawn.data[Respawn.currentIndex].velZ)
	setElementAngularVelocity(vehicle, Respawn.data[Respawn.currentIndex].turX, Respawn.data[Respawn.currentIndex].turY, Respawn.data[Respawn.currentIndex].turZ)
	Respawn.currentIndex = nil

	Respawn.recording = true

end


function Respawn.pickupHit()

	if getElementData(localPlayer, "state") ~= "Respawned" then return end

	local type = getElementData(source, "type")

	if type ~= "vehiclechange" then return end
	
	local model = getElementData(source, "model")
	
	for i, forbidden_model in pairs(Respawn.forbiddenModels) do
	
		if model == forbidden_model then
			
			setElementData(source, "cancelled", true)
			break
			
		end
	
	end
	
end


function Respawn.getRecordedData()

	if not Respawn.data then return false end

	return Respawn.data

end
export_getRecordedData = Respawn.getRecordedData