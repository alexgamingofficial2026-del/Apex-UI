# Apex UI

```lua
-- 1. Cargar la librería
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/alexgamingofficial2026-del/Apex-UI/main/Source.lua"))()

-- 2. Crear la ventana
local Window = Library:CreateWindow("Mi Script")

-- 3. Crear una pestaña
local Tab = Window:CreateTab("Principal")

-- 4. Añadir elementos
Tab:CreateButton("Mi Botón", function()
    print("¡Botón pulsado!")
end)

Tab:CreateToggle("Mi Toggle", false, function(state)
    print("Estado:", state)
end)

Tab:CreateSlider("Velocidad", 16, 300, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

-- 5. Notificación
Library:Notify("Mi Script", "Cargado correctamente", 3)
```

---

## 📚 Funciones

### 🪟 Ventana

```lua
local Window = Library:CreateWindow(title)
```

| Parámetro | Tipo | Descripción |
|---|---|---|
| `title` | String | Nombre que aparece en la barra superior |

---

### 📑 Pestañas (Tabs)

```lua
local Tab = Window:CreateTab(name)
```

| Parámetro | Tipo | Descripción |
|---|---|---|
| `name` | String | Nombre de la pestaña |

---

### 📂 Secciones

```lua
local Section = Tab:CreateSection(name)
```

| Parámetro | Tipo | Descripción |
|---|---|---|
| `name` | String | Nombre de la sección |

---

### 🔘 Botones

```lua
Section:CreateButton(name, callback)
```

| Parámetro | Tipo | Descripción |
|---|---|---|
| `name` | String | Texto del botón |
| `callback` | Function | Función que se ejecuta al hacer clic |

---

### 🎚️ Toggles

```lua
Section:CreateToggle(name, default, callback)
```

| Parámetro | Tipo | Descripción |
|---|---|---|
| `name` | String | Texto del toggle |
| `default` | Bool | Estado inicial (`true` o `false`) |
| `callback` | Function | Función que recibe el estado actual |

---

### 📏 Sliders

```lua
Section:CreateSlider(name, min, max, default, callback)
```

| Parámetro | Tipo | Descripción |
|---|---|---|
| `name` | String | Texto del slider |
| `min` | Number | Valor mínimo |
| `max` | Number | Valor máximo |
| `default` | Number | Valor inicial |
| `callback` | Function | Función que recibe el valor actual |

---

### 📋 Dropdowns

```lua
Section:CreateDropdown(name, options, default, callback)
```

| Parámetro | Tipo | Descripción |
|---|---|---|
| `name` | String | Texto del dropdown |
| `options` | Table | Lista de opciones |
| `default` | Any | Opción seleccionada por defecto |
| `callback` | Function | Función que recibe la opción elegida |

---

### ✏️ Textboxes

```lua
Section:CreateTextbox(name, placeholder, callback)
```

| Parámetro | Tipo | Descripción |
|---|---|---|
| `name` | String | Texto del textbox |
| `placeholder` | String | Texto de ayuda dentro de la caja |
| `callback` | Function | Función que recibe el texto escrito |

---

### 🎨 Colorpickers

```lua
Section:CreateColorpicker(name, default, callback)
```

| Parámetro | Tipo | Descripción |
|---|---|---|
| `name` | String | Texto del colorpicker |
| `default` | Color3 | Color inicial |
| `callback` | Function | Función que recibe el color elegido |

---

### ⌨️ Keybinds

```lua
Section:CreateKeybind(name, defaultKey, callback)
```

| Parámetro | Tipo | Descripción |
|---|---|---|
| `name` | String | Texto del keybind |
| `defaultKey` | String | Tecla por defecto (ej: `"F"`) |
| `callback` | Function | Función que se ejecuta al pulsar la tecla |

---

### 🏷️ Labels

```lua
Section:CreateLabel(text)
```

| Parámetro | Tipo | Descripción |
|---|---|---|
| `text` | String | Texto de la etiqueta |

---

### 📢 Notificaciones

```lua
Library:Notify(title, text, duration)
```

| Parámetro | Tipo | Descripción |
|---|---|---|
| `title` | String | Título de la notificación |
| `text` | String | Texto de la notificación |
| `duration` | Number | Duración en segundos |

---

## 🎨 Temas

Puedes cambiar el tema de la librería:

```lua
Library:SetTheme("Dark")
```

Temas disponibles:
- `Default`
- `Dark`
- `Light`
- `Amethyst`

---

## 💾 Configuraciones

Guarda y carga la configuración de tu UI:

```lua
-- Guardar
Library:SaveConfig("MiConfig")

-- Cargar
Library:LoadConfig("MiConfig")
```

---

## 📁 Estructura del repositorio

```
Apex-UI/
├── README.md          ← Este archivo
├── Source.lua         ← Código de la librería
├── Example.lua        ← Ejemplo de uso
└── LICENSE            ← Licencia
```

---

## 🤝 Contribuir

Si quieres contribuir:

1. Haz un **Fork** del repositorio
2. Crea una rama: `git checkout -b feature/nueva-funcion`
3. Haz commit: `git commit -m "Añadida nueva función"`
4. Haz push: `git push origin feature/nueva-funcion`
5. Abre un **Pull Request**

---

## 📜 Licencia

Este proyecto está bajo la licencia **MIT**. Puedes usarlo, modificarlo y distribuirlo libremente.

---

## ⭐ Créditos

- **Creador**: AlexOfficial
- **Inspiración**: Rayfield, Orion, WindUI
- **Comunidad**: Discord de Roblox Scripting

Si te gusta la librería, ¡dale una ⭐ al repositorio!
