BattleRoyale = {}
BattleRoyale.plane = {}
BattleRoyale.planeobject = {}
BattleRoyale.round = {}
BattleRoyale.origin = {}
BattleRoyale.maxRounds = 5
BattleRoyale.roundDuration = 60000
BattleRoyale.planeFlyTime = 60000
BattleRoyale.startRadius = 1500
BattleRoyale.cirlceOrigins = {}
BattleRoyale.cirlceOrigins["Los Santos"] = {x = 1450, y = -1066}
BattleRoyale.cirlceOrigins["San Fierro"] = {x = -1807, y = -272}
BattleRoyale.cirlceOrigins["Las Venturas"] = {x = 959, y = 1734}
BattleRoyale.wallMoving = {}
BattleRoyale.pickups = {}
BattleRoyale.vehicles = {}
BattleRoyale.markers = {}
BattleRoyale.pickupToMarker = {}
BattleRoyale.spawns = {}
BattleRoyale.spawns["Los Santos"] = {}
BattleRoyale.spawns["San Fierro"] = {}
BattleRoyale.spawns["Las Venturas"] = {}

BattleRoyale.pickupSpawns = {}
BattleRoyale.pickupSpawns["Los Santos"] = {}
BattleRoyale.pickupSpawns["San Fierro"] = {}
BattleRoyale.pickupSpawns["Las Venturas"] = {}

BattleRoyale.vehicleSpawns = {}
BattleRoyale.vehicleSpawns["Los Santos"] = {}
BattleRoyale.vehicleSpawns["San Fierro"] = {}
BattleRoyale.vehicleSpawns["Las Venturas"] = {}
	
BattleRoyale.weapons = {{9, 1}, {16, 5}, {18, 5}, {22, 60}, {23, 60}, {24, 60}, {25, 15}, {26, 15}, {27, 15}, {28, 150}, {29, 150}, {30, 150}, {31, 150}, {32, 150}, {33, 10}, {34, 10}, {37, 30}}
BattleRoyale.vehicleModels = {581, 602, 496, 401, 518, 527, 589, 419, 587, 533, 526, 474, 545, 517, 410, 600, 436, 439, 549, 491, 445, 507, 585, 466, 516, 550, 566, 540, 421, 499, 422, 420, 418, 440, 579, 400, 505, 475, 429, 415, 451, 411, 506}

BattleRoyale.time = {}

function BattleRoyale.start()

	local xml = xmlLoadFile("conf/battleroyale.xml")
	
	for i, group in ipairs(xmlNodeGetChildren(xml)) do
	
		local mode = xmlNodeGetAttribute(group, "mode")
		
		if xmlNodeGetName(group) == "pickups" then

			for i, child in ipairs(xmlNodeGetChildren(group)) do
			
				local posX = xmlNodeGetAttribute(child, "posX")
				local posY = xmlNodeGetAttribute(child, "posY")
				local posZ = xmlNodeGetAttribute(child, "posZ")
			
				table.insert(BattleRoyale.pickupSpawns[mode], {posX, posY, posZ})
				
			end
		
		elseif xmlNodeGetName(group) == "vehicles" then

			for i, child in ipairs(xmlNodeGetChildren(group)) do
			
				local posX = xmlNodeGetAttribute(child, "posX")
				local posY = xmlNodeGetAttribute(child, "posY")
				local posZ = xmlNodeGetAttribute(child, "posZ")
				local rotZ = xmlNodeGetAttribute(child, "rotZ")
			
				table.insert(BattleRoyale.vehicleSpawns[mode], {posX, posY, posZ, rotZ})
				
			end
				
		elseif xmlNodeGetName(group) == "spawns" then

			for i, child in ipairs(xmlNodeGetChildren(group)) do
			
				local posX = xmlNodeGetAttribute(child, "posX")
				local posY = xmlNodeGetAttribute(child, "posY")
				local posZ = xmlNodeGetAttribute(child, "posZ")
			
				table.insert(BattleRoyale.spawns[mode], {posX, posY, posZ})
				
			end
				
		end
		
	end

	xmlUnloadFile(xml)

end
addEventHandler("onResourceStart", resourceRoot, BattleRoyale.start)


