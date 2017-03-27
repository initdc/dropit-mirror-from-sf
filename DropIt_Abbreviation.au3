
; Image funtions of DropIt

#include-once
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

Func _ReplaceAbbreviation($sDestination, $sFilePath, $sProfile, $sAction, $sMainDir)
	Local $sLoadedProperty
	Local $aEnvArray[104][3] = [ _
			[103, 0, 0], _
			["FileExt", 0, 1], _
			["FileName", 0, 2], _
			["FileNameExt", 0, 3], _
			["ParentDir", 0, 4], _
			["ParentDirName", 0, 5], _
			["PortableDrive", 0, 6], _
			["SubDir", 0, 7], _
			["ProfileName", 0, 8], _
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
			["CurrentDay", 5, 17], _
			["CurrentTime", 5, 18], _
			["CurrentHour", 5, 19], _
			["CurrentMinute", 5, 20], _
			["CurrentSecond", 5, 21], _
			["DateCreated", 2, 1], _
			["YearCreated", 2, 1], _
			["MonthCreated", 2, 1], _
			["MonthNameCreated", 2, 1], _
			["MonthShortCreated", 2, 1], _
			["DayCreated", 2, 1], _
			["TimeCreated", 2, 1], _
			["HourCreated", 2, 1], _
			["MinuteCreated", 2, 1], _
			["SecondCreated", 2, 1], _
			["DateModified", 2, 0], _
			["YearModified", 2, 0], _
			["MonthModified", 2, 0], _
			["MonthNameModified", 2, 0], _
			["MonthShortModified", 2, 0], _
			["DayModified", 2, 0], _
			["TimeModified", 2, 0], _
			["HourModified", 2, 0], _
			["MinuteModified", 2, 0], _
			["SecondModified", 2, 0], _
			["DateOpened", 2, 2], _
			["YearOpened", 2, 2], _
			["MonthOpened", 2, 2], _
			["MonthNameOpened", 2, 2], _
			["MonthShortOpened", 2, 2], _
			["DayOpened", 2, 2], _
			["TimeOpened", 2, 2], _
			["HourOpened", 2, 2], _
			["MinuteOpened", 2, 2], _
			["SecondOpened", 2, 2], _
			["DateTaken", 2, 3], _
			["YearTaken", 2, 3], _
			["MonthTaken", 2, 3], _
			["MonthNameTaken", 2, 3], _
			["MonthShortTaken", 2, 3], _
			["DayTaken", 2, 3], _
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
			Switch $aEnvArray[$A][1]
				Case 0 ; Specific Strings.
					$sLoadedProperty = __GetFileParameter($sFilePath, $sMainDir, $sProfile, $aEnvArray[$A][2])
				Case 1 ; From Windows Explorer.
					$sLoadedProperty = __GetFileProperties($sFilePath, $aEnvArray[$A][2])
					$sLoadedProperty = StringReplace($sLoadedProperty, ":", ".")
				Case 2 ; Date And Time.
					$sLoadedProperty = __GetFileTime($sFilePath, $aEnvArray[$A][0], $aEnvArray[$A][2])
					$sLoadedProperty = StringReplace($sLoadedProperty, ":", ".")
				Case 3 ; Hash.
					$sLoadedProperty = __GetFileHash($sFilePath, $aEnvArray[$A][2])
				Case 4 ; Exif.
					$sLoadedProperty = __GetFileExif($sFilePath, $aEnvArray[$A][2])
				Case 5 ; Macro.
					$sLoadedProperty = __GetDefinedMacro($aEnvArray[$A][2])
				Case 6 ; User Input.
					$sLoadedProperty = __GetUserInput($sDestination, __GetFileName($sFilePath), $sAction)
			EndSwitch
			If StringStripWS($sLoadedProperty, 8) == "" And $aEnvArray[$A][0] <> "SubDir" Then
				$sLoadedProperty = StringReplace(__GetLang('ENV_VAR_UNKNOWN', 'Unknown %Abbreviation%', 1), "%Abbreviation%", $aEnvArray[$A][0])
			EndIf
			$sDestination = _Modifier_StringReplaceModifier($sDestination, $aEnvArray[$A][0], $sLoadedProperty)
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

Func __GetFileParameter($sFilePath, $sMainDir, $sProfileName, $iParameterCode)
	Local $sReturn = '', $aProfile[1]

	Switch $iParameterCode
		Case 1 ; File Extension.
			$sReturn = __GetFileExtension($sFilePath)
		Case 2 ; File Name.
			$sReturn = __GetFileNameOnly($sFilePath)
		Case 3 ; File Name With Extension.
			$sReturn = __GetFileName($sFilePath)
		Case 4 ; Parent Folder Path.
			$sReturn = __GetParentFolder($sFilePath)
		Case 5 ; Parent Folder Name.
			$sReturn = __GetFileName(__GetParentFolder($sFilePath))
		Case 6 ; Portable Drive Letter.
			$sReturn = StringLeft(@ScriptFullPath, 2)
		Case 7 ; Recreated Directory Structure.
			$sReturn = StringTrimLeft(__GetParentFolder($sFilePath), StringLen($sMainDir))
		Case 8 ; Profile Name.
			$aProfile = __IsProfile($sProfileName, 0) ; Get Array Of Selected Profile.
			$sReturn = $aProfile[1]
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
		$sReturn = $aTime[3] & ":" & $aTime[4] ; HH.MM.
	ElseIf StringInStr($sTimeVariable, "Year") Then
		$sReturn = $aTime[0] ; YYYY.
	ElseIf StringInStr($sTimeVariable, "MonthName") Then
		$sReturn = __Locale_MonthName($aTime[1], 0) ; [November].
	ElseIf StringInStr($sTimeVariable, "MonthShort") Then
		$sReturn = __Locale_MonthName($aTime[1], 1) ; [Nov].
	ElseIf StringInStr($sTimeVariable, "Month") Then
		$sReturn = $aTime[1] ; MM.
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

Func __GetDefinedMacro($iMacroCode)
	Local $sReturn = ''

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
			$sReturn = @HOUR & ":" & @MIN
		Case 19 ; Current Hour.
			$sReturn = @HOUR
		Case 20 ; Current Minute.
			$sReturn = @MIN
		Case 21 ; Current Second.
			$sReturn = @SEC
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
