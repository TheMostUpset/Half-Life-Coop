AddCSLuaFile()

ENT.Type = "anim"
ENT.Author = "Upset"
ENT.Spawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Fadeless")
	self:NetworkVar("Bool", 1, "CvarIndependent")
	self:NetworkVar("Int", 0, "Distance")
	self:NetworkVar("Float", 0, "Scale")
	self:NetworkVar("String", 0, "Text")
end

if CLIENT then
	ENT.alpha = 0
	function ENT:DoDrawHint()
		surface.SetFont("MenuFont")
		local text = ConvertToLang(self:GetText())
		local textWidth, textHeight = surface.GetTextSize(text)
		local rectWidth = textWidth + 32
		local dist = self:GetPos():DistToSqr(LocalPlayer():GetPos())
		if dist <= self:GetDistance() and (self.time and self.time > RealTime() or !self.time) then
			self.alpha = math.min(self.alpha + 5, 230)
			if !self:GetFadeless() and !self.time then
				self.time = RealTime() + 10
			end
		end
		if self.alpha > 0 then
			surface.SetDrawColor(0, 0, 0, self.alpha)
			surface.DrawRect(0 - rectWidth / 2, 0 - textHeight / 2, rectWidth, textHeight)
			draw.OutlinedBox(0 - rectWidth / 2, 0 - textHeight / 2, rectWidth, textHeight, 3, Color(255, 150, 0, self.alpha))
			draw.DrawText(text, "MenuFont", 0, 0 - textHeight / 2, Color(255, 255, 150, self.alpha), TEXT_ALIGN_CENTER)
		end
	end
	
	function ENT:Think()
		if self.alpha <= 0 then return end
		local dist = self:GetPos():DistToSqr(LocalPlayer():GetPos())
		if dist > self:GetDistance() or self.time and self.time < RealTime() then
			self.alpha = math.max(self.alpha - 2, 0)
		end
	end

	local cvar_showhints = GetConVar("hl1_coop_cl_showhints")
	function ENT:Draw()
		if !self:GetCvarIndependent() and cvar_showhints and !cvar_showhints:GetBool() then return end
		local ang = LocalPlayer():EyeAngles()
		cam.Start3D2D(self:GetPos(), self:GetAngles(), self:GetScale())
			cam.IgnoreZ(true)
			self:DoDrawHint()
			cam.IgnoreZ(false)
		cam.End3D2D()
	end
else
	function ENT:Initialize()
		self:SetSolid(SOLID_NONE)
		self:DrawShadow(false)
		self:SetScale(.3)
		self:SetDistance(40000)
	end
end