
; List funtions of DropIt

#include-once
#include <WinAPI.au3>

#include "DropIt_Abbreviation.au3"
#include "DropIt_General.au3"
#include "DropIt_Global.au3"
#include "Lib\udf\DropIt_LibFiles.au3"
#include "Lib\udf\DropIt_LibVarious.au3"
#include "Lib\udf\HashForFile.au3"
#include "Lib\udf\MPDF.au3"

Func __ConvertListProperties($cListProperties, $cProfileName, $cAssociationName)
	#cs
		Description: Convert List Properties To The New Syntax.
		Returns: Properties String
	#ce
	Local $cTitle, $cValue
	Local $cProfile = __IsProfile($cProfileName, 1) ; Get Current Profile Path.
	Local $cStringSplit = StringSplit($cListProperties, ";")
	$cListProperties = ""

	For $A = 1 To $cStringSplit[0]
		Switch $cStringSplit[$A]
			Case 0
				$cTitle = "#"
				$cValue = "%Counter%"
			Case 1
				$cTitle = __GetLang('LIST_LABEL_1', 'Full Name')
				$cValue = "%FileNameExt%"
			Case 2
				$cTitle = __GetLang('LIST_LABEL_2', 'Directory')
				$cValue = "%ParentDir%"
			Case 3
				$cTitle = __GetLang('LIST_LABEL_3', 'Size')
				$cValue = "%FileSize%"
			Case 4
				$cTitle = __GetLang('LIST_LABEL_4', 'Name')
				$cValue = "%FileName%"
			Case 5
				$cTitle = __GetLang('LIST_LABEL_5', 'Extension')
				$cValue = "%FileExt%"
			Case 6
				$cTitle = __GetLang('LIST_LABEL_6', 'Drive')
				$cValue = "%FileDrive%"
			Case 7
				$cTitle = __GetLang('LIST_LABEL_7', 'MD5 Hash')
				$cValue = "%MD5%"
			Case 8
				$cTitle = __GetLang('LIST_LABEL_8', 'SHA-1 Hash')
				$cValue = "%SHA1%"
			Case 9
				$cTitle = __GetLang('LIST_LABEL_9', 'Absolute Link')
				$cValue = "%LinkAbsolute%"
			Case 10
				$cTitle = __GetLang('LIST_LABEL_10', 'Relative Link')
				$cValue = "%LinkRelative%"
			Case 11
				$cTitle = __GetLang('LIST_LABEL_11', 'Type')
				$cValue = "%FileType%"
			Case 12
				$cTitle = __GetLang('LIST_LABEL_12', 'Date Created')
				$cValue = "%DateCreated%"
			Case 13
				$cTitle = __GetLang('LIST_LABEL_13', 'Date Modified')
				$cValue = "%DateModified%"
			Case 14
				$cTitle = __GetLang('LIST_LABEL_14', 'Date Opened')
				$cValue = "%DateOpened%"
			Case 15
				$cTitle = __GetLang('LIST_LABEL_15', 'Date Taken')
				$cValue = "%DateTaken%"
			Case 16
				$cTitle = __GetLang('LIST_LABEL_16', 'Attributes')
				$cValue = "%Attributes%"
			Case 17
				$cTitle = __GetLang('LIST_LABEL_17', 'Owner')
				$cValue = "%Owner%"
			Case 18
				$cTitle = __GetLang('LIST_LABEL_18', 'Dimensions')
				$cValue = "%Dimensions%"
			Case 19
				$cTitle = __GetLang('LIST_LABEL_19', 'Camera Model')
				$cValue = "%CameraModel%"
			Case 20
				$cTitle = __GetLang('LIST_LABEL_20', 'Authors')
				$cValue = "%Authors%"
			Case 21
				$cTitle = __GetLang('LIST_LABEL_21', 'Artists')
				$cValue = "%SongArtist%"
			Case 22
				$cTitle = __GetLang('LIST_LABEL_22', 'Title')
				$cValue = "%SongTitle%"
			Case 23
				$cTitle = __GetLang('LIST_LABEL_23', 'Album')
				$cValue = "%SongAlbum%"
			Case 24
				$cTitle = __GetLang('LIST_LABEL_24', 'Genre')
				$cValue = "%SongGenre%"
			Case 25
				$cTitle = __GetLang('LIST_LABEL_25', 'Year')
				$cValue = "%SongYear%"
			Case 26
				$cTitle = __GetLang('LIST_LABEL_26', 'Track')
				$cValue = "%SongTrack%"
			Case 27
				$cTitle = __GetLang('LIST_LABEL_27', 'Subject')
				$cValue = "%Subject%"
			Case 28
				$cTitle = __GetLang('LIST_LABEL_28', 'Categories')
				$cValue = "%Category%"
			Case 29
				$cTitle = __GetLang('LIST_LABEL_29', 'Comments')
				$cValue = "%Comments%"
			Case 30
				$cTitle = __GetLang('LIST_LABEL_30', 'Copyright')
				$cValue = "%Copyright%"
			Case 31
				$cTitle = __GetLang('LIST_LABEL_31', 'Duration')
				$cValue = "%Duration%"
			Case 32
				$cTitle = __GetLang('LIST_LABEL_32', 'Bit Rate')
				$cValue = "%BitRate%"
			Case 33
				$cTitle = __GetLang('LIST_LABEL_33', 'CRC Hash')
				$cValue = "%CRC%"
			Case 34
				$cTitle = __GetLang('LIST_LABEL_34', 'MD4 Hash')
				$cValue = "%MD4%"
			Case Else
				ContinueLoop
		EndSwitch
		$cListProperties &= $cTitle & ";" & $cValue & ";"
	Next
	$cListProperties = StringTrimRight($cListProperties, 1) ; To Remove The Last ";" Character.
	__IniWriteEx($cProfile, $cAssociationName, "ListProperties", $cListProperties)

	Return $cListProperties
