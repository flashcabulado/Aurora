local Tab = {}
Tab.__index = Tab

function Tab.new(config, theme, animation, utils, components)
    local self = setmetatable({}, Tab)
    local T = theme.Current

    self.Name = config.Name or "Tab"
    self.Icon = config.Icon
    self.Group = config.Group or "General"

    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.fromScale(1, 1)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 3
    contentFrame.ScrollBarImageColor3 = T.Accent
    contentFrame.ScrollBarImageTransparency = 0.4
    contentFrame.CanvasSize = UDim2.fromScale(0, 0)
    contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentFrame.Visible = false

    local innerPad = Instance.new("Frame")
    innerPad.Size = UDim2.new(1, -16, 0, 0)
    innerPad.Position = UDim2.fromOffset(8, 8)
    innerPad.BackgroundTransparency = 1
    innerPad.AutomaticSize = Enum.AutomaticSize.Y
    innerPad.Parent = contentFrame
    utils:ListLayout(innerPad, Enum.FillDirection.Vertical, 10)

    function self:CreateSection(cfg)
        local sec = components.Section.new(innerPad, cfg, theme, animation, utils, components, nil)
        return sec
    end

    function self:Show(anim)
        contentFrame.Visible = true
        contentFrame.GroupTransparency = 1
        contentFrame.Position = UDim2.new(0, 15, 0, 0)
        if anim then
            animation:Tween(contentFrame, {GroupTransparency = 0, Position = UDim2.fromScale(0, 0)}, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        else
            contentFrame.GroupTransparency = 0
            contentFrame.Position = UDim2.fromScale(0, 0)
        end
    end

    function self:Hide()
        contentFrame.Visible = false
    end

    self.Frame = contentFrame
    self.Inner = innerPad
    return self
end

return Tab
