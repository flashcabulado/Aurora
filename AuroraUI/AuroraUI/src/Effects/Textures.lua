local Textures = {}

local NOISE_ID = "rbxassetid://6580542979"

function Textures:ApplyNoise(frame, transparency)
    local existing = frame:FindFirstChild("_NoiseTexture")
    if existing then existing:Destroy() end
    local img = Instance.new("ImageLabel")
    img.Name = "_NoiseTexture"
    img.Image = NOISE_ID
    img.Size = UDim2.fromScale(1, 1)
    img.Position = UDim2.fromScale(0, 0)
    img.BackgroundTransparency = 1
    img.ImageTransparency = transparency or 0.92
    img.ScaleType = Enum.ScaleType.Tile
    img.TileSize = UDim2.fromOffset(128, 128)
    img.ZIndex = frame.ZIndex
    img.Parent = frame
    return img
end

function Textures:Remove(frame)
    local t = frame:FindFirstChild("_NoiseTexture")
    if t then t:Destroy() end
end

return Textures
