
; Archive funtions of DropIt

#include-once
#include <Constants.au3>
#include <Date.au3>
#include <GUIConstantsEx.au3>
#include <String.au3>
#include <WinAPIFiles.au3>
#include <WinAPIShPath.au3>
#include <WindowsConstants.au3>

#include "DropIt_Duplicate.au3"
#include "DropIt_General.au3"
#include "DropIt_Global.au3"
#include "Lib\udf\DropIt_LibFiles.au3"
#include "Lib\udf\DropIt_LibVarious.au3"

Func __7ZipGetPassword($sFilePath, $sPassword = "")
	#cs
		Description: Verify If The Archive Is Encrypted And Get Password.
		Returns: Password
	#ce
	__7ZipRun($sFilePath, "", 2) ; Check If Archive Is Encrypted.
	Switch @error
		Case 1
			Return SetError(1, 0, "") ; Failed.
		Case 2 ; Password Needed.
			If $sPassword = "" Then
				__ExpandEventMode(0) ; Disable Event Buttons.
				$sPassword = __InsertPassword_GUI($sFilePath)
				__ExpandEventMode(1) ; Enable Event Buttons.
				If $sPassword = -1 Then
					Return SetError(2, 0, "") ; Skipped.
				EndIf
			EndIf
			If $sPassword = "" Then
				Return SetError(1, 0, "") ; Failed.
			EndIf
	EndSwitch

	Return $sPassword
EndFunc   ;==>__7ZipGetPassword

Func __7ZipRun($rSourceFilePath, $rDestinationFilePath, $rType = 0, $rDuplicateMode = 0, $rNotWait = 0, $rPassword = "")
	#cs
		Description: Compress/Extract/Check Using 7-Zip.
		Returns: Output FilePath [C:\Test.7z]
	#ce
	Local $rCommand, $rProcess, $rReady, $7Zip = $G_Global_7ZipPath
	If FileExists($7Zip) = 0 Or $rSourceFilePath = "" Or ($rDestinationFilePath = "" And $rType <> 2) Then
		Return SetError(1, 0, 0)
	EndIf

	Switch $rType
		Case 0, 4 ; Compress Mode.
			$rCommand = '"' & $7Zip & '"' & __CompressCommands($rType, $rDestinationFilePath, $rPassword) & ' -- "' & $rSourceFilePath & '"'

		Case 3 ; Compress List Mode.
			$rCommand = '"' & $7Zip & '"' & __CompressCommands($rType, $rDestinationFilePath, $rPassword) & ' -- @"' & $rSourceFilePath & '"'

		Case 1 ; Extract Mode.
			$rCommand = '"' & $7Zip & '" x ' & __ExtractDuplicateMode($rDuplicateMode) & ' "-p' & $rPassword & '" -o"' & $rDestinationFilePath & '" -- "' & $rSourceFilePath & '"'

		Case 2 ; Check/List Mode.
			$rCommand = '"' & $7Zip & '" l "-p' & $rPassword & '" -bse1 -slt -- "' & $rSourceFilePath & '"'
			$rNotWait = 1 ; Force To Not Wait.

		Case Else
			Return SetError(1, 0, 0)
	EndSwitch

	If $rNotWait = 1 Then
		$rProcess = Run($rCommand, "", @SW_HIDE, $STDOUT_CHILD)
		If @error Then
			Return SetError(1, 0, 0)
		EndIf
		Do
			$rReady = ProcessExists($rProcess)
			Sleep(10)
		Until $rReady <> 0
	Else
		$rProcess = RunWait($rCommand, "", @SW_HIDE)
		If FileExists($rDestinationFilePath) = 0 Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf

	If $rType = 2 Then
		Local $rLineRead
		While 1
			$rLineRead &= StdoutRead($rProcess)
			If @error Then
				ExitLoop
			EndIf
		WEnd
		If StringInStr($rLineRead, "encrypted archive") Or StringInStr($rLineRead, "Encrypted = +") Then ; Archive Encrypted.
			Return SetError(2, 0, 0) ; Password Needed.
		ElseIf StringInStr($rLineRead, "Encrypted = -") = 0 Then ; Not Archive.
			Return SetError(1, 0, 0)
		EndIf
		Return $rLineRead
	EndIf

	Return $rProcess
