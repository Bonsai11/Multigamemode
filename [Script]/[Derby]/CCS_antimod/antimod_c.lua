Antimod = {}
Antimod.replacedModels = {}
Antimod.replacedTextures = {}

function Antimod.modInfo(modList)

	for i, mod in pairs(modList) do
		
		if fileExists("models/"..mod.txd) then
		
			local txd = engineLoadTXD("models/"..mod.txd)
			
			if txd and engineImportTXD(txd, mod.id) then
			
				triggerServerEvent("onPlayerUpdateModState", localPlayer, "models/"..mod.txd, false)
			
			end
			
			table.insert(Antimod.replacedTextures, {txd = txd, name = "models/"..mod.txd})
		
		end
		
		if fileExists("models/"..mod.dff) then
		
			local dff = engineLoadDFF("models/"..mod.dff) 
			
			if dff and engineReplaceModel(dff, mod.id) then
			
				triggerServerEvent("onPlayerUpdateModState", localPlayer, "models/"..mod.dff, false)
			
			end
			
			table.insert(Antimod.replacedModels, {id = mod.id, name = "models/"..mod.dff})
			
		end
	
	end

end
addEvent("onClientPlayerModInfo", true)
addEventHandler("onClientPlayerModInfo", root, Antimod.modInfo)


function Antimod.restore()

	for i, mod in pairs(Antimod.replacedModels) do
	
		engineRestoreModel(mod.id)
		triggerServerEvent("onPlayerUpdateModState", localPlayer, mod.name, true)
		
	end	
	
	Antimod.replacedModels = {}
	
	for i, mod in pairs(Antimod.replacedTextures) do
	
		if isElement(mod.txd) then destroyElement(mod.txd) end
		triggerServerEvent("onPlayerUpdateModState", localPlayer, mod.name, true)
	
	end	
	
	Antimod.replacedTextures = {}
	
end
addEvent("onClientPlayerLeaveArena", true)
addEvent("onClientPlayerModRestore", true)
addEventHandler("onClientPlayerLeaveArena", localPlayer, Antimod.restore)
addEventHandler("onClientPlayerModRestore", root, Antimod.restore)