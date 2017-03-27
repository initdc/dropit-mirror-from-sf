#cs

IMPORTANT NOTES
===============

PATTERNS
--------

Overwrite patterns may be given to the functions as a single integer or array of integers 0 <= i <= 255. If a single integer
is given, one overwrite pass will be performed with that integer. If an array is given, then one pass will be performed for each
member of the array. If -1 is given, the default DoD_E short method will be used.

BUFFERS
-------

Global buffers are created which will contain the overwriting patterns on the first call to any of the functions. These buffers
are 2 MB in size, one will be created for each overwrite pass, and they will exist for the life of the script. This is done for
performance reasons. The buffers will be recreated if you pass a different value or array for $aPatterns, or if you manually
call the _SD_FreeBuffers() function.

_SD_FreeBuffers() is registered as an Exit function with OnAutoItExitRegister.

For example, if you are ambitious enough to create 35 passes similar to Gutmann, the script will allocate ~70 MB.

Note:
Gutmann uses some mutlibyte pass patterns, so it cannot be faithfully recreated in the current implementation.

FILE / FOLDER REMOVAL
---------------------

If there is an error when the script attempts to rename and delete files or folders after overwriting, the original name will be
restored. The file and folder times will not be restored, and the file likely will have been truncated to 0 bytes.

#ce

#include-once
#include <Memory.au3>
#include <WinAPI.au3>
#include "SecureDelete_FileEx.au3"
#include "SecureDelete_FileMapping.au3"

; #GLOBALS# =====================================================================================================================
Global $__g_apBuffers = 0, $__g_iMaxWriteSize = (1024 ^ 2) * 2, $__g_hCryptContext[2] = [0, 0]
; ===============================================================================================================================

; #EXIT FUNCTION ================================================================================================================
OnAutoItExitRegister("_SD_FreeBuffers")
; ===============================================================================================================================

#region FUNCTIONS
; #FUNCTION# ====================================================================================================================
; Name ..........: _SecureDirectoryDelete
; Description ...: Recursively securely remove a directory and files
; Syntax ........: _SecureDirectoryDelete($sDir[, $aPatterns = -1[, $fDelete = True[, $sCallback = ""]]])
; Parameters ....: $sDir                - Path to directory to securely delete.
;                  $aPatterns           - [optional] User array of integers 0 to 255 (decimal or hex) to use as patterns
;                                         $aPatterns[] = [0xAA,0x4F,135,etc...]
;                                         If $aPatterns = -1, then the default DoD_E method is used
;                                         If $aPatterns is an integer 0 <= i <= 255 then i will be used for a single pass.
;                                         If $aPatters[n] is -1, then the buffer will be filled with pseudo-random data each
;                                         time it is used. This will incur a performance penalty.
;                  $fDelete             - [optional] Delete the top level dir when finished (Default = True)
;                  $sCallback           - [optional] Callback function that receives bytes written and total bytes *per file*
; Return values .: Success              - Returns 1
;                  Failure              - Array of errors and sets @error, applicable to the top level directory
;                                         Errors for subdirs and files are returned in the error array
;                                       | 1 - $sDir does not exist
;                                       | 2 - $sDir is not a directory
;                                       | 3 - Error removing directory (for example, it is not empty)
;                                       | 4 - Error with user array
;                                       | 5 - Error allocating buffers
;                                       | 6 - Errors were encountered, but $fDelete was False for top level dir
;                                       Error array:
;                                       [0][0] - Number of errors
;                                       [n][0] - Error number (see this function for dir errors, _SecureFileDelete for file errors)
;                                       [n][1] - Path at which error was encountered
;                                       [n][2] - Type of path item: 1 - file, 2 - folder
; Author ........: Erik Pilsits
; Modified ......:
; Remarks .......: Directory junctions and symbolic links will be simply deleted, they will NOT be followed.
;                  $fDelete only applies to the top directory level, all subdirs will be removed regardless.
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _SecureDirectoryDelete($sDir, $aPatterns = -1, $fDelete = True, $sCallback = "")
    ; error array
    ; [0][0] - total, [n][0] - err #, [n][1] - path, [n][2] - type: 1 - file, 2 - folder
    Local $aErr[1][3] = [[0]]

    ; remove trailing slash
    $sDir = StringRegExpReplace($sDir, "\\+$", "")
    ; check dir
    Local $iAttr = _FileEx_GetAttributes($sDir)
    If @error Then
        _SD_AddError($aErr, 1, $sDir, 2)
        Return SetError(1, 0, $aErr)
    EndIf
    If Not _SD_IsDirectory($iAttr) Then
        _SD_AddError($aErr, 2, $sDir, 2)
        Return SetError(2, 0, $aErr)
    EndIf

    ; if directory is a junction or symbolic link do a simple delete, do NOT follow it
    If _SD_IsReparsePoint($iAttr) Then
        If $fDelete Then
            _SD_DeleteDir($sDir)
            If @error Then
                _SD_AddError($aErr, 3, $sDir, 2)
                Return SetError(3, 0, $aErr)
            EndIf
        EndIf
    Else
        ; check patterns, create buffers
        ;
        ; this is only done once for performance reasons, this being an iterative function
        ;
        _SD_CheckPatterns($aPatterns)
        Switch @error
            Case 1
                Return SetError(4, 0, $aErr)
            Case 2
                Return SetError(5, 0, $aErr)
        EndSwitch
        ;
        ; TLD is set as first folder with depth = 0
        Local $aSearchFolders[10][2] = [[1], [$sDir, 0]]
        Local $aFoldersToRemove[10][2] = [[0]]
        Local $search, $item, $sPath, $iDepth
        ; set subdir flag to True initially so TLD is always stored in removal array
        ; this way, in case it has only files, we can respect $fDelete by never removing [1] automatically
        Local $hasDir = True
        Local $tFIND = _FileEx_FINDDATA()

        While $aSearchFolders[0][0]
            ; set depth based on the directory being searched, as stored in the array
            $iDepth = $aSearchFolders[$aSearchFolders[0][0]][1]
            $sPath = $aSearchFolders[$aSearchFolders[0][0]][0]
            $aSearchFolders[0][0] -= 1

            ; prune directories
            ; we do this to optimize memory usage by not storing directories that can be removed now
            ;
            ; check folder removal array and remove anything stored with a depth >= current search depth
            ; iterate in reverse, never remove the first entry though, that is the TLD and is handled at the end
            For $i = $aFoldersToRemove[0][0] To 2 Step -1
                ; check depth
                If $aFoldersToRemove[$i][1] >= $iDepth Then