EndFunc   ;==>__7ZipRun

Func __Backup_Restore($bHandle = -1, $bType = 0, $bZipFile = -1)
	#cs
		Description: Backup/Restore The Settings INI File & Profiles.
		Returns: 1
	#ce
	Local $bSettingsPath = __IsSettingsFile()
	Local $bDirectories = __GetDefault(35) ; 1 = Settings Directory, 2 = Profiles Directory, 3 = Backup Directory.

	Switch $bType
		Case 0 ; Back Up.
			If FileExists($bDirectories[3][0] & $bZipFile) Or $bZipFile = -1 Then
				$bZipFile = "DropIt_Backup_" & @YEAR & "-" & @MON & "-" & @MDAY & "[" & @HOUR & "." & @MIN & "." & @SEC & "].zip"
			EndIf
			__7ZipRun($bSettingsPath & '" "' & $bDirectories[2][0], $bDirectories[3][0] & $bZipFile, 0)
			If @error Then
				Return SetError(1, 0, 0)
			EndIf
			MsgBox(0, __GetLang('OPTIONS_BACKUP_MSGBOX_0', 'Backup Created'), __GetLang('OPTIONS_BACKUP_MSGBOX_1', 'Successfully created a DropIt Backup.'), 0, __OnTop($bHandle))

		Case 1 ; Restore.
			If FileExists($bDirectories[3][0]) = 0 Or DirGetSize($bDirectories[3][0]) = 0 Then
				$bDirectories[3][0] = $bDirectories[1][0]
			EndIf
			$bZipFile = FileOpenDialog(__GetLang('OPTIONS_BACKUP_TIP_0', 'Select a DropIt Backup'), $bDirectories[3][0], __GetLang('OPTIONS_BACKUP_TIP_1', 'DropIt Backup') & " (*.zip)", 1, "", __OnTop($bHandle))
			If @error Then
				Return SetError(1, 0, 0)
			EndIf
			Local $bTempDir = $bDirectories[1][0] & "TEMPBK\"
			__SureMove($bSettingsPath, $bTempDir & __GetFileName($bSettingsPath))
			__SureMove($bDirectories[2][0], $bTempDir & __GetFileName($bDirectories[2][0]))
			__7ZipRun($bZipFile, $bDirectories[1][0], 1, 1)
			If @error Then
				__SureMove($bTempDir & __GetFileName($bSettingsPath), $bSettingsPath)
				__SureMove($bTempDir & __GetFileName($bDirectories[2][0]), $bDirectories[2][0])
				Return SetError(1, 0, 0)
			EndIf
			DirRemove($bTempDir, 1)
			Sleep(100)
			MsgBox(0, __GetLang('OPTIONS_BACKUP_MSGBOX_2', 'Backup Restored'), __GetLang('OPTIONS_BACKUP_MSGBOX_3', 'Successfully restored the selected DropIt Backup.'), 0, __OnTop($bHandle))

		Case 2 ; Remove.
			If DirGetSize($bDirectories[3][0]) > 0 Then
				If MsgBox(0x4, __GetLang('OPTIONS_BACKUP_MSGBOX_6', 'Remove Backups'), __GetLang('OPTIONS_BACKUP_MSGBOX_7', 'Are you sure to remove all backup files?'), 0, __OnTop($bHandle)) <> 6 Then
					Return SetError(1, 0, 0)
				EndIf
			EndIf
			DirRemove($bDirectories[3][0], 1)

		Case 3 ; Auto Back Up.
			$bZipFile = $bDirectories[3][0] & "DropIt_AutoBackup.zip"
			If FileExists($bZipFile) Then
				Local $bDateArray = FileGetTime($bZipFile, 0, 0)
				If @error Then
					Return SetError(1, 0, 0)
				EndIf
				Local $bDate = StringFormat("%s/%s/%s %s:%s:%s", $bDateArray[0], $bDateArray[1], $bDateArray[2], $bDateArray[3], $bDateArray[4], $bDateArray[5])
				If _DateDiff('d', $bDate, _NowCalc()) < 3 Then
					Return SetError(1, 0, 0)
				EndIf
			EndIf
			__7ZipRun($bSettingsPath & '" "' & $bDirectories[2][0], $bZipFile, 0)

	EndSwitch
	Return 1
