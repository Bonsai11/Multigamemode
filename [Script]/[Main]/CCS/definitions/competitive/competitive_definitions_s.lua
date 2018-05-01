Competitive = {}
Competitive.queue = {}
Competitive.queue["oldschool"] = {}
Competitive.matchMakeTimer = nil
Competitive.matchList = {}

function Competitive.register(maptype)

	--is player already registered in queue?
	for i, player in pairs(Competitive.queue["oldschool"]) do
	
		if player == source then
		
			return
			
		end
	
	end

	table.insert(Competitive.queue["oldschool"], source)

	outputDebugString("Competitive: "..getCleanPlayerName(source).." registered.")
	
	outputDebugString("Competitive: "..#Competitive.queue["oldschool"].." searching.")

	outputChatBox("Competitive: Registered!", source, 255, 255, 0)	
	
end
addEvent("onCompetitiveRegister", true)
addEventHandler("onCompetitiveRegister", root, Competitive.register)


function Competitive.deregister()

	Competitive.removePlayerFromQueue(source)

	outputChatBox("Competitive: Deregistered!", source, 255, 255, 0)	
	
end
addEvent("onCompetitiveDeregister", true)
addEventHandler("onCompetitiveDeregister", root, Competitive.deregister)


function Competitive.removePlayerFromQueue(player)

	--find and remove player from queue
	for i, p in pairs(Competitive.queue["oldschool"]) do
	
		if p == player then
			
			table.remove(Competitive.queue["oldschool"], i)
			
			outputDebugString("Competitive: "..getCleanPlayerName(player).." deregistered.")
			
			break
			
		end
	
	end

end


function Competitive.playerLeave()

	Competitive.removePlayerFromQueue(source)

end
addEvent("onPlayerLeaveArena")
addEventHandler("onPlayerLeaveArena", root, Competitive.playerLeave)
addEventHandler("onPlayerQuit", root, Competitive.playerLeave)


function Competitive.matchMaker()

	while #Competitive.queue["oldschool"] > 1 do
	
		local matchID = math.random(10000000)
	
		matchID = tostring(matchID)
	
		local player1 = Competitive.queue["oldschool"][1]
		
		local player2 = Competitive.queue["oldschool"][2]
	
		triggerClientEvent(player1, "onClientCompetitiveMatchFound", root, matchID)
	
		triggerClientEvent(player2, "onClientCompetitiveMatchFound", root, matchID)
	
		Competitive.removePlayerFromQueue(player1)
	
		Competitive.removePlayerFromQueue(player2)
		
		Competitive.matchList[matchID] = {}
		
		Competitive.matchList[matchID].players = {{player = player1, state = false}, {player = player2, state = false}}
	
		Competitive.matchList[matchID].acceptTimer = setTimer(Competitive.matchTimeout, 30000, 1, matchID)
	
		Competitive.matchList[matchID].maptype = "Oldschool"
	
		outputDebugString("Competitive: Match "..matchID..": Match created.")
	
	end

end
Competitive.matchMakeTimer = setTimer(Competitive.matchMaker, 60000, 0)


function Competitive.matchTimeout(matchID)

	for i, player in pairs(Competitive.matchList[matchID].players) do
	
		triggerClientEvent(player.player, "onClientCompetitiveMatchCancelled", root, true)
	
	end

	Competitive.matchList[matchID] = nil
	
	outputDebugString("Competitive: Match "..matchID..": Match timeout was reached.")

end


function Competitive.matchResponse(matchID, acceptOrDecline)

	if not Competitive.matchList[matchID] then
	
		outputDebugString("Competitive: Match "..matchID..": No Match with this ID.")
		return
		
	end

	if not acceptOrDecline then
	
		for i, player in pairs(Competitive.matchList[matchID].players) do
		
			if player.player ~= source then
		
				triggerClientEvent(player.player, "onClientCompetitiveMatchCancelled", root)
		
			end
		
		end
	
		if isTimer(Competitive.matchList[matchID].acceptTimer) then killTimer(Competitive.matchList[matchID].acceptTimer) end
	
		outputDebugString("Competitive: Match "..matchID..": Match cancelled.")
	
		return
	
	end
		
	for i, player in pairs(Competitive.matchList[matchID].players) do

		if player.player == source then
		
			player.state = true
			
		end
	
	end
		
	--Count ready players	
	local readyPlayers = 0
		
	for i, player in pairs(Competitive.matchList[matchID].players) do

		if player.state then
		
			readyPlayers = readyPlayers + 1
			
		end
	
	end

	if readyPlayers == #Competitive.matchList[matchID].players then

		if isTimer(Competitive.matchList[matchID].acceptTimer) then killTimer(Competitive.matchList[matchID].acceptTimer) end
	
		local myArena = Arena.new(matchID, "Race", "Race", Competitive.matchList[matchID].maptype, 2, false, "Competitive", "#999999", 480000, false, false, false, false, "Server", true, true, false, false, false, false, false, false, false, false, true)	
		
		if myArena then

			Competitive.matchList[matchID].arena = myArena
		
			setElementData(myArena.element, "matchID", matchID)
		
			addEventHandler("onPlayerWin", myArena.element, Competitive.matchEnd)
		
			for i, player in pairs(Competitive.matchList[matchID].players) do
		
				triggerEvent("onLobbyKick", root, player.player, "Competitive", "Competitive")
		
				triggerClientEvent(player.player, "onArenaSelectButton", root, myArena.name)
		
			end
		
		else
		
			outputDebugString("Competitive: Match "..matchID..": Failed to create Arena.")
		
		end
	
	else
	
		--Update number of players that are ready
		for i, player in pairs(Competitive.matchList[matchID].players) do
		
			triggerClientEvent(player.player, "onClientCompetitiveMatchUpdate", root, readyPlayers, #Competitive.matchList[matchID].players)
		
		end
	
	end
	
end
addEvent("onCompetitivePlayerMatchResponse", true)
addEventHandler("onCompetitivePlayerMatchResponse", root, Competitive.matchResponse)


function Competitive.matchEnd(playerName)

	local arenaElement = getElementParent(source)
	
	local matchID = getElementData(arenaElement, "matchID")

	outputDebugString("Competitive: Match "..matchID..": "..playerName.." won!")
	
	removeEventHandler("onPlayerWin", arenaElement, Competitive.matchEnd)
	
	Competitive.matchList[matchID].destroyTimer = setTimer(Competitive.matchDestroy, 60000, 1, matchID)
	
	outputChatBox("Arena will be destroyed in 60 seconds.", arenaElement, 255, 255, 0)

end
addEvent("onPlayerWin")


function Competitive.matchDestroy(matchID)

	local arenaElement = Competitive.matchList[matchID].arena.element

	if isElement(arenaElement) then
	
		for i, p in ipairs(getPlayersAndSpectatorsInArena(arenaElement)) do

			triggerEvent("onLobbyKick", arenaElement, p, "Kicked", "Arena was destroyed!")

		end

	end
		
	Competitive.matchList[matchID] = nil
	
	outputDebugString("Competitive: Match "..matchID..": Match destroyed!")
	
end


function Competitive.calculateRatingChange(myRating, opponentRating, myGameResult)
	
	local myChance = 1 / (1 + math.pow(10, (tonumber(opponentRating) - tonumber(myRating)) / 400))

	local delta = 32 * (tonumber(myGameResult) - myChance)

	return delta

end