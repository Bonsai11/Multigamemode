Respawn = {}
Respawn.data = {}
Respawn.fetchTimer = nil
Respawn.toggleKey = "enter"
Respawn.state = false
Respawn.fetchInterval = 50
Respawn.rewindKey = "backspace"
Respawn.isRewinding = false
Respawn.recording = false
Respawn.sound = nil
Respawn.speed = 1
Respawn.lastTick = 0
Respawn.respawned = false
Respawn.waitingForRelease = false
Respawn.releaseKeys = {}
Respawn.forbiddenModels = {425, 447, 520, 464, 432, 476}

function Respawn.main(map)

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
	Respawn.recording = true
	addEventHandler("onClientRender", root, Respawn.fetchData)
	addEventHandler("onClientArenaReset", root, Respawn.reset)
	addEventHandler("onClientColShapeHit", root, Respawn.pickupHit, true, "high")
	bindKey(Respawn.rewindKey, "both", Respawn.rewind)

end
addEvent("onClientMapStart", true)
addEventHandler("onClientMapStart", root, Respawn.main)


function Respawn.reset()

	if not Respawn.state then return end

	Respawn.state = false
	Respawn.data = {}
	Respawn.isRewinding = false
	Respawn.recording = false
	Respawn.respawned = false
	Respawn.waitingForRelease = false
	if isElement(Respawn.sound) then stopSound(Respawn.sound) end
	unbindKey(Respawn.toggleKey, "down", "res")
	unbindKey(Respawn.rewindKey, "both", Respawn.rewind)
	
	for i, key in pairs(Respawn.releaseKeys) do
	
		unbindKey(key, "down", Respawn.release)
	
	end
	
	Respawn.releaseKeys = {}
	
	removeEventHandler("onClientRender", root, Respawn.fetchData)
	removeEventHandler("onClientColShapeHit", root, Respawn.pickupHit)
	removeCommandHandler("res", Respawn.request)
	unbindKey("enter", "down", "suicide")
	removeEventHandler("onClientArenaReset", root, Respawn.reset)

end
addEvent("onClientArenaReset", true)


function Respawn.death()

	if not Respawn.state then return end

	triggerEvent("onClientCreateNotification", localPlayer, "Press Enter to respawn!", "information")

	Respawn.recording = false
	Respawn.respawned = false
	unbindKey("enter", "down", "suicide")
	unbindKey(Respawn.rewindKey, "both", Respawn.rewind)
	addCommandHandler("res", Respawn.request)
	bindKey(Respawn.toggleKey, "down", "res")
	
	Respawn.currentIndex = #Respawn.data
	
end
addEventHandler("onClientPlayerWasted", localPlayer, Respawn.death)


function Respawn.stop()

	Respawn.isRewinding = false
	setCameraTarget(localPlayer)
	if isElement(Respawn.sound) then stopSound(Respawn.sound) end
	
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

		Respawn.sound = playSound("wind.mp3", true)
		setSoundPosition(Respawn.sound, 1)
		Respawn.currentIndex = math.max(#Respawn.data, Respawn.speed)
		Respawn.isRewinding = true
		Respawn.recording = false
		toggleAllControls(false, true, false)

	else

		Respawn.stop()

	end

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
							   turX = select(1, getVehicleTurnVelocity(vehicle)), turY = select(2, getVehicleTurnVelocity(vehicle)), turZ = select(3, getVehicleTurnVelocity(vehicle)),
							   nitro = getVehicleUpgradeOnSlot(vehicle, 8), model = getElementModel(vehicle), isNosActive = isVehicleNitroActivated(vehicle),
							   camX = select(1, getCameraMatrix()), camY = select(2, getCameraMatrix()), camZ = select(3, getCameraMatrix()), roll = select(7, getCameraMatrix()),
							   camLX = select(4, getCameraMatrix()), camLY = select(5, getCameraMatrix()), camLZ = select(6, getCameraMatrix()), fov = select(8, getCameraMatrix())})

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

	fixVehicle(vehicle)
	setElementModel(vehicle, Respawn.data[Respawn.currentIndex].model)
	setElementPosition(vehicle, Respawn.data[Respawn.currentIndex].posX, Respawn.data[Respawn.currentIndex].posY, Respawn.data[Respawn.currentIndex].posZ)
	setElementRotation(vehicle, Respawn.data[Respawn.currentIndex].rotX, Respawn.data[Respawn.currentIndex].rotY, Respawn.data[Respawn.currentIndex].rotZ)
	addVehicleUpgrade(vehicle, Respawn.data[Respawn.currentIndex].nitro)
	setVehicleNitroActivated(vehicle, Respawn.data[Respawn.currentIndex].isNosActive)
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
	
	if #getCommandsBoundToKey("enter") ~= 0 then
	
		bindKey("enter", "down", "suicide")
	
	end
	
	for i, key in pairs(Respawn.releaseKeys) do
	
		unbindKey(key, "down", Respawn.release)
	
	end
	
	setElementVelocity(vehicle, Respawn.data[Respawn.currentIndex].velX, Respawn.data[Respawn.currentIndex].velY, Respawn.data[Respawn.currentIndex].velZ)
	setVehicleTurnVelocity(vehicle, Respawn.data[Respawn.currentIndex].turX, Respawn.data[Respawn.currentIndex].turY, Respawn.data[Respawn.currentIndex].turZ)
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