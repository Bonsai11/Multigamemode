Nitro = {}
Nitro.active = false
Nitro.nitroLevel = nil

function Nitro.activate()
	if Nitro.nitroType == "Normal" and isVehicleNitroActivated(getPedOccupiedVehicle(localPlayer)) then return end

	setVehicleNitroActivated(getPedOccupiedVehicle(localPlayer), not isVehicleNitroActivated(getPedOccupiedVehicle(localPlayer)))
end

function Nitro.stateChange(state)
	if getVehicleOccupant(source) ~= localPlayer then return end

	if not state then
		Nitro.nitroLevel = getVehicleNitroLevel(getPedOccupiedVehicle(localPlayer))
		
		if math.round(Nitro.nitroLevel, 2, "normal") == 0 then
			removeVehicleUpgrade(getPedOccupiedVehicle(localPlayer), getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer), 8))
		end
	else
		setVehicleNitroLevel(getPedOccupiedVehicle(localPlayer), Nitro.nitroLevel)
	end
end

function Nitro.update()
	Nitro.nitroLevel = 1
end
addEvent("updateClientNitro", true)

function Nitro.restore()
	if not getPedOccupiedVehicle(localPlayer) then return end
	
	Nitro.nitroLevel = getVehicleNitroLevel(getPedOccupiedVehicle(localPlayer)) or 0
end
addEventHandler("onClientVehicleEnter", root, Nitro.restore)

function Nitro.render()
	if not Nitro.active then return end
	if not getPedOccupiedVehicle(localPlayer) then return end

	if isVehicleNitroRecharging(getPedOccupiedVehicle(localPlayer)) then
		setVehicleNitroLevel(getPedOccupiedVehicle(localPlayer), Nitro.nitroLevel)
	end
	
	if Nitro.nitroLevel ~= (getVehicleNitroLevel(getPedOccupiedVehicle(localPlayer)) or 0) then
		Nitro.nitroLevel = getVehicleNitroLevel(getPedOccupiedVehicle(localPlayer))
	end
end

function Nitro.reset()
	removeEventHandler("onClientRender", root, Nitro.render)
	removeEventHandler("onClientVehicleNitroStateChange", root, Nitro.stateChange)	
	removeEventHandler("updateClientNitro", root, Nitro.update)
	unbindKey("vehicle_fire", "both", Nitro.activate)
	unbindKey("vehicle_secondary_fire", "both", Nitro.activate)
	removeCommandHandler("nitro", Nitro.command)
	Nitro.active = false
	Nitro.recharging = false
end
addEvent("onClientArenaReset", true)
addEventHandler("onClientArenaReset", root, Nitro.reset)

function Nitro.toggle(map)
	if map.type ~= "Cross" and map.type ~= "Race" then return end
	
	if getPedOccupiedVehicle(localPlayer) then
		Nitro.nitroLevel = getVehicleNitroLevel(getPedOccupiedVehicle(localPlayer)) or 0
	else
		Nitro.nitroLevel = 0
	end
	
	bindKey("vehicle_fire", "both", Nitro.activate)
	bindKey("vehicle_secondary_fire", "both", Nitro.activate)
	addEventHandler("onClientRender", root, Nitro.render)
	addEventHandler("onClientVehicleNitroStateChange", root, Nitro.stateChange)	
	addEventHandler("updateClientNitro", root, Nitro.update)
	addCommandHandler("nitro", Nitro.command)
	
	if fileExists("settings.nitro") then
		local file = fileOpen("settings.nitro")
		local fileData = fileRead(file, fileGetSize(file))
		fileClose(file)
		
		if fileData == "Normal" then
			Nitro.nitroType = "Normal"
		elseif fileData == "Hybrid" then
			Nitro.nitroType = "Hybrid"
		elseif fileData == "Nfs" then
			Nitro.nitroType = "Nfs"
		else
			Nitro.nitroType = "Normal"
			Nitro.saveSettings()
		end
	else
		Nitro.nitroType = "Normal"
	end

	outputChatBox("Use /nitro <mode> to change nitro mode! Current: '#00ff00"..Nitro.nitroType.."#00ffff'", 0, 255, 255, true)
	Nitro.switch(Nitro.nitroType)
	Nitro.recharging = false
end
addEvent("onClientMapStart", true)
addEventHandler("onClientMapStart", root, Nitro.toggle)

function Nitro.saveSettings()
	if fileExists("settings.nitro") then
		fileDelete("settings.nitro")
	end

	local file = fileCreate("settings.nitro")
	
	if file then   
		fileWrite(file, Nitro.nitroType)      
		fileClose(file)  
	else
		outputDebugString("Could not save nitro settings!")
	end
end

function Nitro.command(_, type)
	if type then type = type:lower() end

	if type ~= "nfs" and type ~= "hybrid" and type ~= "normal" then
		return outputChatBox("Possible nitro modes are: '#00ff00normal#00ffff', '#00ff00hybrid#00ffff', '#00ff00nfs#00ffff'! Current: '#00ff00"..Nitro.nitroType.."#00ffff'", 0, 255, 255, true)		
	end
	
	Nitro.switch(type)
	outputChatBox("Nitro mode changed to '#00ff00"..type.."#00ffff'!", 0, 255, 255, true)
end

function Nitro.switch(type)
	if type then type = type:lower() end

	if type == "nfs" then
		while getKeyBoundToFunction(Nitro.activate) do
			unbindKey(getKeyBoundToFunction(Nitro.activate), "both", Nitro.activate)
		end
	
		bindKey("vehicle_fire", "both", Nitro.activate )
		bindKey("vehicle_secondary_fire", "both", Nitro.activate )
		setVehicleNitroActivated(getPedOccupiedVehicle(localPlayer), false)
		Nitro.nitroType = "Nfs"
		Nitro.saveSettings()
	elseif type == "hybrid" then
		while getKeyBoundToFunction(Nitro.activate) do
			unbindKey(getKeyBoundToFunction(Nitro.activate), "both", Nitro.activate)
		end
	
		bindKey("vehicle_fire", "down", Nitro.activate )
		bindKey("vehicle_secondary_fire", "down", Nitro.activate )
		setVehicleNitroActivated(getPedOccupiedVehicle(localPlayer), false)
		Nitro.nitroType = "Hybrid"
		Nitro.saveSettings()
	elseif type == "normal" then
		while getKeyBoundToFunction(Nitro.activate) do
			unbindKey(getKeyBoundToFunction(Nitro.activate), "both", Nitro.activate)
		end
	
		toggleControl("vehicle_secondary_fire", true)
		bindKey("vehicle_fire", "down", Nitro.activate )
		bindKey("vehicle_secondary_fire", "down", Nitro.activate )
		setVehicleNitroActivated(getPedOccupiedVehicle(localPlayer), false)
		Nitro.nitroType = "Normal"
		Nitro.saveSettings()
	end
end

function math.round(number, decimals, method)
    decimals = decimals or 0
	local factor = 10 ^ decimals
	
	if (method == "ceil" or method == "floor") then 
		return math[method](number * factor) / factor 
	else 
		return tonumber(("%."..decimals.."f"):format(number))
	end
end