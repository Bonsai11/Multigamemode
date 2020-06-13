screenX, screenY = guiGetScreenSize()
ratioX, ratioY = (screenX / 800), (screenY / 600)
startX = 800 * ratioX
startY = 200 * ratioY
endX = nil
endY = startY
positionX = startX
positionY = startY
leaderboardWidth = 0
toggleDelay = nil
leaderboard = {}
isAnimating = false
animationStartTime = nil
animationEndTime = nil
tableColumns = {}
isToggled = false
isClientReady = false
personalRecord = false
isAlreadyShown = false

TOGGLE_KEY = "F5"
ANIMATION_NAME = "InOutQuad"
LEADERBOARD_OFFSET = 20 * ratioY
TOGGLE_DURATION = 5000
ROWS_TO_SHOW = 8
ROW_FONT_SIZE = 1
ROW_FONT_COLOR = tocolor(200, 200, 200, 255)
ROW_BACKGROUND_COLOR = tocolor(22, 28, 32, 225)
ROW_PADDING_START = 0
ROW_PADDING_END = 7.5 * ratioX
ROW_PADDING_Y = 3 * ratioY
ROW_FONT = dxCreateFont(":CCS_toptimes/fonts/Inter-UI-Regular.ttf", math.floor(8 * ratioY))
ROW_SIZE = dxGetFontHeight(ROW_FONT_SIZE, ROW_FONT) + ROW_PADDING_Y
COLUMN_HEIGHT_MULTIPLIER = 1.15
COLUMN_FONT_SIZE = 1
COLUMN_FONT = dxCreateFont(":CCS_toptimes/fonts/Inter-UI-Medium.ttf", math.floor(7 * ratioY))
COLUMN_BACKGROUND_COLOR = tocolor(14, 23, 26, 240)
COLUMN_FONT_COLOR = tocolor(255, 255, 255, 255)
BORDER_SIZE = 3
BORDER_LEFT_COLOR_HIGHLIGHT = tocolor(64, 196, 255, 255)
HIGHLIGHT_IMAGE_PATH = ":CCS_toptimes/images/gradient_highlight.png"

Leaderboard = {}
Leaderboard.flags = {
	"AD", "AE", "AF", "AG", "AI", "AL", "AM", "AN", "AO", "AR", "AS", "AT", "AU", "AW", "AX", "AZ",
	"BA", "BB", "BD", "BE", "BF", "BG", "BH", "BI", "BJ", "BL", "BM", "BN", "BO", "BR", "BS", "BT",
	"BW", "BY", "BZ", "CA", "CD", "CF", "CG", "CH", "CI", "CK", "CL", "CM", "CN", "CO", "CR", "CU",
	"CV", "CW", "CY", "CZ", "DE", "DJ", "DK", "DM", "DO", "DZ", "EC", "EE", "EG", "EH", "ER", "ES",
	"ET", "EU", "FI", "FJ", "FK", "FM", "FO", "FR", "GA", "GB", "GD", "GE", "GG", "GH", "GI", "GL",
	"GM", "GN", "GQ", "GR", "GS", "GT", "GU", "GW", "GY", "HK", "HN", "HR", "HT", "HU", "IC", "ID",
	"IE", "IL", "IM", "IN", "IQ", "IR", "IS", "IT", "JE", "JM", "JO", "JP", "KE", "KG", "KH", "KI",
	"KM", "KN", "KP", "KR", "KW", "KY", "KZ", "LA", "LB", "LC", "LI", "LK", "LR", "LS", "LT", "LU",
	"LV", "LY", "MA", "MC", "MD", "ME", "MF", "MG", "MH", "MK", "ML", "MM", "MN", "MO", "MP", "MQ",
	"MR", "MS", "MT", "MU", "MV", "MW", "MX", "MY", "MZ", "NA", "NC", "NE", "NF", "NG", "NI", "NL",
	"NO", "NP", "NR", "NU", "NZ", "OM", "PA", "PE", "PF", "PG", "PH", "PK", "PL", "PN", "PR", "PS",
	"PT", "PW", "PY", "QA", "RO", "RS", "RU", "RW", "SA", "SB", "SC", "SD", "SE", "SG", "SH", "SI",
	"SK", "SL", "SM", "SN", "SO", "SR", "SS", "ST", "SV", "SY", "SZ", "TC", "TD", "TF", "TG", "TH",
	"TJ", "TK", "TL", "TM", "TN", "TO", "TR", "TT", "TV", "TW", "TZ", "UA", "UG", "US", "UY", "UZ",
	"VA", "VC", "VE", "VG", "VI", "VN", "VU", "WF", "WS", "YE", "YT", "ZA", "ZM", "ZW", "XX"
}

