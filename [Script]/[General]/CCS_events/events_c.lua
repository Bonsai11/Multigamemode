Events = {}
Events.x, Events.y = guiGetScreenSize()
Events.relX, Events.relY =  (Events.x/800), (Events.y/600)
Events.gui = {}
Events.gui.teamSelects = {}
Events.data = nil
Events.shown = true
Events.cursor = false

--Font
Events.fontSize = 1
Events.font = "default-bold"
Events.fontColor = tocolor ( 255, 255, 255, 255 )
Events.rowSize = dxGetFontHeight(Events.fontSize, Events.font) * 1.5

--Other
Events.backgroundColor = tocolor(0, 0, 0, 100)
Events.normalRowWidth = dxGetTextWidth(" XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ", Events.fontSize, Events.font)
Events.offset = (2 * Events.relY)
Events.positionX = Events.x - Events.normalRowWidth - Events.offset
Events.positionY = Events.y / 2
Events.currentPositionY = Events.positionY
Events.height = 0
Events.positioning = false

function Events.main()

    Events.gui.window = guiCreateWindow((Events.x - 350) / 2, (Events.y - 400) / 2, 350, 400, "Events Panel", false)
    guiSetVisible(Events.gui.window, false)
    guiWindowSetMovable(Events.gui.window, true)
    guiWindowSetSizable(Events.gui.window, false)

	Events.gui.saveButton = guiCreateButton(50, 370, 70, 20, "Save", false, Events.gui.window)
	
	Events.gui.resetButton = guiCreateButton(140, 370, 70, 20, "Reset", false, Events.gui.window)	
	
	Events.gui.closeButton = guiCreateButton(230, 370, 70, 20, "Close", false, Events.gui.window) 
	
	addEventHandler("onClientGUIClick", Events.gui.window, Events.buttonClick)

	--Tabpanel
    local tabPanel = guiCreateTabPanel(5, 25, 460, 340, false, Events.gui.window)
	
	--Players Tab
	Events.gui.clanwarTab = {}
    Events.gui.clanwarTab.tab = guiCreateTab("Clanwar", tabPanel)	
	
	--Event
    local eventLabel = guiCreateLabel(10, 20, 70, 20, "Event:", false, Events.gui.clanwarTab.tab)
    guiSetFont(eventLabel, "default-bold-small")
    guiLabelSetVerticalAlign(eventLabel, "center")	
	Events.gui.clanwarTab.eventEdit = guiCreateEdit(90, 20, 220, 20, "Event 1", false, Events.gui.clanwarTab.tab)
	
	--Referee
    local refereeLabel = guiCreateLabel(10, 50, 70, 20, "Referee:", false, Events.gui.clanwarTab.tab)
    guiSetFont(refereeLabel, "default-bold-small")
    guiLabelSetVerticalAlign(refereeLabel, "center")	
	Events.gui.clanwarTab.refereeEdit = guiCreateEdit(90, 50, 220, 20, "Player (or empty)", false, Events.gui.clanwarTab.tab)
	
	--Teams	
    local teamsLabel = guiCreateLabel(10, 80, 70, 20, "Teams:", false, Events.gui.clanwarTab.tab)
    guiSetFont(teamsLabel, "default-bold-small")
    guiLabelSetVerticalAlign(teamsLabel, "center")
	
    local teamNameLabel = guiCreateLabel(120, 80, 70, 20, "Name:", false, Events.gui.clanwarTab.tab)
    guiSetFont(teamNameLabel, "default-bold-small")
    guiLabelSetVerticalAlign(teamNameLabel, "center")
	
    local teamScoreLabel = guiCreateLabel(240, 80, 70, 20, "Score:", false, Events.gui.clanwarTab.tab)
    guiSetFont(teamScoreLabel, "default-bold-small")
    guiLabelSetVerticalAlign(teamScoreLabel, "center")	
	
	Events.gui.clanwarTab.team1Box = guiCreateComboBox(90, 100, 100, 100, "Team 1", false, Events.gui.clanwarTab.tab)
	Events.gui.clanwarTab.team1Edit = guiCreateEdit(210, 100, 100, 20, "0", false, Events.gui.clanwarTab.tab)
	guiComboBoxAddItem(Events.gui.clanwarTab.team1Box, "None")
	table.insert(Events.gui.teamSelects, {box = Events.gui.clanwarTab.team1Box, edit = Events.gui.clanwarTab.team1Edit})
	
	Events.gui.clanwarTab.team2Box = guiCreateComboBox(90, 130, 100, 100, "Team 2", false, Events.gui.clanwarTab.tab)
	Events.gui.clanwarTab.team2Edit = guiCreateEdit(210, 130, 100, 20, "0", false, Events.gui.clanwarTab.tab)
	guiComboBoxAddItem(Events.gui.clanwarTab.team2Box, "None")
	table.insert(Events.gui.teamSelects, {box = Events.gui.clanwarTab.team2Box, edit = Events.gui.clanwarTab.team2Edit})
		
	Events.gui.clanwarTab.team3Box = guiCreateComboBox(90, 160, 100, 100, "Team 3", false, Events.gui.clanwarTab.tab)
	Events.gui.clanwarTab.team3Edit = guiCreateEdit(210, 160, 100, 20, "0", false, Events.gui.clanwarTab.tab)
	guiComboBoxAddItem(Events.gui.clanwarTab.team3Box, "None")
	table.insert(Events.gui.teamSelects, {box = Events.gui.clanwarTab.team3Box, edit = Events.gui.clanwarTab.team3Edit})
	
	Events.gui.clanwarTab.team4Box = guiCreateComboBox(90, 190, 100, 100, "Team 4", false, Events.gui.clanwarTab.tab)
	Events.gui.clanwarTab.team4Edit = guiCreateEdit(210, 190, 100, 20, "0", false, Events.gui.clanwarTab.tab)
	guiComboBoxAddItem(Events.gui.clanwarTab.team4Box, "None")
	table.insert(Events.gui.teamSelects, {box = Events.gui.clanwarTab.team4Box, edit = Events.gui.clanwarTab.team4Edit})
	
	--Progress
    Events.gui.clanwarTab.progressLabel = guiCreateLabel(10, 230, 70, 20, "Progress:", false, Events.gui.clanwarTab.tab)
    guiSetFont(Events.gui.clanwarTab.progressLabel, "default-bold-small")
    guiLabelSetVerticalAlign(Events.gui.clanwarTab.progressLabel, "center")	
	Events.gui.clanwarTab.progressEdit = guiCreateEdit(90, 230, 220, 20, "0/20", false, Events.gui.clanwarTab.tab)
	
	--State
    Events.gui.clanwarTab.stateLabel = guiCreateLabel(10, 260, 70, 20, "State:", false, Events.gui.clanwarTab.tab)
    guiSetFont(Events.gui.clanwarTab.stateLabel, "default-bold-small")
    guiLabelSetVerticalAlign(Events.gui.clanwarTab.stateLabel, "center")	
	
	Events.gui.clanwarTab.waitingRatioButton = guiCreateRadioButton(90, 260, 70, 20, "Waiting", false, Events.gui.clanwarTab.tab)
	guiRadioButtonSetSelected(Events.gui.clanwarTab.waitingRatioButton, true)
	
	Events.gui.clanwarTab.runningRatioButton = guiCreateRadioButton(180, 260, 70, 20, "Running", false, Events.gui.clanwarTab.tab)
	
	Events.gui.clanwarTab.pausedRatioButton = guiCreateRadioButton(90, 280, 70, 20, "Paused", false, Events.gui.clanwarTab.tab)
	
	Events.gui.clanwarTab.endedRatioButton = guiCreateRadioButton(180, 280, 70, 20, "Ended", false, Events.gui.clanwarTab.tab)
	
	--Chat Tab
	Events.gui.chatTab = {}
    Events.gui.chatTab.tab = guiCreateTab("Chat", tabPanel)
	
    Events.gui.chatTab.chatLabel = guiCreateLabel(10, 20, 80, 20, "Arena chat:", false, Events.gui.chatTab.tab)
    guiSetFont(Events.gui.chatTab.chatLabel, "default-bold-small")
	
	Events.gui.chatTab.enableRatioButton = guiCreateRadioButton(90, 18, 70, 20, "Enable", false, Events.gui.chatTab.tab)
	guiRadioButtonSetSelected(Events.gui.chatTab.enableRatioButton, true)

	Events.gui.chatTab.disableRatioButton = guiCreateRadioButton(160, 18, 70, 20, "Disable", false, Events.gui.chatTab.tab)
	
    Events.gui.chatTab.chatLabel = guiCreateLabel(10, 50, 80, 20, "Whitelist:", false, Events.gui.chatTab.tab)
    guiSetFont(Events.gui.chatTab.chatLabel, "default-bold-small")
	
    Events.gui.chatTab.gridlist = guiCreateGridList(10, 70, 310, 190, false, Events.gui.chatTab.tab)
    Events.gui.chatTab.gridlistPlayerColumn = guiGridListAddColumn(Events.gui.chatTab.gridlist, "Player", 0.9)	
	
	Events.gui.chatTab.plusButton = guiCreateButton(250, 265, 20, 20, "+", false, Events.gui.chatTab.tab) 
	
	Events.gui.chatTab.minusButton = guiCreateButton(280, 265, 20, 20, "-", false, Events.gui.chatTab.tab) 
	
	addEventHandler("onClientGUIClick", Events.gui.chatTab.tab, Events.chatTabClick)
	
	Events.gui.chatTab.plusWindow = guiCreateWindow((Events.x - 200) / 2, (Events.y - 200) / 2, 200, 200, "Add Player", false)
    guiSetVisible(Events.gui.chatTab.plusWindow, false)
    guiWindowSetMovable(Events.gui.chatTab.plusWindow, false)
    guiWindowSetSizable(Events.gui.chatTab.plusWindow, false)
	
    Events.gui.chatTab.playerGridlist = guiCreateGridList(10, 10, 180, 150, false, Events.gui.chatTab.plusWindow)
    Events.gui.chatTab.playerGridlistPlayerColumn = guiGridListAddColumn(Events.gui.chatTab.playerGridlist, "Player", 0.9)
	
	Events.gui.chatTab.addButton = guiCreateButton(50, 170, 40, 20, "Add", false, Events.gui.chatTab.plusWindow) 
	
	Events.gui.chatTab.closeButton = guiCreateButton(100, 170, 40, 20, "Close", false, Events.gui.chatTab.plusWindow) 
		
	addEventHandler("onClientGUIClick", Events.gui.chatTab.plusWindow, Events.plusWindowClick)
	
	--Spawnpoints Tab
	Events.gui.spawnpointsTab = {}
    Events.gui.spawnpointsTab.tab = guiCreateTab("Spawnpoints", tabPanel)
	
    Events.gui.spawnpointsTab.spawnLabel = guiCreateLabel(10, 20, 110, 20, "Same Spawnpoint:", false, Events.gui.spawnpointsTab.tab)
    guiSetFont(Events.gui.spawnpointsTab.spawnLabel, "default-bold-small")	
	
	Events.gui.spawnpointsTab.spawnCheckBox = guiCreateCheckBox(150, 20, 20, 20, "", false, false, Events.gui.spawnpointsTab.tab)

    Events.gui.spawnpointsTab.spawnpointSwitchingLabel = guiCreateLabel(10, 50, 130, 20, "Spawnpoint switching:", false, Events.gui.spawnpointsTab.tab)
    guiSetFont(Events.gui.spawnpointsTab.spawnpointSwitchingLabel, "default-bold-small")	
	
	Events.gui.spawnpointsTab.spawnpointSwitchingCheckBox = guiCreateCheckBox(150, 50, 20, 20, "", true, false, Events.gui.spawnpointsTab.tab)

