Derby = {}
Derby.spawnIndex = {}
Derby.spawnpoints = {}
Derby.isRaceMap = {}
Derby.finishedPlayers = {}
Derby.playerSpawn = {}
Derby.playerVehicles = {}
Derby.integrityTimer = {}
Derby.isHunterFight = {}

function Derby.load()

	outputServerLog(getElementID(source)..": Loading Derby Definitions")

	addEventHandler("onPlayerWasted", source, Derby.mapEnd)
	addEventHandler("onPlayerRequestSpawn", source, Derby.spawn)
	addEventHandler("onMapStart", source, Derby.mapStart)
	addEventHandler("onSetDownDerbyDefinitions", source, Derby.unload)
	addEventHandler("onPlayerDerbyPickupHit", source, Derby.handleHunter)
	addEventHandler("onFinishRace", source, Derby.mapEnd)
	addEventHandler("onPlayerWasted", source, Derby.killDerbyPlayer)
	addEventHandler("onPlayerQuit", source, Derby.killDerbyPlayer)
	addEventHandler("onVehicleExplode", source, Derby.removeVehicle)
	addEventHandler("onMapChange", source, Derby.mapChange)
	addEventHandler("onArenaReset", source, Derby.reset)
	addEventHandler("onSetMapStartCountdown", source, Derby.setMapStartCountdown)
	addEventHandler("onPrepareCountdown", source, Derby.prepareMapCountdown)
	addEventHandler("onCountdownStart", source, Derby.doCountdown)
	addEventHandler("onMapLoading", source, Derby.loadNewMap)
	addEventHandler("onMapEnd", source, Derby.forceEndMap)
	addEventHandler("onPreMapEnd", source, Derby.mapPreEnd)
	addEventHandler("onPlayerDerbySpawn", source, Derby.playerReady)
		
	if getElementData(source, "mode") ~= "Training" then

		if getElementData(source, "temporary") then

			local map = MapManager.findMap("Airport Dogfight DD", "Classic")[1]
		
			if not map then
			
				map = MapManager.getRandomArenaMap()
				
			end
		
			triggerEvent("onStartNewMap", source, map, false)

		else
		
			local typ = getElementData(source, "type")

			triggerEvent("onStartNewMap", source, MapManager.getRandomArenaMap(typ), false)

		end
		
	end
	
end
addEvent("onSetUpDerbyDefinitions", true)
addEventHandler("onSetUpDerbyDefinitions", root, Derby.load)


function Derby.mapChange(map)

	Derby.spawnIndex[source] = 1
	Derby.isRaceMap[source] = false
	setElementData(source, "GhostMode", true)
	setElementData(source, "finishTime", 3000)
	Derby.playerSpawn[source] = {}
	Derby.finishedPlayers[source] = 0
	Derby.spawnpoints[source] = MapManager.getSpawnpoints(source)

	if map.type == "Shooter" then

		setElementData(source, "GhostMode", false)

	elseif map.type == "Cross" then

		setElementData(source, "GhostMode", false)

	elseif map.type == "Hunter" then

		setElementData(source, "GhostMode", false)

	elseif map.type == "Linez" then

		setElementData(source, "GhostMode", false)
		
		triggerEvent("onSetUpLinezDefinitions", source)
		
	end
	
	if MapManager.getIsRaceMap(source) then
	
		Derby.isRaceMap[source] = true
		setElementData(source, "finishTime", 20000)
	
	end

	setElementData(source, "state", "Waiting")

	Derby.integrityTimer[source] = setTimer(Derby.integrityCheck, 2000, 0, source)

end
addEvent("onMapChange")


