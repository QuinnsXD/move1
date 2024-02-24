#SingleInstance, force
#InstallKeybdHook
#MaxThreadsPerHotkey 5
#include Lib\AutoHotInterception.ahk

global AHI := new AutoHotInterception()
global keyboardId := AHI.GetKeyboardId(0x046D, 0xC232)

gui, +Alwaysontop
gui, color, BF2B24
gui, show, x1 y1 w210 h435 NoActivate,
gui, font, s8
gui, add, groupbox, x5 y5 h90 w200, Controls
gui, add, groupbox, x5 y100 h90 w200, Positions
gui, add, groupbox, x5 y265 h45 w200, JumpHeight
gui, font, s15
gui, add, button, w140 h24 x35 y15 gReload1, Reload
gui, add, text, x30 y40, F3 =
gui, add, button, w100 h24 x85 y40 gStart1 vStart1, Start
gui, add, text, x30 y65, F4 =
gui, add, button, w100 h24 x85 y65 gPause1 vPause1 , Pause
gui, add, text, x30 y110, F6 =
gui, add, button, w100 h24 x85 y110 gLEFTPOS vLButton , Left
gui, add, text, x30 y135, F7 =
gui, add, button, w100 h24 x85 y135 gRIGHTPOS vRButton , Right
gui, add, text, x30 y160, F8 =
gui, add, button, w100 h24 x85 y160 gTOPPOS vTButton , Top
gui, add, radio, y280 x8 gLow checked group, Low
gui, add, radio, y280 x73 gMed, Med
gui, add, radio, y280 x138 gHigh, High
gui, add, text, x8 y315 , RopeDelay :
iniread, RopeDelay, Map.ini, MapPos, RopeDelay, %A_Space%
gui, add, edit, x120 y315 h25 w70 vropedelay gsubmitla, %ropedelay%
gui, add, checkbox, y345 x5 gvertical, Vertical
gui, add, checkbox, y345 x100 gclockwise, Clockwise
gui, add, checkbox, x5 y375 grope, Rope
gui, add, checkbox, x100 y375 galarms checked, Alarms
Gui, add, text, x55 y405 c0000A0, C&M Edition
IniRead, LeftX, Map.ini, MapPos, LeftX
Iniread, RightX, Map.ini, MapPos, RightX
Iniread, TopY, Map.ini, MapPos, TopY
MidX := ((RightX - LeftX) / 2) + LeftX ; middle of the boundaries
clockwise := false
vertical := false
rope := false
jump1 := 40
jump2 := 60
exps := false
wealths := false
doubleexps := false
gosub, alarms
return
submitla:
    gui, submit, nohide
    iniwrite, %ropedelay%, Map.ini, MapPos, RopeDelay
return

double:
    if(double) {
        double := false
    } else {
        double := true
    }
return

rope:
    if(rope) {
        rope := false
    } else {
        rope := true
    }
return

clockwise:
    if(clockwise) {
        clockwise := false
    } else {
        clockwise := true
    }
return

vertical:
    if(vertical) {
        vertical := false
    } else {
        vertical := true
    }
return

guiclose:
ExitApp
return

Low:
    jump1 := 40
    jump2 := 60
return

Med:
    jump1 := 70
    jump2 := 90
return

High:
    jump1 := 90
    jump2 := 110
return

Start1:
    atk()
return

Pause1:
    Winactivate, ahk_class MapleStoryClass
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 0)
    Pause ,,1
    if A_IsPaused
    {
        TrayTip, `t, BOT HAS PAUSED
        guicontrol, text , Pause1 , Resume
    }
    else
    {
        TrayTip, `t, BOT HAS RESUMED
        guicontrol, text , Pause1 , Pause
    }
return

Reload1:
    Reload
