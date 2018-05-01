Panel = {}

function Panel.requestAccess()

	local arenaElement = getElementParent(source)

	local access = false
	
	if exports["CCS"]:export_acl_check(source, "adminpanel") then 
	
		access = true
	
	end
	
	triggerClientEvent(source, "onClientPanelReceiveAccess", arenaElement, access)

end
addEvent("onPanelRequestAccess", true)
addEventHandler("onPanelRequestAccess", root, Panel.requestAccess)
	

function Panel.requestPlayers()

	local arenaElement = getElementParent(source)

	local playerList = {}

	for i, player in pairs(exports["CCS"]:export_getPlayersInArena(arenaElement)) do
		
		table.insert(playerList, {player = player, name = getPlayerName(player):gsub('#%x%x%x%x%x%x', '' ), serial = getPlayerSerial(player), ip = getPlayerIP(player), team = getPlayerTeam(player), account = getElementData(player, "account") or "Guest", country = getElementData(player, "Country") or "XX"})
	
	end
	
	triggerClientEvent(source, "onClientPanelReceivePlayers", arenaElement, playerList)
	
end
addEvent("onPanelRequestPlayers", true)
addEventHandler("onPanelRequestPlayers", root, Panel.requestPlayers)


function Panel.requestMaps()

	local arenaElement = getElementParent(source)

	local type = getElementData(arenaElement, "type")
	
	if not type then return end
	
	triggerClientEvent(source, "onClientPanelReceiveMaps", arenaElement, exports["CCS"]:export_getMaps(type))
	
end
addEvent("onPanelRequestMaps", true)
addEventHandler("onPanelRequestMaps", root, Panel.requestMaps)


function Panel.requestBans()

	local arenaElement = getElementParent(source)

	local arena = getElementID(arenaElement)
	
	triggerClientEvent(source, "onClientPanelReceiveBans", arenaElement, exports["CCS"]:export_getArenaBans(arena))
	
end
addEvent("onPanelRequestBans", true)
addEventHandler("onPanelRequestBans", root, Panel.requestBans)


function Panel.requestACL()

	local arenaElement = getElementParent(source)

	local arena = getElementID(arenaElement)
	
	triggerClientEvent(source, "onClientPanelReceiveACL", arenaElement, exports["CCS"]:export_getArenaAdminList(arena))
	
end
addEvent("onPanelRequestACL", true)
addEventHandler("onPanelRequestACL", root, Panel.requestACL)


function Panel.requestTeams()

	local arenaElement = getElementParent(source)

	triggerClientEvent(source, "onClientPanelReceiveTeams", arenaElement, exports["CCS"]:export_getTeamsInArena(arenaElement))
	
end
addEvent("onPanelRequestTeams", true)
addEventHandler("onPanelRequestTeams", root, Panel.requestTeams)


function Panel.lobby(player)

	if not exports["CCS"]:export_acl_check(source, "lobby") then return end

    executeCommandHandler("lobby", source, player)
	
end
addEvent("onPanelLobby", true)
addEventHandler("onPanelLobby", root, Panel.lobby)


function Panel.kick(player)

	if not exports["CCS"]:export_acl_check(source, "kick") then return end

    executeCommandHandler("kick", source, player)
	
end
addEvent("onPanelKick", true)
addEventHandler("onPanelKick", root, Panel.kick)


function Panel.ban(player)

	if not exports["CCS"]:export_acl_check(source, "ban") then return end

    executeCommandHandler("ban", source, player)
	
end
addEvent("onPanelBan", true)
addEventHandler("onPanelBan", root, Panel.ban)


function Panel.mute(player)

	if not exports["CCS"]:export_acl_check(source, "mute") then return end

    executeCommandHandler("mute", source, player)
	
end
addEvent("onPanelMute", true)
addEventHandler("onPanelMute", root, Panel.mute)


function Panel.fix(player)

	if not exports["CCS"]:export_acl_check(source, "fix") then return end

    executeCommandHandler("fix", source, player)
	
end
addEvent("onPanelFix", true)
addEventHandler("onPanelFix", root, Panel.fix)


function Panel.nos(player)

	if not exports["CCS"]:export_acl_check(source, "nos") then return end

    executeCommandHandler("nos", source, player)
	
end
addEvent("onPanelNos", true)
addEventHandler("onPanelNos", root, Panel.nos)


function Panel.smash(player)

	if not exports["CCS"]:export_acl_check(source, "smash") then return end

    executeCommandHandler("smash", source, player)
	
end
addEvent("onPanelSmash", true)
addEventHandler("onPanelSmash", root, Panel.smash)


function Panel.boom(player)

	if not exports["CCS"]:export_acl_check(source, "boom") then return end

    executeCommandHandler("boom", source, player)
	
end
addEvent("onPanelBoom", true)
addEventHandler("onPanelBoom", root, Panel.boom)


function Panel.nextmap(map)

	if not exports["CCS"]:export_acl_check(source, "nm") then return end

    executeCommandHandler("nm", source, map)
	
end
addEvent("onPanelNextmap", true)
addEventHandler("onPanelNextmap", root, Panel.nextmap)


function Panel.goto(map)

	if not exports["CCS"]:export_acl_check(source, "goto") then return end

    executeCommandHandler("goto", source, map)
	
end
addEvent("onPanelGoto", true)
addEventHandler("onPanelGoto", root, Panel.goto)


function Panel.unban(name)

	if not exports["CCS"]:export_acl_check(source, "unban") then return end

	local arenaElement = getElementParent(source)

	local arena = getElementID(arenaElement)
	
    exports["CCS"]:export_removeArenaBan(name, arena)

	triggerClientEvent(source, "onClientPanelReceiveBans", arenaElement, exports["CCS"]:export_getArenaBans(arena))
	
