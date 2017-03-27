#Region Header

#cs

    Title:          Management of Copying Files and Folders UDF Library for AutoIt3
    Filename:       Copy.au3
    Description:    Copies a files and folders without pausing a script
    Author:         Yashied
    Version:        1.3
    Requirements:   AutoIt v3.3 +, Developed/Tested on WindowsXP Pro Service Pack 2
    Uses:           None
    Notes:          This library requires Copy.dll (v1.3.x.x)

    Available functions:

	_Copy_Abort
	_Copy_CloseDll
	_Copy_CopyDir
	_Copy_CopyFile
	_Copy_GetState
	_Copy_MoveDir
	_Copy_MoveFile
	_Copy_OpenDll
	_Copy_Pause

    Error codes:

    0 - No error
    1 - DLL not loaded
    2 - ID is incorrect or out of range
    3 - Thread is not yet initialized
    4 - Thread is now being used
    5 - DllCall() error
    6 - DLL already loaded
    7 - Incompatible DLL version
    8 - DLL not found

    Example1:

    #Include <EditConstants.au3>
    #Include <GUIConstantsEx.au3>

    #Include "Copy.au3"

    Opt('MustDeclareVars', 1)
    Opt('TrayAutoPause', 0)

    Global $hForm, $Input1, $Input2, $Button1, $Button2, $Button3, $Button4, $Data, $Msg, $Path, $Progress, $State, $Copy = False, $Pause = False
    Global $Source = '', $Destination = ''

    If Not _Copy_OpenDll() Then
        MsgBox(16, '', 'DLL not found.')
        Exit
    EndIf

    $hForm = GUICreate('MyGUI', 360, 163)
    GUICtrlCreateLabel('Source:', 14, 23, 58, 14)
    $Input1 = GUICtrlCreateInput('', 74, 20, 248, 19, BitOR($ES_AUTOHSCROLL, $ES_LEFT, $ES_MULTILINE))
    GUICtrlSetState(-1, $GUI_DISABLE)
    $Button1 = GUICtrlCreateButton('...', 326, 19, 21, 21)
    GUICtrlCreateLabel('Destination:', 14, 55, 58, 14)
    $Input2 = GUICtrlCreateInput('', 74, 52, 248, 19, BitOR($ES_AUTOHSCROLL, $ES_LEFT, $ES_MULTILINE))
    GUICtrlSetState(-1, $GUI_DISABLE)
    $Button2 = GUICtrlCreateButton('...', 326, 51, 21, 21)
    $Progress = GUICtrlCreateProgress(14, 94, 332, 16)
    $Button3 = GUICtrlCreateButton('Copy', 135, 126, 80, 21)
    $Button4 = GUICtrlCreateButton(';', 326, 126, 21, 21)
    GUICtrlSetFont(-1, 10, 400, 0, 'Webdings')
    GUICtrlSetState(-1, $GUI_DISABLE)
    GUISetState()

    While 1
        If $Copy Then
            $State = _Copy_GetState()
            If $State[0] Then
                $Data = Round($State[1] / $State[2] * 100)
                If GUICtrlRead($Progress) <> $Data Then
                    GUICtrlSetData($Progress, $Data)
                EndIf
            Else
                Switch $State[5]
                    Case 0
                        GUICtrlSetData($Progress, 100)
                        MsgBox(64, '', 'File was successfully copied.', 0, $hForm)
                    Case 1235 ; ERROR_REQUEST_ABORTED
                        MsgBox(16, '', 'File copying was aborted.', 0, $hForm)
                    Case Else
                        MsgBox(16, '', 'File was not copied.' & @CR & @CR & $State[5], 0, $hForm)
                EndSwitch
                GUICtrlSetData($Progress, 0)
                GUICtrlSetState($Button1, $GUI_ENABLE)
                GUICtrlSetState($Button2, $GUI_ENABLE)
                GUICtrlSetState($Button4, $GUI_DISABLE)
                GUICtrlSetData($Button3, 'Copy')
                GUICtrlSetData($Button4, ';')
                $Copy = 0
            EndIf
        EndIf
        $Msg = GUIGetMsg()
        Switch $Msg
            Case $GUI_EVENT_CLOSE
                ExitLoop
            Case $Button1
                $Path = FileOpenDialog('Select Source File', StringRegExpReplace($Source, '\\[^\\]*\Z', ''), 'All Files (*.*)', 3, StringRegExpReplace($Source, '^.*\\', ''), $hForm)
                If $Path Then
                    GUICtrlSetData($Input1, $Path)
                    $Source = $Path
                EndIf
            Case $Button2
                $Path = FileOpenDialog('Select Destination File', StringRegExpReplace($Destination, '\\[^\\]*\Z', ''), 'All Files (*.*)', 2, StringRegExpReplace($Source, '^.*\\', ''), $hForm)
                If $Path Then
                    GUICtrlSetData($Input2, $Path)
                    $Destination = $Path
                EndIf
            Case $Button3
                If $Copy Then
                    _Copy_Abort()
                Else
                    If (Not $Source) Or (Not $Destination) Then
                        MsgBox(16, '', 'The source and destination file names must be specified.', 0, $hForm)
                        ContinueLoop
                    EndIf
                    If FileExists($Destination) Then
                        If MsgBox(52, '', $Destination & ' already exists.' & @CR & @CR & 'Do you want to replace it?', 0, $hForm) <> 6 Then
                            ContinueLoop
                        EndIf
                    EndIf
                    GUICtrlSetState($Button1, $GUI_DISABLE)
                    GUICtrlSetState($Button2, $GUI_DISABLE)
                    GUICtrlSetState($Button4, $GUI_ENABLE)
                    GUICtrlSetData($Button3, 'Abort')
                    _Copy_CopyFile($Source, $Destination)
                    $Copy = 1
                EndIf
            Case $Button4
                $Pause = Not $Pause
                If $Pause Then
                    GUICtrlSetData($Button4, '4')
                Else
                    GUICtrlSetData($Button4, ';')
                EndIf
                _Copy_Pause($Pause)
        EndSwitch
    WEnd

    Example2:

    #Include <EditConstants.au3>
    #Include <GUIConstantsEx.au3>

    #Include "Copy.au3"

    Opt('MustDeclareVars', 1)
    Opt('TrayAutoPause', 0)

    Global $hForm, $Input1, $Input2, $Button1, $Button2, $Button3, $Button4, $Label, $Data, $Msg, $Path, $Progress, $State, $Copy = False, $Pause = False
    Global $Source = '', $Destination = ''

    If Not _Copy_OpenDll() Then
        MsgBox(16, '', 'DLL not found.')
        Exit
    EndIf

    $hForm = GUICreate('MyGUI', 360, 175)
    GUICtrlCreateLabel('Source:', 14, 23, 58, 14)
    $Input1 = GUICtrlCreateInput('', 74, 20, 248, 19, BitOR($ES_AUTOHSCROLL, $ES_LEFT, $ES_MULTILINE))
    GUICtrlSetState(-1, $GUI_DISABLE)
    $Button1 = GUICtrlCreateButton('...', 326, 19, 21, 21)
    GUICtrlCreateLabel('Destination:', 14, 55, 58, 14)
    $Input2 = GUICtrlCreateInput('', 74, 52, 248, 19, BitOR($ES_AUTOHSCROLL, $ES_LEFT, $ES_MULTILINE))
    GUICtrlSetState(-1, $GUI_DISABLE)
    $Button2 = GUICtrlCreateButton('...', 326, 51, 21, 21)
    $Label = GUICtrlCreateLabel('',14, 91, 332, 14)
    $Progress = GUICtrlCreateProgress(14, 106, 332, 16)
    $Button3 = GUICtrlCreateButton('Copy', 135, 138, 80, 21)
    $Button4 = GUICtrlCreateButton(';', 326, 138, 21, 21)
    GUICtrlSetFont(-1, 10, 400, 0, 'Webdings')
    GUICtrlSetState(-1, $GUI_DISABLE)
    GUISetState()

    While 1
        If $Copy Then
            $State = _Copy_GetState()
            If $State[0] Then
                If $State[0] = -1 Then
                    ; Preparing
                Else
                    $Data = Round($State[1] / $State[2] * 100)
                    If GUICtrlRead($Progress) <> $Data Then
                        GUICtrlSetData($Progress, $Data)
                    EndIf
                    $Data = StringRegExpReplace($State[6], '^.*\\', '')
                    If GUICtrlRead($Label) <> $Data Then
                        GUICtrlSetData($Label, $Data)
                    EndIf
                EndIf
            Else
                Switch $State[5]
                    Case 0
                        GUICtrlSetData($Progress, 100)
                        MsgBox(64, '', 'Folder was successfully copied.', 0, $hForm)
                    Case 1235 ; ERROR_REQUEST_ABORTED
                        MsgBox(16, '', 'Folder copying was aborted.', 0, $hForm)
                    Case Else
                        MsgBox(16, '', 'Folder was not copied.' & @CR & @CR & $State[5], 0, $hForm)
                EndSwitch
                GUICtrlSetState($Button1, $GUI_ENABLE)
                GUICtrlSetState($Button2, $GUI_ENABLE)
                GUICtrlSetState($Button4, $GUI_DISABLE)
                GUICtrlSetData($Progress, 0)
                GUICtrlSetData($Label, '')
                GUICtrlSetData($Button3, 'Copy')
                GUICtrlSetData($Button4, ';')
                $Copy = 0
            EndIf
        EndIf
        $Msg = GUIGetMsg()
        Switch $Msg
            Case $GUI_EVENT_CLOSE
                ExitLoop
            Case $Button1
                $Path = FileSelectFolder('Select source folder that to be copied.', '', 2, $Source, $hForm)
                If $Path Then
                    GUICtrlSetData($Input1, $Path)
                    $Source = $Path
                EndIf
            Case $Button2
                $Path = FileSelectFolder('Select destination folder in which will be copied the source directory.', '', 2, $Destination, $hForm)
                If $Path Then
                    GUICtrlSetData($Input2, $Path)
                    $Destination = $Path
                EndIf
            Case $Button3
                If $Copy Then
                    _Copy_Abort()
                Else
                    If (Not $Source) Or (Not $Destination) Then
                        MsgBox(16, '', 'The source and destination folders must be specified.', 0, $hForm)
                        ContinueLoop
                    EndIf
                    $Path = $Destination & '\' & StringRegExpReplace($Source, '^.*\\', '')
                    If FileExists($Path) Then
                        If MsgBox(52, '', $Path & ' already exists.' & @CR & @CR & 'Do you want to replace it?', 0, $hForm) <> 6 Then
                            ContinueLoop
                        EndIf
                    EndIf
                    GUICtrlSetState($Button1, $GUI_DISABLE)
                    GUICtrlSetState($Button2, $GUI_DISABLE)
                    GUICtrlSetState($Button4, $GUI_ENABLE)
                    GUICtrlSetData($Label, 'Preparing...')
                    GUICtrlSetData($Button3, 'Abort')
                    _Copy_CopyDir($Source, $Path)
                    $Copy = 1
                EndIf
            Case $Button4
                $Pause = Not $Pause
                If $Pause Then
                    GUICtrlSetData($Button4, '4')
                Else
                    GUICtrlSetData($Button4, ';')
                EndIf
                _Copy_Pause($Pause)
        EndSwitch
    WEnd

