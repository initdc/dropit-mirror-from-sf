#Region Header

#cs

    Title:          Management of Copying Files UDF Library for AutoIt3
    Filename:       Copy.au3
    Description:    Copies a files without pausing a script
    Author:         Yashied
    Version:        1.2
    Requirements:   AutoIt v3.3 +, Developed/Tested on WindowsXP Pro Service Pack 2
    Uses:           None
    Notes:          This library requires Copy.dll (v1.2.x.x)

    Available functions:

	_Copy_Abort
	_Copy_CloseDll
	_Copy_CopyFile
	_Copy_GetState
	_Copy_MoveFile
	_Copy_OpenDll

    Error codes:

        0 - No error
        1 - DLL not loaded
        2 - ID is incorrect or out of range
        3 - Thread is not yet initialized
        4 - Thread is now being used
        5 - DllCall() error
        6 - DLL already loaded
        7 - Incompatible DLL version

    Example:

		#Include <Copy.au3>
		#Include <EditConstants.au3>
		#Include <GUIConstantsEx.au3>

		Opt('MustDeclareVars', 1)
        Opt('TrayAutoPause', 0)

		Global $hForm, $Input1, $Input2, $Button1, $Button2, $Button3, $Data, $Msg, $Path, $Progress, $Percent, $Size, $State, $Copy = 0
		Global $Source = '', $Destination = ''

		If Not _Copy_OpenDll() Then
			MsgBox(16, '', 'Copy.dll not found.')
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
		$Button3 = GUICtrlCreateButton('Copy', 145, 125, 70, 23)
		GUISetState()

		While 1
			If $Copy Then
				$State = _Copy_GetState()
				If $State[0] Then
					$Data = Round($State[1] / $Size * 100)
					If $Data <> $Percent Then
						GUICtrlSetData($Progress, $Data)
						$Percent = $Data
					EndIf
				Else
					Switch $State[2]
						Case 0
							GUICtrlSetData($Progress, 100)
							MsgBox(64, '', 'File was successfully copied.', 0, $hForm)
						Case 1235 ; ERROR_REQUEST_ABORTED
							MsgBox(16, '', 'File copying was aborted.', 0, $hForm)
						Case Else
							MsgBox(16, '', 'File was not copied.' & @CR & @CR & $State[2], 0, $hForm)
					EndSwitch
					GUICtrlSetData($Progress, 0)
					GUICtrlSetState($Button1, $GUI_ENABLE)
					GUICtrlSetState($Button2, $GUI_ENABLE)
					GUICtrlSetData($Button3, 'Copy')
					$Copy = 0
				EndIf
			EndIf
			$Msg = GUIGetMsg()
			Switch $Msg
				Case 0
					ContinueLoop
				Case $GUI_EVENT_CLOSE
					_Copy_Abort()
					ExitLoop
				Case $Button1
					$Path = FileOpenDialog('Select Source File', StringRegExpReplace($Source, '\\[^\\]*\Z', ''), 'All Files (*.*)', 3, StringRegExpReplace($Source, '^.*\\', ''), $hForm)
					If $Path Then
						GUICtrlSetData($Input1, $Path)
						$Source = $Path
					EndIf
				Case $Button2
					$Path = FileOpenDialog('Select Source File', StringRegExpReplace($Destination, '\\[^\\]*\Z', ''), 'All Files (*.*)', 2, StringRegExpReplace($Source, '^.*\\', ''), $hForm)
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
						If $Path = $Source Then
							MsgBox(16, '', 'The source and destination file names must be different.', 0, $hForm)
							ContinueLoop
						EndIf
						If FileExists($Destination) Then
							If MsgBox(52, '', $Path & ' already exists.' & @CR & @CR & 'Do you want to replace it?', 0, $hForm) <> 6 Then
								ContinueLoop
							EndIf
						EndIf
						$Percent = 0
						$Size = FileGetSize($Source)
						GUICtrlSetState($Button1, $GUI_DISABLE)
						GUICtrlSetState($Button2, $GUI_DISABLE)
						GUICtrlSetData($Button3, 'Abort')
						_Copy_CopyFile($Source, $Destination)
						$Copy = 1
					EndIf
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

Global $__cpState[256]
Global $__cpDll = -1

#EndRegion Local Variables and Constants

#Region Initialization

OnAutoItExitRegister('__CP_AutoItExit')

#EndRegion Initialization

#Region Public Functions

Func _Copy_Abort($iID = 0)
	If $__cpDll = -1 Then
		Return SetError(1, 0, 0)
	EndIf
	If (Not IsNumber($iID)) Or ($iID < -1) Or ($iID > UBound($__cpState) - 1) Then
		Return SetError(2, 0, 0)
	EndIf
	If $iID = -1 Then
		For $i = 0 To UBound($__cpState) - 1
			If (IsDllStruct($__cpState[$i])) And (DllStructGetData($__cpState[$i], 4)) Then
				DllStructSetData($__cpState[$i], 2, 1)
				While DllStructGetData($__cpState[$i], 4)
					Sleep(10)
				WEnd
			EndIf
		Next
	Else
		If Not IsDllStruct($__cpState[$iID]) Then
			Return SetError(3, 0, 0)
		EndIf
		If DllStructGetData($__cpState[$iID], 4) Then
			DllStructSetData($__cpState[$iID], 2, 1)
			While DllStructGetData($__cpState[$iID], 4)
				Sleep(10)
			WEnd
		EndIf
	EndIf
	Return 1