end
addEvent("onPanelUnban", true)
addEventHandler("onPanelUnban", root, Panel.unban)


function Panel.remove(account)

	if not exports["CCS"]:export_acl_check(source, "setlevel") then return end

	local arenaElement = getElementParent(source)

	local arena = getElementID(arenaElement)
	
    exports["CCS"]:export_aclremovePlayer(account, arena)

	triggerClientEvent(source, "onClientPanelReceiveACL", arenaElement, exports["CCS"]:export_getArenaAdminList(arena))
	
end
addEvent("onPanelRemove", true)
addEventHandler("onPanelRemove", root, Panel.remove)


function Panel.add(account, level)

	if not exports["CCS"]:export_acl_check(source, "setlevel") then return end

	local arenaElement = getElementParent(source)

	local arena = getElementID(arenaElement)
	
    exports["CCS"]:export_acladdPlayer(account, arena, level)

	triggerClientEvent(source, "onClientPanelReceiveACL", arenaElement, exports["CCS"]:export_getArenaAdminList(arena))
	
end
addEvent("onPanelAdd", true)
addEventHandler("onPanelAdd", root, Panel.add)


function Panel.createTeam(name, r, g, b)

	local arenaElement = getElementParent(source)

	local team = createTeam(name, r, g, b)
	
	if not team then return end
	
	setElementParent(team, arenaElement)
	
	triggerClientEvent(source, "onClientPanelReceiveTeams", arenaElement, exports["CCS"]:export_getTeamsInArena(arenaElement))
	
end
addEvent("onCreateTeam", true)
addEventHandler("onCreateTeam", root, Panel.createTeam)


function Panel.destroyTeam(team)

	if not team then return end
	
	local arenaElement = getElementParent(source)

	destroyElement(team)
	
	triggerClientEvent(source, "onClientPanelReceiveTeams", arenaElement, exports["CCS"]:export_getTeamsInArena(arenaElement))
	
end
addEvent("onDestroyTeam", true)
addEventHandler("onDestroyTeam", root, Panel.destroyTeam)


function Panel.setPlayerTeam(player, team)

	local arenaElement = getElementParent(source)

	setPlayerTeam(player, team)

	local playerName = getPlayerName(player):gsub('#%x%x%x%x%x%x', '')

	if team then
	
		exports["CCS"]:export_outputArenaChat(arenaElement, "#ffff00"..playerName.." was moved into "..getTeamName(team).." team!")
	
	else
	
		exports["CCS"]:export_outputArenaChat(arenaElement, "#ffff00"..playerName.." was removed from his team!")
	
	end
	
	triggerEvent("onPlayerChangeTeam", player, team)
	
end
addEvent("onSetPlayerTeam", true)
addEventHandler("onSetPlayerTeam", root, Panel.setPlayerTeam)


function Panel.passwordChange(password)

	if not exports["CCS"]:export_acl_check(source, "setarenapassword") then return end

	if password then
	
		executeCommandHandler("setarenapassword", source, password)
	
	else
	
		executeCommandHandler("setarenapassword", source)
	
	end
	
end
addEvent("onPanelPasswordChange", true)
addEventHandler("onPanelPasswordChange", root, Panel.passwordChange)


function Panel.settingChange(wff, cptp, detector, ping, nicknames, spectator, rewind, specs, fps, mode)

	local arenaElement = getElementParent(source)

	if getElementData(arenaElement, "wff") ~= wff then
	
		if not exports["CCS"]:export_acl_check(source, "setarenawff") then return end

		executeCommandHandler("setarenawff", source)
	
	end
	
	if getElementData(arenaElement, "cptp") ~= cptp then
	
		if not exports["CCS"]:export_acl_check(source, "setarenacptp") then return end

		executeCommandHandler("setarenacptp", source)
	
	end
	
	if getElementData(arenaElement, "Detector") ~= detector then
	
		if not exports["CCS"]:export_acl_check(source, "setarenadetector") then return end

		executeCommandHandler("setarenadetector", source)
	
	end
	
	if getElementData(arenaElement, "pingchecker") ~= ping then
	
		if not exports["CCS"]:export_acl_check(source, "setarenaping") then return end

		executeCommandHandler("setarenaping", source)
	
	end
	
	if getElementData(arenaElement, "hideNicknames") ~= nicknames then
	
		if not exports["CCS"]:export_acl_check(source, "hidenicks") then return end

		executeCommandHandler("hidenicks", source)
	
	end
	
	if getElementData(arenaElement, "showSpectatorChat") ~= spectator then
	
		if not exports["CCS"]:export_acl_check(source, "showspectatorchat") then return end

		executeCommandHandler("showspectatorchat", source)
	
	end
	
	if getElementData(arenaElement, "rewind") ~= rewind then
	
		if not exports["CCS"]:export_acl_check(source, "setarenarewind") then return end

		executeCommandHandler("setarenarewind", source)
	
	end
	
	if getElementData(arenaElement, "spectators") ~= specs then
	
		if not exports["CCS"]:export_acl_check(source, "setarenaspectators") then return end

		executeCommandHandler("setarenaspectators", source)
	
	end
	
	if getElementData(arenaElement, "fpschecker") ~= fps then
	
		if not exports["CCS"]:export_acl_check(source, "setarenafps") then return end

		executeCommandHandler("setarenafps", source)
	
	end
	
	if mode then
	
		if getElementData(arenaElement, "mode") ~= mode then
	
			if not exports["CCS"]:export_acl_check(source, "setarenamode") then return end

			executeCommandHandler("setarenamode", source, mode)
	
		end
	
	end

end
addEvent("onPanelSettingChange", true)
addEventHandler("onPanelSettingChange", root, Panel.settingChange)