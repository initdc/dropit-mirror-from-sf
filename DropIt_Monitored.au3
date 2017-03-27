
; Monitored funtions of DropIt

#include-once
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListView.au3>

#include "DropIt_General.au3"
#include "DropIt_Global.au3"
#include "DropIt_ProfileList.au3"
#include "Lib\udf\APIConstants.au3"
#include "Lib\udf\DropIt_LibVarious.au3"
#include "Lib\udf\WinAPIEx.au3"

Func __Monitored_Edit_GUI($mHandle, $mINI, $mListView, $mIndex = -1, $mFolder = -1)
	Local $mGUI, $mInput_Folder, $mButton_Folder, $mCombo_Profile, $mCurrent_Folder, $mSave, $mCancel
	Local $mProfile = __IsProfile(-1, 0) ; Get Array Of Current Profile.

	If $mIndex <> -1 Then
		$mProfile[1] = _GUICtrlListView_GetItemText($mListView, $mIndex, 1)
	EndIf
	If $mFolder = -1 Then
		$mFolder = ""
	EndIf

	$mGUI = GUICreate(__GetLang('MONITORED_FOLDER', 'Monitored Folder'), 300, 125, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	$mInput_Folder = GUICtrlCreateInput($mFolder, 10, 15 + 2, 240, 22)
	GUICtrlSetTip($mInput_Folder, __GetLang('MONITORED_FOLDER_TIP_0', 'Drag and drop the folder that will be monitored.'))
	GUICtrlSetState($mInput_Folder, $GUI_DROPACCEPTED)
	$mButton_Folder = GUICtrlCreateButton("S", 10 + 244, 15, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Folder, __GetLang('SEARCH', 'Search'))
	GUICtrlSetImage($mButton_Folder, @ScriptFullPath, -8, 0)
	$mCombo_Profile = GUICtrlCreateCombo("", 10, 15 + 35, 280, 22, 0x0003)
	GUICtrlSetTip($mCombo_Profile, __GetLang('MONITORED_FOLDER_TIP_1', 'Select the group of associations to use on this folder.'))
	GUICtrlSetData($mCombo_Profile, __ProfileList_Combo(), $mProfile[1])

	$mSave = GUICtrlCreateButton(__GetLang('SAVE', 'Save'), 150 - 20 - 75, 90, 75, 24)
	$mCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 150 + 20, 90, 75, 24)
	GUICtrlSetState($mSave, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)

	While 1
		; Enable/Disable Save Button:
		If GUICtrlRead($mInput_Folder) <> "" Then
			If GUICtrlGetState($mSave) > 80 Then
				GUICtrlSetState($mSave, 576) ; $GUI_ENABLE + $GUI_DEFBUTTON.
			EndIf
			If GUICtrlGetState($mCancel) = 512 Then
				GUICtrlSetState($mCancel, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
		Else
			If GUICtrlGetState($mSave) = 80 Then
				GUICtrlSetState($mSave, 144) ; $GUI_DISABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($mCancel) = 80 Then
				GUICtrlSetState($mCancel, 512) ; $GUI_DEFBUTTON.
			EndIf
		EndIf

		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $mCancel
				ExitLoop

			Case $mSave
				$mCurrent_Folder = GUICtrlRead($mInput_Folder)
				If __StringIsValid($mCurrent_Folder) = 0 Then
					MsgBox(0x30, __GetLang('MONITORED_FOLDER_MSGBOX_0', 'Folder Error'), __GetLang('MONITORED_FOLDER_MSGBOX_1', 'You must specify a valid directory.'), 0, __OnTop($mGUI))
					ContinueLoop
				EndIf
				If $mIndex <> -1 Then
					IniDelete($mINI, "MonitoredFolders", $mFolder)
				EndIf
				__IniWriteEx($mINI, "MonitoredFolders", $mCurrent_Folder, GUICtrlRead($mCombo_Profile) & "|Enabled")
				ExitLoop

			Case $mButton_Folder
				$mCurrent_Folder = FileSelectFolder(__GetLang('MONITORED_FOLDER_MSGBOX_2', 'Select a monitored folder:'), "", 3, "", $mGUI)
				$mCurrent_Folder = _WinAPI_PathRemoveBackslash($mCurrent_Folder)
				If $mCurrent_Folder <> "" Then
					GUICtrlSetData($mInput_Folder, $mCurrent_Folder)
				EndIf

		EndSwitch
	WEnd
	GUIDelete($mGUI)

	Return 1
EndFunc   ;==>__Monitored_Edit_GUI

Func __Monitored_Update($mListView, $mINI)
	Local $mStringSplit
	Local $mMonitored = __IniReadSection($mINI, "MonitoredFolders") ; Get Associations Array For The Current Profile.
	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	_GUICtrlListView_BeginUpdate($mListView)
	_GUICtrlListView_DeleteAllItems($mListView)
	For $A = 1 To $mMonitored[0][0]
		_GUICtrlListView_AddItem($mListView, $mMonitored[$A][0])
		$mStringSplit = StringSplit($mMonitored[$A][1], "|")
		ReDim $mStringSplit[3]
		_GUICtrlListView_AddSubItem($mListView, $A - 1, $mStringSplit[1], 1)
		If $mStringSplit[2] <> $G_Global_StateDisabled Then
			_GUICtrlListView_SetItemChecked($mListView, $A - 1)
		EndIf
	Next
	_GUICtrlListView_RegisterSortCallBack($mListView, True, False)
	_GUICtrlListView_SortItems($mListView, 0)
	_GUICtrlListView_UnRegisterSortCallBack($mListView)
	_GUICtrlListView_SetItemSelected($mListView, 0, False, False)
	_GUICtrlListView_EndUpdate($mListView)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__Monitored_Update

Func __Monitored_SetState($sINI, $sFolder, $sProfile, $sState)
	#cs
		Description: Enable/Disable The Monitored Folder.
		Return: 1
	#ce
	If $sState Then
		$sState = $G_Global_StateEnabled
	Else
		$sState = $G_Global_StateDisabled
	EndIf
	__IniWriteEx($sINI, "MonitoredFolders", $sFolder, $sProfile & "|" & $sState)

	Return 1
EndFunc   ;==>__Monitored_SetState
