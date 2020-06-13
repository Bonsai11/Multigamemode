local Scoreboard = {}
Scoreboard.x, Scoreboard.y = guiGetScreenSize()
Scoreboard.relX, Scoreboard.relY = (Scoreboard.x/800), (Scoreboard.y/600)
Scoreboard.offset = 2 * Scoreboard.relY
Scoreboard.postGui = true
Scoreboard.font = nil
Scoreboard.fontBold = nil
Scoreboard.clanRowActive = false
Scoreboard.showClanRows = true
Scoreboard.hintText = "Hold RMB to scroll, click on a clan to change mode"

Scoreboard.titleFont = "clear"
Scoreboard.titleFontSize = 1
Scoreboard.titleFontColor = tocolor(255, 255, 255, 255)
Scoreboard.titleColor = tocolor(10, 10, 10, 250)
Scoreboard.titleHeight = dxGetFontHeight(Scoreboard.titleFontSize, Scoreboard.titleFont) * 2

Scoreboard.headerFont = "default-bold"
Scoreboard.headerFontSize = 1
Scoreboard.headerFontColor = tocolor(255, 255, 255, 255)
Scoreboard.headerColor = tocolor(10, 10, 10, 250)

Scoreboard.groupHeaderFont = "default-bold"
Scoreboard.groupHeaderFontSize = 1
Scoreboard.groupHeaderFontColor = tocolor(255, 255, 255, 255)
Scoreboard.groupHeaderColor = tocolor(20, 20, 20, 250)
Scoreboard.groupHeaderHighlightColor = tocolor(40, 40, 40, 250)

Scoreboard.groupFont = "default-bold"
Scoreboard.groupFontSize = 1
Scoreboard.groupFontColor = tocolor(255, 255, 255, 255)
Scoreboard.groupColor = tocolor(0, 0, 0, 180)
Scoreboard.groupHighlightColor = tocolor(15, 15, 15, 180)
Scoreboard.groupHighlightLocalplayerColor = tocolor(0, 10, 0, 180)

Scoreboard.clanHeaderFont = "default-bold"
Scoreboard.clanHeaderFontSize = 1
Scoreboard.clanHeaderFontColor = tocolor(255, 255, 255, 255)
Scoreboard.clanHeaderColor = tocolor(10, 10, 10, 240)
Scoreboard.clanHeaderHighlightColor = tocolor(20, 20, 20, 240)

Scoreboard.row = 0
Scoreboard.maxRows = nil
Scoreboard.scroll = 0
Scoreboard.scrollValue = 1
Scoreboard.scrollBarHeight = nil
Scoreboard.scrollBarWidth = 2 * Scoreboard.relY
Scoreboard.posY = nil
Scoreboard.showing = false
Scoreboard.serverInfo = {}
Scoreboard.columns = {}
Scoreboard.arenas = {}

Scoreboard.flags = {
	"AD", "AE", "AF", "AG", "AI", "AL", "AM", "AN", "AO", "AR", "AS", "AT", "AU", "AW", "AX", "AZ",
	"BA", "BB", "BD", "BE", "BF", "BG", "BH", "BI", "BJ", "BL", "BM", "BN", "BO", "BR", "BS", "BT",
	"BW", "BY", "BZ", "CA", "CD", "CF", "CG", "CH", "CI", "CK", "CL", "CM", "CN", "CO", "CR", "CU",
	"CV", "CW", "CY", "CZ", "DE", "DJ", "DK", "DM", "DO", "DZ", "EC", "EE", "EG", "EH", "ER", "ES",
	"ET", "EU", "FI", "FJ", "FK", "FM", "FO", "FR", "GA", "GB", "GD", "GE", "GG", "GH", "GI", "GL",
	"GM", "GN", "GQ", "GR", "GS", "GT", "GU", "GW", "GY", "HK", "HN", "HR", "HT", "HU", "IC", "ID",
	"IE", "IL", "IM", "IN", "IQ", "IR", "IS", "IT", "JE", "JM", "JO", "JP", "KE", "KG", "KH", "KI",
	"KM", "KN", "KP", "KR", "KW", "KY", "KZ", "LA", "LB", "LC", "LI", "LK", "LR", "LS", "LT", "LU",
	"LV", "LY", "MA", "MC", "MD", "ME", "MF", "MG", "MH", "MK", "ML", "MM", "MN", "MO", "MP", "MQ",
	"MR", "MS", "MT", "MU", "MV", "MW", "MX", "MY", "MZ", "NA", "NC", "NE", "NF", "NG", "NI", "NL",
	"NO", "NP", "NR", "NU", "NZ", "OM", "PA", "PE", "PF", "PG", "PH", "PK", "PL", "PN", "PR", "PS",
	"PT", "PW", "PY", "QA", "RO", "RS", "RU", "RW", "SA", "SB", "SC", "SD", "SE", "SG", "SH", "SI",
	"SK", "SL", "SM", "SN", "SO", "SR", "SS", "ST", "SV", "SY", "SZ", "TC", "TD", "TF", "TG", "TH",
	"TJ", "TK", "TL", "TM", "TN", "TO", "TR", "TT", "TV", "TW", "TZ", "UA", "UG", "US", "UY", "UZ",
	"VA", "VC", "VE", "VG", "VI", "VN", "VU", "WF", "WS", "YE", "YT", "ZA", "ZM", "ZW", "XX"
}

