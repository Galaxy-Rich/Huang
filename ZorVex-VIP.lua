local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local NOTIFICATION_DURATION = 3 

-- URL PASTEBIN
local URL_ZORVEX = "https://pastebin.com/raw/N89CEe6M"

local function getYourHWID()
    if gethwid and type(gethwid) == "function" then return gethwid() end
    if delta and delta.gethwid and type(delta.gethwid) == "function" then return delta.gethwid() end
    if synapse and synapse.gethwid and type(synapse.gethwid) == "function" then return synapse.gethwid() end
    return nil
end

local function checkWhitelist(url)
    local currentHWID = getYourHWID()
    if not currentHWID then return false end

    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if success and response and string.find(response, currentHWID) then
        return true
    end
    return false
end

local function displayNotification(message, isError)
    if CoreGui:FindFirstChild("FullScreenNotification") then
        CoreGui.FullScreenNotification:Destroy()
    end

    local sg = Instance.new("ScreenGui", CoreGui)
    sg.Name = "FullScreenNotification"
    sg.IgnoreGuiInset = true 
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Global 

    local bg = Instance.new("TextLabel", sg)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundTransparency = 1 
    bg.TextScaled = true 
    bg.Font = Enum.Font.GothamBlack
    
    -- MODIFIKASI WARNA DI SINI --
    -- Jika Error = Merah, Jika Sukses = Putih (255, 255, 255)
    bg.TextColor3 = isError and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)
    
    -- Menambahkan Outline Hitam agar teks putih terlihat jelas
    bg.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    bg.TextStrokeTransparency = 0 -- 0 berarti solid (tidak transparan)
    ------------------------------

    local padding = Instance.new("UIPadding", bg)
    padding.PaddingLeft = UDim.new(0.1, 0)
    padding.PaddingRight = UDim.new(0.1, 0)

    task.spawn(function()
        for i = 1, #message do
            bg.Text = string.sub(message, 1, i)
            task.wait(0.05)
        end
        task.wait(NOTIFICATION_DURATION) 
        local fade = TweenService:Create(bg, TweenInfo.new(0.8), {TextTransparency = 1, TextStrokeTransparency = 1})
        fade:Play()
        fade.Completed:Connect(function() sg:Destroy() end)
    end)
end

--- LOGIKA EKSEKUSI ---

local isZorVex = checkWhitelist(URL_ZORVEX)

if isZorVex then
    displayNotification("ZorVex Detected\nScript Active", false)
    
    task.wait(2)
    
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Galaxy-Rich/Huang/refs/heads/main/Script%20By%20ZorVex.lua'))()
    print("Menjalankan Script ZorVex...")
    
else
    -- Jika tidak terdaftar (Teks akan berwarna Merah)
    displayNotification("Not Vz\nScript Not Active", true)
    warn("HWID tidak terdaftar di database manapun.")
end
