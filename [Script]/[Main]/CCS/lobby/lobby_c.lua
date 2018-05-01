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

--Login
Login.login = {}
	
Login.lobby = {}
Login.lobby.renderTargetWidth = Login.x
Login.lobby.renderTargetHeight = Login.y * 0.75
Login.lobby.renderTarget = dxCreateRenderTarget(Login.lobby.renderTargetWidth, Login.lobby.renderTargetHeight, true)
dxSetTextureEdge(Login.lobby.renderTarget, "border")
Login.lobby.postGui = false
Login.lobby.scroll = 0
Login.lobby.scrollValue = 30
Login.lobby.rows = {{tag = "All", name = "All Arenas", index = 1}, {tag = "Race", name = "Race", index = 1}, {tag = "Fun", name = "Fun", index = 1}, {tag = "Custom", name = "Custom Arenas", index = 1, creatable = true}, {tag = "Clan", name = "Clan Arenas", index = 1}, {tag = "Misc", name = "Misc", index = 1}}
Login.lobby.entries = {}
Login.lobby.roomWidth = 210 * Login.relY
Login.lobby.roomHeight = 120 * Login.relY
Login.lobby.screenSource = dxCreateScreenSource ( Login.lobby.roomWidth, Login.lobby.roomHeight )
Login.lobby.roomDetailFont = "default-bold"
Login.lobby.roomDetailTextOffset = 5 * Login.relY
Login.lobby.roomDetailNameFontSize = 1
Login.lobby.roomDetailNameHeight = dxGetFontHeight(Login.lobby.roomDetailNameFontSize, Login.lobby.roomDetailFont)
Login.lobby.roomDetailHeight = Login.lobby.roomDetailNameHeight * 2 + Login.lobby.roomDetailTextOffset * 2
Login.lobby.roomDetailMapFontSize = 0.9
Login.lobby.roomDetailMapFontColor = tocolor(255, 255, 255, 150)
Login.lobby.roomOffset = 10 * Login.relY
Login.lobby.rowHeaderFontSize = 2
Login.lobby.rowHeaderFont = "default-bold"
Login.lobby.rowHeaderColor = tocolor(255, 255, 255, 255)
Login.lobby.rowHeaderHeight = dxGetFontHeight(Login.lobby.rowHeaderFontSize, Login.lobby.rowHeaderFont) * 1.5
Login.lobby.rowHeight = Login.lobby.rowHeaderHeight + Login.lobby.roomHeight + Login.lobby.roomOffset
Login.lobby.rowOffset = 20 * Login.relY
Login.lobby.arrowWidth = 30 * Login.relY
Login.lobby.arrowHeight = 40 * Login.relY
Login.lobby.arenasPerRow = Login.x > ( ( Login.lobby.roomWidth * 4 + Login.lobby.roomOffset * 3 ) + ( 2 * Login.lobby.arrowWidth ) ) and 4 or 3
Login.lobby.rowStartX = Login.x/2 - (Login.lobby.roomWidth * Login.lobby.arenasPerRow + Login.lobby.roomOffset * ( Login.lobby.arenasPerRow - 1 )) / 2
Login.lobby.arrowRightPosX = Login.lobby.rowStartX + (Login.lobby.roomWidth * Login.lobby.arenasPerRow + Login.lobby.roomOffset * ( Login.lobby.arenasPerRow - 1 ))
Login.lobby.rowStartY = 75 * Login.relY
Login.lobby.arrowLeftPosX = Login.lobby.rowStartX - Login.lobby.arrowWidth
Login.lobby.circleSize = 16
Login.lobby.circleOffset = 3

--Animation
Login.lobby.animating = false
Login.lobby.animationState = 0
Login.lobby.animatedPosX = Login.x
Login.lobby.animationSpeed = 2

--Date/Time
Login.lobby.timeFont = "default-bold"
Login.lobby.timeFontSize = 2.5
Login.lobby.timeFontColor = tocolor(255, 255, 255, 255)
Login.lobby.timePosX = 20 * Login.relX
Login.lobby.timePosY = 10 * Login.relY
Login.lobby.dateFont = "default-bold"
Login.lobby.dateFontSize = 1.2
Login.lobby.dateFontColor = tocolor(255, 255, 255, 255)
Login.lobby.datePosX = 20 * Login.relX
Login.lobby.datePosY = 10 * Login.relY + dxGetFontHeight(Login.lobby.timeFontSize, Login.lobby.timeFont)

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

