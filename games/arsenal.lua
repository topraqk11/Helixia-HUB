local HelixiaHUB = loadstring(game:HttpGet("https://raw.githubusercontent.com/topraqk11/Helixia-HUB/refs/heads/main/library/source"))()

local win = HelixiaHUB:CreateWindow({
	Title    = "Helixia HUB",
	SubTitle = "Helixia HUB v2.0 - Pro Edition",
	Icon     = "rbxassetid://102278873791566",
	Size     = Vector2.new(860, 600),
})

local themeNames = {}
for name in pairs(HelixiaHUB.Themes) do
	table.insert(themeNames, name)
end
table.sort(themeNames)

-- ===== ESP CONFIGURATION =====
local espConfig = {
	enabled = false,
	showNames = true,
	showHealth = true,
	showDistance = true,
	useTeamColor = true,
	r = 1,
	g = 0,
	b = 0,
	transparency = 0.3,
	lineThickness = 2,
	maxDistance = 500
}

local espConnections = {}
local espDrawings = {}
local espBoxes = {}

-- ===== GENERAL TAB =====
local generalTab = win:CreateTab({
	Name = "General",
	Icon = "rbxassetid://138525646531017",
})

generalTab:CreateSection("Server Management")

generalTab:CreateButton({
	Text        = "Welcome!",
	Description = "Helixia HUB Pro Edition loaded.",
	Callback    = function()
		HelixiaHUB:Notify({
			Title    = "Helixia HUB",
			Message  = "Pro script is active and running!",
			Type     = "Success",
			Duration = 3,
		})
	end,
})

generalTab:CreateButton({
	Text        = "Rejoin Server",
	Description = "Teleport to the same server",
	Callback    = function()
		local ts = game:GetService("TeleportService")
		local placeId = game.PlaceId
		ts:Teleport(placeId, game.Players.LocalPlayer)
	end,
})

generalTab:CreateButton({
	Text        = "Hop to New Server",
	Description = "Find a new server with available space",
	Callback    = function()
		local HttpService = game:GetService("HttpService")
		local TeleportService = game:GetService("TeleportService")
		
		pcall(function()
			local response = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100")
			local Servers = HttpService:JSONDecode(response).data
			
			for _, v in pairs(Servers) do
				if v.playing < v.maxPlayers then
					TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, game.Players.LocalPlayer)
					break
				end
			end
		end)
	end,
})

generalTab:CreateSection("Information")

generalTab:CreateButton({
	Text        = "System Info",
	Description = "Display current game information",
	Callback    = function()
		local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name or "Unknown"
		HelixiaHUB:Notify({
			Title    = "Game Info",
			Message  = "Game: " .. gameName .. "\nPlace ID: " .. game.PlaceId,
			Type     = "Info",
			Duration = 4,
		})
	end,
})

-- ===== PLAYER TAB =====
local playerTab = win:CreateTab({
	Name = "Player",
	Icon = "rbxassetid://98097754960306",
})

playerTab:CreateSection("Movement Settings")

playerTab:CreateSlider({
	Text      = "Walk Speed",
	Min       = 16,
	Max       = 300,
	Default   = 16,
	Increment = 5,
	Suffix    = " stud/s",
	Callback  = function(v)
		local char = game.Players.LocalPlayer.Character
		if char and char:FindFirstChild("Humanoid") then
			char.Humanoid.WalkSpeed = v
		end
	end,
})

playerTab:CreateSlider({
	Text      = "Jump Power",
	Min       = 0,
	Max       = 300,
	Default   = 50,
	Increment = 5,
	Suffix    = " power",
	Callback  = function(v)
		local char = game.Players.LocalPlayer.Character
		if char and char:FindFirstChild("Humanoid") then
			char.Humanoid.JumpPower = v
		end
	end,
})

playerTab:CreateSlider({
	Text      = "Gravity Scale",
	Min       = 0,
	Max       = 2,
	Default   = 1,
	Increment = 0.1,
	Suffix    = "x",
	Callback  = function(v)
		local char = game.Players.LocalPlayer.Character
		if char and char:FindFirstChild("Humanoid") then
			char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, v > 0)
		end
	end,
})

