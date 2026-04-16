-- [[ OMNI v160: SKYJACK RBX - MODERN PERSISTENCE ]] --
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local pgui = lp:WaitForChild("PlayerGui", 20)

local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/d9a4102ad46bbcf1399d208b03e57ead4bb46af8/gistfile1.txt"

-- Configuration
local Screen, KeyPanel, Main, Status, KeyInput, MinBtn
local IsMinimized = false
local Toggles = {Speed = false, SafeNoclip = false, InfJump = false, VipBypass = false, HideName = false, AntiBan = false}
local Keys = {"Speed", "SafeNoclip", "InfJump", "VipBypass", "HideName", "AntiBan"}
local Names = {"WALK SPEED", "NOCLIP (SAFE)", "INFINITE JUMP", "VIP PASS BYPASS", "HIDE MY NAME", "ANTI-BAN SHIELD"}
local Buttons = {}
local Index, SpeedMult = 1, 2.5

-- [[ 1. CORE CHEAT ENGINE (RUNS ALWAYS) ]] --
rs.RenderStepped:Connect(function()
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    
    if root and hum and hum.MoveDirection.Magnitude > 0 then
        -- Speed Engine
        if Toggles.Speed then 
            root.CFrame = root.CFrame + (hum.MoveDirection * SpeedMult) 
        end
        -- Noclip / Safe Clamp
        if Toggles.SafeNoclip then
            local ray = workspace:Raycast(root.Position, hum.MoveDirection * 5)
            if ray then root.Velocity = Vector3.new(0, root.Velocity.Y, 0) end
        end
    end
    
    -- Fake Name / Hide Name
    if Toggles.HideName and char and char:FindFirstChild("Head") then
        for _, v in pairs(char.Head:GetChildren()) do
            if v:IsA("BillboardGui") then v.Enabled = false end
        end
    end
end)

-- Anti-Ban Protection
local function EnableShield()
    local old; old = hookmetamethod(game, "__namecall", function(self, ...)
        if self == lp and getnamecallmethod():lower() == "kick" then return nil end
        return old(self, ...)
    end)
end

-- Jump & VIP Persistence
task.spawn(function()
    while task.wait(0.1) do
        if Toggles.InfJump and uis:IsKeyDown(Enum.KeyCode.Space) and lp.Character then
            lp.Character.HumanoidRootPart.Velocity = Vector3.new(lp.Character.HumanoidRootPart.Velocity.X, 60, lp.Character.HumanoidRootPart.Velocity.Z)
        end
        if Toggles.VipBypass then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Name:lower():find("vip") then 
                    v.CanCollide = false 
                    v.Transparency = 0.5 
                end
            end
        end
    end
end)

