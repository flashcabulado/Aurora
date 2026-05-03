local Shadows = {}

function Shadows:Apply(frame, offset, color, transparency)
    local existing = frame:FindFirstChild("_Shadow")
    if existing then existing:Destroy() end
    local shadow = Instance.new("Frame")
    shadow.Name = "_Shadow"
    shadow.Size = UDim2.new(1, (offset or 12) * 2, 1, (offset or 12) * 2)
    shadow.Position = UDim2.new(0, -(offset or 12), 0, (offset or 8))
    shadow.BackgroundColor3 = color or Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = transparency or 0.55
    shadow.BorderSizePixel = 0
    shadow.ZIndex = frame.ZIndex - 1
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = shadow
    shadow.Parent = frame.Parent
    local g = Instance.new("UIGradient")
    g.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.4),
        NumberSequenceKeypoint.new(0.5, 0.7),
        NumberSequenceKeypoint.new(1, 1)
    })
    g.Rotation = 90
    g.Parent = shadow
    return shadow
end

function Shadows:Remove(frame)
    local s = frame:FindFirstChild("_Shadow")
    if s then s:Destroy() end
end

return Shadows