EndFunc   ;==>__Backup_Restore

Func __CompressCommands($cType, $cDestinationFilePath, $sCompressSettings)
	#cs
		Description: Update 7-Zip Commands And Output Archive Format.
		Returns: Needed Commands
	#ce
	Local $cEncryption, $cCommand = ' a'
	If $cType = 3 Or $cType = 4 Then ; Update Archive.
		$cCommand = ' u -ux2y2z2'
	ElseIf FileExists($cDestinationFilePath) Then ; Create New Archive.
		FileDelete($cDestinationFilePath)
	EndIf
	If IsArray($sCompressSettings) = 0 Then
		$sCompressSettings = StringSplit(__GetDefaultCompressSettings(), ";") ; 1 = Remove Source, 2 = Compress Format, 3 = Level, 4 = Method, 5 = Encryption, 6 = Password.
		ReDim $sCompressSettings[7] ; Number Of Settings.
	EndIf
	$cEncryption = StringReplace($sCompressSettings[5], "-", "")
	$sCompressSettings[6] = __StringEncrypt(0, $sCompressSettings[6], $G_Global_PasswordKey)
	If @error Then
		$cEncryption = "None"
		$sCompressSettings[6] = ""
	EndIf
	If $sCompressSettings[3] = 0 Then ; Storage Mode (No Compression).
		$sCompressSettings[4] = 'Copy'
	EndIf
	If $sCompressSettings[2] <> "zip" Then
		$cCommand &= ' -t7z'
		$cCommand &= ' -m0=' & $sCompressSettings[4]
		$cCommand &= ' -mmt=on'
		$cCommand &= ' -mx' & $sCompressSettings[3]
		If $cEncryption <> "None" Then
			$cCommand &= ' -mhe=on "-p' & $sCompressSettings[6] & '"'
		EndIf
		If $sCompressSettings[2] = "exe" Then
			$cCommand &= ' -sfx7z.sfx'
		EndIf
	Else
		$cCommand &= ' -tzip'
		$cCommand &= ' -mm=' & $sCompressSettings[4]
		$cCommand &= ' -mmt=on'
		$cCommand &= ' -mx' & $sCompressSettings[3]
		If $cEncryption <> "None" Then
			$cCommand &= ' -mem=' & $cEncryption & ' "-p' & $sCompressSettings[6] & '"'
		EndIf
	EndIf

	Return $cCommand & ' -ssw -sccUTF-8 "' & $cDestinationFilePath & '"'
EndFunc   ;==>__CompressCommands

Func __CreateTempZIP($sSource)
	Local $sFileName = __GetFileName($sSource)
	Local $sFilePath = $G_Global_TempDir & "\" & $sFileName & ".zip"
	DirCreate($G_Global_TempDir)
	If FileExists($sFilePath) Then
		$sFilePath = $G_Global_TempDir & "\" & __Duplicate_Rename($sFileName & ".zip", $G_Global_TempDir, 0, 2)
	EndIf
	__7ZipRun($sSource & "\*", $sFilePath, 0)
	If @error Then
		FileDelete($sFilePath)
		Return SetError(1, 0, 0)
	EndIf
	Return $sFilePath