function BattleRoyale.load()

	outputServerLog(getElementID(source)..": Loading Battle Royale Definitions")

	addEventHandler("onUnloadBattleRoyaleDefinitions", source, BattleRoyale.unload)
	addEventHandler("onPlayerRequestSpawn", source, BattleRoyale.spawn)
	addEventHandler("onMapChange", source, BattleRoyale.mapChange)
	addEventHandler("onCountdownStart", source, BattleRoyale.doCountdown)
	addEventHandler("onMapStart", source, BattleRoyale.mapStart)
	addEventHandler("onPlayerLeaveArena", source, BattleRoyale.quit)
	addEventHandler("onPlaneReachFinalPosition", source, BattleRoyale.planeFinish)
	addEventHandler("onPlayerRequestExitPlane", source, BattleRoyale.exitPlane)
	addEventHandler("onMatchStart", source, BattleRoyale.matchStart)
	addEventHandler("onRoundEnd", source, BattleRoyale.roundEnd)
	addEventHandler("onRoundStart", source, BattleRoyale.roundStart)
	addEventHandler("onPlayerWasted", source, BattleRoyale.playerDeath)
	addEventHandler("onMapEnd", source, BattleRoyale.mapEnd)
	addEventHandler("onMapLoading", source, BattleRoyale.mapLoading)
	addEventHandler("onArenaReset", source, BattleRoyale.reset)
	addEventHandler("onVehicleStartEnter", source, BattleRoyale.vehicleEnter)
	addEventHandler("onPickupUse", source, BattleRoyale.pickupUse)
	addEventHandler("onPickupSpawn", source, BattleRoyale.pickupSpawn)
	addEventHandler("onPlayerChooseCharacter", source, BattleRoyale.chooseCharacter)
	addEventHandler("onPreMapEnd", source, BattleRoyale.preMapEnd)	
	
	BattleRoyale.round[source] = 0
	BattleRoyale.origin[source] = {}
	BattleRoyale.wallMoving[source] = false
	BattleRoyale.pickups[source] = {}
	BattleRoyale.vehicles[source] = {}
	BattleRoyale.markers[source] = {}
	BattleRoyale.time[source] = {}
	
	local mode = getElementData(source, "mode")
	local type = getElementData(source, "type")
	local map = MapManager.findMap("Battle Royale - "..mode, type)

	triggerEvent("onStartNewMap", source, map[1], false)

end
addEvent("onLoadBattleRoyaleDefinitions", true)
addEventHandler("onLoadBattleRoyaleDefinitions", root, BattleRoyale.load)


function BattleRoyale.unload()

	outputServerLog(getElementID(source)..": Unloading Battle Royale Definitions")

	removeEventHandler("onUnloadBattleRoyaleDefinitions", source, BattleRoyale.unload)
	removeEventHandler("onPlayerRequestSpawn", source, BattleRoyale.spawn)
	removeEventHandler("onMapChange", source, BattleRoyale.mapChange)
	removeEventHandler("onCountdownStart", source, BattleRoyale.doCountdown)
	removeEventHandler("onMapStart", source, BattleRoyale.mapStart)
	removeEventHandler("onPlayerLeaveArena", source, BattleRoyale.quit)
	removeEventHandler("onPlaneReachFinalPosition", source, BattleRoyale.planeFinish)
	removeEventHandler("onPlayerRequestExitPlane", source, BattleRoyale.exitPlane)
	removeEventHandler("onMatchStart", source, BattleRoyale.matchStart)
	removeEventHandler("onRoundEnd", source, BattleRoyale.roundEnd)
	removeEventHandler("onRoundStart", source, BattleRoyale.roundStart)	
	removeEventHandler("onPlayerWasted", source, BattleRoyale.playerDeath)	
	removeEventHandler("onMapEnd", source, BattleRoyale.mapEnd)
	removeEventHandler("onMapLoading", source, BattleRoyale.mapLoading)
	removeEventHandler("onArenaReset", source, BattleRoyale.reset)
	removeEventHandler("onVehicleStartEnter", source, BattleRoyale.vehicleEnter)
	removeEventHandler("onPickupUse", source, BattleRoyale.pickupUse)
	removeEventHandler("onPickupSpawn", source, BattleRoyale.pickupSpawn)
	removeEventHandler("onPlayerChooseCharacter", source, BattleRoyale.chooseCharacter)
	removeEventHandler("onPreMapEnd", source, BattleRoyale.preMapEnd)	
	
	if isElement(BattleRoyale.plane[source]) then destroyElement(BattleRoyale.plane[source]) end
	if isElement(BattleRoyale.planeobject[source]) then destroyElement(BattleRoyale.planeobject[source]) end

