Commands = {}

function Commands.ghostmode(p,c,t)

	local arenaElement = getElementParent(p)

	if not getElementData(arenaElement, "GhostMode") then

		for i, player in ipairs(getPlayersInArena(arenaElement)) do

			if getPedOccupiedVehicle(player) then

				setElementData(getPedOccupiedVehicle(player), "no_collision", true)

			end

		end

		Chat.outputArenaChat(arenaElement, "#00ff00Ghostmode enabled by "..getCleanPlayerName(p))
		setElementData(arenaElement, "GhostMode", true)

	elseif getElementData(arenaElement, "GhostMode") then

		for i, player in ipairs(getPlayersInArena(arenaElement)) do

			if getPedOccupiedVehicle(player) then

				setElementData(getPedOccupiedVehicle(player), "no_collision", false)

			end

		end

		Chat.outputArenaChat(arenaElement, "#ff0000Ghostmode disabled by "..getCleanPlayerName(p))
		setElementData(arenaElement, "GhostMode", false)

	end

end
addCommandHandler("gm", Commands.ghostmode)


function Commands.mute(p, c, player)

	local arenaElement = getElementParent(p)

	if player then

		player = findArenaPlayer(arenaElement, player)

	else

		player = p

	end

	if not player then return end

	if not isPlayerMuted(player) then

		setPlayerMuted(player, true)
		Chat.outputArenaChat(arenaElement, "#ff0000"..getCleanPlayerName(p).."#ff0000 muted "..getCleanPlayerName(player).."!")

	else

		setPlayerMuted(player, false)
		Chat.outputArenaChat(arenaElement, "#00ff00"..getCleanPlayerName(p).."#00ff00 unmuted "..getCleanPlayerName(player).."!")

	end

end
addCommandHandler("mute", Commands.mute)


local quickMuteTimer = {}
function Commands.qm(p, c, player, duration)

	local arenaElement = getElementParent(p)

	if player then

		player = findArenaPlayer(arenaElement, player)

	else

		player = p

	end

	if not player then return end

	if isPlayerMuted(player) then

		outputChatBox(getCleanPlayerName(player).." is already muted!", p, 255, 255, 0, true)
		return

	end

	if duration then

		duration = tonumber(duration)

		if not duration or (duration ~= duration or duration == math.huge or duration == -math.huge) then

			outputChatBox("You cannot do this!", p, 255, 0, 128)
			return

		end

		if duration < 30 or duration > 300 then

			outputChatBox("ERROR: Durations from 30 to 300 seconds only!", p, 255, 0, 128)
			return

		end

	else

		duration = 30

	end

	setPlayerMuted(player, true)
	quickMuteTimer[player] = setTimer(Commands.doUnmute, duration*1000, 1, player)

	Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).."#ffff00 muted "..getCleanPlayerName(player).." for "..duration.." seconds!")

end
addCommandHandler("qm", Commands.qm)


function Commands.doUnmute(player)

	if not isElement(player) then return end

	if not isPlayerMuted(player) then return end

	setPlayerMuted(player, false)

	quickMuteTimer[player] = nil

end


function Commands.gmute(p, c, player)

	local arenaElement = getElementParent(p)

	if player then

		player = findPlayerAll(player)

	else

		player = p

	end

	if not player then return end

	if not getElementData(player, "gmute") then

		setElementData(player, "gmute", true)
		Chat.outputGlobalChat("#ff0000"..getCleanPlayerName(p).." muted "..getCleanPlayerName(player).."!")

	else

		setElementData(player, "gmute", false)
		Chat.outputGlobalChat("#00ff00"..getCleanPlayerName(p).." unmuted "..getCleanPlayerName(player).."!")

	end

end
addCommandHandler("gmute", Commands.gmute)


function Commands.lmute(p, c, player)

	local arenaElement = getElementParent(p)

	if player then

		player = findPlayerAll(player)

	else

		player = p

	end

	if not player then return end

	if not getElementData(player, "Language") then return end

	if not getElementData(player, "lmute") then

		setElementData(player, "lmute", true)
		Chat.outputLanguageChat(getElementData(player, "Language"), "#ff0000"..getCleanPlayerName(p).." muted "..getCleanPlayerName(player).."!")

	else

		setElementData(player, "lmute", false)
		Chat.outputLanguageChat(getElementData(player, "Language"), "#00ff00"..getCleanPlayerName(p).." unmuted "..getCleanPlayerName(player).."!")

	end

