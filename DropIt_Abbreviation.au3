
; Image funtions of DropIt

#include-once
#include <Date.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

#include "DropIt_General.au3"
#include "DropIt_Global.au3"
#include "DropIt_Modifier.au3"
#include "Lib\udf\DropIt_LibFiles.au3"
#include "Lib\udf\DropIt_LibVarious.au3"
#include "Lib\udf\HashForFile.au3"
#include "Lib\udf\ImageGetInfo.au3"

Global $A_Global_ComboBox, $A_Global_ComboBoxChange = 0

Func _ManageCustomAbbreviation($mMenuItem, $mCustomItem, $mNoCustom, $mINI, $mHandle = -1)
	Local $mGUI, $mSave, $mRemove, $mClose, $mMsgBox, $mAbbreviation, $mComboAbbreviation, $mInput_Abbreviation, $mString_Abbreviations, $mText, $mInput_Text
	Local $mAddNew = "[ " & __GetLang('ENV_VAR_MSGBOX_14', 'New Abbreviation') & " ]"

	$mGUI = GUICreate(__GetLang('ENV_VAR_MSGBOX_15', 'Manage Abbreviations'), 360, 145, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	If $mNoCustom <> 1 Then
		For $A = 1 To $mCustomItem[0][0]
			$mString_Abbreviations &= "|" & $mCustomItem[$A][0]
		Next
	EndIf
	$A_Global_ComboBox = GUICtrlCreateCombo("", 10, 15, 340, 22, $WS_VSCROLL + $CBS_DROPDOWNLIST)
	GUICtrlSetData($A_Global_ComboBox, $mAddNew & $mString_Abbreviations, $mAddNew)

	GUICtrlCreateLabel(__GetLang('ENV_VAR_MSGBOX_13', 'Abbreviation') & ":", 10, 12 + 40, 120, 20)
	$mInput_Abbreviation = GUICtrlCreateInput("", 10, 31 + 40, 130, 22)
	GUICtrlCreateLabel(__GetLang('VALUE', 'Value') & ":", 10 + 140, 12 + 40, 190, 20)
	$mInput_Text = GUICtrlCreateInput("", 10 + 140, 31 + 40, 200, 22)

	$mSave = GUICtrlCreateButton(__GetLang('SAVE', 'Save'), 180 - 70 - 90, 110, 90, 24)
	$mRemove = GUICtrlCreateButton(__GetLang('OPTIONS_BUTTON_3', 'Remove'), 180 - 45, 110, 90, 24)
	$mClose = GUICtrlCreateButton(__GetLang('CLOSE', 'Close'), 180 + 70, 110, 90, 24)
	GUICtrlSetState($mClose, $GUI_DEFBUTTON)
	GUICtrlSetState($mRemove, $GUI_DISABLE)
	GUIRegisterMsg($WM_COMMAND, "_WM_COMMAND_ABBREVIATION")
	GUISetState(@SW_SHOW)

	While 1
		If $A_Global_ComboBoxChange Then
			$A_Global_ComboBoxChange = 0
			$mComboAbbreviation = GUICtrlRead($A_Global_ComboBox)
			If $mComboAbbreviation <> $mAddNew Then
				GUICtrlSetData($mInput_Abbreviation, $mComboAbbreviation)
				GUICtrlSetData($mInput_Text, IniRead($mINI, "EnvironmentVariables", $mComboAbbreviation, ""))
				GUICtrlSetState($mRemove, $GUI_ENABLE)
			Else
				GUICtrlSetData($mInput_Abbreviation, "")
				GUICtrlSetData($mInput_Text, "")
				GUICtrlSetState($mRemove, $GUI_DISABLE)
			EndIf
		EndIf

		; Enable/Disable Save Button:
		If StringStripWS(GUICtrlRead($mInput_Abbreviation), 8) <> "" And GUICtrlRead($mInput_Text) <> "" Then
			If GUICtrlGetState($mSave) > 80 Then
				GUICtrlSetState($mSave, 576) ; $GUI_ENABLE + $GUI_DEFBUTTON.
			EndIf
			If GUICtrlGetState($mClose) = 512 Then
				GUICtrlSetState($mClose, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
		ElseIf StringStripWS(GUICtrlRead($mInput_Abbreviation), 8) = "" Or GUICtrlRead($mInput_Text) = "" Then
			If GUICtrlGetState($mSave) = 80 Then
				GUICtrlSetState($mSave, 144) ; $GUI_DISABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($mClose) = 80 Then
				GUICtrlSetState($mClose, 512) ; $GUI_DEFBUTTON.
			EndIf
		EndIf

		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $mClose
				ExitLoop

			Case $mSave
				$mAbbreviation = GUICtrlRead($mInput_Abbreviation)
				$mComboAbbreviation = GUICtrlRead($A_Global_ComboBox)
				$mText = GUICtrlRead($mInput_Text)
				If StringInStr($mAbbreviation, "#") <> 0 Then
					MsgBox(0x30, __GetLang('ENV_VAR_MSGBOX_4', 'Abbreviation Error'), __GetLang('ENV_VAR_MSGBOX_8', 'The # is a special character for modifiers and cannot be used for the abbreviation variable.'), 0, __OnTop($mGUI))
					ContinueLoop
				EndIf
				For $A = 1 To $mMenuItem[0][0]
					If $mAbbreviation = $mMenuItem[$A][1] Then
						MsgBox(0x30, __GetLang('ENV_VAR_MSGBOX_4', 'Abbreviation Error'), __GetLang('ENV_VAR_MSGBOX_5', 'This variable already exists and cannot be replaced.'), 0, __OnTop($mGUI))
						ContinueLoop
					EndIf
				Next
				If $mNoCustom <> 1 Then
					For $A = 1 To $mCustomItem[0][0]
						If $mAbbreviation = $mCustomItem[$A][0] And $mAbbreviation <> $mComboAbbreviation Then
							$mMsgBox = MsgBox(0x4, __GetLang('ENV_VAR_MSGBOX_6', 'Replace Abbreviation'), __GetLang('ENV_VAR_MSGBOX_7', 'This variable already exists. Do you want to replace it?'), 0, __OnTop($mGUI))
							If $mMsgBox <> 6 Then
								ContinueLoop 2
							EndIf
						EndIf
					Next
				EndIf
				If $mComboAbbreviation <> $mAddNew Then
					IniDelete($mINI, "EnvironmentVariables", $mComboAbbreviation)
					EnvSet($mComboAbbreviation)
				EndIf
				__IniWriteEx($mINI, "EnvironmentVariables", $mAbbreviation, $mText)
				EnvSet($mAbbreviation, $mText)
				ExitLoop

			Case $mRemove
				$mAbbreviation = GUICtrlRead($A_Global_ComboBox)
				IniDelete($mINI, "EnvironmentVariables", $mAbbreviation)
				EnvSet($mAbbreviation)
				ExitLoop

		EndSwitch
	WEnd
	$A_Global_ComboBoxChange = -1
	GUIDelete($mGUI)

	Return 1
EndFunc   ;==>_ManageCustomAbbreviation

Func _WM_COMMAND_ABBREVIATION($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg
	Local $cWndFrom, $cAbbreviation_ComboBox = $A_Global_ComboBox
	If IsHWnd($cAbbreviation_ComboBox) = 0 Then
		$cAbbreviation_ComboBox = GUICtrlGetHandle($cAbbreviation_ComboBox)
	EndIf
	$cWndFrom = $ilParam
	Switch $cWndFrom
		Case $cAbbreviation_ComboBox
			Switch _WinAPI_HiWord($iwParam)
				Case $CBN_EDITCHANGE, $CBN_SELCHANGE
					$A_Global_ComboBoxChange = 1
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_COMMAND_ABBREVIATION

Func _ContextMenuAbbreviations($mButton_Abbreviations, $mMenuGroup, $mNumberAbbreviations, $mCurrentAction, $mHandle = -1)
	Local $mEnvMenu, $mCustomMenu, $mCustomID[1], $mNoCustom, $mMsg, $mPos, $mValue = -1
	Local $mIndex, $mCurrentArray, $mMenuItem[$mNumberAbbreviations + 1][4] = [[$mNumberAbbreviations, 0, 0, 0]]
	Local $mINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $mCustomItem = __IniReadSection($mINI, "EnvironmentVariables")
	If @error Or $mCustomItem[0][0] = 0 Then
		$mNoCustom = 1
	EndIf

	For $A = 1 To $mMenuGroup[0][0] ; Create The Unique Array.
		If $mMenuGroup[$A][0] <> "" Then ; To Skip Separators.
			$mCurrentArray = $mMenuGroup[$A][1]
			For $B = 1 To $mCurrentArray[0][0]
				$mIndex += 1
				$mMenuItem[$mIndex][0] = $A ; Group Number.
				$mMenuItem[$mIndex][1] = $mCurrentArray[$B][0] ; Abbreviation String.
				$mMenuItem[$mIndex][2] = $mCurrentArray[$B][1] ; Abbreviation Description.
			Next
		EndIf
	Next

	If IsHWnd($mButton_Abbreviations) = 0 Then
		$mButton_Abbreviations = GUICtrlGetHandle($mButton_Abbreviations)
	EndIf

	$mEnvMenu = _GUICtrlMenu_CreatePopup()
	_GUICtrlMenu_SetMenuStyle($mEnvMenu, $MNS_NOCHECK)
	For $A = 1 To $mMenuGroup[0][0]
		If $mMenuGroup[$A][0] = "" Then ; Separator.
			_GUICtrlMenu_AddMenuItem($mEnvMenu, "")
		Else
			$mMenuGroup[$A][2] = _GUICtrlMenu_CreatePopup()
			_GUICtrlMenu_SetMenuStyle($mMenuGroup[$A][2], $MNS_NOCHECK)
			_GUICtrlMenu_AddMenuItem($mEnvMenu, $mMenuGroup[$A][0], 0, $mMenuGroup[$A][2])
		EndIf
	Next
	For $A = 1 To $mMenuItem[0][0]
		$mMenuItem[$A][3] = 1000 + $A
		If $mMenuItem[$A][1] = "" Then ; Separator.
			_GUICtrlMenu_AddMenuItem($mMenuGroup[$mMenuItem[$A][0]][2], "")
		Else
			_GUICtrlMenu_AddMenuItem($mMenuGroup[$mMenuItem[$A][0]][2], "%" & $mMenuItem[$A][1] & "% = " & $mMenuItem[$A][2], $mMenuItem[$A][3])
			If ($mCurrentAction <> __GetLang('ACTION_OPEN_WITH', 'Open With') And ($mMenuItem[$A][1] = "File" Or $mMenuItem[$A][1] = "DefaultProgram")) Or _
					($mCurrentAction <> "ManageList" And ($mMenuItem[$A][1] = "LinkAbsolute" Or $mMenuItem[$A][1] = "LinkRelative")) Or _
					($mCurrentAction == "ManageList" And $mMenuItem[$A][1] = "SubDir") Then
				_GUICtrlMenu_SetItemDisabled($mMenuGroup[$mMenuItem[$A][0]][2], $mMenuItem[$A][3], True, False) ; To Hide Abbreviations If Not Supported By Current Action.
			EndIf
		EndIf
	Next

	_GUICtrlMenu_AddMenuItem($mEnvMenu, "")
	$mCustomMenu = _GUICtrlMenu_CreatePopup()
	_GUICtrlMenu_SetMenuStyle($mCustomMenu, $MNS_NOCHECK)
	_GUICtrlMenu_AddMenuItem($mEnvMenu, __GetLang('ENV_VAR_TAB_11', 'Custom'), 0, $mCustomMenu)
	_GUICtrlMenu_AddMenuItem($mCustomMenu, __GetLang('ENV_VAR_MSGBOX_15', 'Manage Abbreviations'), 1999)
	If $mNoCustom <> 1 Then
		_GUICtrlMenu_AddMenuItem($mCustomMenu, "")
		$mCustomID[0] = $mCustomItem[0][0]
		ReDim $mCustomID[$mCustomID[0] + 1]
		For $A = 1 To $mCustomItem[0][0]
			$mCustomID[$A] = 2000 + $A
			_GUICtrlMenu_AddMenuItem($mCustomMenu, "%" & $mCustomItem[$A][0] & "% = " & $mCustomItem[$A][1], $mCustomID[$A])
		Next
	EndIf
	If FileExists($G_Global_GuidePath) Then
		_GUICtrlMenu_AddMenuItem($mEnvMenu, __GetLang('ENV_VAR_MSGBOX_9', 'Modifiers'), 2000)
	EndIf

	$mPos = WinGetPos($mButton_Abbreviations, "")
	$mMsg = _GUICtrlMenu_TrackPopupMenu($mEnvMenu, $mButton_Abbreviations, $mPos[0] + $mPos[2], $mPos[1] + $mPos[3], 2, 1, 2)
	Switch $mMsg
		Case 1999 ; Manage Abbreviation.
			_ManageCustomAbbreviation($mMenuItem, $mCustomItem, $mNoCustom, $mINI, $mHandle)
		Case 2000 ; Open The Guide.
			Local $mMsgBox = MsgBox(0x44, __GetLang('ENV_VAR_MSGBOX_10', 'Abbreviation Modifiers'), __GetLang('ENV_VAR_MSGBOX_11', 'The last chapter of the Guide contains the instructions to use the abbreviation modifiers.') & @LF & __GetLang('ENV_VAR_MSGBOX_12', 'Do you want to read the Guide?'), 0, __OnTop($mHandle))
			If $mMsgBox = 6 Then
				__ShellExecuteOnTop($G_Global_GuidePath, "Guide")
			EndIf
		Case Else
			If $mMsg >= $mMenuItem[1][3] And $mMsg <= $mMenuItem[$mMenuItem[0][0]][3] Then
				For $A = 1 To $mMenuItem[0][0]
					If $mMsg = $mMenuItem[$A][3] Then
						$mValue = $mMenuItem[$A][1]
						ExitLoop
					EndIf
				Next
			ElseIf $mNoCustom <> 1 Then
				If $mMsg >= $mCustomID[1] And $mMsg <= $mCustomID[$mCustomID[0]] Then
					For $A = 1 To $mCustomID[0]
						If $mMsg = $mCustomID[$A] Then
							$mValue = $mCustomItem[$A][0]
							ExitLoop
						EndIf
					Next
				EndIf
			EndIf
	EndSwitch

	_GUICtrlMenu_DestroyMenu($mEnvMenu)
	For $A = 1 To $mMenuGroup[0][0]
		_GUICtrlMenu_DestroyMenu($mMenuGroup[$A][2])
	Next

	Return $mValue
EndFunc   ;==>_ContextMenuAbbreviations

Func _ReplaceAbbreviation($sDestination, $sFilePath = "", $sProfile = "", $sAction = "", $sMainDir = "")
	Local $sLoadedProperty
	Local $aEnvArray[123][3] = [ _
			[122, 0, 0], _
			["FileExt", 0, 1], _
			["FileName", 0, 2], _
			["FileNameExt", 0, 3], _
			["FileBytes", 0, 4], _
			["FileSize", 0, 5], _
			["ParentDir", 0, 6], _
			["ParentDirName", 0, 7], _
			["SubDir", 0, 8], _
			["FileDrive", 0, 9], _
			["PortableDrive", 5, 25], _
			["ProfileName", 5, 26], _
			["Owner", 1, 8], _
			["Authors", 1, 12], _
			["Company", 1, 26], _
			["Subject", 1, 19], _
			["Category", 1, 20], _
			["FileType", 1, 2], _
			["Attributes", 1, 6], _
			["Comments", 1, 21], _
			["Copyright", 1, 22], _
			["Duration", 1, 23], _
			["BitRate", 1, 24], _
			["CameraMaker", 1, 25], _
			["CameraModel", 1, 11], _
			["Dimensions", 1, 10], _
			["Megapixels", 4, 1], _
			["ISO", 4, 2], _
			["FNumber", 4, 3], _
			["FocalLength", 4, 4], _
			["ExposureTime", 4, 5], _
			["ExposureTimeFraction", 4, 6], _
			["ExposureBias", 4, 7], _
			["Brightness", 4, 8], _
			["SongAlbum", 1, 15], _
			["SongArtist", 1, 13], _
			["SongGenre", 1, 16], _
			["SongTrack", 1, 18], _
			["SongNumber", 1, 18], _
			["SongTitle", 1, 14], _
			["SongYear", 1, 17], _
			["ComputerName", 5, 1], _
			["UserName", 5, 2], _
			["AppData", 5, 3], _
			["AppDataPublic", 5, 4], _
			["Desktop", 5, 5], _
			["DesktopPublic", 5, 6], _
			["Documents", 5, 7], _
			["DocumentsPublic", 5, 8], _
			["Favorites", 5, 9], _
			["FavoritesPublic", 5, 10], _
			["ProgramFiles", 5, 11], _
			["CurrentDate", 5, 12], _
			["CurrentYear", 5, 13], _
			["CurrentMonth", 5, 14], _
			["CurrentMonthName", 5, 15], _
			["CurrentMonthShort", 5, 16], _
			["CurrentWeek", 5, 22], _
			["CurrentDay", 5, 17], _
			["CurrentDayName", 5, 23], _
			["CurrentDayShort", 5, 24], _
			["CurrentTime", 5, 18], _
			["CurrentHour", 5, 19], _
			["CurrentMinute", 5, 20], _
			["CurrentSecond", 5, 21], _
			["DateCreated", 2, 1], _
			["YearCreated", 2, 1], _
			["MonthCreated", 2, 1], _
			["MonthNameCreated", 2, 1], _
			["MonthShortCreated", 2, 1], _
			["WeekCreated", 2, 1], _
			["DayCreated", 2, 1], _
			["DayNameCreated", 2, 1], _
			["DayShortCreated", 2, 1], _
			["TimeCreated", 2, 1], _
			["HourCreated", 2, 1], _
			["MinuteCreated", 2, 1], _
			["SecondCreated", 2, 1], _
			["DateModified", 2, 0], _
			["YearModified", 2, 0], _
			["MonthModified", 2, 0], _
			["MonthNameModified", 2, 0], _
			["MonthShortModified", 2, 0], _
			["WeekModified", 2, 0], _
			["DayModified", 2, 0], _
			["DayNameModified", 2, 0], _
			["DayShortModified", 2, 0], _
			["TimeModified", 2, 0], _
			["HourModified", 2, 0], _
			["MinuteModified", 2, 0], _
			["SecondModified", 2, 0], _
			["DateOpened", 2, 2], _
			["YearOpened", 2, 2], _
			["MonthOpened", 2, 2], _
			["MonthNameOpened", 2, 2], _
			["MonthShortOpened", 2, 2], _
			["WeekOpened", 2, 2], _
			["DayOpened", 2, 2], _
			["DayNameOpened", 2, 2], _
			["DayShortOpened", 2, 2], _
			["TimeOpened", 2, 2], _
			["HourOpened", 2, 2], _
			["MinuteOpened", 2, 2], _
			["SecondOpened", 2, 2], _
			["DateTaken", 2, 3], _
			["YearTaken", 2, 3], _
			["MonthTaken", 2, 3], _
			["MonthNameTaken", 2, 3], _
			["MonthShortTaken", 2, 3], _
			["WeekTaken", 2, 3], _
			["DayTaken", 2, 3], _
			["DayNameTaken", 2, 3], _
			["DayShortTaken", 2, 3], _
			["TimeTaken", 2, 3], _
			["HourTaken", 2, 3], _
			["MinuteTaken", 2, 3], _
			["SecondTaken", 2, 3], _
			["CRC", 3, 1], _
			["MD4", 3, 2], _
			["MD5", 3, 3], _
			["SHA-1", 3, 4], _
			["SHA1", 3, 4], _
			["UserInput", 6, 0]]

	For $A = 1 To $aEnvArray[0][0]
		If StringRegExp($sDestination, "%" & $aEnvArray[$A][0] & "%|%" & $aEnvArray[$A][0] & "#(.*?)%") Then
			If $sFilePath = "" And $aEnvArray[$A][1] <> 5 Then ; Only Macro Category Is File Independent (Used For Monitored Folders).
				$sLoadedProperty = StringReplace(__GetLang('ENV_VAR_UNKNOWN', 'Unknown %Abbreviation%', 1), "%Abbreviation%", $aEnvArray[$A][0])
				$sDestination = _Modifier_StringReplaceModifier($sDestination, $aEnvArray[$A][0], $sLoadedProperty)
				ContinueLoop
			EndIf
			Switch $aEnvArray[$A][1]
				Case 0 ; Specific Strings.
					$sLoadedProperty = __GetFileParameter($sFilePath, $sMainDir, $aEnvArray[$A][2])
				Case 1 ; From Windows Explorer.
					$sLoadedProperty = __GetFileProperties($sFilePath, $aEnvArray[$A][2])
					$sLoadedProperty = StringReplace($sLoadedProperty, ":", ".")
				Case 2 ; Date And Time.
					$sLoadedProperty = __GetFileTime($sFilePath, $aEnvArray[$A][0], $aEnvArray[$A][2])
				Case 3 ; Hash.
					$sLoadedProperty = __GetFileHash($sFilePath, $aEnvArray[$A][2])
				Case 4 ; Exif.
					$sLoadedProperty = __GetFileExif($sFilePath, $aEnvArray[$A][2])
				Case 5 ; Macro.
					$sLoadedProperty = __GetDefinedMacro($sProfile, $aEnvArray[$A][2])
				Case 6 ; User Input.
					$sLoadedProperty = __GetUserInput($sDestination, __GetFileName($sFilePath), $sAction)
			EndSwitch
			If StringStripWS($sLoadedProperty, 8) == "" And $aEnvArray[$A][0] <> "SubDir" Then
				$sLoadedProperty = StringReplace(__GetLang('ENV_VAR_UNKNOWN', 'Unknown %Abbreviation%', 1), "%Abbreviation%", $aEnvArray[$A][0])
			EndIf
			$sDestination = _Modifier_StringReplaceModifier($sDestination, $aEnvArray[$A][0], StringStripWS($sLoadedProperty, 3))
		EndIf
	Next

	Return $sDestination
EndFunc   ;==>_ReplaceAbbreviation

Func __GetFileExif($sFilePath, $iExifCode)
	Local $sReturn = '', $sExif

	$sExif = _ImageGetInfo($sFilePath)
	If @error Then
		Return SetError(@error, 0, '')
	EndIf

	Switch $iExifCode
		Case 1
			$sReturn = Round(_ImageGetParam($sExif, "Width") * _ImageGetParam($sExif, "Height") / 1000000, 1)
		Case 2
			$sReturn = _ImageGetParam($sExif, "ISO")
		Case 3
			$sReturn = _ImageGetParam($sExif, "FNumber")
		Case 4
			$sReturn = Round(_ImageGetParam($sExif, "FocalLength"), 1)
		Case 5
			$sReturn = Round(_ImageGetParam($sExif, "ExposureTime"), 5)
		Case 6
			$sReturn = Round(1 / _ImageGetParam($sExif, "ExposureTime"))
		Case 7
			$sReturn = Round(_ImageGetParam($sExif, "ExposureBiasValue"), 1)
		Case 8
			$sReturn = Round(_ImageGetParam($sExif, "BrightnessValue"), 2)
	EndSwitch

	Return $sReturn
EndFunc   ;==>__GetFileExif

Func __GetFileHash($sFilePath, $iHashCode)
	Local $sReturn = ''

	Switch $iHashCode
		Case 1 ; CRC32 Hash.
			$sReturn = __CRC32ForFile($sFilePath)
		Case 2 ; MD4 Hash.
			$sReturn = __MD4ForFile($sFilePath)
		Case 3 ; MD5 Hash.
			$sReturn = __MD5ForFile($sFilePath)
		Case 4 ; SHA-1 Hash.
			$sReturn = __SHA1ForFile($sFilePath)
	EndSwitch

	Return $sReturn
EndFunc   ;==>__GetFileHash

Func __GetFileParameter($sFilePath, $sMainDir, $iParameterCode)
	Local $sReturn = ''

	Switch $iParameterCode
		Case 1 ; File Extension.
			$sReturn = __GetFileExtension($sFilePath)
		Case 2 ; File Name.
			$sReturn = __GetFileNameOnly($sFilePath)
		Case 3 ; File Name With Extension.
			$sReturn = __GetFileName($sFilePath)
		Case 4 ; File Bytes.
			$sReturn = __GetFileSize($sFilePath)
		Case 5 ; File Size.
			$sReturn = __ByteSuffix(__GetFileSize($sFilePath))
		Case 6 ; Parent Folder Path.
			$sReturn = __GetParentFolder($sFilePath)
		Case 7 ; Parent Folder Name.
			$sReturn = __GetFileName(__GetParentFolder($sFilePath))
		Case 8 ; Recreated Directory Structure.
			$sReturn = StringTrimLeft(__GetParentFolder($sFilePath), StringLen($sMainDir))
		Case 9 ; File Drive Letter.
			$sReturn = StringTrimRight(__GetDrive($sFilePath), 1)
	EndSwitch

	Return $sReturn
EndFunc   ;==>__GetFileParameter

Func __GetFileTime($sFilePath, $sTimeVariable, $iTimeCode)
	Local $sReturn = '', $sString, $aTime[6]

	If $iTimeCode = 3 Then
		$sString = StringRegExpReplace(_ImageGetParam(_ImageGetInfo($sFilePath), "DateTimeOriginal"), "[^0-9]", "")
		If StringIsDigit($sString) Then
			$aTime[0] = StringLeft($sString, 4)
			$aTime[1] = StringRight(StringLeft($sString, 6), 2)
			$aTime[2] = StringRight(StringLeft($sString, 8), 2)
			$aTime[3] = StringLeft(StringRight($sString, 6), 2)
			$aTime[4] = StringLeft(StringRight($sString, 4), 2)
			$aTime[5] = StringRight($sString, 2)
		Else
			Return SetError(1, 0, '')
		EndIf
	Else
		$aTime = FileGetTime($sFilePath, $iTimeCode)
	EndIf
	If @error Then
		Return SetError(@error, 0, '')
	EndIf

	If StringInStr($sTimeVariable, "Date") Then
		$sReturn = $aTime[0] & "-" & $aTime[1] & "-" & $aTime[2] ; YYYY-MM-DD.
	ElseIf StringInStr($sTimeVariable, "Time") Then
		$sReturn = $aTime[3] & "." & $aTime[4] ; HH.MM.
	ElseIf StringInStr($sTimeVariable, "Year") Then
		$sReturn = $aTime[0] ; YYYY.
	ElseIf StringInStr($sTimeVariable, "MonthName") Then
		$sReturn = __Locale_MonthName($aTime[1], 0) ; [November].
	ElseIf StringInStr($sTimeVariable, "MonthShort") Then
		$sReturn = __Locale_MonthName($aTime[1], 1) ; [Nov].
	ElseIf StringInStr($sTimeVariable, "Month") Then
		$sReturn = $aTime[1] ; MM.
	ElseIf StringInStr($sTimeVariable, "Week") Then
		$sReturn = _WeekNumberISO($aTime[0], $aTime[1], $aTime[2]) ; [23].
	ElseIf StringInStr($sTimeVariable, "DayName") Then
		$sReturn = __Locale_DayName(_DateToDayOfWeekISO($aTime[0], $aTime[1], $aTime[2]), 0) ; [saturday].
	ElseIf StringInStr($sTimeVariable, "DayShort") Then
		$sReturn = __Locale_DayName(_DateToDayOfWeekISO($aTime[0], $aTime[1], $aTime[2]), 1) ; [sat].
	ElseIf StringInStr($sTimeVariable, "Day") Then
		$sReturn = $aTime[2] ; DD.
	ElseIf StringInStr($sTimeVariable, "Hour") Then
		$sReturn = $aTime[3] ; HH.
	ElseIf StringInStr($sTimeVariable, "Minute") Then
		$sReturn = $aTime[4] ; MM.
	ElseIf StringInStr($sTimeVariable, "Second") Then
		$sReturn = $aTime[5] ; SS.
	EndIf

	Return $sReturn
EndFunc   ;==>__GetFileTime

Func __GetDefinedMacro($sProfileName, $iMacroCode)
	Local $sReturn = '', $aProfile[1]

	Switch $iMacroCode
		Case 1 ; Computer Name.
			$sReturn = @ComputerName
		Case 2 ; User Name.
			$sReturn = @UserName
		Case 3 ; AppData Directory.
			$sReturn = @AppDataDir
		Case 4 ; AppData Public Directory.
			$sReturn = @AppDataCommonDir
		Case 5 ; Desktop Directory.
			$sReturn = @DesktopDir
		Case 6 ; Desktop Public Directory.
			$sReturn = @DesktopCommonDir
		Case 7 ; Documents Directory.
			$sReturn = @MyDocumentsDir
		Case 8 ; Documents Public Directory.
			$sReturn = @DocumentsCommonDir
		Case 9 ; Favorites Directory.
			$sReturn = @FavoritesDir
		Case 10 ; Favorites Public Directory.
			$sReturn = @FavoritesCommonDir
		Case 11 ; ProgramFiles Directory.
			$sReturn = @ProgramFilesDir
		Case 12 ; Current Date.
			$sReturn = @YEAR & "-" & @MON & "-" & @MDAY
		Case 13 ; Current Year.
			$sReturn = @YEAR
		Case 14 ; Current Month.
			$sReturn = @MON
		Case 15 ; Current Month Name.
			$sReturn = __Locale_MonthName(@MON, 0)
		Case 16 ; Current Month Short Name.
			$sReturn = __Locale_MonthName(@MON, 1)
		Case 17 ; Current Day.
			$sReturn = @MDAY
		Case 18 ; Current Time.
			$sReturn = @HOUR & "." & @MIN
		Case 19 ; Current Hour.
			$sReturn = @HOUR
		Case 20 ; Current Minute.
			$sReturn = @MIN
		Case 21 ; Current Second.
			$sReturn = @SEC
		Case 22 ; Current Week.
			$sReturn = _WeekNumberISO()
		Case 23 ; Current Day Name.
			$sReturn = __Locale_DayName(_DateToDayOfWeekISO(@YEAR, @MON, @MDAY), 0)
		Case 24 ; Current Day Short Name.
			$sReturn = __Locale_DayName(_DateToDayOfWeekISO(@YEAR, @MON, @MDAY), 1)
		Case 25 ; Portable Drive Letter.
			$sReturn = StringLeft(@ScriptFullPath, 2)
		Case 26 ; Profile Name.
			$aProfile = __IsProfile($sProfileName, 0) ; Get Array Of Selected Profile.
			$sReturn = $aProfile[1]
	EndSwitch

	Return $sReturn
EndFunc   ;==>__GetDefinedMacro

Func __GetUserInput($sDestination, $sFilePath, $sAction)
	Local $hGUI, $hSave, $hCancel, $hCheckForAll, $sText, $hInput

	If $G_Global_UserInput <> "" Then
		Return $G_Global_UserInput
	EndIf
	$sDestination = __GetDestinationString($sAction, $sDestination)

	__ExpandEventMode(0) ; Disable Event Buttons.
	$hGUI = GUICreate(__GetLang('USERINPUT_0', 'Define Abbreviation Value'), 400, 280, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($G_Global_SortingGUI))
	GUICtrlCreateLabel(__GetLang('MOREMATCHES_LABEL_0', 'Loaded item:'), 10, 10, 380, 20)
	GUICtrlCreateEdit($sFilePath, 10, 30, 380, 52, $ES_READONLY + $WS_VSCROLL)
	GUICtrlCreateLabel(__GetLang('DESTINATION', 'Destination') & ":", 10, 90 + 10, 380, 20)
	GUICtrlCreateInput($sDestination, 10, 90 + 30, 380, 22, BitOR($ES_READONLY, $ES_AUTOHSCROLL))
	GUICtrlCreateLabel(__GetLang('USERINPUT_1', 'Replace %UserInput% with', 1) & ":", 10, 90 + 60 + 10, 380, 20)
	$hInput = GUICtrlCreateInput("", 10, 90 + 60 + 30, 380, 22)

	$hSave = GUICtrlCreateButton(__GetLang('OK', 'OK'), 200 - 60 - 85, 220, 85, 24)
	$hCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 200 + 60, 220, 85, 24)
	GUICtrlSetState($hSave, $GUI_DEFBUTTON)
	$hCheckForAll = GUICtrlCreateCheckbox(__GetLang('USERINPUT_2', 'Apply to all %UserInput% abbreviations of this drop', 1), 10, 255, 380, 20)
	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $hCancel
				ExitLoop

			Case $hSave
				$sText = GUICtrlRead($hInput)
				ExitLoop

		EndSwitch
	WEnd
	If GUICtrlRead($hCheckForAll) = 1 Then
		$G_Global_UserInput = $sText
	EndIf
	GUIDelete($hGUI)
	__ExpandEventMode(1) ; Enable Event Buttons.

	Return $sText
EndFunc   ;==>__GetUserInput
