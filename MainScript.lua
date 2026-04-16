-- [[ SKYJACK RBX v180: PREMIER COMMERCIAL GRADE ]] --
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local pgui = lp:WaitForChild("PlayerGui", 20)
local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/d9a4102ad46bbcf1399d208b03e57ead4bb46af8/gistfile1.txt"

-- States & Smooth Motion Config
local Screen, KeyPanel, Main, Status, KeyInput, MinBtn
local IsMinimized = false
local Toggles = {Speed = false, WallPass = false, InfJump = false, VipAccess = false, HiddenMode = false, Shield = false}
local Keys = {"Speed", "WallPass", "InfJump", "VipAccess", "HiddenMode", "Shield"}
local Names = {"TURBO SPEED", "WALL PASS (NOCLIP)", "INFINITE JUMP", "VIP AREA ACCESS", "HIDDEN IDENTITY", "ANTI-BAN SHIELD"}
local Buttons = {}
local Index, SpeedMult = 1, 0.15 -- Menggunakan multiplier kecil untuk sistem Lerp yang mulus

-- [[ 1. ANTI-BAN PROTECTION (HARD-FIX) ]] --
local function ForceShield()
    local success = pcall(function()
        local mt = getrawmetatable(game)
        if setreadonly then setreadonly(mt, false) end
        local old = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if self == lp and (method:lower() == "kick" or method == "BreakJoints") then
                return nil
            end
            return old(self, ...)
        end)
        if setreadonly then setreadonly(mt, true) end
    end)
    return success
end

-- [[ 2. SMOOTH MOVEMENT ENGINE (FIXED A/D JITTER) ]] --
rs.RenderStepped:Connect(function()
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    
    if root and hum and hum.MoveDirection.Magnitude > 0 then
        if Toggles.Speed then
            -- Mencegah gerakan patah-patah dengan interpolasi posisi (Lerp-like motion)
            local targetMove = hum.MoveDirection * (SpeedMult * 10)
            local rayParam = RaycastParams.new()
            rayParam.FilterDescendantsInstances = {char}
            local hit = workspace:Raycast(root.Position, hum.MoveDirection * 2, rayParam)
            
            if not hit or Toggles.WallPass then
                root.CFrame = root.CFrame:Lerp(root.CFrame + targetMove, 0.6)
            end
        end
        
        if Toggles.WallPass then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
            end
        end
    end
    
    if Toggles.HiddenMode and char and char:FindFirstChild("Head") then
        for _, v in pairs(char.Head:GetChildren()) do
            if v:IsA("BillboardGui") then v.Enabled = false end
        end
    end
end)

