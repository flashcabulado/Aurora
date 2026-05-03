local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Window = {}
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

return Window