return
LEFTPOS:
    Winactivate, ahk_class MapleStoryClass
    ImageSearch,leftx,lefty,1,1,1920,1080, *10 me.png
    if (ErrorLevel=0)
    {
        IniWrite, %leftx%, Map.ini, MapPos, LeftX
        MidX := ((RightX - LeftX) / 2) + LeftX
        guicontrol,text, LButton, Left(%LeftX%)
    }
    Else
    {
        TrayTip, `t,Minimap not found
    }
return
RIGHTPOS:
    Winactivate, ahk_class MapleStoryClass
    ImageSearch,rightx,righty,1,1,1920,1080, *10 me.png
    if (ErrorLevel=0)
    {
        IniWrite, %rightx%, Map.ini, MapPos, RightX
        MidX := ((RightX - LeftX) / 2) + LeftX
        guicontrol,text, RButton, Right(%RightX%)
    }
    Else
    {
        TrayTip, `t,Minimap not found
    }
return
TOPPOS:
    Winactivate, ahk_class MapleStoryClass
    ImageSearch,topx,topy,1,1,1920,1080, *10 me.png
    if (ErrorLevel=0)
    {
        IniWrite, %topy%, Map.ini, MapPos, TopY
        guicontrol,text, TButton, Top(%TopY%)
    }
    Else
    {
        TrayTip, `t,Minimap not found
    }
return
f8::
    Winactivate, ahk_class MapleStoryClass
    ImageSearch,topx,topy,1,1,1920,1080, *10 me.png
    if (ErrorLevel=0)
    {
        IniWrite, %topy%, Map.ini, MapPos, TopY
        guicontrol,text, TButton, Top(%TopY%)
    }
    Else
    {
        TrayTip, `t,Minimap not found
    }
return
f6::
    Winactivate, ahk_class MapleStoryClass
    ImageSearch,leftx,lefty,1,1,1920,1080, *10 me.png
    if (ErrorLevel=0)
    {
        IniWrite, %leftx%, Map.ini, MapPos, LeftX
        MidX := ((RightX - LeftX) / 2) + LeftX
        guicontrol,text, LButton, Left(%LeftX%)
    }
    Else
    {
        TrayTip, `t,Minimap not found
    }
return
f7::
    Winactivate, ahk_class MapleStoryClass
    ImageSearch,rightx,righty,1,1,1920,1080, *10 me.png
    if (ErrorLevel=0)
    {
        IniWrite, %rightx%, Map.ini, MapPos, RightX
        MidX := ((RightX - LeftX) / 2) + LeftX
        guicontrol,text, RButton, Right(%RightX%)
    }
    Else
    {
        TrayTip, `t,Minimap not found
    }
return
f4::
    Winactivate, ahk_class MapleStoryClass
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 0)
    Pause ,,1
    if A_IsPaused
    {
        TrayTip, `t, BOT HAS PAUSED
        guicontrol, , Pause1 , Resume
    }
    else
    {
        TrayTip, `t, BOT HAS RESUMED
        guicontrol, , Pause1 , Pause
    }
return

