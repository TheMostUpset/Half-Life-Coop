AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	--self:AddFlags(bit.band(FL_STATICPROP, FL_GRAPHED))
	self.PhysgunDisabled = true
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Sleep()
		phys:EnableMotion(false)
	end
end