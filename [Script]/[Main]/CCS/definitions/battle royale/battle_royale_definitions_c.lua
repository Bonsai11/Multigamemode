BattleRoyale = {}
BattleRoyale.x, BattleRoyale.y = guiGetScreenSize()
BattleRoyale.relX, BattleRoyale.relY = (BattleRoyale.x/800), (BattleRoyale.y/600)
BattleRoyale.wallTexture = dxCreateTexture("img/white.png")
BattleRoyale.moveStartTime = nil
BattleRoyale.circleSizes = {0.65, 0.35, 0.15, 0.05, 0}
BattleRoyale.radius = nil
BattleRoyale.startRadius = nil
BattleRoyale.origin = {}
BattleRoyale.roundStartOrigion = {}
BattleRoyale.roundTargetOrigin = {}
BattleRoyale.targetOrigin = {}
BattleRoyale.wallColor = tocolor(255, 0, 0, 200)
BattleRoyale.wallAreaColor = tocolor(255, 0, 0, 100)
BattleRoyale.round = 0
BattleRoyale.moving = false
BattleRoyale.wallClosingTimer = nil
BattleRoyale.wallClosingWarnTime = 10000 
BattleRoyale.lastTick = 0
BattleRoyale.roundStartRadius = nil
BattleRoyale.roundTargetRadius = nil
BattleRoyale.startOrigin = nil
BattleRoyale.showingMap = false
BattleRoyale.mapWidth = 600 * BattleRoyale.relY
BattleRoyale.mapHeight = 600 * BattleRoyale.relY
BattleRoyale.mapX = BattleRoyale.x / 2 - BattleRoyale.mapWidth / 2
BattleRoyale.mapY = BattleRoyale.y / 2 - BattleRoyale.mapHeight / 2
BattleRoyale.wall = false
BattleRoyale.mapInfoShown = false
BattleRoyale.fuelCheck = 0
BattleRoyale.fuelReduction = 1
BattleRoyale.cameraAngle = {0, 0}
BattleRoyale.choosingCharacter = false
BattleRoyale.skins = getValidPedModels()
BattleRoyale.skinIndex = 1
BattleRoyale.character = 0
BattleRoyale.chooseCharacterInstructionText = "Use arrow keys to switch.\nUse Enter to accept."
local lobbyActive
BattleRoyale.compassWidth = 400 * BattleRoyale.relY
BattleRoyale.compassHeight = 32 * BattleRoyale.relY
BattleRoyale.compassPosX = BattleRoyale.x / 2 - BattleRoyale.compassWidth / 2
BattleRoyale.compassPosY = 60 * BattleRoyale.relY

function BattleRoyale.load()
	
	lobbyActive = false
	addEventHandler("onClientUnloadBattleRoyaleDefinitions", root, BattleRoyale.unload)
	addEventHandler("onClientLobbyDisable", root, BattleRoyale.disableLobby)
	addEventHandler("onClientLobbyEnable", root, BattleRoyale.enableLobby)
	addEventHandler("onClientPlayerReady", root, BattleRoyale.loadingFinished)
	addEventHandler("onClientCountdownStart", root, BattleRoyale.countdown)
	addEventHandler("onClientMapStart", root, BattleRoyale.mapStart)
	addEventHandler("onClientMatchStart", root, BattleRoyale.matchStart)
	addEventHandler("onClientPlaneReachFinalPosition", root, BattleRoyale.planeFinish)
	addEventHandler("onClientRoundEnd", root, BattleRoyale.roundEnd)
	addEventHandler("onClientRoundStart", root, BattleRoyale.roundStart)
	addEventHandler("onClientRender", root, BattleRoyale.render)
	addEventHandler("onClientMapEnding", root, BattleRoyale.mapEnd)
	addEventHandler("onClientMatchInProgress", root, BattleRoyale.matchInProgress)
	addEventHandler("onClientPlayerWin", root, BattleRoyale.playerWin)
	addEventHandler("onClientPlayerLeavePlane", root, BattleRoyale.parachute)
	addEventHandler("onClientVehicleEnter", root, BattleRoyale.vehicleEnter)
	addEventHandler("onClientMapChange", root, BattleRoyale.mapChange)
	addEventHandler("onClientPreMapEnd", root, BattleRoyale.preMapEnd)
	setPlayerHudComponentVisible("weapon", true)
	setPlayerHudComponentVisible("ammo", true)
	setPlayerHudComponentVisible("radio", true)
	setPlayerHudComponentVisible("health", true)
	setPlayerHudComponentVisible("crosshair", true)
	setPlayerHudComponentVisible("armour", true)
	setPlayerHudComponentVisible("clock", true)	
	bindKey("M", "down", BattleRoyale.showMap)

end
addEvent("onClientLoadBattleRoyaleDefinitions", true)
addEventHandler("onClientLoadBattleRoyaleDefinitions", root, BattleRoyale.load)


