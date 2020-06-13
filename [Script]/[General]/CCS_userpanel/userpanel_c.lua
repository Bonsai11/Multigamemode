local Userpanel = {}
Userpanel.x, Userpanel.y = guiGetScreenSize()
Userpanel.relX, Userpanel.relY = (Userpanel.x/800), (Userpanel.y/600)
Userpanel.postGui = true
Userpanel.showing = false
Userpanel.lastTick = getTickCount()
Userpanel.blink = false
Userpanel.font8 = dxCreateFont("Roboto-Medium.ttf", 8, false, "proof")
Userpanel.font10 = dxCreateFont("Roboto-Medium.ttf", 10, false, "proof")

Userpanel.width = 600 * Userpanel.relY
Userpanel.posX = nil
Userpanel.currentPosY = nil

Userpanel.tabFont = Userpanel.font10
Userpanel.tabFontSize = 1
Userpanel.tabFontColor = tocolor(255, 255, 255, 255)
Userpanel.tabColor = tocolor(20, 20, 20, 240)
Userpanel.tabHeight = dxGetFontHeight(Userpanel.tabFontSize, Userpanel.tabFont) * 2
Userpanel.tabOffset = 2 * Userpanel.relY
Userpanel.tabHighlightColor = tocolor(40, 40, 40, 240)
Userpanel.tabActiveColor = tocolor(255, 255, 255, 240)
Userpanel.tabActiveFontColor = tocolor(0, 0, 0, 255)

Userpanel.tileFont = Userpanel.font10
Userpanel.tileFontSize = 1
Userpanel.tileFontColor = tocolor(255, 255, 255, 255)
Userpanel.tileColor = tocolor(40, 40, 40, 100)
Userpanel.tileHighlightColor = tocolor(50, 50, 50, 100)
Userpanel.tileActiveColor = tocolor(255, 255, 255, 200)
Userpanel.tileActiveFontColor = tocolor(0, 0, 0, 255)
Userpanel.tileHeight = dxGetFontHeight(Userpanel.tileFontSize, Userpanel.tileFont) * 4
Userpanel.tileHeightSmall = dxGetFontHeight(Userpanel.tileFontSize, Userpanel.tileFont) * 2
Userpanel.tileTextOffset = 2 * Userpanel.relY
Userpanel.tileOffset = 2 * Userpanel.relY

--avatar
Userpanel.avatar = dxCreateTexture("avatar.png")
Userpanel.clans = dxCreateTexture("clan.png")
Userpanel.maps = dxCreateTexture("maps.png")
Userpanel.tops = dxCreateTexture("tops.png")
Userpanel.avatarWidth = Userpanel.tileHeight * 0.66
Userpanel.avatarHeight = Userpanel.tileHeight * 0.66

--favorite
Userpanel.favorite = dxCreateTexture("fav.png")
Userpanel.favoriteWidth = Userpanel.tileHeight * 0.33
Userpanel.favoriteHeight = Userpanel.tileHeight * 0.33

--player stats
Userpanel.playerStatsDataTileFont = Userpanel.font10
Userpanel.playerStatsDataTileFontSize = 1
Userpanel.playerStatsDataTileFontHeight = dxGetFontHeight(Userpanel.playerStatsDataTileFontSize, Userpanel.playerStatsDataTileFont)
Userpanel.playerStatsDataTileFontColor = tocolor(255, 255, 255, 255)

Userpanel.playerStatsColumnTileFont = Userpanel.font8
Userpanel.playerStatsColumnTileFontSize = 1
Userpanel.playerStatsColumnTileFontHeight = dxGetFontHeight(Userpanel.playerStatsColumnTileFontSize, Userpanel.playerStatsColumnTileFont)
Userpanel.playerStatsColumnTileFontColor = tocolor(155, 155, 155, 255)

--settings
Userpanel.settingsTileFont = Userpanel.font10
Userpanel.settingsTileFontSize = 1
Userpanel.settingsTileFontHeight = dxGetFontHeight(Userpanel.settingsTileFontSize, Userpanel.settingsTileFont)
Userpanel.settingsTileFontColor = tocolor(255, 255, 255, 255)

Userpanel.settingsDetailsTileFont = Userpanel.font8
Userpanel.settingsDetailsTileFontSize = 1
Userpanel.settingsDetailsTileFontHeight = dxGetFontHeight(Userpanel.settingsDetailsTileFontSize, Userpanel.settingsDetailsTileFont)
Userpanel.settingsDetailsTileFontColor = tocolor(155, 155, 155, 255)

--settings color
Userpanel.settingsColorPreviewWidth = Userpanel.tileHeight * 0.75
Userpanel.settingsColorPreviewHeight = Userpanel.tileHeight * 0.75

--help
Userpanel.helpTileFont = Userpanel.font10
Userpanel.helpTileFontSize = 1
Userpanel.helpTileFontHeight = dxGetFontHeight(Userpanel.helpTileFontSize, Userpanel.helpTileFont)
Userpanel.helpTileFontColor = tocolor(255, 255, 255, 255)

Userpanel.helpDetailsTileFont = Userpanel.font8
Userpanel.helpDetailsTileFontSize = 1
Userpanel.helpDetailsTileFontHeight = dxGetFontHeight(Userpanel.helpDetailsTileFontSize, Userpanel.helpDetailsTileFont)
Userpanel.helpDetailsTileFontColor = tocolor(155, 155, 155, 255)

--help commands
Userpanel.helpCommandsTileFont = Userpanel.font10
Userpanel.helpCommandsTileFontSize = 1
Userpanel.helpCommandsTileFontHeight = dxGetFontHeight(Userpanel.helpCommandsTileFontSize, Userpanel.helpCommandsTileFont)
Userpanel.helpCommandsTileFontColor = tocolor(255, 255, 255, 255)

Userpanel.helpCommandsDetailsTileFont = Userpanel.font8
Userpanel.helpCommandsDetailsTileFontSize = 1
Userpanel.helpCommandsDetailsTileFontHeight = dxGetFontHeight(Userpanel.helpCommandsDetailsTileFontSize, Userpanel.helpCommandsDetailsTileFont)
Userpanel.helpCommandsDetailsTileFontColor = tocolor(155, 155, 155, 255)

--clan
Userpanel.clanMemberCountDetailsTileFont = Userpanel.font8
Userpanel.clanMemberCountDetailsTileFontSize = 1
Userpanel.clanMemberCountDetailsTileFontHeight = dxGetFontHeight(Userpanel.clanMemberCountDetailsTileFontSize, Userpanel.clanMemberCountDetailsTileFont)
Userpanel.clanMemberCountDetailsTileFontColor = tocolor(155, 155, 155, 255)

--stats
Userpanel.statsTileFont = Userpanel.font10
Userpanel.statsTileFontSize = 1
Userpanel.statsTileFontHeight = dxGetFontHeight(Userpanel.statsTileFontSize, Userpanel.statsTileFont)
Userpanel.statsTileFontColor = tocolor(255, 255, 255, 255)

Userpanel.statsDetailsTileFont = Userpanel.font8
Userpanel.statsDetailsTileFontSize = 1
Userpanel.statsDetailsTileFontHeight = dxGetFontHeight(Userpanel.statsDetailsTileFontSize, Userpanel.statsDetailsTileFont)
Userpanel.statsDetailsTileFontColor = tocolor(155, 155, 155, 255)

--maps
Userpanel.mapsTileFont = Userpanel.font10
Userpanel.mapsTileFontSize = 1
Userpanel.mapsTileFontHeight = dxGetFontHeight(Userpanel.mapsTileFontSize, Userpanel.mapsTileFont)
Userpanel.mapsTileFontColor = tocolor(255, 255, 255, 255)

Userpanel.mapsDetailsTileFont = Userpanel.font8
Userpanel.mapsDetailsTileFontSize = 1
Userpanel.mapsDetailsTileFontHeight = dxGetFontHeight(Userpanel.mapsDetailsTileFontSize, Userpanel.mapsDetailsTileFont)
Userpanel.mapsDetailsTileFontColor = tocolor(155, 155, 155, 255)

Userpanel.buyButtonText = "Buy as next map for $10000"
Userpanel.buyButtonFont = Userpanel.font10
Userpanel.buyButtonFontSize = 1
Userpanel.buyButtonWidth = dxGetTextWidth(Userpanel.buyButtonText, Userpanel.buyButtonFontSize, Userpanel.buyButtonFont) * 1.75
Userpanel.buyButtonHeight = dxGetFontHeight(Userpanel.buyButtonFontSize, Userpanel.buyButtonFont) * 1.75
Userpanel.buyButtonColor = tocolor(255, 255, 255, 255)

Userpanel.mapsBackButtonText = "Back"
Userpanel.mapsBackButtonFont = Userpanel.font10
Userpanel.mapsBackButtonFontSize = 1
Userpanel.mapsBackButtonWidth = dxGetTextWidth(Userpanel.mapsBackButtonText, Userpanel.mapsBackButtonFontSize, Userpanel.mapsBackButtonFont) * 2
Userpanel.mapsBackButtonHeight = dxGetFontHeight(Userpanel.mapsBackButtonFontSize, Userpanel.mapsBackButtonFont) * 1.75
Userpanel.mapsBackButtonColor = tocolor(255, 255, 255, 255)
Userpanel.buttonOffset = 10 * Userpanel.relY

Userpanel.backButtonText = "Back"
Userpanel.backButtonFont = Userpanel.font10
Userpanel.backButtonFontSize = 1
Userpanel.backButtonWidth = dxGetTextWidth(Userpanel.backButtonText, Userpanel.backButtonFontSize, Userpanel.backButtonFont) * 2
Userpanel.backButtonHeight = dxGetFontHeight(Userpanel.backButtonFontSize, Userpanel.backButtonFont) * 1.75
Userpanel.backButtonColor = tocolor(255, 255, 255, 255)

--color picker
Userpanel.colorpicker = {}
Userpanel.colorpicker.palette = dxCreateTexture("palette.jpg")
Userpanel.colorpicker.width = 300 * Userpanel.relY
Userpanel.colorpicker.height = 194 * Userpanel.relY
Userpanel.colorpicker.posX = Userpanel.x / 2 - Userpanel.colorpicker.width / 2
Userpanel.colorpicker.posY = Userpanel.y / 2 - Userpanel.colorpicker.height / 2
Userpanel.colorpicker.active = false

