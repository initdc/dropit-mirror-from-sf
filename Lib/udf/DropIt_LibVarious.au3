
; Various funtions collected for DropIt

#include-once
#include "APIConstants.au3"
#include <GUIConstantsEx.au3>
#include "WinAPIEx.au3"

Func _ArraySortEx(ByRef $avArray, $iStartRow = 1, $iEndRow = 0, $iCol1 = 0, $iCol2 = -1, $iCol3 = -1, $iCol4 = -1) ; Taken From: http://www.autoitscript.com/forum/topic/98071-array-multi-column-sort/
	Local $iLastRow = 0, $iStart = -1, $iEnd = -1

	If $iCol1 >= 0 Then ; Sort on the first column.
		_ArraySort($avArray, 0, $iStartRow, $iEndRow, $iCol1)

		If $iCol2 >= 0 Then ; For each group of values in the first column sort the second column.
			$iStart = -1
			$iLastRow = UBound($avArray) - 1
			For $i = $iStartRow To $iLastRow
				Switch $i
					Case $iStartRow
						If $i <> $iLastRow Then
							If ($avArray[$i][$iCol1] <> $avArray[$i + 1][$iCol1]) Then
								$iStart = $i
								$iEnd = $i
							Else
								$iStart = $i
								$iEnd = $i + 1
							EndIf
						EndIf
					Case $iLastRow
						$iEnd = $iLastRow
						If $iStart <> $iEnd Then
							_ArraySort($avArray, 0, $iStart, $iEnd, $iCol2)
						EndIf
					Case Else
						If ($avArray[$i][$iCol1] <> $avArray[$i + 1][$iCol1]) Then
							$iEnd = $i
							If $iStart <> $iEnd Then
								_ArraySort($avArray, 0, $iStart, $iEnd, $iCol2)
							EndIf
							$iStart = $i + 1
							$iEnd = $iStart
						Else
							$iEnd = $i
						EndIf
				EndSwitch
			Next

			If $iCol3 >= 0 Then ; For each group of values in the second column sort the third column.
				$iStart = -1
				For $i = 1 To $iLastRow
					Switch $i
						Case 1
							If $i <> $iLastRow Then
								If ($avArray[$i][$iCol1] <> $avArray[2][$iCol1]) Or ($avArray[$i][$iCol2] <> $avArray[2][$iCol2]) Then
									$iStart = 2
									$iEnd = $iStart
								Else
									$iStart = 1
									$iEnd = $iStart
								EndIf
							EndIf
						Case $iLastRow
							$iEnd = $iLastRow
							If $iStart <> $iEnd Then
								_ArraySort($avArray, 0, $iStart, $iEnd, $iCol3)
							EndIf
						Case Else
							If ($avArray[$i][$iCol1] <> $avArray[$i + 1][$iCol1]) Or ($avArray[$i][$iCol2] <> $avArray[$i + 1][$iCol2]) Then
								$iEnd = $i
								If $iStart <> $iEnd Then
									_ArraySort($avArray, 0, $iStart, $iEnd, $iCol3)
								EndIf
								$iStart = $i + 1
								$iEnd = $iStart
							Else
								$iEnd = $i
							EndIf
					EndSwitch
				Next

				If $iCol4 >= 0 Then ; For each group of values in the third column sort the forth column.
					$iStart = -1
					For $i = 1 To $iLastRow
						Switch $i
							Case 1
								If $i <> $iLastRow Then
									If ($avArray[$i][$iCol1] <> $avArray[2][$iCol1]) Or ($avArray[$i][$iCol2] <> $avArray[2][$iCol2]) Or ($avArray[$i][$iCol3] <> $avArray[2][$iCol3]) Then
										$iStart = 2
										$iEnd = $iStart
									Else
										$iStart = 1
										$iEnd = $iStart
									EndIf
								EndIf
							Case $iLastRow
								$iEnd = $iLastRow
								If $iStart <> $iEnd Then
									_ArraySort($avArray, 0, $iStart, $iEnd, $iCol4)
								EndIf
							Case Else
								If ($avArray[$i][$iCol1] <> $avArray[$i + 1][$iCol1]) Or ($avArray[$i][$iCol2] <> $avArray[$i + 1][$iCol2]) Or ($avArray[$i][$iCol3] <> $avArray[$i + 1][$iCol3]) Then
									$iEnd = $i
									If $iStart <> $iEnd Then
										_ArraySort($avArray, 0, $iStart, $iEnd, $iCol4)
									EndIf
									$iStart = $i + 1
									$iEnd = $iStart
								Else
									$iEnd = $i
								EndIf
						EndSwitch
					Next
				EndIf
			EndIf
		EndIf
	EndIf
