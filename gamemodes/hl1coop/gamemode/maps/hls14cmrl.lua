MAP.ChapterTitle = "#HL1_Chapter18_Title"
MAP.ShowChapterTitle = true

if CLIENT then return end

MAP.StartingWeapons = {"weapon_crowbar", "weapon_glock", "weapon_357", "weapon_mp5", "weapon_shotgun", "weapon_crossbow", "weapon_rpg", "weapon_gauss", "weapon_egon", "weapon_hornetgun", "weapon_handgrenade", "weapon_satchel", "weapon_tripmine", "weapon_snark"}
MAP.StartingWeaponsLight = {"weapon_hornetgun"}
MAP.StartingAmmo = {["MP5_Grenade"] = 2}

MAP.FallToDeath = {
	{Vector(14484, 3624, -64), Vector(10422, -438, 524)}
}

MAP.EnvFadeWhitelist = {
	["start_flash"] = true,
	["start_fade"] = true,
	["end_fade_out"] = true,
	["fade1"] = true,
	["fade1.1"] = true,
	["fade_final"] = true,
	["tele_flash_final"] = true,
	["fade_pre_gman"] = true,
}

function MAP:CreateViewPoints()
	GAMEMODE:CreateViewPointEntity(Vector(1922, 4237, -3710), Angle(-80, 105, 0))
	GAMEMODE:CreateViewPointEntity(Vector(-221, 4983, -3890), Angle(0, -135, 0))
	GAMEMODE:CreateViewPointEntity(Vector(1215, -3449, 1520), Angle(5, -30, 0))
	GAMEMODE:CreateViewPointEntity(Vector(11032, 2359, 1630), Angle(0, -35, 0))
end

local titles = {
	["gametitlex"] = true,
	["valveisx"] = true,
	["end1x"] = true,
	["end2x"] = true,
	["end3x"] = true,
	["end4x"] = true,
	["end5x"] = true,
	["end6x"] = true,
	["end7x"] = true,
	["end8x"] = true,
	["end9x"] = true,
	["end10x"] = true,
	["end11x"] = true,
	["end12x"] = true
}
function MAP:FixMapEntities()
	for k, v in pairs(ents.FindByClass("env_message")) do
		if titles[v:GetName()] then
			v:Remove()
		end
	end
end

function MAP:ModifyMapEntities()
	GAMEMODE:CreateWeaponEntity("weapon_357", Vector(1893, 4493, -3371), Angle(0, 145, 0))
	GAMEMODE:CreateWeaponEntity("weapon_mp5", Vector(1735, 4432, -3059), Angle(0, 15, 0))
	GAMEMODE:CreateWeaponEntity("weapon_shotgun", Vector(-276, 4965, -3853), Angle(0, 120, 0))
	GAMEMODE:CreateWeaponEntity("weapon_rpg", Vector(3187, -5209, 1426), Angle(0, 70, 0))
	
	if GAMEMODE:GetCoopState() == COOP_STATE_FIRSTLOAD then
		for k, v in pairs(ents.FindByClass("logic_auto")) do
			v:Remove()
		end
	end
	
	if game.MaxPlayers() >= 2 then
		local fTrig = ents.Create("hl1_trigger_func")
		if IsValid(fTrig) then
			fTrig.TouchFunction = function(ply)
				ply:StripWeapons()
			end
			fTrig:Spawn()
			fTrig:SetCollisionBoundsWS(Vector(-14738, 15794, -6305), Vector(-14473, 15983, -6161))
		end
		for k, v in pairs(ents.FindByClass("func_breakable")) do
			if v:GetName() == "crystal1" or v:GetName() == "crystal2" or v:GetName() == "crystal3" then
				v:SetHealth(v:Health() * player.GetCount())
			end
		end
	end
end

function MAP:OperateMapEvents(ent, input, caller, activator)
	if ent:GetClass() == "trigger_teleport" and ent:GetName() == "n_dead_trigger_teleport" and input == "Enable" then
		for k, v in pairs(player.GetAll()) do
			if v:Alive() then
				v:SetLocalVelocity(Vector())
				v:SetPos(v:GetPos() + Vector(0,0,8))
			end
		end
	end
	if ent:GetClass() == "logic_relay" and ent:GetName() == "end_mm1" and input == "Trigger" and IsValid(activator) and activator:IsPlayer() then
		for k, v in pairs(player.GetAll()) do
			if v != activator then
				v:SetPos(activator:GetPos())
			end
		end
	end
	if ent:GetClass() == "trigger_teleport" and ent:GetName() == "teleport_after_nih" and input == "Enable" then
		noRespawnOptions = true
		if GAMEMODE:GetSurvivalMode() then
			GAMEMODE:ReviveDeadPlayers(Vector(-14626, 15884, -6270), Angle(0, 180, 0))
		end
	end
	if ent:GetClass() == "ambient_generic" and ent:GetName() == "music_track_25" then
		GAMEMODE:StartEndTitles()
	end
end

function MAP:OnNihilanthDeath(npc)
	npc:SetNotSolid(true)
	GAMEMODE:GameFinished()
end

function MAP:OnPlayerSpawn(ply)
	ply:SetGravity(0.25)
	ply:SetLongJump(true, true)
end

function MAP:OnEntCreated(ent)
	if ent:GetClass() == "nihilanth_energy_ball" then
		timer.Simple(0, function()
			if IsValid(ent) then
				local ontouch = ent:GetSaveTable().m_hTouch
				if IsValid(ontouch) and ontouch:GetClass() == "trigger_teleport" then
					--ent:SetCollisionBounds(Vector(-32, -32, -32), Vector(32, 32, 32))
					if ontouch:GetName() == "n_teleport4" then
						ontouch:SetSaveValue("target", "arena_"..math.random(4,5).."_start")
					end
				end
			end
		end)
	end
end

function MAP:OnMapRestart()
	noRespawnOptions = nil
end