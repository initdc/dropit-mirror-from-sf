#include-once

; #INDEX# ============================================================================================================
; Title .........: ExtMsgBox
; AutoIt Version : v3.2.12.1 or higher
; Language ......: English
; Description ...: Generates user defined message boxes centred on an owner, on screen or at defined coordinates
; Remarks .......:
; Note ..........:
; Author(s) .....: Melba23, based on some original code by photonbuddy & YellowLab
; ====================================================================================================================

;#AutoIt3Wrapper_au3check_parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6

; #INCLUDES# =========================================================================================================
#include "StringSize.au3"

; #GLOBAL CONSTANTS# =================================================================================================
Global Const $MB_ICONSTOP   = 16 ; Stop-sign icon
Global Const $MB_ICONQUERY  = 32 ; Question-mark icon
Global Const $MB_ICONEXCLAM = 48 ; Exclamation-point icon
Global Const $MB_ICONINFO   = 64 ; Icon consisting of an 'i' in a circle

; #GLOBAL VARIABLES# =================================================================================================
Global $iDef_EMB_Font_Size = _GetDefaultEMBFont(0)
Global $sDef_EMB_Font_Name = _GetDefaultEMBFont(1)
Global $iEMB_Style = 0
Global $iEMB_Just = 0
Global $iEMB_BkCol = Default
Global $iEMB_Col   = Default
Global $sEMB_Font_Name = $sDef_EMB_Font_Name
Global $iEMB_Font_Size = $iDef_EMB_Font_Size

; #CURRENT# ==========================================================================================================
; _ExtMsgBoxSet: Sets the GUI style, justification, colours and font for subsequent _ExtMsgBox function calls
; _ExtMsgBox:    Generates user defined message boxes centred on an owner, on screen or at defined coordinates
; ====================================================================================================================

; #INTERNAL_USE_ONLY#=================================================================================================
; _GetDefaultEMBFont: Determines Windows default MsgBox font size and name
; ====================================================================================================================

; #FUNCTION# =========================================================================================================
; Name...........: _ExtMsgBoxSet
; Description ...: Sets the GUI style, justification, colours and font for subsequent _ExtMsgBox function calls
; Syntax.........: _ExtMsgBoxSet($iStyle, $iJust, [$iBkCol, [$iCol, [$sFont_Size, [$iFont_Name]]]])
; Parameters ....: $iStyle      -> 0 = Normal - Button appears on TaskBar (Default), 1 = Button does not appear on TaskBar
;                   >>>>>>>>>>     Setting this parameter to 'Default' will reset ALL parameters to default values <<<<<<<<<<
;                  $iJust       -> 0 = Left justified (Default), 1 = Centred , 2 = Right justified
;                                  + 4 = Centred single button.  Note: multiple buttons are always centred
;                                  ($SS_LEFT, $SS_CENTER, $SS_RIGHT can also be used)
;                   $iBkCol		-> The colour for the message box background.  Default = system colour
;                   $iCol		-> The colour for the message box text.  Default = system colour
;                                  Omitting a colour parameter or setting -1 leaves it unchanged
;                                  Setting a colour parameter to Default resets the system message box colour
;                   $iFont_Size -> The font size in points to use for the message box. Default = system font size
;                   $sFont_Name -> The font to use for the message box. Default = system font
;                                  Omitting a font parameter or setting  font size to -1 or font name to "" = unchanged
;                                  Setting a font parameter to Default resets the system message box font and size
; Requirement(s).: v3.2.12.1 or higher
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and sets @error to 1 with @extended set to parameter index number
; Remarks .......;
; Author ........: Melba23
; Example........; Yes
;=====================================================================================================================

