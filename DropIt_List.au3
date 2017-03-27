
; List funtions of DropIt

#include-once
#include "DropIt_General.au3"
#include "DropIt_Global.au3"
#include "Lib\udf\APIConstants.au3"
#include "Lib\udf\DropIt_LibFiles.au3"
#include "Lib\udf\DropIt_LibVarious.au3"
#include "Lib\udf\HashForFile.au3"
#include "Lib\udf\MPDF.au3"
#include "Lib\udf\WinAPIEx.au3"

Global $G_List_NumberProperties = 34

Func __List_GetProperty($lNumber, $lTranslated = 1)
	#cs
		Description: Get Property Name Associated To The Property Number.
		Returns: Property [Full Name]
	#ce
	Local $lProperty, $lError = 0

	Switch $lNumber
		Case 0
			$lProperty = '#'
		Case 1
			$lProperty = 'Full Name'
		Case 2
			$lProperty = 'Directory'
		Case 3
			$lProperty = 'Size'
		Case 4
			$lProperty = 'Name'
		Case 5
			$lProperty = 'Extension'
		Case 6
			$lProperty = 'Drive'
		Case 7
			$lProperty = 'MD5 Hash'
		Case 8
			$lProperty = 'SHA-1 Hash'
		Case 9
			$lProperty = "Absolute Link"
		Case 10
			$lProperty = "Relative Link"
		Case 11
			$lProperty = 'Type'
		Case 12
			$lProperty = 'Date Created'
		Case 13
			$lProperty = 'Date Modified'
		Case 14
			$lProperty = 'Date Opened'
		Case 15
			$lProperty = 'Date Taken'
		Case 16
			$lProperty = 'Attributes'
		Case 17
			$lProperty = 'Owner'
		Case 18
			$lProperty = 'Dimensions'
		Case 19
			$lProperty = 'Camera Model'
		Case 20
			$lProperty = 'Authors'
		Case 21
			$lProperty = 'Artists'
		Case 22
			$lProperty = 'Title'
		Case 23
			$lProperty = 'Album'
		Case 24
			$lProperty = 'Genre'
		Case 25
			$lProperty = 'Year'
		Case 26
			$lProperty = 'Track'
		Case 27
			$lProperty = 'Subject'
		Case 28
			$lProperty = 'Categories'
		Case 29
			$lProperty = 'Comments'
		Case 30
			$lProperty = 'Copyright'
		Case 31
			$lProperty = 'Duration'
		Case 32
			$lProperty = 'Bit Rate'
		Case 33
			$lProperty = 'CRC Hash'
		Case 34
			$lProperty = 'MD4 Hash'
		Case Else
			$lProperty = ''
			$lError = 1
	EndSwitch

	If $lProperty <> "" And $lNumber > 0 And $lTranslated Then
		$lProperty = __GetLang('LIST_LABEL_' & $lNumber, $lProperty)
	EndIf

	Return SetError($lError, 0, $lProperty)
EndFunc   ;==>__List_GetProperty

