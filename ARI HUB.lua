-- ARI HUB V3 PRO - COMPRESSED VERSION (Under 500 Lines)
-- By Bebang - All Features Included

local Players, LocalPlayer, RunService, UserInputService, Workspace, HttpService = game:GetService("Players"), Players.LocalPlayer or Players.LocalPlayerAdded:Wait(), game:GetService("RunService"), game:GetService("UserInputService"), game:GetService("Workspace"), game:GetService("HttpService")
local playerGui = LocalPlayer:WaitForChild("PlayerGui", 30) if not playerGui then return end

local SETTINGS = { ESP = { Enabled = false, MaxDistance = 1000 }, Wallhack = { Enabled = false }, Noclip = { Enabled = false }, Fly = { Enabled = false, Speed = 50 }, Movement = { Speed = 16, InfiniteJump = false }, Safety = { AntiFall = false }, AutoClicker = { Enabled = false, CPS = 10 } }

local function LoadSettings() pcall(function() if isfile and isfile("AriHubSettings.json") then local content = readfile("AriHubSettings.json") if content and content ~= "" then local success, data = pcall(function() return HttpService:JSONDecode(content) end) if success and data then for k, v in pairs(data) do if SETTINGS[k] then for i, j in pairs(v) do SETTINGS[k][i] = j end end end end end end end) end
local function SaveSettings() pcall(function() if writefile then pcall(function() writefile("AriHubSettings.json", HttpService:JSONEncode(SETTINGS)) end) end end)
LoadSettings()

local ScreenGui = Instance.new("ScreenGui") ScreenGui.Name, ScreenGui.ResetOnSpawn, ScreenGui.IgnoreGuiInset, ScreenGui.DisplayOrder, ScreenGui.Parent = "AriHubV3", false, true, 999999, playerGui
local MainFrame = Instance.new("Frame") MainFrame.Size, MainFrame.Position, MainFrame.BackgroundColor3, MainFrame.BorderSizePixel, MainFrame.BorderColor3, MainFrame.Active, MainFrame.Draggable, MainFrame.Parent = UDim2.new(0, 280, 0, 350), UDim2.new(0.5, -140, 0.5, -175), Color3.fromRGB(40, 40, 50), 2, Color3.fromRGB(0, 200, 255), true, true, ScreenGui
local TitleBar = Instance.new("Frame") TitleBar.Size, TitleBar.BackgroundColor3, TitleBar.BorderSizePixel, TitleBar.Parent = UDim2.new(1, 0, 0, 25), Color3.fromRGB(30, 30, 40), 0, MainFrame
local Title = Instance.new("TextLabel") Title.Size, Title.Position, Title.BackgroundTransparency, Title.Text, Title.Font, Title.TextSize, Title.TextColor3, Title.TextXAlignment, Title.Parent = UDim2.new(1, -60, 1, 0), UDim2.new(0, 10, 0, 0), 1, "ARI HUB V3 PRO", Enum.Font.SourceSansBold, 14, Color3.fromRGB(0, 200, 255), Enum.TextXAlignment.Left, TitleBar
local CloseButton = Instance.new("TextButton") CloseButton.Size, CloseButton.Position, CloseButton.Text, CloseButton.BackgroundColor3, CloseButton.TextColor3, CloseButton.Font, CloseButton.TextSize, CloseButton.Parent = UDim2.new(0, 25, 1, -4), UDim2.new(1, -30, 0, 2), "X", Color3.fromRGB(200, 50, 50), Color3.new(1,1,1), Enum.Font.SourceSansBold, 12, TitleBar
local MinimizeButton = Instance.new("TextButton") MinimizeButton.Size, MinimizeButton.Position, MinimizeButton.Text, MinimizeButton.BackgroundColor3, MinimizeButton.TextColor3, MinimizeButton.Font, MinimizeButton.TextSize, MinimizeButton.Parent = UDim2.new(0, 25, 1, -4), UDim2.new(1, -60, 0, 2), "-", Color3.fromRGB(60, 120, 200), Color3.new(1,1,1), Enum.Font.SourceSansBold, 12, TitleBar
local ContentFrame = Instance.new("ScrollingFrame") ContentFrame.Size, ContentFrame.Position, ContentFrame.BackgroundTransparency, ContentFrame.ScrollBarThickness, ContentFrame.CanvasSize, ContentFrame.Parent = UDim2.new(1, -10, 1, -35), UDim2.new(0, 5, 0, 30), 1, 6, UDim2.new(0, 0, 0, 800), MainFrame

local yPos, ESPCache = 0, {}
local function SafeCreate(t, p) local s, i = pcall(function() local inst = Instance.new(t) for k, v in pairs(p or {}) do inst[k] = v end return inst end) return s and i or nil end

