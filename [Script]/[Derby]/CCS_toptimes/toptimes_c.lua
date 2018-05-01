TopTimes = {}
TopTimes.x, TopTimes.y = guiGetScreenSize()
TopTimes.relX, TopTimes.relY = (TopTimes.x/800), (TopTimes.y/600)
TopTimes.shown = false
TopTimes.startX = 800*TopTimes.relX
TopTimes.startY = 200*TopTimes.relY
TopTimes.posX = TopTimes.startX
TopTimes.posY = TopTimes.startY
TopTimes.fontSize = 1
TopTimes.font = "default-bold"
TopTimes.fontColor = tocolor(255, 255, 255, 255)
TopTimes.animation = "InOutBack"
TopTimes.rowSize = dxGetFontHeight(TopTimes.fontSize, TopTimes.font)
TopTimes.width = 0
TopTimes.columnOffset = 1
TopTimes.rowOffset = 1
TopTimes.tableHeadHeight = 1.4
TopTimes.offset = 20*TopTimes.relY
TopTimes.endY = TopTimes.startY
TopTimes.timer = nil
TopTimes.list = {}
TopTimes.myTop = {}
TopTimes.isAnimating = false
TopTimes.animStartTime = nil
TopTimes.endTime = nil
TopTimes.hasLocalPlayer = false
TopTimes.columns = {}
TopTimes.enabled = false
TopTimes.showOn = true

function TopTimes.main()

	TopTimes.createColumn("#", dxGetTextWidth("_XX_", TopTimes.fontSize, TopTimes.font), "center", function(i, rowData) if not rowData[i] then return "" end return rowData[i][1].."." or "" end)
	TopTimes.createColumn(" Name", dxGetTextWidth("_XXXXXXXXXX_", TopTimes.fontSize, TopTimes.font), "left", function(i, rowData) if not rowData[i] then return "" end return rowData[i][2] or "" end)
	TopTimes.createColumn(" Time", dxGetTextWidth("_00:00:000_", TopTimes.fontSize, TopTimes.font), "left", function(i, rowData) if not rowData[i] then return "" end  return rowData[i][3] or "" end)
	TopTimes.createColumn(" Date", dxGetTextWidth("_XXXX.XX.XX_XX:XX:XX", TopTimes.fontSize, TopTimes.font), "left", function(i, rowData) if not rowData[i] then return "" end  return rowData[i][4] or "" end)
	TopTimes.createColumn(" Arena", dxGetTextWidth("_XXXXXXXXXX_", TopTimes.fontSize, TopTimes.font), "left",
	function(i, rowData)

		if not rowData[i] then return "" end

		if not rowData[i][5] then return "" end

		if getElementByID(rowData[i][5]) then

			local color = getElementData(getElementByID(rowData[i][5]), "color") or "ffffff"
			local name = getElementData(getElementByID(rowData[i][5]), "name") or rowData[i][5]
			return color..name

		else

			return rowData[i][5]

		end

	end)

	for i, column in pairs(TopTimes.columns) do

		TopTimes.width = TopTimes.width + column.width + TopTimes.columnOffset

	end

	TopTimes.width = TopTimes.width - TopTimes.columnOffset
	TopTimes.endX = TopTimes.startX - TopTimes.width-TopTimes.offset

end
addEventHandler("onClientResourceStart", resourceRoot, TopTimes.main)


function TopTimes.reset()

	TopTimes.shown = false
	if isTimer(TopTimes.timer) then killTimer(TopTimes.timer) end
	removeEventHandler("onClientRender", root, TopTimes.render)
	removeEventHandler("onClientRender", root, TopTimes.AnimIn)
	removeEventHandler("onClientRender", root, TopTimes.AnimOut)
	TopTimes.enabled = false

end
addEvent("onClientArenaReset", true)
addEventHandler("onClientArenaReset", localPlayer, TopTimes.reset)