Func _ExtMsgBoxSet($iStyle = 0, $iJust = 0, $iBkCol = -1, $iCol = -1, $iFont_Size = -1, $sFont_Name = "")

	Local $aRet

	; Set global EMB variables to required values
	Switch $iStyle
		Case Default
			$iEMB_Style = 0
			$iEMB_Just = 0 ; $SS_LEFT
			$aRet = DllCall("User32.dll", "int", "GetSysColor", "int", 5) ; $COLOR_WINDOW = 5
			$iEMB_BkCol = $aRet[0]
			$aRet = DllCall("User32.dll", "int", "GetSysColor", "int", 8) ; $COLOR_WINDOWTEXT = 8
			$iEMB_Col = $aRet[0]
			$sEMB_Font_Name = $sDef_EMB_Font_Name
			$iEMB_Font_Size = $iDef_EMB_Font_Size
			Return
		Case 0, 1
			$iEMB_Style = $iStyle
		Case Else
			Return SetError(1, 1, 0)
	EndSwitch

	Switch $iJust
		Case 0, 1, 2, 4, 5, 6
			$iEMB_Just = $iJust
		Case Else
			Return SetError(1, 2, 0)
	EndSwitch

	Switch $iBkCol
		Case Default
			$aRet = DllCall("User32.dll", "int", "GetSysColor", "int", 5) ; $COLOR_WINDOW = 5
			$iEMB_BkCol = $aRet[0]
		Case -1
			; Do nothing
		Case 0 To 0xFFFFFF
			$iEMB_BkCol = $iBkCol
		Case Else
			Return SetError(1, 3, 0)
	EndSwitch

	Switch $iCol
		Case Default
			$aRet = DllCall("User32.dll", "int", "GetSysColor", "int", 8) ; $COLOR_WINDOWTEXT = 8
			$iEMB_Col = $aRet[0]
		Case -1
			; Do nothing
		Case 0 To 0xFFFFFF
			$iEMB_Col = $iCol
		Case Else
			Return SetError(1, 4, 0)
	EndSwitch

	Switch $iFont_Size
		Case Default
			$iEMB_Font_Size = $iDef_EMB_Font_Size
		Case 8 To 72
			$iEMB_Font_Size = Int($iFont_Size)
        Case -1
			; Do nothing
		Case Else
			Return SetError(1, 5, 0)
	EndSwitch

	Switch $sFont_Name
		Case Default
			$sEMB_Font_Name = $sDef_EMB_Font_Name
		Case ""
			; Do nothing
		Case Else
			If IsString($sFont_Name) Then
				$sEMB_Font_Name = $sFont_Name
			Else
				Return SetError(1, 6, 0)
			EndIf
	EndSwitch

	Return 1

EndFunc

; #FUNCTION# =========================================================================================================
; Name...........: _ExtMsgBox
; Description ...: Generates user defined message boxes centred on an owner, on screen or at defined coordinates
; Syntax.........: _ExtMsgBox ($iIcon, $iButton, $sTitle, $sText, [$iTimeout, [$hWin, [$iTop]]])
; Parameters ....: $iIcon		-> The $MB_ICON constant for the icon to use:
;                                  0 - No icon, 16 - Stop, 32 - Query, 48 - Exclamation, 64 - Information
;                                  Any other value returns -1, error 1
;                   $iButton	-> Button text separated with "|" character. An ampersand (&)before the text indicates
;                                  the default button. Two focus ampersands returns -1, error 2.
;                                  Can also use $MB_ button constants:
;                                  0 = "OK", 1 = "OK|Cancel", 2 = "Abort|Retry|Ignore", 3 = "Yes|No|Cancel"
;                                  4 = "Yes|No", 5 = "Retry|Cancel" Incorrect constant returns -1, error 3
;                                  Default max width of 370 gives 1-4 buttons @ width 80, 5 @ width 60, 6 @ width 50
;                                  Min button width set at 50, so 7 buttons returns -1, error 4 unless default changed
;                   $sTitle		-> The title of the message box
;                   $sText		-> The text to be displayed. Long lines will wrap. The box depth is adjusted to fit
;                   $iTimeout	-> Timeout delay before EMB closes. 0 = no timeout (Default)
;                   $hWin		-> Handle of the window in which EMB is centred
;                                  If window is hidden or no handle passed EMB centred in display (Default)
;                                  If parameter holds number which is not a valid window handle,
;                                  it is interpreted as horizontal coordinate for EMB location
;                   $iVPos      -> Vertical parameter for EMB location, only if $hWin parameter is
;                                  interpreted as horizontal coordinate.  (Default = 0)
; Requirement(s).: v3.2.12.1 or higher
; Return values .: Success:	Returns 1-based index of the button pressed, counting from the LEFT.
;                           Returns 0 if closed by a "CloseGUI" event (i.e. click [X] or press Escape)
;                           Returns 9 if timed out
;                  Failure:	Returns -1 and sets @error as follows:
;                               1 - Icon error
;                               2 - Multiple default button error
;                               3 - Button constant error
;                               4 - Too many buttons to fit max GUI size
;                               5 - StringSize error
;                               6 - GUI creation error
; Remarks .......; EMB position automatically adjusted to appear on screen
; Author ........: Melba23, based on some original code by photonbuddy & YellowLab
; Example........; Yes
;=====================================================================================================================

