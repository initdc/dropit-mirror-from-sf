
; Archive funtions of DropIt

#include-once
#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <String.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>

#include "DropIt_General.au3"
#include "DropIt_Global.au3"
#include "Lib\udf\DropIt_LibFiles.au3"
#include "Lib\udf\DropIt_LibVarious.au3"

Func __7ZipCommands($cType, $cDestinationFilePath = "", $cDefault = 0, $cDuplicateMode = 0, $cPassword = "")
	#cs
		Description: Update 7-Zip Commands And Output Archive Format.
		Returns: Needed Commands
	#ce
	Local $cCommand = ' a'
	If $cType = 3 Then ; Update Archive.
		$cCommand = ' u -ux2y2z2'
	ElseIf $cType = 0 And FileExists($cDestinationFilePath) Then ; Create New Archive.
		FileDelete($cDestinationFilePath)
	EndIf
	If ($cType = 0 Or $cType = 3) And $cDefault = 1 Then ; Compress With Default Parameters.
		$cCommand &= ' -tzip -mm=Deflate -mx5 -mem=AES256 -ssw -sccUTF-8'
		Return $cCommand & ' "' & $cDestinationFilePath & '"'
	EndIf

	If $cPassword == "" Then
		$cPassword = __7ZipINIPassword($cDestinationFilePath)
	EndIf
	If $cType = 1 Then ; Extract.
		Return ' x ' & __ExtractDuplicateMode($cDuplicateMode) & ' "-p' & $cPassword & '" -o"' & $cDestinationFilePath & '"'
	EndIf

	Local $c7ZipFormat = __GetFileExtension($cDestinationFilePath)
	Switch $c7ZipFormat
		Case "7z", "exe"
			$cCommand &= __GetCommands7z($cPassword, $c7ZipFormat)
		Case Else ; zip.
			$cCommand &= __GetCommandsZip($cPassword)
	EndSwitch

	Return $cCommand & ' -ssw -sccUTF-8 "' & $cDestinationFilePath & '"'
EndFunc   ;==>__7ZipCommands

Func __7ZipGetPassword($sFilePath, $iGetPassword = 0)
	#cs
		Description: Verify If The Archive Is Encrypted And Get Password.
		Returns: Password
	#ce
	Local $sPassword = ""
	__7ZipRun($sFilePath, "", 2) ; Check If Archive Is Encrypted.
	Switch @error
		Case 1
			Return SetError(1, 0, "") ; Failed.
		Case 2 ; Password Needed.
			If $iGetPassword Then
				$sPassword = __7ZipINIPassword($sFilePath)
			Else
				__ExpandEventMode(0) ; Disable Event Buttons.
				$sPassword = __InsertPassword_GUI(_WinAPI_PathCompactPathEx(__GetFileName($sFilePath), 68))
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

Func __7ZipINIPassword($sFilePath)
	Local $sPassword, $sPassword_Code = $G_Global_PasswordKey
	Local $sINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $s7ZipFormat = __GetFileExtension($sFilePath)

	If $s7ZipFormat = "7z" Or $s7ZipFormat = "exe" Then
		$sPassword = IniRead($sINI, $G_Global_GeneralSection, "7ZPassword", "")
	Else
		$sPassword = IniRead($sINI, $G_Global_GeneralSection, "ZIPPassword", "")
	EndIf
	$sPassword = _StringEncrypt(0, $sPassword, $sPassword_Code)
	If @error Then
		Return SetError(1, 0, "")
	EndIf

	Return $sPassword
EndFunc   ;==>__7ZipINIPassword

Func __7ZipRun($rSourceFilePath, $rDestinationFilePath, $rType = 0, $rDefault = 0, $rDuplicateMode = 0, $rNotWait = 0, $rPassword = "")
	#cs
		Description: Compress/Extract/Check Using 7-Zip.
		Returns: Output FilePath [C:\Test.7z]
	#ce
	Local $rCommand, $rProcess, $rReady, $7Zip = $G_Global_7ZipPath
	If FileExists($7Zip) = 0 Or $rSourceFilePath = "" Or ($rDestinationFilePath = "" And $rType <> 2) Then
		Return SetError(1, 0, 0)
	EndIf

	Switch $rType
		Case 0 ; Compress Mode.
			$rCommand = '"' & $7Zip & '"' & __7ZipCommands($rType, $rDestinationFilePath, $rDefault, 0, $rPassword) & ' -- "' & $rSourceFilePath & '"'

		Case 3 ; Compress List Mode.
			$rCommand = '"' & $7Zip & '"' & __7ZipCommands($rType, $rDestinationFilePath, $rDefault, 0, $rPassword) & ' -- @"' & $rSourceFilePath & '"'

		Case 1 ; Extract Mode.
			$rCommand = '"' & $7Zip & '"' & __7ZipCommands($rType, $rDestinationFilePath, 0, $rDuplicateMode, $rPassword) & ' -- "' & $rSourceFilePath & '"'

		Case 2 ; Check Mode.
			$rCommand = '"' & $7Zip & '" l -slt -- "' & $rSourceFilePath & '"'
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
	EndIf

	Return $rProcess
EndFunc   ;==>__7ZipRun

