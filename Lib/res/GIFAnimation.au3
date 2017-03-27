;.......script written by trancexx (trancexx at yahoo dot com)

#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#include-once

; #INDEX# ========================================================================================
; Title ...............: GIFAnimation
; File Name............: GIFAnimation.au3
; Min. AutoIt Version..: v3.3.2.0
; Description .........: Display GIF in AutoIt
; Author... ...........: trancexx
; Dll .................: kernel32.dll, user32.dll, gdi32.dll, comctl32.dll, ole32.dll, gdiplus.dll
; ================================================================================================

; #CONSTANTS# ===============================================================================
; Pseudo-handles for DLLs to use
Global Const $hGIFDLL__KERNEL32 = DllOpen("kernel32.dll")
Global Const $hGIFDLL__USER32 = DllOpen("user32.dll")
Global Const $hGIFDLL__GDI32 = DllOpen("gdi32.dll")
Global Const $hGIFDLL__COMCTL32 = DllOpen("comctl32.dll")
Global Const $hGIFDLL__OLE32 = DllOpen("ole32.dll")
Global Const $hGIFDLL__GDIPLUS = DllOpen("gdiplus.dll")
;============================================================================================

; #CURRENT# =================================================================================
;_GIF_DeleteGIF
;_GIF_ExitAnimation
;_GIF_GetCtrlID
;_GIF_GetCurrentFrame
;_GIF_GetDimension
;_GIF_GetSize
;_GIF_PauseAnimation
;_GIF_RefreshGIF
;_GIF_ResumeAnimation
;_GIF_ValidateGIF
;_GUICtrlCreateGIF
; ===========================================================================================

; #FUNCTION# ;===============================================================================
;
; Name...........: _GIF_DeleteGIF
; Description ...: Deletes GIF control
; Syntax.........: _GIF_DeleteGIF(ByRef $pGIF)
; Parameters ....: $pGIF - GIF specific value set by _GUICtrlCreateGIF function
; Return values .: Returns 1
; Author ........: trancexx
;
;============================================================================================
Func _GIF_DeleteGIF(ByRef $pGIF)
	; Read $pGIF (shorter version - only handles and memory pointers)
	Local $tGIF = DllStructCreate("handle GIFThread;" & _
			"ptr CodeBuffer;" & _
			"hwnd ControlHandle;" & _
			"handle ImageList;" & _
			"bool ExitFlag;", _
			$pGIF)
	; GIFThread. Will alow it to exit gracefully for it to close all internally opened handles
	Local $hGIFThread = DllStructGetData($tGIF, "GIFThread")
	If $hGIFThread Then
		; Maybe it's suspended
		_GIF_ResumeThread($hGIFThread)
		; Set exit Flag
		DllStructSetData($tGIF, "ExitFlag", 1)
		; Thread will exit now. Wait for it to exit
		_GIF_WaitForSingleObject($hGIFThread)
		_GIF_CloseHandle($hGIFThread) ; closing the handle
	EndIf
	; CodeBuffer
	Local $pCodeBuffer = DllStructGetData($tGIF, "CodeBuffer")
	If $pCodeBuffer Then _GIF_MemGlobalFree($pCodeBuffer)
	; ImageList
	Local $hImageList = DllStructGetData($tGIF, "ImageList")
	If $hImageList Then _GIF_ImageList_Destroy($hImageList)
	; The rest of the cleaning job
	_GIF_MemGlobalFree($pGIF)
	$pGIF = 0
	; Not sure if GUICtrlDelete will delete associated Bitmap. Will do that by myself...
	Local $hGIFControl = _GIF_GetDlgCtrlID(DllStructGetData($tGIF, "ControlHandle"))
	_GIF_DeleteObject(GUICtrlSendMsg($hGIFControl, 370, 0, 0)) ; STM_SETIMAGE
	; Delete control
	GUICtrlDelete($hGIFControl)
	Return 1
EndFunc   ;==>_GIF_DeleteGIF

; #FUNCTION# ;===============================================================================
;
; Name...........: _GIF_ExitAnimation
; Description ...: Exits animation of GIF control
; Syntax.........: _GIF_ExitAnimation(ByRef $pGIF)
; Parameters ....: $pGIF - GIF specific value set by _GUICtrlCreateGIF function
; Return values .: Returns 1
; Author ........: trancexx
;
;============================================================================================
Func _GIF_ExitAnimation(ByRef $pGIF)
	; Read $pGIF (shorter version - only handles and memory pointers)
	Local $tGIF = DllStructCreate("handle GIFThread;" & _
			"ptr CodeBuffer;" & _
			"hwnd ControlHandle;" & _
			"handle ImageList;" & _
			"bool ExitFlag;" & _
			"bool Transparent;" & _
			"dword CurrentFrame;", _
			$pGIF)
	; GIFThread. Will alow it to exit gracefully for it to close all internally opened handles
	Local $hGIFThread = DllStructGetData($tGIF, "GIFThread")
	If $hGIFThread Then
		; Maybe it's suspended
		_GIF_ResumeThread($hGIFThread)
		; Set exit Flag
		DllStructSetData($tGIF, "ExitFlag", 1)
		; Thread will exit now. Wait for it to exit
		_GIF_WaitForSingleObject($hGIFThread)
		_GIF_CloseHandle($hGIFThread) ; closing the handle
		DllStructSetData($tGIF, "GIFThread", 0)
	EndIf
	; CodeBuffer
	Local $pCodeBuffer = DllStructGetData($tGIF, "CodeBuffer")
	If $pCodeBuffer Then _GIF_MemGlobalFree($pCodeBuffer)
	DllStructSetData($tGIF, "CodeBuffer", 0)
	; ImageList
	Local $hImageList = DllStructGetData($tGIF, "ImageList")
	If $hImageList Then _GIF_ImageList_Destroy($hImageList)
	DllStructSetData($tGIF, "ImageList", 0)
	; Set value of CurrentFrame to 0
	DllStructSetData($tGIF, "CurrentFrame", 0)
	; Refresh the control
	Local $hGIFControl = _GIF_GetDlgCtrlID(DllStructGetData($tGIF, "ControlHandle"))
	GUICtrlSetState($hGIFControl, GUICtrlGetState($hGIFControl))
	Return 1
EndFunc   ;==>_GIF_ExitAnimation

; #FUNCTION# ;===============================================================================
;
; Name...........: _GIF_GetCtrlID
; Description ...: Retrieves Control identifier of the GIF control
; Syntax.........: _GIF_GetCtrlID(ByRef $pGIF)
; Parameters ....: $pGIF - GIF specific value set by _GUICtrlCreateGIF function
; Return values .: Returns ControlID
; Author ........: trancexx
;
;============================================================================================
Func _GIF_GetCtrlID(ByRef $pGIF)
	Return _GIF_GetDlgCtrlID(_GIF_GetCtrlHandle($pGIF))
EndFunc   ;==>_GIF_GetCtrlID

; #FUNCTION# ;===============================================================================
;
; Name...........: _GIF_GetCurrentFrame
; Description ...: Retrieves index of currently displayed frame of the GIF control
; Syntax.........: _GIF_GetCurrentFrame(ByRef $pGIF)
; Parameters ....: $pGIF - GIF specific value set by _GUICtrlCreateGIF function
; Return values .: Returns frame index
; Author ........: trancexx
;
;============================================================================================
Func _GIF_GetCurrentFrame(ByRef $pGIF)
	; Read $pGIF (shorter version)
	Local $tGIF = DllStructCreate("handle GIFThread;" & _
			"ptr CodeBuffer;" & _
			"hwnd ControlHandle;" & _
			"handle ImageList;" & _
			"bool ExitFlag;" & _
			"bool Transparent;" & _
			"dword CurrentFrame;", _
			$pGIF)
	Return DllStructGetData($tGIF, "CurrentFrame")
EndFunc   ;==>_GIF_GetCurrentFrame