EndFunc   ;==>__ConvertListProperties

Func __DefaultListProperties()
	#cs
		Description: Get Default List Properties.
		Returns: Properties String
	#ce
	Local $dListProperties = "#;%Counter%;" & _
		__GetLang('LIST_LABEL_1', 'Full Name') & ";%FileNameExt%;" & _
		__GetLang('LIST_LABEL_2', 'Directory') & ";%ParentDir%;" & _
		__GetLang('LIST_LABEL_3', 'Size') & ";%FileSize%;" & _
		__GetLang('LIST_LABEL_9', 'Absolute Link') & ";%LinkAbsolute%;" & _
		__GetLang('LIST_LABEL_13', 'Date Modified') & ";%DateModified%"
	Return $dListProperties
EndFunc   ;==>__DefaultListProperties

Func __GetDefaultListSettings()
	Local $sDefaultSettings = "True;True;True;True"
	Return $sDefaultSettings
EndFunc   ;==>__GetDefaultListSettings

Func __List_GetProperties($lStringProperties, $lGetValues = 0)
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
EndFunc   ;==>__List_GetProperties

Func __List_ReplaceAbbreviations($lString, $lFilePath, $lListPath, $lProfile, $lCounter)
	Local $lRelativePath

	If StringInStr($lString, "%LinkAbsolute%") Then
		$lString = StringReplace($lString, "%LinkAbsolute%", $lFilePath)
	EndIf
	If StringInStr($lString, "%LinkRelative%") Then
		$lRelativePath = __GetRelativePath($lFilePath, $lListPath)
		If @error Then
			$lRelativePath = ""
		EndIf
		$lString = StringReplace($lString, "%LinkRelative%", $lRelativePath)
	EndIf
	$lString = StringReplace($lString, "%Counter%", $lCounter)
	$lString = _ReplaceAbbreviation($lString, 0, $lFilePath, $lProfile, "$8")

	Return $lString
EndFunc   ;==>__List_ReplaceAbbreviations

