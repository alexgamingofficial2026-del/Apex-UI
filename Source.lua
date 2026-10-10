-- ============================================================
-- APEX UI - Librería de interfaz para Roblox
-- Creador: AlexOfficial
-- Licencia: MIT
-- ============================================================

local ApexUI = {}
ApexUI.__index = ApexUI

-- Servicios
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

-- ============================================================
-- CONFIGURACIÓN DE TEMAS
-- ============================================================
local Themes = {
    Default = {
        Background = Color3.fromRGB(30, 30, 35),
        Header = Color3.fromRGB(40, 40, 48),
        Accent = Color3.fromRGB(155, 92, 246),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(180, 180, 190),
        Element = Color3.fromRGB(45, 45, 55),
        ToggleOff = Color3.fromRGB(70, 70, 80)
    },
    Dark = {
        Background = Color3.fromRGB(15, 15, 18),
        Header = Color3.fromRGB(22, 22, 28),
        Accent = Color3.fromRGB(120, 80, 220),
        Text = Color3.fromRGB(240, 240, 245),
        SubText = Color3.fromRGB(150, 150, 160),
        Element = Color3.fromRGB(30, 30, 38),
        ToggleOff = Color3.fromRGB(55, 55, 65)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 245),
        Header = Color3.fromRGB(225, 225, 235),
        Accent = Color3.fromRGB(100, 60, 200),
        Text = Color3.fromRGB(30, 30, 40),
        SubText = Color3.fromRGB(90, 90, 100),
        Element = Color3.fromRGB(215, 215, 225),
        ToggleOff = Color3.fromRGB(180, 180, 190)
    },
    Amethyst = {
        Background = Color3.fromRGB(35, 25, 50),
        Header = Color3.fromRGB(48, 35, 68),
        Accent = Color3.fromRGB(170, 100, 255),
        Text = Color3.fromRGB(255, 250, 255),
        SubText = Color3.fromRGB(200, 180, 220),
        Element = Color3.fromRGB(55, 40, 75),
        ToggleOff = Color3.fromRGB(80, 60, 105)
    }
}

local CurrentTheme = Themes.Default

-- ============================================================
-- FUNCIONES AUXILIARES
-- ============================================================
local function Create(className, props)
    local inst = Instance.new(className)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    return inst
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
-- CREAR VENTANA
-- ============================================================
function ApexUI:CreateWindow(title)
    local self = setmetatable({}, ApexUI)
    self.Tabs = {}
    self.CurrentTab = nil

    -- ScreenGui
    self.ScreenGui = Create("ScreenGui", {
        Name = "ApexUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui
    })

    -- Ventana principal
    self.Main = Create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 560, 0, 420),
        Position = UDim2.new(0.5, -280, 0.5, -210),
        BackgroundColor3 = CurrentTheme.Background,
        BorderSizePixel = 0,
        Active = true,
        Parent = self.ScreenGui
    })

    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = self.Main })
    Create("UIStroke", {
        Color = CurrentTheme.Accent,
        Thickness = 1,
        Transparency = 0.4,
        Parent = self.Main
    })

    -- Barra de título
    local titleBar = Create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = CurrentTheme.Header,
        BorderSizePixel = 0,
        Parent = self.Main
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = titleBar })

    -- Ocultar esquinas inferiores de la barra
    Create("Frame", {
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = CurrentTheme.Header,
        BorderSizePixel = 0,
        Parent = titleBar
    })

    Create("TextLabel", {
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = title or "Apex UI",
        TextColor3 = CurrentTheme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })

    -- Botón minimizar
    local minBtn = Create("TextButton", {
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -66, 0, 6),
        BackgroundColor3 = Color3.fromRGB(240, 180, 60),
        Text = "—",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        Parent = titleBar
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = minBtn })

    -- Botón cerrar
    local closeBtn = Create("TextButton", {
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -34, 0, 6),
        BackgroundColor3 = Color3.fromRGB(220, 60, 60),
        Text = "X",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        Parent = titleBar
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = closeBtn })

    closeBtn.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)

    minBtn.MouseButton1Click:Connect(function()
        self.Main.Visible = not self.Main.Visible
        self.Main.Visible = true
        self.Main.Size = UDim2.new(0, 560, 0, self.Main.Size.Y.Offset == 420 and 40 or 420)
    end)

    MakeDraggable(self.Main, titleBar)

    -- Sidebar de pestañas
    self.Sidebar = Create("ScrollingFrame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 150, 1, -50),
        Position = UDim2.new(0, 10, 0, 45),
        BackgroundColor3 = CurrentTheme.Header,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = CurrentTheme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = self.Main
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = self.Sidebar })
    Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.Sidebar
    })
    Create("UIPadding", {
        PaddingTop = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        Parent = self.Sidebar
    })

    -- Contenedor de contenido
    self.Content = Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -180, 1, -50),
        Position = UDim2.new(0, 170, 0, 45),
        BackgroundColor3 = CurrentTheme.Header,
        BorderSizePixel = 0,
        Parent = self.Main
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = self.Content })

    return self