end
addEventHandler("onClientResourceStart", resourceRoot, Events.main)


function Events.toggle()

    if not guiGetVisible(Events.gui.window) then
	
		Events.show()
		
    else
	
		Events.hide()
		
    end
	
end



function Events.join()
	
	addEventHandler("onClientRender", root, Events.render)
	addEventHandler("onClientPlayerLeaveArena", localPlayer, Events.leave)
	addCommandHandler("hideevent", Events.hideEvent)
	addEventHandler("onClientKey", root, Events.click)
	addEventHandler("onClientCursorMove", root, Events.cursorMove)
	
	triggerServerEvent("onEventsRequestAccess", localPlayer)

end
addEvent("onClientPlayerJoinArena", true)
addEventHandler("onClientPlayerJoinArena", localPlayer, Events.join)


function Events.access(access)

	if not access then return end

	addCommandHandler("event", Events.toggle)

end
addEvent("onClientEventsReceiveAccess", true)
addEventHandler("onClientEventsReceiveAccess", root, Events.access)


function Events.leave()

	removeCommandHandler("event", Events.toggle)
	removeEventHandler("onClientRender", root, Events.render)
	removeCommandHandler("hideevent", Events.hideEvent)
	removeEventHandler("onClientKey", root, Events.click)
	removeEventHandler("onClientCursorMove", root, Events.cursorMove)
	removeEventHandler("onClientPlayerLeaveArena", localPlayer, Events.leave)
	Events.data = nil
	Events.hide()
	Events.positioning = false
	
