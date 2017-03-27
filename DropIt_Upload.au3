
; Upload funtions of DropIt

#include-once
#include <DropIt_General.au3>
#include <DropIt_Global.au3>
#include <FTPEx.au3>
#include "Lib\udf\APIConstants.au3"
#include "Lib\udf\WinAPIEx.au3"

Func __FTP_ListToArrayEx($l_FTPSession, $s_RemoteDir = "", $ReturnType = 0, $iFlags = 0, $fTimeFormat = 1)
	If $l_FTPSession = 0 Then
		Return SetError(1, 0, 0)
	EndIf

	Local $aFileList, $sPreviousDir, $iError = 0
	$sPreviousDir = _FTP_DirGetCurrent($l_FTPSession)
	_FTP_DirSetCurrent($l_FTPSession, $s_RemoteDir)
	$aFileList = _FTP_ListToArrayEx($l_FTPSession, $ReturnType, $iFlags, $fTimeFormat)
	$iError = @error
	_FTP_DirSetCurrent($l_FTPSession, $sPreviousDir)
	If $iError Then
		Return SetError($iError, 0, $aFileList)
	EndIf

	Return $aFileList
EndFunc   ;==>__FTP_ListToArrayEx

Func __FTP_ProgressUpload($l_FTPSession, $s_LocalFile, $s_RemoteFile, $l_Progress1, $l_Progress2, $l_Percent1, $l_Percent2, $fSize) ; Modified From: http://www.autoitscript.com/forum/topic/113542-ftp-upload-issue/
	#cs
		Description: Uploads A File In Binary Mode And Update Progress Bars.
		Returns: 1
	#ce
	If $__ghWinInet_FTP = -1 Then
		Return SetError(2, 0, 0)
	EndIf

	Local $fHandle = FileOpen($s_LocalFile, 16)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	Local $ai_FTPOpenFile = DllCall($__ghWinInet_FTP, 'handle', 'FtpOpenFileW', 'handle', $l_FTPSession, 'wstr', $s_RemoteFile, 'dword', $GENERIC_WRITE, 'dword', $FTP_TRANSFER_TYPE_BINARY, 'dword_ptr', 0)
	If @error Or $ai_FTPOpenFile[0] = 0 Then
		Return SetError(3, 0, 0)
	EndIf

	Local Const $ChunkSize = 256 * 1024
	Local $fLast = Mod($fSize, $ChunkSize)
	Local $fParts = Ceiling($fSize / $ChunkSize)
	Local $fBuffer = DllStructCreate("byte[" & $ChunkSize & "]")
	Local $ai_InternetCloseHandle, $ai_FTPWrite, $fOut, $fPercent
	Local $X = $ChunkSize
	Local $fDone = 0

	For $A = 1 To $fParts
		If $A = $fParts And $fLast > 0 Then
			$X = $fLast
		EndIf
		DllStructSetData($fBuffer, 1, FileRead($fHandle, $X))

		$ai_FTPWrite = DllCall($__ghWinInet_FTP, 'bool', 'InternetWriteFile', 'handle', $ai_FTPOpenFile[0], 'ptr', DllStructGetPtr($fBuffer), 'dword', $X, 'dword*', $fOut)
		If @error Or $ai_FTPWrite[0] = 0 Then
			$ai_InternetCloseHandle = DllCall($__ghWinInet_FTP, 'bool', 'InternetCloseHandle', 'handle', $ai_FTPOpenFile[0])
			FileClose($fHandle)
			Return SetError(4, 0, 0)
		EndIf
		$fDone += $X

		$fPercent = Round($fDone / $fSize * 100)
		If GUICtrlRead($l_Progress2) <> $fPercent Then
			GUICtrlSetData($l_Progress2, $fPercent)
			GUICtrlSetData($l_Percent2, $fPercent & ' %')
			$fPercent = __GetPercent($fDone, 0)
			If GUICtrlRead($l_Progress1) <> $fPercent Then
				GUICtrlSetData($l_Progress1, $fPercent)
				GUICtrlSetData($l_Percent1, $fPercent & ' %')
			EndIf
		EndIf

		If $G_Global_AbortSorting Then
			$ai_InternetCloseHandle = DllCall($__ghWinInet_FTP, 'bool', 'InternetCloseHandle', 'handle', $ai_FTPOpenFile[0])
			DllCall($__ghWinInet_FTP, 'bool', 'FtpDeleteFileW', 'handle', $l_FTPSession, 'wstr', $s_RemoteFile)
			FileClose($fHandle)
			Return SetError(6, 0, 0)
		EndIf
		Sleep(10)
	Next
	FileClose($fHandle)

	$ai_InternetCloseHandle = DllCall($__ghWinInet_FTP, 'bool', 'InternetCloseHandle', 'handle', $ai_FTPOpenFile[0])
	If @error Or $ai_InternetCloseHandle[0] = 0 Then
		Return SetError(5, 0, 0)
	EndIf

	Return 1
EndFunc   ;==>__FTP_ProgressUpload

Func __SFTP_ProgressUpload($l_SFTPSession, $s_LocalFile, $s_RemoteFile, $l_Progress1, $l_Progress2, $l_Percent1, $l_Percent2, $iSize)
	#cs
		Description: Uploads A File With SFTP Protocol And Update Progress Bars.
		Returns: 1
	#ce
	If ProcessExists($l_SFTPSession) = 0 Then
		Return SetError(1, 0, 0)
	EndIf

	If $s_RemoteFile <> "" Then
		$s_RemoteFile = ' "' & $s_RemoteFile & '"'
	EndIf
	Local $sLine, $sInitialBytes, $sReadBytes, $fPercent, $iError
	If _WinAPI_PathIsDirectory($s_LocalFile) Then
		$sLine = '-r '
	EndIf

	StdinWrite($l_SFTPSession, 'put ' & $sLine & '-- "' & $s_LocalFile & '"' & $s_RemoteFile & @CRLF)
	$sReadBytes = ProcessGetStats($l_SFTPSession, 1)
	$sInitialBytes = $sReadBytes[3]
	While 1
		$sLine = StdoutRead($l_SFTPSession)
		If ProcessExists($l_SFTPSession) = 0 Then
			$iError = 1
			ExitLoop
		ElseIf StringInStr($sLine, "psftp>") Then
			ExitLoop
		ElseIf StringInStr($sLine, "=> remote:") Then
			ContinueLoop
		ElseIf StringInStr($sLine, "unable to open") Then
			$iError = 2
			ExitLoop
		ElseIf StringInStr($sLine, "Cannot create directory") Then
			$iError = 3
			ExitLoop
		ElseIf $sLine <> "" Then
			$iError = 5
			ExitLoop
		EndIf

		$sReadBytes = ProcessGetStats($l_SFTPSession, 1)
		$fPercent = Round(($sReadBytes[3] - $sInitialBytes) / $iSize * 100)
		If GUICtrlRead($l_Progress2) <> $fPercent Then
			GUICtrlSetData($l_Progress2, $fPercent)
			GUICtrlSetData($l_Percent2, $fPercent & ' %')
			$fPercent = __GetPercent($sReadBytes[3] - $sInitialBytes, 0)
			If GUICtrlRead($l_Progress1) <> $fPercent Then
				GUICtrlSetData($l_Progress1, $fPercent)
				GUICtrlSetData($l_Percent1, $fPercent & ' %')
			EndIf
		EndIf

		If $G_Global_AbortSorting Then
			ProcessClose($l_SFTPSession)
			$iError = 4
			ExitLoop
		EndIf
		Sleep(10)
	WEnd

	If $iError Then
		Return SetError($iError, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__SFTP_ProgressUpload