#ce

#Include-once

#EndRegion Header

#Region Global Variables and Constants

#cs

Global Const $COPY_FILE_ALLOW_DECRYPTED_DESTINATION = 0x0008
Global Const $COPY_FILE_COPY_SYMLINK = 0x0800
Global Const $COPY_FILE_FAIL_IF_EXISTS = 0x0001
Global Const $COPY_FILE_NO_BUFFERING = 0x1000
Global Const $COPY_FILE_OPEN_SOURCE_FOR_WRITE = 0x0004
Global Const $COPY_FILE_RESTARTABLE = 0x0002

Global Const $MOVE_FILE_COPY_ALLOWED = 0x0002
Global Const $MOVE_FILE_CREATE_HARDLINK = 0x0010
Global Const $MOVE_FILE_DELAY_UNTIL_REBOOT = 0x0004
Global Const $MOVE_FILE_FAIL_IF_NOT_TRACKABLE = 0x0020
Global Const $MOVE_FILE_REPLACE_EXISTING = 0x0001
Global Const $MOVE_FILE_WRITE_THROUGH = 0x0008

#ce

#EndRegion Global Variables and Constants

#Region Local Variables and Constants

Global $__Slot[256]
Global $__DLL = -1
Global $__CALLBACKSTATUS = _
		'UINT64 TotalBytesTransferred;' & _
		'UINT64 TotalSize;' & _
		'UINT64 FileBytesTransferred;' & _
		'UINT64 FileSize;' & _
		'INT    Synchronize;' & _
		'INT    Pause;' & _
		'INT    Abort;' & _
		'INT    SystemErrorCode;' & _
		'INT    Progress;' & _
		'INT    Reserved;' & _
		'WCHAR  Source[512];' & _
		'WCHAR  Destination[512];'