end
addEvent("onUnloadBattleRoyaleDefinitions", true)


function BattleRoyale.reset()

	if isElement(BattleRoyale.plane[source]) then destroyElement(BattleRoyale.plane[source]) end
	if isElement(BattleRoyale.planeobject[source]) then destroyElement(BattleRoyale.planeobject[source]) end
	if isTimer(Arena.timers[source].secondaryTimer) then killTimer(Arena.timers[source].secondaryTimer) end
	if isTimer(Arena.timers[source].primaryTimer) then killTimer(Arena.timers[source].primaryTimer) end
	
	BattleRoyale.round[source] = 0
	BattleRoyale.origin[source] = {}
	BattleRoyale.wallMoving[source] = false
	
	for i, pickup in ipairs(BattleRoyale.pickups[source]) do 
	
		if pickup and isElement(pickup) then
		
			destroyElement(pickup)
			
		end
	
	end
	
	for i, vehicle in ipairs(BattleRoyale.vehicles[source]) do 
	
		if vehicle and isElement(vehicle) then
		
			destroyElement(vehicle)
			
		end
	
	end
	
	for i, marker in ipairs(BattleRoyale.markers[source]) do 
	
		if marker and isElement(marker) then
		
			destroyElement(marker)
			
		end
	
	end	
	
	BattleRoyale.pickups[source] = {}	
	BattleRoyale.vehicles[source] = {}
	BattleRoyale.markers[source] = {}
	BattleRoyale.time[source] = {}
	
end
addEvent("onArenaReset")


function BattleRoyale.mapChange(map)

	setElementData(source, "state", "Waiting")

end
addEvent("onMapChange")


