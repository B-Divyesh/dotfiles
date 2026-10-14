-- ─────────────────────────────────────────────────────────────────────────────
--  Hyprland 0.56 · Lua config · "Ember" setup
--
--  Files (everything is plain Lua — edit, save, it reloads by itself):
--    hyprland.lua        ← you are here: apps, monitors, which modules load
--    conf/theme.lua      ← colours — change the whole look from one place
--    conf/env.lua        ← environment variables
--    conf/look.lua       ← gaps, borders, blur, shadows, animations, layouts
--    conf/input.lua      ← keyboard (UK), touchpad, touchscreen, gestures
--    conf/keybinds.lua   ← every shortcut   (press  Super + /  to search them)
--    conf/rules.lua      ← window / layer / workspace rules
--    conf/autostart.lua  ← programs started with the session
--
--  Check for mistakes without logging out:   Hyprland --verify-config
--  Wiki for this exact version:              https://wiki.hypr.land/0.56.0/
-- ─────────────────────────────────────────────────────────────────────────────

-- Programs used by the shortcuts, the bar and the scripts
Apps = {
    terminal  = "alacritty",
    files     = "thunar",
    browser   = "brave",
    launcher  = "fuzzel",
    -- floating terminal for TUIs (network, bluetooth, task manager)
    floatterm = "alacritty --class floatterm -e",
}

HyprDir = os.getenv("HOME") .. "/.config/hypr"
Scripts = HyprDir .. "/scripts/"

-- ── Monitors ────────────────────────────────────────────────────────────────
-- Built-in 13" 4K panel: scale 2 → a sharp 1920×1080 workspace.
hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = 2 })
-- Anything you plug in (HDMI/USB-C) goes to the right of it with a sensible scale.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

-- ── Modules ─────────────────────────────────────────────────────────────────
require("conf.theme")      -- must be first: defines Theme + rgba() used below
require("conf.env")
require("conf.look")
require("conf.input")
require("conf.keybinds")
require("conf.rules")
require("conf.autostart")
