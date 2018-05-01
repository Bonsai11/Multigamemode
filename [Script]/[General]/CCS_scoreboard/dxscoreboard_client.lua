-- THESE CAN BE CHANGED
triggerKey = "tab" -- default button to open/close scoreboard
settingsKey = "F7" -- default button to open the settings window
drawOverGUI = true -- draw scoreboard over gui?
seperationSpace = 80 -- the space between top/bottom screen and scoreboard top/bottom in pixels

-- BUT DON'T TOUCH THESE
scoreboardToggled = false
scoreboardForced = false
scoreboardDrawn = false
forceScoreboardUpdate = false
useAnimation = false
scoreboardIsToggleable = false
showServerInfo = false
showGamemodeInfo = false
showTeams = true
useColors = true
drawSpeed = 2
scoreboardScale = 1
teamHeaderFont = "default-bold"
contentFont = "default-bold"
columnFont = "default-bold"
serverInfoFont = "default"
rmbFont = "clear"
cBlack = tocolor( 0, 0, 0 )
cWhite = tocolor( 255, 255, 255 )
cSettingsBox = tocolor( 255, 255, 255, 150 )
MAX_PRIRORITY_SLOT = 500

scoreboardColumns = {}
resourceColumns = {}
scoreboardDimensions = { ["width"] = 0, ["height"] = 0, ["phase"] = 1, ["lastSeconds"] = 0 }
scoreboardTicks = { ["lastUpdate"] = 0, ["updateInterval"] = 500 }
scoreboardContent = {}
firstVisibleIndex = 1
sortBy = { ["what"] = "__NONE__", ["dir"] = -1 } -- -1 = dec, 1 = asc
sbOutOffset, sbInOffset = 1, 1
sbFont = "clear"
sbFontScale = 0.68
serverInfo = {}
fontScale = { -- To make all fonts be equal in height
	["default"] = 1.0,
	["default-bold"] = 1.0,
	["clear"] = 1.0,
	["arial"] = 1.0,
	["sans"] = 1.0,
	["pricedown"] = 0.5,
	["bankgothic"] = 0.5,
	["diploma"] = 0.5,
	["beckett"] = 0.5
}



addEventHandler( "onClientResourceStart", getResourceRootElement( getThisResource() ), 
	function ( resource )
		cScoreboardBackground = tocolor( 0, 0, 0, 185 )
		cSelection = tocolor( 82, 103, 188, 170 )
		cHighlight = tocolor( 255, 255, 255, 50)
		cHeader = tocolor( 100, 100, 100, 255 )
		cTeam = tocolor( 50, 50, 50, 200 )
		cBorder = tocolor( 255, 255, 255, 50 )
		cServerInfo = tocolor( 150, 150, 150, 255 )
		cContent = tocolor( 255, 255, 255, 255 )
		
		bindKey( triggerKey, "down", "Toggle scoreboard", "1" )
		bindKey( triggerKey, "up", "Toggle scoreboard", "0" )
		bindKey( settingsKey, "down", "Open scoreboard settings", "1" )
	
		scoreboardAddColumn( "id", 30, "ID" )
		scoreboardAddColumn( "name", 150, "Name" )
		scoreboardAddColumn( "team", 80, "Team" )
		scoreboardAddColumn( "Country", 60, "Country" )	
		scoreboardAddColumn( "state", 70, "State" )	
		scoreboardAddColumn( "time", 70, "Local Time" )
		scoreboardAddColumn( "clan", 50, "Clan" )
		scoreboardAddColumn( "fps", 40, "FPS" )
		scoreboardAddColumn( "ping", 40, "Ping" )
		
		addEventHandler( "onClientRender", getRootElement(), drawScoreboard )
		triggerServerEvent( "onClientDXScoreboardResourceStart", getRootElement() )
		triggerServerEvent( "requestServerInfo", getRootElement() )

	end
)


function sendServerInfo( output )
	serverInfo = output
end
addEvent( "sendServerInfo", true )
addEventHandler( "sendServerInfo", getResourceRootElement( getThisResource() ), sendServerInfo )

function toggleScoreboard( _, state )
	state = iif( state == "1", true, false )
	if scoreboardIsToggleable and state then
		scoreboardToggled = not scoreboardToggled
	elseif not scoreboardIsToggleable then
		scoreboardToggled = state
	end
