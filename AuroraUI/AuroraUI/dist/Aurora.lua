local TweenService    = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")

local Aurora = {}
Aurora.__index = Aurora

local _Theme = {
	Background      = Color3.fromRGB(10, 12, 18),
	Surface         = Color3.fromRGB(18, 22, 32),
	Card            = Color3.fromRGB(26, 31, 44),
	CardHover       = Color3.fromRGB(34, 40, 56),
	Accent          = Color3.fromRGB(124, 92, 255),
	AccentDim       = Color3.fromRGB(80, 58, 180),
	AccentSecondary = Color3.fromRGB(0, 210, 255),
	Text            = Color3.fromRGB(240, 244, 255),
	Subtext         = Color3.fromRGB(140, 150, 170),
	Muted           = Color3.fromRGB(80, 90, 110),
	Border          = Color3.fromRGB(255, 255, 255),
	Success         = Color3.fromRGB(52, 211, 153),
	Warning         = Color3.fromRGB(251, 191, 36),
	Error           = Color3.fromRGB(248, 113, 113),
	Info            = Color3.fromRGB(0, 210, 255),
}

local _Presets = {
	Dark = {
		Background      = Color3.fromRGB(10, 12, 18),
		Surface         = Color3.fromRGB(18, 22, 32),
		Card            = Color3.fromRGB(26, 31, 44),
		CardHover       = Color3.fromRGB(34, 40, 56),
		Accent          = Color3.fromRGB(124, 92, 255),
		AccentDim       = Color3.fromRGB(80, 58, 180),
		AccentSecondary = Color3.fromRGB(0, 210, 255),
		Text            = Color3.fromRGB(240, 244, 255),
		Subtext         = Color3.fromRGB(140, 150, 170),
		Muted           = Color3.fromRGB(80, 90, 110),
		Border          = Color3.fromRGB(255, 255, 255),
		Success         = Color3.fromRGB(52, 211, 153),
		Warning         = Color3.fromRGB(251, 191, 36),
		Error           = Color3.fromRGB(248, 113, 113),
		Info            = Color3.fromRGB(0, 210, 255),
	},
	Light = {
		Background      = Color3.fromRGB(238, 241, 248),
		Surface         = Color3.fromRGB(255, 255, 255),
		Card            = Color3.fromRGB(224, 228, 240),
		CardHover       = Color3.fromRGB(210, 215, 230),
		Accent          = Color3.fromRGB(110, 78, 240),
		AccentDim       = Color3.fromRGB(80, 55, 180),
		AccentSecondary = Color3.fromRGB(0, 160, 210),
		Text            = Color3.fromRGB(14, 17, 26),
		Subtext         = Color3.fromRGB(80, 90, 110),
		Muted           = Color3.fromRGB(160, 170, 190),
		Border          = Color3.fromRGB(0, 0, 0),
		Success         = Color3.fromRGB(34, 170, 100),
		Warning         = Color3.fromRGB(200, 140, 10),
		Error           = Color3.fromRGB(210, 60, 60),
		Info            = Color3.fromRGB(0, 130, 180),
	},
}

local function tw(obj, props, t, style, dir)
	TweenService:Create(obj,
		TweenInfo.new(t or 0.25, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
		props
	):Play()
end

local function spring(obj, props, t)
	tw(obj, props, t or 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

local function mk(cls, props)
	local o = Instance.new(cls)
	for k, v in pairs(props or {}) do
		if k ~= "Parent" and k ~= "Children" then
			pcall(function() o[k] = v end)
		end
	end
	if props and props.Children then
		for _, c in ipairs(props.Children) do c.Parent = o end
	end
	if props and props.Parent then o.Parent = props.Parent end
	return o
end

local function corner(p, r)
	return mk("UICorner", {CornerRadius = UDim.new(0, r or 12), Parent = p})
end

local function stroke(p, c, tr, th)
	return mk("UIStroke", {
		Color = c or Color3.new(1,1,1),
		Transparency = tr or 0.85,
		Thickness = th or 1,
		Parent = p
	})
end

local function pad(p, t, r, b, l)
	return mk("UIPadding", {
		PaddingTop    = UDim.new(0, t or 8),
		PaddingRight  = UDim.new(0, r or 8),
		PaddingBottom = UDim.new(0, b or 8),
		PaddingLeft   = UDim.new(0, l or 8),
		Parent = p
	})
end

local function list(p, dir, sp, ha, va)
	return mk("UIListLayout", {
		FillDirection      = dir or Enum.FillDirection.Vertical,
		Padding            = UDim.new(0, sp or 6),
		HorizontalAlignment = ha or Enum.HorizontalAlignment.Left,
		VerticalAlignment  = va or Enum.VerticalAlignment.Top,
		SortOrder          = Enum.SortOrder.LayoutOrder,
		Parent = p
	})
end

local function gradient(p, seq, rot)
	return mk("UIGradient", {
		Color    = seq or ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(124,92,255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(0,210,255)),
		}),
		Rotation = rot or 135,
		Parent   = p,
	})
end

local function makeDraggable(frame, handle)
	local dragging, start, startPos = false, nil, nil
	handle = handle or frame
	handle.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1
			or i.UserInputType == Enum.UserInputType.Touch then
			dragging  = true
			start     = i.Position
			startPos  = frame.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if dragging and (
			i.UserInputType == Enum.UserInputType.MouseMovement or
			i.UserInputType == Enum.UserInputType.Touch
		) then
			local d = i.Position - start
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + d.X,
				startPos.Y.Scale, startPos.Y.Offset + d.Y
			)
		end
	end)
end

local function ripple(btn, px, py)
	local T = _Theme
	local r = mk("Frame", {
		Size = UDim2.fromOffset(0,0),
		Position = UDim2.fromOffset(px, py),
		AnchorPoint = Vector2.new(0.5,0.5),
		BackgroundColor3 = T.Accent,
		BackgroundTransparency = 0.6,
		BorderSizePixel = 0,
		ZIndex = btn.ZIndex + 5,
		Parent = btn,
	})
	corner(r, 999)
	local sz = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 2.2
	tw(r, {Size = UDim2.fromOffset(sz,sz), BackgroundTransparency = 1}, 0.55, Enum.EasingStyle.Quad)
	game:GetService("Debris"):AddItem(r, 0.6)
end

