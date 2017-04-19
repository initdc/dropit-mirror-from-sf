
; Association funtions of DropIt

#include-once
#include <Crypt.au3>

#include "DropIt_General.au3"
#include "DropIt_Global.au3"
#include "Lib\udf\DropIt_LibVarious.au3"

Func __UpgradeAssociations($gProfilePath)
	#cs
		Description: Convert Associations From Old DropIt Version (<5.1) To New One.
	#ce
	Local $gSection = __IniReadSection($gProfilePath, "Associations")
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Local $gStringSplit, $gSubStringSplit, $gTheme, $gSite
	For $A = 1 To $gSection[0][0]
		$gStringSplit = StringSplit($gSection[$A][1], "|") ; Parameters With Old Divider.
		If @error Then
			ContinueLoop
		EndIf
		ReDim $gStringSplit[7]

		$gStringSplit[2] = StringRegExpReplace($gStringSplit[2], "[;#|\[\]]", "") ; Association Name.
		If $gStringSplit[4] == "" Then ; State.
			$gStringSplit[4] = $G_Global_StateEnabled
		EndIf
		If $gStringSplit[3] <> "" Then ; Filters Defined.
			$gSubStringSplit = StringSplit($gStringSplit[3], ";", 2) ; Filters With Old Divider.
			ReDim $gSubStringSplit[$STATIC_FILTERS_NUMBER] ; Number Of Filters.
			$gStringSplit[3] = ""
			For $B = 0 To $STATIC_FILTERS_NUMBER - 2
				$gStringSplit[3] &= $gSubStringSplit[$B]
				If $B = 8 Then ; Add An Extra Divider Because "File Content" Filter Is Moved To The Next Position Of The Array.
					$gStringSplit[3] &= $STATIC_FILTERS_DIVIDER
				EndIf
				If $B < $STATIC_FILTERS_NUMBER - 2 Then
					$gStringSplit[3] &= $STATIC_FILTERS_DIVIDER
				EndIf
			Next
		EndIf
		If StringInStr($gStringSplit[6], ";") Then
			$gTheme = ""
			$gSite = $gStringSplit[6]
		Else
			$gTheme = $gStringSplit[6]
			$gSite = ""
		EndIf

		__PasteAssociation($gProfilePath, $gStringSplit[2], "State=" & $gStringSplit[4] & @LF & "Rules=" & StringTrimRight($gSection[$A][0], 2) & @LF & _
				"Action=" & StringRight($gSection[$A][0], 2) & @LF & "Destination=" & $gStringSplit[1] & _
				__ComposeLineINI("Filters", $gStringSplit[3]) & _
				__ComposeLineINI("ListProperties", $gStringSplit[5]) & _
				__ComposeLineINI("HTMLTheme", $gTheme) & _
				__ComposeLineINI("SiteSettings", $gSite))
	Next
	Return 1
EndFunc   ;==>__UpgradeAssociations

