Srl = {}

--[[CREATE TABLE IF NOT EXISTS ddc_srl(id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, player_serial VARCHAR(100), player_ip VARCHAR(100), 
player_name VARCHAR(100), player_account VARCHAR(100), UNIQUE(player_serial, player_ip, player_name, player_account)) ENGINE = MYISAM;
]]


function Srl.register()

	if not isElement(source) then return end

	local playerAccount = getElementData(source, "account")
	
	if not playerAccount then
	
		playerAccount = ""
		
	end

	local playerSerial = getPlayerSerial(source)
	
	local playerIP = getPlayerIP(source)
	
	local playerName = getPlayerName(source)
	
	Srl.connection = exports["CCS_database"]:getConnection()
	
	if not Srl.connection then return end	
	
	dbExec(Srl.connection, "INSERT INTO ddc_srl(player_serial, player_ip, player_name, player_account) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE player_serial = ?", playerSerial, playerIP, playerName, playerAccount, playerSerial)

end
addEvent("onPlayerLoggedIn", true)
addEvent("onPlayerPlayAsGuest", true)
addEventHandler("onPlayerLoggedIn", root, Srl.register)
addEventHandler("onPlayerPlayAsGuest", root, Srl.register)


function Srl.check(p, c, player)

	local arenaElement = getElementParent(p)

	if player then 
	
		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)
	
	else
	
		player = p
		
	end

	if not player then return end
	
	Srl.connection = exports["CCS_database"]:getConnection()
	
	if not Srl.connection then return end	

	local playerSerial = getPlayerSerial(player)
	
	dbQuery(Srl.callback, {p, player}, Srl.connection, "SELECT DISTINCT player_name, player_account FROM ddc_srl WHERE player_serial = ?;", playerSerial)	
	

end
addCommandHandler("srl", Srl.check)


function Srl.callback(handle, p, player)

	local result = dbPoll(handle, 0)

	--No Result
	if not result then 
	
		outputDebugString("SRL: No result!")
		dbFree(handle)
		return
		
	end
	
	local playerName = getPlayerName(player):gsub('#%x%x%x%x%x%x', '')
	
	outputChatBox("Serial Check for player: "..playerName, p, 255, 0, 128)
	
	if #result == 0 then
	
		outputChatBox("Nothing found!", p, 255, 0, 128)
		return
	
	end
	
	outputChatBox(#result.." results found! Check Console for a list!", p, 255, 0, 128)
	
	for i, row in pairs(result) do
	
		local account = row.player_account
		
		if account == "" then
		
			account = "Guest"
			
		end
	
		outputConsole("- "..row.player_name:gsub('#%x%x%x%x%x%x', '').." ".."("..account..")", p)
	
	end

end