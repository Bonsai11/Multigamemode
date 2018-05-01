Antimod = {}
Antimod.playerMods = {}

function Antimod.check()

	resendPlayerModInfo(source)
	
end
addEvent("onPlayerJoinArena")
addEventHandler("onPlayerJoinArena", root, Antimod.check)


function Antimod.clean()

	Antimod.playerMods[source] = nil
	
end
addEvent("onPlayerLeaveArena")
addEventHandler("onPlayerLeaveArena", root, Antimod.clean)


function Antimod.getModInfo(filename, list)
	
	local arenaElement = getElementParent(source)
	
	local modList = {}
	
	Antimod.playerMods[source] = {}

	for i, value in pairs(list) do
	
		if string.find(value["name"], ".dff", 1, true) then
	   
			local name = value["name"]:gsub(".dff", '')
	   
			table.insert(modList, {id = value["id"], dff = value["name"], txd = name..".txd"})

		end
		
		table.insert(Antimod.playerMods[source], {name = value["name"], state = "#ff0000active"})

	end
		
	if not getElementData(arenaElement, "allow_mods") then 

		triggerClientEvent(source, "onClientPlayerModInfo", root, modList)
		
	else
	
		triggerClientEvent(source, "onClientPlayerModRestore", root)
	
	end
	
end
addEventHandler("onPlayerModInfo", root, Antimod.getModInfo)


function Antimod.updateModState(name, state)

	if not Antimod.playerMods[source] then return end
	
	for i, mod in pairs(Antimod.playerMods[source]) do
	
		if "models/"..mod.name == name then
			
			if state then
			
				mod.state = "#ff0000active"
			
			else
			
				mod.state = "#00f000inactive"
			
			end
			
		end
		
	end

end
addEvent("onPlayerUpdateModState", true)
addEventHandler("onPlayerUpdateModState", root, Antimod.updateModState)


function Antimod.checkPlayer(p, c, player)

	local arenaElement = getElementParent(p)
	
	if player then

		player = exports["CCS"]:export_findArenaPlayer(arenaElement, player)

	else

		player = p

	end

	if not player then return end

	local playerName = getPlayerName(player):gsub('#%x%x%x%x%x%x', '')	
	
	if not Antimod.playerMods[player] or #Antimod.playerMods[player] == 0 then
	
		outputChatBox("No mods found for player: "..playerName, p, 255, 0, 128)
		return
		
	end

	outputChatBox(#Antimod.playerMods[player].." mods found for player: "..playerName, p, 255, 0, 128)

	for i, mod in pairs(Antimod.playerMods[player]) do
	
		outputChatBox(i..". "..mod.name.." ("..mod.state.."#FF0080)", p, 255, 0, 128, true)
		
	end
	
end
addCommandHandler("getmods", Antimod.checkPlayer)
