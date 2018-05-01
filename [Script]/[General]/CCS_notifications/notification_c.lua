Notifications = {}
Notifications.x, Notifications.y = guiGetScreenSize()
Notifications.minWidth = 120
Notifications.font = "default-bold"
Notifications.fontSize = 1
Notifications.height = dxGetFontHeight(Notifications.fontSize, Notifications.font) * 3
Notifications.offset = 5
Notifications.startPosY = Notifications.offset
Notifications.list = {}
Notifications.life = 3000


function Notifications.create(text, typ)

	local newWidth = 40 + dxGetTextWidth(text, Notifications.fontSize, Notifications.font)
	
	if newWidth < Notifications.minWidth then
	
		newWidth = Notifications.minWidth
		
	end
	
	table.insert(Notifications.list, 1, { message = text, type = typ, time = getTickCount(), width = newWidth, alpha = 255 })

	if typ == "error" then
	
		playSound("sound/error.mp3")
		
	else

		playSound("sound/notify.mp3")

	end
		
end
addEvent("onClientCreateNotification", true)
addEventHandler("onClientCreateNotification", root, Notifications.create)
export_showNotification = Notifications.create


function Notifications.render()

	local tick = getTickCount()

	for i, alert in ipairs(Notifications.list) do
		
		local posY = Notifications.startPosY + (Notifications.height + Notifications.offset) * (i - 1)
		dxDrawImage(Notifications.x - alert.width - 40, posY, 517, Notifications.height, "img/"..alert.type..".png", 0, 0, 0, tocolor(255,255,255, alert.alpha), true)
		
		dxDrawText(alert.message, Notifications.x - alert.width + 1, posY + 1, Notifications.x + 1, posY+Notifications.height + 1, tocolor(0,0,0, alert.alpha), Notifications.fontSize, Notifications.font, "center", "center", false, false, true)
		dxDrawText(alert.message, Notifications.x - alert.width, posY, Notifications.x, posY + Notifications.height, tocolor(255,255,255, alert.alpha), Notifications.fontSize, Notifications.font, "center", "center", false, false, true)
		
		if tick-alert.time > Notifications.life then
		
			alert.alpha = alert.alpha - 2
			
			if alert.alpha < 0 then
			
				table.remove(Notifications.list, #Notifications.list)
				
			end
			
		end
	
	end


end
addEventHandler("onClientRender", root, Notifications.render)