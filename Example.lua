-- ============================================================
-- APEX UI - Ejemplo de uso
-- ============================================================

-- 1. Cargar la librería
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/alexgamingofficial2026-del/Apex-UI/main/Source.lua"))()

-- 2. Crear la ventana
local Window = Library:CreateWindow("Apex UI - Ejemplo")

-- 3. Crear pestañas
local MainTab = Window:CreateTab("Principal")
local VisualTab = Window:CreateTab("Visuales")
local ListTab = Window:CreateTab("Listas")
local SettingsTab = Window:CreateTab("Ajustes")

-- ============================================================
-- PESTAÑA PRINCIPAL
-- ============================================================
local MoveSection = MainTab:CreateSection("Movimiento")

MoveSection:CreateSlider("Velocidad", 16, 300, 16, function(value)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").WalkSpeed = value
    end
end)

MoveSection:CreateSlider("Salto", 50, 500, 50, function(value)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").JumpPower = value
    end
end)

MoveSection:CreateToggle("Salto Infinito", false, function(state)
    if state then
        local UIS = game:GetService("UserInputService")
        _G.InfConn = UIS.JumpRequest:Connect(function()
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if _G.InfConn then
            _G.InfConn:Disconnect()
            _G.InfConn = nil
        end
    end
end)

MoveSection:CreateButton("Restablecer Movimiento", function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
        char:FindFirstChildOfClass("Humanoid").JumpPower = 50
    end
    Library:Notify("Apex UI", "Movimiento restablecido", 3)
end)

-- ============================================================
-- PESTAÑA VISUALES
-- ============================================================
local EspSection = VisualTab:CreateSection("Jugadores")

local espHighlights = {}

EspSection:CreateToggle("ESP (Resaltar Jugadores)", false, function(state)
    if state then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                local hl = Instance.new("Highlight")
                hl.Name = "ApexESP"
                hl.FillColor = Color3.fromRGB(155, 92, 246)
                hl.OutlineColor = Color3.new(1, 1, 1)
                hl.FillTransparency = 0.5
                hl.OutlineTransparency = 0
                hl.Parent = player.Character
                table.insert(espHighlights, hl)
            end
        end
    else
        for _, h in pairs(espHighlights) do
            if h and h.Parent then h:Destroy() end
        end
        espHighlights = {}
    end
end)

EspSection:CreateColorpicker("Color del ESP", Color3.fromRGB(155, 92, 246), function(color)
    for _, h in pairs(espHighlights) do
        if h and h.Parent then h.FillColor = color end
    end
end)

local LightSection = VisualTab:CreateSection("Iluminación")

LightSection:CreateToggle("Fullbright", false, function(state)
    local lighting = game:GetService("Lighting")
    if state then
        lighting.Brightness = 3
        lighting.Ambient = Color3.fromRGB(255, 255, 255)
    else
        lighting.Brightness = 1
        lighting.Ambient = Color3.fromRGB(0, 0, 0)
    end
end)

-- ============================================================
-- PESTAÑA LISTAS
-- ============================================================
local PlayerListSection = ListTab:CreateSection("Jugadores en Servidor")

-- Lista de nombres de jugadores
local playerNames = {}
for _, p in pairs(game.Players:GetPlayers()) do
    if p ~= game.Players.LocalPlayer then
        table.insert(playerNames, p.Name)
    end
end

PlayerListSection:CreateDropdown("Seleccionar Jugador", playerNames, playerNames[1], function(value)
    print("[Apex UI] Seleccionaste: " .. value)
    Library:Notify("Apex UI", "Jugador seleccionado: " .. value, 3)
end)

local InventedSection = ListTab:CreateSection("Objetos Inventados")

local InventedItems = {
    "Poción de Velocidad Turbo",
    "Espada Láser Cuántica",
    "Escudo Anti-Gravedad",
    "Capa de Invisibilidad",
    "Botas de Salto Dimensional",
    "Guantes de Fuerza Titánica",
    "Casco de Visión Infrarroja",
    "Anillo de Teletransporte",
    "Amuleto de Vida Infinita",
    "Gafas de Rayos X"
}

InventedSection:CreateDropdown("Seleccionar Objeto", InventedItems, InventedItems[1], function(value)
    print("[Apex UI] Obtuviste: " .. value)
    Library:Notify(":Apex UI", "¡ObtuvCreateiste: " .. value .. "!",Key 3)
end)

InventedSectionbind:CreateButton("Obtener Ob("jeto Aleatorio", function()
    local randomItem = InventedItems[math.random(1, #InventedItems)]
    Library:Notify("Apex UI", "¡Obtuviste: " .. randomItem .. "!", 3)
    print("[Apex UI] Objeto aleatorio: " .. randomItem)
end)

-- ============================================================
-- PESTAÑA AJUSTES
-- ============================================================
local ThemeSection = SettingsTab:CreateSection("Temas")

ThemeSection:CreateDropdown("Seleccionar Tema", {"Default", "Dark", "Light", "Amethyst"}, "Default", function(theme)
    Library:SetTheme(theme)
    Library:Notify("Apex UI", "Tema cambiado a: " .. theme, 3)
end)

local KeybindSection = SettingsTab:CreateSection("Atajos")

KeybindSectionTecla de Prueba", "F", function(key)
    Library:Notify("Apex UI", "Presionaste: " .. key.Name, 2)
end)

local TextSection = SettingsTab:CreateSection("Texto")

TextSection:CreateTextbox("Escribe algo", "Escribe aquí...", function(text)
    print("[Apex UI] Escribiste: " .. text)
    Library:Notify("Apex UI", "Escribiste: " .. text, 3)
end)

local InfoSection = SettingsTab:CreateSection("Información")

InfoSection:CreateLabel("Apex UI v1.0")
InfoSection:CreateLabel("Creado por AlexOfficial")
InfoSection:CreateLabel("Licencia MIT")

-- ============================================================
-- NOTIFICACIÓN DE CARGA
-- ============================================================
Library:Notify("Apex UI", "¡Script cargado correctamente!", 5)
print("[Apex UI] Ejemplo cargado correctamente")