Func __GetActionResult($gAction)
	#cs
		Description: Get Action Result [Copied].
	#ce
	Local $gReturn

	Switch $gAction
		Case "$1"
			$gReturn = __GetLang('POSITIONPROCESS_LOG_6', 'Copied')
		Case "$3"
			$gReturn = __GetLang('POSITIONPROCESS_LOG_3', 'Compressed')
		Case "$4"
			$gReturn = __GetLang('POSITIONPROCESS_LOG_4', 'Extracted')
		Case "$5"
			$gReturn = __GetLang('POSITIONPROCESS_LOG_7', 'Opened')
		Case "$6"
			$gReturn = __GetLang('POSITIONPROCESS_LOG_8', 'Deleted')
		Case "$7"
			$gReturn = __GetLang('POSITIONPROCESS_LOG_9', 'Renamed')
		Case "$8"
			$gReturn = __GetLang('POSITIONPROCESS_LOG_10', 'Added to List')
		Case "$9"
			$gReturn = __GetLang('POSITIONPROCESS_LOG_13', 'Added to Playlist')
		Case "$A"
			$gReturn = __GetLang('POSITIONPROCESS_LOG_11', 'Shortcut Created')
		Case "$B"
			$gReturn = __GetLang('POSITIONPROCESS_LOG_12', 'Copied to Clipboard')
		Case "$C"
			$gReturn = __GetLang('POSITIONPROCESS_LOG_14', 'Uploaded')
		Case "$D"
			$gReturn = __GetLang('POSITIONPROCESS_LOG_15', 'Changed Properties')
		Case "$E"
			$gReturn = __GetLang('POSITIONPROCESS_LOG_16', 'Sent by Mail')
		Case "$F"
			$gReturn = __GetLang('POSITIONPROCESS_LOG_17', 'Encrypted')
		Case "$G"
			$gReturn = __GetLang('POSITIONPROCESS_LOG_18', 'Decrypted')
		Case "$H"
			$gReturn = __GetLang('POSITIONPROCESS_LOG_19', 'Added to Gallery')
		Case "$I"
			$gReturn = __GetLang('POSITIONPROCESS_LOG_20', 'Split')
		Case "$J"
			$gReturn = __GetLang('POSITIONPROCESS_LOG_21', 'Joined')
		Case "$M"
			$gReturn = __GetLang('POSITIONPROCESS_LOG_22', 'Printed')
		Case Else
			$gReturn = __GetLang('POSITIONPROCESS_LOG_5', 'Moved')
	EndSwitch

	Return $gReturn
EndFunc   ;==>__GetActionResult

