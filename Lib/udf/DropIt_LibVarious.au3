
; Various funtions collected for DropIt

#include-once
#include "APIConstants.au3"
#include <GUIConstantsEx.au3>
#include "WinAPIEx.au3"

Func __ByteSuffix($iBytes)
	#cs
		Description: Round A Value Of Bytes To Highest Value.
		Returns: [1024 Bytes = 1 KB]
	#ce
	Local $A, $iPlaces = 1, $aArray[9] = ["bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
	While $iBytes > 1023
		$A += 1
		$iBytes /= 1024
	WEnd
	If $iBytes < 100 Then
		$iPlaces += 1
	EndIf
	Return Round($iBytes, $iPlaces) & " " & $aArray[$A]
EndFunc   ;==>__ByteSuffix

Func __CmdLineRaw($sString) ; Taken From: http://www.autoitscript.com/forum/topic/121034-stringsplit-cmdlineraw/page__p__840768#entry840768
	Local $aError[2] = [1, $sString]

	If StringStripWS($sString, 8) = "" Then
		Return SetError(1, 0, $aError)
	EndIf
	Local $aReturn = StringRegExp('"' & @ScriptFullPath & '"' & ' ' & _WinAPI_ExpandEnvironmentStrings($sString), '((?<=\s"|^")[^"]+(?=")|[^\s"]+)', 3)
	If @error Then
		Return SetError(1, 0, $aError)
	EndIf
	$aReturn[0] = UBound($aReturn, 1) - 1
	Return $aReturn
EndFunc   ;==>__CmdLineRaw

Func __ExpandEnvStrings($iEnvStrings)
	#cs
		Description: Set The Expansion Of Environment Variables.
		Returns: 0 = Disabled Or 1 = Enabled
	#ce.
	Opt("ExpandEnvStrings", $iEnvStrings)
	Return $iEnvStrings
EndFunc   ;==>__ExpandEnvStrings

Func __ExpandEventMode($iEventMode)
	#cs
		Description: Set The Expansion Of The GUIOnEventMode.
		Returns: 0 = Disabled Or 1 = Enabled.
	#ce.
	Opt("GUIOnEventMode", $iEventMode)
	Return $iEventMode
EndFunc   ;==>__ExpandEventMode

Func __GetOSLanguage()
	#cs
		Description: Get The OS Language.
		Returns: Language [Italian]
	#ce
	Local $aString[20] = [19, "0409 0809 0c09 1009 1409 1809 1c09 2009 2409 2809 2c09 3009 3409", "0404 0804 0c04 1004 0406", "0406", "0413 0813", "0425", _
			"040b", "040c 080c 0c0c 100c 140c 180c", "0407 0807 0c07 1007 1407", "040e", "0410 0810", "0411", "0414 0814", "0415", "0416 0816", "0418", _
			"0419", "081a 0c1a", "040a 080a 0c0a 100a 140a 180a 1c0a 200a 240a 280a 2c0a 300a 340a 380a 3c0a 400a 440a 480a 4c0a 500a", "041d 081d"]

	Local $aLanguage[20] = [19, "English", "Chinese", "Danish", "Dutch", "Estonian", "Finnish", "French", "German", "Hungarian", "Italian", _
			"Japanese", "Norwegian", "Polish", "Portuguese", "Romanian", "Russian", "Serbian", "Spanish", "Swedish"]
	For $A = 1 To $aString[0]
		If StringInStr($aString[$A], @OSLang) Then
			Return $aLanguage[$A]
		EndIf
	Next
	Return $aLanguage[1]
EndFunc   ;==>__GetOSLanguage

Func __GUIInBounds($hHandle) ; Original Idea By wraithdu, Modified By guinness.
	#cs
		Description: Check If The GUI Is Within View Of The Users Screen.
		Returns: Move GUI If Out Of Bounds
	#ce
	Local $iXPos = 5, $iYPos = 5, $tWorkArea = DllStructCreate($tagRECT)
	_WinAPI_SystemParametersInfo($SPI_GETWORKAREA, 0, DllStructGetPtr($tWorkArea))

	Local $iLeft = DllStructGetData($tWorkArea, "Left"), $iTop = DllStructGetData($tWorkArea, "Top")
	Local $iWidth = DllStructGetData($tWorkArea, "Right") - $iLeft
	If _WinAPI_GetSystemMetrics($SM_CYVIRTUALSCREEN) > $iWidth Then
		$iWidth = _WinAPI_GetSystemMetrics($SM_CYVIRTUALSCREEN)
	EndIf
	$iWidth -= $iLeft
	Local $iHeight = DllStructGetData($tWorkArea, "Bottom") - $iTop
	Local $aWinGetPos = WinGetPos($hHandle)
	If @error Then
		Return SetError(1, 0, WinMove($hHandle, "", $iXPos, $iYPos))
	EndIf

	If $aWinGetPos[0] < $iLeft Then
		$iXPos = $iLeft
	ElseIf ($aWinGetPos[0] + $aWinGetPos[2]) > $iWidth Then
		$iXPos = $iWidth - $aWinGetPos[2]
	Else
		$iXPos = $aWinGetPos[0]
	EndIf
	If $aWinGetPos[1] < $iTop Then
		$iYPos = $iTop
	ElseIf ($aWinGetPos[1] + $aWinGetPos[3]) > $iHeight Then
		$iYPos = $iHeight - $aWinGetPos[3]
	Else
		$iYPos = $aWinGetPos[1]
	EndIf
	WinMove($hHandle, "", $iXPos, $iYPos)
	Return 1
EndFunc   ;==>__GUIInBounds

Func __IniReadSection($iFile, $iSection) ; Modified From: http://www.autoitscript.com/forum/topic/32004-iniex-functions-exceed-32kb-limit/page__view__findpost__p__229487
	#cs
		Description: Read A Section From A Standard Format INI File.
		Returns: $Array[?] - Array Contains Unlimited Number Of Items.
		[0][0] - Number Of Rows [3]

		[A][0] - Key [Example]
		[A][1] - Value [Test]
	#ce
	Local $iSize = FileGetSize($iFile) / 1024
	If $iSize <= 31 Then
		Local $iRead = IniReadSection($iFile, $iSection)
		If @error Then
			Return SetError(@error, 0, 0)
		EndIf
		If IsArray($iRead) = 0 Then
			Return SetError(-2, 0, 0)
		EndIf
		Return $iRead
	EndIf

	Local $iSplitKeyValue
	Local $iFileRead = FileRead($iFile)
	Local $iData = StringRegExp($iFileRead, "(?is)(?:^|\v)(?!;|#)\h*\[\h*\Q" & $iSection & "\E\h*\]\h*\v+(.*?)(?:\z|\v\h*\[)", 1)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	Local $iLines = StringSplit(StringRegExpReplace($iData[0], @CRLF & "|" & @CR & "|" & @LF, @LF), @LF)
	Local $iLeft, $iAdded = 0, $iSectionReturn[$iLines[0] + 1][2]
	For $A = 1 To $iLines[0]
		$iLeft = StringLeft(StringStripWS($iLines[$A], 8), 1)
		If $iLeft == ";" Or $iLeft == "#" Then
			ContinueLoop
		EndIf

		$iSplitKeyValue = StringSplit($iLines[$A], "=")
		If $iSplitKeyValue[0] > 1 Then
			$iAdded += 1
			$iSectionReturn[$iAdded][0] = $iSplitKeyValue[1]
			For $B = 2 To $iSplitKeyValue[0]
				If $B > 2 Then
					$iSectionReturn[$iAdded][1] &= "="
				EndIf
				$iSectionReturn[$iAdded][1] &= $iSplitKeyValue[$B]
			Next
		EndIf
	Next
	ReDim $iSectionReturn[$iAdded + 1][2]
	$iSectionReturn[0][0] = $iAdded
	Return $iSectionReturn
EndFunc   ;==>__IniReadSection

Func __IniWriteEx($iFile, $iSection, $iKey = "", $iValue = "")
	#cs
		Description: Write A Key Or A Section From A Standard Format INI File With Unicode Support.
		Returns: 1
	#ce
	Local $iWrite

	If FileGetEncoding($iFile) <> 32 Then
		Local $iFileRead = FileRead($iFile)
		If @error And FileExists($iFile) Then
			Return SetError(1, 0, 0)
		EndIf
		Local $iFileOpen = FileOpen($iFile, 2 + 8 + 32)
		If $iFileOpen = -1 Then
			Return SetError(1, 0, 0)
		EndIf
		$iWrite = FileWrite($iFileOpen, $iFileRead)
		FileClose($iFileOpen)
		If $iWrite = 0 Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf

	If $iKey = "" Then ; Write Section.
		$iWrite = IniWriteSection($iFile, $iSection, $iValue)
	Else ; Write Key.
		$iWrite = IniWrite($iFile, $iSection, $iKey, $iValue)
	EndIf
	If $iWrite = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__IniWriteEx

Func __InsertText(ByRef $hEdit, $sString) ; Modified From: http://www.autoitscript.com/forum/topic/34326-get-selected-text-and-replace/
	#cs
		Description: Insert A Text In A Control.
		Returns: Nothing
	#ce
	Local $iSelected = GUICtrlRecvMsg($hEdit, 0x00B0) ; $EM_GETSEL.
	If (IsArray($iSelected)) And ($iSelected[0] <= $iSelected[1]) Then
		GUICtrlSetData($hEdit, StringLeft(GUICtrlRead($hEdit), $iSelected[0]) & $sString & StringTrimLeft(GUICtrlRead($hEdit), $iSelected[1]))
	Else
		GUICtrlSetData($hEdit, GUICtrlRead($hEdit) & $sString)
	EndIf
EndFunc   ;==>__InsertText

Func __IsHandle($hHandle = -1)
	#cs
		Description: Check If GUI Handle Is A Valid Handle.
		Returns:
		If True Return The Handle.
		If False Return The AutoIt Hidden Handle.
	#ce
	If IsHWnd($hHandle) Then
		Return $hHandle
	EndIf
	Return WinGetHandle(AutoItWinGetTitle())
EndFunc   ;==>__IsHandle

Func __IsInstalled()
	#cs
		Description: Check If Program Is Installed (Simply Detecting The Inno Setup Uninstaller).
		Returns:
		If unins000.exe Exists Return 1
		If Not unins000.exe Exists Return 0
	#ce
	Return FileExists(@ScriptDir & "\unins000.exe")
EndFunc   ;==>__IsInstalled

Func __IsWindowsVersion()
	#cs
		Description: Check If The Windows Version Is Supported.
		Returns: 1 = Is Supported Or 0 = Not Supported.
	#ce
	Return RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\", "CurrentVersion") >= 6.0
EndFunc   ;==>__IsWindowsVersion

Func __OnTop($hHandle = -1, $iState = 1)
	#cs
		Description: Set A GUI Handle "OnTop".
		Returns: GUI OnTop
	#ce
	$hHandle = __IsHandle($hHandle) ; Check If GUI Handle Is A Valid Handle.

	WinSetOnTop($hHandle, "", $iState)
	Return $hHandle
EndFunc   ;==>__OnTop

Func __SetHandle($sID, $sGUI)
	#cs
		Description: Set Window Title For WM_COPYDATA.
		Returns: Handle ID
	#ce
	AutoItWinSetTitle($sID)
	ControlSetText($sID, '', ControlGetHandle($sID, '', 'Edit1'), $sGUI)
	Return WinGetHandle($sID)
EndFunc   ;==>__SetHandle

Func __SetProgress($sHandle, $sPercentage, $sColor = 0, $sVertical = False) ; Taken From: http://www.autoitscript.com/forum/topic/121883-progress-bar-without-animation-in-vista7/page__p__845958#entry845958
	#cs
		Description: Set A Custom Progress Bar.
		Return: Progress Data.
	#ce
	Local $sBitmap, $sClip, $sDC, $sMemDC, $sObject, $sRectangle, $sResult = 1, $sRet, $sStructure_1, $sStructure_2, $sTheme, $sWinAPI_Object
	If __IsWindowsVersion() = 0 Then
		GUICtrlSetState($sHandle, $GUI_SHOW)
		GUICtrlSetData($sHandle, $sPercentage)
		Return 1
	EndIf

	If IsHWnd($sHandle) = 0 Then
		$sHandle = GUICtrlGetHandle($sHandle)
		If $sHandle = 0 Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf
	$sTheme = DllCall('uxtheme.dll', 'ptr', 'OpenThemeData', 'hwnd', $sHandle, 'wstr', 'Progress')
	If (@error) Or (Not $sTheme[0]) Then
		Return 0
	EndIf
	$sRectangle = _WinAPI_GetClientRect($sHandle)
	$sStructure_1 = DllStructGetData($sRectangle, 3) - DllStructGetData($sRectangle, 1)
	$sStructure_2 = DllStructGetData($sRectangle, 4) - DllStructGetData($sRectangle, 2)
	$sDC = _WinAPI_GetDC($sHandle)
	$sMemDC = _WinAPI_CreateCompatibleDC($sDC)
	$sBitmap = _WinAPI_CreateSolidBitmap(0, _WinAPI_GetSysColor(15), $sStructure_1, $sStructure_2, 0)
	$sWinAPI_Object = _WinAPI_SelectObject($sMemDC, $sBitmap)
	DllStructSetData($sRectangle, 1, 0)
	DllStructSetData($sRectangle, 2, 0)
	DllStructSetData($sRectangle, 3, $sStructure_1)
	DllStructSetData($sRectangle, 4, $sStructure_2)
	$sRet = DllCall('uxtheme.dll', 'uint', 'DrawThemeBackground', 'ptr', $sTheme[0], 'hwnd', $sMemDC, 'int', 2 - (Not $sVertical), 'int', 0, 'ptr', DllStructGetPtr($sRectangle), 'ptr', 0)
	If (@error) Or ($sRet[0]) Then
		$sResult = 0
	EndIf
	If $sVertical Then
		DllStructSetData($sRectangle, 2, $sStructure_2 * (1 - $sPercentage / 100))
	Else
		DllStructSetData($sRectangle, 3, $sStructure_1 * $sPercentage / 100)
	EndIf
	$sClip = DllStructCreate($tagRECT)
	DllStructSetData($sClip, 1, 1)
	DllStructSetData($sClip, 2, 1)
	DllStructSetData($sClip, 3, $sStructure_1 - 1)
	DllStructSetData($sClip, 4, $sStructure_2 - 1)
	DllCall('uxtheme.dll', 'uint', 'DrawThemeBackground', 'ptr', $sTheme[0], 'hwnd', $sMemDC, 'int', 6 - (Not $sVertical), 'int', 1 + $sColor, 'ptr', DllStructGetPtr($sRectangle), 'ptr', DllStructGetPtr($sClip))
	If (@error) Or ($sRet[0]) Then
		$sResult = 0
	EndIf
	_WinAPI_ReleaseDC($sHandle, $sDC)
	_WinAPI_SelectObject($sMemDC, $sWinAPI_Object)
	_WinAPI_DeleteDC($sMemDC)
	DllCall('uxtheme.dll', 'uint', 'CloseThemeData', 'ptr', $sTheme[0])
	If $sResult Then
		_WinAPI_DeleteObject(_SendMessage($sHandle, 0x0172, 0, $sBitmap))
		$sObject = _SendMessage($sHandle, 0x0173)
		If $sObject <> $sBitmap Then
			_WinAPI_DeleteObject($sBitmap)
		EndIf
	EndIf
	Return $sResult
EndFunc   ;==>__SetProgress

Func __ShowPassword($iControlID)
	#cs
		Description: Show/Hide Password Of An Input Password Field.
		Returns: Input State.
	#ce
	Local Const $EM_GETPASSWORDCHAR = 0xD2, $EM_SETPASSWORDCHAR = 0xCC
	Local $sPasswordCharacter
	Switch GUICtrlSendMsg($iControlID, $EM_GETPASSWORDCHAR, 0, 0)
		Case 0
			$sPasswordCharacter = 9679
		Case Else
			$sPasswordCharacter = 0
	EndSwitch
	GUICtrlSendMsg($iControlID, $EM_SETPASSWORDCHAR, $sPasswordCharacter, 0)
	GUICtrlSetState($iControlID, $GUI_FOCUS)
	Return $sPasswordCharacter = 0
EndFunc   ;==>__ShowPassword

Func __StringIsValid($sString, $sPattern = '|<>')
	#cs
		Description: Check If A String Contains Invalid Characters.
		Returns:
		If String Contains Invalid Characters Return 1
		If Not String Contains Invalid Characters Return 0
	#ce
	If $sString = "" Then
		Return 0
	EndIf
	Return BitAND(StringRegExp($sString, '[\Q' & StringRegExpReplace($sPattern, "\\E", "E\") & '\E]') = 0, 1)
EndFunc   ;==>__StringIsValid