; #FUNCTION# ;===============================================================================
;
; Name...........: _GIF_GetDimension
; Description ...: Returns array of GIF image dimension
; Syntax.........: _GIF_GetDimension($vGIF [, $vAdditionalData])
; Parameters ....: $vGIF - filename of the GIF file
;                  $vAdditionalData - optional parameter used if the GIF if embedded resource inside PE file.
;                                     resurce type, name and language (all separated by semicolon ';')
;                                     language is optional
; Return values .: Success - Returns array which first element [0] is width,
;                                                second element [1] is height,
;                          - Sets @error to 0
;                  Failure - Returns array which first element [0] is 0 (zero),
;                                                second element [1] is 0 (zero),
;                          - Sets @error:
;                           |1 - invalid input or Gdip failure
; Author ........: trancexx
;
;============================================================================================
Func _GIF_GetDimension($vGIF, $vAdditionalData = "")
	Local $aOut[2] = [0, 0] ; preset output
	Local $vData
	; Process passed
	If IsBinary($vGIF) Then ; GIF binary data passed
		$vData = $vGIF
	Else
		If $vAdditionalData Then ; likely resource
			Local $aData = StringSplit($vAdditionalData, ";", 2)
			If UBound($aData) < 3 Then ReDim $aData[3]
			$vData = _GIF_ResourceGetAsRaw($vGIF, $aData[0], $aData[1], $aData[2])
			If @error Then
				$vData = $vGIF ; it's not resource, $vAdditionalData was wrong
			Else
				; RT_BITMAP is stored without BMP header. Add it:
				If $aData[0] = 2 Then $vData = _GIF_MakeBitmapFromRT_BITMAP($vData)
			EndIf
		Else
			$vData = $vGIF ; maybe $vGIF is the file name
		EndIf
	EndIf
	Local $hGDIP ; Gdip engine
	Local $hMemGlobal ; Memory
	; Bitmap object
	Local $pBitmap, $iWidth, $iHeight
	If IsString($vData) Then
		$pBitmap = _GIF_CreateBitmapFromFile($hGDIP, $vData, $iWidth, $iHeight)
		If @error Then $pBitmap = _GIF_CreateBitmapFromBinaryImage($hGDIP, $hMemGlobal, Binary($vData), $iWidth, $iHeight)
		If @error Then
			Local $hGIFFile = FileOpen($vData)
			$vData = FileRead($hGIFFile)
			FileClose($hGIFFile)
			$pBitmap = _GIF_CreateBitmapFromBinaryImage($hGDIP, $hMemGlobal, $vData, $iWidth, $iHeight)
		EndIf
	Else
		$pBitmap = _GIF_CreateBitmapFromBinaryImage($hGDIP, $hMemGlobal, $vData, $iWidth, $iHeight)
	EndIf
	If @error Then Return SetError(1, 0, $aOut) ; Nothing worked. Invalid input or Gdip failure.
	_GIF_FreeGdipAndMem($pBitmap, $hGDIP, $hMemGlobal)
	$aOut[0] = $iWidth
	$aOut[1] = $iHeight
	Return $aOut
EndFunc   ;==>_GIF_GetDimension

; #FUNCTION# ;===============================================================================
;
; Name...........: _GIF_GetSize
; Description ...: Returns array of animated GIF Control dimension
; Syntax.........: _GIF_GetSize(ByRef $pGIF)
; Parameters ....: $pGIF - GIF specific value set by _GUICtrlCreateGIF function
; Return values .: Success - Returns array which first element [0] is width,
;                                                second element [1] is height,
;                  Failure - Returns array which first element [0] is 0 (zero),
;                                                second element [1] is 0 (zero),
;                           Sets @error to 1
; Author ........: trancexx
;
;============================================================================================
Func _GIF_GetSize(ByRef $pGIF)
	Local $aOut[2] = [0, 0] ; preset output
	; Read $pGIF (shorter version)
	Local $tGIF = DllStructCreate("handle GIFThread;" & _
			"ptr CodeBuffer;" & _
			"hwnd ControlHandle;" & _
			"handle ImageList;", _
			$pGIF)
	; ImageList
	Local $hImageList = DllStructGetData($tGIF, "ImageList")
	If $hImageList Then Return _GIF_ImageList_GetIconSize($hImageList)
	Local $hControl = DllStructGetData($tGIF, "ControlHandle")
	If Not $hControl Then Return SetError(1, 0, $aOut)
	Local $aArray = WinGetPos($hControl)
	If @error Then Return SetError(1, 0, $aOut)
	$aOut[0] = $aArray[2]
	$aOut[1] = $aArray[3]
	Return $aOut
EndFunc   ;==>_GIF_GetSize

; #FUNCTION# ;===============================================================================
;
; Name...........: _GIF_PauseAnimation
; Description ...: Pauses animation of GIF control
; Syntax.........: _GIF_PauseAnimation(ByRef $pGIF)
; Parameters ....: $pGIF - GIF specific value set by _GUICtrlCreateGIF function
; Return values .: Returns 1
; Author ........: trancexx
;
;============================================================================================
Func _GIF_PauseAnimation(ByRef $pGIF)
	; Read $pGIF (short version - only GIFThread)
	Local $tGIF = DllStructCreate("handle GIFThread;", $pGIF)
	; GIFThread
	Local $hGIFThread = DllStructGetData($tGIF, "GIFThread")
	If Not $hGIFThread Then Return SetExtended(1, 1)
	If _GIF_SuspendThread($hGIFThread) Then _GIF_ResumeThread($hGIFThread) ; make sure not to increment suspended count of the thread
	Return 1
EndFunc   ;==>_GIF_PauseAnimation

; #FUNCTION# ;===============================================================================
;
; Name...........: _GIF_RefreshGIF
; Description ...: Refreshes GIF control
; Syntax.........: _GIF_RefreshGIF(ByRef $pGIF)
; Parameters ....: $pGIF - GIF specific value set by _GUICtrlCreateGIF function
; Return values .: Success - Returns 1. Refreshes GIF control
;                  Failure - Sets @error:
;                  |1 - GIF Control doesn't exist
;                  |2 - Couldn't get DC for the control
; Remark.........; Meant to be used with GUIRegisterMsg function
; Author ........: trancexx
;
;============================================================================================
Func _GIF_RefreshGIF(ByRef $pGIF)
	; Make structure at $pGIF address
	Local $tGIF = DllStructCreate("handle GIFThread;" & _
			"ptr CodeBuffer;" & _
			"hwnd ControlHandle;" & _
			"handle ImageList;" & _
			"bool ExitFlag;" & _
			"bool Transparent;" & _
			"dword CurrentFrame;", _
			$pGIF)
	; If there is no $pGIF error will occur. Great opportunity to return
	If @error Then Return SetError(1, 0, 0)
	; Is it animated at all
	If Not DllStructGetData($tGIF, "ImageList") Then Return 1
	; Get DC
	Local $hDC = _GIF_GetDC(DllStructGetData($tGIF, "ControlHandle"))
	If @error Then Return SetError(2, 0, 0)
	Local $iColorRef = -1
	If DllStructGetData($tGIF, "Transparent") Then $iColorRef = _GIF_GetUnderlyingColor(DllStructGetData($tGIF, "ControlHandle")) ; if transparent gif then set bk color to GUI's bk color
	_GIF_ImageList_DrawEx(DllStructGetData($tGIF, "ImageList"), DllStructGetData($tGIF, "CurrentFrame"), $hDC, 0, 0, 0, 0, $iColorRef, -1, 0)
	_GIF_ReleaseDC(0, $hDC)
	Return 1
EndFunc   ;==>_GIF_RefreshGIF

; #FUNCTION# ;===============================================================================
;
; Name...........: _GIF_ResumeAnimation
; Description ...: Resumes stopped animation of GIF control
; Syntax.........: _GIF_ResumeAnimation(ByRef $pGIF)
; Parameters ....: $pGIF - GIF specific value set by _GUICtrlCreateGIF function
; Return values .: Returns 1
; Author ........: trancexx
;
;============================================================================================
Func _GIF_ResumeAnimation(ByRef $pGIF)
	; Read $pGIF (short version - only GIFThread)
	Local $tGIF = DllStructCreate("handle GIFThread;", $pGIF)
	; GIFThread
	Local $hGIFThread = DllStructGetData($tGIF, "GIFThread")
	If Not $hGIFThread Then Return SetExtended(1, 1)
	If _GIF_ResumeThread($hGIFThread) = 2 Then _GIF_SuspendThread($hGIFThread) ; make sure not to increment non-suspended count of the thread
	Return 1
EndFunc   ;==>_GIF_ResumeAnimation

; #FUNCTION# ;===============================================================================
;
; Name...........: _GIF_ValidateGIF
; Description ...: Removes the GIF Control from the update region of the main window and in the same time upates the control
; Syntax.........: _GIF_ValidateGIF(ByRef $pGIF)
; Parameters ....: $pGIF - GIF specific value set by _GUICtrlCreateGIF function
; Return values .: Success - Returns 1
;                  Failure - Sets @error to 1
; Remark.........; Meant to be used with GUIRegisterMsg function
; Author ........: trancexx
;
;============================================================================================
Func _GIF_ValidateGIF(ByRef $pGIF)
	; Make structure at $pGIF address
	Local $tGIF = DllStructCreate("handle GIFThread;" & _
			"ptr CodeBuffer;" & _
			"hwnd ControlHandle;" & _
			"handle ImageList;" & _
			"bool ExitFlag;" & _
			"bool Transparent;" & _
			"dword CurrentFrame;" & _
			"dword NumberOfFrames;", _
			$pGIF)
	; If there is no $pGIF error will occur. Great opportunity to return
	If @error Then Return SetError(1, 0, 0)
	; Check to see if it's needed to proceed. If not then just return sucess
	If DllStructGetData($tGIF, "NumberOfFrames") < 2 Then Return 1
	; Is it animated at all
	If Not DllStructGetData($tGIF, "GIFThread") Then Return 1
    ; Redraw the control
	_GIF_RedrawWindow(DllStructGetData($tGIF, "ControlHandle"), 0, 0, 1280) ; RDW_UPDATENOW | RDW_FRAME
   _GIF_RefreshGIF($pGIF)
	Return 1
