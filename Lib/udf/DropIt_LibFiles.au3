
; File funtions collected for DropIt

#include-once
#include <Array.au3>
#include <Constants.au3>
#include <Date.au3>
#include <File.au3>
#include <String.au3>
#include <WinAPIFiles.au3>

Func __FileCompareDate($sSource, $sDestination, $fDestinationIsDate = 0, $iMethod = 0) ; Modified From: http://www.autoitscript.com/forum/topic/125127-compare-file-datetime-stamps/page__p__868705#entry868705
	#cs
		Description: Check If Source File Is Newer Than Destination File [Or Given Date].
		Returns: 1 If Newer Or 0 If Equal Or -1 If Older
	#ce
	Local $iDate1, $iDate2, $iDateDiff
	$iDate1 = StringRegExpReplace(FileGetTime($sSource, $iMethod, 1), "(.{4})(.{2})(.{2})(.{2})(.{2})(.{2})", "\1/\2/\3 \4:\5:\6")
	If $fDestinationIsDate Then
		$iDate2 = $sDestination
	Else
		$iDate2 = StringRegExpReplace(FileGetTime($sDestination, $iMethod, 1), "(.{4})(.{2})(.{2})(.{2})(.{2})(.{2})", "\1/\2/\3 \4:\5:\6")
	EndIf
	$iDateDiff = _DateDiff("s", $iDate2, $iDate1)
	Select
		Case $iDateDiff > 0
			Return 1
		Case $iDateDiff = 0
			Return 0
		Case Else
			Return -1
	EndSelect
EndFunc   ;==>__FileCompareDate

Func __FileCompareSize($sSource, $sDestination, $fDestinationIsSize = 0)
	#cs
		Description: Check If Source File Is Bigger Than Destination File [Or Given Size].
		Returns: 1 If Bigger Or 0 If Equal Or -1 If Smaller
	#ce
	Local $iSize1, $iSize2, $iSizeDiff
	If _WinAPI_PathIsDirectory($sSource) Then
		$iSize1 = DirGetSize($sSource)
	Else
		$iSize1 = FileGetSize($sSource)
	EndIf
	If $fDestinationIsSize Then
		$iSize2 = $sDestination
	Else
		If _WinAPI_PathIsDirectory($sDestination) Then
			$iSize2 = DirGetSize($sDestination)
		Else
			$iSize2 = FileGetSize($sDestination)
		EndIf
	EndIf
	$iSizeDiff = $iSize1 - $iSize2
	Select
		Case $iSizeDiff > 0
			Return -1
		Case $iSizeDiff = 0
			Return 0
		Case Else
			Return 1
	EndSelect
EndFunc   ;==>__FileCompareSize