end
addCommandHandler("lmute", Commands.lmute)


local currentCountDown = false
function Commands.count(p, c, n)

	if currentCountDown then return end

	currentCountDown = true

	local arenaElement = getElementParent(p)

	n = tonumber(n)
	
	if not n or n > 5 then

		n = 5

	end

	n = math.ceil(n)
	
	Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p)..': Get ready!')

	setTimer(Commands.doCountDown, 1000, 1, arenaElement, n)

end
addCommandHandler("count", Commands.count)
addCommandHandler("c", Commands.count)


function Commands.doCountDown(arenaElement, n)

	if n > 0 then

		Chat.outputArenaChat(arenaElement, "#ffff00"..'Countdown: '..n)
		setTimer(Commands.doCountDown, 1000, 1, arenaElement, n - 1)

	else

		Chat.outputArenaChat(arenaElement, "#ffff00"..'Countdown: GO!')
		currentCountDown = false

	end

end


function Commands.silence(p, c)

	local arenaElement = getElementParent(p)

	if getElementData(arenaElement, "silence") then

		Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).."#ffff00 disabled Silence Mode!")

	else

		Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).."#ffff00 enabled Silence Mode!")

	end

	setElementData(arenaElement, "silence", not getElementData(arenaElement, "silence"))

end
addCommandHandler("silence", Commands.silence)


function Commands.boomall(p, c)

	local arenaElement = getElementParent(p)

	local wasAnyoneBlown = false

	for i, player in pairs(getPlayersInArena(arenaElement)) do

		if getPedOccupiedVehicle(player) then

			blowVehicle(getPedOccupiedVehicle(player))
			wasAnyoneBlown = true

		end

	end

	if wasAnyoneBlown then

		Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).."#ffff00 boomed everyone!")

	end

end
addCommandHandler("boomall", Commands.boomall)


function Commands.fixall(p, c)

	local arenaElement = getElementParent(p)

	local wasAnyoneFixed = false

	for i, player in pairs(getPlayersInArena(arenaElement)) do

		if getPedOccupiedVehicle(player) then

			fixVehicle(getPedOccupiedVehicle(player))
			setElementHealth(getPedOccupiedVehicle(player), 1000)
			wasAnyoneFixed = true

		end

	end

	if wasAnyoneFixed then

		Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).."#ffff00 fixed everyone!")

	end

end
addCommandHandler("fixall", Commands.fixall)


function Commands.boom(p, c, player)

	local arenaElement = getElementParent(p)

	if player then

		player = findArenaPlayer(arenaElement, player)

	else

		player = p

	end

	if not player then return end

	if not getPedOccupiedVehicle(player) then return end

	if isElementFrozen(getPedOccupiedVehicle(player)) then return end

	blowVehicle(getPedOccupiedVehicle(player), false)

	setElementHealth(player, 0)

	Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).."#ffff00 destroyed "..getCleanPlayerName(player).."!")

end
addCommandHandler("boom", Commands.boom)


function Commands.kick(p, c, player)

	local arenaElement = getElementParent(p)

	if player then

		player = findArenaPlayer(arenaElement, player)

	else

		player = p

	end

	if not player then return end

	Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).."#ffff00 kicked "..getCleanPlayerName(player).."!")

	kickPlayer(player)

end
addCommandHandler("kick", Commands.kick)


function Commands.skick(p, c, player)

	local arenaElement = getElementParent(p)

	if player then

		player = findPlayerAll(player)

	else

		player = p

	end

	if not player then return end

	Chat.outputGlobalChat("#ffff00"..getCleanPlayerName(p).."#ffff00 kicked "..getCleanPlayerName(player).."!")

	kickPlayer(player)

end
addCommandHandler("skick", Commands.skick)


function Commands.arenaBan(p, c, player)

	local arenaElement = getElementParent(p)

	if player then

		player = findArenaPlayer(arenaElement, player)

	else

		player = p

	end

	if not player then return end

	ACL.addArenaBan(player, getElementID(arenaElement))

	Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).."#ffff00 banned "..getCleanPlayerName(player).." from this Arena!")

	triggerEvent("onLobbyKick", arenaElement, player, "Kicked", "You have been banned!")