Func __GetActionString($gAction)
	#cs
		Description: Get Action Name [Copy] Or Action Code [$1].
	#ce
	Local $gReturn

	If StringLeft($gAction, 1) = "$" Then
		Switch $gAction
			Case "$1"
				$gReturn = __GetLang('ACTION_COPY', 'Copy')
			Case "$2"
				$gReturn = __GetLang('ACTION_IGNORE', 'Ignore')
			Case "$3"
				$gReturn = __GetLang('ACTION_COMPRESS', 'Compress')
			Case "$4"
				$gReturn = __GetLang('ACTION_EXTRACT', 'Extract')
			Case "$5"
				$gReturn = __GetLang('ACTION_OPEN_WITH', 'Open With')
			Case "$6"
				$gReturn = __GetLang('ACTION_DELETE', 'Delete')
			Case "$7"
				$gReturn = __GetLang('ACTION_RENAME', 'Rename')
			Case "$8"
				$gReturn = __GetLang('ACTION_LIST', 'Create List')
			Case "$9"
				$gReturn = __GetLang('ACTION_PLAYLIST', 'Create Playlist')
			Case "$A"
				$gReturn = __GetLang('ACTION_SHORTCUT', 'Create Shortcut')
			Case "$B"
				$gReturn = __GetLang('ACTION_CLIPBOARD', 'Copy to Clipboard')
			Case "$C"
				$gReturn = __GetLang('ACTION_UPLOAD', 'Upload')
			Case "$D"
				$gReturn = __GetLang('ACTION_CHANGE_PROPERTIES', 'Change Properties')
			Case "$E"
				$gReturn = __GetLang('ACTION_SEND_MAIL', 'Send by Mail')
			Case "$F"
				$gReturn = __GetLang('ACTION_ENCRYPT', 'Encrypt')
			Case "$G"
				$gReturn = __GetLang('ACTION_DECRYPT', 'Decrypt')
			Case "$H"
				$gReturn = __GetLang('ACTION_GALLERY', 'Create Gallery')
			Case "$I"
				$gReturn = __GetLang('ACTION_SPLIT', 'Split')
			Case "$J"
				$gReturn = __GetLang('ACTION_JOIN', 'Join')
			Case "$M"
				$gReturn = __GetLang('ACTION_PRINT', 'Print')
			Case Else ; Move.
				$gReturn = __GetLang('ACTION_MOVE', 'Move')
		EndSwitch
	Else
		Switch $gAction
			Case __GetLang('ACTION_COPY', 'Copy'), 'Copy'
				$gReturn = "$1"
			Case __GetLang('ACTION_IGNORE', 'Ignore'), 'Ignore'
				$gReturn = "$2"
			Case __GetLang('ACTION_COMPRESS', 'Compress'), 'Compress'
				$gReturn = "$3"
			Case __GetLang('ACTION_EXTRACT', 'Extract'), 'Extract'
				$gReturn = "$4"
			Case __GetLang('ACTION_OPEN_WITH', 'Open With'), 'Open With'
				$gReturn = "$5"
			Case __GetLang('ACTION_DELETE', 'Delete'), 'Delete'
				$gReturn = "$6"
			Case __GetLang('ACTION_RENAME', 'Rename'), 'Rename'
				$gReturn = "$7"
			Case __GetLang('ACTION_LIST', 'Create List'), 'Create List'
				$gReturn = "$8"
			Case __GetLang('ACTION_PLAYLIST', 'Create Playlist'), 'Create Playlist'
				$gReturn = "$9"
			Case __GetLang('ACTION_SHORTCUT', 'Create Shortcut'), 'Create Shortcut'
				$gReturn = "$A"
			Case __GetLang('ACTION_CLIPBOARD', 'Copy to Clipboard'), 'Copy to Clipboard'
				$gReturn = "$B"
			Case __GetLang('ACTION_UPLOAD', 'Upload'), 'Upload'
				$gReturn = "$C"
			Case __GetLang('ACTION_CHANGE_PROPERTIES', 'Change Properties'), 'Change Properties'
				$gReturn = "$D"
			Case __GetLang('ACTION_SEND_MAIL', 'Send by Mail'), 'Send by Mail'
				$gReturn = "$E"
			Case __GetLang('ACTION_ENCRYPT', 'Encrypt'), 'Encrypt'
				$gReturn = "$F"
			Case __GetLang('ACTION_DECRYPT', 'Decrypt'), 'Decrypt'
				$gReturn = "$G"
			Case __GetLang('ACTION_GALLERY', 'Create Gallery'), 'Create Gallery'
				$gReturn = "$H"
			Case __GetLang('ACTION_SPLIT', 'Split'), 'Split'
				$gReturn = "$I"
			Case __GetLang('ACTION_JOIN', 'Join'), 'Join'
				$gReturn = "$J"
			Case __GetLang('ACTION_PRINT', 'Print'), 'Print'
				$gReturn = "$M"
			Case Else ; __GetLang('ACTION_MOVE', 'Move').
				$gReturn = "$0"
		EndSwitch
	EndIf

	Return $gReturn
EndFunc   ;==>__GetActionString

Func __GetAlgorithmString($gString, $gGetCode = 0)
	#cs
		Description: Get Encryption Algorithm Mode [3DES] Or Encryption Algorithm Code [$CALG_3DES].
	#ce
	Local $gReturn

	If $gGetCode Then
		Switch $gString
			Case "AES (128bit)"
				$gReturn = $CALG_AES_128
			Case "AES (192bit)"
				$gReturn = $CALG_AES_192
			Case "AES (256bit)"
				$gReturn = $CALG_AES_256
			Case "DES"
				$gReturn = $CALG_DES
			Case "RC2"
				$gReturn = $CALG_RC2
			Case "RC4"
				$gReturn = $CALG_RC4
			Case Else ; "3DES".
				$gReturn = $CALG_3DES
		EndSwitch
	Else
		Switch $gString
			Case $CALG_AES_128
				$gReturn = "AES (128bit)"
			Case $CALG_AES_192
				$gReturn = "AES (192bit)"
			Case $CALG_AES_256
				$gReturn = "AES (256bit)"
			Case $CALG_DES
				$gReturn = "DES"
			Case $CALG_RC2
				$gReturn = "RC2"
			Case $CALG_RC4
				$gReturn = "RC4"
			Case Else ; $CALG_3DES.
				$gReturn = "3DES"
		EndSwitch
	EndIf

	Return $gReturn
