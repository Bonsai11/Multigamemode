Killdetection = {}
Killdetection.killDetection = {}
Killdetection.active = {}
Killdetection.kills = {}

function Killdetection.load(map)

	if map.type ~= "Cross" then return end
	
	outputServerLog(getElementID(source)..": Starting Derby Killdetection")
	
	addEventHandler("onPlayerWasted", source, Killdetection.checkkiller, true, "high")
	addEventHandler("onMapEnd", source, Killdetection.saveKills)
	Killdetection.killDetection[source] = {}
	Killdetection.active[source] = true
	Killdetection.kills[source] = {}

end
addEvent("onMapStart", true)
addEventHandler("onMapStart", root, Killdetection.load)


function Killdetection.unload()

	if not Killdetection.active[source] then return end

	outputServerLog(getElementID(source)..": Stopping Killdetection")	
	
	removeEventHandler("onPlayerWasted", source, Killdetection.checkkiller)
	removeEventHandler("onMapEnd", source, Killdetection.saveKills)
	Killdetection.killDetection[source] = {}
	Killdetection.active[source] = false
	Killdetection.kills[source] = {}
	
end
addEvent("onArenaReset", true)
addEventHandler("onArenaReset", root, Killdetection.unload)


function Killdetection.saveKills()

	for i, player in pairs(exports["CCS"]:export_getPlayersInArena(source)) do
		
		if Killdetection.kills[source][player] then
		
			triggerEvent("onDerbyKills", player, Killdetection.kills[source][player])
	
		end
	
	end

end
addEvent("onMapEnd", true)


function Killdetection.checkkiller()

	local arenaElement = getElementParent(source)

	if not getElementData(source, "derby_killer") then return end

	local killer = getElementData(source, "derby_killer")

	if not isElement(killer) then return end
	
	local myPlayerName = getPlayerName(source)
	
	local hisPlayername = getPlayerName(killer)
	
	triggerClientEvent(arenaElement, "onClientCreateMessage", source, "#ffffff"..myPlayerName.." #00ffffwas killed by #ffffff"..hisPlayername)

	if not Killdetection.kills[arenaElement][killer] then
	
		Killdetection.kills[arenaElement][killer] = 0
		
	end
	
	Killdetection.kills[arenaElement][killer] = Killdetection.kills[arenaElement][killer] + 1
	
end


