Logger = {}
Logger.logFile = nil
Logger.logDate = nil

function Logger.start()

	Logger.createLogFile()

end
addEventHandler("onResourceStart", resourceRoot, Logger.start)


function Logger.createLogFile()

	if Logger.logFile then
	
		fileClose(Logger.logFile)
		
	end

	Logger.logDate = Logger.getFileDate()

	if not fileExists("logs/"..Logger.logDate..".log") then
	
		Logger.logFile = fileCreate("logs/"..Logger.logDate..".log")
		fileClose(Logger.logFile)
		
	end

	Logger.logFile = fileOpen("logs/"..Logger.logDate..".log")
	fileSetPos(Logger.logFile, fileGetSize(Logger.logFile))

end


function Logger.log(msg)

	if not Logger.logFile then return end
	
	if Logger.logDate ~= Logger.getFileDate() then
	
		Logger.createLogFile()
		
	end
	
	fileWrite(Logger.logFile, Logger.getTimeStamp().." "..tostring(msg:gsub("#%x%x%x%x%x%x", "")).."\n")
	fileFlush(Logger.logFile)

end
addEvent("onServerChatMessage")
addEventHandler("onServerChatMessage", root, Logger.log)


function Logger.getTimeStamp()

	local timeT = getRealTime()

	return string.format("[%02d:%02d:%02d]", timeT.hour, timeT.minute, timeT.second)

end


function Logger.getFileDate()

	local timeT = getRealTime()
	
	return string.format("%04d-%02d-%02d", timeT.year + 1900, timeT.month + 1, timeT.monthday)
	
end