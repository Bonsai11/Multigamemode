Gametime = {}
Gametime.sessionList = {}

--[[
CREATE TABLE IF NOT EXISTS ddc_gametime (id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, player_account VARCHAR(255) NOT NULL, 
ddc_Night BIGINT NOT NULL DEFAULT 0, ddc_Lemon BIGINT NOT NULL DEFAULT 0, ddc_Cross BIGINT NOT NULL DEFAULT 0, 
ddc_Red BIGINT NOT NULL DEFAULT 0, ddc_Pink BIGINT NOT NULL DEFAULT 0, ddc_Shooter BIGINT NOT NULL DEFAULT 0, 
ddc_Lilac BIGINT NOT NULL DEFAULT 0, ddc_Orange BIGINT NOT NULL DEFAULT 0, date_recorded DATE, UNIQUE (player_account, date_recorded));
]]

function Gametime.main()

	for i, player in pairs(getElementsByType("player")) do
	
		Gametime.createSession(player)
	
	end
	
end
addEventHandler("onResourceStart", resourceRoot, Gametime.main)


function Gametime.handleStop()

	for i, player in pairs(getElementsByType("player")) do
	
		Gametime.saveSession(player)
	
	end

end
addEventHandler("onResourceStop", resourceRoot, Gametime.handleStop)


function Gametime.createSession(player)
	
	local account = getElementData(player, "account")

	if not account then return end
	
	local arenaElement = getElementParent(player)

	if not getElementData(arenaElement, "stats") then return end
	
	local arena = getElementID(arenaElement)
	
	if not arena then return end
	
	Gametime.sessionList[account] = getTickCount()

	outputServerLog(arena..": Session created for : "..getPlayerName(player))
	
end


function Gametime.playerLeave()

	Gametime.saveSession(source)

end
addEvent("onPlayerLeaveArena", true)
addEventHandler("onPlayerLeaveArena", root, Gametime.playerLeave)


function Gametime.playerJoin()
	
	Gametime.createSession(source)
	
end
addEvent("onPlayerJoinArena", true)
addEventHandler("onPlayerJoinArena", root, Gametime.playerJoin)


function Gametime.saveSession(player)

	local account = getElementData(player, "account")

	if not account then return end
	
	local arenaElement = getElementParent(player)

	if not getElementData(arenaElement, "stats") then return end
	
	local arena = getElementID(arenaElement)
	
	if not arena then return end
	
	local playerName = getPlayerName(player)
	
	local playerSerial = getPlayerSerial(player)
	
	if not Gametime.sessionList[account] then return end

	local sessionTime = getTickCount() - Gametime.sessionList[account]
	
	local resource = getResourceFromName("CCS_database")
	
	if not resource then return end

	if getResourceState(resource) ~= "running" then return end
	
	Gametime.connection = exports["CCS_database"]:getConnection()
	
	if not Gametime.connection then return end		
	
	local tableName = "ddc_"..arena
	
	dbExec(Gametime.connection, "INSERT INTO ddc_gametime (player_account, date_recorded) VALUES (?, CURDATE()) ON DUPLICATE KEY UPDATE id = id", account, playerSerial)

	dbExec(Gametime.connection, "UPDATE ddc_gametime SET "..tableName.." = "..tableName.." + ? WHERE player_account = ? AND date_recorded = CURDATE()", sessionTime, account)
	
	Gametime.sessionList[account] = nil
	
	outputServerLog(arena..": Session saved for : "..getPlayerName(player))
	
end