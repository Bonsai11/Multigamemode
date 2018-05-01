Derby = {}
Derby.respawnData = {}
Derby.x, Derby.y = guiGetScreenSize()
Derby.relX, Derby.relY =  (Derby.x/800), (Derby.y/600)
Derby.setupRespawnTimer = nil
Derby.waterVehicle = { 539, 460, 417, 447, 472, 473, 493, 595, 484, 430, 453, 452, 446, 454 }

function Derby.load()

	setPedCanBeKnockedOffBike(localPlayer, false)
	Derby.waterTimer = setTimer(Derby.checkWater, 500, 0)
	addEventHandler("onClientSetDownDerbyDefinitions", root, Derby.unload)
	addEventHandler('onClientElementStreamIn', root, Derby.handleGhostMode)
	addEventHandler('onClientElementDataChange', root, Derby.handleGhostModeChange)	
	addEventHandler("onClientPlayerReady", root, Derby.loadingFinished)
	addEventHandler("onClientMapChange", root, Derby.setMapChangeScreen)
	addEventHandler("onClientMapEnding", root, Derby.setNextMapCountDown)
	addEventHandler("onClientPreMapStart", root, Derby.preMapStart)
	addEventHandler("onClientPreCountdown", root, Derby.preCountdown)
	addEventHandler("onClientCountdownStart", root, Derby.startCountdown)
	addEventHandler("onClientPlayerWin", root, Derby.winScreen)
	addEventHandler("onClientVoteStart", root, Derby.clear)
	addEventHandler("onClientMapStart", root, Derby.mapStart)
	
end
addEvent("onClientSetUpDerbyDefinitions", true)
addEventHandler("onClientSetUpDerbyDefinitions", root, Derby.load)


function Derby.unload()
	
	removeEventHandler("onClientSetDownDerbyDefinitions", root, Derby.unload)
	setPedCanBeKnockedOffBike(localPlayer, true)
	if isTimer(Derby.waterTimer) then killTimer(Derby.waterTimer) end
	removeEventHandler("onClientPlayerReady", root, Derby.loadingFinished)
	removeEventHandler("onClientMapChange", root, Derby.setMapChangeScreen)
	removeEventHandler("onClientMapEnding", root, Derby.setNextMapCountDown)
	removeEventHandler("onClientPreMapStart", root, Derby.preMapStart)
	removeEventHandler("onClientPreCountdown", root, Derby.preCountdown)
	removeEventHandler("onClientCountdownStart", root, Derby.startCountdown)
	removeEventHandler("onClientPlayerWin", root, Derby.winScreen)
	removeEventHandler("onClientVoteStart", root, Derby.clear)
	removeEventHandler("onClientMapStart", root, Derby.mapStart)
	removeEventHandler('onClientElementStreamIn', root, Derby.handleGhostMode)
	removeEventHandler('onClientElementDataChange', root, Derby.handleGhostModeChange)
	
end
addEvent("onClientSetDownDerbyDefinitions", true)


