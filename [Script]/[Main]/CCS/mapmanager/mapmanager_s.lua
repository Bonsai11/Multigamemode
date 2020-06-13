MapManager = {}
MapManager.mapDataCache = {}
MapManager.vehicles = {}
MapManager.pickups = {}

function MapManager.startMap(map, sendToPlayers)
	
	if not map then

		for i, p in ipairs(getPlayersAndSpectatorsInArena(source)) do

			triggerEvent("onLobbyKick", source, p, "Kicked", "No Maps available!")

		end

		return

	end

	local tempMapTable = MapManager.loadMap(map.resource, source)
	
	if not tempMapTable then

		for i, p in ipairs(getPlayersAndSpectatorsInArena(source)) do

			triggerEvent("onLobbyKick", source, p, "Kicked", "Error loading Map!")

		end

		return

	end
	
	if getElementData(source, "gamemode") ~= "Freeroam" then

		Core.cleanArena(source)
		
		triggerClientEvent(source, "onClientMapChange", source, map)

	end

	setElementData(source, "map", map)

	Downloader.create(source, tempMapTable)

	if sendToPlayers then
	
		for i, player in ipairs(getPlayersAndSpectatorsInArena(source)) do

			triggerEvent("onStartDownload", source, player)

		end	
		
	end
	
	outputServerLog(getElementID(source)..": Starting new Map: "..getElementData(source, "map").name)

	triggerEvent("onMapChange", source, getElementData(source, "map"))

end
addEvent("onStartNewMap", true)
addEventHandler("onStartNewMap", root, MapManager.startMap)


