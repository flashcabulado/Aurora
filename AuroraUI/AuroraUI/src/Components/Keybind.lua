local UserInputService = game:GetService("UserInputService")

local Keybind = {}
Keybind.__index = Keybind

function Keybind.new(parent, config, theme, animation, utils)
    local self = setmetatable({}, Keybind)
    local T = theme.Current
    self.Key = config.Default or Enum.KeyCode.Unknown
    self.Listening = false

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 54)
    card.BackgroundColor3 = T.Card
    card.BackgroundTransparency = 0.3
    card.BorderSizePixel = 0
    card.Parent = parent
    utils:Corner(card, 12)
    utils:Stroke(card, T.Border, 0.88, 1)

    local textBlock = Instance.new("Frame")
    textBlock.Size = UDim2.new(0.65, 0, 1, 0)
    textBlock.Position = UDim2.fromOffset(14, 0)
    textBlock.BackgroundTransparency = 1
    textBlock.Parent = card

    local title = Instance.new("TextLabel")
    title.Text = config.Title or "Keybind"
    title.TextSize = 13
    title.Font = Enum.Font.GothamMedium
    title.TextColor3 = T.Text
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 18)
    title.Position = UDim2.new(0, 0, 0.5, config.Description and -12 or -9)
    title.TextXAlignment = Enum.TextXAlignment.Left
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
        desc.Parent = textBlock
    end

    local keyDisplay = Instance.new("TextButton")
    keyDisplay.Size = UDim2.fromOffset(80, 28)
    keyDisplay.Position = UDim2.new(1, -92, 0.5, -14)
    keyDisplay.BackgroundColor3 = T.Surface
    keyDisplay.BackgroundTransparency = 0.3
    keyDisplay.BorderSizePixel = 0
    keyDisplay.Text = self.Key.Name
    keyDisplay.TextSize = 12
    keyDisplay.Font = Enum.Font.GothamBold
    keyDisplay.TextColor3 = T.Accent
    keyDisplay.AutoButtonColor = false
    keyDisplay.Parent = card
    utils:Corner(keyDisplay, 8)
    utils:Stroke(keyDisplay, T.Accent, 0.7, 1)

    keyDisplay.MouseButton1Click:Connect(function()
        if self.Listening then return end
        self.Listening = true
        keyDisplay.Text = "..."
        keyDisplay.TextColor3 = T.Warning
        animation:Tween(keyDisplay, {BackgroundColor3 = T.Card}, 0.15)
        local conn
        conn = UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                self.Key = input.KeyCode
                keyDisplay.Text = input.KeyCode.Name
                keyDisplay.TextColor3 = T.Accent
                animation:Tween(keyDisplay, {BackgroundColor3 = T.Surface}, 0.15)
                self.Listening = false
                conn:Disconnect()
            end
        end)
    end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if not self.Listening and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == self.Key then
            if config.Callback then pcall(config.Callback) end
        end
    end)

    function self:Set(key)
        self.Key = key
        keyDisplay.Text = key.Name
    end

    self.Instance = card
    return self
end

return Keybind
