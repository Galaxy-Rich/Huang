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

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UIBUTTON"
ScreenGui.Parent = game.CoreGui
ScreenGui.IgnoreGuiInset = true 

local ImgBtn = Instance.new("ImageButton")
ImgBtn.Parent = ScreenGui
ImgBtn.Size = UDim2.new(0, 70, 0, 70)
ImgBtn.AnchorPoint = Vector2.new(1, 0) 
ImgBtn.Position = UDim2.new(0.9, -20, 0, 50) 
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

local a = game:GetService("ReplicatedStorage")
local b = game:GetService("Players")
local c = b.LocalPlayer

do
    Window:Tag({
        Title = "--> VIP Rebirth <--",
        Color = Color3.fromHex("#000000")
    })
end

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

local VIP_Tab = Window:Tab({
Title = "Strength",
Icon = "chevrons-left-right-ellipsis"})

local VIP_SET = VIP_Tab:Section({
Title = "Settings",
Icon = "sliders-horizontal"})

local sizeValue = 1

VIP_Tab:Input({
    Title = "Set Size",
    Placeholder = "Enter Your Size",
    Callback = function(text)
        local num = tonumber(text)
        if num then
            sizeValue = num
        end
    end
})

VIP_Tab:Toggle({
    Title = "Auto Size",
    Callback = function(bool)
        _G.autoSizeActive = bool
        if bool then
            task.spawn(function()
                while _G.autoSizeActive and task.wait() do
                    game:GetService("ReplicatedStorage").rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", sizeValue)
                end
            end)
        end
    end
})

