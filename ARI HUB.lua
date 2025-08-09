-- Place this in StarterPlayerScripts or StarterGui
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- First, try to load the external script
local success, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ARIISETIAWAN20/ScAri/main/ScAri.lua"))()
end)

if success then
    print("ScAri.lua berhasil dijalankan!")
else
    warn("Gagal menjalankan ScAri.lua: ", err)
end

-- Then create the teleporter UI
-- Create main UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PlayerTeleportUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BorderSizePixel = 0

local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(0.7, 0, 1, 0)
TitleText.Position = UDim2.new(0.15, 0, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Player Teleporter"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 14

-- Minimize button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 16

-- Close button (actually maximize since we won't close completely)
local MaximizeButton = Instance.new("TextButton")
MaximizeButton.Name = "MaximizeButton"
MaximizeButton.Size = UDim2.new(0, 30, 0, 30)
MaximizeButton.Position = UDim2.new(1, -30, 0, 0)
MaximizeButton.BackgroundTransparency = 1
MaximizeButton.Text = "□"
MaximizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MaximizeButton.Font = Enum.Font.GothamBold
MaximizeButton.TextSize = 14

-- Search box
local SearchBox = Instance.new("TextBox")
SearchBox.Name = "SearchBox"
SearchBox.Size = UDim2.new(1, -20, 0, 30)
SearchBox.Position = UDim2.new(0, 10, 0, 35)
SearchBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.PlaceholderText = "Search players..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 14
SearchBox.ClearTextOnFocus = false

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 4)
SearchCorner.Parent = SearchBox

-- Player list
local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Name = "PlayerList"
PlayerList.Size = UDim2.new(1, -20, 1, -110)
PlayerList.Position = UDim2.new(0, 10, 0, 70)
PlayerList.BackgroundTransparency = 1
PlayerList.ScrollBarThickness = 5
PlayerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 5)
ListLayout.Parent = PlayerList

-- Teleport button
local TeleportButton = Instance.new("TextButton")
TeleportButton.Name = "TeleportButton"
TeleportButton.Size = UDim2.new(1, -20, 0, 40)
TeleportButton.Position = UDim2.new(0, 10, 1, -50)
TeleportButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportButton.Font = Enum.Font.GothamBold
TeleportButton.Text = "TELEPORT"
TeleportButton.TextSize = 14

local TeleportCorner = Instance.new("UICorner")
TeleportCorner.CornerRadius = UDim.new(0, 4)
TeleportCorner.Parent = TeleportButton

-- Selected player display
local SelectedPlayer = Instance.new("TextLabel")
SelectedPlayer.Name = "SelectedPlayer"
SelectedPlayer.Size = UDim2.new(1, -20, 0, 20)
SelectedPlayer.Position = UDim2.new(0, 10, 1, -95)
SelectedPlayer.BackgroundTransparency = 1
SelectedPlayer.TextColor3 = Color3.fromRGB(200, 200, 200)
SelectedPlayer.Font = Enum.Font.Gotham
SelectedPlayer.TextSize = 12
SelectedPlayer.Text = "Selected: None"
SelectedPlayer.TextXAlignment = Enum.TextXAlignment.Left

-- Assemble UI
TitleBar.Parent = MainFrame
TitleText.Parent = TitleBar
MinimizeButton.Parent = TitleBar
MaximizeButton.Parent = TitleBar
SearchBox.Parent = MainFrame
PlayerList.Parent = MainFrame
TeleportButton.Parent = MainFrame
SelectedPlayer.Parent = MainFrame

MainFrame.Parent = ScreenGui
ScreenGui.Parent = playerGui

-- Variables
local selectedPlayer = nil
local minimized = false
local originalSize = MainFrame.Size
local originalPosition = MainFrame.Position
local minimizedSize = UDim2.new(0, 300, 0, 30)
local minimizedPosition = UDim2.new(0.5, -150, 0, 10)

