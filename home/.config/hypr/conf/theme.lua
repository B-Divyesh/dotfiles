-- ─────────────────────────────────────────────────────────────────────────────
--  Ember — warm dark palette taken from the galaxy wallpaper.
--  Hyprland reads it from here; the same hex values are used in
--  waybar/style.css, fuzzel/fuzzel.ini, mako/config, hyprlock.conf and
--  alacritty/alacritty.toml (search for the hex code to change it everywhere).
-- ─────────────────────────────────────────────────────────────────────────────
Theme = {
    crust    = "0e0a0f",   -- deepest background
    base     = "1a141b",   -- main background
    surface0 = "261c23",
    surface1 = "33262c",
    surface2 = "4a3638",
    overlay  = "7d6a66",   -- muted text / inactive things
    subtext  = "bfa998",
    text     = "f0e4d4",   -- main text (warm white)

    amber    = "e89b5e",   -- primary accent
    ember    = "c8643c",   -- secondary accent (gradient partner)
    gold     = "efcf9f",
    rose     = "e07a7a",
    red      = "e5534b",
    green    = "a8c686",
    blue     = "8cb3d9",
}

-- rgba("e89b5e", 0.5) → "rgba(e89b5e80)"
function rgba(hex, alpha)
    return string.format("rgba(%s%02x)", hex, math.floor((alpha or 1) * 255 + 0.5))
end
