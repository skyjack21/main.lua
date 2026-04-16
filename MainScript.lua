-- [[ SKYJACK RBX v1500: TRUE-STABLE - PHYSICAL ACTIVE FEATURES ]] --
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local pgui = lp:WaitForChild("PlayerGui", 20)
local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/d9a4102ad46bbcf1399d208b03e57ead4bb46af8/gistfile1.txt"

-- Master Reset States
local Running = true
local Screen, Main, KeyPanel
local Toggles = {Speed = false, WallPass = false, InfJump = false, Vip = false, HideName = false, Shield = false, AutoWalk = false}
local Keys = {"Speed", "WallPass", "InfJump", "Vip", "HideName", "Shield", "AutoWalk"}
local Names = {"STABLE SPEED (90)", "NOCLIP WALL", "INFINITE JUMP", "VIP INJECTOR", "GHOST NAME", "ANTI-KICK", "AUTO SUMMIT"}
local Buttons = {}
local Index = 1

-- [[ 1. REAL GHOST NAME (SERVER-SIDE MASKING) ]] --
local function GhostLogic()
    task.spawn(function()
        while Running do
            if Toggles.HideName and lp.Character then
                pcall(function()
                    local hum = lp.Character:FindFirstChildOfClass("Humanoid")
                    hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                    -- Menghapus semua Gui di karakter secara paksa
                    for _, v in pairs(lp.Character:GetDescendants()) do
                        if v:IsA("BillboardGui") or v:IsA("SurfaceGui") or v:IsA("TextLabel") then
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

-- [[ 2. BODYPHYSICS ENGINE (TANGGA & TANJAKAN FIX) ]] --
local BV = Instance.new("BodyVelocity")
BV.MaxForce = Vector3.new(1e6, 0, 1e6) -- Sumbu Y dikunci 0 agar tidak terbang/noclip bawah

rs.Heartbeat:Connect(function()
    if not Running or not lp.Character then return end
    local hum = lp.Character:FindFirstChildOfClass("Humanoid")
    local root = lp.Character:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    -- SPEED & AUTO WALK LOGIC
    if (Toggles.Speed and hum.MoveDirection.Magnitude > 0) or Toggles.AutoWalk then
        BV.Parent = (hum.SeatPart and hum.SeatPart.Parent:IsA("Model")) and (hum.SeatPart.Parent.PrimaryPart or hum.SeatPart) or root
        
        local moveDir = hum.MoveDirection
        
        -- AUTO WALK: Mencari Checkpoint terdekat jika tidak ada input manual
        if Toggles.AutoWalk and hum.MoveDirection.Magnitude == 0 then
            local target = workspace:FindFirstChild("Checkpoint") or workspace:FindFirstChild("Summit")
            if target then
                moveDir = (target.Position - root.Position).Unit
            end
        end

        -- Speed disetel di 90 (Kencang tapi mesin fisika Roblox masih sanggup baca tangga)
        BV.Velocity = Vector3.new(moveDir.X * 90, 0, moveDir.Z * 90)
    else
        BV.Velocity = Vector3.new(0, 0, 0)
        BV.Parent = nil
    end

    -- NOCLIP
    if Toggles.WallPass then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- [[ 3. FUNCTIONAL VIP & ANTI-KICK ]] --
local function StartInjections()
    -- ANTI-KICK (Metatable Hook)
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if Toggles.Shield and (method == "Kick" or method == "kick") then return nil end
        return old(self, ...)
    end)
    setreadonly(mt, true)
    
    -- VIP TOUCHER
    task.spawn(function()
        while Running do
            if Toggles.Vip and lp.Character:FindFirstChild("HumanoidRootPart") then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("TouchTransmitter") and (v.Parent.Name:lower():find("vip") or v.Parent.Name:lower():find("pass")) then
                        firetouchinterest(lp.Character.HumanoidRootPart, v.Parent, 0)
                        firetouchinterest(lp.Character.HumanoidRootPart, v.Parent, 1)
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end

-- [[ 4. CLEAN PRO UI ]] --
local function BuildUI()
    for _, v in pairs(pgui:GetChildren()) do if v.Name == "STABLE_V1500" then v:Destroy() end end
    Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "STABLE_V1500"
    Screen.IgnoreGuiInset = true

    KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 240, 0, 150)
    KeyPanel.Position = UDim2.new(0.5, -120, 0.4, 0)
    KeyPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UICorner", KeyPanel).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", KeyPanel).Color = Color3.fromRGB(0, 170, 255)

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
    LoginBtn.Text = "ACTIVATE"
    LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    LoginBtn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 5)

    Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 170, 0, 380)
    Main.Position = UDim2.new(0.02, 0, 0.25, 0)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Main.Visible = false
    Main.Active, Main.Draggable = true, true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 170, 255)

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
        b.BackgroundColor3 = (i == Index) and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(25, 25, 25)
    end
end

for i = 1, #Names do
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, -12, 0, 45)
    b.Position = UDim2.new(0, 6, 0, (i * 50) - 30)
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 8
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    table.insert(Buttons, b)
end

uis.InputBegan:Connect(function(k, g)
    if k.KeyCode == Enum.KeyCode.F8 then Running = false BV:Destroy() Screen:Destroy() end
    if k.KeyCode == Enum.KeyCode.L then if Main then Main.Visible = not Main.Visible end end
    if g or not Main or not Main.Visible then return end
    if k.KeyCode == Enum.KeyCode.Up then Index = (Index > 1) and Index - 1 or #Names Refresh()
    elseif k.KeyCode == Enum.KeyCode.Down then Index = (Index < #Names) and Index + 1 or 1 Refresh()
    elseif k.KeyCode == Enum.KeyCode.Return then 
        local key = Keys[Index] Toggles[key] = not Toggles[key] Refresh() 
    end
end)

Refresh()