#EndRegion Local Variables and Constants

#Region Initialization

OnAutoItExitRegister('__CP_AutoItExit')

#EndRegion Initialization

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Name...........: _Copy_Abort
; Description....: Aborts a process of copying or moving files.
; Syntax.........: _Copy_Abort ( [$iID] )
; Parameters.....: $iID    - The slot identifier that has been specified in the _Copy_Copy... or _Copy_Move... funtions. If this
;                            parameter is (-1), all running processes will be aborted.
; Return values..: Success - 1.
;                  Failure - 0 and sets the @error flag to non-zero (see above).
; Author.........: Yashied
; Modified.......:
; Remarks........: If the copying or moving files was completed, the function has no effect.
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _Copy_Abort($iID = 0)
	If $__DLL = -1 Then
		Return SetError(1, 0, 0)
	EndIf
	If (Not IsNumber($iID)) Or ($iID < -1) Or ($iID > UBound($__Slot) - 1) Then
		Return SetError(2, 0, 0)
	EndIf
	If $iID = -1 Then
		For $i = 0 To UBound($__Slot) - 1
			If (IsDllStruct($__Slot[$i])) And (DllStructGetData($__Slot[$i], 'Progress')) Then
				DllStructSetData($__Slot[$i], 'Abort', 1)
				DllStructSetData($__Slot[$i], 'Pause', 0)
				While DllStructGetData($__Slot[$i], 'Progress')
					Sleep(10)
				WEnd
			EndIf
		Next
	Else
		If Not IsDllStruct($__Slot[$iID]) Then
			Return SetError(3, 0, 0)
		EndIf
		If DllStructGetData($__Slot[$iID], 'Progress') Then
			DllStructSetData($__Slot[$iID], 'Abort', 1)
			DllStructSetData($__Slot[$iID], 'Pause', 0)
			While DllStructGetData($__Slot[$iID], 'Progress')
				Sleep(10)
			WEnd
		EndIf
	EndIf
	Return 1
