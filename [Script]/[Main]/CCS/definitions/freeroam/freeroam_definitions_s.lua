Freeroam = {}
Freeroam.createdVehicles = {}
Freeroam.maxVehicles = 30
Freeroam.pickups = {}
Freeroam.spawns = {{2485, -1670, 13}, {-2328, -1625, 484}, {358, 2537, 17}, {-2464, 2234, 5}, {210, 1904, 18}, {2015, 1252, 11}}
Freeroam.respawnTimer = {}

function Freeroam.load()

	outputServerLog(getElementID(source)..": Loading Freeroam Definitions")
	addEventHandler("spawnOnPosition", source, Freeroam.requestSpawn)
	addEventHandler("onSetDownFreeroamDefinitions", source, Freeroam.unload)
	addEventHandler("createNewVehicle", source, Freeroam.createVehicle)
	addEventHandler("onPlayerWasted", source, Freeroam.playerWasted, true, "low")
	addEventHandler("createNewWeapon", source, Freeroam.createWeapon)
	addEventHandler("addUpgrade", source, addUpgrade)
	addEventHandler("changeSkin", source, changeSkin)
	addEventHandler("changeAnim", source, changeAnim)
	addEventHandler("giveJetpack", source, giveJetpack)
	addEventHandler("onPlayerLeaveArena", source, Freeroam.quit)
	addEventHandler("onPlayerRequestSpawn", source, Freeroam.spawn)
	Freeroam.createdVehicles[source] = {}
	Freeroam.pickups[source] = {}
	
	triggerEvent("onStartNewMap", source, MapManager.getRandomArenaMap("Freeroam"), false)

	setElementData(source, "state", "In Progress")

end
addEvent("onSetUpFreeroamDefinitions", true)
addEventHandler("onSetUpFreeroamDefinitions", root, Freeroam.load)


function Freeroam.unload()

	outputServerLog(getElementID(source)..": Unloading Freeroam Definitions")
	removeEventHandler("spawnOnPosition", source, Freeroam.requestSpawn)
	removeEventHandler("onSetDownFreeroamDefinitions", source, Freeroam.unload)
	removeEventHandler("createNewVehicle", source, Freeroam.createVehicle)
	removeEventHandler("createNewWeapon", source, Freeroam.createWeapon)
	removeEventHandler("onPlayerWasted", source, Freeroam.playerWasted)
	removeEventHandler("addUpgrade", source, addUpgrade)
	removeEventHandler("changeSkin", source, changeSkin)
	removeEventHandler("giveJetpack", source, giveJetpack)
	removeEventHandler("changeAnim", source, changeAnim)
	removeEventHandler("onPlayerLeaveArena", source, Freeroam.quit)
	removeEventHandler("onPlayerRequestSpawn", source, Freeroam.spawn)
	
	setElementData(source, "state", "End")
	
	for i, vehicle in ipairs(Freeroam.createdVehicles[source]) do 
	
		if vehicle and isElement(vehicle) then
		
			destroyElement(vehicle)
			
		end
	
	end
	
	Freeroam.createdVehicles[source] = {}
	
	for i, pickup in ipairs(Freeroam.pickups[source]) do 
	
		if pickup and isElement(pickup) then
		
			destroyElement(pickup)
			
		end
	
	end
	
	Freeroam.pickups[source] = {}
	
end
addEvent("onSetDownFreeroamDefinitions", true)


function Freeroam.spawn()

	local arenaElement = getElementParent(source)

	triggerClientEvent(source, "onClientPlayerReady", arenaElement, false, false)	

	if getElementData(source, "Spectator") then

		triggerClientEvent(source, "onClientRequestSpectatorMode", source, true)
		return

	end

	spawnPlayer(source, 2485, -1670, 13, 0, 0, 0, getElementDimension(arenaElement))
	setElementFrozen(source, false)
	setElementRotation(source, 0, 0, 0)
	setElementData(source, "state", "Alive")
	setCameraTarget(source, source)
	toggleAllControls(source, true, true, true)
	toggleControl(source, "fire", false)
	toggleControl(source, "action", false)
	toggleControl(source, "aim_weapon", false)
	setPedStat(source, 160, 1000)
	setPedStat(source, 229, 1000)
	setPedStat(source, 230, 1000)
	
end


function Freeroam.requestSpawn(x, y, z, respawn)

	local arenaElement = getElementParent(source)
	
	local skin = getElementModel(source)
	
	if respawn and getElementData(source, "state") ~= "Dead" then return end
	
	if getElementData(source, "state") == "Alive" then
	
		if getPedOccupiedVehicle(source) and getElementHealth(getPedOccupiedVehicle(source)) > 0 then
		
			setElementPosition(getPedOccupiedVehicle(source), x, y, z+3)
			fixVehicle(getPedOccupiedVehicle(source))
			
		else
		
			setElementPosition(source, x, y, z+3)
			setElementRotation(source, 0, 0, 0)
			
		end
		
		fadeCamera(source, true)
		
	else	
	
		spawnPlayer(source, x, y, z+3, 0, skin, 0, getElementDimension(arenaElement))
		setElementFrozen(source, false)
		setElementRotation(source, 0, 0, 0)
		setElementData(source, "state", "Alive")
		setCameraTarget(source, source)
		toggleAllControls(source, true, true, true)
		toggleControl(source, "fire", false)
		toggleControl(source, "action", false)
		toggleControl(source, "aim_weapon", false)
		setPedStat(source, 160, 1000)
		setPedStat(source, 229, 1000)
		setPedStat(source, 230, 1000)
		fadeCamera(source, true)
		
	end
		
