Downloader = {}
Downloader.progress = nil


function Downloader.receive(fileData, session)
	
	local arenaElement = getElementParent(localPlayer)
	
	if session ~= getElementData(arenaElement, "session") then return end
	
	for i, file in ipairs(fileData.data) do
	
		if file.data then
		
			local newFile = fileCreate(":ccs_wrapper/"..file.path)
			fileWrite(newFile, file.data)
			fileFlush(newFile)
			fileClose(newFile)
			
		end
		
	end
	
	triggerEvent("onClientDownloadFinished", getElementParent(localPlayer), fileData, session)

end
addEvent("onClientDownload", true)
addEventHandler("onClientDownload", root, Downloader.receive)


function Downloader.start()
	
	Downloader.progress = DownloadProgress.new()

end
addEvent("onClientStartDownload", true)
addEventHandler("onClientStartDownload", root, Downloader.start)


function Downloader.reset()

	if Downloader.progress then 
	
		Downloader.progress:destroy()
		Downloader.progress = nil
		
	end

end
addEvent("onClientDownloadFinished", true)
addEventHandler("onClientDownloadFinished", root, Downloader.reset)
addEventHandler("onClientArenaReset", root, Downloader.reset)


function Downloader.checkFiles(files, session)

	local arenaElement = getElementParent(localPlayer)
	
	if session ~= getElementData(arenaElement, "session") then return end

	local missingFilesPackage = {}
	
	for i, file in ipairs(files) do
	
		if not fileExists(":ccs_wrapper/"..file.path) then
	
			table.insert(missingFilesPackage, file.path)
	
		else
		
			local clientfile = fileOpen(":ccs_wrapper/"..file.path, true)
			local content = fileRead(clientfile, fileGetSize(clientfile))
			fileClose(clientfile)
			
			if md5(content) ~= file.hash then
	
				table.insert(missingFilesPackage, file.path)	
				
			end
			
		end
	
	end
		
	triggerServerEvent("onDownloadRequestFiles", localPlayer, missingFilesPackage, session)


end
addEvent("onClientDownloadCheckFiles", true)
addEventHandler("onClientDownloadCheckFiles", root, Downloader.checkFiles)