Func __List_WriteHTML($lSubArray, $lListPath, $lElementsGUI, $lSettings, $lStringProperties, $lProfile, $lRules, $lListName, $lTheme) ; Inspired By: http://www.autoitscript.com/forum/topic/124516-guictrllistview-savehtml-exports-the-details-of-a-listview-to-a-html-file/
	#cs
		Description: Write An Array To HTML File.
		Returns: 1
	#ce
	Local $lFileOpen, $lArray, $lString, $lRelativePath, $lTable, $lAlign
	Local $lThemeFolder = @ScriptDir & "\Lib\list\themes"
	Local $lTitleArray = __List_GetProperties($lStringProperties)
	Local $lValueArray = __List_GetProperties($lStringProperties, 1)

	If FileExists($lThemeFolder & "\" & $lTheme & ".css") = 0 Then
		$lTheme = "Default"
	EndIf
	Local $lLoadedCSS = __LoadList_CSS($lSettings, $lTheme)
	Local $lLoadedJS = __LoadList_JS($lSettings)

	Local $lHeader = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' & @CRLF & _
			'<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en"><head>' & @CRLF & _
			'<meta http-equiv="content-type" content="text/html; charset=UTF-8" />' & @CRLF & _
			'<title>' & $lListName & '</title>' & @CRLF & @CRLF & _
			'<style type="text/css"> ' & $lLoadedCSS & '</style>' & @CRLF & _
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

	Local $lColumns = '<div id="di-table">' & @CRLF & '<table id="di-mainTable" cellpadding="0" cellspacing="0">' & @CRLF
	If $lSettings[4] == "True" Then ; List Header.
		$lColumns &= '<thead>' & @CRLF & '<tr>' & @CRLF
		$lArray = $lTitleArray
		For $B = 1 To $lArray[0]
			Switch $lArray[$B]
				Case "#"
					$lColumns &= @TAB & '<th class="di-right">&nbsp;</th>' & @CRLF
				Case Else
					$lColumns &= @TAB & '<th>' & $lArray[$B] & '</th>' & @CRLF
			EndSwitch
		Next
		$lColumns &= '</tr>' & @CRLF & '</thead>' & @CRLF
	EndIf

	For $A = 1 To $lSubArray[0]
		$lArray = $lValueArray
		$lString = ''
		For $B = 1 To $lArray[0]
			$lAlign = ''
			If $lArray[$B] = "" Then
				$lArray[$B] = "-"
			ElseIf StringInStr($lArray[$B], "%") Then
				$lArray[$B] = StringReplace($lArray[$B], "%Counter%", $A)
				$lArray[$B] = _ReplaceAbbreviation($lArray[$B], 0, $lSubArray[$A], $lProfile, "$8")
				;$lArray[$B] = StringRegExpReplace($lArray[$B], '[<>"]', '')
				If StringInStr($lArray[$B], "%LinkAbsolute%") Then
					$lArray[$B] = StringReplace($lArray[$B], "%LinkAbsolute%", '<a href="file:///' & $lSubArray[$A] & '" target="_blank">' & __GetLang('LINK', 'Link') & '</a>')
					$lAlign = ' class="di-center"'
				EndIf
				If StringInStr($lArray[$B], "%LinkRelative%") Then
					$lRelativePath = __GetRelativePath($lSubArray[$A], $lListPath)
					If @error Then
						$lRelativePath = ""
					EndIf
					$lArray[$B] = StringReplace($lArray[$B], "%LinkRelative%", '<a href="' & StringReplace($lRelativePath, "\", "/") & '" target="_blank">' & __GetLang('LINK', 'Link') & '</a>')
					$lAlign = ' class="di-center"'
				EndIf
				If StringInStr($lArray[$B], "%FileSize%") Then
					$lAlign = ' class="di-right"'
				EndIf
			EndIf
			If StringIsDigit($lArray[$B]) Then
				$lAlign = ' class="di-right"'
			EndIf
			$lString &= @TAB & '<td' & $lAlign & '>' & $lArray[$B] & '</td>' & @CRLF
		Next
		$lTable &= '<tr>' & @CRLF & $lString & '</tr>' & @CRLF
		__SetProgressResult($lElementsGUI, __GetFileSize($lSubArray[$A]))
	Next

	Local $lContent = '<tbody>' & @CRLF & $lTable & @CRLF & '</tbody>' & @CRLF & '</table>' & @CRLF & '</div><!-- #table -->' & @CRLF & @CRLF & _
			'</div><!-- #di-main-wrap -->' & @CRLF & @CRLF & _
			'<div id="di-footer-wrap">' & @CRLF & _
			@TAB & '<div id="di-footer">' & @CRLF & _
			@TAB & '<p>' & @CRLF & _
			@TAB & @TAB & StringReplace(__GetLang('LIST_HTML_GENERATED', 'Generated with %DropItWebLink%', 1), '%DropItWebLink%', '<a id="di-homeLink" href="%DropItURL%" title="' & __GetLang('LIST_HTML_VISIT', 'Visit DropIt website') & '" target="_blank">DropIt</a>') & @CRLF & _
			@TAB & '</p>' & @CRLF & _
			@TAB & '<a id="di-top" href="#" title="' & __GetLang('LIST_HTML_GO_TOP', 'Go to top') & '">' & __GetLang('LIST_HTML_TOP', 'top') & '</a>' & @CRLF & _
			@TAB & '</div><!-- #di-footer -->' & @CRLF & _
			'</div><!-- #di-footer-wrap -->' & @CRLF & @CRLF & _
			'</div><!-- #di-container -->' & @CRLF & @CRLF & _
			'</div><!-- #dropitList -->' & @CRLF & @CRLF

	$lFileOpen = FileOpen($lListPath, 2 + 8 + 128)
	FileWrite($lFileOpen, $lHeader & $lColumns & $lContent & $lLoadedJS & @CRLF & '</body>' & @CRLF & '</html>')
	FileClose($lFileOpen)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	Return 1
EndFunc   ;==>__List_WriteHTML

Func __List_WritePDF($lSubArray, $lListPath, $lElementsGUI, $lSettings, $lStringProperties, $lProfile, $lListName)
	#cs
		Description: Write An Array To PDF File.
		Returns: 1
	#ce
	Local $lArray, $lText
	Local $lTitleArray = __List_GetProperties($lStringProperties)
	Local $lValueArray = __List_GetProperties($lStringProperties, 1)

	If $lSettings[4] == "True" Then ; List Header.
		$lArray = $lTitleArray
		For $B = 1 To $lArray[0]
			$lText &= $lArray[$B] & @CRLF
		Next
		$lText &= @CRLF
	EndIf

	For $A = 1 To $lSubArray[0]
		$lArray = $lValueArray
		For $B = 1 To $lArray[0]
			If $lArray[$B] = "" Then
				$lArray[$B] = "-"
			ElseIf StringInStr($lArray[$B], "%") Then
				$lArray[$B] = __List_ReplaceAbbreviations($lArray[$B], $lSubArray[$A], $lListPath, $lProfile, $A)
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

Func __List_WriteTEXT($lSubArray, $lListPath, $lElementsGUI, $lSettings, $lStringProperties, $lProfile, $lDelimiter = ',', $lQuote = '"') ; Inspired By: http://www.autoitscript.com/forum/topic/129250-guictrllistview-savecsv-exports-the-details-of-a-listview-to-a-csv-file/
	#cs
		Description: Write An Array To TXT Or CSV File.
		Returns: 1
	#ce
	Local $lFileOpen, $lArray, $lString
	Local $lTitleArray = __List_GetProperties($lStringProperties)
	Local $lValueArray = __List_GetProperties($lStringProperties, 1)

	If $lSettings[4] == "True" Then ; List Header.
		$lArray = $lTitleArray
		For $B = 1 To $lArray[0]
			If $lQuote <> '' Then
				$lArray[$B] = StringReplace($lArray[$B], $lQuote, $lQuote & $lQuote, 0, 1)
			EndIf
			$lString &= $lQuote & $lArray[$B] & $lQuote
			If $B < $lArray[0] Then
				$lString &= $lDelimiter
			EndIf
		Next
		$lString &= @CRLF & @CRLF
	EndIf

	For $A = 1 To $lSubArray[0]
		$lArray = $lValueArray
		For $B = 1 To $lArray[0]
			If StringInStr($lArray[$B], "%") Then
				$lArray[$B] = __List_ReplaceAbbreviations($lArray[$B], $lSubArray[$A], $lListPath, $lProfile, $A)
			EndIf
			If $lQuote <> '' Then
				$lArray[$B] = StringReplace($lArray[$B], $lQuote, $lQuote & $lQuote, 0, 1)
			EndIf
			$lString &= $lQuote & $lArray[$B] & $lQuote
			If $B < $lArray[0] Then
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

Func __List_WriteXML($lSubArray, $lListPath, $lElementsGUI, $lSettings, $lStringProperties, $lProfile) ; Inspired By: http://www.autoitscript.com/forum/topic/129432-guictrllistview-savexml-exports-the-details-of-a-listview-to-a-xml-file/
	#cs
		Description: Write An Array To XML File.
		Returns: 1
	#ce
	Local $lFileOpen, $lArray, $lString, $lRows = $lSubArray[0]
	Local $lTitleArray = __List_GetProperties($lStringProperties)
	Local $lValueArray = __List_GetProperties($lStringProperties, 1)

	If $lSettings[4] == "True" Then ; List Header.
		$lArray = $lTitleArray
		$lString &= @TAB & '<header>' & @CRLF
		For $B = 1 To $lArray[0]
			$lString &= @TAB & @TAB & '<title' & $B & '>' & StringRegExpReplace($lArray[$B], "[<>']", "") & '</title' & $B & '>' & @CRLF
		Next
		$lString &= @TAB & '</header>' & @CRLF
		$lRows += 1
	EndIf

	For $A = 1 To $lSubArray[0]
		$lArray = $lValueArray
		$lString &= @TAB & '<item' & $A & '>' & @CRLF
		For $B = 1 To $lArray[0]
			If $lArray[$B] = "" Then
				$lArray[$B] = "-"
			ElseIf StringInStr($lArray[$B], "%") Then
				$lArray[$B] = __List_ReplaceAbbreviations($lArray[$B], $lSubArray[$A], $lListPath, $lProfile, $A)
			EndIf
			$lString &= @TAB & @TAB & '<value' & $B & '>' & StringRegExpReplace($lArray[$B], "[<>']", "") & '</value' & $B & '>' & @CRLF
		Next
		$lString &= @TAB & '</item' & $A & '>' & @CRLF
		__SetProgressResult($lElementsGUI, __GetFileSize($lSubArray[$A]))
	Next

	$lFileOpen = FileOpen($lListPath, 2 + 8 + 128)
	FileWrite($lFileOpen, '<?xml version="1.0" encoding="UTF-8" ?>' & @CRLF & '<listview rows="' & $lRows & '" cols="' & $lArray[0] & '">' & @CRLF & $lString & '</listview>')
	FileClose($lFileOpen)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__List_WriteXML

Func __List_WriteXLS($lSubArray, $lListPath, $lElementsGUI, $lSettings, $lStringProperties, $lProfile) ; Inspired By: http://www.autoitscript.com/forum/topic/131866-arraytoxls-save-1d2d-array-to-excel-file-xls/
	#cs
		Description: Write An Array To XLS File.
		Returns: 1
	#ce
	Local $lArray, $hFile, $nBytes, $str_bof, $str_eof, $lStart = 0
	Local $lTitleArray = __List_GetProperties($lStringProperties)
	Local $lValueArray = __List_GetProperties($lStringProperties, 1)

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

	If $lSettings[4] == "True" Then ; List Header.
		$lArray = $lTitleArray
		For $B = 1 To $lArray[0]
			__XLSWriteCell($hFile, 0, $B - 1, $lArray[$B])
		Next
		$lStart = 1
	EndIf

	For $A = 1 To $lSubArray[0]
		$lArray = $lValueArray
		For $B = 1 To $lArray[0]
			If $lArray[$B] = "" Then
				$lArray[$B] = "-"
			ElseIf StringInStr($lArray[$B], "%") Then
				$lArray[$B] = __List_ReplaceAbbreviations($lArray[$B], $lSubArray[$A], $lListPath, $lProfile, $A)
			EndIf
			__XLSWriteCell($hFile, $A - 1 + $lStart, $B - 1, $lArray[$B])
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

Func __LoadList_CSS($lSettings, $lTheme) ; Internal Function For __List_WriteHTML()
	Local $lLoadedCSS, $lStyle, $lArrayCSS[4] = [3, "base.css", "lighterbox2.css", "themes\" & $lTheme & ".css"]
	For $A = 1 To $lArrayCSS[0]
		If $A = 2 And $lSettings[3] <> "True" Then ; Lightbox Disabled.
			ContinueLoop
		EndIf
		$lStyle = FileRead(@ScriptDir & "\Lib\list\" & $lArrayCSS[$A])
		If @error Then
			Return SetError(1, 0, 0)
		EndIf
		$lLoadedCSS &= @CRLF & $lStyle & @CRLF
	Next
	Return $lLoadedCSS
EndFunc   ;==>__LoadList_CSS

Func __LoadList_JS($lSettings) ; Internal Function For __List_WriteHTML()
	Local $lLoadedJS, $lJavaScript, $lArrayJS[4] = [3, "sortable.js", "filter.js", "lighterbox2.js"]
	For $A = 1 To $lArrayJS[0]
		If $lSettings[$A] == "True" Then ; 1 = HTML Sortable, 2 = HTML Filter, 3 = HTML Lightbox.
			Switch $A
				Case 2 ; HTML Filter Translation.
					$lJavaScript = 'var clearFilterText = "' & __GetLang('LIST_HTML_CLEARFILTER', 'clear filter') & '";' & @CRLF & _
							'var noResultsText = "' & __GetLang('LIST_HTML_NORESULTS', 'No results for this term') & ':";' & @CRLF & _
							'var searchFieldText = "' & __GetLang('LIST_HTML_FILTER', 'filter') & '...";' & @CRLF & @CRLF
				Case 3 ; HTML Lightbox Translation.
					$lJavaScript = 'var viewText = "' & __GetLang('VIEW', 'View') & '";' & @CRLF & @CRLF
			EndSwitch
			$lJavaScript &= FileRead(@ScriptDir & "\Lib\list\" & $lArrayJS[$A])
			If @error = 0 Then
				$lLoadedJS &= '<script type="text/javascript" charset="utf-8">' & @CRLF & '//<![CDATA[' & @CRLF & $lJavaScript & @CRLF & '//]]>' & @CRLF & '</script>' & @CRLF
			EndIf
			$lJavaScript = ""
		EndIf
	Next
	If $lLoadedJS <> "" Then ; Add Code To Correctly Load JavaScript.
		$lLoadedJS = '<script type="text/javascript" charset="utf-8">' & @CRLF & _
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
				'</script>' & @CRLF & $lLoadedJS
	EndIf
	Return $lLoadedJS
EndFunc   ;==>__LoadList_JS

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

Func __ThemeList_Combo($sFolder)
	#cs
		Description: Get Themes And Create String For Use In A Combo Box.
		Returns: String Of Themes.
	#ce
	Local $iSearch, $sFileName, $sData

	$iSearch = FileFindFirstFile($sFolder & "\*.css")
	While 1
		$sFileName = FileFindNextFile($iSearch)
		If @error Then
			ExitLoop
		EndIf
		$sData &= StringTrimRight($sFileName, 4) & "|"
	WEnd
	FileClose($iSearch)

	Return StringTrimRight($sData, 1)
EndFunc   ;==>__ThemeList_Combo

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