EndFunc   ;==>__GetAlgorithmString

Func __GetDeleteString($gString)
	#cs
		Description: Get Delete Action Mode [Safely Erase] Or Delete Action Code [2].
	#ce
	Local $gReturn

	If StringIsDigit($gString) Then
		Switch $gString
			Case 2
				$gReturn = __GetLang('DELETE_MODE_2', 'Safely Erase')
			Case 3
				$gReturn = __GetLang('DELETE_MODE_3', 'Send to Recycle Bin')
			Case Else ; 1.
				$gReturn = __GetLang('DELETE_MODE_1', 'Directly Remove')
		EndSwitch
	Else
		Switch $gString
			Case __GetLang('DELETE_MODE_2', 'Safely Erase'), 'Safely Erase'
				$gReturn = 2
			Case __GetLang('DELETE_MODE_3', 'Send to Recycle Bin'), 'Send to Recycle Bin'
				$gReturn = 3
			Case Else ; Directly Remove.
				$gReturn = 1
		EndSwitch
	EndIf

	Return $gReturn
EndFunc   ;==>__GetDeleteString

Func __GetDestinationString($gAction, $gDestination, $gSiteSettings = -1)
	#cs
		Description: Get Destination To Show [Defined Settings].
	#ce
	Local $gStringSplit

	Switch $gAction
		Case "$6"
			$gDestination = __GetDeleteString($gDestination)
		Case "$3", "$4", "$5", "$8", "$F", "$G", "$H", "$I", "$J"
			$gStringSplit = StringSplit($gDestination, "|")
			$gDestination = $gStringSplit[1]
		Case "$C"
			$gStringSplit = StringSplit($gDestination, "|")
			$gDestination = $gStringSplit[1]
			ReDim $gStringSplit[3] ; Only One More Than Needed.
			If $gSiteSettings == -1 Then
				$gSiteSettings = $gStringSplit[2]
			EndIf
			$gStringSplit = StringSplit($gSiteSettings, ";")
			$gDestination = $gStringSplit[1] & $gDestination
		Case "$D"
			$gDestination = __GetLang('CHANGE_PROPERTIES_DEFINED', 'Defined Properties')
		Case "$E"
			$gStringSplit = StringSplit($gDestination, ";")
			ReDim $gStringSplit[9] ; Only One More Than Needed.
			If $gStringSplit[8] <> "" Then
				$gDestination = $gStringSplit[8] ; To Email Address.
			Else
				$gDestination = __GetLang('MAIL_SETTINGS_DEFINED', 'Defined Settings')
			EndIf
	EndSwitch

	Return $gDestination
EndFunc   ;==>__GetDestinationString

Func __GetListCode($gAction, $gListPath)
	#cs
		Description: Get The List Code For The Defined Action [2].
	#ce
	Local $gReturn, $gError, $gExtension = __GetFileExtension($gListPath)

	Switch $gAction
		Case __GetLang('ACTION_LIST', 'Create List')
			Switch $gExtension
				Case "html", "htm"
					$gReturn = 1
				Case "pdf"
					$gReturn = 2
				Case "xls"
					$gReturn = 3
				Case "csv"
					$gReturn = 4
				Case "txt"
					$gReturn = 5
				Case "xml"
					$gReturn = 6
				Case Else
					$gReturn = 1
					$gError = 1
			EndSwitch
		Case __GetLang('ACTION_COMPRESS', 'Compress')
			Switch $gExtension
				Case "zip"
					$gReturn = 1
				Case "7z"
					$gReturn = 2
				Case "exe"
					$gReturn = 3
				Case Else
					$gReturn = 1
					$gError = 1
			EndSwitch
		Case __GetLang('ACTION_PLAYLIST', 'Create Playlist')
			Switch $gExtension
				Case "m3u"
					$gReturn = 1
				Case "m3u8"
					$gReturn = 2
				Case "pls"
					$gReturn = 3
				Case "wpl"
					$gReturn = 4
				Case Else
					$gReturn = 1
					$gError = 1
			EndSwitch
	EndSwitch

	If $gError Then
		Return SetError(1, 0, $gReturn)
	EndIf
	Return $gReturn
