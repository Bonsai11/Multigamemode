Radar = {}
Radar.x, Radar.y = guiGetScreenSize()
Radar.relX, Radar.relY =  (Radar.x/800), (Radar.y/600)
Radar.barHeight = 6*Radar.relY
Radar.edge = 1
Radar.width = 180*Radar.relY
Radar.height = 110*Radar.relY
Radar.posX = 13*Radar.relY
Radar.posY = Radar.y - Radar.height - 13*Radar.relY - dxGetFontHeight(1, "default-bold") * 1.5
Radar.blipSize = 16
Radar.totalsize = 3000
Radar.theTarget = nil
Radar.rotorRotation = 0
Radar.show = true
Radar.renderTarget = dxCreateRenderTarget( Radar.width, Radar.height, true )

function Radar.getCameraRotation()

    px, py, pz, lx, ly, lz = getCameraMatrix()
    local rotz = 6.2831853071796 - math.atan2 ( ( lx - px ), ( ly - py ) ) % 6.2831853071796
    local rotx = math.atan2 ( lz - pz, getDistanceBetweenPoints2D ( lx, ly, px, py ) )
    rotx = math.deg(rotx)
    rotz = math.deg(rotz)	
    return rotz
	
end


function Radar.findRotation(x1,y1,x2,y2)
 
  local t = -math.deg(math.atan2(x2-x1,y2-y1))
  if t < 0 then t = t + 360 end;
  return t;
 
end


function Radar.getPointFromDistanceRotation(x, y, dist, angle)
 
    local a = math.rad(90 - angle);
    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;
    return x+dx, y+dy;
 
end


function Radar.toggle()

	Radar.show = not Radar.show

end
addCommandHandler("showradar", Radar.toggle)


function Radar.show(state)

	Radar.show = state

end
addEvent("showRadar", true)
addEventHandler("showRadar", root, Radar.show)


