RankingBoard = {}
RankingBoard.x, RankingBoard.y = guiGetScreenSize()
RankingBoard.relX, RankingBoard.relY =  (RankingBoard.x/800), (RankingBoard.y/600)

--Font
RankingBoard.fontSize = 1
RankingBoard.font = "default-bold"
RankingBoard.fontColor = tocolor ( 255, 255, 255, 255 )
RankingBoard.rowSize = dxGetFontHeight(RankingBoard.fontSize, RankingBoard.font) * 1.5

--Other
RankingBoard.posY = (10 * RankingBoard.relY)
RankingBoard.offset = (2 * RankingBoard.relY)
RankingBoard.maxRows = 6
RankingBoard.firstRow = 0
RankingBoard.currentFirstRow = RankingBoard.firstRow
RankingBoard.labels = {}

--Time
RankingBoard.timeWidth = dxGetTextWidth(" 00:00:00 ", RankingBoard.fontSize, RankingBoard.font)
RankingBoard.timePosX = RankingBoard.x - RankingBoard.timeWidth - RankingBoard.offset
RankingBoard.timeBackgroundColor = tocolor(0, 0, 0, 100)

--Label
RankingBoard.labelWidth = dxGetTextWidth(" XXXXXXXXXXXXX ", RankingBoard.fontSize, RankingBoard.font)
RankingBoard.labelPosX = RankingBoard.timePosX - RankingBoard.labelWidth - RankingBoard.offset
RankingBoard.labelBackgroundColor = tocolor(0, 0, 0, 100)

--Position
RankingBoard.positionWidth = RankingBoard.rowSize
RankingBoard.positionPosX = RankingBoard.labelPosX - RankingBoard.positionWidth - RankingBoard.offset
RankingBoard.positionBackgroundColor = tocolor(0, 0, 0, 255)
RankingBoard.positionColor = tocolor (255, 255, 255, 255)

RankingBoard.show = true

function RankingBoard.destroy()

	RankingBoard.labels = {}
	RankingBoard.firstRow = 0
	RankingBoard.currentFirstRow = RankingBoard.firstRow
	removeEventHandler("onClientRender", root, RankingBoard.render)
	
end
addEvent("onClientArenaReset", true)
addEventHandler("onClientArenaReset", root, RankingBoard.destroy)


function RankingBoard.create()

	addEventHandler("onClientRender", root, RankingBoard.render)
	
end
addEvent("onClientPlayerReady", true)
addEventHandler("onClientPlayerReady", root, RankingBoard.create)


