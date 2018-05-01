function onClientResourceStart()
	setWaterColor( 127, 255, 212)
	setCloudsEnabled(false)
	marker1a = createMarker(3947.599609375, -1644.8041992188, 0, "corona", 4, 0, 0, 0, 0)
	marker1b = createMarker(4539.90625, -1325.8087158203, 0, "corona", 4, 0, 0, 0, 0)
	marker2a = createMarker(3947.599609375, -1678.2799072266, 0, "corona", 4, 0, 0, 0, 0)
	marker2b = createMarker(3402.0849609375, -3635.5087890625, 0, "corona", 4, 0, 0, 0, 0)
	marker3a = createMarker(3947.599609375, -1739.435546875, 0, "corona", 4, 0, 0, 0, 0)
	marker3b = createMarker(4855.02734375, -381.8349609375, 0, "corona", 4, 0, 0, 0, 0)
	marker4a = createMarker(3947.599609375, -1783.724609375, 0, "corona", 4, 0, 0, 0, 0)
	marker4b = createMarker(4449.939453125, -141.828125, 0, "corona", 4, 0, 0, 0, 0)
	marker5a = createMarker(3986.19921875, -1709.599609375, 0, "corona", 5, 0, 0, 0, 0)
	marker6 = createMarker(4178.7397460938, -1705.4927978516, 2989.4790039063, "corona", 5, 0, 0, 0, 0)
	alreadydid1 = false
	alreadydid2 = false
	alreadydid3 = false
	alreadydid4 = false
	object1 = createObject ( 987, 3950.6000976563, -1686.6999511719, -2.7999999523163, 0, 0, 270 )
	object2 = createObject ( 987, 3950.6000976563, -1698.5999755859, -2.7999999523163, 0, 0, 270 )
	object3 = createObject ( 987, 3950.6000976563, -1710.5999755859, -2.7999999523163, 0, 0, 270 )
	object4 = createObject ( 987, 3950.6000976563, -1722.5999755859, -2.7999999523163, 0, 0, 270 )
end
addEventHandler( "onClientResourceStart", getResourceRootElement(getThisResource()), onClientResourceStart )