end
addEvent("onClientPlayerLeaveArena", true)


function Events.show()
	
	local arenaElement = getElementParent(localPlayer)
	
	if Events.data then
	
		guiSetText(Events.gui.clanwarTab.eventEdit, Events.data.event)
			
		guiSetText(Events.gui.clanwarTab.refereeEdit, Events.data.referee)
		
		guiSetText(Events.gui.clanwarTab.progressEdit, Events.data.progress)
		
		if Events.data.state == "#ffaa00Waiting" then
		
			guiRadioButtonSetSelected(Events.gui.clanwarTab.waitingRatioButton, true)
		
		elseif Events.data.state == "#00ff00Running" then
		
			guiRadioButtonSetSelected(Events.gui.clanwarTab.runningRatioButton, true)
		
		elseif Events.data.state == "#ffff00Paused" then

			guiRadioButtonSetSelected(Events.gui.clanwarTab.pausedRatioButton, true)
		
		elseif Events.data.state == "#ff0000Ended" then

			guiRadioButtonSetSelected(Events.gui.clanwarTab.endedRatioButton, true)

		end
	
		for i, teamSelect in pairs(Events.gui.teamSelects) do
		
			guiComboBoxClear(teamSelect.box)
			guiComboBoxAddItem(teamSelect.box, "None")
			guiComboBoxSetSelected(teamSelect.box, -1)
			guiSetText(teamSelect.edit, "0")
		
			for j, team in pairs(exports["CCS"]:export_getTeamsInArena(arenaElement)) do
				
				local id = guiComboBoxAddItem(teamSelect.box, getTeamName(team))
			
				if getTeamName(team) == Events.data.teams[i].name then
				
					guiComboBoxSetSelected(teamSelect.box, id)
					guiSetText(teamSelect.edit, Events.data.teams[i].score)
					
				end
				
			end
		
		end
		
		guiRadioButtonSetSelected(Events.gui.chatTab.disableRatioButton, Events.data.arenaChatDisable)

		guiCheckBoxSetSelected(Events.gui.spawnpointsTab.spawnCheckBox, Events.data.sameSpawnpoint)

		guiCheckBoxSetSelected(Events.gui.spawnpointsTab.spawnpointSwitchingCheckBox, Events.data.spawnpointSwitching)

		guiGridListClear(Events.gui.chatTab.gridlist)
		
		for player, state in pairs(Events.data.whitelist) do
			
			if player and isElement(player) then
			
				local row = guiGridListAddRow(Events.gui.chatTab.gridlist)
				guiGridListSetItemText(Events.gui.chatTab.gridlist, row, 1, getPlayerName(player):gsub('#%x%x%x%x%x%x', '' ), false, false)
				guiGridListSetItemData(Events.gui.chatTab.gridlist, row, 1, player)
				
			else
			
				Events.data.whitelist[player] = nil
			
			end
			
		end

	else
	
		for i, teamSelect in pairs(Events.gui.teamSelects) do
		
			guiComboBoxClear(teamSelect.box)
			guiComboBoxAddItem(teamSelect.box, "None")
			guiComboBoxSetSelected(teamSelect.box, -1)
			guiSetText(teamSelect.edit, "0")
		
			for j, team in pairs(exports["CCS"]:export_getTeamsInArena(arenaElement)) do
				
				guiComboBoxAddItem(teamSelect.box, getTeamName(team))
				
			end
		
		end
	
	end
		
	guiGridListClear(Events.gui.chatTab.playerGridlist)

	for i, player in pairs(exports["CCS"]:export_getPlayersInArena(arenaElement)) do
		
		local row = guiGridListAddRow(Events.gui.chatTab.playerGridlist)
		guiGridListSetItemText(Events.gui.chatTab.playerGridlist, row, 1, getPlayerName(player):gsub('#%x%x%x%x%x%x', '' ), false, false)
		guiGridListSetItemData(Events.gui.chatTab.playerGridlist, row, 1, player)
		
	end
	
	guiSetVisible(Events.gui.window, true)
	showCursor(true)	
	
