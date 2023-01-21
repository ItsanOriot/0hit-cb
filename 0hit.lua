--[locals n shit]--
local UserInputService = game:GetService("UserInputService")
local lp = game:GetService('Players').LocalPlayer
local chr = game.Players.LocalPlayer.Character
local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
local coreGui = game:GetService("CoreGui")
local runService = game:GetService("RunService")
local mouse = lp:GetMouse()
local client = getsenv(lp.PlayerGui:WaitForChild("Client"))
local RunService = game:GetService("RunService")

--movement variables
local bhop = false
local bhopSpeed = 50
local fly = false
local flySpeed = 50
local walk = false
local walkSpeed = 16

--misc variables
local idealtick = false
local idealtickLocation;
local className = "Part"
local parent = game.Workspace
local part = Instance.new(className, parent)
part.Size = Vector3.new(0, 3, 3)
part.Anchored = true
part.CanCollide = false
part.Shape = Enum.PartType.Cylinder
part.Material = Enum.Material.Neon
part.Color = Color3.new(1, 0, 0)
part.Transparency = 1

--visuals variables
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
ESP.Enabled = false
ESP.TeamColor = false
ESP.TeamMates = false
ESP.Tracers = false
ESP.Boxes = false
ESP.Size = 11
ESP.Color = Color3.fromRGB(255,255,255)
ESP.Names = false
local visibleChams = false
local chamsColorVisible = Color3.fromRGB(0, 255, 0)
local chamsTransparencyVisible = 1
local invisibleChams = false
local chamsColorInvisible = Color3.fromRGB(0, 0, 0)
local chamsTransparencyInvisible = 1
local thirdPersonDistance = 15
local thirdperson = false
local tintR, tintG, tintB = 1,1,1
local fov = 75;


-- viewport shit
local viewportGui = Instance.new("ScreenGui", coreGui)
viewportGui.IgnoreGuiInset = true
local viewportFrame = Instance.new("ViewportFrame")
viewportFrame.Parent = viewportGui
viewportFrame.CurrentCamera = workspace.CurrentCamera
viewportFrame.BackgroundTransparency = 1
viewportFrame.Size = UDim2.new(1, 0, 1, 0)
viewportFrame.Position = UDim2.new(0, 0, 0, 0)

--rage and combat variables
local antiAim = false
local aaX = 0
local aay = 0
local aaz = 0
local rageMain = false
local autoShoot = false
local killAll = false
local dt = false
local rapidFire = false
local noSpread = false
local instantReload = false
local noRecoil = false

local controlturn = game:GetService("ReplicatedStorage").Events:FindFirstChild("ControlTurn")
local anim = Instance.new("Animation", workspace)
anim.AnimationId = "rbxassetid://0"

loadstring(game:HttpGet('https://raw.githubusercontent.com/ItsanOriot/lolounge-ui-lib/main/library.lua'))()

-- [Rage Tab UI] ------------------------------------------------------------------------------------------------------------------------------------------------------------
local RageTab = library:AddTab("Rage"); 
local RageColunm1 = RageTab:AddColumn();
local RageColunm2 = RageTab:AddColumn();
local RageMain = RageColunm1:AddSection("Ragebot")
local RageSecondary = RageColunm2:AddSection("Exploits")

RageMain:AddDivider("Ragebot");
RageMain:AddToggle{text = "Enabled", skipflag = true, callback = function(v)
	rageMain = v
end}
RageMain:AddToggle{text = "Autoshoot", skipflag = true, callback = function(v)
	autoShoot = v
end}
RageMain:AddDivider("Anti Aim");
RageMain:AddToggle{text = "Enabled", skipflag = true, callback = function(v)
	antiAim = v
end}
RageMain:AddSlider{text = "Anti Aim X", skipflag = true, min = -50, max = 50, value = 0, callback = function(v)
	aaX = v
end}
RageMain:AddSlider{text = "Anti Aim Y", skipflag = true, min = -50, max = 50, value = 0, callback = function(v)
	aaY = v
end}
RageMain:AddSlider{text = "Anti Aim Z", skipflag = true, min = -50, max = 50, value = 0, callback = function(v)
	aaZ = v
end}

