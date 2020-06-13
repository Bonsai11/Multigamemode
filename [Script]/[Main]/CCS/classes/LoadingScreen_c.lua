LoadingScreen = {}
LoadingScreen.__index = LoadingScreen
setmetatable(LoadingScreen, {__call = function (cls, ...) return cls.new(...) end,})
LoadingScreen.instances = {}
LoadingScreen.x, LoadingScreen.y =  guiGetScreenSize()
LoadingScreen.relX, LoadingScreen.relY =  (LoadingScreen.x/800), (LoadingScreen.y/600)
LoadingScreen.font = dxCreateFont("img/travel.ttf", 200)
LoadingScreen.tagList = {"BONSAI", "TABO", "N!KO", "TIGER", "^_^", "KINGZZ", "DIMA", "MYETZ", "CLICKYY", "STIFLER", "YIGITHAN", "ONLYTIME", "FORLAN", "ER1K", "ADOMER", 
			"DAINDY", "MOS", "THE_DUDE", "DINNER", "MR.DRAKE", "JULIAN", "RAYOKKZ", "AJ", "SEBAZ", "KITT", "MILKEH", "SHOK", "TRYHARD", "TEMPLER", 
			"OLUCHNA", "JOHNNY", "RENKON", "LARSKEE", "DARKNESS", "MR.SKOL", "INFERNO", "QWINCE", "TROSKY", "SPACE", "MONKSUN", "BERTO", "ANGEL", "PENDEX", 
			"ZUNE", "MICHAEL", "VODKA", "MONSTER", "COLD", "JAPA", "HUNTER", "BUSHIDO", "KURATO", "VIRTU", "SEISH", "KNASKRIPPA", "PROJECTX", 
			"TOYKO", "ROXUS", "DEVISUNNNN", "WIND", "HITSU", "WILSON", "GJENTIB", "WEED", "JAYER", "SNIPER", "SAMUPEGA", "EVIL15", "REPLAY", "NIRAX", 
			"LIGHTNING", "NEXON", "WAYLON", "FALKEN", "POLLA", "TECLA", "DEATHNOTE", "POKEX", "NOHEAR43", "NUTZ", "MAJESTIC", "SAPE", "BOULI", "SKYKNIGHT", 
			"MYHAX", "ELUZIVE", "MR.MONKEY", "SANDOWSKI", "ORS", "ROBERT_M", "TAURUS", "BLADE", "LUCHO122", "FERNANDO", "REBEL", "CRAWLER", "STIEG", 
			"SMIRNOV", "MIDHAT", "CHAOSJOY", "RUURD", "4:20", "RYZER!", "ABDE_GAMER", "MR.AZZOZ", "HADI", "XZERO", "PERFEKT", "LIPISIQX", "VINTAGUS", 
			"BULLET", "SKELETON", "CRYS", "HM", "AVENGER", "DREAMER", "THESKATER", "JONHY", "THEONE", "OBSIDIAN", "PLATO", "SNAKE", "D4N1EL", "JOULEX", 
			"NIGGAA", "SEBAS", "JAYZEN", "CRAZYBOY", "GHOST_EGY", "CAIMAN", "KARIM", "REYVESTIA", "LORENZO", "TENSHO", "XTREME", "BLACKANGEL", "YOUNGALP", 
			"KOSTOLOM", "FEAR", "JACKASS", "NO1SE", "KRUZE", "AVEUX", "PROTO", "MRHERZ", "SPEED", "JAX", "SARA", "YAMI", "BREAK", "YIGI", "TECHNO", "XLION",
			"TARGET^", "KAVINSKY", "NEGA", "^SOLIMAN~", "AIRTEAM", "TOXIDO_STYLE", "LYNE", "WINGZ", "ASPHEL", "MOHAMED", "ALIOMAR", "EASYE", "TRUCKER",
			"JASON", "MATEE", "WESLEY", "AIR", "JAKE", "MATTOWSKI", "EXSSV", "KRANZ", "REACTX", "REDWARRIOR", "N0PE", "ELECTROMANZY~", "DUFF", "TIGERCLAW",
			"MIGHTYFIRE", "KHAKIONE0", "MIKKZ", "SKEMA", "SCORPION", "ONLYTIME", "FRANK", "LILGERA", "LUDI", "ROXUS", "MIHA", "SAMMY", "CAT MASTER", "BUSHIDO",
			"DEATHNOTE", "ANASS"}
			
function LoadingScreen.new()

    local self = setmetatable({}, LoadingScreen)

	self.x = 0
	self.y = 0
	self.width = LoadingScreen.x
	self.height = LoadingScreen.y
	self.backgroundColor = tocolor( 0, 0, 0, 255)
	self.postGUI = false
	self.currentTags = {}
	self.currentID = 1
	self.currentList = {}	
	self.currentList = LoadingScreen.getRandomList()
	table.insert(self.currentTags, {text = self.currentList[self.currentID], size = 0, alpha = 255, speed = 0.01, visible = true, hasNext = false})
	fadeCamera(false, 0)

	LoadingScreen.instances[self] = true
	
	return self
	
end


function LoadingScreen.draw()

	for self, _ in pairs(LoadingScreen.instances) do
	
		dxDrawRectangle(0, 0, LoadingScreen.x, LoadingScreen.y, tocolor(0, 0, 0, 255))
			
		for i, tag in pairs(self.currentTags) do
			
			if tag.visible then
			
				local color = getElementData(getElementParent(localPlayer), "color") or "ffffff"
				local r, g, b = Util.hex2rgb(color)
				dxDrawText(tag.text, 0, 0, LoadingScreen.x, LoadingScreen.y, tocolor(r, g, b, tag.alpha), tag.size, LoadingScreen.font, "center", "center")
		
			end
		
			tag.size = tag.size + tag.speed
			tag.alpha = tag.alpha - 2.5
			tag.speed = tag.speed + 0.001
			
			if tag.size > 2 and not tag.hasNext then
			
				tag.hasNext = true
				self.currentID = self.currentID + 1
				
				if self.currentID > #self.currentList then
				
					self.currentID = 1
					
				end
				
				table.insert(self.currentTags, {text = self.currentList[self.currentID], size = 0, alpha = 255, speed = 0.01, visible = true, hasNext = false})
				break
			
			end
			
			if tag.alpha <= 0 then
			
				tag.visible = false
				
			end
		
		end

	end
		
end
addEventHandler("onClientRender", root, LoadingScreen.draw, true, "low-1")


function LoadingScreen:getRandomList()

	tempList = table.copy(LoadingScreen.tagList)
	newList = {}
	
	while #tempList ~= 0 do
	
		local index = math.random(#tempList)
		table.insert(newList, LoadingScreen.tagList[index])
		table.remove(tempList, index)
	
	end

	return newList
	
end
	
	
function LoadingScreen:destroy()
	
	LoadingScreen.instances[self] = nil
	self = nil
	fadeCamera(true, 3.0)
	
end