function Leaderboard.main()
	Leaderboard.addColumn({
		title = "Rank", 
		width = dxGetTextWidth("_XX_.", ROW_FONT_SIZE, ROW_FONT),
		computed = function(row, index)
			return index and index.."." or "—"
		end,
		alignX = nil,
		alignY = nil,
		rowAlignX = "center",
		rowAlignY = nil,
		isColorCoded = nil,
		isUpperCase = nil,
		isImage = true, 
		imagePath = ":CCS_toptimes/images/rank.png", 
		imageSize = 12,
		isValueImage = false,
		rowImageSize = nil,
		isImageCentered = true
	})

	Leaderboard.addColumn({
		title = "Nickname", 
		width = dxGetTextWidth("_XXXXXXXXXXXXXXX_", ROW_FONT_SIZE, ROW_FONT),
		computed = function(row)
			return row and row.nickname or "Empty"
		end
	})

	Leaderboard.addColumn({
		title = "Kills",
		width = dxGetTextWidth("_00:00:000___", ROW_FONT_SIZE, ROW_FONT),
		computed = function(row)
			return row and row.kills or "—"
		end
	})

	Leaderboard.addColumn({
		title = "Date",
		width = dxGetTextWidth("_XXXX.XX.XX__", ROW_FONT_SIZE, ROW_FONT),
		computed = function(row)
			return row and Leaderboard.convertDate(row.date) or "—"
		end
	})

	Leaderboard.addColumn({
		title = "Country",
		width = math.floor(12 * ratioY) + (tableColumns[1].width / 2),
		computed = function(row)
			if not row or not row.country then return "XX" end
			return Leaderboard.flags[row.country] and row.country or "XX"
		end,
		alignX = nil,
		alignY = nil,
		rowAlignX = nil,
		rowAlignY = nil,
		isColorCoded = nil,
		isUpperCase = nil,
		isImage = true,
		imagePath = ":CCS_toptimes/images/country.png",
		imageSize = 12,
		isValueImage = true,
		rowImageSize = 13.5,
		isImageCentered = false
	})

	for i, column in pairs(tableColumns) do
		leaderboardWidth = leaderboardWidth + column.width
	end

	leaderboardWidth = leaderboardWidth
	endX = startX - leaderboardWidth - LEADERBOARD_OFFSET
	
	for i, flag in ipairs(Leaderboard.flags) do
		Leaderboard.flags[flag] = i-1
	end	
end
addEventHandler("onClientResourceStart", resourceRoot, Leaderboard.main)

