Megajump = {}
Megajump.active = false
Megajump.vehicles = {509, 481, 510}
Megajump.lastTick = 0
Megajump.minDelay = 250

function Megajump.check(button, pressOrRelease)
	
	if pressOrRelease then return end

	local found = false
	
	for key, state in pairs(getBoundKeys("vehicle_secondary_fire")) do
			
		if key == button then
		
			found = true
			break
			
		end
		
	end	
	
	if not found then return end
	
	local vehicle = getPedOccupiedVehicle(localPlayer)
	
	if not vehicle then return end
	
	local found = false
	
	for i, model in pairs(Megajump.vehicles) do
		
		if model == getElementModel(vehicle) then
		
			found = true
			break
			
		end
	
	end
	
	if not found then return end
	
	if getTickCount() - Megajump.lastTick < Megajump.minDelay then 
	
		cancelEvent()
		return 
		
	end

	Megajump.lastTick = getTickCount()
	
end
addEventHandler("onClientKey", root, Megajump.check)