function BattleRoyale.unload()

	removeEventHandler("onClientUnloadBattleRoyaleDefinitions", root, BattleRoyale.unload)
	removeEventHandler("onClientLobbyDisable", root, BattleRoyale.disableLobby)
	removeEventHandler("onClientLobbyEnable", root, BattleRoyale.enableLobby)
	removeEventHandler("onClientPlayerReady", root, BattleRoyale.loadingFinished)
	removeEventHandler("onClientCountdownStart", root, BattleRoyale.countdown)	
	removeEventHandler("onClientMapStart", root, BattleRoyale.mapStart)	
	removeEventHandler("onClientMatchStart", root, BattleRoyale.matchStart)
	removeEventHandler("onClientPlaneReachFinalPosition", root, BattleRoyale.planeFinish)
	removeEventHandler("onClientRoundEnd", root, BattleRoyale.roundEnd)
	removeEventHandler("onClientRoundStart", root, BattleRoyale.roundStart)
	removeEventHandler("onClientMapEnding", root, BattleRoyale.mapEnd)
	removeEventHandler("onClientRender", root, BattleRoyale.render)
	removeEventHandler("onClientMatchInProgress", root, BattleRoyale.matchInProgress)
	removeEventHandler("onClientPlayerWin", root, BattleRoyale.playerWin)
	removeEventHandler("onClientPlayerLeavePlane", root, BattleRoyale.parachute)
	removeEventHandler("onClientVehicleEnter", root, BattleRoyale.vehicleEnter)
	removeEventHandler("onClientMapChange", root, BattleRoyale.mapChange)
	removeEventHandler("onClientPreMapEnd", root, BattleRoyale.preMapEnd)	
	setPlayerHudComponentVisible("weapon", false)
	setPlayerHudComponentVisible("ammo", false)
	setPlayerHudComponentVisible("health", false)
	setPlayerHudComponentVisible("armour", false)
	setPlayerHudComponentVisible("clock", false)
	setPlayerHudComponentVisible("radio", false)	
	if getKeyBoundToFunction(BattleRoyale.leavePlane) then unbindKey("F", "down", BattleRoyale.leavePlane) end
	if getKeyBoundToFunction(BattleRoyale.showMap) then unbindKey("M", "down", BattleRoyale.showMap) end

	if BattleRoyale.loadingScreen then 

		BattleRoyale.loadingScreen:destroy()
		BattleRoyale.loadingScreen = nil
		
	end	

end
addEvent("onClientUnloadBattleRoyaleDefinitions", true)


function BattleRoyale.reset()

	removeEventHandler("onClientPreRender", root, BattleRoyale.followPlane)
	removeEventHandler("onClientPedStep", localPlayer, BattleRoyale.mapInfo)
	removeEventHandler("onClientCursorMove", root, BattleRoyale.cursorMove)
	
	BattleRoyale.stopChooseCharacter()
	
	if isTimer(BattleRoyale.wallClosingTimer) then killTimer(BattleRoyale.wallClosingTimer) end

	BattleRoyale.targetOrigin = {}
	BattleRoyale.moving = false
	BattleRoyale.showingMap = false
	BattleRoyale.wall = false
	BattleRoyale.mapInfoShown = false
	BattleRoyale.round = 0

	if BattleRoyale.waitingMessage then 
		
		BattleRoyale.waitingMessage:destroy() 
		BattleRoyale.waitingMessage = nil
		
	end
	
	if BattleRoyale.matchStartCountdown then
	
		BattleRoyale.matchStartCountdown:destroy()
		BattleRoyale.matchStartCountdown = nil
		
	end
	
	if BattleRoyale.roundStartMessage then
	
		BattleRoyale.roundStartMessage:destroy()
		BattleRoyale.roundStartMessage = nil
		
	end
	
	if BattleRoyale.ringClosingCountDown then
	
		BattleRoyale.ringClosingCountDown:destroy()
		BattleRoyale.ringClosingCountDown = nil
		
	end
	
	if BattleRoyale.leavePlaneButton then
	
		BattleRoyale.leavePlaneButton:destroy()
		BattleRoyale.leavePlaneButton = nil
		
	end
	
	if BattleRoyale.timeUpMessage then
	
		BattleRoyale.timeUpMessage:destroy()
		BattleRoyale.timeUpMessage = nil
		
	end
	
	if BattleRoyale.nextMatchCountDown then
	
		BattleRoyale.nextMatchCountDown:destroy()
		BattleRoyale.nextMatchCountDown = nil
		
	end	

	if BattleRoyale.mapInfoMessage then
	
		BattleRoyale.mapInfoMessage:destroy()
		BattleRoyale.mapInfoMessage = nil
		
	end

	if BattleRoyale.chooseCharacterInstructionMessage then
	
		BattleRoyale.chooseCharacterInstructionMessage:destroy()
		BattleRoyale.chooseCharacterInstructionMessage = nil
		
	end

	if BattleRoyale.chooseCharacterMessage then
	
		BattleRoyale.chooseCharacterMessage:destroy()
		BattleRoyale.chooseCharacterMessage = nil
		
	end
	
	if BattleRoyale.mapEndCountDown then
	
		BattleRoyale.mapEndCountDown:destroy()
		BattleRoyale.mapEndCountDown = nil
		
	end	

