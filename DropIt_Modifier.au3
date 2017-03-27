; !!! VERSION 0.4 !!!
; Version note at the end of this file
#include-once
#include <DropIt_Global.au3>
#include "Lib\udf\DropIt_LibBDV.au3"
#include "Lib\udf\DropIt_LibStringM.au3"

; #INDEX#===================================================================================================
; Title .........: Abbreviation Modifier
; AutoIt Version : 3.3.8.0++
; Language ......: English
; Description ...: Process Abbreviation with Modifier in file Action/Destination
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


; #VARIABLES# ==============================================================================================
Global $i_Modifier_ModifierRulesLength = 33  ;Note UBound($modifierRules) - 1 not used
Global Const $i_Modifier_ModifierRule = 0         ;Indexes of inner array
Global Const $i_Modifier_ModifierWhat = 1
Global Const $i_Modifier_ModifierAction = 2
Global Const $i_Modifier_MultiSplitter = 3
Global Const $i_Modifier_MultiAction = 4
Global Const $i_Modifier_MultiNameCut = 5
;Var with modifier format: %VarName#modifier%
Global $s_Modifier_ModifierEscapeChar = $STATIC_MODIFIER_ESCAPE_CHAR
Global $s_Modifier_VarEscapeChar = $STATIC_ABBREVIATION_ESCAPE_CHAR


;Attention: action from ModifierRule is with "\" and action from ModifierWhat is "/"
;Modifier array [n][6] = [n]["Modifier Rule", "Applicantion Rule (What)", "Application (Action)","MultiAction"..]
Global $aas_Modifier_ModifierRules[$i_Modifier_ModifierRulesLength][6] = [ _
	["[+]" , "(.)(.*)", 'StringUpper("/1")&"/2"'], _
	["[+][+]", "(.+)", '_StringM_FirstLetterUpAllWord("/1")'],  _
	["[+][+][+]", "(.+)", 'StringUpper("/1")'],  _
	["[-]" , "(.)(.*)", 'StringLower("/1")&"/2"'], _
	["[-][-]", "(.+)", '_StringM_LowerAllExceptFirstLetter("/1")'],  _
	["[-][-][-]", "(.+)", 'StringLower("/1")'],  _
	["[>](\d+)[,](\d+)","(.+)",'StringMid("/1", \1, \2 )'], _
	["[<](\d+)[,](\d+)","(.+)",'StringMid("/1", StringLen ("/1") - \1 - \2 +2 , \2 )'], _
	["[-](\d+)[,](\d+)","(.+)",'StringMid("/1", \1, \2 - \1 + 1)'], _
	["[r][(](.+)[,](.+)[)]","(.+)",'StringReplace("/1", "\1","\2")'], _
	["[d][(](.+)[)]","(.+)",'StringReplace("/1", "\1","")'], _
	["[c][>](.+)","(.+)",'StringTrimLeft("/1", \1)'], _
	["[c][<](.+)","(.+)",'StringTrimRight("/1", \1)'], _
	["[s][>][(](.+)[)]","(.+)", 'StringMid("/1",StringInStr ("/1", "\1"))' ], _
	["[s][>][-][(](.+)[)]","(.+)" ,'StringMid("/1",StringInStr ("/1", "\1") + StringLen("\1"))' ], _
	["[s][<][(](.+)[)]","(.+)",'StringMid("/1",1,StringInStr ("/1", "\1") + StringLen("\1") -1)'], _
	["[s][<][-][(](.+)[)]","(.+)" ,'StringMid("/1",1,StringInStr ("/1", "\1") -1)'], _
	["[s][-][(](.+),(.+)[)]","(.+)" ,'_StringM_getStringBetween("/1","\1","\2",true)'], _
	["[s][-][-][(](.+),(.+)[)]","(.+)" ,'_StringM_getStringBetween("/1","\1","\2")' ], _
	["[?][?]","(.+)" ,'_StringM_UpperLowerString("/1",false)'], _
	["[?][ ][?]","(.+)" ,'_StringM_UpperLowerString("/1")'], _
	["[E][n][(](.+)[)]","(.+)" ,'_BDV_Encrypt("/1","\1",2)'], _
	["[D][e][(](.+)[)]","(.+)" ,'_BDV_Decrypt("/1","\1",2)'], _
	["[E][n][N][P][t][(](.+)[)]","(.+)" ,'_BDV_Encrypt("/1","\1",2,true,false)'], _
	["[D][e][N][P][t][(](.+)[)]","(.+)" ,'_BDV_Decrypt("/1","\1",2,true,false)'], _
	["[E][n][N][S][p][(](.+)[)]","(.+)" ,'_BDV_Encrypt("/1","\1",2,false,true)'], _
	["[D][e][N][S][p][(](.+)[)]","(.+)" ,'_BDV_Decrypt("/1","\1",2,false,true)'], _
	["[E][n][N][S][p][P][t][(](.+)[)]","(.+)" ,'_BDV_Encrypt("/1","\1",2,true,true)'], _
	["[D][e][N][S][p][P][t][(](.+)[)]","(.+)" ,'_BDV_Decrypt("/1","\1",2,true,true)'], _
	["[E][n][(](.+)[,](.+)[)]","(.+)" ,'_BDV_Encrypt("/1","\1",2,false,false,"\2")'], _
	["[D][e][(](.+)[,](.+)[)]","(.+)" ,'_BDV_Decrypt("/1","\1",2,false,false,"\2")']]