Func __FileInUse($sInput) ; Modified From: http://www.autoitscript.com/forum/topic/123160-how-to-determine-is-a-file-is-open-by-another-program/
	Local $strComputer = "localhost"
	If StringInStr($sInput, "\\") Then
		Local $aHost = _StringBetween($sInput, "\\", "\")
		If IsArray($aHost) Then
			$strComputer = $aHost[0]
		EndIf
	EndIf
	Local $objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
	If @error Then
		Return SetError(-1, 0, 0)
	EndIf
	Local $colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Process", "WQL", 0x10 + 0x20)
	If IsObj($colItems) = 0 Then
		Return SetError(-2, 0, 0)
	EndIf
	For $objItem In $colItems
		If $objItem.CommandLine = '' Or StringLeft($objItem.CommandLine, 1) = '\' Then
			ContinueLoop
		EndIf
		If $objItem.Name = $sInput Or StringInStr($objItem.CommandLine, $sInput) Then
			Return 1
		EndIf
	Next
	Return 0
EndFunc   ;==>__FileInUse

Func __FileListToArrayEx($sFilePath, $sFilter = "*") ; Taken From: _FileListToArray() & Optimised By guinness For Increase In Speed (Reduction Of 0.50ms.)
	Local $aError[1] = [0], $hSearch, $sFile, $sReturn = ""

	If FileExists($sFilePath) = 0 Then
		Return SetError(1, 0, $aError)
	EndIf
	$sFilePath = _WinAPI_PathAddBackslash($sFilePath)

	$hSearch = FileFindFirstFile($sFilePath & $sFilter)
	If $hSearch = -1 Then
		Return SetError(2, 0, $aError)
	EndIf

	While 1
		$sFile = FileFindNextFile($hSearch)
		If @error Then
			ExitLoop
		EndIf
		$sReturn &= $sFilePath & $sFile & "*"
	WEnd
	FileClose($hSearch)
	If $sReturn = "" Then
		Return SetError(3, 0, $aError)
	EndIf
	Return StringSplit(StringTrimRight($sReturn, 1), "*")
EndFunc   ;==>__FileListToArrayEx

Func __ReadDOCX($sFilePath) ; Inspired By: http://www.autoitscript.com/forum/topic/80806-reading-docx-files/
	#cs
		Description: Search for a string in a DOCX file.
		Returns: True or False
	#ce
	Local $hwnd = FileOpen($sFilePath, 16)
	Local $header = FileRead($hwnd, 2)
	FileClose($hwnd)
	If $header <> '0x504B' Then
		Return SetError(-1, 0, "")
	EndIf

	Local $Name, $UnZipName, $TempZipName, $i, $j, $k, $f_name = "~TempDoc"
	Do
		$i += 1
		$Name = @TempDir & "\" & $f_name & $i & ".zip"
	Until Not FileExists($Name)
	FileCopy($sFilePath, $Name, 9)
	Do
		$j += 1
		$UnZipName = @TempDir & "\~DocXdoc" & $j
	Until Not FileExists($UnZipName)
	DirCreate($UnZipName)
	Do
		$k += 1
		$TempZipName = @TempDir & "\Temporary Directory " & $k & " for " & $f_name & $i & ".zip"
	Until Not FileExists($TempZipName)

	Local $oApp = ObjCreate("Shell.Application")
	If Not IsObj($oApp) Then
		DirRemove($UnZipName, 1)
		FileDelete($Name)
		DirRemove($TempZipName, 1)
		Return SetError(-2, 0, "")
	EndIf
	$oApp.NameSpace($UnZipName).CopyHere($oApp.NameSpace($Name & '\word').ParseName("document.xml"), 4)

	Local $sText = FileRead($UnZipName & "\document.xml")
	DirRemove($UnZipName, 1)
	FileDelete($Name)
	DirRemove($TempZipName, 1)

	$sText = StringReplace($sText, @CRLF, "")
	$sText = StringRegExpReplace($sText, "<w:body>(.*?)</w:body>", '$1', 0)
	$sText = StringReplace($sText, "</w:p>", @CRLF)
	$sText = StringReplace($sText, "<w:cr/>", @CRLF)
	$sText = StringReplace($sText, "<w:br/>", @CRLF)
	$sText = StringReplace($sText, "<w:tab/>", @TAB)
	$sText = StringRegExpReplace($sText, "<(.*?)>", "")
	$sText = StringReplace($sText, "&lt;", "<")
	$sText = StringReplace($sText, "&gt;", ">")
	$sText = StringReplace($sText, "&amp;", "&")
	$sText = StringReplace($sText, Chr(226) & Chr(130) & Chr(172), Chr(128))
	$sText = StringReplace($sText, Chr(194) & Chr(129), Chr(129))
	$sText = StringReplace($sText, Chr(226) & Chr(128) & Chr(154), Chr(130))
	$sText = StringReplace($sText, Chr(198) & Chr(146), Chr(131))
	$sText = StringReplace($sText, Chr(226) & Chr(128) & Chr(158), Chr(132))
	$sText = StringReplace($sText, Chr(226) & Chr(128) & Chr(166), Chr(133))
	$sText = StringReplace($sText, Chr(226) & Chr(128) & Chr(160), Chr(134))
	$sText = StringReplace($sText, Chr(226) & Chr(128) & Chr(161), Chr(135))
	$sText = StringReplace($sText, Chr(203) & Chr(134), Chr(136))
	$sText = StringReplace($sText, Chr(226) & Chr(128) & Chr(176), Chr(137))
	$sText = StringReplace($sText, Chr(197) & Chr(160), Chr(138))
	$sText = StringReplace($sText, Chr(226) & Chr(128) & Chr(185), Chr(139))
	$sText = StringReplace($sText, Chr(197) & Chr(146), Chr(140))
	$sText = StringReplace($sText, Chr(194) & Chr(141), Chr(141))
	$sText = StringReplace($sText, Chr(197) & Chr(189), Chr(142))
	$sText = StringReplace($sText, Chr(194) & Chr(143), Chr(143))
	$sText = StringReplace($sText, Chr(194) & Chr(144), Chr(144))
	$sText = StringReplace($sText, Chr(226) & Chr(128) & Chr(152), Chr(145))
	$sText = StringReplace($sText, Chr(226) & Chr(128) & Chr(153), Chr(146))
	$sText = StringReplace($sText, Chr(226) & Chr(128) & Chr(156), Chr(147))
	$sText = StringReplace($sText, Chr(226) & Chr(128) & Chr(157), Chr(148))
	$sText = StringReplace($sText, Chr(226) & Chr(128) & Chr(162), Chr(149))
	$sText = StringReplace($sText, Chr(226) & Chr(128) & Chr(147), Chr(150))
	$sText = StringReplace($sText, Chr(226) & Chr(128) & Chr(148), Chr(151))
	$sText = StringReplace($sText, Chr(203) & Chr(156), Chr(152))
	$sText = StringReplace($sText, Chr(226) & Chr(132) & Chr(162), Chr(153))
	$sText = StringReplace($sText, Chr(197) & Chr(161), Chr(154))
	$sText = StringReplace($sText, Chr(226) & Chr(128) & Chr(186), Chr(155))
	$sText = StringReplace($sText, Chr(197) & Chr(147), Chr(156))
	$sText = StringReplace($sText, Chr(194) & Chr(157), Chr(157))
	$sText = StringReplace($sText, Chr(197) & Chr(190), Chr(158))
	$sText = StringReplace($sText, Chr(197) & Chr(184), Chr(159))
	For $x = 160 To 191
		$sText = StringReplace($sText, Chr(194) & Chr($x), Chr($x))
	Next
	For $x = 192 To 255
		$sText = StringReplace($sText, Chr(195) & Chr($x - 64), Chr($x))
	Next

	Return $sText
EndFunc   ;==>__ReadDOCX

Func __ReadPDF($sFilePath)
	#cs
		Description: Search for a string in a PDF file.
		Returns: True or False
	#ce
	Local $sOutput, $sPDFToTextPath = @ScriptDir & "\Lib\pdftotext\pdftotext.exe"
	Local $iPID = Run('"' & $sPDFToTextPath & '" -q "' & $sFilePath & '" -', @SystemDir, @SW_HIDE, $STDOUT_CHILD)
	If @error Then
		Return SetError(1, 0, "")
	EndIf
	While 1
		$sOutput &= StdoutRead($iPID)
		If @error Then
			ExitLoop
		EndIf
	WEnd

	Return $sOutput
EndFunc   ;==>__ReadPDF

Func __FindInFile($sFilePath, $sSearch, $iAllWords = 0, $iCaseSensitive = 0)
	#cs
		Description: Search for a string in a file.
			$iAllWords = 0 (At least one of the words), 1 (All words in casual order), 2 (Literal string)
		Returns: True or False
	#ce
	Local $sText = ''
	If _WinAPI_PathFindExtension($sFilePath) = '.pdf' Then
		$sText = __ReadPDF($sFilePath)
	ElseIf _WinAPI_PathFindExtension($sFilePath) = '.docx' Then
		$sText = __ReadDOCX($sFilePath)
	EndIf
	If $sText = '' Then
		$sText = FileRead($sFilePath)
	EndIf
	If @error Or $sText = '' Then
		Return SetError(1, 0, 0)
	EndIf

	If $iAllWords = 0 Then
		$sSearch = StringReplace($sSearch, ' ', '|')
	ElseIf $iAllWords = 1 Then
		$sSearch = '(?=.*' & StringReplace($sSearch, ' ', ')(?=.*') & ')'
		$sText = StringStripWS($sText, 8)
	EndIf
	If $iCaseSensitive = 0 Then
		$sSearch = '(?i)' & $sSearch
	EndIf

	If StringRegExp($sText, $sSearch) Then
		Return 1
	EndIf
	Return SetError(1, 0, 0)
EndFunc   ;==>__FindInFile

Func __FindInFolder($sFilePath, $sSearch, $iAllWords = 0, $iCaseSensitive = 0)
	#cs
		Description: Search for a string in files of a folder.
		Returns: True or False
	#ce
	Local $aArray = _FileListToArrayRec($sFilePath, "*", 1, 1, 0, 2)
	For $A = 1 To $aArray[0]
		If __FindInFile($aArray[$A], $sSearch, $iAllWords, $iCaseSensitive) Then
			Return 1
		EndIf
	Next
	Return SetError(1, 0, 0)
EndFunc   ;==>__FindInFolder

Func __GetDrive($sFilePath) ; Taken From: http://www.autoitscript.com/forum/topic/82954-securely-overwrite-files/
	#cs
		Description: Get The Drive Letter Of An Absolute Or Relative Path.
		Returns: Drive Letter [C]
	#ce
	If StringInStr($sFilePath, ":") Then
		Return StringRegExpReplace($sFilePath, "^.*([[:alpha:]]:).*$", "${1}\\") ; Full Or UNC Path.
	EndIf
	Return StringRegExpReplace(@WorkingDir, "^([[:alpha:]]:).*$", "${1}\\") ; Relative Path, Use Current Drive.
EndFunc   ;==>__GetDrive

Func __GetFileExtension($sFilePath)
	#cs
		Description: Get The File Extension.
		Returns: File Extension [txt]
	#ce
	Return StringTrimLeft(_WinAPI_PathFindExtension($sFilePath), 1)
EndFunc   ;==>__GetFileExtension

Func __GetFileName($sFilePath)
	#cs
		Description: Get The File Name From A File Path.
		Returns: File Name [FileName.txt] Or Empty String If @error
	#ce
	Return _WinAPI_PathStripPath($sFilePath)
EndFunc   ;==>__GetFileName

Func __GetFileNameOnly($sFilePath)
	#cs
		Description: Get The File Name Only From A File Path.
		Returns: File Name [FileName]
	#ce
	Return _WinAPI_PathStripPath(_WinAPI_PathRemoveExtension($sFilePath))
EndFunc   ;==>__GetFileNameOnly

Func __GetFileSize($sFilePath)
	#cs
		Description: Get The File/Folder Size.
		Returns: Size [1024]
	#ce
	If _WinAPI_PathIsDirectory($sFilePath) Then
		Return DirGetSize($sFilePath)
	EndIf
	Return FileGetSize($sFilePath)
EndFunc   ;==>__GetFileNameOnly

Func __GetFileTimeFormatted($sFilePath, $iTimeCode)
	#cs
		Description: Get The Date And Time In Standard Format.
		Returns: Date And Time [YYYY/MM/DD HH:MM]
	#ce
	Local $aTime = FileGetTime($sFilePath, $iTimeCode)
	If @error Then
		Return SetError(1, 0, "")
	EndIf
	Return $aTime[0] & "/" & $aTime[1] & "/" & $aTime[2] & " " & $aTime[3] & ":" & $aTime[4]
EndFunc   ;==>__GetFileTimeFormatted

Func __GetParentFolder($sFilePath)
	#cs
		Description: Get The Parent Folder.
		Returns: Parent Folder [C:\Program Files\Test] Or Empty String If @error
	#ce
	Return _WinAPI_PathRemoveFileSpec($sFilePath)
EndFunc   ;==>__GetParentFolder

Func __GetFileProperties($gFilePath, $gPropertyNumber = 0, $gMode = 0) ; Modified Version Of A Melba23's Function - http://www.autoitscript.com/forum/topic/109450-file-properties/
	#cs
		Description: Get The Defined File Property.
		Returns: Defined Property E.G. File Name [FileName.txt]

		Modes:
		0 = Get File Property Value Using Global Numeration,
		1 = Get File Property Value Using System Numeration,
		2 = Get File Property Name And Value Using System Numeration.

		Supported Global Numeration:
		0 Name, 1 Size, 2 Type, 3 Date Modified, 4 Date Created, 5 Date Opened, 6 Attributes, 7 Status, 8 Owner, 9 Date Taken,
		10 Dimensions, 11 Camera Model, 12 Authors, 13 Artists, 14 Title, 15 Album, 16 Genre, 17 Year, 18 Track Number,
		19 Subject, 20 Category, 21 Comments, 22 Copyright, 23 Duration, 24 Bit Rate, 25 Camera Maker, 26 Company.
		This Numeration Is Automatically Converted For Win2000, WinXP, Win2003, WinVista, Win7, Win8, Win8.1.
		More Properties And Relative Numeration Are Reported At The AutoIt Webpage.
	#ce
	Local $gFileName, $gFileDir, $gObjShell, $gObjFolder, $gObjFile, $gFileProperty, $gFileProperties[2]

	If $gMode = 0 Then
		Local $gArrayWin2000[27] = [0, 1, 2, 3, 6, 7, 4, 100, 8, 100, 100, 100, 10, 100, 11, 100, 100, 100, 100, 12, 13, 5, 15, 33, 30, 100, 100]
		Local $gArrayWinXP[27] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 25, 26, 24, 9, 16, 10, 17, 20, 18, 19, 11, 12, 14, 15, 21, 22, 100, 100]
		Local $gArrayWin7[27] = [0, 1, 2, 3, 4, 5, 6, 7, 10, 12, 31, 30, 20, 13, 21, 14, 16, 15, 26, 22, 23, 24, 25, 27, 28, 32, 33]
		If @OSVersion == "WIN_XP" Or @OSVersion == "WIN_XPe" Or @OSVersion == "WIN_2003" Then
			$gPropertyNumber = $gArrayWinXP[$gPropertyNumber]
		ElseIf @OSVersion == "WIN_2000" Then
			$gPropertyNumber = $gArrayWin2000[$gPropertyNumber]
		Else
			$gPropertyNumber = $gArrayWin7[$gPropertyNumber]
		EndIf
	EndIf

	$gObjShell = ObjCreate("Shell.Application")
	If IsObj($gObjShell) Then
		$gFileDir = FileGetShortName(StringRegExpReplace($gFilePath, "(^.*\\)(.*)", "\1"), 1)
		$gObjFolder = $gObjShell.NameSpace($gFileDir)
		If IsObj($gObjFolder) Then
			$gFileName = StringRegExpReplace($gFilePath, "^.*\\", "")
			$gObjFile = $gObjFolder.Parsename($gFileName)
			If IsObj($gObjFile) Then
				If $gMode = 2 Then
					$gFileProperties[0] = $gObjFolder.GetDetailsOf($gObjFolder.Items, $gPropertyNumber)
					$gFileProperties[1] = $gObjFolder.GetDetailsOf($gObjFile, $gPropertyNumber)
					Return $gFileProperties
				Else
					$gFileProperty = $gObjFolder.GetDetailsOf($gObjFile, $gPropertyNumber)
					Return $gFileProperty
				EndIf
			EndIf
		EndIf
	EndIf

	Return SetError(1, 0, 0)
