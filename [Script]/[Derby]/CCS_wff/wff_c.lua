WFF = {}
WFF.gui = {}
WFF.img = {file = "img/rip.png", width = 64, height = 64}
WFF.list = {}
WFF.currentMarker = 1

function WFF.main()

	if not getElementData(source, "wff") then return end

	addEventHandler("onClientRender", root, WFF.render)
	triggerServerEvent("onWFFRequest", localPlayer)
	bindKey("space", "down", WFF.moveToMarkers)
		
end
addEvent("onClientMapStart", true)
addEventHandler("onClientMapStart", root, WFF.main)


function WFF.reset()

	WFF.list = {}
	removeEventHandler("onClientRender", root, WFF.render)
	unbindKey("space", "down", WFF.moveToMarkers)
	WFF.currentMarker = 1

end
addEvent("onClientArenaReset", true)
addEventHandler("onClientArenaReset", root, WFF.reset)


function WFF.update(list)

	WFF.list = list
		
end
addEvent("onClientWFFUpdate", true)
addEventHandler("onClientWFFUpdate", root, WFF.update)


function WFF.render()

	for i, data in pairs(WFF.list) do
	
		while true do
		
			local x, y, z = data.posX, data.posY, data.posZ
			local sx, sy = getScreenFromWorldPosition(x, y, z)
			
			if not sx or not sy then break end
			
			local cx, cy, cz = getCameraMatrix()
			local dist = getDistanceBetweenPoints3D(cx, cy, cz, x, y, z)
			
			if dist > 300 then break end
			
			local scale = 500/dist*0.05
			local stat = data.time.." ("..(data.position or "-")..") "
			dxDrawImage(sx-WFF.img.width/2*scale, sy-WFF.img.height*scale, WFF.img.width*scale, WFF.img.height*scale, WFF.img.file)
			dxDrawText(data.name, sx-WFF.img.width/2*scale, sy-(WFF.img.height+33)*scale, sx+WFF.img.width/2*scale, sy, -939524096, 1.5*scale, "default", "center", "top", false, false, false, true)
			dxDrawText(data.name, sx-WFF.img.width/2*scale, sy-(WFF.img.height+33)*scale-1, sx+WFF.img.width/2*scale, sy, -922746881, 1.5*scale, "default", "center", "top", false, false, false, true)
			dxDrawText(stat, sx-WFF.img.width/2*scale, sy-(WFF.img.height+7)*scale, sx+WFF.img.width/2*scale, sy, -939524096, 0.7*scale, "default", "center")
			dxDrawText(stat, sx-WFF.img.width/2*scale, sy-(WFF.img.height+7)*scale-1, sx+WFF.img.width/2*scale, sy, -922746881, 0.7*scale, "default", "center")

			break
		
		end
		
	end
	
end


function WFF.moveToMarkers()

	if not exports["CCS_freecam"]:isFreecamEnabled() then return end

	WFF.currentMarker = WFF.currentMarker + 1
	
	if WFF.currentMarker > #WFF.list then
	
		WFF.currentMarker = 1
		
	end
	
	setCameraMatrix(WFF.list[WFF.currentMarker].posX, WFF.list[WFF.currentMarker].posY, WFF.list[WFF.currentMarker].posZ)

end