function Leaderboard.render()
	local arena = getElementParent(localPlayer)
	local map = getElementData(arena, "map")

	if not map then return end

	local currentX = positionX + ROW_PADDING_START
	local currentY = positionY

	dxDrawRectangle(currentX - ROW_PADDING_START, currentY, leaderboardWidth, ROW_SIZE * COLUMN_HEIGHT_MULTIPLIER, COLUMN_BACKGROUND_COLOR)
	
	for i, column in pairs(tableColumns) do
		local title = column.isUpperCase and column.title:upper() or column.title

		if column.isImage then
			local imageSize = math.floor(column.imageSize * ratioY)

			if column.isImageCentered then
				dxDrawImage(currentX + ((column.rowImageSize - column.imageSize) / 2) + (column.width / 2) - (column.imageSize / 2), currentY + ((ROW_SIZE * COLUMN_HEIGHT_MULTIPLIER) / 2) - (imageSize / 2), imageSize, imageSize, column.imagePath)
			else
				dxDrawImage(currentX + ((column.rowImageSize - column.imageSize) / 2), currentY + ((ROW_SIZE * COLUMN_HEIGHT_MULTIPLIER) / 2) - (imageSize / 2), imageSize, imageSize, column.imagePath)
			end
		else
			dxDrawText(title, currentX, currentY, currentX + column.width, currentY + ROW_SIZE * COLUMN_HEIGHT_MULTIPLIER, COLUMN_FONT_COLOR, COLUMN_FONT_SIZE, COLUMN_FONT, column.alignX, column.alignY, false, false, false, column.isColorCoded, false)
		end

		currentX = currentX + column.width
	end

	currentY = currentY + ROW_SIZE * COLUMN_HEIGHT_MULTIPLIER - ROW_SIZE

	for i = 1, ROWS_TO_SHOW, 1 do
		currentX = positionX
		currentY = currentY + ROW_SIZE

		if personalRecord and tonumber(personalRecord.rank) == i then
			dxDrawImage(currentX, currentY, leaderboardWidth, ROW_SIZE, HIGHLIGHT_IMAGE_PATH)
			dxDrawRectangle(currentX, currentY, BORDER_SIZE, ROW_SIZE, BORDER_LEFT_COLOR_HIGHLIGHT)
		else
			dxDrawRectangle(currentX, currentY, leaderboardWidth, ROW_SIZE, ROW_BACKGROUND_COLOR)
		end

		currentX = currentX + ROW_PADDING_START 

		for j, column in pairs(tableColumns) do
			local value = column.computed(leaderboard[i], i)
			if column.isValueImage then
				local flagIndex = Leaderboard.flags[value]
				local flagRow = flagIndex % 16
				local flagColumn = math.floor(flagIndex / 16)
				local imageSize = math.floor(column.rowImageSize * ratioY)
				dxDrawImageSection(currentX, currentY + (ROW_SIZE / 2) - (imageSize / 2), imageSize, imageSize, (48) * flagRow, (48) * flagColumn, 48, 48, ":CCS/img/flags.png")
			else
				value = Leaderboard.textOverflow(value, ROW_FONT_SIZE, ROW_FONT, column.width, true)

				if column.isImage then
					dxDrawText(value, currentX + (column.imageSize / 2), currentY, currentX + column.width, currentY + ROW_SIZE, ROW_FONT_COLOR, ROW_FONT_SIZE, ROW_FONT, column.rowAlignX, column.rowAlignY, false, false, false, true, false)
				else
					dxDrawText(value, currentX, currentY, currentX + column.width, currentY + ROW_SIZE, ROW_FONT_COLOR, ROW_FONT_SIZE, ROW_FONT, column.rowAlignX, column.rowAlignY, false, false, false, true, false)
				end
			end

			currentX = currentX + column.width
		end
	end

	currentX = positionX + ROW_PADDING_START
	currentY = currentY + ROW_SIZE

	if personalRecord and tonumber(personalRecord.rank) > 8 then
		dxDrawImage(positionX, currentY, leaderboardWidth, ROW_SIZE, HIGHLIGHT_IMAGE_PATH)
		dxDrawRectangle(positionX, currentY, BORDER_SIZE, ROW_SIZE, BORDER_LEFT_COLOR_HIGHLIGHT)

		for i, column in ipairs(tableColumns) do
			local value = column.computed(personalRecord, personalRecord.rank)

			if column.isValueImage then
				local flagIndex = Leaderboard.flags[value]
				local flagRow = flagIndex % 16
				local flagColumn = math.floor( flagIndex / 16 )
				local imageSize = math.floor(column.rowImageSize * ratioY)
				dxDrawImageSection(currentX, currentY + (ROW_SIZE / 2) - (imageSize / 2), imageSize, imageSize, (48) * flagRow, (48) * flagColumn, 48, 48, ":CCS/img/flags.png")
			else
				if column.isImage then
					local textWidth = dxGetTextWidth(value, ROW_FONT_SIZE, ROW_FONT)
					local fontSize = Leaderboard.textFit(value, ROW_FONT_SIZE, ROW_FONT, column.width, 10)
					dxDrawText(value, currentX + (column.imageSize / 2), currentY, currentX + column.width, currentY + ROW_SIZE, ROW_FONT_COLOR, fontSize, ROW_FONT, column.rowAlignX, column.rowAlignY, false, false, false, true, false)
				else
					value = Leaderboard.textOverflow(value, ROW_FONT_SIZE, ROW_FONT, column.width, true)
					dxDrawText(value, currentX, currentY, currentX + column.width, currentY + ROW_SIZE, ROW_FONT_COLOR, ROW_FONT_SIZE, ROW_FONT, column.rowAlignX, column.rowAlignY, false, false, false, true, false)
				end
			end

			currentX = currentX + column.width
		end
	end
end

function Leaderboard.update(list, personalBest)
	local arena = getElementParent(localPlayer)
	local map = getElementData(arena, "map")
	personalRecord = false

	if not isClientReady or not list or not map or not Leaderboard.isDerbyMap(map.type) then return end

	if personalBest then
		personalRecord = personalBest
	end

	removeEventHandler("onClientRender", root, Leaderboard.animationOut)
	removeEventHandler("onClientRender", root, Leaderboard.animationIn)
	removeEventHandler("onClientRender", root, Leaderboard.render)
	leaderboard = list
	isAnimating = false
	isToggled = false
	setTimer(function() Leaderboard.toggle() end, 1000, 1)	