function Derby.reset()
	
	if Derby.nextMapCountDown then 
		
		Derby.nextMapCountDown:destroy()
		Derby.nextMapCountDown = nil
		
	end
	
	if Derby.countdown then 
	
		Derby.countdown.destroy() 
		Derby.countdown = nil
		
	end

	if Derby.timeUpMessage then 
	
		Derby.timeUpMessage:destroy() 
		Derby.timeUpMessage = nil
		
	end
	
	if Derby.waitingMessage then 
		
		Derby.waitingMessage:destroy() 
		Derby.waitingMessage = nil
		
	end
	
	if Derby.winMessage then 
	
		Derby.winMessage:destroy() 
		Derby.winMessage = nil
		
	end

	if Derby.mapInfoMessage then
	
		Derby.mapInfoMessage:destroy()
		Derby.mapInfoMessage = nil
	
	end
	
	if Derby.readyMessage then
	
		Derby.readyMessage:destroy()
		Derby.readyMessage = nil
		
	end
	
	if isTimer(Derby.rankTimer) then killTimer(Derby.rankTimer) end
	if isTimer(Derby.setupRespawnTimer) then killTimer(Derby.setupRespawnTimer) end
	if isElement(Derby.winSound) then destroyElement(Derby.winSound) end
	Derby.respawnData = {}
	Derby.checkpointList = {}
	setElementData(localPlayer, "checkpoint", false)
	setElementData(localPlayer, "racestate", false)
	setElementData(localPlayer, "no_collision", false)
	unbindKey("b", "down", "racespectate")
	removeCommandHandler("suicide", Derby.suicide)
	removeEventHandler("onClientColShapeHit", root, Derby.checkpoint)	
	removeEventHandler("onClientRender", root, Derby.render)
	removeEventHandler("onClientPlayerRespawn", root, Derby.respawn)
	removeEventHandler("onClientPlayerWasted", localPlayer, Derby.death)
	
	triggerEvent("onClientSetDownLinezDefinitions", source)
	
end
addEvent("onClientArenaReset", true)
addEventHandler("onClientArenaReset", root, Derby.reset)