end
addCommandHandler("ban", Commands.arenaBan)


function Commands.sban(p, c, player)

	local arenaElement = getElementParent(p)

	if player then

		player = findPlayerAll(player)

	else

		player = p

	end

	if not player then return end

	Chat.outputGlobalChat("#ffff00"..getCleanPlayerName(player).."#ffff00 was banned from the server by "..getCleanPlayerName(p).."!")

	banPlayer(player, false, false, true, p)

end
addCommandHandler("sban", Commands.sban)


function Commands.unban(p, c, player)

	local arenaElement = getElementParent(p)

	if not player then return end

	local arena = getElementID(arenaElement)

	if ACL.removeArenaBan(player, arena) then

		Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).."#ffff00 unbanned "..player.."!")

	else

		outputChatBox("Player "..player.." isn't banned!", p, 255, 0, 128, true)

	end

end
addCommandHandler("unban", Commands.unban)


function Commands.unbanserial(p, c, player)

	local arenaElement = getElementParent(p)

	if not player then return end

	for _,ban in ipairs(getBans())do

		if getBanNick(ban) == player then

			removeBan(ban)
			Chat.outputGlobalChat("#ffff00"..getCleanPlayerName(p).."#ffff00 unbanned serial of "..player.."!")
			return

		end

	end

	outputChatBox("Player "..player.." isn't banned!", p, 255, 0, 128, true)

end
addCommandHandler("unsban", Commands.unbanserial)


function Commands.nitro(p, c, player)

	local arenaElement = getElementParent(p)

	if player then

		player = findArenaPlayer(arenaElement, player)

	else

		player = p

	end

	if not player then return end

	if not getPedOccupiedVehicle(player) then return end

	addVehicleUpgrade(getPedOccupiedVehicle(player), 1010 )

	Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).."#ffff00 added Nitro to "..getCleanPlayerName(player).."!")

end
addCommandHandler("nos", Commands.nitro)


function Commands.nitroAll(p, c)

	local arenaElement = getElementParent(p)

	for i, player in pairs(getPlayersInArena(arenaElement)) do

		if getPedOccupiedVehicle(player) then

			addVehicleUpgrade(getPedOccupiedVehicle(player), 1010)

		end

	end

	Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).."#ffff00 added Nitro to everyone!")

end
addCommandHandler("nosall", Commands.nitroAll)


function Commands.smash(p, c, player)

	local arenaElement = getElementParent(p)

	if player then

		player = findArenaPlayer(arenaElement, player)

	else

		player = p

	end

	if not player then return end

	if player == p then

		outputChatBox("You cannot do this to yourself!", p, 255, 0, 128)
		return

	end

	if not getPedOccupiedVehicle(player) then return end

	local speedX, speedY, speedZ = getElementVelocity(getPedOccupiedVehicle(player))

	setElementVelocity(getPedOccupiedVehicle(player), speedX, speedY, speedZ+0.6)

	setTimer(setElementVelocity, 1000, 1, getPedOccupiedVehicle(player), speedX, speedY, speedZ-3)

	Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).."#ffff00 smashes "..getCleanPlayerName(player).."!")

end
addCommandHandler("smash", Commands.smash)


function Commands.push(p, c, player)

	local arenaElement = getElementParent(p)

	if player then

		player = findArenaPlayer(arenaElement, player)

	else

		player = p

	end

	if not player then return end

	if player == p then

		outputChatBox("You cannot do this to yourself!", p, 255, 0, 128)
		return

	end

	if not getPedOccupiedVehicle(player) then return end

    local speedX, speedY, speedZ = getElementVelocity(getPedOccupiedVehicle(player))

    setElementVelocity(getPedOccupiedVehicle(player), speedX, speedY, speedZ+0.2)

    Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).."#ffff00 pushes "..getCleanPlayerName(player).."!")

end
addCommandHandler("push", Commands.push)


