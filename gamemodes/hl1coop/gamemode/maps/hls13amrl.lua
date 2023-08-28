MAP.ChapterTitle = "#HL1_Chapter14_Title"
MAP.ShowChapterTitle = true

if CLIENT then return end

MAP.StartingWeapons = {"weapon_crowbar", "weapon_glock", "weapon_357", "weapon_mp5", "weapon_shotgun", "weapon_crossbow", "weapon_rpg", "weapon_gauss", "weapon_hornetgun", "weapon_handgrenade", "weapon_satchel", "weapon_tripmine", "weapon_snark"}
MAP.StartingAmmo = {["MP5_Grenade"] = 2}

local importantNPCtable = {"scientist_c3a2", "thesci", "thegun", "theb", "c3a2_portsci"}
MAP.ImportantNPCs = {}
table.Merge(MAP.ImportantNPCs, importantNPCtable)
MAP.ImportantHealthBlacklist = {["theb"] = true}
MAP.NPCUseFix = {["scientist_c3a2"] = true, ["thesci"] = true}

function MAP:CreateViewPoints()
	GAMEMODE:CreateViewPointEntity(Vector(625, 600, 220), Angle(5, 140, 0))
	GAMEMODE:CreateViewPointEntity(Vector(-833, 2000, -740), Angle(0, -50, 0))
	GAMEMODE:CreateViewPointEntity(Vector(1997, 1906, 2035), Angle(70, -20, 0))
	GAMEMODE:CreateViewPointEntity(Vector(1980, 1441, 820), Angle(0, 53, 0))
end

function MAP:ModifyMapEntities()
	GAMEMODE:CreateWeaponEntity("weapon_crossbow", Vector(-355, 1018, 232), Angle(0, 185, 0))
	GAMEMODE:CreateWeaponEntity("weapon_mp5", Vector(-1615, 1870, -1010), Angle(0, 192, 0))
	GAMEMODE:CreateWeaponEntity("weapon_rpg", Vector(126, 1049, -780), Angle(0, 80, 0))
	GAMEMODE:CreateWeaponEntity("weapon_357", Vector(444, -719, -798), Angle(0, 20, 0))
	GAMEMODE:CreateWeaponEntity("weapon_mp5", Vector(1891, 2498, 1230), Angle(0, 30, 0))
	GAMEMODE:CreateWeaponEntity("weapon_shotgun", Vector(1744, 1160, 800), Angle(0, -105, 0))
	
	for k, v in pairs(ents.FindByName("c3a2d_door3")) do
		v:SetNotSolid(true)
		v:SetNoDraw(true)
	end
	
	for _, ent in pairs(ents.FindByClass("trigger_changelevel")) do
		ent.FadeEffect = true -- saving your eyes
	end
	
	for k, v in pairs(ents.FindInBox(Vector(3962, 1008, 2568), Vector(3662, 1200, 2442))) do
		if v:IsPickupItem() then
			v.RespawnTime = 1
		end
	end
end

local tele1pos = Vector(1890, 800, 180)
local tele2pos = Vector(-818, 1055, 310)
local tele3pos = Vector(-862, 2150, -745)
local tele4pos = Vector(2978, 2426, 1212)

function MAP:CreateMapEventCheckpoints(ent, activator)
	if ent:GetName() == "argue" then
		GAMEMODE:Checkpoint(1, Vector(-860, 930, -795), Angle(0, 45, 0), {tele1pos, tele2pos}, activator, "weapon_egon")
	end
	--[[if ent:GetName() == "c3a2spawn_mm" then
		GAMEMODE:Checkpoint(Vector(3540, 2910, 1165), Angle(0, 180, 0), {tele1pos, tele2pos}, activator, "weapon_egon")
	end]]--
	if ent:GetName() == "c3a2_rumbles1" then
		GAMEMODE:Checkpoint(3, Vector(3665, 705, 2445), Angle(0, 180, 0), {tele1pos, tele2pos, tele3pos, tele4pos}, activator, "weapon_egon")
	end
	if ent:GetName() == "music_track_19" then
		GAMEMODE:RemoveCoopSpawnpoints()
		GAMEMODE:CreateCoopSpawnpoints(Vector(3379, 1487, 2445), Angle(0, -30, 0))
		GAMEMODE:Checkpoint(4, Vector(3435, 1580, 2460), Angle(0, -90, 0), {tele1pos, tele2pos, tele3pos, tele4pos}, activator, "weapon_egon")
	end
