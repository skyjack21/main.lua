-- [[ SKYJACK RBX v230: ONYX - COMMERCIAL PREMIUM ]] --
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local pgui = lp:WaitForChild("PlayerGui", 20)
local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/d9a4102ad46bbcf1399d208b03e57ead4bb46af8/gistfile1.txt"

-- Onyx Config
local Screen, KeyPanel, Main, Status, KeyInput, MinBtn
local IsMinimized = false
local Toggles = {Speed = false, WallPass = false, InfJump = false, VipAccess = false, HiddenMode = false, Shield = false}
local Keys = {"Speed", "WallPass", "InfJump", "VipAccess", "HiddenMode", "Shield"}
local Names = {"OVERDRIVE SPEED", "NOCLIP (WALL PASS)", "INFINITE JUMP", "VIP ACCESS", "STEALTH MODE", "ANTI-BAN PROTECTION"}
local Buttons = {}
local Index = 1
local SpeedValue = 1.8 -- Nilai offset murni, sangat kencang tapi stabil

-- [[ 1. SECURE CORE (ANTI-BAN FIXED) ]] --
local function ActivateShield()
    local success = pcall(function()
        local mt = getrawmetatable(game)
        local old = mt.__namecall
        if setreadonly then setreadonly(mt, false) end
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if self == lp and (method:lower() == "kick") then return nil end
            return old(self, ...)
        end)
        if setreadonly then setreadonly(mt, true) end
    end)
    return success
end

-- [[ 2. ONYX MOTION ENGINE (NO GLITCH) ]] --
rs.PostSimulation:Connect(function()
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    
    if root and hum and hum.MoveDirection.Magnitude > 0 then
        if Toggles.Speed then
            -- Metode Offset CFrame: Tidak mengganggu gaya gravitasi (No Jumping Glitch)
            local targetCFrame = root.CFrame + (hum.MoveDirection * SpeedValue)
            
            if Toggles.WallPass then
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
                root.CFrame = targetCFrame
            else
                local ray = workspace:Raycast(root.Position, hum.MoveDirection * 2)
                if not ray then
                    root.CFrame = targetCFrame
                end
            end
        end
    end
end)

-- Inf Jump Fix
uis.JumpRequest:Connect(function()
    if Toggles.InfJump and lp.Character then
        local hum = lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- [[ 3. LUXURY UI DESIGN (ONYX & BLUE) ]] --
local function BuildUI()
    for _, v in pairs(pgui:GetChildren()) do if v.Name == "SKYJACK_ONYX" then v:Destroy() end end
    Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "SKYJACK_ONYX"
    Screen.IgnoreGuiInset = true

    -- LOGIN PANEL
    KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 400, 0, 320)
    KeyPanel.Position = UDim2.new(0.5, -200, 0.4, 0)
    KeyPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    KeyPanel.BorderSizePixel = 0
    KeyPanel.Active, KeyPanel.Draggable = true, true
    Instance.new("UICorner", KeyPanel).CornerRadius = UDim.new(0, 20)
    
    local stroke = Instance.new("UIStroke", KeyPanel)
    stroke.Color = Color3.fromRGB(0, 150, 255)
    stroke.Thickness = 1.5

    local Header = Instance.new("TextLabel", KeyPanel)
    Header.Size = UDim2.new(1, 0, 0, 60)
    Header.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Header.Text = "SKYJACK PREMIER ACCESS"
    Header.TextColor3 = Color3.fromRGB(0, 150, 255)
    Header.Font = Enum.Font.GothamBold
    Header.TextSize = 16
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 20)

    KeyInput = Instance.new("TextBox", KeyPanel)
    KeyInput.Size = UDim2.new(0.85, 0, 0, 50)
    KeyInput.Position = UDim2.new(0.075, 0, 0.4, 0)
    KeyInput.PlaceholderText = "ENTER PRODUCT KEY"
    KeyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    KeyInput.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 10)

    local LoginBtn = Instance.new("TextButton", KeyPanel)
    LoginBtn.Size = UDim2.new(0.85, 0, 0, 60)
    LoginBtn.Position = UDim2.new(0.075, 0, 0.68, 0)
    LoginBtn.Text = "VALIDATE LICENSE"
    LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    LoginBtn.TextColor3 = Color3.new(1,1,1)
    LoginBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 10)

    -- MAIN PANEL
    Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 300, 0, 580)
    Main.Position = UDim2.new(0.05, 0, 0.2, 0)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    Main.Visible = false
    Main.Active, Main.Draggable = true, true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 20)
    local mStroke = Instance.new("UIStroke", Main)
    mStroke.Color = Color3.fromRGB(0, 150, 255)
    mStroke.Thickness = 1.5

    local MTitle = Instance.new("TextLabel", Main)
    MTitle.Size = UDim2.new(1, 0, 0, 60)
    MTitle.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MTitle.Text = "SKYJACK RBX v230"
    MTitle.TextColor3 = Color3.fromRGB(0, 150, 255)
    MTitle.Font = Enum.Font.GothamBold
    MTitle.TextSize = 18
    Instance.new("UICorner", MTitle).CornerRadius = UDim.new(0, 20)

    MinBtn = Instance.new("TextButton", Main)
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -40, 0, 15)
    MinBtn.Text = "−"
    MinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    MinBtn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)

    LoginBtn.MouseButton1Click:Connect(function()
        local success, result = pcall(function() return game:HttpGet(DATABASE_URL) end)
        if success then
            local data = HttpService:JSONDecode(result)
            if data.KEY_LIST[KeyInput.Text] then
                KeyPanel:Destroy()
                Main.Visible = true
                Toggles.Shield = ActivateShield() -- Auto-activate on login
            end
        end
    end)
end

BuildUI()

-- [[ 4. NAVIGATION SYSTEM ]] --
local function Refresh()
    for i, b in ipairs(Buttons) do
        local k = Keys[i]
        b.Visible = not IsMinimized
        b.Text = Names[i] .. (Toggles[k] and " [ACTIVE]" or " [OFF]")
        b.BackgroundColor3 = (i == Index) and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(25, 25, 30)
        b.TextColor3 = (i == Index) and Color3.new(1,1,1) or Color3.fromRGB(150, 150, 150)
        b.BackgroundTransparency = (i == Index) and 0 or 0.5
    end
end

for i = 1, #Names do
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, -30, 0, 70)
    b.Position = UDim2.new(0, 15, 0, (i * 80) - 10)
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
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
            Toggles.Shield = ActivateShield()
        else
            Toggles[key] = not Toggles[key]
        end
        Refresh() 
    end
end)

MinBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    Main:TweenSize(IsMinimized and UDim2.new(0, 300, 0, 60) or UDim2.new(0, 300, 0, 580), "Out", "Quart", 0.4, true)
    Refresh()
end)

Refresh()
