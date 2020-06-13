Panel = {}
Panel.x, Panel.y = guiGetScreenSize()
Panel.gui = {}
local lastVisible
local lobbyActive

function Panel.create()

	--Window
    Panel.gui.window = guiCreateWindow((Panel.x - 480) / 2, (Panel.y - 380) / 2, 480, 380, "Admin Panel", false)
    guiSetVisible(Panel.gui.window, false)
    guiWindowSetMovable(Panel.gui.window, true)
    guiWindowSetSizable(Panel.gui.window, false)
	
	--Tabpanel
    local tabPanel = guiCreateTabPanel(5, 25, 460, 350, false, Panel.gui.window)
    
	--Players Tab
	Panel.gui.playerTab = {}
    Panel.gui.playerTab.tab = guiCreateTab("Players", tabPanel)
    Panel.gui.playerTab.gridlist = guiCreateGridList(10, 10, 180, 300, false, Panel.gui.playerTab.tab)
    Panel.gui.playerTab.gridlistPlayerColumn = guiGridListAddColumn(Panel.gui.playerTab.gridlist, "Player", 0.9)
    Panel.gui.playerTab.lobbyButton = guiCreateButton(375, 20, 70, 20, "Lobby", false, Panel.gui.playerTab.tab)
    Panel.gui.playerTab.kickButton = guiCreateButton(375, 55, 70, 20, "Kick", false, Panel.gui.playerTab.tab)
    Panel.gui.playerTab.banButton = guiCreateButton(375, 90, 70, 20, "Ban", false, Panel.gui.playerTab.tab)
    Panel.gui.playerTab.muteButton = guiCreateButton(375, 125, 70, 20, "Mute", false, Panel.gui.playerTab.tab)
    Panel.gui.playerTab.fixButton = guiCreateButton(375, 160, 70, 20, "Fix", false, Panel.gui.playerTab.tab)
    Panel.gui.playerTab.nosButton = guiCreateButton(375, 195, 70, 20, "Nos", false, Panel.gui.playerTab.tab)
    Panel.gui.playerTab.smashButton = guiCreateButton(375, 230, 70, 20, "Smash", false, Panel.gui.playerTab.tab)
    Panel.gui.playerTab.boomButton = guiCreateButton(375, 265, 70, 20, "Boom", false, Panel.gui.playerTab.tab)
	Panel.gui.playerTab.teamButton = guiCreateButton(275, 265, 70, 20, "Team", false, Panel.gui.playerTab.tab)
	
    local playerNameLabel = guiCreateLabel(200, 20, 70, 20, "Name:", false, Panel.gui.playerTab.tab)
    guiSetFont(playerNameLabel, "default-bold-small")
    guiLabelSetVerticalAlign(playerNameLabel, "center")
	
    Panel.gui.playerTab.playerName = guiCreateLabel(200, 40, 170, 20, "", false, Panel.gui.playerTab.tab)
    guiSetFont(Panel.gui.playerTab.playerName, "default")
    guiLabelSetVerticalAlign(Panel.gui.playerTab.playerName, "center")
	
    local playerAccountLabel = guiCreateLabel(200, 60, 70, 20, "Account:", false, Panel.gui.playerTab.tab)
    guiSetFont(playerAccountLabel, "default-bold-small")
    guiLabelSetVerticalAlign(playerAccountLabel, "center")
	
    Panel.gui.playerTab.playerAccount = guiCreateLabel(200, 80, 170, 20, "", false, Panel.gui.playerTab.tab)
    guiSetFont(Panel.gui.playerTab.playerAccount, "default")
    guiLabelSetVerticalAlign(Panel.gui.playerTab.playerAccount, "center")
	
    local playerSerialLabel = guiCreateLabel(200, 100, 70, 20, "Serial:", false, Panel.gui.playerTab.tab)
    guiSetFont(playerSerialLabel, "default-bold-small")
    guiLabelSetVerticalAlign(playerSerialLabel, "center")
	
    Panel.gui.playerTab.playerSerial = guiCreateLabel(200, 120, 170, 20, "", false, Panel.gui.playerTab.tab)
    guiSetFont(Panel.gui.playerTab.playerSerial, "default")
    guiLabelSetVerticalAlign(Panel.gui.playerTab.playerSerial, "center")
	
    local playerIPLabel = guiCreateLabel(200, 140, 70, 20, "IP Address:", false, Panel.gui.playerTab.tab)
    guiSetFont(playerIPLabel, "default-bold-small")
    guiLabelSetVerticalAlign(playerIPLabel, "center")
	
    Panel.gui.playerTab.playerIP = guiCreateLabel(200, 160, 170, 20, "", false, Panel.gui.playerTab.tab)
    guiSetFont(Panel.gui.playerTab.playerIP, "default")
    guiLabelSetVerticalAlign(Panel.gui.playerTab.playerIP, "center")
	
    local playerCountryLabel = guiCreateLabel(200, 180, 70, 20, "Country:", false, Panel.gui.playerTab.tab)
    guiSetFont(playerCountryLabel, "default-bold-small")
    guiLabelSetVerticalAlign(playerCountryLabel, "center")
	
    Panel.gui.playerTab.playerCountry = guiCreateLabel(200, 200, 170, 20, "", false, Panel.gui.playerTab.tab)
    guiSetFont(Panel.gui.playerTab.playerCountry, "default")
    guiLabelSetVerticalAlign(Panel.gui.playerTab.playerCountry, "center")
	
	addEventHandler("onClientGUIClick", Panel.gui.playerTab.gridlist, Panel.playerGridlistClick)
	addEventHandler("onClientGUIClick", Panel.gui.playerTab.tab, Panel.playerTabClick)
	
	--Team Window
	Panel.gui.playerTab.teamWindow = guiCreateWindow((Panel.x - 300) / 2, (Panel.y - 200) / 2, 300, 200, "Team", false)
	Panel.gui.playerTab.teamTabPanel = guiCreateTabPanel(5, 25, 290, 165, false, Panel.gui.playerTab.teamWindow)
	Panel.gui.playerTab.teamListTab = guiCreateTab("Teams", Panel.gui.playerTab.teamTabPanel)
	Panel.gui.playerTab.teamCreateTab = guiCreateTab("Create", Panel.gui.playerTab.teamTabPanel)
	guiSetVisible(Panel.gui.playerTab.teamWindow, false)
	Panel.gui.playerTab.teamGridlist = guiCreateGridList(10, 10, 120, 125, false, Panel.gui.playerTab.teamListTab)
    Panel.gui.playerTab.teamGridlistNameColumn = guiGridListAddColumn(Panel.gui.playerTab.teamGridlist, "Teams", 0.8)
	
    local currentTeamLabel = guiCreateLabel(140, 10, 80, 20, "Current Team:", false, Panel.gui.playerTab.teamListTab)
    guiSetFont(currentTeamLabel, "default-bold-small")
    guiLabelSetVerticalAlign(currentTeamLabel, "center")
	
    Panel.gui.playerTab.currentTeam = guiCreateLabel(140, 30, 170, 20, "None", false, Panel.gui.playerTab.teamListTab)
    guiSetFont(Panel.gui.playerTab.currentTeam, "default")
    guiLabelSetVerticalAlign(Panel.gui.playerTab.currentTeam, "center")
	
	Panel.gui.playerTab.teamRemoveButton = guiCreateButton(140, 60, 60, 20, "Remove", false, Panel.gui.playerTab.teamListTab)
	Panel.gui.playerTab.teamDeleteButton = guiCreateButton(140, 90, 130, 20, "Destroy Team", false, Panel.gui.playerTab.teamListTab)
	Panel.gui.playerTab.teamAddButton = guiCreateButton(140, 115, 60, 20, "Add", false, Panel.gui.playerTab.teamListTab)
	Panel.gui.playerTab.teamListCloseButton = guiCreateButton(210, 115, 60, 20, "Close", false, Panel.gui.playerTab.teamListTab)
	
    local teamNameLabel = guiCreateLabel(10, 10, 60, 20, "Name:", false, Panel.gui.playerTab.teamCreateTab)
    guiSetFont(teamNameLabel, "default-bold-small")
    guiLabelSetVerticalAlign(teamNameLabel, "center")
	Panel.gui.playerTab.teamNameEdit = guiCreateEdit(10, 30, 150, 20, "", false, Panel.gui.playerTab.teamCreateTab)
	
    local teamRLabel = guiCreateLabel(10, 60, 60, 20, "Red:", false, Panel.gui.playerTab.teamCreateTab)
    guiSetFont(teamRLabel, "default-bold-small")
    guiLabelSetVerticalAlign(teamRLabel, "center")
	Panel.gui.playerTab.teamREdit = guiCreateEdit(10, 80, 50, 20, "255", false, Panel.gui.playerTab.teamCreateTab)
	
    local teamGLabel = guiCreateLabel(80, 60, 60, 20, "Green:", false, Panel.gui.playerTab.teamCreateTab)
    guiSetFont(teamGLabel, "default-bold-small")
    guiLabelSetVerticalAlign(teamGLabel, "center")
	Panel.gui.playerTab.teamGEdit = guiCreateEdit(80, 80, 50, 20, "255", false, Panel.gui.playerTab.teamCreateTab)
	
    local teamBLabel = guiCreateLabel(150, 60, 60, 20, "Blue:", false, Panel.gui.playerTab.teamCreateTab)
    guiSetFont(teamBLabel, "default-bold-small")
    guiLabelSetVerticalAlign(teamBLabel, "center")
	Panel.gui.playerTab.teamBEdit = guiCreateEdit(150, 80, 50, 20, "255", false, Panel.gui.playerTab.teamCreateTab)
	
	Panel.gui.playerTab.teamCreateButton = guiCreateButton(50, 115, 70, 20, "Create", false, Panel.gui.playerTab.teamCreateTab)
	Panel.gui.playerTab.teamCreateCloseButton = guiCreateButton(180, 115, 60, 20, "Close", false, Panel.gui.playerTab.teamCreateTab)
	
	addEventHandler("onClientGUIClick", Panel.gui.playerTab.teamWindow, Panel.teamWindowClick)
	
	--Maps Tab
	Panel.gui.mapsTab = {}
    Panel.gui.mapsTab.tab = guiCreateTab("Maps", tabPanel)
    Panel.gui.mapsTab.gridlist = guiCreateGridList(10, 10, 180, 300, false, Panel.gui.mapsTab.tab)
    Panel.gui.mapsTab.gridlistMapsColumn = guiGridListAddColumn(Panel.gui.mapsTab.gridlist, "Maps", 0.8)
    Panel.gui.mapsTab.nextmapButton = guiCreateButton(240, 160, 70, 20, "Nextmap", false, Panel.gui.mapsTab.tab)
    Panel.gui.mapsTab.gotoButton = guiCreateButton(340, 160, 70, 20, "Goto", false, Panel.gui.mapsTab.tab)
	
    local mapNameLabel = guiCreateLabel(210, 20, 184, 20, "Name:", false, Panel.gui.mapsTab.tab)
    guiSetFont(mapNameLabel, "default-bold-small")
    guiLabelSetVerticalAlign(mapNameLabel, "center")
	
    Panel.gui.mapsTab.mapName = guiCreateLabel(210, 40, 184, 20, "", false, Panel.gui.mapsTab.tab)
    guiSetFont(Panel.gui.mapsTab.mapName, "default")
    guiLabelSetVerticalAlign(Panel.gui.mapsTab.mapName, "center")
	
    local mapAuthorLabel = guiCreateLabel(210, 60, 184, 27, "Author:", false, Panel.gui.mapsTab.tab)
    guiSetFont(mapAuthorLabel, "default-bold-small")
    guiLabelSetVerticalAlign(mapAuthorLabel, "center")
	
    Panel.gui.mapsTab.mapAuthor = guiCreateLabel(210, 80, 184, 20, "", false, Panel.gui.mapsTab.tab)
    guiSetFont(Panel.gui.mapsTab.mapAuthor, "default")
    guiLabelSetVerticalAlign(Panel.gui.mapsTab.mapAuthor, "center")
	
    local mapTypeLabel = guiCreateLabel(210, 100, 184, 20, "Type:", false, Panel.gui.mapsTab.tab)
    guiSetFont(mapTypeLabel, "default-bold-small")
    guiLabelSetVerticalAlign(mapTypeLabel, "center")

    Panel.gui.mapsTab.mapType = guiCreateLabel(210, 120, 184, 20, "", false, Panel.gui.mapsTab.tab)
    guiSetFont(Panel.gui.mapsTab.mapType, "default")
    guiLabelSetVerticalAlign(Panel.gui.mapsTab.mapType, "center")
	
	addEventHandler("onClientGUIClick", Panel.gui.mapsTab.gridlist, Panel.mapsGridlistClick)
	addEventHandler("onClientGUIClick", Panel.gui.mapsTab.tab, Panel.mapsTabClick)
	
	--Bans Tab
	Panel.gui.bansTab = {}
    Panel.gui.bansTab.tab = guiCreateTab("Bans", tabPanel)
    Panel.gui.bansTab.gridlist = guiCreateGridList(10, 10, 180, 300, false, Panel.gui.bansTab.tab)
    Panel.gui.bansTab.gridlistNameColumn = guiGridListAddColumn(Panel.gui.bansTab.gridlist, "Name", 0.4)
    Panel.gui.bansTab.gridlistSerialColumn = guiGridListAddColumn(Panel.gui.bansTab.gridlist, "Serial", 0.5)
    Panel.gui.bansTab.unbanButton = guiCreateButton(210, 40, 70, 20, "Unban", false, Panel.gui.bansTab.tab)

	addEventHandler("onClientGUIClick", Panel.gui.bansTab.tab, Panel.bansTabClick)
	
	--ACL Tab
	Panel.gui.aclTab = {}
    Panel.gui.aclTab.tab = guiCreateTab("ACL", tabPanel)
    Panel.gui.aclTab.gridlist = guiCreateGridList(10, 10, 180, 300, false, Panel.gui.aclTab.tab)
    Panel.gui.aclTab.gridlistGroupColumn = guiGridListAddColumn(Panel.gui.aclTab.gridlist, "Group", 0.2)
    Panel.gui.aclTab.gridlistNameColumn = guiGridListAddColumn(Panel.gui.aclTab.gridlist, "Account", 0.7)
    Panel.gui.aclTab.removeButton = guiCreateButton(210, 40, 70, 20, "Remove", false, Panel.gui.aclTab.tab)
    Panel.gui.aclTab.addButton = guiCreateButton(210, 80, 70, 20, "Add", false, Panel.gui.aclTab.tab)	
	
	addEventHandler("onClientGUIClick", Panel.gui.aclTab.tab, Panel.aclTabClick)
	
	--Add admin
	Panel.gui.aclTab.addWindow = guiCreateWindow((Panel.x - 240) / 2, (Panel.y - 160) / 2, 240, 160, "Add Admin", false)	
	guiSetVisible(Panel.gui.aclTab.addWindow, false)
    local accountLabel = guiCreateLabel(10, 30, 60, 20, "Account:", false, Panel.gui.aclTab.addWindow)
    guiSetFont(accountLabel, "default-bold-small")
    guiLabelSetVerticalAlign(accountLabel, "center")
	Panel.gui.aclTab.accountEdit = guiCreateEdit(70, 30, 100, 20, "", false, Panel.gui.aclTab.addWindow)
    local levelLabel = guiCreateLabel(10, 75, 60, 20, "Level:", false, Panel.gui.aclTab.addWindow)
    guiSetFont(levelLabel, "default-bold-small")
    guiLabelSetVerticalAlign(levelLabel, "center")
	Panel.gui.aclTab.levelBox = guiCreateComboBox(70, 75, 100, 100, "Level", false, Panel.gui.aclTab.addWindow)
	guiComboBoxAddItem(Panel.gui.aclTab.levelBox, "1")
	guiComboBoxAddItem(Panel.gui.aclTab.levelBox, "2")
	guiComboBoxAddItem(Panel.gui.aclTab.levelBox, "3")
	guiComboBoxAddItem(Panel.gui.aclTab.levelBox, "4")
	guiComboBoxAddItem(Panel.gui.aclTab.levelBox, "5")
	guiComboBoxAddItem(Panel.gui.aclTab.levelBox, "6")
	guiComboBoxAddItem(Panel.gui.aclTab.levelBox, "7")	
	Panel.gui.aclTab.addAdminButton = guiCreateButton(30, 120, 70, 20, "Add", false, Panel.gui.aclTab.addWindow) 
	Panel.gui.aclTab.exitAdminButton = guiCreateButton(150, 120, 70, 20, "Exit", false, Panel.gui.aclTab.addWindow) 
	
	addEventHandler("onClientGUIClick", Panel.gui.aclTab.addWindow, Panel.addWindowClick)
	
	--Arena Tab
	Panel.gui.arenaTab = {}
    Panel.gui.arenaTab.tab = guiCreateTab("Settings", tabPanel)

    local arenaPasswordLabel = guiCreateLabel(15, 20, 60, 20, "Password:", false, Panel.gui.arenaTab.tab)
    guiSetFont(arenaPasswordLabel, "default-bold-small")
    guiLabelSetVerticalAlign(arenaPasswordLabel, "center")
	
    local arenaTypeLabel = guiCreateLabel(15, 75, 60, 20, "Type:", false, Panel.gui.arenaTab.tab)
    guiSetFont(arenaTypeLabel, "default-bold-small")
    guiLabelSetVerticalAlign(arenaTypeLabel, "center")
	
    Panel.gui.arenaTab.arenaType = guiCreateLabel(15, 95, 240, 20, "", false, Panel.gui.arenaTab.tab)
    guiSetFont(Panel.gui.arenaTab.arenaType, "default")
    guiLabelSetVerticalAlign(Panel.gui.arenaTab.arenaType, "center")
	
	Panel.gui.arenaTab.passwordEdit = guiCreateEdit(15, 45, 100, 20, "", false, Panel.gui.arenaTab.tab)
	Panel.gui.arenaTab.passwordSetButton = guiCreateButton(125, 45, 70, 20, "Set", false, Panel.gui.arenaTab.tab) 
	Panel.gui.arenaTab.passwordResetButton = guiCreateButton(205, 45, 70, 20, "Reset", false, Panel.gui.arenaTab.tab) 
	
    local arenaModeLabel = guiCreateLabel(15, 120, 60, 20, "Mode:", false, Panel.gui.arenaTab.tab)
    guiSetFont(arenaModeLabel, "default-bold-small")
    guiLabelSetVerticalAlign(arenaModeLabel, "center")
	
	Panel.gui.arenaTab.votingRadioButton = guiCreateRadioButton(15, 140, 70, 20, "Voting", false, Panel.gui.arenaTab.tab)
	Panel.gui.arenaTab.randomRadioButton = guiCreateRadioButton(95, 140, 70, 20, "Random", false, Panel.gui.arenaTab.tab)
	Panel.gui.arenaTab.manualRadioButton = guiCreateRadioButton(175, 140, 70, 20, "Manual", false, Panel.gui.arenaTab.tab)
	
    Panel.gui.arenaTab.wffSelect = guiCreateCheckBox(15, 190, 150, 20, "WFF Script", false, false, Panel.gui.arenaTab.tab)
    Panel.gui.arenaTab.cptpSelect = guiCreateCheckBox(15, 220, 150, 20, "CP/TP", false, false, Panel.gui.arenaTab.tab)
	Panel.gui.arenaTab.nicknamesSelect = guiCreateCheckBox(15, 250, 150, 20, "Hide Nicknames", false, false, Panel.gui.arenaTab.tab)
    Panel.gui.arenaTab.afkSelect = guiCreateCheckBox(150, 190, 150, 20, "AFK Detector", false, false, Panel.gui.arenaTab.tab)
    Panel.gui.arenaTab.pingSelect = guiCreateCheckBox(150, 220, 150, 20, "Ping Detector", false, false, Panel.gui.arenaTab.tab)
    Panel.gui.arenaTab.spectatorSelect = guiCreateCheckBox(150, 250, 150, 20, "Spectator Chat", false, false, Panel.gui.arenaTab.tab)
	Panel.gui.arenaTab.rewindSelect = guiCreateCheckBox(285, 190, 150, 20, "Rewind", false, false, Panel.gui.arenaTab.tab)
	Panel.gui.arenaTab.specSelect = guiCreateCheckBox(285, 220, 150, 20, "Spectators", false, false, Panel.gui.arenaTab.tab)
	Panel.gui.arenaTab.fpsSelect = guiCreateCheckBox(285, 250, 150, 20, "FPS Detector", false, false, Panel.gui.arenaTab.tab)
	
	Panel.gui.arenaTab.saveButton = guiCreateButton(190, 290, 70, 20, "Save", false, Panel.gui.arenaTab.tab) 
	
	addEventHandler("onClientGUIClick", Panel.gui.arenaTab.tab, Panel.arenaTabClick)
	
