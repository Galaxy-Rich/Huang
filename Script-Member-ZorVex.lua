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

--Window:SetUIScale(.8)

-- */  Tags  /* --
do
    Window:Tag({
        Title = "--> MEMBER <--",
        Color = Color3.fromHex("#000000")
    })
end

local a = game:GetService("ReplicatedStorage")
local b = game:GetService("Players")
local c = b.LocalPlayer

-- Farming Tab
local farmPlusTab = Window:Tab({Title = "Farming", Icon = "cpu"})

local VipUser = farmPlusTab:Section({
Title = "Vip Mode",
Icon = "circle-dollar-sign"})

farmPlusTab:Toggle({
    Title = "Push Strength",
    Locked = true,
        LockedTitle = "VIP Only",
    })

farmPlusTab:Toggle({
    Title = "Hide Frame",
    Locked = true,
        LockedTitle = "VIP Only",
    })

local unlockGp = farmPlusTab:Section({
Title = "Farm Tools",
Icon = "circle-dollar-sign"})

farmPlusTab:Button({
    Title = "Unlock Gamepass AutoLift",
    Desc = "Unlock Free No Robux",
    Locked = true,
        LockedTitle = "VIP Only",
    })

-- Gym farm Section
local Farmingg = farmPlusTab:Section({
Title = "Farm Tools",
Icon = "swords"})

local muscleEvent = player:WaitForChild("muscleEvent")

local function equipTool(toolName)
    local backpack = player:FindFirstChild("Backpack")
    local char = player.Character
    if backpack and char and char:FindFirstChild("Humanoid") then
        local tool = backpack:FindFirstChild(toolName)
        if tool then
            char.Humanoid:EquipTool(tool)
        end
    end
end

local function unequipTool(toolName)
    local char = player.Character
    if char then
        local equipped = char:FindFirstChild(toolName)
        if equipped then
            equipped.Parent = player.Backpack
        end
    end
end

local function startAutoRep(flagName, toolName)
    task.spawn(function()
        while _G[flagName] do
            local char = player.Character
            if not char or not char:FindFirstChild("Humanoid") then
                task.wait(0.2)
                continue
            end
            if not char:FindFirstChild(toolName) then
                equipTool(toolName)
            end
            muscleEvent:FireServer("rep")
            task.wait(0.1)
        end
    end)
end

player.CharacterAdded:Connect(function()
    task.wait(1.5)
    for _, info in ipairs({
        {flag = "AutoWeight", tool = "Weight"},
        {flag = "AutoPushups", tool = "Pushups"},
        {flag = "AutoHandstands", tool = "Handstands"},
        {flag = "AutoSitups", tool = "Situps"},
    }) do
        if _G[info.flag] then
            equipTool(info.tool)
            startAutoRep(info.flag, info.tool)
        end
    end
end)

-- Auto tool toggles
local toolConfigs = {
    {"Auto Weight", "AutoWeight", "Weight", "Do lifting automatically"},
    {"Auto Pushups", "AutoPushups", "Pushups", "Do push-ups automatically"},
    {"Auto Handstands", "AutoHandstands", "Handstands", "Do hand-stands automatically"},
    {"Auto Situps", "AutoSitups", "Situps", "Do sit-ups automatically"}
}

for _, tool in ipairs(toolConfigs) do
    farmPlusTab:Toggle({
        Title = tool[1],
        Callback = function(Value)
            _G[tool[2]] = Value
            if Value then
                equipTool(tool[3])
                startAutoRep(tool[2], tool[3])
            else
                unequipTool(tool[3])
            end
        end
    })
end

-- Gym farm Section
local FarmingCombo = farmPlusTab:Section({
Title = "Combo Jungle",
Icon = "diamond-plus"})

local doPushups = false
local doSitups = false
local doHandstands = false
local durabilityNeeded = 10000000

local function punchRock()
    local char = player.Character
    local bp = player.Backpack
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")

    if char and bp and humanoid then
        local punch = bp:FindFirstChild("Punch")
        if punch and not char:FindFirstChild("Punch") then
            humanoid:EquipTool(punch)
        end

        local inst = char:FindFirstChild("Punch")
        if inst and inst:FindFirstChild("attackTime") then
            inst.attackTime.Value = 0.001
            muscleEvent:FireServer("punch", "rightHand")
            muscleEvent:FireServer("punch", "leftHand")
            inst:Activate()
        end
    end
end

local function tryRockTouch()
    local char = player.Character
    if player.Durability.Value >= durabilityNeeded then
        for _, v in pairs(workspace.machinesFolder:GetDescendants()) do
            if v.Name == "neededDurability" and v.Value == durabilityNeeded then
                local rock = v.Parent:FindFirstChild("Rock")
                if rock and char and char:FindFirstChild("RightHand") and char:FindFirstChild("LeftHand") then
                    firetouchinterest(rock, char.RightHand, 0)
                    firetouchinterest(rock, char.RightHand, 1)
                    firetouchinterest(rock, char.LeftHand, 0)
                    firetouchinterest(rock, char.LeftHand, 1)
                    punchRock()
                end
            end
        end
    end
end

local function doRep(toolName)
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local bp = player.Backpack

    if not char:FindFirstChild(toolName) then
        local tool = bp:FindFirstChild(toolName)
        if tool and humanoid then
            humanoid:EquipTool(tool)
        end
    end

    muscleEvent:FireServer("rep")
end

task.spawn(function()
    while true do
        if doPushups then
            doRep("Pushups")
            tryRockTouch()
        end
        if doSitups then
            doRep("Situps")
            tryRockTouch()
        end
        if doHandstands then
            doRep("Handstands")
            tryRockTouch()
        end
        task.wait(0.1)
    end
end)

player.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart")
    task.wait(2)
    warn("[RESPAWN] Player respawned â€” OP FARM auto-resumed.")
end)

farmPlusTab:Toggle({
    Title = "Pushups + Jungle Rock",
    Callback = function(state)
        doPushups = state
    end
})

farmPlusTab:Toggle({
    Title = "Situps + Jungle Rock",
    Callback = function(state)
        doSitups = state
    end
})

farmPlusTab:Toggle({
    Title = "Handstands + Jungle Rock",
    Callback = function(state)
        doHandstands = state
    end
})

-- Gym farm Section
local FarmingCombo2 = farmPlusTab:Section({
Title = "Combo Muscle King",
Icon = "diamond-plus"})

local doPushups = false
local doSitups = false
local doHandstands = false
local durabilityNeeded = 5000000

local function punchRock()
    local char = player.Character
    local bp = player.Backpack
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")

    if char and bp and humanoid then
        local punch = bp:FindFirstChild("Punch")
        if punch and not char:FindFirstChild("Punch") then
            humanoid:EquipTool(punch)
        end

        local inst = char:FindFirstChild("Punch")
        if inst and inst:FindFirstChild("attackTime") then
            inst.attackTime.Value = 0.001
            muscleEvent:FireServer("punch", "rightHand")
            muscleEvent:FireServer("punch", "leftHand")
            inst:Activate()
        end
    end
end

local function tryRockTouch()
    local char = player.Character
    if player.Durability.Value >= durabilityNeeded then
        for _, v in pairs(workspace.machinesFolder:GetDescendants()) do
            if v.Name == "neededDurability" and v.Value == durabilityNeeded then
                local rock = v.Parent:FindFirstChild("Rock")
                if rock and char and char:FindFirstChild("RightHand") and char:FindFirstChild("LeftHand") then
                    firetouchinterest(rock, char.RightHand, 0)
                    firetouchinterest(rock, char.RightHand, 1)
                    firetouchinterest(rock, char.LeftHand, 0)
                    firetouchinterest(rock, char.LeftHand, 1)
                    punchRock()
                end
            end
        end
    end
end

local function doRep(toolName)
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local bp = player.Backpack

    if not char:FindFirstChild(toolName) then
        local tool = bp:FindFirstChild(toolName)
        if tool and humanoid then
            humanoid:EquipTool(tool)
        end
    end

    muscleEvent:FireServer("rep")
end

task.spawn(function()
    while true do
        if doPushups then
            doRep("Pushups")
            tryRockTouch()
        end
        if doSitups then
            doRep("Situps")
            tryRockTouch()
        end
        if doHandstands then
            doRep("Handstands")
            tryRockTouch()
        end
        task.wait(0.1)
    end
end)

player.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart")
    task.wait(2)
    warn("[RESPAWN] Player respawned â€” OP FARM auto-resumed.")
end)

farmPlusTab:Toggle({
    Title = "Pushups + Muscle King Rock",
    Callback = function(state)
        doPushups = state
    end
})

farmPlusTab:Toggle({
    Title = "Situps + Muscle King Rock",
    Callback = function(state)
        doSitups = state
    end
})

farmPlusTab:Toggle({
    Title = "Handstands + Muscle King Rock",
    Callback = function(state)
        doHandstands = state
    end
})

-- Gym farm Section
local FarmingCombo3 = farmPlusTab:Section({
Title = "Combo Legends",
Icon = "diamond-plus"})

local doPushups = false
local doSitups = false
local doHandstands = false
local durabilityNeeded = 1000000

local function punchRock()
    local char = player.Character
    local bp = player.Backpack
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")

    if char and bp and humanoid then
        local punch = bp:FindFirstChild("Punch")
        if punch and not char:FindFirstChild("Punch") then
            humanoid:EquipTool(punch)
        end

        local inst = char:FindFirstChild("Punch")
        if inst and inst:FindFirstChild("attackTime") then
            inst.attackTime.Value = 0.001
            muscleEvent:FireServer("punch", "rightHand")
            muscleEvent:FireServer("punch", "leftHand")
            inst:Activate()
        end
    end
end

local function tryRockTouch()
    local char = player.Character
    if player.Durability.Value >= durabilityNeeded then
        for _, v in pairs(workspace.machinesFolder:GetDescendants()) do
            if v.Name == "neededDurability" and v.Value == durabilityNeeded then
                local rock = v.Parent:FindFirstChild("Rock")
                if rock and char and char:FindFirstChild("RightHand") and char:FindFirstChild("LeftHand") then
                    firetouchinterest(rock, char.RightHand, 0)
                    firetouchinterest(rock, char.RightHand, 1)
                    firetouchinterest(rock, char.LeftHand, 0)
                    firetouchinterest(rock, char.LeftHand, 1)
                    punchRock()
                end
            end
        end
    end
end

local function doRep(toolName)
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local bp = player.Backpack

    if not char:FindFirstChild(toolName) then
        local tool = bp:FindFirstChild(toolName)
        if tool and humanoid then
            humanoid:EquipTool(tool)
        end
    end

    muscleEvent:FireServer("rep")
end

task.spawn(function()
    while true do
        if doPushups then
            doRep("Pushups")
            tryRockTouch()
        end
        if doSitups then
            doRep("Situps")
            tryRockTouch()
        end
        if doHandstands then
            doRep("Handstands")
            tryRockTouch()
        end
        task.wait(0.1)
    end
end)

player.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart")
    task.wait(2)
    warn("[RESPAWN] Player respawned â€” OP FARM auto-resumed.")
end)

farmPlusTab:Toggle({
    Title = "Pushups + Legends Rock",
    Callback = function(state)
        doPushups = state
    end
})

farmPlusTab:Toggle({
    Title = "Situps + Legends Rock",
    Callback = function(state)
        doSitups = state
    end
})

farmPlusTab:Toggle({
    Title = "Handstands + Legends Rock",
    Callback = function(state)
        doHandstands = state
    end
})

-- Farming Tab
local farmTab = Window:Tab({Title = "Rock Farm", Icon = "shield-check"})

-- Gym farm Section
local FarmingRock1 = farmTab:Section({
Title = "Rock Farm Ezz",
Icon = "mountain"})

getgenv().autoFarm = false
local currentDurabilityReq = 0
local activeRock = nil

local function gettool()
    for _, v in pairs(player.Backpack:GetChildren()) do
        if v.Name == "Punch" and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid:EquipTool(v)
        end
    end
    if player:FindFirstChild("muscleEvent") then
        player.muscleEvent:FireServer("punch", "leftHand")
        player.muscleEvent:FireServer("punch", "rightHand")
    end
end

local function doAutoFarm()
    task.spawn(function()
        while getgenv().autoFarm do
            task.wait(0.1)
            local char = player.Character
            if not char or not char:FindFirstChild("LeftHand") or not char:FindFirstChild("RightHand") then
                continue
            end

            local durability = player:FindFirstChild("Durability")
            if durability and durability.Value >= currentDurabilityReq then
                for _, v in pairs(workspace.machinesFolder:GetDescendants()) do
                    if v.Name == "neededDurability" and v.Value == currentDurabilityReq then
                        local rock = v.Parent:FindFirstChild("Rock")
                        if rock then
                            firetouchinterest(rock, char.RightHand, 0)
                            firetouchinterest(rock, char.RightHand, 1)
                            firetouchinterest(rock, char.LeftHand, 0)
                            firetouchinterest(rock, char.LeftHand, 1)
                            gettool()
                        end
                    end
                end
            end
        end
    end)
end

local function handleRespawn()
    player.CharacterAdded:Connect(function(newChar)
        if getgenv().autoFarm then
            task.wait(2) 
            doAutoFarm()
        end
    end)
end

local function startAutoFarm()
    if getgenv().autoFarm then return end
    getgenv().autoFarm = true
    handleRespawn()
    doAutoFarm()
end

local function stopAutoFarm()
    getgenv().autoFarm = false
end

-- Create rock toggles
local rocks = {
    {"Jungle Rock", 10000000},
    {"Muscle King Rock", 5000000},
    {"Legend Rock", 1000000},
    {"Eternal Rock", 750000},
    {"Mythical Rock", 400000},
    {"Frozen Rock", 150000},
    {"Golden Rock", 5000},
    {"Starter Rock", 100},
    {"Tiny Rock", 0}
}

for _, rock in ipairs(rocks) do
    farmTab:Toggle({
        Title = rock[1],
        Callback = function(Value)
            if Value then
                activeRock = rock[1]
                currentDurabilityReq = rock[2]
                startAutoFarm()
            else
                if activeRock == rock[1] then
                    stopAutoFarm()
                end
            end
        end
    })
end

local farmGymTab = Window:Tab({Title = "Gym Farm", Icon = "dumbbell"})

-- Gym farm Section
local KingTab = farmGymTab:Section({
Title = "Farm ( Jungle Gym )",
Icon = "tree-palm"})

local VIM = game:GetService("VirtualInputManager")

local function pressE()
    VIM:SendKeyEvent(true, "E", false, game)
    task.wait(0.1)
    VIM:SendKeyEvent(false, "E", false, game)
end

getgenv().working = false

local function autoLift()
    while getgenv().working do
        player.muscleEvent:FireServer("rep")
        task.wait() 
    end
end

local function teleportAndStart(machineName, position)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        
        for i = 1, 9 do 
            
            character.HumanoidRootPart.CFrame = position
            task.wait(0.01)
            pressE()
            task.spawn(autoLift) 
        end 
    end
end

farmGymTab:Toggle({
    Title = "Jungle Bench Press",
    Callback = function(bool)
        if getgenv().working and not bool then
            getgenv().working = false
            return
        end
    
        getgenv().working = bool
        if bool then
            teleportAndStart("Bench Press", CFrame.new(-8173, 64, 1898))
        end
    end
})

farmGymTab:Toggle({
    Title = "Jungle Squat",
    Callback = function(bool)
        if getgenv().working and not bool then
            getgenv().working = false
            return
        end
    
        getgenv().working = bool
        if bool then
            teleportAndStart("Squat", CFrame.new(-8352, 34, 2878))
        end
    end
})

farmGymTab:Toggle({
    Title = "Jungle Pull Ups",
    Callback = function(bool)
        if getgenv().working and not bool then
            getgenv().working = false
            return
        end
    
        getgenv().working = bool
        if bool then
            teleportAndStart("Pull Up", CFrame.new(-8666, 34, 2070))
        end
    end
})

farmGymTab:Toggle({
    Title = "Jungle Boulder",
    Callback = function(bool)
        if getgenv().working and not bool then
            getgenv().working = false
            return
        end
    
        getgenv().working = bool
        if bool then
            teleportAndStart("Boulder", CFrame.new(-8621, 34, 2684))
        end
    end
})

farmGymTab:Space()

-- Gym farm Section
local KingTab = farmGymTab:Section({
Title = "Farm ( Muscle King )",
Icon = "crown"})

farmGymTab:Toggle({
    Title = "Muscle King Bench Press",
    Callback = function(bool)
        if getgenv().working and not bool then
            getgenv().working = false
            return
        end
    
        getgenv().working = bool
        if bool then
            teleportAndStart("Bench Press", CFrame.new(-8590.23535, 51, -6044.59521, -1, 0, 0, 0, 1, 0, 0, 0, -1))
        end
    end
})

farmGymTab:Toggle({
    Title = "Muscle King Squat",
    Callback = function(bool)
        if getgenv().working and not bool then
            getgenv().working = false
            return
        end
    
        getgenv().working = bool
        if bool then
            teleportAndStart("Squat", CFrame.new(-8758.44238, 44.1433296, -6043.06934, -1, 0, 0, 0, 1, 0, 0, 0, -1))
        end
    end
})

farmGymTab:Toggle({
    Title = "Muscle King Lifting",
    Callback = function(bool)
        if getgenv().working and not bool then
            getgenv().working = false
            return
        end
    
        getgenv().working = bool
        if bool then
            teleportAndStart("Pull Up", CFrame.new(-8772.9707, 49.7349625, -5663.5625, -1, 0, 0, 0, 1, 0, 0, 0, -1))
        end
    end
})

farmGymTab:Toggle({
    Title = "Muscle King Boulder",
    Callback = function(bool)
        if getgenv().working and not bool then
            getgenv().working = false
            return
        end
    
        getgenv().working = bool
        if bool then
            teleportAndStart("Boulder", CFrame.new(-8942.12891, 49.6002846, -5691.63623, -1, 0, 0, 0, 1, 0, 0, 0, -1))
        end
    end
})

farmGymTab:Space()

-- Gym farm Section
local legendsTab = farmGymTab:Section({
Title = "Farm ( Legends Gym ) ",
Icon = "dumbbell"})

farmGymTab:Toggle({
    Title = "Legends Bench Press",
    Callback = function(bool)
        if getgenv().working and not bool then
            getgenv().working = false
            return
        end
    
        getgenv().working = bool
        if bool then
            teleportAndStart("Bench Press", CFrame.new(4109.91309, 1019.80396, -3802.15332, -1, 0, 0, 0, 1, 0, 0, 0, -1))
        end
    end
})

farmGymTab:Toggle({
    Title = "Legends Squat",
    Callback = function(bool)
        if getgenv().working and not bool then
            getgenv().working = false
            return
        end
    
        getgenv().working = bool
        if bool then
            teleportAndStart("Squat", CFrame.new(4439.77344, 1019.34332, -4058.48682, -1, 0, 0, 0, 1, 0, 0, 0, -1))
        end
    end
})

farmGymTab:Toggle({
    Title = "Legends Lifting",
    Callback = function(bool)
        if getgenv().working and not bool then
            getgenv().working = false
            return
        end
    
        getgenv().working = bool
        if bool then
            teleportAndStart("Squat", CFrame.new(4532.21777, 1023.03497, -4002.71216, -1, 0, 0, 0, 1, 0, 0, 0, -1))
        end
    end
})

farmGymTab:Toggle({
    Title = "Legends Pull Ups",
    Callback = function(bool)
        if getgenv().working and not bool then
            getgenv().working = false
            return
        end
    
        getgenv().working = bool
        if bool then
            teleportAndStart("Pull Up", CFrame.new(4304.02393, 1020.08582, -4122.27734, -1, 0, 0, 0, 1, 0, 0, 0, -1))
        end
    end
})

farmGymTab:Toggle({
    Title = "Legends Boulder",
    Callback = function(bool)
        if getgenv().working and not bool then
            getgenv().working = false
            return
        end
    
        getgenv().working = bool
        if bool then
            teleportAndStart("Boulder", CFrame.new(4189.96143, 1010.20032, -3903.0166, -1, 0, 0, 0, 1, 0, 0, 0, -1))
        end
    end
})

farmGymTab:Space()

-- Gym farm Section
local InfernoTab = farmGymTab:Section({Title = "Farm ( Inferno Gym ) ", Icon = "flame"})

farmGymTab:Toggle({
    Title = "Inferno Bench Press",
    Callback = function(bool)
        if getgenv().working and not bool then
            getgenv().working = false
            return
        end
    
        getgenv().working = bool
        if bool then
            teleportAndStart("Bench Press", CFrame.new(-7173.3418, 44.7310448, -1105.02759, -1, 0, 0, 0, 1, 0, 0, 0, -1))
        end
    end
})

-- Gym farm Section
local MythicalTab = farmGymTab:Section({
Title = "Farm ( Mythical Gym )",
Icon = "biohazard"})

farmGymTab:Toggle({
    Title = "Mythical Bench Press",
    Callback = function(bool)
        if getgenv().working and not bool then
            getgenv().working = false
            return
        end
    
        getgenv().working = bool
        if bool then
            teleportAndStart("Bench Press", CFrame.new(2369.70044, 38.5528984, 1243.02173, -1, 0, 0, 0, 1, 0, 0, 0, -1))
        end
    end
})

farmGymTab:Toggle({
    Title = "Mythical Pull Ups",
    Callback = function(bool)
        if getgenv().working and not bool then
            getgenv().working = false
            return
        end
    
        getgenv().working = bool
        if bool then
            teleportAndStart("Pull Up", CFrame.new(2487.12085, 29.9059505, 848.289124, -1, 0, 0, 0, 1, 0, 0, 0, -1))
        end
    end
})

farmGymTab:Toggle({
    Title = "Mythical Boulder",
    Callback = function(bool)
        if getgenv().working and not bool then
            getgenv().working = false
            return
        end
    
        getgenv().working = bool
        if bool then
            teleportAndStart("Boulder", CFrame.new(2667.74072, 46.027359, 1203.33374, -1, 0, 0, 0, 1, 0, 0, 0, -1))
        end
    end
})


-- Global References (Asumsi ini didefinisikan di tempat lain)
-- local Window = ... 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local tradingEvent = ReplicatedStorage:WaitForChild("rEvents"):WaitForChild("tradingEvent")

--------------------------------------------------------------------------------
-- 1. Variables 📦
--------------------------------------------------------------------------------

-- Crystal Variables
local selectedCrystal = "Galaxy Oracle Crystal"
local autoCrystalRunning = false
local crystalNames = {
    "Blue Crystal", "Green Crystal", "Frozen Crystal", "Mythical Crystal",
    "Inferno Crystal", "Legends Crystal", "Muscle Elite Crystal",
    "Galaxy Oracle Crystal", "Sky Eclipse Crystal", "Jungle Crystal"
}

-- Pet Trade/Buy/Evolve Variables
local petList = {
    "Neon Guardian", "Muscle Sensei", "Darkstar Hunter", "Muscle King", 
    "Cybernetic Showdown Dragon", "Magic Butterfly"
}
local selectedPetName = petList[1]
local selectedPlayer = nil
local PET_COUNT = 6 -- Jumlah pet yang akan di-trade/diberi

local autoBuySelectedPet = false
local autoEvolveSelectedPet = false
local autoTradeToSelected = false
local autoTradeToAll = false

--------------------------------------------------------------------------------
-- 2. Utility Functions 🛠️
--------------------------------------------------------------------------------

local function getPlayerDisplay(plr)
    return (plr.DisplayName and plr.DisplayName ~= "") and plr.DisplayName or plr.Name
end

local function buildPlayerDisplayList()
    local list = {}
    if not player then return {"None"} end 

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            table.insert(list, getPlayerDisplay(plr))
        end
    end
    if #list == 0 then table.insert(list, "None") end
    return list
end

local function getPetInstances(petName, n)
    local pets = {}
    if not player then return pets end 

    local petsFolder = player:FindFirstChild("petsFolder")
    local uniquePets = petsFolder and petsFolder:FindFirstChild("Unique")
    if uniquePets then
        for _, pet in ipairs(uniquePets:GetChildren()) do
            if pet.Name == petName then
                table.insert(pets, pet)
                if #pets >= n then break end
            end
        end
    end
    return pets
end

local function isTradePending()
    if not player then return false end 
    return player:FindFirstChild("CurrentTrade") ~= nil
end

local function isTradeAccepted()
    if not player then return false end 
    local currentTrade = player:FindFirstChild("CurrentTrade")
    if currentTrade and currentTrade:FindFirstChild("Accepted") then
        return currentTrade.Accepted.Value
    end
    return false
end

--------------------------------------------------------------------------------
-- 3. Core Logic Functions ⚙️
--------------------------------------------------------------------------------

-- Auto Crystal Loop
local function autoOpenCrystal()
    while autoCrystalRunning do
        local rEvents = ReplicatedStorage:FindFirstChild("rEvents")
        if rEvents and rEvents:FindFirstChild("openCrystalRemote") then
            pcall(function() rEvents.openCrystalRemote:InvokeServer("openCrystal", selectedCrystal) end)
        end
        wait(0.1)
    end
end

-- Auto Buy Pet Loop
local function autoBuyPetLoop()
    while autoBuySelectedPet do
        if selectedPetName and selectedPetName ~= "" then
            local shopFolder = ReplicatedStorage:FindFirstChild("cPetShopFolder")
            local cPetShopRemote = ReplicatedStorage:FindFirstChild("cPetShopRemote")
            if shopFolder and cPetShopRemote then
                local petObj = shopFolder:FindFirstChild(selectedPetName)
                if petObj then
                    pcall(function() cPetShopRemote:InvokeServer(petObj) end)
                end
            end
        end
        task.wait()
    end
end

-- Auto Evolve Pet Loop
local function autoEvolvePetLoop()
    while autoEvolveSelectedPet do
        if selectedPetName and selectedPetName ~= "" then
            local rEvents = ReplicatedStorage:FindFirstChild("rEvents")
            if rEvents and rEvents:FindFirstChild("petEvolveEvent") then
                pcall(function()
                    rEvents.petEvolveEvent:FireServer("evolvePet", selectedPetName)
                end)
            end
        end
        task.wait()
    end
end

-- Main Trade Loop (Handles Sending Trade & Auto Accepting)
local function mainTradeLoop()
    while true do
        -- A. Auto Trade To Selected Player
        if autoTradeToSelected and selectedPetName and selectedPlayer and not isTradePending() then
            local pets = getPetInstances(selectedPetName, PET_COUNT)
            if #pets > 0 then
                pcall(function() tradingEvent:FireServer("sendTradeRequest", selectedPlayer) end)
                task.wait(0.2)
                
                for _, pet in ipairs(pets) do
                    pcall(function() tradingEvent:FireServer("offerItem", pet) end)
                    task.wait(0.1)
                end
                
                if not isTradeAccepted() then 
                    pcall(function() tradingEvent:FireServer("confirmTrade") end)
                    pcall(function() tradingEvent:FireServer("acceptTrade") end)
                end
                task.wait(0.5) 
            end
        end

        -- B. Auto Trade To All (Mengirim ke SEMUA pemain)
        if autoTradeToAll and selectedPetName and not isTradePending() then
            local pets = getPetInstances(selectedPetName, PET_COUNT)
            
            if #pets > 0 then
                local playersList = Players:GetPlayers()
                local tradedSuccessfully = false

            if #pets > 0 then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= player then
                        pcall(function() tradingEvent:FireServer("sendTradeRequest", plr) end)
                        task.wait()
                    end
                end
                for _, pet in ipairs(pets) do
                    pcall(function() tradingEvent:FireServer("offerItem", pet) end)
                    task.wait()
                end
                if not isTradeAccepted() then
                    pcall(function() tradingEvent:FireServer("confirmTrade") end)
                    pcall(function() tradingEvent:FireServer("acceptTrade") end)
                end
                task.wait(3)
            end
                
                -- Jeda yang lebih lama setelah mencoba berinteraksi dengan semua pemain
                if tradedSuccessfully then
                    task.wait(5)
                else
                    task.wait(1) 
                end
            end
        end

        -- C. Auto Accept Incoming Trade
        local currentTrade = player:FindFirstChild("CurrentTrade")
        if currentTrade then
            pcall(function() tradingEvent:FireServer("acceptTrade") end) 
            task.wait(0.1)

            local tradeItems
            local timeoutStart = tick()
            repeat
                task.wait()
                tradeItems = currentTrade:FindFirstChild("OfferedItems")
                if tick() - timeoutStart > 8 then break end
            until tradeItems and #tradeItems:GetChildren() > 0

            pcall(function() tradingEvent:FireServer("confirmTrade") end)
            pcall(function() tradingEvent:FireServer("acceptTrade") end)
        end

        task.wait()
    end
end

--------------------------------------------------------------------------------
-- 4. UI Setup 🖥️
--------------------------------------------------------------------------------

local Crystal = Window:Tab({Title = "Crystal", Icon = "gem"})

-- Crystal Section
local crystalSection = Crystal:Section({Title = "Open Crystal", Icon = "gem"})

Crystal:Dropdown({
    Title = "Select Crystal",
    Values = crystalNames,
    Value = selectedCrystal,
    Callback = function(text)
        selectedCrystal = text
    end
})

Crystal:Toggle({
    Title = "Auto Crystal",
    Callback = function(state)
        autoCrystalRunning = state
        if autoCrystalRunning then
            task.spawn(autoOpenCrystal)
        end
    end
})

Crystal:Space()

---
-- Pet Trading Section
local petSection = Crystal:Section({
Title = "Pet Infinity",
Icon = "infinity",
Locked = true,
        LockedTitle = "VIP Only",
    })

Crystal:Dropdown({
    Title = "Select Pet",
    Values = petList,
    Value = selectedPetName,
    Locked = true,
        LockedTitle = "VIP Only",
    })

Crystal:Toggle({
    Title = "Auto Get Pet",
    Locked = true,
        LockedTitle = "VIP Only",
    })

Crystal:Toggle({
    Title = "Auto Evolved Pet",
    Locked = true,
        LockedTitle = "VIP Only",
    })

Crystal:Space()

---
-- Other Section (Trade)
local otherSection = Crystal:Section({Title = "Give Pet", Icon = "gitlab"})

Crystal:Dropdown({
    Title = "Select Player",
    Values = buildPlayerDisplayList(),
    Callback = function(selectedDisplay)
        selectedPlayer = nil
        if not player then return end

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and getPlayerDisplay(plr) == selectedDisplay then
                selectedPlayer = plr
                break
            end
            
        end
    end
})

Crystal:Toggle({
    Title = "Trade Select Player",
    Callback = function(state)
        autoTradeToSelected = state
    end
})

Crystal:Toggle({
    Title = "Trade All Player",
    Callback = function(state)
        autoTradeToAll = state
    end
})

--------------------------------------------------------------------------------
-- 5. Initialize Main Loop 🚀
--------------------------------------------------------------------------------

task.spawn(mainTradeLoop)

-- Killing Tab
local KillSelect = Window:Tab({Title = "Killer", Icon = "locate-fixed"})

local KillerV1 = KillSelect:Section({Title = "Animation", Icon = "omega"})

KillSelect:Button({
    Title = "Remove Attack Animations",
    Locked = true,
        LockedTitle = "VIP Only",
    })

KillSelect:Toggle({
    Title = "Fast Punch",
    Callback = function(bool)
        _G.FastPunch = bool

        local function startFastPunch()
            if _G.FastPunchActive then return end
            _G.FastPunchActive = true
            
            task.spawn(function()
                while _G.FastPunch do
                    local character = player.Character
                    if character then
                        local punch = character:FindFirstChild("Punch") or player.Backpack:FindFirstChild("Punch")
                        if punch then
                            if punch:FindFirstChild("attackTime") then
                                punch.attackTime.Value = 0
                            end
                            if not character:FindFirstChild("Punch") and character:FindFirstChild("Humanoid") then
                                character.Humanoid:EquipTool(punch)
                            end
                        end
                    end
                    task.wait(0.0001)
                end
                _G.FastPunchActive = false
            end)
            
            task.spawn(function()
                while _G.FastPunch do
                    local character = player.Character
                    local muscleEvent = player:FindFirstChild("muscleEvent")
                    
                    if muscleEvent then
                        muscleEvent:FireServer("punch", "rightHand")
                        muscleEvent:FireServer("punch", "leftHand")
                    end

                    if character then
                        local punchTool = character:FindFirstChild("Punch")
                        if punchTool then
                            punchTool:Activate()
                        end
                    end

                    task.wait() 
                end
            end)
        end

        local function stopFastPunch()
            _G.FastPunch = false
            local character = player.Character
            if character then
                local equipped = character:FindFirstChild("Punch")
                if equipped and equipped:FindFirstChild("attackTime") then
                    equipped.attackTime.Value = 0.35
                end
                if equipped then
                    equipped.Parent = player.Backpack
                end
            end
            local backpackTool = player.Backpack:FindFirstChild("Punch")
            if backpackTool and backpackTool:FindFirstChild("attackTime") then
                backpackTool.attackTime.Value = 0.35
            end
        end
        
        if bool then
            startFastPunch()
            player.CharacterAdded:Connect(function(newChar)
                newChar:WaitForChild("HumanoidRootPart")
                task.wait(0.5)
                if _G.FastPunch then
                    startFastPunch()
                end
            end)
        else
            stopFastPunch()
        end
    end
})

local KillerV2 = KillSelect:Section({Title = "Killer", Icon = "skull"})

KillSelect:Toggle({
    Title = "Auto Kill All Players",
    Callback = function(state)
        if state then
            local url = "https://raw.githubusercontent.com/seth-pogi/-kill-alllllll/refs/heads/main/Code"
            local success, response = pcall(function()
                return game:HttpGet(url)
            end)
            if success and response then
                loadstring(response)()
            else
                warn("Failed to load Auto Kill All script")
            end
        end
    end
})

local autoGoodKarma = false
KillSelect:Toggle({
    Title = "Auto Good Karma",
    Callback = function(bool)
        autoGoodKarma = bool
        if autoGoodKarma then
            task.spawn(function()
                while autoGoodKarma do
                    local playerChar = player.Character
                    local rightHand = playerChar and playerChar:FindFirstChild("RightHand")
                    local leftHand = playerChar and playerChar:FindFirstChild("LeftHand")

                    if playerChar and rightHand and leftHand then
                        for _, target in ipairs(Players:GetPlayers()) do
                            if target ~= player then
                                local evilKarma = target:FindFirstChild("evilKarma")
                                local goodKarma = target:FindFirstChild("goodKarma")

                                if evilKarma and goodKarma and evilKarma:IsA("IntValue") and goodKarma:IsA("IntValue") and evilKarma.Value > goodKarma.Value then
                                    local targetChar = target.Character
                                    local rootPart = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

                                    if rootPart then
                                        firetouchinterest(rightHand, rootPart, 1)
                                        firetouchinterest(leftHand, rootPart, 1)
                                        firetouchinterest(rightHand, rootPart, 0)
                                        firetouchinterest(leftHand, rootPart, 0)
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.01)
                end
            end)
        end
    end
})

local autoEvilKarma = false
KillSelect:Toggle({
    Title = "Auto Evil Karma",
    Callback = function(bool)
        autoEvilKarma = bool
        if autoEvilKarma then
            task.spawn(function()
                while autoEvilKarma do
                    local playerChar = player.Character
                    local rightHand = playerChar and playerChar:FindFirstChild("RightHand")
                    local leftHand = playerChar and playerChar:FindFirstChild("LeftHand")

                    if playerChar and rightHand and leftHand then
                        for _, target in ipairs(Players:GetPlayers()) do
                            if target ~= player then
                                local evilKarma = target:FindFirstChild("evilKarma")
                                local goodKarma = target:FindFirstChild("goodKarma")

                                if evilKarma and goodKarma and evilKarma:IsA("IntValue") and goodKarma:IsA("IntValue") and goodKarma.Value > evilKarma.Value then
                                    local targetChar = target.Character
                                    local rootPart = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

                                    if rootPart then
                                        firetouchinterest(rightHand, rootPart, 1)
                                        firetouchinterest(leftHand, rootPart, 1)
                                        firetouchinterest(rightHand, rootPart, 0)
                                        firetouchinterest(leftHand, rootPart, 0)
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.01)
                end
            end)
        end
    end
})

local KillerV3 = KillSelect:Section({Title = "Killer Targett", Icon = "skull"})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local selectedSpyPlayerName = nil
local killTargets = {}
local spyingEnabled = false
local autoKillEnabled = false
local bringTargetsEnabled = false

local function getPlayerDisplayText(player)
    return player.DisplayName .. " | " .. player.Name
end

local function getNameFromDisplay(text)
    return text and text:match("|%s*(.+)$")
end

local function buildPlayerDisplayList()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(list, getPlayerDisplayText(p))
        end
    end
    return list
end

KillSelect:Dropdown({
    Title = "Spectate Player",
    Values = buildPlayerDisplayList(),
    Callback = function(text)
        local name = getNameFromDisplay(text)
        if name then
            selectedSpyPlayerName = name
            spyLabel:SetText("Spy Player: " .. name)  -- Menggunakan :SetText jika WindUI mendukung, atau sesuaikan
        end
    end
})

KillSelect:Toggle({
    Title = "Spectate Player",  -- Nama toggle sesuai permintaan, tapi logika masih spying (updateCamera)
    Callback = function(state)
        spyingEnabled = state

        local function updateCamera()
            if not spyingEnabled then
                Camera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
                return
            end

            task.spawn(function()
                while spyingEnabled do
                    local target = selectedSpyPlayerName and Players:FindFirstChild(selectedSpyPlayerName)
                    if target and target.Character and target.Character:FindFirstChild("Humanoid") then
                        Camera.CameraSubject = target.Character.Humanoid
                    end
                    task.wait(0.1)
                end
            end)
        end

        updateCamera()
    end
})

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if spyingEnabled and selectedSpyPlayerName then
        task.spawn(function()
            while spyingEnabled do
                local target = Players:FindFirstChild(selectedSpyPlayerName)
                if target and target.Character and target.Character:FindFirstChild("Humanoid") then
                    Camera.CameraSubject = target.Character.Humanoid
                end
                task.wait(0.1)
            end
        end)
    end
end)

-- Bagian Auto Kill dan Bring Target
local killTargets = {}
local autoKillEnabled = false

-- Dropdown untuk select target (targetDropdown didefinisikan di sini)
local targetDropdown = KillSelect:Dropdown({
    Title = "Select Target",
    Values = buildPlayerDisplayList(),
    Callback = function(text)
        local name = getNameFromDisplay(text)
        if name and not table.find(killTargets, name) then
            table.insert(killTargets, name)
            killLabel:SetText("Targeted Players: " .. table.concat(killTargets, ", "))  -- Menggunakan :SetText
        end
    end
})

KillSelect:Button({
    Title = "Remove All Targets",
    Callback = function()
        killTargets = {}
        killLabel:SetText("Targeted Players: None")  -- Menggunakan :SetText
    end
})

Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then
        local display = getPlayerDisplayText(p)
        spyDropdown:Add(display)
        targetDropdown:Add(display)
    end
end)

Players.PlayerRemoving:Connect(function(p)
    local display = getPlayerDisplayText(p)
    spyDropdown:Remove(display)
    targetDropdown:Remove(display)
    local index = table.find(killTargets, p.Name)
    if index then
        table.remove(killTargets, index)
        if #killTargets == 0 then
            killLabel:SetText("Targeted Players: None")
        else
            killLabel:SetText("Targeted Players: " .. table.concat(killTargets, ", "))
        end
    end
end)

local function startAutoKill()
    task.spawn(function()
        while autoKillEnabled do
            local char = LocalPlayer.Character
            if char then
                for _, name in ipairs(killTargets) do
                    local target = Players:FindFirstChild(name)
                    local root = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        local right = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
                        local left = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
                        if right and left then
                            firetouchinterest(right, root, 1)
                            firetouchinterest(left, root, 1)
                            firetouchinterest(right, root, 0)
                            firetouchinterest(left, root, 0)
                        end
                    end
                end
            end
            task.wait(0.05)
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    if autoKillEnabled then
        task.wait(2)
        startAutoKill()
    end
end)

KillSelect:Toggle({
    Title = "Kill Target",
    Callback = function(state)
        autoKillEnabled = state
        if state then
            startAutoKill()
        end
    end
})

KillSelect:Toggle({
    Title = "Bring Target",
    Callback = function(state)
        bringTargetsEnabled = state
        if state then
            task.spawn(function()  -- Dibungkus dalam task.spawn untuk menghindari pembekuan
                while bringTargetsEnabled do
                    local myChar = LocalPlayer.Character
                    local hand = myChar and (myChar:FindFirstChild("RightHand") or myChar:FindFirstChild("LeftHand"))
                    local handCFrame = hand and hand.CFrame

                    if handCFrame then
                        for _, name in ipairs(killTargets) do
                            local target = Players:FindFirstChild(name)
                            local root = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                            if root then
                                root.CFrame = handCFrame + Vector3.new(0, 0, 0)
                            end
                        end
                    end

                    task.wait(0.5)
                end
            end)
        end
    end
})

local KillerV4 = KillSelect:Section({Title = "Aura Killer", Icon = "eye"})

-- ====== INPUT RADIUS ======
KillSelect:Input({
    Title = "Set Radius",
    Placeholder = "Enter Radius (1-150)",
    Locked = true,
        LockedTitle = "VIP Only",
    })

-- ====== TOGGLE KILL AURA ======
KillSelect:Toggle({
    Title = "KILL AURA ON/OFF",
    Locked = true,
        LockedTitle = "VIP Only",
    })

-- ====== CLEANUP ======
LocalPlayer.CharacterRemoving:Connect(function()
    runAura = false
    if auraConnection then auraConnection:Disconnect() auraConnection = nil end
    for _, segment in ipairs(radiusVisuals) do segment:Destroy() end
    radiusVisuals = {}
end)

Players.PlayerAdded:Connect(function(player)
    if LocalPlayer:IsFriendsWith(player.UserId) then
        friendWhitelist[player.UserId] = true
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    updateFriendWhitelist()
end)

-- Rebirth Tab
local rebirthTab = Window:Tab({Title = "Rebirth", Icon = "refresh-cw"})

-- Gym farm Section
local glitch_h = rebirthTab:Section({
Title = "Fast Rebirth",
Icon = "skull"})

rebirthTab:Toggle({
    Title = "Auto Farm Rebirth",
    Locked = true,
        LockedTitle = "VIP Only",
    })

rebirthTab:Toggle({
    Title = "Hide Frame",
    Locked = true,
        LockedTitle = "VIP Only",
    })

-- Gym farm Section
local Farmingg = rebirthTab:Section({
Title = "Rebirth Target",
Icon = "crosshair"})

local rebirthTarget = 0
local rebirthingToTarget = false
local teleportActive = false
_G.FastWeight = false
_G.autoSizeActive = false

rebirthTab:Input({
    Title = "Rebirth Target",
    Callback = function(text)
        rebirthTarget = tonumber(text) or 0
    end
})

rebirthTab:Toggle({
    Title = "Auto Rebirth Target",
    Callback = function(bool)
        rebirthingToTarget = bool

        task.spawn(function()
            while rebirthingToTarget do
                local leaderstats = player:FindFirstChild("leaderstats")
                local rebirths = leaderstats and leaderstats:FindFirstChild("Rebirths")

                if rebirths and rebirths.Value >= rebirthTarget then
                    rebirthingToTarget = false
                    break
                end

                ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                task.wait(0.1)
            end
        end)
    end
})

rebirthTab:Toggle({
    Title = "Auto Rebirth Infinity",
    Callback = function(bool)
        local isAutoRebirthing = bool

        task.spawn(function()
            while isAutoRebirthing do 
                ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                task.wait(0.1) 
            end
        end)
    end
})

rebirthTab:Toggle({
    Title = "Hide Frame",
    Callback = function(bool)
        for _, obj in pairs(ReplicatedStorage:GetChildren()) do
            if obj.Name:match("Frame$") then
                obj.Visible = not bool
            end
        end
    end
})

rebirthTab:Space()

-- Gym farm Section
local Farmingg = rebirthTab:Section({
Title = "Farming",
Icon = "dumbbell"})

local function activateProteinEgg()
    local tool = player.Character:FindFirstChild("Protein Egg") or player.Backpack:FindFirstChild("Protein Egg")
    if tool then
        muscleEvent:FireServer("proteinEgg", tool)
    end
end

local running = false

task.spawn(function()
    while true do
        if running then
            activateProteinEgg()
            task.wait(1800)
        else
            task.wait(1)
        end
    end
end)

rebirthTab:Toggle({
    Title = "Auto Eat Egg | 30mins",
    Desc = " Get 2x Strength | 30 Minute",
    Locked = true,
        LockedTitle = "This element is locked",
    })
    
rebirthTab:Toggle({
    Title = "Auto Weight",
    Callback = function(bool)
        _G.FastWeight = bool

        if bool then
            task.spawn(function()
                while _G.FastWeight do
                    local char = player.Character
                    if char and not char:FindFirstChild("Weight") then
                        local weightTool = player.Backpack:FindFirstChild("Weight")
                        if weightTool then
                            if weightTool:FindFirstChild("repTime") then
                                weightTool.repTime.Value = 0
                            end
                            char.Humanoid:EquipTool(weightTool)
                        end
                    elseif char and char:FindFirstChild("Weight") then
                        local equipped = char:FindFirstChild("Weight")
                        if equipped:FindFirstChild("repTime") then
                            equipped.repTime.Value = 0
                        end
                    end
                    task.wait(0.1)
                end
            end)

            task.spawn(function()
                while _G.FastWeight do
                    player.muscleEvent:FireServer("rep")
                    task.wait(0)
                end
            end)
        else
            local char = player.Character
            local equipped = char and char:FindFirstChild("Weight")
            if equipped then
                if equipped:FindFirstChild("repTime") then
                    equipped.repTime.Value = 1
                end
                equipped.Parent = player.Backpack
            end
            local backpackTool = player.Backpack:FindFirstChild("Weight")
            if backpackTool and backpackTool:FindFirstChild("repTime") then
                backpackTool.repTime.Value = 1
            end
        end
    end
})

rebirthTab:Toggle({
    Title = "Auto Size 1",
    Callback = function(bool)
        _G.autoSizeActive = bool
        if bool then
            task.spawn(function()
                while _G.autoSizeActive and task.wait() do
                    ReplicatedStorage.rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 0)
                end
            end)
        end
    end
})

local targetPosition = CFrame.new(-8742, 121, -5858)
rebirthTab:Toggle({
    Title = "Auto King",
    Callback = function(enabled)
        teleportActive = enabled
    end
})

task.spawn(function()
    while true do
        if teleportActive then
            local char = player.Character or player.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            if (hrp.Position - targetPosition.Position).Magnitude > 5 then
                hrp.CFrame = targetPosition
            end
        end
        task.wait(0.05)
    end
end)

player.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart")
    task.wait(2)
    warn("[RESPAWN] Character respawned â€” continuing automation...")

    if _G.FastWeight then
        task.spawn(function()
            while _G.FastWeight do
                local c = player.Character
                if c and not c:FindFirstChild("Weight") then
                    local tool = player.Backpack:FindFirstChild("Weight")
                    if tool then
                        c.Humanoid:EquipTool(tool)
                    end
                end
                player.muscleEvent:FireServer("rep")
                task.wait(0.1)
            end
        end)
    end

    if _G.autoSizeActive then
        task.spawn(function()
            while _G.autoSizeActive do
                ReplicatedStorage.rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 0)
                task.wait(0.2)
            end
        end)
    end

    if teleportActive then
        task.spawn(function()
            local hrp = char:WaitForChild("HumanoidRootPart")
            while teleportActive do
                if (hrp.Position - targetPosition.Position).Magnitude > 5 then
                    hrp.CFrame = targetPosition
                end
                task.wait(0.05)
            end
        end)
    end
end)

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

_G.afkGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
_G.afkGui.Name = "AntiAFKGui"
_G.afkGui.ResetOnSpawn = true

rebirthTab:Toggle({
    Title = "Anti-AFK",
    Callback = function(state)
        if state then
            local VirtualUser = game:GetService("VirtualUser")

            _G.afkGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
            _G.afkGui.Name = "AntiAFKGui"
            _G.afkGui.ResetOnSpawn = false

            local timer = Instance.new("TextLabel", _G.afkGui)
            timer.Size = UDim2.new(0, 200, 0, 30)
            timer.Position = UDim2.new(1, -210, 0, -20)
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

rebirthTab:Space()

-- Gym farm Section
local Farmingg = rebirthTab:Section({
Title = "Upgrade Ultimate",
Icon = "sparkles"})

local ultimateOptions = {
    "+1 Daily Spin",
    "+1 Pet Slot",
    "+10 Item Capacity",
    "+5% Rep Speed",
    "Demon Damage",
    "Galaxy Gains",
    "Golden Rebirth",
    "Jungle Swift",
    "Muscle Mind",
    "x2 Chest Rewards",
    "x2 Quest Rewards"
}

local autoUltimateToggles = {}

for _, ultimate in ipairs(ultimateOptions) do
    autoUltimateToggles[ultimate] = false
    rebirthTab:Toggle({
        Title = "Auto Buy " .. ultimate,
        Callback = function(state)
            autoUltimateToggles[ultimate] = state
            if state then
                task.spawn(function()
                    while autoUltimateToggles[ultimate] do
                        pcall(function()
                            ReplicatedStorage.rEvents.ultimatesRemote:InvokeServer("upgradeUltimate", ultimate)
                        end)
                        task.wait(1)
                    end
                end)
            end
        end
    })
end

-- Teleport Tab
local teleportTab = Window:Tab({Title = "Teleport", Icon = "map-pin"})

-- Gym farm Section
local Teleport1 = teleportTab:Section({
Title = "Teleportation Glitch",
Icon = "radio-tower"})

local function safeTeleport(cframe)
    local character = player.Character or player.CharacterAdded:Wait()
    local root = character:WaitForChild("HumanoidRootPart", 10)
    if root then
        root.CFrame = cframe
    end
end

local teleportLocations = {
    {"Glitch Tp 1", CFrame.new(4466.90918, 391.794525, -9176.28418, -0.985972404, 1.91417904e-09, -0.166908562, 5.25488852e-09, 1, -1.95735694e-08, 0.166908562, -2.0176083e-08, -0.985972404)},
    {"Glitch Tp 2", CFrame.new(4785.2412109375, 391.9150085449219, -9154.6376953125)},
    {"Glitch Tp 3", CFrame.new(4178.14501953125, 391.67266845703125, -9158.5244140625)},
    {"Glitch Tp 4", CFrame.new(4178.7314453125, 391.617919921875, -8789.45703125)},
    {"Glitch Tp 5", CFrame.new(4764.4091796875, 391.4629211425781, -8859.970703125)},
    {"Glitch Tp 6", CFrame.new(4781.07177734375, 391.5324401855469, -8558.205078125)},
    {"Glitch Tp 7", CFrame.new(4177.03173828125, 391.5628967285156, -8560.72265625)}
}

for _, location in ipairs(teleportLocations) do
    teleportTab:Button({
        Title = location[1],
        Callback = function()
            safeTeleport(location[2])
        end
    })
end

teleportTab:Space()

-- Gym farm Section
local Teleport2 = teleportTab:Section({
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
    teleportTab:Button({
        Title = location[1],
        Callback = function()
            safeTeleport(location[2])
        end
    })
end

player.CharacterAdded:Connect(function()
    task.wait(1)
end)

-- Misc Tab
local miscTab = Window:Tab({Title = "Misc", Icon = "settings"})

-- Misc 2 Section
local miscccFolder = miscTab:Section({
Title = "New Event", 
Icon = "radar"
})

local itemList = { "Tropical Shake", "Energy Shake", "Protein Bar", "TOUGH Bar", "Protein Shake", "ULTRA Shake", "Energy Bar" }

local function formatEventName(itemName)
    local parts = {}
    for word in itemName:gmatch("%S+") do
        table.insert(parts, word:lower())
    end
    for i = 2, #parts do
        parts[i] = parts[i]:sub(1,1):upper() .. parts[i]:sub(2)
    end
    return table.concat(parts)
end

local function activateItems()
    for _, itemName in ipairs(itemList) do
        local tool = player.Character:FindFirstChild(itemName) or player.Backpack:FindFirstChild(itemName)
        if tool then
            local eventName = formatEventName(itemName)
            muscleEvent:FireServer(eventName, tool)
        end
    end
end

local running3 = false
task.spawn(function()
    while true do
        if running3 then
            activateItems()
            task.wait(0.1)
        else
            task.wait(0.5)
        end
    end
end)

miscTab:Toggle({
    Title = "Eat All Snacks",
    Callback = function(state)
        running3 = state
        if state then
            activateItems()
        end
    end
})

miscTab:Toggle({
    Title = "Auto Spin Wheel",
    Callback = function(bool)
        _G.AutoSpinWheel = bool
        if bool then
            task.spawn(function()
                while _G.AutoSpinWheel do
                    ReplicatedStorage.rEvents.openFortuneWheelRemote:InvokeServer("openFortuneWheel", ReplicatedStorage.fortuneWheelChances["Fortune Wheel"])
                    task.wait(1)
                end
            end)
        end
    end
})

miscTab:Toggle({
    Title = "Auto Claim Gifts",
    Callback = function(bool)
        _G.AutoClaimGifts = bool
        if bool then
            task.spawn(function()
                while _G.AutoClaimGifts do
                    for i = 1, 8 do
                        ReplicatedStorage.rEvents.freeGiftClaimRemote:InvokeServer("claimGift", i)
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

-- Misc 2 Section
local misc2Folder = miscTab:Section({
Title = "Players", 
Icon = "radiation"
})

miscTab:Toggle({
    Title = "Anti Knockback",
    Callback = function(Value)
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart", 10)

        if Value then
            for _, v in pairs(rootPart:GetChildren()) do
                if v:IsA("BodyVelocity") or v:IsA("VectorForce") then
                    v:Destroy()
                end
            end

            local antiKnock = Instance.new("VectorForce")
            antiKnock.Name = "AntiKnockbackForce"
            antiKnock.Attachment0 = rootPart:FindFirstChildWhichIsA("Attachment") or Instance.new("Attachment", rootPart)
            antiKnock.Force = Vector3.zero
            antiKnock.RelativeTo = Enum.ActuatorRelativeTo.World
            antiKnock.Parent = rootPart

            task.spawn(function()
                while antiKnock.Parent == rootPart and Value do
                    local vel = rootPart.Velocity
                    if vel.Magnitude > 80 then
                        rootPart.Velocity = Vector3.zero
                    end
                    task.wait(0.05)
                end
            end)
        else
            local existing = rootPart:FindFirstChild("AntiKnockbackForce")
            if existing then
                existing:Destroy()
            end
        end
    end
})

miscTab:Toggle({
    Title = "Lock Position",
    Callback = function(state)
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        local humanoid = char:WaitForChild("Humanoid")

        _G.lockRunning = state

        if state then
            _G.LockedCFrame = hrp.CFrame
            _G.OriginalSpeed = humanoid.WalkSpeed
            _G.OriginalJump = humanoid.JumpPower
            _G.LockedChar = char

            _G.lockThread = coroutine.create(function()
                while _G.lockRunning and _G.LockedCFrame do
                    if hrp then
                        hrp.Velocity = Vector3.zero
                        hrp.RotVelocity = Vector3.zero
                        hrp.CFrame = _G.LockedCFrame
                    end
                    task.wait(0.05)
                end
            end)
            coroutine.resume(_G.lockThread)

            humanoid.Died:Connect(function()
                task.spawn(function()
                    while _G.lockRunning and _G.LockedCFrame do
                        hrp = char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.Velocity = Vector3.zero
                            hrp.CFrame = _G.LockedCFrame
                        end
                        task.wait(0.05)
                    end
                end)
            end)
        else
            _G.LockedCFrame = nil
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = _G.OriginalSpeed or 200
                humanoid.JumpPower = _G.OriginalJump or 50
                humanoid.PlatformStand = false
            end
        end
    end
})

player.CharacterAdded:Connect(function(char)
    local hrp = char:WaitForChild("HumanoidRootPart")
    local humanoid = char:WaitForChild("Humanoid")

    task.defer(function()
        if _G.lockRunning and _G.LockedCFrame then
            hrp.CFrame = _G.LockedCFrame
            task.wait(0.1)
            _G.lockThread = coroutine.create(function()
                while _G.lockRunning do
                    hrp.Velocity = Vector3.zero
                    hrp.RotVelocity = Vector3.zero
                    hrp.CFrame = _G.LockedCFrame
                    task.wait(0.05)
                end
            end)
            coroutine.resume(_G.lockThread)
        end
    end)
end)

miscTab:Toggle({
    Title = "Hide Frames",
    Callback = function(bool)
        for _, obj in pairs(ReplicatedStorage:GetChildren()) do
            if obj.Name:match("Frame$") then
                obj.Visible = not bool
            end
        end
    end
})

miscTab:Toggle({
    Title = "Hide Pets",
    Callback = function(isOn)
        local hp = player:FindFirstChild("hidePets")
        if hp then
            hp.Value = not isOn
        else
            warn("hidePets BoolValue not found!")
        end
    end
})

miscTab:Toggle({
    Title = "Unable Trade",
    Callback = function(State)
        if State then
            ReplicatedStorage.rEvents.tradingEvent:FireServer("disableTrading")
        else
            ReplicatedStorage.rEvents.tradingEvent:FireServer("enableTrading")
        end
    end
})

-- Misc 3 Section
local misc3Folder = miscTab:Section({
Title = "Misc", 
Icon = "circle-alert"
})


local godModeToggle = false
miscTab:Toggle({
    Title = "God Mode (Brawl)",
    Callback = function(State)
        godModeToggle = State
        if State then
            task.spawn(function()
                while godModeToggle do
                    ReplicatedStorage.rEvents.brawlEvent:FireServer("joinBrawl")
                    task.wait(0)
                end
            end)
        end
    end
})

local autoJoinToggle = false
miscTab:Toggle({
    Title = "Auto Join Brawl",
    Callback = function(State)
        autoJoinToggle = State
        if State then
            task.spawn(function()
                while autoJoinToggle do
                    ReplicatedStorage.rEvents.brawlEvent:FireServer("joinBrawl")
                    task.wait(2)
                end
            end)
        end
    end
})

local parts = {}
local partSize = 2048
local totalDistance = 50000
local startPosition = Vector3.new(-2, -9.5, -2)
local numberOfParts = math.ceil(totalDistance / partSize)

local function createParts()
    for x = 0, numberOfParts - 1 do
        for z = 0, numberOfParts - 1 do
            local newPartSide = Instance.new("Part")
            newPartSide.Size = Vector3.new(partSize, 1, partSize)
            newPartSide.Position = startPosition + Vector3.new(x * partSize, 0, z * partSize)
            newPartSide.Anchored = true
            newPartSide.Transparency = 1
            newPartSide.CanCollide = true
            newPartSide.Name = "Part_Side_" .. x .. "_" .. z
            newPartSide.Parent = workspace
            table.insert(parts, newPartSide)
            
            local newPartLeftRight = Instance.new("Part")
            newPartLeftRight.Size = Vector3.new(partSize, 1, partSize)
            newPartLeftRight.Position = startPosition + Vector3.new(-x * partSize, 0, z * partSize)
            newPartLeftRight.Anchored = true
            newPartLeftRight.Transparency = 1
            newPartLeftRight.CanCollide = true
            newPartLeftRight.Name = "Part_LeftRight_" .. x .. "_" .. z
            newPartLeftRight.Parent = workspace
            table.insert(parts, newPartLeftRight)
            
            local newPartUpLeft = Instance.new("Part")
            newPartUpLeft.Size = Vector3.new(partSize, 1, partSize)
            newPartUpLeft.Position = startPosition + Vector3.new(-x * partSize, 0, -z * partSize)
            newPartUpLeft.Anchored = true
            newPartUpLeft.Transparency = 1
            newPartUpLeft.CanCollide = true
            newPartUpLeft.Name = "Part_UpLeft_" .. x .. "_" .. z
            newPartUpLeft.Parent = workspace
            table.insert(parts, newPartUpLeft)
            
            local newPartUpRight = Instance.new("Part")
            newPartUpRight.Size = Vector3.new(partSize, 1, partSize)
            newPartUpRight.Position = startPosition + Vector3.new(x * partSize, 0, -z * partSize)
            newPartUpRight.Anchored = true
            newPartUpRight.Transparency = 1
            newPartUpRight.CanCollide = true
            newPartUpRight.Name = "Part_UpRight_" .. x .. "_" .. z
            newPartUpRight.Parent = workspace
            table.insert(parts, newPartUpRight)
        end
    end
end

local function makePartsWalkthrough()
    for _, part in ipairs(parts) do
        if part and part.Parent then
            part.CanCollide = false
        end
    end
end

local function makePartsSolid()
    for _, part in ipairs(parts) do
        if part and part.Parent then
            part.CanCollide = true
        end
    end
end

miscTab:Toggle({
    Title = "Walk on Water",
    Callback = function(bool)
        if bool then
            createParts()
        else
            makePartsWalkthrough()
        end
    end
})

miscTab:Toggle({
    Title = "No-Clip",
    Callback = function(bool)
        _G.NoClip = bool
        if bool then
            local noclipLoop
            noclipLoop = game:GetService("RunService").Stepped:Connect(function()
                if _G.NoClip then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                else
                    noclipLoop:Disconnect()
                end
            end)
            WindUI:Notify({Title = "No-Clip", Content = "Success Load No-Clip"})
        end
    end
})

miscTab:Toggle({
    Title = "Jump Infinite",
    Callback = function(bool)
        _G.InfiniteJump = bool
        if bool then
            local InfiniteJumpConnection
            InfiniteJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                if _G.InfiniteJump then
                    player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                else
                    InfiniteJumpConnection:Disconnect()
                end
            end)
            WindUI:Notify({Title = "Jump Infinite", Content = "Success Load Jump Infinite"})
        end
    end
})

miscTab:Dropdown({
    Title = "Change Time",
    Values = {"Night", "Day", "Midnight"},
    Callback = function(selection)
        local lighting = game:GetService("Lighting")
        if selection == "Night" then
            lighting.ClockTime = 0
        elseif selection == "Day" then
            lighting.ClockTime = 12
        elseif selection == "Midnight" then
            lighting.ClockTime = 6
        end
        WindUI:Notify({Title = "Time Changed", Content = "Time changed to: " .. selection})
    end
})

local ZorVexStatus = {}
ZorVexStatus.__index = ZorVexStatus

function ZorVexStatus.new(mainWindow)
    local self = setmetatable({}, ZorVexStatus)
    self.Window = mainWindow
    self.StatsTab = nil
    self.PlayerDropdown = nil
    self.SelectedPlayer = player
    self.PlayerOriginalStats = {}

    self:CreateStatsTab()
    self:InitPlayerStats()
    self:BuildDropdown()
    self:StartAutoRefresh()

    return self
end

function ZorVexStatus:FormatNumber(n)
    local formatted = tostring(n):reverse():gsub("(%d%d%d)", "%1,")
    if formatted:sub(-1) == "," then
        formatted = formatted:sub(1, -2)
    end
    return formatted:reverse()
end

function ZorVexStatus:InitPlayerStats()
    for _, plr in ipairs(Players:GetPlayers()) do
        self:StoreOriginalStats(plr)
    end

    Players.PlayerAdded:Connect(function(plr)
        self:StoreOriginalStats(plr)
        self:UpdateDropdown()
    end)
    Players.PlayerRemoving:Connect(function(plr)
        self.PlayerOriginalStats[plr] = nil
        self:UpdateDropdown()
    end)
end

function ZorVexStatus:StoreOriginalStats(plr)
    local statsTable = {}
    local ls = plr:FindFirstChild("leaderstats")
    if ls then
        for _, s in ipairs(ls:GetChildren()) do
            statsTable[s.Name] = s.Value or 0
        end
    end
    statsTable["Durability"] = plr:FindFirstChild("Durability") and plr.Durability.Value or 0
    statsTable["Agility"] = plr:FindFirstChild("Agility") and plr.Agility.Value or 0
    statsTable["MuscleKingTime"] = plr:FindFirstChild("MuscleKingTime") and plr.MuscleKingTime.Value or 0

    self.PlayerOriginalStats[plr] = statsTable
end

function ZorVexStatus:CreateStatsTab()
    self.StatsTab = self.Window:Tab({
        Title = "Stats",
        Icon = "trending-up"
    })
    
    -- 1. Header Stats
    self.StatsTab:Section({
        Title = "Stats",
        TextSize = 24,
        FontWeight = Enum.FontWeight.SemiBold
    })

    -- 2. Dropdown akan dibuat di BuildDropdown() - POSISI KEDUA SETELAH HEADER
    
    -- 3. Player Stats Section
    self.PlayerStatsSection = self.StatsTab:Section({
        Title = "Player Stats",
        TextSize = 18,
        TextTransparency = 0.2,
        FontWeight = Enum.FontWeight.Medium
    })

    -- 4. Gained Stats Section
    self.GainedSection = self.StatsTab:Section({
        Title = "Gained Stats",
        TextSize = 18,
        TextTransparency = 0.2,
        FontWeight = Enum.FontWeight.Medium
    })
end

function ZorVexStatus:BuildDropdown()
    local values = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        table.insert(values, {
            Title = plr.DisplayName,
            Desc = "View stats for " .. plr.DisplayName,
            Icon = "user",
            Callback = function()
                self.SelectedPlayer = plr
                WindUI:Notify({
                    Title = "Player Selected",
                    Content = plr.DisplayName .. " stats are now shown.",
                    Duration = 2,
                    Icon = "user"
                })
            end
        })
    end

    if self.PlayerDropdown then
        self.PlayerDropdown:UpdateValues(values)
    else
        -- Dropdown dibuat di sini, akan muncul SETELAH header Stats (posisi ke-2)
        self.PlayerDropdown = self.StatsTab:Dropdown({
            Title = "Select Player",
            Values = values
        })
    end
end

function ZorVexStatus:UpdateDropdown()
    self:BuildDropdown()
end

function ZorVexStatus:RefreshStats()
    if not self.SelectedPlayer or not self.SelectedPlayer.Parent then
        return
    end

    local statsText = ""
    local gainedText = ""
    local extras = {"Durability", "Agility", "MuscleKingTime"}

    local ls = self.SelectedPlayer:FindFirstChild("leaderstats")
    if ls then
        for _, stat in ipairs(ls:GetChildren()) do
            local val = stat.Value or 0
            statsText = statsText .. "> " .. stat.Name .. ": " .. self:FormatNumber(val) .. "\n"
            local orig = self.PlayerOriginalStats[self.SelectedPlayer] and
                             self.PlayerOriginalStats[self.SelectedPlayer][stat.Name] or 0
            gainedText = gainedText .. "> " .. stat.Name .. " Gained: " .. self:FormatNumber(val - orig) .. "\n"
        end
    end

    for _, name in ipairs(extras) do
        local val = self.SelectedPlayer:FindFirstChild(name) and self.SelectedPlayer[name].Value or 0
        statsText = statsText .. "> " .. name .. ": " .. self:FormatNumber(val) .. "\n"
        local orig = self.PlayerOriginalStats[self.SelectedPlayer] and
                         self.PlayerOriginalStats[self.SelectedPlayer][name] or 0
        gainedText = gainedText .. "> " .. name .. " Gained: " .. self:FormatNumber(val - orig) .. "\n"
    end

    self.PlayerStatsSection:SetTitle(statsText)
    self.GainedSection:SetTitle(gainedText)
end

function ZorVexStatus:StartAutoRefresh()
    spawn(function()
        while task.wait(0.05) do
            self:RefreshStats()
        end
    end)
end

-- Inisialisasi Stats System
local StatsSystem = ZorVexStatus.new(Window)

---------------------------------------------------------
--             SERVER TAB
---------------------------------------------------------

local serverTab = Window:Tab({Title = "Server", Icon = "server"})

local serverSection = serverTab:Section({Title = "Server", Icon = "power"})

serverTab:Toggle({
    Title = "Join Low Player",
    Callback = function(bool)
        if bool then
            local module = loadstring(game:HttpGet("https://raw.githubusercontent.com/LeoKholYt/roblox/main/lk_serverhop.lua"))()
            module:Teleport(game.PlaceId, "Lowest")
        end
    end
})

serverTab:Button({
    Title = "Rejoin Server",
    Callback = function()
        local ts = game:GetService("TeleportService")
        ts:Teleport(game.PlaceId, player)
    end
})

serverTab:Button({
    Title = "Delete Portals",
    Callback = function()
        for _, portal in pairs(game:GetDescendants()) do
            if portal.Name == "RobloxForwardPortals" then
                portal:Destroy()
            end
        end
    
        if _G.AdRemovalConnection then
            _G.AdRemovalConnection:Disconnect()
        end
        
        _G.AdRemovalConnection = game.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "RobloxForwardPortals" then
                descendant:Destroy()
            end
        end)
        
        WindUI:Notify({
            Title = "Ads Delete",
            Content = "Portal Ads Delete"
        })
    end
})

serverTab:Button({
    Title = "FPS Boost",
    Callback = function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                v.Enabled = false
            end
        end
 
        local lighting = game:GetService("Lighting")
        lighting.GlobalShadows = false
        lighting.FogEnd = 9e9
        lighting.Brightness = 0
 
        settings().Rendering.QualityLevel = 1
 
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("BasePart") and not v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
                if v.Parent and (v.Parent:FindFirstChild("Humanoid") or v.Parent.Parent:FindFirstChild("Humanoid")) then
                else
                    v.Reflectance = 0
                end
            end
        end
 
        for _, v in pairs(lighting:GetChildren()) do
            if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                v.Enabled = false
            end
        end
 
        WindUI:Notify({
            Title = "Boost",
            Content = "Done Booster FPS"
        })
    end
})

-- Notify loaded
WindUI:Notify({
    Title = "ZorVex Hub Loaded",
    Content = "Halo " .. player.DisplayName .. " Vip Features Done",
    Duration = 5
})