
; Image funtions collected for DropIt

#include-once
#include "APIConstants.au3"
#include <DropIt_LibVarious.au3>
#include <GDIPlus.au3>
#include <GUIComboBoxEx.au3>
#include <GUIImageList.au3>
#include <GUIListView.au3>
#include <GUIMenu.au3>
#include "Resources.au3"
#include "WinAPIEx.au3"

Func __ImageConvert($sImagePath, $sSaveDirectory, $sFileExtension = "PNG")
	#cs
		Description: Convert The Image File To Another Valid Format.
		Returns: New Image [New Image.png]
	#ce
	Local $hImagePath, $sCLSID, $sFilePath

	$sCLSID = _GDIPlus_EncodersGetCLSID($sFileExtension)

	$sFileExtension = StringLower($sFileExtension)
	$sSaveDirectory = _WinAPI_PathAddBackslash($sSaveDirectory)

	$sFilePath = _WinAPI_PathYetAnotherMakeUniqueName($sSaveDirectory & _WinAPI_PathStripPath(_WinAPI_PathRemoveExtension($sImagePath)) & "." & $sFileExtension)
	$hImagePath = _GDIPlus_ImageLoadFromFile($sImagePath)

	_GDIPlus_ImageSaveToFileEx($hImagePath, $sFilePath, $sCLSID)
	Return $sFilePath
EndFunc   ;==>__ImageConvert

Func __ImageResize($sFilePath, $iWidth, $iHeight)
	#cs
		Description: Resize The Image File (In The Program Only) If Size Is Different To The Correct Size.
		Returns: New Image [Default New Size.png]
	#ce
	Local $hImage, $hGraphicsContent, $hImageNew, $iNewGraphicsContent

	$hImage = _GDIPlus_ImageLoadFromFile($sFilePath)
	$hGraphicsContent = _GDIPlus_ImageGetGraphicsContext($hImage)
	$hImageNew = _GDIPlus_BitmapCreateFromGraphics($iWidth, $iHeight, $hGraphicsContent)
	$iNewGraphicsContent = _GDIPlus_ImageGetGraphicsContext($hImageNew)
	_GDIPlus_GraphicsDrawImageRect($iNewGraphicsContent, $hImage, 0, 0, $iWidth, $iHeight)
	_GDIPlus_GraphicsDispose($hGraphicsContent)
	_GDIPlus_GraphicsDispose($iNewGraphicsContent)
	_GDIPlus_ImageDispose($hImage)
	Return $hImageNew
EndFunc   ;==>__ImageResize

Func __ImageRelativeSize($iGUIWidth, $iGUIHeight, $iImageWidth, $iImageHeight)
	#cs
		Description: Calculate The Correct Width And Height Of An Image In A GUI.
		Returns: An Array[2]
		[0] - Width Of GUI [64]
		[1] - Height Of GUI [64]
	#ce
	Local $aReturn[2] = [$iGUIWidth, $iGUIHeight]

	If ($iImageWidth < 0) Or ($iImageHeight < 0) Then
		Return SetError(1, 0, $aReturn)
	EndIf

	If $iImageWidth < $iImageHeight Then
		$aReturn[0] = Int($iGUIWidth * $iImageWidth / $iImageHeight)
		$aReturn[1] = Int($iGUIHeight)
	Else
		$aReturn[1] = Int($iGUIHeight * $iImageHeight / $iImageWidth)
		$aReturn[0] = Int($iGUIWidth)
	EndIf
	Return $aReturn
EndFunc   ;==>__ImageRelativeSize

Func __ImageSize($sFilePath) ; Taken From: http://www.autoitscript.com/forum/topic/121275-how-to-get-size-of-pictures/page__view__findpost__p__842249
	#cs
		Description: Calculate The Correct Width And Height Of An Image.
		Returns: An Array[2] Or @error
		[0] - Width Of Image File [64]
		[1] - Height Of Image File [64]
	#ce
	Local $aReturn[2] = [0, 0], $hImage

	If FileExists($sFilePath) = 0 Then
		Return SetError(1, 0, $aReturn)
	EndIf
	$hImage = _GDIPlus_ImageLoadFromFile($sFilePath)
	$aReturn[0] = _GDIPlus_ImageGetWidth($hImage)
	$aReturn[1] = _GDIPlus_ImageGetHeight($hImage)
	_GDIPlus_ImageDispose($hImage)
	If @error Then
		Return SetError(1, 0, $aReturn)
	EndIf
	Return $aReturn
