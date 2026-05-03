local TextBoxComp = {}
TextBoxComp.__index = TextBoxComp

function TextBoxComp.new(parent, config, theme, animation, utils)
    local self = setmetatable({}, TextBoxComp)
    local T = theme.Current

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 64)
    card.BackgroundColor3 = T.Card
    card.BackgroundTransparency = 0.3
    card.BorderSizePixel = 0
    card.Parent = parent
    utils:Corner(card, 12)
    utils:Stroke(card, T.Border, 0.88, 1)

    local labelFrame = Instance.new("Frame")
    labelFrame.Size = UDim2.new(1, -24, 0, 22)
    labelFrame.Position = UDim2.fromOffset(14, 8)
    labelFrame.BackgroundTransparency = 1
    labelFrame.Parent = card

    local title = Instance.new("TextLabel")
    title.Text = config.Title or "TextBox"
    title.TextSize = 13
    title.Font = Enum.Font.GothamMedium
    title.TextColor3 = T.Text
    title.BackgroundTransparency = 1
    title.Size = UDim2.fromScale(1, 1)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = labelFrame

    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(1, -24, 0, 30)
    inputFrame.Position = UDim2.new(0, 12, 0, 30)
    inputFrame.BackgroundColor3 = T.Surface
    inputFrame.BackgroundTransparency = 0.4
    inputFrame.BorderSizePixel = 0
    inputFrame.Parent = card
    utils:Corner(inputFrame, 8)
    utils:Stroke(inputFrame, T.Border, 0.8, 1)

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -16, 1, 0)
    textBox.Position = UDim2.fromOffset(8, 0)
    textBox.BackgroundTransparency = 1
    textBox.Text = ""
    textBox.PlaceholderText = config.Placeholder or "Enter text..."
    textBox.PlaceholderColor3 = T.Subtext
    textBox.TextColor3 = T.Text
    textBox.TextSize = 13
    textBox.Font = Enum.Font.Gotham
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.ClearTextOnFocus = false
    textBox.Parent = inputFrame

    textBox.Focused:Connect(function()
        animation:Tween(inputFrame, {BackgroundTransparency = 0.2}, 0.2)
        animation:Stroke(inputFrame, T.Accent, 0.5, 1)
    end)

    textBox.FocusLost:Connect(function(enterPressed)
        animation:Tween(inputFrame, {BackgroundTransparency = 0.4}, 0.2)
        if config.Callback then
            pcall(config.Callback, textBox.Text)
        end
    end)

    function self:Set(text)
        textBox.Text = text
    end

    function self:Get()
        return textBox.Text
    end

    self.Instance = card
    return self
end

return TextBoxComp