function Radar.render()

	showPlayerHudComponent("radar", false)

	if not Radar.show then return end
	
	Radar.theTarget = getCameraTarget(localPlayer)
	
	if not Radar.theTarget then return end
	
	if getElementType(Radar.theTarget) == "player" then
	
		Radar.theTarget = getPedOccupiedVehicle(Radar.theTarget)
		
	end
	
	if not Radar.theTarget then 
	
		Radar.theTarget = getCameraTarget(localPlayer)
	
	end
	
	if not Radar.theTarget then return end

	--background
	dxDrawRectangle ( Radar.posX, Radar.posY, Radar.width, Radar.height, tocolor ( 255, 255, 255, 50 ) )
	dxDrawRectangle ( Radar.posX, Radar.posY, Radar.width, Radar.edge, tocolor ( 0, 0, 0, 255 ) )
	dxDrawRectangle ( Radar.posX, Radar.posY, Radar.edge, Radar.height+Radar.barHeight+Radar.edge, tocolor ( 0, 0, 0, 255 ) )
	dxDrawRectangle ( Radar.posX, Radar.posY+Radar.height, Radar.width, Radar.edge, tocolor ( 0, 0, 0, 255 ) )	
	dxDrawRectangle ( Radar.posX+Radar.width-Radar.edge, Radar.posY, Radar.edge, Radar.height+Radar.barHeight+Radar.edge, tocolor ( 0, 0, 0, 255 ) )

	local health = getElementHealth(Radar.theTarget)
	
	if getElementType(Radar.theTarget) == "player" then
	
		health = health * 7.5
	
	else
	
		health = math.max(health - 250, 0)
	
	end
	
	health = health/750
	local p = -510*(health^2)
	local r,g = math.max(math.min(p + 255*health + 255, 255), 0), math.max(math.min(p + 765*health, 255), 0)
	
	local nitro
	
	if getElementType(Radar.theTarget) == "vehicle" then
	
		nitro = getVehicleNitroLevel(Radar.theTarget)
		
	end
		
	if not nitro then 
	
		nitro = 0 
		
	end

	
	dxDrawRectangle ( Radar.posX, Radar.posY+Radar.height+Radar.barHeight+Radar.edge, Radar.width, Radar.edge, tocolor ( 0, 0, 0, 255 ) )	
	dxDrawRectangle ( Radar.posX+Radar.width/2, Radar.posY+Radar.height+Radar.edge, Radar.edge, Radar.barHeight, tocolor ( 0, 0, 0, 255 ) )	
	
	--health
	dxDrawRectangle(Radar.posX+Radar.edge, Radar.posY+Radar.height+Radar.edge, Radar.width/2-Radar.edge*2+Radar.edge/2, Radar.barHeight, tocolor(r,g,0,75) )				
	dxDrawRectangle(Radar.posX+Radar.edge, Radar.posY+Radar.height+Radar.edge, health*(Radar.width/2-Radar.edge*2+Radar.edge/2), Radar.barHeight, tocolor(r,g,0,255) )
	
	--nitro
	dxDrawRectangle(Radar.posX+Radar.width/2+Radar.edge/2, Radar.posY+Radar.height+Radar.edge, Radar.width/2-Radar.edge*2+Radar.edge/2, Radar.barHeight, tocolor(0,150,220,75) )				
	dxDrawRectangle(Radar.posX+Radar.width/2+Radar.edge/2, Radar.posY+Radar.height+Radar.edge, nitro*(Radar.width/2-Radar.edge*2+Radar.edge/2), Radar.barHeight, tocolor(0,50,255,255) )


	local rotation = Radar.getCameraRotation()	
	
	local xp, yp, zp = getElementPosition(Radar.theTarget)
   
    local ratio = Radar.totalsize/6000
	local startX = (-Radar.totalsize/2) + Radar.width/2
	local startY = (-Radar.totalsize/2) + Radar.height/2
    
    dxSetRenderTarget(Radar.renderTarget, true)
		dxDrawImage(startX - xp*ratio, startY + yp*ratio, Radar.totalsize, Radar.totalsize, "img/map.png", rotation, xp*ratio, -yp*ratio, tocolor(255, 255, 255, 255))
    dxSetRenderTarget() 
	
    dxDrawImage(Radar.posX+Radar.edge, Radar.posY+Radar.edge, Radar.width-Radar.edge*2, Radar.height-Radar.edge, Radar.renderTarget, 0, 0, 0, tocolor(255, 255, 255, 225), false)  	

   
    --players
	for i, player in pairs(getElementsByType("player")) do
	
		while true do
	
			if getElementParent(player) ~= getElementParent(localPlayer) then break end
			
			if getElementData(player, "state") ~= "Alive" then break end
			
			if player == Radar.theTarget then break end
					
			if getPedOccupiedVehicle(player) == Radar.theTarget then break end
					
			local x, y, z = getElementPosition(player)

			local blipr, blipg, blipb
			
			if getElementData(getElementParent(player), "forced_vehicle_color") then
	
				local color = getElementData(getElementParent(player), "forced_vehicle_color")
				blipr, blipg, blipb = getColorFromString(color)
			
			elseif getPlayerTeam(player) then
			
				blipr, blipg, blipb = getTeamColor(getPlayerTeam(player), true)
			
			else
			
				local playerName = getPlayerName(player)
				local c1, c2 = string.find(playerName, '#%x%x%x%x%x%x')
				
				if c1 then
				
					blipr, blipg, blipb = getColorFromString(string.sub(playerName, c1, c2))
			
				else
				
					blipr = 255
					blipg = 255
					blipb = 255
			
				end
			
			end
			
			local distance = getDistanceBetweenPoints2D(x, y, xp,yp)
			local rotation2 = Radar.findRotation(x,y,xp,yp)
			local xd, yd = Radar.getPointFromDistanceRotation(Radar.posX+(Radar.width/2), Radar.posY+(Radar.height/2), distance*0.5, rotation2-rotation)	
			
			if xd < Radar.posX+Radar.edge then
			
				xd = Radar.posX+Radar.edge
				
			elseif xd > Radar.posX+Radar.width-Radar.edge then
			
				xd = Radar.posX+Radar.width-Radar.edge
				
			end
			
			if yd < Radar.posY+Radar.edge then
			
				yd = Radar.posY+Radar.edge
				
			elseif yd > Radar.posY+Radar.height then
			
				yd = Radar.posY+Radar.height
				
			end
			
			if zp - z > 1 then
				
				dxDrawImage(xd-6, yd-7, 13, 14, "img/blipDown.png", 0, 0, 0, tocolor ( blipr, blipg, blipb, 255 ))
			
			elseif zp - z < -1 then
			
				dxDrawImage(xd-6, yd-7, 13, 14, "img/blipUp.png", 0, 0, 0, tocolor ( blipr, blipg, blipb, 255 ))
			
			else
			
				dxDrawImage(xd-6, yd-6, 12, 12, "img/blipNormal.png", 0, 0, 0, tocolor ( blipr, blipg, blipb, 255 ))
				
			end
			
			break
		
		end
			
	end

	--checkpoints
	for i, colshape in pairs(getElementsByType("colshape")) do
	
		while true do
	
			if getElementData(colshape, "type") ~= "checkpoint" then break end 
	
			local p = getElementData(colshape, "marker")
			
			if getElementDimension(colshape) ~= getElementDimension(localPlayer) then break end
		
			local x, y, z = getElementPosition(p)
			local blipr, blipg, blipb = getMarkerColor(p)
			
			local distance = getDistanceBetweenPoints2D(x, y, xp,yp)
			local rotation2 = Radar.findRotation(x,y,xp,yp)
			local xd, yd = Radar.getPointFromDistanceRotation(Radar.posX+(Radar.width/2), Radar.posY+(Radar.height/2), distance*0.5, rotation2-rotation)	
			
			if xd < Radar.posX+Radar.edge then
			
				xd = Radar.posX+Radar.edge
				
			elseif xd > Radar.posX+Radar.width-Radar.edge then
			
				xd = Radar.posX+Radar.width-Radar.edge
				
			end
			
			if yd < Radar.posY+Radar.edge then
			
				yd = Radar.posY+Radar.edge
				
			elseif yd > Radar.posY+Radar.height then
			
				yd = Radar.posY+Radar.height
				
			end
			
			if getElementData(colshape, "next") then
			
				dxDrawRectangle(xd-6, yd-6, 12, 12, tocolor ( 0, 0, 0, 255 ))	
				dxDrawRectangle(xd-5, yd-5, 10, 10, tocolor (blipr, blipg, blipb, 255 ))	

			elseif getElementData(colshape, "afterNext") then
			
				dxDrawRectangle(xd-3, yd-3, 6, 6, tocolor ( 0, 0, 0, 255 ))	
				dxDrawRectangle(xd-2, yd-2, 5, 5, tocolor (blipr, blipg, blipb, 255 ))	
			
			end
				
			break
			
		end 
			
	end
	
	local xr,yr,zr = getElementRotation(Radar.theTarget)
    dxDrawImage ( Radar.posX+(Radar.width/2)-Radar.blipSize/2, Radar.posY+(Radar.height/2)-Radar.blipSize/2, Radar.blipSize, Radar.blipSize, "img/blip.png", -zr+rotation, 0, 0, tocolor ( 255, 255, 255, 255 ), false )  
	
	
end
addEventHandler("onClientRender", root, Radar.render)
