Joinquit = {}

function Joinquit.joinMessage(isSpectator)

	if isSpectator then

		triggerEvent("onClientCreateMessage", root, getPlayerName(source).."#00ff00 has joined the Arena! #ffffff(Spectator)")
	
	else
	
		triggerEvent("onClientCreateMessage", root, getPlayerName(source).."#00ff00 has joined the Arena!")
	
	end
	
	outputConsole(string.gsub(getPlayerName(source).."#00ff00 has joined the Arena!", "#%x%x%x%x%x%x", ""))

end
addEvent("onClientPlayerJoinArena", true)
addEventHandler("onClientPlayerJoinArena", root, Joinquit.joinMessage)


function Joinquit.leaveMessage(name, reason)

	if reason then
	
		reason = "#ffffff[#ffff00"..reason.."#ffffff]"
		
	else
	
		reason = ""
		
	end
		
	triggerEvent("onClientCreateMessage", root, getPlayerName(source).."#ff0000 has left the Arena! "..reason)	
		
	outputConsole(string.gsub(getPlayerName(source).."#ff0000 has left the Arena! "..reason, "#%x%x%x%x%x%x", ""))
		
end
addEvent("onClientPlayerLeaveArena", true)
addEventHandler("onClientPlayerLeaveArena", root, Joinquit.leaveMessage)