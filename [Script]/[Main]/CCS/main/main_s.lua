Main = {}

function Main.start()

	setTimer(startResource, 1000, 1, getResourceFromName("CCS_wrapper"))

	setGameType("DDC v3.0.0")
	setMapName("Drunk")
	setFPSLimit(60)

	createElement("Arena", "Lobby")
	setElementData(getElementByID("Lobby"), "inScoreboard", true)
	setElementData(getElementByID("Lobby"), "name", "Lobby")
	setElementData(getElementByID("Lobby"), "alias", "Lobby")
	setElementData(getElementByID("Lobby"), "creator", "Server")
	
	local cross = Arena.new("Cross", "Deathmatch", "Race", "Race", "Cross", 32, false, "Voting", "#679E37", 900000, true, "Server", true, false)
	cross:setPodiumEnabled(true)
	cross:setChallengesEnabled(true)
	cross:setGamblingEnabled(true)
	cross:setUserpanelEnabled(true)
	cross:setSpectatorsEnabled(true)
	cross:setAFKCheckEnabled(true)
	cross:setPingCheckEnabled(true)
	cross:setFPSCheckEnabled(true)
	cross:setVoteredoEnabled(true)
	cross:setTopkillsEnabled(true)
	cross:setStatsEnabled(true)
	cross:setMapstatsEnabled(true)

	local lemon = Arena.new("Lemon", "Oldschool", "Race", "Race", "Oldschool", 128, false, "Random", "#92B204", 900000, true, "Server", true, false)			
	lemon:setPodiumEnabled(true)
	lemon:setChallengesEnabled(true)
	lemon:setGamblingEnabled(true)
	lemon:setUserpanelEnabled(true)
	lemon:setSpectatorsEnabled(true)
	lemon:setModsEnabled(true)
	lemon:setAFKCheckEnabled(true)
	lemon:setVoteredoEnabled(true)
	lemon:setToptimesEnabled(true)
	lemon:setStatsEnabled(true)
	lemon:setMapstatsEnabled(true)
	
	local red = Arena.new("Red", "Classic", "Race", "Race", "Classic", 128, false, "Random", "#E53935", 900000, true, "Server", true, false)			
	red:setPodiumEnabled(true)
	red:setChallengesEnabled(true)
	red:setGamblingEnabled(true)
	red:setUserpanelEnabled(true)
	red:setSpectatorsEnabled(true)
	red:setModsEnabled(true)
	red:setAFKCheckEnabled(true)
	red:setVoteredoEnabled(true)
	red:setToptimesEnabled(true)
	red:setStatsEnabled(true)
	red:setMapstatsEnabled(true)	
	
	local night = Arena.new("Night", "Modern", "Race", "Race", "Modern", 128, false, "Random", "#778F9B", 900000, true, "Server", true, false)	
	night:setPodiumEnabled(true)
	night:setChallengesEnabled(true)
	night:setGamblingEnabled(true)
	night:setUserpanelEnabled(true)
	night:setSpectatorsEnabled(true)
	night:setModsEnabled(true)
	night:setAFKCheckEnabled(true)
	night:setVoteredoEnabled(true)
	night:setToptimesEnabled(true)
	night:setStatsEnabled(true)
	night:setMapstatsEnabled(true)
	
	local shooter = Arena.new("Shooter", "Shooter", "Race", "Race", "Shooter", 32, false, "Random", "#414141", 900000, true, "Server", true, false)
	shooter:setPodiumEnabled(true)
	shooter:setChallengesEnabled(true)
	shooter:setGamblingEnabled(true)
	shooter:setUserpanelEnabled(true)
	shooter:setSpectatorsEnabled(true)
	shooter:setModsEnabled(true)
	shooter:setAFKCheckEnabled(true)
	shooter:setPingCheckEnabled(true)
	shooter:setFPSCheckEnabled(true)
	shooter:setTopkillsEnabled(true)
	shooter:setStatsEnabled(true)
	shooter:setMapstatsEnabled(true)
	
	local pink = Arena.new("Pink", "Race", "Race", "Race", "Race", 128, false, "Random", "#EB3F79", 1200000, true, "Server", true, false)	
	pink:setPodiumEnabled(true)
	pink:setChallengesEnabled(true)	
	pink:setGamblingEnabled(true)
	pink:setUserpanelEnabled(true)
	pink:setSpectatorsEnabled(true)
	pink:setModsEnabled(true)
	pink:setAFKCheckEnabled(true)
	pink:setVoteredoEnabled(true)
	pink:setToptimesEnabled(true)
	pink:setStatsEnabled(true)
	pink:setMapstatsEnabled(true)
	
	local hunter = Arena.new("Hunter", "Hunter", "Race", "Fun", "Hunter", 128, false, "Random", "#1D87E4", 600000, true, "Server", true, false)	
	hunter:setPodiumEnabled(true)
	hunter:setUserpanelEnabled(true)
	hunter:setSpectatorsEnabled(true)
	hunter:setModsEnabled(true)
	hunter:setAFKCheckEnabled(true)
	hunter:setStatsEnabled(true)
	hunter:setMapstatsEnabled(true)
	
	local freeroam = Arena.new("Freeroam", "Freeroam", "Freeroam", "Fun", "Freeroam", 128, false, "Manual", "#4CAF50", 900000, true, "Server", true, false)
	freeroam:setSpectatorsEnabled(true)
	freeroam:setModsEnabled(true)
	freeroam:setStatsEnabled(true)
	
	local linez = Arena.new("Linez", "Linez", "Race", "Race", "Linez", 32, false, "Random", "#9932CC", 900000, true, "Server", true, false)
	linez:setPodiumEnabled(true)
	linez:setChallengesEnabled(true)		
	linez:setGamblingEnabled(true)
	linez:setUserpanelEnabled(true)
	linez:setSpectatorsEnabled(true)
	linez:setModsEnabled(true)
	linez:setAFKCheckEnabled(true)
	linez:setPingCheckEnabled(true)
	linez:setVoteredoEnabled(true)	
	linez:setTopkillsEnabled(true)
	linez:setStatsEnabled(true)
	linez:setMapstatsEnabled(true)
	
	local dynamic = Arena.new("Dynamic", "Dynamic", "Race", "Race", "Dynamic", 128, false, "Voting", "#FF7F50", 900000, true, "Server", true, false)
	dynamic:setPodiumEnabled(true)
	dynamic:setChallengesEnabled(true)
	dynamic:setGamblingEnabled(true)
	dynamic:setUserpanelEnabled(true)
	dynamic:setSpectatorsEnabled(true)
	dynamic:setModsEnabled(true)
	dynamic:setAFKCheckEnabled(true)
	dynamic:setVoteredoEnabled(true)	
	dynamic:setToptimesEnabled(true)
	dynamic:setStatsEnabled(true)
	dynamic:setMapstatsEnabled(true)
	
	local maptest = Arena.new("Maptest", "Maptest", "Race", "Misc", "Maptest", 128, "4321", "Voting", "#00BFFF", 900000, true, "Server", true, false)
	maptest:setSpectatorsEnabled(true)
	maptest:setModsEnabled(true)	
	maptest:setVoteredoEnabled(true)	
	
	--Competitive
	local competitive_oldschool = Arena.new("Competitive - Oldschool", "Competitive - Oldschool", "Race", "Competitive", "Oldschool", 2, false, "Competitive", "#92B204", 900000, true, "Server", true, false)
	setElementData(competitive_oldschool.element, "queue", 0)
	competitive_oldschool:setWaitingTime(60000)
	competitive_oldschool:setPodiumEnabled(true)	
	competitive_oldschool:setSpectatorsEnabled(true)
	competitive_oldschool:setModsEnabled(true)
	competitive_oldschool:setAFKCheckEnabled(true)
	competitive_oldschool:setToptimesEnabled(true)
		
	local competitive_shooter = Arena.new("Competitive - Shooter", "Competitive - Shooter", "Race", "Competitive", "Shooter", 2, false, "Competitive", "#414141", 900000, true, "Server", true, false)
	setElementData(competitive_shooter.element, "queue", 0)
	competitive_shooter:setWaitingTime(60000)
	competitive_shooter:setPodiumEnabled(true)
	competitive_shooter:setSpectatorsEnabled(true)
	competitive_shooter:setModsEnabled(true)
	competitive_shooter:setAFKCheckEnabled(true)
	competitive_shooter:setPingCheckEnabled(true)
	competitive_shooter:setTopkillsEnabled(true)
		
	local competitive_classic = Arena.new("Competitive - Classic", "Competitive - Classic", "Race", "Competitive", "Classic", 2, false, "Competitive", "#E53935", 900000, true, "Server", true, false)
	setElementData(competitive_classic.element, "queue", 0)
	competitive_classic:setWaitingTime(60000)
	competitive_classic:setPodiumEnabled(true)	
	competitive_classic:setSpectatorsEnabled(true)
	competitive_classic:setModsEnabled(true)
	competitive_classic:setAFKCheckEnabled(true)
	competitive_classic:setToptimesEnabled(true)
	
	local competitive_cross = Arena.new("Competitive - Cross", "Competitive - Cross", "Race", "Competitive", "Cross", 2, false, "Competitive", "#679E37", 900000, true, "Server", true, false)
	setElementData(competitive_cross.element, "queue", 0)
	competitive_cross:setWaitingTime(60000)
	competitive_cross:setPodiumEnabled(true)	
	competitive_cross:setSpectatorsEnabled(true)
	competitive_cross:setAFKCheckEnabled(true)
	competitive_cross:setTopkillsEnabled(true)
	
	local competitive_modern = Arena.new("Competitive - Modern", "Competitive - Modern", "Race", "Competitive", "Modern", 2, false, "Competitive", "#778F9B", 900000, true, "Server", true, false)	
	setElementData(competitive_modern.element, "queue", 0)
	competitive_modern:setWaitingTime(60000)
	competitive_modern:setPodiumEnabled(true)	
	competitive_modern:setSpectatorsEnabled(true)
	competitive_modern:setModsEnabled(true)
	competitive_modern:setAFKCheckEnabled(true)
	competitive_modern:setToptimesEnabled(true)
	
	local competitive_race = Arena.new("Competitive - Race", "Competitive - Race", "Race", "Competitive", "Race", 2, false, "Competitive", "#EB3F79", 900000, true, "Server", true, false)
	setElementData(competitive_race.element, "queue", 0)
	competitive_race:setWaitingTime(60000)
	competitive_race:setPodiumEnabled(true)
	competitive_race:setSpectatorsEnabled(true)
	competitive_race:setModsEnabled(true)
	competitive_race:setAFKCheckEnabled(true)
	competitive_race:setToptimesEnabled(true)
	
	--Clan
	local clan_7s = Arena.new("7s", "7s", "Race", "Clan", "Race", 128, "secretddc", "Voting", "#ffd700", 900000, true, "Server", true, false)
	clan_7s:setPodiumEnabled(true)
	clan_7s:setModsEnabled(true)
	clan_7s:setAFKCheckEnabled(true)
	clan_7s:setVoteredoEnabled(true)	
	clan_7s:setToptimesEnabled(true)
	clan_7s:setTopkillsEnabled(true)
	
	local clan_int = Arena.new("INT", "INT", "Race", "Clan", "Race", 128, "losints", "Voting", "#ffd700", 900000, true, "Server", true, false)
	clan_int:setPodiumEnabled(true)
	clan_int:setModsEnabled(true)
	clan_int:setAFKCheckEnabled(true)
	clan_int:setVoteredoEnabled(true)	
	clan_int:setToptimesEnabled(true)
	clan_int:setTopkillsEnabled(true)
	
	local los_santos = Arena.new("Battle_Royale_Los_Santos", "Los Santos", "Battle Royale", "Battle Royale", "BattleRoyale", 128, false, "Los Santos", "#FF7F50", 1200000, true, "Server", true, false)
	los_santos:setWaitingTime(30000)
	los_santos:setPodiumEnabled(true)
	los_santos:setSpectatorsEnabled(true)
	los_santos:setModsEnabled(true)
	los_santos:setStatsEnabled(true)
	
	local san_fierro = Arena.new("Battle_Royale_San_Fierro", "San Fierro", "Battle Royale", "Battle Royale", "BattleRoyale", 128, false, "San Fierro", "#FF7F50", 1200000, true, "Server", true, false)
	san_fierro:setWaitingTime(30000)
	san_fierro:setPodiumEnabled(true)
	san_fierro:setSpectatorsEnabled(true)
	san_fierro:setModsEnabled(true)
	san_fierro:setStatsEnabled(true)
	
	local las_venturas = Arena.new("Battle_Royale_Las_Venturas", "Las Venturas", "Battle Royale", "Battle Royale", "BattleRoyale", 128, false, "Las Venturas", "#FF7F50", 1200000, true, "Server", true, false)
	las_venturas:setWaitingTime(30000)
	las_venturas:setPodiumEnabled(true)
	las_venturas:setSpectatorsEnabled(true)
	las_venturas:setModsEnabled(true)
	las_venturas:setStatsEnabled(true)
	
	--Arena.new(name, alias, gamemode, category, type, maxplayers, password, mode, color, duration, inLobby, creator, inScoreboard, temporary)
	
	createElement("Arena", "Training")
	setElementData(getElementByID("Training"), "inScoreboard", true)
	setElementData(getElementByID("Training"), "name", "Training")
	setElementData(getElementByID("Training"), "alias", "Training")
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
