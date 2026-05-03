local TweenService = game:GetService("TweenService")

local Animation = {}

function Animation:Tween(instance, properties, duration, style, direction)
    local info = TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quart,
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, info, properties)
    tween:Play()
    return tween
end

function Animation:Spring(instance, properties, duration)
    return self:Tween(instance, properties, duration or 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

function Animation:Smooth(instance, properties, duration)
    return self:Tween(instance, properties, duration or 0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
end

function Animation:Quick(instance, properties, duration)
    return self:Tween(instance, properties, duration or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
end

function Animation:WindowOpen(frame)
    frame.GroupTransparency = 1
    frame.Size = UDim2.new(frame.Size.X.Scale, frame.Size.X.Offset, frame.Size.Y.Scale * 0.96, frame.Size.Y.Offset * 0.96)
    local targetSize = UDim2.new(frame.Size.X.Scale, frame.Size.X.Offset, frame.Size.Y.Scale / 0.96, frame.Size.Y.Offset / 0.96)
    self:Tween(frame, {GroupTransparency = 0, Size = targetSize}, 0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
end

function Animation:WindowClose(frame, callback)
    local targetSize = UDim2.new(frame.Size.X.Scale, frame.Size.X.Offset, frame.Size.Y.Scale * 0.96, frame.Size.Y.Offset * 0.96)
    local tween = self:Tween(frame, {GroupTransparency = 1, Size = targetSize}, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    if callback then
        tween.Completed:Connect(callback)
    end
    return tween
end

function Animation:FadeIn(instance, duration)
    instance.BackgroundTransparency = 1
    return self:Tween(instance, {BackgroundTransparency = 0}, duration or 0.25)
end

function Animation:FadeOut(instance, duration)
    return self:Tween(instance, {BackgroundTransparency = 1}, duration or 0.25)
end

function Animation:SlideIn(instance, from, duration)
    local originalPos = instance.Position
    if from == "right" then
        instance.Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset + 30, originalPos.Y.Scale, originalPos.Y.Offset)
    elseif from == "left" then
        instance.Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset - 30, originalPos.Y.Scale, originalPos.Y.Offset)
    elseif from == "top" then
        instance.Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset, originalPos.Y.Scale, originalPos.Y.Offset - 20)
    elseif from == "bottom" then
        instance.Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset, originalPos.Y.Scale, originalPos.Y.Offset + 20)
    end
    instance.BackgroundTransparency = 1
    self:Tween(instance, {Position = originalPos, BackgroundTransparency = 0}, duration or 0.3)
end

function Animation:HoverOn(btn, theme)
    self:Quick(btn, {BackgroundColor3 = theme.Current.Accent}, 0.18)
end

function Animation:HoverOff(btn, originalColor)
    self:Quick(btn, {BackgroundColor3 = originalColor}, 0.18)
end

function Animation:ClickPulse(btn)
    local orig = btn.Size
    self:Quick(btn, {Size = UDim2.new(orig.X.Scale, orig.X.Offset - 2, orig.Y.Scale, orig.Y.Offset - 2)}, 0.06)
    task.delay(0.08, function()
        self:Quick(btn, {Size = orig}, 0.1)
    end)
end

return Animation
