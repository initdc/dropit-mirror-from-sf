
; Update funtions of DropIt

#include-once
#include <WinAPI.au3>
#include <WinAPIFiles.au3>

#include "DropIt_Archive.au3"
#include "DropIt_General.au3"
#include "DropIt_Global.au3"
#include "Lib\udf\DropIt_LibVarious.au3"

Func __Update_Check($uLabel = -1, $uProgress = -1, $uCancel = -1, $uHandle = -1)
	Local $uBackground_GUI

	If $uLabel = -1 Then
		If __Is("CheckUpdates") Then ; Create A Hidden Update GUI.
			$uBackground_GUI = GUICreate(__GetLang('UPDATE_MSGBOX_10', 'DropIt Updating'), 330, 95, -1, -1, -1, $WS_EX_TOOLWINDOW)
			$uLabel = GUICtrlCreateLabel("", 10, 12, 310, 18)
			If __IsWindowsVersion() = 0 Then
				$uProgress = GUICtrlCreateProgress(10, 12 + 25, 310, 14, 0x01)
			Else
				$uProgress = GUICtrlCreatePic("", 10, 12 + 25, 310, 14)
			EndIf
			$uCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 165 - 40, 12 + 50, 80, 25)
		Else
			Return SetError(1, 0, 0)
		EndIf
	EndIf

	Local $uMsgBox, $uDownload, $uVersion, $uPage, $uCancelRead, $uCancelled = 0, $uPercent = 0, $uBefore = "<!--<version>", $uAfter = "</version>-->"
	Local $uSize, $uCurrentPercent, $uDownloaded, $uText, $uDownloadURL, $uDownloadFile, $uDownloadName

	HttpSetProxy(0) ; Load System Proxy Settings.
	$uPage = BinaryToString(InetRead(_WinAPI_ExpandEnvironmentStrings("%DropItURL%"), 17)) ; Load Web Page.

	If @error Or StringInStr($uPage, $uBefore) = 0 Then
		MsgBox(0x30, __GetLang('UPDATE_MSGBOX_2', 'Check Failed'), __GetLang('UPDATE_MSGBOX_3', 'An error occurs during check for updates.'), 10, __OnTop($uHandle))
		Return SetError(1, 0, 0)
	EndIf

	; Extract Last Version Available From Web Page:
	$uBefore = StringInStr($uPage, $uBefore) + StringLen($uBefore)
	$uAfter = StringInStr(StringTrimLeft($uPage, $uBefore), $uAfter)
	$uVersion = StringStripWS(StringMid($uPage, $uBefore, $uAfter), 3)

	If @error Or $uVersion == "" Then
		GUICtrlSetData($uLabel, __GetLang('UPDATE_MSGBOX_3', 'An error occurs during check for updates.'))
		Return SetError(1, 0, 0)
	EndIf

	If $uVersion > $G_Global_CurrentVersion Then
		$uBefore = '<!--<update>'
		$uAfter = '</update>-->'
		If StringInStr($uPage, $uBefore) = 0 Then
			GUICtrlSetData($uLabel, __GetLang('UPDATE_MSGBOX_3', 'An error occurs during check for updates.'))
			Return SetError(1, 0, 0)
		EndIf

		; Extract Download URL From Web Page:
		$uBefore = StringInStr($uPage, $uBefore) + StringLen($uBefore)
		$uAfter = StringInStr(StringTrimLeft($uPage, $uBefore), $uAfter)
		$uDownloadURL = StringStripWS(StringMid($uPage, $uBefore, $uAfter), 3)

		$uMsgBox = MsgBox(0x4, __GetLang('UPDATE_MSGBOX_5', 'Update Available!'), StringReplace(__GetLang('UPDATE_MSGBOX_6', 'New version %DropItNewVersion% of DropIt is available.'), '%DropItNewVersion%', $uVersion) & @LF & __GetLang('UPDATE_MSGBOX_11', 'Do you want to update it now?'), 0, __OnTop($uHandle))
		If $uMsgBox <> 6 Then
			Return SetError(1, 0, 0)
		EndIf
		__SetProgress($uProgress, 0, 3)

		GUISetState(@SW_SHOW, $uBackground_GUI) ; Show The Background GUI If It Exists.
		$uCancelRead = GUICtrlRead($uCancel)
		GUICtrlSetData($uCancel, __GetLang('CANCEL', 'Cancel'))
		$uDownloadName = "DropIt_v" & StringReplace($uVersion, " ", "_") & "_Portable"
		$uDownloadFile = @ScriptDir & "\" & $uDownloadName & ".zip"

		GUICtrlSetData($uLabel, StringReplace(__GetLang('UPDATE_MSGBOX_8', 'Calculating size for version %DropItNewVersion%'), '%DropItNewVersion%', $uVersion))
		$uSize = InetGetSize($uDownloadURL, 1) ; Get Download Size.
		$uDownload = InetGet($uDownloadURL, $uDownloadFile, 17, 1) ; Start Download.
		While InetGetInfo($uDownload, 2) = 0 ; Whilst Complete Is False.
			$uDownloaded = InetGetInfo($uDownload, 0) ; Bytes Downloaded So Far.
			$uCurrentPercent = Round($uDownloaded * 100 / $uSize, 0) ; Percentage Of Downloaded File.

			If $uCurrentPercent > $uPercent Then
				__SetProgress($uProgress, $uCurrentPercent, 3)
				$uPercent = $uCurrentPercent
				$uText = __GetLang('UPDATE_MSGBOX_9', 'Downloading %DropItCurrentSize% of %DropItTotalSize%')
				$uText = StringReplace($uText, '%DropItCurrentSize%', __ByteSuffix($uDownloaded))
				$uText = StringReplace($uText, '%DropItTotalSize%', __ByteSuffix($uSize))
				GUICtrlSetData($uLabel, $uCurrentPercent & "% " & $uText)
			EndIf

			If InetGetInfo($uDownload, 4) <> 0 Then
				InetClose($uDownload)
				FileDelete($uDownloadFile)
				GUICtrlSetData($uLabel, __GetLang('UPDATE_MSGBOX_7', 'An error occured during software download.'))
				Return SetError(1, 0, 0)
			EndIf

			Switch GUIGetMsg()
				Case $GUI_EVENT_CLOSE, $uCancel
					$uCancelled = 1
					InetClose($uDownload)
					ExitLoop
			EndSwitch
		WEnd
		InetClose($uDownload)
		GUICtrlSetData($uCancel, $uCancelRead)
		__SetProgress($uProgress, 100, 3)

		If FileGetSize($uDownloadFile) <> $uSize Or $uCancelled = 1 Then ; Check If Download FileSize Is The Same As On The Server.
			GUICtrlSetData($uLabel, __GetLang('UPDATE_MSGBOX_7', 'An error occured during software download.'))
			If FileExists($uDownloadFile) Then
				FileDelete($uDownloadFile)
			EndIf
			GUIDelete($uBackground_GUI) ; Delete The Background GUI If It Exists.
			Return SetError(1, 0, 0)
		EndIf

		If __Update_Run($uDownloadFile, $uDownloadName, @ScriptDir & "\ZIP\") Then
			__IniWriteEx(__IsSettingsFile(), $G_Global_GeneralSection, "Update", "True")
			Run(@ScriptName)
			Exit
		EndIf
	Else
		GUICtrlSetData($uLabel, __GetLang('UPDATE_MSGBOX_4', 'You have the latest release available.'))
	EndIf

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__Update_Check

Func __Update_Complete()
	Local $uINI = __IsSettingsFile()

	If __Is("Update", -1, "False") Then
		IniDelete($uINI, $G_Global_GeneralSection, "Update")
		FileDelete(@ScriptDir & "\DropIt_OLD.exe")
		MsgBox(0x40000, __GetLang('UPDATE_MSGBOX_0', 'Successfully Updated'), __GetLang('UPDATE_MSGBOX_1', 'New version %DropItVersionNo% is now ready to be used.'), 10)
	EndIf

	Return 1
EndFunc   ;==>__Update_Complete

Func __Update_Run($uDownloadFile, $uDownloadName, $uNewFolder)
	Local $uNewDirectory = $uNewFolder & $uDownloadName
	Local $uArray[6] = [5, "Languages", "Lib", "Guide.pdf", "License.txt", "Readme.txt"]

	__7ZipRun($uDownloadFile, __GetDefault(1) & "ZIP", 1) ; __GetDefault(1) = Get The Default Settings Directory.
	FileDelete($uDownloadFile)
	If FileExists($uNewDirectory & "\" & @ScriptName) = 0 Then
		Return SetError(1, 0, 0)
	EndIf

	For $A = 1 To $uArray[0]
		If FileExists($uNewDirectory & "\" & $uArray[$A]) = 0 Then
			ContinueLoop
		EndIf
		If _WinAPI_PathIsDirectory($uNewDirectory & "\" & $uArray[$A]) Then
			DirRemove(@ScriptDir & "\" & $uArray[$A], 1)
			DirCopy($uNewDirectory & "\" & $uArray[$A], @ScriptDir & "\" & $uArray[$A])
			DirRemove($uNewDirectory & "\" & $uArray[$A])
		Else
			FileSetAttrib(@ScriptDir & "\" & $uArray[$A], '-R')
			FileMove($uNewDirectory & "\" & $uArray[$A], @ScriptDir & "\" & $uArray[$A], 1)
		EndIf
	Next
	FileMove($uNewDirectory & "\Images\*.*", @ScriptDir & "\Images\", 9)
	FileMove(@ScriptFullPath, @ScriptDir & "\DropIt_OLD.exe") ; Trick To Update DropIt Executable.
	FileMove($uNewDirectory & "\DropIt.exe", @ScriptFullPath)
	DirRemove($uNewFolder, 1)

	Return 1
EndFunc   ;==>__Update_Run
