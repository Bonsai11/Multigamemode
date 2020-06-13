SettingsWindow = {}
SettingsWindow.x, SettingsWindow.y = guiGetScreenSize()
SettingsWindow.width = 400
SettingsWindow.height = 500
SettingsWindow.posX = SettingsWindow.x / 2 - SettingsWindow.width / 2
SettingsWindow.posY = SettingsWindow.y / 2 - SettingsWindow.height / 2

function SettingsWindow.new(animationX)

    local self = {}
	
	SettingsWindow.posX = SettingsWindow.posX + animationX
	self.window = guiCreateWindow ( SettingsWindow.posX, SettingsWindow.posY, SettingsWindow.width, SettingsWindow.height, "Settings", false)
	guiWindowSetSizable(self.window, false)
	guiWindowSetMovable(self.window, false)
	
	self.titleLabel = guiCreateLabel(0.05, 0.07, 0.9, 0.15, "Available settings:", true, self.window)	
	guiLabelSetHorizontalAlign(self.titleLabel, "center")	
		
	self.showAllArenas = guiCreateCheckBox(0.05, 0.14, 0.9, 0.05, "Show all Arenas", false, true, self.window)	
	
	self.animationLabel = guiCreateLabel(0.05, 0.21, 0.4, 0.15, "Animation Style:", true, self.window)	
	self.animationMethod = guiCreateComboBox ( 0.35, 0.21, 0.5, 0.3, "Animation Style", true, self.window)
	
	for i = 1, 17, 1 do
		guiComboBoxAddItem ( self.animationMethod, i )
	end
	
	self.blurryBackground = guiCreateCheckBox(0.05, 0.28, 0.9, 0.05, "Blurry Background", false, true, self.window)		
	
	self.ingameBackground = guiCreateCheckBox(0.05, 0.35, 0.9, 0.05, "Show game Background", false, true, self.window)		
	
	self.arenaSize = {}
	self.arenaSizeLabel = guiCreateLabel(0.05, 0.42, 0.9, 0.05, "Arena size:", true, self.window)	
	self.arenaSize[1] = guiCreateRadioButton(0.25, 0.47, 0.9, 0.05, "Small", true, self.window)
	self.arenaSize[2] = guiCreateRadioButton(0.25, 0.53, 0.9, 0.05, "Medium", true, self.window)
	self.arenaSize[3] = guiCreateRadioButton(0.25, 0.58, 0.9, 0.05, "Big", true, self.window)
	
	self.saveButton = guiCreateButton( 0.25, 0.925, 0.2, 0.05, "Save", true, self.window)	
	self.closeButton = guiCreateButton( 0.55, 0.925, 0.2, 0.05, "Close", true, self.window)
	
	guiSetVisible(self.window, false)
	
	function self.setVisible(state)
	
		guiSetVisible(self.window, state)
		
	end
	
	function self.isVisible()
	
		return guiGetVisible(self.window)
	
	end
	
	function self.setAnimationPosition(x)
	
		guiSetPosition(self.window, x + SettingsWindow.posX, SettingsWindow.posY, false)
	
	end
	
	function self.loadSettings(showAllArenas, animationStyle, blurryBackground, ingameBackground, arenaSize)
		
		if showAllArenas then
			
			guiCheckBoxSetSelected(self.showAllArenas, true)
			
		end			
	
		guiComboBoxSetSelected(self.animationMethod, animationStyle - 1)
	
		if blurryBackground then
		
			guiCheckBoxSetSelected(self.blurryBackground, true)
			
		end
	
		if ingameBackground then
		
			guiCheckBoxSetSelected(self.ingameBackground, true) 
			
		end
	
		guiRadioButtonSetSelected(self.arenaSize[arenaSize], true)
	
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
		
			triggerEvent ( "onLobbyWindowClose", localPlayer )
			
		elseif source == self.saveButton then
		
			local showAllArenas = guiCheckBoxGetSelected(self.showAllArenas)
			local animationStyle = guiComboBoxGetSelected(self.animationMethod) + 1
			local blurryBackground = guiCheckBoxGetSelected(self.blurryBackground)
			local ingameBackground = guiCheckBoxGetSelected(self.ingameBackground)
			
			local arenaSize
			
			if guiRadioButtonGetSelected(self.arenaSize[1]) then
			
				arenaSize = 1
				
			elseif guiRadioButtonGetSelected(self.arenaSize[2]) then
			
				arenaSize = 2
			
			elseif guiRadioButtonGetSelected(self.arenaSize[3]) then
			
				arenaSize = 3
			
			end
			
			triggerEvent ( "onLobbyWindowClose", localPlayer )
			triggerEvent ( "onLobbySettingsChange", localPlayer, showAllArenas, animationStyle, blurryBackground, ingameBackground, arenaSize)
			exports["CCS_notifications"]:export_showNotification("Settings saved successfully!", "success")
	
		end
	
	end
	addEventHandler("onClientGUIClick", root, self.click)
	
	return self
	
end