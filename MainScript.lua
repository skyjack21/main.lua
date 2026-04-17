-- [[ SKYJACK OMEGA v3300: INTEGRATED STABILITY ]] --
-- Perbaikan Total: Mempertahankan Struktur GUI Asli & Menambah Fitur Lengkap
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local pgui = lp:WaitForChild("PlayerGui", 15)

-- Link Database Gist Anda
local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/d9a4102ad46bbcf1399d208b03e57ead4bb46af8/gistfile1.txt"

-- [[ 1. UI BUILDER (STRUKTUR ASLI PERTAHANKAN) ]] --
local function BuildUI()
    if pgui:FindFirstChild("SKYJACK_OMEGA_V3300") then pgui.SKYJACK_OMEGA_V3300:Destroy() end
    local Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "SKYJACK_OMEGA_V3300"
    Screen.ResetOnSpawn = false

    -- PANEL LOGIN (Struktur v140)
    local KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 320, 0, 240)
    KeyPanel.Position = UDim2.new(0.5, -160, 0.4, 0)
    KeyPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    KeyPanel.Active, KeyPanel.Draggable = true, true
    Instance.new("UICorner", KeyPanel)

    local KTitle = Instance.new("TextLabel", KeyPanel)
    KTitle.Size = UDim2.new(1, 0, 0, 45)
    KTitle.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
    KTitle.Text = "LOGIN SYSTEM (8-CHAR)"
    KTitle.TextColor3 = Color3.new(0, 0, 0)
    KTitle.Font = Enum.Font.GothamBold
    Instance.new("UICorner", KTitle)

    local KeyInput = Instance.new("TextBox", KeyPanel)
    KeyInput.Size = UDim2.new(0.85, 0, 0, 45)
    KeyInput.Position = UDim2.new(0.075, 0, 0.35, 0)
    KeyInput.PlaceholderText = "Enter Key Here..."
    KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    KeyInput.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", KeyInput)

    local CheckBtn = Instance.new("TextButton", KeyPanel)
    CheckBtn.Size = UDim2.new(0.85, 0, 0, 45)
    CheckBtn.Position = UDim2.new(0.075, 0, 0.6, 0)
    CheckBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
    CheckBtn.Text = "CHECK KEY"
    CheckBtn.TextColor3 = Color3.new(1, 1, 1)
    CheckBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", CheckBtn)

    local Status = Instance.new("TextLabel", KeyPanel)
    Status.Size = UDim2.new(1, 0, 0, 30)
    Status.Position = UDim2.new(0, 0, 0.85, 0)
    Status.BackgroundTransparency = 1
    Status.Text = "Awaiting Key..."
    Status.TextColor3 = Color3.new(0.8, 0.8, 0.8)

    -- PANEL CHEAT UTAMA (Hidden at Start)
    local Main = Instance.new("Frame", Screen)
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 240, 0, 520)
    Main.Position = UDim2.new(0.1, 0, 0.2, 0)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Main.Visible, Main.Active, Main.Draggable = false, true, true
    Instance.new("UICorner", Main)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 120)

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
    Title.Text = "SKYJACK OMEGA v3300"
    Title.TextColor3 = Color3.new(0, 0, 0)
    Title.Font = Enum.Font.GothamBold
    Instance.new("UICorner", Title)

    return Screen, KeyPanel, Main, CheckBtn, KeyInput, Status
end

-- Menjalankan Builder dengan variabel lengkap agar tidak nil
local Screen, KeyPanel, Main, CheckBtn, KeyInput, Status = BuildUI()

-- [[ 2. MASTER FEATURES CONFIG ]] --
local Toggles = {
    Speed = false,      -- Kecepatan 2.3
    WallPass = false,   -- Noclip
    InfJump = false,    -- Infinite Jump
    Vip = false,        -- VIP Bypass
    FakeName = false,   -- Identity Cleaner
    Shield = false,     -- Anti-Kick
    AutoWalk = false    -- Auto Summit
}

