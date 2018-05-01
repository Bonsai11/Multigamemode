Main = {}

function Main.start()

	setTimer(startResource, 1000, 1, getResourceFromName("CCS_wrapper"))

	setGameType("DDC v2.0.0")
	setMapName("Drunk")
	setFPSLimit(60)

	createElement("Arena", "Lobby")
	setElementData(getElementByID("Lobby"), "inScoreboard", true)
	setElementData(getElementByID("Lobby"), "name", "Lobby")
	setElementData(getElementByID("Lobby"), "creator", "Server")
	
	--Arena.new(name, gamemode, type, maxplayers, password, mode, color, duration, afk_detector, pingcheck, fpscheck, inLobby, creator, inScoreboard, temporary, voteRedo, toptimes, topkills, stats, mapstats, gambling, userpanel, spectators, mods)
	local cross = Arena.new("Cross", "Race", "Fun", "Cross", 32, false, "Voting", "#679E37", 900000, true, true, true, true, "Server", true, false, true, false, true, true, true, true, true, true, false)
	
	local lemon = Arena.new("Lemon", "Race", "Race", "Oldschool", 128, false, "Voting", "#92B204", 900000, true, false, false, true, "Server", true, false, true, true, false, true, true, true, true, true, true)			
	setElementData(lemon.element, "challenges", true)	

	local red = Arena.new("Red", "Race", "Race", "Classic", 128, false, "Voting", "#E53935", 900000, true, false, false, true, "Server", true, false, true, true, false, true, true, true, true, true, true)			
	setElementData(red.element, "challenges", true)	
	
	local night = Arena.new("Night", "Race", "Race", "Modern", 128, false, "Random", "#778F9B", 900000, true, false, false, true, "Server", true, false, true, true, false, true, true, true, true, true, true)	
	setElementData(night.element, "challenges", true)	
	
	local shooter = Arena.new("Shooter", "Race", "Fun", "Shooter", 32, false, "Random", "#414141", 900000, true, true, true, true, "Server", true, false, false, false, true, true, true, true, true, true, true)
	
	local pink = Arena.new("Pink", "Race", "Race", "Race", 128, false, "Random", "#EB3F79", 1200000, true, false, false, true, "Server", true, false, true, true, false, true, true, true, true, true, true)	
	setElementData(pink.element, "challenges", true)	
	
	local hunter = Arena.new("Hunter", "Race", "Fun", "Hunter", 128, false, "Random", "#1D87E4", 600000, true, false, false, true, "Server", true, false, false, false, false, true, true, false, true, true, true)	

	local freeroam = Arena.new("Freeroam", "Freeroam", "Fun", "Freeroam", 128, false, "Manual", "#4CAF50", 900000, false, false, false, true, "Server", true, false, false, false, false, true, false, false, false, false, true)
		
	local linez = Arena.new("Linez", "Race", "Fun", "Linez", 32, false, "Random", "#9932CC", 900000, true, true, false, true, "Server", true, false, true, false, true, true, true, true, true, true, true)
		
	local dynamic = Arena.new("Dynamic", "Race", "Fun", "Dynamic", 128, false, "Voting", "#FF7F50", 900000, true, false, false, true, "Server", true, false, true, true, false, true, true, true, true, true, true)
	setElementData(dynamic.element, "challenges", true)	
	
	local maptest = Arena.new("Maptest", "Race", "Misc", "Maptest", 128, "4321", "Voting", "#00BFFF", 900000, false, false, false, true, "Server", true, false, true, false, false, false, false, false, false, true, true)
	
	createElement("Arena", "Training")
	setElementData(getElementByID("Training"), "inScoreboard", true)
	setElementData(getElementByID("Training"), "name", "Training")
	setElementData(getElementByID("Training"), "creator", "Server")
		
	--In case of Resource Restart
	for i, p in ipairs(getElementsByType("player")) do
	
		setElementParent(p, getElementByID("Lobby"))
		setElementData(p, "Arena", "Lobby")
		setElementData(p, "state", "Login")
		setElementData(p, "account", nil)
		setElementData(p, "racestate", nil)
		setPlayerMuted(p, false)
		spawnPlayer(p, 0, 0, 0)
		setElementFrozen(p, true)
		setElementHealth(p, 100)
		
	end

end
addEventHandler("onResourceStart", resourceRoot, Main.start)


function Main.initPlayerData()

	if #getPlayerName(source):gsub('#%x%x%x%x%x%x', '') < 3 then
	
		kickPlayer(source, "Your nickname is too short!")
		return
		
	end

	local tempPlayerName = getPlayerName(source):gsub('#%x%x%x%x%x%x', '') 
	
	if tempPlayerName:gsub('#%x%x%x%x%x%x', '') ~= tempPlayerName then
	
		kickPlayer(source, "Something is wrong with your nickname! Colorcodes?")
		return
	
	end
	
	setElementParent(source, getElementByID("Lobby"))
	setElementData(source, "Arena", "Lobby")
	setElementData(source, "state", "Login")
	setElementData(source, "account", nil)
	setElementData(source, "racestate", nil)
	spawnPlayer(source, 0, 0, 0)
	setElementFrozen(source, true)
	setElementHealth(source, 100)
	
end
addEventHandler("onPlayerJoin", root, Main.initPlayerData)


function Main.blockNicknameChange()

    cancelEvent()

	outputChatBox("Your nickname will not change until you reconnect.", source, 255, 128, 0)
	
end
addEventHandler("onPlayerChangeNick", root, Main.blockNicknameChange)