Userpanel.pageHeight = nil
Userpanel.maxRows = nil
Userpanel.pageColor = tocolor(20, 20, 20, 240)
Userpanel.selectedTab = 1

Userpanel.scroll = 0
Userpanel.scrollValue = 1
Userpanel.scrollBarHeight = nil
Userpanel.scrollBarWidth = 2 * Userpanel.relY

Userpanel.mapsTab = {}
Userpanel.mapsTab.listPosY = Userpanel.tileHeight + Userpanel.tileOffset

Userpanel.serverName = nil
Userpanel.row = 0
Userpanel.tabs = {}
Userpanel.lists = {}
Userpanel.buttons = {}

Userpanel.languages = {}

Userpanel.flags = {
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

function Userpanel.main()

	Userpanel.maxRows = math.floor((Userpanel.y * 0.75 - Userpanel.tabHeight - Userpanel.tabOffset) / (Userpanel.tileHeight + Userpanel.tileOffset))

	Userpanel.pageHeight = Userpanel.maxRows * (Userpanel.tileHeight + Userpanel.tileOffset) + Userpanel.tileOffset * 2
	Userpanel.posX = Userpanel.x / 2 - Userpanel.width / 2
	Userpanel.posY = Userpanel.y / 2 - Userpanel.getUserpanelHeight() / 2

	for i, flag in ipairs(Userpanel.flags) do
			
		Userpanel.flags[flag] = i-1
		
	end

	bindKey("F7", "down", Userpanel.show)
		
	Userpanel.addTab(1, "Statistics")
	Userpanel.addTab(2, "Clans")
	Userpanel.addTab(3, "Maps")
	Userpanel.addTab(4, "Toptimes")
	Userpanel.addTab(5, "Achievements")
	Userpanel.addTab(6, "Settings")
	Userpanel.addTab(7, "Help")

	Userpanel.createPage(1, "stats")
	Userpanel.createPage(1, "player_stats")	
	Userpanel.createPage(2, "clans")
	Userpanel.createPage(2, "clan_members")
	Userpanel.createPage(3, "maps")
	Userpanel.createPage(3, "maps_details")
	Userpanel.createPage(4, "toptimes")
	Userpanel.createPage(6, "settings")
	Userpanel.createPage(6, "settings_data")
	Userpanel.createPage(7, "help")
	Userpanel.createPage(7, "help_details")

	Userpanel.createList("stats", Userpanel.tileOffset, 3, Userpanel.tileHeight, Userpanel.maxRows - 1, "left")
	Userpanel.createList("stats_title", Userpanel.tileOffset, 1, Userpanel.tileHeightSmall, 1, "center")
	Userpanel.createList("player_stats", Userpanel.tileOffset, 3, Userpanel.tileHeight, Userpanel.maxRows - 2, "center")
	Userpanel.createList("clans", Userpanel.tileOffset, 3, Userpanel.tileHeight, Userpanel.maxRows - 1, "left")
	Userpanel.createList("clan_title", Userpanel.tileOffset, 1, Userpanel.tileHeightSmall, 1, "center")
	Userpanel.createList("clan_members", Userpanel.tileOffset, 3, Userpanel.tileHeight, Userpanel.maxRows - 2, "left")	
	Userpanel.createList("maps", Userpanel.tileOffset, 2, Userpanel.tileHeight, Userpanel.maxRows - 1, "left")
	Userpanel.createList("maps_title", Userpanel.tileOffset, 1, Userpanel.tileHeightSmall, 1, "center")
	Userpanel.createList("maps_details", Userpanel.tileOffset, 3, Userpanel.tileHeight, Userpanel.maxRows - 2, "center")
	Userpanel.createList("settings", Userpanel.tileOffset, 1, Userpanel.tileHeight, Userpanel.maxRows - 1, "left")
	Userpanel.createList("settings_data", Userpanel.tileOffset, 4, Userpanel.tileHeight, Userpanel.maxRows - 2, "center")
	Userpanel.createList("toptimes_title", Userpanel.tileOffset, 1, Userpanel.tileHeightSmall, 1, "center")
	Userpanel.createList("toptimes", Userpanel.tileOffset, 2, Userpanel.tileHeight, Userpanel.maxRows - 1, "left")
	Userpanel.createList("help", Userpanel.tileOffset, 1, Userpanel.tileHeight, Userpanel.maxRows - 1, "left")
	Userpanel.createList("help_title", Userpanel.tileOffset, 1, Userpanel.tileHeightSmall, 1, "center")
	Userpanel.createList("help_details", Userpanel.tileOffset, 1, Userpanel.tileHeight, Userpanel.maxRows - 2, "left")
	
	Userpanel.createSearchbar(Userpanel.lists["stats"], "stats", "Search for a player...")	
	Userpanel.createSearchbar(Userpanel.lists["clans"], "clans", "Search for a clan...")
	Userpanel.createSearchbar(Userpanel.lists["clan_members"], "clan_members", "Search for a members...")	
	Userpanel.createSearchbar(Userpanel.lists["maps"], "maps", "Search for a map...")
	Userpanel.createSearchbar(Userpanel.lists["settings"], "settings", "Search the settings...")
	Userpanel.createSearchbar(Userpanel.lists["settings_data"], "settings", "Search for entries...")
	Userpanel.createSearchbar(Userpanel.lists["toptimes"], "toptimes", "Search for a toptime...")
	Userpanel.createSearchbar(Userpanel.lists["help"], "help", "Search the help...")
	Userpanel.createSearchbar(Userpanel.lists["help_details"], "help", "Search the help...")
	
	Userpanel.mapsBackButtonPosX = Userpanel.posX + Userpanel.width / 2 - (Userpanel.mapsBackButtonWidth + Userpanel.buyButtonWidth + Userpanel.buttonOffset) / 2
	Userpanel.mapsBackButtonPosY = Userpanel.posY + Userpanel.pageHeight - Userpanel.tileHeight / 2 + Userpanel.backButtonHeight / 2
	
	Userpanel.buyButtonPosX = Userpanel.mapsBackButtonPosX + Userpanel.mapsBackButtonWidth + Userpanel.buttonOffset
	Userpanel.buyButtonPosY = Userpanel.posY + Userpanel.pageHeight - Userpanel.tileHeight / 2 + Userpanel.buyButtonHeight / 2
	
	Userpanel.backButtonPosX = Userpanel.posX + Userpanel.width / 2 - Userpanel.backButtonWidth / 2
	Userpanel.backButtonPosY = Userpanel.posY + Userpanel.pageHeight - Userpanel.tileHeight / 2 + Userpanel.backButtonHeight / 2
	
	Userpanel.createButton("buymap", Userpanel.buyButtonText, Userpanel.buyButtonPosX, Userpanel.buyButtonPosY, Userpanel.buyButtonWidth, Userpanel.buyButtonHeight, Userpanel.buyButtonColor, Userpanel.buyButtonFont, Userpanel.buyButtonFontSize)
	Userpanel.createButton("maps_back", Userpanel.mapsBackButtonText, Userpanel.mapsBackButtonPosX, Userpanel.mapsBackButtonPosY, Userpanel.mapsBackButtonWidth, Userpanel.mapsBackButtonHeight, Userpanel.mapsBackButtonColor, Userpanel.mapsBackButtonFont, Userpanel.mapsBackButtonFontSize)

	Userpanel.createButton("back", Userpanel.backButtonText, Userpanel.backButtonPosX, Userpanel.backButtonPosY, Userpanel.backButtonWidth, Userpanel.backButtonHeight, Userpanel.backButtonColor, Userpanel.backButtonFont, Userpanel.backButtonFontSize)

	Userpanel.createTile(Userpanel.lists["help"], "Server rules", {detail = "Basis rules that you should follow"})
	Userpanel.createTile(Userpanel.lists["help"], "How to play", {detail = "Everything you need to know about how to play"})
	Userpanel.createTile(Userpanel.lists["help"], "Player commands", {detail = "A list of commands all players can use"})	
	Userpanel.createTile(Userpanel.lists["help"], "Admin commands", {detail = "A list of commands admins can use"})
	Userpanel.createTile(Userpanel.lists["help"], "Report a player", {detail = "Report a player for who is not following the rules"})
	
	triggerServerEvent("onUserpanelRequestServerInfo", localPlayer)
	
end
addEventHandler("onClientResourceStart", resourceRoot, Userpanel.main)


function Userpanel.show()
	
	if not Userpanel.showing then
	
		Userpanel.showing = true
		showCursor(true)	
		Userpanel.scroll = 0
		Userpanel.row = 0
		guiSetInputMode("no_binds")
		
		triggerServerEvent("onUserpanelRequestSettings", localPlayer)
		triggerServerEvent("onUserpanelRequestMaps", localPlayer)
		triggerServerEvent("onUserpanelRequestClans", localPlayer)
		triggerServerEvent("onUserpanelRequestMyTops", localPlayer, getElementData(localPlayer, "account"))
		Userpanel.selectTabpage(1, "stats")
		Userpanel.selectTabpage(2, "clans")
		Userpanel.selectTabpage(3, "maps")
		Userpanel.selectTabpage(4, "toptimes")
		Userpanel.selectTabpage(6, "settings")
		Userpanel.selectTabpage(7, "help")
		Userpanel.requestPlayers()
	
		Userpanel.lists["stats_title"].data = {}	
		Userpanel.createTile(Userpanel.lists["stats_title"], Userpanel.serverName, {})	
	
		Userpanel.selectTab(1)
	
	else
	
		for i, list in pairs(Userpanel.lists) do
		
			Userpanel.selectTile(list, false)
		
		end
	
		guiSetInputMode("allow_binds")
		Userpanel.showing = false
		Userpanel.colorpicker.active = false
		showCursor(false)
	
	end
	
end


function Userpanel.key(button, pressOrRelease)

	if not Userpanel.showing then return end

	if not pressOrRelease then return end
	
	if not isCursorShowing() then return end
	
	if button == "mouse_wheel_up" then
	
		Userpanel.processScroll(true)
		
	elseif button == "mouse_wheel_down" then
	
		Userpanel.processScroll(false)

	elseif button == "mouse1" then
	
		if Userpanel.colorpicker.active then
		
			local mouseX, mouseY = getCursorPosition()

			if not mouseX then return false end
			
			mouseX = mouseX * Userpanel.x
			mouseY = mouseY * Userpanel.y

			local pixels = dxGetTexturePixels(Userpanel.colorpicker.palette)

			local r, g, b = dxGetPixelColor(pixels, (mouseX - Userpanel.colorpicker.posX) * (600 / Userpanel.colorpicker.width), (mouseY - Userpanel.colorpicker.posY) * (388 / Userpanel.colorpicker.height))
			
			if r then
			
				Userpanel.lists["settings"].data[Userpanel.lists["settings"].selectedTile].data.color = string.format("#%.2X%.2X%.2X", r, g, b)
				
				Userpanel.settingsSave()
			
			end
			
			Userpanel.colorpicker.active = false
			return
		
		end
	
		--reset searchbar
		for key, list in pairs(Userpanel.lists) do
			
			if list.searchbar and list.searchbar.active then
			
				list.searchbar.active = false
			
			end
		
		end
	
		for i, tab in pairs(Userpanel.tabs) do

			if tab.selected then
			
				Userpanel.selectTab(i)
				break
				
			end

		end
				
		for key, list in pairs(Userpanel.lists) do
			
			if list.active then
			
				for i, tile in pairs(list.data) do
					
					if tile.selected then
						
						triggerEvent("onClientUserpanelTileClick", localPlayer, key, tile, i)
						
						Userpanel.selectTile(list, i, true)
						break
						
					end
				
				end	
			
			end
		
		end		
				
		for i, list in pairs(Userpanel.lists) do
			
			if list.searchbar and list.searchbar.selected then
			
				list.searchbar.active = true
				break
			
			end
		
		end	
		
		for key, button in pairs(Userpanel.buttons) do

			if button.selected then
			
				button.selected = false
				
				triggerEvent("onClientUserpanelButtonClick", localPlayer, key, button)
				break
			
			end		
		
		end		
		
	elseif button == "backspace" then
	
		for i, list in pairs(Userpanel.lists) do
		
			if list.searchbar and list.searchbar.active then
			
				list.searchbar.query = list.searchbar.query:sub(1, -2)
				break
			
			end		
		
		end

	end

end
addEventHandler("onClientKey", root, Userpanel.key)


function Userpanel.input(character)

	if not Userpanel.showing then return end

	for i, list in pairs(Userpanel.lists) do
	
		if list.searchbar and list.searchbar.active then
		
			list.searchbar.query = list.searchbar.query..character
			break
		
		end		
	
	end
	
end
addEventHandler("onClientCharacter", root, Userpanel.input)


function Userpanel.processScroll(direction)

	for i, list in pairs(Userpanel.lists) do

		if list.active then
			
			if direction then
			
				list.scroll = list.scroll - Userpanel.scrollValue
				
			else
			
				list.scroll = list.scroll + Userpanel.scrollValue

			end	
			
			if list.scroll < 0 then
			
				list.scroll = 0
				
			elseif list.scroll > Userpanel.getUserpanelRowCount(list) - list.maxRows then
				
				list.scroll = Userpanel.getUserpanelRowCount(list) - list.maxRows
				
			end
		
		end
		
	end
	
end


function Userpanel.getUserpanelRowCount(list)

	local rows = 0

	for i, tile in pairs(list.data) do
	
		rows = rows + 1 / list.tilesPerRow
	
	end
	
	return math.ceil(rows)

end


function Userpanel.selectTab(tab)

	Userpanel.tabs[Userpanel.selectedTab].active = false

	Userpanel.tabs[tab].active = true
		
	Userpanel.selectedTab = tab

end


function Userpanel.selectTabpage(tab, page)

	for i, tabpage in pairs(Userpanel.tabs[tab].pages) do
	
		if tabpage.name == page then
		
			tabpage.active = true
			
		else
		
			tabpage.active = false
			
		end
	
	end

end


function Userpanel.selectTile(list, tile, state)
	
	if list.selectedTile then
	
		if list.selectedTile ~= tile then
		
			if list.data[list.selectedTile] then
			
				list.data[list.selectedTile].active = false

			end

		end

	end
	
	if not tile then
		
		list.selectedTile = nil
		return
		
	end
	
	if state then
		
		list.data[tile].active = true
		list.selectedTile = tile
				
	else
		
		Userpanel.selectTile(list, false)
			
	end

end


function Userpanel.createPage(tab, name)

	Userpanel.tabs[tab].pages[name] = {name = name, active = false}
	
end


function Userpanel.createButton(name, text, posX, posY, width, height, color, font, fontSize)

	Userpanel.buttons[name] = {text = text, posX = posX, posY = posY, width = width, height = height, color = color, font = font, fontSize = fontSize, selected = false}
		
end


function Userpanel.createSearchbar(list, name, hintText)

	local width = Userpanel.width - Userpanel.tileOffset * 2

	list.searchbar = {name = name, query = "", width = width, height = Userpanel.tileHeightSmall, hintText = hintText, selected = false, active = false}

end


function Userpanel.createTile(list, name, data)

	table.insert(list.data, {name = name, data = data, selected = false, active = false})

end

function Userpanel.createList(name, posY, tilesPerRow, tileHeight, maxRows, align)

	local width = Userpanel.width / tilesPerRow - Userpanel.tileOffset * ((tilesPerRow + 1) / tilesPerRow)

	local height = maxRows * (tileHeight + Userpanel.tileOffset)

	Userpanel.lists[name] = {name = name, data = {}, scroll = 0, posY = posY, tileWidth = width, tileHeight = tileHeight, height = height, tilesPerRow = tilesPerRow, selectedTile = nil, maxRows = maxRows, align = align, searchbar = nil, active = false}

end


function Userpanel.addTab(position, name)

	local width = dxGetTextWidth(name, Userpanel.tabFontSize, Userpanel.tabFont) * 1.5

	table.insert(Userpanel.tabs, position, {name = name, width = width, list = nil, pages = {}, active = false, selected = false})

end


function Userpanel.getUserpanelHeight()

	return Userpanel.tabHeight + Userpanel.tabOffset + Userpanel.pageHeight

end


function Userpanel.render()

	if not Userpanel.showing then return end
	
	for i, list in pairs(Userpanel.lists) do
	
		list.active = false
	
	end	

	Userpanel.currentPosY = Userpanel.posY

	local posX = Userpanel.posX

	for i, tab in pairs(Userpanel.tabs) do
	
		local color, fontColor
		
		if Userpanel.mouseCheck(posX, Userpanel.currentPosY, tab.width, Userpanel.tabHeight) then
		
			tab.selected = true
		
		else
		
			tab.selected = false
		
		end
		
		if tab.active then
		
			color = Userpanel.tabActiveColor
			
			fontColor = Userpanel.tabActiveFontColor
			
		else
		
			if tab.selected then
			
				color = Userpanel.tabHighlightColor
				
			else
			
				color = Userpanel.tabColor
				
			end
			
			fontColor = Userpanel.tabFontColor
		
		end
	
		dxDrawRectangle(posX, Userpanel.currentPosY, tab.width, Userpanel.tabHeight, color, Userpanel.postGui)
		dxDrawText(tab.name, posX, Userpanel.currentPosY, posX + tab.width, Userpanel.currentPosY + Userpanel.tabHeight, fontColor, Userpanel.tabFontSize, Userpanel.tabFont, "center", "center", false, false, Userpanel.postGui)
	
		posX = posX + tab.width + Userpanel.tabOffset
	
	end
	
	Userpanel.currentPosY = Userpanel.currentPosY + Userpanel.tabHeight + Userpanel.tabOffset
	
	dxDrawRectangle(Userpanel.posX, Userpanel.currentPosY, Userpanel.width, Userpanel.pageHeight, Userpanel.pageColor, Userpanel.postGui)
	
	if Userpanel.tabs[Userpanel.selectedTab].name == "Statistics" then
	
		Userpanel.drawStatisticsPage()
	
	elseif Userpanel.tabs[Userpanel.selectedTab].name == "Clans" then
	
		Userpanel.drawClansPage()
	
	elseif Userpanel.tabs[Userpanel.selectedTab].name == "Maps" then
			
		Userpanel.drawMapsPage()
		
	elseif Userpanel.tabs[Userpanel.selectedTab].name == "Settings" then
			
		Userpanel.drawSettingsPage()		
		
	elseif Userpanel.tabs[Userpanel.selectedTab].name == "Toptimes" then
			
		Userpanel.drawToptimesPage()	
		
	elseif Userpanel.tabs[Userpanel.selectedTab].name == "Achievements" then
			
		Userpanel.drawAchievementsPage()	
		
		
	elseif Userpanel.tabs[Userpanel.selectedTab].name == "Help" then
			
		Userpanel.drawHelpPage()	
		
	end

	if Userpanel.colorpicker.active then
	
		Userpanel.drawColorPicker()
		
	end

	if getTickCount() - Userpanel.lastTick > 500 then
	
		Userpanel.lastTick = getTickCount()
			
	end

end
addEventHandler("onClientRender", root, Userpanel.render)


function Userpanel.drawStatisticsPage()
	
	if Userpanel.tabs[1].pages["player_stats"].active then
	
		if #Userpanel.lists["player_stats"].data == 0 then
	
			dxDrawText("No data available", Userpanel.posX, Userpanel.posY, Userpanel.posX + Userpanel.width, Userpanel.posY + Userpanel.pageHeight, tocolor(255, 255, 255, 255), Userpanel.tileFontSize, Userpanel.tileFont, "center", "center", false, false, Userpanel.postGui, true)
			
		else
		
			Userpanel.drawList(Userpanel.lists["stats_title"])
		
			Userpanel.drawList(Userpanel.lists["player_stats"])
			
		end
		
		Userpanel.drawButton(Userpanel.buttons["back"])

	elseif Userpanel.tabs[1].pages["stats"].active then
		
		Userpanel.drawSearchBar(Userpanel.lists["stats"].searchbar)
		
		Userpanel.drawList(Userpanel.lists["stats_title"])
		
		Userpanel.drawList(Userpanel.lists["stats"])
	
	end

end


function Userpanel.drawClansPage()

	if Userpanel.tabs[2].pages["clan_members"].active then
		
		Userpanel.drawSearchBar(Userpanel.lists["clan_members"].searchbar)
		
		Userpanel.drawList(Userpanel.lists["clan_title"])
		
		Userpanel.drawList(Userpanel.lists["clan_members"])	
	
		Userpanel.drawButton(Userpanel.buttons["back"])
		
		if Userpanel.lists["clan_members"].selectedTile then
		
		
		
		end
	
	elseif Userpanel.tabs[2].pages["clans"].active then
		
		Userpanel.drawSearchBar(Userpanel.lists["clans"].searchbar)
		
		Userpanel.drawList(Userpanel.lists["clans"])

	end

end


function Userpanel.drawMapsPage()

	if Userpanel.tabs[3].pages["maps_details"].active then

		if #Userpanel.lists["maps_details"].data == 0 then
	
			dxDrawText("No data available", Userpanel.posX, Userpanel.posY, Userpanel.posX + Userpanel.width, Userpanel.posY + Userpanel.pageHeight, tocolor(255, 255, 255, 255), Userpanel.tileFontSize, Userpanel.tileFont, "center", "center", false, false, Userpanel.postGui, true)
			
		else

			Userpanel.drawList(Userpanel.lists["maps_title"])

			Userpanel.drawList(Userpanel.lists["maps_details"])
			
			Userpanel.drawButton(Userpanel.buttons["buymap"])
			
		end
		
		Userpanel.drawButton(Userpanel.buttons["maps_back"])	

	elseif Userpanel.tabs[3].pages["maps"].active then
		
		Userpanel.drawSearchBar(Userpanel.lists["maps"].searchbar)
		
		Userpanel.drawList(Userpanel.lists["maps"])
	
	end

end


function Userpanel.drawSettingsPage()

	if Userpanel.tabs[6].pages["settings"].active then
	
		Userpanel.drawSearchBar(Userpanel.lists["settings"].searchbar)
	
		Userpanel.drawList(Userpanel.lists["settings"])
	
	elseif Userpanel.tabs[6].pages["settings_data"].active then
	
		Userpanel.drawSearchBar(Userpanel.lists["settings_data"].searchbar)
	
		Userpanel.drawList(Userpanel.lists["settings_data"])
		
		Userpanel.drawButton(Userpanel.buttons["back"])	
	
	end
	
end


function Userpanel.drawToptimesPage()

	if Userpanel.tabs[4].pages["toptimes"].active then
	
		Userpanel.drawSearchBar(Userpanel.lists["toptimes"].searchbar)
	
		Userpanel.drawList(Userpanel.lists["toptimes_title"])
	
		Userpanel.drawList(Userpanel.lists["toptimes"])

	end

end


function Userpanel.drawAchievementsPage()

	dxDrawText("Coming soon.", Userpanel.posX, Userpanel.posY, Userpanel.posX + Userpanel.width, Userpanel.posY + Userpanel.pageHeight, tocolor(255, 255, 255, 255), Userpanel.tileFontSize, Userpanel.tileFont, "center", "center", false, false, Userpanel.postGui, true)
	
end


function Userpanel.drawHelpPage()

	if Userpanel.tabs[7].pages["help_details"].active then

		Userpanel.drawSearchBar(Userpanel.lists["help_details"].searchbar)

		Userpanel.drawList(Userpanel.lists["help_title"])

		Userpanel.drawList(Userpanel.lists["help_details"])

		Userpanel.drawButton(Userpanel.buttons["back"])

	elseif Userpanel.tabs[7].pages["help"].active then
	
		Userpanel.drawSearchBar(Userpanel.lists["help"].searchbar)
	
		Userpanel.drawList(Userpanel.lists["help"])
	
	end

end


function Userpanel.drawButton(button)

	if Userpanel.mouseCheck(button.posX, button.posY, button.width, button.height) then
		
		dxDrawRectangle(button.posX, button.posY, button.width, button.height, button.color, Userpanel.postGui)
		
		dxDrawText(button.text, button.posX, button.posY, button.posX + button.width, button.posY + button.height, tocolor(102, 102, 102, 255), button.fontSize, button.font, "center", "center", false, false, Userpanel.postGui)
		button.selected = true
		
	else
		
		dxDrawLine(button.posX, button.posY, button.posX + button.width, button.posY, tocolor(255, 255, 255, 255), 1, Userpanel.postGui)
		dxDrawLine(button.posX, button.posY + button.height, button.posX + button.width, button.posY + button.height, tocolor(255, 255, 255, 255), 1, Userpanel.postGui)
		dxDrawLine(button.posX, button.posY, button.posX, button.posY + button.height, tocolor(255, 255, 255, 255), 1, Userpanel.postGui)
		dxDrawLine(button.posX + button.width, button.posY, button.posX + button.width, button.posY + button.height, tocolor(255, 255, 255, 255), 1, Userpanel.postGui)
		
		dxDrawText(button.text, button.posX, button.posY, button.posX + button.width, button.posY + button.height, tocolor(255, 255, 255, 255), button.fontSize, button.font, "center", "center", false, false, Userpanel.postGui)
		button.selected = false
		
	end

end


function Userpanel.drawSearchBar(searchbar)

	Userpanel.currentPosY = Userpanel.currentPosY + Userpanel.tileOffset

	if Userpanel.mouseCheck(Userpanel.posX, Userpanel.currentPosY, searchbar.width, searchbar.height) then

		searchbar.selected = true

	else
	
		searchbar.selected = false
	
	end

	local color, blinkCharacter

	if searchbar.selected then
	
		color = Userpanel.tileHighlightColor
		
	else
	
		color = Userpanel.tileColor
		
	end

	dxDrawRectangle(Userpanel.posX + Userpanel.tileOffset, Userpanel.currentPosY, searchbar.width, searchbar.height, color, Userpanel.postGui)
	
	if getTickCount() - Userpanel.lastTick > 500 then
	
		Userpanel.blink = not Userpanel.blink
	
	end
	
	if searchbar.active and Userpanel.blink then
	
		blinkCharacter = "|"
		
	else
	
		blinkCharacter = ""
		
	end
	
	if not searchbar.active and searchbar.query == "" then
	
		dxDrawText(searchbar.hintText, Userpanel.posX + Userpanel.tileOffset + Userpanel.tileTextOffset, Userpanel.currentPosY, Userpanel.posX + Userpanel.tileTextOffset + searchbar.width, Userpanel.currentPosY + searchbar.height, tocolor(255, 255, 255, 255), Userpanel.tileFontSize, Userpanel.tileFont, "left", "center", false, false, Userpanel.postGui, true)

	else
	
		dxDrawText(searchbar.query..blinkCharacter, Userpanel.posX + Userpanel.tileOffset + Userpanel.tileTextOffset, Userpanel.currentPosY, Userpanel.posX + Userpanel.tileTextOffset + searchbar.width, Userpanel.currentPosY + searchbar.height, tocolor(255, 255, 255, 255), Userpanel.tileFontSize, Userpanel.tileFont, "left", "center", false, false, Userpanel.postGui, true)

	end

	Userpanel.currentPosY = Userpanel.currentPosY + searchbar.height

end


function Userpanel.drawList(list)

	list.active = true

	Userpanel.row = 1

	Userpanel.currentPosY = Userpanel.currentPosY + list.posY

	local filter = ""

	if list.searchbar then
	
		filter =  list.searchbar.query:lower()
				
	end

	local startPosY = Userpanel.currentPosY

	local index = 1

	for i, tile in pairs(list.data) do
	
		local tileName = tile.name:gsub("#%x%x%x%x%x%x", "")

		if tileName:lower():find(filter) then
		
			local position = (index - 1) % list.tilesPerRow
			
			Userpanel.drawTile(list, tile, index, position)
		
			if position + 1 == list.tilesPerRow then
		
				Userpanel.row = Userpanel.row + 1

			end
			
			index = index + 1
			
		end
	
	end
	
	Userpanel.drawScrollbar(startPosY, list)

end


function Userpanel.drawTile(list, tile, index, position)
	
	tile.selected = false
	
	if Userpanel.row - list.scroll > list.maxRows then return end
	
	if Userpanel.row - list.scroll <= 0 then return end
	
	local color

	local posX = Userpanel.posX + Userpanel.tileOffset + (list.tileWidth + Userpanel.tileOffset) * position

	if Userpanel.mouseCheck(posX, Userpanel.currentPosY, list.tileWidth, list.tileHeight) then

		tile.selected = true

	else
	
		tile.selected = false
	
	end

	if tile.selected then
	
		color = Userpanel.tileHighlightColor
		
	else
	
		color = Userpanel.tileColor
		
	end

	dxDrawRectangle(posX, Userpanel.currentPosY, list.tileWidth, list.tileHeight, color, Userpanel.postGui)	

	Userpanel.drawTileContent(list, posX, tile)

	if position + 1 == list.tilesPerRow then

		if index < #list.data then
		
			Userpanel.currentPosY = Userpanel.currentPosY + list.tileHeight + Userpanel.tileOffset

		else
		
			Userpanel.currentPosY = Userpanel.currentPosY + list.tileHeight

		end

	end

end


function Userpanel.drawTileContent(list, posX, tile)

	if list.name == "clans" then
		
		local name = Userpanel.textOverflow(tile.name, "", Userpanel.tileFontSize, Userpanel.tileFont, list.tileWidth - Userpanel.avatarWidth - Userpanel.tileTextOffset * 4)

		local posY = Userpanel.currentPosY + list.tileHeight / 2 - Userpanel.avatarHeight / 2
		
		dxDrawImage(posX + Userpanel.tileTextOffset, posY, Userpanel.avatarWidth, Userpanel.avatarHeight, Userpanel.clans, 0, 0, 0, tocolor(255, 255, 255, 255), Userpanel.postGui)

		local memberCountPosX = posX

		posX = posX + Userpanel.avatarWidth + Userpanel.tileTextOffset * 3	

		dxDrawText(name, posX + Userpanel.tileTextOffset, Userpanel.currentPosY, posX + Userpanel.tileTextOffset + list.tileWidth, Userpanel.currentPosY + list.tileHeight, fontColor, Userpanel.tileFontSize, Userpanel.tileFont, list.align, "center", false, false, Userpanel.postGui, true)

		dxDrawText(tile.data.memberCount, memberCountPosX, Userpanel.currentPosY, memberCountPosX + list.tileWidth - Userpanel.tileTextOffset, Userpanel.currentPosY + list.tileHeight - Userpanel.tileTextOffset, Userpanel.clanMemberCountDetailsTileFontColor, Userpanel.clanMemberCountDetailsTileFontSize, Userpanel.clanMemberCountDetailsTileFont, "right", "bottom", false, false, Userpanel.postGui, true)

	elseif list.name == "clan_members" then
	
		local name = Userpanel.textOverflow(tile.name, "", Userpanel.statsTileFontSize, Userpanel.statsTileFont, list.tileWidth - Userpanel.avatarWidth - Userpanel.tileTextOffset * 4)
		
		local posY = Userpanel.currentPosY + list.tileHeight / 2 - Userpanel.avatarHeight / 2
		
		dxDrawImage(posX + Userpanel.tileTextOffset, posY, Userpanel.avatarWidth, Userpanel.avatarHeight, Userpanel.avatar, 0, 0, 0, tocolor(255, 255, 255, 255), Userpanel.postGui)

		posX = posX + Userpanel.avatarWidth + Userpanel.tileTextOffset * 3	

		posY = Userpanel.currentPosY + list.tileHeight / 2 - (Userpanel.statsTileFontHeight + Userpanel.statsDetailsTileFontHeight) / 2

		dxDrawText(name, posX, posY, posX + Userpanel.tileTextOffset + list.tileWidth, posY + Userpanel.statsTileFontHeight, Userpanel.statsTileFontColor, Userpanel.statsTileFontSize, Userpanel.statsTileFont, "left", "top", false, false, Userpanel.postGui, true)

		posY = posY + Userpanel.statsTileFontHeight

		dxDrawText(tile.data.detail, posX, posY, posX + Userpanel.tileTextOffset + list.tileWidth, posY + Userpanel.statsDetailsTileFontHeight, Userpanel.statsDetailsTileFontColor, Userpanel.statsDetailsTileFontSize, Userpanel.statsDetailsTileFont, "left", "top", false, false, Userpanel.postGui, true)

	elseif list.name == "maps" then
				
		local name = Userpanel.textOverflow(tile.name, "", Userpanel.mapsTileFontSize, Userpanel.mapsTileFont, list.tileWidth - Userpanel.avatarWidth - Userpanel.tileTextOffset * 4)
		
		local posY = Userpanel.currentPosY + list.tileHeight / 2 - Userpanel.avatarHeight / 2
		
		dxDrawImage(posX + Userpanel.tileTextOffset, posY, Userpanel.avatarWidth, Userpanel.avatarHeight, Userpanel.maps, 0, 0, 0, tocolor(255, 255, 255, 255), Userpanel.postGui)

		local originalPosX = posX

		posX = posX + Userpanel.avatarWidth + Userpanel.tileTextOffset * 3	
		
		local posY = Userpanel.currentPosY + list.tileHeight / 2 - (Userpanel.mapsTileFontHeight + Userpanel.mapsDetailsTileFontHeight) / 2
		
		dxDrawText(name, posX + Userpanel.tileTextOffset, posY, posX + Userpanel.tileTextOffset + list.tileWidth, posY + Userpanel.mapsTileFontHeight, Userpanel.mapsTileFontColor, Userpanel.mapsTileFontSize, Userpanel.mapsTileFont, "left", "top", false, false, Userpanel.postGui, true)

		posY = posY + Userpanel.mapsTileFontHeight

		dxDrawText(tile.data.detail, posX + Userpanel.tileTextOffset, posY, posX + Userpanel.tileTextOffset + list.tileWidth, posY + Userpanel.mapsDetailsTileFontHeight, Userpanel.mapsDetailsTileFontColor, Userpanel.mapsDetailsTileFontSize, Userpanel.mapsDetailsTileFont, "left", "top", false, false, Userpanel.postGui, true)

		local posY = Userpanel.currentPosY + Userpanel.tileTextOffset
	
		if tile.data.favorite then
	
			dxDrawImage(originalPosX + list.tileWidth - Userpanel.favoriteWidth - Userpanel.tileTextOffset, posY, Userpanel.favoriteWidth, Userpanel.favoriteHeight, Userpanel.favorite, 0, 0, 0, tocolor(255, 0, 0, 255), Userpanel.postGui)

		end

	elseif list.name == "stats" then
		
		local name = Userpanel.textOverflow(tile.name, "", Userpanel.statsTileFontSize, Userpanel.statsTileFont, list.tileWidth - Userpanel.avatarWidth - Userpanel.tileTextOffset * 4)
		
		local posY = Userpanel.currentPosY + list.tileHeight / 2 - Userpanel.avatarHeight / 2
		
		dxDrawImage(posX + Userpanel.tileTextOffset, posY, Userpanel.avatarWidth, Userpanel.avatarHeight, Userpanel.avatar, 0, 0, 0, tocolor(255, 255, 255, 255), Userpanel.postGui)

		posX = posX + Userpanel.avatarWidth + Userpanel.tileTextOffset * 3

		posY = Userpanel.currentPosY + list.tileHeight / 2 - (Userpanel.statsTileFontHeight + Userpanel.statsDetailsTileFontHeight) / 2

		dxDrawText(name, posX, posY, posX + Userpanel.tileTextOffset + list.tileWidth, posY + Userpanel.statsTileFontHeight, Userpanel.statsTileFontColor, Userpanel.statsTileFontSize, Userpanel.statsTileFont, "left", "top", false, false, Userpanel.postGui, true)

		posY = posY + Userpanel.statsTileFontHeight

		dxDrawText(tile.data.detail, posX, posY, posX + Userpanel.tileTextOffset + list.tileWidth, posY + Userpanel.statsDetailsTileFontHeight, Userpanel.statsDetailsTileFontColor, Userpanel.statsDetailsTileFontSize, Userpanel.statsDetailsTileFont, "left", "top", false, false, Userpanel.postGui, true)

	elseif list.name == "maps_details" then
		
		if tile.name == "Favorite" then
		
			local posY = Userpanel.currentPosY + list.tileHeight / 2 - Userpanel.avatarHeight / 2
		
			if tile.data.detail then
		
				dxDrawImage(posX + list.tileWidth / 2 - Userpanel.favoriteWidth / 2, posY, Userpanel.favoriteWidth, Userpanel.favoriteHeight, Userpanel.favorite, 0, 0, 0, tocolor(255, 0, 0, 255), Userpanel.postGui)
			
			else
			
				dxDrawImage(posX + list.tileWidth / 2 - Userpanel.favoriteWidth / 2, posY, Userpanel.favoriteWidth, Userpanel.favoriteHeight, Userpanel.favorite, 0, 0, 0, tocolor(255, 255, 255, 255), Userpanel.postGui)
			
			end
			
			dxDrawText(tile.name, posX + Userpanel.tileTextOffset, Userpanel.currentPosY + Userpanel.playerStatsColumnTileFontHeight, posX + list.tileWidth - Userpanel.tileTextOffset, Userpanel.currentPosY + Userpanel.playerStatsColumnTileFontHeight + Userpanel.tileHeight, Userpanel.playerStatsColumnTileFontColor, Userpanel.playerStatsColumnTileFontSize, Userpanel.playerStatsColumnTileFont, "center", "center", false, false, Userpanel.postGui, true)

		else
		
			local detail = Userpanel.textOverflow(tile.data.detail, "", Userpanel.playerStatsDataTileFontSize, Userpanel.playerStatsDataTileFont, list.tileWidth - Userpanel.tileTextOffset * 2)
		
			dxDrawText(detail, posX + Userpanel.tileTextOffset, Userpanel.currentPosY, posX + Userpanel.tileTextOffset + list.tileWidth, Userpanel.currentPosY + list.tileHeight, Userpanel.playerStatsDataTileFontColor, Userpanel.playerStatsDataTileFontSize, Userpanel.playerStatsDataTileFont, "center", "center", false, false, Userpanel.postGui, true)

			dxDrawText(tile.name, posX + Userpanel.tileTextOffset, Userpanel.currentPosY + Userpanel.playerStatsColumnTileFontHeight, posX + Userpanel.tileTextOffset + list.tileWidth, Userpanel.currentPosY + Userpanel.playerStatsColumnTileFontHeight + Userpanel.tileHeight, Userpanel.playerStatsColumnTileFontColor, Userpanel.playerStatsColumnTileFontSize, Userpanel.playerStatsColumnTileFont, "center", "center", false, false, Userpanel.postGui, true)

		end

	elseif list.name == "player_stats" then
		
		local detail = Userpanel.textOverflow(tile.data.detail, "", Userpanel.playerStatsDataTileFontSize, Userpanel.playerStatsDataTileFont, list.tileWidth)
		
		local posY = Userpanel.currentPosY + list.tileHeight / 2 - (Userpanel.playerStatsDataTileFontHeight + Userpanel.playerStatsColumnTileFontHeight) / 2
		
		dxDrawText(detail, posX + Userpanel.tileTextOffset, posY, posX + Userpanel.tileTextOffset + list.tileWidth, posY + Userpanel.playerStatsDataTileFontHeight, Userpanel.playerStatsDataTileFontColor, Userpanel.playerStatsDataTileFontSize, Userpanel.playerStatsDataTileFont, "center", "top", false, false, Userpanel.postGui, true)

		posY = posY + Userpanel.playerStatsDataTileFontHeight

		dxDrawText(tile.name, posX + Userpanel.tileTextOffset, posY, posX + Userpanel.tileTextOffset + list.tileWidth, posY + Userpanel.playerStatsColumnTileFontHeight, Userpanel.playerStatsColumnTileFontColor, Userpanel.playerStatsColumnTileFontSize, Userpanel.playerStatsColumnTileFont, "center", "top", false, false, Userpanel.postGui, true)

	elseif list.name == "toptimes" then
		
		local name = Userpanel.textOverflow(tile.name, "", Userpanel.helpTileFontSize, Userpanel.helpTileFont, list.tileWidth - Userpanel.avatarWidth - Userpanel.tileTextOffset * 4)
		
		local posY = Userpanel.currentPosY + list.tileHeight / 2 - Userpanel.avatarWidth / 2
		
		dxDrawImage(posX + Userpanel.tileTextOffset, posY, Userpanel.avatarWidth, Userpanel.avatarHeight, Userpanel.tops, 0, 0, 0, tocolor(255, 255, 255, 255), Userpanel.postGui)

		posX = posX + Userpanel.avatarWidth + Userpanel.tileTextOffset * 3	
		
		local posY = Userpanel.currentPosY + list.tileHeight / 2 - (Userpanel.helpTileFontHeight + Userpanel.helpDetailsTileFontHeight) / 2
		
		dxDrawText(name, posX + Userpanel.tileTextOffset, posY, posX + Userpanel.tileTextOffset + list.tileWidth, posY + Userpanel.helpTileFontHeight, Userpanel.helpTileFontColor, Userpanel.helpTileFontSize, Userpanel.helpTileFont, "left", "top", false, false, Userpanel.postGui, true)

		posY = posY + Userpanel.helpTileFontHeight

		dxDrawText(tile.data.time, posX + Userpanel.tileTextOffset, posY, posX + Userpanel.tileTextOffset + list.tileWidth, posY + Userpanel.helpDetailsTileFontHeight, Userpanel.helpDetailsTileFontColor, Userpanel.helpDetailsTileFontSize, Userpanel.helpDetailsTileFont, "left", "top", false, false, Userpanel.postGui, true)

	elseif list.name == "settings" then

		if tile.data.type == "switch" then
		
			local color

			if tile.data.active then
			
				color = tocolor(61, 206, 106, 100)

			else
				
				color = tocolor(206, 61, 66, 100)

			end
			
			dxDrawRectangle(posX, Userpanel.currentPosY, 2, list.tileHeight, color, Userpanel.postGui)
			
		elseif tile.data.type == "color" then
				
			if tile.data.color then

				local r, g, b = Userpanel.hex2rgb(tile.data.color)
				
				local posY = Userpanel.currentPosY + list.tileHeight / 2 - Userpanel.settingsColorPreviewHeight / 2
					
				dxDrawRectangle(posX + list.tileWidth - Userpanel.settingsColorPreviewWidth * 2, posY, Userpanel.settingsColorPreviewWidth, Userpanel.settingsColorPreviewHeight, tocolor(r, g, b, 255), Userpanel.postGui)
			
			end
			
		elseif tile.data.type == "data" then
				
			if tile.data.display then

				local posY = Userpanel.currentPosY + list.tileHeight / 2 - Userpanel.settingsTileFontHeight / 2

				dxDrawText(tile.data.display, posX + Userpanel.tileTextOffset + 2, posY , posX + list.tileWidth - Userpanel.settingsColorPreviewHeight, posY + Userpanel.settingsTileFontHeight, Userpanel.settingsTileFontColor, Userpanel.settingsTileFontSize, Userpanel.settingsTileFont, "right", "top", false, false, Userpanel.postGui, true)
	
			end
			
		end
		
		local posY = Userpanel.currentPosY + list.tileHeight / 2 - (Userpanel.settingsTileFontHeight + Userpanel.settingsDetailsTileFontHeight) / 2
		
		dxDrawText(tile.name, posX + Userpanel.tileTextOffset + 2, posY , posX + Userpanel.tileTextOffset + list.tileWidth, posY + Userpanel.settingsTileFontHeight, Userpanel.settingsTileFontColor, Userpanel.settingsTileFontSize, Userpanel.settingsTileFont, "left", "top", false, false, Userpanel.postGui, true)

		posY = posY + Userpanel.settingsTileFontHeight

		dxDrawText(tile.data.detail, posX + Userpanel.tileTextOffset + 2, posY, posX + Userpanel.tileTextOffset + list.tileWidth, posY + Userpanel.settingsDetailsTileFontHeight, Userpanel.settingsDetailsTileFontColor, Userpanel.settingsDetailsTileFontSize, Userpanel.settingsDetailsTileFont, "left", "top", false, false, Userpanel.postGui, true)

	elseif list.name == "help" then
		
		local posY = Userpanel.currentPosY + list.tileHeight / 2 - (Userpanel.helpTileFontHeight + Userpanel.helpDetailsTileFontHeight) / 2
		
		dxDrawText(tile.name, posX + Userpanel.tileTextOffset, posY, posX + Userpanel.tileTextOffset + list.tileWidth, posY + Userpanel.helpTileFontHeight, Userpanel.helpTileFontColor, Userpanel.helpTileFontSize, Userpanel.helpTileFont, "left", "top", false, false, Userpanel.postGui, true)

		posY = posY + Userpanel.helpTileFontHeight

		dxDrawText(tile.data.detail, posX + Userpanel.tileTextOffset, posY, posX + Userpanel.tileTextOffset + list.tileWidth, posY + Userpanel.helpDetailsTileFontHeight, Userpanel.helpDetailsTileFontColor, Userpanel.helpDetailsTileFontSize, Userpanel.helpDetailsTileFont, "left", "top", false, false, Userpanel.postGui, true)

	elseif list.name == "help_details" then
		
		local name = Userpanel.textOverflow(tile.name, "", Userpanel.helpCommandsTileFontSize, Userpanel.helpCommandsTileFont, list.tileWidth - Userpanel.tileTextOffset * 2)
		
		local posY = Userpanel.currentPosY + list.tileHeight / 2 - (Userpanel.helpCommandsTileFontSize + Userpanel.helpCommandsDetailsTileFontHeight) / 2
		
		dxDrawText(name, posX + Userpanel.tileTextOffset, posY, posX + Userpanel.tileTextOffset + list.tileWidth, posY + Userpanel.helpCommandsTileFontHeight, Userpanel.helpCommandsTileFontColor, Userpanel.helpCommandsTileFontSize, Userpanel.helpCommandsTileFont, "left", "top", false, false, Userpanel.postGui, true)

		posY = posY + Userpanel.helpCommandsTileFontHeight

		dxDrawText(tile.data.detail, posX + Userpanel.tileTextOffset, posY, posX + Userpanel.tileTextOffset + list.tileWidth, posY + Userpanel.helpCommandsDetailsTileFontHeight, Userpanel.helpCommandsDetailsTileFontColor, Userpanel.helpCommandsDetailsTileFontSize, Userpanel.helpCommandsDetailsTileFont, "left", "top", false, true, Userpanel.postGui, false)

	else
	
		local name = Userpanel.textOverflow(tile.name, "", Userpanel.tileFontSize, Userpanel.tileFont, list.tileWidth - Userpanel.tileTextOffset * 2)
		
		dxDrawText(name, posX + Userpanel.tileTextOffset, Userpanel.currentPosY, posX + Userpanel.tileTextOffset + list.tileWidth, Userpanel.currentPosY + list.tileHeight, fontColor, Userpanel.tileFontSize, Userpanel.tileFont, list.align, "center", false, false, Userpanel.postGui, true)

	end

end


function Userpanel.drawScrollbar(posY, list)

	if Userpanel.getUserpanelRowCount(list) > list.maxRows then
	
		local scrollPercent =  list.scroll / (Userpanel.getUserpanelRowCount(list) - list.maxRows)
		
		Userpanel.scrollBarHeight = list.height * (list.maxRows / Userpanel.getUserpanelRowCount(list))
		
		dxDrawRectangle(Userpanel.posX + Userpanel.width - Userpanel.scrollBarWidth, posY + (list.height - Userpanel.scrollBarHeight - Userpanel.tileOffset) * scrollPercent, Userpanel.scrollBarWidth, Userpanel.scrollBarHeight, tocolor(255, 255, 255, 255), Userpanel.postGui)

	end

end


function Userpanel.drawColorPicker()

	dxDrawRectangle(Userpanel.colorpicker.posX - Userpanel.tileOffset, Userpanel.colorpicker.posY - Userpanel.tileOffset, Userpanel.colorpicker.width + 2 * Userpanel.tileOffset, Userpanel.colorpicker.height + 2 * Userpanel.tileOffset, Userpanel.pageColor, Userpanel.postGui)

	dxDrawImage(Userpanel.colorpicker.posX, Userpanel.colorpicker.posY, Userpanel.colorpicker.width, Userpanel.colorpicker.height, Userpanel.colorpicker.palette, 0, 0, 0, tocolor(255, 255, 255, 255), Userpanel.postGui)

end


function Userpanel.tileClick(type, tile, index)

	if type == "clans" then
		
		Userpanel.lists["clan_members"].data = {}

		Userpanel.lists["clan_title"].data = {}
		
		Userpanel.createTile(Userpanel.lists["clan_title"], tile.data.name, {})

		Userpanel.selectTabpage(2, "clan_members")

		triggerServerEvent("onUserpanelRequestClanMembers", localPlayer, tile.data.id)
		
	elseif type == "clan_members" then
		
		Userpanel.lists["player_stats"].data = {}

		Userpanel.lists["stats_title"].data = {}

		Userpanel.selectTab(1)

		Userpanel.selectTabpage(1, "player_stats")

		triggerServerEvent("onUserpanelRequestPlayerStats", localPlayer, tile.data.account)		
		
	elseif type == "stats" then
				
		Userpanel.lists["player_stats"].data = {}

		Userpanel.lists["stats_title"].data = {}

		if not tile.data.account then return end

		Userpanel.selectTabpage(1, "player_stats")

		triggerServerEvent("onUserpanelRequestPlayerStats", localPlayer, tile.data.account)
		
	elseif type == "player_stats" then
	
		if tile.name == "Toptimes" then
		
			Userpanel.lists["toptimes"].data = {}
		
			Userpanel.lists["toptimes_title"].data = {}
			
			Userpanel.selectTab(4)

			Userpanel.selectTabpage(4, "toptimes")
			
			triggerServerEvent("onUserpanelRequestMyTops", localPlayer, tile.data.account)
			
		end
		
	elseif type == "maps" then
		
		Userpanel.lists["maps_details"].data = {}
	
		Userpanel.lists["maps_title"].data = {}

		if not tile.data.map then return end
	
		Userpanel.selectTabpage(3, "maps_details")
	
		triggerServerEvent("onUserpanelRequestMapDetails", localPlayer, tile.data.map)
	
	elseif type == "maps_details" then
		
		if tile.name == "Favorite" then
			
			Userpanel.lists["maps_details"].data[index].data.detail = not Userpanel.lists["maps_details"].data[index].data.detail
			
			local map = Userpanel.lists["maps_details"].data[index].data.map
			
			triggerServerEvent("onUserpanelUpdateMapFavorite", localPlayer, map, Userpanel.lists["maps_details"].data[index].data.detail) 
			
		elseif tile.name == "Toptimes" then
			
			Userpanel.lists["toptimes"].data = {}
		
			Userpanel.lists["toptimes_title"].data = {}
			
			if not tile.data.map then return end
			
			Userpanel.selectTab(4)
			
			Userpanel.selectTabpage(4, "toptimes")
			
			triggerServerEvent("onUserpanelRequestMapToptimes", localPlayer, tile.data.map)
			
		end
	
	elseif type == "toptimes" then
		
		if tile.data.account then
		
			Userpanel.lists["player_stats"].data = {}

			Userpanel.lists["stats_title"].data = {}
				
			Userpanel.selectTab(1)
		
			Userpanel.selectTabpage(1, "player_stats")
		
			triggerServerEvent("onUserpanelRequestPlayerStats", localPlayer, tile.data.account)
			
		else
		
			Userpanel.lists["maps_details"].data = {}
				
			Userpanel.selectTab(3)
		
			Userpanel.selectTabpage(3, "maps_details")
		
			triggerServerEvent("onUserpanelRequestMapDetails", localPlayer, tile.data.map)
					
		end
			
	elseif type == "settings" then
		
		Userpanel.lists["settings_data"].data = {}
		
		if tile.data.type == "switch" then
			
			Userpanel.lists["settings"].data[index].data.active = not Userpanel.lists["settings"].data[index].data.active
			
			Userpanel.settingsSave()
			
		elseif tile.data.type == "color" then
		
			Userpanel.colorpicker.active = true
			
		elseif tile.data.type == "data" then
		
			if tile.data.code == "player_language" then
			
				triggerServerEvent("onUserpanelRequestLanguages", localPlayer)
				
			elseif tile.data.code == "winsound" then
		
				for i = 1, 67, 1 do

					Userpanel.createTile(Userpanel.lists["settings_data"], "Sound "..i, {display = "Sound "..i, data = i})
					
				end
			
			end
			
			Userpanel.selectTabpage(6, "settings_data")
		
		end
		
	elseif type == "settings_data" then
		
		Userpanel.lists["settings"].data[Userpanel.lists["settings"].selectedTile].data.display = Userpanel.lists["settings_data"].data[index].data.display
		
		Userpanel.lists["settings"].data[Userpanel.lists["settings"].selectedTile].data.data = Userpanel.lists["settings_data"].data[index].data.data
		
		Userpanel.selectTabpage(6, "settings")
		
		Userpanel.settingsSave()
		
	elseif type == "help" then	
	
		Userpanel.lists["help_details"].data = {}
	
		Userpanel.lists["help_title"].data = {}
	
		Userpanel.selectTabpage(7, "help_details")
	
		Userpanel.createTile(Userpanel.lists["help_title"], tile.name, {})
	
		if tile.name == "Player commands" then

			Userpanel.createTile(Userpanel.lists["help_details"], "/challenge", {detail = "See what and where will be next challenge held"})
			Userpanel.createTile(Userpanel.lists["help_details"], "/cp /tp", {detail = "Use /cp to create a checkpoint, /tp to teleport to it"})
			Userpanel.createTile(Userpanel.lists["help_details"], "/ghost", {detail = "Displays ghost when you finished map last time"})
			Userpanel.createTile(Userpanel.lists["help_details"], "/skip", {detail = "Skip the map At least 51% of alive players must skip to pass"})
			Userpanel.createTile(Userpanel.lists["help_details"], "/speclist", {detail = "Displays spectators that view you when you're alive on right side"})
			Userpanel.createTile(Userpanel.lists["help_details"], "/st", {detail = "Displays stats in chat"})
			Userpanel.createTile(Userpanel.lists["help_details"], "/top [type]", {detail = "Displays top 10 in various types, DMs, wins, ratio, cash..."})
			Userpanel.createTile(Userpanel.lists["help_details"], "/map", {detail = "Shows map information, creators, number played, price of it"})

		elseif tile.name == "Server rules" then

			Userpanel.createTile(Userpanel.lists["help_details"], "1. The use of the !boom command", {detail = ""})
			Userpanel.createTile(Userpanel.lists["help_details"], "2. The use of the kicking to lobby command (name of command: /lobby)", {detail = ""})
			Userpanel.createTile(Userpanel.lists["help_details"], "3. The use of the Ban command", {detail = ""})
			Userpanel.createTile(Userpanel.lists["help_details"], "4. The use of the Mute command", {detail = ""})
			Userpanel.createTile(Userpanel.lists["help_details"], "5. Admin's reaction towards insults", {detail = ""})
			Userpanel.createTile(Userpanel.lists["help_details"], "6. Attitude towards other people", {detail = ""})
			Userpanel.createTile(Userpanel.lists["help_details"], "7. Other", {detail = ""})

		elseif tile.name == "How to play" then

			Userpanel.createTile(Userpanel.lists["help_details"], "Battle Royale", {detail = "Hints about how to play Battle Royale"})
			Userpanel.createTile(Userpanel.lists["help_details"], "Race gamemode", {detail = "Hints about how to play Race"})
			Userpanel.createTile(Userpanel.lists["help_details"], "Freeroam gamemode", {detail = "Hints about how to play Freeroam"})
			Userpanel.createTile(Userpanel.lists["help_details"], "Custom Arenas", {detail = "What are Custom Arenas"})
			Userpanel.createTile(Userpanel.lists["help_details"], "Training", {detail = "How to train maps"})
			Userpanel.createTile(Userpanel.lists["help_details"], "Competitive", {detail = "How does Competitive work?"})
			Userpanel.createTile(Userpanel.lists["help_details"], "Clan Arenas", {detail = "How to get a Clan Arena"})

		elseif tile.name == "Report a player" then

			Userpanel.createTile(Userpanel.lists["help_details"], "Report", {detail = "Report a player or admin on www.ddc.community"})

		end
		
	elseif type == "help_details" then
		
		if tile.name == "1. The use of the !boom command" then

			Userpanel.lists["help_details"].data = {}
	
			Userpanel.lists["help_title"].data = {}
			
			Userpanel.selectTabpage(7, "help_details")
	
			Userpanel.createTile(Userpanel.lists["help_title"], tile.name, {})	

			Userpanel.createTile(Userpanel.lists["help_details"], "1.1", {detail = "If you do not have the rights to use the !boom command, let another admin do it (if there's not another admin that is able to use /kick)."})
	
		end
		
	end

end
addEvent("onClientUserpanelTileClick", false)
addEventHandler("onClientUserpanelTileClick", root, Userpanel.tileClick)


function Userpanel.buttonClick(type, button)

	if Userpanel.tabs[1].active and Userpanel.tabs[1].pages["player_stats"].active then

		if type == "back" then
		
			Userpanel.lists["stats_title"].data = {}
			
			Userpanel.createTile(Userpanel.lists["stats_title"], Userpanel.serverName, {})	
		
			Userpanel.selectTabpage(1, "stats")
		
			Userpanel.selectTile(Userpanel.lists["stats"], false)
			
			Userpanel.lists["player_stats"].scroll = 0
			
			Userpanel.lists["player_stats"].active = false
			
		end
		
	elseif Userpanel.tabs[2].active and Userpanel.tabs[2].pages["clan_members"].active then
	
		if type == "back" then
		
			Userpanel.selectTabpage(2, "clans")
		
			Userpanel.selectTile(Userpanel.lists["clans"], false)
			
			Userpanel.lists["clan_members"].scroll = 0
			
			Userpanel.lists["clan_members"].active = false
			
		end
	
	elseif Userpanel.tabs[3].active and Userpanel.tabs[3].pages["maps_details"].active then

		if type == "maps_back" then
		
			Userpanel.selectTabpage(3, "maps")		
		
			Userpanel.selectTile(Userpanel.lists["maps"], false)
			
			Userpanel.lists["maps_details"].scroll = 0
			
			Userpanel.lists["maps_details"].active = false
			
		elseif type == "buymap" then
		
			local tile = Userpanel.lists["maps"].data[Userpanel.lists["maps"].selectedTile]
		
			if not tile then 
			
				tile = Userpanel.lists["toptimes"].data[Userpanel.lists["toptimes"].selectedTile]
				
				if not tile then return end
				
			end

			triggerServerEvent("onUserpanelRequestNextmap", localPlayer, tile.data.map)

		end
	
	elseif Userpanel.tabs[7].active and Userpanel.tabs[7].pages["help_details"].active then
	
		if type == "back" then
		
			Userpanel.selectTabpage(7, "help")		
		
			Userpanel.selectTile(Userpanel.lists["help"], false)
			
			Userpanel.lists["help_details"].scroll = 0
			
			Userpanel.lists["help_details"].active = false
			
		end
		
	elseif Userpanel.tabs[6].active and Userpanel.tabs[6].pages["settings_data"].active then
	
		if type == "back" then
		
			Userpanel.selectTabpage(6, "settings")		
		
			Userpanel.selectTile(Userpanel.lists["settings_data"], false)
			
			Userpanel.lists["settings_data"].scroll = 0
			
			Userpanel.lists["settings_data"].active = false
			
		end

	end

end
addEvent("onClientUserpanelButtonClick", false)
addEventHandler("onClientUserpanelButtonClick", root, Userpanel.buttonClick)


function Userpanel.receiveServerInfo(info)

	Userpanel.serverName = info[1]

end
addEvent("onClientUserpanelReceiveServerInfo", true)
addEventHandler("onClientUserpanelReceiveServerInfo", root, Userpanel.receiveServerInfo)


function Userpanel.receiveMaps(maps)
	
	if not maps then return end
		
	Userpanel.lists["maps"].data = {}
	
	for i, map in pairs(maps) do
	
		local map_favorite = map["map_favorite"] == 1
	
		Userpanel.createTile(Userpanel.lists["maps"], map["map_name"], {map = map["map_name"], detail = "", favorite = map_favorite})
		
	end
	
end
addEvent("onUserpanelReceiveMaps", true)
addEventHandler("onUserpanelReceiveMaps", root, Userpanel.receiveMaps)


function Userpanel.receiveClans(clans)

	if not clans then return end
		
	Userpanel.lists["clans"].data = {}
	
	for i, clan in pairs(clans) do
		
		Userpanel.createTile(Userpanel.lists["clans"], clan["clan_color"]..clan["clan_name"], {id = clan["id"], name = clan["clan_color"]..clan["clan_name"], memberCount = clan["member_count"]})
		
	end

end
addEvent("onUserpanelReceiveClans", true)
addEventHandler("onUserpanelReceiveClans", root, Userpanel.receiveClans)


function Userpanel.receiveToptimes(toptimes)

	if not toptimes then return end
		
	Userpanel.lists["toptimes_title"].data = {}	
		
	Userpanel.lists["toptimes"].data = {}
	
	Userpanel.createTile(Userpanel.lists["toptimes_title"], "Toptimes of "..toptimes[1]["player_name"], {})
	
	for i, toptime in pairs(toptimes) do
		
		Userpanel.createTile(Userpanel.lists["toptimes"], toptime["map_name"], {time = exports["CCS"]:export_msToTime(toptime["time_ms"], true), map = toptime["map_name"]})
		
	end

end
addEvent("onUserpanelReceiveMyTops", true)
addEventHandler("onUserpanelReceiveMyTops", root, Userpanel.receiveToptimes)


function Userpanel.receiveMapToptimes(toptimes)

	if not toptimes or #toptimes == 0 then return end
	
	Userpanel.lists["toptimes_title"].data = {}	
		
	Userpanel.lists["toptimes"].data = {}

	Userpanel.createTile(Userpanel.lists["toptimes_title"], "Toptimes of "..toptimes[1]["map_name"], {})
	
	for i, toptime in pairs(toptimes) do
		
		Userpanel.createTile(Userpanel.lists["toptimes"], toptime["player_name"], {time = exports["CCS"]:export_msToTime(toptime["time_ms"], true), account = toptime["player_account"]})
		
	end

end
addEvent("onUserpanelReceiveMapTops", true)
addEventHandler("onUserpanelReceiveMapTops", root, Userpanel.receiveMapToptimes)


function Userpanel.receiveClanMembers(members)

	if not members then return end
		
	Userpanel.lists["clan_members"].data = {}
		
	for i, member in pairs(members) do
		
		local role

		if member["is_owner"] == 1 then
		
			role = "Owner"
			
		else
		
			role = "Member"
			
		end
		
		if member["player_name"] then
		
			Userpanel.createTile(Userpanel.lists["clan_members"], member["player_name"], {account = member["player_account"], detail = role})
		
		else
		
			Userpanel.createTile(Userpanel.lists["clan_members"], member["player_account"], {account = member["player_account"], detail = role})
		
		end
		
	end

end
addEvent("onUserpanelReceiveClanMembers", true)
addEventHandler("onUserpanelReceiveClanMembers", root, Userpanel.receiveClanMembers)


function Userpanel.receivePlayerStats(stats)

	if not stats then return end

	Userpanel.lists["stats_title"].data = {}

	Userpanel.lists["player_stats"].data = {}

	if #stats == 0 then return end

	Userpanel.createTile(Userpanel.lists["stats_title"], "Stats of "..stats[1]["player_name"], {})

	Userpanel.createTile(Userpanel.lists["player_stats"], "Name", {detail = stats[1]["player_name"]})
	Userpanel.createTile(Userpanel.lists["player_stats"], "Country", {detail = stats[1]["player_country"]})
	Userpanel.createTile(Userpanel.lists["player_stats"], "Toptimes", {detail = stats[1]["player_toptimes"], account = stats[1]["player_account"]})
	Userpanel.createTile(Userpanel.lists["player_stats"], "Cash", {detail = "$"..stats[1]["player_cash"]})
	Userpanel.createTile(Userpanel.lists["player_stats"], "Rolls", {detail = stats[1]["player_rolls"]})
	Userpanel.createTile(Userpanel.lists["player_stats"], "Spins", {detail = stats[1]["player_spins"]})

	Userpanel.createTile(Userpanel.lists["player_stats"], "Oldschool DMs", {detail = stats[1]["player_dms"]})
	Userpanel.createTile(Userpanel.lists["player_stats"], "Oldschool Wins", {detail = stats[1]["player_wins"]})
	Userpanel.createTile(Userpanel.lists["player_stats"], "Oldschool Gametime", {detail = exports["CCS"]:export_msToHourTime(stats[1]["player_gametime"], false)})

end
addEvent("onUserpanelReceivePlayerStats", true)
addEventHandler("onUserpanelReceivePlayerStats", root, Userpanel.receivePlayerStats)


function Userpanel.receiveMapsDetails(mapDetails)

	if not mapDetails then return end

	Userpanel.lists["maps_details"].data = {}

	Userpanel.lists["maps_title"].data = {}

	if #mapDetails == 0 then return end

	local map_favorite = mapDetails[1]["map_favorite"] == 1
	
	Userpanel.createTile(Userpanel.lists["maps_title"], mapDetails[1]["map_name"], {})
	Userpanel.createTile(Userpanel.lists["maps_details"], "Name", {detail = mapDetails[1]["map_name"]})
	Userpanel.createTile(Userpanel.lists["maps_details"], "Type", {detail = mapDetails[1]["map_type"]})	
	Userpanel.createTile(Userpanel.lists["maps_details"], "Played", {detail = mapDetails[1]["map_played"]})
	Userpanel.createTile(Userpanel.lists["maps_details"], "Last played", {detail = mapDetails[1]["map_lastPlayed"]})
	Userpanel.createTile(Userpanel.lists["maps_details"], "Toptimes", {detail = mapDetails[1]["map_toptimes"], map = mapDetails[1]["map_resource"]})
	Userpanel.createTile(Userpanel.lists["maps_details"], "Favorite", {detail = map_favorite, map = mapDetails[1]["map_resource"]})

end
addEvent("onUserpanelReceiveMapDetails", true)
addEventHandler("onUserpanelReceiveMapDetails", root, Userpanel.receiveMapsDetails)


function Userpanel.requestPlayers()

	Userpanel.lists["stats"].data = {}

	for i, player in pairs(getElementsByType("player")) do
			
		local arena = getElementData(player, "Arena")
		
		if arena ~= "Training" then
		
			local arenaElement = getElementParent(player)
		
			arena = getElementData(arenaElement, "alias")
			
		end
		
		Userpanel.createTile(Userpanel.lists["stats"], getPlayerName(player), {account = getElementData(player, "account"), detail = "Playing on "..arena})
		
	end

end


function Userpanel.receiveLanguages(languages)

	Userpanel.lists["settings_data"].data = {}

	for i, language in pairs(languages) do

		Userpanel.createTile(Userpanel.lists["settings_data"], language, {display = language, data = language})
		
	end

end
addEvent("onUserpanelReceiveLanguages", true)
addEventHandler("onUserpanelReceiveLanguages", root, Userpanel.receiveLanguages)


function Userpanel.receiveSettings(settings)

	if not settings then return end
	
	Userpanel.lists["settings"].data = {}
	
	local maps_music = settings["maps_music"] == 1
	local ghost = settings["ghost_driver"] == 1
	local no_music = settings["no_music"] == 1
	local maps_textures = settings["maps_textures"] == 1
	local no_personalmessages = settings["no_personalmessages"] == 1
	
	local winsound
	
	if settings["winsound"] then
	
		winsound = "Sound "..settings["winsound"]
		
	else
	
		winsound = "None"
		
	end

	Userpanel.createTile(Userpanel.lists["settings"], "Language", {code = "player_language", type = "data", display = settings["player_language"], data = settings["player_language"], detail = "Choose your language"})
	Userpanel.createTile(Userpanel.lists["settings"], "Win sound", {code = "winsound", type = "data", display = winsound, data = settings["winsound"], detail = "A sound that plays when you win a round"})
	Userpanel.createTile(Userpanel.lists["settings"], "Disable Private Messages", {code = "no_personalmessages", type = "switch", active = no_personalmessages, detail = "Should other players not be able to send you privates messages?"})
	Userpanel.createTile(Userpanel.lists["settings"], "Ghost driver", {code = "ghost_driver", type = "switch", active = ghost, detail = "Show a ghost of the last time you played this map"})
	Userpanel.createTile(Userpanel.lists["settings"], "Chat Color", {code = "chat_color", type = "color", color = settings["chat_color"], detail = "The color of your chat messages"})
	Userpanel.createTile(Userpanel.lists["settings"], "Car Color", {code = "car_color", type = "color", color = settings["car_color"], detail = "The primary color of your vehicles"})
	Userpanel.createTile(Userpanel.lists["settings"], "Car Color 2", {code = "car_color2", type = "color", color = settings["car_color2"], detail = "The secondary color of your vehicles"})
	Userpanel.createTile(Userpanel.lists["settings"], "Nitro Color", {code = "nitro_color", type = "color", color = settings["nitro_color"], detail = "The nitro color of your vehicles"})
	Userpanel.createTile(Userpanel.lists["settings"], "Mute map music", {code = "no_music", type = "switch", active = no_music, detail = "Should map music be downloaded? Turn this off if you have slow Internet"})	
	Userpanel.createTile(Userpanel.lists["settings"], "Download map music", {code = "maps_music", type = "switch", active = maps_music, detail = "Should map music be downloaded? Turn this off if you have slow Internet"})
	Userpanel.createTile(Userpanel.lists["settings"], "Download map textures", {code = "maps_textures", type = "switch", active = maps_textures, detail = "Should map textures be downloaded? Turn this off if you have slow Internet"})
		
end
addEvent("onUserpanelReceiveSettings", true)
addEventHandler("onUserpanelReceiveSettings", root, Userpanel.receiveSettings)


function Userpanel.settingsSave()
	
	local settings = {}
	
	for i, tile in pairs(Userpanel.lists["settings"].data) do
		
		local setting = tile.data
		
		if setting.type == "switch" then
		
			if setting.active then
			
				settings[setting.code] = 1
			
			else
			
				settings[setting.code] = 0
				
			end
		
		elseif setting.type == "color" then
		
			settings[setting.code] = setting.color
		
		elseif setting.type == "data" then
			
			settings[setting.code] = setting.data
			
		end
	
	end
	
	triggerServerEvent("onUserpanelSaveSettings", localPlayer, settings)
	
end


function Userpanel.mouseCheck(posX, posY, width, height)
	
	local mouseX, mouseY = getCursorPosition()
	
	if not mouseX then return false end
	
	mouseX = mouseX * Userpanel.x
	mouseY = mouseY * Userpanel.y

	if mouseX < posX or mouseX > posX + width then return false end

	if mouseY < posY or mouseY > posY + height then return false end

	return true

end


function Userpanel.hex2rgb(hex)

    hex = hex:gsub("#","")
	
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))

end


function Userpanel.textOverflow(text, suffix, size, font, width)

	while dxGetTextWidth(text..suffix, size, font, true) > width do
	
		text = text:sub(1, text:len()-4).."..."

	end

	return text
	
end