function getPlayersInArena(arenaElement)

	local playerTable = {}

	for i, p in ipairs(getElementChildren(arenaElement)) do

		if getElementType(p) == "player" and not getElementData(p, "Spectator") then

			table.insert(playerTable, p)
			
		end
		
	end

	return playerTable

end
export_getPlayersInArena = getPlayersInArena


function getAlivePlayersInArena(arenaElement)

	local playerTable = {}

	for i, p in ipairs(getElementChildren(arenaElement)) do

		if getElementType(p) == "player" and not getElementData(p, "Spectator") then

			if getElementData(p, "state") == "Alive" then
			
				table.insert(playerTable, p)
				
			end
			
		end
		
	end

	return playerTable

end
export_getAlivePlayersInArena = getAlivePlayersInArena


function getPlayersAndSpectatorsInArena(arenaElement)

	local playerTable = {}

	for i, p in ipairs(getElementChildren(arenaElement)) do

		if getElementType(p) == "player" then

			table.insert(playerTable, p)
			
		end
		
	end

	return playerTable

end


function getSpectatorsInArena(arenaElement)

	local playerTable = {}

	for i, p in ipairs(getElementChildren(arenaElement)) do

		if getElementType(p) == "player" and getElementData(p, "Spectator") then

			table.insert(playerTable, p)
			
		end
		
	end

	return playerTable

end


function getTeamsInArena(arenaElement)

	local teamTable = {}

	for i, p in ipairs(getElementChildren(arenaElement)) do

		if getElementType(p) == "team" then

			table.insert(teamTable, p)
			
		end
		
	end

	return teamTable

end
export_getTeamsInArena = getTeamsInArena


function getCleanPlayerName(p)

	return string.gsub(getPlayerName(p), '#%x%x%x%x%x%x', '')

end



function findArenaPlayer(arenaElement, name)

	if not name then return false end

    for i, p in ipairs(getPlayersInArena(arenaElement)) do
	
        local fullname = getCleanPlayerName(p):lower()
		
        if string.find(fullname, name:lower(), 1, true) then
		
            return p
			
        end
		
    end
	
    return false
	
end
export_findArenaPlayer = findArenaPlayer


function findPlayerAll(name)

	if not name then return false end

    for i, p in ipairs(getElementsByType("player")) do
	
        local fullname = getCleanPlayerName(p):lower()
		
        if string.find(fullname, name:lower(), 1, true) then
		
            return p
			
        end
		
    end
	
    return false
	
end
export_findPlayerAll = findPlayerAll


function getPlayerFromAccount(account)

	for i, p in pairs(getElementsByType("player")) do
	
		if getElementData(p, "account") == account then
		
			return p
			
		end
		
	end

	return false
	
end
export_getPlayerFromAccount = getPlayerFromAccount


