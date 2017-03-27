
; Archive funtions of DropIt

#include-once
#include <EditConstants.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>

#include "DropIt_General.au3"
#include "DropIt_Global.au3"
#include "Lib\udf\DropIt_LibVarious.au3"

Func __Duplicate_Alert($dItem, $dSourceDir, $dDestinationDir, $dInfo, $dMerge = 0)
	Local $dGUI, $dButtonOverwrite, $dButtonRename, $dButtonSkip, $dCheckForAll, $dValue

	If $dInfo[0] = "-" Then
		$dSourceDir = __GetLang('POSITIONPROCESS_DUPLICATE_3', 'New file')
	EndIf

	$dGUI = GUICreate(__GetLang('POSITIONPROCESS_DUPLICATE_0', 'Item already exists'), 460, 230, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($G_Global_SortingGUI))

	GUICtrlCreateLabel(__GetLang('POSITIONPROCESS_DUPLICATE_1', 'This item already exists in destination folder:'), 10, 10, 440, 20)
	GUICtrlCreateEdit($dItem, 10, 30, 440, 50, $ES_READONLY + $WS_VSCROLL)

	GUICtrlCreateLabel(__GetLang('FROM', 'From') & ":", 10, 95, 80, 20)
	GUICtrlSetColor(-1, 0x787878)
	GUICtrlCreateLabel(_WinAPI_PathCompactPathEx($dSourceDir, 23), 10 + 80, 95, 130, 20)
	GUICtrlSetTip(-1, $dSourceDir)
	GUICtrlCreateLabel(__GetLang('FILE_SIZE', 'Size') & ":", 10, 95 + 20, 80, 20)
	GUICtrlSetColor(-1, 0x787878)
	GUICtrlCreateLabel($dInfo[0], 10 + 80, 95 + 20, 130, 20)
	GUICtrlCreateLabel(__GetLang('ENV_VAR_TAB_7', 'Modified') & ":", 10, 95 + 40, 80, 20)
	GUICtrlSetColor(-1, 0x787878)
	GUICtrlCreateLabel($dInfo[1], 10 + 80, 95 + 40, 130, 20)

	GUICtrlCreateLabel(__GetLang('TO', 'To') & ":", 10 + 220, 95, 80, 20)
	GUICtrlSetColor(-1, 0x787878)
	GUICtrlCreateLabel(_WinAPI_PathCompactPathEx($dDestinationDir, 23), 10 + 220 + 80, 95, 130, 20)
	GUICtrlSetTip(-1, $dDestinationDir)
	GUICtrlCreateLabel(__GetLang('FILE_SIZE', 'Size') & ":", 10 + 220, 95 + 20, 80, 20)
	GUICtrlSetColor(-1, 0x787878)
	GUICtrlCreateLabel($dInfo[2], 10 + 220 + 80, 95 + 20, 130, 20)
	GUICtrlCreateLabel(__GetLang('ENV_VAR_TAB_7', 'Modified') & ":", 10 + 220, 95 + 40, 80, 20)
	GUICtrlSetColor(-1, 0x787878)
	GUICtrlCreateLabel($dInfo[3], 10 + 220 + 80, 95 + 40, 130, 20)

	$dValue = __GetLang('DUPLICATE_MODE_0', 'Overwrite')
	If $dMerge Then ; Compress Action Supports To Merge Archives.
		$dValue = __GetLang('DUPLICATE_MODE_8', 'Merge')
	EndIf
	$dButtonOverwrite = GUICtrlCreateButton($dValue, 230 - 80 - 100, 170, 100, 26)
	$dButtonRename = GUICtrlCreateButton(__GetLang('DUPLICATE_MODE_2', 'Rename'), 230 - 50, 170, 100, 26)
	$dButtonSkip = GUICtrlCreateButton(__GetLang('DUPLICATE_MODE_6', 'Skip'), 230 + 80, 170, 100, 26)
	GUICtrlSetState($dButtonSkip, $GUI_DEFBUTTON)
	$dCheckForAll = GUICtrlCreateCheckbox(__GetLang('POSITIONPROCESS_DUPLICATE_2', 'Apply to all duplicates of this drop'), 14, 205, 420, 20)
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
		MsgBox(0x40, __GetLang('DUPLICATE_MSGBOX_0', 'Manual selection needed'), __GetLang('DUPLICATE_MSGBOX_1', 'SFTP protocol currently does not support "Overwrite if newer".') & @LF & __GetLang('DUPLICATE_MSGBOX_2', 'You need to manually select how to manage this duplicate.'), 0, __OnTop())
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
		$dNumber = StringFormat("%02d", $A)
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
