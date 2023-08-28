local cvar_bobstyle = CreateClientConVar("hl1_coop_cl_bobstyle", 1)
local cvar_bobcustom = CreateClientConVar("hl1_coop_cl_bobcustom", 1)

local cvar_bob = CreateClientConVar("hl1_cl_bob", 0.01)
local cvar_bobcycle = CreateClientConVar("hl1_cl_bobcycle", 0.8)
local cvar_bobup = CreateClientConVar("hl1_cl_bobup", 0.5)
local cvar_rollangle = CreateClientConVar("hl1_cl_rollangle", 2)
local cvar_rollspeed = CreateClientConVar("hl1_cl_rollspeed", 200)
local cvar_viewbob = CreateClientConVar("hl1_cl_viewbob", 1)

local VIEWBOB_NONE = 0
local VIEWBOB_HL1 = 1
local VIEWBOB_WON = 2
local VIEWBOB_REALISTIC = 3
local VIEWBOB_HLS = 4
local VIEWBOB_Q3 = 5
local VIEWBOB_UT99 = 6

function GM:CalcBob(ply)
	if !IsValid(ply) then return 0 end
	local cl_bob = cvar_bob:GetFloat()
	local cl_bobcycle = math.max(cvar_bobcycle:GetFloat(), 0.1)
	local cl_bobup = cvar_bobup:GetFloat()
	
	if ply:ShouldDrawLocalPlayer() or ply:GetMoveType() == MOVETYPE_NOCLIP then return 0 end

	local cltime = CurTime()
	local cycle = cltime - math.floor(cltime/cl_bobcycle)*cl_bobcycle
	cycle = cycle / cl_bobcycle
	if (cycle < cl_bobup) then
		cycle = math.pi * cycle / cl_bobup
	else
		cycle = math.pi + math.pi*(cycle-cl_bobup)/(1.0 - cl_bobup)
	end

	local velocity = ply:GetVelocity()

	local bob = math.sqrt(velocity[1]*velocity[1] + velocity[2]*velocity[2]) * cl_bob
	bob = bob*0.3 + bob*0.7*math.sin(cycle)
	if (bob > 4) then
		bob = 4
	elseif (bob < -7) then
		bob = -7
	end
	
	return bob
end

local WON_bob = 0
local WON_lasttime = CurTime()
local WON_bobtime = 0

function GM:CalcBobWON(ply)
	if !IsValid(ply) then return 0 end
	local cl_bob = cvar_bob:GetFloat()
	local cl_bobcycle = math.max(cvar_bobcycle:GetFloat(), 0.1)
	local cl_bobup = cvar_bobup:GetFloat()

	if (!ply:OnGround() || CurTime() == WON_lasttime) then
		return WON_bob
	end

	WON_lasttime = CurTime()

	local FT = FrameTime()
	WON_bobtime = WON_bobtime + FT

	local cycle = WON_bobtime - math.floor(WON_bobtime / cl_bobcycle) * cl_bobcycle
	cycle = cycle / cl_bobcycle
	
	if (cycle < cl_bobup) then
		cycle = math.pi * cycle / cl_bobup
	else
		cycle = math.pi + math.pi*(cycle-cl_bobup)/(1.0 - cl_bobup)
	end

	local vel = ply:GetVelocity()
	WON_bob = math.sqrt(vel[1]*vel[1] + vel[2]*vel[2]) * cl_bob
	WON_bob = WON_bob*0.3 + WON_bob*0.7*math.sin(cycle)
	WON_bob = math.Clamp(WON_bob, -7, 4)

	return WON_bob
end

function GM:CalcRoll(ply)
	if ply:GetMoveType() == MOVETYPE_NOCLIP then return 0 end

	local sign
	
	local cl_rollangle = cvar_rollangle:GetFloat()
	local cl_rollspeed = cvar_rollspeed:GetFloat()
	
	local side = ply:GetVelocity():Dot(ply:EyeAngles():Right())
	if side < 0 then
		sign = -1
	else
		sign = 1
	end
	side = math.abs(side)
	
	local value = cl_rollangle
	
	if (side < cl_rollspeed) then
		side = side * value / cl_rollspeed
	else
		side = value
	end
	
	return side * sign