EndFunc   ;==>__GetListCode

Func __GetPropertyStringCode($gString, $gMode = 0)
	#cs
		Description: Get Property String [Turn On] Or Property Code [1].
	#ce
	Local $gReturn

	If $gMode = 0 Then
		Switch $gString
			Case 1
				$gReturn = __GetLang('CHANGE_PROPERTIES_MODE_1', 'Turn On')
			Case 2
				$gReturn = __GetLang('CHANGE_PROPERTIES_MODE_2', 'Turn Off')
			Case 3
				$gReturn = __GetLang('CHANGE_PROPERTIES_MODE_3', 'Switch')
			Case Else
				$gReturn = __GetLang('CHANGE_PROPERTIES_MODE_0', 'No Change')
		EndSwitch
	Else
		Switch $gString
			Case __GetLang('CHANGE_PROPERTIES_MODE_1', 'Turn On')
				$gReturn = 1
			Case __GetLang('CHANGE_PROPERTIES_MODE_2', 'Turn Off')
				$gReturn = 2
			Case __GetLang('CHANGE_PROPERTIES_MODE_3', 'Switch')
				$gReturn = 3
			Case Else ; No Change.
				$gReturn = 0
		EndSwitch
	EndIf

	Return $gReturn
EndFunc   ;==>__GetPropertyStringCode

Func __GetSizeStringCode($gString, $gMode = 0)
	#cs
		Description: Get Size String [bytes] Or Size Code [bytes].
	#ce
	Local $gReturn

	If $gMode = 0 Then
		Switch $gString
			Case "bytes"
				$gReturn = __GetLang('SIZE_B', 'bytes')
			Case "MB"
				$gReturn = __GetLang('SIZE_MB', 'MB')
			Case "GB"
				$gReturn = __GetLang('SIZE_GB', 'GB')
			Case Else
				$gReturn = __GetLang('SIZE_KB', 'KB')
		EndSwitch
	Else
		Switch $gString
			Case __GetLang('SIZE_B', 'bytes')
				$gReturn = "bytes"
			Case __GetLang('SIZE_MB', 'MB')
				$gReturn = "MB"
			Case __GetLang('SIZE_GB', 'GB')
				$gReturn = "GB"
			Case Else ; KB.
				$gReturn = "KB"
		EndSwitch
	EndIf

	Return $gReturn
EndFunc   ;==>__GetSizeStringCode

Func __GetTimeStringCode($gString, $gMode = 0)
	#cs
		Description: Get Time String [Seconds] Or Time Code [s].
	#ce
	Local $gReturn

	If $gMode = 0 Then
		Switch $gString
			Case "s"
				$gReturn = __GetLang('TIME_SECONDS', 'Seconds')
			Case "n"
				$gReturn = __GetLang('TIME_MINUTES', 'Minutes')
			Case "h"
				$gReturn = __GetLang('TIME_HOURS', 'Hours')
			Case "M"
				$gReturn = __GetLang('TIME_MONTHS', 'Months')
			Case "Y"
				$gReturn = __GetLang('TIME_YEARS', 'Years')
			Case Else
				$gReturn = __GetLang('TIME_DAYS', 'Days')
		EndSwitch
	Else
		Switch $gString
			Case __GetLang('TIME_SECONDS', 'Seconds')
				$gReturn = "s"
			Case __GetLang('TIME_MINUTES', 'Minutes')
				$gReturn = "n"
			Case __GetLang('TIME_HOURS', 'Hours')
				$gReturn = "h"
			Case __GetLang('TIME_MONTHS', 'Months')
				$gReturn = "M"
			Case __GetLang('TIME_YEARS', 'Years')
				$gReturn = "Y"
			Case Else ; Days.
				$gReturn = "D"
		EndSwitch
	EndIf

	Return $gReturn
