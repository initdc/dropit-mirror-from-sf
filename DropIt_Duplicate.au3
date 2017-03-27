
; Archive funtions of DropIt

#include-once
#include <DropIt_General.au3>
#include <DropIt_Global.au3>
#include "Lib\udf\APIConstants.au3"
#include "Lib\udf\DropIt_LibVarious.au3"
#include "Lib\udf\WinAPIEx.au3"

Func __Duplicate_Alert($dItem, $dSourceDir, $dDestinationDir, $dInfo)
	Local $dGUI, $dButtonOverwrite, $dButtonRename, $dButtonSkip, $dCheckForAll, $dValue

	If $dInfo[0] = "-" Then
		$dSourceDir = "-"
	EndIf

	$dGUI = GUICreate(__GetLang('POSITIONPROCESS_DUPLICATE_0', 'Item already exists'), 440, 205, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($G_Global_SortingGUI))
	GUICtrlCreateGraphic(0, 0, 440, 68)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlSetColor(-1, 0xffffff)

	GUICtrlCreateLabel(__GetLang('POSITIONPROCESS_DUPLICATE_1', 'This item already exists in destination folder:'), 12, 12, 400, 18)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlCreateLabel($dItem, 12, 12 + 18, 416, 36)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlSetFont(-1, -1, 800)

	GUICtrlCreateLabel(__GetLang('FROM', 'From') & ":", 12, 76, 80, 18)
	GUICtrlSetColor(-1, 0x787878)
	GUICtrlCreateLabel(_WinAPI_PathCompactPathEx($dSourceDir, 23), 12 + 80, 76, 130, 18)
	GUICtrlSetTip(-1, $dSourceDir)
	GUICtrlCreateLabel(__GetLang('SIZE', 'Size') & ":", 12, 76 + 20, 80, 18)
	GUICtrlSetColor(-1, 0x787878)
	GUICtrlCreateLabel($dInfo[0], 12 + 80, 76 + 20, 130, 18)
	GUICtrlCreateLabel(__GetLang('ENV_VAR_TAB_7', 'Modified') & ":", 12, 76 + 40, 80, 18)
	GUICtrlSetColor(-1, 0x787878)
	GUICtrlCreateLabel($dInfo[1], 12 + 80, 76 + 40, 130, 18)

	GUICtrlCreateLabel(__GetLang('TO', 'To') & ":", 12 + 220, 76, 80, 18)
	GUICtrlSetColor(-1, 0x787878)
	GUICtrlCreateLabel(_WinAPI_PathCompactPathEx($dDestinationDir, 23), 12 + 220 + 80, 76, 130, 18)
	GUICtrlSetTip(-1, $dDestinationDir)
	GUICtrlCreateLabel(__GetLang('SIZE', 'Size') & ":", 12 + 220, 76 + 20, 80, 18)
	GUICtrlSetColor(-1, 0x787878)
	GUICtrlCreateLabel($dInfo[2], 12 + 220 + 80, 76 + 20, 130, 18)
	GUICtrlCreateLabel(__GetLang('ENV_VAR_TAB_7', 'Modified') & ":", 12 + 220, 76 + 40, 80, 18)
	GUICtrlSetColor(-1, 0x787878)
	GUICtrlCreateLabel($dInfo[3], 12 + 220 + 80, 76 + 40, 130, 18)

	$dButtonOverwrite = GUICtrlCreateButton(__GetLang('DUPLICATE_MODE_0', 'Overwrite'), 220 - 70 - 94, 147, 94, 25)
	$dButtonRename = GUICtrlCreateButton(__GetLang('DUPLICATE_MODE_2', 'Rename'), 220 - 47, 147, 94, 25)
	$dButtonSkip = GUICtrlCreateButton(__GetLang('DUPLICATE_MODE_6', 'Skip'), 220 + 70, 147, 94, 25)
	GUICtrlSetState($dButtonSkip, $GUI_DEFBUTTON)
	$dCheckForAll = GUICtrlCreateCheckbox(__GetLang('POSITIONPROCESS_DUPLICATE_2', 'Apply to all duplicates of this drop'), 14, 180, 400, 20)
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

Func __Duplicate_GetInfo($dSourcePath, $dDestinationPath, $dInfo, $dSameInfo = 0)
	If $dSameInfo Then
		$dInfo[0] = "-"
		$dInfo[1] = "-"
	Else
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

Func __Duplicate_Process($dProfile, $dSourcePath, $dDestinationPath)
	Local $dINI, $dIsDirectory, $dFileName, $dSameInfo, $dInfo[4], $dDupMode = "Skip"

	If $dSourcePath = -1 Then ; New Output Creation.
		$dSourcePath = $dDestinationPath
		$dSameInfo = 1
	EndIf
	If _WinAPI_PathIsDirectory($dDestinationPath) Then
		$dIsDirectory = 1
	EndIf
	$dFileName = __GetFileName($dDestinationPath)

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
			$dInfo = __Duplicate_GetInfo($dSourcePath, $dDestinationPath, $dInfo, $dSameInfo)
			__ExpandEventMode(0) ; Disable The Abort Button.
			$dDupMode = __Duplicate_Alert($dFileName, __GetParentFolder($dSourcePath), __GetParentFolder($dDestinationPath), $dInfo)
			__ExpandEventMode(1) ; Enable The Abort Button.
		EndIf
	EndIf

	If StringInStr($dDupMode, 'Skip') Or (StringInStr($dDupMode, 'Overwrite2') And __FileCompareDate($dSourcePath, $dDestinationPath) <> 1) Or (StringInStr($dDupMode, 'Overwrite3') And __FileCompareSize($dSourcePath, $dDestinationPath) = 0) Then
		Return SetError(1, 0, $dFileName) ; Error Needed To Skip.
	EndIf
	If StringInStr($dDupMode, 'Overwrite') Then
		Return SetError(2, 0, $dFileName) ; Error Needed To Overwrite.
	EndIf
	If StringInStr($dDupMode, 'Rename') Then
		$dFileName = __Duplicate_Rename($dFileName, __GetParentFolder($dDestinationPath), $dIsDirectory, StringRight($dDupMode, 1))
	EndIf

	Return $dFileName
EndFunc   ;==>__Duplicate_Process

Func __Duplicate_ProcessOnline($dProfile, $dSourcePath, $dDestinationDir, $dRemoteDate, $dRemoteSize, $dListArray, $dProtocol = "FTP")
	Local $dINI, $dFileName, $dIsDirectory, $dInfo[4], $dDupMode = ""

	If _WinAPI_PathIsDirectory($dSourcePath) Then
		$dIsDirectory = 1
	EndIf
	$dFileName = __GetFileName($dSourcePath)

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
			$dInfo = __Duplicate_GetInfo($dSourcePath, -1, $dInfo)
			$dInfo[2] = $dRemoteSize
			$dInfo[3] = $dRemoteDate
			__ExpandEventMode(0) ; Disable The Abort Button.
			$dDupMode = __Duplicate_Alert($dFileName, __GetParentFolder($dSourcePath), $dDestinationDir, $dInfo)
			__ExpandEventMode(1) ; Enable The Abort Button.
		EndIf
	EndIf

	If StringInStr($dDupMode, 'Skip') Or (StringInStr($dDupMode, 'Overwrite2') And __FileCompareDate($dSourcePath, $dRemoteDate, 1) <> 1) Or (StringInStr($dDupMode, 'Overwrite3') And __FileCompareSize($dSourcePath, $dRemoteSize, 1) = 0) Then
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
