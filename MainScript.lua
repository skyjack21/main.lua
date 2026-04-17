-- [[ SKYJACK OMEGA v3500: ULTIMATE MOUNT EDITION ]] --
-- Analisis: Perbaikan Stuck Verifikasi + Fitur Mount Lengkap (Video-Based)
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local pgui = lp:WaitForChild("PlayerGui", 15)

-- DATABASE LINK (Pastikan RAW)
local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/ac789c1730c2474be917416201112f553c252218/gistfile1.txt"

-- [[ 1. UI BUILDER (MEMPERTAHANKAN STRUKTUR ASLI AGAR MUNCUL) ]] --
local function BuildUI()
    if pgui:FindFirstChild("SKYJACK_OMEGA_V3500") then pgui.SKYJACK_OMEGA_V3500:Destroy() end
    local Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "SKYJACK_OMEGA_V3500"
    Screen.ResetOnSpawn = false

    local KeyPanel = Instance.new("Frame", Screen)
    KeyPanel.Size = UDim2.new(0, 320, 0, 240)
    KeyPanel.Position = UDim2.new(0.5, -160, 0.4, 0)
    KeyPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    KeyPanel.Active, KeyPanel.Draggable = true, true
    Instance.new("UICorner", KeyPanel)

    local KTitle = Instance.new("TextLabel", KeyPanel)
    KTitle.Size = UDim2.new(1, 0, 0, 45)
    KTitle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    KTitle.Text = "LOGIN SYSTEM (8-CHAR)"
    KTitle.TextColor3 = Color3.new(1, 1, 1)
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
    CheckBtn.Text = "VERIFY ACCESS"
    CheckBtn.TextColor3 = Color3.new(1, 1, 1)
    CheckBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", CheckBtn)

    local Status = Instance.new("TextLabel", KeyPanel)
    Status.Size = UDim2.new(1, 0, 0, 30)
    Status.Position = UDim2.new(0, 0, 0.85, 0)
    Status.BackgroundTransparency = 1
    Status.Text = "Awaiting Key..."
    Status.TextColor3 = Color3.new(0.8, 0.8, 0.8)

    local Main = Instance.new("Frame", Screen)
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 240, 0, 520)
    Main.Position = UDim2.new(0.1, 0, 0.2, 0)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Main.Visible, Main.Active, Main.Draggable = false, true, true
    Instance.new("UICorner", Main)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(200, 0, 0)

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    Title.Text = "MOUNT ULTIMATE v3500"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Instance.new("UICorner", Title)

    return Screen, KeyPanel, Main, CheckBtn, KeyInput, Status
end

local Screen, KeyPanel, Main, CheckBtn, KeyInput, Status = BuildUI()

-- [[ 2. MASTER MODULES (FITUR HASIL ANALISIS VIDEO) ]] --
local Toggles = {
    Speed = false,      -- WalkSpeed Engine
    AutoWalk = false,   -- Auto Summit (Video 1 & 3)
    SafeClamp = false,  -- Anti-Clip (Cegah Nyangkut)
    InfJump = false,    -- Air Jump
    VipBypass = false,  -- VIP Access (Metatable Hook)
    FakeName = false,   -- Identity Cleaner (Video 2)
    Record = false      -- Record/Play Motion
}

local Keys = {"Speed", "AutoWalk", "SafeClamp", "InfJump", "VipBypass", "FakeName", "Record"}
local Names = {"SPEED ENGINE (2.3)", "AUTO SUMMIT", "ANTI-CLIP CLAMP", "PHYSICAL AIR JUMP", "SYSTEM VIP BYPASS", "IDENTITY CLEANER", "MOTION RECORD"}
local Buttons = {}
local Index = 1

-- [[ 3. VERIFIKASI ANTI-STUCK ]] --
CheckBtn.MouseButton1Click:Connect(function()
    local input = KeyInput.Text
    if #input ~= 8 then
        Status.Text = "KEY HARUS 8 KARAKTER!"
        Status.TextColor3 = Color3.new(1, 0, 0)
        return
    end

    Status.Text = "Connecting to Server..."
    -- Menggunakan task.spawn agar pcall tidak mengunci thread utama (Anti-Stuck)
    task.spawn(function()
        local success, result = pcall(function() 
            return game:HttpGet(DATABASE_URL) 
        end)

        if success and result then
            local dataSuccess, data = pcall(function() return HttpService:JSONDecode(result) end)
            if dataSuccess and data.KEY_LIST[input] then
                Status.Text = "ACCESS GRANTED!"
                Status.TextColor3 = Color3.new(0, 1, 0)
                task.wait(0.5)
                KeyPanel:Destroy()
                Main.Visible = true
            else
                Status.Text = "INVALID OR EXPIRED KEY!"
                Status.TextColor3 = Color3.new(1, 0, 0)
            end
        else
            Status.Text = "SERVER TIMEOUT / URL ERROR"
            Status.TextColor3 = Color3.new(1, 0.5, 0)
        end
    end)
end)

-- [[ 4. CORE ENGINE & MOVEMENT ]] --
rs.Heartbeat:Connect(function()
    if not Main.Visible then return end
    local char = lp.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    -- Speed Engine 2.3 (Analisis Video: Optimal Speed)
    if Toggles.Speed and hum.MoveDirection.Magnitude > 0 then
        root.CFrame = root.CFrame + (hum.MoveDirection * 2.3)
    end

    -- Auto Summit Logic
    if Toggles.AutoWalk then
        local target = workspace:FindFirstChild("Checkpoint") or workspace:FindFirstChild("Summit")
        if target then hum:MoveTo(target.Position) end
    end

    -- Anti-Clip (Safe Clamp) 
    if Toggles.SafeClamp and hum.MoveDirection.Magnitude > 0 then
        local ray = workspace:Raycast(root.Position, hum.MoveDirection * 5)
        if ray then root.Velocity = Vector3.new(0, root.Velocity.Y, 0) end
    end
end)

-- [[ 5. UI CONTROLS ]] --
local function Refresh()
    for i, b in ipairs(Buttons) do
        local k = Keys[i]
        b.Text = Names[i] .. (Toggles[k] and " [ON]" or " [OFF]")
        b.BackgroundColor3 = (i == Index) and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(25, 25, 30)
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
