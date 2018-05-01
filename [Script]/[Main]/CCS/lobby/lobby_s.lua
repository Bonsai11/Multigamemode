local Login = {}
Login.loggedUsers = {}

function Login.login(username, password, remember_me)
	
	callRemote("https://ddc.community/api/index.php?function=login", 1, Login.callback, getPlayerName(source), username, password, remember_me)
	
end
addEvent("onLogin", true)
addEventHandler("onLogin", root, Login.login)


function Login.callback(result, playerName, remember_me, username, password, id)
	
	local player = getPlayerFromName(playerName)

	if not player then return end
	
	if getElementData(player, "state") ~= "Login" then return end

    if result == "ERROR" then 
	
		return 
		
	end

	if result == "true" then
		
		if Login.loggedUsers[username] then
		
			triggerClientEvent(player, "onLoginResponse", root, 0)
			return
		
		end
		
		Login.loggedUsers[username] = true
		
		setElementData(player, "account", username)
		setElementData(player, "accountID", id)
		setElementData(player, "state", "Lobby")
		setElementData(player, "Arena", "Lobby")
		
		triggerClientEvent(player, "onLoginResponse", root, 3, remember_me, username, password)
		
	else
		
		triggerClientEvent(player, "onLoginResponse", root, 2)
		
	end
	
end


function Login.guest()

	if not isElement(source) then return end

	if getElementData(source, "state") ~= "Login" then return end	
	
	setElementData(source, "state", "Lobby")
	setElementData(source, "Arena", "Lobby")
	
	--Success
	triggerClientEvent(source, "onGuestResponse", root, 2)

end
addEvent("onGuest", true)
addEventHandler("onGuest", root, Login.guest)


function Login.logout()

	local account = getElementData(source, "account")
	
	if not account then return end
	
	Login.loggedUsers[account] = nil

end
addEvent("onPlayerLoggedOut", true)
addEventHandler("onPlayerLoggedOut", root, Login.logout)
addEventHandler("onPlayerQuit", root, Login.logout)


function Login.createArena(name, password, afk, ping, fps, cptp, wff, specs, rewind, mods, arena_type)

	local myArena = Arena.new(name, "Race", "Custom", arena_type, 128, password, "Voting", "#999999", 900000, afk, ping, fps, true, getPlayerName(source):gsub('#%x%x%x%x%x%x', ''), true, true, true, false, false, false, false, false, false, specs, mods)	
	
	if myArena then
		
		setElementData(myArena.element, "rewind", rewind)
		setElementData(myArena.element, "cptp", cptp)
		setElementData(myArena.element, "wff", wff)
		setElementData(myArena.element, "showSpectatorChat", true)
		
		triggerClientEvent(source, "onArenaSelect", root, myArena.name)
		
		if getElementData(source, "account") then
		
			ACL.addPlayer(getElementData(source, "account"), myArena.name, "8")
	
		else
		
			outputChatBox("Create an account and login to be automatically added as an admin in your custom arena.", source, 255, 0, 128)
	
		end
	
	else
	
		triggerClientEvent(source, "onArenaSelect", root, false)
	
	end
	
end
addEvent("onLobbyCreateArena", true)
addEventHandler("onLobbyCreateArena", root, Login.createArena)


function Login.createTrainingArena()

	local myTrainingArena = Arena.new(getPlayerSerial(source), "Race", "Training", "Cross;Classic;Oldschool;Modern;Race;Shooter;Linez;Dynamic", 1, nil, "Training", "#999999", 1800000, false, false, false, false, "Training", false, true, false, false, false, false, false, false, false, true)
	
	if myTrainingArena then
		
		setElementData(myTrainingArena.element, "rewind", true)
		setElementData(myTrainingArena.element, "cptp", true)

		triggerClientEvent(source, "onArenaSelect", root, myTrainingArena.name)

	else
	
		triggerClientEvent(source, "onArenaSelect", root, false)
	
	end
		
end
addEvent("onCreateTrainingArena", true)
addEventHandler("onCreateTrainingArena", root, Login.createTrainingArena)