; ==========================================================================================================

; #CURRENT# ================================================================================================
; Func _Modifier_StringReplaceModifier($sWhereReplace, $sVarName, $sVarValue)
; ==========================================================================================================

;#INTERNAL_USE_ONLY# =======================================================================================
; Func _Modifier_ActiveModifier($sVarValue,$sModifierRequest)
; ==========================================================================================================

; #FUNCTION# ===============================================================================================
;
; Name...........: _Modifier_StringReplaceModifier
; Description ...: Replace in $sWhereReplace the occurrences of $sVarName with $sVarValue applying modifier
; Syntax.........: _Modifier_StringReplaceModifier($sWhereReplace, $sVarName, $sVarValue)
; Parameters ....: $sWhereReplace - the original string with var in format %var% or %var#modifier%
;                  $sVarName - the name of var in %var% or %var#modifier% without %
;                  $sVarValue - the value of a varName
; Return values .: A string with all occurences of varname replaced
; GlobalVar .....: Read,Function
; Author ........: Daneel
; Modified.......:
; Remarks .......: % and # is the orginal ones but the used one are stored in global var
; Related .......:
; Link ..........;
; Example .......; Yes
; ============================================================================================
Func _Modifier_StringReplaceModifier($sWhereReplace, $sVarName, $sVarValue)
	Local $sVEC = $s_Modifier_VarEscapeChar
	Local $sMEC = $s_Modifier_ModifierEscapeChar
	; This line replace standard abbreviation
	$sWhereReplace = StringReplace($sWhereReplace, $sVEC & $sVarName & $sVEC, $sVarValue)
	Local $iOccurrences = StringInStr($sWhereReplace, $sVEC & $sVarName & $sMEC)
	While $iOccurrences > 0
		Local $sModifierRequest = _StringM_ExtractBetweenString($sWhereReplace,$iOccurrences,$sMEC,$sVEC)
		Local $sAction = __Modifier_ActiveMultiModifier($sVarValue,$sModifierRequest)
		$sWhereReplace = StringReplace($sWhereReplace, $sVEC & $sVarName & $sMEC & $sModifierRequest & $sVEC, $sAction)
		$iOccurrences = StringInStr($sWhereReplace, $sVEC & $sVarName & $sMEC)
	WEnd
	Return $sWhereReplace
EndFunc