function Commands.speed(p, c, player)

	local arenaElement = getElementParent(p)

	if player then

		player = findArenaPlayer(arenaElement, player)

	else

		player = p

	end

	if not player then return end

	if player == p then

		outputChatBox("You cannot do this to yourself!", p, 255, 0, 128)
		return

	end

	if not getPedOccupiedVehicle(player) then return end

    local speedX, speedY, speedZ = getElementVelocity(getPedOccupiedVehicle(player))

	setElementSpeed(getPedOccupiedVehicle(player), "kph", getElementSpeed(getPedOccupiedVehicle(player), "kph")+40)

    Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).."#ffff00 speeds "..getCleanPlayerName(player).."!")

end
addCommandHandler("speed", Commands.speed)


function Commands.slow(p, c, player)

	local arenaElement = getElementParent(p)

	if player then

		player = findArenaPlayer(arenaElement, player)

	else

		player = p

	end

	if not player then return end

	if player == p then

		outputChatBox("You cannot do this to yourself!", p, 255, 0, 128)
		return

	end

	if not getPedOccupiedVehicle(player) then return end

    local speedX, speedY, speedZ = getElementVelocity(getPedOccupiedVehicle(player))

	setElementSpeed(getPedOccupiedVehicle(player), "kph", getElementSpeed(getPedOccupiedVehicle(player), "kph")/2)

    Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).."#ffff00 slows "..getCleanPlayerName(player).."!")

end
addCommandHandler("slow", Commands.slow)


function Commands.fix(p, c, player)

	local arenaElement = getElementParent(p)

	if player then

		player = findArenaPlayer(arenaElement, player)

	else

		player = p

	end

	if not player then return end

	if not getPedOccupiedVehicle(player) then return end

	fixVehicle(getPedOccupiedVehicle(player))

	setElementHealth(getPedOccupiedVehicle(player), 1000)

	Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).."#ffff00 fixed "..getCleanPlayerName(player).."!")

end
addCommandHandler("fix", Commands.fix)


function Commands.toLobby(p, c, player)

	local arenaElement = getElementParent(p)

	if player then

		player = findArenaPlayer(arenaElement, player)

	else

		player = p

	end

	if not player then return end

	triggerEvent("onLobbyKick", arenaElement, player, "Kicked", "You have been kicked!")

	Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(player).." was kicked to Lobby by "..getCleanPlayerName(p).."!")

end
addCommandHandler("lobby", Commands.toLobby)


function Commands.toLobbyAll(p, c)

	local arenaElement = getElementParent(p)

	for i, player in ipairs(getPlayersInArena(arenaElement)) do

		if player ~= p then

			triggerEvent("onLobbyKick", arenaElement, player, "Kicked", "Kicked!")

			Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(player).." was kicked to Lobby by "..getCleanPlayerName(p).."!")

		end

	end

end
addCommandHandler("lobbyall", Commands.toLobbyAll)


function Commands.restartMap(player, c, t)

	local arenaElement = getElementParent(player)

	triggerEvent("onStartNewMap", arenaElement, getElementData(arenaElement, "map"), true)	
	
	Chat.outputArenaChat(arenaElement, "#ffff00"..'Map restarted by '..getCleanPlayerName(player))

end
addCommandHandler("redo", Commands.restartMap)


function Commands.randMap(player, c, t)

	local arenaElement = getElementParent(player)

	local typ = getElementData(arenaElement, "type")
	
	triggerEvent("onStartNewMap", arenaElement, MapManager.getRandomArenaMap(typ), true)

	Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(player).." started a random map!")

end
addCommandHandler("random", Commands.randMap)


function Commands.again(player, c, t)

	local arenaElement = getElementParent(player)

	if not getElementData(arenaElement, "map") then return end

	if #getElementData(arenaElement, "nextmap") > 2 then

		outputChatBox("Error: Next map queue is full!", player, 255, 0, 128)
		return

	end

	local nextmap = getElementData(arenaElement, "nextmap")

	table.insert(nextmap, 1, getElementData(arenaElement, "map"))

	setElementData(arenaElement, "nextmap", nextmap)

	Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(player).." set this map to be played again!")

end
addCommandHandler("again", Commands.again)


