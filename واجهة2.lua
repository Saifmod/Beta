--!strict
-- timebomb lib | tik ; scrips_saifx
-- ModuleScript

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local Lib = {}

local State = {
    PlayerControls = nil,
    LockedFrames = {},
    ScreenGui = nil,
    MainFrame = nil,
    AutoFrame = nil,
    AutoBig = nil,
    AutoBigStroke = nil,
    Toggled = false,
    Fixed = false,
    Speed = 16,
    Radius = 3,
    ScriptWeight = 0.5,
    ManualWeight = 0.5,
    BombCheckEnabled = false,
    HitboxEnabled = false,
    HitboxSize = Vector3.new(8, 5, 5),
    ElementOrder = 0,
    Minimized = false,
    OriginalSize = UDim2.new(0, 380, 0, 320),
    MinimizeTween = nil,
    ContentFrame = nil,
    TEAM = { side = nil, arena = nil, mates = {} },
    Connections = {},
    Tabs = {},
    TabButtons = {},
    TabScroll = nil,
    TabScrollConn = nil,
    ActiveTab = nil,
}

local function track(conn)
    table.insert(State.Connections, conn)
    return conn
end

local function GetManualMoveVector()
    if not State.PlayerControls then return Vector3.zero end
    local ok, mv = pcall(function() return State.PlayerControls:GetMoveVector() end)
    if ok and typeof(mv) == "Vector3" then return mv end
    return Vector3.zero
end

local function EnableManualControl()
    if State.PlayerControls then
        pcall(function() State.PlayerControls:Enable() end)
    end
end

local function makeDraggable(frame, handle)
    local dragging, dragStart, startPos
    track(handle.InputBegan:Connect(function(input)
        if State.LockedFrames[frame] then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end))
    track(handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))
    track(UserInputService.InputChanged:Connect(function(input)
        if dragging and not State.LockedFrames[frame] and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end))
end

local function makeHorizScroll(container, canvasHolder)
    local dragging, dragStart, startCanvas
    track(container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startCanvas = canvasHolder.CanvasPosition
        end
    end))
    track(container.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))
    track(UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - dragStart
            local maxX = math.max(0, canvasHolder.AbsoluteCanvasSize.X - canvasHolder.AbsoluteSize.X)
            local newX = math.clamp(startCanvas.X - delta.X, 0, maxX)
            canvasHolder.CanvasPosition = Vector2.new(newX, canvasHolder.CanvasPosition.Y)
        end
    end))
end

