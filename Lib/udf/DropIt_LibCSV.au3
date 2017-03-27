
; CSV funtions collected for DropIt
; Taken From: http://www.autoitscript.com/forum/topic/123398-snippet-dump/page__view__findpost__p__934152

Func __CSVSplit($sString, $sDelim = ",")
	If IsString($sString) = 0 Or $sString = "" Or IsString($sDelim) = 0 Or $sDelim = "" Then
		Return SetError(1, 0, 0)
	EndIf
	$sString = StringRegExpReplace($sString, '[“”„]', '"') ; Fix Quotes.

	Local $iOverride = 255, $asDelim[3] ; Replacements For Delimiters.
	For $A = 0 To 2
		$asDelim[$A] = __CSVGetSubstitute($sString, $iOverride, $sDelim) ; Choose A Suitable Substitution Character.
		If @error Then
			Return SetError(1, 0, 0)
		EndIf
	Next
	$iOverride = 0

	Local $aArray = StringRegExp($sString, '\A[^"]+|("+[^"]+)|"+\z', 3) ; Split String Using Double Quotes Delimiter.
	$sString = ""

	For $A = 0 To UBound($aArray) - 1
		$iOverride += StringInStr($aArray[$A], '"', 0, -1)
		If Mod($iOverride + 2, 2) = 0 Then
			$aArray[$A] = StringReplace($aArray[$A], $sDelim, $asDelim[0])
			$aArray[$A] = StringRegExpReplace($aArray[$A], "(\r\n)|[\r\n]", $asDelim[1])
		EndIf
		$aArray[$A] = StringReplace($aArray[$A], '""', $asDelim[2])
		$aArray[$A] = StringReplace($aArray[$A], '"', '')
		$aArray[$A] = StringReplace($aArray[$A], $asDelim[2], '"')
		$sString &= $aArray[$A]
	Next
	$iOverride = 0

	$aArray = StringSplit($sString, $asDelim[1], 2) ; Split To Get Rows.
	Local $iBound = UBound($aArray)
	Local $aCSV[$iBound + 1][2], $aTemp
	For $A = 1 To $iBound
		$aTemp = StringSplit($aArray[$A - 1], $asDelim[0]) ; Split To Get Row Items.
		If @error = 0 Then
			If $aTemp[0] > $iOverride Then
				$iOverride = $aTemp[0]
				ReDim $aCSV[$iBound + 1][$iOverride + 1]
			EndIf
		EndIf
		For $B = 1 To $aTemp[0]
			If StringLen($aTemp[$B]) Then
				If StringRegExp($aTemp[$B], '[^"]') = 0 Then ; Field Only Contains Double Quotes.
					$aTemp[$B] = StringTrimLeft($aTemp[$B], 1) ; Delete Enclosing Double Quote Single Char.
				EndIf
				$aCSV[$A][$B] = $aTemp[$B] ; Populate Each Row.
			EndIf
		Next
	Next
	$aCSV[0][0] = $iBound ; Number Of Rows.
	$aCSV[0][1] = $iOverride + 1 ; Number Of Columns.

	Return $aCSV
EndFunc   ;==>__CSVSplit

Func __CSVGetSubstitute($sString, ByRef $iCountdown, $sAvoid = "")
	If $iCountdown < 1 Then
		Return SetError(1, 0, "")
	EndIf
	Local $sTestChar
	For $A = $iCountdown To 1 Step -1
		$sTestChar = Chr($A)
		$iCountdown -= 1
		If StringInStr($sString, $sTestChar, 2) = 0 Then
			If $A = 34 Or $A = 13 Or $A = 10 Or StringInStr($sAvoid, $sTestChar) Then ; Some Characters May Interfere With Parsing.
				ContinueLoop
			EndIf
			Return $sTestChar
		EndIf
	Next
	Return SetError(1, 0, "")
EndFunc   ;==>__CSVGetSubstitute
