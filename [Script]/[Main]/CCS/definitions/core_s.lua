Core = {}

function Core.lobbyPlayer(player, action, reason)

	triggerEvent("onLeaveArena", player, action or "")
	
	triggerClientEvent(player, "onClientLobbyKick", root, reason)

end
addEvent("onLobbyKick")
addEventHandler("onLobbyKick", root, Core.lobbyPlayer)


function Core.cleanArena(arenaElement)

	if getElementData(arenaElement, "map") then

		outputServerLog(getElementID(arenaElement)..": Map End")

	end

	outputServerLog(getElementID(arenaElement)..": Reset")
	triggerEvent("onArenaReset", arenaElement)


	--Reset Element Data
	setElementData(arenaElement, "state", "End")
	setElementData(arenaElement, "map", false)

	--Kill all Players
	Arena.killAllPlayers(arenaElement)

	--Destroy Timers
	if isTimer(Arena.timers[arenaElement].primaryTimer) then killTimer(Arena.timers[arenaElement].primaryTimer) end
	if isTimer(Arena.timers[arenaElement].secondaryTimer) then killTimer(Arena.timers[arenaElement].secondaryTimer) end
	if isTimer(Arena.timers[arenaElement].hunterFightTimer) then killTimer(Arena.timers[arenaElement].hunterFightTimer) end
	Arena.timers[arenaElement] = {}

	triggerClientEvent(arenaElement, "onClientArenaReset", arenaElement)

end


function Core.getTimePassed(arenaElement)

	if getElementData(arenaElement, "state") == "End" and not isTimer(Arena.timers[arenaElement].primaryTimer) then

		return getElementData(arenaElement, "Duration")

	end

	if not isTimer(Arena.timers[arenaElement].primaryTimer) then return 0 end

	local leftTime = getTimerDetails(Arena.timers[arenaElement].primaryTimer)

	return getElementData(arenaElement, "Duration") - leftTime

end
export_getTimePassed = Core.getTimePassed


function Core.getWaitingTime(arenaElement)

	if getElementData(arenaElement, "state") ~= "Waiting" then return false end

	if not isTimer(Arena.timers[arenaElement].secondaryTimer) then return 30000 end

	return getTimerDetails(Arena.timers[arenaElement].secondaryTimer)

end


function Core.setupDefinitions(arenaElement)

	if getElementData(arenaElement, "gamemode") == "Freeroam" then

		triggerEvent("onSetUpFreeroamDefinitions", arenaElement)

	elseif getElementData(arenaElement, "gamemode") == "Race" then

		triggerEvent("onSetUpDerbyDefinitions", arenaElement)

	end

end

--the order of things in this function is important
function Core.joinArena(arena, isSpectator)

	local arenaElement = getElementByID(arena)

	setElementParent(source, arenaElement)
	setElementData(source, "Arena", arena)
	setElementData(source, "Spectator", isSpectator)
	setElementData(source, "state", "Joined")
	setElementData(arenaElement, "players", getElementData(arenaElement, "players") + 1)

	if ACL.checkBan(getPlayerSerial(source), arena) then

		triggerEvent("onLobbyKick", arenaElement, source, "Kicked", "You are banned from this Arena!")
		return

	end

	triggerClientEvent(arenaElement, "onClientPlayerJoinArena", source, isSpectator)
	triggerEvent("onPlayerJoinArena", source, arenaElement, arena)

	spawnPlayer(source, 0, 0, 0, 0, 0, 0, getElementDimension(arenaElement))
	setElementFrozen(source, true)
	setElementHealth(source, 100)
	
	if getElementData(arenaElement, "gamemode") == "Freeroam" then

		triggerClientEvent(source, "onClientSetUpFreeroamDefinitions", root)

	elseif getElementData(arenaElement, "gamemode") == "Race" then

		if getElementData(arenaElement, "mode") == "Training" then
		
			setElementData(source, "Arena", "Training")
			triggerClientEvent(source, "onClientSetUpTrainingDefinitions", arenaElement)
			triggerClientEvent(source, "onClientPlayerReady", arenaElement, false, false)
	
		end
	
		triggerClientEvent(source, "onClientSetUpDerbyDefinitions", arenaElement)

	end

	--Only one player in this arena now, so setup the definitions for it
	if #getPlayersAndSpectatorsInArena(arenaElement) == 1 then
	
		Core.setupDefinitions(arenaElement)

	end
	
	triggerEvent("onStartDownload", arenaElement, source)
	
end
addEvent("onJoinArena", true)
addEventHandler("onJoinArena", root, Core.joinArena)


function Core.leaveArena(quitType)

	local lobbyElement = getElementByID("Lobby")
	local arenaElement = getElementParent(source)

	--Disconnect before initial download finished
	if not arenaElement or arenaElement == root then return end

	triggerClientEvent(arenaElement, "onClientPlayerLeaveArena", source, getPlayerName(source), quitType)
	triggerEvent("onPlayerLeaveArena", source, arenaElement)
	
	triggerClientEvent(source, "onClientSetDownDerbyDefinitions", arenaElement)
	triggerClientEvent(source, "onClientSetDownFreeroamDefinitions", arenaElement)
	triggerClientEvent(source, "onClientSetDownTrainingDefinitions", arenaElement)

	--Leave while being in Lobby means he left server
	if arenaElement == lobbyElement then return end

	--kill him so he ends up in rankingboard
	killPed(source)
	triggerClientEvent(source, "onClientArenaReset", arenaElement)
	setElementParent(source, lobbyElement)
	setElementData(arenaElement, "players", getElementData(arenaElement, "players") - 1)

	--spawn and freeze to prevent falling sound
	spawnPlayer(source, 0, 0, 0)
	setElementFrozen(source, true)
	setPlayerMuted(source, false)
	setElementHealth(source, 100)
	setElementAlpha(source, 255)
	triggerEvent("onDownloadCancel", source)
	setPlayerTeam(source, nil)
	setElementData(source, "Spectator", false)
	setElementData(source, "Arena", "Lobby")
	setElementData(source, "state", "Lobby")
	
	if #getPlayersInArena(arenaElement) == 0 and not getElementData(source, "Spectator") then

		for i, p in ipairs(getPlayersAndSpectatorsInArena(arenaElement)) do

			triggerEvent("onLobbyKick", arenaElement, p, "Kicked", "Arena was destroyed!")

		end

		Core.cleanArena(arenaElement)

		triggerEvent("onSetDownDerbyDefinitions", arenaElement)

		triggerEvent("onSetDownFreeroamDefinitions", arenaElement)

		triggerEvent("onSetDownReplayDefinitions", arenaElement)

		setElementData(arenaElement, "nextmap", {})

		if getElementData(arenaElement, "temporary") then

			triggerEvent("onArenaDestroy", arenaElement, getElementID(arenaElement))

		end

	end

end
addEvent("onLeaveArena", true)
addEventHandler("onLeaveArena", root, Core.leaveArena)
addEventHandler( "onPlayerQuit", root, Core.leaveArena)
