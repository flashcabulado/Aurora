local Section = {}
Section.__index = Section

function Section.new(parent, config, theme, animation, utils, components, ripple)
    local self = setmetatable({}, Section)
    local T = theme.Current

    local wrapper = Instance.new("Frame")
    wrapper.Size = UDim2.new(1, 0, 0, 0)
    wrapper.BackgroundTransparency = 1
    wrapper.AutomaticSize = Enum.AutomaticSize.Y
    wrapper.Parent = parent

    if config.Title then
        local headerRow = Instance.new("Frame")
        headerRow.Size = UDim2.new(1, 0, 0, 24)
        headerRow.BackgroundTransparency = 1
        headerRow.Parent = wrapper

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Text = string.upper(config.Title)
        titleLabel.TextSize = 10
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextColor3 = T.Accent
        titleLabel.BackgroundTransparency = 1
        titleLabel.Size = UDim2.fromScale(1, 1)
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.LetterSpacingPx = 2
        titleLabel.Parent = headerRow

        if config.Description then
            local descLabel = Instance.new("TextLabel")
            descLabel.Text = config.Description
            descLabel.TextSize = 10
            descLabel.Font = Enum.Font.Gotham
            descLabel.TextColor3 = T.Subtext
            descLabel.BackgroundTransparency = 1
            descLabel.Size = UDim2.fromScale(1, 1)
            descLabel.Position = UDim2.new(0.45, 0, 0, 0)
            descLabel.TextXAlignment = Enum.TextXAlignment.Right
            descLabel.Parent = headerRow
        end
    end

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 0, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.AutomaticSize = Enum.AutomaticSize.Y
    contentFrame.Parent = wrapper
    utils:ListLayout(contentFrame, Enum.FillDirection.Vertical, 6)

    local wLayout = utils:ListLayout(wrapper, Enum.FillDirection.Vertical, 8)

    function self:CreateButton(cfg)
        local btn = components.Button.new(contentFrame, cfg, theme, animation, components.Ripple, utils)
        return btn
    end

    function self:CreateToggle(cfg)
        local tog = components.Toggle.new(contentFrame, cfg, theme, animation, utils)
        return tog
    end

    function self:CreateSlider(cfg)
        local sl = components.Slider.new(contentFrame, cfg, theme, animation, utils)
        return sl
    end

    function self:CreateDropdown(cfg)
        local dd = components.Dropdown.new(contentFrame, cfg, theme, animation, utils)
        return dd
    end

    function self:CreateKeybind(cfg)
        local kb = components.Keybind.new(contentFrame, cfg, theme, animation, utils)
        return kb
    end

    function self:CreateTextBox(cfg)
        local tb = components.TextBox.new(contentFrame, cfg, theme, animation, utils)
        return tb
    end

    function self:CreateSeparator()
        local sep = components.Separator.new(contentFrame, theme)
        return sep
    end

    self.Instance = wrapper
    self.Content = contentFrame
    return self
end

return Section
