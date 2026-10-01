--==================================================
-- SAIF LIBRARY
--==================================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Library = {}

--==================================================
-- CREATE WINDOW
--==================================================

function Library:CreateWindow(options)

    options = options or {}

    local Window = {}

    local TitleText = options.Title or "💣 timebomb | tik ; 9yy_9"

    --==================================================
    -- SCREEN GUI
    --==================================================

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TabUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.CoreGui

    --==================================================
    -- MAIN FRAME
    --==================================================

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 380, 0, 220)
    MainFrame.Position = UDim2.new(0.5, -190, 0.5, -110)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = false
    MainFrame.Parent = ScreenGui

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

    --==================================================
    -- TOP BAR
    --==================================================

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
    Title.Text = TitleText
    Title.TextColor3 = Color3.fromRGB(230, 220, 200)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 12
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    --==================================================
    -- MINIMIZE BUTTON
    --==================================================

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

    --==================================================
    -- CLOSE BUTTON
    --==================================================

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

    --==================================================
    -- TAB BAR
    --==================================================

    local TabBar = Instance.new("ScrollingFrame")
    TabBar.Size = UDim2.new(0, 110, 1, -45)
    TabBar.Position = UDim2.new(0, 10, 0, 42)
    TabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    TabBar.BorderSizePixel = 0
    TabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabBar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabBar.ScrollingDirection = Enum.ScrollingDirection.Y
    TabBar.ScrollingEnabled = true
    TabBar.ScrollBarThickness = 3
    TabBar.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 110)
    TabBar.ScrollBarImageTransparency = 0.3
    TabBar.ClipsDescendants = true
    TabBar.Active = true
    TabBar.Parent = MainFrame

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 10)
    TabCorner.Parent = TabBar

    local TabStroke = Instance.new("UIStroke")
    TabStroke.Color = Color3.fromRGB(40, 40, 55)
    TabStroke.Thickness = 1
    TabStroke.Parent = TabBar

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 6)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Parent = TabBar

    local TabPad = Instance.new("UIPadding")
    TabPad.PaddingTop = UDim.new(0, 10)
    TabPad.PaddingLeft = UDim.new(0, 8)
    TabPad.PaddingRight = UDim.new(0, 8)
    TabPad.PaddingBottom = UDim.new(0, 10)
    TabPad.Parent = TabBar

    --==================================================
    -- CONTENT FRAME
    --==================================================

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, -130, 1, -45)
    ContentFrame.Position = UDim2.new(0, 122, 0, 42)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    ContentFrame.BorderSizePixel = 0
    ContentFrame.ClipsDescendants = true
    ContentFrame.Parent = MainFrame

    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 10)
    ContentCorner.Parent = ContentFrame

    local ContentStroke = Instance.new("UIStroke")
    ContentStroke.Color = Color3.fromRGB(40, 40, 55)
    ContentStroke.Thickness = 1
    ContentStroke.Parent = ContentFrame

    --==================================================
    -- DRAG
    --==================================================

    local dragging = false
    local dragStart
    local startPos

    TopBar.InputBegan:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)

    TopBar.InputEnded:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)

        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then

            local delta = input.Position - dragStart

            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    --==================================================
    -- TABS
    --==================================================

    local Tabs = {}
    local TabOrder = 0
    local currentTab = nil

    function Window:CreateTab(name)

        TabOrder += 1

        local Tab = {}

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(200, 200, 220)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.LayoutOrder = TabOrder
        btn.Parent = TabBar

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = btn

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(50, 50, 70)
        stroke.Thickness = 1
        stroke.Parent = btn

        local content = Instance.new("ScrollingFrame")

        content.Name = name .. "_Content"
        content.Size = UDim2.new(1, -16, 1, -16)
        content.Position = UDim2.new(0, 8, 0, 8)
        content.BackgroundTransparency = 1
        content.BorderSizePixel = 0
        content.Visible = false
        content.CanvasSize = UDim2.new(0, 0, 0, 0)
        content.AutomaticCanvasSize = Enum.AutomaticSize.Y
        content.ScrollingDirection = Enum.ScrollingDirection.Y
        content.ScrollingEnabled = true
        content.ScrollBarThickness = 4
        content.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 110)
        content.ScrollBarImageTransparency = 0.3
        content.Active = true
        content.ClipsDescendants = true
        content.Parent = ContentFrame

        local ContentPad = Instance.new("UIPadding")
        ContentPad.PaddingTop = UDim.new(0, 1)
        ContentPad.PaddingBottom = UDim.new(0, 10)
        ContentPad.PaddingLeft = UDim.new(0, 1)
        ContentPad.PaddingRight = UDim.new(0, 6)
        ContentPad.Parent = content

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 6)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = content

        Tabs[name] = {
            button = btn,
            content = content
        }

        btn.MouseButton1Click:Connect(function()

            if currentTab == name then
                return
            end

            -- إخفاء كل التابات فوراً
            for _, tab in pairs(Tabs) do

                tab.content.Visible = false
                tab.content.Position = UDim2.new(0, 8, 0, 8)

                tab.button.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
                tab.button.TextColor3 = Color3.fromRGB(200, 200, 220)
            end

            currentTab = name

            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
            btn.TextColor3 = Color3.fromRGB(230, 220, 200)

            content.Position = UDim2.new(0, 18, 0, 8)
            content.Visible = true

            TweenService:Create(
                content,
                TweenInfo.new(
                    0.18,
                    Enum.EasingStyle.Quart,
                    Enum.EasingDirection.Out
                ),
                {
                    Position = UDim2.new(0, 8, 0, 8)
                }
            ):Play()
        end)

        --==================================================
        -- BUTTON
        --==================================================

        function Tab:CreateButton(text, callback)

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 32)
            frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
            frame.BorderSizePixel = 0
            frame.Parent = content

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = frame

            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(50, 50, 70)
            stroke.Thickness = 1
            stroke.Parent = frame

            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 1, 0)
            button.BackgroundTransparency = 1
            button.Text = text
            button.TextColor3 = Color3.fromRGB(200, 200, 220)
            button.Font = Enum.Font.GothamBold
            button.TextSize = 11
            button.Parent = frame

            button.MouseEnter:Connect(function()

                TweenService:Create(
                    frame,
                    TweenInfo.new(0.15),
                    {
                        BackgroundColor3 = Color3.fromRGB(35, 35, 50)
                    }
                ):Play()
            end)

            button.MouseLeave:Connect(function()

                TweenService:Create(
                    frame,
                    TweenInfo.new(0.15),
                    {
                        BackgroundColor3 = Color3.fromRGB(20, 20, 30)
                    }
                ):Play()
            end)

            button.MouseButton1Click:Connect(function()

                if callback then
                    callback()
                end
            end)

            return frame
        end
        
        --==================================================
