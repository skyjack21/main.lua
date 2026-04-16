-- [[ SKYJACK RBX v170: PLATINUM EDITION ]] --
-- Professional Grade UI & Secure Execution
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local pgui = lp:WaitForChild("PlayerGui", 20)
local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/d9a4102ad46bbcf1399d208b03e57ead4bb46af8/gistfile1.txt"

-- States
local Screen, KeyPanel, Main, Status, KeyInput, MinBtn
local IsMinimized = false
local Toggles = {Speed = false, WallPass = false, InfJump = false, VipAccess = false, HiddenMode = false, Shield = false}
local Keys = {"Speed", "WallPass", "InfJump", "VipAccess", "HiddenMode", "Shield"}
local Names = {"TURBO SPEED", "WALL PASS (NOCLIP)", "INFINITE JUMP", "VIP AREA ACCESS", "HIDDEN IDENTITY", "ANTI-BAN SHIELD"}
local Buttons = {}
local Index, SpeedMult = 1, 2.5

-- [[ 1. PREMIUM UI HELPERS ]] --
local function CreateShadow(parent)
    local s = Instance.new("ImageLabel", parent)
    s.Name = "Shadow"
    s.AnchorPoint = Vector2.new(0.5, 0.5)
    s.BackgroundTransparency = 1
    s.Position = UDim2.new(0.5, 0, 0.5, 0)
    s.Size = UDim2.new(1, 30, 1, 30)
    s.Image = "rbxassetid://6014264792"
    s.ImageColor3 = Color3.new(0, 0, 0)
    s.ImageTransparency = 0.5
    s.ZIndex = parent.ZIndex - 1
end

-- [[ 2. SECURE ENGINE ]] --
local function ActivateShield()
    local success, err = pcall(function()
        local mt = getrawmetatable(game)
        if setreadonly then setreadonly(mt, false) end
        local old = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if self == lp and (method:lower() == "kick" or method:lower() == "breakjoints") then
                return nil
            end
            return old(self, ...)
        end)
        if setreadonly then setreadonly(mt, true) end
    end)
    return success
end

rs.RenderStepped:Connect(function()
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    
    if root and hum and hum.MoveDirection.Magnitude > 0 then
        if Toggles.Speed then
            local rayParam = RaycastParams.new()
            rayParam.FilterDescendantsInstances = {char}
            local hit = workspace:Raycast(root.Position, hum.MoveDirection * 3, rayParam)
            if not hit or Toggles.WallPass then
                root.CFrame = root.CFrame + (hum.MoveDirection * SpeedMult)
            end
        end
        if Toggles.WallPass then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end)

