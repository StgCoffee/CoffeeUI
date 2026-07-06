local CoffeeUI = {}

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Не работаем в студии
if RunService:IsStudio() then return end

local Parent = CoreGui
if gethui then Parent = gethui() elseif set_thread_identity then set_thread_identity(8) end

local colors = {
    Bg = Color3.fromRGB(240, 240, 245),
    Side = Color3.fromRGB(230, 230, 235),
    Top = Color3.fromRGB(230, 230, 235),
    Stroke = Color3.fromRGB(180, 180, 185),
    T1 = Color3.fromRGB(20, 20, 25),
    T2 = Color3.fromRGB(80, 80, 85),
    Acc = Color3.fromRGB(50, 50, 55),
    InputBg = Color3.fromRGB(220, 220, 225),
    BtnBg = Color3.fromRGB(210, 210, 215),
    BtnH = Color3.fromRGB(200, 200, 205),
    TogBg = Color3.fromRGB(200, 200, 205),
    TogOff = Color3.fromRGB(150, 150, 150),
    TogOn = Color3.fromRGB(50, 50, 55),
    DropBg = Color3.fromRGB(210, 210, 215),
    DropList = Color3.fromRGB(220, 220, 225),
    SlBg = Color3.fromRGB(200, 200, 205),
    SlFill = Color3.fromRGB(50, 50, 55),
    InpBg = Color3.fromRGB(200, 200, 205),
    Lbl = Color3.fromRGB(80, 80, 85),
    Sep = Color3.fromRGB(180, 180, 185),
    Notif = Color3.fromRGB(230, 230, 235),
    KeyBg = Color3.fromRGB(240, 240, 245),
    KeyTop = Color3.fromRGB(230, 230, 235),
}

local app = Instance.new("ScreenGui")
app.Name = "CoffeeUI_Environment"
app.IgnoreGuiInset = true
app.ResetOnSpawn = false
app.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
app.Parent = Parent

for _, v in ipairs(Parent:GetChildren()) do
    if v.Name == "CoffeeUI_Environment" and v ~= app then v:Destroy() end
end

local notifyContainer = Instance.new("Frame")
notifyContainer.Name = "NotifContainer"
notifyContainer.Parent = app
notifyContainer.BackgroundTransparency = 1
notifyContainer.Position = UDim2.new(1, -320, 1, -20)
notifyContainer.Size = UDim2.new(0, 300, 1, 0)
notifyContainer.AnchorPoint = Vector2.new(0, 1)

local notifyLayout = Instance.new("UIListLayout")
notifyLayout.Parent = notifyContainer
notifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifyLayout.Padding = UDim.new(0, 10)

