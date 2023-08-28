MAP.ChapterTitle = "#HL1_Chapter5_Title"
MAP.ShowChapterTitle = true

if CLIENT then return end

MAP.BlockSpawnpointCreation = {
	["hls03amrl"] = true
}

MAP.StartingWeapons = {"weapon_crowbar", "weapon_glock", "weapon_shotgun", "weapon_handgrenade"}

MAP.FallToDeath = {
	{Vector(304, -1770, 129), Vector(-304, -2360, 420)},
	{Vector(591, 55, -664), Vector(352, -184, -256)}, -- elevator shaft
	{Vector(-2640, -1207, 20), Vector(-2384, -951, 270)} -- fan
}

function MAP:OnMapLoaded() -- HACKS HACKS HACKS
	for k, v in pairs(ents.FindByClass("point_template")) do
		if v:GetName() == "slab_template" then
			v:Fire("ForceSpawn") -- need this for correctly path_corner creating after cleanup
		end
	end
	if game.SinglePlayer() then
		timer.Simple(1, function()
			GAMEMODE:RestartMap()
		end)
	end
end

function MAP:OnMapRestart()
	self:ReturnDefaultPathCorners()
end

function MAP:CreateViewPoints()
	GAMEMODE:CreateViewPointEntity(Vector(440, 1170, 135), Angle(15, -140, 0))
end

local tele1pos = Vector(255, 1630, 50)
local tele2pos = Vector(-1070, -1500, 1280)
local elev_tele1pos = Vector(1280, -956, -80)
local elev_tele2pos = Vector(64, -1125, 670)

function MAP:CreateMapCheckpoints()
	GAMEMODE:CreateCheckpointTrigger(1, Vector(1455, -1176, 482), Vector(1297, -1016, 383), Vector(1350, -1470, 520), Angle(0, -90, 0), {tele1pos, elev_tele1pos}, "weapon_mp5")
end

local doorClip

function MAP:CreateMapEventCheckpoints(ent, activator)
	if ent:GetName() == "c1a3c_collapse_mm" then
		local pos = Vector(-590, -1555, 770)
		local ang = Angle(0, 180, 0)
		GAMEMODE:Checkpoint(3, pos, ang, {tele1pos, tele2pos, elev_tele2pos}, activator, "weapon_mp5")
	end
	if ent:GetName() == "c1a3_security01" then
		GAMEMODE:RemovePreviousCheckpoint({elev_tele1pos, elev_tele2pos, tele2pos})
		if IsValid(doorClip) then doorClip:Remove() end
	end
end

function MAP:OperateMapEvents(ent, input, caller, activator)
	if ent:GetClass() == "scripted_sentence" and ent:GetName() == "c1a3deadtalk" then
		for _, npc in ipairs(ents.FindInSphere(Vector(1440, -904, -128), 8)) do
			if npc:IsNPC() and npc:GetClass() == "monster_human_grunt" then
				npc:SetAngles(Angle(0, 207, 0))
			end
		end
		--[[local sci = ents.FindByName("c1a3lucky")[1]
		timer.Simple(1, function()
			if IsValid(sci) then
				for _, npc in pairs(ents.FindInSphere(Vector(1440, -904, -128), 8)) do
					if npc:IsNPC() and npc:GetClass() == "monster_human_grunt" then
						npc:UpdateEnemyMemory(sci, sci:GetPos())
					end
				end
			end
		end)]]
	end
	if ent:GetClass() == "path_track" and ent:GetName() == "lift02c" and input == "InPass" then
		local pos = Vector(175, -870, 1290)
		local ang = Angle(0, 180, 0)
		local trig = function()
			local triggersExist
			for k, v in ipairs(ents.FindInSphere(Vector(59, -1114, 1261), 32)) do
				if v:GetClass() == "trigger_once" then
					triggersExist = true
					v:Remove()
				end
			end
			if triggersExist then
				local spawner = ents.FindByName("osprey_t")[1]
				if IsValid(spawner) then
					spawner:Fire("ForceSpawn")
				end
				timer.Simple(0, function()
					local osprey = ents.FindByName("osprey1")[1]
					if IsValid(osprey) then
						osprey:Fire("Activate")
					end
				end)
				local music = ents.FindByName("music_track_2")[1]
				if IsValid(music) then
					music:Fire("PlaySound")
				end
			end
		end
		GAMEMODE:Checkpoint(2, pos, ang, {tele1pos, elev_tele2pos}, activator, "weapon_mp5", nil, trig)
	end
	
	if IsValid(caller) and caller:GetClass() == "trigger_once" and ent:GetClass() == "func_door" and ent:GetName() == "sl10_door" and input == "Close" then
		return true
	end