-- INPUT BOX
--==================================================

function Tab:CreateInput(text, placeholder, callback)

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 42)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    Frame.BorderSizePixel = 0
    Frame.Parent = content

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(50, 50, 70)
    Stroke.Thickness = 1
    Stroke.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.42, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 220)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(0.48, -10, 0, 26)
    TextBox.Position = UDim2.new(0.48, 0, 0.5, -13)
    TextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    TextBox.BorderSizePixel = 0
    TextBox.Text = ""
    TextBox.PlaceholderText = placeholder or "اكتب هنا..."
    TextBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
    TextBox.TextColor3 = Color3.fromRGB(220, 220, 235)
    TextBox.Font = Enum.Font.Gotham
    TextBox.TextSize = 10
    TextBox.ClearTextOnFocus = false
    TextBox.TextXAlignment = Enum.TextXAlignment.Center
    TextBox.Parent = Frame

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 5)
    BoxCorner.Parent = TextBox

    local BoxStroke = Instance.new("UIStroke")
    BoxStroke.Color = Color3.fromRGB(50, 50, 70)
    BoxStroke.Thickness = 1
    BoxStroke.Parent = TextBox

    TextBox.Focused:Connect(function()
        TweenService:Create(
            TextBox,
            TweenInfo.new(0.15),
            {BackgroundColor3 = Color3.fromRGB(35, 35, 50)}
        ):Play()

        TweenService:Create(
            BoxStroke,
            TweenInfo.new(0.15),
            {Color = Color3.fromRGB(80, 80, 110)}
        ):Play()
    end)

    TextBox.FocusLost:Connect(function()
        TweenService:Create(
            TextBox,
            TweenInfo.new(0.15),
            {BackgroundColor3 = Color3.fromRGB(30, 30, 42)}
        ):Play()

        TweenService:Create(
            BoxStroke,
            TweenInfo.new(0.15),
            {Color = Color3.fromRGB(50, 50, 70)}
        ):Play()

        if callback then
            callback(TextBox.Text)
        end
    end)

    return {
        Set = function(value)
            TextBox.Text = tostring(value)
        end,

        Get = function()
            return TextBox.Text
        end,

        Clear = function()
            TextBox.Text = ""
        end
    }
