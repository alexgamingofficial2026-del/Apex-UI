-- ============================================================
-- APEX UI v1.0 - Delta Compatible
-- Creador: AlexOfficial
-- ============================================================

local ApexUI = {}
ApexUI.__index = ApexUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Theme = {
    Background = Color3.fromRGB(12, 12, 16),
    Header = Color3.fromRGB(20, 20, 26),
    Accent = Color3.fromRGB(255, 60, 60),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(150, 150, 160),
    Element = Color3.fromRGB(28, 28, 36),
    ToggleOff = Color3.fromRGB(50, 50, 60)
}

local function Create(class, props)
    local i = Instance.new(class)
    for k, v in pairs(props or {}) do i[k] = v end
    return i
end

-- Delta fix: usar SIEMPRE PlayerGui
local function GetGuiParent()
    return game.Players.LocalPlayer:WaitForChild("PlayerGui")
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
        DisplayOrder = 999999,
        IgnoreGuiInset = true,
        Parent = GetGuiParent()
    })

    self.Main = Create("Frame", {
        Size = UDim2.new(0, 420, 0, 320),
        Position = UDim2.new(0.5, -210, 0.5, -160),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Active = true,
        Parent = self.ScreenGui
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 14), Parent = self.Main })
    Create("UIStroke", { Color = Color3.new(1,1,1), Thickness = 1.5, Transparency = 0.35, Parent = self.Main })

    local titleBar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Theme.Header,
        BorderSizePixel = 0,
        Parent = self.Main
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 14), Parent = titleBar })

    Create("Frame", {
        Size = UDim2.new(0, 3, 0, 20),
        Position = UDim2.new(0, 12, 0.5, -10),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Parent = titleBar
    })

    Create("TextLabel", {
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 22, 0, 0),
        BackgroundTransparency = 1,
        Text = title or "Apex UI",
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })

    local closeBtn = Create("TextButton", {
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(1, -26, 0, 6),
        BackgroundColor3 = Color3.fromRGB(220, 60, 60),
        Text = "X",
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        AutoButtonColor = false,
        Parent = titleBar
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = closeBtn })
    closeBtn.MouseButton1Click:Connect(function() self.ScreenGui:Destroy() end)

    local minBtn = Create("TextButton", {
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(1, -52, 0, 6),
        BackgroundColor3 = Color3.fromRGB(240, 180, 60),
        Text = "—",
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        AutoButtonColor = false,
        Parent = titleBar
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = minBtn })
    minBtn.MouseButton1Click:Connect(function()
        local isMin = self.Main.Size.Y.Offset < 100
        self.Main.Size = isMin and UDim2.new(0, 420, 0, 320) or UDim2.new(0, 420, 0, 34)
    end)

    -- Hacer arrastrable
    local dragging, dragStart, startPos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.Main.Position
        end
    end)
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            self.Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    self.Sidebar = Create("ScrollingFrame", {
        Size = UDim2.new(0, 115, 1, -46),
        Position = UDim2.new(0, 10, 0, 42),
        BackgroundColor3 = Theme.Header,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        CanvasSize = UDim2.new(0, 0, 0, 2000),
        Parent = self.Main
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = self.Sidebar })
    Create("UIListLayout", { Padding = UDim.new(0, 4), Parent = self.Sidebar })
    Create("UIPadding", { PaddingTop = UDim.new(0,6), PaddingLeft = UDim.new(0,6), PaddingRight = UDim.new(0,6), PaddingBottom = UDim.new(0,6), Parent = self.Sidebar })

    self.Content = Create("Frame", {
        Size = UDim2.new(1, -135, 1, -46),
        Position = UDim2.new(0, 125, 0, 42),
        BackgroundColor3 = Theme.Header,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = self.Main
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = self.Content })

    return self
end