end
addEventHandler("onClientResourceStart", resourceRoot, Panel.create)


function Panel.disableWindow()

	lastVisible = guiGetVisible(Panel.gui.window)
	
	if guiGetVisible(Panel.gui.window) then 
	
		guiSetVisible(Panel.gui.window, false)
		showCursor(false)
		
	end
	
	lobbyActive = true

end
addEvent("onClientLobbyEnable")


function Panel.enableWindow()

	lobbyActive = false
	
	if lastVisible then 
	
		guiSetVisible(Panel.gui.window, true)
        showCursor(true)
		
	end	
	
	lastVisible = false	

end
addEvent("onClientLobbyDisable")


function Panel.show()

	guiSetVisible(Panel.gui.window, true)
	showCursor(true)
	addEventHandler("onClientLobbyEnable", root, Panel.disableWindow)
	addEventHandler("onClientLobbyDisable", root, Panel.enableWindow)
	triggerServerEvent("onPanelRequestPlayers", localPlayer)
	triggerServerEvent("onPanelRequestMaps", localPlayer)
	triggerServerEvent("onPanelRequestBans", localPlayer)
	triggerServerEvent("onPanelRequestACL", localPlayer)
	triggerServerEvent("onPanelRequestTeams", localPlayer)
	Panel.loadArenaInfos()