-- [[ 3. UI CONSTRUCTOR ]] --
local function BuildUI()
    for _, v in pairs(pgui:GetChildren()) do if v.Name == "SKYJACK_PLATINUM" then v:Destroy() end end
    Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "SKYJACK_PLATINUM"
    Screen.ResetOnSpawn = false

    -- PANEL LOGIN (Premium Style)
    KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 380, 0, 300)
    KeyPanel.Position = UDim2.new(0.5, -190, 0.4, 0)
    KeyPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    KeyPanel.Active, KeyPanel.Draggable = true, true
    Instance.new("UICorner", KeyPanel).CornerRadius = UDim.new(0, 20)
    local strokeK = Instance.new("UIStroke", KeyPanel)
    strokeK.Color = Color3.fromRGB(255, 0, 0)
    strokeK.Thickness = 2
    CreateShadow(KeyPanel)

    local KTitle = Instance.new("TextLabel", KeyPanel)
    KTitle.Size = UDim2.new(1, 0, 0, 65)
    KTitle.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    KTitle.Text = "SKYJACK RBX | AUTHENTICATION"
    KTitle.TextColor3 = Color3.new(1, 1, 1)
    KTitle.Font = Enum.Font.GothamBold
    KTitle.TextSize = 16
    Instance.new("UICorner", KTitle).CornerRadius = UDim.new(0, 20)

    KeyInput = Instance.new("TextBox", KeyPanel)
    KeyInput.Size = UDim2.new(0.85, 0, 0, 50)
    KeyInput.Position = UDim2.new(0.075, 0, 0.4, 0)
    KeyInput.PlaceholderText = "License Key Here..."
    KeyInput.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    KeyInput.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 10)

    local CheckBtn = Instance.new("TextButton", KeyPanel)
    CheckBtn.Size = UDim2.new(0.85, 0, 0, 55)
    CheckBtn.Position = UDim2.new(0.075, 0, 0.68, 0)
    CheckBtn.Text = "ACTIVATE SYSTEM"
    CheckBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
    CheckBtn.TextColor3 = Color3.new(1, 1, 1)
    CheckBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", CheckBtn).CornerRadius = UDim.new(0, 10)

    Status = Instance.new("TextLabel", KeyPanel)
    Status.Size = UDim2.new(1, 0, 0, 30)
    Status.Position = UDim2.new(0, 0, 0.9, 0)
    Status.BackgroundTransparency = 1
    Status.Text = "Awaiting verification..."
    Status.TextColor3 = Color3.fromRGB(150, 150, 150)

    -- PANEL CHEAT (Glossy Modern)
    Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 280, 0, 600)
    Main.Position = UDim2.new(0.1, 0, 0.2, 0)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    Main.Visible = false
    Main.Active, Main.Draggable = true, true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)
    local strokeM = Instance.new("UIStroke", Main)
    strokeM.Color = Color3.fromRGB(255, 0, 0)
    strokeM.Thickness = 2
    CreateShadow(Main)

    local TitleBar = Instance.new("TextLabel", Main)
    TitleBar.Size = UDim2.new(1, 0, 0, 60)
    TitleBar.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    TitleBar.Text = "SKYJACK RBX"
    TitleBar.TextColor3 = Color3.new(1, 1, 1)
    TitleBar.Font = Enum.Font.GothamBold
    TitleBar.TextSize = 20
    Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 20)

    MinBtn = Instance.new("TextButton", Main)
    MinBtn.Size = UDim2.new(0, 32, 0, 32)
    MinBtn.Position = UDim2.new(1, -40, 0, 14)
    MinBtn.Text = "−"
    MinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    MinBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(1, 0)

    CheckBtn.MouseButton1Click:Connect(function()
        local success, result = pcall(function() return game:HttpGet(DATABASE_URL) end)
        if success then
            local data = HttpService:JSONDecode(result)
            if data.KEY_LIST[KeyInput.Text] then
                KeyPanel:Destroy()
                Main.Visible = true
            else Status.Text = "ACCESS DENIED" Status.TextColor3 = Color3.new(1,0,0) end
        end
    end)
end

BuildUI()

-- [[ 4. LOGIC CONTROLS ]] --
local function Refresh()
    for i, b in ipairs(Buttons) do
        local k = Keys[i]
        b.Visible = not IsMinimized
        b.Text = Names[i] .. (Toggles[k] and " [ACTIVE]" or " [OFF]")
        b.BackgroundColor3 = (i == Index) and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(25, 25, 30)
        b.BackgroundTransparency = (i == Index) and 0 or 0.3
    end
end

for i = 1, #Names do
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, -30, 0, 75)
    b.Position = UDim2.new(0, 15, 0, (i * 85) - 15)
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 12)
    table.insert(Buttons, b)
end

uis.InputBegan:Connect(function(k, g)
    if k.KeyCode == Enum.KeyCode.F8 then Screen:Destroy() end
    if k.KeyCode == Enum.KeyCode.L and not KeyPanel.Parent then Main.Visible = not Main.Visible end
    if g or not Main.Visible or IsMinimized then return end
    
    if k.KeyCode == Enum.KeyCode.Up then Index = (Index > 1) and Index - 1 or #Names Refresh()
    elseif k.KeyCode == Enum.KeyCode.Down then Index = (Index < #Names) and Index + 1 or 1 Refresh()
    elseif k.KeyCode == Enum.KeyCode.Return then 
        local key = Keys[Index]
        Toggles[key] = not Toggles[key]
        if key == "Shield" and Toggles.Shield then 
            local res = ActivateShield() 
            if not res then Toggles.Shield = false end
        end
        Refresh() 
    end
end)

MinBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    Main:TweenSize(IsMinimized and UDim2.new(0, 280, 0, 60) or UDim2.new(0, 280, 0, 600), "Out", "Quart", 0.4, true)
    Refresh()
end)

Refresh()
