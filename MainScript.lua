-- [[ SKYJACK RBX v220: TITAN - ULTIMATE PRECISION ]] --
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local pgui = lp:WaitForChild("PlayerGui", 20)
local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/d9a4102ad46bbcf1399d208b03e57ead4bb46af8/gistfile1.txt"

-- Titan System States
local Screen, KeyPanel, Main, Status, KeyInput, MinBtn
local IsMinimized = false
local Toggles = {Speed = false, WallPass = false, InfJump = false, VipAccess = false, HiddenMode = false, Shield = false}
local Keys = {"Speed", "WallPass", "InfJump", "VipAccess", "HiddenMode", "Shield"}
local Names = {"TITAN SPEED", "WALL PASS (NOCLIP)", "INFINITE JUMP", "VIP AREA ACCESS", "HIDDEN IDENTITY", "ANTI-BAN PROTECT"}
local Buttons = {}
local Index = 1
local FinalSpeed = 6.8 -- Kecepatan kencang yang stabil untuk Top Time
local LerpWeight = 0.65

-- [[ 1. PROTECTION & UTILITY ]] --
local function ForceShield()
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

-- [[ 2. TITAN ENGINE (FIXED SPEED-JUMP CONFLICT) ]] --
rs.RenderStepped:Connect(function()
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    
    if root and hum and hum.MoveDirection.Magnitude > 0 then
        if Toggles.Speed then
            -- MENGGUNAKAN CFRAME TANPA MENGGANGGU VELOCITY Y (LONCAT)
            local moveVec = hum.MoveDirection * FinalSpeed
            local nextPos = root.Position + moveVec
            
            if Toggles.WallPass then
                for _, p in pairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
                root.CFrame = root.CFrame:Lerp(CFrame.new(nextPos, nextPos + hum.MoveDirection), LerpWeight)
            else
                local ray = workspace:Raycast(root.Position, hum.MoveDirection * 3)
                if not ray then
                    -- Lerp hanya pada posisi X dan Z, biarkan Y tetap untuk gravitasi/lompat
                    local targetCFrame = CFrame.new(nextPos.X, root.Position.Y, nextPos.Z)
                    root.CFrame = root.CFrame:Lerp(targetCFrame, LerpWeight)
                end
            end
        end
    end
end)

-- Infinite Jump (Clean Execution)
uis.JumpRequest:Connect(function()
    if Toggles.InfJump and lp.Character then
        local hum = lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- [[ 3. LUXURY 2026 UI DESIGN ]] --
local function BuildUI()
    for _, v in pairs(pgui:GetChildren()) do if v.Name == "SKYJACK_TITAN" then v:Destroy() end end
    Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "SKYJACK_TITAN"
    Screen.IgnoreGuiInset = true

    -- LOGIN INTERFACE
    KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 420, 0, 350)
    KeyPanel.Position = UDim2.new(0.5, -210, 0.4, 0)
    KeyPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    KeyPanel.BorderSizePixel = 0
    KeyPanel.Active, KeyPanel.Draggable = true, true
    Instance.new("UICorner", KeyPanel).CornerRadius = UDim.new(0, 30)
    local strokeK = Instance.new("UIStroke", KeyPanel)
    strokeK.Color = Color3.fromRGB(200, 0, 0)
    strokeK.Thickness = 3

    local LHeader = Instance.new("TextLabel", KeyPanel)
    LHeader.Size = UDim2.new(1, 0, 0, 80)
    LHeader.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    LHeader.Text = "SKYJACK RBX | TITAN LOGIN"
    LHeader.TextColor3 = Color3.new(1,1,1)
    LHeader.Font = Enum.Font.GothamBold
    LHeader.TextSize = 18
    Instance.new("UICorner", LHeader).CornerRadius = UDim.new(0, 30)

    KeyInput = Instance.new("TextBox", KeyPanel)
    KeyInput.Size = UDim2.new(0.85, 0, 0, 60)
    KeyInput.Position = UDim2.new(0.075, 0, 0.45, 0)
    KeyInput.PlaceholderText = "ENTER PRODUCT KEY"
    KeyInput.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    KeyInput.TextColor3 = Color3.new(1,1,1)
    KeyInput.Font = Enum.Font.Gotham
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 15)

    local LoginBtn = Instance.new("TextButton", KeyPanel)
    LoginBtn.Size = UDim2.new(0.85, 0, 0, 70)
    LoginBtn.Position = UDim2.new(0.075, 0, 0.72, 0)
    LoginBtn.Text = "VALIDATE PRODUCT"
    LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
    LoginBtn.TextColor3 = Color3.new(1,1,1)
    LoginBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 15)

    -- MAIN FEATURE PANEL
    Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 340, 0, 680)
    Main.Position = UDim2.new(0.05, 0, 0.15, 0)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    Main.Visible = false
    Main.Active, Main.Draggable = true, true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 30)
    local strokeM = Instance.new("UIStroke", Main)
    strokeM.Color = Color3.fromRGB(200, 0, 0)
    strokeM.Thickness = 3

    local MTitle = Instance.new("TextLabel", Main)
    MTitle.Size = UDim2.new(1, 0, 0, 80)
    MTitle.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    MTitle.Text = "TITAN HUB"
    MTitle.TextColor3 = Color3.new(1,1,1)
    MTitle.Font = Enum.Font.GothamBold
    MTitle.TextSize = 25
    Instance.new("UICorner", MTitle).CornerRadius = UDim.new(0, 30)

    MinBtn = Instance.new("TextButton", Main)
    MinBtn.Size = UDim2.new(0, 40, 0, 40)
    MinBtn.Position = UDim2.new(1, -55, 0, 20)
    MinBtn.Text = "−"
    MinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
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

-- [[ 4. NAVIGATION & CONTROLS ]] --
local function Refresh()
    for i, b in ipairs(Buttons) do
        local k = Keys[i]
        b.Visible = not IsMinimized
        b.Text = Names[i] .. (Toggles[k] and " [ACTIVE]" or " [OFF]")
        b.BackgroundColor3 = (i == Index) and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(22, 22, 26)
        b.BackgroundTransparency = (i == Index) and 0 or 0.4
    end
end

for i = 1, #Names do
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, -30, 0, 85)
    b.Position = UDim2.new(0, 15, 0, (i * 95) - 5)
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
        if key == "Shield" and Toggles.Shield then ForceShield() end
        Refresh() 
    end
end)

MinBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    Main:TweenSize(IsMinimized and UDim2.new(0, 340, 0, 80) or UDim2.new(0, 340, 0, 680), "Out", "Quart", 0.5, true)
    Refresh()
end)

Refresh()