EndFunc   ;==>_GIF_ValidateGIF

; #FUNCTION# ;===============================================================================
;
; Name...........: _GUICtrlCreateGIF
; Description ...: Creates GIF control for the GUI
; Syntax.........: _GUICtrlCreateGIF($vGIF, $vAdditionalData, $iLeft, $iTop,  ByRef $pGIF)
; Parameters ....: $vGIF - filename of the GIF file to be loaded
;                  $vAdditionalData - resurce type, name and language (all separated by semicolon ';') if the GIF is stored as resource inside PE file
;                                     language is optional
;                  $iLeft - left side coordinate of the control
;                  $iTop - the top of the control
;                  $pGIF - variable that receives pointer to a memory space where all relevant GIF data is stored
; Return values .: Success - Returns controlID of the new control
;                          - Sets @error to 0
;                          - Sets @extended to 1 if GIF contains only one frame (no animation)
;                  Failure - Sets @error:
;                  |1 - if @extended is not set then failure is likely due to invalid input
;                       if @extended = 1 then Gdip failure occured
;                       0 (zero) is returned in both cases
;                  |2 - Needed memory allocation failed. Returns ControlID.
;                  |3 - Memory protection step failed. Returns ControlID.
;                  |4 - Some of the functions are not accessible for unknown reasons. Check @extended to determine which one. Returns ControlID.
;                  |5 - Couldn't create thread for the animation. Returns ControlID.
; Author ........: trancexx
;
;============================================================================================
Func _GUICtrlCreateGIF($vGIF, $vAdditionalData, $iLeft, $iTop, ByRef $pGIF)
	Local $vData
	; Process passed
	If IsBinary($vGIF) Then ; GIF binary data passed
		$vData = $vGIF
	Else
		If $vAdditionalData Then ; likely resource
			Local $aData = StringSplit($vAdditionalData, ";", 2)
			If UBound($aData) < 3 Then ReDim $aData[3]
			$vData = _GIF_ResourceGetAsRaw($vGIF, $aData[0], $aData[1], $aData[2])
			If @error Then
				$vData = $vGIF ; it's not resource, $vAdditionalData was wrong
			Else
				; RT_BITMAP is stored without BMP header. Add it:
				If $aData[0] = 2 Then $vData = _GIF_MakeBitmapFromRT_BITMAP($vData)
			EndIf
		Else
			$vData = $vGIF ; maybe $vGIF is the file name
		EndIf
	EndIf
	; Generate pGIF
	Local $iWidth, $iHeight, $hGIFBitmap
	$pGIF = _GIF_Create_pGIF($vData, $iWidth, $iHeight, $hGIFBitmap)
	If @error Then ; try some more opions
		Local $hGIFFile = FileOpen($vData)
		$vData = FileRead($hGIFFile)
		FileClose($hGIFFile)
		$pGIF = _GIF_Create_pGIF($vData, $iWidth, $iHeight, $hGIFBitmap)
		If @error Then ; finally maybe it's GIF content passed as string
			$pGIF = _GIF_Create_pGIF(Binary($vGIF), $iWidth, $iHeight, $hGIFBitmap)
			If @error Then Return SetError(1, @extended = True, 0) ; Nothing worked, Invalid input or Gdip failure.
		EndIf
	EndIf
	; Arrange/parse that space
	Local $tGIF = DllStructCreate("handle GIFThread;" & _
			"ptr CodeBuffer;" & _
			"hwnd ControlHandle;" & _
			"handle ImageList;" & _
			"bool ExitFlag;" & _
			"bool Transparent;" & _
			"dword CurrentFrame;" & _
			"dword NumberOfFrames;", _
			$pGIF)
	; Read NumberOfFrames to know the size of the structure
	Local $iFrameCount = DllStructGetData($tGIF, "NumberOfFrames")
	; Make it complete now:
	$tGIF = DllStructCreate("handle GIFThread;" & _
			"ptr CodeBuffer;" & _
			"hwnd ControlHandle;" & _
			"handle ImageList;" & _
			"bool ExitFlag;" & _
			"bool Transparent;" & _
			"dword CurrentFrame;" & _
			"dword NumberOfFrames;" & _
			"dword FrameDelay[" & $iFrameCount & "];", _
			$pGIF)
	; Make GIF Control
	Local $hGIFControl = GUICtrlCreatePic("", $iLeft, $iTop, $iWidth, $iHeight)
	; Render default image
	_GIF_DeleteObject(GUICtrlSendMsg($hGIFControl, 370, 0, $hGIFBitmap)) ; STM_SETIMAGE
	_GIF_DeleteObject($hGIFBitmap)
	; Set default resizing value for this control
	GUICtrlSetResizing($hGIFControl, 802)
	; Save Control handle
	DllStructSetData($tGIF, "ControlHandle", GUICtrlGetHandle($hGIFControl))
	; If there is just one frame there is no animation. Return
	If $iFrameCount = 1 Then Return SetExtended(1, $hGIFControl)
	; Allocate enough memory space for machine code
	Local $iSizeCodeBuffer = 181
	If @AutoItX64 Then $iSizeCodeBuffer = 274; x64 code is little longer
	Local $pCodeBuffer = _GIF_MemGlobalAlloc($iSizeCodeBuffer, 64) ; GPTR
	If @error Then Return SetError(2, 0, $hGIFControl) ; Couldn't allocate
	; Save that value
	DllStructSetData($tGIF, "CodeBuffer", $pCodeBuffer)
	; Set proper 'protection'
	_GIF_VirtualProtect($pCodeBuffer, $iSizeCodeBuffer, 64) ; MEM_EXECUTE_READWRITE
	If @error Then Return SetError(3, 0, $hGIFControl) ; Couldn't set MEM_EXECUTE_READWRITE
	Local $tCodeBuffer = DllStructCreate("byte[" & $iSizeCodeBuffer & "]", $pCodeBuffer)
	; Get functions addresses
	Local $pImageList_DrawEx = _GIF_GetAddress(_GIF_GetModuleHandle("comctl32.dll"), "ImageList_DrawEx")
	If @error Then Return SetError(4, 1, $hGIFControl) ; Couldn't get address of ImageList_DrawEx function
	Local $pSleep = _GIF_GetAddress(_GIF_GetModuleHandle("kernel32.dll"), "Sleep")
	If @error Then Return SetError(4, 2, $hGIFControl) ; Couldn't get address of Sleep function
	Local $pGetPixel = _GIF_GetAddress(_GIF_GetModuleHandle("gdi32.dll"), "GetPixel")
	If @error Then Return SetError(4, 3, $hGIFControl) ; Couldn't get address of GetPixel function
	Local $hUser32 = _GIF_GetModuleHandle("user32.dll")
	Local $pGetDC = _GIF_GetAddress($hUser32, "GetDC")
	If @error Then Return SetError(4, 4, $hGIFControl) ; Couldn't get address of GetDC function
	Local $pReleaseDC = _GIF_GetAddress($hUser32, "ReleaseDC")
	If @error Then Return SetError(4, 5, $hGIFControl) ; Couldn't get address of ReleaseDC function
	Local $pGetParent = _GIF_GetAddress($hUser32, "GetParent")
	If @error Then Return SetError(4, 6, $hGIFControl) ; Couldn't get address of GetParent function
	; Read from $tGIF
	Local $hImageList = DllStructGetData($tGIF, "ImageList")
	Local $hControl = DllStructGetData($tGIF, "ControlHandle")
	; Define style for ImageList_DrawEx function
	Local $iStyle = 1
	If DllStructGetData($tGIF, "Transparent") Then $iStyle = 0 ; correct value if needed
	; Write code
	If @AutoItX64 Then
		DllStructSetData($tCodeBuffer, 1, _
				"0x" & _
				"4883EC" & SwapEndian(88, 1) & _                                         ; sub rsp, 88d ;<- expand the stack
				"" & _ ; 10 START
				"4831F6" & _                                                             ; xor rsi, rsi ;<- rsi = 0
				"" & _ ; 20 MAIN LOOP
				"" & _ ; 25 SET CurrentFrame
				"8BC6" & _                                                               ; mov aax, asi ;<- esi is current frame index. Copy it to eax
				"A3" & SwapEndian(DllStructGetPtr($tGIF, "CurrentFrame"), 8) & _         ; mov $pCurrentFrame, eax ;<- from eax to structure
				"" & _ ; 30 GET CONTROL'S PARENT WINDOW (That's main GUI)
				"48B9" & SwapEndian($hControl, 8) & _                                    ; mov rcx,  Control handle
				"48B8" & SwapEndian($pGetParent, 8) & _                                  ; mov rax, GetParent ;<- set rax to address of GetParent function
				"FFD0" & _                                                               ; call rax ;<- calling rax (function)
				"" & _ ; 40 GET DC OF THE PARENT WINDOW
				"4889C1" & _                                                             ; mov rcx, rax ;<- window handle
				"48B8" & SwapEndian($pGetDC, 8) & _                                      ; mov rax, GetDC ;<- set rax to address of GetDC function
				"FFD0" & _                                                               ; call rax ;<- calling rax (function)
				"" & _ ; 50 SAVE DC (to release later)
				"4889C3" & _                                                             ; mov rbx, rax ;<- storing DC into rbx
				"" & _ ; 60 GET BACKGROUND COLOR (upper left pixel)
				"49C7C0" & SwapEndian($iTop, 4) & _                                      ; mov r8, $iTop ;<- Y coordinate
				"BA" & SwapEndian($iLeft, 4) & _                                         ; mov rdx, $iTop ;<- X coordinate
				"4889C1" & _                                                             ; mov rcx, rax ;<- DC handle (currently rax=rbx, so I could have set it rbx too with no difference)
				"48B8" & SwapEndian($pGetPixel, 8) & _                                   ; mov rax, GetPixel ;<- set rax to address of GetPixel function
				"FFD0" & _                                                               ; call rax ;<- calling rax (function)
				"89442438" & _                                                           ; mov [rsp+56], eax ;<- SET $iBkColRef parameter
				"" & _ ; 70 RELEASE DC
				"4889DA" & _                                                             ; mov rdx, rbx ;<- previously stored DC
				"48B9" & SwapEndian(0, 8) & _                                            ; mov rcx, NULL ;<- this is NULL as window handle
				"48B8" & SwapEndian($pReleaseDC, 8) & _                                  ; mov rax, ReleaseDC ;<- set rax to address of ReleaseDC function
				"FFD0" & _                                                               ; call rax ;<- calling rax (function)
				"B8" & SwapEndian($iStyle, 4) & _                                        ; mov eax, $iStyle
				"89442448" & _                                                           ; mov [rsp+72], eax ;<- SET $iStyle parameter
				"" & _ ; 80 GET CONTROL DC TO RENDER TO
				"48B9" & SwapEndian($hControl, 8) & _                                    ; mov rcx,  Control handle
				"48B8" & SwapEndian($pGetDC, 8) & _                                      ; mov rax, GetDC ;<- set rax to address of GetDC function
				"FFD0" & _                                                               ; call rax ;<- calling rax (function)
				"" & _ ; 90 SAVE DC (to release later)
				"4889C3" & _                                                             ; mov rbx, rax ;<- storing DC into rbx
				"4989C0" & _                                                             ; mov r8, rax ; <- SET $hDC parameter
				"49C7C1" & SwapEndian(0, 4) & _                                          ; mov r9, 0 ; <- SET $iXPos parameter
				"89F2" & _                                                               ; mov edx, esi ; <- SET $iImageIndex parameter
				"48B9" & SwapEndian($hImageList, 8) & _                                  ; mov rcx,  $hImageList handle ; <- SET $hImageList parameter
				"" & _ ; 100 DRAW FINALLY
				"48B8" & SwapEndian($pImageList_DrawEx, 8) & _                           ; mov rax, $pImageList_DrawEx ;<- set rax to address of ImageList_DrawEx function
				"FFD0" & _                                                               ; call rax ;<- calling rax (function)
				"" & _ ; 110 RELEASE DC
				"4889DA" & _                                                             ; mov rdx, rbx ;<- previously stored DC
				"48B9" & SwapEndian(0, 8) & _                                            ; mov rcx, NULL ;<- this is NULL as window handle
				"48B8" & SwapEndian($pReleaseDC, 8) & _                                  ; mov rax, ReleaseDC ;<- set rax to address of ReleaseDC function
				"FFD0" & _                                                               ; call rax ;<- calling rax (function)
				"" & _ ; 115 CHECK IF EXIT FLAG IS SET
				"A1" & SwapEndian(DllStructGetPtr($tGIF, "ExitFlag"), 8) & _             ; mov eax, Address of ExitFlag
				"85C0" & _                                                               ; test eax, eax
				"75" & SwapEndian(46, 1) & _                                             ; jne 46d ;<- if set then jump forward 46 bytes; (to 160)
				"" & _ ; 120 SLEEP FOR GIF TIME DELAY VALUE
				"48BB" & SwapEndian(DllStructGetPtr($tGIF, "FrameDelay"), 8) & _         ; mov rbx, Address of FrameDelay
				"488B0CB3" & _                                                           ; mov rcx, qword[rbx+4*rsi] ;<- move pointer for every new frame to exact position
				"48B8" & SwapEndian($pSleep, 8) & _                                      ; mov rax, Sleep ;<- set rax to address of Sleep function
				"FFD0" & _                                                               ; call rax ;<- calling rax (function)
				"" & _ ; 130 INCREMENTATING 'POSITION INDEX'
				"FFC6" & _                                                               ; inc esi ;<- increment esi by value of 1
				"" & _ ; 140 CHECK 'POSITION'
				"81FE" & SwapEndian($iFrameCount, 4) & _                                 ; cmp esi, $iFrameCount ;<- compare esi with $iFrameCount
				"" & _ ; 150 DEAL WITH DIFFERENT CASES
				"74" & SwapEndian(5, 1) & _                                              ; je 5d ;<- if equal jump forward five bytes
				"E9" & SwapEndian(-254, 4) & _                                           ; jump -241d ;<- jump back 254 bytes (to 20)
				"E9" & SwapEndian(-262, 4) & _                                           ; jump -262d ;<- jump back 262 bytes (to 10)
				"" & _ ; 160 SET EXIT CODE TO 0 BEFORE THE END
				"4831C0" & _                                                             ; xor rax, rax ;<- rax = 0
				"4883C4" & SwapEndian(88, 1) & _                                         ; add rsp, 88d ;<- shrink stack (88 bytes)
				"C3" _                                                                   ; ret ;<- Return.
				)
	Else
		DllStructSetData($tCodeBuffer, 1, _
				"0x" & _
				"" & _ ; 10 START
				"33F6" & _                                                               ; xor esi, esi ;<- esi = 0
				"" & _ ; 20 MAIN LOOP
				"" & _ ; 25 SET CurrentFrame
				"8BC6" & _                                                               ; mov eax, esi ;<- esi is current frame index. Copy it to eax
				"A3" & SwapEndian(DllStructGetPtr($tGIF, "CurrentFrame"), 4) & _         ; mov $pCurrentFrame, eax ;<- from eax to structure
				"68" & SwapEndian($iStyle, 4) & _                                        ; push Style
				"68" & SwapEndian(-1, 4) & _                                             ; push FgColRef
				"" & _ ; 30 GET CONTROL'S PARENT WINDOW (That's main GUI)
				"68" & SwapEndian($hControl, 4) & _                                      ; push Control handle
				"B8" & SwapEndian($pGetParent, 4) & _                                    ; mov eax, GetParent ;<- set eax to address of GetParent function
				"FFD0" & _                                                               ; call eax ;<- calling eax (function)
				"" & _ ; 40 GET DC OF THE PARENT WINDOW
				"50" & _                                                                 ; push eax ;<- push window handle
				"B8" & SwapEndian($pGetDC, 4) & _                                        ; mov eax, GetDC ;<- set eax to address of GetDC function
				"FFD0" & _                                                               ; call eax ;<- calling eax (function)
				"" & _ ; 50 SAVE DC (to release later)
				"8BD8" & _                                                               ; mov ebx, eax ;<- storing DC into ebx
				"68" & SwapEndian($iTop, 4) & _                                          ; push Y coordinate
				"68" & SwapEndian($iLeft, 4) & _                                         ; push X coordinate
				"" & _ ; 60 GET BACKGROUND COLOR (upper left pixel)
				"53" & _                                                                 ; push ebx ;<- DC handle (currently eax=ebx, so I could have pushed eax too with no difference)
				"B8" & SwapEndian($pGetPixel, 4) & _                                     ; mov eax, GetPixel ;<- set eax to address of GetPixel function
				"FFD0" & _                                                               ; call eax ;<- calling eax (function)
				"50" & _                                                                 ; push eax ; push retrieved background color on the stack
				"" & _ ; 70 RELEASE DC
				"53" & _                                                                 ; push ebx ;<- push previously stored DC
				"68" & SwapEndian(0, 4) & _                                              ; push 0 ;<- this is NULL as window handle
				"B8" & SwapEndian($pReleaseDC, 4) & _                                    ; mov eax, ReleaseDC ;<- set eax to address of ReleaseDC function
				"FFD0" & _                                                               ; call eax ;<- calling eax (function)
				"68" & SwapEndian(0, 4) & _                                              ; push Height
				"68" & SwapEndian(0, 4) & _                                              ; push Width
				"68" & SwapEndian(0, 4) & _                                              ; push YPos
				"68" & SwapEndian(0, 4) & _                                              ; push XPos
				"" & _ ; 80 GET CONTROL DC TO RENDER TO
				"68" & SwapEndian($hControl, 4) & _                                      ; push Control handle
				"B8" & SwapEndian($pGetDC, 4) & _                                        ; mov eax, GetDC ;<- set eax to address of GetDC function
				"FFD0" & _                                                               ; call eax ;<- calling eax (function)
				"" & _ ; 90 SAVE DC (to release later)
				"8BD8" & _                                                               ; mov ebx, eax ; storing DC into ebx
				"50" & _                                                                 ; push eax ;<- push DC (again eax=ebx)
				"56" & _                                                                 ; push esi ;<- this is ImageList's index of the frame to render
				"68" & SwapEndian($hImageList, 4) & _                                    ; push ImageList
				"" & _ ; 100 DRAW FINALLY
				"B8" & SwapEndian($pImageList_DrawEx, 4) & _                             ; mov eax, ImageList_DrawEx ;<- set eax to address of ImageList_DrawEx function
				"FFD0" & _                                                               ; call eax ;<- calling eax (function)
				"" & _ ; 110 RELEASE DC
				"53" & _                                                                 ; push ebx ;<- DC is found in ebx
				"68" & SwapEndian(0, 4) & _                                              ; push 0 ;<- this is NULL as window handle
				"B8" & SwapEndian($pReleaseDC, 4) & _                                    ; mov eax, ReleaseDC ;<- set eax to address of ReleaseDC function
				"FFD0" & _                                                               ; call eax ;<- calling eax (function)
				"" & _ ; 115 CHECK IF EXIT FLAG IS SET
				"A1" & SwapEndian(DllStructGetPtr($tGIF, "ExitFlag"), 4) & _             ; mov eax, Address of ExitFlag
				"85C0" & _                                                               ; test eax, eax
				"75" & SwapEndian(35, 1) & _                                             ; jne 35d ;<- if set then jump forward 35 bytes; (to 160)
				"" & _ ; 120 SLEEP FOR GIF TIME DELAY VALUE
				"BB" & SwapEndian(DllStructGetPtr($tGIF, "FrameDelay"), 4) & _           ; mov ebx, Address of FrameDelay
				"8B0CB3" & _                                                             ; mov ecx, dword[ebx+4*esi] ;<- move pointer for every new frame to exact position
				"51" & _                                                                 ; push ecx ;<- push TimeDelay value
				"B8" & SwapEndian($pSleep, 4) & _                                        ; mov eax, Sleep ;<- set eax to address of Sleep function
				"FFD0" & _                                                               ; call eax ;<- calling eax (function)
				"" & _ ; 130 INCREMENTATING 'POSITION INDEX'
				"46" & _                                                                 ; inc esi ;<- increment esi by value of 1
				"" & _ ; 140 CHECK 'POSITION'
				"81FE" & SwapEndian($iFrameCount, 4) & _                                 ; cmp esi, $iFrameCount ;<- compare esi with $iFrameCount
				"" & _ ; 150 DEAL WITH DIFFERENT CASES
				"74" & SwapEndian(5, 1) & _                                              ; je 5d ;<- if equal jump forward five bytes
				"E9" & SwapEndian(-171, 4) & _                                           ; jump -171d ;<- jump back 171 bytes (to 20)
				"E9" & SwapEndian(-178, 4) & _                                           ; jump -178d ;<- jump back 178 bytes (to 10)
				"" & _ ; 160 SET EXIT CODE TO 0 BEFORE THE END
				"33C0" & _                                                               ; xor eax, eax ;<- eax = 0
				"C3" _                                                                   ; ret ;<- Return.
				)
	EndIf
	; Create thread in which to run the code
	Local $hThread = _GIF_CreateThread($pCodeBuffer)
	If @error Then Return SetError(5, 0, $hGIFControl) ; Couldn't create thread
	; Save that handle
	DllStructSetData($tGIF, "GIFThread", $hThread)
	; Redraw parent window
	_GIF_InvalidateRect(_GIF_GetParent($hControl))
	; All went well. Return Control Identifier
	Return $hGIFControl