f3::
    atk(){
        global
        Winactivate, ahk_class MapleStoryClass ;script only active when maplestory window is active
        ;dominion()
        shadowspear()
        ;spider()                ; these are all function calls 

        servant := false
        shadowbats := true
        penguin := false
        omen := true
        shower := true

        loop{

            if (clockwise) {
                if (shower) {
                    sleep 300
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 1)
                    sleep 50
                    loop 3 {
                        random, ran, 88,115
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("c"), 1) ; c is Erda Shower
                        sleep %ran%
                        random, ran, 88,115
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("c"), 0)
                        sleep %ran%
                    }
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 0)
                    sleep 455
                    shower := false
                    SetTimer, shower, -120000 								; timer for shower starts
                }
                if(penguin) {												;5th job cygnus phalanx charge
                    loop 3 {
                        random, ran, 88,115
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("5"), 1)
                        sleep %ran%
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("5"), 0)
                        sleep %ran%
                    }
                    sleep 500
                    penguin := false
                    SetTimer, penguin, -30000 								; timer for penguine starts
                }

                ; regardless of above if statements, code progresses to below

                ImageSearch,vX,vY,1,1,1920,1080, *1 me.png

                while(vX > MidX && Errorlevel = 0) {						; while character is on the right side 
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 1)			; Send left key down 
                    sleep 100
                    loop 3 {
                        random, jump, %jump1%, %jump2%							; random is built-in function, gets random number between jump1 and jump2 and assign to jump variable
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Alt"), 1)
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Alt"), 0)
                        sleep %jump%											; %jump% is more like a delay than actual jump 
                    }

                    if(shadowbats) {												
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("PgDn"), 1)
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("PgDn"), 0)
                        shadowbats := false
                        SetTimer, shadowbats, -25000

                    } else if (omen) {
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Del"), 1)
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Del"), 0)
                        sleep 50
                        SetTimer, omen, -30000
                        omen := false
                    }

                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("a"), 1) ; main mobbing skill is on "a" button
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("a"), 0)
                    sleep 550
                    ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
                }

                ; It should now be on the left side of the map / boundary 

                if(servant) {
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0) ; release Left key just in case 
                    sleep 200
                    loop 3 {
                        random, ran, 88,115
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("PgUp"), 1)
                        sleep %ran%
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("PgUp"), 0)
                        sleep %ran%
                    }
                    sleep 500
                    servant := false
                    SetTimer, servant, -60000
                }

                ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
                while(vX > LeftX && Errorlevel = 0) { 						; while current position is not further left than left boundary
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 1)
                    sleep 100
                    loop 3 {
                        random, jump, %jump1%, %jump2%
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Alt"), 1)
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Alt"), 0)
                        sleep %jump%
                    }

                    if(shadowbats) {
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("PgDn"), 1)
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("PgDn"), 0)
                        shadowbats := false
                        SetTimer, shadowbats, -25000

                    } else if (omen) {
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Del"), 1)
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Del"), 0)
                        sleep 50
                        SetTimer, omen, -30000
                        omen := false
                    }

                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("a"), 1)
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("a"), 0)
                    sleep 550
                    ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
                }

                ; breaks out of loop when outside of left boundary

                AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
                sleep 200
                ImageSearch,vX,vY,1,1,1920,1080, *1 me.png

                if(Errorlevel = 1) {										; if imagesearch above is unsuccessful
                    critical, on											; prio ON
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 1)	; turn char right
                    sleep 800
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)
                    critical, off											; prio OFF
                }

                if(vertical) {
                    if(vY > TopY && Errorlevel = 0) {								; check if character is below top boundary, if so, it goes right, then rope lifts
                        ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
                        vX2 := vX + 1												; assigns value of (current X + 1) to variable vX2

                        while(vX < vX2 && Errorlevel = 0) { 						; While current position is to the left of the initial position, walk right
                            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 1)
                            sleep 25
                            ImageSearch,vX,vY,1,1,1920,1080, *1 me.png			
                        }

                        if(rope) {
                            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("j"), 1)
                            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("j"), 0)
                            sleep %ropedelay%
                            loop 2 {
                                AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("j"), 1)
                                AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("j"), 0)
                                sleep 50
                            }
                            sleep 300

                        } else {
                            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Alt"), 1)
                            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Alt"), 0)
                            sleep 150
                            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 1)
                            sleep 50
                            loop 2 {
                                AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Alt"), 1)
                                AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Alt"), 0)
                                sleep 50
                            }
                            sleep 650
                            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 0)
                            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("a"), 1)
                            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("a"), 0)
                            sleep 550
                        }
                        ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
                    }
                    sleep 100
                }

                ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
                while(vX < RightX && Errorlevel = 0) {
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 1)
                    sleep 100
                    loop 3 {
                        random, jump, %jump1%, %jump2%
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Alt"), 1)
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Alt"), 0)
                        sleep %jump%
                    }
                    if(shadowbats) {
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("PgDn"), 1)
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("PgDn"), 0)
                        shadowbats := false
                        SetTimer, shadowbats, -25000
                    }else if (omen) {
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Del"), 1)
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Del"), 0)
                        sleep 50
                        SetTimer, omen, -30000
                        omen := false
                    }
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("a"), 1)
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("a"), 0)
                    sleep 550
                    ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
                }

                AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)
                sleep 200
                ImageSearch,vX,vY,1,1,1920,1080, *1 me.png

                if(Errorlevel = 1) {
                    critical, on
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 1)
                    sleep 800
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
                    critical, off
                }

                if(vertical) {
                    while(vY < TopY && Errorlevel = 0) {
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 1)
                        sleep 50
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Alt"), 1)
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Alt"), 0)
                        sleep 100
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("a"), 1)
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("a"), 0)
                        sleep 700
                        ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
                    }
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 0)
                    sleep 100
                }
            } else {														;IF NOT CLOCKWISE 
                if (shower) {
                    sleep 300
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 1)
                    sleep 50
                    loop 3 {
                        random, ran, 88,115
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("c"), 1)
                        sleep %ran%
                        random, ran, 88,115
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("c"), 0)
                        sleep %ran%
                    }
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 0)
                    sleep 455
                    shower := false
                    SetTimer, shower, -120000
                }
                if(penguin) {
                    loop 3 {
                        random, ran, 88,115
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("5"), 1)
                        sleep %ran%
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("5"), 0)
                        sleep %ran%
                    }
                    sleep 500
                    penguin := false
                    SetTimer, penguin, -30000
                }

                ImageSearch,vX,vY,1,1,1920,1080, *1 me.png 				; when it's on left side of map
                while(vX < MidX && Errorlevel = 0) {
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 1)
                    sleep 100
                    loop 3 {
                        random, jump, %jump1%, %jump2%
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Alt"), 1)
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Alt"), 0)
                        sleep %jump%
                    }
                    if(shadowbats) {
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("PgDn"), 1)
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("PgDn"), 0)
                        shadowbats := false
                        SetTimer, shadowbats, -25000
                    } else if (omen) {
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Del"), 1)
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Del"), 0)
                        sleep 50
                        SetTimer, omen, -30000
                        omen := false
                    }
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("a"), 1)
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("a"), 0)
                    sleep 550
                    ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
                }

                if(servant) {
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)
                    sleep 200
                    loop 3 {
                        random, ran, 88,115
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("PgUp"), 1)
                        sleep %ran%
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("PgUp"), 0)
                        sleep %ran%
                    }
                    sleep 500
                    servant := false
                    SetTimer, servant, -60000
                }

                ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
                while(vX < RightX && Errorlevel = 0) {
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 1)
                    sleep 100
                    loop 3 {
                        random, jump, %jump1%, %jump2%
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Alt"), 1)
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Alt"), 0)
                        sleep %jump%
                    }
                    if(shadowbats) {
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Ins"), 1)
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Ins"), 0)
                        shadowbats := false
                        SetTimer, shadowbats, -15000
                    } else if (omen) {
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Del"), 1)
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Del"), 0)
                        sleep 50
                        SetTimer, omen, -4000
                        omen := false
                    }

                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("a"), 1)
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("a"), 0)
                    sleep 550
                    ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
                }
                AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)
                sleep 200

                ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
                if(Errorlevel = 1) {
                    critical, on
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 1)
                    sleep 800
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
                    critical, off
                }

                if(vertical) {
                    if(vY > TopY && Errorlevel = 0) {
                        ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
                        vX2 := vX - 1
                        while(vX > vX2 && Errorlevel = 0) {
                            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 1)
                            sleep 25
                            ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
                        }

                        if(rope) {
                            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("j"), 1)
                            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("j"), 0)
                            sleep %ropedelay%
                            loop 2 {
                                AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("j"), 1)
                                AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("j"), 0)
                                sleep 50
                            }
                            sleep 300
                        } else {
                            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Alt"), 1)
                            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Alt"), 0)
                            sleep 150
                            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 1)
                            sleep 50
                            loop 2 {
                                AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Alt"), 1)
                                AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Alt"), 0)
                                sleep 50
                            }
                            sleep 650
                            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 0)
                            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("a"), 1)
                            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("a"), 0)
                            sleep 550
                        }
                        ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
                    }
                    sleep 100
                }

                ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
                while(vX > LeftX && Errorlevel = 0) {
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 1)
                    sleep 100
                    loop 3 {
                        random, jump, %jump1%, %jump2%
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Alt"), 1)
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Alt"), 0)
                        sleep %jump%
                    }
                    if(shadowbats) {									; shadowbats is variable for Timer, this line is essentially if the timer went off
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("PgDn"), 1)
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("PgDn"), 0)
                        shadowbats := false									; resets the variable for timer.
                        SetTimer, shadowbats, -25000						; starts the timer
                    } else if (omen) {									; if shadowbats timer did not go off, it will check if OMEN timer went off
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Del"), 1)
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Del"), 0)
                        sleep 50
                        SetTimer, omen, -30000
                        omen := false
                    }
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("a"), 1)
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("a"), 0)
                    sleep 550
                    ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
                }
                AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
                sleep 200
                ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
                if(Errorlevel = 1) {
                    critical, on
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 1)
                    sleep 800
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)
                    critical, off
                }
                if(vertical) {
                    while(vY < TopY && Errorlevel = 0) {
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 1)
                        sleep 50
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Alt"), 1)
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Alt"), 0)
                        sleep 100
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("a"), 1)
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("a"), 0)
                        sleep 700
                        ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
                    }
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 0)
                    sleep 100
                }
            }
        }
        return

    }
