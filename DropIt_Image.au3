
; Image funtions of DropIt

#include-once
#include "DropIt_General.au3"
#include "DropIt_Global.au3"
#include "Lib\udf\DropIt_LibFiles.au3"
#include "Lib\udf\DropIt_LibImages.au3"
#include "Lib\udf\DropIt_LibVarious.au3"

Func __ImageGet($hHandle = -1, $sProfile = -1)
	Local $aReturn[6], $sFileName, $sFileOpenDialog, $sImagePath, $iSize

	$sImagePath = __IsProfile($sProfile, 0) ; Get Array Of Selected Profile.
	$sFileOpenDialog = FileOpenDialog(__GetLang('IMAGE_GET_TIP_0', 'Select target image for this Profile'), $sImagePath[8], __GetLang('IMAGE_GET', 'Images') & " (*.gif;*.jpg;*.png)", 1, "", __OnTop($hHandle))
	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	If __IsWindowsVersion() = 0 And __GetFileExtension($sFileOpenDialog) = "gif" Then
		$sFileOpenDialog = __ImageConvert($sFileOpenDialog, $sImagePath[8], "PNG")
	EndIf

	If StringInStr($sFileOpenDialog, $sImagePath[8]) = 0 Then
		FileCopy($sFileOpenDialog, $sImagePath[8])
		$sFileOpenDialog = $sImagePath[8] & __GetFileName($sFileOpenDialog) ; Get The File Name Of The Selected [FileName.txt].
	EndIf

	$iSize = __ImageSize($sFileOpenDialog)
	$sFileName = StringTrimLeft($sFileOpenDialog, StringLen($sImagePath[8]))
	$aReturn[0] = $sFileOpenDialog ; FilePath + FileName.
	$aReturn[1] = $sFileName ; FileName.
	$aReturn[2] = $iSize[0] ; FileSize Width.
	$aReturn[3] = $iSize[1] ; FileSize Height.
	$aReturn[4] = 100 ; Opacity.
	$aReturn[5] = $sImagePath[8] ; FilePath.

	__ImageWrite($sProfile, 7, $aReturn[1], $aReturn[2], $aReturn[3], $aReturn[4]) ; Write Image File Name & Size & Opacity To The Selected Profile.
	Return $aReturn
EndFunc   ;==>__ImageGet

Func __ImageWrite($sProfile = -1, $iFlag = 1, $sImagePath = -1, $iSize_X = 64, $iSize_Y = 64, $iOpacity = 100)
	$sProfile = __IsProfile($sProfile, 1) ; Get Profile Path Of Selected Profile.

	If $sImagePath == -1 Or $sImagePath == 0 Or $sImagePath == "" Then
		$sImagePath = __GetDefault(16) ; Default Image File.
	EndIf

	If BitAND($iFlag, 1) Then ; 1 = Add Image File.
		__IniWriteEx($sProfile, $G_Global_TargetSection, "Image", $sImagePath)
	EndIf
	If BitAND($iFlag, 2) Then ; 2 = Add Image Size.
		__IniWriteEx($sProfile, $G_Global_TargetSection, "SizeX", $iSize_X)
		__IniWriteEx($sProfile, $G_Global_TargetSection, "SizeY", $iSize_Y)
	EndIf
	If BitAND($iFlag, 4) Then ; 4 = Add Opacity.
		__IniWriteEx($sProfile, $G_Global_TargetSection, "Opacity", StringReplace($iOpacity, "%", ""))
		IniDelete($sProfile, $G_Global_TargetSection, "Transparency")
	EndIf

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__ImageWrite