EndFunc   ;==>_Copy_Abort

; #FUNCTION# ====================================================================================================================
; Name...........: _Copy_CloseDll
; Description....: Closes a Copy.dll if it's no longer required.
; Syntax.........: _Copy_CloseDll ( )
; Parameters.....: None
; Return values..: Success - 1.
;                  Failure - 0 and sets the @error flag to non-zero (see above).
; Author.........: Yashied
; Modified.......:
; Remarks........: Note, if any process of copying or moving files is not completed, the function fails. Use _Copy_Abort() before
;                  calling this function.
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _Copy_CloseDll()
	If $__DLL = -1 Then
		Return SetError(1, 0, 0)
	EndIf
	For $i = 0 To UBound($__Slot) - 1
		If (IsDllStruct($__Slot[$i])) And (DllStructGetData($__Slot[$i], 'Progress')) Then
			Return SetError(4, 0, 0)
		EndIf
	Next
	DllClose($__DLL)
	$__DLL = -1
	Return 1
EndFunc   ;==>_Copy_CloseDll

; #FUNCTION# ====================================================================================================================
; Name...........: _Copy_CopyDir
; Description....: Copies a directory and all sub-directories and files to another directory.
; Syntax.........: _Copy_CopyDir ( $sSource, $sDestination [, $iFlags [, $iID]] )
; Parameters.....: $sSource      - The path to the source directory that to be copied.
;                  $sDestination - The path to the destination directory.
;                  $iFlags       - Flags that specify how the file is to be copied. It can be one or more of the following values.
;
;                                  $COPY_FILE_ALLOW_DECRYPTED_DESTINATION
;                                  $COPY_FILE_COPY_SYMLINK
;                                  $COPY_FILE_FAIL_IF_EXISTS
;                                  $COPY_FILE_NO_BUFFERING
;                                  $COPY_FILE_OPEN_SOURCE_FOR_WRITE
;
;                  $iID          - The slot identifier (ID) to receiving the copying status. The value of this parameter must be
;                                  between 0 and 255. If the slot with the specified ID is already in use, the function fails.
;                                  This slot can not be used as long as the copying will not be completed or will not be aborted
;                                  by user. The maximum number of copying files or folders at once is 256. To retrieve the
;                                  copying status, you must call the _Copy_GetState() function with ID that has been specified
;                                  in this function.
; Return values..: Success       - 1.
;                  Failure       - 0 and sets the @error flag to non-zero (see above).
; Author.........: Yashied
; Modified.......:
; Remarks........: This function preserves extended attributes, OLE structured storage, NTFS file system alternate data streams,
;                  and file attributes. Security attributes for the existing file are not copied to the new file.
;
;                  This function fails with ERROR_ACCESS_DENIED (5) if the destination file already exists and has the
;                  FILE_ATTRIBUTE_HIDDEN or FILE_ATTRIBUTE_READONLY attribute set.
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _Copy_CopyDir($sSource, $sDestination, $iFlags = 0, $iID = 0)
	__CP_CopyMoveProgress($sSource, $sDestination, $iFlags, $iID, 'CopyDirProgress')
	If @error Then
		Return SetError(@error, 0, 0)
	Else
		Return 1
	EndIf