EndFunc   ;==>__GetTimeStringCode

Func __GetAssociationField($gProfile, $gAssociationName, $gField)
	#cs
		Description: Get String Of The Defined Association Field.
		Returns: String [*.png;*.jpg]
	#ce
	If $gAssociationName = "" Then
		Return SetError(1, 0, "")
	EndIf
	If $gProfile = -1 Then
		$gProfile = __IsProfile($gProfile, 1) ; Get Current Profile Path.
	EndIf
	Return IniRead($gProfile, $gAssociationName, $gField, "")
EndFunc   ;==>__GetAssociationField

Func __GetAssociationKey($gParameter = -1, $gType = 0)
	#cs
		Description: Get A Key String ($gParameter = Number) Or A Key Number ($gParameter = String).
		Returns: Key $gType = 0 [ExtractSettings] Or Key $gType = 1 [EXTRACT SETTINGS]
	#ce
	Local $gIsNumber = StringIsDigit($gParameter), $gNumberFields = 21
	If $gParameter = -1 Then
		Return $gNumberFields
	EndIf
	Local $gFields[$gNumberFields] = ["Name", "State", "Rules", "Action", "Destination", "Filters", "List Properties", "HTML Theme", "Site Settings", "Crypt Settings", "Gallery Properties", _
			"Gallery Theme", "Gallery Settings", "Compress Settings", "Extract Settings", "Open With Settings", "List Settings", "Favourite Association", "Use RegEx", "Split Settings", "Join Settings"]
	For $A = 0 To $gNumberFields
		If $gType = 0 Then
			$gFields[$A] = StringStripWS($gFields[$A], 8)
		Else
			$gFields[$A] = StringUpper($gFields[$A])
		EndIf
		If $gIsNumber And $gParameter = $A Then
			Return $gFields[$A]
		ElseIf $gIsNumber = 0 And $gParameter = $gFields[$A] Then
			Return $A
		EndIf
	Next
	Return SetError(1, 0, "")
EndFunc   ;==>__GetAssociationKey

