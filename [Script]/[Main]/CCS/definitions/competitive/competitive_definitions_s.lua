Competitive = {}
Competitive.arenas = {}
Competitive.arenas["Oldschool"] = {arena = "Competitive - Oldschool", inProgress = false, players = {}, winCondition = "hunter", round = 0, acceptTimer = nil, destroyTimer = nil, nextRoundTimer = nil, queue = {}}
Competitive.arenas["Shooter"] = {arena = "Competitive - Shooter", inProgress = false, players = {}, winCondition = "normal", round = 0, acceptTimer = nil, destroyTimer = nil, nextRoundTimer = nil, queue = {}}
Competitive.arenas["Cross"] = {arena = "Competitive - Cross", inProgress = false, players = {}, winCondition = "normal", round = 0, acceptTimer = nil, destroyTimer = nil, nextRoundTimer = nil, queue = {}}
Competitive.arenas["Modern"] = {arena = "Competitive - Modern", inProgress = false, players = {}, winCondition = "hunter", round = 0, acceptTimer = nil, destroyTimer = nil, nextRoundTimer = nil, queue = {}}
Competitive.arenas["Race"] = {arena = "Competitive - Race", inProgress = false, players = {}, winCondition = "race", round = 0, acceptTimer = nil, destroyTimer = nil, nextRoundTimer = nil, queue = {}}
Competitive.arenas["Classic"] = {arena = "Competitive - Classic", inProgress = false, players = {}, winCondition = "hunter", round = 0, acceptTimer = nil, destroyTimer = nil, nextRoundTimer = nil, queue = {}}
Competitive.matchMakeTimer = nil
Competitive.responseTimeout = 30000
Competitive.findMatchInterval = 60000
Competitive.maxRounds = 3
Competitive.roundsToWin = math.floor ( Competitive.maxRounds / 2 ) + 1
Competitive.cooldownList = {}
Competitive.cooldownTimes = {1800000, 3600000, 21600000, 86400000} --30 min, 1h, 6h, 24h
Competitive.savedPlayerQueues = {}

function Competitive.main()

	for i, p in ipairs(getElementsByType("player")) do
	
		setElementData(p, "competitive", {})
		
	end
	
end
addEventHandler("onResourceStart", resourceRoot, Competitive.main)


function Competitive.join()

	setElementData(source, "competitive", {})

end
addEventHandler("onPlayerJoin", root, Competitive.join)


function Competitive.quit()

	setElementData(source, "competitive", {})

	Competitive.removePlayerFromAllQueues(source)
		
end
addEvent("onPlayerLoggedOut", true)
addEventHandler("onPlayerLoggedOut", root, Competitive.quit)
addEventHandler("onPlayerQuit", root, Competitive.quit)


function Competitive.register(type)

	local serial = getPlayerSerial(source)

	if Competitive.cooldownList[serial] then
	
		local coolDownLevel= Competitive.cooldownList[serial].level
		local cooldownTime = getTickCount() - Competitive.cooldownList[serial].time
	
		if cooldownTime > Competitive.cooldownTimes[coolDownLevel] then
		
			Competitive.cooldownList[serial] = nil
	
		else
		
			local timeLeft = Competitive.cooldownTimes[coolDownLevel] - cooldownTime
		
			triggerClientEvent(source, "onClientCreateNotification", root, "Competitive: "..msToHourMinuteSecond(timeLeft).." Cooldown left!", "error")
			return
	
		end
	
	end

	--is player already registered in queue?
	for i, queue in pairs(Competitive.arenas[type].queue) do
	
		if queue.player == source then
		
			triggerClientEvent(source, "onClientCreateNotification", root, "Competitive: You are already registered!", "error")
			return
			
		end
	
	end

	Competitive.addPlayerToQueue(source, type)
	
	triggerClientEvent(source, "onClientCreateNotification", root, "Competitive: Successfully registered!", "information")
	
