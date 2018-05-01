PasswordWindow = {}
PasswordWindow.x, PasswordWindow.y = guiGetScreenSize()
PasswordWindow.width = 400
PasswordWindow.height = 500

function PasswordWindow.new()

    local self = {}
	
	self.window = guiCreateWindow ( PasswordWindow.x / 2 - PasswordWindow.width / 2, PasswordWindow.y / 2 - PasswordWindow.height / 2, PasswordWindow.width, PasswordWindow.height, "Password", false)
	guiWindowSetSizable(self.window, false)
	guiWindowSetMovable(self.window, false)
	
	self.titleLabel = guiCreateLabel(0.05, 0.1, 0.9, 0.15, "Please enter the password required to join this Arena!", true, self.window)	
	guiLabelSetHorizontalAlign(self.titleLabel, "center")	
	
	self.nameLabel = guiCreateLabel(0.05, 0.20, 0.2, 0.05, "Players:", true, self.window)	
	guiLabelSetVerticalAlign(self.nameLabel, "center")
	guiSetFont(self.nameLabel, "default-bold-small")
	
	self.playerList = guiCreateGridList ( 0.05, 0.25, 0.9, 0.50, true, self.window)
	guiGridListAddColumn ( self.playerList, "Player list", 0.9 )
	
	self.passwordLabel = guiCreateLabel(0.05, 0.80, 0.2, 0.05, "Password:", true, self.window)
	guiLabelSetVerticalAlign(self.passwordLabel, "center")
	self.passwordBox = guiCreateEdit(0.25, 0.80, 0.65, 0.05, "", true, self.window)			
	
	self.joinButton = guiCreateButton( 0.25, 0.925, 0.2, 0.05, "Join", true, self.window)	
	self.closeButton = guiCreateButton( 0.55, 0.925, 0.2, 0.05, "Close", true, self.window)
	
	guiSetVisible(self.window, false)
	
	function self.setVisible(state)
	
		guiSetVisible(self.window, state)

		if state then
		
			for i, p in pairs(getPlayersInArena(self.arenaElement)) do
		 
				local row = guiGridListAddRow(self.playerList)
				guiGridListSetItemText(self.playerList, row, 1, string.gsub(getPlayerName(p), '#%x%x%x%x%x%x', ''), false, false)
				
			end
		
		else
		
			guiGridListClear(self.playerList)
		
		end
		
	end
	
	function self.isVisible()
	
		return guiGetVisible(self.window)
	
	end
	
	function self.destroy()
		
		destroyElement(self.window)
		removeEventHandler("onClientGUIClick", root, self.click)

	end
	
	function self.setArena(arenaElement)
	
		self.arenaElement = arenaElement
	
	end
	
	function self.click()
	
		if source == self.closeButton then
		
			self.setVisible(false)
			
		elseif source == self.joinButton then
		
			self.setVisible(false)
		
			local password = guiGetText(self.passwordBox)
			local arenaID = getElementID(self.arenaElement)
		
			if getElementData(self.arenaElement, "password") == password then
			
				triggerEvent("onArenaSelect", localPlayer, arenaID, false)
			
			else
			
				exports["CCS_notifications"]:export_showNotification("Wrong password!", "error")
			
			end
			
		end
	
	
	end
	addEventHandler("onClientGUIClick", root, self.click)
	
	return self
	
end