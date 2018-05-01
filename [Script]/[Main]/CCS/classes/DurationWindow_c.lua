DurationWindow = {}
DurationWindow.x, DurationWindow.y =  guiGetScreenSize()
DurationWindow.relX, DurationWindow.relY =  (DurationWindow.x/800), (DurationWindow.y/600)

DurationWindow.fontSize = 1
DurationWindow.font = "default-bold"
DurationWindow.posY = (10 * DurationWindow.relY)
DurationWindow.rowSize = dxGetFontHeight(DurationWindow.fontSize, DurationWindow.font) * 1.5

--Time left
DurationWindow.timeLeftWidth = dxGetTextWidth(" XXX:XXX:XXX ", DurationWindow.fontSize, DurationWindow.font)
DurationWindow.timeLeftPosX = DurationWindow.x / 2 - DurationWindow.timeLeftWidth - DurationWindow.timeLeftWidth / 8
DurationWindow.timeLeftBackgroundColor = tocolor(0, 0, 0, 100)
DurationWindow.timeLeftColor = tocolor (255, 255, 255, 255)
DurationWindow.timeLeftHighlightColor = tocolor (255, 0, 0, 255)
DurationWindow.timeLeftColorHunter = tocolor (255, 200, 45, 255)
DurationWindow.timeLeftColorCurrent = DurationWindow.timeLeftColor

--Time passed
DurationWindow.timePassedWidth = dxGetTextWidth(" XXX:XXX:XXX ", DurationWindow.fontSize, DurationWindow.font)
DurationWindow.timePassedPosX = DurationWindow.x / 2 + DurationWindow.timeLeftWidth / 8
DurationWindow.timePassedBackgroundColor = tocolor(0, 0, 0, 100)
DurationWindow.timePassedColor = tocolor (255, 255, 255, 255)

DurationWindow.active = false
DurationWindow.timerDuration = nil
DurationWindow.timerStartTime = nil
DurationWindow.timerEndTime = nil
DurationWindow.timerPassed = 0
DurationWindow.timerLeft = 0

DurationWindow.show = true

function DurationWindow.create(duration, passed)

	if not duration then return end
	
	DurationWindow.timerDuration = duration
	
	if getElementData(source, "state") == "In Progress" then
	
		DurationWindow.timerPassed = passed
		DurationWindow.start()
		
	else
	
		DurationWindow.timerPassed = 0
		DurationWindow.timerLeft = duration
		
	end
	
	addEventHandler("onClientRender", root, DurationWindow.draw)

end
addEvent("onClientPlayerReady", true)
addEventHandler("onClientPlayerReady", root, DurationWindow.create)


function DurationWindow.start()

	DurationWindow.timerStartTime = getTickCount() - DurationWindow.timerPassed
	DurationWindow.timerEndTime = DurationWindow.timerStartTime + DurationWindow.timerDuration
	DurationWindow.active = true
	
end
addEvent("onClientMapStart", true)
addEventHandler("onClientMapStart", root, DurationWindow.start)


function DurationWindow.finish(text, countTime)

	DurationWindow.timerEndTime = getTickCount() + countTime
		
end
addEvent("onClientMapEnding", true)
addEventHandler("onClientMapEnding", root, DurationWindow.finish)

	
function DurationWindow.hunterPickup(isFirst)

	if not isFirst then return end

	DurationWindow.timerEndTime = getTickCount() + 180000
	DurationWindow.timeLeftColorCurrent = DurationWindow.timeLeftColorHunter
	