function Lib:Init()
    pcall(function()
        local PlayerModule = LocalPlayer.PlayerScripts:WaitForChild("PlayerModule")
        State.PlayerControls = require(PlayerModule):GetControls()
    end)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TabUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.CoreGui
    State.ScreenGui = ScreenGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = State.OriginalSize
    MainFrame.Position = UDim2.new(0.5, -190, 0.5, -160)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Parent = ScreenGui
    State.MainFrame = MainFrame

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(45, 45, 55)
    MainStroke.Thickness = 1.5
    MainStroke.Parent = MainFrame

    local MainGradient = Instance.new("UIGradient")
    MainGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 220)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 80, 110)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 220))
    }
    MainGradient.Rotation = 45
    MainGradient.Parent = MainStroke

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 32)
    TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    TopBar.BorderSizePixel = 0
    TopBar.Active = true
    TopBar.Parent = MainFrame

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 12)
    TopCorner.Parent = TopBar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -80, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "timebomb | tik ; scrips_saifx"
    Title.TextColor3 = Color3.fromRGB(230, 220, 200)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 12
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 22, 0, 22)
    MinBtn.Position = UDim2.new(1, -54, 0, 5)
    MinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    MinBtn.BorderSizePixel = 0
    MinBtn.Text = "—"
    MinBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 14
    MinBtn.Parent = TopBar

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 6)
    MinCorner.Parent = MinBtn

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 22, 0, 22)
    CloseBtn.Position = UDim2.new(1, -28, 0, 5)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(240, 200, 200)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 12
    CloseBtn.Parent = TopBar

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn

    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1, -20, 0, 26)
    TabBar.Position = UDim2.new(0, 10, 0, 36)
    TabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    TabBar.BorderSizePixel = 0
    TabBar.Parent = MainFrame

    local TabBarCorner = Instance.new("UICorner")
    TabBarCorner.CornerRadius = UDim.new(0, 6)
    TabBarCorner.Parent = TabBar

    local TabBarStroke = Instance.new("UIStroke")
    TabBarStroke.Color = Color3.fromRGB(40, 40, 55)
    TabBarStroke.Thickness = 1
    TabBarStroke.Parent = TabBar

    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Size = UDim2.fromScale(1, 1)
    TabScroll.BackgroundTransparency = 1
    TabScroll.BorderSizePixel = 0
    TabScroll.ScrollBarThickness = 0
    TabScroll.ScrollingDirection = Enum.ScrollingDirection.X
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
    TabScroll.ClipsDescendants = true
    TabScroll.Active = true
    TabScroll.Parent = TabBar
    State.TabScroll = TabScroll

    local TabScrollPad = Instance.new("UIPadding")
    TabScrollPad.PaddingTop = UDim.new(0, 3)
    TabScrollPad.PaddingBottom = UDim.new(0, 3)
    TabScrollPad.PaddingLeft = UDim.new(0, 3)
    TabScrollPad.PaddingRight = UDim.new(0, 3)
    TabScrollPad.Parent = TabScroll

    local TabScrollLayout = Instance.new("UIListLayout")
    TabScrollLayout.FillDirection = Enum.FillDirection.Horizontal
    TabScrollLayout.Padding = UDim.new(0, 4)
    TabScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabScrollLayout.Parent = TabScroll

    makeHorizScroll(TabBar, TabScroll)

    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Size = UDim2.new(1, -20, 1, -78)
    ContentFrame.Position = UDim2.new(0, 10, 0, 68)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    ContentFrame.BorderSizePixel = 0
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ContentFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ContentFrame.ScrollBarThickness = 4
    ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 110)
    ContentFrame.ScrollBarImageTransparency = 0.3
    ContentFrame.ClipsDescendants = true
    ContentFrame.Active = true
    ContentFrame.Parent = MainFrame
    State.ContentFrame = ContentFrame

    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 10)
    ContentCorner.Parent = ContentFrame

    local ContentStroke = Instance.new("UIStroke")
    ContentStroke.Color = Color3.fromRGB(40, 40, 55)
    ContentStroke.Thickness = 1
    ContentStroke.Parent = ContentFrame

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Padding = UDim.new(0, 6)
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Parent = ContentFrame

    local ContentPad = Instance.new("UIPadding")
    ContentPad.PaddingTop = UDim.new(0, 8)
    ContentPad.PaddingBottom = UDim.new(0, 10)
    ContentPad.PaddingLeft = UDim.new(0, 8)
    ContentPad.PaddingRight = UDim.new(0, 8)
    ContentPad.Parent = ContentFrame

    makeDraggable(MainFrame, TopBar)

    local AutoFrame = Instance.new("Frame")
    AutoFrame.Size = UDim2.new(0, 180, 0, 106)
    AutoFrame.Position = UDim2.new(0.5, 200, 0.5, -53)
    AutoFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    AutoFrame.BorderSizePixel = 0
    AutoFrame.Active = true
    AutoFrame.Visible = false
    AutoFrame.Parent = ScreenGui
    State.AutoFrame = AutoFrame

    local AutoCorner = Instance.new("UICorner")
    AutoCorner.CornerRadius = UDim.new(0, 12)
    AutoCorner.Parent = AutoFrame

    local AutoStroke = Instance.new("UIStroke")
    AutoStroke.Color = Color3.fromRGB(45, 45, 55)
    AutoStroke.Thickness = 1.5
    AutoStroke.Parent = AutoFrame

    local AutoGrad = Instance.new("UIGradient")
    AutoGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 220)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 80, 110)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 220))
    }
    AutoGrad.Rotation = 45
    AutoGrad.Parent = AutoStroke

    local AutoTop = Instance.new("Frame")
    AutoTop.Size = UDim2.new(1, 0, 0, 32)
    AutoTop.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    AutoTop.BorderSizePixel = 0
    AutoTop.Active = true
    AutoTop.Parent = AutoFrame

    local AutoTopCorner = Instance.new("UICorner")
    AutoTopCorner.CornerRadius = UDim.new(0, 12)
    AutoTopCorner.Parent = AutoTop

    local AutoTitle = Instance.new("TextLabel")
    AutoTitle.Size = UDim2.new(1, -50, 1, 0)
    AutoTitle.Position = UDim2.new(0, 12, 0, 0)
    AutoTitle.BackgroundTransparency = 1
    AutoTitle.Text = "AUTO CONTROL"
    AutoTitle.TextColor3 = Color3.fromRGB(230, 220, 200)
    AutoTitle.Font = Enum.Font.GothamBold
    AutoTitle.TextSize = 12
    AutoTitle.TextXAlignment = Enum.TextXAlignment.Left
    AutoTitle.Parent = AutoTop

    local AutoClose = Instance.new("TextButton")
    AutoClose.Size = UDim2.new(0, 22, 0, 22)
    AutoClose.Position = UDim2.new(1, -28, 0, 5)
    AutoClose.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
    AutoClose.BorderSizePixel = 0
    AutoClose.Text = "X"
    AutoClose.TextColor3 = Color3.fromRGB(240, 200, 200)
    AutoClose.Font = Enum.Font.GothamBold
    AutoClose.TextSize = 12
    AutoClose.Parent = AutoTop

    local AutoCloseCorner = Instance.new("UICorner")
    AutoCloseCorner.CornerRadius = UDim.new(0, 6)
    AutoCloseCorner.Parent = AutoClose

    makeDraggable(AutoFrame, AutoTop)

    local AutoBig = Instance.new("TextButton")
    AutoBig.Size = UDim2.new(1, -24, 0, 40)
    AutoBig.Position = UDim2.new(0, 12, 0, 46)
    AutoBig.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    AutoBig.BorderSizePixel = 0
    AutoBig.Text = "AUTO: OFF"
    AutoBig.TextColor3 = Color3.fromRGB(200, 200, 220)
    AutoBig.Font = Enum.Font.GothamBold
    AutoBig.TextSize = 14
    AutoBig.Parent = AutoFrame
    State.AutoBig = AutoBig

    local AutoBigCorner = Instance.new("UICorner")
    AutoBigCorner.CornerRadius = UDim.new(0, 10)
    AutoBigCorner.Parent = AutoBig

    local AutoBigStroke = Instance.new("UIStroke")
    AutoBigStroke.Color = Color3.fromRGB(50, 50, 70)
    AutoBigStroke.Thickness = 1
    AutoBigStroke.Parent = AutoBig
    State.AutoBigStroke = AutoBigStroke

    track(AutoClose.MouseButton1Click:Connect(function()
        AutoFrame.Visible = false
    end))

    track(CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end))

    track(MinBtn.MouseButton1Click:Connect(function()
        if State.MinimizeTween then State.MinimizeTween:Cancel() end
        State.Minimized = not State.Minimized
        if State.Minimized then
            ContentFrame.Visible = false
            State.MinimizeTween = TweenService:Create(
                MainFrame,
                TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                { Size = UDim2.new(0, 380, 0, 32) }
            )
            State.MinimizeTween:Play()
        else
            State.MinimizeTween = TweenService:Create(
                MainFrame,
                TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                { Size = State.OriginalSize }
            )
            State.MinimizeTween:Play()
            State.MinimizeTween.Completed:Connect(function()
                if not State.Minimized then
                    ContentFrame.Visible = true
                end
            end)
        end
    end))

    return self
