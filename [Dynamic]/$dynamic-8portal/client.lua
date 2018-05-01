local localPlayer = getLocalPlayer()

function startclient()
	setSkyGradient(0 , 0 , 0 , 0 , 0 , 0)
	local tekstura = engineLoadTXD("files/a51jdrx.txd") 
	engineImportTXD(tekstura, 3095)
	local tekstura1 = engineLoadTXD("files/vgsoffice1.txd") 
	engineImportTXD(tekstura1, 8434)
	local tekstura2 = engineLoadTXD("files/vgsn_billboard.txd") 
	engineImportTXD(tekstura2, 7301)
	aboxobj = createObject(971, 5010.175, -1853.2252197266, 53.17, 0, 0, 0)
	aboxobj1 = createObject(971, 5019.046, -1853.234, 53.170, 0, 0, 180)
	aboxobj2 = createObject(971, 4982.647, -1931.62, 53.145, 0, 0, 135.088)
	aboxobj3 = createObject(971, 4976.414, -1925.386, 53.145, 0, 0, 314.874)
	aboxobj4 = createObject(971, 4967.703, -1900.875, 53.145, 0, 0, 89.5)
	aboxobj5 = createObject(971, 4967.791, -1892.063, 53.145, 0, 0, 269.286)
	aboxobj6 = createObject(971, 5057.563, -1895.274, 53.145, 0, 0, 269.896)
	aboxobj7 = createObject(971, 5057.542, -1904.096, 53.145, 0, 0, 89.687)
	aboxobj8 = createObject(971, 5042.393, -1864.403, 53.145, 0, 0, 315.192)
	aboxobj9 = createObject(971, 5048.632, -1870.652, 53.145, 0, 0, 134.984)
	aboxobj10 = createObject(971, 5008.762, -1898.047, 41.327, 0, 0, 90)
	aboxobj11 = createObject(971, 5013.179, -1893.65, 41.327, 0, 0, 0)
	aboxobj12 = createObject(971, 5017.574, -1898.035, 41.327, 0, 0, 90)
	aboxobj13 = createObject(971, 5013.147, -1902.439, 41.327, 0, 0, 0)
	aboxobj14 = createObject(971, 5046.272, -1927.948, 53.145, 0, 0, 223.54)
	aboxobj15 = createObject(971, 5039.902, -1934.042, 53.145, 0, 0, 43.83)
	aboxobj16 = createObject(971, 5015.078, -1942.84, 53.145, 0, 0, 180.895)
	aboxobj17 = createObject(971, 5006.281, -1943.011, 53.145, 0, 0, 1.434)
	agrav1 = createMarker(4974.033, -1857.81, 50.55, "corona", 8, 0, 0, 204, 200)
	agrav1a = createMarker(4544.023, -1075.564, 245.237, "corona", 4, 155, 100, 200, 200)
	agrav2 = createMarker(5012.31, -1842.936, 50.55, "corona", 8, 0, 0, 204, 200)
	agrav2a = createMarker(5067.169, -808.416, 113.866, "corona", 4, 81, 223, 31, 200)
	agrav3 = createMarker(5052.139, -1858.598, 50.55, "corona", 8, 0, 0, 204, 200)
	agrav3a = createMarker(5478.053, -905.408, 2.281, "corona", 4, 81, 223, 31, 200)
	agrav4 = createMarker(5067.342, -1898.056, 50.55, "corona", 8, 0, 0, 204, 200)
	agrav4a = createMarker(7743.076, -1873.369, 46.777, "corona", 4, 81, 223, 31, 200)
	agrav5 = createMarker(5051.524, -1936.013, 50.55, "corona", 8, 255, 0, 0, 200)
	agrav5a = createMarker(3390.563, 1731.956, 53.539, "corona", 8, 81, 223, 31, 200)
	agrav6 = createMarker(5012.771, -1953.454, 50.55, "corona", 8, 255, 0, 0, 200)
	agrav6a = createMarker(608.247, -3032.164, 670.486, "corona", 4, 200, 50, 100, 200)
	agrav7 = createMarker(4973.045, -1937.823, 50.55, "corona", 8, 255, 0, 0, 200)
	agrav7a = createMarker(-292.942, -3665.739, 45.304, "corona", 8, 81, 223, 31, 200)
	agrav8 = createMarker(4957.057, -1897.882, 50.55, "corona", 8, 255, 0, 0, 200)
	agrav8a = createMarker(3831.716, -1998.715, 46.626, "corona", 4, 81, 223, 31, 200)
	addEventHandler("onClientMarkerHit", resourceRoot, warp)
end

