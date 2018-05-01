Arena = {}
Arena.timers = {}
Arena.dimensionList = {}

function Arena.new(name, gamemode, category, type, maxplayers, password, mode, color, duration, afk_detector, pingcheck, fpscheck, inLobby, creator, inScoreboard, temporary, voteRedo, toptimes, topkills, stats, mapstats, gambling, userpanel, spectators, mods)
	
	if Arena.isNameTaken(name) then return false end
	
    local self = {}

	--Find available Dimension
	self.dimension = Arena.generateNewDimension()
	Arena.dimensionList[self.dimension] = true
	self.name = name
	self.element = createElement("Arena", self.name)
	setElementData(self.element, "name", self.name)
	setElementData(self.element, "gamemode", gamemode)
	setElementData(self.element, "category", category)
	setElementData(self.element, "type", type)
	setElementData(self.element, "players", 0)
	setElementData(self.element, "maxplayers", maxplayers)
	setElementData(self.element, "password", password)
	setElementData(self.element, "mode", mode)
	setElementData(self.element, "color", color)
	setElementData(self.element, "Duration", duration)
	setElementData(self.element, "Detector", afk_detector)
	setElementData(self.element, "pingchecker", pingcheck)
	setElementData(self.element, "fpschecker", fpscheck)	
	setElementData(self.element, "inLobby", inLobby)
	setElementData(self.element, "creator", creator)
	setElementData(self.element, "inScoreboard", inScoreboard)
	setElementData(self.element, "temporary", temporary)
	setElementData(self.element, "voteRedo", voteRedo)
	setElementData(self.element, "toptimes", toptimes)
	setElementData(self.element, "topkills", topkills)
	setElementData(self.element, "stats", stats)
	setElementData(self.element, "mapstats", mapstats)
	setElementData(self.element, "gambling", gambling)
	setElementData(self.element, "userpanel", userpanel)
	setElementData(self.element, "spectators", spectators)
	setElementData(self.element, "allow_mods", mods)
	setElementData(self.element, "nextmap", {})
	setElementDimension(self.element, self.dimension)
	Arena.timers[self.element] = {}

	triggerEvent("onArenaCreate", self.element, self.name)

	function self.destroy(arenaName)
		
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