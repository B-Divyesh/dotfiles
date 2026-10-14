-- ─────────────────────────────────────────────────────────────────────────────
--  Window, layer and workspace rules
--  Find an app's class/title with:  hyprctl clients   (layers: hyprctl layers)
-- ─────────────────────────────────────────────────────────────────────────────

-- ── Sensible defaults ───────────────────────────────────────────────────────
hl.window_rule({
    name  = "suppress-maximize-events",      -- apps can't maximise themselves over the tiling
    match = { class = ".*" },
    suppress_event = "maximize",
})
hl.window_rule({
    name  = "fix-xwayland-drags",            -- invisible XWayland drag helpers must not steal focus
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})
hl.window_rule({
    name  = "no-idle-while-fullscreen",      -- videos/games keep the screen on
    match = { class = ".*" },
    idle_inhibit = "fullscreen",
})

-- ── Floating utility windows ────────────────────────────────────────────────
hl.window_rule({
    name  = "float-utilities",
    match = { class = "^(org\\.pulseaudio\\.pavucontrol|nwg-look|swappy|imv|xdg-desktop-portal-gtk|polkit-gnome-authentication-agent-1|gcr-prompter|nm-connection-editor|blueman-manager|org\\.gnome\\.FileRoller)$" },
    float  = true,
    center = true,
})
hl.window_rule({
    name  = "float-terminal-tools",          -- nmtui, bluetui, btop … opened from bar / keys
    match = { class = "^(floatterm)$" },
    float  = true,
    center = true,
    size   = { "monitor_w*0.6", "monitor_h*0.65" },
})
hl.window_rule({
    name  = "float-file-dialogs",
    match = { title = "^(Open File|Open Files|Open Folder|Save File|Save As|Save Image|Select a File|Choose Files?|File Upload|Library)(.*)$" },
    float  = true,
    center = true,
    size   = { "monitor_w*0.6", "monitor_h*0.65" },
})
hl.window_rule({
    name  = "float-thunar-dialogs",
    match = { class = "^([Tt]hunar)$", title = "^(File Operation Progress|Confirm to replace files|Rename .*)$" },
    float = true,
})

-- ── Picture-in-picture (Brave / Firefox): small, pinned, bottom-right ───────
hl.window_rule({
    name  = "pip",
    match = { title = "^(Picture.in.[Pp]icture)$" },
    float             = true,
    pin               = true,
    keep_aspect_ratio = true,
    size              = { "monitor_w*0.3", "monitor_h*0.3" },
    move              = { "monitor_w*0.69", "monitor_h*0.67" },
})

-- ── Android Studio / JetBrains: popups must not steal focus ─────────────────
hl.window_rule({
    name  = "jetbrains-popups",
    match = { class = "^(jetbrains-.*)$", title = "^(win.*)$" },
    no_initial_focus = true,
})

-- ── Layers: frosted bar / launcher / notifications, no fade on capture tools ─
hl.layer_rule({ name = "blur-bar",           match = { namespace = "^(waybar)$" },            blur = true, ignore_alpha = 0.2 })
hl.layer_rule({ name = "blur-launcher",      match = { namespace = "^(launcher)$" },          blur = true, ignore_alpha = 0.2, animation = "popin 92%" })
hl.layer_rule({ name = "blur-notifications", match = { namespace = "^(notifications)$" },     blur = true, ignore_alpha = 0.2, animation = "slide right" })
hl.layer_rule({ name = "no-anim-capture",    match = { namespace = "^(selection|hyprpicker)$" }, no_anim = true })

-- ── AirPods (LibrePods): settings window floats; the case card is frosted ──
hl.window_rule({
    name  = "librepods-window",
    match = { class = "^(librepods|LibrePods|me\\.kavishdevar\\.librepods)$" },
    float  = true,
    center = true,
    size   = { "monitor_w*0.55", "monitor_h*0.75" },
})
hl.layer_rule({ name = "librepods-menu", match = { namespace = "^(librepods-menu)$" }, blur = true, ignore_alpha = 0.3, no_anim = true })   -- bar dropdown
hl.layer_rule({ name = "librepods-card", match = { namespace = "^(librepods-popup)$" }, blur = true, ignore_alpha = 0.3, no_anim = true })   -- the card animates itself

-- ── Workspaces ──────────────────────────────────────────────────────────────
hl.workspace_rule({ workspace = "special:scratch", gaps_out = 48 })   -- scratchpad floats in the middle