function TopTimes.show(state)

	if not TopTimes.enabled then return end

	if TopTimes.isAnimating then return end

	if isTimer(TopTimes.timer) then killTimer(TopTimes.timer) end

	TopTimes.animStartTime = getTickCount()
	TopTimes.animEndTime = TopTimes.animStartTime + 1000

	if state then

		TopTimes.isAnimating = true
		addEventHandler("onClientRender", root, TopTimes.AnimIn)
		addEventHandler("onClientRender", root, TopTimes.render)
		TopTimes.timer = setTimer(TopTimes.show, 5000, 1, false)

	elseif not state then

		TopTimes.isAnimating = true
		addEventHandler("onClientRender", root, TopTimes.AnimOut)

	end

end


function TopTimes.toggle()

	TopTimes.show(not TopTimes.shown)

end
bindKey("F5", "down", TopTimes.toggle)


function TopTimes.AnimIn()

	local now = getTickCount()
	local elapsedTime = now - TopTimes.animStartTime
	local duration = TopTimes.animEndTime - TopTimes.animStartTime
	local progress = elapsedTime / duration

	TopTimes.posX, TopTimes.posY = interpolateBetween(TopTimes.startX, TopTimes.startY, 0, TopTimes.endX, TopTimes.endY, 0, progress, TopTimes.animation)

	if progress >= 1 then

		removeEventHandler("onClientRender", root, TopTimes.AnimIn)
		TopTimes.isAnimating = false
		TopTimes.shown = true

	end

end


function TopTimes.AnimOut()

	local now = getTickCount()
	local elapsedTime = now - TopTimes.animStartTime
	local duration = TopTimes.animEndTime - TopTimes.animStartTime
	local progress = elapsedTime / duration

	TopTimes.posX, TopTimes.posY = interpolateBetween(TopTimes.endX, TopTimes.endY, 0, TopTimes.startX, TopTimes.startY, 0, progress, TopTimes.animation)

	if progress >= 1 then

		removeEventHandler("onClientRender", root, TopTimes.AnimOut)
		removeEventHandler("onClientRender", root, TopTimes.render)
		TopTimes.isAnimating = false
		TopTimes.shown = false

	end

end


function TopTimes.update(topTimeList, mapname)
	
	removeEventHandler("onClientRender", root, TopTimes.AnimOut)
	removeEventHandler("onClientRender", root, TopTimes.AnimIn)
	removeEventHandler("onClientRender", root, TopTimes.render)

	TopTimes.enabled = true
	TopTimes.shown = false
	TopTimes.isAnimating = false
	TopTimes.list = topTimeList
	TopTimes.mapName = mapname or "Unknown"
	TopTimes.show(true)
	TopTimes.hasLocalPlayer = false

end
addEvent("onClientTopTimesUpdate", true)
addEventHandler("onClientTopTimesUpdate", root, TopTimes.update)


function TopTimes.request()

	local arenaElement = getElementParent(localPlayer)

	if getElementData(arenaElement, "gamemode") ~= "Race" then return end
	
	local map = getElementData(arenaElement, "map")

	if not map then return end

	--if not getElementData(arenaElement, "toptimes") then return end
	
	triggerServerEvent("onPlayerRequestTopTimes", localPlayer)

end
addEvent("onClientPlayerReady", true)
addEvent("onClientPlayerTopTime", true)
addEventHandler("onClientPlayerReady", root, TopTimes.request)
addEventHandler("onClientPlayerTopTime", root, TopTimes.request)


