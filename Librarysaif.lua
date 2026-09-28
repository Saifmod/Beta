--// Library saif
--// Roblox UI Library

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Library = {}

local function Tween(object, time, properties)
    local tween = TweenService:Create(
        object,
        TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        properties
    )

    tween:Play()
    return tween
end

function Library:CreateWindow(options)
    options = options or {}

    local TitleText = options.Title or "Library saif"

    local Window = {}
    local Tabs = {}
    local CurrentTab = nil

    --// ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LibrarySaif"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    pcall(function()
        ScreenGui.Parent = game.CoreGui
    end)

    if not ScreenGui.Parent then
        local player = game:GetService("Players").LocalPlayer
        if player then
            ScreenGui.Parent = player:WaitForChild("PlayerGui")
        end
    end

    --// Main Window
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -190, 0.5, -110)
    MainFrame.Size = UDim2.new(0, 380, 0, 220)
    MainFrame.ClipsDescendants = true

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(55, 55, 70)
    MainStroke.Thickness = 1
    MainStroke.Parent = MainFrame

    local MainGradient = Instance.new("UIGradient")
    MainGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 28)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 15))
    })
    MainGradient.Rotation = 90
    MainGradient.Parent = MainFrame

    --// Top bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundTransparency = 1
    TopBar.Position = UDim2.new(0, 0, 0, 0)
    TopBar.Size = UDim2.new(1, 0, 0, 32)
    TopBar.ZIndex = 5

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.Size = UDim2.new(1, -90, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = TitleText
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 6

    --// Minimize
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "Minimize"
    MinimizeButton.Parent = TopBar
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
    MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Color3.fromRGB(200, 200, 210)
    MinimizeButton.TextSize = 18
    MinimizeButton.ZIndex = 6

    --// Close
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "Close"
    CloseButton.Parent = TopBar
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -32, 0, 0)
    CloseButton.Size = UDim2.new(0, 30, 1, 0)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 90, 90)
    CloseButton.TextSize = 20
    CloseButton.ZIndex = 6

    --// Tab bar
    local TabBar = Instance.new("ScrollingFrame")
    TabBar.Name = "TabBar"
    TabBar.Parent = MainFrame
    TabBar.BackgroundColor3 = Color3.fromRGB(12, 12, 17)
    TabBar.BorderSizePixel = 0
    TabBar.Position = UDim2.new(0, 7, 0, 39)
    TabBar.Size = UDim2.new(0, 105, 1, -46)
    TabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabBar.ScrollBarThickness = 2
    TabBar.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
    TabBar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabBar.ScrollingDirection = Enum.ScrollingDirection.Y
    TabBar.ZIndex = 3

    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 5)
    TabPadding.PaddingLeft = UDim.new(0, 4)
    TabPadding.PaddingRight = UDim.new(0, 4)
    TabPadding.Parent = TabBar

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Parent = TabBar

    --// Content
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "Content"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 119, 0, 39)
    ContentFrame.Size = UDim2.new(1, -126, 1, -46)
    ContentFrame.ClipsDescendants = true
    ContentFrame.ZIndex = 2

    --// Drag
    local Dragging = false
    local DragStart
    local StartPosition

    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            Dragging = true
            DragStart = input.Position
            StartPosition = MainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not Dragging then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then

            local Delta = input.Position - DragStart

            MainFrame.Position = UDim2.new(
                StartPosition.X.Scale,
                StartPosition.X.Offset + Delta.X,
                StartPosition.Y.Scale,
                StartPosition.Y.Offset + Delta.Y
            )
        end
    end)

    --// Create Tab
    function Window:CreateTab(name)

        if Tabs[name] then
            return Tabs[name]
        end

        local Tab = {}
        local TabButton
        local TabContent

        --// Tab button
        TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Parent = TabBar
        TabButton.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, -8, 0, 30)
        TabButton.AutoButtonColor = false
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(170, 170, 180)
        TabButton.TextSize = 12
        TabButton.ZIndex = 4

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 6)
        ButtonCorner.Parent = TabButton

        --// Tab content
        TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "_Content"
        TabContent.Parent = ContentFrame
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Position = UDim2.new(0, 0, 0, 0)
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.ScrollBarThickness = 2
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
        TabContent.ScrollingDirection = Enum.ScrollingDirection.Y
        TabContent.Visible = false
        TabContent.ZIndex = 2

        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingTop = UDim.new(0, 2)
        ContentPadding.PaddingLeft = UDim.new(0, 4)
        ContentPadding.PaddingRight = UDim.new(0, 4)
        ContentPadding.PaddingBottom = UDim.new(0, 5)
        ContentPadding.Parent = TabContent

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Padding = UDim.new(0, 6)
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Parent = TabContent

        --// Select tab
        local function SelectTab()

            if CurrentTab == TabContent then
                return
            end

            for _, OtherTab in pairs(Tabs) do
                if OtherTab.Content then
                    OtherTab.Content.Visible = false
                end

                if OtherTab.Button then
                    Tween(
                        OtherTab.Button,
                        0.15,
                        {
                            BackgroundColor3 = Color3.fromRGB(22, 22, 30),
                            TextColor3 = Color3.fromRGB(170, 170, 180)
                        }
                    )
                end
            end

            TabContent.Visible = true

            Tween(
                TabButton,
                0.15,
                {
                    BackgroundColor3 = Color3.fromRGB(55, 55, 75),
                    TextColor3 = Color3.fromRGB(255, 255, 255)
                }
            )

            CurrentTab = TabContent
        end

        TabButton.MouseButton1Click:Connect(SelectTab)

        Tab.Button = TabButton
        Tab.Content = TabContent
        Tabs[name] = Tab

        if not CurrentTab then
            SelectTab()
        end

        --// Button
        function Tab:CreateButton(text, callback)

            callback = callback or function()
            end

            local Button = Instance.new("TextButton")
            Button.Parent = TabContent
            Button.BackgroundColor3 = Color3.fromRGB(25, 25, 34)
            Button.BorderSizePixel = 0
            Button.Size = UDim2.new(1, 0, 0, 32)
            Button.AutoButtonColor = false
            Button.Font = Enum.Font.GothamMedium
            Button.Text = text
            Button.TextColor3 = Color3.fromRGB(235, 235, 240)
            Button.TextSize = 12
            Button.ZIndex = 3

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 7)
            Corner.Parent = Button

            Button.MouseEnter:Connect(function()
                Tween(Button, 0.12, {
                    BackgroundColor3 = Color3.fromRGB(40, 40, 52)
                })
            end)

            Button.MouseLeave:Connect(function()
                Tween(Button, 0.12, {
                    BackgroundColor3 = Color3.fromRGB(25, 25, 34)
                })
            end)

            Button.MouseButton1Click:Connect(function()
                callback()
            end)

            return Button
        end

        --// Toggle
        function Tab:CreateToggle(text, default, callback)

            default = default or false
            callback = callback or function()
            end

            local toggled = default

            local Frame = Instance.new("Frame")
            Frame.Parent = TabContent
            Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 34)
            Frame.BorderSizePixel = 0
            Frame.Size = UDim2.new(1, 0, 0, 34)
            Frame.ZIndex = 3

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 7)
            Corner.Parent = Frame

            local Label = Instance.new("TextLabel")
            Label.Parent = Frame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.Size = UDim2.new(1, -55, 1, 0)
            Label.Font = Enum.Font.GothamMedium
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(235, 235, 240)
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.ZIndex = 4

            local Switch = Instance.new("Frame")
            Switch.Parent = Frame
            Switch.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
            Switch.Position = UDim2.new(1, -42, 0.5, -9)
            Switch.Size = UDim2.new(0, 32, 0, 18)
            Switch.ZIndex = 4

            local SwitchCorner = Instance.new("UICorner")
            SwitchCorner.CornerRadius = UDim.new(1, 0)
            SwitchCorner.Parent = Switch

            local Circle = Instance.new("Frame")
            Circle.Parent = Switch
            Circle.BackgroundColor3 = Color3.fromRGB(220, 220, 225)
            Circle.Position = UDim2.new(0, 2, 0.5, -7)
            Circle.Size = UDim2.new(0, 14, 0, 14)
            Circle.ZIndex = 5

            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = Circle

            local Click = Instance.new("TextButton")
            Click.Parent = Frame
            Click.BackgroundTransparency = 1
            Click.Size = UDim2.new(1, 0, 1, 0)
            Click.Text = ""
            Click.ZIndex = 6

            local function UpdateVisual()

                if toggled then
                    Tween(Switch, 0.15, {
                        BackgroundColor3 = Color3.fromRGB(90, 70, 180)
                    })

                    Tween(Circle, 0.15, {
                        Position = UDim2.new(1, -16, 0.5, -7)
                    })
                else
                    Tween(Switch, 0.15, {
                        BackgroundColor3 = Color3.fromRGB(55, 55, 65)
                    })

                    Tween(Circle, 0.15, {
                        Position = UDim2.new(0, 2, 0.5, -7)
                    })
                end
            end

            UpdateVisual()

            Click.MouseButton1Click:Connect(function()

                toggled = not toggled

                UpdateVisual()
                callback(toggled)
            end)

            return {
                Set = function(_, value)
                    toggled = value == true
                    UpdateVisual()
                    callback(toggled)
                end,

                Get = function()
                    return toggled
                end
            }
        end

        --// Keybind
        function Tab:CreateKeybind(text, defaultKey, callback)

            defaultKey = defaultKey or Enum.KeyCode.RightShift
            callback = callback or function()
            end

            local CurrentKey = defaultKey

            local Frame = Instance.new("Frame")
            Frame.Parent = TabContent
            Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 34)
            Frame.BorderSizePixel = 0
            Frame.Size = UDim2.new(1, 0, 0, 34)

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 7)
            Corner.Parent = Frame

            local Label = Instance.new("TextLabel")
            Label.Parent = Frame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.Size = UDim2.new(0.55, 0, 1, 0)
            Label.Font = Enum.Font.GothamMedium
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(235, 235, 240)
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local KeyButton = Instance.new("TextButton")
            KeyButton.Parent = Frame
            KeyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
            KeyButton.Position = UDim2.new(1, -85, 0.5, -11)
            KeyButton.Size = UDim2.new(0, 75, 0, 22)
            KeyButton.Font = Enum.Font.GothamBold
            KeyButton.Text = CurrentKey.Name
            KeyButton.TextColor3 = Color3.fromRGB(220, 220, 230)
            KeyButton.TextSize = 10
            KeyButton.AutoButtonColor = false

            local KeyCorner = Instance.new("UICorner")
            KeyCorner.CornerRadius = UDim.new(0, 5)
            KeyCorner.Parent = KeyButton

            local Listening = false

            KeyButton.MouseButton1Click:Connect(function()

                if Listening then
                    return
                end

                Listening = true
                KeyButton.Text = "..."

                local connection

                connection = UserInputService.InputBegan:Connect(function(input, processed)

                    if processed then
                        return
                    end

                    if input.UserInputType == Enum.UserInputType.Keyboard then

                        CurrentKey = input.KeyCode
                        KeyButton.Text = CurrentKey.Name

                        Listening = false

                        connection:Disconnect()
                    end
                end)
            end)

            UserInputService.InputBegan:Connect(function(input, processed)

                if processed then
                    return
                end

                if input.KeyCode == CurrentKey then
                    callback(CurrentKey)
                end
            end)

            return {
                SetKey = function(_, key)
                    if typeof(key) == "EnumItem"
                        and key.EnumType == Enum.KeyCode then

                        CurrentKey = key
                        KeyButton.Text = CurrentKey.Name
                    end
                end,

                Get = function()
                    return CurrentKey
                end
            }
        end

        --// Slider
        function Tab:CreateSlider(text, min, max, default, callback)

            min = tonumber(min) or 0
            max = tonumber(max) or 100
            default = tonumber(default) or min

            if max <= min then
                max = min + 1
            end

            default = math.clamp(default, min, max)

            callback = callback or function()
            end

            local Value = default

            local Frame = Instance.new("Frame")
            Frame.Parent = TabContent
            Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 34)
            Frame.BorderSizePixel = 0
            Frame.Size = UDim2.new(1, 0, 0, 48)

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 7)
            Corner.Parent = Frame

            local Label = Instance.new("TextLabel")
            Label.Parent = Frame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 10, 0, 3)
            Label.Size = UDim2.new(0.7, 0, 0, 20)
            Label.Font = Enum.Font.GothamMedium
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(235, 235, 240)
            Label.TextSize = 11
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Parent = Frame
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Position = UDim2.new(0.7, 0, 0, 3)
            ValueLabel.Size = UDim2.new(0.25, 0, 0, 20)
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.Text = tostring(Value)
            ValueLabel.TextColor3 = Color3.fromRGB(180, 170, 255)
            ValueLabel.TextSize = 11
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

            local Bar = Instance.new("Frame")
            Bar.Parent = Frame
            Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            Bar.Position = UDim2.new(0, 10, 0, 29)
            Bar.Size = UDim2.new(1, -20, 0, 6)
            Bar.BorderSizePixel = 0

            local BarCorner = Instance.new("UICorner")
            BarCorner.CornerRadius = UDim.new(1, 0)
            BarCorner.Parent = Bar

            local Fill = Instance.new("Frame")
            Fill.Parent = Bar
            Fill.BackgroundColor3 = Color3.fromRGB(100, 80, 200)
            Fill.BorderSizePixel = 0
            Fill.Size = UDim2.new(
                (Value - min) / (max - min),
                0,
                1,
                0
            )

            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = Fill

            local Click = Instance.new("TextButton")
            Click.Parent = Bar
            Click.BackgroundTransparency = 1
            Click.Size = UDim2.new(1, 0, 1, 10)
            Click.Position = UDim2.new(0, 0, 0, -5)
            Click.Text = ""

            local DraggingSlider = false

            local function SetValue(value)

                Value = math.clamp(value, min, max)

                local Percent = (Value - min) / (max - min)

                Fill.Size = UDim2.new(Percent, 0, 1, 0)
                ValueLabel.Text = tostring(math.floor(Value))

                callback(Value)
            end

            local function UpdateFromInput(input)

                local X = input.Position.X
                local Start = Bar.AbsolutePosition.X
                local Width = Bar.AbsoluteSize.X

                local Percent = math.clamp(
                    (X - Start) / Width,
                    0,
                    1
                )

                local NewValue = min + ((max - min) * Percent)

                SetValue(NewValue)
            end

            Click.MouseButton1Down:Connect(function(input)
                DraggingSlider = true
                UpdateFromInput(input)
            end)

            UserInputService.InputChanged:Connect(function(input)

                if not DraggingSlider then
                    return
                end

                if input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch then

                    UpdateFromInput(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)

                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then

                    DraggingSlider = false
                end
            end)

            return {
                Set = function(_, value)
                    SetValue(value)
                end,

                Get = function()
                    return Value
                end
            }
        end

        --// Dropdown
        function Tab:CreateDropdown(text, options, callback)

            options = options or {}
            callback = callback or function()
            end

            local Selected = options[1] or "None"
            local Open = false

            local Frame = Instance.new("Frame")
            Frame.Parent = TabContent
            Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 34)
            Frame.BorderSizePixel = 0
            Frame.Size = UDim2.new(1, 0, 0, 34)
            Frame.ClipsDescendants = false
            Frame.ZIndex = 10

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 7)
            Corner.Parent = Frame

            local Button = Instance.new("TextButton")
            Button.Parent = Frame
            Button.BackgroundTransparency = 1
            Button.Size = UDim2.new(1, 0, 1, 0)
            Button.Font = Enum.Font.GothamMedium
            Button.Text = text .. ": " .. tostring(Selected)
            Button.TextColor3 = Color3.fromRGB(235, 235, 240)
            Button.TextSize = 11
            Button.ZIndex = 12

            local List = Instance.new("Frame")
            List.Parent = Frame
            List.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            List.BorderSizePixel = 0
            List.Position = UDim2.new(0, 0, 1, 4)
            List.Size = UDim2.new(1, 0, 0, 0)
            List.Visible = false
            List.ZIndex = 20

            local ListCorner = Instance.new("UICorner")
            ListCorner.CornerRadius = UDim.new(0, 7)
            ListCorner.Parent = List

            local ListLayout = Instance.new("UIListLayout")
            ListLayout.Padding = UDim.new(0, 2)
            ListLayout.Parent = List

            local function RefreshList()

                for _, child in ipairs(List:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end

                for _, option in ipairs(options) do

                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Parent = List
                    OptionButton.BackgroundColor3 = Color3.fromRGB(38, 38, 50)
                    OptionButton.BorderSizePixel = 0
                    OptionButton.Size = UDim2.new(1, -6, 0, 25)
                    OptionButton.Position = UDim2.new(0, 3, 0, 0)
                    OptionButton.Font = Enum.Font.GothamMedium
                    OptionButton.Text = tostring(option)
                    OptionButton.TextColor3 = Color3.fromRGB(230, 230, 235)
                    OptionButton.TextSize = 10
                    OptionButton.ZIndex = 21
                    OptionButton.AutoButtonColor = false

                    local OptionCorner = Instance.new("UICorner")
                    OptionCorner.CornerRadius = UDim.new(0, 5)
                    OptionCorner.Parent = OptionButton

                    OptionButton.MouseButton1Click:Connect(function()

                        Selected = option
                        Button.Text = text .. ": " .. tostring(Selected)

                        Open = false
                        List.Visible = false

                        Tween(List, 0.15, {
                            Size = UDim2.new(1, 0, 0, 0)
                        })

                        callback(Selected)
                    end)
                end
            end

            RefreshList()

            Button.MouseButton1Click:Connect(function()

                Open = not Open

                if Open then

                    List.Visible = true

                    local Height = math.min(#options * 27 + 5, 130)

                    Tween(List, 0.18, {
                        Size = UDim2.new(1, 0, 0, Height)
                    })

                else

                    Tween(List, 0.15, {
                        Size = UDim2.new(1, 0, 0, 0)
                    })

                    task.delay(0.15, function()
                        if not Open then
                            List.Visible = false
                        end
                    end)
                end
            end)

            return {
                Set = function(_, value)

                    for _, option in ipairs(options) do
                        if option == value then
                            Selected = value
                            Button.Text = text .. ": " .. tostring(Selected)
                            callback(Selected)
                            break
                        end
                    end
                end,

                Get = function()
                    return Selected
                end,

                Refresh = function(_, newOptions)

                    options = newOptions or {}
                    Selected = options[1] or "None"

                    Button.Text = text .. ": " .. tostring(Selected)

                    RefreshList()
                end
            }
        end

        --// Label
        function Tab:CreateLabel(text)

            local Label = Instance.new("TextLabel")
            Label.Parent = TabContent
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, 0, 0, 25)
            Label.Font = Enum.Font.GothamMedium
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(190, 190, 200)
            Label.TextSize = 11
            Label.TextXAlignment = Enum.TextXAlignment.Left

            return Label
        end

        --// Divider
        function Tab:CreateDivider()

            local Divider = Instance.new("Frame")
            Divider.Parent = TabContent
            Divider.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
            Divider.BorderSizePixel = 0
            Divider.Size = UDim2.new(1, 0, 0, 1)

            return Divider
        end

        --// Paragraph
        function Tab:CreateParagraph(title, description)

            local Frame = Instance.new("Frame")
            Frame.Parent = TabContent
            Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 34)
            Frame.BorderSizePixel = 0
            Frame.Size = UDim2.new(1, 0, 0, 65)

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 7)
            Corner.Parent = Frame

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Parent = Frame
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Position = UDim2.new(0, 10, 0, 6)
            TitleLabel.Size = UDim2.new(1, -20, 0, 20)
            TitleLabel.Font = Enum.Font.GothamBold
            TitleLabel.Text = title
            TitleLabel.TextColor3 = Color3.fromRGB(235, 235, 240)
            TitleLabel.TextSize = 12
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

            local DescriptionLabel = Instance.new("TextLabel")
            DescriptionLabel.Parent = Frame
            DescriptionLabel.BackgroundTransparency = 1
            DescriptionLabel.Position = UDim2.new(0, 10, 0, 28)
            DescriptionLabel.Size = UDim2.new(1, -20, 0, 30)
            DescriptionLabel.Font = Enum.Font.Gotham
            DescriptionLabel.Text = description
            DescriptionLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
            DescriptionLabel.TextSize = 10
            DescriptionLabel.TextWrapped = true
            DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
            DescriptionLabel.TextYAlignment = Enum.TextYAlignment.Top

            return Frame
        end

        return Tab
    end

    --// Minimize
    local Minimized = false

    MinimizeButton.MouseButton1Click:Connect(function()

        Minimized = not Minimized

        if Minimized then

            TabBar.Visible = false
            ContentFrame.Visible = false

            Tween(MainFrame, 0.25, {
                Size = UDim2.new(0, 380, 0, 32)
            })

            MinimizeButton.Text = "+"

        else

            Tween(MainFrame, 0.25, {
                Size = UDim2.new(0, 380, 0, 220)
            })

            task.delay(0.2, function()
                if not Minimized then
                    TabBar.Visible = true
                    ContentFrame.Visible = true
                end
            end)

            MinimizeButton.Text = "-"
        end
    end)

    --// Close
    CloseButton.MouseButton1Click:Connect(function()

        Tween(MainFrame, 0.2, {
            Size = UDim2.new(0, 0, 0, 0)
        })

        task.delay(0.2, function()
            if ScreenGui then
                ScreenGui:Destroy()
            end
        end)
    end)

    --// Destroy
    function Window:Destroy()

        if ScreenGui then
            ScreenGui:Destroy()
        end
    end

    return Window
end

return Library
