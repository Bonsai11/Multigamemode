local ID_LIST = {}

function generateNewID()

	for i, p in ipairs(ID_LIST) do 
	
		if not isElement(p) then
		
			return i 
			
		end
	
	end

	return #ID_LIST+1

end


function getID()

	local id = generateNewID()
	setElementData(source, "id", id)
	ID_LIST[id] = source

end
addEventHandler("onPlayerJoin", root, getID)


function getPlayerByID(id) 

	return ID_LIST[id]

end