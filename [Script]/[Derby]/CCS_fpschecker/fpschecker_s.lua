FPSChecker = {}
FPSChecker.checkFrequency = 10000
FPSChecker.minFPS = 25
FPSChecker.strikeListFPS = {}
FPSChecker.checkTimers = {}

function FPSChecker.create()
	
	if not getElementData(source, "fpschecker") then return end

	FPSChecker.checkTimers[source] = setTimer(FPSChecker.check, FPSChecker.checkFrequency, 0, source)
	
	outputServerLog(getElementID(source)..": Creating FPS Checker")
	
	for _,p in ipairs(exports["CCS"]:export_getPlayersInArena(source)) do
	
		FPSChecker.strikeListFPS[p] = false
	
	end
	
end
addEvent("onMapStart", true)
addEventHandler("onMapStart", root, FPSChecker.create)


function FPSChecker.destroy()
	
	if isTimer(FPSChecker.checkTimers[source]) then killTimer(FPSChecker.checkTimers[source]) end	
	
	outputServerLog(getElementID(source)..": Destroying FPS Checker")
	
end
addEvent("onArenaReset", true)
addEventHandler("onArenaReset", root, FPSChecker.destroy)


function FPSChecker.check(arenaElement)

	if not getElementData(arenaElement, "fpschecker") then return end

	for i, p in pairs(exports["CCS"]:export_getPlayersInArena(arenaElement)) do
	
		if getElementData(p, "fps") and getElementData(p, "fps") < FPSChecker.minFPS then
		
			if not FPSChecker.strikeListFPS[p] then
			
				if getPedOccupiedVehicle(p) then
				
					outputChatBox("Your FPS is too low.", p, 255, 0, 125)
					setElementData(p, "fpswarning", true)
				
				end
				
			else
			
				if getPedOccupiedVehicle(p) then
			
					setElementHealth(p, 0)
					exports["CCS"]:export_outputArenaChat(arenaElement, "#ffff00FPS Check: "..getPlayerName(p):gsub('#%x%x%x%x%x%x', '').." destroyed!")
					setElementData(p, "fpswarning", false)
				
				end
				
			end
			
		end
		
					
	end

end