EndFunc   ;==>__CreateTempZIP

Func __GetContentArchiveArray($sArchive, $sPassword)
	Local $aArray[1] = [0]
	If _WinAPI_PathIsDirectory($sArchive) Then
		Return SetError(1, 0, $aArray)
	EndIf
	Local $sText = __7ZipRun($sArchive, "", 2, 0, 1, $sPassword)
	If @error Then
		Return SetError(1, 0, $aArray)
	EndIf
	$aArray = StringRegExp($sText, '(?i)' & @CRLF & 'Path = (.*?)' & @CRLF, 3)
	$aArray[0] = UBound($aArray) - 1 ; Replace The Archive Path With The Number Of Items.
	Return $aArray
EndFunc   ;==>__GetContentArchiveArray

Func __GetDefaultCompressSettings($sCompressSettings = "", $sDestination = "")
	Local $sCompress_ZipDefault = "False;zip;5;Deflate;None;", $sCompress_7zDefault = "False;7z;5;LZMA;None;", $sCompress_ExeDefault = "False;exe;5;LZMA;None;"
	Local $sStringSplit = StringSplit($sCompressSettings, ";") ; Only To Get 2 = Compress Format.
	ReDim $sStringSplit[3]
	If $sStringSplit[2] = "" Then ; Load Default Settings If Not Defined (From Old DropIt Versions).
		$sStringSplit[2] = __GetFileExtension($sDestination)
		If $sStringSplit[2] = "7z" Then
			$sCompressSettings = $sCompress_7zDefault
		ElseIf $sStringSplit[2] = "exe" Then
			$sCompressSettings = $sCompress_ExeDefault
		Else
			$sCompressSettings = $sCompress_ZipDefault
		EndIf
	EndIf
	Return $sCompressSettings
EndFunc   ;==>__GetDefaultCompressSettings

Func __EncryptionFolder($fDecrypt = -1) ; $fDecrypt = 0, Encrypt/Decrypt Profiles.
	#cs
		Description: Create An Encrypted/Decrypted File Of The Profiles Folder. .dat Is The Extension Used For Encryption.
		Returns: Full Path Of Encrypted/Decrypted File [C:\Program Files\DropIt\Profiles.dat]
	#ce
	Local $7Zip = $G_Global_7ZipPath, $fPassword = $G_Global_EncryptionKey
	Local $fEncryptionFile = __GetDefault(1) & "Profiles.dat" ; Get Default Settings Directory.
	Local $fProfileFolder = __GetDefault(2) ; Get Default Profile Directory.
	Local $fCommand, $fFolder
	If FileExists($7Zip) = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	If FileExists($fEncryptionFile) And $fDecrypt = -1 Then
		$fDecrypt = 1
	EndIf
	Switch $fDecrypt
		Case 0 ; Encrypt.
			$fFolder = $fProfileFolder
			$fCommand = '"' & $7Zip & '" a -m0=LZMA -mx5 -p' & $fPassword & ' -sccUTF-8 -ssw' & ' "' & $fEncryptionFile & '" "' & $fFolder & '"'
			RunWait($fCommand, "", @SW_HIDE)
			Sleep(100)
			If FileExists($fEncryptionFile) Then
				DirRemove($fFolder, 1)
			EndIf

		Case 1 ; Decrypt.
			$fFolder = __GetDefault(1) ; Get Default Settings Directory.
			$fCommand = '"' & $7Zip & '" ' & 'x -p' & $fPassword & ' "' & $fEncryptionFile & '" -y -o"' & $fFolder & '"'
			RunWait($fCommand, "", @SW_HIDE)
			Sleep(100)
			If DirGetSize($fProfileFolder) <> 0 Then
				FileDelete($fEncryptionFile)
			EndIf

	EndSwitch
	Return $fEncryptionFile
EndFunc   ;==>__EncryptionFolder

