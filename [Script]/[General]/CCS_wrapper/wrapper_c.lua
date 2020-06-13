Wrapper = {}
Wrapper.lists = {}
Wrapper.lists.objects = {}
Wrapper.lists.timers = {}
Wrapper.lists.events = {}
Wrapper.lists.txd = {}
Wrapper.lists.shaders = {}
Wrapper.lists.marker = {}
Wrapper.lists.xmlFiles = {}
Wrapper.lists.models = {}
Wrapper.lists.sounds = {}
Wrapper.lists.peds = {}
Wrapper.lists.commands = {}
Wrapper.lists.binds = {}
Wrapper.lists.vehicle = {}
Wrapper.lists.shapes = {}
Wrapper.lists.collision = {}
Wrapper.lists.water = {}
local _createObject = createObject 
local _setTimer = setTimer
local _addEventHandler = addEventHandler
local _engineLoadTXD = engineLoadTXD
local _engineImportTXD = engineImportTXD
local _createMarker = createMarker
local _xmlLoadFile = xmlLoadFile
local _engineSetModelLODDistance = engineSetModelLODDistance
local _engineReplaceCOL = engineReplaceCOL
local _engineLoadCOL = engineLoadCOL
local _engineReplaceModel = engineReplaceModel
local _engineLoadDFF = engineLoadDFF
local _playSound = playSound
local _addCommandHandler = addCommandHandler
local _bindKey = bindKey
local _createPed = createPed
local _createVehicle = createVehicle
local _dxCreateTexture = dxCreateTexture
local _dxCreateScreenSource = dxCreateScreenSource
local _fileDelete = fileDelete
local _dxCreateShader = dxCreateShader
local _setElementData = setElementData
local _setElementDimension = setElementDimension
local _createColSphere = createColSphere
local _setCloudsEnabled = setCloudsEnabled
local _setWeather = setWeather
local _createWater = createWater

outputChatBox = function() end

triggerServerEvent = function() end

setElementDimension = function() end

setCloudsEnabled = function() end

setElementData = function(theElement, key, value, synchronize)  

	_setElementData(theElement, key, value, false)

end

dxCreateShader = function(path, priority, maxDistance, layered, elementTypes)

	local shader = _dxCreateShader(Wrapper.mapname.."/"..path, priority or 0, maxDistance or 0, layered or false, elementTypes or "world,vehicle,object,other") 
	table.insert(Wrapper.lists.shaders, shader)
	return shader
	
end

fileDelete = function(path)

	local bool = _fileDelete(Wrapper.mapname.."/"..path)
	return bool

end


dxCreateScreenSource = function(x,y)

	local screen = _dxCreateScreenSource(x,y)
	table.insert(Wrapper.lists.txd, screen)
	return screen

end
	
	
dxCreateTexture = function(path)

	local file = _dxCreateTexture(Wrapper.mapname.."/"..path)
	table.insert(Wrapper.lists.txd, file)
	return file


end


setWeather = function(id)

	_setWeather(id)
	_setCloudsEnabled(false)

end


xmlLoadFile = function(path)

	local file = _xmlLoadFile(Wrapper.mapname.."/"..path)
	table.insert(Wrapper.lists.xmlFiles, file)
	return file
	
end
		
		
engineSetModelLODDistance = function(model,distance)

	_engineSetModelLODDistance(model,distance)
	return true
	
end


engineReplaceCOL = function(col, id)

	_engineReplaceCOL(col, id)
	table.insert(Wrapper.lists.collision, id)
	return true
	
end


engineLoadCOL = function(path)

	local col = _engineLoadCOL(Wrapper.mapname.."/"..path)
	table.insert(Wrapper.lists.models, col)
	return col
	
end


engineReplaceModel = function(dff, model)

	_engineReplaceModel(dff,model)
	table.insert(Wrapper.lists.models, model)
	return true
	
end


engineLoadDFF = function(path, model)

	local dff = _engineLoadDFF(Wrapper.mapname.."/"..path, model)
	table.insert(Wrapper.lists.models, model)
	return dff
	
end


--Textures
engineLoadTXD = function(path)

	local txd = _engineLoadTXD(Wrapper.mapname.."/"..path)
	table.insert(Wrapper.lists.txd, txd)
	return txd