end


function Panel.hide()

	removeEventHandler("onClientLobbyEnable", root, Panel.disableWindow)
	removeEventHandler("onClientLobbyDisable", root, Panel.enableWindow)
	guiSetVisible(Panel.gui.window, false)
	guiSetVisible(Panel.gui.aclTab.addWindow, false)
	guiSetVisible(Panel.gui.playerTab.teamWindow, false)
	guiSetEnabled(Panel.gui.window, true)
	showCursor(false)
	lobbyActive = false
	lastVisible = false

end


function Panel.toggle()
	
	if lobbyActive then return end
	
    if not guiGetVisible(Panel.gui.window) then
	
		Panel.show()
		
    else
	
		Panel.hide()
		
    end
	
end


function Panel.bind()
	
	triggerServerEvent("onPanelRequestAccess", localPlayer)

end
addEvent("onClientPlayerJoinArena", true)
addEventHandler("onClientPlayerJoinArena", localPlayer, Panel.bind)


function Panel.unbind()

	unbindKey("p", "down", Panel.toggle)
	Panel.hide()
	
end
addEvent("onClientLeaveArena")
addEventHandler("onClientLeaveArena", root, Panel.unbind)


function Panel.access(access)

	if not access then return end
	
	bindKey("p", "down", Panel.toggle)