function markerHit(hitPlayer, matchingDimension)
	if source == marker1a then
		local vehicle = getPedOccupiedVehicle(hitPlayer)
		if hitPlayer == getLocalPlayer() then
			if alreadydid1 == false then
				setElementRotation(vehicle, 0, 0, 270)
				setElementPosition(vehicle, 3496.9262695313, -1345.3129882813, 0.17500001192093)
				setVehicleFrozen(vehicle, true)
				setTimer(setVehicleFrozen, 100, 1, vehicle, false)
				fadeCamera ( false, 0.0, 0, 0, 0 )
				setCameraTarget ( getLocalPlayer() )
				setTimer(fadeCamera, 100, 1, true, 0.0, 0, 0, 0)
			else
				outputChatBox("#7A02BFYou already did this parcour!", 255, 255, 255, true)
				setElementRotation(vehicle, 0, 0, 270)
				setElementPosition(vehicle, 3674.6005859375, -1712.0306396484, 0.12999990582466)
				setVehicleFrozen(vehicle, true)
				setTimer(setVehicleFrozen, 100, 1, vehicle, false)
				fadeCamera ( false, 0.0, 0, 0, 0 )
				setCameraTarget ( getLocalPlayer() )
				setTimer(fadeCamera, 100, 1, true, 0.0, 0, 0, 0)
			end
		else
			setElementRotation(vehicle, 0, 0, 270)
			setElementPosition(vehicle, 3496.9262695313, -1345.3129882813, 0.17500001192093)
			setVehicleFrozen(vehicle, true)
			setTimer(setVehicleFrozen, 100, 1, vehicle, false)
		end
	elseif source == marker1b then
		local vehicle = getPedOccupiedVehicle(hitPlayer)
		if hitPlayer == getLocalPlayer() then
			if alreadydid2 == true and alreadydid3 == true and alreadydid4 == true then
				setElementPosition(vehicle, 3921.3994140625, -1709.599609375, 0)
				moveObject ( object1, 7000, 3950.6000976563, -1686.6999511719, -7.7999999523163 )
				moveObject ( object2, 7000, 3950.6000976563, -1698.5999755859, -7.7999999523163 )
				moveObject ( object3, 7000, 3950.6000976563, -1710.5999755859, -7.7999999523163 )
				moveObject ( object4, 7000, 3950.6000976563, -1722.5999755859, -7.7999999523163 )
			else
				setElementPosition(vehicle, 3675.6999511719, -1712.6999511719, 0.12999990582466)
			end
			alreadydid1 = true
			outputChatBox("#7A02BFYou succesfully completed this parcour!", 255, 255, 255, true)
			setElementRotation(vehicle, 0, 0, 270)
			setVehicleFrozen(vehicle, true)
			setTimer(setVehicleFrozen, 100, 1, vehicle, false)
			fadeCamera ( false, 0.0, 0, 0, 0 )
			setCameraTarget ( getLocalPlayer() )
			setTimer(fadeCamera, 100, 1, true, 0.0, 0, 0, 0)
		else
			setElementRotation(vehicle, 0, 0, 270)
			setElementPosition(vehicle, 3675.6999511719, -1712.6999511719, 0.12999990582466)
			setVehicleFrozen(vehicle, true)
			setTimer(setVehicleFrozen, 100, 1, vehicle, false)
		end
	elseif source == marker2a then
		local vehicle = getPedOccupiedVehicle(hitPlayer)
		if hitPlayer == getLocalPlayer() then
			if alreadydid2 == false then
				setElementRotation(vehicle, 0, 0, 90)
				setElementPosition(vehicle, 4138.2001953125, -2230.6000976563, 287.79998779297)
				setVehicleFrozen(vehicle, true)
				setTimer(setVehicleFrozen, 100, 1, vehicle, false)
				fadeCamera ( false, 0.0, 0, 0, 0 )
				setCameraTarget ( getLocalPlayer() )
				setTimer(fadeCamera, 100, 1, true, 0.0, 0, 0, 0)
			else
				outputChatBox("#7A02BFYou already did this parcour!", 255, 255, 255, true)
				setElementRotation(vehicle, 0, 0, 270)
				setElementPosition(vehicle, 3674.6005859375, -1712.0306396484, 0.12999990582466)
				setVehicleFrozen(vehicle, true)
				setTimer(setVehicleFrozen, 100, 1, vehicle, false)
				fadeCamera ( false, 0.0, 0, 0, 0 )
				setCameraTarget ( getLocalPlayer() )
				setTimer(fadeCamera, 100, 1, true, 0.0, 0, 0, 0)
			end
		else
			setElementRotation(vehicle, 0, 0, 90)
			setElementPosition(vehicle, 4138.2001953125, -2230.6000976563, 287.79998779297)
			setVehicleFrozen(vehicle, true)
			setTimer(setVehicleFrozen, 100, 1, vehicle, false)
		end
	elseif source == marker2b then
		local vehicle = getPedOccupiedVehicle(hitPlayer)
		if hitPlayer == getLocalPlayer() then
			if alreadydid1 == true and alreadydid3 == true and alreadydid4 == true then
				setElementPosition(vehicle, 3921.3994140625, -1709.599609375, 0)
				moveObject ( object1, 7000, 3950.6000976563, -1686.6999511719, -7.7999999523163 )
				moveObject ( object2, 7000, 3950.6000976563, -1698.5999755859, -7.7999999523163 )
				moveObject ( object3, 7000, 3950.6000976563, -1710.5999755859, -7.7999999523163 )
				moveObject ( object4, 7000, 3950.6000976563, -1722.5999755859, -7.7999999523163 )
			else
				setElementPosition(vehicle, 3675.6999511719, -1712.6999511719, 0.12999990582466)
			end
			alreadydid2 = true
			outputChatBox("#7A02BFYou succesfully completed this parcour!", 255, 255, 255, true)
			setElementRotation(vehicle, 0, 0, 270)
			setElementPosition(vehicle, 3675.6999511719, -1712.6999511719, 0.12999990582466)
			setVehicleFrozen(vehicle, true)
			setTimer(setVehicleFrozen, 100, 1, vehicle, false)
			fadeCamera ( false, 0.0, 0, 0, 0 )
			setCameraTarget ( getLocalPlayer() )
			setTimer(fadeCamera, 100, 1, true, 0.0, 0, 0, 0)
		else
			setElementRotation(vehicle, 0, 0, 270)
			setElementPosition(vehicle, 3675.6999511719, -1712.6999511719, 0.12999990582466)
			setVehicleFrozen(vehicle, true)
			setTimer(setVehicleFrozen, 100, 1, vehicle, false)
		end
	elseif source == marker3a then
		local vehicle = getPedOccupiedVehicle(hitPlayer)
		if hitPlayer == getLocalPlayer() then
			if alreadydid3 == false then
				setElementRotation(vehicle, 0, 0, 270)
				setElementPosition(vehicle, 3381.7470703125, -802.09222412109, -0.099999994039536)
				setVehicleFrozen(vehicle, true)
				setTimer(setVehicleFrozen, 100, 1, vehicle, false)
				fadeCamera ( false, 0.0, 0, 0, 0 )
				setCameraTarget ( getLocalPlayer() )
				setTimer(fadeCamera, 100, 1, true, 0.0, 0, 0, 0)
			else
				outputChatBox("#7A02BFYou already did this parcour!", 255, 255, 255, true)
				setElementRotation(vehicle, 0, 0, 270)
				setElementPosition(vehicle, 3674.6005859375, -1712.0306396484, 0.12999990582466)
				setVehicleFrozen(vehicle, true)
				setTimer(setVehicleFrozen, 100, 1, vehicle, false)
				fadeCamera ( false, 0.0, 0, 0, 0 )
				setCameraTarget ( getLocalPlayer() )
				setTimer(fadeCamera, 100, 1, true, 0.0, 0, 0, 0)
			end
		else
			setElementRotation(vehicle, 0, 0, 270)
			setElementPosition(vehicle, 3381.7470703125, -802.09222412109, -0.099999994039536)
			setVehicleFrozen(vehicle, true)
			setTimer(setVehicleFrozen, 100, 1, vehicle, false)
		end
	elseif source == marker3b then
		local vehicle = getPedOccupiedVehicle(hitPlayer)
		if hitPlayer == getLocalPlayer() then
			if alreadydid1 == true and alreadydid2 == true and alreadydid4 == true then
				setElementPosition(vehicle, 3921.3994140625, -1709.599609375, 0)
				moveObject ( object1, 7000, 3950.6000976563, -1686.6999511719, -7.7999999523163 )
				moveObject ( object2, 7000, 3950.6000976563, -1698.5999755859, -7.7999999523163 )
				moveObject ( object3, 7000, 3950.6000976563, -1710.5999755859, -7.7999999523163 )
				moveObject ( object4, 7000, 3950.6000976563, -1722.5999755859, -7.7999999523163 )
			else
				setElementPosition(vehicle, 3675.6999511719, -1712.6999511719, 0.12999990582466)
			end
			alreadydid3 = true
			outputChatBox("#7A02BFYou succesfully completed this parcour!", 255, 255, 255, true)
			setElementRotation(vehicle, 0, 0, 270)
			setVehicleFrozen(vehicle, true)
			setTimer(setVehicleFrozen, 100, 1, vehicle, false)
			fadeCamera ( false, 0.0, 0, 0, 0 )
			setCameraTarget ( getLocalPlayer() )
			setTimer(fadeCamera, 100, 1, true, 0.0, 0, 0, 0)
		else
			setElementRotation(vehicle, 0, 0, 270)
			setElementPosition(vehicle, 3675.6999511719, -1712.6999511719, 0.12999990582466)
			setVehicleFrozen(vehicle, true)
			setTimer(setVehicleFrozen, 100, 1, vehicle, false)
		end
	elseif source == marker4a then
		local vehicle = getPedOccupiedVehicle(hitPlayer)
		if hitPlayer == getLocalPlayer() then
			if alreadydid4 == false then
				setElementRotation(vehicle, 0, 0, 270)
				setElementPosition(vehicle, 3237.7734375, -328.541015625, -0.024999996647239)
				setVehicleFrozen(vehicle, true)
				setTimer(setVehicleFrozen, 100, 1, vehicle, false)
				fadeCamera ( false, 0.0, 0, 0, 0 )
				setCameraTarget ( getLocalPlayer() )
				setTimer(fadeCamera, 100, 1, true, 0.0, 0, 0, 0)
			else
				outputChatBox("#7A02BFYou already did this parcour!", 255, 255, 255, true)
				setElementRotation(vehicle, 0, 0, 270)
				setElementPosition(vehicle, 3674.6005859375, -1712.0306396484, 0.12999990582466)
				setVehicleFrozen(vehicle, true)
				setTimer(setVehicleFrozen, 100, 1, vehicle, false)
				fadeCamera ( false, 0.0, 0, 0, 0 )
				setCameraTarget ( getLocalPlayer() )
				setTimer(fadeCamera, 100, 1, true, 0.0, 0, 0, 0)
			end
		else
			setElementRotation(vehicle, 0, 0, 270)
			setElementPosition(vehicle, 3237.7734375, -328.541015625, -0.024999996647239)
			setVehicleFrozen(vehicle, true)
			setTimer(setVehicleFrozen, 100, 1, vehicle, false)
		end
	elseif source == marker4b then
		local vehicle = getPedOccupiedVehicle(hitPlayer)
		if hitPlayer == getLocalPlayer() then
			if alreadydid1 == true and alreadydid2 == true and alreadydid3 == true then
				setElementPosition(vehicle, 3921.3994140625, -1709.599609375, 0)
				moveObject ( object1, 7000, 3950.6000976563, -1686.6999511719, -7.7999999523163 )
				moveObject ( object2, 7000, 3950.6000976563, -1698.5999755859, -7.7999999523163 )
				moveObject ( object3, 7000, 3950.6000976563, -1710.5999755859, -7.7999999523163 )
				moveObject ( object4, 7000, 3950.6000976563, -1722.5999755859, -7.7999999523163 )
			else
				setElementPosition(vehicle, 3675.6999511719, -1712.6999511719, 0.12999990582466)
			end
			alreadydid4 = true
			outputChatBox("#7A02BFYou succesfully completed this parcour!", 255, 255, 255, true)
			setElementRotation(vehicle, 0, 0, 270)
			setVehicleFrozen(vehicle, true)
			setTimer(setVehicleFrozen, 100, 1, vehicle, false)
			fadeCamera ( false, 0.0, 0, 0, 0 )
			setCameraTarget ( getLocalPlayer() )
			setTimer(fadeCamera, 100, 1, true, 0.0, 0, 0, 0)
		else
			setElementRotation(vehicle, 0, 0, 270)
			setElementPosition(vehicle, 3675.6999511719, -1712.6999511719, 0.12999990582466)
			setVehicleFrozen(vehicle, true)
			setTimer(setVehicleFrozen, 100, 1, vehicle, false)
		end

	elseif source == marker5a then
		local vehicle = getPedOccupiedVehicle(hitPlayer)
		if hitPlayer == getLocalPlayer() then
			if (alreadydid1 == true or alreadydid1 == false) and (alreadydid2 == true or alreadydid2 == false) and (alreadydid3 == true or alreadydid3 == false) and (alreadydid4 == true or alreadydid4 == false) then
				setElementRotation(vehicle, 0, 0, 270)
				setElementPosition(vehicle, 4179.2568359375, -1705.4285888672, 3051.9831542969)
				setVehicleFrozen(vehicle, true)
				setTimer(setVehicleFrozen, 100, 1, vehicle, false)
				fadeCamera ( false, 0.0, 0, 0, 0 )
				setCameraTarget ( getLocalPlayer() )
				setTimer(fadeCamera, 100, 1, true, 0.0, 0, 0, 0)
			else
				outputChatBox("#7A02BFYou have to do all parcours!", 255, 255, 255, true)
				setElementRotation(vehicle, 0, 0, 270)
				setElementPosition(vehicle, 3674.6005859375, -1712.0306396484, 0.12999990582466)
				setVehicleFrozen(vehicle, true)
				setTimer(setVehicleFrozen, 100, 1, vehicle, false)
				fadeCamera ( false, 0.0, 0, 0, 0 )
				setCameraTarget ( getLocalPlayer() )
				setTimer(fadeCamera, 100, 1, true, 0.0, 0, 0, 0)
			end
		else
			setElementRotation(vehicle, 0, 0, 270)
			setElementPosition(vehicle, 4179.2568359375, -1705.4285888672, 3051.9831542969)
			setVehicleFrozen(vehicle, true)
			setTimer(setVehicleFrozen, 100, 1, vehicle, false)
		end
	elseif source == marker6 then
		local vehicle = getPedOccupiedVehicle(hitPlayer)
		if hitPlayer == getLocalPlayer() then
			x1, y1, z1 = getElementRotation(vehicle)
			getTickStart = getTickCount()
			count = 0
			setVehicleFrozen(vehicle, true)
			addEventHandler ( "onClientPreRender", getRootElement(), somethingfor )
		else
			setVehicleFrozen(vehicle, true)
			setTimer(setVehicleFrozen, 5000, 1, vehicle, false)
		end
	elseif source == jump5 then
		local vehicle = getPedOccupiedVehicle(hitPlayer)
		setElementRotation(vehicle, 0, 0, 0)
		setElementPosition(vehicle, 5941.4887695313, -1282.4050292969, 6.088677406311)
		setVehicleFrozen(vehicle, true)
		setTimer(setVehicleFrozen, 100, 1, vehicle, false)
		speedx, speedy, speedz = getElementVelocity(vehicle)
		setElementVelocity(vehicle, 1, 0, speedz+1.2)
		playSound("boing.wav")
	end
