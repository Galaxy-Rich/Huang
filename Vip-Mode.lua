local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local startTime = os.time()
local startRebirths = player.leaderstats.Rebirths.Value
local displayName = player.DisplayName

WindUI:AddTheme({
    Name = "Light",
    Accent = "#f4f4f5",
    Dialog = "#f4f4f5",
    Outline = "#000000", 
    Text = "#000000",
    Placeholder = "#666666",
    Background = "#f0f0f0",
    Button = "#000000",
    Icon = "#000000",
})

WindUI:SetNotificationLower(true)

local themes = {"Light"}
local currentThemeIndex = 1

if not getgenv().TransparencyEnabled then
    getgenv().TransparencyEnabled = true
end

local Window = WindUI:CreateWindow({
    Title = "Team | Vuzo Zilux",
    Icon = "rbxassetid://76676105086715", 
    Author = "By ZorVex",
    Folder = "Vz Hub",
    Size = UDim2.fromOffset(500, 350),
    Transparent = getgenv().TransparencyEnabled,
    Theme = "Light",
    Resizable = true,
    SideBarWidth = 150,
    BackgroundImageTransparency = 0.8,
    HideSearchBar = true,
    ScrollBarEnabled = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            currentThemeIndex = currentThemeIndex + 1
            if currentThemeIndex > #themes then
                currentThemeIndex = 1
            end
            
            local newTheme = themes[currentThemeIndex]
            WindUI:SetTheme(newTheme)
           
            WindUI:Notify({
                Title = "ZorVex | Leader Of Vuzo Zilux",
                Duration = 8
            })
        end,
    },
})

Window:SetIconSize(55)

Window:EditOpenButton({
    Enabled = false
})

-- Bagian UI Button yang sudah dimodifikasi untuk Posisi Tengah (HP/DPI Friendly)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UIBUTTON"
ScreenGui.Parent = game.CoreGui
ScreenGui.IgnoreGuiInset = true -- Mengabaikan bar atas agar benar-benar di tengah

local ImgBtn = Instance.new("ImageButton")
ImgBtn.Parent = ScreenGui
ImgBtn.Size = UDim2.new(0, 70, 0, 70)
ImgBtn.AnchorPoint = Vector2.new(1, 0) -- Menentukan titik pusat di tengah tombol
ImgBtn.Position = UDim2.new(0.9, -20, 0, 50) -- Koordinat 0.5 berarti 50% layar (Tengah)
ImgBtn.BackgroundTransparency = 1
ImgBtn.Image = "rbxassetid://88635292278521" 
ImgBtn.ZIndex = 9999

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = ImgBtn
local isOpen = true

ImgBtn.MouseButton1Click:Connect(function()
    local shrink = TweenService:Create(ImgBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 60, 0, 60)
    })
    local grow = TweenService:Create(ImgBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 70, 0, 70)
    })
    shrink:Play()
    shrink.Completed:Wait()
    grow:Play()
    
    Window:Toggle()
    isOpen = not isOpen
end)

-- Sistem Dragging (Tetap berfungsi jika ingin dipindah manual)
local dragging = false
local dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    ImgBtn.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end
ImgBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ImgBtn.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
ImgBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement 
    or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Variabel global yang sering digunakan
local a = game:GetService("ReplicatedStorage")
local b = game:GetService("Players")
local c = b.LocalPlayer

do
    Window:Tag({
        Title = "--> Glitch Pet <--",
        Color = Color3.fromHex("#000000")
    })
end

local Part1 = Window:Tab({
Title = "━═━═━═━═━"})

local Part2 = Window:Tab({
Title = "━═━═━═━═━"})

-- Farming Tab
local FarmTab = Window:Tab({
Title = "━═>Rebirth<═━"})

-- Gym farm Section
local glitch_h = FarmTab:Section({
Title = "Fast Rebirth",
Icon = "skull"})

FarmTab:Toggle({
    Title = "Auto Farm Rebirth",
    Callback = function(state)
        getgenv().IsAutoFarming = state

        if state then
            
            local d = function() -- Unequip All Pets
                local f = c.petsFolder
                for g, h in pairs(f:GetChildren()) do
                    if h:IsA("Folder") then
                        for i, j in pairs(h:GetChildren()) do
                            a.rEvents.equipPetEvent:FireServer("unequipPet", j)
                        end
                    end
                end
                task.wait(.1)
            end

            local k = function(l) -- Equip Specific Pet
                d()
                task.wait(.01)
                for m, n in pairs(c.petsFolder.Unique:GetChildren()) do
                    if n.Name == l then
                        a.rEvents.equipPetEvent:FireServer("equipPet", n)
                    end
                end
            end

            -- Variabel global untuk memungkinkan penghentian thread
            autoFarmThread = task.spawn(function()
                while getgenv().IsAutoFarming do
                    local v = c.leaderstats.Rebirths.Value
                    local w = 10000 + (5000 * v)
                    if c.ultimatesFolder:FindFirstChild("Golden Rebirth") then
                        local x = c.ultimatesFolder["Golden Rebirth"].Value
                        w = math.floor(w * (1 - (x * 0.1)))
                    end
                    
                    -- 1. Farm Strength
                    d()
                    task.wait(.1)
                    k("Swift Samurai")
                    while c.leaderstats.Strength.Value < w and getgenv().IsAutoFarming do
                        for y = 1, 15 do
                            c.muscleEvent:FireServer("rep")
                        end
                        task.wait()
                    end
                    
                    -- Hentikan jika toggle dimatikan saat farm strength
                    if not getgenv().IsAutoFarming then break end

                    -- 2. Rebirth
                    d()
                    task.wait(.1)
                    k("Tribal Overlord")
                    local A = c.leaderstats.Rebirths.Value
                    repeat
                        a.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                        task.wait(.1)
                        if not getgenv().IsAutoFarming then break end -- Hentikan jika toggle dimatikan saat rebirth
                    until c.leaderstats.Rebirths.Value > A

                    task.wait() -- Jeda antar siklus
                end
            end)
        else
            -- Jika toggle dimatikan, pastikan thread dihentikan
            if autoFarmThread and task.cancel then
                task.cancel(autoFarmThread)
                autoFarmThread = nil
            end
        end
    end
})

