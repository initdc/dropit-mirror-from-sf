
; Gallery funtions of DropIt

#include-once
#include <String.au3>

#include "DropIt_Abbreviation.au3"
#include "DropIt_General.au3"
#include "DropIt_Global.au3"
#include "Lib\udf\DropIt_LibFiles.au3"
#include "Lib\udf\DropIt_LibImages.au3"
#include "Lib\udf\DropIt_LibVarious.au3"

Func __Gallery_GetProperties($lStringProperties, $lGetValues = 0)
	If $lStringProperties == "" Then ; No Fields To Write.
		Local $lArray[1] = [0]
		Return $lArray
	EndIf
	Local $lStringSplit = StringSplit($lStringProperties, ";")
	Local $B = 0, $lArray[Int($lStringSplit[0] / 2) + 1] = [Int($lStringSplit[0] / 2)]

	For $A = 1 To $lStringSplit[0] Step 2
		$B += 1
		If $lGetValues <> 0 Then ; Get Values.
			$lArray[$B] = $lStringSplit[$A + 1]
		Else ; Get Titles.
			$lArray[$B] = $lStringSplit[$A]
		EndIf
	Next

	Return $lArray
EndFunc   ;==>__Gallery_GetProperties

Func __Gallery_WriteHTML($lSubArray, $lGalleryPath, $lElementsGUI, $lStringProperties, $lProfile, $lListName, $lThemeName, $lSettings)
	#cs
		Description: Write An Array To Gallery HTML File.
		Returns: 1
	#ce
	Local $lFileOpen, $lFileName, $lArray, $lString, $lStringSplit, $lGallery, $lCurrent
	Local $lThumbSize, $lPhotoLink, $lPhotoTitle, $lFileType, $lLightThumbs, $lSizeLimit, $lDifferentString
	Local $lGalleryDataFolder = @ScriptDir & "\Lib\gallery"
	Local $lTitleArray = __Gallery_GetProperties($lStringProperties)
	Local $lValueArray = __Gallery_GetProperties($lStringProperties, 1)
	Local $lThemeArray = __ThemeGallery_Array($lGalleryDataFolder & "\themes")

	If $lThemeName = "" Or StringInStr($lThemeArray[0][1], $lThemeName) = 0 Then
		$lThemeName = "Default"
	EndIf
	$lCurrent = __ThemeGallery_Current($lThemeArray, $lThemeName, 3) ; [200x200].
	$lThumbSize = StringSplit($lCurrent, "x")
	If $lThumbSize[0] <> 2 Then
		ReDim $lThumbSize[3]
		$lThumbSize[1] = 200
		$lThumbSize[2] = 200
	EndIf

	$lStringSplit = StringSplit($lSettings, ";") ; 1 = Quality, 2 = Lightbox Thumbs, 3 = Image Titles.
	ReDim $lStringSplit[4]
	If $lStringSplit[1] = "" Then
		$lStringSplit[1] = 2
	EndIf
	$lStringSplit[1] = Number($lStringSplit[1])
	If Number($lStringSplit[2]) <> 0 Then
		$lLightThumbs = @TAB & '<link rel="stylesheet" type="text/css" href="js/fancybox/helpers/jquery.fancybox-thumbs.css?v=1.0.7"/>' & @CRLF & _
				@TAB & '<script type="text/javascript" src="js/fancybox/helpers/jquery.fancybox-thumbs.js?v=1.0.7"></script>' & @CRLF
	EndIf

	DirCopy($lGalleryDataFolder & "\css", $lGalleryPath & "\css", 1)
	DirCopy($lGalleryDataFolder & "\images", $lGalleryPath & "\images", 1)
	DirCopy($lGalleryDataFolder & "\js", $lGalleryPath & "\js", 1)
	$lCurrent = __ThemeGallery_Current($lThemeArray, $lThemeName, 2) ; [layout-default].
	FileCopy($lGalleryDataFolder & "\layouts\" & $lCurrent & ".css", $lGalleryPath & "\css\" & $lCurrent & ".css", 9)
	$lCurrent = __ThemeGallery_Current($lThemeArray, $lThemeName, 0) ; [theme-default].
	FileCopy($lGalleryDataFolder & "\themes\" & $lCurrent & ".css", $lGalleryPath & "\css\" & $lCurrent & ".css", 9)
	If $lStringSplit[1] <> 5 Then ; If Is Not "Link original files".
		DirCreate($lGalleryPath & "\files")
		DirCreate($lGalleryPath & "\photos")
	EndIf
	DirCreate($lGalleryPath & "\thumbs")

	Local $lHeader = '<!DOCTYPE html>' & @CRLF & _
			'<html dir="ltr" lang="en">' & @CRLF & @CRLF & _
			'<head>' & @CRLF & _
			@TAB & '<meta charset="utf-8">' & @CRLF & _
			@TAB & '<meta name="description" content="">' & @CRLF & _
			@TAB & '<meta name="keywords" content=""/>' & @CRLF & _
			@TAB & '<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">' & @CRLF & _
			@TAB & '<meta name="author" content="">' & @CRLF & _
			@TAB & '<!--<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">-->' & @CRLF & @CRLF & _
			@TAB & '<title>' & $lListName & '</title>' & @CRLF & @CRLF & _
			@TAB & '<link rel="shortcut icon" type="image/ico" href="images/favicon.ico">' & @CRLF & @CRLF & _
			@TAB & '<link rel="stylesheet" href="css/normalize.css" type="text/css" media="screen,projection">' & @CRLF & _
			@TAB & '<script type="text/javascript" src="js/jquery-1.10.1.min.js"></script>' & @CRLF & _
			@TAB & '<script type="text/javascript" src="js/jquery.mousewheel-3.0.6.pack.js"></script>' & @CRLF & _
			@TAB & '<script type="text/javascript" src="js/fancybox/jquery.fancybox.js?v=2.1.5"></script>' & @CRLF & _
			@TAB & '<link rel="stylesheet" type="text/css" href="js/fancybox/jquery.fancybox.css?v=2.1.5" media="screen"/>' & @CRLF & $lLightThumbs & _
			@TAB & '<link rel="stylesheet" href="css/base.css" type="text/css" media="screen,projection">' & @CRLF & _
			@TAB & '<link rel="stylesheet" href="css/' & $lCurrent & '.css" type="text/css" media="screen,projection">' & @CRLF & @CRLF & _
			@TAB & '<!--[if lt IE 8]>' & @CRLF & _
			@TAB & '<link rel="stylesheet" href="css/ie.css" type="text/css" media="screen">' & @CRLF & _
			@TAB & '<![endif]-->' & @CRLF & @CRLF & _
			@TAB & '<!--[if lt IE 9]>' & @CRLF & _
			@TAB & '<script src="js/html5.js"></script>' & @CRLF & _
			@TAB & '<![endif]-->' & @CRLF & @CRLF & _
			@TAB & '<script src="js/main.js" type="text/javascript"></script>' & @CRLF & _
			'</head>' & @CRLF & @CRLF

	For $A = 1 To $lSubArray[0]
		$lArray = $lValueArray
		$lString = ''
		$lFileName = __GetFileName($lSubArray[$A])
		If __IsValidFileType($lSubArray[$A], 'jpg;jpeg;png;gif;tif;tiff') Then
			$lFileType = 'photos'
			__ImageWriteResize($lSubArray[$A], $lGalleryPath & "\thumbs\" & $lFileName, $lThumbSize[1], $lThumbSize[2], 1)
		ElseIf __IsValidFileType($lSubArray[$A], 'svg') Then
			$lFileType = 'photos'
			FileCopy($lSubArray[$A], $lGalleryPath & "\thumbs\" & $lFileName, 9)
		Else
			$lFileType = 'files'
		EndIf
		$lPhotoLink = $lFileType & '/' & $lFileName
		If $lStringSplit[1] = 5 Then ; If Is "Link original files".
			$lPhotoLink = 'file:///' & $lSubArray[$A]
		ElseIf ($lFileType = 'photos' And $lStringSplit[1] = 4) Or ($lFileType = 'photos' And __IsValidFileType($lSubArray[$A], 'svg')) Or $lFileType = 'files' Then ; If Is "Copy for best quality" Or SVG Image Or A File.
			FileCopy($lSubArray[$A], $lGalleryPath & '\' & $lFileType & '\' & $lFileName, 9)
		Else ; If Is "Resize for high/medium/low quality".
			Switch $lStringSplit[1]
				Case 3
					$lSizeLimit = 1600
				Case 1
					$lSizeLimit = 800
				Case Else
					$lSizeLimit = 1200
			EndSwitch
			__ImageWriteResize($lSubArray[$A], $lGalleryPath & "\photos\" & $lFileName, $lSizeLimit, $lSizeLimit, 0)
		EndIf
		$lPhotoTitle = $lStringSplit[3]
		If $lPhotoTitle <> "" Then ; Image Titles Are Defined.
			If StringInStr($lPhotoTitle, "%") Then
				$lPhotoTitle = StringReplace($lPhotoTitle, "%Counter%", $A)
				$lPhotoTitle = _ReplaceAbbreviation($lPhotoTitle, 0, $lSubArray[$A], $lProfile, "$H")
				$lPhotoTitle = StringRegExpReplace($lPhotoTitle, '[<>"]', '')
			EndIf
			If $lFileType = 'photos' Then
				$lDifferentString = ''
			Else
				$lDifferentString = ' target="_blank"'
			EndIf
			$lString &= @TAB & @TAB & @TAB & @TAB & @TAB & @TAB & @TAB & @TAB & '<h2><a href="' & $lPhotoLink & '" class="title" title="' & $lPhotoTitle & '"' & $lDifferentString & '>' & $lPhotoTitle & '</a></h2>' & @CRLF
		EndIf
		If $lFileType = 'photos' Then
			$lDifferentString = '<a href="' & $lPhotoLink & '" class="fancybox image" data-rel="group" title="' & $lPhotoTitle & '" style="height: ' & $lThumbSize[2] & 'px;"><img src="thumbs/' & $lFileName & '" alt=""/></a>'
		Else ; Is 'files'.
			$lDifferentString = '<a href="' & $lPhotoLink & '" class="no-image" title="' & __GetLang('DOWNLOAD', 'Download') & '" style="height: ' & $lThumbSize[2] & 'px;" target="_blank"><span>' & __GetLang('DOWNLOAD', 'Download') & '</span></a>'
		EndIf
		If $lArray[0] <> 0 Then
			For $B = 1 To $lArray[0]
				If $lArray[$B] = "" Then
					$lArray[$B] = "-"
				ElseIf StringInStr($lArray[$B], "%") Then
					$lArray[$B] = StringReplace($lArray[$B], "%Counter%", $A)
					$lArray[$B] = _ReplaceAbbreviation($lArray[$B], 0, $lSubArray[$A], $lProfile, "$H")
					$lArray[$B] = StringRegExpReplace($lArray[$B], '[<>"]', '')
				EndIf
				$lPhotoTitle = ""
				If $lTitleArray[$B] <> "" Then
					$lPhotoTitle = '<strong>' & $lTitleArray[$B] & ': </strong>'
				EndIf
				$lString &= @TAB & @TAB & @TAB & @TAB & @TAB & @TAB & @TAB & @TAB & '<p class="field">' & $lPhotoTitle & $lArray[$B] & '</p>' & @CRLF
			Next
		EndIf
		$lGallery &= @TAB & @TAB & @TAB & @TAB & @TAB & '<li class="group">' & @CRLF & _
				@TAB & @TAB & @TAB & @TAB & @TAB & @TAB & '<div class="inner" style="width: ' & $lThumbSize[1] & 'px;">' & @CRLF & _
				@TAB & @TAB & @TAB & @TAB & @TAB & @TAB & @TAB & $lDifferentString & @CRLF & _
				@TAB & @TAB & @TAB & @TAB & @TAB & @TAB & @TAB & '<div>' & @CRLF & $lString & _
				@TAB & @TAB & @TAB & @TAB & @TAB & @TAB & @TAB & '</div>' & @CRLF & _
				@TAB & @TAB & @TAB & @TAB & @TAB & @TAB & '</div>' & @CRLF & _
				@TAB & @TAB & @TAB & @TAB & @TAB & '</li>' & @CRLF & @CRLF
		__SetProgressResult($lElementsGUI, __GetFileSize($lSubArray[$A]))
	Next

	Local $lContent = '<body>' & @CRLF & @CRLF & _
			'<div class="wrap group">' & @CRLF & @CRLF & _
			@TAB & '<div class="header-wrap">' & @CRLF & _
			@TAB & @TAB & '<div class="header">' & @CRLF & @CRLF & _
			@TAB & @TAB & @TAB & '<header>' & @CRLF & _
			@TAB & @TAB & @TAB & @TAB & '<div><h1>' & $lListName & '</h1></div>' & @CRLF & _
			@TAB & @TAB & @TAB & '</header>' & @CRLF & _
			@TAB & @TAB & @TAB & '<!-- end of header -->' & @CRLF & @CRLF & _
			@TAB & @TAB & '</div>' & @CRLF & _
			@TAB & @TAB & '<!-- /.header -->' & @CRLF & _
			@TAB & '</div>' & @CRLF & _
			@TAB & '<!-- /.header-wrap -->' & @CRLF & @CRLF & _
			@TAB & '<div class="content-wrap">' & @CRLF & _
			@TAB & @TAB & '<div class="content">' & @CRLF & @CRLF & _
			@TAB & @TAB & @TAB & '<section>' & @CRLF & @CRLF & _
			@TAB & @TAB & @TAB & @TAB & '<ul class="photos group">' & @CRLF & @CRLF & $lGallery & _
			@TAB & @TAB & @TAB & @TAB & '</ul>' & @CRLF & @CRLF & _
			@TAB & @TAB & @TAB & '</section>' & @CRLF & @CRLF & _
			@TAB & @TAB & '</div>' & @CRLF & _
			@TAB & @TAB & '<!-- /.content -->' & @CRLF & _
			@TAB & '</div>' & @CRLF & _
			@TAB & '<!-- /.content-wrap -->' & @CRLF & @CRLF & _
			@TAB & '<div class="footerfix"></div>' & @CRLF & @CRLF & _
			'</div>' & @CRLF & _
			'<!-- /.content-wrap -->' & @CRLF

	Local $lFooter = '<div class="footer-wrap">' & @CRLF & _
			@TAB & '<div class="footer">' & @CRLF & _
			@TAB & @TAB & '<footer>' & @CRLF & _
			@TAB & @TAB & @TAB & '<p>' & @CRLF & _
			@TAB & @TAB & @TAB & @TAB & StringReplace(__GetLang('LIST_HTML_GENERATED', 'Generated with %DropItWebLink%', 1), '%DropItWebLink%', '<a href="%DropItURL%" title="' & __GetLang('LIST_HTML_VISIT', 'Visit DropIt website') & '" class="dropit-link" target="_blank">DropIt</a>') & @CRLF & _
			@TAB & @TAB & @TAB & '</p>' & @CRLF & _
			@TAB & @TAB & '</footer>' & @CRLF & _
			@TAB & '</div>' & @CRLF & _
			'</div>' & @CRLF & @CRLF & _
			'</body>' & @CRLF & _
			'</html>'

	$lFileOpen = FileOpen($lGalleryPath & "\index.html", 2 + 8 + 128)
	FileWrite($lFileOpen, $lHeader & $lContent & $lFooter)
	FileClose($lFileOpen)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	Return 1
EndFunc   ;==>__Gallery_WriteHTML

Func __ThemeGallery_Array($sFolder, $iSort = 0)
	#cs
		Description: Get Themes Array And Create String For Use In A Combo Box.
		Returns: Array[?][4]
		[0][0] - Counter Of Themes [3]
		[0][1] - String Of Themes [Dark|Default|Red]
		[$A][0] - Theme Filename [theme-default]
		[$A][1] - Theme Name [Default]
		[$A][2] - Related Layout Filename [layout-default]
		[$A][3] - Thumbnail Size [200x200]
	#ce
	Local $iSearch, $sFileName, $sFileRead, $aBetween, $aData[1][4] = [[0, ""]]

	$iSearch = FileFindFirstFile($sFolder & "\*.css")
	While 1
		$sFileName = FileFindNextFile($iSearch)
		If @error Then
			ExitLoop
		EndIf
		$sFileRead = FileRead($sFolder & "\" & $sFileName)
		$aData[0][0] += 1
		ReDim $aData[$aData[0][0] + 1][4]
		$aData[$aData[0][0]][0] = StringTrimRight($sFileName, 4)
		$aBetween = _StringBetween($sFileRead, '/* Theme name: ', ' */')
		$aData[$aData[0][0]][1] = $aBetween[0]
		$aBetween = _StringBetween($sFileRead, '@import "', '.css";')
		$aData[$aData[0][0]][2] = $aBetween[0]
		$aBetween = _StringBetween($sFileRead, '/* Thumbnail size: ', ' */')
		$aData[$aData[0][0]][3] = $aBetween[0]
		$aData[0][1] &= $aData[$aData[0][0]][1] & "|"
	WEnd
	FileClose($iSearch)
	If $iSort Then
		_ArraySort($aData, 0, 1, $aData[0][0], 1)
		$aData[0][1] = ""
		For $A = 1 To $aData[0][0]
			$aData[0][1] &= $aData[$A][1] & "|"
		Next
	EndIf
	$aData[0][1] = StringTrimRight($aData[0][1], 1)

	Return $aData
EndFunc   ;==>__ThemeGallery_Array

Func __ThemeGallery_Current($aThemes, $sCurrentName, $iParam = 0)
	#cs
		Description: Get Parameter Related To The Current Theme.
		Returns: Parameter.
	#ce
	For $A = 1 To $aThemes[0][0]
		If $aThemes[$A][1] = $sCurrentName Then
			Return $aThemes[$A][$iParam]
		EndIf
	Next

	Return ""
EndFunc   ;==>__ThemeGallery_Current
