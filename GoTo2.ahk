global teleport := 1 ; 0 = no teleport, 1 = teleport
attackdelay2 := 70



goTo(X, Y)
{
    Loop
    {
        ImageSearch, FoundX, FoundY, 0, 0, 400, 400, me.png
        If (Abs(FoundX - X) <= 1)
        {
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Left"), 0)
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Right"), 0)
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("a"), 0)
        }
        If (FoundX < X - 28 && teleport = 0)
        {
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Left"), 0)
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Right"), 1)
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Space"), 1)
            Sleep 100
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Space"), 0)
            Sleep 50
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Space"), 1)
            Sleep 100
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Space"), 0)
            Sleep 500
            Continue
        }
        If (FoundX > X + 28 && teleport = 0)
        {
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Right"), 0)
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Left"), 1)
            Sleep 1000
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Space"), 1)
            Sleep 100
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Space"), 0)
            Sleep 50
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Space"), 1)
            Sleep 100
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Space"), 0)
            Sleep 500
            Continue

        }
        If (FoundX < X - 20 && teleport = 1)
        {
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Left"), 0)
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Right"), 1)
            Sleep 1000
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Space"), 1)
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("d"), 1)
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("d"), 0)
            sleep %attackdelay2%
            Continue
        }
        If (FoundX > X + 20 && teleport = 1)
        {
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Right"), 0)
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Left"), 1)
            Sleep 1000
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Space"), 1)
            Continue
        }
        If (FoundX < X - 1)
        {
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Left"), 0)
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Right"), 1)
            Sleep 10
            Continue
        }
        If (FoundX > X + 1)
        {
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Right"), 0)
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Left"), 1)
            Sleep 10
            Continue
        }
        If (FoundY < Y - 2)
        {
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Up"), 1)
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Down"), 1)
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Space"), 1)
            Sleep 200
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Up"), 0)
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Down"), 0)
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Space"), 0)
            Sleep 1500
            Continue
        }
        If (FoundY > Y + 2)
        {   
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("v"), 1)
            Sleep 100
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("v"), 0)
            Sleep 2000
            Continue
        }
        Break
    }
}

hwnd := 0 ; Set hwnd to the appropriate window handle

get_adjusted_coords(coords) {
    WinGetPos, x, y, , , ahk_id %hwnd%
    x := Max(0, x)
    y := Max(0, y)
    if (ArrLen(coords) = 2) {
        return coords.1 + x + 10, coords.2 + y
    }
    return coords.1 + x + 10, coords.2 + y, coords.3 + x - 30, coords.4 + y - 30
}

get_adjusted_found_coords(coords) {
    return coords.1, coords.2
}

go_to(x, y, rope_lift_delay := 2.2, down_jump_delay := 1.0) {
    global on

    ; Main loop for movement
    while (true) {
        ; Perform image search for player's position
        ImageSearch, vX, vY, 1, 1, 1920, 1080, *1 me.png

        ; Check if player is still active and the image is found
        if (!on || ErrorLevel) {
            release('left')
            release('right')
            release('up')
            release('down')
            return
        }

        ; Adjust coordinates
        ; Example: xx, yy = get_adjusted_found_coords((vX, vY))
        ; Perform actions based on coordinates

        ; Simulate key presses for movement
        if (x - xx > 34) {
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 1)
            Sleep 1000 ; Adjust sleep duration as needed
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)
            continue
        } else if (xx - x > 34) {
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 1)
            Sleep 1000 ; Adjust sleep duration as needed
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
            continue
        } else if (x - xx > 3) {
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 1)
            Sleep 10 ; Adjust sleep duration as needed
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
            continue
        } else if (xx - x > 3) {
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 1)
            Sleep 10 ; Adjust sleep duration as needed
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)
            continue
        } else {
            release('left')
            release('right')
        }

        ; More conditions and key presses for different movements

        ; Sleep for a short duration before next iteration
        Sleep 50
    }

    ; Additional actions or cleanup after the loop ends
    release('left')
    release('right')
    release('up')
    release('down')
    return
}

SetHwnd() {
    Loop {
        try {
            hwnd := ""
            WinGet, hwnd, ID, A

            if hwnd {
                WinGetTitle, title, ahk_id %hwnd%
                IfInString, title, MapleStory
                    return hwnd
            }
        } catch {
            ; Do nothing or add any desired error handling here
        }
        Sleep, 3000
    }
}

GetAdjustedCoords(coords) {
    global hwnd

    WinGetPos, , , width, height, ahk_id %hwnd%
    x := Max(0, width)
    y := Max(0, height)
    if (ArrLen(coords) = 2)
        return coords.1 + x + 10, coords.2 + y
    return coords.1 + x + 10, coords.2 + y, coords.3 + x - 30, coords.4 + y - 30
}

GetAdjustedFoundCoords(coords) {
    return coords.1, coords.2
}

Release(key) {
    global context
    global keyboard_id
    global on
    global key_states

    if (!on)
        return

    if (!key_states.HasKey(key))
        return

    if (key_states[key] = 0)
        return

    key_states[key] := 0

    ; Uncomment the following line to print key states
    ; MsgBox % key_states

    if (key in arrow_keys)
        context.send(keyboard_id, key_stroke(arrow_keys[key], 3, 0))
    else
        context.send(keyboard_id, key_stroke(keys[key], 1, 0))
}

SetHwnd() {
    Loop {
        try {
            hwnd := ""
            WinGet, hwnd, ID, A

            if hwnd {
                WinGetTitle, title, ahk_id %hwnd%
                IfInString, title, MapleStory
                    return hwnd
            }
        } catch {
            ; You can add error handling here if needed
        }
        Sleep, 3000
    }
}