EndFunc   ;==>_Copy_CopyDir

; #FUNCTION# ====================================================================================================================
; Name...........: _Copy_CopyFile
; Description....: Copies an existing file to a new file.
; Syntax.........: _Copy_CopyFile ( $sSource, $sDestination [, $iFlags [, $iID]] )
; Parameters.....: $sSource      - The name of the existing file.
;                  $sDestination - The new name of the file.
;                  $iFlags       - Flags that specify how the file is to be copied. It can be one or more of the following values.
;
;                                  $COPY_FILE_ALLOW_DECRYPTED_DESTINATION
;                                  $COPY_FILE_COPY_SYMLINK
;                                  $COPY_FILE_FAIL_IF_EXISTS
;                                  $COPY_FILE_NO_BUFFERING
;                                  $COPY_FILE_OPEN_SOURCE_FOR_WRITE
;
;                  $iID          - The slot identifier (ID) to receiving the copying status. The value of this parameter must be
;                                  between 0 and 255. If the slot with the specified ID is already in use, the function fails.
;                                  This slot can not be used as long as the copying will not be completed or will not be aborted
;                                  by user. The maximum number of copying files or folders at once is 256. To retrieve the
;                                  copying status, you must call the _Copy_GetState() function with ID that has been specified
;                                  in this function.
; Return values..: Success       - 1.
;                  Failure       - 0 and sets the @error flag to non-zero (see above).
; Author.........: Yashied
; Modified.......:
; Remarks........: This function preserves extended attributes, OLE structured storage, NTFS file system alternate data streams,
;                  and file attributes. Security attributes for the existing file are not copied to the new file.
;
;                  This function fails with ERROR_ACCESS_DENIED (5) if the destination file already exists and has the
;                  FILE_ATTRIBUTE_HIDDEN or FILE_ATTRIBUTE_READONLY attribute set.
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _Copy_CopyFile($sSource, $sDestination, $iFlags = 0, $iID = 0)
	__CP_CopyMoveProgress($sSource, $sDestination, $iFlags, $iID, 'CopyFileProgress')
	If @error Then
		Return SetError(@error, 0, 0)
	Else
		Return 1
	EndIf
EndFunc   ;==>_Copy_CopyFile

