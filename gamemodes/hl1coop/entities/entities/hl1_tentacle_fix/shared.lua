ENT.Type = "anim"
ENT.Author = "Upset"
ENT.Spawnable = false

if CLIENT then
	function ENT:Draw()
		render.DrawWireframeSphere( self:GetPos(), 600, 10, 10, Color( 255, 255, 255, 255 ) )
	end
end