end
addCommandHandler( "Toggle scoreboard", toggleScoreboard )



addCommandHandler( "scoreboard", 
	function ()
		scoreboardToggled = not scoreboardToggled
	end
)

function iif( cond, arg1, arg2 )
	if cond then
		return arg1
	end
	return arg2
end

function doDrawScoreboard( rtPass, onlyAnim, sX, sY )
	if #scoreboardColumns ~= 0 then

		--
		-- In/out animation
		--
		local currentSeconds = getTickCount() / 1000
		local deltaSeconds = currentSeconds - scoreboardDimensions.lastSeconds
		scoreboardDimensions.lastSeconds = currentSeconds
		deltaSeconds = math.clamp( 0, deltaSeconds, 1/25 )
			
		if scoreboardToggled or scoreboardForced then
			local phases = {
				[1] = {
					["width"] 		= s(10),
					["height"] 		= s(5),
					
					["incToWidth"] 	= s(10),
					["incToHeight"] = s(5),
				
					["decToWidth"] 	= 0,
					["decToHeight"] = 0
				},
				[2] = {
					["width"] 	= s(40),
					["height"] 	= s(5),
						
					["incToWidth"] 	= calculateWidth(),
					["incToHeight"] = s(5),
						
					["decToWidth"] 	= s(10),
					["decToHeight"] = s(5)
						
				},
				[3] = {
					["width"] 		= calculateWidth(),
					["height"] 		= s(30),
						
					["incToWidth"] 	= calculateWidth(),
					["incToHeight"] = calculateHeight(),
						
					["decToWidth"] 	= calculateWidth(),
					["decToHeight"] = s(5)
				}
			}
		
			if not useAnimation then
				scoreboardDimensions.width = calculateWidth()
				scoreboardDimensions.height = calculateHeight()
				scoreboardDimensions.phase = #phases
			end
			
			local maxChange = deltaSeconds * 30*drawSpeed
			local maxWidthDiff = math.clamp( -maxChange, phases[scoreboardDimensions.phase].incToWidth - scoreboardDimensions.width, maxChange )
			local maxHeightDiff = math.clamp( -maxChange, phases[scoreboardDimensions.phase].incToHeight - scoreboardDimensions.height, maxChange )	
			
			if scoreboardDimensions.width < phases[scoreboardDimensions.phase].incToWidth then
				scoreboardDimensions.width = scoreboardDimensions.width + maxWidthDiff * phases[scoreboardDimensions.phase].width
				if scoreboardDimensions.width > phases[scoreboardDimensions.phase].incToWidth then
					scoreboardDimensions.width = phases[scoreboardDimensions.phase].incToWidth
				end
			elseif scoreboardDimensions.width > phases[scoreboardDimensions.phase].incToWidth and not scoreboardDrawn then
				scoreboardDimensions.width = scoreboardDimensions.width - maxWidthDiff * phases[scoreboardDimensions.phase].width
				if scoreboardDimensions.width < phases[scoreboardDimensions.phase].incToWidth then
					scoreboardDimensions.width = phases[scoreboardDimensions.phase].incToWidth
				end
			end
				
			if scoreboardDimensions.height < phases[scoreboardDimensions.phase].incToHeight then
				scoreboardDimensions.height = scoreboardDimensions.height + maxHeightDiff * phases[scoreboardDimensions.phase].height
				if scoreboardDimensions.height > phases[scoreboardDimensions.phase].incToHeight then
					scoreboardDimensions.height = phases[scoreboardDimensions.phase].incToHeight
				end
			elseif scoreboardDimensions.height > phases[scoreboardDimensions.phase].incToHeight and not scoreboardDrawn then
				scoreboardDimensions.height = scoreboardDimensions.height - maxHeightDiff * phases[scoreboardDimensions.phase].height
				if scoreboardDimensions.height < phases[scoreboardDimensions.phase].incToHeight then
					scoreboardDimensions.height = phases[scoreboardDimensions.phase].incToHeight
				end
			end
				
			if 	scoreboardDimensions.width == phases[scoreboardDimensions.phase].incToWidth and
				scoreboardDimensions.height == phases[scoreboardDimensions.phase].incToHeight then
				if phases[scoreboardDimensions.phase + 1] then
					scoreboardDimensions.phase = scoreboardDimensions.phase + 1
				else
					if not scoreboardDrawn then
						bindKey( "mouse2", "both", showTheCursor )
						bindKey( "mouse_wheel_up", "down", scrollScoreboard, -1 )
						bindKey( "mouse_wheel_down", "down", scrollScoreboard, 1 )
						if not (windowSettings and isElement( windowSettings )) then
							showCursor( false )
						end
						triggerServerEvent( "requestServerInfo", getRootElement() )
					end
					scoreboardDrawn = true
				end
			end
		elseif scoreboardDimensions.width ~= 0 and scoreboardDimensions.height ~= 0 then
			local phases = {
				[1] = {
					["width"] 		= s(10),
					["height"] 		= s(5),
					
					["incToWidth"] 	= s(10),
					["incToHeight"] = s(5),
				
					["decToWidth"] 	= 0,
					["decToHeight"] = 0
				},
				[2] = {
					["width"] 	= s(40),
					["height"] 	= s(5),
						
					["incToWidth"] 	= calculateWidth(),
					["incToHeight"] = s(5),
						
					["decToWidth"] 	= s(10),
					["decToHeight"] = s(5)
						
				},
				[3] = {
					["width"] 		= calculateWidth(),
					["height"] 		= s(30),
						
					["incToWidth"] 	= calculateWidth(),
					["incToHeight"] = calculateHeight(),
						
					["decToWidth"] 	= calculateWidth(),
					["decToHeight"] = s(5)
				}
			}
		
			if scoreboardDrawn then
				unbindKey( "mouse2", "both", showTheCursor )
				unbindKey( "mouse_wheel_up", "down", scrollScoreboard, -1 )
				unbindKey( "mouse_wheel_down", "down", scrollScoreboard, 1 )
				if not (windowSettings and isElement( windowSettings )) then
					showCursor( false )
				end
			end
			scoreboardDrawn = false
			
			if not useAnimation then
				scoreboardDimensions.width = 0
				scoreboardDimensions.height = 0
				scoreboardDimensions.phase = 1
			end
			
			local maxChange = deltaSeconds * 30*drawSpeed
			local maxWidthDiff = math.clamp( -maxChange, scoreboardDimensions.width - phases[scoreboardDimensions.phase].decToWidth, maxChange )
			local maxHeightDiff = math.clamp( -maxChange, scoreboardDimensions.height - phases[scoreboardDimensions.phase].decToHeight, maxChange )
			
			if scoreboardDimensions.width > phases[scoreboardDimensions.phase].decToWidth then
				scoreboardDimensions.width = scoreboardDimensions.width - maxWidthDiff * phases[scoreboardDimensions.phase].width
				if scoreboardDimensions.width < phases[scoreboardDimensions.phase].decToWidth then
					scoreboardDimensions.width = phases[scoreboardDimensions.phase].decToWidth
				end
			elseif scoreboardDimensions.width < phases[scoreboardDimensions.phase].decToWidth then
				scoreboardDimensions.width = scoreboardDimensions.width - maxWidthDiff * phases[scoreboardDimensions.phase].width
				if scoreboardDimensions.width > phases[scoreboardDimensions.phase].decToWidth then
					scoreboardDimensions.width = phases[scoreboardDimensions.phase].decToWidth
				end
			end
				
			if scoreboardDimensions.height > phases[scoreboardDimensions.phase].decToHeight then
				scoreboardDimensions.height = scoreboardDimensions.height - maxHeightDiff * phases[scoreboardDimensions.phase].height
				if scoreboardDimensions.height < phases[scoreboardDimensions.phase].decToHeight then
					scoreboardDimensions.height = phases[scoreboardDimensions.phase].decToHeight
				end
			elseif scoreboardDimensions.height < phases[scoreboardDimensions.phase].decToHeight then
				scoreboardDimensions.height = scoreboardDimensions.height - maxHeightDiff * phases[scoreboardDimensions.phase].height
				if scoreboardDimensions.height > phases[scoreboardDimensions.phase].decToHeight then
					scoreboardDimensions.height = phases[scoreboardDimensions.phase].decToHeight
				end
			end
				
			if 	scoreboardDimensions.width == phases[scoreboardDimensions.phase].decToWidth and
				scoreboardDimensions.height == phases[scoreboardDimensions.phase].decToHeight and
				scoreboardDimensions.width ~= 0 and scoreboardDimensions.height ~= 0 then
				
				scoreboardDimensions.phase = scoreboardDimensions.phase - 1
				if scoreboardDimensions.phase < 1 then scoreboardDimensions.phase = 1 end
			end
		end

		--
		-- Draw scoreboard background
		--
		if (not rtPass or onlyAnim) and scoreboardDimensions.width ~= 0 and scoreboardDimensions.height ~= 0 then
			dxDrawRectangle( (sX/2)-(scoreboardDimensions.width/2), (sY/2)-(scoreboardDimensions.height/2), scoreboardDimensions.width, scoreboardDimensions.height, cScoreboardBackground, drawOverGUI )
		end

		-- Check if anything else to do
		if not scoreboardDrawn or onlyAnim then
			return
		end		

		--
		-- Update the scoreboard content
		--
		local currentTick = getTickCount()
		if (currentTick - scoreboardTicks.lastUpdate > scoreboardTicks.updateInterval and (scoreboardToggled or scoreboardForced)) or forceScoreboardUpdate then
			forceScoreboardUpdate = false
			scoreboardContent = {}
			local index = 1
			
			local sortTableIndex = 1
			local sortTable = {}
			
			
				-- And then the teams
				local teamSortTableIndex = 1
				local teamSortTable = {}
				sortTableIndex = 1
				sortTable = {}
				
				local teams = {}
				
				for i, team in pairs(getElementsByType( "Arena" )) do
				
					if getElementData(team, "inScoreboard") then
				
						table.insert(teams, team)
				
					end
				
				end
				
				for key, team in ipairs( teams ) do

					-- Add teams to sorting table first
					teamSortTable[teamSortTableIndex] = {}	
					for key, column in ipairs( scoreboardColumns ) do
						local content
						if column.name == "name" then
				
							content = getElementData( team, "name" )
							
						else
							content = getElementData( team, column.name ) or ""
							
						end

						teamSortTable[teamSortTableIndex][column.name] = content
						teamSortTable[teamSortTableIndex]["__SCOREBOARDELEMENT__"] = team
					end
					teamSortTableIndex = teamSortTableIndex + 1
					
				
					
					-- and then the players
					sortTableIndex = 1
					sortTable[team] = {}
					
					for key, player in ipairs( getElementsByType("player") ) do
				
						if getElementData(player, "Arena") == getElementData(team, "name") then
						
						sortTable[team][sortTableIndex] = {}
						for key, column in ipairs( scoreboardColumns ) do
							local content
							if column.name == "name" then
								content = getPlayerName( player )
								
								if not getElementData(player, "account") then
								
									content = content.." #ffffff(Guest)"
									
								end	
								
								if getElementData(player, "Spectator") then
								
									content = content.." #ffffff(Spectator)"
									
								end	
								
							elseif column.name == "ping" then
							
								content = getPlayerPing( player )
								
							elseif column.name == "team" then
							
								local team = getPlayerTeam( player )
								
								if team then 
								
									content = getTeamName(team)
									
								else
								
									content = ""
									
								end
								
							elseif column.name == "state" then
							
								if getElementData(player, "racestate") then
								
									content = getElementData(player, "racestate")
									
								else
								
									content = getElementData( player, column.name )
									
								end
								
							else
							
								content = getElementData( player, column.name )
								
							end
							sortTable[team][sortTableIndex][column.name] = content
							sortTable[team][sortTableIndex]["__SCOREBOARDELEMENT__"] = player
							
						end
						sortTableIndex = sortTableIndex + 1
						end
					end
				end				
	
				for key, content in ipairs( teamSortTable ) do
					local team = content["__SCOREBOARDELEMENT__"]
					scoreboardContent[index] = content
					index = index + 1
					
					for key, value in ipairs( sortTable[team] ) do
						scoreboardContent[index] = value
						index = index + 1
					end
				end
				
			end
			scoreboardTicks.lastUpdate = currentTick
		end
		
		--
		-- Draw scoreboard content
		--
		if scoreboardDrawn then
			scoreboardDimensions.height = calculateHeight()
			scoreboardDimensions.width = calculateWidth()
			
			local topX, topY = (sX/2)-(calculateWidth()/2), (sY/2)-(calculateHeight()/2)
			local index = firstVisibleIndex
			local maxPerWindow = getMaxPerWindow()
			
			if firstVisibleIndex > #scoreboardContent-maxPerWindow+1 then
				firstVisibleIndex = 1
			end
			
			if firstVisibleIndex > 1 then 
				dxDrawImage( sX/2-8, topY-15, 17, 11, "arrow.png", 0, 0, 0, cWhite, drawOverGUI )
			end
			if firstVisibleIndex+maxPerWindow <= #scoreboardContent and #scoreboardContent > maxPerWindow then
				dxDrawImage( sX/2-8, topY+scoreboardDimensions.height+4, 17, 11, "arrow.png", 180, 0, 0, cWhite, drawOverGUI )
			end
			
			local y = topY+s(5)
			
			local textLength = dxGetTextWidth( "Hold RMB to enable scrolling/sorting", fontscale(rmbFont, s(0.75)), rmbFont )
			local textHeight = dxGetFontHeight( fontscale(rmbFont, s(0.75)), rmbFont )
			dxDrawText( "Hold RMB to enable scrolling/sorting", sX/2-(textLength/2), topY+scoreboardDimensions.height-textHeight-s(2), sX/2+(textLength/2), topY+scoreboardDimensions.height-s(2), cWhite, fontscale(serverInfoFont, s(0.75)), rmbFont, "left", "top", false, false, drawOverGUI )


			while ( index < firstVisibleIndex+maxPerWindow and scoreboardContent[index] ) do
				local x = s(10)
				local element = scoreboardContent[index]["__SCOREBOARDELEMENT__"]
				local team, player
				
				if element and isElement( element ) and getElementType( element ) == "Arena" then
					dxDrawRectangle( topX+s(5), y, scoreboardDimensions.width-s(10), dxGetFontHeight( fontscale(teamHeaderFont, scoreboardScale), teamHeaderFont ), cTeam, drawOverGUI )
					-- Highlight the the row on which the cursor lies on
					if checkCursorOverRow( rtPass, topX+s(5), topX+scoreboardDimensions.width-s(5), y, y+dxGetFontHeight( fontscale(teamHeaderFont, scoreboardScale), teamHeaderFont ) ) then
						dxDrawRectangle( topX+s(5), y, scoreboardDimensions.width-s(10), dxGetFontHeight( fontscale(teamHeaderFont, scoreboardScale), teamHeaderFont ), cHighlight, drawOverGUI )
					end

					
					for key, column in ipairs( scoreboardColumns ) do
						
						local theX = x
						local content = scoreboardContent[index][column.name]
						
						if content and column.name == "name" then
							theX = x - s(5)
						
							if content then
								if content == "Lobby" or content == "Training" then
								
									dxDrawText( content, topX+theX, y, topX+x+s(column.width), y+dxGetFontHeight( fontscale(teamHeaderFont, scoreboardScale), teamHeaderFont ), 			tocolor( 255, 255, 255, 255 ), fontscale(teamHeaderFont, s(1)), teamHeaderFont, "left", "top", true, false, drawOverGUI, true )
								else
									dxDrawText( content.." ["..getElementData(element, "players" ).."/"..getElementData(element, "maxplayers" ).."]", topX+theX, 		y, 		topX+x+s(column.width), 	y+dxGetFontHeight( fontscale(teamHeaderFont, scoreboardScale), teamHeaderFont ), 			tocolor( 255, 255, 255, 255 ), fontscale(teamHeaderFont, s(1)), teamHeaderFont, "left", "top", true, false, drawOverGUI, true )
								end
							end
							x = x + s(column.width + 10)
						end
						
					end
					
					local font = iif( element and isElement( element ) and getElementType( element ) == "Arena", teamHeaderFont, contentFont )
					y = y + dxGetFontHeight( fontscale(font, scoreboardScale), font )
			local x = s(10)
			for key, column in ipairs( scoreboardColumns ) do
				if x ~= s(10) then
					local height = s(5)
					height = height+s(3)
					dxDrawLine( topX+x-s(5), y+s(1), topX+x-s(5), y+textHeight+s(3), cBorder, s(1), drawOverGUI )
				end
					local _, _, _, a = fromcolor( cHeader )
					dxDrawText( column.friendlyName or "-", topX+x+s(1), 	y+s(1), 	topX+x+s(1+column.width), 	y+s(1)+dxGetFontHeight( fontscale(columnFont, scoreboardScale), columnFont ), tocolor( 0, 0, 0, a ), fontscale(columnFont, s(1)), columnFont, "left", "top", true, false, drawOverGUI )
					dxDrawText( column.friendlyName or "-", topX+x, 	y, 	topX+x+s(column.width), 	y+dxGetFontHeight( fontscale(columnFont, scoreboardScale), columnFont ), cHeader, fontscale(columnFont, s(1)), columnFont, "left", "top", true, false, drawOverGUI )
			
				x = x + s(column.width + 10)
			end
				--dxDrawLine( topX+s(5), y+s(1)+dxGetFontHeight( fontscale(columnFont, scoreboardScale), columnFont ), topX+scoreboardDimensions.width-s(5), y+s(1)+dxGetFontHeight( fontscale(columnFont, scoreboardScale), columnFont ), cBorder, s(1), drawOverGUI )
	
				elseif element and isElement( element ) and getElementType( element ) == "player" then
					-- Highlight local player's name
					if element == getLocalPlayer() then
						dxDrawRectangle( topX+s(5), y, scoreboardDimensions.width-s(10), dxGetFontHeight( fontscale(contentFont, scoreboardScale), contentFont ), cSelection, drawOverGUI )
					end
					-- Highlight the the row on which the cursor lies on
					if checkCursorOverRow( rtPass, topX+s(5), topX+scoreboardDimensions.width-s(5), y, y+dxGetFontHeight( fontscale(contentFont, scoreboardScale), contentFont ) ) then
						dxDrawRectangle( topX+s(5), y, scoreboardDimensions.width-s(10), dxGetFontHeight( fontscale(contentFont, scoreboardScale), contentFont ), cHighlight, drawOverGUI )
					end

						
					for key, column in ipairs( scoreboardColumns ) do
						local theX = x
						local content = scoreboardContent[index][column.name]
						if content then
							if column.name == "ping" then
								b = 0
								if content<=50 then r, g = 0, 255
								elseif content>350 then r, g = 255, 0
								elseif content<=200 then
									r = 255 * (content-50) / 150
									g = 255
								else
									r = 255
									g = 255 - 255 * (content-200) / 150
								end
								dxDrawText( content, topX+theX, y, topX+x+s(column.width), y+dxGetFontHeight( fontscale(contentFont, scoreboardScale), contentFont ), tocolor( r, g, b, 255 ), fontscale(contentFont, s(1)), contentFont, "left", "top", true, false, drawOverGUI, true )
							elseif column.name == "fps" then
								b = 0
								if content>=25 then r, g = 0, 255
								elseif content<=0 then r, g = 255, 0
								elseif content<=12 then
									r = 255
									g = 255 - 255 * (12 - content) / 12
								else
									r = 255 * (12 - content) / 12
									g = 255
								end
								
								dxDrawText( content, topX+theX, y, topX+x+s(column.width), y+dxGetFontHeight( fontscale(contentFont, scoreboardScale), contentFont ), tocolor( r, g, b, 255 ), fontscale(contentFont, s(1)), contentFont, "left", "top", true, false, drawOverGUI, true )
							elseif column.name == "Country" then	
								r = 255
								g = 255
								b = 255
								local c = getElementData(element, 'Country') or 'zz'
								local p = 'img/flags/'..string.lower(c)..'.png'
								if not fileExists(p) then p = 'img/flags/zz.png' end
								dxDrawImage(topX+theX, y+s(1)+1, 16, 11, p, 0, 0, 0, -1, drawOverGUI)
								dxDrawText( content, topX+theX+20, y, topX+x+s(column.width), y+dxGetFontHeight( fontscale(contentFont, scoreboardScale), contentFont ), tocolor( r or 255, g or 255, b or 255, a or 255 ), fontscale(contentFont, s(1)), contentFont, "left", "top", true, false, drawOverGUI )
							elseif column.name == "team" then
								
								local team = getTeamFromName(content)
								
								local r = 255
								local g = 255
								local b = 255
								
								if team then
								
									r, g, b = getTeamColor(team)
									
								end
								
								dxDrawText( content, topX+theX, y, topX+x+s(column.width), y+dxGetFontHeight( fontscale(contentFont, scoreboardScale), contentFont ), tocolor( r, g, b, 255 ), fontscale(contentFont, s(1)), contentFont, "left", "top", true, false, drawOverGUI, true )
							
							else
								r = 255
								g = 255
								b = 255
								dxDrawText( content, topX+theX, y, topX+x+s(column.width), y+dxGetFontHeight( fontscale(contentFont, scoreboardScale), contentFont ), tocolor( r, g, b, 255 ), fontscale(contentFont, s(1)), contentFont, "left", "top", true, false, drawOverGUI, true )
							end
							
					
						end
						x = x + s(column.width + 10)
					end
				end
				
				local font = iif( element and isElement( element ) and getElementType( element ) == "Arena", teamHeaderFont, contentFont )
				y = y + dxGetFontHeight( fontscale(font, scoreboardScale), font )
				index = index + 1
			end
			index = 1
		end
	