RageSecondary:AddBind({text = "Idealtick Autopeek", skipflag = true, nomouse = true, key = "v", callback = function(v)
	idealtick = not idealtick
	if idealtick then
		idealtickLocation = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
		part.CFrame = game.Players.LocalPlayer.Character.LeftFoot.CFrame
		part.Rotation = Vector3.new(0, 0, 90)
		part.Transparency = 0.5
	else
		part.Transparency = 1
	end
end});
RageSecondary:AddToggle{text = "Kill All", skipflag = true, callback = function(v)
	killAll = v
end}

RageSecondary:AddToggle{text = "Doubletap", skipflag = true, callback = function(v)
	dt = v
end}

RageSecondary:AddToggle{text = "Rapid Fire", skipflag = true, callback = function(v)
	rapidFire = v;
	if v then
		for _, wep in next, game:GetService("ReplicatedStorage").Weapons:GetChildren() do
			if wep:FindFirstChild("Auto") then
				wep:FindFirstChild("Auto").Value = true
			end
		end
	else
		for _, wep in next, game:GetService("ReplicatedStorage").Weapons:GetChildren() do
			if wep:FindFirstChild("Auto") then
				wep:FindFirstChild("Auto").Value = false
			end
		end
	end
end}

RageSecondary:AddToggle{text = "Infinite Ammo", skipflag = true, callback = function(v)
	for _, wep in next, game:GetService("ReplicatedStorage").Weapons:GetChildren() do
		if wep:FindFirstChild("Ammo") and wep:FindFirstChild("StoredAmmo") then
			wep:FindFirstChild("Ammo").Value = 999999
			wep:FindFirstChild("StoredAmmo").Value = 999999
		end
	end
end}

RageSecondary:AddToggle{text = "No Spread", skipflag = true, callback = function(v)
	noSpread = v
end}

RageSecondary:AddToggle{text = "No Recoil", skipflag = true, callback = function(v)
	if v then
		RunService:BindToRenderStep("NoRecoil", 100, function()
			client.resetaccuracy()
			client.RecoilX = 0
			client.RecoilY = 0
		end)
	else
		RunService:UnbindFromRenderStep("NoRecoil")
	end
end}

RageSecondary:AddToggle{text = "Instant Reload", skipflag = true, callback = function(v)
	instantReload = v;
end}

-- [Visuals Tab UI] ------------------------------------------------------------------------------------------------------------------------------------------------------------
local VisualsTab = library:AddTab("Visuals"); 
local VisualsColunm1 = VisualsTab:AddColumn();
local VisualsMain = VisualsColunm1:AddSection("Esp")

VisualsMain:AddDivider("Main");
VisualsMain:AddToggle{text = "Enabled", skipflag = true, callback = function(v)
	ESP:Toggle(v)
end}:AddColor({text = "Esp Color", skipflag = true, color = Color3.new(255,255,255), callback = function(color)
	ESP.Color = color
end})
VisualsMain:AddToggle{text = "Boxes", skipflag = true, callback = function(v)
	ESP.Boxes = v
end}
VisualsMain:AddToggle{text = "Tracers", skipflag = true, callback = function(v)
	ESP.Tracers = v
end}
VisualsMain:AddToggle{text = "Names", skipflag = true, callback = function(v)
	ESP.Names = v
end}
VisualsMain:AddToggle{text = "Teammate esp", skipflag = true, callback = function(v)
	ESP.TeamMates = v
end}
VisualsMain:AddToggle{text = "Team color", skipflag = true, callback = function(v)
	ESP.TeamColor = v
end}
VisualsMain:AddToggle{text = "Visible Chams", skipflag = true, callback = function(v)
	visibleChams = v
	print("chams toggled")
	if visibleChams then
		addChams()
		print("chams added")
	else
		
	end
end}:AddColor({text = "Visible Chams Color", skipflag = true, color = Color3.new(255,255,255), callback = function(color)
	chamsColorVisible = color
end})
VisualsMain:AddSlider{text = "Visible Chams Transparency", skipflag = true, min = 0, max = 100, value = 100, callback = function(v)
	chamsTransparencyVisible = v/100
end}

