#include-once

; #AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
; #INDEX# =======================================================================================================================
; Title .........: _ShellAll
; AutoIt Version : v3.2.12.1 or higher
; Language ......: English
; Description ...: Create an entry in the shell contextmenu when selecting a file and folder, includes the program icon as well.
; Note ..........:
; Author(s) .....: guinness
; Remarks .......: Special thanks to KaFu for EnumRegKeys2Array() which I used as inspiration for enumerating the Registry Keys.
; ===============================================================================================================================

; #INCLUDES# =========================================================================================================
; None

; #GLOBAL VARIABLES# =================================================================================================
; None

; #CURRENT# =====================================================================================================================
; _ShellAll_Install: Creates an entry in the 'All Users/Current Users' registry for displaying a program entry in the shell contextmenu, but only displays when selecting a file and folder.
; _ShellAll_Uninstall: Deletes an entry in the 'All Users/Current Users' registry for displaying a program entry in the shell contextmenu.
; ===============================================================================================================================

; #INTERNAL_USE_ONLY#============================================================================================================
; __ShellAll_RegistryGet ......; Retrieve an array of registry entries for a specific key.
; ===============================================================================================================================

; #FUNCTION# =========================================================================================================
; Name...........: _ShellAll_Install()
; Description ...: Creates an entry in the 'All Users/Current Users' registry for displaying a program entry in the shell contextmenu, but only displays when selecting a file and folder.
; Syntax.........: _ShellAll_Install($sText, [$sName = @ScriptName, [$sFilePath = @ScriptFullPath, [$sIconPath = @ScriptFullPath, [$iIcon = 0, [$iAllUsers = 0, [$iExtended = 0]]]]]])
; Parameters ....: $sText - Text to be shown in the contextmenu.
;                  $sName - [Optional] Name of the program. [Default = Script name]
;                  $sFilePath - [Optional] Location of the program executable. [Default = Full script location]
;                  $sIconPath - [Optional] Location of the icon e.g. program executable or dll file. [Default = Full script location]
;                  $$iIcon - [Optional] Index of icon to be used. [Default = 0 - Main icon]
;                  $iAllUsers - [Optional] Add to Current Users (0) or All Users (1) [Default = 0 - Current user]
;                  $iExtended - [Optional] Show in the Extended contextmenu using Shift + Right click. [Default = 0 - Show in main contextmeu.]
; Requirement(s).: v3.2.12.1 or higher
; Return values .: Success - RegWrite() Return code.
;                  Failure - none
; Author ........: guinness
; Example........; Yes
;=====================================================================================================================
Func _ShellAll_Install($sText, $sName = @ScriptName, $sFilePath = @ScriptFullPath, $sIconPath = @ScriptFullPath, $iIcon = 0, $iAllUsers = 0, $iExtended = 0)
	Local $aArray[3] = [2, "*", "Directory"], $i64Bit = ""

	If @OSArch = "X64" Then
		$i64Bit = "64"
	EndIf
	For $A = 1 To $aArray[0]
		If $iAllUsers Then
			$aArray[$A] = "HKEY_LOCAL_MACHINE" & $i64Bit & "\SOFTWARE\Classes\" & $aArray[$A] & "\shell\"
		Else
			$aArray[$A] = "HKEY_CURRENT_USER" & $i64Bit & "\SOFTWARE\Classes\" & $aArray[$A] & "\shell\"
		EndIf
	Next

	$sName = StringLower(StringReplace($sName, ".exe", ""))
	If $sName = "" Or $sFilePath = "" Then
		Return SetError(1, 0, 0)
	EndIf

	_ShellAll_Uninstall($sName, $iAllUsers)

	For $A = 1 To $aArray[0]
		RegWrite($aArray[$A] & $sName, "", "REG_SZ", $sText)
		RegWrite($aArray[$A] & $sName, "Icon", "REG_EXPAND_SZ", $sIconPath & "," & $iIcon)
		RegWrite($aArray[$A] & $sName & "\command", "", "REG_SZ", '"' & $sFilePath & '" "%1"')
		If $iExtended Then
			RegWrite($aArray[$A], "Extended", "REG_SZ", "")
		EndIf
	Next
	Return SetError(@error, 0, @error)
EndFunc   ;==>_ShellAll_Install