EndFunc   ;==>_GUICtrlCreateGIF

; #INTERNAL FUNCTIONS DOWN BELOW# ;==========================================================
Func _GIF_GetCtrlHandle(ByRef $pGIF)
	; Read $pGIF (shorter version - only ControlHandle really matters)
	Local $tGIF = DllStructCreate("handle GIFThread;" & _
			"ptr CodeBuffer;" & _
			"hwnd ControlHandle;", _
			$pGIF)
	Return DllStructGetData($tGIF, "ControlHandle")
EndFunc   ;==>_GIF_GetCtrlHandle

Func _GIF_CloseHandle($hHandle)
	Local $aCall = DllCall($hGIFDLL__KERNEL32, "bool", "CloseHandle", "handle", $hHandle)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_GIF_CloseHandle

Func _GIF_WaitForSingleObject($hHandle, $iMiliSec = -1)
	Local $aCall = DllCall($hGIFDLL__KERNEL32, "dword", "WaitForSingleObject", "handle", $hHandle, "dword", $iMiliSec)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_GIF_WaitForSingleObject

Func _GIF_CreateThread($pAddress)
	Local $aCall = DllCall($hGIFDLL__KERNEL32, "handle", "CreateThread", _
			"ptr", 0, _
			"dword_ptr", 0, _
			"ptr", $pAddress, _
			"ptr", 0, _
			"dword", 0, _
			"dword*", 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_GIF_CreateThread

Func _GIF_SuspendThread($hTread)
	Local $aCall = DllCall($hGIFDLL__KERNEL32, "dword", "SuspendThread", "handle", $hTread)
	If @error Or $aCall[0] = -1 Then Return SetError(1, 0, -1)
	Return $aCall[0]
EndFunc   ;==>_GIF_SuspendThread

Func _GIF_ResumeThread($hTread)
	Local $aCall = DllCall($hGIFDLL__KERNEL32, "dword", "ResumeThread", "handle", $hTread)
	If @error Or $aCall[0] = -1 Then Return SetError(1, 0, -1)
	Return $aCall[0]
EndFunc   ;==>_GIF_ResumeThread

Func _GIF_VirtualProtect($pAddress, $iSize, $iProtection)
	Local $aCall = DllCall($hGIFDLL__KERNEL32, "bool", "VirtualProtect", "ptr", $pAddress, "dword_ptr", $iSize, "dword", $iProtection, "dword*", 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_GIF_VirtualProtect

Func _GIF_GetAddress($hModule, $vFuncName)
	Local $sType = "str"
	If IsNumber($vFuncName) Then $sType = "int" ; if ordinal value passed
	Local $aCall = DllCall($hGIFDLL__KERNEL32, "ptr", "GetProcAddress", "handle", $hModule, $sType, $vFuncName)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_GIF_GetAddress

Func _GIF_GetModuleHandle($vModule = 0)
	Local $sType = "wstr"
	If Not $vModule Then $sType = "ptr"
	Local $aCall = DllCall($hGIFDLL__KERNEL32, "ptr", "GetModuleHandleW", $sType, $vModule)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_GIF_GetModuleHandle

Func _GIF_GetBkColor($hWnd)
	Local $hDC = _GIF_GetDC($hWnd)
	If @error Then Return SetError(1, 0, -1)
	Local $aCall = DllCall($hGIFDLL__GDI32, "dword", "GetBkColor", "handle", $hDC)
	If @error Or $aCall[0] = -1 Then
		_GIF_ReleaseDC($hWnd, $hDC)
		Return SetError(2, 0, -1)
	EndIf
	_GIF_ReleaseDC($hWnd, $hDC)
	Return $aCall[0]
EndFunc   ;==>_GIF_GetBkColor

Func _GIF_GetDC($hWnd)
	Local $aCall = DllCall($hGIFDLL__USER32, "handle", "GetDC", "hwnd", $hWnd)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_GIF_GetDC

Func _GIF_ReleaseDC($hWnd, $hDC)
	Local $aCall = DllCall($hGIFDLL__USER32, "int", "ReleaseDC", "hwnd", $hWnd, "handle", $hDC)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_GIF_ReleaseDC

Func _GIF_GetDlgCtrlID($hWnd)
	Local $aCall = DllCall($hGIFDLL__USER32, "int", "GetDlgCtrlID", "hwnd", $hWnd)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_GIF_GetDlgCtrlID

Func _GIF_InvalidateRect($hWnd, $pRect = 0, $fErase = True)
	Local $aCall = DllCall($hGIFDLL__USER32, "bool", "InvalidateRect", _
			"hwnd", $hWnd, _
			"ptr", $pRect, _
			"bool", $fErase)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_GIF_InvalidateRect

Func _GIF_ValidateRect($hWnd, $pRect = 0)
	Local $aCall = DllCall($hGIFDLL__USER32, "bool", "ValidateRect", "hwnd", $hWnd, "ptr", $pRect)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_GIF_ValidateRect

Func _GIF_RedrawWindow($hWnd, $pRect, $hRegion, $iFlags)
	Local $aCall = DllCall($hGIFDLL__USER32, "bool", "RedrawWindow", "hwnd", $hWnd, "ptr", $pRect, "handle", $hRegion, "dword", $iFlags)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_GIF_RedrawWindow

Func _GIF_GetUnderlyingColor($hWnd)
	Local $hParent = _GIF_GetParent($hWnd)
	If @error Then Return SetError(1, 0, -1)
	Local $iColor = _GIF_GetBkColor($hParent)
	Return SetError(@error, 0, $iColor)
EndFunc   ;==>_GIF_GetUnderlyingColor

Func _GIF_GetParent($hWnd)
	Local $aCall = DllCall($hGIFDLL__USER32, "hwnd", "GetParent", "hwnd", $hWnd)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_GIF_GetParent

Func _GIF_Create_pGIF($bBinary, ByRef $iWidth, ByRef $iHeight, ByRef $hGIFBitmap)
	Local $hGDIP ; Gdip engine
	Local $hMemGlobal ; Memory
	; Bitmap object
	Local $pBitmap
	If IsBinary($bBinary) Then
		$pBitmap = _GIF_CreateBitmapFromBinaryImage($hGDIP, $hMemGlobal, $bBinary, $iWidth, $iHeight)
	Else
		$pBitmap = _GIF_CreateBitmapFromFile($hGDIP, $bBinary, $iWidth, $iHeight)
	EndIf
	If @error Then
		Local $iErr = @error
		_GIF_FreeGdipAndMem($pBitmap, $hGDIP, $hMemGlobal)
		Return SetError(1, $iErr, 0)
	EndIf
	; Get number of frame dimensions
	Local $iFrameDimensionsCount = _GIF_GdipImageGetFrameDimensionsCount($pBitmap)
	If @error Then
		_GIF_FreeGdipAndMem($pBitmap, $hGDIP, $hMemGlobal)
		Return SetError(2, 0, 0)
	EndIf
	; GUID
	Local $tGUID = DllStructCreate("dword;word;word;byte[8]")
	Local $pGUID = DllStructGetPtr($tGUID)
	; Get the identifiers for the frame dimensions
	_GIF_GdipImageGetFrameDimensionsList($pBitmap, $pGUID, $iFrameDimensionsCount)
	If @error Then
		_GIF_FreeGdipAndMem($pBitmap, $hGDIP, $hMemGlobal)
		Return SetError(3, 0, 0)
	EndIf
	; Number of frames
	Local $iFrameCount = _GIF_GdipImageGetFrameCount($pBitmap, $pGUID)
	If @error Then
		_GIF_FreeGdipAndMem($pBitmap, $hGDIP, $hMemGlobal)
		Return SetError(4, 0, 0)
	EndIf
	; Allocate needed global memory
	Local $pGIF = _GIF_MemGlobalAlloc(4 * (8 + 4 * @AutoItX64 + $iFrameCount), 64) ; GPTR
	If @error Then
		_GIF_FreeGdipAndMem($pBitmap, $hGDIP, $hMemGlobal)
		Return SetError(3, 0, 0)
	EndIf
	Local $tGIF = DllStructCreate("handle GIFThread;" & _
			"ptr CodeBuffer;" & _
			"hwnd ControlHandle;" & _
			"handle ImageList;" & _
			"bool ExitFlag;" & _
			"bool Transparent;" & _
			"dword CurrentFrame;" & _
			"dword NumberOfFrames;" & _
			"dword FrameDelay[" & $iFrameCount & "];", _
			$pGIF)
	DllStructSetData($tGIF, "GIFThread", 0)
	DllStructSetData($tGIF, "ControlHandle", 0)
	DllStructSetData($tGIF, "ExitFlag", 0)
	DllStructSetData($tGIF, "CurrentFrame", 0)
	; Set number of frames
	DllStructSetData($tGIF, "NumberOfFrames", $iFrameCount)
	; If frame count is 1 then free what needs to be freed and return $pGIF. This requires no animation.
	If $iFrameCount = 1 Then
		$hGIFBitmap = _GIF_GdipCreateHBITMAPFromBitmap($pBitmap)
		_GIF_FreeGdipAndMem($pBitmap, $hGDIP, $hMemGlobal)
		Return $pGIF
	EndIf
	; Make ImageList
	Local $hImageList = _GIF_ImageList_Create($iWidth, $iHeight, 32, $iFrameCount) ; ILC_COLOR32
	If @error Then
		_GIF_FreeGdipAndMem($pBitmap, $hGDIP, $hMemGlobal, $pGIF)
		Return SetError(4, 0, 0)
	EndIf
	; Set imagelist
	DllStructSetData($tGIF, "ImageList", $hImageList)
	Local $hBitmap
	For $j = 0 To $iFrameCount - 1 ; for all frames
		; Select the frame
		_GIF_GdipImageSelectActiveFrame($pBitmap, $pGUID, $j)
		If @error Then ContinueLoop
		; Fill the array with HBITMAPs
		$hBitmap = _GIF_GdipCreateHBITMAPFromBitmap($pBitmap)
		; Add it to the ImageList
		_GIF_ImageList_Add($hImageList, $hBitmap)
		If $j = 0 Then ; Export "static" GIF (first frame)
			$hGIFBitmap = $hBitmap
		Else ; Delete it
			_GIF_DeleteObject($hBitmap)
		EndIf
	Next
	; Get size of PropertyTagFrameDelay
	Local $iPropertyItemSize = _GIF_GdipGetPropertyItemSize($pBitmap, 0x5100) ; PropertyTagFrameDelay
	If @error Then
		_GIF_FreeGdipAndMem($pBitmap, $hGDIP, $hMemGlobal, $pGIF)
		Return SetError(5, 0, 0)
	EndIf
	; Raw structure for the call
	Local $tRawPropItem = DllStructCreate("byte[" & $iPropertyItemSize & "]")
	; Fill the structure
	_GIF_GdipGetPropertyItem($pBitmap, 0x5100, $iPropertyItemSize, DllStructGetPtr($tRawPropItem)) ; PropertyTagFrameDelay
	If @error Then
		_GIF_FreeGdipAndMem($pBitmap, $hGDIP, $hMemGlobal, $pGIF)
		Return SetError(6, 0, 0)
	EndIf
	; Formatted structure in place of the raw
	Local $tPropItem = DllStructCreate("int Id;" & _
			"dword Length;" & _
			"word Type;" & _
			"ptr Value", _
			DllStructGetPtr($tRawPropItem))
	; Read the "Length"
	Local $iSize = DllStructGetData($tPropItem, "Length") / 4 ; 'Delay Time' is dword type. 4 is size of dword.
	; Make new structure for the data
	Local $tPropertyData = DllStructCreate("dword[" & $iSize & "]", DllStructGetData($tPropItem, "Value"))
	; Read and fill array
	Local $iDelay
	For $j = 1 To $iFrameCount ; loop through all frames
		$iDelay = DllStructGetData($tPropertyData, 1, $j) * 10 ; 1 = 10 msec
		; Corrections
		If Not $iDelay Then $iDelay = 130 ; interpreting 0 as 130 ms
		If $iDelay < 50 Then $iDelay = 50 ; will slow it down to prevent more extensive cpu usage
		; Set delay
		DllStructSetData($tGIF, "FrameDelay", $iDelay, $j)
	Next
	; Determining trancparency
	Local $fTransparent = True ; preset
	; Get pixel color
	Local $iPixelColor = _GIF_GdipBitmapGetPixel($pBitmap, 0, 0) ; upper left pixel
	; Color is ARGB. If A is set then it's not transparent
	If BitShift($iPixelColor, 24) Then $fTransparent = False
	; Set transparency
	DllStructSetData($tGIF, "Transparent", $fTransparent)
	; Free
	_GIF_FreeGdipAndMem($pBitmap, $hGDIP, $hMemGlobal)
	; Return sucess (pointer to allocated memory)
	Return $pGIF
EndFunc   ;==>_GIF_Create_pGIF

Func _GIF_GlobalAlloc($iSize, $iFlag)
	Local $aCall = DllCall($hGIFDLL__KERNEL32, "ptr", "GlobalAlloc", "dword", $iFlag, "dword_ptr", $iSize)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_GIF_GlobalAlloc

Func _GIF_CreateStreamOnHGlobal($hGlobal, $iFlag = 1)
	Local $aCall = DllCall($hGIFDLL__OLE32, "long", "CreateStreamOnHGlobal", "handle", $hGlobal, "int", $iFlag, "ptr*", 0)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[3]
EndFunc   ;==>_GIF_CreateStreamOnHGlobal

Func _GIF_DeleteObject($hObject)
	Local $aCall = DllCall($hGIFDLL__GDI32, "bool", "DeleteObject", "handle", $hObject)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_GIF_DeleteObject

Func _GIF_ImageList_GetIconSize($hImageList)
	Local $aOut[2] = [0, 0]
	Local $aCall = DllCall($hGIFDLL__COMCTL32, "bool", "ImageList_GetIconSize", "handle", $hImageList, "int*", 0, "int*", 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, $aOut)
	$aOut[0] = $aCall[2]
	$aOut[1] = $aCall[3]
	Return $aOut
EndFunc   ;==>_GIF_ImageList_GetIconSize

Func _GIF_ImageList_Create($iWidth, $iHeight, $iFlag, $iInitial, $iGrow = 0)
	Local $aCall = DllCall($hGIFDLL__COMCTL32, "handle", "ImageList_Create", _
			"int", $iWidth, _
			"int", $iHeight, _
			"dword", $iFlag, _
			"int", $iInitial, _
			"int", $iGrow)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_GIF_ImageList_Create

Func _GIF_ImageList_Add($hImageList, $hBitmap)
	Local $aCall = DllCall($hGIFDLL__COMCTL32, "int", "ImageList_Add", _
			"handle", $hImageList, _
			"handle", $hBitmap, _
			"handle", 0)
	If @error Or $aCall[0] = -1 Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_GIF_ImageList_Add

Func _GIF_ImageList_Destroy($hImageList)
	Local $aCall = DllCall($hGIFDLL__COMCTL32, "bool", "ImageList_Destroy", "handle", $hImageList)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_GIF_ImageList_Destroy

Func _GIF_ImageList_DrawEx($hImageList, $iImageIndex, $hDC, $iXPos = 0, $iYPos = 0, $iWidth = 0, $iHeight = 0, $iBkColRef = -1, $iFgColRef = -1, $iStyle = 0)
	Local $aCall = DllCall($hGIFDLL__COMCTL32, "bool", "ImageList_DrawEx", _
			"handle", $hImageList, _
			"int", $iImageIndex, _
			"handle", $hDC, _
			"int", $iXPos, _
			"int", $iYPos, _
			"int", $iWidth, _
			"int", $iHeight, _
			"dword", $iBkColRef, _
			"dword", $iFgColRef, _
			"dword", $iStyle)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_GIF_ImageList_DrawEx

Func _GIF_CreateBitmapFromFile(ByRef $hGDIP, $sFile, ByRef $iWidth, ByRef $iHeight)
	; Initialize Gdip
	$hGDIP = _GIF_GdiplusStartup()
	If @error Then Return SetError(1, 0, 0)
	; Create bitmap object out of the file
	Local $pBitmap = _GIF_GdipLoadImageFromFile($sFile)
	If @error Then
		_GIF_GdiplusShutdown($hGDIP)
		Return SetError(2, 0, 0)
	EndIf
	; Get dimension
	_GIF_GdipGetImageDimension($pBitmap, $iWidth, $iHeight)
	If @error Then
		_GIF_FreeGdipAndMem($pBitmap, $hGDIP)
		Return SetError(3, 0, 0)
	EndIf
	Return $pBitmap
EndFunc   ;==>_GIF_CreateBitmapFromFile

Func _GIF_CreateBitmapFromBinaryImage(ByRef $hGDIP, ByRef $hMemGlobal, $bBinary, ByRef $iWidth, ByRef $iHeight)
	; Determine the size of binary data
	Local $iSize = BinaryLen($bBinary)
	; Allocate global moveable memory in requred size
	$hMemGlobal = _GIF_MemGlobalAlloc($iSize, 2); GMEM_MOVEABLE
	If @error Then Return SetError(1, 0, 0)
	; Get pointer to it
	Local $pMemory = _GIF_MemGlobalLock($hMemGlobal)
	If @error Then
		_GIF_MemGlobalFree($hMemGlobal)
		Return SetError(2, 0, 0)
	EndIf
	; Make structure at that address
	Local $tBinary = DllStructCreate("byte[" & $iSize & "]", $pMemory)
	; Fill it
	DllStructSetData($tBinary, 1, $bBinary)
	; Create stream
	Local $pStream = _GIF_CreateStreamOnHGlobal($pMemory)
	If @error Then
		_GIF_MemGlobalFree($hMemGlobal)
		Return SetError(3, 0, 0)
	EndIf
	; Unlock memory (almost irrelevant)
	_GIF_MemGlobalUnlock($pMemory)
	; Initialize Gdip
	$hGDIP = _GIF_GdiplusStartup()
	If @error Then
		_GIF_MemGlobalFree($hMemGlobal)
		Return SetError(4, 0, 0)
	EndIf
	; Create bitmap object out of the stream
	Local $pBitmap = _GIF_GdipCreateBitmapFromStream($pStream)
	If @error Then
		_GIF_GdiplusShutdown($hGDIP)
		_GIF_MemGlobalFree($hMemGlobal)
		Return SetError(5, 0, 0)
	EndIf
	; Get dimension
	_GIF_GdipGetImageDimension($pBitmap, $iWidth, $iHeight)
	If @error Then
		_GIF_FreeGdipAndMem($pBitmap, $hGDIP, $hMemGlobal)
		Return SetError(6, 0, 0)
	EndIf
	Return $pBitmap
EndFunc   ;==>_GIF_CreateBitmapFromBinaryImage

Func _GIF_GdiplusStartup()
	Local $tGdiplusStartupInput = DllStructCreate("dword GdiplusVersion;" & _
			"ptr DebugEventCallback;" & _
			"int SuppressBackgroundThread;" & _
			"int SuppressExternalCodecs")
	DllStructSetData($tGdiplusStartupInput, "GdiplusVersion", 1)
	Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdiplusStartup", "dword_ptr*", 0, "ptr", DllStructGetPtr($tGdiplusStartupInput), "ptr", 0)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[1]
EndFunc   ;==>_GIF_GdiplusStartup

Func _GIF_GdiplusShutdown($hGDIP)
	DllCall($hGIFDLL__GDIPLUS, "none", "GdiplusShutdown", "dword_ptr", $hGDIP)
EndFunc   ;==>_GIF_GdiplusShutdown

Func _GIF_GdipDisposeImage($hImage)
	Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipDisposeImage", "handle", $hImage)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_GIF_GdipDisposeImage

Func _GIF_GdipCreateHBITMAPFromBitmap($pBitmap, $iARGB = 0xFF000000)
	Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipCreateHBITMAPFromBitmap", "ptr", $pBitmap, "handle*", 0, "dword", $iARGB)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[2]
EndFunc   ;==>_GIF_GdipCreateHBITMAPFromBitmap

Func _GIF_GdipGetImageDimension($pBitmap, ByRef $iWidth, ByRef $iHeight)
	Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipGetImageDimension", "ptr", $pBitmap, "float*", 0, "float*", 0)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	$iWidth = $aCall[2]
	$iHeight = $aCall[3]
EndFunc   ;==>_GIF_GdipGetImageDimension

Func _GIF_GdipCreateBitmapFromStream($pStream)
	Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipCreateBitmapFromStream", "ptr", $pStream, "ptr*", 0)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[2]
EndFunc   ;==>_GIF_GdipCreateBitmapFromStream

Func _GIF_GdipImageGetFrameDimensionsCount($pBitmap)
	Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipImageGetFrameDimensionsCount", "ptr", $pBitmap, "dword*", 0)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[2]
EndFunc   ;==>_GIF_GdipImageGetFrameDimensionsCount

Func _GIF_GdipImageGetFrameDimensionsList($pBitmap, $pGUID, $iFrameDimensionsCount)
	Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipImageGetFrameDimensionsList", _
			"ptr", $pBitmap, _
			"ptr", $pGUID, _
			"dword", $iFrameDimensionsCount)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_GIF_GdipImageGetFrameDimensionsList

Func _GIF_GdipImageGetFrameCount($pBitmap, $pGUID)
	Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipImageGetFrameCount", _
			"ptr", $pBitmap, _
			"ptr", $pGUID, _
			"dword*", 0)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[3]