; #FUNCTION# ===============================================================================================
;
; Name...........: __Modifier_ActiveModifier
; Description ...: Find the modifier and apply it on a string, if not find return not apply
; Syntax.........: __Modifier_ActiveModifier($sVarValue,$sModifierRequest)
; Parameters ....: $sVarValue - string to modify
;                  $sModifierRequest - modifier found
; Return values .: String modified or if modifer not found or empty, the original string
; GlobalVar .....: Read
; Author ........: Daneel
; Modified.......:
; Remarks .......: Change StrngCompare with StringRegExp +\A...\z for start and end of a string
; Related .......: __Modifier_StringReplaceModifier
; Link ..........;
; Example .......; NO
; ============================================================================================
Func __Modifier_ActiveModifier($sVarValue, $sModifierRequest)
	;_dbg_out($sVarValue & " " & $sModifierRequest)
	Local $iLength = $i_Modifier_ModifierRulesLength
	Local $iI = 0

	While $iI < $iLength And 0 == StringRegExp($sModifierRequest,"\A" & $aas_Modifier_ModifierRules[$iI][$i_Modifier_ModifierRule] & "\z")
		$iI += 1
	WEnd

	;_Dbg_out("is " & $sModifierRequest& " " &$iI  & " " & $iLength & " " & $sVarValue)
	If $iI == $iLength Then Return $sVarValue ;Modifier not found so not applied to value

	If Not $aas_Modifier_ModifierRules[$iI][$i_Modifier_MultiSplitter] Then
		Return __Modifier_ActiveMonoModifier($sVarValue, $sModifierRequest, $iI, $aas_Modifier_ModifierRules[$iI][$i_Modifier_ModifierRule])
	EndIf

	$sModifierRequest = StringTrimLeft($sModifierRequest,$aas_Modifier_ModifierRules[$iI][$i_Modifier_MultiNameCut])

	Local $as_Array = StringSplit($sModifierRequest,$aas_Modifier_ModifierRules[$iI][$i_Modifier_MultiSplitter], 2)

	For $elem in $as_Array
		$sVarValue = __Modifier_ActiveMonoModifier($sVarValue,$elem,$iI,$aas_Modifier_ModifierRules[$iI][$i_Modifier_MultiAction])
	Next

	Return $sVarValue
EndFunc

