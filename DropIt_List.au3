
; List funtions of DropIt

#include-once
#include <DropIt_General.au3>
#include <Lib\udf\DropIt_LibFiles.au3>
#include <Lib\udf\DropIt_LibVarious.au3>
#include <Lib\udf\HashForFile.au3>

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

Func __List_Properties($lFilePath, $lSize, $lListPath, $lStringProperties, $lTranslated = 1)
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
					$lProperties[$A] = __ByteSuffix($lSize)
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
				Case Else
					$lString = $lProperties[$A]
					$lProperties[$A] = __GetFileProperties($lFilePath, $lMoreProperties[$lString - 10])
			EndSwitch
		EndIf
	Next
	$lProperties[0] = StringTrimRight($lProperties[0], 1) ; To Remove The Last ";" Character.

	Return $lProperties
EndFunc   ;==>__List_Properties

Func __List_Write($lFilePath, $lListPath, $lSize)
	#cs
		Description: Write Properties Of A File In The Defined List.
		Returns: 1
	#ce
	Local $lStringSplit = StringSplit($lListPath, "|") ; Separate List File Path, List Properties, Profile, Rules And Association Name.
	$lListPath = $lStringSplit[1]
	Local $lListType = __GetFileExtension($lListPath)

	Switch $lListType
		Case "html", "htm"
			__List_WriteHTML($lListPath, __List_Properties($lFilePath, $lSize, $lListPath, $lStringSplit[2]), $lStringSplit[3], $lStringSplit[4], $lStringSplit[5])
		Case "txt"
			__List_WriteTEXT($lListPath, __List_Properties($lFilePath, $lSize, $lListPath, $lStringSplit[2]), '|', '')
		Case "csv"
			__List_WriteTEXT($lListPath, __List_Properties($lFilePath, $lSize, $lListPath, $lStringSplit[2]), ',', '"')
		Case "xml"
			__List_WriteXML($lListPath, __List_Properties($lFilePath, $lSize, $lListPath, $lStringSplit[2], 0))
		Case Else
			Return SetError(1, 0, 0)
	EndSwitch

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__List_Write

