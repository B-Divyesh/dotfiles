# ~/.zprofile — login shells.
# Logging in on tty1 starts Hyprland automatically (start-hyprland = official
# launcher with crash watchdog + safe mode). Other ttys stay plain consoles,
# so Ctrl+Alt+F2 always gives you a rescue shell.
if [[ -z $WAYLAND_DISPLAY && $XDG_VTNR == 1 && $EUID -ne 0 ]] && command -v start-hyprland >/dev/null; then
    exec start-hyprland
fi
