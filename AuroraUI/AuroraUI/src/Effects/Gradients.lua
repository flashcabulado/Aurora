local Gradients = {}

function Gradients:Apply(frame, colorSequence, rotation)
    local existing = frame:FindFirstChildOfClass("UIGradient")
    if existing then existing:Destroy() end
    local g = Instance.new("UIGradient")
    g.Color = colorSequence or ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(124, 92, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 212, 255))
    })
    g.Rotation = rotation or 135
    g.Parent = frame
    return g
end

function Gradients:ApplyVertical(frame, topColor, bottomColor)
    return self:Apply(frame, ColorSequence.new({
        ColorSequenceKeypoint.new(0, topColor or Color3.fromRGB(28, 34, 46)),
        ColorSequenceKeypoint.new(1, bottomColor or Color3.fromRGB(12, 14, 20))
    }), 90)
end

function Gradients:ApplyAccent(frame)
    return self:Apply(frame, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(124, 92, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 60, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 212, 255))
    }), 135)
end

function Gradients:ApplySurface(frame)
    return self:Apply(frame, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 36, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 24, 34))
    }), 120)
end

function Gradients:ApplyGlow(frame, color)
    return self:Apply(frame, ColorSequence.new({
        ColorSequenceKeypoint.new(0, color or Color3.fromRGB(124, 92, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
    }), 90)
end

function Gradients:Remove(frame)
    local g = frame:FindFirstChildOfClass("UIGradient")
    if g then g:Destroy() end
end

return Gradients