; #FUNCTION# ====================================================================================================================
; Name...........: _Copy_GetState
; Description....: Retrieve a copying status for the specified slot.
; Syntax.........: _Copy_GetState ( [$iID = 0 [, $iIndex]] )
; Parameters.....: $iID    - The slot identifier that has been specified in the _Copy_Copy... or _Copy_Move... funtions.
;                  $iIndex - An index of the parameter that is of interest. If this parameter is (-1) or not specified, the function
;                            returns an array of all possible parameters (see below).
; Return values..: Success - A value of the required parameter or an array containing the following information.
;
;                            [0] - Current state. (0 - Complete; (-1) - Enumerate; 1 - Progress)
;                            [1] - Total bytes transferred.
;                            [2] - Total size, in bytes.
;                            [3] - The current file's bytes transferred.
;                            [4] - File size, in bytes.
;                            [5] - System error code. (0 - No error; (-1) - Internal DLL error; * - System error (see MSDN))
;                            [6] - The full path to the source file that in progress.
;                            [7] - The full path to the destination file that in progress.
;
;                  Failure - 0 and sets the @error flag to non-zero (see above).
; Author.........: Yashied
; Modified.......:
; Remarks........: This function reads the required values from the buffer, and does not affect the process of copying or moving.
;                  If you are not interested in additional information about copying, you can call _Copy_GetState() only to
;                  determine that the copying is complete. For example,
;
;                  While _Copy_GetState($ID, 0)
;                      ; Anything
;                  WEnd
;
;                  Even after copying is completed, the information about the last state in the buffer will be stored until this
;                  slot will not be used again.
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _Copy_GetState($iID = 0, $iIndex = -1)

	Local $aState

	If $__DLL = -1 Then
		Return SetError(1, 0, 0)
	EndIf
	If (Not IsNumber($iID)) Or ($iID < 0) Or ($iID > UBound($__Slot) - 1) Then
		Return SetError(2, 0, 0)
	EndIf
	If Not IsDllStruct($__Slot[$iID]) Then
		Return SetError(3, 0, 0)
	EndIf
	While DllStructGetData($__Slot[$iID], 'Synchronize')
		; Synchronization
	WEnd
	DllStructSetData($__Slot[$iID], 'Synchronize', 1)
	If $iIndex = -1 Then
		Dim $aState[8]
		$aState[0] = DllStructGetData($__Slot[$iID], 'Progress')
		$aState[1] = DllStructGetData($__Slot[$iID], 'TotalBytesTransferred')
		$aState[2] = DllStructGetData($__Slot[$iID], 'TotalSize')
		$aState[3] = DllStructGetData($__Slot[$iID], 'FileBytesTransferred')
		$aState[4] = DllStructGetData($__Slot[$iID], 'FileSize')
		$aState[5] = DllStructGetData($__Slot[$iID], 'SystemErrorCode')
		$aState[6] = DllStructGetData($__Slot[$iID], 'Source')
		$aState[7] = DllStructGetData($__Slot[$iID], 'Destination')
;~		__CP_Debug($aState)
	Else
		Switch $iIndex
			Case 0
				$aState = DllStructGetData($__Slot[$iID], 'Progress')
			Case 1
				$aState = DllStructGetData($__Slot[$iID], 'TotalBytesTransferred')
			Case 2
				$aState = DllStructGetData($__Slot[$iID], 'TotalSize')
			Case 3
				$aState = DllStructGetData($__Slot[$iID], 'FileBytesTransferred')
			Case 4
				$aState = DllStructGetData($__Slot[$iID], 'FileSize')
			Case 5
				$aState = DllStructGetData($__Slot[$iID], 'SystemErrorCode')
			Case 6
				$aState = DllStructGetData($__Slot[$iID], 'Source')
			Case 7
				$aState = DllStructGetData($__Slot[$iID], 'Destination')
			Case Else
				$aState = Default
		EndSwitch
	EndIf
	DllStructSetData($__Slot[$iID], 'Synchronize', 0)
	If $aState = Default Then
		Return SetError(2, 0, 0)
	EndIf
	Return $aState
EndFunc   ;==>_Copy_GetState

