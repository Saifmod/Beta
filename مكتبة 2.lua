-- language: Lua, target: Roblox (executor), type: SAIF UI Library
local SAIF_Lib = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local elementOrder = 0

local function makeDraggable(frame, handle)
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function SAIF_Lib:CreateWindow(titleText)
    local Window = {}
    local Tabs = {}
    local currentTab = nil

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SAIF_Lib_UI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 380, 0, 320)
    MainFrame.Position = UDim2.new(0.5, -190, 0.5, -160)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
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
    Title.Text = titleText or "SAIF UI"
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
    TabBar.Size = UDim2.new(1, -20, 0, 30)
    TabBar.Position = UDim2.new(0, 10, 0, 40)
    TabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    TabBar.BorderSizePixel = 0
    TabBar.Parent = MainFrame

    local TabBarCorner = Instance.new("UICorner")
    TabBarCorner.CornerRadius = UDim.new(0, 8)
    TabBarCorner.Parent = TabBar

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.Padding = UDim.new(0, 4)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Parent = TabBar

    local TabPad = Instance.new("UIPadding")
    TabPad.PaddingTop = UDim.new(0, 4)
    TabPad.PaddingBottom = UDim.new(0, 4)
    TabPad.PaddingLeft = UDim.new(0, 4)
    TabPad.PaddingRight = UDim.new(0, 4)
    TabPad.Parent = TabBar

    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Size = UDim2.new(1, -20, 1, -90)
    ContentFrame.Position = UDim2.new(0, 10, 0, 80)
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

    local function SwitchTab(tabName)
        for name, tab in pairs(Tabs) do
            if name == tabName then
                tab.page.Visible = true
                tab.btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
                tab.btn.TextColor3 = Color3.fromRGB(230, 220, 200)
                tab.stroke.Color = Color3.fromRGB(90, 90, 130)
            else
                tab.page.Visible = false
                tab.btn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
                tab.btn.TextColor3 = Color3.fromRGB(200, 200, 220)
                tab.stroke.Color = Color3.fromRGB(50, 50, 70)
            end
        end
    end

    function Window:CreateTab(name)
        local Tab = {}
        local tabOrder = 0

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 100, 1, 0)
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(200, 200, 220)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.Parent = TabBar

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = btn

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(50, 50, 70)
        stroke.Thickness = 1
        stroke.Parent = btn

        local page = Instance.new("Frame")
        page.Size = UDim2.new(1, 0, 0, 0)
        page.AutomaticSize = Enum.AutomaticSize.Y
        page.BackgroundTransparency = 1
        page.Visible = false
        page.Parent = ContentFrame

        local pageLayout = Instance.new("UIListLayout")
        pageLayout.Padding = UDim.new(0, 6)
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Parent = page

        Tabs[name] = { btn = btn, stroke = stroke, page = page }

        btn.MouseButton1Click:Connect(function()
            SwitchTab(name)
        end)

        if not currentTab then
            currentTab = name
            SwitchTab(name)
        end

        function Tab:AddDivider()
            tabOrder += 1
            local d = Instance.new("Frame")
            d.Size = UDim2.new(1, 0, 0, 1)
            d.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            d.BorderSizePixel = 0
            d.LayoutOrder = tabOrder
            d.Parent = page
        end

        function Tab:AddLabel(text)
            tabOrder += 1
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
            lbl.LayoutOrder = tabOrder
            lbl.Parent = page
        end

        function Tab:AddButton(text, callback)
            tabOrder += 1
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 36)
            frame.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
            frame.BorderSizePixel = 0
            frame.LayoutOrder = tabOrder
            frame.Parent = page

            local fCorner = Instance.new("UICorner")
            fCorner.CornerRadius = UDim.new(0, 8)
            fCorner.Parent = frame

            local fStroke = Instance.new("UIStroke")
            fStroke.Color = Color3.fromRGB(90, 90, 130)
            fStroke.Thickness = 1
            fStroke.Parent = frame

            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 1, 0)
            b.BackgroundTransparency = 1
            b.Text = text
            b.TextColor3 = Color3.fromRGB(230, 220, 200)
            b.Font = Enum.Font.GothamBold
            b.TextSize = 13
            b.Parent = frame

            b.MouseEnter:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(40, 40, 60) }):Play()
            end)
            b.MouseLeave:Connect(function()
                TweenService:Create(frame, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(25, 25, 38) }):Play()
            end)

            b.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
        end

        function Tab:AddToggle(text, default, callback)
            tabOrder += 1
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 32)
            frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
            frame.BorderSizePixel = 0
            frame.LayoutOrder = tabOrder
            frame.Parent = page

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

            button.MouseButton1Click:Connect(function()
                toggled = not toggled
                UpdateToggle()
                if callback then callback(toggled) end
            end)

            return {
                Set = function(_, value)
                    toggled = value == true
                    UpdateToggle()
                    if callback then callback(toggled) end
                end,
                Get = function() return toggled end
            }
        end

        function Tab:AddSlider(text, min, max, default, callback)
            tabOrder += 1
            min = tonumber(min) or 0
            max = tonumber(max) or 100
            default = tonumber(default) or min
            if max <= min then max = min + 1 end
            default = math.clamp(default, min, max)

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 40)
            frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
            frame.BorderSizePixel = 0
            frame.LayoutOrder = tabOrder
            frame.Parent = page

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

            barBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliderDragging = true
                    update(input.Position.X)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliderDragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    update(input.Position.X)
                end
            end)

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

        return Tab
    end

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local minimized = false
    local originalSize = MainFrame.Size
    local minimizeTween

    MinBtn.MouseButton1Click:Connect(function()
        if minimizeTween then minimizeTween:Cancel() end
        minimized = not minimized

        if minimized then
            ContentFrame.Visible = false
            TabBar.Visible = false
            minimizeTween = TweenService:Create(
                MainFrame,
                TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                { Size = UDim2.new(0, 380, 0, 32) }
            )
            minimizeTween:Play()
        else
            minimizeTween = TweenService:Create(
                MainFrame,
                TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                { Size = originalSize }
            )
            minimizeTween:Play()
            minimizeTween.Completed:Connect(function()
                if not minimized then
                    ContentFrame.Visible = true
                    TabBar.Visible = true
                end
            end)
        end
    end)

    return Window
end

return SAIF_Lib