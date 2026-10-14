-- ─────────────────────────────────────────────────────────────────────────────
--  Input — UK keyboard, touchpad, touchscreen + pen, gestures
-- ─────────────────────────────────────────────────────────────────────────────
hl.config({
    input = {
        kb_layout  = "gb",
        kb_variant = "",
        kb_options = "",          -- e.g. "caps:escape" to make Caps Lock another Esc

        repeat_rate  = 40,        -- snappier key repeat
        repeat_delay = 250,

        follow_mouse = 1,         -- focus follows the mouse
        sensitivity  = 0,

        touchpad = {
            natural_scroll       = true,
            tap_to_click         = true,
            disable_while_typing = true,
            clickfinger_behavior = true,   -- two-finger click = right click
            scroll_factor        = 0.7,
        },

        -- touchscreen and pen always map to the built-in display
        touchdevice = { output = "eDP-1" },
        tablet      = { output = "eDP-1" },
    },

    gestures = {
        workspace_swipe_distance     = 300,
        workspace_swipe_cancel_ratio = 0.2,
        workspace_swipe_create_new   = true,
    },
})

-- Touchpad gestures
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })                        -- switch workspace
hl.gesture({ fingers = 3, direction = "up",   action = "fullscreen" })                             -- fullscreen on/off
hl.gesture({ fingers = 3, direction = "down", action = "special", workspace_name = "scratch" })     -- scratchpad
