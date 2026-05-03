local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local Theme; do
  Theme = {}
  
  Theme.Presets = {
      Dark = {
          Background = Color3.fromRGB(12, 14, 20),
          Surface = Color3.fromRGB(20, 24, 34),
          Card = Color3.fromRGB(28, 34, 46),
          Accent = Color3.fromRGB(124, 92, 255),
          AccentSecondary = Color3.fromRGB(0, 212, 255),
          Text = Color3.fromRGB(245, 247, 250),
          Subtext = Color3.fromRGB(150, 160, 175),
          Border = Color3.fromRGB(255, 255, 255),
          Success = Color3.fromRGB(52, 211, 153),
          Warning = Color3.fromRGB(251, 191, 36),
          Error = Color3.fromRGB(248, 113, 113)
      },
      Light = {
          Background = Color3.fromRGB(242, 244, 248),
          Surface = Color3.fromRGB(255, 255, 255),
          Card = Color3.fromRGB(230, 234, 242),
          Accent = Color3.fromRGB(124, 92, 255),
          AccentSecondary = Color3.fromRGB(0, 150, 200),
          Text = Color3.fromRGB(15, 18, 28),
          Subtext = Color3.fromRGB(90, 100, 120),
          Border = Color3.fromRGB(0, 0, 0),
          Success = Color3.fromRGB(34, 170, 110),
          Warning = Color3.fromRGB(200, 150, 20),
          Error = Color3.fromRGB(210, 70, 70)
      }
  }
  
  Theme.Current = {
      Background = Color3.fromRGB(12, 14, 20),
      Surface = Color3.fromRGB(20, 24, 34),
      Card = Color3.fromRGB(28, 34, 46),
      Accent = Color3.fromRGB(124, 92, 255),
      AccentSecondary = Color3.fromRGB(0, 212, 255),
      Text = Color3.fromRGB(245, 247, 250),
      Subtext = Color3.fromRGB(150, 160, 175),
      Border = Color3.fromRGB(255, 255, 255),
      Success = Color3.fromRGB(52, 211, 153),
      Warning = Color3.fromRGB(251, 191, 36),
      Error = Color3.fromRGB(248, 113, 113)
  }
  
  Theme.Listeners = {}
  
  function Theme:Apply(config)
      for k, v in pairs(config) do
          self.Current[k] = v
      end
      for _, fn in ipairs(self.Listeners) do
          pcall(fn, self.Current)
      end
  end
  
  function Theme:UsePreset(name)
      if self.Presets[name] then
          self:Apply(self.Presets[name])
      end
  end
  
  function Theme:OnChange(fn)
      table.insert(self.Listeners, fn)
  end
  
  function Theme:Get(key)
      return self.Current[key]
  end
  
  Theme = Theme
end

local Animation; do
  
  Animation = {}
  
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
  
  Animation = Animation
end

local Utils; do
  
  Utils = {}
  
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
  
  Utils = Utils
end

local Assets; do
  Assets = {}
  
  Assets.Icons = {
      Home = "rbxassetid://7733715400",
      Settings = "rbxassetid://7734053495",
      Star = "rbxassetid://7743878855",
      Shield = "rbxassetid://7743882715",
      Bolt = "rbxassetid://7733651120",
      User = "rbxassetid://7734053495",
      Eye = "rbxassetid://7734053495",
      Lock = "rbxassetid://7734053495",
      Search = "rbxassetid://7734053495",
      Bell = "rbxassetid://7734053495",
      Chart = "rbxassetid://7734053495",
      Map = "rbxassetid://7734053495",
      Heart = "rbxassetid://7734053495",
      Sparkles = "rbxassetid://7733715400",
      X = "rbxassetid://7734053495",
      Check = "rbxassetid://7734053495",
      Info = "rbxassetid://7734053495",
      Warning = "rbxassetid://7734053495",
      Error = "rbxassetid://7734053495",
      ChevronDown = "rbxassetid://7734053495",
      ChevronRight = "rbxassetid://7734053495",
  }
  
  Assets.Sounds = {}
  
  function Assets:GetIcon(name)
      return self.Icons[name] or ""
  end
  
  Assets = Assets
end

local Gradients; do
  Gradients = {}
  
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
  
  Gradients = Gradients
end

local Textures; do
  Textures = {}
  
  local NOISE_ID = "rbxassetid://6580542979"
  
  function Textures:ApplyNoise(frame, transparency)
      local existing = frame:FindFirstChild("_NoiseTexture")
      if existing then existing:Destroy() end
      local img = Instance.new("ImageLabel")
      img.Name = "_NoiseTexture"
      img.Image = NOISE_ID
      img.Size = UDim2.fromScale(1, 1)
      img.Position = UDim2.fromScale(0, 0)
      img.BackgroundTransparency = 1
      img.ImageTransparency = transparency or 0.92
      img.ScaleType = Enum.ScaleType.Tile
      img.TileSize = UDim2.fromOffset(128, 128)
      img.ZIndex = frame.ZIndex
      img.Parent = frame
      return img
  end
  
  function Textures:Remove(frame)
      local t = frame:FindFirstChild("_NoiseTexture")
      if t then t:Destroy() end
  end
  
  Textures = Textures
end

local Shadows; do
  Shadows = {}
  
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
  
  Shadows = Shadows
end

local Ripple; do
  
  Ripple = {}
  
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
  
  Ripple = Ripple
end

local Separator; do
  Separator = {}
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
  
  Separator = Separator
end

