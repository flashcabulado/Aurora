# AuroraUI — Properties Reference

## CreateWindow Properties

```lua
AuroraUI:CreateWindow({
    Title           = "string",          -- Header title
    Subtitle        = "string",          -- Header subtitle (optional)
    Footer          = "string",          -- Footer text
    Thumbnail       = "rbxassetid://0",  -- Header icon asset
    Banner          = "rbxassetid://0",  -- Banner image asset
    Size            = UDim2.fromOffset(620, 430),
    Position        = UDim2.fromScale(0.5, 0.5),
    AnchorPoint     = Vector2.new(0.5, 0.5),
    ToggleKey       = Enum.KeyCode.RightShift,
    MinimizeKey     = Enum.KeyCode.M,
    Theme           = "Dark",            -- "Dark" | "Light"
    Acrylic         = true,              -- Surface gradient
    Noise           = true,              -- Noise texture overlay
    Shadow          = true,              -- Drop shadow
    Blur            = false,             -- BlurEffect in Lighting
    MobileScale     = 0.85,              -- Scale on mobile
    Draggable       = true,
    Closable        = true,
    Minimizable     = true
})
```

## CreateTab Properties

```lua
Window:CreateTab({
    Name    = "string",        -- Sidebar label
    Icon    = "rbxassetid://", -- Icon image (optional)
    Group   = "string"         -- Sidebar group header
})
```

## CreateSection Properties

```lua
Tab:CreateSection({
    Title       = "string",    -- Section heading (uppercase)
    Description = "string"     -- Right-aligned subtext (optional)
})
```

## CreateButton Properties

```lua
Section:CreateButton({
    Title       = "string",
    Description = "string",    -- Optional
    Icon        = "string",    -- Optional icon asset ID
    Callback    = function() end
})
```

## CreateToggle Properties

```lua
Section:CreateToggle({
    Title       = "string",
    Description = "string",
    Default     = false,
    Callback    = function(value: boolean) end
})
```

## CreateSlider Properties

```lua
Section:CreateSlider({
    Title       = "string",
    Description = "string",
    Min         = 0,
    Max         = 100,
    Default     = 50,
    Increment   = 1,
    Callback    = function(value: number) end
})
```

## CreateDropdown Properties

```lua
Section:CreateDropdown({
    Title       = "string",
    Description = "string",
    Options     = {"Option1", "Option2"},
    Default     = "Option1",
    Callback    = function(value: string) end
})
```

## CreateKeybind Properties

```lua
Section:CreateKeybind({
    Title       = "string",
    Description = "string",
    Default     = Enum.KeyCode.F,
    Callback    = function() end
})
```

## CreateTextBox Properties

```lua
Section:CreateTextBox({
    Title       = "string",
    Description = "string",
    Placeholder = "Enter text...",
    Callback    = function(text: string) end
})
```

## Notify Properties

```lua
AuroraUI:Notify({
    Title    = "string",
    Content  = "string",
    Duration = 4,
    Type     = "Success"  -- "Success" | "Warning" | "Error" | "Info" | "Default"
})
```

## Theme Properties

```lua
AuroraUI:SetTheme({
    Background      = Color3.fromRGB(12, 14, 20),
    Surface         = Color3.fromRGB(20, 24, 34),
    Card            = Color3.fromRGB(28, 34, 46),
    Accent          = Color3.fromRGB(124, 92, 255),
    AccentSecondary = Color3.fromRGB(0, 212, 255),
    Text            = Color3.fromRGB(245, 247, 250),
    Subtext         = Color3.fromRGB(150, 160, 175),
    Border          = Color3.fromRGB(255, 255, 255),
    Success         = Color3.fromRGB(52, 211, 153),
    Warning         = Color3.fromRGB(251, 191, 36),
    Error           = Color3.fromRGB(248, 113, 113)
})
```
