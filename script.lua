-- LocalScript Auto Joiner Profissional, Movível
-- Créditos: by: dark

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local PLACE_ID = 109983668079237
local processedJobIds = {}

-- Validação de JobId
local function isValidJobId(jobId)
    return string.match(jobId, "%w+%-%w+%-%w+%-%w+%-%w+")
end

local function autoJoin(jobId)
    if not isValidJobId(jobId) then return end
    if processedJobIds[jobId] then return end
    processedJobIds[jobId] = true
    print("Entrando no servidor:", jobId)
    TeleportService:TeleportToPlaceInstance(PLACE_ID, jobId, player)
end

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoJoinerGUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 400, 0, 150)
Frame.Position = UDim2.new(0.5, -200, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Frame.BorderSizePixel = 0
Frame.AnchorPoint = Vector2.new(0.5,0.5)
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 15)

-- Header (para mover)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,35)
Header.BackgroundColor3 = Color3.fromRGB(50,50,60)
Header.BorderSizePixel = 0
Header.Parent = Frame
local headerCorner = Instance.new("UICorner", Header)
headerCorner.CornerRadius = UDim.new(0,15)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,1,0)
Title.BackgroundTransparency = 1
Title.Text = "Auto Joiner"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Header

-- Créditos
local Credit = Instance.new("TextLabel")
Credit.Size = UDim2.new(1, -10, 0, 20)
Credit.Position = UDim2.new(0, 5, 1, -25)
Credit.BackgroundTransparency = 1
Credit.Text = "by: dark"
Credit.TextColor3 = Color3.fromRGB(180,180,180)
Credit.TextScaled = false
Credit.Font = Enum.Font.Gotham
Credit.TextSize = 14
Credit.TextXAlignment = Enum.TextXAlignment.Right
Credit.Parent = Frame

-- TextBox
local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0.9, 0, 0, 50)
TextBox.Position = UDim2.new(0.05, 0, 0, 50)
TextBox.PlaceholderText = "Cole o JobId aqui"
TextBox.ClearTextOnFocus = false
TextBox.Text = ""
TextBox.TextScaled = false
TextBox.TextSize = 16
TextBox.TextColor3 = Color3.fromRGB(255,255,255)
TextBox.BackgroundColor3 = Color3.fromRGB(50,50,60)
TextBox.BorderSizePixel = 0
TextBox.Parent = Frame
local tbCorner = Instance.new("UICorner", TextBox)
tbCorner.CornerRadius = UDim.new(0,10)

-- Auto join ao colar JobId
TextBox:GetPropertyChangedSignal("Text"):Connect(function()
    local jobId = TextBox.Text or ""
    jobId = jobId:match("^%s*(.-)%s*$") -- trim
    if jobId ~= "" and isValidJobId(jobId) then
        autoJoin(jobId)
        TextBox.Text = ""
    end
end)

-- Drag simples e funcional
local dragging = false
local dragStart = nil
local startPos = nil

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        UserInputService.InputChanged:Connect(function(move)
            if dragging and move.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = move.Position - dragStart
                Frame.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
            end
        end)
    end
end)
