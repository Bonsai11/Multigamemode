LoginWindow = {}
LoginWindow.x, LoginWindow.y = guiGetScreenSize()
LoginWindow.width = 600
LoginWindow.height = 300
LoginWindow.posX = LoginWindow.x / 2 - LoginWindow.width / 2
LoginWindow.posY = LoginWindow.y / 2 - LoginWindow.height / 2

function LoginWindow.new()

    local self = {}
	
	self.window = guiCreateWindow(LoginWindow.posX, LoginWindow.posY, LoginWindow.width, LoginWindow.height, "Drunk Drivers Club", false)
	guiWindowSetMovable(self.window, false)
	guiWindowSetSizable(self.window, false)
	
	self.infoLabelText = "Welcome to Drunk Drivers Club! \n\nWebsite: www.ddc.community\n\n Discord: https://discord.gg/tr74pGR\n\n Have fun!"
	self.infoLabel = guiCreateLabel(0.05, 0, 0.4, 1, self.infoLabelText, true, self.window)
	
	guiSetFont(self.infoLabel, "default-bold-small")
	guiLabelSetHorizontalAlign(self.infoLabel, "center", false)
	guiLabelSetVerticalAlign(self.infoLabel, "center")
	
	self.usernameLabel = guiCreateLabel(0.55, 0.10, 0.25, 0.10, "Username", true, self.window)
	guiSetFont(self.usernameLabel, "default-bold-small")
	guiLabelSetHorizontalAlign(self.usernameLabel, "left", false)
	guiLabelSetVerticalAlign(self.usernameLabel, "center")
	
	self.usernameInput = guiCreateEdit(0.67, 0.1, 0.28, 0.10, "", true, self.window)
	guiEditSetMaxLength(self.usernameInput, 21)
	
	self.passwordLabel = guiCreateLabel(0.55, 0.25, 0.25, 0.10, "Password", true, self.window)
	guiSetFont(self.passwordLabel, "default-bold-small")
	guiLabelSetHorizontalAlign(self.passwordLabel, "left", false)
	guiLabelSetVerticalAlign(self.passwordLabel, "center")
	
	self.passwordInput = guiCreateEdit(0.67, 0.25, 0.28, 0.10, "", true, self.window)
	self.rememberMe = guiCreateCheckBox ( 0.67, 0.35, 0.4, 0.1, "Remember me", false, true, self.window )
	guiEditSetMasked(self.passwordInput, true)
	guiEditSetMaxLength(self.passwordInput, 32)
	
	self.loginButton = guiCreateButton(0.55, 0.50, 0.40, 0.10, "Login", true, self.window)
	guiSetFont(self.loginButton, "default-bold-small")
	guiSetProperty(self.loginButton, "NormalTextColour", "FFFFFFFF")
	
	self.guestButton = guiCreateButton(0.55, 0.62, 0.40, 0.10, "Play as Guest", true, self.window)
	guiSetFont(self.guestButton, "default-bold-small")
	guiSetProperty(self.guestButton, "NormalTextColour", "FFFFFFFF")
	
	guiCreateStaticImage( 0.5, 0.08, 0.002, 0.9, "img/white.png", true, self.window)
	
	self.registerButton = guiCreateButton(0.55, 0.85, 0.40, 0.10, "Register", true, self.window)
	guiSetFont(self.registerButton, "default-bold-small")
	guiSetProperty(self.registerButton, "NormalTextColour", "FFFFFFFF")
	
	guiSetVisible(self.window, false)
	
	function self.setVisible(state)
	
		guiSetVisible(self.window, state)
		
	end
	
	function self.isVisible()
	
		return guiGetVisible(self.window)
	
	end
	
	function self.setAnimationPosition(x)
	
		guiSetPosition(self.window, x - LoginWindow.x + LoginWindow.posX, LoginWindow.posY, false)
	
	end
	
	function self.setEnabled(enabled)
	
		guiSetEnabled(self.window, enabled)
	
	end	
	
	function self.setUsernameText(username)
	
		guiSetText(self.usernameInput, username)
	
	end
	
	function self.setPasswordText(password)
	
		guiSetText(self.passwordInput, password)
	
	end
	
	function self.enableRememberCheckbox()
	
		guiCheckBoxSetSelected(self.rememberMe, true)
	
	end
	
	function self.destroy()
	
		destroyElement(self.window)
		removeEventHandler("onClientGUIClick", root, self.click)

	end
	
	function self.click()
	
		if source == self.loginButton then
		
			local username = guiGetText(self.usernameInput)
			local password = guiGetText(self.passwordInput)
			local remember_me = guiCheckBoxGetSelected(self.rememberMe)
			
			triggerEvent("onLoginButtonClick", localPlayer, username, password, remember_me)
			
		elseif source == self.guestButton then
		
			triggerEvent("onGuestButtonClick", localPlayer, username, password, remember_me)
			
		elseif source == self.registerButton then
		
			triggerEvent("onRegisterButtonClick", localPlayer)
		
		end
	
	
	end
	addEventHandler("onClientGUIClick", root, self.click)
	
	return self
	
end