function MapManager.loadMap(mapname, arenaElement)
	
	--Client Map Data
 	local MapTable = {}
	MapTable.mapData = {}
	MapTable.mapData.resourceName = mapname
   	MapTable.mapData.objects = {} 
	MapTable.mapData.marker = {}
	MapTable.mapData.pickup = {}
	MapTable.mapData.Jumps = {}
	MapTable.mapData.Freeze = {}
	MapTable.mapData.SpeedUp = {}
	MapTable.mapData.Flip = {}
	MapTable.mapData.Reverse = {}
	MapTable.mapData.Rotate = {}
	MapTable.mapData.checkpoints = {}
	MapTable.mapData.removeWorldObjects = {}
	MapTable.mapData.name = nil
	MapTable.mapData.author = nil
	MapTable.mapData.settings = {}
	MapTable.mapData.spawnpoints = {}

	MapTable.fileData = {}
	MapTable.fileData.data = {}
	MapTable.fileData.resourceName = mapname
	MapTable.fileHash = {}
	
	--Server Map Data
	MapManager.mapDataCache[arenaElement] = {}
	MapManager.mapDataCache[arenaElement].spawnpoints = {}
	MapManager.mapDataCache[arenaElement].isRaceMap = false
	MapManager.mapDataCache[arenaElement].pickups = {}
	MapManager.mapDataCache[arenaElement].vehicles = {}
	
    local metaXML = xmlLoadFile(":"..mapname.."/meta.xml")
	
    if not metaXML then return false end
			
	for i, m in ipairs(xmlNodeGetChildren(metaXML)) do
					
		local metaXMLName = xmlNodeGetName(m)
				
		if metaXMLName == "info" then
			
			MapTable.mapData.name = xmlNodeGetAttribute(m, "name") or "Unknown"		
			MapTable.mapData.author = xmlNodeGetAttribute(m, "author") or "Unknown"
				
		elseif metaXMLName == "map" then

			local mapPath = xmlNodeGetAttribute(m, "src")

			if not mapPath then return false end

			local mapFile = xmlLoadFile(":"..mapname.."/"..mapPath)
		
			if not mapFile then return false end
		
			local defType = xmlNodeGetAttribute(mapFile, "edf:definitions")
		
			for r, p in ipairs(xmlNodeGetChildren(mapFile)) do
					
				local objectType = xmlNodeGetName(p)

				if objectType == "spawnpoint" then
				
					table.insert(MapManager.mapDataCache[arenaElement].spawnpoints,{
					modelID = tonumber(xmlNodeGetAttribute(p, "vehicle")),
					interiorID = tonumber(xmlNodeGetAttribute(p, "interior")),
					posX = tonumber(xmlNodeGetAttribute(p, "posX")),
					posY = tonumber(xmlNodeGetAttribute(p, "posY")),
					posZ = tonumber(xmlNodeGetAttribute(p, "posZ")),
					rotX = tonumber(xmlNodeGetAttribute(p, "rotX")) or 0,
					rotY = tonumber(xmlNodeGetAttribute(p, "rotY")) or 0,
					rotZ = tonumber(xmlNodeGetAttribute(p, "rotZ")) or tonumber(xmlNodeGetAttribute(p, "rotation")) or 0,
					skin = tonumber(xmlNodeGetAttribute(p, "skin")) or 1,
					})
					
				elseif objectType == "object" then
				
					table.insert(MapTable.mapData.objects,{
					modelId = tonumber(xmlNodeGetAttribute(p,"model")),
					interiorID = tonumber(xmlNodeGetAttribute(p, "interior")) or 0,
					posX = tonumber(xmlNodeGetAttribute(p,"posX")),
					posY = tonumber(xmlNodeGetAttribute(p,"posY")),
					posZ = tonumber(xmlNodeGetAttribute(p,"posZ")),
					rotX = tonumber(xmlNodeGetAttribute(p,"rotX")) or 0,
					rotY = tonumber(xmlNodeGetAttribute(p,"rotY")) or 0,
					rotZ = tonumber(xmlNodeGetAttribute(p,"rotZ")) or 0,
					doublesided = xmlNodeGetAttribute(p,"doublesided") or "false",
					collisions = xmlNodeGetAttribute(p,"collisions") or "true",
					breakable = xmlNodeGetAttribute(p,"breakable") or "true",
					alpha = xmlNodeGetAttribute(p,"alpha") or 255,
					scale = xmlNodeGetAttribute(p,"scale") or 1
					})		
					
				elseif objectType == "vehicle" then
				
					table.insert(MapManager.mapDataCache[arenaElement].vehicles,{
					modelId = tonumber(xmlNodeGetAttribute(p,"model")),
					interiorID = tonumber(xmlNodeGetAttribute(p, "interior")) or 0,
					posX = tonumber(xmlNodeGetAttribute(p,"posX")),
					posY = tonumber(xmlNodeGetAttribute(p,"posY")),
					posZ = tonumber(xmlNodeGetAttribute(p,"posZ")),
					rotX = tonumber(xmlNodeGetAttribute(p,"rotX")) or 0,
					rotY = tonumber(xmlNodeGetAttribute(p,"rotY")) or 0,
					rotZ = tonumber(xmlNodeGetAttribute(p,"rotZ")) or 0,
					frozen = xmlNodeGetAttribute(p,"frozen") or "false"
					})	
					
				elseif objectType == "marker" then
				
					table.insert(MapTable.mapData.marker,{
					theType = xmlNodeGetAttribute(p, "type"),
					interiorID = tonumber(xmlNodeGetAttribute(p, "interior")) or 0,
					posX = tonumber(xmlNodeGetAttribute(p, "posX")),
					posY = tonumber(xmlNodeGetAttribute(p, "posY")),
					posZ = tonumber(xmlNodeGetAttribute(p, "posZ")),
					size = tonumber(xmlNodeGetAttribute(p, "size")),
					color = xmlNodeGetAttribute(p, "color")
					})
					
				elseif objectType == "racepickup" then
				
					table.insert(MapTable.mapData.pickup,{
					pickupType = xmlNodeGetAttribute(p, "type"),
					posX = tonumber(xmlNodeGetAttribute(p, "posX")),
					posY = tonumber(xmlNodeGetAttribute(p, "posY")),
					posZ = tonumber(xmlNodeGetAttribute(p, "posZ")),
					interiorID = tonumber(xmlNodeGetAttribute(p, "interior")),
					vehicle = tonumber(xmlNodeGetAttribute(p, "vehicle"))
					})
					
				elseif objectType == "checkpoint" then
				
					local size
					
					if not defType then
						
						size = (tonumber(xmlNodeGetAttribute(p, "size")) or 1) * 4
					
					else
					
						size = tonumber(xmlNodeGetAttribute(p, "size")) or 4
					
					end
				
					table.insert(MapTable.mapData.checkpoints,{
					posX = tonumber(xmlNodeGetAttribute(p, "posX")),
					posY = tonumber(xmlNodeGetAttribute(p, "posY")),
					posZ = tonumber(xmlNodeGetAttribute(p, "posZ")),
					size = size,
					color = xmlNodeGetAttribute(p, "color") or "#0000ff",
					type = xmlNodeGetAttribute(p, "type") or "checkpoint",
					id = xmlNodeGetAttribute(p, "id"),
					nextid = xmlNodeGetAttribute(p, "nextid"),
					vehicle = xmlNodeGetAttribute(p, "vehicle")
					})
					
					MapManager.mapDataCache[arenaElement].isRaceMap = true
					
				elseif objectType == "removeWorldObject" then
				
					table.insert(MapTable.mapData.removeWorldObjects,{
					radius = xmlNodeGetAttribute(p, "radius"),
					interior = tonumber(xmlNodeGetAttribute(p, "interior")) or 0,
					model = tonumber(xmlNodeGetAttribute(p, "model")),
					lodModel = tonumber(xmlNodeGetAttribute(p, "lodModel")),
					posX = tonumber(xmlNodeGetAttribute(p,"posX")),
					posY = tonumber(xmlNodeGetAttribute(p,"posY")),
					posZ = tonumber(xmlNodeGetAttribute(p,"posZ"))
					})
					
				elseif objectType == "pickup" then
				
					table.insert(MapManager.mapDataCache[arenaElement].pickups,{
					amount = tonumber(xmlNodeGetAttribute(p, "amount")) or 50,
					interior = tonumber(xmlNodeGetAttribute(p, "interior")) or 0,
					respawn = tonumber(xmlNodeGetAttribute(p, "respawn")) or 0,
					typ = xmlNodeGetAttribute(p, "type"),
					posX = tonumber(xmlNodeGetAttribute(p,"posX")),
					posY = tonumber(xmlNodeGetAttribute(p,"posY")),
					posZ = tonumber(xmlNodeGetAttribute(p,"posZ"))
					})
					
				elseif objectType == "Jump" then
				
					table.insert(MapTable.mapData.Jumps,{
					id = xmlNodeGetAttribute(p, "id"),
					type = xmlNodeGetAttribute(p, "type"),
					color = xmlNodeGetAttribute(p, "color") or "#ffffffff",
					power = xmlNodeGetAttribute(p, "power"),
					size = xmlNodeGetAttribute(p, "size"),
					posX = tonumber(xmlNodeGetAttribute(p,"posX")),
					posY = tonumber(xmlNodeGetAttribute(p,"posY")),
					posZ = tonumber(xmlNodeGetAttribute(p,"posZ"))
					})
					
				elseif objectType == "SpeedUp" then
				
					table.insert(MapTable.mapData.SpeedUp,{
					id = xmlNodeGetAttribute(p, "id"),
					type = xmlNodeGetAttribute(p, "type"),
					color = xmlNodeGetAttribute(p, "color") or "#ffffffff",
					power = xmlNodeGetAttribute(p, "power"),
					size = xmlNodeGetAttribute(p, "size"),
					posX = tonumber(xmlNodeGetAttribute(p,"posX")),
					posY = tonumber(xmlNodeGetAttribute(p,"posY")),
					posZ = tonumber(xmlNodeGetAttribute(p,"posZ"))
					})
					
				elseif objectType == "Freeze" then
				
					table.insert(MapTable.mapData.Freeze,{
					id = xmlNodeGetAttribute(p, "id"),
					type = xmlNodeGetAttribute(p, "type"),
					color = xmlNodeGetAttribute(p, "color") or "#ffffffff",
					time = xmlNodeGetAttribute(p, "time"),
					size = xmlNodeGetAttribute(p, "size"),
					posX = tonumber(xmlNodeGetAttribute(p,"posX")),
					posY = tonumber(xmlNodeGetAttribute(p,"posY")),
					posZ = tonumber(xmlNodeGetAttribute(p,"posZ"))
					})
					
				elseif objectType == "Flip" then
				
					table.insert(MapTable.mapData.Flip,{
					id = xmlNodeGetAttribute(p, "id"),
					type = xmlNodeGetAttribute(p, "type"),
					color = xmlNodeGetAttribute(p, "color") or "#ffffffff",
					size = xmlNodeGetAttribute(p, "size"),
					posX = tonumber(xmlNodeGetAttribute(p,"posX")),
					posY = tonumber(xmlNodeGetAttribute(p,"posY")),
					posZ = tonumber(xmlNodeGetAttribute(p,"posZ"))
					})
					
				elseif objectType == "Reverse" then
				
					table.insert(MapTable.mapData.Reverse,{
					id = xmlNodeGetAttribute(p, "id"),
					type = xmlNodeGetAttribute(p, "type"),
					color = xmlNodeGetAttribute(p, "color") or "#ffffffff",
					size = xmlNodeGetAttribute(p, "size"),
					posX = tonumber(xmlNodeGetAttribute(p,"posX")),
					posY = tonumber(xmlNodeGetAttribute(p,"posY")),
					posZ = tonumber(xmlNodeGetAttribute(p,"posZ"))
					})
					
				elseif objectType == "Rotate" then
				
					table.insert(MapTable.mapData.Rotate,{
					id = xmlNodeGetAttribute(p, "id"),
					type = xmlNodeGetAttribute(p, "type"),
					color = xmlNodeGetAttribute(p, "color") or "#ffffffff",
					size = xmlNodeGetAttribute(p, "size"),
					posX = tonumber(xmlNodeGetAttribute(p,"posX")),
					posY = tonumber(xmlNodeGetAttribute(p,"posY")),
					posZ = tonumber(xmlNodeGetAttribute(p,"posZ"))
					})
					
				else
					
					for r, q in ipairs(xmlNodeGetChildren(p)) do
						
						local objectType = xmlNodeGetName(q)
						
						if objectType == "object" then
				
							table.insert(MapTable.mapData.objects,{
							modelId = tonumber(xmlNodeGetAttribute(q,"model")),
							interiorID = tonumber(xmlNodeGetAttribute(q, "interior")) or 0,
							posX = tonumber(xmlNodeGetAttribute(q,"posX")),
							posY = tonumber(xmlNodeGetAttribute(q,"posY")),
							posZ = tonumber(xmlNodeGetAttribute(q,"posZ")),
							rotX = tonumber(xmlNodeGetAttribute(q,"rotX")) or 0,
							rotY = tonumber(xmlNodeGetAttribute(q,"rotY")) or 0,
							rotZ = tonumber(xmlNodeGetAttribute(q,"rotZ")) or 0,
							doublesided = xmlNodeGetAttribute(q,"doublesided") or "false",
							collisions = xmlNodeGetAttribute(q,"collisions") or "true",
							breakable = xmlNodeGetAttribute(q,"breakable") or "true",
							alpha = xmlNodeGetAttribute(q,"alpha") or 255,
							scale = xmlNodeGetAttribute(q,"scale") or 1
							})	
							
						end
					
					end
					
				end

			end
		
			xmlUnloadFile(mapFile)

		elseif metaXMLName == "script" then
		
			if xmlNodeGetAttribute(m,"type") ~= "server" then  
			
				local scriptPath = xmlNodeGetAttribute(m,"src")
				local file = fileOpen(":"..mapname.."/"..scriptPath)
				local content = fileRead(file, fileGetSize(file))
				local hash = md5(content)
				fileClose(file)
				table.insert(MapTable.fileData.data, {path = mapname.."/"..scriptPath, data = content})
				table.insert(MapTable.fileHash, {path = mapname.."/"..scriptPath, hash = hash})

			end
									
		elseif metaXMLName == "file" then	
		
			local filePath = xmlNodeGetAttribute(m,"src")
			local file = fileOpen(":"..mapname.."/"..filePath)
			local content = fileRead(file, fileGetSize(file))
			fileClose(file)
			table.insert(MapTable.fileData.data, {path = mapname.."/"..filePath, data = content})
			table.insert(MapTable.fileHash, {path = mapname.."/"..filePath, hash = md5(content)})
			
		elseif metaXMLName == "settings" then
		
			for i, node in ipairs(xmlNodeGetChildren(m)) do
			
				MapTable.mapData.settings[xmlNodeGetAttribute(node, "name")] = xmlNodeGetAttribute(node, "value")
			
			end
			
		end

	end 

	xmlUnloadFile(metaXML)

	MapTable.mapData.spawnpoints = MapManager.mapDataCache[arenaElement].spawnpoints

	outputServerLog(getElementID(arenaElement)..": Loading new Map: "..MapTable.mapData.name)
	
	return MapTable

		
