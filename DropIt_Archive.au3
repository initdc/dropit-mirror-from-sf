
; Archive funtions of DropIt

#include-once
#include <Constants.au3>
#include <DropIt_General.au3>
#include <DropIt_Global.au3>
#include <GUIConstantsEx.au3>
#include <Lib\udf\APIConstants.au3>
#include <Lib\udf\DropIt_LibFiles.au3>
#include <Lib\udf\DropIt_LibVarious.au3>
#include <Lib\udf\WinAPIEx.au3>
#include <String.au3>
#include <WindowsConstants.au3>

Func __7ZipCommands($cType, $cDestinationFilePath = -1, $cDefault = 0, $cDuplicateMode = 0, $cPassword = "")
	#cs
		Description: Update 7-Zip Commands And Output Archive Format.
		Returns: Needed Commands
	#ce
	Local $cCommand = "a "
	If FileExists($cDestinationFilePath) Then
		If $cType = 3 Then ; Update Archive.
			$cCommand = "u "
		Else ; Create New Archive.
			FileDelete($cDestinationFilePath)
		EndIf
	EndIf

	If ($cType = 0 Or $cType = 3) And $cDefault = 1 Then ; Compress With Default Parameters.
		$cCommand &= '-tzip -mm=Deflate -mx5 -mem=AES256 -sccUTF-8 -ssw '
		Return $cCommand & '"' & $cDestinationFilePath & '"'
	EndIf

	Local $cINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $c7ZipFormat = __GetFileExtension($cDestinationFilePath)
	Local $cEncryption, $cINI_Password, $cPassword_Code = $G_Global_PasswordKey
	If $c7ZipFormat = "7z" Or $c7ZipFormat = "exe" Then
		$cINI_Password = IniRead($cINI, "General", "7ZPassword", "")
	Else
		$cINI_Password = IniRead($cINI, "General", "ZIPPassword", "")
	EndIf
	$cINI_Password = _StringEncrypt(0, $cINI_Password, $cPassword_Code)
	If @error Then
		$cINI_Password = ""
	EndIf
	If $cPassword <> "" Then
		$cINI_Password = $cPassword
	EndIf

	If $cType = 1 Then ; Extract.
		Switch $cDuplicateMode
			Case 1 ; Overwrite Duplicates.
				$cDuplicateMode = "-aoa "
			Case 2 ; Skip Duplicates.
				$cDuplicateMode = "-aos "
			Case 3 ; Rename Duplicates (Only "name_1.txt").
				$cDuplicateMode = "-aou "
			Case Else
				$cDuplicateMode = "-y "
		EndSwitch
		Return "x " & $cDuplicateMode & "-p" & $cINI_Password
	EndIf

	Switch $c7ZipFormat
		Case "7z", "exe"
			If $c7ZipFormat = "7z" Then
				$cCommand &= '-t7z '
			Else
				$cCommand &= '-sfx7z.sfx '
			EndIf
			$cCommand &= '-m0=' & IniRead($cINI, "General", "7ZMethod", "LZMA") & ' '
			$cCommand &= '-mx' & IniRead($cINI, "General", "7ZLevel", "5") & ' -mhe '
			$cEncryption = StringReplace(IniRead($cINI, "General", "7ZEncryption", "None"), "-", "")
		Case Else ; zip.
			$cCommand &= '-tzip '
			$cCommand &= '-mm=' & IniRead($cINI, "General", "ZIPMethod", "Deflate") & ' '
			$cCommand &= '-mx' & IniRead($cINI, "General", "ZIPLevel", "5") & ' '
			$cEncryption = StringReplace(IniRead($cINI, "General", "ZIPEncryption", "None"), "-", "")
	EndSwitch
	If $cEncryption <> "None" Then
		$cCommand &= '-mem=' & $cEncryption & ' '
		$cCommand &= '-p' & $cINI_Password & ' '
	EndIf
	$cCommand &= '-sccUTF-8 -ssw '

	Return $cCommand & '"' & $cDestinationFilePath & '"'
EndFunc   ;==>__7ZipCommands

Func __7ZipRun($rSourceFilePath, $rDestinationFilePath, $rType = 0, $rDefault = 0, $rDuplicateMode = 0, $rNotWait = 0, $rPassword = "")
	#cs
		Description: Compress/Extract/Check Using 7-Zip.
		Returns: Output FilePath [C:\Test.7z]
	#ce
	Local $rCommand, $rProcess, $7Zip = @ScriptDir & "\Lib\7z\7z.exe"
	If FileExists($7Zip) = 0 Or $rSourceFilePath = "" Or $rDestinationFilePath = "" Then
		Return SetError(1, 0, 0)
	EndIf

	Switch $rType
		Case 0, 3 ; Compress Modes (0 = Create, 3 = Update).
			$rCommand = '"' & $7Zip & '" ' & __7ZipCommands($rType, $rDestinationFilePath, $rDefault) & ' -- "' & $rSourceFilePath & '"'

		Case 1 ; Extract Mode.
			$rCommand = '"' & $7Zip & '" ' & __7ZipCommands($rType, -1, 0, $rDuplicateMode, $rPassword) & ' -o"' & $rDestinationFilePath & '" -- "' & $rSourceFilePath & '"'

		Case 2 ; Check Mode.
			$rCommand = '"' & $7Zip & '" l -slt -- "' & $rSourceFilePath & '"'
			$rNotWait = 1

		Case Else
			Return SetError(1, 0, 0)
	EndSwitch

	If $rNotWait = 1 Then
		$rProcess = Run($rCommand, "", @SW_HIDE, $STDOUT_CHILD)
		If @error Then
			Return SetError(1, 0, 0)
		EndIf
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

Func __EncryptionFolder($fDecrypt = -1) ; $fDecrypt = 0, Encrypt/Decrypt Profiles.
	#cs
		Description: Create An Encrypted/Decrypted File Of The Profiles Folder. .dat Is The Extension Used For Encryption.
		Returns: Full Path Of Encrypted/Decrypted File [C:\Program Files\DropIt\Profiles.dat]
	#ce
	Local $7Zip = @ScriptDir & "\Lib\7z\7z.exe", $fPassword = $G_Global_EncryptionKey
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

Func __InsertPassword_GUI($iFileName)
	Local $iCancel, $iGUI, $iInput, $iOK, $iPassword

	$iGUI = GUICreate(__GetLang('PASSWORD_MSGBOX_0', 'Enter Password'), 320, 150, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($G_Global_SortingGUI))
	GUICtrlCreateGraphic(0, 0, 320, 60)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlSetColor(-1, 0xffffff)

	GUICtrlCreateLabel(__GetLang('PASSWORD_MSGBOX_4', 'Loaded archive:'), 14, 12, 292, 18)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlCreateLabel($iFileName, 16, 12 + 18, 288, 30)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlSetFont(-1, -1, 800)

	GUICtrlCreateLabel(__GetLang('PASSWORD_MSGBOX_5', 'Password for decryption:'), 14, 66, 292, 18)
	$iInput = GUICtrlCreateInput("", 14, 83, 292, 20)

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
				$pPW = IniRead($pINI, "General", "MasterPassword", "")
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
