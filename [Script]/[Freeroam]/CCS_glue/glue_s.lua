Glue = {}

function Glue.attach(vehicle, x, y, z, rotX, rotY, rotZ)

	attachElements(source, vehicle, x, y, z, rotX, rotY, rotZ)
	
end
addEvent("onPlayerGlue", true)
addEventHandler("onPlayerGlue", root, Glue.attach)


function Glue.detach()

	detachElements(source)
	
end
addEvent("onPlayerUnglue", true)
addEventHandler("onPlayerUnglue", root, Glue.detach)