end
addEvent("onClientPanelReceiveAccess", true)
addEventHandler("onClientPanelReceiveAccess", root, Panel.access)


function Panel.receivePlayers(playerList)

    guiGridListClear(Panel.gui.playerTab.gridlist)
	
    for i, object in pairs(playerList) do
		
        local row = guiGridListAddRow(Panel.gui.playerTab.gridlist)
        guiGridListSetItemText(Panel.gui.playerTab.gridlist, row, Panel.gui.playerTab.gridlistPlayerColumn, object.name, false, false)
		guiGridListSetItemData(Panel.gui.playerTab.gridlist, row, Panel.gui.playerTab.gridlistPlayerColumn, object)
		
    end

	
end
addEvent("onClientPanelReceivePlayers", true)
addEventHandler("onClientPanelReceivePlayers", root, Panel.receivePlayers)


function Panel.receiveMaps(mapsList)

    guiGridListClear(Panel.gui.mapsTab.gridlist)
	
    for i, object in pairs(mapsList) do
		
        local row = guiGridListAddRow(Panel.gui.mapsTab.gridlist)
        guiGridListSetItemText(Panel.gui.mapsTab.gridlist, row, Panel.gui.mapsTab.gridlistMapsColumn, object.name, false, false)
		guiGridListSetItemData(Panel.gui.mapsTab.gridlist, row, Panel.gui.mapsTab.gridlistMapsColumn, object)
		
    end
	
