; #INDEX#===================================================================================================
; Title .........: BDV Encrypter/Decrytper
; AutoIt Version : 3.3.8.0++
; Language ......: English
; Description ...: Encrypt Decrypt String
; Author(s) .....: Daneel
; Notes .........: Char not Allowed in filename =[34   " ,42   * ,47   / ,58   : ,60   < ,62   > ,63   ? ,92   \ ,124   |]
;				   SpecialChar = 1-31
; Todo ..........: Add personal not allowed array (only if requested)
; 				   Add not consiered char list for user
; Exe(s) ........: 
; ==========================================================================================================

; #CURRENT# ================================================================================================
;$i_BDV_AllAllowed = 1
;$i_BDV_NotAllowedFile = 2
;$i_BDV_NotAllowedFileAndPoint = 3

;Func _BDV_Decrypt($sSource,$sKey,$NotAllowedInResult = $i_BDV_NotAllowedFileAndPoint,$iSkipPoint=false,$iSkipSpace=false,$sOtherSkip="")
;Func _BDV_Encrypt($sSource,$sKey,$NotAllowedInResult = $i_BDV_NotAllowedFileAndPoint,$iSkipPoint=false,$iSkipSpace=false,$sOtherSkip="")
; ==========================================================================================================
Global Const $_BDV_ENCRYPT = 1
Global Const $_BDV_DECRYPT = -1
Global Const $_BDV_AllAllowed = 1
Global Const $_BDV_NotAllowedFile = 2
Global Const $_BDV_NotAllowedFileAndPoint = 3

#Region Only Internal Use
Global $a_BDV_Special
Global $a_BDV_Digit
Global $a_BDV_Upper
Global $a_BDV_Lower
Global $a_BDV_Symbol1
Global $a_BDV_Symbol2
Global $a_BDV_Symbol3
Global $a_BDV_Symbol4
Global $a_BDV_Accented
Global $a_BDV_ArrayNotAllowedSelected
#endRegion

Func _BDV_Decrypt($sSource,$sKey,$NotAllowedInResult = $_BDV_NotAllowedFileAndPoint,$iSkipPoint=false,$iSkipSpace=false,$sOtherSkip="")
	Return __BDV_DeEncrypt($sSource,$sKey,$_BDV_DECRYPT,$NotAllowedInResult,__BDV_SkipVar($iSkipPoint,$iSkipSpace,$sOtherSkip))
EndFunc

Func _BDV_Encrypt($sSource,$sKey,$NotAllowedInResult = $_BDV_NotAllowedFileAndPoint,$iSkipPoint=false,$iSkipSpace=false,$sOtherSkip="")
	Return __BDV_DeEncrypt($sSource,$sKey,$_BDV_ENCRYPT,$NotAllowedInResult,__BDV_SkipVar($iSkipPoint,$iSkipSpace,$sOtherSkip))
EndFunc

Func __BDV_DeEncrypt($sSource,$sKey,$operation,$iArrayNotAllowedType = 3, $sOtherSkip="")
	__BDV_ChangeArrayNotAllowedType($iArrayNotAllowedType)
	__BDV_SkipArray($sOtherSkip)
	Local $iKeyPos = 0
	Local $sResult = ""
	Local $aKey = StringSplit($sKey, "" ,2)
	Local $aSource = StringSplit($sSource, "" ,2)
	For $elem in $aSource
		Local $iShift = $operation * AscW($aKey[$iKeyPos])
		$sResult &= __BDV_ShifOne($elem,$iShift)
        $iKeyPos = Mod($iKeyPos + 1, UBound($aKey))
	Next
	;Redim $ai_BDV_Jump[1]
	If $sOtherSkip <> "" Then __BDV_ChangeArrayNotAllowedType($iArrayNotAllowedType)
	Return $sResult	
EndFunc

Func __BDV_SkipVar($iSkipPoint,$iSkipSpace,$sOtherSkip)
	Local $sSkip = ""
	If $iSkipPoint Then $sSkip &= "."
	If $iSkipSpace Then $sSkip &= " "
	$sSkip &= $sOtherSkip
	Return $sSkip
EndFunc

Func __BDV_SkipArray($sSkip)
	Local $asSkip = StringSplit($sSkip, "" ,2)
	If Ubound($asSkip) == 0 Then Return
	For $elem in $asSkip
		__BDV_AddInArray($a_BDV_ArrayNotAllowedSelected,AscW($elem))
	Next
EndFunc

Func __BDV_AddInArray(ByRef $aiArray, $iVal, $bFinder = True)
	If $bFinder And __BDV_IsInArray($iVal, $aiArray) Then Return
	ReDim $aiArray[UBound($aiArray) + 1]
	Local $iI = UBound($aiArray) - 2
	While $iI > 0 And $aiArray[$iI - 1] > $iVal
		$aiArray[$iI] = $aiArray[$iI - 1]
		$iI -= 1
	WEnd
	$aiArray[$iI] = $iVal
EndFunc


;TODO character / ruin next letter
Global Const $ai_BDV_AllAllowed[1] = [47]
Global Const $ai_BDV_NotAllowedFile[10] = [34,42,47,58,60,62,63,92,124]
Global Const $ai_BDV_NotAllowedFileAndPoint[11] = [34,42,46,47,58,60,62,63,92,124]
Global $ai_BDV_Jump[1] = [0]


Func __BDV_ShifOne($cChar, $iShift, $SpecialAccepted = False)
	Local $iChar = AscW($cChar)
	Local $res = 0

	$res =  __BDV_Jump($iChar)
	If $res Then Return $res
    $res =  __BDV_isSpecialIniEnd($iChar, $iShift, 1, 31, $a_BDV_Special,$SpecialAccepted)
	If $res Then Return $res
	$res =  __BDV_isBetweenIniEnd($iChar, $iShift, 32, 47, $a_BDV_Symbol1)
	If $res Then Return $res
	$res =  __BDV_isBetweenIniEnd($iChar, $iShift, 48, 57, $a_BDV_Digit)
	If $res Then Return $res
	$res =  __BDV_isBetweenIniEnd($iChar, $iShift, 58, 64, $a_BDV_Symbol2)
	If $res Then Return $res
	$res =  __BDV_isBetweenIniEnd($iChar, $iShift, 65, 90, $a_BDV_Upper)
	If $res Then Return $res
	$res =  __BDV_isBetweenIniEnd($iChar, $iShift, 91, 96, $a_BDV_Symbol3)
	If $res Then Return $res
	$res =  __BDV_isBetweenIniEnd($iChar, $iShift, 97, 122, $a_BDV_Lower)
	If $res Then Return $res
	$res =  __BDV_isBetweenIniEnd($iChar, $iShift, 123, 191, $a_BDV_Symbol4)
	If $res Then Return $res
	$res =  __BDV_isBetweenIniEnd($iChar, $iShift, 192, 255, $a_BDV_Accented)
	If $res Then Return $res
	Return $cChar
EndFunc

Func __BDV_ChangeArrayNotAllowedType($iArrayNotAllowedType)
	Switch $iArrayNotAllowedType
		Case 1
			__BDV_ChangeArrayNotAllowed($ai_BDV_AllAllowed)
		Case 2
			__BDV_ChangeArrayNotAllowed($ai_BDV_NotAllowedFile)
		Case 3
			__BDV_ChangeArrayNotAllowed($ai_BDV_NotAllowedFileAndPoint)
    EndSwitch
EndFunc

Func __BDV_Jump($iChar)
	Local $iI = 0
	While $iI < UBound($a_BDV_ArrayNotAllowedSelected) And $a_BDV_ArrayNotAllowedSelected[$iI] < $iChar
		$iI += 1
	WEnd
	If $iI < UBound($a_BDV_ArrayNotAllowedSelected) And $a_BDV_ArrayNotAllowedSelected[$iI] == $iChar Then Return ChrW($iChar)
	Return 0
EndFunc

Func __BDV_IsSameArray($aArray1, $aArray2)
	If Ubound($aArray1) <> Ubound($aArray2) Then Return False
	Local $iI = 0
	While $iI < Ubound($aArray1) And $aArray1[$iI] == $aArray2[$iI]
		$iI += 1
	WEnd
	If $iI < Ubound($aArray1) Then Return False
	Return True
EndFunc			

;TODO Resolve this little speed down
Func __BDV_ChangeArrayNotAllowed($aArrayNotAllowed)
	;if __BDV_IsSameArray($a_BDV_ArrayNotAllowedSelected,$aArrayNotAllowed) then return
	$a_BDV_ArrayNotAllowedSelected = $aArrayNotAllowed
	Local $aA
	$a_BDV_Special = $aA
	$a_BDV_Digit = $aA
	$a_BDV_Upper = $aA
	$a_BDV_Lower = $aA
	$a_BDV_Symbol1 = $aA
	$a_BDV_Symbol2 = $aA
	$a_BDV_Symbol3 = $aA
	$a_BDV_Symbol4 = $aA
	$a_BDV_Accented = $aA
EndFunc

Func __BDV_isSpecialIniEnd($iChar, $iShift, $iIni, $iEnd, ByRef $aiArray, $SpecialAccepted)
	If $iChar < $iIni Or $iChar > $iEnd Then Return 0
	If Not $SpecialAccepted Then Return ChrW($iChar)
	$aiArray = __BDV_buildNotAllowedArray($aiArray, $iIni, $iEnd)
	Return __BDV_ShiftSingle($iChar, $iShift, $aiArray)
EndFunc

Func __BDV_isBetweenIniEnd($iChar, $iShift, $iIni, $iEnd, ByRef $aiArray)
	If $iChar < $iIni Or $iChar > $iEnd Then Return 0
	$aiArray = __BDV_buildNotAllowedArray($aiArray, $iIni, $iEnd)
	Return __BDV_ShiftSingle($iChar, $iShift, $aiArray)
EndFunc

Func __BDV_ShiftSingle($iChar, $iShift, $aiArray)
	Local $iI = Mod(__BDV_FindCharNotEnd($iChar, $aiArray) + $iShift, UBound($aiArray))
	;Local $iI = Mod($iChar + $iShift, UBound($aiArray))
	If $iI < 0 Then $iI += UBound($aiArray)
	Return ChrW($aiArray[$iI])
EndFunc

Func __BDV_FindCharNotEnd($iChar, $aiArray)
	Local $iI = 0
	While $iChar > $aiArray[$iI]
		$iI += 1
	WEnd
	Return $iI
EndFunc	

Func __BDV_buildNotAllowedArray($aiArray, $iIni, $iEnd)
	If Ubound($aiArray) Then Return $aiArray
	Local $aExlude = __BDV_getSubArrayBetween($a_BDV_ArrayNotAllowedSelected, $iIni, $iEnd)
	Local $aiLocalArray[$iEnd-$iIni + 1 - UBound($aExlude)]
	Local $iI = 0
	While $iIni <= $IEnd
		If Not __BDV_isInArray($iIni, $aExlude) Then
			$aiLocalArray[$iI] = $iIni
			$iI += 1
		EndIf
		$iIni += 1
	WEnd
	Return $aiLocalArray
EndFunc

Func __BDV_isInArray($iVal, $aArray)
	If __BDV_FindInArray($iVal, $aArray) == -1 Then Return False
	Return True
EndFunc

Func __BDV_FindInArray($iVal, $aArray)
	Local $iI = 0
	While $iI < Ubound($aArray) And $aArray[$iI] < $iVal
		$iI += 1
	WEnd
	If $iI < Ubound($aArray) And $aArray[$iI] == $iVal Then Return $iI
	Return -1
EndFunc

Func __BDV_getSubArrayBetween($aArray, $iIni, $iEnd)
	Local $aSubArray[1]
	Local $iI = 0
	Local $iK = 0
	While $iI < Ubound($aArray) And $aArray[$iI] <= $iEnd
		If $aArray[$iI] >=  $iIni Then 
			$iK += 1
			Redim $aSubArray[$iK]
			$aSubArray[$iK - 1] = $aArray[$iI]
		EndIf
		$iI += 1
	WEnd
	If $iK == 0 Then Return ""
	Return $aSubArray
EndFunc

#cs
Func _BDV_testAllArrays($bTest=true)
	;_Dbg_printArray($ai_BDV_AllAllowed,"$ai_BDV_AllAllowed",$bTest,"-")
	;_Dbg_printArray($ai_BDV_NotAllowedFile,"$ai_BDV_NotAllowedFile",$bTest,"-")
	;_Dbg_printArray($ai_BDV_NotAllowedFileAndPoint,"$ai_BDV_NotAllowedFileAndPoint",$bTest,"-")
	;_Dbg_printArray($ai_BDV_Jump,"$ai_BDV_Jump",$bTest,"-")
	_Dbg_printArray($a_BDV_ArrayNotAllowedSelected,"$a_BDV_ArrayNotAllowedSelected",$bTest,"-")
	_Dbg_printArray($ai_BDV_AllAllowed,"$ai_BDV_AllAllowed",$bTest,"-")
EndFunc

Func _BDV_testSelectArray($iArray,$bTest=true)
	switch $iArray
	case 1 
		_Dbg_printArray($ai_BDV_AllAllowed,"$ai_BDV_AllAllowed",$bTest,"-")
	case 2
		_Dbg_printArray($ai_BDV_NotAllowedFile,"$ai_BDV_NotAllowedFile",$bTest,"-")
	case 3
		_Dbg_printArray($ai_BDV_NotAllowedFileAndPoint,"$ai_BDV_NotAllowedFileAndPoint",$bTest,"-")
	case 4
		_Dbg_printArray($ai_BDV_Jump,"$ai_BDV_Jump",$bTest,"-")
	case 5
		_Dbg_printArray($a_BDV_ArrayNotAllowedSelected,"$a_BDV_ArrayNotAllowedSelected",$bTest,"-")
	case 6
		_Dbg_printArray($ai_BDV_AllAllowed,"$ai_BDV_AllAllowed",$bTest,"-")
	case else
	endswitch
EndFunc

Func _BDV_testAllArraysDimension($bTest=true)
	if not $bTest then return
	Local $sDims = "" 
	$sDims &= Ubound($ai_BDV_AllAllowed) & " " 
	$sDims &= Ubound($ai_BDV_NotAllowedFile) & " " 
	$sDims &= Ubound($ai_BDV_NotAllowedFileAndPoint) & " " 
	$sDims &= Ubound($ai_BDV_Jump) & " " 
	$sDims &= Ubound($a_BDV_ArrayNotAllowedSelected) & " " 
	$sDims &= Ubound($ai_BDV_AllAllowed) & " " 
	$sDims &= Ubound($a_BDV_Special) & " " 
	$sDims &= Ubound($a_BDV_Digit) & " " 
	$sDims &= Ubound($a_BDV_Upper) & " " 
	$sDims &= Ubound($a_BDV_Lower) & " " 
	$sDims &= Ubound($a_BDV_Symbol1) & " " 
	$sDims &= Ubound($a_BDV_Symbol2) & " " 
	$sDims &= Ubound($a_BDV_Symbol3) & " " 
	$sDims &= Ubound($a_BDV_Symbol4) & " " 
	$sDims &= Ubound($a_BDV_Accented) & " " 
	_Dbg_out(">>> " & $sDims)
EndFunc
#ce