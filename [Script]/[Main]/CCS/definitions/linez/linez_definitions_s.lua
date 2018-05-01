Linez = {}
Linez.size = {}
Linez.kills = {}
Linez.randomPickupTimer = {}
Linez.pickups = {}
Linez.shieldObjects = {}
Linez.pickupTimers = {}
Linez.globalEffect = {}

function Linez.load()

	outputServerLog(getElementID(source)..": Loading Linez Definitions")

	addEventHandler("onPlayerLinezWasted", source, Linez.playerWasted)
	addEventHandler("onSetDownLinezDefinitions", source, Linez.unload)
	addEventHandler("onMapEnd", source, Linez.saveKills)
	addEventHandler("onMapStart", source, Linez.setupRandomPickups)
	addEventHandler("onColShapeHit", source, Linez.pickupHit)
	Linez.kills[source] = {}
	Linez.randomPickupTimer[source] = {}
	Linez.pickups[source] = {}
	Linez.pickupTimers[source] = {}
	Linez.shieldObjects[source] = {}
	Linez.globalEffect[source] = {}
	
end
addEvent("onSetUpLinezDefinitions", true)
addEventHandler("onSetUpLinezDefinitions", root, Linez.load)


function Linez.unload()

	outputServerLog(getElementID(source)..": Unloading Linez Definitions")

	removeEventHandler("onPlayerLinezWasted", source, Linez.playerWasted)
	removeEventHandler("onSetDownLinezDefinitions", source, Linez.unload)
	removeEventHandler("onMapEnd", source, Linez.saveKills)
	removeEventHandler("onMapStart", source, Linez.setupRandomPickups)
	removeEventHandler("onColShapeHit", source, Linez.pickupHit)
	Linez.kills[source] = {}
	if isTimer(Linez.randomPickupTimer[source]) then killTimer(Linez.randomPickupTimer[source]) end

	for i, colshape in pairs(Linez.pickups[source]) do
	
		local object
	
		if isElement(colshape) then
		
			object = getElementData(colshape, "object")
		
		end
		
		if isElement(object) then destroyElement(object) end
		if isElement(colshape) then destroyElement(colshape) end
	
	end
	
	for i, timer in pairs(Linez.pickupTimers[source]) do
	
		if isTimer(timer) then killTimer(timer) end
	
	end
	
	for i, object in pairs(Linez.shieldObjects[source]) do
	
		if isElement(object) then destroyElement(object) end
	
	end
	
end
addEvent("onSetDownLinezDefinitions", true)


function Linez.setupRandomPickups()

	Linez.randomPickupTimer[source] = setTimer(Linez.getRandomPickupPosition, 10000, 1, source)
	
end
addEvent("onMapStart", true)


function Linez.saveKills()

	for i, player in pairs(exports["CCS"]:export_getPlayersInArena(source)) do
		
		if Linez.kills[source][player] then
		
			triggerEvent("onShooterKills", player, Linez.kills[source][player])
	
		end
	
	end

end
addEvent("onMapEnd", true)


function Linez.playerWasted(killer)

	local arenaElement = getElementParent(source)

	if not isElement(killer) then return end
	
	local myPlayerName = getPlayerName(source)
	
	local hisPlayername = getPlayerName(killer)
	
	triggerClientEvent(arenaElement, "onClientCreateMessage", source, "#ffffff"..myPlayerName.." #00ffffwas killed by #ffffff"..hisPlayername)

	if not Linez.kills[arenaElement][killer] then
	
		Linez.kills[arenaElement][killer] = 0
		
	end
	
	Linez.kills[arenaElement][killer] = Linez.kills[arenaElement][killer] + 1
	
	if getPedOccupiedVehicle(killer) then
	
		fixVehicle(getPedOccupiedVehicle(killer))
	
		playSoundFrontEnd(killer, 46)
	
	end

end
addEvent("onPlayerLinezWasted", true)


