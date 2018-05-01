Announcement = {}
Announcement.staticMessage = {}

function Announcement.dynamicAnnounce(p, c, ...) 

	local arenaElement = getElementParent(p)

	local message = table.concat({...}," ")
	
	if #message:gsub(" ", "") == 0 then return end
	
	triggerClientEvent(arenaElement, "onClientAnnouncementCreate", arenaElement, "dynamic", message)

end
addCommandHandler("dannounce", Announcement.dynamicAnnounce)


function Announcement.staticAnnounce(p, c, ...)

	local arenaElement = getElementParent(p)

	local message = table.concat({...}," ")
	
	if #message:gsub(" ", "") == 0 then return end
	
	Announcement.staticMessage[arenaElement] = {}
	
	table.insert(Announcement.staticMessage[arenaElement], message)
	
	triggerClientEvent(arenaElement, "onClientAnnouncementCreate", arenaElement, "static", message, true)

end
addCommandHandler("sannounce", Announcement.staticAnnounce)


function Announcement.resetAnnounce(p, c)

	local arenaElement = getElementParent(p)

	Announcement.staticMessage[arenaElement] = nil
	
	triggerClientEvent(arenaElement, "onClientAnnouncementReset", arenaElement)

end
addCommandHandler("rannounce", Announcement.resetAnnounce)


function Announcement.request()

	local arenaElement = getElementParent(source)
	
	local message
	local mode
	
	if Announcement.staticMessage[arenaElement] then
	
		message = Announcement.staticMessage[arenaElement][1]
		
		mode = "static"
		
	else
	
		local arena = getElementID(arenaElement, "name")
	
		local color = getElementData(arenaElement, "color") or "#ffffff"
	
		message = "Welcome to "..color..arena.."#ffffff Arena. Have fun!"
	
		mode = "dynamic"
	
	end

	triggerClientEvent(source, "onClientAnnouncementCreate", arenaElement, mode, message)

end
addEvent("onAnnouncementRequest", true)
addEventHandler("onAnnouncementRequest", root, Announcement.request)