end
addEvent("onClientTopTimesUpdate", true)
addEventHandler("onClientTopTimesUpdate", root, Leaderboard.update)



addEvent("onClientMapChange", true)
addEventHandler("onClientMapChange", root, function()
	isClientReady = false
end)

function Leaderboard.toggle()
	local arena = getElementParent(localPlayer)
	local map = getElementData(arena, "map")

	if not Leaderboard.isDerbyMap(map.type) or isAnimating then return end
	if isTimer(toggleDelay) then killTimer(toggleDelay) end

	animationStartTime = getTickCount()
	animationEndTime = animationStartTime + 1000

	if isToggled then
		isAnimating = true
		isToggled = false
		addEventHandler("onClientRender", root, Leaderboard.animationOut)
	else
		isAnimating = true
		isToggled = true
		addEventHandler("onClientRender", root, Leaderboard.animationIn)
		addEventHandler("onClientRender", root, Leaderboard.render)
		toggleDelay = setTimer(Leaderboard.toggle, TOGGLE_DURATION, 1)
	end
end
bindKey(TOGGLE_KEY, "down", Leaderboard.toggle)

function Leaderboard.animationIn()
	local now = getTickCount()
	local elapsedTime = now - animationStartTime
	local duration = animationEndTime - animationStartTime
	local progress = elapsedTime / duration

	positionX, positionY = interpolateBetween(startX, startY, 0, endX, endY, 0, progress, ANIMATION_NAME)

	if progress >= 1 then
		removeEventHandler("onClientRender", root, Leaderboard.animationIn)
		isAnimating = false
	end
end

function Leaderboard.animationOut()
	local now = getTickCount()
	local elapsedTime = now - animationStartTime
	local duration = animationEndTime - animationStartTime
	local progress = elapsedTime / duration

	positionX, positionY = interpolateBetween(endX, endY, 0, startX, startY, 0, progress, ANIMATION_NAME)

	if progress >= 1 then
		removeEventHandler("onClientRender", root, Leaderboard.animationOut)
		removeEventHandler("onClientRender", root, Leaderboard.render)
		isAnimating = false
	end
end

function Leaderboard.reset()
	if isTimer(toggleDelay) then killTimer(toggleDelay) end

	removeEventHandler("onClientRender", root, Leaderboard.render)
	removeEventHandler("onClientRender", root, Leaderboard.animationIn)
	removeEventHandler("onClientRender", root, Leaderboard.animationOut)
	isToggled = false
	isAnimating = false
end
addEvent("onClientArenaReset", true)
addEventHandler("onClientArenaReset", root, Leaderboard.reset)

function Leaderboard.addColumn(column)
	column.alignX = column.alignX or "left"
	column.alignY = column.alignY or "center"
	column.rowAlignX = column.rowAlignX or column.alignX
	column.rowAlignY = column.rowAlignY or column.alignY
	column.isImage = column.isImage or false
	column.isColorCoded = column.isColorCoded or true
	column.isUpperCase = column.isUpperCase or true
	column.isValueImage = column.isValueImage or false
	column.rowImageSize = column.rowImageSize or column.imageSize
	column.isImageCentered = column.isImageCentered or false
	table.insert(tableColumns, column)
end

function Leaderboard.textFit(text, size, font, width, padding)
	local fontSize = size
	padding = padding or 10
	width = width - padding

	while dxGetTextWidth(text, fontSize, font, true) > width do
		fontSize = fontSize - 0.1
	end

	return fontSize
end

function Leaderboard.textOverflow(text, size, font, width, ellipsis)
	local ellipsis = ellipsis or false

	while dxGetTextWidth(text, size, font, true) > width do
		if ellipsis then
			text = text:sub(1, text:len()-4).."..."
		else
			text = text:sub(1, text:len()-1)
		end
	end

	return text
end

function Leaderboard.convertDate(date)
	if not date then return false end
	
	local d, m, y, h, i, s = string.match(date, "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)")
	return string.format("%s.%s.%s", y, m, d) or false
end

function Leaderboard.isDerbyMap(type)
	if not type then return false end

	local allowedTypes = {
		"Cross",
		"Shooter",
		"Hunter",
		"Linez"
	}

	for _, v in ipairs(allowedTypes) do
		if type == v then return true end
	end

	return false
end