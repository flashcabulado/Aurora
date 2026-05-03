# AuroraUI — Theme Guide

## Color System

AuroraUI uses a structured color palette with these semantic roles:

| Role | Purpose |
|------|---------|
| `Background` | Main window background |
| `Surface` | Header, sidebar, footer, secondary panels |
| `Card` | Component cards (buttons, toggles, sliders) |
| `Accent` | Primary interactive color (active tabs, sliders, toggles) |
| `AccentSecondary` | Gradient end color, highlights |
| `Text` | Primary readable text |
| `Subtext` | Secondary, descriptive, placeholder text |
| `Border` | UIStroke color (low opacity) |
| `Success` | Success notifications and indicators |
| `Warning` | Warning notifications |
| `Error` | Error notifications and close button |

## Changing a Single Color

You only need to provide the keys you want to change:

```lua
AuroraUI:SetTheme({
    Accent = Color3.fromRGB(255, 70, 70)
})
```

## Switching Built-in Presets

```lua
AuroraUI:UseTheme("Dark")
AuroraUI:UseTheme("Light")
```

## Creating Custom Themes

Define a full palette and apply it:

```lua
local OceanTheme = {
    Background = Color3.fromRGB(8, 18, 32),
    Surface = Color3.fromRGB(14, 28, 48),
    Card = Color3.fromRGB(20, 36, 58),
    Accent = Color3.fromRGB(0, 180, 220),
    AccentSecondary = Color3.fromRGB(0, 240, 200),
    Text = Color3.fromRGB(230, 245, 255),
    Subtext = Color3.fromRGB(120, 160, 190),
    Border = Color3.fromRGB(255, 255, 255),
    Success = Color3.fromRGB(52, 211, 153),
    Warning = Color3.fromRGB(251, 191, 36),
    Error = Color3.fromRGB(248, 113, 113)
}

AuroraUI:SetTheme(OceanTheme)
```

## Gradient System

AuroraUI uses `UIGradient` for:
- Window background surface effect (`Gradients:ApplySurface`)
- Accent gradient on sliders and pills (`Gradients:ApplyAccent`)
- Individual gradient overrides (`Gradients:Apply`)

Custom gradient example:

```lua
local Gradients = require(game.ReplicatedStorage.AuroraUI.src.Effects.Gradients)
Gradients:Apply(myFrame, ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 255))
}), 135)
```

## Noise Texture

The noise texture overlay gives surfaces a subtle grain, similar to Apple visionOS frosted glass. It uses `ScaleType = Tile` on an `ImageLabel`.

Control transparency via `Textures:ApplyNoise(frame, 0.92)`. Lower values = more visible grain.

Disable it globally by passing `Noise = false` to `CreateWindow`.

## Shadows

Shadows are created using a semi-transparent frame behind the window. You can customize:

```lua
local Shadows = require(game.ReplicatedStorage.AuroraUI.src.Effects.Shadows)
Shadows:Apply(myFrame, 20, Color3.fromRGB(0, 0, 0), 0.5)
```

## Stroke (Border)

UIStrokes are applied via `Utils:Stroke(frame, color, transparency, thickness)`. The default border is white at ~85% transparency for a frosted glass edge.

## Typography

AuroraUI uses Roblox's `Gotham` font family:
- `GothamBold` — titles, active tab labels, values
- `GothamMedium` — button text, section titles
- `Gotham` — descriptions, subtitles, placeholders

Font sizes used:
- `15` — window title
- `13–14` — component titles
- `10–12` — descriptions, footers, labels
- `9–10` — section headers (uppercase with letter-spacing)