servant:
    servant := true
return
shower:
    shower := true
return
omen:
    omen := true
return

totem:
    totem()
return

totem() {
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 0)
    sleep 1000
    loop 5 {
        random, ran, 88,115
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("1"), 1)
        sleep %ran%
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("1"), 0)
        sleep %ran%
    }
    sleep 500
    loop 5 {
        random, ran, 88,115
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("3"), 1)
        sleep %ran%
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("3"), 0)
        sleep %ran%
    }
    sleep 500
    SetTimer, totem, -75000
}

shadowspear:
    shadowspear()
return

shadowspear() {
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 0)
    sleep 500
    loop 3 {
        random, ran, 88,115
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Home"), 1)
        sleep %ran%
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Home"), 0)
        sleep %ran%
    }
    sleep 500
    SetTimer, shadowspear, -173000
}

shadowbats:
    shadowbats := true
return

dominion:
    dominion()
return

dominion() {

    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 0)
    sleep 500
    loop 3 {
        random, ran, 88,115
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("PgDn"), 1)
        sleep %ran%
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("PgDn"), 0)
        sleep %ran%
    }
    sleep 500
    SetTimer, shadow ,-30000
}

shadow:
    shadow()
return
shadow() {
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 0)
    sleep 500
    loop 3 {
        random, ran, 88,115
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("End"), 1)
        sleep %ran%
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("End"), 0)
        sleep %ran%
    }
    sleep 500
    SetTimer, dominion, -150000
}
spider:
    spider()
