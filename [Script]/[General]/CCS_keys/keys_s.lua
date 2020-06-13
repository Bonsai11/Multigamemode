Keys = {}
Keys.updateInterval = 100
Keys.playerList = {}
Keys.keys = {"accelerate", "brake_reverse", "vehicle_left", "vehicle_right", "handbrake", "left", "right", "steer_forward", "steer_back"}

function Keys.update()

	Keys.playerList = {}

	for i, player in ipairs(getElementsByType("player")) do
	
		if getElementData(player, "state") == "Alive" then
		
			Keys.playerList[player] = {}
		
			for i, key in pairs(Keys.keys) do
		
				Keys.playerList[player][key] = getControlState(player, key)
			
			end
			
		end
		
	end
	
	triggerClientEvent(root, 'onKeysUpdate', root, Keys.playerList)
	
end
setTimer(Keys.update, Keys.updateInterval, 0)