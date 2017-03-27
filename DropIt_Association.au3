
; Association funtions of DropIt

#include-once
#include <DropIt_General.au3>
#include <DropIt_Global.au3>
#include "Lib\udf\DropIt_LibVarious.au3"

Func __GetActionResult($gAction)
	#cs
		Description: Get Action Result [Copied].
	#ce
	Local $gSyntaxMode
	Switch $gAction
		Case "$1"
			$gSyntaxMode = __GetLang('POSITIONPROCESS_LOG_6', 'Copied')
		Case "$3"
			$gSyntaxMode = __GetLang('POSITIONPROCESS_LOG_3', 'Compressed')
		Case "$4"
			$gSyntaxMode = __GetLang('POSITIONPROCESS_LOG_4', 'Extracted')
		Case "$5"
			$gSyntaxMode = __GetLang('POSITIONPROCESS_LOG_7', 'Opened')
		Case "$6"
			$gSyntaxMode = __GetLang('POSITIONPROCESS_LOG_8', 'Deleted')
		Case "$7"
			$gSyntaxMode = __GetLang('POSITIONPROCESS_LOG_9', 'Renamed')
		Case "$8"
			$gSyntaxMode = __GetLang('POSITIONPROCESS_LOG_10', 'Added to List')
		Case "$9"
			$gSyntaxMode = __GetLang('POSITIONPROCESS_LOG_13', 'Added to Playlist')
		Case "$A"
			$gSyntaxMode = __GetLang('POSITIONPROCESS_LOG_11', 'Shortcut Created')
		Case "$B"
			$gSyntaxMode = __GetLang('POSITIONPROCESS_LOG_12', 'Copied to Clipboard')
		Case "$C"
			$gSyntaxMode = __GetLang('POSITIONPROCESS_LOG_14', 'Uploaded')
		Case "$D"
			$gSyntaxMode = __GetLang('POSITIONPROCESS_LOG_15', 'Changed Properties')
		Case "$E"
			$gSyntaxMode = __GetLang('POSITIONPROCESS_LOG_16', 'Sent by Mail')
		Case Else
			$gSyntaxMode = __GetLang('POSITIONPROCESS_LOG_5', 'Moved')
	EndSwitch

	Return $gSyntaxMode
EndFunc   ;==>__GetActionResult

Func __GetAssociationField($gProfile, $gAction, $gAssociation, $gField)
	#cs
		Description: Get String Of The Defined Association Field.
		Returns: String [0;1;2;3;9;13]
	#ce
	Local $gStringSplit, $gNumberFields = $G_Global_NumberFields

	$gAssociation = __GetAssociationString($gAction, $gAssociation) ; Get Association String.
	$gStringSplit = StringSplit(IniRead($gProfile, "Associations", $gAssociation, ""), "|")
	If @error Then
		Return ""
	EndIf
	ReDim $gStringSplit[$gNumberFields + 1]

	Return $gStringSplit[$gField]
EndFunc   ;==>__GetAssociationField

Func __GetAssociations($gProfile = -1, $gNumberFields = $G_Global_NumberFields)
	#cs
		Description: Get Associations In The Current Profile [-1] Or Specified Profile Name [Valid Profile Name].
		Returns: Array[0][0] - Number Of Items [?]
		[0][1] - Number Of Fields [6]
		[0][2] - Profile Name [Profile Name]

		Array[A][0] - Rule [*.exe$2]
		[A][1] - Destination [C:\DropIt Files]
		[A][2] - Association Name [Executables]
		[A][3] - Filters [1<20MB;1<20d;1<20d;1<20d]
		[A][4] - Association Enabled/Disabled [Enabled]
		[A][5] - List Properties [0;1;2;3;9;13]
		[A][6] - FTP Settings [Host;Port;User;Password]
	#ce
	$gProfile = __IsProfile($gProfile, 0) ; Get Array Of Selected Profile.

	Local $g_IniReadSection = __IniReadSection($gProfile[0], "Associations")
	If @error Then
		Local $gReturn[1][$gNumberFields + 1] = [[0, $gNumberFields, $gProfile[1]]]
		Return $gReturn
	EndIf

	Local $gStringSplit
	Local $gReturn[$g_IniReadSection[0][0] + 1][$gNumberFields + 1] = [[0, $gNumberFields, $gProfile[1]]]

	For $A = 1 To $g_IniReadSection[0][0]
		$gStringSplit = StringSplit($g_IniReadSection[$A][1], "|")
		If @error Then
			IniDelete($gProfile[0], "Associations", $g_IniReadSection[$A][0])
			ContinueLoop
		EndIf
		ReDim $gStringSplit[$gNumberFields + 1]

		$gReturn[$A][0] = $g_IniReadSection[$A][0]
		For $B = 1 To $gNumberFields
			$gReturn[$A][$B] = $gStringSplit[$B]
		Next
		$gReturn[0][0] += 1
	Next
	ReDim $gReturn[$gReturn[0][0] + 1][$gNumberFields + 1] ; Delete Empty Rows.
	Return $gReturn
EndFunc   ;==>__GetAssociations