function Scoreboard.main()

	Scoreboard.addColumn(1, "ID", "id", 30, "center")
	Scoreboard.addColumn(2, "Name", "name", 200, "left")
	Scoreboard.addColumn(3, "Team", "team", 100, "left")
	Scoreboard.addColumn(4, "State", "state", 100, "left")
	Scoreboard.addColumn(5, "Country", "Country", 80, "left")
	Scoreboard.addColumn(6, "Local Time", "time", 80, "center")
	Scoreboard.addColumn(7, "FPS", "fps", 50, "center")
	Scoreboard.addColumn(8, "Ping", "ping", 50, "center")
	
	Scoreboard.font = dxCreateFont("RobotoCondensed-Regular.ttf", 10, false, "proof")
	Scoreboard.fontBold = dxCreateFont("RobotoCondensed-Regular.ttf", 10, true, "proof")

	if Scoreboard.font and Scoreboard.fontBold then
	
		Scoreboard.titleFont = Scoreboard.fontBold
		Scoreboard.headerFont = Scoreboard.font
		Scoreboard.groupHeaderFont = Scoreboard.font
		Scoreboard.groupFont = Scoreboard.font
		Scoreboard.clanHeaderFont = Scoreboard.font
		
	else
	
		Scoreboard.font = "default-bold"
		
	end
	
	Scoreboard.rowHeight = dxGetFontHeight(1, Scoreboard.font) * 1.75
	
	for i, flag in ipairs(Scoreboard.flags) do
	
		Scoreboard.flags[flag] = i-1
		
	end
	
	Scoreboard.maxRows = math.floor((Scoreboard.y * 0.9 - Scoreboard.titleHeight) / Scoreboard.rowHeight)
	
	bindKey("tab", "down", Scoreboard.show, true)
	
	bindKey("tab", "up", Scoreboard.show, false)

	triggerServerEvent("onRequestScoreboardInfo", localPlayer)

	triggerServerEvent("onRequestScoreboardArenas", localPlayer)

	Scoreboard.loadSettings()

	Scoreboard.toggleClanRows(Scoreboard.showClanRows)

end
addEventHandler("onClientResourceStart", resourceRoot, Scoreboard.main)


function Scoreboard.receiveInfo(serverInfo)

	Scoreboard.serverInfo = serverInfo

end
addEvent("onClientReceiveScoreboardInfo", true)
addEventHandler("onClientReceiveScoreboardInfo", root, Scoreboard.receiveInfo)


function Scoreboard.show(_, _, toggle)

	if toggle then
	
		Scoreboard.showing = true
		bindKey("mouse2", "both", Scoreboard.showCursor)
		
	else
	
		Scoreboard.showing = false
		unbindKey("mouse2", "both", Scoreboard.showCursor)
		showCursor(false)
		
	end

end


function Scoreboard.showCursor(_, state)

	if state == "down" then
		
		showCursor(true)
		
	else
	
		showCursor(false)
		
	end

end