Func _ExtMsgBox($iIcon, $iButton, $sTitle, $sText, $iTimeout = 0, $hWin = "", $iVPos = 0)

	Local $iParent_Win = 0

	Local $nOldOpt = Opt('GUIOnEventMode', 0)

	; Set default sizes for message box
	Local $iMsg_Width_max = 460, $iMsg_Width_min = 150
	Local $iMsg_Height_min = 90
	Local $iButton_Width_max = 80, $iButton_Width_min = 50

	; Declare local variables
	Local $iButton_Width_Req, $iButton_Width, $iButton_Xpos, $iRet_Value, $iHpos, $iIcon_Style

	; Check for icon
	Local $iIcon_Reduction = 50
	Switch $iIcon
		Case 0
			$iIcon_Reduction = 0
		Case 16 ; Stop
			$iIcon_Style = -4
		Case 32 ; Query
			$iIcon_Style = -3
		Case 48 ; Exclam
			$iIcon_Style = -2
		Case 64 ; Info
			$iIcon_Style = -5
		Case Else
			$nOldOpt = Opt('GUIOnEventMode', $nOldOpt)
			Return SetError(1, 0, -1)
	EndSwitch

	; Check if using constants or text
	If IsNumber($iButton) Then
		Switch $iButton
			Case 0
				$iButton = "OK"
			Case 1
				$iButton = "OK|Cancel"
			Case 2
				$iButton = "Abort|Retry|Ignore"
			Case 3
				$iButton = "Yes|No|Cancel"
			Case 4
				$iButton = "Yes|No"
			Case 5
				$iButton = "Retry|Cancel"
			Case Else
				$nOldOpt = Opt('GUIOnEventMode', $nOldOpt)
				Return SetError(3, 0, -1)
		EndSwitch
	EndIf

	; Check if two buttons are seeking focus
	If StringInStr($iButton, "&", 0, 2) <> 0 Then
		$nOldOpt = Opt('GUIOnEventMode', $nOldOpt)
		Return SetError(2, 0, -1)
	EndIf

	; Get individual button text
	Local $aButtons = StringSplit($iButton, "|")
	; Get minimum GUI width needed for buttons
	Local $iMsg_Width_Button = ($iButton_Width_max + 10) * $aButtons[0] + 10
	; If shorter than min width
	If $iMsg_Width_Button < $iMsg_Width_min Then
		; Set buttons to max size and leave box min width unchanged
		$iButton_Width = $iButton_Width_max
	Else
		; Check button width needed to fit within max box width
		$iButton_Width_Req = ($iMsg_Width_max - (($aButtons[0] + 1) * 10)) / $aButtons[0]
		; Button width less than min button width permitted
		If $iButton_Width_Req < $iButton_Width_min Then
			$nOldOpt = Opt('GUIOnEventMode', $nOldOpt)
			Return SetError(4, 0, -1)
			; Buttons only need resizing to fit
		ElseIf $iButton_Width_Req < $iButton_Width_max Then
			; Set box to max width and set button size as required
			$iMsg_Width_Button = $iMsg_Width_max
			$iButton_Width = $iButton_Width_Req
			; Buttons can be max size
		Else
			; Set box min width to fit buttons
			$iButton_Width = $iButton_Width_max
			$iMsg_Width_min = $iMsg_Width_Button
		EndIf
	EndIf

	; Now get message label size
	$sText = StringReplace($sText, @LF, @CRLF)
	Local $aLabel_Pos = _StringSize($sText, $iEMB_Font_Size, Default, Default, $sEMB_Font_Name, $iMsg_Width_max - 20 - $iIcon_Reduction)
	If @error Then
		$nOldOpt = Opt('GUIOnEventMode', $nOldOpt)
		Return SetError(5, 0, -1)
	EndIf

	; Reset text to wrapped version
	$sText = $aLabel_Pos[0]

	; Set label size
	Local $iLabel_Width = $aLabel_Pos[2]
	Local $iLabel_Height = $aLabel_Pos[3]
	; Set GUI size
	Local $iMsg_Width = $iLabel_Width + 20 + $iIcon_Reduction
	If $iMsg_Width < $iMsg_Width_min Then
		$iMsg_Width = $iMsg_Width_min
		$iLabel_Width = $iMsg_Width_min - 20
	EndIf
	Local $iMsg_Height = $iLabel_Height + 65
	If $iMsg_Height < $iMsg_Height_min Then $iMsg_Height = $iMsg_Height_min

	; If only single line, lower label to to centre text on icon
	Local $iLabel_Vert = 16
	If StringInStr($sText, @CRLF) = 0 And $iIcon_Reduction <> 0 Then $iLabel_Vert = 27

	; Check for style required
	If $iEMB_Style = 1 Then ; Hide taskbar button so create as child
		If IsHWnd($hWin) Then
			$iParent_Win = $hWin ; Make child of that window
		Else
			$iParent_Win = WinGetHandle(AutoItWinGetTitle()) ; Make child of AutoIt window
		EndIf
	EndIf

	; Determine EMB location
	If $hWin = "" Then
		; No handle or position passed so centre on screen
		$iHpos = (@DesktopWidth - $iMsg_Width) / 2
		$iVPos = (@DesktopHeight - $iMsg_Height) / 2
	Else
		If IsHWnd($hWin) Then
			; Get parent GUI pos if visible
			If BitAND(WinGetState($hWin), 2) Then
				; Set EMB to centre on parent
				Local $aPos = WinGetPos($hWin)
				$iHpos = ($aPos[2] - $iMsg_Width) / 2 + $aPos[0] - 3
				$iVPos = ($aPos[3] - $iMsg_Height) / 2 + $aPos[1] - 20
			Else
				; Set EMB to centre om screen
				$iHpos = (@DesktopWidth - $iMsg_Width) / 2
				$iVPos = (@DesktopHeight - $iMsg_Height) / 2
			EndIf
		Else
			; Assume parameter is horizontal coord
			$iHpos = $hWin ; $iVpos already set
		EndIf
	EndIf

	; Now check to make sure GUI is visible on screen
	; First horizontally
	If $iHpos < 10 Then $iHpos = 10
	If $iHpos + $iMsg_Width > @DesktopWidth - 20 Then $iHpos = @DesktopWidth - 20 - $iMsg_Width
	; Then vertically
	If $iVPos < 10 Then $iVPos = 10
	If $iVPos + $iMsg_Height > @DesktopHeight - 60 Then $iVPos = @DesktopHeight - 60 - $iMsg_Height

	; Create GUI with $WS_POPUPWINDOW, $WS_CAPTION style and $WS_EX_TOPMOST extended style
	Local $hMsgGUI = GUICreate($sTitle, $iMsg_Width, $iMsg_Height, $iHpos, $iVPos, BitOR(0x80880000, 0x00C00000), 0x00000008, $iParent_Win)
	If @error Then
		$nOldOpt = Opt('GUIOnEventMode', $nOldOpt)
		Return SetError(6, 0, -1)
	EndIf
	GUISetFont($iEMB_Font_Size, Default, Default, $sEMB_Font_Name)
	If $iEMB_BkCol <> Default Then GUISetBkColor($iEMB_BkCol)

	; Set centring parameter
	Local $iLabel_Style = 0 ; $SS_LEFT
	If BitAND($iEMB_Just, 1) = 1 Then
		$iLabel_Style = 1 ; $SS_CENTER
	ElseIf BitAND($iEMB_Just, 2) = 2 Then
		$iLabel_Style = 2 ; $SS_RIGHT
	EndIf

	; Create label
	GUICtrlCreateLabel($sText, 10 + $iIcon_Reduction, $iLabel_Vert, $iLabel_Width, $iLabel_Height, $iLabel_Style)
	GUICtrlSetFont(-1, $iEMB_Font_Size, 400, 0, $sEMB_Font_Name)
	If $iEMB_Col <> Default Then GUICtrlSetColor(-1, $iEMB_Col)

	; Create icon
	If $iIcon_Reduction Then GUICtrlCreateIcon("user32.dll", $iIcon_Style, 10, 20)

	; Create buttons
	Local $iDef_Button = 0
	; Calculate button horizontal start
	If $aButtons[0] = 1 Then
		If BitAND($iEMB_Just, 4) = 4 Then
			; Single centred button
			$iButton_Xpos = ($iMsg_Width - $iButton_Width) / 2
		Else
			; Single offset button
			$iButton_Xpos = $iMsg_Width - $iButton_Width - 10
		EndIf
	Else
		; Multiple centred buttons
		$iButton_Xpos = 10 + ($iMsg_Width - $iMsg_Width_Button) / 2
	EndIf
	; Create dummy to calculate return value
	Local $hButton_Start = GUICtrlCreateDummy()
	; Work through button list
	For $i = 0 To $aButtons[0] - 1
		Local $iButton_Text = $aButtons[$i + 1]
		; See if button is default
		If StringLeft($iButton_Text, 1) = "&" Then
			$iDef_Button = 0x0001
			$aButtons[$i + 1] = StringTrimLeft($iButton_Text, 1)
		EndIf
		; Draw button
		GUICtrlCreateButton($aButtons[$i + 1], $iButton_Xpos + ($i * ($iButton_Width + 10)), $iMsg_Height - 35, $iButton_Width, 25, $iDef_Button)
		; Reset default parameter
		$iDef_Button = 0
	Next

	; Show GUI
	GUISetState(@SW_SHOW, $hMsgGUI)

	; Begin timeout counter
	Local $iTimeout_Begin = TimerInit()

	; Much faster to declare GUIGetMsg return array here and not in loop
	Local $aMsg

	While 1
		$aMsg = GUIGetMsg(1)

		If $aMsg[1] = $hMsgGUI Then

			Select
				Case $aMsg[0] = -3 ; $GUI_EVENT_CLOSE
					$iRet_Value = 0
					ExitLoop
				Case $aMsg[0] > $hButton_Start
					; Button handle minus dummy handle will give button index
					$iRet_Value = $aMsg[0] - $hButton_Start
					ExitLoop
			EndSelect
		EndIf

		; Timeout if required
		If TimerDiff($iTimeout_Begin) / 1000 >= $iTimeout And $iTimeout > 0 Then
			$iRet_Value = 9
			ExitLoop
		EndIf

	WEnd

	$nOldOpt = Opt('GUIOnEventMode', $nOldOpt)

	GUIDelete($hMsgGUI)

	Return $iRet_Value