end


function Events.hide()

	guiSetVisible(Events.gui.window, false)
	showCursor(false)

end


function Events.update(data)
	
	Events.data = data

end
addEvent("onClientEventUpdate", true)
addEventHandler("onClientEventUpdate", root, Events.update)


function Events.buttonClick()

    if source == Events.gui.saveButton then
	
		Events.sendUpdate()

	elseif source == Events.gui.resetButton then
	
		Events.reset()

	elseif source == Events.gui.closeButton then
	
		Events.hide()
		
	end

end


function Events.reset()

	guiSetText(Events.gui.clanwarTab.eventEdit, "Event")
	
	guiSetText(Events.gui.clanwarTab.refereeEdit, "Player (or empty)")
	
	guiSetText(Events.gui.clanwarTab.progressEdit, "0/20")
	
	guiRadioButtonSetSelected(Events.gui.clanwarTab.waitingRatioButton, true)
	
	for i, teamSelect in pairs(Events.gui.teamSelects) do

		guiComboBoxSetSelected(teamSelect.box, -1)

		guiSetText(teamSelect.edit, 0)

	end
	
	guiRadioButtonSetSelected(Events.gui.chatTab.disableRatioButton, false)

	guiRadioButtonSetSelected(Events.gui.chatTab.enableRatioButton, true)

	guiCheckBoxSetSelected(Events.gui.spawnpointsTab.spawnCheckBox, false)

	guiCheckBoxSetSelected(Events.gui.spawnpointsTab.spawnpointSwitchingCheckBox, true)

	guiGridListClear(Events.gui.chatTab.gridlist)
	
	triggerServerEvent("onEventUpdate", localPlayer, nil)