FarmTab:Toggle({
    Title = "Delete Frames",
    Callback = function(state)
        if state then
            -- Langsung mencari dan menghapus objek secara permanen
            for _, obj in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                if obj.Name:match("Frame$") then
                    obj:Destroy()
                end
            end
        end
    end
})

local Strength = FarmTab:Section({
Title = "Fast Strength",
Icon = "skull"})

FarmTab:Toggle({
    Title = "Push Strength",
    Callback = function(l)
        getgenv().PushStrengthEnabled = l
        
        if l then
            local k = function(l)
                -- Fungsi untuk meng-equip pet (tidak unequip pet lain)
                for m, n in pairs(c.petsFolder.Unique:GetChildren()) do
                    if n.Name == l then
                        a.rEvents.equipPetEvent:FireServer("equipPet", n)
                    end
                end
            end
            
            task.spawn(function()
                while getgenv().PushStrengthEnabled do
                    k("Swift Samurai")
                    for y = 1, 10 do
                        c.muscleEvent:FireServer("rep")
                    end
                    task.wait()  -- Menambahkan wait untuk menghindari lag berlebih
                end
            end)
        end
    end
})

FarmTab:Toggle({
    Title = "Delete Frames",
    Callback = function(state)
        if state then
            -- Langsung mencari dan menghapus objek secara permanen
            for _, obj in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                if obj.Name:match("Frame$") then
                    obj:Destroy()
                end
            end
        end
    end
})

local Misc = FarmTab:Section({
Title = "Utilities", -- Mengganti nama section agar lebih relevan
Icon = "wrench"})

-- **START MODIFIKASI: Perbaikan Auto Eat Egg**
local function activateProteinEgg()
    local character = player.Character
    if not character then return end -- Cek karakter
    
    -- Cari alat (tool) di Character atau Backpack
    local tool = character:FindFirstChild("Protein Egg") or player.Backpack:FindFirstChild("Protein Egg")
    
    -- Menggunakan c.muscleEvent (RemoteEvent milik LocalPlayer)
    if tool and c.muscleEvent then
        c.muscleEvent:FireServer("proteinEgg", tool)
    end
end

local running = false

task.spawn(function()
    while true do
        if running then
            activateProteinEgg()
            task.wait(1800) -- 1800 detik = 30 menit
        else
            task.wait(1)
        end
    end
end)

FarmTab:Toggle({
    Title = "Auto Eat Egg | 30mins",
    Desc = " Get 2x Strength | 30 Minute",
    Callback = function(state)
        running = state
        if state then
            -- Panggil sekali saat dihidupkan
            activateProteinEgg()
        end
    end
})
-- **END MODIFIKASI: Perbaikan Auto Eat Egg**

FarmTab:Button({
    Title = "Teleport To Jungle",
    Callback = function()
        local o = function(p)
            local q = workspace.machinesFolder:FindFirstChild(p)
            if not q then
                for r, s in pairs(workspace:GetChildren()) do
                    if s:IsA("Folder") and s.Name:find("machines") then
                        q = s:FindFirstChild(p)
                        if q then break end
                    end
                end
            end
            return q
        end

        local t = function()
            local u = game:GetService("VirtualInputManager")
            u:SendKeyEvent(true, "E", false, game)
            task.wait(.1)
            u:SendKeyEvent(false, "E", false, game)
        end
        
        local z = o("Jungle Bar Lift")
        if z and z:FindFirstChild("interactSeat") and c.Character and c.Character:FindFirstChild("HumanoidRootPart") then
            for i = 1, 3 do
                c.Character.HumanoidRootPart.CFrame = z.interactSeat.CFrame * CFrame.new(0, 3, 0)
                task.wait(.01)
                t()
                task.wait(.1)
            end
        end
    end
})

