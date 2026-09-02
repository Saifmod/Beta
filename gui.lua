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

    -- [عنصر الشرح والملاحظات المضاف]
    function tabObj:Paragraph(opts)
        local title = typeof(opts) == "string" and opts or opts.Title or opts[1] or "Notice"
        local desc = typeof(opts) == "table" and (opts.Desc or opts[2]) or ""

        local paraFrame = Instance.new("Frame")
        paraFrame.Size = UDim2.new(1, -6, 0, desc ~= "" and 42 or 26)
        paraFrame.BackgroundColor3 = BG_DARK
        paraFrame.BackgroundTransparency = 0.5
        paraFrame.Parent = scrollPage

        Instance.new("UICorner", paraFrame).CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke")
        stroke.Color = MAIN_COLOR
        stroke.Thickness = 0.5
        stroke.Transparency = 0.5
        stroke.Parent = paraFrame

        local pTitle = Instance.new("TextLabel")
        pTitle.Size = UDim2.new(1, -16, 0, 18)
        pTitle.Position = UDim2.new(0, 8, 0, desc ~= "" and 4 or 4)
        pTitle.BackgroundTransparency = 1
        pTitle.Text = title
        pTitle.TextColor3 = MAIN_COLOR
        pTitle.TextSize = 11
        pTitle.Font = Enum.Font.GothamBold
        pTitle.TextXAlignment = Enum.TextXAlignment.Left
        pTitle.Parent = paraFrame

        if desc ~= "" then
            local pDesc = Instance.new("TextLabel")
            pDesc.Size = UDim2.new(1, -16, 0, 16)
            pDesc.Position = UDim2.new(0, 8, 0, 20)
            pDesc.BackgroundTransparency = 1
            pDesc.Text = desc
            pDesc.TextColor3 = TEXT_WHITE
            pDesc.TextSize = 10
            pDesc.Font = Enum.Font.Gotham
            pDesc.TextXAlignment = Enum.TextXAlignment.Left
            pDesc.Parent = paraFrame
        end
    end

    -- [عنصر السلايدر المضاف]
    function tabObj:Slider(opts)
        local title = opts.Title or "Slider"
        local min = opts.Min or 0
        local max = opts.Max or 100
        local default = opts.Default or min
        local callback = opts.Callback or function() end

        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(1, -6, 0, 42)
        sliderFrame.BackgroundColor3 = BG_DARK
        sliderFrame.BackgroundTransparency = 0.3
        sliderFrame.Parent = scrollPage

        Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 8)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -50, 0, 18)
        label.Position = UDim2.new(0, 10, 0, 4)
        label.BackgroundTransparency = 1
        label.Text = title
        label.TextColor3 = TEXT_WHITE
        label.TextSize = 11
        label.Font = Enum.Font.GothamBold
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = sliderFrame

        local valLabel = Instance.new("TextLabel")
        valLabel.Size = UDim2.new(0, 40, 0, 18)
        valLabel.Position = UDim2.new(1, -45, 0, 4)
        valLabel.BackgroundTransparency = 1
        valLabel.Text = tostring(default)
        valLabel.TextColor3 = MAIN_COLOR
        valLabel.TextSize = 11
        valLabel.Font = Enum.Font.GothamBold
        valLabel.TextXAlignment = Enum.TextXAlignment.Right
        valLabel.Parent = sliderFrame

        local barBg = Instance.new("Frame")
        barBg.Size = UDim2.new(1, -20, 0, 6)
        barBg.Position = UDim2.new(0, 10, 0, 26)
        barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        barBg.Parent = sliderFrame

        Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

        local barFill = Instance.new("Frame")
        barFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        barFill.BackgroundColor3 = MAIN_COLOR
        barFill.Parent = barBg

        Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

        local dragging = false
        local function update(input)
            local pos = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * pos)
            barFill.Size = UDim2.new(pos, 0, 1, 0)
            valLabel.Text = tostring(value)
            callback(value)
        end

        barBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                update(input)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                update(input)
            end
        end)
    end

    -- [عنصر حقل الكتابة المضاف]
    function tabObj:TextBox(opts)
        local title = opts.Title or "Input"
        local placeholder = opts.Placeholder or "Enter text..."
        local callback = opts.Callback or function() end

        local boxFrame = Instance.new("Frame")
        boxFrame.Size = UDim2.new(1, -6, 0, 36)
        boxFrame.BackgroundColor3 = BG_DARK
        boxFrame.BackgroundTransparency = 0.3
        boxFrame.Parent = scrollPage

        Instance.new("UICorner", boxFrame).CornerRadius = UDim.new(0, 8)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.5, -10, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = title
        label.TextColor3 = TEXT_WHITE
        label.TextSize = 11
        label.Font = Enum.Font.GothamBold
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = boxFrame

        local textBox = Instance.new("TextBox")
        textBox.Size = UDim2.new(0.5, -10, 0, 24)
        textBox.Position = UDim2.new(0.5, 0, 0.5, -12)
        textBox.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        textBox.Text = ""
        textBox.PlaceholderText = placeholder
        textBox.TextColor3 = TEXT_WHITE
        textBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
        textBox.TextSize = 10
        textBox.Font = Enum.Font.Gotham
        textBox.Parent = boxFrame

        Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 6)

        textBox.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                callback(textBox.Text)
            end
        end)
    end

    -- [عنصر القائمة المنسدلة المضاف]
    function tabObj:Dropdown(opts)
        local title = opts.Title or "Dropdown"
        local items = opts.Items or {}
        local callback = opts.Callback or function() end

        local dropped = false
        local dropFrame = Instance.new("Frame")
        dropFrame.Size = UDim2.new(1, -6, 0, 36)
        dropFrame.BackgroundColor3 = BG_DARK
        dropFrame.BackgroundTransparency = 0.3
        dropFrame.ClipsDescendants = true
        dropFrame.Parent = scrollPage

        Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 8)

        local mainBtn = Instance.new("TextButton")
        mainBtn.Size = UDim2.new(1, 0, 0, 36)
        mainBtn.BackgroundTransparency = 1
        mainBtn.Text = title .. "  ▼"
        mainBtn.TextColor3 = TEXT_WHITE
        mainBtn.TextSize = 11
        mainBtn.Font = Enum.Font.GothamBold
        mainBtn.Parent = dropFrame

        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, -12, 0, #items * 26)
        container.Position = UDim2.new(0, 6, 0, 36)
        container.BackgroundTransparency = 1
        container.Parent = dropFrame

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 2)
        layout.Parent = container

        for _, item in ipairs(items) do
            local itemBtn = Instance.new("TextButton")
            itemBtn.Size = UDim2.new(1, 0, 0, 24)
            itemBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            itemBtn.Text = tostring(item)
            itemBtn.TextColor3 = TEXT_WHITE
            itemBtn.TextSize = 10
            itemBtn.Font = Enum.Font.Gotham
            itemBtn.Parent = container

            Instance.new("UICorner", itemBtn).CornerRadius = UDim.new(0, 4)

            itemBtn.MouseButton1Click:Connect(function()
                mainBtn.Text = title .. ": " .. tostring(item)
                dropped = false
                TweenService:Create(dropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, -6, 0, 36)}):Play()
                callback(item)
            end)
        end

        mainBtn.MouseButton1Click:Connect(function()
            dropped = not dropped
            local targetSize = dropped and UDim2.new(1, -6, 0, 40 + (#items * 26)) or UDim2.new(1, -6, 0, 36)
            TweenService:Create(dropFrame, TweenInfo.new(0.2), {Size = targetSize}):Play()
        end)
    end

    return tabObj
end

return Library
