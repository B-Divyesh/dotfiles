-- ─────────────────────────────────────────────────────────────────────────────
--  Environment — makes toolkits run natively on Wayland (faster, sharper).
-- ─────────────────────────────────────────────────────────────────────────────

-- Cursor (Adwaita, same size everywhere)
hl.env("XCURSOR_THEME", "Adwaita")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Toolkits: prefer Wayland, fall back to X11 only if an app can't do Wayland
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")   -- VSCodium, Cursor, … run natively
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")       -- Android Studio / Java apps: no blank windows