end

function Lib:Tab(name, label)
    if State.Tabs[name] then return State.Tabs[name] end

    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollingDirection = Enum.ScrollingDirection.Y
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 110)
    page.ScrollBarImageTransparency = 0.3
    page.ClipsDescendants = true
    page.Active = true
    page.Visible = false
    page.Parent = State.ContentFrame

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 0)
    pad.PaddingBottom = UDim.new(0, 0)
    pad.PaddingLeft = UDim.new(0, 0)
    pad.PaddingRight = UDim.new(0, 0)
    pad.Parent = page

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 90, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    btn.BorderSizePixel = 0
    btn.Text = label
    btn.TextColor3 = Color3.fromRGB(200, 200, 220)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.Parent = State.TabScroll

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 5)
    bc.Parent = btn

    track(btn.MouseButton1Click:Connect(function()
        Lib:SelectTab(name)
    end))

    State.Tabs[name] = { Page = page, Button = btn, Order = #State.TabScroll:GetChildren() }

    if not State.ActiveTab then
        Lib:SelectTab(name)
    end

    return page
end

function Lib:SelectTab(name)
    if not State.Tabs[name] then return end
    for n, t in pairs(State.Tabs) do
        if n == name then
            t.Page.Visible = true
            t.Button.BackgroundColor3 = Color3.fromRGB(30, 60, 40)
            t.Button.TextColor3 = Color3.fromRGB(150, 230, 170)
        else
            t.Page.Visible = false
            t.Button.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
            t.Button.TextColor3 = Color3.fromRGB(200, 200, 220)
        end
    end
    State.ActiveTab = name
end

local function activeParent()
    if State.ActiveTab and State.Tabs[State.ActiveTab] then
        return State.Tabs[State.ActiveTab].Page
    end
    return State.ContentFrame
end

function Lib:Toggle(text, default, callback)
    State.ElementOrder += 1
    local parent = activeParent()

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BorderSizePixel = 0
    frame.LayoutOrder = State.ElementOrder
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(50, 50, 70)
    stroke.Thickness = 1
    stroke.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 40, 0, 20)
    toggleBg.Position = UDim2.new(1, -50, 0.5, -10)
    toggleBg.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = frame

    local toggleBgCorner = Instance.new("UICorner")
    toggleBgCorner.CornerRadius = UDim.new(1, 0)
    toggleBgCorner.Parent = toggleBg

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = UDim2.new(0, 2, 0.5, -8)
    circle.BackgroundColor3 = Color3.fromRGB(230, 220, 200)
    circle.BorderSizePixel = 0
    circle.Parent = toggleBg

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = frame

    local toggled = default == true

    local function UpdateToggle()
        if toggled then
            TweenService:Create(circle, TweenInfo.new(0.2), { Position = UDim2.new(1, -18, 0.5, -8) }):Play()
            TweenService:Create(toggleBg, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(30, 60, 40) }):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(150, 230, 170) }):Play()
            stroke.Color = Color3.fromRGB(80, 180, 110)
            label.TextColor3 = Color3.fromRGB(150, 230, 170)
        else
            TweenService:Create(circle, TweenInfo.new(0.2), { Position = UDim2.new(0, 2, 0.5, -8) }):Play()
            TweenService:Create(toggleBg, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(40, 40, 55) }):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(230, 220, 200) }):Play()
            stroke.Color = Color3.fromRGB(50, 50, 70)
            label.TextColor3 = Color3.fromRGB(200, 200, 220)
        end
    end

    UpdateToggle()

    track(button.MouseButton1Click:Connect(function()
        toggled = not toggled
        UpdateToggle()
        if callback then callback(toggled) end
    end))

    return {
        Set = function(_, value)
            toggled = value == true
            UpdateToggle()
            if callback then callback(toggled) end
        end,
        Get = function() return toggled end
    }