Func __List_Properties($lFilePath, $lListPath, $lStringProperties, $lTranslated = 1)
	#cs
		Description: Get Properties Of The File/Folder.
		Returns: $Array[?] - Array Contains Some Of The Supported Properties.
		[0] - Row Names [Full Name|Directory|Size]
		[1] - Full Name [Text.txt]
		[2] - Directory [C:\Folder]
		[3] - Size [20 MB]
	#ce
	Local $lMoreProperties[23] = [22, 2, 4, 3, 5, 9, 6, 8, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24] ; Properties From 11 To 32.
	Local $lProperties = StringSplit($lStringProperties, ";")
	Local $lString, $lCount = $lProperties[0]
	$lProperties[0] = ""
	For $A = 1 To $lCount
		$lString = __List_GetProperty($lProperties[$A], $lTranslated)
		If @error = 0 Then ; Supported Number.
			$lProperties[0] &= $lString & ";"
			Switch $lProperties[$A]
				Case 0
					$lProperties[$A] = "#"
				Case 1
					$lProperties[$A] = __GetFileName($lFilePath)
				Case 2
					$lProperties[$A] = __GetParentFolder($lFilePath)
				Case 3
					$lProperties[$A] = __ByteSuffix(__GetFileSize($lFilePath))
				Case 4
					$lProperties[$A] = __GetFileNameOnly($lFilePath)
				Case 5
					$lProperties[$A] = __GetFileExtension($lFilePath)
				Case 6
					$lProperties[$A] = __GetDrive($lFilePath)
				Case 7
					$lProperties[$A] = __MD5ForFile($lFilePath)
				Case 8
					$lProperties[$A] = __SHA1ForFile($lFilePath)
				Case 33
					$lProperties[$A] = __CRC32ForFile($lFilePath)
				Case 34
					$lProperties[$A] = __MD4ForFile($lFilePath)
				Case 9
					$lProperties[$A] = $lFilePath
				Case 10
					$lProperties[$A] = __GetRelativePath($lFilePath, $lListPath)
					If @error Then
						$lProperties[$A] = ""
					EndIf
				Case 12
					$lProperties[$A] = __GetFileTimeFormatted($lFilePath, 1)
				Case 13
					$lProperties[$A] = __GetFileTimeFormatted($lFilePath, 0)
				Case 14
					$lProperties[$A] = __GetFileTimeFormatted($lFilePath, 2)
				Case Else
					$lProperties[$A] = __GetFileProperties($lFilePath, $lMoreProperties[$lProperties[$A] - 10])
			EndSwitch
		EndIf
	Next
	$lProperties[0] = StringTrimRight($lProperties[0], 1) ; To Remove The Last ";" Character.

	Return $lProperties
EndFunc   ;==>__List_Properties

