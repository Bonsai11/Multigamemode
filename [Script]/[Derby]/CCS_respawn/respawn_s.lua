Respawn = {}
Respawn.vehicles = {}

function Respawn.reset()

	if not Respawn.vehicles[source] then
	
		Respawn.vehicles[source] = {}
		
	end

	for i, vehicle in pairs(Respawn.vehicles[source]) do
	
		if isElement(vehicle) then
		
			destroyElement(vehicle)
			
		end
	
	end
	
	Respawn.vehicles[source] = {}
	
end
addEvent("onArenaReset", true)
addEventHandler("onArenaReset", root, Respawn.reset)


function Respawn.respawn(model)

	if not isElement(source) then return end

	if getElementData(source, "state") ~= "Spectating" then return end

	local arenaElement = getElementParent(source)
	
	if getElementData(arenaElement, "state") ~= "In Progress" then return end

	local localVehicle = createVehicle(model, 0, 0, 0) 

	if Respawn.vehicles[arenaElement][source] then
	
		if isElement(Respawn.vehicles[arenaElement][source]) then
		
			destroyElement(Respawn.vehicles[arenaElement][source])
			
		end
		
	end	
	
	Respawn.vehicles[arenaElement][source] = localVehicle

	setElementParent(localVehicle, arenaElement)

	if getPlayerTeam(source) then
	
		local r, g, b = getTeamColor(getPlayerTeam(source))
		setVehicleColor(localVehicle, r, g, b)
		
	elseif getElementData(source, "setting:car_color") then

		local color = getElementData(source, "setting:car_color")
		local color2 = getElementData(source, "setting:car_color2")
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
	spawnPlayer(source, 0, 0, 3)
	setElementAlpha(source, 255)
	setElementDimension(source, getElementDimension(arenaElement))
	warpPedIntoVehicle(source, localVehicle)
	setVehicleOverrideLights(localVehicle, 2)
	setCameraTarget(source, source)
	addEventHandler("onVehicleStartExit", localVehicle, Respawn.stayInVehicle)
	
	setElementData(source, "state", "Respawned")

	triggerClientEvent(source, "onClientPlayerRespawn", arenaElement)	

end
addEvent("onPlayerRequestRespawn", true)
addEventHandler("onPlayerRequestRespawn", root, Respawn.respawn)


function Respawn.stayInVehicle()

	cancelEvent()

end