function Scoreboard.key(button, pressOrRelease)

	if not Scoreboard.showing then return end

	if not pressOrRelease then return end
	
	if not isCursorShowing() then return end
	
	if button == "mouse_wheel_up" then
	
		Scoreboard.processScroll(true)
		
	elseif button == "mouse_wheel_down" then
	
		Scoreboard.processScroll(false)

	elseif button == "mouse1" then
	
		for i, arena in pairs(Scoreboard.arenas) do

			if arena.selected then
			
				arena.hidden = not arena.hidden
				
			end

		end
		
		if Scoreboard.clanRowActive then
		
			Scoreboard.toggleClanRows(not Scoreboard.showClanRows)
			
			Scoreboard.saveSettings()
			
		end

	end

end
addEventHandler("onClientKey", root, Scoreboard.key)
	

function Scoreboard.addColumn(position, name, data, width, align)

	table.insert(Scoreboard.columns, position, {name = name, data = data, width = width * Scoreboard.relY, align = align})

end


function Scoreboard.removeColumn(name)

	for i, column in pairs(Scoreboard.columns) do
	
		if column.name == name then
		
			table.remove(Scoreboard.columns, i)
			break
			
		end

	end

end


function Scoreboard.toggleClanRows(toggle)

	if toggle then
	
		Scoreboard.showClanRows = true
		Scoreboard.removeColumn("Clan")
		
	else
	
		Scoreboard.showClanRows = false
		Scoreboard.addColumn(7, "Clan", "clan", 100, "left")
			
	end

	Scoreboard.clanRowActive = false
	
end


function Scoreboard.adjustScroll()

	if Scoreboard.scroll > Scoreboard.getScoreboardRowCount() - Scoreboard.maxRows then
	
		Scoreboard.scroll = math.max(0, Scoreboard.getScoreboardRowCount() - Scoreboard.maxRows)

	end

end


function Scoreboard.processScroll(direction)

	if direction then
	
		Scoreboard.scroll = Scoreboard.scroll - Scoreboard.scrollValue
		
	else
	
		Scoreboard.scroll = Scoreboard.scroll + Scoreboard.scrollValue

	end	

	if Scoreboard.scroll < 0 then
	
		Scoreboard.scroll = 0
		
	elseif Scoreboard.scroll > Scoreboard.getScoreboardRowCount() - Scoreboard.maxRows then
		
		Scoreboard.scroll = Scoreboard.getScoreboardRowCount() - Scoreboard.maxRows
		
	end

end


function Scoreboard.getScoreboardWidth()

	local width = 0

	for i, column in pairs(Scoreboard.columns) do

		width = width + column.width
		
	end
	
	return width

end


function Scoreboard.getScoreboardHeight()

	local height = Scoreboard.titleHeight
	local rows = 1

	for i, arena in pairs(Scoreboard.arenas) do

		height = height + Scoreboard.rowHeight
		rows = rows + 1
		
		if rows > Scoreboard.maxRows then
		
			return height
			
		end
		
		height = height + Scoreboard.rowHeight
		rows = rows + 1

		if rows > Scoreboard.maxRows then
		
			return height
			
		end

		for i, player in pairs(getElementsByType("player")) do

			if getElementData(player, "Arena") == getElementData(arena.arenaElement, "name") then
					
				height = height + Scoreboard.rowHeight
				rows = rows + 1
				
				if rows > Scoreboard.maxRows then
				
					return height
					
				end
			
			end
			
		end
		
		if Scoreboard.showClanRows then
		
			for clan, players in pairs(Scoreboard.getClansInArena(arena)) do
			
				if not arena.hidden then
					
					height = height + Scoreboard.rowHeight
					rows = rows + 1
				
				end
		
			end
		
		end
	
	end
	
	return height

end


function Scoreboard.getScoreboardRowCount()

	local rows = 0

	for i, arena in pairs(Scoreboard.arenas) do
	
		rows = rows + 1

		if not arena.hidden then
		
			rows = rows + 1
		
		end

		for i, player in pairs(getElementsByType("player")) do

			if getElementData(player, "Arena") == getElementData(arena.arenaElement, "name") then
			
				if not arena.hidden then
			
					rows = rows + 1

				end
			
			end
			
		end
		
		if Scoreboard.showClanRows then
		
			for clan, players in pairs(Scoreboard.getClansInArena(arena)) do
			
				if not arena.hidden then
					
					rows = rows + 1
				
				end
		
			end
		
		end
	
	end
	
	return rows

