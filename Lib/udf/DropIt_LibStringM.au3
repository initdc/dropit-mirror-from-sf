; !!! VERSION 0.1 !!!
#include-once
; #INDEX#===================================================================================================
; Title .........: String Operation
; AutoIt Version : 3.3.8.0++
; Language ......: English
; Description ...: Some operation on String
; Author(s) .....: Daneel
; Notes .........: Function Name: _FileName_(Word)*
;                  Var Name: $type_FileName_(Word)*
;                  Private Function: __FileName_(Word)*
;                  New note funtion: GlobalVar: Read,
;                                               Write,
;                                               FunctionRW(possible read/write in called function)
;                                               FunctionR (write NOT allowed in called function)
; Exe(s) ........:
; ==========================================================================================================

; #CURRENT# ================================================================================================
; _StringM_extractBetweenString($sSource, $iFrom, $sPreviusString, $sNextString)
; _StringM_FirstLetterUP($sSource)
; _StringM_LowerAllExcetFirstLetter($sSource)
; _StringM_getStringBetween($sString, $sSubString1, $sSubString2, $including = 0)
; ==========================================================================================================

;#INTERNAL_USE_ONLY# =======================================================================================
; ==========================================================================================================

; #FUNCTION# ===============================================================================================
;
; Name...........: _StringM_extractBetweenString
; Description ...: Return a string between other two from a start point
; Syntax.........: _StringM_extractBetweenString($sSource, $iOccurence, $sPreviusString, $sNextString)
; Parameters ....: $sSource - the source string
;                  $iOccurence - index where start to search, $iOccurence > 0
;                  $sPreviusString - First string to find
;                  $sNextString - Second string to find
; Return values .: A string between $sPreviusString and $sNextString or
;                  if there is an error return "" and set @error to
;				   1 - if first string is not found
;                  2 - if second string is not found
; GlobalVar .....:
; Author ........: Daneel
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ============================================================================================
Func _StringM_ExtractBetweenString($sSource, $iOccurence, $sPreviusString, $sNextString)
	Local $iStart = StringInStr($sSource, $sPreviusString, 0, 1, $iOccurence) + StringLen($sPreviusString)
	If Not $iStart Then
		Return SetError(1, 0, "")
	EndIf
	Local $iEnd = StringInStr($sSource, $sNextString, 0, 1, $iStart) - $iStart
	If $iEnd <= 0 Then
		Return SetError(2, 0, "")
	EndIf
	Return StringMid($sSource, $iStart, $iEnd)
EndFunc

; #FUNCTION# ===============================================================================================
;
; Name...........: _StringM_FirstLetterUpAllWord
; Description ...: Return a string where all word after space have first letter uppercase
; Syntax.........: _StringM_FirstLetterUpAllWord($sSource)
; Parameters ....: $sSource - the source string
; Return values .: Same as Description
; GlobalVar .....:
; Author ........: Daneel
; Modified.......:
; Remarks .......:
; Related .......: __StringM_RegExpOnArray
; Link ..........;
; Example .......; Yes
; ============================================================================================
Func _StringM_FirstLetterUpAllWord($sSource, $regExpSetInWord = "")
	Return __StringM_RegExpOnArray($sSource, '(*UCP)\W+|\d+|[\p{L}\-_' & $regExpSetInWord & ']+', '(.)(.*)', 'StringUpper("\1")&"\2"')
EndFunc

; #FUNCTION# ===============================================================================================
;
; Name...........: _StringM_LowerAllExceptFirstLetter
; Description ...: Return a string where all letters are lower case leaving untouched all first letter of a word
; Syntax.........: _StringM_LowerAllExceptFirstLetter($sSource)
; Parameters ....: $sSource - the source string
; Return values .: Same as Description
; GlobalVar .....:
; Author ........: Daneel
; Modified.......:
; Remarks .......:
; Related .......: __StringM_RegExpOnArray
; Link ..........;
; Example .......; Yes
; ============================================================================================
Func _StringM_LowerAllExceptFirstLetter($sSource, $regExpSetInWord = "")
	Return __StringM_RegExpOnArray($sSource, '(*UCP)\W+|\d+|[\p{L}\-_' & $regExpSetInWord & ']+', '(.)(.*)', '"\1"&StringLower("\2")')
EndFunc

; #FUNCTION# ===============================================================================================
;
; Name...........: __StringM_RegExpOnArray
; Description ...: With two rules, split the string and replace every item with the action
; Syntax.........: __StringM_RegExpOnArray($sSource)
; Parameters ....: $sSource - the source string
;				   $sRuleArraySlit - rule to slit the source in an array
;                  $sRuleItem - rule applied on a single item of the array
;                  $sActionReplace - rule to replace according $sRuleItem
; Return values .: Return the string replaced
; GlobalVar .....:
; Author ........: Daneel
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; No
; ============================================================================================
Func __StringM_RegExpOnArray($sSource, $sRuleArraySplit, $sRuleItem, $sActionReplace)
	Local $sWord = ""
	Local $as_Array = StringRegExp($sSource, $sRuleArraySplit, 3)
	For $elem in $as_Array
		$sWord &= execute(StringRegExpReplace($elem, $sRuleItem, $sActionReplace))
	Next
	Return $sWord
EndFunc

