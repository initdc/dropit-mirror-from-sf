#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=ic.ico
#AutoIt3Wrapper_outfile=DropIt.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=N
#AutoIt3Wrapper_Res_Comment=DropIt - To place your files with a drop
#AutoIt3Wrapper_Res_Description=DropIt
#AutoIt3Wrapper_Res_Fileversion=0.8.2.0
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_LegalCopyright=by Lupo PenSuite Team
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/striponly
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#Include <GUIListBox.au3>

Opt("MustDeclareVars", 1)
Opt("TrayIconHide", 1)
Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 1)

Global $sName = "DropIt", $sVer = " (v0.8.2)", $ii = $sName & " - To place your files with a drop"
Global $sIni = @ScriptDir & "\settings.ini", $PrDir = @ScriptDir & "\profiles", $sIniPr, $sIm = @ScriptDir & "\img\image.gif", $sPic = @ScriptDir & "\img\ps.gif"
Global $hGUI1, $hGUI2, $sData, $temp, $i, $top, $Show, $Separ, $Exit, $list, $gaDropFiles[1], $RelPos[2]
Global Const $WM_DROPFILES = 0x233, $SC_MOVE = 0xF010, $WM_ENTERSIZEMOVE = 0x231, $WM_EXITSIZEMOVE = 0x232
Global $xD = IniRead($sIni, "General", "SizeX", "64"), $yD = IniRead($sIni, "General", "SizeY", "64")
Global $EP = "Exclusion-Pattern"
Global $tips = '- As destination folders are supported both absolute ("C:\Lupo\My Images") and relative ("..\My Images") paths.' & @LF & @LF & '- If you want to use different pattern groups, for example on different computers, you can click "Profiles" -> "Customize" to create and manage them.' & @LF & @LF & '- If you want to exclude files that match with a specified pattern, you can add "$" at the end of the pattern itself (for example:  *.exe$ ).' & @LF & @LF & '- If you need more info about supported pattern rules, you can click the "Rules" button and see a list of possible patterns.'
Global $prs = 'Supported pattern rules for files:' & @LF & '*.zip   = all files with "zip" extension' & @LF & 'penguin.*   = all files named "penguin"' & @LF & 'penguin*.*   = all files that begins with "penguin"' & @LF & '*penguin.*   = all files that ends with "penguin"' & @LF & '*penguin*   = all files that contains "penguin"' & @LF & @LF & 'Supported pattern rules for folders:' & @LF & 'robot**   = all folders that begins with "robot"' & @LF & '**robot   = all folders that ends with "robot"' & @LF & '**robot**   = all folders that contains "robot"' & @LF & @LF & 'Add "$" at the end of a pattern to skip files that' & @LF & 'match with it during the dropping (eg:  sky*.jpg$ ).'
Global $er1 = "You have to select a destination folder to associate it.", $er2 = "You have to insert a correct pattern to add the association.", $er3 = "Destination folder already associated for this pattern.", $me1 = "Insert the desired destination folder and write a pattern, to place there files that match with it:", $me2 = "Change the destination folder for files that match with the selected pattern or delete this association:"


If FileExists($sIm) Then
	$list = ProcessList(@ScriptName)
	If $list[0][0] = 0 Or $list[0][0] = 1 Then _Main()
Else
	MsgBox(0, "Image not found", 'Software image not found. You need to have a "img\image.gif" file, to popup it as drop target.')
EndIf


