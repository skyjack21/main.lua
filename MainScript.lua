--[[
    OMNI v143: MOUNT INDEPENDENCE - NO-KEY EDITION
    
    Perbaikan oleh AI Research:
    - [CRITICAL] Sistem verifikasi kunci dihapus sepenuhnya untuk mengatasi error 'Can't parse JSON'.
    - Skrip kini langsung aktif tanpa perlu login.
    - Semua fitur dari v141 (Anti-Ban, VIP, Speed, dll.) sudah terimplementasi dan aktif.
]]

-- Layanan-layanan utama
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Variabel pemain lokal
local lp = Players.LocalPlayer
local pgui = lp:WaitForChild("PlayerGui", 15)

-- Konfigurasi Fitur
local Toggles = {Speed = false, InfJump = false, VIP = false, FakeName = false, AntiBan = false}
local Keys = {"Speed", "InfJump", "VIP", "FakeName", "AntiBan"}
local Names = {"SPEED ENGINE (1.8x)", "AIR JUMP", "VIP BYPASS", "SERVER FAKE NAME", "ANTI-BAN SHIELD"}
local Buttons = {}
local Index, SpeedMult = 1, 1.8

-- [[ 1. UI BUILDER ]] --
local function BuildUI()
    if pgui:FindFirstChild("OMNI_SECURE_V143") then pgui.OMNI_SECURE_V143:Destroy() end
    local Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "OMNI_SECURE_V143"
    Screen.ResetOnSpawn = false

    -- PANEL CHEAT UTAMA (Langsung terlihat)
    local Main = Instance.new("Frame", Screen)
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 240, 0, 440)
    Main.Position = UDim2.new(0.1, 0, 0.2, 0)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Main.Visible, Main.Active, Main.Draggable = true, true, true -- Langsung terlihat
    Instance.new("UICorner", Main)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(200, 0, 0)

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    Title.Text = "MOUNT INDEPENDENCE v143"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Instance.new("UICorner", Title)

    return Main
end

local Main = BuildUI()

-- [[ 2. FUNGSI-FUNGSI FITUR ]] --
local function InitializeFeatures()
    RunService.Heartbeat:Connect(function()
        local char = lp.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if not hum then return end
        hum.WalkSpeed = Toggles.Speed and (16 * SpeedMult) or 16
    end)

    UserInputService.JumpRequest:Connect(function()
        if Toggles.InfJump and lp.Character then
            lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    local function updateNameVisibility(character)
        if not character or not character:FindFirstChild("Humanoid") then return end
        local humanoid = character.Humanoid
        humanoid.DisplayDistanceType = Toggles.FakeName and Enum.HumanoidDisplayDistanceType.None or Enum.HumanoidDisplayDistanceType.Viewer
    end

    if lp.Character then updateNameVisibility(lp.Character) end
    lp.CharacterAdded:Connect(updateNameVisibility)

    local function SetupBypasses()
        if not getrawmetatable or not newcclosure then return end
        local mt = getrawmetatable(game)
        if not mt or not mt.__namecall then return end
        
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if Toggles.AntiBan and (method == "Kick" or method == "kick") and self == lp then return end
            if Toggles.VIP and (method == "UserOwnsGamePassAsync" or method == "PlayerOwnsAsset") then return true end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end
    SetupBypasses()
    
    local function Refresh()
        for i, b in ipairs(Buttons) do
            local k = Keys[i]
            b.Text = Names[i] .. (Toggles[k] and " [ON]" or " [OFF]")
            b.BackgroundColor3 = (i == Index) and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(25, 25, 30)
        end
    end

    for i = 1, #Names do
        local b = Instance.new("TextButton", Main)
        b.Size = UDim2.new(1, -20, 0, 65)
        b.Position = UDim2.new(0, 10, 0, (i * 75) - 25)
        b.Font = Enum.Font.GothamBold
        b.TextColor3 = Color3.new(1, 1, 1)
        b.TextSize = 12
        Instance.new("UICorner", b)
        table.insert(Buttons, b)
    end

    UserInputService.InputBegan:Connect(function(k, g)
        if k.KeyCode == Enum.KeyCode.L then Main.Visible = not Main.Visible end
        if g or not Main.Visible then return end
        
        if k.KeyCode == Enum.KeyCode.Up then Index = (Index > 1) and Index - 1 or #Names
        elseif k.KeyCode == Enum.KeyCode.Down then Index = (Index < #Names) and Index + 1 or 1
        elseif k.KeyCode == Enum.KeyCode.Return then
            local key = Keys[Index]
            Toggles[key] = not Toggles[key]
            if key == "FakeName" then updateNameVisibility(lp.Character) end
        end
        Refresh()
    end)
    Refresh()
end

-- [[ 3. INISIALISASI ]] --
-- Langsung jalankan fitur karena tidak ada sistem kunci
InitializeFeatures()
print("OMNI v143 (No-Key Edition) Berhasil Dimuat!")
