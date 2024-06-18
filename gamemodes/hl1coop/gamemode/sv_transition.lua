function GM:ReadEntityDataFromFile(name)
	local idString = tostring(SESSION_ID)
	local datafile = "hl1_coop/transition_"..name.."_"..game.GetMap()..".txt"
	local data = file.Read(datafile)
	if data then
		local nStart, nEnd = string.find(data, idString)
		if nStart == 1 and nEnd == #idString then
			data = string.TrimLeft(data, idString)
			file.Delete(datafile)
			return util.JSONToTable(data)
		end
	end
end

function GM:SaveTransitionData(map, landmark, curmap, pos, ang)
	local dataTable = {
		map,
		landmark,
		curmap,
		self:GetGameTime(),
		pos,
		ang,
		SESSION_ID
	}
	file.CreateDir("hl1_coop")
	file.Write("hl1_coop/transition_data.txt", util.TableToJSON(dataTable))
end

function GM:TransitPlayers(maptochange, leveltransition)
	local tPlys = {}
	if leveltransition then
		for k, v in ipairs(player.GetHumans()) do
			local actwep = v:GetActiveWeapon()
			local wepclass = IsValid(actwep) and actwep:GetClass()
			table.insert(tPlys, {id = v:UserID(), steamid = v:SteamID64(), nick = v:Nick(), hp = v:Health(), armor = v:Armor(), wep = wepclass, alive = v:Alive(), spec = v:Team() == TEAM_SPECTATOR, weptable = hook.Run("StorePlayerAmmunitionNew", v), score = v:GetScore()})
		end
	else
		for k, v in ipairs(player.GetHumans()) do
			table.insert(tPlys, {id = v:UserID(), steamid = v:SteamID64(), nick = v:Nick()})
		end
	end
	if tPlys then
		file.CreateDir("hl1_coop")
		file.Write("hl1_coop/transition_players_"..maptochange..".txt", util.TableToJSON(tPlys))
	end
end

function GM:RestorePlayerData()
	if !self.LastPlayersTable then
		local datafile = "hl1_coop/transition_players_"..game.GetMap()..".txt"
		local tData = file.Read(datafile)
		if tData then
			self.LastPlayersTable = util.JSONToTable(tData)			
			file.Delete(datafile)
		end
		if self:IsCoop() and self.LastPlayersTable then
			if !CONNECTING_PLAYERS_TABLE then
				CONNECTING_PLAYERS_TABLE = {}
			end
			for k, v in pairs(self.LastPlayersTable) do
				if CONNECTING_PLAYERS_TABLE then
					table.insert(CONNECTING_PLAYERS_TABLE, {v.id, v.nick})
				end
			end
		end
	end
end

local DOOR_OPEN = 0
local DOOR_CLOSED = 1
local DOOR_CLOSING = 2
local DOOR_OPENING = 3
function GM:SaveDoorsState()
	local tDoors = {}
	for _, ent in ipairs(ents.FindByClass("func_door*")) do
		local state = ent:GetInternalVariable("m_toggle_state")
		local islocked = ent:GetInternalVariable("m_bLocked")
		table.insert(tDoors, {ent:MapCreationID(), state, islocked})
	end
	if tDoors and !table.IsEmpty(tDoors) then
		file.CreateDir("hl1_coop")
		file.Write("hl1_coop/transition_doors_"..game.GetMap()..".txt", SESSION_ID..util.TableToJSON(tDoors))
	end
end

function GM:RestoreDoorsState()
	if MAP.SaveTransitionEntityData and !self.TransitionTable_Doors and SESSION_ID then
		self.TransitionTable_Doors = self:ReadEntityDataFromFile("doors")
	end
	if self.TransitionTable_Doors then
		for _, ent in ipairs(ents.FindByClass("func_door*")) do
			for _, tEnt in ipairs(self.TransitionTable_Doors) do
				if ent:MapCreationID() == tEnt[1] then
					if tEnt[2] == DOOR_OPEN or tEnt[2] == DOOR_OPENING then
						ent:Fire("Open")
					elseif tEnt[2] == DOOR_CLOSED or tEnt[2] == DOOR_CLOSING then
						ent:Fire("Close")
					end
					ent:SetSaveValue("m_bLocked", tEnt[3])
				end
			end
		end
	end
end

function GM:SaveTransitionEntityData()
	if !MAP.SaveTransitionEntityData or !SESSION_ID then return end
	local tEnts = self.RemovedMapEntities
	local tEntsOld = self.TransitionTable_RemovedEntities -- the table from first transition (if exists)
	if tEntsOld then
		if !tEnts then
			tEnts = {}
		end
		table.Add(tEnts, tEntsOld)
	end
	if tEnts then
		file.CreateDir("hl1_coop")
		file.Write("hl1_coop/transition_removedentities_"..game.GetMap()..".txt", SESSION_ID..util.TableToJSON(tEnts))
	end
	
	self:SaveDoorsState()
end

function GM:RestoreTransitionEntityData()
	-- basic entity transition, remove that should be removed
	if MAP.SaveTransitionEntityData and !self.TransitionTable_RemovedEntities and SESSION_ID then
		self.TransitionTable_RemovedEntities = self:ReadEntityDataFromFile("removedentities")
	end
	if self.TransitionTable_RemovedEntities then
		for _, ent in ipairs(ents.GetAll()) do
			for _, remEnt in ipairs(self.TransitionTable_RemovedEntities) do
				if IsValid(ent) and ent:MapCreationID() == remEnt then					
					ent:Remove()
				end
			end
		end
	end
	
	self:RestoreDoorsState()
end