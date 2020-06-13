local Login = {}
Login.x, Login.y = guiGetScreenSize()
Login.relX, Login.relY = (Login.x/800), (Login.y/600)
Login.key = "ClassicCrossShooter"
Login.isLobbyActive = false
Login.cache = {}
Login.updateTimer = nil
Login.loadingScreen = nil
Login.joinFloodInterval = 5000
Login.joinLock = false
Login.joinFloodLock = 0
Login.passwordInputActive = false
Login.timeoutTimer = nil
Login.disableRenderTimer = nil
Login.weekdays = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}
Login.loggedIn = false
Login.delta = 0
Login.lastTick = nil

--Background
Login.backgroundPicture = dxCreateTexture("img/lobby/background.jpg")
Login.shader = dxCreateShader( "img/blur.fx" )

--Login
Login.login = {}
Login.login.loginData = {}	
	
Login.lobby = {}
Login.lobby.renderTargetWidth = Login.x
Login.lobby.renderTargetHeight = Login.y * 0.75
Login.lobby.renderTarget = dxCreateRenderTarget(Login.lobby.renderTargetWidth, Login.lobby.renderTargetHeight, true)
dxSetTextureEdge(Login.lobby.renderTarget, "border")
Login.lobby.postGui = false
Login.lobby.scroll = 0
Login.lobby.scrollPosition = 0
Login.lobby.scrollValue = 50 * Login.relY
Login.lobby.rows = {{tag = "Battle Royale", name = "Battle Royale", index = 1},{tag = "Race", name = "Race", index = 1}, {tag = "Fun", name = "Fun", index = 1}, {tag = "Custom", name = "Custom Arenas", index = 1, creatable = true}, {tag = "Clan", name = "Clan Arenas", index = 1, creatable = true}, {tag = "Competitive", name = "Competitive", index = 1}, {tag = "Misc", name = "Misc", index = 1}}
Login.lobby.entries = {}
Login.lobby.roomSizeOptions = {{205, 117}, {230, 140}, {273, 156}}
Login.lobby.roomSize = 1
Login.lobby.roomWidth = Login.lobby.roomSizeOptions[Login.lobby.roomSize][1] * Login.relY
Login.lobby.roomHeight = Login.lobby.roomSizeOptions[Login.lobby.roomSize][2] * Login.relY
Login.lobby.screenSource = dxCreateScreenSource ( Login.x, Login.y )
Login.lobby.roomDetailFont = "default-bold"
Login.lobby.roomDetailTextOffset = 5 * Login.relY
Login.lobby.roomDetailNameFontSize = 1
Login.lobby.roomDetailNameHeight = dxGetFontHeight(Login.lobby.roomDetailNameFontSize, Login.lobby.roomDetailFont)
Login.lobby.roomDetailHeight = Login.lobby.roomDetailTextOffset * 3
Login.lobby.roomDetailMapFontSize = 0.9
Login.lobby.roomDetailMapFontColor = tocolor(255, 255, 255, 150)
Login.lobby.roomOffset = 10 * Login.relY
Login.lobby.rowHeaderFontSize = 2
Login.lobby.rowHeaderFont = "default-bold"
Login.lobby.rowHeaderColor = tocolor(255, 255, 255, 255)
Login.lobby.rowHeaderHeight = dxGetFontHeight(Login.lobby.rowHeaderFontSize, Login.lobby.rowHeaderFont) * 1.5
Login.lobby.rowHeight = Login.lobby.rowHeaderHeight + Login.lobby.roomHeight + Login.lobby.roomOffset
Login.lobby.rowOffset = 20 * Login.relY
Login.lobby.arrowWidth = 20 * Login.relY
Login.lobby.arrowHeight = 27 * Login.relY
Login.lobby.arenasPerRow = math.floor(Login.x / (Login.lobby.roomWidth + Login.lobby.roomOffset + 2 * Login.lobby.arrowWidth))
Login.lobby.rowStartX = Login.x/2 - (Login.lobby.roomWidth * Login.lobby.arenasPerRow + Login.lobby.roomOffset * ( Login.lobby.arenasPerRow - 1 )) / 2
Login.lobby.arrowRightPosX = Login.lobby.rowStartX + (Login.lobby.roomWidth * Login.lobby.arenasPerRow + Login.lobby.roomOffset * ( Login.lobby.arenasPerRow - 1 ))
Login.lobby.rowStartY = 75 * Login.relY
Login.lobby.arrowLeftPosX = Login.lobby.rowStartX - Login.lobby.arrowWidth
Login.lobby.circleSize = 16
Login.lobby.circleOffset = 3
Login.lobby.mode = "SHOW_ALL_ARENAS"
Login.lobby.blurryBackground = false
Login.lobby.ingameBackground = false

--Animation
Login.lobby.animating = false
Login.lobby.animationDirection = nil
Login.lobby.animatedPosX = Login.x
Login.lobby.animateTime = 1500
Login.lobby.animateStart = nil
Login.lobby.animateStartX = nil
Login.lobby.animateMethod = 11
Login.lobby.animations = { "Linear", 
						   "InQuad", 
						   "OutQuad", 
						   "InOutQuad", 
						   "OutInQuad", 
						   "InElastic", 
						   "OutElastic", 
						   "InOutElastic", 
						   "OutInElastic", 
						   "InBack", 
						   "OutBack", 
						   "InOutBack", 
						   "OutInBack", 
						   "InBounce", 
						   "OutBounce", 
						   "InOutBounce", 
						   "OutInBounce" }

--Date/Time
Login.lobby.timeFont = "default-bold"
Login.lobby.timeFontSize = 2.5
Login.lobby.timeFontColor = tocolor(255, 255, 255, 255)
Login.lobby.timeOffset = 15 * Login.relY
Login.lobby.timePosX = Login.lobby.timeOffset
Login.lobby.timePosY = Login.lobby.timeOffset
Login.lobby.dateFont = "default-bold"
Login.lobby.dateFontSize = 1.2
Login.lobby.dateFontColor = tocolor(255, 255, 255, 255)
Login.lobby.dateOffset = 15 * Login.relY
Login.lobby.datePosX = Login.lobby.dateOffset
Login.lobby.datePosY = Login.lobby.dateOffset + dxGetFontHeight(Login.lobby.timeFontSize, Login.lobby.timeFont)

--Leave Arena
Login.lobby.leaveButtonFont = "default-bold"
Login.lobby.leaveButtonFontSize = 1
Login.lobby.leaveButtonFontColor = tocolor(255, 255, 255, 255)
Login.lobby.leaveButtonText = "Leave Arena"
Login.lobby.leaveButtonWidth = dxGetTextWidth(Login.lobby.leaveButtonText, Login.lobby.leaveButtonFontSize, Login.lobby.leaveButtonFont) * 1.75
Login.lobby.leaveButtonHeight = dxGetFontHeight(Login.lobby.leaveButtonFontSize, Login.lobby.leaveButtonFont) * 1.75
Login.lobby.leaveButtonOffset = 10 * Login.relY
Login.lobby.leaveButtonPosX = Login.x - Login.lobby.leaveButtonOffset - Login.lobby.leaveButtonWidth
Login.lobby.leaveButtonPosY = Login.y - Login.lobby.leaveButtonOffset - Login.lobby.leaveButtonHeight
Login.lobby.leaveButtonActive = false

--Logout
Login.lobby.logoutButtonFont = "default-bold"
Login.lobby.logoutButtonFontSize = 1
Login.lobby.logoutButtonFontColor = tocolor(255, 255, 255, 255)
Login.lobby.logoutButtonText = "Logout"
Login.lobby.logoutButtonWidth = dxGetTextWidth(Login.lobby.leaveButtonText, Login.lobby.logoutButtonFontSize, Login.lobby.logoutButtonFont) * 1.75
Login.lobby.logoutButtonHeight = dxGetFontHeight(Login.lobby.logoutButtonFontSize, Login.lobby.logoutButtonFont) * 1.75
Login.lobby.logoutButtonOffset = 10 * Login.relY
Login.lobby.logoutButtonPosX = Login.x - Login.lobby.logoutButtonOffset - Login.lobby.logoutButtonWidth
Login.lobby.logoutButtonPosY = Login.y - Login.lobby.logoutButtonOffset - Login.lobby.logoutButtonHeight
Login.lobby.logoutButtonActive = false

--Player Count
Login.lobby.playercountButtonFont = "default-bold"
Login.lobby.playercountButtonFontSize = 1
Login.lobby.playercountButtonFontColor = tocolor(255, 255, 255, 255)
Login.lobby.playercountButtonText = "XX players online"
Login.lobby.playercountButtonWidth = dxGetTextWidth(Login.lobby.playercountButtonText, Login.lobby.playercountButtonFontSize, Login.lobby.playercountButtonFont) * 1.75
Login.lobby.playercountButtonHeight = dxGetFontHeight(Login.lobby.playercountButtonFontSize, Login.lobby.playercountButtonFont) * 1.75
Login.lobby.playercountButtonOffset = 10 * Login.relY 
Login.lobby.playercountButtonPosX = Login.lobby.playercountButtonOffset
Login.lobby.playercountButtonPosY = Login.y - Login.lobby.playercountButtonOffset - Login.lobby.playercountButtonHeight

--scroll info
Login.lobby.scrollInfoFont = "default-bold"
Login.lobby.scrollInfoFontSize = 1
Login.lobby.scrollInfoFontColor = tocolor(255, 255, 255, 255)
Login.lobby.scrollInfoText = "Use mousewheel or page down button to scroll"
Login.lobby.scrollInfoWidth = dxGetTextWidth(Login.lobby.scrollInfoText, Login.lobby.scrollInfoFontSize, Login.lobby.scrollInfoFont)
Login.lobby.scrollInfoHeight = dxGetFontHeight(Login.lobby.scrollInfoFontSize, Login.lobby.scrollInfoFont)
Login.lobby.scrollInfoOffset = 10 * Login.relY 
Login.lobby.scrollInfoPosX = Login.x / 2 - Login.lobby.scrollInfoWidth / 2
Login.lobby.scrollInfoPosY = Login.y - Login.lobby.scrollInfoOffset - Login.lobby.scrollInfoHeight

--spectate button
Login.lobby.spectateButtonFont = "default-bold"
Login.lobby.spectateButtonFontSize = 1
Login.lobby.spectateButtonFontColor = tocolor(255, 255, 255, 255)
Login.lobby.spectateButtonText = "Spectate"
Login.lobby.spectateButtonWidth = dxGetTextWidth(Login.lobby.spectateButtonText, Login.lobby.spectateButtonFontSize, Login.lobby.spectateButtonFont) * 1.75
Login.lobby.spectateButtonHeight = dxGetFontHeight(Login.lobby.spectateButtonFontSize, Login.lobby.spectateButtonFont) * 1.75
Login.lobby.spectateButtonOffset = 5 * Login.relY
Login.lobby.spectateButtonActive = false

--register button
Login.lobby.registerButtonFont = "default-bold"
Login.lobby.registerButtonFontSize = 1
Login.lobby.registerButtonFontColor = tocolor(255, 255, 255, 255)
Login.lobby.registerButtonText = "Register"
Login.lobby.registerButtonWidth = dxGetTextWidth(Login.lobby.registerButtonText, Login.lobby.registerButtonFontSize, Login.lobby.registerButtonFont) * 1.75
Login.lobby.registerButtonHeight = dxGetFontHeight(Login.lobby.registerButtonFontSize, Login.lobby.registerButtonFont) * 1.75
Login.lobby.registerButtonOffset = 5 * Login.relY
Login.lobby.registerButtonActive = false

--competitive information
Login.lobby.competitiveInfoFont = "default-bold"
Login.lobby.competitiveInfoFontSize = 1
Login.lobby.competitiveInfoFontColor = tocolor(255, 255, 255, 255)
Login.lobby.competitiveInfoText = "Competitive Match found:"
Login.lobby.competitiveInfoHeight = dxGetFontHeight(Login.lobby.competitiveInfoFontSize, Login.lobby.competitiveInfoFont)
Login.lobby.competitiveInfoOffset = 5 * Login.relY
Login.lobby.competitiveInfoPosX = 0
Login.lobby.competitiveInfoPosY = Login.lobby.competitiveInfoOffset