end
addEvent("onClientArenaReset", true)
addEventHandler("onClientArenaReset", root, BattleRoyale.reset)


function BattleRoyale.enableLobby()

	lobbyActive = true	

end
addEvent("onClientLobbyEnable")


function BattleRoyale.disableLobby()

	lobbyActive = false

end
addEvent("onClientLobbyDisable")


function BattleRoyale.mapEnd(text, countTime)
	
	if BattleRoyale.timeUpMessage then
	
		BattleRoyale.timeUpMessage:destroy()
		BattleRoyale.timeUpMessage = nil
		
	end
	
	BattleRoyale.nextMatchCountDown = OnScreenMessage.new(text.."\n", 0.75, "#ffffff", 2, countTime, false, true)

	BattleRoyale.wall = false

	if isTimer(BattleRoyale.wallClosingTimer) then killTimer(BattleRoyale.wallClosingTimer) end

end
addEvent("onClientMapEnding", true)


function BattleRoyale.preMapEnd(text, countTime, timeUp)

	if timeUp then
	
		BattleRoyale.timeUpMessage = OnScreenMessage.new("Time's up!", 0.5, "#ff0000", 3)
		toggleAllControls(false, true, false)	
	
	end

	BattleRoyale.mapEndCountDown = OnScreenMessage.new(text.."\n", 0.75, "#ffffff", 2, countTime, false, true)

end
addEvent("onClientPreMapEnd", true)


function BattleRoyale.followPlane()

	local arenaElement = getElementParent(localPlayer)
	
	if not getElementData(localPlayer, "inplane") then return end
	
	local plane = getElementData(arenaElement, "plane")
	
	if isElement(plane) then
	
		local x, y, z = getElementPosition(plane)

		local ox = x - math.sin(math.rad(BattleRoyale.cameraAngle[1])) * 50
		local oy = y - math.cos(math.rad(BattleRoyale.cameraAngle[1])) * 50
		local oz = z + math.tan(math.rad(BattleRoyale.cameraAngle[2])) * 50
		setCameraMatrix(ox, oy, oz, x, y, z)
		
		return
		
	end

end


function BattleRoyale.cursorMove(rx, ry, x, y)

	if not getElementData(localPlayer, "inplane") then return end

	if isCursorShowing() then return end
	
	if isChatBoxInputActive() then return end

	if isConsoleActive() then return end
	
	if isMainMenuActive() then return end

	local sx, sy = guiGetScreenSize()
	
	BattleRoyale.cameraAngle[1] = (BattleRoyale.cameraAngle[1] + (x - sx / 2) / 10) % 360
	BattleRoyale.cameraAngle[2] = (BattleRoyale.cameraAngle[2] + (y - sy / 2) / 10) % 360
	
	if BattleRoyale.cameraAngle[2] > 180 then
	
		if BattleRoyale.cameraAngle[2] < 300 then BattleRoyale.cameraAngle[2] = 300 end
		
	else
	
		if BattleRoyale.cameraAngle[2] > 60 then BattleRoyale.cameraAngle[2] = 60 end
		
	end
	
end


