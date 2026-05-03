local UserInputService = game:GetService("UserInputService")

local Utils = {}

Utils.IsMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

function Utils:Create(class, props, children)
    local inst = Instance.new(class)
    if props then
        for k, v in pairs(props) do
            if k ~= "Parent" then
                pcall(function() inst[k] = v end)
            end
        end
    end
    if children then
        for _, child in ipairs(children) do
            child.Parent = inst
        end
    end
    if props and props.Parent then
        inst.Parent = props.Parent
    end
    return inst
end

function Utils:Corner(inst, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 12)
    c.Parent = inst
    return c
end

function Utils:Stroke(inst, color, transparency, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(255, 255, 255)
    s.Transparency = transparency or 0.85
    s.Thickness = thickness or 1
    s.Parent = inst
    return s
end

function Utils:Padding(inst, top, right, bottom, left)
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, top or 8)
    p.PaddingRight = UDim.new(0, right or 8)
    p.PaddingBottom = UDim.new(0, bottom or 8)
    p.PaddingLeft = UDim.new(0, left or 8)
    p.Parent = inst
    return p
end

function Utils:ListLayout(inst, dir, spacing, hAlign, vAlign)
    local l = Instance.new("UIListLayout")
    l.FillDirection = dir or Enum.FillDirection.Vertical
    l.Padding = UDim.new(0, spacing or 6)
    l.HorizontalAlignment = hAlign or Enum.HorizontalAlignment.Left
    l.VerticalAlignment = vAlign or Enum.VerticalAlignment.Top
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Parent = inst
    return l
end

function Utils:GridLayout(inst, cellSize, cellPadding)
    local g = Instance.new("UIGridLayout")
    g.CellSize = cellSize or UDim2.fromOffset(100, 30)
    g.CellPaddingH = UDim.new(0, cellPadding or 6)
    g.CellPaddingV = UDim.new(0, cellPadding or 6)
    g.SortOrder = Enum.SortOrder.LayoutOrder
    g.Parent = inst
    return g
end

function Utils:ScrollFrame(parent, size, pos, canvasSize)
    local frame = Instance.new("ScrollingFrame")
    frame.Size = size or UDim2.fromScale(1, 1)
    frame.Position = pos or UDim2.fromScale(0, 0)
    frame.BackgroundTransparency = 1
    frame.ScrollBarThickness = 3
    frame.ScrollBarImageColor3 = Color3.fromRGB(124, 92, 255)
    frame.ScrollBarImageTransparency = 0.5
    frame.BorderSizePixel = 0
    frame.CanvasSize = canvasSize or UDim2.fromScale(0, 0)
    frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    frame.Parent = parent
    return frame
end

function Utils:Label(parent, text, size, color, font, pos, anchor)
    local l = Instance.new("TextLabel")
    l.Text = text or ""
    l.TextSize = size or 14
    l.TextColor3 = color or Color3.fromRGB(245, 247, 250)
    l.Font = font or Enum.Font.GothamMedium
    l.BackgroundTransparency = 1
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Size = UDim2.new(1, 0, 0, size and size + 4 or 18)
    if pos then l.Position = pos end
    if anchor then l.AnchorPoint = anchor end
    l.Parent = parent
    return l
end

function Utils:Button(parent, text, size, pos)
    local b = Instance.new("TextButton")
    b.Text = text or ""
    b.Size = size or UDim2.fromOffset(100, 36)
    b.Position = pos or UDim2.fromScale(0, 0)
    b.BackgroundTransparency = 1
    b.AutoButtonColor = false
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 14
    b.Parent = parent
    return b
end

function Utils:Frame(parent, size, pos, color, transparency)
    local f = Instance.new("Frame")
    f.Size = size or UDim2.fromScale(1, 1)
    f.Position = pos or UDim2.fromScale(0, 0)
    f.BackgroundColor3 = color or Color3.fromRGB(20, 24, 34)
    f.BackgroundTransparency = transparency or 0
    f.BorderSizePixel = 0
    f.Parent = parent
    return f
end

function Utils:Image(parent, id, size, pos)
    local img = Instance.new("ImageLabel")
    img.Image = id or ""
    img.Size = size or UDim2.fromOffset(32, 32)
    img.Position = pos or UDim2.fromScale(0, 0)
    img.BackgroundTransparency = 1
    img.ScaleType = Enum.ScaleType.Fit
    img.Parent = parent
    return img
end

function Utils:MakeDraggable(frame, handle)
    local dragging, dragStart, startPos = false, nil, nil
    handle = handle or frame
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Utils:AutoSize(frame)
    frame.AutomaticSize = Enum.AutomaticSize.Y
end

function Utils:SizeToContent(frame, layout)
    layout.Changed:Connect(function()
        frame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 16)
    end)
end

return Utils
