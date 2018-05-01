Speedo = {}
Speedo.x, Speedo.y = guiGetScreenSize()
Speedo.show = true
Speedo.fontSize = 1
Speedo.font = dxCreateFont('font/rothman.ttf', 45)
Speedo.color = tocolor(240, 240, 240, 255)
Speedo.posX = Speedo.x - dxGetTextWidth(" XXX km/h", Speedo.fontSize, Speedo.font)
Speedo.posY = Speedo.y - dxGetFontHeight(Speedo.fontSize, Speedo.font) - dxGetFontHeight(1, "default-bold") * 1.5
Speedo.speed = "0"
Speedo.updateInterval = 50
Speedo.theTarget = nil
Speedo.tick = getTickCount()

function Speedo.toggle()

	Speedo.show = not Speedo.show

end
addCommandHandler("showspeedo", Speedo.toggle)


function Speedo.show(state)

	Speedo.show = state

end
addEvent("showSpeedo", true)
addEventHandler("showSpeedo", root, Speedo.show)


function Speedo.render()

	if not Speedo.show then return end
	
	Speedo.theTarget = getCameraTarget(localPlayer)
	
	if not Speedo.theTarget then return end
	
	if getElementType(Speedo.theTarget) == "player" then
	
		Speedo.theTarget = getPedOccupiedVehicle(Speedo.theTarget)
		
	end
	
	if not Speedo.theTarget then return end

	if getTickCount() - Speedo.tick > Speedo.updateInterval then
	
		Speedo.speed = tostring(math.floor(Speedo.getVehicleSpeed(Speedo.theTarget) * 0.8914))
		Speedo.tick = getTickCount()
		
	end

	dxDrawText(string.format("%03d", Speedo.speed).." km/h", Speedo.posX+1, Speedo.posY+1, Speedo.x+1, Speedo.y+1, tocolor(0,0,0,255), Speedo.fontSize, Speedo.font, "left", "top")
	dxDrawText(string.format("%03d", Speedo.speed).." km/h", Speedo.posX, Speedo.posY, Speedo.x, Speedo.y, Speedo.color, Speedo.fontSize, Speedo.font, "left", "top")

end
addEventHandler("onClientRender", root, Speedo.render)


function Speedo.getVehicleSpeed(vehicle)   

    if (vehicle) then
	
        local vx, vy, vz = getElementVelocity(vehicle)
        
        if (vx) and (vy)and (vz) then
		
            return math.sqrt(vx^2 + vy^2 + vz^2) * 180 
			
        else
		
            return 0
			
        end
		
    else
	
        return 0
		
    end
	
end

