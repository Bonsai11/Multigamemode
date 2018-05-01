Spectator = {}

function Spectator.spectate(p)

	local arenaElement = getElementParent(p)

	if getElementData(arenaElement, "gamemode") ~= "Race" then return end
	
	if getElementData(arenaElement, "state") ~= "In Progress" then return end
	
	local map = getElementData(arenaElement, "map")
	
	if not map then return end
	
	if map.type == "Race" then return end	
	
	if not getElementData(p, "adminSpectate") then

		setElementData(p, "adminSpectate", true)
		
		local myVehicle = getPedOccupiedVehicle(p)
		
		if not myVehicle then return end
		
		setElementAlpha(myVehicle, 0)
		setElementAlpha(p, 0)
		setElementFrozen(myVehicle, true)
		setElementCollisionsEnabled(myVehicle, false)
		triggerClientEvent(p, "onAdminSpectate", root)
		
	else
		
		setElementData(p, "adminSpectate", false)
		
		local myVehicle = getPedOccupiedVehicle(p)
		
		if myVehicle == false then return end
		
		setCameraTarget(p)
		setElementAlpha(myVehicle, 155)	
		setElementAlpha(p, 255)
		setTimer(setElementAlpha, 1000, 1, myVehicle, 255)	
		setTimer(setElementFrozen, 1000, 1, myVehicle, false)
		setTimer(setElementCollisionsEnabled, 1000, 1, myVehicle, true)
		triggerClientEvent(p, "onAdminSpectate", root)
		
	end

end
addCommandHandler("spectate", Spectator.spectate)


function Spectator.restore()

	for i, p in ipairs(getPlayersInArena(source)) do
		
		setElementData(p, "adminSpectate", false)
		setElementData(p, "raceSpectate", false)
		setElementAlpha(p, 255)

	end

end
addEvent("onArenaReset", true)
addEventHandler("onArenaReset", root, Spectator.restore)


function Spectator.racespectate(p)

	local arenaElement = getElementParent(p)

	if getElementData(arenaElement, "gamemode") ~= "Race" then return end
	
	if getElementData(arenaElement, "state") ~= "In Progress" then return end
	
	local map = getElementData(arenaElement, "map")
	
	if not map then return end
	
	if map.type ~= "Race" then return end	

	if not getElementData(p, "raceSpectate") then

		setElementData(p, "raceSpectate", true)
		
		local myVehicle = getPedOccupiedVehicle(p)
		
		if not myVehicle then return end
		
		setElementAlpha(myVehicle, 0)
		setElementAlpha(p, 0)
		setElementFrozen(myVehicle, true)
		setElementCollisionsEnabled(myVehicle, false)
		triggerClientEvent(p, "onAdminSpectate", root)
		
	else
		
		setElementData(p, "raceSpectate", false)
		
		local myVehicle = getPedOccupiedVehicle(p)
		
		if not myVehicle then return end
		
		setCameraTarget(p)
		setElementAlpha(myVehicle, 155)	
		setElementAlpha(p, 255)
		setTimer(setElementAlpha, 1000, 1, myVehicle, 255)	
		setTimer(setElementFrozen, 1000, 1, myVehicle, false)
		setTimer(setElementCollisionsEnabled, 1000, 1, myVehicle, true)
		triggerClientEvent(p, "onAdminSpectate", root)
		
	end

end
addCommandHandler("racespectate", Spectator.racespectate)