end
addEvent("onClientPanelReceiveMaps", true)
addEventHandler("onClientPanelReceiveMaps", root, Panel.receiveMaps)


function Panel.receiveBans(banList)

    guiGridListClear(Panel.gui.bansTab.gridlist)
	
    for i, object in pairs(banList) do
		
        local row = guiGridListAddRow(Panel.gui.bansTab.gridlist)
        guiGridListSetItemText(Panel.gui.bansTab.gridlist, row, Panel.gui.bansTab.gridlistNameColumn, object.name, false, false)
		guiGridListSetItemText(Panel.gui.bansTab.gridlist, row, Panel.gui.bansTab.gridlistSerialColumn, object.serial, false, false)
		guiGridListSetItemData(Panel.gui.bansTab.gridlist, row, Panel.gui.bansTab.gridlistNameColumn, object)
		
    end
	
end
addEvent("onClientPanelReceiveBans", true)
addEventHandler("onClientPanelReceiveBans", root, Panel.receiveBans)


function Panel.receiveACL(aclList)

    guiGridListClear(Panel.gui.aclTab.gridlist)
	
    for i, object in pairs(aclList) do
		
        local row = guiGridListAddRow(Panel.gui.aclTab.gridlist)
        guiGridListSetItemText(Panel.gui.aclTab.gridlist, row, Panel.gui.aclTab.gridlistGroupColumn, object.group, false, false)
		guiGridListSetItemText(Panel.gui.aclTab.gridlist, row, Panel.gui.aclTab.gridlistNameColumn, object.name, false, false)
		guiGridListSetItemData(Panel.gui.aclTab.gridlist, row, Panel.gui.aclTab.gridlistGroupColumn, object)
		
    end
	
