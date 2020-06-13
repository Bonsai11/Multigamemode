RegisterWindow = {}
RegisterWindow.x, RegisterWindow.y = guiGetScreenSize()
RegisterWindow.width = 300
RegisterWindow.height = 400
RegisterWindow.posX = RegisterWindow.x / 2 - RegisterWindow.width / 2
RegisterWindow.posY = RegisterWindow.y / 2 - RegisterWindow.height / 2

function RegisterWindow.new()

    local self = {}
	
	self.window = guiCreateWindow(RegisterWindow.posX, RegisterWindow.posY, RegisterWindow.width, RegisterWindow.height, "Register", false)
	guiWindowSetMovable(self.window, false)
	guiWindowSetSizable(self.window, false)
	
	self.infoLabelText = "Please enter your details to create an account!"
	self.infoLabel = guiCreateLabel(0.05, 0.1, 0.9, 1, self.infoLabelText, true, self.window)
	
	guiSetFont(self.infoLabel, "default-bold-small")
	guiLabelSetHorizontalAlign(self.infoLabel, "center", false)
	
	self.usernameLabel = guiCreateLabel(0.1, 0.19, 0.25, 0.10, "Username", true, self.window)
	guiSetFont(self.usernameLabel, "default-bold-small")
	guiLabelSetHorizontalAlign(self.usernameLabel, "left", false)
	guiLabelSetVerticalAlign(self.usernameLabel, "center")
	
	self.usernameInput = guiCreateEdit(0.35, 0.20, 0.55, 0.08, "", true, self.window)
	guiEditSetMaxLength(self.usernameInput, 21)
	
	self.passwordLabel = guiCreateLabel(0.1, 0.31, 0.25, 0.10, "Password", true, self.window)
	guiSetFont(self.passwordLabel, "default-bold-small")
	guiLabelSetHorizontalAlign(self.passwordLabel, "left", false)
	guiLabelSetVerticalAlign(self.passwordLabel, "center")
	
	self.passwordInput = guiCreateEdit(0.35, 0.32, 0.55, 0.08, "", true, self.window)
	guiEditSetMaxLength(self.passwordInput, 21)
	guiEditSetMasked(self.passwordInput, true)
	
	self.passwordConfirmInput = guiCreateEdit(0.35, 0.44, 0.55, 0.08, "", true, self.window)
	guiEditSetMaxLength(self.passwordConfirmInput, 21)
	guiEditSetMasked(self.passwordConfirmInput, true)
	
	self.passwordConfirmLabel = guiCreateLabel(0.36, 0.53, 0.9, 1, "(confirm password)", true, self.window)
	guiSetFont(self.passwordConfirmLabel, "default-bold-small")
	
	self.emailLabel = guiCreateLabel(0.1, 0.58, 0.25, 0.10, "E-Mail", true, self.window)
	guiSetFont(self.emailLabel, "default-bold-small")
	guiLabelSetHorizontalAlign(self.emailLabel, "left", false)
	guiLabelSetVerticalAlign(self.emailLabel, "center")

	self.emailInput = guiCreateEdit(0.35, 0.59, 0.55, 0.08, "", true, self.window)
	guiEditSetMaxLength(self.emailInput, 40)
	
	self.registerButton = guiCreateButton(0.10, 0.77, 0.80, 0.08, "Continue", true, self.window)
	guiSetFont(self.registerButton, "default-bold-small")
	guiSetProperty(self.registerButton, "NormalTextColour", "FFFFFFFF")
	
	self.cancelButton = guiCreateButton(0.10, 0.87, 0.80, 0.08, "Cancel", true, self.window)
	guiSetFont(self.cancelButton, "default-bold-small")
	guiSetProperty(self.cancelButton, "NormalTextColour", "FFFFFFFF")
	
	guiSetVisible(self.window, false)
	
	function self.setVisible(state)
	
		guiSetVisible(self.window, state)
		
	end
	
	function self.isVisible()
	
		return guiGetVisible(self.window)
	
	end
	
	function self.getUsernameText()
	
		return guiGetText(self.usernameInput)
	
	end
	
	function self.setEnabled(enabled)
	
		guiSetEnabled(self.window, enabled)
	
	end
	
	function self.destroy()
	
		destroyElement(self.window)
		removeEventHandler("onClientGUIClick", root, self.click)

	end
	
	function self.click()
	
		if source == self.cancelButton then

			triggerEvent("onCancelButtonClick", localPlayer)
		
		elseif source == self.registerButton then
			
			local username = guiGetText(self.usernameInput)
			local password = guiGetText(self.passwordInput)
			local passwordConfirm = guiGetText(self.passwordConfirmInput)
			local email = guiGetText(self.emailInput)
			
			triggerEvent("onContinueButtonClick", localPlayer, username, password, passwordConfirm, email)
			
		end
	
	
	end
	addEventHandler("onClientGUIClick", root, self.click)
	
	return self
	
end