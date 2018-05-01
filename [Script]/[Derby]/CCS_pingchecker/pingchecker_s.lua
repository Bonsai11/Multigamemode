PingChecker = {}
PingChecker.checkFrequency = 10000
PingChecker.maxPing = 250
PingChecker.strikeListPing = {}
PingChecker.checkTimers = {}

function PingChecker.create()
	
	if not getElementData(source, "pingchecker") then return end

	PingChecker.checkTimers[source] = setTimer(PingChecker.check, PingChecker.checkFrequency, 0, source)
	
	outputServerLog(getElementID(source)..": Creating Ping Checker")
	
	for _,p in ipairs(exports["CCS"]:export_getPlayersInArena(source)) do
	
		PingChecker.strikeListPing[p] = false
	
	end
	
end
addEvent("onMapStart", true)
addEventHandler("onMapStart", root, PingChecker.create)


function PingChecker.destroy()
	
	if isTimer(PingChecker.checkTimers[source]) then killTimer(PingChecker.checkTimers[source]) end	
	
	outputServerLog(getElementID(source)..": Destroying Ping Checker")
	
end
addEvent("onArenaReset", true)
addEventHandler("onArenaReset", root, PingChecker.destroy)


function PingChecker.check(arenaElement)

	if not getElementData(arenaElement, "pingchecker") then return end

	for i, p in pairs(exports["CCS"]:export_getPlayersInArena(arenaElement)) do
	
		if getPlayerPing(p) and getPlayerPing(p) > PingChecker.maxPing then
		
			if not PingChecker.strikeListPing[p] then
			
				if getPedOccupiedVehicle(p) then
				
					outputChatBox("Your Ping is too high.", p, 255, 0, 125)
					PingChecker.strikeListPing[p] = true
				
				end
				
			else
			
				if getPedOccupiedVehicle(p) then
				
					setElementHealth(p, 0)
					exports["CCS"]:export_outputArenaChat(arenaElement, "#ffff00Ping Check: "..getPlayerName(p):gsub('#%x%x%x%x%x%x', '').." destroyed!")
					PingChecker.strikeListPing[p] = false
				
				end
				
			end
			
		end
		
	end

end
