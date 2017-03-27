
; Bounds funtions collected for DropIt

#include-once
#include <GUIConstantsEx.au3>
#include <WinAPI.au3>
#include <WinAPIsysinfoConstants.au3>
#include <WindowsConstants.au3>

Func __GUIGraduallyHide($hHandle, $iOnTop = 0, $iSpeed = 5, $iVisiblePixels = 50, $iMarginFromSide = 10, $iRevealOnly = 0, $iSide = -1)
	#cs
		Description: Gradually Hide GUI On The Nearest Side Of The Screen.
		Returns: 1
	#ce
	Local $aDesktopArea, $hMonitor, $aMousePos, $aWinPos, $iLength, $iMouseHover, $iInternalDist
	$aMousePos = MouseGetPos()
	$aWinPos = __WinGetPosEx($hHandle)
	If @error Then Return SetError(2, 0, 0)
	$hMonitor = __MonitorFromWindow($hHandle)
	If @error Then Return SetError(3, 0, 0)
	$aDesktopArea = __MonitorGetInfo($hMonitor)
	If @error Then Return SetError(4, 0, 0)
	If $iOnTop Then ; To Ignore Taskbar If Win On Top.
		$aDesktopArea[4] = $aDesktopArea[0]
		$aDesktopArea[5] = $aDesktopArea[1]
		$aDesktopArea[6] = $aDesktopArea[2]
		$aDesktopArea[7] = $aDesktopArea[3]
	EndIf
	If $iSide = -1 Then $iSide = __GetNearSide($aDesktopArea[2] - $aDesktopArea[0], $aDesktopArea[3] - $aDesktopArea[1], $aWinPos[4] - $aDesktopArea[0], $aWinPos[5] - $aDesktopArea[1])

	Switch $iSide
		Case 1 ; Hide On Top Side.
			If $hMonitor <> __MonitorFromPoint($aWinPos[4], $aDesktopArea[1] - 10) Then Return SetError(5, 0, 0) ; Do Not Hide On Sides Between Two Monitors.
			Local $aRefPos[4] = [$aWinPos[0] - 5, $aWinPos[6] + 5, $aDesktopArea[5], $aWinPos[7] + 10]
			$iInternalDist = $aWinPos[1] - $aDesktopArea[5]
			$iLength = $aWinPos[3]
		Case 2 ; Hide On Right Side.
			If $hMonitor <> __MonitorFromPoint($aDesktopArea[2] + 10, $aWinPos[5]) Then Return SetError(5, 0, 0) ; Do Not Hide On Sides Between Two Monitors.
			Local $aRefPos[4] = [$aWinPos[0] - 10, $aDesktopArea[6], $aWinPos[1] - 5, $aWinPos[7] + 5]
			$iInternalDist = $aDesktopArea[6] - $aWinPos[6]
			$iLength = $aWinPos[2]
		Case 3 ; Hide On Bottom Side.
			If $hMonitor <> __MonitorFromPoint($aWinPos[4], $aDesktopArea[3] + 10) Then Return SetError(5, 0, 0) ; Do Not Hide On Sides Between Two Monitors.
			Local $aRefPos[4] = [$aWinPos[0] - 5, $aWinPos[6] + 5, $aWinPos[1] - 10, $aDesktopArea[7]]
			$iInternalDist = $aDesktopArea[7] - $aWinPos[7]
			$iLength = $aWinPos[3]
		Case Else ; Hide On Left Side.
			If $hMonitor <> __MonitorFromPoint($aDesktopArea[0] - 10, $aWinPos[5]) Then Return SetError(5, 0, 0) ; Do Not Hide On Sides Between Two Monitors.
			Local $aRefPos[4] = [$aDesktopArea[4], $aWinPos[6] + 10, $aWinPos[1] - 5, $aWinPos[7] + 5]
			$iInternalDist = $aWinPos[0] - $aDesktopArea[4]
			$iLength = $aWinPos[2]
	EndSwitch
	If $aMousePos[0] >= $aRefPos[0] And $aMousePos[0] <= $aRefPos[1] And $aMousePos[1] >= $aRefPos[2] And $aMousePos[1] <= $aRefPos[3] Then $iMouseHover = 1 ; Show.

	If $iInternalDist < $iMarginFromSide And $iMouseHover = 1 Then ; Gradually Show Window.
		If WinActive($hHandle) = 0 Then WinActivate($hHandle)
		$iInternalDist += $iSpeed
		If $iInternalDist > $iMarginFromSide Then $iInternalDist = $iMarginFromSide
	ElseIf $iInternalDist > ($iVisiblePixels - $iLength) And $iMouseHover = 0 And $iRevealOnly = 0 Then ; Gradually Hide Window.
		If $iInternalDist > 0 Then $iInternalDist = 0
		$iInternalDist -= $iSpeed
		If $iInternalDist < ($iVisiblePixels - $iLength) Then $iInternalDist = $iVisiblePixels - $iLength
	Else
		Return SetError(1, 0, 0) ; Completely Hidden/Revealed.
	EndIf

	Switch $iSide
		Case 1 ; Hide On Top Side.
			$aWinPos[1] = $aDesktopArea[5] + $iInternalDist
		Case 2 ; Hide On Right Side.
			$aWinPos[0] = $aDesktopArea[6] - $iLength - $iInternalDist
		Case 3 ; Hide On Bottom Side.
			$aWinPos[1] = $aDesktopArea[7] - $iLength - $iInternalDist
		Case Else ; Hide On Left Side.
			$aWinPos[0] = $aDesktopArea[4] + $iInternalDist
	EndSwitch

	WinMove($hHandle, "", $aWinPos[0], $aWinPos[1])
	Sleep(20)
	Return 1
