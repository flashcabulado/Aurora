local Separator = {}
Separator.__index = Separator

function Separator.new(parent, theme)
    local self = setmetatable({}, Separator)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -24, 0, 1)
    frame.Position = UDim2.new(0, 12, 0, 0)
    frame.BackgroundColor3 = theme.Current.Border
    frame.BackgroundTransparency = 0.88
    frame.BorderSizePixel = 0
    frame.Parent = parent
    self.Instance = frame
    return self
end

return Separator
