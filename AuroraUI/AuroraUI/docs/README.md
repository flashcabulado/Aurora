# AuroraUI — Premium Roblox UI Library

AuroraUI is a modern, glassmorphism-inspired UI library for Roblox, built in Luau. It features iOS/Apple-style aesthetics, fluid animations, and a modular architecture supporting PC and mobile platforms.

## Features

- Glassmorphism visuals with noise texture and translucent surfaces
- Smooth TweenService-based animations throughout
- iOS-style toggle switches, modern sliders, animated dropdowns
- Floating pill button (Dynamic Island style) for minimized state
- Tab system with sidebar navigation and group labels
- Toast notification system (Success, Warning, Error, Info)
- Full theming system with color presets
- Draggable window on PC, touch-responsive on mobile
- Keyboard hotkey support for toggle and minimize
- Ripple effects on interactive elements
- Gradient accents, glow effects, soft shadows

## Installation

1. Open Roblox Studio
2. In the Explorer panel, navigate to `ReplicatedStorage`
3. Create a new Folder named `AuroraUI`
4. Inside it, create a Folder named `src`
5. Import all ModuleScripts from the `src/` folder:
   - `Init` (ModuleScript)
   - `Core` (ModuleScript)
   - `Theme` (ModuleScript)
   - `Animation` (ModuleScript)
   - `Utils` (ModuleScript)
   - `Assets` (ModuleScript)
6. Create a Folder inside `src` named `Components`
7. Import all component ModuleScripts into `Components`
8. Create a Folder inside `src` named `Effects`
9. Import all effect ModuleScripts into `Effects`
10. Place `Example.client.lua` content into a `LocalScript` inside `StarterPlayerScripts`

## Quick Start

```lua
local AuroraUI = require(game.ReplicatedStorage.AuroraUI.src.Init)

local Window = AuroraUI:CreateWindow({
    Title = "My Script",
    Subtitle = "Premium Interface",
    Footer = "MyScript v1.0.0",
    ToggleKey = Enum.KeyCode.RightShift,
})

local Tab = Window:CreateTab({ Name = "Main", Group = "General" })
local Section = Tab:CreateSection({ Title = "Player" })

Section:CreateSlider({
    Title = "Speed",
    Min = 16,
    Max = 100,
    Default = 16,
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
})

AuroraUI:Notify({
    Title = "Loaded",
    Content = "Script is ready",
    Duration = 4,
    Type = "Success"
})
```

## Module Structure

```
AuroraUI/
└── src/
    ├── Init.lua          -- Entry point, loads and returns the library
    ├── Core.lua          -- Main API: CreateWindow, Notify, SetTheme
    ├── Theme.lua         -- Color system and presets
    ├── Animation.lua     -- TweenService wrappers
    ├── Utils.lua         -- Instance creation helpers
    ├── Assets.lua        -- Icon and asset IDs
    ├── Components/
    │   ├── Window.lua    -- Main window, header, sidebar, footer
    │   ├── Tab.lua       -- Tab with scrollable content
    │   ├── Section.lua   -- Section container with label
    │   ├── Button.lua    -- Clickable button with ripple
    │   ├── Toggle.lua    -- iOS-style toggle switch
    │   ├── Slider.lua    -- Draggable value slider
    │   ├── Dropdown.lua  -- Animated option selector
    │   ├── Keybind.lua   -- Keyboard key listener
    │   ├── TextBox.lua   -- Text input field
    │   ├── Notification.lua -- Toast notifications
    │   └── Separator.lua -- Visual divider line
    └── Effects/
        ├── Gradients.lua -- UIGradient helpers
        ├── Textures.lua  -- Noise texture overlay
        ├── Shadows.lua   -- Drop shadow frames
        └── Ripple.lua    -- Click ripple animation
```

## Hotkeys

| Key | Action |
|-----|--------|
| `RightShift` | Toggle UI visibility |
| `M` | Minimize to pill button |

Both keys are configurable via `ToggleKey` and `MinimizeKey` in `CreateWindow`.

## Themes

AuroraUI includes built-in presets:
- `Dark` — deep dark background with purple accent (default)
- `Light` — light gray background with purple accent

Switch with:
```lua
AuroraUI:UseTheme("Light")
```

Or apply custom colors:
```lua
AuroraUI:SetTheme({
    Background = Color3.fromRGB(10, 10, 10),
    Accent = Color3.fromRGB(255, 100, 100)
})
```

## Minimization

When the user clicks the minimize button or presses `M`, the window shrinks into a pill button in the bottom center of the screen. Clicking the pill reopens the window with a smooth animation.

## Notification System

```lua
AuroraUI:Notify({
    Title = "Title",
    Content = "Message here",
    Duration = 4,
    Type = "Success"  -- "Success", "Warning", "Error", "Info", "Default"
})
```

## Thumbnail and Banner

Pass an asset ID to display an avatar image in the header or a banner image at the top of the window:

```lua
AuroraUI:CreateWindow({
    Thumbnail = "rbxassetid://YOUR_ID",
    Banner = "rbxassetid://YOUR_ID",
})
```

Set to `"rbxassetid://0"` or `""` to disable.

## Groups

Groups are labels in the sidebar that categorize tabs:

```lua
Window:CreateTab({ Name = "Main", Group = "General" })
Window:CreateTab({ Name = "Combat", Group = "General" })
Window:CreateTab({ Name = "Visuals", Group = "Options" })
```

## License

Generated for educational and personal use in Roblox Studio.
