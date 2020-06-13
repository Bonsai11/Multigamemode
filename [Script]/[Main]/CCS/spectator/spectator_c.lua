Spectator = {}
Spectator.startTimer = nil
Spectator.active = false
Spectator.target = nil
bindKey("b", "down", "spectate")

function Spectator.reset()

	exports["CCS_freecam"]:setFreecamDisabled()
	Spectator.stop()

end
addEvent("onClientArenaReset", true)
addEventHandler("onClientArenaReset", root, Spectator.reset)


function Spectator.toggle()
	
	if source ~= localPlayer then

		Spectator.dropCamera(source, 1000)
		
	end

end
addEventHandler("onClientPlayerWasted", root, Spectator.toggle)


function Spectator.start(instant)

	if not instant then
	
		setCameraMatrix(getCameraMatrix())
		
		Spectator.startTimer = setTimer(Spectator.start, 3000, 1, true)

		return
		
	end
	
	if Spectator.active then return end

	local arenaElement = getElementParent(localPlayer)
	
	Spectator.setTarget(Spectator.findNewTarget(1))
	
	bindKey('arrow_l', 'down', Spectator.previous)
	bindKey('arrow_r', 'down', Spectator.next)
	
	if not getElementData(localPlayer, "racestate") then 

		setElementData(localPlayer, "state", "Spectating")
		
	end

	Spectator.setTarget(Spectator.target)
    Spectator.validateTarget(Spectator.target)
	Spectator.tickTimer = setTimer(Spectator.tick, 500, 0)	
	
end
addEvent("onClientRequestSpectatorMode", true)
addEventHandler("onClientRequestSpectatorMode", root, Spectator.start)


function Spectator.stop()

	Spectator.cancelDropCamera()
	if isTimer(Spectator.tickTimer) then killTimer(Spectator.tickTimer) end
	if isTimer(Spectator.startTimer) then killTimer(Spectator.startTimer) end
	unbindKey('arrow_l', 'down', Spectator.previous)
	unbindKey('arrow_r', 'down', Spectator.next)

	setCameraTarget(localPlayer)
	Spectator.target = nil
	Spectator.active = false

end
addEvent("onClientShowPodium", true)
addEvent("onClientPlayerRespawn", true)
addEventHandler("onClientShowPodium", root, Spectator.stop)
addEventHandler("onClientPlayerRespawn", root, Spectator.stop)


function Spectator.previous()

	Spectator.setTarget(Spectator.findNewTarget(-1))
	
end


function Spectator.next()

	Spectator.setTarget(Spectator.findNewTarget(1))
	
end


function Spectator.isValidTarget(player)

	if not player then
	
		return true
		
	end

	if player == localPlayer or getElementData(player, "state") ~= "Alive" then return false end

	return true
	
end


function Spectator.findNewTarget(dir)

	local arenaElement = getElementParent(localPlayer)

	local specTargets = {}
	
	local position
	
	for i, p in ipairs(getAlivePlayersInArena(arenaElement)) do
	
		if getElementType(p) == "player" then
		
			table.insert(specTargets, p)
			
		end
		
		if p == Spectator.target then
		
			position = i
			
		end
		
	end

	if not position then
	
		position = 1
		
	end
	
	for i=1, #specTargets do
	
		position = ((position + dir - 1) % #specTargets ) + 1
		
		if Spectator.isValidTarget(specTargets[position]) then
		
			return specTargets[position]
			
		end
		
	end
	
	return nil

end


function Spectator.validateTarget(player)

	if Spectator.active and player == Spectator.target then
	
		if not Spectator.isValidTarget(player) then
		
			Spectator.previous()
			
		end
		
	end
	
end


function Spectator.dropCamera(player, time)

	if Spectator.active and player == Spectator.target then
	
		if not Spectator.hasDroppedCamera() then
		
			setCameraMatrix(getCameraMatrix())
			
			Spectator.target = nil
			
			Spectator.droppedCameraTimer = setTimer(Spectator.cancelDropCamera, time, 1, player)
			
		end
		
	end
	
end


function Spectator.hasDroppedCamera()

	return isTimer(Spectator.droppedCameraTimer)
	
end


function Spectator.cancelDropCamera()

	if Spectator.hasDroppedCamera() then
	
		killTimer(Spectator.droppedCameraTimer)
		
		Spectator.tick()
		
	end
	
end


function Spectator.setTarget( player )

	if Spectator.hasDroppedCamera() then
		return
	end
	
	Spectator.active = true
	Spectator.target = player
	
	if Spectator.target then
	
		if Spectator.getCameraTargetPlayer() ~= Spectator.target then
			setCameraTarget(Spectator.target)
		end

	else
		setCameraTarget( localPlayer )
		setCameraMatrix( -1360, 1618, 100, -1450, 1200, 100)
	end

end


function Spectator.tick()

	if exports["CCS_freecam"]:isFreecamEnabled() then return end

	if Spectator.target and Spectator.getCameraTargetPlayer() and Spectator.getCameraTargetPlayer() ~= Spectator.target then
		if Spectator.isValidTarget(Spectator.target) then
			setCameraTarget(Spectator.target)
			return
		end
	end
	
	if not Spectator.target or ( Spectator.getCameraTargetPlayer() and Spectator.getCameraTargetPlayer() ~= Spectator.target ) or not Spectator.isValidTarget(Spectator.target) then
		Spectator.previous()
	end
	
end


function Spectator.getCameraTargetPlayer()

	local element = getCameraTarget()
	
	if element and getElementType(element) == "vehicle" then
	
		element = getVehicleController(element)
		
	end
	
	return element
	
end


function Spectator.adminSpectate()

	if not Spectator.active then
	
		Spectator.start()
		
	else
	
		Spectator.stop()
		
	end

end
addEvent("onAdminSpectate", true)
addEventHandler("onAdminSpectate", root, Spectator.adminSpectate)


function Spectator.freecam()

	if not exports["CCS_freecam"]:isFreecamEnabled() then 
	
		local x, y, z = getCameraMatrix()
	
		exports["CCS_freecam"]:setFreecamEnabled(x, y, z)
	
	else
	
		exports["CCS_freecam"]:setFreecamDisabled()
	
		if getPedOccupiedVehicle(localPlayer) then
		
			setCameraTarget(localPlayer)
		
		end
		
	end

end
addCommandHandler("freecam", Spectator.freecam)