end

function GM:CalcCameraShake(pos, ang, fov)
	local ispeed = CurTime() * 1
	local iscale = 1
	local iyaw_cycle = 2
	local iroll_cycle = 0.5
	local ipitch_cycle = 1
	local iyaw_level = 0.3
	local iroll_level = 0.1
	local ipitch_level = 0.3
	ang[1] = ang[1] + iscale * math.sin(ispeed * ipitch_cycle) * ipitch_level
	ang[2] = ang[2] + iscale * math.sin(ispeed * iyaw_cycle) * iyaw_level
	ang[3] = ang[3] + iscale * math.sin(ispeed * iroll_cycle) * iroll_level
	
	local view = {}
	view.origin = pos
	view.angles = ang
	view.fov = fov
	view.drawviewer = false
	
	return view
end

local ModelSelect
local ModelSelectPos = Vector()
local ModelSelectAng = Angle()
local mouseX, mouseY = 0, 0
local canDragCamera

function GM:CalcModelSelectView(ply, pos, ang, fov)
	local FT = RealFrameTime()
	if ply.PreviewModel then
		ply:SetModel(ply.PreviewModel)
	end
	local camAng = Angle(0, ang[2] + 140, 0)
	if !input.IsMouseDown(MOUSE_LEFT) then
		local pnl = vgui.GetHoveredPanel()
		if IsValid(pnl) and pnl:GetClassName() == "CGModBase" then
			mouseX, mouseY = input.GetCursorPos()
			canDragCamera = true
		else
			canDragCamera = false
		end
	elseif canDragCamera then
		FT = FT * 7
		local m_x, m_y = input.GetCursorPos()
		m_x, m_y = (m_x - mouseX) / 8, (m_y - mouseY) / 14
		camAng[1] = m_y
		camAng[2] = camAng[2] - m_x
	end
	if ModelSelectAng:IsZero() then
		ModelSelectAng = ang
	end
	ModelSelectAng = LerpAngle(FT * 2, ModelSelectAng, camAng)
	ang = ModelSelectAng
	local screenAR = ScrW() / ScrH()
	local tr = util.TraceHull({
		start = pos,
		endpos = pos - ang:Forward() * 2800/fov * screenAR - ang:Up() * 25 + ang:Right() * 20 * screenAR,
		filter = ply,
		mins = Vector(-5, -5, -5),
		maxs = Vector(5, 5, 5),
		mask = MASK_SOLID_BRUSHONLY
	})
	if tr.Fraction < .9 then
		local fixang = ang - tr.HitPos:Angle()
		fixang[1], fixang[3] = 0, 0
		ply:SetEyeAngles(fixang)
	end
	if ModelSelectPos:IsZero() then
		ModelSelectPos = tr.StartPos
	end
	local gEnt = ply:GetGroundEntity()
	if ply:GetVelocity():Length() >= 50 or IsValid(gEnt) and gEnt:IsMovingEntity() and gEnt:GetVelocity():Length() > 25 then
		ModelSelectPos = tr.HitPos
	else
		ModelSelectPos = LerpVector(FT * 2, ModelSelectPos, tr.HitPos)
	end
	
	local view = {}

	view.origin = ModelSelectPos
	view.angles = ang
	view.fov = fov
	view.drawviewer = true
	
	return view
end

function GM:IsModelSelectorEnabled(ply)
	return ModelSelect and ply:Alive()
end

function GM:CalcThirdPersonView(ply, pos, ang, fov)
	if ply:GetObserverMode() == OBS_MODE_IN_EYE then return end

	local startpos = pos
	local camPos = ang:Forward() * -80 + ang:Up() * (74 + ply:GetPos()[3] - pos[3])
	local tr = util.TraceHull({
		start = startpos,
		endpos = startpos + camPos,
		filter = ply,
		mins = Vector(-5, -5, -5),
		maxs = Vector(5, 5, 5),
		mask = MASK_PLAYERSOLID_BRUSHONLY
	})

	if tr.Fraction > .25 then
		pos = tr.HitPos
	
		local view = {}

		view.origin = pos
		view.angles = ang
		view.fov = fov
		view.drawviewer = true

		return view
	end
