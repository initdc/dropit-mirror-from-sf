
; #VARIABLES# ===================================================================================================================
Global $__gPTR_7ZipRead = "ptr"
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
Func __7Zip_ClosePercent(ByRef $zHandle)
	If UBound($zHandle) <> 4 Then
		Return 0
	EndIf
	DllCall("Kernel32.dll", "int", "FreeConsole")
	$zHandle = 0
	Return 1
EndFunc   ;==>__7Zip_ClosePercent

; #FUNCTION# ====================================================================================================================
Func __7Zip_OpenPercent($zPID)
	If __7Zip_AttachConsole($zPID) = 0 Then
		Return
	EndIf
	Local $zHandle[4]
	$zHandle[0] = __7Zip_GetHandle(-11)
	$zHandle[1] = DllStructCreate("short dwSizeX; short dwSizeY;short dwCursorPositionX; short dwCursorPositionY; short wAttributes;short Left; short Top; short Right; short Bottom; short dwMaximumWindowSizeX; short dwMaximumWindowSizeY")
	$zHandle[2] = DllStructCreate("dword[4]")
	$zHandle[3] = DllStructCreate("short Left; short Top; short Right; short Bottom")
	Return $zHandle
EndFunc   ;==>__7Zip_OpenPercent

; #FUNCTION# ====================================================================================================================
Func __7Zip_ReadPercent(ByRef $zHandle)
	If UBound($zHandle) = 4 Then
		Local Const $zStdOut = $zHandle[0]
		Local Const $zGetConsoleInfo = $zHandle[1]
		Local Const $zBuffer = $zHandle[2]
		Local Const $zSmallRect = $zHandle[3]
		If __7Zip_GetConsoleInfo($zStdOut, $zGetConsoleInfo) Then
			DllStructSetData($zSmallRect, "Left", DllStructGetData($zGetConsoleInfo, "dwCursorPositionX") - 4)
			DllStructSetData($zSmallRect, "Top", DllStructGetData($zGetConsoleInfo, "dwCursorPositionY"))
			DllStructSetData($zSmallRect, "Right", DllStructGetData($zGetConsoleInfo, "dwCursorPositionX"))
			DllStructSetData($zSmallRect, "Bottom", DllStructGetData($zGetConsoleInfo, "dwCursorPositionY"))
			If __7Zip_ReadConsoleOutput($zStdOut, $zBuffer, $zSmallRect) Then
				Local $zPercent = ""
				For $i = 0 To 3
					Local $zCharInfo = DllStructCreate("wchar UnicodeChar; short Attributes", DllStructGetPtr($zBuffer) + ($i * 4))
					$zPercent &= DllStructGetData($zCharInfo, "UnicodeChar")
				Next
				If StringRight($zPercent, 1) = "%" Then
					Return Number($zPercent)
				EndIf
			EndIf
		EndIf
	EndIf
	Return -1
EndFunc   ;==>__7Zip_ReadPercent

; #FUNCTION# ====================================================================================================================
Func __7Zip_AttachConsole($zPID)
	Local $zReturn = DllCall("Kernel32.dll", "int", "AttachConsole", "dword", $zPID)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return $zReturn[0]
EndFunc   ;==>__7Zip_AttachConsole

; #FUNCTION# ====================================================================================================================
Func __7Zip_GetConsoleInfo($zConsoleOutput, $zGetConsoleInfo)
	Local $zReturn = DllCall("Kernel32.dll", "int", "GetConsoleScreenBufferInfo", "hwnd", $zConsoleOutput, $__gPTR_7ZipRead, __7Zip_GetPointer($zGetConsoleInfo))
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return $zReturn[0]
EndFunc   ;==>__7Zip_GetConsoleInfo

; #FUNCTION# ====================================================================================================================
Func __7Zip_GetHandle($zHandle)
	Local $zReturn = DllCall("Kernel32.dll", "hwnd", "GetStdHandle", "dword", $zHandle)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return $zReturn[0]
EndFunc   ;==>__7Zip_GetHandle

; #FUNCTION# ====================================================================================================================
Func __7Zip_GetPointer(Const ByRef $__gPTR_7ZipRead)
	Local $zPointer = DllStructGetPtr($__gPTR_7ZipRead)
	If @error Then
		$zPointer = $__gPTR_7ZipRead
	EndIf
	Return $zPointer
EndFunc   ;==>__7Zip_GetPointer

; #FUNCTION# ====================================================================================================================
Func __7Zip_ReadConsoleOutput($zConsoleOutput, $zBuffer, $zSmallRect)
	Local $zReturn = DllCall("Kernel32.dll", "int", "ReadConsoleOutputW", $__gPTR_7ZipRead, $zConsoleOutput, "int", __7Zip_GetPointer($zBuffer), "int", 65540, "int", 0, $__gPTR_7ZipRead, __7Zip_GetPointer($zSmallRect))
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return $zReturn[0]
EndFunc   ;==>__7Zip_ReadConsoleOutput
