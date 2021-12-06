MAP.ChapterTitle = "#T0A0TITLE"
MAP.ShowChapterTitle = true

MAP.DisableFullRespawn = true

if CLIENT then return end

MAP.NoSuitOnSpawn = true
MAP.StartingWeapons = false
MAP.DisallowSurvivalMode = true
MAP.npcLagFixDisabled = true

function MAP:CreateViewPoints()
	GAMEMODE:CreateViewPointEntity(Vector(-1598, -171, 17), Angle(5, -32, 0))
	GAMEMODE:CreateViewPointEntity(Vector(-811, 203, 50), Angle(10, 45, 0))
end

local tele1pos = Vector(-1380, -1670, -5)
local tele2pos = Vector(-2, 102, 640)
local tele3pos = Vector(1007, -1113, 1565)
local tele4pos = Vector(-2010, 571, 1555)
local tele4pos_elev = Vector(-965, -1607, 1735)

function MAP:CreateMapCheckpoints()
	GAMEMODE:CreateCheckpointTrigger(1, Vector(600, 109, 8), Vector(660, 49, 64), Vector(490, 78, -30), Angle(0, 180, 0), tele1pos, "item_suit")
	GAMEMODE:CreateCheckpointTrigger(2, Vector(1791, -1549, 1516), Vector(1946, -1400, 1664), Vector(1868, -1498, 1520), Angle(0, 90, 0), {tele1pos, tele2pos}, "item_suit")
	GAMEMODE:CreateCheckpointTrigger(3, Vector(-1183, 660, 1500), Vector(-1097, 501, 1623), Vector(-1193, 867, 1510), Angle(0, 180, 0), {tele1pos, tele2pos, tele3pos}, "item_suit")
	GAMEMODE:CreateCheckpointTrigger(4, Vector(-856, -1495, 2429), Vector(-632, -1719, 2472), Vector(-1029, -1698, 2435), Angle(0, 90, 0), {tele1pos, tele2pos, tele3pos, tele4pos, tele4pos_elev}, "item_suit") -- elev
end

function MAP:ModifyMapEntities()
	GAMEMODE:CreateCoopSpawnpoints(Vector(-1380, -1952, -55), Angle(0, 90, 0))

	if GAMEMODE:GetCoopState() == COOP_STATE_FIRSTLOAD then
		local removeEnts = ents.FindByClass("monster_generic")
		for k, v in pairs(removeEnts) do
			v:Remove()
		end
	end
	
	for _, suitEnt in pairs(ents.FindByClass("item_suit")) do
		suitEnt.Respawnable = true
		suitEnt.RespawnTime = .5
	end
	
	for k, v in pairs(ents.FindByClass("trigger_once")) do
		if v:GetPos() == Vector(187, -2387, 2422) then
			v:Remove()
		end
		if v:GetPos() == Vector(187, -2545, 2422) then
			local fTrig = ents.Create("hl1_trigger_func")
			if IsValid(fTrig) then
				fTrig.TouchFunction = function(ply)					
					if GAMEMODE:GetSpeedrunMode() then
						GAMEMODE:PlayerHasFinishedMap(ply)
					end
					ply:Spawn()					
					ply:ScreenFade(SCREENFADE.IN, color_black, 1, .1)
				end
				fTrig:SetPos(v:GetPos())
				fTrig:Spawn()
				fTrig:SetCollisionBounds(v:GetCollisionBounds())
			end
		end
	end
	
	for k, doorEnt in pairs(ents.FindByClass("func_door")) do
		local name = doorEnt:GetName()
		if name == "td10" or name == "swimblock1" then
			doorEnt:Fire("Lock")
		end
	end
	
	for k, v in pairs(ents.FindByClass("game_end")) do
		v:Remove()
	end
	
	for k, v in pairs(ents.FindByClass("monster_miniturret")) do
		local pos = v:GetPos()
		if pos == Vector(-544,-1231,2550) then
			v:SetPos(pos - Vector(0,0,1))
		end
	end
end

local doors = {
	["td1"] = true,
	["td2"] = true,
	["td3"] = true,
	["td4"] = true,
	["td5"] = true,
	["td6"] = true,
	["td7"] = true,
	["td9"] = true,
	["td11"] = true,
}

local plyClip
function MAP:OperateMapEvents(ent, input, caller, activator)
	if game.SinglePlayer() then
		if ent:GetClass() == "game_end" and input == "EndGame" then
			RunConsoleCommand("disconnect")
		end
	else
		local class, name = ent:GetClass(), ent:GetName()
		if class == "func_door" and doors[name] then
			if input == "Toggle" then
				ent:Fire("Lock")
			elseif input == "Close" then
				return true
			end
		end
		
		if class == "func_button" and name == "liftbutton1" then
			if !IsValid(plyClip) then
				plyClip = ents.Create("hl1_playerclip")
				if IsValid(plyClip) then
					plyClip:Spawn()
					plyClip:SetCollisionBoundsWS(Vector(-188, -1631, 290), Vector(-5, -1619, 665))
				end
			else
				plyClip:Toggle()
			end
		end
		if class == "path_track" and input == "InPass" and IsValid(caller) and caller:GetClass() == "func_tracktrain" and caller:GetName() == "freightlift" then
			if IsValid(plyClip) and name == "floathumanlift3" then
				plyClip:Toggle()
			end
			if name == "floathumanlift4" then
				timer.Simple(3, function()
					if IsValid(ent) and IsValid(caller) then
						caller:Fire("StartForward")
					end
				end)
			end
		end
		if class == "multi_manager" and IsValid(caller) and caller:GetClass() == "func_guntarget" and IsValid(activator) and activator:IsPlayer() then
			activator:AddScore(100)
		end
	end
end

function MAP:OnPlayerSpawn(ply)
	ply:SetLongJump(false)
	ply:StripWeapons()
	ply:StripAmmo()
end

function MAP:OnPlayerDeath()
	if game.SinglePlayer() then
		if !LAST_CHECKPOINT_NUMBER then
			GAMEMODE:GameOver()
		elseif LAST_CHECKPOINT_NUMBER == 1 then
			local ljCheck = ents.FindByClass("item_longjump")[1]
			if !ljCheck then
				local lj = ents.Create("item_longjump")
				if IsValid(lj) then
					lj:SetPos(Vector(-592, 1569, 629))
					lj:Spawn()
				end
			end
			local elev = ents.FindByName("freightlift")[1]
			if IsValid(elev) and !elev:GetPos():IsEqualTol(Vector(-96,-1691,345), 10) then
				elev:Fire("StartForward")
			end
		elseif LAST_CHECKPOINT_NUMBER == 2 then
			local doors = ents.FindByName("td9")
			table.Add(doors, ents.FindByName("td10"))
			for k, v in pairs(doors) do
				v:Fire("Open")
			end
		elseif LAST_CHECKPOINT_NUMBER == 3 then
			local doors = ents.FindByName("td11")
			table.Add(doors, ents.FindByName("swimblock1"))
			for k, v in pairs(doors) do
				v:Fire("Open")
			end
		end
	end
end