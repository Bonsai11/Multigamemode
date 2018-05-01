--
-- dxscoreboard_rt.lua
--
-- Scoreboard render target support stuff
--

local rtShader
local rt
local lastUpdateTime = 0


addEventHandler( "onClientResourceStart", resourceRoot, 
	function ( resource )
		rtShader = dxCreateShader ( "rt_blend.fx" )
	end
)


-- drawScoreboard
--		Do things depending on things
function drawScoreboard()
	cursorCache = {}
	if #savedRowsNext > 0 then
		savedRows = savedRowsNext
		savedRowsNext = {}
	end

	if not scoreboardDrawn then
		doDrawScoreboard ( false--[[rtPass]], true--[[onlyAnim]], guiGetScreenSize() )
		bForceUpdate = true
		return
	end

	-- Update once every 1000ms
	local bUpdate = false
	if getTickCount() - lastUpdateTime > 1000 or bForceUpdate then
		bUpdate = true
		bForceUpdate = false
		lastUpdateTime = getTickCount()
	end

	-- Determine if new rt is needed
	local sX, sY = getRequiredRtSize()
	if rt then
		local rX, rY = dxGetMaterialSize( rt )
		if sX ~= rX or sY ~= rY then
			destroyElement( rt )
			rt = nil
		end
	end

	-- Try to create rt if needed
	if not rt then
		rt = dxCreateRenderTarget( sX, sY, true )
		bUpdate = true
	end

	-- No rt then use standard drawing (hold num_9 to test)
	if not rt or getKeyState("num_9") then
		doDrawScoreboard ( false --[[rtPass]], false --[[onlyAnim]], guiGetScreenSize() )
		return
	end

	-- See if highlighted row will change
	local newRowIdx = getCursorOverRow(true)
	if newRowIdx ~= lastRowIdx then
		-- Force rt update if highlighted row will change
		lastRowIdx = newRowIdx
		bUpdate = true
	end

	-- Draw background to screen
	doDrawScoreboard ( true --[[rtPass]], true --[[onlyAnim]], guiGetScreenSize() )

	-- Update to rt
	if bUpdate then
		dxSetRenderTarget ( rt, true )

		-- Save drawOverGUI settings
		local drawOverGUISaved = drawOverGUI
		drawOverGUI = false

		-- Draw all text to rt
		doDrawScoreboard ( true --[[rtPass]], false --[[onlyAnim]], getRequiredRtSize() )

		-- Restore drawOverGUI settings
		drawOverGUI = drawOverGUISaved

		dxSetRenderTarget ()
	end

    -- If no text drawn then we are done
	if not scoreboardDrawn then
		return
	end

	-- Draw rt
	local x, y = scoreboardGetTopCornerPosition()

	dxSetShaderValue( rtShader, "sTexture0", rt );
	dxDrawImage( x, y, sX, sY, rtShader, 0, 0, 0, tocolor(255,255,255), drawOverGUI )
end


-- Calc required render target size
--		Includes extra 15 pixels top and bottom for the scroll buttons
function getRequiredRtSize()
	local sX, sY = calculateWidth(), calculateHeight()
	if not sX then
		sX, sY = guiGetScreenSize()
	else
		sY = sY + 30
	end
	return math.floor(sX), math.floor(sY)
end


-- Adjust cursor position if using rt
cursorCache = {}
function getCursorScoreboardPosition(rtPass)
	if #cursorCache == 0 then
		local cX, cY = getCursorPosition()
		local sX, sY = guiGetScreenSize()
		cX, cY = cX*sX, cY*sY
		if rtPass then
			local x, y = scoreboardGetTopCornerPosition()
			cX, cY = cX-x, cY-y
		end
		cursorCache = { cX, cY }
	end
	return unpack(cursorCache)
end


savedRowsNext = {}
savedRows = {}
-- Return true is cursor is inside bounds
--		Also saves row data to check if highlighted row is changing between rt updates
function checkCursorOverRow( rtPass, xl,xh,yl,yh )
	if isCursorShowing() then
		savedRowsNext[#savedRowsNext + 1] = { xl,xh,yl,yh }
		local cX, cY = getCursorScoreboardPosition( rtPass )
		if cX >= xl and cX <= xh and cY >= yl and cY <= yh then
			return true
		end
	end
	return false
end

-- Return index of the row the cursor is hovering over
function getCursorOverRow(rtPass)
	if isCursorShowing() then
		local cX, cY = getCursorScoreboardPosition( rtPass )
		for idx,row in ipairs(savedRows) do
			if cX >= row[1] and cX <= row[2] and cY >= row[3] and cY <= row[4] then
				return idx
			end
		end
	end
	return false
end


