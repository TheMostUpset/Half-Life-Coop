local meta = FindMetaTable("Player")

medicSnd = Sound("fgrunt/medic.wav")

function meta:SetupDataTables()
	self:NetworkVar("Int", 0, "Score")
	self:NetworkVar("Int", 1, "FlashlightPower")
end

local ItemPickupSound = Sound("items/gunpickup2.wav")
local AmmoPickupSound = Sound("items/9mmclip1.wav")

function meta:PlayPickupSound(lvl, chan)
	lvl = lvl or 75
	chan = chan or CHAN_ITEM
	self:EmitSound(ItemPickupSound, lvl, 100, 1, chan)
end

function meta:PlayAmmoPickupSound(lvl, chan)
	lvl = lvl or 75
	chan = chan or CHAN_ITEM
	self:EmitSound(AmmoPickupSound, lvl, 100, 1, chan)
end
	
function meta:CanChasePlayer()
	return GAMEMODE:GetCoopState() == COOP_STATE_INGAME and self:IsFrozen() --and self:IsInWaitTrigger()
end

function meta:CanJoinGame()
	return true
end
	
function meta:IsChasing()
	local viewent = self:GetViewEntity()
	return IsValid(viewent) and viewent:IsPlayer() and viewent != self
end

function meta:IsSpectator()
	return self:Team() == TEAM_SPECTATOR or self:IsDeadInSurvival() and (self.DiedInSurvival or self:GetScore() < cvar_price_respawn_survival:GetInt())
end

function meta:IsDeadInSurvival()
	return GAMEMODE:GetSurvivalMode() and !self:Alive() and self:Team() == TEAM_COOP
end
	
function meta:IsStuck()
	if !IsValid(self) or self:GetMoveType() == MOVETYPE_NOCLIP or !self:Alive() then return end
	local tr = util.TraceEntity({
		start = self:GetPos(), --+ Vector(0, 0, 1),
		endpos = self:GetPos(), --+ Vector(0, 0, 1),
		filter = player.GetAll(),
		mask = MASK_PLAYERSOLID
	}, self)
	local worldEntities = {
		["func_breakable"] = true,
		["func_pushable"] = true,
		["func_train"] = true,
		["func_trackchange"] = true,
		["func_tracktrain"] = true,
		["func_movelinear"] = true,
		["func_door"] = true,
		["func_door_rotating"] = true,
		["func_healthcharger"] = true,
		["func_recharge"] = true,
		["func_tank"] = true,
		["func_tankmortar"] = true,
		["func_rotating"] = true,
		["hl1_playerclip"] = true,
		["hl1_prop_static"] = true,
		["hl1_prop_breakable"] = true,
		["prop_physics"] = true
	}
	--print(tr.Hit, tr.Entity, tr.HitWorld, self:OnGround())
	return tr.HitWorld or (IsValid(tr.Entity) and (worldEntities[tr.Entity:GetClass()] or tr.Entity:IsNPC()))
end

function meta:IsInWaitTrigger()
	return self:GetNWBool("InWaitTrigger")
end

function meta:SetDefaultPlayerColor()
	local teamcol = team.GetColor(self:Team())
	self:SetPlayerColor(Vector(teamcol.r / 255, teamcol.g / 255, teamcol.b / 255))
end
	
function meta:SetupPlayerColor()
	local cl_playercolor
	
	if SERVER then
		cl_playercolor = self:GetInfo("hl1_coop_cl_playercolor")
	else
		cl_playercolor = cvars.String("hl1_coop_cl_playercolor")
	end

	if cl_playercolor and #cl_playercolor > 0 then
		local col = string.Explode(" ", cl_playercolor)
		if col[1] and col[2] and col[3] then
			self:SetPlayerColor(Vector(col[1] / 255, col[2] / 255, col[3] / 255))
		else
			self:SetDefaultPlayerColor()
		end
	else
		self:SetDefaultPlayerColor()
	end
end

local sci_pmodels = {
	"models/player/coop/scientist_einstien.mdl",
	"models/player/coop/scientist_luther.mdl",
	"models/player/coop/scientist_slick.mdl",
	"models/player/coop/scientist_walter.mdl"
}