return
spider() {
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 0)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 0)
    sleep 500
    loop 3 {
        random, ran, 88,115
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("2"), 1)
        sleep %ran%
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("2"), 0)
        sleep %ran%
    }
    sleep 500
    loop 3 {
        random, ran, 88,115
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("x"), 1)
        sleep %ran%
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("x"), 0)
        sleep %ran%
    }
    sleep 500
    SetTimer, spider, -240000
}
penguin:
    penguin := true
return
alarms:
    if(alarms) {
        SetTimer, rune, off
        alarms := false
    } else {
        rune()
        alarms := true
    }
return
rune:
    rune()
return
rune() {
    ImageSearch,RuneX,RuneY,1,1,1920,1080, *1 guild.png
    if(Errorlevel = 0) {
        TrayTip, `t, Guildie Entered Map
        SoundPlay, alarm.mp3
    }
    ImageSearch,RuneX,RuneY,1,1,1920,1080, *1 people.png
    if(Errorlevel = 0) {
        TrayTip, `t, Stranger Entered Map
        SoundPlay, alarm.mp3
    }
    ImageSearch,RuneX,RuneY,1,1,1920,1080, *1 buddy.png
    if(Errorlevel = 0) {
        TrayTip, `t, Buddy Entered Map
        SoundPlay, alarm.mp3
    }
    ImageSearch,RuneX,RuneY,1,1,1920,1080, *1 eb.png
    if(Errorlevel = 0) {
        TrayTip, `t, Eb Spawned
        SoundPlay, alarm.mp3
    }
    ImageSearch,RuneX,RuneY,1,1,1920,1080, *1 rune.png
    if(Errorlevel = 0) {
        TrayTip, `t, Rune Spawned
        SoundPlay, alarm.mp3
    }
    SetTimer, rune, -15000
}