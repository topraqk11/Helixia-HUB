local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/topraqk1/helixia-hub/refs/heads/main/Scripts/library.lua"))()

local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name or "Unknown Game"

local Window = Rayfield:CreateWindow({
   Name = "Helixia Hub | " .. gameName,
   Icon = "gamepad",
   LoadingTitle = "Helixia Hub",
   LoadingSubtitle = "discord.gg/JRzMYAWvUZ",
   Theme = "Default",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "HelixiaHub",
      FileName = "Config"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },

   KeySystem = false,
   KeySettings = {
      Title = "Helixia Hub",
      Subtitle = "Key System",
      Note = "Anahtar almak için özel bilgi verilmemiş",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

local MainTab = Window:CreateTab("Home", "home")
MainTab:CreateSection("General")

MainTab:CreateButton({
   Name = "Rejoin Server",
   Callback = function()
      local ts = game:GetService("TeleportService")
      local placeId = game.PlaceId
      ts:Teleport(placeId, game.Players.LocalPlayer)
   end,
})

MainTab:CreateButton({
   Name = "Hop to New Server",
   Callback = function()
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

local PlayerTab = Window:CreateTab("Player", "user")
PlayerTab:CreateSection("Player Settings")

local player = game.Players.LocalPlayer
local character = function() return player.Character or player.CharacterAdded:Wait() end

PlayerTab:CreateSlider({
   Name = "Walk Speed",
   Range = {16, 250},
   Increment = 1,
   CurrentValue = 16,
   Flag = "Slider1",
   Callback = function(Value)
      character():WaitForChild("Humanoid").WalkSpeed = Value
   end,
})

PlayerTab:CreateSlider({
   Name = "Jump Power",
   Range = {50, 300},
   Increment = 5,
   CurrentValue = 50,
   Flag = "Slider1",
   Callback = function(Value)
      character():WaitForChild("Humanoid").JumpPower = Value
   end,
})

local infiniteJumpEnabled = false

PlayerTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(Value)
      infiniteJumpEnabled = Value
      if infiniteJumpEnabled then
         Rayfield:Notify({
            Title = "Infinite Jump",
            Content = "Enabled",
            Duration = 3
         })
      else
         Rayfield:Notify({
            Title = "Infinite Jump",
            Content = "Disabled",
            Duration = 3
         })
      end
   end,
})

local UIS = game:GetService("UserInputService")
UIS.JumpRequest:Connect(function()
   if infiniteJumpEnabled then
      character():WaitForChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
   end
end)

local GameTab = Window:CreateTab("Game", "crosshair")
GameTab:CreateSection("ESP")

local espBoxTable = {}  
local runServiceConnection = nil  
  
GameTab:CreateToggle({  
  Name = "ESP",  
  CurrentValue = false,  
  Callback = function (Value)  
    if Value then  
      runServiceConnection = game:GetService("RunService").RenderStepped:Connect(function()  
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do  
          if player ~= game.Players.LocalPlayer and player.Team ~= game.Players.LocalPlayer.Team and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then  
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")  
            local espBox = espBoxTable[player]  
  
            if not espBox then  
              espBox = Instance.new("BoxHandleAdornment")  
              espBox.Size = rootPart.Size + Vector3.new(5, 5, 5)  
              espBox.Adornee = rootPart  
              espBox.AlwaysOnTop = true  
              espBox.ZIndex = 10  
              espBox.Transparency = 0.8  
              espBox.Color3 = Color3.new(1, 0, 0)  
              espBox.Parent = rootPart  
              espBoxTable[player] = espBox  
            end  
          end  
        end  
  
        for player, espBox in pairs(espBoxTable) do  
          if not player.Character or player.Team == game.Players.LocalPlayer.Team or not player.Character:FindFirstChild("HumanoidRootPart") then  
            espBox:Destroy()  
            espBoxTable[player] = nil  
          end  
        end  
      end)  
    else  
      if runServiceConnection then  
        runServiceConnection:Disconnect()  
        runServiceConnection = nil  
      end  
      for _, espBox in pairs(espBoxTable) do  
        espBox:Destroy()  
      end  
      espBoxTable = {}  
    end  
  end  
})

GameTab:CreateSection("AimBot")
local aimbotEnabled = false  
  
local fov = 1000  
local maxDistance = 400  
local maxTransparency = 0.1  
local teamCheck = true  
  
local RunService = game:GetService("RunService")  
local UserInputService = game:GetService("UserInputService")  
local Players = game:GetService("Players")  
local Cam = workspace.CurrentCamera  
  
local FOVring = Drawing.new("Circle")  
FOVring.Visible = false  
FOVring.Thickness = 2  
FOVring.Color = Color3.fromRGB(128, 0, 128)  
FOVring.Filled = false  
FOVring.Radius = fov  
FOVring.Position = Cam.ViewportSize / 2  
  
local function updateDrawings()  
    FOVring.Position = Cam.ViewportSize / 2  
end  
  
local function lookAt(target)  
    local lookVector = (target - Cam.CFrame.Position).unit  
    Cam.CFrame = CFrame.new(Cam.CFrame.Position, Cam.CFrame.Position + lookVector)  
end  
  
local function calculateTransparency(distance)  
    return (1 - (distance / fov)) * maxTransparency  
end  
  
local function isPlayerAlive(player)  
    local character = player.Character  
    return character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0  
end  
  
local function isVisible(part)  
    local origin = Cam.CFrame.Position  
    local direction = (part.Position - origin).unit * maxDistance  
    local ray = Ray.new(origin, direction)  
    local hit = workspace:FindPartOnRay(ray, Players.LocalPlayer.Character)  
    return hit and hit:IsDescendantOf(part.Parent)  
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
    local target = getClosestVisiblePlayerInFOV("Head")  
    if target and target.Character and target.Character:FindFirstChild("Head") then  
        lookAt(target.Character.Head.Position)  
        local ePos = Cam:WorldToViewportPoint(target.Character.Head.Position)  
        local distance = (Vector2.new(ePos.X, ePos.Y) - (Cam.ViewportSize / 2)).Magnitude  
        FOVring.Transparency = calculateTransparency(distance)  
    else  
        FOVring.Transparency = maxTransparency  
    end  
end  

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Delete then
        RunService:UnbindFromRenderStep("AimbotUpdate")
        FOVring:Remove()
        aimbotEnabled = false
    end
end)

GameTab:CreateToggle({
    Name = "AimBot",
    CurrentValue = false,
    Callback = function(Value)
        aimbotEnabled = Value
        FOVring.Visible = Value

        if Value then
            RunService:BindToRenderStep("AimbotUpdate", Enum.RenderPriority.Camera.Value, aimbotFunction)
            Rayfield:Notify({
                Title = "Aimbot",
                Content = "Enabled",
                Duration = 3
            })
        else
            RunService:UnbindFromRenderStep("AimbotUpdate")
            FOVring.Visible = false
            Rayfield:Notify({
                Title = "Aimbot",
                Content = "Disabled",
                Duration = 3
            })
        end
    end,
})

GameTab:CreateDivider()

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

GameTab:CreateToggle({
    Name = "Infinite Ammo",
    CurrentValue = false,
    Callback = function(Value)
        if Value and not infiniteAmmoConnection then
            infiniteAmmoConnection = game:GetService("RunService").Stepped:Connect(infiniteAmmoFunction)
            Rayfield:Notify({
                Title = "Infinite Ammo",
                Content = "Enabled",
                Duration = 3
            })
        elseif not Value and infiniteAmmoConnection then
            infiniteAmmoConnection:Disconnect()
            infiniteAmmoConnection = nil
            Rayfield:Notify({
                Title = "Infinite Ammo",
                Content = "Disabled",
                Duration = 3
            })
        end
    end,
})

local originalValues = {
    ReloadTime = {},
    EReloadTime = {}
}

GameTab:CreateToggle({
    Name = "Fast Reload",
    CurrentValue = false,
    Callback = function(Value)
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

        Rayfield:Notify({
            Title = "Fast Reload",
            Content = Value and "Enabled" or "Disabled",
            Duration = 3
        })
    end,
})
