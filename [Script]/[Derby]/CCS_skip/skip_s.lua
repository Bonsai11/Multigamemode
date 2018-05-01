Skip = {}
Skip.votes = {}
Skip.votedPlayers = {}
Skip.locked = {}
Skip.mapHistory = {}
Skip.percentNeeded = 1

function Skip.mapChange(map)

	--Reset
	Skip.votes[source] = 0
	Skip.votedPlayers[source] = {}
	Skip.locked[source] = false

end
addEvent("onMapChange", true)
addEventHandler("onMapChange", root, Skip.mapChange)


function Skip.command(player) 

	local element = getElementParent(player)

	if getElementData(element, "state") ~= "In Progress" then return end
	
	if Skip.locked[element] then return end
	
	if getElementData(player, "state") ~= "Alive" then
	
		outputChatBox("Only alive players can vote!", player)
		return 
		
	end

	--Player already voted
	if Skip.votedPlayers[element][getPlayerSerial(player)] then return end

	Skip.votes[element] = Skip.votes[element] + 1
	
	Skip.votedPlayers[element][getPlayerSerial(player)] = true
	
	local playerName = getPlayerName(player)

	local missing = math.ceil((#exports["CCS"]:export_getAlivePlayersInArena(element) * Skip.percentNeeded)) - Skip.votes[element]
	
	--if some players who already voted leave, it might go negative
	missing = math.max(missing, 0)
	
	triggerClientEvent(element, "onClientCreateMessage", element, playerName.." #00ff00used /skip! ("..(Skip.percentNeeded*100).."% Mode | "..missing.." votes missing)")
	
	if missing == 0 then
	
		Skip.locked[element] = true
		
		triggerClientEvent(element, "onClientCreateMessage", element, "#00ff00Skip successful!")

		exports["CCS"]:export_outputArenaChat(element, "#00f000Skip: This map will be skipped.")
	
		triggerEvent("onMapEnd", element)
	
	end

end
addCommandHandler("skip", Skip.command)