EndFunc   ;==>__GUIGraduallyHide

Func __WinGetPosEx($hHandle)
	#cs
		Description: Get Position And Size Of A Window.
		Returns: Array[8]
		[0] - Left-Side Position From Left
		[1] - Top-Side Position From Top
		[2] - Width
		[3] - Height
		[4] - Center Position From Left
		[5] - Center Position From Top
		[6] - Right-Side Position From Left
		[7] - Bottom-Side Position From Top
	#ce
	Local $aWinPos = WinGetPos($hHandle)
	If @error Then Return SetError(@error, 0, 0)
	Local $aReturn[8] = [$aWinPos[0], $aWinPos[1], $aWinPos[2], $aWinPos[3], $aWinPos[0] + Ceiling($aWinPos[2] / 2), $aWinPos[1] + Ceiling($aWinPos[3] / 2), $aWinPos[0] + $aWinPos[2], $aWinPos[1] + $aWinPos[3]]
	Return $aReturn
EndFunc   ;==>__WinGetPosEx

Func __GetNearSide($iScreenW, $iScreenH, $iWinCX, $iWinCY)
	#cs
		Description: Get The Nearest Side Of Current Monitor To The Window Center.
		Returns: 0 = Left, 1 = Top, 2 = Right, 3 = Bottom.
	#ce
	Local $iReturn
	Local $aRatio[3] = [$iScreenW / $iScreenH, $iWinCX / $iWinCY, ($iScreenW - $iWinCX) / $iWinCY]
	Select
		Case $iWinCX <= 0 Or ($aRatio[1] < $aRatio[0] And $aRatio[2] >= $aRatio[0]) ; Near Left.
			$iReturn = 0
		Case $iWinCY <= 0 Or ($aRatio[1] >= $aRatio[0] And $aRatio[2] >= $aRatio[0]) ; Near Top.
			$iReturn = 1
		Case $iWinCX >= $iScreenW Or ($aRatio[1] >= $aRatio[0] And $aRatio[2] < $aRatio[0]) ; Near Right.
			$iReturn = 2
		Case Else ; Near Bottom.
			$iReturn = 3
	EndSelect
	Return $iReturn
EndFunc   ;==>__GetNearSide

