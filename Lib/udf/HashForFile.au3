
#include-once

; #FUNCTION# ;===============================================================================
;
; Name...........: __CRC32ForFile
; Description ...: Calculates CRC32 value for the specific file.
; Syntax.........: __CRC32ForFile ($sFile)
; Parameters ....: $sFile - Full path to the file to process.
; Return values .: Success - Returns CRC32 value in form of hex string
;                          - Sets @error to 0
;                  Failure - Returns empty string and sets @error:
;                  |1 - CreateFile function or call to it failed.
;                  |2 - CreateFileMapping function or call to it failed.
;                  |3 - MapViewOfFile function or call to it failed.
;                  |4 - RtlComputeCrc32 function or call to it failed.
; Author ........: trancexx
;
;==========================================================================================
Func __CRC32ForFile($sFile)
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
	Local $a_iCall = DllCall("ntdll.dll", "dword", "RtlComputeCrc32", "dword", 0, "ptr", $pFile, "int", $iBufferSize)
	If @error Or Not $a_iCall[0] Then
		DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
		Return SetError(4, 0, "")
	EndIf
	DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
	DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
	Local $iCRC32 = $a_iCall[0]
	Return SetError(0, 0, Hex($iCRC32, 8))
EndFunc   ;==>__CRC32ForFile

; #FUNCTION# ;===============================================================================
;
; Name...........: __MD4ForFile
; Description ...: Calculates MD4 value for the specific file.
; Syntax.........: __MD4ForFile ($sFile)
; Parameters ....: $sFile - Full path to the file to process.
; Return values .: Success - Returns MD4 value in form of hex string
;                          - Sets @error to 0
;                  Failure - Returns empty string and sets @error:
;                  |1 - CreateFile function or call to it failed.
;                  |2 - CreateFileMapping function or call to it failed.
;                  |3 - MapViewOfFile function or call to it failed.
;                  |4 - MD4Init function or call to it failed.
;                  |5 - MD4Update function or call to it failed.
;                  |6 - MD4Final function or call to it failed.
; Author ........: trancexx
;
;==========================================================================================
Func __MD4ForFile($sFile)
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
	Local $tMD4_CTX = DllStructCreate("dword i[2];" & "dword buf[4];" & "ubyte in[64];" & "ubyte digest[16]")
	DllCall("advapi32.dll", "none", "MD4Init", "ptr", DllStructGetPtr($tMD4_CTX))
	If @error Then
		DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
		Return SetError(4, 0, "")
	EndIf
	DllCall("advapi32.dll", "none", "MD4Update", "ptr", DllStructGetPtr($tMD4_CTX), "ptr", $pFile, "dword", $iBufferSize)
	If @error Then
		DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
		Return SetError(5, 0, "")
	EndIf
	DllCall("advapi32.dll", "none", "MD4Final", "ptr", DllStructGetPtr($tMD4_CTX))
	If @error Then
		DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
		Return SetError(6, 0, "")
	EndIf
	DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
	DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
	Local $sMD4 = Hex(DllStructGetData($tMD4_CTX, "digest"))
	Return SetError(0, 0, $sMD4)
EndFunc   ;==>__MD4ForFile

; #FUNCTION# ;===============================================================================
;
; Name...........: __MD5ForFile
; Description ...: Calculates MD5 value for the specific file.
; Syntax.........: __MD5ForFile ($sFile, $iRead)
; Parameters ....: $sFile - Full path to the file to process.
;                         $iRead - Percentage of the file to process.
; Return values .: Success - Returns MD5 value in form of hex string
;                          - Sets @error to 0
;                  Failure - Returns empty string and sets @error:
;                  |1 - CreateFile function or call to it failed.
;                  |2 - CreateFileMapping function or call to it failed.
;                  |3 - MapViewOfFile function or call to it failed.
;                  |4 - MD5Init function or call to it failed.
;                  |5 - MD5Update function or call to it failed.
;                  |6 - MD5Final function or call to it failed.
; Author ........: trancexx, guinness
;
;==========================================================================================
Func __MD5ForFile($sFile, $iRead = 100)
	If $iRead > 100 Then
		$iRead = 100
	EndIf
	$iRead = ($iRead / 100) * FileGetSize($sFile)

	Local $aResult = DllCall("kernel32.dll", "hwnd", "CreateFileW", "wstr", $sFile, "dword", 0x80000000, "dword", 1, "ptr", 0, "dword", 3, "dword", 0, "ptr", 0)
	If @error Or $aResult[0] = -1 Then
		Return SetError(1, 0, 0)
	EndIf
	Local $hFile = $aResult[0]
	$aResult = DllCall("kernel32.dll", "ptr", "CreateFileMappingW", "hwnd", $hFile, "dword", 0, "dword", 2, "dword", 0, "dword", 0, "ptr", 0)
	If @error Or Not $aResult[0] Then
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFile)
		Return SetError(1, 2, 0)
	EndIf
	DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFile)
	Local $hFileMappingObject = $aResult[0]
	$aResult = DllCall("kernel32.dll", "ptr", "MapViewOfFile", "hwnd", $hFileMappingObject, "dword", 4, "dword", 0, "dword", 0, "dword", $iRead)
	If @error Or Not $aResult[0] Then
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
		Return SetError(1, 3, 0)
	EndIf
	Local $hTempFile = $aResult[0]
	Local $iBufferSize = $iRead
	Local $sTempResult = DllStructCreate("dword i[2];" & "dword buf[4];" & "ubyte in[64];" & "ubyte digest[16]")
	DllCall("advapi32.dll", "none", "MD5Init", "ptr", DllStructGetPtr($sTempResult))
	If @error Then
		DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $hTempFile)
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
		Return SetError(1, 4, 0)
	EndIf
	DllCall("advapi32.dll", "none", "MD5Update", "ptr", DllStructGetPtr($sTempResult), "ptr", $hTempFile, "dword", $iBufferSize)
	If @error Then
		DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $hTempFile)
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
		Return SetError(1, 5, 0)
	EndIf
	DllCall("advapi32.dll", "none", "MD5Final", "ptr", DllStructGetPtr($sTempResult))
	If @error Then
		DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $hTempFile)
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
		Return SetError(1, 6, 0)
	EndIf
	DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $hTempFile)
	DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
	Local $sCheckSum = Hex(DllStructGetData($sTempResult, "digest"))
	Return SetError(0, 0, $sCheckSum)
EndFunc   ;==>__MD5ForFile

; #FUNCTION# ;===============================================================================
;
; Name...........: __SHA1ForFile
; Description ...: Calculates SHA1 value for the specific file.
; Syntax.........: __SHA1ForFile ($sFile)
; Parameters ....: $sFile - Full path to the file to process.
; Return values .: Success - Returns SHA1 value in form of hex string
;                          - Sets @error to 0
;                  Failure - Returns empty string and sets @error:
;                  |1 - CreateFile function or call to it failed.
;                  |2 - CreateFileMapping function or call to it failed.
;                  |3 - MapViewOfFile function or call to it failed.
;                  |4 - CryptAcquireContext function or call to it failed.
;                  |5 - CryptCreateHash function or call to it failed.
;                  |6 - CryptHashData function or call to it failed.
;                  |7 - CryptGetHashParam function or call to it failed.
; Author ........: trancexx
;
;==========================================================================================
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
