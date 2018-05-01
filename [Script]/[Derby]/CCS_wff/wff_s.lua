WFF = {}
WFF.data = {}
WFF.counter = {}

function WFF.handleHunter(type, model)

	local arenaElement = getElementParent(source)
	
	if not getElementData(arenaElement, "wff") then return end
	
	if type ~= "vehiclechange" then return end

	if model == 425 then
	
		if not WFF.counter[arenaElement] then
		
			WFF.counter[arenaElement] = 0
			
		end
		
		WFF.counter[arenaElement] = WFF.counter[arenaElement] + 1
	
		local playerName = getPlayerName(source):gsub('#%x%x%x%x%x%x', '')
	
		local deathtime = exports["CCS"]:export_getTimePassed(arenaElement)
	
		deathtimeString = exports["CCS"]:export_msToTime(deathtime)
	
		local delayTime = getPlayerPing(source)
		
		delayTimeString = exports["CCS"]:export_msToTime(delayTime)
	
		local totalTimeString = exports["CCS"]:export_msToTime(tonumber(deathtime - delayTime))
	
		exports["CCS"]:export_outputArenaChat(arenaElement, "#ff5050WFF: #ffffff"..WFF.counter[arenaElement]..". #ff5050"..playerName.." #ffffffRaw: [#ff5050"..deathtimeString.."#ffffff] Delay: [#ffff00"..delayTimeString.."#ffffff] Total: [#00ff00"..totalTimeString.."#ffffff]")
		
	end
	
end
addEvent("onPlayerDerbyPickupHit", true)
addEventHandler("onPlayerDerbyPickupHit", root, WFF.handleHunter)


function WFF.registerPlayer(position)

	local arenaElement = getElementParent(source)
	
	if not getElementData(arenaElement, "wff") then return end
	
	if not WFF.data[arenaElement] then
	
		WFF.data[arenaElement] = {}
		
	end	
	
	local playerName = getPlayerName(source)
	
	local deathtime = exports["CCS"]:export_getTimePassed(arenaElement)
	
	deathtime = exports["CCS"]:export_msToTime(deathtime)
	
	if not deathtime then return end
	
	local x, y, z = getElementPosition(source)

	local marker = createMarker(x, y, z, "checkpoint", 2, 0, 0, 0, 100)
	
	setElementDimension(marker, getElementDimension(arenaElement))
	
	table.insert(WFF.data[arenaElement], {name = playerName, marker = marker, time = deathtime, posX = x, posY = y, posZ = z, position = position})
	
	triggerClientEvent(arenaElement, "onClientWFFUpdate", arenaElement, WFF.data[arenaElement])
	
end
addEvent("onPlayerDerbyWasted")
addEventHandler("onPlayerDerbyWasted", root, WFF.registerPlayer)


function WFF.reset()

	if not WFF.data[source] then
	
		WFF.data[source] = {}
		
	end	

	for i, data in pairs(WFF.data[source]) do
	
		if isElement(data.marker) then destroyElement(data.marker) end
		
	end
		
	WFF.data[source] = {}
	WFF.counter[source] = 0
	
end
addEventHandler("onArenaReset", root, WFF.reset)


function WFF.request()

	local arenaElement = getElementParent(source)

	if not getElementData(arenaElement, "wff") then return end
	
	triggerClientEvent(source, "onClientWFFUpdate", arenaElement, WFF.data[arenaElement])
	
end
addEvent("onWFFRequest", true)
addEventHandler("onWFFRequest", root, WFF.request)