end
addEvent("onPlayerHunterPickup", true)
addEventHandler("onPlayerHunterPickup", root, DurationWindow.hunterPickup)
	
	
function DurationWindow.draw()

	if not DurationWindow.show then return end

	local arenaElement = getElementParent(localPlayer)
	
	--map
	if getElementData(arenaElement, "map") then
	
		local mapText = "\n"..getElementData(arenaElement, "map").name

		if #getElementData(arenaElement, "nextmap") > 0 then
	
			mapText = mapText.."\n\nNext:"
	
			for i, map in pairs(getElementData(arenaElement, "nextmap")) do
			
				mapText = mapText.."\n"..map.name
				
			end	
		
		end
		
		dxDrawText(mapText, 1, DurationWindow.posY + DurationWindow.rowSize + 1, DurationWindow.x+1, DurationWindow.y+1, tocolor(0, 0, 0), 1, "default-bold", "center", "top", true, true, false, false, false )
		dxDrawText(mapText, 0, DurationWindow.posY + DurationWindow.rowSize, DurationWindow.x, DurationWindow.y, tocolor(255, 255, 255), 1, "default-bold", "center", "top", true, true, false, false, false )

	end

	if DurationWindow.active then
		
		if getTickCount() < DurationWindow.timerEndTime then
		
			DurationWindow.timerPassed = getTickCount() - DurationWindow.timerStartTime
			DurationWindow.timerLeft = DurationWindow.timerEndTime - getTickCount()
		
		else
		
			DurationWindow.timerLeft = 0
			
		end
		
	end
	
	if DurationWindow.timerLeft < 30000 then
	
		DurationWindow.timeLeftColorCurrent = DurationWindow.timeLeftHighlightColor
		
	end
	
	dxDrawRectangle(DurationWindow.timePassedPosX, DurationWindow.posY, DurationWindow.timePassedWidth, DurationWindow.rowSize, DurationWindow.timePassedBackgroundColor)
	dxDrawRectangle(DurationWindow.timeLeftPosX, DurationWindow.posY, DurationWindow.timeLeftWidth, DurationWindow.rowSize, DurationWindow.timeLeftBackgroundColor)		
	
	dxDrawText(exports["CCS"]:export_msToTime(DurationWindow.timerPassed), DurationWindow.timePassedPosX+1, DurationWindow.posY+1, DurationWindow.timePassedPosX + DurationWindow.timePassedWidth+1, DurationWindow.posY + DurationWindow.rowSize+1, tocolor ( 0, 0, 0, 255 ), DurationWindow.fontSize, DurationWindow.font, "center", "center", false, false, false, false, false )
	dxDrawText(exports["CCS"]:export_msToTime(DurationWindow.timerPassed), DurationWindow.timePassedPosX, DurationWindow.posY, DurationWindow.timePassedPosX + DurationWindow.timePassedWidth, DurationWindow.posY + DurationWindow.rowSize, DurationWindow.timePassedColor, DurationWindow.fontSize, DurationWindow.font, "center", "center", false, false, false, false, false )
	
	dxDrawText(exports["CCS"]:export_msToTime(DurationWindow.timerLeft), DurationWindow.timeLeftPosX+1, DurationWindow.posY+1, DurationWindow.timeLeftPosX + DurationWindow.timeLeftWidth+1, DurationWindow.posY + DurationWindow.rowSize+1, tocolor ( 0, 0, 0, 255 ), DurationWindow.fontSize, DurationWindow.font, "center", "center", false, false, false, false, false )
	dxDrawText(exports["CCS"]:export_msToTime(DurationWindow.timerLeft), DurationWindow.timeLeftPosX, DurationWindow.posY, DurationWindow.timeLeftPosX + DurationWindow.timeLeftWidth, DurationWindow.posY + DurationWindow.rowSize, DurationWindow.timeLeftColorCurrent, DurationWindow.fontSize, DurationWindow.font, "center", "center", false, false, false, false, false )
	
end


function DurationWindow.reset()

	removeEventHandler("onClientRender", root, DurationWindow.draw)
	DurationWindow.active = false
	DurationWindow.timerDuration = nil
	DurationWindow.timerStartTime = nil
	DurationWindow.timerEndTime = nil
	DurationWindow.timerPassed = 0
	DurationWindow.timerLeft = 0
	DurationWindow.timePassedHighLightStartTime = 0
	DurationWindow.timeLeftColorCurrent = DurationWindow.timeLeftColor

end	
addEvent("onClientArenaReset", true)
addEventHandler("onClientArenaReset", root, DurationWindow.reset)


function DurationWindow.toggle()

	DurationWindow.show = not DurationWindow.show

end
addCommandHandler("showdurationwindow", DurationWindow.toggle)