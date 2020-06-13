Autoteam = {}
Autoteam.connection = nil
Autoteam.cacheInterval = 600000
Autoteam.cache = {}

--CREATE TABLE ddc_clans (id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY, clan_name VARCHAR(30) NOT NULL, clan_tag VARCHAR(30) NOT NULL, clan_color VARCHAR(30) NOT NULL, clan_state TINYINT(1), reg_date TIMESTAMP);
--CREATE TABLE ddc_clan_members (id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY, member_name VARCHAR(30) NOT NULL, forum_id INT(6) NOT NULL, clan_id INT(6) UNSIGNED NOT NULL, is_owner TINYINT(1), FOREIGN KEY (clan_id) REFERENCES ddc_clans(id) ON DELETE CASCADE);
--INSERT INTO ddc_clans(clan_name, clan_tag, clan_color, clan_state) VALUES('BAD COMPANY', '[BAD]', "#ffd700", 1);
--INSERT INTO ddc_clan_members(member_name, forum_id, clan_id, is_owner) VALUES('Bonsai', 3, 2, 1);

function Autoteam.main()
	
	Autoteam.cacheClans()
	setTimer(Autoteam.cacheClans, Autoteam.cacheInterval, 0)
	
end
addEventHandler("onResourceStart", resourceRoot, Autoteam.main)


function Autoteam.cacheClans()

	Autoteam.connection = exports["CCS_database"]:getConnection()
	
	if not Autoteam.connection then return end	

	dbQuery(Autoteam.updateCache, Autoteam.connection, "SELECT * FROM ddc_clans;")

end


function Autoteam.updateCache(handle)

	Autoteam.cache = {}

	local result = dbPoll(handle, 0)
	
	--No Result
	if not result then 
	
		outputDebugString("No result!")
		dbFree(handle)
		return 
		
	end
	
	outputDebugString("Clanpack: Caching Clans..")
	
	for i, row in pairs(result) do
		
		if row["clan_state"] == 1 then
		
			Autoteam.cache[row["clan_tag"]] = {row["id"], row["clan_tag"], row["clan_name"], row["clan_color"]}
			
		end
	
	end

end


function Autoteam.check()
	
	Autoteam.connection = exports["CCS_database"]:getConnection()
	
	if not Autoteam.connection then return end	
	
	local clan_tag = Autoteam.findPlayerClanTag(source)

	if clan_tag and not getElementData(source, "account") then
			
		kickPlayer(source, "Login to use "..clan_tag.." clan tag!")
		
		return
				
	end

	local forum_id = getElementData(source, "accountID")
	
	dbQuery(Autoteam.callback, {source, data}, Autoteam.connection, "SELECT * FROM ddc_clans WHERE id = (SELECT clan_id FROM ddc_clan_members WHERE forum_id = ? LIMIT 1);", forum_id)

end
addEvent("onPlayerLoggedIn", true)
addEvent("onPlayerPlayAsGuest", true)
addEventHandler("onPlayerLoggedIn", root, Autoteam.check)
addEventHandler("onPlayerPlayAsGuest", root, Autoteam.check)


function Autoteam.callback(handle, player)

	local result = dbPoll(handle, 0)
	
	--No Result
	if not result then 
	
		outputDebugString("No result!")
		dbFree(handle)
		return 
		
	end
	
	--Player left meanwhile?
	if not isElement(player) then return end
	
	local clan_tag = Autoteam.findPlayerClanTag(player)
	
	if clan_tag and #result == 0 then 
	
		kickPlayer(player, "You are not allowed to use "..clan_tag.." clan tag!")
	
		return 
	
	end
	
	if #result == 0 then
	
		return
		
	end
	
	if #result > 1 then
	
		kickPlayer(player, "You are added in more than 1 clanpack!")
		
		return
		
	end

	if clan_tag and clan_tag ~= result[1]["clan_tag"] then
	
		kickPlayer(player, "You are not allowed to use "..clan_tag.." clan tag!")
	
		return 
	
	end	
	
	setElementData(player, "clan", result[1]["clan_color"]..result[1]["clan_tag"].." - "..result[1]["clan_name"])

end

function Autoteam.logout()

	setElementData(source, "clan", nil)

end
addEvent("onPlayerLoggedOut", true)
addEventHandler("onPlayerLoggedOut", root, Autoteam.logout)


function Autoteam.findPlayerClanTag(player)

	for clan_tag, data in pairs(Autoteam.cache) do
		
		local playerName = getPlayerName(player):gsub("#%x%x%x%x%x%x", "")
		
		if string.find(playerName, clan_tag, 1, true) then
			
			return clan_tag
			
		end
	
	end

	return false

end