local TweenService = game:GetService("TweenService")

local Ripple = {}

function Ripple:Create(button, inputPos, color)
    local ripple = Instance.new("Frame")
    ripple.BackgroundColor3 = color or Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.7
    ripple.BorderSizePixel = 0
    ripple.ZIndex = button.ZIndex + 2
    ripple.Size = UDim2.fromOffset(0, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    local absPos = button.AbsolutePosition
    local relX = inputPos.X - absPos.X
    local relY = inputPos.Y - absPos.Y
    ripple.Position = UDim2.fromOffset(relX, relY)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    ripple.Parent = button
    local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2.5
    local expandInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local expand = TweenService:Create(ripple, expandInfo, {
        Size = UDim2.fromOffset(size, size),
        BackgroundTransparency = 1
    })
    expand:Play()
    expand.Completed:Connect(function()
        ripple:Destroy()
    end)
end

function Ripple:Attach(button, color)
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Ripple:Create(button, input.Position, color)
        end
    end)
end

return Ripple