EndFunc   ;==>_GIF_GdipImageGetFrameCount

Func _GIF_GdipImageSelectActiveFrame($pBitmap, $pGUID, $iFrameIndex)
	Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipImageSelectActiveFrame", _
			"ptr", $pBitmap, _
			"ptr", $pGUID, _
			"dword", $iFrameIndex)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_GIF_GdipImageSelectActiveFrame

Func _GIF_GdipGetPropertyItemSize($pBitmap, $iPropID)
	Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipGetPropertyItemSize", _
			"ptr", $pBitmap, _
			"ptr", $iPropID, _
			"dword*", 0)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[3]
EndFunc   ;==>_GIF_GdipGetPropertyItemSize

Func _GIF_GdipGetPropertyItem($pBitmap, $iPropID, $iSize, $pBuffer)
	Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipGetPropertyItem", _
			"ptr", $pBitmap, _
			"dword", $iPropID, _
			"dword", $iSize, _
			"ptr", $pBuffer)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_GIF_GdipGetPropertyItem

Func _GIF_GdipBitmapGetPixel($pBitmap, $iX, $iY)
	Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipBitmapGetPixel", _
			"ptr", $pBitmap, _
			"int", $iX, _
			"int", $iY, _
			"dword*", 0)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[4]
EndFunc   ;==>_GIF_GdipBitmapGetPixel

