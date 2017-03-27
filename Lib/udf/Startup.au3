#include-once

; #AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
; #INDEX# =======================================================================================================================
; Title .........: _Startup
; AutoIt Version : v3.2.12.1 or higher
; Language ......: English
; Description ...: Create Startup entries in the startup folder or registry. The registry entries can be Run all the time (Run registry entry) or only once (RunOnce registry entry.)
; Note ..........:
; Author(s) .....: guinness
; Remarks .......: Special thanks to KaFu for EnumRegKeys2Array() which I used as inspiration for enumerating the Registry Keys.
; ===============================================================================================================================

; #INCLUDES# =========================================================================================================
; None

; #GLOBAL VARIABLES# =================================================================================================
; None

; #CURRENT# =====================================================================================================================
; _StartupFolder_Install: Creates a Shortcut in the 'All Users/Current Users' startup folder.
; _StartupFolder_Uninstall: Deletes the Shortcut in the 'All Users/Current Users' startup folder.
; _StartupRegistry_Install: Creates an entry in the 'All Users/Current Users' registry.
; _StartupRegistry_Uninstall: Deletes the entry in the 'All Users/Current Users' registry.
; ===============================================================================================================================

; #INTERNAL_USE_ONLY#============================================================================================================
; None
; ===============================================================================================================================

; #FUNCTION# =========================================================================================================
; Name...........: _StartupFolder_Install()
; Description ...: Creates a Shortcut in the 'All Users/Current Users' startup folder.
; Syntax.........: _StartupFolder_Install([$sName = @ScriptName, [$sFilePath = @ScriptFullPath, [$iAllUsers = 0]]])
; Parameters ....: $sName - [Optional] Name of the program. [Default = Script name.]
;                  $sFilePath - [Optional] Location of the program executable. [Default = Full script location.]
;                  $iAllUsers - [Optional] Add to Current Users (0) or All Users (1). [Default = 0 - Current user.]
; Requirement(s).: v3.2.12.1 or higher
; Return values .: Success - FileCreateShortcut() Return code.
;                  Failure - Returns 0 & sets @error = 1
; Author ........: guinness
; Example........; Yes
;=====================================================================================================================
Func _StartupFolder_Install($sName = @ScriptName, $sFilePath = @ScriptFullPath, $iAllUsers = 0)
	Local $sStartup = ""

	$sName = StringLower(StringReplace($sName, ".exe", ""))
	If $sName = "" Or $sFilePath = "" Then
		Return SetError(1, 0, 0)
	EndIf

	_StartupFolder_Uninstall($sName, $sFilePath, $iAllUsers) ; Deletes The Shortcut In The 'All Users/Current Users' startup folder.

	If $iAllUsers Then
		$sStartup = @StartupCommonDir & "\"
	Else
		$sStartup = @StartupDir & "\"
	EndIf
	Return FileCreateShortcut($sFilePath, $sStartup & $sName & ".lnk", $sStartup)
EndFunc   ;==>_StartupFolder_Install

; #FUNCTION# =========================================================================================================
; Name...........: _StartupFolder_Uninstall()
; Description ...: Deletes the Shortcut in the 'All Users/Current Users' startup folder.
; Syntax.........: _StartupFolder_Uninstall([$sName = @ScriptName, [$sFilePath = @ScriptFullPath, [$iAllUsers = 0]]])
; Parameters ....: $sName - [Optional] Name of the program. [Default = Script name.]
;                  $sFilePath - [Optional] Location of the program executable. [Default = Full script location.]
;                  $iAllUsers - [Optional] Was it Added to Current Users (0) or All Users (1). [Default = 0 - Current user]
; Requirement(s).: v3.2.12.1 or higher
; Return values .: Success - FileClose() Return code.
;                  Failure - Returns 0 & sets @error = 1
; Author ........: guinness
; Example........; Yes
;=====================================================================================================================
Func _StartupFolder_Uninstall($sName = @ScriptName, $sFilePath = @ScriptFullPath, $iAllUsers = 0)
	Local $aFileGetShortcut, $hSearch, $iStringLen = 0, $sFile, $sStartup = ""

	$sName = StringLower(StringReplace($sName, ".exe", ""))
	If $sName = "" Or $sFilePath = "" Then
		Return SetError(1, 0, 0)
	EndIf
	$iStringLen = StringLen($sName)

	If $iAllUsers Then
		$sStartup = @StartupCommonDir & "\"
	Else
		$sStartup = @StartupDir & "\"
	EndIf

	$hSearch = FileFindFirstFile($sStartup & "*.lnk")
	If $hSearch = -1 Then
		Return SetError(2, 0, 0)
	EndIf
	While 1
		$sFile = FileFindNextFile($hSearch)
		If @error Then
			ExitLoop
		EndIf
		If StringLeft($sFile, $iStringLen) = $sName Then
			$aFileGetShortcut = FileGetShortcut($sStartup & $sFile)
			If @error Then
				ContinueLoop
			EndIf
			If $aFileGetShortcut[0] = $sFilePath Then
				FileDelete($sStartup & $sFile)
			EndIf
		EndIf
	WEnd
	Return FileClose($hSearch)
