MapManager = {}
MapManager.objects = {}
MapManager.pickups = {}
MapManager.elements = {}
MapManager.helicopterIDs = {425, 592, 553, 577, 488, 511, 497, 548, 563, 512, 476, 593, 447, 425, 519, 520, 460, 417, 469, 487, 513, 501, 465}
MapManager.pickUpTimer = nil
MapManager.checkpoints = {}
MapManager.spawnpoints = {}

function MapManager.loadMap(mapTable, session)

	local arenaElement = getElementParent(localPlayer)
	
	if session ~= getElementData(arenaElement, "session") then return end
	
	if mapTable.settings["#time"] then
	
		local hour = string.match(mapTable.settings["#time"], "%d+")
		
		mapTable.settings["#time"] = string.reverse(mapTable.settings["#time"])
		
		local minute = string.match(mapTable.settings["#time"], "%d+")
		
		if hour and minute then
		
			setTime(hour, minute)
	
		end
	
	end
	
	if mapTable.settings["#weather"] then
	
		local weather = string.match(mapTable.settings["#weather"], "%d+")
		
		if weather then
		
			setWeather(weather)
		
		end
	
	end
	
	setCloudsEnabled(false)
	
	for i, m in ipairs(mapTable.objects) do
	
		local object = createObject(m.modelId, m.posX, m.posY, m.posZ, m.rotX, m.rotY, m.rotZ)
		
		if object then
		
			if m.collisions == "false" then
			
				setElementCollisionsEnabled(object, false)
			
			else
			
				setElementCollisionsEnabled(object, true)
				
			end
			
			if m.doublesided == "true" then
				
				setElementDoubleSided(object, true)
				
			end
			
			if m.breakable == "false" then
			
				setObjectBreakable(object, false)
				
			else 
			
				setObjectBreakable(object, true)
				
			end
			
			setElementDimension(object, getElementDimension(source))
			setElementInterior(object, m.interiorID)
			setElementAlpha(object, m.alpha)
			setObjectScale(object, m.scale)
			table.insert(MapManager.objects, object)
		
		end
		
	end
	
	for i, r in ipairs(mapTable.removeWorldObjects) do
	
		removeWorldModel(r.model, r.radius, r.posX, r.posY, r.posZ, r.interior)
	
	end

	for i, m in ipairs(mapTable.marker) do
	
		local r, g, b, a = getColorFromString(m.color)
		local marker = createMarker(m.posX, m.posY, m.posZ, m.theType, m.size, r, g, b, a)
		
		if marker then
		
			setElementDimension(marker, getElementDimension(source))
			table.insert(MapManager.objects, marker)
		
		end
		
	end
	
	for i, m in ipairs(mapTable.pickup) do
		
		MapManager.pickups[i] = {}
		local pickup
		local colshape
		
		if m.pickupType == "repair" then
		
			pickup = createObject ( 2222, m.posX, m.posY, m.posZ, 0, 0, 0, true)
			colshape = createColSphere(m.posX, m.posY, m.posZ, 3.5)
			setElementData(colshape, "type", "repair")
			setElementData(colshape, "object", pickup)
			
		elseif m.pickupType == "nitro" then
		
			pickup = createObject ( 2221, m.posX - 0.25, m.posY - 0.25, m.posZ, 0, 0, 0, true)
			colshape = createColSphere(m.posX, m.posY, m.posZ, 3.5)
			setElementData(colshape, "type", "nitro")
			setElementData(colshape, "object", pickup)
			
		elseif m.pickupType == "vehiclechange" then
		
			pickup = createObject ( 2223, m.posX + 0.25, m.posY + 0.25, m.posZ, 0, 0, 0, true)
			colshape = createColSphere(m.posX, m.posY, m.posZ, 3.5)
			setElementData(colshape, "type", "vehiclechange")
			setElementData(colshape, "model", m.vehicle)
			setElementData(colshape, "object", pickup)
			
		end
		
		if colshape and pickup then
		
			setElementDimension(colshape, getElementDimension(source))
			setElementDimension(pickup, getElementDimension(source))
			setElementCollisionsEnabled(pickup, false)
			MapManager.pickups[i].pickup = pickup
			MapManager.pickups[i].colshape = colshape
	
		end
	
	end

	MapManager.spawnpoints = mapTable.spawnpoints

	local orderedList
	
	if #mapTable.checkpoints > 0 then
	
		orderedList = MapManager.orderCheckpoints(mapTable.checkpoints)
		
	end
	
	for i, c in ipairs(mapTable.checkpoints) do
	
		local r, g, b, a = getColorFromString(c.color)
		local marker = createMarker(c.posX, c.posY, c.posZ, c.type, c.size, r, g, b, a)
		local colshape
		
		if not c.type or c.type == "checkpoint" then
			
			colshape = createColCircle(c.posX, c.posY, c.size + 4)
			
		else
		
			colshape = createColSphere(c.posX, c.posY, c.posZ, c.size + 4)
		
		end
		
		setElementDimension(marker, 0)
		setElementDimension(colshape, getElementDimension(source))
		setElementData(colshape, "type", "checkpoint")
		setElementData(colshape, "marker", marker)
		
		if c.id == firstCheckpoint then
		
			setElementData(colshape, "id", "0")
			
		else
		
			setElementData(colshape, "id", c.id)
			
		end
				
		setElementData(colshape, "nextid", c.nextid)
		
		if c.vehicle then
		
			setElementData(colshape, "vehicle", c.vehicle)	
			
		end
		
		table.insert(MapManager.checkpoints, {colshape = colshape, marker = marker})
		
	end
	
	for i, c in ipairs(mapTable.Jumps) do
	
		local element = createElement("Jump", c.id)
		setElementPosition(element, c.posX, c.posY, c.posZ)
		setElementData(element, "power", c.power)
		setElementData(element, "id", c.id)
		setElementData(element, "color", c.color)
		setElementData(element, "type", c.type)
		setElementData(element, "size", c.size)
		table.insert(MapManager.elements, element)
		
	end
	
	for i, c in ipairs(mapTable.SpeedUp) do
	
		local element = createElement("SpeedUp", c.id)
		setElementPosition(element, c.posX, c.posY, c.posZ)
		setElementData(element, "power", c.power)
		setElementData(element, "id", c.id)
		setElementData(element, "color", c.color)
		setElementData(element, "type", c.type)
		setElementData(element, "size", c.size)
		table.insert(MapManager.elements, element)
		
	end
	
	for i, c in ipairs(mapTable.Freeze) do
	
		local element = createElement("Freeze", c.id)
		setElementPosition(element, c.posX, c.posY, c.posZ)
		setElementData(element, "time", c.time)
		setElementData(element, "id", c.id)
		setElementData(element, "color", c.color)
		setElementData(element, "type", c.type)
		setElementData(element, "size", c.size)
		table.insert(MapManager.elements, element)
		
	end
	
	for i, c in ipairs(mapTable.Flip) do
	
		local element = createElement("Flip", c.id)
		setElementPosition(element, c.posX, c.posY, c.posZ)
		setElementData(element, "id", c.id)
		setElementData(element, "color", c.color)
		setElementData(element, "type", c.type)
		setElementData(element, "size", c.size)
		table.insert(MapManager.elements, element)
		
	end
	
	for i, c in ipairs(mapTable.Reverse) do
	
		local element = createElement("Reverse", c.id)
		setElementPosition(element, c.posX, c.posY, c.posZ)
		setElementData(element, "id", c.id)
		setElementData(element, "color", c.color)
		setElementData(element, "type", c.type)
		setElementData(element, "size", c.size)
		table.insert(MapManager.elements, element)
		
	end
	
	for i, c in ipairs(mapTable.Rotate) do
	
		local element = createElement("Rotate", c.id)
		setElementPosition(element, c.posX, c.posY, c.posZ)
		setElementData(element, "id", c.id)
		setElementData(element, "color", c.color)
		setElementData(element, "type", c.type)
		setElementData(element, "size", c.size)
		table.insert(MapManager.elements, element)
		
	end
	
	addEventHandler("onClientRender", root, MapManager.rotatePickups)
	addEventHandler("onClientColShapeHit", root, MapManager.pickupHit)
	
	triggerServerEvent("onPlayerDownloadFinish", localPlayer, session)
	