end
addEvent("onClientPanelReceiveACL", true)
addEventHandler("onClientPanelReceiveACL", root, Panel.receiveACL)


function Panel.receiveTeams(teamList)

    guiGridListClear(Panel.gui.playerTab.teamGridlist)
	
    for i, team in pairs(teamList) do
		
        local row = guiGridListAddRow(Panel.gui.playerTab.teamGridlist)
        guiGridListSetItemText(Panel.gui.playerTab.teamGridlist, row, Panel.gui.playerTab.teamGridlistNameColumn, getTeamName(team), false, false)
		guiGridListSetItemData(Panel.gui.playerTab.teamGridlist, row, Panel.gui.playerTab.teamGridlistNameColumn, team)
		
    end
	
end
addEvent("onClientPanelReceiveTeams", true)
addEventHandler("onClientPanelReceiveTeams", root, Panel.receiveTeams)


function Panel.playerGridlistClick() 

	local row = guiGridListGetSelectedItem(Panel.gui.playerTab.gridlist)

	if row == -1 then return end
	
	local object = guiGridListGetItemData(Panel.gui.playerTab.gridlist, row, 1)

	guiSetText(Panel.gui.playerTab.playerName, object.name)
	
	guiSetText(Panel.gui.playerTab.playerAccount, object.account)
	
	guiSetText(Panel.gui.playerTab.playerSerial, object.serial)
	
	guiSetText(Panel.gui.playerTab.playerIP, object.ip)

	guiSetText(Panel.gui.playerTab.playerCountry, object.country)
	
end


function Panel.mapsGridlistClick() 

	local row = guiGridListGetSelectedItem(Panel.gui.mapsTab.gridlist)

	if row == -1 then return end
	
	local object = guiGridListGetItemData(Panel.gui.mapsTab.gridlist, row, 1)

	guiSetText(Panel.gui.mapsTab.mapName, object.name)
	
	guiSetText(Panel.gui.mapsTab.mapAuthor, object.author)
	
	guiSetText(Panel.gui.mapsTab.mapType, object.type)

end


function Panel.playerTabClick() 

	local row = guiGridListGetSelectedItem(Panel.gui.playerTab.gridlist)

	local object = guiGridListGetItemData(Panel.gui.playerTab.gridlist, row, 1)

	if not object or not isElement(object.player) then return end

    if source == Panel.gui.playerTab.lobbyButton then
	
        triggerServerEvent("onPanelLobby", localPlayer, object.name)
   
    elseif source == Panel.gui.playerTab.kickButton then
        
        triggerServerEvent("onPanelKick", localPlayer, object.name)
		 
    elseif source == Panel.gui.playerTab.banButton then
        
		triggerServerEvent("onPanelBan", localPlayer, object.name)
		 
	elseif source == Panel.gui.playerTab.muteButton then
        
		triggerServerEvent("onPanelMute", localPlayer, object.name)
		 
	elseif source == Panel.gui.playerTab.fixButton then
        
		triggerServerEvent("onPanelFix", localPlayer, object.name)
		 
	elseif source == Panel.gui.playerTab.nosButton then
        
		triggerServerEvent("onPanelNos", localPlayer, object.name)
		
	elseif source == Panel.gui.playerTab.smashButton then
        
		triggerServerEvent("onPanelSmash", localPlayer, object.name)
		 
	elseif source == Panel.gui.playerTab.boomButton then
        
		triggerServerEvent("onPanelBoom", localPlayer, object.name)
		
	elseif source == Panel.gui.playerTab.teamButton then
	
	    guiSetVisible(Panel.gui.playerTab.teamWindow, true)
		guiBringToFront(Panel.gui.playerTab.teamWindow)
		guiSetEnabled(Panel.gui.window, false)
		guiSetSelectedTab(Panel.gui.playerTab.teamTabPanel, Panel.gui.playerTab.teamListTab)
		
		if object.team then
		
			guiSetText(Panel.gui.playerTab.currentTeam, getTeamName(object.team))
			guiSetVisible(Panel.gui.playerTab.teamRemoveButton, true)
		
		else
		
			guiSetText(Panel.gui.playerTab.currentTeam, "None")
			guiSetVisible(Panel.gui.playerTab.teamRemoveButton, false)
		
		end
		
	end
	
end


function Panel.mapsTabClick() 

	local row = guiGridListGetSelectedItem(Panel.gui.mapsTab.gridlist)

	local object = guiGridListGetItemData(Panel.gui.mapsTab.gridlist, row, 1)

	if not object then return end

    if source == Panel.gui.mapsTab.nextmapButton then
	
        triggerServerEvent("onPanelNextmap", localPlayer, object.name)
   
    elseif source == Panel.gui.mapsTab.gotoButton then
        
        triggerServerEvent("onPanelGoto", localPlayer, object.name)

	end
	
end


function Panel.bansTabClick() 

	local row = guiGridListGetSelectedItem(Panel.gui.bansTab.gridlist)

	local object = guiGridListGetItemData(Panel.gui.bansTab.gridlist, row, 1)

	if not object then return end

    if source == Panel.gui.bansTab.unbanButton then
	
        triggerServerEvent("onPanelUnban", localPlayer, object.name)

	end
	
