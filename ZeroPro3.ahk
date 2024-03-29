#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
; <COMPILER: v1.1.33.10>
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%\Assets
FileCreateDir,%A_ScriptDir%\Assets
CLR_LoadLibrary(AssemblyName, AppDomain=0) {
    if !AppDomain
        AppDomain := CLR_GetDefaultDomain()
    e := ComObjError(0)
    Loop 1 {
        if assembly := AppDomain.Load_2(AssemblyName)
            break
        static _null := ComObject(13,0)
        args := ComObjArray(0xC, 1), args[0] := AssemblyName
        typeofAssembly := AppDomain.GetType().Assembly.GetType()
        if assembly := typeofAssembly.InvokeMember_3("LoadWithPartialName", 0x158, _null, _null, args)
            break
        if assembly := typeofAssembly.InvokeMember_3("LoadFrom", 0x158, _null, _null, args)
            break
    }
    ComObjError(e)
    return assembly
}
CLR_CreateObject(Assembly, TypeName, Args*) {
    if !(argCount := Args.MaxIndex())
        return Assembly.CreateInstance_2(TypeName, true)
    vargs := ComObjArray(0xC, argCount)
    Loop % argCount
        vargs[A_Index-1] := Args[A_Index]
    static Array_Empty := ComObjArray(0xC,0), _null := ComObject(13,0)
    return Assembly.CreateInstance_3(TypeName, true, 0, _null, vargs, _null, Array_Empty)
}
CLR_CompileC#(Code, References="", AppDomain=0, FileName="", CompilerOptions="") {
    return CLR_CompileAssembly(Code, References, "System", "Microsoft.CSharp.CSharpCodeProvider", AppDomain, FileName, CompilerOptions)
}
CLR_CompileVB(Code, References="", AppDomain=0, FileName="", CompilerOptions="") {
    return CLR_CompileAssembly(Code, References, "System", "Microsoft.VisualBasic.VBCodeProvider", AppDomain, FileName, CompilerOptions)
}
CLR_StartDomain(ByRef AppDomain, BaseDirectory="") {
    static _null := ComObject(13,0)
    args := ComObjArray(0xC, 5), args[0] := "", args[2] := BaseDirectory, args[4] := ComObject(0xB,false)
    AppDomain := CLR_GetDefaultDomain().GetType().InvokeMember_3("CreateDomain", 0x158, _null, _null, args)
    return A_LastError >= 0
}
CLR_StopDomain(ByRef AppDomain) {
    DllCall("SetLastError", "uint", hr := DllCall(NumGet(NumGet(0+RtHst:=CLR_Start())+20*A_PtrSize), "ptr", RtHst, "ptr", ComObjValue(AppDomain))), AppDomain := ""
    return hr >= 0
}
CLR_Start(Version="") {
    static RtHst := 0
    if RtHst
        return RtHst
    EnvGet SystemRoot, SystemRoot
    if Version =
        Loop % SystemRoot "\Microsoft.NET\Framework" (A_PtrSize=8?"64":"") "\*", 2
        if (FileExist(A_LoopFileFullPath "\mscorlib.dll") && A_LoopFileName > Version)
        Version := A_LoopFileName
    if DllCall("mscoree\CorBindToRuntimeEx", "wstr", Version, "ptr", 0, "uint", 0
        , "ptr", CLR_GUID(CLSID_CorRuntimeHost, "{CB2F6723-AB3A-11D2-9C40-00C04FA30A3E}")
    , "ptr", CLR_GUID(IID_ICorRuntimeHost, "{CB2F6722-AB3A-11D2-9C40-00C04FA30A3E}")
    , "ptr*", RtHst) >= 0
    DllCall(NumGet(NumGet(RtHst+0)+10*A_PtrSize), "ptr", RtHst)
    return RtHst
}
CLR_GetDefaultDomain() {
    static defaultDomain := 0
    if !defaultDomain {
        if DllCall(NumGet(NumGet(0+RtHst:=CLR_Start())+13*A_PtrSize), "ptr", RtHst, "ptr*", p:=0) >= 0
            defaultDomain := ComObject(p), ObjRelease(p)
    }
    return defaultDomain
}
CLR_CompileAssembly(Code, References, ProviderAssembly, ProviderType, AppDomain=0, FileName="", CompilerOptions="") {
    if !AppDomain
        AppDomain := CLR_GetDefaultDomain()
    if !(asmProvider := CLR_LoadLibrary(ProviderAssembly, AppDomain))
        || !(codeProvider := asmProvider.CreateInstance(ProviderType))
    || !(codeCompiler := codeProvider.CreateCompiler())
    return 0
    if !(asmSystem := (ProviderAssembly="System") ? asmProvider : CLR_LoadLibrary("System", AppDomain))
        return 0
    StringSplit, Refs, References, |, %A_Space%%A_Tab%
    aRefs := ComObjArray(8, Refs0)
    Loop % Refs0
        aRefs[A_Index-1] := Refs%A_Index%
    prms := CLR_CreateObject(asmSystem, "System.CodeDom.Compiler.CompilerParameters", aRefs)
    , prms.OutputAssembly := FileName
    , prms.GenerateInMemory := FileName=""
    , prms.GenerateExecutable := SubStr(FileName,-3)=".exe"
    , prms.CompilerOptions := CompilerOptions
    , prms.IncludeDebugInformation := true
    compilerRes := codeCompiler.CompileAssemblyFromSource(prms, Code)
    if error_count := (errors := compilerRes.Errors).Count {
        error_text := ""
        Loop % error_count
            error_text .= ((e := errors.Item[A_Index-1]).IsWarning ? "Warning " : "Error ") . e.ErrorNumber " on line " e.Line ": " e.ErrorText "`n`n"
        MsgBox, 16, Compilation Failed, %error_text%
        return 0
    }
    return compilerRes[FileName="" ? "CompiledAssembly" : "PathToAssembly"]
}
CLR_GUID(ByRef GUID, sGUID) {
    VarSetCapacity(GUID, 16, 0)
    return DllCall("ole32\CLSIDFromString", "wstr", sGUID, "ptr", &GUID) >= 0 ? &GUID : ""
    }
    class AutoHotInterception {
        _contextManagers := {}
        __New() {
            bitness := A_PtrSize == 8 ? "x64" : "x86"
                dllName := "interception.dll"
                if (A_IsCompiled){
                    dllFile := A_LineFile "\..\Assets\Lib\" bitness "\" dllName
                    FileCreateDir, \Assets\Lib
                    FileInstall, Lib\AutoHotInterception.dll, \Assets\Lib\AutoHotInterception.dll
                    if (bitness == "x86"){
                        FileCreateDir, \Assets\Lib\x86
                        FileInstall, Lib\x86\interception.dll, \Assets\Lib\x86\interception.dll
                    } else {
                        FileCreateDir, \Assets\Lib\x64
                        FileInstall, Lib\x64\interception.dll, \Assets\Lib\x64\interception.dll
                    }
                } else {
                    dllFile := A_LineFile "\..\" bitness "\" dllName
                }
                if (!FileExist(dllFile)) {
                    MsgBox % "Unable to find " dllFile ", exiting...`nYou should extract both x86 and x64 folders from the library folder in interception.zip into AHI's lib folder."
                    ExitApp
                }
                hModule := DllCall("LoadLibrary", "Str", dllFile, "Ptr")
                if (hModule == 0) {
                    this_bitness := A_PtrSize == 8 ? "64-bit" : "32-bit"
                    other_bitness := A_PtrSize == 4 ? "64-bit" : "32-bit"
                        MsgBox % "Bitness of " dllName " does not match bitness of AHK.`nAHK is " this_bitness ", but " dllName " is " other_bitness "."
                    ExitApp
                }
                DllCall("FreeLibrary", "Ptr", hModule)
                dllName := "AutoHotInterception.dll"
                if (A_IsCompiled){
                    dllFile := A_LineFile "\..\Assets\Lib\" dllName
                } else {
                    dllFile := A_LineFile "\..\Assets\" dllName
                }
                hintMessage := "Try right-clicking " dllFile ", select Properties, and if there is an 'Unblock' checkbox, tick it`nSpaceernatively, running Unblocker.ps1 in the lib folder (ideally as admin) can do this for you."
                if (!FileExist(dllFile)) {
                    MsgBox % "Unable to find " dllFile ", exiting..."
                    ExitApp
                }
                asm := CLR_LoadLibrary(dllFile)
                try {
                    this.Instance := asm.CreateInstance("AutoHotInterception.Manager")
                }
                catch {
                    MsgBox % dllName " failed to load`n`n" hintMessage
                    ExitApp
                }
                if (this.Instance.OkCheck() != "OK") {
                    MsgBox % dllName " loaded but check failed!`n`n" hintMessage
                    ExitApp
                }
            }
            GetInstance() {
                return this.Instance
            }
            SendKeyEvent(id, code, state) {
                this.Instance.SendKeyEvent(id, code, state)
            }
            SendMouseButtonEvent(id, btn, state) {
                this.Instance.SendMouseButtonEvent(id, btn, state)
            }
            SendMouseButtonEventAbsolute(id, btn, state, x, y) {
                this.Instance.SendMouseButtonEventAbsolute(id, btn, state, x, y)
            }
            SendMouseMove(id, x, y) {
                this.Instance.SendMouseMove(id, x, y)
            }
            SendMouseMoveRelative(id, x, y) {
                this.Instance.SendMouseMoveRelative(id, x, y)
            }
            SendMouseMoveAbsolute(id, x, y) {
                this.Instance.SendMouseMoveAbsolute(id, x, y)
            }
            SetState(state){
                this.Instance.SetState(state)
            }
            MoveCursor(x, y, cm := "Screen", mouseId := -1){
                if (mouseId == -1)
                    mouseId := 11
                oldMode := A_CoordModeMouse
                CoordMode, Mouse, % cm
                Loop {
                    MouseGetPos, cx, cy
                    dx := this.GetDirection(cx, x)
                    dy := this.GetDirection(cy, y)
                    if (dx == 0 && dy == 0)
                        break
                    this.SendMouseMove(mouseId, dx, dy)
                }
                CoordMode, Mouse, % oldMode
            }
            GetDirection(cp, dp){
                d := dp - cp
                if (d > 0)
                    return 1
                if (d < 0)
                    return -1
                return 0
            }
            GetDeviceId(IsMouse, VID, PID, instance := 1) {
                static devType := {0: "Keyboard", 1: "Mouse"}
                dev := this.Instance.GetDeviceId(IsMouse, VID, PID, instance)
                if (dev == 0) {
                    MsgBox % "Could not get " devType[isMouse] " with VID " VID ", PID " PID ", Instance " instance
                    ExitApp
                }
                return dev
            }
            GetDeviceIdFromHandle(isMouse, handle, instance := 1) {
                static devType := {0: "Keyboard", 1: "Mouse"}
                dev := this.Instance.GetDeviceIdFromHandle(IsMouse, handle, instance)
                if (dev == 0) {
                    MsgBox % "Could not get " devType[isMouse] " with Handle " handle ", Instance " instance
                    ExitApp
                }
                return dev
            }
            GetKeyboardId(VID, PID, instance := 1) {
                return this.GetDeviceId(false, VID, PID, instance)
            }
            GetMouseId(VID, PID, instance := 1) {
                return this.GetDeviceId(true, VID, PID, instance)
            }
            GetKeyboardIdFromHandle(handle, instance := 1) {
                return this.GetDeviceIdFromHandle(false, handle, instance)
            }
            GetMouseIdFromHandle(handle, instance := 1) {
                return this.GetDeviceIdFromHandle(true, handle, instance)
            }
            GetDeviceList() {
                DeviceList := {}
                arr := this.Instance.GetDeviceList()
                for v in arr {
                    DeviceList[v.id] := { ID: v.id, VID: v.vid, PID: v.pid, IsMouse: v.IsMouse, Handle: v.Handle }
                }
                return DeviceList
            }
            SubscribeKey(id, code, block, callback, concurrent := false) {
                this.Instance.SubscribeKey(id, code, block, callback, concurrent)
            }
            UnsubscribeKey(id, code){
                this.Instance.UnsubscribeKey(id, code)
            }
            SubscribeKeyboard(id, block, callback, concurrent := false) {
                this.Instance.SubscribeKeyboard(id, block, callback, concurrent)
            }
            UnsubscribeKeyboard(id){
                this.Instance.UnsubscribeKeyboard(id)
            }
            SubscribeMouseButton(id, btn, block, callback, concurrent := false) {
                this.Instance.SubscribeMouseButton(id, btn, block, callback, concurrent)
            }
            UnsubscribeMouseButton(id, btn){
                this.Instance.UnsubscribeMouseButton(id, btn)
            }
            SubscribeMouseButtons(id, block, callback, concurrent := false) {
                this.Instance.SubscribeMouseButtons(id, block, callback, concurrent)
            }
            UnsubscribeMouseButtons(id){
                this.Instance.UnsubscribeMouseButtons(id)
            }
            SubscribeMouseMove(id, block, callback, concurrent := false) {
                this.Instance.SubscribeMouseMove(id, block, callback, concurrent)
            }
            UnsubscribeMouseMove(id){
                this.Instance.UnsubscribeMouseMove(id)
            }
            SubscribeMouseMoveRelative(id, block, callback, concurrent := false) {
                this.Instance.SubscribeMouseMoveRelative(id, block, callback, concurrent)
            }
            UnsubscribeMouseMoveRelative(id){
                this.Instance.UnsubscribeMouseMoveRelative(id)
            }
            SubscribeMouseMoveAbsolute(id, block, callback, concurrent := false) {
                this.Instance.SubscribeMouseMoveAbsolute(id, block, callback, concurrent)
            }
            UnsubscribeMouseMoveAbsolute(id){
                this.Instance.UnsubscribeMouseMoveAbsolute(id)
            }
            CreateContextManager(id) {
                if (this._contextManagers.HasKey(id)) {
                    Msgbox % "ID " id " already has a Context Manager"
                    ExitApp
                }
                cm := new this.ContextManager(this, id)
                this._contextManagers[id] := cm
                return cm
            }
            RemoveContextManager(id) {
                if (!this._contextManagers.HasKey(id)) {
                    Msgbox % "ID " id " does not have a Context Manager"
                    ExitApp
                }
                this._contextManagers[id].Remove()
                this._contextManagers.Delete(id)
                return cm
            }
            class ContextManager {
                IsActive := 0
                __New(parent, id) {
                    this.parent := parent
                    this.id := id
                    result := this.parent.Instance.SetContextCallback(id, this.OnContextCallback.Bind(this))
                }
                OnContextCallback(state) {
                    Sleep 0
                    this.IsActive := state
                }
                Remove(){
                    this.parent.Instance.RemoveContextCallback(this.id)
                }
            }
        }
        global AHI := new AutoHotInterception()
        FileInstall,me.png,%A_ScriptDir%\Assets\me.png,1
        FileInstall,rune.png,%A_ScriptDir%\Assets\rune.png,1
        FileInstall,alarm.mp3,%A_ScriptDir%\Assets\alarm.mp3,1
        FileInstall,alarm2.mp3,%A_ScriptDir%\Assets\alarm2.mp3,1
        FileInstall,buddy.png,%A_ScriptDir%\Assets\buddy.png,1
        FileInstall,guild.png,%A_ScriptDir%\Assets\guild.png,1
        FileInstall,people.png,%A_ScriptDir%\Assets\people.png,1
        FileInstall,eb.png,%A_ScriptDir%\Assets\eb.png,1
        FileInstall,Map.png,%A_ScriptDir%\Assets\Map.png,1
        #SingleInstance, force
        #InstallKeybdHook
        #MaxThreadsPerHotkey 1
        gui, +Alwaysontop
        gui, color, D7A1F9
        gui, show, x1 y1 w210 h435 NoActivate,
        gui, font, s8
        gui, add, groupbox, x5 y5 h90 w200, Controls
        gui, add, groupbox, x5 y100 h90 w200, Positions
        gui, add, groupbox, x5 y190 h75 w200, KeyboardID
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
        gui, add, radio, x10 y205 ghid1 vhid1, 1
        gui, add, radio, x49 y205 ghid2 vhid2, 2
        gui, add, radio, x88 y205 ghid3 vhid3 , 3
        gui, add, radio, x127 y205 ghid4 vhid4, 4
        gui, add, radio, x166 y205 ghid5 vhid5, 5
        gui, add, radio, x10 y235 ghid6 vhid6, 6
        gui, add, radio, x49 y235 ghid7 vhid7, 7
        gui, add, radio, x88 y235 ghid8 vhid8 , 8
        gui, add, radio, x127 y235 ghid9 vhid9, 9
        gui, add, radio, x166 y235 ghid10 vhid10, 10
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
        Gui, add, text, x55 y405 c0000A0, GMS
        IniRead, LeftX, Map.ini, MapPos, LeftX
        Iniread, RightX, Map.ini, MapPos, RightX
        Iniread, TopY, Map.ini, MapPos, TopY
        MidX := ((RightX - LeftX) / 2)
        clockwise := false
        vertical := false
        rope := false
        jump1 := 40
        jump2 := 60
        global hid := 1
        exps := false
        weSpacehs := false
        doubleexps := false
        Iniread, hid, Map.ini, KeyboardID, ID
        if(hid = 1) {
            gosub, hid1
        } else if(hid = 2) {
            gosub, hid2
        } else if(hid = 3) {
            gosub, hid3
        } else if(hid = 4) {
            gosub, hid4
        } else if(hid = 5) {
            gosub, hid5
        } else if(hid = 6) {
            gosub, hid6
        } else if(hid = 7) {
            gosub, hid7
        } else if(hid = 8) {
            gosub, hid8
        } else if(hid = 9) {
            gosub, hid9
        } else if(hid = 10) {
            gosub, hid10
        }
        gosub, alarms
        return
        submitla:
            gui, submit, nohide
            iniwrite, %ropedelay%, Map.ini, MapPos, RopeDelay
        return
        hid1:
            hid := 1
            Iniwrite, %hid% , Map.ini, KeyboardID, ID
            guicontrol,,hid1, 1
        return
        hid2:
            hid := 2
            Iniwrite, %hid% , Map.ini, KeyboardID, ID
            guicontrol,,hid2, 1
        return
        hid3:
            hid := 3
            Iniwrite, %hid% , Map.ini, KeyboardID, ID
            guicontrol,,hid3, 1
        return
        hid4:
            hid := 4
            Iniwrite, %hid% , Map.ini, KeyboardID, ID
            guicontrol,,hid4, 1
        return
        hid5:
            hid := 5
            Iniwrite, %hid% , Map.ini, KeyboardID, ID
            guicontrol,,hid5, 1
        return
        hid6:
            hid := 6
            Iniwrite, %hid% , Map.ini, KeyboardID, ID
            guicontrol,,hid6, 1
        return
        hid7:
            hid := 7
            Iniwrite, %hid% , Map.ini, KeyboardID, ID
            guicontrol,,hid7, 1
        return
        hid8:
            hid := 8
            Iniwrite, %hid% , Map.ini, KeyboardID, ID
            guicontrol,,hid8, 1
        return
        hid9:
            hid := 9
            Iniwrite, %hid% , Map.ini, KeyboardID, ID
            guicontrol,,hid9, 1
        return
        hid10:
            hid := 10
            Iniwrite, %hid% , Map.ini, KeyboardID, ID
            guicontrol,,hid10, 1
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
        SCREEN_X1 := 0
        SCREEN_Y1 := 0
        SCREEN_X2 := 1920
        SCREEN_Y2 := 1080
        Return
        Start1:
            atk()
        return
        Pause1:
            Winactivate, ahk_class MapleStoryClass
            AHI.Instance.SendKeyEvent(HID, GetKeySC("Left"), 0)
            AHI.Instance.SendKeyEvent(HID, GetKeySC("Right"), 0)
            AHI.Instance.SendKeyEvent(HID, GetKeySC("Up"), 0)
            AHI.Instance.SendKeyEvent(HID, GetKeySC("Down"), 0)
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
            ImageSearch,leftx,lefty,1,1,400,400, *10 me.png
            if (ErrorLevel=0)
            {
                IniWrite, %leftx%, Map.ini, MapPos, LeftX
                MidX := ((RightX - LeftX) / 2)
                guicontrol,text, LButton, Left(%LeftX%)
            }
            Else
            {
                TrayTip, `t,Minimap not found
            }
        return
        RIGHTPOS:
            Winactivate, ahk_class MapleStoryClass
            ImageSearch,rightx,righty,1,1,400,400, *10 me.png
            if (ErrorLevel=0)
            {
                IniWrite, %rightx%, Map.ini, MapPos, RightX
                MidX := ((RightX - LeftX) / 2)
                guicontrol,text, RButton, Right(%RightX%)
            }
            Else
            {
                TrayTip, `t,Minimap not found
            }
        return
        TOPPOS:
            Winactivate, ahk_class MapleStoryClass
            ImageSearch,topx,topy,1,1,400,400, *10 me.png
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
        F9::
            MouseGetPos, xpos, ypos 
            MsgBox, The cursor is at X%xpos% Y%ypos%.
        Return
        f8::
            Winactivate, ahk_class MapleStoryClass
            ImageSearch,topx,topy,1,1,400,400, *10 me.png
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
            ImageSearch,leftx,lefty,1,1,400,400, *10 me.png
            if (ErrorLevel=0)
            {
                IniWrite, %leftx%, Map.ini, MapPos, LeftX
                MidX := ((RightX - LeftX) / 2)
                guicontrol,text, LButton, Left(%LeftX%)
            }
            Else
            {
                TrayTip, `t,Minimap not found
            }
        return
        f7::
            Winactivate, ahk_class MapleStoryClass
            ImageSearch,rightx,righty,1,1,400,400, *10 me.png
            if (ErrorLevel=0)
            {
                IniWrite, %rightx%, Map.ini, MapPos, RightX
                MidX := ((RightX - LeftX) / 2)
                guicontrol,text, RButton, Right(%RightX%)
            }
            Else
            {
                TrayTip, `t,Minimap not found
            }
        return
        f4::
            Winactivate, ahk_class MapleStoryClass
            AHI.Instance.SendKeyEvent(HID, GetKeySC("Left"), 0)
            AHI.Instance.SendKeyEvent(HID, GetKeySC("Right"), 0)
            AHI.Instance.SendKeyEvent(HID, GetKeySC("Up"), 0)
            AHI.Instance.SendKeyEvent(HID, GetKeySC("Down"), 0)
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
                Winactivate, ahk_class MapleStoryClass
                guicontrol, , Pause1 , Pause
                guicontrol, , Start1 , Started
                pause,Off
                guicontrol,text, TButton, Top(%TopY%)
                guicontrol,text, LButton, Left(%LeftX%)
                guicontrol,text, RButton, Right(%RightX%)
                ArrowRainInhuman()
                Clock()
                Arachnid()
                beta := true
                arrowblast := true
                GrittyGust := true
                penguin := true
                shower := true
                SetTimer, xp, 930000
                SetTimer, Eap, 7500000
                xp()
                Eap()
                loop{

                    if (clockwise) {

                        if(penguin) {
                            loop 2 {
                                random, ran, 88,115
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("5"), 1)
                                sleep %ran%
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("5"), 0)
                                sleep %ran%
                            }
                            sleep 500
                            penguin := false
                            SetTimer, penguin, -180000
                        }
                        ImageSearch,vX,vY,1,1,400,400, *1 me.png
                        while(vX > MidX && Errorlevel = 0) {
                            AHI.Instance.SendKeyEvent(HID, GetKeySC("Left"), 1)
                            sleep 100
                            loop 3 {
                                random, jump, %jump1%, %jump2%
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("Space"), 1)
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("Space"), 0)
                                sleep %jump%
                            }
                            if(GrittyGust) {
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("Ins"), 1)
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("Ins"), 0)
                                GrittyGust := false
                                SetTimer, GrittyGust, -15000
                            } 
                            AHI.Instance.SendKeyEvent(HID, GetKeySC("f"), 1)
                            AHI.Instance.SendKeyEvent(HID, GetKeySC("f"), 0)
                            sleep 550

                            if (shower) {
                                sleep 300
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("Down"), 1)
                                sleep 50
                                loop 2 {
                                    random, ran, 88,115
                                    AHI.Instance.SendKeyEvent(HID, GetKeySC("c"), 1)
                                    sleep %ran%
                                    random, ran, 88,115
                                    AHI.Instance.SendKeyEvent(HID, GetKeySC("c"), 0)
                                    sleep %ran%
                                }
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("Down"), 0)
                                sleep 455
                                shower := false
                                SetTimer, shower, -60000
                            }
                            ImageSearch,vX,vY,1,1,400,400, *1 me.png
                        }
                        if(arrowblast) {
                            AHI.Instance.SendKeyEvent(HID, GetKeySC("Left"), 0)
                            sleep 200
                            loop 2 {
                                random, ran, 88,115
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("PgUp"), 1)
                                sleep %ran%
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("y"), 1)
                                sleep %ran%
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("y"), 0)
                                sleep %ran%
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("PgUp"), 0)
                                sleep %ran%
                            }
                            sleep 500
                            arrowblast := false
                            SetTimer, arrowblast, -70000
                        }
                        ImageSearch,vX,vY,1,1,400,400, *1 me.png
                        while(vX > LeftX && Errorlevel = 0) {
                            AHI.Instance.SendKeyEvent(HID, GetKeySC("Left"), 1)
                            sleep 100
                            loop 3 {
                                random, jump, %jump1%, %jump2%
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("Space"), 1)
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("Space"), 0)
                                sleep %jump%
                            }
                            if(GrittyGust) {
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("Ins"), 1)
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("Ins"), 0)
                                GrittyGust := false
                                SetTimer, GrittyGust, -15000
                            } 

                            AHI.Instance.SendKeyEvent(HID, GetKeySC("f"), 1)
                            AHI.Instance.SendKeyEvent(HID, GetKeySC("f"), 0)
                            sleep 550
                            ImageSearch,vX,vY,1,1,400,400, *1 me.png
                        }
                        AHI.Instance.SendKeyEvent(HID, GetKeySC("Left"), 0)
                        sleep 200
                        ImageSearch,vX,vY,1,1,400,400, *1 me.png
                        if(Errorlevel = 1) { ; if imagesearch above is unsuccessful
                            critical, on
                            AHI.Instance.SendKeyEvent(HID, GetKeySC("Right"), 1)
                            sleep 300
                            AHI.Instance.SendKeyEvent(HID, GetKeySC("Right"), 0)
                            critical, off
                        }
                        if(vertical) { ; check if character is below top boundary, if so, it goes right, then rope lifts
                            if(vY > TopY && Errorlevel = 0) {
                                ImageSearch,vX,vY,1,1,400,400, *1 me.png
                                vX2 := vX + 1
                                while(vX < vX2 && Errorlevel = 0) {
                                    AHI.Instance.SendKeyEvent(HID, GetKeySC("Right"), 1)
                                    sleep 25
                                    ImageSearch,vX,vY,1,1,400,400, *1 me.png
                                }
                                if(rope) {
                                    AHI.Instance.SendKeyEvent(HID, GetKeySC("j"), 1)
                                    AHI.Instance.SendKeyEvent(HID, GetKeySC("j"), 0)
                                    sleep %ropedelay%
                                    loop 2 {
                                        AHI.Instance.SendKeyEvent(HID, GetKeySC("j"), 1)
                                        AHI.Instance.SendKeyEvent(HID, GetKeySC("j"), 0)
                                        sleep 50
                                    }
                                    sleep 300
                                } 
                                ImageSearch,vX,vY,1,1,400,400, *1 me.png
                            }
                            sleep 100
                        }
                        ImageSearch,vX,vY,1,1,400,400, *1 me.png
                        while(vX < RightX && Errorlevel = 0) {
                            AHI.Instance.SendKeyEvent(HID, GetKeySC("Right"), 1)
                            sleep 100
                            loop 3 {
                                random, jump, %jump1%, %jump2%
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("Space"), 1)
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("Space"), 0)
                                sleep %jump%
                            }
                            if(GrittyGust) {
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("Ins"), 1)
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("Ins"), 0)
                                GrittyGust := false
                                SetTimer, GrittyGust, -15000
                            } 
                            AHI.Instance.SendKeyEvent(HID, GetKeySC("f"), 1)
                            AHI.Instance.SendKeyEvent(HID, GetKeySC("f"), 0)
                            sleep 550
                            ImageSearch,vX,vY,1,1,400,400, *1 me.png
                        }
                        AHI.Instance.SendKeyEvent(HID, GetKeySC("Right"), 0)
                        sleep 200
                        ImageSearch,vX,vY,1,1,400,400, *1 me.png
                        if(Errorlevel = 1) { ; if imagesearch above is unsuccessful
                            critical, on
                            AHI.Instance.SendKeyEvent(HID, GetKeySC("Left"), 1)
                            sleep 300
                            AHI.Instance.SendKeyEvent(HID, GetKeySC("Left"), 0)
                            critical, off
                        }
                        if(vertical) {
                            while(vY < TopY && Errorlevel = 0) {
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("Down"), 1)
                                sleep 50
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("Space"), 1)
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("Space"), 0)
                                sleep 100
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("f"), 1)
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("f"), 0)
                                sleep 700
                                ImageSearch,vX,vY,1,1,400,400, *1 me.png
                            }
                            AHI.Instance.SendKeyEvent(HID, GetKeySC("Down"), 0)
                            sleep 600
                        }
                    } else {
                        if (shower) {
                            sleep 300
                            AHI.Instance.SendKeyEvent(HID, GetKeySC("Down"), 1)
                            sleep 50
                            loop 2 {
                                random, ran, 88,115
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("c"), 1)
                                sleep %ran%
                                random, ran, 88,115
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("c"), 0)
                                sleep %ran%
                            }
                            AHI.Instance.SendKeyEvent(HID, GetKeySC("Down"), 0)
                            sleep 455
                            shower := false
                            SetTimer, shower, -60000
                        }
                        if(penguin) {
                            loop 2 {
                                random, ran, 88,115
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("5"), 1)
                                sleep %ran%
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("5"), 0)
                                sleep %ran%
                            }
                            sleep 500
                            penguin := false
                            SetTimer, penguin, -190000
                        }
                            ImageSearch,vX,vY,1,1,400,400, *1 me.png

                            while(vX < MidX && Errorlevel = 0) {
                            AHI.Instance.SendKeyEvent(HID, GetKeySC("Right"), 1)
                            sleep 50
                            ImageSearch,vX,vY,1,1,400,400, *1 me.png
                            loop 1 {
                                random, jump, %jump1%, %jump2%
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("Space"), 0)
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("Space"), 0)
                                sleep %jump%
                            }
                            if(GrittyGust) {
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("3"), 1)
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("3"), 0)
                                GrittyGust := false
                                SetTimer, GrittyGust, -15000
                            } 
                            
                                loop 3 {
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("q"), 1)
                                sleep 300
                                }
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("q"), 0)
                            
                            ImageSearch,vX,vY,1,1,400,400, *1 me.png
                            sleep 50
                            
                        }
                        if(arrowblast) {
                            AHI.Instance.SendKeyEvent(HID, GetKeySC("Right"), 0)
                            sleep 200
                            loop 3 {
                                random, ran, 200,300
                                
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("3"), 1)
                                sleep %ran%
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("3"), 0)
                                sleep %ran%
                               
                            }
                            sleep 500
                            arrowblast := false
                            SetTimer, arrowblast, -40000
                        }
                        
                            while(vX < RightX && Errorlevel = 0) {
                            AHI.Instance.SendKeyEvent(HID, GetKeySC("Right"), 1)
                            AHI.Instance.SendKeyEvent(HID, GetKeySC("space"), 1)
                            sleep 50
                            ImageSearch,vX,vY,1,1,400,400, *1 me.png
                            
                            if(GrittyGust) {
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("3"), 1)
                                sleep 400
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("3"), 0)
                                GrittyGust := false
                                SetTimer, GrittyGust, -40000
                            } 
                              loop 2 {
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("q"), 1)
                                sleep 300
                                }
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("q"), 0)
                            loop 3 {
                                random, jump, %jump1%, %jump2%
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("v"), 1)
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("v"), 0)
                                sleep %jump%
                            } 
                            ImageSearch,vX,vY,1,1,400,400, *1 me.png
                            sleep 50
                        }
                        AHI.Instance.SendKeyEvent(HID, GetKeySC("space"), 0)
                        AHI.Instance.SendKeyEvent(HID, GetKeySC("Right"), 0)
                        sleep 50
                        ImageSearch,vX,vY,1,1,400,400, *1 me.png
                        if(Errorlevel = 1) { ; if imagesearch above is unsuccessful
                            critical, on
                            AHI.Instance.SendKeyEvent(HID, GetKeySC("Left"), 0)
                            sleep 50
                            AHI.Instance.SendKeyEvent(HID, GetKeySC("Left"), 0)
                            critical, off
                        }
                        if(vertical) {
                            if(vY > TopY && Errorlevel = 0) {
                                ImageSearch,vX,vY,1,1,400,400, *1 me.png
                                vX2 := vX - 1
                                while(vX > vX2 && Errorlevel = 0) {
                                    AHI.Instance.SendKeyEvent(HID, GetKeySC("Left"), 1)
                                    sleep 500
                                    AHI.Instance.SendKeyEvent(HID, GetKeySC("Left"), 0)
                                    ImageSearch,vX,vY,1,1,400,400, *1 me.png
                                }
                                if(rope) {
                                    AHI.Instance.SendKeyEvent(HID, GetKeySC("j"), 1)
                                    AHI.Instance.SendKeyEvent(HID, GetKeySC("j"), 0)
                                    sleep %ropedelay%
                                    loop 2 {
                                        AHI.Instance.SendKeyEvent(HID, GetKeySC("j"), 1)
                                        AHI.Instance.SendKeyEvent(HID, GetKeySC("j"), 0)
                                        sleep 50
                                    }
                                    sleep 300
                                }else{
                                    AHI.Instance.SendKeyEvent(HID, GetKeySC("Up"), 1)
                                    AHI.Instance.SendKeyEvent(HID, GetKeySC("Space"), 1)
                                    sleep 50
                                    AHI.Instance.SendKeyEvent(HID, GetKeySC("Up"), 0)
                                    AHI.Instance.SendKeyEvent(HID, GetKeySC("Space"), 0)
                                }
                                ImageSearch,vX,vY,1,1,400,400, *1 me.png
                                GoSub ZeroAlphaAir
                            }
                            sleep 100
                        }
                                ImageSearch,vX,vY,1,1,400,400, *1 me.png
                                while(vX > LeftX && Errorlevel = 0) {
                                Gosub, ZeroBetaLeft
                                ImageSearch,vX,vY,1,1,400,400, *1 me.png
                                sleep 50
                                if(beta) {
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("Left"), 0)
                                ImageSearch,vX,vY,1,1,400,400, *1 me.png
                                sleep 200
                                loop 4 {
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("3"), 1)
                                sleep 400
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("3"), 0)
                                beta := false
                                SetTimer, beta, -40000
                                }
                                    }
                                ImageSearch,vX,vY,1,1,400,400, *1 me.png    
                                if (vX <= 160 && Errorlevel = 0){
                                loop 3 {
                                random, ran, 303,359
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("a"), 1)
                                sleep %ran%
                                }
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("a"), 0)
                                sleep 50
                                } 
                                ImageSearch,vX,vY,1,1,400,400, *1 me.png 

                             }
                        AHI.Instance.SendKeyEvent(HID, GetKeySC("Left"), 0)
                        AHI.Instance.SendKeyEvent(HID, GetKeySC("space"), 0)
                        AHI.Instance.SendKeyEvent(HID, GetKeySC("right"), 1)
                        sleep 50
                        ImageSearch,vX,vY,1,1,400,400, *1 me.png
                        if(Errorlevel = 1) { ; if imagesearch above is unsuccessful
                            critical, on
                            AHI.Instance.SendKeyEvent(HID, GetKeySC("Right"), 0)
                            sleep 30
                            AHI.Instance.SendKeyEvent(HID, GetKeySC("Right"), 0)
                            critical, off
                        }
                        if(vertical) {
                            while(vY < TopY && Errorlevel = 0) {
                                critical, on
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("Down"), 1)
                                sleep 50
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("right"), 1)
                                sleep 50
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("right"), 0)
                                sleep 100
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("space"), 1)
                                sleep 50
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("space"), 0)
                                sleep 100
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("v"), 1)
                                sleep 50
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("v"), 0)
                                sleep 100
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("q"), 1)
                                sleep 400
                                AHI.Instance.SendKeyEvent(HID, GetKeySC("q"), 0)
                                critical, off
                                ImageSearch,vX,vY,1,1,400,400, *1 me.png
                            }
                            AHI.Instance.SendKeyEvent(HID, GetKeySC("Down"), 0)
                            sleep 300
                        }
                    }
                }
                return
            }
            beta:
            beta := true
        return
        arrowblast:
            arrowblast := true
        return
        shower:
            shower := true
        return
        GrittyGust:
            GrittyGust := true
        return
        Clock:
            Clock()
        return
        Clock() {
            AHI.Instance.SendKeyEvent(HID, GetKeySC("Left"), 0)
            AHI.Instance.SendKeyEvent(HID, GetKeySC("Right"), 0)
            AHI.Instance.SendKeyEvent(HID, GetKeySC("Up"), 0)
            AHI.Instance.SendKeyEvent(HID, GetKeySC("Down"), 0)
            sleep 200
            loop 3 {
                random, ran, 88,115
                AHI.Instance.SendKeyEvent(HID, GetKeySC("1"), 1)
                sleep %ran%
                AHI.Instance.SendKeyEvent(HID, GetKeySC("1"), 0)
                sleep %ran%
            }
            sleep 500
            SetTimer, Clock, -130000
        }

        ArrowRainInhuman:
            ArrowRainInhuman()
        return
        ArrowRainInhuman() { ; ArrowRain, inhuman speed combo
            AHI.Instance.SendKeyEvent(HID, GetKeySC("Left"), 0)
            AHI.Instance.SendKeyEvent(HID, GetKeySC("Right"), 0)
            AHI.Instance.SendKeyEvent(HID, GetKeySC("Up"), 0)
            AHI.Instance.SendKeyEvent(HID, GetKeySC("Down"), 0)
            sleep 200
            loop 3 {
                random, ran, 88,115
                AHI.Instance.SendKeyEvent(HID, GetKeySC("2"), 1)
                sleep %ran%
                AHI.Instance.SendKeyEvent(HID, GetKeySC("2"), 0)
                sleep %ran%
            }
            sleep 50
            loop 3 {
                random, ran, 88,115
                AHI.Instance.SendKeyEvent(HID, GetKeySC("x"), 1)
                sleep %ran%
                AHI.Instance.SendKeyEvent(HID, GetKeySC("x"), 0)
                sleep %ran%
            }
            sleep 50
            SetTimer, ArrowRainInhuman, -125000
        }
        xp()
        {
            Sleep 500
            AHI.Instance.SendKeyEvent(HID, GetKeySC("7"), 1)
            Sleep 300
            AHI.Instance.SendKeyEvent(HID, GetKeySC("7"), 0)
            Sleep 200
            }
        Eap()
        {
            Sleep 500
            AHI.Instance.SendKeyEvent(HID, GetKeySC("8"), 1)
            Sleep 300
            AHI.Instance.SendKeyEvent(HID, GetKeySC("8"), 0)
            Sleep 200
            }
        Arachnid:
            Arachnid()
        return
        Arachnid() {
            AHI.Instance.SendKeyEvent(HID, GetKeySC("Left"), 0)
            AHI.Instance.SendKeyEvent(HID, GetKeySC("Right"), 0)
            AHI.Instance.SendKeyEvent(HID, GetKeySC("Up"), 0)
            AHI.Instance.SendKeyEvent(HID, GetKeySC("Down"), 0)
            sleep 50
            loop 3 {
                random, ran, 88,115
                AHI.Instance.SendKeyEvent(HID, GetKeySC("Home"), 1)
                sleep %ran%
                AHI.Instance.SendKeyEvent(HID, GetKeySC("Home"), 0)
                sleep %ran%
            }
            sleep 50
            SetTimer, Arachnid, -250000
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

            ImageSearch,mapX,mapY,1,1,400,400, *1 map.png
            if(Errorlevel = 1) {
                SoundPlay, snake.mp3
            }
            ImageSearch,RuneX,RuneY,1,1,400,400, *1 guild.png
            if(Errorlevel = 0) {
                
                SoundPlay, alarm2.mp3
            }
            ImageSearch,RuneX,RuneY,1,1,400,400, *1 people.png
            if(Errorlevel = 0) {
                
                SoundPlay, alarm2.mp3
            }
            ImageSearch,RuneX,RuneY,1,1,400,400, *1 buddy.png
            if(Errorlevel = 0) {
                
                SoundPlay, alarm2.mp3
            }
            ImageSearch,RuneX,RuneY,1,1,400,400, *1 eb.png
            if(Errorlevel = 0) {
                
                SoundPlay, alarm2.mp3
            }
            ImageSearch,RuneX,RuneY,1,1,400,400, *1 rune.png
            if(Errorlevel = 0) {
                
                SoundPlay, alarm.mp3
            }
            SetTimer, rune, -10000
        }
ZeroBetaLeft:
        AHI.Instance.SendKeyEvent(HID, GetKeySC("Left"), 1)
        sleep 100
        AHI.Instance.SendKeyEvent(HID, GetKeySC("s"), 1)
        sleep 700
        AHI.Instance.SendKeyEvent(HID, GetKeySC("space"), 1)
        sleep 100
        loop 3 {
        random, jump, %jump1%, %jump2%
        AHI.Instance.SendKeyEvent(HID, GetKeySC("v"), 1)
        AHI.Instance.SendKeyEvent(HID, GetKeySC("v"), 0)
        sleep %jump%
        }
        return
 ZeroAlphaAir:
        loop 3 {
            AHI.Instance.SendKeyEvent(HID, GetKeySC("a"), 1)
            sleep 300
            }AHI.Instance.SendKeyEvent(HID, GetKeySC("a"), 0)
        return