--Training
Login.lobby.trainingButtonFont = "default-bold"
Login.lobby.trainingButtonFontSize = 1
Login.lobby.trainingButtonFontColor = tocolor(255, 255, 255, 255)
Login.lobby.trainingButtonText = "Training"
Login.lobby.trainingButtonWidth = dxGetTextWidth(Login.lobby.trainingButtonText, Login.lobby.trainingButtonFontSize, Login.lobby.trainingButtonFont) * 1.75
Login.lobby.trainingButtonHeight = dxGetFontHeight(Login.lobby.trainingButtonFontSize, Login.lobby.trainingButtonFont) * 1.75
Login.lobby.trainingButtonOffset = 10 * Login.relY 
Login.lobby.trainingButtonPosX = Login.lobby.leaveButtonPosX - Login.lobby.trainingButtonOffset - Login.lobby.trainingButtonWidth
Login.lobby.trainingButtonPosY = Login.y - Login.lobby.trainingButtonOffset - Login.lobby.trainingButtonHeight
Login.lobby.trainingButtonActive = false

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

--spectate button
Login.lobby.spectateButtonFont = "default-bold"
Login.lobby.spectateButtonFontSize = 1
Login.lobby.spectateButtonFontColor = tocolor(255, 255, 255, 255)
Login.lobby.spectateButtonText = "Spectate"
Login.lobby.spectateButtonWidth = dxGetTextWidth(Login.lobby.spectateButtonText, Login.lobby.spectateButtonFontSize, Login.lobby.spectateButtonFont) * 1.75
Login.lobby.spectateButtonHeight = dxGetFontHeight(Login.lobby.spectateButtonFontSize, Login.lobby.spectateButtonFont) * 1.75
Login.lobby.spectateButtonOffset = 5 * Login.relY
Login.lobby.spectateButtonActive = false

Login.lobby.playerInLobby = true

Login.lobby.createArenaWindow = nil
Login.lobby.passwordWindow = nil
Login.lobby.loginWindow = nil

Login.lobby.challenge = {}
Login.lobby.challenge.arenaElement = nil
Login.lobby.challenge.challengeTime = nil

function Login.start()

	Login.lobby.loginWindow = LoginWindow.new()
	Login.lobby.loginWindow.setVisible(true)
	Login.loadPassword()
	
	--triggerServerEvent("onChallengeRequestInfo", localPlayer)

end
addEventHandler("onClientResourceStart", resourceRoot, Login.start)


function Login.create()

	--Before changing Cursor
	triggerEvent("onClientLobbyEnable", localPlayer)

	addEventHandler("onLoginButtonClick", root, Login.login.loginButtonHandler)
	addEventHandler("onGuestButtonClick", root, Login.login.guestButtonHandler)
	addEventHandler("onClientKey", root, Login.clickHandler)
	addEventHandler("onCreateArenaButton", root, Login.createArena)
	addEventHandler("onPlayerLogoutButton", root, Login.logout)
	addEventHandler("onLoginResponse", root, Login.loginResponse)
	addEventHandler("onGuestResponse", root, Login.guestResponse)
	addEventHandler("onClientRender", root, Login.render, true, "low-99")
	addEventHandler("onArenaSelect", root, Login.arenaJoin)
	addEventHandler("onClientChallengeInfo", root, Login.challenge)		
	Login.isLobbyActive = true
	showChat(false)
	showCursor(true)
	Login.lobby.passwordWindow = PasswordWindow.new()
	Login.lobby.createArenaWindow = ArenaCreateWindow.new()
	
end
addEvent("onShowLogin")
addEventHandler("onShowLogin", root, Login.create)


function Login.destroy()

	showChat(true)
	Login.isLobbyActive = false
	showCursor(false)
	removeEventHandler("onLoginButtonClick", root, Login.login.loginButtonHandler)
	removeEventHandler("onGuestButtonClick", root, Login.login.guestButtonHandler)
	removeEventHandler("onClientKey", root, Login.clickHandler)
	removeEventHandler("onCreateArenaButton", root, Login.createArena)
	removeEventHandler("onPlayerLogoutButton", root, Login.logout)
	removeEventHandler("onArenaSelect", root, Login.arenaJoin)
	removeEventHandler("onLoginResponse", root, Login.loginResponse)
	removeEventHandler("onGuestResponse", root, Login.guestResponse)
	removeEventHandler("onClientRender", root, Login.render)
	removeEventHandler("onClientChallengeInfo", root, Login.challenge)	
	
	if Login.lobby.createArenaWindow then 
	
		Login.lobby.createArenaWindow:destroy()
		Login.lobby.createArenaWindow = nil
		
	end
	
	if Login.lobby.passwordWindow then 
	
		Login.lobby.passwordWindow:destroy()
		Login.lobby.passwordWindow = nil
		
	end
	
	--After changing Cursor
	triggerEvent("onClientLobbyDisable", localPlayer)	
	