Func __List_WriteHTML($lSubArray, $lListPath, $lElementsGUI, $lStringProperties, $lProfile, $lRules, $lListName, $lTheme) ; Inspired By: http://www.autoitscript.com/forum/topic/124516-guictrllistview-savehtml-exports-the-details-of-a-listview-to-a-html-file/
	#cs
		Description: Write An Array To HTML File.
		Returns: 1
	#ce
	Local $lFileOpen, $lArray, $lStringSplit, $lString, $lContent

	$lArray = __List_Properties($lSubArray[1], $lListPath, $lStringProperties) ; Get Headers From The First Item.
	$lStringSplit = StringSplit($lArray[0], ";")

	If FileExists(@ScriptDir & "\Lib\list\themes\" & $lTheme & ".css") = 0 Then
		$lTheme = "Default"
	EndIf
	Local $lStyle, $lLoadCSS, $lArrayCSS[4] = [3, "base.css", "lighterbox2.css", "themes\" & $lTheme & ".css"]
	For $A = 1 To $lArrayCSS[0]
		If $A = 2 And __Is("ListLightbox") = 0 Then ; Lightbox Disabled.
			ContinueLoop
		EndIf
		$lStyle = FileRead(@ScriptDir & "\Lib\list\" & $lArrayCSS[$A])
		If @error Then
			Return SetError(1, 0, 0)
		EndIf
		$lLoadCSS &= @CRLF & $lStyle & @CRLF
	Next

	Local $lHeader = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' & @CRLF & _
			'<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en"><head>' & @CRLF & _
			'<meta http-equiv="content-type" content="text/html; charset=UTF-8" />' & @CRLF & _
			'<title>' & $lListName & '</title>' & @CRLF & @CRLF & _
			'<style type="text/css"> ' & $lLoadCSS & '</style>' & @CRLF & _
			'</head>' & @CRLF & @CRLF & _
			'<body>' & @CRLF & _
			'<div id="dropitList">' & @CRLF & @CRLF & _
			'<div id="di-bg-header"></div>' & @CRLF & @CRLF & _
			'<div id="di-container">' & @CRLF & @CRLF & _
			'<div id="di-main-wrap">' & @CRLF & @CRLF & _
			'<div id="di-header-wrap">' & @CRLF & @CRLF & _
			'<div id="di-header">' & @CRLF & _
			@TAB & '<h1>' & $lListName & '</h1>' & @CRLF & _
			@TAB & '<ul id="di-infoline">' & @CRLF & _
			@TAB & @TAB & '<li><strong>' & __GetLang('LIST_HTML_CREATED', 'Created') & '</strong>: ' & @MDAY & '/' & @MON & '/' & @YEAR & ' ' & @HOUR & ':' & @MIN & '</li>' & @CRLF & _
			@TAB & @TAB & '<li><strong>' & __GetLang('PROFILE', 'Profile') & '</strong>: ' & $lProfile & '</li>' & @CRLF & _
			@TAB & @TAB & '<li><strong>' & __GetLang('RULES', 'Rules') & '</strong>: ' & $lRules & '</li>' & @CRLF & _
			@TAB & @TAB & '<li class="di-last"><strong>' & __GetLang('LIST_HTML_TOTAL', 'Total') & '</strong>: <span id="di-count">' & $lSubArray[0] & '</span></li>' & @CRLF & _
			@TAB & '</ul>' & @CRLF & _
			'</div><!-- #di-header -->' & @CRLF & _
			'</div><!-- #di-header-wrap -->' & @CRLF & @CRLF

	Local $lColumns = '<div id="di-table">' & @CRLF & _
			'<table id="di-mainTable" cellpadding="0" cellspacing="0">' & @CRLF & _
			'<thead>' & @CRLF & '<tr>' & @CRLF
	For $B = 1 To $lStringSplit[0]
		Switch $lStringSplit[$B]
			Case "#"
				$lColumns &= @TAB & '<th class="di-right">&nbsp;</th>' & @CRLF
			Case Else
				$lColumns &= @TAB & '<th>' & $lStringSplit[$B] & '</th>' & @CRLF
		EndSwitch
	Next
	$lColumns &= '</tr>' & @CRLF & '</thead>' & @CRLF

	Local $lJavaScript, $lLoadJS, $lArrayJS[4][2] = [[3, 3],["ListSortable", "sortable.js"],["ListFilter", "filter.js"],["ListLightbox", "lighterbox2.js"]]
	For $A = 1 To $lArrayJS[0][0]
		If __Is($lArrayJS[$A][0]) Then
			Switch $A
				Case 2 ; ListFilter Translation.
					$lJavaScript = 'var clearFilterText = "' & __GetLang('LIST_HTML_CLEARFILTER', 'clear filter') & '";' & @CRLF & _
							'var noResultsText = "' & __GetLang('LIST_HTML_NORESULTS', 'No results for this term') & ':";' & @CRLF & _
							'var searchFieldText = "' & __GetLang('LIST_HTML_FILTER', 'filter') & '...";' & @CRLF & @CRLF
				Case 3 ; ListLightbox Translation.
					$lJavaScript = 'var viewText = "' & __GetLang('VIEW', 'View') & '";' & @CRLF & @CRLF
			EndSwitch
			$lJavaScript &= FileRead(@ScriptDir & "\Lib\list\" & $lArrayJS[$A][1])
			If @error = 0 Then
				$lLoadJS &= '<script type="text/javascript" charset="utf-8">' & @CRLF & '//<![CDATA[' & @CRLF & $lJavaScript & @CRLF & '//]]>' & @CRLF & '</script>' & @CRLF
			EndIf
			$lJavaScript = ""
		EndIf
	Next
	If $lLoadJS <> "" Then ; Add Code To Correctly Load JavaScript.
		$lLoadJS = '<script type="text/javascript" charset="utf-8">' & @CRLF & _
				'function addLoadEvent(func) {' & @CRLF & _
				@TAB & 'var oldonload = window.onload;' & @CRLF & _
				@TAB & @TAB & 'if (typeof window.onload != "function") {' & @CRLF & _
				@TAB & @TAB & @TAB & 'window.onload = func' & @CRLF & _
				@TAB & @TAB & '} else {' & @CRLF & _
				@TAB & @TAB & @TAB & 'window.onload = function() {' & @CRLF & _
				@TAB & @TAB & @TAB & @TAB & 'if (oldonload) {' & @CRLF & _
				@TAB & @TAB & @TAB & @TAB & @TAB & 'oldonload()' & @CRLF & _
				@TAB & @TAB & @TAB & @TAB & '}' & @CRLF & _
				@TAB & @TAB & @TAB & 'func()' & @CRLF & _
				@TAB & @TAB & '}' & @CRLF & _
				@TAB & '}' & @CRLF & _
				'}' & @CRLF & _
				'</script>' & @CRLF & $lLoadJS
	EndIf

	For $A = 1 To $lSubArray[0]
		$lArray = __List_Properties($lSubArray[$A], $lListPath, $lStringProperties)
		$lString = ""
		For $B = 1 To $lStringSplit[0]
			If $lArray[$B] = "" Then
				$lArray[$B] = "-"
			EndIf
			Switch $lStringSplit[$B]
				Case __GetLang('LIST_LABEL_9', 'Absolute Link')
					$lString &= @TAB & '<td class="di-center"><a href="file:///' & $lArray[$B] & '" target="_blank">' & __GetLang('LINK', 'Link') & '</a></td>' & @CRLF
				Case __GetLang('LIST_LABEL_10', 'Relative Link')
					$lString &= @TAB & '<td class="di-center"><a href="' & StringReplace($lArray[$B], "\", "/") & '" target="_blank">' & __GetLang('LINK', 'Link') & '</a></td>' & @CRLF
				Case __GetLang('LIST_LABEL_3', 'Size')
					$lString &= @TAB & '<td class="di-right">' & $lArray[$B] & '</td>' & @CRLF
				Case "#"
					$lString &= @TAB & '<td class="di-right">' & $A & '</td>' & @CRLF
				Case Else
					$lString &= @TAB & '<td>' & $lArray[$B] & '</td>' & @CRLF
			EndSwitch
		Next
		$lContent &= '<tr>' & @CRLF & $lString & '</tr>' & @CRLF
		__SetProgressResult($lElementsGUI, __GetFileSize($lSubArray[$A]))
	Next

	Local $lFooter = '<tbody>' & @CRLF & $lContent & @CRLF & '</tbody>' & @CRLF & '</table>' & @CRLF & '</div><!-- #table -->' & @CRLF & @CRLF & _
			'</div><!-- #di-main-wrap -->' & @CRLF & @CRLF & _
			'<div id="di-footer-wrap">' & @CRLF & _
			@TAB & '<div id="di-footer">' & @CRLF & _
			@TAB & '<p>' & @CRLF & _
			@TAB & @TAB & StringReplace(__GetLang('LIST_HTML_GENERATED', 'Generated with %DropItWebLink%', 1), '%DropItWebLink%', '<a id="di-homeLink" href="%DropItURL%" title="' & __GetLang('LIST_HTML_VISIT', 'Visit DropIt website') & '" target="_blank">DropIt</a>') & '<span> - ' & __GetLang('TITLE_TOOLTIP', 'Process your files with a drop!') & '</span>' & @CRLF & _
			@TAB & '</p>' & @CRLF & _
			@TAB & '<a id="di-top" href="#" title="' & __GetLang('LIST_HTML_GO_TOP', 'Go to top') & '">' & __GetLang('LIST_HTML_TOP', 'top') & '</a>' & @CRLF & _
			@TAB & '</div><!-- #di-footer -->' & @CRLF & _
			'</div><!-- #di-footer-wrap -->' & @CRLF & @CRLF & _
			'</div><!-- #di-container -->' & @CRLF & @CRLF & _
			'</div><!-- #dropitList -->' & @CRLF & @CRLF

	$lFileOpen = FileOpen($lListPath, 2 + 8 + 128)
	FileWrite($lFileOpen, $lHeader & $lColumns & $lFooter & $lLoadJS & @CRLF & '</body>' & @CRLF & '</html>')
	FileClose($lFileOpen)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	Return 1
EndFunc   ;==>__List_WriteHTML

Func __List_WritePDF($lSubArray, $lListPath, $lElementsGUI, $lStringProperties, $lListName)
	#cs
		Description: Write An Array To PDF File.
		Returns: 1
	#ce
	Local $lArray, $lStringSplit, $lText

	$lArray = __List_Properties($lSubArray[1], $lListPath, $lStringProperties) ; Get Headers From The First Item.
	$lStringSplit = StringSplit($lArray[0], ";")

	For $B = 1 To $lStringSplit[0]
		$lText &= $lStringSplit[$B] & @CRLF
	Next
	$lText &= @CRLF
	For $A = 1 To $lSubArray[0]
		$lArray = __List_Properties($lSubArray[$A], $lListPath, $lStringProperties, 0)
		For $B = 1 To $lStringSplit[0]
			If $lStringSplit[$B] == "#" Then
				$lArray[$B] = $A
			ElseIf $lArray[$B] = "" Then
				$lArray[$B] = "-"
			EndIf
			$lText &= $lArray[$B] & @CRLF
		Next
		$lText &= @CRLF
		__SetProgressResult($lElementsGUI, __GetFileSize($lSubArray[$A]))
	Next

	_SetTitle($lListName)
	;_SetSubject()
	;_SetKeywords()
	_OpenAfter(False)
	_SetUnit($PDF_UNIT_CM)
	_SetPaperSize("A4")
	_SetZoomMode($PDF_ZOOM_CUSTOM, 90)
	_SetOrientation($PDF_ORIENTATION_PORTRAIT)
	_SetLayoutMode($PDF_LAYOUT_CONTINOUS)
	_InitPDF($lListPath)
	_LoadFontTT("F1", $PDF_FONT_CALIBRI)
	__Text2PDF($lText, "F1")
	_ClosePDFFile()

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__List_WritePDF

Func __List_WriteTEXT($lSubArray, $lListPath, $lElementsGUI, $lStringProperties, $lDelimiter = ',', $lQuote = '"') ; Inspired By: http://www.autoitscript.com/forum/topic/129250-guictrllistview-savecsv-exports-the-details-of-a-listview-to-a-csv-file/
	#cs
		Description: Write An Array To TXT Or CSV File.
		Returns: 1
	#ce
	Local $lFileOpen, $lArray, $lStringSplit, $lString

	$lArray = __List_Properties($lSubArray[1], $lListPath, $lStringProperties) ; Get Headers From The First Item.
	$lStringSplit = StringSplit($lArray[0], ";")

	If __Is("ListHeader") Then
		For $B = 1 To $lStringSplit[0]
			If $lQuote <> '' Then
				$lStringSplit[$B] = StringReplace($lStringSplit[$B], $lQuote, $lQuote & $lQuote, 0, 1)
			EndIf
			$lString &= $lQuote & $lStringSplit[$B] & $lQuote
			If $B < $lStringSplit[0] Then
				$lString &= $lDelimiter
			EndIf
		Next
		$lString &= @CRLF & @CRLF
	EndIf

	For $A = 1 To $lSubArray[0]
		$lArray = __List_Properties($lSubArray[$A], $lListPath, $lStringProperties)
		For $B = 1 To $lStringSplit[0]
			If $lStringSplit[$B] == "#" Then
				$lArray[$B] = $A
			EndIf
			If $lQuote <> '' Then
				$lArray[$B] = StringReplace($lArray[$B], $lQuote, $lQuote & $lQuote, 0, 1)
			EndIf
			$lString &= $lQuote & $lArray[$B] & $lQuote
			If $B < $lStringSplit[0] Then
				$lString &= $lDelimiter
			EndIf
		Next
		$lString &= @CRLF
		__SetProgressResult($lElementsGUI, __GetFileSize($lSubArray[$A]))
	Next

	$lFileOpen = FileOpen($lListPath, 2 + 8 + 128)
	FileWrite($lFileOpen, $lString)
	FileClose($lFileOpen)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	Return 1
EndFunc   ;==>__List_WriteTEXT

Func __List_WriteXML($lSubArray, $lListPath, $lElementsGUI, $lStringProperties) ; Inspired By: http://www.autoitscript.com/forum/topic/129432-guictrllistview-savexml-exports-the-details-of-a-listview-to-a-xml-file/
	#cs
		Description: Write An Array To XML File.
		Returns: 1
	#ce
	Local $lFileOpen, $lArray, $lStringSplit, $lString

	$lArray = __List_Properties($lSubArray[1], $lListPath, $lStringProperties, 0) ; Get Headers From The First Item.
	$lStringSplit = StringSplit($lArray[0], ";")

	$lString = '<?xml version="1.0" encoding="UTF-8" ?>' & @CRLF & '<listview rows="' & $lSubArray[0] & '" cols="' & $lStringSplit[0] & '">' & @CRLF
	For $A = 1 To $lSubArray[0]
		$lArray = __List_Properties($lSubArray[$A], $lListPath, $lStringProperties, 0)
		$lString &= @TAB & '<item>' & @CRLF
		For $B = 1 To $lStringSplit[0]
			If $lStringSplit[$B] == "#" Or $lStringSplit[$B] == "n" Then
				$lStringSplit[$B] = "n"
				$lArray[$B] = $A
			ElseIf $lArray[$B] = "" Then
				$lArray[$B] = "-"
			EndIf
			$lStringSplit[$B] = StringReplace(StringLower($lStringSplit[$B]), " ", "_")
			$lString &= @TAB & @TAB & '<' & $lStringSplit[$B] & '>' & $lArray[$B] & '</' & $lStringSplit[$B] & '>' & @CRLF
		Next
		$lString &= @TAB & '</item>' & @CRLF
		__SetProgressResult($lElementsGUI, __GetFileSize($lSubArray[$A]))
	Next
	$lString &= '</listview>'

	$lFileOpen = FileOpen($lListPath, 2 + 8 + 128)
	FileWrite($lFileOpen, $lString)
	FileClose($lFileOpen)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__List_WriteXML

Func __List_WriteXLS($lSubArray, $lListPath, $lElementsGUI, $lStringProperties) ; Inspired By: http://www.autoitscript.com/forum/topic/131866-arraytoxls-save-1d2d-array-to-excel-file-xls/
	#cs
		Description: Write An Array To XLS File.
		Returns: 1
	#ce
	Local $lArray, $lStringSplit, $hFile, $nBytes, $str_bof, $str_eof

	$lArray = __List_Properties($lSubArray[1], $lListPath, $lStringProperties, 0) ; Get Headers From The First Item.
	$lStringSplit = StringSplit($lArray[0], ";")

	$hFile = _WinAPI_CreateFile($lListPath, 1)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	$str_bof = DllStructCreate('short;short;short;short;short;short')
	DllStructSetData($str_bof, 1, 0x809)
	DllStructSetData($str_bof, 2, 0x8)
	DllStructSetData($str_bof, 3, 0x0)
	DllStructSetData($str_bof, 4, 0x10)
	DllStructSetData($str_bof, 5, 0x0)
	DllStructSetData($str_bof, 6, 0x0)
	_WinAPI_WriteFile($hFile, DLLStructGetPtr($str_bof), DllStructGetSize($str_bof), $nBytes)

	For $B = 1 To $lStringSplit[0]
		__XLSWriteCell($hFile, 0, $B - 1, $lStringSplit[$B])
	Next
	For $A = 1 To $lSubArray[0]
		$lArray = __List_Properties($lSubArray[$A], $lListPath, $lStringProperties, 0)
		For $B = 1 To $lStringSplit[0]
			If $lStringSplit[$B] == "#" Then
				$lArray[$B] = $A
			ElseIf $lArray[$B] = "" Then
				$lArray[$B] = "-"
			EndIf
			__XLSWriteCell($hFile, $A, $B - 1, $lArray[$B])
		Next
		__SetProgressResult($lElementsGUI, __GetFileSize($lSubArray[$A]))
	Next

	$str_eof = DllStructCreate('short;short')
	DllStructSetData($str_eof, 1, 0x0A)
	DllStructSetData($str_eof, 2, 0x0)
	_WinAPI_WriteFile($hFile, DLLStructGetPtr($str_eof), DllStructGetSize($str_eof), $nBytes)
	_WinAPI_CloseHandle($hFile)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__List_WriteXLS

Func __Text2PDF($sText, $sFontAlias, $iMarginX = 2, $iMarginY = 1.5, $iLineHeight = 0.5) ; Internal Function For __List_WritePDF()
	Local $iUnit = _GetUnit()
	Local $iPaperHeight = _GetPageHeight() / $iUnit
	Local $iPaperWidth = _GetPageWidth() / $iUnit
	Local $iHeight = $iPaperHeight - (2 * $iMarginY)
	Local $iWidth = $iPaperWidth - (2 * $iMarginX)
	Local $iLinesPerPage = Floor($iHeight / $iLineHeight)
	Local $aLines = StringSplit($sText & @CRLF, @CRLF, 1)
	Local $iNrPages = Ceiling($aLines[0] / $iLinesPerPage)
	Local $sLength, $iCurrent, $iX, $iY
	For $iPage = 1 To $iNrPages
		_BeginPage()
		_DrawText($iPaperWidth - 1.5, 1, $iPage, $sFontAlias, 10, $PDF_ALIGN_CENTER)
		For $iLine = 1 To $iLinesPerPage
			$iCurrent = $iLine + ($iPage - 1) * $iLinesPerPage
			If $iCurrent > $aLines[0] Then
				ExitLoop
			EndIf
			$iX = $iMarginX
			$iY = $iMarginY + $iHeight - ($iLineHeight * $iLine)
			$sLength = Round(_GetTextLength($aLines[$iCurrent], $sFontAlias, 10))
			If $sLength > $iWidth - 1 Then
				_SetTextHorizontalScaling(Ceiling($iWidth * 100 / $sLength))
				_DrawText($iX, $iY, $aLines[$iCurrent], $sFontAlias, 10, $PDF_ALIGN_LEFT)
				_SetTextHorizontalScaling(100)
			Else
				_DrawText($iX, $iY, $aLines[$iCurrent], $sFontAlias, 10, $PDF_ALIGN_LEFT)
			EndIf
		Next
		_EndPage()
	Next
EndFunc   ;==>__Text2PDF

Func __XLSWriteCell($hFile, $Row, $Col, $Value) ; Internal Function For __List_WriteXLS()
	Local $nBytes, $Len, $str_cell, $tBuffer
	$Value = String($Value)
	$Len = StringLen($Value)
	$str_cell = DllStructCreate('short;short;short;short;short;short')
	DllStructSetData($str_cell, 1, 0x204)
	DllStructSetData($str_cell, 2, 8 + $Len)
	DllStructSetData($str_cell, 3, $Row)
	DllStructSetData($str_cell, 4, $Col)
	DllStructSetData($str_cell, 5, 0x0)
	DllStructSetData($str_cell, 6, $Len)
	_WinAPI_WriteFile($hFile, DLLStructGetPtr($str_cell), DllStructGetSize($str_cell), $nBytes)
	$tBuffer = DLLStructCreate("byte[" & $Len & "]")
	DLLStructSetData($tBuffer, 1, $Value)
	_WinAPI_WriteFile($hFile, DLLStructGetPtr($tBuffer), $Len, $nBytes)
EndFunc  ; ==> __XLSWriteCell
