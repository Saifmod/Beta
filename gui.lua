local Library = {}
Library.__index = Library

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local MAIN_COLOR = Color3.fromRGB(255, 30, 60)
local BG_DARK = Color3.fromRGB(20, 20, 28)
local TEXT_WHITE = Color3.fromRGB(255, 255, 255)

function Library.CreateWindow(config)
    config = config or {}
    local hubTitle = config.Title or "NXT SYSTEM • VIP"
    
    local self = setmetatable({}, Library)
    self.isMainFrameLocked = false
    self.Pages = {}

    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NXT_CustomLibrary_Hub"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = PlayerGui

    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 440, 0, 260)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    mainFrame.BackgroundTransparency = 0.35
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui

    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = MAIN_COLOR
    mainStroke.Thickness = 1.8
    mainStroke.Parent = mainFrame

    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 36)
    header.BackgroundTransparency = 1
    header.Parent = mainFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -40, 1, 0)
    titleLabel.Position = UDim2.new(0, 14, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = hubTitle
    titleLabel.TextColor3 = TEXT_WHITE
    titleLabel.TextSize = 13
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = header

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 22, 0, 22)
    closeBtn.Position = UDim2.new(1, -30, 0, 7)
    closeBtn.BackgroundColor3 = Color3.fromRGB(25, 12, 18)
    closeBtn.BackgroundTransparency = 0.2
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = TEXT_WHITE
    closeBtn.TextSize = 12
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = header

    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
    local closeStroke = Instance.new("UIStroke")
    closeStroke.Color = MAIN_COLOR
    closeStroke.Thickness = 1
    closeStroke.Parent = closeBtn

    -- Sidebar
    local sidebarScroll = Instance.new("ScrollingFrame")
    sidebarScroll.Size = UDim2.new(0, 115, 1, -46)
    sidebarScroll.Position = UDim2.new(0, 10, 0, 38)
    sidebarScroll.BackgroundTransparency = 1
    sidebarScroll.BorderSizePixel = 0
    sidebarScroll.ScrollBarThickness = 2
    sidebarScroll.ScrollBarImageColor3 = MAIN_COLOR
    sidebarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    sidebarScroll.Parent = mainFrame

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Padding = UDim.new(0, 6)
    sidebarLayout.Parent = sidebarScroll

    sidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sidebarScroll.CanvasSize = UDim2.new(0, 0, 0, sidebarLayout.AbsoluteContentSize.Y + 10)
    end)

    -- Content Container
    local contentContainer = Instance.new("Frame")
    contentContainer.Size = UDim2.new(1, -135, 1, -46)
    contentContainer.Position = UDim2.new(0, 128, 0, 38)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = mainFrame

    -- Dragging
    local mainDragging, mainDragInput, mainDragStart, mainStartPos
    mainFrame.InputBegan:Connect(function(input)
        if not self.isMainFrameLocked and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            mainDragging = true
            mainDragStart = input.Position
            mainStartPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then mainDragging = false end
            end)
        end
    end)

    mainFrame.InputChanged:Connect(function(input)
        if not self.isMainFrameLocked and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            mainDragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not self.isMainFrameLocked and input == mainDragInput and mainDragging then
            local delta = input.Position - mainDragStart
            mainFrame.Position = UDim2.new(mainStartPos.X.Scale, mainStartPos.X.Offset + delta.X, mainStartPos.Y.Scale, mainStartPos.Y.Offset + delta.Y)
        end
    end)

    -- Toggle Hide Button
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 75, 0, 35)
    toggleBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    toggleBtn.BackgroundTransparency = 0.2
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = "إخفاء"
    toggleBtn.TextColor3 = TEXT_WHITE
    toggleBtn.TextSize = 12
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Parent = screenGui

    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 10)

    local isVisible = true
    local function toggleUI()
        isVisible = not isVisible
        mainFrame.Visible = isVisible
        toggleBtn.Text = isVisible and "إخفاء" or "إظهار"
    end

    closeBtn.MouseButton1Click:Connect(toggleUI)

    local btnDragging, btnDragStart, btnStartPos, hasMoved = false, nil, nil, false
    toggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            btnDragging, hasMoved = true, false
            btnDragStart, btnStartPos = input.Position, toggleBtn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    btnDragging = false
                    if not hasMoved then toggleUI() end
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if btnDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - btnDragStart
            if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then hasMoved = true end
            toggleBtn.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
        end
    end)

    self.SidebarScroll = sidebarScroll
    self.ContentContainer = contentContainer
    return self