Func __ExtractDuplicateMode($iDuplicateMode)
	Switch $iDuplicateMode
		Case 1 ; Overwrite.
			$iDuplicateMode = '-aoa'
		Case 2 ; Skip.
			$iDuplicateMode = '-aos'
		Case 3 ; Rename (Only "name_1.txt").
			$iDuplicateMode = '-aou'
		Case Else
			$iDuplicateMode = '-y'
	EndSwitch
	Return $iDuplicateMode
EndFunc   ;==>__ExtractDuplicateMode

Func __InsertPassword_GUI($iFilePath)
	Local $iCancel, $iGUI, $iInput, $iOK, $iPassword

	$iGUI = GUICreate(__GetLang('PASSWORD_MSGBOX_0', 'Enter Password'), 320, 150, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($G_Global_SortingGUI))
	GUICtrlCreateGraphic(0, 0, 320, 60)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlSetColor(-1, 0xffffff)

	GUICtrlCreateLabel(__GetLang('MOREMATCHES_LABEL_0', 'Loaded item:'), 10, 12, 300, 18)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlCreateLabel(__GetFileName($iFilePath), 10, 12 + 18, 300, 30, $STATIC_COMPACT_END)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlSetFont(-1, -1, 800)

	GUICtrlCreateLabel(__GetLang('PASSWORD_MSGBOX_5', 'Password for decryption:'), 10, 66, 300, 18)
	$iInput = GUICtrlCreateInput("", 10, 83, 300, 20, 0x0020)

	$iOK = GUICtrlCreateButton(__GetLang('OK', 'OK'), 160 - 80 - 30, 116, 80, 24)
	$iCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 160 + 30, 116, 80, 24)
	GUICtrlSetState($iOK, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $iCancel
				$iPassword = -1
				ExitLoop

			Case $iOK
				$iPassword = GUICtrlRead($iInput)
				ExitLoop

		EndSwitch
	WEnd
	GUIDelete($iGUI)
	Return $iPassword
EndFunc   ;==>__InsertPassword_GUI

Func __Password_GUI()
	#cs
		Description: Enter Master Password.
		Returns: Start DropIt If Password Is Correct.
	#ce
	Local $pINI = __IsSettingsFile() ; Get Default Settings INI File.
	If __Is("ProfileEncryption", $pINI) = 0 Or FileExists(__GetDefault(1) & "Profiles.dat") = 0 Then
		Return 1
	EndIf

	Local $pPW, $pPW_Code = $G_Global_PasswordKey
	Local $pMasterPassword, $pOK, $pCancel, $pStart = 1, $pPWFailedAttempts
	Local $pGUI = GUICreate(__GetLang('PASSWORD_MSGBOX_0', 'Enter Password'), 240, 80, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop())

	$pMasterPassword = GUICtrlCreateInput("", 15, 15, 210, 20, 0x0020)
	$pOK = GUICtrlCreateButton(__GetLang('OK', 'OK'), 120 - 15 - 76, 46, 76, 25)
	$pCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 120 + 15, 46, 76, 25)
	GUICtrlSetState($pOK, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)
	ControlClick($pGUI, "", $pMasterPassword)

	While 1
		; Enable/Disable OK Button.
		If GUICtrlRead($pMasterPassword) <> "" And StringIsSpace(GUICtrlRead($pMasterPassword)) = 0 Then
			If GUICtrlGetState($pOK) > 80 Then
				GUICtrlSetState($pOK, 576) ; $GUI_ENABLE + $GUI_DEFBUTTON.
			EndIf
			If GUICtrlGetState($pCancel) = 512 Then
				GUICtrlSetState($pCancel, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
		ElseIf GUICtrlRead($pMasterPassword) = "" Or StringIsSpace(GUICtrlRead($pMasterPassword)) Then
			If GUICtrlGetState($pOK) = 80 Then
				GUICtrlSetState($pOK, 144) ; $GUI_DISABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($pCancel) = 80 Then
				GUICtrlSetState($pCancel, 512) ; $GUI_DEFBUTTON.
			EndIf
		EndIf

		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $pCancel
				$pStart = 0
				ExitLoop

			Case $pOK
				$pPW = IniRead($pINI, $G_Global_GeneralSection, "MasterPassword", "")
				$pPWFailedAttempts += 1
				If StringCompare(GUICtrlRead($pMasterPassword), __StringEncrypt(0, $pPW, $pPW_Code), 1) <> 0 Then
					MsgBox(0x30, __GetLang('PASSWORD_MSGBOX_1', 'Password Not Correct') & ' - ' & $pPWFailedAttempts, __GetLang('PASSWORD_MSGBOX_2', 'You have to enter the correct password to use DropIt.'), 0, __OnTop($pGUI))
					GUICtrlSetData($pMasterPassword, "")
					ControlClick($pGUI, "", $pMasterPassword)
					If $pPWFailedAttempts > 2 Then ; 3 Attempts At Entering The Password.
						$pStart = 0
						ExitLoop
					EndIf
				Else
					$pStart = 1
					ExitLoop
				EndIf

		EndSwitch
	WEnd

	GUIDelete($pGUI)
	If $pStart = 0 Then
		Exit ; Close DropIt If Password Is Wrong.
	EndIf

	__EncryptionFolder(1) ; Decrypt Profiles.
	Return 1
EndFunc   ;==>__Password_GUI

Func __RenameToCompress($sFilePath, $sStringContent, ByRef $iTempMoved)
	Local $sFileExt, $sTempFilePath, $sNewFilePath, $A = 1, $sTempName = $G_Global_TempName

	If StringInStr($sStringContent, "\" & __GetFileName($sFilePath) & @CRLF) = 0 Then
		Return $sFilePath
	EndIf
	$sTempFilePath = __GetParentFolder($sFilePath) & "\" & $sTempName & "\" & __GetFileName($sFilePath)
	$iTempMoved = 1 ; At Least One File/Folder Renamed.

	If _WinAPI_PathIsDirectory($sTempFilePath) = 0 Then ; If Is A File.
		$sFileExt = __GetFileExtension($sTempFilePath) ; txt
		If $sFileExt <> "" Then
			$sFileExt = "." & $sFileExt ; To Add It Only If Is A File With Extension.
			$sTempFilePath = StringTrimRight($sTempFilePath, StringLen($sFileExt))
		EndIf
	EndIf

	While 1
		$sNewFilePath = $sTempFilePath & " (" & StringFormat("%02d", $A) & ")" & $sFileExt
		If StringInStr($sStringContent, "\" & __GetFileName($sNewFilePath) & @CRLF) = 0 Then
			ExitLoop
		EndIf
		$A += 1
	WEnd
	__SureMove($sFilePath, $sNewFilePath) ; Temporarily Move File/Folder In A Subdirectory.

	Return $sNewFilePath
EndFunc   ;==>__RenameToCompress

Func __RestoreCompressedItems($sString, $aMainArray, $iFrom, $iTo) ; Used To Restore The Position Of Files/Folders Temporarily Moved In A Subdirectory For Compression.
	Local $aArray = StringSplit($sString, @CRLF, 1)
	If IsArray($aArray) = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	Local $iCounter
	For $A = $iFrom To $iTo
		If $aMainArray[$A][4] == -9 Then ; Skip Already Processed Item.
			ContinueLoop
		EndIf
		$iCounter += 1
		If $aArray[$iCounter] <> $aMainArray[$A][0] Then ; File/Folder Was Moved In Temporarily Subdirectory.
			__SureMove($aArray[$iCounter], $aMainArray[$A][0])
			DirRemove(__GetParentFolder($aArray[$iCounter]), 0) ; 0 = To Remove Temporarily Subdirectory Only If Empty.
		EndIf
	Next
	Return 1
EndFunc   ;==>__RestoreCompressedItems
