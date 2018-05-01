Util = {}

function math.round(num, idp)

	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult

end
export_round = math.round


function table.contains(table, element)

	for _, value in pairs(table) do

		if value == element then
			return true
		end

	end

	return false

end
export_table_contains = table.contains


function table.copy(tab, recursive)

    local ret = {}
    for key, value in pairs(tab) do
        if (type(value) == "table") and recursive then ret[key] = table.copy(value)
        else ret[key] = value end
    end
    return ret

end
export_table_copy = table.copy


function msToTime(ms, includeMilliseconds)

	if not ms then return false end

	if includeMilliseconds then
	
		local centiseconds = math.floor(math.fmod(ms, 1000))
		local seconds = math.fmod(math.floor(ms / 1000), 60)
		local minutes = math.floor(math.floor(ms / 1000) / 60)

		return string.format("%02d:%02d:%03d", minutes, seconds, centiseconds)
		
	else
	
		local centiseconds = math.floor(math.fmod(ms, 1000)/10)
		local seconds = math.fmod(math.floor(ms / 1000), 60)
		local minutes = math.floor(math.floor(ms / 1000) / 60)

		return string.format("%02d:%02d:%02d", minutes, seconds, centiseconds)
		
	end
	
end
export_msToTime = msToTime


function msToHourTime(ms)

	if not ms then return false end

	local minutes = math.fmod(math.floor(ms / (1000 * 60)), 60)
	local hours = math.fmod(math.floor(ms / (1000 * 60 * 60)), 24)
	local days = math.floor(ms / (1000 * 60 * 60 * 24))

	return string.format("%01d days, %02dh, %02dm", days, hours, minutes)

end
export_msToHourTime = msToHourTime


function msToHourMinuteSecond(ms)

	if not ms then return false end

	local seconds = math.fmod(math.floor(ms / 1000), 60)
	local minutes = math.fmod(math.floor(ms / (1000 * 60)), 60)
	local hours = math.fmod(math.floor(ms / (1000 * 60 * 60)), 24)

	return string.format("%01dh %02dm %02ds", hours, minutes, seconds)

end
export_msToHourMinuteSecond = msToHourMinuteSecond


function getElementSpeed(element,unit)

	if (unit == nil) then unit = 0 end
	if (isElement(element)) then
		local x,y,z = getElementVelocity(element)
		return (x^2 + y^2 + z^2) ^ 0.5 * 1.61 * 100
	else
		return 0
	end

end
export_getElementSpeed = getElementSpeed


function setElementSpeed(element, unit, speed)

	if (unit == nil) then unit = 0 end
	if (speed == nil) then speed = 0 end
	speed = tonumber(speed)
	local acSpeed = getElementSpeed(element, unit)

	if acSpeed ~= false and acSpeed ~= 0 then

		local diff = speed/acSpeed
		local x,y,z = getElementVelocity(element)
		setElementVelocity(element,x*diff,y*diff,z*diff)
		return true

	end

	return false

end


function Util.hex2rgb(hex)

    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))

end
export_hex2rgb = Util.hex2rgb