Func _GIF_GdipCreateHICONFromBitmap($pBitmap)
	Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipCreateHICONFromBitmap", "ptr", $pBitmap, "handle*", 0)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[2]
EndFunc   ;==>_GIF_GdipCreateHICONFromBitmap

Func _GIF_GdipLoadImageFromFile($sFile)
	Local $aCall = DllCall($hGIFDLL__GDIPLUS, "dword", "GdipLoadImageFromFile", "wstr", $sFile, "ptr*", 0)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[2]
EndFunc   ;==>_GIF_GdipLoadImageFromFile

Func _GIF_FreeGdipAndMem($pBitmap = 0, $hGDIP = 0, $hMem = 0, $pGIF = 0)
	If $pBitmap Then _GIF_GdipDisposeImage($pBitmap)
	If $hGDIP Then _GIF_GdiplusShutdown($hGDIP)
	If $hMem Then _GIF_MemGlobalFree($hMem)
	If $pGIF Then _GIF_MemGlobalFree($pGIF)
EndFunc   ;==>_GIF_FreeGdipAndMem

Func _GIF_MemGlobalAlloc($iSize, $iFlag)
	Local $aCall = DllCall($hGIFDLL__KERNEL32, "handle", "GlobalAlloc", "dword", $iFlag, "dword_ptr", $iSize)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_GIF_MemGlobalAlloc

