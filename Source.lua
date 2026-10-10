-- ============================================================
-- APEX UI - Librería de interfaz para Roblox
-- Creador: AlexOfficial
-- Licencia: MIT
-- Estilo: Speed Hub X
-- ============================================================

local ApexUI = {}
ApexUI.__index = ApexUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- ============================================================
-- TEMAS
-- ============================================================
local Themes = {
    Default = {
        Background = Color3.fromRGB(18, 18, 22),
        Header = Color3.fromRGB(25, 25, 32),
        Accent = Color3.fromRGB(155, 92, 246),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(160, 160, 175),
        Element = Color3.fromRGB(32, 32, 40),
        ToggleOff = Color3.fromRGB(55, 55, 65),
        Transparency = 0.15
    },
    Dark = {
        Background = Color3.fromRGB(10, 10, 14),
        Header = Color3.fromRGB(18, 18, 24),
        Accent = Color3.fromRGB(120, 80, 220),
        Text = Color3.fromRGB(240, 240, 245),
        SubText = Color3.fromRGB(140, 140, 155),
        Element = Color3.fromRGB(25, 25, 32),
        ToggleOff = Color3.fromRGB(45, 45, 55),
        Transparency = 0.2
    },
    Light = {
        Background = Color3.fromRGB(245, 245, 250),
        Header = Color3.fromRGB(235, 235, 242),
        Accent = Color3.fromRGB(100, 60, 200),
        Text = Color3.fromRGB(25, 25, 35),
        SubText = Color3.fromRGB(85, 85, 95),
        Element = Color3.fromRGB(225, 225, 235),
        ToggleOff = Color3.fromRGB(190, 190, 200),
        Transparency = 0.1
    },
    Amethyst = {
        Background = Color3.fromRGB(25, 18, 38),
        Header = Color3.fromRGB(35, 25, 50),
        Accent = Color3.fromRGB(170, 100, 255),
        Text = Color3.fromRGB(255, 250, 255),
        SubText = Color3.fromRGB(190, 170, 210),
        Element = Color3.fromRGB(45, 32, 62),
        ToggleOff = Color3.fromRGB(70, 52, 92),
        Transparency = 0.15
    },
    SpeedHub = {
        Background = Color3.fromRGB(12, 12, 16),
        Header = Color3.fromRGB(20, 20, 26),
        Accent = Color3.fromRGB(255, 60, 60),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(150, 150, 160),
        Element = Color3.fromRGB(28, 28, 36),
        ToggleOff = Color3.fromRGB(50, 50, 60),
        Transparency = 0.15
    }
}

local CurrentTheme = Themes.SpeedHub

-- ============================================================
-- AUXILIARES
-- ============================================================
local function Create(className, props)
    local inst = Instance.new(className)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    return inst
end

