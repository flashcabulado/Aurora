# AuroraUI — API Reference

## Library

### `AuroraUI:CreateWindow(config) → Window`

Creates and displays the main UI window.

**Config fields:**

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `Title` | string | `"AuroraUI"` | Window title |
| `Subtitle` | string | `nil` | Subtitle below the title |
| `Footer` | string | `"AuroraUI • v1.0.0"` | Bottom bar text |
| `Thumbnail` | string | `""` | rbxassetid for header icon |
| `Banner` | string | `""` | rbxassetid for banner image |
| `Size` | UDim2 | `UDim2.fromOffset(620, 430)` | Window size |
| `Position` | UDim2 | `UDim2.fromScale(0.5, 0.5)` | Window position |
| `AnchorPoint` | Vector2 | `Vector2.new(0.5, 0.5)` | Anchor |
| `ToggleKey` | Enum.KeyCode | `nil` | Key to show/hide window |
| `MinimizeKey` | Enum.KeyCode | `nil` | Key to minimize |
| `Theme` | string | `"Dark"` | Theme preset name |
| `Acrylic` | boolean | `true` | Surface gradient |
| `Noise` | boolean | `true` | Noise texture overlay |
| `Shadow` | boolean | `true` | Drop shadow |
| `Blur` | boolean | `false` | Background blur effect |
| `MobileScale` | number | `0.85` | Scale factor on mobile |
| `Draggable` | boolean | `true` | Allow dragging on PC |
| `Closable` | boolean | `true` | Show close button |
| `Minimizable` | boolean | `true` | Show minimize button |

---

### `AuroraUI:Notify(config)`

Displays a toast notification in the top-right corner.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `Title` | string | `"Notification"` | Bold title |
| `Content` | string | `""` | Body message |
| `Duration` | number | `4` | Seconds before dismiss |
| `Type` | string | `"Default"` | Icon/color type |

**Type options:** `"Success"`, `"Warning"`, `"Error"`, `"Info"`, `"Default"`

---

### `AuroraUI:SetTheme(config)`

Applies partial or full theme overrides.

```lua
AuroraUI:SetTheme({ Accent = Color3.fromRGB(255, 80, 80) })
```

---

### `AuroraUI:UseTheme(name)`

Switches to a built-in preset (`"Dark"` or `"Light"`).

---

### `AuroraUI:GetTheme() → table`

Returns the current theme color table.

---

## Window

### `Window:CreateTab(config) → Tab`

| Field | Type | Description |
|-------|------|-------------|
| `Name` | string | Tab label |
| `Icon` | string | Optional rbxassetid icon |
| `Group` | string | Sidebar group label |

### `Window:Hide()`

Hides the window with fade + scale animation. Shows floating pill button.

### `Window:Show()`

Restores the window from hidden state.

### `Window:Minimize()`

Shrinks window to pill button with animation.

### `Window:Destroy()`

Removes all UI elements from the screen.

---

## Tab

### `Tab:CreateSection(config) → Section`

| Field | Type | Description |
|-------|------|-------------|
| `Title` | string | Section heading |
| `Description` | string | Right-aligned subtitle |

---

## Section

### `Section:CreateButton(config) → Button`

| Field | Type | Description |
|-------|------|-------------|
| `Title` | string | Button label |
| `Description` | string | Subtitle text |
| `Icon` | string | Optional icon asset ID |
| `Callback` | function | Called on click |

### `Section:CreateToggle(config) → Toggle`

| Field | Type | Description |
|-------|------|-------------|
| `Title` | string | Label |
| `Description` | string | Subtitle |
| `Default` | boolean | Initial state |
| `Callback` | function(value: boolean) | Called on change |

**Methods:**
- `Toggle:Set(value: boolean)` — set value programmatically

### `Section:CreateSlider(config) → Slider`

| Field | Type | Description |
|-------|------|-------------|
| `Title` | string | Label |
| `Description` | string | Subtitle |
| `Min` | number | Minimum value |
| `Max` | number | Maximum value |
| `Default` | number | Initial value |
| `Increment` | number | Step size |
| `Callback` | function(value: number) | Called on change |

**Methods:**
- `Slider:Set(value: number)` — set value programmatically

### `Section:CreateDropdown(config) → Dropdown`

| Field | Type | Description |
|-------|------|-------------|
| `Title` | string | Label |
| `Description` | string | Subtitle |
| `Options` | table | Array of string options |
| `Default` | string | Initially selected option |
| `Callback` | function(value: string) | Called on selection |

**Methods:**
- `Dropdown:Set(value: string)` — set selected value
- `Dropdown:OpenDrop()` — open the dropdown
- `Dropdown:Close()` — close the dropdown

### `Section:CreateKeybind(config) → Keybind`

| Field | Type | Description |
|-------|------|-------------|
| `Title` | string | Label |
| `Description` | string | Subtitle |
| `Default` | Enum.KeyCode | Initial key |
| `Callback` | function | Called when key is pressed |

**Methods:**
- `Keybind:Set(key: Enum.KeyCode)` — set key programmatically

### `Section:CreateTextBox(config) → TextBox`

| Field | Type | Description |
|-------|------|-------------|
| `Title` | string | Label |
| `Description` | string | Subtitle |
| `Placeholder` | string | Placeholder text |
| `Callback` | function(text: string) | Called on focus lost |

**Methods:**
- `TextBox:Set(text: string)` — set text
- `TextBox:Get() → string` — get current text

### `Section:CreateSeparator() → Separator`

Creates a thin horizontal dividing line.
