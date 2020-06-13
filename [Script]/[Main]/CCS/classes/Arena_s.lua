Arena = {}
Arena.__index = Arena
setmetatable(Arena, {__call = function (cls, ...) return cls.new(...) end,})
Arena.timers = {}
Arena.dimensionList = {}

function Arena.new(name, alias, gamemode, category, type, maxplayers, password, mode, color, duration, inLobby, creator, inScoreboard, temporary)
	
	if Arena.isNameTaken(name) then return false end
	
    local self = setmetatable({}, Arena)

	--Find available Dimension
	self.dimension = Arena.generateNewDimension()
	Arena.dimensionList[self.dimension] = true
	self.name = name
	self.element = createElement("Arena", self.name)
	setElementData(self.element, "name", self.name)
	setElementData(self.element, "alias", alias)
	setElementData(self.element, "gamemode", gamemode)
	setElementData(self.element, "category", category)
	setElementData(self.element, "type", type)
	setElementData(self.element, "players", 0)
	setElementData(self.element, "maxplayers", maxplayers)
	setElementData(self.element, "password", password)
	setElementData(self.element, "mode", mode)
	setElementData(self.element, "color", color)
	setElementData(self.element, "Duration", duration)
	setElementData(self.element, "Detector", false)
	setElementData(self.element, "pingchecker", false)
	setElementData(self.element, "fpschecker", false)	
	setElementData(self.element, "inLobby", inLobby)
	setElementData(self.element, "creator", creator)
	setElementData(self.element, "inScoreboard", inScoreboard)
	setElementData(self.element, "temporary", temporary)
	setElementData(self.element, "voteRedo", false)
	setElementData(self.element, "toptimes", false)
	setElementData(self.element, "topkills", false)
	setElementData(self.element, "stats", false)
	setElementData(self.element, "mapstats", false)
	setElementData(self.element, "gambling", false)
	setElementData(self.element, "userpanel", false)
	setElementData(self.element, "spectators", false)
	setElementData(self.element, "allow_mods", false)
	setElementData(self.element, "timer:waitingForPlayers", 30000)
	setElementData(self.element, "showSpectatorChat", true)
	setElementData(self.element, "podium", false)
	setElementData(self.element, "challenges", false)
	setElementData(self.element, "nextmap", {})
	setElementDimension(self.element, self.dimension)
	Arena.timers[self.element] = {}

	triggerEvent("onArenaCreate", self.element, self.name)
	
	triggerClientEvent(root, "onClientArenaCreate", self.element, self.name)

	function self.destroy(arenaName)
		
		triggerClientEvent(root, "onClientArenaDestroy", self.element, self.name)
		
		for i, team in pairs(getTeamsInArena(self.element)) do
		
			if isElement(team) then destroyElement(team) end
			
		end
		
		ACL.unloadArenaACL(arenaName)
		Arena.dimensionList[self.dimension] = false
		Arena.timers[self.element] = {}
		destroyElement(self.element)
	
	end
	addEvent("onArenaDestroy")
	addEventHandler("onArenaDestroy", self.element, self.destroy)
	
	return self
	
end


function Arena:setPodiumEnabled(state)

	setElementData(self.element, "podium", state)

end


function Arena:setChallengesEnabled(state)

	setElementData(self.element, "challenges", state)

end


function Arena:setUserpanelEnabled(state)

	setElementData(self.element, "userpanel", state)

end


function Arena:setSpectatorsEnabled(state)

	setElementData(self.element, "spectators", state)

end


function Arena:setGamblingEnabled(state)

	setElementData(self.element, "gambling", state)

end


function Arena:setModsEnabled(state)

	setElementData(self.element, "allow_mods", state)

end


function Arena:setAFKCheckEnabled(state)

	setElementData(self.element, "Detector", state)

end


function Arena:setPingCheckEnabled(state)

	setElementData(self.element, "pingchecker", state)

end


function Arena:setFPSCheckEnabled(state)

	setElementData(self.element, "fpschecker", state)

end


function Arena:setVoteredoEnabled(state)

	setElementData(self.element, "voteRedo", state)

end


function Arena:setToptimesEnabled(state)

	setElementData(self.element, "toptimes", state)

end
	
	
function Arena:setTopkillsEnabled(state)

	setElementData(self.element, "topkills", state)

end	


function Arena:setStatsEnabled(state)

	setElementData(self.element, "stats", state)

