TopKills = {}
TopKills.x, TopKills.y = guiGetScreenSize()
TopKills.relX, TopKills.relY = (TopKills.x/800), (TopKills.y/600)
TopKills.shown = false
TopKills.startX = 800*TopKills.relX
TopKills.startY = 200*TopKills.relY
TopKills.posX = TopKills.startX
TopKills.posY = TopKills.startY
TopKills.fontSize = 1
TopKills.font = "default-bold"
TopKills.fontColor = tocolor(255, 255, 255, 255)
TopKills.animation = "InOutBack"
TopKills.rowSize = dxGetFontHeight(TopKills.fontSize, TopKills.font)
TopKills.width = 0
TopKills.columnOffset = 1
TopKills.rowOffset = 1
TopKills.tableHeadHeight = 1.4
TopKills.offset = 20*TopKills.relY
TopKills.endY = TopKills.startY
TopKills.timer = nil
TopKills.list = {}
TopKills.myTop = {}
TopKills.isAnimating = false
TopKills.animStartTime = nil
TopKills.endTime = nil
TopKills.hasLocalPlayer = false
TopKills.columns = {}
TopKills.enabled = false
TopKills.showOn = true

function TopKills.main()

	TopKills.createColumn("#", dxGetTextWidth("_XX_", TopKills.fontSize, TopKills.font), "center", function(i, rowData) if not rowData[i] then return "" end return rowData[i][1].."." or "" end)
	TopKills.createColumn(" Name", dxGetTextWidth("_XXXXXXXXXX_", TopKills.fontSize, TopKills.font), "left", function(i, rowData) if not rowData[i] then return "" end return rowData[i][2] or "" end)
	TopKills.createColumn(" Kills", dxGetTextWidth("_00:00:000_", TopKills.fontSize, TopKills.font), "left", function(i, rowData) if not rowData[i] then return "" end  return rowData[i][3] or "" end)
	TopKills.createColumn(" Date", dxGetTextWidth("_XXXX.XX.XX_XX:XX:XX", TopKills.fontSize, TopKills.font), "left", function(i, rowData) if not rowData[i] then return "" end  return rowData[i][4] or "" end)
	TopKills.createColumn(" Arena", dxGetTextWidth("_XXXXXXXXXX_", TopKills.fontSize, TopKills.font), "left",
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

	for i, column in pairs(TopKills.columns) do

		TopKills.width = TopKills.width + column.width + TopKills.columnOffset

	end

	TopKills.width = TopKills.width - TopKills.columnOffset
	TopKills.endX = TopKills.startX - TopKills.width-TopKills.offset

end
addEventHandler("onClientResourceStart", resourceRoot, TopKills.main)


function TopKills.reset()

	TopKills.shown = false
	if isTimer(TopKills.timer) then killTimer(TopKills.timer) end
	removeEventHandler("onClientRender", root, TopKills.render)
	removeEventHandler("onClientRender", root, TopKills.AnimIn)
	removeEventHandler("onClientRender", root, TopKills.AnimOut)
	TopKills.enabled = false

end
addEvent("onClientArenaReset", true)
addEventHandler("onClientArenaReset", localPlayer, TopKills.reset)


function TopKills.show(state)

	if not TopKills.enabled then return end

	if TopKills.isAnimating then return end

	if isTimer(TopKills.timer) then killTimer(TopKills.timer) end

	TopKills.animStartTime = getTickCount()
	TopKills.animEndTime = TopKills.animStartTime + 1000

	if state then

		TopKills.isAnimating = true
		addEventHandler("onClientRender", root, TopKills.AnimIn)
		addEventHandler("onClientRender", root, TopKills.render)
		TopKills.timer = setTimer(TopKills.show, 5000, 1, false)

	elseif not state then

		TopKills.isAnimating = true
		addEventHandler("onClientRender", root, TopKills.AnimOut)

	end

end


function TopKills.toggle()

	TopKills.show(not TopKills.shown)

end
bindKey("F5", "down", TopKills.toggle)


function TopKills.AnimIn()

	local now = getTickCount()
	local elapsedTime = now - TopKills.animStartTime
	local duration = TopKills.animEndTime - TopKills.animStartTime
	local progress = elapsedTime / duration

	TopKills.posX, TopKills.posY = interpolateBetween(TopKills.startX, TopKills.startY, 0, TopKills.endX, TopKills.endY, 0, progress, TopKills.animation)

	if progress >= 1 then

		removeEventHandler("onClientRender", root, TopKills.AnimIn)
		TopKills.isAnimating = false
		TopKills.shown = true

	end

end


function TopKills.AnimOut()

	local now = getTickCount()
	local elapsedTime = now - TopKills.animStartTime
	local duration = TopKills.animEndTime - TopKills.animStartTime
	local progress = elapsedTime / duration

	TopKills.posX, TopKills.posY = interpolateBetween(TopKills.endX, TopKills.endY, 0, TopKills.startX, TopKills.startY, 0, progress, TopKills.animation)

	if progress >= 1 then

		removeEventHandler("onClientRender", root, TopKills.AnimOut)
		removeEventHandler("onClientRender", root, TopKills.render)
		TopKills.isAnimating = false
		TopKills.shown = false

	end

end


function TopKills.update(topTimeList, mapname)

	removeEventHandler("onClientRender", root, TopKills.AnimOut)
	removeEventHandler("onClientRender", root, TopKills.AnimIn)
	removeEventHandler("onClientRender", root, TopKills.render)

	TopKills.enabled = true
	TopKills.shown = false
	TopKills.isAnimating = false
	TopKills.list = topTimeList
	TopKills.mapName = mapname or "Unknown"
	TopKills.show(true)
	TopKills.hasLocalPlayer = false

end
addEvent("onClientTopKillsUpdate", true)
addEventHandler("onClientTopKillsUpdate", root, TopKills.update)


function TopKills.request()

	local arenaElement = getElementParent(localPlayer)

	if getElementData(arenaElement, "gamemode") ~= "Race" then return end	
	
	local map = getElementData(arenaElement, "map")

	if not map then return end

	--if not getElementData(arenaElement, "topkills") then return end

	triggerServerEvent("onPlayerRequestTopKills", localPlayer)

end
addEvent("onClientPlayerReady", true)
addEvent("onClientPlayerTopKill", true)
addEventHandler("onClientPlayerReady", root, TopKills.request)
addEventHandler("onClientPlayerTopKill", root, TopKills.request)


function TopKills.render()

	if not TopKills.showOn then return end

	local arenaElement = getElementParent(localPlayer)

	local map = getElementData(arenaElement, "map")

	if not map then return end

	local color = getElementData(arenaElement, "color") or "000000"
	local r, g, b = TopKills.hex2rgb(color)

	dxDrawRectangle(TopKills.posX, TopKills.posY, TopKills.width, TopKills.rowSize * TopKills.tableHeadHeight, tocolor(0, 0, 0, 255))
	dxDrawRectangle(TopKills.posX+1, TopKills.posY+1, TopKills.width-2, TopKills.rowSize * TopKills.tableHeadHeight-2, tocolor(r, g, b, 255))

	local header = TopKills.dxClipTextToWidth("Top Kills - "..TopKills.mapName, TopKills.width)


	dxDrawText(header, TopKills.posX+1, TopKills.posY+1, TopKills.posX + TopKills.width+1, TopKills.posY + TopKills.rowSize * TopKills.tableHeadHeight+1, tocolor ( 0, 0, 0, 255 ), TopKills.fontSize, TopKills.font, "center", "center", false, false, false, false, false )
	dxDrawText(header, TopKills.posX, TopKills.posY, TopKills.posX + TopKills.width, TopKills.posY + TopKills.rowSize * TopKills.tableHeadHeight, tocolor ( 255, 255, 255, 255 ), TopKills.fontSize, TopKills.font, "center", "center", false, false, false, false, false )

	local currentX = TopKills.posX
	local currentY = TopKills.posY + TopKills.rowSize * TopKills.tableHeadHeight + TopKills.rowOffset

	for i, column in pairs(TopKills.columns) do

		dxDrawRectangle(currentX, currentY, column.width, TopKills.rowSize, tocolor ( 0, 0, 0, 130 ))
		dxDrawText(column.name, currentX+1, currentY+1, currentX+column.width+1, currentY + TopKills.rowSize+1, tocolor ( 0, 0, 0, 255 ), TopKills.fontSize, TopKills.font, column.align, "center", false, false, false, false, false )
		dxDrawText(column.name, currentX, currentY, currentX+column.width, currentY + TopKills.rowSize, tocolor ( 155, 155, 155, 255 ), TopKills.fontSize, TopKills.font, column.align, "center", false, false, false, false, false )
		currentX = currentX + column.width + TopKills.columnOffset

	end

	for i=1, 10, 1 do

		currentX = TopKills.posX
		currentY = currentY + TopKills.rowSize + TopKills.rowOffset
		localPlayerRow = false

		if TopKills.list and TopKills.list[i] then

			if TopKills.list[i][2] == getPlayerName(localPlayer) then

				localPlayerRow = true
				TopKills.hasLocalPlayer = true

			end

		end

		for j, column in pairs(TopKills.columns) do

			local content = column.getData(i, TopKills.list)
			content = TopKills.dxClipTextToWidth(content, column.width)

			if localPlayerRow then

				dxDrawRectangle(currentX, currentY, column.width, TopKills.rowSize, tocolor ( 0, 155, 0, 130 ))

			else

				dxDrawRectangle(currentX, currentY, column.width, TopKills.rowSize, tocolor ( 0, 0, 0, 130 ))

			end

			dxDrawText(content:gsub('#%x%x%x%x%x%x', ''), currentX+1, currentY+1, currentX+column.width+1, currentY + TopKills.rowSize+1, tocolor( 0, 0, 0, 255), TopKills.fontSize, TopKills.font, "center", "center", false, false, false, true, false )
			dxDrawText(content, currentX, currentY, currentX+column.width, currentY + TopKills.rowSize, TopKills.fontColor, TopKills.fontSize, TopKills.font, "center", "center", false, false, false, true, false )

			currentX = currentX + column.width + TopKills.columnOffset

		end

	end

end


function TopKills.createColumn(name, width, align, getData)

	table.insert(TopKills.columns, {name = name, width = width, align = align, getData = getData})

end


function TopKills.dxClipTextToWidth(text, width)

	while dxGetTextWidth(text, TopKills.fontSize, TopKills.font, true) > width do

		text = text:sub(1, #text-1)

	end

	return text

end


function TopKills.hex2rgb(hex)

    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))

end


function TopKills.toggle()

	TopKills.showOn = not TopKills.showOn

end
addCommandHandler("showtopkills", TopKills.toggle)