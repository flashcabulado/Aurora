local TweenService = game:GetService("TweenService")

local Button = {}
Button.__index = Button

function Button.new(parent, config, theme, animation, ripple, utils)
    local self = setmetatable({}, Button)
    local T = theme.Current

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 54)
    card.BackgroundColor3 = T.Card
    card.BackgroundTransparency = 0.3
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.Parent = parent
    utils:Corner(card, 12)
    utils:Stroke(card, T.Border, 0.88, 1)

    local iconFrame = Instance.new("Frame")
    iconFrame.Size = UDim2.fromOffset(36, 36)
    iconFrame.Position = UDim2.new(0, 10, 0.5, -18)
    iconFrame.BackgroundColor3 = T.Accent
    iconFrame.BackgroundTransparency = 0.75
    iconFrame.BorderSizePixel = 0
    iconFrame.Parent = card
    utils:Corner(iconFrame, 10)

    if config.Icon then
        local iconImg = Instance.new("ImageLabel")
        iconImg.Image = config.Icon
        iconImg.Size = UDim2.fromOffset(20, 20)
        iconImg.Position = UDim2.fromScale(0.5, 0.5)
        iconImg.AnchorPoint = Vector2.new(0.5, 0.5)
        iconImg.BackgroundTransparency = 1
        iconImg.ImageColor3 = T.Accent
        iconImg.Parent = iconFrame
    else
        local dot = Instance.new("Frame")
        dot.Size = UDim2.fromOffset(8, 8)
        dot.Position = UDim2.fromScale(0.5, 0.5)
        dot.AnchorPoint = Vector2.new(0.5, 0.5)
        dot.BackgroundColor3 = T.Accent
        dot.BorderSizePixel = 0
        dot.Parent = iconFrame
        utils:Corner(dot, 4)
    end

    local textContainer = Instance.new("Frame")
    textContainer.Size = UDim2.new(1, -70, 1, 0)
    textContainer.Position = UDim2.fromOffset(58, 0)
    textContainer.BackgroundTransparency = 1
    textContainer.Parent = card

    local title = Instance.new("TextLabel")
    title.Text = config.Title or "Button"
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

    local chevron = Instance.new("TextLabel")
    chevron.Text = "›"
    chevron.TextSize = 20
    chevron.Font = Enum.Font.GothamMedium
    chevron.TextColor3 = T.Accent
    chevron.BackgroundTransparency = 1
    chevron.Size = UDim2.fromOffset(20, 20)
    chevron.Position = UDim2.new(1, -30, 0.5, -10)
    chevron.TextXAlignment = Enum.TextXAlignment.Center
    chevron.Parent = card

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromScale(1, 1)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = card

    ripple:Attach(btn, T.Accent)

    btn.MouseEnter:Connect(function()
        animation:Tween(card, {BackgroundTransparency = 0.1}, 0.18)
        animation:Tween(iconFrame, {BackgroundTransparency = 0.5}, 0.18)
    end)
    btn.MouseLeave:Connect(function()
        animation:Tween(card, {BackgroundTransparency = 0.3}, 0.18)
        animation:Tween(iconFrame, {BackgroundTransparency = 0.75}, 0.18)
    end)
    btn.MouseButton1Click:Connect(function()
        animation:ClickPulse(card)
        if config.Callback then
            pcall(config.Callback)
        end
    end)

    self.Instance = card
    return self
end

return Button
