Ghost = {}
Ghost.data = {}
Ghost.enabled = nil
Ghost.vehicle = nil
Ghost.ped = nil
Ghost.currentIndex = 1
Ghost.fetchInterval = 50
Ghost.lastTick = 0
Ghost.currentMap = nil
Ghost.marker = nil
Ghost.lineSize = 5

function Ghost.main()

	if getElementData(source, "gamemode") ~= "Race" then return end

	if not getElementData(source, "GhostMode") then return end
	
	local map = getElementData(source, "map")

	Ghost.currentMap = map

	addEventHandler("onClientPlayerWasted", localPlayer, Ghost.death)
	addEventHandler("onClientMapStart", root, Ghost.start)
	
	Ghost.data = Ghost.load()
	
	addCommandHandler("ghost", Ghost.toggle)
	
	if not Ghost.data then return end
	
	if getElementData(localPlayer, "setting:ghost_driver") == 0 then
	
		outputChatBox("#00ccffUse #ffffff/ghost#00ccff to show a Ghost of the last time you played this map!", 255, 255, 255, true)
	
	else
	
		outputChatBox("#00ccffGhost from the last time you played this map active!", 255, 255, 255, true)
	
	end
	
	Ghost.vehicle = createVehicle(Ghost.data[Ghost.currentIndex].model, Ghost.data[Ghost.currentIndex].posX, Ghost.data[Ghost.currentIndex].posY, Ghost.data[Ghost.currentIndex].posZ, Ghost.data[Ghost.currentIndex].rotX, Ghost.data[Ghost.currentIndex].rotY, Ghost.data[Ghost.currentIndex].rotZ)
	Ghost.ped = createPed(0, 0, 0, 0)
	Ghost.marker = createMarker(0, 0, 0, "arrow", 1.0, 0, 0, 255, 255)
	attachElements(Ghost.marker, Ghost.vehicle, 0, 0, 2)
	
	if getElementData(localPlayer, "setting:ghost_driver") == 1 then
	
		setElementDimension(Ghost.vehicle, getElementDimension(localPlayer))
		setElementDimension(Ghost.ped, getElementDimension(localPlayer))
		setElementDimension(Ghost.marker, getElementDimension(localPlayer))
		Ghost.enabled = true
		
	else
	
		setElementDimension(Ghost.vehicle, 0)
		setElementDimension(Ghost.ped, 0)
		setElementDimension(Ghost.marker, 0)
		Ghost.enabled = false
	
	end
	
	setElementAlpha(Ghost.vehicle, 155)
	setElementAlpha(Ghost.ped, 155)
	setVehicleOverrideLights(Ghost.vehicle, 2)
	warpPedIntoVehicle(Ghost.ped, Ghost.vehicle)
	
	if getElementData(localPlayer, "setting:car_color") then

		local color = getElementData(localPlayer, "setting:car_color")
		local color2 = getElementData(localPlayer, "setting:car_color2")
		local r, g, b = getColorFromString(color)
		local r2, g2, b2 = getColorFromString(color2)
		setTimer(setVehicleColor, 200, 1, Ghost.vehicle, r, g, b, r2, g2, b2)
		
	else

		local color = getElementData(source, "color")
		local r, g, b = getColorFromString(color)
		setTimer(setVehicleColor, 200, 1, setVehicleColor, Ghost.vehicle, r, g, b)
		
	end
	
end
addEvent("onClientPlayerReady", true)
addEventHandler("onClientPlayerReady", root, Ghost.main)


function Ghost.start()

	addEventHandler("onClientRender", root, Ghost.process)

end
addEvent("onClientMapStart", true)


function Ghost.reset()

	removeEventHandler("onClientPlayerWasted", localPlayer, Ghost.death)
	removeEventHandler("onClientRender", root, Ghost.process)
	removeEventHandler("onClientMapStart", root, Ghost.start)
	removeCommandHandler("ghost", Ghost.toggle)
	Ghost.data = {}
	Ghost.currentIndex = 1
	if isElement(Ghost.vehicle) then destroyElement(Ghost.vehicle) end
	if isElement(Ghost.ped) then destroyElement(Ghost.ped) end
	if isElement(Ghost.marker) then destroyElement(Ghost.marker) end
	
end
addEvent("onClientArenaReset", true)
addEventHandler("onClientArenaReset", root, Ghost.reset)