end
addEventHandler ( "onClientMarkerHit", resourceRoot, markerHit )

function somethingfor()
	vehicle = getPedOccupiedVehicle(getLocalPlayer())
	if (getTickCount() - getTickStart <= 4000) then
		if count == 0 then
			--sound3 = playSound( "3.mp3", false )
			count = 1
		end
		local elapsedTime = getTickCount() - (getTickStart)
		local duration = (getTickStart+4000) - (getTickStart)
		local progress = elapsedTime / duration
		if x1 >= 180 then
			a = 360
		else
			a = 0
		end
		if y1 >= 270 then
			b = 450
		else
			b = 90
		end
		if z1 >= 90 then
			c = 270
		else
			c = -90
		end
		local x2, y2, z2 = interpolateBetween ( 
			x1, y1, z1,
			a, b, c,
			progress, "InOutQuad")-- 0 , 90 , 270
		setElementPosition(vehicle, 4178.7397460938, -1705.4927978516, 2989.4790039063)
		setElementRotation(vehicle, x2, y2, z2)
	elseif getTickCount() - getTickStart <= 5000 then
		setElementRotation(vehicle, 0, 90, 270)
	elseif getTickCount() - getTickStart > 5000 then
		setVehicleFrozen( vehicle, false)
		setElementVelocity(vehicle, 5, 0, 0)
		removeEventHandler ( "onClientPreRender", root, somethingfor )
	end
end