function Derby.loadingFinished(duration, passed, waitTime, isRaceMap)

	if getElementData(source, "state") == "Waiting" then
		
		Derby.waitingMessage = OnScreenMessage.new("Waiting for other players..\n", 0.5, "#ffffff", 3, waitTime, false, true)
		
	end

	if Derby.loadingScreen then 
	
		Derby.loadingScreen:destroy()
		Derby.loadingScreen = nil
		
	end
	
	if Derby.mapInfoMessage then
	
		Derby.mapInfoMessage:destroy()
		Derby.mapInfoMessage = nil
	
	end
	
	setWindowFlashing(true, 3)
	
	local map = getElementData(source, "map")
	
	if not map then return end
	
	local color = getElementData(source, "color") or "#ffffff"

	Derby.mapInfoMessage = OnScreenMessage.new(color.."Name: #ffffff"..map.name.."\n "..color.."Author: #ffffff"..map.author.."\n "..color.."Type: #ffffff"..map.type, 0.75, "#ffffff", 2, 3000, true)
	
	if isRaceMap then

		setElementData(localPlayer, "checkpoint", 0)
		
		Derby.checkpointList = MapManager.getCheckpoints()
		
		Derby.setupCheckpoints(0)
			
		Derby.respawnData = {}
		
		Derby.setRespawnPoint()	

		Derby.rankTimer = setTimer(Derby.getDerbyPlayerRank, 1000, 0)
		
		addEventHandler("onClientColShapeHit", root, Derby.checkpoint)
		addEventHandler("onClientRender", root, Derby.render)
		addEventHandler("onClientPlayerWasted", localPlayer, Derby.death)
		addEventHandler("onClientPlayerRespawn", root, Derby.respawn)
		
		setElementData(localPlayer, "racestate", "0 / "..#Derby.checkpointList)
		
		bindKey("b", "down", "racespectate")
	
	end
	
	if map.type == "Linez" then
	
		triggerEvent("onClientSetUpLinezDefinitions", source)
	
	end
	
end
addEvent("onClientPlayerReady", true)


function Derby.setMapChangeScreen()
	
	if Derby.loadingScreen then 

		Derby.loadingScreen:destroy()
		Derby.loadingScreen = nil
		
	end
	
	Derby.loadingScreen = LoadingScreen.new()

end
addEvent("onClientMapChange", true)


function Derby.setNextMapCountDown(text, countTime, timeUp)

	if Derby.respawnInfo then
	
		Derby.respawnInfo:destroy()
		Derby.respawnInfo = nil
	
	end

	if timeUp then
	
		Derby.timeUpMessage = OnScreenMessage.new("Time's up!", 0.5, "#ff0000", 3)
		toggleAllControls(false, true, false)	
	
	end
	
	Derby.nextMapCountDown = OnScreenMessage.new(text.."\n", 0.75, "#ffffff", 2, countTime, false, true)

end
addEvent("onClientMapEnding", true)


function Derby.preMapStart()

	if Derby.waitingMessage then 
		
		Derby.waitingMessage:destroy() 
		Derby.waitingMessage = nil
		
	end

end
addEvent("onClientPreMapStart", true)


function Derby.preCountdown()

	Derby.readyMessage = OnScreenMessage.new("Ready! Waiting for start..\n", 0.5, "#ffffff", 3)

end
addEvent("onClientPreCountdown", true)


function Derby.startCountdown()

	if Derby.readyMessage then
	
		Derby.readyMessage:destroy()
		Derby.readyMessage = nil
		
	end

	local arenaElement = getElementParent(localPlayer)
	local color = getElementData(arenaElement, "color") or "#ffffff"
	local r, g, b = Util.hex2rgb(color)
	
	Derby.countdown = Countdown.new(r, g, b)

end
addEvent("onClientCountdownStart", true)


function Derby.mapStart(map)

	addCommandHandler("suicide", Derby.suicide)

end
addEvent("onClientMapStart", true)


function Derby.winScreen(player, message)

	Derby.winMessage = OnScreenMessage.new(message, 0.5, "#04B404", 3, 5000)

	if getElementData(player, "setting:winsound") then
	
		local soundName = getElementData(player, "setting:winsound")
		
		Derby.winSound = playSound("http://ddc.community/mta/mvp/"..soundName..".mp3", false)
		
	end
	
end
addEvent("onClientPlayerWin", true)


function Derby.clear()

	if Derby.winMessage then 
	
		Derby.winMessage:destroy()
		Derby.winMessage = nil
		
	end
	
	if Derby.timeUpMessage then 
	
		Derby.timeUpMessage:destroy()
		Derby.timeUpMessage = nil
		
	end
	
	if Derby.nextMapCountDown then 
		
		Derby.nextMapCountDown:destroy()
		Derby.nextMapCountDown = nil
		
	end

end
addEvent("onClientVoteStart", true)


function Derby.checkWater()

	local vehicle = getPedOccupiedVehicle(localPlayer)

	if not vehicle then return end
	
	if isElementFrozen(vehicle) then return end
	
	for i, model in pairs(Derby.waterVehicle) do
	
		if getElementModel(vehicle) == model then return end
	
	end
	
	local x, y, z = getElementPosition(vehicle)
	
	local waterZ = getWaterLevel(x, y, z)
	
	if waterZ and z < waterZ - 0.5 then
	
		setElementHealth(localPlayer, 0)
		
	end
	
	if not getVehicleEngineState(vehicle) then
	
		setVehicleEngineState(vehicle, true)
		
	end

end


function Derby.checkpoint(player, matchingDimension)
	
	if player ~= localPlayer then return end
	
	if not matchingDimension then return end
	
	if getElementData(player, "state") ~= "Alive" then return end
	
	if getElementData(source, "type") ~= "checkpoint" then return end
	
	local currentProgress = getElementData(localPlayer, "checkpoint")
	
	local nextCheckpoint = Derby.checkpointList[currentProgress + 1]
	
	if not nextCheckpoint then return end
	
	if source ~= nextCheckpoint.colshape then return end

	if getElementData(source, "vehicle") then
	
		triggerServerEvent("onPlayerDerbyPickupHit", localPlayer, "vehiclechange", tonumber(getElementData(source, "vehicle")))
		setElementModel(getPedOccupiedVehicle(localPlayer), tonumber(getElementData(source, "vehicle")))
		fixVehicle(getPedOccupiedVehicle(localPlayer))
		
	end
	
	playSoundFrontEnd(43)
	setElementData(localPlayer, "checkpoint", currentProgress + 1)
	setElementData(localPlayer, "racestate", (currentProgress + 1).." / "..#Derby.checkpointList)
	
	Derby.setRespawnPoint()
	
	local newNextCheckpoint = currentProgress + 1
	
	if not Derby.setupCheckpoints(newNextCheckpoint) then

		if not getElementData(localPlayer, "setting:winsound") then
			
			Derby.winSound = playSound("sound/winsong.mp3")
			
		end
		
		removeEventHandler("onClientPlayerWasted", localPlayer, Derby.death)
		triggerServerEvent("onFinishRace", localPlayer, localPlayer)
		
	end
	
end


function Derby.getDerbyPlayerRank()

	local rank = 1

	for i, p in pairs(getPlayersInArena(getElementParent(localPlayer))) do
	
		if getElementData(p, "checkpoint") then
	
			if (getElementData(p, "checkpoint") + 1) > (getElementData(localPlayer, "checkpoint") + 1) then
			
				rank = rank + 1
				
			end
		
		end

	end

	setElementData(localPlayer, "rank", rank)

end


function Derby.setRespawnPoint()
	
	local respawnIndex = getElementData(localPlayer, "checkpoint")
	
	local vehicle = getPedOccupiedVehicle(localPlayer)
	
	if not vehicle then return end
	
	Derby.respawnData[respawnIndex] = {}
	Derby.respawnData[respawnIndex].x, Derby.respawnData[respawnIndex].y, Derby.respawnData[respawnIndex].z = getElementPosition(vehicle)
	Derby.respawnData[respawnIndex].rx, Derby.respawnData[respawnIndex].ry, Derby.respawnData[respawnIndex].rz = getElementRotation(vehicle)
	Derby.respawnData[respawnIndex].sx, Derby.respawnData[respawnIndex].sy, Derby.respawnData[respawnIndex].sz = getElementVelocity(vehicle)
	Derby.respawnData[respawnIndex].tx, Derby.respawnData[respawnIndex].ty, Derby.respawnData[respawnIndex].tz = getVehicleTurnVelocity(vehicle)
	Derby.respawnData[respawnIndex].nitro = getVehicleUpgradeOnSlot(vehicle, 8)
	Derby.respawnData[respawnIndex].model = getElementModel(vehicle)

end


function Derby.setupCheckpoints(number)

	for i, checkpoint in pairs(Derby.checkpointList) do
	
		setElementDimension(checkpoint.marker, 0)
		setElementData(checkpoint.colshape, "next", false)
		setElementData(checkpoint.colshape, "afterNext", false)
	
	end

	local nextCheckpoint = Derby.checkpointList[number + 1]
	local afterNextCheckpoint = Derby.checkpointList[number + 2]
	
	if nextCheckpoint then
	
		setElementDimension(nextCheckpoint.marker, getElementDimension(localPlayer))
		setElementData(nextCheckpoint.colshape, "next", true)
		
	else
	
		return false
		
	end
	
	if afterNextCheckpoint then
	
		setElementDimension(afterNextCheckpoint.marker, getElementDimension(localPlayer))
		setElementData(afterNextCheckpoint.colshape, "afterNext", true)
		
		local x, y, z = getElementPosition(afterNextCheckpoint.marker)
		setMarkerTarget(nextCheckpoint.marker, x, y, z)

	else
	
		setMarkerIcon(nextCheckpoint.marker, "finish")
		
	end	
		
	return true
		
end


function Derby.death()
	
	Derby.setupRespawnTimer = setTimer(Derby.setupRespawn, 2000, 1)

end


function Derby.setupRespawn()

	fadeCamera(false, 0)
	toggleAllControls(false, true, false)

end


function Derby.respawn()
	
	fadeCamera(true, 1)
	toggleAllControls(true)
	
	local currentProgress = getElementData(localPlayer, "checkpoint")
		
	local newCheckpointNumber = currentProgress - 1
	
	if newCheckpointNumber < 0 then
	
		newCheckpointNumber = 0
		
	end
	
	Derby.setupCheckpoints(newCheckpointNumber)
	
	setElementData(localPlayer, "checkpoint", newCheckpointNumber)
	setElementData(localPlayer, "racestate", newCheckpointNumber.." / "..#Derby.checkpointList)

	local car = getPedOccupiedVehicle(localPlayer)
	setTimer(adjustAttributes, 1100, 1, car, newCheckpointNumber)
	setElementFrozen(car, true)
	fixVehicle(car)
	setElementPosition(car, Derby.respawnData[newCheckpointNumber].x, Derby.respawnData[newCheckpointNumber].y, Derby.respawnData[newCheckpointNumber].z)
	setElementRotation(car, Derby.respawnData[newCheckpointNumber].rx, Derby.respawnData[newCheckpointNumber].ry, Derby.respawnData[newCheckpointNumber].rz)
	triggerServerEvent('onPlayerDerbyPickupHit', localPlayer, "vehiclechange", Derby.respawnData[newCheckpointNumber].model)

end
addEvent("onClientPlayerRespawn", true)


function adjustAttributes(car, index)

	setElementFrozen(car, false)
	setElementModel(car, Derby.respawnData[index].model)
	setElementVelocity(car, Derby.respawnData[index].sx, Derby.respawnData[index].sy, Derby.respawnData[index].sz)
	setVehicleTurnVelocity(car, Derby.respawnData[index].tx, Derby.respawnData[index].ty, Derby.respawnData[index].tz)
	
	if Derby.respawnData[index].nitro == 1010 then addVehicleUpgrade(car, 1010) end
	
end


function Derby.render()

	local arenaElement = getElementParent(localPlayer)
	
	local target = getCameraTarget()

	if not target then return end
	
	if getElementType(target) == "vehicle" then
	
		target = getVehicleOccupant(target)
		
	end
	
	if not target then return end
	
	local currentCheckpointNumber = getElementData(target, "checkpoint")
	local position = getElementData(target, "rank")
	local players = #getPlayersInArena(arenaElement)
	local color = getElementData(arenaElement, "color") or "#999999"
	
	if Derby.lastCheckPointNumber and Derby.lastCheckPointNumber ~= currentCheckpointNumber then
	
		Derby.setupCheckpoints(currentCheckpointNumber)
	
	end
	
	Derby.lastCheckPointNumber = currentCheckpointNumber
	
	if position then

		dxDrawText("Position\n"..position.."/"..players.."\n\nCheckpoint\n"..currentCheckpointNumber.."/"..#Derby.checkpointList, 1, 1, Derby.x+1, Derby.y+1, tocolor ( 0, 0, 0, 255 ) , 2, "default-bold", "right", "center", false, false, false, true, false)		
		dxDrawText(color.."Position#ffffff\n"..position.."/"..players.."\n\n"..color.."Checkpoint#ffffff\n"..currentCheckpointNumber.."/"..#Derby.checkpointList, 0, 0, Derby.x, Derby.y, tocolor ( 255, 255, 255, 255 ) , 2, "default-bold", "right", "center", false, false, false, true, false)		

	end

end


function Derby.handleGhostMode()
	
	if getElementType(source) ~= "vehicle" and getElementType(source) ~= "player" then return end
		
	for _, other in ipairs(getElementsByType("vehicle")) do

		local docollide = not getElementData(source, 'no_collision') and not getElementData(other, 'no_collision')
		setElementCollidableWith(source, other, docollide)

	end
	
end


function Derby.handleGhostModeChange(dataName)

	if dataName ~= "no_collision" and dataName ~= "collideworld" then return end
		
	for _, other in ipairs(getElementsByType("vehicle")) do

		local docollide = not getElementData(source, 'no_collision') and not getElementData(other, 'no_collision')
		setElementCollidableWith(source, other, docollide)

	end

end


function Derby.suicide()

	setElementHealth(localPlayer, 0)

end

