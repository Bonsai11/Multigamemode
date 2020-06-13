Competitive = {}
Competitive.matchType = nil
Competitive.finishMessage = nil

function Competitive.reset()

	if Competitive.finishMessage then 
		
		Competitive.finishMessage:destroy()
		Competitive.finishMessage = nil
		
	end

	if Competitive.roundWinMessage then 
		
		Competitive.roundWinMessage:destroy()
		Competitive.roundWinMessage = nil
		
	end	
	
end
addEvent("onClientArenaReset", true)
addEventHandler("onClientArenaReset", root, Competitive.reset)


function Competitive.matchFound(type, timeout)
	
	Competitive.matchType = type
	
	outputChatBox("Competitive: Match found! Accept in Lobby!", 255, 255, 0)
	
	exports["CCS_notifications"]:export_showNotification("Competitive: Match found! Accept in Lobby!", "success")
	
end
addEvent("onClientCompetitiveMatchFound", true)
addEventHandler("onClientCompetitiveMatchFound", root, Competitive.matchFound)


function Competitive.acceptMatch()

	triggerServerEvent("onCompetitivePlayerMatchResponse", localPlayer, Competitive.matchType, true)

end


function Competitive.declineMatch()

	triggerServerEvent("onCompetitivePlayerMatchResponse", localPlayer, Competitive.matchType, false)
	
end


function Competitive.cancelled(timeout)

	Competitive.matchType = nil

	if timeout then
	
		exports["CCS_notifications"]:export_showNotification("Competitive: Match cancelled!", "error")
	
	else
	
		exports["CCS_notifications"]:export_showNotification("Competitive: Match timeout!", "error")
		
	end	

end
addEvent("onClientCompetitiveMatchCancelled", true)
addEventHandler("onClientCompetitiveMatchCancelled", root, Competitive.cancelled)


function Competitive.finished(byPlayerWin)

	Competitive.finishMessage = OnScreenMessage.new("Arena will be cleared in:\n", 0.75, "#ffffff", 2, 60000, false, true)

end
addEvent("onClientCompetitiveMatchFinished", true)
addEventHandler("onClientCompetitiveMatchFinished", root, Competitive.finished)


function Competitive.roundWin()

	local message = "#ffffff"..getPlayerName(source).."#04B404 has won the round!"

	Competitive.roundWinMessage = OnScreenMessage.new(message, 0.5, "#04B404", 3, 5000)

end
addEvent("onClientCompetitiveRoundWin", true)
addEventHandler("onClientCompetitiveRoundWin", root, Competitive.roundWin)