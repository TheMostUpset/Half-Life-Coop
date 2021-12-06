ENT.Type = "anim"
ENT.Author = "Upset"
ENT.Spawnable = false

if CLIENT then
	function ENT:Initialize()
		self:SetRenderBoundsWS(self:GetCollisionBounds())
	end
	function ENT:Draw()
		if GetConVarNumber("sv_cheats") != 1 or !cvar_showclips:GetBool() then return end
		local pos, ang = self:GetPos(), self:GetAngles()
		local mins, maxs = self:GetCollisionBounds()
		render.SetColorMaterial()
		render.DrawBox(pos, ang, mins, maxs, Color(80,170,170,200))
		render.DrawWireframeBox(pos, ang, mins, maxs, Color(180,250,250,200))
	end
end