Func Manage()		; OK
	Local $DFA, $sel, $close, $help, $tem, $var, $ff, $decision
	Local $hListBox, $Dir1, $Dir2, $fo1, $fo2, $se1, $se2, $bot1, $bot2, $bot3, $bot4
	$DFA = GUICreate("Destination Folders Association [" & IniRead($sIni, "General", "Profile", "Default") & "]", 410, 280, -1, -1, -1, $WS_EX_TOOLWINDOW, $hGUI1)
	
	GUICtrlCreateGroup("Add Association", 10, 6, 280, 115)
	GUICtrlCreateLabel($me1, 21, 6+17, 260, 40)
	$Dir1 = GUICtrlCreateInput("", 18, 6+50, 207, 20)
	$se1 = GUICtrlCreateButton("Folder", 286-60, 6+49, 56, 22)
	GUICtrlSetTip($se1, "Select a destination folder")
	$bot1 = GUICtrlCreateButton("Rules", 150-54-64, 6+79, 64, 24)
	GUICtrlSetTip($bot1, "Info about supported pattern rules")
	$fo1 = GUICtrlCreateInput("", 150-39, 6+81, 78, 20)
	GUICtrlSetTip($fo1, "Write here the desired pattern")
	$bot2 = GUICtrlCreateButton("Apply", 150+54, 6+79, 64, 24)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	GUICtrlCreateGroup("Edit Associations", 10, 125, 280, 115)
	GUICtrlCreateLabel($me2, 21, 125+17, 260, 40)
	$Dir2 = GUICtrlCreateInput("", 18, 125+50, 207, 20)
	$se2 = GUICtrlCreateButton("Folder", 286-60, 125+49, 56, 22)
	GUICtrlSetTip($se2, "Change the destination folder")
	$bot3 = GUICtrlCreateButton("Delete", 150-54-64, 125+79, 64, 24)
	GUICtrlSetTip($bot3, "Delete this association")
	$fo2 = GUICtrlCreateInput("", 150-39, 125+81, 78, 20)
	$bot4 = GUICtrlCreateButton("Apply",150+54, 125+79, 64, 24)
	GUICtrlSetState($Dir2, $GUI_DISABLE)
	GUICtrlSetState($se2, $GUI_DISABLE)
	GUICtrlSetState($bot3, $GUI_DISABLE)
	GUICtrlSetState($fo2, $GUI_DISABLE)
	GUICtrlSetState($bot4, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	GUICtrlCreateGroup("Pattern List", 300, 6, 100, 234)
	$hListBox = GUICtrlCreateList("", 308, 6+18, 84, 211, BitOr($LBS_DISABLENOSCROLL, $LBS_STANDARD))
	_GUICtrlListBox_BeginUpdate($hListBox)
	$var = IniReadSection($sIniPr, "Patterns")
	If Not @error Then
		For $i = 1 To $var[0][0]
			_GUICtrlListBox_AddString($hListBox, $var[$i][0])
		Next
	EndIf
    _GUICtrlListBox_UpdateHScroll($hListBox)
    _GUICtrlListBox_EndUpdate($hListBox)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	$help = GUICtrlCreateButton("Help", 205-30-100, 247, 100, 24)
	$close = GUICtrlCreateButton("Close", 205+30, 247, 100, 24)
	GUISetState()
	
	While 1
		$sel = GUIGetMsg()
		Switch $sel
			Case $se1
				If $top = "True" Then WinSetOnTop($DFA, "", 0)
				$tem = FileSelectFolder("Select a destination folder:", "", 1)
				If Not($tem = "") Then GUICtrlSetData($Dir1, $tem)
				If $top = "True" Then WinSetOnTop($DFA, "", 1)
				
			Case $se2
				If $top = "True" Then WinSetOnTop($DFA, "", 0)
				$tem = FileSelectFolder("Select a destination folder:", "", 1)
				If Not($tem = "") Then GUICtrlSetData($Dir2, $tem)
				If $top = "True" Then WinSetOnTop($DFA, "", 1)
				
			Case $bot1
				MsgBox(0x40000, "Supported pattern rules", $prs)
				
			Case $bot2
				$tem = GUICtrlRead($Dir1)
				$ff = StringLower(GUICtrlRead($fo1))
				If $ff = "" Or Not(StringInStr($ff, "*")) Then
					MsgBox(0x40000, "Message", $er2)
				Else
					If IniRead($sIniPr, "Patterns", $ff, "0") = "0" Then
						If StringRight($ff, 1) = '$' Then $tem = $EP
						If $tem = "" Then
							MsgBox(0x40000, "Message", $er1)
						Else
							IniWrite($sIniPr, "Patterns", $ff, $tem)
							_GUICtrlListBox_AddString($hListBox, $ff)
							_GUICtrlListBox_Sort($hListBox)
							GUICtrlSetData($Dir1, "")
							GUICtrlSetData($fo1, "")
						EndIf
					Else
						MsgBox(0x40000, "Message", $er3)
					EndIf
				EndIf
				
			Case $bot3
				$decision = MsgBox(0x40004, "Delete Association", 'Are you sure to delete this association?')
				If $decision = 6 Then
					IniDelete($sIniPr, "Patterns", GUICtrlRead($fo2))
					_GUICtrlListBox_DeleteString($hListBox, _GUICtrlListBox_FindString($hListBox, $ff))
					GUICtrlSetData($Dir2, "")
					GUICtrlSetData($fo2, "")
				EndIf
				
			Case $bot4
				$tem = GUICtrlRead($Dir2)
				$ff = StringLower(GUICtrlRead($fo2))
				If $tem = "" Then
					MsgBox(0x40000, "Message", $er1)
				Else
					IniWrite($sIniPr, "Patterns", $ff, $tem)
				EndIf
				
			Case $hListBox
				$ff = GUICtrlRead($hListBox)
				$tem = IniRead($sIniPr, "Patterns", $ff, "")
				If Not($tem = "") Then
					GUICtrlSetState($bot3, $GUI_ENABLE)
					If StringRight($ff, 1) = '$' Then
						GUICtrlSetState($Dir2, $GUI_DISABLE)
						GUICtrlSetState($se2, $GUI_DISABLE)
						GUICtrlSetState($bot4, $GUI_DISABLE)
					Else
						GUICtrlSetState($Dir2, $GUI_ENABLE)
						GUICtrlSetState($se2, $GUI_ENABLE)
						GUICtrlSetState($bot4, $GUI_ENABLE)
					EndIf
					GUICtrlSetData($Dir2, $tem)
					GUICtrlSetData($fo2, $ff)
				EndIf
				
			Case $help
					MsgBox(0x40000, "Tips and tricks", $tips)
				
			Case $close, $GUI_EVENT_CLOSE
				ExitLoop
				
		EndSwitch
	WEnd
	GUIDelete($DFA)
	If $top = "True" Then WinSetOnTop($hGUI1, "", 1)
EndFunc


Func Options()		; OK
	Local $opz, $sel, $check1, $check2, $check3, $check4, $mod1, $mod2, $modA, $do1, $do2, $do3, $ok, $canc, $tp
	$opz = GUICreate("Options", 260, 236, -1, -1, -1, $WS_EX_TOOLWINDOW, $hGUI1)
	
	; group of general options
	GUICtrlCreateGroup("General",10, 6, 240, 104)
	$check1 = GUICtrlCreateCheckbox("Show target image always on top", 24, 6+16)
	$check2 = GUICtrlCreateCheckbox("Lock target image position", 24, 6+16+20)
	$check3 = GUICtrlCreateCheckbox("Active association also for folders", 24, 6+16+40)
	$check4 = GUICtrlCreateCheckbox("Set automatic choice for duplicates", 24, 6+16+60)
	GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group
	
	; group of update procedure options
	GUICtrlCreateGroup("Positioning mode", 10, 114, 110, 84)
	$mod1 = GUICtrlCreateRadio("Move files", 24, 114+16, 90, 20)
	$mod2 = GUICtrlCreateRadio("Copy files", 24, 114+16+20, 90, 20)
	$modA = GUICtrlCreateCheckbox("Ask each drop", 24, 114+16+40)
	GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group
	
	; group of update procedure options
	GUICtrlCreateGroup("Manage duplicates", 130, 114, 120, 84)
	$do1 = GUICtrlCreateRadio("Overwrite files", 144, 114+16, 90, 20)
	$do2 = GUICtrlCreateRadio("Skip files", 144, 114+16+20, 90, 20)
	$do3 = GUICtrlCreateRadio("Rename files", 144, 114+16+40, 90, 20)
	GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group
	
	If IniRead($sIni, "General", "Mode", "Move") = "Move" Then
		GUICtrlSetState($mod1, 1)
		GUICtrlSetState($mod2, 4)
	Else
		GUICtrlSetState($mod1, 4)
		GUICtrlSetState($mod2, 1)
	EndIf
	If IniRead($sIni, "General", "AskMode", "False") = "True" Then
		GUICtrlSetState($modA, $GUI_CHECKED)
		GUICtrlSetState($mod1, $GUI_DISABLE)
		GUICtrlSetState($mod2, $GUI_DISABLE)
	EndIf
	If IniRead($sIni, "General", "Duplicates", "Overwrite") = "Overwrite" Then
		GUICtrlSetState($do1, 1)
		GUICtrlSetState($do2, 4)
		GUICtrlSetState($do3, 4)
	ElseIf IniRead($sIni, "General", "Duplicates", "Overwrite") = "Skip" Then
		GUICtrlSetState($do1, 4)
		GUICtrlSetState($do2, 1)
		GUICtrlSetState($do3, 4)
	Else
		GUICtrlSetState($do1, 4)
		GUICtrlSetState($do2, 4)
		GUICtrlSetState($do3, 1)
	EndIf
	If IniRead($sIni, "General", "OnTop", "True") = "True" Then GUICtrlSetState($check1, $GUI_CHECKED)
	If IniRead($sIni, "General", "LockPos", "True") = "True" Then GUICtrlSetState($check2, $GUI_CHECKED)
	If IniRead($sIni, "General", "DirForFolders", "False") = "True" Then GUICtrlSetState($check3, $GUI_CHECKED)
	If IniRead($sIni, "General", "AutoForDup", "False") = "True" Then
		GUICtrlSetState($check4, $GUI_CHECKED)
	Else
		GUICtrlSetState($do1, $GUI_DISABLE)
		GUICtrlSetState($do2, $GUI_DISABLE)
		GUICtrlSetState($do3, $GUI_DISABLE)
	EndIf
	
	$ok = GUICtrlCreateButton("OK", 130-20-66, 206, 66, 24)
	$canc = GUICtrlCreateButton("Cancel", 130+20, 206, 66, 24)
	GUICtrlSetState($ok, $GUI_FOCUS)
	GUISetState()
	
	While 1
		$sel = GUIGetMsg()
		Switch $sel
			Case $check4
				If GUICtrlRead($check4) = 1 Then
					GUICtrlSetState($do1, $GUI_ENABLE)
					GUICtrlSetState($do2, $GUI_ENABLE)
					GUICtrlSetState($do3, $GUI_ENABLE)
				Else
					GUICtrlSetState($do1, $GUI_DISABLE)
					GUICtrlSetState($do2, $GUI_DISABLE)
					GUICtrlSetState($do3, $GUI_DISABLE)
				EndIf
				
			Case $modA
				If GUICtrlRead($modA) = 1 Then
					GUICtrlSetState($mod1, $GUI_DISABLE)
					GUICtrlSetState($mod2, $GUI_DISABLE)
				Else
					GUICtrlSetState($mod1, $GUI_ENABLE)
					GUICtrlSetState($mod2, $GUI_ENABLE)
				EndIf
				
			Case $ok
				$top = "False"
				If GUICtrlRead($check1) = 1 Then
					$top = "True"
					WinSetOnTop($hGUI1, "", 1)
				Else
					WinSetOnTop($hGUI1, "", 0)
				EndIf
				IniWrite($sIni, "General", "OnTop", $top)
				
				$tp = "False"
				If GUICtrlRead($check2) = 1 Then $tp = "True"
				IniWrite($sIni, "General", "LockPos", $tp)
				
				$tp = "False"
				If GUICtrlRead($check3) = 1 Then $tp = "True"
				IniWrite($sIni, "General", "DirForFolders", $tp)
				
				$tp = "False"
				If GUICtrlRead($check4) = 1 Then $tp = "True"
				IniWrite($sIni, "General", "AutoForDup", $tp)
				
				If GUICtrlRead($do1) = 1 Then
					$tp = "Overwrite"
				ElseIf GUICtrlRead($do2) = 1 Then
					$tp = "Skip"
				Else
					$tp = "Rename"
				EndIf
				IniWrite($sIni, "General", "Duplicates", $tp)
				
				$tp = "Copy"
				If GUICtrlRead($mod1) = 1 Then $tp = "Move"
				IniWrite($sIni, "General", "Mode", $tp)
				
				$tp = "False"
				If GUICtrlRead($modA) = 1 Then $tp = "True"
				IniWrite($sIni, "General", "AskMode", $tp)
				ExitLoop
				
			Case $canc, $GUI_EVENT_CLOSE
				ExitLoop
				
		EndSwitch
	WEnd
	GUIDelete($opz)
	If $top = "True" Then WinSetOnTop($hGUI1, "", 1)
EndFunc


Func MoreMatches($matches, $item, $j)		; OK
	Local $asso, $sel, $ok, $canc, $ma, $rad[$j+1]
	Local $mess = "You have to select the pattern to use."
	$asso = GUICreate("Pattern ambiguity", 280, 115+21*$j, -1, -1, -1, $WS_EX_TOOLWINDOW, $hGUI2)
	
	GUICtrlCreateGroup("Item with pattern ambiguity:", 8, 6, 264, 40)
	GUICtrlCreateLabel($item, 30, 4+20, 230, 20)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	GUICtrlCreateGroup("Select what pattern use for it:", 8, 40+6*2, 264, 22+21*$j)
	For $i = 1 To $j
		$rad[$i] = GUICtrlCreateRadio(" " & $matches[$i][0], 30, 46+($i*21))
	Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	$ok = GUICtrlCreateButton("OK", 140-20-66, 82+21*$j, 66, 24)
	$canc = GUICtrlCreateButton("Cancel", 140+20, 82+21*$j, 66, 24)
	GUISetState()
	
	While 1
		$sel = GUIGetMsg()
		Switch $sel
			Case $ok
				For $i = 1 To $j
					If GUICtrlRead($rad[$i]) = 1 Then
						$ma = $matches[$i][1]
						ExitLoop
					EndIf
				Next
				MsgBox(0x40000, "Message", $mess)
				
			Case $canc, $GUI_EVENT_CLOSE
				$ma = "-1"
				ExitLoop
				
		EndSwitch
	WEnd
	GUIDelete($asso)
	If $top = "True" Then WinSetOnTop($hGUI1, "", 1)
	If $ma = $EP Then $ma = "-1"
	Return $ma
EndFunc


Func Checking($item, $ff)			; OK
	Local $str, $match, $pattern, $j = 0, $matches[8][2], $var = IniReadSection($sIniPr, "Patterns")
	If Not(@error) Then
		For $i = 1 To $var[0][0]
			$match = 0
			$str = $var[$i][0]
			If StringRight($var[$i][0], 1) = '$' Then $str = StringTrimRight($var[$i][0], 1)
			If StringInStr($str, "**") Then
				$pattern = StringReplace($str, "**", "(.*?)")
				If $ff = "0" Then $match = StringRegExp(StringLower($item), "^" & $pattern & "$")
			Else
				$pattern = StringReplace($str, "*", "(.*?)")
				If Not($ff = "0") Then $match = StringRegExp(StringLower($item), "^" & $pattern & "$")
			EndIf
			If $match = 1 And $j < 7 Then
				$j = $j + 1
				$matches[$j][0] = $var[$i][0]
				$matches[$j][1] = $var[$i][1]
			EndIf
		Next
		If $j = 1 Then
			If StringRight($matches[$j][0], 1) = '$' Then
				Return "-1"
			Else
				Return $matches[$j][1]
			EndIf
		ElseIf $j > 1 Then
			$match = MoreMatches($matches, $item, $j)
			Return $match
		EndIf
	EndIf
	Return "0"
EndFunc


Func Associate($item, $ff)		; OK
	Local $asso, $sel, $Dir1, $se1, $bot1, $fo1, $bot2, $canc, $tem, $tx = ""
	$asso = GUICreate("Add Association", 296, 160, -1, -1, -1, $WS_EX_TOOLWINDOW, $hGUI2)
	If $ff = "0" Then
		$tx = $item & "**"
	Else
		$tx = "*." & $ff
	EndIf
	
	GUICtrlCreateGroup("", 8, 4, 280, 115)
	GUICtrlCreateLabel($me1, 19, 4+17, 260, 40)
	$Dir1 = GUICtrlCreateInput("", 16, 4+50, 207, 20)
	$se1 = GUICtrlCreateButton("Folder", 284-60, 4+49, 56, 22)
	GUICtrlSetTip($se1, "Select a destination folder")
	$bot1 = GUICtrlCreateButton("Rules", 150-54-64, 4+79, 64, 24)
	GUICtrlSetTip($bot1, "Info about supported pattern rules")
	$fo1 = GUICtrlCreateInput($tx, 150-39, 4+81, 78, 20)
	GUICtrlSetTip($fo1, "Write here the desired pattern")
	$bot2 = GUICtrlCreateButton("Apply", 150+54, 4+79, 64, 24)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	GUICtrlCreateLabel('Item: "' & $item & '"', 18, 133, 170, 20)
	$canc = GUICtrlCreateButton("Cancel", 190, 127, 86, 24)
	GUISetState()
	
	While 1
		$sel = GUIGetMsg()
		Switch $sel
			Case $se1
				If $top = "True" Then WinSetOnTop($asso, "", 0)
				$tem = FileSelectFolder("Select a destination folder:", "", 1)
				If Not($tem = "") Then GUICtrlSetData($Dir1, $tem)
				If $top = "True" Then WinSetOnTop($asso, "", 1)
				
			Case $bot1
				MsgBox(0x40000, "Supported pattern rules", $prs)
				
			Case $bot2
				$tem = GUICtrlRead($Dir1)
				$ff = StringLower(GUICtrlRead($fo1))
				If $ff = "" Or Not(StringInStr($ff, "*")) Then
					MsgBox(0x40000, "Message", $er2)
				Else
					If IniRead($sIniPr, "Patterns", $ff, "0") = "0" Then
						If StringRight($ff, 1) = '$' Then $tem = $EP
						If $tem = "" Then
							MsgBox(0x40000, "Message", $er1)
						Else
							IniWrite($sIniPr, "Patterns", $ff, $tem)
							ExitLoop
						EndIf
					Else
						MsgBox(0x40000, "Message", $er3)
					EndIf
				EndIf
				
			Case $canc, $GUI_EVENT_CLOSE
				ExitLoop
				
		EndSwitch
	WEnd
	GUIDelete($asso)
	If $top = "True" Then WinSetOnTop($hGUI1, "", 1)
EndFunc


Func PosFile($temp)			; OK
	Local $Place, $item, $name, $tut, $decision, $cont, $tx, $j = 1, $f = 0, $DD = 0, $ff = "0"
	If StringInStr(FileGetAttrib($temp), "D") Then $DD = 1
	; Rules extrapolation
	While 1
		$j = $j + 1
		$item = StringRight($temp, $j)
		If StringLeft($item, 1) = '.' And $f = 0 Then
			If $DD = 0 Then $ff = StringLower(StringRight($temp, $j - 1))
			$f = 1
		EndIf
		If StringLeft($item, 1) = '\' Then
			$item = StringRight($temp, $j - 1)
			ExitLoop
		EndIf
	WEnd
	; Check if match with a pattern
	$Place = Checking($item, $ff)	; destination if ok, 0 to associate, -1 to skip
	If $Place = "0" Then
		If $DD = 0 Then
			$tx = "file:"
		Else
			$tx = 'folder:'
		EndIf
		$decision = MsgBox(0x40004, "Association needed", 'No association found for the following ' & $tx & @LF & $temp & @LF & @LF & 'Do you want to associate a destination folder for it?')
		If $decision = 6 Then
			Associate($item, $ff)
			$Place = Checking($item, $ff)
		EndIf
	EndIf
	; File positioning
	If Not($Place = "0") And Not($Place = "-1") Then
		$decision = 6
		If Not FileExists($Place) Then DirCreate($Place)
		If FileExists($Place & "\" & $item) Then
			If IniRead($sIni, "General", "AutoForDup", "False") = "False" Then
				If $DD = 1 Then
					$tx = "Folder"
				Else
					$tx = "File"
				EndIf
				$decision = MsgBox(0x40004, $tx & " already exists", '"' & $item & '" already exists in destination folder.' & @LF & 'Do you want to overwrite it? (otherwise it will be skipped)')
			Else
				If IniRead($sIni, "General", "Duplicates", "Overwrite") = "Skip" Then $decision = 1
				If IniRead($sIni, "General", "Duplicates", "Overwrite") = "Rename" Then
					$j = 0
					While 1
						$j = $j + 1
						If $j < 10 Then
							$cont = "0" & $j
						Else
							$cont = $j
						EndIf
						If $DD = 1 Then
							$name = $item & "_" & $cont
						Else
							$name = StringTrimRight($item, StringLen($ff) + 1) & "_" & $cont & "." & $ff
						EndIf
						If Not FileExists($Place & "\" & $name) Then
							$item = $name
							ExitLoop
						EndIf
					WEnd
				EndIf
			EndIf
		EndIf
		If $decision = 6 Then
			If IniRead($sIni, "General", "Mode", "Move") = "Move" Then
				If $DD = 1 Then
					DirMove($temp, $Place & "\" & $item, 1)
				Else
					FileMove($temp, $Place & "\" & $item, 1)
				EndIf
			Else
				If $DD = 1 Then
					DirCopy($temp, $Place & "\" & $item, 1)
				Else
					FileCopy($temp, $Place & "\" & $item, 1)
				EndIf
			EndIf
		EndIf
	EndIf
EndFunc


Func Position($temp)		; OK
	Local $search, $file, $attrib
	If StringInStr(FileGetAttrib($temp), "D") Then
		If IniRead($sIni, "General", "DirForFolders", "False") = "True" Then
			PosFile($temp)
		Else
			; Load files
			$search = FileFindFirstFile($temp & "\*.*")
			While 1
				$file = FileFindNextFile($search)
				If @error Then ExitLoop
				$attrib = FileGetAttrib($temp & "\" & $file)
				If Not StringInStr($attrib, "D") Then PosFile($temp & "\" & $file)
			WEnd
			FileClose($search)
			; Load folders
			$search = FileFindFirstFile($temp & "\*.*")
			While 1
				$file = FileFindNextFile($search)
				If @error Then ExitLoop
				$attrib = FileGetAttrib($temp & "\" & $file)
				If StringInStr($attrib, "D") Then Position($temp & "\" & $file)
			WEnd
			FileClose($search)
		EndIf
	Else
		PosFile($temp)
	EndIf
EndFunc


Func DropEvent()		; OK
	Local $decision
	If IniRead($sIni, "General", "AskMode", "False") = "True" Then
		$decision = MsgBox(0x40004, "Choose positioning mode", "Do you want to 'move' these files in destination folders?" & @LF & "(otherwise they will be 'copied' in destination folders)")
		If $decision = 6 Then
			IniWrite($sIni, "General", "Mode", "Move")
		Else
			IniWrite($sIni, "General", "Mode", "Copy")
		EndIf
	EndIf
	For $i = 0 To UBound($gaDropFiles) - 1
		$temp = $gaDropFiles[$i]
		Position($temp)
	Next
EndFunc


Func WM_DROPFILES_UNICODE_FUNC($hWnd, $msgID, $wParam, $lParam)		; OK
    Local $nSize, $pFileName
    Local $nAmt = DllCall("shell32.dll", "int", "DragQueryFileW", "hwnd", $wParam, "int", 0xFFFFFFFF, "ptr", 0, "int", 255)
    For $i = 0 To $nAmt[0] - 1
        $nSize = DllCall("shell32.dll", "int", "DragQueryFileW", "hwnd", $wParam, "int", $i, "ptr", 0, "int", 0)
        $nSize = $nSize[0] + 1
        $pFileName = DllStructCreate("wchar[" & $nSize & "]")
        DllCall("shell32.dll", "int", "DragQueryFileW", "hwnd", $wParam, "int", $i, "int", DllStructGetPtr($pFileName), "int", $nSize)
        ReDim $gaDropFiles[$i + 1]
        $gaDropFiles[$i] = DllStructGetData($pFileName, 1)
        $pFileName = 0
    Next
EndFunc


Func WM_SYSCOMMAND($hWnd, $Msg, $wParam, $lParam)		; OK
	If IniRead($sIni, "General", "LockPos", "True") = "True" Then
		If BitAND($wParam, 0x0000FFF0) = $SC_MOVE Then Return False
	EndIf
    Return 'GUI_RUNDEFMSG'
EndFunc


Func ShowEvent()		; OK
	TrayItemDelete($Show)
	TrayItemDelete($Separ)
	TrayItemDelete($Exit)
	GUISetState(@SW_SHOW, $hGUI1)
	Opt("TrayIconHide", 1)
EndFunc


Func ExitEvent()		; OK
	_Pos()
    Exit
EndFunc


Func MyTrayMenu()		; OK
	GUISetState(@SW_HIDE, $hGUI1)
	Opt("TrayIconHide", 0)
	TraySetToolTip($ii)
	$Show = TrayCreateItem("Show")
	$Separ = TrayCreateItem("")
	$Exit = TrayCreateItem("Exit")
	TrayItemSetOnEvent($Show, 'ShowEvent')
	TrayItemSetOnEvent($Exit, 'ExitEvent')
	TraySetOnEvent(-13, 'ShowEvent')
	TraySetState()
	TraySetClick(16)
EndFunc


Func _Pos()		; OK
	Local $pos = WinGetPos($hGUI1)
	IniWrite($sIni, "General", "PosX", $pos[0])
	IniWrite($sIni, "General", "PosY", $pos[1])
EndFunc


Func FollowMe($hW, $iM, $wp, $lp)		; OK
    If $hW <> $hGUI1 Then Return
    Local $xypos = WinGetPos($hGUI1)
    WinMove($hGUI2, "", $xypos[0] - $RelPos[0], $xypos[1] - $RelPos[1])
EndFunc


Func SetRelPos($hW, $iM, $wp, $lp)		; OK
    If $hW <> $hGUI1 Then Return
    Local $hGUI1p = WinGetPos($hGUI1)
    Local $hGUI2p = WinGetPos($hGUI2)
    $RelPos[0] = $hGUI1p[0] - $hGUI2p[0]
    $RelPos[1] = $hGUI1p[1] - $hGUI2p[1]
EndFunc


Func ListProfiles()		; OK
    Local $search, $file, $profiles[16]
	$profiles[0] = 0
	$search = FileFindFirstFile($PrDir & "\*.ini")
	If $search = -1 Then Return $profiles
	While 1
		$file = FileFindNextFile($search)
		If @error Then ExitLoop
		If $profiles[0] = 15 Then ExitLoop
		$profiles[0] = $profiles[0] + 1
		$profiles[$profiles[0]] = StringTrimRight($file, 4)
	WEnd
	FileClose($search)
	Return $profiles
EndFunc


Func Customize($profiles)			; OK
	Local $cust, $sel, $bt1, $bt2, $bt3, $bt4, $new, $edit, $del, $tem, $tem2, $hListBox, $decision
	$cust = GUICreate("Customize Profiles", 200, 222, -1, -1, -1, $WS_EX_TOOLWINDOW, $hGUI1)
	
	$new = GUICtrlCreateInput("", 10, 10, 80, 20)
	$bt1 = GUICtrlCreateButton("Create", 50-32, 32, 64, 24)
	GUICtrlSetTip($bt1, "Create a new profile")
	$edit = GUICtrlCreateInput("", 10, 10+60, 80, 20)
	$bt2 = GUICtrlCreateButton("Rename", 50-32, 32+60, 64, 24)
	GUICtrlSetTip($bt2, "Rename selected profile")
	$del = GUICtrlCreateInput("", 10, 10+120, 80, 20)
	$bt3 = GUICtrlCreateButton("Remove", 50-32, 32+120, 64, 24)
	GUICtrlSetTip($bt3, "Remove selected profile")
	$hListBox = GUICtrlCreateList("", 100, 10, 90, 180, BitOr($LBS_DISABLENOSCROLL, $LBS_STANDARD))
	$bt4 = GUICtrlCreateButton("Close", 100-35, 190, 70, 24)
	GUICtrlSetState($edit, $GUI_DISABLE)
	GUICtrlSetState($del, $GUI_DISABLE)
	
	_GUICtrlListBox_BeginUpdate($hListBox)
	For $i = 1 To $profiles[0]
		_GUICtrlListBox_AddString($hListBox, $profiles[$i])
	Next
    _GUICtrlListBox_UpdateHScroll($hListBox)
    _GUICtrlListBox_EndUpdate($hListBox)
	
	GUISetState()
	While 1
		$sel = GUIGetMsg()
		Switch $sel
			Case $hListBox
				$tem = GUICtrlRead($hListBox)
				If Not($tem = "") Then
					GUICtrlSetState($edit, $GUI_ENABLE)
					GUICtrlSetData($edit, $tem)
					GUICtrlSetData($del, $tem)
				EndIf
				
			Case $bt1
				$tem = GUICtrlRead($new)
				If Not($tem = "") Then
					If FileExists($PrDir & "\" & $tem & ".ini") Then
						MsgBox(0x40000, "Name Not Available", "This profile name already exists.")
					Else
						_GUICtrlListBox_AddString($hListBox, $tem)
						IniWriteSection($PrDir & "\" & $tem & ".ini", "Patterns", "")
						GUICtrlSetData($new, "")
					EndIf
				EndIf
				
			Case $bt2
				$tem = GUICtrlRead($edit)
				If Not($tem = "") Then
					If FileExists($PrDir & "\" & $tem & ".ini") Then
						MsgBox(0x40000, "Name Not Available", "This profile name already exists.")
					Else
						$decision = MsgBox(0x40004, "Rename Selected Profile", 'Are you sure to rename this profile?')
						If $decision = 6 Then
							$tem2 = GUICtrlRead($hListBox)
							_GUICtrlListBox_ReplaceString($hListBox, _GUICtrlListBox_FindString($hListBox, $tem2), $tem)
							FileMove($PrDir & "\" & $tem2 & ".ini", $PrDir & "\" & $tem & ".ini", 8)
							If $tem2 = IniRead($sIni, "General", "Profile", "Default") Then
								IniWrite($sIni, "General", "Profile", $tem)
								$sIniPr = $PrDir & "\" & $tem & ".ini"
							EndIf
							GUICtrlSetData($edit, "")
							GUICtrlSetData($del, "")
						EndIf
					EndIf
				EndIf
				
			Case $bt3
				$decision = MsgBox(0x40004, "Remove Selected Profile", 'Are you sure to remove this profile?')
				If $decision = 6 Then
					$tem = GUICtrlRead($hListBox)
					_GUICtrlListBox_DeleteString($hListBox, _GUICtrlListBox_FindString($hListBox, $tem))
					FileDelete($PrDir & "\" & $tem & ".ini")
					If $tem = IniRead($sIni, "General", "Profile", "Default") Then
						IniWrite($sIni, "General", "Profile", "Default")
						$sIniPr = $PrDir & "\Default.ini"
						If Not FileExists($PrDir) Then DirCreate($PrDir)
						If Not FileExists($sIniPr) Then IniWriteSection($sIniPr, "Patterns", "")
					EndIf
					GUICtrlSetData($edit, "")
					GUICtrlSetData($del, "")
				EndIf
				
			Case $bt4, $GUI_EVENT_CLOSE
				ExitLoop
			
			EndSwitch
	WEnd
	GUIDelete($cust)
	If $top = "True" Then WinSetOnTop($hGUI1, "", 1)
	Return ListProfiles()
EndFunc


Func _Main()
	Local $icon, $menu, $nMsg, $x, $y, $dim, $gif, $pos, $j, $tem
	Local $func1, $func3, $func2, $func4, $func5, $func6, $custom, $prof[16], $profiles[16]
	$x = IniRead($sIni, "General", "PosX", "-1")
	$y = IniRead($sIni, "General", "PosY", "-1")
	$hGUI1 = GUICreate($sName, $xD, $yD, $x, $y, $WS_POPUP, BitOR($WS_EX_ACCEPTFILES, $WS_EX_LAYERED, $WS_EX_TOOLWINDOW, $WS_EX_TOPMOST))
	$icon = GUICtrlCreatePic($sIm, 0, 0, $xD, $yD, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetState($icon, $GUI_DROPACCEPTED)
	GUICtrlSetTip($icon, $ii)
	
	; Creation of INI files
	If Not FileExists($sIni) Then
		$sData = "Profile=Default" & @LF & "PosX=-1" & @LF & "PosY=-1" & @LF & "LockPos=False" & @LF & "OnTop=True" & @LF & "SizeX=64" & @LF & "SizeY=64" & @LF & "NoAsk=False" & @LF & "Duplicates=Overwrite" & @LF & "Mode=Move" & @LF & "AskMode=False" & @LF & "AskForFolders=False"
		IniWriteSection($sIni, "General", $sData)
	EndIf
	$sData = IniRead($sIni, "General", "Profile", "Default")
	If $sData = "" Then
		$sData = "Default"
		IniWrite($sIni, "General", "Profile", $sData)
	EndIf
	$sIniPr = $PrDir & "\" & $sData & ".ini"
	If Not FileExists($PrDir) Then DirCreate($PrDir)
	$tem = IniReadSection($sIni, "Patterns")
	If @error Then
		If Not FileExists($sIniPr) Then IniWriteSection($sIniPr, "Patterns", "")
	Else
		IniWriteSection($sIniPr, "Patterns", $tem)
		IniDelete($sIni, "Patterns")
	EndIf
	$profiles = ListProfiles()
	
	; Background mode
	If $CmdLine[0] > 0 Then
		If FileExists($CmdLine[1]) Then
			GUISetState(@SW_HIDE, $hGUI1)
			ReDim $gaDropFiles[$CmdLine[0]]
			For $j = 1 To $CmdLine[0]
				$gaDropFiles[$j - 1] = $CmdLine[$j]
			Next
			DropEvent()
			Exit
		Else
			$sData = StringTrimLeft($CmdLine[1], 1)
			If StringLeft($CmdLine[1], 1) = "-" And FileExists($PrDir & "\" & $sData & ".ini") Then
				IniWrite($sIni, "General", "Profile", $sData)
				$sIniPr = $PrDir & "\" & $sData & ".ini"
			Else
				MsgBox(0, "Invalid Command", "You are running " & $sName & " with an invalid command." & @LF & "It will be normally started.")
			EndIf
		EndIf
	EndIf
	
	; Context menu
	$menu = GUICtrlCreateContextMenu($icon)
	$func1 = GUICtrlCreateMenuItem("Manage", $menu, 0)
	GUICtrlCreateMenuItem("", $menu, 1)
	$func2 = GUICtrlCreateMenu("Profiles", $menu, 2)
	$func3 = GUICtrlCreateMenuItem("Options", $menu, 3)
	$func4 = GUICtrlCreateMenuItem("Hide", $menu, 4)
	$func5 = GUICtrlCreateMenuItem("About...", $menu, 5)
	GUICtrlCreateMenuItem("", $menu, 6)
	$func6 = GUICtrlCreateMenuItem("Exit", $menu, 7)
	
	; Context submenu
	$custom = GUICtrlCreateMenuItem("Customize", $func2)
	GUICtrlCreateMenuItem("", $func2)
	For $i = 1 To $profiles[0]
		$prof[$i] = GUICtrlCreateMenuItem($profiles[$i], $func2, $i+1, 1)
		If $profiles[$i] = IniRead($sIni, "General", "Profile", "Default") Then GUICtrlSetState($prof[$i], $GUI_CHECKED)
    Next
	
	GUIRegisterMsg($WM_DROPFILES, "WM_DROPFILES_UNICODE_FUNC")
	GUIRegisterMsg($WM_SYSCOMMAND, "WM_SYSCOMMAND")
	GUISetState(@SW_SHOW, $hGUI1)
	
	$pos = WinGetPos($hGUI1)
	$hGUI2 = GUICreate("Positioning", 16, 16, $pos[0]+7, $pos[1]+7, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_TOPMOST), $hGUI1)
	$gif = GUICtrlCreatePic($sPic, 0, 0, 16, 16, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
	GUIRegisterMsg($WM_ENTERSIZEMOVE, "SetRelPos")
	GUIRegisterMsg($WM_MOVE, "FollowMe")
	GUISetState(@SW_HIDE, $hGUI2)
	
	$top = IniRead($sIni, "General", "OnTop", "True")
	If $top = "True" Then
		WinSetOnTop($hGUI1, "", 1)
	Else
		WinSetOnTop($hGUI1, "", 0)
	EndIf
	
	While 1
		$nMsg = GUIGetMsg()
		Select
			Case $nMsg = $GUI_EVENT_DROPPED
				GUISetState(@SW_SHOW, $hGUI2)
				DropEvent()
				GUISetState(@SW_HIDE, $hGUI2)
				
			Case $nMsg = $func1
				GUICtrlSetState($icon, $GUI_DISABLE)
				Manage()
				GUICtrlSetState($icon, $GUI_ENABLE)
			
			Case $nMsg = $custom
				GUICtrlSetState($icon, $GUI_DISABLE)
				$profiles = Customize($profiles)
				GUICtrlSetState($icon, $GUI_ENABLE)
				GUICtrlDelete($func2)
				; Recreate submenu
				$func2 = GUICtrlCreateMenu("Profiles", $menu, 2)
				$custom = GUICtrlCreateMenuItem("Customize", $func2)
				GUICtrlCreateMenuItem("", $func2)
				For $i = 1 To $profiles[0]
					$prof[$i] = GUICtrlCreateMenuItem($profiles[$i], $func2, $i+1, 1)
					If $profiles[$i] = IniRead($sIni, "General", "Profile", "Default") Then GUICtrlSetState($prof[$i], $GUI_CHECKED)
				Next
				
			Case $nMsg >= $prof[1] And $nMsg <= $prof[$profiles[0]]
				For $i = 1 To $profiles[0]
					If $nMsg = $prof[$i] Then
						IniWrite($sIni, "General", "Profile", $profiles[$i])
						$sIniPr = $PrDir & "\" & $profiles[$i] & ".ini"
					EndIf
				Next
				
			Case $nMsg = $func3
				GUICtrlSetState($icon, $GUI_DISABLE)
				Options()
				GUICtrlSetState($icon, $GUI_ENABLE)
				
			Case $nMsg = $func4
				MyTrayMenu()
				
			Case $nMsg = $func5
				MsgBox(0x40040, "About", "      " & $sName & $sVer & @LF & @LF & "Software developed by Lupo PenSuite Team." & @LF & "Released under Open Source GPL.")
				
			Case $nMsg = $func6
				ExitLoop
				
			Case $nMsg = $GUI_EVENT_CLOSE
				ExitLoop
				
		EndSelect
	WEnd
	ExitEvent()
EndFunc