Func __GetAssociationString($gAction, $gRule = "")
	#cs
		Description: Get Association String [*.txt$1] Or Action Name [Copy] Or Action Code [$1].
	#ce
	Local $gAssociationString

	If StringLeft($gAction, 1) = "$" Then
		Switch $gAction
			Case "$1"
				$gAssociationString = __GetLang('ACTION_COPY', 'Copy')
			Case "$2"
				$gAssociationString = __GetLang('ACTION_IGNORE', 'Ignore')
			Case "$3"
				$gAssociationString = __GetLang('ACTION_COMPRESS', 'Compress')
			Case "$4"
				$gAssociationString = __GetLang('ACTION_EXTRACT', 'Extract')
			Case "$5"
				$gAssociationString = __GetLang('ACTION_OPEN_WITH', 'Open With')
			Case "$6"
				$gAssociationString = __GetLang('ACTION_DELETE', 'Delete')
			Case "$7"
				$gAssociationString = __GetLang('ACTION_RENAME', 'Rename')
			Case "$8"
				$gAssociationString = __GetLang('ACTION_LIST', 'Create List')
			Case "$9"
				$gAssociationString = __GetLang('ACTION_PLAYLIST', 'Create Playlist')
			Case "$A"
				$gAssociationString = __GetLang('ACTION_SHORTCUT', 'Create Shortcut')
			Case "$B"
				$gAssociationString = __GetLang('ACTION_CLIPBOARD', 'Copy to Clipboard')
			Case "$C"
				$gAssociationString = __GetLang('ACTION_UPLOAD', 'Upload')
			Case "$D"
				$gAssociationString = __GetLang('ACTION_CHANGE_PROPERTIES', 'Change Properties')
			Case "$E"
				$gAssociationString = __GetLang('ACTION_SEND_MAIL', 'Send by Mail')
			Case Else ; Move.
				$gAssociationString = __GetLang('ACTION_MOVE', 'Move')
		EndSwitch
	Else
		Switch $gAction
			Case __GetLang('ACTION_COPY', 'Copy'), 'Copy'
				$gAssociationString = $gRule & "$1"
			Case __GetLang('ACTION_IGNORE', 'Ignore'), 'Ignore'
				$gAssociationString = $gRule & "$2"
			Case __GetLang('ACTION_COMPRESS', 'Compress'), 'Compress'
				$gAssociationString = $gRule & "$3"
			Case __GetLang('ACTION_EXTRACT', 'Extract'), 'Extract'
				$gAssociationString = $gRule & "$4"
			Case __GetLang('ACTION_OPEN_WITH', 'Open With'), 'Open With'
				$gAssociationString = $gRule & "$5"
			Case __GetLang('ACTION_DELETE', 'Delete'), 'Delete'
				$gAssociationString = $gRule & "$6"
			Case __GetLang('ACTION_RENAME', 'Rename'), 'Rename'
				$gAssociationString = $gRule & "$7"
			Case __GetLang('ACTION_LIST', 'Create List'), 'Create List'
				$gAssociationString = $gRule & "$8"
			Case __GetLang('ACTION_PLAYLIST', 'Create Playlist'), 'Create Playlist'
				$gAssociationString = $gRule & "$9"
			Case __GetLang('ACTION_SHORTCUT', 'Create Shortcut'), 'Create Shortcut'
				$gAssociationString = $gRule & "$A"
			Case __GetLang('ACTION_CLIPBOARD', 'Copy to Clipboard'), 'Copy to Clipboard'
				$gAssociationString = $gRule & "$B"
			Case __GetLang('ACTION_UPLOAD', 'Upload'), 'Upload'
				$gAssociationString = $gRule & "$C"
			Case __GetLang('ACTION_CHANGE_PROPERTIES', 'Change Properties'), 'Change Properties'
				$gAssociationString = $gRule & "$D"
			Case __GetLang('ACTION_SEND_MAIL', 'Send by Mail'), 'Send by Mail'
				$gAssociationString = $gRule & "$E"
			Case Else ; __GetLang('ACTION_MOVE', 'Move').
				$gAssociationString = $gRule & "$0"
		EndSwitch
	EndIf

	Return $gAssociationString
EndFunc   ;==>__GetAssociationString

Func __SetAssociationState($sProfile, $sAssociation, $sState)
	#cs
		Description: Enable/Disable The Association.
		Return: 1
	#ce
	Local $sNewString, $sStringSplit, $sNumberFields = $G_Global_NumberFields

	$sStringSplit = StringSplit(IniRead($sProfile, "Associations", $sAssociation, ""), "|")
	ReDim $sStringSplit[$sNumberFields + 1]
	If $sState Then
		$sStringSplit[4] = "Enabled"
	Else
		$sStringSplit[4] = "Disabled"
	EndIf

	For $A = 1 To $sNumberFields
		If $A <> 1 Then
			$sNewString &= "|"
		EndIf
		$sNewString &= $sStringSplit[$A]
	Next
	__IniWriteEx($sProfile, "Associations", $sAssociation, $sNewString)

	Return 1
EndFunc   ;==>__SetAssociationState
