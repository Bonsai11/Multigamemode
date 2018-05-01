VoteManager = {}
VoteManager.optionPool = {}
VoteManager.votes = {}
VoteManager.voteTime = 8000
VoteManager.maxOptions = 8
VoteManager.timers = {}
VoteManager.nomination = {}
VoteManager.lastMap = {}
VoteManager.playedAgain = {}

function VoteManager.start(nominationMaps)

	local arenaID = getElementID(source)
	
	VoteManager.votes[source] = {}
	VoteManager.optionPool[source] = {}
	VoteManager.timers[source] = {}
	
	if nominationMaps then
	
		VoteManager.nomination[source] = VoteManager.nomination[source] + 1
		
		for i, option in pairs(nominationMaps) do
		
			table.insert(VoteManager.optionPool[source], {data = option.data, name = option.name})
			table.insert(VoteManager.votes[source], 0)
		
		end
		
	else
	
		VoteManager.nomination[source] = 1
		
		--Arena Map Type
		local typ = getElementData(source, "type")
		
		for i=1, VoteManager.maxOptions, 1 do
			
			local map = MapManager.getRandomArenaMap(typ)
			
			if map then
			
				table.insert(VoteManager.optionPool[source], {data = map, name = map.name})
				table.insert(VoteManager.votes[source], 0)
				
			end
			
		end
		
		if VoteManager.lastMap[source] and #VoteManager.lastMap[source] > 1 and VoteManager.lastMap[source][1].resource ~= VoteManager.lastMap[source][2].resource then
	
			table.insert(VoteManager.optionPool[source], {data = getElementData(source, "map"), name = "Play again"})
			table.insert(VoteManager.votes[source], 0)
		
		end
	
	end
	
	triggerClientEvent(source, "onClientVoteStart", source, {mapList = VoteManager.optionPool[source], voteTime = VoteManager.voteTime})
	
	VoteManager.timers[source] = setTimer(VoteManager.result, VoteManager.voteTime, 1, source)

	outputServerLog(arenaID..": Starting Vote")

end
addEvent("onStartVote", true)
addEventHandler("onStartVote", root, VoteManager.start)


function VoteManager.mapChange(map)

	if not VoteManager.lastMap[source] then
	
		VoteManager.lastMap[source] = {}
		
	end
	
	table.insert(VoteManager.lastMap[source], 1, map)

	if #VoteManager.lastMap[source] == 3 then
	
		table.remove(VoteManager.lastMap[source], 3)
	
	end	
	
end
addEvent("onMapChange")
addEventHandler("onMapChange", root, VoteManager.mapChange)


function VoteManager.destroy()

	if isTimer(VoteManager.timers[source]) then killTimer((VoteManager.timers[source])) end

end
addEvent("onArenaReset", true)
addEventHandler("onArenaReset", root, VoteManager.destroy)


function VoteManager.receiveVote(vote, setOrRemove)

	local arenaElement = getElementParent(source)
	
	if not VoteManager.votes[arenaElement][vote] then return end

	if setOrRemove then
	
		VoteManager.votes[arenaElement][vote] = VoteManager.votes[arenaElement][vote] + 1
	
	else
	
		VoteManager.votes[arenaElement][vote] = VoteManager.votes[arenaElement][vote] - 1
	
	end
	
	triggerClientEvent(arenaElement, "onClientVoteUodate", arenaElement, VoteManager.votes[arenaElement])

end
addEvent("onReceiveVote", true)
addEventHandler("onReceiveVote", root, VoteManager.receiveVote)


function VoteManager.result(arenaElement)

	triggerClientEvent(arenaElement, "onClientVoteEnd", arenaElement)
	
	local topOptions = VoteManager.getTopVote(arenaElement)
	
	if #topOptions > 1 and VoteManager.nomination[arenaElement] == 1 then
	
		triggerEvent("onStartVote", arenaElement, topOptions)
		
		outputServerLog(getElementID(arenaElement)..": Voting Result: Draw! Starting another nomination!")	

	else

		outputServerLog(getElementID(arenaElement)..": Voting Result: "..topOptions[1].name)	
		
		triggerEvent("onStartNewMap", arenaElement, topOptions[1].data)

		for i, player in ipairs(getPlayersAndSpectatorsInArena(arenaElement)) do

			triggerEvent("onStartDownload", arenaElement, player)

		end		
		
	end	
		
end


function VoteManager.getTopVote(arenaElement)

	local maximum = 0
	local topOptions = {}
	
	for i, vote in ipairs(VoteManager.votes[arenaElement]) do 
		
		if vote ~= 0 and vote > maximum then
			
			topOptions = {}
			table.insert(topOptions, VoteManager.optionPool[arenaElement][i])
			
			maximum = vote
			
		elseif vote ~= 0 and vote == maximum then
			
			table.insert(topOptions, VoteManager.optionPool[arenaElement][i])
			
		end
	
	end
	
	--Nobody voted, choose random map
	if #topOptions == 0 then
	
		table.insert(topOptions, VoteManager.optionPool[arenaElement][math.random(1, #VoteManager.optionPool[arenaElement])])

	end
	
	return topOptions
	
end