end


engineImportTXD = function(...)

	_engineImportTXD(...)

end

--Marker
createMarker = function(...)
	
	local marker = _createMarker(...)
	_setElementDimension(marker, getElementDimension(localPlayer))
	table.insert(Wrapper.lists.marker, marker)
	return marker

end


createColSphere = function(x, y, z, size)
	
	local shape = _createColSphere(x, y, z, size)
	_setElementDimension(shape, getElementDimension(localPlayer))
	table.insert(Wrapper.lists.shapes, shape)
	return shape

end

--Objects
createObject = function(...) 

	local object = _createObject(...)
	_setElementDimension(object, getElementDimension(localPlayer) )
	table.insert(Wrapper.lists.objects, object)
	return object 
	
end
 
 
 --Timers
setTimer = function(...)
	
	local timer = _setTimer(...)
	table.insert(Wrapper.lists.timers, timer)
	return timer
 
 end
 
 
 --Handlers
addEventHandler = function(eventName, attachedTo, handlerFunction, getPropagated, priority)

	if eventName == "onClientResourceStart" then 
	
		table.insert(Wrapper.lists.timers, _setTimer(handlerFunction, 1000, 1)) 
		
		return false 
		
	end
	
    table.insert (Wrapper.lists.events, { eventName, attachedTo, handlerFunction } )
	
    return _addEventHandler ( eventName, attachedTo, handlerFunction, getPropagated, priority )
	
end


playSound = function(path, loop)
	
	if getElementData(localPlayer, "radio") then return end
	
	if getElementData(localPlayer, "setting:no_music") == 1 then return end

	local sound = _playSound(Wrapper.mapname.."/"..path, loop)
    table.insert (Wrapper.lists.sounds, sound )
	return sound
	
end
 
 

addCommandHandler = function (cmd, func)

	_addCommandHandler(cmd, func)
	table.insert (Wrapper.lists.commands, {cmd, funcs} )
	return true
	
end
 
 

bindKey = function (key,state,func)
	
	_bindKey(key,state,func)
	table.insert (Wrapper.lists.binds, {key, state, func} )
	return true
	
end



createPed = function (...)

	local ped = _createPed(...)
	_setElementDimension(ped, getElementDimension(localPlayer) )
	table.insert (Wrapper.lists.peds, ped)
	return ped
	
end
 

createVehicle = function(...)
	
	local vehicle = _createVehicle(...)
	_setElementDimension(vehicle, getElementDimension(localPlayer) )
	table.insert (Wrapper.lists.vehicle, vehicle)	
	return vehicle
	
end

--Water
createWater = function(...)
	
	local water = _createWater(...)
	_setElementDimension(water, getElementDimension(localPlayer))
	table.insert(Wrapper.lists.water, water)
	return water

end


function table.copy(tab, recursive)

    local ret = {}
	
    for key, value in pairs(tab) do

        if (type(value) == "table") and recursive then 
		
			ret[key] = table.copy(value)
			
        else 
		
			ret[key] = value 
		
		end
		
    end
	
    return ret
	
end


function Wrapper.createEnvironment()

	local env = table.copy(_G, true)

	setmetatable(env, {
	
		__index = function(_, index)
			return rawget(env, index)
		end,
		
		__newindex = function(_, index, value)
			rawset(env, index, value)
		end
		
	})

	setmetatable(_G, {

		__newindex = function(_, index, value)
			rawset(env, index, value)
		end
		
	})
	
	return env
	
end


function Wrapper.loadScript(fileData)

	Wrapper.mapname = fileData.resourceName
	
	local env = Wrapper.createEnvironment()
	
	for i, file in ipairs(fileData.data) do
	
		if string.find(file.path, ".lua", 1, true) then 
		
			local file = fileOpen(file.path)
			local content = fileRead(file, fileGetSize(file))
			fileClose(file)
			local loaded = loadstring(content)
			
			if loaded then
			
				setfenv(loaded, env)
				pcall(loaded)
			
			end
			
		end
		
	end

