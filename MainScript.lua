-- [[ SKYJACK V.FINAL-HYPERION: STABLE FOUNDATION + PREMIUM DESIGN ]] --
-- Fix by AI Research:
-- - Menggunakan struktur UI asli yang 100% terbukti muncul.
-- - Mengaplikasikan desain premium "Hyperion" (Ungu-Biru Neon) pada struktur tersebut.
-- - Memastikan fitur 'Draggable' aktif dan 'PlaceholderText' benar.
-- - Fungsionalitas inti dari v3609 (kecepatan stabil) dipertahankan.

repeat task.wait() until game:IsLoaded()

-- Layanan
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local pgui = Players.LocalPlayer:WaitForChild("PlayerGui", 15)
local TweenService = game:GetService("TweenService")

-- Variabel Global
local lp = Players.LocalPlayer
local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/57de2421060ced152d4bbcad6a583d452dc6f9d7/gistfile1.txt"

-- [[ 1. UI BUILDER (FONDASI STABIL + SKIN PREMIUM) ]] --
local function BuildUI()
    if pgui:FindFirstChild("SKYJACK_HYPERION") then pgui.SKYJACK_HYPERION:Destroy() end
    local Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "SKYJACK_HYPERION"
    Screen.ResetOnSpawn = false

    -- Warna Tema "Hyperion"
    local theme = {
        Background = Color3.fromRGB(20, 20, 25),
        Secondary = Color3.fromRGB(30, 30, 40),
        Accent1 = Color3.fromRGB(120, 80, 255), -- Ungu
        Accent2 = Color3.fromRGB(0, 150, 255),   -- Biru
        Text = Color3.fromRGB(255, 255, 255),
        MutedText = Color3.fromRGB(160, 160, 170)
    }

    -- PANEL LOGIN (Struktur Asli + Skin Baru)
    local KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 320, 0, 240)
    KeyPanel.Position = UDim2.new(0.5, -160, 0.4, 0)
    KeyPanel.BackgroundColor3 = theme.Background
    KeyPanel.Active, KeyPanel.Draggable = true, true
    Instance.new("UICorner", KeyPanel).CornerRadius = UDim.new(0, 8)
    local KeyStroke = Instance.new("UIStroke", KeyPanel)
    KeyStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local KeyGradient = Instance.new("UIGradient", KeyStroke)
    KeyGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, theme.Accent1), ColorSequenceKeypoint.new(1, theme.Accent2)})

    local KTitle = Instance.new("TextLabel", KeyPanel)
    KTitle.Size = UDim2.new(1, 0, 0, 45)
    KTitle.BackgroundColor3 = theme.Secondary
    KTitle.Text = "SKYJACK AUTHENTICATION"
    KTitle.TextColor3 = theme.Text
    KTitle.Font = Enum.Font.GothamBold
    KTitle.TextSize = 18
    Instance.new("UICorner", KTitle).CornerRadius = UDim.new(0, 8)

    local KeyInput = Instance.new("TextBox", KeyPanel)
    KeyInput.Size = UDim2.new(0.85, 0, 0, 45)
    KeyInput.Position = UDim2.new(0.075, 0, 0.35, 0)
    KeyInput.PlaceholderText = "Enter your key..." -- [FIXED]
    KeyInput.BackgroundColor3 = theme.Secondary
    KeyInput.TextColor3 = theme.Text
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.TextSize = 14
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 4)

    local CheckBtn = Instance.new("TextButton", KeyPanel)
    CheckBtn.Size = UDim2.new(0.85, 0, 0, 45)
    CheckBtn.Position = UDim2.new(0.075, 0, 0.6, 0)
    CheckBtn.Text = ""
    Instance.new("UICorner", CheckBtn).CornerRadius = UDim.new(0, 4)
    local BtnGradient = Instance.new("UIGradient", CheckBtn)
    BtnGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, theme.Accent1), ColorSequenceKeypoint.new(1, theme.Accent2)})
    local BtnText = Instance.new("TextLabel", CheckBtn)
    BtnText.Size = UDim2.new(1, 0, 1, 0)
    BtnText.BackgroundTransparency = 1
    BtnText.Text = "VERIFY ACCESS"
    BtnText.TextColor3 = theme.Text
    BtnText.Font = Enum.Font.GothamBold
    BtnText.TextSize = 16

    local Status = Instance.new("TextLabel", KeyPanel)
    Status.Size = UDim2.new(1, 0, 0, 30)
    Status.Position = UDim2.new(0, 0, 0.85, 0)
    Status.BackgroundTransparency = 1
    Status.Text = "Awaiting key..."
    Status.TextColor3 = theme.MutedText
    Status.Font = Enum.Font.Gotham
    Status.TextSize = 12

    -- PANEL CHEAT UTAMA (Struktur Asli + Skin Baru)
    local Main = Instance.new("Frame", Screen)
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 260, 0, 480)
    Main.Position = UDim2.new(0.1, 0, 0.2, 0)
    Main.BackgroundColor3 = theme.Background
    Main.Visible, Main.Active, Main.Draggable = false, true, true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local MainGradient = Instance.new("UIGradient", MainStroke)
    MainGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, theme.Accent1), ColorSequenceKeypoint.new(1, theme.Accent2)})

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundColor3 = theme.Secondary
    Title.Text = "SKYJACK HYPERION"
    Title.TextColor3 = theme.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8)

    return Screen, KeyPanel, Main, CheckBtn, KeyInput, Status, theme
