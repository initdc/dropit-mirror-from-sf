
; Image funtions collected for DropIt

#include-once
#include <GDIPlus.au3>
#include <GUIComboBoxEx.au3>
#include <GUIImageList.au3>
#include <GUIListView.au3>
#include <GUIMenu.au3>
#include <WinAPIShPath.au3>
#include <WinAPITheme.au3>

#include "DropIt_LibFiles.au3"
#include "DropIt_LibVarious.au3"
#include "MPDF.au3"
#include "ResourcesEx.au3"

Func __ImageConvert($sImagePath, $sDestination, $sFileExtension = "PNG")
	#cs
		Description: Convert The Image File To Another Valid Format.
		Returns: New Image [New Image.png]
	#ce
	Local $hImage, $sCLSID, $sFilePath

	$sCLSID = _GDIPlus_EncodersGetCLSID($sFileExtension)
	$sFileExtension = StringLower($sFileExtension)
	If _WinAPI_PathIsDirectory($sDestination) Then
		$sDestination = _WinAPI_PathAddBackslash($sDestination) & _WinAPI_PathStripPath(_WinAPI_PathRemoveExtension($sImagePath)) & "." & $sFileExtension
	Else
		$sDestination = _WinAPI_PathRemoveExtension($sDestination) & "." & $sFileExtension
	EndIf
	$sFilePath = _WinAPI_PathYetAnotherMakeUniqueName($sDestination)
	$hImage = _GDIPlus_ImageLoadFromFile($sImagePath)
	_GDIPlus_ImageSaveToFileEx($hImage, $sFilePath, $sCLSID)
	If @error Then
		_GDIPlus_ImageDispose($hImage)
		Return SetError(1, 0, $sFilePath)
	EndIf
	_GDIPlus_ImageDispose($hImage)

	Return $sFilePath
EndFunc   ;==>__ImageConvert

Func __ImagesToPDF($sImagePaths, $sDestination)
	#cs
		Description: Save One Or More Images To PDF.
		Returns: PDF File [File.pdf]
	#ce
	Local $aImages = StringSplit($sImagePaths, "|", 1)
	_SetTitle(__GetFileNameOnly($sDestination))
	_OpenAfter(False)
	_SetUnit($PDF_UNIT_CM)
	_SetPaperSize("a4")
	_SetZoomMode($PDF_ZOOM_CUSTOM, 90)
	_SetOrientation($PDF_ORIENTATION_PORTRAIT)
	_SetLayoutMode($PDF_LAYOUT_CONTINOUS)

	_InitPDF($sDestination)
	For $A = 1 To $aImages[0]
		_LoadResImage("img" & $A, $aImages[$A])
	Next
	For $A = 1 To $aImages[0]
		_BeginPage()
		_InsertImage("img" & $A, 0, 0, _GetPageWidth() / _GetUnit(), _GetPageHeight() / _GetUnit())
		_EndPage()
	Next
	_ClosePDFFile()

	Return $sDestination
EndFunc   ;==>__ImageToPDF

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

