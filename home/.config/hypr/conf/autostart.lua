-- ─────────────────────────────────────────────────────────────────────────────
--  Autostart — everything here is a small native program (no Qt, no Python).
--  Runs once per login (not on config reload).
-- ─────────────────────────────────────────────────────────────────────────────
local startup = {
    -- let D-Bus / systemd-activated services (portals, keyring…) see this session
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE XCURSOR_THEME XCURSOR_SIZE GDK_BACKEND QT_QPA_PLATFORM ELECTRON_OZONE_PLATFORM_HINT",

    "hyprpaper",                                            -- wallpaper
    "waybar",                                               -- bar
    "mako",                                                 -- notifications
    "hypridle",                                             -- dim → lock → screen off → suspend
    "hyprsunset",                                           -- night light schedule (hyprsunset.conf)
    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1",  -- password dialogs for GUI apps
    -- AirPods (LibrePods, systemd user service so it restarts if it crashes)
    "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE && systemctl --user restart librepods.service",

    "wl-paste --type text  --watch cliphist store",         -- clipboard history
    "wl-paste --type image --watch cliphist store",
    "wl-clip-persist --clipboard regular",                  -- copied text survives closing the app

    Scripts .. "gtk-theme",                                 -- dark GTK theme, icons, fonts, cursor

    -- first login only: a hint where to find everything
    "f=~/.cache/hypr-welcomed; [ -e $f ] || { sleep 3; notify-send -a Hyprland -t 12000 'Welcome to Hyprland' 'Super + /  →  every shortcut\nSuper + Space  →  apps\nSuper + Esc  →  power menu'; touch $f; }",
}

hl.on("hyprland.start", function()
    for _, cmd in ipairs(startup) do
        hl.exec_cmd(cmd)
    end
end)