end

function Lib:Slider(text, min, max, default, callback)
    State.ElementOrder += 1
    local parent = activeParent()
    min = tonumber(min) or 0
    max = tonumber(max) or 100
    default = tonumber(default) or min
    if max <= min then max = min + 1 end
    default = math.clamp(default, min, max)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BorderSizePixel = 0
    frame.LayoutOrder = State.ElementOrder
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(50, 50, 70)
    stroke.Thickness = 1
    stroke.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 18)
    label.Position = UDim2.new(0, 8, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -20, 0, 6)
    barBg.Position = UDim2.new(0, 10, 0, 25)
    barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    barBg.BorderSizePixel = 0
    barBg.Parent = frame

    local barBgCorner = Instance.new("UICorner")
    barBgCorner.CornerRadius = UDim.new(1, 0)
    barBgCorner.Parent = barBg

    local percent = (default - min) / (max - min)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(percent, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(80, 80, 110)
    fill.BorderSizePixel = 0
    fill.Parent = barBg

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.new(0, 14, 0, 14)
    thumb.Position = UDim2.new(percent, -7, 0.5, -7)
    thumb.BackgroundColor3 = Color3.fromRGB(230, 220, 200)
    thumb.BorderSizePixel = 0
    thumb.Parent = barBg

    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = thumb

    local sliderDragging = false
    local value = default

    local function update(inputX)
        local barX = barBg.AbsolutePosition.X
        local barWidth = barBg.AbsoluteSize.X
        local newPercent = math.clamp((inputX - barX) / barWidth, 0, 1)
        value = math.floor(min + (max - min) * newPercent)
        fill.Size = UDim2.new(newPercent, 0, 1, 0)
        thumb.Position = UDim2.new(newPercent, -7, 0.5, -7)
        label.Text = text .. ": " .. value
        if callback then callback(value) end
    end

    track(barBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliderDragging = true
            update(input.Position.X)
        end
    end))

    track(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliderDragging = false
        end
    end))

    track(UserInputService.InputChanged:Connect(function(input)
        if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input.Position.X)
        end
    end))

    return {
        Set = function(_, newValue)
            newValue = math.clamp(tonumber(newValue) or min, min, max)
            value = newValue
            local newPercent = (value - min) / (max - min)
            fill.Size = UDim2.new(newPercent, 0, 1, 0)
            thumb.Position = UDim2.new(newPercent, -7, 0.5, -7)
            label.Text = text .. ": " .. value
            if callback then callback(value) end
        end,
        Get = function() return value end
    }
