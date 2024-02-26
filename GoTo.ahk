global teleport := 0 ; 0 = no teleport, 1 = teleport
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
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Space"), 1)
            Continue
        }
        If (FoundX < X - 1)
        {
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Left"), 0)
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Right"), 1)
            Continue
        }
        If (FoundX > X + 1)
        {
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Right"), 0)
            AHI.Instance.SendKeyEvent(KeyboardId, GetKeySC("Left"), 1)
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