end

        --==================================================
        -- TOGGLE
        --==================================================

        function Tab:CreateToggle(text, default, callback)

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 32)
            frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
            frame.BorderSizePixel = 0
            frame.Parent = content

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

                    TweenService:Create(
                        circle,
                        TweenInfo.new(0.2),
                        {
                            Position = UDim2.new(1, -18, 0.5, -8)
                        }
                    ):Play()

                    TweenService:Create(
                        toggleBg,
                        TweenInfo.new(0.2),
                        {
                            BackgroundColor3 = Color3.fromRGB(30, 60, 40)
                        }
                    ):Play()

                    TweenService:Create(
                        circle,
                        TweenInfo.new(0.2),
                        {
                            BackgroundColor3 = Color3.fromRGB(150, 230, 170)
                        }
                    ):Play()

                    stroke.Color = Color3.fromRGB(80, 180, 110)
                    label.TextColor3 = Color3.fromRGB(150, 230, 170)

                else

                    TweenService:Create(
                        circle,
                        TweenInfo.new(0.2),
                        {
                            Position = UDim2.new(0, 2, 0.5, -8)
                        }
                    ):Play()

                    TweenService:Create(
                        toggleBg,
                        TweenInfo.new(0.2),
                        {
                            BackgroundColor3 = Color3.fromRGB(40, 40, 55)
                        }
                    ):Play()

                    TweenService:Create(
                        circle,
                        TweenInfo.new(0.2),
                        {
                            BackgroundColor3 = Color3.fromRGB(230, 220, 200)
                        }
                    ):Play()

                    stroke.Color = Color3.fromRGB(50, 50, 70)
                    label.TextColor3 = Color3.fromRGB(200, 200, 220)
                end
            end

            UpdateToggle()

            button.MouseButton1Click:Connect(function()

                toggled = not toggled

                UpdateToggle()

                if callback then
                    callback(toggled)
                end
            end)

            return {
                Set = function(_, value)

                    toggled = value == true

                    UpdateToggle()

                    if callback then
                        callback(toggled)
                    end
                end,

                Get = function()
                    return toggled
                end
            }
        end

        --==================================================
        -- SLIDER
        --==================================================

        function Tab:CreateSlider(text, min, max, default, callback)

            min = tonumber(min) or 0
            max = tonumber(max) or 100
            default = tonumber(default) or min

            if max <= min then
                max = min + 1
            end

            default = math.clamp(default, min, max)

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 40)
            frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
            frame.BorderSizePixel = 0
            frame.Parent = content

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

                local newPercent = math.clamp(
                    (inputX - barX) / barWidth,
                    0,
                    1
                )

                value = math.floor(
                    min + (max - min) * newPercent
                )

                fill.Size = UDim2.new(newPercent, 0, 1, 0)

                thumb.Position = UDim2.new(
                    newPercent,
                    -7,
                    0.5,
                    -7
                )

                label.Text = text .. ": " .. value

                if callback then
                    callback(value)
                end
            end

            barBg.InputBegan:Connect(function(input)

                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then

                    sliderDragging = true
                    update(input.Position.X)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)

                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then

                    sliderDragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)

                if sliderDragging and (
                    input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch
                ) then

                    update(input.Position.X)
                end
            end)

            return {
                Set = function(_, newValue)

                    newValue = math.clamp(
                        tonumber(newValue) or min,
                        min,
                        max
                    )

                    value = newValue

                    local newPercent =
                        (value - min) / (max - min)

                    fill.Size = UDim2.new(
                        newPercent,
                        0,
                        1,
                        0
                    )

                    thumb.Position = UDim2.new(
                        newPercent,
                        -7,
                        0.5,
                        -7
                    )

                    label.Text = text .. ": " .. value

                    if callback then
                        callback(value)
                    end
                end,

                Get = function()
                    return value
                end
            }
        end

--==================================================
-- DROPDOWN
--==================================================