end
addEvent("onCompetitiveRegister", true)
addEventHandler("onCompetitiveRegister", root, Competitive.register)


function Competitive.deregister(type)

	Competitive.removePlayerFromQueue(source, type)

	triggerClientEvent(source, "onClientCreateNotification", root, "Competitive: Successfully unregistered!", "information")
	
end
addEvent("onCompetitiveDeregister", true)
addEventHandler("onCompetitiveDeregister", root, Competitive.deregister)


function Competitive.addPlayerToQueue(player, type)

	local arenaElement = getElementByID(Competitive.arenas[type].arena)

	table.insert(Competitive.arenas[type].queue, {player = player, registerTime = getTickCount()})

	setElementData(arenaElement, "queue", #Competitive.arenas[type].queue)
	
	Competitive.updatePlayerData(player, type, true)

end


function Competitive.removePlayerFromQueue(player, type)

	local arenaElement = getElementByID(Competitive.arenas[type].arena)

	--find and remove player from queue
	for i, queue in pairs(Competitive.arenas[type].queue) do
	
		if queue.player == player then
			
			table.remove(Competitive.arenas[type].queue, i)
			
			setElementData(arenaElement, "queue", #Competitive.arenas[type].queue)
			
			Competitive.updatePlayerData(player, type, false)
			
			break
			
		end
	
	end

end


function Competitive.removePlayerFromAllQueues(player)

	for type, data in pairs(Competitive.arenas) do
	
		Competitive.removePlayerFromQueue(player, type)

	end
		
end


function Competitive.getPlayerQueues(player)

	local queues = {}

	for type, data in pairs(Competitive.arenas) do
	
		for i, queue in pairs(data.queue) do
		
			if queue.player == player then
		
				table.insert(queues, type)
		
			end
		
		end

	end

	return queues
	
end


function Competitive.restorePlayerQueues(player)

	for i, type in pairs(Competitive.savedPlayerQueues[player]) do
	
		Competitive.addPlayerToQueue(player, type)
	
	end

end


function Competitive.updatePlayerData(player, key, value)

	local playerData = getElementData(player, "competitive")
	playerData[key] = value

	setElementData(player, "competitive", playerData)

end


function Competitive.getLongestQueuePlayer(type)

	local player
	local time = 0

	for i, queue in pairs(Competitive.arenas[type].queue) do
	
		local timeInQueue = getTickCount() - queue.registerTime
	
		if timeInQueue > time then
			
			player = queue.player
			time = timeInQueue
			
		end
	
	end

	return player

end


function Competitive.getRandomQueuePlayer(type)

	local index = math.random(#Competitive.arenas[type].queue)

	return Competitive.arenas[type].queue[index].player

end


function Competitive.matchMaker()

	for type, data in pairs(Competitive.arenas) do
		
		if not data.inProgress and #data.queue > 1 then
		
			local player1 = Competitive.getLongestQueuePlayer(type)
		
			Competitive.savedPlayerQueues[player1] = Competitive.getPlayerQueues(player1)
		
			Competitive.removePlayerFromAllQueues(player1)
			
			Competitive.updatePlayerData(player1, "waiting", type)
			
			local player2 = Competitive.getRandomQueuePlayer(type)
		
			Competitive.savedPlayerQueues[player2] = Competitive.getPlayerQueues(player2)
		
			Competitive.removePlayerFromAllQueues(player2)
			
			Competitive.updatePlayerData(player2, "waiting", type)
			outputDebugString("Matchmaker: "..getPlayerName(player1).." "..getPlayerName(player2))
			triggerClientEvent({player1, player2}, "onClientCompetitiveMatchFound", root, type, Competitive.responseTimeout)
			
			data.players = {{player = player1, state = false, wins = 0}, {player = player2, state = false, wins = 0}}
		
			data.acceptTimer = setTimer(Competitive.matchTimeout, Competitive.responseTimeout, 1, type)
		
			data.inProgress = true
		
		end
		
	end	

end
Competitive.matchMakeTimer = setTimer(Competitive.matchMaker, Competitive.findMatchInterval, 0)


function Competitive.matchTimeout(type)

	for i, player in pairs(Competitive.arenas[type].players) do
	
		if getElementData(player.player, "competitive")["ready"] then
		
			Competitive.restorePlayerQueues(player.player)
		
		end
	
		Competitive.updatePlayerData(player.player, "waiting", nil)
		Competitive.updatePlayerData(player.player, "ready", false)
	
		triggerClientEvent(player.player, "onClientCompetitiveMatchCancelled", root, true)
	
	end
	
	Competitive.arenas[type].inProgress = false
	
	outputDebugString("Competitive "..type..": Match timeout.")

end


function Competitive.matchResponse(type, acceptOrDecline)
	
	if not getElementData(source, "competitive")["waiting"] or getElementData(source, "competitive")["ready"] then return end

	if not acceptOrDecline then
	
		for i, player in pairs(Competitive.arenas[type].players) do
		
			triggerClientEvent(player.player, "onClientCompetitiveMatchCancelled", root)

			if player.player ~= source then
		
				Competitive.restorePlayerQueues(player.player)

			end
				
			Competitive.updatePlayerData(player.player, "waiting", nil)
			Competitive.updatePlayerData(player.player, "ready", false)
		
		end
	
		if isTimer(Competitive.arenas[type].acceptTimer) then killTimer(Competitive.arenas[type].acceptTimer) end
	
		Competitive.arenas[type].inProgress = false
	
		return
	
	end
		
	Competitive.updatePlayerData(source, "ready", true)	
		
	for i, player in pairs(Competitive.arenas[type].players) do

		if player.player == source then
		
			player.state = true
			
		end
	
	end
		
	--Count ready players	
	local readyPlayers = 0
		
	for i, player in pairs(Competitive.arenas[type].players) do

		if player.state then
		
			readyPlayers = readyPlayers + 1
			
		end
	
	end

	if readyPlayers == #Competitive.arenas[type].players then

		if isTimer(Competitive.arenas[type].acceptTimer) then killTimer(Competitive.arenas[type].acceptTimer) end
	
		local arenaElement = getElementByID(Competitive.arenas[type].arena)

		addEventHandler("onPrepareCountdown", arenaElement, Competitive.preMapStart, true, "low")
		addEventHandler("onPlayerWin", arenaElement, Competitive.playerWin)
		addEventHandler("onPlayerHunterPickup", arenaElement, Competitive.playerHunter)
		addEventHandler("onMapEnd", arenaElement, Competitive.mapEnd)
		addEventHandler("onPlayerLeaveArena", arenaElement, Competitive.playerLeave)
		addEventHandler("onPlayerDerbyWasted", arenaElement, Competitive.playerWasted)
	
		for i, player in pairs(Competitive.arenas[type].players) do
	
			Competitive.updatePlayerData(player.player, "waiting", nil)
			Competitive.updatePlayerData(player.player, "ready", false)
	
			triggerEvent("onLobbyKick", root, player.player, "Competitive", "Competitive")
	
			triggerClientEvent(player.player, "onArenaSelect", root, Competitive.arenas[type].arena, false, true)
	
			Competitive.updatePlayerData(player.player, "playing", true)
	
			local matches_played = exports["CCS_stats"]:export_getCompetitiveData(player.player, type, "matches_played")

			exports["CCS_stats"]:export_updateCompetitiveData(player.player, type, "matches_played", matches_played + 1)
	
		end
	
	else
	
		--Update number of players that are ready
		for i, player in pairs(Competitive.arenas[type].players) do
		
			triggerClientEvent(player.player, "onClientCompetitiveMatchUpdate", root, readyPlayers, #Competitive.arenas[type].players)
		
		end
	
	end
	
end
addEvent("onCompetitivePlayerMatchResponse", true)
addEventHandler("onCompetitivePlayerMatchResponse", root, Competitive.matchResponse)


function Competitive.playerLeave(arenaElement)

	if getElementData(source, "Spectator") then return end

	local type = getElementData(arenaElement, "type")

	if #getPlayersInArena(arenaElement) == 2 then
	
		Competitive.updatePlayerStats(source, type, false)
	
		Competitive.createCooldown(source, 2)
	
		outputChatBox("Competitive "..type..": "..getPlayerName(source):gsub('#%x%x%x%x%x%x', "").." left and receives a 60 min cooldown!", arenaElement, 255, 255, 0)
	
	end

	Competitive.matchEnd(type, false)
	
end
addEvent("onPlayerLeaveArena")


function Competitive.playerWin(playerName)

	local arenaElement = getElementParent(source)

	local type = getElementData(arenaElement, "type")
	
	if Competitive.arenas[type].winCondition == "hunter" then return end
	
	Competitive.roundWin(type, source)
	
end
addEvent("onPlayerWin")


function Competitive.playerHunter(isFirst)

	local arenaElement = getElementParent(source)

	local type = getElementData(arenaElement, "type")
	
	if Competitive.arenas[type].winCondition ~= "hunter" then return end
	
	if not isFirst then return end

	Competitive.roundWin(type, source)
	
end
addEvent("onPlayerHunterPickup")


function Competitive.playerWasted(aliveCount)

	local arenaElement = getElementParent(source)

	local type = getElementData(arenaElement, "type")

	if Competitive.arenas[type].winCondition ~= "hunter" then return end

	if isTimer(Competitive.arenas[type].nextRoundTimer) then return end
	
	if aliveCount > 1 then return end
	
	outputChatBox("Competitive "..type..": Round "..Competitive.arenas[type].round.." ended! Nobody won!", arenaElement, 255, 255, 0)

	Competitive.prepareNextRound(type)
	
	triggerEvent("onMapEnd", arenaElement)

end
addEvent("onPlayerDerbyWasted", true)

	
function Competitive.roundWin(type, player)

	local matchFinished = false
	
	local arenaElement = getElementByID(Competitive.arenas[type].arena)

	for i, playerData in pairs(Competitive.arenas[type].players) do
	
		if player == playerData.player then
		
			playerData.wins = playerData.wins + 1
			
			if playerData.wins == Competitive.roundsToWin then
			
				matchFinished = true
			
			end
			
		end
	
	end
	
	triggerEvent("onPlayerWin", source, getCleanPlayerName(player))
	
	triggerClientEvent(arenaElement, "onClientCompetitiveRoundWin", player)
	
	if matchFinished then
		
		Competitive.matchWin(type, player)
		
	else
	
		outputChatBox("Competitive "..type..": Round "..Competitive.arenas[type].round.." ended! "..getPlayerName(player):gsub('#%x%x%x%x%x%x', "").." won!", arenaElement, 255, 255, 0)
	
		Competitive.prepareNextRound(type)
		
		triggerEvent("onMapEnd", arenaElement)
	
	end

end


function Competitive.matchWin(type, player)

	if player then
	
		--winner
		local ratingChange = Competitive.updatePlayerStats(player, type, true)

		outputChatBox("Competitive "..type..": "..getPlayerName(player):gsub('#%x%x%x%x%x%x', "").." wins the match and gains "..ratingChange.." Skillpoints for "..type.."!", arenaElement, 255, 255, 0)
		
		--loser
		for i, playerData in pairs(Competitive.arenas[type].players) do

			if player ~= playerData.player then

				Competitive.updatePlayerStats(playerData.player, type, false)
				
			end

		end

		Competitive.matchEnd(type, true)
		
	else
	
		outputChatBox("Competitive "..type..": Match ended in a draw!", arenaElement, 255, 255, 0)
		
		Competitive.matchEnd(type, false)
		
	end

end


function Competitive.prepareNextRound(type)

	if Competitive.arenas[type].round == Competitive.maxRounds then
	
		local winPlayer
		local maxPoints = 0
		
		for i, playerData in pairs(Competitive.arenas[type].players) do

			if playerData.wins > maxPoints then
			
				winPlayer = playerData.player
				maxPoints = playerData.wins
				
			elseif playerData.wins == maxPoints then	
				
				winPlayer = nil
				
			end
			
		end

		Competitive.matchWin(type, winPlayer)
		
		return
	
	end

	local arenaElement = getElementByID(Competitive.arenas[type].arena)
	
	setElementData(arenaElement, "state", "End")
	
	local finishTime = getElementData(arenaElement, "finishTime") or 10000
	
	Competitive.arenas[type].nextRoundTimer = setTimer(Competitive.nextRound, finishTime, 1, type)

	triggerClientEvent(arenaElement, "onClientMapEnding", arenaElement, "Next map starts in: ", finishTime)

end


function Competitive.nextRound(type)

	local arenaElement = getElementByID(Competitive.arenas[type].arena)

	triggerEvent("onStartNewMap", arenaElement, MapManager.getRandomArenaMap(type), true)

end


--if map ends but nobody won
function Competitive.mapEnd(timeUp)

	local type = getElementData(source, "type")

	if not timeUp or isTimer(Competitive.arenas[type].nextRoundTimer) then return end

	outputChatBox("Competitive "..type..": Round "..Competitive.arenas[type].round.." ended! Nobody won!", source, 255, 255, 0)

	Competitive.prepareNextRound(type)

end
addEvent("onMapEnd", true)


function Competitive.preMapStart()

	local matchReady = true

	local type = getElementData(source, "type")
	
	for i, player in pairs(Competitive.arenas[type].players) do

		if getElementData(player.player, "state") ~= "Alive" then
	
			matchReady = false
		
			Competitive.updatePlayerStats(player.player, type, false)
		
			Competitive.createCooldown(player.player, 1)
		
			outputChatBox("Competitive "..type..": "..getPlayerName(player.player):gsub('#%x%x%x%x%x%x', "").." is not ready and receives a 30 min cooldown!", source, 255, 255, 0)

		end
			
	end
	
	if not matchReady then
		
		Competitive.matchEnd(type, false)
	
	else
	
		triggerEvent("onCountdownStart", source)
	
	end

	Competitive.arenas[type].round = Competitive.arenas[type].round + 1
	
	if Competitive.arenas[type].winCondition == "hunter" then
	
		outputChatBox("Competitive "..type..": Round "..Competitive.arenas[type].round.." of "..Competitive.maxRounds.."! First to reach Hunter wins!", source, 255, 255, 0)
	
	elseif Competitive.arenas[type].winCondition == "race" then
		
		outputChatBox("Competitive "..type..": Round "..Competitive.arenas[type].round.." of "..Competitive.maxRounds.."! First to finish the race wins!", source, 255, 255, 0)
	
	else
	
		outputChatBox("Competitive "..type..": Round "..Competitive.arenas[type].round.." of "..Competitive.maxRounds.."! Last one alive wins!", source, 255, 255, 0)
	
	end
	
end
addEvent("onPrepareCountdown")


function Competitive.matchEnd(type, byPlayerWin)

	local arenaElement = getElementByID(Competitive.arenas[type].arena)

	removeEventHandler("onPrepareCountdown", arenaElement, Competitive.preMapStart)
	removeEventHandler("onPlayerWin", arenaElement, Competitive.playerWin)
	removeEventHandler("onMapEnd", arenaElement, Competitive.mapEnd)
	removeEventHandler("onPlayerHunterPickup", arenaElement, Competitive.playerHunter)
	removeEventHandler("onPlayerLeaveArena", arenaElement, Competitive.playerLeave)
	removeEventHandler("onPlayerDerbyWasted", arenaElement, Competitive.playerWasted)
	
	setElementData(arenaElement, "state", "End")
	
	Competitive.arenas[type].destroyTimer = setTimer(Competitive.matchDestroy, 60000, 1, type)
	
	for i, player in pairs(Competitive.arenas[type].players) do

		Competitive.updatePlayerData(player.player, "playing", false)

	end	
	
	triggerClientEvent(arenaElement, "onClientCompetitiveMatchFinished", arenaElement, byPlayerWin)
	
	triggerEvent("onMapEnd", arenaElement)
	
	outputChatBox("Competitive "..type..": Arena will be cleared in 60 seconds.", arenaElement, 255, 255, 0)

end


function Competitive.matchDestroy(type)

	local arenaElement = getElementByID(Competitive.arenas[type].arena)

	if isElement(arenaElement) then
	
		for i, p in ipairs(getPlayersInArena(arenaElement)) do

			triggerEvent("onLobbyKick", arenaElement, p, "Kicked", "Match ended!")
			
		end

	end
	
	Competitive.arenas[type].inProgress = false
	
	Competitive.arenas[type].round = 0
	
	outputDebugString("Competitive "..type..": Match destroyed!")
	
end


function Competitive.createCooldown(player, level)

	local serial = getPlayerSerial(player)

	Competitive.cooldownList[serial] = {level = level, time = getTickCount()}

end


function Competitive.updatePlayerStats(player, type, winOrLose)

	if winOrLose then

		--wins
		local wins = exports["CCS_stats"]:export_getCompetitiveData(player, type, "wins")
	
		exports["CCS_stats"]:export_updateCompetitiveData(player, type, "wins", wins + 1)
	
	else
	
		--losses
		local losses = exports["CCS_stats"]:export_getCompetitiveData(player, type, "losses")

		exports["CCS_stats"]:export_updateCompetitiveData(player, type, "losses", losses + 1)
		
	end
	
	local myRating = exports["CCS_stats"]:export_getCompetitiveData(player, type, "rating")

	local otherRating

	for i, player in pairs(Competitive.arenas[type].players) do

		if source ~= player.player then

			--rating
			otherRating = exports["CCS_stats"]:export_getCompetitiveData(player.player, type, "rating")
			break
		
		end

	end
	
	local ratingChange = Competitive.calculateRatingChange(myRating, otherRating, winOrLose and 1 or 0)
	
	exports["CCS_stats"]:export_updateCompetitiveData(player, type, "rating", myRating + ratingChange)
	
	return ratingChange
	
end


function Competitive.calculateRatingChange(myRating, opponentRating, myGameResult)
	
	local myChance = 1 / (1 + math.pow(10, (tonumber(opponentRating) - tonumber(myRating)) / 400))

	local delta = 32 * (tonumber(myGameResult) - myChance)

	return math.floor ( delta )

end


function Competitive.skillInfo()

	local matches = 0
	local skill = 0
	
	for type, _ in pairs(Competitive.arenas) do
	
		local matches_for_type = exports["CCS_stats"]:export_getCompetitiveData(source, type, "matches_played")
	
		if not matches_for_type then return end
	
		matches = matches + matches_for_type
	
		local skill_for_type = exports["CCS_stats"]:export_getCompetitiveData(source, type, "rating")
	
		if not skill_for_type then return end
	
		skill = skill + skill_for_type
	
	end
	
	triggerClientEvent(source, "onClientCompetitiveInfo", source, {skillPoints = math.floor(skill / 6), matches = matches})

end
addEvent("onCompetitiveRequestInfo", true)
addEventHandler("onCompetitiveRequestInfo", root, Competitive.skillInfo)


-------------------------------

function Competitive.debugQueue(p, c, type)
	
	outputDebugString(#Competitive.arenas[type].queue)
	
	for i, queue in pairs(Competitive.arenas[type].queue) do
	
		outputDebugString(getPlayerName(queue.player))


	end
	
	outputDebugString(tostring(Competitive.arenas[type].inProgress))

end
addCommandHandler("debugcomp", Competitive.debugQueue)