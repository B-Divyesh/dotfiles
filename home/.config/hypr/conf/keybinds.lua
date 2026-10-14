-- ─────────────────────────────────────────────────────────────────────────────
--  Keybinds.  Super + /  (or Super + F1) opens a searchable list of all of them.
--
--  key(keys, action, "description")  → bind + add to the cheat sheet
--  key(keys, action)                 → bind silently (covered by a note())
--  note(keys, "description")         → cheat-sheet line for a family of binds
-- ─────────────────────────────────────────────────────────────────────────────
local M    = "SUPER"
local exec = hl.dsp.exec_cmd
local S    = Scripts
local A    = Apps

local sheet, section = {}, ""
local function group(name) section = name end
local function note(keys, desc) sheet[#sheet + 1] = { section, keys, desc } end
local function key(keys, action, desc, opts)
    opts = opts or {}
    if desc then
        opts.description = desc
        note(keys, desc)
    end
    return hl.bind(keys, action, opts)
end
local function lr() return { locked = true, repeating = true } end   -- works on lock screen + auto-repeat
local function notify(title, body)
    hl.exec_cmd(string.format("notify-send -a Hyprland -t 1600 %q %q", title, body or ""))
end

-- ── Apps ────────────────────────────────────────────────────────────────────
group("Apps")
key(M .. " + Return",      exec(A.terminal),                    "Terminal")
key(M .. " + SHIFT + Return", exec("alacritty --class floatterm"), "Floating terminal")
key(M .. " + E",           exec(A.files),                       "File manager")
key(M .. " + W",           exec(A.browser),                     "Web browser")
key(M .. " + space",       exec("pkill -x fuzzel || fuzzel"),   "App launcher")
key(M .. " + V",           exec(S .. "clipboard"),              "Clipboard history")
key(M .. " + CTRL + V",    exec(S .. "clipboard wipe"),         "Clear clipboard history")
key(M .. " + period",      exec(S .. "emoji"),                  "Emoji picker")
key(M .. " + SHIFT + C",   exec("hyprpicker -a"),               "Colour picker → clipboard")
key("CTRL + SHIFT + Escape", exec(A.floatterm .. " btop"),      "Task manager (btop)")

-- ── Screenshots & recording ─────────────────────────────────────────────────
group("Capture")
key("Print",               exec(S .. "screenshot screen"),      "Screenshot: whole screen")
key(M .. " + SHIFT + S",   exec(S .. "screenshot region"),      "Screenshot: select area")
key("CTRL + Print",        exec(S .. "screenshot window"),      "Screenshot: active window")
key("SHIFT + Print",       exec(S .. "screenshot edit"),        "Screenshot: area → annotate")
key(M .. " + ALT + R",     exec(S .. "record region"),          "Record area (press again to stop)")
key(M .. " + SHIFT + ALT + R", exec(S .. "record screen"),      "Record screen + sound (again to stop)")

-- ── Windows ─────────────────────────────────────────────────────────────────
group("Windows")
key(M .. " + Q",           hl.dsp.window.close(),               "Close window")
key("ALT + F4",            hl.dsp.window.close())
key(M .. " + SHIFT + Q",   hl.dsp.window.kill(),                "Force-kill frozen window")
key(M .. " + F",           hl.dsp.window.fullscreen(),          "Fullscreen")
key(M .. " + D",           hl.dsp.window.fullscreen({ mode = "maximized" }), "Maximise (keep bar + gaps)")
key(M .. " + ALT + space", hl.dsp.window.float({ action = "toggle" }), "Float / tile window")
key(M .. " + C",           hl.dsp.window.center(),              "Centre floating window")
key(M .. " + P",           hl.dsp.window.pin(),                 "Pin floating window to all workspaces")
key(M .. " + SHIFT + P",   hl.dsp.window.pseudo(),              "Pseudo-tile (keep window's own size)")
key(M .. " + J",           hl.dsp.layout("togglesplit"),        "Flip split horizontal / vertical")
key(M .. " + G",           hl.dsp.group.toggle(),               "Tab group on / off")
key(M .. " + CTRL + Tab",  hl.dsp.group.next(),                 "Next tab in group")
key("ALT + Tab", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
end, "Cycle windows")

local arrows = {
    { "left",  "left",  -40,   0 },
    { "right", "right",  40,   0 },
    { "up",    "up",      0, -40 },
    { "down",  "down",    0,  40 },
}
for _, a in ipairs(arrows) do
    local k, dir, dx, dy = a[1], a[2], a[3], a[4]
    key(M .. " + " .. k,           hl.dsp.focus({ direction = dir }))
    key(M .. " + SHIFT + " .. k,   hl.dsp.window.move({ direction = dir }))
    key(M .. " + ALT + " .. k,     hl.dsp.window.resize({ x = dx, y = dy, relative = true }), nil, { repeating = true })
end
note("Super + ←↑↓→",           "Move focus")
note("Super + Shift + ←↑↓→",   "Move window")
note("Super + Alt + ←↑↓→",     "Resize window")
key(M .. " + mouse:272", hl.dsp.window.drag(),   nil, { mouse = true })
key(M .. " + mouse:273", hl.dsp.window.resize(), nil, { mouse = true })
note("Super + Left-drag",      "Move window with the mouse")
note("Super + Right-drag",     "Resize window with the mouse")

-- Resize mode: Super + R, then arrows (or h j k l), Enter/Esc to leave
hl.define_submap("resize", function()
    local step = { left = { -40, 0 }, right = { 40, 0 }, up = { 0, -40 }, down = { 0, 40 },
                   h    = { -40, 0 }, l     = { 40, 0 }, k  = { 0, -40 }, j    = { 0, 40 } }
    for k, d in pairs(step) do
        hl.bind(k, hl.dsp.window.resize({ x = d[1], y = d[2], relative = true }), { repeating = true })
    end
    hl.bind("Return", hl.dsp.submap("reset"))
    hl.bind("escape", hl.dsp.submap("reset"))
end)
key(M .. " + R", hl.dsp.submap("resize"), "Resize mode (arrows / hjkl, Esc to leave)")

-- ── Workspaces ──────────────────────────────────────────────────────────────
group("Workspaces")
for i = 1, 10 do
    local k = tostring(i % 10)
    key(M .. " + " .. k,           hl.dsp.focus({ workspace = i }))
    key(M .. " + SHIFT + " .. k,   hl.dsp.window.move({ workspace = i }))
    key(M .. " + ALT + " .. k,     hl.dsp.window.move({ workspace = i, follow = false }))
end
note("Super + 1…0",            "Go to workspace")
note("Super + Shift + 1…0",    "Move window there and follow it")
note("Super + Alt + 1…0",      "Send window there, stay here")
key(M .. " + Tab",                   hl.dsp.focus({ workspace = "previous" }),   "Back to previous workspace")
key(M .. " + CTRL + right",          hl.dsp.focus({ workspace = "r+1" }),        "Next workspace")
key(M .. " + CTRL + left",           hl.dsp.focus({ workspace = "r-1" }),        "Previous workspace")
key(M .. " + CTRL + SHIFT + right",  hl.dsp.window.move({ workspace = "r+1" }),  "Move window to next workspace")
key(M .. " + CTRL + SHIFT + left",   hl.dsp.window.move({ workspace = "r-1" }),  "Move window to previous workspace")
key(M .. " + mouse_down",            hl.dsp.focus({ workspace = "e+1" }))
key(M .. " + mouse_up",              hl.dsp.focus({ workspace = "e-1" }))
note("Super + scroll",               "Scroll through open workspaces")
note("3-finger swipe ←→",            "Switch workspace (touchpad)")
key(M .. " + S",       hl.dsp.workspace.toggle_special("scratch"),                        "Scratchpad show / hide")
key(M .. " + ALT + S", hl.dsp.window.move({ workspace = "special:scratch", follow = false }), "Send window to scratchpad")

-- ── Notifications ───────────────────────────────────────────────────────────
group("Notifications")
key(M .. " + N",          exec("makoctl dismiss --all"),               "Dismiss all notifications")
key(M .. " + SHIFT + N",  exec("makoctl restore"),                     "Bring back last notification")
key(M .. " + CTRL + N",   exec(S .. "dnd toggle"),                     "Do not disturb on / off")

-- ── Session & toggles ───────────────────────────────────────────────────────
group("System")
key(M .. " + L",             exec("loginctl lock-session"),            "Lock screen")
key(M .. " + Escape",        exec(S .. "powermenu"),                   "Power menu")
key("CTRL + ALT + Delete",   exec(S .. "powermenu"))
key(M .. " + slash",         exec(S .. "keybinds"),                    "This cheat sheet")
key(M .. " + F1",            exec(S .. "keybinds"))
key(M .. " + B",             exec("pkill -SIGUSR1 -x waybar"),         "Hide / show bar")
key(M .. " + CTRL + W",      exec(S .. "wallpaper"),                   "Change wallpaper")
key(M .. " + CTRL + R",      exec(S .. "reload"),                      "Reload everything / revive a crashed bar")
key(M .. " + F2",            exec(S .. "nightlight toggle"),           "Night light on / off")

-- Game mode: no animations, blur, shadows, gaps or rounding. Press again to restore.
key(M .. " + F3", function()
    if hl.get_config("animations.enabled") == false then
        hl.exec_cmd("hyprctl reload")
        notify("Game mode off", "Animations, blur and gaps are back")
        return
    end
    hl.config({
        general    = { gaps_in = 0, gaps_out = 0, border_size = 1 },
        animations = { enabled = false },
        decoration = { rounding = 0, shadow = { enabled = false }, blur = { enabled = false } },
    })
    notify("Game mode on", "Maximum performance — Super + F3 to restore")
end, "Game mode (max performance)")

key(M .. " + F4", exec(S .. "caffeine toggle"), "Caffeine: keep screen awake")

-- Cycle tiling layouts
local layouts = { "dwindle", "master", "scrolling" }
key(M .. " + F5", function()
    local cur, nxt = hl.get_config("general.layout"), layouts[1]
    for i, l in ipairs(layouts) do
        if l == cur then nxt = layouts[i % #layouts + 1] end
    end
    hl.config({ general = { layout = nxt } })
    notify("Layout", nxt)
end, "Cycle layout: dwindle → master → scrolling")

-- ── AirPods (LibrePods) ─────────────────────────────────────────────────────
group("AirPods")
local pods = os.getenv("HOME") .. "/.local/bin/librepods ctl "
key(M .. " + ALT + A",         exec(pods .. "mode next"),  "AirPods: next listening mode (NC → Transparency → Adaptive)")
key(M .. " + ALT + SHIFT + A", exec(pods .. "toggle"),     "AirPods: connect / disconnect")
key(M .. " + ALT + C",         exec(pods .. "ca toggle"),  "AirPods: conversation awareness on / off")
key(M .. " + ALT + P",         exec(pods .. "popup"),      "AirPods: show battery card")
key(M .. " + CTRL + A",        exec(pods .. "open"),       "AirPods settings")
key(M .. " + ALT + B",         exec(S .. "bluetooth toggle"), "Bluetooth on / off")

-- ── Hardware keys (also work on the lock screen) ────────────────────────────
group("Keys")
key("XF86AudioRaiseVolume",  exec(S .. "osd volume up"),       nil, lr())
key("XF86AudioLowerVolume",  exec(S .. "osd volume down"),     nil, lr())
key("XF86AudioMute",         exec(S .. "osd volume mute"),     nil, { locked = true })
key("XF86AudioMicMute",      exec(S .. "osd mic mute"),        nil, { locked = true })
key("XF86MonBrightnessUp",   exec(S .. "osd brightness up"),   nil, lr())
key("XF86MonBrightnessDown", exec(S .. "osd brightness down"), nil, lr())
key("XF86AudioPlay",         exec("playerctl play-pause"),     nil, { locked = true })
key("XF86AudioPause",        exec("playerctl play-pause"),     nil, { locked = true })
key("XF86AudioNext",         exec("playerctl next"),           nil, { locked = true })
key("XF86AudioPrev",         exec("playerctl previous"),       nil, { locked = true })
key(M .. " + SHIFT + M",     exec(S .. "osd volume mute"),     "Mute speakers")
key(M .. " + ALT + M",       exec(S .. "osd mic mute"),        "Mute microphone")
note("Volume / brightness / media keys", "Show an on-screen bar; work on the lock screen too")

-- ── Write the cheat sheet (read by scripts/keybinds) ────────────────────────
local function pretty(k)
    k = k:gsub("SUPER", "Super"):gsub("SHIFT", "Shift"):gsub("CTRL", "Ctrl"):gsub("ALT", "Alt")
    k = k:gsub("Return", "Enter"):gsub("space", "Space"):gsub("slash", "/"):gsub("period", ".")
    k = k:gsub("escape", "Esc"):gsub("Escape", "Esc"):gsub("Print", "PrtSc"):gsub("Delete", "Del")
    k = k:gsub("left$", "←"):gsub("right$", "→"):gsub("up$", "↑"):gsub("down$", "↓")
    return k
end
local cache = (os.getenv("XDG_CACHE_HOME") or (os.getenv("HOME") .. "/.cache")) .. "/hypr-keybinds.txt"
local function pad(s, n) return s .. string.rep(" ", math.max(2, n - (utf8.len(s) or #s))) end
local f = io.open(cache, "w")
if f then
    for _, e in ipairs(sheet) do
        f:write(pad(e[1], 15) .. pad(pretty(e[2]), 30) .. e[3] .. "\n")
    end
    f:close()
end
