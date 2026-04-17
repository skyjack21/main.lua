-- [[ SKYJACK OMEGA v3200: HYBRID STABILITY ]] --
-- Menggabungkan Login System v140 dengan Engine Supreme v3200
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local pgui = lp:WaitForChild("PlayerGui", 15)

-- Link Database Anda
local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/d9a4102ad46bbcf1399d208b03e57ead4bb46af8/gistfile1.txt"

-- [[ 1. UI BUILDER (MENGGUNAKAN STRUKTUR LAMA YANG STABIL) ]] --
local function BuildUI()
    if pgui:FindFirstChild("SKYJACK_OMEGA_V3200") then pgui.SKYJACK_OMEGA_V3200:Destroy() end
    local Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "SKYJACK_OMEGA_V3200"
    Screen.ResetOnSpawn = false

    -- PANEL LOGIN
    local KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 320, 0, 240) [cite: 2]
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
    KeyInput.Size = UDim2.new(0.85, 0, 0, 45) [cite: 3]
    KeyInput.Position = UDim2.new(0.075, 0, 0.35, 0)
    KeyInput.PlaceholderText = "Enter Key Here..."
    KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    KeyInput.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", KeyInput)

    local CheckBtn = Instance.new("TextButton", KeyPanel)
    CheckBtn.Size = UDim2.new(0.85, 0, 0, 45)
    CheckBtn.Position = UDim2.new(0.075, 0, 0.6, 0)
    CheckBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
    CheckBtn.Text = "CHECK KEY"
    CheckBtn.Font = Enum.Font.GothamBold [cite: 4]
    Instance.new("UICorner", CheckBtn)

    local Status = Instance.new("TextLabel", KeyPanel)
    Status.Size = UDim2.new(1, 0, 0, 30)
    Status.Position = UDim2.new(0, 0, 0.85, 0)
    Status.BackgroundTransparency = 1
    Status.Text = "Awaiting Key..."
    Status.TextColor3 = Color3.new(0.8, 0.8, 0.8)

    -- PANEL CHEAT UTAMA (Hidden at Start)
    local Main = Instance.new("Frame", Screen)
    Main.Size = UDim2.new(0, 200, 0, 420)
    Main.Position = UDim2.new(0.02, 0, 0.25, 0) [cite: 5]
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    Main.Visible, Main.Active, Main.Draggable = false, true, true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(0, 255, 120)
    Stroke.Thickness = 2

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "SKYJACK SUPREME v3200"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.BackgroundTransparency = 1

    return Screen, KeyPanel, Main, CheckBtn, KeyInput, Status
end

local Screen, KeyPanel, Main, CheckBtn, KeyInput, Status = BuildUI() [cite: 6]

-- [[ 2. MASTER FEATURES CONFIG ]] --
getgenv().SkyjackMaster = {
    Speed = false,      -- Supreme Speed (2.3)
    WallPass = false,   -- Ghost Noclip
    InfJump = false,    -- Physical Infinite Jump
    Vip = false,        -- System VIP Bypass
    HideName = false,   -- Identity Cleaner
    Shield = false,     -- Anti-Kick Shield
    AutoWalk = false    -- Stealth Auto Summit
}

local T = getgenv().SkyjackMaster
local Keys = {"Speed", "WallPass", "InfJump", "Vip", "HideName", "Shield", "AutoWalk"}
local Names = {"SUPREME SPEED (2.3)", "GHOST NOCLIP", "PHYSICAL INF JUMP", "SYSTEM VIP BYPASS", "IDENTITY CLEANER", "ANTI-KICK SHIELD", "STEALTH AUTO SUMMIT"}
local Buttons = {}
local Index = 1

-- [[ 3. LOGIN LOGIC (GIST GITHUB) ]] --
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
        local data = HttpService:JSONDecode(result) [cite: 7]
        local keyData = data.KEY_LIST[input]

        if keyData then
            local yr, mo, dy = keyData.Exp:match("(%d+)-(%d+)-(%d+)")
            local expTime = os.time({year=yr, month=mo, day=dy})
            if os.time() < expTime then
                Status.Text = "ACCESS GRANTED!" [cite: 8]
                Status.TextColor3 = Color3.new(0, 1, 0)
                task.wait(0.5)
                KeyPanel:Destroy()
                Main.Visible = true
            else
                Status.Text = "KEY EXPIRED!" [cite: 9]
                Status.TextColor3 = Color3.new(1, 0.5, 0)
            end
        else
            Status.Text = "INVALID KEY!"
            Status.TextColor3 = Color3.new(1, 0, 0)
        end
    else
        Status.Text = "SERVER ERROR!" [cite: 10]
    end
end)

-- [[ 4. CORE ENGINE (SPEED, NOCLIP, BYPASS) ]] --
-- Anti-Kick & VIP Bypass
task.spawn(function()
    pcall(function()
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        local oldIndex = mt.__index
        setreadonly(mt, false)

        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if T.Shield and (method == "Kick" or method == "kick") then return nil end
            if T.Vip and (method == "UserOwnsGamePassAsync" or method == "PlayerOwnsAsset" or method == "CheckGamepass") then
                return true
            end
            return oldNamecall(self, ...)
        end)

        mt.__index = newcclosure(function(t, k)
            if T.Vip and (k == "UserOwnsGamePassAsync" or k == "PlayerOwnsAsset") then
                return function() return true end
            end
            return oldIndex(t, k)
        end)
        setreadonly(mt, true)
    end)
end)

-- Movement Engine
rs.Heartbeat:Connect(function()
    if not Main.Visible then return end
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid") [cite: 11]
    if not root or not hum then return end

    if T.Speed and hum.MoveDirection.Magnitude > 0 then
        root.CFrame = root.CFrame + (hum.MoveDirection * 2.3)
    end

    if T.WallPass then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end

    if T.AutoWalk then
        local target = workspace:FindFirstChild("Checkpoint") or workspace:FindFirstChild("Summit")
        if target then hum:MoveTo(target.Position) end
    end
end)

-- [[ 5. BUTTON GENERATOR & REFRESH ]] --
local function Refresh() [cite: 12]
    for i, b in ipairs(Buttons) do
        local key = Keys[i]
        b.Text = Names[i] .. (T[key] and " [ON]" or " [OFF]")
        b.BackgroundColor3 = (i == Index) and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(22, 22, 28)
        b.TextColor3 = (i == Index) and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
    end
end

for i = 1, #Names do
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, -16, 0, 44)
    b.Position = UDim2.new(0, 8, 0, (i * 50) - 5)
    b.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    b.Font = Enum.Font.GothamBold [cite: 13]
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 8
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    table.insert(Buttons, b)
end

uis.InputBegan:Connect(function(k, g)
    if k.KeyCode == Enum.KeyCode.L then Main.Visible = not Main.Visible end
    if g or not Main.Visible then return end
    if k.KeyCode == Enum.KeyCode.Up then 
        Index = (Index > 1) and Index - 1 or #Names Refresh()
    elseif k.KeyCode == Enum.KeyCode.Down then 
        Index = (Index < #Names) and Index + 1 or 1 Refresh()
    elseif k.KeyCode == Enum.KeyCode.Return then 
        T[Keys[Index]] = not T[Keys[Index]] [cite: 14]
        Refresh()
    end
end)

Refresh()