; #FUNCTION# =========================================================================================================
; Name...........: _ShellAll_Uninstall()
; Description ...: Deletes an entry in the 'All Users/Current Users' registry for displaying a program entry in the shell contextmenu.
; Syntax.........: _ShellAll_Uninstall([$sName = @ScriptName, [$iAllUsers = 0]])
; Parameters ....: $sName - [Optional] Name of the Program [Default = Script name.]
;                  $iAllUsers - [Optional] Was it added to Current Users (0) or All Users (1). [Default = 0 - Current user]
; Requirement(s).: v3.2.12.1 or higher
; Return values .: Success - Returns 2D Array of registry entries.
;                  Failure - Returns 0 and sets @error to 1.
; Author ........: guinness
; Example........; Yes
;=====================================================================================================================
Func _ShellAll_Uninstall($sName = @ScriptName, $iAllUsers = 0)
	Local $aArray[3] = [2, "*", "Directory"], $aFinal[1][5] = [[0, 5]], $aReturn, $i64Bit = "", $sDelete

	If @OSArch = "X64" Then
		$i64Bit = "64"
	EndIf
	For $A = 1 To $aArray[0]
		If $iAllUsers Then
			$aArray[$A] = "HKEY_LOCAL_MACHINE" & $i64Bit & "\SOFTWARE\Classes\" & $aArray[$A] & "\shell\"
		Else
			$aArray[$A] = "HKEY_CURRENT_USER" & $i64Bit & "\SOFTWARE\Classes\" & $aArray[$A] & "\shell\"
		EndIf
	Next

	$sName = StringLower(StringReplace($sName, ".exe", ""))
	If $sName = "" Then
		Return SetError(1, 0, 0)
	EndIf

	For $A = 1 To $aArray[0]
		$aReturn = __ShellAll_RegistryGet($aArray[$A])

		If $aReturn[0][0] > 0 Then
			For $B = 1 To $aReturn[0][0]
				If $aReturn[$B][0] = $sName And $sDelete <> $aReturn[$B][1] Then
					$sDelete = $aReturn[$B][1]
					RegDelete($sDelete)
				EndIf
			Next

			ReDim $aFinal[$aFinal[0][0] + $aReturn[0][0] + 1][$aReturn[0][1]]
			For $C = 1 To $aReturn[0][0]
				$aFinal[0][0] += 1
				For $D = 0 To $aReturn[0][1] - 1
					$aFinal[$aFinal[0][0]][$D] = $aReturn[$C][$D]
				Next
			Next
			$aFinal[0][1] = $aReturn[0][1]
		EndIf
	Next
	Return $aFinal
EndFunc   ;==>_ShellAll_Uninstall

; #INTERNAL_USE_ONLY#============================================================================================================
Func __ShellAll_RegistryGet($sRegistryKey)
	Local $aArray[1][5] = [[0, 5]], $iCount_1 = 0, $iCount_2 = 0, $iDimension, $iError = 0, $sRegistryKey_All, $sRegistryKey_Main, $sRegistryKey_Name, $sRegistryKey_Value

	While 1
		If $iError Then
			ExitLoop
		EndIf
		$sRegistryKey_Main = RegEnumKey($sRegistryKey, $iCount_1 + 1)
		If @error Then
			$sRegistryKey_All = $sRegistryKey
			$iError = 1
		Else
			$sRegistryKey_All = $sRegistryKey & $sRegistryKey_Main
		EndIf

		$iCount_2 = 0
		While 1
			$sRegistryKey_Name = RegEnumVal($sRegistryKey_All, $iCount_2 + 1)
			If @error Then
				ExitLoop
			EndIf

			If ($aArray[0][0] + 1) >= $iDimension Then
				$iDimension = ($aArray[0][0] + 1) * 2
				ReDim $aArray[$iDimension][$aArray[0][1]]
			EndIf

			$sRegistryKey_Value = RegRead($sRegistryKey_All, $sRegistryKey_Name)
			$aArray[$aArray[0][0] + 1][0] = $sRegistryKey_Main
			$aArray[$aArray[0][0] + 1][1] = $sRegistryKey_All
			$aArray[$aArray[0][0] + 1][2] = $sRegistryKey & $sRegistryKey_Main & "\" & $sRegistryKey_Name
			$aArray[$aArray[0][0] + 1][3] = $sRegistryKey_Name
			$aArray[$aArray[0][0] + 1][4] = $sRegistryKey_Value
			$aArray[0][0] += 1
			$iCount_2 += 1
		WEnd
		$iCount_1 += 1
	WEnd
	ReDim $aArray[$aArray[0][0] + 1][$aArray[0][1]]
	Return $aArray
EndFunc   ;==>__ShellAll_RegistryGet