function Commands.setNextMap(player, command, ...)

	local arenaElement = getElementParent(player)

	local type = getElementData(arenaElement, "type")

	if #getElementData(arenaElement, "nextmap") > 2 then

		outputChatBox("Error: Next map queue is full!", player, 255, 0, 128)
		return

	end

	local query = #{...}>0 and table.concat({...},' ') or nil

	if not query then return end

	local maps = MapManager.findMap(query, type)

	if #maps == 0 then

		outputChatBox("Error: No maps were found!", player, 255, 0, 128)
		return

	elseif #maps > 1 then

		outputChatBox("Error: "..#maps.." maps were found! Check Console for a List.", player, 255, 0, 128)

		for i, map in pairs(maps) do

			outputConsole(map.name, player)

		end

		return

	end

	local nextmap = getElementData(arenaElement, "nextmap")

	table.insert(nextmap, maps[1])

	setElementData(arenaElement, "nextmap", nextmap)

	Chat.outputArenaChat(arenaElement, "#00f000"..'Next map set to ' ..  maps[1].name  .. ' by ' .. getCleanPlayerName( player ))

end
addCommandHandler('nextmap', Commands.setNextMap)
addCommandHandler('nm', Commands.setNextMap)


function Commands.cancel(player)

	local arenaElement = getElementParent(player)

	if not #getElementData(arenaElement, "nextmap") == 0 then return end

	local nextmap = getElementData(arenaElement, "nextmap")

	table.remove(nextmap, 1)

	setElementData(arenaElement, "nextmap", nextmap)

	Chat.outputArenaChat(arenaElement, "#00f000"..getCleanPlayerName(player).." cancels the next map!")

end
addCommandHandler('cancel', Commands.cancel)


function Commands.cancelall(player)

	local arenaElement = getElementParent(player)

	if not #getElementData(arenaElement, "nextmap") == 0 then return end

	setElementData(arenaElement, "nextmap", {})

	Chat.outputArenaChat(arenaElement, "#00f000"..getCleanPlayerName(player).." removed all maps from queue.")

end
addCommandHandler('cancelall', Commands.cancelall)


function Commands.force(player)

	local arenaElement = getElementParent(player)

	if #getElementData(arenaElement, "nextmap") == 0 then return end

	triggerEvent("onStartNewMap", arenaElement, getElementData(arenaElement, "nextmap")[1], true)

	local nextmap = getElementData(arenaElement, "nextmap")

	table.remove(nextmap, 1)

	setElementData(arenaElement, "nextmap", nextmap)

	Chat.outputArenaChat(arenaElement, "#00f000"..getCleanPlayerName(player).." forced next map.")

end
addCommandHandler('force', Commands.force)


function Commands.run(player)

	local arenaElement = getElementParent(player)

	if getElementData(arenaElement, "state") ~= "Ready" then return end

	triggerEvent("onCountdownStart", arenaElement)

end
addCommandHandler('run', Commands.run)


function Commands.go(player, command, ...)

	local arenaElement = getElementParent(player)

	local type = getElementData(arenaElement, "type")

	local query = #{...}>0 and table.concat({...},' ') or nil

	if not query then return end

	local maps = MapManager.findMap(query, type)

	if #maps == 0 then

		outputChatBox("Error: No maps were found!", player, 255, 0, 128)
		return

	elseif #maps > 1 then

		outputChatBox("Error: "..#maps.." maps were found! Check Console for a list.", player, 255, 0, 128)

		for i, map in pairs(maps) do

			outputConsole(map.name, player)

		end

		return

	end

	triggerEvent("onStartNewMap", arenaElement, maps[1], true)

	Chat.outputArenaChat(arenaElement, "#ffff00"..'New Map started by '..getCleanPlayerName(player))

end
addCommandHandler('goto', Commands.go)


function Commands.checkmap(player, command, ...)

	local arenaElement = getElementParent(player)

	local type = getElementData(arenaElement, "type")

	local query = #{...}>0 and table.concat({...},' ') or nil

	if not query then return end

	local maps = MapManager.findMap(query, type)

	if not maps or #maps == 0 then

		outputChatBox("Error: No maps were found!", player, 255, 0, 128)
		return

	elseif #maps > 1 then

		outputChatBox("Error: "..#maps.." maps were found! Check Console for a List.", player, 255, 0, 128)

		for i, map in pairs(maps) do

			outputConsole(map.name, player)

		end

		return

	end

	outputChatBox("Found map: "..maps[1].name, player, 255, 0, 128)

end
addCommandHandler('checkmap', Commands.checkmap)


function Commands.warp(p, c, player)

	local arenaElement = getElementParent(p)

	if player then

		player = findArenaPlayer(arenaElement, player)

	else

		player = p

	end

	if not player then return end

	if not getPedOccupiedVehicle(player) then return end

	local playerVehicle = getPedOccupiedVehicle(player)
	if not playerVehicle then return end
	local theVehicle = getPedOccupiedVehicle(p)
	local x,y,z = getElementPosition(playerVehicle)
	local rx,ry,rz = getVehicleRotation(playerVehicle)
	local vx,vy,vz = getElementVelocity(playerVehicle)
	local rvx,rvy,rvz = getVehicleTurnVelocity(playerVehicle)
	z = z + 4
	setElementPosition(theVehicle, x,y,z, true)
	setVehicleRotation(theVehicle, rx,ry,rz)
	setVehicleTurnVelocity(theVehicle, rvx,rvy,rvz)
	setElementVelocity(theVehicle, vx,vy,vz)

	Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." warps to "..getCleanPlayerName(player).."!")

end
addCommandHandler("warp", Commands.warp)


function Commands.here(p, c, player)

	local arenaElement = getElementParent(p)

	if player then

		player = findArenaPlayer(arenaElement, player)

	else

		player = p

	end

	if not player then return end

	if not getPedOccupiedVehicle(player) then return end

	if not getPedOccupiedVehicle(p) then return end

	local x,y,z = getElementPosition(getPedOccupiedVehicle(p))
	local rx,ry,rz = getVehicleRotation(getPedOccupiedVehicle(p))
	local vx,vy,vz = getElementVelocity(getPedOccupiedVehicle(p))
	local rvx,rvy,rvz = getVehicleTurnVelocity(getPedOccupiedVehicle(p))
	z = z + 4
	setElementPosition(getPedOccupiedVehicle(player), x, y, z)
	setVehicleRotation(getPedOccupiedVehicle(player), rx, ry, rz)
	setVehicleTurnVelocity(getPedOccupiedVehicle(player), rvx, rvy, rvz)
	setElementVelocity(getPedOccupiedVehicle(player), vx, vy, vz)

	Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p)..' warps '..getCleanPlayerName(player)..'!')

