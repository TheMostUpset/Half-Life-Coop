MAP.ChapterTitle = "#HL1_Chapter1_Title"
MAP.ShowChapterTitle = false

MAP.ShowIntro = true
MAP.DisableFullRespawn = true

local titlesTable = {
	["CR1"] = "Ted Backman",
	["CR2"] = "TK Backman",
	["CR3"] = "Kelly Bailey",
	["CR4"] = "Yahn Bernier",
	["CR5"] = "Ken Birdwell",
	["CR6"] = "Steve Bond",
	["CR7"] = "Dario Casali",
	["CR8"] = "John Cook",
	["CR9"] = "Greg Coomer",
	["CR10"] = "Wes Cumberland",
	["CR11"] = "John Guthrie",
	["CR12"] = "Mona Lisa Guthrie",
	["CR13"] = "Mike Harrington",
	["CR14"] = "Monica Harrington",
	["CR15"] = "Brett Johnson",
	["CR16"] = "Chuck Jones",
	["CR17"] = "Marc Laidlaw",
	["CR18"] = "Karen Laur",
	["CR19"] = "Randy Lundeen",
	["CR20"] = "Yatsze Mark",
	["CR21"] = "Lisa Mennet",
	["CR22"] = "Gabe Newell",
	["CR23"] = "Dave Riller",
	["CR24"] = "Aaron Stackpole",
	["CR25"] = "Jay Stelly",
	["CR26"] = "Harry Teasley",
	["CR35"] = "Steve Theodore",
	["CR36"] = "Bill Van Buren",
	["CR37"] = "Robin Walker",
	["CR38"] = "Douglas R. Wood"
}

if CLIENT then
	for k, v in pairs(titlesTable) do
		language.Add(k, v)
	end
end

if CLIENT then return end

MAP.EnvFadeWhitelist = {
	["fade_in"] = true
}

MAP.NoSuitOnSpawn = true
MAP.StartingWeapons = false
MAP.DisallowSurvivalMode = true
MAP.DisallowSpeedrunMode = true
MAP.npcLagFixDisabled = true

local trainEnt = NULL

function MAP:CreateViewPoints()
	GAMEMODE:CreateViewPointEntity(Vector(1783, 7923, 800), Angle(15, 55, 0))
	GAMEMODE:CreateViewPointEntity(Vector(-3777, 4970, 641), Angle(3, 40, 0))
end

local cutMusic = {
	["HL1_Music.track_3_a"] = true,
	["HL1_Music.track_3_b"] = true,
	["HL1_Music.track_3_d"] = true,
}

local seatPos = {
	{Vector(-94, -48, 0), Angle(0, 90, 0), 70},
	{Vector(-94, -16, 0), Angle(0, 90, 0), 40},
	{Vector(-73, -48, 0), Angle(0, -90, 0)},
	{Vector(-73, -16, 0), Angle(0, -90, 0)},
	{Vector(9, -48, 0), Angle(0, 90, 0)},
	{Vector(9, -16, 0), Angle(0, 90, 0)},
	{Vector(48, -48, 0), Angle(0, 90, 0), 70},
	{Vector(48, -16, 0), Angle(0, 90, 0), 40},
}

function MAP:FixMapEntities()
	for k, v in pairs(ents.FindByClass("ambient_generic")) do
		local var = v:GetInternalVariable("message")
		if var == "HL1_Music.track_3_0" or var == "HL1_Music.track_3_c" then
			v:SetSaveValue("message", "song_hl1_3")
		end
		if cutMusic[var] then
			v:Remove()
		end
	end
	local train = ents.FindByName("train")[1]
	if IsValid(train) then
		for k, v in pairs(seatPos) do
			local seat = ents.Create("prop_vehicle_prisoner_pod")
			seat:SetModel("models/nova/jeep_seat.mdl")
			seat:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt") 
			seat:SetPos(train:GetPos() + v[1] + Vector(0, 0, 20))
			seat:SetAngles(train:GetAngles() + v[2])
			seat:SetParent(train)
			seat:SetNoDraw(true)
			if v[3] then
				seat.exitPosRight = v[3]
			end
			seat:Spawn()
			seat:Activate()
			seat:SetCollisionGroup(COLLISION_GROUP_WORLD)
		end
	end
	for k, v in ipairs(ents.FindByClass("trigger_changelevel")) do
		v.Untouchable = true
	end
end

function GM:PlayerLeaveVehicle(ply, veh)
	local exitPos = veh:GetForward() * 28
	if veh.exitPosRight then
		exitPos = veh:GetRight() * veh.exitPosRight
	end
	ply:SetPos(veh:GetPos() - Vector(0, 0, 10) + exitPos)
	ply:SetEyeAngles(veh:GetAngles() + Angle(0, 90, 0))
end

function MAP:ModifyMapEntities()
	--GAMEMODE:CreateCoopSpawnpoints(Vector(2554, 3534, 780), Angle(0, 180, 0))	

	if GAMEMODE:GetCoopState() == COOP_STATE_FIRSTLOAD then
		ents.FindByName("music_track_3")[1]:Remove()
		local removeEnts = ents.FindByClass("trigger_auto")
		table.Add(removeEnts, ents.FindByClass("monster_*"))
		for k, v in pairs(removeEnts) do
			v:Remove()
		end
	end
end

function MAP:OperateMapEvents(ent, input, caller, activator)
	local class, name = ent:GetClass(), ent:GetName()
	if !game.SinglePlayer() and class == "env_message" then
		local msg = ent:GetKeyValues().message
		if msg and msg != "CR27" and msg != "OPENTITLE4" then
			local pos, t = 0, 0
			if titlesTable[msg] then
				pos, t = 1, 1
			end
			SendMessage(msg, pos, t)
		end
	end
	if class == "path_track" and name == "lower110b" and input == "InPass" and IsValid(caller) and caller:GetClass() == "func_tracktrain" then
		caller:EmitSound("hl1/plats/ttrain_brake1.wav")
		--[[timer.Simple(.1, function()
			if IsValid(caller) then
				caller:StopMoveSound() -- fix for looping sound
			end
		end)]]
	end
	if class == "path_track" and name == "lower109" and input == "InPass" then
		SendMessage("Co-op adaptation by:", 1, 1)
		timer.Simple(4, function()
			SendMessage("TheMostUpset", 1, 1)
			timer.Simple(3, function()
				SendMessage("Mr.Lazy", 1, 1)
				timer.Simple(3, function()
					SendMessage("Maestra Fénix", 1, 1)
				end)
			end)
		end)
	end
	if IsValid(activator) and activator:IsPlayer() and class == "func_tracktrain" and name == "train" and input == "StartForward" then
		trainEnt = ent
	end
end

function MAP:OnPlayerSpawn(ply)	
	if IsValid(trainEnt) then
		local spawnpos = trainEnt:GetPos() - trainEnt:GetRight() * 32
		local tramAng = trainEnt:GetAngles()
		tramAng:Normalize()
		ply:SetPos(spawnpos + Vector(0, 0, 8))
		ply:SetEyeAngles(tramAng)
	end
end