end

-- FUNCTIONS
-- addColumn
function scoreboardAddColumn( name, width, friendlyName, priority, textFunction, fromResource )
	if type( name ) == "string" then
		width = width or 70
		friendlyName = friendlyName or name
		priority = tonumber( priority ) or getNextFreePrioritySlot( scoreboardGetColumnPriority( "name" ) )
		fixPrioritySlot( priority )
		textFunction = textFunction or nil
		fromResource = sourceResource or fromResource or nil
		
		if not (priority > MAX_PRIRORITY_SLOT or priority < 1) then
			for key, value in ipairs( scoreboardColumns ) do
				if name == value.name then
					return false
				end
			end
			table.insert( scoreboardColumns, { ["name"] = name, ["width"] = width, ["friendlyName"] = friendlyName, ["priority"] = priority, ["textFunction"] = textFunction } )
			table.sort( scoreboardColumns, function ( a, b ) return a.priority < b.priority end )
			if fromResource then
				if not resourceColumns[fromResource] then resourceColumns[fromResource] = {} end
				table.insert ( resourceColumns[fromResource], name )
			end
			return true
		end
	end
	return false
end

addEvent( "doScoreboardAddColumn", true )
addEventHandler( "doScoreboardAddColumn", getResourceRootElement(),
	function ( name, width, friendlyName, priority, fromResource )
		scoreboardAddColumn( name, width, friendlyName, priority, nil, fromResource )
	end
)