playerTab:CreateSection("Ability Features")

local infiniteJumpEnabled = false
playerTab:CreateToggle({
	Text        = "Infinite Jump",
	Description = "Jump continuously in the air",
	Default     = false,
	Callback    = function(v)
		infiniteJumpEnabled = v
		if v then
			local UIS = game:GetService("UserInputService")
			local connection
			connection = UIS.JumpRequest:Connect(function()
				if infiniteJumpEnabled then
					local char = game.Players.LocalPlayer.Character
					if char and char:FindFirstChild("Humanoid") then
						char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
					end
				end
			end)
		end
	end,
})

playerTab:CreateToggle({
	Text        = "No Clip",
	Description = "Walk through walls and objects",
	Default     = false,
	Callback    = function(v)
		if v then
			local char = game.Players.LocalPlayer.Character
			if char then
				for _, part in pairs(char:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
			end
		end
	end,
})

playerTab:CreateToggle({
	Text        = "God Mode",
	Description = "Makes character invincible",
	Default     = false,
	Callback    = function(v)
		if v then
			local char = game.Players.LocalPlayer.Character
			if char and char:FindFirstChild("Humanoid") then
				char.Humanoid.MaxHealth = math.huge
			end
		end
	end,
})

-- ===== VISUAL TAB =====
local visualTab = win:CreateTab({
	Name = "Visual",
	Icon = "rbxassetid://104214411068348",
})

visualTab:CreateSection("Camera Settings")

visualTab:CreateSlider({
	Text      = "Field of View",
	Min       = 30,
	Max       = 120,
	Default   = 70,
	Increment = 5,
	Suffix    = "°",
	Callback  = function(v)
		workspace.CurrentCamera.FieldOfView = v
	end,
})

visualTab:CreateSection("Environment Effects")

visualTab:CreateToggle({
	Text        = "Fullbright",
	Description = "Removes darkness and shadows",
	Default     = false,
	Callback    = function(v)
		local Lighting = game:GetService("Lighting")
		if v then
			Lighting.Brightness    = 2.5
			Lighting.ClockTime     = 14
			Lighting.FogEnd        = 100000
			Lighting.GlobalShadows = false
			Lighting.Ambient       = Color3.fromRGB(200, 200, 200)
		else
			Lighting.Brightness    = 1
			Lighting.ClockTime     = 14
			Lighting.FogEnd        = 100000
			Lighting.GlobalShadows = true
			Lighting.Ambient       = Color3.fromRGB(70, 70, 70)
		end
	end,
})

visualTab:CreateToggle({
	Text        = "Remove Fog",
	Description = "Increases visibility distance",
	Default     = false,
	Callback    = function(v)
		local Lighting = game:GetService("Lighting")
		if v then
			Lighting.FogEnd = 1000000
		else
			Lighting.FogEnd = 100000
		end
	end,
})

-- ===== ESP TAB (NEW & IMPROVED) =====
local espTab = win:CreateTab({
	Name = "ESP",
	Icon = "rbxassetid://7733778463",
})

espTab:CreateSection("Main Toggle")

espTab:CreateToggle({
	Text        = "Enable ESP",
	Description = "Activate wireframe player ESP",
	Default     = false,
	Callback    = function(v)
		espConfig.enabled = v
		
		if v then
			HelixiaHUB:Notify({
				Title    = "ESP",
				Message  = "ESP Enabled",
				Type     = "Success",
				Duration = 2,
			})
			
			-- Start ESP Loop
			if not espConnections.main then
				espConnections.main = game:GetService("RunService").RenderStepped:Connect(function()
					if espConfig.enabled then
						updateESP()
					end
				end)
			end
		else
			HelixiaHUB:Notify({
				Title    = "ESP",
				Message  = "ESP Disabled",
				Type     = "Info",
				Duration = 2,
			})
			
			-- Cleanup
			if espConnections.main then
				espConnections.main:Disconnect()
				espConnections.main = nil
			end
			
			for _, drawing in pairs(espDrawings) do
				pcall(function() drawing:Remove() end)
			end
			espDrawings = {}
			
			for _, box in pairs(espBoxes) do
				pcall(function() box:Destroy() end)
			end
			espBoxes = {}
		end
	end,
})

espTab:CreateSection("Display Options")

espTab:CreateToggle({
	Text        = "Show Names",
	Description = "Display player names",
	Default     = true,
	Callback    = function(v)
		espConfig.showNames = v
	end,
})

espTab:CreateToggle({
	Text        = "Show Health",
	Description = "Display player health",
	Default     = true,
	Callback    = function(v)
		espConfig.showHealth = v
	end,
})

espTab:CreateToggle({
	Text        = "Show Distance",
	Description = "Display distance to player",
	Default     = true,
	Callback    = function(v)
		espConfig.showDistance = v
	end,
})

espTab:CreateToggle({
	Text        = "Team Colors",
	Description = "Auto color by team (red for enemies)",
	Default     = true,
	Callback    = function(v)
		espConfig.useTeamColor = v
	end,
})

espTab:CreateSection("Color & Style")

espTab:CreateSlider({
	Text      = "Red (R)",
	Min       = 0,
	Max       = 255,
	Default   = 255,
	Increment = 5,
	Suffix    = "",
	Callback  = function(v)
		espConfig.r = v / 255
	end,
})

espTab:CreateSlider({
	Text      = "Green (G)",
	Min       = 0,
	Max       = 255,
	Default   = 0,
	Increment = 5,
	Suffix    = "",
	Callback  = function(v)
		espConfig.g = v / 255
	end,
})

espTab:CreateSlider({
	Text      = "Blue (B)",
	Min       = 0,
	Max       = 255,
	Default   = 0,
	Increment = 5,
	Suffix    = "",
	Callback  = function(v)
		espConfig.b = v / 255
	end,
})

espTab:CreateSlider({
	Text      = "Transparency",
	Min       = 0,
	Max       = 100,
	Default   = 30,
	Increment = 5,
	Suffix    = "%",
	Callback  = function(v)
		espConfig.transparency = v / 100
	end,
})

espTab:CreateSlider({
	Text      = "Line Thickness",
	Min       = 1,
	Max       = 5,
	Default   = 2,
	Increment = 1,
	Suffix    = " px",
	Callback  = function(v)
		espConfig.lineThickness = v
	end,
})

espTab:CreateSlider({
	Text      = "Max Distance",
	Min       = 100,
	Max       = 1000,
	Default   = 500,
	Increment = 50,
	Suffix    = " studs",
	Callback  = function(v)
		espConfig.maxDistance = v
	end,
})

espTab:CreateSection("Presets")

espTab:CreateButton({
	Text        = "Red Enemy",
	Description = "Red color for enemies",
	Callback    = function()
		espConfig.r, espConfig.g, espConfig.b = 1, 0, 0
		HelixiaHUB:Notify({
			Title    = "Color Preset",
			Message  = "Red color applied",
			Type     = "Success",
			Duration = 2,
		})
	end,
})

espTab:CreateButton({
	Text        = "Green Friendly",
	Description = "Green color for friendlies",
	Callback    = function()
		espConfig.r, espConfig.g, espConfig.b = 0, 1, 0
		HelixiaHUB:Notify({
			Title    = "Color Preset",
			Message  = "Green color applied",
			Type     = "Success",
			Duration = 2,
		})
	end,
})

espTab:CreateButton({
	Text        = "Blue Neutral",
	Description = "Blue color for neutral",
	Callback    = function()
		espConfig.r, espConfig.g, espConfig.b = 0, 0.5, 1
		HelixiaHUB:Notify({
			Title    = "Color Preset",
			Message  = "Blue color applied",
			Type     = "Success",
			Duration = 2,
		})
	end,
})

-- ===== AIMBOT TAB =====
local aimbotTab = win:CreateTab({
	Name = "Combat",
	Icon = "rbxassetid://6034143597",
})

local aimbotEnabled = false
local aimbotConfig = {
	fov = 500,
	maxDistance = 400,
	teamCheck = true,
	smoothing = 0.1,
	predictMovement = true
}

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Cam = workspace.CurrentCamera

local FOVring = Drawing.new("Circle")
FOVring.Visible = false
FOVring.Thickness = 2
FOVring.Color = Color3.fromRGB(128, 0, 128)
FOVring.Filled = false
FOVring.Radius = aimbotConfig.fov
FOVring.Position = Cam.ViewportSize / 2

local function updateDrawings()
	FOVring.Position = Cam.ViewportSize / 2
end

local function lookAt(target)
	local lookVector = (target - Cam.CFrame.Position).unit
	Cam.CFrame = CFrame.new(Cam.CFrame.Position, Cam.CFrame.Position + lookVector)
end

local function isPlayerAlive(player)
	local character = player.Character
	return character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0
end

local function isVisible(part)
	local origin = Cam.CFrame.Position
	local direction = (part.Position - origin).unit * aimbotConfig.maxDistance
	local ray = Ray.new(origin, direction)
	local hit = workspace:FindPartOnRay(ray, Players.LocalPlayer.Character)
	return hit and hit:IsDescendantOf(part.Parent)
end

local function getClosestVisiblePlayerInFOV(trg_part)
	local nearest, last = nil, math.huge
	local playerMousePos = Cam.ViewportSize / 2
	local localPlayer = Players.LocalPlayer

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and (not aimbotConfig.teamCheck or player.Team ~= localPlayer.Team) then
			if isPlayerAlive(player) then
				local part = player.Character and player.Character:FindFirstChild(trg_part)
				if part and isVisible(part) then
					local ePos = Cam:WorldToViewportPoint(part.Position)
					local distance = (Vector2.new(ePos.X, ePos.Y) - playerMousePos).Magnitude
					if distance < last and distance < aimbotConfig.fov then
						last = distance
						nearest = player
					end
				end
			end
		end
	end
	return nearest
end

local function aimbotFunction()
	if not aimbotEnabled then return end
	updateDrawings()
	local target = getClosestVisiblePlayerInFOV("Head")
	if target and target.Character and target.Character:FindFirstChild("Head") then
		lookAt(target.Character.Head.Position)
	end
end

aimbotTab:CreateSection("Aimbot Settings")

aimbotTab:CreateToggle({
	Text = "Enable Aimbot",
	Description = "Auto aim to closest player head",
	Default = false,
	Callback = function(Value)
		aimbotEnabled = Value
		FOVring.Visible = Value

		if Value then
			RunService:BindToRenderStep("AimbotUpdate", Enum.RenderPriority.Camera.Value, aimbotFunction)
			HelixiaHUB:Notify({
				Title    = "Aimbot",
				Message  = "Enabled",
				Type     = "Success",
				Duration = 2,
			})
		else
			RunService:UnbindFromRenderStep("AimbotUpdate")
			FOVring.Visible = false
			HelixiaHUB:Notify({
				Title    = "Aimbot",
				Message  = "Disabled",
				Type     = "Info",
				Duration = 2,
			})
		end
	end,
})

aimbotTab:CreateSlider({
	Text      = "FOV Size",
	Min       = 100,
	Max       = 2000,
	Default   = 500,
	Increment = 50,
	Suffix    = " px",
	Callback  = function(v)
		aimbotConfig.fov = v
		FOVring.Radius = v
	end,
})

aimbotTab:CreateSlider({
	Text      = "Max Distance",
	Min       = 100,
	Max       = 1000,
	Default   = 400,
	Increment = 50,
	Suffix    = " stud",
	Callback  = function(v)
		aimbotConfig.maxDistance = v
	end,
})

aimbotTab:CreateToggle({
	Text        = "Team Check",
	Description = "Only target enemies",
	Default     = true,
	Callback    = function(v)
		aimbotConfig.teamCheck = v
	end,
})

aimbotTab:CreateToggle({
	Text        = "Predict Movement",
	Description = "Lead shots for moving targets",
	Default     = true,
	Callback    = function(v)
		aimbotConfig.predictMovement = v
	end,
})

-- ===== WEAPONS TAB =====
local weaponsTab = win:CreateTab({
	Name = "Weapons",
	Icon = "rbxassetid://8614397126",
})

weaponsTab:CreateSection("Ammunition")

local infiniteAmmoConnection = nil

local function infiniteAmmoFunction()
	local player = game:GetService("Players").LocalPlayer
	local playerGui = player:FindFirstChild("PlayerGui")
	if playerGui then
		local gui = playerGui:FindFirstChild("GUI")
		if gui and gui:FindFirstChild("Client") and gui.Client:FindFirstChild("Variables") then
			local variables = gui.Client.Variables
			if variables:FindFirstChild("ammocount") and variables:FindFirstChild("ammocount2") then
				variables.ammocount.Value = 999
				variables.ammocount2.Value = 999
			end
		end
	end
end

weaponsTab:CreateToggle({
	Text        = "Infinite Ammo",
	Description = "Unlimited ammunition",
	Default     = false,
	Callback    = function(Value)
		if Value and not infiniteAmmoConnection then
			infiniteAmmoConnection = game:GetService("RunService").Stepped:Connect(infiniteAmmoFunction)
			HelixiaHUB:Notify({
				Title    = "Infinite Ammo",
				Message  = "Enabled",
				Type     = "Success",
				Duration = 2,
			})
		elseif not Value and infiniteAmmoConnection then
			infiniteAmmoConnection:Disconnect()
			infiniteAmmoConnection = nil
			HelixiaHUB:Notify({
				Title    = "Infinite Ammo",
				Message  = "Disabled",
				Type     = "Info",
				Duration = 2,
			})
		end
	end,
})

weaponsTab:CreateSection("Reload Speed")

local originalValues = {
	ReloadTime = {},
	EReloadTime = {}
}

weaponsTab:CreateToggle({
	Text        = "Fast Reload",
	Description = "Instant weapon reload",
	Default     = false,
	Callback    = function(Value)
		for _, weapon in pairs(game.ReplicatedStorage.Weapons:GetChildren()) do
			if weapon:FindFirstChild("ReloadTime") then
				if Value then
					if not originalValues.ReloadTime[weapon] then
						originalValues.ReloadTime[weapon] = weapon.ReloadTime.Value
					end
					weapon.ReloadTime.Value = 0.01
				else
					if originalValues.ReloadTime[weapon] then
						weapon.ReloadTime.Value = originalValues.ReloadTime[weapon]
					else
						weapon.ReloadTime.Value = 0.8
					end
				end
			end

			if weapon:FindFirstChild("EReloadTime") then
				if Value then
					if not originalValues.EReloadTime[weapon] then
						originalValues.EReloadTime[weapon] = weapon.EReloadTime.Value
					end
					weapon.EReloadTime.Value = 0.01
				else
					if originalValues.EReloadTime[weapon] then
						weapon.EReloadTime.Value = originalValues.EReloadTime[weapon]
					else
						weapon.EReloadTime.Value = 0.8
					end
				end
			end
		end

		HelixiaHUB:Notify({
			Title    = "Fast Reload",
			Message  = Value and "Enabled" or "Disabled",
			Type     = "Success",
			Duration = 2,
		})
	end,
})

weaponsTab:CreateSlider({
	Text      = "Reload Speed Multiplier",
	Min       = 0.1,
	Max       = 5,
	Default   = 1,
	Increment = 0.2,
	Suffix    = "x",
	Callback  = function(v)
		for _, weapon in pairs(game.ReplicatedStorage.Weapons:GetChildren()) do
			if weapon:FindFirstChild("ReloadTime") and originalValues.ReloadTime[weapon] then
				weapon.ReloadTime.Value = originalValues.ReloadTime[weapon] / v
			end
		end
	end,
})

-- ===== SETTINGS TAB =====
local settingsTab = win:CreateTab({
	Name = "Settings",
	Icon = "rbxassetid://119673892841288",
})

settingsTab:CreateSection("Theme Customization")

settingsTab:CreateDropdown({
	Text     = "Select Theme",
	Options  = themeNames,
	Default  = "Midnight",
	Callback = function(v)
		HelixiaHUB.Theme:SetPalette(v)
		HelixiaHUB:Notify({
			Title    = "Theme",
			Message  = v .. " theme applied.",
			Type     = "Success",
			Duration = 2,
		})
	end,
})

settingsTab:CreateSection("UI Settings")

settingsTab:CreateToggle({
	Text        = "Background Blur",
	Description = "Toggles background blur effect",
	Default     = true,
	Callback    = function(v)
		local blur = game:GetService("Lighting"):FindFirstChild("HelixiaHUBBlur")
		if blur then
			blur.Enabled = v
		end
	end,
})

settingsTab:CreateSection("About")

settingsTab:CreateButton({
	Text        = "Helixia HUB Pro v2.0",
	Description = "Advanced exploit features with professional ESP",
	Callback    = function()
		HelixiaHUB:Notify({
			Title    = "Helixia HUB Pro",
			Message  = "v2.0 — Premium features unlocked! 🚀",
			Type     = "Info",
			Duration = 4,
		})
	end,
})

-- ===== ESP UPDATE FUNCTION =====
function updateESP()
	local localPlayer = game.Players.LocalPlayer
	local players = game.Players:GetPlayers()

	for _, player in pairs(players) do
		if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local character = player.Character
			local humanoid = character:FindFirstChild("Humanoid")
			local rootPart = character:FindFirstChild("HumanoidRootPart")

			if humanoid and rootPart then
				local distance = (rootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude

				if distance <= espConfig.maxDistance then
					-- Color selection
					local color
					if espConfig.useTeamColor then
						if player.Team ~= localPlayer.Team then
							color = Color3.fromRGB(255, 0, 0) -- Red for enemies
						else
							color = Color3.fromRGB(0, 255, 0) -- Green for teammates
						end
					else
						color = Color3.new(espConfig.r, espConfig.g, espConfig.b)
					end

					-- Create BillboardGui for text display
					if espConfig.showNames or espConfig.showHealth or espConfig.showDistance then
						if not espBoxes[player] then
							local billboard = Instance.new("BillboardGui")
							billboard.Size = UDim2.new(4, 0, 2, 0)
							billboard.MaxDistance = espConfig.maxDistance
							billboard.Adornee = rootPart

							local textLabel = Instance.new("TextLabel")
							textLabel.Size = UDim2.new(1, 0, 1, 0)
							textLabel.BackgroundTransparency = 1
							textLabel.TextScaled = true
							textLabel.Font = Enum.Font.GothamBold
							textLabel.TextColor3 = color
							textLabel.Parent = billboard

							billboard.Parent = rootPart
							espBoxes[player] = {
								billboard = billboard,
								textLabel = textLabel,
								color = color
							}
						end

						-- Update text
						local box = espBoxes[player]
						local text = ""

						if espConfig.showNames then
							text = text .. player.Name .. "\n"
						end
						if espConfig.showHealth and humanoid then
							text = text .. "HP: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth) .. "\n"
						end
						if espConfig.showDistance then
							text = text .. "Dist: " .. math.floor(distance) .. "m"
						end

						box.textLabel.Text = text
						box.textLabel.TextColor3 = box.color
					end
				else
					-- Remove ESP if too far
					if espBoxes[player] then
						espBoxes[player].billboard:Destroy()
						espBoxes[player] = nil
					end
				end
			end
		end
	end

	-- Cleanup destroyed players
	for player, box in pairs(espBoxes) do
		if not player.Parent or not player.Character then
			pcall(function() box.billboard:Destroy() end)
			espBoxes[player] = nil
		end
	end
end

-- ===== STARTUP =====
task.delay(0.8, function()
	HelixiaHUB:Notify({
		Title    = "Helixia HUB Pro",
		Message  = "v2.0 loaded! Check all tabs for features.",
		Type     = "Success",
		Duration = 5,
	})
end)
