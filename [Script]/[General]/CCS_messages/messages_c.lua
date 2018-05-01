Messages = {}
Messages.lists = {}
Messages.lists["left"] = {}
Messages.lists["right"] = {}
Messages.x, Messages.y = guiGetScreenSize()
Messages.relX, Messages.relY =  (Messages.x/800), (Messages.y/600)
Messages.font = "default-bold"
Messages.fontSize = 1
Messages.positionX = (2 * Messages.relX)
Messages.positionY = (300 * Messages.relY)
Messages.offset = (2 * Messages.relY)
Messages.height = dxGetFontHeight(Messages.fontSize, Messages.font) * 1.2
Messages.life = 5000
Messages.fadeSpeed = 0.5
Messages.delta = 0
Messages.lastTick = nil
Messages.lastCount = 0
Messages.show = true

function Messages.create(message, align)

	if not align then
	
		align = "left"
		
	end

	local length = dxGetTextWidth(message.." ", Messages.fontSize, Messages.font, true)

	table.insert(Messages.lists[align], 1, {text = message, time = getTickCount(), width = length, alpha = 0, align = align})
	
end
addEvent("onClientCreateMessage", true)
addEventHandler("onClientCreateMessage", root, Messages.create)


function Messages.toggle()

	Messages.show = not Messages.show

end
addCommandHandler("showmessages", Messages.toggle)


function Messages.render()

	if not Messages.show then return end

	if Messages.lastTick then
	
			Messages.delta = getTickCount() - Messages.lastTick
			Messages.delta = math.min(Messages.delta, (1/60)*1000)
		
	end
			
	Messages.lastTick = getTickCount()

	for i, list in pairs(Messages.lists) do

		for j, message in ipairs(list) do
			
			local posY = Messages.positionY + (Messages.height + Messages.offset)*(j-1)
				
			if message.align == "right" then
			
				dxDrawRectangle(Messages.x - message.width, posY, message.width, Messages.height, tocolor(0, 0, 0, message.alpha * (100/255)))
				
			else
			
				dxDrawRectangle(Messages.positionX, posY, message.width, Messages.height, tocolor(0, 0, 0, message.alpha * (100/255)))
			
			end

			dxDrawText(message.text:gsub("#%x%x%x%x%x%x", ""), Messages.positionX+1, posY+1, Messages.x+1, posY + Messages.height+1, tocolor(0, 0, 0, message.alpha), Messages.fontSize, Messages.font, message.align, "center", true, false, false, false, false)
			dxDrawText(message.text, Messages.positionX, posY, Messages.x, posY + Messages.height, tocolor(255, 255, 255, message.alpha), Messages.fontSize, Messages.font, message.align, "center", true, false, false, true, false)

			if getTickCount() - message.time > Messages.life then

				message.alpha = message.alpha - (Messages.fadeSpeed * Messages.delta)
			
				if message.alpha <= 0 then
					
					message.alpha = 0
					table.remove(list, #list)
					
				end

			else
			
				message.alpha = message.alpha + (Messages.fadeSpeed * Messages.delta)
			
				if message.alpha > 255 then
				
					message.alpha = 255
					
				end
			
			end
		
		end
	
	end

end
addEventHandler("onClientRender", root, Messages.render)