end
addEvent("onClientLoadMap", true)
addEventHandler("onClientLoadMap", root, MapManager.loadMap)


function MapManager.unloadMap()

	setWeather(0)
	setTime(12, 0)

	for i, object in pairs(MapManager.objects) do
	
		if isElement(object) then destroyElement(object) end
		
	end
	
	for i, p in pairs(MapManager.pickups) do
	
		if isElement(p.pickup) then destroyElement(p.pickup) end
		if isElement(p.colshape) then destroyElement(p.colshape) end
		
	end
	
	for i, element in pairs(MapManager.elements) do
	
		if isElement(element) then destroyElement(element) end
		
	end
	
	for i, checkpoint in pairs(MapManager.checkpoints) do
	
		if isElement(checkpoint.marker) then destroyElement(checkpoint.marker) end
		if isElement(checkpoint.colshape) then destroyElement(checkpoint.colshape) end
		
	end

	MapManager.objects = {}
	MapManager.elements = {}
	MapManager.pickups = {}
	MapManager.checkpoints = {}
	MapManager.spawnpoints = {}
	restoreAllWorldModels()
	removeEventHandler("onClientRender", root, MapManager.rotatePickups)
	removeEventHandler("onClientColShapeHit", root, MapManager.pickupHit)
	
end
addEvent("onClientArenaReset", true)
addEventHandler("onClientArenaReset", root, MapManager.unloadMap)


