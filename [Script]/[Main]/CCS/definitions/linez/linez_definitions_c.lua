Linez = {}
Linez.recordData = {}
Linez.recordInterval = 50
Linez.lastRecordTime = 0
Linez.size = 50
Linez.wasAlreadyHit = false

function Linez.load()

	addEventHandler("onClientRender", root, Linez.record)
	addEventHandler("onClientRender", root, Linez.draw)
	
end
addEvent("onClientSetUpLinezDefinitions", true)
addEventHandler("onClientSetUpLinezDefinitions", root, Linez.load)


function Linez.unload()

	Linez.recordData = {}
	Linez.wasAlreadyHit = false
	setElementData(localPlayer, "linez_size", Linez.size)
	setElementData(localPlayer, "linez_shield", false)
	removeEventHandler("onClientRender", root, Linez.record)
	removeEventHandler("onClientRender", root, Linez.draw)
	
end
addEvent("onClientSetDownLinezDefinitions", true)
addEventHandler("onClientSetDownLinezDefinitions", root, Linez.unload)


function Linez.record()

	if getTickCount() - Linez.lastRecordTime < Linez.recordInterval then return end
	
	Linez.lastRecordTime = getTickCount()

	local arenaElement = getElementParent(localPlayer)
	
	for i, player in pairs(exports["CCS"]:export_getPlayersInArena(arenaElement)) do
	
		while true do
		
			local vehicle = getPedOccupiedVehicle(player)
		
			if not vehicle then break end
		
			if not Linez.recordData[player] then
			
				Linez.recordData[player] = {}
				
			end
		
			if #Linez.recordData[player] > 100 then
			
				table.remove(Linez.recordData[player], 1)
				
			end
				
			local size = getElementData(player, "linez_size") or Linez.size 
			
			table.insert(Linez.recordData[player], {position = vehicle.position, size = size})
		
			break
			
		end
		
	end
	
end


function Linez.draw()

	local arenaElement = getElementParent(localPlayer)

	for i, player in pairs(exports["CCS"]:export_getPlayersInArena(arenaElement)) do
		
		while true do

			if not Linez.recordData[player] or #Linez.recordData[player] < 2 then break end

			if not getPedOccupiedVehicle(player) then break end

			local r1, g1, b1, r2, g2, b2 = getVehicleColor(getPedOccupiedVehicle(player), true)
		
			for i = 2, #Linez.recordData[player], 1 do
				
				local r, g, b
				
				--if i % 2 == 0 then
				
					r, g, b = r1, g1, b1
					
				--else

					--r, g, b = r2, g2, b2
					
				--end
				
				if r < 50 and g < 50 and b < 50 then
					
					r, g, b = 255, 0, 0
					
				end
				
				while true do
					
					dxDrawLine3D(Linez.recordData[player][i-1].position.x, Linez.recordData[player][i-1].position.y, Linez.recordData[player][i-1].position.z, Linez.recordData[player][i].position.x, Linez.recordData[player][i].position.y, Linez.recordData[player][i].position.z, tocolor ( r, g, b, 200 ), Linez.recordData[player][i-1].size)

					if Linez.wasAlreadyHit then break end
					
					if player == localPlayer then break end
					
					if getElementData(localPlayer, "linez_shield") then break end

					Linez.checkHit(player, Linez.recordData[player][i-1].position.x, Linez.recordData[player][i-1].position.y, Linez.recordData[player][i-1].position.z, Linez.recordData[player][i].position.x, Linez.recordData[player][i].position.y, Linez.recordData[player][i].position.z)
	
					break
					
				end
	
			end
				
		break
		
		end
		
	end
	
end


function Linez.checkHit(player, x, y, z, x1, y1, z1)

	if Linez.wasAlreadyHit then return end
					
	local hit, hitX, hitY, hitZ, hitElement = processLineOfSight(x, y, z, x1, y1, z1, false, true, true, false, false, false, nil, false, false)
					
	if not hit then return end
	
	local localVehicle = getPedOccupiedVehicle(localPlayer)
		
	if hitElement ~= localPlayer and hitElement ~= localVehicle then return end
		
	triggerServerEvent("onPlayerLinezWasted", localPlayer, player)

	blowVehicle(localVehicle)

	Linez.wasAlreadyHit = true
	
end