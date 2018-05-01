Killdetection = {}

function Killdetection.load(map)

	if map.type ~= "Shooter" then return end

	addEventHandler("onClientColShapeHit", root, Killdetection.detectHit)
	addEventHandler("onClientProjectileCreation", root, Killdetection.registerMissle)
	
end
addEvent("onClientMapStart", true)
addEventHandler("onClientMapStart", root, Killdetection.load)


function Killdetection.unload()

	removeEventHandler("onClientColShapeHit", root, Killdetection.detectHit)
	removeEventHandler("onClientProjectileCreation", root, Killdetection.registerMissle)

end
addEvent("onClientArenaReset", true)
addEventHandler("onClientArenaReset", root, Killdetection.unload)


function Killdetection.getPositionFromElementOffset(element, distance)

    return element.matrix.position + element.matrix.forward * distance
	
end


function Killdetection.registerMissle(creator)
	
	if not creator then return end
	
	if getElementType(creator) == "vehicle" then 
	
		creator = getVehicleOccupant(creator)
		
	end
	
	if not getElementType(creator) == "player" then return end
	
	if creator ~= localPlayer then return end
	
	local vec = Killdetection.getPositionFromElementOffset(getPedOccupiedVehicle(localPlayer), 1)
	
	--For Killdetection
	local dummy = createObject(1337, vec.x, vec.y, vec.z)
	setElementDimension(dummy, getElementDimension(localPlayer))
	setElementAlpha(dummy, 0)
	setElementCollisionsEnabled(dummy, false)
	setElementID(dummy, "dummy")
	local distance = 150 + (exports["CCS"]:export_getElementSpeed(getPedOccupiedVehicle(localPlayer))*0.9)
	local vec = Killdetection.getPositionFromElementOffset(getPedOccupiedVehicle(localPlayer), distance)
	moveObject(dummy, 3000, vec.x, vec.y, vec.z)
	setTimer(destroyElement, 3000, 1, dummy)
	
end


function Killdetection.detectHit(element)

	if getElementID(element) ~= "dummy" then return end

	local player = getElementData(source, "creator")
	
	if not player then return end

	if getElementData(source, "creator") == localPlayer then return end

	if getElementData(player, "state") ~= "Alive" then return end
	
	triggerServerEvent("onProjectilePlayerHit", localPlayer, player)

end



