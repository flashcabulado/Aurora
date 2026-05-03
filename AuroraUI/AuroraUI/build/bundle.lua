local ROOT = "AuroraUI/src"
local OUT = "dist/Aurora.lua"

local function read(path)
    local f = assert(io.open(path, "r"))
    local c = f:read("*a")
    f:close()
    return c
end

local function write(path, content)
    local f = assert(io.open(path, "w"))
    f:write(content)
    f:close()
end

local function scandir(path, base, out)
    out = out or {}
    base = base or path

    local p = io.popen('find "' .. path .. '" -type f')
    for file in p:lines() do
        if file:match("%.lua$") then
            local rel = file:gsub("^" .. base .. "/?", ""):gsub("%.lua$", "")
            rel = rel:gsub("\\", "/")
            table.insert(out, {
                path = file,
                name = rel
            })
        end
    end
    p:close()

    table.sort(out, function(a, b)
        return a.name < b.name
    end)

    return out
end

local function normalizeRequirePath(current, target)
    local parts = {}

    for seg in current:gmatch("[^/]+") do
        table.insert(parts, seg)
    end
    table.remove(parts, #parts)

    for token in target:gmatch("[^%.]+") do
        if token == "Parent" then
            table.remove(parts, #parts)
        else
            table.insert(parts, token)
        end
    end

    return table.concat(parts, "/")
end

local function rewriteRequires(source, moduleName)
    source = source:gsub(
        "require%s*%(%s*script([%._%a%d]+)%s*%)",
        function(chain)
            local path = normalizeRequirePath(moduleName, chain)
            return ('requireModule("%s")'):format(path)
        end
    )

    source = source:gsub(
        "require%s*%(%s*script%s*:%s*FindFirstChild%s*%b()%s*%)",
        function()
            error("Dynamic FindFirstChild require not supported in bundler")
        end
    )

    return source
end

local function indent(text)
    local out = {}
    for line in text:gmatch("([^\n]*)\n?") do
        table.insert(out, "        " .. line)
    end
    return table.concat(out, "\n")
end

local files = scandir(ROOT)

local chunks = {}

table.insert(chunks, "-- bundled by Aurora bundler")
table.insert(chunks, "local Aurora")
table.insert(chunks, "local Modules = {}")
table.insert(chunks, "local Cache = {}")
table.insert(chunks, "")

table.insert(chunks, "-- executor compatibility")
table.insert(chunks, "local cloneref = cloneref or function(v) return v end")
table.insert(chunks, "local gethui = gethui or function() return cloneref(game:GetService(\"CoreGui\")) end")
table.insert(chunks, "local protectgui = protectgui or function() end")
table.insert(chunks, "local getcustomasset = getcustomasset or getsynasset or function(v) return v end")
table.insert(chunks, "")

table.insert(chunks, "local function requireModule(name)")
table.insert(chunks, "    if Cache[name] then")
table.insert(chunks, "        return Cache[name]")
table.insert(chunks, "    end")
table.insert(chunks, "")
table.insert(chunks, "    local loader = Modules[name]")
table.insert(chunks, "    assert(loader, \"[Aurora] Missing module: \" .. tostring(name))")
table.insert(chunks, "")
table.insert(chunks, "    local loaded = loader()")
table.insert(chunks, "    Cache[name] = loaded")
table.insert(chunks, "    return loaded")
table.insert(chunks, "end")
table.insert(chunks, "")

for _, mod in ipairs(files) do
    local src = read(mod.path)
    src = rewriteRequires(src, mod.name)

    table.insert(chunks, ('Modules["%s"] = function()'):format(mod.name))
    table.insert(chunks, indent(src))
    table.insert(chunks, "end")
    table.insert(chunks, "")
end

table.insert(chunks, 'Aurora = requireModule("Init")')
table.insert(chunks, "return Aurora")

write(OUT, table.concat(chunks, "\n"))
print("[Aurora] bundled -> " .. OUT)
