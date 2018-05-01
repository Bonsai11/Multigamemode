Autoteam = {}
Autoteam.savedPlayers = {}

function Autoteam.create(team)

	local arenaElement = getElementParent(source)
	
	if team then
	
		Autoteam.savedPlayers[getPlayerSerial(source)] = {team = getPlayerTeam(source), arenaElement = arenaElement}

	else

		Autoteam.savedPlayers[getPlayerSerial(source)] = nil
	
	end
		
end
addEvent("onPlayerChangeTeam")
addEventHandler("onPlayerChangeTeam", root, Autoteam.create)


function Autoteam.join()

	if not Autoteam.savedPlayers[getPlayerSerial(source)] then return end

	local arenaElement = getElementParent(source)
	
	if Autoteam.savedPlayers[getPlayerSerial(source)].arenaElement ~= arenaElement then return end
	
	local team = Autoteam.savedPlayers[getPlayerSerial(source)].team
	
	if isElement(team) then
	
		setPlayerTeam(source, team)

	end
	
end
addEvent("onPlayerJoinArena")
addEventHandler("onPlayerJoinArena", root, Autoteam.join)
