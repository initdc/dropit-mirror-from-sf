
; Archive funtions of DropIt

#include-once
#include <DropIt_General.au3>
#include <DropIt_Global.au3>

Func __Duplicate_Alert($dItem)
	Local $dGUI, $dButtonOverwrite, $dButtonRename, $dButtonSkip, $dCheckForAll, $dValue

	$dGUI = GUICreate(__GetLang('POSITIONPROCESS_DUPLICATE_0', 'Item Already Exists'), 360, 135, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($G_Global_SortingGUI))
	GUICtrlCreateGraphic(0, 0, 360, 68)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlSetColor(-1, 0xffffff)

	GUICtrlCreateLabel(__GetLang('POSITIONPROCESS_DUPLICATE_1', 'This item already exists in destination folder:'), 14, 12, 328, 18)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlCreateLabel($dItem, 16, 12 + 18, 324, 36)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlSetFont(-1, -1, 800)

	$dButtonOverwrite = GUICtrlCreateButton(__GetLang('DUPLICATE_MODE_0', 'Overwrite'), 180 - 65 - 84, 76, 88, 25)
	$dButtonRename = GUICtrlCreateButton(__GetLang('DUPLICATE_MODE_2', 'Rename'), 180 - 42, 76, 88, 25)
	$dButtonSkip = GUICtrlCreateButton(__GetLang('DUPLICATE_MODE_6', 'Skip'), 180 + 65, 76, 88, 25)
	GUICtrlSetState($dButtonSkip, $GUI_DEFBUTTON)
	$dCheckForAll = GUICtrlCreateCheckbox(__GetLang('POSITIONPROCESS_DUPLICATE_2', 'Apply to all duplicates of this drop'), 14, 110, 328, 20)
	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $dButtonSkip
				$dValue = "Skip"
				ExitLoop

			Case $dButtonOverwrite
				$dValue = "Overwrite1"
				ExitLoop

			Case $dButtonRename
				$dValue = "Rename1"
				ExitLoop

		EndSwitch
	WEnd
	If GUICtrlRead($dCheckForAll) = 1 Then
		$G_Global_DuplicateMode = $dValue
	EndIf
	GUIDelete($dGUI)

	Return $dValue
EndFunc   ;==>__Duplicate_Alert

