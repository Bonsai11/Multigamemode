Spectators = {}
Spectators.x, Spectators.y = guiGetScreenSize()
Spectators.relX, Spectators.relY =  (Spectators.x/800), (Spectators.y/600)
Spectators.maxPlayers = 10
Spectators.playerList = {}
Spectators.font = "default-bold"
Spectators.fontSize = 1
Spectators.fontColor = tocolor(255, 255, 255, 255)
Spectators.posY = Spectators.y/3
Spectators.rowSize = dxGetFontHeight(Spectators.fontSize, Spectators.font) * 1.2
Spectators.alwaysOn = false
Spectators.offset = (20 * Spectators.relX)
Spectators.headerLength = dxGetTextWidth(" Spectating XXXXXXXXXXXXXXXX:", Spectators.fontSize, Spectators.font, true)
Spectators.posX = Spectators.x - Spectators.headerLength - Spectators.offset

function Spectators.update(playerList)
	
	Spectators.playerList = {}
	
	for player, target in pairs(playerList) do
	
		if target == Spectators.getCameraTargetPlayer() then
		
			table.insert(Spectators.playerList, player)
			
		end
		
	end
	
		
end
addEvent("onSpectatorsUpdate", true)
addEventHandler("onSpectatorsUpdate", root, Spectators.update)


function Spectators.render()

	if getElementData(localPlayer, "state") ~= "Spectating" and getElementData(localPlayer, "state") ~= "Alive" then return end
	
	if getElementData(localPlayer, "state") == "Alive" and not Spectators.alwaysOn then return end

	local target = Spectators.getCameraTargetPlayer()
	
	if not target then return end
	
	local spectatedPlayerName = getPlayerName(target)

	local specList = ""

	local text = Spectators.dxClipTextToWidth(" Spectating "..spectatedPlayerName, Spectators.headerLength)
	dxDrawText(text:gsub("#%x%x%x%x%x%x", "")..":", Spectators.posX+1, Spectators.posY+1, Spectators.posX+Spectators.headerLength+1, Spectators.posY+Spectators.rowSize, tocolor(0, 0, 0, 255), Spectators.fontSize, Spectators.font, "left", "center", false, false, false, true)
	dxDrawText(text.."#ffffff:", Spectators.posX, Spectators.posY, Spectators.posX+Spectators.headerLength, Spectators.posY+Spectators.rowSize, Spectators.fontColor, Spectators.fontSize, Spectators.font, "left", "center", false, false, false, true)
	
	for i, player in pairs(Spectators.playerList) do
	
		if isElement(player) then
		
			local playerName = getPlayerName(player)

			if playerName then
			
				specList = specList.."#ffffff - "..playerName.." \n"
				
				if i > Spectators.maxPlayers then
				
					specList = specList.."#ffffffand "..(#Spectators.playerList-Spectators.maxPlayers).." more"
					break
					
				end
				
			end
		
		end
	
	end

	dxDrawText(specList:gsub("#%x%x%x%x%x%x", ""), Spectators.posX+1, Spectators.posY+1+Spectators.rowSize, Spectators.x+1, Spectators.y+1, tocolor(0, 0, 0, 255), Spectators.fontSize, Spectators.font, "left", "top", false, false, false, true)
	dxDrawText(specList, Spectators.posX, Spectators.posY+Spectators.rowSize, Spectators.x, Spectators.y, Spectators.fontColor, Spectators.fontSize, Spectators.font, "left", "top", false, false, false, true)
	
end
addEventHandler('onClientRender', root, Spectators.render)


function Spectators.getCameraTargetPlayer()

	local target = getCameraTarget()
	
	if target and getElementType(target) == "vehicle" then
	
		target = getVehicleOccupant(target)
		
	end
	
	if target and getElementType(target) ~= "player" then
	
		return false
	
	end
	
	return target

end


function Spectators.dxClipTextToWidth(text, width)

	while dxGetTextWidth(" "..text, Spectators.fontSize, Spectators.font, true) > width do
	
		text = text:sub(1, #text-1)
	
	end
	
	return text

end


function Spectators.toggle(c, t)

	Spectators.alwaysOn = not Spectators.alwaysOn
	outputChatBox("You "..(Spectators.alwaysOn and "will now" or "won't").." see who spectates you when alive.", 255, 0, 128)

end
addCommandHandler('speclist', Spectators.toggle)