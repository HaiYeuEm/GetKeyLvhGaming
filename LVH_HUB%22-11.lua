-- ============================================================
--                 KEY SYSTEM - BẢN QUYỀN
--       Kiểm tra key từ GitHub, load script theo game ID
-- ============================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

if not player then return end

-- ============================================================
--  CẤU HÌNH (SỬA THEO BẠN)
-- ============================================================

-- URL raw của file KeyList.lua trên GitHub (chỉ chứa danh sách key)
local GITHUB_KEYLIST_URL = "https://raw.githubusercontent.com/levanhai797130-ops/GetKeyLvhGaming/refs/heads/main/KeyList.Lua"

-- Định nghĩa script cho từng game (dùng game.PlaceId)
local GAME_SCRIPTS = {
    [-10959918411] = "loadstring(game:HttpGet('https://your-script-for-studio.lua'))()",   -- Game Studio Lite
    [-107778070777162] = "loadstring(game:HttpGet('https://your-script-for-egg.lua'))()",  -- Steal a Egg
}

-- Script dùng khi game không có trong danh sách (tùy chọn)
local FALLBACK_SCRIPT = "print('Game không được hỗ trợ. Liên hệ admin.')"

-- ============================================================
--  TẠO GIAO DIỆN (KHÔNG THAY ĐỔI)
-- ============================================================

local gui = Instance.new("ScreenGui")
gui.Name = "KeySystem"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local function roundCorner(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = obj
    return corner
end

local function addStroke(obj, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(0, 212, 255)
    stroke.Thickness = thickness or 2
    stroke.Transparency = transparency or 0.3
    stroke.Parent = obj
    return stroke
end

local function addPressEffect(btn)
    local scale = Instance.new("UIScale")
    scale.Parent = btn
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(scale, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {Scale = 0.92}):Play()
    end)
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(scale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if scale.Scale ~= 1 then
            TweenService:Create(scale, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Scale = 1}):Play()
        end
    end)
    return scale
end

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 300)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui
roundCorner(mainFrame, 18)
addStroke(mainFrame, Color3.fromRGB(0, 212, 255), 2.5, 0.25)

local gradient = Instance.new("UIGradient")
gradient.Rotation = 45
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 15))
})
gradient.Parent = mainFrame

local glow = Instance.new("Frame")
glow.Size = UDim2.new(1.2, 0, 1.2, 0)
glow.Position = UDim2.new(-0.1, 0, -0.1, 0)
glow.BackgroundColor3 = Color3.fromRGB(0, 212, 255)
glow.BackgroundTransparency = 0.95
glow.BorderSizePixel = 0
glow.Parent = mainFrame
roundCorner(glow, 30)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "🔑  KEY SYSTEM  🔑"
title.TextColor3 = Color3.fromRGB(0, 212, 255)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = mainFrame

local subTitle = Instance.new("TextLabel")
subTitle.Size = UDim2.new(1, 0, 0, 20)
subTitle.Position = UDim2.new(0, 0, 0, 48)
subTitle.BackgroundTransparency = 1
subTitle.Text = "Nhập key để kích hoạt script"
subTitle.TextColor3 = Color3.fromRGB(180, 180, 200)
subTitle.TextSize = 13
subTitle.Font = Enum.Font.GothamMedium
subTitle.TextXAlignment = Enum.TextXAlignment.Center
subTitle.Parent = mainFrame

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0.8, 0, 0, 42)
keyBox.Position = UDim2.new(0.1, 0, 0.33, 0)
keyBox.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
keyBox.BackgroundTransparency = 0.3
keyBox.BorderSizePixel = 0
keyBox.Text = ""
keyBox.PlaceholderText = "Nhập key vào đây..."
keyBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 180)
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.TextSize = 16
keyBox.Font = Enum.Font.GothamMedium
keyBox.Parent = mainFrame
roundCorner(keyBox, 12)
addStroke(keyBox, Color3.fromRGB(0, 212, 255), 1.5, 0.35)

