
; Archive funtions of DropIt

#include-once
#include <EditConstants.au3>
#include <WinAPIFiles.au3>
#include <WindowsConstants.au3>

#include "DropIt_General.au3"
#include "DropIt_Global.au3"
#include "Lib\udf\DropIt_LibVarious.au3"

Func __Duplicate_Alert($dItem, $dSourceDir, $dDestinationDir, $dInfo, $dMerge = 0)
	Local $dGUI, $dINI, $dButtonOverwrite, $dButtonRename, $dButtonSkip, $dCheckForAll, $dValue, $dString[5], $dLabel[8]

	If _WinAPI_PathIsDirectory($dSourceDir & "\" & $dItem) = 0 Or $dInfo[0] = "-" Then
		$dString[0] = __GetLang('POSITIONPROCESS_DUPLICATE_0', 'File Already Exists')
		$dString[1] = __GetLang('POSITIONPROCESS_DUPLICATE_1', 'This file already exists in destination directory:')
		$dString[2] = __GetLang('OPEN_FILE', 'Open file')
		$dString[3] = __GetLang('POSITIONPROCESS_DUPLICATE_4', 'Open file from source directory')
		$dString[4] = __GetLang('POSITIONPROCESS_DUPLICATE_6', 'Open file already in destination directory')
	Else
		$dString[0] = __GetLang('POSITIONPROCESS_DUPLICATE_8', 'Folder Already Exists')
		$dString[1] = __GetLang('POSITIONPROCESS_DUPLICATE_9', 'This folder already exists in destination directory:')
		$dString[2] = __GetLang('OPEN_FOLDER', 'Open folder')
		$dString[3] = __GetLang('POSITIONPROCESS_DUPLICATE_5', 'Open folder from source directory')
		$dString[4] = __GetLang('POSITIONPROCESS_DUPLICATE_7', 'Open folder already in destination directory')
	EndIf
	If $dInfo[0] = "-" Then
		$dSourceDir = __GetLang('POSITIONPROCESS_DUPLICATE_3', 'New file')
	EndIf

	$dGUI = GUICreate($dString[0], 500, 220, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($G_Global_SortingGUI))

	GUICtrlCreateLabel($dString[1], 10, 10, 480, 18)
	GUICtrlCreateInput($dItem, 10, 30, 480, 22, BitOR($ES_READONLY, $ES_AUTOHSCROLL, $ES_LEFT))

	$dLabel[0] = GUICtrlCreateLabel(__GetLang('FROM', 'From') & ": " & __GetFileName($dSourceDir), 10, 65, 230, 18, $STATIC_COMPACT_END)
	GUICtrlSetTip($dLabel[0], $dSourceDir, "", 0, 2)
	$dLabel[1] = GUICtrlCreateLabel($dInfo[0], 10, 65 + 20, 80, 18)
	If $dInfo[0] > $dInfo[2] Then
		GUICtrlSetFont($dLabel[1], 8.5, 800)
	EndIf
	GUICtrlSetTip($dLabel[1], __GetLang('FILE_SIZE', 'Size'), "", 0, 2)
	$dLabel[2] = GUICtrlCreateLabel($dInfo[1], 10, 65 + 40, 140, 18)
	If $dInfo[1] > $dInfo[3] Then
		GUICtrlSetFont($dLabel[2], 8.5, 800)
	EndIf
	GUICtrlSetTip($dLabel[2], __GetLang('DATE_MODIFIED', 'Date Modified'), "", 0, 2)
	$dLabel[3] = GUICtrlCreateLabel($dString[2], 10, 65 + 60, 120, 18)
	GUICtrlSetTip($dLabel[3], $dString[3], "", 0, 2)
	GUICtrlSetColor($dLabel[3], 0x0058C9)
	If $dInfo[0] <> "-" Then
		GUICtrlSetCursor($dLabel[0], 0)
		GUICtrlSetCursor($dLabel[3], 0)
	Else ; Disabled For Upload Action.
		GUICtrlSetState($dLabel[3], $GUI_DISABLE)
	EndIf

	$dLabel[4] = GUICtrlCreateLabel(__GetLang('TO', 'To') & ": " & __GetFileName($dDestinationDir), 10 + 240, 65, 230, 18, $STATIC_COMPACT_END)
	GUICtrlSetTip($dLabel[4], $dDestinationDir, "", 0, 2)
	$dLabel[5] = GUICtrlCreateLabel($dInfo[2], 10 + 240, 65 + 20, 80, 18)
	If $dInfo[0] < $dInfo[2] Then
		GUICtrlSetFont($dLabel[5], 8.5, 800)
	EndIf
	GUICtrlSetTip($dLabel[5], __GetLang('FILE_SIZE', 'Size'), "", 0, 2)
	$dLabel[6] = GUICtrlCreateLabel($dInfo[3], 10 + 240, 65 + 40, 140, 18)
	If $dInfo[1] < $dInfo[3] Then
		GUICtrlSetFont($dLabel[6], 8.5, 800)
	EndIf
	GUICtrlSetTip($dLabel[6], __GetLang('DATE_MODIFIED', 'Date Modified'), "", 0, 2)
	$dLabel[7] = GUICtrlCreateLabel($dString[2], 10 + 240, 65 + 60, 120, 18)
	GUICtrlSetTip($dLabel[7], $dString[4], "", 0, 2)
	GUICtrlSetColor($dLabel[7], 0x0058C9)
	If StringInStr($dDestinationDir, "/") = 0 Then
		GUICtrlSetCursor($dLabel[4], 0)
		GUICtrlSetCursor($dLabel[7], 0)
	Else ; Disabled For Upload Action.
		GUICtrlSetState($dLabel[7], $GUI_DISABLE)
	EndIf

	$dValue = __GetLang('DUPLICATE_MODE_0', 'Overwrite')
	If $dMerge Then ; Compress Action Supports To Merge Archives.
		$dValue = __GetLang('DUPLICATE_MODE_8', 'Merge')
	EndIf
	$dButtonOverwrite = GUICtrlCreateButton($dValue, 250 - 80 - 110, 160, 110, 26)
	$dButtonRename = GUICtrlCreateButton(__GetLang('DUPLICATE_MODE_2', 'Rename'), 250 - 55, 160, 110, 26)
	$dButtonSkip = GUICtrlCreateButton(__GetLang('DUPLICATE_MODE_6', 'Skip'), 250 + 80, 160, 110, 26)
	GUICtrlSetState($dButtonSkip, $GUI_DEFBUTTON)
	$dCheckForAll = GUICtrlCreateCheckbox(__GetLang('POSITIONPROCESS_DUPLICATE_2', 'Apply to all duplicates of this drop'), 14, 195, 460, 20)
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
				$dINI = __IsSettingsFile() ; Get Default Settings INI File.
				$dValue = IniRead($dINI, $G_Global_GeneralSection, "DupManualRename", "Rename1")
				ExitLoop

			Case $dLabel[0]
				If $dInfo[0] <> "-" Then ; Disabled For New Files.
					__ShellExecuteOnTop($dSourceDir, 1)
				EndIf

			Case $dLabel[3]
				If $dInfo[0] <> "-" Then ; Disabled For New Files.
					__ShellExecuteOnTop($dSourceDir & "\" & $dItem, 1)
				EndIf

			Case $dLabel[4]
				If StringInStr($dDestinationDir, "/") = 0 Then ; Disabled For Upload Actions.
					__ShellExecuteOnTop($dDestinationDir, 1)
				EndIf

			Case $dLabel[7]
				If StringInStr($dDestinationDir, "/") = 0 Then ; Disabled For Upload Actions.
					__ShellExecuteOnTop($dDestinationDir & "\" & $dItem, 1)
				EndIf

		EndSwitch
	WEnd
	If GUICtrlRead($dCheckForAll) = 1 Then
		$G_Global_DuplicateMode = $dValue
	EndIf
	GUIDelete($dGUI)

	Return $dValue
EndFunc   ;==>__Duplicate_Alert

Func __Duplicate_GetInfo($dSourcePath, $dDestinationPath, $dInfo, $dNewFile = 0)
	If $dNewFile <> 1 Then
		If _WinAPI_PathIsDirectory($dSourcePath) Then
			$dInfo[0] = DirGetSize($dSourcePath)
		Else
			$dInfo[0] = FileGetSize($dSourcePath)
		EndIf
		$dInfo[0] = __ByteSuffix($dInfo[0])
		$dInfo[1] = StringRegExpReplace(FileGetTime($dSourcePath, 0, 1), "(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})", "$1/$2/$3 $4:$5:$6")
	EndIf

	If $dDestinationPath <> -1 Then
		If _WinAPI_PathIsDirectory($dDestinationPath) Then
			$dInfo[2] = DirGetSize($dDestinationPath)
		Else
			$dInfo[2] = FileGetSize($dDestinationPath)
		EndIf
		$dInfo[2] = __ByteSuffix($dInfo[2])
		$dInfo[3] = StringRegExpReplace(FileGetTime($dDestinationPath, 0, 1), "(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})", "$1/$2/$3 $4:$5:$6")
	EndIf

	Return $dInfo
EndFunc   ;==>__Duplicate_GetInfo

Func __Duplicate_GetMode($dProfile, $dOnlineProtocol = 0)
	Local $dINI, $dDupMode = "None"

	If __Is("AutoDup", -1, "False", $dProfile) Then
		$dINI = __IsProfile($dProfile, 1) ; Get Profile Path Of Selected Profile.
		If IniRead($dINI, $G_Global_GeneralSection, "AutoDup", "Default") == "Default" Then
			$dINI = __IsSettingsFile() ; Get Default Settings INI File.
		EndIf
		$dDupMode = IniRead($dINI, $G_Global_GeneralSection, "DupMode", "Skip")
	ElseIf $G_Global_DuplicateMode <> "" Then
		$dDupMode = $G_Global_DuplicateMode
	EndIf
	If StringInStr($dDupMode, 'Overwrite2') And $dOnlineProtocol == "SFTP" Then
		MsgBox(0x40, __GetLang('DUPLICATE_MSGBOX_0', 'Manual selection needed'), __GetLang('DUPLICATE_MSGBOX_1', 'SFTP protocol currently does not support "Overwrite if newer".') & @LF & __GetLang('DUPLICATE_MSGBOX_2', 'You need to manually select how to manage this duplicate.'), 10, __OnTop())
		$dDupMode = "None"
	EndIf

	Return $dDupMode
EndFunc   ;==>__Duplicate_GetMode

Func __Duplicate_Process($dProfile, $dSourcePath, $dDestinationPath, $dMerge = 0)
	Local $dIsDirectory, $dNewFile, $dInfo[4], $dDupMode

	If $dSourcePath = -1 Then ; New Output Creation.
		$dSourcePath = $dDestinationPath
		$dNewFile = 1
	EndIf

	$dDupMode = __Duplicate_GetMode($dProfile)
	If $dDupMode == "None" Then
		$dInfo[0] = "-"
		$dInfo[1] = "-"
		$dInfo = __Duplicate_GetInfo($dSourcePath, $dDestinationPath, $dInfo, $dNewFile)
		__ExpandEventMode(0) ; Disable Event Buttons.
		$dDupMode = __Duplicate_Alert(__GetFileName($dDestinationPath), __GetParentFolder($dSourcePath), __GetParentFolder($dDestinationPath), $dInfo, $dMerge)
		__ExpandEventMode(1) ; Enable Event Buttons.
	EndIf

	If StringInStr($dDupMode, 'Skip') Or (StringInStr($dDupMode, 'Overwrite2') And __FileCompareDate($dSourcePath, $dDestinationPath) <> 1 And $dNewFile <> 1) Or (StringInStr($dDupMode, 'Overwrite3') And __FileCompareSize($dSourcePath, $dDestinationPath) = 0 And $dNewFile <> 1) Then
		Return SetError(2, 0, $dDestinationPath) ; 2 = Skip.
	ElseIf StringInStr($dDupMode, 'Overwrite') Then
		Return SetError(1, 0, $dDestinationPath) ; 1 = Overwrite.
	ElseIf StringInStr($dDupMode, 'Rename') Then
		If _WinAPI_PathIsDirectory($dDestinationPath) Then
			$dIsDirectory = 1
		EndIf
		$dDestinationPath = __GetParentFolder($dDestinationPath) & "\" & __Duplicate_Rename(__GetFileName($dDestinationPath), __GetParentFolder($dDestinationPath), $dIsDirectory, StringRight($dDupMode, 1))
	EndIf

	Return $dDestinationPath
EndFunc   ;==>__Duplicate_Process

Func __Duplicate_ProcessOnline($dProfile, $dSourcePath, $dDestinationHost, $dDestinationDir, $dRemoteDate, $dRemoteSize, $dListArray, $dProtocol = "FTP")
	Local $dFileName, $dDestinationPath, $dIsDirectory, $dInfo[4], $dDupMode

	$dFileName = __GetFileName($dSourcePath)
	$dDestinationPath = $dDestinationDir & "/" & $dFileName

	$dDupMode = __Duplicate_GetMode($dProfile, $dProtocol)
	If $dDupMode == "None" Then
		$dInfo[2] = __ByteSuffix($dRemoteSize)
		$dInfo[3] = $dRemoteDate
		$dInfo = __Duplicate_GetInfo($dSourcePath, -1, $dInfo)
		__ExpandEventMode(0) ; Disable Event Buttons.
		$dDupMode = __Duplicate_Alert($dFileName, __GetParentFolder($dSourcePath), $dDestinationHost & $dDestinationDir, $dInfo)
		__ExpandEventMode(1) ; Enable Event Buttons.
	EndIf

	If StringInStr($dDupMode, 'Skip') Or (StringInStr($dDupMode, 'Overwrite2') And __FileCompareDate($dSourcePath, $dRemoteDate, 1) <> 1) Or (StringInStr($dDupMode, 'Overwrite3') And __FileCompareSize($dSourcePath, $dRemoteSize, 1) = 0) Then
		Return SetError(2, 0, $dDestinationPath) ; 2 = Skip.
	ElseIf StringInStr($dDupMode, 'Rename') Then
		If _WinAPI_PathIsDirectory($dSourcePath) Then
			$dIsDirectory = 1
		EndIf
		$dDestinationPath = $dDestinationDir & "/" & __Duplicate_Rename($dFileName, $dListArray, $dIsDirectory, StringRight($dDupMode, 1))
	EndIf

	Return $dDestinationPath
EndFunc   ;==>__Duplicate_ProcessOnline

Func __Duplicate_Rename($dFileName, $dDestination, $dIsDirectory = 0, $dStyle = 1)
	Local $dNumber, $dFileExt, $dExists, $dIsArray, $A = 1
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
			$sFileString = StringTrimRight($sFileString, StringLen($dFileExt))
		EndIf
	EndIf

	While 1
		$dFileName = $sFileString
		$dNumber = StringFormat("%02d", $A)
		Switch $dStyle
			Case 2
				$dFileName &= "_" & $dNumber
			Case 3
				$dFileName &= " (" & $dNumber & ")"
			Case Else
				$dFileName &= " " & $dNumber
		EndSwitch
		$dFileName &= $dFileExt

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
