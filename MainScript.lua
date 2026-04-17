--[[
    OMNI v142: MOUNT INDEPENDENCE - KEY VERIFICATION FIX
    
    Perbaikan oleh AI Research:
    - [CRITICAL FIX] Proses verifikasi kunci kini sepenuhnya dibungkus pcall untuk mencegah 'stuck'.
    - [ADDED] Pesan status UI kini lebih detail jika terjadi error (mis. format JSON salah).
    - [ADDED] Validasi tambahan untuk memastikan format tanggal di Gist benar.
    - Semua perbaikan dari v141 tetap dipertahankan.
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
local Index, SpeedMult = 1, 1.8

-- [[ 1. UI BUILDER (LOGIN & CHEAT PANELS) ]] --
local function BuildUI()
    if pgui:FindFirstChild("OMNI_SECURE_V142") then pgui.OMNI_SECURE_V142:Destroy() end
    local Screen = Instance.new("ScreenGui", pgui)
    Screen.Name = "OMNI_SECURE_V142"
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
    Main.Size = UDim2.new(0, 240, 0, 440)
    Main.Position = UDim2.new(0.1, 0, 0.2, 0)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Main.Visible, Main.Active, Main.Draggable = false, true, true
    Instance.new("UICorner", Main)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(200, 0, 0)

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    Title.Text = "MOUNT INDEPENDENCE v142"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Instance.new("UICorner", Title)

    return Screen, KeyPanel, Main, CheckBtn, KeyInput, Status
end

local Screen, KeyPanel, Main, CheckBtn, KeyInput, Status = BuildUI()

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

-- [[ 3. CLOUD KEY VALIDATION (REVISED) ]] --
CheckBtn.MouseButton1Click:Connect(function()
    local input = KeyInput.Text
    if #input ~= 8 then
        Status.Text = "KEY HARUS 8 KARAKTER!"
        Status.TextColor3 = Color3.new(1, 0, 0)
        return
    end

    Status.Text = "Verifying with Server..."
    Status.TextColor3 = Color3.new(0.8, 0.8, 0.8)

    -- [CRITICAL FIX] pcall kini membungkus seluruh proses
    local success, result = pcall(function()
        local rawData = game:HttpGet(DATABASE_URL)
        local data = HttpService:JSONDecode(rawData)
        
        if not data or not data.KEY_LIST then
            error("FORMAT JSON SALAH / KEY_LIST TIDAK ADA")
        end

        local keyData = data.KEY_LIST[input]
        if not keyData then
            error("KEY TIDAK DITEMUKAN DI DATABASE")
        end

        local yr, mo, dy = keyData.Exp:match("(%d+)-(%d+)-(%d+)")
        if not (yr and mo and dy) then
            error("FORMAT TANGGAL SALAH (Harus: YYYY-MM-DD)")
        end

        local expTime = os.time({year=tonumber(yr), month=tonumber(mo), day=tonumber(dy)})
        if os.time() >= expTime then
            error("KEY SUDAH EXPIRED")
        end

        -- Jika semua pemeriksaan lolos, kembalikan true
        return true
    end)

    if success and result == true then
        Status.Text = "WORK! Akses Terbuka."
        Status.TextColor3 = Color3.new(0, 1, 0)
        task.wait(1)
        KeyPanel:Destroy()
        Main.Visible = true
        InitializeFeatures()
    else
        -- Jika gagal, 'result' akan berisi pesan error dari atas
        Status.Text = tostring(result)
        Status.TextColor3 = Color3.new(1, 0.2, 0.2)
        warn("Key Verification Error:", result)
    end
end)
