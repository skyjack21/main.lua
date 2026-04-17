-- [[ SKYJACK V.1.6: DRAGGABLE UI FIX ]] --
-- Fix by AI Research:
-- - [FIXED] Menambahkan kembali 'Draggable = true' pada panel login dan panel utama
--   agar bisa digeser sesuai permintaan.
-- - Semua fitur dan desain premium dari v1.5 dipertahankan.

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

-- [[ 1. PREMIUM UI BUILDER (HYPERION) ]] --
local function BuildUI()
    if pgui:FindFirstChild("SKYJACK_V1.6") then pgui.SKYJACK_V1.6:Destroy() end
    local Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "SKYJACK_V1.6"
    Screen.ResetOnSpawn = false

    -- Warna Tema
    local theme = {
        Background = Color3.fromRGB(20, 20, 25),
        Secondary = Color3.fromRGB(30, 30, 40),
        Accent1 = Color3.fromRGB(120, 80, 255), -- Ungu
        Accent2 = Color3.fromRGB(0, 150, 255),   -- Biru
        Text = Color3.fromRGB(255, 255, 255),
        MutedText = Color3.fromRGB(160, 160, 170)
    }

    -- Efek Blur
    local Blur = Instance.new("BlurEffect", game.Lighting)
    Blur.Enabled = false
    Blur.Size = 6

    -- PANEL LOGIN
    local KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 350, 0, 230)
    KeyPanel.AnchorPoint = Vector2.new(0.5, 0.5)
    KeyPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
    KeyPanel.BackgroundColor3 = theme.Background
    KeyPanel.BackgroundTransparency = 0.1
    KeyPanel.BorderSizePixel = 0
    KeyPanel.Active = true -- [FIXED] Memastikan bisa di-drag
    KeyPanel.Draggable = true -- [FIXED] Menambahkan kembali fitur geser
    Instance.new("UICorner", KeyPanel).CornerRadius = UDim.new(0, 8)
    local KeyStroke = Instance.new("UIStroke", KeyPanel)
    KeyStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local KeyGradient = Instance.new("UIGradient", KeyStroke)
    KeyGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, theme.Accent1), ColorSequenceKeypoint.new(1, theme.Accent2)})

    local KTitle = Instance.new("TextLabel", KeyPanel)
    KTitle.Size = UDim2.new(1, 0, 0, 45)
    KTitle.BackgroundColor3 = theme.Secondary
    KTitle.Text = "SKYJACK V.1.6"
    KTitle.TextColor3 = theme.Text
    KTitle.Font = Enum.Font.GothamBold
    KTitle.TextSize = 18
    Instance.new("UICorner", KTitle).CornerRadius = UDim.new(0, 8)

    local KeyInput = Instance.new("TextBox", KeyPanel)
    KeyInput.Size = UDim2.new(1, -40, 0, 45)
    KeyInput.AnchorPoint = Vector2.new(0.5, 0)
    KeyInput.Position = UDim2.new(0.5, 0, 0, 75)
    KeyInput.PlaceholderText = "Enter your key"
    KeyInput.ClearTextOnFocus = false
    KeyInput.BackgroundColor3 = theme.Secondary
    KeyInput.TextColor3 = theme.Text
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.TextSize = 14
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 4)

    local CheckBtn = Instance.new("TextButton", KeyPanel)
    CheckBtn.Size = UDim2.new(1, -40, 0, 45)
    CheckBtn.AnchorPoint = Vector2.new(0.5, 0)
    CheckBtn.Position = UDim2.new(0.5, 0, 0, 135)
    CheckBtn.Text = ""
    Instance.new("UICorner", CheckBtn).CornerRadius = UDim.new(0, 4)
    local BtnGradient = Instance.new("UIGradient", CheckBtn)
    BtnGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, theme.Accent1), ColorSequenceKeypoint.new(1, theme.Accent2)})
    local BtnText = Instance.new("TextLabel", CheckBtn)
    BtnText.Size = UDim2.new(1, 0, 1, 0)
    BtnText.BackgroundTransparency = 1
    BtnText.Text = "AUTHENTICATE"
    BtnText.TextColor3 = theme.Text
    BtnText.Font = Enum.Font.GothamBold
    BtnText.TextSize = 16

    local Status = Instance.new("TextLabel", KeyPanel)
    Status.Size = UDim2.new(1, -40, 0, 30)
    Status.AnchorPoint = Vector2.new(0.5, 0)
    Status.Position = UDim2.new(0.5, 0, 0, 190)
    Status.BackgroundTransparency = 1
    Status.Text = "Awaiting authentication..."
    Status.TextColor3 = theme.MutedText
    Status.Font = Enum.Font.Gotham
    Status.TextSize = 12

    -- PANEL CHEAT UTAMA
    local Main = Instance.new("Frame", Screen)
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 280, 0, 500)
    Main.Position = UDim2.new(0.1, 0, 0.2, 0)
    Main.BackgroundColor3 = theme.Background
    Main.BackgroundTransparency = 0.1
    Main.Visible = false
    Main.BorderSizePixel = 0
    Main.Active = true -- [FIXED] Memastikan bisa di-drag
    Main.Draggable = true -- [FIXED] Menambahkan kembali fitur geser
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local MainGradient = Instance.new("UIGradient", MainStroke)
    MainGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, theme.Accent1), ColorSequenceKeypoint.new(1, theme.Accent2)})

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundColor3 = theme.Secondary
    Title.Text = "SKYJACK V.1.6"
    Title.TextColor3 = theme.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8)

    local CloseBtn = Instance.new("TextButton", Title)
    CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseBtn.AnchorPoint = Vector2.new(1, 0.5)
    CloseBtn.Position = UDim2.new(1, -15, 0.5, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = theme.MutedText
    CloseBtn.TextSize = 16

    local MinimizeBtn = Instance.new("TextButton", Title)
    MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
    MinimizeBtn.AnchorPoint = Vector2.new(1, 0.5)
    MinimizeBtn.Position = UDim2.new(1, -40, 0.5, 0)
    MinimizeBtn.BackgroundTransparency = 1
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Text = "_"
    MinimizeBtn.TextColor3 = theme.MutedText
    MinimizeBtn.TextSize = 16

    local ButtonContainer = Instance.new("ScrollingFrame", Main)
    ButtonContainer.Size = UDim2.new(1, 0, 1, -45)
    ButtonContainer.Position = UDim2.new(0, 0, 0, 45)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.BorderSizePixel = 0
    ButtonContainer.ScrollBarImageColor3 = theme.Accent1
    ButtonContainer.ScrollBarThickness = 4

    local ListLayout = Instance.new("UIListLayout", ButtonContainer)
    ListLayout.Padding = UDim.new(0, 10)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    Blur.Enabled = true

    return Screen, KeyPanel, Main, CheckBtn, KeyInput, Status, theme, Blur, ButtonContainer, CloseBtn, MinimizeBtn
end

local Screen, KeyPanel, Main, CheckBtn, KeyInput, Status, theme, Blur, ButtonContainer, CloseBtn, MinimizeBtn = BuildUI()

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

-- [[ 5. UI CONTROL & REFRESH (PREMIUM) ]] --
local function Refresh()
    for i, b in ipairs(Buttons) do
        local k = Keys[i]
        local state = Toggles[k]
        b.Text = Names[i]
        
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local goal = {
            BackgroundColor3 = (i == Index) and theme.Secondary or Color3.fromRGB(35,35,45),
            TextColor3 = state and theme.Accent2 or theme.MutedText
        }
        TweenService:Create(b, tweenInfo, goal):Play()
    end
end

for i = 1, #Names do
    local b = Instance.new("TextButton", ButtonContainer)
    b.Size = UDim2.new(1, -20, 0, 60)
    b.BackgroundColor3 = Color3.fromRGB(35,35,45)
    b.Font = Enum.Font.GothamSemibold
    b.TextColor3 = theme.MutedText
    b.TextSize = 16
    b.LayoutOrder = i
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", b).Color = theme.Secondary
    table.insert(Buttons, b)
end

local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local goal = {Size = isMinimized and UDim2.new(0, 280, 0, 45) or UDim2.new(0, 280, 0, 500)}
    TweenService:Create(Main, tweenInfo, goal):Play()
    ButtonContainer.Visible = not isMinimized
end)

CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    Blur.Enabled = false
end)

uis.InputBegan:Connect(function(k, g)
    if k.KeyCode == Enum.KeyCode.L and IsAuthed then 
        Main.Visible = not Main.Visible 
        Blur.Enabled = Main.Visible
    end
    if g or not Main.Visible or isMinimized then return end
    
    if k.KeyCode == Enum.KeyCode.Up then Index = (Index > 1) and Index - 1 or #Names
    elseif k.KeyCode == Enum.KeyCode.Down then Index = (Index < #Names) and Index + 1 or 1
    elseif k.KeyCode == Enum.KeyCode.Return then
        local key = Keys[Index]
        Toggles[key] = not Toggles[key]
    end
    Refresh()
end)

Refresh()