--competitive players information
Login.lobby.competitivePlayersInfoFont = "default-bold"
Login.lobby.competitivePlayersInfoFontSize = 1
Login.lobby.competitivePlayersInfoFontColor = tocolor(255, 255, 255, 255)
Login.lobby.competitivePlayersInfoText = "Players ready: 0 of 2"
Login.lobby.competitivePlayersInfoHeight = dxGetFontHeight(Login.lobby.competitivePlayersInfoFontSize, Login.lobby.competitivePlayersInfoFont)
Login.lobby.competitivePlayersInfoOffset = 5 * Login.relY
Login.lobby.competitivePlayersInfoPosX = 0
Login.lobby.competitivePlayersInfoPosY = Login.lobby.competitiveInfoPosY + Login.lobby.competitiveInfoHeight + Login.lobby.competitivePlayersInfoOffset

--accept button
Login.lobby.acceptButtonFont = "default-bold"
Login.lobby.acceptButtonFontSize = 2
Login.lobby.acceptButtonFontColor = tocolor(255, 255, 255, 255)
Login.lobby.acceptButtonText = "ACCEPT"
Login.lobby.acceptButtonWidth = dxGetTextWidth(Login.lobby.acceptButtonText.."(XX)", Login.lobby.acceptButtonFontSize, Login.lobby.acceptButtonFont) * 1.5
Login.lobby.acceptButtonHeight = dxGetFontHeight(Login.lobby.acceptButtonFontSize, Login.lobby.acceptButtonFont) * 1.5
Login.lobby.acceptButtonOffset = 5 * Login.relY
Login.lobby.acceptButtonPosX = Login.x / 2 - Login.lobby.acceptButtonWidth - Login.lobby.acceptButtonOffset
Login.lobby.acceptButtonPosY = Login.lobby.competitivePlayersInfoPosY + Login.lobby.competitivePlayersInfoHeight + Login.lobby.competitivePlayersInfoOffset
Login.lobby.acceptButtonActive = false

--decline button
Login.lobby.declineButtonFont = "default-bold"
Login.lobby.declineButtonFontSize = 2
Login.lobby.declineButtonFontColor = tocolor(255, 255, 255, 255)
Login.lobby.declineButtonText = "DECLINE"
Login.lobby.declineButtonWidth = dxGetTextWidth(Login.lobby.declineButtonText.."(XX)", Login.lobby.declineButtonFontSize, Login.lobby.declineButtonFont) * 1.5
Login.lobby.declineButtonHeight = dxGetFontHeight(Login.lobby.declineButtonFontSize, Login.lobby.declineButtonFont) * 1.5
Login.lobby.declineButtonOffset = 5 * Login.relY
Login.lobby.declineButtonPosX = Login.x / 2 + Login.lobby.declineButtonOffset
Login.lobby.declineButtonPosY = Login.lobby.competitivePlayersInfoPosY + Login.lobby.competitivePlayersInfoHeight + Login.lobby.competitivePlayersInfoOffset
Login.lobby.declineButtonActive = false

--arena player count
Login.lobby.arenaPlayerCountFont = "default-bold"
Login.lobby.arenaPlayerCountFontSize = 1
Login.lobby.arenaPlayerCountFontColor = tocolor(255, 255, 255, 255)
Login.lobby.arenaPlayerCountText = "XX / XX"
Login.lobby.arenaPlayerCountWidth = dxGetTextWidth(Login.lobby.arenaPlayerCountText, Login.lobby.arenaPlayerCountFontSize, Login.lobby.arenaPlayerCountFont) * 1.75
Login.lobby.arenaPlayerCountHeight = dxGetFontHeight(Login.lobby.arenaPlayerCountFontSize, Login.lobby.arenaPlayerCountFont) * 1.75
Login.lobby.arenaPlayerCountOffset = 5 * Login.relY
Login.lobby.arenaPlayerCountActive = false

--settings
Login.lobby.settingsButtonFont = "default-bold"
Login.lobby.settingsButtonFontSize = 1
Login.lobby.settingsButtonFontColor = tocolor(255, 255, 255, 255)
Login.lobby.settingsButtonText = "Settings"
Login.lobby.settingsButtonWidth = dxGetTextWidth(Login.lobby.settingsButtonText, Login.lobby.settingsButtonFontSize, Login.lobby.settingsButtonFont) * 1.75
Login.lobby.settingsButtonHeight = dxGetFontHeight(Login.lobby.settingsButtonFontSize, Login.lobby.settingsButtonFont) * 1.75
Login.lobby.settingsButtonOffset = 10 * Login.relY
Login.lobby.settingsButtonPosX = Login.lobby.leaveButtonPosX - Login.lobby.settingsButtonOffset - Login.lobby.settingsButtonWidth
Login.lobby.settingsButtonPosY = Login.y - Login.lobby.settingsButtonOffset - Login.lobby.settingsButtonHeight
Login.lobby.settingsButtonActive = false

--Training
Login.lobby.trainingButtonFont = "default-bold"
Login.lobby.trainingButtonFontSize = 1
Login.lobby.trainingButtonFontColor = tocolor(255, 255, 255, 255)
Login.lobby.trainingButtonText = "Training"
Login.lobby.trainingButtonWidth = dxGetTextWidth(Login.lobby.trainingButtonText, Login.lobby.trainingButtonFontSize, Login.lobby.trainingButtonFont) * 1.75
Login.lobby.trainingButtonHeight = dxGetFontHeight(Login.lobby.trainingButtonFontSize, Login.lobby.trainingButtonFont) * 1.75
Login.lobby.trainingButtonOffset = 10 * Login.relY 
Login.lobby.trainingButtonPosX = Login.lobby.settingsButtonPosX - Login.lobby.trainingButtonOffset - Login.lobby.trainingButtonWidth
Login.lobby.trainingButtonPosY = Login.y - Login.lobby.trainingButtonOffset - Login.lobby.trainingButtonHeight
Login.lobby.trainingButtonActive = false

--Scrollbar
Login.lobby.scrollbarPosX = Login.lobby.renderTargetWidth - Login.lobby.rowStartX / 2
Login.lobby.scrollbarWidth = 4 * Login.relY
Login.lobby.scrollbarHeight = 4 * Login.relY

Login.lobby.playerInLobby = true

Login.lobby.createArenaWindow = nil
Login.lobby.passwordWindow = nil
Login.lobby.loginWindow = nil
Login.lobby.registerWindow = nil
Login.lobby.settingsWindow = nil
Login.lobby.clanArenaWindow = nil

Login.lobby.challenge = {}
Login.lobby.challenge.arenaElement = nil
Login.lobby.challenge.challengeTime = nil

Login.lobby.competitive = {}
Login.lobby.competitive.type = nil
Login.lobby.competitive.responseTime = nil
Login.lobby.competitive.skillPoints = nil
Login.lobby.competitive.matches = nil

function Login.start()

	Login.lobby.loginWindow = LoginWindow.new()
	Login.lobby.loginWindow.setVisible(true)
	Login.loadSettings()
	
	triggerServerEvent("onChallengeRequestInfo", localPlayer)
	
end
addEventHandler("onClientResourceStart", resourceRoot, Login.start)


function Login.create()

	--Before changing Cursor
	triggerEvent("onClientLobbyEnable", localPlayer)

	addEventHandler("onLoginButtonClick", root, Login.login.loginButtonHandler)
	addEventHandler("onRegisterButtonClick", root, Login.login.registerButtonHandler)
	addEventHandler("onContinueButtonClick", root, Login.login.continueButtonHandler)
	addEventHandler("onCancelButtonClick", root, Login.login.cancelButtonHandler)
	addEventHandler("onGuestButtonClick", root, Login.login.guestButtonHandler)
	addEventHandler("onClientKey", root, Login.clickHandler)
	addEventHandler("onCreateArenaButton", root, Login.createArena)
	addEventHandler("onPlayerLogoutButton", root, Login.logout)
	addEventHandler("onLoginResponse", root, Login.loginResponse)
	addEventHandler("onRegisterResponse", root, Login.registerResponse)
	addEventHandler("onGuestResponse", root, Login.guestResponse)
	addEventHandler("onClientRender", root, Login.render, true, "low-99")
	addEventHandler("onArenaSelect", root, Login.arenaJoin)
	addEventHandler("onLobbySettingsChange", root, Login.lobbySettings)
	addEventHandler("onLobbyWindowClose", root, Login.lobbyWindowClose)
	Login.isLobbyActive = true
	showChat(false)
	showCursor(true)
	Login.lobby.passwordWindow = PasswordWindow.new(Login.lobby.animatedPosX)
	Login.lobby.createArenaWindow = ArenaCreateWindow.new(Login.lobby.animatedPosX)
	Login.lobby.settingsWindow = SettingsWindow.new(Login.lobby.animatedPosX)
	Login.lobby.clanArenaWindow = ClanArenaWindow.new(Login.lobby.animatedPosX)

	triggerServerEvent("onCompetitiveRequestInfo", localPlayer)
	
end
addEvent("onShowLogin")
addEventHandler("onShowLogin", root, Login.create)


function Login.destroy()

	showChat(true)
	Login.isLobbyActive = false
	showCursor(false)
	Login.lobby.animating = false
	Login.lobby.animatedPosX = 0
	Login.refreshAnimation()
	removeEventHandler("onLoginButtonClick", root, Login.login.loginButtonHandler)
	removeEventHandler("onRegisterButtonClick", root, Login.login.registerButtonHandler)
	removeEventHandler("onContinueButtonClick", root, Login.login.continueButtonHandler)
	removeEventHandler("onCancelButtonClick", root, Login.login.cancelButtonHandler)
	removeEventHandler("onGuestButtonClick", root, Login.login.guestButtonHandler)
	removeEventHandler("onClientKey", root, Login.clickHandler)
	removeEventHandler("onCreateArenaButton", root, Login.createArena)
	removeEventHandler("onPlayerLogoutButton", root, Login.logout)
	removeEventHandler("onArenaSelect", root, Login.arenaJoin)
	removeEventHandler("onLoginResponse", root, Login.loginResponse)
	removeEventHandler("onRegisterResponse", root, Login.registerResponse)
	removeEventHandler("onGuestResponse", root, Login.guestResponse)
	removeEventHandler("onClientRender", root, Login.render)
	removeEventHandler("onLobbySettingsChange", root, Login.lobbySettings)
	removeEventHandler("onLobbyWindowClose", root, Login.lobbyWindowClose)
	
	if Login.lobby.createArenaWindow then 
	
		Login.lobby.createArenaWindow:destroy()
		Login.lobby.createArenaWindow = nil
		
	end
	
	if Login.lobby.passwordWindow then 
	
		Login.lobby.passwordWindow:destroy()
		Login.lobby.passwordWindow = nil
		
	end
	
	if Login.lobby.settingsWindow then 
	
		Login.lobby.settingsWindow:destroy()
		Login.lobby.settingsWindow = nil
		
	end	
	
	if Login.lobby.clanArenaWindow then
	
		Login.lobby.clanArenaWindow:destroy()
		Login.lobby.clanArenaWindow = nil
		
	end
	
	--After changing Cursor
	triggerEvent("onClientLobbyDisable", localPlayer)	
	
end


function Login.render()

	if Login.lobby.ingameBackground and not Login.lobby.playerInLobby then
	
		dxUpdateScreenSource( Login.lobby.screenSource )
		dxSetShaderValue( Login.shader, "ScreenSource", Login.lobby.screenSource )

	else
		
		dxSetShaderValue( Login.shader, "ScreenSource", Login.backgroundPicture )

	end

	dxSetShaderValue( Login.shader, "UVSize", Login.x, Login.y )	
		
	if Login.lobby.blurryBackground then
	
		dxSetShaderValue( Login.shader, "BlurStrength", 25 )
		
	else

		dxSetShaderValue( Login.shader, "BlurStrength", 0 )	
		
	end
	
	dxDrawImage(0, 0, Login.x, Login.y, Login.shader, 0, 0, 0, tocolor( 255, 255, 255, 255), Login.lobby.postGui)
		
	if Login.lobby.animating then
	
		Login.animate()
		
	end
	
	if Login.loggedIn then
	
		Login.renderLobby()
	
	end
	
end