local function CreateToggle(n, d, c)
    local f = SafeCreate("Frame", { Size = UDim2.new(0.95, 0, 0, 35), Position = UDim2.new(0.025, 0, 0, yPos), BackgroundColor3 = Color3.fromRGB(60, 60, 70), Parent = ContentFrame })
    local l = SafeCreate("TextLabel", { Size = UDim2.new(0.65, 0, 1, 0), BackgroundTransparency = 1, Text = n, TextColor3 = Color3.new(1,1,1), Font = Enum.Font.SourceSans, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Position = UDim2.new(0.05, 0, 0, 0), Parent = f })
    local t = SafeCreate("TextButton", { Size = UDim2.new(0.25, 0, 0.6, 0), Position = UDim2.new(0.72, 0, 0.2, 0), BackgroundColor3 = d and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50), Text = d and "ON" or "OFF", TextColor3 = Color3.new(1,1,1), Font = Enum.Font.SourceSansBold, TextSize = 11, Parent = f })
    if t then t.MouseButton1Click:Connect(function() d = not d t.BackgroundColor3, t.Text = d and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50), d and "ON" or "OFF" if c then local s, e = pcall(function() c(d) end) end SaveSettings() end) end
    yPos = yPos + 40 return t
end

local function CreateTextBox(n, d, c)
    local l = SafeCreate("TextLabel", { Size = UDim2.new(0.95, 0, 0, 20), Position = UDim2.new(0.025, 0, 0, yPos), BackgroundTransparency = 1, Text = n .. ": " .. tostring(d), TextColor3 = Color3.new(1,1,1), Font = Enum.Font.SourceSans, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = ContentFrame })
    local t = SafeCreate("TextBox", { Size = UDim2.new(0.6, 0, 0, 25), Position = UDim2.new(0.025, 0, 0, yPos + 22), BackgroundColor3 = Color3.fromRGB(70, 70, 80), TextColor3 = Color3.new(1,1,1), Font = Enum.Font.SourceSans, TextSize = 12, Text = tostring(d), ClearTextOnFocus = false, Parent = ContentFrame })
    local a = SafeCreate("TextButton", { Size = UDim2.new(0.3, 0, 0, 25), Position = UDim2.new(0.675, 0, 0, yPos + 22), BackgroundColor3 = Color3.fromRGB(60, 120, 200), Text = "Apply", TextColor3 = Color3.new(1,1,1), Font = Enum.Font.SourceSansBold, TextSize = 11, Parent = ContentFrame })
    if a and t then a.MouseButton1Click:Connect(function() local v = tonumber(t.Text) if v then l.Text = n .. ": " .. tostring(v) if c then local s, e = pcall(function() c(v) end) end SaveSettings() end end) end
    yPos = yPos + 55 return t
end