end


function Login.render()

    dxDrawImage(0, 0, Login.x, Login.y, Login.backgroundPicture, 0, 0, 0, tocolor( 255, 255, 255, 255), Login.lobby.postGui)

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
	
	if Login.lobby.createArenaWindow and Login.lobby.createArenaWindow.isVisible() then return end
	
	if Login.lobby.passwordWindow and Login.lobby.passwordWindow.isVisible() then return end	
	
	if button == "escape" then
	
		Login.lobby.passwordWindow.setVisible ( false )
		Login.lobby.createArenaWindow.setVisible ( false )
	
	elseif button == "mouse_wheel_up" then
	
		Login.lobby.scroll = Login.lobby.scroll - Login.lobby.scrollValue
		
	elseif button == "mouse_wheel_down" then
	
		Login.lobby.scroll = Login.lobby.scroll + Login.lobby.scrollValue
		
	elseif button == "mouse1" then

		for i, row in pairs(Login.lobby.rows) do
			
			if row.active then

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
							
							if getElementData(entry.arenaElement, "password") and not Login.lobby.spectateButtonActive then
							
								Login.lobby.passwordWindow.setArena(entry.arenaElement)
								Login.lobby.passwordWindow.setVisible ( true )
							
							else
							
								local arenaID = getElementID(entry.arenaElement)
								Login.arenaJoin(arenaID, Login.lobby.spectateButtonActive)
								break
							
							end
							
						elseif entry.type == "plus" then
						
							Login.lobby.createArenaWindow.setVisible ( true )
							break
	
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
		
	end
	
	local totalRows = 0
	
	for i, row in pairs(Login.lobby.rows) do
	
		if #Login.lobby.entries[row.tag] > 0 then
		
			totalRows = totalRows + 1
		
		end
	
	end

	if Login.lobby.scroll < 0 then
	
		Login.lobby.scroll = 0
		
	elseif Login.lobby.scroll > (totalRows * (Login.lobby.rowHeight + Login.lobby.rowOffset )) - Login.lobby.renderTargetHeight then
		
		Login.lobby.scroll = (totalRows * (Login.lobby.rowHeight + Login.lobby.rowOffset )) - Login.lobby.renderTargetHeight
		
	end
	
end


