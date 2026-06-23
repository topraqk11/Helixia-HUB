# HELIXIA HUB

A modern, themeable UI library for Roblox — built with clean animations, a full component system, and 15 hand-crafted themes.

---

## Preview

<img width="650" height="450" alt="image" src="https://github.com/user-attachments/assets/60c48747-3dd3-449e-9239-dcab444c3a65" />

---

## Features

- **15 built-in themes** — Midnight, Void, Slate, Obsidian, Aurora, Crimson, Amethyst, Rose, Copper, Forest, Ocean, Arctic, Sand, Neon, Dusk
- **Full component set** — Button, Toggle, Slider, Dropdown, Color Picker, Text Input, Section
- **Live theme switching** — all components react instantly with no flicker
- **Custom accent color** — override the accent on any theme via Color Picker
- **Draggable & resizable window** — drag from title bar, resize from corner grip
- **Minimize to floating button** — with drag support, click to restore
- **Sidebar tab search** — real-time filter across all tabs
- **Notification system** — Info, Success, Warning, Error types with progress bar and auto-dismiss
- **Ripple click effects** — material-style feedback on buttons
- **Multi-window support** — focus management and z-index stacking
- **Background blur** — global blur effect tied to open window count
- **Config manager** — bind components to keys, export/import JSON, save/load from file

---

## Quick Start

```lua
local HelixiaHUB = loadstring(HttpGet(""))()

-- Create a window
local win = HelixiaHUB:CreateWindow({
    Title    = "My Hub",
    SubTitle = "v1.0",
    Icon     = "rbxassetid://102278873791566",
    Size     = Vector2.new(860, 540),
})

-- Create a tab
local generalTab = win:CreateTab({
	Name = "General",
	Icon = "rbxassetid://138525646531017",
})

-- Add a button
generalTab:CreateButton({
    Text     = "Click Me",
    Callback = function()
        HelixiaHUB:Notify({ Title = "Hello!", Type = "Success" })
    end,
})
```

---

## Components

### Section
```lua
generalTab:CreateSection("My Section", {
    Description = "Optional description text.",
})
```

### Button
```lua
generalTab:CreateButton({
    Text        = "Button",
    Description = "Optional subtitle",   -- optional
    Icon        = "rbxassetid://...",    -- optional
    ConfirmMode = true,                  -- double-click to confirm
    ConfirmText = "Are you sure?",
    Callback    = function() end,
})
```

### Toggle
```lua
local toggle = generalTab:CreateToggle({
    Text        = "Enable Feature",
    Description = "Optional subtitle",
    Default     = false,
    Keybind     = Enum.KeyCode.F,        -- optional
    Callback    = function(value) end,
})

-- API
toggle:SetValue(true)
print(toggle.Value)
toggle.Changed:Connect(function(v) end)
```

### Slider
```lua
local slider = generalTab:CreateSlider({
    Text      = "Walk Speed",
    Min       = 0,
    Max       = 100,
    Default   = 16,
    Increment = 1,
    Prefix    = "",       -- optional, e.g. "×"
    Suffix    = " stud/s",-- optional
    Callback  = function(value) end,
})

-- API
slider:SetValue(50)
print(slider.Value)
```

### Dropdown
```lua
local dropdown = generalTab:CreateDropdown({
    Text     = "Select Option",
    Options  = { "Option A", "Option B", "Option C" },
    Default  = "Option A",
    Multi    = false,   -- set true for multi-select
    Callback = function(value) end,
})

-- API
dropdown:SetOptions({ "New A", "New B" })
print(dropdown.Value)
```

### Color Picker
```lua
local picker = generalTab:CreateColorPicker({
    Text         = "Accent Color",
    Default      = Color3.fromRGB(124, 92, 255),
    DefaultAlpha = 1,
    Callback     = function(color, alpha) end,
})

-- API
picker:SetValue(Color3.fromRGB(255, 100, 100), 0.8)
print(picker.Value, picker.Alpha)
```

### Input
```lua
local input = generalTab:CreateInput({
    Text        = "Username",
    Placeholder = "Enter username...",
    Default     = "",
    CharLimit   = 32,          -- optional
    Validate    = function(v)  -- optional, return false to show error
        return #v >= 3
    end,
    Callback    = function(value, enterPressed) end,
})

-- API
input:SetValue("hello")
print(input.Value)
```

---

## Notifications

```lua
HelixiaHUB:Notify({
    Title    = "Title",
    Message  = "Optional body text.",
    Type     = "Success",   -- "Info" | "Success" | "Warning" | "Error"
    Duration = 4,           -- seconds
})
```

---

## Theming

### Switch theme
```lua
HelixiaHUB.Theme:SetPalette("Aurora")
```

### Auto-load all themes into a dropdown
```lua
local themeNames = {}
for name in pairs(HelixiaHUB.Themes) do
    table.insert(themeNames, name)
end
table.sort(themeNames)

settingsTab:CreateDropdown({
    Text     = "Select Theme",
    Options  = themeNames,
    Default  = "Midnight",
    Callback = function(v)
        HelixiaHUB.Theme:SetPalette(v)
    end,
})
```

### Available themes

| Theme      | Background  | Accent          | Style             |
|------------|-------------|-----------------|-------------------|
| Midnight   | Near-black navy  | Bright violet  | Default dark      |
| Void       | Pure black  | Electric blue   | Ultra minimal     |
| Slate      | Dark blue-grey | Sky blue     | Clean dark        |
| Obsidian   | Warm black  | Old gold        | Warm dark         |
| Aurora     | Deep navy   | Teal-green      | Northern lights   |
| Crimson    | Dark red    | Ember red       | Intense dark      |
| Amethyst   | Deep purple | Pure violet     | Rich dark         |
| Rose       | Dark wine   | Neon pink       | Vibrant dark      |
| Copper     | Dark brown  | Burnt copper    | Earthy dark       |
| Forest     | Dark green  | Leaf green      | Nature dark       |
| Ocean      | Deep ocean  | Bioluminescent cyan | Aquatic dark |
| Arctic     | Near-white  | Glacier blue    | Light            |
| Sand       | Cream-desert| Dark gold       | Warm light        |
| Neon       | Pure black  | Electric lime   | Cyberpunk         |
| Dusk       | Dark purple | Sunset orange   | Twilight dark     |

---

## Config Manager

```lua
local config = HelixiaHUB.Config

-- Bind a component value to a key
config:Bind("walkSpeed", mySlider)

-- Export current config as JSON string
local json = config:Export()

-- Import from JSON string
config:Import(json, function(data)
    mySlider:SetValue(data.walkSpeed)
end)

-- Save / Load from file (exploit environments only)
config:Save("MyHubConfig")
config:Load("MyHubConfig", function(data)
    mySlider:SetValue(data.walkSpeed)
end)
```

---

## Window API

```lua
win:Minimize()   -- minimize to floating button
win:Restore()    -- restore from floating button
win:Close()      -- close and destroy the window
win:SetTheme("Obsidian")  -- shorthand for theme switch
```

---

<div align="center">
  Made with ❤️ — <strong>Helixia HUB</strong>
</div>