Func __Backup_Restore($bHandle = -1, $bType = 0, $bZipFile = -1) ; 0 = Backup & 1 = Restore & 2 = Remove.
	#cs
		Description: Backup/Restore The Settings INI File & Profiles.
		Returns: 1
	#ce
	Local $bBackupDirectory = __GetDefault(32) ; Get Default Backup Directory.
	Local $bBackup[3] = [2, __IsSettingsFile(), __GetDefault(2)] ; __GetDefault(2) = Get Default Profiles Directory.

	If FileExists($bBackupDirectory & $bZipFile) Or $bZipFile = -1 Then
		$bZipFile = "DropIt_Backup_" & @YEAR & "-" & @MON & "-" & @MDAY & "[" & @HOUR & "." & @MIN & "." & @SEC & "].zip"
	EndIf

	Switch $bType
		Case 0
			__7ZipRun($bBackup[1] & '" "' & $bBackup[2], $bBackupDirectory & $bZipFile, 0, 1)
			MsgBox(0, __GetLang('OPTIONS_BACKUP_MSGBOX_0', 'Backup Created'), __GetLang('OPTIONS_BACKUP_MSGBOX_1', 'Successfully created a DropIt Backup.'), 0, __OnTop($bHandle))

		Case 1
			Local $bSettingsDirectory = __GetDefault(1) ; __GetDefault(1) = Get The Default Settings Directory.
			If FileExists($bBackupDirectory) = 0 Or DirGetSize($bBackupDirectory, 2) = 0 Then
				$bBackupDirectory = __GetDefault(1) ; __GetDefault(1) = Get The Default Settings Directory.
			EndIf
			$bZipFile = FileOpenDialog(__GetLang('OPTIONS_BACKUP_TIP_0', 'Select a DropIt Backup'), $bBackupDirectory, __GetLang('OPTIONS_BACKUP_TIP_1', 'DropIt Backup') & " (*.zip)", 1, "", __OnTop($bHandle))
			If @error Then
				Return SetError(1, 0, 0)
			EndIf

			For $A = 1 To $bBackup[0]
				If FileExists($bBackup[$A]) = 0 Then
					ContinueLoop
				EndIf
				If _WinAPI_PathIsDirectory($bBackup[$A]) Then
					DirRemove($bBackup[$A], 1)
				EndIf
			Next

			__7ZipRun($bZipFile, $bSettingsDirectory, 1, 0, 1)
			Sleep(100)
			MsgBox(0, __GetLang('OPTIONS_BACKUP_MSGBOX_2', 'Backup Restored'), __GetLang('OPTIONS_BACKUP_MSGBOX_3', 'Successfully restored the selected DropIt Backup.'), 0, __OnTop($bHandle))

		Case 2
			If FileExists($bBackupDirectory) = 0 Or DirGetSize($bBackupDirectory, 2) = 0 Then
				$bBackupDirectory = __GetDefault(1) ; __GetDefault(1) = Get The Default Settings Directory.
			EndIf
			$bZipFile = FileOpenDialog(__GetLang('OPTIONS_BACKUP_TIP_0', 'Select a DropIt Backup'), $bBackupDirectory, __GetLang('OPTIONS_BACKUP_TIP_1', 'DropIt Backup') & " (*.zip)", 1, "", __OnTop($bHandle))
			If @error Then
				Return SetError(1, 0, 0)
			EndIf

			FileDelete($bZipFile)
			If DirGetSize($bBackupDirectory, 2) = 0 Then
				DirRemove($bBackupDirectory, 1) ; Remove Back Directory If Empty.
			EndIf
			MsgBox(0, __GetLang('OPTIONS_BACKUP_MSGBOX_4', 'Backup Removed'), __GetLang('OPTIONS_BACKUP_MSGBOX_5', 'Successfully removed the selected DropIt Backup.'), 0, __OnTop($bHandle))

	EndSwitch
	Return 1
EndFunc   ;==>__Backup_Restore

Func __GetCommands7z($cPassword, $c7ZipFormat)
	Local $cINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $cEncryption = StringReplace(IniRead($cINI, $G_Global_GeneralSection, "7ZEncryption", "None"), "-", "")
	Local $cReturn = ' -t7z'
	$cReturn &= ' -m0=' & IniRead($cINI, $G_Global_GeneralSection, "7ZMethod", "LZMA")
	$cReturn &= ' -mmt=on'
	$cReturn &= ' -mx' & IniRead($cINI, $G_Global_GeneralSection, "7ZLevel", "5")
	If $cEncryption <> "None" Then
		$cReturn &= ' -mhe=on "-p' & $cPassword & '"'
	EndIf
	If $c7ZipFormat = "exe" Then
		$cReturn &= ' -sfx7z.sfx'
	EndIf
	Return $cReturn
EndFunc   ;==>__GetCommands7z

Func __GetCommandsZip($cPassword)
	Local $cINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $cEncryption = StringReplace(IniRead($cINI, $G_Global_GeneralSection, "ZIPEncryption", "None"), "-", "")
	Local $cReturn = ' -tzip'
	$cReturn &= ' -mm=' & IniRead($cINI, $G_Global_GeneralSection, "ZIPMethod", "Deflate")
	$cReturn &= ' -mmt=on'
	$cReturn &= ' -mx' & IniRead($cINI, $G_Global_GeneralSection, "ZIPLevel", "5")
	If $cEncryption <> "None" Then
		$cReturn &= ' -mem=' & $cEncryption & ' "-p' & $cPassword & '"'
	EndIf
	Return $cReturn
EndFunc   ;==>__GetCommandsZip

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

Func __InsertPassword_GUI($iFileName)
	Local $iCancel, $iGUI, $iInput, $iOK, $iPassword

	$iGUI = GUICreate(__GetLang('PASSWORD_MSGBOX_0', 'Enter Password'), 320, 150, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($G_Global_SortingGUI))
	GUICtrlCreateGraphic(0, 0, 320, 60)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlSetColor(-1, 0xffffff)

	GUICtrlCreateLabel(__GetLang('MOREMATCHES_LABEL_0', 'Loaded item:'), 10, 12, 300, 18)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlCreateLabel($iFileName, 10, 12 + 18, 300, 30)
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
				If StringCompare(GUICtrlRead($pMasterPassword), _StringEncrypt(0, $pPW, $pPW_Code), 1) <> 0 Then
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
