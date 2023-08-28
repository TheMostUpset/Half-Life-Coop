AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Radius = 600
ENT.UpdateTime = .5

function ENT:Initialize()
	self:SetNoDraw(true)
	self:SetSolid(SOLID_NONE)
	if !self.NPCPos then self.NPCPos = self:GetPos() end
	for k, v in ipairs(ents.FindInSphere(self.NPCPos, 100)) do
		if v:GetClass() == "monster_tentacle" then
			v:SetSaveValue("m_hDamageFilter", NULL)
			self.NPC = v
		end
	end
end

function ENT:InsertSound(pos, duration)
	if !IsValid(self.aiSoundEnt) then
		self.aiSoundEnt = ents.Create("ai_sound")
		local ent = self.aiSoundEnt
		ent:SetPos(pos)
		ent:Spawn()
		ent:SetKeyValue("soundtype", 1)
		ent:SetKeyValue("volume", 600)
		ent:SetKeyValue("duration", duration)
		ent:Activate()
		SafeRemoveEntityDelayed(ent, duration)
	end
	if IsValid(self.aiSoundEnt) then
		self.aiSoundEnt:SetPos(pos)
		self.aiSoundEnt:Fire("EmitAISound")
	end
end

function ENT:Think()
	if IsValid(self.NPC) then
		for k, v in ipairs(ents.FindInSphere(self:GetPos(), self.Radius)) do
			if v:IsPlayer() then
				local vel = v:GetVelocity()
				if v:OnGround() and vel:Length() > 200 then
					self:InsertSound(v:GetPos(), 5)
				end
			end
		end
	else
		self:Remove()
	end
	
	self:NextThink(CurTime() + self.UpdateTime)
	return true
end