function MapManager.getCheckpoints()

	return MapManager.checkpoints

end


function MapManager.isRaceMap()

	return #MapManager.checkpoints > 0

end
export_isRaceMap = MapManager.isRaceMap


function MapManager.getSpawnPoints()

	return MapManager.spawnpoints

end
export_getSpawnPoints = MapManager.getSpawnPoints


function MapManager.rotatePickups()
	
	for i, p in pairs(MapManager.pickups) do
	
		if isElement(p.pickup) and isElementStreamedIn(p.pickup) then
			
			local xr, yr, zr = getElementRotation(p.pickup) 
			setElementRotation(p.pickup, xr, yr, zr+3)
			
			if getElementData(p.colshape, "type") == "vehiclechange" then
			
				local x, y, z = getElementPosition(p.pickup)
				local cx, cy, cz = getCameraMatrix()
				local distance = getDistanceBetweenPoints3D ( x, y, z, cx, cy, cz )
				local model = getElementData(p.colshape, "model")

				local sx, sy = getScreenFromWorldPosition ( x, y, z + 1.1, 0.08 )
				
				if sx then
				
					if distance < 80 and isLineOfSightClear(cx, cy, cz, x, y, z, true, false, false, true, false) then
				
						alpha = 255 - ((distance-60)*(255/20))
				
					elseif distance < 60 and isLineOfSightClear(cx, cy, cz, x, y, z, true, false, false, true, false) then
				
						alpha = 255
						
					else

						alpha = 0
						
					end

					scale = (60/distance)*0.3
					dxDrawText(getVehicleNameFromModel(model), sx, sy, sx, sy, tocolor(255,255,255,math.min(255, alpha)), math.min (scale, 1.5), "bankgothic", "center", "bottom", false, false, false )

				end
				
			end
		
		end
		
	end
	
end


function MapManager.pickupHit(element)
	
	if getElementType(element) ~= "player" then return end
	
	if element == localPlayer then 

		if getElementData(source, "cancelled") then return end
	
		if not getPedOccupiedVehicle(localPlayer) then return end
		
		local type = getElementData(source, "type")
		local model = getElementData(source, "model")
		local vehicle = getPedOccupiedVehicle(localPlayer)  
		
		if type == "vehiclechange" then
		
			if model == getElementModel(vehicle) then 
			
				return 
				
			end
		
		end
		
		if type == "nitro" then
		
			addVehicleUpgrade(vehicle, 1010)
			playSoundFrontEnd(46)
			
		elseif type == "repair" then
		
			fixVehicle(vehicle)
			playSoundFrontEnd(46)
			
		elseif type == "vehiclechange" then
		
			if model == 425 then
			
				if getElementData(localPlayer, "state") ~= "Alive" then return end
		
				setTime(5, 0)
				setWeather(1)
		
			else
		
		
		
			end

			if isTimer(MapManager.pickUpTimer) then return end
			
			MapManager.pickUpTimer = setTimer(function()
				setElementModel(vehicle, model)
				MapManager.vehicleChanging(model)
			end, 50, 1)
	
		end	
		
		triggerServerEvent("onPlayerDerbyPickupHit", localPlayer, type, model)
		
	end
		
	if getElementData(source, "unique") then

		local object = getElementData(source, "object")
		
		if isElement(object) then destroyElement(object) end
		
		destroyElement(source)
		
	end
	