local Button; do
  
  Button = {}
  Button.__index = Button
  
  function Button.new(parent, config, theme, animation, ripple, utils)
      local self = setmetatable({}, Button)
      local T = theme.Current
  
      local card = Instance.new("Frame")
      card.Size = UDim2.new(1, 0, 0, 54)
      card.BackgroundColor3 = T.Card
      card.BackgroundTransparency = 0.3
      card.BorderSizePixel = 0
      card.ClipsDescendants = true
      card.Parent = parent
      utils:Corner(card, 12)
      utils:Stroke(card, T.Border, 0.88, 1)
  
      local iconFrame = Instance.new("Frame")
      iconFrame.Size = UDim2.fromOffset(36, 36)
      iconFrame.Position = UDim2.new(0, 10, 0.5, -18)
      iconFrame.BackgroundColor3 = T.Accent
      iconFrame.BackgroundTransparency = 0.75
      iconFrame.BorderSizePixel = 0
      iconFrame.Parent = card
      utils:Corner(iconFrame, 10)
  
      if config.Icon then
          local iconImg = Instance.new("ImageLabel")
          iconImg.Image = config.Icon
          iconImg.Size = UDim2.fromOffset(20, 20)
          iconImg.Position = UDim2.fromScale(0.5, 0.5)
          iconImg.AnchorPoint = Vector2.new(0.5, 0.5)
          iconImg.BackgroundTransparency = 1
          iconImg.ImageColor3 = T.Accent
          iconImg.Parent = iconFrame
      else
          local dot = Instance.new("Frame")
          dot.Size = UDim2.fromOffset(8, 8)
          dot.Position = UDim2.fromScale(0.5, 0.5)
          dot.AnchorPoint = Vector2.new(0.5, 0.5)
          dot.BackgroundColor3 = T.Accent
          dot.BorderSizePixel = 0
          dot.Parent = iconFrame
          utils:Corner(dot, 4)
      end
  
      local textContainer = Instance.new("Frame")
      textContainer.Size = UDim2.new(1, -70, 1, 0)
      textContainer.Position = UDim2.fromOffset(58, 0)
      textContainer.BackgroundTransparency = 1
      textContainer.Parent = card
  
      local title = Instance.new("TextLabel")
      title.Text = config.Title or "Button"
      title.TextSize = 14
      title.Font = Enum.Font.GothamMedium
      title.TextColor3 = T.Text
      title.BackgroundTransparency = 1
      title.Size = UDim2.new(1, 0, 0, 18)
      title.Position = UDim2.new(0, 0, 0.5, config.Description and -12 or -9)
      title.TextXAlignment = Enum.TextXAlignment.Left
      title.Parent = textContainer
  
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
          desc.Parent = textContainer
      end
  
      local chevron = Instance.new("TextLabel")
      chevron.Text = "›"
      chevron.TextSize = 20
      chevron.Font = Enum.Font.GothamMedium
      chevron.TextColor3 = T.Accent
      chevron.BackgroundTransparency = 1
      chevron.Size = UDim2.fromOffset(20, 20)
      chevron.Position = UDim2.new(1, -30, 0.5, -10)
      chevron.TextXAlignment = Enum.TextXAlignment.Center
      chevron.Parent = card
  
      local btn = Instance.new("TextButton")
      btn.Size = UDim2.fromScale(1, 1)
      btn.BackgroundTransparency = 1
      btn.Text = ""
      btn.AutoButtonColor = false
      btn.Parent = card
  
      ripple:Attach(btn, T.Accent)
  
      btn.MouseEnter:Connect(function()
          animation:Tween(card, {BackgroundTransparency = 0.1}, 0.18)
          animation:Tween(iconFrame, {BackgroundTransparency = 0.5}, 0.18)
      end)
      btn.MouseLeave:Connect(function()
          animation:Tween(card, {BackgroundTransparency = 0.3}, 0.18)
          animation:Tween(iconFrame, {BackgroundTransparency = 0.75}, 0.18)
      end)
      btn.MouseButton1Click:Connect(function()
          animation:ClickPulse(card)
          if config.Callback then
              pcall(config.Callback)
          end
      end)
  
      self.Instance = card
      return self
  end
  
  Button = Button
end