end
addCommandHandler('here', Commands.here)


function Commands.hideNicknames(p, c)

	local arenaElement = getElementParent(p)

	local state = getElementData(arenaElement, "hideNicknames")

	if state then

		setElementData(arenaElement, "hideNicknames", false)
		Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." enabled nicknames!")

	else

		setElementData(arenaElement, "hideNicknames", true)
		Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." disabled nicknames!")

	end

end
addCommandHandler("hidenicks", Commands.hideNicknames)


function Commands.spectatorChat(p, c)

	local arenaElement = getElementParent(p)

	local state = getElementData(arenaElement, "showSpectatorChat")

	if state then

		setElementData(arenaElement, "showSpectatorChat", false)

		Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." disabled spectator chat!")

	else

		setElementData(arenaElement, "showSpectatorChat", true)

		Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." enabled spectator chat!")

	end

end
addCommandHandler("showspectatorchat", Commands.spectatorChat)


function Commands.setRewind(p, c)

	local arenaElement = getElementParent(p)

	local state = getElementData(arenaElement, "rewind")

	if state then

		setElementData(arenaElement, "rewind", false)

		Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." disabled rewind!")

	else

		setElementData(arenaElement, "rewind", true)

		Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." enabled rewind!")

	end

end
addCommandHandler("setarenarewind", Commands.setRewind)


function Commands.setArenaSpectators(p, c)

	local arenaElement = getElementParent(p)

	local state = getElementData(arenaElement, "spectators")

	if state then

		setElementData(arenaElement, "spectators", false)

		Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." disabled spectators!")

	else

		setElementData(arenaElement, "spectators", true)

		Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." enabled spectators!")

	end

end
addCommandHandler("setarenaspectators", Commands.setArenaSpectators)


function Commands.deletemap(p, c)

	local arenaElement = getElementParent(p)

	local map = getElementData(arenaElement, "map")

	if not map then return end

	local resource = getResourceFromName(map.resource)

	if not resource then return end

	deleteResource(resource)

	MapManager.fetchMaps(p)

	Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." deleted this map from the Arena!")

end
addCommandHandler("deletemap", Commands.deletemap)


