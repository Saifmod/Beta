-- MobileUI Library v1.0
local MobileUI = {}
MobileUI.__index = MobileUI

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function MobileUI:CreateWindow(title)
    local self = setmetatable({}, MobileUI)
    local player = Players.LocalPlayer

    -- ======= ScreenGui =======
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MobileBoxUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = player:WaitForChild("PlayerGui")

    -- ======= Main Frame =======
    local Main = Instance.new("Frame")
    Main.Parent = ScreenGui
    Main.Name = "MainBox"
    Main.Size = UDim2.fromScale(0.8, 1.2)
    Main.Position = UDim2.fromScale(0.5, 0.48)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
    Main.BackgroundTransparency = 0.25
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0,18)
    Corner.Parent = Main

    local Stroke = Instance.new("UIStroke")
    Stroke.Parent = Main
    Stroke.Thickness = 1.3
    Stroke.Color = Color3.fromRGB(80,80,80)
    Stroke.Transparency = 0.15

    -- ======= TitleBar =======
    local TitleBar = Instance.new("Frame")
    TitleBar.Parent = Main
    TitleBar.Size = UDim2.fromScale(1,0.12)
    TitleBar.BackgroundColor3 = Color3.fromRGB(28,28,28)
    TitleBar.BackgroundTransparency = 0.1
    TitleBar.BorderSizePixel = 0

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0,18)
    TitleCorner.Parent = TitleBar

    local TitleText = Instance.new("TextLabel")
    TitleText.Parent = TitleBar
    TitleText.Size = UDim2.fromScale(1,1)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = title
    TitleText.Font = Enum.Font.GothamBold
    TitleText.TextSize = 20
    TitleText.TextColor3 = Color3.fromRGB(255,255,255)
    TitleText.TextXAlignment = Enum.TextXAlignment.Center

    -- ======= Close Button =======
    local CloseButton = Instance.new("TextButton")
    CloseButton.Parent = Main
    CloseButton.Size = UDim2.fromScale(0.12,0.08)
    CloseButton.Position = UDim2.fromScale(0.85,0.02)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200,50,50)
    CloseButton.BackgroundTransparency = 0.2
    CloseButton.Text = "×"
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 22
    CloseButton.TextColor3 = Color3.fromRGB(255,255,255)
    CloseButton.BorderSizePixel = 0

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0,10)
    CloseCorner.Parent = CloseButton

    CloseButton.MouseEnter:Connect(function()
        CloseButton.BackgroundColor3 = Color3.fromRGB(230,70,70)
    end)
    CloseButton.MouseLeave:Connect(function()
        CloseButton.BackgroundColor3 = Color3.fromRGB(200,50,50)
    end)
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- ======= Content & ScrollingFrame =======
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Parent = Main
    ContentFrame.Size = UDim2.new(1,0,0.88,0)
    ContentFrame.Position = UDim2.fromScale(0,0.12)
    ContentFrame.BackgroundTransparency = 1

    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Parent = ContentFrame
    ScrollingFrame.Size = UDim2.fromScale(1,1)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ScrollBarThickness = 6
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100,100,100)
    ScrollingFrame.CanvasSize = UDim2.new(0,0,2,0)

    -- ======= Dragging =======
    local dragging = false
    local dragInput, dragStart, startPos

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset + delta.X,
                                      startPos.Y.Scale,startPos.Y.Offset + delta.Y)
        end
    end)

    -- ======= Tabs System =======
    self.Main = Main
    self.ScrollingFrame = ScrollingFrame
    self.Tabs = {}

    function self:CreateTab(name)
        local tab = {}
        tab.Elements = {}

        -- InfoLabel
        function tab:AddInfoLabel(text)
            local lbl = Instance.new("TextLabel")
            lbl.Parent = self.ScrollingFrame or ScrollingFrame
            lbl.Size = UDim2.new(0.65,0,0,70)
            lbl.Position = UDim2.new(0.3,0,0,10 + #tab.Elements*80)
            lbl.BackgroundColor3 = Color3.fromRGB(40,40,50)
            lbl.BackgroundTransparency = 0.3
            lbl.Text = text
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 13
            lbl.TextColor3 = Color3.fromRGB(220,220,255)
            lbl.TextWrapped = true
            lbl.TextXAlignment = Enum.TextXAlignment.Center
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0,8)
            corner.Parent = lbl
            table.insert(tab.Elements,lbl)
            return lbl
        end

        -- Button
        function tab:AddButton(text,callback)
            local btn = Instance.new("TextButton")
            btn.Parent = self.ScrollingFrame or ScrollingFrame
            btn.Size = UDim2.new(0.65,0,0,40)
            btn.Position = UDim2.new(0.3,0,0,10 + #tab.Elements*50)
            btn.BackgroundColor3 = Color3.fromRGB(180,100,50)
            btn.BackgroundTransparency = 0.2
            btn.Text = text
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 14
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.BorderSizePixel = 0
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0,8)
            corner.Parent = btn
            btn.MouseButton1Click:Connect(callback)
            table.insert(tab.Elements,btn)
            return btn
        end

        -- Toggle
        function tab:AddToggle(text,callback)
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Parent = self.ScrollingFrame or ScrollingFrame
            toggleFrame.Size = UDim2.new(0.65,0,0,40)
            toggleFrame.Position = UDim2.new(0.3,0,0,10 + #tab.Elements*50)
            toggleFrame.BackgroundColor3 = Color3.fromRGB(45,45,55)
            toggleFrame.BackgroundTransparency = 0.2
            toggleFrame.BorderSizePixel = 0
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0,8)
            corner.Parent = toggleFrame

            local label = Instance.new("TextLabel")
            label.Parent = toggleFrame
            label.Size = UDim2.new(0.6,0,1,0)
            label.Position = UDim2.new(0.05,0,0,0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.TextColor3 = Color3.fromRGB(220,220,220)
            label.TextXAlignment = Enum.TextXAlignment.Left

            local toggleButton = Instance.new("TextButton")
            toggleButton.Parent = toggleFrame
            toggleButton.Size = UDim2.new(0,40,0,20)
            toggleButton.Position = UDim2.new(0.9,-40,0.5,-10)
            toggleButton.BackgroundColor3 = Color3.fromRGB(80,80,90)
            toggleButton.Text = ""
            toggleButton.BorderSizePixel = 0
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0,10)
            btnCorner.Parent = toggleButton

            local toggleCircle = Instance.new("Frame")
            toggleCircle.Parent = toggleButton
            toggleCircle.Size = UDim2.new(0,16,0,16)
            toggleCircle.Position = UDim2.new(0,2,0.5,-8)
            toggleCircle.BackgroundColor3 = Color3.fromRGB(220,220,220)
            toggleCircle.BorderSizePixel = 0
            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(0,8)
            circleCorner.Parent = toggleCircle

            local state = false
            toggleButton.MouseButton1Click:Connect(function()
                state = not state
                if state then
                    TweenService:Create(toggleButton,TweenInfo.new(0.2),{BackgroundColor3 = Color3.fromRGB(0,180,120)}):Play()
                    TweenService:Create(toggleCircle,TweenInfo.new(0.2),{Position = UDim2.new(1,-18,0.5,-8)}):Play()
                else
                    TweenService:Create(toggleButton,TweenInfo.new(0.2),{BackgroundColor3 = Color3.fromRGB(80,80,90)}):Play()
                    TweenService:Create(toggleCircle,TweenInfo.new(0.2),{Position = UDim2.new(0,2,0.5,-8)}):Play()
                end
                if callback then callback(state) end
            end)
            table.insert(tab.Elements,toggleFrame)
            return toggleFrame
        end

        -- Slider
        function tab:AddSlider(text,callback)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Parent = self.ScrollingFrame or ScrollingFrame
            sliderFrame.Size = UDim2.new(0.65,0,0,50)
            sliderFrame.Position = UDim2.new(0.3,0,0,10 + #tab.Elements*60)
            sliderFrame.BackgroundColor3 = Color3.fromRGB(45,45,55)
            sliderFrame.BackgroundTransparency = 0.2
            sliderFrame.BorderSizePixel = 0
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0,8)
            corner.Parent = sliderFrame

            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.Parent = sliderFrame
            sliderLabel.Size = UDim2.new(1,0,0,20)
            sliderLabel.Position = UDim2.new(0,0,0,5)
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Text = text.." 50%"
            sliderLabel.Font = Enum.Font.Gotham
            sliderLabel.TextSize = 12
            sliderLabel.TextColor3 = Color3.fromRGB(220,220,220)
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Center

            local sliderBar = Instance.new("Frame")
            sliderBar.Parent = sliderFrame
            sliderBar.Size = UDim2.new(0.85,0,0,6)
            sliderBar.Position = UDim2.new(0.075,0,0,30)
            sliderBar.BackgroundColor3 = Color3.fromRGB(60,60,70)
            sliderBar.BorderSizePixel = 0
            local barCorner = Instance.new("UICorner")
            barCorner.CornerRadius = UDim.new(0,3)
            barCorner.Parent = sliderBar

            local fillBar = Instance.new("Frame")
            fillBar.Parent = sliderBar
            fillBar.Size = UDim2.new(0.5,0,1,0)
            fillBar.BackgroundColor3 = Color3.fromRGB(0,150,255)
            fillBar.BorderSizePixel = 0
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(0,3)
            fillCorner.Parent = fillBar

            local function updateSlider(input)
                local relativeX = (input.Position.X - sliderBar.AbsolutePosition.X)/sliderBar.AbsoluteSize.X
                relativeX = math.clamp(relativeX,0,1)
                fillBar.Size = UDim2.new(relativeX,0,1,0)
                local percentage = math.floor(relativeX*100)
                sliderLabel.Text = text.." "..percentage.."%"
                if callback then callback(percentage) end
            end

            sliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    updateSlider(input)
                    local conn
                    conn = input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            conn:Disconnect()
                        else
                            updateSlider(input)
                        end
                    end)
                end
            end)
            sliderBar.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    updateSlider(input)
                end
            end)

            table.insert(tab.Elements,sliderFrame)
            return sliderFrame
        end

        self.Tabs[name] = tab
        return tab
    end

    return self
end

return MobileUI