Func __Modifier_ActiveMonoModifier($sVarValue,$sModifierRequest, $iI, $sModifierRule)
	Local $modToAction = StringRegExpReplace($sModifierRequest, $sModifierRule, $aas_Modifier_ModifierRules[$iI][$i_Modifier_ModifierAction])
	Local $activeAction = StringReplace ($modToAction,"/","\")
	#cs
	_dbg_out("act " &$activeAction)

	_dbg_out("act2 " & StringRegExpReplace($sVarValue, $aas_Modifier_ModifierRules[$iI][$i_Modifier_ModifierWhat], $activeAction))

	_dbg_line("+")
	#ce
	Return Execute(StringRegExpReplace($sVarValue, $aas_Modifier_ModifierRules[$iI][$i_Modifier_ModifierWhat], $activeAction))
EndFunc

; #FUNCTION# ===============================================================================================
;
; Name...........: __Modifier_ActiveMultiModifier
; Description ...: Find the modifiers between Modifier_Escape_Char and apply them on a string
; Syntax.........: __Modifier_ActiveMultiModifier($sVarValue,$sModifierRequest)
; Parameters ....: $sVarValue - string to modify
;                  $sModifierRequest - modifiers found
; Return values .: String modified or if modifers not found or empty, the original string
; GlobalVar .....: Read
; Author ........: Daneel
; Modified.......:
; Remarks .......:
; Related .......: __Modifier_ActiveModifier
; Link ..........;
; Example .......; NO
; ============================================================================================
Func __Modifier_ActiveMultiModifier($sVarValue,$sModifierRequest)
	Local $as_Array = StringSplit($sModifierRequest,$s_Modifier_ModifierEscapeChar,2)
	For $elem in $as_Array
		$sVarValue = __Modifier_ActiveModifier($sVarValue,$elem)
	Next
	Return $sVarValue
EndFunc


#cs
; * Modifiers list at the end

Version 0.1
- Initial Release

Version 0.2
- Udf format
- Modifiers added:
	- +
	- ++
	- +++

Version 0.3
- Modifiers added:
	- -
	- --
	- ---
	- >d1,d2
	- <d1,d2
	- -d1,d2
	- r(s1,s2)
	- d(s)
	- >(s)
	- >-(s)
	- <(s)
	- <-(s)
	- -(s1,s2)
	- --(s1,s2)
	- /\
	- / \
	- Encr(pass);Encrypt with password (not the file,but the abbreviaton)
	- Decr(pass);Decrypt with password (not the file,but the abbreviation)

- Chaged function to apply modifier.

- Support to MultiModifier. %abbreviation#modifier1#modifier2#modifier3#....#modifierN%

Version 0.4

- Chaged function to apply modifier. Added multiple action of the same modifier

- Modifiers added:
	-r:s1,s2|s3,s4...
	-d:s1|s2...

- Modifier Changed
	- /\ to ??
	- / \ to ? ?

- Many critical bug fix:


#ce

#cs
- Rejceted
- Modifiers with Smilies: most of these use character not allowed in file

#ce

#cs
TODO:
Modifiers:
	- String cleaning on pattern
	- Math modifier
	- If-then-else modifier

	- With var
	- Simple modifier of a set of other modifier
	- Concatenated (now modifiers are applied from right to left, with this modifier can be applie on other modifier)
	- Other Crazy Modifier (no idea!)

User modifier (not here):
	- with autoit code
	- with built-in modifier
	- with regular expression

Multi file modifier (not here)
Crypt and Decrypt file (not here)
Prompter modifier

#ce


#cs Modifiers list
	- +			;Uppercase the first letter of the entire string
	- ++		;Uppercase all the first letter of eash word in the string
	- +++		;Uppercase all the letter in the string
	- -			;Lowercase the first letter of the entire string
	- --		;Lowercase all the letter ignoring the first letter of eash word in the string
	- ---		;Lowercase all the letter
	- >d1,d2	;Retrive a string from position d1 included counting d2 position
	- <d1,d2	;Retrive a string from position d1 included counting d2 position from the right side
	- -d1,d2	;Retrive a string between d1 and d2 postions
	- r(s1,s2)	;Rename all occurences of the string s1 with string s2
	- r:s1,s2(|s1,s2)* ; Rename many string in couple divided by |
	- d:s1(|s2)* ; Delete many string divided by |
	- d(s1)		;Delete all occurences og the string s1
	- c>d       ;Cut d letter from Ini
	- c<d		;Cut d letter from End
	- s>(s1)		;Retrive a String from the substring s1 included until the end
	- s>-(s1)		;Retrive a String from the substring s1 excluded until the end
	- s<(s1)		;Retrive a String from the substring s1 included until the beginning
	- s<-(s1)		;Retrive a String from the substring s1 excluded until the beginning
	- s-(s1,s2)	;Retrive a String between string s1 and s2 included
	- s--(s1,s2)	;Retrive a String between string s1 and s2 excluded
	- ??		;Alternates letter upper and lower
	- ? ?		;Alternates letter upper and lower but leave space neutral
	- En(pass)  ;Encrypt with password *
	- De(pass)  ;Decrypt with password *
	- EnNPt(pass) ;Encrypt with password, point skipped *
	- DeNPt(pass) ;Decrypt with password, point skipped *
	- EnNSp(pass) ;Encrypt with password, space skipped *
	- DeNSp(pass) ;Decrypt with password, space skipped *
	- EnNSpPt(pass) ;Encrypt with password, space and point skipped *
	- DeNSpPt(pass) ;Decrypt with password, space and point skipped *
	- En(pass,exclude) ;Encrypt with password, skipped all char in exclude strind between , and ) *
	- De(pass,exclude) ;Decrypt with password, skipped all char in exclude strind between , and ) *

* Note: Characters not allowed in filenames are not used. All char are valid for password

#ce