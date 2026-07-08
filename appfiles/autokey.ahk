#Requires AutoHotkey v2.0

A_HotkeyInterval := 2000
A_MaxHotkeysPerInterval := 4000

; ================================================
; Two-finger scroll (direction reversed + throttled)
; ================================================
global lastWheelUpTime := 0
global lastWheelDownTime := 0
global WheelThrottleMs := 70   ; Throttle interval (ms). Higher = slower scrolling, adjust as needed.

$WheelUp::
{
    global lastWheelUpTime, WheelThrottleMs
    now := A_TickCount
    if (now - lastWheelUpTime < WheelThrottleMs)
        return
    lastWheelUpTime := now
    Send "{WheelDown}"
}

$WheelDown::
{
    global lastWheelDownTime, WheelThrottleMs
    now := A_TickCount
    if (now - lastWheelDownTime < WheelThrottleMs)
        return
    lastWheelDownTime := now
    Send "{WheelUp}"
}

; ================================================
; macOS-style key mapping (Alt => Ctrl)
; For AutoHotkey v2
; ================================================

; Basic editing
!c::Send("^c")        ; Alt+C => Copy
!v::Send("^v")        ; Alt+V => Paste
!x::Send("^x")        ; Alt+X => Cut
!a::Send("^a")        ; Alt+A => Select all
!z::Send("^z")        ; Alt+Z => Undo
!+z::Send("^+z")      ; Alt+Shift+Z => Redo

; File operations
!s::Send("^s")        ; Alt+S => Save
!w::Send("^w")        ; Alt+W => Close tab/window
!n::Send("^n")        ; Alt+N => New
!o::Send("^o")        ; Alt+O => Open
!p::Send("^p")        ; Alt+P => Print

; Find & replace
!f::Send("^f")        ; Alt+F => Find
!h::Send("^h")        ; Alt+H => Replace
!g::Send("^g")        ; Alt+G => Go to

; Tab switching (browser/editor)
!t::Send("^t")        ; Alt+T => New tab
!r::Send("^r")        ; Alt+R => Refresh
!l::Send("^l")        ; Alt+L => Focus address bar

; Window management (mimics macOS Cmd+` to cycle windows of the same app)
!`::Send("!{Tab}")    ; Alt+` => Task switch