Func __Duplicate_Process($dFilePath, $dProfile, $dDestination = -1, $dFileName = -1)
	Local $dINI, $dIsDirectory, $dDupMode = "Skip"

	If _WinAPI_PathIsDirectory($dFilePath) Then
		$dIsDirectory = 1
	EndIf
	If $dDestination = -1 Then ; New Output Creation.
		$dDestination = __GetParentFolder($dFilePath)
		$dFileName = __GetFileName($dFilePath)
	EndIf

	If __Is("AutoDup", -1, "False", $dProfile) Then
		$dINI = __IsProfile($dProfile, 1) ; Get Profile Path Of Selected Profile.
		If IniRead($dINI, "General", "AutoDup", "Default") == "Default" Then
			$dINI = __IsSettingsFile() ; Get Default Settings INI File.
		EndIf
		$dDupMode = IniRead($dINI, "General", "DupMode", "Skip")
	Else
		If $G_Global_DuplicateMode <> "" Then
			$dDupMode = $G_Global_DuplicateMode
		Else
			__ExpandEventMode(0) ; Disable The Abort Button.
			$dDupMode = __Duplicate_Alert($dFileName)
			__ExpandEventMode(1) ; Enable The Abort Button.
		EndIf
	EndIf
	If StringInStr($dDupMode, 'Skip') Or (StringInStr($dDupMode, 'Overwrite2') And __FileCompareDate($dFilePath, $dDestination & "\" & $dFileName) <> 1) Or (StringInStr($dDupMode, 'Overwrite3') And __FileCompareSize($dFilePath, $dDestination & "\" & $dFileName) = 0) Then
		Return SetError(1, 0, $dFileName) ; Error Needed To Skip.
	EndIf
	If StringInStr($dDupMode, 'Overwrite') Then
		Return SetError(2, 0, $dFileName) ; Error Needed To Overwrite.
	EndIf
	If StringInStr($dDupMode, 'Rename') Then
		$dFileName = __Duplicate_Rename($dFileName, $dDestination, $dIsDirectory, StringRight($dDupMode, 1))
	EndIf

	Return $dFileName
EndFunc   ;==>__Duplicate_Process

Func __Duplicate_ProcessOnline($dFilePath, $dProfile, $dRemoteDate, $dRemoteSize, $dListArray, $dProtocol = "FTP")
	Local $dINI, $dFileName, $dIsDirectory, $dDupMode = ""

	If _WinAPI_PathIsDirectory($dFilePath) Then
		$dIsDirectory = 1
	EndIf
	$dFileName = __GetFileName($dFilePath)

	If __Is("AutoDup", -1, "False", $dProfile) Then
		$dINI = __IsProfile($dProfile, 1) ; Get Profile Path Of Selected Profile.
		If IniRead($dINI, "General", "AutoDup", "Default") == "Default" Then
			$dINI = __IsSettingsFile() ; Get Default Settings INI File.
		EndIf
		$dDupMode = IniRead($dINI, "General", "DupMode", "Skip")
	EndIf
	If StringInStr($dDupMode, 'Overwrite2') And $dProtocol = "SFTP" Then
		MsgBox(0x40, __GetLang('DUPLICATE_MSGBOX_0', 'Manual selection needed'), __GetLang('DUPLICATE_MSGBOX_1', 'SFTP protocol currently does not support "Overwrite if newer".') & @LF & __GetLang('DUPLICATE_MSGBOX_2', 'You need to manually select how to manage this duplicate.'), 0, __OnTop())
		$dDupMode = ""
	EndIf
	If $dDupMode = "" Then
		If $G_Global_DuplicateMode <> "" Then
			$dDupMode = $G_Global_DuplicateMode
		Else
			__ExpandEventMode(0) ; Disable The Abort Button.
			$dDupMode = __Duplicate_Alert($dFileName)
			__ExpandEventMode(1) ; Enable The Abort Button.
		EndIf
	EndIf

	If StringInStr($dDupMode, 'Skip') Or (StringInStr($dDupMode, 'Overwrite2') And __FileCompareDate($dFilePath, $dRemoteDate, 1) <> 1) Or (StringInStr($dDupMode, 'Overwrite3') And __FileCompareSize($dFilePath, $dRemoteSize, 1) = 0) Then
		Return SetError(1, 0, $dFileName) ; Error Needed To Skip.
	EndIf
	If StringInStr($dDupMode, 'Rename') Then
		$dFileName = __Duplicate_Rename($dFileName, $dListArray, $dIsDirectory, StringRight($dDupMode, 1))
	EndIf

	Return $dFileName
EndFunc   ;==>__Duplicate_ProcessOnline

Func __Duplicate_Rename($dFileName, $dDestination, $dIsDirectory = 0, $dStyle = 1)
	Local $dNumber, $dFileExt, $dExists, $dIsArray = 0, $A = 1
	Local $sFileString = $dFileName

	If IsArray($dDestination) Then
		$dIsArray = 1
	Else
		If $dDestination <> "" Then
			$dDestination &= "\"
		EndIf
	EndIf

	If $dIsDirectory = 0 Then ; If Is A File.
		$dFileExt = __GetFileExtension($sFileString)
		If $dFileExt <> "" Then
			$dFileExt = "." & $dFileExt ; To Add It Only If Is A File With Extension.
		EndIf
		$sFileString = StringTrimRight($sFileString, StringLen($dFileExt))
	EndIf

	While 1
		If $A < 10 Then
			$dNumber = 0 & $A ; Create 01, 02, 03, 04, 05 Till 09.
		Else
			$dNumber = $A ; Create 10, 11, 12, 13, 14, Etc.
		EndIf
		Switch $dStyle
			Case 2
				$dFileName = $sFileString & "_" & $dNumber
			Case 3
				$dFileName = $sFileString & " (" & $dNumber & ")"
			Case Else
				$dFileName = $sFileString & " " & $dNumber
		EndSwitch
		If $dIsDirectory = 0 Then ; If Is A File.
			$dFileName &= $dFileExt
		EndIf

		If $dIsArray Then
			$dExists = 0
			For $B = 1 To $dDestination[0][0]
				If $dFileName = $dDestination[$B][0] Then
					$dExists = 1
				EndIf
			Next
			If $dExists = 0 Then
				ExitLoop
			EndIf
		Else
			If FileExists($dDestination & $dFileName) = 0 Then
				ExitLoop
			EndIf
		EndIf
		$A += 1
	WEnd

	Return $dFileName
EndFunc   ;==>__Duplicate_Rename
