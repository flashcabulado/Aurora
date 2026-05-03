local Core = {}
Core.__index = Core

local _theme, _animation, _utils, _assets, _effects, _components

function Core:_Init(theme, animation, utils, assets, effects, components)
    _theme = theme
    _animation = animation
    _utils = utils
    _assets = assets
    _effects = effects
    _components = components
end

function Core:CreateWindow(config)
    local win = _components.Window.new(config, _theme, _animation, _utils, _assets, _effects, _components, self)
    return win
end

function Core:Notify(config)
    local gui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("AuroraUI_ScreenGui")
    if not gui then
        gui = Instance.new("ScreenGui")
        gui.Name = "AuroraUI_ScreenGui"
        gui.ResetOnSpawn = false
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
    _components.Notification:Show(config, gui)
end

function Core:SetTheme(config)
    _theme:Apply(config)
end

function Core:UseTheme(name)
    _theme:UsePreset(name)
end

function Core:GetTheme()
    return _theme.Current
end

return Core