VisualsMain:AddToggle{text = "Wall Chams", skipflag = true, callback = function(v)
	invisibleChams = v
	print("chams toggled")
	if invisibleChams then
		addChams()
		print("chams added")
	else
		
	end
end}:AddColor({text = "Wall Chams Color", skipflag = true, color = Color3.new(255,255,255), callback = function(color)
	chamsColorInvisible = color
end})
VisualsMain:AddSlider{text = "Wall Chams Transparency", skipflag = true, min = 0, max = 100, value = 100, callback = function(v)
	chamsTransparencyInvisible = v/100
end}




local VisualsColunm2 = VisualsTab:AddColumn();
local VisualsSecond = VisualsColunm2:AddSection("Misc Visuals")

VisualsSecond:AddDivider("World Visuals");
VisualsSecond:AddToggle{text = "World Tint", skipflag = true, callback = function(v)
	if v then
		game:GetService("Workspace").Camera.ColorCorrection.TintColor = Color3.new(tintR,tintG,tintB)
	else
		game:GetService("Workspace").Camera.ColorCorrection.TintColor = Color3.new(1,1,1)
	end
end}
VisualsSecond:AddSlider{text = "Tint Red", skipflag = true, min = 0, max = 100, value = 10, callback = function(v)
	tintR = v/10
	game:GetService("Workspace").Camera.ColorCorrection.TintColor = Color3.new(tintR,tintG,tintB)
end}
VisualsSecond:AddSlider{text = "Tint Green", skipflag = true, min = 0, max = 100, value = 10, callback = function(v)
	tintG = v/10
	game:GetService("Workspace").Camera.ColorCorrection.TintColor = Color3.new(tintR,tintG,tintB)
end}
VisualsSecond:AddSlider{text = "Tint Blue", skipflag = true, min = 0, max = 100, value = 10, callback = function(v)
	tintB = v/10
	game:GetService("Workspace").Camera.ColorCorrection.TintColor = Color3.new(tintR,tintG,tintB)
end}



VisualsSecond:AddDivider("View");
VisualsSecond:AddSlider{text = "Field of View", skipflag = true, min = 1, max = 120, value = 75, callback = function(v)
	 fov = v
end}

VisualsSecond:AddBind({text = "Third Person", skipflag = true, nomouse = true, key = "Pageup", callback = function(v)
	thirdperson = v
	game.Players.LocalPlayer.CameraMaxZoomDistance = 0
	game.Players.LocalPlayer.CameraMinZoomDistance = 0
end});
VisualsSecond:AddSlider{text = "Third Person Distance", skipflag = true, min = 0, max = 30, value = 1, callback = function(v)
	thirdPersonDistance = v
end}

VisualsSecond:AddDivider("Removals");
VisualsSecond:AddToggle{text = "Remove Flash", skipflag = true, callback = function(v)
	if v then
		lp.PlayerGui.Blnd.Blind.Visible = false
	else
		lp.PlayerGui.Blnd.Blind.Visible = true
	end
end}


-- [Misc Tab] ----------------------------------------------------------------------------------------------------------------------------------------------------------------
local MiscTab = library:AddTab("Misc"); 
local MiscColunm1 = MiscTab:AddColumn();
local MiscColunm2 = MiscTab:AddColumn();
local MiscMain = MiscColunm1:AddSection("Movement")
local MiscSecond = MiscColunm2:AddSection("Exploits")