EndFunc   ;==>__GetFileProperties

Func __GetRelativePath($sFilePath, $sFilePathRef = @ScriptDir)
	#cs
		Description: Get The Path Relative To The Reference Path.
		Returns: Relative Path [..\Path\Test] Or Original Path If @error
	#ce
	Local $aArray[2][2] = [[$sFilePath, 0],[$sFilePathRef, 0]], $sFilePathNew

	For $A = 0 To 1
		If _WinAPI_PathIsRelative($aArray[$A][0]) Then
			$aArray[$A][0] = _WinAPI_GetFullPathName(@ScriptDir & "\" & $aArray[$A][0])
		EndIf

		If _WinAPI_PathIsDirectory($aArray[$A][0]) Then
			$aArray[$A][0] = _WinAPI_PathAddBackslash($aArray[$A][0])
			$aArray[$A][1] = 1
		EndIf
	Next

	$sFilePathNew = _WinAPI_PathRelativePathTo($aArray[1][0], $aArray[1][1], $aArray[0][0], $aArray[0][1])
	If @error Then
		Return SetError(1, 0, $sFilePath)
	EndIf

	If $sFilePathNew == "." Then
		$sFilePathNew &= "\"
	EndIf
	Return $sFilePathNew
EndFunc   ;==>__GetRelativePath

Func __IsReadOnly($sFilePath)
	#cs
		Description: Check Whether A File Is Read-Only.
		Returns:
		If Read-Only Return 1
		If Not Read-Only Return 0
	#ce
	Return StringInStr(FileGetAttrib($sFilePath), "R") > 0
EndFunc   ;==>__IsReadOnly

Func __IsValidFileType($sFilePath, $sList = 'bat;cmd;exe') ; Taken From: http://www.autoitscript.com/forum/topic/123674-isvalidtype/
	#cs
		Description: Check If A File Is Supported.
		Returns: 1 = True Or 0 = False
	#ce
	If StringStripWS($sList, $STR_STRIPALL) = '' Then
		$sList = '*'
	EndIf
	Return _WinAPI_PathMatchSpec($sFilePath, StringReplace(';' & $sList, ';', ';*.'))
EndFunc   ;==>__IsValidFileType

Func __SureCopy($sSource, $sDestination)
	#cs
		Description: Copy File Or Folder.
		Returns: 1 = OK Or 0 = Failed
	#ce
	Local $iReadOnly, $iError
	If __IsReadOnly($sSource) Then
		FileSetAttrib($sSource, '-R')
		$iReadOnly = 1
	EndIf
	If _WinAPI_PathIsDirectory($sSource) Then
		DirRemove($sDestination, 1) ; To Overwrite.
		If DirCopy($sSource, $sDestination) = 0 Then
			$iError = 1
		EndIf
	Else
		If FileCopy($sSource, $sDestination, 9) = 0 Then
			$iError = 1
		EndIf
	EndIf
	If $iError Then
		If $iReadOnly Then
			FileSetAttrib($sSource, '+R')
		EndIf
		Return SetError(1, 0, 0)
	EndIf
	If $iReadOnly Then
		FileSetAttrib($sDestination, '+R')
	EndIf
	Return 1
EndFunc   ;==>__SureCopy

Func __SureMove($sSource, $sDestination)
	#cs
		Description: Move File Or Folder.
		Returns: 1 = OK Or 0 = Failed
	#ce
	Local $iReadOnly, $iError
	If __IsReadOnly($sSource) Then
		FileSetAttrib($sSource, '-R')
		$iReadOnly = 1
	EndIf
	If _WinAPI_PathIsDirectory($sSource) Then
		DirRemove($sDestination, 1) ; To Overwrite.
		If DirMove($sSource, $sDestination) = 0 Then
			$iError = 1
		EndIf
	Else
		If FileMove($sSource, $sDestination, 9) = 0 Then
			$iError = 1
		EndIf
	EndIf
	If $iError Then
		If $iReadOnly Then
			FileSetAttrib($sSource, '+R')
		EndIf
		Return SetError(1, 0, 0)
	EndIf
	If $iReadOnly Then
		FileSetAttrib($sDestination, '+R')
	EndIf
	Return 1
EndFunc   ;==>__SureMove