local Keys = {"Speed", "WallPass", "InfJump", "Vip", "FakeName", "Shield", "AutoWalk"}
local Names = {"SPEED ENGINE (2.3)", "GHOST NOCLIP", "AIR JUMP", "VIP BYPASS", "GHOST IDENTITY", "ANTI-KICK SHIELD", "AUTO SUMMIT"}
local Buttons = {}
local Index = 1

-- [[ 3. LOGIN LOGIC ]] --
CheckBtn.MouseButton1Click:Connect(function()
    local input = KeyInput.Text
    if #input ~= 8 then
        Status.Text = "KEY HARUS 8 KARAKTER!"
        Status.TextColor3 = Color3.new(1, 0, 0)
        return
    end

    Status.Text = "Verifying..."
    local success, result = pcall(function() return game:HttpGet(DATABASE_URL) end)

    if success then
        local data = HttpService:JSONDecode(result)
        local keyData = data.KEY_LIST[input]

        if keyData then
            Status.Text = "ACCESS GRANTED!"
            Status.TextColor3 = Color3.new(0, 1, 0)
            task.wait(1)
            KeyPanel:Destroy()
            Main.Visible = true
        else
            Status.Text = "KEY TIDAK VALID!"
            Status.TextColor3 = Color3.new(1, 0, 0)
        end
    else
        Status.Text = "SERVER ERROR!"
    end
end)

-- [[ 4. CORE ENGINE (ANTI-CRASH) ]] --
pcall(function()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    local oldIndex = mt.__index
    setreadonly(mt, false)

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if Toggles.Shield and (method == "Kick" or method == "kick") then return nil end
        if Toggles.Vip and (method == "UserOwnsGamePassAsync" or method == "PlayerOwnsAsset") then return true end
        return oldNamecall(self, ...)
    end)

    mt.__index = newcclosure(function(t, k)
        if Toggles.Vip and (k == "UserOwnsGamePassAsync" or k == "PlayerOwnsAsset") then
            return function() return true end
        end
        return oldIndex(t, k)
    end)
    setreadonly(mt, true)
end)

rs.RenderStepped:Connect(function()
    if not Main.Visible then return end
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    if Toggles.Speed and hum.MoveDirection.Magnitude > 0 then
        root.CFrame = root.CFrame + (hum.MoveDirection * 2.3)
    end

    if Toggles.WallPass then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end

    if Toggles.AutoWalk then
        local goal = workspace:FindFirstChild("Checkpoint") or workspace:FindFirstChild("Summit")
        if goal then hum:MoveTo(goal.Position) end
    end
end)

-- [[ 5. BUTTON GENERATOR & REFRESH ]] --
local function Refresh()
    for i, b in ipairs(Buttons) do
        local k = Keys[i]
        b.Text = Names[i] .. (Toggles[k] and " [ON]" or " [OFF]")
        b.BackgroundColor3 = (i == Index) and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(25, 25, 30)
        b.TextColor3 = (i == Index) and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
    end
end

for i = 1, #Names do
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, -20, 0, 60)
    b.Position = UDim2.new(0, 10, 0, (i * 68) - 20)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 10
    Instance.new("UICorner", b)
    table.insert(Buttons, b)
end

uis.InputBegan:Connect(function(k, g)
    if k.KeyCode == Enum.KeyCode.L then Main.Visible = not Main.Visible end
    if g or not Main.Visible then return end
    if k.KeyCode == Enum.KeyCode.Up then Index = (Index > 1) and Index - 1 or #Names Refresh()
    elseif k.KeyCode == Enum.KeyCode.Down then Index = (Index < #Names) and Index + 1 or 1 Refresh()
    elseif k.KeyCode == Enum.KeyCode.Return then 
        Toggles[Keys[Index]] = not Toggles[Keys[Index]] 
        Refresh()
    end
end)

Refresh()