--getColumnPriority
function scoreboardGetColumnPriority( name )
	if type( name ) == "string" then
		for key, value in ipairs( scoreboardColumns ) do
			if name == value.name then
				return value.priority
			end
		end
	end
	return false
end

--setColumnPriority
function scoreboardSetColumnPriority( name, priority )
	if type( name ) == "string" and type( priority ) == "number" then
		if not (priority > MAX_PRIRORITY_SLOT or priority < 1) then
			local columnIndex = false
			for key, value in ipairs( scoreboardColumns ) do
				if name == value.name then
					columnIndex = key
				end
			end
			if columnIndex then
				scoreboardColumns[columnIndex].priority = -1 -- To empty out the current priority
				fixPrioritySlot( priority )
				scoreboardColumns[columnIndex].priority = priority
				table.sort( scoreboardColumns, function ( a, b ) return a.priority < b.priority end )
				return true
			end
		end
	end
	return false
end

addEvent( "doScoreboardSetColumnPriority", true )
addEventHandler( "doScoreboardSetColumnPriority", getResourceRootElement(),
	function ( name, priority )
		scoreboardSetColumnPriority( name, priority )
	end
)

--getColumnCount
function scoreboardGetColumnCount()
	return #scoreboardColumns
end

--setColumnTextFunction
function scoreboardSetColumnTextFunction( name, func )
	if 	type( name ) == "string" then
		for key, value in ipairs( scoreboardColumns ) do
			if name == value.name then
				scoreboardColumns[key].textFunction = func
				return true
			end
		end
	end
	return false