Func __List_WriteHTML($lListPath, $lArray, $lProfile, $lRules, $lListName) ; Inspired By: http://www.autoitscript.com/forum/topic/124516-guictrllistview-savehtml-exports-the-details-of-a-listview-to-a-html-file/
	#cs
		Description: Write An Array To HTML File.
		Returns: 1
	#ce
	Local $lFileOpen, $lFileRead, $lString, $lNumber[1] = [0], $lCurrentEnd = '<!-- Current List End -->'
	Local $lStringSplit = StringSplit($lArray[0], ";")

	If FileExists($lListPath) Then
		$lFileRead = FileRead($lListPath)
	Else
		Local $lTheme = IniRead(__IsSettingsFile(), "General", "ListTheme", "Default") ; __IsSettingsFile() = Get Default Settings INI File.
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
				@TAB & @TAB & '<li class="di-last"><strong>' & __GetLang('LIST_HTML_TOTAL', 'Total') & '</strong>: <span id="di-count">0</span></li>' & @CRLF & _
				@TAB & '</ul>' & @CRLF & _
				'</div><!-- #di-header -->' & @CRLF & _
				'</div><!-- #di-header-wrap -->' & @CRLF & @CRLF

		Local $lColumns = '<div id="di-table">' & @CRLF & _
				'<table id="di-mainTable" cellpadding="0" cellspacing="0">' & @CRLF & _
				'<thead>' & @CRLF & '<tr>' & @CRLF
		For $A = 1 To $lStringSplit[0]
			Switch $lStringSplit[$A]
				Case "#"
					$lColumns &= @TAB & '<th class="di-right">&nbsp;</th>' & @CRLF
				Case Else
					$lColumns &= @TAB & '<th>' & $lStringSplit[$A] & '</th>' & @CRLF
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

		Local $lFooter = '<tbody>' & @CRLF & $lCurrentEnd & @CRLF & '</tbody>' & @CRLF & '</table>' & @CRLF & '</div><!-- #table -->' & @CRLF & @CRLF & _
				'</div><!-- #di-main-wrap -->' & @CRLF & @CRLF & _
				'<div id="di-footer-wrap">' & @CRLF & _
				@TAB & '<div id="di-footer">' & @CRLF & _
				@TAB & '<p>' & @CRLF & _
				@TAB & @TAB & 'Generated with <a id="di-homeLink" href="%DropItURL%" title="Visit DropIt website" target="_blank">DropIt</a> <span>- Sort your files with a drop!</span>' & @CRLF & _
				@TAB & '</p>' & @CRLF & _
				@TAB & '<a id="di-top" href="#" title="Go to top">top</a>' & @CRLF & _
				@TAB & '</div><!-- #di-footer -->' & @CRLF & _
				'</div><!-- #di-footer-wrap -->' & @CRLF & @CRLF & _
				'</div><!-- #di-container -->' & @CRLF & @CRLF & _
				'</div><!-- #dropitList -->' & @CRLF & @CRLF

		$lFileRead = $lHeader & $lColumns & $lFooter & $lLoadJS & @CRLF & '</body>' & @CRLF & '</html>'
	EndIf

	$lNumber = StringRegExp($lFileRead, '<span id="di-count">(.*?)</span>', 3)
	$lFileRead = StringReplace($lFileRead, '<span id="di-count">' & $lNumber[0] & '</span>', '<span id="di-count">' & $lNumber[0] + 1 & '</span>', 0, 1)

	For $A = 1 To $lStringSplit[0]
		If $lArray[$A] = "" Then
			$lArray[$A] = "-"
		EndIf
		Switch $lStringSplit[$A]
			Case __GetLang('LIST_LABEL_9', 'Absolute Link')
				$lString &= @TAB & '<td class="di-center"><a href="file:///' & $lArray[$A] & '" target="_blank">' & __GetLang('LINK', 'Link') & '</a></td>' & @CRLF
			Case __GetLang('LIST_LABEL_10', 'Relative Link')
				$lString &= @TAB & '<td class="di-center"><a href="' & StringReplace($lArray[$A], "\", "/") & '" target="_blank">' & __GetLang('LINK', 'Link') & '</a></td>' & @CRLF
			Case __GetLang('LIST_LABEL_3', 'Size')
				$lString &= @TAB & '<td class="di-right">' & $lArray[$A] & '</td>' & @CRLF
			Case "#"
				$lString &= @TAB & '<td class="di-right">' & $lNumber[0] + 1 & '</td>' & @CRLF
			Case Else
				$lString &= @TAB & '<td>' & $lArray[$A] & '</td>' & @CRLF
		EndSwitch
	Next
	$lString = '<tr>' & @CRLF & $lString & '</tr>' & @CRLF & $lCurrentEnd
	$lFileRead = StringReplace($lFileRead, $lCurrentEnd, $lString)

	$lFileOpen = FileOpen($lListPath, 2 + 8 + 128)
	FileWrite($lFileOpen, $lFileRead)
	FileClose($lFileOpen)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__List_WriteHTML

Func __List_WriteTEXT($lListPath, $lArray, $lDelimiter = ',', $lQuote = '"') ; Inspired By: http://www.autoitscript.com/forum/topic/129250-guictrllistview-savecsv-exports-the-details-of-a-listview-to-a-csv-file/
	#cs
		Description: Write An Array To TXT Or CSV File.
		Returns: 1
	#ce
	Local $lFileOpen, $lString
	Local $lStringSplit = StringSplit($lArray[0], ";")

	If FileExists($lListPath) = 0 And __Is("ListHeader") Then
		For $A = 1 To $lStringSplit[0]
			If $lStringSplit[$A] == "#" Then
				ContinueLoop
			EndIf
			If $lQuote <> '' Then
				$lStringSplit[$A] = StringReplace($lStringSplit[$A], $lQuote, $lQuote & $lQuote, 0, 1)
			EndIf
			$lString &= $lQuote & $lStringSplit[$A] & $lQuote
			If $A < $lStringSplit[0] Then
				$lString &= $lDelimiter
			EndIf
		Next
		$lString &= @CRLF & @CRLF
	EndIf

	For $A = 1 To $lStringSplit[0]
		If $lArray[$A] == "#" Then
			ContinueLoop
		EndIf
		If $lQuote <> '' Then
			$lArray[$A] = StringReplace($lArray[$A], $lQuote, $lQuote & $lQuote, 0, 1)
		EndIf
		$lString &= $lQuote & $lArray[$A] & $lQuote
		If $A < $lStringSplit[0] Then
			$lString &= $lDelimiter
		EndIf
	Next

	$lFileOpen = FileOpen($lListPath, 1 + 8 + 128)
	FileWrite($lFileOpen, $lString & @CRLF)
	FileClose($lFileOpen)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__List_WriteTEXT

Func __List_WriteXML($lListPath, $lArray) ; Inspired By: http://www.autoitscript.com/forum/topic/129432-guictrllistview-savexml-exports-the-details-of-a-listview-to-a-xml-file/
	#cs
		Description: Write An Array To XML File.
		Returns: 1
	#ce
	Local $lFileOpen, $lFileRead, $lString, $lNumber[2] = [1], $lCurrentEnd = '</listview>'
	Local $lStringSplit = StringSplit($lArray[0], ";")

	If FileExists($lListPath) Then
		$lFileRead = FileRead($lListPath)
	Else
		$lFileRead = '<?xml version="1.0" encoding="UTF-8" ?>' & @CRLF & '<listview rows="0" cols="' & $lStringSplit[0] & '">' & @CRLF & $lCurrentEnd
	EndIf

	$lNumber = StringRegExp($lFileRead, 'rows="(.*?)"', 3)
	$lFileRead = StringReplace($lFileRead, 'rows="' & $lNumber[0] & '"', 'rows="' & $lNumber[0] + 1 & '"', 0, 1)
	$lString = @TAB & '<item>' & @CRLF
	For $A = 1 To $lStringSplit[0]
		If $lArray[$A] = "" Then
			$lArray[$A] = "-"
		EndIf
		If $lStringSplit[$A] == "#" Then
			$lStringSplit[$A] = "n"
			$lArray[$A] = $lNumber[0] + 1
		EndIf
		$lStringSplit[$A] = StringReplace(StringLower($lStringSplit[$A]), " ", "_")
		$lString &= @TAB & @TAB & '<' & $lStringSplit[$A] & '>' & $lArray[$A] & '</' & $lStringSplit[$A] & '>' & @CRLF
	Next
	$lString &= @TAB & '</item>' & @CRLF & $lCurrentEnd
	$lFileRead = StringReplace($lFileRead, $lCurrentEnd, $lString)

	$lFileOpen = FileOpen($lListPath, 2 + 8 + 128)
	FileWrite($lFileOpen, $lFileRead)
	FileClose($lFileOpen)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__List_WriteXML