MiscMain:AddToggle{text = "Bunnyhop", skipflag = true, callback = function(v)
	bhop = v
end};
MiscMain:AddSlider{text = "Bunnyhop Speed", skipflag = true, min = 0, max = 100, value = 50, callback = function(v)
	bhopSpeed = v
end}

MiscMain:AddToggle{text = "Fly", skipflag = true, callback = function(v)
	fly = v
end};
MiscMain:AddSlider{text = "Fly Speed", skipflag = true, min = 0, max = 100, value = 50, callback = function(v)
	flySpeed = v
end}
MiscMain:AddToggle{text = "Speedhack", skipflag = true, callback = function(v)
	walk = v
end};
MiscMain:AddSlider{text = "Walkspeed", flag = "UI Toggle", min = 0, max = 100, value = 50, callback = function(v)
	walkSpeed = v
end}
MiscMain:AddToggle{text = "No Crouch Cooldown", skipflag = true, callback = function(v)
	if v then
		RunService:BindToRenderStep("crouchCD", 100, function()
			client.crouchcooldown = 0
		end)
	else
		RunService:UnbindFromRenderStep("crouchCD")
	end
end};


-- [Library Settings UI] -----------------------------------------------------------------------------------------------------------------------------------------------------
local SettingsTab = library:AddTab("Settings"); 
local SettingsColumn = SettingsTab:AddColumn(); 
local SettingsColumn2 = SettingsTab:AddColumn(); 
local SettingSection = SettingsColumn:AddSection("Menu"); 
local ConfigSection = SettingsColumn2:AddSection("Configs");
local Warning = library:AddWarning({type = "confirm"});

SettingSection:AddBind({text = "Open / Close", flag = "UI Toggle", nomouse = true, key = "Pageup", callback = function()
    library:Close();
end});

SettingSection:AddColor({text = "Accent Color", flag = "Menu Accent Color", color = Color3.new(0.599623620510101318359375, 0.447115242481231689453125, 0.97174417972564697265625), callback = function(color)
    if library.currentTab then
        library.currentTab.button.TextColor3 = color;
    end
    for i,v in pairs(library.theme) do
        v[(v.ClassName == "TextLabel" and "TextColor3") or (v.ClassName == "ImageLabel" and "ImageColor3") or "BackgroundColor3"] = color;
    end
end});

-- [Background List]
local backgroundlist = {
    Floral = "rbxassetid://5553946656",
    Flowers = "rbxassetid://6071575925",
    Circles = "rbxassetid://6071579801",
    Hearts = "rbxassetid://6073763717"
};

-- [Background List]
local back = SettingSection:AddList({text = "Background", max = 4, flag = "background", values = {"Floral", "Flowers", "Circles", "Hearts"}, value = "Floral", callback = function(v)
    if library.main then
        library.main.Image = backgroundlist[v];
    end
end});

-- [Background Color Picker]
back:AddColor({flag = "backgroundcolor", color = Color3.new(), callback = function(color)
    if library.main then
        library.main.ImageColor3 = color;
    end
end, trans = 1, calltrans = function(trans)
    if library.main then
        library.main.ImageTransparency = 1 - trans;
    end
end});

-- [Tile Size Slider]
SettingSection:AddSlider({text = "Tile Size", min = 50, max = 500, value = 50, callback = function(size)
    if library.main then
        library.main.TileSize = UDim2.new(0, size, 0, size);
    end
end});

-- [Discord Button]
SettingSection:AddButton({text = "Copy Discord Invite", callback = function()
	setclipboard("https://discord.gg/gnD5TJKXQt")
end});

-- [Config Box]
ConfigSection:AddBox({text = "Config Name", skipflag = true});

-- [Config List]
ConfigSection:AddList({text = "Configs", skipflag = true, value = "", flag = "Config List", values = library:GetConfigs()});

