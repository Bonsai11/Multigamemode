Antispawnkill = {}
Antispawnkill.active = false
Antispawnkill.timer = nil

function Antispawnkill.enable()

	Antispawnkill.active = true

end
addEvent("onClientMapChange", true)
addEventHandler("onClientMapChange", root, Antispawnkill.enable)


function Antispawnkill.start()

	Antispawnkill.timer = setTimer(Antispawnkill.disable, 5000, 1)

end
addEvent("onClientMapStart", true)
addEventHandler("onClientMapStart", root, Antispawnkill.start)


function Antispawnkill.disable()

	Antispawnkill.active = false

end


function Antispawnkill.reset()

	if isTimer(Antispawnkill.timer) then killTimer(Antispawnkill.timer) end
	Antispawnkill.active = false
	
end
addEvent("onClientArenaReset", true)
addEventHandler("onClientArenaReset", root, Antispawnkill.reset)


function Antispawnkill.check(creator)
	
	if not creator then return end
	
	if getElementType(creator) == "vehicle" then 
	
		creator = getVehicleOccupant(creator)
		
	end
	
	if not getElementType(creator) == "player" then return end

	if Antispawnkill.active then
	
		setElementPosition(source, 0, 0, 1000)
		destroyElement(source)
		
		if creator == localPlayer then 
		
			outputChatBox("Anti Spawnkill! Wait 5 seconds after map started!", 0, 255, 255)
			
		end
		
		return
		
	end
	
end
addEventHandler("onClientProjectileCreation", root, Antispawnkill.check)