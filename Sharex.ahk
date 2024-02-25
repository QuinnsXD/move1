#SingleInstance, force
#InstallKeybdHook
#MaxThreadsPerHotkey 5
#include Lib\AutoHotInterception.ahk

global AHI := new AutoHotInterception()
keyboardId := AHI.GetKeyboardId(0x2516, 0x008F)

f2::
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)	
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)	
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 0)	
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 0)	
    reload
return

f3::
    LeftX := 93
    RightX := 145
    loot := True
    gosub, main
return

f4::
    MouseGetPos, xpos, ypos 
    MsgBox, The cursor is at X%xpos% Y%ypos%.

f5::
    Reload
Return

f1::
    LeftX := 70
    RightX := 120
    loot := False
    SetTimer, loot, -80000 ; loot timer
    gosub, main
return

main:
    loop{
        ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
        while (vX < RightX && Errorlevel = 0) {
            gosub, atkright2
            ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
            Sleep 50
        }

        critical, on
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("r"), 0)
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("t"), 0)
        critical, off

        Sleep, 500
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("r"), 1)
        Sleep, 500
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("r"), 0)
        Sleep 200

        ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
        while (vX > LeftX && Errorlevel = 0) {
            gosub, atkleft2
            ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
        }

        critical, on
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("r"), 0)
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)	
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("t"), 0)		
        critical, off 

        Sleep 500
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("r"), 1)
        Sleep, 500
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("r"), 0)
        Sleep 200

        ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
        if (vY > 100 && Errorlevel = 0){
            while (vX < 90 && Errorlevel = 0) {
                gosub, atkright2
                ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
                Sleep 50
            }
            critical, on
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("t"), 0)
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("r"), 0)
            critical, off
            Sleep 200
            ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
            while (100 < vY && Errorlevel = 0) {							;tp up from bottom plat to 2nd platform
                gosub, tpup
                ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
                Sleep 50
            }
        }

        ; LOOT ROTATION BELOW

        if (loot && Errorlevel = 0){
            Sleep, 500
            ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
            while (vX > 40 && Errorlevel = 0){
                gosub, atkleft2
                ImageSearch,vX,vY,1,1,1920,1080, *1 me.png	
                Sleep 50
            }
            critical, on
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("t"), 0)
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("r"), 0)
            critical, off

            while (105 > vY && Errorlevel = 0){							;tp down to bottom platform
                gosub, tpdown
                ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
                Sleep 50
            }

            while (vX < 153 && Errorlevel = 0) {						;atk to right
                gosub, atkright2
                ImageSearch,vX,vY,1,1,1920,1080, *1 me.png	
                Sleep 50
            }

            critical, on
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("t"), 0)
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("r"), 0)
            critical, off
            Sleep 50

            while (92 < vY && Errorlevel = 0) {							;tp up from bottom plat to 3rd platform
                gosub, tpup
                ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
                Sleep 1000
            }

            while (vX > 140 && Errorlevel = 0) { 						; atk to the left until you get to the middle of top right platform
                gosub, atkleft2
                ImageSearch,vX,vY,1,1,1920,1080, *1 me.png	
                Sleep 50
            }

            critical, on
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("t"), 0)
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("r"), 0)
            critical, off

            while (75 < vY && Errorlevel = 0) {							;tp up to loot top right platform
                gosub, tpup
                Sleep, 50
                ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
            }
            Sleep 400													
            while (vX > 30){
                AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 1)
                Sleep 50
                ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
            }
            critical, on
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
            critical, off
            Sleep 50

            while (75 > vY && Errorlevel = 0) {							;tp down to 3rd lvl platform
                gosub, tpdown
                Sleep 800
                ImageSearch,vX,vY,1,1,1920,1080, *1 me.png		
            }
            while (vX > 75 && Errorlevel = 0) { 						;atk to the left until you get to the middle of top left platforms
                gosub, atkleft
                Sleep 50
                ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
            }
            while (75 < vY && Errorlevel = 0) {							;tp up to loot top left platform
                gosub, tpup	
                Sleep 600
                ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
            }
            gosub, tpleft
            Sleep 1200
            while (75 > vY && Errorlevel = 0) {							;tp down to 3rd lvl platform
                gosub, tpdown	
                Sleep 600
                ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
            }
            while (vX > 40 && Errorlevel = 0) { 						;atk to the left until left boundary					
                gosub, atkleft
                ImageSearch,vX,vY,1,1,1920,1080, *1 me.png	
                Sleep 50
            }
            while (vX > 30){
                AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 1)
                Sleep 50
                ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
            }
            critical, on
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
            critical, off
            while (88 > vY && Errorlevel = 0) {							;tp down to 2nd lvl platform and original starting spot
                gosub, tpdown
                ImageSearch,vX,vY,1,1,1920,1080, *1 me.png		
                Sleep 600
            }
            Sleep 200
            loot := false
            SetTimer, loot, -80000 ; loot timer
        }
    }
loot:
    loot := true
return

tpup:	
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 1)			
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("t"), 1)
    Sleep 50
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("t"), 0)	
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 0)		
    Sleep 100
return

tpdown:	
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 1)			
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("t"), 1)
    Sleep 50
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("t"), 0)	
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 0)		
    Sleep 100
return

tpright:	
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 1)			
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("t"), 1)
    Sleep 50
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("t"), 0)	
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)		
    Sleep 100
return

tpleft:	
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 1)			
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("t"), 1)
    Sleep 50
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("t"), 0)	
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)		
    Sleep 100
return

atkleft:
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 1)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("t"), 1)
    Sleep 100
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("r"), 1)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("r"), 0)
    Sleep 500
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)	
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("t"), 0)		
    Sleep 50
return

atkright:
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 1)			
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("t"), 1)
    Sleep 100
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("r"), 1)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("r"), 0)
    Sleep 500
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 0)	
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("t"), 0)	
return

atkleft2:
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 1)
    Sleep 50
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("r"), 1)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("t"), 1)
return

atkright2:
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 1)
    Sleep 50
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("r"), 1)
    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("t"), 1)
return