-- [Create Button]
ConfigSection:AddButton({text = "Create", callback = function()
    library:GetConfigs();
    writefile(library.foldername .. "/" .. library.flags["Config Name"] .. library.fileext, "{}");
    library.options["Config List"]:AddValue(library.flags["Config Name"]);
end});

-- [Save Button]
ConfigSection:AddButton({text = "Save", callback = function()
    local r, g, b = library.round(library.flags["Menu Accent Color"]);
    Warning.text = "Are you sure you want to save the current settings to config <font color='rgb(" .. r .. "," .. g .. "," .. b .. ")'>" .. library.flags["Config List"] .. "</font>?";
    if Warning:Show() then
        library:SaveConfig(library.flags["Config List"]);
    end
end});

-- [Load Button]
ConfigSection:AddButton({text = "Load", callback = function()
    local r, g, b = library.round(library.flags["Menu Accent Color"]);
    Warning.text = "Are you sure you want to load config <font color='rgb(" .. r .. "," .. g .. "," .. b .. ")'>" .. library.flags["Config List"] .. "</font>?";
    if Warning:Show() then
        library:LoadConfig(library.flags["Config List"]);
    end
end});

-- [Delete Button]
ConfigSection:AddButton({text = "Delete", callback = function()
    local r, g, b = library.round(library.flags["Menu Accent Color"]);
    Warning.text = "Are you sure you want to delete config <font color='rgb(" .. r .. "," .. g .. "," .. b .. ")'>" .. library.flags["Config List"] .. "</font>?";
    if Warning:Show() then
        local config = library.flags["Config List"];
        if table.find(library:GetConfigs(), config) and isfile(library.foldername .. "/" .. config .. library.fileext) then
            library.options["Config List"]:RemoveValue(config);
            delfile(library.foldername .. "/" .. config .. library.fileext);
        end
    end
end});
--[Loops n functions]--

--kill all loop
game:GetService("RunService").RenderStepped:Connect(function()
	if killAll then
		for _, plr in next, game:GetService("Players"):GetChildren() do
			if plr.Team ~= lp.Team then
				local args = {
					[1] = v.Character.Head,
					[2] = v.Character.Head.Position,
					[3] = "AWP",
					[4] = 100,
					[5] = lp.Character.Gun,
					[8] = 100,
					[9] = false,
					[10] = false,
					[11] = Vector3.new(),
					[12] = 100,
					[13] = Vector3.new()
				}
				ReplicatedStorage.Events.HitPart:FireServer(unpack(args))
			end
		end
	end
end)

--ragebot loop
game:GetService("RunService").RenderStepped:Connect(function()
	if rageMain then
		for _, plr in next, game:GetService("Players"):GetChildren() do
			local pos, vis = workspace.CurrentCamera:WorldToScreenPoint(plr.Character.Head.Position)
			if plr.Team ~= lp.Team and vis then
				local args = {
					[1] = v.Character.Head,
					[2] = v.Character.Head.Position,
					[3] = "AWP",
					[4] = 100,
					[5] = lp.Character.Gun,
					[8] = 100,
					[9] = false,
					[10] = false,
					[11] = Vector3.new(),
					[12] = 100,
					[13] = Vector3.new()
				}
				ReplicatedStorage.Events.HitPart:FireServer(unpack(args))
			end
		end
	end
end)

--fov loop
game:GetService("RunService").RenderStepped:Connect(function()
	client.fieldofview = fov
end)

--exploits loop
task.spawn(function()
    while task.wait(1) do
		if rapidFire then
			for _, wep in next, game:GetService("ReplicatedStorage").Weapons:GetChildren() do
				if wep:FindFirstChild("FireRate") then
					wep:FindFirstChild("FireRate").Value = 0.001
				end
			end
		end
		if instantReload then
			for _, wep in next, game:GetService("ReplicatedStorage").Weapons:GetChildren() do
				if wep:FindFirstChild("ReloadTime") then
					wep:FindFirstChild("ReloadTime").Value = 0.001
				end
			end
		end
		if noSpread then
			for _, wep in next, game:GetService("ReplicatedStorage").Weapons:GetChildren() do
				if wep:FindFirstChild("Spread") then
					for _, property in next, wep:FindFirstChild("Spread"):GetChildren() do
					property.Value = 0
					end
				end
			end
		end
    end
end)