end

function scoreboardGetTopCornerPosition()
	if scoreboardDrawn then
		local sX, sY = guiGetScreenSize()
		local topX, topY = (sX/2)-(calculateWidth()/2), (sY/2)-(calculateHeight()/2)
		topY = topY - 15		-- Extra 15 pixels for the scroll up button
		return math.floor(topX), math.floor(topY+1)
	end
	return false
end

function scoreboardGetSize()
	if scoreboardDrawn then
		local width, height = calculateWidth(), calculateHeight()
		return width, height
	end
	return false
end



-- Other
function calculateWidth()
	local width = 0
	for key, value in ipairs( scoreboardColumns ) do
		width = width + s(value.width + 10)
	end
	return width + s(10)
end

function calculateHeight()
	local sX, sY = guiGetScreenSize()
	local maxPerWindow = getMaxPerWindow()
	local index = firstVisibleIndex
	local height = s(5)
	height = height+s(3)
	height = height+s(5)+dxGetFontHeight( fontscale(rmbFont, s(0.75)), rmbFont )
	height = height+s(2)
	while ( index < firstVisibleIndex+maxPerWindow and scoreboardContent[index] ) do
		local element = scoreboardContent[index]["__SCOREBOARDELEMENT__"]
		if element and isElement( element ) and getElementType( element ) == "Arena" then
			height = height + dxGetFontHeight( fontscale(teamHeaderFont, scoreboardScale), teamHeaderFont ) + dxGetFontHeight( fontscale(columnFont, scoreboardScale), columnFont )
		else
			height = height + dxGetFontHeight( fontscale(contentFont, scoreboardScale), contentFont )
		end
		index = index + 1
	end
	return height