end

function Lib:Divider()
    State.ElementOrder += 1
    local parent = activeParent()
    local d = Instance.new("Frame")
    d.Size = UDim2.new(1, 0, 0, 1)
    d.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    d.BorderSizePixel = 0
    d.LayoutOrder = State.ElementOrder
    d.Parent = parent
end

function Lib:Label(text)
    State.ElementOrder += 1
    local parent = activeParent()
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 0)
    lbl.AutomaticSize = Enum.AutomaticSize.Y
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(200, 200, 220)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextYAlignment = Enum.TextYAlignment.Top
    lbl.TextWrapped = true
    lbl.LayoutOrder = State.ElementOrder
    lbl.Parent = parent
end

function Lib:Button(text, callback)
    State.ElementOrder += 1
    local parent = activeParent()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
    frame.BorderSizePixel = 0
    frame.LayoutOrder = State.ElementOrder
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(90, 90, 130)
    stroke.Thickness = 1
    stroke.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(230, 220, 200)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Parent = frame

    track(btn.MouseEnter:Connect(function()
        TweenService:Create(frame, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(40, 40, 60) }):Play()
    end))
    track(btn.MouseLeave:Connect(function()
        TweenService:Create(frame, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(25, 25, 38) }):Play()
    end))

    track(btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end))
end

function Lib:SetAutoToggle(v)
    State.Toggled = v
    if v then
        State.AutoBig.BackgroundColor3 = Color3.fromRGB(30, 60, 40)
        State.AutoBig.Text = "AUTO: ON"
        State.AutoBig.TextColor3 = Color3.fromRGB(150, 230, 170)
        State.AutoBigStroke.Color = Color3.fromRGB(80, 180, 110)
    else
        State.AutoBig.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        State.AutoBig.Text = "AUTO: OFF"
        State.AutoBig.TextColor3 = Color3.fromRGB(200, 200, 220)
        State.AutoBigStroke.Color = Color3.fromRGB(50, 50, 70)
        EnableManualControl()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:Move(Vector3.zero, false)
                hum.WalkSpeed = 16
            end
        end
    end