function BattleRoyale.render()
	
	local arenaElement = getElementParent(localPlayer)	
	
	local cameraTarget = getCameraTarget(localPlayer)
	
	if not cameraTarget then 
	
		cameraTarget = localPlayer
		
	end	
	
	if getElementType(cameraTarget) == "player" then
	
		local vehicle = getPedOccupiedVehicle(cameraTarget)
		
		if vehicle then
		
			cameraTarget = vehicle
			
		end
		
	end
	
	if not cameraTarget then 
	
		cameraTarget = localPlayer
		
	end	
	
	if BattleRoyale.wall then
	
		if BattleRoyale.moving then
		
			local progress = (getTickCount() - BattleRoyale.moveStartTime) / BattleRoyale.roundDuration
			
			progress = math.min(progress, 1)

			BattleRoyale.radius = interpolateBetween ( BattleRoyale.roundStartRadius, 0, 0, BattleRoyale.roundTargetRadius, 0, 0, progress, "Linear" )

			BattleRoyale.origin.x, BattleRoyale.origin.y = interpolateBetween ( BattleRoyale.roundStartOrigion.x, BattleRoyale.roundStartOrigion.y, 0, BattleRoyale.roundTargetOrigin.x, BattleRoyale.roundTargetOrigin.y, 0, progress, "Linear" ) 
		
			if progress == 1 then
				
				BattleRoyale.moving = false

			end

		end

		local mover = 0
		local points = math.floor( math.pow( BattleRoyale.radius, 0.4 ) * 5 )
		local step = math.pi * 2 / points
		local sx, sy

		for i = 0, points do
		
			local ex = math.cos ( i * step ) * BattleRoyale.radius
			local ey = math.sin ( i * step ) * BattleRoyale.radius
			
			if sx then
				
				mover = mover + 0.002;
				local stretch = BattleRoyale.radius * 0.5;
				if (stretch < 300) then stretch = BattleRoyale.radius * 3 end
				
				dxDrawMaterialSectionLine3D(BattleRoyale.origin.x + sx, BattleRoyale.origin.y + sy, 0, BattleRoyale.origin.x + ex, BattleRoyale.origin.y + ey, 0, 0 , mover, 150000, stretch, BattleRoyale.wallTexture, 10000, BattleRoyale.wallColor, BattleRoyale.origin.x, BattleRoyale.origin.y, 0)
			
			end
			
			sx, sy = ex, ey
			
		end
		
		if not lobbyActive and not BattleRoyale.isPlayerInCircle(BattleRoyale.origin, BattleRoyale.radius) then
			
			if getTickCount() - BattleRoyale.lastTick > 1000 then
		
				if cameraTarget == localPlayer or cameraTarget == getPedOccupiedVehicle(localPlayer) then
		
					local health = getElementHealth(localPlayer)
				
					setElementHealth(localPlayer, health - 2.5)
					
					local vehicle = getPedOccupiedVehicle(localPlayer)
					
					if vehicle then
					
						local health = getElementHealth(vehicle)
				
						setElementHealth(vehicle, health - 25)
						
					end
					
					BattleRoyale.lastTick = getTickCount()
					
				end
				
			end

			dxDrawRectangle(0, 0, BattleRoyale.x, BattleRoyale.y, BattleRoyale.wallAreaColor, false);
		
		end
	
	end
	
	if BattleRoyale.showingMap then
	
		dxDrawImage(BattleRoyale.mapX, BattleRoyale.mapY, BattleRoyale.mapWidth, BattleRoyale.mapHeight, "img/map.png", 0, 0, 0, tocolor(255, 255, 255, 255))
	
		local x, y, z = getElementPosition(cameraTarget)
		local x = x * (BattleRoyale.mapWidth/6000) + BattleRoyale.mapWidth/2
		local y = y * (-BattleRoyale.mapWidth/6000) + BattleRoyale.mapWidth/2
	
		if BattleRoyale.wall then
		
			local roundTargetX = BattleRoyale.roundTargetOrigin.x * (BattleRoyale.mapWidth/6000) + BattleRoyale.mapWidth/2
			local roundTargetY = BattleRoyale.roundTargetOrigin.y * (-BattleRoyale.mapWidth/6000) + BattleRoyale.mapWidth/2
			local roundTargetRadius = BattleRoyale.roundTargetRadius * (BattleRoyale.mapWidth/6000)
		
			dxDrawCircleLine(BattleRoyale.mapX + roundTargetX, BattleRoyale.mapY + roundTargetY, roundTargetRadius, tocolor(255, 255, 255, 255), 2, false)
		
			local originX = BattleRoyale.origin.x * (BattleRoyale.mapWidth/6000) + BattleRoyale.mapWidth/2
			local originY = BattleRoyale.origin.y * (-BattleRoyale.mapWidth/6000) + BattleRoyale.mapWidth/2
			local originRadius = BattleRoyale.radius * (BattleRoyale.mapWidth/6000)
			
			dxDrawCircleLine(BattleRoyale.mapX + originX, BattleRoyale.mapY + originY, originRadius, tocolor(255, 0, 0, 255), 2, false)
			
			if not BattleRoyale.isPlayerInCircle(BattleRoyale.roundTargetOrigin, BattleRoyale.roundTargetRadius) and BattleRoyale.isPlayerInCircle(BattleRoyale.origin, BattleRoyale.radius) then

				local pX, pY = BattleRoyale.getPointOnCircle(x, y, roundTargetX, roundTargetY, roundTargetRadius)
			
				dxDrawLine(BattleRoyale.mapX + x, BattleRoyale.mapY + y, BattleRoyale.mapX + pX, BattleRoyale.mapY + pY, tocolor(255, 255, 255, 255), 2)
			
			elseif not BattleRoyale.isPlayerInCircle(BattleRoyale.origin, BattleRoyale.radius) then

				local pX, pY = BattleRoyale.getPointOnCircle(x, y, originX, originY, originRadius)
			
				dxDrawLine(BattleRoyale.mapX + x, BattleRoyale.mapY + y, BattleRoyale.mapX + pX, BattleRoyale.mapY + pY, tocolor(255, 0, 0, 255), 2)
			
			end
			
		end
		
		local _, _, zr = getElementRotation(cameraTarget)
		
		dxDrawImage(BattleRoyale.mapX + x - 16/2, BattleRoyale.mapY + y - 16/2, 16, 16, "img/blip.png", -zr, 0, 0, tocolor ( 255, 255, 255, 255 ), false)  	
	
		for i, player in pairs(getAlivePlayersInArena(arenaElement)) do
		
			while true do
			
				if player == localPlayer then break end
			
				if not getPlayerTeam(localPlayer) then break end
			
				if getPlayerTeam(player) ~= getPlayerTeam(localPlayer) then break end
			
				local x, y, z = getElementPosition(player)
				local x = x * (BattleRoyale.mapWidth/6000) + BattleRoyale.mapWidth/2
				local y = y * (-BattleRoyale.mapWidth/6000) + BattleRoyale.mapWidth/2
						
				local playerName = getPlayerName(player)
				local c1, c2 = string.find(playerName, '#%x%x%x%x%x%x')
				local blipr, blipg, blipb
				
				if c1 then
				
					blipr, blipg, blipb = getColorFromString(string.sub(playerName, c1, c2))
			
				else
				
					blipr = 255
					blipg = 255
					blipb = 255
			
				end

				dxDrawImage(BattleRoyale.mapX + x - 6, BattleRoyale.mapY + y - 6, 12, 12, "img/blipNormal.png", 0, 0, 0, tocolor ( blipr, blipg, blipb, 255 ))
				
				break
			
			end
				
		end
		
		local plane = getElementData(arenaElement, "plane")
		
		if isElement(plane) then
		
			local x, y, z = getElementPosition(plane)
			local x = x * (BattleRoyale.mapWidth/6000) + BattleRoyale.mapWidth/2
			local y = y * (-BattleRoyale.mapWidth/6000) + BattleRoyale.mapWidth/2
			local _, _, zr = getElementRotation(plane)
			
			dxDrawImage(BattleRoyale.mapX + x - 16 * BattleRoyale.relY, BattleRoyale.mapY + y - 16 * BattleRoyale.relY, 32 * BattleRoyale.relY, 32 * BattleRoyale.relY, "img/plane.png", -zr, 0, 0, tocolor ( 255, 255, 255, 255 ), false)
		
		end
		--[[
		for i, vehicle in pairs(getElementsByType("vehicle")) do
		
			local x, y, z = getElementPosition(vehicle)
			local x = x * (BattleRoyale.mapWidth/6000) + BattleRoyale.mapWidth/2
			local y = y * (-BattleRoyale.mapWidth/6000) + BattleRoyale.mapWidth/2
			
			dxDrawImage(BattleRoyale.mapX + x - 6, BattleRoyale.mapY + y - 6, 12, 12, "img/blipNormal.png", 0, 0, 0, tocolor ( 255, 0, 0, 255 ))
	
		end
		
		for i, pickup in pairs(getElementsByType("pickup")) do
		
			local x, y, z = getElementPosition(pickup)
			local x = x * (BattleRoyale.mapWidth/6000) + BattleRoyale.mapWidth/2
			local y = y * (-BattleRoyale.mapWidth/6000) + BattleRoyale.mapWidth/2
			
			dxDrawImage(BattleRoyale.mapX + x - 6, BattleRoyale.mapY + y - 6, 12, 12, "img/blipNormal.png", 0, 0, 0, tocolor ( 0, 180, 255, 255 ))
	
		end]]
		
	end
	
	if getPedOccupiedVehicle(localPlayer) then
	
		if getTickCount() - BattleRoyale.fuelCheck > 1000 then
		
			local vehicle = getPedOccupiedVehicle(localPlayer)
		
			local fuel = getElementData(vehicle, "fuel")
		
			if getElementSpeed(vehicle) ~= 0 then
		
				fuel = math.max(0, fuel - BattleRoyale.fuelReduction)
			
				setElementData(vehicle, "fuel", fuel)
			
			end
			
			if fuel == 0 then
	
				if getVehicleEngineState(vehicle) then
				
					outputChatBox("This vehicle is out of fuel!", 255, 0, 128, true)
				
					setVehicleEngineState(vehicle, false)
					
				end
		
			end
		
			BattleRoyale.fuelCheck = getTickCount()
		
		end
		
	end
	
	--local _,_,rot = getElementRotation(getCamera())
	--local pos = rot/360
	--dxDrawImageSection(BattleRoyale.compassPosX, BattleRoyale.compassPosY, BattleRoyale.compassWidth, BattleRoyale.compassHeight, 660 + -pos * 2400, 0, 1100, 72, "img/compass.png")
	--dxDrawImage(BattleRoyale.x / 2 - 7 * BattleRoyale.relY, BattleRoyale.compassPosY, 14 * BattleRoyale.relY, 11 * BattleRoyale.relY, "img/arrow.png", 0, 0, 0, tocolor(255, 255, 255))
	
