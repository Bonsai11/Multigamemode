FreeroamWindow = {}
FreeroamWindow.x, FreeroamWindow.y =  guiGetScreenSize()
FreeroamWindow.relX, FreeroamWindow.relY =  (FreeroamWindow.x/800), (FreeroamWindow.y/600)

function FreeroamWindow.new()

	local self = {}

	self.window = guiCreateWindow( 0.2, 0.2, 0.6, 0.6, "Double Click on a Location to spawn!", true )
	self.map = guiCreateStaticImage(0, 0.04, 1, 0.85, "img/map.png", true, self.window)
	
	local mapWidth, mapHeight = guiGetSize(self.map, false)
	local mapX, mapY = guiGetPosition(self.map, false)
	local windowX, windowY = guiGetPosition(self.window, false)
	self.mapX = windowX + mapX
	self.mapY = windowY + mapY
	self.mapScaleX = 6000 / mapWidth
	self.mapScaleY = 6000 / mapHeight
	
	self.vehicleButton = guiCreateButton( 0.03, 0.92, 0.15, 0.05, "Vehicles", true, self.window)
	self.weaponButton = guiCreateButton( 0.19, 0.92, 0.15, 0.05, "Weapons", true, self.window)
	self.upgradeButton = guiCreateButton( 0.35, 0.92, 0.15, 0.05, "Upgrades", true, self.window)
	self.skinButton = guiCreateButton( 0.51, 0.92, 0.15, 0.05, "Skins", true, self.window)
	self.animButton = guiCreateButton( 0.67, 0.92, 0.15, 0.05, "Animation", true, self.window)
	self.jetpackButton = guiCreateButton( 0.83, 0.92, 0.15, 0.05, "Jetpack", true, self.window)
	guiWindowSetSizable(self.window, false)
	guiWindowSetMovable(self.window, false)
	guiSetVisible(self.window, false)
	
	self.vehicleWindow = guiCreateWindow ( 0.35, 0.3, 0.3, 0.4, "Select a Vehicle", true )
	self.vehicleList = guiCreateGridList ( 0, 0.07, 1, 0.8, true, self.vehicleWindow)
	self.vehicleNameColumn = guiGridListAddColumn( self.vehicleList, "Name", 0.9)
	self.createVehicleButton = guiCreateButton( 0.33, 0.90, 0.33, 0.1, "Create", true, self.vehicleWindow)
	guiSetVisible(self.vehicleWindow , false)
	guiWindowSetSizable(self.vehicleWindow , false)
	
	self.weaponWindow = guiCreateWindow ( 0.35, 0.3, 0.3, 0.4, "Select a Weapon", true)
	self.weaponList = guiCreateGridList ( 0, 0.07, 1, 0.8, true, self.weaponWindow)
	self.weaponNameColumn = guiGridListAddColumn( self.weaponList, "Name", 0.9)
	self.giveWeaponButton = guiCreateButton( 0.33, 0.90, 0.33, 0.1, "Give", true, self.weaponWindow)
	guiSetVisible(self.weaponWindow, false)
	guiWindowSetSizable(self.weaponWindow, false)
	
	self.upgradeWindow = guiCreateWindow ( 0.35, 0.3, 0.3, 0.4, "Select an Upgrade", true)
	self.upgradeList = guiCreateGridList ( 0, 0.07, 1, 0.8, true, self.upgradeWindow)
	self.upgradeNameColumn = guiGridListAddColumn( self.upgradeList, "Name", 0.9)
	self.giveUpgradeButton = guiCreateButton( 0.33, 0.90, 0.33, 0.1, "Upgrade", true, self.upgradeWindow)
	guiSetVisible(self.upgradeWindow, false)
	guiWindowSetSizable(self.upgradeWindow, false)
	
	self.skinWindow = guiCreateWindow ( 0.35, 0.3, 0.3, 0.4, "Select a Skin", true)
	self.skinList = guiCreateGridList ( 0, 0.07, 1, 0.8, true, self.skinWindow)
	self.skinNameColumn = guiGridListAddColumn( self.skinList, "Name", 0.9)
	self.giveSkinButton = guiCreateButton( 0.33, 0.90, 0.33, 0.1, "Change", true, self.skinWindow)
	guiSetVisible(self.skinWindow, false)
	guiWindowSetSizable(self.skinWindow, false)
	
	self.animWindow = guiCreateWindow ( 0.35, 0.3, 0.3, 0.4, "Select an Animation", true)
	self.animList = guiCreateGridList ( 0, 0.07, 1, 0.8, true, self.animWindow)
	self.animNameColumn = guiGridListAddColumn( self.animList, "Name", 0.9)
	self.giveAnimButton = guiCreateButton( 0.33, 0.90, 0.33, 0.1, "Animate!", true, self.animWindow)
	guiSetVisible(self.animWindow, false)
	guiWindowSetSizable(self.animWindow, false)
	
	local vehicleXML = xmlLoadFile("conf/vehicles.xml")
	
	for i, m in ipairs(xmlNodeGetChildren(vehicleXML)) do
	
		local row = guiGridListAddRow(self.vehicleList)
		guiGridListSetItemText(self.vehicleList, row, self.vehicleNameColumn, xmlNodeGetAttribute(m, "name"), true, false)
		
		for id, n in ipairs(xmlNodeGetChildren(m)) do
		
			local row = guiGridListAddRow(self.vehicleList)
			
			guiGridListSetItemText(self.vehicleList, row, self.vehicleNameColumn, xmlNodeGetAttribute(n, "name"), false, false)
			guiGridListSetItemData(self.vehicleList, row, self.vehicleNameColumn, xmlNodeGetAttribute(n, "id"))
			
		end
		
	end

	xmlUnloadFile(vehicleXML)	
	
	local weaponXML = xmlLoadFile("conf/weapons.xml")
	
	for id, m in ipairs(xmlNodeGetChildren(weaponXML)) do
	
		local row = guiGridListAddRow(self.weaponList)
		guiGridListSetItemText(self.weaponList, row, self.weaponNameColumn, xmlNodeGetAttribute(m, "name"), true, false)
		
		for id, n in ipairs(xmlNodeGetChildren(m)) do
		
			local row = guiGridListAddRow(self.weaponList)
			guiGridListSetItemText(self.weaponList, row, self.weaponNameColumn, xmlNodeGetAttribute(n, "name"), false, false)
			guiGridListSetItemData(self.weaponList, row, self.weaponNameColumn, xmlNodeGetAttribute(n, "id"))
			
		end
		
	end

	xmlUnloadFile(weaponXML)
	
	local skinXML = xmlLoadFile("conf/skins.xml")
	
	for id, m in ipairs(xmlNodeGetChildren(skinXML)) do
	
		local row = guiGridListAddRow ( self.skinList )
		guiGridListSetItemText(self.skinList, row, self.skinNameColumn, xmlNodeGetAttribute(m, "name"), true, false)
		
		for id, n in ipairs(xmlNodeGetChildren(m)) do
		
			local row = guiGridListAddRow(self.skinList)
			guiGridListSetItemText(self.skinList, row, self.skinNameColumn, xmlNodeGetAttribute(n, "name"), false, false)
			guiGridListSetItemData(self.skinList, row, self.skinNameColumn, xmlNodeGetAttribute(n, "model"))
			
		end
		
	end

	xmlUnloadFile(skinXML)
	
	local animXML = xmlLoadFile("conf/animations.xml")
	
	for id, m in ipairs(xmlNodeGetChildren(animXML)) do
	
		local row = guiGridListAddRow ( self.animList )
		guiGridListSetItemText(self.animList, row, self.animNameColumn, xmlNodeGetAttribute(m, "name"), true, false)
		
		for id, n in ipairs(xmlNodeGetChildren(m)) do
		
			local row = guiGridListAddRow(self.animList)
			guiGridListSetItemText(self.animList, row, self.animNameColumn, xmlNodeGetAttribute(n, "name"), false, false)
			guiGridListSetItemData(self.animList, row, self.animNameColumn, {block = xmlNodeGetAttribute(m, "name"), anim = xmlNodeGetAttribute(n, "name")})
			
		end
		
	end

	xmlUnloadFile(animXML)
	
	function self.setVisible(state)
	
		guiSetVisible(self.window, state)
		showCursor(state)
		
		if state then return end
		
		guiSetVisible(self.vehicleWindow, state)
		guiSetVisible(self.weaponWindow, state)
		guiSetVisible(self.upgradeWindow, state)
		guiSetVisible(self.skinWindow, state)
		guiSetVisible(self.animWindow, state)	
		
	end
	
	function self.isVisible()
	
		return guiGetVisible(self.window)
		
	end

	
	function self.click()
	
		if source == self.vehicleButton then 
		
			guiSetVisible(self.vehicleWindow, true) 
			guiBringToFront(self.vehicleWindow)
			
		elseif source == self.weaponButton then
		
			guiSetVisible(self.weaponWindow, true) 
			guiBringToFront(self.weaponWindow)	
			
		elseif source == self.upgradeButton then
		
			guiGridListClear(self.upgradeList)
			
			if not getPedOccupiedVehicle(localPlayer) then return end
			
			if not getVehicleCompatibleUpgrades(getPedOccupiedVehicle(localPlayer)) then return end
			
			for upgradeKey, upgradeValue in ipairs(getVehicleCompatibleUpgrades(getPedOccupiedVehicle(localPlayer))) do
			
				local row = guiGridListAddRow (self.upgradeList)
				guiGridListSetItemText(self.upgradeList, row, self.upgradeNameColumn, getVehicleUpgradeSlotName(upgradeValue), false, false)
				guiGridListSetItemData(self.upgradeList, row, self.upgradeNameColumn, upgradeValue)
				
			end
			
			guiSetVisible(self.upgradeWindow, true) 
			guiBringToFront(self.upgradeWindow)	
			
		elseif source == self.skinButton then
		
			guiSetVisible(self.skinWindow, true) 
			guiBringToFront(self.skinWindow)
			
		elseif source == self.animButton then
		
			guiSetVisible(self.animWindow, true) 
			guiBringToFront(self.animWindow)
			
		elseif source == self.createVehicleButton then
		
			local row, column =  guiGridListGetSelectedItem(self.vehicleList)
			if row == -1 then return end
			
			local vehicleID = guiGridListGetItemData(self.vehicleList, row, 1)
			
			triggerServerEvent("createNewVehicle", localPlayer, vehicleID)
			guiSetVisible(self.vehicleWindow, false)
			
		elseif source == self.giveWeaponButton then
		
			local row, column =  guiGridListGetSelectedItem(self.weaponList)
			
			if row == -1 then return end
			
			local weaponID = guiGridListGetItemData(self.weaponList, row, 1)
			
			triggerServerEvent("createNewWeapon", localPlayer, weaponID)
			guiSetVisible(self.weaponWindow, false)
			
		elseif source == self.giveUpgradeButton then	
		
			local row, column =  guiGridListGetSelectedItem(self.upgradeList)
			
			if row == -1 then return end
			
			local upgrade = guiGridListGetItemData(self.upgradeList, row, 1)
			triggerServerEvent("addUpgrade", localPlayer, upgrade)		
			guiSetVisible(self.upgradeWindow, false)
			
		elseif source == self.giveSkinButton then	
		
			local row, column =  guiGridListGetSelectedItem(self.skinList)
			
			if row == -1 then return end
			
			local skin = guiGridListGetItemData(self.skinList, row, 1)
			triggerServerEvent("changeSkin", localPlayer, skin)		
			guiSetVisible(self.skinWindow, false)
			
		elseif source == self.giveAnimButton then	
		
			local row, column =  guiGridListGetSelectedItem(self.animList)
			
			if row == -1 then return end
			
			local anim = guiGridListGetItemData(self.animList, row, 1)
			triggerServerEvent("changeAnim", localPlayer, anim.block, anim.anim)		
			guiSetVisible(self.animWindow, false)
			
		elseif source == self.jetpackButton then
		
			if getPedOccupiedVehicle(localPlayer) then return end
			
			triggerServerEvent("giveJetpack", localPlayer)
			
		end
	
	end
	addEventHandler("onClientGUIClick", root, self.click)
	
	
	function self.doubleClick(button, state, absoluteX, absoluteY)

		if source == self.map then
		
			if getPedOccupiedVehicle(localPlayer) and getPedOccupiedVehicleSeat(localPlayer) ~= 0 then return end
		
			local spawnX = ((absoluteX - self.mapX) * self.mapScaleX) - 3000
			local spawnY = ((absoluteY - self.mapY) * -self.mapScaleY) + 3000
			
			fadeCamera(false, 0)
			local element
			if getPedOccupiedVehicle(localPlayer) and getElementHealth(getPedOccupiedVehicle(localPlayer)) > 0 then		
				element = getPedOccupiedVehicle(localPlayer)
			else
				element = localPlayer
			end
			setCameraTarget(localPlayer)
			setElementFrozen(element, true)
			setElementPosition(element, spawnX, spawnY, 0)
			setElementRotation(element, 0, 0, 0)
			
			setTimer(function(spawnX, spawnY) 
			
				local _, _, _, spawnZ = processLineOfSight(spawnX, spawnY, 3000, spawnX, spawnY, -3000)
				local waterZ = getWaterLevel(spawnX, spawnY, 100)
				spawnZ = (waterZ and math.max(spawnZ, waterZ) or spawnZ)
				triggerServerEvent("spawnOnPosition", localPlayer, spawnX, spawnY, spawnZ or 0)
				
			end, 1000, 1, spawnX, spawnY)
			
			setTimer(setElementFrozen, 1000, 1, element, false)
			
			self.setVisible(false)
		
		end

	end
	addEventHandler("onClientGUIDoubleClick", root, self.doubleClick)
	
	function self.renderBlips()

		if not self.isVisible() then return end

		local arena = getElementData(localPlayer, "Arena")
		local arenaElement = getElementByID(arena)
		
		for i, p in pairs(getPlayersInArena(arenaElement)) do
			
			if getElementData(p, "state") == "Alive" then
				
				local x, y, z = getElementPosition(getPedOccupiedVehicle(p) or p)
		
				local name = getPlayerName(p)
				local c1, c2 = string.find(name, '#%x%x%x%x%x%x')
				
				if c1 then
					blipr, blipg, blipb = getColorFromString(string.sub(name, c1, c2))
				else
					blipr = 255
					blipg = 255
					blipb = 255
				end
		
				local x = ((x + 3000) / self.mapScaleX + self.mapX) 
				local y = ((y - 3000) / -self.mapScaleY + self.mapY) 

				dxDrawRectangle ( x-4, y-4, 8, 8, tocolor ( 0, 0, 0, 255 ), true )	
				dxDrawRectangle (x-3, y-3, 6, 6, tocolor (blipr, blipg, blipb, 255 ), true )	

			end
		
		end
		
	end
	addEventHandler("onClientRender", root, self.renderBlips)
	
	function self.stopanim()
	
		triggerServerEvent("changeAnim", localPlayer, false)
	
	end
	bindKey("lshift", "down", self.stopanim)
	
	function self.destroy()
	
		removeEventHandler("onClientGUIDoubleClick", root, self.doubleClick)		
		removeEventHandler("onClientGUIClick", root, self.click)
		removeEventHandler("onClientRender", root, self.renderBlips)
		destroyElement(self.window)
		destroyElement(self.vehicleWindow)
		destroyElement(self.weaponWindow)
		destroyElement(self.skinWindow)
		destroyElement(self.animWindow)
		destroyElement(self.upgradeWindow)
		unbindKey("lshift", "down", self.stopanim)
	
	end

	return self
	
end
