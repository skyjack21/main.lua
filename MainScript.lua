-- [[ SKYJACK OMEGA v3610: PREMIUM UI EDITION ]] --
-- Fix by AI Research: Merombak total desain UI menjadi lebih premium dan modern.
-- Menggunakan skema warna baru (biru elektrik), animasi, ikon, dan efek blur.

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local pgui = lp:WaitForChild("PlayerGui", 15)
local TweenService = game:GetService("TweenService")

local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/57de2421060ced152d4bbcad6a583d452dc6f9d7/gistfile1.txt"

-- [[ 1. PREMIUM UI BUILDER ]] --
local function BuildUI()
    if pgui:FindFirstChild("SKYJACK_V3610") then pgui.SKYJACK_V3610:Destroy() end
    local Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "SKYJACK_V3610"
    Screen.ResetOnSpawn = false

    -- Efek Blur
    local Blur = Instance.new("BlurEffect", game.Lighting)
    Blur.Enabled = false
    Blur.Size = 8

    -- PANEL LOGIN
    local KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 340, 0, 220)
    KeyPanel.Position = UDim2.new(0.5, -170, 0.5, -110)
    KeyPanel.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
    KeyPanel.BorderSizePixel = 0
    Instance.new("UICorner", KeyPanel).CornerRadius = UDim.new(0, 8)
    
    local KeyStroke = Instance.new("UIStroke", KeyPanel)
    KeyStroke.Color = Color3.fromRGB(0, 120, 255)
    KeyStroke.Thickness = 1.5

    local KTitle = Instance.new("TextLabel", KeyPanel)
    KTitle.Size = UDim2.new(1, 0, 0, 40)
    KTitle.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
    KTitle.Text = "AUTHENTICATION REQUIRED"
    KTitle.TextColor3 = Color3.new(1, 1, 1)
    KTitle.Font = Enum.Font.GothamSemibold
    KTitle.TextSize = 14
    local KTitleCorner = Instance.new("UICorner", KTitle)
    KTitleCorner.CornerRadius = UDim.new(0, 8)

    local KeyInput = Instance.new("TextBox", KeyPanel)
    KeyInput.Size = UDim2.new(1, -40, 0, 40)
    KeyInput.Position = UDim2.new(0.5, -KeyInput.AbsoluteSize.X/2, 0, 70)
    KeyInput.PlaceholderText = "Enter Your Key"
    KeyInput.ClearTextOnFocus = false
    KeyInput.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
    KeyInput.TextColor3 = Color3.new(1, 1, 1)
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.TextSize = 14
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 6)

    local CheckBtn = Instance.new("TextButton", KeyPanel)
    CheckBtn.Size = UDim2.new(1, -40, 0, 45)
    CheckBtn.Position = UDim2.new(0.5, -CheckBtn.AbsoluteSize.X/2, 0, 125)
    CheckBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    CheckBtn.Text = "VERIFY ACCESS"
    CheckBtn.TextColor3 = Color3.new(1, 1, 1)
    CheckBtn.Font = Enum.Font.GothamBold
    CheckBtn.TextSize = 16
    Instance.new("UICorner", CheckBtn).CornerRadius = UDim.new(0, 6)

    local Status = Instance.new("TextLabel", KeyPanel)
    Status.Size = UDim2.new(1, -40, 0, 30)
    Status.Position = UDim2.new(0.5, -Status.AbsoluteSize.X/2, 0, 180)
    Status.BackgroundTransparency = 1
    Status.Text = "Awaiting input..."
    Status.TextColor3 = Color3.fromRGB(150, 150, 150)
    Status.Font = Enum.Font.Gotham
    Status.TextSize = 12

    -- PANEL CHEAT UTAMA
    local Main = Instance.new("Frame", Screen)
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 260, 0, 480)
    Main.Position = UDim2.new(0.05, 0, 0.5, -240)
    Main.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
    Main.Visible = false
    Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Color3.fromRGB(0, 120, 255)
    MainStroke.Thickness = 1.5

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
    Title.Text = "SKYJACK ¦ OMEGA v3610"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    local TitleCorner = Instance.new("UICorner", Title)
    TitleCorner.CornerRadius = UDim.new(0, 8)

    -- Animasi Masuk
    local function AnimateIn(panel)
        panel.Visible = true
        panel.Position = UDim2.new(panel.Position.X.Scale, panel.Position.X.Offset, panel.Position.Y.Scale - 0.05, panel.Position.Y.Offset)
        local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local goal = {Position = UDim2.new(panel.Position.X.Scale, panel.Position.X.Offset, panel.Position.Y.Scale + 0.05, panel.Position.Y.Offset)}
        TweenService:Create(panel, tweenInfo, goal):Play()
        Blur.Enabled = true
    end
    AnimateIn(KeyPanel)

    return Screen, KeyPanel, Main, CheckBtn, KeyInput, Status, Blur, AnimateIn
end

local Screen, KeyPanel, Main, CheckBtn, KeyInput, Status, Blur, AnimateIn = BuildUI()