end

function GM:IsThirdPersonEnabled(ply)
	local thirdperson = cvar_thirdperson:GetBool()
	local wep = ply:GetActiveWeapon()
	local wepzoom = IsValid(wep) and wep.IsHL1Base and wep:GetInZoom()

	return thirdperson and !wepzoom
end

local UT99viewBobSide = 0
local UT99viewBobUp = 0
local UT99viewBobTime = 0

local gnd_t = 1

function GM:CalcView(ply, pos, ang, fov)
	if GAMEMODE:GetCoopState() == COOP_STATE_FIRSTLOAD then
		return hook.Run("CalcCameraShake", pos, ang, 75)
	end

	local punchangle = ply.punchangle
	if punchangle then
		HL1_VectorAdd(ang, punchangle, ang)
		HL1_DropPunchAngle(FrameTime(), punchangle)
	end
	
	local viewent = ply:GetViewEntity()
	if IsValid(viewent) and viewent:IsPlayer() and viewent != ply then
		local view = {}

		view.origin = viewent:EyePos()
		view.angles = viewent:EyeAngles()
		view.fov = fov
		view.drawviewer = true

		return view
	end
	
	if hook.Run("IsModelSelectorEnabled", ply) then
		return hook.Run("CalcModelSelectView", ply, pos, ang, fov)
	end
	
	if hook.Run("IsThirdPersonEnabled", ply) then
		local thirdPerson = hook.Run("CalcThirdPersonView", ply, pos, ang, fov)
		if thirdPerson != nil then return thirdPerson end
	end
	
	local specply = ply:GetObserverTarget()
	if IsValid(specply) and specply:IsPlayer() and ply:GetObserverMode() == OBS_MODE_IN_EYE then
		ply = specply
	end
	
	if cvar_bobcustom:GetBool() then
		local wep = ply:GetActiveWeapon()
		if IsValid(wep) and wep:IsScripted() and !wep.IsHL1Base then
			if wep.CalcView then
				pos, ang, fov = wep:CalcView(ply, pos, ang, fov)
				local view = {}
				view.origin = pos
				view.angles = ang
				view.fov = fov
				view.drawviewer = false
				return view
			elseif wep.GetViewModelPosition and (wep.BobScale == 0 or wep.SwayScale == 0) then
				local view = {}
				view.origin = pos
				view.angles = ang
				view.fov = fov
				view.drawviewer = false
				return view
			end
		end
	end
	
	if ply:IsValid() and ply:Alive() and !ply:InVehicle() and !ply:ShouldDrawLocalPlayer() then
		local iBobStyle = cvar_bobstyle:GetInt()
		if iBobStyle != VIEWBOB_HLS then
			if iBobStyle == VIEWBOB_REALISTIC then
				if cvar_viewbob and cvar_viewbob:GetBool() then
					local vel = ply:GetVelocity():Length2D()
			
					local cl_bobmodel_side = .05
					local cl_bobmodel_up = .03
					local cl_bobmodel_speed = 8.25

					local xyspeed = math.Clamp(vel, 0, 800)
					local s = CurTime() * cl_bobmodel_speed
					local bspeed = xyspeed * 0.01

					local bob = bspeed * cl_bobmodel_side * math.sin (s)
					ang:RotateAroundAxis(ang:Up(), -bob)
					bob = bspeed * cl_bobmodel_up * math.cos (s * 2)
					ang:RotateAroundAxis(ang:Right(), -bob)
					ang.r = ang.r - bob
					
					--[[if self.viewang then
						ang:RotateAroundAxis(ang:Up()*.1, -self.viewang[2])
						ang:RotateAroundAxis(ang:Right()*.1, self.viewang[1])
						ang:RotateAroundAxis(ang:Forward()*.1, -self.viewang[3])
					end]]--
				end
			elseif iBobStyle == VIEWBOB_Q3 then
				-- cough
			elseif iBobStyle == VIEWBOB_UT99 then
				if ply:IsOnGround() then
					gnd_t = math.Approach(gnd_t, 1, FrameTime() * 6)
				else
					gnd_t = math.Approach(gnd_t, 0, FrameTime() * 3)
				end
				
				if cvar_viewbob and cvar_viewbob:GetBool() then
					local scale = .75 * gnd_t
					
					local vel = ply:GetVelocity():Length2D()
					vel = math.Clamp(vel, 0, 320) / 200

					UT99viewBobTime = UT99viewBobTime + vel * 12 * FrameTime()
					
					UT99viewBobSide = math.cos(UT99viewBobTime * .5) * vel * scale
					UT99viewBobUp = math.sin(UT99viewBobTime) * vel * scale
					
					pos = pos - ang:Right() * UT99viewBobSide
					pos[3] = pos[3] - UT99viewBobUp
				end
			elseif iBobStyle == VIEWBOB_NONE then
				-- nothing
			else				
				local bob = hook.Run("CalcBob", ply)
				--[[if iBobStyle == VIEWBOB_WON then
					bob = hook.Run("CalcBobWON", ply)
				else
					bob = hook.Run("CalcBob", ply)
				end]]
				local roll = hook.Run("CalcRoll", ply)
				
				if cvar_viewbob and cvar_viewbob:GetBool() then
					pos[3] = pos[3] + bob
				end
				ang.r = ang.r + roll
			end
		end
	end
	
	local view = {}

	view.origin = pos
	view.angles = ang
	view.fov = fov
	view.drawviewer = false
	
	local vehicle = ply:GetVehicle()
	if IsValid(vehicle) then return hook.Run("CalcVehicleView", vehicle, ply, view) end

	return view