local function attachRipple(btn)
	btn.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1
			or i.UserInputType == Enum.UserInputType.Touch then
			local abs = btn.AbsolutePosition
			ripple(btn, i.Position.X - abs.X, i.Position.Y - abs.Y)
		end
	end)
end

local _gui = nil
local function getGui()
	if _gui and _gui.Parent then return _gui end
	local lp = Players.LocalPlayer
	local pg = lp:WaitForChild("PlayerGui")
	local g  = pg:FindFirstChild("_AuroraUI")
	if not g then
		g = mk("ScreenGui", {
			Name            = "_AuroraUI",
			ResetOnSpawn    = false,
			ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
			IgnoreGuiInset  = false,
			Parent          = pg,
		})
	end
	_gui = g
	return g
end

local _notifContainer = nil
local function getNotifContainer()
	local g = getGui()
	if _notifContainer and _notifContainer.Parent == g then return _notifContainer end
	local c = mk("Frame", {
		Name = "_Notifs",
		Size = UDim2.fromOffset(300, 0),
		Position = UDim2.new(1, -310, 0, 16),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = g,
	})
	list(c, Enum.FillDirection.Vertical, 8, Enum.HorizontalAlignment.Right)
	_notifContainer = c
	return c
end

local NOTIF_ICONS = {
	Success = "✓", Warning = "!", Error = "✕", Info = "i", Default = "★"
}
local NOTIF_COLORS = {
	Success = Color3.fromRGB(52,211,153),
	Warning = Color3.fromRGB(251,191,36),
	Error   = Color3.fromRGB(248,113,113),
	Info    = Color3.fromRGB(0,210,255),
	Default = Color3.fromRGB(124,92,255),
}

