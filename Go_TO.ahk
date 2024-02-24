go_to(x, y, rope_lift_delay := 2.2, down_jump_delay := 1.0) {
    global on

Loop {
    ; Get player coordinates
    ImageSearch, meX, meY, *32 %A_ScriptDir%\me.png, %MAP_REGION%
    whiteroom_check()
    
    ; Check conditions for termination
    if (!on || !meX) {
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("left"), 0)
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("right"), 0)
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("up"), 0)
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("down"), 0)
        return
    }
    
    ; Adjust coordinates
    xx := meX
    yy := meY
    
    ; Move horizontally
    if (x - xx > 34) {
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("left"), 0)
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("right"), 1)
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC(JUMP_KEY), 1)
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC(JUMP_KEY), 1)
        Sleep, 650
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("right"), 0)
        continue
    } else if (xx - x > 34) {
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("right"), 0)
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("left"), 1)
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC(JUMP_KEY), 1)
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC(JUMP_KEY), 1)
        Sleep, 650
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("left"), 0)
        continue
    } else if (x - xx > 3) {
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("left"), 0)
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("right"), 1)
        Sleep, 10
        continue
    } else if (xx - x > 3) {
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("right"), 0)
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("left"), 1)
        Sleep, 10
        continue
    } else {
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("left"), 0)
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("right"), 0)
    }
    
    ; Move vertically
    ImageSearch, meX, meY, *32 %A_ScriptDir%\me.png, %MAP_REGION%
    whiteroom_check()
    if (!on || !meX) {
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("left"), 0)
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("right"), 0)
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("up"), 0)
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("down"), 0)
        return
    }
    
    xx := meX
    yy := meY
    
    if (y - yy > 32) {
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("up"), 0)
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("down"), 1)
        Sleep, 100
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC(JUMP_KEY), 1)
        Sleep, 100
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("down"), 0)
        Sleep, 2000
        continue
    } else if (y - yy > 2) {
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("up"), 0)
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("down"), 1)
        Sleep, 100
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC(JUMP_KEY), 1)
        Sleep, 100
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("down"), 0)
        Sleep, down_jump_delay * 1000
        continue
    } else if (yy - y > 34) {
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("down"), 0)
        Sleep, 100
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC(JUMP_KEY), 1)
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC(ROPE_LIFT_KEY), 1)
            Sleep, rope_lift_delay * 1000
            continue
    } else if (yy - y > 2) {
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("down"), 0)
        Sleep, 100
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC(ROPE_LIFT_KEY), 1)
            Sleep, rope_lift_delay * 1000
            continue
    } else {
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("down"), 0)
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("up"), 0)
        break
    }
}

AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("left"), 0)
AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("right"), 0)
AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("down"), 0)
AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("up"), 0)
return
}