-- ============================================================
-- TAB
-- ============================================================
function ApexUI:CreateTab(name)
    local tab = { Name = name }

    local btn = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = Theme.Background,
        Text = name,
        TextColor3 = Theme.Text,
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
        CanvasSize = UDim2.new(0, 0, 0, 2000),
        Visible = false,
        Parent = self.Content
    })
    Create("UIListLayout", { Padding = UDim.new(0, 6), Parent = frame })
    Create("UIPadding", { PaddingTop = UDim.new(0,8), PaddingLeft = UDim.new(0,8), PaddingRight = UDim.new(0,8), PaddingBottom = UDim.new(0,8), Parent = frame })

    tab.Button = btn
    tab.Frame = frame

    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do
            t.Frame.Visible = false
            t.Button.BackgroundColor3 = Theme.Background
        end
        frame.Visible = true
        btn.BackgroundColor3 = Theme.Accent
        self.CurrentTab = tab
    end)

    table.insert(self.Tabs, tab)
    if #self.Tabs == 1 then
        frame.Visible = true
        btn.BackgroundColor3 = Theme.Accent
        self.CurrentTab = tab
    end

    return tab
end

-- ============================================================
-- SECTION
-- ============================================================
function ApexUI:CreateSection(tab, name)
    local label = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        Text = "▸ " .. name,
        TextColor3 = Theme.Accent,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = tab.Frame
    })

    return {
        Name = name,
        Label = label,
        Frame = tab.Frame
    }
end

-- ============================================================
-- BOTÓN
-- ============================================================
function ApexUI:CreateButton(section, name, callback)
    local btn = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = Theme.Element,
        Text = name,
        TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        AutoButtonColor = false,
        Parent = section.Frame
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = btn })
    Create("UIStroke", { Color = Color3.new(1,1,1), Thickness = 1, Transparency = 0.6, Parent = btn })

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
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = Theme.Element,
        Parent = section.Frame
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = container })
    Create("UIStroke", { Color = Color3.new(1,1,1), Thickness = 1, Transparency = 0.6, Parent = container })

    Create("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })

    local toggleBtn = Create("TextButton", {
        Size = UDim2.new(0, 36, 0, 18),
        Position = UDim2.new(1, -46, 0.5, -9),
        BackgroundColor3 = state and Theme.Accent or Theme.ToggleOff,
        Text = "",
        AutoButtonColor = false,
        Parent = container
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = toggleBtn })

    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and Theme.Accent or Theme.ToggleOff
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
        BackgroundColor3 = Theme.Element,
        Parent = section.Frame
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = container })
    Create("UIStroke", { Color = Color3.new(1,1,1), Thickness = 1, Transparency = 0.6, Parent = container })

    local label = Create("TextLabel", {
        Size = UDim2.new(1, -20, 0, 16),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text = name .. ": " .. value,
        TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })

    local bar = Create("Frame", {
        Size = UDim2.new(1, -20, 0, 5),
        Position = UDim2.new(0, 10, 0, 27),
        BackgroundColor3 = Theme.Background,
        Parent = container
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = bar })

    local fill = Create("Frame", {
        Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Parent = bar
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = fill })

    local dragging = false
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
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
            local relX = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            value = math.floor(min + (max - min) * relX)
            fill.Size = UDim2.new(relX, 0, 1, 0)
            label.Text = name .. ": " .. value
            if callback then callback(value) end
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
        BackgroundColor3 = Theme.Element,
        ClipsDescendants = true,
        Parent = section.Frame
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = container })
    Create("UIStroke", { Color = Color3.new(1,1,1), Thickness = 1, Transparency = 0.6, Parent = container })

    local selected = default or (options and options[1]) or "Ninguno"

    local header = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        Text = name .. ": " .. tostring(selected) .. "  ▼",
        TextColor3 = Theme.Text,
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
        CanvasSize = UDim2.new(0, 0, 0, 2000),
        Parent = container
    })
    Create("UIListLayout", { Padding = UDim.new(0, 2), Parent = listFrame })

    local open = false
    header.MouseButton1Click:Connect(function()
        open = not open
        if open then
            for _, child in pairs(listFrame:GetChildren()) do
                if child:IsA("TextButton") then child:Destroy() end
            end
            for _, opt in pairs(options) do
                local optBtn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 22),
                    BackgroundColor3 = Theme.Background,
                    Text = tostring(opt),
                    TextColor3 = Theme.Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 10,
                    Parent = listFrame
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = optBtn })
                optBtn.MouseButton1Click:Connect(function()
                    selected = opt
                    header.Text = name .. ": " .. tostring(opt) .. "  ▼"
                    open = false
                    container.Size = UDim2.new(1, 0, 0, 28)
                    listFrame.Size = UDim2.new(1, -8, 0, 0)
                    if callback then callback(opt) end
                end)
            end
            local height = math.min(#options * 24, 110)
            container.Size = UDim2.new(1, 0, 0, 28 + height + 4)
            listFrame.Size = UDim2.new(1, -8, 0, height)
        else
            container.Size = UDim2.new(1, 0, 0, 28)
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
        BackgroundColor3 = Theme.Element,
        Parent = section.Frame
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = container })
    Create("UIStroke", { Color = Color3.new(1,1,1), Thickness = 1, Transparency = 0.6, Parent = container })

    local box = Create("TextBox", {
        Size = UDim2.new(1, -20, 1, -8),
        Position = UDim2.new(0, 10, 0, 4),
        BackgroundTransparency = 1,
        Text = "",
        PlaceholderText = placeholder or name,
        PlaceholderColor3 = Theme.SubText,
        TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Parent = container
    })

    box.FocusLost:Connect(function()
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
        BackgroundColor3 = Theme.Element,
        Parent = section.Frame
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = container })
    Create("UIStroke", { Color = Color3.new(1,1,1), Thickness = 1, Transparency = 0.6, Parent = container })

    Create("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Theme.Text,
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
        Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 0, 255), Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0)
    }
    local index = 1

    colorBtn.MouseButton1Click:Connect(function()
        index = index + 1
        if index > #palette then index = 1 end
        colorBtn.BackgroundColor3 = palette[index]
        if callback then callback(palette[index]) end
    end)

    return colorBtn