function Linez.getRandomPickupPosition(arenaElement)

	local players = exports["CCS"]:export_getAlivePlayersInArena(arenaElement)

	if not players or #players == 0 then return end
	
	local randomPlayer = math.random(1, #players)
	
	randomPlayer = players[randomPlayer]

	if getPlayerIdleTime(randomPlayer) > 10000 then
	
		Linez.randomPickupTimer[arenaElement] = setTimer(Linez.getRandomPickupPosition, 10000, 1, arenaElement)
		
		return
		
	end
	
	local vehicle = getPedOccupiedVehicle(randomPlayer)
	
	if not vehicle then return end
	
	local x, y, z = getElementPosition(vehicle)
	
	Linez.randomPickupTimer[arenaElement] = setTimer(Linez.createPickup, 10000, 1, arenaElement, x, y, z)
	
end


function Linez.createPickup(arenaElement, x, y, z)

	local randomPickup = math.random(3)
	
	if randomPickup == 1 then

		local pickup = createObject(2224, x, y, z, 0, 0, 0, true)
		local colshape = createColSphere(x, y, z, 3.5)
		setElementData(colshape, "type", "linez")
		setElementData(colshape, "effect", "big_line")
		setElementData(colshape, "object", pickup, false)
		setElementParent(colshape, arenaElement)
		setElementDimension(pickup, getElementDimension(arenaElement))
		setElementDimension(colshape, getElementDimension(arenaElement))
		moveObject(pickup, 600000000, x, y, z, 0, 0, 100000000)
		
		table.insert(Linez.pickups[arenaElement], colshape)
		
	elseif randomPickup == 2 then

		local pickup = createObject(2225, x, y, z, 0, 0, 0, true)
		local colshape = createColSphere(x, y, z, 3.5)
		setElementData(colshape, "type", "linez")
		setElementData(colshape, "effect", "shield")
		setElementData(colshape, "object", pickup, false)
		setElementParent(colshape, arenaElement)
		setElementDimension(pickup, getElementDimension(arenaElement))
		setElementDimension(colshape, getElementDimension(arenaElement))
		moveObject(pickup, 600000000, x, y, z, 0, 0, 100000000)
		
		table.insert(Linez.pickups[arenaElement], colshape)
		
	elseif randomPickup == 3 then

		local pickup = createObject(2226, x, y, z, 0, 0, 0, true)
		local colshape = createColSphere(x, y, z, 3.5)
		setElementData(colshape, "type", "linez")
		setElementData(colshape, "effect", "tires")
		setElementData(colshape, "object", pickup, false)
		setElementParent(colshape, arenaElement)
		setElementDimension(pickup, getElementDimension(arenaElement))
		setElementDimension(colshape, getElementDimension(arenaElement))
		moveObject(pickup, 600000000, x, y, z, 0, 0, 100000000)
		
		table.insert(Linez.pickups[arenaElement], colshape)
		
		
	end

	Linez.randomPickupTimer[arenaElement] = setTimer(Linez.getRandomPickupPosition, 10000, 1, arenaElement, x, y, z)
	
end


function Linez.pickupHit(hitElement, matchingDimension)
	
	if getElementData(source, "type") ~= "linez" then return end

	if not matchingDimension then return end
	
	if getElementType(hitElement) ~= "vehicle" then return end

	local player = getVehicleOccupant(hitElement)

	if not player then return end
	
	local arenaElement = getElementParent(player)
	
	if getElementData(source, "effect") == "big_line" then
	
		if getElementData(player, "linez_size") == 150 then return end
	
		playSoundFrontEnd(player, 46)
	
		setElementData(player, "linez_size", 150)
		
		local timer = setTimer(Linez.resetPickupEffect, 15000, 1, player, "big_line")
		
		table.insert(Linez.pickupTimers[arenaElement], timer)
	
	elseif getElementData(source, "effect") == "shield" then
	
		if getElementData(player, "linez_shield") then return end
	
		playSoundFrontEnd(player, 46)
	
		setElementData(player, "linez_shield", true)
		
		setElementAlpha(hitElement, 100)
		
		local shield = createObject(2225, 0, 0, 0, 0, 0, 0, true)
		setElementCollisionsEnabled(shield, false)
		setElementDimension(shield, getElementDimension(arenaElement))
		table.insert(Linez.shieldObjects[arenaElement], shield)
		
		attachElements(shield, hitElement, 0, 0, 1.5)
		
		local timer = setTimer(Linez.resetPickupEffect, 15000, 1, player, "shield", shield)
		
		table.insert(Linez.pickupTimers[arenaElement], timer)
	
	elseif getElementData(source, "effect") == "tires" then
	
		if Linez.globalEffect[arenaElement] == "tires" then return end
	
		playSoundFrontEnd(player, 46)
	
		for i, p in pairs(exports["CCS"]:export_getAlivePlayersInArena(arenaElement)) do
			
			if getPedOccupiedVehicle(p) and p ~= player then
			
				setVehicleWheelStates(getPedOccupiedVehicle(p), 1, 1, 1, 1)

			end

		end
		
		Linez.globalEffect[arenaElement] = "tires"
		
		local timer = setTimer(Linez.resetPickupEffect, 15000, 1, player, "tires")
		
		table.insert(Linez.pickupTimers[arenaElement], timer)
	
	end
	
	local object = getElementData(source, "object")
	
	if isElement(object) then destroyElement(object) end
	if isElement(source) then destroyElement(source) end
	
end


function Linez.resetPickupEffect(player, effect, object)

	local arenaElement = getElementParent(player)

	if effect == "big_line" then
	
		setElementData(player, "linez_size", 50)

	elseif effect == "shield" then

		setElementData(player, "linez_shield", false)
		
		local vehicle = getPedOccupiedVehicle(player)
		
		if vehicle then
		
			setElementAlpha(vehicle, 255)
		
		end
		
		if isElement(object) then destroyElement(object) end
		
	elseif effect == "tires" then

		for i, player in pairs(exports["CCS"]:export_getAlivePlayersInArena(arenaElement)) do
			
			if getPedOccupiedVehicle(player) then
			
				setVehicleWheelStates(getPedOccupiedVehicle(player), 0, 0, 0, 0)

			end

		end	
		
		Linez.globalEffect[arenaElement] = false
		
	end

end