function Login.animate()

	if Login.lobby.animationState == 0 then
		
		if Login.lobby.animatedPosX > 0 then
		
			Login.lobby.animatedPosX = math.max(0, Login.lobby.animatedPosX - Login.lobby.animationSpeed * Login.delta)
		
			local x, y = Login.lobby.loginWindow.getPosition()
			Login.lobby.loginWindow.setPosition(x + (Login.lobby.animatedPosX - Login.x), y)
		
		else
		
			Login.lobby.animating = false
			Login.lobby.animationState = 1
			Login.lobby.loginWindow.setVisible(false)
		
		end

	elseif Login.lobby.animationState == 1 then
	
		if Login.lobby.animatedPosX < Login.x then
		
			Login.lobby.animatedPosX = math.min(Login.x, Login.lobby.animatedPosX + Login.lobby.animationSpeed * Login.delta)
		
			local x, y = Login.lobby.loginWindow.getPosition()
			Login.lobby.loginWindow.setPosition(x + (Login.lobby.animatedPosX - Login.x), y)
		
		else
		
			Login.lobby.animating = false
			Login.lobby.animationState = 0
			Login.loggedIn = false
		
		end
	
	end
	
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
			
			table.insert(Login.lobby.entries["All"], {type = "arena", arenaElement = arenaElement, active = false})
		
		end
	
	end

	local time = getRealTime()
	
	local dateString = Login.weekdays[time.weekday + 1]..", "..string.format("%02d.%02d.%04d", time.monthday, time.month + 1, time.year + 1900)
	local timeString = string.format("%02d:%02d", time.hour, time.minute)
	
	--Date
	dxDrawText(timeString, Login.lobby.animatedPosX + Login.lobby.timePosX, Login.lobby.timePosY, Login.x, Login.y, Login.lobby.timeFontColor, Login.lobby.timeFontSize, Login.lobby.timeFont, "left", "top", false, false, Login.lobby.postGui)
	dxDrawText(dateString, Login.lobby.animatedPosX + Login.lobby.datePosX, Login.lobby.datePosY, Login.x, Login.y, Login.lobby.dateFontColor, Login.lobby.dateFontSize, Login.lobby.dateFont, "left", "top", false, false, Login.lobby.postGui)

	dxSetRenderTarget(Login.lobby.renderTarget, true) 
	dxSetBlendMode("modulate_add")
	
	local posY = -Login.lobby.scroll
	
	for i, row in pairs(Login.lobby.rows) do
	
		if #Login.lobby.entries[row.tag] > 0 or row.creatable then
		
			local arrowPosY = posY + Login.lobby.rowHeaderHeight + Login.lobby.roomHeight / 2 - Login.lobby.arrowHeight / 2
			
			dxDrawText(row.name, Login.lobby.rowStartX, posY, Login.x, Login.y, Login.lobby.rowHeaderColor, Login.lobby.rowHeaderFontSize, Login.lobby.rowHeaderFont)
		
			if Login.mouseCheck(0, posY + Login.lobby.rowStartY, Login.x, Login.lobby.rowHeight) and Login.mouseCheck(0, Login.lobby.rowStartY, Login.lobby.renderTargetWidth, Login.lobby.renderTargetHeight) then
			
				row.active = true
			
			else
			
				row.active = false
			
			end
		
			if row.creatable then
			
				table.insert(Login.lobby.entries[row.tag], {type = "plus", arenaElement = false, active = false})
			
			end
		
			for j, entry in pairs(Login.lobby.entries[row.tag]) do
				
				if j >= row.index and j <= row.index + Login.lobby.arenasPerRow - 1 then
				
					local posY = posY + Login.lobby.rowHeaderHeight
					local posX = Login.lobby.rowStartX + (Login.lobby.roomWidth + Login.lobby.roomOffset) * (j - row.index)
				
					if Login.mouseCheck(posX, posY + Login.lobby.rowStartY, Login.lobby.roomWidth, Login.lobby.roomHeight) and Login.mouseCheck(0, Login.lobby.rowStartY, Login.lobby.renderTargetWidth, Login.lobby.renderTargetHeight) then
						
						entry.active = true
							
					else
						
						entry.active = false
						
					end
				
					if entry.type == "arena" then
					
						local arenaElement = entry.arenaElement
					
						local name = getElementData(arenaElement, "name")
						local color = {getColorFromString(getElementData(arenaElement, "color"))}
						local current_map = getElementData(arenaElement, "map") and getElementData(arenaElement, "map").name or "No map running"
						local players = getElementData(arenaElement, "players").."/"..getElementData(arenaElement, "maxplayers")
						local detailY = posY + Login.lobby.roomHeight - Login.lobby.roomDetailHeight
						local arenaPicture, picture
						
						if getElementData(arenaElement, "category") == "Custom" then
							
							picture = "custom"
							
						elseif getElementData(arenaElement, "category") == "Clan" then
							
							picture = "clan"
						
						else
						
							picture = name
							
						end
						
						if entry.active then
						
							arenaPicture = "img/lobby/"..picture.."_preview.png"

						else

							arenaPicture = "img/lobby/"..picture..".png"
							
						end
						
						--password
						if getElementData(entry.arenaElement, "password") then
						
							name = name .. " (locked)"
						
						end
						
						if entry.arenaElement == getElementParent(localPlayer) then
						
							dxUpdateScreenSource( Login.lobby.screenSource )
							arenaPicture = Login.lobby.screenSource
						
						end
						
						dxDrawRectangle(posX, posY, Login.lobby.roomWidth, Login.lobby.roomHeight, tocolor(color[1], color[2], color[3], 255))
						dxDrawImage(posX, posY, Login.lobby.roomWidth, Login.lobby.roomHeight - Login.lobby.roomDetailHeight, arenaPicture, 0, 0, 0, tocolor( 255, 255, 255, 255), false)
						dxDrawText(name, posX + Login.lobby.roomDetailTextOffset, detailY + Login.lobby.roomDetailTextOffset, posX + Login.lobby.roomWidth, detailY + Login.lobby.roomDetailHeight, tocolor(255, 255, 255, 255), Login.lobby.roomDetailNameFontSize, Login.lobby.roomDetailFont)
						dxDrawText(current_map, posX + Login.lobby.roomDetailTextOffset, detailY + Login.lobby.roomDetailTextOffset + Login.lobby.roomDetailNameHeight, posX + Login.lobby.roomWidth, detailY + Login.lobby.roomDetailHeight, Login.lobby.roomDetailMapFontColor, Login.lobby.roomDetailMapFontSize, Login.lobby.roomDetailFont)
						dxDrawText(players, posX + Login.lobby.roomDetailTextOffset, detailY + Login.lobby.roomDetailTextOffset, posX + Login.lobby.roomWidth - Login.lobby.roomDetailTextOffset, detailY + Login.lobby.roomDetailHeight - Login.lobby.roomDetailTextOffset, tocolor(255, 255, 255, 255), Login.lobby.roomDetailNameFontSize, Login.lobby.roomDetailFont, "right", "center")
						
						if entry.arenaElement == Login.lobby.challenge.arenaElement then
						
							dxDrawText("#00ff00Challenge: #ffffff"..msToHourMinuteSecond(Login.lobby.challenge.challengeTime - getTickCount()), posX + Login.lobby.roomDetailTextOffset, posY + Login.lobby.roomDetailTextOffset, posX + Login.lobby.roomWidth, posY + Login.lobby.roomHeight, tocolor(255, 255, 255, 255), Login.lobby.roomDetailNameFontSize, Login.lobby.roomDetailFont, "left", "top", false, false, false, true)
						
						end
						
						if entry.active then
							
							if getElementData(entry.arenaElement, "spectators") then
							
								--Spectate
								local spectateButtonPosX = posX + Login.lobby.roomWidth - Login.lobby.spectateButtonWidth - Login.lobby.spectateButtonOffset
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
						
						end
						
					elseif entry.type == "plus" then
					
						local picture = "img/lobby/plus.png"
					
						if entry.active then
						
							picture = "img/lobby/plus_preview.png"
							
						end
					
						dxDrawImage(posX, posY, Login.lobby.roomWidth, Login.lobby.roomHeight, picture, 0, 0, 0, tocolor( 255, 255, 255, 255), false)
						
					end	
						
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
			
			posY = posY + (Login.lobby.rowHeight + Login.lobby.rowOffset)
			
		end
		
	end
	
	dxSetBlendMode("blend")
	dxSetRenderTarget()
	
	dxSetBlendMode("add") 
	dxDrawImage(Login.lobby.animatedPosX, Login.lobby.rowStartY, Login.lobby.renderTargetWidth, Login.lobby.renderTargetHeight, Login.lobby.renderTarget, 0, 0, 0, tocolor(255, 255, 255, 255), Login.lobby.postGui)
	dxSetBlendMode("blend")
	
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
		
