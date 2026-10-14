-- ─────────────────────────────────────────────────────────────────────────────
--  Look & feel — tuned for an Intel UHD 620 driving a 4K panel:
--  cheap blur (xray = computed once from the wallpaper), short snappy
--  animations, opaque windows (translucency is what costs GPU time).
--  Super + F3 = game mode: turns all of this off until you press it again.
-- ─────────────────────────────────────────────────────────────────────────────
local T = Theme

hl.config({
    general = {
        gaps_in     = 4,
        gaps_out    = 8,
        border_size = 2,
        col = {
            active_border   = { colors = { rgba(T.amber), rgba(T.ember) }, angle = 45 },
            inactive_border = rgba(T.surface1, 0.9),
        },
        layout = "dwindle",

        -- grab window edges to resize, windows snap to each other when floating
        resize_on_border        = true,
        extend_border_grab_area = 12,
        hover_icon_on_border    = true,
        snap = { enabled = true, window_gap = 8, monitor_gap = 8, respect_gaps = true },

        allow_tearing = false,
    },

    decoration = {
        rounding       = 12,
        rounding_power = 2.4,          -- slightly squircle corners

        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        dim_special      = 0.35,       -- darken the desktop behind the scratchpad

        shadow = {
            enabled        = true,
            range          = 14,
            render_power   = 3,
            offset         = { 0, 4 },
            color          = rgba(T.crust, 0.55),
            color_inactive = rgba(T.crust, 0.30),
        },

        blur = {
            enabled           = true,
            size              = 6,
            passes            = 2,
            new_optimizations = true,
            xray              = true,   -- blur only the wallpaper → rendered once, nearly free
            noise             = 0.012,
            brightness        = 0.9,
            vibrancy          = 0.2,
            special           = false,  -- no blur behind the scratchpad (expensive at 4K)
            popups            = false,
        },
    },

    animations = { enabled = true },

    -- Layouts (Super + F5 cycles between them)
    dwindle   = { preserve_split = true, force_split = 2 },   -- new window always right/below
    master    = { new_status = "master", mfact = 0.55 },
    scrolling = { fullscreen_on_one_column = true },

    group = {
        col = { border_active = rgba(T.amber), border_inactive = rgba(T.surface1) },
        groupbar = {
            font_family = "Inter",
            font_size   = 11,
            height      = 18,
            rounding    = 6,
            gradients   = true,
            text_color  = rgba(T.text),
            col = { active = rgba(T.amber, 0.65), inactive = rgba(T.surface1, 0.8) },
        },
    },

    misc = {
        disable_hyprland_logo        = true,
        disable_splash_rendering     = true,
        force_default_wallpaper      = 0,
        background_color             = "rgb(" .. T.crust .. ")",
        font_family                  = "Inter",
        focus_on_activate            = true,   -- clicking a link focuses the browser
        mouse_move_enables_dpms      = true,
        key_press_enables_dpms       = true,
        enable_swallow               = true,   -- GUI apps started from the terminal replace it
        swallow_regex                = "^(Alacritty)$",
        animate_manual_resizes       = false,  -- drags feel 1:1, no lag
        animate_mouse_windowdragging = false,
    },

    binds = {
        workspace_back_and_forth         = true,  -- Super+N on the current workspace jumps back
        allow_workspace_cycles           = true,
        hide_special_on_workspace_change = true,
    },

    cursor    = { hide_on_key_press = true },
    render    = { direct_scanout = 2 },            -- zero-copy for fullscreen games / video
    ecosystem = { no_update_news = true, no_donation_nag = true },
})

-- ── Animations: short and springy ───────────────────────────────────────────
-- speed is in tenths of a second (3 = 300 ms). Lower = snappier.
hl.curve("snap",   { type = "spring", mass = 1, stiffness = 380, dampening = 32 })
hl.curve("out",    { type = "bezier", points = { {0.23, 1},  {0.32, 1} } })     -- easeOutQuint
hl.curve("linear", { type = "bezier", points = { {0, 0},     {1, 1}    } })

hl.animation({ leaf = "global",           enabled = true,  speed = 6,   bezier = "default" })
hl.animation({ leaf = "windows",          enabled = true,  speed = 3,   spring = "snap" })
hl.animation({ leaf = "windowsIn",        enabled = true,  speed = 3,   spring = "snap", style = "popin 88%" })
hl.animation({ leaf = "windowsOut",       enabled = true,  speed = 1.6, bezier = "out",  style = "popin 88%" })
hl.animation({ leaf = "windowsMove",      enabled = true,  speed = 3,   spring = "snap" })
hl.animation({ leaf = "border",           enabled = true,  speed = 4,   bezier = "out" })
hl.animation({ leaf = "borderangle",      enabled = false })                   -- no constant redraws
hl.animation({ leaf = "fade",             enabled = true,  speed = 2.5, bezier = "out" })
hl.animation({ leaf = "layersIn",         enabled = true,  speed = 2.5, bezier = "out",  style = "fade" })
hl.animation({ leaf = "layersOut",        enabled = true,  speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "workspaces",       enabled = true,  speed = 3,   bezier = "out",  style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true,  speed = 3,   bezier = "out",  style = "slidevert" })
hl.animation({ leaf = "zoomFactor",       enabled = true,  speed = 5,   bezier = "out" })
