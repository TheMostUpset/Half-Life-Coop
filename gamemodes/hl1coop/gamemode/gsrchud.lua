--[[
  Stuff for DyaMetR's GoldSrc HUD 
  You can get it here:
  https://steamcommunity.com/sharedfiles/filedetails/?id=1290525688
]]

local cvar_huddisable = CreateClientConVar("hl1_coop_cl_disablehud", 0, true, false, "Disable HL1 HUD")

if GSRCHUD then
	local HOOK_NAME = 'hl1coop'
	
	--[[ Show itself if we're playing (or spectating) ]]--
	GSRCHUD.hook.add('IsEnabled', HOOK_NAME, function()
		local ply = LocalPlayer()
		if !IsValid(ply) then return end
		return !cvar_huddisable:GetBool() and ply:Team() != TEAM_UNASSIGNED and (ply:GetObserverMode() == OBS_MODE_NONE or IsValid(ply:GetObserverTarget()))
	end)
	
	--[[ Always require suit to draw ]]--
	GSRCHUD.hook.add('RequireSuit', HOOK_NAME, function() return true end)
	
	--[[ Only show death screen when not spectating (and while in first person) ]]--
	GSRCHUD.hook.add('ShouldUseDeathCam', HOOK_NAME, function()
		local ply = LocalPlayer()
		if !IsValid(ply) then return end
		return GSRCHUD.config.getDeathCam() and ply:Team() != TEAM_SPECTATOR and ply:GetObserverMode() == OBS_MODE_NONE and !IsValid(ply:GetObserverTarget()) and !ply:IsChasing() and !cvar_thirdperson:GetBool()
	end)
	
	hook.Add('GSRCHUDFlashlight', HOOK_NAME, function()
		if cvar_gmodsuit:GetBool() or AUXPOW and AUXPOW:IsEnabled() then return end
		local ply = GSRCHUD.localPlayer()
		return ply:GetFlashlightPower() * .01, ply:FlashlightIsOn(), false
	end)

	--[[ Set weapon icons ]]--
	GSRCHUD.weapon.inheritSprite('weapon_crowbar', 'weapon_crowbar_hl1')
	GSRCHUD.weapon.inheritSprite('weapon_glock', 'weapon_glock_hl1')
	GSRCHUD.weapon.inheritSprite('weapon_357', 'weapon_357_hl1')
	GSRCHUD.weapon.inheritSprite('weapon_mp5', 'weapon_mp5_hl1')
	GSRCHUD.weapon.inheritSprite('weapon_shotgun', 'weapon_shotgun_hl1')
	GSRCHUD.weapon.inheritSprite('weapon_crossbow', 'weapon_crossbow_hl1')
	GSRCHUD.weapon.inheritSprite('weapon_rpg', 'weapon_rpg_hl1')
	GSRCHUD.weapon.inheritSprite('weapon_healthkit', 'weapon_medkit')
	
	--[[ Textures for icons ]]--
	local HUD1, HUD2, HUD3 = '640hl1coop1', '640hl1coop2', '640hl1coop3'

	GSRCHUD.sprite.addTexture(HUD1, surface.GetTextureID('gsrchud/_hl1coop/640hud1'), 256, 256)
	GSRCHUD.sprite.addTexture(HUD2, surface.GetTextureID('gsrchud/_hl1coop/640hud2'), 256, 256)
	GSRCHUD.sprite.addTexture(HUD3, surface.GetTextureID('gsrchud/_hl1coop/640hud3'), 256, 256)
	GSRCHUD.sprite.addTexture(HUD1, surface.GetTextureID('gsrchud/_hl1coop/640hudof1'), 256, 256, GSRCHUD.THEME_OPPOSINGFORCE)
	GSRCHUD.sprite.addTexture(HUD2, surface.GetTextureID('gsrchud/_hl1coop/640hudof2'), 256, 256, GSRCHUD.THEME_OPPOSINGFORCE)
	GSRCHUD.sprite.addTexture(HUD3, surface.GetTextureID('gsrchud/_hl1coop/640hudof3'), 256, 256, GSRCHUD.THEME_OPPOSINGFORCE)

	--[[ Medkit ammunition ]]--
	GSRCHUD.ammunition.addSprite('medkit', HUD1, 182, 65, 16, 16)
	
	--[[ Do not skip throwables ]]--
	GSRCHUD.hook.add('ShouldSkipEmptyWeapons', HOOK_NAME, function(weapon)
		return !weapon.IsThrowable
	end)
	
	--[[ Do not play pickup sound ]]--
	GSRCHUD.hook.add('PickupSound', HOOK_NAME, function() return false end)
	
	--[[ Do not show loading screen if we're in MP or speedrun mode ]]--
	GSRCHUD.hook.add('ShowLoadingScreen', HOOK_NAME, function()
		return GSRCHUD.config.getLoading() and game.SinglePlayer() and !GAMEMODE:GetSpeedrunMode()
	end)
	
	-- disabling other known HUDs unless we have disabled GSRCHUD
	if UT99HUD then
		local oldFunc = UT99HUD.IsEnabled
		function UT99HUD:IsEnabled()
			if cvar_huddisable:GetBool() then
				return oldFunc()
			else
				return false
			end
		end
	end
	if SeriousHUD then
		local oldFunc = SeriousHUD.Enabled
		function SeriousHUD:Enabled()
			if cvar_huddisable:GetBool() then
				return oldFunc()
			else
				return false
			end
		end
	end
	if Q2HUD then
		local oldFunc = Q2HUD.Config.IsEnabled
		function Q2HUD.Config:IsEnabled()
			if cvar_huddisable:GetBool() then
				return oldFunc(self)
			else
				return false
			end
		end
		local oldFunc = Q2HUD.Config.DeathScreenEnabled
		function Q2HUD.Config:DeathScreenEnabled()
			if IsValid(LocalPlayer()) and !LocalPlayer():IsSpectator() then
				return oldFunc(self)
			else
				return false
			end
		end
	end
end

if HL1AHUD then
	local PREFIX = 'hl1ahud_'
	function HL1AHUD.IsEnabled()
		if GSRCHUD and GSRCHUD.isEnabled() then
			return false
		else
			return GetConVar(PREFIX .. 'enabled'):GetBool()
		end
	end
	function HL1AHUD.ShouldUseDeathCam()
		local ply = LocalPlayer()
		return GetConVar(PREFIX..'death'):GetBool() and ply:Team() != TEAM_SPECTATOR and ply:GetObserverMode() == OBS_MODE_NONE and !IsValid(ply:GetObserverTarget()) and !ply:IsChasing() and !cvar_thirdperson:GetBool()
	end
	if GSRCHUD then
		-- adding some sprites from gsrchud if both installed
		local hud2 = HL1AHUD.GenerateFileData(surface.GetTextureID('gsrchud/default/640hud2'), 256, 256)
		local hud5 = HL1AHUD.GenerateFileData(surface.GetTextureID('gsrchud/default/640hud5'), 256, 256)
		HL1AHUD.AddSprite('rocketlauncher_release', hud2, 0, 45, 170, 45)
		HL1AHUD.AddSprite('rocketlauncher_release_selected', hud5, 0, 45, 170, 45)
		HL1AHUD.AddWeaponSprite('weapon_rpg', 'rocketlauncher_release', 'rocketlauncher_release_selected')
		local tfchud6 = HL1AHUD.GenerateFileData(surface.GetTextureID('gsrchud/default/tfchud6'), 256, 256)
		local tfchud5 = HL1AHUD.GenerateFileData(surface.GetTextureID('gsrchud/default/tfchud5'), 256, 256)
		HL1AHUD.AddSprite('medkit', tfchud6, 0, 90, 170, 45)
		HL1AHUD.AddSprite('medkit_selected', tfchud5, 0, 180, 170, 45)
		HL1AHUD.AddWeaponSprite('weapon_healthkit', 'medkit', 'medkit_selected')
	end
	HL1AHUD.AddWeaponSprite('weapon_357', 'magnum', 'magnum_selected')
	HL1AHUD.AddWeaponSprite('weapon_glock', 'pistol', 'pistol_selected')
	HL1AHUD.AddWeaponSprite('weapon_crossbow', 'crossbow', 'crossbow_selected')
	HL1AHUD.AddWeaponSprite('weapon_crowbar', 'crowbar', 'crowbar_selected')
	HL1AHUD.AddWeaponSprite('weapon_mp5', '9mmar', '9mmar_selected')
	HL1AHUD.AddWeaponSprite('weapon_shotgun', 'shotgun', 'shotgun_selected')
end