function BattleRoyale.playerDeath(totalAmmo, killer)

	if not isElement(source) then return end

	local arenaElement = getElementParent(source)

	toggleAllControls(source, false, true, false)

	if getElementData(source, "state") ~= "Alive" then return end

	if killer and getElementType(killer) == "vehicle" then
	
		killer = getVehicleOccupant(killer)
		
	end

	if killer then
	
		local myPlayerName = getPlayerName(source)

		local hisPlayername = getPlayerName(killer)

		triggerClientEvent(arenaElement, "onClientCreateMessage", source, "#ffffff"..myPlayerName.." #00ffffwas killed by #ffffff"..hisPlayername)

	else
	
		triggerClientEvent(arenaElement, "onClientCreateMessage", arenaElement, getPlayerName(source).."#ff0000 died!", "right")	
		
	end
	
	if getElementData(arenaElement, "state") == "Waiting" or getElementData(arenaElement, "state") == "Countdown" then 
	
		BattleRoyale.spawnPlayer(source)
		return 
		
	end

	if getElementData(arenaElement, "state") ~= "In Progress" then return end
	
	triggerEvent("onPlayerBattleRoyaleWasted", source, #getAlivePlayersInArena(arenaElement))

	triggerClientEvent(source, "onClientRequestSpectatorMode", source)

	setElementData(source, "state", "Dead")

	setElementAlpha(source, 0)
	
    local currentweapon = getPedWeapon(source)
	
	if currentweapon ~= 0 then
	
		local x, y, z = getElementPosition(source)
	
		local pickup = createPickup(x, y, z, 2, currentweapon, 999999999, 5)
		
		setElementDimension(pickup, getElementDimension(arenaElement))
	
		table.insert(BattleRoyale.pickups[arenaElement], pickup)
	
	end

	if #getAlivePlayersInArena(arenaElement) == 1  then

		local alivePlayers = getAlivePlayersInArena(arenaElement)
		
		triggerClientEvent(arenaElement, "onClientPlayerWin", alivePlayers[1], "#ffffff"..getPlayerName(alivePlayers[1]).."#04B404 has won as last player alive!")

		triggerEvent("onPlayerWin", alivePlayers[1], getCleanPlayerName(alivePlayers[1]))

		triggerEvent("onPreMapEnd", arenaElement)

	end

end


function BattleRoyale.spawn()
	
	local arenaElement = getElementParent(source)

	outputServerLog(getElementID(arenaElement)..": Spawn Request by: "..getPlayerName(source))

	if getElementData(source, "Spectator") then

		triggerClientEvent(source, "onClientRequestSpectatorMode", source, true)
		triggerClientEvent(source, "onClientPlayerReady", arenaElement, getElementData(arenaElement, "Duration"), Core.getTimePassed(arenaElement), BattleRoyale.getWaitingTime(arenaElement))

		BattleRoyale.sendMatchData(source)

		return

	end

	if getElementData(arenaElement, "state") ~= "Waiting" and getElementData(arenaElement, "state") ~= "Countdown" then 
	
		triggerClientEvent(source, "onClientRequestSpectatorMode", source, true)
		triggerClientEvent(source, "onClientPlayerReady", arenaElement, getElementData(arenaElement, "Duration"), Core.getTimePassed(arenaElement), BattleRoyale.getWaitingTime(arenaElement))	
		
		BattleRoyale.sendMatchData(source)
		
		return 
		
	end

	BattleRoyale.spawnPlayer(source)
	
	triggerClientEvent(source, "onClientPlayerReady", arenaElement, getElementData(arenaElement, "Duration"), Core.getTimePassed(arenaElement), BattleRoyale.getWaitingTime(arenaElement))	

	local readyPlayers = #getAlivePlayersInArena(arenaElement)	
	
	if readyPlayers < 2 then return end

	if not isTimer(Arena.timers[arenaElement].secondaryTimer) then

		triggerEvent("onCountdownStart", arenaElement)

	end
	
end
addEvent("onPlayerRequestSpawn", true)


function BattleRoyale.spawnPlayer(player)

	local arenaElement = getElementParent(player)

	local mode = getElementData(arenaElement, "mode")

	local spawn = math.random(#BattleRoyale.spawns[mode])
	
	spawnPlayer(player, BattleRoyale.spawns[mode][spawn][1], BattleRoyale.spawns[mode][spawn][2], BattleRoyale.spawns[mode][spawn][3], 0, 0, 0, getElementDimension(arenaElement))
	setElementAlpha(player, 255)
	setElementFrozen(player, false)
	setElementRotation(player, 0, 0, 0)
	setElementData(player, "state", "Alive")
	setCameraTarget(player, player)
	toggleAllControls(player, true, true, true)
	toggleControl(player, "fire", true)
	toggleControl(player, "action", true)
	toggleControl(player, "aim_weapon", true)
	setPedOnFire(player, false)
	setPedStat(player, 160, 1000)
	setPedStat(player, 229, 1000)
	setPedStat(player, 230, 1000)
	setPedStat(player, 69, 1000)
	setPedStat(player, 70, 1000)
	setPedStat(player, 71, 1000)
	setPedStat(player, 72, 1000)
	setPedStat(player, 73, 1000)
	setPedStat(player, 74, 1000)
	setPedStat(player, 75, 1000)
	setPedStat(player, 76, 1000)
	setPedStat(player, 77, 1000)
	setPedStat(player, 78, 1000)
	setPedStat(player, 79, 1000)
	
end


function BattleRoyale.sendMatchData(player)

	local arenaElement = getElementParent(player)

	if BattleRoyale.origin[arenaElement].x then
	
		if isTimer(Arena.timers[arenaElement].secondaryTimer) then 
		
			local timeLeft = getTimerDetails(Arena.timers[arenaElement].secondaryTimer)
			
			local mode = getElementData(arenaElement, "mode")
			
			triggerClientEvent(player, "onClientMatchInProgress", arenaElement, BattleRoyale.cirlceOrigins[mode], BattleRoyale.origin[arenaElement], BattleRoyale.startRadius, BattleRoyale.round[arenaElement], BattleRoyale.roundDuration, 	BattleRoyale.wallMoving[arenaElement], timeLeft, BattleRoyale.time[arenaElement])
			
		end
			
	end	

end


function BattleRoyale.doCountdown()
	
	setElementData(source, "state", "Countdown")
	
	Arena.timers[source].secondaryTimer = setTimer(triggerEvent, getElementData(source, "timer:waitingForPlayers"), 1, "onMapStart", source, getElementData(source, "map"))

	triggerClientEvent(source, "onClientCountdownStart", source, getElementData(source, "timer:waitingForPlayers"))

	outputServerLog(getElementID(source)..": Countdown Start")

end
addEvent("onCountdownStart", true)
--addCommandHandler("abc", function(p) 	local arenaElement = getElementParent(p) triggerEvent("onCountdownStart", arenaElement) end)
--addCommandHandler("ghi", function(p) givePedJetPack (p)   end) 

function BattleRoyale.mapStart()

	outputServerLog(getElementID(source)..": Map Start")

	setElementData(source, "state", "In Progress")

	local startx, starty, endx, endy = BattleRoyale.getRandomPlanePosition()
	
	local zrot = Util.findRotation(startx, starty, endx, endy)
	
	BattleRoyale.planeobject[source] = createObject(1372, startx, starty, 500, 0, 0, zrot, true)
	BattleRoyale.plane[source] = createVehicle(592, startx, starty, 500, 0, 0, 0)
	
	setElementDimension(BattleRoyale.planeobject[source], getElementDimension(source))
	setElementDimension(BattleRoyale.plane[source], getElementDimension(source))
	
	setElementCollisionsEnabled(BattleRoyale.planeobject[source], false)
	setElementCollisionsEnabled(BattleRoyale.plane[source], false)
	
	setObjectScale(BattleRoyale.planeobject[source], 0)
	
	attachElements(BattleRoyale.plane[source], BattleRoyale.planeobject[source])
	
	setElementData(source, "plane", BattleRoyale.plane[source])
	
	setVehicleLandingGearDown(BattleRoyale.plane[source], false)
	
	for i, p in pairs(getAlivePlayersInArena(source)) do
	
		removePedFromVehicle(p)
		
		takeAllWeapons(p)
		
		toggleAllControls(p, true, true, true)
		
		setElementHealth(p, 100)
		
		setElementPosition(p, startx, starty, 700)
		
		attachElements(p, BattleRoyale.planeobject[source], 0, 0, 0)
		
		setElementData(p, "inplane", true)
		
		giveWeapon(p, 46, 1, true)
		
	end
	
	moveObject(BattleRoyale.planeobject[source], BattleRoyale.planeFlyTime, endx, endy, 700)
	
	Arena.timers[source].primaryTimer = setTimer(triggerEvent, getElementData(source, "Duration"), 1, "onPreMapEnd", source, true)
	
	Arena.timers[source].secondaryTimer = setTimer(triggerEvent, BattleRoyale.planeFlyTime, 1, "onPlaneReachFinalPosition", source)

	BattleRoyale.createPickups(source)

	BattleRoyale.createVehicles(source)
	
	BattleRoyale.time[source] = math.random(0, 23)

	triggerClientEvent(source, "onClientMapStart", source, getElementData(source, "map"), BattleRoyale.time[source])

end
addEvent("onMapStart", false)


function BattleRoyale.mapEnd()

	triggerClientEvent(source, "onClientMapEnding", source, "Next match starts in: ", 7000)
		
	Arena.timers[source].secondaryTimer = setTimer(triggerEvent, 7000, 1, "onMapLoading", source)

end
addEvent("onMapEnd", false)


function BattleRoyale.preMapEnd(timeUp)

	if getElementData(source, "state") ~= "In Progress" then return end

	setElementData(source, "state", "End")

	if isTimer(Arena.timers[source].secondaryTimer) then killTimer(Arena.timers[source].secondaryTimer) end

	if getElementData(source, "podium") then

		Arena.timers[source].secondaryTimer = setTimer(triggerEvent, 3000, 1, "onMapEnd", source)

		triggerClientEvent(source, "onClientPreMapEnd", source, "Map will end in: ", 3000, timeUp)

	else
	
		triggerEvent("onMapEnd", source)
	
	end

end
addEvent("onPreMapEnd", true)


function BattleRoyale.mapLoading()

	local mode = getElementData(source, "mode")
	local type = getElementData(source, "type")
	local map = MapManager.findMap("Battle Royale - "..mode, type)

	triggerEvent("onStartNewMap", source, map[1], true)

end
addEvent("onMapLoading", true)


function BattleRoyale.quit()
	
	local arenaElement = getElementParent(source)	
	
	if getElementData(arenaElement, "state") == "Waiting" or getElementData(arenaElement, "state") == "Countdown" then

		local readyPlayers = #getAlivePlayersInArena(arenaElement) - 1
		
		if readyPlayers < 2 then
		
			if isTimer(Arena.timers[arenaElement].secondaryTimer) then killTimer(Arena.timers[arenaElement].secondaryTimer) end
		
			triggerEvent("onMapLoading", arenaElement)
		
		end
		
	end
	
end
addEvent("onPlayerLeaveArena", true)


function BattleRoyale.planeFinish()

	for i, p in pairs(getAlivePlayersInArena(source)) do
	
		triggerEvent("onPlayerRequestExitPlane", p)
		
	end

	if isElement(BattleRoyale.plane[source]) then destroyElement(BattleRoyale.plane[source]) end
	if isElement(BattleRoyale.planeobject[source]) then destroyElement(BattleRoyale.planeobject[source]) end

	triggerEvent("onMatchStart", source)

	triggerClientEvent(source, "onClientPlaneReachFinalPosition", source)

end
addEvent("onPlaneReachFinalPosition", false)


function BattleRoyale.matchStart()

	outputServerLog(getElementID(source)..": Match Start")

	BattleRoyale.origin[source].x, BattleRoyale.origin[source].y = BattleRoyale.getRandomOrigin()

	local mode = getElementData(source, "mode")

	triggerClientEvent(source, "onClientMatchStart", source, BattleRoyale.cirlceOrigins[mode], BattleRoyale.origin[source], BattleRoyale.startRadius)	

	triggerEvent("onRoundStart", source)

end
addEvent("onMatchStart", false)


function BattleRoyale.roundStart()

	BattleRoyale.round[source] = BattleRoyale.round[source] + 1

	outputServerLog(getElementID(source)..": Round "..BattleRoyale.round[source].." Start")

	BattleRoyale.wallMoving[source] = false

	triggerClientEvent(source, "onClientRoundStart", source, BattleRoyale.round[source], BattleRoyale.roundDuration)	

	Arena.timers[source].secondaryTimer = setTimer(triggerEvent, BattleRoyale.roundDuration, 1, "onRoundEnd", source)

end
addEvent("onRoundStart", false)


function BattleRoyale.roundEnd()

	outputServerLog(getElementID(source)..": Round "..BattleRoyale.round[source].." End, moving Wall")

	BattleRoyale.wallMoving[source] = true

	triggerClientEvent(source, "onClientRoundEnd", source)
	
	if BattleRoyale.round[source] < BattleRoyale.maxRounds then
	
		Arena.timers[source].secondaryTimer = setTimer(triggerEvent, BattleRoyale.roundDuration, 1, "onRoundStart", source)	

	end

end
addEvent("onRoundEnd", false)


function BattleRoyale.exitPlane()

	if not getElementData(source, "inplane") then return end

	local arenaElement = getElementParent(source)
	
	local x, y, z = getElementPosition(BattleRoyale.planeobject[arenaElement])
	
	setElementPosition(source, x, y, z)
	setElementData(source, "inplane", false)
	detachElements(source, BattleRoyale.planeobject[arenaElement])
	fadeCamera(source, true)
	setCameraTarget(source, source)
	
	triggerClientEvent(source, "onClientPlayerLeavePlane", source)
	
end
addEvent("onPlayerRequestExitPlane", true)


function BattleRoyale.vehicleEnter(player, seat)

	if getVehicleOccupant(source) then
	
		if not getPlayerTeam(player) then return end
	
		if getPlayerTeam(getVehicleOccupant(source)) == getPlayerTeam(player) then return end
		
	end

	if seat ~= 0 then

		cancelEvent()
		
		outputChatBox("You can only enter a vehicle as the driver!", player, 255, 0, 128, true)
		return
		
	end

end


function BattleRoyale.getRandomOrigin()

	local mode = getElementData(source, "mode")
	
	local angle = math.random(360)
	
	local distance = math.random(BattleRoyale.startRadius)
	
	local x = BattleRoyale.cirlceOrigins[mode].x + distance * math.cos(math.rad(angle))
	local y = BattleRoyale.cirlceOrigins[mode].y + distance * math.sin(math.rad(angle))
	
	return x, y

end


function BattleRoyale.getRandomPlanePosition()

	local mode = getElementData(source, "mode")

	local angle = math.random(360)

	local startX = BattleRoyale.cirlceOrigins[mode].x + BattleRoyale.startRadius * math.cos(math.rad(angle))
	local startY = BattleRoyale.cirlceOrigins[mode].y + BattleRoyale.startRadius * math.sin(math.rad(angle))
	local endX = BattleRoyale.cirlceOrigins[mode].x + BattleRoyale.startRadius * math.cos(math.rad(angle - 180))
	local endY = BattleRoyale.cirlceOrigins[mode].y + BattleRoyale.startRadius * math.sin(math.rad(angle - 180))	
	
	return startX, startY, endX, endY
	
end


function BattleRoyale.createVehicles(arenaElement)
	
	local mode = getElementData(arenaElement, "mode")
	
	for i, vehicleData in pairs(BattleRoyale.vehicleSpawns[mode]) do

		local model = math.random(#BattleRoyale.vehicleModels)
	
		local vehicle = createVehicle(BattleRoyale.vehicleModels[model], vehicleData[1], vehicleData[2], vehicleData[3], 0, 0, vehicleData[4])
		
		if vehicle then

			setElementParent(vehicle, arenaElement)
			setElementDimension(vehicle, getElementDimension(arenaElement))
			
			if getVehicleType(vehicle) == "Automobile" or getVehicleType(vehicle) == "Bike" then
			
				setElementData(vehicle, "fuel", 100)
				
			end	
				
			table.insert(BattleRoyale.vehicles[arenaElement], vehicle)
			
		end
	
	end
	
end


function BattleRoyale.createPickups(arenaElement)

	local mode = getElementData(arenaElement, "mode")

	for i, pickupData in pairs(BattleRoyale.pickupSpawns[mode]) do
	
		if math.random(100) < 50 then
		
			local weapon = math.random(#BattleRoyale.weapons)
			
			local pickup = createPickup ( pickupData[1], pickupData[2], pickupData[3], 2, BattleRoyale.weapons[weapon][1], 999999999, BattleRoyale.weapons[weapon][2])
			
			if pickup then
			
				local marker = createMarker ( pickupData[1], pickupData[2], pickupData[3], "corona", 1.0, 0, 180, 250, 175, arenaElement )

				if marker then
		
					setElementDimension(marker, getElementDimension(arenaElement))

					BattleRoyale.pickupToMarker[pickup] = marker

					table.insert(BattleRoyale.markers[arenaElement], marker)
				
				end
				
				setElementParent(pickup, arenaElement)
				setElementDimension(pickup, getElementDimension(arenaElement))
				table.insert(BattleRoyale.pickups[arenaElement], pickup)
				
			end
	
		end
	
	end
	
end


function BattleRoyale.pickupUse(player)

	local arenaElement = getElementParent(source)

	local marker = BattleRoyale.pickupToMarker[source]
	
	if marker and isElement(marker) then
		
		destroyElement(marker)
		
	end
	
	BattleRoyale.pickupToMarker[source] = nil

end


function BattleRoyale.pickupSpawn()

	local arenaElement = getElementParent(source)

	local x, y, z = getElementPosition(source)

	local marker = createMarker ( x, y, z, "corona", 1.0, 0, 180, 250, 255, arenaElement )

	if marker then
	
		setElementDimension(marker, getElementDimension(arenaElement))

		BattleRoyale.pickupToMarker[source] = marker

		table.insert(BattleRoyale.markers[arenaElement], marker)
	
	end

end


function BattleRoyale.getWaitingTime(arenaElement)

	if getElementData(arenaElement, "state") ~= "Countdown" then return false end

	if not isTimer(Arena.timers[arenaElement].secondaryTimer) then return false end

	return getTimerDetails(Arena.timers[arenaElement].secondaryTimer)

end


function BattleRoyale.chooseCharacter(character)

	setElementModel(source, character)

end
addEvent("onPlayerChooseCharacter", true)