EndFunc   ;==>_Copy_Abort

Func _Copy_CloseDll()
	If $__cpDll = -1 Then
		Return SetError(1, 0, 0)
	EndIf
	For $i = 0 To UBound($__cpState) - 1
		If (IsDllStruct($__cpState[$i])) And (DllStructGetData($__cpState[$i], 4)) Then
			Return SetError(4, 0, 0)
		EndIf
	Next
	DllClose($__cpDll)
	$__cpDll = -1
	Return 1
EndFunc   ;==>_Copy_CloseDll

Func _Copy_CopyFile($sSource, $sDestination, $iFlags = 0, $iID = 0)
	_Copy_CopyMoveFileProgress($sSource, $sDestination, $iFlags, $iID, 'CopyFileProgressW')
	If @error Then
		Return SetError(@error, 0, 0)
	Else
		Return 1
	EndIf
EndFunc   ;==>_Copy_CopyFile

Func _Copy_GetState($iID = 0, $iIndex = -1)

	Local $aState

	If $__cpDll = -1 Then
		Return SetError(1, 0, 0)
	EndIf
	If (Not IsNumber($iID)) Or ($iID < 0) Or ($iID > UBound($__cpState) - 1) Then
		Return SetError(2, 0, 0)
	EndIf
	If Not IsDllStruct($__cpState[$iID]) Then
		Return SetError(3, 0, 0)
	EndIf
	If $iIndex = -1 Then
		Dim $aState[3]
		$aState[0] = DllStructGetData($__cpState[$iID], 4) ; Current state (0 - Complete; 1- Progress)
		$aState[1] = DllStructGetData($__cpState[$iID], 1) ; Total bytes transferred (% = $TotalBytesTransferred/$FileSize * 100)
		$aState[2] = DllStructGetData($__cpState[$iID], 3) ; System error code ((-1) - Internal DLL error)
	Else
		Switch $iIndex
			Case 0
				$aState = DllStructGetData($__cpState[$iID], 4)
			Case 1
				$aState = DllStructGetData($__cpState[$iID], 1)
			Case 2
				$aState = DllStructGetData($__cpState[$iID], 3)
			Case Else
				Return SetError(2, 0, 0)
		EndSwitch
	EndIf
	Return $aState
EndFunc   ;==>_Copy_GetState

Func _Copy_MoveFile($sSource, $sDestination, $iFlags = 0, $iID = 0)
	_Copy_CopyMoveFileProgress($sSource, $sDestination, $iFlags, $iID, 'MoveFileProgressW')
	If @error Then
		Return SetError(@error, 0, 0)
	Else
		Return 1
	EndIf
EndFunc   ;==>_Copy_MoveFile

Func _Copy_OpenDll($sDll = '')
	If $__cpDll <> -1 Then
		Return SetError(6, 0, 0)
	EndIf
	If Not StringStripWS($sDll, 3) Then
		If @AutoItX64 Then
			;$sDll = @ScriptDir & '\Copy_x64.dll'	original line
			$sDll = @ScriptDir & '\Lib\copy\Copy_x64.dll' ; <<<<<<< modified for DropIt
		Else
			;$sDll = @ScriptDir & '\Copy.dll'	original line
			$sDll = @ScriptDir & '\Lib\copy\Copy.dll' ; <<<<<<< modified for DropIt
		EndIf
	EndIf
	If StringRegExpReplace(FileGetVersion($sDll), '(\d+\.\d+).*', '\1') <> '1.2' Then
		Return SetError(7, 0, 0)
	EndIf
	$__cpDll = DllOpen($sDll)
	If $__cpDll = -1 Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_Copy_OpenDll

#EndRegion Public Functions

#Region Internal Functions

Func _Copy_CopyMoveFileProgress($sSource, $sDestination, $iFlags, $iID, $sFunc)

	Local $aResult

	If $__cpDll = -1 Then
		Return SetError(1, 0, 0)
	EndIf
	If (Not IsNumber($iID)) Or ($iID < 0) Or ($iID > UBound($__cpState) - 1) Then
		Return SetError(2, 0, 0)
	EndIf
	If Not IsDllStruct($__cpState[$iID]) Then
		$__cpState[$iID] = DllStructCreate('uint64;int;int;int')
	Else
		If DllStructGetData($__cpState[$iID], 4) Then
			Return SetError(4, 0, 0)
		EndIf
	EndIf
	$aResult = DllCall($__cpDll, 'int', $sFunc, 'wstr', $sSource, 'wstr', $sDestination, 'dword', $iFlags, 'ptr', DllStructGetPtr($__cpState[$iID]))
	If (@error) Or (Not $aResult[0]) Then
		Return SetError(5, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_Copy_CopyMoveFileProgress

#EndRegion Internal Functions

#Region AutoIt Exit Functions

Func __CP_AutoItExit()
	_Copy_Abort(-1)
EndFunc   ;==>__CP_AutoItExit

#EndRegion AutoIt Exit Functions