local Toggle; do
  
  Toggle = {}
  Toggle.__index = Toggle
  
  function Toggle.new(parent, config, theme, animation, utils)
      local self = setmetatable({}, Toggle)
      local T = theme.Current
      self.Value = config.Default == true
  
      local card = Instance.new("Frame")
      card.Size = UDim2.new(1, 0, 0, 54)
      card.BackgroundColor3 = T.Card
      card.BackgroundTransparency = 0.3
      card.BorderSizePixel = 0
      card.Parent = parent
      utils:Corner(card, 12)
      utils:Stroke(card, T.Border, 0.88, 1)
  
      local textContainer = Instance.new("Frame")
      textContainer.Size = UDim2.new(1, -80, 1, 0)
      textContainer.Position = UDim2.fromOffset(14, 0)
      textContainer.BackgroundTransparency = 1
      textContainer.Parent = card
  
      local title = Instance.new("TextLabel")
      title.Text = config.Title or "Toggle"
      title.TextSize = 14
      title.Font = Enum.Font.GothamMedium
      title.TextColor3 = T.Text
      title.BackgroundTransparency = 1
      title.Size = UDim2.new(1, 0, 0, 18)
      title.Position = UDim2.new(0, 0, 0.5, config.Description and -12 or -9)
      title.TextXAlignment = Enum.TextXAlignment.Left
      title.Parent = textContainer
  
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
          desc.Parent = textContainer
      end
  
      local trackFrame = Instance.new("Frame")
      trackFrame.Size = UDim2.fromOffset(46, 26)
      trackFrame.Position = UDim2.new(1, -58, 0.5, -13)
      trackFrame.BackgroundColor3 = self.Value and T.Accent or Color3.fromRGB(60, 65, 80)
      trackFrame.BorderSizePixel = 0
      trackFrame.Parent = card
      utils:Corner(trackFrame, 13)
  
      local thumb = Instance.new("Frame")
      thumb.Size = UDim2.fromOffset(20, 20)
      thumb.Position = self.Value and UDim2.fromOffset(23, 3) or UDim2.fromOffset(3, 3)
      thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      thumb.BorderSizePixel = 0
      thumb.ZIndex = trackFrame.ZIndex + 1
      thumb.Parent = trackFrame
      utils:Corner(thumb, 10)
  
      local glowFrame = Instance.new("Frame")
      glowFrame.Size = UDim2.fromOffset(46, 26)
      glowFrame.Position = UDim2.fromScale(0, 0)
      glowFrame.BackgroundColor3 = T.Accent
      glowFrame.BackgroundTransparency = self.Value and 0.6 or 1
      glowFrame.BorderSizePixel = 0
      glowFrame.ZIndex = trackFrame.ZIndex - 1
      glowFrame.Parent = trackFrame
      utils:Corner(glowFrame, 13)
  
      local btn = Instance.new("TextButton")
      btn.Size = UDim2.fromScale(1, 1)
      btn.BackgroundTransparency = 1
      btn.Text = ""
      btn.AutoButtonColor = false
      btn.Parent = card
  
      local function updateVisual(val)
          if val then
              animation:Tween(trackFrame, {BackgroundColor3 = T.Accent}, 0.2)
              animation:Tween(thumb, {Position = UDim2.fromOffset(23, 3)}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
              animation:Tween(glowFrame, {BackgroundTransparency = 0.6}, 0.2)
          else
              animation:Tween(trackFrame, {BackgroundColor3 = Color3.fromRGB(60, 65, 80)}, 0.2)
              animation:Tween(thumb, {Position = UDim2.fromOffset(3, 3)}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
              animation:Tween(glowFrame, {BackgroundTransparency = 1}, 0.2)
          end
      end
  
      btn.MouseButton1Click:Connect(function()
          self.Value = not self.Value
          updateVisual(self.Value)
          if config.Callback then
              pcall(config.Callback, self.Value)
          end
      end)
  
      btn.MouseEnter:Connect(function()
          animation:Tween(card, {BackgroundTransparency = 0.1}, 0.18)
      end)
      btn.MouseLeave:Connect(function()
          animation:Tween(card, {BackgroundTransparency = 0.3}, 0.18)
      end)
  
      function self:Set(val)
          self.Value = val
          updateVisual(val)
      end
  
      self.Instance = card
      return self
  end
  
  Toggle = Toggle
end

local Slider; do
  
  Slider = {}
  Slider.__index = Slider
  
  function Slider.new(parent, config, theme, animation, utils)
      local self = setmetatable({}, Slider)
      local T = theme.Current
      local min = config.Min or 0
      local max = config.Max or 100
      local increment = config.Increment or 1
      self.Value = config.Default or min
  
      local card = Instance.new("Frame")
      card.Size = UDim2.new(1, 0, 0, 64)
      card.BackgroundColor3 = T.Card
      card.BackgroundTransparency = 0.3
      card.BorderSizePixel = 0
      card.Parent = parent
      utils:Corner(card, 12)
      utils:Stroke(card, T.Border, 0.88, 1)
  
      local headerFrame = Instance.new("Frame")
      headerFrame.Size = UDim2.new(1, -24, 0, 24)
      headerFrame.Position = UDim2.fromOffset(14, 10)
      headerFrame.BackgroundTransparency = 1
      headerFrame.Parent = card
  
      local title = Instance.new("TextLabel")
      title.Text = config.Title or "Slider"
      title.TextSize = 13
      title.Font = Enum.Font.GothamMedium
      title.TextColor3 = T.Text
      title.BackgroundTransparency = 1
      title.Size = UDim2.new(0.7, 0, 1, 0)
      title.TextXAlignment = Enum.TextXAlignment.Left
      title.Parent = headerFrame
  
      local valueLabel = Instance.new("TextLabel")
      valueLabel.Text = tostring(self.Value)
      valueLabel.TextSize = 13
      valueLabel.Font = Enum.Font.GothamBold
      valueLabel.TextColor3 = T.Accent
      valueLabel.BackgroundTransparency = 1
      valueLabel.Size = UDim2.new(0.3, 0, 1, 0)
      valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
      valueLabel.TextXAlignment = Enum.TextXAlignment.Right
      valueLabel.Parent = headerFrame
  
      local trackBg = Instance.new("Frame")
      trackBg.Size = UDim2.new(1, -28, 0, 6)
      trackBg.Position = UDim2.new(0, 14, 0, 42)
      trackBg.BackgroundColor3 = Color3.fromRGB(50, 56, 72)
      trackBg.BorderSizePixel = 0
      trackBg.Parent = card
      utils:Corner(trackBg, 3)
  
      local pct = (self.Value - min) / (max - min)
      local trackFill = Instance.new("Frame")
      trackFill.Size = UDim2.new(pct, 0, 1, 0)
      trackFill.BackgroundColor3 = T.Accent
      trackFill.BorderSizePixel = 0
      trackFill.Parent = trackBg
      utils:Corner(trackFill, 3)
  
      local g = Instance.new("UIGradient")
      g.Color = ColorSequence.new({
          ColorSequenceKeypoint.new(0, T.Accent),
          ColorSequenceKeypoint.new(1, T.AccentSecondary)
      })
      g.Parent = trackFill
  
      local thumb = Instance.new("Frame")
      thumb.Size = UDim2.fromOffset(16, 16)
      thumb.Position = UDim2.new(pct, -8, 0.5, -8)
      thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
      thumb.BorderSizePixel = 0
      thumb.ZIndex = trackBg.ZIndex + 2
      thumb.Parent = trackBg
      utils:Corner(thumb, 8)
  
      local thumbGlow = Instance.new("Frame")
      thumbGlow.Size = UDim2.fromOffset(24, 24)
      thumbGlow.Position = UDim2.new(0.5, -12, 0.5, -12)
      thumbGlow.BackgroundColor3 = T.Accent
      thumbGlow.BackgroundTransparency = 0.65
      thumbGlow.BorderSizePixel = 0
      thumbGlow.ZIndex = thumb.ZIndex - 1
      thumbGlow.Parent = thumb
      utils:Corner(thumbGlow, 12)
  
      local dragging = false
  
      local function update(inputX)
          local trackAbs = trackBg.AbsolutePosition
          local trackSize = trackBg.AbsoluteSize
          local rel = math.clamp((inputX - trackAbs.X) / trackSize.X, 0, 1)
          local rawVal = min + rel * (max - min)
          local snapped = math.floor(rawVal / increment + 0.5) * increment
          snapped = math.clamp(snapped, min, max)
          if snapped ~= self.Value then
              self.Value = snapped
              local p = (snapped - min) / (max - min)
              animation:Quick(trackFill, {Size = UDim2.new(p, 0, 1, 0)}, 0.05)
              animation:Quick(thumb, {Position = UDim2.new(p, -8, 0.5, -8)}, 0.05)
              valueLabel.Text = tostring(snapped)
              if config.Callback then pcall(config.Callback, snapped) end
          end
      end
  
      trackBg.InputBegan:Connect(function(input)
          if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
              dragging = true
              update(input.Position.X)
          end
      end)
  
      UserInputService.InputChanged:Connect(function(input)
          if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
              update(input.Position.X)
          end
      end)
  
      UserInputService.InputEnded:Connect(function(input)
          if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
              dragging = false
          end
      end)
  
      function self:Set(val)
          self.Value = math.clamp(val, min, max)
          local p = (self.Value - min) / (max - min)
          trackFill.Size = UDim2.new(p, 0, 1, 0)
          thumb.Position = UDim2.new(p, -8, 0.5, -8)
          valueLabel.Text = tostring(self.Value)
      end
  
      self.Instance = card
      return self
  end
  
  Slider = Slider
end

local Dropdown; do
  
  Dropdown = {}
  Dropdown.__index = Dropdown
  
  function Dropdown.new(parent, config, theme, animation, utils)
      local self = setmetatable({}, Dropdown)
      local T = theme.Current
      self.Value = config.Default or (config.Options and config.Options[1]) or ""
      self.Open = false
      self.Options = config.Options or {}
  
      local card = Instance.new("Frame")
      card.Size = UDim2.new(1, 0, 0, 54)
      card.BackgroundColor3 = T.Card
      card.BackgroundTransparency = 0.3
      card.BorderSizePixel = 0
      card.ClipsDescendants = false
      card.ZIndex = 5
      card.Parent = parent
      utils:Corner(card, 12)
      utils:Stroke(card, T.Border, 0.88, 1)
  
      local headerFrame = Instance.new("Frame")
      headerFrame.Size = UDim2.new(1, -24, 1, 0)
      headerFrame.Position = UDim2.fromOffset(14, 0)
      headerFrame.BackgroundTransparency = 1
      headerFrame.ZIndex = card.ZIndex
      headerFrame.Parent = card
  
      local textBlock = Instance.new("Frame")
      textBlock.Size = UDim2.new(0.7, 0, 1, 0)
      textBlock.BackgroundTransparency = 1
      textBlock.ZIndex = card.ZIndex
      textBlock.Parent = headerFrame
  
      local title = Instance.new("TextLabel")
      title.Text = config.Title or "Dropdown"
      title.TextSize = 13
      title.Font = Enum.Font.GothamMedium
      title.TextColor3 = T.Text
      title.BackgroundTransparency = 1
      title.Size = UDim2.new(1, 0, 0, 18)
      title.Position = UDim2.new(0, 0, 0.5, config.Description and -12 or -9)
      title.TextXAlignment = Enum.TextXAlignment.Left
      title.ZIndex = card.ZIndex
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
          desc.ZIndex = card.ZIndex
          desc.Parent = textBlock
      end
  
      local valueDisplay = Instance.new("Frame")
      valueDisplay.Size = UDim2.fromOffset(110, 28)
      valueDisplay.Position = UDim2.new(1, -118, 0.5, -14)
      valueDisplay.BackgroundColor3 = T.Surface
      valueDisplay.BackgroundTransparency = 0.3
      valueDisplay.BorderSizePixel = 0
      valueDisplay.ZIndex = card.ZIndex
      valueDisplay.Parent = card
      utils:Corner(valueDisplay, 8)
      utils:Stroke(valueDisplay, T.Accent, 0.7, 1)
  
      local selectedLabel = Instance.new("TextLabel")
      selectedLabel.Text = self.Value
      selectedLabel.TextSize = 12
      selectedLabel.Font = Enum.Font.GothamMedium
      selectedLabel.TextColor3 = T.Accent
      selectedLabel.BackgroundTransparency = 1
      selectedLabel.Size = UDim2.new(1, -24, 1, 0)
      selectedLabel.Position = UDim2.fromOffset(8, 0)
      selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
      selectedLabel.ZIndex = card.ZIndex + 1
      selectedLabel.Parent = valueDisplay
  
      local arrow = Instance.new("TextLabel")
      arrow.Text = "▾"
      arrow.TextSize = 12
      arrow.Font = Enum.Font.GothamBold
      arrow.TextColor3 = T.Subtext
      arrow.BackgroundTransparency = 1
      arrow.Size = UDim2.fromOffset(18, 18)
      arrow.Position = UDim2.new(1, -20, 0.5, -9)
      arrow.TextXAlignment = Enum.TextXAlignment.Center
      arrow.ZIndex = card.ZIndex + 1
      arrow.Parent = valueDisplay
  
      local dropFrame = Instance.new("Frame")
      dropFrame.Size = UDim2.new(1, 0, 0, 0)
      dropFrame.Position = UDim2.new(0, 0, 1, 4)
      dropFrame.BackgroundColor3 = T.Surface
      dropFrame.BackgroundTransparency = 0.1
      dropFrame.BorderSizePixel = 0
      dropFrame.ClipsDescendants = true
      dropFrame.ZIndex = card.ZIndex + 3
      dropFrame.Visible = false
      dropFrame.Parent = card
      utils:Corner(dropFrame, 10)
      utils:Stroke(dropFrame, T.Border, 0.8, 1)
  
      local optionList = Instance.new("Frame")
      optionList.Size = UDim2.fromScale(1, 1)
      optionList.BackgroundTransparency = 1
      optionList.ZIndex = dropFrame.ZIndex
      optionList.Parent = dropFrame
      utils:ListLayout(optionList, Enum.FillDirection.Vertical, 0)
      utils:Padding(optionList, 4, 6, 4, 6)
  
      local function createOption(optText)
          local optBtn = Instance.new("TextButton")
          optBtn.Size = UDim2.new(1, 0, 0, 32)
          optBtn.BackgroundColor3 = T.Card
          optBtn.BackgroundTransparency = optText == self.Value and 0.2 or 1
          optBtn.BorderSizePixel = 0
          optBtn.Text = optText
          optBtn.TextSize = 13
          optBtn.Font = Enum.Font.GothamMedium
          optBtn.TextColor3 = optText == self.Value and T.Accent or T.Text
          optBtn.TextXAlignment = Enum.TextXAlignment.Left
          optBtn.AutoButtonColor = false
          optBtn.ZIndex = dropFrame.ZIndex + 1
          optBtn.Parent = optionList
          utils:Corner(optBtn, 8)
          utils:Padding(optBtn, 0, 0, 0, 8)
  
          optBtn.MouseEnter:Connect(function()
              animation:Quick(optBtn, {BackgroundTransparency = 0.3}, 0.12)
          end)
          optBtn.MouseLeave:Connect(function()
              animation:Quick(optBtn, {BackgroundTransparency = optText == self.Value and 0.2 or 1}, 0.12)
          end)
          optBtn.MouseButton1Click:Connect(function()
              self.Value = optText
              selectedLabel.Text = optText
              self:Close()
              if config.Callback then pcall(config.Callback, optText) end
          end)
      end
  
      for _, opt in ipairs(self.Options) do
          createOption(opt)
      end
  
      local targetH = #self.Options * 36 + 12
      if targetH > 180 then targetH = 180 end
  
      function self:Close()
          self.Open = false
          animation:Tween(arrow, {Rotation = 0}, 0.2)
          animation:Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
          task.delay(0.25, function()
              dropFrame.Visible = false
          end)
      end
  
      function self:OpenDrop()
          self.Open = true
          dropFrame.Visible = true
          dropFrame.Size = UDim2.new(1, 0, 0, 0)
          animation:Tween(arrow, {Rotation = 180}, 0.2)
          animation:Tween(dropFrame, {Size = UDim2.new(1, 0, 0, targetH)}, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
      end
  
      local mainBtn = Instance.new("TextButton")
      mainBtn.Size = UDim2.fromScale(1, 1)
      mainBtn.BackgroundTransparency = 1
      mainBtn.Text = ""
      mainBtn.AutoButtonColor = false
      mainBtn.ZIndex = card.ZIndex + 2
      mainBtn.Parent = card
  
      mainBtn.MouseButton1Click:Connect(function()
          if self.Open then
              self:Close()
          else
              self:OpenDrop()
          end
      end)
  
      mainBtn.MouseEnter:Connect(function()
          animation:Tween(card, {BackgroundTransparency = 0.1}, 0.18)
      end)
      mainBtn.MouseLeave:Connect(function()
          animation:Tween(card, {BackgroundTransparency = 0.3}, 0.18)
      end)
  
      function self:Set(val)
          self.Value = val
          selectedLabel.Text = val
      end
  
      self.Instance = card
      return self
  end
  
  Dropdown = Dropdown
end

local Keybind; do
  
  Keybind = {}
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
  
  Keybind = Keybind
end

local TextBox; do
  local TextBoxComp = {}
  TextBoxComp.__index = TextBoxComp
  
  function TextBoxComp.new(parent, config, theme, animation, utils)
      local self = setmetatable({}, TextBoxComp)
      local T = theme.Current
  
      local card = Instance.new("Frame")
      card.Size = UDim2.new(1, 0, 0, 64)
      card.BackgroundColor3 = T.Card
      card.BackgroundTransparency = 0.3
      card.BorderSizePixel = 0
      card.Parent = parent
      utils:Corner(card, 12)
      utils:Stroke(card, T.Border, 0.88, 1)
  
      local labelFrame = Instance.new("Frame")
      labelFrame.Size = UDim2.new(1, -24, 0, 22)
      labelFrame.Position = UDim2.fromOffset(14, 8)
      labelFrame.BackgroundTransparency = 1
      labelFrame.Parent = card
  
      local title = Instance.new("TextLabel")
      title.Text = config.Title or "TextBox"
      title.TextSize = 13
      title.Font = Enum.Font.GothamMedium
      title.TextColor3 = T.Text
      title.BackgroundTransparency = 1
      title.Size = UDim2.fromScale(1, 1)
      title.TextXAlignment = Enum.TextXAlignment.Left
      title.Parent = labelFrame
  
      local inputFrame = Instance.new("Frame")
      inputFrame.Size = UDim2.new(1, -24, 0, 30)
      inputFrame.Position = UDim2.new(0, 12, 0, 30)
      inputFrame.BackgroundColor3 = T.Surface
      inputFrame.BackgroundTransparency = 0.4
      inputFrame.BorderSizePixel = 0
      inputFrame.Parent = card
      utils:Corner(inputFrame, 8)
      utils:Stroke(inputFrame, T.Border, 0.8, 1)
  
      local textBox = Instance.new("TextBox")
      textBox.Size = UDim2.new(1, -16, 1, 0)
      textBox.Position = UDim2.fromOffset(8, 0)
      textBox.BackgroundTransparency = 1
      textBox.Text = ""
      textBox.PlaceholderText = config.Placeholder or "Enter text..."
      textBox.PlaceholderColor3 = T.Subtext
      textBox.TextColor3 = T.Text
      textBox.TextSize = 13
      textBox.Font = Enum.Font.Gotham
      textBox.TextXAlignment = Enum.TextXAlignment.Left
      textBox.ClearTextOnFocus = false
      textBox.Parent = inputFrame
  
      textBox.Focused:Connect(function()
          animation:Tween(inputFrame, {BackgroundTransparency = 0.2}, 0.2)
          animation:Stroke(inputFrame, T.Accent, 0.5, 1)
      end)
  
      textBox.FocusLost:Connect(function(enterPressed)
          animation:Tween(inputFrame, {BackgroundTransparency = 0.4}, 0.2)
          if config.Callback then
              pcall(config.Callback, textBox.Text)
          end
      end)
  
      function self:Set(text)
          textBox.Text = text
      end
  
      function self:Get()
          return textBox.Text
      end
  
      self.Instance = card
      return self
  end
  
  TextBox = TextBoxComp
end

local Notification; do
  
  Notification = {}
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
  
  Notification = Notification
end

local Section; do
  Section = {}
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
  
  Section = Section
end

local Tab; do
  Tab = {}
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
  
  Tab = Tab
end

local Window; do
  
  Window = {}
  Window.__index = Window
  
  function Window.new(config, theme, animation, utils, assets, effects, components, library)
      local self = setmetatable({}, Window)
      local T = theme.Current
      local isMobile = utils.IsMobile
  
      local gui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("AuroraUI_ScreenGui")
      if not gui then
          gui = Instance.new("ScreenGui")
          gui.Name = "AuroraUI_ScreenGui"
          gui.ResetOnSpawn = false
          gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
          gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
      end
  
      if config.Blur then
          local blur = Instance.new("BlurEffect")
          blur.Size = 8
          blur.Name = "_AuroraBlur"
          blur.Parent = game:GetService("Lighting")
          self._blur = blur
      end
  
      local windowSize = config.Size or UDim2.fromOffset(620, 430)
      if isMobile then
          local scale = config.MobileScale or 0.85
          windowSize = UDim2.fromOffset(windowSize.X.Offset * scale, windowSize.Y.Offset * scale)
      end
  
      local windowGroup = Instance.new("CanvasGroup")
      windowGroup.Size = windowSize
      windowGroup.Position = config.Position or UDim2.fromScale(0.5, 0.5)
      windowGroup.AnchorPoint = config.AnchorPoint or Vector2.new(0.5, 0.5)
      windowGroup.BackgroundTransparency = 1
      windowGroup.GroupTransparency = 0
      windowGroup.Parent = gui
  
      if config.Shadow ~= false then
          effects.Shadows:Apply(windowGroup, 16, Color3.fromRGB(0, 0, 0), 0.45)
      end
  
      local mainFrame = Instance.new("Frame")
      mainFrame.Size = UDim2.fromScale(1, 1)
      mainFrame.BackgroundColor3 = T.Background
      mainFrame.BorderSizePixel = 0
      mainFrame.ClipsDescendants = true
      mainFrame.Parent = windowGroup
      utils:Corner(mainFrame, 18)
      utils:Stroke(mainFrame, T.Border, 0.88, 1)
  
      if config.Noise ~= false then
          effects.Textures:ApplyNoise(mainFrame, 0.93)
      end
  
      if config.Acrylic ~= false then
          effects.Gradients:ApplySurface(mainFrame)
      end
  
      local bannerH = 0
      if config.Banner and config.Banner ~= "" and config.Banner ~= "rbxassetid://0" then
          bannerH = 80
          local bannerFrame = Instance.new("ImageLabel")
          bannerFrame.Name = "Banner"
          bannerFrame.Size = UDim2.new(1, 0, 0, bannerH)
          bannerFrame.Position = UDim2.fromScale(0, 0)
          bannerFrame.Image = config.Banner
          bannerFrame.BackgroundColor3 = Color3.fromRGB(20, 24, 34)
          bannerFrame.BackgroundTransparency = 0
          bannerFrame.BorderSizePixel = 0
          bannerFrame.ScaleType = Enum.ScaleType.Crop
          bannerFrame.ZIndex = 2
          bannerFrame.Parent = mainFrame
          local bannerOverlay = Instance.new("Frame")
          bannerOverlay.Size = UDim2.fromScale(1, 1)
          bannerOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
          bannerOverlay.BackgroundTransparency = 0.5
          bannerOverlay.BorderSizePixel = 0
          bannerOverlay.ZIndex = 3
          bannerOverlay.Parent = bannerFrame
      end
  
      local headerH = 52
      local headerFrame = Instance.new("Frame")
      headerFrame.Name = "Header"
      headerFrame.Size = UDim2.new(1, 0, 0, headerH)
      headerFrame.Position = UDim2.new(0, 0, 0, bannerH)
      headerFrame.BackgroundColor3 = T.Surface
      headerFrame.BackgroundTransparency = 0.2
      headerFrame.BorderSizePixel = 0
      headerFrame.ZIndex = 4
      headerFrame.Parent = mainFrame
  
      local headerSep = Instance.new("Frame")
      headerSep.Size = UDim2.new(1, 0, 0, 1)
      headerSep.Position = UDim2.new(0, 0, 1, -1)
      headerSep.BackgroundColor3 = T.Border
      headerSep.BackgroundTransparency = 0.85
      headerSep.BorderSizePixel = 0
      headerSep.ZIndex = 4
      headerSep.Parent = headerFrame
  
      local thumbSize = 0
      if config.Thumbnail and config.Thumbnail ~= "" and config.Thumbnail ~= "rbxassetid://0" then
          thumbSize = 36
          local thumbFrame = Instance.new("Frame")
          thumbFrame.Size = UDim2.fromOffset(36, 36)
          thumbFrame.Position = UDim2.new(0, 12, 0.5, -18)
          thumbFrame.BackgroundColor3 = T.Accent
          thumbFrame.BackgroundTransparency = 0.7
          thumbFrame.BorderSizePixel = 0
          thumbFrame.ZIndex = 5
          thumbFrame.Parent = headerFrame
          utils:Corner(thumbFrame, 10)
          local thumbImg = Instance.new("ImageLabel")
          thumbImg.Image = config.Thumbnail
          thumbImg.Size = UDim2.fromScale(1, 1)
          thumbImg.BackgroundTransparency = 1
          thumbImg.ScaleType = Enum.ScaleType.Crop
          thumbImg.ZIndex = 5
          thumbImg.Parent = thumbFrame
          utils:Corner(thumbImg, 10)
      end
  
      local titleX = 12 + (thumbSize > 0 and thumbSize + 8 or 0)
  
      local titleLabel = Instance.new("TextLabel")
      titleLabel.Text = config.Title or "AuroraUI"
      titleLabel.TextSize = 15
      titleLabel.Font = Enum.Font.GothamBold
      titleLabel.TextColor3 = T.Text
      titleLabel.BackgroundTransparency = 1
      titleLabel.Size = UDim2.new(1, -(titleX + 80), 0, 20)
      titleLabel.Position = UDim2.new(0, titleX, 0.5, config.Subtitle and -13 or -10)
      titleLabel.TextXAlignment = Enum.TextXAlignment.Left
      titleLabel.ZIndex = 5
      titleLabel.Parent = headerFrame
  
      if config.Subtitle then
          local subtitleLabel = Instance.new("TextLabel")
          subtitleLabel.Text = config.Subtitle
          subtitleLabel.TextSize = 11
          subtitleLabel.Font = Enum.Font.Gotham
          subtitleLabel.TextColor3 = T.Subtext
          subtitleLabel.BackgroundTransparency = 1
          subtitleLabel.Size = UDim2.new(1, -(titleX + 80), 0, 14)
          subtitleLabel.Position = UDim2.new(0, titleX, 0.5, 4)
          subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
          subtitleLabel.ZIndex = 5
          subtitleLabel.Parent = headerFrame
      end
  
      local btnX = -10
      if config.Closable ~= false then
          local closeBtn = Instance.new("TextButton")
          closeBtn.Size = UDim2.fromOffset(28, 28)
          closeBtn.Position = UDim2.new(1, btnX - 28, 0.5, -14)
          closeBtn.BackgroundColor3 = Color3.fromRGB(248, 113, 113)
          closeBtn.BackgroundTransparency = 0.3
          closeBtn.Text = "×"
          closeBtn.TextSize = 16
          closeBtn.Font = Enum.Font.GothamBold
          closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
          closeBtn.AutoButtonColor = false
          closeBtn.BorderSizePixel = 0
          closeBtn.ZIndex = 6
          closeBtn.Parent = headerFrame
          utils:Corner(closeBtn, 8)
          closeBtn.MouseButton1Click:Connect(function()
              self:Hide()
          end)
          closeBtn.MouseEnter:Connect(function()
              animation:Tween(closeBtn, {BackgroundTransparency = 0}, 0.15)
          end)
          closeBtn.MouseLeave:Connect(function()
              animation:Tween(closeBtn, {BackgroundTransparency = 0.3}, 0.15)
          end)
          btnX = btnX - 36
      end
  
      if config.Minimizable ~= false then
          local minBtn = Instance.new("TextButton")
          minBtn.Size = UDim2.fromOffset(28, 28)
          minBtn.Position = UDim2.new(1, btnX - 28, 0.5, -14)
          minBtn.BackgroundColor3 = Color3.fromRGB(251, 191, 36)
          minBtn.BackgroundTransparency = 0.3
          minBtn.Text = "−"
          minBtn.TextSize = 16
          minBtn.Font = Enum.Font.GothamBold
          minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
          minBtn.AutoButtonColor = false
          minBtn.BorderSizePixel = 0
          minBtn.ZIndex = 6
          minBtn.Parent = headerFrame
          utils:Corner(minBtn, 8)
          minBtn.MouseButton1Click:Connect(function()
              self:Minimize()
          end)
          minBtn.MouseEnter:Connect(function()
              animation:Tween(minBtn, {BackgroundTransparency = 0}, 0.15)
          end)
          minBtn.MouseLeave:Connect(function()
              animation:Tween(minBtn, {BackgroundTransparency = 0.3}, 0.15)
          end)
      end
  
      local sidebarW = 140
      local sidebarFrame = Instance.new("Frame")
      sidebarFrame.Name = "Sidebar"
      sidebarFrame.Size = UDim2.new(0, sidebarW, 1, -(headerH + bannerH + 28))
      sidebarFrame.Position = UDim2.new(0, 0, 0, headerH + bannerH)
      sidebarFrame.BackgroundColor3 = T.Surface
      sidebarFrame.BackgroundTransparency = 0.35
      sidebarFrame.BorderSizePixel = 0
      sidebarFrame.ZIndex = 3
      sidebarFrame.Parent = mainFrame
  
      local sidebarSep = Instance.new("Frame")
      sidebarSep.Size = UDim2.new(0, 1, 1, 0)
      sidebarSep.Position = UDim2.new(1, -1, 0, 0)
      sidebarSep.BackgroundColor3 = T.Border
      sidebarSep.BackgroundTransparency = 0.85
      sidebarSep.BorderSizePixel = 0
      sidebarSep.ZIndex = 4
      sidebarSep.Parent = sidebarFrame
  
      local sidebarScroll = Instance.new("ScrollingFrame")
      sidebarScroll.Size = UDim2.fromScale(1, 1)
      sidebarScroll.BackgroundTransparency = 1
      sidebarScroll.BorderSizePixel = 0
      sidebarScroll.ScrollBarThickness = 2
      sidebarScroll.ScrollBarImageColor3 = T.Accent
      sidebarScroll.ScrollBarImageTransparency = 0.6
      sidebarScroll.CanvasSize = UDim2.fromScale(0, 0)
      sidebarScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
      sidebarScroll.ZIndex = 4
      sidebarScroll.Parent = sidebarFrame
  
      local sidebarInner = Instance.new("Frame")
      sidebarInner.Size = UDim2.new(1, 0, 0, 0)
      sidebarInner.BackgroundTransparency = 1
      sidebarInner.AutomaticSize = Enum.AutomaticSize.Y
      sidebarInner.ZIndex = 4
      sidebarInner.Parent = sidebarScroll
      utils:ListLayout(sidebarInner, Enum.FillDirection.Vertical, 2)
      utils:Padding(sidebarInner, 8, 6, 8, 6)
  
      local contentArea = Instance.new("Frame")
      contentArea.Name = "ContentArea"
      contentArea.Size = UDim2.new(1, -sidebarW, 1, -(headerH + bannerH + 28))
      contentArea.Position = UDim2.new(0, sidebarW, 0, headerH + bannerH)
      contentArea.BackgroundTransparency = 1
      contentArea.ZIndex = 3
      contentArea.Parent = mainFrame
  
      utils:Padding(contentArea, 4, 8, 4, 8)
  
      local footerH = 28
      local footerFrame = Instance.new("Frame")
      footerFrame.Size = UDim2.new(1, 0, 0, footerH)
      footerFrame.Position = UDim2.new(0, 0, 1, -footerH)
      footerFrame.BackgroundColor3 = T.Surface
      footerFrame.BackgroundTransparency = 0.3
      footerFrame.BorderSizePixel = 0
      footerFrame.ZIndex = 4
      footerFrame.Parent = mainFrame
  
      local footerSep = Instance.new("Frame")
      footerSep.Size = UDim2.new(1, 0, 0, 1)
      footerSep.BackgroundColor3 = T.Border
      footerSep.BackgroundTransparency = 0.85
      footerSep.BorderSizePixel = 0
      footerSep.ZIndex = 4
      footerSep.Parent = footerFrame
  
      local footerLabel = Instance.new("TextLabel")
      footerLabel.Text = config.Footer or "AuroraUI • v1.0.0"
      footerLabel.TextSize = 10
      footerLabel.Font = Enum.Font.Gotham
      footerLabel.TextColor3 = T.Subtext
      footerLabel.BackgroundTransparency = 1
      footerLabel.Size = UDim2.fromScale(1, 1)
      footerLabel.TextXAlignment = Enum.TextXAlignment.Center
      footerLabel.ZIndex = 5
      footerLabel.Parent = footerFrame
  
      local pillBtn = Instance.new("TextButton")
      pillBtn.Name = "FloatingPill"
      pillBtn.Size = UDim2.fromOffset(160, 38)
      pillBtn.Position = UDim2.new(0.5, -80, 1, -60)
      pillBtn.BackgroundColor3 = T.Surface
      pillBtn.BackgroundTransparency = 0.05
      pillBtn.Text = ""
      pillBtn.AutoButtonColor = false
      pillBtn.BorderSizePixel = 0
      pillBtn.Visible = false
      pillBtn.ZIndex = 100
      pillBtn.Parent = gui
      utils:Corner(pillBtn, 19)
      utils:Stroke(pillBtn, T.Border, 0.75, 1)
      effects.Gradients:Apply(pillBtn, nil, 135)
  
      local pillLabel = Instance.new("TextLabel")
      pillLabel.Text = config.Title or "AuroraUI"
      pillLabel.TextSize = 13
      pillLabel.Font = Enum.Font.GothamBold
      pillLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
      pillLabel.BackgroundTransparency = 1
      pillLabel.Size = UDim2.fromScale(1, 1)
      pillLabel.TextXAlignment = Enum.TextXAlignment.Center
      pillLabel.ZIndex = 101
      pillLabel.Parent = pillBtn
  
      pillBtn.MouseButton1Click:Connect(function()
          self:Show()
      end)
  
      if config.Draggable ~= false and not isMobile then
          utils:MakeDraggable(windowGroup, headerFrame)
      end
  
      self._gui = gui
      self._group = windowGroup
      self._main = mainFrame
      self._sidebar = sidebarInner
      self._content = contentArea
      self._pill = pillBtn
      self._tabs = {}
      self._groups = {}
      self._activeTab = nil
      self._theme = theme
      self._animation = animation
      self._utils = utils
      self._components = components
      self._windowSize = windowSize
      self._config = config
      self._visible = true
  
      if config.ToggleKey then
          UserInputService.InputBegan:Connect(function(input, gp)
              if gp then return end
              if input.KeyCode == config.ToggleKey then
                  if self._visible then
                      self:Hide()
                  else
                      self:Show()
                  end
              end
          end)
      end
  
      if config.MinimizeKey then
          UserInputService.InputBegan:Connect(function(input, gp)
              if gp then return end
              if input.KeyCode == config.MinimizeKey then
                  if self._visible then
                      self:Minimize()
                  end
              end
          end)
      end
  
      animation:WindowOpen(windowGroup)
  
      return self
  end
  
  function Window:CreateTab(config)
      local T = self._theme.Current
      local tab = self._components.Tab.new(config, self._theme, self._animation, self._utils, self._components)
      tab.Frame.Parent = self._content
  
      local groupName = config.Group or "General"
      if not self._groups[groupName] then
          local groupLabel = Instance.new("TextLabel")
          groupLabel.Text = string.upper(groupName)
          groupLabel.TextSize = 9
          groupLabel.Font = Enum.Font.GothamBold
          groupLabel.TextColor3 = T.Subtext
          groupLabel.BackgroundTransparency = 1
          groupLabel.Size = UDim2.new(1, 0, 0, 18)
          groupLabel.TextXAlignment = Enum.TextXAlignment.Left
          groupLabel.LetterSpacingPx = 2
          groupLabel.ZIndex = 5
          groupLabel.Parent = self._sidebar
          utils:Padding(groupLabel, 0, 0, 0, 4)
          self._groups[groupName] = true
      end
  
      local tabBtn = Instance.new("TextButton")
      tabBtn.Size = UDim2.new(1, 0, 0, 34)
      tabBtn.BackgroundColor3 = T.Card
      tabBtn.BackgroundTransparency = 1
      tabBtn.Text = ""
      tabBtn.AutoButtonColor = false
      tabBtn.BorderSizePixel = 0
      tabBtn.ZIndex = 5
      tabBtn.Parent = self._sidebar
      self._utils:Corner(tabBtn, 10)
  
      local tabInner = Instance.new("Frame")
      tabInner.Size = UDim2.fromScale(1, 1)
      tabInner.BackgroundTransparency = 1
      tabInner.ZIndex = 5
      tabInner.Parent = tabBtn
      self._utils:ListLayout(tabInner, Enum.FillDirection.Horizontal, 8)
      self._utils:Padding(tabInner, 0, 0, 0, 10)
  
      local tabIconFrame = Instance.new("Frame")
      tabIconFrame.Size = UDim2.fromOffset(22, 22)
      tabIconFrame.BackgroundColor3 = T.Accent
      tabIconFrame.BackgroundTransparency = 0.8
      tabIconFrame.BorderSizePixel = 0
      tabIconFrame.LayoutOrder = 1
      tabIconFrame.ZIndex = 6
      tabIconFrame.Parent = tabInner
      self._utils:Corner(tabIconFrame, 6)
  
      if config.Icon then
          local iconImg = Instance.new("ImageLabel")
          iconImg.Image = config.Icon
          iconImg.Size = UDim2.fromOffset(14, 14)
          iconImg.Position = UDim2.fromScale(0.5, 0.5)
          iconImg.AnchorPoint = Vector2.new(0.5, 0.5)
          iconImg.BackgroundTransparency = 1
          iconImg.ImageColor3 = T.Accent
          iconImg.ZIndex = 7
          iconImg.Parent = tabIconFrame
      else
          local dot = Instance.new("Frame")
          dot.Size = UDim2.fromOffset(6, 6)
          dot.Position = UDim2.fromScale(0.5, 0.5)
          dot.AnchorPoint = Vector2.new(0.5, 0.5)
          dot.BackgroundColor3 = T.Accent
          dot.BorderSizePixel = 0
          dot.ZIndex = 7
          dot.Parent = tabIconFrame
          self._utils:Corner(dot, 3)
      end
  
      local tabLabelText = Instance.new("TextLabel")
      tabLabelText.Text = config.Name or "Tab"
      tabLabelText.TextSize = 13
      tabLabelText.Font = Enum.Font.GothamMedium
      tabLabelText.TextColor3 = T.Subtext
      tabLabelText.BackgroundTransparency = 1
      tabLabelText.Size = UDim2.new(1, -40, 1, 0)
      tabLabelText.TextXAlignment = Enum.TextXAlignment.Left
      tabLabelText.LayoutOrder = 2
      tabLabelText.ZIndex = 6
      tabLabelText.Parent = tabInner
  
      local indicator = Instance.new("Frame")
      indicator.Size = UDim2.new(0, 3, 0.6, 0)
      indicator.Position = UDim2.new(0, 0, 0.2, 0)
      indicator.BackgroundColor3 = T.Accent
      indicator.BackgroundTransparency = 1
      indicator.BorderSizePixel = 0
      indicator.ZIndex = 6
      indicator.Parent = tabBtn
      self._utils:Corner(indicator, 2)
  
      local function activateTab()
          if self._activeTab then
              self._activeTab.tab:Hide()
              self._animation:Tween(self._activeTab.btn, {BackgroundTransparency = 1}, 0.2)
              self._animation:Tween(self._activeTab.label, {TextColor3 = T.Subtext, TextSize = 13}, 0.2)
              self._animation:Tween(self._activeTab.indicator, {BackgroundTransparency = 1}, 0.2)
              self._animation:Tween(self._activeTab.iconFrame, {BackgroundTransparency = 0.8}, 0.2)
          end
          self._activeTab = {tab = tab, btn = tabBtn, label = tabLabelText, indicator = indicator, iconFrame = tabIconFrame}
          tab:Show(true)
          self._animation:Tween(tabBtn, {BackgroundTransparency = 0.6}, 0.2)
          self._animation:Tween(tabLabelText, {TextColor3 = T.Text, TextSize = 13}, 0.2)
          self._animation:Tween(indicator, {BackgroundTransparency = 0}, 0.2)
          self._animation:Tween(tabIconFrame, {BackgroundTransparency = 0.4}, 0.2)
      end
  
      tabBtn.MouseButton1Click:Connect(activateTab)
  
      tabBtn.MouseEnter:Connect(function()
          if self._activeTab and self._activeTab.btn == tabBtn then return end
          self._animation:Tween(tabBtn, {BackgroundTransparency = 0.8}, 0.15)
      end)
      tabBtn.MouseLeave:Connect(function()
          if self._activeTab and self._activeTab.btn == tabBtn then return end
          self._animation:Tween(tabBtn, {BackgroundTransparency = 1}, 0.15)
      end)
  
      table.insert(self._tabs, {tab = tab, btn = tabBtn, activate = activateTab})
      if #self._tabs == 1 then
          activateTab()
      end
  
      return tab
  end
  
  function Window:Hide()
      self._visible = false
      self._animation:WindowClose(self._group, function()
          self._group.Visible = false
          self._pill.Visible = true
          self._animation:Tween(self._pill, {BackgroundTransparency = 0.05}, 0.3)
      end)
  end
  
  function Window:Show()
      self._group.Visible = true
      self._pill.Visible = false
      self._visible = true
      self._animation:WindowOpen(self._group)
  end
  
  function Window:Minimize()
      self._visible = false
      local origSize = self._group.Size
      self._animation:Tween(self._group, {
          Size = UDim2.fromOffset(160, 38),
          Position = UDim2.new(0.5, -80, 1, -60),
          GroupTransparency = 0
      }, 0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
      task.delay(0.42, function()
          self._group.Visible = false
          self._group.Size = origSize
          self._group.Position = self._config.Position or UDim2.fromScale(0.5, 0.5)
          self._pill.Visible = true
      end)
  end
  
  function Window:Destroy()
      if self._blur then
          self._blur:Destroy()
      end
      self._group:Destroy()
      self._pill:Destroy()
  end
  
  Window = Window
end

local Effects = {
  Gradients = Gradients,
  Textures = Textures,
  Shadows = Shadows,
  Ripple = Ripple,
}

local Components = {
  Window = Window,
  Tab = Tab,
  Section = Section,
  Button = Button,
  Toggle = Toggle,
  Slider = Slider,
  Dropdown = Dropdown,
  Keybind = Keybind,
  Notification = Notification,
  TextBox = TextBox,
  Separator = Separator,
  Ripple = Ripple,
}

local AuroraUI = {}
AuroraUI.__index = AuroraUI

function AuroraUI:CreateWindow(config)
  return Window.new(config, Theme, Animation, Utils, Assets, Effects, Components, self)
end

function AuroraUI:Notify(config)
  local gui = Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("AuroraUI_ScreenGui")
  if not gui then
    gui = Instance.new("ScreenGui")
    gui.Name = "AuroraUI_ScreenGui"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
  end
  Notification:Show(config, gui)
end

function AuroraUI:SetTheme(config)
  Theme:Apply(config)
end

function AuroraUI:UseTheme(name)
  Theme:UsePreset(name)
end

function AuroraUI:GetTheme()
  return Theme.Current
end

return AuroraUI
