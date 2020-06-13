local Scoreboard = {}

function Scoreboard.requestInfo()

	triggerClientEvent(source, "onClientReceiveScoreboardInfo", source, {getServerName(), getMaxPlayers()})

end
addEvent("onRequestScoreboardInfo", true)
addEventHandler("onRequestScoreboardInfo", root, Scoreboard.requestInfo)


function Scoreboard.requestArenas()

	local arenas = {}

	for i, arenaElement in pairs(getElementsByType("Arena")) do
		
		if getElementData(arenaElement, "inScoreboard") then
			
			table.insert(arenas, arenaElement)

		end
		
	end

	triggerClientEvent(source, "onClientReceiveScoreboardArenas", source, arenas)

end
addEvent("onRequestScoreboardArenas", true)
addEventHandler("onRequestScoreboardArenas", root, Scoreboard.requestArenas)