end


function Panel.aclTabClick() 

    if source == Panel.gui.aclTab.removeButton then
	
		local row = guiGridListGetSelectedItem(Panel.gui.aclTab.gridlist)

		local object = guiGridListGetItemData(Panel.gui.aclTab.gridlist, row, 1)

		if not object then return end
	
        triggerServerEvent("onPanelRemove", localPlayer, object.name)

	elseif source == Panel.gui.aclTab.addButton then
		
		guiSetVisible(Panel.gui.aclTab.addWindow, true)
		guiBringToFront(Panel.gui.aclTab.addWindow)
		guiSetEnabled(Panel.gui.window, false)

	end
	
end


function Panel.addWindowClick() 

	if source == Panel.gui.aclTab.exitAdminButton then
		
		guiSetVisible(Panel.gui.aclTab.addWindow, false)
		guiSetText(Panel.gui.aclTab.accountEdit, "")
		guiSetEnabled(Panel.gui.window, true)
		
	elseif source == Panel.gui.aclTab.addAdminButton then

		guiSetVisible(Panel.gui.aclTab.addWindow, false)
		
		local account = guiGetText(Panel.gui.aclTab.accountEdit)
		
		if #account == 0 then return end
		
		local level = guiComboBoxGetSelected(Panel.gui.aclTab.levelBox)
		
		if level == -1 then return end
		
		level = guiComboBoxGetItemText(Panel.gui.aclTab.levelBox, level)
		
		triggerServerEvent("onPanelAdd", localPlayer, account, level)
		
		guiSetText(Panel.gui.aclTab.accountEdit, "")
		guiSetVisible(Panel.gui.aclTab.addWindow, false)
		
	end
	
end


function Panel.teamWindowClick()

	if source == Panel.gui.playerTab.teamListCloseButton or source == Panel.gui.playerTab.teamCreateCloseButton then
	
		guiSetVisible(Panel.gui.playerTab.teamWindow, false)
		guiSetEnabled(Panel.gui.window, true)
	
	elseif source == Panel.gui.playerTab.teamCreateButton then
	
		local name = guiGetText(Panel.gui.playerTab.teamNameEdit)
		
		if #name == 0 then return end
	
		local r = guiGetText(Panel.gui.playerTab.teamREdit)
		
		r = tonumber(r)
		
		local g = guiGetText(Panel.gui.playerTab.teamGEdit)
		
		g = tonumber(g)
		
		local b = guiGetText(Panel.gui.playerTab.teamBEdit)
	
		b = tonumber(b)
	
		if not r or r < 0 or r > 255 then return end
	
		if not g or g < 0 or g > 255 then return end
		
		if not b or b < 0 or b > 255 then return end
		
		triggerServerEvent("onCreateTeam", localPlayer, name, r, g, b)
	
		guiSetVisible(Panel.gui.playerTab.teamWindow, false)
		
		guiSetEnabled(Panel.gui.window, true)
	
	elseif source == Panel.gui.playerTab.teamAddButton then
	
		local row = guiGridListGetSelectedItem(Panel.gui.playerTab.gridlist)

		local object = guiGridListGetItemData(Panel.gui.playerTab.gridlist, row, 1)

		if not object or not isElement(object.player) then return end

		local row = guiGridListGetSelectedItem(Panel.gui.playerTab.teamGridlist)

		local team = guiGridListGetItemData(Panel.gui.playerTab.teamGridlist, row, 1)

		if not team or not isElement(team) then return end

		guiSetText(Panel.gui.playerTab.currentTeam, getTeamName(team))
		
		guiSetVisible(Panel.gui.playerTab.teamRemoveButton, true)
		
		guiSetVisible(Panel.gui.playerTab.teamWindow, false)
		
		guiSetEnabled(Panel.gui.window, true)
		
		triggerServerEvent("onSetPlayerTeam", localPlayer, object.player, team)
	
	elseif source == Panel.gui.playerTab.teamRemoveButton then
	
		local row = guiGridListGetSelectedItem(Panel.gui.playerTab.gridlist)

		local object = guiGridListGetItemData(Panel.gui.playerTab.gridlist, row, 1)

		if not object or not isElement(object.player) then return end

		guiSetText(Panel.gui.playerTab.currentTeam, "None")
		
		guiSetVisible(Panel.gui.playerTab.teamRemoveButton, false)
		
		triggerServerEvent("onSetPlayerTeam", localPlayer, object.player, nil)
	
	elseif source == Panel.gui.playerTab.teamDeleteButton then
	
		local row = guiGridListGetSelectedItem(Panel.gui.playerTab.teamGridlist)

		local team = guiGridListGetItemData(Panel.gui.playerTab.teamGridlist, row, 1)

		if not team or not isElement(team) then return end

		triggerServerEvent("onDestroyTeam", localPlayer, team)
	
	end

end


