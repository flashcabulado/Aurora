local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local AuroraUI = require(ReplicatedStorage.AuroraUI.src.Init)

AuroraUI:SetTheme({
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
})

local Window = AuroraUI:CreateWindow({
    Title = "Aurora UI",
    Subtitle = "Premium Roblox Interface",
    Footer = "AuroraUI v1.0.0 • by Generator",
    Thumbnail = "rbxassetid://0",
    Banner = "rbxassetid://0",
    Size = UDim2.fromOffset(620, 430),
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    ToggleKey = Enum.KeyCode.RightShift,
    MinimizeKey = Enum.KeyCode.M,
    Theme = "Dark",
    Acrylic = true,
    Noise = true,
    Shadow = true,
    Blur = false,
    MobileScale = 0.85,
    Draggable = true,
    Closable = true,
    Minimizable = true
})

local MainTab = Window:CreateTab({
    Name = "Main",
    Icon = "",
    Group = "General"
})

local PlayerTab = Window:CreateTab({
    Name = "Player",
    Icon = "",
    Group = "General"
})

local VisualTab = Window:CreateTab({
    Name = "Visuals",
    Icon = "",
    Group = "Options"
})

local SettingsTab = Window:CreateTab({
    Name = "Settings",
    Icon = "",
    Group = "Options"
})

local PlayerSection = MainTab:CreateSection({
    Title = "Player",
    Description = "Movement settings"
})

PlayerSection:CreateSlider({
    Title = "WalkSpeed",
    Description = "Adjust local walkspeed",
    Min = 16,
    Max = 200,
    Default = 16,
    Increment = 1,
    Callback = function(Value)
        local player = Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = Value
        end
    end
})

PlayerSection:CreateSlider({
    Title = "JumpPower",
    Description = "Adjust local jump power",
    Min = 50,
    Max = 400,
    Default = 50,
    Increment = 5,
    Callback = function(Value)
        local player = Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = Value
        end
    end
})

PlayerSection:CreateToggle({
    Title = "Infinite Jump",
    Description = "Jump while in the air",
    Default = false,
    Callback = function(Value)
        print("Infinite Jump:", Value)
    end
})

local CombatSection = MainTab:CreateSection({
    Title = "Combat",
    Description = "Combat modifications"
})

CombatSection:CreateDropdown({
    Title = "Mode",
    Description = "Select operation mode",
    Options = {"Legit", "Balanced", "Fast", "Rage"},
    Default = "Balanced",
    Callback = function(Value)
        print("Mode:", Value)
    end
})

CombatSection:CreateButton({
    Title = "Teleport to Random Player",
    Description = "Instantly move to a player",
    Icon = "",
    Callback = function()
        print("Teleporting...")
        AuroraUI:Notify({
            Title = "Teleport",
            Content = "Teleported to random player",
            Duration = 3,
            Type = "Success"
        })
    end
})

CombatSection:CreateKeybind({
    Title = "Action Key",
    Description = "Trigger main action",
    Default = Enum.KeyCode.F,
    Callback = function()
        print("Action key triggered")
        AuroraUI:Notify({
            Title = "Action",
            Content = "Key action executed",
            Duration = 2,
            Type = "Info"
        })
    end
})

local AppearanceSection = PlayerTab:CreateSection({
    Title = "Appearance",
    Description = "Visual player settings"
})

AppearanceSection:CreateToggle({
    Title = "ESP",
    Description = "Show player highlights",
    Default = false,
    Callback = function(Value)
        print("ESP:", Value)
    end
})

AppearanceSection:CreateToggle({
    Title = "Chams",
    Description = "Show through walls",
    Default = false,
    Callback = function(Value)
        print("Chams:", Value)
    end
})

AppearanceSection:CreateDropdown({
    Title = "Highlight Color",
    Description = "Choose ESP highlight color",
    Options = {"Red", "Blue", "Green", "Purple", "White", "Cyan"},
    Default = "Purple",
    Callback = function(Value)
        print("Highlight Color:", Value)
    end
})

local NameSection = PlayerTab:CreateSection({
    Title = "Identity",
    Description = "Player name settings"
})

NameSection:CreateTextBox({
    Title = "Display Name",
    Description = "Change your overhead name",
    Placeholder = "Enter display name...",
    Callback = function(Text)
        print("Name set to:", Text)
    end
})

NameSection:CreateSeparator()

NameSection:CreateButton({
    Title = "Reset Name",
    Description = "Restore original display name",
    Callback = function()
        AuroraUI:Notify({
            Title = "Name Reset",
            Content = "Display name has been restored",
            Duration = 3,
            Type = "Success"
        })
    end
})

local WorldSection = VisualTab:CreateSection({
    Title = "World",
    Description = "Environment modifications"
})

WorldSection:CreateSlider({
    Title = "Field of View",
    Description = "Adjust camera FOV",
    Min = 70,
    Max = 120,
    Default = 70,
    Increment = 1,
    Callback = function(Value)
        workspace.CurrentCamera.FieldOfView = Value
    end
})

WorldSection:CreateToggle({
    Title = "Fullbright",
    Description = "Maximum ambient brightness",
    Default = false,
    Callback = function(Value)
        if Value then
            game:GetService("Lighting").Brightness = 10
            game:GetService("Lighting").ClockTime = 14
        else
            game:GetService("Lighting").Brightness = 2
        end
    end
})

WorldSection:CreateToggle({
    Title = "No Fog",
    Description = "Disable distance fog",
    Default = false,
    Callback = function(Value)
        if Value then
            game:GetService("Lighting").FogEnd = 1e9
        else
            game:GetService("Lighting").FogEnd = 100000
        end
    end
})

local ThemeSection = SettingsTab:CreateSection({
    Title = "Theme",
    Description = "Customize interface appearance"
})

ThemeSection:CreateDropdown({
    Title = "Color Theme",
    Description = "Select UI color preset",
    Options = {"Dark (Default)", "Light", "Ocean", "Midnight"},
    Default = "Dark (Default)",
    Callback = function(Value)
        if Value == "Light" then
            AuroraUI:UseTheme("Light")
        else
            AuroraUI:UseTheme("Dark")
        end
        AuroraUI:Notify({
            Title = "Theme Changed",
            Content = "Applied theme: " .. Value,
            Duration = 3,
            Type = "Info"
        })
    end
})

ThemeSection:CreateButton({
    Title = "Reset All Settings",
    Description = "Restore default configuration",
    Callback = function()
        AuroraUI:Notify({
            Title = "Settings Reset",
            Content = "All values have been restored",
            Duration = 4,
            Type = "Warning"
        })
    end
})

local HotkeySection = SettingsTab:CreateSection({
    Title = "Hotkeys",
    Description = "Interface controls"
})

HotkeySection:CreateKeybind({
    Title = "Toggle UI",
    Description = "Show or hide interface",
    Default = Enum.KeyCode.RightShift,
    Callback = function()
    end
})

HotkeySection:CreateKeybind({
    Title = "Minimize UI",
    Description = "Minimize to pill button",
    Default = Enum.KeyCode.M,
    Callback = function()
    end
})

task.delay(1.5, function()
    AuroraUI:Notify({
        Title = "AuroraUI",
        Content = "Interface loaded successfully. Press RightShift to toggle.",
        Duration = 5,
        Type = "Success"
    })
end)