function meta:SetupPlayerModel()
	local customModelsBool = false

	if SERVER then
		customModelsBool = cvars.Bool("hl1_coop_sv_custommodels")
	else
		customModelsBool = GetGlobalBool("hl1_coop_sv_custommodels", false)
	end
	
	if customModelsBool then
		local cl_playermodel = self:GetInfo("hl1_coop_cl_playermodel")
		if CLIENT then
			cl_playermodel = cvars.String("hl1_coop_cl_playermodel")
		end
		local modelname = player_manager.TranslatePlayerModel(cl_playermodel)
		util.PrecacheModel(modelname)
		self:SetModel(modelname)
		
		local cl_skin = self:GetInfo("hl1_coop_cl_playermodel_skin")
		if tonumber(cl_skin) >= self:SkinCount() then
			self:ConCommand("hl1_coop_cl_playermodel_skin 0")
			self:SetSkin(0)
		else
			self:SetSkin(cl_skin)
		end
		
		local cl_bodygroups = self:GetInfo("hl1_coop_cl_playermodel_bodygroups")
		self:SetBodyGroups(cl_bodygroups)
	else
		if self:IsSuitEquipped() then
			self:SetModel(DEFAULT_PLAYERMODEL_PATH)
		else
			self:SetModel(sci_pmodels[math.random(1, 4)])
		end
	end
	
	hook.Run("ApplyViewModelHands", self, nil, true)
end

local defaultHands = {
	[DEFAULT_PLAYERMODEL_PATH] = true,
	["models/player/hl1/helmet.mdl"] = true,
	["models/player/hl1/player.mdl"] = true,
	["models/player/hl1/holo.mdl"] = true
}

function meta:ShouldUseHands()
	local modelname = self:GetModel() == "models/player.mdl" and player_manager.TranslatePlayerModel(self:GetInfo("hl1_coop_cl_playermodel")) or self:GetModel()
	return GetGlobalBool("hl1_coop_sv_custommodels", false) and !defaultHands[modelname]
end

function meta:DropAmmo(ent)
	if self:Alive() then
		local wep = self:GetActiveWeapon()
		if IsValid(wep) and wep:IsScripted() then
			local ammotype = wep:GetPrimaryAmmoType()
			local ammo = self:GetAmmoCount(ammotype)
			ent = ent or wep.AmmoEnt
			if ammo > 0 and ent then
				local num = wep.Primary.DefaultClip
				if ammo < num then
					num = ammo
				end
				if SERVER then
					local ammoent = ents.Create(ent)
					if !IsValid(ammoent) then return end
					local pos = self:WorldSpaceCenter()
					local ang = self:EyeAngles():Forward()
					local tr = util.TraceHull({
						start = pos,
						endpos = pos + ang * 60,
						filter = {ammoent, self},
						mins = Vector(-8, -8, 0),
						maxs = Vector(8, 8, 8)
					})
					if tr.HitWorld then return end
					ammoent:SetPos(tr.HitPos)
					--ammoent:SetAngles(Angle(0, self:EyeAngles()[2], 0))
					ammoent:SetVelocity(ang * 100)
					ammoent:Spawn()
					if ammoent:IsWeapon() then
						ammoent.DroppedAmmo = num
					else
						ammoent.AmmoAmount = num
					end
				end
				self:SetAmmo(ammo - num, ammotype)
			end
		end
	end
end

function meta:SetActAbsVelocity(vel)
	self:SetNW2Vector("ActAbsVelocity", vel)
end

function meta:GetActAbsVelocity(fallback)
	fallback = fallback or Vector()
	return self:GetNW2Vector("ActAbsVelocity", fallback)
end

function meta:GetLongJump()
	return self:GetNW2Bool("LongJump")
end

function meta:UseSound(t)
	if cvar_gmodsuit:GetBool() then return end
	local snd
	if t == 1 then
		snd = "common/wpn_select.wav"
	else
		snd = "player/suit_denydevice.wav"
	end
	self:EmitSound(snd, 60, 100, .5)