local function Tween(obj, time, props, style, direction)
    local info = TweenInfo.new(
        time or 0.2,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

local function MakeDraggable(frame, dragArea)
    dragArea = dragArea or frame
    local dragging = false
    local dragStart, startPos

    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    dragArea.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ============================================================
-- VENTANA
-- ============================================================
function ApexUI:CreateWindow(title)
    local self = setmetatable({}, ApexUI)
    self.Tabs = {}
    self.CurrentTab = nil

    self.ScreenGui = Create("ScreenGui", {
        Name = "ApexUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui
    })

    -- Ventana más pequeña y con transparencia
    self.Main = Create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 420, 0, 320),
        Position = UDim2.new(0.5, -210, 0.5, -160),
        BackgroundColor3 = CurrentTheme.Background,
        BackgroundTransparency = CurrentTheme.Transparency,
        BorderSizePixel = 0,
        Active = true,
        ClipsDescendants = true,
        Parent = self.ScreenGui
    })

    Create("UICorner", { CornerRadius = UDim.new(0, 14), Parent = self.Main })
    Create("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 1.5,
        Transparency = 0.35,
        Parent = self.Main
    })

    -- Animación de entrada
    self.Main.Size = UDim2.new(0, 0, 0, 0)
    self.Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Tween(self.Main, 0.35, {
        Size = UDim2.new(0, 420, 0, 320),
        Position = UDim2.new(0.5, -210, 0.5, -160)
    }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    -- Barra de título
    local titleBar = Create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = CurrentTheme.Header,
        BackgroundTransparency = CurrentTheme.Transparency,
        BorderSizePixel = 0,
        Parent = self.Main
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 14), Parent = titleBar })
    Create("Frame", {
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = CurrentTheme.Header,
        BackgroundTransparency = CurrentTheme.Transparency,
        BorderSizePixel = 0,
        Parent = titleBar
    })

    -- Indicador de color (línea accent)
    Create("Frame", {
        Size = UDim2.new(0, 3, 0, 20),
        Position = UDim2.new(0, 12, 0.5, -10),
        BackgroundColor3 = CurrentTheme.Accent,
        BorderSizePixel = 0,
        Parent = titleBar
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = titleBar:FindFirstChildWhichIsA("Frame", true) })

    Create("TextLabel", {
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 22, 0, 0),
        BackgroundTransparency = 1,
        Text = title or "Apex UI",
        TextColor3 = CurrentTheme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })

    -- Botones minimizar/cerrar
    local minBtn = Create("TextButton", {
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(1, -52, 0, 6),
        BackgroundColor3 = Color3.fromRGB(240, 180, 60),
        BackgroundTransparency = 0.1,
        Text = "—",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        AutoButtonColor = false,
        Parent = titleBar
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = minBtn })

    local closeBtn = Create("TextButton", {
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(1, -26, 0, 6),
        BackgroundColor3 = Color3.fromRGB(220, 60, 60),
        BackgroundTransparency = 0.1,
        Text = "X",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        AutoButtonColor = false,
        Parent = titleBar
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = closeBtn })

    -- Hover animado
    minBtn.MouseEnter:Connect(function()
        Tween(minBtn, 0.15, { BackgroundTransparency = 0 })
    end)
    minBtn.MouseLeave:Connect(function()
        Tween(minBtn, 0.15, { BackgroundTransparency = 0.1 })
    end)
    closeBtn.MouseEnter:Connect(function()
        Tween(closeBtn, 0.15, { BackgroundTransparency = 0 })
    end)
    closeBtn.MouseLeave:Connect(function()
        Tween(closeBtn, 0.15, { BackgroundTransparency = 0.1 })
    end)

    closeBtn.MouseButton1Click:Connect(function()
        Tween(self.Main, 0.25, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.26)
        self.ScreenGui:Destroy()
    end)

    minBtn.MouseButton1Click:Connect(function()
        local isMinimized = self.Main.Size.Y.Offset < 100
        Tween(self.Main, 0.25, {
            Size = isMinimized and UDim2.new(0, 420, 0, 320) or UDim2.new(0, 420, 0, 34)
        }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    end)

    MakeDraggable(self.Main, titleBar)

    -- Sidebar con animación
    self.Sidebar = Create("ScrollingFrame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 115, 1, -46),
        Position = UDim2.new(0, 10, 0, 42),
        BackgroundColor3 = CurrentTheme.Header,
        BackgroundTransparency = CurrentTheme.Transparency,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = CurrentTheme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = self.Main
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = self.Sidebar })
    Create("UIListLayout", {
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.Sidebar
    })
    Create("UIPadding", {
        PaddingTop = UDim.new(0, 6),
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6),
        PaddingBottom = UDim.new(0, 6),
        Parent = self.Sidebar
    })

    -- Contenido
    self.Content = Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -135, 1, -46),
        Position = UDim2.new(0, 125, 0, 42),
        BackgroundColor3 = CurrentTheme.Header,
        BackgroundTransparency = CurrentTheme.Transparency,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = self.Main
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = self.Content })

    return self
end

-- ============================================================
-- PESTAÑAS
-- ============================================================
function ApexUI:CreateTab(name)
    local tab = { Name = name, Sections = {} }

    local btn = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = CurrentTheme.Background,
        BackgroundTransparency = 0.3,
        Text = name,
        TextColor3 = CurrentTheme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        AutoButtonColor = false,
        Parent = self.Sidebar
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = btn })

    local frame = Create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = CurrentTheme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = self.Content
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = frame
    })
    Create("UIPadding", {
        PaddingTop = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8),
        Parent = frame
    })

    tab.Button = btn
    tab.Frame = frame

    btn.MouseEnter:Connect(function()
        if self.CurrentTab ~= tab then
            Tween(btn, 0.15, { BackgroundColor3 = CurrentTheme.Element })
        end
    end)
    btn.MouseLeave:Connect(function()
        if self.CurrentTab ~= tab then
            Tween(btn, 0.15, { BackgroundColor3 = CurrentTheme.Background })
        end
    end)

    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do
            t.Frame.Visible = false
            Tween(t.Button, 0.2, { BackgroundColor3 = CurrentTheme.Background })
        end
        frame.Visible = true
        Tween(btn, 0.2, { BackgroundColor3 = CurrentTheme.Accent })
        self.CurrentTab = tab

        -- Animación de apertura del frame
        frame.Position = UDim2.new(0, 5, 0, 0)
        Tween(frame, 0.2, { Position = UDim2.new(0, 0, 0, 0) })
    end)

    table.insert(self.Tabs, tab)

    if #self.Tabs == 1 then
        frame.Visible = true
        btn.BackgroundColor3 = CurrentTheme.Accent
        self.CurrentTab = tab
    end

    return tab