end

function MAP:CreateMapCheckpoints()
	GAMEMODE:CreateCheckpointTrigger(2, Vector(2352, 2734, 1280), Vector(2216, 2715, 1160), Vector(1985, 2508, 1160), Angle(0, 90, 0), {tele1pos, tele2pos, tele3pos}, "weapon_egon")
end

local portalSentences = {
	["!SC_UPHERE"] = true,
	["!SC_FOOL"] = true,
	["!SC_PORTAL"] = true,
	["!SC_POSITION"] = true,
	["!SC_NOTYET"] = true,
	["!SC_PORTOPEN"] = true,
	["!SC_FOREVER"] = true
}

function MAP:OperateMapEvents(ent, input, caller, activator)
	local class, name = ent:GetClass(), ent:GetName()
	if class == "func_door" and name == "retinal_scanner_door" and input == "Open" then
		table.RemoveByValue(self.ImportantNPCs, "scientist_c3a2")
	end
	if class == "func_door" and name == "c3a2d_door2" and input == "Open" then
		table.RemoveByValue(self.ImportantNPCs, "thesci")
		table.RemoveByValue(self.ImportantNPCs, "theb")
	end
	if class == "scripted_sentence" and input == "BeginSentence" then
		local keyvalues = ent:GetKeyValues()
		local sentence = keyvalues.sentence
		if portalSentences[sentence] then
			local sEnt = ents.FindByName(keyvalues.entity)[1]
			if IsValid(sEnt) and sEnt:Health() > 0 then
				timer.Simple(0.05, function()
					if IsValid(sEnt) then
						sEnt:PlaySentence(sentence, 0, .1) -- 'stops' current
					end
				end)
				local sentence = string.Replace(sentence, "!", "")
				EmitSentence(sentence, sEnt:GetPos(), sEnt:EntIndex(), CHAN_VOICE, 1, 95)
			end
		end
	end
	if class == "scripted_sentence" and name == "c3a2_portaudio04" then
		local portsci = ents.FindByName("c3a2_portsci")[1]
		if IsValid(portsci) and portsci:Health() > 0 then
			table.RemoveByValue(self.ImportantNPCs, "c3a2_portsci")
			--sound.Play("scientist/c3a2_sci_portopen.wav", Vector(2261, 1418, 2832), 0, 100, 1)
		end
	end

	if class == "multi_manager" and input == "Trigger" then
		if name == "mm1" then
			for k, v in pairs(GAMEMODE:GetActivePlayersTable()) do
				if v != activator then
					v:SendScreenHintTop("#notify_pumpblue")
				end
			end
		end
		if name == "mm2" then
			for k, v in pairs(GAMEMODE:GetActivePlayersTable()) do
				if v != activator then
					v:SendScreenHintTop("#notify_pumporange")
				end
			end
		end
	end
	
	if class == "trigger_hurt" and name == "c3a2d_alldead" and input == "Enable" then
		SetGlobalBool("DisablePlayerRespawn", true)
		if GetGlobalFloat("WaitTime") < CurTime() then
			timer.Simple(5, function()
				GAMEMODE:GameOver()
			end)
		end
	end
	
	if IsValid(caller) and caller:GetClass() == "trigger_once" and name == "heymaster" and input == "Trigger" then
		for k, v in pairs(ents.FindByClass("speaker")) do
			v:TurnOff()
		end
	end
end

function MAP:OnMapRestart()
	if self.ImportantNPCs then table.Merge(self.ImportantNPCs, importantNPCtable) end
	SetGlobalBool("DisablePlayerRespawn", false)
end