end


function MapManager.getSpawnpoints(arenaElement)

	return MapManager.mapDataCache[arenaElement].spawnpoints

end
export_getSpawnPoints = MapManager.getSpawnpoints


function MapManager.getIsRaceMap(arenaElement)

	return MapManager.mapDataCache[arenaElement].isRaceMap
	
end


function MapManager.mapChange()

	for i, m in ipairs(MapManager.mapDataCache[source].vehicles) do
	
		local vehicle = createVehicle(m.modelId, m.posX, m.posY, m.posZ, m.rotX, m.rotY, m.rotZ)
		
		if vehicle then
		
			if m.frozen == "false" then
			
				setElementFrozen(vehicle, false)
			
			else
			
				setElementFrozen(vehicle, true)
				
			end

			setElementParent(vehicle, source)
			setElementDimension(vehicle, getElementDimension(source))
			setElementInterior(vehicle, m.interiorID)
			table.insert(MapManager.vehicles[source], vehicle)
			
		end
			
	end

	for i, p in ipairs(MapManager.mapDataCache[source].pickups) do
		
		local pickup
		
		if p.typ == "health" then 
		
			pickup = createPickup ( p.posX, p.posY, p.posZ, 0, p.amount, p.respawn)
			
		elseif p.typ == "armor" then 
		
			pickup = createPickup ( p.posX, p.posY, p.posZ, 1, p.amount, p.respawn)
			
		else
		
			pickup = createPickup ( p.posX, p.posY, p.posZ, 2, tonumber(p.typ), p.respawn, p.amount)
			
		end
	
		setElementParent(pickup, source)
		setElementInterior(pickup, p.interior)
		setElementDimension(pickup, getElementDimension(source))
		
		table.insert(MapManager.pickups[source], pickup)
		
	end

