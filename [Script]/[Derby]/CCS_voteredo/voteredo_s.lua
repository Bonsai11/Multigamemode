Voteredo = {}
Voteredo.votes = {}
Voteredo.votedPlayers = {}
Voteredo.locked = {}
Voteredo.mapHistory = {}
Voteredo.percentFirstRedo = 0.51
Voteredo.percentSecondRedo = 0.75
Voteredo.percentThirdRedo = 1

function Voteredo.mapChange(map)
	
	if not Voteredo.mapHistory[source] then
	
		Voteredo.mapHistory[source] = {}
	
		for i=1, 3, 1 do
		
			table.insert(Voteredo.mapHistory[source], 1, {false, false})
		
		end
		
	end

	if #Voteredo.mapHistory[source] == 3 then
	
		table.remove(Voteredo.mapHistory[source], 3)
	
	end
	
	table.insert(Voteredo.mapHistory[source], 1, map)
	
	--Reset
	Voteredo.votes[source] = 0
	Voteredo.votedPlayers[source] = {}
	Voteredo.locked[source] = false

end
addEvent("onMapChange", true)
addEventHandler("onMapChange", root, Voteredo.mapChange)


function Voteredo.command(player) 

	local element = getElementParent(player)

	if not getElementData(element, "voteRedo") then return end

	if Voteredo.locked[element] then return end
	
	--Nextmap already set?
	if #getElementData(element, "nextmap") > 2 then 
	
		outputChatBox("Next map queue is full!", player)
		return 
		
	end

	--No new map started since resourceStart
	if not Voteredo.mapHistory[element] then return end
	
	--Player already voted
	if Voteredo.votedPlayers[element][getPlayerSerial(player)] then return end

	--1 is current map, 2 last map, 3 pre last map
	if not Voteredo.mapHistory[element][1] then return end

	Voteredo.votes[element] = Voteredo.votes[element] + 1
	Voteredo.votedPlayers[element][getPlayerSerial(player)] = true
	
	local playerName = getPlayerName(player)

	local percentNeeded = 0
	
	if Voteredo.mapHistory[element][1].resource ~= Voteredo.mapHistory[element][2].resource then
	
		percentNeeded = Voteredo.percentFirstRedo
		
	elseif Voteredo.mapHistory[element][1].resource == Voteredo.mapHistory[element][2].resource and Voteredo.mapHistory[element][1].resource ~= Voteredo.mapHistory[element][3].resource then
	
		percentNeeded = Voteredo.percentSecondRedo
	
	elseif Voteredo.mapHistory[element][1].resource == Voteredo.mapHistory[element][2].resource and Voteredo.mapHistory[element][1].resource == Voteredo.mapHistory[element][3].resource then
	
		percentNeeded = Voteredo.percentThirdRedo
	
	end
	
	local missing = math.ceil((#exports["CCS"]:export_getPlayersInArena(element) * percentNeeded)) - Voteredo.votes[element]
	
	--if some players who already voted leave, it might go negative
	missing = math.max(missing, 0)
	
	triggerClientEvent(element, "onClientCreateMessage", element, playerName.." #00ff00used /vr! ("..(percentNeeded*100).."% Mode | "..missing.." votes missing)")
	
	if missing == 0 then
	
		Voteredo.locked[element] = true
		triggerClientEvent(element, "onClientCreateMessage", element, "#00ff00Voteredo successful!")
		
		local nextmap = getElementData(element, "nextmap")
	
		table.insert(nextmap, 1, Voteredo.mapHistory[element][1])
	
		setElementData(element, "nextmap", nextmap)
		
		exports["CCS"]:export_outputArenaChat(element, "#00f000Vote Redo: This map will be played again.")
	
	end

end
addCommandHandler("vr", Voteredo.command)
