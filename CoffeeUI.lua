local CoffeeUI = {}

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ParentGui = CoreGui
if gethui then ParentGui = gethui() elseif set_thread_identity then set_thread_identity(8) end

-- ==============================================
--  ТЕМА ТЕПЕРЬ ВСЕГДА LIGHT (убрал выбор)
-- ==============================================
local Themes = {
    Light = {
        Background = Color3.fromRGB(240, 240, 245),
        Sidebar = Color3.fromRGB(230, 230, 235),
        Topbar = Color3.fromRGB(230, 230, 235),
        Stroke = Color3.fromRGB(180, 180, 185),
        TextPrimary = Color3.fromRGB(20, 20, 25),
        TextSecondary = Color3.fromRGB(80, 80, 85),
        Accent = Color3.fromRGB(50, 50, 55),
        InputBg = Color3.fromRGB(220, 220, 225),
        ButtonBg = Color3.fromRGB(210, 210, 215),
        ButtonHover = Color3.fromRGB(200, 200, 205),
        ToggleBg = Color3.fromRGB(200, 200, 205),
        ToggleOff = Color3.fromRGB(150, 150, 150),
        ToggleOn = Color3.fromRGB(50, 50, 55),
        DropdownBg = Color3.fromRGB(210, 210, 215),
        DropdownList = Color3.fromRGB(220, 220, 225),
        SliderBg = Color3.fromRGB(200, 200, 205),
        SliderFill = Color3.fromRGB(50, 50, 55),
        InputBoxBg = Color3.fromRGB(200, 200, 205),
        LabelColor = Color3.fromRGB(80, 80, 85),
        Separator = Color3.fromRGB(180, 180, 185),
        NotificationBg = Color3.fromRGB(230, 230, 235),
        KeySystemBg = Color3.fromRGB(240, 240, 245),
        KeySystemHeader = Color3.fromRGB(230, 230, 235),
    }
}

local CurrentTheme = "Light"
local Colors = Themes.Light

-- Create ScreenGui
local ScreenObject = Instance.new("ScreenGui")
ScreenObject.Name = "CoffeeUI_Environment"
ScreenObject.IgnoreGuiInset = true
ScreenObject.ResetOnSpawn = false
ScreenObject.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenObject.Parent = ParentGui

if ParentGui:FindFirstChild("CoffeeUI_Environment") then
    for _, v in pairs(ParentGui:GetChildren()) do
        if v.Name == "CoffeeUI_Environment" and v ~= ScreenObject then v:Destroy() end
    end
end

-- Notification Container
local NotifContainer = Instance.new("Frame")
NotifContainer.Name = "NotifContainer"
NotifContainer.Parent = ScreenObject
NotifContainer.BackgroundTransparency = 1
NotifContainer.Position = UDim2.new(1, -320, 1, -20)
NotifContainer.Size = UDim2.new(0, 300, 1, 0)
NotifContainer.AnchorPoint = Vector2.new(0, 1)

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.Parent = NotifContainer
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Padding = UDim.new(0, 10)

-- Core Functions
local Utility = {}
function Utility:Tween(object, info, properties)
    local t = TweenService:Create(object, TweenInfo.new(unpack(info)), properties)
    t:Play()
    return t
end

function Utility:MakeDraggable(topbar, object)
    local Dragging, DragInput, DragStart, StartPosition
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true; DragStart = input.Position; StartPosition = object.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then Dragging = false end end)
        end
    end)
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local delta = input.Position - DragStart
            Utility:Tween(object, {0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out}, {
                Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + delta.Y)
            })
        end
    end)
end

