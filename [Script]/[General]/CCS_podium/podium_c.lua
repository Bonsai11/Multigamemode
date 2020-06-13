local Podium = {}
Podium.state = false
Podium.locations = {{1093.94, 1080.24, 10.83, 307}, {1091.83, 1071.43, 10.83, 307}, {1084.67, 1080.09, 10.83, 307}}
Podium.cameraStartPosition = Vector3(1247.56, 1196.82, 100.90)
Podium.effectPositions = {{1085.26, 1060.27, 8.83}, {1074.47, 1075.01, 8.83}, {1093.43, 1089.23, 8.83}, {1104.04, 1075.87, 8.83}}
Podium.elements = {}
Podium.data = {}
Podium.animateStart = 0
Podium.animateTime = 3000
Podium.finalCameraPosition = nil

function Podium.set(positions)

	if Podium.state then return end

	Podium.state = true

	local arenaElement = getElementParent(localPlayer)

	local matrix = Matrix(Vector3(Podium.locations[1][1], Podium.locations[1][2], Podium.locations[1][3]))
	
	Podium.finalCameraPosition = matrix.position + matrix.forward * 15 + matrix.right * 20 + matrix.up * 10

	for i, podium in pairs(positions) do

		Podium.data[i] = {}
		Podium.data[i].ped = createPed(podium.skin, Podium.locations[i][1], Podium.locations[i][2], Podium.locations[i][3], Podium.locations[i][4])
		setElementDimension(Podium.data[i].ped, getElementDimension(arenaElement))
		setPedAnimation(Podium.data[i].ped, "playidles", "stretch", -1, true)
		Podium.data[i].name = podium.name

		if podium.vehicle then
		
			local matrix = Matrix(Vector3(Podium.locations[i][1], Podium.locations[i][2], Podium.locations[i][3]), Vector3(0, 0, Podium.locations[i][4]))
			local vehiclePosition = matrix.position + matrix.right * 2
		
			Podium.data[i].vehicle = createVehicle(podium.vehicle.id, vehiclePosition.x, vehiclePosition.y, vehiclePosition.z, 0, 0, Podium.locations[i][4])
			setElementDimension(Podium.data[i].vehicle, getElementDimension(arenaElement))

			local r, g, b = getColorFromString(podium.vehicle.color)
			
			if podium.vehicle.color2 then
			
				local r2, g2, b2 = getColorFromString(podium.vehicle.color2)
				
				setVehicleColor(Podium.data[i].vehicle, r, g, b, r2, g2, b2)
				
			else
			
				setVehicleColor(Podium.data[i].vehicle, r, g, b)
				
			end
			
		end

	end
		
	for i, effectPos in pairs(Podium.effectPositions) do
	
		local effect = createEffect("smoke_flare", effectPos[1], effectPos[2], effectPos[3], 270, 0, 0, 100) 
		setElementDimension(effect, getElementDimension(arenaElement))
		table.insert(Podium.elements, effect)
	
	end	
	
	--seats
	local object = createObject(3819, 1085.40, 1051.59, 11.10, 0, 0, 264)
	setElementDimension(object, getElementDimension(arenaElement))
	setObjectScale(object, 2)
	table.insert(Podium.elements, object)
	
	--seats
	local object = createObject(3819, 1065.70, 1076.5, 11.10, 0, 0, 174)
	setElementDimension(object, getElementDimension(arenaElement))
	setObjectScale(object, 2)	
	table.insert(Podium.elements, object)
	
	--spotlight
	local object = createObject(2888, 1097.59, 1062.5, 10.5, 56, 0, 36)
	setElementDimension(object, getElementDimension(arenaElement))	
	table.insert(Podium.elements, object)
	
	local object = createObject(2887, 1097.59, 1062.40, 10.5, 55.96, 3.12, 36.65)
	setElementDimension(object, getElementDimension(arenaElement))	
	table.insert(Podium.elements, object)
	
	local spotlight = createSearchLight(1097.59, 1062.69, 12.19, 1093, 1068, 31.70, 1, 10)
	setElementDimension(spotlight, getElementDimension(arenaElement))	
	table.insert(Podium.elements, spotlight)		

	--spotlight
	local object = createObject(2888, 1078.80, 1085.5, 10.5, 56, 0, 216)
	setElementDimension(object, getElementDimension(arenaElement))	
	table.insert(Podium.elements, object)
	
	local object = createObject(2887, 1078.80, 1085.59, 10.5, 55.96, 3.12, 216)
	setElementDimension(object, getElementDimension(arenaElement))	
	table.insert(Podium.elements, object)
	
	local spotlight = createSearchLight(1078.90, 1085.40, 12.19, 1086.69, 1076.59, 33.20, 1, 10)
	setElementDimension(spotlight, getElementDimension(arenaElement))	
	table.insert(Podium.elements, spotlight)		
	
	Podium.animateStart = getTickCount()
	
	addEventHandler("onClientRender", root, Podium.render)
	
end
addEvent("onClientShowPodium", true)
addEventHandler("onClientShowPodium", root, Podium.set)


function Podium.reset()

	for i, data in pairs(Podium.data) do
	
		if isElement(data.ped) then destroyElement(data.ped) end
		if isElement(data.vehicle) then destroyElement(data.vehicle) end
		
	end

	for i, element in pairs(Podium.elements) do
	
		if isElement(element) then destroyElement(element) end
		
	end

	Podium.state = false
	Podium.data = {}
	Podium.effects = {}
	removeEventHandler("onClientRender", root, Podium.render)

end
addEvent("onClientArenaReset", true)
addEventHandler("onClientArenaReset", root, Podium.reset)


function Podium.render()

	local progress = ( getTickCount() - Podium.animateStart ) / Podium.animateTime

	progress = math.min(progress, 1)

	local x, y, _ = interpolateBetween(Podium.cameraStartPosition.x, Podium.cameraStartPosition.y, Podium.cameraStartPosition.z, Podium.finalCameraPosition.x, Podium.finalCameraPosition.y, Podium.finalCameraPosition.z, progress, "OutQuad")

	local _, _, z = interpolateBetween(Podium.cameraStartPosition.x, Podium.cameraStartPosition.y, Podium.cameraStartPosition.z, Podium.finalCameraPosition.x, Podium.finalCameraPosition.y, Podium.finalCameraPosition.z, progress, "OutBack")

	setCameraTarget(localPlayer)
	setCameraMatrix(x, y, z, Podium.locations[1][1], Podium.locations[1][2], Podium.locations[1][3])

	for i, data in pairs(Podium.data) do
	
		local prefix
	
		if i == 1 then
		
			prefix = "1st"
		
		elseif i == 2 then
		
			prefix = "2nd"
		
		elseif i == 3 then
		
			prefix = "3rd"
		
		end
		
		dxDrawTextOnElement(data.ped, prefix.."\n"..data.name, 1.5, 50, tocolor(255, 255, 255, 255), 2, "default-bold")
		
	end

end


function dxDrawTextOnElement(element, text, height, distance, color, size, font, ...)

	local x, y, z = getElementPosition(element)
	local x2, y2, z2 = getCameraMatrix()
	local distance = distance or 20
	local height = height or 1

	if (isLineOfSightClear(x, y, z+2, x2, y2, z2, ...)) then
	
		local sx, sy = getScreenFromWorldPosition(x, y, z + height)
		
		if sx and sy then
		
			local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
			
			if distanceBetweenPoints < distance then
			
				dxDrawText(text, sx+2, sy+2, sx, sy, color, (size or 1)-(distanceBetweenPoints / distance), font or "arial", "center", "center", false, false, false, true)
				
			end
			
		end
		
	end
	
end
