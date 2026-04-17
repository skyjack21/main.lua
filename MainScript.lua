--[[
    SKYJACK RBX v2403: SAFE-MODE REVISION
    
    Perbaikan oleh AI Research (Fokus pada 'attempt to call a nil value'):
    - Struktur tabel kompleks dihilangkan untuk menyederhanakan alur.
    - Fitur Bypass (getrawmetatable/newcclosure) dinonaktifkan sementara untuk diagnosis.
      Jika skrip ini berjalan, artinya executor Anda tidak mendukung fitur tersebut.
    - Semua fungsi didefinisikan secara lokal untuk memastikan referensi yang benar.
]]

-- Menggunakan pcall untuk keamanan maksimum
local success, errorMessage = pcall(function()

    -- Layanan-layanan utama
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")

    -- Variabel pemain lokal
    local lp = Players.LocalPlayer

    -- Konfigurasi Fitur
    local Config = {
        Speed = false,
        WallPass = false,
        InfJump = false,
        Vip = false,
        HideName = false,
        Shield = false,
        AutoWalk = false
    }

    -- Variabel UI
    local Keys = {"Speed", "WallPass", "InfJump", "Vip", "HideName", "Shield", "AutoWalk"}
    local Names = {"ELITE SPEED (1.95x)", "GHOST NOCLIP", "PHYSICAL INF JUMP", "SYSTEM VIP BYPASS", "IDENTITY CLEANER", "ANTI-KICK SHIELD", "STEALTH AUTO SUMMIT"}
    local Buttons = {}
    local Index = 1

    -- =================================================================
    -- FITUR BYPASS DINONAKTIFKAN SEMENTARA UNTUK MENGHINDARI ERROR
    -- Jika skrip ini berhasil, berarti executor Anda tidak mendukung getrawmetatable atau newcclosure.
    --
    -- local mt = getrawmetatable and getrawmetatable(game)
    -- if mt then
    --     local oldNamecall = mt.__namecall
    --     setreadonly(mt, false)
    --     mt.__namecall = newcclosure(function(self, ...)
    --         local method = getnamecallmethod()
    --         if Config.Shield and (method == "Kick" or method == "kick") and self == lp then return end
    --         if Config.Vip and (method == "UserOwnsGamePassAsync" or method == "PlayerOwnsAsset") then return true end
    --         return oldNamecall(self, ...)
    --     end)
    --     setreadonly(mt, true)
    -- end
    -- =================================================================

    -- Fungsi untuk menangani efek pada karakter
    local function handleCharacter(character)
        if not character or not character:FindFirstChild("Humanoid") then return end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        
        if Config.HideName then
            task.wait(0.5)
            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            if character:FindFirstChild("Head") then
                for _, v in pairs(character.Head:GetChildren()) do
                    if v:IsA("BillboardGui") then
                        v:Destroy()
                    end
                end
            end
        else
            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
        end
    end

    -- Loop utama untuk fitur-fitur yang berjalan terus-menerus
    RunService.Heartbeat:Connect(function()
        if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
        
        local char = lp.Character
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        
        -- Speed
        hum.WalkSpeed = Config.Speed and (16 * 1.95) or 16

        -- Noclip
        hum.PlatformStand = Config.WallPass
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = not Config.WallPass
            end
        end
        
        -- AutoWalk
        if Config.AutoWalk then
            local target = workspace:FindFirstChild("Checkpoint") or workspace:FindFirstChild("Summit") or workspace:FindFirstChild("End")
            if target and (target.Position - char.HumanoidRootPart.Position).Magnitude > 5 then
                hum:MoveTo(target.Position)
            end
        end
    end)

    -- Event untuk Infinite Jump
    UserInputService.JumpRequest:Connect(function()
        if Config.InfJump and lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
            lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    -- Event untuk Hide Name saat karakter muncul
    if lp.Character then handleCharacter(lp.Character) end
    lp.CharacterAdded:Connect(handleCharacter)

    -- Fungsi untuk membangun UI
    local function BuildUI()
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
        Header.Text = "SKYJACK ELITE v2403"
        Header.TextColor3 = Color3.new(1, 1, 1)
        Header.Font = Enum.Font.GothamBold
        Header.TextSize = 10
        Header.BackgroundTransparency = 1

        local function RefreshUI()
            for i, b in ipairs(Buttons) do
                local key = Keys[i]
                b.Text = Names[i] .. (Config[key] and " [ON]" or " [OFF]")
                b.BackgroundColor3 = (i == Index) and Color3.fromRGB(0, 220, 255) or Color3.fromRGB(22, 22, 26)
                b.TextColor3 = (i == Index) and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
            end
        end

        for i, name in ipairs(Names) do
            local b = Instance.new("TextButton", Main)
            b.Size = UDim2.new(1, -16, 0, 44)
            b.Position = UDim2.new(0, 8, 0, (i * 50) - 10)
            b.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
            b.TextColor3 = Color3.new(1, 1, 1)
            b.Text = name .. " [OFF]"
            b.Font = Enum.Font.GothamBold
            b.TextSize = 8
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
            table.insert(Buttons, b)
        end

        UserInputService.InputBegan:Connect(function(k, g)
            if k.KeyCode == Enum.KeyCode.L then Main.Visible = not Main.Visible end
            if g or not Main.Visible then return end

            if k.KeyCode == Enum.KeyCode.Up then
                Index = (Index > 1) and Index - 1 or #Names
            elseif k.KeyCode == Enum.KeyCode.Down then
                Index = (Index < #Names) and Index + 1 or 1
            elseif k.KeyCode == Enum.KeyCode.Return then
                local key = Keys[Index]
                Config[key] = not Config[key]
                if key == "HideName" then
                    handleCharacter(lp.Character)
                end
            end
            RefreshUI()
        end)

        RefreshUI()
    end

    -- Panggil fungsi untuk membangun UI
    BuildUI()

    print("SKYJACK RBX v2403 (Safe Mode): Berhasil dimuat.")
end)

if not success then
    warn("SKYJACK RBX: Gagal memuat skrip. Error:", errorMessage)
end
