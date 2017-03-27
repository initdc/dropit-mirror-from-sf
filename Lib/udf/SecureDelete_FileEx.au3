#include-once
#include <WinAPI.au3>

Global Const $INVALID_FILE_ATTRIBUTES = 4294967295 ; (DWORD)-1
Global Const $FILE_ATTRIBUTES_SETTABLE = 0x31A7

Func _FileEx_AddAttributes($sPath, $iAttr)
    Local $iA = _FileEx_GetAttributes($sPath)
    If @error Then Return SetError(1, 0, 0)
    _FileEx_SetAttributes($sPath, BitOR($iA, $iAttr))
    If @error Then Return SetError(2, 0, 0)
    Return 1
EndFunc   ;==>_FileEx_AddAttributes

Func _FileEx_AttrSettable($iAttr)
    Return BitAND($iAttr, 0x31A7)
EndFunc   ;==>_FileEx_AttrSettable

Func _FileEx_CopyStruct($tSOURCE, $tagStruct, $iElem)
    Local $tCOPY = DllStructCreate($tagStruct)

    For $i = 1 To $iElem
        DllStructSetData($tCOPY, $i, DllStructGetData($tSOURCE, $i))
    Next

    Return $tCOPY
EndFunc   ;==>_FileEx_CopyStruct