EndFunc   ;==>_StartupFolder_Uninstall

; #FUNCTION# =========================================================================================================
; Name...........: _StartupRegistry_Install()
; Description ...: Creates an entry in the 'All Users/Current Users' registry.
; Syntax.........: _StartupRegistry_Install([$sName = @ScriptName, [$sFilePath = @ScriptFullPath, [$iAllUsers = 0, [$iRunOnce = 0]]]])
; Parameters ....: $sName - [Optional] Name of the program. [Default = Script name]
;                  $sFilePath - [Optional] Location of the program executable. [Default = Full script location]
;                  $iAllUsers - [Optional] Add to Current Users (0) or All Users (1). [Default = 0 - Current user]
;                  $iRunOnce - [Optional] Always Run at System Startup (0) or Run only once (1)l [Default = 0 - Always run at system startup.]
; Requirement(s).: v3.2.12.1 or higher
; Return values .: Success - RegWrite() Return code.
;                  Failure - Returns 0 & sets @error = 1
; Author ........: guinness
; Example........; Yes
;=====================================================================================================================
Func _StartupRegistry_Install($sName = @ScriptName, $sFilePath = @ScriptFullPath, $iAllUsers = 0, $iRunOnce = 0)
	Local $i64Bit = "", $sRegistryKey, $sRunOnce = ""

	_StartupRegistry_Uninstall($sName, $sFilePath, $iAllUsers, $iRunOnce) ; Deletes The Entry In The 'All Users/Current Users' Registry.

	$sName = StringLower(StringReplace($sName, ".exe", ""))
	If $sName = "" Or $sFilePath = "" Then
		Return SetError(1, 0, 0)
	EndIf

	If $iRunOnce Then
		$sRunOnce = "Once"
	EndIf

	If @OSArch = "X64" Then
		$i64Bit = "64"
	EndIf
	If $iAllUsers Then
		$sRegistryKey = "HKEY_LOCAL_MACHINE" & $i64Bit & "\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" & $sRunOnce & "\"
	Else
		$sRegistryKey = "HKEY_CURRENT_USER" & $i64Bit & "\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" & $sRunOnce & "\"
	EndIf
	Return RegWrite($sRegistryKey, $sName, "REG_SZ", $sFilePath)
EndFunc   ;==>_StartupRegistry_Install

; #FUNCTION# =========================================================================================================
; Name...........: _StartupRegistry_Uninstall()
; Description ...: Deletes the entry in the 'All Users/Current Users' registry.
; Syntax.........: _StartupRegistry_Uninstall([$sName = @ScriptName, [$sFilePath = @ScriptFullPath, [$iAllUsers = 0, [$iRunOnce = 0]]]])
; Parameters ....: $sName - [Optional] Name of the program. [Default = Script name.]
;                  $sFilePath - [Optional] Location of the program executable. [Default = Full script location]
;                  $iAllUsers - [Optional] Was it Added to Current Users (0) or All Users (1). [Default = 0 - Current user.]
;                  $iRunOnce - [Optional] Was it Always Run at System Startup (0) or Run only once (1). [Default = 0 - Always run at system startup.]
; Requirement(s).: v3.2.12.1 or higher
; Return values .: Success - Returns 1
;                  Failure - Returns 0 & sets @error = 1
; Author ........: guinness
; Example........; Yes
;=====================================================================================================================
Func _StartupRegistry_Uninstall($sName = @ScriptName, $sFilePath = @ScriptFullPath, $iAllUsers = 0, $iRunOnce = 0)
	Local $i64Bit = "", $iCount = 1, $sRegistryKey, $sRegistryName, $sRegistryValue, $sRunOnce

	$sName = StringLower(StringReplace($sName, ".exe", ""))
	If $sName = "" Or $sFilePath = "" Then
		Return SetError(1, 0, 0)
	EndIf

	If $iRunOnce Then
		$sRunOnce = "Once"
	EndIf

	If @OSArch = "X64" Then
		$i64Bit = "64"
	EndIf
	If $iAllUsers Then
		$sRegistryKey = "HKEY_LOCAL_MACHINE" & $i64Bit & "\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" & $sRunOnce & "\"
	Else
		$sRegistryKey = "HKEY_CURRENT_USER" & $i64Bit & "\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" & $sRunOnce & "\"
	EndIf

	While 1
		$sRegistryName = RegEnumVal($sRegistryKey, $iCount)
		If @error Then
			ExitLoop
		EndIf

		$sRegistryValue = RegRead($sRegistryKey, $sRegistryName)
		If ($sRegistryName = $sName) And ($sRegistryValue = $sFilePath) Then
			RegDelete($sRegistryKey, $sName)
		EndIf
		$iCount += 1
	WEnd
	Return 1
EndFunc   ;==>_StartupRegistry_Uninstall
