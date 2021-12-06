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
		local col = Color(80,20,180,200)
		if self:GetSolid() == SOLID_NONE then
			col = Color(80,20,180,40)
		end
		render.DrawBox(pos, ang, mins, maxs, col)
		render.DrawWireframeBox(pos, ang, mins, maxs, Color(180,100,250,200))
	end
end