-- [[ 2. MODERN UI CONSTRUCTOR ]] --
local function BuildUI()
    for _, old in ipairs(pgui:GetChildren()) do if old.Name:find("OMNI") then old:Destroy() end end
    
    Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "OMNI_SKYJACK_V160"
    Screen.ResetOnSpawn = false

    -- MODERN LOGIN PANEL
    KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 350, 0, 280)
    KeyPanel.Position = UDim2.new(0.5, -175, 0.4, 0)
    KeyPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    KeyPanel.Active, KeyPanel.Draggable = true, true
    local kCorner = Instance.new("UICorner", KeyPanel)
    kCorner.CornerRadius = UDim.new(0, 15)
    local kStroke = Instance.new("UIStroke", KeyPanel)
    kStroke.Color = Color3.fromRGB(255, 0, 0)
    kStroke.Thickness = 2

    local KTitle = Instance.new("TextLabel", KeyPanel)
    KTitle.Size = UDim2.new(1, 0, 0, 60)
    KTitle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    KTitle.Text = "SKYJACK RBX ACCESS"
    KTitle.TextColor3 = Color3.new(1, 1, 1)
    KTitle.Font = Enum.Font.GothamBold
    KTitle.TextSize = 18
    Instance.new("UICorner", KTitle).CornerRadius = UDim.new(0, 15)

    KeyInput = Instance.new("TextBox", KeyPanel)
    KeyInput.Size = UDim2.new(0.85, 0, 0, 50)
    KeyInput.Position = UDim2.new(0.075, 0, 0.38, 0)
    KeyInput.PlaceholderText = "Enter Activation Key..."
    KeyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    KeyInput.TextColor3 = Color3.new(1, 1, 1)
    KeyInput.Font = Enum.Font.Gotham
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 10)

    local CheckBtn = Instance.new("TextButton", KeyPanel)
    CheckBtn.Size = UDim2.new(0.85, 0, 0, 50)
    CheckBtn.Position = UDim2.new(0.075, 0, 0.65, 0)
    CheckBtn.Text = "LOGIN"
    CheckBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
    CheckBtn.TextColor3 = Color3.new(1, 1, 1)
    CheckBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", CheckBtn).CornerRadius = UDim.new(0, 10)

    Status = Instance.new("TextLabel", KeyPanel)
    Status.Size = UDim2.new(1, 0, 0, 30)
    Status.Position = UDim2.new(0, 0, 0.88, 0)
    Status.BackgroundTransparency = 1
    Status.Text = "Awaiting Key Verification"
    Status.TextColor3 = Color3.fromRGB(150, 150, 150)
    Status.Font = Enum.Font.Gotham

    -- MODERN MAIN PANEL
    Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 260, 0, 580)
    Main.Position = UDim2.new(0.1, 0, 0.2, 0)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    Main.Visible = false
    Main.Active, Main.Draggable = true, true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
    local mStroke = Instance.new("UIStroke", Main)
    mStroke.Color = Color3.fromRGB(200, 0, 0)
    mStroke.Thickness = 2

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 55)
    Title.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    Title.Text = "SKYJACK RBX"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 15)

    -- Control Buttons (Minimize & Close)
    local CloseBtn = Instance.new("TextButton", Main)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -40, 0, 12)
    CloseBtn.Text = "×"
    CloseBtn.TextSize = 25
    CloseBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
    CloseBtn.MouseButton1Click:Connect(function() Screen:Destroy() end)

    MinBtn = Instance.new("TextButton", Main)
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -78, 0, 12)
    MinBtn.Text = "-"
    MinBtn.TextSize = 25
    MinBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    MinBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(1, 0)

    -- Login logic
    CheckBtn.MouseButton1Click:Connect(function()
        local success, result = pcall(function() return game:HttpGet(DATABASE_URL) end)
        if success then
            local data = HttpService:JSONDecode(result)
            if data.KEY_LIST[KeyInput.Text] then
                KeyPanel:Destroy()
                Main.Visible = true
            else Status.Text = "INVALID KEY!" Status.TextColor3 = Color3.new(1,0,0) end
        end
    end)
end

BuildUI()

-- [[ 3. BUTTON SYSTEM & NAVIGATION ]] --
local function Refresh()
    for i, b in ipairs(Buttons) do
        local k = Keys[i]
        b.Visible = not IsMinimized
        b.Text = Names[i] .. (Toggles[k] and " [ON]" or " [OFF]")
        b.BackgroundColor3 = (i == Index) and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(25, 25, 30)
        b.TextColor3 = (i == Index) and Color3.new(1,1,1) or Color3.fromRGB(180, 180, 180)
    end
end

MinBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    Main:TweenSize(IsMinimized and UDim2.new(0, 260, 0, 55) or UDim2.new(0, 260, 0, 580), "Out", "Back", 0.4, true)
    MinBtn.Text = IsMinimized and "+" or "-"
    Refresh()
end)

for i = 1, #Names do
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, -24, 0, 75)
    b.Position = UDim2.new(0, 12, 0, (i * 85) - 25)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    table.insert(Buttons, b)
end

uis.InputBegan:Connect(function(k, g)
    if k.KeyCode == Enum.KeyCode.F8 then Screen:Destroy() end
    if k.KeyCode == Enum.KeyCode.L and not KeyPanel.Parent then Main.Visible = not Main.Visible end
    
    if g or not Main.Visible or IsMinimized then return end
    if k.KeyCode == Enum.KeyCode.Up then Index = (Index > 1) and Index - 1 or #Names Refresh()
    elseif k.KeyCode == Enum.KeyCode.Down then Index = (Index < #Names) and Index + 1 or 1 Refresh()
    elseif k.KeyCode == Enum.KeyCode.Return then 
        Toggles[Keys[Index]] = not Toggles[Keys[Index]] 
        if Keys[Index] == "AntiBan" and Toggles.AntiBan then EnableShield() end
        Refresh() 
    end
end)

Refresh()