function Commands.setArenaVehicleColor(p, c, t)

	local arenaElement = getElementParent(p)

	if not t then
	
		outputChatBox("Error: You have to provide a color!", p, 255, 0, 128)
		return

	end
	
	if not getColorFromString(t) then
	
		outputChatBox("Error: Invalid color! Format is: '\#ffffff'", p, 255, 0, 128)
		return

	end
	
	setElementData(arenaElement, "forced_vehicle_color", t)

	Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." changed arena vehicle color!")

	local r, g, b = getColorFromString(t)

	for i, player in ipairs(getPlayersInArena(arenaElement)) do

		if getPedOccupiedVehicle(player) then

			setVehicleColor(getPedOccupiedVehicle(player), r, g, b, r, g, b)

		end

	end

end
addCommandHandler("setarenavehiclecolor", Commands.setArenaVehicleColor)


function Commands.resetArenaVehicleColor(p, c)

	local arenaElement = getElementParent(p)

	setElementData(arenaElement, "forced_vehicle_color", nil)

	Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." reset arena vehicle color!")

end
addCommandHandler("resetarenavehiclecolor", Commands.resetArenaVehicleColor)


function Commands.removeRepairPickups(p, c)

	local arenaElement = getElementParent(p)

	triggerClientEvent(arenaElement, "onClientRemoveRepairPickups", arenaElement)

	Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." removed all repair pickups!")

end
addCommandHandler("removerepairs", Commands.removeRepairPickups)


function Commands.removeObjects(p, c)

	local arenaElement = getElementParent(p)

	triggerClientEvent(arenaElement, "onClientRemoveObjects", arenaElement)

	Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." made the map invisible!")

end
addCommandHandler("removeobjects", Commands.removeObjects)

Commands.createdTanks = {}
function Commands.tank(p, c, t)

	local vehicle = getPedOccupiedVehicle(p)

	if not vehicle then return end
	
	if Commands.createdTanks[p] then
	
		if isTimer(Commands.createdTanks[p].timer) then killTimer(Commands.createdTanks[p].timer) end
		if isElement(Commands.createdTanks[p].tank) then destroyElement(Commands.createdTanks[p].tank) end
		
	end
	
	Commands.createdTanks[p] = {}

	if not t or not tonumber(t) then
	
		t = 432
		
	end

	local x, y, z = getElementPosition(p)
	
	local vx, vy, vz = getElementVelocity(vehicle)
	
	local rx, ry, rz = getVehicleRotation(vehicle)
	
	Commands.createdTanks[p].tank = createVehicle(t, x, y, z+2, 0, 0, 0)
	
	if not Commands.createdTanks[p].tank then return end
	
	setElementDimension(Commands.createdTanks[p].tank, getElementDimension(p))
	
	setVehicleDamageProof(Commands.createdTanks[p].tank, true)
	
	setVehicleRotation(Commands.createdTanks[p].tank, rx,ry,rz)
	
	setElementVelocity(Commands.createdTanks[p].tank, 10*vx,10*vy,10*vz)

	Commands.createdTanks[p].timer = setTimer(function() if isElement(Commands.createdTanks[p].tank) then destroyElement(Commands.createdTanks[p].tank) end end, 7000, 1)
	
end
addCommandHandler("tank", Commands.tank)


function Chat.toptimeban(p, c, player)
	
	local arenaElement = getElementParent(p)

	if player then

		player = findArenaPlayer(arenaElement, player)

	else

		player = p

	end

	if not player then return end
	
	if getElementData(player, "setting:ban_toptimes") == 1 then
	
		exports["CCS_stats"]:export_changePlayerSettings(player, {ban_toptimes = 0})
		
		if player == p then
		
			Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).."#ffff00 unbanned himself from getting toptimes! °͜ʖ°?")

		else	
			
			Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).."#ffff00 unbanned "..getCleanPlayerName(player).." from getting toptimes!")

		end
		
	else

		exports["CCS_stats"]:export_changePlayerSettings(player, {ban_toptimes = 1})
		
		if player == p then
		
			Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).."#ffff00 banned himself from getting toptimes! °͜ʖ°?")

		else	
			
			Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).."#ffff00 banned "..getCleanPlayerName(player).." from getting toptimes!")

		end
	end	
		
end
addCommandHandler("bantt", Chat.toptimeban)