function Panel.loadArenaInfos()

	local arenaElement = getElementParent(localPlayer)
	
	local type = getElementData(arenaElement, "type")
	
	if type then
	
		guiSetText(Panel.gui.arenaTab.arenaType, type)
	
	end
	
	local password = getElementData(arenaElement, "password")
	
	if password then
	
		guiSetText(Panel.gui.arenaTab.passwordEdit, password)
	
	end
	
	local wff = getElementData(arenaElement, "wff")
	
	if wff then
	
		guiCheckBoxSetSelected(Panel.gui.arenaTab.wffSelect, true)
	
	else
	
		guiCheckBoxSetSelected(Panel.gui.arenaTab.wffSelect, false)
	
	end
	
	local cptp = getElementData(arenaElement, "cptp")
	
	if cptp then
	
		guiCheckBoxSetSelected(Panel.gui.arenaTab.cptpSelect, true)
	
	else
	
		guiCheckBoxSetSelected(Panel.gui.arenaTab.cptpSelect, false)
	
	end

	local detector = getElementData(arenaElement, "Detector")
	
	if detector then
	
		guiCheckBoxSetSelected(Panel.gui.arenaTab.afkSelect, true)
	
	else
	
		guiCheckBoxSetSelected(Panel.gui.arenaTab.afkSelect, false)
	
	end
	
	local ping = getElementData(arenaElement, "pingchecker")
	
	if ping then
	
		guiCheckBoxSetSelected(Panel.gui.arenaTab.pingSelect, true)
	
	else
	
		guiCheckBoxSetSelected(Panel.gui.arenaTab.pingSelect, false)
	
	end
   
	local nicknames = getElementData(arenaElement, "hideNicknames")
	
	if nicknames then
	
		guiCheckBoxSetSelected(Panel.gui.arenaTab.nicknamesSelect, true)
	
	else
	
		guiCheckBoxSetSelected(Panel.gui.arenaTab.nicknamesSelect, false)
	
	end
   
	local spectator = getElementData(arenaElement, "showSpectatorChat")
	
	if spectator then
	
		guiCheckBoxSetSelected(Panel.gui.arenaTab.spectatorSelect, true)
	
	else
	
		guiCheckBoxSetSelected(Panel.gui.arenaTab.spectatorSelect, false)
	
	end
   
    local rewind = getElementData(arenaElement, "rewind")
	
	if rewind then
	
		guiCheckBoxSetSelected(Panel.gui.arenaTab.rewindSelect, true)
		
	else
	
		guiCheckBoxSetSelected(Panel.gui.arenaTab.rewindSelect, false)
		
	end
   
    local specs = getElementData(arenaElement, "spectators")
	
	if specs then
	
		guiCheckBoxSetSelected(Panel.gui.arenaTab.specSelect, true)
		
	else
	
		guiCheckBoxSetSelected(Panel.gui.arenaTab.specSelect, false)
		
	end
   
    local fps = getElementData(arenaElement, "fpschecker")
	
	if fps then
	
		guiCheckBoxSetSelected(Panel.gui.arenaTab.fpsSelect, true)
		
	else
	
		guiCheckBoxSetSelected(Panel.gui.arenaTab.fpsSelect, false)
		
	end
   
	local mode = getElementData(arenaElement, "mode")
	
	if mode == "Voting" then
	
		guiRadioButtonSetSelected(Panel.gui.arenaTab.votingRadioButton, true)
   
	elseif mode == "Random" then
	
		guiRadioButtonSetSelected(Panel.gui.arenaTab.randomRadioButton, true)
	
	elseif mode == "Manual" then
	
		guiRadioButtonSetSelected(Panel.gui.arenaTab.manualRadioButton, true)
	
	end
   
end


function Panel.arenaTabClick() 

	local arenaElement = getElementParent(localPlayer)
	
    if source == Panel.gui.arenaTab.passwordSetButton then
	
		local password = guiGetText(Panel.gui.arenaTab.passwordEdit)
		
		if #password == 0 then return end
		
        triggerServerEvent("onPanelPasswordChange", localPlayer, password)

	elseif source == Panel.gui.arenaTab.passwordResetButton then
		
		triggerServerEvent("onPanelPasswordChange", localPlayer, false)
		
		guiSetText(Panel.gui.arenaTab.passwordEdit, "")
		
	elseif source == Panel.gui.arenaTab.saveButton then
	
		local wff = guiCheckBoxGetSelected(Panel.gui.arenaTab.wffSelect)
		local cptp = guiCheckBoxGetSelected(Panel.gui.arenaTab.cptpSelect)
		local detector = guiCheckBoxGetSelected(Panel.gui.arenaTab.afkSelect)
		local ping = guiCheckBoxGetSelected(Panel.gui.arenaTab.pingSelect)
		local nicknames = guiCheckBoxGetSelected(Panel.gui.arenaTab.nicknamesSelect)
		local spectator = guiCheckBoxGetSelected(Panel.gui.arenaTab.spectatorSelect)
		local rewind = guiCheckBoxGetSelected(Panel.gui.arenaTab.rewindSelect)
		local specs = guiCheckBoxGetSelected(Panel.gui.arenaTab.specSelect)
		local fps = guiCheckBoxGetSelected(Panel.gui.arenaTab.fpsSelect)
		local mode = false
		
		if guiRadioButtonGetSelected(Panel.gui.arenaTab.votingRadioButton) then
		
			mode = "Voting"
		
		elseif guiRadioButtonGetSelected(Panel.gui.arenaTab.randomRadioButton) then 
		
			mode = "Random"
		
		elseif guiRadioButtonGetSelected(Panel.gui.arenaTab.manualRadioButton) then 
		
			mode = "Manual"
		
		
		end
		
		triggerServerEvent("onPanelSettingChange", localPlayer, wff, cptp, detector, ping, nicknames, spectator, rewind, specs, fps, mode)
		
	end
	
end