end	


function Arena:setMapstatsEnabled(state)

	setElementData(self.element, "mapstats", state)

end	


function Arena:setWaitingTime(time)

	setElementData(self.element, "timer:waitingForPlayers", time)

end	


function Arena.generateNewDimension()

	for i, state in ipairs(Arena.dimensionList) do 
	
		if not state then
		
			return i 
			
		end
	
	end

	return #Arena.dimensionList + 1

end


function Arena.isNameTaken(name)

	for i, arena in ipairs(getElementsByType("Arena")) do
		
		if getElementData(arena, "name") == name then
		
			return true
			
		end
	
	end	

	return false

end
	
	
function Arena.killAllPlayers(arenaElement)

	for i, p in ipairs(getPlayersInArena(arenaElement)) do
	
		if getPedOccupiedVehicle(p) then
		
			destroyElement(getPedOccupiedVehicle(p))
			
		end
		
		if not isPedDead(p) then
		
			removePedFromVehicle(p)
			killPed(p)
			
		end
		
	end

end

	
function Arena.setArenaPassword(p, c, password)

	local arenaElement = getElementParent(p)
	
	if not password then 
	
		setElementData(arenaElement, "password", nil)
		Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." reset the arena password!")
		return 
		
	end
	
	if #password >= 1 then
	
		setElementData(arenaElement, "password", password)
		Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." changed the arena password!")

	end

end
addCommandHandler("setarenapassword", Arena.setArenaPassword)


function Arena.getArenaPassword(p, c, ...)

	local arena = table.concat({...}," ")
	
	if #arena:gsub(" ", "") == 0 then return end
	
	local arenaElement = getElementByID(arena)
	
	if not arenaElement then return end
	
	local password = getElementData(arenaElement, "password")

	if not password or #password == 0 then
	
		password = "No password!"
		
	end
	
	outputChatBox("Current Arena password is: "..password, p, 255, 0, 128)

end
addCommandHandler("getarenapassword", Arena.getArenaPassword)


function Arena.setArenaMode(p, c, mode)

	local arenaElement = getElementParent(p)
	
	if not mode then return end
	
	if mode == "Random" or mode == "Voting" or mode == "Manual" then
	
		setElementData(arenaElement, "mode", mode)
		Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." changed the arena mode to "..mode.."!")
		
	end

end
addCommandHandler("setarenamode", Arena.setArenaMode)


function Arena.setArenaDetector(p, c)

	local arenaElement = getElementParent(p)

	local state = getElementData(arenaElement, "Detector")
	
	setElementData(arenaElement, "Detector", not state)
	
	if state then
	
		Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." disabled AFK Detector!")

	else

		Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." enabled AFK Detector!")

	end
	
end
addCommandHandler("setarenadetector", Arena.setArenaDetector)


function Arena.setArenaFPS(p, c)

	local arenaElement = getElementParent(p)

	local state = getElementData(arenaElement, "fpschecker")
	
	setElementData(arenaElement, "fpschecker", not state)
	
	if state then
	
		Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." disabled FPS Check!")

	else

		Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." enabled FPS Check!")

	end
	
end
addCommandHandler("setarenafps", Arena.setArenaFPS)


function Arena.setArenaPing(p, c)

	local arenaElement = getElementParent(p)

	local state = getElementData(arenaElement, "pingchecker")
	
	setElementData(arenaElement, "pingchecker", not state)
	
	if state then
	
		Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." disabled Ping Check!")

	else

		Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." enabled Ping Check!")

	end
	
end
addCommandHandler("setarenaping", Arena.setArenaPing)


function Arena.setArenaCPTP(p, c)

	local arenaElement = getElementParent(p)

	local state = getElementData(arenaElement, "cptp")
	
	setElementData(arenaElement, "cptp", not state)
	
	if state then
	
		Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." disabled CP/TP!")

	else

		Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." enabled CP/TP!")

	end
	
end
addCommandHandler("setarenacptp", Arena.setArenaCPTP)


function Arena.setArenaWFF(p, c)

	local arenaElement = getElementParent(p)

	local state = getElementData(arenaElement, "wff")
	
	setElementData(arenaElement, "wff", not state)
	
	if state then
	
		Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." disabled WFF Death Markers!")

	else

		Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." enabled WFF Death Markers!")

	end
	
end
addCommandHandler("setarenawff", Arena.setArenaWFF)