; #FUNCTION# ===============================================================================================
;
; Name...........: _StringM_getStringBetween
; Description ...: Extract a string between 2 substring
; Syntax.........: _StringM_getStringBetween($sString, $sSubString1, $sSubString2, $including = 0)
; Parameters ....: $sString - the source string
;				   $sSubString1 - left substring
;                  $sSubString2 - right substring
;                  $including - true if the substring have to be included or viceversa
; Return values .: Return the substring or an empty string if StringInStr fail or if the index are inverted
; GlobalVar .....:
; Author ........: Daneel
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; No
; ============================================================================================
Func _StringM_getStringBetween($sString, $sSubString1, $sSubString2, $including = 0)
	Local $iStart = StringInStr($sString, $sSubString1)
	If Not $including Then
		$iStart += StringLen($sSubString1)
	EndIf
	Local $iEnd = StringInStr($sString, $sSubString2)
	If $including Then
		$iEnd += StringLen($sSubString2)
	EndIf
	Return StringMid($sString, $iStart, $iEnd - $iStart)
EndFunc

; #FUNCTION# ===============================================================================================
;
; Name...........: _StringM_UpperLowerString
; Description ...: Alternates upper letter and lower letter
; Syntax.........: _StringM_UpperLowerString($sString, $bSpaceExcluded = True)
; Parameters ....: $sString - the source string
;				   $bSpaceExcluded - if true "space" is not considered in the alternation
; Return values .: Return a string that alternates lower and upper letter
; GlobalVar .....:
; Author ........: Daneel
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; No
; ============================================================================================
Func _StringM_UpperLowerString($sString, $bSpaceExcluded = True)
	Local $sResult = ""
	Local $bSwitch = True
	Local $aString = StringSplit($sString, "", 2)
	For $elem In $aString
		If $bSpaceExcluded And $elem == " " Then
			$sResult &= $elem
		Else
			If $bSwitch Then
				$sResult &= StringUpper($elem)
			Else
				$sResult &= StringLower($elem)
			EndIf
			$bSwitch = Not $bSwitch
		EndIf
	Next
	Return $sResult
EndFunc

; #FUNCTION# ===============================================================================================
;
; Name...........: _StringM_DeleteBetween
; Description ...: Return a String without a delimited substring
; Syntax.........: _StringM_DeleteBetween($sString, $sSubString1, $sSubString2, $included = 0, $occurance1 = 1, $occurance2 = 1)
; Parameters ....: $sString - the source string
;				   $sSubString1 - left substring delimeter
;                  $sSubString2 - right substring delimeter
;                  $including - true if the substring have to be included or viceversa
;				   $occurence1 = occurence of the first delimeter
;				   $occurence2 = occurence of the second delimeter
; Return values .: Return a String without the delimited substring or the orginal string if delimeter not exist
; GlobalVar .....:
; Author ........: Daneel
; Modified.......:
; Remarks .......: The function is case sensitive
; Related .......:
; Link ..........;
; Example .......; No
; ============================================================================================
Func _StringM_DeleteBetween($sString, $sSubString1, $sSubString2, $included = 0, $occurance1 = 1, $occurance2 = 1)
	Local $iStart = StringInStr($sString, $sSubString1, 1, $occurance1)
	If $iStart == 0 Then
		Return $sString
	EndIf
	If Not $included Then
		$iStart += StringLen($sSubString1)
	EndIf
	Local $sStart = StringMid($sString, 1, $iStart - 1)
	Local $sEnd = StringMid($sString, $iStart + StringLen($sSubString1))
	Local $iEnd = StringInStr($sEnd, $sSubString2, 1, $occurance2)
	If $iEnd == 0 Then
		Return $sString
	EndIf
	If $included Then
		$iEnd += StringLen($sSubString2)
	EndIf
	Return $sStart & StringMid($sEnd, $iEnd)
EndFunc

; #FUNCTION# ===============================================================================================
;
; Name...........: _StringM_KeepSingleChars
; Description ...: Return a String with or without a group of characters
; Syntax.........: _StringM_KeepSingleChars($sString, $sChars, $delete = 0)
; Parameters ....: $sString - the source string
;				   $sChars - the group of characters
;                  $delete - 1 to remove characters or 0 to keep them
; Return values .: Return a String with or without the group of characters
; GlobalVar .....:
; Author ........: Lupo73
; Modified.......:
; Remarks .......: The function is case sensitive
; Related .......:
; Link ..........;
; Example .......; No
; ============================================================================================
Func _StringM_KeepSingleChars($sString, $sChars, $delete = 0)
	Local $sExclude = $delete ? "" : "^"
	Return StringRegExpReplace($sString, "[" & $sExclude & "\Q" & $sChars & "\E]", "")
EndFunc

; #FUNCTION# ===============================================================================================
;
; Name...........: _StringM_AddLeadingZeros
; Description ...: Return a String filled with a number of leading zeros
; Syntax.........: _StringM_AddLeadingZeros($sString, $iLeadingZeros = 0)
; Parameters ....: $sString - the source string
;				   $iLeadingZeros = length of the string to fill
; Return values .: Return the filled String
; GlobalVar .....:
; Author ........: Lupo73
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; No
; ============================================================================================
Func _StringM_AddLeadingZeros($sString, $iLeadingZeros = 0)
	Local $iToAdd = $iLeadingZeros - StringLen($sString)
	If $iToAdd > 0 Then
		Local $sZeros
		For $A = 1 To $iToAdd
			$sZeros &= "0"
		Next
		$sString = $sZeros & $sString
	EndIf
	Return $sString
EndFunc