end
	
function meta:SetSuitUpdate(name, iNoRepeatTime, ignorecvar, customDuration)
	if !ignorecvar and !cvar_hevvoice:GetBool() or cvar_gmodsuit:GetBool() or !self:IsSuitEquipped() then return end

	if self.HEVSentenceTable and self.HEVSentenceTable[name] and self.HEVSentenceTable[name] > CurTime() then return end
	
	iNoRepeatTime = iNoRepeatTime or 0
	
	if iNoRepeatTime > 0 then
		if !self.HEVSentenceTable then
			self.HEVSentenceTable = {}
		end
		if self.HEVSentenceTable then
			self.HEVSentenceTable[name] = CurTime() + iNoRepeatTime
		end
	end
	
	local pitchMul = math.Rand(0.97, 1.05)
	local vol = 0.3
	local sndlvl = 65	
	
	local timerName = "HEVMessage"
	local plyIndex = self:EntIndex()
	local queue, maxqueue = 0, 10
	for q = 0, maxqueue do
		if timer.Exists(timerName..q..plyIndex) then
			queue = math.min(q + 1, maxqueue)
		end
	end
	
	if queue >= maxqueue then return end
	
	local delay = self.SentenceLastTime and self.SentenceLastTime > CurTime() and self.SentenceLastTime - CurTime() or 0
	local sDuration = customDuration or SentenceDuration(name)
	self.SentenceLastTime = CurTime() + math.max(sDuration / pitchMul + delay - 0.5, 0)
	--print(self, queue, name, self.SentenceLastTime - CurTime())
	
	timer.Create(timerName..queue..plyIndex, delay + 0.15, 1, function()
		if IsValid(self) then
			local plyIndex = self:EntIndex()
			if self:Alive() and self:IsSuitEquipped() then
				-- the channel used to be CHAN_VOICE but after some gmod updates sentences started to cut each other
				EmitSentence(name, self:GetPos(), plyIndex, CHAN_AUTO, vol, sndlvl, 0, 100 * pitchMul)
			else
				self:ClearSuitMessages()
			end
		end
	end)
end

function meta:ClearSuitMessages()
	self.HEVSentenceTable = nil
	self.SentenceLastTime = nil
	for q = 0, 10 do
		timer.Remove("HEVMessage"..q..self:EntIndex())
	end
end

function meta:HasFallenToDeath(pos)
	pos = pos or self:GetPos()
	if MAP.FallToDeath then
		for k, v in pairs(MAP.FallToDeath) do
			if pos:WithinAABox(v[1], v[2]) then
				return true
			end
		end
	end
	return false
end

function meta:SetPunchAngle(ang)
	if game.SinglePlayer() and SERVER then
		net.Start("HL1punchangle")
		net.WriteEntity(self)
		net.WriteAngle(ang)
		net.Send(self)
	end
	if CLIENT then
		if IsFirstTimePredicted() then
			self.punchangle = ang
		end
	else
		self.punchangle = ang
	end
end	

