local TweenService = game:GetService("TweenService")

local Notification = {}
Notification.__index = Notification

local queue = {}
local showing = false
local notifContainer = nil

local TYPE_COLORS = {
    Success = Color3.fromRGB(52, 211, 153),
    Warning = Color3.fromRGB(251, 191, 36),
    Error = Color3.fromRGB(248, 113, 113),
    Info = Color3.fromRGB(0, 212, 255),
    Default = Color3.fromRGB(124, 92, 255)
}

local TYPE_ICONS = {
    Success = "✓",
    Warning = "⚠",
    Error = "✕",
    Info = "i",
    Default = "★"
}

local function getOrCreateContainer(gui)
    if notifContainer and notifContainer.Parent then
        return notifContainer
    end
    local container = Instance.new("Frame")
    container.Name = "_AuroraNotifications"
    container.Size = UDim2.fromOffset(320, 600)
    container.Position = UDim2.new(1, -330, 0, 20)
    container.BackgroundTransparency = 1
    container.AnchorPoint = Vector2.new(0, 0)
    container.Parent = gui
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = container
    notifContainer = container
    return container
end

function Notification:Show(config, gui)
    local T = {
        Card = Color3.fromRGB(28, 34, 46),
        Text = Color3.fromRGB(245, 247, 250),
        Subtext = Color3.fromRGB(150, 160, 175),
        Border = Color3.fromRGB(255, 255, 255)
    }
    local container = getOrCreateContainer(gui)
    local notifColor = TYPE_COLORS[config.Type] or TYPE_COLORS.Default
    local notifIcon = TYPE_ICONS[config.Type] or TYPE_ICONS.Default
    local duration = config.Duration or 4

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(300, 72)
    frame.BackgroundColor3 = T.Card
    frame.BackgroundTransparency = 0.05
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Position = UDim2.fromOffset(320, 0)
    frame.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = notifColor
    stroke.Transparency = 0.6
    stroke.Thickness = 1
    stroke.Parent = frame

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 4, 1, 0)
    accent.BackgroundColor3 = notifColor
    accent.BorderSizePixel = 0
    accent.Parent = frame

    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 4)
    accentCorner.Parent = accent

    local iconCircle = Instance.new("Frame")
    iconCircle.Size = UDim2.fromOffset(32, 32)
    iconCircle.Position = UDim2.new(0, 14, 0.5, -16)
    iconCircle.BackgroundColor3 = notifColor
    iconCircle.BackgroundTransparency = 0.8
    iconCircle.BorderSizePixel = 0
    iconCircle.Parent = frame

    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 10)
    iconCorner.Parent = iconCircle

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Text = notifIcon
    iconLabel.TextSize = 14
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextColor3 = notifColor
    iconLabel.BackgroundTransparency = 1
    iconLabel.Size = UDim2.fromScale(1, 1)
    iconLabel.TextXAlignment = Enum.TextXAlignment.Center
    iconLabel.Parent = iconCircle

    local textFrame = Instance.new("Frame")
    textFrame.Size = UDim2.new(1, -62, 1, 0)
    textFrame.Position = UDim2.fromOffset(56, 0)
    textFrame.BackgroundTransparency = 1
    textFrame.Parent = frame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = config.Title or "Notification"
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextColor3 = T.Text
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, 0, 0, 20)
    titleLabel.Position = UDim2.new(0, 0, 0.5, -20)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = textFrame

    local contentLabel = Instance.new("TextLabel")
    contentLabel.Text = config.Content or ""
    contentLabel.TextSize = 12
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.TextColor3 = T.Subtext
    contentLabel.BackgroundTransparency = 1
    contentLabel.Size = UDim2.new(1, 0, 0, 16)
    contentLabel.Position = UDim2.new(0, 0, 0.5, 2)
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextWrapped = true
    contentLabel.Parent = textFrame

    local progress = Instance.new("Frame")
    progress.Size = UDim2.fromScale(1, 0)
    progress.Position = UDim2.new(0, 0, 1, -2)
    progress.BackgroundColor3 = notifColor
    progress.BackgroundTransparency = 0.5
    progress.BorderSizePixel = 0
    progress.Parent = frame

    local slideIn = TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.fromOffset(0, 0)})
    slideIn:Play()

    local progressTween = TweenService:Create(progress, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 0)})
    progressTween:Play()

    task.delay(duration, function()
        local fadeOut = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.fromOffset(320, 0),
            BackgroundTransparency = 1
        })
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            frame:Destroy()
        end)
    end)
end

return Notification