Func __ImageWriteResize($sInFile, $sOutFile, $iOutWidth, $iOutHeight, $iCrop = 0) ; Taken From: http://www.autoitscript.com/forum/topic/152974-unique-function-to-convert-resize-and-crop-images/
	#cs
		Description: Save A Converted, Resized And Cropped Image From A Loaded Image File.
		Returns: 1
	#ce
	Local $hInHandle, $iInWidth, $iInHeight, $iRatio, $hOutHandle, $hGraphic, $CLSID, $iInX = 0, $iInY = 0
	Local $sExt = StringTrimLeft(_WinAPI_PathFindExtension($sOutFile), 1)

	$hInHandle = _GDIPlus_ImageLoadFromFile($sInFile)
	$iInWidth = _GDIPlus_ImageGetWidth($hInHandle)
	$iInHeight = _GDIPlus_ImageGetHeight($hInHandle)

	If $iCrop = 1 Then ; Images Are Cropped To Width And Height, Keeping Aspect Ratio (Smaller Images Are Expanded).
		If $iOutWidth / $iInWidth > $iOutHeight / $iInHeight Then
			$iRatio = $iOutWidth / $iInWidth
		Else
			$iRatio = $iOutHeight / $iInHeight
		EndIf
		$iInX = Int(($iInWidth - $iOutWidth / $iRatio) / 2)
		$iInY = Int(($iInHeight - $iOutHeight / $iRatio) / 4)
		$iInWidth = Int($iOutWidth / $iRatio)
		$iInHeight = Int($iOutHeight / $iRatio)
	Else ; Images Are Limited To Width And Height, Keeping Aspect Ratio (Smaller Images Are Not Expanded).
		If $iOutWidth / $iInWidth < $iOutHeight / $iInHeight Then
			$iRatio = $iOutWidth / $iInWidth
		Else
			$iRatio = $iOutHeight / $iInHeight
		EndIf
		If $iRatio > 1 Then
			$iRatio = 1 ; To Keep Size Of Smaller Images.
		EndIf
		$iOutWidth = Int($iInWidth * $iRatio)
		$iOutHeight = Int($iInHeight * $iRatio)
	EndIf

	$hOutHandle = __GDIPlus_BitmapCreateFromScan0($iOutWidth, $iOutHeight)
	$hGraphic = _GDIPlus_ImageGetGraphicsContext($hOutHandle)
	_GDIPlus_GraphicsDrawImageRectRect($hGraphic, $hInHandle, $iInX, $iInY, $iInWidth, $iInHeight, 0, 0, $iOutWidth, $iOutHeight)
	$CLSID = _GDIPlus_EncodersGetCLSID(StringUpper($sExt))
	_GDIPlus_ImageSaveToFileEx($hOutHandle, $sOutFile, $CLSID)

	_GDIPlus_ImageDispose($hInHandle)
	_GDIPlus_ImageDispose($hOutHandle)
	_GDIPlus_GraphicsDispose($hGraphic)

	Return 1
EndFunc   ;==>__ImageWriteResize

Func __IsClassicTheme()
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
			$gImage = _Resource_GetAsBitmap($gImageFile)
			_GUICtrlMenu_SetItemBmp($gHandle, $gIndex, $gImage)
			Return SetError(0, 0, $gImage)
		Case Else
			Local $gBitmap, $gContext, $gIcon, $gImageHeight, $gImageWidth
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
			$gBitmap = __GDIPlus_BitmapCreateFromScan0($gWidth, $gHeight)
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

Func __GDIPlus_BitmapCreateFromScan0($iWidth, $iHeight, $iStride = 0, $iPixelFormat = $GDIP_PXF32ARGB, $pScan0 = 0) ; Fixed Support To 64bit OS.
	Local $aResult = DllCall($__g_hGDIPDll, "uint", "GdipCreateBitmapFromScan0", "int", $iWidth, "int", $iHeight, "int", $iStride, "int", $iPixelFormat, "ptr", $pScan0, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return SetError(10, $aResult[0], 0)

	Return $aResult[6]
EndFunc   ;==>__GDIPlus_BitmapCreateFromScan0

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

	$gHeightPicture = _Resource_GetAsImage($gImageFile)
	If @error Then
		$gHeightPicture = _Resource_GetAsImage("FLAG")
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
	$gHeightImage = DllCall($__g_hGDIPDll, 'int', 'GdipGetImageThumbnail', 'ptr', $gHeightPicture, 'int', $gIconSize[0], 'int', $gIconSize[1], 'ptr*', 0, 'ptr', 0, 'ptr', 0)
	$gHeightGraphic = _GDIPlus_ImageGetGraphicsContext($gHeightImage[4])
	_GDIPlus_GraphicsClear($gHeightGraphic, 0)
	_GDIPlus_GraphicsDrawImageRect($gHeightGraphic, $gHeightPicture, ($gIconSize[0] - $gSize[0]) / 2, ($gIconSize[1] - $gSize[1]) / 2, $gSize[0], $gSize[1])
	$gHeightIcon = DllCall($__g_hGDIPDll, 'int', 'GdipCreateHICONFromBitmap', 'ptr', $gHeightImage[4], 'ptr*', 0)
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