end

function Lib:SetSpeed(v) State.Speed = v end
function Lib:SetRadius(v) State.Radius = v end
function Lib:SetWeights(scriptW) State.ScriptWeight = scriptW; State.ManualWeight = 1 - scriptW end
function Lib:SetBombCheck(v) State.BombCheckEnabled = v end
function Lib:SetFixed(v)
    State.Fixed = v
    if v then
        State.LockedFrames[State.AutoFrame] = true
    else
        State.LockedFrames[State.AutoFrame] = nil
    end
end
function Lib:ShowAuto() State.AutoFrame.Visible = not State.AutoFrame.Visible end
function Lib:GetState() return State end

function Lib:StartAutoLoop()
    pcall(function() RunService:UnbindFromRenderStep("SimpleUI_Follow") end)
    RunService:BindToRenderStep(
        "SimpleUI_Follow",
        Enum.RenderPriority.Character.Value + 1,
        function()
            if not State.Toggled then return end
            local character = LocalPlayer.Character
            if not character then return end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local myRoot = character:FindFirstChild("HumanoidRootPart")
            if not humanoid or not myRoot or humanoid.Health <= 0 then return end

            humanoid.WalkSpeed = State.Speed

            local manualMove = GetManualMoveVector()
            local manualDir = Vector3.zero
            if manualMove.Magnitude > 0.05 then
                local camera = workspace.CurrentCamera
                if camera then
                    local forward = camera.CFrame.LookVector
                    local right = camera.CFrame.RightVector
                    local faceDir = (right * manualMove.X) + (forward * -manualMove.Z)
                    faceDir = Vector3.new(faceDir.X, 0, faceDir.Z)
                    if faceDir.Magnitude > 0.05 then
                        manualDir = faceDir.Unit
                    end
                end
            end

            local scriptDir = Vector3.zero
            if not State.BombCheckEnabled and not Lib:HasBomb() then
            else
                local target = Lib:GetNearestEnemy()
                if target and target.Character then
                    local tr = target.Character:FindFirstChild("HumanoidRootPart")
                    if tr then
                        local diff = tr.Position - myRoot.Position
                        local dist = diff.Magnitude
                        if dist > State.Radius then
                            scriptDir = diff.Unit
                        end
                    end
                end
            end

            local finalDir = (manualDir * State.ManualWeight) + (scriptDir * State.ScriptWeight)
            if finalDir.Magnitude > 0.05 then
                humanoid:Move(finalDir.Unit, false)
            else
                humanoid:Move(Vector3.zero, false)
            end
        end
    )
end

function Lib:HasBomb()
    local char = LocalPlayer.Character
    if not char then return false end
    return char:FindFirstChild("Bomb") ~= nil
end

function Lib:DetectMyTeam()
    local arenas = workspace:FindFirstChild("Arenas")
    if not arenas then return nil, nil end
    for _, arena in ipairs(arenas:GetChildren()) do
        local slots = arena:FindFirstChild("Slots")
        if slots then
            for _, side in ipairs({"Left", "Right"}) do
                local folder = slots:FindFirstChild(side)
                if folder then
                    for _, slot in ipairs(folder:GetChildren()) do
                        local slotData = slot:FindFirstChild("Data")
                        local playerObj = slotData and slotData:FindFirstChild("Player")
                        local player = playerObj and playerObj.Value
                        if player == LocalPlayer then
                            return side, arena
                        end
                    end
                end
            end
        end
    end
    return nil, nil
end

