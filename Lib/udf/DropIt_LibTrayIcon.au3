
; Tray icon funtions collected for DropIt

#include-once
#include <GDIPlus.au3>
#include <WinAPI.au3>

#include "DropIt_LibVarious.au3"

Func __Tray_BitmapIcon($gb_Bitmap)
	Local $ts_Return = DllCall($__g_hGDIPDll, "int", "GdipCreateHICONFromBitmap", "hwnd", $gb_Bitmap, "int*", 0)
	If @error Or Not $ts_Return[0] Then
		Return SetError(@error, @extended, $ts_Return[2])
	EndIf
	Return $ts_Return[2]
EndFunc   ;==>__Tray_BitmapIcon

Func __Tray_ConvertIcon($ip_Image, $ip_XPixel = 5, $ip_YPixel = 5)
	Local $ip_ImageLoad, $ip_Width, $ip_Height, $ip_FirstPixel, $ip_TransparentPixel, $ip_ImageLoadData, $ip_Stride, $ip_Scan, $ip_Pixel
	Local $ip_Buffer, $ip_AllPixels, $ip_Result, $ip_Pix

	$ip_ImageLoad = _GDIPlus_ImageLoadFromFile($ip_Image)
	$ip_Width = _GDIPlus_ImageGetWidth($ip_ImageLoad)
	$ip_Height = _GDIPlus_ImageGetHeight($ip_ImageLoad)

	If __IsWindowsVersion() = 0 Then
		Local $ip_Return, $ip_BMP, $ip_Bitmap, $ip_Graphic
		$ip_Return = _GDIPlus_ImageGetPixelFormat($ip_ImageLoad)
		If Int(StringRegExpReplace($ip_Return[1], "\D+", "")) < 24 Then
			$ip_BMP = _WinAPI_CreateBitmap($ip_Width, $ip_Height, 1, 32)
			$ip_Bitmap = _GDIPlus_BitmapCreateFromHBITMAP($ip_BMP)
			_WinAPI_DeleteObject($ip_BMP)
			$ip_Graphic = _GDIPlus_ImageGetGraphicsContext($ip_Bitmap)
			_GDIPlus_GraphicsDrawImage($ip_Graphic, $ip_ImageLoad, 0, 0)
			_GDIPlus_GraphicsDispose($ip_Graphic)
			_GDIPlus_ImageDispose($ip_ImageLoad)
			$ip_ImageLoad = _GDIPlus_BitmapCloneArea($ip_Bitmap, 0, 0, $ip_Width, $ip_Height, $GDIP_PXF32ARGB)
			_GDIPlus_BitmapDispose($ip_Bitmap)
		EndIf
	EndIf

	$ip_ImageLoadData = _GDIPlus_BitmapLockBits($ip_ImageLoad, 0, 0, $ip_Width, $ip_Height, $GDIP_ILMWRITE, $GDIP_PXF32ARGB)
	$ip_Stride = DllStructGetData($ip_ImageLoadData, "stride")
	$ip_Scan = DllStructGetData($ip_ImageLoadData, "Scan0")

	$ip_Pixel = DllStructCreate("int", $ip_Scan + ($ip_YPixel * $ip_Stride) + ($ip_XPixel * 4))
	$ip_FirstPixel = DllStructGetData($ip_Pixel, 1)
	$ip_TransparentPixel = BitAND($ip_FirstPixel, 0x00FFFFFF)

	$ip_FirstPixel = StringRegExpReplace(Hex($ip_FirstPixel, 8), "(.{2})(.{2})(.{2})(.{2})", "\4\3\2\1")
	$ip_TransparentPixel = StringTrimRight($ip_FirstPixel, 2) & "00"
	$ip_Buffer = DllStructCreate("byte[" & $ip_Height * $ip_Width * 4 & "]", $ip_Scan)
	$ip_AllPixels = DllStructGetData($ip_Buffer, 1)
	$ip_Result = StringRegExpReplace(StringTrimLeft($ip_AllPixels, 2), "(.{8})", "\1 ")
	$ip_Pix = "0x" & StringStripWS(StringRegExpReplace($ip_Result, "(" & $ip_FirstPixel & ")", $ip_TransparentPixel), 8)
	$ip_AllPixels = DllStructSetData($ip_Buffer, 1, $ip_Pix)

	_GDIPlus_BitmapUnlockBits($ip_ImageLoad, $ip_ImageLoadData)
	Return $ip_ImageLoad
EndFunc   ;==>__Tray_ConvertIcon

Func __Tray_SetIcon($ts_Icon)
	Local $ts_Bitmap = __Tray_ConvertIcon($ts_Icon)
	$ts_Icon = __Tray_BitmapIcon($ts_Bitmap)

	Local Const $tagNOTIFYICONDATA = "dword Size;hwnd Wnd;uint ID;uint Flags;uint CallbackMessage;ptr Icon;wchar Tip[128];dword State;dword StateMask;wchar Info[256];" & _
			"uint Timeout;wchar InfoTitle[64];dword InfoFlags;dword Data1;word Data2;word Data3;byte Data4[8];ptr BalloonIcon"
	Local $ts_Handle = WinGetHandle(AutoItWinGetTitle())

	Local $tNOTIFY = DllStructCreate($tagNOTIFYICONDATA)
	DllStructSetData($tNOTIFY, "Size", DllStructGetSize($tNOTIFY))
	DllStructSetData($tNOTIFY, "Wnd", $ts_Handle)
	DllStructSetData($tNOTIFY, "ID", 1)
	DllStructSetData($tNOTIFY, "Icon", $ts_Icon)
	DllStructSetData($tNOTIFY, "Flags", BitOR(2, 1))
	DllStructSetData($tNOTIFY, "CallbackMessage", 1025)

	Local $ts_Return = DllCall("shell32.dll", "int", "Shell_NotifyIconW", "dword", 1, "ptr", DllStructGetPtr($tNOTIFY))
	If (@error) Then
		Return SetError(1, 0, 0)
	EndIf
	_GDIPlus_BitmapDispose($ts_Bitmap)
	_WinAPI_DestroyIcon($ts_Icon)
	Return $ts_Return[0] <> 0
EndFunc   ;==>__Tray_SetIcon