function RankingBoard.render()

	if not RankingBoard.show then return end

	local resource = getResourceFromName("CCS")
	
	if not resource then return end

	if getResourceState(resource) ~= "running" then return end
	
	--Rankingboard
	RankingBoard.rowIndex = 0

	if getKeyState("F6") then
	
		RankingBoard.currentMaxRows = #RankingBoard.labels
		RankingBoard.currentFirstRow = 0
		
	else
	
		RankingBoard.currentMaxRows = RankingBoard.maxRows
		RankingBoard.currentFirstRow = RankingBoard.firstRow
	
	end
	
	
	--Show players
	for i, label in ipairs(RankingBoard.labels) do
		
		if (i > RankingBoard.currentFirstRow and i - RankingBoard.currentFirstRow <= RankingBoard.currentMaxRows) then
		
			local currentPosY = RankingBoard.posY + RankingBoard.offset + ((RankingBoard.rowSize + RankingBoard.offset) * RankingBoard.rowIndex)
			RankingBoard.drawLabel(currentPosY, label.pos, label.name, label.timeString)

			RankingBoard.rowIndex = RankingBoard.rowIndex + 1
			
		end
		
	end
	
	--Show number of not shown players
	if RankingBoard.rowIndex == #RankingBoard.labels then return end
	
	if (#RankingBoard.labels - RankingBoard.rowIndex) == 1 then
	
		playerOrPlayers = "player"
		
	else
	
		playerOrPlayers = "players"
	
	end
	
	local currentPosY = RankingBoard.posY + RankingBoard.offset + ((RankingBoard.rowSize + RankingBoard.offset) * (RankingBoard.currentMaxRows))
	dxDrawRectangle(RankingBoard.positionPosX, currentPosY, RankingBoard.positionWidth + RankingBoard.labelWidth + RankingBoard.timeWidth + 2 * RankingBoard.offset, RankingBoard.rowSize, RankingBoard.labelBackgroundColor)
	dxDrawText("and "..(#RankingBoard.labels - RankingBoard.rowIndex) .." more "..playerOrPlayers.."..", RankingBoard.positionPosX+1, currentPosY+1, RankingBoard.positionPosX + RankingBoard.positionWidth + RankingBoard.labelWidth + RankingBoard.timeWidth + 2 * RankingBoard.offset+1, currentPosY + RankingBoard.rowSize+1, tocolor ( 0, 0, 0, 255 ), RankingBoard.fontSize, RankingBoard.font, "center", "center", false, false, false, false, false )
	dxDrawText("and "..(#RankingBoard.labels - RankingBoard.rowIndex) .." more "..playerOrPlayers.."..", RankingBoard.positionPosX, currentPosY, RankingBoard.positionPosX + RankingBoard.positionWidth + RankingBoard.labelWidth + RankingBoard.timeWidth + 2 * RankingBoard.offset, currentPosY + RankingBoard.rowSize, tocolor (255, 255, 255, 255), RankingBoard.fontSize, RankingBoard.font, "center", "center", false, false, false, false, false )

end


function RankingBoard.drawLabel(currentPosY, position, name, time)

	--Highlight Local Player
	if name == getPlayerName(localPlayer) then
	
		RankingBoard.positionColor = tocolor (0, 255, 0, 255)
		
	else
	
		RankingBoard.positionColor = tocolor (255, 255, 255, 255)
	
	end
	
	dxDrawRectangle(RankingBoard.positionPosX, currentPosY, RankingBoard.positionWidth, RankingBoard.rowSize, RankingBoard.positionBackgroundColor)
	dxDrawText(position, RankingBoard.positionPosX+1, currentPosY+1, RankingBoard.positionPosX + RankingBoard.positionWidth+1, currentPosY + RankingBoard.rowSize+1, tocolor ( 0, 0, 0, 255 ), RankingBoard.fontSize, RankingBoard.font, "center", "center", false, false, false, false, false )
	dxDrawText(position, RankingBoard.positionPosX, currentPosY, RankingBoard.positionPosX + RankingBoard.positionWidth, currentPosY + RankingBoard.rowSize, RankingBoard.positionColor, RankingBoard.fontSize, RankingBoard.font, "center", "center", false, false, false, false, false )
	
	dxDrawRectangle(RankingBoard.labelPosX, currentPosY, RankingBoard.labelWidth, RankingBoard.rowSize, RankingBoard.labelBackgroundColor)
	dxDrawText(" "..name:gsub('#%x%x%x%x%x%x', '').." ", RankingBoard.labelPosX+1, currentPosY+1, RankingBoard.labelPosX + RankingBoard.labelWidth+1, currentPosY + RankingBoard.rowSize+1, tocolor ( 0, 0, 0, 255 ), RankingBoard.fontSize, RankingBoard.font, "left", "center", true, false, false, false, false )
	dxDrawText(" "..name.." ", RankingBoard.labelPosX, currentPosY, RankingBoard.labelPosX + RankingBoard.labelWidth, currentPosY + RankingBoard.rowSize, RankingBoard.fontColor, RankingBoard.fontSize, RankingBoard.font, "left", "center", true, false, false, true, false )

	dxDrawRectangle(RankingBoard.timePosX, currentPosY, RankingBoard.timeWidth, RankingBoard.rowSize, RankingBoard.labelBackgroundColor)
	dxDrawText(" "..time.." ", RankingBoard.timePosX+1, currentPosY+1, RankingBoard.timePosX + RankingBoard.timeWidth+1, currentPosY + RankingBoard.rowSize+1, tocolor ( 0, 0, 0, 255 ), RankingBoard.fontSize, RankingBoard.font, "left", "center", false, false, false, false, false )
	dxDrawText(" "..time.." ", RankingBoard.timePosX, currentPosY, RankingBoard.timePosX + RankingBoard.timeWidth, currentPosY + RankingBoard.rowSize, RankingBoard.fontColor, RankingBoard.fontSize, RankingBoard.font, "left", "center", false, false, false, false, false )
	
end


function RankingBoard.add(position, name, time, upOrDown)

	local deathTime = exports["CCS"]:export_msToTime(time)
	
	local name = RankingBoard.dxClipTextToWidth(name, RankingBoard.labelWidth)
	
	if upOrDown then
	
		table.insert(RankingBoard.labels, 1, {pos = position, name = name, time = time, timeString = deathTime})
		
	else
	
		table.insert(RankingBoard.labels, #RankingBoard.labels + 1, {pos = position, name = name, time = time, timeString = deathTime})
	
		if #RankingBoard.labels > RankingBoard.maxRows then
		
			RankingBoard.firstRow = RankingBoard.firstRow + 1
			RankingBoard.currentFirstRow = RankingBoard.firstRow
			
		else
	
			RankingBoard.firstRow = 0
			RankingBoard.currentFirstRow = RankingBoard.firstRow
			
		end
	
	end

	playSoundFrontEnd(7)
	
end
addEvent("onClientRankingBoardUpdate", true)
addEventHandler("onClientRankingBoardUpdate", root, RankingBoard.add)


function RankingBoard.dxClipTextToWidth(text, width)

	while dxGetTextWidth(" "..text, RankingBoard.fontSize, RankingBoard.font, true) > width do
	
		text = text:sub(1, #text-1)
	
	end
	
	return text

end


function RankingBoard.toggle()

	RankingBoard.show = not RankingBoard.show

end
addCommandHandler("showrankingboard", RankingBoard.toggle)