GetAdjustedCoords(coords) {
    global hwnd

    WinGetPos, , , width, height, ahk_id %hwnd%
    x := Max(0, width)
    y := Max(0, height)
    if (ArrLen(coords) = 2)
        return coords.1 + x + 10, coords.2 + y
    return coords.1 + x + 10, coords.2 + y, coords.3 + x - 30, coords.4 + y - 30
}

GetAdjustedFoundCoords(coords) {
    return coords.1, coords.2
}
go_to(x, y, rope_lift_delay := 2.2, down_jump_delay := 1.0) {
    global on

    Loop {
        ; Perform image search for player's position
        ImageSearch, FoundX, FoundY, 0, 0, 1920, 1080, C:\path\to\me.png

        ; Check if player is still active and the image is found
        if (!on || ErrorLevel) {
            release("left")
            release("right")
            release("up")
            release("down")
            return
        }

        ; Adjust coordinates
        ; Example: xx, yy := get_adjusted_found_coords(FoundX, FoundY)
        ; Perform actions based on coordinates

        ; Simulate key presses for movement
        if (x - FoundX > 34) {
            release("left")
            hold("right")
            ; send_key(JUMP_KEY)
            ; send_key(JUMP_KEY)
            ; Use Send command to send keystrokes in AHK
            Send {JUMP_KEY}
            Send {JUMP_KEY}
            Sleep, 650 ; Milliseconds
            release("right")
            continue
        } else if (FoundX - x > 34) {
            release("right")
            hold("left")
            ; send_key(JUMP_KEY)
            ; send_key(JUMP_KEY)
            Send {JUMP_KEY}
            Send {JUMP_KEY}
            Sleep, 650 ; Milliseconds
            release("left")
            continue
        } else if (x - FoundX > 3) {
            release("left")
            hold("right")
            Sleep, 10 ; Milliseconds
            continue
        } else if (FoundX - x > 3) {
            release("right")
            hold("left")
            Sleep, 10 ; Milliseconds
            continue
        } else {
            release("left")
            release("right")
        }

        ; More conditions and key presses for different movements

        ; Sleep for a short duration before next iteration
        Sleep, 50
    }

    ; Additional actions or cleanup after the loop ends
    release("left")
    release("right")
    release("down")
    release("up")
    return
}

go_to2()
{
    Loop
    {
        ImageSearch, FoundX, FoundY, 0, 0, 400, 400, me.png

if (x2 - x1 > 31) {
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 1)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 1)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 1)
    Sleep 800
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)
    continue
} else if (x1 - x2 > 31) {
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 1)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 1)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 1)
    Sleep 800
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
    continue
} else if (x2 - x1 > 8) {
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 1)
    Sleep 100
    continue
} else if (x1 - x2 > 8) {
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 1)
    Sleep 100
    continue
} else if (3 < x2 - x1 <= 8) {
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 1)
    Sleep 200
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)
    Sleep 200
    continue
} else if (3 < x1 - x2 <= 8) {
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 1)
    Sleep 200
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
    Sleep 200
    continue
} else if (x1 - x2 <= 0) {
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 1)
    Sleep 100
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)
    Sleep 200
} else if (x1 - x2 > 0) {
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 1)
    Sleep 100
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
    Sleep 200
}

if (y2 - y1 > 15) {
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 1)
    Sleep 200
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 1)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 1)
    Sleep 300
    Sleep 200
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 0)
    Sleep 2000
    continue
} else if (y2 - y1 > 5) {
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 1)
    Sleep 200
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 1)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 1)
    Sleep 300
    Sleep 200
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 0)
    Sleep 1000
    continue
} else if (y1 - y2 > 5) {
    Sleep 100
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 1)
    Sleep 100
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("A"), 1)
    Sleep 2200
    continue
}
    }
}

break

go_to2()
{
    Loop
    {
        ImageSearch, FoundX, FoundY, 0, 0, 400, 400, me.png
        
        if (FoundX = 0 && FoundY = 0)
            break

        if (FoundX - x1 > 31) {
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 1)
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 1)
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 1)
            Sleep 800
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 0)
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)
            continue
        } else if (x1 - FoundX > 31) {
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 1)
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 1)
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 1)
            Sleep 800
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 0)
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
            continue
        } else if (FoundX - x1 > 8) {
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 1)
            Sleep 100
            continue
        } else if (x1 - FoundX > 8) {
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 1)
            Sleep 100
            continue
        } else if (3 < FoundX - x1 <= 8) {
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 1)
            Sleep 200
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)
            Sleep 200
            continue
        } else if (3 < x1 - FoundX <= 8) {
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 1)
            Sleep 200
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
            Sleep 200
            continue
        } else if (x1 - FoundX <= 0) {
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 1)
            Sleep 100
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)
            Sleep 200
        } else if (x1 - FoundX > 0) {
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 1)
            Sleep 100
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
            Sleep 200
        }

        if (FoundY - y1 > 15) {
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 1)
            Sleep 200
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 1)
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 1)
            Sleep 300
            Sleep 200
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 0)
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 0)
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 0)
            Sleep 2000
            continue
        } else if (FoundY - y1 > 5) {
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 1)
            Sleep 200
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 1)
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 1)
            Sleep 300
            Sleep 200
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 0)
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 0)
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 0)
            Sleep 1000
            continue
        } else if (y1 - FoundY > 5) {
            Sleep 100
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 1)
            Sleep 100
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("A"), 1)
            Sleep 2200
            continue
        }
    }
}