end


function Events.plusWindowClick()

    if source == Events.gui.chatTab.addButton then

		guiSetEnabled(Events.gui.window, true)

		guiSetVisible(Events.gui.chatTab.plusWindow, false)	

		local row = guiGridListGetSelectedItem(Events.gui.chatTab.playerGridlist)

		if row == -1 then return end
		
		local player = guiGridListGetItemData(Events.gui.chatTab.playerGridlist, row, 1)

		if not player then return end
		
		if guiGridListGetRowCount(Events.gui.chatTab.gridlist) > 0 then
		
			for i = 0, guiGridListGetRowCount(Events.gui.chatTab.gridlist) - 1, 1 do

				local whitelistPlayer = guiGridListGetItemData(Events.gui.chatTab.gridlist, i, 1)

				if whitelistPlayer == player then return end
			
			end
			
		end

		local row = guiGridListAddRow(Events.gui.chatTab.gridlist)

		guiGridListSetItemText(Events.gui.chatTab.gridlist, row, 1, getPlayerName(player):gsub('#%x%x%x%x%x%x', '' ), false, false)
		guiGridListSetItemData(Events.gui.chatTab.gridlist, row, 1, player)

	elseif source == Events.gui.chatTab.closeButton then
	
		guiSetEnabled(Events.gui.window, true)

		guiSetVisible(Events.gui.chatTab.plusWindow, false)	
	
	end

end


