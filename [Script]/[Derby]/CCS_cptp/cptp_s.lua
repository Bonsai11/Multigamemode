addEvent('onSyncModel', true)
addEventHandler('onSyncModel', resourceRoot,
    function(model)
	
		if not getPedOccupiedVehicle(source) then return end
		
        setElementModel(getPedOccupiedVehicle(source), model)
		
    end
)