Func _GIF_MemGlobalFree($hMem)
	Local $aCall = DllCall($hGIFDLL__KERNEL32, "ptr", "GlobalFree", "handle", $hMem)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_GIF_MemGlobalFree

Func _GIF_MemGlobalLock($hMem)
	Local $aCall = DllCall($hGIFDLL__KERNEL32, "ptr", "GlobalLock", "handle", $hMem)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_GIF_MemGlobalLock

Func _GIF_MemGlobalUnlock($hMem)
	Local $aCall = DllCall($hGIFDLL__KERNEL32, "bool", "GlobalUnlock", "handle", $hMem)
	If @error Then Return SetError(1, 0, 0)
	If $aCall[0] Or _GIF_GetLastError() Then Return $aCall[0]
	Return 1
EndFunc   ;==>_GIF_MemGlobalUnlock

Func _GIF_GetLastError()
	Local $aCall = DllCall($hGIFDLL__KERNEL32, "dword", "GetLastError")
	If @error Then Return SetError(1, 0, -1)
	Return $aCall[0]
EndFunc   ;==>_GIF_GetLastError

Func _GIF_FindResourceEx($hModule, $vResType, $vResName, $iResLang = 0)
	Local $sTypeType = "wstr"
	If $vResType == Number($vResType) Then $sTypeType = "int"
	Local $sNameType = "wstr"
	If $vResName == Number($vResName) Then $sNameType = "int"
	Local $aCall = DllCall($hGIFDLL__KERNEL32, "handle", "FindResourceExW", _
			"handle", $hModule, _
			$sTypeType, $vResType, _
			$sNameType, $vResName, _
			"int", $iResLang)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_GIF_FindResourceEx