local activateBtn = Instance.new("TextButton")
activateBtn.Size = UDim2.new(0.45, 0, 0, 42)
activateBtn.Position = UDim2.new(0.275, 0, 0.6, 0)
activateBtn.BackgroundColor3 = Color3.fromRGB(0, 212, 255)
activateBtn.BackgroundTransparency = 0.25
activateBtn.BorderSizePixel = 0
activateBtn.Text = "▶  KÍCH HOẠT"
activateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
activateBtn.TextSize = 16
activateBtn.Font = Enum.Font.GothamBold
activateBtn.Parent = mainFrame
roundCorner(activateBtn, 12)
addStroke(activateBtn, Color3.fromRGB(0, 212, 255), 1.5, 0.4)

local actScale = addPressEffect(activateBtn)

activateBtn.MouseEnter:Connect(function()
    TweenService:Create(activateBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(activateBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(0, 0, 0)}):Play()
    TweenService:Create(activateBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 255, 200)}):Play()
end)
activateBtn.MouseLeave:Connect(function()
    TweenService:Create(activateBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.25}):Play()
    TweenService:Create(activateBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    TweenService:Create(activateBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 212, 255)}):Play()
end)

local getKeyBtn = Instance.new("TextButton")
getKeyBtn.Size = UDim2.new(0.35, 0, 0, 28)
getKeyBtn.Position = UDim2.new(0.325, 0, 0.82, 0)
getKeyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
getKeyBtn.BackgroundTransparency = 0.3
getKeyBtn.BorderSizePixel = 0
getKeyBtn.Text = "🔑  LẤY KEY"
getKeyBtn.TextColor3 = Color3.fromRGB(180, 180, 210)
getKeyBtn.TextSize = 13
getKeyBtn.Font = Enum.Font.GothamMedium
getKeyBtn.Parent = mainFrame
roundCorner(getKeyBtn, 10)
addStroke(getKeyBtn, Color3.fromRGB(0, 212, 255), 1.5, 0.35)

local getScale = addPressEffect(getKeyBtn)

