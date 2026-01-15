-- SaifUI v1.0
-- Lightweight UI Library for Delta Executor
-- Author: Saifmod

local SaifUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ======== إنشاء نافذة ========
function SaifUI:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SaifUI"
    ScreenGui.Parent = player:WaitForChild("PlayerGui")

    local Window = Instance.new("Frame")
    Window.Size = UDim2.new(0, 420, 0, 520)
    Window.Position = UDim2.new(0.5, 0, 0.5, 0)
    Window.AnchorPoint = Vector2.new(0.5, 0.5)
    Window.BackgroundColor3 = Color3.fromRGB(28,28,38)
    Window.BorderSizePixel = 0
    Window.ClipsDescendants = true
    Window.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 14)
    Corner.Parent = Window

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0, 50)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title or "SaifUI Window"
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 22
    TitleLabel.TextColor3 = Color3.fromRGB(255,255,255)
    TitleLabel.Parent = Window

    -- زر الإغلاق
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 35, 0, 35)
    CloseButton.Position = UDim2.new(1, -40, 0, 7)
    CloseButton.Text = "×"
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 24
    CloseButton.TextColor3 = Color3.fromRGB(255,255,255)
    CloseButton.BackgroundColor3 = Color3.fromRGB(180,50,50)
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = Window

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0,10)
    CloseCorner.Parent = CloseButton

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- سحب النافذة
    local dragging = false
    local dragInput, dragStart, startPos

    TitleLabel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Window.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    TitleLabel.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            Window.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- ======== Content Frame ========
    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1,0,1, -50)
    Content.Position = UDim2.new(0,0,0,50)
    Content.BackgroundTransparency = 1
    Content.Parent = Window

    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Size = UDim2.new(1,0,1,0)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ScrollBarThickness = 6
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100,100,100)
    ScrollingFrame.CanvasSize = UDim2.new(0,0,2,0)
    ScrollingFrame.Parent = Content

    -- ======== Tabs System ========
    local Tabs = {}
    function SaifUI:CreateTab(name)
        local TabFrame = Instance.new("Frame")
        TabFrame.Size = UDim2.new(0, 380, 0, 40)
        TabFrame.Position = UDim2.new(0, 20, 0, #Tabs*50 + 10)
        TabFrame.BackgroundColor3 = Color3.fromRGB(40,40,50)
        TabFrame.BorderSizePixel = 0
        TabFrame.Parent = ScrollingFrame

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0,8)
        Corner.Parent = TabFrame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1,0,1,0)
        Label.BackgroundTransparency = 1
        Label.Text = name
        Label.Font = Enum.Font.GothamBold
        Label.TextSize = 14
        Label.TextColor3 = Color3.fromRGB(255,255,255)
        Label.Parent = TabFrame

        local TabContent = Instance.new("Frame")
        TabContent.Size = UDim2.new(1,0,0,200)
        TabContent.Position = UDim2.new(0,0,0,40)
        TabContent.BackgroundTransparency = 1
        TabContent.Parent = TabFrame

        Tabs[name] = {Content = TabContent}
        return TabContent
    end

    -- ======== Buttons ========
    function SaifUI:CreateButton(tabContent, text, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0, 350, 0, 35)
        Button.Position = UDim2.new(0, 15, 0, #tabContent:GetChildren()*40)
        Button.BackgroundColor3 = Color3.fromRGB(60,60,80)
        Button.BorderSizePixel = 0
        Button.Text = text
        Button.Font = Enum.Font.GothamBold
        Button.TextSize = 14
        Button.TextColor3 = Color3.fromRGB(255,255,255)
        Button.Parent = tabContent

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0,6)
        Corner.Parent = Button

        Button.MouseButton1Click:Connect(function()
            if callback then
                callback()
            end
        end)
        return Button
    end

    -- ======== Toggle ========
    function SaifUI:CreateToggle(tabContent, text, default, callback)
        default = default or false
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(0, 350, 0, 35)
        Frame.Position = UDim2.new(0,15,0,#tabContent:GetChildren()*40)
        Frame.BackgroundColor3 = Color3.fromRGB(60,60,80)
        Frame.BorderSizePixel = 0
        Frame.Parent = tabContent

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0,6)
        Corner.Parent = Frame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.7,0,1,0)
        Label.Position = UDim2.new(0.05,0,0,0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14
        Label.TextColor3 = Color3.fromRGB(255,255,255)
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Frame

        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0.2,0,0.6,0)
        Button.Position = UDim2.new(0.75,0,0.2,0)
        Button.BackgroundColor3 = default and Color3.fromRGB(0,180,120) or Color3.fromRGB(80,80,90)
        Button.BorderSizePixel = 0
        Button.Parent = Frame

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0,6)
        BtnCorner.Parent = Button

        local toggled = default
        Button.MouseButton1Click:Connect(function()
            toggled = not toggled
            Button.BackgroundColor3 = toggled and Color3.fromRGB(0,180,120) or Color3.fromRGB(80,80,90)
            if callback then callback(toggled) end
        end)

        return Frame
    end

    return SaifUI
end

return SaifUI