; #FUNCTION# ====================================================================================================================
; Name...........: _Copy_MoveDir
; Description....: Moves a directory and all sub-directories and files to another directory.
; Syntax.........: _Copy_MoveDir ( $sSource, $sDestination [, $iFlags [, $iID]] )
; Parameters.....: $sSource      - The path to the source directory that to be moved.
;                  $sDestination - The path to the destination directory.
;                  $iFlags       - Flags that specify how the file is to be moved. It can be one or more of the following values.
;
;                                  $MOVE_FILE_COPY_ALLOWED
;                                  $MOVE_FILE_CREATE_HARDLINK
;                                  $MOVE_FILE_FAIL_IF_NOT_TRACKABLE
;                                  $MOVE_FILE_REPLACE_EXISTING
;                                  $MOVE_FILE_WRITE_THROUGH
;
;                  $iID          - The slot identifier (ID) to receiving the copying status. The value of this parameter must be
;                                  between 0 and 255. If the slot with the specified ID is already in use, the function fails.
;                                  This slot can not be used as long as the copying will not be completed or will not be aborted
;                                  by user. The maximum number of copying files or folders at once is 256. To retrieve the
;                                  copying status, you must call the _Copy_GetState() function with ID that has been specified
;                                  in this function.
; Return values..: Success       - 1.
;                  Failure       - 0 and sets the @error flag to non-zero (see above).
; Author.........: Yashied
; Modified.......:
; Remarks........: Note, if you move a directory within the same drive, it may take more time than moving this directory by using
;                  the _Copy_MoveFile() function. If the source and destination directories located on a different drives and the
;                  $MOVEFILE_COPY_ALLOWED flag is not set, the function fails with ERROR_NOT_SAME_DEVICE (17).
;
;                  If the directory is to be moved to a different volume, the function simulates the move by using the CopyFile(),
;                  DeleteFile(), CreateDirectory(), and RemoveDirectory() functions.
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _Copy_MoveDir($sSource, $sDestination, $iFlags = 0, $iID = 0)
	__CP_CopyMoveProgress($sSource, $sDestination, $iFlags, $iID, 'MoveDirProgress')
	If @error Then
		Return SetError(@error, 0, 0)
	Else
		Return 1
	EndIf
EndFunc   ;==>_Copy_MoveDir

; #FUNCTION# ====================================================================================================================
; Name...........: _Copy_MoveFile
; Description....: Moves a file or directory, including its children.
; Syntax.........: _Copy_MoveFile ( $sSource, $sDestination [, $iFlags [, $iID]] )
; Parameters.....: $sSource      - The name of the existing file or directory.
;                  $sDestination - The new name of the file or directory.
;                  $iFlags       - Flags that specify how the file is to be moved. It can be one or more of the following values.
;
;                                  $MOVE_FILE_COPY_ALLOWED
;                                  $MOVE_FILE_CREATE_HARDLINK
;                                  $MOVE_FILE_FAIL_IF_NOT_TRACKABLE
;                                  $MOVE_FILE_REPLACE_EXISTING
;                                  $MOVE_FILE_WRITE_THROUGH
;
;                  $iID          - The slot identifier (ID) to receiving the copying status. The value of this parameter must be
;                                  between 0 and 255. If the slot with the specified ID is already in use, the function fails.
;                                  This slot can not be used as long as the copying will not be completed or will not be aborted
;                                  by user. The maximum number of copying files or folders at once is 256. To retrieve the
;                                  copying status, you must call the _Copy_GetState() function with ID that has been specified
;                                  in this function.
; Return values..: Success       - 1.
;                  Failure       - 0 and sets the @error flag to non-zero (see above).
; Author.........: Yashied
; Modified.......:
; Remarks........: When moving a file, $sDestination can be on a different file system or volume. If $sDestination is on another
;                  drive, you must set the $MOVEFILE_COPY_ALLOWED flag. When moving a directory, $sSource and $sDestination must
;                  be on the same drive.
;
;                  If the file is to be moved to a different volume, the function simulates the move by using the CopyFile()
;                  and DeleteFile() functions.
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _Copy_MoveFile($sSource, $sDestination, $iFlags = 0, $iID = 0)
	__CP_CopyMoveProgress($sSource, $sDestination, $iFlags, $iID, 'MoveFileProgress')
	If @error Then
		Return SetError(@error, 0, 0)
	Else
		Return 1
	EndIf
EndFunc   ;==>_Copy_MoveFile

; #FUNCTION# ====================================================================================================================
; Name...........: _Copy_OpenDll
; Description....: Opens a Copy.dll for use in this library.
; Syntax.........: _Copy_OpenDll ( [$sDLL] )
; Parameters.....: $sDLL   - The path to the DLL file to open. By default is used Copy.dll for 32-bit and Copy_x64.dll for 64-bit
;                            operating systems.
; Return values..: Success - 1.
;                  Failure - 0 and sets the @error flag to non-zero (see above).
; Author.........: Yashied
; Modified.......:
; Remarks........: Note, the 64-bit executables cannot load 32-bit DLLs and vice-versa.
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _Copy_OpenDll($sDLL = '')
	If $__DLL <> -1 Then
		Return SetError(6, 0, 0)
	EndIf
	If Not $sDLL Then
		If @AutoItX64 Then
			;$sDll = @ScriptDir & '\Copy_x64.dll'	original line
			$sDll = @ScriptDir & '\Lib\copy\Copy_x64.dll' ; <<<<<<< modified for DropIt
		Else
			;$sDll = @ScriptDir & '\Copy.dll'	original line
			$sDll = @ScriptDir & '\Lib\copy\Copy.dll' ; <<<<<<< modified for DropIt
		EndIf
	EndIf
	If Not FileExists($sDLL) Then
		Return SetError(8, 0, 0)
	EndIf
	If StringRegExpReplace(FileGetVersion($sDLL), '(\d+\.\d+).*', '\1') <> '1.3' Then
		Return SetError(7, 0, 0)
	EndIf
	$__DLL = DllOpen($sDLL)
	If $__DLL = -1 Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_Copy_OpenDll

