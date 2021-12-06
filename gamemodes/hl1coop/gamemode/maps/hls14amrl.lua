MAP.ChapterTitle = "#HL1_Chapter15_Title"
MAP.ShowChapterTitle = true

if CLIENT then return end

MAP.StartingWeapons = {"weapon_crowbar", "weapon_glock", "weapon_357", "weapon_mp5", "weapon_shotgun", "weapon_crossbow", "weapon_rpg", "weapon_gauss", "weapon_egon", "weapon_hornetgun", "weapon_handgrenade", "weapon_satchel", "weapon_tripmine", "weapon_snark"}
MAP.StartingWeaponsLight = {"weapon_hornetgun"}
MAP.StartingAmmo = {["MP5_Grenade"] = 2}

MAP.FallToDeath = {
	{Vector(-9546, 14219, -800), Vector(-14346, 9835, -2896)},
	{Vector(10636, 5485, -800), Vector(7188, 9389, -1248)}, -- gonarch 1
	{Vector(2412, 9637, -1856), Vector(3356, 8293, -1130)}, -- gonarch 2
	{Vector(-14627, -2377, -3800), Vector(-10963, 1623, -4431)}, -- interloper
	{Vector(5325, -10048, -805), Vector(9005, -6112, -1305)},
	{Vector(3925, -6640, -1961), Vector(4445, -6464, -1093)},
	{Vector(3933, -7392, -970), Vector(2061, -4704, -2089)}
}

function MAP:CreateViewPoints()
	GAMEMODE:CreateViewPointEntity(Vector(-13090, 9870, 750), Angle(4, 75, 0))
end

local tele1pos = Vector(-10784, 13612, 1630)
local tele2pos = Vector(5329, 8205, -725)
local tele3pos = Vector(-12650, -235, -3416)

function MAP:CreateMapEventCheckpoints(ent, activator)
	if ent:GetName() == "c4a2_collapse" then
		GAMEMODE:Checkpoint(2, Vector(5218, 9104, -780), Angle(0, -170, 0), {tele1pos, tele2pos}, activator)
	end
end

function MAP:CreateMapCheckpoints()
	GAMEMODE:CreateCheckpointTrigger(1, Vector(9601, 7949, -592), Vector(9715, 8143, -500), Vector(9434, 8805, -570), Angle(0, -120, 0), tele1pos) -- gonarch
	GAMEMODE:CreateCheckpointTrigger(3, Vector(-13103, -772, -3123), Vector(-12773, -1127, -3471), Vector(-12975, -1080, -3465), Angle(0, 65, 0), {tele1pos, tele2pos})
	GAMEMODE:CreateCheckpointTrigger(4, Vector(6499, -8204, -553), Vector(6803, -8419, -410), Vector(6660, -8288, -535), Angle(0, -90, 0), {tele1pos, tele2pos, tele3pos})
end

function MAP:FixMapEntities()
	local rem = ents.FindByClass("npc_enemyfinder")
	table.Add(rem, ents.FindByClass("ai_relationship"))
	for k, v in pairs(rem) do
		v:Remove()
	end
	
	for k, v in pairs(ents.FindByClass("func_tanklaser")) do
		local cEnt = ents.Create("func_tank_controller")
		if IsValid(cEnt) then
			cEnt:SetParent(v)
			cEnt:SetPos(v:GetPos() - Vector(0,0,16))
			cEnt.ForceTraceCheck = true
			cEnt:Spawn()
		end
	end
	
	for k, v in pairs(ents.FindInBox(Vector(2907, 11718, -1281), Vector(3338, 12009, -1119))) do
		if string.StartWith(v:GetClass(), "xen_spore") then
			v:SetNotSolid(true)
		end
	end
	for k, v in pairs(ents.FindByName("mammagibs")) do
		v:SetKeyValue("m_flGibLife", "30")
	end
end

function MAP:ModifyMapEntities()
	GAMEMODE:CreateWeaponEntity("weapon_shotgun", Vector(-12610, 11180, -87), Angle(0, -45, 0))
	GAMEMODE:CreateWeaponEntity("weapon_rpg", Vector(9471, 8052, -555), Angle(0, 45, 0))
	GAMEMODE:CreateWeaponEntity("weapon_357", Vector(5267, 7906, -746), Angle(0, 15, 0))
	GAMEMODE:CreateWeaponEntity("weapon_mp5", Vector(3486, 8995, -1002), Angle(0, -35, 0))
	GAMEMODE:CreateWeaponEntity("weapon_crossbow", Vector(-12213, 872, -3030), Angle(0, 55, 0))
	GAMEMODE:CreateWeaponEntity("weapon_357", Vector(-11862, 365, -3700), Angle(0, 45, 0))
	GAMEMODE:CreateWeaponEntity("weapon_357", Vector(6870, -8494, -506), Angle(0, 5, 0))
	GAMEMODE:CreateWeaponEntity("weapon_shotgun", Vector(6838, -8520, -498), Angle(0, 45, 0))
	GAMEMODE:CreateWeaponEntity("weapon_rpg", Vector(7347, -7568, -511), Angle(0, 45, 0))
	GAMEMODE:CreateWeaponEntity("weapon_mp5", Vector(7321, -7652, -511), Angle(0, 45, 0))
	
	for k, v in pairs(ents.FindByName("c4a1c")) do
		if v:GetClass() == "trigger_once" then
			v:Fire("Disable")
		end
	end
	local mins, maxs = Vector(4604, -5058, -473), Vector(4624, -5078, -369)
	local func = function()
		for k, v in pairs(ents.FindByName("c4a1c")) do
			if v:GetClass() == "trigger_once" then
				v:Fire("Enable")
			end
		end
	end
	GAMEMODE:CreateWaitTrigger(mins, maxs, 50, false, func, WAIT_FREEZE, true)
	
	for k, v in pairs(ents.FindByClass("info_bigmomma")) do
		local healthkey = v:GetKeyValues().health
		if healthkey and healthkey > 0 then
			if !v.healthDefault then
				v.healthDefault = healthkey
			end
			v:SetKeyValue("health", healthkey * cvars.Number("sk_bigmomma_health_factor", 1) * GAMEMODE:NPCHealthMultiplier())
		end
	end
	
	if game.MaxPlayers() > 1 then
		local tentFixEnts = {
			{pos = Vector(6186, -9256, -440), npcPos = Vector(6237, -9239, -771), radius = 450},
			{pos = Vector(3372, -6562, -589), npcPos = Vector(3372, -6562, -885), radius = 500},
			{pos = Vector(3057, -5861, -540), npcPos = Vector(3057, -5861, -774), radius = 450},
		}
		for k, v in pairs(tentFixEnts) do
			local tentFix = ents.Create("hl1_tentacle_fix")
			if IsValid(tentFix) then
				tentFix:SetPos(v.pos)
				tentFix.NPCPos = v.npcPos
				tentFix:Spawn()
				tentFix.Radius = v.radius
			end
		end
	end
end

function MAP:OnPlayerSpawn(ply)
	ply:SetLongJump(true, true)
end