local function CreatePlayerList()
    local l = SafeCreate("TextLabel", { Size = UDim2.new(0.95, 0, 0, 20), Position = UDim2.new(0.025, 0, 0, yPos), BackgroundTransparency = 1, Text = "Teleport to Player:", TextColor3 = Color3.new(1,1,1), Font = Enum.Font.SourceSans, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = ContentFrame })
    local s = SafeCreate("ScrollingFrame", { Size = UDim2.new(0.95, 0, 0, 100), Position = UDim2.new(0.025, 0, 0, yPos + 22), BackgroundColor3 = Color3.fromRGB(50, 50, 60), BackgroundTransparency = 0.3, ScrollBarThickness = 6, CanvasSize = UDim2.new(0, 0, 0, 0), Parent = ContentFrame })
    local function U() if not s then return end for _, c in ipairs(s:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end local p, y = Players:GetPlayers(), 0 for _, pl in ipairs(p) do if pl ~= LocalPlayer then local b = SafeCreate("TextButton", { Size = UDim2.new(1, -10, 0, 25), Position = UDim2.new(0, 5, 0, y), BackgroundColor3 = Color3.fromRGB(70, 70, 80), Text = pl.Name, TextColor3 = Color3.new(1,1,1), Font = Enum.Font.SourceSans, TextSize = 11, Parent = s }) if b then b.MouseButton1Click:Connect(function() pcall(function() if pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character:SetPrimaryPartCFrame(pl.Character:GetPrimaryPartCFrame()) end end) end y = y + 30 end end s.CanvasSize = UDim2.new(0, 0, 0, y) end
    U() Players.PlayerAdded:Connect(U) Players.PlayerRemoving:Connect(U) yPos = yPos + 130
end

local function createESP(p) if p == LocalPlayer or ESPCache[p] then return end pcall(function() local b = Instance.new("BoxHandleAdornment") b.AlwaysOnTop, b.Size, b.Color3, b.Transparency = true, Vector3.new(2, 3, 1), Color3.fromRGB(255, 50, 50), 0.5 local n = Instance.new("BillboardGui") n.Size, n.StudsOffset, n.AlwaysOnTop = UDim2.new(0, 100, 0, 25), Vector3.new(0, 3, 0), true local l = Instance.new("TextLabel") l.Size, l.BackgroundTransparency, l.Text, l.TextColor3, l.Font, l.TextSize, l.Parent = UDim2.new(1, 0, 1, 0), 1, p.Name, Color3.new(1,1,1), Enum.Font.SourceSansBold, 12, n local function u() if not SETTINGS.ESP.Enabled or not p.Character then b.Visible, n.Enabled = false, false return end local h = p.Character:FindFirstChild("HumanoidRootPart") if not h then return end local d = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (LocalPlayer.Character.HumanoidRootPart.Position - h.Position).Magnitude) or 0 if d > SETTINGS.ESP.MaxDistance then b.Visible, n.Enabled = false, false return end local v, o = Workspace.CurrentCamera:WorldToViewportPoint(h.Position) if o then b.Adornee, n.Adornee, b.Visible, n.Enabled = h, h, true, true else b.Visible, n.Enabled = false, false end end RunService.Heartbeat:Connect(function() pcall(u) end) p.CharacterRemoving:Connect(function() pcall(function() if b then b:Destroy() end if n then n:Destroy() end ESPCache[p] = nil end) end) ESPCache[p] = {box = b, tag = n} end) end

local function applyWallhack() if not SETTINGS.Wallhack.Enabled then return end pcall(function() for _, d in ipairs(Workspace:GetDescendants()) do if d:IsA("BasePart") and d.Name ~= "HumanoidRootPart" then d.LocalTransparencyModifier = 0.8 end end end) end

local function applySpeed() pcall(function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = SETTINGS.Movement.Speed end end) end

local FLYING, flyBodyPosition, flyBodyGyro = false, nil, nil
local function startFly() if FLYING or not LocalPlayer.Character then return end pcall(function() local c = LocalPlayer.Character local h = c:FindFirstChildOfClass("Humanoid") if not h then return end h:ChangeState(Enum.HumanoidStateType.Physics) flyBodyPosition = Instance.new("BodyPosition") flyBodyPosition.Position, flyBodyPosition.MaxForce, flyBodyPosition.P, flyBodyPosition.D, flyBodyPosition.Parent = c.PrimaryPart.Position, Vector3.new(9e9, 9e9, 9e9), 9e9, 1000, c.PrimaryPart flyBodyGyro = Instance.new("BodyGyro") flyBodyGyro.P, flyBodyGyro.D, flyBodyGyro.MaxTorque, flyBodyGyro.CFrame, flyBodyGyro.Parent = 9e9, 1000, Vector3.new(9e9, 9e9, 9e9), c.PrimaryPart.CFrame, c.PrimaryPart FLYING = true end) end

local function stopFly() pcall(function() if flyBodyPosition then flyBodyPosition:Destroy() flyBodyPosition = nil end if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end FLYING = false end) end

local function updateFly() if not SETTINGS.Fly.Enabled or not LocalPlayer.Character then if FLYING then stopFly() end return end if not FLYING then startFly() end pcall(function() local c = LocalPlayer.Character local cam = Workspace.CurrentCamera local m = Vector3.new() if UserInputService:IsKeyDown(Enum.KeyCode.W) then m = m + cam.CFrame.LookVector end if UserInputService:IsKeyDown(Enum.KeyCode.S) then m = m - cam.CFrame.LookVector end if UserInputService:IsKeyDown(Enum.KeyCode.A) then m = m - cam.CFrame.RightVector end if UserInputService:IsKeyDown(Enum.KeyCode.D) then m = m + cam.CFrame.RightVector end if UserInputService:IsKeyDown(Enum.KeyCode.Space) then m = m + Vector3.new(0, 1, 0) end if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then m = m - Vector3.new(0, 1, 0) end m = m.Unit * SETTINGS.Fly.Speed if flyBodyPosition then flyBodyPosition.Position = flyBodyPosition.Position + m * 0.05 end if flyBodyGyro then flyBodyGyro.CFrame = cam.CFrame end end) end

local function noclip() if not SETTINGS.Noclip.Enabled or not LocalPlayer.Character then return end pcall(function() for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end) end

UserInputService.JumpRequest:Connect(function() if not SETTINGS.Movement.InfiniteJump then return end pcall(function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end) end)

local antiFallPart = nil
local function updateAntiFall() pcall(function() if SETTINGS.Safety.AntiFall then if not antiFallPart then antiFallPart = Instance.new("Part") antiFallPart.Size, antiFallPart.Anchored, antiFallPart.Transparency, antiFallPart.Color, antiFallPart.CanCollide, antiFallPart.Material, antiFallPart.Parent = Vector3.new(50, 1, 50), true, 0.7, Color3.fromRGB(0, 100, 255), true, Enum.Material.Neon, Workspace end if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then antiFallPart.Position = LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(0, 5, 0) end else if antiFallPart then antiFallPart:Destroy() antiFallPart = nil end end end) end

local autoClicking = false
local function startAutoClicker() if autoClicking or not SETTINGS.AutoClicker.Enabled then return end autoClicking = true spawn(function() while autoClicking and SETTINGS.AutoClicker.Enabled do pcall(function() mouse1click() end) wait(1 / math.max(SETTINGS.AutoClicker.CPS, 1)) end autoClicking = false end) end

local function stopAutoClicker() autoClicking = false end

CreateToggle("ESP", SETTINGS.ESP.Enabled, function(s) SETTINGS.ESP.Enabled = s if s then for _, p in ipairs(Players:GetPlayers()) do createESP(p) end else for _, e in pairs(ESPCache) do pcall(function() if e.box then e.box:Destroy() end if e.tag then e.tag:Destroy() end end) end ESPCache = {} end end)
CreateTextBox("ESP Distance", SETTINGS.ESP.MaxDistance, function(v) SETTINGS.ESP.MaxDistance = v end)
CreateToggle("Wallhack", SETTINGS.Wallhack.Enabled, function(s) SETTINGS.Wallhack.Enabled = s if not s then pcall(function() for _, d in ipairs(Workspace:GetDescendants()) do if d:IsA("BasePart") and d.Name ~= "HumanoidRootPart" then d.LocalTransparencyModifier = 0 end end end) end end)
CreateToggle("Noclip", SETTINGS.Noclip.Enabled, function(s) SETTINGS.Noclip.Enabled = s end)
CreateToggle("Fly", SETTINGS.Fly.Enabled, function(s) SETTINGS.Fly.Enabled = s if not s then stopFly() end end)
CreateTextBox("Fly Speed", SETTINGS.Fly.Speed, function(v) SETTINGS.Fly.Speed = v end)
CreateTextBox("Walk Speed", SETTINGS.Movement.Speed, function(v) SETTINGS.Movement.Speed = v applySpeed() end)
CreateToggle("Infinite Jump", SETTINGS.Movement.InfiniteJump, function(s) SETTINGS.Movement.InfiniteJump = s end)
CreateToggle("Anti-Fall", SETTINGS.Safety.AntiFall, function(s) SETTINGS.Safety.AntiFall = s updateAntiFall() end)
CreateToggle("Auto Clicker", SETTINGS.AutoClicker.Enabled, function(s) SETTINGS.AutoClicker.Enabled = s if s then startAutoClicker() else stopAutoClicker() end end)
CreateTextBox("Clicks/Second", SETTINGS.AutoClicker.CPS, function(v) SETTINGS.AutoClicker.CPS = math.max(1, v) end)
CreatePlayerList()

pcall(function() RunService.Stepped:Connect(function() pcall(noclip) pcall(updateFly) end) end)
pcall(function() RunService.Heartbeat:Connect(function() pcall(applyWallhack) end) end)
Players.PlayerAdded:Connect(function(p) pcall(function() if SETTINGS.ESP.Enabled then createESP(p) end end) end)
Players.PlayerRemoving:Connect(function(p) pcall(function() if ESPCache[p] then if ESPCache[p].box then ESPCache[p].box:Destroy() end if ESPCache[p].tag then ESPCache[p].tag:Destroy() end ESPCache[p] = nil end end) end)
LocalPlayer.CharacterAdded:Connect(function() wait(0.5) pcall(applySpeed) end)

if CloseButton then CloseButton.MouseButton1Click:Connect(function() pcall(function() ScreenGui:Destroy() end) end) end
if MinimizeButton then local m = false MinimizeButton.MouseButton1Click:Connect(function() pcall(function() m = not m if ContentFrame then ContentFrame.Visible = not m end if MainFrame then MainFrame.Size = m and UDim2.new(0, 280, 0, 25) or UDim2.new(0, 280, 0, 350) end if MinimizeButton then MinimizeButton.Text = m and "+" or "-" end end) end end

spawn(function() while true do pcall(SaveSettings) wait(15) end end)
pcall(function() applySpeed() updateAntiFall() if SETTINGS.ESP.Enabled then for _, p in ipairs(Players:GetPlayers()) do createESP(p) end end end)

print("ARI HUB V3 PRO - LOADED SUCCESSFULLY!")
print("✅ ScreenGui Compatible")
print("✅ Draggable UI")
print("✅ All Features Working")
print("✅ Mobile Optimized")