local function tween(obj, dur, style, dir, props)
    return TweenService:Create(obj, TweenInfo.new(dur, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
end

function CoffeeUI:Notify(o)
    local title = o.Title or "Notification"
    local content = o.Content or "Notification content."
    local duration = o.Duration or 3

    local f = Instance.new("Frame")
    f.Name = "Notification"
    f.Parent = notifyContainer
    f.BackgroundColor3 = colors.Notif
    f.BorderSizePixel = 0
    f.Size = UDim2.new(1, 40, 0, 0)
    f.Position = UDim2.new(1, 50, 0, 0)
    f.ClipsDescendants = true
    f.BackgroundTransparency = 1
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", f)
    stroke.Color = colors.Stroke
    stroke.Thickness = 1
    stroke.Transparency = 1

    local titleL = Instance.new("TextLabel")
    titleL.Parent = f
    titleL.BackgroundTransparency = 1
    titleL.Position = UDim2.new(0, 15, 0, 10)
    titleL.Size = UDim2.new(1, -30, 0, 20)
    titleL.Font = Enum.Font.Ubuntu
    titleL.Text = title
    titleL.TextColor3 = colors.T1
    titleL.TextSize = 14
    titleL.TextXAlignment = Enum.TextXAlignment.Left
    titleL.TextTransparency = 1

    local textL = Instance.new("TextLabel")
    textL.Parent = f
    textL.BackgroundTransparency = 1
    textL.Position = UDim2.new(0, 15, 0, 32)
    textL.Size = UDim2.new(1, -30, 0, 40)
    textL.Font = Enum.Font.Ubuntu
    textL.Text = content
    textL.TextColor3 = colors.T2
    textL.TextSize = 13
    textL.TextXAlignment = Enum.TextXAlignment.Left
    textL.TextYAlignment = Enum.TextYAlignment.Top
    textL.TextWrapped = true
    textL.TextTransparency = 1

    local barBg = Instance.new("Frame")
    barBg.Parent = f
    barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    barBg.Position = UDim2.new(0, 15, 1, -8)
    barBg.Size = UDim2.new(1, -30, 0, 3)
    barBg.BorderSizePixel = 0
    barBg.BackgroundTransparency = 1
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

    local bar = Instance.new("Frame")
    bar.Parent = barBg
    bar.BackgroundColor3 = colors.Acc
    bar.Size = UDim2.new(1, 0, 1, 0)
    bar.BorderSizePixel = 0
    bar.BackgroundTransparency = 1
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    local h = 55 + TextService:GetTextSize(content, 13, Enum.Font.Ubuntu, Vector2.new(270, math.huge)).Y

    tween(f, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {Size = UDim2.new(1, 0, 0, h), BackgroundTransparency = 0})
    tween(stroke, 0.4, nil, nil, {Transparency = 0})
    tween(titleL, 0.3, nil, nil, {TextTransparency = 0})
    tween(textL, 0.3, nil, nil, {TextTransparency = 0})
    tween(barBg, 0.3, nil, nil, {BackgroundTransparency = 0})
    tween(bar, 0.3, nil, nil, {BackgroundTransparency = 0})
    tween(bar, duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In, {Size = UDim2.new(0, 0, 1, 0)})

    task.delay(duration, function()
        tween(titleL, 0.3, nil, nil, {TextTransparency = 1})
        tween(textL, 0.3, nil, nil, {TextTransparency = 1})
        tween(barBg, 0.3, nil, nil, {BackgroundTransparency = 1})
        tween(bar, 0.3, nil, nil, {BackgroundTransparency = 1})
        local t = tween(f, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
        tween(stroke, 0.4, nil, nil, {Transparency = 1})
        t.Completed:Connect(function() f:Destroy() end)
    end)
end

-- Общая функция для базового фрейма
local function makeElement(parent, height, bg, cb)
    local f = Instance.new("Frame")
    f.Parent = parent
    f.BackgroundColor3 = bg
    f.Size = UDim2.new(1, 0, 0, height)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", f)
    stroke.Color = colors.Stroke
    return f, stroke
end

function CoffeeUI:CreateWindow(o)
    local name = o.Name or "CoffeeUI"
    local hideKey = o.HideKey or Enum.KeyCode.K

    local isOpen = false
    local animating = false

    local overlay = Instance.new("Frame")
    overlay.Name = "IntroOverlay"
    overlay.Parent = app
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.Position = UDim2.new(0, 0, 0, 0)
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.ZIndex = 100
    overlay.BackgroundTransparency = 1

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = overlay
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0.5, -200, 0.5, -40)
    titleLabel.Size = UDim2.new(0, 400, 0, 80)
    titleLabel.Font = Enum.Font.Code
    titleLabel.Text = "Developed by Coffee"
    titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    titleLabel.TextScaled = true
    titleLabel.TextTransparency = 1

    local main = Instance.new("Frame")
    main.Name = "MainFrame"
    main.Parent = app
    main.BackgroundColor3 = colors.Bg
    main.Position = UDim2.new(0.5, -325, 0.5, -200)
    main.Size = UDim2.new(0, 650, 0, 400)
    main.Visible = false
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", main).Color = colors.Stroke

    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Parent = main
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundTransparency = 0.8
    shadow.ZIndex = -1
    Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 14)

    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Parent = main
    sidebar.BackgroundColor3 = colors.Side
    sidebar.Position = UDim2.new(0, 0, 0, 35)
    sidebar.Size = UDim2.new(0, 180, 1, -35)
    sidebar.BorderSizePixel = 0
    sidebar.ClipsDescendants = true
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)

    local fix1 = Instance.new("Frame", sidebar)
    fix1.BackgroundColor3 = colors.Side
    fix1.Position = UDim2.new(1, -10, 0, 0)
    fix1.Size = UDim2.new(0, 10, 1, 0)

    local fix2 = Instance.new("Frame", sidebar)
    fix2.BackgroundColor3 = colors.Side
    fix2.Position = UDim2.new(0, 0, 0, 0)
    fix2.Size = UDim2.new(1, 0, 0, 10)

    local div = Instance.new("Frame", sidebar)
    div.BackgroundColor3 = colors.Stroke
    div.Position = UDim2.new(1, 0, 0, 0)
    div.Size = UDim2.new(0, 1, 1, 0)

    local header = Instance.new("Frame")
    header.Name = "Topbar"
    header.Parent = main
    header.BackgroundColor3 = colors.Top
    header.Size = UDim2.new(1, 0, 0, 35)
    header.BorderSizePixel = 0
    header.ZIndex = 5
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 10)

    local hFix = Instance.new("Frame", header)
    hFix.BackgroundColor3 = colors.Top
    hFix.Position = UDim2.new(0, 0, 1, -10)
    hFix.Size = UDim2.new(1, 0, 0, 10)

    local hDiv = Instance.new("Frame", header)
    hDiv.BackgroundColor3 = colors.Stroke
    hDiv.Position = UDim2.new(0, 0, 1, -1)
    hDiv.Size = UDim2.new(1, 0, 0, 1)

    local dragging, dragStart, startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            if dragging then
                main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = header
    closeBtn.BackgroundTransparency = 1
    closeBtn.Position = UDim2.new(1, -40, 0, 0)
    closeBtn.Size = UDim2.new(0, 40, 1, 0)
    closeBtn.Font = Enum.Font.Ubuntu
    closeBtn.Text = "X"
    closeBtn.TextColor3 = colors.T2
    closeBtn.TextSize = 14
    closeBtn.AutoButtonColor = false
    closeBtn.MouseEnter:Connect(function() closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100) end)
    closeBtn.MouseLeave:Connect(function() closeBtn.TextColor3 = colors.T2 end)

    local titleL = Instance.new("TextLabel")
    titleL.Parent = header
    titleL.BackgroundTransparency = 1
    titleL.Position = UDim2.new(0, 15, 0, 0)
    titleL.Size = UDim2.new(1, -60, 1, 0)
    titleL.Font = Enum.Font.Ubuntu
    titleL.Text = name
    titleL.TextColor3 = colors.T1
    titleL.TextSize = 14
    titleL.TextXAlignment = Enum.TextXAlignment.Left
    titleL.TextYAlignment = Enum.TextYAlignment.Center

    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Name = "TabContainer"
    tabContainer.Parent = sidebar
    tabContainer.Active = true
    tabContainer.BackgroundTransparency = 1
    tabContainer.Position = UDim2.new(0, 0, 0, 10)
    tabContainer.Size = UDim2.new(1, 0, 1, -80)
    tabContainer.ScrollBarThickness = 2
    tabContainer.ScrollBarImageColor3 = colors.Stroke

    local tabList = Instance.new("UIListLayout")
    tabList.Parent = tabContainer
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Padding = UDim.new(0, 5)

    local tabPad = Instance.new("UIPadding")
    tabPad.Parent = tabContainer
    tabPad.PaddingTop = UDim.new(0, 5)
    tabPad.PaddingLeft = UDim.new(0, 10)
    tabPad.PaddingRight = UDim.new(0, 10)

    tabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContainer.CanvasSize = UDim2.new(0, 0, 0, tabList.AbsoluteContentSize.Y + 15)
    end)

    local profile = Instance.new("Frame")
    profile.Name = "ProfileFrame"
    profile.Parent = sidebar
    profile.BackgroundTransparency = 1
    profile.Position = UDim2.new(0, 10, 1, -60)
    profile.Size = UDim2.new(1, -20, 0, 50)

    local avatar = Instance.new("ImageLabel")
    avatar.Parent = profile
    avatar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    avatar.Size = UDim2.new(0, 34, 0, 34)
    avatar.Position = UDim2.new(0, 0, 0.5, -17)
    Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)

    local nameL = Instance.new("TextLabel")
    nameL.Parent = profile
    nameL.BackgroundTransparency = 1
    nameL.Position = UDim2.new(0, 42, 0, 8)
    nameL.Size = UDim2.new(1, -42, 0, 16)
    nameL.Font = Enum.Font.Ubuntu
    nameL.Text = Players.LocalPlayer and Players.LocalPlayer.Name or "Unknown"
    nameL.TextColor3 = colors.T1
    nameL.TextSize = 13
    nameL.TextXAlignment = Enum.TextXAlignment.Left

    local gameL = Instance.new("TextLabel")
    gameL.Parent = profile
    gameL.BackgroundTransparency = 1
    gameL.Position = UDim2.new(0, 42, 0, 24)
    gameL.Size = UDim2.new(1, -42, 0, 14)
    gameL.Font = Enum.Font.Ubuntu
    gameL.Text = "Loading..."
    gameL.TextColor3 = colors.T2
    gameL.TextSize = 11
    gameL.TextXAlignment = Enum.TextXAlignment.Left

    task.spawn(function()
        local lp = Players.LocalPlayer
        if lp then
            local success, url = pcall(function() return Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end)
            if success then avatar.Image = url end
        end
    end)
    task.spawn(function()
        local success, info = pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId) end)
        if success and info and info.Name then gameL.Text = info.Name else gameL.Text = "Unknown Game" end
    end)

    local content = Instance.new("Frame")
    content.Name = "ContentArea"
    content.Parent = main
    content.BackgroundTransparency = 1
    content.Position = UDim2.new(0, 181, 0, 35)
    content.Size = UDim2.new(1, -181, 1, -35)

    task.spawn(function()
        tween(overlay, 0.5, nil, nil, {BackgroundTransparency = 0})
        task.wait(0.6)
        tween(titleLabel, 1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {TextTransparency = 0})
        tween(titleLabel, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, {Size = UDim2.new(0, 480, 0, 96), Position = UDim2.new(0.5, -240, 0.5, -48)})
        task.wait(1.5)
        tween(titleLabel, 0.6, nil, nil, {TextTransparency = 1, Size = UDim2.new(0, 600, 0, 120), Position = UDim2.new(0.5, -300, 0.5, -60)})
        task.wait(0.7)

        main.Visible = true
        main.Size = UDim2.new(0, 100, 0, 100)
        main.Position = UDim2.new(0.5, -50, 0.5, -50)
        main.BackgroundTransparency = 1

        task.delay(1.5, function() if overlay and overlay.Parent then overlay:Destroy() end end)
        local fade = tween(overlay, 0.8, nil, nil, {BackgroundTransparency = 1})
        tween(main, 1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
            Size = UDim2.new(0, 650, 0, 400),
            Position = UDim2.new(0.5, -325, 0.5, -200),
            BackgroundTransparency = 0
        })
        fade.Completed:Connect(function()
            if overlay and overlay.Parent then overlay:Destroy() end
            isOpen = true
            CoffeeUI:Notify({Title = "Loaded", Content = "CoffeeUI loaded successfully.", Duration = 4})
        end)
    end)

    local function ToggleUI(state)
        if animating then return end
        animating = true
        isOpen = state
        if state then
            main.Visible = true
            main.Size = UDim2.new(0, 100, 0, 100)
            main.Position = UDim2.new(0.5, -50, 0.5, -50)
            main.BackgroundTransparency = 1
            tween(main, 1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
                Size = UDim2.new(0, 650, 0, 400),
                Position = UDim2.new(0.5, -325, 0.5, -200),
                BackgroundTransparency = 0
            }).Completed:Connect(function() animating = false end)
        else
            tween(main, 1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
                Size = UDim2.new(0, 100, 0, 100),
                Position = UDim2.new(0.5, -50, 0.5, -50),
                BackgroundTransparency = 1
            }).Completed:Connect(function()
                if not isOpen then
                    main.Visible = false
                    main.Size = UDim2.new(0, 650, 0, 400)
                    main.Position = UDim2.new(0.5, -325, 0.5, -200)
                    main.BackgroundTransparency = 0
                end
                animating = false
            end)
        end
    end

    closeBtn.MouseButton1Click:Connect(function() if isOpen then ToggleUI(false) end end)
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == hideKey and not Parent:FindFirstChild("IntroOverlay") then
            ToggleUI(not isOpen)
        end
    end)

    local Window = {}
    local Pages = {}

    function Window:CreateTab(name)
        local btn = Instance.new("TextButton")
        btn.Name = name.."_Btn"
        btn.Parent = tabContainer
        btn.BackgroundColor3 = colors.BtnBg
        btn.BackgroundTransparency = 1
        btn.Size = UDim2.new(1, 0, 0, 36)
        btn.Font = Enum.Font.Ubuntu
        btn.Text = "   " .. name
        btn.TextColor3 = colors.T2
        btn.TextSize = 14
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        local ind = Instance.new("Frame")
        ind.Parent = btn
        ind.BackgroundColor3 = colors.Acc
        ind.Size = UDim2.new(0, 3, 0, 0)
        ind.Position = UDim2.new(0, 0, 0.5, 0)
        ind.AnchorPoint = Vector2.new(0, 0.5)
        Instance.new("UICorner", ind).CornerRadius = UDim.new(1, 0)

        local page = Instance.new("ScrollingFrame")
        page.Name = name.."_Page"
        page.Parent = content
        page.Active = true
        page.BackgroundTransparency = 1
        page.Size = UDim2.new(1, 0, 1, 0)
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = colors.Stroke
        page.Visible = false
        page.CanvasSize = UDim2.new(0,0,0,0)
        table.insert(Pages, page)

        local layout = Instance.new("UIListLayout")
        layout.Parent = page
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 10)

        local pad = Instance.new("UIPadding")
        pad.Parent = page
        pad.PaddingTop = UDim.new(0, 10)
        pad.PaddingBottom = UDim.new(0, 20)
        pad.PaddingLeft = UDim.new(0, 20)
        pad.PaddingRight = UDim.new(0, 20)

        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 30)
        end)

        local function activate()
            for _, ch in ipairs(tabContainer:GetChildren()) do
                if ch:IsA("TextButton") then
                    tween(ch, 0.3, nil, nil, {BackgroundTransparency = 1, TextColor3 = colors.T2})
                    local i = ch:FindFirstChild("Frame")
                    if i then tween(i, 0.3, nil, nil, {Size = UDim2.new(0, 3, 0, 0)}) end
                end
            end
            for i = 1, #Pages do
                local p = Pages[i]
                if p.Visible then
                    p.Visible = false
                    p.Position = UDim2.new(0, 10, 0, 0)
                end
            end
            tween(btn, 0.3, nil, nil, {BackgroundTransparency = 0, TextColor3 = colors.T1})
            tween(ind, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {Size = UDim2.new(0, 3, 0, 18)})
            page.Visible = true
            tween(page, 0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {Position = UDim2.new(0, 0, 0, 0)})
        end

        btn.MouseButton1Click:Connect(activate)
        if #Pages == 1 then activate() end

        local Elements = {}
        local elementMeta = {}

        function elementMeta:__index(key)
            if key == "CreateButton" then
                return function(o)
                    local cb = o.Callback or function() end
                    local f, stroke = makeElement(page, 42, colors.BtnBg, cb)

                    local txt = Instance.new("TextLabel")
                    txt.Parent = f
                    txt.BackgroundTransparency = 1
                    txt.Position = UDim2.new(0, 15, 0, 0)
                    txt.Size = UDim2.new(1, -30, 1, 0)
                    txt.Font = Enum.Font.Ubuntu
                    txt.Text = o.Name or "Button"
                    txt.TextColor3 = colors.T1
                    txt.TextSize = 14
                    txt.TextXAlignment = Enum.TextXAlignment.Left

                    local icon = Instance.new("ImageLabel")
                    icon.Parent = f
                    icon.BackgroundTransparency = 1
                    icon.Position = UDim2.new(1, -30, 0.5, -8)
                    icon.Size = UDim2.new(0, 16, 0, 16)
                    icon.Image = "rbxassetid://10888331510"
                    icon.ImageColor3 = colors.T2

                    local btn = Instance.new("TextButton")
                    btn.Parent = f
                    btn.BackgroundTransparency = 1
                    btn.Size = UDim2.new(1, 0, 1, 0)
                    btn.Text = ""

                    btn.MouseEnter:Connect(function()
                        tween(f, 0.2, nil, nil, {BackgroundColor3 = colors.BtnH})
                        tween(icon, 0.2, nil, nil, {Position = UDim2.new(1, -25, 0.5, -8), ImageColor3 = colors.T1})
                    end)
                    btn.MouseLeave:Connect(function()
                        tween(f, 0.2, nil, nil, {BackgroundColor3 = colors.BtnBg})
                        tween(icon, 0.2, nil, nil, {Position = UDim2.new(1, -30, 0.5, -8), ImageColor3 = colors.T2})
                    end)
                    btn.MouseButton1Down:Connect(function()
                        tween(f, 0.1, nil, nil, {Size = UDim2.new(1, -4, 0, 38)})
                        tween(stroke, 0.1, nil, nil, {Color = colors.Acc})
                    end)
                    btn.MouseButton1Up:Connect(function()
                        tween(f, 0.1, nil, nil, {Size = UDim2.new(1, 0, 0, 42)})
                        tween(stroke, 0.1, nil, nil, {Color = colors.Stroke})
                        cb()
                    end)
                end
            elseif key == "CreateToggle" then
                return function(o)
                    local cb = o.Callback or function() end
                    local val = o.CurrentValue or false
                    local f, stroke = makeElement(page, 42, colors.BtnBg, cb)

                    local txt = Instance.new("TextLabel")
                    txt.Parent = f
                    txt.BackgroundTransparency = 1
                    txt.Position = UDim2.new(0, 15, 0, 0)
                    txt.Size = UDim2.new(1, -60, 1, 0)
                    txt.Font = Enum.Font.Ubuntu
                    txt.Text = o.Name or "Toggle"
                    txt.TextColor3 = colors.T1
                    txt.TextSize = 14
                    txt.TextXAlignment = Enum.TextXAlignment.Left

                    local bg = Instance.new("Frame")
                    bg.Parent = f
                    bg.BackgroundColor3 = colors.TogBg
                    bg.Position = UDim2.new(1, -45, 0.5, -12)
                    bg.Size = UDim2.new(0, 36, 0, 24)
                    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
                    local bgStroke = Instance.new("UIStroke", bg)
                    bgStroke.Color = colors.Stroke

                    local circle = Instance.new("Frame")
                    circle.Parent = bg
                    circle.BackgroundColor3 = colors.TogOff
                    circle.Position = UDim2.new(0, 4, 0.5, -8)
                    circle.Size = UDim2.new(0, 16, 0, 16)
                    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

                    local btn = Instance.new("TextButton")
                    btn.Parent = f
                    btn.BackgroundTransparency = 1
                    btn.Size = UDim2.new(1, 0, 1, 0)
                    btn.Text = ""

                    local function update(anim)
                        local t = anim and 0.25 or 0
                        if val then
                            tween(bg, t, nil, nil, {BackgroundColor3 = colors.TogOn})
                            tween(circle, t, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {Position = UDim2.new(1, -20, 0.5, -8), BackgroundColor3 = colors.BtnBg})
                            tween(bgStroke, t, nil, nil, {Color = colors.TogOn})
                        else
                            tween(bg, t, nil, nil, {BackgroundColor3 = colors.TogBg})
                            tween(circle, t, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {Position = UDim2.new(0, 4, 0.5, -8), BackgroundColor3 = colors.TogOff})
                            tween(bgStroke, t, nil, nil, {Color = colors.Stroke})
                        end
                    end
                    update(false)

                    btn.MouseButton1Click:Connect(function()
                        val = not val
                        update(true)
                        cb(val)
                    end)
                    btn.MouseEnter:Connect(function() tween(f, 0.2, nil, nil, {BackgroundColor3 = colors.BtnH}) end)
                    btn.MouseLeave:Connect(function() tween(f, 0.2, nil, nil, {BackgroundColor3 = colors.BtnBg}) end)
                end
            elseif key == "CreateSlider" then
                return function(o)
                    local min = o.Range[1] or 0
                    local max = o.Range[2] or 100
                    local val = o.CurrentValue or min
                    local inc = o.Increment or 1
                    local cb = o.Callback or function() end

                    if max == min then
                        -- Заглушка, чтобы не ломать код
                        return {
                            Set = function() end,
                            GetSelected = function() return min end,
                            Refresh = function() end
                        }
                    end

                    local isFloat = (inc < 1) or (math.floor(min) ~= min) or (math.floor(max) ~= max)
                    local dec = 0
                    if isFloat then
                        local s = tostring(inc)
                        local dot = s:find("%.")
                        dec = dot and (#s - dot) or 2
                    end

                    local function snap(v)
                        if inc <= 0 then return v end
                        local snapped = math.floor((v - min) / inc + 0.5) * inc + min
                        snapped = math.clamp(snapped, min, max)
                        if isFloat then return tonumber(string.format("%."..dec.."f", snapped)) end
                        return math.floor(snapped + 0.5)
                    end

                    local function fmt(v)
                        if isFloat then return string.format("%."..dec.."f", v) end
                        return tostring(math.floor(v + 0.5))
                    end

                    local f, stroke = makeElement(page, 60, colors.BtnBg, cb)

                    local title = Instance.new("TextLabel")
                    title.Parent = f
                    title.BackgroundTransparency = 1
                    title.Position = UDim2.new(0, 15, 0, 10)
                    title.Size = UDim2.new(1, -30, 0, 20)
                    title.Font = Enum.Font.Ubuntu
                    title.Text = o.Name or "Slider"
                    title.TextColor3 = colors.T1
                    title.TextSize = 14
                    title.TextXAlignment = Enum.TextXAlignment.Left

                    local value = Instance.new("TextLabel")
                    value.Parent = f
                    value.BackgroundTransparency = 1
                    value.Position = UDim2.new(0, 15, 0, 10)
                    value.Size = UDim2.new(1, -30, 0, 20)
                    value.Font = Enum.Font.Ubuntu
                    value.Text = fmt(val)
                    value.TextColor3 = colors.T2
                    value.TextSize = 14
                    value.TextXAlignment = Enum.TextXAlignment.Right

                    local track = Instance.new("Frame")
                    track.Parent = f
                    track.BackgroundColor3 = colors.SlBg
                    track.Position = UDim2.new(0, 15, 1, -15)
                    track.Size = UDim2.new(1, -30, 0, 6)
                    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

                    local fill = Instance.new("Frame")
                    fill.Parent = track
                    fill.BackgroundColor3 = colors.SlFill
                    fill.Size = UDim2.new(0, 0, 1, 0)
                    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

                    local handle = Instance.new("Frame")
                    handle.Parent = track
                    handle.Size = UDim2.new(0, 12, 0, 12)
                    handle.AnchorPoint = Vector2.new(0.5, 0.5)
                    handle.Position = UDim2.new((val - min) / math.max(max - min, 0.0001), 0, 0.5, 0)
                    handle.BackgroundColor3 = colors.T1
                    handle.BorderSizePixel = 0
                    handle.ZIndex = 3
                    Instance.new("UICorner", handle).CornerRadius = UDim.new(1, 0)

                    local drag = Instance.new("TextButton")
                    drag.Parent = track
                    drag.BackgroundTransparency = 1
                    drag.Position = UDim2.new(0, -15, 0, -10)
                    drag.Size = UDim2.new(1, 30, 1, 20)
                    drag.Text = ""
                    drag.ZIndex = 5

                    f.MouseEnter:Connect(function() tween(f, 0.2, nil, nil, {BackgroundColor3 = colors.BtnH}) end)
                    f.MouseLeave:Connect(function() tween(f, 0.2, nil, nil, {BackgroundColor3 = colors.BtnBg}) end)

                    local dragging = false
                    local function update(input)
                        local w = track.AbsoluteSize.X
                        if w == 0 then w = 1 end
                        local x = math.clamp((input.Position.X - track.AbsolutePosition.X) / w, 0, 1)
                        local raw = min + (max - min) * x
                        local snapped = snap(raw)
                        local fillX = (snapped - min) / math.max(max - min, 0.0001)
                        tween(fill, 0.05, nil, nil, {Size = UDim2.new(fillX, 0, 1, 0)})
                        handle.Position = UDim2.new(fillX, 0, 0.5, 0)
                        value.Text = fmt(snapped)
                        cb(snapped)
                    end

                    drag.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            dragging = true
                            update(input)
                        end
                    end)
                    drag.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            dragging = false
                        end
                    end)
                    UserInputService.InputChanged:Connect(function(input)
                        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                            update(input)
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                    end)

                    local init = (val - min) / math.max(max - min, 0.0001)
                    fill.Size = UDim2.new(math.clamp(init, 0, 1), 0, 1, 0)
                    handle.Position = UDim2.new(math.clamp(init, 0, 1), 0, 0.5, 0)
                end
            elseif key == "CreateLabel" then
                return function(o)
                    local l = Instance.new("Frame")
                    l.Parent = page
                    l.BackgroundTransparency = 1
                    l.Size = UDim2.new(1, 0, 0, 28)

                    local txt = Instance.new("TextLabel")
                    txt.Parent = l
                    txt.BackgroundTransparency = 1
                    txt.Position = UDim2.new(0, 15, 0, 0)
                    txt.Size = UDim2.new(1, -30, 1, 0)
                    txt.Font = Enum.Font.Ubuntu
                    txt.Text = o.Text or "Label"
                    txt.TextColor3 = o.Color or colors.Lbl
                    txt.TextSize = o.TextSize or 13
                    txt.TextXAlignment = Enum.TextXAlignment.Left
                    txt.TextWrapped = true
                    txt.RichText = true

                    return {
                        SetText = function(t) txt.Text = t end,
                        SetColor = function(c) txt.TextColor3 = c end
                    }
                end
            elseif key == "CreateSeparator" then
                return function(o)
                    local text = o and o.Text or ""
                    local f = Instance.new("Frame")
                    f.Parent = page
                    f.BackgroundTransparency = 1
                    f.Size = UDim2.new(1, 0, 0, 24)

                    local line = Instance.new("Frame")
                    line.Parent = f
                    line.BackgroundColor3 = colors.Sep
                    line.AnchorPoint = Vector2.new(0, 0.5)
                    line.Position = UDim2.new(0, 15, 0.5, 0)
                    line.Size = UDim2.new(1, -30, 0, 1)
                    Instance.new("UICorner", line).CornerRadius = UDim.new(1, 0)

                    if text ~= "" then
                        local lab = Instance.new("TextLabel")
                        lab.Parent = f
                        lab.BackgroundColor3 = colors.Bg
                        lab.Size = UDim2.new(0, 0, 0, 16)
                        lab.AutomaticSize = Enum.AutomaticSize.X
                        lab.AnchorPoint = Vector2.new(0.5, 0.5)
                        lab.Position = UDim2.new(0.5, 0, 0.5, 0)
                        lab.Font = Enum.Font.Ubuntu
                        lab.Text = "  " .. text .. "  "
                        lab.TextColor3 = colors.T2
                        lab.TextSize = 11
                        lab.ZIndex = 2
                    end
                end
            elseif key == "CreateKeybind" then
                return function(o)
                    local listening = false
                    local key = o.CurrentKey or Enum.KeyCode.Unknown
                    local cb = o.Callback or function() end

                    local f, stroke = makeElement(page, 42, colors.BtnBg, cb)

                    local txt = Instance.new("TextLabel")
                    txt.Parent = f
                    txt.BackgroundTransparency = 1
                    txt.Position = UDim2.new(0, 15, 0, 0)
                    txt.Size = UDim2.new(1, -100, 1, 0)
                    txt.Font = Enum.Font.Ubuntu
                    txt.Text = o.Name or "Keybind"
                    txt.TextColor3 = colors.T1
                    txt.TextSize = 14
                    txt.TextXAlignment = Enum.TextXAlignment.Left

                    local btn = Instance.new("TextButton")
                    btn.Parent = f
                    btn.BackgroundColor3 = colors.InpBg
                    btn.Position = UDim2.new(1, -90, 0.5, -12)
                    btn.Size = UDim2.new(0, 78, 0, 24)
                    btn.Font = Enum.Font.Code
                    btn.Text = key.Name
                    btn.TextColor3 = colors.T1
                    btn.TextSize = 12
                    btn.AutoButtonColor = false
                    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
                    local bStroke = Instance.new("UIStroke", btn)
                    bStroke.Color = colors.Stroke

                    f.MouseEnter:Connect(function() tween(f, 0.2, nil, nil, {BackgroundColor3 = colors.BtnH}) end)
                    f.MouseLeave:Connect(function() tween(f, 0.2, nil, nil, {BackgroundColor3 = colors.BtnBg}) end)

                    btn.MouseButton1Click:Connect(function()
                        listening = true
                        btn.Text = "..."
                        tween(bStroke, 0.2, nil, nil, {Color = colors.Acc})
                    end)

                    UserInputService.InputBegan:Connect(function(input, gp)
                        if not listening then return end
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            key = input.KeyCode == Enum.KeyCode.Escape and Enum.KeyCode.Unknown or input.KeyCode
                            listening = false
                            btn.Text = key.Name
                            tween(bStroke, 0.2, nil, nil, {Color = colors.Stroke})
                            cb(key)
                        end
                    end)
                end
            elseif key == "CreateDropdown" then
                return function(o)
                    local list = o.Options or {}
                    local current = o.CurrentOption or (list[1] or "")
                    local cb = o.Callback or function() end

                    local outer = Instance.new("Frame")
                    outer.Parent = page
                    outer.BackgroundTransparency = 1
                    outer.Size = UDim2.new(1, 0, 0, 42)
                    outer.ClipsDescendants = false
                    outer.ZIndex = 10

                    local head = Instance.new("Frame")
                    head.Parent = outer
                    head.BackgroundColor3 = colors.DropBg
                    head.Size = UDim2.new(1, 0, 0, 42)
                    head.ClipsDescendants = false
                    head.ZIndex = 10
                    Instance.new("UICorner", head).CornerRadius = UDim.new(0, 6)
                    local hStroke = Instance.new("UIStroke", head)
                    hStroke.Color = colors.Stroke

                    local btn = Instance.new("TextButton")
                    btn.Parent = head
                    btn.BackgroundTransparency = 1
                    btn.Size = UDim2.new(1, 0, 1, 0)
                    btn.Text = ""
                    btn.ZIndex = 12

                    local title = Instance.new("TextLabel")
                    title.Parent = head
                    title.BackgroundTransparency = 1
                    title.Position = UDim2.new(0, 15, 0, 0)
                    title.Size = UDim2.new(1, -60, 1, 0)
                    title.Font = Enum.Font.Ubuntu
                    title.Text = o.Name .. "  ›  " .. tostring(current)
                    title.TextColor3 = colors.T1
                    title.TextSize = 14
                    title.TextXAlignment = Enum.TextXAlignment.Left
                    title.ZIndex = 11

                    local arrow = Instance.new("TextLabel")
                    arrow.Parent = head
                    arrow.BackgroundTransparency = 1
                    arrow.Position = UDim2.new(1, -32, 0, 0)
                    arrow.Size = UDim2.new(0, 24, 1, 0)
                    arrow.Font = Enum.Font.Ubuntu
                    arrow.Text = "▼"
                    arrow.TextColor3 = colors.T2
                    arrow.TextSize = 12
                    arrow.ZIndex = 11

                    local panel = Instance.new("Frame")
                    panel.Parent = head
                    panel.BackgroundColor3 = colors.DropList
                    panel.Position = UDim2.new(0, 0, 1, 4)
                    panel.Size = UDim2.new(1, 0, 0, 0)
                    panel.ClipsDescendants = true
                    panel.ZIndex = 50
                    panel.Visible = false
                    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 6)
                    local pStroke = Instance.new("UIStroke", panel)
                    pStroke.Color = colors.Stroke

                    local scroll = Instance.new("ScrollingFrame")
                    scroll.Parent = panel
                    scroll.BackgroundTransparency = 1
                    scroll.Size = UDim2.new(1, 0, 1, 0)
                    scroll.ScrollBarThickness = 2
                    scroll.ScrollBarImageColor3 = colors.Stroke
                    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
                    scroll.ZIndex = 51

                    local layout = Instance.new("UIListLayout")
                    layout.Parent = scroll
                    layout.SortOrder = Enum.SortOrder.LayoutOrder

                    local pad = Instance.new("UIPadding")
                    pad.Parent = scroll
                    pad.PaddingTop = UDim.new(0, 4)
                    pad.PaddingBottom = UDim.new(0, 4)

                    local expanded = false
                    local ITEM_H = 34

                    local function build()
                        for _, v in ipairs(scroll:GetChildren()) do
                            if v:IsA("TextButton") then v:Destroy() end
                        end
                        for i = 1, #list do
                            local opt = list[i]
                            local is = tostring(opt) == tostring(current)
                            local b = Instance.new("TextButton")
                            b.Parent = scroll
                            b.BackgroundColor3 = is and colors.Acc or colors.DropList
                            b.BackgroundTransparency = is and 0 or 1
                            b.Size = UDim2.new(1, 0, 0, ITEM_H)
                            b.Font = Enum.Font.Ubuntu
                            b.Text = "  " .. (is and "▶  " or "    ") .. tostring(opt)
                            b.TextColor3 = is and colors.Bg or colors.T2
                            b.TextSize = 13
                            b.TextXAlignment = Enum.TextXAlignment.Left
                            b.AutoButtonColor = false
                            b.ZIndex = 52

                            b.MouseEnter:Connect(function()
                                if not is then
                                    tween(b, 0.12, nil, nil, {BackgroundTransparency = 0, BackgroundColor3 = colors.BtnH, TextColor3 = colors.T1})
                                end
                            end)
                            b.MouseLeave:Connect(function()
                                if not is then
                                    tween(b, 0.12, nil, nil, {BackgroundTransparency = 1, TextColor3 = colors.T2})
                                end
                            end)
                            b.MouseButton1Click:Connect(function()
                                current = opt
                                title.Text = o.Name .. "  ›  " .. tostring(current)
                                expanded = false
                                tween(panel, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {Size = UDim2.new(1, 0, 0, 0)})
                                tween(arrow, 0.2, nil, nil, {Rotation = 0})
                                task.wait(0.28)
                                panel.Visible = false
                                build()
                                cb(current)
                            end)
                        end
                        scroll.CanvasSize = UDim2.new(0, 0, 0, #list * ITEM_H + 8)
                    end
                    build()

                    local function toggle()
                        expanded = not expanded
                        if expanded then
                            local h = math.clamp(#list * ITEM_H + 8, 0, 180)
                            panel.Visible = true
                            panel.Size = UDim2.new(1, 0, 0, 0)
                            tween(panel, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {Size = UDim2.new(1, 0, 0, h)})
                            tween(arrow, 0.25, nil, nil, {Rotation = 180})
                            tween(head, 0.2, nil, nil, {BackgroundColor3 = colors.BtnH})
                        else
                            tween(panel, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {Size = UDim2.new(1, 0, 0, 0)})
                            tween(arrow, 0.2, nil, nil, {Rotation = 0})
                            tween(head, 0.2, nil, nil, {BackgroundColor3 = colors.DropBg})
                            task.wait(0.28)
                            if not expanded then panel.Visible = false end
                        end
                    end

                    btn.MouseButton1Click:Connect(toggle)
                    head.MouseEnter:Connect(function() if not expanded then tween(head, 0.2, nil, nil, {BackgroundColor3 = colors.BtnH}) end end)
                    head.MouseLeave:Connect(function() if not expanded then tween(head, 0.2, nil, nil, {BackgroundColor3 = colors.DropBg}) end end)

                    UserInputService.InputBegan:Connect(function(input)
                        if expanded and input.UserInputType == Enum.UserInputType.MouseButton1 then
                            local pos = input.Position
                            local hp = head.AbsolutePosition
                            local hs = head.AbsoluteSize
                            local pp = panel.AbsolutePosition
                            local ps = panel.AbsoluteSize
                            local inHead = pos.X >= hp.X and pos.X <= hp.X + hs.X and pos.Y >= hp.Y and pos.Y <= hp.Y + hs.Y
                            local inPanel = pos.X >= pp.X and pos.X <= pp.X + ps.X and pos.Y >= pp.Y and pos.Y <= pp.Y + ps.Y
                            if not inHead and not inPanel then
                                task.spawn(function()
                                    expanded = false
                                    tween(panel, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {Size = UDim2.new(1, 0, 0, 0)})
                                    tween(arrow, 0.2, nil, nil, {Rotation = 0})
                                    tween(head, 0.2, nil, nil, {BackgroundColor3 = colors.DropBg})
                                    task.wait(0.28)
                                    panel.Visible = false
                                end)
                            end
                        end
                    end)

                    return {
                        Set = function(opt) current = opt; title.Text = o.Name .. "  ›  " .. tostring(current); build(); cb(current) end,
                        GetSelected = function() return current end,
                        Refresh = function(new) list = new; build() end
                    }
                end
            elseif key == "CreateInput" then
                return function(o)
                    local cb = o.Callback or function() end
                    local f, stroke = makeElement(page, 42, colors.BtnBg, cb)

                    local title = Instance.new("TextLabel")
                    title.Parent = f
                    title.BackgroundTransparency = 1
                    title.Position = UDim2.new(0, 15, 0, 0)
                    title.Size = UDim2.new(0.4, 0, 1, 0)
                    title.Font = Enum.Font.Ubuntu
                    title.Text = o.Name or "Input"
                    title.TextColor3 = colors.T1
                    title.TextSize = 14
                    title.TextXAlignment = Enum.TextXAlignment.Left

                    local bg = Instance.new("Frame")
                    bg.Parent = f
                    bg.BackgroundColor3 = colors.InpBg
                    bg.Position = UDim2.new(0.4, 15, 0.5, -12)
                    bg.Size = UDim2.new(0.6, -30, 0, 24)
                    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 4)

                    local box = Instance.new("TextBox")
                    box.Parent = bg
                    box.BackgroundTransparency = 1
                    box.Size = UDim2.new(1, -10, 1, 0)
                    box.Position = UDim2.new(0, 5, 0, 0)
                    box.Font = Enum.Font.Ubuntu
                    box.Text = ""
                    box.PlaceholderText = o.PlaceholderText or "Type here..."
                    box.TextColor3 = colors.T1
                    box.PlaceholderColor3 = colors.T2
                    box.TextSize = 13
                    box.TextXAlignment = Enum.TextXAlignment.Left

                    box.FocusLost:Connect(function(enter) cb(box.Text) end)
                end
            elseif key == "CreateColorPicker" then
                return function(o)
                    local h, s, v = Color3.toHSV(o.Default or Color3.fromRGB(255, 0, 0))
                    local expanded = false
                    local svDrag = false
                    local hueDrag = false
                    local cb = o.Callback or function() end

                    local f = Instance.new("Frame")
                    f.Parent = page
                    f.BackgroundColor3 = colors.BtnBg
                    f.Size = UDim2.new(1, 0, 0, 42)
                    f.ClipsDescendants = true
                    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
                    local stroke = Instance.new("UIStroke", f)
                    stroke.Color = colors.Stroke

                    local label = Instance.new("TextLabel")
                    label.Parent = f
                    label.BackgroundTransparency = 1
                    label.Position = UDim2.new(0, 15, 0, 0)
                    label.Size = UDim2.new(1, -90, 0, 42)
                    label.Font = Enum.Font.Ubuntu
                    label.Text = o.Name or "Color Picker"
                    label.TextColor3 = colors.T1
                    label.TextSize = 14
                    label.TextXAlignment = Enum.TextXAlignment.Left

                    local swatch = Instance.new("Frame")
                    swatch.Parent = f
                    swatch.BackgroundColor3 = Color3.fromHSV(h, s, v)
                    swatch.Position = UDim2.new(1, -68, 0.5, -10)
                    swatch.Size = UDim2.new(0, 36, 0, 20)
                    Instance.new("UICorner", swatch).CornerRadius = UDim.new(0, 4)
                    local swStroke = Instance.new("UIStroke", swatch)
                    swStroke.Color = colors.Stroke
                    swStroke.Thickness = 1

                    local arrow = Instance.new("ImageLabel")
                    arrow.Parent = f
                    arrow.BackgroundTransparency = 1
                    arrow.Position = UDim2.new(1, -26, 0.5, -8)
                    arrow.Size = UDim2.new(0, 16, 0, 16)
                    arrow.Image = "rbxassetid://10888331510"
                    arrow.ImageColor3 = colors.T2
                    arrow.Rotation = 90

                    local header = Instance.new("TextButton")
                    header.Parent = f
                    header.BackgroundTransparency = 1
                    header.Size = UDim2.new(1, 0, 0, 42)
                    header.Text = ""
                    header.ZIndex = 2

                    local paletteImg = Instance.new("ImageLabel")
                    paletteImg.Parent = f
                    paletteImg.Size = UDim2.new(1, -30, 0, 150)
                    paletteImg.Position = UDim2.new(0, 15, 0, 52)
                    paletteImg.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    paletteImg.Image = "rbxassetid://4155801252"
                    paletteImg.ZIndex = 3
                    Instance.new("UICorner", paletteImg).CornerRadius = UDim.new(0, 4)

                    local svCursor = Instance.new("Frame")
                    svCursor.Parent = paletteImg
                    svCursor.Size = UDim2.new(0, 10, 0, 10)
                    svCursor.AnchorPoint = Vector2.new(0.5, 0.5)
                    svCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    svCursor.BorderSizePixel = 0
                    svCursor.ZIndex = 5
                    svCursor.Position = UDim2.new(s, 0, 1 - v, 0)
                    Instance.new("UICorner", svCursor).CornerRadius = UDim.new(1, 0)

                    local hueBar = Instance.new("ImageLabel")
                    hueBar.Parent = f
                    hueBar.Size = UDim2.new(1, -30, 0, 14)
                    hueBar.Position = UDim2.new(0, 15, 0, 212)
                    hueBar.Image = "rbxassetid://698052001"
                    hueBar.ZIndex = 3
                    Instance.new("UICorner", hueBar).CornerRadius = UDim.new(0, 4)

                    local hueCursor = Instance.new("Frame")
                    hueCursor.Parent = hueBar
                    hueCursor.Size = UDim2.new(0, 5, 1, 4)
                    hueCursor.AnchorPoint = Vector2.new(0.5, 0)
                    hueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    hueCursor.BorderSizePixel = 0
                    hueCursor.ZIndex = 5
                    hueCursor.Position = UDim2.new(h, 0, 0, -2)
                    Instance.new("UICorner", hueCursor).CornerRadius = UDim.new(0, 2)

                    local hex = Instance.new("TextLabel")
                    hex.Parent = f
                    hex.BackgroundColor3 = colors.InpBg
                    hex.Position = UDim2.new(0, 15, 0, 236)
                    hex.Size = UDim2.new(1, -30, 0, 22)
                    hex.Font = Enum.Font.Code
                    hex.TextColor3 = colors.T2
                    hex.TextSize = 12
                    hex.ZIndex = 3
                    Instance.new("UICorner", hex).CornerRadius = UDim.new(0, 4)

                    local function update()
                        local col = Color3.fromHSV(h, s, v)
                        swatch.BackgroundColor3 = col
                        paletteImg.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                        local r = math.floor(col.R * 255)
                        local g = math.floor(col.G * 255)
                        local b = math.floor(col.B * 255)
                        hex.Text = string.format("  #%02X%02X%02X  (R:%d G:%d B:%d)", r, g, b, r, g, b)
                        svCursor.Position = UDim2.new(s, 0, 1 - v, 0)
                        hueCursor.Position = UDim2.new(h, 0, 0, -2)
                        cb(col)
                    end
                    update()

                    header.MouseButton1Click:Connect(function()
                        expanded = not expanded
                        if expanded then
                            tween(f, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {Size = UDim2.new(1, 0, 0, 270)})
                            tween(arrow, 0.3, nil, nil, {Rotation = -90})
                        else
                            tween(f, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {Size = UDim2.new(1, 0, 0, 42)})
                            tween(arrow, 0.3, nil, nil, {Rotation = 90})
                        end
                    end)
                    header.MouseEnter:Connect(function() tween(f, 0.2, nil, nil, {BackgroundColor3 = colors.BtnH}) end)
                    header.MouseLeave:Connect(function() tween(f, 0.2, nil, nil, {BackgroundColor3 = colors.BtnBg}) end)

                    paletteImg.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            svDrag = true
                            local x = math.clamp((input.Position.X - paletteImg.AbsolutePosition.X) / paletteImg.AbsoluteSize.X, 0, 1)
                            local y = math.clamp((input.Position.Y - paletteImg.AbsolutePosition.Y) / paletteImg.AbsoluteSize.Y, 0, 1)
                            s = x; v = 1 - y; update()
                        end
                    end)
                    paletteImg.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then svDrag = false end
                    end)

                    hueBar.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            hueDrag = true
                            local x = math.clamp((input.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
                            h = x; update()
                        end
                    end)
                    hueBar.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then hueDrag = false end
                    end)

                    UserInputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then
                            if svDrag then
                                local x = math.clamp((input.Position.X - paletteImg.AbsolutePosition.X) / paletteImg.AbsoluteSize.X, 0, 1)
                                local y = math.clamp((input.Position.Y - paletteImg.AbsolutePosition.Y) / paletteImg.AbsoluteSize.Y, 0, 1)
                                s = x; v = 1 - y; update()
                            elseif hueDrag then
                                local x = math.clamp((input.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
                                h = x; update()
                            end
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            svDrag = false; hueDrag = false
                        end
                    end)
                end
            end
        end

        setmetatable(Elements, elementMeta)
        return Elements
    end

    return Window
end

-- ============================================================
--  Silent Aim (вкладка Other)
-- ============================================================
local silentAimState = {
    enabled = false,
    active = false,
    conn = nil,
    keyConn = nil,
    toggleKey = Enum.KeyCode.E
}

local function findTarget()
    local cam = workspace.CurrentCamera
    if not cam then return nil end
    local center = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
    local bestScore = math.huge
    local bestTarget = nil
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Players.LocalPlayer and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildWhichIsA("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local pos, on = cam:WorldToViewportPoint(hrp.Position)
                if on then
                    local dist = (hrp.Position - cam.CFrame.Position).Magnitude
                    local angle = (center - Vector2.new(pos.X, pos.Y)).Magnitude
                    -- смесь угла и расстояния (чем ближе и ближе к центру, тем лучше)
                    local score = angle + dist * 0.1
                    if score < bestScore then
                        bestScore = score
                        bestTarget = hrp
                    end
                end
            end
        end
    end
    return bestTarget
end

local function silentAimLoop()
    if not silentAimState.enabled then return end
    if not silentAimState.active then return end
    local r = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local t = findTarget()
    if r and t then
        local p = t.Position + t.Velocity * 0.155
        r.CFrame = CFrame.lookAt(r.Position, Vector3.new(p.X, r.Position.Y, p.Z))
    end
end

function CoffeeUI:CreateSilentAim(options)
    local Window = options.Window
    local toggleKey = options.ToggleKey or Enum.KeyCode.E
    silentAimState.toggleKey = toggleKey

    local tab = Window:CreateTab("Other")

    tab:CreateToggle({
        Name = "Silent Aim",
        CurrentValue = false,
        Callback = function(val)
            if val then
                if silentAimState.conn then silentAimState.conn:Disconnect() end
                if silentAimState.keyConn then silentAimState.keyConn:Disconnect() end
                silentAimState.enabled = true
                silentAimState.active = false
                silentAimState.conn = RunService.RenderStepped:Connect(silentAimLoop)
                silentAimState.keyConn = UserInputService.InputBegan:Connect(function(input, gp)
                    if gp then return end
                    if input.KeyCode == silentAimState.toggleKey then
                        silentAimState.active = not silentAimState.active
                        CoffeeUI:Notify({Title = "Silent Aim", Content = silentAimState.active and "ACTIVE" or "INACTIVE", Duration = 1})
                    end
                end)
                CoffeeUI:Notify({Title = "Silent Aim", Content = "Enabled", Duration = 2})
            else
                if silentAimState.conn then silentAimState.conn:Disconnect(); silentAimState.conn = nil end
                if silentAimState.keyConn then silentAimState.keyConn:Disconnect(); silentAimState.keyConn = nil end
                silentAimState.enabled = false
                silentAimState.active = false
                CoffeeUI:Notify({Title = "Silent Aim", Content = "Disabled", Duration = 2})
            end
        end
    })

    return tab
end

function CoffeeUI:KeySystem(config)
    local validKey = config.Key or ""
    local linkURL = config.GetKeyURL or ""
    local title = config.Title or "COFFEE"
    local subtitle = config.Subtitle or "Enter your key to continue"

    if validKey == "" then return end

    local gui = Instance.new("ScreenGui")
    gui.Name = "CoffeeUI_KeySystem"
    gui.DisplayOrder = 9999
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = Parent

    local overlay = Instance.new("Frame", gui)
    overlay.Size = UDim2.fromScale(1,1)
    overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
    overlay.BackgroundTransparency = 1
    overlay.ZIndex = 100

    local card = Instance.new("Frame", gui)
    card.AnchorPoint = Vector2.new(0.5,0.5)
    card.Position = UDim2.fromScale(0.5, 0.52)
    card.Size = UDim2.fromOffset(360, 200)
    card.BackgroundColor3 = colors.KeyBg
    card.ZIndex = 101
    Instance.new("UICorner", card).CornerRadius = UDim.new(0,10)
    Instance.new("UIStroke", card).Color = colors.Stroke

    local shadow = Instance.new("Frame", card)
    shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
    shadow.Size = UDim2.new(1,10,1,10)
    shadow.Position = UDim2.new(0,-5,0,-5)
    shadow.BackgroundTransparency = 0.8
    shadow.ZIndex = -1
    Instance.new("UICorner", shadow).CornerRadius = UDim.new(0,14)

    local header = Instance.new("Frame", card)
    header.Size = UDim2.new(1,0,0,35)
    header.BackgroundColor3 = colors.KeyTop
    header.ZIndex = 102
    Instance.new("UICorner", header).CornerRadius = UDim.new(0,10)
    local hFix = Instance.new("Frame", header)
    hFix.BackgroundColor3 = colors.KeyTop
    hFix.Position = UDim2.new(0,0,1,-10)
    hFix.Size = UDim2.new(1,0,0,10)
    local hDiv = Instance.new("Frame", header)
    hDiv.BackgroundColor3 = colors.Stroke
    hDiv.Position = UDim2.new(0,0,1,-1)
    hDiv.Size = UDim2.new(1,0,0,1)

    local titleL = Instance.new("TextLabel", header)
    titleL.BackgroundTransparency = 1
    titleL.Position = UDim2.new(0,15,0,0)
    titleL.Size = UDim2.new(1,-20,1,0)
    titleL.Font = Enum.Font.Ubuntu
    titleL.Text = title
    titleL.TextColor3 = colors.T1
    titleL.TextSize = 14
    titleL.TextXAlignment = Enum.TextXAlignment.Left
    titleL.ZIndex = 103

    local subL = Instance.new("TextLabel", card)
    subL.BackgroundTransparency = 1
    subL.Position = UDim2.new(0,18,0,46)
    subL.Size = UDim2.new(1,-36,0,18)
    subL.Font = Enum.Font.Ubuntu
    subL.Text = subtitle
    subL.TextColor3 = colors.T2
    subL.TextSize = 13
    subL.TextXAlignment = Enum.TextXAlignment.Left
    subL.ZIndex = 102

    local iBg = Instance.new("Frame", card)
    iBg.Size = UDim2.new(1,-36,0,36)
    iBg.Position = UDim2.new(0,18,0,74)
    iBg.BackgroundColor3 = colors.InputBg
    iBg.ZIndex = 102
    Instance.new("UICorner", iBg).CornerRadius = UDim.new(0,8)
    local iStroke = Instance.new("UIStroke", iBg)
    iStroke.Color = colors.Stroke

    local box = Instance.new("TextBox", iBg)
    box.Size = UDim2.new(1,-14,1,0)
    box.Position = UDim2.new(0,7,0,0)
    box.BackgroundTransparency = 1
    box.Text = ""
    box.PlaceholderText = "Paste your key here..."
    box.PlaceholderColor3 = colors.T2
    box.TextColor3 = colors.T1
    box.Font = Enum.Font.Code
    box.TextSize = 13
    box.ClearTextOnFocus = false
    box.ZIndex = 103

    local status = Instance.new("TextLabel", card)
    status.BackgroundTransparency = 1
    status.Position = UDim2.new(0,18,0,118)
    status.Size = UDim2.new(1,-36,0,16)
    status.Font = Enum.Font.Ubuntu
    status.Text = ""
    status.TextColor3 = colors.T2
    status.TextSize = 12
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.ZIndex = 102

    local btnY = 143
    local function makeBtn(text, xOff, width, primary)
        local b = Instance.new("TextButton", card)
        b.Size = UDim2.new(0, width, 0, 32)
        b.Position = UDim2.new(0, xOff, 0, btnY)
        b.BackgroundColor3 = colors.BtnBg
        b.AutoButtonColor = false
        b.Font = Enum.Font.Ubuntu
        b.Text = "   "..text
        b.TextColor3 = primary and colors.T1 or colors.T2
        b.TextSize = 13
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.ZIndex = 102
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
        local bs = Instance.new("UIStroke", b)
        bs.Color = colors.Stroke
        if primary then
            local ind = Instance.new("Frame", b)
            ind.BackgroundColor3 = colors.Acc
            ind.Size = UDim2.new(0,3,0,14)
            ind.Position = UDim2.new(0,0,0.5,-7)
            Instance.new("UICorner", ind).CornerRadius = UDim.new(1,0)
        end
        b.MouseEnter:Connect(function()
            tween(b, 0.2, nil, nil, {BackgroundColor3 = colors.BtnH})
            tween(bs, 0.2, nil, nil, {Color = colors.Acc})
        end)
        b.MouseLeave:Connect(function()
            tween(b, 0.2, nil, nil, {BackgroundColor3 = colors.BtnBg})
            tween(bs, 0.2, nil, nil, {Color = colors.Stroke})
        end)
        return b
    end
    local w = (420-36-8)/2
    local getBtn = makeBtn("Get Key", 18, w, false)
    local submitBtn = makeBtn("Submit", 18+w+8, w, true)

    local footer = Instance.new("TextLabel", card)
    footer.BackgroundTransparency = 1
    footer.Position = UDim2.new(0,18,1,-22)
    footer.Size = UDim2.new(1,-36,0,14)
    footer.Font = Enum.Font.Ubuntu
    footer.Text = "coffee library"
    footer.TextColor3 = colors.T2
    footer.TextSize = 11
    footer.TextXAlignment = Enum.TextXAlignment.Left
    footer.ZIndex = 102

    tween(overlay, 0.4, nil, nil, {BackgroundTransparency = 0.35})
    tween(card, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {Size = UDim2.fromOffset(420,195), Position = UDim2.fromScale(0.5,0.5)})

    box.Focused:Connect(function() tween(iStroke, 0.2, nil, nil, {Color = colors.Acc, Thickness = 1.5}) end)
    box.FocusLost:Connect(function() tween(iStroke, 0.2, nil, nil, {Color = colors.Stroke, Thickness = 1}) end)

    local function shake()
        local orig = card.Position
        for i = 1,7 do
            card.Position = orig + UDim2.fromOffset(i%2==0 and 7 or -7, 0)
            task.wait(0.035)
        end
        card.Position = orig
    end

    getBtn.MouseButton1Click:Connect(function()
        pcall(function() setclipboard(linkURL) end)
        status.TextColor3 = Color3.fromRGB(130,190,130)
        status.Text = "Link copied to clipboard."
    end)

    local done = false
    local function tryKey()
        if string.gsub(box.Text, "%s+", "") == string.gsub(validKey, "%s+", "") then
            done = true
            status.TextColor3 = Color3.fromRGB(130,190,130)
            status.Text = "Key accepted. Loading..."
            tween(card, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In, {Size=UDim2.fromOffset(360,160), Position=UDim2.fromScale(0.5,0.52)})
            tween(overlay, 0.35, nil, nil, {BackgroundTransparency = 1})
            task.delay(0.4, function() gui:Destroy() end)
        else
            status.TextColor3 = Color3.fromRGB(190,120,120)
            status.Text = "Invalid key. Click 'Get Key' to receive yours."
            task.spawn(shake)
        end
    end

    submitBtn.MouseButton1Click:Connect(tryKey)
    box.FocusLost:Connect(function(enter) if enter then tryKey() end end)

    repeat task.wait(0.05) until done
end

return CoffeeUI