if SERVER then

	local cvar_wboxstay = CreateConVar("hl1_coop_sv_wboxstay", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Players cannot pickup other's weaponbox")

	function meta:SetupMovementParams()
		local runspeed, walkspeed = 160, 320
		local gravity = GetConVarNumber("sv_gravity")
		local jumppower = math.sqrt(2 * gravity * 45.0)
		self:SetRunSpeed(runspeed)
		self:SetWalkSpeed(walkspeed)
		self:SetJumpPower(jumppower)
		self:SetCrouchedWalkSpeed(.4)
		self:SetDuckSpeed(.4)
		self:SetUnDuckSpeed(.15)
		
		timer.Simple(1, function()
			if IsValid(self) then
				if self:GetWalkSpeed() != walkspeed or self:GetRunSpeed() != runspeed or math.floor(self:GetJumpPower()) != math.floor(jumppower) then
					PrintMessage(HUD_PRINTTALK, "Warning! Movement has been changed by some addon! Expect issues!")
				end
			end
		end)
	end

	function meta:AddScore(n, text)
		if n != 0 then
			self:SetScore(self:GetScore() + n)
			self:SendScreenMessageScore(n, text)
			
			if cvar_scoretracking:GetBool() then
				self:SetFrags(self:GetScore())
			end
		end
	end
	
	function meta:Unstuck()
		self:ChatPrint("You are stuck. Let's fix this.")
		timer.Simple(1, function()
			if self:IsStuck() then
				for i = 0, 5 do
					if self:IsStuck() then
						local tr = util.TraceLine({
							start = self:GetPos() + self:OBBMins(),
							endpos = self:GetPos() + self:OBBMaxs(),
							filter = self
						})
						local norm = tr.HitNormal
						if norm:IsZero() then
							tr = util.TraceLine({
								start = self:GetPos() + self:OBBMaxs(),
								endpos = self:GetPos() + self:OBBMins(),
								filter = self
							})
							norm = tr.HitNormal
						end
						if norm:IsZero() then
							norm = (tr.HitPos - self:GetPos()):GetNormalized()
						end
						self:SetPos(self:GetPos() + norm * 16)
						if i == 5 and self:IsStuck() then
							local spawnpoint = hook.Call("PlayerSelectSpawn", GAMEMODE, self, true)
							if IsValid(spawnpoint) then
								self:SetPos(spawnpoint:GetPos())
								self:SetEyeAngles(spawnpoint:GetAngles())
								self.canTakeDamage = nil
							else
								print("Cannot find spawnpoint!")
							end
						end
					else
						break
					end
				end
			else
				self:ChatPrint("Canceled!")
			end
		end)
	end

	function meta:CallMedic()
		local ragdoll = self:GetRagdollEntity()
		if (GAMEMODE:GetSurvivalMode() or cvar_medkit:GetBool()) and IsValid(self) and (self:Alive() or IsValid(ragdoll)) and self:Team() == TEAM_COOP and (!self.CallMedicTime or self.CallMedicTime <= CurTime()) then
			if !self:Alive() and IsValid(ragdoll) then
				self:EmitSound(medicSnd, 75, 100, 0) -- doing this for precache
				EmitSound(medicSnd, ragdoll:GetPos(), ragdoll:EntIndex(), CHAN_VOICE, 1, 100, 1, 100 + math.random(-5, 5))
			else
				self:EmitSound(medicSnd, 80, 100 + math.random(-5, 5), 1, CHAN_VOICE)
			end
			self.CallMedicTime = CurTime() + 3
			self:SetNWFloat("CallMedicTime", self.CallMedicTime)
		end
	end
	
	function meta:GiveMedkit()
		if !GAMEMODE:Get1hpMode() then
			self:Give("weapon_healthkit")
		end
	end
	
	function meta:DropWeaponBox(noowner)
		local wbox = ents.Create("weaponbox")
		if IsValid(wbox) then
			local weapons = GAMEMODE:StorePlayerAmmunition(self)
			if weapons then
				local pos = self:GetPos()
				local ang = self:EyeAngles()
				if GAMEMODE.Deathmatch then
					pos = self:WorldSpaceCenter()
					local tr = util.TraceHull({
						start = pos,
						endpos = pos + ang:Forward() * 8,
						filter = {wbox, self},
						mins = Vector(-8, -8, 0),
						maxs = Vector(8, 8, 8)
					})
					
					pos = tr.HitPos
				end
				wbox:SetPos(pos)
				wbox:SetWeaponTable(weapons)
				if GAMEMODE.Deathmatch then
					wbox:SetVelocity(ang:Forward() * 200)
				elseif !noowner then
					wbox:SetOwner(self)
				end
				wbox:Spawn()
				
				if !GAMEMODE:GetSpeedrunMode() and !cvar_wboxstay:GetBool() then 
					self.wboxEnt = wbox
				end
				
				if !GAMEMODE.Deathmatch then
					local glow = ents.Create("env_sprite")
					glow:SetKeyValue("rendercolor", "224 224 255")
					glow:SetKeyValue("GlowProxySize", "2")
					glow:SetKeyValue("HDRColorScale", "1")
					glow:SetKeyValue("renderfx", "15")
					glow:SetKeyValue("rendermode", "3")
					glow:SetKeyValue("renderamt", "64")
					glow:SetKeyValue("model", "sprites/animglow01.vmt")
					glow:SetKeyValue("scale", ".64")
					glow:SetParent(wbox)
					glow:SetPos(wbox:GetPos() + Vector(0,0,32))
					glow:Spawn()
				end
			end
		end
	end

	function meta:SetLongJump(b, silent)
		silent = silent or false
		self:SetNW2Bool("LongJump", b)
		--[[self.HasLongJump = b
		net.Start("SetLongJumpClient")
		net.WriteBool(b)
		net.WriteBool(silent)
		net.Send(self)]]
		if b and !silent then
			EmitSentence("HEV_A1", self:GetPos(), self:EntIndex(), CHAN_VOICE, 0.3)
			timer.Simple(.5, function()
				if IsValid(self) and self:Alive() and self:GetLongJump() then
					self:SendScreenHint(1)
				end
			end)
		end
	end

	function meta:SetWaitBool(b)
		self:SetNWBool("InWaitTrigger", b)
	end
	
	function meta:SetSpawnProtectionTime(t)
		self.SpawnProtectionTime = CurTime() + t
		self:SendLua("LocalPlayer().SpawnProtectionTime = CurTime() + "..t)
	end
	
	function meta:ResetVars(keeplj)
		self.DeathEnt = nil
		self.DeathPos = nil
		self.DeathAng = nil
		self.DeathDuck = nil
		self.KilledByFall = nil
		if !keeplj then
			self:SetLongJump(false)
		end
	end
	
	function meta:ChasePlayer(ply)
		local viewent = self:GetViewEntity()
		if IsValid(viewent) and viewent:GetClass() == "point_viewcontrol" then return end
		
		if self:CanChasePlayer() and IsValid(ply) and ply:IsPlayer() and ply:Alive() and !ply:IsFrozen() and ply != self and ply:GetViewEntity() == ply then
			self:SetViewEntity(ply)
			self:SendScreenHint(2)
		else
			self:SetViewEntity()		
		end
	end
	
	function meta:SpecToggle()
		if self:Team() == TEAM_UNASSIGNED or !GAMEMODE:IsCoop() then return end
		if self.TeamChangeTime and self.TeamChangeTime > CurTime() then
			self:PrintMessage(HUD_PRINTTALK, "You can switch teams again in "..math.ceil(self.TeamChangeTime - CurTime()).."s")
			return
		end
		if self:Team() == TEAM_SPECTATOR then
			self.TeamChangeTime = CurTime() + 3
			if GAMEMODE:GetSurvivalMode() and team.NumPlayers(TEAM_COOP) == 0 then
				GAMEMODE:GameRestart()
			end
			self:SetTeam(TEAM_COOP)
			if GAMEMODE:GetSurvivalMode() or !self:CanJoinGame() then return end
			self:UnSpectate()
			if self.SpawnedAsSpectator then
				self.SpawnedAsSpectator = nil
				GAMEMODE:PlayerInitialSpawn(self)
			else
				hook.Call("PlayerLoadout", GAMEMODE, self, true)
			end
			self:Spawn()
			if self.LastHealth and self.LastArmor then
				self:SetHealth(self.LastHealth)
				self:SetArmor(self.LastArmor)
			end
		else
			self.TeamChangeTime = CurTime() + 3
			if self:Alive() and self:Health() > 0 then
				self.LastHealth = self:Health()
				self.LastArmor = self:Armor()
			else
				self.LastHealth = nil
				self.LastArmor = nil
			end
			GAMEMODE:PlayerSpawnAsSpectator(self)
		end
	end

	function meta:SendScreenMessageScore(int, msg)
		net.Start("ScreenMessageScore")
		net.WriteInt(int, 32)
		msg = msg or ""
		net.WriteString(msg)
		net.Send(self)
	end
	
	function meta:TextMessageCenter(msg, lifetime)
		net.Start("TextMessageCenter")
		net.WriteString(msg)
		net.WriteFloat(lifetime)
		net.Send(self)
	end
	
	function meta:SendScreenHint(t, lifetime)
		lifetime = lifetime or 8
		net.Start("ShowScreenHint")
		net.WriteUInt(t, 5)
		net.WriteFloat(lifetime)
		net.Send(self)
	end
	
	function meta:SendScreenHintTop(text, lifetime)
		if !istable(text) then
			text = {text}
		end
		lifetime = lifetime or 8
		net.Start("ShowScreenHintTop")
		net.WriteTable(text)
		net.WriteFloat(lifetime)
		net.Send(self)
	end

	function meta:ChatMessage(msg, t)
		if !istable(msg) then
			msg = {msg}
		end
		t = t or 1
		net.Start("ChatMessage")
		net.WriteTable(msg)
		net.WriteUInt(t, 4)
		net.Send(self)
	end
	
	function meta:SendMessage(msg, msgtype, pos, staydelay, hcol, col)
		msgtype = msgtype or 0
		pos = pos or 0
		hcol = hcol or Color(240,110,0)
		col = col or Color(100, 100, 100)
		net.Start("HL1DrawMessage")
		net.WriteString(msg)
		net.WriteUInt(msgtype, 4)
		net.WriteUInt(pos, 4)
		net.WriteFloat(staydelay)
		net.WriteColor(hcol)
		net.WriteColor(col)
		net.Send(self)
	end
	
	local teleSound = Sound("debris/beamstart8.wav")

	function meta:TeleportToCheckpoint(dest, ang, weptable)
		if IsEntity(dest) then
			dest = dest:GetPos() + Vector(0,0,24)
		end
		self:SetPos(dest + Vector(0, 0, 8))
		if ang then
			self:SetEyeAngles(ang)
		end
		self:SetLocalVelocity(Vector(0,0,0))
		self:ScreenFade(SCREENFADE.IN, Color(0, 180, 0, 120), 1, 0)
		self:EmitSound(teleSound, 70, 100, .5)
		if weptable then
			if istable(weptable) then
				for k, v in pairs(weptable) do
					self:Give(v)
				end
			else
				if weptable == "item_suit" and self:IsSuitEquipped() then return end
				self:Give(weptable)
			end
		end
		if self:IsStuck() then
			self:Unstuck()
		end
		self.KilledByFall = nil
		hook.Run("OnPlayerTeleportToCheckpoint", self, dest)
	end
	
	function meta:CreateRagdollServerside()
		self:SetShouldServerRagdoll(true)
	end
	
	function meta:ClearRagdollServerside()
		if self.GetRagdollEntityServerside then
			local ragdoll = self:GetRagdollEntityServerside()
			if IsValid(ragdoll) then
				ragdoll:Remove()
			end
		end
	end
	
	function meta:SelectBestWeapon()
		local weps = self:GetWeapons()
		if weps then
			local bestweight = -10
			local selectedwep
			for k, v in pairs(weps) do
				if IsValid(v) and v:GetWeight() > bestweight and (v:Clip1() == -1 and v.Ammo1 and v:Ammo1() > 0 or v:Clip1() > 0) then
					bestweight = v:GetWeight()
					selectedwep = v
				end
			end
			if IsValid(selectedwep) then
				self:SelectWeapon(selectedwep:GetClass())
			end
		end
	end
	
	function meta:FixInvisibleViewModel()
		local actwep = self:GetActiveWeapon()
		if IsValid(actwep) then
			local vm = self:GetViewModel()
			local wepmodel = actwep:GetWeaponViewModel()
			if IsValid(vm) then
				if vm:GetModel() != wepmodel then
					vm:SetWeaponModel(wepmodel)
					actwep:SendWeaponAnim(ACT_VM_DRAW)
				end
			end
		end
	end
	
	function meta:GivePickupEditor(class, isitem)
		self:Give("hl1_pickupeditor")
		local wep = self:GetWeapon("hl1_pickupeditor")
		if IsValid(wep) then
			wep.PickupClass = class
			if isitem then
				wep.IsItem = true
			end
			self:SelectWeapon(wep:GetClass())
		end
	end

end