Func _FileEx_CrackPath($sPath, $fRootOnly = False)
    ; make sure path is terminated
    $sPath = StringRegExpReplace($sPath, "\\+$", "") & "\"
    ; get prefix
    Local $aRet = StringRegExp($sPath, "(?i)^\\\\\?\\unc\\|\\\\\?\\|\\\\", 1)
    If Not IsArray($aRet) Then
        $aRet = ""
    Else
        $aRet = $aRet[0]
    EndIf
    ; capture and remove the root
    If ($aRet = "\\") Or ($aRet = "\\?\UNC\") Then
        ; UNC network path
        $aRet = StringRegExp($sPath, "(?i)^(" & StringReplace(StringReplace($aRet, "\", "\\"), "?", "\?") & ".*?\\.*?\\)", 1)
    Else
        ; $aRet = "" or \\?\ => local path
        Local $iTrim = StringLen($aRet) + 3
        Local $aRet[1] = [StringLeft($sPath, $iTrim)]
    EndIf
    If Not $fRootOnly Then
        Local $aPath = StringTrimLeft($sPath, StringLen($aRet[0]))
        ; check if path given was just a root
        If $aPath <> "" Then
            ; crack path, prepend \ to get first segment
            $aPath = StringRegExp("\" & $aPath, "\\(.*?)(?=\\)", 3)
            ReDim $aRet[UBound($aPath) + 1]
            For $i = 0 To UBound($aPath) - 1
                $aRet[$i + 1] = $aPath[$i]
            Next
        EndIf
    EndIf
    ;
    Return $aRet
EndFunc   ;==>_FileEx_CrackPath

Func _FileEx_CreateDirectory($sPath, $fCheckExists = True)
    ; check path already exists
    ; it is possible to save some overhead if you know in advance the directory
    ; does not exist, by setting $fCheckExists = False
    If $fCheckExists Then
        Local $iAttr = _FileEx_GetAttributes($sPath)
        If Not @error Then
            ; check if it is a direcotry
            If BitAND($iAttr, 0x10) = 0x10 Then
                Return 1
            Else
                Return SetError(1, 0, 0)
            EndIf
        EndIf
    EndIf
    ;
    ; remove any terminations
    $sPath = StringRegExpReplace($sPath, "\\+$", "")
    Local $aPath = _FileEx_CrackPath($sPath)
    ; make sure root exists
    Local $sSegment = $aPath[0]
    If Not FileExists($sSegment) Then Return SetError(2, 0, 0)
    Local $ret
    For $i = 1 To UBound($aPath) - 1
        $sSegment &= $aPath[$i] & "\"
        If Not FileExists($sSegment) Then
            ; create sub-path
            $ret = DllCall("kernel32.dll", "bool", "CreateDirectoryW", "wstr", $sSegment, "ptr", 0)
            If @error Or (Not $ret[0]) Then Return SetError(3, 0, 0)
        EndIf
    Next
    Return 1
EndFunc   ;==>_FileEx_CreateDirectory

Func _FileEx_CreateFile($sPath, $iAccess, $iShareMode, $iCreation, $iFlags)
    ; open the file with existing HIDDEN or SYSTEM attributes to avoid failure when using CREATE_ALWAYS
    If $iCreation = $CREATE_ALWAYS Then
        ; FILE_ATTRIBUTE_HIDDEN = 0x2, FILE_ATTRIBUTE_SYSTEM = 0x4
        Local $iAttr = _FileEx_GetAttributes($sPath)
        If Not @error Then
            If (BitAND($iAttr, 0x2) = 0x2) Then $iFlags = BitOR($iFlags, 0x2)
            If (BitAND($iAttr, 0x4) = 0x4) Then $iFlags = BitOR($iFlags, 0x4)
        EndIf
    EndIf
    Local $hFile = DllCall("kernel32.dll", "handle", "CreateFileW", "wstr", $sPath, "dword", $iAccess, "dword", $iShareMode, "ptr", 0, _
            "dword", $iCreation, "dword", $iFlags, "ptr", 0)
    If @error Or ($hFile[0] = Ptr(-1)) Then Return SetError(1, 0, 0)
    Return $hFile[0]
EndFunc   ;==>_FileEx_CreateFile

Func _FileEx_DeleteFile($sFile)
    Local $ret = DllCall("kernel32.dll", "bool", "DeleteFileW", "wstr", $sFile)
    If @error Or (Not $ret[0]) Then
        Return SetError(1, 0, 0)
    Else
        Return 1
    EndIf
EndFunc   ;==>_FileEx_DeleteFile

Func _FileEx_FileExists($sPath)
    _FileEx_GetAttributes($sPath)
    If @error Then Return SetError(@error, 0, 0)
    Return 1
EndFunc   ;==>_FileEx_FileExists

Func _FileEx_FindClose($hFind)
    Local $ret = DllCall("kernel32.dll", "bool", "FindClose", "handle", $hFind)

    If @error Or (Not $ret[0]) Then Return SetError(1, 0, 0)

    Return 1
EndFunc   ;==>_FileEx_FindClose

Func _FileEx_FINDDATA()
    Return DllStructCreate("dword dwFileAttributes;STRUCT;dword dwCreationTimeLow;dword dwCreationTimeHigh;ENDSTRUCT;" & _
            "STRUCT;dword dwAccessTimeLow;dword dwAccessTimeHigh;ENDSTRUCT;STRUCT;dword dwWriteTimeLow;dword dwWriteTimeHigh;ENDSTRUCT;" & _
            "dword nFileSizeHigh;dword nFileSizeLow;dword dwReserved0;dword dwReserved1;wchar cFileName[260];wchar cAlternateFileName[14]")
    ; The size of the file is equal to (nFileSizeHigh * (MAXDWORD+1)) + nFileSizeLow
    ; The size of the file is equal to (nFileSizeHigh * (4294967295+1)) + nFileSizeLow
EndFunc   ;==>_FileEx_FINDDATA

Func _FileEx_FillFINDDATA($sPath)
    Local $tFIND = _FileEx_FINDDATA()
    ; FILE_FLAG_BACKUP_SEMANTICS for folder handle
    Local $hFile = _FileEx_CreateFile($sPath, $GENERIC_READ, $FILE_SHARE_READ, $OPEN_EXISTING, 0x02000000)
    ; attributes
    DllStructSetData($tFIND, "dwFileAttributes", _FileEx_GetAttributes($sPath))
    ; time
    DllCall("kernel32.dll", "bool", "GetFileTime", "handle", $hFile, "struct*", DllStructGetPtr($tFIND, "dwCreationTimeLow"), _
            "struct*", DllStructGetPtr($tFIND, "dwAccessTimeLow"), "struct*", DllStructGetPtr($tFIND, "dwWriteTimeLow"))
    ; file size
;~     Local $tSIZE = DllStructCreate("dword low;dword high")
;~     DllStructSetData(DllStructCreate("int64", DllStructGetPtr($tSIZE)), 1, _WinAPI_GetFileSizeEx($hFile))
;~     DllStructSetData($tFIND, "nFileSizeHigh", DllStructGetData($tSIZE, "high"))
;~     DllStructSetData($tFIND, "nFileSizeLow", DllStructGetData($tSIZE, "low"))
    ; file name
    DllStructSetData($tFIND, "cFileName", StringRegExpReplace($sPath, ".*\\", ""))
    ; 8.3 name
    DllStructSetData($tFIND, "cAlternateFileName", StringRegExpReplace(FileGetShortName($sPath), ".*\\", ""))
    _WinAPI_CloseHandle($hFile)
    ;
    Return $tFIND
EndFunc  ;==>_FileEx_FillFINDDATA

Func _FileEx_FindFileCallback($sDir, $sCallback)
    ; callback gets 3 params:
    ; 1 - stage, 2 - path, 3 - FIND_DATA structure
    ; callback must return 1 or True to continue, otherwise the search ends
    ; if the callback returns 0 or False to end the search, the function set @error to the aborted stage

    ; remove trailing slash
    $sDir = StringRegExpReplace($sDir, "\\+$", "")

    ; folder arrays hold path, FIND_DATA, and depth
    Local $aSearchFolders[10][3] = [[1], [$sDir, _FileEx_FillFINDDATA($sDir), 0]]
    Local $aStoredFolders[10][3] = [[0]]
    Local $search, $sPath, $iDepth, $item, $iAttr, $srcFIND
    Local $hasDir = True
    Local $tagFINDDATA = "dword dwFileAttributes;STRUCT;dword dwCreationTimeLow;dword dwCreationTimeHigh;ENDSTRUCT;" & _
            "STRUCT;dword dwAccessTimeLow;dword dwAccessTimeHigh;ENDSTRUCT;STRUCT;dword dwWriteTimeLow;dword dwWriteTimeHigh;ENDSTRUCT;" & _
            "dword nFileSizeHigh;dword nFileSizeLow;dword dwReserved0;dword dwReserved1;wchar cFileName[260];wchar cAlternateFileName[14]"
    Local $tFIND = DllStructCreate($tagFINDDATA)

    Local Enum $iStageFile = 1, $iStageFolderFound, $iStageFolderEnter, $iStageFolderExit

    While $aSearchFolders[0][0]
        $sPath = $aSearchFolders[$aSearchFolders[0][0]][0]
        $srcFIND = $aSearchFolders[$aSearchFolders[0][0]][1]
        ; release ref to struct in search folder array
        $aSearchFolders[$aSearchFolders[0][0]][1] = 0
        $iDepth = $aSearchFolders[$aSearchFolders[0][0]][2]
        $aSearchFolders[0][0] -= 1

        ; check stored folder array and process anything stored with a depth >= current search depth
        ; iterate in reverse, never process the first entry though, that is the TLD and is handled at the end
        For $i = $aStoredFolders[0][0] To 2 Step -1
            ; check depth
            If $aStoredFolders[$i][2] >= $iDepth Then
                $aStoredFolders[0][0] -= 1
                If Not Call($sCallback, $iStageFolderExit, $aStoredFolders[$i][0], $aStoredFolders[$i][1]) Then Return SetError($iStageFolderExit, 0, $sPath)
                ; release stored struct
                $aStoredFolders[$i][1] = 0
            Else
                ; stop when we get to a depth that is too low
                ExitLoop
            EndIf
        Next

        ; callback start search
        If Not Call($sCallback, $iStageFolderEnter, $sPath, $srcFIND) Then Return SetError($iStageFolderEnter, 0, $sPath)

        $search = _FileEx_FindFirstFile($sPath & "\*", $tFIND)
        If $search Then
            Do
                $item = DllStructGetData($tFIND, "cFileName")
                If ($item <> ".") And ($item <> "..") Then
                    $iAttr = DllStructGetData($tFIND, "dwFileAttributes")
                    If BitAND($iAttr, 0x10) = 0x10 Then
                        ; folder, add to search array
                        $hasDir = True
                        $aSearchFolders[0][0] += 1
                        If $aSearchFolders[0][0] >= UBound($aSearchFolders) Then ReDim $aSearchFolders[UBound($aSearchFolders) * 2][3]
                        $aSearchFolders[$aSearchFolders[0][0]][0] = $sPath & "\" & $item
                        ; must make a copy of the struct (it is a pointer to static memory)
                        $aSearchFolders[$aSearchFolders[0][0]][1] = _FileEx_CopyStruct($tFIND, $tagFINDDATA, 13)
                        $aSearchFolders[$aSearchFolders[0][0]][2] = $iDepth + 1
                        ; callback
                        If Not Call($sCallback, $iStageFolderFound, $sPath & "\" & $item, $tFIND) Then
                            _FileEx_FindClose($search)
                            Return SetError($iStageFolderFound, 0, $sPath)
                        EndIf
                    Else
                        ; file, just callback
                        If Not Call($sCallback, $iStageFile, $sPath & "\" & $item, $tFIND) Then
                            _FileEx_FindClose($search)
                            Return SetError($iStageFile, 0, $sPath)
                        EndIf
                    EndIf
                EndIf
                ; next file
                _FileEx_FindNextFile($search, $tFIND)
            Until @error
            _FileEx_FindClose($search)
        EndIf

        ; check subdir flag and remove or store for later
        If $hasDir Then
            $hasDir = False
            ; add to stored array, this always includes the TLD
            $aStoredFolders[0][0] += 1
            If $aStoredFolders[0][0] >= UBound($aStoredFolders) Then ReDim $aStoredFolders[UBound($aStoredFolders) * 2][3]
            $aStoredFolders[$aStoredFolders[0][0]][0] = $sPath
            $aStoredFolders[$aStoredFolders[0][0]][1] = $srcFIND
            $aStoredFolders[$aStoredFolders[0][0]][2] = $iDepth
        Else
            ; folder done, callback
            If Not Call($sCallback, $iStageFolderExit, $sPath, $srcFIND) Then Return SetError($iStageFolderExit, 0, $sPath)
            ; release stored struct
            $srcFIND = 0
        EndIf
    WEnd

    ; finish stored list
    For $i = $aStoredFolders[0][0] To 1 Step -1
        If Not Call($sCallback, $iStageFolderExit, $aStoredFolders[$i][0], $aStoredFolders[$i][1]) Then Return SetError($iStageFolderExit, 0, $sPath)
    Next
EndFunc   ;==>_FileEx_FindFileCallback

Func _FileEx_FindFirstFile($sSearch, ByRef $tFIND)
    Local $ret = DllCall("kernel32.dll", "handle", "FindFirstFileW", "wstr", $sSearch, "struct*", $tFIND)

	If @error Then
		Return SetError(1, 0, 0)
	ElseIf $ret[0] = Ptr(-1) Then
        Return SetError(2, _WinAPI_GetLastError(), 0)
	EndIf

	Return $ret[0]
EndFunc   ;==>_FileEx_FindFirstFile

Func _FileEx_FindFirstFileEx($sSearch, ByRef $tFIND, $iInfoLevel = 0, $iSearchOp = 0, $dwFlags = 0)
    ; info level: 0 - standard, 1 - basic (no 8.3 name)
    ; search op: 0 - name match, 1 - only directories
    ; dwFlags: 1 - case sensitive, 2 - large directory query buffer (win 7+, srv 2008 R2+)
    Local $ret = DllCall("kernel32.dll", "handle", "FindFirstFileExW", "wstr", $sSearch, "int", $iInfoLevel, "struct*", $tFIND, _
            "int", $iSearchOp, "ptr", 0, "dword", $dwFlags)

	If @error Then
		Return SetError(1, 0, 0)
	ElseIf $ret[0] = Ptr(-1) Then
        Return SetError(2, _WinAPI_GetLastError(), 0)
	EndIf

	Return $ret[0]
EndFunc   ;==>_FileEx_FindFirstFileEx

Func _FileEx_FindNextFile($hFind, ByRef $tFIND)
    Local $ret = DllCall("kernel32.dll", "bool", "FindNextFileW", "handle", $hFind, "struct*", $tFIND)

	If @error Then
		Return SetError(1, 0, 0)
	ElseIf Not $ret[0] Then
        Return SetError(2, _WinAPI_GetLastError(), 0)
	EndIf

	Return 1
EndFunc

Func _FileEx_GetAttributes($sPath)
    ; readonly = 0x1
    ; hidden = 0x2
    ; system = 0x4
    ; directory = 0x10
    ; archive = 0x20
    ; device = 0x40
    ; normal = 0x80
    ; temporary = 0x100
    ; sparse_file = 0x200
    ; reparse_point = 0x400
    ; compressed = 0x800
    ; offline = 0x1000
    ; not_content_indexed = 0x2000
    ; encrypted = 0x4000
    ; all_settable = 0x31A7
    ; $INVALID_FILE_ATTRIBUTES = (DWORD)-1 = 4294967295
    Local $ret = DllCall("kernel32.dll", "dword", "GetFileAttributesW", "wstr", $sPath)
    If @error Or ($ret[0] = 4294967295) Then Return SetError(1, 0, -1)
    Return $ret[0]
EndFunc   ;==>_FileEx_GetAttributes

Func _FileEx_GetDiskClusterSize($sPath)
    Local $aRet = DllCall("kernel32.dll", "bool", "GetDiskFreeSpaceW", "wstr", _FileEx_PathGetRoot($sPath), "dword*", 0, "dword*", 0, "dword*", 0, "dword*", 0)
    If @error Or (Not $aRet[0]) Then Return SetError(1, 0, 0)
    Return ($aRet[2] * $aRet[3])
EndFunc   ;==>_FileEx_GetDiskClusterSize

Func _FileEx_GetDiskSectorSize($sPath)
    Local $aRet = DllCall("kernel32.dll", "bool", "GetDiskFreeSpaceW", "wstr", _FileEx_PathGetRoot($sPath), "dword*", 0, "dword*", 0, "dword*", 0, "dword*", 0)
    If @error Or (Not $aRet[0]) Then Return SetError(1, 0, 0)
    Return $aRet[3]
EndFunc   ;==>_FileEx_GetDiskSectorSize

Func _FileEx_GetFileTime($sPath, ByRef $tCreated, ByRef $tAccessed, ByRef $tModified)
    $tCreated = DllStructCreate("dword;dword")
    $tAccessed = DllStructCreate("dword;dword")
    $tModified = DllStructCreate("dword;dword")
    ; FILE_FLAG_BACKUP_SEMANTICS so we can get dir handles
    Local $hFile = _FileEx_CreateFile($sPath, $GENERIC_READ, $FILE_SHARE_READ, $OPEN_EXISTING, 0x02000000)
    Local $err = 0
    Local $ret = DllCall("kernel32.dll", "bool", "GetFileTime", "handle", $hFile, "struct*", $tCreated, "struct*", $tAccessed, "struct*", $tModified)
    If @error Or (Not $ret[0]) Then $err = 1
    _WinAPI_CloseHandle($hFile)
    Return SetError($err, 0, Abs($err - 1))
EndFunc   ;==>_FileEx_GetFileTime

Func _FileEx_GetFullPathName($sFile, $sBasePath = @WorkingDir)
    Local $sWorkingDir = @WorkingDir
    If Not FileChangeDir($sBasePath) Then Return SetError(1, 0, "")
    Local $ret = DllCall("kernel32.dll", "dword", "GetFullPathNameW", "wstr", $sFile, "dword", 4096, "wstr", "", "ptr", 0)
    Local $nError = @error
    FileChangeDir($sWorkingDir)
    If $nError Or (Not $ret[0]) Then
        Return SetError(2, 0, "")
    Else
        Return $ret[3]
    EndIf
EndFunc   ;==>_FileEx_GetFullPathName

Func _FileEx_GetTempFile($s_DirectoryName = @TempDir, $s_FilePrefix = "~", $s_FileExtension = ".tmp", $i_RandomLength = 7)
    ; Check parameters
    If Not FileExists($s_DirectoryName) Then Return SetError(1, 0, 0)
    ; add trailing \ for directory name
    If StringRight($s_DirectoryName, 1) <> "\" Then $s_DirectoryName &= "\"
    ;
    Local $s_TempName
    Do
        $s_TempName = ""
        While StringLen($s_TempName) < $i_RandomLength
            $s_TempName &= Chr(Random(97, 122, 1))
        WEnd
        $s_TempName = $s_DirectoryName & $s_FilePrefix & $s_TempName & $s_FileExtension
    Until Not FileExists($s_TempName)
    ;
    Return $s_TempName
EndFunc   ;==>_FileEx_GetTempFile

Func _FileEx_HasAttributes($sPath, $iAttr)
    Local $iA = _FileEx_GetAttributes($sPath)
    If @error Then Return SetError(1, 0, 0)
    Return Number(BitAND($iA, $iAttr) = $iAttr)
EndFunc   ;==>_FileEx_HasAttributes

Func _FileEx_IsDirectory($sPath)
    Local $ret = _FileEx_HasAttributes($sPath, 0x10)
    If @error Then Return SetError(1, 0, 0)
    Return $ret
EndFunc   ;==>_FileEx_IsDirectory

Func _FileEx_IsReparsePoint($sPath)
    Local $ret = _FileEx_HasAttributes($sPath, 0x400)
    If @error Then Return SetError(1, 0, 0)
    Return $ret
EndFunc   ;==>_FileEx_IsReparsePoint

Func _FileEx_MoveFile($sSource, $sDest)
    ; MOVEFILE_WRITE_THROUGH
    Local $ret = DllCall("kernel32.dll", "bool", "MoveFileExW", "wstr", $sSource, "wstr", $sDest, "dword", 0x8)
    If @error Or (Not $ret[0]) Then
        Return SetError(1, 0, 0)
    Else
        Return 1
    EndIf
EndFunc   ;==>_FileEx_MoveFile

Func _FileEx_PathCombine($sFile, $sBasePath = @WorkingDir)
    Local $ret = DllCall("shlwapi.dll", "ptr", "PathCombineW", "wstr", "", "wstr", $sBasePath, "wstr", $sFile)
    If @error Or (Not $ret[0]) Then
        Return SetError(1, 0, "")
    Else
        Return $ret[1]
    EndIf
EndFunc   ;==>_FileEx_PathCombine

Func _FileEx_PathGetRoot($sPath)
    Local $sRoot = _FileEx_PathStripToRoot($sPath)
    If StringRight($sRoot, 1) <> "\" Then $sRoot &= "\"
    Return $sRoot
EndFunc   ;==>_FileEx_PathGetRoot

Func _FileEx_PathRemoveFileSpec($sPath)
    Local $r = DllCall("shlwapi.dll", "bool", "PathRemoveFileSpecW", "wstr", $sPath)
    If @error Or ($r[0] = 0) Then
        Return SetError(1, 0, "")
    Else
        Return $r[1]
    EndIf
EndFunc   ;==>_FileEx_PathRemoveFileSpec

Func _FileEx_PathRemoveExtension($sPath)
    Local $r = DllCall("shlwapi.dll", "none", "PathRemoveExtensionW", "wstr", $sPath)
    If @error Then
        Return SetError(1, 0, "")
    Else
        Return $r[1]
    EndIf
EndFunc   ;==>_FileEx_PathRemoveExtension

Func _FileEx_PathRenameExtension($sPath, $sExt)
    Local $r = DllCall("shlwapi.dll", "bool", "PathRenameExtensionW", "wstr", $sPath, "wstr", $sExt)
    If @error Or ($r[0] = 0) Then
        Return SetError(1, 0, "")
    Else
        Return $r[1]
    EndIf
EndFunc   ;==>_FileEx_PathRenameExtension

Func _FileEx_PathStripPath($sPath)
    Local $r = DllCall("shlwapi.dll", "none", "PathStripPathW", "wstr", $sPath)
    If @error Then
        Return SetError(1, 0, "")
    Else
        Return $r[1]
    EndIf
EndFunc   ;==>_FileEx_PathStripPath

Func _FileEx_PathStripToRoot($sPath)
    Local $r = DllCall("shlwapi.dll", "bool", "PathStripToRootW", "wstr", $sPath)
    If @error Or ($r[0] = 0) Then
        Return SetError(1, 0, "")
    Else
        Return $r[1]
    EndIf
EndFunc   ;==>_FileEx_PathStripToRoot

Func _FileEx_RemoveAttributes($sPath, $iAttr)
    Local $iA = _FileEx_GetAttributes($sPath)
    If @error Then Return SetError(1, 0, 0)
    _FileEx_SetAttributes($sPath, BitAND($iA, BitNOT($iAttr)))
    If @error Then Return SetError(2, 0, 0)
    Return 1
EndFunc   ;==>_FileEx_RemoveAttributes

Func _FileEx_RemoveDirectory($sDir)
    Local $ret = DllCall("kernel32.dll", "bool", "RemoveDirectoryW", "wstr", $sDir)
    If @error Or (Not $ret[0]) Then
        Return SetError(1, 0, 0)
    Else
        Return 1
    EndIf
EndFunc   ;==>_FileEx_RemoveDirectory

Func _FileEx_RemoveDirectoryRecursive($sPath)
    ; check it exists
    If Not FileExists($sPath) Then Return SetError(1, 0, 0)
    ; remove trailing \'s
    $sPath = StringRegExpReplace($sPath, "\\+$", "")
    ; check it is a directory
    If Not _FileEx_IsDirectory($sPath) Then Return SetError(2, 0, 0)
    ;
    Local $errpath = _FileEx_FindFileCallback($sPath, "_FileEx_RDRCallback")
    If @error Then
        Return SetError(@error, 0, $errpath)
    Else
        Return 1
    EndIf
EndFunc   ;==>_FileEx_RemoveDirectoryRecursive

Func _FileEx_RDRCallback($iStage, $sPath);, $tFIND)
    Local $ret
    Switch $iStage
        Case 1
            ; file
            $ret = DllCall("kernel32.dll", "bool", "DeleteFileW", "wstr", $sPath)
            If @error Or (Not $ret[0]) Then Return False
        Case 4
            ; folder exit (folder is empty)
            $ret = DllCall("kernel32.dll", "bool", "RemoveDirectoryW", "wstr", $sPath)
            If @error Or (Not $ret[0]) Then Return False
    EndSwitch
    Return True
EndFunc   ;==>_FileEx_RDRCallback

;~ Func _FileEx_RemoveDirectoryRec($sPath, $fRoot = True)
;~     ; only run checks for root path
;~     If $fRoot Then
;~         ; check it exists
;~         If Not FileExists($sPath) Then Return SetError(1, 0, 0)
;~         ; remove trailing \'s
;~         $sPath = StringRegExpReplace($sPath, "\\+$", "")
;~         ; check it is a directory
;~         If Not _FileEx_IsDirectory($sPath) Then Return SetError(2, 0, 0)
;~     EndIf
;~     ;
;~     Local $item, $ret
;~     Local $search = FileFindFirstFile($sPath & "\*.*")
;~     If $search <> -1 Then
;~         While 1
;~             $item = FileFindNextFile($search)
;~             If @error Then ExitLoop
;~             If @extended Then
;~                 ; sub-dir
;~                 _FileEx_RemoveDirectoryRec($sPath & "\" & $item, False)
;~                 If @error Then
;~                     FileClose($search)
;~                     Return SetError(3, 0, 0)
;~                 EndIf
;~             Else
;~                 ; file
;~                 $ret = DllCall("kernel32.dll", "bool", "DeleteFileW", "wstr", $sPath & "\" & $item)
;~                 If @error Or (Not $ret[0]) Then
;~                     FileClose($search)
;~                     Return SetError(4, 0, 0)
;~                 EndIf
;~             EndIf
;~         WEnd
;~         FileClose($search)
;~     EndIf
;~     ; delete dir
;~     $ret = DllCall("kernel32.dll", "bool", "RemoveDirectoryW", "wstr", $sPath)
;~     If @error Or (Not $ret[0]) Then Return SetError(5, 0, 0)
;~     Return 1
;~ EndFunc   ;==>_FileEx_RemoveDirectoryRec

Func _FileEx_SetAttributes($sPath, $iAttr)
    Local $ret = DllCall("kernel32.dll", "bool", "SetFileAttributesW", "wstr", $sPath, "dword", _FileEx_AttrSettable($iAttr))
    If @error Or (Not $ret[0]) Then Return SetError(1, 0, 0)
    Return 1
EndFunc   ;==>_FileEx_SetAttributes

Func _FileEx_SetFileTime($sPath, Const ByRef $tCreated, Const ByRef $tAccessed, Const ByRef $tModified)
    ; check structs, get pointers
    Local $pC = 0, $pA = 0, $pM = 0
    If IsDllStruct($tCreated) Then $pC = $tCreated
    If IsDllStruct($tAccessed) Then $pA = $tAccessed
    If IsDllStruct($tModified) Then $pM = $tModified
    ; FILE_FLAG_BACKUP_SEMANTICS so we can set dir handles
    Local $hFile = _FileEx_CreateFile($sPath, BitOR($GENERIC_READ, $GENERIC_WRITE), BitOR($FILE_SHARE_READ, $FILE_SHARE_WRITE), $OPEN_EXISTING, 0x02000000)
    Local $err = 0
    Local $ret = DllCall("kernel32.dll", "bool", "SetFileTime", "handle", $hFile, "struct*", $pC, "struct*", $pA, "struct*", $pM)
    If @error Or (Not $ret[0]) Then $err = 1
    _WinAPI_CloseHandle($hFile)
    Return SetError($err, 0, Abs($err - 1))
EndFunc   ;==>_FileEx_SetFileTime
