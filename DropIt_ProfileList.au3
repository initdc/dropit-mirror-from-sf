
; ProfileList funtions of DropIt

#include-once
#include <GUIConstantsEx.au3>

#include "DropIt_General.au3"
#include "Lib\udf\DropIt_LibFiles.au3"

Func __ProfileList_Combo()
	#cs
		Description: Get Profiles And Create String For Use In A Combo Box.
		Returns: String Of Profiles.
	#ce
	Local $aProfileList, $sData

	$aProfileList = __ProfileList_Get()
	For $A = 1 To $aProfileList[0]
		If @error Then
			ExitLoop
		EndIf
		$sData &= $aProfileList[$A] & "|"
	Next
	Return StringTrimRight($sData, 1)
EndFunc   ;==>__ProfileList_Combo

Func __ProfileList_Get($iGetPath = 0)
	#cs
		Description: Proivide Details Of The Profiles In The Profiles Directory.
		Returns: $Array[?] - Array Contains Unlimited Number Of Items.
		[0] - Number Of Rows [3]
		[1] - Profile Name 1 [First Profile Name]
		[2] - Profile Name 2 [Second Profile Name]
		[3] - Profile Name 3 [Third Profile Name]
	#ce
	Local $aProfileList, $sDefault

	$sDefault = __GetDefault(2) ; Get Default Profile Directory.
	$aProfileList = __FileListToArrayEx($sDefault, "*.ini")
	If $iGetPath <> 1 Then
		For $A = 1 To $aProfileList[0]
			$aProfileList[$A] = __GetFileNameOnly($aProfileList[$A])
		Next
	EndIf
	Return $aProfileList
EndFunc   ;==>__ProfileList_Get

Func __ProfileList_GUI()
	#cs
		Description: Select Profile From ProfileList.
		Returns: Selected Profile
	#ce
	Local $hGUI, $iOK, $iCancel, $iProfileCombo, $sProfile

	$sProfile = __GetCurrentProfile() ; Get Current Profile From The Settings INI File.
	$hGUI = GUICreate(__GetLang('PROFILELIST_GUI_LABEL_0', 'Select a Profile'), 230, 70, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop())
	$iProfileCombo = GUICtrlCreateCombo("", 5, 10, 220, 25, 0x0003)

	GUICtrlSetData($iProfileCombo, __ProfileList_Combo(), $sProfile)
	$iOK = GUICtrlCreateButton(__GetLang('OK', 'OK'), 115 - 76 - 15, 40, 76, 24)
	$iCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 115 + 15, 40, 76, 24)
	GUICtrlSetState($iOK, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW, $hGUI)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $iCancel
				GUIDelete($hGUI)
				Return SetError(1, 0, $sProfile)

			Case $iOK
				ExitLoop

		EndSwitch
	WEnd

	$sProfile = GUICtrlRead($iProfileCombo)
	GUIDelete($hGUI)
	Return $sProfile
EndFunc   ;==>__ProfileList_GUI