function Tab:CreateDropdown(text, options, callback)

    options = options or {}

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 34)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = false
    frame.Parent = content

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(50, 50, 70)
    stroke.Thickness = 1
    stroke.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = text
    button.TextColor3 = Color3.fromRGB(200, 200, 220)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 11
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.Parent = frame

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = button

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -25, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(150, 150, 170)
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 10
    arrow.Parent = frame

    local listFrame = Instance.new("Frame")
    listFrame.Size = UDim2.new(1, 0, 0, 0)
    listFrame.Position = UDim2.new(0, 0, 1, 4)
    listFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    listFrame.BorderSizePixel = 0
    listFrame.Visible = false
    listFrame.ClipsDescendants = true
    listFrame.ZIndex = 10
    listFrame.Parent = frame

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 6)
    listCorner.Parent = listFrame

    local listStroke = Instance.new("UIStroke")
    listStroke.Color = Color3.fromRGB(50, 50, 70)
    listStroke.Thickness = 1
    listStroke.Parent = listFrame

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -6, 1, -6)
    scroll.Position = UDim2.new(0, 3, 0, 3)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 110)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollingDirection = Enum.ScrollingDirection.Y
    scroll.ZIndex = 11
    scroll.Parent = listFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 2)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = scroll

    local isOpen = false

    button.MouseButton1Click:Connect(function()

        isOpen = not isOpen

        if isOpen then

            listFrame.Visible = true

            local targetHeight = math.min(
                #options * 24 + 6,
                130
            )

            TweenService:Create(
                listFrame,
                TweenInfo.new(0.2),
                {
                    Size = UDim2.new(1, 0, 0, targetHeight)
                }
            ):Play()

            arrow.Text = "▲"

        else

            local tween = TweenService:Create(
                listFrame,
                TweenInfo.new(0.2),
                {
                    Size = UDim2.new(1, 0, 0, 0)
                }
            )

            tween:Play()

            tween.Completed:Connect(function()
                if not isOpen then
                    listFrame.Visible = false
                end
            end)

            arrow.Text = "▼"
        end
    end)

    for index, option in pairs(options) do

        local opt = Instance.new("TextButton")
        opt.Size = UDim2.new(1, 0, 0, 22)
        opt.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        opt.BorderSizePixel = 0
        opt.Text = tostring(option)
        opt.TextColor3 = Color3.fromRGB(200, 200, 220)
        opt.Font = Enum.Font.GothamBold
        opt.TextSize = 10
        opt.ZIndex = 12
        opt.LayoutOrder = index
        opt.Parent = scroll

        local optCorner = Instance.new("UICorner")
        optCorner.CornerRadius = UDim.new(0, 4)
        optCorner.Parent = opt

        opt.MouseEnter:Connect(function()

            TweenService:Create(
                opt,
                TweenInfo.new(0.15),
                {
                    BackgroundColor3 = Color3.fromRGB(35, 35, 50)
                }
            ):Play()

        end)

        opt.MouseLeave:Connect(function()

            TweenService:Create(
                opt,
                TweenInfo.new(0.15),
                {
                    BackgroundColor3 = Color3.fromRGB(20, 20, 30)
                }
            ):Play()

        end)

        opt.MouseButton1Click:Connect(function()

            button.Text = text .. ": " .. tostring(option)

            local tween = TweenService:Create(
                listFrame,
                TweenInfo.new(0.2),
                {
                    Size = UDim2.new(1, 0, 0, 0)
                }
            )

            tween:Play()

            tween.Completed:Connect(function()
                listFrame.Visible = false
            end)

            arrow.Text = "▼"
            isOpen = false

            if callback then
                callback(option)
            end
        end)
    end

    return frame
end


--==================================================
-- SAIF NOTIFICATION
--==================================================

local TweenService = game:GetService("TweenService")

-- Notification Holder
local NotificationHolder = Instance.new("Frame")
NotificationHolder.Name = "NotificationHolder"
NotificationHolder.Size = UDim2.new(0, 300, 1, -20)
NotificationHolder.Position = UDim2.new(1, -315, 0, 10)
NotificationHolder.BackgroundTransparency = 1
NotificationHolder.Parent = ScreenGui

local NotificationLayout = Instance.new("UIListLayout")
NotificationLayout.Padding = UDim.new(0, 8)
NotificationLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotificationLayout.VerticalAlignment = Enum.VerticalAlignment.Top
NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotificationLayout.Parent = NotificationHolder


