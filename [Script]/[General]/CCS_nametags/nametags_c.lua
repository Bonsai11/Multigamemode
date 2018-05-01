local nametag = {}
local nametags = {}
local g_screenX,g_screenY = guiGetScreenSize()
local bHideNametags = false
local element
local NAMETAG_ALPHA_DISTANCE = 50 
local NAMETAG_DISTANCE = 120 
local NAMETAG_ALPHA = 120 
local NAMETAG_TEXT_BAR_SPACE = 2
local NAMETAG_WIDTH = 50
local NAMETAG_HEIGHT = 5
local NAMETAG_TEXTSIZE = 0.7
local NAMETAG_OUTLINE_THICKNESS = 0.6
local NAMETAG_ALPHA_DIFF = NAMETAG_DISTANCE - NAMETAG_ALPHA_DISTANCE
local NAMETAG_SCALE = 1/0.3  * 800 / g_screenY 
local maxScaleCurve = { {0, 0}, {3, 3}, {13, 5} }
local textScaleCurve = { {0, 0.8}, {0.8, 1.2}, {99, 99} }
local textAlphaCurve = { {0, 0}, {25, 100}, {120, 190}, {255, 190} }
local avatarWidth = 216/14
local avatarHeight = 274/14

addEventHandler ( "onClientRender", root,
	function()

		if bHideNametags then
			return
		end
		
		local x,y,z = getCameraMatrix()
		
		for _, player in pairs(getElementsByType("player")) do 
		
			setPlayerNametagShowing(player, false)
		
			while true do
			
				if getElementData(localPlayer, "state") == "Alive" and getElementData(getElementParent(localPlayer), "hideNicknames") then break end
			
				if player == localPlayer then break end
			
				if getElementData(player, "state") ~= "Alive" and getElementData(player, "state") ~= "Respawned" then break end
				
				if getElementParent(player) ~= getElementParent(localPlayer) then break end
				
				if getElementDimension(player) ~= getElementDimension(localPlayer) then break end
				
				local vehicle = getPedOccupiedVehicle(player)
				
				local px,py,pz
				
				if vehicle then
				
					px,py,pz = getElementPosition (vehicle)
				
				else
				
					px,py,pz = getElementPosition (player)
					
				end
				
				local pdistance = getDistanceBetweenPoints3D ( x,y,z,px,py,pz )
				if pdistance <= NAMETAG_DISTANCE then
					--Get screenposition
					local sx,sy = getScreenFromWorldPosition ( px, py, pz+0.95, 0.06 )
					if not sx or not sy then break end
					--Calculate our components
					local scale = 1/(NAMETAG_SCALE * (pdistance / NAMETAG_DISTANCE))
					local alpha = ((pdistance - NAMETAG_ALPHA_DISTANCE) / NAMETAG_ALPHA_DIFF)
					alpha = (alpha < 0) and NAMETAG_ALPHA or NAMETAG_ALPHA-(alpha*NAMETAG_ALPHA)
					scale = math.evalCurve(maxScaleCurve,scale)
					local textscale = math.evalCurve(textScaleCurve,scale)
					local textalpha = math.evalCurve(textAlphaCurve,alpha)
					local outlineThickness = NAMETAG_OUTLINE_THICKNESS*(scale)
					--Draw our text
					local r,g,b = 255,255,255
					local team = getPlayerTeam(player)
					if team then
						r,g,b = getTeamColor(team)
					end
					local offset = (scale) * NAMETAG_TEXT_BAR_SPACE/2
					
					if getElementAlpha(player) ~= 255 then
					
						alpha = getElementAlpha(player)
						textalpha = getElementAlpha(player)
					
					end
					
					dxDrawText ( string.gsub(getPlayerName(player), '#%x%x%x%x%x%x', ''), sx+1, sy - offset+1, sx+1, sy - offset+1, tocolor(0,0,0,textalpha), textscale*NAMETAG_TEXTSIZE, "default", "center", "bottom", false, false, false, false)
					dxDrawText ( getPlayerName(player), sx, sy - offset, sx, sy - offset, tocolor(r,g,b,textalpha), textscale*NAMETAG_TEXTSIZE, "default", "center", "bottom", false, false, false, true)
					
					--We draw three parts to make the healthbar.  First the outline/background
					local drawX = sx - NAMETAG_WIDTH*scale/2
					drawY = sy + offset
					local width,height =  NAMETAG_WIDTH*scale, NAMETAG_HEIGHT*scale
					
					dxDrawRectangle ( drawX, drawY, width, height, tocolor(0,0,0,alpha) )
					--Next the inner background 
					
					local health
					
					if vehicle then
					
						health = getElementHealth(vehicle)
						health = math.max(health - 250, 0)
					
					else
					
						health = getElementHealth(player)
						health = health * 7.5
					
					end
					
					health = health/750
					local p = -510*(health^2)
					local r,g = math.max(math.min(p + 255*health + 255, 255), 0), math.max(math.min(p + 765*health, 255), 0)
					
					dxDrawRectangle ( 	drawX + outlineThickness, 
										drawY + outlineThickness, 
										width - outlineThickness*2, 
										height - outlineThickness*2, 
										tocolor(r,g,0,0.4*alpha) 
									)
					--Finally, the actual health
					dxDrawRectangle ( 	drawX + outlineThickness, 
										drawY + outlineThickness, 
										health*(width - outlineThickness*2), 
										height - outlineThickness*2, 
										tocolor(r,g,0,alpha) 
									)			
				end
				break
			end
		end
	end
)



addEvent ( "onClientScreenFadedOut", true )
addEventHandler ( "onClientScreenFadedOut", root,
	function()
		bHideNametags = true
	end
)

addEvent ( "onClientScreenFadedIn", true )
addEventHandler ( "onClientScreenFadedIn", root,
	function()
		bHideNametags = false
	end
)


function math.evalCurve( curve, input )

	if input<curve[1][1] then
		return curve[1][2]
	end

	for idx=2,#curve do
		if input<curve[idx][1] then
			local x1 = curve[idx-1][1]
			local y1 = curve[idx-1][2]
			local x2 = curve[idx][1]
			local y2 = curve[idx][2]
		
			local alpha = (input - x1)/(x2 - x1);
		
			return math.lerp(y1,y2,alpha)
		end
	end

	return curve[#curve][2]
end


function math.lerp(from,to,alpha)
    return from + (to-from) * alpha
end