function Aurora:Notify(cfg)
	local T    = _Theme
	local c    = getNotifContainer()
	local col  = NOTIF_COLORS[cfg.Type] or NOTIF_COLORS.Default
	local icon = NOTIF_ICONS[cfg.Type] or NOTIF_ICONS.Default
	local dur  = cfg.Duration or 4

	local card = mk("Frame", {
		Size = UDim2.fromOffset(290, 66),
		BackgroundColor3 = T.Surface,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = UDim2.fromOffset(310, 0),
		Parent = c,
	})
	corner(card, 14)
	stroke(card, col, 0.55, 1)

	mk("Frame", {
		Size = UDim2.new(0,4,1,0),
		BackgroundColor3 = col,
		BorderSizePixel = 0,
		Parent = card,
		Children = {(function() local u = Instance.new("UICorner") u.CornerRadius = UDim.new(0,4) return u end)()},
	})

	local ic = mk("Frame", {
		Size = UDim2.fromOffset(30,30),
		Position = UDim2.new(0,12,0.5,-15),
		BackgroundColor3 = col,
		BackgroundTransparency = 0.75,
		BorderSizePixel = 0,
		Parent = card,
	})
	corner(ic, 9)
	mk("TextLabel", {
		Text = icon, TextSize = 14, Font = Enum.Font.GothamBold,
		TextColor3 = col, BackgroundTransparency = 1,
		Size = UDim2.fromScale(1,1), TextXAlignment = Enum.TextXAlignment.Center,
		Parent = ic,
	})

	local tf = mk("Frame", {
		Size = UDim2.new(1,-54,1,0),
		Position = UDim2.fromOffset(50,0),
		BackgroundTransparency = 1,
		Parent = card,
	})
	mk("TextLabel", {
		Text = cfg.Title or "Notification",
		TextSize = 13, Font = Enum.Font.GothamBold,
		TextColor3 = T.Text, BackgroundTransparency = 1,
		Size = UDim2.new(1,0,0,20),
		Position = UDim2.new(0,0,0.5,-20),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = tf,
	})
	mk("TextLabel", {
		Text = cfg.Content or "",
		TextSize = 11, Font = Enum.Font.Gotham,
		TextColor3 = T.Subtext, BackgroundTransparency = 1,
		Size = UDim2.new(1,0,0,15),
		Position = UDim2.new(0,0,0.5,2),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		Parent = tf,
	})

	local bar = mk("Frame", {
		Size = UDim2.new(1,0,0,2),
		Position = UDim2.new(0,0,1,-2),
		BackgroundColor3 = col,
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
		Parent = card,
	})

	tw(card, {Position = UDim2.fromOffset(0,0)}, 0.4, Enum.EasingStyle.Back)
	tw(bar, {Size = UDim2.new(0,0,0,2)}, dur, Enum.EasingStyle.Linear)

	task.delay(dur, function()
		tw(card, {Position = UDim2.fromOffset(310,0), BackgroundTransparency = 1}, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
		task.delay(0.35, function() card:Destroy() end)
	end)
end

function Aurora:SetTheme(cfg)
	for k,v in pairs(cfg) do _Theme[k] = v end
end

function Aurora:UseTheme(name)
	if _Presets[name] then
		for k,v in pairs(_Presets[name]) do _Theme[k] = v end
	end
end

function Aurora:GetTheme()
	return _Theme
end

function Aurora:CreateWindow(cfg)
	local T  = _Theme
	local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
	local g  = getGui()

	local W = 620
	local H = 440
	if isMobile then
		W = math.floor(W * (cfg.MobileScale or 0.88))
		H = math.floor(H * (cfg.MobileScale or 0.88))
	end

	local win = {}
	win._tabs       = {}
	win._activeTab  = nil
	win._visible    = true
	win._cfg        = cfg

	local HEADER_H = 52
	local SIDEBAR_W = 148
	local FOOTER_H  = 26

	local mainFrame = mk("Frame", {
		Name             = "AuroraWindow",
		Size             = UDim2.fromOffset(W, H),
		Position         = cfg.Position or UDim2.fromScale(0.5, 0.5),
		AnchorPoint      = cfg.AnchorPoint or Vector2.new(0.5, 0.5),
		BackgroundColor3 = T.Background,
		BorderSizePixel  = 0,
		ClipsDescendants = true,
		Parent           = g,
	})
	corner(mainFrame, 16)
	stroke(mainFrame, T.Border, 0.82, 1)

	mk("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(26,30,44)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(10,12,18)),
		}),
		Rotation = 110,
		Parent   = mainFrame,
	})

	mk("ImageLabel", {
		Name   = "_noise",
		Image  = "rbxassetid://6580542979",
		Size   = UDim2.fromScale(1,1),
		BackgroundTransparency = 1,
		ImageTransparency = 0.94,
		ScaleType = Enum.ScaleType.Tile,
		TileSize  = UDim2.fromOffset(128,128),
		ZIndex    = 2,
		Parent    = mainFrame,
	})

	local shadow = mk("Frame", {
		Name   = "_shadow",
		Size   = UDim2.new(1,28,1,28),
		Position = UDim2.new(0,-14,0,8),
		BackgroundColor3 = Color3.fromRGB(0,0,0),
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		ZIndex = mainFrame.ZIndex - 1,
		Parent = g,
	})
	corner(shadow, 20)
	mk("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.35),
			NumberSequenceKeypoint.new(0.6, 0.65),
			NumberSequenceKeypoint.new(1, 1),
		}),
		Rotation = 90,
		Parent   = shadow,
	})

	local header = mk("Frame", {
		Name             = "Header",
		Size             = UDim2.new(1,0,0,HEADER_H),
		Position         = UDim2.fromOffset(0,0),
		BackgroundColor3 = T.Surface,
		BackgroundTransparency = 0.15,
		BorderSizePixel  = 0,
		ZIndex           = 4,
		Parent           = mainFrame,
	})

	mk("Frame", {
		Size = UDim2.new(1,0,0,1),
		Position = UDim2.new(0,0,1,-1),
		BackgroundColor3 = T.Border,
		BackgroundTransparency = 0.82,
		BorderSizePixel = 0,
		ZIndex = 4,
		Parent = header,
	})

	local titleX = 14
	if cfg.Thumbnail and cfg.Thumbnail ~= "" and cfg.Thumbnail ~= "rbxassetid://0" then
		local tb = mk("Frame", {
			Size = UDim2.fromOffset(34,34),
			Position = UDim2.new(0,12,0.5,-17),
			BackgroundColor3 = T.Accent,
			BackgroundTransparency = 0.6,
			BorderSizePixel = 0,
			ZIndex = 5,
			Parent = header,
		})
		corner(tb, 10)
		mk("ImageLabel", {
			Image = cfg.Thumbnail,
			Size = UDim2.fromScale(1,1),
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Crop,
			ZIndex = 5,
			Parent = tb,
		})
		corner(tb, 10)
		titleX = 56
	end

	mk("TextLabel", {
		Text = cfg.Title or "AuroraUI",
		TextSize = 15, Font = Enum.Font.GothamBold,
		TextColor3 = T.Text, BackgroundTransparency = 1,
		Size = UDim2.new(1, -(titleX+90), 0, 20),
		Position = UDim2.new(0, titleX, 0, cfg.Subtitle and 8 or 16),
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 5, Parent = header,
	})

	if cfg.Subtitle then
		mk("TextLabel", {
			Text = cfg.Subtitle,
			TextSize = 11, Font = Enum.Font.Gotham,
			TextColor3 = T.Subtext, BackgroundTransparency = 1,
			Size = UDim2.new(1,-(titleX+90),0,14),
			Position = UDim2.new(0,titleX,0,29),
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 5, Parent = header,
		})
	end

	local btnOX = -8
	local function winBtn(label, col)
		local b = mk("TextButton", {
			Size = UDim2.fromOffset(26,26),
			Position = UDim2.new(1, btnOX-26, 0.5, -13),
			BackgroundColor3 = col,
			BackgroundTransparency = 0.2,
			Text = label, TextSize = 14,
			Font = Enum.Font.GothamBold,
			TextColor3 = Color3.new(1,1,1),
			AutoButtonColor = false,
			BorderSizePixel = 0,
			ZIndex = 6, Parent = header,
		})
		corner(b, 8)
		b.MouseEnter:Connect(function() tw(b, {BackgroundTransparency = 0}, 0.12) end)
		b.MouseLeave:Connect(function() tw(b, {BackgroundTransparency = 0.2}, 0.12) end)
		btnOX = btnOX - 32
		return b
	end

	local closeBtn, minBtn
	if cfg.Closable ~= false then
		closeBtn = winBtn("×", T.Error)
	end
	if cfg.Minimizable ~= false then
		minBtn = winBtn("−", T.Warning)
	end

	local sidebar = mk("Frame", {
		Name             = "Sidebar",
		Size             = UDim2.new(0, SIDEBAR_W, 1, -(HEADER_H + FOOTER_H)),
		Position         = UDim2.new(0, 0, 0, HEADER_H),
		BackgroundColor3 = T.Surface,
		BackgroundTransparency = 0.3,
		BorderSizePixel  = 0,
		ZIndex           = 3,
		Parent           = mainFrame,
	})

	mk("Frame", {
		Size = UDim2.new(0,1,1,0),
		Position = UDim2.new(1,-1,0,0),
		BackgroundColor3 = T.Border,
		BackgroundTransparency = 0.84,
		BorderSizePixel = 0,
		ZIndex = 4,
		Parent = sidebar,
	})

	local sideScroll = mk("ScrollingFrame", {
		Size = UDim2.fromScale(1,1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		CanvasSize = UDim2.fromScale(0,0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ZIndex = 4,
		Parent = sidebar,
	})

	local sideInner = mk("Frame", {
		Size = UDim2.new(1,0,0,0),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 4,
		Parent = sideScroll,
	})
	list(sideInner, Enum.FillDirection.Vertical, 2)
	pad(sideInner, 8, 6, 8, 6)

	local contentArea = mk("Frame", {
		Name             = "Content",
		Size             = UDim2.new(1, -SIDEBAR_W, 1, -(HEADER_H + FOOTER_H)),
		Position         = UDim2.new(0, SIDEBAR_W, 0, HEADER_H),
		BackgroundTransparency = 1,
		BorderSizePixel  = 0,
		ZIndex           = 3,
		Parent           = mainFrame,
	})

	local footer = mk("Frame", {
		Name             = "Footer",
		Size             = UDim2.new(1,0,0,FOOTER_H),
		Position         = UDim2.new(0,0,1,-FOOTER_H),
		BackgroundColor3 = T.Surface,
		BackgroundTransparency = 0.2,
		BorderSizePixel  = 0,
		ZIndex           = 4,
		Parent           = mainFrame,
	})
	mk("Frame", {
		Size = UDim2.new(1,0,0,1),
		BackgroundColor3 = T.Border, BackgroundTransparency = 0.84,
		BorderSizePixel = 0, ZIndex = 4, Parent = footer,
	})
	mk("TextLabel", {
		Text = cfg.Footer or "AuroraUI v1.0.0",
		TextSize = 10, Font = Enum.Font.Gotham,
		TextColor3 = T.Muted, BackgroundTransparency = 1,
		Size = UDim2.fromScale(1,1),
		TextXAlignment = Enum.TextXAlignment.Center,
		ZIndex = 5, Parent = footer,
	})

	local pill = mk("TextButton", {
		Name = "_Pill",
		Size = UDim2.fromOffset(0, 36),
		Position = UDim2.new(0.5, 0, 1, -54),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundColor3 = T.Surface,
		BackgroundTransparency = 0,
		Text = "", AutoButtonColor = false,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Visible = false,
		ZIndex = 50,
		Parent = g,
	})
	corner(pill, 18)
	stroke(pill, T.Accent, 0.55, 1)
	gradient(pill, ColorSequence.new({
		ColorSequenceKeypoint.new(0, T.Accent),
		ColorSequenceKeypoint.new(1, T.AccentSecondary),
	}), 135)

	local pillLabel = mk("TextLabel", {
		Text = cfg.Title or "AuroraUI",
		TextSize = 13, Font = Enum.Font.GothamBold,
		TextColor3 = Color3.new(1,1,1),
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1,1),
		TextXAlignment = Enum.TextXAlignment.Center,
		ZIndex = 51, Parent = pill,
	})

	local function syncShadow()
		if mainFrame.Visible then
			shadow.Size     = UDim2.new(0, mainFrame.AbsoluteSize.X+28, 0, mainFrame.AbsoluteSize.Y+28)
			shadow.Position = UDim2.new(0, mainFrame.AbsolutePosition.X-14, 0, mainFrame.AbsolutePosition.Y+8)
		end
	end

	local _groups = {}

	local function addGroupLabel(name)
		if _groups[name] then return end
		_groups[name] = true
		local lbl = mk("TextLabel", {
			Text = string.upper(name),
			TextSize = 9, Font = Enum.Font.GothamBold,
			TextColor3 = T.Muted,
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,20),
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 5, Parent = sideInner,
		})
		pad(lbl, 0,0,0,8)
	end

	function win:CreateTab(tabCfg)
		local group = tabCfg.Group or "General"
		addGroupLabel(group)

		local tabFrame = mk("ScrollingFrame", {
			Size = UDim2.fromScale(1,1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = T.Accent,
			ScrollBarImageTransparency = 0.35,
			CanvasSize = UDim2.fromScale(0,0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Visible = false,
			ZIndex = 4,
			Parent = contentArea,
		})

		local inner = mk("Frame", {
			Size = UDim2.new(1,-16,0,0),
			Position = UDim2.fromOffset(8,8),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			ZIndex = 4,
			Parent = tabFrame,
		})
		list(inner, Enum.FillDirection.Vertical, 10)

		local tabBtn = mk("TextButton", {
			Size = UDim2.new(1,0,0,34),
			BackgroundColor3 = T.Card,
			BackgroundTransparency = 1,
			Text = "", AutoButtonColor = false,
			BorderSizePixel = 0,
			ZIndex = 5, Parent = sideInner,
		})
		corner(tabBtn, 10)

		local indicator = mk("Frame", {
			Size = UDim2.new(0,3,0.55,0),
			Position = UDim2.new(0,0,0.225,0),
			BackgroundColor3 = T.Accent,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 6, Parent = tabBtn,
		})
		corner(indicator, 2)

		local dotFrame = mk("Frame", {
			Size = UDim2.fromOffset(20,20),
			Position = UDim2.new(0,8,0.5,-10),
			BackgroundColor3 = T.Accent,
			BackgroundTransparency = 0.8,
			BorderSizePixel = 0,
			ZIndex = 6, Parent = tabBtn,
		})
		corner(dotFrame, 6)
		mk("Frame", {
			Size = UDim2.fromOffset(6,6),
			Position = UDim2.fromScale(0.5,0.5),
			AnchorPoint = Vector2.new(0.5,0.5),
			BackgroundColor3 = T.Accent,
			BorderSizePixel = 0,
			ZIndex = 7, Parent = dotFrame,
			Children = {(function() local u=Instance.new("UICorner") u.CornerRadius=UDim.new(1,0) return u end)()},
		})

		local tabLabel = mk("TextLabel", {
			Text = tabCfg.Name or "Tab",
			TextSize = 13, Font = Enum.Font.GothamMedium,
			TextColor3 = T.Subtext,
			BackgroundTransparency = 1,
			Size = UDim2.new(1,-36,1,0),
			Position = UDim2.fromOffset(34,0),
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 6, Parent = tabBtn,
		})

		local tabObj = {}

		local function activate()
			if win._activeTab then
				local old = win._activeTab
				old.frame.Visible = false
				tw(old.btn,       {BackgroundTransparency = 1}, 0.18)
				tw(old.label,     {TextColor3 = T.Subtext}, 0.18)
				tw(old.indicator, {BackgroundTransparency = 1}, 0.18)
				tw(old.dot,       {BackgroundTransparency = 0.8}, 0.18)
			end
			win._activeTab = {frame=tabFrame, btn=tabBtn, label=tabLabel, indicator=indicator, dot=dotFrame}
			tabFrame.Visible = true
			tabFrame.Position = UDim2.fromOffset(10,0)
			tabFrame.BackgroundTransparency = 1
			tw(tabFrame, {Position = UDim2.fromOffset(0,0)}, 0.22, Enum.EasingStyle.Quart)
			tw(tabBtn,       {BackgroundTransparency = 0.6}, 0.18)
			tw(tabLabel,     {TextColor3 = T.Text}, 0.18)
			tw(indicator,    {BackgroundTransparency = 0}, 0.2)
			tw(dotFrame,     {BackgroundTransparency = 0.35}, 0.18)
		end

		tabBtn.MouseButton1Click:Connect(activate)
		tabBtn.MouseEnter:Connect(function()
			if win._activeTab and win._activeTab.btn == tabBtn then return end
			tw(tabBtn, {BackgroundTransparency = 0.82}, 0.14)
		end)
		tabBtn.MouseLeave:Connect(function()
			if win._activeTab and win._activeTab.btn == tabBtn then return end
			tw(tabBtn, {BackgroundTransparency = 1}, 0.14)
		end)

		if #win._tabs == 0 then
			task.defer(activate)
		end
		table.insert(win._tabs, tabObj)

		function tabObj:CreateSection(sCfg)
			local secWrap = mk("Frame", {
				Size = UDim2.new(1,0,0,0),
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				ZIndex = 4, Parent = inner,
			})

			if sCfg.Title then
				local hdr = mk("Frame", {
					Size = UDim2.new(1,0,0,22),
					BackgroundTransparency = 1,
					ZIndex = 4, Parent = secWrap,
				})
				mk("TextLabel", {
					Text = string.upper(sCfg.Title),
					TextSize = 10, Font = Enum.Font.GothamBold,
					TextColor3 = T.Accent,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(0.65,1),
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 5, Parent = hdr,
				})
				if sCfg.Description then
					mk("TextLabel", {
						Text = sCfg.Description,
						TextSize = 10, Font = Enum.Font.Gotham,
						TextColor3 = T.Muted,
						BackgroundTransparency = 1,
						Size = UDim2.new(0.35,0,1,0),
						Position = UDim2.new(0.65,0,0,0),
						TextXAlignment = Enum.TextXAlignment.Right,
						ZIndex = 5, Parent = hdr,
					})
				end
			end

			local content = mk("Frame", {
				Size = UDim2.new(1,0,0,0),
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				ZIndex = 4, Parent = secWrap,
			})
			list(content, Enum.FillDirection.Vertical, 5)
			list(secWrap, Enum.FillDirection.Vertical, 6)

			local sec = {}

			local function makeCard(h)
				local card = mk("Frame", {
					Size = UDim2.new(1,0,0, h or 52),
					BackgroundColor3 = T.Card,
					BackgroundTransparency = 0.25,
					BorderSizePixel = 0,
					ClipsDescendants = true,
					ZIndex = 5, Parent = content,
				})
				corner(card, 12)
				stroke(card, T.Border, 0.88, 1)
				return card
			end

			local function makeIconDot(parent, zBase)
				local f = mk("Frame", {
					Size = UDim2.fromOffset(32,32),
					Position = UDim2.new(0,10,0.5,-16),
					BackgroundColor3 = T.Accent,
					BackgroundTransparency = 0.75,
					BorderSizePixel = 0,
					ZIndex = zBase+1, Parent = parent,
				})
				corner(f, 9)
				mk("Frame", {
					Size = UDim2.fromOffset(8,8),
					Position = UDim2.fromScale(0.5,0.5),
					AnchorPoint = Vector2.new(0.5,0.5),
					BackgroundColor3 = T.Accent,
					BorderSizePixel = 0,
					ZIndex = zBase+2, Parent = f,
					Children = {(function() local u=Instance.new("UICorner") u.CornerRadius=UDim.new(1,0) return u end)()},
				})
				return f
			end

			local function makeTitleBlock(parent, title, desc, offsetX, zBase, heightOverride)
				local block = mk("Frame", {
					Size = UDim2.new(1, offsetX or -60, 1, 0),
					Position = UDim2.fromOffset(math.abs(offsetX or -60) > 30 and 52 or 14, 0),
					BackgroundTransparency = 1,
					ZIndex = zBase, Parent = parent,
				})
				mk("TextLabel", {
					Text = title or "",
					TextSize = 14, Font = Enum.Font.GothamMedium,
					TextColor3 = T.Text, BackgroundTransparency = 1,
					Size = UDim2.new(1,0,0,18),
					Position = UDim2.new(0,0,0.5, desc and -12 or -9),
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = zBase+1, Parent = block,
				})
				if desc then
					mk("TextLabel", {
						Text = desc,
						TextSize = 11, Font = Enum.Font.Gotham,
						TextColor3 = T.Subtext, BackgroundTransparency = 1,
						Size = UDim2.new(1,0,0,14),
						Position = UDim2.new(0,0,0.5,2),
						TextXAlignment = Enum.TextXAlignment.Left,
						ZIndex = zBase+1, Parent = block,
					})
				end
				return block
			end

			function sec:CreateButton(bcfg)
				local card = makeCard(52)
				makeIconDot(card, 5)
				makeTitleBlock(card, bcfg.Title, bcfg.Description, -66, 5)
				mk("TextLabel", {
					Text = "›", TextSize = 20, Font = Enum.Font.GothamBold,
					TextColor3 = T.Accent, BackgroundTransparency = 1,
					Size = UDim2.fromOffset(20,20),
					Position = UDim2.new(1,-28,0.5,-10),
					TextXAlignment = Enum.TextXAlignment.Center,
					ZIndex = 6, Parent = card,
				})
				local btn = mk("TextButton", {
					Size = UDim2.fromScale(1,1), BackgroundTransparency = 1,
					Text = "", AutoButtonColor = false, ZIndex = 7, Parent = card,
				})
				attachRipple(btn)
				btn.MouseEnter:Connect(function() tw(card, {BackgroundTransparency = 0.05, BackgroundColor3 = T.CardHover}, 0.15) end)
				btn.MouseLeave:Connect(function() tw(card, {BackgroundTransparency = 0.25, BackgroundColor3 = T.Card}, 0.15) end)
				btn.MouseButton1Click:Connect(function()
					tw(card, {BackgroundColor3 = T.Accent}, 0.08)
					task.delay(0.1, function() tw(card, {BackgroundColor3 = T.Card}, 0.2) end)
					if bcfg.Callback then task.spawn(bcfg.Callback) end
				end)
			end

			function sec:CreateToggle(tcfg)
				local val = tcfg.Default == true
				local card = makeCard(52)
				makeTitleBlock(card, tcfg.Title, tcfg.Description, -100, 5)

				local track = mk("Frame", {
					Size = UDim2.fromOffset(44,24),
					Position = UDim2.new(1,-54,0.5,-12),
					BackgroundColor3 = val and T.Accent or T.Muted,
					BorderSizePixel = 0,
					ZIndex = 6, Parent = card,
				})
				corner(track, 12)

				local glow = mk("Frame", {
					Size = UDim2.fromOffset(44,24),
					Position = UDim2.fromScale(0,0),
					BackgroundColor3 = T.Accent,
					BackgroundTransparency = val and 0.55 or 1,
					BorderSizePixel = 0,
					ZIndex = 5, Parent = track,
				})
				corner(glow, 12)

				local thumb = mk("Frame", {
					Size = UDim2.fromOffset(18,18),
					Position = val and UDim2.fromOffset(23,3) or UDim2.fromOffset(3,3),
					BackgroundColor3 = Color3.new(1,1,1),
					BorderSizePixel = 0,
					ZIndex = 7, Parent = track,
				})
				corner(thumb, 9)

				local shadow2 = mk("Frame", {
					Size = UDim2.fromOffset(18,18),
					Position = UDim2.fromScale(0,0),
					BackgroundColor3 = Color3.fromRGB(0,0,0),
					BackgroundTransparency = 0.6,
					BorderSizePixel = 0,
					ZIndex = 6, Parent = thumb,
				})
				corner(shadow2, 9)

				local function setVal(v)
					val = v
					if v then
						tw(track, {BackgroundColor3 = T.Accent}, 0.2)
						spring(thumb, {Position = UDim2.fromOffset(23,3)}, 0.28)
						tw(glow, {BackgroundTransparency = 0.55}, 0.2)
					else
						tw(track, {BackgroundColor3 = T.Muted}, 0.2)
						spring(thumb, {Position = UDim2.fromOffset(3,3)}, 0.28)
						tw(glow, {BackgroundTransparency = 1}, 0.2)
					end
					if tcfg.Callback then task.spawn(tcfg.Callback, v) end
				end

				local btn = mk("TextButton", {
					Size = UDim2.fromScale(1,1), BackgroundTransparency = 1,
					Text = "", AutoButtonColor = false, ZIndex = 8, Parent = card,
				})
				btn.MouseEnter:Connect(function() tw(card, {BackgroundTransparency = 0.08}, 0.15) end)
				btn.MouseLeave:Connect(function() tw(card, {BackgroundTransparency = 0.25}, 0.15) end)
				btn.MouseButton1Click:Connect(function() setVal(not val) end)

				return {Set = setVal}
			end

			function sec:CreateSlider(scfg)
				local mn  = scfg.Min or 0
				local mx  = scfg.Max or 100
				local inc = scfg.Increment or 1
				local val = math.clamp(scfg.Default or mn, mn, mx)

				local card = makeCard(62)

				local hdrF = mk("Frame", {
					Size = UDim2.new(1,-24,0,22),
					Position = UDim2.fromOffset(12,8),
					BackgroundTransparency = 1,
					ZIndex = 5, Parent = card,
				})
				mk("TextLabel", {
					Text = scfg.Title or "Slider",
					TextSize = 13, Font = Enum.Font.GothamMedium,
					TextColor3 = T.Text, BackgroundTransparency = 1,
					Size = UDim2.new(0.7,0,1,0),
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 6, Parent = hdrF,
				})
				local valLbl = mk("TextLabel", {
					Text = tostring(val),
					TextSize = 13, Font = Enum.Font.GothamBold,
					TextColor3 = T.Accent, BackgroundTransparency = 1,
					Size = UDim2.new(0.3,0,1,0),
					Position = UDim2.new(0.7,0,0,0),
					TextXAlignment = Enum.TextXAlignment.Right,
					ZIndex = 6, Parent = hdrF,
				})

				local trackBg = mk("Frame", {
					Size = UDim2.new(1,-24,0,6),
					Position = UDim2.new(0,12,0,40),
					BackgroundColor3 = T.Muted,
					BackgroundTransparency = 0.4,
					BorderSizePixel = 0,
					ZIndex = 6, Parent = card,
				})
				corner(trackBg, 3)

				local pct0 = (val-mn)/(mx-mn)
				local fill = mk("Frame", {
					Size = UDim2.new(pct0,0,1,0),
					BackgroundColor3 = T.Accent,
					BorderSizePixel = 0,
					ZIndex = 7, Parent = trackBg,
				})
				corner(fill, 3)
				gradient(fill, ColorSequence.new({
					ColorSequenceKeypoint.new(0, T.Accent),
					ColorSequenceKeypoint.new(1, T.AccentSecondary),
				}), 0)

				local knob = mk("Frame", {
					Size = UDim2.fromOffset(14,14),
					Position = UDim2.new(pct0,-7,0.5,-7),
					BackgroundColor3 = Color3.new(1,1,1),
					BorderSizePixel = 0,
					ZIndex = 8, Parent = trackBg,
				})
				corner(knob, 7)

				local knobGlow = mk("Frame", {
					Size = UDim2.fromOffset(22,22),
					Position = UDim2.fromScale(0.5,0.5),
					AnchorPoint = Vector2.new(0.5,0.5),
					BackgroundColor3 = T.Accent,
					BackgroundTransparency = 0.6,
					BorderSizePixel = 0,
					ZIndex = 7, Parent = knob,
				})
				corner(knobGlow, 11)

				local dragging = false

				local function updateAt(ix)
					local abs = trackBg.AbsolutePosition
					local sz  = trackBg.AbsoluteSize
					local rel = math.clamp((ix - abs.X) / sz.X, 0, 1)
					local raw = mn + rel * (mx - mn)
					local snapped = math.floor(raw / inc + 0.5) * inc
					snapped = math.clamp(snapped, mn, mx)
					if snapped ~= val then
						val = snapped
						local p = (val-mn)/(mx-mn)
						tw(fill,  {Size = UDim2.new(p,0,1,0)}, 0.04, Enum.EasingStyle.Linear)
						tw(knob,  {Position = UDim2.new(p,-7,0.5,-7)}, 0.04, Enum.EasingStyle.Linear)
						valLbl.Text = tostring(val)
						if scfg.Callback then task.spawn(scfg.Callback, val) end
					end
				end

				trackBg.InputBegan:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseButton1
						or i.UserInputType == Enum.UserInputType.Touch then
						dragging = true
						updateAt(i.Position.X)
					end
				end)
				UserInputService.InputChanged:Connect(function(i)
					if dragging and (
						i.UserInputType == Enum.UserInputType.MouseMovement or
						i.UserInputType == Enum.UserInputType.Touch
					) then updateAt(i.Position.X) end
				end)
				UserInputService.InputEnded:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseButton1
						or i.UserInputType == Enum.UserInputType.Touch then
						dragging = false
					end
				end)

				return {
					Set = function(_, v)
						val = math.clamp(v, mn, mx)
						local p = (val-mn)/(mx-mn)
						fill.Size = UDim2.new(p,0,1,0)
						knob.Position = UDim2.new(p,-7,0.5,-7)
						valLbl.Text = tostring(val)
					end
				}
			end

			function sec:CreateDropdown(dcfg)
				local opts = dcfg.Options or {}
				local val  = dcfg.Default or (opts[1] or "")
				local open = false

				local card = makeCard(52)
				card.ClipsDescendants = false
				card.ZIndex = 10

				makeTitleBlock(card, dcfg.Title, dcfg.Description, -130, 5)

				local valBox = mk("Frame", {
					Size = UDim2.fromOffset(108,26),
					Position = UDim2.new(1,-116,0.5,-13),
					BackgroundColor3 = T.Surface,
					BackgroundTransparency = 0.2,
					BorderSizePixel = 0,
					ZIndex = 11, Parent = card,
				})
				corner(valBox, 8)
				stroke(valBox, T.Accent, 0.65, 1)

				local selLbl = mk("TextLabel", {
					Text = val, TextSize = 12, Font = Enum.Font.GothamMedium,
					TextColor3 = T.Accent, BackgroundTransparency = 1,
					Size = UDim2.new(1,-20,1,0),
					Position = UDim2.fromOffset(7,0),
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 12, Parent = valBox,
				})
				local arrow = mk("TextLabel", {
					Text = "▾", TextSize = 11, Font = Enum.Font.GothamBold,
					TextColor3 = T.Subtext, BackgroundTransparency = 1,
					Size = UDim2.fromOffset(16,16),
					Position = UDim2.new(1,-18,0.5,-8),
					ZIndex = 12, Parent = valBox,
				})

				local dropFrame = mk("Frame", {
					Size = UDim2.new(1,0,0,0),
					Position = UDim2.new(0,0,1,4),
					BackgroundColor3 = T.Surface,
					BackgroundTransparency = 0.05,
					BorderSizePixel = 0,
					ClipsDescendants = true,
					Visible = false,
					ZIndex = 20, Parent = card,
				})
				corner(dropFrame, 10)
				stroke(dropFrame, T.Border, 0.78, 1)

				local optList = mk("Frame", {
					Size = UDim2.new(1,-8,0,0),
					Position = UDim2.fromOffset(4,4),
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					ZIndex = 21, Parent = dropFrame,
				})
				list(optList, Enum.FillDirection.Vertical, 2)

				local targetH = math.min(#opts * 30 + 10, 160)

				for _, opt in ipairs(opts) do
					local ob = mk("TextButton", {
						Size = UDim2.new(1,0,0,28),
						BackgroundColor3 = opt == val and T.Card or T.Surface,
						BackgroundTransparency = opt == val and 0.1 or 1,
						Text = opt, TextSize = 12, Font = Enum.Font.GothamMedium,
						TextColor3 = opt == val and T.Accent or T.Text,
						TextXAlignment = Enum.TextXAlignment.Left,
						AutoButtonColor = false,
						BorderSizePixel = 0,
						ZIndex = 22, Parent = optList,
					})
					corner(ob, 7)
					pad(ob, 0,0,0,8)
					ob.MouseEnter:Connect(function() tw(ob, {BackgroundTransparency = 0.25}, 0.1) end)
					ob.MouseLeave:Connect(function()
						tw(ob, {BackgroundTransparency = ob.Text == val and 0.1 or 1}, 0.1)
					end)
					ob.MouseButton1Click:Connect(function()
						val = opt
						selLbl.Text = opt
						for _, child in ipairs(optList:GetChildren()) do
							if child:IsA("TextButton") then
								tw(child, {TextColor3 = child.Text == val and T.Accent or T.Text, BackgroundTransparency = child.Text == val and 0.1 or 1}, 0.15)
							end
						end
						tw(dropFrame, {Size = UDim2.new(1,0,0,0)}, 0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
						tw(arrow, {Rotation = 0}, 0.2)
						task.delay(0.22, function() dropFrame.Visible = false end)
						open = false
						if dcfg.Callback then task.spawn(dcfg.Callback, val) end
					end)
				end

				local mainBtn = mk("TextButton", {
					Size = UDim2.fromScale(1,1), BackgroundTransparency = 1,
					Text = "", AutoButtonColor = false, ZIndex = 13, Parent = card,
				})
				mainBtn.MouseButton1Click:Connect(function()
					if open then
						open = false
						tw(dropFrame, {Size = UDim2.new(1,0,0,0)}, 0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
						tw(arrow, {Rotation = 0}, 0.2)
						task.delay(0.22, function() dropFrame.Visible = false end)
					else
						open = true
						dropFrame.Visible = true
						dropFrame.Size = UDim2.new(1,0,0,0)
						tw(dropFrame, {Size = UDim2.new(1,0,0,targetH)}, 0.28, Enum.EasingStyle.Quart)
						tw(arrow, {Rotation = 180}, 0.2)
					end
				end)
				mainBtn.MouseEnter:Connect(function() tw(card, {BackgroundTransparency = 0.08}, 0.15) end)
				mainBtn.MouseLeave:Connect(function() tw(card, {BackgroundTransparency = 0.25}, 0.15) end)

				return {
					Set = function(_, v) val = v selLbl.Text = v end,
				}
			end

			function sec:CreateKeybind(kcfg)
				local key  = kcfg.Default or Enum.KeyCode.Unknown
				local listening = false

				local card = makeCard(52)
				makeTitleBlock(card, kcfg.Title, kcfg.Description, -110, 5)

				local keyBox = mk("TextButton", {
					Size = UDim2.fromOffset(88,26),
					Position = UDim2.new(1,-96,0.5,-13),
					BackgroundColor3 = T.Surface,
					BackgroundTransparency = 0.2,
					Text = key.Name, TextSize = 11,
					Font = Enum.Font.GothamBold,
					TextColor3 = T.Accent,
					AutoButtonColor = false,
					BorderSizePixel = 0,
					ZIndex = 6, Parent = card,
				})
				corner(keyBox, 8)
				stroke(keyBox, T.Accent, 0.65, 1)

				keyBox.MouseButton1Click:Connect(function()
					if listening then return end
					listening = true
					keyBox.Text = "···"
					tw(keyBox, {TextColor3 = T.Warning}, 0.15)
					local c
					c = UserInputService.InputBegan:Connect(function(i, gp)
						if gp then return end
						if i.UserInputType == Enum.UserInputType.Keyboard then
							key = i.KeyCode
							keyBox.Text = key.Name
							tw(keyBox, {TextColor3 = T.Accent}, 0.15)
							listening = false
							c:Disconnect()
						end
					end)
				end)

				UserInputService.InputBegan:Connect(function(i, gp)
					if gp or listening then return end
					if i.UserInputType == Enum.UserInputType.Keyboard and i.KeyCode == key then
						if kcfg.Callback then task.spawn(kcfg.Callback) end
					end
				end)

				return {Set = function(_, k) key = k keyBox.Text = k.Name end}
			end

			function sec:CreateTextBox(tbcfg)
				local card = makeCard(62)

				mk("TextLabel", {
					Text = tbcfg.Title or "TextBox",
					TextSize = 12, Font = Enum.Font.GothamMedium,
					TextColor3 = T.Text, BackgroundTransparency = 1,
					Size = UDim2.new(1,-24,0,18),
					Position = UDim2.fromOffset(12,8),
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 6, Parent = card,
				})

				local inputWrap = mk("Frame", {
					Size = UDim2.new(1,-24,0,28),
					Position = UDim2.new(0,12,0,30),
					BackgroundColor3 = T.Surface,
					BackgroundTransparency = 0.3,
					BorderSizePixel = 0,
					ZIndex = 6, Parent = card,
				})
				corner(inputWrap, 8)
				local borderStroke = stroke(inputWrap, T.Border, 0.82, 1)

				local box = mk("TextBox", {
					Size = UDim2.new(1,-16,1,0),
					Position = UDim2.fromOffset(8,0),
					BackgroundTransparency = 1,
					Text = "", PlaceholderText = tbcfg.Placeholder or "Enter text...",
					PlaceholderColor3 = T.Muted,
					TextColor3 = T.Text,
					TextSize = 12, Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					ClearTextOnFocus = false,
					ZIndex = 7, Parent = inputWrap,
				})

				box.Focused:Connect(function()
					tw(inputWrap, {BackgroundTransparency = 0.1}, 0.18)
					tw(borderStroke, {Color = T.Accent, Transparency = 0.45}, 0.18)
				end)
				box.FocusLost:Connect(function()
					tw(inputWrap, {BackgroundTransparency = 0.3}, 0.18)
					tw(borderStroke, {Color = T.Border, Transparency = 0.82}, 0.18)
					if tbcfg.Callback then task.spawn(tbcfg.Callback, box.Text) end
				end)

				return {
					Set = function(_, t) box.Text = t end,
					Get = function(_) return box.Text end,
				}
			end

			function sec:CreateSeparator()
				mk("Frame", {
					Size = UDim2.new(1,-20,0,1),
					Position = UDim2.fromOffset(10,0),
					BackgroundColor3 = T.Border,
					BackgroundTransparency = 0.85,
					BorderSizePixel = 0,
					ZIndex = 5, Parent = content,
				})
			end

			return sec
		end

		return tabObj
	end

	local function doHide()
		win._visible = false
		tw(mainFrame, {BackgroundTransparency = 1}, 0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
		tw(shadow, {BackgroundTransparency = 1}, 0.22)
		task.delay(0.24, function()
			mainFrame.Visible = false
			shadow.Visible    = false
			pill.Visible      = true
			pill.Size = UDim2.fromOffset(0,36)
			spring(pill, {Size = UDim2.fromOffset(160,36)}, 0.35)
		end)
	end

	local function doShow()
		win._visible = true
		pill.Visible = false
		mainFrame.Visible = true
		shadow.Visible    = true
		mainFrame.BackgroundTransparency = 1
		shadow.BackgroundTransparency = 1
		mainFrame.Size = UDim2.new(0, W*0.95, 0, H*0.95)
		spring(mainFrame, {
			Size = UDim2.fromOffset(W, H),
			BackgroundTransparency = 0,
		}, 0.38)
		tw(shadow, {BackgroundTransparency = 0.5}, 0.38)
	end

	if closeBtn then
		closeBtn.MouseButton1Click:Connect(doHide)
	end
	if minBtn then
		minBtn.MouseButton1Click:Connect(function()
			win._visible = false
			tw(mainFrame, {BackgroundTransparency = 1}, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
			tw(shadow, {BackgroundTransparency = 1}, 0.2)
			task.delay(0.22, function()
				mainFrame.Visible = false
				shadow.Visible    = false
				pill.Visible      = true
				pill.Size = UDim2.fromOffset(0,36)
				spring(pill, {Size = UDim2.fromOffset(160,36)}, 0.35)
			end)
		end)
	end

	pill.MouseButton1Click:Connect(doShow)
	pill.MouseEnter:Connect(function()
		tw(pill, {Size = UDim2.fromOffset(172,38)}, 0.18, Enum.EasingStyle.Back)
	end)
	pill.MouseLeave:Connect(function()
		tw(pill, {Size = UDim2.fromOffset(160,36)}, 0.18)
	end)

	if cfg.Draggable ~= false then
		makeDraggable(mainFrame, header)
	end

	if cfg.ToggleKey then
		UserInputService.InputBegan:Connect(function(i, gp)
			if gp then return end
			if i.KeyCode == cfg.ToggleKey then
				if win._visible then doHide() else doShow() end
			end
		end)
	end
	if cfg.MinimizeKey then
		UserInputService.InputBegan:Connect(function(i, gp)
			if gp then return end
			if i.KeyCode == cfg.MinimizeKey and win._visible then
				minBtn and minBtn.MouseButton1Click:Fire()
			end
		end)
	end

	win.Hide    = doHide
	win.Show    = doShow
	win.Destroy = function()
		mainFrame:Destroy()
		shadow:Destroy()
		pill:Destroy()
	end

	mainFrame.BackgroundTransparency = 1
	mainFrame.Size = UDim2.new(0, W*0.95, 0, H*0.95)
	spring(mainFrame, {Size = UDim2.fromOffset(W,H), BackgroundTransparency = 0}, 0.42)
	task.delay(0.05, function() tw(shadow, {BackgroundTransparency = 0.5}, 0.35) end)

	return win
end

return Aurora