--chams function
-- clone part function
function clonePart(part, model, character)
	-- check if part is a BasePart
    if part:IsA("BasePart") then
		local head = character:WaitForChild("Head")

		-- clone part
		local clone = part:Clone() 

		-- loop through cloned part
		for _, obj in next, clone:GetChildren() do
			-- destroy anything that isnt a SpecialMesh
			if not obj:IsA("SpecialMesh") then
				obj:Destroy()
				continue
			end

			-- change SpecialMesh texture id to nothing
			obj.TextureId = ""
		end

		-- change clone color and parent clone
		clone.Color = chamsColorVisible
		clone.Parent = model

		-- loop clone
		runService.RenderStepped:connect(function()
			-- check if head exists
			if head:IsDescendantOf(workspace) then
				-- object on screen
				local _, visible = workspace.CurrentCamera:WorldToViewportPoint(part.Position)

				-- if object is on screen
				if visible then
					-- change CFrame and Size and Transparency of clone
					clone.CFrame = part.CFrame
					clone.Size = part.Size
					clone.Color = chamsColorVisible
					clone.Parent = model
					if visibleChams then
						clone.Transparency = chamsTransparencyVisible
					else
						clone.Transparency = 1
					end
				else
					-- if not visible then stop rendering
					clone.Color = chamsColorInvisible
					if invisibleChams then
						clone.Transparency = chamsTransparencyInvisible
					else
						clone.Transparency = 1
					end
				end
			else
				-- if object doesnt exist delete it and move on
				model:Destroy()
				return
			end
		end)
	end
end


function chams(character)
	print("chams()")
	-- create model for cloned parts to be in
    local model = Instance.new("Model")
    model.Name = character.Name
    model.Parent = viewportFrame
	-- loop through character
    for _, obj in next, character:GetChildren() do
		print("looping chams()")
		-- if character has a head then
        if character:FindFirstChild("Head") then
			print("found head")
			-- clone parts
            clonePart(obj, model, character)
        end
    end
end

function addChams()
	for _, plr in next, game:GetService("Players"):GetChildren() do
		print("finding target")
		if plr  ~= lp then
			print("found valid target: ")
			print(plr)
			-- get character
			local character = plr.Character or plr.CharacterAdded:Wait()
			character:WaitForChild("Head")
			print("done waiting")
			-- add chams to character
				print("chams()")
			-- create model for cloned parts to be in
			local model = Instance.new("Model")
			model.Name = character.Name
			model.Parent = viewportFrame
			-- loop through character
			for _, obj in next, character:GetChildren() do
				print("looping chams()")
				-- if character has a head then
				if character:FindFirstChild("Head") then
					print("found head")
					-- clone parts
					clonePart(obj, model, character)
				end
			end

			-- on character created
			plr.CharacterAdded:connect(function(char)
				-- create chams
				print("creating chams")
				char:WaitForChild("Head")
				-- create model for cloned parts to be in
				local model = Instance.new("Model")
				model.Name = char.Name
				model.Parent = viewportFrame
				-- loop through character
				for _, obj in next, char:GetChildren() do
					print("looping chams()")
					-- if character has a head then
					if char:FindFirstChild("Head") then
						print("found head")
						-- clone parts
						clonePart(obj, model, charr)
					end
				end
			end)
		end
	end
end

-- on player join
game:GetService("Players").PlayerAdded:connect(function(plr)
	if chams then
		-- get character
		local character = plr.Character or plr.CharacterAdded:Wait()
		character:WaitForChild("Head")
		chams(character)
		
		-- on character created
		plr.CharacterAdded:connect(function(char)
			-- create chams
			char:WaitForChild("Head")
			chams(char)
		end)
	end
end)