end

-- ============================================================
-- CREAR PESTAÑA
-- ============================================================
function ApexUI:CreateTab(name)
    local tab = { Name = name, Sections = {} }

    local btn = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = CurrentTheme.Background,
        Text = name,
        TextColor3 = CurrentTheme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        Parent = self.Sidebar
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })

    local frame = Create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = CurrentTheme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = self.Content
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = frame
    })
    Create("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        Parent = frame
    })

    tab.Button = btn
    tab.Frame = frame

    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do
            t.Frame.Visible = false
            t.Button.BackgroundColor3 = CurrentTheme.Background
        end
        frame.Visible = true
        btn.BackgroundColor3 = CurrentTheme.Accent
        self.CurrentTab = tab
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
-- CREAR SECCIÓN
-- ============================================================
function ApexUI:CreateSection(tab, name)
    local section = { Name = name }

    local label = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1,
        Text = "• " .. name,
        TextColor3 = CurrentTheme.Accent,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = tab.Frame
    })

    local container = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = tab.Frame
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 6),
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
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = CurrentTheme.Element,
        Text = name,
        TextColor3 = CurrentTheme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        Parent = section.Frame
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
    Create("UIStroke", {
        Color = CurrentTheme.Accent,
        Thickness = 1,
        Transparency = 0.7,
        Parent = btn
    })

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = CurrentTheme.Accent
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = CurrentTheme.Element
    end)
    btn.MouseButton1Click:Connect(function()
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
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = CurrentTheme.Element,
        Parent = section.Frame
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = container })

    Create("TextLabel", {
        Size = UDim2.new(1, -70, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = CurrentTheme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })

    local toggleBtn = Create("TextButton", {
        Size = UDim2.new(0, 44, 0, 22),
        Position = UDim2.new(1, -56, 0.5, -11),
        BackgroundColor3 = state and CurrentTheme.Accent or CurrentTheme.ToggleOff,
        Text = "",
        Parent = container
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = toggleBtn })

    local circle = Create("Frame", {
        Size = UDim2.new(0, 18, 0, 18),
        Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
        BackgroundColor3 = Color3.new(1, 1, 1),
        Parent = toggleBtn
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = circle })

    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and CurrentTheme.Accent or CurrentTheme.ToggleOff
        circle.Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
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
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = CurrentTheme.Element,
        Parent = section.Frame
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = container })

    Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 6),
        BackgroundTransparency = 1,
        Text = name .. ": " .. value,
        TextColor3 = CurrentTheme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })

    local bar = Create("Frame", {
        Size = UDim2.new(1, -20, 0, 8),
        Position = UDim2.new(0, 10, 0, 32),
        BackgroundColor3 = CurrentTheme.Background,
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
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = CurrentTheme.Element,
        ClipsDescendants = true,
        Parent = section.Frame
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = container })

    local selected = default or (options and options[1]) or "Ninguno"

    local header = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundTransparency = 1,
        Text = name .. "  ▾",
        TextColor3 = CurrentTheme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        Parent = container
    })

    local listFrame = Create("ScrollingFrame", {
        Size = UDim2.new(1, -10, 0, 0),
        Position = UDim2.new(0, 5, 0, 36),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = container
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 3),
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
                Size = UDim2.new(1, 0, 0, 26),
                BackgroundColor3 = CurrentTheme.Background,
                Text = tostring(opt),
                TextColor3 = CurrentTheme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                Parent = listFrame
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = optBtn })
            optBtn.MouseButton1Click:Connect(function()
                selected = opt
                header.Text = name .. ": " .. tostring(opt) .. "  ▾"
                open = false
                container.Size = UDim2.new(1, 0, 0, 34)
                listFrame.Size = UDim2.new(1, -10, 0, 0)
                if callback then callback(opt) end
            end)
        end
    end

    header.MouseButton1Click:Connect(function()
        open = not open
        if open then
            refreshList()
            local height = math.min(#options * 29, 130)
            container.Size = UDim2.new(1, 0, 0, 34 + height + 5)
            listFrame.Size = UDim2.new(1, -10, 0, height)
        else
            container.Size = UDim2.new(1, 0, 0, 34)
            listFrame.Size = UDim2.new(1, -10, 0, 0)
        end
    end)

    header.Text = name .. ": " .. tostring(selected) .. "  ▾"

    return header
end

-- ============================================================
-- TEXTBOX
-- ============================================================
function ApexUI:CreateTextbox(section, name, placeholder, callback)
    local container = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = CurrentTheme.Element,
        Parent = section.Frame
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = container })

    local box = Create("TextBox", {
        Size = UDim2.new(1, -20, 1, -10),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text = "",
        PlaceholderText = placeholder or name,
        PlaceholderColor3 = CurrentTheme.SubText,
        TextColor3 = CurrentTheme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Parent = container
    })

    box.FocusLost:Connect(function(enterPressed)
        if callback then callback(box.Text) end
    end)

    return box