function Window:Notify(data)

    data = data or {}

    local Title = data.Title or "SAIF"
    local Description = data.Description or ""
    local Duration = data.Duration or 3

    local Notification = Instance.new("Frame")
    Notification.Name = "Notification"
    Notification.Size = UDim2.new(0, 0, 0, 70)
    Notification.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Notification.BackgroundTransparency = 0.05
    Notification.BorderSizePixel = 0
    Notification.ClipsDescendants = true
    Notification.LayoutOrder = os.clock()
    Notification.Parent = NotificationHolder

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Notification

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(55, 55, 55)
    Stroke.Thickness = 1
    Stroke.Transparency = 0.2
    Stroke.Parent = Notification

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 0, 25)
    TitleLabel.Position = UDim2.new(0, 10, 0, 7)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = tostring(Title)
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 15
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Notification

    local DescriptionLabel = Instance.new("TextLabel")
    DescriptionLabel.Size = UDim2.new(1, -20, 0, 30)
    DescriptionLabel.Position = UDim2.new(0, 10, 0, 32)
    DescriptionLabel.BackgroundTransparency = 1
    DescriptionLabel.Text = tostring(Description)
    DescriptionLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    DescriptionLabel.TextSize = 13
    DescriptionLabel.Font = Enum.Font.Gotham
    DescriptionLabel.TextWrapped = true
    DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescriptionLabel.Parent = Notification

    -- دخول الإشعار
    TweenService:Create(
        Notification,
        TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0, 300, 0, 70)
        }
    ):Play()

    -- انتظار مدة الإشعار
    task.delay(Duration, function()

        if not Notification or not Notification.Parent then
            return
        end

        local OutTween = TweenService:Create(
            Notification,
            TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
            {
                Size = UDim2.new(0, 0, 0, 70)
            }
        )

        OutTween:Play()
        OutTween.Completed:Wait()

        Notification:Destroy()
    end)
end

        --==================================================
        -- DIVIDER
        --==================================================

        function Tab:CreateDivider()

            local Divider = Instance.new("Frame")
            Divider.Size = UDim2.new(1, 0, 0, 1)
            Divider.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            Divider.BorderSizePixel = 0
            Divider.LayoutOrder = #content:GetChildren()
            Divider.Parent = content

            return Divider
        end

        --==================================================
        -- PARAGRAPH
        --==================================================

        function Tab:CreateParagraph(title, description)

            local Paragraph = Instance.new("Frame")
            Paragraph.Size = UDim2.new(1, 0, 0, 55)
            Paragraph.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
            Paragraph.BorderSizePixel = 0
            Paragraph.LayoutOrder = #content:GetChildren()
            Paragraph.Parent = content

            local PCorner = Instance.new("UICorner")
            PCorner.CornerRadius = UDim.new(0, 7)
            PCorner.Parent = Paragraph

            local PTitle = Instance.new("TextLabel")
            PTitle.Size = UDim2.new(1, -20, 0, 20)
            PTitle.Position = UDim2.new(0, 10, 0, 5)
            PTitle.BackgroundTransparency = 1
            PTitle.Text = title
            PTitle.TextColor3 = Color3.fromRGB(230, 220, 200)
            PTitle.TextSize = 12
            PTitle.Font = Enum.Font.GothamBold
            PTitle.TextXAlignment = Enum.TextXAlignment.Left
            PTitle.Parent = Paragraph

            local PDesc = Instance.new("TextLabel")
            PDesc.Size = UDim2.new(1, -20, 0, 25)
            PDesc.Position = UDim2.new(0, 10, 0, 25)
            PDesc.BackgroundTransparency = 1
            PDesc.Text = description
            PDesc.TextColor3 = Color3.fromRGB(160, 160, 180)
            PDesc.TextSize = 11
            PDesc.Font = Enum.Font.Gotham
            PDesc.TextWrapped = true
            PDesc.TextXAlignment = Enum.TextXAlignment.Left
            PDesc.Parent = Paragraph

            return Paragraph
        end

        --==================================================
        -- LABEL
        --==================================================

        function Tab:CreateLabel(text)

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0, 22)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(200, 200, 220)
            Label.TextSize = 12
            Label.Font = Enum.Font.GothamSemibold
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.LayoutOrder = #content:GetChildren()
            Label.Parent = content

            return Label
        end

        return Tab
    end

    --==================================================
    -- CLOSE
    --==================================================

    --==================================================
-- CLOSE CONFIRMATION
--==================================================

