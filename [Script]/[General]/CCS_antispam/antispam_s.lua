Antispam = {}
Antispam.checks = {}
Antispam.excludeList = {"togglelobby", "Toggle"}

function Antispam.filter(command)
	
	--Exclude certain commands
	for i, excluded in pairs(Antispam.excludeList) do
		
		if command == excluded then return end
		
	end
	
	local tick = getTickCount()
	
	if not Antispam.checks[source] then
	
		Antispam.checks[source] = {}
		Antispam.checks[source].tick = 0
		Antispam.checks[source].strikes = 0
		
	end
	
	if tick - Antispam.checks[source].tick > 5000 then
	
		Antispam.checks[source].tick = tick
		Antispam.checks[source].strikes = 0
		
	else
	
		Antispam.checks[source].strikes = Antispam.checks[source].strikes + 1
		
		if Antispam.checks[source].strikes > 8 then
		
			local name = getPlayerName(source):gsub('#%x%x%x%x%x%x', '')
			Antispam.checks[source] = nil
			exports["CCS"]:export_outputArenaChat(getElementParent(source), "#ffff00Command Flood: "..name.." kicked!")
			kickPlayer(source, "Command Flood")
			cancelEvent()
			
		end
	end
	
end
addEventHandler("onPlayerCommand", root, Antispam.filter)