-- Functions
local function createPlayerEntry(playerInstance)
    local entry = Instance.new("TextButton")
    entry.Name = playerInstance.Name
    entry.Size = UDim2.new(1, 0, 0, 30)
    entry.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    entry.TextColor3 = Color3.fromRGB(255, 255, 255)
    entry.Text = playerInstance.Name
    entry.Font = Enum.Font.Gotham
    entry.TextSize = 14
    entry.AutoButtonColor = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = entry
    
    entry.MouseButton1Click:Connect(function()
        -- Deselect previous
        for _, child in ipairs(PlayerList:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end
        end
        
        -- Select new
        entry.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        selectedPlayer = playerInstance
        SelectedPlayer.Text = "Selected: " .. playerInstance.Name
    end)
    
    return entry
end

local function updatePlayerList(searchTerm)
    -- Clear current list
    for _, child in ipairs(PlayerList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Add players
    local players = Players:GetPlayers()
    table.sort(players, function(a, b) return a.Name:lower() < b.Name:lower() end)
    
    for _, playerInstance in ipairs(players) do
        if playerInstance ~= player then
            if not searchTerm or searchTerm == "" or string.find(playerInstance.Name:lower(), searchTerm:lower()) then
                local entry = createPlayerEntry(playerInstance)
                entry.Parent = PlayerList
            end
        end
    end
end

-- Event handlers
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    
    if minimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = minimizedSize, Position = minimizedPosition}):Play()
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = originalSize, Position = originalPosition}):Play()
    end
end)

MaximizeButton.MouseButton1Click:Connect(function()
    if MainFrame.Size == originalSize then
        MainFrame.Size = UDim2.new(0, 350, 0, 450)
        MainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
    else
        MainFrame.Size = originalSize
        MainFrame.Position = originalPosition
    end
end)

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    updatePlayerList(SearchBox.Text)
end)

TeleportButton.MouseButton1Click:Connect(function()
    if selectedPlayer then
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        
        local targetCharacter = selectedPlayer.Character or selectedPlayer.CharacterAdded:Wait()
        local targetRootPart = targetCharacter:WaitForChild("HumanoidRootPart")
        
        humanoidRootPart.CFrame = targetRootPart.CFrame + Vector3.new(0, 3, 0)
        
        -- Optional teleport effect
        local teleportEffect = Instance.new("Part")
        teleportEffect.Size = Vector3.new(4, 4, 4)
        teleportEffect.Position = humanoidRootPart.Position
        teleportEffect.Anchored = true
        teleportEffect.CanCollide = false
        teleportEffect.Transparency = 1
        teleportEffect.Parent = workspace
        
        local particle = Instance.new("ParticleEmitter")
        particle.Texture = "rbxassetid://242719788"
        particle.LightEmission = 1
        particle.Color = ColorSequence.new(Color3.fromRGB(0, 162, 255))
        particle.Size = NumberSequence.new(0.5)
        particle.Lifetime = NumberRange.new(0.5)
        particle.Speed = NumberRange.new(2)
        particle.EmissionDirection = Enum.NormalId.Top
        particle.Parent = teleportEffect
        
        game:GetService("Debris"):AddItem(teleportEffect, 1)
    else
        local notification = Instance.new("TextLabel")
        notification.Size = UDim2.new(1, -20, 0, 30)
        notification.Position = UDim2.new(0, 10, 1, -50)
        notification.BackgroundColor3 = Color3.fromRGB(215, 0, 0)
        notification.TextColor3 = Color3.fromRGB(255, 255, 255)
        notification.Text = "Please select a player first!"
        notification.Font = Enum.Font.GothamBold
        notification.TextSize = 14
        notification.Parent = MainFrame
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = notification
        
        delay(2, function()
            notification:Destroy()
        end)
    end
end)

-- Make frame draggable
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Initial setup
updatePlayerList()

-- Update player list when players join/leave
Players.PlayerAdded:Connect(function()
    updatePlayerList(SearchBox.Text)
end)

Players.PlayerRemoving:Connect(function()
    updatePlayerList(SearchBox.Text)
end)