Func __GetAssociations($gProfile = -1)
	#cs
		Description: Get Associations Of The Current Profile [-1] Or Specified Profile Name [Valid Profile Name].
		Returns: Array[0][0] - Number Of Items [?]
		[0][1] - Number Of Fields [21]
		[0][2] - Profile Name [Profile]

		Array[A][0] - Association Name [Example]
		[A][1] - State [Enabled]
		[A][2] - Rules [*.png;*.jpg]
		[A][3] - Action [$3]
		[A][4] - Destination [C:\Example]
		[A][5] - Filters [1<20MB;1<20d;1<20d;1<20d]
		[A][6] - List Properties [#=%Counter%;Name=%FileName%]
		[A][7] - HTML Theme [Default]
		[A][8] - Site Settings [Host;Port;User;Password]
		[A][9] - Crypt Settings [Algorithm|Password]
		[A][10] - Gallery Properties [#=%Counter%;Name=%FileName%]
		[A][11] - Gallery Theme [Default]
		[A][12] - Gallery Settings [2;1;]
		[A][13] - Compress Settings [False]
		[A][14] - Extract Settings [False]
		[A][15] - Open With Settings [False]
		[A][16] - List Settings [True;True;True;True]
		[A][17] - Favourite Association [False]
		[A][18] - Consider As Regular Expressions [False]
		[A][19] - Split Settings [10MB]
		[A][20] - Join Settings [False]
	#ce
	$gProfile = __IsProfile($gProfile, 0) ; Get Array Of Selected Profile.

	Local $gNumberFields = __GetAssociationKey(-1)
	Local $gAssociationNames = __IniReadSectionNamesEx($gProfile[0])
	If @error Then
		Local $gReturn[1][$gNumberFields + 1] = [[0, $gNumberFields, $gProfile[1]]]
		Return $gReturn
	EndIf

	Local $gSection, $gIndex
	Local $gReturn[$gAssociationNames[0] + 1][$gNumberFields + 1] = [[0, $gNumberFields, $gProfile[1]]]

	For $A = 1 To $gAssociationNames[0]
		If $gAssociationNames[$A] = $G_Global_GeneralSection Or $gAssociationNames[$A] = $G_Global_TargetSection Then
			ContinueLoop
		EndIf
		$gSection = __IniReadSection($gProfile[0], $gAssociationNames[$A])
		If @error Then
			ContinueLoop
		EndIf
		$gReturn[0][0] += 1
		$gReturn[$gReturn[0][0]][0] = $gAssociationNames[$A]
		For $B = 1 To $gSection[0][0]
			$gIndex = __GetAssociationKey($gSection[$B][0])
			If @error Then
				ContinueLoop
			EndIf
			$gReturn[$gReturn[0][0]][$gIndex] = $gSection[$B][1]
		Next
	Next

	ReDim $gReturn[$gReturn[0][0] + 1][$gNumberFields + 1] ; Delete Empty Rows.
	Return $gReturn
EndFunc   ;==>__GetAssociations

Func __PasteAssociation($sToProfilePath, $sAssociationName, $aSectionToWrite)
	Local $A = 0, $iNumber = ""

	While 1
		__IniReadSection($sToProfilePath, $sAssociationName & $iNumber)
		If @error Then ; Section Name Does Not Exist.
			ExitLoop
		EndIf
		$A += 1
		$iNumber = " " & StringFormat("%02d", $A)
	WEnd
	__IniWriteEx($sToProfilePath, $sAssociationName & $iNumber, "", $aSectionToWrite)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__PasteAssociation

Func __SetAssociationName($sNewAssociationName, $sOldAssociationName, $sProfilePath, $iIsNewAssociation, $hGUI)
	#cs
		Description: Define New Association And Report If The Name Already Exists.
		Return: 1
	#ce
	Local $iMsgBox = 6

	If __StringIsValid($sNewAssociationName, ';#|[]') = 0 Then
		MsgBox(0x30, __GetLang('MANAGE_EDIT_MSGBOX_4', 'Association Error'), __GetLang('MANAGE_EDIT_MSGBOX_36', 'You cannot use the following characters in association name:') & @LF & "; # | [ ]", 0, __OnTop($hGUI))
		Return SetError(1, 0, $sNewAssociationName)
	EndIf
	__IniReadSection($sProfilePath, $sNewAssociationName)
	If @error = 0 Then ; Section Name Already Exists.
		If $sNewAssociationName <> $sOldAssociationName Then
			$iMsgBox = MsgBox(0x4, __GetLang('MANAGE_EDIT_MSGBOX_2', 'Replace association'), __GetLang('MANAGE_EDIT_MSGBOX_3', 'This association already exists. Do you want to replace it?'), 0, __OnTop($hGUI))
		EndIf
		If $iMsgBox = 6 Then
			IniDelete($sProfilePath, $sNewAssociationName) ; Remove The New Section Name If Replaced.
		EndIf
	EndIf
	If $iMsgBox <> 6 Then
		Return SetError(1, 0, $sNewAssociationName)
	EndIf
	If $iIsNewAssociation = 0 Then
		IniDelete($sProfilePath, $sOldAssociationName) ; Remove The Old Section Name.
	EndIf

	Return $sNewAssociationName
EndFunc   ;==>__SetAssociationName

Func __SetAssociationState($sProfilePath, $sAssociationName, $sState)
	#cs
		Description: Enable/Disable The Association.
		Return: 1
	#ce
	If $sAssociationName = "" Then
		Return SetError(1, 0, 0)
	EndIf
	If $sState Then
		$sState = $G_Global_StateEnabled
	Else
		$sState = $G_Global_StateDisabled
	EndIf
	__IniWriteEx($sProfilePath, $sAssociationName, "State", $sState)
	Return 1
EndFunc   ;==>__SetAssociationState