function Derby.reset()

	for i, player in pairs(getPlayersInArena(source)) do

		if Derby.playerVehicles[player] and isElement(Derby.playerVehicles[player]) then

			destroyElement(Derby.playerVehicles[player])

		end

	end

	Derby.playerSpawn[source] = {}
	Derby.spawnpoints[source] = {}
	Derby.isHunterFight[source] = false
	if isTimer(Derby.integrityTimer[source]) then killTimer(Derby.integrityTimer[source]) end
	if isTimer(Arena.timers[source].hunterFightTimer) then killTimer(Arena.timers[source].hunterFightTimer) end
	triggerEvent("onSetDownLinezDefinitions", source)

end
addEvent("onArenaReset")


function Derby.unload()

	outputServerLog(getElementID(source)..": Unloading Derby Definitions")

	removeEventHandler("onVehicleExplode", source, Derby.removeVehicle)
	removeEventHandler("onPlayerWasted", source, Derby.killDerbyPlayer)
	removeEventHandler("onPlayerQuit", source, Derby.killDerbyPlayer)
	removeEventHandler("onPlayerWasted", source, Derby.mapEnd)
	removeEventHandler("onPlayerRequestSpawn", source, Derby.spawn)
	removeEventHandler("onMapStart", source, Derby.mapStart)
	removeEventHandler("onSetDownDerbyDefinitions", source, Derby.unload)
	removeEventHandler("onPlayerDerbyPickupHit", source, Derby.handleHunter)
	removeEventHandler("onFinishRace", source, Derby.mapEnd)
	removeEventHandler("onMapChange", source, Derby.mapChange)
	removeEventHandler("onArenaReset", source, Derby.reset)
	removeEventHandler("onSetMapStartCountdown", source, Derby.setMapStartCountdown)
	removeEventHandler("onPrepareCountdown", source, Derby.prepareMapCountdown)
	removeEventHandler("onCountdownStart", source, Derby.doCountdown)
	removeEventHandler("onMapLoading", source, Derby.loadNewMap)
	removeEventHandler("onMapEnd", source, Derby.forceEndMap)
	removeEventHandler("onPreMapEnd", source, Derby.mapPreEnd)
	removeEventHandler("onPlayerDerbySpawn", source, Derby.playerReady)

end
addEvent("onSetDownDerbyDefinitions")


function Derby.setMapStartCountdown()

	if isTimer(Arena.timers[source].secondaryTimer) then killTimer(Arena.timers[source].secondaryTimer) end

	triggerClientEvent(source, "onClientPreMapStart", source)

	Arena.timers[source].secondaryTimer = setTimer(triggerEvent, 2000, 1, "onPrepareCountdown", source)

end
addEvent("onSetMapStartCountdown", true)


function Derby.prepareMapCountdown()
	
	setElementData(source, "state", "Ready")

	if getElementData(source, "mode") == "Manual" then

		triggerClientEvent(source, "onClientPreCountdown", source)
	
		outputChatBox("Arena Mode: 'Manual' - Use /run to start the countdown!", source, 255, 255, 0)
		return

	elseif getElementData(source, "mode") == "Competitive" then
	
		return
		
	end

	triggerEvent("onCountdownStart", source)
	
end
addEvent("onPrepareCountdown", true)


function Derby.doCountdown()
	
	Arena.timers[source].secondaryTimer = setTimer(triggerEvent, 3000, 1, "onMapStart", source, getElementData(source, "map"))

	setElementData(source, "state", "Countdown")

	triggerClientEvent(source, "onClientCountdownStart", source)

	outputServerLog(getElementID(source)..": Countdown Start")

end
addEvent("onCountdownStart", true)


function Derby.loadNewMap()

	if #getElementData(source, "nextmap") > 0 then

		local nextmap = getElementData(source, "nextmap")

		triggerEvent("onStartNewMap", source, nextmap[1], true)
		
		table.remove(nextmap, 1)

		setElementData(source, "nextmap", nextmap)

	else

		if getElementData(source, "mode") == "Random" then

			local typ = getElementData(source, "type")

			triggerEvent("onStartNewMap", source, MapManager.getRandomArenaMap(typ), true)

		elseif getElementData(source, "mode") == "Voting" then

			triggerEvent("onStartVote", source)

		end

	end

