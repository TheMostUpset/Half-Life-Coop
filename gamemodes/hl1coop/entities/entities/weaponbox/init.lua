AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.AmmoNames = {
	["9mm"] = "9mmRound",
	["357"] = "357",
	["buckshot"] = "Buckshot",
	["bolts"] = "XBowBolt",
	["rockets"] = "RPG_Round",
	["uranium"] = "Uranium",
	["Hand Grenade"] = "Grenade",
	["Satchel Charge"] = "Satchel",
	["Trip Mine"] = "TripMine",
	["ARgrenades"] = "MP5_Grenade"
}

ENT.AmmoBlacklist = {
	["Hornet"] = true,
	["medkit"] = true
}

function ENT:KeyValue(k, v)
	if !self.Ammo then
		self.Ammo = {}
	end
	if self.Ammo then
		local ammotype = self.AmmoNames[k]
		if ammotype then
			local ammoid = game.GetAmmoID(ammotype)
			self.Ammo[ammoid] = v
		end
	end
end

function ENT:Initialize()
	if !self:IsInWorld() then
		self:Remove()
	end
	self:SetModel("models/w_weaponbox.mdl")
	self:SetMoveType(MOVETYPE_FLYGRAVITY)
	self:SetMoveCollide(MOVECOLLIDE_FLY_BOUNCE)
	self:SetSolid(SOLID_NONE)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

	self:SetTrigger(true)
	self:UseTriggerBounds(true, 16)
	
	self.Pickable = true
	
	local owner = self:GetOwner()
	if IsValid(owner) and owner:IsPlayer() then
		self:SetOwnerNick(owner:Nick())
	end
end

function ENT:SetWeaponTable(t)
	if !t then return end
	self.Weapons = t
	self.Ammo = {}
	for k, v in pairs(self.Weapons) do
		local ammotype, ammocount = v[2], v[3]
		local ammotypeS, ammocountS = v[4], v[5]
		self.Ammo[ammotype] = ammocount
		if ammotypeS > -1 then
			self.Ammo[ammotypeS] = ammocountS
		end
	end
end

function ENT:Pickup(ent)
	if !self:CreatedByMap() and (CurTime() - self:GetCreationTime()) < .5 then return end
	
	local owner = self:GetOwner()
	if IsValid(owner) and owner != ent then return end
	if self.Ammo then
		for k, v in pairs(self.Ammo) do
			if k > -1 then
				local ammoName = game.GetAmmoName(k)
				local inBlacklist = self.AmmoBlacklist[ammoName]
				if !inBlacklist then
					local maxValue = WEAPONBOX_AMMO_MAX_VALUES[ammoName]
					local maxValueMul = ent.HL1MaxAmmoMultiplier
					if maxValue and maxValueMul then
						maxValue = math.Round(maxValue * maxValueMul)
					end
					local ammoCount = ent:GetAmmoCount(k)
					local giveamount = maxValue and math.min(maxValue - ammoCount, v) or tonumber(v)
					ent:GiveAmmo(giveamount, k)
					if maxValue and ammoCount > maxValue then
						ent:SetAmmo(maxValue, k)
					end
					local throwable = WEAPONBOX_THROWABLES[ammoName]
					if throwable and giveamount > 0 then					
						ent:Give(throwable, true)
						local wep = ent:GetWeapon(throwable)
						if IsValid(wep) then
							wep:SetClip1(-1)
						end
					end
				end
			end
		end
	end
	if self.Weapons then
		for k, v in pairs(self.Weapons) do
			if v[1] == "weapon_healthkit" and !(GAMEMODE:GetSurvivalMode() or cvar_medkit:GetBool()) then continue end
			if !ent:HasWeapon(v[1]) then
				local throwable = table.HasValue(WEAPONBOX_THROWABLES, v[1])
				if throwable and v[3] > 0 or !throwable then
					local noDefaultAmmo = true
					if self.AmmoBlacklist[game.GetAmmoName(v[2])] then
						noDefaultAmmo = false
					end
					ent:Give(v[1], noDefaultAmmo)
					local wep = ent:GetWeapon(v[1])
					if IsValid(wep) and wep.Primary.ClipSize then
						if v[6] > -1 and wep.Primary.ClipSize > -1 then
							wep:SetClip1(v[6])
						else
							wep:SetClip1(-1)
						end
					end
				end
			else
				local clip = v[6]
				if clip > 0 then
					local ammoName = game.GetAmmoName(v[2])
					local maxValue = WEAPONBOX_AMMO_MAX_VALUES[ammoName]
					local maxValueMul = ent.HL1MaxAmmoMultiplier
					if maxValue and maxValueMul then
						maxValue = math.Round(maxValue * maxValueMul)
					end
					local ammoCount = ent:GetAmmoCount(v[2])
					local giveamount = maxValue and math.min(maxValue - ammoCount, clip) or tonumber(clip)
					ent:GiveAmmo(giveamount, v[2])
				end
			end
			--[[local wep = ent:GetWeapon(v[1])
			if IsValid(wep) then
				if wep.Primary.MaxAmmo and ent:GetAmmoCount(v[2]) > wep.Primary.MaxAmmo then
					ent:SetAmmo(wep.Primary.MaxAmmo, v[2])
				end
				if wep.Secondary.MaxAmmo and ent:GetAmmoCount(v[4]) > wep.Secondary.MaxAmmo then
					ent:SetAmmo(wep.Secondary.MaxAmmo, v[4])
				end
			end]]--
		end
	end
	
	ent:PlayPickupSound(85)
	self.Pickable = false
	if self:ItemShouldRespawn() then
		self:RespawnItem()
	else
		self:Remove()
	end
end