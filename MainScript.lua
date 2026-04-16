-- [[ SKYJACK RBX v1600: ULTIMATE MOUNT-STABLE - REBUILT FROM SCRATCH ]] --
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local pgui = lp:WaitForChild("PlayerGui", 20)
local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/d9a4102ad46bbcf1399d208b03e57ead4bb46af8/gistfile1.txt"

-- Master Configuration
local Running = true
local Screen, Main, KeyPanel
local Toggles = {Speed = false, WallPass = false, InfJump = false, Vip = false, HideName = false, Shield = false, AutoWalk = false}
local Keys = {"Speed", "WallPass", "InfJump", "Vip", "HideName", "Shield", "AutoWalk"}
local Names = {"STABLE MOUNT SPEED", "GHOST NOCLIP", "INFINITE JUMP", "VIP PASS INJECT", "GHOST IDENTITY", "ANTI-KICK PROTECTION", "STEALTH AUTO SUMMIT"}
local Buttons = {}
local Index = 1

-- [[ 1. GHOST IDENTITY - CLEAN LIVE MODE ]] --
local function GhostLogic()
    task.spawn(function()
        while Running do
            if Toggles.HideName and lp.Character then
                pcall(function()
                    local hum = lp.Character:FindFirstChildOfClass("Humanoid")
                    if hum then hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
                    for _, v in pairs(lp.Character:GetDescendants()) do
                        if v:IsA("BillboardGui") or v:IsA("SurfaceGui") or v:IsA("TextLabel") or v.Name:lower():find("tag") then
                            v.Enabled = false
                            v:Destroy()
                        end
                    end
                end)
            end
            task.wait(0.1)
        end
    end)
end

-- [[ 2. MOUNT-SYNC ENGINE (STAIRS & SLOPE FIX) ]] --
rs.Stepped:Connect(function()
    if not Running or not lp.Character then return end
    local hum = lp.Character:FindFirstChildOfClass("Humanoid")
    local root = lp.Character:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    -- SPEED & AUTO SUMMIT LOGIC
    if (Toggles.Speed and hum.MoveDirection.Magnitude > 0) or Toggles.AutoWalk then
        -- Deteksi apakah sedang di Mount
        local activeTarget = (hum.SeatPart and hum.SeatPart.Parent:IsA("Model")) and (hum.SeatPart.Parent.PrimaryPart or hum.SeatPart) or root
        
        local moveDir = hum.MoveDirection
        
        -- AUTO SUMMIT: Tanpa garis, langsung menuju objektif
        if Toggles.AutoWalk and hum.MoveDirection.Magnitude == 0 then
            local summit = workspace:FindFirstChild("Checkpoint") or workspace:FindFirstChild("Summit") or workspace:FindFirstChild("End")
            if summit then
                moveDir = (summit.Position - root.Position).Unit
            end
        end

        -- PERBAIKAN TANGGA: Menggunakan Frame-by-Frame CFrame Lerping agar tidak nembus (Noclip)
        -- Speed 75: Cepat, Stabil, dan tetap menapak tangga dengan sempurna
        local speedValue = 75
        if moveDir.Magnitude > 0 then
            activeTarget.CFrame = activeTarget.CFrame + (moveDir * (speedValue / 100))
        end
    end

    -- GHOST NOCLIP (Hanya aktif jika dicentang)
    if Toggles.WallPass then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    else
        for _, v in pairs(lp.Character:GetChildren()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.CanCollide = true end
        end
    end
end)

-- [[ 3. VIP & ANTI-KICK SECURITY ]] --
local function StartInjections()
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        if Toggles.Shield and (getnamecallmethod() == "Kick" or getnamecallmethod() == "kick") then return nil end
        return old(self, ...)
    end)
    setreadonly(mt, true)
    
    task.spawn(function()
        while Running and task.wait(0.5) do
            if Toggles.Vip and root then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("TouchTransmitter") and (v.Parent.Name:lower():find("vip") or v.Parent.Name:lower():find("pass")) then
                        firetouchinterest(root, v.Parent, 0)
                        firetouchinterest(root, v.Parent, 1)
                    end
                end
            end
        end
    end)
end

-- [[ 4. PRO UI SYSTEM ]] --
local function BuildUI()
    for _, v in pairs(pgui:GetChildren()) do if v.Name == "ULTIMATE_V1600" then v:Destroy() end end
    Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "ULTIMATE_V1600"
    Screen.IgnoreGuiInset = true

    KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 240, 0, 150)
    KeyPanel.Position = UDim2.new(0.5, -120, 0.4, 0)
    KeyPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    Instance.new("UICorner", KeyPanel).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", KeyPanel).Color = Color3.fromRGB(0, 200, 255)

    local KeyInput = Instance.new("TextBox", KeyPanel)
    KeyInput.Size = UDim2.new(0.8, 0, 0, 30)
    KeyInput.Position = UDim2.new(0.1, 0, 0.35, 0)
    KeyInput.PlaceholderText = "ENTER KEY"
    KeyInput.TextColor3 = Color3.new(1,1,1)
    KeyInput.BackgroundTransparency = 1
    KeyInput.Font = Enum.Font.Gotham

    local LoginBtn = Instance.new("TextButton", KeyPanel)
    LoginBtn.Size = UDim2.new(0.8, 0, 0, 35)
    LoginBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
    LoginBtn.Text = "ACTIVATE"
    LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 255)
    LoginBtn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 5)

    Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 175, 0, 380)
    Main.Position = UDim2.new(0.02, 0, 0.25, 0)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    Main.Visible = false
    Main.Active, Main.Draggable = true, true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 200, 255)

    LoginBtn.MouseButton1Click:Connect(function()
        local success, result = pcall(function() return game:HttpGet(DATABASE_URL) end)
        if success then
            local data = HttpService:JSONDecode(result)
            if data.KEY_LIST[KeyInput.Text] then
                KeyPanel:Destroy() Main.Visible = true StartInjections() GhostLogic() Toggles.Shield = true
            end
        end
    end)
end

BuildUI()

local function Refresh()
    for i, b in ipairs(Buttons) do
        local k = Keys[i]
        b.Text = Names[i] .. (Toggles[k] and " [ON]" or " [OFF]")
        b.BackgroundColor3 = (i == Index) and Color3.fromRGB(0, 160, 255) or Color3.fromRGB(25, 25, 30)
    end
end

for i = 1, #Names do
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, -12, 0, 42)
    b.Position = UDim2.new(0, 6, 0, (i * 48) - 20)
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 8
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    table.insert(Buttons, b)
end

uis.InputBegan:Connect(function(k, g)
    if k.KeyCode == Enum.KeyCode.F8 then Running = false Screen:Destroy() end
    if k.KeyCode == Enum.KeyCode.L then if Main then Main.Visible = not Main.Visible end end
    if g or not Main or not Main.Visible then return end
    if k.KeyCode == Enum.KeyCode.Up then Index = (Index > 1) and Index - 1 or #Names Refresh()
    elseif k.KeyCode == Enum.KeyCode.Down then Index = (Index < #Names) and Index + 1 or 1 Refresh()
    elseif k.KeyCode == Enum.KeyCode.Return then 
        local key = Keys[Index] Toggles[key] = not Toggles[key] Refresh() 
    end
end)

Refresh()