end

-- ============================================================
-- COLORPICKER (simplificado con presets)
-- ============================================================
function ApexUI:CreateColorpicker(section, name, default, callback)
    local container = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = CurrentTheme.Element,
        Parent = section.Frame
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = container })

    Create("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = CurrentTheme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })

    local colorBtn = Create("TextButton", {
        Size = UDim2.new(0, 40, 0, 22),
        Position = UDim2.new(1, -52, 0.5, -11),
        BackgroundColor3 = default or Color3.fromRGB(255, 0, 0),
        Text = "",
        Parent = container
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = colorBtn })

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
        colorBtn.BackgroundColor3 = col
        if callback then callback(col) end
    end)

    return colorBtn
end

-- ============================================================
-- KEYBIND
-- ============================================================
function ApexUI:CreateKeybind(section, name, defaultKey, callback)
    local container = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = CurrentTheme.Element,
        Parent = section.Frame
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = container })

    Create("TextLabel", {
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = CurrentTheme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })

    local keyBtn = Create("TextButton", {
        Size = UDim2.new(0, 60, 0, 22),
        Position = UDim2.new(1, -72, 0.5, -11),
        BackgroundColor3 = CurrentTheme.Background,
        Text = defaultKey or "NONE",
        TextColor3 = CurrentTheme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        Parent = container
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = keyBtn })

    local listening = false

    keyBtn.MouseButton1Click:Connect(function()
        listening = true
        keyBtn.Text = "..."
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                keyBtn.Text = input.KeyCode.Name
                listening = false
                if callback then callback(input.KeyCode) end
            end
        else
            if input.UserInputType == Enum.UserInputType.Keyboard
            and input.KeyCode.Name == keyBtn.Text then
                if callback then callback(input.KeyCode) end
            end
        end
    end)

    return keyBtn
end

-- ============================================================
-- LABEL
-- ============================================================
function ApexUI:CreateLabel(section, text)
    local label = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = CurrentTheme.SubText,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = section.Frame
    })
    return label
end

-- ============================================================
-- NOTIFICACIÓN
-- ============================================================
local notifCount = 0

function ApexUI:Notify(title, text, duration)
    duration = duration or 3
    notifCount = notifCount + 1
    local myIndex = notifCount

    local notif = Create("Frame", {
        Size = UDim2.new(0, 300, 0, 70),
        Position = UDim2.new(1, -320, 0, 20 + (myIndex - 1) * 80),
        BackgroundColor3 = CurrentTheme.Header,
        BorderSizePixel = 0,
        Parent = self.ScreenGui
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = notif })
    Create("UIStroke", {
        Color = CurrentTheme.Accent,
        Thickness = 1,
        Parent = notif
    })

    Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 22),
        Position = UDim2.new(0, 12, 0, 8),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = CurrentTheme.Accent,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notif
    })

    Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 22),
        Position = UDim2.new(0, 12, 0, 32),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = CurrentTheme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = notif
    })

    task.delay(duration, function()
        notif:Destroy()
    end)
end

-- ============================================================
-- TEMAS
-- ============================================================
function ApexUI:SetTheme(themeName)
    if Themes[themeName] then
        CurrentTheme = Themes[themeName]
        if self.Main then
            self.Main.BackgroundColor3 = CurrentTheme.Background
            self.Sidebar.BackgroundColor3 = CurrentTheme.Header
            self.Content.BackgroundColor3 = CurrentTheme.Header
        end
        return true
    end
    return false
end

function ApexUI:GetThemes()
    local list = {}
    for k, _ in pairs(Themes) do
        table.insert(list, k)
    end
    return list
end

-- ============================================================
-- CONFIGURACIONES (simplificado)
-- ============================================================
local Configs = {}

function ApexUI:SaveConfig(name)
    Configs[name] = Configs[name] or {}
    return true
end

function ApexUI:LoadConfig(name)
    return Configs[name] or {}
end

function ApexUI:DeleteConfig(name)
    Configs[name] = nil
end

-- ============================================================
-- RETORNAR LIBRERÍA
-- ============================================================
return ApexUI
