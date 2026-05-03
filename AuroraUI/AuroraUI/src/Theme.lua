local Theme = {}

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

return Theme