end

function Library:Tab(title)
    local tabObj = {}
    local scrollPage = Instance.new("ScrollingFrame")
    scrollPage.Name = "Page_" .. title
    scrollPage.Size = UDim2.new(1, 0, 1, 0)
    scrollPage.BackgroundTransparency = 1
    scrollPage.BorderSizePixel = 0
    scrollPage.ScrollBarThickness = 2
    scrollPage.ScrollBarImageColor3 = MAIN_COLOR
    scrollPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollPage.Visible = false
    scrollPage.Parent = self.ContentContainer

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = scrollPage

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollPage.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)

    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -6, 0, 34)
    tabBtn.BackgroundColor3 = BG_DARK
    tabBtn.BackgroundTransparency = 0.5
    tabBtn.BorderSizePixel = 0
    tabBtn.Text = title
    tabBtn.TextColor3 = TEXT_WHITE
    tabBtn.TextSize = 11
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.Parent = self.SidebarScroll

    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 8)

    if #self.Pages == 0 then
        scrollPage.Visible = true
        tabBtn.BackgroundColor3 = MAIN_COLOR
        tabBtn.BackgroundTransparency = 0.25
    end

    table.insert(self.Pages, {Btn = tabBtn, Page = scrollPage})

    tabBtn.MouseButton1Click:Connect(function()
        for _, pData in ipairs(self.Pages) do
            pData.Page.Visible = false
            TweenService:Create(pData.Btn, TweenInfo.new(0.2), {BackgroundColor3 = BG_DARK, BackgroundTransparency = 0.5}):Play()
        end
        scrollPage.Visible = true
        TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundColor3 = MAIN_COLOR, BackgroundTransparency = 0.25}):Play()
    end)

    function tabObj:Button(opts)
        local btnTitle = opts.Title or opts[1] or "Button"
        local callback = opts.Callback or function() end

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -6, 0, 36)
        btn.BackgroundColor3 = BG_DARK
        btn.BackgroundTransparency = 0.3
        btn.BorderSizePixel = 0
        btn.Text = btnTitle
        btn.TextColor3 = TEXT_WHITE
        btn.TextSize = 12
        btn.Font = Enum.Font.GothamBold
        btn.Parent = scrollPage

        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    function tabObj:Toggle(opts)
        local title = opts.Title or "Toggle"
        local state = opts.Default or false
        local callback = opts.Callback or function() end

        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(1, -6, 0, 36)
        toggleFrame.BackgroundColor3 = BG_DARK
        toggleFrame.BackgroundTransparency = 0.3
        toggleFrame.Parent = scrollPage

        Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 8)
        local tfStroke = Instance.new("UIStroke") tfStroke.Color = MAIN_COLOR tfStroke.Thickness = 0.8 tfStroke.Parent = toggleFrame

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -55, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = title
        label.TextColor3 = TEXT_WHITE
        label.TextSize = 12
        label.Font = Enum.Font.GothamBold
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggleFrame

        local switchBg = Instance.new("TextButton")
        switchBg.Size = UDim2.new(0, 38, 0, 20)
        switchBg.Position = UDim2.new(1, -44, 0.5, -10)
        switchBg.BackgroundColor3 = state and MAIN_COLOR or Color3.fromRGB(40, 40, 50)
        switchBg.Text = ""
        switchBg.Parent = toggleFrame

        Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)

        local circle = Instance.new("Frame")
        circle.Size = UDim2.new(0, 16, 0, 16)
        circle.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        circle.BackgroundColor3 = TEXT_WHITE
        circle.Parent = switchBg

        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

        switchBg.MouseButton1Click:Connect(function()
            state = not state
            TweenService:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = state and MAIN_COLOR or Color3.fromRGB(40, 40, 50)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
            callback(state)
        end)
    end

    function tabObj:Section(title)
        local sectionFrame = Instance.new("Frame")
        sectionFrame.Size = UDim2.new(1, -6, 0, 24)
        sectionFrame.BackgroundTransparency = 1
        sectionFrame.Parent = scrollPage

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "— " .. title .. " —"
        label.TextColor3 = MAIN_COLOR
        label.TextSize = 11
        label.Font = Enum.Font.GothamBold
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.Parent = sectionFrame
    end

    return tabObj
end

return Library
