Nitro = {}
Nitro.active = false
Nitro.nitroLevel = nil
Nitro.unlimited = false
Nitro.recharging = false

function Nitro.activate()
	
	if Nitro.recharging then return end

	if Nitro.nitroType == "Normal" then

		if isVehicleNitroActivated(getPedOccupiedVehicle(localPlayer)) then return end

	end
	
	setVehicleNitroActivated(getPedOccupiedVehicle(localPlayer), not Nitro.active)
	
	Nitro.active = not Nitro.active
	
end



function Nitro.updateNitroLevel()
	
	Nitro.nitroLevel = 1
	
end
addEvent("updateClientNitro", true)


function Nitro.restoreNitro()
	
	if not getPedOccupiedVehicle(localPlayer) then return end
	
	Nitro.nitroLevel = getVehicleNitroLevel(getPedOccupiedVehicle(localPlayer)) or 0

end
addEventHandler("onClientVehicleEnter", root, Nitro.restoreNitro)


function Nitro.render()
	
	if not getPedOccupiedVehicle(localPlayer) then return end

	if not getVehicleNitroLevel(getPedOccupiedVehicle(localPlayer)) then return end
	
	local currentNitroLevel = getVehicleNitroLevel(getPedOccupiedVehicle(localPlayer))
	
	if math.round(currentNitroLevel, 2, "normal") == 0 then
	
		Nitro.recharging = true
		Nitro.active = false
		
	elseif math.round(currentNitroLevel, 2, "normal") == 1 then
		
		Nitro.recharging = false
		Nitro.nitroLevel = getVehicleNitroLevel(getPedOccupiedVehicle(localPlayer))
		
	end
	
	if not Nitro.active then 
	
		if Nitro.recharging then 
		
			setVehicleNitroLevel(getPedOccupiedVehicle(localPlayer), getVehicleNitroLevel(getPedOccupiedVehicle(localPlayer)))
		
		else
	
			setVehicleNitroLevel(getPedOccupiedVehicle(localPlayer), Nitro.nitroLevel)
		
		end
		
		return 
	
	end

	if Nitro.nitroLevel ~= getVehicleNitroLevel(getPedOccupiedVehicle(localPlayer)) then
		
		if Nitro.unlimited then
		
			setVehicleNitroLevel(getPedOccupiedVehicle(localPlayer), 0.99)
	
		end
		
		Nitro.nitroLevel = getVehicleNitroLevel(getPedOccupiedVehicle(localPlayer))
		
	end

end


function Nitro.reset()

	removeEventHandler("onClientRender", root, Nitro.render)
	removeEventHandler("updateClientNitro", root, Nitro.updateNitroLevel)
	unbindKey("vehicle_fire", "both", Nitro.activate)
	unbindKey("vehicle_secondary_fire", "both", Nitro.activate)
	removeCommandHandler("nitro", Nitro.command)
	Nitro.unlimited = false
	Nitro.active = false
	Nitro.recharging = false
	
end
addEvent("onClientArenaReset", true)
addEventHandler("onClientArenaReset", root, Nitro.reset)


function Nitro.toggle(map)

	if map.type ~= "Cross" and map.type ~= "Race" and map.type ~= "Linez" and map.type ~= "Shooter" and map.type ~= "Freeroam" then return end

	if map.type == "Cross" then
	
		Nitro.unlimited = true
		
	end
	
	if getPedOccupiedVehicle(localPlayer) then
	
		Nitro.nitroLevel = getVehicleNitroLevel(getPedOccupiedVehicle(localPlayer)) or 0
		
	else
	
		Nitro.nitroLevel = 0
		
	end
	
	bindKey("vehicle_fire", "both", Nitro.activate )
	bindKey("vehicle_secondary_fire", "both", Nitro.activate )
	addEventHandler("onClientRender", root, Nitro.render)	
	addEventHandler("updateClientNitro", root, Nitro.updateNitroLevel)
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


function Nitro.command(c, t)

	if t then t = t:lower() end

	if t ~= "nfs" and t ~= "hybrid" and t ~= "normal" then
	
		outputChatBox("Possible nitro modes are: '#00ff00normal#00ffff', '#00ff00hybrid#00ffff', '#00ff00nfs#00ffff'! Current: '#00ff00"..Nitro.nitroType.."#00ffff'", 0, 255, 255, true)
		return
		
	end
	
	Nitro.switch(t)
	
	outputChatBox("Nitro mode changed to '#00ff00"..t.."#00ffff'!", 0, 255, 255, true)

end


function Nitro.switch(t)

	if t then t = t:lower() end

	if t == "nfs" then
	
		while getKeyBoundToFunction(Nitro.activate) do
	
			unbindKey(getKeyBoundToFunction(Nitro.activate), "both", Nitro.activate)
	
		end
	
		bindKey("vehicle_fire", "both", Nitro.activate )
		bindKey("vehicle_secondary_fire", "both", Nitro.activate )
		setVehicleNitroActivated(getPedOccupiedVehicle(localPlayer), false)
		Nitro.active = false
		Nitro.nitroType = "Nfs"
		Nitro.recharging = true
		Nitro.saveSettings()
		
	elseif t == "hybrid" then
	
		while getKeyBoundToFunction(Nitro.activate) do
	
			unbindKey(getKeyBoundToFunction(Nitro.activate), "both", Nitro.activate)
	
		end
	
		bindKey("vehicle_fire", "down", Nitro.activate )
		bindKey("vehicle_secondary_fire", "down", Nitro.activate )
		setVehicleNitroActivated(getPedOccupiedVehicle(localPlayer), false)
		Nitro.active = false
		Nitro.nitroType = "Hybrid"
		Nitro.recharging = true
		Nitro.saveSettings()
		
	elseif t == "normal" then
	
		while getKeyBoundToFunction(Nitro.activate) do
	
			unbindKey(getKeyBoundToFunction(Nitro.activate), "both", Nitro.activate)
	
		end
	
		toggleControl("vehicle_secondary_fire", true)
		bindKey("vehicle_fire", "down", Nitro.activate )
		bindKey("vehicle_secondary_fire", "down", Nitro.activate )
		setVehicleNitroActivated(getPedOccupiedVehicle(localPlayer), false)
		Nitro.active = false
		Nitro.nitroType = "Normal"
		Nitro.recharging = true
		Nitro.saveSettings()

	end

end


function math.round(number, decimals, method)

    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
	
end