end

function BattleRoyale.getPointOnCircle(x, y, cX, cY, radius)

	local vX = x - cX
	local vY = y - cY

	local magV = math.sqrt(vX * vX + vY * vY)
	
	local aX = cX + vX / magV * radius
	local aY = cY + vY / magV * radius

	return aX, aY

end


function BattleRoyale.isPlayerInCircle(circle, radius)
	
	local x, y = getCameraMatrix()
	
	if (circle.x - x)^2 + (circle.y - y)^2 <= radius^2 then 
	
		return true
		
	end
	
	return false

end


function BattleRoyale.loadingFinished(duration, timePassed, waitTime)

	if BattleRoyale.loadingScreen then 

		BattleRoyale.loadingScreen:destroy()
		BattleRoyale.loadingScreen = nil
		
	end	

	if getElementData(source, "state") == "Waiting" then
		
		BattleRoyale.waitingMessage = OnScreenMessage.new("Waiting for more players..\n", 0.5, "#ffffff", 3)
		
		if not getElementData(localPlayer, "Spectator") then
		
			BattleRoyale.chooseCharacter()
			
		end
		
	elseif getElementData(source, "state") == "Countdown" then
		
		BattleRoyale.matchStartCountdown = OnScreenMessage.new("Match starting in ", 0.75, "#ffffff", 2, waitTime, false, true, true)
		
		if not getElementData(localPlayer, "Spectator") and waitTime > 5000 then
		
			BattleRoyale.chooseCharacter()
			
		end
		
	end
	