EndFunc   ;==>__ImageSize

Func __IsClassicTheme() ; By guinness 2011.
	#cs
		Description: Check If Windows Uses Classic Theme.
		Returns:
		If Yes Return 1
		If No Return 0
	#ce
	_WinAPI_GetCurrentThemeName()
	Return @error
EndFunc   ;==>__IsClassicTheme

Func __SetBitmap($hGUI, $sImagePath, $iOpacity, $iWidth, $iHeight)
	#cs
		Description: Set An Image File To A GUI Handle.
		Returns: Image Name [Default.png]
	#ce
	Local $hBitmap, $hGetDC, $hImage, $hMemDC, $hPreviousImage, $hReturn, $pBlend, $pSize, $pSource, $tBlend, $tSize, $tSource

	$hImage = __ImageResize($sImagePath, $iWidth, $iHeight)
	$hReturn = $hImage

	$hGetDC = _WinAPI_GetDC(0)
	$hMemDC = _WinAPI_CreateCompatibleDC($hGetDC)
	$hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
	$hPreviousImage = _WinAPI_SelectObject($hMemDC, $hBitmap)
	$tSize = DllStructCreate($tagSIZE)
	$pSize = DllStructGetPtr($tSize)
	DllStructSetData($tSize, "X", _GDIPlus_ImageGetWidth($hImage))
	DllStructSetData($tSize, "Y", _GDIPlus_ImageGetHeight($hImage))
	$tSource = DllStructCreate($tagPOINT)
	$pSource = DllStructGetPtr($tSource)
	$tBlend = DllStructCreate($tagBLENDFUNCTION)
	$pBlend = DllStructGetPtr($tBlend)
	DllStructSetData($tBlend, "Alpha", $iOpacity)
	DllStructSetData($tBlend, "Format", 1)
	_WinAPI_UpdateLayeredWindow($hGUI, $hGetDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
	_WinAPI_ReleaseDC(0, $hGetDC)
	_WinAPI_SelectObject($hMemDC, $hPreviousImage)
	_WinAPI_DeleteObject($hBitmap)
	_WinAPI_DeleteDC($hMemDC)
	Return $hReturn
EndFunc   ;==>__SetBitmap

Func __SetItemImage($gImageFile, $gIndex, $gHandle = 0, $gType = 1, $gResource = 1, $gWidth = 20, $gHeight = 20)
	#cs
		Description: Set Image To GUI/Tray Context Menu.
		Returns: Converted Image.
	#ce
	If __IsWindowsVersion() = 0 Or __IsClassicTheme() Then
		Return SetError(1, 0, 0)
	EndIf
	Local $gImage
	Switch $gType
		Case 0 ; Native GUI ContextMenu.
			$gHandle = GUICtrlGetHandle($gHandle)
		Case 1 ; Native TrayMenu ContextMenu.
			$gHandle = TrayItemGetHandle($gHandle)
		Case 2
			$gHandle = $gHandle ; UDF Functions.
	EndSwitch
	Switch $gResource
		Case 1
			$gImage = _ResourceGetAsBitmap($gImageFile)
			_GUICtrlMenu_SetItemBmp($gHandle, $gIndex, $gImage)
			Return SetError(0, 0, $gImage)
		Case Else
			Local $gBitmap, $gContext, $gIcon, $gImageHeight, $gImageWidth, $gResult
			$gImage = _GDIPlus_BitmapCreateFromFile($gImageFile)
			$gImageWidth = _GDIPlus_ImageGetWidth($gImage)
			$gImageHeight = _GDIPlus_ImageGetHeight($gImage)
			If $gImageWidth < 0 Or $gImageHeight < 0 Then
				Return SetError(1, 0, 0)
			EndIf
			If $gImageWidth < $gImageHeight Then
				$gImageWidth = $gWidth * $gImageWidth / $gImageHeight
				$gImageHeight = $gHeight
			Else
				$gImageHeight = $gHeight * $gImageHeight / $gImageWidth
				$gImageWidth = $gWidth
			EndIf
			$gResult = DllCall($ghGDIPDll, "uint", "GdipCreateBitmapFromScan0", "int", $gWidth, "int", $gHeight, "int", 0, "int", 0x0026200A, "ptr", 0, "int*", 0)
			$gBitmap = $gResult[6]
			$gContext = _GDIPlus_ImageGetGraphicsContext($gBitmap)
			_GDIPlus_GraphicsDrawImageRect($gContext, $gImage, 0, 0, $gWidth, $gHeight)
			$gIcon = _GDIPlus_BitmapCreateHBITMAPFromBitmap($gBitmap)
			_GUICtrlMenu_SetItemBmp($gHandle, $gIndex, $gIcon)
			_GDIPlus_GraphicsDispose($gContext)
			_GDIPlus_BitmapDispose($gBitmap)
			_GDIPlus_BitmapDispose($gImage)
			Return SetError(0, 0, $gIcon)
	EndSwitch
EndFunc   ;==>__SetItemImage

Func __SetItemImageEx($gHandle, $gIndex, ByRef $gImageList, $gImageFile, $gType) ; Taken From: http://www.autoitscript.com/forum/topic/113827-thumbnail-of-a-file/page__p__799038#entry799038
	#cs
		Description: Set Image To Control Handle.
		Returns: 1
	#ce
	Local $gIconSize = _GUIImageList_GetIconSize($gImageList)
	If (Not $gIconSize[0]) Or (Not $gIconSize[1]) Then
		Return SetError(1, 0, 0)
	EndIf

	Local $gWidth, $gHeight, $gHeightGraphic, $gHeightPicture, $gHeightImage, $gHeightIcon

	$gHeightPicture = _ResourceGetAsImage($gImageFile)
	If @error Then
		$gHeightPicture = _ResourceGetAsImage("FLAG")
		If FileExists($gImageFile) Then
			$gHeightPicture = _GDIPlus_ImageLoadFromFile($gImageFile)
		EndIf
	EndIf

	$gWidth = _GDIPlus_ImageGetWidth($gHeightPicture)
	$gHeight = _GDIPlus_ImageGetHeight($gHeightPicture)

	Local $gSize = __ImageRelativeSize($gIconSize[0], $gIconSize[1], $gWidth, $gHeight)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	$gHeightImage = DllCall($ghGDIPDll, 'int', 'GdipGetImageThumbnail', 'ptr', $gHeightPicture, 'int', $gIconSize[0], 'int', $gIconSize[1], 'ptr*', 0, 'ptr', 0, 'ptr', 0)
	$gHeightGraphic = _GDIPlus_ImageGetGraphicsContext($gHeightImage[4])
	_GDIPlus_GraphicsClear($gHeightGraphic, 0)
	_GDIPlus_GraphicsDrawImageRect($gHeightGraphic, $gHeightPicture, ($gIconSize[0] - $gSize[0]) / 2, ($gIconSize[1] - $gSize[1]) / 2, $gSize[0], $gSize[1])
	$gHeightIcon = DllCall($ghGDIPDll, 'int', 'GdipCreateHICONFromBitmap', 'ptr', $gHeightImage[4], 'ptr*', 0)
	_GDIPlus_GraphicsDispose($gHeightGraphic)
	_GDIPlus_ImageDispose($gHeightImage[4])
	_GDIPlus_ImageDispose($gHeightPicture)
	If Not $gHeightIcon[2] Then
		Return SetError(1, 0, 0)
	EndIf
	_GUIImageList_ReplaceIcon($gImageList, -1, $gHeightIcon[2])
	Switch $gType
		Case 1 ; ListView
			_GUICtrlListView_SetItemImage($gHandle, $gIndex, _GUIImageList_GetImageCount($gImageList) - 1)
		Case 2 ; ComboBox
			_GUICtrlComboBoxEx_SetItemImage($gHandle, $gIndex, _GUIImageList_GetImageCount($gImageList) - 1)
	EndSwitch
	_WinAPI_DestroyIcon($gHeightIcon[2])
	Return 1
EndFunc   ;==>__SetItemImageEx