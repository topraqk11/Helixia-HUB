local HelixiaHUB = loadstring(game:HttpGet("https://raw.githubusercontent.com/topraqk11/Helixia-HUB/refs/heads/main/library/source"))()

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local function getCharacter()
	return player.Character or player.CharacterAdded:Wait()
end

local function getHumanoid()
	local char = getCharacter()
	return char:WaitForChild("Humanoid")
end

local gameName = "Unknown Game"

pcall(function()
	gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

local themeNames = {}

for name in pairs(HelixiaHUB.Themes) do
	table.insert(themeNames, name)
end

table.sort(themeNames)

local win = HelixiaHUB:CreateWindow({
	Title    = "Helixia HUB | " .. gameName,
	SubTitle = "Helixia HUB v2.0",
	Icon     = "rbxassetid://102278873791566",
	Size     = Vector2.new(860, 540),
})

-- Home Tab
local homeTab = win:CreateTab({
	Name = "Home",
	Icon = "rbxassetid://138525646531017",
})

homeTab:CreateSection("General", {
	Description = "Helixia HUB loaded successfully.",
})

homeTab:CreateButton({
	Text = "Rejoin Server",
	Description = "Rejoins the current server.",
	Callback = function()
		TeleportService:Teleport(game.PlaceId, player)
	end,
})

homeTab:CreateButton({
	Text = "Hop to New Server",
	Description = "Teleports to another public server.",
	Callback = function()
		local success, result = pcall(function()
			return HttpService:JSONDecode(game:HttpGet(
				"https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
			))
		end)

		if not success or not result or not result.data then
			HelixiaHUB:Notify({
				Title = "Server Hop",
				Message = "Could not fetch server list.",
				Type = "Error",
				Duration = 3,
			})
			return
		end

		for _, server in pairs(result.data) do
			if server.playing < server.maxPlayers and server.id ~= game.JobId then
				TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, player)
				return
			end
		end

		HelixiaHUB:Notify({
			Title = "Server Hop",
			Message = "No suitable server found.",
			Type = "Warning",
			Duration = 3,
		})
	end,
})

homeTab:CreateButton({
	Text = "Welcome!",
	Description = "Shows loaded notification.",
	Callback = function()
		HelixiaHUB:Notify({
			Title = "Helixia HUB",
			Message = "Script is active and running.",
			Type = "Success",
			Duration = 3,
		})
	end,
})

-- Player Tab
local playerTab = win:CreateTab({
	Name = "Player",
	Icon = "rbxassetid://98097754960306",
})

playerTab:CreateSection("Movement")

playerTab:CreateSlider({
	Text      = "Walk Speed",
	Min       = 16,
	Max       = 500,
	Default   = 16,
	Increment = 1,
	Suffix    = " stud/s",
	Callback  = function(v)
		local humanoid = getHumanoid()
		humanoid.WalkSpeed = v
	end,
})

playerTab:CreateSlider({
	Text      = "Jump Power",
	Min       = 0,
	Max       = 500,
	Default   = 50,
	Increment = 1,
	Suffix    = " power",
	Callback  = function(v)
		local humanoid = getHumanoid()
		humanoid.JumpPower = v
	end,
})

playerTab:CreateSection("Abilities")

local infiniteJumpEnabled = false

playerTab:CreateToggle({
	Text = "Infinite Jump",
	Description = "Allows jumping while already in the air.",
	Default = false,
	Callback = function(v)
		infiniteJumpEnabled = v

		HelixiaHUB:Notify({
			Title = "Infinite Jump",
			Message = v and "Enabled" or "Disabled",
			Type = v and "Success" or "Info",
			Duration = 3,
		})
	end,
})

UserInputService.JumpRequest:Connect(function()
	if infiniteJumpEnabled then
		getHumanoid():ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

local noClipEnabled = false

playerTab:CreateToggle({
	Text = "No Clip",
	Description = "Allows walking through walls and objects.",
	Default = false,
	Callback = function(v)
		noClipEnabled = v

		HelixiaHUB:Notify({
			Title = "No Clip",
			Message = v and "Enabled" or "Disabled",
			Type = v and "Success" or "Info",
			Duration = 3,
		})
	end,
})

game:GetService("RunService").Stepped:Connect(function()
	if noClipEnabled then
		local char = player.Character
		if char then
			for _, part in pairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end
	end
end)

playerTab:CreateToggle({
	Text = "God Mode",
	Description = "Makes the character harder to kill.",
	Default = false,
	Callback = function(v)
		local humanoid = getHumanoid()

		if v then
			humanoid.MaxHealth = math.huge
			humanoid.Health = math.huge
		else
			humanoid.MaxHealth = 100
			humanoid.Health = 100
		end

		HelixiaHUB:Notify({
			Title = "God Mode",
			Message = v and "Enabled" or "Disabled",
			Type = v and "Success" or "Info",
			Duration = 3,
		})
	end,
})

local aimbotTab = win:CreateTab({
	Name = "Aimbot",
	Icon = "rbxassetid://104214411068348"
})

AimbotTab:CreateSection("AimBot")
local aimbotEnabled = false

local teamCheck = true
local maxDistance = 500

local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Backpack = LocalPlayer:WaitForChild("Backpack")

local ShootRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Shoot")

local function getClosestEnemyPlayer()
	local closestPlayer = nil
	local shortestDistance = maxDistance

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			if not teamCheck or player.Team ~= LocalPlayer.Team then
				local hrp = player.Character.HumanoidRootPart
				local distance = (Camera.CFrame.Position - hrp.Position).Magnitude
				if distance < shortestDistance then
					shortestDistance = distance
					closestPlayer = player
				end
			end
		end
	end

	return closestPlayer
end

local function isOnScreen(part)
	local _, onScreen = Camera:WorldToViewportPoint(part.Position)
	return onScreen
end

local function shootAtPlayer(targetPlayer)
	if not targetPlayer or not targetPlayer.Character then return end

	local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local firePos = root.Position + Vector3.new(0, 1.5, 0)

	local targetPart = nil
	for _, part in ipairs(targetPlayer.Character:GetChildren()) do
		if part:IsA("BasePart") and isOnScreen(part) then
			targetPart = part
			break
		end
	end

	if not targetPart then return end

	local args = {
		firePos,
		targetPart.Position,
		targetPart,
		targetPart.Position
	}

	ShootRemote:FireServer(unpack(args))
end

local lastShootTime = 0
local shootDelay = 0.1

RunService.RenderStepped:Connect(function()
	if not aimbotEnabled then return end

	local currentTime = tick()
	if currentTime - lastShootTime < shootDelay then return end

	local target = getClosestEnemyPlayer()
	if target then
		shootAtPlayer(target)
		lastShootTime = currentTime
	end
end)

AimbotTab:CreateToggle({
	Text = "Aimbot",
	Default = false,
	Callback = function(v)
		aimbotEnabled = v

		HelixiaHUB:Notify({
			Title = "Helixia HUB - AimBot",
			Message = v and "Enabled, take the gun." or "Disabled",
			Type = "Info",
			Duration = 2.5,
		})
	end
})

local visualTab = win:CreateTab({
	Name = "Visual",
	Icon = "rbxassetid://104214411068348",
})

visualTab:CreateSection("Camera")

visualTab:CreateSlider({
	Text      = "Field of View",
	Min       = 30,
	Max       = 120,
	Default   = 70,
	Increment = 1,
	Suffix    = "°",
	Callback  = function(v)
		workspace.CurrentCamera.FieldOfView = v
	end,
})

visualTab:CreateSection("Environment")

visualTab:CreateToggle({
	Text = "Fullbright",
	Description = "Removes darkness and shadows from the environment.",
	Default = false,
	Callback = function(v)
		if v then
			Lighting.Brightness = 2
			Lighting.ClockTime = 14
			Lighting.FogEnd = 100000
			Lighting.GlobalShadows = false
			Lighting.Ambient = Color3.fromRGB(178, 178, 178)
		else
			Lighting.Brightness = 1
			Lighting.ClockTime = 14
			Lighting.FogEnd = 100000
			Lighting.GlobalShadows = true
			Lighting.Ambient = Color3.fromRGB(70, 70, 70)
		end
	end,
})

-- Settings Tab
local settingsTab = win:CreateTab({
	Name = "Settings",
	Icon = "rbxassetid://119673892841288",
})

settingsTab:CreateSection("Theme")

settingsTab:CreateDropdown({
	Text = "Select Theme",
	Options = themeNames,
	Default = "Midnight",
	Callback = function(v)
		HelixiaHUB.Theme:SetPalette(v)

		HelixiaHUB:Notify({
			Title = "Theme Changed",
			Message = v .. " theme applied.",
			Type = "Success",
			Duration = 2,
		})
	end,
})

settingsTab:CreateSection("Window")

settingsTab:CreateToggle({
	Text = "Background Blur",
	Description = "Toggles the blur effect behind the window.",
	Default = true,
	Callback = function(v)
		local blur = Lighting:FindFirstChild("HelixiaHUBBlur")
		if blur then
			blur.Enabled = v
		end
	end,
})

settingsTab:CreateSection("About")

settingsTab:CreateButton({
	Text = "Helixia HUB v2.0",
	Description = "Built with the HelixiaHUB library.",
	Callback = function()
		HelixiaHUB:Notify({
			Title = "Helixia HUB",
			Message = "v2.0 - Built with HelixiaHUB.",
			Type = "Info",
			Duration = 3,
		})
	end,
})

task.delay(0.8, function()
	HelixiaHUB:Notify({
		Title = "Helixia HUB",
		Message = "Welcome! Script loaded successfully.",
		Type = "Success",
		Duration = 5,
	})
end)
