ClanArenaWindow = {}
ClanArenaWindow.x, ClanArenaWindow.y = guiGetScreenSize()
ClanArenaWindow.width = 400
ClanArenaWindow.height = 500
ClanArenaWindow.posX = ClanArenaWindow.x / 2 - ClanArenaWindow.width / 2
ClanArenaWindow.posY = ClanArenaWindow.y / 2 - ClanArenaWindow.height / 2

function ClanArenaWindow.new(animationX)

    local self = {}
	
	ClanArenaWindow.posX = ClanArenaWindow.posX + animationX	
	self.window = guiCreateWindow ( ClanArenaWindow.posX, ClanArenaWindow.posY, ClanArenaWindow.width, ClanArenaWindow.height, "Request Clan Arena", false)
	guiWindowSetSizable(self.window, false)
	guiWindowSetMovable(self.window, false)
	
	self.titleLabel = guiCreateLabel(0, 0, 1, 1, "Request an arena for your clan on: www.ddc.community", true, self.window)	
	guiLabelSetHorizontalAlign(self.titleLabel, "center")	
	guiLabelSetVerticalAlign(self.titleLabel, "center")
	
	self.closeButton = guiCreateButton( 0.4, 0.925, 0.2, 0.05, "Close", true, self.window)
	guiSetVisible(self.window, false)
	
	function self.setVisible(state)
	
		guiSetVisible(self.window, state)

	end
	
	function self.isVisible()
	
		return guiGetVisible(self.window)
	
	end
	
	function self.setAnimationPosition(x)
	
		guiSetPosition(self.window, x + ClanArenaWindow.posX, ClanArenaWindow.posY, false)
	
	end	
	
	function self.destroy()
	
		destroyElement(self.window)
		removeEventHandler("onClientGUIClick", root, self.click)
		
	end
	
	function self.click()
	
		if source == self.closeButton then
		
			triggerEvent ( "onLobbyWindowClose", localPlayer )	
		end
	
	end
	addEventHandler("onClientGUIClick", root, self.click)
	
	return self
	
end