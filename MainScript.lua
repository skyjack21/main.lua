-- [[ OMNI v165: SKYJACK RBX - ULTIMATE STABILITY ]] --
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local pgui = lp:WaitForChild("PlayerGui", 20)

local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/d9a4102ad46bbcf1399d208b03e57ead4bb46af8/gistfile1.txt"

-- Config & State
local Screen, KeyPanel, Main, Status, KeyInput, MinBtn
local IsMinimized = false
local Toggles = {Speed = false, Noclip = false, InfJump = false, VipBypass = false, HideName = false, AntiBan = false}
local Keys = {"Speed", "Noclip", "InfJump", "VipBypass", "HideName", "AntiBan"}
local Names = {"WALK SPEED", "NOCLIP (WALLPASS)", "INFINITE JUMP", "VIP PASS BYPASS", "HIDE MY NAME", "ANTI-BAN SHIELD"}
local Buttons = {}
local Index, SpeedMult = 1, 2.5

-- [[ 1. IMPROVED ENGINE (FIXED CLIMBING & COLLISION) ]] --
rs.RenderStepped:Connect(function()
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    
    if root and hum and hum.MoveDirection.Magnitude > 0 then
        -- Anti-Tembus saat Speed (Smart Speed)
        if Toggles.Speed then
            local movePos = hum.MoveDirection * SpeedMult
            -- Deteksi apakah ada tembok di depan sebelum maju
            local rayParam = RaycastParams.new()
            rayParam.FilterDescendantsInstances = {char}
            local hit = workspace:Raycast(root.Position, hum.MoveDirection * 3, rayParam)
            
            if not hit or Toggles.Noclip then
                root.CFrame = root.CFrame + movePos
            end
        end
        
        -- Noclip Logic (Only when ON)
        if Toggles.Noclip then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
            end
        end
    end
    
    if Toggles.HideName and char and char:FindFirstChild("Head") then
        for _, v in pairs(char.Head:GetChildren()) do
            if v:IsA("BillboardGui") then v.Enabled = false end
        end
    end
end)

-- Anti-Ban Fix (Hardcoded Protection)
local function EnableShield()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if self == lp and (method:lower() == "kick" or method == "BreakJoints") then
            return nil
        end
        return old(self, ...)
    end)
    setreadonly(mt, true)
end

-- Jump & VIP Persistence
task.spawn(function()
    while task.wait(0.1) do
        if Toggles.InfJump and uis:IsKeyDown(Enum.KeyCode.Space) and lp.Character then
            lp.Character.HumanoidRootPart.Velocity = Vector3.new(lp.Character.HumanoidRootPart.Velocity.X, 55, lp.Character.HumanoidRootPart.Velocity.Z)
        end
        if Toggles.VipBypass then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Name:lower():find("vip") then v.CanCollide = false v.Transparency = 0.5 end
            end
        end
    end
end)

-- [[ 2. UI CONSTRUCTION ]] --
local function BuildUI()
    for _, old in ipairs(pgui:GetChildren()) do if old.Name:find("SKYJACK") then old:Destroy() end end
    Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "SKYJACK_V165"
    Screen.ResetOnSpawn = false

    -- Main Panel
    Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 260, 0, 580)
    Main.Position = UDim2.new(0.1, 0, 0.2, 0)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    Main.Visible = false
    Main.Active, Main.Draggable = true, true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
    local stroke = Instance.new("UIStroke", Main)
    stroke.Color = Color3.fromRGB(200, 0, 0)
    stroke.Thickness = 2

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 55)
    Title.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    Title.Text = "SKYJACK RBX"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 15)

    -- Login Panel
    KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 350, 0, 280)
    KeyPanel.Position = UDim2.new(0.5, -175, 0.4, 0)
    KeyPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    KeyPanel.Active, KeyPanel.Draggable = true, true
    Instance.new("UICorner", KeyPanel).CornerRadius = UDim.new(0, 15)
    local kStroke = Instance.new("UIStroke", KeyPanel)
    kStroke.Color = Color3.fromRGB(255, 0, 0)
    kStroke.Thickness = 2

    KeyInput = Instance.new("TextBox", KeyPanel)
    KeyInput.Size = UDim2.new(0.85, 0, 0, 50)
    KeyInput.Position = UDim2.new(0.075, 0, 0.38, 0)
    KeyInput.PlaceholderText = "Paste Key..."
    KeyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    KeyInput.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", KeyInput)

    local CheckBtn = Instance.new("TextButton", KeyPanel)
    CheckBtn.Size = UDim2.new(0.85, 0, 0, 50)
    CheckBtn.Position = UDim2.new(0.075, 0, 0.65, 0)
    CheckBtn.Text = "ACTIVATE"
    CheckBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
    CheckBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", CheckBtn)

    -- Buttons logic
    MinBtn = Instance.new("TextButton", Main)
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -78, 0, 12)
    MinBtn.Text = "-"
    MinBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    MinBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(1, 0)

    CheckBtn.MouseButton1Click:Connect(function()
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

-- [[ 3. CONTROL REFRESH ]] --
local function Refresh()
    for i, b in ipairs(Buttons) do
        local k = Keys[i]
        b.Visible = not IsMinimized
        b.Text = Names[i] .. (Toggles[k] and " [ON]" or " [OFF]")
        b.BackgroundColor3 = (i == Index) and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(25, 25, 30)
    end
end

for i = 1, #Names do
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, -24, 0, 75)
    b.Position = UDim2.new(0, 12, 0, (i * 85) - 25)
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
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

MinBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    Main:TweenSize(IsMinimized and UDim2.new(0, 260, 0, 55) or UDim2.new(0, 260, 0, 580), "Out", "Back", 0.3, true)
    Refresh()
end)

Refresh()
