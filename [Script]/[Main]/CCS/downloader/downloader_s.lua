Downloader = {}
Downloader.filePackage = {}
	
function Downloader.create(element, filePackage)
	
	setElementData(element, "session", getTickCount())
	
	Downloader.filePackage[element] = filePackage
	
end

function Downloader.start(player)
	
	--Arena has nothing that needs to be downloaded, spawn handled different way
	if not Downloader.filePackage[source] then return end

	setElementData(player, "state", "Download")
	triggerEvent("onDownloadCancel", player)
	triggerClientEvent(player, "onClientDownloadCheckFiles", source, Downloader.filePackage[source].fileHash, getElementData(source, "session"))

end
addEvent("onStartDownload", true)
addEventHandler("onStartDownload", root, Downloader.start)	


function Downloader.finished(session)
	
	local arenaElement = getElementParent(source)
	local arenaID = getElementID(arenaElement)
	
	if session ~= getElementData(arenaElement, "session") then 
	
		outputServerLog(arenaID..": Session Mismatch for Player: "..getPlayerName(source))
		return 
		
	end
	
	triggerEvent("onPlayerRequestSpawn", source)

end
addEvent("onPlayerDownloadFinish", true)
addEventHandler("onPlayerDownloadFinish", root, Downloader.finished)


function Downloader.destroy()
	
	Downloader.filePackage[source] = nil
	
end	
addEvent("onArenaReset", true)
addEventHandler("onArenaReset", root, Downloader.destroy)	


function Downloader.createFilePackage(missingFiles, session)
	
	local element = getElementParent(source)
	local elementID = getElementID(element)
	
	if session ~= getElementData(element, "session") then 
	
		outputServerLog(elementID..": Session Mismatch for Player: "..getPlayerName(source))
		return 
		
	end
	
	local filePackage = table.copy(Downloader.filePackage[element])
	filePackage.fileData = {}
	filePackage.fileData.data = {}
	filePackage.fileData.resourceName = filePackage.mapData.resourceName
	
	for i, file in ipairs(Downloader.filePackage[element].fileData.data) do
		
		while true do
		
			if string.find(file.path, ".mp3", 1, true) and getElementData(source, "setting:maps_music") == 0 then break end
		
			if string.find(file.path, ".ogg", 1, true) and getElementData(source, "setting:maps_music") == 0 then break end
		
			if string.find(file.path, ".txd", 1, true) and getElementData(source, "setting:maps_textures") == 0 then break end
		
			if string.find(file.path, ".dff", 1, true) and getElementData(source, "setting:maps_textures") == 0 then break end
		
			if table.contains(missingFiles, file.path) then
		
				table.insert(filePackage.fileData.data, {path = file.path, data = file.data})
			
			else
			
				table.insert(filePackage.fileData.data, {path = file.path, data = nil})
			
			end
		
			break
			
		end
	
	end
		
	triggerEvent("onDownloadCancel", source)
	triggerLatentClientEvent(source, "onClientLoadMap", 1000000, false, element, filePackage.mapData, session)	
	triggerClientEvent(source, "onClientStartDownload", element)
	triggerLatentClientEvent(source, "onClientDownload", 1000000, false, element, filePackage.fileData, session)
	
end
addEvent("onDownloadRequestFiles", true)
addEventHandler("onDownloadRequestFiles", root, Downloader.createFilePackage)	


function Downloader.checkProgress()

	local handles = getLatentEventHandles(client)
	
	if #handles == 0 then 
	
		triggerClientEvent(client, "onClientDownloadProgress", root, 100)
		return 
		
	end

	local status = getLatentEventStatus(client, handles[1])

	triggerClientEvent(client, "onClientDownloadProgress", root, status.percentComplete, status.totalSize)

end
addEvent("onDownloadProgress", true)
addEventHandler("onDownloadProgress", root, Downloader.checkProgress)


function Downloader.cancel()

	for i, handle in pairs(getLatentEventHandles(source)) do
	
		cancelLatentEvent(source, handle)
		
	end

end
addEvent("onDownloadCancel", true)
addEventHandler("onDownloadCancel", root, Downloader.cancel)