end

function showTheCursor( _, state )
	if state == "down" then
		showCursor( true )
	else
		if not (windowSettings and isElement( windowSettings )) then
			showCursor( false )
		end
	end
end

function scrollScoreboard( _, _, upOrDown )
	if isCursorShowing() then
		local index = firstVisibleIndex
		local maxPerWindow = getMaxPerWindow()
		local highestIndex = #scoreboardContent - maxPerWindow + 1
		if index >= 1 and index <= highestIndex then
			local newIndex = math.max(1,math.min(index + upOrDown * serverInfo.scrollStep,highestIndex))
			if index ~= newIndex then
				firstVisibleIndex = newIndex
				bForceUpdate = true
			end
		end
	end
end

function math.clamp( low, value, high )
	return math.max( low, math.min( value, high ) )
end

function fromcolor( color )
	-- Propably not the most efficient way, but only way it works
	local colorCode = string.format( "%x", color )
	local a = string.sub( colorCode, 1, 2 ) or "FF"
	local r = string.sub( colorCode, 3, 4 ) or "FF"
	local g = string.sub( colorCode, 5, 6 ) or "FF"
	local b = string.sub( colorCode, 7, 8 ) or "FF"
	a = tonumber( "0x" .. a )
	r = tonumber( "0x" .. r )
	g = tonumber( "0x" .. g )
	b = tonumber( "0x" .. b )
	return r, g, b, a
