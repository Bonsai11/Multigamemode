RankingBoard = {}
RankingBoard.table = {}

function RankingBoard.destroy()

	RankingBoard.table[source] = {}

end
addEvent("onArenaReset", true)
addEventHandler("onArenaReset", root, RankingBoard.destroy)


function RankingBoard.add(position)

	local arenaElement = getElementParent(source)
	
	local time = exports["CCS"]:export_getTimePassed(arenaElement)

	if not RankingBoard.table then 
	
		RankingBoard.table[arenaElement] = {}
		
	end

	local upOrDown = true
	
	if eventName == "onPlayerFinishRace" then
	
		upOrDown = false

	end
	
	table.insert(RankingBoard.table[arenaElement], {pos = position, name = getPlayerName(source), time = time, direction = upOrDown})
	
	triggerClientEvent(arenaElement, "onClientRankingBoardUpdate", arenaElement, position, getPlayerName(source), time, upOrDown)

end
addEvent("onPlayerFinishRace", true)
addEvent("onPlayerDerbyWasted", true)
addEvent("onPlayerBattleRoyaleWasted", false)
addEventHandler("onPlayerFinishRace", root, RankingBoard.add)
addEventHandler("onPlayerDerbyWasted", root, RankingBoard.add)
addEventHandler("onPlayerBattleRoyaleWasted", root, RankingBoard.add)


function RankingBoard.send(arenaElement)

	if not RankingBoard.table[arenaElement] then return end

	for i, label in ipairs(RankingBoard.table[arenaElement]) do
	
		triggerClientEvent(source, "onClientRankingBoardUpdate", arenaElement, label.pos, label.name, label.time, label.direction)
		
	end

end
addEvent("onPlayerJoinArena", true)
addEventHandler("onPlayerJoinArena", root, RankingBoard.send)

