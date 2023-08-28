MAP.ChapterTitle = "#HL1_Chapter12_Title"
MAP.ShowChapterTitle = true

if CLIENT then return end

MAP.StartingWeapons = {"weapon_crowbar", "weapon_glock", "weapon_357", "weapon_mp5", "weapon_shotgun", "weapon_crossbow", "weapon_gauss", "weapon_handgrenade", "weapon_satchel", "weapon_tripmine", "weapon_snark"}
MAP.StartingAmmo = {["MP5_Grenade"] = 2}

MAP.FallToDeath = {
	{Vector(-4016, 3216, -1194), Vector(2090, -3872, -6335)}
}

function MAP:CreateViewPoints()
	GAMEMODE:CreateViewPointEntity(Vector(-9340, 3415, 1920), Angle(5, 150, 0))
end

function MAP:CreateMapEventCheckpoints(ent, activator)
	local tele1pos = Vector(-8230, 4990, 1750)
	local tele2pos = Vector(-5460, -1032, 940)
	if ent:GetName() == "apache_maker_2" then
		local pos = Vector(-6485, 335, 580)
		local ang = Angle(0, -40, 0)
		GAMEMODE:Checkpoint(1, pos, ang, tele1pos, activator)
	end
	if ent:GetName() == "music_track_11" then
		local pos = Vector(1055, 610, 770)
		local ang = Angle(0, -90, 0)
		GAMEMODE:Checkpoint(2, pos, ang, {tele1pos, tele2pos}, activator)	
	end
end

function MAP:ModifyMapEntities()
	GAMEMODE:CreateWeaponEntity("weapon_mp5", Vector(-6316, 1015, 567), Angle())
	
	if game.MaxPlayers() > 1 then
		local tentFix = ents.Create("hl1_tentacle_fix")
		if IsValid(tentFix) then
			local pos = Vector(-5465, 1939, 1222)
			tentFix:SetPos(pos)
			tentFix:Spawn()
			tentFix.Radius = 500
			tentFix.UpdateTime = .75
		end
	end
end

function MAP:CreateExtraEnemies()
	GAMEMODE:CreateNPCSpawner("monster_ichthyosaur", 5, Vector(-11013, 5426, 555), Angle(0, -20, 0), 1300, false)
	GAMEMODE:CreateNPCSpawner("monster_ichthyosaur", 10, Vector(-11072, 4616, 371), Angle(0, 6, 0), 1300, false)
end