Spectators = {}
Spectators.updateInterval = 1000 
Spectators.playerList = {}

function Spectators.update()

	Spectators.playerList = {}

	for i, player in ipairs(getElementsByType("player")) do
	
		if getElementData(player, "state") ~= "Alive" then
		
			local target = Spectators.getCameraTargetPlayer(player)
			
			if target and getElementType(target) == "player" and target ~= player then
			
				--create list if not existing
				if not Spectators.playerList[player] then
				
					Spectators.playerList[player] = {}
					
				end
				
				Spectators.playerList[player] = target
				
			end
			
		end
		
	end
	
	triggerClientEvent(root, 'onSpectatorsUpdate', root, Spectators.playerList)
	
end
setTimer(Spectators.update, Spectators.updateInterval, 0)


function Spectators.getCameraTargetPlayer(player)

	local target = getCameraTarget(player)
	
	if target and getElementType(target) == "vehicle" then
	
		target = getVehicleOccupant(target)
		
	end
	
	if target and getElementType(target) ~= "player" then
	
		return false
	
	end
	
	return target

end