EndFunc   ;==>_ArraySortEx

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
	Local $aString[22] = [21, '0409 0809 0c09 1009 1409 1809 1c09 2009 2409 2809 2c09 3009 3409', '0404 0804 0c04 1004 0406', '0406', '0413 0813', '0425', _
			'040b', '040c 080c 0c0c 100c 140c 180c', '0407 0807 0c07 1007 1407', '408', '040e', _
			'0410 0810', '0411', '0414 0814', '0415', '0816', '0416', _
			'0418', '0419', '081a 0c1a', '040a 080a 0c0a 100a 140a 180a 1c0a 200a 240a 280a 2c0a 300a 340a 380a 3c0a 400a 440a 480a 4c0a 500a', '041d 081d']

	Local $aLanguage[22] = [21, 'English', 'Chinese', 'Danish', 'Dutch', 'Estonian', 'Finnish', 'French', 'German', 'Greek', 'Hungarian', _
			'Italian', 'Japanese', 'Norwegian', 'Polish', 'Portuguese', 'Brazilian Portuguese', 'Romanian', 'Russian', 'Serbian', 'Spanish', 'Swedish']
	For $i = 1 To $aString[0]
		If StringInStr($aString[$i], @OSLang) Then
			Return $aLanguage[$i]
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

Func __IniReadSection($sFilePath, $sSection) ; Modified From: http://www.autoitscript.com/forum/topic/32004-iniex-functions-exceed-32kb-limit/
	#cs
		Description: Read A Section From A Standard Format INI File.
		Returns: $Array[?] - Array Contains Unlimited Number Of Items.
		[0][0] - Number Of Rows [3]

		[A][0] - Key [Example]
		[A][1] - Value [Test]
	#ce
	Local $iSize = FileGetSize($sFilePath) / 1024
	If $iSize < 32 Then
		Local $aRead = IniReadSection($sFilePath, $sSection)
		If @error Then
			Return SetError(@error, 0, "")
		EndIf
		If IsArray($aRead) = 0 Then
			Return SetError(-2, 0, "")
		EndIf
		Return $aRead
	EndIf

	Local $aSplitKeyValue
	Local $hFileRead = FileRead($sFilePath)
	Local $aData = StringRegExp($hFileRead, "(?is)(?:^|\v)(?!;|#)\h*\[\h*\Q" & $sSection & "\E\h*\]\h*\v+(.*?)(?:\z|\v\h*\[)", 1)
	If @error Then
		Return SetError(1, 0, "")
	EndIf

	Local $aLines = StringSplit(StringRegExpReplace($aData[0], @CRLF & "|" & @CR & "|" & @LF, @LF), @LF)
	Local $sLeft, $iAdded = 0, $aSectionReturn[$aLines[0] + 1][2]
	For $A = 1 To $aLines[0]
		$sLeft = StringLeft(StringStripWS($aLines[$A], 8), 1)
		If $sLeft == ";" Or $sLeft == "#" Then
			ContinueLoop
		EndIf

		$aSplitKeyValue = StringSplit($aLines[$A], "=")
		If $aSplitKeyValue[0] > 1 Then
			$iAdded += 1
			$aSectionReturn[$iAdded][0] = $aSplitKeyValue[1]
			For $B = 2 To $aSplitKeyValue[0]
				If $B > 2 Then
					$aSectionReturn[$iAdded][1] &= "="
				EndIf
				$aSectionReturn[$iAdded][1] &= $aSplitKeyValue[$B]
			Next
		EndIf
	Next
	If $iAdded = 0 Then
		Return SetError(1, 0, "")
	EndIf
	ReDim $aSectionReturn[$iAdded + 1][2]
	$aSectionReturn[0][0] = $iAdded
	Return $aSectionReturn
