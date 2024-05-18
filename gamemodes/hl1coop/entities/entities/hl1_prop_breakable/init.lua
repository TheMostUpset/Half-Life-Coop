AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.pSoundsWood = {
	"debris/wood1.wav",
	"debris/wood2.wav",
	"debris/wood3.wav",
}
ENT.pSoundsWoodBreak = {
	"debris/bustcrate1.wav",
	"debris/bustcrate2.wav",
}

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_FLYGRAVITY)
	self:SetSolid(SOLID_VPHYSICS)
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Sleep()
		phys:EnableMotion(false)
	end
	
	local MatType = self:GetMaterialType()
	if MatType == MAT_WOOD then
		self.HitSndTable = self.pSoundsWood
		self.BreakSndTable = self.pSoundsWoodBreak
		self.GibType = 2
		self.GibAmount = 16
	elseif MatType == 68 then
		self.BreakSndTable = self.pSoundsWoodBreak
		self.GibType = 2
		self.GibAmount = 2
	end
	
	if self.HitSndTable then
		for k, v in pairs(self.HitSndTable) do
			util.PrecacheSound(v)
		end
	end
	if self.BreakSndTable then
		for k, v in pairs(self.BreakSndTable) do
			util.PrecacheSound(v)
		end
	end
end

function ENT:DamageSound()
	local pitch

	if math.random(0,2) > 0 then
		pitch = 100
	else
		pitch = 95 + math.random(0, 34)
	end
	
	local fvol = math.Rand(0.75, 1)
	
	if self.HitSndTable then
		self:EmitSound(self.HitSndTable[math.random(1,#self.HitSndTable)], 80, pitch, fvol, CHAN_VOICE)
	end
end

function ENT:OnTakeDamage(dmginfo)
	if self.entKilled then return end
	local pevInflictor, pevAttacker, flDamage, bitsDamageType = dmginfo:GetInflictor(), dmginfo:GetAttacker(), dmginfo:GetDamage(), dmginfo:GetDamageType()

	self:SetHealth(self:Health() - flDamage)
	if self:Health() <= 0 then
		self.entKilled = true
		
		--[[local mins, maxs = self:OBBMins(), self:OBBMaxs()
		mins = mins * .95
		maxs = maxs * .95
		maxs[3] = 1
		local tr = util.TraceHull({
			start = self:GetPos(),
			endpos = self:GetPos() + Vector(0, 0, self:OBBMaxs()[3] + 1),
			filter = self,
			mins = mins,
			maxs = maxs
		})
		if IsValid(tr.Entity) and tr.Entity:GetClass() == self:GetClass() then
			tr.Entity:SetMoveType(MOVETYPE_FLYGRAVITY)
		end]]
		
		self:Killed(dmginfo:GetDamageForce(), self.GibAmount)
		self:Die()
		self:Remove()
		return
	end
	
	self:DamageSound()
end

function ENT:Die()
	local pitch = 95 + math.random(0,29)
	if pitch > 97 && pitch < 103 then
		pitch = 100
	end
	
	// The more negative pev->health, the louder
	// the sound should be.

	local fvol = math.Rand(0.85, 1.0) + (math.abs(self:Health()) / 100.0)
	if fvol > 1.0 then
		fvol = 1.0
	end
	
	if self.BreakSndTable then
		self:EmitSound(self.BreakSndTable[math.random(1,2)], 80, pitch, fvol, CHAN_VOICE)
	end
	
	if self.spawnobject then
		local dropEnt = ents.Create(self.spawnobject)
		if IsValid(dropEnt) then
			dropEnt:SetPos(self:GetPos())
			dropEnt:Spawn()
		end
	end
end

function ENT:Killed(force, amount)
	if !self.GibType then return end
	local effectdata = EffectData()
	effectdata:SetFlags(self.GibType)
	effectdata:SetOrigin(self:GetPos())
	effectdata:SetNormal(force)
	effectdata:SetScale(amount)
	util.Effect("hl1_gib_emitter", effectdata, true)
end