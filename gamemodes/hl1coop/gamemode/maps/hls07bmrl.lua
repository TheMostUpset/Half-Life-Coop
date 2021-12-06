MAP.ChapterTitle = "#HL1_Chapter8_Title"
MAP.ShowChapterTitle = false

if CLIENT then return end

MAP.StartingWeapons = {"weapon_crowbar", "weapon_glock", "weapon_shotgun", "weapon_handgrenade", "weapon_mp5", "weapon_357", "weapon_satchel", "weapon_tripmine"}
MAP.StartingAmmo = {["MP5_Grenade"] = 2}

function MAP:CreateViewPoints()
	GAMEMODE:CreateViewPointEntity(Vector(-4250, -576, -154), Angle())
end

function MAP:CreateMapEventCheckpoints(ent, activator)
	local tele1pos = Vector(-1600, -2400, -145)
	if ent:GetName() == "snooper" then
		local pos = Vector(2030, 1575, -380)
		local ang = Angle(0, 90, 0)
		GAMEMODE:Checkpoint(1, pos, ang, tele1pos, activator)
	end
end

function MAP:FixMapEntities()
	for k, v in pairs(ents.FindByName("tblast2")) do
		if v:GetClass() == "func_door" then
			v:SetKeyValue("forceclosed", 1)
		end
	end
end

function MAP:ModifyMapEntities()
	for k, v in pairs(ents.FindByName("timetrain1")) do
		v:Remove()
	end
	for k, v in pairs(ents.FindByName("rocket_for_player2")) do
		v:Remove()
	end
	
	for k, v in pairs(ents.FindByClass("trigger_auto")) do
		if v:GetKeyValues().globalstate == "c2a2g_trainblastdoors" then
			v:Remove()
		end
	end
	
	local fTrig = ents.Create("hl1_trigger_func")
	if IsValid(fTrig) then
		fTrig.TouchFunction = function(ply)
			GAMEMODE:RemoveCoopSpawnpoints()
			GAMEMODE:CreateCoopSpawnpoints(Vector(-2449, -2363, -190), Angle(0, 5, 0), 3)
			fTrig:Remove()
		end
		fTrig:Spawn()
		fTrig:SetCollisionBoundsWS(Vector(-2144, -2109, -192), Vector(-2178, -2360, 58))
	end
	
	local rem = ents.FindByClass("npc_enemyfinder")
	table.Add(rem, ents.FindByClass("ai_relationship"))
	for k, v in pairs(rem) do
		v:Remove()
	end
	
	for k, v in pairs(ents.FindByClass("func_tank*")) do
		if v:GetName() == "siloguardgun" or v:GetName() == "sniper1" or v:GetName() == "trackguardrocket" then
			local cEnt = ents.Create("func_tank_controller")
			if IsValid(cEnt) then
				cEnt:SetParent(v)
				cEnt:SetPos(v:GetPos())
				cEnt:Spawn()
				if v:GetName() == "trackguardrocket" then
					cEnt.Explosive = true
				end
			end
		end
	end
end

local renameTrain
function MAP:OnEntCreated(ent)
	if !renameTrain then
		for _, trainEnt in pairs(ents.FindByName("train")) do
			trainEnt:SetSaveValue("globalname", "pieceofshit2")
			renameTrain = true
		end
	end
	
	if ent:GetClass() == "rpg_missile" then
		ent:SetNoDraw(true)
		timer.Simple(0, function()
			if IsValid(ent) then
				ent:StopSound("Missile.Ignite")
				ent:SetModel("models/rpgrocket.mdl")
				local replaceent = ents.Create("ent_hl1_rpg_rocket")
				if IsValid(replaceent) then
					replaceent:SetPos(ent:GetPos() - Vector(0,0,16))
					replaceent:SetAngles(ent:GetAngles())
					replaceent:SetOwner(ent:GetOwner())
					replaceent:Spawn()
				end
				ent:Remove()
			end
		end)
	end
end

function MAP:OperateMapEvents(ent, input, caller, activator)
	if GAMEMODE:GetSpeedrunMode() and ent:GetClass() == "func_door" and ent:GetName() == "tblast2" and input == "Open" and activator:IsPlayer() then
		timer.Simple(27, function()
			if IsValid(ent) then
				ent:Fire("Open")
			end
		end)
		return true
	end
end

function MAP:PreMapRestart()
	renameTrain = nil
end