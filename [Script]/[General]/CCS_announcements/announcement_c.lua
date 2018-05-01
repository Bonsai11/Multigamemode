Announcement = {}
Announcement.x, Announcement.y = guiGetScreenSize()
Announcement.relX, Announcement.relY =  (Announcement.x/800), (Announcement.y/600)

--GUI Settings
Announcement.font = "default-bold"
Announcement.fontSize = 1
Announcement.width = Announcement.x
Announcement.height = dxGetFontHeight(Announcement.fontSize, Announcement.font) * 1.5
Announcement.posX = 0
Announcement.posY = Announcement.y - Announcement.height
Announcement.color = tocolor(0, 0, 0, 155)
Announcement.postGui = false
Announcement.messageOffset = 100 * Announcement.relX
Announcement.timer = nil
Announcement.show = true

--Other settings
Announcement.list = {}
Announcement.speed = 0.10
Announcement.mode = "dynamic"

--Ads
Announcement.adsList = {"You can chat with players in other Arenas using 'g' for global chat.",
						"You can turn on/off the radar by typing /showradar",
						"Hold F6 to show the full rankingboard.",
						"Press 'c' for Clan Chat.",
						"Please mind that using shortcuts is forbidden.",
						"Use /create to create a group chat.",
						"Use /leave to leave the language chat.",
						"Use /join <Language> to join a language chat.",
						"Press 'x' for group chat.",
						"Use /leavegroup to leave a group chat.",
						"Press 'l' for Language Chat.",
						"English ONLY in global chat.",
						"Press 'r' to reply to a personal message.",
						"Use /invite <name> to invite a player to your group chat.",
						"Use /remove <name> to remove a player from your group chat."
						}
Announcement.adsInterval = 30000
Announcement.adsCurrentID = 1

--FPS
Announcement.delta = 0
Announcement.lastTick = nil

--state
Announcement.active = false

function Announcement.main(arenaElement)

	triggerServerEvent("onAnnouncementRequest", localPlayer)

	Announcement.active = true
	
	addEventHandler("onClientRender", root, Announcement.render)
	
	Announcement.timer = setTimer(Announcement.createAd, Announcement.adsInterval, 0)

end
addEvent("onClientPlayerJoinArena", true)
addEventHandler("onClientPlayerJoinArena", localPlayer, Announcement.main)


function Announcement.destroy(arenaElement)

	Announcement.active = false

	if isTimer(Announcement.timer) then killTimer(Announcement.timer) end

	removeEventHandler("onClientRender", root, Announcement.render)
	
	Announcement.list = {}
	
	Announcement.mode = "dynamic"
	
end
addEvent("onClientPlayerLeaveArena", true)
addEventHandler("onClientPlayerLeaveArena", localPlayer, Announcement.destroy)


function Announcement.createAd()

	if Announcement.mode == "static" then return end

	if Announcement.adsCurrentID > #Announcement.adsList then
	
		Announcement.adsCurrentID = 1
		
	end
	
	local newAd = Announcement.adsList[Announcement.adsCurrentID]
	
	Announcement.create(newAd, false)
	
	Announcement.adsCurrentID = Announcement.adsCurrentID + 1
		
end


function Announcement.create(message, override)

	if override then
	
		Announcement.list = {}
		
	end
	
	table.insert(Announcement.list, {text = message, width = dxGetTextWidth(message, Announcement.fontSize, Announcement.font, true), currentX = Announcement.x})
	
end


function Announcement.new(mode, message, override)

	if Announcement.mode ~= mode then
	
		override = true
	
	end

	Announcement.mode = mode

	Announcement.create(message, override)

end
addEvent("onClientAnnouncementCreate", true)
addEventHandler("onClientAnnouncementCreate", root, Announcement.new)


function Announcement.reset()

	Announcement.list = {}
	
	Announcement.mode = "dynamic"

end
addEvent("onClientAnnouncementReset", true)
addEventHandler("onClientAnnouncementReset", root, Announcement.reset)


function Announcement.render()
	
	if not Announcement.show then return end
	
	if Announcement.lastTick then
	
		Announcement.delta = getTickCount() - Announcement.lastTick
		Announcement.delta = math.min(Announcement.delta, (1/60)*1000)
		
	end
	
	Announcement.lastTick = getTickCount()
	
	dxDrawRectangle(Announcement.posX, Announcement.posY, Announcement.width, Announcement.height, Announcement.color, Announcement.postGui)
	dxDrawLine(Announcement.posX, Announcement.posY, Announcement.posX + Announcement.width, Announcement.posY, tocolor(255, 255, 255, 150), 1, Announcement.postGui)
	
	if not Announcement.active then return end
	
	if Announcement.mode == "dynamic" then
	
		for i, message in pairs(Announcement.list) do
			
			if (i-1 > 0 and Announcement.list[i-1].currentX + Announcement.list[i-1].width + Announcement.messageOffset < Announcement.x) or i == 1 then 
		
				dxDrawText(message.text, message.currentX, Announcement.posY, message.currentX + Announcement.width, Announcement.posY + Announcement.height, tocolor(255,255,255,255), Announcement.fontSize, Announcement.font, "left", "center", false, false, Announcement.postGui, true, false)
				
				message.currentX = message.currentX - (Announcement.speed * Announcement.delta)
			
				if message.currentX + message.width < 0 then
			
					table.remove(Announcement.list, i)
				
				end
		
			end
		
		end
		
	elseif Announcement.mode == "static" then
	
		local message = Announcement.list[1]
	
		dxDrawText(message.text, 0, Announcement.posY, Announcement.width, Announcement.posY + Announcement.height, tocolor(255,255,255,255), Announcement.fontSize, Announcement.font, "center", "center", false, false, Announcement.postGui, true, false)
		
	end

end

function Announcement.toggle()

	Announcement.show = not Announcement.show

end
addCommandHandler("showannouncement", Announcement.toggle)