function Ghost.toggle()

	if not Ghost.data then
	
		outputChatBox("#00ccffNo recorded data for this map available!", 255, 255, 255, true)
		return
		
	end

	if getElementData(localPlayer, "setting:ghost_driver") == 0 then
	
		if isElement(Ghost.vehicle) then
		
			setElementDimension(Ghost.vehicle, getElementDimension(localPlayer))
			setElementDimension(Ghost.ped, getElementDimension(localPlayer))
			setElementDimension(Ghost.marker, getElementDimension(localPlayer))
			
		end
			
		triggerServerEvent("onGhostDriverSettingChange", localPlayer, 1)
		
		Ghost.enabled = true
		
		outputChatBox("#00ccffGhosts are now turned #ffffffon#00ccff!", 255, 255, 255, true)
		
	else
	
		if isElement(Ghost.vehicle) then
		
			setElementDimension(Ghost.vehicle, 0)
			setElementDimension(Ghost.ped, 0)
			setElementDimension(Ghost.marker, 0)
			
		end
		
		triggerServerEvent("onGhostDriverSettingChange", localPlayer, 0)
		
		Ghost.enabled = false
		
		outputChatBox("#00ccffGhosts are now turned #ffffffoff#00ccff!", 255, 255, 255, true)
	
	end
		
end


function Ghost.death()

	local data = exports["CCS_respawn"]:export_getRecordedData()
	
	if not data or #data == 0 then return end

	Ghost.save(data)

end


function Ghost.save(data)

	if not Ghost.currentMap then return end

	local saveData = toJSON(data)

	local file = fileCreate(Ghost.currentMap.resource..".ghost")
	fileWrite(file, saveData)
	fileFlush(file)
	fileClose(file)

end


function Ghost.load()

	local arenaElement = getElementParent(localPlayer)
	
	local map = getElementData(arenaElement, "map")
	
	if not map then return end
	
	if not fileExists(map.resource..".ghost") then return end
	
	local file = fileOpen(map.resource..".ghost")

	local content = fileRead(file, fileGetSize(file))
	fileClose(file)
	
	local temp = fromJSON(content)
	
	if not temp then return end
	
	return temp

end


function Ghost.process()

	if not isElement(Ghost.vehicle) then return end
	
	if Ghost.currentIndex > #Ghost.data then 
	
		destroyElement(Ghost.vehicle)
		destroyElement(Ghost.ped)
		destroyElement(Ghost.marker)
		return 
	
	end

	if Ghost.enabled then
	
		for i = 2, Ghost.currentIndex, 1 do
		
			local speed = Ghost.getSpeed(Ghost.data[i-1].velX, Ghost.data[i-1].velY, Ghost.data[i-1].velZ)
			
			local r, g, b, n
			
			n = (speed / 197) * 100
			n = math.abs(n - 100)
			n = math.min(100, n)
			n = math.max(0, n)
			
			r = (255 * n) / 100
			g = (255 * (100 - n)) / 100 
			b = 0
		
			dxDrawLine3D(Ghost.data[i-1].posX, Ghost.data[i-1].posY, Ghost.data[i-1].posZ, Ghost.data[i].posX, Ghost.data[i].posY, Ghost.data[i].posZ, tocolor ( r, g, b, 255 ), Ghost.lineSize)

		end
		
	end

	if getTickCount() - Ghost.lastTick < Ghost.fetchInterval then return end

	Ghost.lastTick = getTickCount()
	
	setElementModel(Ghost.vehicle, Ghost.data[Ghost.currentIndex].model)
	setElementPosition(Ghost.vehicle, Ghost.data[Ghost.currentIndex].posX, Ghost.data[Ghost.currentIndex].posY, Ghost.data[Ghost.currentIndex].posZ)
	setElementRotation(Ghost.vehicle, Ghost.data[Ghost.currentIndex].rotX, Ghost.data[Ghost.currentIndex].rotY, Ghost.data[Ghost.currentIndex].rotZ)
	setElementVelocity(Ghost.vehicle, Ghost.data[Ghost.currentIndex].velX, Ghost.data[Ghost.currentIndex].velY, Ghost.data[Ghost.currentIndex].velZ)
	setElementAngularVelocity(Ghost.vehicle, Ghost.data[Ghost.currentIndex].turX, Ghost.data[Ghost.currentIndex].turY, Ghost.data[Ghost.currentIndex].turZ)
	addVehicleUpgrade(Ghost.vehicle, Ghost.data[Ghost.currentIndex].nitro)
	setVehicleNitroActivated(Ghost.vehicle, Ghost.data[Ghost.currentIndex].isNosActive)
	
	Ghost.currentIndex = Ghost.currentIndex + 1
	
end

function Ghost.getSpeed(velX, velY, velZ)

	return (velX^2 + velY^2 + velZ^2) ^ 0.5 * 1.61 * 100

end