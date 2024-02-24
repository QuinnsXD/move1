; Illuim
; Map Name here
#Persistent 
#NoEnv
SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Window
SendMode Input
#SingleInstance Force
SetTitleMatchMode 2
#WinActivateForce
SetControlDelay 1
SetWinDelay 0
SetKeyDelay -1
SetMouseDelay -1
SetBatchLines -1
#include Lib\AutoHotInterception.ahk

global AHI := new AutoHotInterception()
global keyboardId := AHI.GetKeyboardId(0x2516, 0x008F)

; Define the key settings
Teleport := "SPACE"
Buffs_180s_cd := [""]
Buffs_120s_cd := [""]
Edra_shower := "C"
Deploy_Crystal := "DELETE"
Origin := "R"
Radiant_Orb := "A"
Ropelift_key := "L"
Attack_key := "D"

F1::


SetTimer, Buffs, 90000  ; Set a timer to trigger every 90 seconds (90000 milliseconds)

return  ; End of auto-execute section

Buffs:
{
    ; Iterate over each key in Buffs_180s_cd
    Loop, % Buffs_180s_cd.MaxIndex()
    {
        Sleep, 500  ; Wait for 500 milliseconds
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC(Buffs_180s_cd[A_Index]), 1)  ; Simulate pressing the key down
        Sleep, 500  ; Wait for 500 milliseconds
        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC(Buffs_180s_cd[A_Index]), 0) ; Simulate releasing the key
    }

    return  ; End of timer function
}




; Define the move function to set a boundary for player movement
move(target_x, target_y, delay:=0.8, delay2:=0.5, ropelift:=true, ropelift_key:="ropelift_key") {
    goto_count := 0
    while true {
        goto_count++
        
        if (goto_count == 100 || goto_count > 200) {
            MsgBox, % ((goto_count == 100) ? "Reached maximum attempts." : "Encountered an undefined error while moving to the location.")
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 1)
            Sleep, 100
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 1)
            Sleep, 20
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 1)
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
            Sleep, 1500
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 1)
            Sleep, 20
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 1)
            Sleep, 100
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 0)
            
            if (goto_count > 200)
                goto_count := 0
            
            continue
        }
        
        ; Perform an image search to find the player's location on the screen
        ; Replace "image_path.png" with the path to your player's image file
        ImageSearch,vX,vY,1,1,1920,1080, *1 me.png
        ; Check if the player's location was found
        if (ErrorLevel = 0) {
            ; Player's location found, assign coordinates to player_location
            player_location := {x: player_x, y: player_y}
        } else {
            ; Player's location not found
            player_location := ""  ; Set player_location to indicate that it is not found
        }
        
        if (player_location = "")
            continue
        
        ; StringSplit, player_location, player_location, `,
        x1 := player_location.x
        y1 := player_location.y
        x2 := target_x
        y2 := target_y
        
        if (abs(x1 - x2) < 3) {
            ; Player has reached target x-destination, release all held keys.
            AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 0)
            
            if (abs(y2 - y1) < 7) {
                ; Player has reached target y-destination, release all held keys.
                AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 0)
                break
            } else if (y1 < y2) {
                if (abs(y2 - y1) > 3) {
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 1)
                    Sleep, 20
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 1)
                    Sleep, 200
                    AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Down"), 0)
                }
                ; Delay for player falling down
                Sleep, delay2
            } else {
                if (y1 - y2 > 40) {
                    if (ropelift) {
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 0)
                        Sleep, 20
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 1)
                        Sleep, 500
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC(ropelift_key), 1)
                    } else {
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 0)
                        Sleep, 20
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 1)
                        Sleep, 200
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 1)
                        Sleep, 100
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 1)
                        Sleep, 20
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 1)
                    }
                } else if (y1 - y2 > 18) {
                    if (ropelift) {
                        Sleep, 20
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC(ropelift_key), 1)
                        Sleep, 200
                    } else {
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 0)
                        Sleep, 20
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 1)
                        Sleep, 80
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 1)
                        Sleep, 20
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 1)
                    }
                } else {
                    if (ropelift) {
                        Sleep, 20
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC(ropelift_key), 1)
                        Sleep, 200
                    } else {
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 0)
                        Sleep, 20
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Up"), 1)
                        Sleep, 100
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 1)
                        Sleep, 20
                        AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 1)
                    }
                }
                ; Delay for player  jumping up.
                Sleep, delay
            }
        } else {
            ; Player is to the left of target x-position.
            if (x1 < x2) {
                Sleep, 20
                AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Right"), 1)
            ; Player is to the right of target x-position.
            } else {
                Sleep, 20
                AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Left"), 1)
            }
            
            if (abs(x2 - x1) > 25) {
                Sleep, 20
                AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 1)
                Sleep, 60
                AHI.Instance.SendKeyEvent(keyboardId, GetKeySC("Space"), 1)
                Sleep, 20
                AHI.Instance.SendKeyEvent(keyboardId, GetKeySC(attack_key), 1)
                Sleep, 530
            }
        }
    }
}