function TopTimes.render()

	if not TopTimes.showOn then return end

	local arenaElement = getElementParent(localPlayer)

	local map = getElementData(arenaElement, "map")

	if not map then return end
	
	local color = getElementData(arenaElement, "color") or "000000"
	local r, g, b = TopTimes.hex2rgb(color)

	dxDrawRectangle(TopTimes.posX, TopTimes.posY, TopTimes.width, TopTimes.rowSize * TopTimes.tableHeadHeight, tocolor(0, 0, 0, 255))
	dxDrawRectangle(TopTimes.posX+1, TopTimes.posY+1, TopTimes.width-2, TopTimes.rowSize * TopTimes.tableHeadHeight-2, tocolor(r, g, b, 255))

	local header = TopTimes.dxClipTextToWidth("Top Times - "..TopTimes.mapName, TopTimes.width)

	dxDrawText(header, TopTimes.posX+1, TopTimes.posY+1, TopTimes.posX + TopTimes.width+1, TopTimes.posY + TopTimes.rowSize * TopTimes.tableHeadHeight+1, tocolor ( 0, 0, 0, 255 ), TopTimes.fontSize, TopTimes.font, "center", "center", false, false, false, false, false )
	dxDrawText(header, TopTimes.posX, TopTimes.posY, TopTimes.posX + TopTimes.width, TopTimes.posY + TopTimes.rowSize * TopTimes.tableHeadHeight, tocolor ( 255, 255, 255, 255 ), TopTimes.fontSize, TopTimes.font, "center", "center", false, false, false, false, false )

	local currentX = TopTimes.posX
	local currentY = TopTimes.posY + TopTimes.rowSize * TopTimes.tableHeadHeight + TopTimes.rowOffset

	for i, column in pairs(TopTimes.columns) do

		dxDrawRectangle(currentX, currentY, column.width, TopTimes.rowSize, tocolor ( 0, 0, 0, 130 ))
		dxDrawText(column.name, currentX+1, currentY+1, currentX+column.width+1, currentY + TopTimes.rowSize+1, tocolor ( 0, 0, 0, 255 ), TopTimes.fontSize, TopTimes.font, column.align, "center", false, false, false, false, false )
		dxDrawText(column.name, currentX, currentY, currentX+column.width, currentY + TopTimes.rowSize, tocolor ( 155, 155, 155, 255 ), TopTimes.fontSize, TopTimes.font, column.align, "center", false, false, false, false, false )
		currentX = currentX + column.width + TopTimes.columnOffset

	end

	for i=1, 10, 1 do

		currentX = TopTimes.posX
		currentY = currentY + TopTimes.rowSize + TopTimes.rowOffset
		localPlayerRow = false

		if TopTimes.list and TopTimes.list[i] then

			if TopTimes.list[i][2] == getPlayerName(localPlayer) then

				localPlayerRow = true
				TopTimes.hasLocalPlayer = true

			end

		end

		for j, column in pairs(TopTimes.columns) do

			local content = column.getData(i, TopTimes.list)
			content = TopTimes.dxClipTextToWidth(content, column.width)

			if localPlayerRow then

				dxDrawRectangle(currentX, currentY, column.width, TopTimes.rowSize, tocolor ( 0, 155, 0, 130 ))

			else

				dxDrawRectangle(currentX, currentY, column.width, TopTimes.rowSize, tocolor ( 0, 0, 0, 130 ))

			end

			dxDrawText(content:gsub('#%x%x%x%x%x%x', ''), currentX+1, currentY+1, currentX+column.width+1, currentY + TopTimes.rowSize+1, tocolor( 0, 0, 0, 255), TopTimes.fontSize, TopTimes.font, "center", "center", false, false, false, true, false )
			dxDrawText(content, currentX, currentY, currentX+column.width, currentY + TopTimes.rowSize, TopTimes.fontColor, TopTimes.fontSize, TopTimes.font, "center", "center", false, false, false, true, false )

			currentX = currentX + column.width + TopTimes.columnOffset

		end

	end

end


function TopTimes.createColumn(name, width, align, getData)

	table.insert(TopTimes.columns, {name = name, width = width, align = align, getData = getData})

end


function TopTimes.dxClipTextToWidth(text, width)

	while dxGetTextWidth(text, TopTimes.fontSize, TopTimes.font, true) > width do

		text = text:sub(1, #text-1)

	end

	return text

end


function TopTimes.hex2rgb(hex)

    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))

end


function TopTimes.toggle()

	TopTimes.showOn = not TopTimes.showOn

end
addCommandHandler("showtoptimes", TopTimes.toggle)