EndFunc   ;==>__IniReadSection

Func __IniReadSectionNamesEx($sFilePath) ; Modified From: http://www.autoitscript.com/forum/topic/32004-iniex-functions-exceed-32kb-limit/
	#cs
		Description: Read Section Names From A Standard Format INI File.
		Returns: $Array[?] - Array Contains Unlimited Number Of Items.
		[0] - Number Of Sections [3]
		[A] - Section Name [Example]
	#ce
	Local $aSections
	If FileExists($sFilePath) = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	If FileGetSize($sFilePath) / 1024 <= 31 Then
		$aSections = IniReadSectionNames($sFilePath)
		If @error Or IsArray($aSections) = 0 Then
			Return SetError(1, 0, 0)
		EndIf
		Return $aSections
	EndIf
	Local $hRead = FileRead($sFilePath)
	Local $aReadSections = StringRegExp($hRead, "(?m)(?:^|\v)\h*\[\h*(.*?)\h*\]", 3)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Local $iNumberSections = UBound($aReadSections)
	Local $aReturnSections[$iNumberSections + 1] = [$iNumberSections]
	For $A = 0 To $iNumberSections - 1
		$aReturnSections[$A + 1] = $aReadSections[$A]
	Next
	Return $aReturnSections
EndFunc   ;==>__IniReadSectionNamesEx

Func __IniWriteEx($sFilePath, $sSection, $sKey = "", $sValue = "")
	#cs
		Description: Write A Key Or A Section From A Standard Format INI File With Unicode Support.
		Returns: 1
	#ce
	Local $hWrite

	If FileGetEncoding($sFilePath) <> 32 Then
		Local $hFileRead = FileRead($sFilePath)
		If @error And FileExists($sFilePath) Then
			Return SetError(1, 0, 0)
		EndIf
		Local $hFileOpen = FileOpen($sFilePath, 2 + 8 + 32)
		If $hFileOpen = -1 Then
			Return SetError(1, 0, 0)
		EndIf
		$hWrite = FileWrite($hFileOpen, $hFileRead)
		FileClose($hFileOpen)
		If $hWrite = 0 Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf

	If $sKey = "" Then ; Write Section.
		$hWrite = IniWriteSection($sFilePath, $sSection, $sValue)
		FileWriteLine($sFilePath, "") ; Add Empty Line.
	Else ; Write Key.
		$hWrite = IniWrite($sFilePath, $sSection, $sKey, $sValue)
	EndIf
	If $hWrite = 0 Then
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
		GUICtrlSetData($hEdit, $sString & GUICtrlRead($hEdit))
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