end


function Login.mouseCheck(posX, posY, width, height)
	
	local mouseX, mouseY = getCursorPosition()
	mouseX = mouseX * Login.x
	mouseY = mouseY * Login.y

	if mouseX < posX or mouseX > posX + width then return false end

	if mouseY < posY or mouseY > posY + height then return false end

	return true

end


function Login.challenge(time)

	Login.lobby.challenge.arenaElement = source
	Login.lobby.challenge.challengeTime = getTickCount() + time

end
addEvent("onClientChallengeInfo", true)


function Login.login.loginButtonHandler(username, password, remember_me)
	
	if #username:gsub(" ", "") == 0 then
		
		exports["CCS_notifications"]:export_showNotification("Please enter your username!", "warning")
		return
		
	elseif #password:gsub(" ", "") == 0 then

		exports["CCS_notifications"]:export_showNotification("Please enter your password!", "warning")
		return
		
	end
	
	triggerServerEvent("onLogin", localPlayer, username, password, remember_me)
	
	exports["CCS_notifications"]:export_showNotification("Logging in...", "information")
	
	Login.timeoutTimer = setTimer(Login.loginResponse, 10000, 1, 1)
	
end
addEvent("onLoginButtonClick", false)


function Login.login.guestButtonHandler()

	triggerServerEvent("onGuest", localPlayer)

	exports["CCS_notifications"]:export_showNotification("Playing as Guest...", "information")

end
addEvent("onGuestButtonClick", false)


