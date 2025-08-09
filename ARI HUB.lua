-- Player Teleporter UI with Working Dragging and Minimize/Maximize

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create main UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PlayerTeleportUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(80, 80, 80)

-- Title bar
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 2
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 8)

local TitleText = Instance.new("TextLabel", TitleBar)
TitleText.Size = UDim2.new(0.7, 0, 1, 0)
TitleText.Position = UDim2.new(0.15, 0, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Player Teleporter"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 14
TitleText.ZIndex = 2

local MinimizeButton = Instance.new("TextButton", TitleBar)
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -90, 0, 0)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 16
MinimizeButton.ZIndex = 2

local MaximizeButton = Instance.new("TextButton", TitleBar)
MaximizeButton.Name = "MaximizeButton"
MaximizeButton.Size = UDim2.new(0, 30, 0, 30)
MaximizeButton.Position = UDim2.new(1, -60, 0, 0)
MaximizeButton.BackgroundTransparency = 1
MaximizeButton.Text = "□"
MaximizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MaximizeButton.Font = Enum.Font.GothamBold
MaximizeButton.TextSize = 14
MaximizeButton.ZIndex = 2

local CloseButton = Instance.new("TextButton", TitleBar)
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.ZIndex = 2

-- Search box
local SearchBox = Instance.new("TextBox", MainFrame)
SearchBox.Size = UDim2.new(1, -20, 0, 30)
SearchBox.Position = UDim2.new(0, 10, 0, 35)
SearchBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.PlaceholderText = "Search players..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 14
SearchBox.ClearTextOnFocus = false
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 4)

-- Player list
local PlayerList = Instance.new("ScrollingFrame", MainFrame)
PlayerList.Size = UDim2.new(1, -20, 1, -110)
PlayerList.Position = UDim2.new(0, 10, 0, 70)
PlayerList.BackgroundTransparency = 1
PlayerList.ScrollBarThickness = 5
PlayerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerList.ScrollingDirection = Enum.ScrollingDirection.Y

local ListLayout = Instance.new("UIListLayout", PlayerList)
ListLayout.Padding = UDim.new(0, 5)
ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
end)

-- Selected player display
local SelectedPlayer = Instance.new("TextLabel", MainFrame)
SelectedPlayer.Size = UDim2.new(1, -20, 0, 20)
SelectedPlayer.Position = UDim2.new(0, 10, 1, -95)
SelectedPlayer.BackgroundTransparency = 1
SelectedPlayer.TextColor3 = Color3.fromRGB(200, 200, 200)
SelectedPlayer.Font = Enum.Font.Gotham
SelectedPlayer.TextSize = 12
SelectedPlayer.Text = "Selected: None"
SelectedPlayer.TextXAlignment = Enum.TextXAlignment.Left

-- Teleport button
local TeleportButton = Instance.new("TextButton", MainFrame)
TeleportButton.Size = UDim2.new(1, -20, 0, 40)
TeleportButton.Position = UDim2.new(0, 10, 1, -50)
TeleportButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportButton.Font = Enum.Font.GothamBold
TeleportButton.Text = "TELEPORT"
TeleportButton.TextSize = 14
Instance.new("UICorner", TeleportButton).CornerRadius = UDim.new(0, 4)

-- Logic variables
local selectedPlayer = nil
local minimized, maximized = false, false
local originalSize, originalPosition = MainFrame.Size, MainFrame.Position
local minimizedSize, minimizedPosition = UDim2.new(0, 300, 0, 30), UDim2.new(0.5, -150, 0, 10)
local maximizedSize, maximizedPosition = UDim2.new(0, 350, 0, 450), UDim2.new(0.5, -175, 0.5, -225)

local playerEntries = {}