EndFunc   ;==>_ExtMsgBox

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _GetDefaultEMBFont
; Description ...: Determines Windows default MsgBox font size and name
; Syntax.........: _GetDefaultEMBFont([$iData)
; Parameters ....: $iData	=> 0 = point size, 1 = font name
; Return values .: Success - return value as requested by $iData
;                : Failure - default values
; Author ........: Melba 23, based on some original code by Larrydalooza
; Remarks .......: Used internally by ExtMsgBox UDF
; ===============================================================================================================================
Func _GetDefaultEMBFont($iData)

	; Get default system font data
	Local $tNONCLIENTMETRICS = DllStructCreate("uint;int;int;int;int;int;byte[60];int;int;byte[60];int;int;byte[60];byte[60];byte[60]")
	DLLStructSetData($tNONCLIENTMETRICS, 1, DllStructGetSize($tNONCLIENTMETRICS))
	DLLCall("user32.dll", "int", "SystemParametersInfo", "int", 41, "int", DllStructGetSize($tNONCLIENTMETRICS), "ptr", DllStructGetPtr($tNONCLIENTMETRICS), "int", 0)
	; Read font data for MsgBox font
	Local $tLOGFONT = DllStructCreate("long;long;long;long;long;byte;byte;byte;byte;byte;byte;byte;byte;char[32]", DLLStructGetPtr($tNONCLIENTMETRICS, 15))
	If @error Then
		Switch $iData
			Case 0
				Return 9
			Case 1
				Return "Tahoma"
		EndSwitch
	Else
		Switch $iData
			Case 0
				Return Int((Abs(DllStructGetData($tLOGFONT, 1)) + 1) * .75) ; Font size as integer
			Case 1
				Return DllStructGetData($tLOGFONT, 14)                      ; Font name
		EndSwitch
	EndIf

EndFunc ;=>_GetDefaultEMBFont