end


function Scoreboard.render()

	if not Scoreboard.showing then return end
	if Scoreboard.debug then outputDebugString("1: "..getTickCount()) end
	if not getKeyState("tab") then

		Scoreboard.show(nil, nil, false)
		return
		
	end

	Scoreboard.clanRowActive = false

	Scoreboard.width = Scoreboard.getScoreboardWidth()
	
	Scoreboard.posX = Scoreboard.x / 2 - Scoreboard.width / 2

	Scoreboard.height = Scoreboard.getScoreboardHeight()

	Scoreboard.posY = Scoreboard.y / 2 - Scoreboard.height / 2	

	Scoreboard.adjustScroll()

	local startPosY = Scoreboard.posY

	Scoreboard.row = 0

	dxDrawRectangle(Scoreboard.posX, Scoreboard.posY, Scoreboard.width, Scoreboard.titleHeight, Scoreboard.titleColor, Scoreboard.postGui)
	dxDrawText(Scoreboard.serverInfo[1], Scoreboard.posX + Scoreboard.offset, Scoreboard.posY, Scoreboard.posX + Scoreboard.width - Scoreboard.offset * 2, Scoreboard.posY + Scoreboard.titleHeight, Scoreboard.titleFontColor, Scoreboard.titleFontSize, Scoreboard.titleFont, "left", "center", false, false, Scoreboard.postGui)
	
	local playerCount =  "" .. string.format("%."..string.len(Scoreboard.serverInfo[2]).."i", #getElementsByType("player")).."/"..string.format("%."..string.len(Scoreboard.serverInfo[2]).."i", Scoreboard.serverInfo[2])
	
	dxDrawText(playerCount, Scoreboard.posX + Scoreboard.offset, Scoreboard.posY, Scoreboard.posX + Scoreboard.width - Scoreboard.offset * 2, Scoreboard.posY + Scoreboard.titleHeight, Scoreboard.titleFontColor, Scoreboard.titleFontSize, Scoreboard.titleFont, "right", "center", false, false, Scoreboard.postGui)
	
	Scoreboard.posY = Scoreboard.posY + Scoreboard.titleHeight
	if Scoreboard.debug then outputDebugString("2: "..getTickCount()) end
	local posX = Scoreboard.posX
	
	for i, arena in pairs(Scoreboard.arenas) do
		if Scoreboard.debug then outputDebugString("1: "..getElementData(arena.arenaElement, "alias")..": "..getTickCount()) end
		Scoreboard.row = Scoreboard.row + 1
	
		Scoreboard.drawGroupHeaderRow(arena)

		if not arena.hidden then
		
			Scoreboard.row = Scoreboard.row + 1
			
			Scoreboard.drawColumnHeaderRow()
		
		end
		if Scoreboard.debug then outputDebugString("2: "..getElementData(arena.arenaElement, "alias")..": "..getTickCount()) end
		for i, player in pairs(getElementsByType("player")) do
		
			if getElementData(player, "Arena") == getElementData(arena.arenaElement, "name") then
		
				if not arena.hidden then
		
					if not Scoreboard.showClanRows or (Scoreboard.showClanRows and not getElementData(player, "clan")) then
		
						Scoreboard.row = Scoreboard.row + 1
		
						Scoreboard.drawGroupRow(player)
						
					end
				
				end
				
			end
	
		end
		if Scoreboard.debug then outputDebugString("3: "..getElementData(arena.arenaElement, "alias")..": "..getTickCount()) end
		if Scoreboard.showClanRows then
		
			for clan, players in pairs(Scoreboard.getClansInArena(arena)) do
			
				if not arena.hidden then

					Scoreboard.row = Scoreboard.row + 1

					Scoreboard.drawClanHeaderRow(clan)
					
					for i, player in pairs(players) do
					
						Scoreboard.row = Scoreboard.row + 1
			
						Scoreboard.drawGroupRow(player)
							
					end
				
				end
		
			end
		
		end
		if Scoreboard.debug then outputDebugString("4: "..getElementData(arena.arenaElement, "alias")..": "..getTickCount()) end
	end
	
	dxDrawText(Scoreboard.hintText , Scoreboard.posX, Scoreboard.posY, Scoreboard.posX + Scoreboard.width, Scoreboard.posY + Scoreboard.rowHeight, Scoreboard.groupFontColor, Scoreboard.groupFontSize, Scoreboard.groupFont, "center", "center", false, false, Scoreboard.postGui)
	if Scoreboard.debug then outputDebugString("3: "..getTickCount()) end
	if Scoreboard.getScoreboardRowCount() > Scoreboard.maxRows then
	
		local scrollPercent =  Scoreboard.scroll / (Scoreboard.getScoreboardRowCount() - Scoreboard.maxRows)
		
		Scoreboard.scrollBarHeight = Scoreboard.height * (Scoreboard.maxRows / Scoreboard.getScoreboardRowCount())
		
		dxDrawRectangle(Scoreboard.posX + Scoreboard.getScoreboardWidth() - Scoreboard.scrollBarWidth, startPosY + Scoreboard.titleHeight + (Scoreboard.height - Scoreboard.titleHeight - Scoreboard.scrollBarHeight) * scrollPercent, Scoreboard.scrollBarWidth, Scoreboard.scrollBarHeight, tocolor(255, 255, 255, 255), Scoreboard.postGui)

	end
	if Scoreboard.debug then outputDebugString("4: "..getTickCount()) end
end
addEventHandler("onClientRender", root, Scoreboard.render)


function Scoreboard.drawGroupHeaderRow(arena)
			
	if Scoreboard.row - Scoreboard.scroll > Scoreboard.maxRows then return end

	if Scoreboard.row - Scoreboard.scroll <= 0 then return end

	local posX = Scoreboard.posX

	local name = getElementData(arena.arenaElement, "alias")

	local map = getElementData(arena.arenaElement, "map")
	
	local groupHeader = name
	
	if name ~= "Lobby" and name ~= "Training" then

		groupHeader = groupHeader.." ["..getElementData(arena.arenaElement, "players" ).."/"..getElementData(arena.arenaElement, "maxplayers" ).."]"
	
	end
	
	if map then
	
		groupHeader = groupHeader.." - "..map.name
		
	end

	if arena.hidden then
	
		groupHeader = "+ "..groupHeader
	
	end

	if Scoreboard.mouseCheck(Scoreboard.posX, Scoreboard.posY, Scoreboard.width, Scoreboard.rowHeight) then
	
		dxDrawRectangle(posX, Scoreboard.posY, Scoreboard.width, Scoreboard.rowHeight, Scoreboard.groupHeaderHighlightColor, Scoreboard.postGui)
		arena.selected = true
		
	else

		dxDrawRectangle(posX, Scoreboard.posY, Scoreboard.width, Scoreboard.rowHeight, Scoreboard.groupHeaderColor, Scoreboard.postGui)
		arena.selected = false
	
	end
	
	dxDrawText(groupHeader, posX + Scoreboard.offset, Scoreboard.posY, posX + Scoreboard.width - Scoreboard.offset * 2, Scoreboard.posY + Scoreboard.rowHeight, Scoreboard.groupHeaderFontColor, Scoreboard.groupHeaderFontSize, Scoreboard.groupHeaderFont, "left", "center", false, false, Scoreboard.postGui)

	Scoreboard.posY = Scoreboard.posY + Scoreboard.rowHeight

end


function Scoreboard.drawGroupRow(player)
			
	if Scoreboard.row - Scoreboard.scroll > Scoreboard.maxRows then return end

	if Scoreboard.row - Scoreboard.scroll <= 0 then return end

	local posX = Scoreboard.posX

	for i, column in pairs(Scoreboard.columns) do
		
		if Scoreboard.mouseCheck(Scoreboard.posX, Scoreboard.posY, Scoreboard.width, Scoreboard.rowHeight) then
		
			dxDrawRectangle(posX, Scoreboard.posY, column.width, Scoreboard.rowHeight, Scoreboard.groupHighlightColor, Scoreboard.postGui)

		else
		
			if player == localPlayer then
			
				dxDrawRectangle(posX, Scoreboard.posY, column.width, Scoreboard.rowHeight, Scoreboard.groupHighlightLocalplayerColor, Scoreboard.postGui)
			
			else
			
				dxDrawRectangle(posX, Scoreboard.posY, column.width, Scoreboard.rowHeight, Scoreboard.groupColor, Scoreboard.postGui)

			end

		end

		local content
		local textOffset = 0

		local r, g, b = 255, 255, 255

		if column.name == "Name" then
		
			content = getPlayerName(player)
			
			local suffix = ""
		
			if not getElementData(player, "account") then
			
				suffix = " #ffffff(Guest)"
				
			end	
			
			if getElementData(player, "Spectator") then
			
				suffix = suffix.." #ffffff(Spectator)"
				
			end	
		
			content = Scoreboard.textOverflow(content, suffix, Scoreboard.groupFontSize, Scoreboard.groupFont, column.width)..suffix
		
		elseif column.name == "Team" then
		
			local team = getPlayerTeam(player)
				
			if team then 
			
				content = getTeamName(team)
				
				r, g, b = getTeamColor(team)
				
			else
			
				content = ""
				
			end

		elseif column.name == "State" then
		
			if getElementData(player, "racestate") then
			
				content = getElementData(player, "racestate")
				
			else
			
				content = getElementData(player, column.data)
				
			end
										
		elseif column.name == "Country" then
		
			content = getElementData(player, 'Country')
			
			if content then
			
				local flagIndex = Scoreboard.flags[content]
				local flagRow = flagIndex % 16
				local flagColumn = math.floor(flagIndex / 16)
				textOffset = Scoreboard.rowHeight
				
				dxDrawImageSection(posX, Scoreboard.posY, Scoreboard.rowHeight - 2, Scoreboard.rowHeight - 2, 48 * flagRow, 48 * flagColumn, 48, 48, ":CCS/img/flags.png", 0, 0, 0, tocolor(255, 255, 255, 255), Scoreboard.postGui)
		
			else
			
				content = ""
				
			end
			
		elseif column.name == "Clan" then
		
			content = getElementData(player, column.data) or ""
		
			content = Scoreboard.textOverflow(content, "", Scoreboard.groupFontSize, Scoreboard.groupFont, column.width)
			
		elseif column.name == "Ping" then
		
			content = getPlayerPing(player)
			
			r, g, b = Scoreboard.getColor(content, 500, true)
			
		elseif column.name == "FPS" then
		
			content = getElementData(player, column.data) or 0
			
			r, g, b = Scoreboard.getColor(content, 60, false)
			
		else
		
			content = getElementData(player, column.data) or ""
	
		end
	
		content = tostring(content)
	
		if Scoreboard.mouseCheck(posX, Scoreboard.posY, column.width, Scoreboard.rowHeight) then
		
			dxDrawText(content:gsub("#%x%x%x%x%x%x", ""), posX + Scoreboard.offset + textOffset, Scoreboard.posY, posX + column.width - Scoreboard.offset * 2, Scoreboard.posY + Scoreboard.rowHeight, tocolor(255, 255, 255, 255), Scoreboard.groupFontSize, Scoreboard.groupFont, column.align, "center", false, false, Scoreboard.postGui, true)
	
			if column.name == "Clan" then
			
				Scoreboard.clanRowActive = true
	
			end
	
		else
		
			dxDrawText(content, posX + Scoreboard.offset + textOffset, Scoreboard.posY, posX + column.width - Scoreboard.offset * 2, Scoreboard.posY + Scoreboard.rowHeight, tocolor(r, g, b, 255), Scoreboard.groupFontSize, Scoreboard.groupFont, column.align, "center", false, false, Scoreboard.postGui, true)
	
		end
	
		posX = posX + column.width
		
	end

	posX = Scoreboard.posX

	Scoreboard.posY = Scoreboard.posY + Scoreboard.rowHeight

end


function Scoreboard.drawColumnHeaderRow()

	if Scoreboard.row - Scoreboard.scroll > Scoreboard.maxRows then return end

	if Scoreboard.row - Scoreboard.scroll <= 0 then return end

	local posX = Scoreboard.posX

	for i, column in pairs(Scoreboard.columns) do

		dxDrawRectangle(posX, Scoreboard.posY, column.width, Scoreboard.rowHeight, Scoreboard.headerColor, Scoreboard.postGui)
		dxDrawText(column.name, posX + Scoreboard.offset, Scoreboard.posY, posX + column.width - Scoreboard.offset * 2, Scoreboard.posY + Scoreboard.rowHeight, Scoreboard.headerFontColor, Scoreboard.headerFontSize, Scoreboard.headerFont, column.align, "center", false, false, Scoreboard.postGui)
		
		posX = posX + column.width
		
	end
	
	posX = Scoreboard.posX
	
	Scoreboard.posY = Scoreboard.posY + Scoreboard.rowHeight

end


function Scoreboard.drawClanHeaderRow(clan)
			
	if Scoreboard.row - Scoreboard.scroll > Scoreboard.maxRows then return end

	if Scoreboard.row - Scoreboard.scroll <= 0 then return end

	local posX = Scoreboard.posX
	
	if Scoreboard.mouseCheck(Scoreboard.posX, Scoreboard.posY, Scoreboard.width, Scoreboard.rowHeight) then
	
		dxDrawRectangle(posX, Scoreboard.posY, Scoreboard.width, Scoreboard.rowHeight, Scoreboard.clanHeaderHighlightColor, Scoreboard.postGui)
		dxDrawText(clan:gsub("#%x%x%x%x%x%x", ""), posX + Scoreboard.offset, Scoreboard.posY, posX + Scoreboard.width- Scoreboard.offset * 2, Scoreboard.posY + Scoreboard.rowHeight, tocolor(255, 255, 255, 255), Scoreboard.clanHeaderFontSize, Scoreboard.clanHeaderFont, "left", "center", false, false, Scoreboard.postGui, true)
		Scoreboard.clanRowActive = true
		
	else
	
		dxDrawRectangle(posX, Scoreboard.posY, Scoreboard.width, Scoreboard.rowHeight, Scoreboard.clanHeaderColor, Scoreboard.postGui)
		dxDrawBorderedText(1, clan, posX + Scoreboard.offset, Scoreboard.posY, posX + Scoreboard.width- Scoreboard.offset * 2, Scoreboard.posY + Scoreboard.rowHeight, Scoreboard.clanHeaderFontColor, Scoreboard.clanHeaderFontSize, Scoreboard.clanHeaderFont, "left", "center", false, false, Scoreboard.postGui, true)
		
	end
	
	Scoreboard.posY = Scoreboard.posY + Scoreboard.rowHeight

end


function Scoreboard.getClansInArena(arena)

	local clans = {}

	for i, player in pairs(getElementsByType("player")) do
	
		if getElementData(player, "Arena") == getElementData(arena.arenaElement, "name") then
	
			local clan = getElementData(player, "clan")
		
			if clan then
			
				if not clans[clan] then
				
					clans[clan] = {}
					
				end
			
				table.insert(clans[clan], player)
				
			end
		
		end
		
	end
	
	return clans

end


function Scoreboard.fetch(arenas)

	for i, arenaElement in pairs(arenas) do

		table.insert(Scoreboard.arenas, {arenaElement = arenaElement, selected = false, hidden = false})

	end

end
addEvent("onClientReceiveScoreboardArenas", true)
addEventHandler("onClientReceiveScoreboardArenas", root, Scoreboard.fetch)


function Scoreboard.arenaCreate()

	if getElementData(source, "inScoreboard") then
		
		table.insert(Scoreboard.arenas, {arenaElement = source, selected = false, hidden = false})
		
	end

end
addEvent("onClientArenaCreate", true)
addEventHandler("onClientArenaCreate", root, Scoreboard.arenaCreate)
Scoreboard.debug = false
addCommandHandler("scorea", function() Scoreboard.debug = false outputDebugString(#Scoreboard.arenas) end)
addCommandHandler("scoreb", function() Scoreboard.debug = true outputDebugString(#Scoreboard.arenas) end)

function Scoreboard.arenaDestroy()

	for i, arena in pairs(Scoreboard.arenas) do
	
		if arena.arenaElement == source then
		
			table.remove(Scoreboard.arenas, i)
			break
		
		end
		
	end

end
addEvent("onClientArenaDestroy", true)
addEventHandler("onClientArenaDestroy", root, Scoreboard.arenaDestroy)


function Scoreboard.getColor(value, maxValue, minOrMax)

	local r, g, b, n

	n = (tonumber(value) / maxValue) * 100
	n = math.abs(n - 100)
	n = math.min(100, n)
	n = math.max(0, n)
	
	if minOrMax then
	
		r = (255 * (100 - n)) / 100 
		g = (255 * n) / 100
		
	else
	
		r = (255 * n) / 100
		g = (255 * (100 - n)) / 100 
	
	end
	
	b = 0
	
	return r, g, b
						
end


function Scoreboard.mouseCheck(posX, posY, width, height)
	
	local mouseX, mouseY = getCursorPosition()
	
	if not mouseX then return false end
	
	mouseX = mouseX * Scoreboard.x
	mouseY = mouseY * Scoreboard.y

	if mouseX < posX or mouseX > posX + width then return false end

	if mouseY < posY or mouseY > posY + height then return false end

	return true

end


function Scoreboard.textOverflow(text, suffix, size, font, width)

	while dxGetTextWidth(text..suffix, size, font, true) > width do
	
		text = text:sub(1, text:len()-4).."..."

	end

	return text
	
end


function Scoreboard.loadSettings()
	
	if not fileExists("@settings.xml") then
		
		Scoreboard.createSettingsFile()
		
	end
	
	local settingsXML = xmlLoadFile("@settings.xml")
	
	if not settingsXML then return end
	
	local showClanRowsNode = xmlFindChild(settingsXML, "showClanRows", 0)

	if not showClanRowsNode then

		Scoreboard.createSettingsFile()
		
	else
	
		Scoreboard.showClanRows = xmlNodeGetAttribute(showClanRowsNode, "enabled") == "true"

	end
	
	xmlUnloadFile(settingsXML)
	
end


function Scoreboard.saveSettings()

	local settingsXML = xmlLoadFile("@settings.xml")
	
	if not settingsXML then return end

	local showClanRowsNode = xmlFindChild(settingsXML, "showClanRows", 0)

	if not showClanRowsNode then

		Scoreboard.createSettingsFile()
		
	end	
	
	xmlNodeSetAttribute(showClanRowsNode, "enabled", tostring(Scoreboard.showClanRows))

	xmlSaveFile(settingsXML)
	xmlUnloadFile(settingsXML)

end


function Scoreboard.createSettingsFile()

	if fileExists("@settings.xml") then
	
		fileDelete("@settings.xml")
		
	end

	local settingsXML = xmlCreateFile("@settings.xml", "settings")
	xmlNodeSetAttribute(xmlCreateChild(settingsXML, "showClanRows"), "enabled", "true")
	xmlSaveFile(settingsXML)
	xmlUnloadFile(settingsXML)
		
end


function dxDrawBorderedText(outline, text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)

    local end1 = 1
    local outlinetext = text
	
    for word in outlinetext:gmatch("#%x%x%x%x%x%x") do 
	
        local startpos, endpos = outlinetext:find(word, end1)
        end1 = endpos
        local red, green, blue = getColorFromString(word)
        ans = math.sqrt(0.299*(red*red) + 0.587*(green*green)+0.144*(blue*blue))
		
        if ans  > 127.5 then
		
            outlinetext = utf8.remove(outlinetext, startpos, endpos)
            outlinetext = utf8.insert(outlinetext, startpos, "#000000")
			
        else
		
            outlinetext = utf8.remove(outlinetext, startpos, endpos)
            outlinetext = utf8.insert(outlinetext, startpos, "#FFFFFF")
			
        end
		
    end
	
    for oX = (outline * -1), outline do
	
        for oY = (outline * -1), outline do
		
            dxDrawText (outlinetext, left + oX, top + oY, right + oX, bottom + oY, tocolor(0, 0, 0, 255), scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, true, fRotation, fRotationCenterX, fRotationCenterY)
       
	   end
		
    end
	
    dxDrawText (text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
	
end