end
addEvent("onMapLoading", true)


function Derby.forceEndMap()

	if getElementData(source, "mode") == "Manual" then

		outputChatBox("Arena Mode: 'Manual' - Use /redo, /goto, /force or /random to continue!", source, 255, 255, 0)

	elseif #getElementData(source, "nextmap") > 0 then

		triggerClientEvent(source, "onClientMapEnding", source, "Next map starts in: ", 7000)
		
		Arena.timers[source].secondaryTimer = setTimer(triggerEvent, 7000, 1, "onMapLoading", source)

	elseif getElementData(source, "mode") == "Random" then

		triggerClientEvent(source, "onClientMapEnding", source, "Random map starts in: ", 7000)
		
		Arena.timers[source].secondaryTimer = setTimer(triggerEvent, 7000, 1, "onMapLoading", source)

	elseif getElementData(source, "mode") == "Voting" then

		triggerClientEvent(source, "onClientMapEnding", source, "Vote for next map starts in: ", 7000)
		
		Arena.timers[source].secondaryTimer = setTimer(triggerEvent, 7000, 1, "onMapLoading", source)

	end

end
addEvent("onMapEnd", true)


function Derby.mapPreEnd(timeUp)

	if getElementData(source, "mode") == "Training" then return end

	if getElementData(source, "state") ~= "In Progress" then return end

	setElementData(source, "state", "End")

	local finishTime = getElementData(source, "finishTime") or 3000

	if getElementData(source, "podium") then
	
		Arena.timers[source].secondaryTimer = setTimer(triggerEvent, finishTime, 1, "onMapEnd", source)

		triggerClientEvent(source, "onClientPreMapEnd", source, "Map will end in: ", finishTime, timeUp)

	else
	
		triggerEvent("onMapEnd", source)
	
	end

end
addEvent("onPreMapEnd", true)


function Derby.handleHunter(type, model)
	
	if type ~= "vehiclechange" then return end

	if not getPedOccupiedVehicle(source) then return end
	
	if model == 425 then
		
		local arenaElement = getElementParent(source)
		
		local isFirst = not Derby.isHunterFight[arenaElement]
		
		toggleControl(source, "vehicle_secondary_fire", false)

		if #getAlivePlayersInArena(arenaElement) == 1 then

			triggerEvent("onPreMapEnd", arenaElement)

		else
			
			if not Derby.isHunterFight[arenaElement] then
				
				--Max 1 minute to finish after a player got hunter
				Arena.timers[arenaElement].hunterFightTimer = setTimer(triggerEvent, 180000, 1, "onPreMapEnd", arenaElement, true)
				
				Derby.isHunterFight[arenaElement] = true
			
			end

		end
		
		triggerEvent("onPlayerHunterPickup", source, isFirst)
			
		triggerClientEvent(arenaElement, "onClientPlayerHunterPickup", source, isFirst)	
			
	else

		toggleControl(source, "vehicle_secondary_fire", true)

	end

end
addEvent("onPlayerDerbyPickupHit", true)