end
addEvent("onClientPlayerReady", true)


function BattleRoyale.countdown(waitTime)

	if BattleRoyale.waitingMessage then 
		
		BattleRoyale.waitingMessage:destroy() 
		BattleRoyale.waitingMessage = nil
		
	end

	BattleRoyale.matchStartCountdown = OnScreenMessage.new("Match starting in ", 0.75, "#ffffff", 2, waitTime, false, true, true)

	if BattleRoyale.choosingCharacter then
	
		BattleRoyale.matchStartCountdown:setVisible(false)
	
	end

end
addEvent("onClientCountdownStart", true)


function BattleRoyale.mapStart(map, time)

	BattleRoyale.leavePlaneButton = OnScreenMessage.new("Press 'F' to leave the plane", 0.75, "#ffffff", 2)

	bindKey("F", "down", BattleRoyale.leavePlane)

	addEventHandler("onClientPreRender", root, BattleRoyale.followPlane)
	addEventHandler("onClientCursorMove", root, BattleRoyale.cursorMove)
	
	setTime(time, 0)
	
	BattleRoyale.stopChooseCharacter()
	
end
addEvent("onClientMapStart", true)


function BattleRoyale.mapChange()
	
	if BattleRoyale.loadingScreen then 

		BattleRoyale.loadingScreen:destroy()
		BattleRoyale.loadingScreen = nil
		
	end
	
	BattleRoyale.loadingScreen = LoadingScreen.new()

end
addEvent("onClientMapChange", true)


function BattleRoyale.leavePlane()

	if not getElementData(localPlayer, "inplane") then return end

	triggerServerEvent("onPlayerRequestExitPlane", localPlayer)

	if getKeyBoundToFunction(BattleRoyale.leavePlane) then unbindKey("F", "down", BattleRoyale.leavePlane) end

	if BattleRoyale.leavePlaneButton then
	
		BattleRoyale.leavePlaneButton:destroy()
		BattleRoyale.leavePlaneButton = nil
		
	end

end


function BattleRoyale.parachute()

	addEventHandler("onClientPedStep", localPlayer, BattleRoyale.mapInfo)	

end
addEvent("onClientPlayerLeavePlane", true)


function BattleRoyale.planeFinish()

	if getKeyBoundToFunction(BattleRoyale.leavePlane) then unbindKey("F", "down", BattleRoyale.leavePlane) end

	if BattleRoyale.leavePlaneButton then
	
		BattleRoyale.leavePlaneButton:destroy()
		BattleRoyale.leavePlaneButton = nil
		
	end

end
addEvent("onClientPlaneReachFinalPosition", true)


function BattleRoyale.matchStart(currentOrigin, targetOrigin, radius)

	BattleRoyale.round = 1

	BattleRoyale.startOrigin = currentOrigin

	BattleRoyale.origin.x, BattleRoyale.origin.y = BattleRoyale.startOrigin.x, BattleRoyale.startOrigin.y

	BattleRoyale.targetOrigin = targetOrigin
	
	BattleRoyale.startRadius = radius
	
	BattleRoyale.radius = BattleRoyale.startRadius

	BattleRoyale.wall = true

end
addEvent("onClientMatchStart", true)


function BattleRoyale.roundStart(round, roundDuration)

	if not BattleRoyale.wall then return end

	BattleRoyale.moving = false

	BattleRoyale.round = round

	BattleRoyale.roundDuration = roundDuration

	BattleRoyale.wallClosingTimer = setTimer(BattleRoyale.ringClosingWarning, BattleRoyale.roundDuration - BattleRoyale.wallClosingWarnTime, 1)

	BattleRoyale.roundStartOrigion.x, BattleRoyale.roundStartOrigion.y = BattleRoyale.origin.x, BattleRoyale.origin.y

	BattleRoyale.roundTargetOrigin.x, BattleRoyale.roundTargetOrigin.y = interpolateBetween ( BattleRoyale.startOrigin.x, BattleRoyale.startOrigin.y, 0, BattleRoyale.targetOrigin.x, BattleRoyale.targetOrigin.y, 0, 1 - BattleRoyale.circleSizes[BattleRoyale.round], "Linear" ) 

	BattleRoyale.roundStartRadius = BattleRoyale.radius
	
	BattleRoyale.roundTargetRadius = BattleRoyale.startRadius * BattleRoyale.circleSizes[BattleRoyale.round]

	BattleRoyale.roundStartMessage = OnScreenMessage.new("Round "..BattleRoyale.round.." begins..", 0.5, "#00ff00", 2, 5000, true)

