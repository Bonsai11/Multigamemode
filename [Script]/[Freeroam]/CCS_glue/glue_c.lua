Glue = {}

function Glue.main()

	if getElementData(source, "gamemode") ~= "Freeroam" then return end

	bindKey("x", "down", Glue.use)
	addCommandHandler("glue", Glue.use)

end
addEvent("onClientPlayerReady", true)
addEventHandler("onClientPlayerReady", root, Glue.main)


function Glue.reset()

	unbindKey("x", "down", Glue.stop)
	removeCommandHandler("unglue", Glue.stop)
	addCommandHandler("glue", Glue.use)
	bindKey("x", "down", Glue.use)

end
addEvent("onClientArenaReset", true)
addEventHandler("onClientArenaReset", root, Glue.reset)


function Glue.use()

	if getPedOccupiedVehicle(localPlayer) then return end

	local vehicle = getPedContactElement(localPlayer)
		
	if not vehicle or getElementType(vehicle) ~= "vehicle" then return end
	
	local px, py, pz = getElementPosition(localPlayer)
	
	local vx, vy, vz = getElementPosition(vehicle)
	
	local sx = px - vx
	local sy = py - vy
	local sz = pz - vz

	local rotpX, rotpY, rotpZ = getElementRotation(localPlayer)

	local rotvX, rotvY, rotvZ = getElementRotation(vehicle)
	
	local t = math.rad(rotvX)
	local p = math.rad(rotvY)
	local f = math.rad(rotvZ)
	
	local ct = math.cos(t)
	local st = math.sin(t)
	local cp = math.cos(p)
	local sp = math.sin(p)
	local cf = math.cos(f)
	local sf = math.sin(f)
	
	local z = ct*cp*sz + (sf*st*cp + cf*sp)*sx + (-cf*st*cp + sf*sp)*sy
	local x = -ct*sp*sz + (-sf*st*sp + cf*cp)*sx + (cf*st*sp + sf*cp)*sy
	local y = st*sz - sf*ct*sx + cf*ct*sy

	triggerServerEvent("onPlayerGlue", localPlayer, vehicle, x, y, z, rotpX, rotpY, rotpZ)
	
	unbindKey("x", "down", Glue.use)
	
	addCommandHandler("unglue", Glue.stop)
	
	bindKey("x", "down", Glue.stop)

end


function Glue.stop()
	
	triggerServerEvent("onPlayerUnglue", localPlayer)
	Glue.reset()
	
end

