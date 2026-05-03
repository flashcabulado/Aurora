local TweenService = game:GetService("TweenService")

local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(parent, config, theme, animation, utils)
    local self = setmetatable({}, Toggle)
    local T = theme.Current
    self.Value = config.Default == true

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 54)
    card.BackgroundColor3 = T.Card
    card.BackgroundTransparency = 0.3
    card.BorderSizePixel = 0
    card.Parent = parent
    utils:Corner(card, 12)
    utils:Stroke(card, T.Border, 0.88, 1)

    local textContainer = Instance.new("Frame")
    textContainer.Size = UDim2.new(1, -80, 1, 0)
    textContainer.Position = UDim2.fromOffset(14, 0)
    textContainer.BackgroundTransparency = 1
    textContainer.Parent = card

    local title = Instance.new("TextLabel")
    title.Text = config.Title or "Toggle"
    title.TextSize = 14
    title.Font = Enum.Font.GothamMedium
    title.TextColor3 = T.Text
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 18)
    title.Position = UDim2.new(0, 0, 0.5, config.Description and -12 or -9)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = textContainer

    if config.Description then
        local desc = Instance.new("TextLabel")
        desc.Text = config.Description
        desc.TextSize = 11
        desc.Font = Enum.Font.Gotham
        desc.TextColor3 = T.Subtext
        desc.BackgroundTransparency = 1
        desc.Size = UDim2.new(1, 0, 0, 14)
        desc.Position = UDim2.new(0, 0, 0.5, 2)
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Parent = textContainer
    end

    local trackFrame = Instance.new("Frame")
    trackFrame.Size = UDim2.fromOffset(46, 26)
    trackFrame.Position = UDim2.new(1, -58, 0.5, -13)
    trackFrame.BackgroundColor3 = self.Value and T.Accent or Color3.fromRGB(60, 65, 80)
    trackFrame.BorderSizePixel = 0
    trackFrame.Parent = card
    utils:Corner(trackFrame, 13)

    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.fromOffset(20, 20)
    thumb.Position = self.Value and UDim2.fromOffset(23, 3) or UDim2.fromOffset(3, 3)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.BorderSizePixel = 0
    thumb.ZIndex = trackFrame.ZIndex + 1
    thumb.Parent = trackFrame
    utils:Corner(thumb, 10)

    local glowFrame = Instance.new("Frame")
    glowFrame.Size = UDim2.fromOffset(46, 26)
    glowFrame.Position = UDim2.fromScale(0, 0)
    glowFrame.BackgroundColor3 = T.Accent
    glowFrame.BackgroundTransparency = self.Value and 0.6 or 1
    glowFrame.BorderSizePixel = 0
    glowFrame.ZIndex = trackFrame.ZIndex - 1
    glowFrame.Parent = trackFrame
    utils:Corner(glowFrame, 13)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromScale(1, 1)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = card

    local function updateVisual(val)
        if val then
            animation:Tween(trackFrame, {BackgroundColor3 = T.Accent}, 0.2)
            animation:Tween(thumb, {Position = UDim2.fromOffset(23, 3)}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            animation:Tween(glowFrame, {BackgroundTransparency = 0.6}, 0.2)
        else
            animation:Tween(trackFrame, {BackgroundColor3 = Color3.fromRGB(60, 65, 80)}, 0.2)
            animation:Tween(thumb, {Position = UDim2.fromOffset(3, 3)}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            animation:Tween(glowFrame, {BackgroundTransparency = 1}, 0.2)
        end
    end

    btn.MouseButton1Click:Connect(function()
        self.Value = not self.Value
        updateVisual(self.Value)
        if config.Callback then
            pcall(config.Callback, self.Value)
        end
    end)

    btn.MouseEnter:Connect(function()
        animation:Tween(card, {BackgroundTransparency = 0.1}, 0.18)
    end)
    btn.MouseLeave:Connect(function()
        animation:Tween(card, {BackgroundTransparency = 0.3}, 0.18)
    end)

    function self:Set(val)
        self.Value = val
        updateVisual(val)
    end

    self.Instance = card
    return self
end

return Toggle