function Derby.mapEnd()

	local arenaElement = getElementParent(source)

	if getElementData(source, "state") ~= "Alive" then return end

	triggerClientEvent(arenaElement, "onClientCreateMessage", arenaElement, getPlayerName(source).."#ff0000 died!", "right")	
	
	if Derby.isRaceMap[arenaElement] and eventName == "onPlayerWasted" then

		setElementData(source, "state", "Waiting")

		setTimer(Derby.respawn, 3000, 1, source)

		return

	end

	if Derby.isRaceMap[arenaElement] and eventName == "onFinishRace" then

		Derby.finishedPlayers[arenaElement] = Derby.finishedPlayers[arenaElement] + 1
		
		triggerEvent("onPlayerFinishRace", source, Derby.finishedPlayers[arenaElement])
		
		setElementData(source, "state", "Finished")
		
		toggleAllControls(source, false, true, false)
		
		triggerClientEvent(source, "onClientRequestSpectatorMode", source)

		--Only for the winner of the Race
		if Derby.finishedPlayers[arenaElement] ~= 1 then return end

		triggerClientEvent(arenaElement, "onClientPlayerWin", source, "#ffffff"..getPlayerName(source).."#04B404 has won the Race!")
		
		triggerEvent("onPlayerWin", source, getCleanPlayerName(source))
		
		triggerEvent("onPlayerRaceWin", source, getCleanPlayerName(source))
		
		triggerEvent("onPreMapEnd", arenaElement)

		return

	end

	--Race can still be finished even if map was already won, Derby cant
	if getElementData(arenaElement, "state") ~= "In Progress" then return end

	triggerEvent("onPlayerDerbyWasted", source, #getAlivePlayersInArena(arenaElement))

	triggerClientEvent(source, "onClientRequestSpectatorMode", source)

	setElementData(source, "state", "Dead")
	
	setElementAlpha(source, 0)

	if #getAlivePlayersInArena(arenaElement) == 1  then

		local alivePlayers = getAlivePlayersInArena(arenaElement)
		
		triggerClientEvent(arenaElement, "onClientPlayerWin", alivePlayers[1], "#ffffff"..getPlayerName(alivePlayers[1]).."#04B404 has won as last player alive!")

		triggerEvent("onPlayerWin", alivePlayers[1], getCleanPlayerName(alivePlayers[1]))

		Derby.finishedPlayers[arenaElement] = 1

		if not getElementData(arenaElement, "GhostMode") or getElementModel(getPedOccupiedVehicle(alivePlayers[1])) == 425 then

			triggerEvent("onPreMapEnd", arenaElement)

		end

	elseif #getAlivePlayersInArena(arenaElement) == 0 then

		triggerEvent("onPreMapEnd", arenaElement)

	end

end
addEvent("onFinishRace", true)


function Derby.respawn(player)

	if not isElement(player) then return end

	local arenaElement = getElementParent(player)

	if getElementData(arenaElement, "state") == "End" then return end

	if getElementData(player, "state") ~= "Waiting" then return end

	spawnPlayer(player, 0, 0, 3, 0, 0, 0, getElementDimension(arenaElement))
	
	setElementAlpha(player, 255)
	
	setElementFrozen(player, false)
	
	bindKey(player, "enter", "down", "suicide")
	
	Derby.createPlayerVehicle(player, 1)
	
	setElementData(player, "state", "Alive")

	triggerClientEvent(player, "onClientPlayerRespawn", arenaElement)

end


function Derby.stayInVehicle()

	cancelEvent()

end


function Derby.createPlayerVehicle(player, spawnID)

	local arenaElement = getElementParent(player)

	local localVehicle = createVehicle(Derby.spawnpoints[arenaElement][spawnID].modelID, Derby.spawnpoints[arenaElement][spawnID].posX, Derby.spawnpoints[arenaElement][spawnID].posY, Derby.spawnpoints[arenaElement][spawnID].posZ,
						Derby.spawnpoints[arenaElement][spawnID].rotX, Derby.spawnpoints[arenaElement][spawnID].rotY, Derby.spawnpoints[arenaElement][spawnID].rotZ)

	setElementParent(localVehicle, arenaElement)

	if getElementData(arenaElement, "forced_vehicle_color") then
	
		local color = getElementData(arenaElement, "forced_vehicle_color")
		local r, g, b = getColorFromString(color)
		setVehicleColor(localVehicle, r, g, b)
	
	elseif getPlayerTeam(player) then

		local r, g, b = getTeamColor(getPlayerTeam(player))
		setVehicleColor(localVehicle, r, g, b)

	elseif getElementData(player, "setting:car_color") then

		local color = getElementData(player, "setting:car_color")
		local color2 = getElementData(player, "setting:car_color2")
		local r, g, b = getColorFromString(color)
		local r2, g2, b2 = getColorFromString(color2)
		setVehicleColor(localVehicle, r, g, b, r2, g2, b2)

	else

		local color = getElementData(arenaElement, "color")
		local r, g, b = getColorFromString(color)
		setVehicleColor(localVehicle, r, g, b)

	end

	setElementDimension(localVehicle, getElementDimension(arenaElement))
	setElementData(localVehicle, "no_collision", true)
	warpPedIntoVehicle(player, localVehicle)
	setVehicleOverrideLights(localVehicle, 2)
	setVehicleVariant(localVehicle)
	Derby.playerVehicles[player] = localVehicle
	setCameraTarget(player, player)
	addEventHandler("onVehicleStartExit", localVehicle, Derby.stayInVehicle)

	if getElementData(arenaElement, "GhostMode") then

		setElementData(localVehicle, "no_collision", true)

	else

		setElementData(localVehicle, "no_collision", false)

	end
	
end


function Derby.spawn()

	local arenaElement = getElementParent(source)
	local elementID = getElementID(arenaElement)

	outputServerLog(elementID..": Spawn Request by: "..getPlayerName(source))

	if getElementData(source, "Spectator") then

		triggerClientEvent(source, "onClientRequestSpectatorMode", source, true)
		triggerClientEvent(source, "onClientPlayerReady", arenaElement, getElementData(arenaElement, "Duration"), Core.getTimePassed(arenaElement), Derby.getWaitingTime(arenaElement), Derby.isRaceMap[arenaElement])

		return

	end

	if getElementData(arenaElement, "state") ~= "Waiting" and getElementData(arenaElement, "state") ~= "Ready" and getElementData(arenaElement, "state") ~= "Countdown" then

		if not Derby.isRaceMap[arenaElement] then

			triggerClientEvent(source, "onClientRequestSpectatorMode", source, true)
			triggerClientEvent(source, "onClientPlayerReady", arenaElement, getElementData(arenaElement, "Duration"), Core.getTimePassed(arenaElement), Derby.getWaitingTime(arenaElement), Derby.isRaceMap[arenaElement])

			return

		else

			bindKey(source, "enter", "down", "suicide")
			toggleAllControls(source, true, true, true)
			setElementFrozen(source, false)

		end

	end

	if Derby.spawnIndex[arenaElement] > #Derby.spawnpoints[arenaElement] then
	
		--If Ghostmode then start from first spawn again
		if getElementData(arenaElement, "GhostMode") then

			Derby.spawnIndex[arenaElement] = 1

		else

			spawnPlayer(source, 0, 0, 3, 0, 0, 0, getElementDimension(arenaElement))
			setElementAlpha(source, 255)
			triggerClientEvent(source, "onClientRequestSpectatorMode", source, true)
			triggerClientEvent(source, "onClientPlayerReady", arenaElement, getElementData(arenaElement, "Duration"), Core.getTimePassed(arenaElement), Derby.getWaitingTime(arenaElement), Derby.isRaceMap[arenaElement])

			return

		end

	end

	spawnPlayer(source, 0, 0, 3, 0, 0, 0, getElementDimension(arenaElement))
	setElementAlpha(source, 255)
	setElementFrozen(source, false)

	Derby.createPlayerVehicle(source, Derby.spawnIndex[arenaElement])
	
	setElementData(source, "state", "Alive")

	if getElementData(arenaElement, "state") == "Waiting" or getElementData(arenaElement, "state") == "Ready" or getElementData(arenaElement, "state") == "Countdown" then

		setElementFrozen(getPedOccupiedVehicle(source), true)
		setElementFrozen(source, false)
		toggleAllControls(source, false, true, false)
		toggleControl(source, "change_camera", true)
		toggleControl(source, "horn", true)
		toggleControl(source, "enter_passenger", false)
		setVehicleDamageProof(getPedOccupiedVehicle(source), true)

	end

	setCameraTarget(source, source)
	setPedStat(source, 160, 1000)
	setPedStat(source, 229, 1000)
	setPedStat(source, 230, 1000)
	Derby.playerSpawn[arenaElement][source] = Derby.spawnIndex[arenaElement]
	Derby.spawnIndex[arenaElement] = Derby.spawnIndex[arenaElement] + 1

	bindKey(source, "arrow_r", "down", Derby.switchSpawnpoint)
	bindKey(source, "arrow_l", "down", Derby.switchSpawnpoint)
	bindKey(source, "mouse_wheel_up", "down", Derby.switchSpawnpoint)
	bindKey(source, "mouse_wheel_down", "down", Derby.switchSpawnpoint)

	triggerClientEvent(source, "onClientPlayerReady", arenaElement, getElementData(arenaElement, "Duration"), Core.getTimePassed(arenaElement), Derby.getWaitingTime(arenaElement), Derby.isRaceMap[arenaElement])

	triggerEvent("onPlayerDerbySpawn", source)

end
addEvent("onPlayerRequestSpawn", true)


function Derby.playerReady()

	local arenaElement = getElementParent(source)

	local arenaID = getElementID(arenaElement)
	
	--Handle map start
	if getElementData(arenaElement, "state") ~= "Waiting" then return end

	if not isTimer(Arena.timers[arenaElement].secondaryTimer) and getElementData(arenaElement, "mode") ~= "Competitive" then

		Arena.timers[arenaElement].secondaryTimer = setTimer(triggerEvent, getElementData(arenaElement, "timer:waitingForPlayers"), 1, "onSetMapStartCountdown", arenaElement)

	end
	
	local onlinePlayers = #getPlayersInArena(arenaElement)
	
	local readyPlayers = #getAlivePlayersInArena(arenaElement)

	if getElementData(arenaElement, "mode") == "Competitive" and onlinePlayers < 2 then
	
		return
		
	end		
	
	if readyPlayers < onlinePlayers then return end

	outputServerLog(arenaID..": All players ready!")

	triggerEvent("onSetMapStartCountdown", arenaElement)

end
addEvent("onPlayerDerbySpawn")


function Derby.mapStart()

	Arena.timers[source].primaryTimer = setTimer(triggerEvent, getElementData(source, "Duration"), 1, "onPreMapEnd", source, true)

	triggerClientEvent(source, "onClientMapStart", source, getElementData(source, "map"))
	
	setElementData(source, "state", "In Progress")

	outputServerLog(getElementID(source)..": Map Start")

	for i, p in ipairs(getAlivePlayersInArena(source)) do

		if not getPedOccupiedVehicle(p) then

			warpPedIntoVehicle(p, Derby.playerVehicles[p])

		end

		if getPedOccupiedVehicle(p) then

			toggleAllControls(p, true)
			bindKey(p, "enter", "down", "suicide")
			setElementFrozen(getPedOccupiedVehicle(p), false)
			setElementFrozen(p, false)
			setVehicleDamageProof(getPedOccupiedVehicle(p), false)

			if getElementModel(getPedOccupiedVehicle(p)) == 425 then

				toggleControl(p, "vehicle_secondary_fire", false)

			else

				toggleControl(p, "vehicle_secondary_fire", true)

			end

		else

			setElementHealth(p, 0)
			outputChatBox("No vehicle found for player: "..getPlayerName(p):gsub('#%x%x%x%x%x%x', ''), source, 255, 0, 0)

		end

		unbindKey(p, "arrow_r", "down", Derby.switchSpawnpoint)
		unbindKey(p, "arrow_l", "down", Derby.switchSpawnpoint)
		unbindKey(p, "mouse_wheel_up", "down", Derby.switchSpawnpoint)
		unbindKey(p, "mouse_wheel_down", "down", Derby.switchSpawnpoint)

	end
	
end


function Derby.integrityCheck(arenaElement)

	if getElementData(arenaElement, "state") == "End" then return end

	for i, p in ipairs(getAlivePlayersInArena(arenaElement)) do

		if getElementData(p, "state") == "Alive" then

			if not getPedOccupiedVehicle(p) then

				if isElement(Derby.playerVehicles[p]) then

					warpPedIntoVehicle(p, Derby.playerVehicles[p])

				else

					setElementHealth(p, 0)
					outputChatBox("No vehicle found for player: "..getPlayerName(p):gsub('#%x%x%x%x%x%x', ''), arenaElement, 255, 0, 0)

				end

			end

		end

	end

end


function Derby.switchSpawnpoint(keyPresser, key, keyState)

	if keyState ~= "down" then return end

	if not getPedOccupiedVehicle(keyPresser) then return end

	local arenaElement = getElementParent(keyPresser)

	if not getElementData(arenaElement, "GhostMode") then return end

	if getElementData(arenaElement, "state") ~= "Waiting" and getElementData(arenaElement, "state") ~= "Countdown" and getElementData(arenaElement, "state") ~= "Ready" then return end

	triggerEvent("onPlayerSwitchSpawnpoint", keyPresser)

	if wasEventCancelled() then return end

	local direction

	if key == "arrow_r" or key == "mouse_wheel_up" then

		direction = 1

	else

		direction = -1

	end

	local myCurrentSpawn = Derby.playerSpawn[arenaElement][keyPresser]

	local newIndex = myCurrentSpawn + direction

	if newIndex < 1 then

		newIndex = #Derby.spawnpoints[arenaElement]

	elseif newIndex > #Derby.spawnpoints[arenaElement] then

		newIndex = 1

	end

	setElementModel(getPedOccupiedVehicle(keyPresser), Derby.spawnpoints[arenaElement][newIndex].modelID)
	setElementPosition(getPedOccupiedVehicle(keyPresser), Derby.spawnpoints[arenaElement][newIndex].posX, Derby.spawnpoints[arenaElement][newIndex].posY, Derby.spawnpoints[arenaElement][newIndex].posZ)
	setElementRotation(getPedOccupiedVehicle(keyPresser), Derby.spawnpoints[arenaElement][newIndex].rotX, Derby.spawnpoints[arenaElement][newIndex].rotY, Derby.spawnpoints[arenaElement][newIndex].rotZ)

	Derby.playerSpawn[arenaElement][keyPresser] = newIndex

end


function Derby.killDerbyPlayer()

	if not isElement(source) then return end

    unbindKey(source, "enter", "down", "suicide")

	toggleAllControls(source, false, true, false)

	local playerVehicle = getPedOccupiedVehicle(source)

    if not isPedDead(source) then

        killPed(source)
		removePedFromVehicle(source)

    end

    if Derby.playerVehicles[source] and isElement(Derby.playerVehicles[source]) then

        setTimer(Derby.destroyVehicle, 4000, 1, Derby.playerVehicles[source])
		Derby.playerVehicles[source] = nil

    end

    if isElement(playerVehicle) then

        setTimer(Derby.destroyVehicle, 4000, 1, playerVehicle)

    end

end


function Derby.destroyVehicle(vehicle)

	if isElement(vehicle) then

		destroyElement(vehicle)

	end

end


function Derby.removeVehicle()

	setTimer(Derby.destroyVehicle, 4000, 1, source)

end


function Derby.getWaitingTime(arenaElement)

	if getElementData(arenaElement, "state") ~= "Waiting" then return false end

	if not isTimer(Arena.timers[arenaElement].secondaryTimer) then return getElementData(arenaElement, "timer:waitingForPlayers") end

	return getTimerDetails(Arena.timers[arenaElement].secondaryTimer)

end