;~                     ConsoleWrite(">prune: " & $aFoldersToRemove[$i][1] & ":" & $aFoldersToRemove[$i][0] & @CRLF)
                    $aFoldersToRemove[0][0] -= 1
                    _SD_DeleteDir($aFoldersToRemove[$i][0])
                    If @error Then _SD_AddError($aErr, 3, $aFoldersToRemove[$i][0], 2)
                Else
                    ; stop when we get to a depth that is too low
                    ExitLoop
                EndIf
            Next

;~             ConsoleWrite("search: " & $iDepth & ":" & $sPath & @CRLF)
            $search = _FileEx_FindFirstFile($sPath & "\*", $tFIND)
            If $search Then
                Do
                    $item = DllStructGetData($tFIND, "cFileName")
                    If ($item <> ".") And ($item <> "..") Then
                        $iAttr = DllStructGetData($tFIND, "dwFileAttributes")
                        If _SD_PathIsDir($iAttr) Then
                            ; directory
                            ; check for junction / symlink
                            If _SD_IsReparsePoint($iAttr) Then
                                ; just delete it
                                _SD_DeleteDir($sPath & "\" & $item)
                                If @error Then _SD_AddError($aErr, 3, $sPath & "\" & $item, 2)
                            Else
                                $hasDir = True
                                ; add to search array at the next incremented depth
    ;~                             ConsoleWrite("+add: " & $iDepth + 1 & ":" & $sPath & "\" & $item & @CRLF)
                                _SD_AddToArray2DLarge($aSearchFolders, $sPath & "\" & $item, $iDepth + 1)
                            EndIf
                        Else
                            ; file
                            _SecureFileDelete($sPath & "\" & $item, $aPatterns, True, $sCallback, $iAttr)
                            If @error Then _SD_AddError($aErr, @error, $sPath & "\" & $item, 1)
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
;~                 ConsoleWrite("!storing: " & $iDepth & ":" & $sPath & @CRLF)
                ; add for later removal, this always includes the TLD
                _SD_AddToArray2DLarge($aFoldersToRemove, $sPath, $iDepth)
            Else
                ; folder is empty, remove now
;~                 ConsoleWrite("-removing: " & $iDepth & ":" & $sPath & @CRLF)
                _SD_DeleteDir($sPath)
                If @error Then _SD_AddError($aErr, 3, $sPath, 2)
            EndIf
        WEnd

        ; remove remaining directories, respect $fDelete for TLD in [1]
        For $i = $aFoldersToRemove[0][0] To 1 Step -1
            If ($i > 1) Or $fDelete Then
                _SD_DeleteDir($aFoldersToRemove[$i][0])
;~                 ConsoleWrite("cleanup: " & $aFoldersToRemove[$i][1] & ":" & $aFoldersToRemove[$i][0] & @CRLF)
                If @error Then _SD_AddError($aErr, 3, $aFoldersToRemove[$i][0], 2)
            EndIf
        Next
    EndIf

    If $aErr[0][0] Then
        If $fDelete Then
            Return SetError(3, 0, $aErr)
        Else
            ; error return for TLD when $fDelete is False
            Return SetError(6, 0, $aErr)
        EndIf
    Else
        Return 1
    EndIf
EndFunc   ;==>_SecureDirectoryDelete

; #FUNCTION# ====================================================================================================================
; Name ..........: _SecureFileDelete
; Description ...: Securely overwrite a file.
; Syntax ........: _SecureFileDelete($sFile[, $aPatterns = -1[, $fDelete = True[, $sCallback = ""]]])
; Parameters ....: $sFile               - Path to file to securely delete.
;                  $aPatterns           - [optional] User array of integers 0 to 255 (decimal or hex) to use as patterns
;                                         $aPatterns[] = [0xAA,0x4F,135,etc...]
;                                         If $aPatterns = -1, then the default DoD_E method is used
;                                         If $aPatterns is an integer 0 <= i <= 255 then i will be used for a single pass.
;                                         If $aPatters[n] is -1, then the buffer will be filled with pseudo-random data each
;                                         time it is used. This will incur a performance penalty.
;                  $fDelete             - [optional] Delete the file when finished (Default = True)
;                  $sCallback           - [optional] Callback function that receives bytes written and total bytes
;                  $iAttr               - [optional] Attributes as returned by _FileEx_GetAttributes for the source file
; Return values .: Success              - Returns 1
;                  Failure              - 0 and sets @error
;                                       | 1 - $sFile does not exist
;                                       | 2 - $sFile is a directory
;                                       | 3 - Error with the user array
;                                       | 4 - Error getting file map and/or device info
;                                       | 5 - Error opening file
;                                       | 6 - Error allocating buffer
;                                       | 7 - Error overwriting file
;                                       | 8 - Error creating temp file
;                                       | 9 - Error removing file
;                                       |10 - Error overwriting special sectors
;                                             **If this error is returned, the file has been deleted, however there is no
;                                             guarantee that all data from these sectors was overwritten.
;                                             It is recommended to do a freespace wipe.
; Author ........: Erik Pilsits
; Modified ......:
; Remarks .......: If the file is Encrypted, Compressed, or Sparse, it will be deleted regardless. This is necessary to
;                  overwrite the clusters on disk containing the data.
;                  File symbolic links will be simply deleted, NOT followed or overwritten.
;                  File hard links however WILL be overwritten. WARNING!!
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _SecureFileDelete($sFile, $aPatterns = -1, $fDelete = True, $sCallback = "", $iAttr = Default)
    ;
    ; check input file
    ;
    If $iAttr = Default Then
        $iAttr = _FileEx_GetAttributes($sFile)
        If @error Then Return SetError(1, 0, 0)
    EndIf
    If _SD_IsDirectory($iAttr) Then Return SetError(2, 0, 0)
    ; if file is a symbolic link, do a simple delete, do NOT follow it
    ; hard links will NOT be detected and WILL be overwritten however, WARNING!!!
    If _SD_IsReparsePoint($iAttr) Then
        If $fDelete Then
            _SD_DeleteFile($sFile)
            If @error Then
                Return SetError(9, 0, 0)
            Else
                Return 1
            EndIf
        Else
            Return 1
        EndIf
    EndIf
    ;
    ; check patterns, create buffers
    ;
    _SD_CheckPatterns($aPatterns)
    Switch @error
        Case 1
            Return SetError(3, 0, 0)
        Case 2
            Return SetError(6, 0, 0)
    EndSwitch
    ;
    ; declare some vars, set some defaults
    Local $hFile, $eraseMethod = 1, $iWriteSize, $iClusters, $iErr = 0
    ;
    ; get file map
    ;
    Local $aMAP = _FM_GetFileMapping($sFile)
    ;
    Switch @error
        Case 0, 4
            ; @error = 4 means 0 extents: file is wholly in MFT on NTFS or this is a FAT / FAT32 drive, use normal erase
            ; @error = 0 means file is on disk: check if encrypted, compressed, or sparse, then use special erase
            If (@error = 0) And _SD_IsSpecialFile($iAttr) Then $eraseMethod = 2
        Case Else
            ; unrecoverable error
            Return SetError(4, 0, 0)
    EndSwitch
    ;
    Switch $eraseMethod
        Case 1
            ; normal erase method used for regular files on disk and files in MFT
            ;
            ; FILE_FLAG_RANDOM_ACCESS | FILE_FLAG_WRITE_THROUGH
            ; 0x10000000              | 0x80000000
            $hFile = _FileEx_CreateFile($sFile, $GENERIC_WRITE, BitOR($FILE_SHARE_READ, $FILE_SHARE_WRITE), $OPEN_EXISTING, 0x90000000)
            If Not $hFile Then Return SetError(5, 0, 0)
            ;
            ; set write size to 2M if file is bigger than 2M, otherwise 64K
            If $aMAP[0][3] > $__g_iMaxWriteSize Then
                $iWriteSize = $__g_iMaxWriteSize
            Else
                $iWriteSize = 1024 * 64
            EndIf
            ;
            ; remove attributes, set NORMAL
            _FileEx_SetAttributes($sFile, 0x80)
            ;
            ; overwrite it
            _SD_SecureOverwrite($hFile, $aMAP[0][3], $iWriteSize, $aPatterns, $sCallback)
            If @error Then $iErr = 1
            ;
            _WinAPI_CloseHandle($hFile)
            ;
            If $iErr Then Return SetError(7, 0, 0)
        Case 2
            ; special erase method used for encrypted, compressed, or sparse files
            ;
            ; NOTE: This method first deletes the file then uses the defragmentation API to move a cluster sized file
            ; into the vacated sectors, essentially overwriting the old data.
            ;
            ; prepare...
            ;
            ; create temp file on same volume as target file
            Local $sDrive = _FileEx_PathGetRoot($sFile)
            Local $sTemp = _FileEx_GetTempFile($sDrive)
            ; FILE_FLAG_RANDOM_ACCESS | FILE_FLAG_NO_BUFFERING | FILE_FLAG_WRITE_THROUGH | FILE_ATTRIBUTE_HIDDEN | FILE_FLAG_DELETE_ON_CLOSE
            ; 0x10000000              | 0x20000000             | 0x80000000              | 0x2                   | 0x04000000
            $hFile = _FileEx_CreateFile($sTemp, $GENERIC_WRITE, 0, $CREATE_NEW, 0xB4000002)
            If @error Then Return SetError(8, 0, 0)
            ;
            ; max number of clusters to overwrite at a time
            ; optimally a multiple of 16
            ;
            ; set temp file size to 2M if file is bigger than 2M, otherwise 64K (16 clusters)
            ; use multiple of 16 clusters
            If $aMAP[0][3] > $__g_iMaxWriteSize Then
                $iWriteSize = Floor($__g_iMaxWriteSize / ($aMAP[0][2] * 16)) * ($aMAP[0][2] * 16)
            Else
                $iWriteSize = Floor(1024 * 64 / ($aMAP[0][2] * 16)) * ($aMAP[0][2] * 16)
            EndIf
            If $iWriteSize = 0 Then $iWriteSize = $aMAP[0][2] * 16
            ; get cluster count
            $iClusters = $iWriteSize / $aMAP[0][2]
            ; set the temp file size
            DllCall("kernel32.dll", "bool", "SetFilePointerEx", "handle", $hFile, "int64", $iWriteSize, "ptr", 0, "dword", 0)
            _WinAPI_SetEndOfFile($hFile)
            ;
            ; FILE_DEVICE_FILE_SYSTEM, 29, METHOD_BUFFERED, FILE_SPECIAL_ACCESS
            Local Const $FSCTL_MOVE_FILE = _FM_CTL_CODE(0x00000009, 29, 0, 0)
            ; create MOVE_FILE_DATA structure and set temp file handle
            Local $tagMOVE_FILE_DATA = "handle FileHandle;int64 StartingVcn;int64 StartingLcn;dword ClusterCount"
            Local $MFD = DllStructCreate($tagMOVE_FILE_DATA)
            DllStructSetData($MFD, "FileHandle", $hFile)
            DllStructSetData($MFD, "StartingVcn", 0)
            ;
            ; get handle to volume containing destination file
            ; make sure $sDrive is a drive letter and not a network share, etc
            ; we can only open local volumes
            If Not StringRegExp(StringLeft($sDrive, 1), "(?i)[a-z]") Then
                _WinAPI_CloseHandle($hFile)
                Return SetError(9, 0, 0)
            EndIf
            Local $hVolume = _FileEx_CreateFile("\\.\" & StringLeft($sDrive, 1) & ":", $GENERIC_READ, BitOR($FILE_SHARE_READ, $FILE_SHARE_WRITE), $OPEN_EXISTING, 0)
            If @error Then
                _WinAPI_CloseHandle($hFile)
                Return SetError(9, 0, 0)
            EndIf
            ;
            ; remove attributes, set NORMAL
            _FileEx_SetAttributes($sFile, 0x80)
            ; delete the file, remove flag
            $fDelete = False
            _SD_DeleteFile($sFile)
            If @error Then
                _WinAPI_CloseHandle($hVolume)
                _WinAPI_CloseHandle($hFile)
                Return SetError(9, 0, 0)
            EndIf
            ;
            Local $aRet, $iLCN, $iClustersToWrite, $iClustersWritten = 0, $iTotalClustersWritten = 0
            ; get # of on-disk clusters for callback
            Local $iFileClusterCount = 0
            If $sCallback Then
                For $i = 1 To $aMAP[0][0]
                    If $aMAP[$i][1] = -1 Then ContinueLoop
                    $iFileClusterCount += $aMAP[$i][2]
                Next
            EndIf
            ;
            ; walk the output array, processing each extent
            For $i = 1 To $aMAP[0][0]
                ; skip LCN's of -1
                If $aMAP[$i][1] = -1 Then ContinueLoop
                ; set first LCN of this extent
                $iLCN = $aMAP[$i][1]
                ; set initial overwrite size and cycles
                $iClustersToWrite = $iClusters
                DllStructSetData($MFD, "ClusterCount", $iClusters)
                ;
                $iClustersWritten = 0
                While $iClustersWritten < $aMAP[$i][2]
                    If $iClustersToWrite > ($aMAP[$i][2] - $iClustersWritten) Then
                        $iClustersToWrite = $aMAP[$i][2] - $iClustersWritten
                        DllStructSetData($MFD, "ClusterCount", $iClustersToWrite)
                    EndIf
                    ; set target LCN to struct
                    DllStructSetData($MFD, "StartingLcn", $iLCN)
                    ; move our temp file to target cluster
                    $aRet = DllCall("kernel32.dll", "bool", "DeviceIoControl", "handle", $hVolume, "dword", $FSCTL_MOVE_FILE, _
                            "ptr", DllStructGetPtr($MFD), "dword", DllStructGetSize($MFD), "ptr", 0, "dword", 0, "dword*", 0, "ptr", 0)
                    If Not $aRet[0] Then
                        ; failure, some of the clusters may have been moved, so overwrite anyway, return error at end
                        $iErr += 1
                    EndIf
                    ; reset file pointer to beginning of the file
                    DllCall("kernel32.dll", "bool", "SetFilePointerEx", "handle", $hFile, "int64", 0, "ptr", 0, "dword", 0)
                    _SD_SecureOverwrite($hFile, $iClustersToWrite * $aMAP[0][2], $iClustersToWrite * $aMAP[0][2], $aPatterns)
                    ; next clusters in extent
                    $iLCN += $iClustersToWrite
                    $iClustersWritten += $iClustersToWrite
                    If $sCallback Then
                        ; send data written as percentage of data size based on # of clusters written
                        $iTotalClustersWritten += $iClustersToWrite
                        Call($sCallback, Ceiling($iTotalClustersWritten * $aMAP[0][3] / $iFileClusterCount), $aMAP[0][3])
                    EndIf
                WEnd
            Next
            ; cleanup
            _WinAPI_CloseHandle($hVolume)
            _WinAPI_CloseHandle($hFile)
    EndSwitch
    ;
    ; post processing
    ;
    If $fDelete Then
        _SD_DeleteFile($sFile)
        If @error Then Return SetError(9, 0, 0)
    EndIf
    ; $iErr is only > 0 if using Special method
    ; this implies $fDelete was set to False, but the file was deleted as part of the process
    ; it is recommended to run a freespace wipe if this error is encountered
    If $iErr Then
        Return SetError(10, $iErr, 0)
    Else
        Return 1
    EndIf
EndFunc   ;==>_SecureFileDelete

; #FUNCTION# ====================================================================================================================
; Name ..........: _SecureFreespaceErase
; Description ...: Securely erase the free space on a drive.
; Syntax ........: _SecureFreespaceErase($sDrive[, $aPatterns = -1[, $sCallback = ""]])
; Parameters ....: $sDrive              - Drive letter to erase.
;                  $aPatterns           - [optional] User array of integers 0 to 255 (decimal or hex) to use as patterns
;                                         $aPatterns[] = [0xAA,0x4F,135,etc...]
;                                         If $aPatterns = -1, then the default DoD_E method is used
;                                         If $aPatterns is an integer 0 <= i <= 255 then i will be used for a single pass.
;                                         If $aPatters[n] is -1, then the buffer will be filled with pseudo-random data each
;                                         time it is used. This will incur a performance penalty.
;                  $sCallback           - [optional] Callback function that receives bytes written and total free bytes
;                                         Under certain (unknown?) circumstances, total bytes written may not equal total
;                                         free bytes on the last call.
; Return values .: Success              - Returns 1
;                  Failure              - 0 and sets @error
;                                       | 1 - $sDrive does not exist
;                                       | 2 - Error with user array
;                                       | 3 - Error getting temp file names
;                                       | 4 - Error allocating buffer
;                                       | 5 - Error creating temp files
; Author ........: Erik Pilsits
; Modified ......:
; Remarks .......: This function does not clean deleted file / dir names or cluster tips, ie slack space. It uses the same
;                  method as the Sysinternals tool SDelete.
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _SecureFreespaceErase($sDrive, $aPatterns = -1, $sCallback = "")
    ; format drive path and check it
    $sDrive = StringLeft($sDrive, 1) & ":\"
    If Not FileExists($sDrive) Then Return SetError(1, 0, 0)
    ;
    ; check patterns, create buffers
    ;
    _SD_CheckPatterns($aPatterns)
    Switch @error
        Case 1
            Return SetError(2, 0, 0)
        Case 2
            Return SetError(4, 0, 0)
    EndSwitch
    ;
    ; get cluster size
    Local $iClusterSize = _FileEx_GetDiskClusterSize($sDrive)
    ;
    ; allocate largest unbuffered file
    ; use multiple of cluster size
    ;
    Local $hTemp, $iWriteSize, $sTemp
    Local $freeSpaceTotal = DriveSpaceFree($sDrive) * (1024 ^ 2)
    Local $iWritten = 0
    ;
    ; on FAT32 this file can only grow to 4GB, so repeat until we've filled the drive
    Do
        $iWriteSize = Floor($__g_iMaxWriteSize / $iClusterSize) * $iClusterSize
        If $iWriteSize = 0 Then $iWriteSize = $iClusterSize
        $sTemp = _FileEx_GetTempFile($sDrive)
        If @error Then
            Return SetError(3, 0, 0)
        Else
            ; FILE_FLAG_RANDOM_ACCESS | FILE_FLAG_NO_BUFFERING | FILE_FLAG_WRITE_THROUGH | FILE_ATTRIBUTE_HIDDEN | FILE_FLAG_DELETE_ON_CLOSE
            ; 0x10000000              | 0x20000000             | 0x80000000              | 0x2                   | 0x04000000
            $hTemp = _FileEx_CreateFile($sTemp, $GENERIC_WRITE, 0, $CREATE_NEW, 0xB4000002)
            If @error Then
                Return SetError(5, 0, 0)
            Else
                While $iWriteSize > $iClusterSize
                    _SD_SecureOverwrite($hTemp, $iWriteSize, $iWriteSize, $aPatterns)
                    If @error Then
                        $iWriteSize -= $iClusterSize
                    ElseIf $sCallback Then
                        $iWritten += $iWriteSize
                        Call($sCallback, $iWritten, $freeSpaceTotal)
                    EndIf
                WEnd
            EndIf
        EndIf
    Until (Floor(DriveSpaceFree($sDrive) * (1024 ^ 2)) < $iClusterSize)
    ;
    ; allocate largest buffered file
    ;
    $iWriteSize = $iClusterSize
    $sTemp = _FileEx_GetTempFile($sDrive)
    If @error Then
        Return SetError(3, 0, 0)
    Else
        ; FILE_FLAG_RANDOM_ACCESS | FILE_FLAG_WRITE_THROUGH | FILE_ATTRIBUTE_HIDDEN | FILE_FLAG_DELETE_ON_CLOSE
        ; 0x10000000              | 0x80000000              | 0x2                   | 0x04000000
        $hTemp = _FileEx_CreateFile($sTemp, $GENERIC_WRITE, 0, $CREATE_NEW, 0x94000002)
        If @error Then
            Return SetError(5, 0, 0)
        Else
            While $iWriteSize
                _SD_SecureOverwrite($hTemp, $iWriteSize, $iWriteSize, $aPatterns)
                If @error Then $iWriteSize -= 1
            WEnd
        EndIf
    EndIf
    ;
    ; MFT (NTFS only)
    ;
    ; max MFT record size
    Local $iTempSize = 4096
    Local $fCreatedFile = False
    While 1
        $sTemp = _FileEx_GetTempFile($sDrive)
        If @error Then
            Return SetError(3, 0, 0)
        EndIf
        ; FILE_FLAG_RANDOM_ACCESS  | FILE_FLAG_WRITE_THROUGH | FILE_ATTRIBUTE_HIDDEN | FILE_FLAG_DELETE_ON_CLOSE
        ; 0x10000000               | 0x80000000              | 0x2                   | 0x04000000
        $hTemp = _FileEx_CreateFile($sTemp, $GENERIC_WRITE, 0, $CREATE_NEW, 0x94000002)
        ; MFT is full, done on NTFS
        If @error Then ExitLoop
        $iWriteSize = $iTempSize
        $fCreatedFile = False
        While $iWriteSize
            _SD_SecureOverwrite($hTemp, $iWriteSize, $iWriteSize, $aPatterns)
            If @error Then
                $iWriteSize -= 1
            Else
                $fCreatedFile = True
                ; set next max file size to last successful write size
                $iTempSize = $iWriteSize
            EndIf
        WEnd
        ; if the only file created is 0 length, this is FAT/FAT32
        If Not $fCreatedFile Then ExitLoop
    WEnd
    ;
    Return 1
EndFunc   ;==>_SecureFreespaceErase
#endregion FUNCTIONS

#region INTERNAL FUNCTIONS
Func _SD_AddError(ByRef $aErr, $iErr, $sErr, $iType)
    ; type: 1 - file, 2 - folder
    $aErr[0][0] += 1
    ReDim $aErr[$aErr[0][0] + 1][3]
    $aErr[$aErr[0][0]][0] = $iErr
    $aErr[$aErr[0][0]][1] = $sErr
    $aErr[$aErr[0][0]][2] = $iType
EndFunc   ;==>_SD_AddError

Func _SD_AddToArray2DLarge(ByRef $arr, $val1, $val2)
    $arr[0][0] += 1
    If $arr[0][0] >= UBound($arr) Then ReDim $arr[UBound($arr) * 2][2]
    $arr[$arr[0][0]][0] = $val1
    $arr[$arr[0][0]][1] = $val2
EndFunc   ;==>_SD_AddToArray2DLarge

Func _SD_CheckPatterns(Const ByRef $aPatterns)
    Static Local $aPrevPatterns = Default
    ;
    ; quick check array dimensions, must be 1D
    If IsArray($aPatterns) And UBound($aPatterns, 0) > 1 Then Return SetError(1)
    ;
    ; only check equality if $__g_apBuffers is an array, meaning we already created some buffers
    If IsArray($__g_apBuffers) Then
        ; check if new patterns match old
        If IsArray($aPatterns) And IsArray($aPrevPatterns) Then
            ; check array equality
            If UBound($aPatterns) = UBound($aPrevPatterns) Then
                For $i = 0 To UBound($aPatterns) - 1
                    If $aPatterns[$i] <> $aPrevPatterns[$i] Then ExitLoop
                Next
                ; if successfully checked all bounds, then arrays are equal
                If $i = UBound($aPatterns) Then Return
            EndIf
            ; else different
        ElseIf (Not IsArray($aPatterns)) And (Not IsArray($aPrevPatterns)) Then
            ; check non-array equality
            If $aPatterns = $aPrevPatterns Then Return
        EndIf
        ; else different
    EndIf
    ;
    Local $aBuff
    If IsArray($aPatterns) Then
        ; check user array values
        For $i = 0 To UBound($aPatterns) - 1
            If ($aPatterns[$i] < -1) Or ($aPatterns[$i] > 255) Then Return SetError(1)
        Next
        $aBuff = $aPatterns
    ElseIf IsNumber($aPatterns) Then
        If $aPatterns = -1 Then
            ; default patterns
            Dim $aBuff[3]
            ; DoD 3-pass method:
            ; 1st pass = random character decimal 0 to 255
            ; 2nd pass = complement of first pass
            ; 3rd pass = random character
            $aBuff[0] = Random(0, 255, 1) ; random decimal value
            $aBuff[1] = BitAND(BitNOT($aBuff[0]), 0xFF) ; get previous value's complement
            $aBuff[2] = Random(0, 255, 1)
        ElseIf ($aPatterns < 0) Or ($aPatterns > 255) Then
            Return SetError(1)
        Else
            ; single byte
            Dim $aBuff[1] = [$aPatterns]
        EndIf
    Else
        Return SetError(1)
    EndIf
    ;
    ; save new patterns
    $aPrevPatterns = $aPatterns
    ; create buffers
    _SD_CreateBuffers($aBuff)
    If @error Then Return SetError(2)
EndFunc   ;==>_SD_CheckPatterns

Func _SD_CreateBuffers(Const ByRef $aBuff)
    Local $pBuff
    _SD_FreeBuffers()
    ; create crypt context
    $__g_hCryptContext[1] = DllOpen("advapi32.dll")
    Local $context = DllCall($__g_hCryptContext[1], "bool", "CryptAcquireContext", "handle*", 0, "ptr", 0, "ptr", 0, "dword", 24, "dword", 0xF0000000)
    If @error Or (Not $context[0]) Then
        DllClose($__g_hCryptContext[1])
        $__g_hCryptContext[1] = 0
        Return SetError(1)
    EndIf
    $__g_hCryptContext[0] = $context[1]
    Dim $__g_apBuffers[1] = [0]
    For $i = 0 To UBound($aBuff) - 1
        $pBuff = _MemVirtualAlloc(0, $__g_iMaxWriteSize, $MEM_COMMIT, $PAGE_READWRITE)
        If Not $pBuff Then
            _SD_FreeBuffers()
            Return SetError(1)
        EndIf
        ; -1 is special value to indicate stream of random data
        If $aBuff[$i] > -1 Then
            ; fill buffer with pattern
            DllCall("ntdll.dll", "none", "RtlFillMemory", "ptr", $pBuff, "ulong_ptr", $__g_iMaxWriteSize, "byte", $aBuff[$i])
        EndIf
        $__g_apBuffers[0] += 1
        ReDim $__g_apBuffers[$__g_apBuffers[0] + 1]
        $__g_apBuffers[$__g_apBuffers[0]] = $pBuff
    Next
EndFunc   ;==>_SD_CreateBuffers

Func _SD_DeleteDir($sDir)
    Local $sOrig = $sDir
    ; rename the dir 10 times
    Local $newdir
    Local $spDir = StringRegExpReplace($sDir, "^(.*)\\.*?$", "${1}")
    For $i = 1 To 10
        $newdir = _FileEx_GetTempFile($spDir, "~", "")
        If Not _FileEx_MoveFile($sDir, $newdir) Then ExitLoop
        $sDir = $newdir
    Next
    ; set dir time
    For $i = 0 To 2
        ; reset all dir timestamps to Jan. 1, 1980, 12:00:01am
        FileSetTime($sDir, "19800101010001", $i)
    Next
    ; delete
    If Not _FileEx_RemoveDirectory($sDir) Then
        ; rename back to original dir name
        _FileEx_MoveFile($sDir, $sOrig)
        Return SetError(1)
    EndIf
EndFunc   ;==>_SD_DeleteDir

Func _SD_DeleteFile($sFile)
    Local $sOrig = $sFile
    ; set length to 0
    _WinAPI_CloseHandle(_FileEx_CreateFile($sFile, $GENERIC_WRITE, $FILE_SHARE_READ, $TRUNCATE_EXISTING, 0))
    ; rename the file 10 times
    Local $newfile
    Local $sDir = StringRegExpReplace($sFile, "^(.*)\\.*?$", "${1}")
    For $i = 1 To 10
        $newfile = _FileEx_GetTempFile($sDir)
        If Not _FileEx_MoveFile($sFile, $newfile) Then ExitLoop
        $sFile = $newfile
    Next
    ; set file time
    For $i = 0 To 2
        ; reset all file timestamps to Jan. 1, 1980, 12:00:01am
        FileSetTime($sFile, "19800101010001", $i)
    Next
    ; delete
    If Not _FileEx_DeleteFile($sFile) Then
        _FileEx_MoveFile($sFile, $sOrig)
        Return SetError(1)
    EndIf
EndFunc   ;==>_SD_DeleteFile

Func _SD_FillBufferRandom($pBuff, $iSize)
    ; fill buffer with random data
    Local $ret = DllCall($__g_hCryptContext[1], "bool", "CryptGenRandom", "handle", $__g_hCryptContext[0], "dword", $iSize, "ptr", $pBuff)
    If @error Or (Not $ret[0]) Then
        Return SetError(1)
    Else
        Return 1
    EndIf
EndFunc   ;==>_SD_FillBufferRandom

Func _SD_FreeBuffers()
    If IsArray($__g_apBuffers) Then
        For $i = 1 To $__g_apBuffers[0]
            _MemVirtualFree($__g_apBuffers[$i], 0, $MEM_RELEASE)
        Next
    EndIf
    $__g_apBuffers = 0
    ; release crypt context
    If $__g_hCryptContext[0] Then DllCall($__g_hCryptContext[1], "bool", "CryptReleaseContext", "handle", $__g_hCryptContext[0], "dword", 0)
    If $__g_hCryptContext[1] Then DllClose($__g_hCryptContext[1])
    $__g_hCryptContext[0] = 0
    $__g_hCryptContext[1] = 0
EndFunc   ;==>_SD_FreeBuffers

Func _SD_IsDirectory($iAttr)
    Return (BitAND($iAttr, 0x10) = 0x10)
EndFunc   ;==>_SD_IsDirectory

Func _SD_IsReparsePoint($iAttr)
    Return (BitAND($iAttr, 0x400) = 0x400)
EndFunc   ;==>_SD_IsReparsePoint

Func _SD_IsSpecialFile($iAttr)
    ; test if file is sparse, compressed, or encrypted
    Return ((BitAND($iAttr, 0x200) = 0x200) Or (BitAND($iAttr, 0x800) = 0x800) Or (BitAND($iAttr, 0x4000) = 0x4000))
EndFunc   ;==>_SD_IsSpecialFile

Func _SD_PathIsDir($iAttr)
    Return (BitAND($iAttr, 0x10) = 0x10)
EndFunc   ;==>_SD_PathIsDir

Func _SD_SecureOverwrite($hFile, $iSize, $iBuffSize, Const ByRef $aPatterns, $sCallback = "")
    If $iBuffSize > $__g_iMaxWriteSize Then $iBuffSize = $__g_iMaxWriteSize
    ; get number of write operations
    Local $iBytes, $bytesWritten, $bytesToWrite = $iBuffSize
    ; overwrite file
    $bytesWritten = 0
    While $bytesWritten < $iSize
        If $bytesToWrite > ($iSize - $bytesWritten) Then $bytesToWrite = $iSize - $bytesWritten
        ; overwrite each bytesToWrite size section with each pattern
        For $i = 1 To $__g_apBuffers[0] ; # of overwrites
            If $i > 1 Then
                ; reset file pointer to beginning of the overwrite segment on successive passes
                DllCall("kernel32.dll", "bool", "SetFilePointerEx", "handle", $hFile, "int64", -$bytesToWrite, "ptr", 0, "dword", 1)
            EndIf
            ; check for pseudo-random pass and fill buffer, special pattern of -1
            ; NOTE: $aPatterns is a 0-based array, while $__g_apBuffers is 1-based with a [0] counter
            If IsArray($aPatterns) And ($aPatterns[$i - 1] = -1) Then _SD_FillBufferRandom($__g_apBuffers[$i], $bytesToWrite)
            ; write the data
            If (Not _WinAPI_WriteFile($hFile, $__g_apBuffers[$i], $bytesToWrite, $iBytes)) Or ($bytesToWrite <> $iBytes) Then
                Return SetError(1)
            EndIf
        Next
        ; next file section
        $bytesWritten += $bytesToWrite
        If $sCallback Then Call($sCallback, $bytesWritten, $iSize)
    WEnd
EndFunc   ;==>_SD_SecureOverwrite
#endregion INTERNAL FUNCTIONS
