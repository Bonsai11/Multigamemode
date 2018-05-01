AFKChecker = {}
AFKChecker.checkTimers = {}
AFKChecker.warningList = {}
AFKChecker.strikeList = {}
AFKChecker.strikesForKick = 2
AFKChecker.afkCheckTime = 10000

function AFKChecker.create()

	if not getElementData(source, "Detector") then return end

	AFKChecker.checkTimers[source] = setTimer(AFKChecker.check, AFKChecker.afkCheckTime, 0, source)
	
	outputServerLog(getElementID(source)..": Creating AFK Detector")

end
addEvent("onMapStart", true)
addEventHandler("onMapStart", root, AFKChecker.create)


function AFKChecker.destroy()
	
	for i, p in pairs(exports["CCS"]:export_getPlayersInArena(source)) do
	
		AFKChecker.warningList[p] = false
	
	end
	
	if isTimer(AFKChecker.checkTimers[source]) then killTimer(AFKChecker.checkTimers[source]) end	
	outputServerLog(getElementID(source)..": Destroying AFK Detector")
	
end
addEvent("onArenaReset", true)
addEventHandler("onArenaReset", root, AFKChecker.destroy)


function AFKChecker.check(arenaElement)

	if not getElementData(arenaElement, "Detector") then return end

	outputServerLog(getElementID(arenaElement)..": AFK Detector Check")

	for _, p in ipairs(exports["CCS"]:export_getPlayersInArena(arenaElement)) do
		
		--Warning
		if getElementData(p, "state") == "Alive" and not getElementData(p, "adminSpectate") and not getElementData(p, "raceSpectate") then
		
			if getPlayerIdleTime(p) and getPlayerIdleTime(p) > AFKChecker.afkCheckTime-1000 then
		
				if AFKChecker.warningList[p] then
					
					if getPedOccupiedVehicle(p) then
						
						if not AFKChecker.strikeList[p] then
						
							AFKChecker.strikeList[p] = 1
					
						else
						
							AFKChecker.strikeList[p] = AFKChecker.strikeList[p] + 1
							
						end
					
						if AFKChecker.strikeList[p] < AFKChecker.strikesForKick then
					
							setElementHealth(p, 0)
							exports["CCS"]:export_outputArenaChat(arenaElement, "#ffff00AFK Detector: "..getPlayerName(p):gsub('#%x%x%x%x%x%x', '').." destroyed!")
					
						else
						
							exports["CCS"]:export_outputArenaChat(arenaElement, "#ffff00AFK Detector: "..getPlayerName(p):gsub('#%x%x%x%x%x%x', '').." kicked!")
							triggerEvent("onLobbyKick", arenaElement, p, "AFK", "AFK Checker!")
							AFKChecker.strikeList[p] = 0
						
						end
					
					end
				
				else
				
					if getPedOccupiedVehicle(p) then
					
						outputChatBox("Move or you will be destroyed!", p, 255, 0, 125)
				
					end	
					
				end
				
				if not AFKChecker.warningList[p] then
				
					AFKChecker.warningList[p] = true
					
				end
			
			else
			
				AFKChecker.warningList[p] = false
				AFKChecker.strikeList[p] = 0
				
			end

		end
		
	end
	
end

