
; #FUNCTION# ====================================================================================================================
Func __MD5ForFile($mFile, $mRead = 100)
	If $mRead > 100 Then
		$mRead = 100
	EndIf
	Local $mFileSize = FileGetSize($mFile)
	$mRead = ($mRead / 100) * $mFileSize

	Local $mResult = DllCall("kernel32.dll", "hwnd", "CreateFileW", "wstr", $mFile, "dword", 0x80000000, "dword", 1, "ptr", 0, "dword", 3, "dword", 0, "ptr", 0)
	If @error Or $mResult[0] = -1 Then
		Return SetError(1, 0, 0)
	EndIf
	Local $mFileOpen = $mResult[0]
	$mResult = DllCall("kernel32.dll", "ptr", "CreateFileMappingW", "hwnd", $mFileOpen, "dword", 0, "dword", 2, "dword", 0, "dword", 0, "ptr", 0)
	If @error Or Not $mResult[0] Then
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $mFileOpen)
		Return SetError(1, 2, 0)
	EndIf
	DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $mFileOpen)
	Local $mFileOpenMappingObject = $mResult[0]
	$mResult = DllCall("kernel32.dll", "ptr", "MapViewOfFile", "hwnd", $mFileOpenMappingObject, "dword", 4, "dword", 0, "dword", 0, "dword", $mRead)
	If @error Or Not $mResult[0] Then
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $mFileOpenMappingObject)
		Return SetError(1, 3, 0)
	EndIf
	Local $mTempFile = $mResult[0]
	Local $mBufferSize = $mRead
	Local $mTempResult = DllStructCreate("dword i[2];" & "dword buf[4];" & "ubyte in[64];" & "ubyte digest[16]")
	DllCall("advapi32.dll", "none", "MD5Init", "ptr", DllStructGetPtr($mTempResult))
	If @error Then
		DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $mTempFile)
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $mFileOpenMappingObject)
		Return SetError(1, 4, 0)
	EndIf
	DllCall("advapi32.dll", "none", "MD5Update", "ptr", DllStructGetPtr($mTempResult), "ptr", $mTempFile, "dword", $mBufferSize)
	If @error Then
		DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $mTempFile)
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $mFileOpenMappingObject)
		Return SetError(1, 5, 0)
	EndIf
	DllCall("advapi32.dll", "none", "MD5Final", "ptr", DllStructGetPtr($mTempResult))
	If @error Then
		DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $mTempFile)
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $mFileOpenMappingObject)
		Return SetError(1, 6, 0)
	EndIf
	DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $mTempFile)
	DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $mFileOpenMappingObject)
	Local $mCheckSum = Hex(DllStructGetData($mTempResult, "digest"))
	Return SetError(0, 0, $mCheckSum)
EndFunc   ;==>__MD5ForFile

; #FUNCTION# ====================================================================================================================
Func __SHA1ForFile($sFile)
	Local $a_hCall = DllCall("kernel32.dll", "hwnd", "CreateFileW", "wstr", $sFile, "dword", 0x80000000, "dword", 3, "ptr", 0, "dword", 3, "dword", 0, "ptr", 0)
	If @error Or $a_hCall[0] = -1 Then
		Return SetError(1, 0, "")
	EndIf
	Local $hFile = $a_hCall[0]
	$a_hCall = DllCall("kernel32.dll", "ptr", "CreateFileMappingW", "hwnd", $hFile, "dword", 0, "dword", 2, "dword", 0, "dword", 0, "ptr", 0)
	If @error Or Not $a_hCall[0] Then
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFile)
		Return SetError(2, 0, "")
	EndIf
	DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFile)
	Local $hFileMappingObject = $a_hCall[0]
	$a_hCall = DllCall("kernel32.dll", "ptr", "MapViewOfFile", "hwnd", $hFileMappingObject, "dword", 4, "dword", 0, "dword", 0, "dword", 0)
	If @error Or Not $a_hCall[0] Then
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
		Return SetError(3, 0, "")
	EndIf
	Local $pFile = $a_hCall[0]
	Local $iBufferSize = FileGetSize($sFile)
	Local $a_iCall = DllCall("advapi32.dll", "int", "CryptAcquireContext", "ptr*", 0, "ptr", 0, "ptr", 0, "dword", 1, "dword", 0xF0000000)
	If @error Or Not $a_iCall[0] Then
		DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
		Return SetError(4, 0, "")
	EndIf
	Local $hContext = $a_iCall[1]
	$a_iCall = DllCall("advapi32.dll", "int", "CryptCreateHash", "ptr", $hContext, "dword", 0x00008004, "ptr", 0, "dword", 0, "ptr*", 0)
	If @error Or Not $a_iCall[0] Then
		DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
		DllCall("advapi32.dll", "int", "CryptReleaseContext", "ptr", $hContext, "dword", 0)
		Return SetError(5, 0, "")
	EndIf
	Local $hHashSHA1 = $a_iCall[5]
	$a_iCall = DllCall("advapi32.dll", "int", "CryptHashData", "ptr", $hHashSHA1, "ptr", $pFile, "dword", $iBufferSize, "dword", 0)
	If @error Or Not $a_iCall[0] Then
		DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
		DllCall("advapi32.dll", "int", "CryptDestroyHash", "ptr", $hHashSHA1)
		DllCall("advapi32.dll", "int", "CryptReleaseContext", "ptr", $hContext, "dword", 0)
		Return SetError(6, 0, "")
	EndIf
	Local $tOutSHA1 = DllStructCreate("byte[20]")
	$a_iCall = DllCall("advapi32.dll", "int", "CryptGetHashParam", "ptr", $hHashSHA1, "dword", 2, "ptr", DllStructGetPtr($tOutSHA1), "dword*", 20, "dword", 0)
	If @error Or Not $a_iCall[0] Then
		DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
		DllCall("advapi32.dll", "int", "CryptDestroyHash", "ptr", $hHashSHA1)
		DllCall("advapi32.dll", "int", "CryptReleaseContext", "ptr", $hContext, "dword", 0)
		Return SetError(7, 0, "")
	EndIf
	DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
	DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
	DllCall("advapi32.dll", "int", "CryptDestroyHash", "ptr", $hHashSHA1)
	Local $sSHA1 = Hex(DllStructGetData($tOutSHA1, 1))
	DllCall("advapi32.dll", "int", "CryptReleaseContext", "ptr", $hContext, "dword", 0)
	Return SetError(0, 0, $sSHA1)
EndFunc   ;==>__SHA1ForFile
