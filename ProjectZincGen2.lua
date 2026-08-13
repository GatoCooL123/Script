local Players = game:GetService("Players")
local lplayer = Players.LocalPlayer

-- ==================== WELCOME SCREEN ====================
-- Built from raw instances rather than a library option, since Gen2 exposes
-- no documented splash key and an unrecognised key would silently do nothing.
do
    local TweenService = game:GetService("TweenService")
    local playerGui = lplayer:WaitForChild("PlayerGui")

    local splash = Instance.new("ScreenGui")
    splash.Name = "ZincWelcome"
    splash.ResetOnSpawn = false
    splash.IgnoreGuiInset = true
    splash.DisplayOrder = 9999
    splash.Parent = playerGui

    local dim = Instance.new("Frame")
    dim.Size = UDim2.new(1, 0, 1, 0)
    dim.BackgroundColor3 = Color3.fromRGB(28, 18, 46)
    dim.BackgroundTransparency = 1
    dim.BorderSizePixel = 0
    dim.Parent = splash

    local card = Instance.new("Frame")
    card.Size = UDim2.new(0, 340, 0, 120)
    card.Position = UDim2.new(0.5, -170, 0.5, -60)
    card.BackgroundColor3 = Color3.fromRGB(228, 218, 250)
    card.BorderSizePixel = 0
    card.BackgroundTransparency = 0.92
    card.Parent = splash

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 10)
    cardCorner.Parent = card

    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = Color3.fromRGB(126, 92, 208)
    cardStroke.Thickness = 2
    cardStroke.Transparency = 0.92
    cardStroke.Parent = card

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 1, -50)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Project Zinc"
    title.TextColor3 = Color3.fromRGB(38, 24, 62)
    title.TextTransparency = 0.92
    title.Font = Enum.Font.GothamBold
    title.TextSize = 28
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.TextYAlignment = Enum.TextYAlignment.Center
    title.Parent = card

    local barBG = Instance.new("Frame")
    barBG.Size = UDim2.new(1, -60, 0, 4)
    barBG.Position = UDim2.new(0, 30, 1, -30)
    barBG.BackgroundColor3 = Color3.fromRGB(198, 180, 245)
    barBG.BackgroundTransparency = 0.92
    barBG.BorderSizePixel = 0
    barBG.Parent = card

    local barBGCorner = Instance.new("UICorner")
    barBGCorner.CornerRadius = UDim.new(1, 0)
    barBGCorner.Parent = barBG

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 0, 1, 0)
    bar.BackgroundColor3 = Color3.fromRGB(126, 92, 208)
    bar.BackgroundTransparency = 0.92
    bar.BorderSizePixel = 0
    bar.Parent = barBG

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = bar

    -- Subtle scale lift alongside the fade. Starting just under full size and
    -- easing up reads as the card settling into place rather than popping in.
    local scale = Instance.new("UIScale")
    scale.Scale = 0.94
    scale.Parent = card

    local fadeIn = TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    TweenService:Create(dim, fadeIn, { BackgroundTransparency = 0.35 }):Play()
    TweenService:Create(scale, fadeIn, { Scale = 1 }):Play()
    TweenService:Create(card, fadeIn, { BackgroundTransparency = 0 }):Play()
    TweenService:Create(cardStroke, fadeIn, { Transparency = 0 }):Play()
    TweenService:Create(title, fadeIn, { TextTransparency = 0 }):Play()
    TweenService:Create(barBG, fadeIn, { BackgroundTransparency = 0 }):Play()
    TweenService:Create(bar, fadeIn, { BackgroundTransparency = 0 }):Play()

    -- Delayed so the sweep begins once the card has settled, rather than
    -- running underneath the fade-in.
    TweenService:Create(
        bar,
        TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0.5),
        { Size = UDim2.new(1, 0, 1, 0) }
    ):Play()

    -- Blocking on purpose. Everything after this point waits for the splash
    -- to finish, so the main window only appears once it has cleared.
    task.wait(2)

    local fadeOut = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    TweenService:Create(dim, fadeOut, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(card, fadeOut, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(cardStroke, fadeOut, { Transparency = 1 }):Play()
    TweenService:Create(title, fadeOut, { TextTransparency = 1 }):Play()
    TweenService:Create(barBG, fadeOut, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(bar, fadeOut, { BackgroundTransparency = 1 }):Play()

    task.wait(0.5)
    splash:Destroy()
end

-- The endpoint returns a small bootstrap chunk, not the full library, so
-- there is deliberately no minimum size check here. An earlier version of
-- this loader rejected anything under 1000 bytes and broke a working load.
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

if type(Rayfield) ~= "table" then
    warn("[Zinc] Rayfield Gen2 did not load. Got: " .. type(Rayfield))
    return
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GAMEPASS_ID = 149827570

-- Used by the Find Player tab to re-run this script after a server hop.
-- Must point at wherever this exact build is hosted.
local SCRIPT_URL = "https://raw.githubusercontent.com/GatoCooL123/Script/main/ProjectZincGen2.lua"

-- ==================== LAVENDER THEME ====================
-- Light surfaces, so every text key is set dark for contrast.
-- Same structure as before: strokes off, elements darker than the window.
local LAV_LIGHT = Color3.fromRGB(198, 180, 245)
local LAV_MID   = Color3.fromRGB(178, 156, 236)
local LAV_DEEP  = Color3.fromRGB(146, 118, 218)
local LAV_PALE  = Color3.fromRGB(228, 218, 250)
local INK       = Color3.fromRGB(38, 24, 62)
local INK_SOFT  = Color3.fromRGB(84, 68, 116)

local window = Rayfield:CreateWindow({
    name = "Project Zinc",
    theme = {
        -- window and shape
        WindowColor = ColorSequence.new(Color3.fromRGB(234, 226, 252), Color3.fromRGB(216, 204, 246)),
        -- SurfaceStroke is a faint rim with no transparency key, so contrast
        -- is the only lever. A deep purple reads on the light window.
        SurfaceStroke = Color3.fromRGB(64, 40, 104),
        ShadowColor = Color3.fromRGB(46, 28, 78),
        LiveAnimation = true,

        -- text
        ContentColor = INK,
        TitlingColor = INK,
        ElementTextHoverColor = Color3.fromRGB(0, 0, 0),
        ActionColor = INK,
        PlaceholderColor = INK_SOFT,

        -- tabs. Unselected pills are dimmed from TabBackground automatically,
        -- so this is kept bright and the text is dark enough to read on both.
        TabColor = INK,
        TabBackground = ColorSequence.new(LAV_LIGHT, LAV_MID),
        TabStroke = ColorSequence.new(LAV_DEEP, LAV_MID),

        -- elements
        -- Strokes stay switched off (transparency 1) because Gen2's gradient
        -- stroke fades along its length and cannot be made uniform from the
        -- theme table. Edges read from fill contrast against the window.
        ElementGradient = ColorSequence.new(Color3.fromRGB(194, 176, 242), Color3.fromRGB(176, 154, 234)),
        ElementStrokeTransparency = 1,
        ElementStrokeHoverTransparency = 1,
        StatBackground = Color3.fromRGB(194, 176, 242),

        -- controls
        AccentColor = Color3.fromRGB(126, 92, 208),
        AccentStroke = Color3.fromRGB(126, 92, 208),
        SliderBackground = LAV_PALE,
        SliderBackgroundHover = Color3.fromRGB(220, 210, 248),
        SliderProgress = ColorSequence.new(LAV_MID, LAV_DEEP),
        SliderStroke = LAV_DEEP,
        SliderHandle = Color3.fromRGB(255, 255, 255),
        ToggleTrack = LAV_PALE,
        ToggleKnobOff = Color3.fromRGB(255, 255, 255),
        DarkToggleOverlay = true,
        DropdownHighlight = LAV_MID,

        -- fields and buttons
        -- Same fill as elements so the dropdown and buttons sit at one tone,
        -- darker than the window behind them. FieldGlow matches the fill so
        -- it adds no halo.
        FieldBackground = Color3.fromRGB(194, 176, 242),
        FieldTransparency = 0,
        FieldGlow = Color3.fromRGB(194, 176, 242),
        NeutralButton = Color3.fromRGB(194, 176, 242),
        NeutralButtonHover = Color3.fromRGB(176, 154, 234),
        NeutralButtonStroke = Color3.fromRGB(194, 176, 242),
    },
    configuration = {
        autoSave = true,
        autoLoad = true,
        fileName = "ProjectZinc",
    },
})

-- Notify wrapper. Each API gets a payload in its own casing; a merged table
-- with both casings can fail validation and make a working Notify look broken.
local function notify(title, content)
    if typeof(window) == "table" and typeof(window.Notify) == "function" then
        if pcall(function()
            window:Notify({ title = title, content = content })
        end) then return end
    end
    if typeof(Rayfield) == "table" and typeof(Rayfield.Notify) == "function" then
        if pcall(function()
            Rayfield:Notify({ Title = title, Content = content, Duration = 5 })
        end) then return end
    end
end

local function PurchaseItem(itemName)
    local remote = ReplicatedStorage:FindFirstChild("Purchasing")
    if not remote then
        notify("Failed", "Purchasing remote not found")
        return false
    end
    local ok = pcall(function()
        remote:InvokeServer(itemName, GAMEPASS_ID)
    end)
    return ok
end

-- ==================== ITEM LISTS ====================

local rareIQs = {
    "IQ Rainbow", "IQ 30M", "IQ 100K Trophy",
    "IQ 1 Decillion", "IQ 601 Nonillion", "IQ",
    "IQ 4.6B", "IQ 945M", "Robux Trophy",
    "IQ -68M", "IQ 100 Decillion Trophy", "IQ 1 Googol",
    "IQ 200K Trophy", "IQ 10 Nonillion", "IQ 2 Vigintillion Medal",
    "IQ 101K Trophy", "IQ 45M", "IQ 3.5 Trigentillion",
    "IQ 845M", "Arena Trophy", "IQ 1 Nonillion",
    "IQ 1 Quadrillion", "IQ 4M", "IQ 5 Quintillion",
    "IQ 1 Googol Medal", "IQ 20 Trophy", "IQ poopillion diarrhea",
    "IQ 2 Septillion", "IQ poopy", "IQ 305M",
    "IQ -43 Nonillion", "IQ 1 Trophy", "IQ 999 Quadrillion",
    "IQ 40 Trophy", "IQ 4 Septillion", "IQ 1 Googolplex",
    "IQ 400K Trophy", "IQ 1 Septillion", "IQ 1 Octillion",
    "IQ 150K Trophy", "IQ 999,999", "IQ 10 Decillion Medal",
    "IQ 100 Trophy", "IQ 1 Trigentillion", "IQ 32T Medal",
    "IQ 1.5 Nonillion", "IQ Obby", "IQ 1Q Piece",
    "IQ 55 Septillion", "IQ 232 Decillion", "IQ 1.1B Trophy",
    "IQ -1 Billion Medal", "IQ 1 Octillion Concept", "IQ 1A7",
    "IQ -300M", "IQ 650M Trophy", "IQ 13M",
    "Cosmic", "IQ 4,300,000", "IQ 2M Trophy",
    "IQ 97M", "IQ 16M", "IQ 1 Centillion",
    "IQ 450 Quadrillion", "IQ Concept", "IQ 7M",
    "IQ 36K Trophy", "IQ 200M", "IQ 500K Trophy",
    "IQ 1 Decillion Concept", "IQ 2 Nonillion Medal", "IQ 702 Decillion",
    "IQ 300K Trophy", "IQ 9M", "IQ 250M",
    "IQ 1.2 Septillion", "IQ 200 Trophy", "IQ 50K Trophy",
    "IQ 1.1 Quadrillion", "IQ 1T Medal", "Battle Trophy",
    "IQ 39M", "IQ 1 Quintillion", "IQ 0 Trophy",
    "IQ 1.3M Trophy", "IQ 18M", "Galaxy",
    "Virus Trophy", "Supporter Trophy", "IQ 1.5M Trophy",
    "IQ -71M", "IQ 660 Quadrillion", "IQ 1....K Trophy",
    "IQ 1B Piece", "IQ 3 Nonillion Medal", "IQ 200 Trillion",
    "10M VISITS TROPHY", "IQ poopillion", "IQ 20K Trophy",
    "IQ 21M", "IQ 1 Vigintillion Medal", "IQ 50 Quintillion",
    "IQ -32 Nonillion", "IQ -250,505,505", "IQ 1T Piece"
}

local cool = {
    "Spray", "Moneybag", "Ajwa",
    "Acceleration Coil", "SpaceSandwich", "Hawk",
    "Weapon Of IQ 999.9M", "WizardFlySpell", "Chocolate Bar",
    "StarbloxLatte", "Smore", "IQ Brain Cell",
    "IQ 999.9M"
}

local recolored = {
    "IQ 50M Trophy", "IQ 20K Trophy", "Solar Glove Recoloured",
    "IQ 1.5M Trophy", "IQ 1.2 Septillion", "IQ 1.1 Quadrillion",
    "IQ 150K Trophy", "IQ 3.5 Trigentillion", "IQ 15M",
    "IQ 2 Septillion", "IQ 1.3M Trophy", "IQ 16M",
    "IQ -71M", "IQ 1.5 Nonillion", "IQ 1.1B Trophy",
    "IQ 5 Quintillion", "IQ 1T Medal Anniversary Skin", "IQ 7M",
    "IQ 2 Vigintillion Medal"
}

local useful = {
    "EmeraldSpaceship", "Gold Spaceship", "Chocolate Bar",
    "IQ 4.6B", "IQ 50 Quintillion", "Classic Plane",
    "IQ 39M", "Spaceship", "Carbon Fiber Spaceship",
    "Galaxy Warp", "Acceleration Coil", "IQ Brain Cell",
    "SapphireSpaceship", "RubySpaceship", "Galaxy Spaceship",
    "Bronze Spaceship", "Ajwa", "RidableUFO",
    "AmethystSpaceship", "IQ 601 Nonillion", "IQ 232 Decillion",
    "IQ 702 Decillion", "Toy Spaceship"
}

local minis = {
    "IQ Omega Mini's", "IQ 400K Trophy Mini", "IQ 50K Trophy Mini",
    "IQ 1 Septillion Mini's", "IQ 1T Medal Mini's", "IQ 1 Googol Medal Mini's",
    "IQ 200K Trophy Mini", "IQ 1B Trophy Mini's", "Mini IQ -1 Billion Medal",
    "IQ 36K Trophy Mini", "IQ 20QA Medal Mini's", "IQ 1 Trigentillion Mini's",
    "IQ 100K Trophy Mini", "IQ 300K Trophy Mini", "IQ 500K Trophy Mini"
}

local ogs = {
    "IQ 1 Quadrillion OG", "IQ 10 Nonillion", "IQ 13M",
    "IQ 1 Nonillion OG", "IQ 1 Quintillion OG", "IQ 1 Decillion OG",
    "IQ 1 Googol", "IQ 1B OG", "IQ 1 Septillion OG",
    "IQ 1T OG"
}

local dangerous = {
    "MedusaHead", "BodySwapPotion", "Galaxy Katana",
    "LaserScythe", "HexSpitter", "RageTable",
    "BananaPeel", "FreezeRay", "Solar Glove",
    "Solar Glove Recoloured", "LaserFingerPointers", "RedHyperLaser",
    "EarthOrb", "FuseBomb", "DoubleCheezburger",
    "ultimate cheese", "InfinityGauntlet", "ThrowingBarrel",
    "Flying Telescope", "Fivetuple Cheese Burger", "Taser",
    "Redstone Sword"
}

-- ==================== SHARED TAB BUILDER ====================

-- Builds a searchable multi-select dropdown plus spawn controls.
-- The dropdown filters as you type, which handles long lists far better
-- than one button per item.
local function BuildCategoryTab(tabName, sectionName, items)
    local tab = window:CreateTab({ name = tabName })
    tab:CreateSection({ name = sectionName })

    local selected = {}

    local dropdown = tab:CreateDropdown({
        name = "Select items",
        options = items,
        multiSelect = true,
        placeholder = "Nothing selected",
        forgetState = true,
        callback = function(choice)
            selected = choice
        end,
    })

    tab:CreateButton({
        name = "Spawn selected",
        callback = function()
            if #selected == 0 then
                notify("Nothing selected", "Pick at least one item first.")
                return
            end
            local count = #selected
            notify("Spawning", count .. " item(s)...")
            task.spawn(function()
                for _, name in ipairs(selected) do
                    PurchaseItem(name)
                    task.wait(0.1)
                end
                notify("Done", "Spawned " .. count .. " item(s).")
            end)
        end,
    })

    tab:CreateButton({
        name = "Spawn all in this tab",
        callback = function()
            notify("Spawning", "All " .. #items .. " items...")
            task.spawn(function()
                for _, name in ipairs(items) do
                    PurchaseItem(name)
                    task.wait(0.1)
                end
                notify("Done", "Spawned " .. #items .. " items.")
            end)
        end,
    })

    tab:CreateButton({
        name = "Clear selection",
        callback = function()
            dropdown:Set({})
            selected = {}
        end,
    })

    return tab
end

BuildCategoryTab("IQ Trophies", "IQ Trophies", rareIQs)
BuildCategoryTab("Interesting", "Interesting Items", cool)
BuildCategoryTab("Recolored", "Recolored Trophies", recolored)
BuildCategoryTab("Useful", "Useful Items", useful)
BuildCategoryTab("Minis", "Mini Trophies", minis)
BuildCategoryTab("OG", "OG Trophies", ogs)

-- ==================== HARMFUL ====================

local harmfulTab = BuildCategoryTab("Harmful", "Harmful Items", dangerous)

harmfulTab:CreateSection({ name = "Special" })

harmfulTab:CreateButton({
    name = "Slap (search players)",
    callback = function()
        local foundTool = nil
        local function searchContainer(container)
            if not container then return nil end
            for _, child in ipairs(container:GetChildren()) do
                if child:IsA("Tool") and child.Name:lower():find("slap") then
                    return child
                end
            end
            return nil
        end

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= lplayer then
                foundTool = searchContainer(p.Backpack) or searchContainer(p.Character)
                if foundTool then break end
            end
        end

        if foundTool then
            local cloned = foundTool:Clone()
            cloned.Parent = lplayer.Backpack
            PurchaseItem(foundTool.Name)
            notify("Slap", "Found and cloned: " .. foundTool.Name)
        else
            PurchaseItem("Slap")
            notify("Slap", "No player had it, requested by name.")
        end
    end,
})

-- ==================== CUSTOM TROPHIES ====================

local customTab = window:CreateTab({ name = "Custom" })
customTab:CreateSection({ name = "Custom Trophies" })

customTab:CreateButton({
    name = "IQ Omega",
    callback = function()
        local char = lplayer.Character
        if not char then
            notify("Failed", "No character loaded.")
            return
        end

        PurchaseItem("IQ 1B Trophy Mini's")
        PurchaseItem("IQ 1 Quintillion")
        PurchaseItem("IQ 1Q Piece")
        PurchaseItem("IQ 1T OG")
        task.wait(1)

        local backpack = lplayer.Backpack

        local mini = backpack:FindFirstChild("IQ 1B Trophy Mini's")
            or char:FindFirstChild("IQ 1B Trophy Mini's")
        if mini then
            for _, v in pairs(mini:GetDescendants()) do
                if v:IsA("LocalScript") then v:Destroy() end
            end
        end

        local rightHand = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")

        local function applyAndWeld(toolName, gripPos, gripCFrame)
            local tool = backpack:FindFirstChild(toolName)
            if not tool or not tool:IsA("Tool") then return end
            if gripPos then tool.GripPos = gripPos end
            if gripCFrame then tool.Grip = gripCFrame end
            tool.Parent = char
            task.wait(0.05)
            local handle = tool:FindFirstChild("Handle")
            if handle and rightHand then
                handle.CanCollide = false
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = rightHand
                weld.Part1 = handle
                weld.Parent = handle
            end
            task.wait(0.05)
            if gripPos then tool.GripPos = gripPos end
            if gripCFrame then tool.Grip = gripCFrame end
        end

        applyAndWeld("IQ 1B Trophy Mini's", Vector3.new(-5, -1, -4), nil)
        applyAndWeld("IQ 1Q Piece", nil, nil)
        applyAndWeld("IQ 1T OG", nil, CFrame.new(-5.5, 0, -7) * CFrame.Angles(math.rad(15), 0, 0))
        applyAndWeld("IQ 1 Quintillion", Vector3.new(0, 0, 0), nil)

        notify("IQ Omega", "Setup complete.")
    end,
})

customTab:CreateButton({
    name = "IQ Unreal",
    callback = function()
        local char = lplayer.Character
        if not char then
            notify("Failed", "No character loaded.")
            return
        end

        PurchaseItem("IQ 1B Trophy Mini's")
        PurchaseItem("IQ 1 Quintillion")
        PurchaseItem("IQ 1Q Piece")
        PurchaseItem("IQ 1T OG")
        PurchaseItem("IQ 100 Decillion Trophy")
        PurchaseItem("Cosmic")
        task.wait(1)

        local backpack = lplayer.Backpack

        local mini = backpack:FindFirstChild("IQ 1B Trophy Mini's")
            or char:FindFirstChild("IQ 1B Trophy Mini's")
        if mini then
            for _, v in pairs(mini:GetDescendants()) do
                if v:IsA("LocalScript") then v:Destroy() end
            end
        end

        local gripData = {
            { name = "IQ 1B Trophy Mini's",     pos = Vector3.new(-5, -1, -4),       rot = Vector3.new(0, 0, 0) },
            { name = "IQ 1Q Piece",             pos = Vector3.new(1.18, -3.25, -5),  rot = Vector3.new(84.86, 9+180, 180) },
            { name = "IQ 1T OG",                pos = Vector3.new(-5.5, 0, -7),      rot = Vector3.new(15, 0, 0) },
            { name = "IQ 1 Quintillion",        pos = Vector3.new(0, 0, 0),          rot = Vector3.new(0, 0, 0) },
            { name = "IQ 100 Decillion Trophy", pos = Vector3.new(-700, -5, 5),      rot = Vector3.new(-95.14, 0+180, 91.29) },
            { name = "Cosmic",                  pos = Vector3.new(-20, -50, 0.79),   rot = Vector3.new(0, -87.43+180, 0) },
        }

        local rightHand = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")

        local function ApplyGripFE(tool, pos, rotX, rotY, rotZ)
            if not tool or not tool:IsA("Tool") then return end
            local gripCF = CFrame.new(pos) * CFrame.Angles(math.rad(rotX), math.rad(rotY), math.rad(rotZ))
            tool.GripPos     = gripCF.Position
            tool.GripRight   = gripCF.RightVector
            tool.GripUp      = gripCF.UpVector
            tool.GripForward = -gripCF.LookVector
        end

        for _, item in ipairs(gripData) do
            local tool = backpack:FindFirstChild(item.name)
            if tool and tool:IsA("Tool") then
                ApplyGripFE(tool, item.pos, item.rot.X, item.rot.Y, item.rot.Z)
                tool.Parent = char
                task.wait(0.05)
                local handle = tool:FindFirstChild("Handle")
                if handle and rightHand then
                    handle.CanCollide = false
                    local weld = Instance.new("WeldConstraint")
                    weld.Part0 = rightHand
                    weld.Part1 = handle
                    weld.Parent = handle
                end
            end
        end

        notify("IQ Unreal", "Setup complete.")
    end,
})

-- ==================== MANUAL ====================

local manualTab = window:CreateTab({ name = "Manual" })
manualTab:CreateSection({ name = "Spawn by name" })

manualTab:CreateInput({
    name = "Item name",
    description = "Exact name, case sensitive.",
    placeholder = "IQ 1 Quintillion",
    callback = function(text)
        if text and #text > 0 then
            PurchaseItem(text)
            notify("Requested", text)
        end
    end,
})

-- ==================== FIND PLAYER ====================
-- Server rosters are not exposed by the API, so the only way to find someone
-- is to join a server and read Players:GetPlayers(). That means the hop has to
-- survive teleports: state is written to a file and the script is re-queued
-- with queueonteleport so it resumes automatically in the next server.

local findTab = window:CreateTab({ name = "Find Player" })
findTab:CreateSection({ name = "Server hop until found" })

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local STATE_FILE = "ProjectZinc_hop.json"
local targetName = ""

local function hasFileSupport()
    return typeof(writefile) == "function"
        and typeof(readfile) == "function"
        and typeof(isfile) == "function"
end

local function loadState()
    if not hasFileSupport() or not isfile(STATE_FILE) then return nil end
    local ok, data = pcall(function()
        return HttpService:JSONDecode(readfile(STATE_FILE))
    end)
    return ok and data or nil
end

local function saveState(state)
    if not hasFileSupport() then return end
    pcall(function()
        writefile(STATE_FILE, HttpService:JSONEncode(state))
    end)
end

local function clearState()
    if hasFileSupport() and isfile(STATE_FILE) then
        pcall(function() delfile(STATE_FILE) end)
    end
end

-- Case-insensitive match on either username or display name.
local function findTargetHere(name)
    local wanted = name:lower()
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower() == wanted or p.DisplayName:lower() == wanted then
            return p
        end
    end
    return nil
end

-- game:HttpGet frequently fails against games.roblox.com. Executors expose a
-- fuller request function that works where HttpGet does not, so try those
-- first and fall back to HttpGet.
local function httpGet(url)
    local req = (syn and syn.request)
        or (http and http.request)
        or (fluxus and fluxus.request)
        or http_request
        or request

    if typeof(req) == "function" then
        local ok, res = pcall(function()
            return req({ Url = url, Method = "GET" })
        end)
        if ok and res and res.Body and res.StatusCode and res.StatusCode < 400 then
            return res.Body
        end
    end

    local ok, body = pcall(function()
        return game:HttpGet(url)
    end)
    return ok and body or nil
end

local function fetchServers(cursor)
    local url = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100")
        :format(game.PlaceId)
    if cursor and cursor ~= "" then
        url = url .. "&cursor=" .. cursor
    end

    local body = httpGet(url)
    if not body then
        warn("[Zinc] server list request failed")
        return nil
    end

    local ok, decoded = pcall(function()
        return HttpService:JSONDecode(body)
    end)
    if not ok then
        warn("[Zinc] could not decode server list")
        return nil
    end
    return decoded
end

local function hopToNext(state)
    local cursor = state.cursor or ""
    for _ = 1, 10 do
        local data = fetchServers(cursor)
        if not data or not data.data then
            notify("Find Player", "Could not list servers.")
            return false
        end

        for _, server in ipairs(data.data) do
            if server.id ~= game.JobId
                and not state.visited[server.id]
                and server.playing < server.maxPlayers
            then
                state.visited[server.id] = true
                state.cursor = data.nextPageCursor or ""
                saveState(state)

                if typeof(queueonteleport) ~= "function" then
                    notify("Find Player", "Executor lacks queueonteleport, cannot resume.")
                    clearState()
                    return false
                end
                queueonteleport(state.script)
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, lplayer)
                return true
            end
        end

        cursor = data.nextPageCursor or ""
        if cursor == "" then
            notify("Find Player", "Searched every server. Not found.")
            clearState()
            return false
        end
    end
    return false
end

findTab:CreateInput({
    name = "Username",
    description = "Username or display name.",
    placeholder = "Builderman",
    callback = function(text)
        targetName = text or ""
    end,
})

findTab:CreateButton({
    name = "Start searching",
    callback = function()
        if targetName == "" then
            notify("Find Player", "Enter a username first.")
            return
        end

        if not hasFileSupport() then
            notify("Find Player", "Executor lacks file support, cannot resume after hop.")
            return
        end

        local here = findTargetHere(targetName)
        if here then
            notify("Found", targetName .. " is in this server.")
            return
        end

        local state = {
            target = targetName,
            visited = { [game.JobId] = true },
            cursor = "",
            -- re-runs this whole script in the next server so the search continues
            script = ('loadstring(game:HttpGet("%s"))()'):format(SCRIPT_URL),
        }
        saveState(state)
        notify("Find Player", "Hopping...")
        hopToNext(state)
    end,
})

findTab:CreateButton({
    name = "Stop searching",
    callback = function()
        clearState()
        notify("Find Player", "Search stopped.")
    end,
})

-- Resume automatically if we arrived here mid-search.
task.spawn(function()
    local state = loadState()
    if not state or not state.target then return end

    task.wait(3)

    local found = findTargetHere(state.target)
    if found then
        clearState()
        notify("Found", state.target .. " is in this server.")
        return
    end

    notify("Find Player", "Not here, hopping...")
    task.wait(1)
    hopToNext(state)
end)

-- ==================== CREDITS ====================

local creditsTab = window:CreateTab({ name = "Credits" })
creditsTab:CreateSection({ name = "Full credits to Gato (me)" })
creditsTab:CreateSection({ name = "Credits to Ninecell for the idea" })
creditsTab:CreateSection({ name = "Slap tool by Creeper_seek" })
