Locator = {}
Locator.data = {}

function Locator.start()

	for i, p in ipairs(getElementsByType("player")) do

		Locator.trace(p)
		
	end

end
addEventHandler("onResourceStart", resourceRoot, Locator.start)


function Locator.main()

	Locator.trace(source)

end
addEvent("onPlayerJoin", true)
addEventHandler("onPlayerJoin", root, Locator.main)


function Locator.main()

	local playerName = getPlayerName(source)

	if not Locator.data[source] then return end
	
	Locator.output(playerName, Locator.data[source].city, Locator.data[source].country, Locator.data[source].region)

end
addEvent("onPlayerJoinArena", true)
addEventHandler("onPlayerJoinArena", root, Locator.main)


function Locator.command(p, c, player)

	local arenaElement = getElementParent(p)

	if player then 
	
		player = exports["CCS"]:export_findPlayerAll(player)
	
	else
	
		player = p
		
	end

	if not player then return end

	local playerName = getPlayerName(player)
	
	Locator.output(playerName, Locator.data[player].city, Locator.data[player].country, Locator.data[player].region, p)

end
addCommandHandler("where", Locator.command)


function Locator.quit()

	if Locator.data[source] then
	
		Locator.data[source] = nil
		
	end

end
addEventHandler("onPlayerQuit", root, Locator.quit)


function Locator.trace(player)

	if not isElement(player) then return end

	local playerIP = getPlayerIP(player)
	
	if not playerIP then return end

	fetchRemote("http://ip-api.com/json/"..playerIP, Locator.callback, "", false, getPlayerName(player))

end


function Locator.callback(responseData, errno, playerName)
   
    local player = getPlayerFromName(playerName)
   
    if not player then return end
   
	if errno == 0 then
      
		local data = fromJSON(responseData)
		
		if data["status"] == "Fail" then
	  
			Locator.error()
	  
		else
		
			Locator.data[player] = {city = data["city"], country = data["country"], region = data["regionName"]}
			setElementData(getPlayerFromName(playerName), "Country", data["countryCode"])
	  
		end
	  
	else
	
		Locator.error()
	  
	end
	
	
end


function Locator.error()

	outputChatBox("Locator unavailable - Try again later.", root, 255, 255, 0)

end


function Locator.output(playerName, playerCity, playerCountry, playerRegion, p)

	if not playerCity then 
	
		playerCity = ""
		
	end
	
	if not playerCountry then
	
		playerCountry = ""
		
	end
	
	if not playerRegion then
	
		playerRegion = ""
		
	end

	local arenaElement = getElementParent(getPlayerFromName(playerName))

		
	local fromPlayer
	
	if p then
	
		fromPlayer = "<"..getPlayerName(p):gsub('#%x%x%x%x%x%x', '').."> "
	
	else
	
		fromPlayer = ""
		
	end
	
	exports["CCS"]:export_outputArenaChat(arenaElement, "#ffff00"..fromPlayer..playerName:gsub("#%x%x%x%x%x%x", "").." came here from "..playerCity..", "..playerCountry.."  ("..playerRegion..")")

end
