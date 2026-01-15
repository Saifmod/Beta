-- SaifUI v1.0
-- Lightweight UI Library for Delta Executor
-- Author: Saifmod

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local SaifUI = {}

-- ========================
-- ===== إنشاء نافذة =====
-- ========================
function SaifUI:CreateWindow(title)
    local window = {}
    
    -- الشاشة الأساسية
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SaifUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    local Main = Instance.new("Frame")
    Main.Parent = ScreenGui
    Main.Size = UDim2.fromScale(0.7, 0.8)
    Main.Position = UDim2.fromScale(0.5, 0.5)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Main

    local TitleBar = Instance.new("Frame")
    TitleBar.Parent = Main
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TitleBar.BorderSizePixel = 0

    local Title = Instance.new("TextLabel")
    Title.Parent = TitleBar
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = title or "SaifUI Window"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Center
    Title.TextYAlignment = Enum.TextYAlignment.Center

    -- سحب النافذة
    local dragging = false
    local dragInput, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- محتوى النافذة
    local Content = Instance.new("ScrollingFrame")
    Content.Parent = Main
    Content.Size = UDim2.new(1, 0, 1, -35)
    Content.Position = UDim2.new(0, 0, 0, 35)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.ScrollBarThickness = 6
    Content.CanvasSize = UDim2.new(0, 0, 2, 0)

    window.Main = Main
    window.Content = Content
    window.Tabs = {}

    -- ========================
    -- ===== إنشاء تاب ========
    -- ========================
    function window:CreateTab(name)
        local tab = {}
        tab.Name = name
        tab.Elements = {}

        function tab:AddButton(text, callback)
            local btn = Instance.new("TextButton")
            btn.Parent = Content
            btn.Size = UDim2.new(0.9, 0, 0, 35)
            btn.Position = UDim2.new(0.05, 0, 0, #Content:GetChildren()*40)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            btn.Text = text
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 14
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = btn

            btn.MouseButton1Click:Connect(callback)
            table.insert(tab.Elements, btn)
            return btn
        end

        function tab:AddToggle(text, callback)
            local frame = Instance.new("Frame")
            frame.Parent = Content
            frame.Size = UDim2.new(0.9, 0, 0, 35)
            frame.Position = UDim2.new(0.05, 0, 0, #Content:GetChildren()*40)
            frame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = frame

            local label = Instance.new("TextLabel")
            label.Parent = frame
            label.Size = UDim2.new(0.7, 0, 1, 0)
            label.Position = UDim2.new(0.02, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextXAlignment = Enum.TextXAlignment.Left

            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Parent = frame
            toggleBtn.Size = UDim2.new(0, 30, 0, 20)
            toggleBtn.Position = UDim2.new(0.85, 0, 0.5, -10)
            toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
            toggleBtn.Text = ""
            toggleBtn.BorderSizePixel = 0
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 6)
            toggleCorner.Parent = toggleBtn

            local circle = Instance.new("Frame")
            circle.Parent = toggleBtn
            circle.Size = UDim2.new(0, 16, 0, 16)
            circle.Position = UDim2.new(0, 2, 0.5, -8)
            circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(0, 8)
            circleCorner.Parent = circle

            local state = false
            toggleBtn.MouseButton1Click:Connect(function()
                state = not state
                if state then
                    toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 120)
                    circle.Position = UDim2.new(1, -18, 0.5, -8)
                else
                    toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
                    circle.Position = UDim2.new(0, 2, 0.5, -8)
                end
                if callback then callback(state) end
            end)

            table.insert(tab.Elements, frame)
            return frame
        end

        function tab:AddLabel(text)
            local label = Instance.new("TextLabel")
            label.Parent = Content
            label.Size = UDim2.new(0.9, 0, 0, 25)
            label.Position = UDim2.new(0.05, 0, 0, #Content:GetChildren()*30)
            label.BackgroundTransparency = 1
            label.Text = text
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextXAlignment = Enum.TextXAlignment.Center
            table.insert(tab.Elements, label)
            return label
        end

        function tab:AddSlider(text, min, max, default, callback)
            local frame = Instance.new("Frame")
            frame.Parent = Content
            frame.Size = UDim2.new(0.9, 0, 0, 40)
            frame.Position = UDim2.new(0.05, 0, 0, #Content:GetChildren()*45)
            frame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = frame

            local label = Instance.new("TextLabel")
            label.Parent = frame
            label.Size = UDim2.new(1, 0, 0, 20)
            label.Position = UDim2.new(0, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text.." : "..tostring(default)
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextXAlignment = Enum.TextXAlignment.Center

            local bar = Instance.new("Frame")
            bar.Parent = frame
            bar.Size = UDim2.new(0.85, 0, 0, 6)
            bar.Position = UDim2.new(0.075, 0, 1, -14)
            bar.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
            local barCorner = Instance.new("UICorner")
            barCorner.CornerRadius = UDim.new(0, 3)
            barCorner.Parent = bar

            local fill = Instance.new("Frame")
            fill.Parent = bar
            fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
            fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(0, 3)
            fillCorner.Parent = fill

            local function update(input)
                local relative = (input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
                relative = math.clamp(relative, 0, 1)
                fill.Size = UDim2.new(relative,0,1,0)
                local value = math.floor(relative*(max-min)+min)
                label.Text = text.." : "..tostring(value)
                if callback then callback(value) end
            end

            bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    update(input)
                    local conn
                    conn = input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            conn:Disconnect()
                        else
                            update(input)
                        end
                    end)
                end
            end)
            bar.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    update(input)
                end
            end)

            table.insert(tab.Elements, frame)
            return frame
        end

        window.Tabs[name] = tab
        return tab
    end

    return window
end

return SaifUI