end
addEvent("onClientDownloadFinished", true)
_addEventHandler("onClientDownloadFinished", root, Wrapper.loadScript)

 
function Wrapper.unloadScript()

	local metatable = {

		__index = function(self, index)
			return rawget(_G, index)
		end,
	
		__newindex = function(_G, index, value)
			rawset(_G, index, value)
		end
	}

	setmetatable(_G, metatable)

	for i, object in pairs(Wrapper.lists.objects) do
		if isElement(object) then
			destroyElement(object)
		end
	end
  
	for i, timer in pairs(Wrapper.lists.timers) do
		if isTimer(timer) then
			killTimer(timer)
		end
	end
  
	for i, theEvent in pairs(Wrapper.lists.events) do
		removeEventHandler( theEvent[ 1 ], theEvent[ 2 ], theEvent[ 3 ] )
	end
	
	for i, txd in pairs(Wrapper.lists.txd) do
		if isElement(txd) then
			destroyElement(txd)
		end
	end
	
	for i, marker in pairs(Wrapper.lists.marker) do
		if isElement(marker) then
			destroyElement(marker)
		end
	end
	
	for i, model in pairs(Wrapper.lists.models) do
		engineRestoreModel(model)
	end
	
	for i, file in pairs(Wrapper.lists.xmlFiles) do
		xmlUnloadFile(file)
	end
	
	for i, sound in pairs(Wrapper.lists.sounds) do
		if sound and isElement(sound) then
			stopSound(sound)
		end
	end
	
	for i, bind in pairs(Wrapper.lists.binds) do
		unbindKey(bind[1],bind[2],bind[3])
	end
	
	for i, command in pairs(Wrapper.lists.commands) do
		removeCommandHandler(command[1],command[2])
	end
	
	for i, peds in pairs(Wrapper.lists.peds) do
		if isElement(peds) then
			destroyElement(peds)
		end
	end
	
	for i, vehicle in pairs(Wrapper.lists.vehicle) do
		if isElement(vehicle) then
			destroyElement(vehicle)
		end
	end
	
	for i, shader in pairs(Wrapper.lists.shaders) do
		if isElement(shader) then
			destroyElement(shader)
		end
	end
	
	for i, shape in pairs(Wrapper.lists.shapes) do
		if isElement(shape) then
			destroyElement(shape)
		end
	end
	
	for i, id in pairs(Wrapper.lists.collision) do
	
		engineRestoreCOL(id)
	
	end
	
	for i, water in pairs(Wrapper.lists.water) do
		if isElement(water) then
			destroyElement(water)
		end
	end	
	
	setWaterLevel(0)
	resetSkyGradient()
	resetWaterColor()
	resetWaterLevel()
	setWaveHeight(0)
	resetHeatHaze()
	resetWindVelocity()
	resetAmbientSounds()
	resetWorldSounds()
	resetRainLevel()
	resetSunSize()
	resetSunColor()
	resetFogDistance()
	resetFarClipDistance()
	setGravity(0.008)
	setGameSpeed(1)
	_setWeather(3)
	setWorldSpecialPropertyEnabled("hovercars", false)
	setWorldSpecialPropertyEnabled("aircars", false)
	setWorldSpecialPropertyEnabled("extrabunny", false)
	setWorldSpecialPropertyEnabled("extrajump", false)
	restoreAllWorldModels()
	_setCloudsEnabled(false)	
	Wrapper.lists.objects = {}
	Wrapper.lists.timers = {}
	Wrapper.lists.events = {}
	Wrapper.lists.txd = {}
	Wrapper.lists.marker = {}
	Wrapper.lists.xmlFiles = {}
	Wrapper.lists.models = {}
	Wrapper.lists.sounds = {}
	Wrapper.lists.data = {}
	Wrapper.lists.peds = {}
	Wrapper.lists.commands = {}
	Wrapper.lists.binds = {}
	Wrapper.lists.vehicle = {}	
	Wrapper.lists.shapes = {}	
	Wrapper.lists.shaders = {}	
	Wrapper.lists.collision = {}
	Wrapper.lists.water = {}	
	
end
addEvent("onClientArenaReset", true)
_addEventHandler("onClientArenaReset", root, Wrapper.unloadScript)