FarmTab:Toggle({
    Title = "Anti-AFK",
    Callback = function(state)
        if state then
            local VirtualUser = game:GetService("VirtualUser")

            _G.afkGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
            _G.afkGui.Name = "AntiAFKGui"
            _G.afkGui.ResetOnSpawn = false

            local timer = Instance.new("TextLabel", _G.afkGui)
            timer.Size = UDim2.new(0, 200, 0, 30)
            timer.Position = UDim2.new(1, -210, 0, 20) -- Diubah sedikit agar tidak terlalu mepet ke atas
            timer.Text = "0:00:00"
            timer.TextColor3 = Color3.fromRGB(255, 255, 255)
            timer.Font = Enum.Font.GothamBold
            timer.TextSize = 25
            timer.BackgroundTransparency = 1
            timer.TextTransparency = 0
            
            -- Outline untuk timer
            local timerStroke = Instance.new("UIStroke", timer)
            timerStroke.Thickness = 1
            timerStroke.Color = Color3.fromRGB(39, 39, 39)

            local startTime = tick()

            task.spawn(function()
                while _G.afkGui and _G.afkGui.Parent do
                    local elapsed = tick() - startTime
                    local h = math.floor(elapsed / 3600)
                    local m = math.floor((elapsed % 3600) / 60)
                    local s = math.floor(elapsed % 60)
                    timer.Text = string.format("%02d:%02d:%02d", h, m, s)
                    task.wait(1)
                end
            end)
            
            _G.afkConnection = player.Idled:Connect(function()
                VirtualUser:Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame)
            end)
        else
            if _G.afkConnection then
                _G.afkConnection:Disconnect()
                _G.afkConnection = nil
            end
            if _G.afkGui then
                _G.afkGui:Destroy()
                _G.afkGui = nil
            end
        end
    end
})

FarmTab:Toggle({
    Title = "Auto Size 2",
    Callback = function(bool)
        _G.autoSizeActive = bool
        if bool then
            task.spawn(function()
                while _G.autoSizeActive and task.wait() do
                    ReplicatedStorage.rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 2)
                end
            end)
        end
    end
})

FarmTab:Toggle({
    Title = "Lock Position",
    Callback = function(state)
        _G.lockRunning = state
        
        local function getCharacterData()
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            return char, hrp
        end

        if state then
            local char, hrp = getCharacterData()
            if not hrp then return end

            -- Simpan posisi saat ini
            _G.LockedCFrame = hrp.CFrame
            
            -- Memulai Loop Teleportasi Berulang
            task.spawn(function()
                while _G.lockRunning do
                    local char, hrp = getCharacterData()
                    if hrp and _G.LockedCFrame then
                        -- Teleportasi paksa ke titik yang dikunci
                        hrp.CFrame = _G.LockedCFrame
                        
                        -- Mengnolkan Velocity agar tidak terpental (Anti-Physics)
                        hrp.Velocity = Vector3.new(0, 0, 0)
                        hrp.RotVelocity = Vector3.new(0, 0, 0)
                    end
                    -- Wait kecil (Heartbeat lebih baik untuk stabilitas tinggi)
                    task.wait() 
                end
            end)
        else
            -- Reset data saat toggle dimatikan
            _G.LockedCFrame = nil
        end
    end
})

local TeleportTab = Window:Tab({Title = "━═Teleport═━"})

local Teleport2 = TeleportTab:Section({
Title = "Teleportation Island",
Icon = "map-pin"})

local function safeTeleport(cframe)
    local character = player.Character or player.CharacterAdded:Wait()
    local root = character:WaitForChild("HumanoidRootPart", 10)
    if root then
        root.CFrame = cframe
    end
end

local teleportLocations = {
    {"Spawn", CFrame.new(2, 8, 115)},
    {"Secret Area", CFrame.new(1947, 2, 6191)},
    {"Tiny Island", CFrame.new(-34, 7, 1903)},
    {"Teleport Frozen", CFrame.new(-2600.00244, 3.67686558, -403.884369, 0.0873617008, 1.0482899e-09, 0.99617666, 3.07204253e-08, 1, -3.7464023e-09, -0.99617666, 3.09302628e-08, 0.0873617008)},
    {"Mythical", CFrame.new(2255, 7, 1071)},
    {"Inferno", CFrame.new(-6768, 7, -1287)},
    {"Legend", CFrame.new(4604, 991, -3887)},
    {"Muscle King Gym", CFrame.new(-8646, 17, -5738)},
    {"Jungle", CFrame.new(-8659, 6, 2384)},
    {"Brawl Lava", CFrame.new(4471, 119, -8836)},
    {"Brawl Desert", CFrame.new(960, 17, -7398)},
    {"Brawl Regular", CFrame.new(-1849, 20, -6335)}
}

for _, location in ipairs(teleportLocations) do
    TeleportTab:Button({
        Title = location[1],
        Callback = function()
            safeTeleport(location[2])
        end
    })
end

player.CharacterAdded:Connect(function()
    task.wait(1)
end)

local Part3 = Window:Tab({
Title = "━═━═━═━═━"})

local Part4 = Window:Tab({
Title = "━═━═━═━═━"})