end
addEvent("spawnOnPosition", true)


function Freeroam.createVehicle(id)

	if getElementData(source, "state") ~= "Alive" then return end

	local arenaElement = getElementParent(source)
	local element = getPedOccupiedVehicle(source) or source
	local x, y, z = getElementPosition(element)
	
	local localVehicle = createVehicle(id, x+3, y+3, z+3, 0, 0, 0) 
	
	if getPlayerTeam(source) then
	
		local r, g, b = getTeamColor(getPlayerTeam(source))
		setVehicleColor(localVehicle, r, g, b)
		
	elseif getElementData(source, "setting:car_color") then

		local color = getElementData(source, "setting:car_color")
		local color2 = getElementData(source, "setting:car_color2")
		local r, g, b = getColorFromString(color)
		local r2, g2, b2 = getColorFromString(color2)
		setVehicleColor(localVehicle, r, g, b, r2, g2, b2)
		
	else
	
		local color = getElementData(arenaElement, "color")
		local r, g, b = getColorFromString(color)
		setVehicleColor(localVehicle, r, g, b)
		
	end

	setElementDimension(localVehicle, getElementDimension(arenaElement))
	setElementParent(localVehicle, arenaElement)
	
	if #Freeroam.createdVehicles[arenaElement] == Freeroam.maxVehicles then
	
		destroyElement(Freeroam.createdVehicles[arenaElement][1])
		table.remove(Freeroam.createdVehicles[arenaElement], 1)
		
	end
	
	table.insert(Freeroam.createdVehicles[arenaElement], localVehicle)
			
end
addEvent("createNewVehicle", true)


function Freeroam.createWeapon(id)

	if getElementData(source, "state") ~= "Alive" then return end

	giveWeapon(source, id, 100, true)
	
	triggerClientEvent(source, "onPlayerReceiveWeapon", root)
		
end
addEvent("createNewWeapon", true)


function addUpgrade(id)

	if getElementData(source, "state") ~= "Alive" then return end
	
	addVehicleUpgrade(getPedOccupiedVehicle(source), id)
		
end
addEvent("addUpgrade", true)


function changeSkin(id)

	if getElementData(source, "state") ~= "Alive" then return end
	
	setElementModel(source, id)
		
end
addEvent("changeSkin", true)


function changeAnim(block, anim)

	if getElementData(source, "state") ~= "Alive" then return end
	
	if not block then
	
		setPedAnimation(source)
		return
		
	end
	
	setPedAnimation(source, block, anim, -1, true, true)
		
end
addEvent("changeAnim", true)


function giveJetpack()
	
	if getElementData(source, "state") ~= "Alive" then return end
	
    if not doesPedHaveJetPack(source) then 
	
		givePedJetPack (source)    
		
    else
	
		removePedJetPack(source) 
		
    end

end
addEvent("giveJetpack", true)


function Freeroam.quit()
	
	if isTimer(Freeroam.respawnTimer[source]) then killTimer(Freeroam.respawnTimer[source]) end
	Freeroam.respawnTimer[source] = nil
	
end
addEvent("onPlayerLeaveArena", true)


function Freeroam.playerWasted(totalAmmo, killer)

	local arenaElement = getElementParent(source)

	setElementData(source, "state", "Dead")
	
	if killer and getElementType(killer) == "vehicle" then
	
		killer = getVehicleOccupant(killer)
		
	end

	if killer then
	
		local myPlayerName = getPlayerName(source)

		local hisPlayername = getPlayerName(killer)

		triggerClientEvent(arenaElement, "onClientCreateMessage", source, "#ffffff"..myPlayerName.." #00ffffwas killed by #ffffff"..hisPlayername)

	else
	
		triggerClientEvent(arenaElement, "onClientCreateMessage", arenaElement, getPlayerName(source).."#ff0000 died!", "right")	
		
	end
	
	local x, y, z = getElementPosition(source)
	
    local currentweapon = getPedWeapon(source)
	
	if currentweapon ~= 0 then
	
		local pickup = createPickup(x, y, z, 2, currentweapon, 999999999, totalammo)
		
		setElementDimension(pickup, getElementDimension(arenaElement))
	
		table.insert(Freeroam.pickups[arenaElement], pickup)
	
	end
	
	Freeroam.respawnTimer[source] = setTimer(Freeroam.respawn, 3000, 1, source)
	
end


function Freeroam.respawn(player)

	if not isElement(player) then return end

	if getElementData(player, "state") ~= "Dead" then return end
	
	local spawn = math.random(#Freeroam.spawns)
	
	triggerEvent("spawnOnPosition", player, Freeroam.spawns[spawn][1], Freeroam.spawns[spawn][2], Freeroam.spawns[spawn][3], true)

end