end

function scale( value )
	return value*scoreboardScale
end
s = scale

function fontscale( font, value )
	return value*fontScale[font]
end



function getMaxPerWindow()
	local sX, sY = guiGetScreenSize()
	local availableHeight = sY-(seperationSpace*2)-s(5)
	if (serverInfo.server or serverInfo.players) and showServerInfo then availableHeight = availableHeight-dxGetFontHeight( fontscale(serverInfoFont, scoreboardScale), serverInfoFont ) end
	if (serverInfo.gamemode or serverInfo.map) and showGamemodeInfo then availableHeight = availableHeight-dxGetFontHeight( fontscale(serverInfoFont, scoreboardScale), serverInfoFont ) end
	availableHeight = availableHeight-s(3)
	availableHeight = availableHeight-s(5)-dxGetFontHeight( fontscale(columnFont, scoreboardScale), columnFont )
	availableHeight = availableHeight-s(5)-dxGetFontHeight( fontscale(rmbFont, s(0.75)), rmbFont )
	availableHeight = availableHeight-s(2)
	
	local index = firstVisibleIndex
	local count = 0
	local height = 0
	while ( scoreboardContent[index] ) do
		local element = scoreboardContent[index]["__SCOREBOARDELEMENT__"]
		if element and isElement( element ) and getElementType( element ) == "team" then
			height = height + dxGetFontHeight( fontscale(teamHeaderFont, scoreboardScale), teamHeaderFont )
		else
			height = height + dxGetFontHeight( fontscale(contentFont, scoreboardScale), contentFont )
		end
		if height >= availableHeight then
			return count
		end
		index = index + 1
		count = count + 1
	end
	return count
end





function scoreboardForceUpdate ()
	bForceUpdate = true
	return true
end