end

-- ============================================================
-- SECCIONES
-- ============================================================
function ApexUI:CreateSection(tab, name)
    local section = { Name = name }

    local wrapper = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = tab.Frame
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = wrapper
    })

    local label = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = "▸ " .. name,
        TextColor3 = CurrentTheme.Accent,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = wrapper
    })

    local container = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = wrapper
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = container
    })

    section.Label = label
    section.Frame = container

    return section
end

-- ============================================================
-- BOTÓN
-- ============================================================
function ApexUI:CreateButton(section, name, callback)
    local btn = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = CurrentTheme.Element,
        BackgroundTransparency = 0.2,
        Text = name,
        TextColor3 = CurrentTheme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        AutoButtonColor = false,
        Parent = section.Frame
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = btn })
    Create("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 1,
        Transparency = 0.6,
        Parent = btn
    })

    btn.MouseEnter:Connect(function()
        Tween(btn, 0.15, {
            BackgroundColor3 = CurrentTheme.Accent,
            BackgroundTransparency = 0
        })
    end)
    btn.MouseLeave:Connect(function()
        Tween(btn, 0.15, {
            BackgroundColor3 = CurrentTheme.Element,
            BackgroundTransparency = 0.2
        })
    end)

    btn.MouseButton1Click:Connect(function()
        -- Animación de click
        Tween(btn, 0.08, { Size = UDim2.new(0.97, 0, 0, 28) }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        task.wait(0.08)
        Tween(btn, 0.1, { Size = UDim2.new(1, 0, 0, 28) }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        if callback then callback() end
    end)

    return btn
end

-- ============================================================
-- TOGGLE
-- ============================================================
function ApexUI:CreateToggle(section, name, default, callback)
    local state = default or false

    local container = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = CurrentTheme.Element,
        BackgroundTransparency = 0.2,
        Parent = section.Frame
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = container })
    Create("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 1,
        Transparency = 0.6,
        Parent = container
    })

    Create("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = CurrentTheme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })

    local toggleBtn = Create("TextButton", {
        Size = UDim2.new(0, 36, 0, 18),
        Position = UDim2.new(1, -46, 0.5, -9),
        BackgroundColor3 = state and CurrentTheme.Accent or CurrentTheme.ToggleOff,
        Text = "",
        AutoButtonColor = false,
        Parent = container
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = toggleBtn })

    local circle = Create("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
        BackgroundColor3 = Color3.new(1, 1, 1),
        Parent = toggleBtn
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = circle })

    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        Tween(toggleBtn, 0.2, {
            BackgroundColor3 = state and CurrentTheme.Accent or CurrentTheme.ToggleOff
        })
        Tween(circle, 0.2, {
            Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        })
        if callback then callback(state) end
    end)

    return toggleBtn
end

-- ============================================================
-- SLIDER
-- ============================================================
function ApexUI:CreateSlider(section, name, min, max, default, callback)
    min = min or 0
    max = max or 100
    local value = default or min

    local container = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = CurrentTheme.Element,
        BackgroundTransparency = 0.2,
        Parent = section.Frame
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = container })
    Create("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 1,
        Transparency = 0.6,
        Parent = container
    })

    Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 16),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text = name .. ": " .. value,
        TextColor3 = CurrentTheme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })

    local bar = Create("Frame", {
        Size = UDim2.new(1, -20, 0, 5),
        Position = UDim2.new(0, 10, 0, 27),
        BackgroundColor3 = CurrentTheme.Background,
        BackgroundTransparency = 0.3,
        Parent = container
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = bar })

    local fill = Create("Frame", {
        Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = CurrentTheme.Accent,
        BorderSizePixel = 0,
        Parent = bar
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = fill })

    local dragging = false
    local label = container:FindFirstChildOfClass("TextLabel")

    local function updateFromInput(input)
        local relX = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * relX)
        fill.Size = UDim2.new(relX, 0, 1, 0)
        label.Text = name .. ": " .. value
        if callback then callback(value) end
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromInput(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromInput(input)
        end
    end)

    return bar
end