end


function MapManager.vehicleChanging(model)

	local vehicle = getPedOccupiedVehicle(localPlayer)  
	local vehicleHeight = getElementDistanceFromCentreOfMassToBaseOfModel(vehicle)

	local x, y, z = getElementPosition(vehicle) 

	setElementModel(vehicle, model)
	playSoundFrontEnd(46)
	
	local matrix = getElementMatrix(vehicle)
	local Right = Vector3( matrix[1][1], matrix[1][2], matrix[1][3] )
	local Fwd	= Vector3( matrix[2][1], matrix[2][2], matrix[2][3] )
	local Up	= Vector3( matrix[3][1], matrix[3][2], matrix[3][3] )

	local Velocity = Vector3(getElementVelocity(vehicle))
	local rz

	if Velocity:getLength() > 0.05 and Up.z < 0.001 then

		rz = directionToRotation2D(Velocity.x, Velocity.y)
		
	else

		rz = directionToRotation2D(Fwd.x, Fwd.y)
		
	end

	setElementRotation(vehicle, 0, 0, rz)		

	local newVehicleHeight = getElementDistanceFromCentreOfMassToBaseOfModel(vehicle)
	
	if vehicleHeight and newVehicleHeight > vehicleHeight then
	
		z = z - vehicleHeight + newVehicleHeight
		
	end

	z = z + 1.2
	
	setElementPosition(vehicle, x, y, z)	
	vehicleHeight = nil
	
	if table.contains(MapManager.helicopterIDs, model) then
	
		setHelicopterRotorSpeed(getPedOccupiedVehicle(localPlayer), 0.2)
		setVehicleLandingGearDown(getPedOccupiedVehicle(localPlayer), true)
		
	end
	
end


function MapManager.orderCheckpoints(checkpointTable)

	local lastCheckPoint = false
	local found
	local orderedList = {}
	
	for i=0, #checkpointTable, 1 do
	
		for j, checkpoint in ipairs(checkpointTable) do
		
			if checkpoint.nextid == lastCheckPoint then
			
				lastCheckPoint = checkpoint.id
				table.insert(orderedList, 1, checkpoint)
				break
				
			end
			
		end
	
	end
	
	return orderedList
	
end


function rem( a, b )

	local result = a - b * math.floor( a / b )
	if result >= b then
		result = result - b
	end
	return result
	
end


function directionToRotation2D( x, y )

	return rem( math.atan2( y, x ) * (360/6.28) - 90, 360 )
	
end


function MapManager.copy()

	local arenaElement = getElementParent(localPlayer)
	
	local map = getElementData(arenaElement, "map")

	setClipboard(map.name)
	
	outputChatBox("Map name copied to clipboard!", 255, 0, 128)
	
end
addCommandHandler("copy", MapManager.copy)


function MapManager.removeRepairs()

	for i, p in pairs(MapManager.pickups) do
	
		if getElementData(p.colshape, "type") == "repair" then
		
			if isElement(p.pickup) then destroyElement(p.pickup) end
			if isElement(p.colshape) then destroyElement(p.colshape) end
		
		end
		
	end

end
addEvent("onClientRemoveRepairPickups", true)
addEventHandler("onClientRemoveRepairPickups", root, MapManager.removeRepairs)


function MapManager.removeObjects()

	for i, object in pairs(MapManager.objects) do
	
		if getElementAlpha(object) == 0 then
		
			setElementAlpha(object, 255)
			
		else
		
			setElementAlpha(object, 0)
			
		end
		
	end

end
addEvent("onClientRemoveObjects", true)
addEventHandler("onClientRemoveObjects", root, MapManager.removeObjects)


