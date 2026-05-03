local Assets = {}

Assets.Icons = {
    Home = "rbxassetid://7733715400",
    Settings = "rbxassetid://7734053495",
    Star = "rbxassetid://7743878855",
    Shield = "rbxassetid://7743882715",
    Bolt = "rbxassetid://7733651120",
    User = "rbxassetid://7734053495",
    Eye = "rbxassetid://7734053495",
    Lock = "rbxassetid://7734053495",
    Search = "rbxassetid://7734053495",
    Bell = "rbxassetid://7734053495",
    Chart = "rbxassetid://7734053495",
    Map = "rbxassetid://7734053495",
    Heart = "rbxassetid://7734053495",
    Sparkles = "rbxassetid://7733715400",
    X = "rbxassetid://7734053495",
    Check = "rbxassetid://7734053495",
    Info = "rbxassetid://7734053495",
    Warning = "rbxassetid://7734053495",
    Error = "rbxassetid://7734053495",
    ChevronDown = "rbxassetid://7734053495",
    ChevronRight = "rbxassetid://7734053495",
}

Assets.Sounds = {}

function Assets:GetIcon(name)
    return self.Icons[name] or ""
end

return Assets