function Login.login.success()
	
	Login.loggedIn = true
	Login.lobby.animating = true
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


function Login.arenaJoin(arena, isSpectator)

	if not arena then return end
	
	if Login.joinLock or getTickCount() - Login.joinFloodLock < Login.joinFloodInterval then 
	
		exports["CCS_notifications"]:export_showNotification("Join flood! Please wait 5 seconds!", "warning")
		return
		
	end
	
	Login.joinFloodLock = getTickCount()
	
	if arena == getElementData(localPlayer, "Arena") then
		
		if not getElementData(localPlayer, "Spectator") and isSpectator then
		
			exports["CCS_notifications"]:export_showNotification("You have to leave this arena first!", "warning")
			return
			
		end
		
		Login.destroy()
		return
		
	elseif getElementData(getElementByID(arena), "players") >= getElementData(getElementByID(arena), "maxplayers") then
		
		exports["CCS_notifications"]:export_showNotification("Arena is full!", "error")
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
	Login.lobby.playerInLobby = true
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
	unbindKey("F1", "down", Login.toggle)
	triggerEvent("onClientLeaveArena", localPlayer)
	removeEventHandler("onClientLobbyKick", root, Login.lobbyKick)
	if not Login.isLobbyActive then Login.toggle() end
	fadeCamera(true)
	
	exports["CCS_notifications"]:export_showNotification("You have been kicked from the arena!", "error")
	
end
addEvent("onClientLobbyKick", true)


function Login.loginResponse(code, remember_me, username, password)
	
	if isTimer(Login.timeoutTimer) then killTimer(Login.timeoutTimer) end

	if code == 0 then
	
		exports["CCS_notifications"]:export_showNotification("Account is already in use!", "warning")
		return
		
	end

	if code == 1 then
	
		exports["CCS_notifications"]:export_showNotification("An error has occurred! Please try again!", "error")
		return
	
	end

	if code == 2 then
	
		exports["CCS_notifications"]:export_showNotification("Wrong account or password!", "error")
		return
		
	end

	if code == 3 then
		
		Login.savePassword(remember_me, username, password)
		--triggerServerEvent("onPlayerLoggedIn", localPlayer)
		Login.login.success()
		return
		
	end

end
addEvent("onLoginResponse", true)


function Login.guestResponse(code)

	if isTimer(Login.timeoutTimer) then killTimer(Login.timeoutTimer) end

	if code == 2 then
	
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
	Login.lobby.animating = true
	Login.lobby.loginWindow.setVisible(true)
	
	exports["CCS_notifications"]:export_showNotification("Logging out...", "information")	

end
addEvent("onPlayerLogoutButton")


function Login.loadPassword()
	
	if not fileExists("@remember.xml") then
		
		local rememberXML = xmlCreateFile("@remember.xml", "remember")
		xmlNodeSetAttribute(xmlCreateChild(rememberXML, "username"), "username", "")
		xmlNodeSetAttribute(xmlCreateChild(rememberXML, "password"), "password", "")
		xmlSaveFile(rememberXML)
		xmlUnloadFile(rememberXML)
		
	else
	
		local rememberXML = xmlLoadFile("@remember.xml")
		
		if not rememberXML then return end
		
		local username = xmlFindChild(rememberXML, "username", 0)
	
		if username then

			local password = xmlFindChild(rememberXML, "password", 0)
			
			if password then	
			
				local user = xmlNodeGetAttribute(username, "username")
				local pass = xmlNodeGetAttribute(password, "password")
				Login.lobby.loginWindow.setPasswordText(teaDecode(pass, Login.key))
				Login.lobby.loginWindow.enableRememberCheckbox()

			end
			
		end
		
		xmlUnloadFile(rememberXML)
		
	end
	
end


function Login.savePassword(remember_me, user, pass)
	
	if remember_me then
		
		local rememberXML = xmlLoadFile("@remember.xml")
		
		if not rememberXML then return end
	
		local username = xmlFindChild(rememberXML, "username", 0)
		local password = xmlFindChild(rememberXML, "password", 0)		
		xmlNodeSetAttribute(username, "username", user)
		xmlNodeSetAttribute(password, "password", teaEncode(pass, Login.key))
		xmlSaveFile(rememberXML)
		xmlUnloadFile(rememberXML)
		
	else
	
		if fileExists("@remember.xml") then
		
			fileDelete("@remember.xml")
			
		end
		
	end
	
end