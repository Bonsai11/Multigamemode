Killdetection = {}
Killdetection.resetTimer = nil
Killdetection.killResetInterval = 6000

function Killdetection.load(map)

	if map.type ~= "Cross" then return end

	addEventHandler("onClientVehicleCollision", root, Killdetection.detectHit)
	
end
addEvent("onClientMapStart", true)
addEventHandler("onClientMapStart", root, Killdetection.load)


function Killdetection.unload()

	removeEventHandler("onClientVehicleCollision", root, Killdetection.detectHit)

	if isTimer(Killdetection.resetTimer) then killTimer(Killdetection.resetTimer) end
	
end
addEvent("onClientArenaReset", true)
addEventHandler("onClientArenaReset", root, Killdetection.unload)


function Killdetection.detectHit(theHitElement)

	local vehicle = getPedOccupiedVehicle(localPlayer)
	
	if not vehicle then return end

	if source ~= vehicle then return end

	if getElementType(theHitElement) ~= "vehicle" then return end

	local player = getVehicleOccupant(theHitElement)
	
	if not player then return end
	
	setElementData(localPlayer, "derby_killer", player)

	if isTimer(Killdetection.resetTimer) then killTimer(Killdetection.resetTimer) end
	
	Killdetection.resetTimer = setTimer(Killdetection.resetHit, Killdetection.killResetInterval, 1)
	
end


function Killdetection.resetHit()

	local vehicle = getPedOccupiedVehicle(localPlayer)
	
	if not vehicle then return end

	if getElementHealth(vehicle) < 250 then 
	
		Killdetection.resetTimer = setTimer(Killdetection.resetHit, Killdetection.killResetInterval, 1)
		return
		
	end
	
	if isElementInWater(vehicle) then 
	
		Killdetection.resetTimer = setTimer(Killdetection.resetHit, Killdetection.killResetInterval, 1)
		return
		
	end

	setElementData(localPlayer, "derby_killer", nil)
	
end