function Lib:RefreshTeam()
    local side, arena = Lib:DetectMyTeam()
    State.TEAM.side = side
    State.TEAM.arena = arena
    State.TEAM.mates = {}
    if not arena or not side then return end
    local slots = arena:FindFirstChild("Slots")
    if not slots then return end
    local folder = slots:FindFirstChild(side)
    if not folder then return end
    for _, slot in ipairs(folder:GetChildren()) do
        local slotData = slot:FindFirstChild("Data")
        local playerObj = slotData and slotData:FindFirstChild("Player")
        local player = playerObj and playerObj.Value
        if player and player:IsA("Player") then
            State.TEAM.mates[player.Name] = true
        end
    end
end

function Lib:GetAllEnemies()
    Lib:RefreshTeam()
    local list = {}
    if not State.TEAM.arena or not State.TEAM.side then return list end
    local slots = State.TEAM.arena:FindFirstChild("Slots")
    if not slots then return list end
    local enemySide = (State.TEAM.side == "Left") and "Right" or "Left"
    local folder = slots:FindFirstChild(enemySide)
    if not folder then return list end
    for _, slot in ipairs(folder:GetChildren()) do
        local slotData = slot:FindFirstChild("Data")
        local playerObj = slotData and slotData:FindFirstChild("Player")
        local player = playerObj and playerObj.Value
        if player and player:IsA("Player") and player ~= LocalPlayer then
            local alive = slotData:GetAttribute("Alive")
            if alive == true then
                table.insert(list, player)
            end
        end
    end
    return list
end

function Lib:GetNearestEnemy()
    Lib:RefreshTeam()
    local character = LocalPlayer.Character
    if not character then return nil end
    local myRoot = character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local nearest, nearestDist = nil, math.huge
    for _, player in ipairs(Lib:GetAllEnemies()) do
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if hum and root and hum.Health > 0 then
            local d = (myRoot.Position - root.Position).Magnitude
            if d < nearestDist then
                nearestDist = d
                nearest = player
            end
        end
    end
    return nearest
end

function Lib:ExpandPlayer(character)
    if not State.HitboxEnabled then return end
    if character.Name == LocalPlayer.Name then return end
    local head = character:FindFirstChild("Head")
    if not head or not head:IsA("BasePart") then return end
    if head:GetAttribute("SaifX_OriginalSizeX") ~= nil then return end
    head:SetAttribute("SaifX_OriginalSizeX", head.Size.X)
    head:SetAttribute("SaifX_OriginalSizeY", head.Size.Y)
    head:SetAttribute("SaifX_OriginalSizeZ", head.Size.Z)
    head.Size = State.HitboxSize
    head.CanCollide = false
end

function Lib:ResetPlayer(character)
    local head = character:FindFirstChild("Head")
    if head and head:IsA("BasePart") and head:GetAttribute("SaifX_OriginalSizeX") ~= nil then
        head.Size = Vector3.new(
            head:GetAttribute("SaifX_OriginalSizeX"),
            head:GetAttribute("SaifX_OriginalSizeY"),
            head:GetAttribute("SaifX_OriginalSizeZ")
        )
        head.CanCollide = true
        head:SetAttribute("SaifX_OriginalSizeX", nil)
        head:SetAttribute("SaifX_OriginalSizeY", nil)
        head:SetAttribute("SaifX_OriginalSizeZ", nil)
    end
end

function Lib:StartHitbox()
    local characters = workspace:WaitForChild("Characters")
    track(characters.ChildAdded:Connect(function(character)
        task.wait(0.5)
        if State.HitboxEnabled then Lib:ExpandPlayer(character) end
    end))
    task.spawn(function()
        while task.wait(0.5) do
            if State.HitboxEnabled then
                for _, character in ipairs(characters:GetChildren()) do
                    Lib:ExpandPlayer(character)
                end
            end
        end
    end)
end

function Lib:Destroy()
    for _, conn in ipairs(State.Connections) do
        pcall(function() conn:Disconnect() end)
    end
    State.Connections = {}
    pcall(function() RunService:UnbindFromRenderStep("SimpleUI_Follow") end)
    if State.ScreenGui then
        State.ScreenGui:Destroy()
        State.ScreenGui = nil
    end
end

return Lib