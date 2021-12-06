MAP.ChapterTitle = "#HL1_Chapter17_Title"
MAP.ShowChapterTitle = true

if CLIENT then return end

MAP.BlockSpawnpointCreation = {
	["hls14amrl"] = true
}

MAP.StartingWeapons = {"weapon_crowbar", "weapon_glock", "weapon_357", "weapon_mp5", "weapon_shotgun", "weapon_crossbow", "weapon_rpg", "weapon_gauss", "weapon_egon", "weapon_hornetgun", "weapon_handgrenade", "weapon_satchel", "weapon_tripmine", "weapon_snark"}
MAP.StartingWeaponsLight = {"weapon_hornetgun"}
MAP.StartingAmmo = {["MP5_Grenade"] = 2}

MAP.FallToDeath = {
	{Vector(4066, 1278, -3008), Vector(-750, -2431, -1600)}, -- three chambers connected
	{Vector(9952, -4995, 1037), Vector(6209, -995, -1496)} -- nihilanth portal
}

function MAP:CreateViewPoints()
	GAMEMODE:CreateViewPointEntity(Vector(-573, -2933, -500), Angle(8, 100, 0))
end

local tele1pos = Vector(-1742, -713, -840)
local tele2pos = Vector(1692, -937, -780)

function MAP:CreateMapEventCheckpoints(ent, activator)
	if ent:GetName() == "sirens" then
		GAMEMODE:Checkpoint(1, Vector(846, -2463, -780), Angle(0, -90, 0), tele1pos, activator)
	end
	if ent:GetName() == "lasta" then
		GAMEMODE:Checkpoint(3, Vector(8613, -1674, 2106), Angle(0, -115, 0), {tele1pos, tele2pos}, activator)
	end
end

function MAP:CreateMapCheckpoints()
	GAMEMODE:CreateCheckpointTrigger(2, Vector(1514, -497, -872), Vector(1475, -386, -945), Vector(1137, -441, -912), Angle(), tele1pos)
end

function MAP:FixMapEntities()
	for k,v in pairs(ents.FindByClass("func_platrot")) do
		local fTrig = ents.Create("hl1_trigger_func")
		if IsValid(fTrig) then
			function fTrig:Touch(ent)
				if ent:GetClass() == "hornet" then
					ent:Remove()
				end
			end
			fTrig:SetPos(v:GetPos())
			fTrig:SetParent(v)
			fTrig:Spawn()
			fTrig:SetCollisionBounds(v:GetCollisionBounds())
		end
	end
end

function MAP:ModifyMapEntities()
	GAMEMODE:CreateWeaponEntity("weapon_357", Vector(177, -3031, -946), Angle(0, 145, 0))
	GAMEMODE:CreateWeaponEntity("weapon_crossbow", Vector(980, -2222, -952), Angle(0, 165, 0))
	GAMEMODE:CreateWeaponEntity("weapon_357", Vector(2423, -837, -981), Angle(0, 165, 0))
	GAMEMODE:CreateWeaponEntity("weapon_rpg", Vector(823, 364, 32), Angle(0, 25, 0))

	local mins, maxs = Vector(8900, -4048, 1656), Vector(8881, -4067, 1756)
	for k, v in pairs(ents.FindInSphere(maxs, 16)) do
		if v:GetClass() == "trigger_once" then
			v:Fire("Disable")
		end
	end
	local func = function()
		for k, v in pairs(ents.FindInSphere(maxs, 16)) do
			if v:GetClass() == "trigger_once" then
				v:Fire("Enable")
			end
		end
	end
	GAMEMODE:CreateWaitTrigger(mins, maxs, 50, false, func, WAIT_LOCK, true)
end

function MAP:OnPlayerSpawn(ply)
	ply:SetLongJump(true, true)
end