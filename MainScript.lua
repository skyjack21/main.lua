-- [[ SKYJACK RBX v1700: ELITE-STREAMER - FULLY FUNCTIONAL RESET ]] --
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local pgui = lp:WaitForChild("PlayerGui", 20)
local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/d9a4102ad46bbcf1399d208b03e57ead4bb46af8/gistfile1.txt"

-- Final State Logic
local Running = true
local Screen, Main, KeyPanel
local Toggles = {Speed = false, WallPass = false, InfJump = false, Vip = false, HideName = false, Shield = false, AutoWalk = false}
local Keys = {"Speed", "WallPass", "InfJump", "Vip", "HideName", "Shield", "AutoWalk"}
local Names = {"STABLE SPEED", "GHOST NOCLIP", "INFINITE JUMP", "VIP INJECTOR", "GHOST IDENTITY", "ANTI-KICK SHIELD", "STEALTH AUTO WALK"}
local Buttons = {}
local Index = 1

-- [[ 1. INFINITE JUMP FIX (PHYSICAL INJECTION) ]] --
-- Fitur ini sekarang terpisah dari loop utama agar tidak delay
uis.JumpRequest:Connect(function()
    if Toggles.InfJump and lp.Character then
        local hum = lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- [[ 2. GHOST IDENTITY (RECURSIVE CLEANER) ]] --
local function GhostLogic()
    task.spawn(function()
        while Running do
            if Toggles.HideName and lp.Character then
                pcall(function()
                    lp.Character:FindFirstChildOfClass("Humanoid").DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                    for _, v in pairs(lp.Character:GetDescendants()) do
                        if v:IsA("BillboardGui") or v:IsA("SurfaceGui") or v:IsA("TextLabel") or v.Name:lower():find("tag") then
                            v:Destroy()
                        end
                    end
                end)
            end
            task.wait(0.1)
        end
    end)
end

-- [[ 3. VIP & ANTI-KICK (METATABLE BYPASS) ]] --
local function SecureInjections()
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        -- Memblokir fungsi Kick dari script game
        if Toggles.Shield and (method == "Kick" or method == "kick") then return nil end
        return old(self, ...)
    end)
    setreadonly(mt, true)

    -- VIP AUTO-TOUCHER (PHYSICAL INTEREST)
    task.spawn(function()
        while Running do
            if Toggles.Vip and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("TouchTransmitter") and (v.Parent.Name:lower():find("vip") or v.Parent.Name:lower():find("pass")) then
                        firetouchinterest(lp.Character.HumanoidRootPart, v.Parent, 0)
                        firetouchinterest(lp.Character.HumanoidRootPart, v.Parent, 1)
                    end
                end
            end
            task.wait(1)
        end
    end)
end

-- [[ 4. SPEED & AUTO-WALK ENGINE (STAIRS COMPATIBLE) ]] --
rs.Heartbeat:Connect(function()
    if not Running or not lp.Character then return end
    local hum = lp.Character:FindFirstChildOfClass("Humanoid")
    local root = lp.Character:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    if (Toggles.Speed and hum.MoveDirection.Magnitude > 0) or Toggles.AutoWalk then
        local activeObj = (hum.SeatPart and hum.SeatPart.Parent:IsA("Model")) and (hum.SeatPart.Parent.PrimaryPart or hum.SeatPart) or root
        local moveDir = hum.MoveDirection
        
        -- Auto Walk Logic (Target Finder)
        if Toggles.AutoWalk and hum.MoveDirection.Magnitude == 0 then
            local summit = workspace:FindFirstChild("Checkpoint") or workspace:FindFirstChild("Summit") or workspace:FindFirstChild("End")
            if summit then moveDir = (summit.Position - root.Position).Unit end
        end

        -- Fisika Pergerakan: Menggunakan pengalian CFrame agar tangga tetap terdeteksi
        if moveDir.Magnitude > 0 then
            activeObj.CFrame = activeObj.CFrame + (moveDir * 0.75) -- Speed konstan & stabil
        end
    end

    -- GHOST NOCLIP (Physical Collision Toggle)
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

-- [[ 5. MINIMALIST PRO UI ]] --
local function BuildUI()
    for _, v in pairs(pgui:GetChildren()) do if v.Name == "STREAMER_V1700" then v:Destroy() end end
    Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "STREAMER_V1700"
    Screen.IgnoreGuiInset = true

    KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 240, 0, 150)
    KeyPanel.Position = UDim2.new(0.5, -120, 0.4, 0)
    KeyPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Instance.new("UICorner", KeyPanel).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", KeyPanel).Color = Color3.fromRGB(0, 255, 150)

    local KeyInput = Instance.new("TextBox", KeyPanel)
    KeyInput.Size = UDim2.new(0.8, 0, 0, 30)
    KeyInput.Position = UDim2.new(0.1, 0, 0.35, 0)
    KeyInput.PlaceholderText = "INPUT KEY"
    KeyInput.TextColor3 = Color3.new(1,1,1)
    KeyInput.BackgroundTransparency = 1
    KeyInput.Font = Enum.Font.Gotham

    local LoginBtn = Instance.new("TextButton", KeyPanel)
    LoginBtn.Size = UDim2.new(0.8, 0, 0, 35)
    LoginBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
    LoginBtn.Text = "AUTHENTICATE"
    LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    LoginBtn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 5)

    Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 175, 0, 380)
    Main.Position = UDim2.new(0.02, 0, 0.25, 0)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    Main.Visible = false
    Main.Active, Main.Draggable = true, true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 150)

    LoginBtn.MouseButton1Click:Connect(function()
        local success, result = pcall(function() return game:HttpGet(DATABASE_URL) end)
        if success then
            local data = HttpService:JSONDecode(result)
            if data.KEY_LIST[KeyInput.Text] then
                KeyPanel:Destroy() Main.Visible = true SecureInjections() GhostLogic() Toggles.Shield = true
            end
        end
    end)
end

BuildUI()

local function Refresh()
    for i, b in ipairs(Buttons) do
        local k = Keys[i]
        b.Text = Names[i] .. (Toggles[k] and " [ACTIVE]" or " [OFF]")
        b.BackgroundColor3 = (i == Index) and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(25, 25, 30)
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
