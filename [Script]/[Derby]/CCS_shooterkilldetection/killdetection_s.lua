Killdetection = {}
Killdetection.killDetection = {}
Killdetection.killResetInterval = 6000
Killdetection.colshapes = {}
Killdetection.active = {}
Killdetection.kills = {}

function Killdetection.load(map)

	if map.type ~= "Shooter" and map.type ~= "Hunter" then return end

	outputServerLog(getElementID(source)..": Starting Killdetection")
	addEventHandler("onPlayerWasted", source, Killdetection.checkkiller, true, "high")
	addEventHandler("onSetDownKilldetectionDefinitions", source, Killdetection.unload)
	addEventHandler("onProjectilePlayerHit", source, Killdetection.registerHit)
	addEventHandler("onMapEnd", source, Killdetection.saveKills)
	Killdetection.killDetection[source] = {}
	Killdetection.active[source] = true
	Killdetection.kills[source] = {}
	Killdetection.colshapes[source] = {}
	
	for i, p in ipairs(exports["CCS"]:export_getAlivePlayersInArena(source)) do 

		if getPedOccupiedVehicle(p) then
		
			local x, y, z = getElementPosition(getPedOccupiedVehicle(p))
			local colshape = createColSphere( x, y, z, 5.5)
			setElementDimension(colshape, getElementDimension(p))
			setElementData(colshape, "creator", p)
			attachElements(colshape, getPedOccupiedVehicle(p), 0, 0.5, 1)
			table.insert(Killdetection.colshapes[source], colshape)
			
		end

	end
	
end
addEvent("onMapStart", true)
addEventHandler("onMapStart", root, Killdetection.load)


function Killdetection.unload()

	if not Killdetection.active[source] then return end

	outputServerLog(getElementID(source)..": Stopping Killdetection")	
	removeEventHandler("onPlayerWasted", source, Killdetection.checkkiller)
	removeEventHandler("onSetDownKilldetectionDefinitions", source, Killdetection.unload)
	removeEventHandler("onProjectilePlayerHit", source, Killdetection.registerHit)
	removeEventHandler("onMapEnd", source, Killdetection.saveKills)
	Killdetection.killDetection[source] = {}
	Killdetection.active[source] = false
	Killdetection.kills[source] = {}
	
	for i, colshape in pairs(Killdetection.colshapes[source]) do
	
		if isElement(colshape) then 
	
			destroyElement(colshape)
		
		end
	
	end

	Killdetection.colshapes[source] = {}
	
end
addEvent("onArenaReset", true)
addEventHandler("onArenaReset", root, Killdetection.unload)


function Killdetection.saveKills()

	for i, player in pairs(exports["CCS"]:export_getPlayersInArena(source)) do
		
		if Killdetection.kills[source][player] then
		
			triggerEvent("onShooterKills", player, Killdetection.kills[source][player])
	
		end
	
	end

end
addEvent("onMapEnd", true)


function Killdetection.registerHit(thatPlayer)

	if not isElement(thatPlayer) then return end
	
	local arenaElement = getElementParent(source)

	Killdetection.killDetection[arenaElement][thatPlayer] = {killer = source, timeStamp = getTickCount()}

end
addEvent("onProjectilePlayerHit", true)


function Killdetection.checkkiller()

	local arenaElement = getElementParent(source)

	if not Killdetection.killDetection[arenaElement][source] then return end

	local killer = Killdetection.killDetection[arenaElement][source].killer
	
	if getTickCount() - Killdetection.killDetection[arenaElement][source].timeStamp > Killdetection.killResetInterval then return end

	if not isElement(killer) then return end
	
	local myPlayerName = getPlayerName(source)
	
	local hisPlayername = getPlayerName(killer)
	
	triggerClientEvent(arenaElement, "onClientCreateMessage", source, "#ffffff"..myPlayerName.." #00ffffwas killed by #ffffff"..hisPlayername)

	if not Killdetection.kills[arenaElement][killer] then
	
		Killdetection.kills[arenaElement][killer] = 0
		
	end
	
	Killdetection.kills[arenaElement][killer] = Killdetection.kills[arenaElement][killer] + 1
	
	if getPedOccupiedVehicle(killer) then
	
		fixVehicle(getPedOccupiedVehicle(killer))
	
		playSoundFrontEnd(killer, 46)
	
	end
	
end