end

-- ============================================================
-- KEYBIND
-- ============================================================
function ApexUI:CreateKeybind(section, name, defaultKey, callback)
    local container = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = Theme.Element,
        Parent = section.Frame
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = container })
    Create("UIStroke", { Color = Color3.new(1,1,1), Thickness = 1, Transparency = 0.6, Parent = container })

    Create("TextLabel", {
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })

    local keyBtn = Create("TextButton", {
        Size = UDim2.new(0, 54, 0, 18),
        Position = UDim2.new(1, -64, 0.5, -9),
        BackgroundColor3 = Theme.Background,
        Text = defaultKey or "NONE",
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        AutoButtonColor = false,
        Parent = container
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = keyBtn })

    local listening = false
    keyBtn.MouseButton1Click:Connect(function()
        listening = true
        keyBtn.Text = "..."
    end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
            keyBtn.Text = input.KeyCode.Name
            listening = false
            if callback then callback(input.KeyCode) end
        end
    end)

    return keyBtn
end

-- ============================================================
-- LABEL
-- ============================================================
function ApexUI:CreateLabel(section, text)
    return Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.SubText,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = section.Frame
    })
end

-- ============================================================
-- NOTIFICACIÓN
-- ============================================================
local notifCount = 0
function ApexUI:Notify(title, text, duration)
    duration = duration or 3
    notifCount = notifCount + 1
    local notif = Create("Frame", {
        Size = UDim2.new(0, 250, 0, 56),
        Position = UDim2.new(1, -260, 0, 20 + (notifCount - 1) * 66),
        BackgroundColor3 = Theme.Header,
        BorderSizePixel = 0,
        Parent = self.ScreenGui
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = notif })
    Create("UIStroke", { Color = Color3.new(1,1,1), Thickness = 1.5, Transparency = 0.3, Parent = notif })

    Create("Frame", {
        Size = UDim2.new(0, 3, 0, 30),
        Position = UDim2.new(0, 8, 0.5, -15),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Parent = notif
    })

    Create("TextLabel", {
        Size = UDim2.new(1, -30, 0, 18), Position = UDim2.new(0, 18, 0, 8),
        BackgroundTransparency = 1, Text = title, TextColor3 = Theme.Accent,
        Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = notif
    })

    Create("TextLabel", {
        Size = UDim2.new(1, -30, 0, 18), Position = UDim2.new(0, 18, 0, 28),
        BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, Parent = notif
    })

    task.delay(duration, function() notif:Destroy() end)
end

function ApexUI:SetTheme(name) return true end
function ApexUI:GetThemes() return {"Default"} end
function ApexUI:SaveConfig(name) return true end
function ApexUI:LoadConfig(name) return {} end
function ApexUI:DeleteConfig(name) end

return ApexUI
