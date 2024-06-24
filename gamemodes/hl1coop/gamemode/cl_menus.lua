net.Receive("HL1DeathMenu", function()
	GAMEMODE:OpenDeathMenu(net.ReadBool())
end)
net.Receive("HL1DeathMenuRemove", function()
	if IsValid(GAMEMODE.DeathMenu) and GAMEMODE.DeathMenu:IsVisible() then
		GAMEMODE.DeathMenu:Remove()
	end
end)

net.Receive("HL1StartMenu", function()
	GAMEMODE:OpenStartMenu()
end)

net.Receive("ShowMapRecords", function()
	GAMEMODE:OpenMapRecords(net.ReadTable())
end)

surface.CreateFont("MenuFont", {
	font = "Trebuchet MS",
	extended = true,
	size = ScrH() / 20,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont("MenuFontSmall", {
	font = "Trebuchet MS",
	extended = true,
	size = ScrH() / 26,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont("HintPanel", {
	font	= "Trebuchet MS",
	extended = true,
	size	= ScreenScaleH(10.5),
	weight	= 800,
})

surface.CreateFont("MenuHint", {
	font	= "Trebuchet MS",
	size	= ScrW() / 58,
	weight	= 800,
	shadow	= true
})

surface.CreateFont("HL1Coop_PlayerFrame", {
	font	= "Trebuchet MS",
	size	= 24,
	weight	= 800,
	shadow	= true
})

surface.CreateFont("ChangelogFont", {
	font	= "Arial",
	size	= 21
})

function GM:MainMenuOptions()
	local menu = {
		{"menu_resumegame", function() self.Menu.MainMenuFrame:DoEndAnim() end},
		{"menu_callvote", function() self:VoteMenu() end},
		{"menu_configuration", function() self.Menu.MainMenuFrame:DoHideAnim() self:OpenPlayerSettings() end},
		{"menu_playermodel", function() self.Menu.MainMenuFrame:DoEndAnim() self:ModelSelectionMenu() end, function() if !GetGlobalBool("hl1_coop_sv_custommodels", false) then return false end end},
		{"menu_langselect", function() self.Menu.MainMenuFrame:DoEndAnim() self:OpenLanguageMenu(true) end},
		{"menu_steamgroup", function() gui.OpenURL("https://steamcommunity.com/groups/hl1coop") end},
		--{"menu_workshoppage", function() gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=1590755372") end},
		{"menu_spectate", function() self.Menu.MainMenuFrame:DoEndAnim() RunConsoleCommand("hl1_coop_spectate") end, function() if GAMEMODE:GetCoopState() == COOP_STATE_FIRSTLOAD then return false end if LocalPlayer():Team() == TEAM_SPECTATOR then return "menu_joingame" end end},
		{"menu_disconnect", function() RunConsoleCommand("disconnect") end},
		{"menu_quit", function() self.Menu.MainMenuFrame:DoHideAnim() self:QuitDialog() end},
		
		{"menu_adminsettings", function() self.Menu.MainMenuFrame:DoHideAnim() self:OpenServerSettings() end, adminonly = true},
		
		{"menu_legacymenu", function() self:CloseMenus() gui.ActivateGameUI() end}
	}
	return menu
end

function GM:VoteMenuOptions()
	local votes = {
		{"votemenu_mapvote", function() self.Menu.MainMenuFrame:DoHideAnim() self:OpenMapVote() end},
		{"votemenu_kick", function() self.Menu.MainMenuFrame:DoHideAnim() self:OpenKickVote() end},
		{"votemenu_ban", function() self.Menu.MainMenuFrame:DoHideAnim() self:OpenBanVote() end},
		{"votemenu_restart", function() self.Menu.MainMenuFrame:DoEndAnim() RunConsoleCommand("hl1_coop_callvote", "restart") end},
		{"votemenu_friendlyfire", function() self.Menu.MainMenuFrame:DoEndAnim() RunConsoleCommand("hl1_coop_callvote", "friendlyfire") end},
		{"votemenu_speedrun", function() self.Menu.MainMenuFrame:DoEndAnim() RunConsoleCommand("hl1_coop_callvote", "speedrunmode") end, "Speedrun mode which features:\n- Bunnyhop script\n- Speed indicator\n- No wait triggers\n- Allowed shortcuts\n- Players can't pickup other's weaponbox\n- Unlimited func_pushable velocity\n- Map records\n\nCauses map restart after activation"},
		{"votemenu_survival", function() self.Menu.MainMenuFrame:DoEndAnim() RunConsoleCommand("hl1_coop_callvote", "survivalmode") end, "Survival mode:\n- No respawns until someone reaches checkpoint\n- Map restarts if no alive players left\n- Medkit weapon available"},
		{"1 HP mode", function() self.Menu.MainMenuFrame:DoEndAnim() RunConsoleCommand("hl1_coop_callvote", "1hpmode") end, "1 HP mode:\nTrue hardcore\n- No medkits\n- No armor\n- Drop from crates replaced for random ammo\n\nCauses map restart after deactivation"},
		{"Crack mode", function() self.Menu.MainMenuFrame:DoEndAnim() RunConsoleCommand("hl1_coop_callvote", "crackmode") end, "Crack mode:\nEverything is fucked up\n\nCauses map restart"},
		{"votemenu_skill1", function() self.Menu.MainMenuFrame:DoEndAnim() RunConsoleCommand("hl1_coop_callvote", "skill", 1) end},
		{"votemenu_skill2", function() self.Menu.MainMenuFrame:DoEndAnim() RunConsoleCommand("hl1_coop_callvote", "skill", 2) end},
		{"votemenu_skill3", function() self.Menu.MainMenuFrame:DoEndAnim() RunConsoleCommand("hl1_coop_callvote", "skill", 3) end},
		{"Skip tripmine room", function() self.Menu.MainMenuFrame:DoEndAnim() RunConsoleCommand("hl1_coop_callvote", "skiptripmines") end, available = function() return game.GetMap() == "hls11cmrl" end},
	}
	return votes
end

function GM:QuickMenuOptions()
	local ply = LocalPlayer()
	local options = {
		--{"Call medic", function() RunConsoleCommand("callmedic") end, function() return ply:Team() == TEAM_COOP and ply:GetNWFloat("CallMedicTime") <= CurTime() end},
		{"quickmenu_dropweapon", function() RunConsoleCommand("dropweapon") end, function() return IsValid(ply:GetActiveWeapon()) end},
		{"quickmenu_dropammo", function() RunConsoleCommand("dropammo") end, function() local wep = ply:GetActiveWeapon() return IsValid(wep) and wep:IsScripted() and wep.AmmoEnt and wep:Ammo1() > 0 end},
		{"quickmenu_unload", function() RunConsoleCommand("unload") end, function() local wep = ply:GetActiveWeapon() return IsValid(wep) and wep.Unload and wep.UnloadTime and wep:Clip1() > 0 end},
		{"quickmenu_tocheckpoint", function() RunConsoleCommand("lastcheckpoint") end, function() return ply:Alive() and ply:GetScore() >= cvar_price_movetocheckpoint:GetInt() and ply.CanTeleportTime and ply.CanTeleportTime > CurTime() and LAST_CHECKPOINT and LAST_CHECKPOINT:Distance(ply:GetPos()) > LAST_CHECKPOINT_MINDISTANCE and CanReachNearestTeleport() end},
		{"quickmenu_unstuck", function() RunConsoleCommand("unstuck") end, function() return ply:IsStuck() end},
	}
	return options
end

function GM:GetLanguageTable()
	-- first string in the table is a lang file postfix,
	-- e.g. lang_en.lua is just "en" here, same for others.
	-- second string is language name that appears in menu.
	-- third one is path to language icon
	local t = {
		{"en", "English", "flags16/gb.png"},
		{"ru", "Русский", "flags16/ru.png"},
		{"ua", "Українська", "flags16/ua.png"},
		{"br", "Português", "flags16/br.png"},
		{"de", "Deutsch", "flags16/de.png"},
		{"tr", "Türkçe", "flags16/tr.png"},
	}
	return t
end

function GM:HintTable()
	local t = {
		"menuhint_showdist",
		"menuhint_thirdperson",
		"menuhint_dropweapon",
		"menuhint_callmedic",
		"menuhint_callvote",
		"menuhint_chase",
		"menuhint_scorereq",
		"menuhint_npchealth",
		"menuhint_medkitcharge",
	}
	return t
end

function GM:AdminSettingsTable()
	local adminsettingscvars = {
		{"DLabel", "adminmenu_hevvoice", "hl1_coop_sv_hevvoice", 1},
		{"DLabel", "adminmenu_custommodels", "hl1_coop_sv_custommodels", 0, func = function() timer.Simple(.1, function() if IsValid(self.Menu.MainMenuFrame) then self.Menu.MainMenuFrame:Refresh() end end) end},
		{"DLabel", "adminmenu_friendlyfire", "hl1_coop_sv_friendlyfire", 0},
		{"DLabel", "adminmenu_givemedkit", "hl1_coop_sv_medkit", 0},
		{"DLabel", "adminmenu_wboxstay", "hl1_coop_sv_wboxstay", 0},
		{"DLabel", "adminmenu_playergib", "hl1_coop_sv_playergib", 1},
		{"DLabel", "adminmenu_voteenable", "hl1_coop_sv_vote_enable", 1},
		{"DLabel", "adminmenu_allowvotingspec", "hl1_coop_sv_vote_allowspectators", 0},
		{"DLabel", "adminmenu_chatsounds", "hl1_coop_sv_chatsounds", 1},
		{"DLabel", "adminmenu_speedrunmode", "hl1_coop_mode_speedrun", 0},
		{"DLabel", "adminmenu_survivalmode", "hl1_coop_mode_survival", 0},
		{"DLabel", "adminmenu_1hpmode", "hl1_coop_mode_1hp", 0},
		{"DLabel", "adminmenu_crackmode", "hl1_coop_mode_crack", 0},
		{"DLabel", "adminmenu_gainnpchealth", "hl1_coop_sv_gainnpchealth", 1},
		{"DNumSlider", "adminmenu_skilllevel", "hl1_coop_sv_skill", 2, 0, 1, 4},
		{"DLabel", "[HL1 SWEPs] "..LangString("adminmenu_wepscreenshake"), "hl1_sv_explosionshake", 0},
		{"DLabel", "[HL1 SWEPs] "..LangString("adminmenu_wepmprules"), "hl1_sv_mprules", 0},
		{"DLabel", "[HL1 SWEPs] "..LangString("adminmenu_wepunlimitedammo"), "hl1_sv_unlimitedammo", 0},
		{"DButton", "adminmenu_cancelvote", "vote_cancel"},
		{"DButton", "adminmenu_restartmap", "game_restart"},
		{"DButton", "adminmenu_tolobby", "game_lobby"},
		{"DButton", "Impulse 101", "hl1_coop_impulse101"},
		{"DButton", "adminmenu_openswepmenu", "swepmenu"},
	}
	return adminsettingscvars
end

local function CanPlayerUseRestrictedSettings(ply)
	return ply:IsAdmin()
end

local sndMenu1 = Sound("common/launch_upmenu1.wav")
local sndMenu2 = Sound("common/launch_glow1.wav")
local sndMenu3 = Sound("common/launch_select2.wav")
local sndMenu4 = Sound("common/launch_dnmenu1.wav")

local menuframeColor = Color(20, 20, 20, 200)
local menuBackgroundColor = Color(100, 100, 100, 180)
local menuTextCol = Color(255, 200, 0, 180)
local menuTextSelected = Color(255, 255, 0, 255)
local buttoncolorDisabled = Color(50, 50, 50, 160)

local menuTitleX, menuTitleY = ScrH() / 38.4, ScrH() / 76.8
local menuContentGap = ScrH() / 38.4

function GM:OpenMountMenu(delay)
	if IsValid(self.MountMenu) and self.MountMenu:IsVisible() then
		return
	end
	
	local text = "Half-Life: Source is required to play this gamemode.\nIf you don't own it and see missing textures, please download this content pack.\nUse external browser to open the link, then download and extract to addons folder."
	local note = "IMPORTANT: you must restart the game after installing it."
	
	self.MountMenu = vgui.Create("DFrame")
	local menu = self.MountMenu
	menu:SetSize(512, 290)
	local menuW, menuH = menu:GetWide(), menu:GetTall()
	menu:SetPos(ScrW() / 2 - menuW / 2, ScrH() / 2 - menuH / 2)
	menu:SetTitle("Mounting error")
	menu:SetDraggable(true)
	menu:SetVisible(true)
	menu:ShowCloseButton(true)
	menu:SetBackgroundBlur(true)
	menu:MakePopup()

	local title = vgui.Create("DLabel", menu)
	title:SetFont("Trebuchet24")
	title:SetText("It seems like you haven't mounted Half-Life: Source")
	title:SizeToContents()
	title:SetPos(20, 30)
	
	local textLabel = vgui.Create("DLabel", menu)
	textLabel:SetFont("Trebuchet18")
	textLabel:SetText(text)
	textLabel:SizeToContents()
	textLabel:SetPos(20, 70)
	local textPosX, textPosY = textLabel:GetPos()
	
	local btn_y = textPosY + textLabel:GetTall() + 20
	
	local link = "https://mega.nz/file/t0VUQAiQ#8fWbmp3XGxQJUKho34tCwqxouwteiEEN6mJQ_sZFQQY"
	
	local textEntry = vgui.Create("DTextEntry", menu)
	textEntry:SetText(link)
	textEntry:SetSize(menuW / 1.2, 30)
	textEntry:SetPos(10, btn_y)
	textEntry.OnEnter = function()
		gui.OpenURL(link)
	end
	local button_copylink = vgui.Create("DButton", menu)
	button_copylink:SetText("Copy link")
	button_copylink:SetSize(menuW - textEntry:GetWide() - 20, 30)
	button_copylink:SetPos(textEntry:GetPos() + textEntry:GetWide(), btn_y)
	button_copylink.DoClick = function()
		SetClipboardText(link)
	end
	
	local noteLabel = vgui.Create("DLabel", menu)
	noteLabel:SetFont("Trebuchet18")
	noteLabel:SetText(note)
	noteLabel:SetTextColor(Color(255, 150, 0))
	noteLabel:SizeToContents()
	noteLabel:SetPos(20, btn_y + textEntry:GetTall() + 20)
	local noteX, noteY = noteLabel:GetPos()
	
	local ip = game.GetIPAddress()
	if ip != "loopback" then
		local note_ip = vgui.Create("DLabel", menu)
		note_ip:SetFont("Trebuchet18")
		note_ip:SetText("You can copy IP of the server by pressing this button: ")
		note_ip:SizeToContents()
		note_ip:SetPos(noteX, noteY + noteLabel:GetTall() + 6)
		local note_ipX, note_ipY = note_ip:GetPos()
		local button_copyip = vgui.Create("DButton", menu)
		button_copyip:SetText("Copy IP")
		button_copyip:SetSize(80, 20)
		button_copyip:SetPos(note_ipX + note_ip:GetWide(), note_ipY)
		button_copyip.DoClick = function()
			SetClipboardText(ip)
		end
		local button_quit = vgui.Create("DButton", menu)
		button_quit:SetText("Quit game")
		button_quit:SetSize(80, 20)
		button_quit:SetPos(menu:GetWide() - button_quit:GetWide() - 20, note_ipY)
		button_quit.DoClick = function()
			RunConsoleCommand("gamemenucommand", "quit")
		end
	end
	
	delay = delay or 10
	timer.Simple(delay, function()
		if IsValid(menu) and menu:IsVisible() then
			local checkb = vgui.Create("DCheckBoxLabel", menu)
			checkb:SetText("Do not show this again")
			checkb:SetConVar("hl1_coop_cl_nocontentwarning")
			checkb:SizeToContents()
			checkb:SetPos(20, menu:GetTall() - 28)
		end
	end)
end

function GM:ReadFuckingDescription()
	local menu = vgui.Create("DFrame")
	menu:SetSize(450, 200)
	menu:SetPos(ScrW() / 2 - menu:GetWide() / 2, ScrH() / 2 - menu:GetTall() / 2)
	menu:SetTitle("READ DESCRIPTION")
	menu:SetDraggable(true)
	menu:SetVisible(true)
	menu:ShowCloseButton(true)
	menu:MakePopup()
	
	function menu:OnClose()
		if GAMEMODE:IsCoop() and GAMEMODE:GetCoopState() == COOP_STATE_FIRSTLOAD then
			hook.Run("OpenStartMenu")
		end
	end

	local title = vgui.Create("DLabel", menu)
	title:SetFont("Trebuchet24")
	title:SetText("You are playing on unsupported map")
	title:SizeToContents()
	title:SetPos(20, 30)
	
	local text = vgui.Create("DLabel", menu)
	text:SetFont("Trebuchet18")
	text:SetText("Half-Life Co-op was made for playing on Half-Life Resized Maps.\nPlease always read description before starting the game.")
	text:SizeToContents()
	text:SetPos(menu:GetWide() / 2 - text:GetWide() / 2, 70)
	local textPosX, textPosY = text:GetPos()
	
	local btn_y = textPosY + text:GetTall() + 20

	if game.GetIPAddress() == "loopback" then
		local button = vgui.Create("DButton", menu)
		button:SetText("Press this button to load correct one")
		button:SetSize(256, 40)
		button:SetPos(menu:GetWide() / 2 - button:GetWide() / 2, btn_y)
		button.DoClick = function()
			local addonid = "971893221"
			if IsWSAddonMounted(addonid) then
				RunConsoleCommand("changelevel", HL1Maps[game.GetMap()])
			else
				gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id="..addonid)
			end
		end
	else
		local text = vgui.Create("DLabel", menu)
		text:SetFont("Trebuchet24")
		text:SetText("Tell the server host to load correct one.")
		text:SizeToContents()
		text:SetPos(menu:GetWide() / 2 - text:GetWide() / 2, btn_y)
	end
end

function GM:IsStartMenuOpen()
	return IsValid(self.StartMenu) and self.StartMenu:IsVisible()
end

function GM:StartMenuReload()
	if IsValid(self.StartMenu) then
		self.StartMenu:Remove()
		-- TODO:Stop music
	end
	hook.Run("OpenStartMenu", 3)
end

function GM:IsLobbyChatValid()
	return IsValid(self.LobbyChat) and self.LobbyChat.richText and IsValid(self.LobbyChat.richText)
end

function GM:IsLobbyChatVisible()
	return IsValid(self.LobbyChat) and self.LobbyChat:IsVisible() and self.LobbyChat.richText and IsValid(self.LobbyChat.richText) and self.LobbyChat.richText:IsVisible()
end

function GM:OpenStartMenu(firstHintTime)
	if IsValid(self.StartMenu) then
		if !self.StartMenu:IsVisible() then
			self.StartMenu:Show()
		end
		return
	end
	
	hook.Run("PlayMusic", "HL1_Music.track_21", .5)
	
	local width, height = math.Clamp(ScrW() / 1.75, 600, 900), math.Clamp(ScrH() / 6 + (32 + 1) * game.MaxPlayers(), ScrH() / 2, ScrH() / 1.65)
	local lobbyChatH = height / 3
	self.StartMenu = vgui.Create("DPanel")
	local menu = self.StartMenu
	-- menu:SetSize(width, 64 + math.min((32 + 1) * game.MaxPlayers(), 512))
	menu:SetSize(width, height)
	menu:SetPos((ScrW() - width) / 2, (ScrH() - height - lobbyChatH) / 2)
	menu:SetBackgroundColor(menuframeColor) -- old color: Color(120, 60, 0, 180)
	menu:MakePopup()
	menu:SetMouseInputEnabled(true)
	menu:SetKeyboardInputEnabled(false)
	
	local menuTitle = vgui.Create("DLabel", menu)
	menuTitle:SetFont("MenuFont")
	menuTitle:SetText(LangString("menu_lobby"))
	menuTitle:SizeToContents()
	menuTitle:SetPos(menuTitleX, menuTitleY)
	menuTitle:SetColor(menuTextCol)
	
	local margin = menuContentGap
	
	local maxPlayers = vgui.Create("DLabel", menu)
	maxPlayers:SetFont("MenuFontSmall")
	maxPlayers:SetText("0/"..game.MaxPlayers())
	maxPlayers:SizeToContents()
	maxPlayers:SetPos((width - maxPlayers:GetWide()) / 2, margin)
	maxPlayers:SetColor(menuTextCol)
	function maxPlayers:Think()
		local text = player.GetCount().."/"..game.MaxPlayers()
		if self:GetText() != text then
			self:SetText(text)
			self:SizeToContents()
			self:SetX((width - self:GetWide()) / 2)
		end
	end
	
	if self.Version then
		local version = vgui.Create("DLabel", menu)
		version:SetFont("Trebuchet18")
		version:SetText(self.Version)
		version:SizeToContents()
		version:SetPos(width - version:GetWide() - margin / 2, height - version:GetTall() - margin / 3)
		version:SetColor(menuTextCol)
	end
	
	-- function menu:PaintOver(w, h)
		-- surface.SetDrawColor(20, 20, 20, 180)
		-- surface.DrawRect(0, 0, w, margin)
		-- draw.SimpleText("Welcome to the "..GAMEMODE.Name.."!", "Trebuchet24", w / 2, 0, Color(255,200,50,255), TEXT_ALIGN_CENTER) 
		--if !ply:IsAdmin() and !ply:GetNWBool("Ready") and ply.afkTime and (RealTime() - ply.afkTime) >= GAMEMODE.KickUnreadyPlayerTime - 10 then
			--draw.DrawText("You were marked as AFK\nand will be kicked soon", "Trebuchet18", w - 95, 80, Color(255,200,50,255), TEXT_ALIGN_CENTER)
		--end
	-- end
	
	function menu:Think()
		if IsValid(self) and GAMEMODE:GetCoopState() != COOP_STATE_FIRSTLOAD then
			hook.Run("StopMusic", 1.5)
			self:Remove()
		end
		if gui.IsGameUIVisible() and self:IsVisible() then
			self:Hide()
		end
	end
	
	local menuX, menuY = menu:GetPos()	
	local PlayerPanelW, PlayerPanelH = (menu:GetWide() - margin*2.5) / 2, menu:GetTall() - menuTitle:GetTall() - margin * 2
	local PlayerPanelX, PlayerPanelY = margin, menuTitle:GetTall() + margin
	local newsPanelW = (menu:GetWide() - margin*2.5) / 2
	local lobbyChatY = menuY + height + 4
	
	local button_disconnect = vgui.Create("DLabel", menu)
	button_disconnect:SetFont("MenuFontSmall")
	button_disconnect:SetText(LangString("menu_disconnect"))
	button_disconnect:SetTextColor(menuTextCol)
	button_disconnect:SizeToContents()
	button_disconnect:SetPos(width / 2 + margin*2, height - button_disconnect:GetTall() - margin / 1.44)
	button_disconnect:SetMouseInputEnabled(true)
	function button_disconnect:DoClick()
		RunConsoleCommand("disconnect")
	end
	function button_disconnect:OnCursorEntered()
		surface.PlaySound(sndMenu2)
		self:SetTextColor(menuTextSelected)
	end
	function button_disconnect:OnCursorExited()
		self:SetTextColor(menuTextCol)
	end
	
	local button_rdy = vgui.Create("DLabel", menu)
	button_rdy:SetFont("MenuFont")
	button_rdy:SetText(LangString("menu_imready"))
	button_rdy:SetTextColor(menuTextCol)
	button_rdy:SizeToContents()
	button_rdy:SetPos((width / 2 - button_rdy:GetWide()) - margin*2, height - button_rdy:GetTall() - margin / 2)
	button_rdy:SetMouseInputEnabled(true)
	function button_rdy:DoClick()
		RunConsoleCommand("_hl1_coop_ready")
		if player.GetCount() > 1 or (CONNECTING_PLAYERS_TABLE and #CONNECTING_PLAYERS_TABLE > 0) then
			-- surface.PlaySound(sndMenu3)
			self:SetMouseInputEnabled(false)
			self:SetFont("MenuFontSmall")
			self:SetText(LangString("menu_waitingpl"))
			self:SizeToContents()
			self:SetX((menu:GetWide() - self:GetWide()) / 2) -- used menu:GetWide() rather than var 'width' because menu can have two different sizes
			button_disconnect:Hide()
		end
	end
	function button_rdy:OnCursorEntered()
		surface.PlaySound(sndMenu2)
		self:SetTextColor(menuTextSelected)
	end
	function button_rdy:OnCursorExited()
		self:SetTextColor(menuTextCol)
	end
	function button_rdy:AnimationThink()
		if !self:IsMouseInputEnabled() then
			local highlight = math.sin(RealTime() * 4) * 40
			self:SetTextColor(Color(210 + highlight, 200 + highlight, 20, 180))
		end
	end
	
	-- local waiting_text = vgui.Create("DLabel", menu)
	-- waiting_text:SetText("")
	-- waiting_text:SetTextColor(menuTextCol)
	-- waiting_text:SetSize(PlayerPanelW, PlayerPanelH / 3.3)
	-- waiting_text:SetPos((PlayerPanelW - waiting_text:GetWide()) / 2 + PlayerPanelX, height - waiting_text:GetTall())
	-- waiting_text:SetMouseInputEnabled(false)
	-- function waiting_text:Paint(w,h)
		-- if !button_rdy:IsVisible() and player.GetCount() > 1 or (CONNECTING_PLAYERS_TABLE and #CONNECTING_PLAYERS_TABLE > 0) then
			-- draw.DrawText(lang.menu_waitingpl, "ChangelogFont", w / 2, h / 2, Color(255,255,255,255), TEXT_ALIGN_CENTER) 
		-- end
	-- end
	
	PlayerPanelH = PlayerPanelH - button_rdy:GetTall()
	
	local newsPanel
	if self.Changelog then
		newsPanel = vgui.Create("DScrollPanel", menu)
		newsPanel:SetSize(newsPanelW, PlayerPanelH)
		newsPanel:SetPos((menu:GetWide() - newsPanelW - margin), PlayerPanelY)
		function newsPanel:Paint(w, h)
			surface.SetDrawColor(menuBackgroundColor)
			surface.DrawRect(0, 0, w, h)
		end
		local verText = newsPanel:Add("DLabel")
		verText:SetFont("ChangelogFont")
		verText:SetText("What's new:\n"..self.Changelog)
		verText:SetTextColor(menuTextCol)
		verText:Dock(FILL)
		-- verText:DockMargin(5, 5, 5, 5)
		verText:SetWrap(true)
		verText:SetAutoStretchVertical(true)
	end
	if !newsPanel then
		PlayerPanelW = menu:GetWide() - margin * 2
	end
	
	local PlayerPanel = vgui.Create("DScrollPanel", menu)
	PlayerPanel:SetSize(PlayerPanelW, PlayerPanelH)
	PlayerPanel:SetPos(PlayerPanelX, PlayerPanelY)
	local plyTable = {}
	--local ConnectingTimeout = CurTime() + 30

	function PlayerPanel:Think()
		for k, pl in ipairs(player.GetAll()) do
			if CONNECTING_PLAYERS_TABLE then
				if !self.Unconnected then
					self.Unconnected = {}
				end
				if self.Unconnected then
					for k, v in ipairs(CONNECTING_PLAYERS_TABLE) do
						local userid, name = v[1], v[2]
						if LocalPlayer():UserID() != userid then
							if !IsValid(self.Unconnected[userid]) then
								self.Unconnected[userid] = PlayerPanel:Add("DPanel")
								self.Unconnected[userid]:Dock(TOP)
								self.Unconnected[userid]:DockMargin(0, 0, 0, 1)
								self.Unconnected[userid]:SetSize(PlayerPanel:GetWide(), 32)
								self.Unconnected[userid]:SetBackgroundColor(Color(40, 40, 40, 180))
								
								self.Unconnected[userid].Nick = vgui.Create("DLabel", self.Unconnected[userid])
								self.Unconnected[userid].Nick:SetFont("HL1Coop_PlayerFrame")
								self.Unconnected[userid].Nick:SetText(LangString("menu_connectingpl").." ("..name..")")
								self.Unconnected[userid].Nick:SizeToContents()
								self.Unconnected[userid].Nick:SetPos(8, self.Unconnected[userid]:GetTall() / 2 - self.Unconnected[userid].Nick:GetTall() / 2 + 1)
							elseif pl:UserID() == userid then
								self.Unconnected[userid]:Hide()
							end
						end
					end
				end
			end
			if !IsValid(pl.PlyReady) then
				pl.PlyReady = PlayerPanel:Add("DPanel")
				pl.PlyReady:Dock(TOP)
				pl.PlyReady:DockMargin(0, 0, 0, 1)
				pl.PlyReady:SetSize(PlayerPanel:GetWide(), 32)
				pl.PlyReady:SetBackgroundColor(Color(40, 40, 40, 180))
				
				pl.PlyReady.Avatar = vgui.Create("AvatarImage", pl.PlyReady)
				pl.PlyReady.Avatar:SetSize(32, 32)
				pl.PlyReady.Avatar:SetPlayer(pl, 32)
				
				pl.PlyReady.Nick = vgui.Create("DLabel", pl.PlyReady)
				pl.PlyReady.Nick:SetFont("HL1Coop_PlayerFrame")
				pl.PlyReady.Nick:SetText(pl:Nick())
				pl.PlyReady.Nick:SetSize(200, pl.PlyReady:GetTall())
				pl.PlyReady.Nick:SetPos(pl.PlyReady.Avatar:GetWide() + 8, 1)
				
				pl.PlyReady.Status = vgui.Create("DLabel", pl.PlyReady)
				pl.PlyReady.Status:SetFont("HL1Coop_PlayerFrame")
				pl.PlyReady.Status:SetSize(pl.PlyReady:GetSize())
				
				function pl.PlyReady:AnimationThink()
					if pl == LocalPlayer() then
						local highlight = math.sin(RealTime()) * 30 + 30
						self:SetBackgroundColor(Color(40 + highlight * 1.25, 40 + highlight * 1.5, 40 + highlight / 2, 180))
					end
				end
				
				local toTable = {pl, pl.PlyReady}
				if !table.HasValue(plyTable, toTable) then
					table.insert(plyTable, toTable)
				end
				
				-- PlayerPanel:OnPlayerAdded(pl.PlyReady, pl)
			else
				local text, col = "menu_connecting", Color(255, 200, 40, 255)
				if pl:GetNWInt("Status") == PLAYER_READY then
					text, col = "menu_ready", Color(40, 255, 40, 255)
				elseif pl:GetNWInt("Status") == PLAYER_NOTREADY then
					text, col = "menu_notready", Color(255, 40, 40, 255)
				end
				if pl:IsBot() then
					text = "menu_bot"
				end
				local langString = LangString(text)
				if pl.PlyReady.Status:GetText() != langString then
					pl.PlyReady.Status:SetText(langString)
					pl.PlyReady.Status:SetTextColor(col)
					pl.PlyReady.Status:SizeToContents()
					pl.PlyReady.Status:SetPos(pl.PlyReady:GetWide() - pl.PlyReady.Status:GetWide() - 8, pl.PlyReady:GetTall() / 2 - pl.PlyReady.Status:GetTall() / 2 + 1)
				end
				if pl.PlyReady.Nick:GetText() != pl:Nick() then
					pl.PlyReady.Nick:SetText(pl:Nick())
				end
			end
		end
		if CONNECTING_PLAYERS_TABLE and self.Unconnected then
			for id, label in pairs(self.Unconnected) do
				if IsValid(label) then
					local hasvalue = false
					for k, v in ipairs(CONNECTING_PLAYERS_TABLE) do
						if v[1] == id then hasvalue = true break end
					end
					if !hasvalue then label:Remove() end
				end
			end
		end
		for k, v in ipairs(plyTable) do
			if !IsValid(v[1]) then
				-- PlayerPanel:OnPlayerRemoved(v[2], v[1])
				v[2]:Remove()
			end
		end
	end
	function PlayerPanel:Paint(w, h)
		surface.SetDrawColor(menuBackgroundColor)
		surface.DrawRect(0, 0, w, h)
	end
	
	local function chatSendMessage(textpnl)
		RunConsoleCommand("say", textpnl:GetValue())
		textpnl:SetText("")
	end
	
	local chatMargin = 6
	self.LobbyChat = vgui.Create("EditablePanel", menu)
	local lobbyChat = self.LobbyChat
	lobbyChat:SetSize(width, lobbyChatH)
	lobbyChat:SetPos(menuX, lobbyChatY)
	lobbyChat:MakePopup()
	-- lobbyChat:SetMouseInputEnabled(false)
	lobbyChat:SetKeyboardInputEnabled(false)
	function lobbyChat:Paint(w, h)
		surface.SetDrawColor(menuframeColor)
		surface.DrawRect(0, 0, w, h)
	end
	local textEntryH = 24
	local textEntry = vgui.Create("DTextEntry", lobbyChat)
	textEntry:SetSize(width - 64, textEntryH)
	textEntry:SetPos(0, lobbyChatH - textEntryH)
	textEntry:SetPlaceholderText(LangString("chat_yourmessage"))
	function textEntry:OnGetFocus()
		lobbyChat:SetKeyboardInputEnabled(true)
	end
	function textEntry:OnLoseFocus()
		lobbyChat:SetKeyboardInputEnabled(false)
	end
	function textEntry:OnKeyCodeTyped(code)
		if code == KEY_TAB then
			self:SetText(hook.Run("OnChatTab", self:GetValue()))
			return true
		elseif code == KEY_ENTER then
			chatSendMessage(self)
			-- return true
		end
	end
	function textEntry:OnChange()
		hook.Run("ChatTextChanged", self:GetValue())
	end

	local chatSendW = 64
	local chatSend = vgui.Create("DButton", lobbyChat)
	chatSend:SetSize(chatSendW, textEntryH)
	chatSend:SetPos(width - chatSendW, lobbyChatH - textEntryH)
	chatSend:SetText(LangString("chat_send"))
	chatSend.DoClick = function()
		chatSendMessage(textEntry)
	end
	
	lobbyChat.richText = vgui.Create("RichText", lobbyChat)
	lobbyChat.richText:Dock(FILL)
	lobbyChat.richText:DockMargin(chatMargin, chatMargin, chatMargin, textEntryH + chatMargin)
	function lobbyChat.richText:PerformLayout()
		self:SetFontInternal("GModNotify")
		self:SetBGColor(menuBackgroundColor)
	end
	
	local hint_panel = vgui.Create("DPanel", menu)
	hint_panel:SetBackgroundColor(Color(110, 70, 0, 180))
	hint_panel:SetAlpha(0)
	hint_panel:MakePopup()
	hint_panel:SetMouseInputEnabled(false)
	hint_panel:SetKeyboardInputEnabled(false)
	
	local hint_table = hook.Run("HintTable")
	local randomhint = math.random(1, #hint_table)
	
	local hint_text = vgui.Create("DLabel", hint_panel)
	hint_text:SetFont("HintPanel")
	hint_text:SetText(LangString("menu_hint")..": "..LangString(hint_table[randomhint]))
	hint_text:SetTextColor(Color(255, 255, 80, 255))
	hint_text:SizeToContents()
	hint_panel:SetSize(menu:GetWide(), hint_text:GetTall() + 16)
	hint_text:SetPos(hint_panel:GetWide() / 2 - hint_text:GetWide() / 2, hint_panel:GetTall() / 2 - hint_text:GetTall() / 2)
	
	table.remove(hint_table, randomhint)
	
	local HINT_FIRST_TIME = firstHintTime or 15
	local HINT_LIFE_TIME = 6
	local HINT_NEXT_TIME = 3.5 -- works a bit incorrectly
	
	local hintalpha = 0
	local hinttime = RealTime() + HINT_FIRST_TIME -- first hint appearing
	local hintendtime = hinttime + HINT_LIFE_TIME
	local hintpos = lobbyChatY + lobbyChatH - hint_panel:GetTall()
	local hintepos = lobbyChatY + lobbyChatH + 4
	
	function hint_panel:AnimationThink()
		local FT = FrameTime()
		if hinttime <= RealTime() then -- slides down
			hintalpha = Lerp(FT * 2, hintalpha, 255)
			hintpos = Lerp(FT * 4, hintpos, hintepos)
			self:SetPos(menu:GetX(), hintpos)
		end
		if hintendtime <= RealTime() then
			hinttime = RealTime() + HINT_NEXT_TIME
			hintalpha = Lerp(FT * 2, hintalpha, 0)
			if hintalpha < .001 then
				hintendtime = hinttime + HINT_LIFE_TIME
				hintpos = lobbyChatY + lobbyChatH - hint_panel:GetTall()
				
				if #hint_table == 0 then
					hint_table = hook.Run("HintTable")
				end

				randomhint = math.random(1, #hint_table)

				hint_text:SetText(LangString("menu_hint")..": "..LangString(hint_table[randomhint]))
				hint_text:SizeToContents()
				hint_text:SetPos(self:GetWide() / 2 - hint_text:GetWide() / 2, self:GetTall() / 2 - hint_text:GetTall() / 2)
				
				table.remove(hint_table, randomhint)
			end
		end
		self:SetAlpha(hintalpha)
	end
	
	local button = vgui.Create("DButton", menu)
	button:SetText(">>")
	button:SetSize(30, 21)
	button:SetPos(menu:GetWide() - button:GetWide() - 2, 2)
	function button:MenuToCenter()
		menu:MoveTo(menuX, menuY, .5, 0, -1, function()
			button:SetText(">>")
			button.Func = button.MenuToRight
			if newsPanel then newsPanel:SetSize(newsPanelW, PlayerPanelH) end
			menu:SetWidth(width)
			hint_panel:SetVisible(true)
			lobbyChat:SetVisible(true)
			button:SetX(menu:GetWide() - button:GetWide() - 2)
			if button_rdy:IsMouseInputEnabled() then -- if "ready"
				button_rdy:SetX((width / 2 - button_rdy:GetWide()) - margin*2)
			else -- if "waiting for players"
				button_rdy:SetX((width - button_rdy:GetWide()) / 2)
			end
			maxPlayers:SetX((menu:GetWide() - maxPlayers:GetWide()) / 2)
		end)
	end
	function button:MenuToRight()
		if newsPanel then newsPanel:SetSize(0, 0) end
		menu:SetWidth(PlayerPanelW + margin * 2)
		hint_panel:SetVisible(false)
		lobbyChat:SetVisible(false)
		button:SetX(menu:GetWide() - button:GetWide() - 2)
		button_rdy:SetX((menu:GetWide() - button_rdy:GetWide()) / 2)
		maxPlayers:SetX((menu:GetWide() - maxPlayers:GetWide()) / 2)
		-- TODO: resize playerpanel if there is no newspanel
		menu:MoveTo(ScrW() - menu:GetWide() - 3, menuY, .5, 0, -1, function()
			button:SetText("<<")
			button.Func = button.MenuToCenter
		end)
	end
	button.Func = button.MenuToRight
	function button:DoClick()
		self.Func()
	end
end

function GM:OpenDeathMenu(isSurvival)
	local plyscore = LocalPlayer():GetScore() or 0
	local respawncost = cvar_price_respawn_here:GetInt()
	local fullrespawncost = cvar_price_respawn_full:GetInt()
	local survrespawncost = cvar_price_respawn_survival:GetInt()
	
	if IsValid(self.DeathMenu) and self.DeathMenu:IsVisible() then
		return
	end
	
	local respawnOptions = {
		{price = 0, text = "deathmenu_option3", cvar = 2, disabled = false},
		{price = respawncost, text = "deathmenu_option2", cvar = 1, disabled = false},
		{price = fullrespawncost, text = "deathmenu_option1", cvar = 3, disabled = MAP.DisableFullRespawn}
	}
	
	if isSurvival then
		respawnOptions = {
			{price = survrespawncost, text = "deathmenu_option_surv1", cvar = 2, disabled = false},
			{text = "deathmenu_option_surv2", cvar = 1, disabled = false}
		}
	end
	
	local textwidth, textheight = 0, 0
	local maxWidth = 0
	surface.SetFont("MenuFontSmall")
	for k, v in ipairs(respawnOptions) do
		textwidth, textheight = surface.GetTextSize(LangString(v.text))
		if textwidth > maxWidth then maxWidth = textwidth end
	end
	
	local gap_from_title = textheight * 2.15
	local gap_from_text = textheight * 1.15
	local w, h = ScrW() / 6 + maxWidth, gap_from_title * 1.35 + #respawnOptions * gap_from_text

	self.DeathMenu = vgui.Create("DPanel")
	local menu = self.DeathMenu
	menu:SetSize(w, h)
	menu:SetPos(ScrW() / 2 - w / 2, ScrH())
	menu:MoveTo(ScrW() / 2 - w / 2, ScrH() / 1.3 - h / 2, .25)
	menu:MakePopup()
	menu.startTime = SysTime()
	function menu:Paint(w, h)
		Derma_DrawBackgroundBlur(self, self.startTime)
		surface.SetDrawColor(menuframeColor)
		surface.DrawRect(0, 0, w, h)
	end
	
	local deathText = vgui.Create("DLabel", menu)
	deathText:SetFont("MenuFont")
	deathText:SetText(LangString("deathmenu_title"))
	deathText:SizeToContents()
	deathText:SetPos(menuTitleX, menuTitleY)
	deathText:SetColor(menuTextCol)

	local scoreText = vgui.Create("DLabel", menu)
	scoreText:SetFont("MenuFontSmall")
	scoreText:SetText(LangString("score")..": "..plyscore)
	scoreText:SetTextColor(Color(255, 250, 100, 255))
	scoreText:SizeToContents()
	scoreText:SetPos(w - scoreText:GetWide() - menuTitleX, menuTitleY * 1.5)

	local x, y = ScrW() * 0.024, gap_from_title
	for k, v in ipairs(respawnOptions) do
		local option = vgui.Create("DLabel", menu)
		option:SetFont("MenuFontSmall")
		option:SetText(LangString(v.text))
		option:SizeToContents()
		option:SetMouseInputEnabled(true)
		if k > 1 then
			y = y + gap_from_text
		end
		option:SetPos(x, y)
		if v.price and plyscore < v.price or v.disabled then
			option:SetTextColor(Color(100,100,100,150))
		else
			function option:OnCursorEntered()
				surface.PlaySound(sndMenu2)
				self:SetTextColor(Color(255,255,255,255))
			end
			function option:OnCursorExited()
				self:SetTextColor()
			end
			function option:DoClick()
				surface.PlaySound(sndMenu3)
				if v.cvar then RunConsoleCommand("_hl1_coop_respawn", v.cvar) end
				menu:Remove()
			end
		end
		
		if v.price then
			local cost = vgui.Create("DLabel", menu)
			cost:SetFont("MenuFontSmall")
			cost:SetTextColor(Color(255, 255, 0, 255))
			if v.price == 0 then
				cost:SetText(LangString("free"))
			else
				cost:SetText(v.price)
			end
			cost:SizeToContents()
			cost:SetPos(w - x - cost:GetWide(), y)
		end
	end
end

function GM:OpenMapRecords()
	local openTime = RealTime() + 30
	local recordsWidth, recordsHeight = ScrW() / 1.65, ScrH() / 1.4

	local menu = vgui.Create("DFrame")
	menu:SetSize(recordsWidth, recordsHeight)
	menu:SetPos(ScrW() / 2 - recordsWidth / 2, ScrH() / 2 - recordsHeight / 2)
	menu:SetTitle("Map records")
	menu:SetDraggable(true)
	menu:SetVisible(true)
	menu:ShowCloseButton(true)
	menu:MakePopup()
	function menu:Paint(w,h)
		local alpha = math.Clamp((30 + (RealTime() - openTime)) * 150, 0, 180)
		surface.SetDrawColor(0, 0, 0, alpha)
		surface.DrawRect(0, 0, w, h)
	end

	local list = vgui.Create("DListLayout", menu)		
end

function GM:IsLanguageMenuOpen()
	return IsValid(self.langSettings) and self.langSettings:IsVisible()
end

function GM:OpenLanguageMenu(short)
	if self:IsLanguageMenuOpen() then
		self.langSettings:Remove()
		return
	end
	
	short = short or GAMEMODE:GetCoopState() == COOP_STATE_FIRSTLOAD
	
	local t = hook.Run("GetLanguageTable")
	local langCount = #t
	
	local flagW, flagH = 80, 50
	local gap = flagW
	
	self.langSettings = vgui.Create("DPanel")
	local langSettings = self.langSettings
	local width = flagW * langCount + gap * (langCount + 1)
	local height = short and ScrH() / 5 + flagH or ScrH() / 2.25
	if ScrW() < width then
		width = ScrW()
		height = height * 1.75
	end
	langSettings:SetSize(width, height)
	local langSettingsW, langSettingsH = langSettings:GetSize()
	langSettings:SetPos(ScrW() / 2 - langSettingsW / 2, ScrH() / 2 - langSettingsH / 2)
	langSettings:SetBackgroundColor(menuframeColor)
	langSettings:MakePopup()
	langSettings.startTime = SysTime()
	
	local menuTitleY = 5
	local menuTitle = vgui.Create("DLabel", langSettings)
	menuTitle:SetFont("MenuFont")
	menuTitle:SetText("Language select")
	menuTitle:SizeToContents()
	menuTitle:SetPos(20, menuTitleY)
	menuTitle:SetColor(menuTextCol)
	
	local langList = vgui.Create("DIconLayout", langSettings)
	langList:SetPos(gap, menuTitleY*7 + menuTitle:GetTall())
	langList:SetSize(langSettingsW - gap*2, langSettingsH)
	langList:SetSpaceX(gap)
	langList:SetSpaceY(flagH*1.25)
	
	local function CreateOptions()
		if short then return end
		
		local langSettings = self.langSettings
		if !IsValid(langSettings) then return end
		
		local menu = {
			{"menu_disconnect", function() RunConsoleCommand("disconnect") end, true},
			{"menu_spectate", function() langSettings:Remove() if LocalPlayer():Team() != TEAM_SPECTATOR then RunConsoleCommand("hl1_coop_spectate") end end},
			{"menu_joingame", function() langSettings:Remove() if LocalPlayer():Team() == TEAM_SPECTATOR then RunConsoleCommand("hl1_coop_spectate") end end},
		}
		
		local menuEntryPos = langSettings:GetTall() - 20
		
		for k, v in pairs(menu) do
			menuEntryPos = menuEntryPos - langSettings:GetTall() / 10
			k = vgui.Create("DLabel", langSettings)
			k:SetFont("MenuFont")
			k:SetText(LangString(v[1]))
			k:SetTextColor(menuTextCol)
			k:SizeToContents()
			k:SetPos(langSettings:GetWide() / 2 - k:GetWide() / 2, menuEntryPos)
			--if cvars.String("hl1_coop_cl_lang") == "" and !v[3] then
				--k:SetMouseInputEnabled(false)
				--k:SetTextColor(buttoncolorDisabled)
			--else
				k:SetMouseInputEnabled(true)
			--end
		
			function k:OnCursorEntered()
				surface.PlaySound(sndMenu2)
				k:SetTextColor(menuTextSelected)
			end
			function k:OnCursorExited()
				k:SetTextColor(menuTextCol)
			end
			function k:DoClick()
				surface.PlaySound(sndMenu3)
				v[2]()
			end
			function k:RefreshText()
				k:Remove()
			end
		end
	end

	if t then
		for k, v in pairs(t) do
			local panel = langList:Add("DImageButton")
			panel:SetSize(flagW, flagH)
			panel:SetImage(v[3])
			panel.Title = v[2]
			function panel:OnCursorEntered()
				langSettings.highlightItem = self
			end
			function panel:OnCursorExited()
				langSettings.highlightItem = nil
			end
			function panel:DoClick()
				local convar = GetConVar("hl1_coop_cl_lang")
				convar:SetString(v[1])
				if short then
					langSettings:Remove()
				else
					langSettings.clickedItem = self
					for k, v in pairs(langSettings:GetChildren()) do
						if v:GetName() == "DLabel" then
							if v.RefreshText then
								v:RefreshText()
							end
						end
					end
					CreateOptions()
				end
			end
			
			if self:GetLanguage() == v[1] then
				langSettings.clickedItem = panel
			end
		end
	end
	
	function langSettings:Paint(w, h)
		Derma_DrawBackgroundBlur(self, self.startTime)
		local sine = math.sin(RealTime()) * 10 + 20
		surface.SetDrawColor(sine + 5, sine, 20, 250)
		surface.DrawRect(0, 0, w, h)
		
		if self.highlightItem and IsValid(self.highlightItem) and self.highlightItem:IsVisible() then
			local x, y = self:GetChildPosition(self.highlightItem)
			local fw, fh = self.highlightItem:GetWide() + 40, self.highlightItem:GetTall() + 40
			surface.SetDrawColor(150, 150, 150, 60)
			surface.DrawRect(x - 20, y - 20, fw, fh)
		end
		if self.clickedItem and IsValid(self.clickedItem) and self.clickedItem:IsVisible() then
			local x, y = self:GetChildPosition(self.clickedItem)
			local fw, fh = self.clickedItem:GetWide() + 40, self.clickedItem:GetTall() + 40
			surface.SetDrawColor(180, 170, 150, 100)
			surface.DrawRect(x - 20, y - 20, fw, fh)
		end
		
		for k, v in ipairs(langList:GetChildren()) do
			local x, y = self:GetChildPosition(v)
			draw.SimpleText(v.Title, "MenuFontSmall", x + flagW / 2, y + flagH*1.4, Color(200,200,200,255), TEXT_ALIGN_CENTER)
		end
	end
	CreateOptions()
	
	function langSettings:OnRemove()
		hook.Run("OnLanguageMenuClose")
	end
end

function GM:OnLanguageMenuClose()
	if GAMEMODE:GetCoopState() == COOP_STATE_FIRSTLOAD then
		hook.Run("StartMenuReload")
	end
end

function GM:OpenQuickMenu()
	local ply = LocalPlayer()
	if ply:Team() != TEAM_COOP then return end

	if IsValid(self.quickMenu) and self.quickMenu:IsVisible() then
		self.quickMenu:Remove()
		return
	end
	local options = hook.Run("QuickMenuOptions")
	local font = "MenuFontSmall"
	surface.SetFont(font)
	local _, fontHeight = surface.GetTextSize("")
	
	self.quickMenu = vgui.Create("DPanel")
	local quickMenu = self.quickMenu
	quickMenu:SetSize(ScrW() / 6, #options * (fontHeight + 4) + 40)
	local quickMenuW, quickMenuH = quickMenu:GetSize()
	local quickMenuX, quickMenuY = -quickMenuW, ScrH() / 2 - quickMenuH / 2
	quickMenu:SetPos(quickMenuX, quickMenuY)
	quickMenu:SetBackgroundColor(menuframeColor)
	quickMenu:MakePopup()
	quickMenu.AnimType = 1
	
	function quickMenu:OnKeyCodePressed(key)
		if input.LookupKeyBinding(key) == "gm_showspare2" then
			quickMenu:DoHideAnim()
		end
	end
	
	function quickMenu:DoStartAnim()
		self.AnimType = 1
	end
	function quickMenu:DoHideAnim()
		self.AnimType = 2
		self:SetMouseInputEnabled(false)
		self:SetKeyboardInputEnabled(false)
	end

	local margin = 20
	local maxwidth = quickMenu:GetWide()
	for k, v in pairs(options) do		
		local l = vgui.Create("DLabel", quickMenu)
		l:Dock(TOP)
		l:DockMargin(margin, 20, 0, -16)
		l:SetTextColor(menuTextCol)
		l:SetFont(font)
		l:SetText(LangString(v[1]))
		l:SizeToContents()
		local textwidth = l:GetWide() + margin*2
		if textwidth > maxwidth then
			maxwidth = textwidth
		end
		if !v[3] or v[3]() then
			l:SetMouseInputEnabled(true)
			function l:OnCursorEntered()
				surface.PlaySound(sndMenu2)
				self:SetTextColor(menuTextSelected)
			end
			function l:OnCursorExited()
				self:SetTextColor(menuTextCol)
			end
			function l:DoClick()
				surface.PlaySound(sndMenu3)
				quickMenu:DoHideAnim()
				v[2]()
			end
		else
			l:SetTextColor(buttoncolorDisabled)
		end
	end
	quickMenu:SetWide(maxwidth)
	
	function quickMenu:AnimationThink()	
		local FT = RealFrameTime()
		if self.AnimType == 1 then
			quickMenuX = Lerp(FT*8, quickMenuX, 0)
			self:SetPos(quickMenuX, quickMenuY)
			if quickMenuX >= -0.1 then
				self.AnimType = nil
			end
		elseif self.AnimType == 2 then
			quickMenuX = math.Approach(quickMenuX, -quickMenuW, FT*3000)
			self:SetPos(quickMenuX, quickMenuY)
			if quickMenuX <= -quickMenuW then
				self:Remove()
			end
		end
	end
end

concommand.Add("hl1_coop_quickmenu", function()
	GAMEMODE:OpenQuickMenu()
end)

concommand.Add("swepmenu", function()
	GAMEMODE:OpenSWEPMenu()
end)

concommand.Add("sweplist", function() -- helps finding needed swep
	for _, swep in SortedPairsByMemberValue(weapons.GetList(), "PrintName") do
		if swep.PrintName then
			print("Name: "..swep.PrintName, "Base: "..swep.Base, "Class: "..swep.ClassName)
		end
	end
end)

function GM:OpenSWEPMenu()
	if IsValid(self.SWEPMenu) and self.SWEPMenu:IsVisible() then
		self.SWEPMenu:Remove()
		return
	end
	
	if !CanPlayerUseRestrictedSettings(LocalPlayer()) then return end
	
	self.SWEPMenu = vgui.Create("DPanel")
	local menu = self.SWEPMenu
	menu:SetSize(ScrW() / 1.5, ScrH() / 1.3)
	local menuW, menuH = menu:GetSize()
	menu:SetPos(ScrW() / 2 - menuW / 2, ScrH() / 2 - menuH / 2)
	menu:SetBackgroundColor(menuframeColor)
	menu:MakePopup()
	
	local menuTitle = vgui.Create("DLabel", menu)
	menuTitle:SetFont("MenuFont")
	menuTitle:SetText("SWEPs")
	menuTitle:SizeToContents()
	menuTitle:SetPos(menuTitleX, menuTitleY)
	menuTitle:SetColor(menuTextCol)
	
	local menuBackground = vgui.Create("DScrollPanel", menu)
	menuBackground:SetSize(menuW - menuContentGap*2, menuH / 1.4)
	menuBackground:SetPos(menuContentGap, menuTitle:GetTall() + menuContentGap)
	menuBackground:SetPaintBackground(true)
	menuBackground:SetBackgroundColor(menuBackgroundColor)
	local menuBackgroundW, menuBackgroundH = menuBackground:GetSize()
	local wepList = vgui.Create("DIconLayout", menuBackground)
	wepList:SetSize(menuBackgroundW, menuBackgroundH)
	wepList:SetPos(menuBackgroundW / 40, menuBackgroundH / 40)
	wepList:SetSpaceY(5)
	wepList:SetSpaceX(5)
	
	local sweps = weapons.GetList()
	for k, swep in SortedPairsByMemberValue(sweps, "ClassName") do
		local class
		local img, img_png = ""
		if swep.Spawnable then
			class = swep.ClassName
			img, img_png = "vgui/entities/"..class, "entities/"..class..".png"
		end
		if class and !string.StartWith(class, "weapon_hl1_") then
			local ListItem = wepList:Add("DImageButton")
			ListItem:SetSize(wepList:GetWide() / 7.725, wepList:GetWide() / 7.725)
			ListItem:SetImage(img, img_png)
			ListItem:SetText(class)
			ListItem.DoClick = function()
				local ply = LocalPlayer()
				if ply:Alive() then
					RunConsoleCommand("hl1_coop_give", class)
					timer.Simple(.1, function()
						if ply:HasWeapon(class) then
							local wep = ply:GetWeapon(class)
							if IsValid(wep) then
								if class == "weapon_vfirethrower" then
									wep.ViewModelOffset = {
										PosForward = 9,
										PosRight = 3,
										PosUp = -16.5,
		
										AngForward = 0,
										AngRight = 1,
										AngUp = 1.5
									}
								end
								input.SelectWeapon(wep)
							end
						end
					end)
				end
			end
			ListItem.PaintOver = function(ListItem, w, h)
				draw.SimpleText(ListItem:GetText(), "default", w / 2, h - 8, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	end
	
	local closeButton = vgui.Create("DLabel", menu)
	closeButton:SetFont("MenuFont")
	closeButton:SetText(LangString("menu_close"))
	closeButton:SizeToContents()
	closeButton:SetPos(menuW / 2 - closeButton:GetWide() / 2, menuH - closeButton:GetTall() - 32)
	closeButton:SetMouseInputEnabled(true)
	function closeButton:DoClick()
		menu:Remove()
	end
end

GM.Menu = {}
GM.LogoImage = "hl1coop_logo.png"
GM.LogoImageSize = {320, 132}

function GM:OpenMainMenu()
	--showGameUI = false
	
	if IsValid(self.langSettings) and self.langSettings:IsVisible() then
		self.langSettings:Remove()
		return
	end	
	if IsValid(self.quickMenu) and self.quickMenu:IsVisible() then
		self.quickMenu:Remove()
		return
	end
	if IsValid(self.DeathMenu) and self.DeathMenu:IsVisible() then
		self.DeathMenu:Remove()
		return
	end
	
	if self.Menu.MainMenuFrame and self.Menu.MainMenuFrame:IsVisible() then
		self:CloseMenus()
		return
	end
	
	if game.SinglePlayer() then
		RunConsoleCommand("pause")
	end
	
	local menu = hook.Run("MainMenuOptions")

	self.Menu.MainMenuFrame = vgui.Create("DPanel")
	self.Menu.MainMenuFrame:SetPos(ScrW() / 16, 0)
	self.Menu.MainMenuFrame:SetSize(ScrW() / 3.5, ScrH())
	self.Menu.MainMenuFrame:SetBackgroundColor(menuframeColor)
	self.Menu.MainMenuFrame:MakePopup()
	local menuW, menuH = self.Menu.MainMenuFrame:GetSize()
	local menuX, menuY = self.Menu.MainMenuFrame:GetPos()
	local menuStart = 0 - menuW
	local menuHideGap = menuW / 4
	local menuHideFocusGap = 110
	function self.Menu.MainMenuFrame:DoStartAnim()
		surface.PlaySound(sndMenu1)
		self.AnimType = 1
	end
	function self.Menu.MainMenuFrame:DoEndAnim()
		menuStart = -menuW
		surface.PlaySound(sndMenu4)
		self.AnimType = 2
		if IsValid(GAMEMODE.Menu.voteMenu) and GAMEMODE.Menu.voteMenu:IsVisible() then GAMEMODE.Menu.voteMenu:DoHideAnim() end
		self:SetMouseInputEnabled(false)
		self:SetKeyboardInputEnabled(false)
		if game.SinglePlayer() then
			RunConsoleCommand("unpause")
		end
	end
	function self.Menu.MainMenuFrame:DoHideAnim()
		menuStart = menuHideGap - menuW
		surface.PlaySound(sndMenu4)
		self.AnimType = 3
		if IsValid(GAMEMODE.Menu.voteMenu) and GAMEMODE.Menu.voteMenu:IsVisible() then GAMEMODE.Menu.voteMenu:DoHideAnim() end
	end
	function self.Menu.MainMenuFrame:Popup()
		self.Hidden = false
		menuX = ScrW() / 16
		self:DoStartAnim()
	end
	function self.Menu.MainMenuFrame:AnimationThink()
		local FT = RealFrameTime()
		if self.AnimType == 1 then
			menuStart = Lerp(FT*8, menuStart, menuX)
			self:SetPos(math.ceil(menuStart))
			if self:GetPos() == menuX then
				self.AnimType = nil
			end
		elseif self.AnimType == 2 then
			menuX = math.Approach(menuX, menuStart, FT*3000)
			self:SetPos(menuX)
			if self:GetPos() == menuStart then
				menuStart = menuX
				GAMEMODE:CloseMenus()
				self.AnimType = nil
			end
		elseif self.AnimType == 3 then
			menuX = Lerp(FT*8, menuX, menuStart)
			self:SetPos(math.floor(menuX))
			if self:GetPos() == menuStart then
				menuStart = menuX
				self.Hidden = true
				self.AnimType = nil
			end
		end
	end
	function self.Menu.MainMenuFrame:OnCursorEntered()
		if self.Hidden and (!self.NextAnim or self.NextAnim <= RealTime()) then
			self.AnimType = 1
			menuX = (menuHideGap + menuHideFocusGap) - menuW
			self.NextAnim = RealTime() + .1
		end
	end
	function self.Menu.MainMenuFrame:OnCursorExited()
		if self.Hidden then
			self.AnimType = 3
			menuStart = menuHideGap - menuW
			self.NextAnim = RealTime() + .1
		end
	end
	function self.Menu.MainMenuFrame:OnMousePressed(key)
		if self.Hidden and key == MOUSE_FIRST then
			GAMEMODE:CloseSubMenus()
			self:Popup()
		end
	end
	self.Menu.MainMenuFrame:DoStartAnim()
	
	local hl1cooplogo = vgui.Create("DImage", self.Menu.MainMenuFrame)
	local logoScale = menuW / 380
	hl1cooplogo:SetSize(self.LogoImageSize[1] * logoScale, self.LogoImageSize[2] * logoScale)
	local hl1cooplogoW, hl1cooplogoH = hl1cooplogo:GetSize()
	hl1cooplogo:SetPos(menuW / 2 - hl1cooplogoW / 2, 20)
	hl1cooplogo:SetImage(self.LogoImage, "gui/contenticon-hovered.png")
	
	function self.Menu.MainMenuFrame:CreateOptions()
		local menuEntryPos = ScrH() / 6
		
		for k, v in pairs(menu) do
			local invisible
			if v.adminonly and !CanPlayerUseRestrictedSettings(LocalPlayer()) then
				invisible = true
			end
			local namefunc = v[3]
			local disabled
			if namefunc and namefunc() == false then
				disabled = true
			end
			menuEntryPos = menuEntryPos + menuH / 16
			k = vgui.Create("DLabel", self)
			k:SetPos(menuW / 8, menuEntryPos)
			k:SetFont("MenuFont")
			k:SetText(LangString(v[1]))
			if namefunc and namefunc() then
				k:SetText(LangString(namefunc()))
			end
			k:SetTextColor(menuTextCol)
			k:SizeToContents()
			k:SetMouseInputEnabled(true)
			if disabled then
				k:SetMouseInputEnabled(false)
				k:SetTextColor(buttoncolorDisabled)
			elseif invisible then
				k:SetMouseInputEnabled(false)
				k:SetTextColor(Color(0,0,0,0))
			else
				k.OnCursorEntered = function()
					surface.PlaySound(sndMenu2)
					k:SetTextColor(menuTextSelected)
				end
				k.OnCursorExited = function()
					k:SetTextColor(menuTextCol)
				end
				function k:DoClick()
					surface.PlaySound(sndMenu3)
					v[2]()
				end
				function k:Think()
					if GAMEMODE.Menu.MainMenuFrame.Hidden then
						k:SetMouseInputEnabled(false)
					elseif !k:IsMouseInputEnabled() then
						k:SetMouseInputEnabled(true)
					end
				end
			end
		end
	end
	self.Menu.MainMenuFrame:CreateOptions()
	
	function self.Menu.MainMenuFrame:Refresh()
		for k, v in pairs(self:GetChildren()) do
			if v:GetClassName() == "Label" then
				v:Remove()
			end
		end
		self:CreateOptions()
	end
end

function GM:PlayerSettingsOptions()
	local settingscvars = {
		{"DCheckBoxLabel", "configmenu_halos", "hl1_coop_cl_drawhalos", 1},
		{"DCheckBoxLabel", "configmenu_hints", "hl1_coop_cl_showhints", 1},
		{"DCheckBoxLabel", "configmenu_score", "hl1_coop_cl_showscore", 1},
		{"DCheckBoxLabel", "configmenu_subtitles", "hl1_coop_cl_subtitles", 1},
		{"DCheckBoxLabel", "configmenu_chatsnds", "hl1_coop_cl_chatsounds", 1},
		{"DCheckBoxLabel", "configmenu_autoswitch", "hl1_coop_cl_autoswitch", 1},
		{"DCheckBoxLabel", "configmenu_firelight", "hl1_cl_firelight", 1},
		{"DCheckBoxLabel", "configmenu_muzzleflash", "hl1_cl_muzzleflash", 1},
		{"DCheckBoxLabel", "configmenu_muzzlesmoke", "hl1_cl_muzzlesmoke", 1},
		{"DCheckBoxLabel", "configmenu_chair", "hl1_cl_crosshair", 1},
		{"DNumSlider", "configmenu_chairscale", "hl1_cl_crosshair_scale", 1, 1, 1, 4},
		{"DNumSlider", "configmenu_vmfov", "hl1_cl_viewmodelfov", 90, 0, 70, 120},
		{"DComboBox", "configmenu_bobstyle", "hl1_coop_cl_bobstyle", 1, choices = {"Half-Life", "Half-Life WON", "Realistic", "Half-Life: Source", "Quake 3", "Unreal Tournament", "Serious Sam"}},
		{"DCheckBoxLabel", "configmenu_custombob", "hl1_coop_cl_bobcustom", 1},
		{"DCheckBoxLabel", "configmenu_viewbob", "hl1_cl_viewbob", 1},
		{"DNumSlider", "configmenu_bob", "hl1_cl_bob", 0.01, 2, 0, 0.05},
		{"DNumSlider", "bobcycle", "hl1_cl_bobcycle", 0.8, 1, 0.3, 1, hidden = true},
		{"DNumSlider", "bobup", "hl1_cl_bobup", 0.5, 1, 0, 1, hidden = true},
		{"DNumSlider", "configmenu_rollangle", "hl1_cl_rollangle", 2, 0, 0, 5},
		{"DNumSlider", "configmenu_rollspeed", "hl1_cl_rollspeed", 200, 0, 100, 400},
	}
	return settingscvars
end

function GM:PlayerSettingsHUDOptions()
	local hudsettings = {
		{"DCheckBoxLabel", "configmenu_gsrchud", "hl1_coop_cl_disablehud", 0},
		{"DComboBox", "[GSRCHUD] "..LangString("configmenu_theme"), "gsrchud_theme", 0},
		{"DCheckBoxLabel", "[GSRCHUD] "..LangString("configmenu_chaircol"), "hl1_cl_crosshair_gsrchud", 1},
		{"DCheckBoxLabel", "[GSRCHUD] "..LangString("configmenu_dscreen"), "gsrchud_deathcam", 1},
		{"DCheckBoxLabel", "[GSRCHUD] "..LangString("configmenu_skipempty"), "gsrchud_skipempty", 1},
		{"DCheckBoxLabel", "[GSRCHUD] "..LangString("configmenu_loadingscreen"), "gsrchud_loading", 1},
		{"DNumSlider", "[GSRCHUD] "..LangString("configmenu_scale"), "gsrchud_scale", 1, 1, 1, 4},
		{"DNumSlider", "[GSRCHUD] "..LangString("configmenu_alpha"), "gsrchud_alpha", 100, 0, 0, 255},
	}
	return hudsettings
end

function GM:OpenPlayerSettings()
	local settingscvars = hook.Run("PlayerSettingsOptions")
	local hudsettings = hook.Run("PlayerSettingsHUDOptions")
	
	self.Menu.plySettings = vgui.Create("DPanel")
	local plySettings = self.Menu.plySettings
	plySettings:SetSize(math.max(ScrW() / 3, 300), ScrH() / 1.2)
	local plySettingsW, plySettingsH = plySettings:GetSize()
	plySettings:SetPos(ScrW() / 2 - plySettingsW / 2, ScrH() / 2 - plySettingsH / 2)
	plySettings:SetBackgroundColor(menuframeColor)
	plySettings:MakePopup()
	
	local menuTitle = vgui.Create("DLabel", plySettings)
	menuTitle:SetFont("MenuFont")
	menuTitle:SetText(LangString("menu_configuration"))
	menuTitle:SizeToContents()
	menuTitle:SetPos(menuTitleX, menuTitleY)
	menuTitle:SetColor(menuTextCol)
	
	local backgr = vgui.Create("DScrollPanel", plySettings)
	backgr:SetSize(plySettingsW - menuContentGap, plySettingsH / 1.24)
	backgr:SetPos(plySettingsW / 2 - backgr:GetWide() / 2, menuTitle:GetTall() + menuContentGap)
	backgr:SetPaintBackground(true)
	backgr:SetBackgroundColor(menuBackgroundColor)
	
	for k, v in pairs(settingscvars) do
		if !v.hidden then
			local k = vgui.Create(v[1], backgr)
			local text = LangString(v[2])
			if v[1] != "DComboBox" then
				k:SetText(text)
				k:SetConVar(v[3])
				if v[1] == "DNumSlider" then
					k:SetDecimals(v[5])
					k:SetMinMax(v[6], v[7])
				end
			else
				--[[local text = vgui.Create("DLabel", backgr)
				text:SetFont("MenuFontSmall")
				text:SetText(text)
				text:SizeToContents()
				text:Dock(TOP)]]
				k:SetSortItems(false)
				local cvar = GetConVar(v[3])
				if cvar then
					local vName = v.choices[cvar:GetInt()] or ""
					k:SetText(text..": "..vName)
					if v.choices then
						for index, name in ipairs(v.choices) do
							k:AddChoice(name)
						end
					end
					function k:OnSelect(index, value, data)
						cvar:SetInt(index)
					end
					function k:Think()
						local choise = v.choices[cvar:GetInt()]
						if choise then
							self:SetText(text..": "..choise)
						end
					end
				end
			end
			k:Dock(TOP)
			k:DockMargin( 20, 12, 20, 0 )
		end
	end
	if GSRCHUD then
		for k, v in pairs(hudsettings) do
			local text = LangString(v[2])
			local k = vgui.Create(v[1], backgr)
			if v[1] != "DComboBox" then
				k:SetText(text)
				k:SetConVar(v[3])
				if v[1] == "DNumSlider" then
					k:SetDecimals(v[5])
					k:SetMinMax(v[6], v[7])
				end
			else
				k:SetValue(text)
				if v[3] == "gsrchud_theme" then
					for i, theme in pairs(GSRCHUD.theme.all()) do
						k:AddChoice(theme.name)
					end
				end
				function k:OnSelect(index, value, data)
					RunConsoleCommand(v[3], index)
				end
			end
			k:Dock(TOP)
			k:DockMargin( 20, 12, 20, 0 )
		end
	end
	
	local def = vgui.Create("DLabel", plySettings)
	def:SetFont("MenuFont")
	def:SetText(LangString("configmenu_default"))
	def:SizeToContents()
	def:SetPos(plySettingsW / 2 - def:GetWide() / 2, plySettingsH - def:GetTall() - 10)
	def:SetTextColor(menuTextCol)
	def:SetMouseInputEnabled(true)
	function def:DoClick()
		surface.PlaySound(sndMenu3)
		for k, v in pairs(settingscvars) do
			RunConsoleCommand(v[3], v[4])
		end
		if GSRCHUD then
			for k, v in pairs(hudsettings) do
				RunConsoleCommand(v[3], v[4])
			end
		end
	end
	function def:OnCursorEntered()
		surface.PlaySound(sndMenu2)
		self:SetTextColor(menuTextSelected)
	end
	function def:OnCursorExited()
		self:SetTextColor(menuTextCol)
	end
end

function GM:QuitDialog()
	self.Menu.quitMenu = vgui.Create("DPanel")
	local quitMenu = self.Menu.quitMenu
	quitMenu:SetSize(ScrW() / 3, ScrH() / 5)
	local quitMenuW, quitMenuH = quitMenu:GetSize()
	quitMenu:SetPos(ScrW() / 2 - quitMenuW / 2, ScrH() / 2 - quitMenuH / 2)
	quitMenu:SetBackgroundColor(menuframeColor)
	quitMenu:MakePopup()
	
	local text = vgui.Create("DLabel", quitMenu)
	text:SetFont("MenuFont")
	text:SetText(LangString("quit_sure"))
	text:SizeToContents()
	quitMenu:SetSize(text:GetWide() + ScrW() / 24, quitMenuH)
	local quitMenuW, quitMenuH = quitMenu:GetSize()
	quitMenu:SetPos(ScrW() / 2 - quitMenuW / 2, ScrH() / 2 - quitMenuH / 2)
	text:SetPos(quitMenuW / 2 - text:GetWide() / 2, 20)
	--text:SetTextColor(menuTextCol)
	
	local button_yes = vgui.Create("DLabel", quitMenu)
	button_yes:SetFont("MenuFont")
	button_yes:SetText(LangString("yes"))
	button_yes:SizeToContents()
	button_yes:SetPos(quitMenuW / 2 - button_yes:GetWide() - 70, quitMenuH / 1.1 - button_yes:GetTall())
	button_yes:SetTextColor(menuTextCol)
	button_yes:SetMouseInputEnabled(true)
	function button_yes:DoClick()
		RunConsoleCommand("gamemenucommand", "quit")
	end
	function button_yes:OnCursorEntered()
		surface.PlaySound(sndMenu2)
		self:SetTextColor(menuTextSelected)
	end
	function button_yes:OnCursorExited()
		self:SetTextColor(menuTextCol)
	end
	
	local button_no = vgui.Create("DLabel", quitMenu)
	button_no:SetFont("MenuFont")
	button_no:SetText(LangString("no"))
	button_no:SizeToContents()
	button_no:SetPos(quitMenuW / 2 + 70, quitMenuH / 1.1 - button_no:GetTall())
	button_no:SetTextColor(menuTextCol)
	button_no:SetMouseInputEnabled(true)
	function button_no:DoClick()
		surface.PlaySound(sndMenu3)
		GAMEMODE:CloseSubMenus()
		GAMEMODE.Menu.MainMenuFrame:Popup()
	end
	function button_no:OnCursorEntered()
		surface.PlaySound(sndMenu2)
		self:SetTextColor(menuTextSelected)
	end
	function button_no:OnCursorExited()
		self:SetTextColor(menuTextCol)
	end
end

local t_selected = Material("gui/contenticon-hovered.png")

function GM:VoteMenu()
	if IsValid(self.Menu.voteMenu) and self.Menu.voteMenu:IsVisible() then
		self.Menu.voteMenu:DoHideAnim()
		return
	end
	
	local votes = hook.Run("VoteMenuOptions")
	local font = "MenuFont"
	surface.SetFont(font)
	local _, fontHeight = surface.GetTextSize("")
	
	self.Menu.voteMenu = vgui.Create("DPanel", self.Menu.MainMenuFrame)
	local voteMenu = self.Menu.voteMenu
	local mainMenuPosX, mainMenuPosY = self.Menu.MainMenuFrame:GetPos()
	local voteOptionCount = #votes
	for k, v in pairs(votes) do
		if v.available and !v.available() then
			voteOptionCount = voteOptionCount - 1
		end
	end
	voteMenu:SetSize(self.Menu.MainMenuFrame:GetWide() - ScrW() / 12, voteOptionCount * (fontHeight + 4) + 40)
	local voteMenuStart = 0
	local voteMenuW, voteMenuH = voteMenu:GetSize()
	local voteMenuY = ScrH() / 3.5 - voteMenuH / 10
	if ScrH() - voteMenuH < 200 then
		voteMenuY = ScrH() / 1.25 - voteMenuH / 1.25
	end
	voteMenu:SetBackgroundColor(menuframeColor)
	voteMenu:MakePopup()
	voteMenu.AnimType = 1
	
	function voteMenu:DoStartAnim()
		self.AnimType = 1
	end
	function voteMenu:DoHideAnim()
		self.AnimType = 2
	end

	for k, v in pairs(votes) do
		if v.available and !v.available() then
			continue
		end
		
		local text = LangString(v[1])
		
		local tw, th = surface.GetTextSize(text)
		tw = tw + 44
		if tw > voteMenuW then
			voteMenuW = tw
		end
		
		local l = vgui.Create("DLabel", voteMenu)
		l:Dock(TOP)
		l:DockMargin(20, 20, 0, -16)
		l:SetTextColor()
		l:SetFont(font)
		l:SetText(text)
		l:SizeToContents()
		l:SetMouseInputEnabled(true)
		function l:OnCursorEntered()
			surface.PlaySound(sndMenu2)
			self:SetTextColor(Color(255,255,255,255))
			
			if v[3] then
				local x, y = self:GetPos()
				local vx, vy = voteMenu:GetPos()
				self.hint = vgui.Create("DLabel", voteMenu)
				self.hint:SetPos(vx + voteMenuW + x, vy + y + 8)
				self.hint:SetTextColor(Color(255,255,230,255))
				self.hint:SetFont("MenuHint")
				self.hint:SetText(v[3])
				self.hint:SizeToContents()
				self.hint:MakePopup()
			end
		end
		function l:OnCursorExited()
			self:SetTextColor()
			
			if IsValid(self.hint) then
				self.hint:Remove()
			end
		end
		function l:DoClick()
			surface.PlaySound(sndMenu3)
			v[2]()
		end
	end
	
	function voteMenu:AnimationThink()
		mainMenuPosX, mainMenuPosY = GAMEMODE.Menu.MainMenuFrame:GetPos()
		self:SetPos(mainMenuPosX + GAMEMODE.Menu.MainMenuFrame:GetWide(), voteMenuY)
	
		local FT = RealFrameTime()
		if self.AnimType == 1 then
			voteMenuStart = Lerp(FT*8, voteMenuStart, voteMenuW)
			self:SetWidth(voteMenuStart)
			if self:GetWide() == voteMenuW - 1 then
				self.AnimType = nil
			end
		elseif self.AnimType == 2 then
			voteMenuStart = Lerp(FT*16, voteMenuStart, 0)
			self:SetWidth(voteMenuStart)
			if self:GetWide() == 0 then
				self:Remove()
			end
		end
	end
end
	
function GM:OpenMapVote()
	self.Menu.voteMenu = vgui.Create("DPanel")
	local mapVoteMenu = self.Menu.voteMenu
	mapVoteMenu:SetSize(ScrW() / 1.5, ScrH() / 1.3)
	local mapVoteMenuW, mapVoteMenuH = mapVoteMenu:GetSize()
	mapVoteMenu:SetPos(ScrW() / 2 - mapVoteMenuW / 2, ScrH() / 2 - mapVoteMenuH / 2)
	mapVoteMenu:SetBackgroundColor(menuframeColor)
	mapVoteMenu:MakePopup()
	
	local menuTitle = vgui.Create("DLabel", mapVoteMenu)
	menuTitle:SetFont("MenuFont")
	menuTitle:SetText(LangString("votemenu_mapvote"))
	menuTitle:SizeToContents()
	menuTitle:SetPos(menuTitleX, menuTitleY)
	menuTitle:SetColor(menuTextCol)
	
	local sheet = vgui.Create("DPropertySheet", mapVoteMenu)
	sheet:SetSize(mapVoteMenuW - menuContentGap*2, mapVoteMenuH / 1.35)
	sheet:SetPos(menuContentGap, menuTitle:GetTall() + menuContentGap)
	local voteMapW, voteMapH = sheet:GetSize()
	local iconSize = voteMapW / 7.725
	local iconSpace = voteMapW / 174
	
	local voteMap
	for k, v in ipairs(Campaigns) do
		voteMap = vgui.Create("DScrollPanel", sheet)
		voteMap:SetPaintBackground(true)
		voteMap:SetBackgroundColor(menuBackgroundColor)
		sheet:AddSheet(v.Title, voteMap, v.Icon)	
		local mapList = vgui.Create("DIconLayout", voteMap)
		mapList:SetSize(voteMapW, voteMapH)
		mapList:SetPos(voteMapW / 44, voteMapW / 44)
		-- mapList:Dock(FILL)
		mapList:SetSpaceY(iconSpace)
		mapList:SetSpaceX(iconSpace)
		
		local availableMaps = {}
		for chapter, map in pairs(v.Maps) do
			if istable(map) then
				for _, mapname in pairs(map) do
					table.insert(availableMaps, mapname)
				end
			else
				table.insert(availableMaps, map)
			end
		end
		table.sort(availableMaps, function(a, b) return a < b end)
		
		for _, map in ipairs(availableMaps) do
			local ListItem = mapList:Add("DImageButton")
			ListItem:SetSize(iconSize, iconSize)
			ListItem:SetImage("maps/thumb/"..map..".png")
			ListItem:SetText(map)
			ListItem.DoClick = function()
				voteMap.SelectedMap = map
			end
			ListItem.PaintOver = function(ListItem, w, h)
				draw.SimpleText(ListItem:GetText(), "default", w / 2, h - 8, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				if voteMap.SelectedMap == map then
					surface.SetDrawColor(255,255,255,255)
					surface.SetMaterial(t_selected)
					surface.DrawTexturedRect(-2, -2, w+4, h+4)
				end
			end
		end
	end
	
	local VmapButton = vgui.Create("DLabel", mapVoteMenu)
	VmapButton:SetFont("MenuFont")
	VmapButton:SetText(LangString("votemenu_mapvote_call"))
	VmapButton:SizeToContents()
	VmapButton:SetPos(mapVoteMenuW / 2 - VmapButton:GetWide() / 2, mapVoteMenuH - VmapButton:GetTall() - 32)
	VmapButton:SetMouseInputEnabled(true)
	function VmapButton:DoClick()
		if voteMap.SelectedMap then
			RunConsoleCommand("hl1_coop_callvote", "map", voteMap.SelectedMap)
			GAMEMODE:CloseMenus()
		end
	end
	function VmapButton:OnCursorEntered()
		surface.PlaySound(sndMenu2)
		self:SetTextColor(Color(255,255,255,255))
	end
	function VmapButton:OnCursorExited()
		self:SetTextColor()
	end
end

function GM:OpenKickVote()
	self.Menu.voteMenu = vgui.Create("DPanel")
	local voteKickMenu = self.Menu.voteMenu
	voteKickMenu:SetSize(ScrW() / 3, ScrH() / 1.3)
	local voteKickMenuW, voteKickMenuH = voteKickMenu:GetSize()
	voteKickMenu:SetPos(ScrW() / 2 - voteKickMenuW / 2, ScrH() / 2 - voteKickMenuH / 2)
	voteKickMenu:SetBackgroundColor(menuframeColor)
	voteKickMenu:MakePopup()
	
	local menuTitle = vgui.Create("DLabel", voteKickMenu)
	menuTitle:SetFont("MenuFont")
	menuTitle:SetText(LangString("votemenu_kick"))
	menuTitle:SizeToContents()
	menuTitle:SetPos(menuTitleX, menuTitleY)
	menuTitle:SetColor(menuTextCol)

	local players = player.GetAll()
	
	local voteKick = vgui.Create("DPanel", voteKickMenu)
	local voteKickX, voteKickY = menuContentGap, menuTitle:GetTall() + menuContentGap
	voteKick:SetPos(voteKickX, voteKickY)
	voteKick:SetSize(voteKickMenuW - voteKickX*2, voteKickMenuH - voteKickY - 100)
	voteKick:SetBackgroundColor(menuBackgroundColor)
	
	local plyList = vgui.Create("DScrollPanel", voteKick)
	plyList:SetPos(25, 25)
	plyList:SetSize(voteKick:GetWide() - 50, voteKick:GetTall() - 50)
	
	local ppos = 0
	for k, ply in pairs(players) do
		k = vgui.Create("DLabel", plyList)
		k:SetPos(0, ppos)
		ppos = ppos + 30
		k:SetFont("DermaLarge")
		k:SetText(ply:Nick())
		//k:SetTextColor(v.col)
		k:SizeToContents()
		k:SetMouseInputEnabled(true)
		function k:DoClick()
			plyList.SelectedPlayer = ply
		end
		k.PaintOver = function(k, w, h)
			if plyList.SelectedPlayer == ply then
				surface.SetDrawColor(255,255,255,255)
				surface.SetMaterial(t_selected)
				surface.DrawTexturedRect(0, 0, w, h)
			end
		end
	end
	
	local kickButton = vgui.Create("DLabel", voteKickMenu)
	kickButton:SetFont("MenuFont")
	kickButton:SetText(LangString("votemenu_kick_call"))
	kickButton:SizeToContents()
	kickButton:SetPos(voteKickMenu:GetWide() / 2 - kickButton:GetWide() / 2, voteKickMenu:GetTall() - kickButton:GetTall() - 32)
	kickButton:SetMouseInputEnabled(true)
	function kickButton:DoClick()
		if plyList.SelectedPlayer and IsValid(plyList.SelectedPlayer) then
			RunConsoleCommand("hl1_coop_callvote", "kick", plyList.SelectedPlayer:Nick())
			GAMEMODE:CloseMenus()
		end
	end
	function kickButton:OnCursorEntered()
		surface.PlaySound(sndMenu2)
		self:SetTextColor(Color(255,255,255,255))
	end
	function kickButton:OnCursorExited()
		self:SetTextColor()
	end
end

function GM:OpenBanVote()
	self.Menu.voteMenu = vgui.Create("DPanel")
	local voteKickMenu = self.Menu.voteMenu
	voteKickMenu:SetSize(ScrW() / 2.5, ScrH() / 1.75)
	local voteKickMenuW, voteKickMenuH = voteKickMenu:GetSize()
	voteKickMenu:SetPos(ScrW() / 2 - voteKickMenuW / 2, ScrH() / 2 - voteKickMenuH / 2)
	voteKickMenu:SetBackgroundColor(menuframeColor)
	voteKickMenu:MakePopup()
	
	local menuTitle = vgui.Create("DLabel", voteKickMenu)
	menuTitle:SetFont("MenuFont")
	menuTitle:SetText(LangString("votemenu_ban"))
	menuTitle:SizeToContents()
	menuTitle:SetPos(menuTitleX, menuTitleY)
	menuTitle:SetColor(menuTextCol)

	local players = player.GetAll()
	
	local voteKick = vgui.Create("DPanel", voteKickMenu)
	local voteKickX, voteKickY = menuContentGap, menuTitle:GetTall() + menuContentGap
	voteKick:SetPos(voteKickX, voteKickY)
	voteKick:SetSize(voteKickMenuW / 2, voteKickMenuH - voteKickY - menuContentGap)
	voteKick:SetBackgroundColor(menuBackgroundColor)
	
	local plyList = vgui.Create("DScrollPanel", voteKick)
	plyList:SetPos(25, 25)
	plyList:SetSize(voteKick:GetWide() - 50, voteKick:GetTall() - 50)
	
	local ppos = 0
	for k, ply in pairs(players) do
		k = vgui.Create("DLabel", plyList)
		k:SetPos(0, ppos)
		ppos = ppos + 30
		k:SetFont("DermaLarge")
		k:SetText(ply:Nick())
		//k:SetTextColor(v.col)
		k:SizeToContents()
		k:SetMouseInputEnabled(true)
		function k:DoClick()
			plyList.SelectedPlayer = ply
		end
		k.PaintOver = function(k, w, h)
			if plyList.SelectedPlayer == ply then
				surface.SetDrawColor(255,255,255,255)
				surface.SetMaterial(t_selected)
				surface.DrawTexturedRect(0, 0, w, h)
			end
		end
	end
	
	local banOptions = {
		["5 minutes"] = 5,
		["15 minutes"] = 15,
		["30 minutes"] = 30
	}
	local pos = 0
	for k, v in pairs(banOptions) do
		local banButton = vgui.Create("DLabel", voteKickMenu)
		banButton:SetFont("MenuFontSmall")
		banButton:SetText("Ban for\n"..k)
		banButton:SizeToContents()
		banButton:SetPos(plyList:GetWide() * 1.5, banButton:GetTall() + 32 + pos)
		banButton:SetMouseInputEnabled(true)
		function banButton:DoClick()
			if plyList.SelectedPlayer and IsValid(plyList.SelectedPlayer) then
				RunConsoleCommand("hl1_coop_callvote", "ban", plyList.SelectedPlayer:UserID(), v)
				GAMEMODE:CloseMenus()
			end
		end
		pos = pos + voteKickMenuH / 5
		function banButton:OnCursorEntered()
			surface.PlaySound(sndMenu2)
			self:SetTextColor(menuTextSelected)
		end
		function banButton:OnCursorExited()
			self:SetTextColor()
		end
		function banButton:Paint(w,h)
			surface.SetDrawColor(100, 100, 100, 180)
			surface.DrawRect(0, 0, w, h)
		end
	end
end

function GM:ModelSelectionMenu()
	local ply = LocalPlayer()
	
	ply:SetupPlayerColor() -- reset color preview
	
	if IsValid(self.plyModelMenu) and self.plyModelMenu:IsVisible() then
		self:SetPlayerModelView(false)
		self.plyModelMenu:Remove()
		return
	end

	if ply.PreviewModel then
		ply.PreviewModel = nil
	end
	if ply.PreviewModelSkin then
		ply.PreviewModelSkin = nil
	end
	if ply.PreviewModelBodygroups then
		ply.PreviewModelBodygroups = nil
	end
	
	self:SetPlayerModelView(true)
	self.plyModelMenu = vgui.Create("DPanel")
	local plyModel = self.plyModelMenu
	plyModel:SetSize(ScrW() / 2, ScrH() / 1.3)
	local plyModelW, plyModelH = plyModel:GetSize()
	local x, y = ScrW() / 1.4 - plyModelW / 2, ScrH() / 2 - plyModelH / 2
	plyModel:SetPos(ScrW(), y)
	plyModel:MoveTo(x, y, 1)
	plyModel:SetBackgroundColor(menuframeColor)
	plyModel:MakePopup()
	
	local menuTitle = vgui.Create("DLabel", plyModel)
	menuTitle:SetFont("MenuFont")
	menuTitle:SetText(LangString("menu_playermodel"))
	menuTitle:SizeToContents()
	menuTitle:SetPos(menuTitleX, menuTitleY)
	menuTitle:SetColor(menuTextCol)
	
	local sheet = vgui.Create("DPropertySheet", plyModel)
	sheet:SetSize(plyModelW - menuContentGap, plyModelH / 1.4)
	sheet:SetPos(plyModelW / 2 - sheet:GetWide() / 2, menuTitle:GetTall() + 40)
	
	local backgr = vgui.Create("DScrollPanel", sheet)
	--backgr:SetSize(plyModelW - 20, plyModelH - 170)
	--backgr:SetPos(plyModelW / 2 - backgr:GetWide() / 2, menuTitle:GetTall() + 40)
	backgr:SetPaintBackground(true)
	backgr:SetBackgroundColor(menuBackgroundColor)
	sheet:AddSheet("Model", backgr, "icon16/status_online.png")
	
	local properties_table
	local function CreatePropertiesTab(model)
		if properties_table then
			sheet:CloseTab(properties_table.Tab, true)
			ply.PreviewModelSkin = nil
			ply.PreviewModelBodygroups = nil
			properties_table = nil
		end
		if model then
			ply:SetModel(model) -- doing this for just one frame to get bodygroups
			local bodygroups = ply:GetBodyGroups()
			local skinCount = ply:SkinCount()
			-- PrintTable(bodygroups)
			if skinCount > 1 or #bodygroups > 1 then
				local properties = vgui.Create("DPanel", sheet)
				properties:SetBackgroundColor(Color(50, 50, 50, 150))
				properties_table = sheet:AddSheet("Properties", properties, "icon16/cog.png")
				-- function sheet:OnActiveTabChanged(old, new)
					-- print(new == properties_table.Tab)
				-- end
				if skinCount > 1 then
					local skin = vgui.Create("DNumSlider", properties)
					skin:SetText("Skin")
					skin:SetDecimals(0)
					skin:SetMinMax(0, skinCount - 1)
					skin:SetValue(cvars.Number("hl1_coop_cl_playermodel_skin"))
					skin:Dock(TOP)
					skin:DockMargin( 40, 16, 20, 0 )
					function skin:OnValueChanged(val)
						ply.PreviewModelSkin = math.Round(val)
					end
				end
				if #bodygroups > 1 then
					ply.PreviewModelBodygroups = {}
					for k, v in ipairs(bodygroups) do
						local curVal = ply:GetBodygroup(v.id)
						ply.PreviewModelBodygroups[v.id] = curVal
						if v.num > 1 then
							local bodygr = vgui.Create("DNumSlider", properties)
							bodygr:SetText(v.name)
							bodygr:SetDecimals(0)
							bodygr:SetMinMax(0, v.num - 1)
							bodygr:SetValue(curVal)
							bodygr:Dock(TOP)
							bodygr:DockMargin( 40, 16, 20, 0 )
							function bodygr:OnValueChanged(val)
								ply.PreviewModelBodygroups[v.id] = math.Round(val)
							end
						end
					end
				end
			end
		end
	end
	
	local List = vgui.Create("DIconLayout", backgr)
	List:Dock(FILL)
	List:SetSpaceY(5)
	List:SetSpaceX(5)

	for name, model in SortedPairs(player_manager.AllValidModels()) do
		local mpanel = List:Add("DPanel") 
		mpanel:SetSize(64, 64)
		mpanel:SetBackgroundColor(Color(160, 90, 0, 150))
		local mdl = vgui.Create("SpawnIcon", mpanel)
		mdl:Dock( FILL )
		mdl:SetModel(model)
		function mdl:DoClick()
			surface.PlaySound(sndMenu2)
			ply.PreviewModel = model
			CreatePropertiesTab(model)
		end
	end
	
	local col = vgui.Create("DPanel", sheet)
	sheet:AddSheet("Color", col, "icon16/color_wheel.png")
	
	local colMixer = vgui.Create("DColorMixer", col)
	/*local colW, colH = sheet:GetSize()
	colMixer:SetSize(colW / 1.5, colH / 2)
	local colMixW, colMixH = colMixer:GetSize()
	colMixer:SetPos(colW / 2 - colMixW / 2, colH / 2 + colMixH)*/
	colMixer:Dock(FILL)
	colMixer:SetPalette(true)
	colMixer:SetAlphaBar(false)
	colMixer:SetWangs(true)
	local defCol = ply:GetPlayerColor() * 255
	colMixer:SetColor(Color(defCol[1], defCol[2], defCol[3]))
	local plyColorValues
	function colMixer:ValueChanged(col)
		plyColorValues = col
		ply:SetPlayerColor(Vector(col.r / 255, col.g / 255, col.b / 255))
	end
	
	CreatePropertiesTab(ply:GetModel())
	
	local button_gap = plyModelW / 5
	
	local applyb = vgui.Create("DLabel", plyModel)
	applyb:SetFont("MenuFont")
	applyb:SetText(LangString("menu_apply"))
	applyb:SizeToContents()
	applyb:SetPos(plyModelW / 2 - applyb:GetWide() / 2 - button_gap, plyModelH - applyb:GetTall() - 10)
	applyb:SetTextColor(menuTextCol)
	applyb:SetMouseInputEnabled(true)
	function applyb:DoClick()
		surface.PlaySound(sndMenu3)
		local model = ply.PreviewModel
		local skin = ply.PreviewModelSkin
		local bodygroups = ply.PreviewModelBodygroups
		if model then
			local convar_mdl = GetConVar("hl1_coop_cl_playermodel")
			convar_mdl:SetString(player_manager.TranslateToPlayerModelName(model))
			net.Start("SetPlayerModel")
			net.WriteString(model)
			net.SendToServer()
			hook.Run("ApplyViewModelHands", ply, nil, true)
		end
		if plyColorValues then
			local convar_col = GetConVar("hl1_coop_cl_playercolor")
			local str = string.format("%s %s %s", plyColorValues.r, plyColorValues.g, plyColorValues.b)
			convar_col:SetString(str)
			net.Start("SetPlayerModelColor")
			net.WriteString(str)
			net.SendToServer()
		end
		if skin then
			local convar_skin = GetConVar("hl1_coop_cl_playermodel_skin")
			convar_skin:SetInt(skin)
			net.Start("SetPlayerModelSkin")
			net.WriteUInt(skin, 5)
			net.SendToServer()
		end
		if bodygroups then
			local convar_bodygroups = GetConVar("hl1_coop_cl_playermodel_bodygroups")
			local str = ""
			for k, v in pairs(bodygroups) do
				str = str..v
			end
			convar_bodygroups:SetString(str)
			net.Start("SetPlayerModelBodygroups")
			net.WriteString(str)
			net.SendToServer()
		end
		GAMEMODE:ModelSelectionMenu()
	end
	function applyb:OnCursorEntered()
		surface.PlaySound(sndMenu2)
		self:SetTextColor(menuTextSelected)
	end
	function applyb:OnCursorExited()
		self:SetTextColor(menuTextCol)
	end
	
	local closeb = vgui.Create("DLabel", plyModel)
	closeb:SetFont("MenuFont")
	closeb:SetText(LangString("menu_cancel"))
	closeb:SizeToContents()
	closeb:SetPos(plyModelW / 2 - closeb:GetWide() / 2 + button_gap, plyModelH - closeb:GetTall() - 10)
	closeb:SetTextColor(menuTextCol)
	closeb:SetMouseInputEnabled(true)
	function closeb:DoClick()
		surface.PlaySound(sndMenu3)
		GAMEMODE:ModelSelectionMenu()
	end
	function closeb:OnCursorEntered()
		surface.PlaySound(sndMenu2)
		self:SetTextColor(menuTextSelected)
	end
	function closeb:OnCursorExited()
		self:SetTextColor(menuTextCol)
	end
end

local function RunServerCommand(cvar, args)
	if !CanPlayerUseRestrictedSettings(LocalPlayer()) then return end
	net.Start("RunServerCommand")
	net.WriteString(cvar)
	if args then
		net.WriteString(args)
	end
	net.SendToServer()
end

function GM:OpenServerSettings()
	if !CanPlayerUseRestrictedSettings(LocalPlayer()) then return end
	self.Menu.adminSettings = vgui.Create("DPanel")
	local plySettings = self.Menu.adminSettings
	plySettings:SetSize(math.max(ScrW() / 3, 400), ScrH() / 1.65 + 200)
	local plySettingsW, plySettingsH = plySettings:GetSize()
	plySettings:SetPos(ScrW() / 2 - plySettingsW / 2, ScrH() / 2 - plySettingsH / 2)
	plySettings:SetBackgroundColor(menuframeColor)
	plySettings:MakePopup()
	
	local menuTitle = vgui.Create("DLabel", plySettings)
	menuTitle:SetFont("MenuFont")
	menuTitle:SetText("Admin menu")
	menuTitle:SizeToContents()
	menuTitle:SetPos(menuTitleX, menuTitleY)
	menuTitle:SetColor(menuTextCol)
	
	local backgr = vgui.Create("DScrollPanel", plySettings)
	backgr:SetSize(plySettingsW - menuContentGap, plySettingsH / 1.24)
	backgr:SetPos(plySettingsW / 2 - backgr:GetWide() / 2, menuTitle:GetTall() + menuContentGap)
	backgr:SetPaintBackground(true)
	backgr:SetBackgroundColor(menuBackgroundColor)
	
	local adminsettingscvars = hook.Run("AdminSettingsTable")
	
	for k, v in pairs(adminsettingscvars) do
		local k = vgui.Create(v[1], backgr)
		k:SetText(LangString(v[2]))
		if v[1] == "DNumSlider" then
			k:SetDecimals(v[5])
			k:SetMinMax(v[6], v[7])
			k:SetValue(GAMEMODE:GetSkillLevel())
			function k:OnValueChanged(value)
				RunServerCommand(v[3], math.Round(value))
			end
		elseif v[1] == "DButton" then
			function k:DoClick()
				GAMEMODE:CloseMenus()
				RunConsoleCommand(v[3])
			end
		else
			k:SetMouseInputEnabled(true)
			local bDisable = vgui.Create("DButton", k)
			bDisable:SetText(LangString("adminmenu_off"))
			bDisable:Dock(RIGHT)
			function bDisable:DoClick()
				RunServerCommand(v[3], "0")
				if v.func then
					v.func()
				end
			end
			local bEnable = vgui.Create("DButton", k)
			bEnable:SetText(LangString("adminmenu_on"))
			bEnable:Dock(RIGHT)
			function bEnable:DoClick()
				RunServerCommand(v[3], "1")
				if v.func then
					v.func()
				end
			end
		end
		k:Dock(TOP)
		k:DockMargin(20, 12, 20, 0)
	end
	
	local def = vgui.Create("DLabel", plySettings)
	def:SetFont("MenuFont")
	def:SetText(LangString("adminmenu_defaultall"))
	def:SizeToContents()
	def:SetPos(plySettingsW / 2 - def:GetWide() / 2, plySettingsH - def:GetTall() - 10)
	def:SetTextColor(menuTextCol)
	def:SetMouseInputEnabled(true)
	function def:DoClick()
		surface.PlaySound(sndMenu3)
		for k, v in pairs(adminsettingscvars) do
			if v[1] != "DButton" and v[4] then
				RunServerCommand(v[3], v[4])
			end
		end
	end
	function def:OnCursorEntered()
		surface.PlaySound(sndMenu2)
		self:SetTextColor(menuTextSelected)
	end
	function def:OnCursorExited()
		self:SetTextColor(menuTextCol)
	end
end

function GM:CloseMenus()
	if game.SinglePlayer() and self.Menu.MainMenuFrame and self.Menu.MainMenuFrame:IsVisible() then
		RunConsoleCommand("unpause")
	end
	for k, v in pairs(self.Menu) do
		if IsValid(v) then
			v:Remove()
		end
	end
end

function GM:CloseSubMenus()
	for k, v in pairs(self.Menu) do
		if IsValid(v) and v != self.Menu.MainMenuFrame then
			v:Remove()
		end
	end
end

function GM:PreRender()
	if gui.IsGameUIVisible() then
		if self.Menu.MainMenuFrame and self.Menu.MainMenuFrame:IsVisible() then
			self:CloseMenus()
		end
		if input.IsKeyDown(KEY_ESCAPE) then
			gui.HideGameUI()
			self:OpenMainMenu()
			return true
		end
	end
end