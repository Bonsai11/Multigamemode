ArenaCreateWindow = {}
ArenaCreateWindow.x, ArenaCreateWindow.y = guiGetScreenSize()
ArenaCreateWindow.width = 400
ArenaCreateWindow.height = 500
ArenaCreateWindow.posX = ArenaCreateWindow.x / 2 - ArenaCreateWindow.width / 2
ArenaCreateWindow.posY = ArenaCreateWindow.y / 2 - ArenaCreateWindow.height / 2

function ArenaCreateWindow.new(animationX)

    local self = {}
	
	ArenaCreateWindow.posX = ArenaCreateWindow.posX + animationX	
	self.window = guiCreateWindow ( ArenaCreateWindow.posX, ArenaCreateWindow.posY, ArenaCreateWindow.width, ArenaCreateWindow.height, "Create Arena", false)
	guiWindowSetSizable(self.window, false)
	guiWindowSetMovable(self.window, false)
	
	self.titleLabel = guiCreateLabel(0.05, 0.07, 0.9, 0.15, "Create an arena of your own. Invite\n your friends over and do anything\n you like!", true, self.window)	
	guiLabelSetHorizontalAlign(self.titleLabel, "center")	
	
	self.nameLabel = guiCreateLabel(0.05, 0.20, 0.2, 0.05, "Name:", true, self.window)	
	guiLabelSetVerticalAlign(self.nameLabel, "center")
	self.nameBox = guiCreateEdit(0.30, 0.20, 0.65, 0.05, "", true, self.window)		
	
	self.passwordLabel = guiCreateLabel(0.05, 0.27, 0.2, 0.05, "Password:", true, self.window)	
	guiLabelSetVerticalAlign(self.passwordLabel, "center")
	self.passwordBox = guiCreateEdit(0.30, 0.27, 0.65, 0.05, "", true, self.window)
	guiEditSetMasked(self.passwordBox, true)
	
	self.mapsLabel = guiCreateLabel(0.30, 0.35, 0.2, 0.05, "Maps:", true, self.window)
	self.mapsBoxes = {}
	self.mapsBoxes[1] = guiCreateCheckBox(0.30, 0.40, 0.65, 0.05, "Cross", true, true, self.window)
	self.mapsBoxes[2] = guiCreateCheckBox(0.30, 0.45, 0.65, 0.05, "Classic", true, true, self.window)	
	self.mapsBoxes[3] = guiCreateCheckBox(0.30, 0.50, 0.65, 0.05, "Oldschool", true, true, self.window)	
	self.mapsBoxes[4] = guiCreateCheckBox(0.30, 0.55, 0.65, 0.05, "Modern", true, true, self.window)		
	self.mapsBoxes[5] = guiCreateCheckBox(0.30, 0.60, 0.65, 0.05, "Shooter", true, true, self.window)	
	self.mapsBoxes[6] = guiCreateCheckBox(0.30, 0.65, 0.65, 0.05, "Race", true, true, self.window)		
	self.mapsBoxes[7] = guiCreateCheckBox(0.30, 0.70, 0.65, 0.05, "Hunter", true, true, self.window)	
	self.mapsBoxes[8] = guiCreateCheckBox(0.30, 0.75, 0.65, 0.05, "Linez", true, true, self.window)	
	self.mapsBoxes[9] = guiCreateCheckBox(0.30, 0.80, 0.65, 0.05, "Dynamic", true, true, self.window)	
	self.mapsBoxes[10] = guiCreateCheckBox(0.30, 0.85, 0.65, 0.05, "Maptest", true, true, self.window)
	
	self.featuresLabel = guiCreateLabel(0.7, 0.35, 0.2, 0.05, "Features:", true, self.window)	
	self.featuresBoxes = {}
	self.featuresBoxes[1] = guiCreateCheckBox(0.70, 0.40, 0.65, 0.05, "Spectating", true, true, self.window)
	self.featuresBoxes[2] = guiCreateCheckBox(0.70, 0.45, 0.65, 0.05, "Vehicle mods", true, true, self.window)
	self.featuresBoxes[3] = guiCreateCheckBox(0.70, 0.50, 0.65, 0.05, "CP/TP", false, true, self.window)
	self.featuresBoxes[4] = guiCreateCheckBox(0.70, 0.55, 0.65, 0.05, "WFF Markers", false, true, self.window)
	self.featuresBoxes[5] = guiCreateCheckBox(0.70, 0.60, 0.65, 0.05, "AFK Detector", false, true, self.window)
	self.featuresBoxes[6] = guiCreateCheckBox(0.70, 0.65, 0.65, 0.05, "Ping Checker", false, true, self.window)
	self.featuresBoxes[7] = guiCreateCheckBox(0.70, 0.70, 0.65, 0.05, "FPS Checker", false, true, self.window)	
	self.featuresBoxes[8] = guiCreateCheckBox(0.70, 0.75, 0.65, 0.05, "Rewind", false, true, self.window)	
	
	self.createButton = guiCreateButton( 0.25, 0.925, 0.2, 0.05, "Create", true, self.window)	
	self.closeButton = guiCreateButton( 0.55, 0.925, 0.2, 0.05, "Close", true, self.window)
	guiSetVisible(self.window, false)
	
	function self.setVisible(state)
	
		guiSetVisible(self.window, state)

	end
	
	function self.isVisible()
	
		return guiGetVisible(self.window)
	
	end
	
	function self.setAnimationPosition(x)
	
		guiSetPosition(self.window, x + ArenaCreateWindow.posX, ArenaCreateWindow.posY, false)
	
	end	
	
	function self.destroy()
	
		destroyElement(self.window)
		removeEventHandler("onClientGUIClick", root, self.click)
		
	end
	
	function self.click()
	
		if source == self.closeButton then
		
			triggerEvent ( "onLobbyWindowClose", localPlayer )
			
		elseif source == self.createButton then
		
			local name = guiGetText(self.nameBox)
			local password = guiGetText(self.passwordBox)
			local maps = {}
			
			if #password == 0 then 
			
				password = false
				
			end	
			
			for i, box in ipairs(self.mapsBoxes) do
	
				local map = guiGetText(box)
				local selected = guiCheckBoxGetSelected(box)
				maps[map] = selected
				
			end
			
			local specs = guiCheckBoxGetSelected(self.featuresBoxes[1])
			local afkChecker = guiCheckBoxGetSelected(self.featuresBoxes[2])
			local cptp = guiCheckBoxGetSelected(self.featuresBoxes[3])
			local wff = guiCheckBoxGetSelected(self.featuresBoxes[4])
			local afkChecker = guiCheckBoxGetSelected(self.featuresBoxes[5])
			local ping = guiCheckBoxGetSelected(self.featuresBoxes[6])
			local fps = guiCheckBoxGetSelected(self.featuresBoxes[7])
			local rewind = guiCheckBoxGetSelected(self.featuresBoxes[8])
					
			triggerEvent("onCreateArenaButton", localPlayer, name, password, afkChecker, ping, fps, cptp, wff, specs, rewind, mods, toJSON(maps))
				
		end
	
	
	end
	addEventHandler("onClientGUIClick", root, self.click)
	
	return self
	
end