end
addEvent("onClientRoundStart", true)


function BattleRoyale.roundEnd()

	if not BattleRoyale.wall then return end

	BattleRoyale.moving = true

	BattleRoyale.moveStartTime = getTickCount()

end
addEvent("onClientRoundEnd", true)


function BattleRoyale.matchInProgress(currentOrigin, targetOrigin, radius, round, roundDuration, wallMoving, timeLeft, time)

	BattleRoyale.moving = wallMoving

	BattleRoyale.round = round

	BattleRoyale.roundDuration = roundDuration

	BattleRoyale.startOrigin = currentOrigin

	BattleRoyale.startRadius = radius

	BattleRoyale.wall = true

	BattleRoyale.targetOrigin = targetOrigin
	
	if BattleRoyale.moving then
	
		BattleRoyale.moveStartTime = getTickCount() - (roundDuration - timeLeft)
	
	else
	
		if timeLeft > BattleRoyale.wallClosingWarnTime then
		
			BattleRoyale.wallClosingTimer = setTimer(BattleRoyale.ringClosingWarning, timeLeft - BattleRoyale.wallClosingWarnTime, 1)

		end	
	
	end
	
	if BattleRoyale.round > 1 then

		BattleRoyale.roundStartOrigion.x, BattleRoyale.roundStartOrigion.y =  interpolateBetween ( BattleRoyale.startOrigin.x, BattleRoyale.startOrigin.y, 0, BattleRoyale.targetOrigin.x, BattleRoyale.targetOrigin.y, 0, 1 - BattleRoyale.circleSizes[BattleRoyale.round - 1], "Linear" ) 

		BattleRoyale.origin.x, BattleRoyale.origin.y = BattleRoyale.roundStartOrigion.x, BattleRoyale.roundStartOrigion.y

		BattleRoyale.roundStartRadius = BattleRoyale.startRadius * BattleRoyale.circleSizes[BattleRoyale.round - 1]
		
		BattleRoyale.radius = BattleRoyale.startRadius * BattleRoyale.circleSizes[BattleRoyale.round - 1]
	
	else
	
		BattleRoyale.roundStartOrigion.x, BattleRoyale.roundStartOrigion.y = BattleRoyale.startOrigin.x, BattleRoyale.startOrigin.y
		
		BattleRoyale.origin.x, BattleRoyale.origin.y = BattleRoyale.roundStartOrigion.x, BattleRoyale.roundStartOrigion.y
		
		BattleRoyale.roundStartRadius = BattleRoyale.startRadius
		
		BattleRoyale.radius = BattleRoyale.startRadius

	end

	BattleRoyale.roundTargetOrigin.x, BattleRoyale.roundTargetOrigin.y = interpolateBetween ( BattleRoyale.startOrigin.x, BattleRoyale.startOrigin.y, 0, BattleRoyale.targetOrigin.x, BattleRoyale.targetOrigin.y, 0, 1 - BattleRoyale.circleSizes[BattleRoyale.round], "Linear" ) 

	BattleRoyale.roundTargetRadius = BattleRoyale.startRadius * BattleRoyale.circleSizes[BattleRoyale.round]

	setTime(time, 0)

end
addEvent("onClientMatchInProgress", true)


function BattleRoyale.playerWin(message)

	BattleRoyale.winMessage = OnScreenMessage.new(message, 0.5, "#04B404", 3, 5000)

end
addEvent("onClientPlayerWin", true)


function BattleRoyale.ringClosingWarning()

	BattleRoyale.ringClosingCountDown = OnScreenMessage.new("Wall moving in ", 0.5, "#ff0000", 2, BattleRoyale.wallClosingWarnTime, false, true, true)

end


function BattleRoyale.showMap()

	if lobbyActive then return end
	
	BattleRoyale.showingMap = not BattleRoyale.showingMap

end


function BattleRoyale.mapInfo()

	if BattleRoyale.mapInfoShown then return end
	
	BattleRoyale.mapInfoShown = true
	
	BattleRoyale.mapInfoMessage = OnScreenMessage.new("Press 'M' to show the Map", 0.75, "#ffffff", 2, 3000, true)	

end


function BattleRoyale.vehicleEnter(player)

	if player ~= localPlayer then return end
	
	if not getElementData(source, "fuel") then return end

	if getElementData(source, "fuel") == 0 then
	
		setVehicleEngineState(source, false)
		return
		
	end

end