-- [[ 2. MASTER TOGGLES & CONFIG ]] --
getgenv().Toggles = {Speed = false, AutoWalk = false, InfJump = false, Vip = false, HideName = false, Shield = false}
local T = getgenv().Toggles
local Keys = {"Speed", "AutoWalk", "InfJump", "Vip", "HideName", "Shield"}
local Names = {"ANTI-CLIP SPEED", "AUTO SUMMIT", "PHYSICAL AIR JUMP", "VIP BYPASS", "IDENTITY CLEANER", "ANTI-KICK"}
local Buttons = {}
local Index = 1
local IsAuthed = false
local SpeedMultiplier = 2.5
local raycastParams = RaycastParams.new()

-- [[ 3. FIXED LOGIN LOGIC ]] --
CheckBtn.MouseButton1Click:Connect(function()
    local input = KeyInput.Text
    Status.Text = "Verifying..."
    Status.TextColor3 = Color3.fromRGB(255, 255, 0)
    task.spawn(function()
        local success, result = pcall(function() return game:HttpGet(DATABASE_URL) end)
        if success then
            local data = HttpService:JSONDecode(result)
            if data.KEY_LIST[input] then
                Status.Text = "Access Granted!"
                Status.TextColor3 = Color3.fromRGB(0, 255, 120)
                IsAuthed = true
                task.wait(1)
                KeyPanel:Destroy()
                AnimateIn(Main)
            else
                Status.Text = "Invalid Key"
                Status.TextColor3 = Color3.fromRGB(255, 50, 50)
            end
        else
            Status.Text = "Server Error"
            Status.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end)
end)

-- [[ 4. CORE REPAIR ENGINE ]] --
task.spawn(function()
    pcall(function()
        local mt = getrawmetatable(game)
        local old = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if T.Shield and (method == "Kick" or method == "kick") then return nil end
            if T.Vip and (method == "UserOwnsGamePassAsync" or method == "PlayerOwnsAsset") then return true end
            return old(self, ...)
        end)
        setreadonly(mt, true)
    end)
end)

rs.Heartbeat:Connect(function()
    if not IsAuthed then return end
    local char = lp.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    if T.Speed and hum.MoveDirection.Magnitude > 0 then
        raycastParams.FilterDescendantsInstances = {char}
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        local origin = root.Position
        local direction = hum.MoveDirection * (SpeedMultiplier + 1)
        local result = workspace:Raycast(origin, direction, raycastParams)
        if not result then
            root.CFrame = root.CFrame + (hum.MoveDirection * SpeedMultiplier)
        end
    end

    if T.AutoWalk then
        local target = workspace:FindFirstChild("Summit", true) or workspace:FindFirstChild("Checkpoint", true) or workspace:FindFirstChild("Goal", true)
        if target and target:IsA("BasePart") then
            hum:MoveTo(target.Position)
        end
    end

    if T.HideName then
        hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BillboardGui") or v:IsA("SurfaceGui") or v.Name:lower():find("name") or v.Name:lower():find("tag") then
                v.Enabled = false
            end
        end
    end
end)

uis.JumpRequest:Connect(function()
    if T.InfJump and IsAuthed then
        local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- [[ 5. UI CONTROL & REFRESH ]] --
local function Refresh()
    for i, b in ipairs(Buttons) do
        local k = Keys[i]
        local state = T[k]
        b.TextLabel.Text = Names[i]
        b.Icon.ImageColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(100, 100, 100)
        
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local goal = {BackgroundColor3 = (i == Index) and Color3.fromRGB(40, 45, 55) or Color3.fromRGB(25, 28, 35)}
        TweenService:Create(b, tweenInfo, goal):Play()
    end
end

for i = 1, #Names do
    local b = Instance.new("Frame", Main)
    b.Size = UDim2.new(1, -20, 0, 60)
    b.Position = UDim2.new(0, 10, 0, (i * 68) - 15)
    b.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

    local TextLabel = Instance.new("TextLabel", b)
    TextLabel.Size = UDim2.new(1, -50, 1, 0)
    TextLabel.Position = UDim2.new(0, 15, 0, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Font = Enum.Font.GothamSemibold
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.TextSize = 14
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    b.TextLabel = TextLabel

    local Icon = Instance.new("ImageLabel", b)
    Icon.Size = UDim2.new(0, 24, 0, 24)
    Icon.Position = UDim2.new(1, -40, 0.5, -12)
    Icon.BackgroundTransparency = 1
    Icon.Image = "rbxassetid://3926305904" -- Toggle Icon
    Icon.ImageColor3 = Color3.fromRGB(100, 100, 100)
    b.Icon = Icon
    
    local Button = Instance.new("TextButton", b)
    Button.Size = UDim2.new(1,0,1,0)
    Button.BackgroundTransparency = 1
    Button.Text = ""
    Button.MouseButton1Click:Connect(function()
        Index = i
        local key = Keys[Index]
        T[key] = not T[key]
        Refresh()
    end)

    table.insert(Buttons, b)
end

uis.InputBegan:Connect(function(k, g)
    if k.KeyCode == Enum.KeyCode.L and IsAuthed then 
        Main.Visible = not Main.Visible 
        Blur.Enabled = Main.Visible
    end
    if g or not Main.Visible then return end
    
    if k.KeyCode == Enum.KeyCode.Up then Index = (Index > 1) and Index - 1 or #Names
    elseif k.KeyCode == Enum.KeyCode.Down then Index = (Index < #Names) and Index + 1 or 1
    elseif k.KeyCode == Enum.KeyCode.Return then
        local key = Keys[Index]
        T[key] = not T[key]
    end
    Refresh()
end)

Refresh()
