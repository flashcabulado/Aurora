local src = script

local Theme = require(src.Theme)
local Animation = require(src.Animation)
local Utils = require(src.Utils)
local Assets = require(src.Assets)

local Effects = {
    Gradients = require(src.Effects.Gradients),
    Textures = require(src.Effects.Textures),
    Shadows = require(src.Effects.Shadows),
    Ripple = require(src.Effects.Ripple)
}

local Components = {
    Window = require(src.Components.Window),
    Tab = require(src.Components.Tab),
    Section = require(src.Components.Section),
    Button = require(src.Components.Button),
    Toggle = require(src.Components.Toggle),
    Slider = require(src.Components.Slider),
    Dropdown = require(src.Components.Dropdown),
    Keybind = require(src.Components.Keybind),
    Notification = require(src.Components.Notification),
    TextBox = require(src.Components.TextBox),
    Separator = require(src.Components.Separator),
    Ripple = Effects.Ripple
}

local Core = require(src.Core)
Core:_Init(Theme, Animation, Utils, Assets, Effects, Components)

return Core
