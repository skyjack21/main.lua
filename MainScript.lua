--[[
    SKYJACK RBX v2402: ELITE-TOTAL - FINAL REVISION
    
    Perbaikan oleh AI Research (berdasarkan error 'attempt to call a nil value'):
    - Memperbaiki metode pemanggilan fungsi internal untuk mencegah error 'nil value'.
    - Menambahkan pemeriksaan keamanan untuk 'getrawmetatable' agar tidak error jika tidak didukung.
    - UI ditempatkan di CoreGui untuk stabilitas maksimum.
    - Seluruh skrip dibungkus pcall untuk menangkap error tersembunyi.
    - Fitur Speed menggunakan WalkSpeed untuk gerakan mulus.
    - Fitur Hide Name dioptimalkan dengan event-based.
    - Fitur Noclip ditingkatkan dengan PlatformStand.
    - Hook __namecall dibungkus newcclosure.
]]

local success, errorMessage = pcall(function()

    -- Layanan-layanan utama
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")

    -- Variabel pemain lokal
    local lp = Players.LocalPlayer

    -- Tabel utama untuk mengelola semua logika skrip
    local Skyjack = {}
    Skyjack.Config = {
        Speed = false,
        WallPass = false,
        InfJump = false,
        Vip = false,
        HideName = false,
        Shield = false,
        AutoWalk = false
    }
    Skyjack.UI = {}
    Skyjack.Keys = {"Speed", "WallPass", "InfJump", "Vip", "HideName", "Shield", "AutoWalk"}
    Skyjack.Names = {"ELITE SPEED (1.95x)", "GHOST NOCLIP", "PHYSICAL INF JUMP", "SYSTEM VIP BYPASS", "IDENTITY CLEANER", "ANTI-KICK SHIELD", "STEALTH AUTO SUMMIT"}
    Skyjack.Buttons = {}
    Skyjack.Index = 1

    local T = Skyjack.Config -- Alias untuk akses lebih cepat

    -- [[ 1. MASTER BYPASS (METATABLE HOOK YANG DISEMPURNAKAN) ]] --
    function Skyjack.SetupBypasses()
        -- Pemeriksaan keamanan: hanya jalankan jika getrawmetatable ada
        if not getrawmetatable then 
            warn("SKYJACK: getrawmetatable tidak ditemukan. Fitur bypass tidak akan aktif.")
            return 
        end

        local mt = getrawmetatable(game)
        if not mt or not mt.__namecall then return end
        
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)

        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            
            if T.Shield and (method == "Kick" or method == "kick") and self == lp then
                return 
            end

            if T.Vip then
                if method == "UserOwnsGamePassAsync" or method == "PlayerOwnsAsset" or method == "CheckGamepass" then
                    return true
                end
            end

            return oldNamecall(self, ...)
        end)
        
        setreadonly(mt, true)
    end

    -- [[ 2. LOGIKA FITUR UTAMA ]] --
    function Skyjack.InitializeFeatures()
        RunService.Heartbeat:Connect(function()
            if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
            
            local char = lp.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            local root = char.HumanoidRootPart

            if T.Speed then
                hum.WalkSpeed = 16 * 1.95
            else
                hum.WalkSpeed = 16
            end

            if T.AutoWalk then
                local target = workspace:FindFirstChild("Checkpoint") or workspace:FindFirstChild("Summit") or workspace:FindFirstChild("End")
                if target and (target.Position - root.Position).Magnitude > 5 then
                    hum:MoveTo(target.Position)
                end
            end

            hum.PlatformStand = T.WallPass
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = not T.WallPass
                end
            end
        end)

        UserInputService.JumpRequest:Connect(function()
            if T.InfJump and lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
                lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)

        local function handleCharacter(character)
            if not character or not character:FindFirstChild("Humanoid") then return end
            
            if T.HideName then
                task.wait(0.5)
                pcall(function()
                    character:FindFirstChildOfClass("Humanoid").DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                    if character:FindFirstChild("Head") then
                        for _, v in pairs(character.Head:GetChildren()) do
                            if v:IsA("BillboardGui") then
                                v:Destroy()
                            end
                        end
                    end
                end)
            else
                 pcall(function()
                    character:FindFirstChildOfClass("Humanoid").DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
                end)
            end
        end

        if lp.Character then handleCharacter(lp.Character) end
        lp.CharacterAdded:Connect(handleCharacter)
        
        -- Tambahkan listener untuk toggle HideName agar langsung diterapkan
        local function onToggleHideName()
            if lp.Character then
                handleCharacter(lp.Character)
            end
        end
        -- Ini adalah bagian penting yang mungkin hilang: menghubungkan toggle ke fungsi
        -- Kita akan memanggil ini saat tombol ditekan
        Skyjack.OnToggleHideName = onToggleHideName
    end

    -- [[ 3. PEMBUAT UI (ABSOLUTE UI BUILDER) ]] --
    function Skyjack.BuildUI()
        if CoreGui:FindFirstChild("SKY_ELITE") then
            CoreGui.SKY_ELITE:Destroy()
        end

        local Screen = Instance.new("ScreenGui", CoreGui)
        Screen.Name = "SKY_ELITE"
        Screen.ResetOnSpawn = false
        Screen.ZIndexBehavior = Enum.ZIndexBehavior.Global

        local Main = Instance.new("Frame", Screen)
        Main.Size = UDim2.new(0, 185, 0, 400)
        Main.Position = UDim2.new(0.02, 0, 0.25, 0)
        Main.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
        Main.Active = true
        Main.Draggable = true
        Main.ZIndex = 1000

        Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
        
        local Stroke = Instance.new("UIStroke", Main)
        Stroke.Color = Color3.fromRGB(0, 220, 255)
        Stroke.Thickness = 2

        local Header = Instance.new("TextLabel", Main)
        Header.Size = UDim2.new(1, 0, 0, 35)
        Header.Text = "SKYJACK ELITE v2402"
        Header.TextColor3 = Color3.new(1, 1, 1)
        Header.Font = Enum.Font.GothamBold
        Header.TextSize = 10
        Header.BackgroundTransparency = 1

        for i, name in ipairs(Skyjack.Names) do
            local b = Instance.new("TextButton", Main)
            b.Size = UDim2.new(1, -16, 0, 44)
            b.Position = UDim2.new(0, 8, 0, (i * 50) - 10)
            b.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
            b.TextColor3 = Color3.new(1, 1, 1)
            b.Text = name .. " [OFF]"
            b.Font = Enum.Font.GothamBold
            b.TextSize = 8
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
            table.insert(Skyjack.Buttons, b)
        end

        local function Refresh()
            for i, b in ipairs(Skyjack.Buttons) do
                local key = Skyjack.Keys[i]
                b.Text = Skyjack.Names[i] .. (T[key] and " [ON]" or " [OFF]")
                b.BackgroundColor3 = (i == Skyjack.Index) and Color3.fromRGB(0, 220, 255) or Color3.fromRGB(22, 22, 26)
                b.TextColor3 = (i == Skyjack.Index) and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
            end
        end
        Skyjack.UI.Refresh = Refresh

        UserInputService.InputBegan:Connect(function(k, g)
            if k.KeyCode == Enum.KeyCode.L then Main.Visible = not Main.Visible end
            if g or not Main.Visible then return end

            if k.KeyCode == Enum.KeyCode.Up then
                Skyjack.Index = (Skyjack.Index > 1) and Skyjack.Index - 1 or #Skyjack.Names
                Refresh()
            elseif k.KeyCode == Enum.KeyCode.Down then
                Skyjack.Index = (Skyjack.Index < #Skyjack.Names) and Skyjack.Index + 1 or 1
                Refresh()
            elseif k.KeyCode == Enum.KeyCode.Return then
                local key = Skyjack.Keys[Skyjack.Index]
                T[key] = not T[key]
                Refresh()
                
                -- Jika fitur yang di-toggle adalah HideName, panggil fungsinya
                if key == "HideName" and Skyjack.OnToggleHideName then
                    Skyjack.OnToggleHideName()
                end
            end
        end)

        Refresh()
    end

    -- [[ 4. INISIALISASI SKRIP ]] --
    Skyjack.SetupBypasses()
    Skyjack.InitializeFeatures()
    Skyjack.BuildUI()

    print("SKYJACK RBX v2402: Berhasil dimuat dan diperbaiki.")
end)

if not success then
    warn("SKYJACK RBX: Gagal memuat skrip. Error:", errorMessage)
end