Func _GIF_SizeofResource($hModule, $hResource)
	Local $aCall = DllCall($hGIFDLL__KERNEL32, "int", "SizeofResource", "handle", $hModule, "handle", $hResource)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_GIF_SizeofResource

Func _GIF_LoadResource($hModule, $hResource)
	Local $aCall = DllCall($hGIFDLL__KERNEL32, "handle", "LoadResource", "handle", $hModule, "handle", $hResource)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_GIF_LoadResource

Func _GIF_LockResource($hResource)
	Local $aCall = DllCall($hGIFDLL__KERNEL32, "ptr", "LockResource", "handle", $hResource)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_GIF_LockResource

Func _GIF_LoadLibraryEx($sModule, $iFlag = 0)
	Local $aCall = DllCall($hGIFDLL__KERNEL32, "handle", "LoadLibraryExW", "wstr", $sModule, "handle", 0, "dword", $iFlag)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_GIF_LoadLibraryEx

Func _GIF_FreeLibrary($hModule)
	Local $aCall = DllCall($hGIFDLL__KERNEL32, "bool", "FreeLibrary", "handle", $hModule)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>_GIF_FreeLibrary

Func _GIF_ResourceGetAsRaw($sModule, $vResType, $vResName, $iResLang = 0)
	; Load the module
	Local $hModule = _GIF_LoadLibraryEx($sModule, 2) ; LOAD_LIBRARY_AS_DATAFILE
	If @error Then Return SetError(1, 0, "")
	; Find specified resource inside it
	Local $hResource = _GIF_FindResourceEx($hModule, $vResType, $vResName, $iResLang)
	If @error Then
		_GIF_FreeLibrary($hModule)
		Return SetError(2, 0, "")
	EndIf
	; Determine the size of the resource
	Local $iSizeOfResource = _GIF_SizeofResource($hModule, $hResource)
	If @error Then
		_GIF_FreeLibrary($hModule)
		Return SetError(3, 0, "")
	EndIf
	; Load it
	$hResource = _GIF_LoadResource($hModule, $hResource)
	If @error Then
		_GIF_FreeLibrary($hModule)
		Return SetError(4, 0, "")
	EndIf
	; Get pointer
	Local $pResource = _GIF_LockResource($hResource)
	If @error Then
		_GIF_FreeLibrary($hModule)
		Return SetError(5, 0, "")
	EndIf
	; Make structure at that address
	Local $tBinary = DllStructCreate("byte[" & $iSizeOfResource & "]", $pResource)
	; Collect data (this should be done before freeing the module)
	Local $bBinary = DllStructGetData($tBinary, 1)
	; Free
	_GIF_FreeLibrary($hModule)
	; Return data
	Return $bBinary
EndFunc   ;==>_GIF_ResourceGetAsRaw

Func _GIF_MakeBitmapFromRT_BITMAP($bBinary)
	Local $tBinary = DllStructCreate("byte[" & BinaryLen($bBinary) & "]")
	DllStructSetData($tBinary, 1, $bBinary)
	; First dword is the size of the bitmap header
	Local $iHeaderSize = DllStructGetData(DllStructCreate("dword HeaderSize", DllStructGetPtr($tBinary)), "HeaderSize")
	Local $tBitmap, $iMultiplier
	; Check the size of the header (different formats)
	Switch $iHeaderSize
		Case 40
			$tBitmap = DllStructCreate("dword HeaderSize;" & _
					"dword Width;" & _
					"dword Height;" & _
					"word Planes;" & _
					"word BitPerPixel;" & _
					"dword CompressionMethod;" & _
					"dword Size;" & _
					"dword Hresolution;" & _
					"dword Vresolution;" & _
					"dword Colors;" & _
					"dword ImportantColors", _
					DllStructGetPtr($tBinary))
			$iMultiplier = 4
		Case 12
			$tBitmap = DllStructCreate("dword HeaderSize;" & _
					"word Width;" & _
					"word Height;" & _
					"word Planes;" & _
					"word BitPerPixel", _
					DllStructGetPtr($tBinary))
			$iMultiplier = 3
		Case Else
			Return SetError(1, 0, 0) ; unsupported format
	EndSwitch
	Local $iExponent = DllStructGetData($tBitmap, "BitPerPixel")
	; Construct the new BMP
	Local $tDIB = DllStructCreate("align 2;char Identifier[2];" & _
			"dword BitmapSize;" & _
			"short;" & _
			"short;" & _
			"dword BitmapOffset;" & _
			"byte Body[" & BinaryLen($bBinary) & "]")
	; Fill the structure
	DllStructSetData($tDIB, "Identifier", "BM")
	DllStructSetData($tDIB, "BitmapSize", BinaryLen($bBinary) + 14)
	; Size of the bitmap. This data can be read from the read data, but somtimes it's not there and must be calculated.
	Local $iRawBitmapSize = DllStructGetData($tBitmap, "Size")
	If $iRawBitmapSize Then ; data is found
		DllStructSetData($tDIB, "BitmapOffset", BinaryLen($bBinary) - $iRawBitmapSize + 14)
	Else ; complication
		If $iExponent = 24 Then ; 24 bit per pixel is special case
			DllStructSetData($tDIB, "BitmapOffset", $iHeaderSize + 14)
		Else ; this is pure math
			Local $iWidth = DllStructGetData($tBitmap, "Width")
			Local $iHeight = DllStructGetData($tBitmap, "Height")
			$iRawBitmapSize = 4 * Floor(($iWidth * $iExponent + 31) / 32) * $iHeight ; boundary
			Local $iOffset1 = BinaryLen($bBinary) - $iRawBitmapSize + 14
			Local $iOffset2 = 2 ^ $iExponent * $iMultiplier + $iHeaderSize + 14
			; Get correct offset
			If $iOffset2 < $iOffset1 Then
				DllStructSetData($tDIB, "BitmapOffset", $iOffset2)
			Else
				DllStructSetData($tDIB, "BitmapOffset", $iOffset1 - 2)
			EndIf
		EndIf
	EndIf
	; Set actual bitmap data
	DllStructSetData($tDIB, "Body", $bBinary)
	; Return the BMP data
	Return DllStructGetData(DllStructCreate("byte[" & DllStructGetSize($tDIB) & "]", DllStructGetPtr($tDIB)), 1)
EndFunc   ;==>_GIF_MakeBitmapFromRT_BITMAP

Func SwapEndian($iValue, $iSize = 0)
	If $iSize Then
		Local $sPadd = "00000000"
		Return Hex(BinaryMid($iValue, 1, $iSize)) & StringLeft($sPadd, 2 * ($iSize - BinaryLen($iValue)))
	EndIf
	Return Hex(Binary($iValue))
EndFunc   ;==>SwapEndian
;============================================================================================