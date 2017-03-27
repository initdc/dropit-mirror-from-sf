#include-once

;#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7

; #INDEX# =======================================================================================================================
; Title .........: _RecFileListToArray
; AutoIt Version : v3.3.1.1 or higher
; Language ......: English
; Description ...: Lists files and\or folders in specified path with optional recursion to defined level and result sorting
; Note ..........:
; Author(s) .....: Melba23
; Remarks .......: - Modified Array.au3 functions - credit: Jos van der Zande, LazyCoder, Tylo, Ultima, SolidSnake and gcriaco
;                  - SRE patterns - credit: various forum members and Spiff59 in particular
;                  - DllCall code suggestion - credit: guinness
;                  - Despite the name, this UDF is iterative, not recursive
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _RecFileListToArray: Lists files and\or folders in a specified path with optional recursion to defined level and result sorting
; ===============================================================================================================================

; #INTERNAL_USE_ONLY#============================================================================================================
; _RFLTA_ListToMask ......; Convert include/exclude lists to SRE format
; _RFLTA_AddToList .......; Add element to list which is resized if necessary
; _RFLTA_AddFileLists ....; Add internal lists after resizing and optional sorting
; _RFLTA_FileListSearch ..; Search file match list for files associated with a folder
; _RFLTA_ArraySort .......; Wrapper for QuickSort function
; _RFLTA_QuickSort .......: Recursive array sort
; _RFLTA_ArrayConcatenate : Join 2 arrays
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _RecFileListToArray
; Description ...: Lists files and\or folders in a specified path with optional recursion to defined level and result sorting
; Syntax.........: _RecFileListToArray($sPath[, $sMask = "*"[, $iReturn = 0[, $iRecur = 0[, $iSort = 0[, $iReturnPath = 1[, $sExclude_List = ""[, $sExclude_List_Folder]]]]]]])
; Parameters ....: $sPath - Initial path used to generate filelist
;                               If path ends in \ then folders will be returned with an ending \
;                               If path lengths > 260 chars, prefix path with "\\?\" - return paths are not affected
;                  $sMask - Optional: Filter for result. Multiple filters must be separated by ";"
;                           Use "|" to separate 3 possible sets of filters: "Include|Exclude|Exclude_Folders"
;                               Include = Files/Folders to include (default = "*" [all])
;                               Exclude = Files/Folders to exclude (default = "" [none])
;                               Exclude_Folders = only used if basic $iReturn = 0 AND $iRecur = 1 to exclude defined folders (default = "" [none])
;                  $iReturn - Optional: specifies whether to return files, folders or both and omits those with certain attributes
;                              0 - Return both files and folders (Default)
;                                   If non-recursive Include/Exclude_List applies to files and folders
;                                   If recursive Include/Exclude_List applies to files only, all folders are searched unless excluded using $sExclude_List_Folder
;                              1 - Return files only    - Include/Exclude_List applies to files only, all folders searched if recursive
;                              2 - Return folders only  - Include/Exclude_List applies to folders only for searching and return
;                                   Add one or more of the following to $iReturn to omit files/folders with that attribute
;                                   + 4  - Hidden files and folders
;                                   + 8  - System files and folders
;                                   + 16 - Link/junction folders
;                                   Note:  Omitting files/folders uses a different search algorithm and takes approx 50% longer
;                  $iRecur - Optional: specifies whether to search recursively in subfolders and to what level
;                             1 - Search in all subfolders (unlimited recursion)
;                             0 - Do not search in subfolders (Default)
;                             Negative integer - Search in subfolders to specified depth
;                  $iSort - Optional: sort ordered in alphabetical and depth order
;                             0 - Not sorted (Default)
;                             1 - Sorted
;                             2 - Sorted with faster algorithm (assumes files sorted within each folder - requires NTFS drive)
;                  $iReturnPath - Optional: specifies displayed path of results
;                             0 - File/folder name only
;                             1 - Relative to initial path (Default)
;                             2 - Full path included
;
; [These parameters are now deprecated as they should be included within the $sMask parameter]
; [If $sMask contains sections for Exclude and Exclude_Folders (i.e "|" characters are used) then these parameters will be ignored]
;                  $sExclude_List - Optional: filter for excluded results (default ""). Multiple filters must be separated by ";"
;                  $sExclude_List_Folder - Optional: only used if $iReturn = 0 AND $iRecur = 1 to exclude folders matching the filter
;
; Requirement(s).: v3.3.1.1 or higher
; Return values .: Success: One-dimensional array made up as follows:
;                            [0] = Number of Files\Folders returned
;                            [1] = 1st File\Folder
;                            [2] = 2nd File\Folder
;                            ...
;                            [n] = nth File\Folder
;                   Failure: Null string and @error = 1 with @extended set as follows:
;                            1 = Path not found or invalid
;                            2 = Invalid $sInclude_List
;                            3 = Invalid $iReturn
;                            4 = Invalid $iRecur
;                            5 = Invalid $iSort
;                            6 = Invalid $iReturnPath
;                            7 = Invalid $sExclude_List
;                            8 = Invalid $sExclude_List_Folder
;                            9 = No files/folders found
; Author ........: Melba23
; Remarks .......: Compatible with existing _FileListToArray syntax
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _RecFileListToArray($sInitialPath, $sMask = "*", $iReturn = 0, $iRecur = 0, $iSort = 0, $iReturnPath = 1, $sExclude_List = "", $sExclude_List_Folder = "")

	Local $asReturnList[100] = [0], $asFileMatchList[100] = [0], $asRootFileMatchList[100] = [0], $asFolderMatchList[100] = [0], $asFolderSearchList[100] = [1]
	Local $sFolderSlash = "", $iMaxLevel, $sInclude_List, $sInclude_File_Mask, $sExclude_File_Mask, $sInclude_Folder_Mask = ".+", $sExclude_Folder_Mask = ":"
	Local $hSearch, $fFolder, $sRetPath = "", $sCurrentPath, $sName, $iAttribs, $iHide_HS = 0, $iHide_Link = 0, $fLongPath = False
	Local $asFolderFileSectionList[100][2] = [[0, 0]], $sFolderToFind, $iFileSectionStartIndex, $iFileSectionEndIndex

	; Check for valid path
	If StringLeft($sInitialPath, 4) == "\\?\" Then
		$fLongPath = True
	EndIf
	If Not FileExists($sInitialPath) Then Return SetError(1, 1, "")
	; Check if folders should have trailing \ and ensure that initial path does have one
	If StringRight($sInitialPath, 1) = "\" Then
		$sFolderSlash = "\"
	Else
		$sInitialPath = $sInitialPath & "\"
	EndIf
	; Add path to folder search list
	$asFolderSearchList[1] = $sInitialPath

	; Check for H or S omitted
	If BitAND($iReturn, 4) Then
		$iHide_HS += 2
		$iReturn -= 4
	EndIf
	If BitAND($iReturn, 8) Then
		$iHide_HS += 4
		$iReturn -= 8
	EndIf

	; Check for link/junction omitted
	If BitAND($iReturn, 16) Then
		$iHide_HS = 0x406
		$iReturn -= 16
	EndIf

	; Check for valid recur value
	If $iRecur > 1 Or Not IsInt($iRecur) Then Return SetError(1, 4, "")
	; If required, determine \ count for max recursive level setting
	If $iRecur < 0 Then
		StringReplace($sInitialPath, "\", "", 0, 2)
		$iMaxLevel = @extended - $iRecur
	EndIf

	; Check mask parameter
	Local $aMaskSplit = StringSplit($sMask, "|")
	; Check for multiple sections and set values
	Switch $aMaskSplit[0]
		Case 3
			$sExclude_List_Folder = $aMaskSplit[3]
			ContinueCase
		Case 2
			$sExclude_List = $aMaskSplit[2]
			ContinueCase
		Case 1
			$sInclude_List = $aMaskSplit[1]
	EndSwitch

	; Create Include mask for files
	If $sInclude_List = "*" Then
		$sInclude_File_Mask = ".+"
	Else
		If Not _RFLTA_ListToMask($sInclude_File_Mask, $sInclude_List) Then Return SetError(1, 2, "")
	EndIf
	; Set Include mask for folders
	Switch $iReturn
		Case 0
			; Folders affected by mask if not recursive
			Switch $iRecur
				Case 0
					; Folders match mask for compatibility
					$sInclude_Folder_Mask = $sInclude_File_Mask
			EndSwitch
		Case 2
			; Folders affected by mask
			$sInclude_Folder_Mask = $sInclude_File_Mask
	EndSwitch

	; Create Exclude List mask for files
	If $sExclude_List = "" Then
		$sExclude_File_Mask = ":" ; Set unmatchable mask
	Else
		If Not _RFLTA_ListToMask($sExclude_File_Mask, $sExclude_List) Then Return SetError(1, 7, "")
	EndIf

	; Create Exclude mask for folders
	If $iRecur Then
		If $sExclude_List_Folder Then
			If Not _RFLTA_ListToMask($sExclude_Folder_Mask, $sExclude_List_Folder) Then Return SetError(1, 8, "")
		EndIf
		; If folders only
		If $iReturn = 2 Then
			; Folders affected by normal mask
			$sExclude_Folder_Mask = $sExclude_File_Mask
		EndIf
	Else
		; Folders affected by normal mask
		$sExclude_Folder_Mask = $sExclude_File_Mask
	EndIf

	; Verify other parameters
	If Not ($iReturn = 0 Or $iReturn = 1 Or $iReturn = 2) Then Return SetError(1, 3, "")
	If Not ($iSort = 0 Or $iSort = 1 Or $iSort = 2) Then Return SetError(1, 5, "")
	If Not ($iReturnPath = 0 Or $iReturnPath = 1 Or $iReturnPath = 2) Then Return SetError(1, 6, "")

	; Prepare for DllCall if required
	If $iHide_HS Or $iHide_Link Then
		Local $tFile_Data = DllStructCreate("struct;align 4;dword FileAttributes;uint64 CreationTime;uint64 LastAccessTime;uint64 LastWriteTime;" & _
				"dword FileSizeHigh;dword FileSizeLow;dword Reserved0;dword Reserved1;wchar FileName[260];wchar AlternateFileName[14];endstruct")
		Local $pFile_Data = DllStructGetPtr($tFile_Data), $hDLL = DllOpen('kernel32.dll'), $aDLL_Ret
	EndIf

	; Search within listed folders
	While $asFolderSearchList[0] > 0

		; Set path to search
		$sCurrentPath = $asFolderSearchList[$asFolderSearchList[0]]

		; Reduce folder search list count
		$asFolderSearchList[0] -= 1

		; Determine return path to add to file/folder name
		Switch $iReturnPath
			; Case 0 ; Name only
			; Leave as ""
			Case 1 ;Relative to initial path
				$sRetPath = StringReplace($sCurrentPath, $sInitialPath, "")
			Case 2 ; Full path
				If $fLongPath Then
					$sRetPath = StringTrimLeft($sCurrentPath, 4)
				Else
					$sRetPath = $sCurrentPath
				EndIf
		EndSwitch

		; Get search handle - use code matched to required listing
		If $iHide_HS Or $iHide_Link Then
			; Use DLL code
			$aDLL_Ret = DllCall($hDLL, 'ptr', 'FindFirstFileW', 'wstr', $sCurrentPath & "*", 'ptr', $pFile_Data)
			If @error Or Not $aDLL_Ret[0] Then
				ContinueLoop
			EndIf
			$hSearch = $aDLL_Ret[0]
		Else
			; Use native code
			$hSearch = FileFindFirstFile($sCurrentPath & "*")
			; If folder empty move to next in list
			If $hSearch = -1 Then
				ContinueLoop
			EndIf
		EndIf

		; If sorting files and folders with paths then store folder name and position of associated files in list
		If $iReturn = 0 And $iSort And $iReturnPath Then
			_RFLTA_AddToList($asFolderFileSectionList, $sRetPath, $asFileMatchList[0] + 1)
		EndIf

		; Search folder - use code matched to required listing
		While 1
			; Use DLL code
			If $iHide_HS Or $iHide_Link Then
				; Use DLL code
				$aDLL_Ret = DllCall($hDLL, 'int', 'FindNextFileW', 'ptr', $hSearch, 'ptr', $pFile_Data)
				; Check for end of folder
				If @error Or Not $aDLL_Ret[0] Then
					ExitLoop
				EndIf

				; Extract data
				$sName = DllStructGetData($tFile_Data, "FileName")
				; Check for .. return - only returned by the DllCall
				If $sName = ".." Then
					ContinueLoop
				EndIf
				$iAttribs = DllStructGetData($tFile_Data, "FileAttributes")
				; Check for hidden/system attributes and skip if found
				If $iHide_HS And BitAND($iAttribs, $iHide_HS) Then
					ContinueLoop
				EndIf
				; Check for link attribute and skip if found
				If $iHide_Link And BitAND($iAttribs, $iHide_Link) Then
					ContinueLoop
				EndIf
				; Set subfolder flag
				$fFolder = 0
				If BitAND($iAttribs, 16) Then
					$fFolder = 1
				EndIf
			Else
				; Use native code
				$sName = FileFindNextFile($hSearch)
				; Check for end of folder
				If @error Then
					ExitLoop
				EndIf
				; Set subfolder flag - @extended set in 3.3.1.1 +
				$fFolder = @extended
			EndIf

			; If folder then check whether to add to search list
			If $fFolder Then
				Select
					Case $iRecur < 0 ; Check recur depth
						StringReplace($sCurrentPath, "\", "", 0, 2)
						If @extended < $iMaxLevel Then
							ContinueCase ; Check if matched to masks
						EndIf
					Case $iRecur = 1 ; Full recur
						If Not StringRegExp($sName, $sExclude_Folder_Mask) Then ; Add folder unless excluded
							_RFLTA_AddToList($asFolderSearchList, $sCurrentPath & $sName & "\")
						EndIf
						; Case $iRecur = 0 ; Never add
						; Do nothing
				EndSelect
			EndIf

			If $iSort Then ; Save in relevant folders for later sorting

				If $fFolder Then
					If StringRegExp($sName, $sInclude_Folder_Mask) And Not StringRegExp($sName, $sExclude_Folder_Mask) Then
						_RFLTA_AddToList($asFolderMatchList, $sRetPath & $sName & $sFolderSlash)
					EndIf
				Else
					If StringRegExp($sName, $sInclude_File_Mask) And Not StringRegExp($sName, $sExclude_File_Mask) Then
						; Select required list for files
						If $sCurrentPath = $sInitialPath Then
							_RFLTA_AddToList($asRootFileMatchList, $sRetPath & $sName)
						Else
							_RFLTA_AddToList($asFileMatchList, $sRetPath & $sName)
						EndIf
					EndIf
				EndIf

			Else ; Save directly in return list
				If $fFolder Then
					If $iReturn <> 1 And StringRegExp($sName, $sInclude_Folder_Mask) And Not StringRegExp($sName, $sExclude_Folder_Mask) Then
						_RFLTA_AddToList($asReturnList, $sRetPath & $sName & $sFolderSlash)
					EndIf
				Else
					If $iReturn <> 2 And StringRegExp($sName, $sInclude_File_Mask) And Not StringRegExp($sName, $sExclude_File_Mask) Then
						_RFLTA_AddToList($asReturnList, $sRetPath & $sName)
					EndIf
				EndIf
			EndIf

		WEnd

		; Close current search
		FileClose($hSearch)

	WEnd

	; Close the DLL if needed
	If $iHide_HS Then
		DllClose($hDLL)
	EndIf

	If $iSort Then
		; Check if any file/folders have been added depending on required return
		Switch $iReturn
			Case 0 ; If no folders then number of files is immaterial
				If $asRootFileMatchList[0] = 0 And $asFolderMatchList[0] = 0 Then Return SetError(1, 9, "")
			Case 1
				If $asRootFileMatchList[0] = 0 And $asFileMatchList[0] = 0 Then Return SetError(1, 9, "")
			Case 2
				If $asFolderMatchList[0] = 0 Then Return SetError(1, 9, "")
		EndSwitch

		Switch $iReturn
			Case 2 ; Folders only
				; Correctly size folder match list
				ReDim $asFolderMatchList[$asFolderMatchList[0] + 1]
				; Copy size folder match array
				$asReturnList = $asFolderMatchList
				; Simple sort list
				_RFLTA_ArraySort($asReturnList)
			Case 1 ; Files only
				If $iReturnPath = 0 Then ; names only so simple sort suffices
					; Combine file match lists
					_RFLTA_AddFileLists($asReturnList, $asRootFileMatchList, $asFileMatchList)
					; Simple sort combined file list
					_RFLTA_ArraySort($asReturnList)
				Else
					; Combine sorted file match lists
					_RFLTA_AddFileLists($asReturnList, $asRootFileMatchList, $asFileMatchList, 1)
				EndIf
			Case 0 ; Both files and folders
				If $iReturnPath = 0 Then ; names only so simple sort suffices
					; Combine file match lists
					_RFLTA_AddFileLists($asReturnList, $asRootFileMatchList, $asFileMatchList)
					; Set correct count for folder add
					$asReturnList[0] += $asFolderMatchList[0]
					; Resize and add file match array
					ReDim $asFolderMatchList[$asFolderMatchList[0] + 1]
					_RFLTA_ArrayConcatenate($asReturnList, $asFolderMatchList)
					; Simple sort final list
					_RFLTA_ArraySort($asReturnList)
				Else
					; Size return list
					Local $asReturnList[$asFileMatchList[0] + $asRootFileMatchList[0] + $asFolderMatchList[0] + 1]
					$asReturnList[0] = $asFileMatchList[0] + $asRootFileMatchList[0] + $asFolderMatchList[0]
					; Sort root file list
					_RFLTA_ArraySort($asRootFileMatchList, 1, $asRootFileMatchList[0])
					; Add the sorted root files at the top
					For $i = 1 To $asRootFileMatchList[0]
						$asReturnList[$i] = $asRootFileMatchList[$i]
					Next
					; Set next insertion index
					Local $iNextInsertionIndex = $asRootFileMatchList[0] + 1
					; Sort folder list
					_RFLTA_ArraySort($asFolderMatchList, 1, $asFolderMatchList[0])
					; Work through folder list
					For $i = 1 To $asFolderMatchList[0]
						; Add folder to return list
						$asReturnList[$iNextInsertionIndex] = $asFolderMatchList[$i]
						$iNextInsertionIndex += 1
						; Format folder name for search
						If $sFolderSlash Then
							$sFolderToFind = $asFolderMatchList[$i]
						Else
							$sFolderToFind = $asFolderMatchList[$i] & "\"
						EndIf
						; Find folder in FolderFileSectionList
						For $j = 1 To $asFolderFileSectionList[0][0]
							; If found then deal with files
							If $sFolderToFind = $asFolderFileSectionList[$j][0] Then
								; Set file list indexes
								$iFileSectionStartIndex = $asFolderFileSectionList[$j][1]
								If $j = $asFolderFileSectionList[0][0] Then
									$iFileSectionEndIndex = $asFileMatchList[0]
								Else
									$iFileSectionEndIndex = $asFolderFileSectionList[$j + 1][1] - 1
								EndIf
								; Sort files
								_RFLTA_ArraySort($asFileMatchList, $iFileSectionStartIndex, $iFileSectionEndIndex)
								; Add files to return list
								For $k = $iFileSectionStartIndex To $iFileSectionEndIndex
									$asReturnList[$iNextInsertionIndex] = $asFileMatchList[$k]
									$iNextInsertionIndex += 1
								Next
								ExitLoop
							EndIf
						Next
					Next
				EndIf
		EndSwitch

	Else ; No sort

		; Check if any file/folders have been added
		If $asReturnList[0] = 0 Then Return SetError(1, 9, "")

		; Remove any unused return list elements from last ReDim
		ReDim $asReturnList[$asReturnList[0] + 1]

	EndIf

	Return $asReturnList


EndFunc   ;==>_RecFileListToArray

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _RFLTA_ListToMask
; Description ...: Convert include/exclude lists to SRE format
; Syntax ........: _RFLTA_ListToMask(ByRef $sMask, $sList)
; Parameters ....: $asMask - Include/Exclude mask to create
;                  $asList - Include/Exclude list to convert
; Return values .: Success: 1
;                  Failure: 0
; Author ........: SRE patterns developed from those posted by various forum members and Spiff59 in particular
; Remarks .......: This function is used internally by _RecFileListToArray
; ===============================================================================================================================
Func _RFLTA_ListToMask(ByRef $sMask, $sList)

	; Check for invalid characters within list
	If StringRegExp($sList, "\\|/|:|\<|\>|\|") Then Return 0
	; Strip WS and insert | for ;
	$sList = StringReplace(StringStripWS(StringRegExpReplace($sList, "\s*;\s*", ";"), 3), ";", "|")
	; Convert to SRE pattern
	$sList = StringReplace(StringReplace(StringRegExpReplace($sList, "[][$^.{}()+\-]", "\\$0"), "?", "."), "*", ".*?")
	; Add prefix and suffix
	$sMask = "(?i)^(" & $sList & ")\z"
	Return 1

EndFunc   ;==>_RFLTA_ListToMask

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _RFLTA_AddToList
; Description ...: Add element to [?] or [?][2] list which is resized if necessary
; Syntax ........: _RFLTA_AddToList(ByRef $asList, $vValue_0, [$vValue_1])
; Parameters ....: $aList - List to be added to
;                  $vValue_0 - Value to add (to [0] element in [?][2] array if $vValue_1 exists)
;                  $vValue_1 - Value to add to [1] element in [?][2] array (optional)
; Return values .: None - array modified ByRef
; Author ........: Melba23
; Remarks .......: This function is used internally by _RecFileListToArray
; ===============================================================================================================================
Func _RFLTA_AddToList(ByRef $aList, $vValue_0, $vValue_1 = -1)

	If $vValue_1 = -1 Then ; [?] array
		; Increase list count
		$aList[0] += 1
		; Double list size if too small (fewer ReDim needed)
		If UBound($aList) <= $aList[0] Then ReDim $aList[UBound($aList) * 2]
		; Add value
		$aList[$aList[0]] = $vValue_0
	Else ; [?][2] array
		$aList[0][0] += 1
		If UBound($aList) <= $aList[0][0] Then ReDim $aList[UBound($aList) * 2][2]
		$aList[$aList[0][0]][0] = $vValue_0
		$aList[$aList[0][0]][1] = $vValue_1
	EndIf

EndFunc   ;==>_RFLTA_AddToList

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _RFLTA_AddFileLists
; Description ...: Add internal lists after resizing and optional sorting
; Syntax ........: _RFLTA_AddFileLists(ByRef $asTarget, $asSource_1, $asSource_2[, $iSort = 0])
; Parameters ....: $asReturnList - Base list
;                  $asRootFileMatchList - First list to add
;                  $asFileMatchList - Second list to add
;                  $iSort - (Optional) Whether to sort lists before adding
;                  |$iSort = 0 (Default) No sort
;                  |$iSort = 1 Sort in descending alphabetical order
; Return values .: None - array modified ByRef
; Author ........: Melba23
; Remarks .......: This function is used internally by _RecFileListToArray
; ===============================================================================================================================
Func _RFLTA_AddFileLists(ByRef $asTarget, $asSource_1, $asSource_2, $iSort = 0)

	; Correctly size root file match array
	ReDim $asSource_1[$asSource_1[0] + 1]
	; Simple sort root file match array if required
	If $iSort = 1 Then _RFLTA_ArraySort($asSource_1)
	; Copy root file match array
	$asTarget = $asSource_1
	; Add file match count
	$asTarget[0] += $asSource_2[0]
	; Correctly size file match array
	ReDim $asSource_2[$asSource_2[0] + 1]
	; Simple sort file match array if required
	If $iSort = 1 Then _RFLTA_ArraySort($asSource_2)
	; Add file match array
	_RFLTA_ArrayConcatenate($asTarget, $asSource_2)

EndFunc   ;==>_RFLTA_AddFileLists

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _RFLTA_FileListSearch
; Description ...: Search file array for beginning and end indices of folder associated files
; Syntax ........: _RFLTA_FileListSearch(Const ByRef $avArray, $vValue)
; Parameters ....: $avArray - Array to search ($asFileMatchList)
;                  $vValue  - Value to search for (Folder name from $asFolderMatchList)
;                  $iIndex  - Index to begin search (search down from here - and then from here to top if not found)
;                  $sSlash  - \ if folder names end in \ - else empty string
; Return values .: Success: Array holding top and bottom indices of folder associated files
;                  Failure: Returns -1
; Author ........: Melba23
; Modified.......:
; Remarks .......: This function is used internally by _RecFileListToArray
; ===============================================================================================================================
Func _RFLTA_FileListSearch(Const ByRef $avArray, $vValue, $iIndex, $sSlash)

	Local $aRet[2]

	; Add final \ if required
	If Not $sSlash Then $vValue &= "\"
	; Start by getting top match - search down from start index
	For $i = $iIndex To $avArray[0]
		; SRE gives path less filename
		If StringRegExpReplace($avArray[$i], "(^.*\\)(.*)", "\1") = $vValue Then ExitLoop
	Next
	If $i > $avArray[0] Then
		; No match found so look from start index upwards
		If $iIndex = $avArray[0] Then $iIndex -= 1
		For $i = $iIndex + 1 To 1 Step -1
			If StringRegExpReplace($avArray[$i], "(^.*\\)(.*)", "\1") = $vValue Then ExitLoop
		Next
		; If still no match - return " nothing found" for empty folder
		If $i = 0 Then Return SetError(1, 0, "")
		; Set index of bottom file
		$aRet[1] = $i
		; Now look for top match
		For $i = $aRet[1] To 1 Step -1
			If StringRegExpReplace($avArray[$i], "(^.*\\)(.*)", "\1") <> $vValue Then ExitLoop
		Next
		; Set top match
		$aRet[0] = $i + 1
	Else
		; Set index of top associated file
		$aRet[0] = $i
		; Now look for bottom match - find first file which does not match
		For $i = $aRet[0] To $avArray[0]
			If StringRegExpReplace($avArray[$i], "(^.*\\)(.*)", "\1") <> $vValue Then ExitLoop
		Next
		; Set bottom match
		$aRet[1] = $i - 1
	EndIf

	Return $aRet

EndFunc   ;==>_RFLTA_FileListSearch

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _RFLTA_ArraySort
; Description ...: Wrapper for QuickSort function
; Syntax ........: _RFLTA_ArraySort(ByRef $avArray)
; Parameters ....: $avArray - Array to sort
;                  $iStart  - Index to start sort
;                  $iEnd    - Index to end sort
; Return values .: None - array modified ByRef
; Author ........: Jos van der Zande, LazyCoder, Tylo, Ultima
; Modified.......: Melba23
; Remarks .......: This function is used internally by _RecFileListToArray
; ===============================================================================================================================
Func _RFLTA_ArraySort(ByRef $avArray, $iStart = 1, $iEnd = -99)

	If $iEnd = -99 Then $iEnd = UBound($avArray) - 1

	_RFLTA_QuickSort($avArray, $iStart, $iEnd)

EndFunc   ;==>_RFLTA_ArraySort

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _RFLTA_QuickSort
; Description ...: Recursive array sort
; Syntax ........: _RFLTA_QuickSort(ByRef $avArray, ByRef $iStart, ByRef $iEnd)
; Parameters ....: $avArray - Array to sort in descending alphabetical order
;                  $iStart - Start index
;                  $iEnd - End index
; Return values .: None - array modified ByRef
; Author ........: Jos van der Zande, LazyCoder, Tylo, Ultima
; Modified.......: Melba23
; Remarks .......: This function is used internally by _RFLTA_ArraySort
; ===============================================================================================================================
Func _RFLTA_QuickSort(ByRef $avArray, ByRef $iStart, ByRef $iEnd)

	Local $vTmp
	If ($iEnd - $iStart) < 15 Then
		Local $i, $j, $vCur
		For $i = $iStart + 1 To $iEnd
			$vTmp = $avArray[$i]
			If IsNumber($vTmp) Then
				For $j = $i - 1 To $iStart Step -1
					$vCur = $avArray[$j]
					If ($vTmp >= $vCur And IsNumber($vCur)) Or (Not IsNumber($vCur) And StringCompare($vTmp, $vCur) >= 0) Then ExitLoop
					$avArray[$j + 1] = $vCur
				Next
			Else
				For $j = $i - 1 To $iStart Step -1
					If (StringCompare($vTmp, $avArray[$j]) >= 0) Then ExitLoop
					$avArray[$j + 1] = $avArray[$j]
				Next
			EndIf
			$avArray[$j + 1] = $vTmp
		Next
		Return
	EndIf
	Local $L = $iStart, $R = $iEnd, $vPivot = $avArray[Int(($iStart + $iEnd) / 2)], $fNum = IsNumber($vPivot)
	Do
		If $fNum Then
			While ($avArray[$L] < $vPivot And IsNumber($avArray[$L])) Or (Not IsNumber($avArray[$L]) And StringCompare($avArray[$L], $vPivot) < 0)
				$L += 1
			WEnd
			While ($avArray[$R] > $vPivot And IsNumber($avArray[$R])) Or (Not IsNumber($avArray[$R]) And StringCompare($avArray[$R], $vPivot) > 0)
				$R -= 1
			WEnd
		Else
			While (StringCompare($avArray[$L], $vPivot) < 0)
				$L += 1
			WEnd
			While (StringCompare($avArray[$R], $vPivot) > 0)
				$R -= 1
			WEnd
		EndIf
		If $L <= $R Then
			$vTmp = $avArray[$L]
			$avArray[$L] = $avArray[$R]
			$avArray[$R] = $vTmp
			$L += 1
			$R -= 1
		EndIf
	Until $L > $R
	_RFLTA_QuickSort($avArray, $iStart, $R)
	_RFLTA_QuickSort($avArray, $L, $iEnd)

EndFunc   ;==>_RFLTA_QuickSort

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _RFLTA_ArrayConcatenate
; Description ...: Joins 2 arrays
; Syntax ........: _RFLTA_ArrayConcatenate(ByRef $avArrayTarget, Const ByRef $avArraySource)
; Parameters ....: $avArrayTarget - Base array
;                  $avArraySource - Array to add from element 1 onwards
; Return values .: None - array modified ByRef
; Author ........: Ultima
; Modified.......: Melba23
; Remarks .......: This function is used internally by _RecFileListToArray
; ===============================================================================================================================
Func _RFLTA_ArrayConcatenate(ByRef $avArrayTarget, Const ByRef $avArraySource)

	Local $iUBoundTarget = UBound($avArrayTarget) - 1, $iUBoundSource = UBound($avArraySource)
	ReDim $avArrayTarget[$iUBoundTarget + $iUBoundSource]
	For $i = 1 To $iUBoundSource - 1
		$avArrayTarget[$iUBoundTarget + $i] = $avArraySource[$i]
	Next

EndFunc   ;==>_RFLTA_ArrayConcatenate