Func __Locale_DayName($WDay, $Abbrev = False, $LCID = "")
	; ==========================================================================================
	; Autor:        Großvater (www.autoit.de) http://www.autoitscript.com/forum/topic/136945-the-name-of-any-day-by-date-multilingual/#entry958589
	; Parameter:
	; $WDay     -   Nummer des Wochentages (1 - 7) (!!! 1 ist Montag (s.u.) !!!)
	; $Abbrev   -   abgekürzten Namen liefern:
	;               |0 : nein
	;               |1 : ja
	; $LCID     -   Sprachbezeichner gem. Abschnitt "@OSLang values" im Anhang der Hilfedatei
	;               als 16-bittiger Hexwert: 0xnnnn (z.b. 0x0407 für Deutschland).
	;               Bei fehlender Angabe wird die Defaulteinstellung  des Benutzers verwendet.
	; Anmerkungen:
	; Zu meinem Erstaunen hat MS in WinNLS.h folgende Konstanten definiert:
	;   #define LOCALE_SDAYNAME1              0x0000002A   // long name for Monday
	;   ...
	;   #define LOCALE_SDAYNAME7              0x00000030   // long name for Sunday
	; Anders als beim Macro @WDAY gilt deshalb der Montag als Tag 1 und der Sonntag
	; als Tag 7. Der passende Wert lässt sich per Aufruf der UDF-Funktion
	;       _DateToDayOfWeekISO()
	; ermitteln.
	; ==========================================================================================
	Local Const $LOCALE_USER_DEFAULT = 0x0400
	Local Const $LOCALE_SDAYNAME = 0x29
	Local Const $LOCALE_SABBREVDAYNAME = 0x30
	If $LCID = "" Then $LCID = $LOCALE_USER_DEFAULT
	Local $LCType = $LOCALE_SDAYNAME
	If $Abbrev Then $LCType = $LOCALE_SABBREVDAYNAME
	If $LCID = "" Then $LCID = $LOCALE_USER_DEFAULT
	If Not StringIsInt($WDay) Or $WDay < 1 Or $WDay > 7 Then Return False
	Local $aResult = DllCall("Kernel32.dll", "Int", "GetLocaleInfoW", "UInt", $LCID, "UInt", $LCType + $WDay, "WStr", "", "Int", 80)
	If @error Or $aResult[0] = 0 Then Return False
	Return $aResult[3]
EndFunc   ;==>__Locale_DayName

Func __Locale_MonthName($Month, $Abbrev = False, $LCID = "")
	; ==========================================================================================
	; Author:        Großvater (www.autoit.de) http://www.autoitscript.com/forum/topic/136945-the-name-of-any-day-by-date-multilingual/#entry958589
	; Parameter:
	; $Month    -   Nummer des Monats (1 - 12)
	; $Abbrev   -   abgekürzten Namen liefern:
	;               |0 : nein
	;               |1 : ja
	; $LCID     -   Sprachbezeichner gem. Abschnitt "@OSLang values" im Anhang der Hilfedatei
	;               als 16-bittiger Hexwert: 0xnnnn (z.b. 0x0407 für Deutschland).
	;               Bei fehlender Angabe wird die Defaulteinstellung  des Benutzers verwendet.
	; ==========================================================================================
	Local Const $LOCALE_USER_DEFAULT = 0x0400
	Local Const $LOCALE_SMONTHNAME = 0x37
	Local Const $LOCALE_SABBREVMONTHNAME = 0x43
	Local $LCType = $LOCALE_SMONTHNAME
	If $Abbrev Then $LCType = $LOCALE_SABBREVMONTHNAME
	If $LCID = "" Then $LCID = $LOCALE_USER_DEFAULT
	If Not StringIsInt($Month) Or $Month < 1 Or $Month > 12 Then Return False
	Local $aResult = DllCall("Kernel32.dll", "Int", "GetLocaleInfoW", "UInt", $LCID, "UInt", $LCType + $Month, "WStr", "", "Int", 80)
	If @error Or $aResult[0] = 0 Then Return False
	Return _StringProper($aResult[3])
EndFunc   ;==>__Locale_MonthName

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

Func __ShellExecuteOnTop($sFilePath, $sText)
	#cs
		Description: Open A File With Default Program And Set It On Top.
		Returns: Nothing
	#ce
	ShellExecute($sFilePath)
	Sleep(300)
	WinSetOnTop($sText, "", 1)
EndFunc   ;==>__ShellExecuteOnTop

Func __ShowPassword($iControlID)
	#cs
		Description: Show/Hide Password Of An Input Password Field.
		Returns: Input State
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