; #FUNCTION# ====================================================================================================================
; Name...........: _Copy_Pause
; Description....: Suspends and resumes a process of copying or moving files.
; Syntax.........: _Copy_Pause ( $fPause [, $iID] )
; Parameters.....: $fPause - Specifies whether to suspend or resume the copying files, valid values:
;                  |TRUE   - Suspend.
;                  |FALSE  - Resume.
;                  $iID    - The slot identifier that has been specified in the _Copy_Copy... or _Copy_Move... funtions. If this
;                            parameter is (-1), all running processes will be suspended or resumed.
; Return values..: Success - 1.
;                  Failure - 0 and sets the @error flag to non-zero (see above).
; Author.........: Yashied
; Modified.......:
; Remarks........: If the copying or moving files was completed, the function has no effect.
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _Copy_Pause($fPause, $iID = 0)

	If $__DLL = -1 Then
		Return SetError(1, 0, 0)
	EndIf
	If (Not IsNumber($iID)) Or ($iID < -1) Or ($iID > UBound($__Slot) - 1) Then
		Return SetError(2, 0, 0)
	EndIf
	If $iID = -1 Then
		For $i = 0 To UBound($__Slot) - 1
			If (IsDllStruct($__Slot[$i])) And (DllStructGetData($__Slot[$i], 'Progress')) Then
				DllStructSetData($__Slot[$i], 'Pause', $fPause)
			EndIf
		Next
	Else
		If DllStructGetData($__Slot[$iID], 'Progress') Then
			DllStructSetData($__Slot[$iID], 'Pause', $fPause)
		Else
			Return SetError(3, 0, 0)
		EndIf
	EndIf
	Return 1
EndFunc   ;==>_Copy_Pause

#EndRegion Public Functions

#Region Internal Functions

Func __CP_CopyMoveProgress($sSource, $sDestination, $iFlags, $iID, $sFunc)

	Local $aResult

	If $__DLL = -1 Then
		Return SetError(1, 0, 0)
	EndIf
	If (Not IsNumber($iID)) Or ($iID < 0) Or ($iID > UBound($__Slot) - 1) Then
		Return SetError(2, 0, 0)
	EndIf
	If Not IsDllStruct($__Slot[$iID]) Then
		$__Slot[$iID] = DllStructCreate($__CALLBACKSTATUS)
	Else
		If DllStructGetData($__Slot[$iID], 'Progress') Then
			Return SetError(4, 0, 0)
		EndIf
	EndIf
	$aResult = DllCall($__DLL, 'int', $sFunc, 'wstr', $sSource, 'wstr', $sDestination, 'dword', $iFlags, 'ptr', DllStructGetPtr($__Slot[$iID]))
	If (@error) Or (Not $aResult[0]) Then
		Return SetError(5, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__CP_CopyMoveProgress

Func __CP_Debug(ByRef $aState)

	Static $Text, $Prev = Default

	$Text = StringFormat('%2s  ', $aState[0])
	For $i = 1 To 5
		$Text &= StringFormat('%-12s', $aState[$i])
	Next
	$Text &= $aState[6]
	If $Text <> $Prev Then
		ConsoleWrite($Text & @CR)
		$Prev = $Text
	EndIf
EndFunc   ;==>__CP_Debug

#EndRegion Internal Functions

#Region AutoIt Exit Functions

Func __CP_AutoItExit()
	_Copy_Abort(-1)
EndFunc   ;==>__CP_AutoItExit

#EndRegion AutoIt Exit Functions