-- Functions
local function createPlayerEntry(playerInstance)
    if playerEntries[playerInstance] then return playerEntries[playerInstance] end
    
    local entry = Instance.new("TextButton")
    entry.Name = playerInstance.Name
    entry.Size = UDim2.new(1, 0, 0, 30)
    entry.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    entry.TextColor3 = Color3.fromRGB(255, 255, 255)
    entry.Text = playerInstance.Name
    entry.Font = Enum.Font.Gotham
    entry.TextSize = 14
    entry.AutoButtonColor = false
    
    Instance.new("UICorner", entry).CornerRadius = UDim.new(0, 4)
    
    entry.MouseButton1Click:Connect(function()
        for _, existingEntry in pairs(playerEntries) do
            if existingEntry and existingEntry.Parent then
                existingEntry.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end
        end
        entry.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        selectedPlayer = playerInstance
        SelectedPlayer.Text = "Selected: " .. playerInstance.Name
    end)
    
    playerEntries[playerInstance] = entry
    return entry
end

local function updatePlayerList(searchTerm)
    for _, child in ipairs(PlayerList:GetChildren()) do
        if child:IsA("TextButton") then
            child.Parent = nil
        end
    end
    
    local players = Players:GetPlayers()
    table.sort(players, function(a, b) 
        return a.Name:lower() < b.Name:lower() 
    end)
    
    for _, p in ipairs(players) do
        if p ~= player then
            if not searchTerm or searchTerm == "" or string.find(p.Name:lower(), searchTerm:lower()) then
                local entry = createPlayerEntry(p)
                entry.Parent = PlayerList
            end
        end
    end
end

local function teleportToPlayer(targetPlayer)
    if not targetPlayer then 
        warn("No player selected!")
        return 
    end
    
    local char = player.Character
    if not char then
        char = player.CharacterAdded:Wait()
    end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        hrp = char:WaitForChild("HumanoidRootPart", 5)
        if not hrp then
            warn("Could not find HumanoidRootPart!")
            return
        end
    end
    
    local targetChar = targetPlayer.Character
    if not targetChar then
        targetChar = targetPlayer.CharacterAdded:Wait()
    end
    
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetHRP then
        targetHRP = targetChar:WaitForChild("HumanoidRootPart", 5)
        if not targetHRP then
            warn("Could not find target's HumanoidRootPart!")
            return
        end
    end
    
    hrp.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
end

-- Draggable functionality
local dragging = false
local dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    local newPos = UDim2.new(
        startPos.X.Scale, 
        startPos.X.Offset + delta.X,
        startPos.Y.Scale, 
        startPos.Y.Offset + delta.Y
    )
    MainFrame.Position = newPos
    
    if minimized then
        minimizedPosition = newPos
    else
        originalPosition = newPos
    end
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

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        update(input)
    end
end)

-- Window control buttons
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.2), {
            Size = minimizedSize,
            Position = minimizedPosition
        }):Play()
        MinimizeButton.Text = "+"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.2), {
            Size = originalSize,
            Position = originalPosition
        }):Play()
        MinimizeButton.Text = "_"
    end
end)

MaximizeButton.MouseButton1Click:Connect(function()
    maximized = not maximized
    if maximized then
        MainFrame.Size = maximizedSize
        MainFrame.Position = maximizedPosition
        MaximizeButton.Text = "❐"
    else
        MainFrame.Size = originalSize
        MainFrame.Position = originalPosition
        MaximizeButton.Text = "□"
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Search functionality
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    updatePlayerList(SearchBox.Text)
end)

-- Teleport button
TeleportButton.MouseButton1Click:Connect(function()
    teleportToPlayer(selectedPlayer)
end)

-- Initialize UI
MainFrame.Parent = ScreenGui
ScreenGui.Parent = playerGui

-- Initialize player list
updatePlayerList()

-- Set up player tracking
Players.PlayerAdded:Connect(function(p)
    updatePlayerList(SearchBox.Text)
end)

Players.PlayerRemoving:Connect(function(p)
    updatePlayerList(SearchBox.Text)
end)

-- External script loader (optional)
local success, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ARIISETIAWAN20/ScAri/main/ScAri.lua"))()
end)
if success then
    print("ScAri.lua berhasil dijalankan!")
else
    warn("Gagal menjalankan ScAri.lua: ", err)
end