function Login.clickHandler(button, pressOrRelease)

	if not pressOrRelease then return end
	
	if not Login.loggedIn then return end
	
	if Login.lobby.animating then return end
	
	if isConsoleActive() then return end
	
	if button ~= "escape" and Login.lobby.createArenaWindow and Login.lobby.createArenaWindow.isVisible() then return end
	
	if button ~= "escape" and Login.lobby.passwordWindow and Login.lobby.passwordWindow.isVisible() then return end	
	
	if button ~= "escape" and Login.lobby.settingsWindow and Login.lobby.settingsWindow.isVisible() then return end
	
	if button ~= "escape" and Login.lobby.clanArenaWindow and Login.lobby.clanArenaWindow.isVisible() then return end	
	
	if button == "escape" then
	
		if Login.lobby.createArenaWindow and Login.lobby.createArenaWindow.isVisible() then
			
			Login.lobby.passwordWindow.setVisible ( false )
			cancelEvent()
			
		elseif Login.lobby.passwordWindow and Login.lobby.passwordWindow.isVisible() then
		
			Login.lobby.createArenaWindow.setVisible ( false )
			cancelEvent()
			
		elseif Login.lobby.settingsWindow and Login.lobby.settingsWindow.isVisible() then
		
			Login.lobby.settingsWindow.setVisible ( false )
			cancelEvent()
		
		elseif Login.lobby.clanArenaWindow and Login.lobby.clanArenaWindow.isVisible() then
		
			Login.lobby.clanArenaWindow.setVisible ( false )
			cancelEvent()
				
		end
	
	elseif button == "mouse_wheel_up" or button == "pgup" then
	
		Login.processScroll(true)
		
	elseif button == "mouse_wheel_down" or button == "pgdn" then
	
		Login.processScroll(false)
		
	elseif button == "mouse1" then
		
		for i, row in pairs(Login.lobby.rows) do
			
			if row.active then
				
				--header
				if row.rowHeaderActive then
				
					row.hidden = not row.hidden
					
					if Login.lobby.scroll > Login.getMaxScrollValue() - Login.lobby.renderTargetHeight then
		
						Login.lobby.scroll = Login.getMaxScrollValue() - Login.lobby.renderTargetHeight
						Login.lobby.scrollPosition = 1
					
					
					end
					
					Login.lobby.scroll = math.max(0, Login.lobby.scroll)
				
				end
			
				--left arrow
				if row.arrowRightActive and row.index < #Login.lobby.entries[row.tag] then
				
					row.index = row.index + Login.lobby.arenasPerRow
					
				end
				
				--right arrow
				if row.arrowLeftActive and row.index > 1 then
				
					row.index = row.index - Login.lobby.arenasPerRow
					
				end
				
				--arena
				for j, entry in pairs(Login.lobby.entries[row.tag]) do
				
					if entry.active then
					
						if entry.type == "arena" then
							
							if Login.lobby.registerButtonActive then
							
								if not getElementData(localPlayer, "account") then
								
									exports["CCS_notifications"]:export_showNotification("You are not logged in!", "warning")
									return
									
								end
							
								local type = getElementData(entry.arenaElement, "type")
								
								if getElementData(localPlayer, "competitive")[type] then
							
									triggerServerEvent("onCompetitiveDeregister", localPlayer, type)
							
								else
								
									triggerServerEvent("onCompetitiveRegister", localPlayer, type)
								
								end
								
							elseif getElementData(entry.arenaElement, "password") and not Login.lobby.spectateButtonActive and not Login.lobby.arenaPlayerCountActive then
							
								Login.lobby.passwordWindow.setArena(entry.arenaElement)
								Login.lobby.passwordWindow.setVisible ( true )
								Login.startAnimation(2)
							
							else
							
								--competitive arenas cannot be joined
								if getElementData(entry.arenaElement, "category") == "Competitive" and not Login.lobby.spectateButtonActive and not Login.lobby.arenaPlayerCountActive then 
								
									exports["CCS_notifications"]:export_showNotification("Please click register to play or watch as spectator!", "warning")
									return 
								
								end
							
								if not Login.lobby.arenaPlayerCountActive then
							
									local arenaID = getElementID(entry.arenaElement)
									Login.arenaJoin(arenaID, Login.lobby.spectateButtonActive)
									break
								
								end
							
							end
							
						elseif entry.type == "plus" then
							
							if row.tag == "Custom" then
							
								Login.lobby.createArenaWindow.setVisible ( true )
								Login.startAnimation(2)
								break
								
							elseif row.tag == "Clan" then
							
								Login.lobby.clanArenaWindow.setVisible ( true )
								Login.startAnimation(2)
								break
							
							end
	
						end
					
					end
				
				end
				
			end
		
		end

		--leave
		if Login.lobby.leaveButtonActive then
			
			Login.arenaLeave()
			Login.lobby.leaveButtonActive = false
		
		end
		
		--Trianing
		if Login.lobby.trainingButtonActive then
		
			Login.training()
		
		end
		
		--Logout
		if Login.lobby.logoutButtonActive then
		
			Login.logout()
			Login.lobby.logoutButtonActive = false
		
		end 
		
		--accept
		if Login.lobby.acceptButtonActive then
			
			Competitive.acceptMatch()
			Login.lobby.acceptButtonActive = false
		
		end
		
		--decline
		if Login.lobby.declineButtonActive then
			
			Competitive.declineMatch()
			Login.lobby.declineButtonActive = false
		
		end
		
		if Login.lobby.settingsButtonActive then
			
			Login.lobby.settingsWindow.loadSettings(Login.lobby.mode == "SHOW_ALL_ARENAS", Login.lobby.animateMethod, Login.lobby.blurryBackground, Login.lobby.ingameBackground, Login.lobby.roomSize)
			Login.lobby.settingsWindow.setVisible ( true )
			Login.startAnimation(2)
		
		end
		
	end
	
end


function Login.animate()

	local progress = ( getTickCount() - Login.lobby.animateStart ) / Login.lobby.animateTime

	progress = math.min(progress, 1)

	if Login.lobby.animationDirection == 0 then
		
		if progress < 1 then
		
			Login.lobby.animatedPosX = interpolateBetween ( Login.lobby.animateStartX, 0, 0, Login.x, 0, 0, progress, Login.lobby.animations[Login.lobby.animateMethod] )
		
		else
		
			Login.lobby.animating = false
			Login.loggedIn = false
		
		end

	elseif Login.lobby.animationDirection == 1 then
	
		if progress < 1 then
		
			Login.lobby.animatedPosX = interpolateBetween ( Login.lobby.animateStartX, 0, 0, 0, 0, 0, progress, Login.lobby.animations[Login.lobby.animateMethod] )
		
		else
		
			Login.lobby.animating = false
			Login.lobby.loginWindow.setVisible(false)
			Login.lobby.settingsWindow.setVisible(false)
			Login.lobby.passwordWindow.setVisible(false)
			Login.lobby.createArenaWindow.setVisible(false)
			Login.lobby.clanArenaWindow.setVisible(false)
		
		end
	
	elseif Login.lobby.animationDirection == 2 then
	
		if progress < 1 then
		
			Login.lobby.animatedPosX = interpolateBetween ( Login.lobby.animateStartX, 0, 0, -Login.x, 0, 0, progress, Login.lobby.animations[Login.lobby.animateMethod] )
		
		else
		
			Login.lobby.animating = false
		
		end
	
	end
	
	Login.refreshAnimation()
	
end


function Login.startAnimation(direction)

	Login.lobby.animating = true
	Login.lobby.animateStart = getTickCount()
	Login.lobby.animateStartX = Login.lobby.animatedPosX
	Login.lobby.animationDirection = direction

end


function Login.refreshAnimation()

	Login.lobby.loginWindow.setAnimationPosition(Login.lobby.animatedPosX)

	Login.lobby.settingsWindow.setAnimationPosition(Login.lobby.animatedPosX)

	Login.lobby.passwordWindow.setAnimationPosition(Login.lobby.animatedPosX)

	Login.lobby.createArenaWindow.setAnimationPosition(Login.lobby.animatedPosX)

	Login.lobby.clanArenaWindow.setAnimationPosition(Login.lobby.animatedPosX)

end