end

local Screen, KeyPanel, Main, CheckBtn, KeyInput, Status, theme = BuildUI()

-- [[ 2. MASTER TOGGLES & CONFIG ]] --
local Toggles = {Speed = false, AutoWalk = false, InfJump = false, Vip = false, HideName = false, Shield = false}
local Keys = {"Speed", "AutoWalk", "InfJump", "Vip", "HideName", "Shield"}
local Names = {"ANTI-CLIP SPEED", "AUTO SUMMIT", "AIR JUMP", "VIP BYPASS", "IDENTITY CLEANER", "ANTI-KICK"}
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
                Status.Text = "Access Granted"
                Status.TextColor3 = Color3.fromRGB(0, 255, 120)
                IsAuthed = true
                task.wait(1)
                KeyPanel:Destroy()
                Main.Visible = true
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
        if getrawmetatable and newcclosure then
            local mt = getrawmetatable(game)
            local old = mt.__namecall
            setreadonly(mt, false)
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if Toggles.Shield and (method == "Kick" or method == "kick") then return nil end
                if Toggles.Vip and (method == "UserOwnsGamePassAsync" or method == "PlayerOwnsAsset") then return true end
                return old(self, ...)
            end)
            setreadonly(mt, true)
        end
    end)
end)

rs.Heartbeat:Connect(function()
    if not IsAuthed then return end
    local char = lp.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    if Toggles.Speed and hum.MoveDirection.Magnitude > 0 then
        raycastParams.FilterDescendantsInstances = {char}
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        local origin = root.Position
        local direction = hum.MoveDirection * (SpeedMultiplier + 1)
        local result = workspace:Raycast(origin, direction, raycastParams)
        if not result then
            root.CFrame = root.CFrame + (hum.MoveDirection * SpeedMultiplier)
        end
    end

    if Toggles.AutoWalk then
        local target = workspace:FindFirstChild("Summit", true) or workspace:FindFirstChild("Checkpoint", true) or workspace:FindFirstChild("Goal", true)
        if target and target:IsA("BasePart") then
            hum:MoveTo(target.Position)
        end
    end

    if Toggles.HideName then
        hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BillboardGui") or v:IsA("SurfaceGui") or v.Name:lower():find("name") or v.Name:lower():find("tag") then
                v.Enabled = false
            end
        end
    end
end)

uis.JumpRequest:Connect(function()
    if Toggles.InfJump and IsAuthed then
        local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- [[ 5. UI CONTROL & REFRESH ]] --
local function Refresh()
    for i, b in ipairs(Buttons) do
        local k = Keys[i]
        local state = Toggles[k]
        b.Text = Names[i] .. (state and " [ON]" or " [OFF]")
        
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local goal = {
            BackgroundColor3 = (i == Index) and theme.Secondary or Color3.fromRGB(25, 25, 30),
            TextColor3 = state and theme.Accent2 or theme.Text
        }
        TweenService:Create(b, tweenInfo, goal):Play()
    end
end

for i = 1, #Names do
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, -20, 0, 60)
    b.Position = UDim2.new(0, 10, 0, (i * 68) - 20)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = theme.Text
    b.TextSize = 14
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", b).Color = theme.Secondary
    table.insert(Buttons, b)
end

uis.InputBegan:Connect(function(k, g)
    if k.KeyCode == Enum.KeyCode.L and IsAuthed then Main.Visible = not Main.Visible end
    if g or not Main.Visible then return end
    
    if k.KeyCode == Enum.KeyCode.Up then Index = (Index > 1) and Index - 1 or #Names
    elseif k.KeyCode == Enum.KeyCode.Down then Index = (Index < #Names) and Index + 1 or 1
    elseif k.KeyCode == Enum.KeyCode.Return then
        local key = Keys[Index]
        Toggles[key] = not Toggles[key]
    end
    Refresh()
end)

Refresh()