function Events.sendUpdate()

	local event = guiGetText(Events.gui.clanwarTab.eventEdit)
	
	local state
	
	if guiRadioButtonGetSelected(Events.gui.clanwarTab.waitingRatioButton) then
	
		state = "#ffaa00Waiting"
		
	elseif guiRadioButtonGetSelected(Events.gui.clanwarTab.runningRatioButton) then
	
		state = "#00ff00Running"
	
	elseif guiRadioButtonGetSelected(Events.gui.clanwarTab.pausedRatioButton) then
	
		state = "#ffff00Paused"
	
	elseif guiRadioButtonGetSelected(Events.gui.clanwarTab.endedRatioButton) then
	
		state = "#ff0000Ended"
	
	end
	
	local progress = guiGetText(Events.gui.clanwarTab.progressEdit)
	
	local referee = guiGetText(Events.gui.clanwarTab.refereeEdit)
	
	local teams = {}
	
	for i, teamSelect in pairs(Events.gui.teamSelects) do
	
		local team = guiComboBoxGetSelected(teamSelect.box)
		
		if team ~= -1 and team ~= 0 then
		
			local team1Name = guiComboBoxGetItemText(teamSelect.box, team)		
		
			local team1Score = guiGetText(teamSelect.edit)
		
			table.insert(teams, {name = team1Name, score = team1Score})
			
		else
		
			table.insert(teams, {name = nil, score = nil})
			
		end
	
	end
	
	local data = {}
	
	data.event = event
	
	data.state = state
	
	data.progress = progress
	
	data.referee = referee
	
	data.teams = teams
	
	data.arenaChatDisable = guiRadioButtonGetSelected(Events.gui.chatTab.disableRatioButton)

	data.sameSpawnpoint = guiCheckBoxGetSelected(Events.gui.spawnpointsTab.spawnCheckBox)

	data.spawnpointSwitching = guiCheckBoxGetSelected(Events.gui.spawnpointsTab.spawnpointSwitchingCheckBox)

	data.whitelist = {}

	if guiGridListGetRowCount(Events.gui.chatTab.gridlist) > 0 then
	
		for i = 0, guiGridListGetRowCount(Events.gui.chatTab.gridlist) - 1, 1 do

			local player = guiGridListGetItemData(Events.gui.chatTab.gridlist, i, 1)

			data.whitelist[player] = true
		
		end

	end

	triggerServerEvent("onEventUpdate", localPlayer, data)

end


function Events.chatTabClick()

    if source == Events.gui.chatTab.minusButton then
	
		local row = guiGridListGetSelectedItem(Events.gui.chatTab.gridlist)

		if row == -1 then return end

		local player = guiGridListGetItemData(Events.gui.chatTab.gridlist, row, 1)

		guiGridListRemoveRow(Events.gui.chatTab.gridlist, row)

		if Events.data then
		
			Events.data.whitelist[player] = nil

		end

	elseif source == Events.gui.chatTab.plusButton then
	
		guiSetEnabled(Events.gui.window, false)

		guiSetVisible(Events.gui.chatTab.plusWindow, true)

		guiBringToFront(Events.gui.chatTab.plusWindow)
		
	end

end


