--[[ 
    SaifUI Library v1.0
    Made for Delta Executor
    Author: You 😎
]]

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local SaifUI = {}
SaifUI.__index = SaifUI

-- =====================
-- Window
-- =====================
function SaifUI:CreateWindow(config)
    local player = Players.LocalPlayer

    local ScreenGui = Instance.new("ScreenGui", player.PlayerGui)
    ScreenGui.Name = "SaifUI"

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.fromScale(0.75, 0.7)
    Main.Position = UDim2.fromScale(0.5, 0.5)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(25,25,25)
    Main.BorderSizePixel = 0

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0,16)

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1,0,0,45)
    Title.Text = config.Title or "SaifUI"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextColor3 = Color3.new(1,1,1)
    Title.BackgroundTransparency = 1

    local TabsFrame = Instance.new("Frame", Main)
    TabsFrame.Size = UDim2.new(0,130,1,-45)
    TabsFrame.Position = UDim2.new(0,0,0,45)
    TabsFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    TabsFrame.BorderSizePixel = 0

    local Content = Instance.new("Frame", Main)
    Content.Size = UDim2.new(1,-130,1,-45)
    Content.Position = UDim2.new(0,130,0,45)
    Content.BackgroundTransparency = 1

    local TabLayout = Instance.new("UIListLayout", TabsFrame)
    TabLayout.Padding = UDim.new(0,6)

    local window = {}
    window.Tabs = {}
    window.Content = Content

    function window:CreateTab(name)
        local TabBtn = Instance.new("TextButton", TabsFrame)
        TabBtn.Size = UDim2.new(1,-10,0,40)
        TabBtn.Text = name
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 14
        TabBtn.TextColor3 = Color3.new(1,1,1)
        TabBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
        TabBtn.BorderSizePixel = 0
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0,10)

        local Page = Instance.new("ScrollingFrame", Content)
        Page.Size = UDim2.new(1,0,1,0)
        Page.CanvasSize = UDim2.new(0,0,0,0)
        Page.ScrollBarImageTransparency = 0.5
        Page.Visible = false
        Page.BackgroundTransparency = 1

        local Layout = Instance.new("UIListLayout", Page)
        Layout.Padding = UDim.new(0,10)

        TabBtn.MouseButton1Click:Connect(function()
            for _,t in pairs(window.Tabs) do
                t.Page.Visible = false
            end
            Page.Visible = true
        end)

        local tab = {}
        tab.Page = Page

        -- ===== Button =====
        function tab:AddButton(text, callback)
            local Btn = Instance.new("TextButton", Page)
            Btn.Size = UDim2.new(1,-20,0,40)
            Btn.Text = text
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 14
            Btn.TextColor3 = Color3.new(1,1,1)
            Btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
            Btn.BorderSizePixel = 0
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,10)

            Btn.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
        end

        -- ===== Toggle =====
        function tab:AddToggle(text, default, callback)
            local Frame = Instance.new("Frame", Page)
            Frame.Size = UDim2.new(1,-20,0,40)
            Frame.BackgroundColor3 = Color3.fromRGB(60,60,60)
            Frame.BorderSizePixel = 0
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,10)

            local Label = Instance.new("TextLabel", Frame)
            Label.Size = UDim2.new(0.7,0,1,0)
            Label.Text = text
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Color3.new(1,1,1)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13

            local Toggle = Instance.new("TextButton", Frame)
            Toggle.Size = UDim2.new(0,40,0,20)
            Toggle.Position = UDim2.new(1,-50,0.5,-10)
            Toggle.BackgroundColor3 = default and Color3.fromRGB(0,170,120) or Color3.fromRGB(80,80,80)
            Toggle.Text = ""
            Toggle.BorderSizePixel = 0
            Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1,0)

            local state = default
            Toggle.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(Toggle,TweenInfo.new(0.2),{
                    BackgroundColor3 = state and Color3.fromRGB(0,170,120) or Color3.fromRGB(80,80,80)
                }):Play()
                if callback then callback(state) end
            end)
        end

        window.Tabs[#window.Tabs+1] = tab
        if #window.Tabs == 1 then Page.Visible = true end
        return tab
    end

    return window
end

return SaifUI