function BattleRoyale.getWallProgress()

	if not BattleRoyale.wall then return end
	
	if not BattleRoyale.moving then return 0 end
	
	local progress = (getTickCount() - BattleRoyale.moveStartTime) / BattleRoyale.roundDuration
			
	return math.min(progress, 1)

end
export_getWallProgress = BattleRoyale.getWallProgress


function BattleRoyale.chooseCharacter()

	local arenaElement = getElementParent(localPlayer)

	BattleRoyale.choosingCharacter = true

	BattleRoyale.chooseCharacterMessage = OnScreenMessage.new("Choose your character", 0.25, "#ffffff", 3)

	BattleRoyale.chooseCharacterInstructionMessage = OnScreenMessage.new("<"..BattleRoyale.skinIndex.."/"..#BattleRoyale.skins..">\n"..BattleRoyale.chooseCharacterInstructionText, 0.75, "#ffffff", 1)

	setElementModel(localPlayer, BattleRoyale.character)

	toggleAllControls(false, true, false)
	
	setElementFrozen(localPlayer, true)

	local x, y, z = getElementPosition(localPlayer)
	
	local cameraPosition = localPlayer.matrix.position + localPlayer.matrix.forward * 5

	setCameraMatrix(cameraPosition.x, cameraPosition.y, cameraPosition.z, x, y, z)

	addEventHandler("onClientKey", root, BattleRoyale.keyClick)
	addEventHandler("onClientPlayerDamage", localPlayer, BattleRoyale.preventDamage)

	if BattleRoyale.waitingMessage then
	
		BattleRoyale.waitingMessage:setVisible(false)
		
	end
	
	if BattleRoyale.matchStartCountdown then
	
		BattleRoyale.matchStartCountdown:setVisible(false)
		
	end	

	setElementDimension(localPlayer, math.random(30000))

end


function BattleRoyale.stopChooseCharacter()

	local arenaElement = getElementParent(localPlayer)

	if BattleRoyale.chooseCharacterInstructionMessage then
	
		BattleRoyale.chooseCharacterInstructionMessage:destroy()
		BattleRoyale.chooseCharacterInstructionMessage = nil
		
	end

	if BattleRoyale.chooseCharacterMessage then
	
		BattleRoyale.chooseCharacterMessage:destroy()
		BattleRoyale.chooseCharacterMessage = nil
		
	end

	BattleRoyale.choosingCharacter = false
	
	setCameraTarget(localPlayer, localPlayer)
	
	toggleAllControls(true, true, true)
	
	setElementFrozen(localPlayer, false)

	if BattleRoyale.waitingMessage then
	
		BattleRoyale.waitingMessage:setVisible(true)
		
	end
	
	if BattleRoyale.matchStartCountdown then
	
		BattleRoyale.matchStartCountdown:setVisible(true)
		
	end
	
	setElementDimension(localPlayer, getElementDimension(arenaElement))
	
	removeEventHandler("onClientKey", root, BattleRoyale.keyClick)
	removeEventHandler("onClientPlayerDamage", localPlayer, BattleRoyale.preventDamage)

	triggerServerEvent("onPlayerChooseCharacter", localPlayer, BattleRoyale.character)

end


function BattleRoyale.keyClick(button, pressOrRelease)

	if not pressOrRelease then return end

	if isCursorShowing() then return end
	
	if isChatBoxInputActive() then return end

	if isConsoleActive() then return end
	
	if isMainMenuActive() then return end

	if button == "arrow_l" then
	
		BattleRoyale.skinIndex = BattleRoyale.skinIndex - 1
	
		if BattleRoyale.skinIndex < 1 then 
		
			BattleRoyale.skinIndex = #BattleRoyale.skins
			
		end

		BattleRoyale.character = BattleRoyale.skins[BattleRoyale.skinIndex]
	
		setElementModel(localPlayer, BattleRoyale.character)
	
		BattleRoyale.chooseCharacterInstructionMessage:setText("<"..BattleRoyale.skinIndex.."/"..#BattleRoyale.skins..">\n"..BattleRoyale.chooseCharacterInstructionText, 0.75, "#ffffff", 1)
	
	elseif button == "arrow_r" then
	
		BattleRoyale.skinIndex = BattleRoyale.skinIndex + 1
	
		if BattleRoyale.skinIndex > #BattleRoyale.skins then 
		
			BattleRoyale.skinIndex = 1
			
		end
	
		BattleRoyale.character = BattleRoyale.skins[BattleRoyale.skinIndex]
	
		setElementModel(localPlayer, BattleRoyale.character)
	
		BattleRoyale.chooseCharacterInstructionMessage:setText("<"..BattleRoyale.skinIndex.."/"..#BattleRoyale.skins..">\n"..BattleRoyale.chooseCharacterInstructionText, 0.75, "#ffffff", 1)
	
	elseif button == "enter" then
	
		BattleRoyale.stopChooseCharacter()
	
	end

end


function BattleRoyale.preventDamage()

	cancelEvent()

end