-- Notification System
function CoffeeUI:Notify(options)
    local title = options.Title or "Notification"
    local content = options.Content or "Notification content."
    local duration = options.Duration or 3

    local NotifFrame = Instance.new("Frame")
    NotifFrame.Name = "Notification"; NotifFrame.Parent = NotifContainer
    NotifFrame.BackgroundColor3 = Colors.NotificationBg; NotifFrame.BorderSizePixel = 0
    NotifFrame.Size = UDim2.new(1, 40, 0, 0); NotifFrame.Position = UDim2.new(1, 50, 0, 0)
    NotifFrame.ClipsDescendants = true; NotifFrame.BackgroundTransparency = 1
    Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 8)

    local NotifStroke = Instance.new("UIStroke", NotifFrame)
    NotifStroke.Color = Colors.Stroke; NotifStroke.Thickness = 1; NotifStroke.Transparency = 1

    local NotifTitle = Instance.new("TextLabel")
    NotifTitle.Parent = NotifFrame; NotifTitle.BackgroundTransparency = 1
    NotifTitle.Position = UDim2.new(0, 15, 0, 10); NotifTitle.Size = UDim2.new(1, -30, 0, 20)
    NotifTitle.Font = Enum.Font.Ubuntu; NotifTitle.Text = title; NotifTitle.TextColor3 = Colors.TextPrimary
    NotifTitle.TextSize = 14; NotifTitle.TextXAlignment = Enum.TextXAlignment.Left; NotifTitle.TextTransparency = 1

    local NotifText = Instance.new("TextLabel")
    NotifText.Parent = NotifFrame; NotifText.BackgroundTransparency = 1
    NotifText.Position = UDim2.new(0, 15, 0, 32); NotifText.Size = UDim2.new(1, -30, 0, 40)
    NotifText.Font = Enum.Font.Ubuntu; NotifText.Text = content; NotifText.TextColor3 = Colors.TextSecondary
    NotifText.TextSize = 13; NotifText.TextXAlignment = Enum.TextXAlignment.Left; NotifText.TextYAlignment = Enum.TextYAlignment.Top
    NotifText.TextWrapped = true; NotifText.TextTransparency = 1

    local ProgressBarBG = Instance.new("Frame")
    ProgressBarBG.Parent = NotifFrame; ProgressBarBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ProgressBarBG.Position = UDim2.new(0, 15, 1, -8); ProgressBarBG.Size = UDim2.new(1, -30, 0, 3)
    ProgressBarBG.BorderSizePixel = 0; ProgressBarBG.BackgroundTransparency = 1
    Instance.new("UICorner", ProgressBarBG).CornerRadius = UDim.new(1, 0)

    local ProgressBar = Instance.new("Frame")
    ProgressBar.Parent = ProgressBarBG; ProgressBar.BackgroundColor3 = Colors.Accent
    ProgressBar.Size = UDim2.new(1, 0, 1, 0); ProgressBar.BorderSizePixel = 0; ProgressBar.BackgroundTransparency = 1
    Instance.new("UICorner", ProgressBar).CornerRadius = UDim.new(1, 0)

    local bounds = TextService:GetTextSize(content, 13, Enum.Font.Ubuntu, Vector2.new(270, math.huge))
    local totalHeight = 55 + bounds.Y

    Utility:Tween(NotifFrame, {0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out}, {Size = UDim2.new(1, 0, 0, totalHeight), BackgroundTransparency = 0})
    Utility:Tween(NotifStroke, {0.4}, {Transparency = 0})
    Utility:Tween(NotifTitle, {0.3}, {TextTransparency = 0})
    Utility:Tween(NotifText, {0.3}, {TextTransparency = 0})
    Utility:Tween(ProgressBarBG, {0.3}, {BackgroundTransparency = 0})
    Utility:Tween(ProgressBar, {0.3}, {BackgroundTransparency = 0})
    Utility:Tween(ProgressBar, {duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In}, {Size = UDim2.new(0, 0, 1, 0)})

    task.delay(duration, function()
        Utility:Tween(NotifTitle, {0.3}, {TextTransparency = 1})
        Utility:Tween(NotifText, {0.3}, {TextTransparency = 1})
        Utility:Tween(ProgressBarBG, {0.3}, {BackgroundTransparency = 1})
        Utility:Tween(ProgressBar, {0.3}, {BackgroundTransparency = 1})
        local hideTween = Utility:Tween(NotifFrame, {0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In}, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
        Utility:Tween(NotifStroke, {0.4}, {Transparency = 1})
        hideTween.Completed:Connect(function() NotifFrame:Destroy() end)
    end)
end

function CoffeeUI:CreateWindow(options)
    local WindowName = options.Name or "CoffeeUI"
    local HideKey = options.HideKey or Enum.KeyCode.K

    local WindowOpen = false
    local isAnimating = false

    -- Loading Screen Fullscreen
    local IntroOverlay = Instance.new("Frame")
    IntroOverlay.Name = "IntroOverlay"; IntroOverlay.Parent = ScreenObject
    IntroOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0); IntroOverlay.Position = UDim2.new(0, 0, 0, 0)
    IntroOverlay.Size = UDim2.new(1, 0, 1, 0); IntroOverlay.ZIndex = 100; IntroOverlay.BackgroundTransparency = 1

    local IntroTitle = Instance.new("TextLabel")
    IntroTitle.Parent = IntroOverlay; IntroTitle.BackgroundTransparency = 1
    IntroTitle.Position = UDim2.new(0.5, -200, 0.5, -40); IntroTitle.Size = UDim2.new(0, 400, 0, 80)
    IntroTitle.Font = Enum.Font.Code; IntroTitle.Text = "Developed by Coffee"
    IntroTitle.TextColor3 = Color3.fromRGB(240, 240, 240); IntroTitle.TextScaled = true; IntroTitle.TextTransparency = 1

    -- Main UI Elements
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"; MainFrame.Parent = ScreenObject
    MainFrame.BackgroundColor3 = Colors.Background; MainFrame.Position = UDim2.new(0.5, -325, 0.5, -200)
    MainFrame.Size = UDim2.new(0, 650, 0, 400); MainFrame.Visible = false
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    local MainStroke = Instance.new("UIStroke", MainFrame); MainStroke.Color = Colors.Stroke; MainStroke.Thickness = 1

    -- Drop Shadow (Fake)
    local ShadowFrame = Instance.new("Frame")
    ShadowFrame.Name = "Shadow"; ShadowFrame.Parent = MainFrame
    ShadowFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0); ShadowFrame.Size = UDim2.new(1, 10, 1, 10)
    ShadowFrame.Position = UDim2.new(0, -5, 0, -5); ShadowFrame.BackgroundTransparency = 0.8; ShadowFrame.ZIndex = -1
    Instance.new("UICorner", ShadowFrame).CornerRadius = UDim.new(0, 14)

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"; Sidebar.Parent = MainFrame; Sidebar.BackgroundColor3 = Colors.Sidebar
    Sidebar.Position = UDim2.new(0, 0, 0, 35); Sidebar.Size = UDim2.new(0, 180, 1, -35); Sidebar.BorderSizePixel = 0
    Sidebar.ClipsDescendants = true; Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)
    local SidebarFix = Instance.new("Frame", Sidebar); SidebarFix.BackgroundColor3 = Colors.Sidebar; SidebarFix.Position = UDim2.new(1, -10, 0, 0); SidebarFix.Size = UDim2.new(0, 10, 1, 0)
    local SidebarFixTop = Instance.new("Frame", Sidebar); SidebarFixTop.BackgroundColor3 = Colors.Sidebar; SidebarFixTop.Position = UDim2.new(0, 0, 0, 0); SidebarFixTop.Size = UDim2.new(1, 0, 0, 10)
    local SidebarDivider = Instance.new("Frame", Sidebar); SidebarDivider.BackgroundColor3 = Colors.Stroke; SidebarDivider.Position = UDim2.new(1, 0, 0, 0); SidebarDivider.Size = UDim2.new(0, 1, 1, 0)

    -- Topbar
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"; Topbar.Parent = MainFrame; Topbar.BackgroundColor3 = Colors.Topbar
    Topbar.Size = UDim2.new(1, 0, 0, 35); Topbar.BorderSizePixel = 0; Topbar.ZIndex = 5
    Instance.new("UICorner", Topbar).CornerRadius = UDim.new(0, 10)
    local TopbarFix = Instance.new("Frame", Topbar); TopbarFix.BackgroundColor3 = Colors.Topbar; TopbarFix.Position = UDim2.new(0, 0, 1, -10); TopbarFix.Size = UDim2.new(1, 0, 0, 10)
    local TopbarDivider = Instance.new("Frame", Topbar); TopbarDivider.BackgroundColor3 = Colors.Stroke; TopbarDivider.Position = UDim2.new(0, 0, 1, -1); TopbarDivider.Size = UDim2.new(1, 0, 0, 1)

    Utility:MakeDraggable(Topbar, MainFrame)

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = Topbar; CloseBtn.BackgroundTransparency = 1; CloseBtn.Position = UDim2.new(1, -40, 0, 0)
    CloseBtn.Size = UDim2.new(0, 40, 1, 0); CloseBtn.Font = Enum.Font.Ubuntu; CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Colors.TextSecondary; CloseBtn.TextSize = 14; CloseBtn.AutoButtonColor = false
    CloseBtn.MouseEnter:Connect(function() Utility:Tween(CloseBtn, {0.2}, {TextColor3 = Color3.fromRGB(255, 100, 100)}) end)
    CloseBtn.MouseLeave:Connect(function() Utility:Tween(CloseBtn, {0.2}, {TextColor3 = Colors.TextSecondary}) end)

    local MainTitle = Instance.new("TextLabel")
    MainTitle.Parent = Topbar; MainTitle.BackgroundTransparency = 1; MainTitle.Position = UDim2.new(0, 15, 0, 0)
    MainTitle.Size = UDim2.new(1, -60, 1, 0); MainTitle.Font = Enum.Font.Ubuntu; MainTitle.Text = WindowName
    MainTitle.TextColor3 = Colors.TextPrimary; MainTitle.TextSize = 14; MainTitle.TextXAlignment = Enum.TextXAlignment.Left
    MainTitle.TextYAlignment = Enum.TextYAlignment.Center; MainTitle.TextTruncate = Enum.TextTruncate.AtEnd

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"; TabContainer.Parent = Sidebar; TabContainer.Active = true; TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 0, 0, 10); TabContainer.Size = UDim2.new(1, 0, 1, -80)
    TabContainer.ScrollBarThickness = 2; TabContainer.ScrollBarImageColor3 = Colors.Stroke

    local TabList = Instance.new("UIListLayout"); TabList.Parent = TabContainer; TabList.SortOrder = Enum.SortOrder.LayoutOrder; TabList.Padding = UDim.new(0, 5)
    local TabPadding = Instance.new("UIPadding"); TabPadding.Parent = TabContainer; TabPadding.PaddingTop = UDim.new(0, 5); TabPadding.PaddingLeft = UDim.new(0, 10); TabPadding.PaddingRight = UDim.new(0, 10)
    TabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabList.AbsoluteContentSize.Y + 15) end)

    -- Player Profile
    local ProfileFrame = Instance.new("Frame")
    ProfileFrame.Name = "ProfileFrame"; ProfileFrame.Parent = Sidebar; ProfileFrame.BackgroundTransparency = 1
    ProfileFrame.Position = UDim2.new(0, 10, 1, -60); ProfileFrame.Size = UDim2.new(1, -20, 0, 50); ProfileFrame.ClipsDescendants = true

    local AvatarImage = Instance.new("ImageLabel")
    AvatarImage.Parent = ProfileFrame; AvatarImage.BackgroundColor3 = Color3.fromRGB(40, 40, 45); AvatarImage.Size = UDim2.new(0, 34, 0, 34)
    AvatarImage.Position = UDim2.new(0, 0, 0.5, -17); Instance.new("UICorner", AvatarImage).CornerRadius = UDim.new(1, 0)

    local NameLab = Instance.new("TextLabel")
    NameLab.Parent = ProfileFrame; NameLab.BackgroundTransparency = 1; NameLab.Position = UDim2.new(0, 42, 0, 8)
    NameLab.Size = UDim2.new(1, -42, 0, 16); NameLab.Font = Enum.Font.Ubuntu; NameLab.Text = LocalPlayer and LocalPlayer.Name or "Unknown"
    NameLab.TextColor3 = Colors.TextPrimary; NameLab.TextSize = 13; NameLab.TextXAlignment = Enum.TextXAlignment.Left; NameLab.TextTruncate = Enum.TextTruncate.AtEnd

    local GameLab = Instance.new("TextLabel")
    GameLab.Parent = ProfileFrame; GameLab.BackgroundTransparency = 1; GameLab.Position = UDim2.new(0, 42, 0, 24)
    GameLab.Size = UDim2.new(1, -42, 0, 14); GameLab.Font = Enum.Font.Ubuntu; GameLab.Text = "Loading..."
    GameLab.TextColor3 = Colors.TextSecondary; GameLab.TextSize = 11; GameLab.TextXAlignment = Enum.TextXAlignment.Left; GameLab.TextTruncate = Enum.TextTruncate.AtEnd

    task.spawn(function()
        if LocalPlayer then
            local success, avatarUrl = pcall(function() return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end)
            if success then AvatarImage.Image = avatarUrl end
        end
    end)
    task.spawn(function()
        local success, info = pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId) end)
        if success and info and info.Name then GameLab.Text = info.Name else GameLab.Text = "Unknown Game" end
    end)

    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"; ContentArea.Parent = MainFrame; ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 181, 0, 35); ContentArea.Size = UDim2.new(1, -181, 1, -35)

    -- Loading Animation (сначала чёрный экран, потом плавное появление окна)
    task.spawn(function()
        Utility:Tween(IntroOverlay, {0.5}, {BackgroundTransparency = 0}); task.wait(0.6)
        Utility:Tween(IntroTitle, {1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {TextTransparency = 0})
        Utility:Tween(IntroTitle, {1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut}, {Size = UDim2.new(0, 480, 0, 96), Position = UDim2.new(0.5, -240, 0.5, -48)})
        task.wait(1.5)
        Utility:Tween(IntroTitle, {0.6}, {TextTransparency = 1, Size = UDim2.new(0, 600, 0, 120), Position = UDim2.new(0.5, -300, 0.5, -60)})
        task.wait(0.7)
        
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 100, 0, 100)
        MainFrame.Position = UDim2.new(0.5, -50, 0.5, -50)
        MainFrame.BackgroundTransparency = 1
        
        task.delay(1.5, function() if IntroOverlay and IntroOverlay.Parent then IntroOverlay:Destroy() end end)
        local fadeBg = Utility:Tween(IntroOverlay, {0.8}, {BackgroundTransparency = 1})
        
        -- Плавное вырастание при первом открытии (1 секунда)
        Utility:Tween(MainFrame, {1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {
            Size = UDim2.new(0, 650, 0, 400),
            Position = UDim2.new(0.5, -325, 0.5, -200),
            BackgroundTransparency = 0
        })
        
        fadeBg.Completed:Connect(function()
            if IntroOverlay and IntroOverlay.Parent then IntroOverlay:Destroy() end
            WindowOpen = true
            CoffeeUI:Notify({Title = "Loaded", Content = "CoffeeUI loaded successfully.", Duration = 4})
        end)
    end)

    -- ============================================================
    --  НОВАЯ АНИМАЦИЯ ОТКРЫТИЯ / ЗАКРЫТИЯ: 1 сек, в центре экрана
    -- ============================================================
    local function ToggleUI(state)
        if isAnimating then return end
        isAnimating = true
        WindowOpen = state
        if WindowOpen then
            MainFrame.Visible = true
            MainFrame.Size = UDim2.new(0, 100, 0, 100)
            MainFrame.Position = UDim2.new(0.5, -50, 0.5, -50)
            MainFrame.BackgroundTransparency = 1

            Utility:Tween(MainFrame, {1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {
                Size = UDim2.new(0, 650, 0, 400),
                Position = UDim2.new(0.5, -325, 0.5, -200),
                BackgroundTransparency = 0
            }).Completed:Connect(function()
                isAnimating = false
            end)
        else
            Utility:Tween(MainFrame, {1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {
                Size = UDim2.new(0, 100, 0, 100),
                Position = UDim2.new(0.5, -50, 0.5, -50),
                BackgroundTransparency = 1
            }).Completed:Connect(function()
                if not WindowOpen then
                    MainFrame.Visible = false
                    MainFrame.Size = UDim2.new(0, 650, 0, 400)
                    MainFrame.Position = UDim2.new(0.5, -325, 0.5, -200)
                    MainFrame.BackgroundTransparency = 0
                end
                isAnimating = false
            end)
        end
    end

    CloseBtn.MouseButton1Click:Connect(function() if WindowOpen then ToggleUI(false) end end)
    UserInputService.InputBegan:Connect(function(input, gp) if gp then return end; if input.KeyCode == HideKey and not ParentGui:FindFirstChild("IntroOverlay") then ToggleUI(not WindowOpen) end end)

    local Window = {}; local Pages = {}; local activeTabBtn = nil

    function Window:CreateTab(tabName)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = tabName.."_Btn"; TabBtn.Parent = TabContainer; TabBtn.BackgroundColor3 = Colors.ButtonBg; TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(1, 0, 0, 36); TabBtn.Font = Enum.Font.Ubuntu; TabBtn.Text = "   " .. tabName
        TabBtn.TextColor3 = Colors.TextSecondary; TabBtn.TextSize = 14; TabBtn.TextXAlignment = Enum.TextXAlignment.Left; TabBtn.AutoButtonColor = false
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
        local SelectedIndicator = Instance.new("Frame")
        SelectedIndicator.Parent = TabBtn; SelectedIndicator.BackgroundColor3 = Colors.Accent; SelectedIndicator.Size = UDim2.new(0, 3, 0, 0)
        SelectedIndicator.Position = UDim2.new(0, 0, 0.5, 0); SelectedIndicator.AnchorPoint = Vector2.new(0, 0.5)
        Instance.new("UICorner", SelectedIndicator).CornerRadius = UDim.new(1, 0)

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = tabName.."_Page"; TabPage.Parent = ContentArea; TabPage.Active = true; TabPage.BackgroundTransparency = 1
        TabPage.Size = UDim2.new(1, 0, 1, 0); TabPage.ScrollBarThickness = 3; TabPage.ScrollBarImageColor3 = Colors.Stroke
        TabPage.Visible = false; TabPage.CanvasSize = UDim2.new(0,0,0,0); table.insert(Pages, TabPage)

        local PageLayout = Instance.new("UIListLayout"); PageLayout.Parent = TabPage; PageLayout.SortOrder = Enum.SortOrder.LayoutOrder; PageLayout.Padding = UDim.new(0, 10)
        local PagePadding = Instance.new("UIPadding"); PagePadding.Parent = TabPage; PagePadding.PaddingTop = UDim.new(0, 10); PagePadding.PaddingBottom = UDim.new(0, 20); PagePadding.PaddingLeft = UDim.new(0, 20); PagePadding.PaddingRight = UDim.new(0, 20)
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 30) end)

        local function ActivateTab()
            for _, child in pairs(TabContainer:GetChildren()) do if child:IsA("TextButton") then Utility:Tween(child, {0.3}, {BackgroundTransparency = 1, TextColor3 = Colors.TextSecondary}); local ind = child:FindFirstChild("Frame"); if ind then Utility:Tween(ind, {0.3}, {Size = UDim2.new(0, 3, 0, 0)}) end end end
            for _, page in pairs(Pages) do if page.Visible then page.Visible = false; page.Position = UDim2.new(0, 10, 0, 0) end end
            Utility:Tween(TabBtn, {0.3}, {BackgroundTransparency = 0, TextColor3 = Colors.TextPrimary})
            Utility:Tween(SelectedIndicator, {0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out}, {Size = UDim2.new(0, 3, 0, 18)})
            TabPage.Visible = true; Utility:Tween(TabPage, {0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {Position = UDim2.new(0, 0, 0, 0)})
        end
        TabBtn.MouseButton1Click:Connect(ActivateTab)
        if #Pages == 1 then ActivateTab() end

        local Elements = {}
        function Elements:CreateButton(options)
            local name = options.Name or "Button"; local callback = options.Callback or function() end
            local ButtonFrame = Instance.new("Frame"); ButtonFrame.Parent = TabPage; ButtonFrame.BackgroundColor3 = Colors.ButtonBg; ButtonFrame.Size = UDim2.new(1, 0, 0, 42)
            Instance.new("UICorner", ButtonFrame).CornerRadius = UDim.new(0, 6)
            local BtnStroke = Instance.new("UIStroke", ButtonFrame); BtnStroke.Color = Colors.Stroke
            local BtnButton = Instance.new("TextButton"); BtnButton.Parent = ButtonFrame; BtnButton.BackgroundTransparency = 1; BtnButton.Size = UDim2.new(1, 0, 1, 0); BtnButton.Text = ""
            local BtnText = Instance.new("TextLabel"); BtnText.Parent = ButtonFrame; BtnText.BackgroundTransparency = 1; BtnText.Position = UDim2.new(0, 15, 0, 0); BtnText.Size = UDim2.new(1, -30, 1, 0); BtnText.Font = Enum.Font.Ubuntu; BtnText.Text = name; BtnText.TextColor3 = Colors.TextPrimary; BtnText.TextSize = 14; BtnText.TextXAlignment = Enum.TextXAlignment.Left
            local BtnIcon = Instance.new("ImageLabel"); BtnIcon.Parent = ButtonFrame; BtnIcon.BackgroundTransparency = 1; BtnIcon.Position = UDim2.new(1, -30, 0.5, -8); BtnIcon.Size = UDim2.new(0, 16, 0, 16); BtnIcon.Image = "rbxassetid://10888331510"; BtnIcon.ImageColor3 = Colors.TextSecondary
            BtnButton.MouseEnter:Connect(function() Utility:Tween(ButtonFrame, {0.2}, {BackgroundColor3 = Colors.ButtonHover}); Utility:Tween(BtnIcon, {0.2}, {Position = UDim2.new(1, -25, 0.5, -8), ImageColor3 = Colors.TextPrimary}) end)
            BtnButton.MouseLeave:Connect(function() Utility:Tween(ButtonFrame, {0.2}, {BackgroundColor3 = Colors.ButtonBg}); Utility:Tween(BtnIcon, {0.2}, {Position = UDim2.new(1, -30, 0.5, -8), ImageColor3 = Colors.TextSecondary}) end)
            BtnButton.MouseButton1Down:Connect(function() Utility:Tween(ButtonFrame, {0.1}, {Size = UDim2.new(1, -4, 0, 38)}); Utility:Tween(BtnStroke, {0.1}, {Color = Colors.Accent}) end)
            BtnButton.MouseButton1Up:Connect(function() Utility:Tween(ButtonFrame, {0.1}, {Size = UDim2.new(1, 0, 0, 42)}); Utility:Tween(BtnStroke, {0.1}, {Color = Colors.Stroke}); callback() end)
        end

        function Elements:CreateToggle(options)
            local name = options.Name or "Toggle"; local default = options.CurrentValue or false; local callback = options.Callback or function() end
            local ToggleFrame = Instance.new("Frame"); ToggleFrame.Parent = TabPage; ToggleFrame.BackgroundColor3 = Colors.ButtonBg; ToggleFrame.Size = UDim2.new(1, 0, 0, 42)
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)
            local TglStroke = Instance.new("UIStroke", ToggleFrame); TglStroke.Color = Colors.Stroke
            local TglButton = Instance.new("TextButton"); TglButton.Parent = ToggleFrame; TglButton.BackgroundTransparency = 1; TglButton.Size = UDim2.new(1, 0, 1, 0); TglButton.Text = ""
            local TglText = Instance.new("TextLabel"); TglText.Parent = ToggleFrame; TglText.BackgroundTransparency = 1; TglText.Position = UDim2.new(0, 15, 0, 0); TglText.Size = UDim2.new(1, -60, 1, 0); TglText.Font = Enum.Font.Ubuntu; TglText.Text = name; TglText.TextColor3 = Colors.TextPrimary; TglText.TextSize = 14; TglText.TextXAlignment = Enum.TextXAlignment.Left
            local SliderBG = Instance.new("Frame"); SliderBG.Parent = ToggleFrame; SliderBG.BackgroundColor3 = Colors.ToggleBg; SliderBG.Position = UDim2.new(1, -45, 0.5, -12); SliderBG.Size = UDim2.new(0, 36, 0, 24); Instance.new("UICorner", SliderBG).CornerRadius = UDim.new(1, 0)
            local SStroke = Instance.new("UIStroke", SliderBG); SStroke.Color = Colors.Stroke
            local SliderCircle = Instance.new("Frame"); SliderCircle.Parent = SliderBG; SliderCircle.BackgroundColor3 = Colors.ToggleOff; SliderCircle.Position = UDim2.new(0, 4, 0.5, -8); SliderCircle.Size = UDim2.new(0, 16, 0, 16); Instance.new("UICorner", SliderCircle).CornerRadius = UDim.new(1, 0)
            local toggled = default
            local function updateToggle(anim)
                local time = anim and 0.25 or 0
                if toggled then Utility:Tween(SliderBG, {time}, {BackgroundColor3 = Colors.ToggleOn}); Utility:Tween(SliderCircle, {time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {Position = UDim2.new(1, -20, 0.5, -8), BackgroundColor3 = Colors.ButtonBg}); Utility:Tween(SStroke, {time}, {Color = Colors.ToggleOn})
                else Utility:Tween(SliderBG, {time}, {BackgroundColor3 = Colors.ToggleBg}); Utility:Tween(SliderCircle, {time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {Position = UDim2.new(0, 4, 0.5, -8), BackgroundColor3 = Colors.ToggleOff}); Utility:Tween(SStroke, {time}, {Color = Colors.Stroke}) end
            end
            updateToggle(false)
            TglButton.MouseButton1Click:Connect(function() toggled = not toggled; updateToggle(true); callback(toggled) end)
            TglButton.MouseEnter:Connect(function() Utility:Tween(ToggleFrame, {0.2}, {BackgroundColor3 = Colors.ButtonHover}) end)
            TglButton.MouseLeave:Connect(function() Utility:Tween(ToggleFrame, {0.2}, {BackgroundColor3 = Colors.ButtonBg}) end)
        end

        function Elements:CreateSlider(options)
            local name = options.Name or "Slider"; local min = options.Range[1] or 0; local max = options.Range[2] or 100; local default = options.CurrentValue or min; local increment = options.Increment or 1; local callback = options.Callback or function() end
            local isFloat = (increment < 1) or (math.floor(min) ~= min) or (math.floor(max) ~= max); local decimals = 0
            if isFloat then local s = tostring(increment); local dot = s:find("%."); decimals = dot and (#s - dot) or 2 end
            local function snap(v)
                if increment <= 0 then return v end; local snapped = math.floor((v - min) / increment + 0.5) * increment + min; snapped = math.clamp(snapped, min, max)
                if isFloat then return tonumber(string.format("%%.%df" % decimals, snapped)) end; return math.floor(snapped + 0.5)
            end
            local function fmt(v) if isFloat then return string.format("%%.%df" % decimals, v) end; return tostring(math.floor(v + 0.5)) end
            local SliderFrame = Instance.new("Frame"); SliderFrame.Parent = TabPage; SliderFrame.BackgroundColor3 = Colors.ButtonBg; SliderFrame.Size = UDim2.new(1, 0, 0, 60)
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6); local SStroke = Instance.new("UIStroke", SliderFrame); SStroke.Color = Colors.Stroke
            local TitleLab = Instance.new("TextLabel"); TitleLab.Parent = SliderFrame; TitleLab.BackgroundTransparency = 1; TitleLab.Position = UDim2.new(0, 15, 0, 10); TitleLab.Size = UDim2.new(1, -30, 0, 20); TitleLab.Font = Enum.Font.Ubuntu; TitleLab.Text = name; TitleLab.TextColor3 = Colors.TextPrimary; TitleLab.TextSize = 14; TitleLab.TextXAlignment = Enum.TextXAlignment.Left
            local ValueLab = Instance.new("TextLabel"); ValueLab.Parent = SliderFrame; ValueLab.BackgroundTransparency = 1; ValueLab.Position = UDim2.new(0, 15, 0, 10); ValueLab.Size = UDim2.new(1, -30, 0, 20); ValueLab.Font = Enum.Font.Ubuntu; ValueLab.Text = fmt(default); ValueLab.TextColor3 = Colors.TextSecondary; ValueLab.TextSize = 14; ValueLab.TextXAlignment = Enum.TextXAlignment.Right
            local TrackBG = Instance.new("Frame"); TrackBG.Parent = SliderFrame; TrackBG.BackgroundColor3 = Colors.SliderBg; TrackBG.Position = UDim2.new(0, 15, 1, -15); TrackBG.Size = UDim2.new(1, -30, 0, 6); Instance.new("UICorner", TrackBG).CornerRadius = UDim.new(1, 0)
            local TrackFill = Instance.new("Frame"); TrackFill.Parent = TrackBG; TrackFill.BackgroundColor3 = Colors.SliderFill; TrackFill.Size = UDim2.new(0, 0, 1, 0); Instance.new("UICorner", TrackFill).CornerRadius = UDim.new(1, 0)
            local Handle = Instance.new("Frame"); Handle.Parent = TrackBG; Handle.Size = UDim2.new(0, 12, 0, 12); Handle.AnchorPoint = Vector2.new(0.5, 0.5); Handle.Position = UDim2.new((default - min) / math.max(max - min, 0.0001), 0, 0.5, 0); Handle.BackgroundColor3 = Colors.TextPrimary; Handle.BorderSizePixel = 0; Handle.ZIndex = 3; Instance.new("UICorner", Handle).CornerRadius = UDim.new(1, 0)
            local DragBtn = Instance.new("TextButton"); DragBtn.Parent = TrackBG; DragBtn.BackgroundTransparency = 1; DragBtn.Position = UDim2.new(0, -15, 0, -10); DragBtn.Size = UDim2.new(1, 30, 1, 20); DragBtn.Text = ""; DragBtn.ZIndex = 5
            SliderFrame.MouseEnter:Connect(function() Utility:Tween(SliderFrame, {0.2}, {BackgroundColor3 = Colors.ButtonHover}) end); SliderFrame.MouseLeave:Connect(function() Utility:Tween(SliderFrame, {0.2}, {BackgroundColor3 = Colors.ButtonBg}) end)
            local dragging = false
            local function updateSlider(input)
                local trackWidth = TrackBG.AbsoluteSize.X; if trackWidth == 0 then trackWidth = 1 end
                local sizeX = math.clamp((input.Position.X - TrackBG.AbsolutePosition.X) / trackWidth, 0, 1)
                local raw = min + (max - min) * sizeX; local value = snap(raw); local fillX = (value - min) / math.max(max - min, 0.0001)
                Utility:Tween(TrackFill, {0.05}, {Size = UDim2.new(fillX, 0, 1, 0)}); Handle.Position = UDim2.new(fillX, 0, 0.5, 0); ValueLab.Text = fmt(value); callback(value)
            end
            DragBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; updateSlider(input) end end)
            DragBtn.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
            UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
            local initFill = (default - min) / math.max(max - min, 0.0001); TrackFill.Size = UDim2.new(math.clamp(initFill, 0, 1), 0, 1, 0); Handle.Position = UDim2.new(math.clamp(initFill, 0, 1), 0, 0.5, 0)
        end

        function Elements:CreateLabel(options)
            local text = options.Text or "Label"; local color = options.Color or Colors.LabelColor; local size = options.TextSize or 13
            local LFrame = Instance.new("Frame"); LFrame.Parent = TabPage; LFrame.BackgroundTransparency = 1; LFrame.Size = UDim2.new(1, 0, 0, 28)
            local LText = Instance.new("TextLabel"); LText.Parent = LFrame; LText.BackgroundTransparency = 1; LText.Position = UDim2.new(0, 15, 0, 0); LText.Size = UDim2.new(1, -30, 1, 0); LText.Font = Enum.Font.Ubuntu; LText.Text = text; LText.TextColor3 = color; LText.TextSize = size; LText.TextXAlignment = Enum.TextXAlignment.Left; LText.TextWrapped = true; LText.RichText = true
            return {SetText = function(newText) LText.Text = newText end, SetColor = function(newCol) LText.TextColor3 = newCol end}
        end

        function Elements:CreateSeparator(options)
            local text = options and options.Text or ""
            local SepFrame = Instance.new("Frame"); SepFrame.Parent = TabPage; SepFrame.BackgroundTransparency = 1; SepFrame.Size = UDim2.new(1, 0, 0, 24)
            local Line = Instance.new("Frame"); Line.Parent = SepFrame; Line.BackgroundColor3 = Colors.Separator; Line.AnchorPoint = Vector2.new(0, 0.5); Line.Position = UDim2.new(0, 15, 0.5, 0); Line.Size = UDim2.new(1, -30, 0, 1); Instance.new("UICorner", Line).CornerRadius = UDim.new(1, 0)
            if text ~= "" then
                local SepLab = Instance.new("TextLabel"); SepLab.Parent = SepFrame; SepLab.BackgroundColor3 = Colors.Background; SepLab.Size = UDim2.new(0, 0, 0, 16); SepLab.AutomaticSize = Enum.AutomaticSize.X; SepLab.AnchorPoint = Vector2.new(0.5, 0.5); SepLab.Position = UDim2.new(0.5, 0, 0.5, 0); SepLab.Font = Enum.Font.Ubuntu; SepLab.Text = "  " .. text .. "  "; SepLab.TextColor3 = Colors.TextSecondary; SepLab.TextSize = 11; SepLab.ZIndex = 2
            end
        end

        function Elements:CreateKeybind(options)
            local name = options.Name or "Keybind"; local default = options.CurrentKey or Enum.KeyCode.Unknown; local callback = options.Callback or function() end
            local listening = false; local currentKey = default
            local KFrame = Instance.new("Frame"); KFrame.Parent = TabPage; KFrame.BackgroundColor3 = Colors.ButtonBg; KFrame.Size = UDim2.new(1, 0, 0, 42)
            Instance.new("UICorner", KFrame).CornerRadius = UDim.new(0, 6); local KStroke = Instance.new("UIStroke", KFrame); KStroke.Color = Colors.Stroke
            local KLabel = Instance.new("TextLabel"); KLabel.Parent = KFrame; KLabel.BackgroundTransparency = 1; KLabel.Position = UDim2.new(0, 15, 0, 0); KLabel.Size = UDim2.new(1, -100, 1, 0); KLabel.Font = Enum.Font.Ubuntu; KLabel.Text = name; KLabel.TextColor3 = Colors.TextPrimary; KLabel.TextSize = 14; KLabel.TextXAlignment = Enum.TextXAlignment.Left
            local KeyBtn = Instance.new("TextButton"); KeyBtn.Parent = KFrame; KeyBtn.BackgroundColor3 = Colors.InputBoxBg; KeyBtn.Position = UDim2.new(1, -90, 0.5, -12); KeyBtn.Size = UDim2.new(0, 78, 0, 24); KeyBtn.Font = Enum.Font.Code; KeyBtn.Text = currentKey.Name; KeyBtn.TextColor3 = Colors.TextPrimary; KeyBtn.TextSize = 12; KeyBtn.AutoButtonColor = false; Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 4)
            local KBStroke = Instance.new("UIStroke", KeyBtn); KBStroke.Color = Colors.Stroke
            KFrame.MouseEnter:Connect(function() Utility:Tween(KFrame, {0.2}, {BackgroundColor3 = Colors.ButtonHover}) end); KFrame.MouseLeave:Connect(function() Utility:Tween(KFrame, {0.2}, {BackgroundColor3 = Colors.ButtonBg}) end)
            KeyBtn.MouseButton1Click:Connect(function() listening = true; KeyBtn.Text = "..."; Utility:Tween(KBStroke, {0.2}, {Color = Colors.Accent}) end)
            UserInputService.InputBegan:Connect(function(input, gp) if not listening then return end; if input.UserInputType == Enum.UserInputType.Keyboard then if input.KeyCode == Enum.KeyCode.Escape then currentKey = Enum.KeyCode.Unknown else currentKey = input.KeyCode end; listening = false; KeyBtn.Text = currentKey.Name; Utility:Tween(KBStroke, {0.2}, {Color = Colors.Stroke}); callback(currentKey) end end)
        end

        function Elements:CreateDropdown(options)
            local name = options.Name or "Dropdown"; local list = options.Options or {}; local current = options.CurrentOption or (list[1] or ""); local callback = options.Callback or function() end
            local DropOuter = Instance.new("Frame"); DropOuter.Parent = TabPage; DropOuter.BackgroundTransparency = 1; DropOuter.Size = UDim2.new(1, 0, 0, 42); DropOuter.ClipsDescendants = false; DropOuter.ZIndex = 10
            local DropFrame = Instance.new("Frame"); DropFrame.Parent = DropOuter; DropFrame.BackgroundColor3 = Colors.DropdownBg; DropFrame.Size = UDim2.new(1, 0, 0, 42); DropFrame.ClipsDescendants = false; DropFrame.ZIndex = 10
            Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 6); local DStroke = Instance.new("UIStroke", DropFrame); DStroke.Color = Colors.Stroke
            local DropBtn = Instance.new("TextButton"); DropBtn.Parent = DropFrame; DropBtn.BackgroundTransparency = 1; DropBtn.Size = UDim2.new(1, 0, 1, 0); DropBtn.Text = ""; DropBtn.ZIndex = 12
            local TitleLab = Instance.new("TextLabel"); TitleLab.Parent = DropFrame; TitleLab.BackgroundTransparency = 1; TitleLab.Position = UDim2.new(0, 15, 0, 0); TitleLab.Size = UDim2.new(1, -60, 1, 0); TitleLab.Font = Enum.Font.Ubuntu; TitleLab.Text = name .. "  ›  " .. tostring(current); TitleLab.TextColor3 = Colors.TextPrimary; TitleLab.TextSize = 14; TitleLab.TextXAlignment = Enum.TextXAlignment.Left; TitleLab.ZIndex = 11
            local ArrowLab = Instance.new("TextLabel"); ArrowLab.Parent = DropFrame; ArrowLab.BackgroundTransparency = 1; ArrowLab.Position = UDim2.new(1, -32, 0, 0); ArrowLab.Size = UDim2.new(0, 24, 1, 0); ArrowLab.Font = Enum.Font.Ubuntu; ArrowLab.Text = "▼"; ArrowLab.TextColor3 = Colors.TextSecondary; ArrowLab.TextSize = 12; ArrowLab.ZIndex = 11
            local ListPanel = Instance.new("Frame"); ListPanel.Parent = DropFrame; ListPanel.BackgroundColor3 = Colors.DropdownList; ListPanel.Position = UDim2.new(0, 0, 1, 4); ListPanel.Size = UDim2.new(1, 0, 0, 0); ListPanel.ClipsDescendants = true; ListPanel.ZIndex = 50; ListPanel.Visible = false
            Instance.new("UICorner", ListPanel).CornerRadius = UDim.new(0, 6); local LStroke = Instance.new("UIStroke", ListPanel); LStroke.Color = Colors.Stroke
            local ListScroll = Instance.new("ScrollingFrame"); ListScroll.Parent = ListPanel; ListScroll.BackgroundTransparency = 1; ListScroll.Size = UDim2.new(1, 0, 1, 0); ListScroll.ScrollBarThickness = 2; ListScroll.ScrollBarImageColor3 = Colors.Stroke; ListScroll.CanvasSize = UDim2.new(0, 0, 0, 0); ListScroll.ZIndex = 51
            local ListLayout = Instance.new("UIListLayout"); ListLayout.Parent = ListScroll; ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            local ListPad = Instance.new("UIPadding"); ListPad.Parent = ListScroll; ListPad.PaddingTop = UDim.new(0, 4); ListPad.PaddingBottom = UDim.new(0, 4)
            local expanded = false; local ITEM_H = 34
            local function buildList()
                for _, v in pairs(ListScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                for _, option in ipairs(list) do
                    local isCurrent = tostring(option) == tostring(current)
                    local Opt = Instance.new("TextButton"); Opt.Parent = ListScroll; Opt.BackgroundColor3 = isCurrent and Colors.Accent or Colors.DropdownList; Opt.BackgroundTransparency = isCurrent and 0 or 1; Opt.Size = UDim2.new(1, 0, 0, ITEM_H); Opt.Font = Enum.Font.Ubuntu; Opt.Text = "  " .. (isCurrent and "▶  " or "    ") .. tostring(option); Opt.TextColor3 = isCurrent and Colors.Background or Colors.TextSecondary; Opt.TextSize = 13; Opt.TextXAlignment = Enum.TextXAlignment.Left; Opt.AutoButtonColor = false; Opt.ZIndex = 52
                    Opt.MouseEnter:Connect(function() if not isCurrent then Utility:Tween(Opt, {0.12}, {BackgroundTransparency = 0, BackgroundColor3 = Colors.ButtonHover, TextColor3 = Colors.TextPrimary}) end end)
                    Opt.MouseLeave:Connect(function() if not isCurrent then Utility:Tween(Opt, {0.12}, {BackgroundTransparency = 1, TextColor3 = Colors.TextSecondary}) end end)
                    Opt.MouseButton1Click:Connect(function() current = option; TitleLab.Text = name .. "  ›  " .. tostring(current); expanded = false; Utility:Tween(ListPanel, {0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {Size = UDim2.new(1, 0, 0, 0)}); Utility:Tween(ArrowLab, {0.2}, {Rotation = 0}); task.wait(0.28); ListPanel.Visible = false; buildList(); callback(current) end)
                end
                ListScroll.CanvasSize = UDim2.new(0, 0, 0, #list * ITEM_H + 8)
            end
            buildList()
            local function toggleDropdown()
                expanded = not expanded
                if expanded then local panelH = math.clamp(#list * ITEM_H + 8, 0, 180); ListPanel.Visible = true; ListPanel.Size = UDim2.new(1, 0, 0, 0); Utility:Tween(ListPanel, {0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {Size = UDim2.new(1, 0, 0, panelH)}); Utility:Tween(ArrowLab, {0.25}, {Rotation = 180}); Utility:Tween(DropFrame, {0.2}, {BackgroundColor3 = Colors.ButtonHover})
                else Utility:Tween(ListPanel, {0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {Size = UDim2.new(1, 0, 0, 0)}); Utility:Tween(ArrowLab, {0.2}, {Rotation = 0}); Utility:Tween(DropFrame, {0.2}, {BackgroundColor3 = Colors.DropdownBg}); task.wait(0.28); if not expanded then ListPanel.Visible = false end end
            end
            DropBtn.MouseButton1Click:Connect(toggleDropdown)
            DropFrame.MouseEnter:Connect(function() if not expanded then Utility:Tween(DropFrame, {0.2}, {BackgroundColor3 = Colors.ButtonHover}) end end)
            DropFrame.MouseLeave:Connect(function() if not expanded then Utility:Tween(DropFrame, {0.2}, {BackgroundColor3 = Colors.DropdownBg}) end end)
            UserInputService.InputBegan:Connect(function(input) if expanded and input.UserInputType == Enum.UserInputType.MouseButton1 then local pos = input.Position; local panelPos = ListPanel.AbsolutePosition; local panelSz = ListPanel.AbsoluteSize; local headPos = DropFrame.AbsolutePosition; local headSz = DropFrame.AbsoluteSize; local inHead = pos.X >= headPos.X and pos.X <= headPos.X + headSz.X and pos.Y >= headPos.Y and pos.Y <= headPos.Y + headSz.Y; local inPanel = pos.X >= panelPos.X and pos.X <= panelPos.X + panelSz.X and pos.Y >= panelPos.Y and pos.Y <= panelPos.Y + panelSz.Y; if not inHead and not inPanel then task.spawn(function() expanded = false; Utility:Tween(ListPanel, {0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {Size = UDim2.new(1, 0, 0, 0)}); Utility:Tween(ArrowLab, {0.2}, {Rotation = 0}); Utility:Tween(DropFrame, {0.2}, {BackgroundColor3 = Colors.DropdownBg}); task.wait(0.28); ListPanel.Visible = false end) end end end)
            return {Set = function(option) current = option; TitleLab.Text = name .. "  ›  " .. tostring(current); buildList(); callback(current) end, GetSelected = function() return current end, Refresh = function(newList) list = newList; buildList() end}
        end

        function Elements:CreateInput(options)
            local name = options.Name or "Input"; local placeholder = options.PlaceholderText or "Type here..."; local callback = options.Callback or function() end
            local InputFrame = Instance.new("Frame"); InputFrame.Parent = TabPage; InputFrame.BackgroundColor3 = Colors.ButtonBg; InputFrame.Size = UDim2.new(1, 0, 0, 42)
            Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 6); local IStroke = Instance.new("UIStroke", InputFrame); IStroke.Color = Colors.Stroke
            local TitleLab = Instance.new("TextLabel"); TitleLab.Parent = InputFrame; TitleLab.BackgroundTransparency = 1; TitleLab.Position = UDim2.new(0, 15, 0, 0); TitleLab.Size = UDim2.new(0.4, 0, 1, 0); TitleLab.Font = Enum.Font.Ubuntu; TitleLab.Text = name; TitleLab.TextColor3 = Colors.TextPrimary; TitleLab.TextSize = 14; TitleLab.TextXAlignment = Enum.TextXAlignment.Left
            local TextBoxBG = Instance.new("Frame"); TextBoxBG.Parent = InputFrame; TextBoxBG.BackgroundColor3 = Colors.InputBoxBg; TextBoxBG.Position = UDim2.new(0.4, 15, 0.5, -12); TextBoxBG.Size = UDim2.new(0.6, -30, 0, 24); Instance.new("UICorner", TextBoxBG).CornerRadius = UDim.new(0, 4)
            local TextBox = Instance.new("TextBox"); TextBox.Parent = TextBoxBG; TextBox.BackgroundTransparency = 1; TextBox.Size = UDim2.new(1, -10, 1, 0); TextBox.Position = UDim2.new(0, 5, 0, 0); TextBox.Font = Enum.Font.Ubuntu; TextBox.Text = ""; TextBox.PlaceholderText = placeholder; TextBox.TextColor3 = Colors.TextPrimary; TextBox.PlaceholderColor3 = Colors.TextSecondary; TextBox.TextSize = 13; TextBox.TextXAlignment = Enum.TextXAlignment.Left
            TextBox.FocusLost:Connect(function(enterPressed) callback(TextBox.Text) end)
        end

        function Elements:CreateColorPicker(options)
            local name = options.Name or "Color Picker"; local default = options.Default or Color3.fromRGB(255, 0, 0); local callback = options.Callback or function() end
            local currentH, currentS, currentV = Color3.toHSV(default); local expanded = false; local svDragging = false; local hueDragging = false
            local CPFrame = Instance.new("Frame"); CPFrame.Parent = TabPage; CPFrame.BackgroundColor3 = Colors.ButtonBg; CPFrame.Size = UDim2.new(1, 0, 0, 42); CPFrame.ClipsDescendants = true
            Instance.new("UICorner", CPFrame).CornerRadius = UDim.new(0, 6); local CPStroke = Instance.new("UIStroke", CPFrame); CPStroke.Color = Colors.Stroke
            local CPLabel = Instance.new("TextLabel"); CPLabel.Parent = CPFrame; CPLabel.BackgroundTransparency = 1; CPLabel.Position = UDim2.new(0, 15, 0, 0); CPLabel.Size = UDim2.new(1, -90, 0, 42); CPLabel.Font = Enum.Font.Ubuntu; CPLabel.Text = name; CPLabel.TextColor3 = Colors.TextPrimary; CPLabel.TextSize = 14; CPLabel.TextXAlignment = Enum.TextXAlignment.Left
            local Swatch = Instance.new("Frame"); Swatch.Parent = CPFrame; Swatch.BackgroundColor3 = default; Swatch.Position = UDim2.new(1, -68, 0.5, -10); Swatch.Size = UDim2.new(0, 36, 0, 20); Instance.new("UICorner", Swatch).CornerRadius = UDim.new(0, 4); local SwatchStroke = Instance.new("UIStroke", Swatch); SwatchStroke.Color = Colors.Stroke; SwatchStroke.Thickness = 1
            local ArrowIcon = Instance.new("ImageLabel"); ArrowIcon.Parent = CPFrame; ArrowIcon.BackgroundTransparency = 1; ArrowIcon.Position = UDim2.new(1, -26, 0.5, -8); ArrowIcon.Size = UDim2.new(0, 16, 0, 16); ArrowIcon.Image = "rbxassetid://10888331510"; ArrowIcon.ImageColor3 = Colors.TextSecondary; ArrowIcon.Rotation = 90
            local HeaderBtn = Instance.new("TextButton"); HeaderBtn.Parent = CPFrame; HeaderBtn.BackgroundTransparency = 1; HeaderBtn.Size = UDim2.new(1, 0, 0, 42); HeaderBtn.Text = ""; HeaderBtn.ZIndex = 2
            local Palette = Instance.new("ImageLabel"); Palette.Parent = CPFrame; Palette.Size = UDim2.new(1, -30, 0, 150); Palette.Position = UDim2.new(0, 15, 0, 52); Palette.BackgroundColor3 = Color3.fromHSV(currentH, 1, 1); Palette.Image = "rbxassetid://4155801252"; Palette.ZIndex = 3; Instance.new("UICorner", Palette).CornerRadius = UDim.new(0, 4)
            local SVCursor = Instance.new("Frame"); SVCursor.Parent = Palette; SVCursor.Size = UDim2.new(0, 10, 0, 10); SVCursor.AnchorPoint = Vector2.new(0.5, 0.5); SVCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255); SVCursor.BorderSizePixel = 0; SVCursor.ZIndex = 5; SVCursor.Position = UDim2.new(currentS, 0, 1 - currentV, 0); Instance.new("UICorner", SVCursor).CornerRadius = UDim.new(1, 0)
            local HueBar = Instance.new("ImageLabel"); HueBar.Parent = CPFrame; HueBar.Size = UDim2.new(1, -30, 0, 14); HueBar.Position = UDim2.new(0, 15, 0, 212); HueBar.Image = "rbxassetid://698052001"; HueBar.ZIndex = 3; Instance.new("UICorner", HueBar).CornerRadius = UDim.new(0, 4)
            local HueCursor = Instance.new("Frame"); HueCursor.Parent = HueBar; HueCursor.Size = UDim2.new(0, 5, 1, 4); HueCursor.AnchorPoint = Vector2.new(0.5, 0); HueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255); HueCursor.BorderSizePixel = 0; HueCursor.ZIndex = 5; HueCursor.Position = UDim2.new(currentH, 0, 0, -2); Instance.new("UICorner", HueCursor).CornerRadius = UDim.new(0, 2)
            local HexLabel = Instance.new("TextLabel"); HexLabel.Parent = CPFrame; HexLabel.BackgroundColor3 = Colors.InputBoxBg; HexLabel.Position = UDim2.new(0, 15, 0, 236); HexLabel.Size = UDim2.new(1, -30, 0, 22); HexLabel.Font = Enum.Font.Code; HexLabel.TextColor3 = Colors.TextSecondary; HexLabel.TextSize = 12; HexLabel.ZIndex = 3; Instance.new("UICorner", HexLabel).CornerRadius = UDim.new(0, 4)
            local function updateColor()
                local color = Color3.fromHSV(currentH, currentS, currentV); Swatch.BackgroundColor3 = color; Palette.BackgroundColor3 = Color3.fromHSV(currentH, 1, 1)
                local r = math.floor(color.R * 255); local g = math.floor(color.G * 255); local b = math.floor(color.B * 255); HexLabel.Text = string.format("  #%02X%02X%02X  (R:%d G:%d B:%d)", r, g, b, r, g, b); SVCursor.Position = UDim2.new(currentS, 0, 1 - currentV, 0); HueCursor.Position = UDim2.new(currentH, 0, 0, -2); callback(color)
            end
            updateColor()
            HeaderBtn.MouseButton1Click:Connect(function() expanded = not expanded; if expanded then Utility:Tween(CPFrame, {0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {Size = UDim2.new(1, 0, 0, 270)}); Utility:Tween(ArrowIcon, {0.3}, {Rotation = -90}) else Utility:Tween(CPFrame, {0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out}, {Size = UDim2.new(1, 0, 0, 42)}); Utility:Tween(ArrowIcon, {0.3}, {Rotation = 90}) end end)
            HeaderBtn.MouseEnter:Connect(function() Utility:Tween(CPFrame, {0.2}, {BackgroundColor3 = Colors.ButtonHover}) end); HeaderBtn.MouseLeave:Connect(function() Utility:Tween(CPFrame, {0.2}, {BackgroundColor3 = Colors.ButtonBg}) end)
            Palette.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then svDragging = true; local relX = math.clamp((input.Position.X - Palette.AbsolutePosition.X) / Palette.AbsoluteSize.X, 0, 1); local relY = math.clamp((input.Position.Y - Palette.AbsolutePosition.Y) / Palette.AbsoluteSize.Y, 0, 1); currentS = relX; currentV = 1 - relY; updateColor() end end)
            Palette.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then svDragging = false end end)
            HueBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then hueDragging = true; local relX = math.clamp((input.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1); currentH = relX; updateColor() end end)
            HueBar.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then hueDragging = false end end)
            UserInputService.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then if svDragging then local relX = math.clamp((input.Position.X - Palette.AbsolutePosition.X) / Palette.AbsoluteSize.X, 0, 1); local relY = math.clamp((input.Position.Y - Palette.AbsolutePosition.Y) / Palette.AbsoluteSize.Y, 0, 1); currentS = relX; currentV = 1 - relY; updateColor() elseif hueDragging then local relX = math.clamp((input.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1); currentH = relX; updateColor() end end end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then svDragging = false; hueDragging = false end end)
        end

        return Elements
    end
    return Window
end

function CoffeeUI:KeySystem(config)
    local validKey = config.Key or ""; local linkURL = config.GetKeyURL or ""; local title = config.Title or "COFFEE"; local subtitle = config.Subtitle or "Enter your key to continue"
    local KGui = Instance.new("ScreenGui"); KGui.Name = "CoffeeUI_KeySystem"; KGui.DisplayOrder = 9999; KGui.IgnoreGuiInset = true; KGui.ResetOnSpawn = false; KGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; KGui.Parent = ParentGui
    local Overlay = Instance.new("Frame", KGui); Overlay.Size = UDim2.fromScale(1,1); Overlay.BackgroundColor3 = Color3.fromRGB(0,0,0); Overlay.BackgroundTransparency = 1; Overlay.ZIndex = 100
    local Card = Instance.new("Frame", KGui); Card.AnchorPoint = Vector2.new(0.5,0.5); Card.Position = UDim2.fromScale(0.5, 0.52); Card.Size = UDim2.fromOffset(360, 200); Card.BackgroundColor3 = Colors.KeySystemBg; Card.ZIndex = 101; Instance.new("UICorner",Card).CornerRadius = UDim.new(0,10)
    local CardStroke = Instance.new("UIStroke",Card); CardStroke.Color = Colors.Stroke; CardStroke.Thickness = 1
    local Shadow = Instance.new("Frame",Card); Shadow.BackgroundColor3 = Color3.fromRGB(0,0,0); Shadow.Size = UDim2.new(1,10,1,10); Shadow.Position = UDim2.new(0,-5,0,-5); Shadow.BackgroundTransparency = 0.8; Shadow.ZIndex = -1; Instance.new("UICorner",Shadow).CornerRadius = UDim.new(0,14)
    local Header = Instance.new("Frame",Card); Header.Size = UDim2.new(1,0,0,35); Header.BackgroundColor3 = Colors.KeySystemHeader; Header.ZIndex = 102; Instance.new("UICorner",Header).CornerRadius = UDim.new(0,10)
    local HFix = Instance.new("Frame",Header); HFix.BackgroundColor3 = Colors.KeySystemHeader; HFix.Position = UDim2.new(0,0,1,-10); HFix.Size = UDim2.new(1,0,0,10)
    local HDiv = Instance.new("Frame",Header); HDiv.BackgroundColor3 = Colors.Stroke; HDiv.Position = UDim2.new(0,0,1,-1); HDiv.Size = UDim2.new(1,0,0,1)
    local TitleLb = Instance.new("TextLabel",Header); TitleLb.BackgroundTransparency = 1; TitleLb.Position = UDim2.new(0,15,0,0); TitleLb.Size = UDim2.new(1,-20,1,0); TitleLb.Font = Enum.Font.Ubuntu; TitleLb.Text = title; TitleLb.TextColor3 = Colors.TextPrimary; TitleLb.TextSize = 14; TitleLb.TextXAlignment = Enum.TextXAlignment.Left; TitleLb.ZIndex = 103
    local SubLb = Instance.new("TextLabel",Card); SubLb.BackgroundTransparency = 1; SubLb.Position = UDim2.new(0,18,0,46); SubLb.Size = UDim2.new(1,-36,0,18); SubLb.Font = Enum.Font.Ubuntu; SubLb.Text = subtitle; SubLb.TextColor3 = Colors.TextSecondary; SubLb.TextSize = 13; SubLb.TextXAlignment = Enum.TextXAlignment.Left; SubLb.ZIndex = 102
    local IBg = Instance.new("Frame",Card); IBg.Size = UDim2.new(1,-36,0,36); IBg.Position = UDim2.new(0,18,0,74); IBg.BackgroundColor3 = Colors.InputBg; IBg.ZIndex = 102; Instance.new("UICorner",IBg).CornerRadius = UDim.new(0,8)
    local IStroke = Instance.new("UIStroke",IBg); IStroke.Color = Colors.Stroke; IStroke.Thickness = 1
    local IBox = Instance.new("TextBox",IBg); IBox.Size = UDim2.new(1,-14,1,0); IBox.Position = UDim2.new(0,7,0,0); IBox.BackgroundTransparency = 1; IBox.Text = ""; IBox.PlaceholderText = "Paste your key here..."; IBox.PlaceholderColor3 = Colors.TextSecondary; IBox.TextColor3 = Colors.TextPrimary; IBox.Font = Enum.Font.Code; IBox.TextSize = 13; IBox.ClearTextOnFocus = false; IBox.ZIndex = 103
    local StatusLb = Instance.new("TextLabel",Card); StatusLb.BackgroundTransparency = 1; StatusLb.Position = UDim2.new(0,18,0,118); StatusLb.Size = UDim2.new(1,-36,0,16); StatusLb.Font = Enum.Font.Ubuntu; StatusLb.Text = ""; StatusLb.TextColor3 = Colors.TextSecondary; StatusLb.TextSize = 12; StatusLb.TextXAlignment = Enum.TextXAlignment.Left; StatusLb.ZIndex = 102
    local btnY = 143
    local function MakeBtn(text, xOff, width, isPrimary)
        local B = Instance.new("TextButton",Card); B.Size = UDim2.new(0, width, 0, 32); B.Position = UDim2.new(0, xOff, 0, btnY); B.BackgroundColor3 = Colors.ButtonBg; B.AutoButtonColor = false; B.Font = Enum.Font.Ubuntu; B.Text = "   "..text; B.TextColor3 = isPrimary and Colors.TextPrimary or Colors.TextSecondary; B.TextSize = 13; B.TextXAlignment = Enum.TextXAlignment.Left; B.ZIndex = 102; Instance.new("UICorner",B).CornerRadius = UDim.new(0,6)
        local BS = Instance.new("UIStroke",B); BS.Color = Colors.Stroke; BS.Thickness = 1
        if isPrimary then local Ind = Instance.new("Frame",B); Ind.BackgroundColor3 = Colors.Accent; Ind.Size = UDim2.new(0,3,0,14); Ind.Position = UDim2.new(0,0,0.5,-7); Instance.new("UICorner",Ind).CornerRadius = UDim.new(1,0) end
        B.MouseEnter:Connect(function() Utility:Tween(B,{0.2},{BackgroundColor3=Colors.ButtonHover}); Utility:Tween(BS,{0.2},{Color=Colors.Accent}) end)
        B.MouseLeave:Connect(function() Utility:Tween(B,{0.2},{BackgroundColor3=Colors.ButtonBg}); Utility:Tween(BS,{0.2},{Color=Colors.Stroke}) end)
        return B
    end
    local btnW = (420-36-8) / 2; local BtnGet = MakeBtn("Get Key", 18, btnW, false); local BtnSubmit = MakeBtn("Submit", 18+btnW+8, btnW, true)
    local FooterLb = Instance.new("TextLabel",Card); FooterLb.BackgroundTransparency = 1; FooterLb.Position = UDim2.new(0,18,1,-22); FooterLb.Size = UDim2.new(1,-36,0,14); FooterLb.Font = Enum.Font.Ubuntu; FooterLb.Text = "coffee library"; FooterLb.TextColor3 = Colors.TextSecondary; FooterLb.TextSize = 11; FooterLb.TextXAlignment = Enum.TextXAlignment.Left; FooterLb.ZIndex = 102
    Utility:Tween(Overlay,{0.4},{BackgroundTransparency=0.35}); Utility:Tween(Card,{0.45,Enum.EasingStyle.Back,Enum.EasingDirection.Out},{Size = UDim2.fromOffset(420,195), Position = UDim2.fromScale(0.5,0.5)})
    IBox.Focused:Connect(function() Utility:Tween(IStroke,{0.2},{Color=Colors.Accent,Thickness=1.5}) end); IBox.FocusLost:Connect(function() Utility:Tween(IStroke,{0.2},{Color=Colors.Stroke,Thickness=1}) end)
    local function Shake() local orig = Card.Position; for i = 1,7 do Card.Position = orig + UDim2.fromOffset(i%2==0 and 7 or -7, 0); task.wait(0.035) end; Card.Position = orig end
    BtnGet.MouseButton1Click:Connect(function() pcall(function() setclipboard(linkURL) end); StatusLb.TextColor3 = Color3.fromRGB(130,190,130); StatusLb.Text = "Link copied to clipboard." end)
    local _done = false
    local function TryKey() if string.gsub(IBox.Text, "%s+", "") == string.gsub(validKey, "%s+", "") then _done = true; StatusLb.TextColor3 = Color3.fromRGB(130,190,130); StatusLb.Text = "Key accepted. Loading..."; Utility:Tween(Card,{0.35,Enum.EasingStyle.Back,Enum.EasingDirection.In},{Size=UDim2.fromOffset(360,160),Position=UDim2.fromScale(0.5,0.52)}); Utility:Tween(Overlay,{0.35},{BackgroundTransparency=1}); task.delay(0.4, function() KGui:Destroy() end) else StatusLb.TextColor3 = Color3.fromRGB(190,120,120); StatusLb.Text = "Invalid key. Click 'Get Key' to receive yours."; task.spawn(Shake) end end
    BtnSubmit.MouseButton1Click:Connect(TryKey); IBox.FocusLost:Connect(function(enter) if enter then TryKey() end end)
    repeat task.wait(0.05) until _done
end

return CoffeeUI