--bhop loop
game:GetService("RunService").RenderStepped:Connect(function()
	if bhop == true then
        if lp.Character and lp.Character.Parent ~= nil and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.Health >= 0 and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
			lp.Character.Humanoid.Jump = true
			local direction = workspace.CurrentCamera.CFrame.LookVector * Vector3.new(1,0,1)
			local move = Vector3.new()
			move = UserInputService:IsKeyDown(Enum.KeyCode.W) and move + direction or move
			move = UserInputService:IsKeyDown(Enum.KeyCode.S) and move - direction or move
			move = UserInputService:IsKeyDown(Enum.KeyCode.D) and move + Vector3.new(-direction.Z,0,direction.X) or move
			move = UserInputService:IsKeyDown(Enum.KeyCode.A) and move + Vector3.new(direction.Z,0,-direction.X) or move
			if move.Unit.X == move.Unit.X then
				move = move.Unit
				lp.Character.HumanoidRootPart.Velocity = Vector3.new(move.X*bhopSpeed,lp.Character.HumanoidRootPart.Velocity.Y,move.Z*bhopSpeed)
			end
		end
	end
end)

--fly loop
game:GetService("RunService").RenderStepped:Connect(function()
	if fly == true then
		local chr = game.Players.LocalPlayer.Character
		local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
		game:GetService('Players').LocalPlayer.Character.PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
			if hum and hum.Parent then
				if hum.MoveDirection.Magnitude > 0 then
					chr:TranslateBy(workspace.CurrentCamera.CFrame.LookVector * (flySpeed/20))
				end
			end
		end
		if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
			if hum and hum.Parent then
				if hum.MoveDirection.Magnitude > 0 then
					chr:TranslateBy(workspace.CurrentCamera.CFrame.LookVector * (-1) * (flySpeed/20))
				end
			end
		end
		if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
			if hum and hum.Parent then
				if hum.MoveDirection.Magnitude > 0 then
					chr:TranslateBy(workspace.CurrentCamera.CFrame.RightVector * (-1) * (flySpeed/20))
				end
			end
		end
		if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
			if hum and hum.Parent then
				if hum.MoveDirection.Magnitude > 0 then
					chr:TranslateBy(workspace.CurrentCamera.CFrame.RightVector * (flySpeed/20))
				end
			end
		end
	end
end)

--speed loop
game:GetService("RunService").RenderStepped:Connect(function()
    if walk == true then
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.Humanoid.MoveDirection * (0.015 * walkSpeed)
		game:GetService("RunService").Stepped:wait()
    end
end)

--3rd person loop
game:GetService("RunService").RenderStepped:Connect(function()
	if thirdperson == true then
		game:GetService("Workspace").Camera.Arms:Destroy()
		game.Players.LocalPlayer.CameraMode = "Classic"
		game.Players.LocalPlayer.CameraMaxZoomDistance = thirdPersonDistance
		game.Players.LocalPlayer.CameraMinZoomDistance = thirdPersonDistance
	end
end)



--AA loop
game:GetService("RunService").RenderStepped:Connect(function()
	if lp.Character and antiAim and chr:FindFirstChild("Humanoid").Health > 0 then
		chr.UpperTorso.Waist.C0 = CFrame.Angles(aaX/10,aaY/10,aaZ/10)
	end
end)

--triggerbot loop
game:GetService("RunService").RenderStepped:Connect(function()
   if autoShoot and rageMain and mouse.Target.Parent:FindFirstChild("HumanoidRootPart")then
     print("trigger")
	 mouse1click()
   end
end)

--On mouse click
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and idealtick then 
		wait()
	    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = idealtickLocation
	end
end)


-- [Init] --------------------------------------------------------------------------------------------------------------------------------------------------------------------
library:Init();
library:selectTab(library.tabs[1]);