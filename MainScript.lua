-- [[ SKYJACK RBX v185: APEX - TOP TIME PERFORMANCE ]] --
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local pgui = lp:WaitForChild("PlayerGui", 20)
local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/d9a4102ad46bbcf1399d208b03e57ead4bb46af8/gistfile1.txt"

-- Apex Performance Config
local Screen, KeyPanel, Main, Status, KeyInput, MinBtn
local IsMinimized = false
local Toggles = {Speed = false, WallPass = false, InfJump = false, VipAccess = false, HiddenMode = false, Shield = false}
local Keys = {"Speed", "WallPass", "InfJump", "VipAccess", "HiddenMode", "Shield"}
local Names = {"APEX TURBO SPEED", "WALL PASS (NOCLIP)", "INFINITE JUMP", "VIP AREA ACCESS", "HIDDEN IDENTITY", "ANTI-BAN SHIELD"}
local Buttons = {}
local Index = 1
local BoostPower = 4.8 -- PENINGKATAN SPEED SIGNIFIKAN UNTUK TOP TIME
local Smoothness = 0.75 -- Keseimbangan belok agar tidak kaku

-- [[ 1. APEX ANTI-BAN (FORCE INJECTION) ]] --
local function ForceShield()
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    if setreadonly then setreadonly(mt, false) end
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if self == lp and (method:lower() == "kick" or method == "BreakJoints") then
            return nil
        end
        return old(self, ...)
    end)
    if setreadonly then setreadonly(mt, true) end
    return true
end

-- [[ 2. HIGH-FREQUENCY SPEED ENGINE ]] --
rs.RenderStepped:Connect(function()
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    
    if root and hum and hum.MoveDirection.Magnitude > 0 then
        if Toggles.Speed then
            -- Apex Motion: Menggunakan perpaduan CFrame dan Velocity untuk Top Time
            local moveVec = hum.MoveDirection * BoostPower
            local rayParam = RaycastParams.new()
            rayParam.FilterDescendantsInstances = {char}
            local hit = workspace:Raycast(root.Position, hum.MoveDirection * 2.5, rayParam)
            
            if not hit or Toggles.WallPass then
                -- Sistem pergerakan 2026: Halus tapi sangat cepat
                root.CFrame = root.CFrame:Lerp(root.CFrame + moveVec, Smoothness)
            end
        end
        
        if Toggles.WallPass then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end)

-- [[ 3. CYBER-FLUENT UI CONSTRUCTION ]] --
local function BuildUI()
    for _, v in pairs(pgui:GetChildren()) do if v.Name == "SKYJACK_APEX" then v:Destroy() end end
    Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "SKYJACK_APEX"
    Screen.IgnoreGuiInset = true

    -- LOGIN PANEL (Modern Glassmorphism)
    KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 420, 0, 340)
    KeyPanel.Position = UDim2.new(0.5, -210, 0.4, 0)
    KeyPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
    KeyPanel.BorderSizePixel = 0
    KeyPanel.Active, KeyPanel.Draggable = true, true
    Instance.new("UICorner", KeyPanel).CornerRadius = UDim.new(0, 30)
    
    local stroke = Instance.new("UIStroke", KeyPanel)
    stroke.Color = Color3.fromRGB(255, 0, 50)
    stroke.Thickness = 3

    local Title = Instance.new("TextLabel", KeyPanel)
    Title.Size = UDim2.new(1, 0, 0, 80)
    Title.BackgroundColor3 = Color3.fromRGB(220, 0, 50)
    Title.Text = "SKYJACK RBX | APEX VERSION"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 30)

    KeyInput = Instance.new("TextBox", KeyPanel)
    KeyInput.Size = UDim2.new(0.85, 0, 0, 60)
    KeyInput.Position = UDim2.new(0.075, 0, 0.42, 0)
    KeyInput.PlaceholderText = "ENTER PRODUCT KEY"
    KeyInput.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    KeyInput.TextColor3 = Color3.new(1, 1, 1)
    KeyInput.Font = Enum.Font.Gotham
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 15)

    local LoginBtn = Instance.new("TextButton", KeyPanel)
    LoginBtn.Size = UDim2.new(0.85, 0, 0, 65)
    LoginBtn.Position = UDim2.new(0.075, 0, 0.72, 0)
    LoginBtn.Text = "VALIDATE ACCESS"
    LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    LoginBtn.TextColor3 = Color3.new(1, 1, 1)
    LoginBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 15)

    -- CHEAT PANEL (Professional Layout)
    Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 320, 0, 650)
    Main.Position = UDim2.new(0.05, 0, 0.2, 0)
    Main.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
    Main.Visible = false
    Main.Active, Main.Draggable = true, true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 30)
    local mainStroke = Instance.new("UIStroke", Main)
    mainStroke.Color = Color3.fromRGB(255, 0, 50)
    mainStroke.Thickness = 2.5

    local MainTitle = Instance.new("TextLabel", Main)
    MainTitle.Size = UDim2.new(1, 0, 0, 75)
    MainTitle.BackgroundColor3 = Color3.fromRGB(220, 0, 50)
    MainTitle.Text = "SKYJACK RBX"
    MainTitle.TextColor3 = Color3.new(1, 1, 1)
    MainTitle.Font = Enum.Font.GothamBold
    MainTitle.TextSize = 24
    Instance.new("UICorner", MainTitle).CornerRadius = UDim.new(0, 30)

    MinBtn = Instance.new("TextButton", Main)
    MinBtn.Size = UDim2.new(0, 40, 0, 40)
    MinBtn.Position = UDim2.new(1, -50, 0, 18)
    MinBtn.Text = "−"
    MinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    MinBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(1, 0)

    LoginBtn.MouseButton1Click:Connect(function()
        local success, result = pcall(function() return game:HttpGet(DATABASE_URL) end)
        if success then
            local data = HttpService:JSONDecode(result)
            if data.KEY_LIST[KeyInput.Text] then
                KeyPanel:Destroy()
                Main.Visible = true
            end
        end
    end)
end

BuildUI()

-- [[ 4. NAVIGATION & ACTIVE CONTROL ]] --
local function Refresh()
    for i, b in ipairs(Buttons) do
        local k = Keys[i]
        b.Visible = not IsMinimized
        b.Text = Names[i] .. (Toggles[k] and " [ACTIVE]" or " [OFF]")
        b.BackgroundColor3 = (i == Index) and Color3.fromRGB(220, 0, 50) or Color3.fromRGB(20, 20, 25)
        b.BackgroundTransparency = (i == Index) and 0 or 0.5
    end
end

for i = 1, #Names do
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, -30, 0, 80)
    b.Position = UDim2.new(0, 15, 0, (i * 90) - 10)
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 13
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 15)
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
        if key == "Shield" then
            Toggles.Shield = ForceShield() -- Force state to Active
        else
            Toggles[key] = not Toggles[key]
        end
        Refresh() 
    end
end)

MinBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    Main:TweenSize(IsMinimized and UDim2.new(0, 320, 0, 75) or UDim2.new(0, 320, 0, 650), "Out", "Quart", 0.5, true)
    Refresh()
end)

Refresh()
