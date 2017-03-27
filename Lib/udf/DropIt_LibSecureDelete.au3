
; Secure delete funtions collected for DropIt
; Taken From: http://www.autoitscript.com/forum/topic/82954-securely-overwrite-files/

#include-once
#include "APIConstants.au3"
#include <DropIt_LibFiles.au3>
#include <Memory.au3>
#include "WinAPIEx.au3"

Func __SecureFileDelete($sFile, $sRename = True, $sFileTime = True, $sDelete = True, $sInputPatterns = -1, $sBlock = 32768)
	#cs
		Description: Securely Delete A File.
		Returns: Deleted File.
	#ce
	Local $sPatterns[3]
	If FileExists($sFile) = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	If $sInputPatterns = -1 Then ; Default DoD 3-Pass Method.
		$sPatterns[0] = Random(0, 255, 1)
		$sPatterns[1] = BitAND(BitNOT($sPatterns[0]), 0xFF)
		$sPatterns[2] = Random(0, 255, 1)
	Else ; Custom Method.
		If IsArray($sInputPatterns) = 0 Then
			Return SetError(2, 0, 0)
		EndIf
		ReDim $sPatterns[UBound($sInputPatterns) + 1]
		For $A = 0 To UBound($sInputPatterns) - 1
			$sPatterns[$A] = $sInputPatterns[$A]
			If ($sPatterns[$A] < 0) Or ($sPatterns[$A] > 255) Then
				Return SetError(2, 0, 0)
			EndIf
		Next
	EndIf

	Local $sFileOpen = __SecureFileDelete_CreateFile($sFile, $GENERIC_WRITE, 0, $OPEN_EXISTING, 0xB0000000) ; FILE_FLAG_RANDOM_ACCESS | FILE_FLAG_NO_BUFFERING | FILE_FLAG_WRITE_THROUGH
	If $sFileOpen = 0 Then
		Return SetError(3, 0, 0)
	EndIf
	Local $sFileGetSize = _WinAPI_GetFileSizeEx($sFileOpen)
	Local $ClusterSize = __SecureFileDelete_GetDiskClusterSize($sFile)
	If @error Then
		$ClusterSize = 512
	EndIf

	$sBlock = Ceiling($sBlock / $ClusterSize) * $ClusterSize
	Local $sBuffer = _MemVirtualAlloc(0, $sBlock, $MEM_COMMIT, $PAGE_READWRITE)
	Local $sCycle = Ceiling($sFileGetSize / $sBlock)
	Local $sBytes, $sError = 0

	For $A = 0 To (UBound($sPatterns) - 1)
		DllCall("msvcrt.dll", "ptr:cdecl", "memset", "ptr", $sBuffer, "int", $sPatterns[$A], "ulong_ptr", $sBlock)
		For $B = 1 To $sCycle
			If _WinAPI_WriteFile($sFileOpen, $sBuffer, $sBlock, $sBytes) = False Then
				$sError = 1
				ExitLoop 2
			EndIf
		Next
		DllCall("kernel32.dll", "bool", "SetFilePointerEx", "handle", $sFileOpen, "int64", 0, "ptr", 0, "dword", 0)
	Next
	_MemVirtualFree($sBuffer, 0, $MEM_RELEASE)
	_WinAPI_CloseHandle($sFileOpen)
	If $sError Then
		Return SetError(4, 0, 0)
	EndIf

	If $sRename Then
		Local $sDir = StringRegExpReplace($sFile, "^(.*)\\.*?$", "${1}")
		Local $sTempFile
		For $A = 1 To 3 ; Rename The File 3 Times.
			$sTempFile = _WinAPI_GetTempFileName($sDir)
			FileMove($sFile, $sTempFile, 1)
			$sFile = $sTempFile
		Next
	EndIf
	If $sFileTime Then
		For $A = 0 To 2
			FileSetTime($sFile, "19800101000001", $A)
		Next
	EndIf
	If $sDelete Then
		FileDelete($sFile)
	EndIf
	Return $sFile
EndFunc   ;==>__SecureFileDelete

Func __SecureFileDelete_CreateFile($sFilePath, $sAccess, $sShareMode, $sCreation, $sFlags)
	If $sCreation = $CREATE_ALWAYS Then ; Open The File With Existing Hidden Or System Attributes To Avoid Failure When Using Create_Always.
		Local $sFileGetAttribute = FileGetAttrib($sFilePath)
		If StringInStr($sFileGetAttribute, "H") Then
			$sFlags = BitOR($sFlags, $FILE_ATTRIBUTE_HIDDEN)
		EndIf
		If StringInStr($sFileGetAttribute, "S") Then
			$sFlags = BitOR($sFlags, $FILE_ATTRIBUTE_SYSTEM)
		EndIf
	EndIf
	Local $sFile = DllCall("kernel32.dll", "handle", "CreateFileW", "wstr", $sFilePath, "dword", $sAccess, "dword", $sShareMode, "ptr", 0, _
			"dword", $sCreation, "dword", $sFlags, "ptr", 0)
	If @error Or ($sFile[0] = Ptr(-1)) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $sFile[0]
EndFunc   ;==>__SecureFileDelete_CreateFile

Func __SecureFileDelete_GetDiskClusterSize($sPath)
	Local $sReturn = DllCall("kernel32.dll", "bool", "GetDiskFreeSpaceW", "wstr", __GetDrive($sPath), "dword*", 0, "dword*", 0, "dword*", 0, "dword*", 0)
	If @error Or (Not $sReturn[0]) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $sReturn[3]
EndFunc   ;==>__SecureFileDelete_GetDiskClusterSize

Func __SecureFolderDelete($sFolder, $sRename = True, $sFileTime = True, $sDelete = True, $sPatterns = -1, $sBlock = 32768)
	#cs
		Description: Securely Delete A Folder.
		Returns: 1
	#ce
	If _WinAPI_PathIsDirectory($sFolder) = 0 Or FileExists($sFolder) = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	Local $sSearch, $sFile

	$sSearch = FileFindFirstFile($sFolder & '\*.*')
	If $sSearch = -1 Then
		Switch @error
			Case 1 ; Folder Is Empty.
				DirRemove($sFolder, 1)
			Case Else
				Return SetError(-1, 0, 0)
		EndSwitch
	EndIf
	While 1
		$sFile = FileFindNextFile($sSearch)
		If @error Then ; No More Files/Folders Match The Search.
			FileClose($sSearch)
			DirRemove($sFolder, 1)
			Return 1
		EndIf
		If @extended Then ; If Selected Item Is A Folder.
			__SecureFolderDelete($sFile, $sRename, $sFileTime, $sDelete, $sPatterns, $sBlock)
			If @error Then
				ExitLoop
			EndIf
		Else
			__SecureFileDelete($sFile, $sRename, $sFileTime, $sDelete, $sPatterns, $sBlock)
			If @error Then
				ExitLoop
			EndIf
		EndIf
	WEnd
	FileClose($sSearch)

	Return SetError(1, 0, 0)
EndFunc   ;==>__SecureFolderDelete