-- ============================================================
-- DROPDOWN
-- ============================================================
function ApexUI:CreateDropdown(section, name, options, default, callback)
    local container = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = CurrentTheme.Element,
        BackgroundTransparency = 0.2,
        ClipsDescendants = true,
        Parent = section.Frame
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = container })
    Create("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 1,
        Transparency = 0.6,
        Parent = container
    })

    local selected = default or (options and options[1]) or "Ninguno"

    local header = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        Text = name .. ": " .. tostring(selected) .. "  ▾",
        TextColor3 = CurrentTheme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        AutoButtonColor = false,
        Parent = container
    })

    local listFrame = Create("ScrollingFrame", {
        Size = UDim2.new(1, -8, 0, 0),
        Position = UDim2.new(0, 4, 0, 30),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = container
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = listFrame
    })

    local open = false

    local function refreshList()
        for _, child in pairs(listFrame:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        for _, opt in pairs(options) do
            local optBtn = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 22),
                BackgroundColor3 = CurrentTheme.Background,
                BackgroundTransparency = 0.2,
                Text = tostring(opt),
                TextColor3 = CurrentTheme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 10,
                AutoButtonColor = false,
                Parent = listFrame
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = optBtn })

            optBtn.MouseEnter:Connect(function()
                Tween(optBtn, 0.1, { BackgroundColor3 = CurrentTheme.Accent, BackgroundTransparency = 0 })
            end)
            optBtn.MouseLeave:Connect(function()
                Tween(optBtn, 0.1, { BackgroundColor3 = CurrentTheme.Background, BackgroundTransparency = 0.2 })
            end)

            optBtn.MouseButton1Click:Connect(function()
                selected = opt
                header.Text = name .. ": " .. tostring(opt) .. "  ▾"
                open = false
                Tween(container, 0.2, { Size = UDim2.new(1, 0, 0, 28) })
                listFrame.Size = UDim2.new(1, -8, 0, 0)
                if callback then callback(opt) end
            end)
        end
    end

    header.MouseButton1Click:Connect(function()
        open = not open
        if open then
            refreshList()
            local height = math.min(#options * 24, 110)
            Tween(container, 0.2, { Size = UDim2.new(1, 0, 0, 28 + height + 4) })
            listFrame.Size = UDim2.new(1, -8, 0, height)
        else
            Tween(container, 0.2, { Size = UDim2.new(1, 0, 0, 28) })
            listFrame.Size = UDim2.new(1, -8, 0, 0)
        end
    end)

    return header
end

-- ============================================================
-- TEXTBOX
-- ============================================================
function ApexUI:CreateTextbox(section, name, placeholder, callback)
    local container = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = CurrentTheme.Element,
        BackgroundTransparency = 0.2,
        Parent = section.Frame
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = container })
    Create("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 1,
        Transparency = 0.6,
        Parent = container
    })

    local box = Create("TextBox", {
        Size = UDim2.new(1, -20, 1, -8),
        Position = UDim2.new(0, 10, 0, 4),
        BackgroundTransparency = 1,
        Text = "",
        PlaceholderText = placeholder or name,
        PlaceholderColor3 = CurrentTheme.SubText,
        TextColor3 = CurrentTheme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Parent = container
    })

    box.Focused:Connect(function()
        Tween(container, 0.15, { BackgroundColor3 = CurrentTheme.Accent })
    end)
    box.FocusLost:Connect(function(enterPressed)
        Tween(container, 0.15, { BackgroundColor3 = CurrentTheme.Element })
        if callback then callback(box.Text) end
    end)

    return box
end

-- ============================================================
-- COLORPICKER
-- ============================================================
function ApexUI:CreateColorpicker(section, name, default, callback)
    local container = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = CurrentTheme.Element,
        BackgroundTransparency = 0.2,
        Parent = section.Frame
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = container })
    Create("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 1,
        Transparency = 0.6,
        Parent = container
    })

    Create("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = CurrentTheme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })

    local colorBtn = Create("TextButton", {
        Size = UDim2.new(0, 34, 0, 18),
        Position = UDim2.new(1, -44, 0.5, -9),
        BackgroundColor3 = default or Color3.fromRGB(255, 0, 0),
        Text = "",
        AutoButtonColor = false,
        Parent = container
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = colorBtn })

    local palette = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(255, 0, 255),
        Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(0, 0, 0)
    }
    local index = 1

    colorBtn.MouseButton1Click:Connect(function()
        index = index + 1
        if index > #palette then index = 1 end
        local col = palette[index]
        Tween(colorBtn, 0.2, { BackgroundColor3 = col })
        if callback then callback(col) end
    end)

    return colorBtn
end

-- ============================================================
-- KEYBIND
-- ============================================================
function ApexUI:CreateKeybind(section, name, defaultKey, callback)
    local container = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = CurrentTheme.Element,
        BackgroundTransparency = 0.2,
        Parent = section.Frame
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = container })
    Create("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 1,
        Transparency = 0.6,
        Parent = container
    })

    Create("TextLabel", {
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTrans
