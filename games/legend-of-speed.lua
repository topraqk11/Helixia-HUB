local HelixiaHUB = loadstring(game:HttpGet("https://raw.githubusercontent.com/topraqk11/Helixia-HUB/refs/heads/main/library/source"))()

local win = HelixiaHUB:CreateWindow({
	Title    = "Helixia HUB",
	SubTitle = "Helixia HUB v2.0",
	Icon     = "rbxassetid://102278873791566",
	Size     = Vector2.new(860, 540),
})

local themeNames = {}
for name in pairs(HelixiaHUB.Themes) do
	table.insert(themeNames, name)
end
table.sort(themeNames)

local generalTab = win:CreateTab({
	Name = "General",
	Icon = "rbxassetid://138525646531017",
})

generalTab:CreateSection("Welcome", {
	Description = "Use the tabs on the left to navigate through Helixia HUB's features.",
})

generalTab:CreateButton({
	Text        = "Welcome!",
	Description = "Helixia HUB v2.0 has loaded successfully.",
	Callback    = function()
		HelixiaHUB:Notify({
			Title    = "Helixia HUB",
			Message  = "Script is active and running.",
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
	Description = "Join a different server with space available",
	Callback    = function()
		local HttpService = game:GetService("HttpService")
		local TeleportService = game:GetService("TeleportService")
		local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100")).data
		
		for _, v in pairs(Servers) do
			if v.playing < v.maxPlayers then
				TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, game.Players.LocalPlayer)
				break
			end
		end
	end,
})

local playerTab = win:CreateTab({
	Name = "Player",
	Icon = "rbxassetid://98097754960306",
})

playerTab:CreateSection("Movement")

playerTab:CreateSlider({
	Text      = "Walk Speed",
	Min       = 16,
	Max       = 250,
	Default   = 16,
	Increment = 1,
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
	Increment = 1,
	Suffix    = " power",
	Callback  = function(v)
		local char = game.Players.LocalPlayer.Character
		if char and char:FindFirstChild("Humanoid") then
			char.Humanoid.JumpPower = v
		end
	end,
})

playerTab:CreateSection("Abilities")

local infiniteJumpEnabled = false
playerTab:CreateToggle({
	Text        = "Infinite Jump",
	Description = "Allows jumping while already in the air",
	Default     = false,
	Callback    = function(v)
		infiniteJumpEnabled = v
		if v then
			local UIS = game:GetService("UserInputService")
			UIS.JumpRequest:Connect(function()
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
	Description = "Allows walking through walls and objects",
	Default     = false,
	Callback    = function(v)
		if v then
			if _G.HelixiaNoClipConnection then
				_G.HelixiaNoClipConnection:Disconnect()
			end

			_G.HelixiaNoClipConnection = game:GetService("RunService").Stepped:Connect(function()
				local character = game.Players.LocalPlayer.Character
				if not character then return end

				for _, part in pairs(character:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
			end)
		elseif _G.HelixiaNoClipConnection then
			_G.HelixiaNoClipConnection:Disconnect()
			_G.HelixiaNoClipConnection = nil
		end
	end,
})

playerTab:CreateToggle({
	Text        = "God Mode",
	Description = "Makes the character invincible",
	Default     = false,
	Callback    = function(v)
		print("God Mode:", v)
	end,
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
	Suffix    = " deg",
	Callback  = function(v)
		workspace.CurrentCamera.FieldOfView = v
	end,
})

visualTab:CreateSection("Environment")

visualTab:CreateToggle({
	Text        = "Fullbright",
	Description = "Removes darkness and shadows from the environment",
	Default     = false,
	Callback    = function(v)
		local Lighting = game:GetService("Lighting")
		if v then
			Lighting.Brightness    = 2
			Lighting.ClockTime     = 14
			Lighting.FogEnd        = 100000
			Lighting.GlobalShadows = false
			Lighting.Ambient       = Color3.fromRGB(178, 178, 178)
		else
			Lighting.Brightness    = 1
			Lighting.ClockTime     = 14
			Lighting.FogEnd        = 100000
			Lighting.GlobalShadows = true
			Lighting.Ambient       = Color3.fromRGB(70, 70, 70)
		end
	end,
})

-- ===== SPEED OF LEGENDS TAB =====
local speedPlayers = game:GetService("Players")
local speedLocalPlayer = speedPlayers.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")

local speedTab = win:CreateTab({
	Name = "Speed Legends",
	Icon = "rbxassetid://138525646531017",
})

speedTab:CreateSection("Farm Setup", {
	Description = "Speed of Legends farming helpers from the Project Meow script.",
})

local function ensureManaHubPart()
	if workspace:FindFirstChild("ManahubPart") then return end

	local manaHubPart = Instance.new("Part")
	manaHubPart.Name = "ManahubPart"
	manaHubPart.Parent = workspace
	manaHubPart.Anchored = true
	manaHubPart.Transparency = 0
	manaHubPart.Size = Vector3.new(30, 0.5, 30)
	manaHubPart.Position = Vector3.new(-543.452, 2873.2, 324.647)
end

local function fireOrb(orbName, areaName)
	local events = replicatedStorage:FindFirstChild("rEvents")
	local orbEvent = events and events:FindFirstChild("orbEvent")
	if orbEvent then
		orbEvent:FireServer("collectOrb", orbName, areaName)
	end
end

local function requestRebirth()
	local events = replicatedStorage:FindFirstChild("rEvents")
	local rebirthEvent = events and events:FindFirstChild("rebirthEvent")
	if rebirthEvent then
		rebirthEvent:FireServer("rebirthRequest")
	end
end

ensureManaHubPart()

speedTab:CreateButton({
	Text = "Create Farm Platform",
	Description = "Creates the ManahubPart platform used by safe hoops farming.",
	Callback = function()
		ensureManaHubPart()
		HelixiaHUB:Notify({
			Title = "Speed Legends",
			Message = "Farm platform is ready.",
			Type = "Success",
			Duration = 2,
		})
	end,
})

speedTab:CreateSection("Autofarm")

local autoStepsEnabled = false
local autoGemsEnabled = false
local autoHoopsEnabled = false
local safeHoopsEnabled = false
local autoRebirthEnabled = false

speedTab:CreateToggle({
	Text = "Auto Steps",
	Description = "Collects red and blue city orbs repeatedly.",
	Default = false,
	Callback = function(value)
		autoStepsEnabled = value
		if not value then return end

		task.spawn(function()
			while autoStepsEnabled do
				pcall(function()
					for _ = 1, 20 do
						fireOrb("Red Orb", "City")
						fireOrb("Blue Orb", "City")
					end
				end)
				task.wait()
			end
		end)
	end,
})

speedTab:CreateToggle({
	Text = "Auto Collect Gems",
	Description = "Collects city, desert and magma city gems repeatedly.",
	Default = false,
	Callback = function(value)
		autoGemsEnabled = value
		if not value then return end

		task.spawn(function()
			while autoGemsEnabled do
				pcall(function()
					for _ = 1, 10 do
						fireOrb("Gem", "City")
						fireOrb("Gem", "Desert")
						fireOrb("Gem", "Magma City")
					end
				end)
				task.wait()
			end
		end)
	end,
})

speedTab:CreateToggle({
	Text = "Hoops Farm",
	Description = "Moves hoops to your character.",
	Default = false,
	Callback = function(value)
		autoHoopsEnabled = value
		if not value then return end

		task.spawn(function()
			while autoHoopsEnabled do
				pcall(function()
					local root = speedLocalPlayer.Character and speedLocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					local hoops = workspace:FindFirstChild("Hoops")
					if root and hoops then
						for _, hoop in pairs(hoops:GetChildren()) do
							if hoop:IsA("BasePart") then
								hoop.CFrame = root.CFrame
							end
						end
					end
				end)
				task.wait()
			end
		end)
	end,
})

speedTab:CreateToggle({
	Text = "Safe Hoops Farm",
	Description = "Moves hoops one by one and returns you to the farm platform.",
	Default = false,
	Callback = function(value)
		safeHoopsEnabled = value
		if not value then return end

		task.spawn(function()
			while safeHoopsEnabled do
				pcall(function()
					local root = speedLocalPlayer.Character and speedLocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					local hoops = workspace:FindFirstChild("Hoops")
					if root and hoops then
						for _, hoop in pairs(hoops:GetChildren()) do
							if not safeHoopsEnabled then break end
							if hoop:IsA("BasePart") then
								hoop.CFrame = root.CFrame
								task.wait(0.3)
							end
						end
					end
				end)
				task.wait()
			end
		end)

		task.spawn(function()
			while safeHoopsEnabled do
				pcall(function()
					local root = speedLocalPlayer.Character and speedLocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					if root then
						root.CFrame = CFrame.new(-547.52026, 2893.19995, 327.647003)
					end
				end)
				task.wait(0.3)
			end
		end)
	end,
})

speedTab:CreateToggle({
	Text = "Auto Rebirth",
	Description = "Sends rebirth requests repeatedly.",
	Default = false,
	Callback = function(value)
		autoRebirthEnabled = value
		if not value then return end

		task.spawn(function()
			while autoRebirthEnabled do
				pcall(function()
					requestRebirth()
					requestRebirth()
				end)
				task.wait()
			end
		end)
	end,
})

speedTab:CreateButton({
	Text = "Collect Chests",
	Description = "Attempts to collect group and course chest rewards.",
	Callback = function()
		pcall(function()
			local events = replicatedStorage:FindFirstChild("rEvents")
			if not events then return end

			local groupRemote = events:FindFirstChild("groupRemote")
			if groupRemote then
				groupRemote:InvokeServer("groupRewards")
			end

			local checkChestRemote = events:FindFirstChild("checkChestRemote")
			if checkChestRemote then
				checkChestRemote:InvokeServer("Enchanted Chest")
			end

			local collectChestRemote = events:FindFirstChild("collectCourseChestRemote")
			local rewardChest = workspace:FindFirstChild("rewardChests") and workspace.rewardChests:FindFirstChild("rewardChest")
			if collectChestRemote and rewardChest then
				collectChestRemote:InvokeServer(rewardChest)
			end
		end)

		HelixiaHUB:Notify({
			Title = "Speed Legends",
			Message = "Chest collection request sent.",
			Type = "Info",
			Duration = 2,
		})
	end,
})

-- ===== ESP TAB =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Cam = workspace.CurrentCamera

local function createColorControl(tab, text, defaultColor, callback)
	local colorPickerCreated = false

	if tab.CreateColorPicker then
		colorPickerCreated = pcall(function()
			tab:CreateColorPicker({
				Text = text,
				Default = defaultColor,
				Callback = callback,
			})
		end)
	elseif tab.CreateColorpicker then
		colorPickerCreated = pcall(function()
			tab:CreateColorpicker({
				Text = text,
				Default = defaultColor,
				Callback = callback,
			})
		end)
	elseif tab.CreateColourPicker then
		colorPickerCreated = pcall(function()
			tab:CreateColourPicker({
				Text = text,
				Default = defaultColor,
				Callback = callback,
			})
		end)
	end

	if not colorPickerCreated then
		local presets = {
			Red = Color3.fromRGB(255, 80, 80),
			Orange = Color3.fromRGB(255, 170, 60),
			Yellow = Color3.fromRGB(255, 235, 90),
			Green = Color3.fromRGB(80, 255, 130),
			Cyan = Color3.fromRGB(80, 220, 255),
			Blue = Color3.fromRGB(90, 140, 255),
			Purple = Color3.fromRGB(190, 100, 255),
			White = Color3.fromRGB(255, 255, 255),
		}

		tab:CreateDropdown({
			Text = text,
			Options = { "Red", "Orange", "Yellow", "Green", "Cyan", "Blue", "Purple", "White" },
			Default = "Red",
			Callback = function(value)
				callback(presets[value] or defaultColor)
			end,
		})
	end
end

local espTab = win:CreateTab({
	Name = "ESP",
	Icon = "rbxassetid://104214411068348",
})

espTab:CreateSection("Player ESP")

local espEnabled = false
local espTeamCheck = true
local espShowNames = true
local espShowDistance = true
local espShowHealth = true
local espShowTracers = false
local espThroughWalls = true
local espMaxDistance = 2000
local espColor = Color3.fromRGB(255, 80, 80)
local espFillTransparency = 0.85
local espObjects = {}
local espConnection = nil

local function removeDrawing(drawing)
	if drawing then
		pcall(function()
			drawing:Remove()
		end)
	end
end

local function setDrawingVisible(drawing, visible)
	if drawing then
		drawing.Visible = visible
	end
end

local function destroyEspObject(player)
	local object = espObjects[player]
	if not object then return end

	if object.Highlight then
		object.Highlight:Destroy()
	end

	removeDrawing(object.NameText)
	removeDrawing(object.DistanceText)
	removeDrawing(object.HealthText)
	removeDrawing(object.HealthBack)
	removeDrawing(object.HealthBar)
	removeDrawing(object.Tracer)
	espObjects[player] = nil
end

local function hideEspObject(object)
	if not object then return end
	if object.Highlight then
		object.Highlight.Enabled = false
	end
	setDrawingVisible(object.NameText, false)
	setDrawingVisible(object.DistanceText, false)
	setDrawingVisible(object.HealthText, false)
	setDrawingVisible(object.HealthBack, false)
	setDrawingVisible(object.HealthBar, false)
	setDrawingVisible(object.Tracer, false)
end

local function createEspObject(player)
	local object = espObjects[player]
	if object then return object end

	object = {}

	local highlight = Instance.new("Highlight")
	highlight.Name = "HelixiaESP_Highlight"
	highlight.FillTransparency = espFillTransparency
	highlight.OutlineTransparency = 0
	highlight.DepthMode = espThroughWalls and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
	highlight.FillColor = espColor
	highlight.OutlineColor = espColor
	object.Highlight = highlight

	object.NameText = Drawing.new("Text")
	object.NameText.Center = true
	object.NameText.Outline = true
	object.NameText.Size = 14
	object.NameText.Font = 2

	object.DistanceText = Drawing.new("Text")
	object.DistanceText.Center = true
	object.DistanceText.Outline = true
	object.DistanceText.Size = 13
	object.DistanceText.Font = 2

	object.HealthText = Drawing.new("Text")
	object.HealthText.Center = true
	object.HealthText.Outline = true
	object.HealthText.Size = 13
	object.HealthText.Font = 2

	object.HealthBack = Drawing.new("Square")
	object.HealthBack.Filled = true
	object.HealthBack.Color = Color3.fromRGB(20, 20, 20)
	object.HealthBack.Transparency = 0.65

	object.HealthBar = Drawing.new("Square")
	object.HealthBar.Filled = true
	object.HealthBar.Color = Color3.fromRGB(90, 255, 120)
	object.HealthBar.Transparency = 1

	object.Tracer = Drawing.new("Line")
	object.Tracer.Thickness = 1
	object.Tracer.Transparency = 0.9

	espObjects[player] = object
	return object
end

local function shouldShowEsp(player)
	if player == LocalPlayer then return false end
	if espTeamCheck and player.Team == LocalPlayer.Team then return false end

	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not character or not humanoid or not root or humanoid.Health <= 0 then return false end

	local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if localRoot and (root.Position - localRoot.Position).Magnitude > espMaxDistance then
		return false
	end

	return true
end

local function updateEspObject(player)
	Cam = workspace.CurrentCamera or Cam
	local object = createEspObject(player)
	if not shouldShowEsp(player) then
		hideEspObject(object)
		return
	end

	local character = player.Character
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart")
	local head = character:FindFirstChild("Head") or root
	local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local distance = localRoot and math.floor((root.Position - localRoot.Position).Magnitude) or 0

	local topPosition, topVisible = Cam:WorldToViewportPoint(head.Position + Vector3.new(0, 1.1, 0))
	local bottomPosition = Cam:WorldToViewportPoint(root.Position - Vector3.new(0, 3.1, 0))
	local rootPosition, rootVisible = Cam:WorldToViewportPoint(root.Position)
	if not topVisible and not rootVisible then
		hideEspObject(object)
		return
	end

	object.Highlight.Adornee = character
	object.Highlight.Parent = character
	object.Highlight.Enabled = true
	object.Highlight.FillColor = espColor
	object.Highlight.OutlineColor = espColor
	object.Highlight.FillTransparency = espFillTransparency
	object.Highlight.DepthMode = espThroughWalls and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded

	local bodyHeight = math.clamp(math.abs(bottomPosition.Y - topPosition.Y), 45, 320)
	local bodyWidth = math.clamp(bodyHeight * 0.42, 20, 150)
	local baseX = topPosition.X
	local topY = topPosition.Y

	object.NameText.Visible = espShowNames
	object.NameText.Text = player.DisplayName ~= player.Name and (player.DisplayName .. " @" .. player.Name) or player.Name
	object.NameText.Color = espColor
	object.NameText.Position = Vector2.new(baseX, topY - 18)

	object.DistanceText.Visible = espShowDistance
	object.DistanceText.Text = tostring(distance) .. "m"
	object.DistanceText.Color = espColor
	object.DistanceText.Position = Vector2.new(baseX, bottomPosition.Y + 3)

	local healthPercent = math.clamp(humanoid.Health / math.max(humanoid.MaxHealth, 1), 0, 1)
	local healthHeight = math.max(bodyHeight * healthPercent, 2)
	local barX = baseX - (bodyWidth / 2) - 8
	local barY = topY

	object.HealthBack.Visible = espShowHealth
	object.HealthBack.Position = Vector2.new(barX, barY)
	object.HealthBack.Size = Vector2.new(4, bodyHeight)

	object.HealthBar.Visible = espShowHealth
	object.HealthBar.Position = Vector2.new(barX, barY + (bodyHeight - healthHeight))
	object.HealthBar.Size = Vector2.new(4, healthHeight)
	object.HealthBar.Color = Color3.fromRGB(math.floor(255 - (healthPercent * 165)), math.floor(90 + (healthPercent * 165)), 90)

	object.HealthText.Visible = espShowHealth
	object.HealthText.Text = math.floor(humanoid.Health) .. " HP"
	object.HealthText.Color = object.HealthBar.Color
	object.HealthText.Position = Vector2.new(baseX, topY - 34)

	object.Tracer.Visible = espShowTracers
	object.Tracer.Color = espColor
	object.Tracer.From = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y - 8)
	object.Tracer.To = Vector2.new(rootPosition.X, rootPosition.Y)
end

local function startEsp()
	if espConnection then return end
	espConnection = RunService.RenderStepped:Connect(function()
		for _, player in ipairs(Players:GetPlayers()) do
			updateEspObject(player)
		end
	end)
end

local function stopEsp()
	if espConnection then
		espConnection:Disconnect()
		espConnection = nil
	end

	for player in pairs(espObjects) do
		destroyEspObject(player)
	end
end

Players.PlayerRemoving:Connect(destroyEspObject)

espTab:CreateToggle({
	Text = "Enable ESP",
	Description = "Highlights enemy character bodies and optional info.",
	Default = false,
	Callback = function(value)
		espEnabled = value
		if value then
			startEsp()
		else
			stopEsp()
		end
	end,
})

createColorControl(espTab, "ESP Color", espColor, function(color)
	espColor = color
end)

espTab:CreateSlider({
	Text = "Body Fill",
	Min = 0,
	Max = 100,
	Default = 15,
	Increment = 1,
	Suffix = "%",
	Callback = function(value)
		espFillTransparency = 1 - (value / 100)
	end,
})

espTab:CreateSlider({
	Text = "Max Distance",
	Min = 100,
	Max = 5000,
	Default = 2000,
	Increment = 100,
	Suffix = " stud",
	Callback = function(value)
		espMaxDistance = value
	end,
})

espTab:CreateSection("ESP Details")

espTab:CreateToggle({
	Text = "Team Check",
	Description = "Hide teammates from ESP.",
	Default = true,
	Callback = function(value)
		espTeamCheck = value
	end,
})

espTab:CreateToggle({
	Text = "Show Names",
	Description = "Display player names above bodies.",
	Default = true,
	Callback = function(value)
		espShowNames = value
	end,
})

espTab:CreateToggle({
	Text = "Show Distance",
	Description = "Display distance under each player.",
	Default = true,
	Callback = function(value)
		espShowDistance = value
	end,
})

espTab:CreateToggle({
	Text = "Show Health",
	Description = "Display health bar and health text.",
	Default = true,
	Callback = function(value)
		espShowHealth = value
	end,
})

espTab:CreateToggle({
	Text = "Show Tracers",
	Description = "Draw lines from the bottom of the screen to players.",
	Default = false,
	Callback = function(value)
		espShowTracers = value
	end,
})

espTab:CreateToggle({
	Text = "Through Walls",
	Description = "Keep outlines visible through map geometry.",
	Default = true,
	Callback = function(value)
		espThroughWalls = value
	end,
})

-- ===== COMBAT TAB =====
local combatTab = win:CreateTab({
	Name = "Combat",
	Icon = "rbxassetid://104214411068348",
})

combatTab:CreateSection("Aimbot")

local aimbotEnabled = false
local fov = 1000
local maxDistance = 400
local maxTransparency = 0.1
local teamCheck = true
local visibleCheck = true
local aimPartName = "Head"
local aimSmoothing = 1
local showFovRing = true

local FOVring = Drawing.new("Circle")  
FOVring.Visible = false  
FOVring.Thickness = 2  
FOVring.Color = Color3.fromRGB(128, 0, 128)  
FOVring.Filled = false  
FOVring.Radius = fov  
FOVring.Position = Cam.ViewportSize / 2  

local function updateDrawings()  
	Cam = workspace.CurrentCamera or Cam
	FOVring.Position = Cam.ViewportSize / 2  
end  

local function lookAt(target)
	local targetCFrame = CFrame.new(Cam.CFrame.Position, target)
	Cam.CFrame = Cam.CFrame:Lerp(targetCFrame, aimSmoothing)
end  

local function calculateTransparency(distance)  
	return (1 - (distance / fov)) * maxTransparency  
end  

local function isPlayerAlive(player)  
	local character = player.Character  
	return character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0  
end  

local function isVisible(part)
	if not visibleCheck then return true end

	local origin = Cam.CFrame.Position
	local direction = part.Position - origin
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Blacklist
	params.FilterDescendantsInstances = { LocalPlayer.Character }

	local result = workspace:Raycast(origin, direction, params)
	return result and result.Instance and result.Instance:IsDescendantOf(part.Parent)
end  

local function getClosestVisiblePlayerInFOV(trg_part)  
	local nearest, last = nil, math.huge  
	local playerMousePos = Cam.ViewportSize / 2  
	local localPlayer = Players.LocalPlayer  

	for _, player in ipairs(Players:GetPlayers()) do  
		if player ~= localPlayer and (not teamCheck or player.Team ~= localPlayer.Team) then  
			if isPlayerAlive(player) then  
				local part = player.Character and player.Character:FindFirstChild(trg_part)  
				if part and isVisible(part) then  
					local ePos = Cam:WorldToViewportPoint(part.Position)  
					local distance = (Vector2.new(ePos.X, ePos.Y) - playerMousePos).Magnitude  
					if distance < last and distance < fov and distance < maxDistance then  
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
	local target = getClosestVisiblePlayerInFOV(aimPartName)
	local aimPart = target and target.Character and target.Character:FindFirstChild(aimPartName)
	if target and aimPart then
		lookAt(aimPart.Position)
		local ePos = Cam:WorldToViewportPoint(aimPart.Position)
		local distance = (Vector2.new(ePos.X, ePos.Y) - (Cam.ViewportSize / 2)).Magnitude  
		FOVring.Transparency = calculateTransparency(distance)  
	else  
		FOVring.Transparency = maxTransparency  
	end  
end  

combatTab:CreateToggle({
	Text = "Aimbot",
	Description = "Auto aim to closest player",
	Default = false,
	Callback = function(Value)
		aimbotEnabled = Value
		FOVring.Visible = Value and showFovRing

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

combatTab:CreateSlider({
	Text      = "Aimbot FOV",
	Min       = 100,
	Max       = 2000,
	Default   = 1000,
	Increment = 50,
	Suffix    = " px",
	Callback  = function(v)
		fov = v
		FOVring.Radius = fov
	end,
})

combatTab:CreateSlider({
	Text      = "Max Distance",
	Min       = 100,
	Max       = 1000,
	Default   = 400,
	Increment = 50,
	Suffix    = " stud",
	Callback  = function(v)
		maxDistance = v
	end,
})

combatTab:CreateSlider({
	Text = "Aim Smoothness",
	Min = 1,
	Max = 100,
	Default = 100,
	Increment = 1,
	Suffix = "%",
	Callback = function(v)
		aimSmoothing = math.clamp(v / 100, 0.01, 1)
	end,
})

combatTab:CreateDropdown({
	Text = "Aim Part",
	Options = { "Head", "HumanoidRootPart", "UpperTorso", "Torso" },
	Default = "Head",
	Callback = function(v)
		aimPartName = v
	end,
})

combatTab:CreateToggle({
	Text        = "Team Check",
	Description = "Only target enemy team",
	Default     = true,
	Callback    = function(v)
		teamCheck = v
	end,
})

combatTab:CreateToggle({
	Text = "Visible Check",
	Description = "Only lock to players with a clear line of sight.",
	Default = true,
	Callback = function(v)
		visibleCheck = v
	end,
})

combatTab:CreateToggle({
	Text = "Show FOV Ring",
	Description = "Toggle the aimbot FOV circle.",
	Default = true,
	Callback = function(v)
		showFovRing = v
		FOVring.Visible = aimbotEnabled and v
	end,
})

createColorControl(combatTab, "FOV Ring Color", FOVring.Color, function(color)
	FOVring.Color = color
end)

-- ===== WEAPONS TAB =====
local weaponsTab = win:CreateTab({
	Name = "Weapons",
	Icon = "rbxassetid://104214411068348",
})

weaponsTab:CreateSection("Ammo")

local infiniteAmmoConnection = nil

local function infiniteAmmoFunction()
	local player = game:GetService("Players").LocalPlayer
	local playerGui = player:FindFirstChild("PlayerGui")
	if playerGui then
		local gui = playerGui:FindFirstChild("GUI")
		if gui and gui:FindFirstChild("Client") and gui.Client:FindFirstChild("Variables") then
			local variables = gui.Client.Variables
			if variables:FindFirstChild("ammocount") and variables:FindFirstChild("ammocount2") then
				variables.ammocount.Value = 99
				variables.ammocount2.Value = 99
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

local originalValues = {
	ReloadTime = {},
	EReloadTime = {},
	FireRate = {},
	Spread = {},
	Recoil = {}
}

weaponsTab:CreateSection("Weapon Tuning")

weaponsTab:CreateToggle({
	Text        = "Fast Reload",
	Description = "Speed up weapon reload time",
	Default     = false,
	Callback    = function(Value)
		local weaponsFolder = game.ReplicatedStorage:FindFirstChild("Weapons")
		if not weaponsFolder then return end

		for _, weapon in pairs(weaponsFolder:GetChildren()) do
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

weaponsTab:CreateToggle({
	Text = "No Recoil / Spread",
	Description = "Attempts to remove weapon recoil and spread values.",
	Default = false,
	Callback = function(Value)
		local weaponsFolder = game.ReplicatedStorage:FindFirstChild("Weapons")
		if not weaponsFolder then return end

		for _, weapon in pairs(weaponsFolder:GetChildren()) do
			for _, valueObject in pairs(weapon:GetDescendants()) do
				local lowerName = string.lower(valueObject.Name)
				if valueObject:IsA("NumberValue") or valueObject:IsA("IntValue") then
					if string.find(lowerName, "recoil") or string.find(lowerName, "spread") then
						originalValues[valueObject.Name] = originalValues[valueObject.Name] or {}
						if Value and originalValues[valueObject.Name][valueObject] == nil then
							originalValues[valueObject.Name][valueObject] = valueObject.Value
						end
						valueObject.Value = Value and 0 or (originalValues[valueObject.Name][valueObject] or valueObject.Value)
					end
				end
			end
		end

		HelixiaHUB:Notify({
			Title = "Weapon Stability",
			Message = Value and "Enabled" or "Disabled",
			Type = "Success",
			Duration = 2,
		})
	end,
})

weaponsTab:CreateToggle({
	Text = "Fast Fire Rate",
	Description = "Attempts to speed up compatible weapon fire-rate values.",
	Default = false,
	Callback = function(Value)
		local weaponsFolder = game.ReplicatedStorage:FindFirstChild("Weapons")
		if not weaponsFolder then return end

		for _, weapon in pairs(weaponsFolder:GetChildren()) do
			for _, valueObject in pairs(weapon:GetDescendants()) do
				local lowerName = string.lower(valueObject.Name)
				if (valueObject:IsA("NumberValue") or valueObject:IsA("IntValue")) and (string.find(lowerName, "firerate") or string.find(lowerName, "fire rate") or string.find(lowerName, "cooldown")) then
					originalValues.FireRate[valueObject] = originalValues.FireRate[valueObject] or valueObject.Value
					valueObject.Value = Value and 0.03 or originalValues.FireRate[valueObject]
				end
			end
		end

		HelixiaHUB:Notify({
			Title = "Fast Fire Rate",
			Message = Value and "Enabled" or "Disabled",
			Type = "Success",
			Duration = 2,
		})
	end,
})

-- ===== SETTINGS TAB =====
local settingsTab = win:CreateTab({
	Name = "Settings",
	Icon = "rbxassetid://119673892841288",
})

settingsTab:CreateSection("Theme")

settingsTab:CreateDropdown({
	Text     = "Select Theme",
	Options  = themeNames,
	Default  = "Midnight",
	Callback = function(v)
		HelixiaHUB.Theme:SetPalette(v)
		HelixiaHUB:Notify({
			Title    = "Theme Changed",
			Message  = v .. " theme applied.",
			Type     = "Success",
			Duration = 2,
		})
	end,
})

settingsTab:CreateSection("Window")

settingsTab:CreateToggle({
	Text        = "Background Blur",
	Description = "Toggles the blur effect behind the window",
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
	Text        = "Helixia HUB v2.0 - Enhanced",
	Description = "Built with the HelixiaHUB library + Rayfield features.",
	Callback    = function()
		HelixiaHUB:Notify({
			Title    = "Helixia HUB",
			Message  = "v2.0 Enhanced - Features merged successfully!",
			Type     = "Info",
			Duration = 3,
		})
	end,
})

-- ===== STARTUP NOTIFICATION =====
task.delay(0.8, function()
	HelixiaHUB:Notify({
		Title    = "Helixia HUB",
		Message  = "Welcome the Helixia HUB.",
		Type     = "Success",
		Duration = 5,
	})
end)
