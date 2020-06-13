local Podium = {}
Podium.table = {}

function Podium.show()

	if not getElementData(source, "podium") then return end

	triggerClientEvent(source, "onClientShowPodium", source, Podium.table[source])

end
addEvent("onMapEnd", true)
addEventHandler("onMapEnd", root, Podium.show)


function Podium.reset()

	Podium.table[source] = {}

end
addEvent("onArenaReset", true)
addEventHandler("onArenaReset", root, Podium.reset)


function Podium.addWinner()

	Podium.add(source, 1)

end
addEvent("onPlayerWin", true)
addEventHandler("onPlayerWin", root, Podium.addWinner)


function Podium.addOther(position)

	if position < 2 or position > 3 then return end

	Podium.add(source, position)

end
addEvent("onPlayerFinishRace", true)
addEvent("onPlayerDerbyWasted", true)
addEvent("onPlayerBattleRoyaleWasted", true)
addEventHandler("onPlayerFinishRace", root, Podium.addOther)
addEventHandler("onPlayerDerbyWasted", root, Podium.addOther)
addEventHandler("onPlayerBattleRoyaleWasted", root, Podium.addOther)


function Podium.add(player, position)
	
	local arenaElement = getElementParent(player)	
	
	if not Podium.table then 
	
		Podium.table[arenaElement] = {}
		
	end	
	
	local spawnpoints = exports["CCS"]:export_getSpawnPoints(arenaElement)

	if spawnpoints and #spawnpoints > 0 then
	
		local color, color2

		if getElementData(arenaElement, "forced_vehicle_color") then
		
			local color = getElementData(arenaElement, "forced_vehicle_color")
		
		elseif getPlayerTeam(player) then

			local r, g, b = getTeamColor(getPlayerTeam(player))
			color = string.format("#%.2X%.2X%.2X%.2X", r, g, b, 255)

		elseif getElementData(player, "setting:car_color") then

			color = getElementData(player, "setting:car_color")
			color2 = getElementData(player, "setting:car_color2")
			
		else
		
			color = getElementData(arenaElement, "color")
			
		end
	
		local vehicleID  = spawnpoints[1].modelID
		
		table.insert(Podium.table[arenaElement], position, {name = getPlayerName(player), skin = getElementModel(player), vehicle = {id = vehicleID, color = color, color2 = color2}})
		
	else
	
		table.insert(Podium.table[arenaElement], position, {name = getPlayerName(player), skin = getElementModel(player), vehicle = nil})
	
	end

end