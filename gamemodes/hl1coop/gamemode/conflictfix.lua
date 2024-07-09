local function RemoveShittyHooks()

	hook.Remove("EntityEmitSound", "HLSNPCs_ReplaceSounds") -- breaks startup screen
	hook.Remove("OnEntityCreated", "HLSNPCs_MinigunFix") -- same
	hook.Remove("KeyPress", "HLSNPCs_PlayerFollow") -- breaks c_ models
	hook.Remove("Initialize", "lf_playermodel_force_hook2")	
	hook.Remove("Move", "CW_Move") -- breaks movement	
	hook.Remove("Move", "pac_custom_movement") -- breaks startup screen camera
	hook.Remove("KeyPress", "MeathookRelease") -- returns false and breaks things
	hook.Remove("PlayerSpawn", "RM_OnSpawn")
	hook.Remove("PlayerDeath", "RM_PlayerDeath")
	hook.Remove("PlayerDeath", "RM_PlayerDies")
	hook.Remove("PostPlayerDeath", "RemoveRagdoll")
	hook.Remove("PlayerLeaveVehicle", "RM_VehicleDrop")
	hook.Remove("PlayerNoClip", "SetNoclipState")
	hook.Remove("Think", "RM_SecondThink")
	hook.Remove("PlayerDisconnected", "RM_Disconnect")
	hook.Remove("CanPlayerEnterVehicle", "RM_DontEnterVehicleWhileRagdoll")
	hook.Remove("EntityTakeDamage", "RM_RagEffects")
	hook.Remove("EntityTakeDamage", "RM_RagOnFall")
	hook.Remove("PlayerTick", "shrinkinator_PlayerUpdateSize") -- breaks movement values
	hook.Remove("EntityEmitSound", "ImprovedNPCSounds_FixSounds") -- we don't need these 'fixes'
	hook.Remove("Think", "ImprovedNPCSounds_OnGargSpotEnemy") -- poor code that breaks scripts and stuff
	hook.Remove("OnEntityCreated", "HL1Gibs") -- we don't need these 'fixes'
	hook.Remove("OnEntityCreated", "HL1Thonk") -- it's badly coded and causes unexpected issues
	hook.Remove("PreCleanupMap", "HL1SentryFix")
	hook.Remove("PostCleanupMap", "HL1SentryFix")
	hook.Remove("PlayerInitialSpawn", "HL1SentryFix")
	hook.Remove("EntityTakeDamage", "HL1SentryBuff")
	hook.Remove("DoPlayerDeath", "SpawnHLGibs") -- we have our own gibs
	hook.Remove("EntityTakeDamage", "SpawnHLNPCGibs")
	if CLIENT then
		hook.Remove("CalcView", "QuakeBobbing") -- duplicate of current CalcView
		hook.Remove("CalcViewModelView", "QuakeGunBobbing") -- same but CalcViewModelView
		hook.Remove("CalcView", "MyCalcView")
		hook.Remove("Think", "rgmToggleThink") -- spams error
		hook.Remove("Think", "GlowToolRender") -- breaks startup screen
		hook.Remove("InitPostEntity", "PGL_lootSystem")
		hook.Remove("HUDPaint", "HP_lootSystem") -- breaks startup screen
		hook.Remove("HUDPaint", "DropWeapon_BindNag")
	else
		hook.Remove("Think", "Splode") -- breaks explosions
		hook.Remove("Think", "CheckForENVExplosion") -- same
		hook.Remove("Think", "SPSThink")
		hook.Remove("EntityTakeDamage", "SPSOnDamage")
		hook.Remove("GetFallDamage", "SPSFallDamage")
		hook.Remove("PlayerInitialSpawn", "SPSUpdateOnSpawnInitial")
		hook.Remove("PlayerSpawn", "SPSUpdateOnSpawn")
		hook.Remove("PlayerSpawn", "walkspawnspeed")
		hook.Remove("PlayerSpawn", "PlayerSpawn")
		hook.Remove("KeyPress", "KeyPress")
		hook.Remove("DoPlayerDeath", "DropWeapon_DoPlayerDeath")
		hook.Remove("PlayerInitialSpawn", "VJBaseSpawn") -- we dont need this because this is not sandbox
		hook.Remove("PlayerInitialSpawn", "drvrejplayerInitialSpawn") -- omg why
		hook.Remove("PlayerSpawn", "VManip_PickupSpawnVar")
		hook.Remove("PlayerCanPickupItem", "VManip_PickupPCPI")
		hook.Remove("PlayerCanPickupWeapon", "VManip_PickupPCPW")
		hook.Remove("AllowPlayerPickup", "VManip_PickupFix")
		hook.Remove("PlayerInitialSpawn", "BTDPFirstTime")
		hook.Remove("PlayerSpawn", "BTDPSpawn")
		hook.Remove("PlayerDeath", "BTDPDeath")
		hook.Remove("PlayerInitialSpawn", "GWSInitBind")
		hook.Remove("PlayerSpawn", "GWSInitInv")
		hook.Remove("PlayerDeath", "DeathInv")
		hook.Remove("ShowSpare1", "GWSShowInventory")
		hook.Remove("PlayerButtonDown", "GWSInvBind")
		hook.Remove("PlayerCanPickupWeapon", "GWSLimitWeapons")
		hook.Remove("EntityRemoved", "hl1_LongJump")
		hook.Remove("PostPlayerDeath", "hl1_LongJump")
		hook.Remove("KeyPress", "hl1_LongJump")
		hook.Remove("InitPostEntity", "sm") -- my goodness...
		hook.Remove("PostCleanupMap", "sm")
	end
	
end

RemoveShittyHooks()
timer.Simple(1, function()
	RemoveShittyHooks()
end)

if CLIENT then return end

local shit = {
	["167545348"] = true,
}
local nextcheck = RealTime()
function GM:CheckForShittyAddons()
	if nextcheck and nextcheck <= RealTime() then
		for k, v in pairs(engine.GetAddons()) do
			if shit[v.wsid] and v.mounted then
				PrintMessage(HUD_PRINTTALK, "Warning! Game-breaking addon detected: "..v.title.." ("..v.wsid..")")
			end
		end
		nextcheck = RealTime() + 2
	end
end