Func __GUIInBounds($hHandle) ; Original Idea By wraithdu, Modified By guinness And Lupo73.
	#cs
		Description: Check If The GUI Is Within View Of The Users Screen.
		Returns: Move GUI If Out Of Bounds
	#ce
	Local $iXPos = 5, $iYPos = 5, $aWinPos = __WinGetPosEx($hHandle)
	If @error Then Return SetError(1, 0, WinMove($hHandle, "", $iXPos, $iYPos))
	Local $aDesktopArea = __MonitorGetInfo(__MonitorFromWindow($hHandle))
	If @error Then Return SetError(2, 0, WinMove($hHandle, "", $iXPos, $iYPos))
	$iXPos = $aWinPos[0]
	$iYPos = $aWinPos[1]
	If $aWinPos[0] < $aDesktopArea[4] Then
		$iXPos = $aDesktopArea[4]
	ElseIf $aWinPos[6] > $aDesktopArea[6] Then
		$iXPos = $aDesktopArea[6] - $aWinPos[2]
	EndIf
	If $aWinPos[1] < $aDesktopArea[5] Then
		$iYPos = $aDesktopArea[5]
	ElseIf $aWinPos[7] > $aDesktopArea[7] Then
		$iYPos = $aDesktopArea[7] - $aWinPos[3]
	EndIf
	WinMove($hHandle, "", $iXPos, $iYPos)
	Return 1
EndFunc   ;==>__GUIInBounds

Func __MonitorGetInfo($hMonitor) ; Modified From: http://www.autoitscript.com/forum/topic/134534-desktopdimensions-details-about-the-primary-and-secondary-monitors/
	#cs
		Description: Get Info About A Monitor (Given A Monitor Handle).
		; Returns: $Array[10]
		[0] = Monitor upper-left corner X coordinate (this rect is same as full-screen size)
		[1] = Monitor upper-left corner Y coordinate
		[2] = Monitor lower-right corner X coordinate
		[3] = Monitor lower-right corner Y coordinate
		[4] = Monitor Work Area upper-left corner X coordinate (this rect is same as maximized size)
		[5] = Monitor Work Area upper-left corner Y coordinate
		[6] = Monitor Work Area lower-right corner X coordinate
		[7] = Monitor Work Area lower-right corner Y coordinate
		[8] = Primary monitor boolean (0 = not, 1 = is)
		[9] = Monitor Or Display Device Name (usually '.DISPLAY#' where # starts at 1)
    #ce
	If IsPtr($hMonitor) = 0 Or $hMonitor = 0 Then Return SetError(1,0,'')
	Local $aRet, $stMonInfoEx = DllStructCreate('dword;long[8];dword;wchar[32]')
	DllStructSetData($stMonInfoEx, 1, DllStructGetSize($stMonInfoEx))
	$aRet = DllCall('user32.dll', 'bool', 'GetMonitorInfoW', 'handle', $hMonitor, 'ptr', DllStructGetPtr($stMonInfoEx))
	If @error Then Return SetError(2, 0, '')
	If $aRet[0] = 0 Then Return SetError(3, 0, '')
	Dim $aRet[10]
	For $A = 0 To 7 ; Both RECT's
		$aRet[$A] = DllStructGetData($stMonInfoEx, 2, $A + 1)
	Next
	$aRet[8] = DllStructGetData($stMonInfoEx, 3) ; 0 or 1 for Primary Monitor [MONITORINFOF_PRIMARY = 1]
	$aRet[9] = DllStructGetData($stMonInfoEx, 4) ; Device String of type '.DISPLAY1' etc
    Return $aRet
EndFunc   ;==>__MonitorGetInfo

Func __MonitorFromPoint($iX, $iY)
	Local $aRet, $stPoint = DllStructCreate($tagPOINT)
	DllStructSetData($stPoint, "x", $iX)
	DllStructSetData($stPoint, "y", $iY)
	$aRet = DllCall("user32.dll", "handle", "MonitorFromPoint", "struct", $stPoint, 'dword', 2)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aRet[0]
EndFunc   ;==>__MonitorFromPoint

Func __MonitorFromWindow($hWin)
	Local $aRet = DllCall("user32.dll", "hwnd", "MonitorFromWindow", "hwnd", $hWin, "int", 2)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aRet[0]
EndFunc   ;==>__MonitorFromWindow

Func __WindowFromPoint($iX, $iY)
	Local $stInt64, $aRet, $stPoint = DllStructCreate("long;long")
	DllStructSetData($stPoint, 1, $iX)
	DllStructSetData($stPoint, 2, $iY)
	$stInt64 = DllStructCreate("int64", DllStructGetPtr($stPoint))
	$aRet = DllCall("user32.dll", "hwnd", "WindowFromPoint", "int64", DllStructGetData($stInt64, 1))
	If @error Then Return SetError(@error, @extended, 0)
	Return $aRet[0]
EndFunc   ;==>__WindowFromPoint