end
addEvent("onMapChange", true)
addEventHandler("onMapChange", root, MapManager.mapChange)


function MapManager.reset()

	if not MapManager.pickups[source] then
	
		MapManager.pickups[source] = {}
		
	end
	
	if not MapManager.vehicles[source] then
	
		MapManager.vehicles[source] = {}
		
	end	

	for i, pickup in ipairs(MapManager.pickups[source]) do
		
		if isElement(pickup) then destroyElement(pickup) end
		
	end

	for i, vehicle in pairs(MapManager.vehicles[source]) do
	
		if isElement(vehicle) then destroyElement(vehicle) end
		
	end
	
	MapManager.pickups[source] = {}
	MapManager.vehicles[source] = {}

end
addEvent("onArenaReset", true)
addEventHandler("onArenaReset", root, MapManager.reset)


function MapManager.fetchMaps(element)

	MapTypes = {"Classic", "Cross", "Oldschool", "Shooter", "Hunter", "Modern", "Race", "Freeroam", "Linez", "Dynamic", "Maptest", "BattleRoyale"}

	Maps = {}
	
	for i, type in ipairs(MapTypes) do
	
		if not Maps[type] then 
		
			Maps[type] = {} 
			
		end
	
	end

	for i, values in ipairs(getResources()) do
	
		local resource = getResourceName(values)
		local typ = getResourceInfo(values, "type")
		local name = getResourceInfo(values, "name") or "Unknown"
		local author = getResourceInfo(values, "author") or "Unknown"
	
		if typ == "map" then
			
			for i, maptype in ipairs(MapTypes) do
			
				if string.find(resource:lower(),"$"..maptype:lower(), 1, true) then
					
					table.insert(Maps[maptype], {resource = resource, name = name, type = maptype, author = author})
					
				end
			
			end
		
		end
	end

	outputServerLog("Fetching Maps complete:")
	
	if isElement(element) then
	
		outputConsole("Fetching Maps complete:", element)
		
	end
	
	for maptype, maps in pairs(Maps) do
	
		outputServerLog("  - "..#maps.." "..maptype.." maps found.")
		
		if isElement(element) then
		
			outputConsole("  - "..#maps.." "..maptype.." maps found.", element)
	
		end
	
	end

end
addEventHandler("onResourceStart", resourceRoot, MapManager.fetchMaps)
addCommandHandler("reloadmaps", MapManager.fetchMaps)


function MapManager.requestMaps(type)

	triggerClientEvent(source, "onRecieveMapList", root, MapManager.getMaps(type))

end
addEvent("onRequestMapList", true)
addEventHandler("onRequestMapList", root, MapManager.requestMaps)


function MapManager.getMaps(type)

	if not type or type == "" then
	
		type = "Cross;Classic;Oldschool;Modern;Race;Shooter;Linez;Dynamic"
	
	end

	local temp = {}

	for i, subType in pairs(split(type, ";")) do
		
		if Maps[subType] then
		
			for i, map in pairs(Maps[subType]) do
			
				table.insert(temp, map)
			
			end
			
		end
	
	end

	return temp or false

end
export_getMaps = MapManager.getMaps


function MapManager.findMap(query, type)

	local results = {}
	
	query = string.gsub(query, "([%*%+%?%.%(%)%[%]%{%}%\%/%|%^%$%-])","%%%1")
	
	local mapsTable = MapManager.getMaps(type)
	
	for i, map in ipairs(mapsTable) do

		if query == map.name:gsub("([%*%+%?%.%(%)%[%]%{%}%\%/%|%^%$%-])","%%%1") then
		
			return {map}
			
		end

		if string.find(map.name:lower(), query:lower()) then
		
			table.insert(results, map)
			
		end
		
	end
	
	return results
	
end
export_findMap = MapManager.findMap


function MapManager.getRandomArenaMap(type)

	local maps = MapManager.getMaps(type)

	if not maps then return false end

	if #maps == 0 then return end
	
	local randomMap = maps[math.random(tonumber(#maps))]
	
	return randomMap
	
end
export_getRandomArenaMap = MapManager.getRandomArenaMap


function MapManager.pickupHit(type, model)
	
	local vehicle = getPedOccupiedVehicle(source)  
	
	if not vehicle then return end
	
	if type == "vehiclechange" then
	
		setElementModel(vehicle, model)
	
	elseif type == "repair" then
	
		fixVehicle(vehicle)
			
	elseif type == "nitro" then
		
		addVehicleUpgrade(vehicle, 1010)
		
	elseif type == "linezbigline" then
		
		setElementData(source, "linez_size", 200)
		
	end

end
addEvent("onPlayerDerbyPickupHit", true)
addEventHandler("onPlayerDerbyPickupHit", root, MapManager.pickupHit)


function MapManager.moveMap(p, c, newType)

	if not newType then return end

	local arenaElement = getElementParent(p)

	local map = getElementData(arenaElement, "map")

	if not map then return end

	if not table.contains(MapTypes, newType) then
	
		outputChatBox("Valid map types are:", p, 255, 0, 128, true)
		
		for i, mapType in pairs(MapTypes) do
			
			outputChatBox("- "..mapType, p, 255, 0, 128, true)
			
		end
		
		return
	
	end
	
	local newResource = "$"..newType:lower()..string.sub(map.resource, string.find(map.resource, "-"), -1)
	
	renameResource(map.resource, newResource, "[Maps]/["..newType.."]")
	
	refreshResources()
	
	MapManager.fetchMaps()
	
	Chat.outputArenaChat(arenaElement, "#ffff00This map was moved to type '"..newType.."' by "..getCleanPlayerName(p))

end
addCommandHandler("movemap", MapManager.moveMap)


function MapManager.deleteMap(p, c)

	local arenaElement = getElementParent(p)

	local map = getElementData(arenaElement, "map")

	if not map then return end

	local resource = getResourceFromName(map.resource)

	if not resource then return end

	deleteResource(resource)

	refreshResources()

	MapManager.fetchMaps()

	Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." deleted this map from the Arena!")

end
addCommandHandler("deletemap", MapManager.deleteMap)


function MapManager.renameMap(p, c, ...)

	local arenaElement = getElementParent(p)

	local map = getElementData(arenaElement, "map")

	if not map then return end

	local resource = getResourceFromName(map.resource)

	if not resource then return end

	local query = #{...}>0 and table.concat({...},' ') or nil

	if not query then return end

	setResourceInfo(resource, "name", query) 

	refreshResources(true, resource)

	MapManager.fetchMaps()

	Chat.outputArenaChat(arenaElement, "#ffff00"..getCleanPlayerName(p).." renamed this map to "..query.."!")

end
addCommandHandler("renamemap", MapManager.renameMap)