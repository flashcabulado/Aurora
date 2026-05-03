local UserInputService = game:GetService("UserInputService")

local Slider = {}
Slider.__index = Slider

function Slider.new(parent, config, theme, animation, utils)
    local self = setmetatable({}, Slider)
    local T = theme.Current
    local min = config.Min or 0
    local max = config.Max or 100
    local increment = config.Increment or 1
    self.Value = config.Default or min

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 64)
    card.BackgroundColor3 = T.Card
    card.BackgroundTransparency = 0.3
    card.BorderSizePixel = 0
    card.Parent = parent
    utils:Corner(card, 12)
    utils:Stroke(card, T.Border, 0.88, 1)

    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, -24, 0, 24)
    headerFrame.Position = UDim2.fromOffset(14, 10)
    headerFrame.BackgroundTransparency = 1
    headerFrame.Parent = card

    local title = Instance.new("TextLabel")
    title.Text = config.Title or "Slider"
    title.TextSize = 13
    title.Font = Enum.Font.GothamMedium
    title.TextColor3 = T.Text
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(0.7, 0, 1, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = headerFrame

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Text = tostring(self.Value)
    valueLabel.TextSize = 13
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextColor3 = T.Accent
    valueLabel.BackgroundTransparency = 1
    valueLabel.Size = UDim2.new(0.3, 0, 1, 0)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = headerFrame

    local trackBg = Instance.new("Frame")
    trackBg.Size = UDim2.new(1, -28, 0, 6)
    trackBg.Position = UDim2.new(0, 14, 0, 42)
    trackBg.BackgroundColor3 = Color3.fromRGB(50, 56, 72)
    trackBg.BorderSizePixel = 0
    trackBg.Parent = card
    utils:Corner(trackBg, 3)

    local pct = (self.Value - min) / (max - min)
    local trackFill = Instance.new("Frame")
    trackFill.Size = UDim2.new(pct, 0, 1, 0)
    trackFill.BackgroundColor3 = T.Accent
    trackFill.BorderSizePixel = 0
    trackFill.Parent = trackBg
    utils:Corner(trackFill, 3)

    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, T.Accent),
        ColorSequenceKeypoint.new(1, T.AccentSecondary)
    })
    g.Parent = trackFill

    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.fromOffset(16, 16)
    thumb.Position = UDim2.new(pct, -8, 0.5, -8)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.BorderSizePixel = 0
    thumb.ZIndex = trackBg.ZIndex + 2
    thumb.Parent = trackBg
    utils:Corner(thumb, 8)

    local thumbGlow = Instance.new("Frame")
    thumbGlow.Size = UDim2.fromOffset(24, 24)
    thumbGlow.Position = UDim2.new(0.5, -12, 0.5, -12)
    thumbGlow.BackgroundColor3 = T.Accent
    thumbGlow.BackgroundTransparency = 0.65
    thumbGlow.BorderSizePixel = 0
    thumbGlow.ZIndex = thumb.ZIndex - 1
    thumbGlow.Parent = thumb
    utils:Corner(thumbGlow, 12)

    local dragging = false

    local function update(inputX)
        local trackAbs = trackBg.AbsolutePosition
        local trackSize = trackBg.AbsoluteSize
        local rel = math.clamp((inputX - trackAbs.X) / trackSize.X, 0, 1)
        local rawVal = min + rel * (max - min)
        local snapped = math.floor(rawVal / increment + 0.5) * increment
        snapped = math.clamp(snapped, min, max)
        if snapped ~= self.Value then
            self.Value = snapped
            local p = (snapped - min) / (max - min)
            animation:Quick(trackFill, {Size = UDim2.new(p, 0, 1, 0)}, 0.05)
            animation:Quick(thumb, {Position = UDim2.new(p, -8, 0.5, -8)}, 0.05)
            valueLabel.Text = tostring(snapped)
            if config.Callback then pcall(config.Callback, snapped) end
        end
    end

    trackBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    function self:Set(val)
        self.Value = math.clamp(val, min, max)
        local p = (self.Value - min) / (max - min)
        trackFill.Size = UDim2.new(p, 0, 1, 0)
        thumb.Position = UDim2.new(p, -8, 0.5, -8)
        valueLabel.Text = tostring(self.Value)
    end

    self.Instance = card
    return self
end

return Slider
