
; Various funtions collected for DropIt

#include-once
#include <Array.au3>
#include <Crypt.au3>
#include <GUIConstantsEx.au3>
#include <String.au3>
#include <WinAPI.au3>
#include <WinAPIProc.au3>

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
		Returns: Language [English]
	#ce
	Local $aLanguage[20][2] = [ _
			[19, 'English'], _
			['BrazilianPortuguese', '0416 0816'], _
			['Danish', '0406'], _
			['Dutch', '0413 0813'], _
			['French', '040C 080C 0C0C 100C 140C 180C'], _
			['German', '0407 0807 0C07 1007 1407'], _
			['Greek', '0408'], _
			['Hungarian', '040E'], _
			['Indonesian', '0421'], _
			['Italian', '0410 0810'], _
			['Japanese', '0411'], _
			['Polish', '0415'], _
			['Romanian', '0418'], _
			['Russian', '0419 0444 046D 0485'], _
			['Serbian', '081A 0C1A 181A 1C1A 241A 281A 2C1A 301A'], _
			['SimplifiedChinese', '0004 0804 0C04 1004 1404'], _
			['Spanish', '040A 080A 0C0A 100A 140A 180A 1C0A 200A 240A 280A 2C0A 300A 340A 380A 3C0A 400A 440A 480A 4C0A 500A 540A'], _
			['Swedish', '041D 081D 083B 143B 1C3B'], _
			['TraditionalChinese', '0404 7C04'], _
			['Vietnamese', '042A']]
	For $A = 1 To $aLanguage[0][0]
		If StringInStr($aLanguage[$A][1], @OSLang) Then
			$aLanguage[0][1] = $aLanguage[$A][0]
			ExitLoop
		EndIf
	Next
	Return $aLanguage[0][1]
EndFunc   ;==>__GetOSLanguage

Func __GetSelectionPointers($hEdit) ; Used In __InsertText()
	Local $aReturn[2] = [0, 0]
	Local $aSelected = GUICtrlRecvMsg($hEdit, 0x00B0) ; $EM_GETSEL.
	If IsArray($aSelected) Then
		$aReturn[0] = $aSelected[0]
		$aReturn[1] = $aSelected[1]
	EndIf
	Return $aReturn
EndFunc   ;==>__GetSelectionPointers

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
	Local $aData = StringRegExp($hFileRead, "(?is)(?:^|\v)(?!;|#)\h*\[\h*\Q" & $sSection & "\E\h*\]\h*\r?\n?(.*?)(?:\z|\v\h*\[)", 1) ; "\r?\n?" Instead Of "\v+" To Correctly Work.
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
	Local $hWrite, $hFileRead, $hFileOpen

	If FileGetEncoding($sFilePath) <> 32 Then
		$hFileRead = FileRead($sFilePath)
		If @error And FileExists($sFilePath) Then
			Return SetError(1, 0, 0)
		EndIf
		$hFileOpen = FileOpen($sFilePath, 2 + 8 + 32)
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
		$hFileRead = StringReplace(FileRead($sFilePath), @CRLF & @CRLF & @CRLF, @CRLF & @CRLF) ; Remove Double Empty Lines.
		$hFileOpen = FileOpen($sFilePath, 2 + 8 + 32)
		If $hFileOpen = -1 Then
			Return SetError(1, 0, 0)
		EndIf
		FileWrite($hFileOpen, $hFileRead)
		FileClose($hFileOpen)
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
	Local $aSelected = __GetSelectionPointers($hEdit)
	GUICtrlSetData($hEdit, StringLeft(GUICtrlRead($hEdit), $aSelected[0]) & $sString & StringTrimLeft(GUICtrlRead($hEdit), $aSelected[1]))
	Local $iCursorPlace = StringLen(StringLeft(GUICtrlRead($hEdit), $aSelected[0]) & $sString)
	GUICtrlSendMsg($hEdit, 0x00B1, $iCursorPlace, $iCursorPlace) ; $EM_SETSEL.
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

Func __ShellExecuteOnTop($sFilePath, $sWait = 0) ; Modified From: http://www.autoitscript.com/forum/topic/157528-open-a-file-and-set-the-window-always-on-top/
	#cs
		Description: Open A File With Default Program And Set It On Top.
		Returns: Nothing
	#ce
	Local $iPID, $aData, $hWnd, $hWndDropIt = WinGetHandle("[ACTIVE]"), $iCounter, $aNewWinList, $aOldWinList = WinList()

	$iPID = ShellExecute($sFilePath)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	If $iPID <> -1 Then
		$iCounter = 0
		Do
			$iCounter += 1
			Sleep(50)
			$aData = _WinAPI_EnumProcessWindows($iPID, 1)
		Until IsArray($aData) Or $iCounter = 6
		If IsArray($aData) = 0 Then
			$iPID = -1
		ElseIf $aData[0][0] = 1 Then
			$hWnd = $aData[1][0]
		EndIf
	EndIf
	If $iPID = -1 Then
		$iCounter = 0
		Do
			$iCounter += 1
			Sleep(50)
			$aNewWinList = WinList()
		Until $aNewWinList[0][0] <> $aOldWinList[0][0] Or $iCounter = 6
		If $aNewWinList[0][0] = $aOldWinList[0][0] Then
			Return SetError(1, 0, 0)
		EndIf
		Sleep(100)
		$hWnd = WinGetHandle("[ACTIVE]")
	EndIf

	If $hWnd <> $hWndDropIt And $hWnd Then
		WinSetOnTop($hWnd, "", 1)
		If $sWait Then
			While WinExists($hWnd)
				Sleep(100)
			WEnd
		EndIf
	EndIf
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

Func __StringEncrypt($fEncrypt, $sData, $sPassword)
	_Crypt_Startup() ; Start the Crypt library.
	Local $sReturn = ''
	If $fEncrypt Then ; If the flag is set to True then encrypt, otherwise decrypt.
		$sReturn = _Crypt_EncryptData($sData, $sPassword, $CALG_RC4)
	Else
		$sReturn = BinaryToString(_Crypt_DecryptData($sData, $sPassword, $CALG_RC4))
	EndIf
	_Crypt_Shutdown() ; Shutdown the Crypt library.
	Return $sReturn
EndFunc   ;==>__StringEncrypt

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