function Events.render()

	if not Events.shown then return end

	if not Events.data then return end

	Events.height = 0
	
	Events.currentPositionY = Events.positionY
	
	Events.drawRow(Events.positionX, Events.currentPositionY, Events.normalRowWidth, Events.data.event, "center", true)
	
	if #Events.data.referee ~= 0 then
	
		Events.drawRow(Events.positionX, Events.currentPositionY, Events.normalRowWidth, "#AAAAAAReferee: #ffffff"..Events.data.referee, "center", true)
	
	end
	
	Events.drawRow(Events.positionX, Events.currentPositionY, Events.normalRowWidth, "#AAAAAAProgress: #ffffff"..Events.data.progress.." ("..Events.data.state.."#ffffff)", "center", true)
	
	Events.drawRow(Events.positionX, Events.currentPositionY, Events.normalRowWidth / 2, "#AAAAAATeam", "center", false)
	
	Events.drawRow(Events.positionX + Events.normalRowWidth / 2 + Events.offset, Events.currentPositionY, Events.normalRowWidth / 4, "#AAAAAAAlive", "center", false)
	
	Events.drawRow(Events.positionX + Events.normalRowWidth / 2 + Events.offset * 2 + Events.normalRowWidth / 4, Events.currentPositionY, Events.normalRowWidth / 4 - Events.offset * 2, "#AAAAAAScore", "center", true)
	
	for i, teamData in pairs(Events.data.teams) do
	
		while true do
		
			if not teamData.name or not teamData.score then break end
			
			local team = getTeamFromName(teamData.name)
			
			local alive = 0
			local total = 0
			local color = "#ffffff"
			
			if team then
			
				local r, g, b = getTeamColor(team)
			
				color = string.format("#%.2X%.2X%.2X", r, g, b)
			
				players = getPlayersInTeam(team)
			
				total = #players
			
				for i, player in pairs(players) do
				
					if getElementData(player, "state") == "Alive" then
					
						alive = alive + 1
						
					end
				
				end
			
			else
			
				alive = "~"
				total = "~"
				
			end
		
			Events.drawRow(Events.positionX, Events.currentPositionY, Events.normalRowWidth / 2, color..teamData.name, "center", false)
		
			Events.drawRow(Events.positionX + Events.normalRowWidth / 2 + Events.offset, Events.currentPositionY, Events.normalRowWidth / 4, tostring(alive).."/"..total, "center", false)
		
			Events.drawRow(Events.positionX + Events.normalRowWidth / 2 + Events.offset * 2 + Events.normalRowWidth / 4, Events.currentPositionY, Events.normalRowWidth / 4 - Events.offset * 2, teamData.score, "center", true)
		
			break
			
		end	
		
	end
	
	--Positioning
	if Events.positioning then 
		
		if getAbsoluteCursorPosition() then
		
			local absoluteX, absoluteY = getAbsoluteCursorPosition()
			Events.positionX = absoluteX - Events.positioningX
			Events.positionY = absoluteY - Events.positioningY
		
		else
			
			Events.positioning = false
			
		end
	end
	
end


function Events.drawRow(x, y, width, text, align, increment, noBackground)

	if not noBackground then
	
		dxDrawRectangle(x, y, width, Events.rowSize, Events.backgroundColor)
		
	end
	
	text = Events.dxClipTextToWidth(text, width)
	
	dxDrawText(text:gsub('#%x%x%x%x%x%x', ''), x+1, y+1, x+width+1, y + Events.rowSize+1, tocolor ( 0, 0, 0, 255 ), Events.fontSize, Events.font, align, "center", false, false, false, false, false )
	dxDrawText(text, x, y, x+width, y + Events.rowSize, tocolor ( 255, 255, 255, 255 ), Events.fontSize, Events.font, align, "center", false, false, false, true, false )

	if increment then
	
		Events.currentPositionY = Events.currentPositionY + (Events.rowSize + Events.offset)
	
		Events.height = Events.height + (Events.rowSize + Events.offset)
	
	end
	
end


function Events.dxClipTextToWidth(text, width)

	while dxGetTextWidth(" "..text, Events.fontSize, Events.font, true) > width do
	
		text = text:sub(1, #text-1)
	
	end
	
	return text

end


function Events.hideEvent()

	Events.shown = not Events.shown

end


--Positioning
function Events.click(button, state)

	if not Events.data then return end

	if not isConsoleActive() and not isChatBoxInputActive() then return end

	if not getAbsoluteCursorPosition() or button ~= "mouse1" then return end
	
	absoluteX, absoluteY = getAbsoluteCursorPosition()

	if state then
		
		if absoluteX < Events.positionX or absoluteX > Events.positionX + Events.normalRowWidth then return end
		
		if absoluteY < Events.positionY or absoluteY > Events.positionY + Events.height then return end
		
		Events.positioning = true
		Events.positioningX = absoluteX - Events.positionX
		Events.positioningY = absoluteY - Events.positionY
			
	else
	
		Events.positioning = false
			
	end
	
end


function Events.cursorMove(rx, ry, x, y)

	Events.cursor = {x, y}

end


function getAbsoluteCursorPosition()

	if not Events.cursor then return end

	return Events.cursor[1], Events.cursor[2] 
	
end