end

local swayangles = Angle()
local ground = 0

local BobTime = 0
local BobTimeLast = RealTime()
function GM:CalcViewModelView(wep, vm, oldPos, oldAng, pos, ang)
	if wep:IsScripted() and (wep.Base == "cw_base" or wep.Base == "cw_grenade_base") then
		return pos - ang:Forward() * 32
	end
	if cvar_bobcustom:GetBool() and wep:IsScripted() and !wep.IsHL1Base and IsValid(wep.Owner) then
		if wep.CalcViewModelView then
			return wep:CalcViewModelView(vm, oldPos, oldAng, pos, ang)
		elseif wep.GetViewModelPosition and (wep.BobScale == 0 or wep.SwayScale == 0) then
			return wep:GetViewModelPosition(pos, ang)
		end
	end

	local ply = LocalPlayer()
	local specply = ply:GetObserverTarget()
	if IsValid(specply) and specply:IsPlayer() then
		ply = specply
	end
	local iBobStyle = cvar_bobstyle:GetInt()
	if iBobStyle == VIEWBOB_HLS then
		oldPos = pos
		oldAng = ang
	elseif iBobStyle == VIEWBOB_REALISTIC then
		local sign
	
		local cl_rollangle = 2
		local cl_rollspeed = 200
		
		local side = ply:GetVelocity():Dot(ply:EyeAngles():Right())
		if side < 0 then
			sign = -1
		else
			sign = 1
		end	
		side = math.abs(side)
		
		if (side < cl_rollspeed) then
			side = side * cl_rollangle / cl_rollspeed
		else
			side = cl_rollangle
		end

		local vel = ply:GetVelocity():Length2D()
		
		local cl_bobmodel_side = .09
		local cl_bobmodel_up = -.045
		local cl_bobmodel_speed = 8.25
		local cl_viewmodel_fov = IsValid(wep) and wep.ViewModelFOV or 90
		local cl_viewmodel_scale = cl_viewmodel_fov / 90
		local swayscale = cl_viewmodel_fov / 450
		local idlescale = .5

		local xyspeed = math.Clamp(vel, 0, 400)
		local s = CurTime() * cl_bobmodel_speed
		local bspeed = xyspeed * 0.01
		local wepbob_side = bspeed * cl_bobmodel_side * cl_viewmodel_scale * math.sin (s)
		local wepbob_up = bspeed * cl_bobmodel_up * cl_viewmodel_scale * math.cos (s * 2)
		local FT = FrameTime()
		
		if !ply:OnGround() then
			ground = Lerp(FT*7, ground, .01)
			wepbob_side = wepbob_side * ground
			wepbob_up = wepbob_up * ground
		else
			ground = Lerp(FT*14, ground, 1)
			wepbob_side = wepbob_side * ground
			wepbob_up = wepbob_up * ground
		end
		
		local upAngles = oldAng[1] * .015
		if wep.ViewModelFlip then
			oldPos = oldPos + oldAng:Right() * upAngles - oldAng:Up() * upAngles - oldAng:Forward() * upAngles * .25
		else
			oldPos = oldPos - oldAng:Right() * upAngles - oldAng:Up() * upAngles - oldAng:Forward() * upAngles * .25
		end
		
		//sway
		local modelindex = vm:ViewModelIndex()
		if !game.SinglePlayer() and IsFirstTimePredicted() or game.SinglePlayer() or IsValid(specply) then
			swayangles = LerpAngle(FT*10, swayangles, oldAng)
		end	
		local sway = oldAng - swayangles	
		if wep.ViewModelFlip or modelindex == 1 and wep.ViewModelFlip1 then
			oldAng:RotateAroundAxis(oldAng:Up() * swayscale, sway[2])
			oldAng:RotateAroundAxis(oldAng:Forward() * swayscale/2, sway[2])
		else
			oldAng:RotateAroundAxis(oldAng:Up() * swayscale, -sway[2])
			oldAng:RotateAroundAxis(oldAng:Forward() * swayscale/2, -sway[2])
		end
		oldAng:RotateAroundAxis(oldAng:Right() * swayscale, sway[1])
		
		//bob
		if modelindex == 0 then
			oldPos = oldPos + wepbob_side * oldAng:Right()
		else
			oldPos = oldPos - wepbob_side * oldAng:Right()
		end
		oldAng:RotateAroundAxis(oldAng:Up(), -wepbob_side*2)
		oldPos[3] = oldPos[3] + wepbob_up
		oldAng.r = oldAng.r - wepbob_up + side * sign
		oldAng:RotateAroundAxis(oldAng:Right(), -wepbob_up*6)
		
		//idle drift
		oldAng = oldAng + Angle(math.sin(CurTime()*2)*idlescale, math.sin(CurTime())*idlescale, math.sin(CurTime()*1.5)*idlescale+.5)
		
		oldPos = oldPos - oldAng:Forward() * bspeed*.2 - oldAng:Up() * bspeed*.05
	elseif iBobStyle == VIEWBOB_Q3 then
		local vel = ply:GetVelocity()
		local xyspeed = vel:Length2D()
		local bob
	
		local cl_bobmodel_side = 1.1
		local cl_bobmodel_up = .22
		local cl_bobmodel_speed = 8.75
		
		local s = CurTime() * cl_bobmodel_speed
		if IsFirstTimePredicted() or game.SinglePlayer() then
			if ply:IsOnGround() then
				gnd_t = Lerp(FrameTime()*6, gnd_t, 1)
			else
				gnd_t = math.max(Lerp(FrameTime()*6, gnd_t, 0.01), 0)
			end
		end
		
		local vmFOV = wep.ViewModelFOV or GetConVarNumber("viewmodel_fov")
		vmFOV = vmFOV / 90
		
		local bspeed = math.Clamp(xyspeed, 0, 700) * 0.01
		bob = bspeed * cl_bobmodel_side * math.sin (s) * gnd_t * vmFOV
		oldAng.y = oldAng.y + bob
		oldAng.r = oldAng.r + bob / 3
		bob = bspeed * cl_bobmodel_up * math.cos (s * 2) * gnd_t * vmFOV
		oldAng.p = oldAng.p - bob
		
		local scale = xyspeed / 2 + 40
		local fracsin = math.sin(CurTime())
		local idle = scale * fracsin * .01 * vmFOV
		oldAng = oldAng + Angle(idle, idle, idle)
	elseif iBobStyle == VIEWBOB_UT99 then
		local vel = ply:GetVelocity():Length2D()
		
		local bob
		local RT = RealTime()
		if game.SinglePlayer() then RT = CurTime() end
		
		local cl_bobmodel_side = .15
		local cl_bobmodel_up = .055
		local cl_bobmodel_speed = 8.7
		local cl_viewmodel_scale = wep.ViewModelFOV or GetConVarNumber("viewmodel_fov")
		cl_viewmodel_scale = cl_viewmodel_scale / 90
		
		local xyspeed = math.Clamp(vel, 0, 320)
		
		BobTime = BobTime + (RT - BobTimeLast) * (xyspeed / 320)
		BobTimeLast = RT

		local s = BobTime * cl_bobmodel_speed
		
		local bspeed = xyspeed * 0.01
		bob = bspeed * cl_bobmodel_side * cl_viewmodel_scale * math.sin (10.55 + s) * gnd_t
		local modelindex = vm:ViewModelIndex()
		if modelindex == 0 then
			oldPos = oldPos + bob * oldAng:Right()
		else
			oldPos = oldPos - bob * oldAng:Right()
		end
		bob = bspeed * cl_bobmodel_up * cl_viewmodel_scale * math.cos (0.45 + s * 2) * gnd_t
		oldPos[3] = oldPos[3] - bob
		
		if cvar_viewbob and cvar_viewbob:GetBool() then
			oldPos = oldPos - oldAng:Right() * UT99viewBobSide
			oldPos[3] = oldPos[3] - UT99viewBobUp
		end
	elseif iBobStyle == VIEWBOB_NONE then
		-- nothing
	else
		local bob = hook.Run("CalcBob", ply)
		--[[if iBobStyle == VIEWBOB_WON then
			bob = WON_bob
		else
			bob = hook.Run("CalcBob", ply)
		end]]
		
		oldPos = oldPos + bob * .4 * oldAng:Forward()
		if cvar_viewbob and cvar_viewbob:GetBool() then
			oldPos[3] = oldPos[3] + bob
		end

		if iBobStyle == VIEWBOB_WON then
			if wep.ViewModelFlip then
				oldAng.y = oldAng.y + bob * 0.5
				oldAng.r = oldAng.r + bob * 1
			else
				oldAng.y = oldAng.y - bob * 0.5
				oldAng.r = oldAng.r - bob * 1
			end
			oldAng.p = oldAng.p + bob * 0.3
		end
		
		oldPos[3] = oldPos[3] - 1
	end
	
	if wep.ViewModelOffset then 
		oldPos = oldPos + oldAng:Forward() * wep.ViewModelOffset.PosForward + oldAng:Right() * wep.ViewModelOffset.PosRight + oldAng:Up() * wep.ViewModelOffset.PosUp
		oldAng:RotateAroundAxis(oldAng:Forward(), wep.ViewModelOffset.AngForward)
		oldAng:RotateAroundAxis(oldAng:Right(), wep.ViewModelOffset.AngRight)
		oldAng:RotateAroundAxis(oldAng:Up(), wep.ViewModelOffset.AngUp)
	end
	if wep.HideWhenEmpty and wep.rgAmmo and wep:rgAmmo() <= 0 then -- hide when no ammo left
		oldPos = wep:ViewModelHide(oldPos, oldAng, vm)
	end
	if wep.SetViewModelFOV then
		wep:SetViewModelFOV()
	end
	if wep.IsHL1Base then
		return wep:GetViewModelPosition(oldPos, oldAng)
	end

	return oldPos, oldAng
end

function GM:SetPlayerModelView(b)
	local ply = LocalPlayer() 
	if b then
		if !ply:Alive() then return end
		ModelSelect = true
		ModelSelectPos = Vector()
		ModelSelectAng = Angle()
	else
		ModelSelect = false
		
		local modelname = player_manager.TranslatePlayerModel(cvars.String("hl1_coop_cl_playermodel"))
		ply:SetModel(modelname)
	end
end