Keys = {}
Keys.x, Keys.y = guiGetScreenSize()
Keys.relX, Keys.relY =  (Keys.x/800), (Keys.y/600)
Keys.keysList = nil
Keys.keys = {"accelerate", "brake_reverse", "vehicle_left", "vehicle_right", "handbrake", "left", "right", "steer_forward", "steer_back"}
Keys.offset = 2 * Keys.relX
Keys.active = true
Keys.posX = Keys.x / 2
Keys.posY = Keys.y - 7 * Keys.relY - dxGetFontHeight(1, "default-bold") * 1.5
Keys.keySize = 30 * Keys.relY

function Keys.update(playerList)
	
	Keys.keysList = nil
	
	local target = Keys.getCameraTargetPlayer()

	if not target then return end
	
	if not playerList[target] then return end

	Keys.keysList = playerList[target]
		
end
addEvent("onKeysUpdate", true)
addEventHandler("onKeysUpdate", root, Keys.update)


function Keys.render()

	if not Keys.active then return end

	if getElementData(localPlayer, "state") ~= "Spectating" then return end

	if not Keys.keysList then return end
	
		if Keys.keysList["vehicle_left"] then

		dxDrawImage(Keys.posX, Keys.posY - Keys.keySize, Keys.keySize, Keys.keySize, "AnotPressed.png", 0, 0, 0, tocolor(125, 125, 125, 100), false)  	

	else
	
		dxDrawImage(Keys.posX, Keys.posY - Keys.keySize, Keys.keySize, Keys.keySize, "AnotPressed.png", 0, 0, 0, tocolor(255, 255, 255, 100), false) 
	
	end
	
	if Keys.keysList["brake_reverse"] then

		dxDrawImage(Keys.posX + Keys.keySize + Keys.offset, Keys.posY - Keys.keySize, Keys.keySize, Keys.keySize, "SnotPressed.png", 0, 0, 0, tocolor(125, 125, 125, 100), false)  	

	else
	
		dxDrawImage(Keys.posX + Keys.keySize + Keys.offset, Keys.posY - Keys.keySize, Keys.keySize, Keys.keySize, "SnotPressed.png", 0, 0, 0, tocolor(255, 255, 255, 100), false) 
	
	end
	
	if Keys.keysList["accelerate"] then

		dxDrawImage(Keys.posX + Keys.keySize + Keys.offset, Keys.posY - Keys.keySize * 2 - Keys.offset, Keys.keySize, Keys.keySize, "WnotPressed.png", 0, 0, 0, tocolor(125, 125, 125, 100), false)  	

	else
	
		dxDrawImage(Keys.posX + Keys.keySize + Keys.offset, Keys.posY - Keys.keySize * 2 - Keys.offset, Keys.keySize, Keys.keySize, "WnotPressed.png", 0, 0, 0, tocolor(255, 255, 255, 100), false) 
	
	end

	if Keys.keysList["vehicle_right"] then

		dxDrawImage(Keys.posX + Keys.keySize * 2 + Keys.offset * 2, Keys.posY - Keys.keySize, Keys.keySize, Keys.keySize, "DnotPressed.png", 0, 0, 0, tocolor(125, 125, 125, 100), false)  	

	else
	
		dxDrawImage(Keys.posX + Keys.keySize * 2 + Keys.offset * 2, Keys.posY - Keys.keySize, Keys.keySize, Keys.keySize, "DnotPressed.png", 0, 0, 0, tocolor(255, 255, 255, 100), false) 
	
	end

	if Keys.keysList["handbrake"] then

		dxDrawImage(Keys.posX + Keys.keySize * 3 + Keys.offset * 3, Keys.posY - Keys.keySize, Keys.keySize * 2 + Keys.offset, Keys.keySize, "SpaceNotPressed.png", 0, 0, 0, tocolor(125, 125, 125, 100), false)  	

	else
	
		dxDrawImage(Keys.posX + Keys.keySize * 3 + Keys.offset * 3, Keys.posY - Keys.keySize, Keys.keySize * 2 + Keys.offset, Keys.keySize, "SpaceNotPressed.png", 0, 0, 0, tocolor(255, 255, 255, 100), false) 
	
	end

	if Keys.keysList["left"] then

		dxDrawImage(Keys.posX + Keys.keySize * 5 + Keys.offset * 5, Keys.posY - Keys.keySize, Keys.keySize, Keys.keySize, "ArrowLeftnotPressed.png", 0, 0, 0, tocolor(125, 125, 125, 100), false)  	

	else
	
		dxDrawImage(Keys.posX + Keys.keySize * 5 + Keys.offset * 5, Keys.posY - Keys.keySize, Keys.keySize, Keys.keySize, "ArrowLeftnotPressed.png", 0, 0, 0, tocolor(255, 255, 255, 100), false) 
	
	end

	if Keys.keysList["steer_back"] then

		dxDrawImage(Keys.posX + Keys.keySize * 6 + Keys.offset * 6, Keys.posY - Keys.keySize, Keys.keySize, Keys.keySize, "ArrowDownnotPressed.png", 0, 0, 0, tocolor(125, 125, 125, 100), false)  	

	else
	
		dxDrawImage(Keys.posX + Keys.keySize * 6 + Keys.offset * 6, Keys.posY - Keys.keySize, Keys.keySize, Keys.keySize, "ArrowDownnotPressed.png", 0, 0, 0, tocolor(255, 255, 255, 100), false) 
	
	end
	
	if Keys.keysList["steer_forward"] then

		dxDrawImage(Keys.posX + Keys.keySize * 6 + Keys.offset * 6, Keys.posY - Keys.keySize * 2 - Keys.offset, Keys.keySize, Keys.keySize, "ArrowUpnotPressed.png", 0, 0, 0, tocolor(125, 125, 125, 100), false)  	

	else
	
		dxDrawImage(Keys.posX + Keys.keySize * 6 + Keys.offset * 6, Keys.posY - Keys.keySize * 2 - Keys.offset, Keys.keySize, Keys.keySize, "ArrowUpnotPressed.png", 0, 0, 0, tocolor(255, 255, 255, 100), false) 
	
	end
	
	if Keys.keysList["right"] then

		dxDrawImage(Keys.posX + Keys.keySize * 7 + Keys.offset * 7, Keys.posY - Keys.keySize, Keys.keySize, Keys.keySize, "ArrowRightnotPressed.png", 0, 0, 0, tocolor(125, 125, 125, 100), false)  	

	else
	
		dxDrawImage(Keys.posX + Keys.keySize * 7 + Keys.offset * 7, Keys.posY - Keys.keySize, Keys.keySize, Keys.keySize, "ArrowRightnotPressed.png", 0, 0, 0, tocolor(255, 255, 255, 100), false) 
	
	end

end
addEventHandler('onClientRender', root, Keys.render)


function Keys.getCameraTargetPlayer()

	local target = getCameraTarget()
	
	if target and getElementType(target) == "vehicle" then
	
		target = getVehicleOccupant(target)
		
	end
	
	if target and getElementType(target) ~= "player" then
	
		return false
	
	end
	
	return target

end


function Keys.toggle(c, t)

	Keys.active = not Keys.active

end
addCommandHandler('keys', Keys.toggle)