--[[
    OMNI v141: MOUNT INDEPENDENCE - REPAIRED & ENHANCED
    
    Perbaikan oleh AI Research (berdasarkan MainScript.txt):
    - [FIXED] Fitur kini tetap aktif meskipun GUI ditutup dengan tombol 'L'.
    - [FIXED] Fitur Speed diubah ke WalkSpeed agar lebih stabil dan tidak menembus objek.
    - [ADDED] Implementasi fitur Anti-Ban (Anti-Kick) menggunakan __namecall hook.
    - [ADDED] Implementasi fitur VIP Bypass menggunakan __namecall hook.
    - [ADDED] Implementasi fitur Hide Name (Fake Name) berbasis event yang efisien.
    - [REMOVED] Fitur 'SafeClamp' yang tidak efektif dihapus.
    - Struktur kode disempurnakan untuk stabilitas.
]]

-- Layanan-layanan utama
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Variabel pemain lokal
local lp = Players.LocalPlayer
local pgui = lp:WaitForChild("PlayerGui", 15)

-- GANTI DENGAN LINK RAW GIST keys.json KAMU
local DATABASE_URL = "https://gist.githubusercontent.com/skyjack21/c75760f9714ba0777e44300702dfdd82/raw/d9a40102ad46bbcf1399d208b03e57ead4bb46af8/gistfile1.txt" 

-- Konfigurasi Fitur
local Toggles = {Speed = false, InfJump = false, VIP = false, FakeName = false, AntiBan = false}
local Keys = {"Speed", "InfJump", "VIP", "FakeName", "AntiBan"}
local Names = {"SPEED ENGINE (1.8x)", "AIR JUMP", "VIP BYPASS", "SERVER FAKE NAME", "ANTI-BAN SHIELD"}
local Buttons = {}
local Index, SpeedMult = 1, 1.8 -- Kecepatan disesuaikan agar lebih stabil

-- [[ 1. UI BUILDER (LOGIN & CHEAT PANELS) ]] --
local function BuildUI()
    if pgui:FindFirstChild("OMNI_SECURE_V141") then pgui.OMNI_SECURE_V141:Destroy() end
    local Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "OMNI_SECURE_V141"
    Screen.ResetOnSpawn = false

    -- PANEL LOGIN
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
    KeyInput.Text = ""
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
    Status.Font = Enum.Font.Gotham

    -- PANEL CHEAT UTAMA
    local Main = Instance.new("Frame", Screen)
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 240, 0, 440) -- Ukuran disesuaikan
    Main.Position = UDim2.new(0.1, 0, 0.2, 0)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Main.Visible, Main.Active, Main.Draggable = false, true, true
    Instance.new("UICorner", Main)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(200, 0, 0)

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    Title.Text = "MOUNT INDEPENDENCE v141"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Instance.new("UICorner", Title)

    return Screen, KeyPanel, Main, CheckBtn, KeyInput, Status
end

local Screen, KeyPanel, Main, CheckBtn, KeyInput, Status = BuildUI()

-- [[ 2. FUNGSI-FUNGSI FITUR ]] --

-- Fungsi untuk mengaktifkan fitur-fitur utama
local function InitializeFeatures()
    -- [FIXED] Loop fitur kini berjalan di Heartbeat untuk fisika yang lebih baik
    RunService.Heartbeat:Connect(function()
        local char = lp.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if not hum then return end

        -- [FIXED] Speed menggunakan WalkSpeed agar stabil
        hum.WalkSpeed = Toggles.Speed and (16 * SpeedMult) or 16
    end)

    -- [ADDED] Fitur Infinite Jump
    UserInputService.JumpRequest:Connect(function()
        if Toggles.InfJump and lp.Character then
            lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    -- [ADDED] Fungsi untuk Hide Name
    local function updateNameVisibility(character)
        if not character or not character:FindFirstChild("Humanoid") then return end
        local humanoid = character.Humanoid
        if Toggles.FakeName then
            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        else
            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
        end
    end

    -- [ADDED] Event untuk Hide Name
    if lp.Character then updateNameVisibility(lp.Character) end
    lp.CharacterAdded:Connect(updateNameVisibility)

    -- [ADDED] Fungsi untuk mengaktifkan Bypass
    local function SetupBypasses()
        if not getrawmetatable or not newcclosure then return end
        local mt = getrawmetatable(game)
        if not mt or not mt.__namecall then return end
        
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if Toggles.AntiBan and (method == "Kick" or method == "kick") and self == lp then
                return -- Blokir kick
            end
            if Toggles.VIP and (method == "UserOwnsGamePassAsync" or method == "PlayerOwnsAsset") then
                return true -- Berikan VIP
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end
    
    -- Panggil fungsi bypass
    SetupBypasses()
    
    -- [FIXED] Kontrol UI dipisahkan agar fitur tetap jalan saat GUI ditutup
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
        -- Tombol L untuk toggle visibilitas GUI
        if k.KeyCode == Enum.KeyCode.L then
            Main.Visible = not Main.Visible
        end
        
        -- Kontrol navigasi hanya berjalan jika GUI terlihat
        if g or not Main.Visible then return end
        
        if k.KeyCode == Enum.KeyCode.Up then
            Index = (Index > 1) and Index - 1 or #Names
            Refresh()
        elseif k.KeyCode == Enum.KeyCode.Down then
            Index = (Index < #Names) and Index + 1 or 1
            Refresh()
        elseif k.KeyCode == Enum.KeyCode.Return then
            local key = Keys[Index]
            Toggles[key] = not Toggles[key]
            Refresh()
            
            -- [ADDED] Panggil update nama saat tombol ditekan
            if key == "FakeName" then
                updateNameVisibility(lp.Character)
            end
        end
    end)
    Refresh()
end

-- [[ 3. CLOUD KEY VALIDATION ]] --
CheckBtn.MouseButton1Click:Connect(function()
    local input = KeyInput.Text
    if #input ~= 8 then
        Status.Text = "KEY HARUS 8 KARAKTER!"
        Status.TextColor3 = Color3.new(1, 0, 0)
        return
    end

    Status.Text = "Verifying with Server..."
    local success, result = pcall(function() return game:HttpGet(DATABASE_URL) end)

    if success then
        local data = HttpService:JSONDecode(result)
        local keyData = data.KEY_LIST[input]

        if keyData then
            local yr, mo, dy = keyData.Exp:match("(%d+)-(%d+)-(%d+)")
            local expTime = os.time({year=tonumber(yr), month=tonumber(mo), day=tonumber(dy)})
            if os.time() < expTime then
                Status.Text = "WORK! Akses Terbuka."
                Status.TextColor3 = Color3.new(0, 1, 0)
                task.wait(1)
                KeyPanel:Destroy()
                Main.Visible = true
                -- PENTING: Jalankan semua fitur setelah login berhasil
                InitializeFeatures()
            else
                Status.Text = "KEY SUDAH EXPIRED!"
                Status.TextColor3 = Color3.new(1, 0.5, 0)
            end
        else
            Status.Text = "KEY TIDAK VALID!"
            Status.TextColor3 = Color3.new(1, 0, 0)
        end
    else
        Status.Text = "SERVER ERROR (Check URL)"
        warn("HTTP Error:", result)
    end
end)