function warp(player)

	if player~=localPlayer then
		if source==agrav8a then
			moveObject(aboxobj10, 6000, 5008.762, -1898.047, 53.108)
			moveObject(aboxobj11, 6000, 5013.179, -1893.65, 53.108)
			moveObject(aboxobj12, 6000, 5017.574, -1898.035, 53.108)
			moveObject(aboxobj13, 6000, 5013.147, -1902.439, 53.108)
		end
		return
	end
	if isPedInVehicle(localPlayer) then
		local vehicle=getPedOccupiedVehicle(localPlayer)
		setElementFrozen(vehicle, true)
		playSound("files/warp.mp3")
		if source~=agrav5 then setTimer(setElementFrozen, 750, 1, vehicle, false) end
		if source==agrav1 then
			setElementPosition(vehicle, 4540.732, -1288.828, 238.627)
		elseif source==agrav1a then
			setElementPosition(vehicle, 5013.247, -1897.528, 50.286)
			setElementRotation(vehicle, 0, 0, 0)
			moveObject(aboxobj, 3000, 5010.175,-1853.225, 41.327)
			moveObject(aboxobj1, 3000, 5019.046,-1853.225, 41.327)
		elseif source==agrav2 then
			setElementPosition(vehicle, 5066.782, -1230.15, 70.881)
		elseif source==agrav2a then
			setElementPosition(vehicle, 5013.247, -1897.528, 50.286)
			setElementRotation(vehicle, 0, 0, -45)
			moveObject(aboxobj8, 3000, 5042.393, -1864.403, 41.327)
			moveObject(aboxobj9, 3000, 5048.632, -1870.652, 41.327)
		elseif source==agrav3 then
			setElementPosition(vehicle, 5704.286, -933.202, 2.391)
			setElementRotation(vehicle, 0, 0, 100)
		elseif source==agrav3a then
			setElementPosition(vehicle, 5013.247, -1897.528, 50.286)
			setElementRotation(vehicle, 0, 0, -90)
			moveObject(aboxobj6, 3000, 5057.563, -1895.274, 41.327)
			moveObject(aboxobj7, 3000, 5057.542, -1904.096, 41.327)
		elseif source==agrav4 then
			setElementPosition(vehicle, 7707.915, -1893.286, 46.558)
		elseif source==agrav4a then
			setElementPosition(vehicle, 5013.247, -1897.528, 50.286)
			setElementRotation(vehicle, 0, 0, -135)
			moveObject(aboxobj14, 3000, 5046.272, -1927.948, 41.327)
			moveObject(aboxobj15, 3000, 5039.902, -1934.042, 41.327)
		elseif source==agrav5 then
			setTimer(setElementFrozen, 600, 1, vehicle, false)
			setElementPosition(vehicle, 3016.373, 1896.37, 3.76)
		elseif source==agrav5a then
			setElementPosition(vehicle, 5013.247, -1897.528, 50.286)
			setElementRotation(vehicle, 0, 0, -180)
			moveObject(aboxobj16, 3000, 5015.078, -1942.84, 41.327)
			moveObject(aboxobj17, 3000, 5006.281, -1943.011, 41.327)
		elseif source==agrav6 then
			setElementPosition(vehicle, 328.119, -3056.395, 629.35)
		elseif source==agrav6a then
			setElementPosition(vehicle, 5013.247, -1897.528, 50.286)
			setElementRotation(vehicle, 0, 0, -225)
			moveObject(aboxobj2, 3000, 4982.647, -1931.62, 41.327)
			moveObject(aboxobj3, 3000, 4976.414, -1925.386, 41.327)
		elseif source==agrav7 then
			setElementRotation(vehicle, 0, 0, 180)
			setElementPosition(vehicle, -382.799, -3250.597, 5.272)
		elseif source==agrav7a then
			setElementPosition(vehicle, 5013.247, -1897.528, 50.286)
			setElementRotation(vehicle, 0, 0, -270)
			moveObject(aboxobj4, 3000, 4967.703, -1900.875, 41.327)
			moveObject(aboxobj5, 3000, 4967.791, -1892.063, 41.327)
		elseif source==agrav8 then
			setElementPosition(vehicle, 4038.591, -1869.676, 4.691)
		elseif source==agrav8a then
			setElementPosition(vehicle, 5013.247, -1897.528, 110.939)
			moveObject(aboxobj10, 3000, 5008.762, -1898.047, 53.108)
			moveObject(aboxobj11, 3000, 5013.179, -1893.65, 53.108)
			moveObject(aboxobj12, 3000, 5017.574, -1898.035, 53.108)
			moveObject(aboxobj13, 3000, 5013.147, -1902.439, 53.108)
		end
	end
end
addEventHandler("onClientResourceStart", resourceRoot, startclient)