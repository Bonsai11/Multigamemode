Competitive = {}
Competitive.matchID = nil

function Competitive.matchFound(matchID)

	outputDebugString("Client: Match Found")

	Competitive.matchID = matchID
	
	addCommandHandler("accept", Competitive.acceptMatch)
	addCommandHandler("decline", Competitive.declineMatch)
	
	outputChatBox("Match found! Use /accept or /decline within 30 seconds!", 255, 255, 0)
	
end
addEvent("onClientCompetitiveMatchFound", true)
addEventHandler("onClientCompetitiveMatchFound", root, Competitive.matchFound)


addCommandHandler("regist", function() triggerServerEvent("onCompetitiveRegister", localPlayer) end)
addCommandHandler("deregist", function() triggerServerEvent("onCompetitiveDeregister", localPlayer) end)

function Competitive.acceptMatch()

	triggerServerEvent("onCompetitivePlayerMatchResponse", localPlayer, Competitive.matchID, true)
	
	Competitive.matchID = nil
	
	removeCommandHandler("accept", Competitive.acceptMatch)
	removeCommandHandler("decline", Competitive.declineMatch)
	
end


function Competitive.declineMatch()

	triggerServerEvent("onCompetitivePlayerMatchResponse", localPlayer, Competitive.matchID, false)

	Competitive.matchID = nil
	
	removeCommandHandler("accept", Competitive.acceptMatch)
	removeCommandHandler("decline", Competitive.declineMatch)
	
end


function Competitive.cancelled(timeout)

	Competitive.matchID = nil

	if timeout then
	
		outputDebugString("client: match timeout")
	
		outputChatBox("Competitive: Match cancelled!", 255, 255, 0)	
	
	else
	
		outputDebugString("client: match cancelled")

		outputChatBox("Competitive: Match timeout!", 255, 255, 0)	
		
	end	
		
end
addEvent("onClientCompetitiveMatchCancelled", true)
addEventHandler("onClientCompetitiveMatchCancelled", root, Competitive.cancelled)


function Competitive.update(num, total)

	outputDebugString(num.." of "..total)

	outputChatBox("Competitive: "..num.." of "..total.." players ready!", 255, 255, 0)	
	
end
addEvent("onClientCompetitiveMatchUpdate", true)
addEventHandler("onClientCompetitiveMatchUpdate", root, Competitive.update)