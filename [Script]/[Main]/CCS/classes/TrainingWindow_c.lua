TrainingWindow = {}
TrainingWindow.x, TrainingWindow.y =  guiGetScreenSize()
TrainingWindow.width = 400
TrainingWindow.height = 500
TrainingWindow.posX = TrainingWindow.x / 2 - TrainingWindow.width / 2
TrainingWindow.posY = TrainingWindow.y / 2 - TrainingWindow.height / 2

function TrainingWindow.new()

	local self = {}
	self.window = guiCreateWindow ( TrainingWindow.posX, TrainingWindow.posY, TrainingWindow.width, TrainingWindow.height, "Choose a Map", false )
	guiWindowSetSizable(self.window, false)
	guiWindowSetMovable(self.window, false)
	self.searchLabel = guiCreateLabel(0.04, 0.05, 0.1, 0.05, "Search", true, self.window)
	guiLabelSetVerticalAlign(self.searchLabel, "center")
	self.searchBar = guiCreateEdit(0.15, 0.05, 0.82, 0.05, "", true, self.window)
	self.mapsGridlist = guiCreateGridList(0.02, 0.12, 0.96, 0.88, true, self.window)
	self.mapsList = guiGridListAddColumn(self.mapsGridlist, "Maps", 0.7)
	self.typeList = guiGridListAddColumn(self.mapsGridlist, "Type", 0.2)
	guiSetVisible(self.window, false)
	self.maps = {}
	guiSetInputMode("no_binds_when_editing")
	
	function self.setVisible(state)
	
		guiSetVisible(self.window, state)
		showCursor(state)
		
	end
	
	function self.isVisible()
	
		return guiGetVisible(self.window)
		
	end
	
	
	function self.update(maps)
	
		self.maps = maps
	
		for i, map in ipairs(self.maps) do
	
			local row = guiGridListAddRow(self.mapsGridlist)
			guiGridListSetItemText(self.mapsGridlist, row, self.mapsList, map.name, false, false)
			guiGridListSetItemData(self.mapsGridlist, row, self.mapsList, i)
			guiGridListSetItemText(self.mapsGridlist, row, self.typeList, map.type, false, false)
	
		end
	
	end
	addEvent("onRecieveMapList", true)
	addEventHandler("onRecieveMapList", root, self.update)
	
	function self.click()

		local arenaElement = getElementParent(localPlayer)
	
		local row, column = guiGridListGetSelectedItem(self.mapsGridlist)
		
		if row == -1 then return end
		
		if self.isVisible() then setTimer(self.setVisible, 100, 1, false) end
		
		triggerServerEvent("onStartNewMap", arenaElement, self.maps[guiGridListGetItemData(self.mapsGridlist, row, column)], true)

	end
	addEventHandler("onClientGUIDoubleClick", root, self.click)
	
	function self.search()

		if source ~= self.searchBar then return end
		
		guiGridListClear(self.mapsGridlist)
		
		if #guiGetText(self.searchBar) == 0 then
			
			for i, map in ipairs(self.maps) do
			
				local row = guiGridListAddRow(self.mapsGridlist )
				
				guiGridListSetItemText(self.mapsGridlist, row, self.mapsList, map.name, false, false )
				guiGridListSetItemData(self.mapsGridlist, row, self.mapsList, i)
				guiGridListSetItemText(self.mapsGridlist, row, self.typeList, map.type, false, false)
			
			end
			
			return
			
		end
		
		for i, map in ipairs(self.maps) do
		
			if string.lower(map.name):find(guiGetText(self.searchBar):lower()) then
			
				local row = guiGridListAddRow (self.mapsGridlist )
				guiGridListSetItemText(self.mapsGridlist, row, self.mapsList, map.name, false, false )
				guiGridListSetItemData(self.mapsGridlist, row, self.mapsList, i)
				guiGridListSetItemText(self.mapsGridlist, row, self.typeList, map.type, false, false)
			
			end
		
		end
		
	end
	addEventHandler("onClientGUIChanged", root, self.search)
	
	function self.destroy()
	
		destroyElement(self.window)
		removeEventHandler("onClientGUIChanged", root, self.search)
		removeEventHandler("onClientGUIDoubleClick", root, self.click)
		removeEventHandler("onRecieveMapList", root, self.update)
	
	end
	
	triggerServerEvent("onRequestMapList", localPlayer, "Cross;Classic;Oldschool;Modern;Race;Shooter;Linez;Dynamic")	

	return self
	
end