local function ShowCloseDialog()

    local Overlay = Instance.new("Frame")
    Overlay.Name = "CloseDialog"
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Overlay.BackgroundTransparency = 0.45
    Overlay.BorderSizePixel = 0
    Overlay.ZIndex = 100
    Overlay.Parent = ScreenGui

    local Dialog = Instance.new("Frame")
    Dialog.Size = UDim2.new(0, 300, 0, 160)
    Dialog.Position = UDim2.new(0.5, -150, 0.5, -80)
    Dialog.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Dialog.BorderSizePixel = 0
    Dialog.ZIndex = 101
    Dialog.Parent = Overlay

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Dialog

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(55, 55, 55)
    Stroke.Thickness = 1
    Stroke.Parent = Dialog

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 0, 30)
    Title.Position = UDim2.new(0, 10, 0, 12)
    Title.BackgroundTransparency = 1
    Title.Text = "إغلاق السكربت"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 17
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Center
    Title.ZIndex = 102
    Title.Parent = Dialog

    local Description = Instance.new("TextLabel")
    Description.Size = UDim2.new(1, -30, 0, 35)
    Description.Position = UDim2.new(0, 15, 0, 48)
    Description.BackgroundTransparency = 1
    Description.Text = "هل تريد إغلاق السكربت؟"
    Description.TextColor3 = Color3.fromRGB(180, 180, 180)
    Description.TextSize = 14
    Description.Font = Enum.Font.Gotham
    Description.TextXAlignment = Enum.TextXAlignment.Center
    Description.ZIndex = 102
    Description.Parent = Dialog

    -- نعم
    local Yes = Instance.new("TextButton")
    Yes.Size = UDim2.new(0.42, 0, 0, 35)
    Yes.Position = UDim2.new(0.06, 0, 1, -47)
    Yes.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Yes.BorderSizePixel = 0
    Yes.Text = "نعم"
    Yes.TextColor3 = Color3.fromRGB(255, 255, 255)
    Yes.TextSize = 14
    Yes.Font = Enum.Font.GothamMedium
    Yes.ZIndex = 102
    Yes.Parent = Dialog

    local YesCorner = Instance.new("UICorner")
    YesCorner.CornerRadius = UDim.new(0, 7)
    YesCorner.Parent = Yes

    -- لا
    local No = Instance.new("TextButton")
    No.Size = UDim2.new(0.42, 0, 0, 35)
    No.Position = UDim2.new(0.52, 0, 1, -47)
    No.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    No.BorderSizePixel = 0
    No.Text = "لا"
    No.TextColor3 = Color3.fromRGB(255, 255, 255)
    No.TextSize = 14
    No.Font = Enum.Font.GothamMedium
    No.ZIndex = 102
    No.Parent = Dialog

    local NoCorner = Instance.new("UICorner")
    NoCorner.CornerRadius = UDim.new(0, 7)
    NoCorner.Parent = No

    -- نعم
    Yes.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- لا
    No.MouseButton1Click:Connect(function()
        Overlay:Destroy()
    end)
end

--==================================================
-- CLOSE BUTTON
--==================================================

CloseBtn.MouseButton1Click:Connect(function()
    ShowCloseDialog()
end)

    --==================================================
    -- MINIMIZE
    --==================================================

    local minimized = false
    local originalSize = MainFrame.Size
    local minimizeTween

    MinBtn.MouseButton1Click:Connect(function()

        if minimizeTween then
            minimizeTween:Cancel()
        end

        minimized = not minimized

        if minimized then

            TabBar.Visible = false
            ContentFrame.Visible = false

            minimizeTween = TweenService:Create(
                MainFrame,
                TweenInfo.new(
                    0.3,
                    Enum.EasingStyle.Quart,
                    Enum.EasingDirection.Out
                ),
                {
                    Size = UDim2.new(0, 380, 0, 32)
                }
            )

            minimizeTween:Play()

        else

            minimizeTween = TweenService:Create(
                MainFrame,
                TweenInfo.new(
                    0.3,
                    Enum.EasingStyle.Quart,
                    Enum.EasingDirection.Out
                ),
                {
                    Size = originalSize
                }
            )

            minimizeTween:Play()

            minimizeTween.Completed:Connect(function()

                if not minimized then
                    TabBar.Visible = true
                    ContentFrame.Visible = true
                end
            end)
        end
    end)

    --==================================================
    -- DESTROY
    --==================================================

    function Window:Destroy()

        if ScreenGui then
            ScreenGui:Destroy()
        end
    end

    --==================================================
    -- RETURN
    --==================================================

    return Window
end

return Library