-- [[ 3. PREMIER UI BUILDER ]] --
local function BuildUI()
    for _, v in pairs(pgui:GetChildren()) do if v.Name == "SKYJACK_PREMIER" then v:Destroy() end end
    Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "SKYJACK_PREMIER"
    Screen.IgnoreGuiInset = true

    -- LOGIN PANEL (Premium Blur Design)
    KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 400, 0, 320)
    KeyPanel.Position = UDim2.new(0.5, -200, 0.4, 0)
    KeyPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    KeyPanel.BorderSizePixel = 0
    KeyPanel.Active, KeyPanel.Draggable = true, true
    Instance.new("UICorner", KeyPanel).CornerRadius = UDim.new(0, 25)
    
    local stroke = Instance.new("UIStroke", KeyPanel)
    stroke.Color = Color3.fromRGB(255, 0, 50)
    stroke.Thickness = 2.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local Title = Instance.new("TextLabel", KeyPanel)
    Title.Size = UDim2.new(1, 0, 0, 70)
    Title.BackgroundColor3 = Color3.fromRGB(200, 0, 40)
    Title.Text = "SKYJACK RBX ACCESS"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 25)

    KeyInput = Instance.new("TextBox", KeyPanel)
    KeyInput.Size = UDim2.new(0.85, 0, 0, 55)
    KeyInput.Position = UDim2.new(0.075, 0, 0.4, 0)
    KeyInput.PlaceholderText = "ENTER LICENSE KEY" -- TULISAN DALAM BAHASA INGGRIS
    KeyInput.Text = ""
    KeyInput.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    KeyInput.TextColor3 = Color3.new(1, 1, 1)
    KeyInput.Font = Enum.Font.Gotham
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 12)

    local LoginBtn = Instance.new("TextButton", KeyPanel)
    LoginBtn.Size = UDim2.new(0.85, 0, 0, 60)
    LoginBtn.Position = UDim2.new(0.075, 0, 0.7, 0)
    LoginBtn.Text = "VALIDATE PRODUCT"
    LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
    LoginBtn.TextColor3 = Color3.new(1, 1, 1)
    LoginBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 12)

    Status = Instance.new("TextLabel", KeyPanel)
    Status.Size = UDim2.new(1, 0, 0, 30)
    Status.Position = UDim2.new(0, 0, 0.92, 0)
    Status.BackgroundTransparency = 1
    Status.Text = "v180.2026 Secure Engine"
    Status.TextColor3 = Color3.fromRGB(120, 120, 120)

    -- CHEAT PANEL (Premium Glass)
    Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 300, 0, 620)
    Main.Position = UDim2.new(0.05, 0, 0.2, 0)
    Main.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
    Main.Visible = false
    Main.Active, Main.Draggable = true, true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 25)
    local mainStroke = Instance.new("UIStroke", Main)
    mainStroke.Color = Color3.fromRGB(200, 0, 40)
    mainStroke.Thickness = 2

    local MainTitle = Instance.new("TextLabel", Main)
    MainTitle.Size = UDim2.new(1, 0, 0, 65)
    MainTitle.BackgroundColor3 = Color3.fromRGB(200, 0, 40)
    MainTitle.Text = "SKYJACK RBX"
    MainTitle.TextColor3 = Color3.new(1, 1, 1)
    MainTitle.Font = Enum.Font.GothamBold
    MainTitle.TextSize = 22
    Instance.new("UICorner", MainTitle).CornerRadius = UDim.new(0, 25)

    MinBtn = Instance.new("TextButton", Main)
    MinBtn.Size = UDim2.new(0, 35, 0, 35)
    MinBtn.Position = UDim2.new(1, -45, 0, 15)
    MinBtn.Text = "−"
    MinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    MinBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(1, 0)

    LoginBtn.MouseButton1Click:Connect(function()
        local success, result = pcall(function() return game:HttpGet(DATABASE_URL) end)
        if success then
            local data = HttpService:JSONDecode(result)
            if data.KEY_LIST[KeyInput.Text] then
                KeyPanel:Destroy()
                Main.Visible = true
            else 
                Status.Text = "KEY INVALID - RE-CHECK"
                Status.TextColor3 = Color3.new(1, 0, 0) 
            end
        end
    end)
end

BuildUI()

-- [[ 4. NAVIGATION & BUTTONS ]] --
local function Refresh()
    for i, b in ipairs(Buttons) do
        local k = Keys[i]
        b.Visible = not IsMinimized
        b.Text = Names[i] .. (Toggles[k] and " [ACTIVE]" or " [OFF]")
        b.BackgroundColor3 = (i == Index) and Color3.fromRGB(200, 0, 40) or Color3.fromRGB(25, 25, 30)
        b.BackgroundTransparency = (i == Index) and 0 or 0.4
    end
end

for i = 1, #Names do
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, -30, 0, 75)
    b.Position = UDim2.new(0, 15, 0, (i * 85) - 15)
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
        Toggles[key] = not Toggles[key]
        if key == "Shield" and Toggles.Shield then 
            local res = ForceShield() 
            if not res then Toggles.Shield = false end
        end
        Refresh() 
    end
end)

MinBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    Main:TweenSize(IsMinimized and UDim2.new(0, 300, 0, 65) or UDim2.new(0, 300, 0, 620), "Out", "Back", 0.4, true)
    Refresh()
end)

Refresh()
