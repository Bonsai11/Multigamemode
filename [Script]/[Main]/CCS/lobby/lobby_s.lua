local Login = {}
Login.loggedUsers = {}

function Login.login(username, password, remember_me)
	
	local account = getAccount(username, password)
	
	if account then
		logIn(source, account, password)
		Login.loginCallback(true, getPlayerName(source), remember_me, username, password, 1)
	else
		Login.loginCallback(false, getPlayerName(source), remember_me, username, password, 1)
	end
		
end
addEvent("onLogin", true)
addEventHandler("onLogin", root, Login.login)


function Login.loginCallback(result, playerName, remember_me, username, password, id)
	
	local player = getPlayerFromName(playerName)

	if not player then return end
	
	if getElementData(player, "state") ~= "Login" then return end

    if result == "ERROR" then 
		return 
	end
	
	if result then
	
		if Login.loggedUsers[username] then
		
			return triggerClientEvent(player, "onLoginResponse", root, -1, "account in use")
			
		end
		
		Login.loggedUsers[username] = true
		
		setElementData(player, "account", username)
		setElementData(player, "accountID", id)
		setElementData(player, "state", "Lobby")
		setElementData(player, "Arena", "Lobby")
		
		triggerClientEvent(player, "onLoginResponse", root, 1, false)
		
	else
	
		triggerClientEvent(player, "onLoginResponse", root, -1, "login invalid")
		
	end
	
end


function Login.register(username, password, email)

	local accountAdded = addAccount(username, password)
	
	if accountAdded then
		Login.registerCallback(true, getPlayerName(source), nil)
	else
		Login.registerCallback(false, getPlayerName(source), nil)
	end
		
end
addEvent("onRegister", true)
addEventHandler("onRegister", root, Login.register)


function Login.registerCallback(result, playerName, errors)

	local player = getPlayerFromName(playerName)

	if not player then return end
	
	if getElementData(player, "state") ~= "Login" then return end

    if result == "ERROR" then 
		return 
	end
		
	if result then
	
		triggerClientEvent(player, "onRegisterResponse", root, 1, false)
		
	else
	
		triggerClientEvent(player, "onRegisterResponse", root, -1, nil)
		
	end

end


function Login.guest()

	if not isElement(source) then return end

	if getElementData(source, "state") ~= "Login" then return end	
	
	setElementData(source, "state", "Lobby")
	setElementData(source, "Arena", "Lobby")
	
	--Success
	triggerClientEvent(source, "onGuestResponse", root, 1, false)

end
addEvent("onGuest", true)
addEventHandler("onGuest", root, Login.guest)


function Login.logout()

	logOut(source)

	local account = getElementData(source, "account")
	
	if not account then return end
	
	Login.loggedUsers[account] = nil

end
addEvent("onPlayerLoggedOut", true)
addEventHandler("onPlayerLoggedOut", root, Login.logout)
addEventHandler("onPlayerQuit", root, Login.logout)


function Login.createArena(name, password, afk, ping, fps, cptp, wff, specs, rewind, mods, arena_type)

	local myArena = Arena.new(name, name, "Race", "Custom", arena_type, 128, password, "Voting", "#999999", 900000, true, getPlayerName(source):gsub('#%x%x%x%x%x%x', ''), true, true)	
	
	if myArena then
		
		setElementData(myArena.element, "rewind", rewind)
		setElementData(myArena.element, "cptp", cptp)
		setElementData(myArena.element, "wff", wff)
		setElementData(myArena.element, "showSpectatorChat", true)
		myArena:setPodiumEnabled(true)
		myArena:setAFKCheckEnabled(afk)
		myArena:setPingCheckEnabled(ping)
		myArena:setFPSCheckEnabled(fps)
		myArena:setSpectatorsEnabled(specs)
		myArena:setModsEnabled(mods)
		myArena:setVoteredoEnabled(true)
		
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


function Login.createTrainingArena(map)

	local myTrainingArena = Arena.new(getPlayerSerial(source), getPlayerSerial(source), "Race", "Training", "Cross;Classic;Oldschool;Modern;Race;Shooter;Linez;Dynamic", 1, nil, "Training", "#999999", 1800000, false, "Training", false, true)
	
	if myTrainingArena then
		
		setElementData(myTrainingArena.element, "rewind", true)
		setElementData(myTrainingArena.element, "cptp", true)
		myTrainingArena:setModsEnabled(true)
		
		triggerClientEvent(source, "onArenaSelect", root, myTrainingArena.name)

		triggerEvent("onStartNewMap", myTrainingArena.element, map, false)

	else
	
		triggerClientEvent(source, "onArenaSelect", root, false)
	
	end
		
end
addEvent("onCreateTrainingArena", true)
addEventHandler("onCreateTrainingArena", root, Login.createTrainingArena)