VIP_Tab:Toggle({
    Title = "Anti-AFK",
    Callback = function(state)
        if state then
            local VirtualUser = game:GetService("VirtualUser")

            _G.afkGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
            _G.afkGui.Name = "AntiAFKGui"
            _G.afkGui.ResetOnSpawn = false

            local timer = Instance.new("TextLabel", _G.afkGui)
            timer.Size = UDim2.new(0, 200, 0, 30)
            timer.Position = UDim2.new(1, -210, 0, 20)
            timer.Text = "0:00:00"
            timer.TextColor3 = Color3.fromRGB(255, 255, 255)
            timer.Font = Enum.Font.GothamBold
            timer.TextSize = 25
            timer.BackgroundTransparency = 1
            timer.TextTransparency = 0
            
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

local Strength = VIP_Tab:Section({
Title = "Fast Strength",
Icon = "skull"})

VIP_Tab:Input({
    Title = "Set Repetition",
    Placeholder = "Set Fast Strength",
    Callback = function(text)
        local num = tonumber(text)
        if num then
            repCount = num
        end
    end
})

VIP_Tab:Toggle({
    Title = "Push Strength",
    Callback = function(l)
        getgenv().PushStrengthEnabled = l
        
        if l then
            local k = function(petName)
                for _, n in pairs(c.petsFolder.Unique:GetChildren()) do
                    if n.Name == petName then
                        a.rEvents.equipPetEvent:FireServer("equipPet", n)
                    end
                end
            end
            
            task.spawn(function()
                while getgenv().PushStrengthEnabled do
                    k("Swift Samurai")
                    for y = 1, repCount do
                        if not getgenv().PushStrengthEnabled then break end
                        c.muscleEvent:FireServer("rep")
                    end
                    task.wait()
                end
            end)
        end
    end
})


VIP_Tab:Button({
    Title = "Delete Frames",
    Callback = function()
        for _, obj in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
            if obj.Name:match("Frame$") then
                obj:Destroy()
            end
        end
        WindUI:Notify({Title = "Success", Content = "Frame Delete 100% Fps Boost"})
    end
})

local VIP_ONLYYY11 = VIP_Tab:Section({
Title = "Emote VIP",
Icon = "sparkles"})

local emoteList = {
    ["Godlike Emote"] = 106493972274585,
    ["Old Town Road"] = 3390820390,
    ["Applaud"] = 507768388,
    ["Hello"] = 3583743333
}

local selectedEmoteName = "Godlike Emote"

local targetDropdown = VIP_Tab:Dropdown({
    Title = "Select Emote",
    Values = {"Godlike Emote", "Old Town Road", "Applaud", "Hello"},
    Callback = function(value)
        selectedEmoteName = value
    end
})

VIP_Tab:Button({
    Title = "Emote VIP",
    Callback = function()
        local emoteId = emoteList[selectedEmoteName]
        
        WindUI:Notify({
            Title = "Emote Started", 
            Content = "Playing: " .. selectedEmoteName
        })

        local player = game.Players.LocalPlayer
        local character = player.Character
        if not character then return end

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local desc = humanoid and humanoid:FindFirstChildOfClass("HumanoidDescription")

        if humanoid and desc then
            desc:SetEmotes({
                [selectedEmoteName] = {emoteId}
            })

            local function forcePlayEmote(name)
                local animator = humanoid:FindFirstChildOfClass("Animator")
                
                if animator then
                    for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                        track:Stop(0.1)
                    end
                end

                local success, err = pcall(function()
                    humanoid:PlayEmote(name)
                end)

                if success then
                    task.defer(function()
                        if animator then
                            for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                                track.Priority = Enum.AnimationPriority.Action4
                                track.Looped = true
                            end
                        end
                    end)
                end
            end

            forcePlayEmote(selectedEmoteName)
        end
    end
})

local VIP_ONLYY = VIP_Tab:Section({
Title = "Only VIP",
Icon = "gem"})

local function activateProteinEgg()
    local character = player.Character
    if not character then return end
    
    local tool = character:FindFirstChild("Protein Egg") or player.Backpack:FindFirstChild("Protein Egg")
    
    if tool and c.muscleEvent then
        c.muscleEvent:FireServer("proteinEgg", tool)
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

VIP_Tab:Toggle({
    Title = "Auto Eat Egg | 30mins",
    Desc = " Get 2x Strength | 30 Minute",
    Callback = function(state)
        running = state
        if state then
            activateProteinEgg()
        end
    end
})

VIP_Tab:Button({
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

local positions = {
    Zone1 = CFrame.new(7.37152624, 181.829956, -1163.31775, -0.999853373, -1.50258028e-08, 0.0171243865, -1.68823515e-08, 1, -1.0827096e-07, -0.0171243865, -1.08544178e-07, -0.999853373),
    Zone2 = CFrame.new(0, 0, 0)
}

-- Satu Loop Utama untuk semua teleport (Lebih Hemat Performa)
task.spawn(function()
    while true do
        if currentTarget then
            pcall(function() -- Menggunakan pcall agar script tidak mati jika karakter mati
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    -- Cek jika jarak lebih dari 5 unit dari target
                    if (hrp.Position - currentTarget.Position).Magnitude > 1 then
                        hrp.CFrame = currentTarget
                    end
                end
            end)
        end
        task.wait(0.01) -- 0.1 sudah cukup cepat dan tidak bikin lag
    end
end)

VIP_Tab:Toggle({
    Title = "VIP Mode",
    Callback = function(enabled)
        currentTarget = enabled and positions.Zone1 or nil
    end
})

VIP_Tab:Toggle({
    Title = "Save Mode",
    Callback = function(enabled)
        currentTarget = enabled and positions.Zone2 or nil
    end
})


local VIP_Tab1 = Window:Tab({
Title = "Rebirth",
Icon = "repeat"})

local VIP_SET = VIP_Tab1:Section({
Title = "Settings",
Icon = "sliders-horizontal"})

local sizeValue = 1

VIP_Tab1:Input({
    Title = "Set Size",
    Placeholder = "Enter Your Size",
    Callback = function(text)
        local num = tonumber(text)
        if num then
            sizeValue = num
        end
    end
})

VIP_Tab1:Toggle({
    Title = "Auto Size",
    Callback = function(bool)
        _G.autoSizeActive = bool
        if bool then
            task.spawn(function()
                while _G.autoSizeActive and task.wait() do
                    game:GetService("ReplicatedStorage").rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", sizeValue)
                end
            end)
        end
    end
})

VIP_Tab1:Toggle({
    Title = "Anti-AFK",
    Callback = function(state)
        if state then
            local VirtualUser = game:GetService("VirtualUser")

            _G.afkGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
            _G.afkGui.Name = "AntiAFKGui"
            _G.afkGui.ResetOnSpawn = false

            local timer = Instance.new("TextLabel", _G.afkGui)
            timer.Size = UDim2.new(0, 200, 0, 30)
            timer.Position = UDim2.new(1, -210, 0, 20)
            timer.Text = "0:00:00"
            timer.TextColor3 = Color3.fromRGB(255, 255, 255)
            timer.Font = Enum.Font.GothamBold
            timer.TextSize = 25
            timer.BackgroundTransparency = 1
            timer.TextTransparency = 0
            
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

local VIP_ONLY = VIP_Tab1:Section({
Title = "Fast Rebirth",
Icon = "skull"})

VIP_Tab1:Toggle({
    Title = "Auto Farm Rebirth",
    Callback = function(state)
        getgenv().IsAutoFarming = state

        if state then
            
            local d = function()
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

            local k = function(l)
                d()
                task.wait(.01)
                for m, n in pairs(c.petsFolder.Unique:GetChildren()) do
                    if n.Name == l then
                        a.rEvents.equipPetEvent:FireServer("equipPet", n)
                    end
                end
            end

            autoFarmThread = task.spawn(function()
                while getgenv().IsAutoFarming do
                    local v = c.leaderstats.Rebirths.Value
                    local w = 10000 + (5000 * v)
                    if c.ultimatesFolder:FindFirstChild("Golden Rebirth") then
                        local x = c.ultimatesFolder["Golden Rebirth"].Value
                        w = math.floor(w * (1 - (x * 0.1)))
                    end
                    
                    d()
                    task.wait(.1)
                    k("Swift Samurai")
                    while c.leaderstats.Strength.Value < w and getgenv().IsAutoFarming do
                        for y = 1, 15 do
                            c.muscleEvent:FireServer("rep")
                        end
                        task.wait()
                    end
                    
                    if not getgenv().IsAutoFarming then break end

                    d()
                    task.wait(.1)
                    k("Tribal Overlord")
                    local A = c.leaderstats.Rebirths.Value
                    repeat
                        a.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                        task.wait(.1)
                        if not getgenv().IsAutoFarming then break end
                    until c.leaderstats.Rebirths.Value > A

                    task.wait()
                end
            end)
        else
            if autoFarmThread and task.cancel then
                task.cancel(autoFarmThread)
                autoFarmThread = nil
            end
        end
    end
})

local circleConnection = nil
local visualParts = {}
local characterAddedConn = nil

VIP_Tab1:Toggle({
    Title = "VIP Mode",
    Callback = function(state)
        _G.AutoSizeEnabled = state

        if _G.AutoSizeEnabled then
            local player = game.Players.LocalPlayer
            local startCFrame = CFrame.new(-0.00503921509, 546.549805, 0.00447463989, 0.995843053, -1.7234008e-08, 0.09108603, 1.22618156e-08, 1, 5.5147467e-08, -0.09108603, -5.38013403e-08, 0.995843053)
            local radius = 1100
            local speed = 1.2      
            local angle = 0        
            local centerPoint = startCFrame.Position 
            local emoteList = {["Godlike Emote"] = 106493972274585}
            local selectedEmoteName = "Godlike Emote"
            local emoteId = emoteList[selectedEmoteName]

            local function drawCircle()
                local segments = 8
                for i = 1, segments do
                    local segmentAngle = (i / segments) * math.pi * 2
                    local x = math.cos(segmentAngle) * radius
                    local z = math.sin(segmentAngle) * radius
                    local dot = Instance.new("Part")
                    dot.Size = Vector3.new(2, 0.1, 5) 
                    dot.Position = centerPoint + Vector3.new(x, -2.8, z) 
                    dot.Anchored = true
                    dot.CanCollide = false
                    dot.BrickColor = BrickColor.new("Cyan") 
                    dot.Material = Enum.Material.Neon
                    dot.Transparency = 0.6
                    dot.CFrame = CFrame.lookAt(dot.Position, Vector3.new(centerPoint.X, dot.Position.Y, centerPoint.Z))
                    dot.Parent = workspace
                    table.insert(visualParts, dot)
                end
            end

            local function runLogic(character)
                local humanoid = character:WaitForChild("Humanoid")
                local rootPart = character:WaitForChild("HumanoidRootPart")
                rootPart.CFrame = startCFrame
                task.wait(1)
                
                local desc = humanoid:FindFirstChildOfClass("HumanoidDescription") or Instance.new("HumanoidDescription", humanoid)
                desc:SetEmotes({[selectedEmoteName] = {emoteId}})
                local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
                
                for _, track in pairs(animator:GetPlayingAnimationTracks()) do track:Stop(0.1) end
                
                pcall(function() humanoid:PlayEmote(selectedEmoteName) end)
                task.defer(function()
                    task.wait(0.1)
                    for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                        track.Priority = Enum.AnimationPriority.Action4
                        track.Looped = true
                    end
                end)

                task.wait(1.2)
                local weightItem = player.Backpack:FindFirstChild("Weight")
                if weightItem then
                    if weightItem:FindFirstChild("repTime") then weightItem.repTime.Value = 0 end
                    humanoid:EquipTool(weightItem)
                end
            end

            drawCircle()
            
            if player.Character then task.spawn(runLogic, player.Character) end
            characterAddedConn = player.CharacterAdded:Connect(runLogic)

            circleConnection = game:GetService("RunService").Heartbeat:Connect(function(dt)
                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    angle = angle + (speed * dt)
                    local x = math.cos(angle) * radius
                    local z = math.sin(angle) * radius
                    local newPosition = centerPoint + Vector3.new(x, 0, z)
                    local lookAheadAngle = angle + 0.1
                    local lookAtPosition = centerPoint + Vector3.new(math.cos(lookAheadAngle) * radius, 0, math.sin(lookAheadAngle) * radius)
                    character.HumanoidRootPart.CFrame = CFrame.lookAt(newPosition, lookAtPosition)
                end
            end)

        else
            if circleConnection then circleConnection:Disconnect() circleConnection = nil end
            if characterAddedConn then characterAddedConn:Disconnect() characterAddedConn = nil end
            for _, part in pairs(visualParts) do if part then part:Destroy() end end
            visualParts = {}
            
            local player = game.Players.LocalPlayer
            if player.Character then
                local tool = player.Character:FindFirstChildOfClass("Tool")
                if tool then tool.Parent = player.Backpack end
            end
        end
    end
})

VIP_Tab1:Button({
    Title = "Delete Frames",
    Callback = function()
        for _, obj in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
            if obj.Name:match("Frame$") then
                obj:Destroy()
            end
        end
        WindUI:Notify({Title = "Success", Content = "Frame Delete 100% Fps Boost"})
    end
})

local VIP_ONLYYY = VIP_Tab1:Section({
Title = "Emote VIP",
Icon = "sparkles"})

local emoteList = {
    ["Godlike Emote"] = 3823158750,
    ["Old Town Road"] = 3390820390,
    ["Applaud"] = 507768388,
    ["Hello"] = 3583743333
}

local selectedEmoteName = "Godlike Emote"

local targetDropdown = VIP_Tab1:Dropdown({
    Title = "Select Emote",
    Values = {"Godlike Emote", "Old Town Road", "Applaud", "Hello"},
    Callback = function(value)
        selectedEmoteName = value
    end
})

VIP_Tab1:Button({
    Title = "Emote VIP",
    Callback = function()
        local emoteId = emoteList[selectedEmoteName]
        
        WindUI:Notify({
            Title = "Emote Started", 
            Content = "Playing: " .. selectedEmoteName
        })

        local player = game.Players.LocalPlayer
        local character = player.Character
        if not character then return end

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local desc = humanoid and humanoid:FindFirstChildOfClass("HumanoidDescription")

        if humanoid and desc then
            desc:SetEmotes({
                [selectedEmoteName] = {emoteId}
            })

            local function forcePlayEmote(name)
                local animator = humanoid:FindFirstChildOfClass("Animator")
                
                if animator then
                    for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                        track:Stop(0.1)
                    end
                end

                local success, err = pcall(function()
                    humanoid:PlayEmote(name)
                end)

                if success then
                    task.defer(function()
                        if animator then
                            for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                                track.Priority = Enum.AnimationPriority.Action4
                                track.Looped = true
                            end
                        end
                    end)
                end
            end

            forcePlayEmote(selectedEmoteName)
        end
    end
})

local VIP_ONLYYY33 = VIP_Tab1:Section({
Title = "Only VIP",
Icon = "gem"})

local function activateProteinEgg()
    local character = player.Character
    if not character then return end
    
    local tool = character:FindFirstChild("Protein Egg") or player.Backpack:FindFirstChild("Protein Egg")
    
    if tool and c.muscleEvent then
        c.muscleEvent:FireServer("proteinEgg", tool)
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

VIP_Tab1:Toggle({
    Title = "Auto Eat Egg | 30mins",
    Desc = " Get 2x Strength | 30 Minute",
    Callback = function(state)
        running = state
        if state then
            activateProteinEgg()
        end
    end
})

VIP_Tab1:Button({
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

local positions = {
    Zone1 = CFrame.new(0, 0, 0),
    Zone2 = CFrame.new(0, 0, 0)
}

-- Satu Loop Utama untuk semua teleport (Lebih Hemat Performa)
task.spawn(function()
    while true do
        if currentTarget then
            pcall(function() -- Menggunakan pcall agar script tidak mati jika karakter mati
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    -- Cek jika jarak lebih dari 5 unit dari target
                    if (hrp.Position - currentTarget.Position).Magnitude > 1 then
                        hrp.CFrame = currentTarget
                    end
                end
            end)
        end
        task.wait(0.01) -- 0.1 sudah cukup cepat dan tidak bikin lag
    end
end)

VIP_Tab1:Toggle({
    Title = "VIP Mode",
    Callback = function(enabled)
        currentTarget = enabled and positions.Zone1 or nil
    end
})

VIP_Tab1:Toggle({
    Title = "Save Mode",
    Callback = function(enabled)
        currentTarget = enabled and positions.Zone2 or nil
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

    -- LABEL DENGAN ADJUSTMENT SPASI (Disesuaikan agar visualnya rata)
    self.StatLayout = {
        {Name = "Strength",       Label = "Strength              "},
        {Name = "Rebirth",        Label = "Rebirth                 "},
        {Name = "Kills",          Label = "Kills                       "},
        {Name = "Brawls",         Label = "Brawls                  "},
        {Name = "Durability",     Label = "Durability             "},
        {Name = "Agility",        Label = "Agility                   "}
    }

    -- URUTAN PEMBUATAN UI
    self:CreateStatsTab()       -- 1. Tab & Header
    self:BuildDropdown()        -- 2. Dropdown (Paling Atas)
    self:CreateStatSections()   -- 3. Area Teks

    self:InitPlayerStats()
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

function ZorVexStatus:StoreOriginalStats(plr)
    local statsTable = {}
    local ls = plr:FindFirstChild("leaderstats")
    
    for _, config in ipairs(self.StatLayout) do
        local name = config.Name
        local val = 0
        local found = (ls and ls:FindFirstChild(name)) or plr:FindFirstChild(name)
        
        if found then
            val = found.Value
        end
        statsTable[name] = val
    end
    
    self.PlayerOriginalStats[plr] = statsTable
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
        if self.SelectedPlayer == plr then
            self.SelectedPlayer = player
        end
        self:UpdateDropdown()
    end)
end

function ZorVexStatus:CreateStatsTab()
    self.StatsTab = self.Window:Tab({
        Title = "Stats",
        Icon = "trending-up"
    })
    
    self.StatsTab:Section({
        Title = "Stats Player",
        TextSize = 22,
        FontWeight = Enum.FontWeight.SemiBold
    })
end

function ZorVexStatus:BuildDropdown()
    local function getDropdownValues()
        local values = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            table.insert(values, {
                Title = plr.DisplayName,
                Desc = "@" .. plr.Name,
                Icon = "user",
                Callback = function()
                    self.SelectedPlayer = plr
                end
            })
        end
        return values
    end

    if self.PlayerDropdown then
        self.PlayerDropdown:UpdateValues(getDropdownValues())
    else
        self.PlayerDropdown = self.StatsTab:Dropdown({
            Title = "Select Stats Playert",
            Values = getDropdownValues()
        })
    end
end

function ZorVexStatus:CreateStatSections()
    self.PlayerStatsSection = self.StatsTab:Section({
        Title = "Current Stats",
        TextSize = 17,
        FontWeight = Enum.FontWeight.Medium
    })

    self.GainedSection = self.StatsTab:Section({
        Title = "Total Gained",
        TextSize = 17,
        FontWeight = Enum.FontWeight.Medium
    })
end

function ZorVexStatus:UpdateDropdown()
    self:BuildDropdown()
end

function ZorVexStatus:RefreshStats()
    if not self.SelectedPlayer or not self.SelectedPlayer.Parent then
        self.SelectedPlayer = player
        return
    end

    local statsText = ""
    local gainedText = ""
    local ls = self.SelectedPlayer:FindFirstChild("leaderstats")

    for _, config in ipairs(self.StatLayout) do
        local name = config.Name
        local label = config.Label
        
        local statObj = (ls and ls:FindFirstChild(name)) or self.SelectedPlayer:FindFirstChild(name)
        local currentVal = statObj and statObj.Value or 0
        
        local originalVal = (self.PlayerOriginalStats[self.SelectedPlayer] and self.PlayerOriginalStats[self.SelectedPlayer][name]) or currentVal
        local gainedVal = currentVal - originalVal

        -- Menggabungkan Label dan Nilai dengan Titik Dua yang disejajarkan
        statsText = statsText .. label .. " :    " .. self:FormatNumber(currentVal) .. "\n"
        gainedText = gainedText .. label .. " :    " .. self:FormatNumber(gainedVal) .. "\n"
    end

    self.PlayerStatsSection:SetTitle(statsText)
    self.GainedSection:SetTitle(gainedText)
end

function ZorVexStatus:StartAutoRefresh()
    task.spawn(function()
        while task.wait(0.1) do
            self:RefreshStats()
        end
    end)
end

-- Inisialisasi Utama
local StatsSystem = ZorVexStatus.new(Window)

local VIP_TP = Window:Tab({
Title = "Teleport Portal",
Icon = "map-pinned"})

local VIP_TP1 = VIP_TP:Section({
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
    VIP_TP:Button({
        Title = location[1],
        Callback = function()
            safeTeleport(location[2])
        end
    })
end

player.CharacterAdded:Connect(function()
    task.wait(1)
end)