getKeyBtn.MouseEnter:Connect(function()
    TweenService:Create(getKeyBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(getKeyBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)
getKeyBtn.MouseLeave:Connect(function()
    TweenService:Create(getKeyBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play()
    TweenService:Create(getKeyBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(180, 180, 210)}):Play()
end)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 24)
statusLabel.Position = UDim2.new(0, 0, 0.92, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "🔑 Nhập key để kích hoạt"
statusLabel.TextColor3 = Color3.fromRGB(0, 212, 255)
statusLabel.TextSize = 13
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.TextYAlignment = Enum.TextYAlignment.Top
statusLabel.Parent = mainFrame

-- ============================================================
--  LOGIC XỬ LÝ KEY VÀ LOAD SCRIPT
-- ============================================================

local scriptActivated = false
local cachedKeyList = nil

-- Hàm lấy danh sách key từ GitHub
local function fetchKeyList()
    if cachedKeyList then return cachedKeyList end
    local success, result = pcall(function()
        return game:HttpGet(GITHUB_KEYLIST_URL)
    end)
    if not success or not result then
        warn("❌ Không thể tải KeyList từ GitHub")
        return nil
    end
    local func, err = loadstring(result)
    if not func then
        warn("❌ Lỗi parse KeyList: " .. tostring(err))
        return nil
    end
    local data = func()
    if type(data) ~= "table" then
        warn("❌ KeyList không đúng định dạng (phải là table)")
        return nil
    end
    cachedKeyList = data
    return data
end

-- Kiểm tra key có tồn tại trong danh sách không (không cần gameId)
local function isValidKey(inputKey)
    local keyData = fetchKeyList()
    if not keyData then return false end
    return keyData[inputKey] ~= nil
end

-- Hủy giao diện với hiệu ứng
local function destroyUI()
    TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
    TweenService:Create(title, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
    TweenService:Create(subTitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
    TweenService:Create(keyBox, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
    TweenService:Create(activateBtn, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
    TweenService:Create(getKeyBtn, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
    TweenService:Create(statusLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
    task.wait(0.6)
    gui:Destroy()
end

-- Load script dựa trên game ID
local function runMainScript()
    if scriptActivated then return false end
    scriptActivated = true

    print("✅ KEY HỢP LỆ! Đang load script cho game này...")
    statusLabel.Text = "⏳ Đang tải script..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)

    local currentGameId = game.PlaceId
    local scriptCode = GAME_SCRIPTS[currentGameId] or FALLBACK_SCRIPT

    -- Kiểm tra nếu game không được hỗ trợ
    if scriptCode == FALLBACK_SCRIPT then
        warn("⚠️ Game chưa được hỗ trợ, ID: " .. tostring(currentGameId))
        statusLabel.Text = "❌ Game này chưa được hỗ trợ"
        statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        scriptActivated = false
        return false
    end

    local success, err = pcall(function()
        loadstring(scriptCode)()
    end)

    if not success then
        warn("❌ Lỗi tải script: " .. tostring(err))
        statusLabel.Text = "❌ Lỗi tải script! Thử lại sau."
        statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        scriptActivated = false
        return false
    end

    -- Thành công
    statusLabel.Text = "✅ Đã kích hoạt thành công! Chúc bạn chơi vui ❤️"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    activateBtn.Text = "✅ ĐÃ KÍCH HOẠT"
    activateBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    activateBtn.BackgroundTransparency = 0.1
    activateBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    getKeyBtn.Visible = false
    keyBox.Visible = false
    subTitle.Text = "Script đã được kích hoạt!"
    mainFrame.BackgroundColor3 = Color3.fromRGB(0, 20, 0)
    addStroke(mainFrame, Color3.fromRGB(0, 255, 100), 2.5, 0.25)

    task.wait(1.2)
    destroyUI()
    return true
end

-- ============================================================
--  SỰ KIỆN NÚT BẤM
-- ============================================================

activateBtn.MouseButton1Click:Connect(function()
    local enteredKey = keyBox.Text
    if enteredKey == "" then
        statusLabel.Text = "⚠️ Vui lòng nhập key!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        return
    end
    if isValidKey(enteredKey) then
        runMainScript()
    else
        statusLabel.Text = "❌ Key không hợp lệ"
        statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        -- Lắc hộp key
        local originalPos = keyBox.Position
        for i = 1, 5 do
            keyBox.Position = UDim2.new(0.1, math.random(-5, 5), 0.33, 0)
            task.wait(0.05)
        end
        keyBox.Position = originalPos
    end
end)

keyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local enteredKey = keyBox.Text
        if enteredKey == "" then
            statusLabel.Text = "⚠️ Vui lòng nhập key!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            return
        end
        if isValidKey(enteredKey) then
            runMainScript()
        else
            statusLabel.Text = "❌ Key không hợp lệ"
            statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            local originalPos = keyBox.Position
            for i = 1, 5 do
                keyBox.Position = UDim2.new(0.1, math.random(-5, 5), 0.33, 0)
                task.wait(0.05)
            end
            keyBox.Position = originalPos
        end
    end
end)

getKeyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard("Hãy liên hệ admin để lấy key hợp lệ")
        statusLabel.Text = "📋 Đã copy thông báo vào clipboard!"
        statusLabel.TextColor3 = Color3.fromRGB(0, 212, 255)
    else
        statusLabel.Text = "🔑 Vui lòng liên hệ admin để lấy key"
    end
    TweenService:Create(statusLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    task.wait(0.3)
    TweenService:Create(statusLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(0, 212, 255)}):Play()
end)

-- Phím tắt Ctrl+C copy thông báo
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.C and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        if setclipboard then
            setclipboard("Hãy liên hệ admin để lấy key hợp lệ")
            statusLabel.Text = "📋 Đã copy thông báo vào clipboard!"
            statusLabel.TextColor3 = Color3.fromRGB(0, 212, 255)
        end
    end
end)

print("🔑 Hệ thống Key đã sẵn sàng!")
statusLabel.Text = "🔑 Nhập key của bạn"