end

function MAP:FixMapEntities()	
	local fTrig = ents.Create("hl1_trigger_func")
	if IsValid(fTrig) then
		fTrig.TouchFunction = function()
			local osprey = ents.FindByClass("monster_osprey")[1]
			if IsValid(osprey) then
				-- renaming map path_corners to break current Osprey path
				for k, v in pairs(ents.FindByName("os*")) do
					if v:GetClass() == "path_corner" then
						v:SetName(v:GetName().."_old")
					end
				end

				-- creating new ones
				local path_corner = {
					{"os_vent1", Vector(-570, -1625, 2400), "os_vent2", "1500"},
					{"os_vent2", Vector(-1543, -1088, 2300), "os_vent3", "800"},
					{"os_vent3", Vector(-2680, -1080, 2030), "os_vent1", "0"}
				}
				for k, v in pairs(path_corner) do
					local pcorner = ents.Create("path_corner")
					if IsValid(pcorner) then
						pcorner:SetPos(v[2])
						pcorner:SetKeyValue("targetname", v[1])
						pcorner:SetKeyValue("target", v[3])
						pcorner:SetKeyValue("speed", v[4])
						pcorner:Spawn()
						pcorner:Activate()
					end
				end
				
				-- forcing Osprey to fly to that ones
				osprey:SetKeyValue("target", "os_vent1")
			end
			
			fTrig:Remove()
		end
		fTrig:Spawn()
		fTrig:SetCollisionBoundsWS(Vector(-1906, -1664, 769), Vector(-2054, -1504, 893))
	end
end

function MAP:ReturnDefaultPathCorners()
	for k, v in pairs(ents.FindByName("os*_old")) do
		if v:GetClass() == "path_corner" then
			local name = v:GetName()
			name = string.Replace(name, "_old", "")
			v:SetName(name)
		end
	end
	for k, v in pairs(ents.FindByName("os_vent*")) do
		v:Remove()
	end
end

function MAP:ModifyMapEntities()
	GAMEMODE:CreateCoopSpawnpoints(Vector(60, 1520, 5), Angle())
	
	GAMEMODE:CreateWeaponEntity("weapon_shotgun", Vector(-677, -3001, 700), Angle(0, 145, 0))
	GAMEMODE:CreateWeaponEntity("weapon_shotgun", Vector(-2148, -2304, 1320), Angle(0, -20, 0))
	GAMEMODE:CreateWeaponEntity("weapon_mp5", Vector(-2154, -2341, 1320), Angle(0, -20, 0))
	GAMEMODE:CreateWeaponEntity("weapon_handgrenade", Vector(-2160, -2376, 1320), Angle(0, 10, 0))
	
	if !GAMEMODE:GetSpeedrunMode() then
		doorClip = ents.Create("hl1_clip")
		if IsValid(doorClip) then
			doorClip:Spawn()
			doorClip:SetCollisionGroup(COLLISION_GROUP_DOOR_BLOCKER)
			doorClip:SetCollisionBoundsWS(Vector(172, 1184, 0), Vector(163, 1248, 96))
		end
	end
	
	for k, v in pairs(ents.FindByName("c1a3_explosion*")) do
		if v:GetClass() == "env_explosion" then
			v.ActivatedByTrigger = true
		end
	end
	
	if GAMEMODE:GetSkillLevel() == 1 then
		for k, v in pairs(ents.FindByClass("monster_tripmine")) do
			if v:GetPos() == Vector(-1376,128,48) then
				v:SetPos(Vector(-1376,128,62))
			end
		end
	end
end

function MAP:OnEntCreated(ent)
	if ent:GetClass() == "monster_mortar" then
		timer.Simple(0, function()
			if IsValid(ent) then
				ent:SetOwner(NULL)
			end
		end)
	end
	if ent:GetClass() == "monster_human_grunt" then
		timer.Simple(0, function()
			if IsValid(ent) then
				local owner = ent:GetOwner()
				if IsValid(owner) and owner:GetClass() == "monster_osprey" and ent:GetPos():WithinAABox(Vector(-2677, -899, 1271), Vector(-2340, -1266, 2200)) then
					local ventBreakable = ents.FindByName("c1a3_debris07")[1]
					if IsValid(ventBreakable) then
						ent:Remove()
					else
						self:ReturnDefaultPathCorners()
						owner:SetKeyValue("target", "os1")
					end
				end
			end
		end)
	end
end