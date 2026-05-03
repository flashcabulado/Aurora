local UserInputService = game:GetService("UserInputService")

local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(parent, config, theme, animation, utils)
    local self = setmetatable({}, Dropdown)
    local T = theme.Current
    self.Value = config.Default or (config.Options and config.Options[1]) or ""
    self.Open = false
    self.Options = config.Options or {}

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 54)
    card.BackgroundColor3 = T.Card
    card.BackgroundTransparency = 0.3
    card.BorderSizePixel = 0
    card.ClipsDescendants = false
    card.ZIndex = 5
    card.Parent = parent
    utils:Corner(card, 12)
    utils:Stroke(card, T.Border, 0.88, 1)

    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, -24, 1, 0)
    headerFrame.Position = UDim2.fromOffset(14, 0)
    headerFrame.BackgroundTransparency = 1
    headerFrame.ZIndex = card.ZIndex
    headerFrame.Parent = card

    local textBlock = Instance.new("Frame")
    textBlock.Size = UDim2.new(0.7, 0, 1, 0)
    textBlock.BackgroundTransparency = 1
    textBlock.ZIndex = card.ZIndex
    textBlock.Parent = headerFrame

    local title = Instance.new("TextLabel")
    title.Text = config.Title or "Dropdown"
    title.TextSize = 13
    title.Font = Enum.Font.GothamMedium
    title.TextColor3 = T.Text
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 18)
    title.Position = UDim2.new(0, 0, 0.5, config.Description and -12 or -9)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = card.ZIndex
    title.Parent = textBlock

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
        desc.ZIndex = card.ZIndex
        desc.Parent = textBlock
    end

    local valueDisplay = Instance.new("Frame")
    valueDisplay.Size = UDim2.fromOffset(110, 28)
    valueDisplay.Position = UDim2.new(1, -118, 0.5, -14)
    valueDisplay.BackgroundColor3 = T.Surface
    valueDisplay.BackgroundTransparency = 0.3
    valueDisplay.BorderSizePixel = 0
    valueDisplay.ZIndex = card.ZIndex
    valueDisplay.Parent = card
    utils:Corner(valueDisplay, 8)
    utils:Stroke(valueDisplay, T.Accent, 0.7, 1)

    local selectedLabel = Instance.new("TextLabel")
    selectedLabel.Text = self.Value
    selectedLabel.TextSize = 12
    selectedLabel.Font = Enum.Font.GothamMedium
    selectedLabel.TextColor3 = T.Accent
    selectedLabel.BackgroundTransparency = 1
    selectedLabel.Size = UDim2.new(1, -24, 1, 0)
    selectedLabel.Position = UDim2.fromOffset(8, 0)
    selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
    selectedLabel.ZIndex = card.ZIndex + 1
    selectedLabel.Parent = valueDisplay

    local arrow = Instance.new("TextLabel")
    arrow.Text = "▾"
    arrow.TextSize = 12
    arrow.Font = Enum.Font.GothamBold
    arrow.TextColor3 = T.Subtext
    arrow.BackgroundTransparency = 1
    arrow.Size = UDim2.fromOffset(18, 18)
    arrow.Position = UDim2.new(1, -20, 0.5, -9)
    arrow.TextXAlignment = Enum.TextXAlignment.Center
    arrow.ZIndex = card.ZIndex + 1
    arrow.Parent = valueDisplay

    local dropFrame = Instance.new("Frame")
    dropFrame.Size = UDim2.new(1, 0, 0, 0)
    dropFrame.Position = UDim2.new(0, 0, 1, 4)
    dropFrame.BackgroundColor3 = T.Surface
    dropFrame.BackgroundTransparency = 0.1
    dropFrame.BorderSizePixel = 0
    dropFrame.ClipsDescendants = true
    dropFrame.ZIndex = card.ZIndex + 3
    dropFrame.Visible = false
    dropFrame.Parent = card
    utils:Corner(dropFrame, 10)
    utils:Stroke(dropFrame, T.Border, 0.8, 1)

    local optionList = Instance.new("Frame")
    optionList.Size = UDim2.fromScale(1, 1)
    optionList.BackgroundTransparency = 1
    optionList.ZIndex = dropFrame.ZIndex
    optionList.Parent = dropFrame
    utils:ListLayout(optionList, Enum.FillDirection.Vertical, 0)
    utils:Padding(optionList, 4, 6, 4, 6)

    local function createOption(optText)
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 32)
        optBtn.BackgroundColor3 = T.Card
        optBtn.BackgroundTransparency = optText == self.Value and 0.2 or 1
        optBtn.BorderSizePixel = 0
        optBtn.Text = optText
        optBtn.TextSize = 13
        optBtn.Font = Enum.Font.GothamMedium
        optBtn.TextColor3 = optText == self.Value and T.Accent or T.Text
        optBtn.TextXAlignment = Enum.TextXAlignment.Left
        optBtn.AutoButtonColor = false
        optBtn.ZIndex = dropFrame.ZIndex + 1
        optBtn.Parent = optionList
        utils:Corner(optBtn, 8)
        utils:Padding(optBtn, 0, 0, 0, 8)

        optBtn.MouseEnter:Connect(function()
            animation:Quick(optBtn, {BackgroundTransparency = 0.3}, 0.12)
        end)
        optBtn.MouseLeave:Connect(function()
            animation:Quick(optBtn, {BackgroundTransparency = optText == self.Value and 0.2 or 1}, 0.12)
        end)
        optBtn.MouseButton1Click:Connect(function()
            self.Value = optText
            selectedLabel.Text = optText
            self:Close()
            if config.Callback then pcall(config.Callback, optText) end
        end)
    end

    for _, opt in ipairs(self.Options) do
        createOption(opt)
    end

    local targetH = #self.Options * 36 + 12
    if targetH > 180 then targetH = 180 end

    function self:Close()
        self.Open = false
        animation:Tween(arrow, {Rotation = 0}, 0.2)
        animation:Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        task.delay(0.25, function()
            dropFrame.Visible = false
        end)
    end

    function self:OpenDrop()
        self.Open = true
        dropFrame.Visible = true
        dropFrame.Size = UDim2.new(1, 0, 0, 0)
        animation:Tween(arrow, {Rotation = 180}, 0.2)
        animation:Tween(dropFrame, {Size = UDim2.new(1, 0, 0, targetH)}, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    end

    local mainBtn = Instance.new("TextButton")
    mainBtn.Size = UDim2.fromScale(1, 1)
    mainBtn.BackgroundTransparency = 1
    mainBtn.Text = ""
    mainBtn.AutoButtonColor = false
    mainBtn.ZIndex = card.ZIndex + 2
    mainBtn.Parent = card

    mainBtn.MouseButton1Click:Connect(function()
        if self.Open then
            self:Close()
        else
            self:OpenDrop()
        end
    end)

    mainBtn.MouseEnter:Connect(function()
        animation:Tween(card, {BackgroundTransparency = 0.1}, 0.18)
    end)
    mainBtn.MouseLeave:Connect(function()
        animation:Tween(card, {BackgroundTransparency = 0.3}, 0.18)
    end)

    function self:Set(val)
        self.Value = val
        selectedLabel.Text = val
    end

    self.Instance = card
    return self
end

return Dropdown
