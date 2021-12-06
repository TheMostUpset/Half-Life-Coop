MAP.ChapterTitle = "#HL1_Chapter7_Title"
MAP.ShowChapterTitle = true

if CLIENT then return end

MAP.StartingWeapons = {"weapon_crowbar", "weapon_glock", "weapon_shotgun", "weapon_handgrenade", "weapon_mp5", "weapon_357", "weapon_tripmine"}

function MAP:CreateViewPoints()
	GAMEMODE:CreateViewPointEntity(Vector(-451, -325, 171), Angle(4, 30, 0))

	if GAMEMODE:GetCoopState() == COOP_STATE_FIRSTLOAD then
		for k, v in pairs(ents.FindByClass("monster_human_grunt")) do
			v:Remove()
		end
	end
end

function MAP:CreateMapEventCheckpoints(ent, activator)
	if ent:GetName() == "grunt_run1_seq" then
		GAMEMODE:Checkpoint(1, Vector(1213, 1080, 5), Angle(0, -155, 0), Vector(207, -456, 50), activator)
	end
end

function MAP:FixMapEntities()
	local scriptFix = ents.FindByName("dragguy")
	table.Add(scriptFix, ents.FindByName("scarey"))
	for k, v in pairs(scriptFix) do
		v:SetSaveValue("m_takedamage", 0)
	end
end

local plyClip

function MAP:ModifyMapEntities()
	GAMEMODE:CreateWeaponEntity("weapon_mp5", Vector(-110, -756, 40), Angle(0, 145, 0))
	
	for k, v in pairs(ents.FindByName("tracks10")) do
		v:Remove()
	end

	for k, v in pairs(ents.FindByClass("trigger_auto")) do
		if v:GetKeyValues().globalstate == "c2a1_train_power" then
			v:Remove()
		end
	end
	
	if !GAMEMODE:GetSpeedrunMode() then
		plyClip = ents.Create("hl1_playerclip")
		if IsValid(plyClip) then
			plyClip:Spawn()
			plyClip:SetCollisionBoundsWS(Vector(1280, -705, 0), Vector(896, -775, 256))
		end
	end
end

local hasPlayed
function MAP:OperateMapEvents(ent, input, caller, activator)
	if ent:GetClass() == "logic_relay" and ent:GetName() == "logic_relay_open_gate" and input == "Trigger" then
		GAMEMODE:RemovePreviousCheckpoint()
	end
	if ent:GetClass() == "logic_relay" and ent:GetName() == "transformer_gr/red" and input == "Trigger" then
		for k, v in pairs(GAMEMODE:GetActivePlayersTable()) do
			if v != activator then
				v:SendScreenHintTop("#notify_power")
			end
		end
	end
	if ent:GetClass() == "func_wall_toggle" and ent:GetName() == "crate_barrier_w" and input == "Kill" then
		if IsValid(plyClip) then plyClip:Remove() end
	end
	if !hasPlayed and ent:GetClass() == "ambient_generic" and input == "PlaySound" and ent:GetName() == "poweroff_wav" then
		local message = string.Replace(ent:GetSaveTable().message, "!", "!BMAS_")
		GAMEMODE:SendCaption(message, ent:GetPos())
		hasPlayed = true
	end
end