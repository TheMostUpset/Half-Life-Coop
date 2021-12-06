AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	self:SetSolid(SOLID_BBOX)
	self:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	
	self:SetCustomCollisionCheck(true)
	self:CollisionRulesChanged()
	
	self.Enabled = true
	self.PhysgunDisabled = true
end

function ENT:ShouldCollide(ent)
	if self.Enabled and IsValid(ent) and ent:IsPlayer() then
		return false
	end

    return true
end

function ENT:Toggle()
	if self.Enabled then
		self.Enabled = false
		self:SetSolid(SOLID_NONE)
	else
		self.Enabled = true
		self:SetSolid(SOLID_BBOX)
	end
end