function Login.renderLobby()
	
	if Login.lastTick then
		Login.delta = getTickCount() - Login.lastTick
		Login.delta = math.min(Login.delta, (1/60)*1000)
	end
	
	Login.lastTick = getTickCount()

	for i, row in pairs(Login.lobby.rows) do
	
		Login.lobby.entries[row.tag] = {}
		
	end

	for i, arenaElement in pairs(getElementsByType("Arena")) do

		if getElementData(arenaElement, "inLobby") then
		
			local category = getElementData(arenaElement, "category")
			
			if Login.lobby.entries[category] then
				
				table.insert(Login.lobby.entries[category], {type = "arena", arenaElement = arenaElement, active = false})
				
			end
			
		end
	
	end

	local time = getRealTime()
	
	local dateString = Login.weekdays[time.weekday + 1]..", "..string.format("%02d.%02d.%04d", time.monthday, time.month + 1, time.year + 1900)
	local timeString = string.format("%02d:%02d:%02d", time.hour, time.minute, time.second)
	
	--Date
	dxDrawText(timeString, Login.lobby.animatedPosX + Login.lobby.timePosX, Login.lobby.timePosY, Login.x, Login.y, Login.lobby.timeFontColor, Login.lobby.timeFontSize, Login.lobby.timeFont, "left", "top", false, false, Login.lobby.postGui)
	dxDrawText(dateString, Login.lobby.animatedPosX + Login.lobby.datePosX, Login.lobby.datePosY, Login.x, Login.y, Login.lobby.dateFontColor, Login.lobby.dateFontSize, Login.lobby.dateFont, "left", "top", false, false, Login.lobby.postGui)

	--competitive skill 
	if Login.lobby.competitive.skillPoints then
	
		dxDrawText("Ø "..Login.lobby.competitive.skillPoints, Login.lobby.animatedPosX + Login.lobby.timePosX, Login.lobby.timePosY, Login.x - Login.lobby.timeOffset, Login.y, Login.lobby.timeFontColor, Login.lobby.timeFontSize, Login.lobby.timeFont, "right", "top", false, false, Login.lobby.postGui)
		dxDrawText("Your Competitive Skill\nTotal matches played: "..Login.lobby.competitive.matches, Login.lobby.animatedPosX + Login.lobby.datePosX, Login.lobby.datePosY, Login.x - Login.lobby.dateOffset, Login.y, Login.lobby.dateFontColor, Login.lobby.dateFontSize, Login.lobby.dateFont, "right", "top", false, false, Login.lobby.postGui)
		
	end
	
	dxSetRenderTarget(Login.lobby.renderTarget, true) 
	dxSetBlendMode("modulate_add")
		
	local posY = -Login.lobby.scroll
	
	for i, row in pairs(Login.lobby.rows) do
	
		if #Login.lobby.entries[row.tag] > 0 or row.creatable then
		
			local arrowPosY = posY + Login.lobby.rowHeaderHeight + Login.lobby.roomHeight / 2 - Login.lobby.arrowHeight / 2
			
			local rowName = row.name.." ("..#Login.lobby.entries[row.tag]..")"
			local rowHeaderColor
			
			if row.hidden then
			
				rowName = "+ "..rowName
				
			end
		
			if row.creatable then
			
				table.insert(Login.lobby.entries[row.tag], {type = "plus", arenaElement = false, active = false})
			
			end
		
			local categoryHeight = Login.lobby.rowHeight
		
			if Login.lobby.mode == "SHOW_ALL_ARENAS" then
			
				local sites = math.ceil(#Login.lobby.entries[row.tag] / Login.lobby.arenasPerRow)
		
				categoryHeight = Login.lobby.rowHeaderHeight + (Login.lobby.roomHeight + Login.lobby.roomOffset) * sites
			
			end
		
			if Login.mouseCheck(0, posY + Login.lobby.rowStartY, Login.x, categoryHeight) and Login.mouseCheck(0, Login.lobby.rowStartY, Login.lobby.renderTargetWidth, Login.lobby.renderTargetHeight) then
			
				row.active = true
			
				if Login.mouseCheck(Login.lobby.rowStartX, posY + Login.lobby.rowStartY, dxGetTextWidth(rowName, Login.lobby.rowHeaderFontSize, Login.lobby.rowHeaderFont), Login.lobby.rowHeaderHeight) then
			
					row.rowHeaderActive = true
					
				else
				
					row.rowHeaderActive = false
				
				end
			
			else
			
				row.active = false
				row.rowHeaderActive = false
			
			end
		
			if row.rowHeaderActive then
			
				rowHeaderColor = tocolor( 0, 255, 0, 255)
			
			else
			
				rowHeaderColor = Login.lobby.rowHeaderColor
			
			end
		
			dxDrawText(rowName, Login.lobby.rowStartX, posY, Login.x, Login.y, rowHeaderColor, Login.lobby.rowHeaderFontSize, Login.lobby.rowHeaderFont)
		
			if not row.hidden then
		
				for j, entry in pairs(Login.lobby.entries[row.tag]) do
					
					while true do
					
						local posX
						local posY = posY
						local width = Login.lobby.roomWidth
						local height = Login.lobby.roomHeight
							
						if j >= row.index and j <= row.index + Login.lobby.arenasPerRow - 1 then
						
							posY = posY + Login.lobby.rowHeaderHeight
							posX = Login.lobby.rowStartX + (Login.lobby.roomWidth + Login.lobby.roomOffset) * (j - row.index)
						
						else
							
							if Login.lobby.mode == "SHOW_ALL_ARENAS" then
							
								local currentSite = math.ceil(j / Login.lobby.arenasPerRow) 
								posY = posY + Login.lobby.rowHeaderHeight + ( Login.lobby.roomHeight + Login.lobby.roomOffset ) * (currentSite - 1)
								local index = j - (currentSite - 1) * Login.lobby.arenasPerRow
								posX = Login.lobby.rowStartX + (Login.lobby.roomWidth + Login.lobby.roomOffset) * (index - 1)
							
							else
							
								break
							
							end

						end
					
						if Login.mouseCheck(posX, posY + Login.lobby.rowStartY, Login.lobby.roomWidth, Login.lobby.roomHeight) and Login.mouseCheck(0, Login.lobby.rowStartY, Login.lobby.renderTargetWidth, Login.lobby.renderTargetHeight) then
							
							entry.active = true
								
						else
							
							entry.active = false
							
						end
					
						if entry.type == "arena" then
						
							local arenaElement = entry.arenaElement
						
							local name = getElementData(arenaElement, "alias")
							local color = {getColorFromString(getElementData(arenaElement, "color"))}
							local players = getElementData(arenaElement, "players").." / "..getElementData(arenaElement, "maxplayers")
							local detailY = posY + Login.lobby.roomHeight - Login.lobby.roomDetailHeight
							local category = getElementData(arenaElement, "category")
							local picture
							
							if category == "Custom" then
								
								picture = "custom"
								
							elseif category == "Clan" then
								
								picture = "clan"
							
							elseif category == "Competitive" then
								
								picture = "competitive"
							
							else
							
								picture = getElementData(arenaElement, "name")
								
							end
							
							if entry.active then
							
								posX = posX - 5
								posY = posY - 5
								width = width + 10
								height = height + 10
								
							end
							
							--password
							if getElementData(entry.arenaElement, "password") then
							
								name = name .. " *"
							
							end
							
							dxDrawRectangle(posX, posY, width, height, tocolor(0, 0, 0, 255))
							dxDrawImage(posX + 1, posY + 1, width - 2, height - 2, "img/lobby/"..picture..".png", 0, 0, 0, tocolor( 255, 255, 255, 255), false)
							
							dxDrawText(name, posX + Login.lobby.roomDetailTextOffset + 1, posY + 1, posX + width + 1, posY + height + 1, tocolor(0, 0, 0, 255), 3, Login.lobby.roomDetailFont, "left", "top", true)
							dxDrawText(name, posX + Login.lobby.roomDetailTextOffset, posY, posX + width, posY + height, tocolor(255, 255, 255, 255), 3, Login.lobby.roomDetailFont, "left", "top", true)
							
							if entry.arenaElement == Login.lobby.challenge.arenaElement then
							
								dxDrawText("#00ff00Challenge: #ffffff"..msToHourMinuteSecond(Login.lobby.challenge.challengeTime - getTickCount()), posX + Login.lobby.roomDetailTextOffset, posY + Login.lobby.roomDetailTextOffset, posX + width, posY + height, tocolor(255, 255, 255, 255), Login.lobby.roomDetailNameFontSize, Login.lobby.roomDetailFont, "left", "bottom", false, false, false, true)
							
							elseif getElementData(entry.arenaElement, "queue") then
							
								dxDrawText(getElementData(entry.arenaElement, "queue").." searching", posX + Login.lobby.roomDetailTextOffset, posY + Login.lobby.roomDetailTextOffset, posX + width, posY + height, tocolor(255, 255, 255, 255), Login.lobby.roomDetailNameFontSize, Login.lobby.roomDetailFont, "left", "bottom", false, false, false, true)
							
							end
							
							if entry.active then
								
								local arenaPlayerCountPosX = posX + width - Login.lobby.arenaPlayerCountWidth - Login.lobby.arenaPlayerCountOffset
								local arenaPlayerCountPosY = posY + height - Login.lobby.arenaPlayerCountHeight - Login.lobby.arenaPlayerCountOffset
								
								if Login.mouseCheck(arenaPlayerCountPosX, arenaPlayerCountPosY + Login.lobby.rowStartY, Login.lobby.arenaPlayerCountWidth, Login.lobby.arenaPlayerCountHeight) then
								
									dxDrawRectangle(arenaPlayerCountPosX, arenaPlayerCountPosY, Login.lobby.arenaPlayerCountWidth, Login.lobby.arenaPlayerCountHeight)
									
									dxDrawText(players, arenaPlayerCountPosX, arenaPlayerCountPosY, arenaPlayerCountPosX + Login.lobby.arenaPlayerCountWidth, arenaPlayerCountPosY + Login.lobby.arenaPlayerCountHeight, tocolor(102, 102, 102, 255), Login.lobby.arenaPlayerCountFontSize, Login.lobby.arenaPlayerCountFont, "center", "center")
									Login.lobby.arenaPlayerCountActive = true
									
								else
								
									dxDrawLine(arenaPlayerCountPosX, arenaPlayerCountPosY, arenaPlayerCountPosX + Login.lobby.arenaPlayerCountWidth, arenaPlayerCountPosY, tocolor(255, 255, 255, 255))
									dxDrawLine(arenaPlayerCountPosX, arenaPlayerCountPosY + Login.lobby.arenaPlayerCountHeight, arenaPlayerCountPosX + Login.lobby.arenaPlayerCountWidth, arenaPlayerCountPosY + Login.lobby.arenaPlayerCountHeight, tocolor(255, 255, 255, 255))
									dxDrawLine(arenaPlayerCountPosX, arenaPlayerCountPosY, arenaPlayerCountPosX, arenaPlayerCountPosY + Login.lobby.arenaPlayerCountHeight, tocolor(255, 255, 255, 255))
									dxDrawLine(arenaPlayerCountPosX + Login.lobby.arenaPlayerCountWidth, arenaPlayerCountPosY, arenaPlayerCountPosX + Login.lobby.arenaPlayerCountWidth, arenaPlayerCountPosY + Login.lobby.arenaPlayerCountHeight, tocolor(255, 255, 255, 255))
									
									dxDrawText(players, arenaPlayerCountPosX, arenaPlayerCountPosY, arenaPlayerCountPosX + Login.lobby.arenaPlayerCountWidth, arenaPlayerCountPosY + Login.lobby.arenaPlayerCountHeight, tocolor(255, 255, 255, 255), Login.lobby.arenaPlayerCountFontSize, Login.lobby.arenaPlayerCountFont, "center", "center")
									Login.lobby.arenaPlayerCountActive = false
									
								end
								
								if getElementData(entry.arenaElement, "spectators") then
								
									--Spectate
									local spectateButtonPosX = posX + width - Login.lobby.spectateButtonWidth - Login.lobby.spectateButtonOffset
									local spectateButtonPosY = posY + Login.lobby.spectateButtonOffset
								
									if Login.mouseCheck(spectateButtonPosX, spectateButtonPosY + Login.lobby.rowStartY, Login.lobby.spectateButtonWidth, Login.lobby.spectateButtonHeight) then
										
										dxDrawRectangle(spectateButtonPosX, spectateButtonPosY, Login.lobby.spectateButtonWidth, Login.lobby.spectateButtonHeight)
										
										dxDrawText(Login.lobby.spectateButtonText, spectateButtonPosX, spectateButtonPosY, spectateButtonPosX + Login.lobby.spectateButtonWidth, spectateButtonPosY + Login.lobby.spectateButtonHeight, tocolor(102, 102, 102, 255), Login.lobby.roomDetailNameFontSize, Login.lobby.roomDetailFont, "center", "center")
										Login.lobby.spectateButtonActive = true
										
									else
										
										dxDrawLine(spectateButtonPosX, spectateButtonPosY, spectateButtonPosX + Login.lobby.spectateButtonWidth, spectateButtonPosY, tocolor(255, 255, 255, 255))
										dxDrawLine(spectateButtonPosX, spectateButtonPosY + Login.lobby.spectateButtonHeight, spectateButtonPosX + Login.lobby.spectateButtonWidth, spectateButtonPosY + Login.lobby.spectateButtonHeight, tocolor(255, 255, 255, 255))
										dxDrawLine(spectateButtonPosX, spectateButtonPosY, spectateButtonPosX, spectateButtonPosY + Login.lobby.spectateButtonHeight, tocolor(255, 255, 255, 255))
										dxDrawLine(spectateButtonPosX + Login.lobby.spectateButtonWidth, spectateButtonPosY, spectateButtonPosX + Login.lobby.spectateButtonWidth, spectateButtonPosY + Login.lobby.spectateButtonHeight, tocolor(255, 255, 255, 255))
										
										dxDrawText(Login.lobby.spectateButtonText, spectateButtonPosX, spectateButtonPosY, spectateButtonPosX + Login.lobby.spectateButtonWidth, spectateButtonPosY + Login.lobby.spectateButtonHeight, tocolor(255, 255, 255, 255), Login.lobby.roomDetailNameFontSize, Login.lobby.roomDetailFont, "center", "center")
										Login.lobby.spectateButtonActive = false
									
									end
									
								end
								
								if category == "Competitive" and not getElementData(localPlayer, "competitive")["playing"] then

									local type = getElementData(entry.arenaElement, "type")
									
									if getElementData(localPlayer, "competitive")[type] then
									
										Login.lobby.registerButtonText = "Cancel"
										
									else

										Login.lobby.registerButtonText = "Register"
										
									end
								
									--register
									local registerButtonPosX = posX + width - Login.lobby.registerButtonWidth - Login.lobby.registerButtonOffset - Login.lobby.spectateButtonWidth - Login.lobby.spectateButtonOffset
									local registerButtonPosY = posY + Login.lobby.registerButtonOffset
								
									if Login.mouseCheck(registerButtonPosX, registerButtonPosY + Login.lobby.rowStartY, Login.lobby.registerButtonWidth, Login.lobby.registerButtonHeight) then
										
										dxDrawRectangle(registerButtonPosX, registerButtonPosY, Login.lobby.registerButtonWidth, Login.lobby.registerButtonHeight)
										
										dxDrawText(Login.lobby.registerButtonText, registerButtonPosX, registerButtonPosY, registerButtonPosX + Login.lobby.registerButtonWidth, registerButtonPosY + Login.lobby.registerButtonHeight, tocolor(102, 102, 102, 255), Login.lobby.roomDetailNameFontSize, Login.lobby.roomDetailFont, "center", "center")
										Login.lobby.registerButtonActive = true
										
									else
										
										dxDrawLine(registerButtonPosX, registerButtonPosY, registerButtonPosX + Login.lobby.registerButtonWidth, registerButtonPosY, tocolor(255, 255, 255, 255))
										dxDrawLine(registerButtonPosX, registerButtonPosY + Login.lobby.registerButtonHeight, registerButtonPosX + Login.lobby.registerButtonWidth, registerButtonPosY + Login.lobby.registerButtonHeight, tocolor(255, 255, 255, 255))
										dxDrawLine(registerButtonPosX, registerButtonPosY, registerButtonPosX, registerButtonPosY + Login.lobby.registerButtonHeight, tocolor(255, 255, 255, 255))
										dxDrawLine(registerButtonPosX + Login.lobby.registerButtonWidth, registerButtonPosY, registerButtonPosX + Login.lobby.registerButtonWidth, registerButtonPosY + Login.lobby.registerButtonHeight, tocolor(255, 255, 255, 255))
										
										dxDrawText(Login.lobby.registerButtonText, registerButtonPosX, registerButtonPosY, registerButtonPosX + Login.lobby.registerButtonWidth, registerButtonPosY + Login.lobby.registerButtonHeight, tocolor(255, 255, 255, 255), Login.lobby.roomDetailNameFontSize, Login.lobby.roomDetailFont, "center", "center")
										Login.lobby.registerButtonActive = false
									
									end								
									
								else
								
									Login.lobby.registerButtonActive = false -- weird bug, stays true after joining sometimes
									
								end
							
							end
							
						elseif entry.type == "plus" then
						
							local picture = "img/lobby/plus.png"
						
							if entry.active then
							
								posX = posX - 5
								posY = posY - 5
								width = width + 10
								height = height + 10
								
							end
						
							dxDrawImage(posX, posY, width, height, picture, 0, 0, 0, tocolor( 255, 255, 255, 255), false)
							
						end	
						
						break
							
					end
					
				end
			
				if row.active and row.index > 1 then
					
					if Login.mouseCheck(Login.lobby.arrowLeftPosX, Login.lobby.rowStartY  + arrowPosY, Login.lobby.arrowWidth, Login.lobby.arrowHeight) and Login.mouseCheck(0, Login.lobby.rowStartY, Login.lobby.renderTargetWidth, Login.lobby.renderTargetHeight) then
				
						dxDrawImage(Login.lobby.arrowLeftPosX, arrowPosY, Login.lobby.arrowWidth, Login.lobby.arrowHeight, "img/lobby/arrow_left.png", 0, 0, 0, tocolor( 0, 255, 0, 255), false)
						row.arrowLeftActive = true
			
					else
				
						dxDrawImage(Login.lobby.arrowLeftPosX, arrowPosY, Login.lobby.arrowWidth, Login.lobby.arrowHeight, "img/lobby/arrow_left.png", 0, 0, 0, tocolor( 255, 255, 255, 255), false)
						row.arrowLeftActive = false
						
					end

				else

					row.arrowLeftActive = false
					
				end

				if Login.lobby.mode ~= "SHOW_ALL_ARENAS" then
				
					if row.active and row.index + Login.lobby.arenasPerRow - 1 < #Login.lobby.entries[row.tag] then
						
						if Login.mouseCheck(Login.lobby.arrowRightPosX, Login.lobby.rowStartY + arrowPosY, Login.lobby.arrowWidth, Login.lobby.arrowHeight) and Login.mouseCheck(0, Login.lobby.rowStartY, Login.lobby.renderTargetWidth, Login.lobby.renderTargetHeight) then
							
							dxDrawImage(Login.lobby.arrowRightPosX, arrowPosY, Login.lobby.arrowWidth, Login.lobby.arrowHeight, "img/lobby/arrow_right.png", 0, 0, 0, tocolor( 0, 255, 0, 255), false)
							row.arrowRightActive = true
						
						else
							
							dxDrawImage(Login.lobby.arrowRightPosX, arrowPosY, Login.lobby.arrowWidth, Login.lobby.arrowHeight, "img/lobby/arrow_right.png", 0, 0, 0, tocolor( 255, 255, 255, 255), false)
							row.arrowRightActive = false
							
						end
						
					else

						row.arrowRightActive = false
						
					end
				
				end

				if Login.lobby.mode ~= "SHOW_ALL_ARENAS" then
					
					if row.active then
					
						local sites = math.ceil(#Login.lobby.entries[row.tag] / Login.lobby.arenasPerRow)
						local currentSite = math.ceil(row.index / Login.lobby.arenasPerRow) 
						local circlePosX = Login.x / 2 - ((Login.lobby.circleSize + Login.lobby.circleOffset) * sites ) / 2
						
						if sites > 1 then
							
							for site = 1, sites, 1 do
							
								if site == currentSite then
								
									dxDrawImage(circlePosX, posY + Login.lobby.rowHeight, Login.lobby.circleSize, Login.lobby.circleSize, "img/lobby/circle_empty.png", 0, 0, 0, tocolor( 0, 150, 255, 255), false)
								
								else
							
									dxDrawImage(circlePosX, posY + Login.lobby.rowHeight, Login.lobby.circleSize, Login.lobby.circleSize, "img/lobby/circle_empty.png", 0, 0, 0, tocolor( 255, 255, 255, 255), false)
							
								end
								
								circlePosX = circlePosX + (Login.lobby.circleSize + Login.lobby.circleOffset)
							
							end
						
						end
						
					end
				
				end
				
				if Login.lobby.mode == "SHOW_ALL_ARENAS" then
					
					local sites = math.ceil(#Login.lobby.entries[row.tag] / Login.lobby.arenasPerRow)
		
					posY = posY + Login.lobby.rowHeaderHeight + Login.lobby.rowOffset + (Login.lobby.roomHeight + Login.lobby.roomOffset) * sites
				
				else
				
					posY = posY + Login.lobby.rowHeight + Login.lobby.rowOffset
					
				end
				
			else

				posY = posY + Login.lobby.rowHeaderHeight
				
			end	
				
		end
		
	end
	
	dxSetBlendMode("blend")
	dxSetRenderTarget()
	
	dxSetBlendMode("add") 
	dxDrawImage(Login.lobby.animatedPosX, Login.lobby.rowStartY, Login.lobby.renderTargetWidth, Login.lobby.renderTargetHeight, Login.lobby.renderTarget, 0, 0, 0, tocolor(255, 255, 255, 255), Login.lobby.postGui)
	dxSetBlendMode("blend")
	
	if Login.getMaxScrollValue() > Login.lobby.renderTargetHeight then
	
		local scrollPercent =  Login.lobby.scroll / (Login.getMaxScrollValue() - Login.lobby.renderTargetHeight)
	
		Login.lobby.scrollBarHeight = Login.lobby.renderTargetHeight * (Login.lobby.renderTargetHeight / Login.getMaxScrollValue())

		dxDrawLine(Login.lobby.animatedPosX + Login.lobby.scrollbarPosX, Login.lobby.rowStartY, Login.lobby.animatedPosX + Login.lobby.scrollbarPosX, Login.lobby.rowStartY + Login.lobby.renderTargetHeight, tocolor(255, 255, 255, 175), 1)

		dxDrawRectangle(Login.lobby.animatedPosX + Login.lobby.scrollbarPosX - Login.lobby.scrollbarWidth / 2, Login.lobby.rowStartY + (Login.lobby.renderTargetHeight - Login.lobby.scrollBarHeight) * scrollPercent, Login.lobby.scrollbarWidth, Login.lobby.scrollBarHeight, tocolor(255, 255, 255, 255), Login.lobby.postGui)
		
	end
	
	if not Login.lobby.playerInLobby then
	
		local leaveButtonPosX = Login.lobby.animatedPosX + Login.lobby.leaveButtonPosX
	
		--Leave Arena
		if Login.mouseCheck(leaveButtonPosX, Login.lobby.leaveButtonPosY, Login.lobby.leaveButtonWidth, Login.lobby.leaveButtonHeight) then
			
			dxDrawRectangle(leaveButtonPosX, Login.lobby.leaveButtonPosY, Login.lobby.leaveButtonWidth, Login.lobby.leaveButtonHeight)
			
			dxDrawText(Login.lobby.leaveButtonText, leaveButtonPosX, Login.lobby.leaveButtonPosY, leaveButtonPosX + Login.lobby.leaveButtonWidth, Login.lobby.leaveButtonPosY + Login.lobby.leaveButtonHeight, tocolor(102, 102, 102, 255), Login.lobby.roomDetailNameFontSize, Login.lobby.roomDetailFont, "center", "center")
			Login.lobby.leaveButtonActive = true
			
		else
			
			dxDrawLine(leaveButtonPosX, Login.lobby.leaveButtonPosY, leaveButtonPosX + Login.lobby.leaveButtonWidth, Login.lobby.leaveButtonPosY, tocolor(255, 255, 255, 255))
			dxDrawLine(leaveButtonPosX, Login.lobby.leaveButtonPosY + Login.lobby.leaveButtonHeight, leaveButtonPosX + Login.lobby.leaveButtonWidth, Login.lobby.leaveButtonPosY + Login.lobby.leaveButtonHeight, tocolor(255, 255, 255, 255))
			dxDrawLine(leaveButtonPosX, Login.lobby.leaveButtonPosY, leaveButtonPosX, Login.lobby.leaveButtonPosY + Login.lobby.leaveButtonHeight, tocolor(255, 255, 255, 255))
			dxDrawLine(leaveButtonPosX + Login.lobby.leaveButtonWidth, Login.lobby.leaveButtonPosY, leaveButtonPosX + Login.lobby.leaveButtonWidth, Login.lobby.leaveButtonPosY + Login.lobby.leaveButtonHeight, tocolor(255, 255, 255, 255))
			
			dxDrawText(Login.lobby.leaveButtonText, leaveButtonPosX, Login.lobby.leaveButtonPosY, leaveButtonPosX + Login.lobby.leaveButtonWidth, Login.lobby.leaveButtonPosY + Login.lobby.leaveButtonHeight, tocolor(255, 255, 255, 255), Login.lobby.roomDetailNameFontSize, Login.lobby.roomDetailFont, "center", "center")
			Login.lobby.leaveButtonActive = false
			
		end	
	
	else
	
		local logoutButtonPosX = Login.lobby.animatedPosX + Login.lobby.logoutButtonPosX
	
		--Logout
		if Login.mouseCheck(logoutButtonPosX, Login.lobby.logoutButtonPosY, Login.lobby.logoutButtonWidth, Login.lobby.logoutButtonHeight) then
			
			dxDrawRectangle(logoutButtonPosX, Login.lobby.logoutButtonPosY, Login.lobby.logoutButtonWidth, Login.lobby.logoutButtonHeight)
					
			dxDrawText(Login.lobby.logoutButtonText, logoutButtonPosX, Login.lobby.logoutButtonPosY, logoutButtonPosX + Login.lobby.logoutButtonWidth, Login.lobby.logoutButtonPosY + Login.lobby.logoutButtonHeight, tocolor(102, 102, 102, 255), Login.lobby.roomDetailNameFontSize, Login.lobby.roomDetailFont, "center", "center")
			Login.lobby.logoutButtonActive = true
			
		else
			
			dxDrawLine(logoutButtonPosX, Login.lobby.logoutButtonPosY, logoutButtonPosX + Login.lobby.logoutButtonWidth, Login.lobby.logoutButtonPosY, tocolor(255, 255, 255, 255))
			dxDrawLine(logoutButtonPosX, Login.lobby.logoutButtonPosY + Login.lobby.logoutButtonHeight, logoutButtonPosX + Login.lobby.logoutButtonWidth, Login.lobby.logoutButtonPosY + Login.lobby.logoutButtonHeight, tocolor(255, 255, 255, 255))
			dxDrawLine(logoutButtonPosX, Login.lobby.logoutButtonPosY, logoutButtonPosX, Login.lobby.logoutButtonPosY + Login.lobby.logoutButtonHeight, tocolor(255, 255, 255, 255))
			dxDrawLine(logoutButtonPosX + Login.lobby.logoutButtonWidth, Login.lobby.logoutButtonPosY, logoutButtonPosX + Login.lobby.logoutButtonWidth, Login.lobby.logoutButtonPosY + Login.lobby.logoutButtonHeight, tocolor(255, 255, 255, 255))
			
			dxDrawText(Login.lobby.logoutButtonText, logoutButtonPosX, Login.lobby.logoutButtonPosY, logoutButtonPosX + Login.lobby.logoutButtonWidth, Login.lobby.logoutButtonPosY + Login.lobby.logoutButtonHeight, tocolor(255, 255, 255, 255), Login.lobby.roomDetailNameFontSize, Login.lobby.roomDetailFont, "center", "center")
			Login.lobby.logoutButtonActive = false
			
		end	
		
	end	
	
	local trainingButtonPosX = Login.lobby.animatedPosX + Login.lobby.trainingButtonPosX
	
	--Training
	if Login.mouseCheck(trainingButtonPosX, Login.lobby.trainingButtonPosY, Login.lobby.trainingButtonWidth, Login.lobby.trainingButtonHeight) then
		
		dxDrawRectangle(trainingButtonPosX, Login.lobby.trainingButtonPosY, Login.lobby.trainingButtonWidth, Login.lobby.trainingButtonHeight)
		
		dxDrawText(Login.lobby.trainingButtonText, trainingButtonPosX, Login.lobby.trainingButtonPosY, trainingButtonPosX + Login.lobby.trainingButtonWidth, Login.lobby.trainingButtonPosY + Login.lobby.trainingButtonHeight, tocolor(102, 102, 102, 255), Login.lobby.roomDetailNameFontSize, Login.lobby.roomDetailFont, "center", "center")
		Login.lobby.trainingButtonActive = true
		
	else
		
		dxDrawLine(trainingButtonPosX, Login.lobby.trainingButtonPosY, trainingButtonPosX + Login.lobby.trainingButtonWidth, Login.lobby.trainingButtonPosY, tocolor(255, 255, 255, 255))
		dxDrawLine(trainingButtonPosX, Login.lobby.trainingButtonPosY + Login.lobby.trainingButtonHeight, trainingButtonPosX + Login.lobby.trainingButtonWidth, Login.lobby.trainingButtonPosY + Login.lobby.trainingButtonHeight, tocolor(255, 255, 255, 255))
		dxDrawLine(trainingButtonPosX, Login.lobby.trainingButtonPosY, trainingButtonPosX, Login.lobby.trainingButtonPosY + Login.lobby.trainingButtonHeight, tocolor(255, 255, 255, 255))
		dxDrawLine(trainingButtonPosX + Login.lobby.trainingButtonWidth, Login.lobby.trainingButtonPosY, trainingButtonPosX + Login.lobby.trainingButtonWidth, Login.lobby.trainingButtonPosY + Login.lobby.trainingButtonHeight, tocolor(255, 255, 255, 255))
				
		dxDrawText(Login.lobby.trainingButtonText, trainingButtonPosX, Login.lobby.trainingButtonPosY, trainingButtonPosX + Login.lobby.trainingButtonWidth, Login.lobby.trainingButtonPosY + Login.lobby.trainingButtonHeight, tocolor(255, 255, 255, 255), Login.lobby.roomDetailNameFontSize, Login.lobby.roomDetailFont, "center", "center")
		Login.lobby.trainingButtonActive = false
		
	end

	local settingsButtonPosX = Login.lobby.animatedPosX + Login.lobby.settingsButtonPosX

	--Settings
	if Login.mouseCheck(settingsButtonPosX, Login.lobby.settingsButtonPosY, Login.lobby.settingsButtonWidth, Login.lobby.settingsButtonHeight) then
		
		dxDrawRectangle(settingsButtonPosX, Login.lobby.settingsButtonPosY, Login.lobby.settingsButtonWidth, Login.lobby.settingsButtonHeight)
		
		dxDrawText(Login.lobby.settingsButtonText, settingsButtonPosX, Login.lobby.settingsButtonPosY, settingsButtonPosX + Login.lobby.settingsButtonWidth, Login.lobby.settingsButtonPosY + Login.lobby.settingsButtonHeight, tocolor(102, 102, 102, 255), Login.lobby.roomDetailNameFontSize, Login.lobby.roomDetailFont, "center", "center")
		Login.lobby.settingsButtonActive = true
		
	else
		
		dxDrawLine(settingsButtonPosX, Login.lobby.settingsButtonPosY, settingsButtonPosX + Login.lobby.settingsButtonWidth, Login.lobby.settingsButtonPosY, tocolor(255, 255, 255, 255))
		dxDrawLine(settingsButtonPosX, Login.lobby.settingsButtonPosY + Login.lobby.settingsButtonHeight, settingsButtonPosX + Login.lobby.settingsButtonWidth, Login.lobby.settingsButtonPosY + Login.lobby.settingsButtonHeight, tocolor(255, 255, 255, 255))
		dxDrawLine(settingsButtonPosX, Login.lobby.settingsButtonPosY, settingsButtonPosX, Login.lobby.settingsButtonPosY + Login.lobby.settingsButtonHeight, tocolor(255, 255, 255, 255))
		dxDrawLine(settingsButtonPosX + Login.lobby.settingsButtonWidth, Login.lobby.settingsButtonPosY, settingsButtonPosX + Login.lobby.settingsButtonWidth, Login.lobby.settingsButtonPosY + Login.lobby.settingsButtonHeight, tocolor(255, 255, 255, 255))
				
		dxDrawText(Login.lobby.settingsButtonText, settingsButtonPosX, Login.lobby.settingsButtonPosY, settingsButtonPosX + Login.lobby.settingsButtonWidth, Login.lobby.settingsButtonPosY + Login.lobby.settingsButtonHeight, tocolor(255, 255, 255, 255), Login.lobby.roomDetailNameFontSize, Login.lobby.roomDetailFont, "center", "center")
		Login.lobby.settingsButtonActive = false
		
	end	
	
	local playercountButtonPosX = Login.lobby.animatedPosX + Login.lobby.playercountButtonPosX
	
	if Login.mouseCheck(playercountButtonPosX, Login.lobby.playercountButtonPosY, Login.lobby.playercountButtonWidth, Login.lobby.playercountButtonHeight) then
	
		dxDrawRectangle(playercountButtonPosX, Login.lobby.playercountButtonPosY, Login.lobby.playercountButtonWidth, Login.lobby.playercountButtonHeight)
		
		dxDrawText(#getElementsByType("player").." players online", playercountButtonPosX, Login.lobby.playercountButtonPosY, playercountButtonPosX + Login.lobby.playercountButtonWidth, Login.lobby.playercountButtonPosY + Login.lobby.playercountButtonHeight, tocolor(102, 102, 102, 255), Login.lobby.roomDetailNameFontSize, Login.lobby.roomDetailFont, "center", "center")
		
	else
	
		--player count
		dxDrawLine(playercountButtonPosX, Login.lobby.playercountButtonPosY, playercountButtonPosX + Login.lobby.playercountButtonWidth, Login.lobby.playercountButtonPosY, tocolor(255, 255, 255, 255))
		dxDrawLine(playercountButtonPosX, Login.lobby.playercountButtonPosY + Login.lobby.playercountButtonHeight, playercountButtonPosX + Login.lobby.playercountButtonWidth, Login.lobby.playercountButtonPosY + Login.lobby.playercountButtonHeight, tocolor(255, 255, 255, 255))
		dxDrawLine(playercountButtonPosX, Login.lobby.playercountButtonPosY, playercountButtonPosX, Login.lobby.playercountButtonPosY + Login.lobby.playercountButtonHeight, tocolor(255, 255, 255, 255))
		dxDrawLine(playercountButtonPosX + Login.lobby.playercountButtonWidth, Login.lobby.playercountButtonPosY, playercountButtonPosX + Login.lobby.playercountButtonWidth, Login.lobby.playercountButtonPosY + Login.lobby.playercountButtonHeight, tocolor(255, 255, 255, 255))
		
		dxDrawText(#getElementsByType("player").." players online", playercountButtonPosX, Login.lobby.playercountButtonPosY, playercountButtonPosX + Login.lobby.playercountButtonWidth, Login.lobby.playercountButtonPosY + Login.lobby.playercountButtonHeight, tocolor(255, 255, 255, 255), Login.lobby.roomDetailNameFontSize, Login.lobby.roomDetailFont, "center", "center")
		
	end
		
	if getElementData(localPlayer, "competitive")["waiting"] then
	
		dxDrawText(Login.lobby.competitiveInfoText.." "..Login.lobby.competitive.type, Login.lobby.competitiveInfoPosX, Login.lobby.competitiveInfoPosY, Login.x, Login.lobby.competitiveInfoPosY + Login.lobby.competitiveInfoHeight, tocolor(255, 255, 255, 255), Login.lobby.competitiveInfoFontSize, Login.lobby.roomDetailFont, "center", "top")
			
		dxDrawText(Login.lobby.competitivePlayersInfoText, Login.lobby.competitivePlayersInfoPosX, Login.lobby.competitivePlayersInfoPosY, Login.x, Login.lobby.competitivePlayersInfoPosY + Login.lobby.competitivePlayersInfoHeight, tocolor(255, 255, 255, 255), Login.lobby.competitivePlayersInfoFontSize, Login.lobby.roomDetailFont, "center", "top")
		
	end
		
	if getElementData(localPlayer, "competitive")["waiting"] then
	
		if not getElementData(localPlayer, "competitive")["ready"] then
		
			local timeLeft = math.floor((Login.lobby.competitive.responseTime - getTickCount()) / 1000)
			local acceptButtonText = Login.lobby.acceptButtonText.." ("..math.max(0, timeLeft)..")"
			local declineButtonText = Login.lobby.declineButtonText.." ("..math.max(0, timeLeft)..")"
				
			if Login.mouseCheck(Login.lobby.acceptButtonPosX, Login.lobby.acceptButtonPosY, Login.lobby.acceptButtonWidth, Login.lobby.acceptButtonHeight) then
			
				dxDrawRectangle(Login.lobby.acceptButtonPosX, Login.lobby.acceptButtonPosY, Login.lobby.acceptButtonWidth, Login.lobby.acceptButtonHeight)
				dxDrawLine(Login.lobby.acceptButtonPosX, Login.lobby.acceptButtonPosY, Login.lobby.acceptButtonPosX + Login.lobby.acceptButtonWidth, Login.lobby.acceptButtonPosY, tocolor(102, 102, 102, 255))
				dxDrawLine(Login.lobby.acceptButtonPosX, Login.lobby.acceptButtonPosY + Login.lobby.acceptButtonHeight, Login.lobby.acceptButtonPosX + Login.lobby.acceptButtonWidth, Login.lobby.acceptButtonPosY + Login.lobby.acceptButtonHeight, tocolor(102, 102, 102, 255))
				dxDrawLine(Login.lobby.acceptButtonPosX, Login.lobby.acceptButtonPosY, Login.lobby.acceptButtonPosX, Login.lobby.acceptButtonPosY + Login.lobby.acceptButtonHeight, tocolor(102, 102, 102, 255))
				dxDrawLine(Login.lobby.acceptButtonPosX + Login.lobby.acceptButtonWidth, Login.lobby.acceptButtonPosY, Login.lobby.acceptButtonPosX + Login.lobby.acceptButtonWidth, Login.lobby.acceptButtonPosY + Login.lobby.acceptButtonHeight, tocolor(102, 102, 102, 255))
				
				dxDrawText(acceptButtonText, Login.lobby.acceptButtonPosX, Login.lobby.acceptButtonPosY, Login.lobby.acceptButtonPosX + Login.lobby.acceptButtonWidth, Login.lobby.acceptButtonPosY + Login.lobby.acceptButtonHeight, tocolor(102, 102, 102, 255), Login.lobby.acceptButtonFontSize, Login.lobby.roomDetailFont, "center", "center")
				Login.lobby.acceptButtonActive = true	
					
			else

				dxDrawRectangle(Login.lobby.acceptButtonPosX, Login.lobby.acceptButtonPosY, Login.lobby.acceptButtonWidth, Login.lobby.acceptButtonHeight, tocolor(50, 205, 50, 255))
				dxDrawLine(Login.lobby.acceptButtonPosX, Login.lobby.acceptButtonPosY, Login.lobby.acceptButtonPosX + Login.lobby.acceptButtonWidth, Login.lobby.acceptButtonPosY, tocolor(255, 255, 255, 255))
				dxDrawLine(Login.lobby.acceptButtonPosX, Login.lobby.acceptButtonPosY + Login.lobby.acceptButtonHeight, Login.lobby.acceptButtonPosX + Login.lobby.acceptButtonWidth, Login.lobby.acceptButtonPosY + Login.lobby.acceptButtonHeight, tocolor(255, 255, 255, 255))
				dxDrawLine(Login.lobby.acceptButtonPosX, Login.lobby.acceptButtonPosY, Login.lobby.acceptButtonPosX, Login.lobby.acceptButtonPosY + Login.lobby.acceptButtonHeight, tocolor(255, 255, 255, 255))
				dxDrawLine(Login.lobby.acceptButtonPosX + Login.lobby.acceptButtonWidth, Login.lobby.acceptButtonPosY, Login.lobby.acceptButtonPosX + Login.lobby.acceptButtonWidth, Login.lobby.acceptButtonPosY + Login.lobby.acceptButtonHeight, tocolor(255, 255, 255, 255))
				
				dxDrawText(acceptButtonText, Login.lobby.acceptButtonPosX, Login.lobby.acceptButtonPosY, Login.lobby.acceptButtonPosX + Login.lobby.acceptButtonWidth, Login.lobby.acceptButtonPosY + Login.lobby.acceptButtonHeight, tocolor(255, 255, 255, 255), Login.lobby.acceptButtonFontSize, Login.lobby.roomDetailFont, "center", "center")
				Login.lobby.acceptButtonActive = false	
				
			end
		
			if Login.mouseCheck(Login.lobby.declineButtonPosX, Login.lobby.declineButtonPosY, Login.lobby.declineButtonWidth, Login.lobby.declineButtonHeight) then
			
				dxDrawRectangle(Login.lobby.declineButtonPosX, Login.lobby.declineButtonPosY, Login.lobby.declineButtonWidth, Login.lobby.declineButtonHeight)
				dxDrawLine(Login.lobby.declineButtonPosX, Login.lobby.declineButtonPosY, Login.lobby.declineButtonPosX + Login.lobby.declineButtonWidth, Login.lobby.declineButtonPosY, tocolor(102, 102, 102, 255))
				dxDrawLine(Login.lobby.declineButtonPosX, Login.lobby.declineButtonPosY + Login.lobby.declineButtonHeight, Login.lobby.declineButtonPosX + Login.lobby.declineButtonWidth, Login.lobby.declineButtonPosY + Login.lobby.declineButtonHeight, tocolor(102, 102, 102, 255))
				dxDrawLine(Login.lobby.declineButtonPosX, Login.lobby.declineButtonPosY, Login.lobby.declineButtonPosX, Login.lobby.declineButtonPosY + Login.lobby.declineButtonHeight, tocolor(102, 102, 102, 255))
				dxDrawLine(Login.lobby.declineButtonPosX + Login.lobby.declineButtonWidth, Login.lobby.declineButtonPosY, Login.lobby.declineButtonPosX + Login.lobby.declineButtonWidth, Login.lobby.declineButtonPosY + Login.lobby.declineButtonHeight, tocolor(102, 102, 102, 255))
				
				dxDrawText(declineButtonText, Login.lobby.declineButtonPosX, Login.lobby.declineButtonPosY, Login.lobby.declineButtonPosX + Login.lobby.declineButtonWidth, Login.lobby.declineButtonPosY + Login.lobby.declineButtonHeight, tocolor(102, 102, 102, 255), Login.lobby.declineButtonFontSize, Login.lobby.roomDetailFont, "center", "center")
				Login.lobby.declineButtonActive = true	
					
			else

				dxDrawRectangle(Login.lobby.declineButtonPosX, Login.lobby.declineButtonPosY, Login.lobby.declineButtonWidth, Login.lobby.declineButtonHeight, tocolor(178, 34, 34, 255))
				dxDrawLine(Login.lobby.declineButtonPosX, Login.lobby.declineButtonPosY, Login.lobby.declineButtonPosX + Login.lobby.declineButtonWidth, Login.lobby.declineButtonPosY, tocolor(255, 255, 255, 255))
				dxDrawLine(Login.lobby.declineButtonPosX, Login.lobby.declineButtonPosY + Login.lobby.declineButtonHeight, Login.lobby.declineButtonPosX + Login.lobby.declineButtonWidth, Login.lobby.declineButtonPosY + Login.lobby.declineButtonHeight, tocolor(255, 255, 255, 255))
				dxDrawLine(Login.lobby.declineButtonPosX, Login.lobby.declineButtonPosY, Login.lobby.declineButtonPosX, Login.lobby.declineButtonPosY + Login.lobby.declineButtonHeight, tocolor(255, 255, 255, 255))
				dxDrawLine(Login.lobby.declineButtonPosX + Login.lobby.declineButtonWidth, Login.lobby.declineButtonPosY, Login.lobby.declineButtonPosX + Login.lobby.declineButtonWidth, Login.lobby.declineButtonPosY + Login.lobby.declineButtonHeight, tocolor(255, 255, 255, 255))
				
				dxDrawText(declineButtonText, Login.lobby.declineButtonPosX, Login.lobby.declineButtonPosY, Login.lobby.declineButtonPosX + Login.lobby.declineButtonWidth, Login.lobby.declineButtonPosY + Login.lobby.declineButtonHeight, tocolor(255, 255, 255, 255), Login.lobby.declineButtonFontSize, Login.lobby.roomDetailFont, "center", "center")
				Login.lobby.declineButtonActive = false	
				
			end
	
		end
	
	end
		
	--scroll info
	if Login.lobby.scrollPosition ~= 1 then
	
		dxDrawText(Login.lobby.scrollInfoText, Login.lobby.animatedPosX + Login.lobby.scrollInfoPosX, Login.lobby.scrollInfoPosY, Login.x, Login.lobby.scrollInfoPosY + Login.lobby.scrollInfoHeight, tocolor(255, 255, 255, 255), Login.lobby.scrollInfoFontSize, Login.lobby.scrollInfoFont, "left", "top")
		
	end	
		
end


function Login.mouseCheck(posX, posY, width, height)
	
	local mouseX, mouseY = getCursorPosition()
	
	if not mouseX then return false end
	
	mouseX = mouseX * Login.x
	mouseY = mouseY * Login.y

	if mouseX < posX or mouseX > posX + width then return false end

	if mouseY < posY or mouseY > posY + height then return false end

	return true

end


function Login.processScroll(direction)

	--no scroll needed
	if Login.getMaxScrollValue() < Login.lobby.renderTargetHeight then return end

	if direction then
	
		Login.lobby.scroll = Login.lobby.scroll - Login.lobby.scrollValue
		Login.lobby.scrollPosition = 0.5
		
	else
	
		Login.lobby.scroll = Login.lobby.scroll + Login.lobby.scrollValue
		Login.lobby.scrollPosition = 0.5

	end	
		
	if Login.lobby.scroll < 0 then
	
		Login.lobby.scroll = 0
		Login.lobby.scrollPosition = 0
		
	elseif Login.lobby.scroll > Login.getMaxScrollValue() - Login.lobby.renderTargetHeight then
		
		Login.lobby.scroll = Login.getMaxScrollValue() - Login.lobby.renderTargetHeight
		Login.lobby.scrollPosition = 1
		
	end

end


function Login.getMaxScrollValue()

	local height = 0

	for i, row in pairs(Login.lobby.rows) do
	
		if #Login.lobby.entries[row.tag] > 0 then
		
			if not row.hidden then
			
				if Login.lobby.mode == "SHOW_ALL_ARENAS" then
				
					local sites = math.ceil(#Login.lobby.entries[row.tag] / Login.lobby.arenasPerRow)
					height = height + Login.lobby.rowHeaderHeight + Login.lobby.rowOffset + (Login.lobby.roomHeight + Login.lobby.roomOffset) * sites
				
				else
				
					height = height + Login.lobby.rowHeight + Login.lobby.rowOffset
				
				end
		
			else
			
				height = height + Login.lobby.rowHeaderHeight
			
			end
		
		end
	
	end

	return height
	
end


function Login.challenge(time)

	Login.lobby.challenge.arenaElement = source
	Login.lobby.challenge.challengeTime = getTickCount() + time

end
addEvent("onClientChallengeInfo", true)
addEventHandler("onClientChallengeInfo", root, Login.challenge)		


function Login.competitive(type, timeout)

	Login.lobby.competitive.type = type
	Login.lobby.competitive.responseTime = getTickCount() + timeout
	Login.lobby.competitivePlayersInfoText = "Players ready: 0 of 2"
	
end
addEvent("onClientCompetitiveMatchFound", true)
addEventHandler("onClientCompetitiveMatchFound", root, Login.competitive)


function Login.competitiveUpdate(num, total)

	Login.lobby.competitivePlayersInfoText = "Players ready: "..num.." of "..total

end
addEvent("onClientCompetitiveMatchUpdate", true)
addEventHandler("onClientCompetitiveMatchUpdate", root, Login.competitiveUpdate)


function Login.competitiveInfo(info)
	
	Login.lobby.competitive.skillPoints = info.skillPoints
	Login.lobby.competitive.matches = info.matches
	
end
addEvent("onClientCompetitiveInfo", true)
addEventHandler("onClientCompetitiveInfo", root, Login.competitiveInfo)


function Login.login.loginButtonHandler(username, password, remember_me)
	
	if #username:gsub(" ", "") == 0 then
		
		exports["CCS_notifications"]:export_showNotification("Please enter your username!", "warning")
		return
		
	elseif #password:gsub(" ", "") == 0 then

		exports["CCS_notifications"]:export_showNotification("Please enter your password!", "warning")
		return
		
	end
	
	Login.lobby.loginWindow.setEnabled(false)
	
	triggerServerEvent("onLogin", localPlayer, username, password, remember_me)
	
	exports["CCS_notifications"]:export_showNotification("Logging in...", "information")
	
	Login.login.loginData = {username, password, remember_me}
	
	Login.timeoutTimer = setTimer(Login.loginResponse, 10000, 1, -1)
	
end
addEvent("onLoginButtonClick", false)


function Login.login.registerButtonHandler()
	
	Login.lobby.loginWindow.setVisible(false)
	
	Login.lobby.registerWindow = RegisterWindow.new()
	Login.lobby.registerWindow.setVisible(true)
	
end
addEvent("onRegisterButtonClick", false)


function Login.login.cancelButtonHandler()
	
	if Login.lobby.registerWindow then 
	
		Login.lobby.registerWindow:destroy()
		Login.lobby.registerWindow = nil
		
	end
	
	Login.lobby.loginWindow.setVisible(true)
	
end
addEvent("onCancelButtonClick", false)


function Login.login.continueButtonHandler(username, password, passwordConfirm, email)
	
	if #username:gsub(" ", "") == 0 then
	
		exports["CCS_notifications"]:export_showNotification("Please choose a username!", "warning")
		return
		
	elseif #password:gsub(" ", "") == 0 then
	
		exports["CCS_notifications"]:export_showNotification("Please choose a password!", "warning")
		return
	
	elseif #passwordConfirm:gsub(" ", "") == 0 then
	
		exports["CCS_notifications"]:export_showNotification("Please confirm your password!", "warning")
		return
	
	elseif #email:gsub(" ", "") == 0 then
	
		exports["CCS_notifications"]:export_showNotification("Please enter an E-Mail address!", "warning")
		return
	
	end
	
	if #username < 4 then
	
		exports["CCS_notifications"]:export_showNotification("Please choose a longer username!", "warning")
		return
	
	elseif #password < 4 then
	
		exports["CCS_notifications"]:export_showNotification("Please choose a longer password!", "warning")
		return
	
	elseif password ~= passwordConfirm then
	
		exports["CCS_notifications"]:export_showNotification("Your passwords don't match!", "warning")
		return
	
	elseif not string.match(email, "^[%w.]+@%w+%.%w+$", 1, true) then
	
		exports["CCS_notifications"]:export_showNotification("Please enter a valid E-Mail address!", "warning")
		return
	
	end
	
	Login.lobby.registerWindow.setEnabled(false)
	
	triggerServerEvent("onRegister", localPlayer, username, password, email)
	
	exports["CCS_notifications"]:export_showNotification("Creating an account...", "information")
	
	Login.timeoutTimer = setTimer(Login.registerResponse, 10000, 1, -1)
	
end
addEvent("onContinueButtonClick", false)


function Login.login.guestButtonHandler()

	Login.lobby.loginWindow.setEnabled(true)

	triggerServerEvent("onGuest", localPlayer)

	exports["CCS_notifications"]:export_showNotification("Playing as Guest...", "information")

end
addEvent("onGuestButtonClick", false)


function Login.login.success()
	
	Login.loggedIn = true
	Login.startAnimation(1)
	exports["CCS_notifications"]:export_showNotification("Successfully logged in!", "success")
	
end
	

function Login.createArena(name, password, afkChecker, ping, fps, cptp, wff, specs, rewind, mods, maps)
	
	if #name:gsub(" ", "") < 4 then
	
		exports["CCS_notifications"]:export_showNotification("The arena name is too short!", "warning")
		return
	
	end
	
	if #name:gsub(" ", "") > 20 then
	
		exports["CCS_notifications"]:export_showNotification("The arena name is too long!", "warning")
		return
	
	end
	
	if name:gsub(" ", ""):find("%A+") then
	
		exports["CCS_notifications"]:export_showNotification("The arena name can only contain letters!", "warning")
		return
	
	end
	
	if getElementByID(name) then
	
		exports["CCS_notifications"]:export_showNotification("The arena name is already taken!", "warning")
		return
		
	end
	
	local maps = fromJSON(maps)
	
	local arena_type
	
	for map_type, state in pairs(maps) do
	
		if state then
		
			if not arena_type then
			
				arena_type = map_type
			
			else
			
				arena_type = arena_type..";"..map_type
			
			end
					
		end
	
	end
	
	if not arena_type then
	
		exports["CCS_notifications"]:export_showNotification("You have to select at least one map type!", "warning")
		return
		
	end

	Login.lobby.createArenaWindow.setVisible ( false )
	
	if Login.joinLock or getTickCount() - Login.joinFloodLock < Login.joinFloodInterval then 
	
		exports["CCS_notifications"]:export_showNotification("Join flood! Please wait 5 seconds!", "warning")
		return
		
	end
	
	triggerServerEvent("onLobbyCreateArena", localPlayer, name, password, afkChecker, ping, fps, cptp, wff, specs, rewind, mods, arena_type)

end
addEvent("onCreateArenaButton")


function Login.toggle()

	if Login.isLobbyActive then
	
		Login.destroy()
		
	else
	
		Login.create()
	
	end
	
end


function Login.training()

	if Login.joinLock or getTickCount() - Login.joinFloodLock < Login.joinFloodInterval then 
	
		exports["CCS_notifications"]:export_showNotification("Join flood! Please wait 5 seconds!", "warning")
		return
		
	end

	triggerServerEvent("onCreateTrainingArena", localPlayer)

end


function Login.lobbySettings(showAllArenas, animateMethod, blurryBackground, ingameBackground, arenaSize)

	if showAllArenas then
	
		Login.lobby.mode = "SHOW_ALL_ARENAS"
		
	else
	
		Login.lobby.mode = "SHOW_IN_ROWS"
	
	end
	
	Login.lobby.animateMethod = animateMethod
	
	Login.lobby.blurryBackground = blurryBackground
	
	Login.lobby.ingameBackground = ingameBackground

	Login.lobby.roomSize = arenaSize

	Login.adjustArenaSize()

	Login.saveSettings()

end
addEvent("onLobbySettingsChange", false)


function Login.adjustArenaSize()

	Login.lobby.roomWidth = Login.lobby.roomSizeOptions[Login.lobby.roomSize][1] * Login.relY
	Login.lobby.roomHeight = Login.lobby.roomSizeOptions[Login.lobby.roomSize][2] * Login.relY
	Login.lobby.rowHeight = Login.lobby.rowHeaderHeight + Login.lobby.roomHeight + Login.lobby.roomOffset
	Login.lobby.arenasPerRow = math.floor(Login.x / (Login.lobby.roomWidth + Login.lobby.roomOffset + 2 * Login.lobby.arrowWidth))
	Login.lobby.arrowRightPosX = Login.lobby.rowStartX + (Login.lobby.roomWidth * Login.lobby.arenasPerRow + Login.lobby.roomOffset * ( Login.lobby.arenasPerRow - 1 ))

end


function Login.lobbyWindowClose()

	Login.startAnimation(1)

end
addEvent("onLobbyWindowClose", false)


function Login.arenaJoin(arena, isSpectator, ignoreFlood)
	
	if not arena then return end
	
	--if player is already in this arena
	if arena == getElementData(localPlayer, "Arena") then
		
		if not getElementData(localPlayer, "Spectator") and isSpectator then
		
			exports["CCS_notifications"]:export_showNotification("You have to leave this arena first!", "warning")
			return
			
		end
		
		Login.destroy()
		return
		
	end
	
	--join flood
	if not ignoreFlood and (Login.joinLock or getTickCount() - Login.joinFloodLock < Login.joinFloodInterval) then 
	
		exports["CCS_notifications"]:export_showNotification("Join flood! Please wait 5 seconds!", "warning")
		return
		
	end
	
	Login.joinFloodLock = getTickCount()
	
	--arena full and not joining as spectator
	if not isSpectator and #getPlayersInArena(getElementByID(arena)) >= getElementData(getElementByID(arena), "maxplayers") then
		
		exports["CCS_notifications"]:export_showNotification("Arena is full!", "error")
		return
		
	elseif isSpectator and #getPlayersInArena(getElementByID(arena)) == 0 then
	
		exports["CCS_notifications"]:export_showNotification("Arena is empty!", "error")
		return
		
	elseif getElementData(localPlayer, "Arena") ~= "Lobby" then
		
		Login.arenaLeave()
		
	end
	
	Login.destroy()
	setFPSLimit(53)
	Login.lobby.playerInLobby = false
	Login.joinLock = true
	Login.loadingScreen = LoadingScreen.new()
	triggerServerEvent("onJoinArena", localPlayer, arena, isSpectator)
	addEventHandler("onClientLobbyKick", root, Login.lobbyKick)
	
end
addEvent("onArenaSelect", true)


function Login.joinComplete()

	bindKey("F1", "down", Login.toggle)
	Login.joinLock = false

end
addEvent("onClientPlayerJoinArena", true)
addEventHandler("onClientPlayerJoinArena", localPlayer, Login.joinComplete)


function Login.leaveComplete()

	Login.joinLock = false

end
addEvent("onClientPlayerLeaveArena", true)
addEventHandler("onClientPlayerLeaveArena", localPlayer, Login.leaveComplete)


function Login.disableLoadingScreen()
	
	if Login.loadingScreen then 
	
		Login.loadingScreen:destroy()
		Login.loadingScreen = nil
		
	end

end
addEvent("onClientPlayerReady", true)
addEventHandler("onClientPlayerReady", localPlayer, Login.disableLoadingScreen)


function Login.arenaLeave()
	
	setFPSLimit(60)
	Login.disableLoadingScreen()
	Login.lobby.playerInLobby = true
	Login.joinLock = true
	unbindKey("F1", "down", Login.toggle)
	removeEventHandler("onClientLobbyKick", root, Login.lobbyKick)
	triggerEvent("onClientLeaveArena", localPlayer)
	triggerServerEvent("onLeaveArena", localPlayer)
	
end


function Login.lobbyKick(reason)

	Login.disableLoadingScreen()
	
	Login.joinLock = false
	setFPSLimit(60)
	Login.lobby.playerInLobby = true
	Login.joinLock = false
	unbindKey("F1", "down", Login.toggle)
	triggerEvent("onClientLeaveArena", localPlayer)
	removeEventHandler("onClientLobbyKick", root, Login.lobbyKick)
	if not Login.isLobbyActive then Login.toggle() end
	fadeCamera(true)
	
	exports["CCS_notifications"]:export_showNotification(reason, "error")
	
end
addEvent("onClientLobbyKick", true)


function Login.loginResponse(code, error)
	
	if isTimer(Login.timeoutTimer) then killTimer(Login.timeoutTimer) end

	Login.lobby.loginWindow.setEnabled(true)
	
	if code == 1 then
		
		Login.saveSettings()
		triggerServerEvent("onPlayerLoggedIn", localPlayer)
		Login.login.success()
		return
		
	elseif code == -1 and error then
	
		if error == "account in use" then
		
			exports["CCS_notifications"]:export_showNotification("An error has occurred! Account is already in use!", "warning")
		
		
		elseif error == "login invalid" then
		
			exports["CCS_notifications"]:export_showNotification("An error has occurred! Wrong account or password!", "error")
		
		end
	
		return
	
	end

	exports["CCS_notifications"]:export_showNotification("An error has occurred! Please try again!", "error")	
	
end
addEvent("onLoginResponse", true)


function Login.registerResponse(code, error)
	
	if isTimer(Login.timeoutTimer) then killTimer(Login.timeoutTimer) end

	Login.lobby.registerWindow.setEnabled(true)
	
	if code == 1 then
	
		local username = Login.lobby.registerWindow.getUsernameText()
	
		Login.lobby.registerWindow:destroy()
		Login.lobby.registerWindow = nil
		
		Login.lobby.loginWindow.setVisible(true)
		Login.lobby.loginWindow.setUsernameText(username)
		Login.lobby.loginWindow.setPasswordText("")
	
		exports["CCS_notifications"]:export_showNotification("Successfully registered!", "success")
		return
		
	end
	
	if code == -1 and error then
	
		if error == "username empty" then
		
			exports["CCS_notifications"]:export_showNotification("An error has occurred! Username is empty!", "error")
		
		elseif error == "username taken" then
		
			exports["CCS_notifications"]:export_showNotification("An error has occurred! Username is taken!", "error")
	
		elseif error == "email invalid" then
	
			exports["CCS_notifications"]:export_showNotification("An error has occurred! E-Mail is invalid!", "error")
	
		elseif error == "email already in use" then
	
			exports["CCS_notifications"]:export_showNotification("An error has occurred! E-Mail is taken!", "error")
	
		end
	
		return
	
	end

	exports["CCS_notifications"]:export_showNotification("An error has occurred! Please try again!", "error")
	
end
addEvent("onRegisterResponse", true)


function Login.guestResponse(code, error)

	if isTimer(Login.timeoutTimer) then killTimer(Login.timeoutTimer) end

	Login.lobby.loginWindow.setEnabled(true)	
	
	if code == 1 then
	
		Login.login.success()
		triggerServerEvent("onPlayerPlayAsGuest", localPlayer)
		return
		
	end

end
addEvent("onGuestResponse", true)


function Login.logout()

	triggerServerEvent("onPlayerLoggedOut", localPlayer)
	setElementData(localPlayer, "state", "Login")
	setElementData(localPlayer, "Arena", "Lobby")
	setElementData(localPlayer, "account", nil)
	Login.lobby.scroll = 0
	Login.startAnimation(0)
	Login.lobby.loginWindow.setVisible(true)
	Login.lobby.competitive.skillPoints = nil
	
	exports["CCS_notifications"]:export_showNotification("Logging out...", "information")	

end
addEvent("onPlayerLogoutButton")


function Login.loadSettings()
	
	if not fileExists("@settings.xml") then
		
		local settingsXML = xmlCreateFile("@settings.xml", "settings")
		xmlNodeSetAttribute(xmlCreateChild(settingsXML, "username"), "username", "")
		xmlNodeSetAttribute(xmlCreateChild(settingsXML, "password"), "password", "")
		xmlNodeSetAttribute(xmlCreateChild(settingsXML, "settings"), "mode", "SHOW_ALL_ARENAS")
		xmlNodeSetAttribute(xmlFindChild(settingsXML, "settings", 0), "animation", 11)
		xmlNodeSetAttribute(xmlFindChild(settingsXML, "settings", 0), "blur", "false")
		xmlNodeSetAttribute(xmlFindChild(settingsXML, "settings", 0), "ingame", "false")
		xmlNodeSetAttribute(xmlFindChild(settingsXML, "settings", 0), "arenaSize", 1)
		xmlSaveFile(settingsXML)
		xmlUnloadFile(settingsXML)
		
	else
	
		local settingsXML = xmlLoadFile("@settings.xml")
		
		if not settingsXML then return end
		
		local username = xmlFindChild(settingsXML, "username", 0)
	
		if username then

			local password = xmlFindChild(settingsXML, "password", 0)
			
			if password then	
			
				local user = xmlNodeGetAttribute(username, "username")
				local pass = xmlNodeGetAttribute(password, "password")
				Login.lobby.loginWindow.setUsernameText(user)
				Login.lobby.loginWindow.setPasswordText(teaDecode(pass, Login.key))
				Login.lobby.loginWindow.enableRememberCheckbox()

			end
			
		end
		
		local settings = xmlFindChild(settingsXML, "settings", 0)
	
		if settings then
		
			Login.lobby.mode = xmlNodeGetAttribute(settings, "mode")
			Login.lobby.animateMethod = tonumber(xmlNodeGetAttribute(settings, "animation")) or 11
			Login.lobby.blurryBackground = Util.toboolean(xmlNodeGetAttribute(settings, "blur"))
			Login.lobby.ingameBackground = Util.toboolean(xmlNodeGetAttribute(settings, "ingame"))
			Login.lobby.roomSize = tonumber(xmlNodeGetAttribute(settings, "arenaSize")) or 1
		
			Login.adjustArenaSize()
		
			if not Login.lobby.animateMethod or Login.lobby.animateMethod < 1 then
			
				Login.lobby.animateMethod = 11
				
			end
		
		end
		
		xmlUnloadFile(settingsXML)
		
	end
	
end


function Login.saveSettings()

	local settingsXML = xmlLoadFile("@settings.xml")
	
	if not settingsXML then return end

	if Login.login.loginData[3] then
		
		local username = xmlFindChild(settingsXML, "username", 0)
		local password = xmlFindChild(settingsXML, "password", 0)	
		xmlNodeSetAttribute(username, "username", Login.login.loginData[1])
		xmlNodeSetAttribute(password, "password", teaEncode(Login.login.loginData[2], Login.key))
		
	end
	
	local settings = xmlFindChild(settingsXML, "settings", 0)

	if settings then
		
		xmlNodeSetAttribute(settings, "mode", Login.lobby.mode)
		xmlNodeSetAttribute(settings, "animation", Login.lobby.animateMethod)
		xmlNodeSetAttribute(settings, "blur", tostring(Login.lobby.blurryBackground))
		xmlNodeSetAttribute(settings, "ingame", tostring(Login.lobby.ingameBackground))
		xmlNodeSetAttribute(settings, "arenaSize", tostring(Login.lobby.roomSize))
	
	end
	
	xmlSaveFile(settingsXML)
	xmlUnloadFile(settingsXML)

end
