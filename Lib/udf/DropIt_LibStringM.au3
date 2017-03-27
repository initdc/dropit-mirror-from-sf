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
; _StringM_extractBetweenString($sSource,$iFrom,$sPreviusString,$sNextString)
; _StringM_FirstLetterUP($sSource)
; _StringM_LowerAllExcetFirstLetter($sSource)
; _StringM_getStringBetween($sString,$sSubString1,$sSubString2,$including = 0)
; ==========================================================================================================

;#INTERNAL_USE_ONLY# =======================================================================================
; ==========================================================================================================

; #FUNCTION# ===============================================================================================
;
; Name...........: _StringM_extractBetweenString
; Description ...: Return a string between other two from a start point
; Syntax.........: _StringM_extractBetweenString($sSource,$iOccurence,$sPreviusString,$sNextString)
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
	If Not $iStart Then Return SetError(1, 0, "")
	Local $iEnd = StringInStr($sSource, $sNextString, 0, 1, $iStart) - $iStart
	If $iEnd <= 0 Then Return SetError(2, 0, "")
	Return StringMid($sSource, $iStart, $iEnd)
EndFunc

; #FUNCTION# ===============================================================================================
;
; Name...........: _StringM_FirstLetterUpAllWord
; Description ...: Return a string where all word after space have first letter uppercase
; Syntax.........: _StringM_FirstLetterUpAllWord($sSource)
; Parameters ....: $sSource - the source string
; Return values .: Return a string where all word after space have first letter uppercase
; GlobalVar .....: 
; Author ........: Daneel
; Modified.......:
; Remarks .......: 
; Related .......: __StringM_RegExpOnArray
; Link ..........;
; Example .......; Yes
; ============================================================================================
Func _StringM_FirstLetterUpAllWord($sSource,$regExpSetInWord="")
	Return __StringM_RegExpOnArray($sSource,'\W+|\d+|[a-zA-Z' & $regExpSetInWord & ']+','(.)(.*)', 'StringUpper("\1")&"\2"')	
EndFunc

; #FUNCTION# ===============================================================================================
;
; Name...........: _StringM_LowerAllExceptFirstLetter
; Description ...: Return a string where all letters are lower case leaving untouched  all first letter of a word 
; Description ...: Return a string where all letters are lower case leaving untouched  all first letter of a word 
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
Func _StringM_LowerAllExceptFirstLetter($sSource,$regExpSetInWord="")
	Return __StringM_RegExpOnArray($sSource,'\W+|\d+|[a-zA-Z' & $regExpSetInWord & ']+','(.)(.*)', '"\1"&StringLower("\2")')
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
Func __StringM_RegExpOnArray($sSource,$sRuleArraySplit,$sRuleItem,$sActionReplace)
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
; Syntax.........: _StringM_getStringBetween($sString,$sSubString1,$sSubString2,$including = 0)
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
Func _StringM_getStringBetween($sString,$sSubString1,$sSubString2,$including = 0)
	Local $iStart = StringInStr($sString, $sSubString1)
	If Not $including Then $iStart += StringLen ($sSubString1)
	Local $iEnd = StringInStr($sString, $sSubString2)
	If $including Then $iEnd += StringLen ($sSubString2)
	Return StringMid($sString,$iStart,$iEnd - $iStart)
EndFunc

; #FUNCTION# ===============================================================================================
;
; Name...........: _StringM_UpperLowerString
; Description ...: Alternates upper letter and lower letter
; Syntax.........: _StringM_UpperLowerString($sString,$bSpaceExcluded = True)
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
Func _StringM_UpperLowerString($sString,$bSpaceExcluded = True)
	Local $sResult = ""
	Local $bSwitch = True
	Local $aString = StringSplit($sString, "" , 2)
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
