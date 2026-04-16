-- [[ SKYJACK RBX v210: PERFORMANCE - BALANCED FOR TOP TIME ]] --
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local pgui = lp:WaitForChild("PlayerGui", 20)
local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/d9a4102ad46bbcf1399d208b03e57ead4bb46af8/gistfile1.txt"

-- Balanced Config
local Screen, KeyPanel, Main, Status, KeyInput, MinBtn
local IsMinimized = false
local Toggles = {Speed = false, WallPass = false, InfJump = false, VipAccess = false, HiddenMode = false, Shield = false}
local Keys = {"Speed", "WallPass", "InfJump", "VipAccess", "HiddenMode", "Shield"}
local Names = {"PERFORMANCE SPEED", "WALL PASS (NOCLIP)", "INFINITE JUMP", "VIP AREA ACCESS", "HIDDEN IDENTITY", "ANTI-BAN PROTECT"}
local Buttons = {}
local Index = 1
local BalancedSpeed = 6.2 -- Kencang tapi tetap terkendali (Sweet Spot)
local SmoothAlpha = 0.5 -- Membuat pergerakan lebih presisi untuk belokan tajam

-- [[ 1. INSTANT INJECTION (ANTI-BAN & LOGIC) ]] --
local function SecureShield()
    local success = pcall(function()
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
    end)
    return success
end

-- [[ 2. PHYSICS & MOTION ENGINE ]] --
rs.RenderStepped:Connect(function()
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    
    if root and hum and hum.MoveDirection.Magnitude > 0 then
        if Toggles.Speed then
            local moveDir = hum.MoveDirection
            if Toggles.WallPass then
                -- Noclip Speed
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
                root.CFrame = root.CFrame:Lerp(root.CFrame + (moveDir * BalancedSpeed), SmoothAlpha)
            else
                -- Smart Collision Speed (Menghindari nembus tembok secara tak sengaja)
                local ray = workspace:Raycast(root.Position, moveDir * 2.5)
                if not ray then
                    root.CFrame = root.CFrame:Lerp(root.CFrame + (moveDir * BalancedSpeed), SmoothAlpha)
                end
            end
        end
    end
end)

-- Infinite Jump (Physics Trigger)
uis.JumpRequest:Connect(function()
    if Toggles.InfJump and lp.Character then
        local hum = lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            lp.Character.HumanoidRootPart.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
        end
    end
end)

-- [[ 3. PREMIUM DESIGN UI (2026 COMMERCIAL) ]] --
local function BuildUI()
    for _, v in pairs(pgui:GetChildren()) do if v.Name == "SKYJACK_V210" then v:Destroy() end end
    Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "SKYJACK_V210"
    Screen.IgnoreGuiInset = true

    -- LOGIN PANEL
    KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 440, 0, 360)
    KeyPanel.Position = UDim2.new(0.5, -220, 0.4, 0)
    KeyPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
    KeyPanel.Active, KeyPanel.Draggable = true, true
    Instance.new("UICorner", KeyPanel).CornerRadius = UDim.new(0, 35)
    local strokeK = Instance.new("UIStroke", KeyPanel)
    strokeK.Color = Color3.fromRGB(220, 20, 60)
    strokeK.Thickness = 3.5

    local LTitle = Instance.new("TextLabel", KeyPanel)
    LTitle.Size = UDim2.new(1, 0, 0, 85)
    LTitle.BackgroundColor3 = Color3.fromRGB(180, 0, 40)
    LTitle.Text = "SKYJACK RBX | PERFORMANCE"
    LTitle.TextColor3 = Color3.new(1,1,1)
    LTitle.Font = Enum.Font.GothamBold
    LTitle.TextSize = 18
    Instance.new("UICorner", LTitle).CornerRadius = UDim.new(0, 35)

    KeyInput = Instance.new("TextBox", KeyPanel)
    KeyInput.Size = UDim2.new(0.85, 0, 0, 65)
    KeyInput.Position = UDim2.new(0.075, 0, 0.45, 0)
    KeyInput.PlaceholderText = "ENTER LICENSE KEY"
    KeyInput.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    KeyInput.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 15)

    local LoginBtn = Instance.new("TextButton", KeyPanel)
    LoginBtn.Size = UDim2.new(0.85, 0, 0, 70)
    LoginBtn.Position = UDim2.new(0.075, 0, 0.72, 0)
    LoginBtn.Text = "VALIDATE PRODUCT"
    LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
    LoginBtn.TextColor3 = Color3.new(1,1,1)
    LoginBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 15)

    -- MAIN CHEAT PANEL
    Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 340, 0, 680)
    Main.Position = UDim2.new(0.05, 0, 0.15, 0)
    Main.BackgroundColor3 = Color3.fromRGB(8, 8, 11)
    Main.Visible = false
    Main.Active, Main.Draggable = true, true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 35)
    local strokeM = Instance.new("UIStroke", Main)
    strokeM.Color = Color3.fromRGB(220, 20, 60)
    strokeM.Thickness = 3

    local MTitle = Instance.new("TextLabel", Main)
    MTitle.Size = UDim2.new(1, 0, 0, 85)
    MTitle.BackgroundColor3 = Color3.fromRGB(180, 0, 40)
    MTitle.Text = "SKYJACK RBX"
    MTitle.TextColor3 = Color3.new(1,1,1)
    MTitle.Font = Enum.Font.GothamBold
    MTitle.TextSize = 24
    Instance.new("UICorner", MTitle).CornerRadius = UDim.new(0, 35)

    MinBtn = Instance.new("TextButton", Main)
    MinBtn.Size = UDim2.new(0, 45, 0, 45)
    MinBtn.Position = UDim2.new(1, -60, 0, 20)
    MinBtn.Text = "−"
    MinBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    MinBtn.TextColor3 = Color3.new(1,1,1)
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

-- [[ 4. BUTTONS REFRESH ]] --
local function Refresh()
    for i, b in ipairs(Buttons) do
        local k = Keys[i]
        b.Visible = not IsMinimized
        b.Text = Names[i] .. (Toggles[k] and " [ACTIVE]" or " [OFF]")
        b.BackgroundColor3 = (i == Index) and Color3.fromRGB(180, 0, 40) or Color3.fromRGB(25, 25, 30)
        b.BackgroundTransparency = (i == Index) and 0 or 0.6
    end
end

for i = 1, #Names do
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, -30, 0, 85)
    b.Position = UDim2.new(0, 15, 0, (i * 95) - 5)
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 18)
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
            Toggles.Shield = SecureShield() 
        else
            Toggles[key] = not Toggles[key]
        end
        Refresh() 
    end
end)

MinBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    Main:TweenSize(IsMinimized and UDim2.new(0, 340, 0, 85) or UDim2.new(0, 340, 0, 680), "Out", "Quart", 0.5, true)
    Refresh()
end)

Refresh()
