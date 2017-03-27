#cs ----------------------------------------------------------------------------
	Application Name: DropIt
	License: Open Source GPL
	Language: English
	AutoIt Version: 3.3.6.1
	Authors: Lupo73 and Guinness
	Website: http://www.lupopensuite.com/db/oth/dropit.htm
	Contact: http://www.lupopensuite.com/contact.htm

	AutoIt3Wrapper Info:
	Icons Added To The Resources Can Be Used With TraySetIcon(@ScriptFullPath, -5) etc. And Are Stored With Numbers -5, -6, -7...
	The Reference Web Page Is http://www.autoitscript.com/autoit3/scite/docs/AutoIt3Wrapper.htm
#ce ----------------------------------------------------------------------------

#NoTrayIcon
#Region ; **** Directives Created By AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Lib\img\icon.ico
#AutoIt3Wrapper_Outfile=DropIt.exe
#AutoIt3Wrapper_UseUpx=N
#AutoIt3Wrapper_Res_Description=DropIt - Sort your files with a drop
#AutoIt3Wrapper_Res_Fileversion=2.0.0.0
#AutoIt3Wrapper_Res_ProductVersion=2.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Lupo PenSuite Team
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_Field=Website|http://www.lupopensuite.com
#AutoIt3Wrapper_Res_Field=E-Mail|comment at the website
#AutoIt3Wrapper_UseX64=N
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_Run_Obfuscator=Y
#Obfuscator_Parameters=/SF /SV /OM /CF=0 /CN=0 /CS=0 /CV=0
#AutoIt3Wrapper_Res_File_Add=Images\Default.png, 10, IMAGE
#AutoIt3Wrapper_Res_File_Add=Lib\img\zz.png, 10, ZZ
#AutoIt3Wrapper_Res_File_Add=Lib\img\NoFlag.gif, 10, NoFlag
#EndRegion ; **** Directives Created By AutoIt3Wrapper_GUI ****

#include <Crypt.au3>
#include <File.au3>
#include <GUIComboBoxEx.au3>
#include <GUIConstantsEx.au3>
#include <GUIImageList.au3>
#include <GUIListView.au3>
#include <GUIMenu.au3>
#include <GUIToolTip.au3>
#include <Lib\udf\Copy.au3>
#include <Lib\udf\Resources.au3>
#include <Misc.au3>
#include <StaticConstants.au3>
#include <String.au3>
#include <WindowsConstants.au3>

Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1)
OnAutoItExitRegister("_ExitEvent")

; <<<<< Environment Variables >>>>>
Global $Global_CurrentVersion = "2.0"
Global $Global_ImageList ; ImageList.
__EnvironmentVariables() ; Sets The Standard & User Assigned Environment Variables.
__ExpandEnvStrings(0) ; Disables The Expansion Of Environment Variables.
; <<<<< Environment Variables >>>>>

; <<<<< Variables >>>>>
Global $Global_GUI_1, $Global_GUI_2 ; GUI Handles.
Global $Global_Icon_1 ; Icons Handle.
Global $Global_ContextMenu[15][2] = [[14, 2]] ; ContextMenu Array.
Global $Global_TrayMenu[14][2] = [[13, 2]] ; TrayMenu Array.
Global $Global_Customize, $Global_ListViewIndex = -1, $Global_ListViewProfiles, $Global_ListViewRules, $Global_Manage ; ListView Variables.
Global $Global_ListViewProfiles_Delete, $Global_ListViewProfiles_Enter, $Global_ListViewProfiles_New ; ContextMenu ListViewProfiles Variables.
Global $Global_ListViewRules_Delete, $Global_ListViewRules_ComboBox, $Global_ListViewRules_ComboBoxChange = 0, $Global_ListViewRules_Enter, $Global_ListViewRules_New ; ContextMenu ListViewManage Variables.
Global $Global_Slider, $Global_SliderLabel ; _Customize_GUI_Edit().
Global $Global_Action, $Global_DroppedFiles[1], $Global_PTR ; Misc.
Global $UniqueID = "DropIt_E15FF08B-84AC-472A-89BF-5F92DB683165" ; WM_COPYDATA.
Global $Global_MultipleInstance = 0 ; Multiple Instances.
Global $Global_AbortButton, $Global_AbortSorting = 0, $Global_SortingCurrentSize, $Global_SortingGUI, $Global_SortingTotalSize ; Sorting GUI.
Global $Global_Encryption_Key = "profiles-password-fake" ; Key For Profiles Encryption.
Global $Global_Password_Key = "archives-password-fake" ; Key For Archives Encryption.
; <<<<< Variables >>>>>

_Update_Check() ; Check If DropIt Has Been Updated.
__Password_GUI() ; Ask Password If In Encrypt Mode.
__Upgrade() ; Upgrade DropIt If Required.
__SingletonEx($UniqueID) ; WM_COPYDATA.

_GDIPlus_Startup()

_Main() ; Start DropIt.

#Region Start >>>>> Manage Functions <<<<<
Func _Manage_GUI($mINI = -1, $mHandle = -1)
	$mINI = __IsSettingsFile($mINI) ; Get Default Settings INI File.
	Local $mGUI = $Global_Manage

	Local $mListView, $mListView_Handle, $mNew, $mDeleteDummy, $mProfileCombo, $mClose, $mEnterDummy, $mText, $mTextINI, $mType, $mStringSplit
	Local $mIndex_Selected, $mAssociate, $mNewDummy, $mProfileCombo_Handle

	Local $mProfile = __IsProfile(-1, 0) ; Get Array Of Current Profile.

	$mGUI = GUICreate(__Lang_Get('MANAGE_GUI', 'Manage Patterns'), 410, 270, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))
	$Global_Manage = $mGUI

	$mListView = GUICtrlCreateListView(__Lang_Get('PATTERN', 'Pattern') & "|" & __Lang_Get('ACTION', 'Action') & "|" & __Lang_Get('DESCRIPTION', 'Description'), 5, 5, 400, 220, BitOR($LVS_NOSORTHEADER, $LVS_REPORT, $LVS_SINGLESEL))
	$mListView_Handle = GUICtrlGetHandle($mListView)

	$Global_ListViewRules = $mListView_Handle

	_GUICtrlListView_SetExtendedListViewStyle($mListView_Handle, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_INFOTIP))
	Local $mColumnSize = __Column_Width("ColumnManage")
	For $A = 1 To $mColumnSize[0]
		_GUICtrlListView_SetColumnWidth($mListView_Handle, $A - 1, $mColumnSize[$A])
	Next

	Local $mToolTip = _GUICtrlListView_GetToolTips($mListView_Handle)
	If IsHWnd($mToolTip) Then
		__OnTop($mToolTip, 1)
		_GUIToolTip_SetDelayTime($mToolTip, 3, 60) ; Speeds Up InfoTip Appearance.
	EndIf

	_Manage_Update($mListView_Handle, $mProfile[1]) ; Add/Update The ListView With The Custom Patterns.

	$mDeleteDummy = GUICtrlCreateDummy()
	$Global_ListViewRules_Delete = $mDeleteDummy
	$mEnterDummy = GUICtrlCreateDummy()
	$Global_ListViewRules_Enter = $mEnterDummy
	$mNewDummy = GUICtrlCreateDummy()
	$Global_ListViewRules_New = $mNewDummy

	$mNew = GUICtrlCreateButton("&" & __Lang_Get('NEW', 'New'), 205 - 90 - 78, 235, 78, 25)
	GUICtrlSetTip($mNew, __Lang_Get('MANAGE_GUI_TIP_0', 'Click to add a pattern or Right-click a pattern to manage it.'))

	$mProfileCombo = GUICtrlCreateCombo("", 205 - 51, 237, 100, 24, 0x0003)
	$mProfileCombo_Handle = GUICtrlGetHandle($mProfileCombo)

	$Global_ListViewRules_ComboBox = $mProfileCombo_Handle

	GUICtrlSetData($mProfileCombo, __ProfileList_Combo(), $mProfile[1])
	GUICtrlSetTip($mProfileCombo, __Lang_Get('MANAGE_GUI_TIP_1', 'Select a Profile to change its patterns.'))

	$mClose = GUICtrlCreateButton("&" & __Lang_Get('CLOSE', 'Close'), 205 + 90, 235, 78, 25)
	GUICtrlSetTip($mClose, __Lang_Get('MANAGE_GUI_TIP_2', 'Save pattern changes and close the window.'))
	GUICtrlSetState($mClose, 576)

	$Global_ListViewIndex = -1 ; Set As No Item Selected.
	GUIRegisterMsg(0x0111, "WM_COMMAND")
	GUIRegisterMsg(0x004E, "WM_NOTIFY")
	GUISetState(@SW_SHOW)
	Local $cHotKeys[3][2] = [["^n", $mNewDummy],["{DELETE}", $mDeleteDummy],["{ENTER}", $mEnterDummy]]
	GUISetAccelerators($cHotKeys)

	While 1
		__ReduceMemory() ; Reduce Memory Usage Of DropIt.

		$mIndex_Selected = $Global_ListViewIndex

		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $mClose
				Local $mColumnSize[_GUICtrlListView_GetColumnCount($mListView_Handle)]
				For $A = 0 To UBound($mColumnSize) - 1
					$mColumnSize[$A] = _GUICtrlListView_GetColumnWidth($mListView_Handle, $A)
				Next
				__Column_Width("ColumnManage", $mColumnSize)
				ExitLoop

			Case $mNew, $mNewDummy
				If $Global_ListViewRules_ComboBoxChange Then
					$Global_ListViewRules_ComboBoxChange = 0
					$mProfile = __IsProfile(GUICtrlRead($mProfileCombo), 0) ; Get Array Of Selected Profile.
				EndIf
				$mAssociate = _Manage_Edit_GUI($mProfile[1], -1, -1, -1, -1, $mGUI, 1) ; Show Manage Edit GUI For New Pattern.
				If $mAssociate = 1 Then $mProfile = _Manage_Update($mListView_Handle, $mProfile) ; Add/Update The ListView With The Custom Patterns.

			Case $mDeleteDummy
				If $Global_ListViewRules_ComboBoxChange Then
					$Global_ListViewRules_ComboBoxChange = 0
					$mProfile = __IsProfile(GUICtrlRead($mProfileCombo), 0) ; Get Array Of Selected Profile.
				EndIf
				_Manage_Delete($mListView_Handle, $mIndex_Selected, $mProfile[0]) ; Delete Selected Pattern From Current Profile & ListView.

			Case $mEnterDummy
				If $Global_ListViewRules_ComboBoxChange Then
					$Global_ListViewRules_ComboBoxChange = 0
					$mProfile = __IsProfile(GUICtrlRead($mProfileCombo), 0) ; Get Array Of Selected Profile.
				EndIf
				$mIndex_Selected = _GUICtrlListView_GetSelectionMark($mListView_Handle)
				If Not _GUICtrlListView_GetItemState($mListView_Handle, $mIndex_Selected, $LVIS_SELECTED) Then ContinueLoop

				$mText = _GUICtrlListView_GetItemText($mListView_Handle, $mIndex_Selected)
				$mType = _GUICtrlListView_GetItemText($mListView_Handle, $mIndex_Selected, 1)
				Switch $mType
					Case __Lang_Get('COPY', 'Copy')
						$mTextINI = $mText & "$1"
					Case __Lang_Get('EXCLUDE', 'Exclude')
						$mTextINI = $mText & "$2"
					Case __Lang_Get('COMPRESS', 'Compress')
						$mTextINI = $mText & "$3"
					Case __Lang_Get('EXTRACT', 'Extract')
						$mTextINI = $mText & "$4"
					Case __Lang_Get('OPEN_WITH', 'Open With')
						$mTextINI = $mText & "$5"
					Case __Lang_Get('DELETE', 'Delete')
						$mTextINI = $mText & "$6"
					Case Else ; Move.
						$mTextINI = $mText & "$0"
				EndSwitch
				$mStringSplit = StringSplit(IniRead($mProfile[0], "Patterns", $mTextINI, ""), "|") ; Seperate Directory & Description.
				If $mStringSplit[0] = 1 Then
					ReDim $mStringSplit[3]
					$mStringSplit[2] = ""
				EndIf
				_Manage_Edit_GUI($mProfile[1], $mStringSplit[2], $mText, $mType, $mStringSplit[1], $mGUI, 0) ; Show Manage Edit GUI For Selected Pattern.
				If @error Then ContinueLoop
				_Manage_Update($mListView_Handle, $mProfile) ; Add/Update The ListView With The Custom Patterns.
				_GUICtrlListView_SetItemSelected($mListView_Handle, $mIndex_Selected, True, True)

		EndSwitch
	WEnd
	GUIDelete($mGUI)

	__SetCurrentPosition() ; Set Current Coordinates/Position Of DropIt.
	__IsOnTop() ; Set GUI "OnTop" If True.

	If Not @error Then Return 1
	Return SetError(1, 1, 0)
EndFunc   ;==>_Manage_GUI

Func _Manage_Edit_GUI($mProfileName = -1, $mFileName = -1, $mFileNameExt = -1, $mInitialType = -1, $mDirectory = -1, $mHandle = -1, $mNewAssociation = 0, $mDroppedEvent = 0)
	Local $mEmptyDestination = "Empty-Destination"

	Local $mGUI, $mInput_Name, $mInput_Rule, $mButton_Rule, $mCombo_Type, $mButton_Type, $mInput_Directory, $mButton_Directory, $mSave, $mCancel
	Local $mInput_RuleData, $mCombo_TypeData, $mInput_NameRead, $mInput_DirectoryRead, $mMsgBox, $mFolder, $mDestination_Label
	Local $mTEMPFileNameExt, $mItem, $mChanged = 0, $mAssociationType = __Lang_Get('MANAGE_ASSOCIATION_NEW', 'New Association')

	Local $mProfile = __IsProfile($mProfileName, 0) ; Get Array Of Current Profile.

	If $mFileName = -1 Then $mFileName = ""
	If $mFileNameExt = -1 Then $mFileNameExt = ""
	If $mInitialType = -1 Then $mInitialType = __Lang_Get('MOVE', 'Move')
	If $mDirectory = -1 Or $mDirectory = "" Then $mDirectory = @ScriptDir
	Local $mCurrentType = $mInitialType
	$mInput_RuleData = $mFileNameExt
	$mCombo_TypeData = __Lang_Get('MOVE', 'Move') & '|' & __Lang_Get('COPY', 'Copy') & '|' & __Lang_Get('COMPRESS', 'Compress') & '|' & __Lang_Get('EXTRACT', 'Extract') & '|' & __Lang_Get('OPEN_WITH', 'Open With') & '|' & __Lang_Get('DELETE', 'Delete') & '|' & __Lang_Get('EXCLUDE', 'Exclude')
	$mItem = "[" & __Lang_Get('PROFILE', 'Profile') & ": " & $mProfile[1] & "]"

	Select
		Case $mNewAssociation = 0 And $mDroppedEvent = 0
			$mAssociationType = __Lang_Get('MANAGE_ASSOCIATION_EDIT', 'Edit Association')

		Case $mNewAssociation = 1 And $mDroppedEvent = 1
			$mInput_RuleData = "**"
			If $mFileNameExt <> "0" Then $mInput_RuleData = "*." & $mFileNameExt ; $mFileNameExt = "0" If Loaded Item Is A Folder.
	EndSelect

	$mGUI = GUICreate($mAssociationType & " " & $mItem, 300, 290, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))
	GUICtrlCreateLabel(__Lang_Get('DESCRIPTION', 'Description') & ":", 10, 10, 160, 20)
	$mInput_Name = GUICtrlCreateInput($mFileName, 10, 31, 278, 20)
	GUICtrlSetTip($mInput_Name, __Lang_Get('MANAGE_EDIT_TIP_0', 'Choose a description for this association.'))

	GUICtrlCreateLabel(__Lang_Get('MANAGE_PATTERN_RULE', 'Pattern Rule') & ":", 10, 60 + 10, 160, 20)
	$mInput_Rule = GUICtrlCreateInput($mInput_RuleData, 10, 60 + 31, 200, 20)
	GUICtrlSetTip($mInput_Rule, __Lang_Get('MANAGE_EDIT_TIP_1', 'Write a pattern rule for this association.'))
	$mButton_Rule = GUICtrlCreateButton(__Lang_Get('INFO', 'Info'), 10 + 208, 60 + 30, 70, 22)

	GUICtrlCreateLabel(__Lang_Get('MANAGE_ACTION', 'Action') & ":", 10, 120 + 10, 160, 20)
	$mCombo_Type = GUICtrlCreateCombo("", 10, 120 + 31, 200, 24, 0x0003)
	$mButton_Type = GUICtrlCreateButton(__Lang_Get('INFO', 'Info'), 10 + 208, 120 + 30, 70, 22)

	$mDestination_Label = GUICtrlCreateLabel(__Lang_Get('MANAGE_DESTINATION_FOLDER', 'Destination Folder') & ":", 10, 180 + 10, 160, 20)
	$mInput_Directory = GUICtrlCreateInput($mDirectory, 10, 180 + 31, 200, 20)
	GUICtrlSetTip($mInput_Directory, __Lang_Get('MANAGE_EDIT_TIP_2', 'As destination are supported both absolute and relative paths.'))
	$mButton_Directory = GUICtrlCreateButton(__Lang_Get('SEARCH', 'Search'), 10 + 208, 180 + 30, 70, 22)

	If $mCurrentType == __Lang_Get('EXCLUDE', 'Exclude') Or $mCurrentType == __Lang_Get('DELETE', 'Delete') Then
		GUICtrlSetData($mInput_Directory, __Lang_Get('EMPTY', 'Empty'))
		GUICtrlSetState($mInput_Directory, $GUI_DISABLE)
		GUICtrlSetState($mButton_Directory, $GUI_DISABLE)
	ElseIf $mCurrentType == __Lang_Get('OPEN_WITH', 'Open With') Then
		GUICtrlSetData($mDestination_Label, __Lang_Get('MANAGE_DESTINATION_PROGRAM', 'Destination Program') & ":")
	EndIf
	GUICtrlSetData($mCombo_Type, $mCombo_TypeData, $mCurrentType)

	$mSave = GUICtrlCreateButton("&" & __Lang_Get('SAVE', 'Save'), 150 - 20 - 76, 250, 76, 26)
	GUICtrlSetState($mSave, 144) ; Disable Save Button Initially.
	$mCancel = GUICtrlCreateButton("&" & __Lang_Get('CANCEL', 'Cancel'), 150 + 20, 250, 76, 26)
	GUICtrlSetState($mCancel, 576)

	GUISetState(@SW_SHOW)
	ControlClick($mGUI, "", $mInput_Name)

	While 1
		__ReduceMemory() ; Reduce Memory Usage Of DropIt.

		; Enable/Disable Destination Input And Switch Folder/Program Label.
		If GUICtrlRead($mCombo_Type) <> $mCurrentType And _GUICtrlComboBox_GetDroppedState($mCombo_Type) = False Then
			$mCurrentType = GUICtrlRead($mCombo_Type)
			Switch $mCurrentType
				Case __Lang_Get('EXCLUDE', 'Exclude'), __Lang_Get('DELETE', 'Delete')
					GUICtrlSetState($mInput_Directory, $GUI_DISABLE)
					GUICtrlSetState($mButton_Directory, $GUI_DISABLE)
					If GUICtrlRead($mInput_Directory) == "" Then GUICtrlSetData($mInput_Directory, __Lang_Get('EMPTY', 'Empty'))
				Case Else
					GUICtrlSetState($mInput_Directory, $GUI_ENABLE)
					GUICtrlSetState($mButton_Directory, $GUI_ENABLE)
					If GUICtrlRead($mInput_Directory) == __Lang_Get('EMPTY', 'Empty') Then GUICtrlSetData($mInput_Directory, "")
			EndSwitch
			Switch $mCurrentType
				Case __Lang_Get('OPEN_WITH', 'Open With')
					GUICtrlSetData($mDestination_Label, __Lang_Get('MANAGE_DESTINATION_PROGRAM', 'Destination Program') & ":")
				Case Else
					GUICtrlSetData($mDestination_Label, __Lang_Get('MANAGE_DESTINATION_FOLDER', 'Destination Folder') & ":")
			EndSwitch
		EndIf

		; Enable/Disable Save Button.
		If GUICtrlRead($mInput_Rule) <> "" And __StringIsValid(GUICtrlRead($mInput_Directory), "$|") And Not StringIsSpace(GUICtrlRead($mInput_Rule)) Then
			If GUICtrlGetState($mSave) > 80 Then GUICtrlSetState($mSave, 576) ; 80 = Normal; 144 = Disabled; 576 = Focused.
			If GUICtrlGetState($mCancel) = 512 Then GUICtrlSetState($mCancel, 80) ; 80 = Normal; 144 = Disabled; 576 = Focused.
		ElseIf GUICtrlRead($mInput_Rule) = "" Or Not __StringIsValid(GUICtrlRead($mInput_Directory), "$|") Or StringIsSpace(GUICtrlRead($mInput_Rule)) Then
			If GUICtrlGetState($mSave) = 80 Then GUICtrlSetState($mSave, 144) ; 80 = Normal; 144 = Disabled; 576 = Focused.
			If GUICtrlGetState($mCancel) = 80 Then GUICtrlSetState($mCancel, 512) ; 80 = Normal; 144 = Disabled; 576 = Focused.
		EndIf

		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $mCancel
				SetError(1, 1, 0)
				ExitLoop

			Case $mSave
				$mInput_NameRead = GUICtrlRead($mInput_Name)
				$mInput_DirectoryRead = GUICtrlRead($mInput_Directory)
				$mFileNameExt = StringLower(GUICtrlRead($mInput_Rule))
				If $mCurrentType <> __Lang_Get('EXCLUDE', 'Exclude') And $mCurrentType <> __Lang_Get('DELETE', 'Delete') And Not __FilePathIsValid(_WinAPI_ExpandEnvironmentStrings($mInput_DirectoryRead)) And Not StringInStr($mInput_DirectoryRead, "%File%") Then
					MsgBox(0x30, __Lang_Get('MANAGE_EDIT_MSGBOX_0', 'Destination Error'), __Lang_Get('MANAGE_EDIT_MSGBOX_1', 'You must specify a valid destination.'), 0, __OnTop($mGUI))
					ContinueLoop
				EndIf

				Switch $mCurrentType
					Case __Lang_Get('COPY', 'Copy')
						$mTEMPFileNameExt = $mFileNameExt & "$1"
					Case __Lang_Get('EXCLUDE', 'Exclude')
						$mTEMPFileNameExt = $mFileNameExt & "$2"
						$mInput_DirectoryRead = $mEmptyDestination
					Case __Lang_Get('COMPRESS', 'Compress')
						$mTEMPFileNameExt = $mFileNameExt & "$3"
					Case __Lang_Get('EXTRACT', 'Extract')
						$mTEMPFileNameExt = $mFileNameExt & "$4"
						If StringInStr($mFileNameExt, "**") Then
							MsgBox(0x30, __Lang_Get('MANAGE_EDIT_MSGBOX_4', 'Pattern Error'), __Lang_Get('MANAGE_EDIT_MSGBOX_11', 'You cannot use this action for folders.'), 0, __OnTop($mGUI))
							ContinueLoop
						EndIf
					Case __Lang_Get('OPEN_WITH', 'Open With')
						$mTEMPFileNameExt = $mFileNameExt & "$5"
						If Not __IsSupported($mInput_DirectoryRead, "bat;cmd;com;exe;pif") Or StringInStr($mInput_DirectoryRead, "DropIt.exe") Then ; DropIt.exe Is Excluded To Avoid A Loop.
							MsgBox(0x30, __Lang_Get('MANAGE_EDIT_MSGBOX_0', 'Destination Error'), __Lang_Get('MANAGE_EDIT_MSGBOX_1', 'You must specify a valid destination.'), 0, __OnTop($mGUI))
							ContinueLoop
						EndIf
					Case __Lang_Get('DELETE', 'Delete')
						$mTEMPFileNameExt = $mFileNameExt & "$6"
						$mInput_DirectoryRead = $mEmptyDestination
					Case Else ; Move
						$mTEMPFileNameExt = $mFileNameExt & "$0"
				EndSwitch

				If StringInStr($mFileNameExt, "*") And Not StringInStr(StringRight($mFileNameExt, 2), "$") And Not StringInStr($mFileNameExt, "|") And Not StringInStr($mInput_DirectoryRead, "|") And Not StringInStr($mInput_NameRead, "|") Then
					$mMsgBox = 6
					If IniRead($mProfile[0], "Patterns", $mTEMPFileNameExt, "0") <> "0" Then
						If $mFileNameExt <> $mInput_RuleData Then $mMsgBox = MsgBox(0x04, __Lang_Get('MANAGE_EDIT_MSGBOX_2', 'Replace association'), __Lang_Get('MANAGE_EDIT_MSGBOX_3', 'This pattern rule already exists. Do you want to replace it?'), 0, __OnTop())
						If $mMsgBox = 6 Then IniDelete($mProfile[0], "Patterns", $mTEMPFileNameExt)
					EndIf

					If $mMsgBox = 6 Then
						If $mNewAssociation = 0 Then
							Switch $mInitialType
								Case __Lang_Get('COPY', 'Copy')
									$mInitialType = "$1"
								Case __Lang_Get('EXCLUDE', 'Exclude')
									$mInitialType = "$2"
								Case __Lang_Get('COMPRESS', 'Compress')
									$mInitialType = "$3"
								Case __Lang_Get('EXTRACT', 'Extract')
									$mInitialType = "$4"
								Case __Lang_Get('OPEN_WITH', 'Open With')
									$mInitialType = "$5"
								Case __Lang_Get('DELETE', 'Delete')
									$mInitialType = "$6"
								Case Else ; Move
									$mInitialType = "$0"
							EndSwitch
							IniDelete($mProfile[0], "Patterns", $mInput_RuleData & $mInitialType)
						EndIf
						If $mInput_NameRead <> "" Then $mInput_DirectoryRead &= "|" & $mInput_NameRead
						IniWrite($mProfile[0], "Patterns", $mTEMPFileNameExt, $mInput_DirectoryRead)
						$mChanged = 1
						ExitLoop
					EndIf
				Else
					MsgBox(0x30, __Lang_Get('MANAGE_EDIT_MSGBOX_4', 'Pattern Error'), __Lang_Get('MANAGE_EDIT_MSGBOX_5', 'You have to insert a correct pattern ("$", "?", "|" characters cannot be used)'), 0, __OnTop())
				EndIf

			Case $mButton_Rule
				MsgBox(0, __Lang_Get('MANAGE_EDIT_MSGBOX_6', 'Supported Rules'), __Lang_Get('MANAGE_EDIT_MSGBOX_7', 'Examples of supported pattern rules for files:  @LF  *.jpg   = all files with "jpg" extension  @LF  penguin.*   = all files named "penguin"  @LF  penguin*.*   = all files that begin with "penguin"  @LF  *penguin*   = all files that contain "penguin"  @LF  @LF  Examples of supported pattern rules for folders:  @LF  robot**   = all folders that begin with "robot"  @LF  **robot   = all folders that end with "robot"  @LF  **robot**   = all folders that contain "robot"  @LF  @LF  Separate several rules in a pattern with ";" to  @LF  create multi-rule patterns (eg:  *.jpg;*.png ).'), 0, __OnTop())

			Case $mButton_Type
				__ExpandEnvStrings(0)
				MsgBox(0, __Lang_Get('MANAGE_EDIT_MSGBOX_8', 'Actions and Destination'), __Lang_Get('MANAGE_EDIT_MSGBOX_9', 'The action is the mode of processing files that match with this pattern.  @LF  @LF  This is the list of internal environment variables for destination:  @LF  %CurrentDate% = current date  @LF  %DateAccessed% = date file last access  @LF  %DateCreated% = date file creation  @LF  %DateModified% = date file modification  @LF  %DateTaken% = date picture taken  @LF  %File% = file full path (only for Open With)  @LF  %FileAuthor% = file author  @LF  %FileName% = file name (only for Open With)  @LF  %FileType% = file type  @LF  %PortableDrive% = current drive letter  @LF  %SongAlbum% = song album  @LF  %SongArtist% = song artist  @LF  %SongGenre% = song genre  @LF  %SongYear% = song year', 1), 0, __OnTop())
				__ExpandEnvStrings(1)

			Case $mButton_Directory
				If $mCurrentType <> __Lang_Get('OPEN_WITH', 'Open With') Then
					$mFolder = FileSelectFolder(__Lang_Get('MANAGE_DESTINATION_FOLDER_SELECT', 'Select a destination folder:'), "", 3, "", $mGUI)
					If StringRight($mFolder, 1) = "\" Then $mFolder = StringTrimRight($mFolder, 1)
				Else
					$mFolder = FileOpenDialog(__Lang_Get('MANAGE_DESTINATION_PROGRAM_SELECT', 'Select a destination program:'), @ScriptDir, __Lang_Get('MANAGE_EDIT_MSGBOX_10', 'Executable or Script') & " (*.bat;*.cmd;*.com;*.exe;*.pif)", 1, "", $mGUI)
					If @error Then $mFolder = ""
				EndIf
				If $mFolder <> "" Then GUICtrlSetData($mInput_Directory, $mFolder)

		EndSwitch
	WEnd
	GUIDelete($mGUI)

	If $mChanged = 1 Then Return $mChanged
	Return SetError(1, 1, 0)
EndFunc   ;==>_Manage_Edit_GUI

Func _Manage_Delete($mListView, $mIndex, $mProfile)
	Local $mMsgBox, $mPattern, $mCurrentType

	$mPattern = _GUICtrlListView_GetItemText($mListView, $mIndex)
	$mCurrentType = _GUICtrlListView_GetItemText($mListView, $mIndex, 1)
	If @error Then Return SetError(1, 1, 0)

	If $mIndex = -1 Then Return SetError(1, 1, 0)
	If $mProfile = "" Then $mProfile = __IsProfile(-1, 0) ; Get Array Of Current Profile.
	If $mIndex <> -1 Then $mMsgBox = MsgBox(0x04, __Lang_Get('MANAGE_DELETE_MSGBOX_0', 'Delete association'), __Lang_Get('MANAGE_DELETE_MSGBOX_1', 'Selected pattern:') & "  " & $mPattern & @LF & __Lang_Get('MANAGE_DELETE_MSGBOX_2', 'Are you sure to delete this association?'), 0, __OnTop())
	If $mMsgBox <> 6 Then Return SetError(1, 1, 0)

	Switch $mCurrentType
		Case __Lang_Get('COPY', 'Copy')
			$mCurrentType = "$1"
		Case __Lang_Get('EXCLUDE', 'Exclude')
			$mCurrentType = "$2"
		Case __Lang_Get('COMPRESS', 'Compress')
			$mCurrentType = "$3"
		Case __Lang_Get('EXTRACT', 'Extract')
			$mCurrentType = "$4"
		Case __Lang_Get('OPEN_WITH', 'Open With')
			$mCurrentType = "$5"
		Case __Lang_Get('DELETE', 'Delete')
			$mCurrentType = "$6"
		Case Else ; Move
			$mCurrentType = "$0"
	EndSwitch

	IniDelete($mProfile, "Patterns", $mPattern & $mCurrentType)
	_GUICtrlListView_DeleteItem($mListView, $mIndex)

	$Global_ListViewIndex = -1
	If Not @error Then Return 1
	Return SetError(1, 1, 0)
EndFunc   ;==>_Manage_Delete

Func _Manage_Update($mListView, $mProfile)
	Local $mPatterns, $mFileNameExt_Pattern, $mFileNameExt_Shown, $mState, $mType

	$mPatterns = __GetPatterns($mProfile) ; Gets Patterns Array For The Current Profile.

	_GUICtrlListView_BeginUpdate($mListView)
	_GUICtrlListView_DeleteAllItems($mListView)
	For $A = 1 To $mPatterns[0][0]
		$mFileNameExt_Pattern = $mPatterns[$A][0]
		$mFileNameExt_Shown = StringTrimRight($mFileNameExt_Pattern, 2)
		$mType = StringRight($mFileNameExt_Pattern, 2)

		Switch $mType
			Case "$1"
				$mState = __Lang_Get('COPY', 'Copy')
			Case "$2"
				$mState = __Lang_Get('EXCLUDE', 'Exclude')
			Case "$3"
				$mState = __Lang_Get('COMPRESS', 'Compress')
			Case "$4"
				$mState = __Lang_Get('EXTRACT', 'Extract')
			Case "$5"
				$mState = __Lang_Get('OPEN_WITH', 'Open With')
			Case "$6"
				$mState = __Lang_Get('DELETE', 'Delete')
			Case Else
				$mState = __Lang_Get('MOVE', 'Move')
		EndSwitch

		_GUICtrlListView_AddItem($mListView, $mFileNameExt_Shown)
		_GUICtrlListView_AddSubItem($mListView, $A - 1, $mState, 1)
		_GUICtrlListView_AddSubItem($mListView, $A - 1, $mPatterns[$A][2], 2)
	Next

	Local $B_DESCENDING[_GUICtrlListView_GetColumnCount($mListView)]
	_GUICtrlListView_SimpleSort($mListView, $B_DESCENDING, 0)
	_GUICtrlListView_SetItemSelected($mListView, 0, False, False)
	_GUICtrlListView_EndUpdate($mListView)

	If Not @error Then Return $mProfile
	Return SetError(1, 1, 0)
EndFunc   ;==>_Manage_Update

Func _GUICtrlListView_ContextMenu_Manage($cmListView, $cmIndex, $cmSubItem)
	#forceref $cmSubItem
	Local Enum $cmItem1 = 1000, $cmItem2, $cmItem3

	If Not IsHWnd($cmListView) Then $cmListView = GUICtrlGetHandle($cmListView)

	Local $cmContextMenu = _GUICtrlMenu_CreatePopup()
	If $cmIndex <> -1 And $cmSubItem <> -1 Then ; Won't Show These MenuItem(s) Unless An Item Is Selected.
		_GUICtrlMenu_AddMenuItem($cmContextMenu, __Lang_Get('EDIT', 'Edit'), $cmItem1)
		_GUICtrlMenu_AddMenuItem($cmContextMenu, __Lang_Get('DELETE', 'Delete'), $cmItem2)
	EndIf
	If $cmIndex = -1 And $cmSubItem <> -1 Then ; Will Show These MenuItem(s) If No Item Is Selected.
		_GUICtrlMenu_AddMenuItem($cmContextMenu, __Lang_Get('NEW', 'New'), $cmItem3) ; Will Show These MenuItem(s) Regardless.
	EndIf

	Switch _GUICtrlMenu_TrackPopupMenu($cmContextMenu, $cmListView, -1, -1, 1, 1, 2)
		Case $cmItem1
			GUICtrlSendToDummy($Global_ListViewRules_Enter)

		Case $cmItem2
			GUICtrlSendToDummy($Global_ListViewRules_Delete)

		Case $cmItem3
			GUICtrlSendToDummy($Global_ListViewRules_New)

	EndSwitch
	_GUICtrlMenu_DestroyMenu($cmContextMenu)
	Return 1
EndFunc   ;==>_GUICtrlListView_ContextMenu_Manage
#Region End >>>>> Manage Functions <<<<<

#Region Start >>>>> Customize Functions <<<<<
Func _Customize_GUI($cHandle = -1, $cProfileList = -1)
	Local $cGUI = $Global_Customize

	Local $cProfileDirectory, $cListView, $cListView_Handle, $cNew, $cClose, $cIndex_Selected, $cText, $cImage, $cSizeText, $cTransparency
	Local $cDeleteDummy, $cEnterDummy, $cNewDummy

	$cProfileDirectory = __GetDefault(2) ; Get Default Profile Directory.

	If $cProfileList = -1 Or $cProfileList = 0 Or $cProfileList = "" Then $cProfileList = __ProfileList() ; Get Array Of All Profiles.
	If Not IsArray($cProfileList) Then Return SetError(1, 1, 0) ; Exit Function If No ProfileList.

	$cGUI = GUICreate(__Lang_Get('CUSTOMIZE_GUI', 'Customize Profiles'), 320, 210, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($cHandle))
	$Global_Customize = $cGUI

	$cListView = GUICtrlCreateListView(__Lang_Get('PROFILE', 'Profile') & "|" & __Lang_Get('IMAGE', 'Image') & "|" & __Lang_Get('SIZE', 'Size') & "|" & __Lang_Get('TRANSPARENCY', 'Transparency'), 5, 5, 310, 160, BitOR($LVS_NOSORTHEADER, $LVS_REPORT, $LVS_SINGLESEL))
	$cListView_Handle = GUICtrlGetHandle($cListView)

	$Global_ListViewProfiles = $cListView_Handle

	Local $cImageList = _GUIImageList_Create(20, 20, 5, 3) ; Creates An ImageList.
	_GUICtrlListView_SetImageList($cListView, $cImageList, 1)
	$Global_ImageList = $cImageList

	_GUICtrlListView_SetExtendedListViewStyle($cListView_Handle, BitOR($LVS_EX_DOUBLEBUFFER, $LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_INFOTIP))
	Local $cColumnSize = __Column_Width("ColumnCustom")
	For $A = 1 To $cColumnSize[0]
		_GUICtrlListView_SetColumnWidth($cListView_Handle, $A - 1, $cColumnSize[$A])
	Next

	Local $cToolTip = _GUICtrlListView_GetToolTips($cListView_Handle)
	If IsHWnd($cToolTip) Then
		__OnTop($cToolTip, 1)
		_GUIToolTip_SetDelayTime($cToolTip, 3, 60) ; Speeds Up InfoTip Appearance.
	EndIf

	_Customize_Update($cListView_Handle, $cProfileDirectory, $cProfileList, $cImageList) ; Add/Update Customise GUI With List Of Profiles.
	If @error Then SetError(1, 1, 0) ; Exit Function If No Profiles.

	$cDeleteDummy = GUICtrlCreateDummy()
	$Global_ListViewProfiles_Delete = $cDeleteDummy
	$cEnterDummy = GUICtrlCreateDummy()
	$Global_ListViewProfiles_Enter = $cEnterDummy
	$cNewDummy = GUICtrlCreateDummy()
	$Global_ListViewProfiles_New = $cNewDummy

	$cNew = GUICtrlCreateButton("&" & __Lang_Get('NEW', 'New'), 160 - 30 - 74, 175, 74, 25)
	GUICtrlSetTip($cNew, __Lang_Get('CUSTOMIZE_GUI_TIP_0', 'Click to add a profile or Right-click a profile to manage it.'))
	$cClose = GUICtrlCreateButton("&" & __Lang_Get('CLOSE', 'Close'), 160 + 30, 175, 74, 25)
	GUICtrlSetTip($cClose, __Lang_Get('CUSTOMIZE_GUI_TIP_1', 'Save profile changes and close the window.'))
	GUICtrlSetState($cClose, 576)

	$Global_ListViewIndex = -1 ; Set As No Item Selected.
	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
	GUISetState(@SW_SHOW)
	Local $cHotKeys[3][2] = [["^n", $cNewDummy],["{DELETE}", $cDeleteDummy],["{ENTER}", $cEnterDummy]]
	GUISetAccelerators($cHotKeys)

	While 1
		__ReduceMemory() ; Reduce Memory Usage Of DropIt.

		Switch GUIGetMsg()
			Case $cClose, $GUI_EVENT_CLOSE
				Local $cColumnSize[_GUICtrlListView_GetColumnCount($cListView_Handle)]
				For $A = 0 To UBound($cColumnSize) - 1
					$cColumnSize[$A] = _GUICtrlListView_GetColumnWidth($cListView_Handle, $A)
				Next
				__Column_Width("ColumnCustom", $cColumnSize)
				ExitLoop

			Case $cNew, $cNewDummy
				_Customize_Edit_GUI($cGUI, -1, -1, -1, -1, 1) ; Show Customize Edit GUI For New Profile.
				_Customize_Update($cListView_Handle, $cProfileDirectory, -1) ; Add/Update Customise GUI With List Of Profiles.

			Case $cDeleteDummy
				_Customize_Delete($cListView_Handle, _GUICtrlListView_GetSelectionMark($cListView_Handle), $cProfileDirectory, -1, $cGUI) ; Delete Profile From The Default Profile Directory & ListView.

			Case $cEnterDummy
				$cIndex_Selected = _GUICtrlListView_GetSelectionMark($cListView_Handle)
				If Not _GUICtrlListView_GetItemState($cListView_Handle, $cIndex_Selected, $LVIS_SELECTED) Then ContinueLoop

				$cText = _GUICtrlListView_GetItemText($cListView_Handle, $cIndex_Selected)
				$cImage = _GUICtrlListView_GetItemText($cListView_Handle, $cIndex_Selected, 1)
				$cSizeText = _GUICtrlListView_GetItemText($cListView_Handle, $cIndex_Selected, 2)
				$cTransparency = _GUICtrlListView_GetItemText($cListView_Handle, $cIndex_Selected, 3)
				_Customize_Edit_GUI($cGUI, $cText, $cImage, $cSizeText, $cTransparency, 0) ; Show Customize Edit GUI Of Selected Profile.
				_Customize_Update($cListView_Handle, $cProfileDirectory, -1) ; Add/Update Customise GUI With List Of Profiles.
				_GUICtrlListView_SetItemSelected($cListView_Handle, $cIndex_Selected, True, True)

		EndSwitch
	WEnd
	GUIDelete($cGUI)
	_GUIImageList_Destroy($cImageList)

	__SetCurrentPosition() ; Set Current Coordinates/Position Of DropIt.
	__IsOnTop() ; Set GUI "OnTop" If True.

	$cProfileList = __ProfileList() ; Get Array Of All Profiles.
	If Not @error Then Return $cProfileList
	Return SetError(1, 1, 0)
EndFunc   ;==>_Customize_GUI

Func _Customize_Edit_GUI($cHandle = -1, $cProfile = -1, $cImage = -1, $cSizeText = -1, $cTransparency = -1, $cNewProfile = 0)
	Local $cGUI_1 = $Global_GUI_1

	Local $cStringSplit, $cProfileType, $cGUI, $cInput_Name, $cInput_Image, $cButton_Image, $cInput_SizeX, $cInput_SizeY, $cButton_Size, $cInput_Transparency
	Local $cSave, $cCancel, $cChanged = 0, $cProfileDirectory, $cReturn, $cSizeX, $cSizeY, $cIniWrite, $cItemText, $cLabel_Transparency, $cCurrentProfile = 0
	Local $cNewProfileCreated = 0, $cIcon_GUI, $cInitialProfileName, $cIcon_Label

	$cProfile = __IsProfile($cProfile, 0) ; Get Array Of Selected Profile.
	$cProfileDirectory = __GetDefault(22) ; Get Default Profile & Default Image Directory & Default Image File.

	If $cNewProfile = 1 Then $cProfile[1] = ""
	If $cImage == -1 Or $cImage == 0 Or $cImage == "" Then $cImage = $cProfileDirectory[3][0] ; Default Image Directory & Default Image File.

	If Not IsArray($cSizeText) Then $cStringSplit = StringSplit($cSizeText, "x")
	If IsArray($cStringSplit) And $cSizeText <> -1 Then
		Local $cSize[2] = [$cStringSplit[1], $cStringSplit[2]]
	Else
		Local $cSize[2] = [64, 64]
	EndIf

	If $cTransparency == -1 Or $cTransparency == 0 Or $cTransparency == "" Or $cTransparency < 10 Or $cTransparency > 100 Then $cTransparency = 100
	$cTransparency = StringReplace($cTransparency, "%", "")

	Select
		Case $cNewProfile = 1
			$cProfileType = __Lang_Get('CUSTOMIZE_PROFILE_NEW', 'New Profile')

		Case $cNewProfile = 0
			$cProfileType = __Lang_Get('CUSTOMIZE_PROFILE_EDIT', 'Edit Profile')
	EndSelect
	If __IsCurrentProfile($cProfile[1]) Then $cCurrentProfile = 1 ; __IsCurrentProfile() = Checks If Selected Profile Is The Current Profile.
	$cInitialProfileName = $cProfile[1] ; For Renaming.

	$cGUI = GUICreate($cProfileType, 260, 290, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($cHandle))
	GUICtrlCreateLabel(__Lang_Get('NAME', 'Name') & ":", 10, 10, 120, 20)
	$cInput_Name = GUICtrlCreateInput($cProfile[1], 10, 31, 170, 20) ; Renaming Function Will Have To Be Re-Built.
	GUICtrlSetTip($cInput_Name, __Lang_Get('CUSTOMIZE_EDIT_TIP_0', 'Choose a name for this profile.'))

	GUICtrlCreateLabel(__Lang_Get('IMAGE', 'Image') & ":", 10, 60 + 10, 120, 20)
	$cInput_Image = GUICtrlCreateInput($cImage, 10, 60 + 31, 170, 20)
	GUICtrlSetTip($cInput_Image, __Lang_Get('CUSTOMIZE_EDIT_TIP_1', 'Select an image for this profile.'))
	$cButton_Image = GUICtrlCreateButton(__Lang_Get('SEARCH', 'Search'), 10 + 174, 60 + 30, 66, 22)
	GUICtrlSetTip($cButton_Image, __Lang_Get('SEARCH', 'Search'))

	GUICtrlCreateLabel(__Lang_Get('SIZE', 'Size') & ":", 10, 120 + 10, 120, 20)
	$cInput_SizeX = GUICtrlCreateInput($cSize[0], 10, 120 + 31, 50, 20, 0x2000)
	GUICtrlSetTip($cInput_SizeX, __Lang_Get('WIDTH', 'Width'))
	GUICtrlCreateLabel("X", 10 + 66, 120 + 34, 34, 20)
	$cInput_SizeY = GUICtrlCreateInput($cSize[1], 10 + 90, 120 + 31, 50, 20, 0x2000)
	GUICtrlSetTip($cInput_SizeY, __Lang_Get('HEIGHT', 'Height'))
	$cButton_Size = GUICtrlCreateButton("&" & __Lang_Get('RESET', 'Reset'), 10 + 174, 120 + 30, 66, 22)
	GUICtrlSetTip($cButton_Size, __Lang_Get('CUSTOMIZE_EDIT_TIP_2', 'Reset target image to the original size.'))

	GUICtrlCreateLabel(__Lang_Get('TRANSPARENCY', 'Transparency') & ":", 10, 180 + 10, 120, 20)
	$cInput_Transparency = GUICtrlCreateSlider(10, 180 + 31, 200, 20)
	$Global_Slider = $cInput_Transparency
	GUICtrlSetLimit(-1, 100, 10)
	GUICtrlSetData(-1, $cTransparency)
	$cLabel_Transparency = GUICtrlCreateLabel($cTransparency & "%", 10 + 200, 180 + 31, 36, 20)
	$Global_SliderLabel = $cLabel_Transparency

	$cSave = GUICtrlCreateButton("&" & __Lang_Get('SAVE', 'Save'), 130 - 20 - 76, 250, 76, 26)
	GUICtrlSetState($cSave, 144) ; Disable Save Button Initially.
	$cCancel = GUICtrlCreateButton("&" & __Lang_Get('CANCEL', 'Cancel'), 130 + 20, 250, 76, 26)
	GUICtrlSetState($cCancel, 576)

	$cIcon_GUI = GUICreate("", 0, 0, 200, 24, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_MDICHILD), $cGUI)
	$cIcon_Label = GUICtrlCreateLabel("", 0, 0, 32, 32)
	GUICtrlSetCursor($cIcon_Label, 0)
	GUICtrlSetTip($cIcon_Label, __Lang_Get('CUSTOMIZE_EDIT_TIP_1', 'Select an image for this profile.'))
	Local $cGUISize = __ImageSize($cProfile[8] & $cImage)
	$cGUISize = __ImageRelativeSize(32, 32, $cGUISize[0], $cGUISize[1])
	__SetBitmap($cIcon_GUI, $cProfile[8] & $cImage, 255 / 100 * $cProfile[7], $cGUISize[0], $cGUISize[1]) ; Set Image & Resize To The Image GUI.

	GUISetState(@SW_SHOW, $cGUI)
	GUISetState(@SW_SHOW, $cIcon_GUI)

	GUIRegisterMsg(0x0114, "WM_HSCROLL") ; Required For Changing The Label Next To The Slider.
	ControlClick($cGUI, "", $cInput_Name)

	While 1
		__ReduceMemory() ; Reduce Memory Usage Of DropIt.

		; Disable/Enable Save Button.
		If GUICtrlRead($cInput_Name) <> "" And GUICtrlRead($cInput_Image) <> "" And GUICtrlRead($cInput_SizeX) <> "" And GUICtrlRead($cInput_SizeY) <> "" _
				And GUICtrlRead($cInput_Transparency) <> "" And __FilePathIsValid($cProfileDirectory[2][0] & GUICtrlRead($cInput_Image)) And Not StringIsSpace(GUICtrlRead($cInput_Name)) Then
			If GUICtrlGetState($cSave) > 80 Then GUICtrlSetState($cSave, 576) ; 80 = Normal; 144 = Disabled; 576 = Focused.
			If GUICtrlGetState($cCancel) = 512 Then GUICtrlSetState($cCancel, 80) ; 80 = Normal; 144 = Disabled; 576 = Focused.
		ElseIf GUICtrlRead($cInput_Name) = "" Or GUICtrlRead($cInput_Image) = "" Or GUICtrlRead($cInput_SizeX) = "" Or GUICtrlRead($cInput_SizeY) = "" _
				Or GUICtrlRead($cInput_Transparency) = "" Or Not __FilePathIsValid($cProfileDirectory[2][0] & GUICtrlRead($cInput_Image)) Or StringIsSpace(GUICtrlRead($cInput_Name)) Then
			If GUICtrlGetState($cSave) = 80 Then GUICtrlSetState($cSave, 144) ; 80 = Normal; 144 = Disabled; 576 = Focused.
			If GUICtrlGetState($cCancel) = 80 Then GUICtrlSetState($cCancel, 512) ; 80 = Normal; 144 = Disabled; 576 = Focused.
		EndIf

		; Disable/Enable Some Buttons.
		If GUICtrlRead($cInput_Name) <> "" And Not StringIsSpace(GUICtrlRead($cInput_Name)) Then
			If GUICtrlGetState($cButton_Image) > 80 Then GUICtrlSetState($cButton_Image, 80) ; 80 = Normal; 144 = Disabled; 576 = Focused.
			If GUICtrlGetState($cButton_Size) > 80 Then GUICtrlSetState($cButton_Size, 80) ; 80 = Normal; 144 = Disabled; 576 = Focused.
			If GUICtrlGetState($cInput_Transparency) > 80 Then GUICtrlSetState($cInput_Transparency, 80) ; 80 = Normal; 144 = Disabled; 576 = Focused.
			If GUICtrlGetState($cInput_SizeX) > 80 Then GUICtrlSetState($cInput_SizeX, 80) ; 80 = Normal; 144 = Disabled; 576 = Focused.
			If GUICtrlGetState($cInput_SizeY) > 80 Then GUICtrlSetState($cInput_SizeY, 80) ; 80 = Normal; 144 = Disabled; 576 = Focused.
			If GUICtrlGetState($cInput_Image) > 80 Then GUICtrlSetState($cInput_Image, 80) ; 80 = Normal; 144 = Disabled; 576 = Focused.
		ElseIf GUICtrlRead($cInput_Name) = "" Or StringIsSpace(GUICtrlRead($cInput_Name)) Then
			If GUICtrlGetState($cButton_Image) = 80 Then GUICtrlSetState($cButton_Image, 144) ; 80 = Normal; 144 = Disabled; 576 = Focused.
			If GUICtrlGetState($cButton_Size) = 80 Then GUICtrlSetState($cButton_Size, 144) ; 80 = Normal; 144 = Disabled; 576 = Focused.
			If GUICtrlGetState($cInput_Transparency) = 80 Then GUICtrlSetState($cInput_Transparency, 144) ; 80 = Normal; 144 = Disabled; 576 = Focused.
			If GUICtrlGetState($cInput_SizeX) = 80 Then GUICtrlSetState($cInput_SizeX, 144) ; 80 = Normal; 144 = Disabled; 576 = Focused.
			If GUICtrlGetState($cInput_SizeY) = 80 Then GUICtrlSetState($cInput_SizeY, 144) ; 80 = Normal; 144 = Disabled; 576 = Focused.
			If GUICtrlGetState($cInput_Image) = 80 Then GUICtrlSetState($cInput_Image, 144) ; 80 = Normal; 144 = Disabled; 576 = Focused.
		EndIf

		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $cCancel
				If $cProfile[1] <> $cInitialProfileName And $cNewProfile = 0 And $cNewProfileCreated = 0 Then
					FileMove($cProfileDirectory[1][0] & $cInitialProfileName & ".ini", $cProfileDirectory[1][0] & $cProfile[1] & ".ini")
					If $cInitialProfileName == __GetCurrentProfile() Then ; Get Current Profile From The Settings INI File.
						__SetCurrentProfile($cProfile[1]) ; Write Selected Profile Name To The Settings INI File.
					EndIf
				EndIf

				If $cNewProfile = 0 Then _Image_Write($cProfile[1], 7, $cProfile[4], $cProfile[5], $cProfile[6], $cProfile[7]) ; Write Image File Name & Size & Transparency To The Selected Profile.

				$cItemText = StringReplace(StringStripWS(GUICtrlRead($cInput_Name), 7), " ", "_")
				If $cNewProfile = 1 Or $cNewProfileCreated = 1 Then FileDelete($cProfileDirectory[1][0] & $cItemText & ".ini")

				SetError(1, 1, 0)
				ExitLoop

			Case $cSave
				$cItemText = StringReplace(StringStripWS(GUICtrlRead($cInput_Name), 7), " ", "_")

				If $cNewProfile = 1 Or $cInitialProfileName <> $cItemText Then
					$cItemText = __IsProfileUnique($cGUI, $cItemText) ; Checks If The Selected Profile Name Is Unique.
					If @error Then
						GUICtrlSetData($cInput_Name, "")
						ContinueLoop
					EndIf
				EndIf

				If $cNewProfile = 1 Then
					$cIniWrite = $cProfileDirectory[1][0] & $cItemText & ".ini"
					If Not FileExists($cIniWrite) Then
						IniWriteSection($cIniWrite, "Target", "Image=" & $cProfileDirectory[3][0] & @LF & "SizeX=64" & @LF & "SizeY=64" & @LF & "Transparency=100")
						IniWriteSection($cIniWrite, "Patterns", "")
					EndIf
				EndIf

				If $cInitialProfileName <> $cItemText Then
					FileMove($cProfileDirectory[1][0] & $cInitialProfileName & ".ini", $cProfileDirectory[1][0] & $cItemText & ".ini")
					If $cInitialProfileName == __GetCurrentProfile() Then ; Get Current Profile From The Settings INI File.
						__SetCurrentProfile($cItemText) ; Write Selected Profile Name To The Settings INI File.
					EndIf
					$cInitialProfileName = $cItemText
				EndIf

				_Image_Write($cItemText, 7, GUICtrlRead($cInput_Image), GUICtrlRead($cInput_SizeX), GUICtrlRead($cInput_SizeY), GUICtrlRead($cInput_Transparency)) ; Write Image File Name & Size & Transparency To The Selected Profile.

				$cChanged = 1
				ExitLoop

			Case $cButton_Image, $cIcon_Label
				If StringIsSpace(GUICtrlRead($cInput_Name)) Or GUICtrlRead($cInput_Name) = "" Then ContinueLoop
				$cItemText = StringReplace(StringStripWS(GUICtrlRead($cInput_Name), 7), " ", "_")

				If $cNewProfile = 1 Or $cInitialProfileName <> $cItemText Then
					$cItemText = __IsProfileUnique($cGUI, $cItemText) ; Checks If The Selected Profile Name Is Unique.
					If @error Then
						GUICtrlSetData($cInput_Name, $cProfile[1])
						ContinueLoop
					EndIf
				EndIf

				If $cNewProfile = 1 Then
					$cIniWrite = $cProfileDirectory[1][0] & $cItemText & ".ini"
					If Not FileExists($cIniWrite) Then
						IniWriteSection($cIniWrite, "Target", "Image=" & $cProfileDirectory[3][0] & @LF & "SizeX=64" & @LF & "SizeY=64" & @LF & "Transparency=100")
						IniWriteSection($cIniWrite, "Patterns", "")
					EndIf
					$cNewProfile = 0
					$cNewProfileCreated = 1
				EndIf

				If $cInitialProfileName <> $cItemText Then
					FileMove($cProfileDirectory[1][0] & $cInitialProfileName & ".ini", $cProfileDirectory[1][0] & $cItemText & ".ini")
					If $cInitialProfileName == __GetCurrentProfile() Then ; Get Current Profile From The Settings INI File.
						__SetCurrentProfile($cItemText) ; Write Selected Profile Name To The Settings INI File.
					EndIf
					$cInitialProfileName = $cItemText
				EndIf

				$cItemText = StringReplace(StringStripWS(GUICtrlRead($cInput_Name), 7), " ", "_")
				$cImage = GUICtrlRead($cInput_Image)
				$cTransparency = GUICtrlRead($cInput_Transparency)
				$cReturn = _Image_Get($cGUI, $cItemText) ; Select Image From Default Image Directory Or Custom Directory, It Will Copy To The Default Image Directory If Selected In A Custom Directory.

				If Not @error Then
					$cImage = $cReturn[1]
					$cSizeX = $cReturn[2]
					$cSizeY = $cReturn[3]
					$cTransparency = $cReturn[4]
					GUICtrlSetData($cInput_Image, $cImage)
					GUICtrlSetData($cInput_SizeX, $cSizeX)
					GUICtrlSetData($cInput_SizeY, $cSizeY)
					__SetBitmap($cIcon_GUI, $cProfileDirectory[2][0] & $cImage, 255 / 100 * $cTransparency, 32, 32) ; Set Image & Resize To The Image GUI.
					If $cCurrentProfile = 1 Then __SetBitmap($cGUI_1, $cProfileDirectory[2][0] & $cImage, 255 / 100 * $cTransparency, $cSizeX, $cSizeY) ; Set Image & Resize To The GUI If Current Profile.
					__GUIInBounds($cGUI_1) ; Checks If The GUI Is Within View Of The Users Screen.
				EndIf
				$cChanged = 1

			Case $cButton_Size
				$cItemText = StringReplace(StringStripWS(GUICtrlRead($cInput_Name), 7), " ", "_")
				$cImage = GUICtrlRead($cInput_Image)
				$cReturn = __ImageSize($cProfileDirectory[2][0] & $cImage)
				If Not @error Then
					GUICtrlSetData($cInput_SizeX, $cReturn[0])
					GUICtrlSetData($cInput_SizeY, $cReturn[1])
					GUICtrlSetData($cInput_Transparency, 100)
					GUICtrlSetData($cLabel_Transparency, 100 & "%")
					If Not $cNewProfile Then _Image_Write($cItemText, 2, $cImage, $cReturn[0], $cReturn[1], 100) ; Write Size To The Selected Profile.
					__SetBitmap($cIcon_GUI, $cProfileDirectory[2][0] & $cImage, 255 / 100 * 100, 32, 32) ; Set Image & Resize To The Image GUI.
					If $cCurrentProfile = 1 Then __SetBitmap($cGUI_1, $cProfileDirectory[2][0] & $cImage, 255 / 100 * 100, $cReturn[0], $cReturn[1]) ; Set Image & Resize To The GUI If Current Profile.
				EndIf
				$cChanged = 1

			Case $cInput_Transparency ; Changes The Transparency Of The Current Profile Image Only.
				$cImage = GUICtrlRead($cInput_Image)
				$cSizeX = GUICtrlRead($cInput_SizeX)
				$cSizeY = GUICtrlRead($cInput_SizeY)
				$cTransparency = GUICtrlRead($cInput_Transparency)
				__SetBitmap($cIcon_GUI, $cProfileDirectory[2][0] & $cImage, 255 / 100 * $cTransparency, 32, 32) ; Set Image & Resize To The Image GUI.
				If $cCurrentProfile = 1 Then __SetBitmap($cGUI_1, $cProfileDirectory[2][0] & $cImage, 255 / 100 * $cTransparency, $cSizeX, $cSizeY) ; Set Image & Resize To The GUI If Current Profile.

		EndSwitch
	WEnd
	GUIDelete($cGUI)

	__SetCurrentPosition() ; Set Current Coordinates/Position Of DropIt.
	$cProfile = __IsProfile(-1, 0) ; Get Array Of Current Profile.
	__SetBitmap($cGUI_1, $cProfile[3], 255 / 100 * $cProfile[7], $cProfile[5], $cProfile[6]) ; Set Image & Resize To The GUI.

	If $cChanged = 1 Then Return $cChanged
	Return SetError(1, 1, 0)
EndFunc   ;==>_Customize_Edit_GUI

Func _Customize_Delete($cListView, $cIndexItem, $cProfileDirectory, $cFileName = -1, $cHandle = -1)
	If $cIndexItem = -1 Then Return SetError(1, 1, 0)
	If $cFileName = -1 Or $cFileName = 0 Or $cFileName = "" Then $cFileName = _GUICtrlListView_GetItemText($cListView, $cIndexItem, 0)
	If $cFileName = "" Then Return SetError(1, 1, 0)

	If _GUICtrlListView_GetItemCount($cListView) = 1 Then
		MsgBox(0x30, __Lang_Get('CUSTOMIZE_DELETE_MSGBOX_0', 'Profile Error'), __Lang_Get('CUSTOMIZE_DELETE_MSGBOX_1', 'You must have at least 1 active profile.'), 0, __OnTop($cHandle))
		Return SetError(1, 1, 0)
	EndIf

	Local $cMsgBox = MsgBox(0x04, __Lang_Get('CUSTOMIZE_DELETE_MSGBOX_2', 'Delete selected profile'), __Lang_Get('CUSTOMIZE_DELETE_MSGBOX_3', 'Selected profile:') & "  " & $cFileName & @LF & __Lang_Get('CUSTOMIZE_DELETE_MSGBOX_4', 'Are you sure to delete this profile?'), 0, __OnTop($cHandle))
	If $cMsgBox = 6 Then
		FileDelete($cProfileDirectory & $cFileName & ".ini")
		_GUICtrlListView_DeleteItem($cListView, $cIndexItem)

		__SetCurrentProfile(_GUICtrlListView_GetItemText($cListView, 0, 0)) ; Write Selected Profile Name To The Settings INI File.

		$cIndexItem -= 1
		If $cIndexItem = -1 Then $cIndexItem = 0
		_GUICtrlListView_SetItemSelected($cListView, $cIndexItem, True)
		If Not @error Then Return 1
	EndIf

	_GUICtrlListView_SetItemSelected($cListView, $cIndexItem, True)
	If Not @error Then Return 1
	Return SetError(1, 1, 0)
EndFunc   ;==>_Customize_Delete

Func _Customize_Update($cListView, $cProfileDirectory, $cProfileList = -1, $cImageList = $Global_ImageList)
	Local $cListViewItem, $cIniReadTransparency, $cIniRead, $cIniRead_Size[2]

	If $cProfileList = -1 Or $cProfileList = 0 Or $cProfileList = "" Then $cProfileList = __ProfileList() ; Get Array Of All Profiles.
	If Not IsArray($cProfileList) Then Return SetError(1, 1, 0)

	If Not __IsFolder($cProfileDirectory) Then Return SetError(1, 1, 0) ; If Selected Is Not A Directory Then Return @error.

	Local $cImageDirectory = __GetDefault(4) ; Default Image Directory.

	_GUICtrlListView_BeginUpdate($cListView)
	_GUICtrlListView_DeleteAllItems($cListView)

	For $A = 1 To $cProfileList[0]
		Local $cINI = $cProfileDirectory & $cProfileList[$A] & ".ini"
		$cListViewItem = _GUICtrlListView_AddItem($cListView, $cProfileList[$A])

		$cIniRead = IniRead($cINI, "Target", "Image", "")
		If $cIniRead = "" Then $cIniRead = __GetDefault(16) ; Default Image File.
		_GUICtrlListView_AddSubItem($cListView, $cListViewItem, $cIniRead, 1)

		$cIniRead_Size[0] = IniRead($cINI, "Target", "SizeX", "")
		$cIniRead_Size[1] = IniRead($cINI, "Target", "SizeY", "")
		$cIniReadTransparency = IniRead($cINI, "Target", "Transparency", "")

		If $cIniRead_Size[0] = "" Or $cIniRead_Size[1] = "" Then $cIniRead_Size = __ImageSize(__GetDefault(4) & $cIniRead) ; If X & Y Empty Then Find The Size Of The Image Using Default Image Directory.
		If Not IsArray($cIniRead_Size) Then Return SetError(1, 1, 0)

		_GUICtrlListView_AddSubItem($cListView, $cListViewItem, $cIniRead_Size[0] & "x" & $cIniRead_Size[1], 2)
		_GUICtrlListView_AddSubItem($cListView, $cListViewItem, $cIniReadTransparency & "%", 3)

		__SetItemImageEx($cListView, $cListViewItem, $cImageList, $cImageDirectory & $cIniRead, 1)
	Next
	_GUICtrlListView_SetIconSpacing($cListView, 32, 32)
	_GUICtrlListView_SetItemSelected($cListView, 0, True)
	_GUICtrlListView_EndUpdate($cListView)

	If @error Then Return 1
	Return SetError(1, 1, 0)
EndFunc   ;==>_Customize_Update

Func _GUICtrlListView_ContextMenu_Customize($cmListView, $cmIndex, $cmSubItem)
	#forceref $cmSubItem
	Local Enum $cmItem1 = 1000, $cmItem2, $cmItem3

	If Not IsHWnd($cmListView) Then $cmListView = GUICtrlGetHandle($cmListView)

	Local $cmContextMenu = _GUICtrlMenu_CreatePopup()
	If $cmIndex <> -1 And $cmSubItem <> -1 Then ; Won't Show These MenuItem(s) Unless An Item Is Selected.
		_GUICtrlMenu_AddMenuItem($cmContextMenu, __Lang_Get('EDIT', 'Edit'), $cmItem1)
		_GUICtrlMenu_AddMenuItem($cmContextMenu, __Lang_Get('DELETE', 'Delete'), $cmItem2)
	EndIf
	If $cmIndex = -1 And $cmSubItem <> -1 Then ; Will Show These MenuItem(s) If No Item Is Selected.
		_GUICtrlMenu_AddMenuItem($cmContextMenu, __Lang_Get('NEW', 'New'), $cmItem3)
	EndIf

	Switch _GUICtrlMenu_TrackPopupMenu($cmContextMenu, $cmListView, -1, -1, 1, 1, 2)
		Case $cmItem1
			GUICtrlSendToDummy($Global_ListViewProfiles_Enter)

		Case $cmItem2
			GUICtrlSendToDummy($Global_ListViewProfiles_Delete)

		Case $cmItem3
			GUICtrlSendToDummy($Global_ListViewProfiles_New)

	EndSwitch
	_GUICtrlMenu_DestroyMenu($cmContextMenu)
	Return 1
EndFunc   ;==>_GUICtrlListView_ContextMenu_Customize
#Region End >>>>> Customize Functions <<<<<

#Region Start >>>>> Image Functions <<<<<
Func _Image_Get($iHandle = -1, $iProfile = -1)
	Local $iImageFile, $iSize, $iFileName

	Local $iReturn[6]

	$iImageFile = __IsProfile($iProfile, 0) ; Get Array Of Selected Profile.
	Local $iFileOpenDialog = FileOpenDialog(__Lang_Get('IMAGE_GET_TIP_0', 'Select target image for this Profile'), $iImageFile[8], __Lang_Get('IMAGE_GET', 'Images') & " (*.gif;*.jpg;*.png)", 1, "", __OnTop($iHandle))
	If @error Then Return SetError(1, 1, 0)

	If StringLeft(FileGetVersion(@SystemDir & "\WinVer.exe"), 3) < 6.0 And __GetFileNameExExt($iFileOpenDialog, 1) == "gif" Then $iFileOpenDialog = __ImageConvert($iFileOpenDialog, $iImageFile[8])

	If Not StringInStr($iFileOpenDialog, $iImageFile[8]) Then
		FileCopy($iFileOpenDialog, $iImageFile[8])
		$iFileOpenDialog = $iImageFile[8] & __GetFileName($iFileOpenDialog) ; Get The File Name Of The Selected [FileName.txt].
	EndIf

	$iSize = __ImageSize($iFileOpenDialog)
	$iFileName = StringTrimLeft($iFileOpenDialog, StringLen($iImageFile[8]))
	$iReturn[0] = $iFileOpenDialog ; FilePath + FileName.
	$iReturn[1] = $iFileName ; FileName.
	$iReturn[2] = $iSize[0] ; FileSize Width.
	$iReturn[3] = $iSize[1] ; FileSize Height.
	$iReturn[4] = 100 ; Transparency.
	$iReturn[5] = $iImageFile[8] ; FilePath.

	_Image_Write($iProfile, 7, $iReturn[1], $iReturn[2], $iReturn[3], $iReturn[4]) ; Write Image File Name & Size & Transparency To The Selected Profile.
	Return $iReturn
EndFunc   ;==>_Image_Get

Func _Image_Write($iProfile = -1, $iFlag = 1, $iImageFile = -1, $iSize_X = 64, $iSize_Y = 64, $iTransparency = 100)
	$iProfile = __IsProfile($iProfile, 1) ; Get Profile Path Of Selected Profile.

	If $iImageFile == -1 Or $iImageFile == 0 Or $iImageFile == "" Then $iImageFile = __GetDefault(16) ; Default Image File.
	$iTransparency = StringReplace($iTransparency, "%", "")

	If BitAND($iFlag, 1) Then IniWrite($iProfile, "Target", "Image", $iImageFile) ; 1 = Add Image File.
	If BitAND($iFlag, 2) Then ; 2 = Add Image Size.
		IniWrite($iProfile, "Target", "SizeX", $iSize_X)
		IniWrite($iProfile, "Target", "SizeY", $iSize_Y)
	EndIf
	If BitAND($iFlag, 4) Then IniWrite($iProfile, "Target", "Transparency", $iTransparency) ; 4 = Add Transparency.

	If Not @error Then Return 1
	Return SetError(1, 1, 0)
EndFunc   ;==>_Image_Write
#Region End >>>>> Image Functions <<<<<

#Region Start >>>>> Processing Functions <<<<<
Func _DropEvent($dFiles, $dProfile)
	__ExpandEnvStrings(1) ; Enables The Expansion Of Environment Variables.

	Local $dMsgBox, $dSize, $dFullSize, $dElementsGUI, $dFailedList[1] = [0]
	If Not IsArray($dFiles) Then SetError(1, 1, 0)

	For $A = 0 To UBound($dFiles) - 1
		If Not FileExists($dFiles[$A]) Then ContinueLoop
		If __IsFolder($dFiles[$A]) Then ; Checks If Selected Is A Directory.
			$dSize = DirGetSize($dFiles[$A])
		Else
			$dSize = FileGetSize($dFiles[$A])
		EndIf
		$dFullSize += $dSize
	Next
	__Log_Write(__Lang_Get('DROP_EVENT_TIP_0', 'Total Size Loaded'), __ByteSuffix($dFullSize)) ; __ByteSuffix() = Rounds A Value Of Bytes To Highest Value.

	If $dFullSize > 2147483648 And __Is("SizeMessage") Then
		$dMsgBox = MsgBox(0x04, __Lang_Get('DROP_EVENT_MSGBOX_3', 'Estimated long processing time'), __Lang_Get('DROP_EVENT_MSGBOX_4', 'You are trying to process a large size of files') & " (" & __ByteSuffix($dFullSize) & ")" & @LF & __Lang_Get('DROP_EVENT_MSGBOX_5', 'It may take a long time, do you wish to continue?'), 0, __OnTop())
		If $dMsgBox <> 6 Then
			__Log_Write(__Lang_Get('DROP_EVENT_TIP_1', 'Sorting Aborted'), __Lang_Get('DROP_EVENT_MSGBOX_3', 'Estimated long processing time'))
			Return SetError(1, 1, 0)
		EndIf
	EndIf

	$dElementsGUI = _Sorting_CreateGUI($dFullSize) ; Create The Sorting GUI & Show It If Option Is Enabled.
	For $A = 0 To UBound($dFiles) - 1
		If FileExists($dFiles[$A]) Then $dFailedList = _PositionCheck($dFiles[$A], $dProfile, $dFailedList, $dElementsGUI)
		If $Global_AbortSorting Then
			$dFailedList[0] = 0 ; Do Not Show Failed Items If The User Aborts Sorting (The List Results Incomplete).
			ExitLoop
		EndIf
	Next
	_Sorting_DeleteGUI() ; Delete The Sorting GUI.

	; Report A List Of Failed Sortings
	If $dFailedList[0] > 0 Then
		Local $dFailedString
		For $A = 1 To $dFailedList[0]
			$dFailedString &= ">> " & $dFailedList[$A] & @CRLF ; Notepad Needs @CRLF Instead Of @LF To Create A New Line.
		Next
		If $dFailedList[0] < 8 Then
			MsgBox(0x40, __Lang_Get('DROP_EVENT_MSGBOX_6', 'Sorting Partially Failed'), __Lang_Get('DROP_EVENT_MSGBOX_7', 'Sorting failed for the following files/folders:') & @LF & $dFailedString, 0, __OnTop())
		Else
			$dMsgBox = MsgBox(0x04, __Lang_Get('DROP_EVENT_MSGBOX_6', 'Sorting Partially Failed'), __Lang_Get('DROP_EVENT_MSGBOX_8', 'Sorting failed for some files/folders.  @LF  Do you want to read a list of them?'), 0, __OnTop())
			If $dMsgBox = 6 Then
				Local $dFileName = @ScriptDir & "\FailedList.txt"
				Local $dFile = FileOpen($dFileName, 2)
				FileWriteLine($dFile, "{NOTE: this file will be removed after closing}")
				FileWriteLine($dFile, "")
				FileWriteLine($dFile, __Lang_Get('DROP_EVENT_MSGBOX_7', 'Sorting failed for the following files/folders:'))
				FileWrite($dFile, $dFailedString)
				FileClose($dFile)
				ShellExecuteWait($dFileName)
				FileDelete($dFileName)
			EndIf
		EndIf
	EndIf

	__ExpandEnvStrings(0) ; Disables The Expansion Of Environment Variables.
	$Global_AbortSorting = 0
	If Not @error Then Return 1
	Return SetError(1, 1, 0)
EndFunc   ;==>_DropEvent

Func _CheckingMatches($cFileName, $cFileNameExt, $cProfile) ; Returns: Directory [C:\DropItFiles] Or To Associate [0] Or To Skip [-1]
	$cProfile = __IsProfile($cProfile, 0) ; Get Array Of Selected Profile.
	Local $cMatch, $cPattern, $cPatternToSplit, $cStringSplit, $cPatterns, $cMatches[1][2] = [[0, 2]]

	$cPatterns = __GetPatterns($cProfile[1]) ; Gets Patterns Array For The Current Profile.
	If @error Then Return SetError(1, 1, -1)

	For $A = 1 To $cPatterns[0][0]
		$cMatch = 0
		$cPatternToSplit = StringTrimRight($cPatterns[$A][0], 2)
		$cPatternToSplit = StringReplace($cPatternToSplit, "; ", ";") ; To Support Rules Also If Separated By A Space After Semicolon.
		$cStringSplit = StringSplit($cPatternToSplit, ";")

		For $B = 1 To $cStringSplit[0]
			If StringInStr($cStringSplit[$B], "**") Then
				$cPattern = StringReplace($cStringSplit[$B], "**", "(.*?)")
				If $cFileNameExt = "0" Then $cMatch = StringRegExp(StringLower($cFileName), "^" & $cPattern & "$")
			Else
				$cPattern = StringReplace($cStringSplit[$B], "*", "(.*?)")
				If $cFileNameExt <> "0" Then $cMatch = StringRegExp(StringLower($cFileName), "^" & $cPattern & "$")
			EndIf
			If $cMatch = 1 Then ExitLoop
		Next

		If $cMatch = 1 And $cMatches[0][0] < 13 Then
			If UBound($cMatches, 1) <= $cMatches[0][0] + 1 Then ReDim $cMatches[UBound($cMatches, 1) + 1][2] ; ReSize Array If More Items Are Required.
			$cMatches[0][0] += 1
			$cMatches[$cMatches[0][0]][0] = $cPatterns[$A][0]
			$cMatches[$cMatches[0][0]][1] = $cPatterns[$A][1]
		EndIf
	Next

	If $cMatches[0][0] = 1 Then
		$Global_Action = StringRight($cMatches[1][0], 2) ; Set Action For This File/Folder.
		If $Global_Action == "$2" Then ; $2 = Exclude.
			Return SetError(1, 1, -1)
		Else
			; ReDim $cMatches[$cMatches[0][0] + 1][UBound($cMatches, 2)] ; Delete Empty Spaces.
			Return $cMatches[$cMatches[0][0]][1]
		EndIf
	ElseIf $cMatches[0][0] > 1 Then
		; ReDim $cMatches[$cMatches[0][0] + 1][UBound($cMatches, 2)] ; Delete Empty Spaces.
		$cMatch = _MoreMatches($cMatches, $cFileName)
		Return $cMatch
	EndIf
	Return SetError(1, 1, 0)
EndFunc   ;==>_CheckingMatches

Func _MoreMatches($mMatches, $mFileName)
	Local $mHandle = $Global_GUI_1

	Local $mGUI, $mType, $mMsg, $mAdditional, $mCancel, $mButtons[$mMatches[0][0] + 1] = [0], $mRead = -1
	If Not IsArray($mMatches) Then Return SetError(1, 1, 0) ; Exit Function If Not An Array.
	$mGUI = GUICreate(__Lang_Get('MOREMATCHES_GUI', 'Select Action'), 300, 115 + 23 * $mMatches[0][0], -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	GUICtrlCreateGroup(__Lang_Get('MOREMATCHES_LABEL_0', 'Loaded item:'), 8, 6, 284, 40)
	GUICtrlCreateLabel($mFileName, 20, 24, 260, 20)
	GUICtrlSetTip($mFileName, __Lang_Get('MOREMATCHES_TIP_0', 'This item fits with several patterns.'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__Lang_Get('MOREMATCHES_LABEL_1', 'Select the action to use:'), 8, 52, 284, 24 + 23 * $mMatches[0][0])
	For $A = 1 To $mMatches[0][0]
		$mType = StringRight($mMatches[$A][0], 2)
		Switch $mType
			Case "$1"
				$mAdditional = __Lang_Get('COPY', 'Copy')
			Case "$2"
				$mAdditional = __Lang_Get('EXCLUDE', 'Exclude')
			Case "$3"
				$mAdditional = __Lang_Get('COMPRESS', 'Compress')
			Case "$4"
				$mAdditional = __Lang_Get('EXTRACT', 'Extract')
			Case "$5"
				$mAdditional = __Lang_Get('OPEN_WITH', 'Open With')
			Case "$6"
				$mAdditional = __Lang_Get('DELETE', 'Delete')
			Case Else
				$mAdditional = __Lang_Get('MOVE', 'Move')
		EndSwitch
		$mAdditional &= " (" & $mMatches[$A][1] & ")"
		$mButtons[$A] = GUICtrlCreateButton(" " & __GetCompactFilePath($mAdditional, 45), 20, 46 + ($A * 23), 260, 22, 0x0100)
		$mButtons[0] += 1
	Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$mCancel = GUICtrlCreateButton("&" & __Lang_Get('CANCEL', 'Cancel'), 150 - 45, 83 + 23 * $mMatches[0][0], 90, 24)
	GUISetState(@SW_SHOW)

	While 1
		__ReduceMemory() ; Reduce Memory Usage Of DropIt.

		$mMsg = GUIGetMsg()
		Switch $mMsg
			Case $GUI_EVENT_CLOSE, $mCancel
				$mRead = -1
				ExitLoop

			Case Else
				If $mMsg >= $mButtons[1] And $mMsg <= $mButtons[$mButtons[0]] Then
					For $A = 1 To $mButtons[0]
						If $mMsg = $mButtons[$A] Then
							$Global_Action = StringRight($mMatches[$A][0], 2) ; Set Action For This File/Folder.
							$mRead = $mMatches[$A][1]
							ExitLoop 2
						EndIf
					Next
					ExitLoop
				EndIf

		EndSwitch
	WEnd
	GUIDelete($mGUI)

	If $mRead = -1 Or $Global_Action == "$2" Then Return SetError(1, 1, -1)
	Return $mRead
EndFunc   ;==>_MoreMatches

Func _PositionCheck($pFilePath, $pProfile, ByRef $pFailedList, $pElementsGUI)
	Local $pSearch, $pFileName, $pFailedFile, $pMultiplePosition = 0, $pWildcards = ""

	If __IsFolder($pFilePath) Then
		If Not __Is("DirForFolders") Then
			$pMultiplePosition = 1
			$pWildcards = "*.*"
		EndIf
	Else
		$pFileName = __GetFileName($pFilePath) ; File Or Folder Name.
		If StringInStr($pFileName, "*") Then
			$pMultiplePosition = 1
			$pWildcards = $pFileName
			$pFilePath = StringTrimRight(__GetParentFolder($pFilePath), 1) ; Parent Path.
		EndIf
	EndIf

	If $pMultiplePosition = 1 Then
		$pSearch = FileFindFirstFile($pFilePath & "\" & $pWildcards) ; Load Files.
		While 1
			$pFileName = FileFindNextFile($pSearch)
			If @error Then ExitLoop
			If Not __IsFolder($pFilePath & "\" & $pFileName) Then
				$pFailedFile = _PositionProcess($pFilePath & "\" & $pFileName, $pProfile, $pElementsGUI) ; If Selected Is Not A Directory Then Process The File.
				If @error Then
					Switch $pFailedFile
						Case 1 ; Skipped.
						Case 0 ; Aborted.
							FileClose($pSearch)
							Return $pFailedList ; Immediately Return If Sorting Aborted.
						Case Else ; Failed.
							$pFailedList[0] += 1
							ReDim $pFailedList[$pFailedList[0] + 1]
							$pFailedList[$pFailedList[0]] = $pFailedFile
					EndSwitch
				EndIf
			EndIf
		WEnd
		FileClose($pSearch)
		$pSearch = FileFindFirstFile($pFilePath & "\" & $pWildcards) ; Load Folders.
		While 1
			$pFileName = FileFindNextFile($pSearch)
			If @error Then ExitLoop
			If __IsFolder($pFilePath & "\" & $pFileName) Then $pFailedList = _PositionCheck($pFilePath & "\" & $pFileName, $pProfile, $pFailedList, $pElementsGUI) ; If Selected Is A Directory Then Process The Directory.
		WEnd
		FileClose($pSearch)
	Else
		$pFailedFile = _PositionProcess($pFilePath, $pProfile, $pElementsGUI)
		If @error Then
			Switch $pFailedFile
				Case 1 ; Skipped.
				Case 0 ; Aborted.
					Return $pFailedList ; Immediately Return If Sorting Aborted.
				Case Else ; Failed.
					$pFailedList[0] += 1
					ReDim $pFailedList[$pFailedList[0] + 1]
					$pFailedList[$pFailedList[0]] = $pFailedFile
			EndSwitch
		EndIf
	EndIf

	If Not @error Then Return $pFailedList
	Return SetError(1, 1, $pFailedList)
EndFunc   ;==>_PositionCheck

Func _PositionProcess($pFilePath, $pProfile, $pElementsGUI)
	__ReduceMemory() ; Reduce Memory Usage Of DropIt.
	Local $pINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $pCompressionFormat = __7ZipCurrentFormat()

	Local $pFileName, $pFileNameExt = 0, $pSortFailed = 0, $pIsDirectory = 0, $pMsgBox = 1, $pDestinationDirectory
	Local $pAssociate, $A, $pFileNameWoExt, $pNumberExtension, $pSyntaxDir, $pCurrentSize

	If __IsFolder($pFilePath) Then $pIsDirectory = 1 ; Checks If Selected Is A Directory.
	If $pIsDirectory Then ; If $pIsDirectory = 1 Then It Is A Directory.
		If StringRight($pFilePath, 1) = "\" Then $pFilePath = StringTrimRight($pFilePath, 1) ; If FilePath Has "\" At The End Of The String Delete.
		$pCurrentSize = DirGetSize($pFilePath)
		__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_0', 'Folder Loaded'), $pFilePath)
	Else ; If $pIsDirectory = 0 Then It Is A File.
		$pFileNameExt = __GetFileNameExExt($pFilePath, 1) ; Returns E.G. ini
		$pCurrentSize = FileGetSize($pFilePath)
		__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_1', 'File Loaded'), $pFilePath)
	EndIf
	$pFileName = __GetFileName($pFilePath) ; Returns E.G. Example.ini

	; Check If The Pattern Matches
	$pDestinationDirectory = _CheckingMatches($pFileName, $pFileNameExt, $pProfile) ; Destination If OK, 0 To Associate, -1 To Skip.
	If $pDestinationDirectory == 0 Then
		If __Is("IgnoreNew", $pINI) Then
			__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_2', 'Not Sorted'), __Lang_Get('POSITIONPROCESS_LOGMSG_0', 'Skipped'))
			$Global_SortingCurrentSize += $pCurrentSize
			GUICtrlSetData($pElementsGUI[2], Round($Global_SortingCurrentSize / $Global_SortingTotalSize * 100)) ; Force Update Progress Bar.
			Return 1 ; Skip The Function By Returning 1.
		Else
			$pMsgBox = MsgBox(0x04, __Lang_Get('POSITIONPROCESS_MSGBOX_0', 'Association Needed'), __Lang_Get('POSITIONPROCESS_MSGBOX_1', 'No association found for:') & @LF & $pFilePath & @LF & @LF & __Lang_Get('POSITIONPROCESS_MSGBOX_2', 'Do you want to associate a destination folder for it?'), 0, __OnTop())
			If $pMsgBox = 6 Then
				$pAssociate = _Manage_Edit_GUI($pProfile, $pFileName, $pFileNameExt, -1, -1, -1, 1, 1) ; Show Manage Edit GUI Of Selected Pattern.
				If $pAssociate <> 0 Then $pDestinationDirectory = _CheckingMatches($pFileName, $pFileNameExt, $pProfile) ; Destination If OK, 0 To Associate, -1 To Skip.
			EndIf
		EndIf
	EndIf
	If $pDestinationDirectory == 0 Or $pDestinationDirectory == -1 Or $pDestinationDirectory = "" Then
		If $pDestinationDirectory == -1 Then
			__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_2', 'Not Sorted'), __Lang_Get('POSITIONPROCESS_LOGMSG_0', 'Skipped'))
		Else
			__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_2', 'Not Sorted'), __Lang_Get('POSITIONPROCESS_LOGMSG_1', 'Aborted'))
		EndIf
		$Global_SortingCurrentSize += $pCurrentSize
		GUICtrlSetData($pElementsGUI[2], Round($Global_SortingCurrentSize / $Global_SortingTotalSize * 100)) ; Force Update Progress Bar.
		Return 1 ; Exits In Not Associated Cases.
	EndIf

	; Special Environment Variables Based On File Properties
	If StringInStr($pDestinationDirectory, "%") Then
		Local $pLoadedProperty
		Local $pEnvArray[11][3] = [ _
				[10, 0, 0], _ ; Item, Parameter, Type.
				["DateAccessed", 2, 2], _
				["DateCreated", 1, 2], _
				["DateModified", 0, 2], _
				["DateTaken", 9, 1], _
				["FileAuthor", 12, 0], _
				["FileType", 2, 0], _
				["SongAlbum", 15, 0], _
				["SongArtist", 13, 0], _
				["SongGenre", 16, 0], _
				["SongYear", 17, 0]]

		For $A = 1 To $pEnvArray[0][0]
			If $pEnvArray[$A][2] = 2 Then
				$pLoadedProperty = FileGetTime($pFilePath, $pEnvArray[$A][1], 1)
				$pLoadedProperty = StringRegExpReplace($pLoadedProperty, "(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})", "$1-$2-$3") ; Convert To YYYY-MM-DD.
			Else
				$pLoadedProperty = __GetFileProperties($pFilePath, $pEnvArray[$A][1], 1)
				If $pEnvArray[$A][2] = 1 Then
					$pLoadedProperty = StringRegExpReplace($pLoadedProperty, "[^0-9]", "") ; Remove All Non-Digit Characters.
					$pLoadedProperty = StringRegExpReplace($pLoadedProperty, "(\d{2})(\d{2})(\d{4})(\d{2})(\d{2})", "$3-$2-$1") ; Convert To YYYY-MM-DD.
				EndIf
			EndIf
			If $pLoadedProperty == "" Then $pLoadedProperty = "Unknown " & $pEnvArray[$A][0]
			$pDestinationDirectory = StringReplace($pDestinationDirectory, "%" & $pEnvArray[$A][0] & "%", $pLoadedProperty)
		Next
	EndIf

	; Destination Folder Creation
	If $Global_Action <> "$5" And $Global_Action <> "$6" And Not FileExists($pDestinationDirectory) Then
		Local $pIsDirectoryCreated = DirCreate($pDestinationDirectory)
		If Not $pIsDirectoryCreated Then
			MsgBox(0x40, __Lang_Get('POSITIONPROCESS_MSGBOX_3', 'Destination Folder Problem'), __Lang_Get('POSITIONPROCESS_MSGBOX_4', 'Sorting operation has been partially skipped.  @LF  The following destination folder does not exist and cannot be created:') & @LF & __GetCompactFilePath($pDestinationDirectory, 65), 0, __OnTop())
			__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_2', 'Not Sorted'), __Lang_Get('POSITIONPROCESS_LOGMSG_2', 'Failed'))
			$Global_SortingCurrentSize += $pCurrentSize
			GUICtrlSetData($pElementsGUI[2], Round($Global_SortingCurrentSize / $Global_SortingTotalSize * 100)) ; Force Update Progress Bar.
			Return SetError(1, 1, 1) ; Exits If @error Occured With Creating Directory.
		EndIf
	EndIf

	; File Name Update
	$pFileNameWoExt = $pFileName
	If $Global_Action == "$3" Then ; If Compression Is Enabled.
		If $pIsDirectory Then ; If Is A Directory.
			$pFileNameWoExt = $pFileName & "." & $pCompressionFormat ; Create A Variable Containing $pFileName + .zip E.G. Test.zip
		Else ; If Is A File.
			$pFileNameWoExt = StringTrimRight($pFileName, StringLen($pFileNameExt) + 1) & "." & $pCompressionFormat ; Create A Variable Containing $pFileName + .zip E.G. Test.zip
		EndIf
	ElseIf $Global_Action == "$4" Then ; If Extraction Is Enabled.
		$pFileNameWoExt = StringTrimRight($pFileName, StringLen($pFileNameExt) + 1) ; Create A Variable Containing The Name Of The Extraction Output Folder.
	EndIf

	; Manage Duplicates
	If FileExists($pDestinationDirectory & "\" & $pFileNameWoExt) Then
		Local $pDupMode = "Skip"
		If __Is("AutoDup", $pINI) Then
			$pDupMode = IniRead($pINI, "General", "DupMode", "Overwrite")
		Else
			$pMsgBox = MsgBox(0x04, __Lang_Get('POSITIONPROCESS_MSGBOX_5', 'Item Already Exists'), '"' & $pFileNameWoExt & '" ' & __Lang_Get('POSITIONPROCESS_MSGBOX_6', 'already exists in destination folder.') & @LF & __Lang_Get('POSITIONPROCESS_MSGBOX_7', 'Do you want to overwrite it? (otherwise it will be skipped)'), 0, __OnTop())
			If $pMsgBox = 6 Then $pDupMode = "Overwrite"
		EndIf

		Switch $pDupMode
			Case "Rename"
				$A = 1
				While 1
					If $A < 10 Then
						$pNumberExtension = 0 & $A ; Creates 01, 02, 03, 04, 05 Til 09.
					Else
						$pNumberExtension = $A ; Creates 10, 11, 12, 13, 14 Etc...
					EndIf
					If $Global_Action == "$3" Then ; If Compression Is Enabled.
						If $pIsDirectory Then ; If Is A Directory.
							$pFileNameWoExt = $pFileName & "_" & $pNumberExtension & "." & $pCompressionFormat ; Create Prefix E.G. Test_01.zip
						Else ; If Is A File.
							$pFileNameWoExt = StringTrimRight($pFileName, StringLen($pFileNameExt) + 1) & "_" & $pNumberExtension & "." & $pCompressionFormat ; Create Prefix E.G. Test_01.zip
						EndIf
					ElseIf $Global_Action == "$4" Then ; If Extraction Is Enabled.
						$pFileNameWoExt = StringTrimRight($pFileName, StringLen($pFileNameExt) + 1) & "_" & $pNumberExtension
					Else
						If $pIsDirectory Then ; If Is A Directory.
							$pFileNameWoExt = $pFileName & "_" & $pNumberExtension ; Create Prefix E.G. Test_01
						Else ; If Is A File.
							$pFileNameWoExt = StringTrimRight($pFileName, StringLen($pFileNameExt) + 1) & "_" & $pNumberExtension & "." & $pFileNameExt ; Create Prefix E.G. Test_01.ini
						EndIf
					EndIf
					If Not FileExists($pDestinationDirectory & "\" & $pFileNameWoExt) Then ExitLoop ; Exit Loop If FileName Is Unique.
					$A += 1
				WEnd

			Case "Skip"
				__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_2', 'Not Sorted'), __Lang_Get('POSITIONPROCESS_LOGMSG_0', 'Skipped'))
				$Global_SortingCurrentSize += $pCurrentSize
				GUICtrlSetData($pElementsGUI[2], Round($Global_SortingCurrentSize / $Global_SortingTotalSize * 100)) ; Force Update Progress Bar.
				Return 1 ; Skip The Function By Returning 1.
		EndSwitch
	EndIf

	__ExpandEventMode(1) ; Enable The Abort Button.
	$pSyntaxDir = $pDestinationDirectory
	If $Global_Action <> "$5" And $Global_Action <> "$6" Then $pSyntaxDir &= "\" & $pFileNameWoExt
	_Sorting_Process($pFilePath, $pSyntaxDir, $pElementsGUI)
	If @error Then $pSortFailed = 1
	__ExpandEventMode(0) ; Disable The Abort Button.

	If $Global_Action == "$3" And __Is("ArchiveSelf") And $pCompressionFormat == "7z" Then
		$pFileNameWoExt = __GetFileNameExExt($pFileNameWoExt) & ".exe" ; Update File Extension If Needed.
		$pSyntaxDir = $pDestinationDirectory & "\" & $pFileNameWoExt
	EndIf
	If $Global_Action <> "$5" And $Global_Action <> "$6" And Not FileExists($pSyntaxDir) Then $pSortFailed = 1
	If $Global_Action == "$6" And FileExists($pFilePath) Then $pSortFailed = 1

	If $pSortFailed Then
		If $Global_AbortSorting Then
			__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_2', 'Not Sorted'), __Lang_Get('POSITIONPROCESS_LOGMSG_1', 'Aborted'))
			Return SetError(1, 1, 0) ; 0 = Aborted Sorting.
		Else
			__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_2', 'Not Sorted'), __Lang_Get('POSITIONPROCESS_LOGMSG_2', 'Failed'))
			$Global_SortingCurrentSize += $pCurrentSize
			GUICtrlSetData($pElementsGUI[2], Round($Global_SortingCurrentSize / $Global_SortingTotalSize * 100)) ; Force Update Progress Bar.
			Return SetError(1, 1, $pFileNameWoExt)
		EndIf
	Else
		Local $pSyntaxMode
		Switch $Global_Action
			Case "$1"
				$pSyntaxMode = __Lang_Get('POSITIONPROCESS_LOG_6', 'Copied')
			Case "$3"
				$pSyntaxMode = __Lang_Get('POSITIONPROCESS_LOG_3', 'Compressed')
			Case "$4"
				$pSyntaxMode = __Lang_Get('POSITIONPROCESS_LOG_4', 'Extracted')
			Case "$5"
				$pSyntaxMode = __Lang_Get('POSITIONPROCESS_LOG_7', 'Opened')
			Case "$6"
				$pSyntaxMode = __Lang_Get('POSITIONPROCESS_LOG_8', 'Deleted')
			Case Else
				$pSyntaxMode = __Lang_Get('POSITIONPROCESS_LOG_5', 'Moved')
		EndSwitch
		__Log_Write($pSyntaxMode, $pSyntaxDir)
	EndIf

	Return 1
EndFunc   ;==>_PositionProcess

Func _Sorting_Abort()
	Switch @GUI_CtrlId
		Case $GUI_EVENT_CLOSE, $Global_AbortButton
			$Global_AbortSorting = 1
	EndSwitch
EndFunc   ;==>_Sorting_Abort

Func _Sorting_ArchiveFile($sSource, $sDestination, $sElementsGUI, $sType = 0)
	Local $sPercent, $sSize, $sArray
	Local $sLabel_2 = $sElementsGUI[1], $sProgress_1 = $sElementsGUI[2], $sProgress_2 = $sElementsGUI[3]

	GUICtrlSetData($sLabel_2, __GetCompactFilePath(__GetFileName($sSource), 68))
	GUICtrlSetData($sProgress_2, 0)
	If __IsFolder($sSource) Then
		$sSize = DirGetSize($sSource)
	Else
		$sSize = FileGetSize($sSource)
	EndIf
	If @error Then Return SetError(1, 0, 0)

	$sArray = __7ZipRun($sSource, $sDestination, $sType, 1, 1) ; $sType = 0 To Compress or $sType = 1 To Extract.
	If @error Or Not IsArray($sArray) Then Return SetError(1, 0, 0)

	Sleep(50) ; Needed, Otherwise Progress Bar Could Be Not Updated.
	Local $sPercentHandle = __7Zip_OpenPercent($sArray[0]), $sPreviousPercent = -1
	While 1
		$sPercent = __7Zip_ReadPercent($sPercentHandle)
		If $sPercent > 0 And $sPreviousPercent <> $sPercent Then
			GUICtrlSetData($sProgress_2, $sPercent)
			$sPreviousPercent = $sPercent
			$sPercent = Round(($Global_SortingCurrentSize + ($sSize * $sPercent / 100)) / $Global_SortingTotalSize * 100)
			If GUICtrlRead($sProgress_1) <> $sPercent Then GUICtrlSetData($sProgress_1, $sPercent)
		Else
			Sleep(50)
		EndIf

		If $Global_AbortSorting Then
			ProcessClose($sArray[0])
			ProcessWaitClose($sArray[0])
			FileDelete($sArray[1])
			Return SetError(1, 0, 0)
		EndIf

		If Not ProcessExists($sArray[0]) Then
			__7Zip_ClosePercent($sPercentHandle)
			GUICtrlSetData($sProgress_2, 100)
			ExitLoop
		EndIf
	WEnd

	$Global_SortingCurrentSize += $sSize
	$sPercent = Round($Global_SortingCurrentSize / $Global_SortingTotalSize * 100)
	If GUICtrlRead($sProgress_1) <> $sPercent Then GUICtrlSetData($sProgress_1, $sPercent)

	Return 1
EndFunc   ;==>_Sorting_ArchiveFile

Func _Sorting_CopyFile($sSource, $sDestination, $sElementsGUI)
	Local $sPercent, $sState, $sError = -1, $sMD5_Before, $sMD5_After
	Local $sLabel_2 = $sElementsGUI[1], $sProgress_1 = $sElementsGUI[2], $sProgress_2 = $sElementsGUI[3]

	If FileExists($sDestination) Then FileSetAttrib($sDestination, '-RH') ; Needed To Overwrite Hidden And Read-Only Files/Folders.
	If __Is("IntegrityCheck") Then $sMD5_Before = __MD5ForFile($sSource)

	GUICtrlSetData($sLabel_2, __GetCompactFilePath(__GetFileName($sSource), 68))
	GUICtrlSetData($sProgress_2, 0)
	If @error Then Return SetError($sError, 0, 0)
	Do
		If $Global_Action == "$0" Then
			If Not _Copy_MoveFile($sSource, $sDestination, 0x0003) Then Return SetError($sError, 0, 0) ; 0x0003 = $MOVE_FILE_COPY_ALLOWED + $MOVE_FILE_REPLACE_EXISTING
		Else
			If Not _Copy_CopyFile($sSource, $sDestination) Then Return SetError($sError, 0, 0)
		EndIf
		While 1
			If $Global_AbortSorting Then _Copy_Abort()
			$sState = _Copy_GetState()
			If $sState[0] Then
				$sPercent = Round($sState[1] / $sState[2] * 100)
				If GUICtrlRead($sProgress_2) <> $sPercent Then
					GUICtrlSetData($sProgress_2, $sPercent)
					$sPercent = Round(($Global_SortingCurrentSize + $sState[1]) / $Global_SortingTotalSize * 100)
					If GUICtrlRead($sProgress_1) <> $sPercent Then GUICtrlSetData($sProgress_1, $sPercent)
				Else
					Sleep(50)
				EndIf
			Else
				If Not $sState[5] Then
					GUICtrlSetData($sProgress_2, 100)
				Else
					$sError = $sState[5]
					Return SetError($sError, 0, 0)
				EndIf
				ExitLoop 2
			EndIf
		WEnd
		If Not StringInStr(FileGetAttrib($sSource), 'A') Then FileSetAttrib($sDestination, '-A')
	Until 1
	$Global_SortingCurrentSize += $sState[2]
	$sPercent = Round($Global_SortingCurrentSize / $Global_SortingTotalSize * 100)
	If GUICtrlRead($sProgress_1) <> $sPercent Then GUICtrlSetData($sProgress_1, $sPercent)

	If __Is("IntegrityCheck") Then
		$sMD5_After = __MD5ForFile($sDestination)
		If $sMD5_Before <> $sMD5_After Then Return SetError(1, 0, 0)
	EndIf

	Return 1
EndFunc   ;==>_Sorting_CopyFile

Func _Sorting_CreateGUI($sTotalSize)
	Local $sLabel1, $sLabel2, $sProgress_1, $sProgress_2

	$Global_SortingTotalSize = $sTotalSize
	$Global_SortingCurrentSize = 0

	If Not _Copy_OpenDll() Then Return SetError(1, 1, 0)

	$Global_SortingGUI = GUICreate(__Lang_Get('POSITIONPROCESS_0', 'Sorting'), 400, 142, -1, -1, -1, -1, __OnTop())
	GUISetOnEvent($GUI_EVENT_CLOSE, '_Sorting_Abort')
	$sLabel1 = GUICtrlCreateLabel(__Lang_Get('POSITIONPROCESS_1', 'Loading') & '...', 16, 14, 368, 16)
	$sProgress_1 = GUICtrlCreateProgress(16, 14 + 16, 368, 16)
	$sLabel2 = GUICtrlCreateLabel('', 16, 60, 368, 16)
	$sProgress_2 = GUICtrlCreateProgress(16, 60 + 16, 368, 16)
	$Global_AbortButton = GUICtrlCreateButton(__Lang_Get('POSITIONPROCESS_2', 'Abort'), 200 - 45, 106, 90, 25)
	GUICtrlSetState(-1, $GUI_DEFBUTTON)
	GUICtrlSetOnEvent(-1, '_Sorting_Abort')

	If __Is("ShowSorting") Then GUISetState(@SW_SHOW)

	Local $sElementsGUI[4] = [$sLabel1, $sLabel2, $sProgress_1, $sProgress_2] ; Populate Elements GUI.

	If Not @error Then Return $sElementsGUI
	Return SetError(1, 1, 0)
EndFunc   ;==>_Sorting_CreateGUI

Func _Sorting_DeleteFile($sSource, $sElementsGUI)
	Local $sPercent, $sSize
	Local $sLabel_2 = $sElementsGUI[1], $sProgress_1 = $sElementsGUI[2], $sProgress_2 = $sElementsGUI[3]

	If __IsReadOnly($sSource) Then FileSetAttrib($sSource, '-R') ; Needed To Delete Read-Only Files/Folders.

	GUICtrlSetData($sLabel_2, __GetCompactFilePath(__GetFileName($sSource), 68))
	GUICtrlSetData($sProgress_2, 0)
	If __IsFolder($sSource) Then
		$sSize = DirGetSize($sSource)
		If __Is("SafetyErase") Then
			__SecureFolderDelete($sSource)
		Else
			DirRemove($sSource, 1)
		EndIf
	Else
		$sSize = FileGetSize($sSource)
		If __Is("SafetyErase") Then
			__SecureFileDelete($sSource)
		Else
			FileDelete($sSource)
		EndIf
	EndIf
	If @error Then Return SetError(1, 0, 0)

	GUICtrlSetData($sProgress_2, 100)
	$Global_SortingCurrentSize += $sSize
	$sPercent = Round($Global_SortingCurrentSize / $Global_SortingTotalSize * 100)
	If GUICtrlRead($sProgress_1) <> $sPercent Then GUICtrlSetData($sProgress_1, $sPercent)

	Return 1
EndFunc   ;==>_Sorting_DeleteFile

Func _Sorting_DeleteGUI()
	GUIDelete($Global_SortingGUI)
	_Copy_CloseDll()

	If Not @error Then Return 1
	Return SetError(1, 1, 0)
EndFunc   ;==>_Sorting_DeleteGUI

Func _Sorting_OpenFile($sSource, $sDestination, $sElementsGUI)
	Local $sPercent, $sSize, $sError = -1
	Local $sLabel_2 = $sElementsGUI[1], $sProgress_1 = $sElementsGUI[2], $sProgress_2 = $sElementsGUI[3]

	GUICtrlSetData($sLabel_2, __GetCompactFilePath(__GetFileName($sSource), 68))
	GUICtrlSetData($sProgress_2, 0)
	$sSize = FileGetSize($sSource)
	If @error Then Return SetError($sError, 0, 0)

	If StringInStr($sDestination, "%") Then
		$sDestination = StringReplace($sDestination, "%File%", '"' & $sSource & '"')
		If StringInStr($sDestination, '""') Then $sDestination = StringReplace($sDestination, '""', '"') ; Fix Double Quotes If Needed.
		$sDestination = StringReplace($sDestination, "%FileName%", __GetFileName($sSource))
		Run($sDestination, @ScriptDir)
	Else
		Run($sDestination & ' "' & $sSource & '"', @ScriptDir)
	EndIf
	If @error Then Return SetError($sError, 0, 0)

	GUICtrlSetData($sProgress_2, 100)
	$Global_SortingCurrentSize += $sSize
	$sPercent = Round($Global_SortingCurrentSize / $Global_SortingTotalSize * 100)
	If GUICtrlRead($sProgress_1) <> $sPercent Then GUICtrlSetData($sProgress_1, $sPercent)

	Return 1
EndFunc   ;==>_Sorting_OpenFile

Func _Sorting_Process($sSource, $sDestination, $sElementsGUI, $sRoot = '')
	Local $sPath, $sFile, $sSearch, $sError = -1
	Local $sLabel_1 = $sElementsGUI[0]

	If $Global_AbortSorting Then SetError($sError, 0, 0) ; Needed To Do Not Start A New Operation If Sorting Is Aborted.

	Switch $Global_Action
		Case "$3" ; Compress Action.
			GUICtrlSetData($sLabel_1, __GetCompactFilePath(StringTrimRight(__GetParentFolder($sDestination), 1), 68))
			_Sorting_ArchiveFile($sSource, $sDestination, $sElementsGUI, 0)
			If Not @error Then Return 1

		Case "$4" ; Extract Action.
			GUICtrlSetData($sLabel_1, __GetCompactFilePath(StringTrimRight(__GetParentFolder($sDestination), 1), 68))
			_Sorting_ArchiveFile($sSource, $sDestination, $sElementsGUI, 1)
			If Not @error Then Return 1

		Case "$5" ; Open With Action.
			GUICtrlSetData($sLabel_1, __GetCompactFilePath($sDestination, 68))
			_Sorting_OpenFile($sSource, $sDestination, $sElementsGUI)
			If Not @error Then Return 1

		Case "$6" ; Delete Action.
			GUICtrlSetData($sLabel_1, __GetCompactFilePath($sSource, 68))
			_Sorting_DeleteFile($sSource, $sElementsGUI)
			If Not @error Then Return 1

		Case Else ; Move Or Copy Action.
			If __IsFolder($sSource) Then
				If Not FileExists($sDestination) Then
					If Not DirCreate($sDestination) Then Return SetError($sError, 0, 0)
				EndIf
				$sSearch = FileFindFirstFile($sSource & $sRoot & '\*.*')
				If $sSearch = -1 Then
					Switch @error
						Case 1 ; Folder Is Empty.
						Case Else
							Return SetError(-1, 0, 0)
					EndSwitch
				EndIf
				While 1
					$sFile = FileFindNextFile($sSearch)
					If @error Then
						FileClose($sSearch)
						Return 1
					EndIf
					$sPath = $sRoot & '\' & $sFile
					If @extended Then
						GUICtrlSetData($sLabel_1, __GetCompactFilePath($sDestination & $sPath, 68))
						If Not FileExists($sDestination & $sPath) Then
							If Not DirCreate($sDestination & $sPath) Then ExitLoop
							FileSetAttrib($sDestination & $sPath, '+' & StringReplace(FileGetAttrib($sSource & $sPath), 'D', ''))
						EndIf
						If Not _Sorting_Process($sSource, $sDestination, $sElementsGUI, $sPath) Then
							$sError = @error
							ExitLoop
						EndIf
					Else
						If Not _Sorting_CopyFile($sSource & $sPath, $sDestination & $sPath, $sElementsGUI) Then
							$sError = @error
							ExitLoop
						EndIf
					EndIf
				WEnd
				FileClose($sSearch)
			Else
				GUICtrlSetData($sLabel_1, __GetCompactFilePath(StringTrimRight(__GetParentFolder($sDestination), 1), 68))
				_Sorting_CopyFile($sSource, $sDestination, $sElementsGUI)
				If Not @error Then Return 1
			EndIf
	EndSwitch

	Return SetError($sError, 0, 0)
EndFunc   ;==>_Sorting_Process
#Region End >>>>> Processing Functions <<<<<

#Region Start >>>>> Main Functions <<<<<
Func _Main()
	Local $mINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $mProfileList, $mMsg

	__InstalledCheck() ; Check To See If DropIt Is Installed.
	__IsProfile() ; Checks If A Default Profile Is Available.
	_Main_Create() ; Refresh The Main GUI & TrayMenu, Including Translation Strings & ContextMenu.

	GUIRegisterMsg(0x004A, "WM_COPYDATA")
	GUIRegisterMsg(0x0233, "WM_DROPFILES_UNICODE")
	GUIRegisterMsg(0x0112, "WM_SYSCOMMAND")

	__Log_Write(@LF & __Lang_Get('DROPIT_STARTED', 'DropIt Started'), __Lang_Get('DATE', 'Date') & " " & @MDAY & "-" & @MON & "-" & @YEAR)

	While 1
		__ReduceMemory() ; Reduce Memory Usage Of DropIt.

		$mMsg = GUIGetMsg()
		Switch $mMsg
			Case $GUI_EVENT_CLOSE, $Global_ContextMenu[9][0] ; Exit DropIt If An Exit Event Is Called.
				ExitLoop

			Case $GUI_EVENT_DROPPED
				GUISetState(@SW_SHOW, $Global_GUI_2) ; Show Small Working Icon.
				_DropEvent($Global_DroppedFiles, -1) ; Send Dropped Files To Be Processed.
				GUISetState(@SW_HIDE, $Global_GUI_2) ; Hide Small Working Icon.

			Case $Global_ContextMenu[2][0]
				GUICtrlSetState($Global_Icon_1, $GUI_DISABLE) ; Disable Main Icon.
				_Manage_GUI($mINI, $Global_GUI_1) ; Open Manage GUI.
				_Refresh() ; Refresh The Main GUI & TrayMenu, Including Translation Strings & ContextMenu.
				GUICtrlSetState($Global_Icon_1, $GUI_ENABLE) ; Enable Main Icon.

			Case $Global_ContextMenu[13][0]
				GUICtrlSetState($Global_Icon_1, $GUI_DISABLE)
				$mProfileList = _Customize_GUI($Global_GUI_1, $mProfileList) ; Open Customize GUI.
				_Refresh(1) ; Refresh The Main GUI Icon & TrayMenu, Including Translation Strings & ContextMenu.
				GUICtrlSetState($Global_Icon_1, $GUI_ENABLE)

			Case $Global_ContextMenu[5][0]
				GUICtrlSetState($Global_Icon_1, $GUI_DISABLE)
				_Options($Global_GUI_1) ; Open Options
				_Refresh() ; Refresh The Main GUI & TrayMenu, Including Translation Strings & ContextMenu.
				GUICtrlSetState($Global_Icon_1, $GUI_ENABLE)

			Case $Global_ContextMenu[6][0]
				_TrayMenu_Show() ; Show The TrayMenu.

			Case $Global_ContextMenu[10][0]
				If FileExists(@ScriptDir & "\Readme.txt") Then ShellExecute(@ScriptDir & "\Readme.txt")

			Case $Global_ContextMenu[11][0]
				If FileExists(@ScriptDir & "\Help.chm") Then ShellExecute(@ScriptDir & "\Help.chm")

			Case $Global_ContextMenu[12][0]
				_About()

			Case Else
				If $mMsg >= $Global_ContextMenu[14][0] And $mMsg <= $Global_ContextMenu[$Global_ContextMenu[0][0]][0] Then
					For $A = 14 To $Global_ContextMenu[0][0]
						If $mMsg = $Global_ContextMenu[$A][0] Then
							__Log_Write(__Lang_Get('MAIN_TIP_1', 'Changed Profile To'), $Global_ContextMenu[$A][1])
							__SetCurrentProfile($Global_ContextMenu[$A][1]) ; Write Selected Profile Name To The Settings INI File.
							ExitLoop
						EndIf
					Next
					__SetCurrentPosition() ; Set Current Coordinates/Position Of DropIt.
					_Refresh(1)
				EndIf

		EndSwitch
	WEnd
EndFunc   ;==>_Main

Func _Main_Create()
	Local $rGUI_1 = $Global_GUI_1
	Local $rGUI_2 = $Global_GUI_2
	Local $rIcon_1 = $Global_Icon_1

	Local $rProfile = __IsProfile(-1, 0) ; Get Array Of Current Profile.
	Local $rPosition = __GetCurrentPosition() ; Get Current Coordinates/Position Of DropIt.

	$rGUI_1 = GUICreate("DropIt", $rProfile[5], $rProfile[6] + 100, $rPosition[0], $rPosition[1], $WS_POPUP, BitOR($WS_EX_ACCEPTFILES, $WS_EX_LAYERED, $WS_EX_TOOLWINDOW, $WS_EX_TOPMOST))
	$Global_GUI_1 = $rGUI_1
	__SetHandle($UniqueID) ; Set Window Title For WM_COPYDATA.
	GUISetHelp("hh.exe " & @ScriptDir & "\Help.chm", $rGUI_1) ; F1 HelpFile.
	If $rProfile[7] < 10 Then
		$rProfile[7] = 100
		_Image_Write(-1, 4, -1, -1, -1, $rProfile[7]) ; Write Transparency To The Current Profile.
	EndIf
	__SetBitmap($rGUI_1, $rProfile[3], 255 / 100 * $rProfile[7], $rProfile[5], $rProfile[6]) ; Set Image & Resize To The GUI.
	__GUIInBounds($rGUI_1) ; Checks If The GUI Is Within View Of The Users Screen.

	_ContextMenu_Create($rIcon_1) ; Create The ContextMenu.

	$rGUI_2 = GUICreate("", 16, 16, $rProfile[5] / 5, $rProfile[6] / 5, $WS_POPUP, BitOR($WS_EX_MDICHILD, $WS_EX_LAYERED, $WS_EX_TOPMOST), $rGUI_1)
	$Global_GUI_2 = $rGUI_2

	GUISetBkColor(0x000001)
	_WinAPI_SetLayeredWindowAttributes($rGUI_2, 0x00000001, 0x00, 1, 0)
	Local $rLabelIconImage = GUICtrlCreateLabel("", 0, 0, 16, 16)
	_ResourceSetImageToCtrl($rLabelIconImage, "ZZ")

	GUISetState(@SW_SHOW, $rGUI_1)
	GUISetState(@SW_HIDE, $rGUI_2)
	_Refresh()
	Return 1
EndFunc   ;==>_Main_Create

Func _Refresh($rImage = 0)
	If $rImage = 1 Then
		Local $rGUI_1 = $Global_GUI_1
		Local $rProfile = __IsProfile(-1, 0) ; Get Array Of Current Profile.
		Local $rWinGetPos = WinGetPos($rGUI_1)
		WinMove($rGUI_1, "", $rWinGetPos[0], $rWinGetPos[1], $rProfile[5], $rProfile[6] + 100)
		__SetBitmap($rGUI_1, $rProfile[3], 255 / 100 * $rProfile[7], $rProfile[5], $rProfile[6]) ; Set Image & Resize To The GUI.
	EndIf
	_ContextMenu_Create() ; Create A ContextMenu.
	_TrayMenu_Create() ; Create A Hidden TrayMenu.
	If __Is("CustomTrayIcon") Then __Tray_SetIcon(__IsProfile(-1, 2))
	If __Is("UseSendTo") Then
		__SendTo_Uninstall() ; Delete SendTo Shortcuts.
		__SendTo_Install() ; Create SendTo Shortcuts.
	EndIf
	GUIRegisterMsg(0x0111, "WM_LBUTTONDBLCLK")
	Return 1
EndFunc   ;==>_Refresh

Func _ContextMenu_Create($cHandle = $Global_Icon_1)
	Local $cContextMenu = _ContextMenu_Delete($cHandle) ; Delete The Current ContextMenu Items.

	$cHandle = $Global_Icon_1
	Local $cProfileList = __ProfileList() ; Get Array Of All Profiles.
	$cContextMenu[1][0] = GUICtrlCreateContextMenu($cHandle)
	$cContextMenu[2][0] = GUICtrlCreateMenuItem(__Lang_Get('PATTERNS', 'Patterns'), $cContextMenu[1][0], 0)
	$cContextMenu[3][0] = GUICtrlCreateMenuItem("", $cContextMenu[1][0], 1)
	$cContextMenu[4][0] = GUICtrlCreateMenu(__Lang_Get('PROFILES', 'Profiles'), $cContextMenu[1][0], 2)
	$cContextMenu[5][0] = GUICtrlCreateMenuItem(__Lang_Get('OPTIONS', 'Options'), $cContextMenu[1][0], 3)
	$cContextMenu[6][0] = GUICtrlCreateMenuItem(__Lang_Get('HIDE', 'Hide'), $cContextMenu[1][0], 4)
	$cContextMenu[7][0] = GUICtrlCreateMenu(__Lang_Get('HELP', 'Help'), $cContextMenu[1][0], 5)
	$cContextMenu[8][0] = GUICtrlCreateMenuItem("", $cContextMenu[1][0], 6)
	$cContextMenu[9][0] = GUICtrlCreateMenuItem(__Lang_Get('EXIT', 'Exit'), $cContextMenu[1][0], 7)

	$cContextMenu[10][0] = GUICtrlCreateMenuItem(__Lang_Get('README', 'Readme'), $cContextMenu[7][0])
	$cContextMenu[10][1] = 'README'
	$cContextMenu[11][0] = GUICtrlCreateMenuItem(__Lang_Get('HELP', 'Help'), $cContextMenu[7][0])
	$cContextMenu[11][1] = 'HELP'
	$cContextMenu[12][0] = GUICtrlCreateMenuItem(__Lang_Get('ABOUT', 'About') & "...", $cContextMenu[7][0])
	$cContextMenu[12][1] = 'ABOUT'

	$cContextMenu[13][0] = GUICtrlCreateMenuItem(__Lang_Get('CUSTOMIZE', 'Customize'), $cContextMenu[4][0])
	$cContextMenu[14][0] = GUICtrlCreateMenuItem("", $cContextMenu[4][0])

	Local $B = $cContextMenu[0][0] + 1
	For $A = 1 To $cProfileList[0]
		If UBound($cContextMenu, 1) <= $cContextMenu[0][0] + 1 Then ReDim $cContextMenu[UBound($cContextMenu, 1) * 2][$cContextMenu[0][1]] ; ReDim's $cContextMenu If More Items Are Required.
		$cContextMenu[$B][0] = GUICtrlCreateMenuItem($cProfileList[$A], $cContextMenu[4][0], $A + 1, 1)
		__SetItemImage(__IsProfile($cProfileList[$A], 2), $A + 1, $cContextMenu[4][0], 1)
		$cContextMenu[$B][1] = $cProfileList[$A]
		If $cProfileList[$A] = __GetCurrentProfile() Then GUICtrlSetState($cContextMenu[$B][0], 1) ; __GetCurrentProfile = Get Current Profile From The Settings INI File.
		$cContextMenu[0][0] += 1
		$B += 1
	Next

	ReDim $cContextMenu[$cContextMenu[0][0] + 1][$cContextMenu[0][1]] ; Delete Empty Rows.
	$Global_ContextMenu = $cContextMenu

	If Not @error Then Return 1
	Return SetError(1, 1, 0)
EndFunc   ;==>_ContextMenu_Create

Func _ContextMenu_Delete($cHandle)
	Local $cGUI_1 = $Global_GUI_1
	Local $cControlGetPos = ControlGetPos($cGUI_1, "", $cHandle)

	If @error Then Local $cControlGetPos[2] = [0, 0, 64, 64]
	GUICtrlDelete($cHandle)
	GUISwitch($cGUI_1)
	$cHandle = GUICtrlCreateLabel("", 0, 0, $cControlGetPos[2], $cControlGetPos[3], $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
	$Global_Icon_1 = $cHandle
	GUICtrlSetState($cHandle, $GUI_DROPACCEPTED)
	GUICtrlSetTip($cHandle, "DropIt - " & __Lang_Get('TITLE_TOOLTIP', 'Sort your files with a drop!'))
	_WinAPI_SetFocus(GUICtrlGetHandle($cHandle)) ; Sets The $Global_Icon_1 Label As Having Focus, Used For The HotKeys.
	Local $cContextMenu = $Global_ContextMenu
	Local $cReturn_ContextMenu[$cContextMenu[0][0] + 1][$cContextMenu[0][1]] = [[$cContextMenu[0][0], $cContextMenu[0][1]]]
	Return $cReturn_ContextMenu
EndFunc   ;==>_ContextMenu_Delete

Func _About($aHandle = -1)
	Local $aGUI, $aIcon_GUI, $aIcon_Label, $aUpdateText, $aUpdateProgress, $aUpdate, $aLicense, $aClose

	$aGUI = GUICreate(__Lang_Get('ABOUT', 'About'), 400, 155, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($aHandle))
	GUICtrlCreateLabel("DropIt", 80, 10, 310, 25)
	GUICtrlSetFont(-1, 18)
	GUICtrlCreateLabel("(v" & $Global_CurrentVersion & ")", 80, 40, 310, 17)
	GUICtrlCreateLabel("", 80, 60, 310, 1) ; Single Line.
	GUICtrlSetBkColor(-1, 0x000000)
	GUICtrlCreateLabel(__Lang_Get('MAIN_TIP_0', 'Software developed by %Team%.  @LF  Released under %License%.'), 80, 70, 310, 45)

	$aUpdateText = GUICtrlCreateLabel('', 80, 101, 310, 18)
	If StringLeft(FileGetVersion(@SystemDir & "\WinVer.exe"), 3) < 6.0 Then
		$aUpdateProgress = GUICtrlCreateProgress(200, 16, 190, 14, 0x01)
		GUICtrlSetState($aUpdateProgress, $GUI_HIDE)
	Else
		$aUpdateProgress = GUICtrlCreatePic('', 200, 16, 190, 14)
	EndIf

	$aUpdate = GUICtrlCreateButton(__Lang_Get('CHECK_UPDATE', 'Check Update'), 10, 120, 120, 25)
	$aLicense = GUICtrlCreateButton("&" & __Lang_Get('LICENSE', 'License'), 250, 120, 65, 25)
	If Not FileExists(@ScriptDir & "\License.txt") Then GUICtrlSetState($aLicense, $GUI_HIDE)
	$aClose = GUICtrlCreateButton("&" & __Lang_Get('CLOSE', 'Close'), 325, 120, 65, 25)
	GUICtrlSetState($aClose, 576)

	$aIcon_GUI = GUICreate("", 64, 64, 10, 10, $WS_POPUP, BitOR($WS_EX_MDICHILD, $WS_EX_LAYERED, $WS_EX_TOPMOST), $aGUI)
	GUISetBkColor(0x000001)
	_WinAPI_SetLayeredWindowAttributes($aIcon_GUI, 0x00000001, 0x00, 1, 0)
	$aIcon_Label = GUICtrlCreateLabel("", 0, 0, 64, 64)
	_ResourceSetImageToCtrl($aIcon_Label, "IMAGE")
	GUICtrlSetTip($aIcon_Label, __Lang_Get('VISIT_WEBSITE', 'Visit Website'))
	GUICtrlSetCursor($aIcon_Label, 0)

	GUISetState(@SW_SHOW, $aIcon_GUI)
	GUISetState(@SW_SHOW, $aGUI)

	While 1
		Switch GUIGetMsg()
			Case -3, $aClose
				ExitLoop

			Case $aLicense
				If FileExists(@ScriptDir & "\License.txt") Then
					ShellExecute(@ScriptDir & "\License.txt")
					Sleep(300)
					WinSetOnTop("License", "", 1)
				EndIf

			Case $aUpdate
				_Update_Check($aUpdateText, $aUpdateProgress, $aUpdate)

			Case $aIcon_Label
				ShellExecute(_WinAPI_ExpandEnvironmentStrings("%URL%"))

		EndSwitch
	WEnd

	GUIDelete($aGUI)

	__SetCurrentPosition() ; Set Current Coordinates/Position Of DropIt.
	__IsOnTop() ; Set GUI "OnTop" If True.

	If Not @error Then Return 1
	Return SetError(1, 1, 0)
EndFunc   ;==>_About

Func _Update_Batch($uFromDirectory, $uSleepTime = 2)
	Local $uData = ':DropIt_Update.bat', $uXCOPY, $uSleep, $uCmd
	Local $uFile = @ScriptDir & "\DropIt_Update.bat"
	Local $uArray[8][3] = [ _
			[7, 3], _
			[$uFromDirectory & @ScriptName, @ScriptDir & "\", "M"], _
			[$uFromDirectory & "Help.chm", @ScriptDir & "\", "M"], _
			[$uFromDirectory & "License.txt", @ScriptDir & "\", "M"], _
			[$uFromDirectory & "Readme.txt", @ScriptDir & "\", "M"], _
			[$uFromDirectory & "Images\*", __GetDefault(1) & "Images\", "M"], _
			[$uFromDirectory & "Languages\*", @ScriptDir & "\" & "Languages\", "M"], _
			[$uFromDirectory & "Lib\*", @ScriptDir & "\" & "Lib\", "M"]]

	For $A = 1 To $uSleepTime
		$uSleep &= @CRLF & '@Ping.exe localhost -N 1 >NUL'
	Next
	For $A = 1 To $uArray[0][0]
		Switch $uArray[$A][2]
			Case "C", "M" ; ["C:\Program Files\DropIt\DropIt.exe", ""C:\Program Files\DropIt\New\", "M"]
				$uCmd = " /Y"
				If __IsFolder($uArray[$A][0]) Then $uCmd = " /I /S /Y"
				$uXCOPY &= @CRLF & 'XCOPY "' & $uArray[$A][0] & '" "' & $uArray[$A][1] & '"' & $uCmd

			Case "D" ; ["C:\Program Files\DropIt\DropIt.exe", "", "D"]
				$uXCOPY &= @CRLF & 'DEL "' & $uArray[$A][0] & '" /Q'

			Case "R" ; ["C:\Program Files\DropIt\DropIt.exe", "DropIt_New.exe", "R"]
				$uXCOPY &= @CRLF & 'REN "' & $uArray[$A][0] & '" "' & $uArray[$A][1] & '"'

		EndSwitch
	Next

	$uData &= $uSleep
	$uData &= $uXCOPY
	$uData &= @CRLF & 'RD /S /Q "' & @ScriptDir & '\ZIP\"' & @CRLF & 'START ' & @ScriptName & '' & @CRLF & 'GOTO End' & @CRLF & @CRLF & ':End' & @CRLF & 'DEL .\DropIt_Update.bat'

	$uFile = FileOpen($uFile, 2)
	FileWrite($uFile, $uData)
	FileClose($uFile)
EndFunc   ;==>_Update_Batch

Func _Update_Check($uHandle = -1, $aProgress = -1, $uCancel = -1)
	If __Is("Update", -1, "False") Then
		MsgBox(0, __Lang_Get('UPDATE_MSGBOX_0', 'Successfully Updated'), __Lang_Get('UPDATE_MSGBOX_1', 'New version %VersionNo% is now ready to be used.'), 10, __OnTop())
		IniDelete(__IsSettingsFile(), "General", "Update")
		Return 1
	EndIf
	If $uHandle = -1 Then Return SetError(1, 1, 0)

	Local $uMsgBox, $uDownload, $uVersion, $uPage, $uCancelled = 0, $uBefore = ">DropIt Installer ", $uAfter = "<"
	Local $uSize, $uPercent, $uDownloaded, $uText, $uDownloadURL, $uDownloadFile, $uTimerBegin, $uPackage = "Portable.zip"

	; Load System Proxy Settings
	HttpSetProxy(0)

	; Load Web Page
	$uPage = BinaryToString(InetRead(_WinAPI_ExpandEnvironmentStrings("%URL%"), 17))

	If @error Then
		MsgBox(0x30, __Lang_Get('UPDATE_MSGBOX_2', 'Check Failed'), __Lang_Get('UPDATE_MSGBOX_3', 'An error occurs during check for updates.'), 10, __OnTop())
		Return SetError(1, 1, 0)
	EndIf

	; Extract Last Version Available From Web Page
	$uBefore = StringInStr($uPage, $uBefore) + StringLen($uBefore)
	$uAfter = StringInStr(StringTrimLeft($uPage, $uBefore), $uAfter)
	$uVersion = StringStripWS(StringMid($uPage, $uBefore, $uAfter), 3)

	If @error Or $uVersion == "" Then
		GUICtrlSetData($uHandle, __Lang_Get('UPDATE_MSGBOX_3', 'An error occurs during check for updates.'))
		Return SetError(1, 1, 0)
	EndIf

	If $uVersion == $Global_CurrentVersion Then ; Check If Current And Online Versions Are The Same Or Not.
		GUICtrlSetData($uHandle, __Lang_Get('UPDATE_MSGBOX_4', 'You have the latest release available.'))
	Else
		; Extract Download URL From Web Page
		$uBefore = '<!--<update>'
		$uAfter = '</update>-->'
		$uBefore = StringInStr($uPage, $uBefore) + StringLen($uBefore)
		$uAfter = StringInStr(StringTrimLeft($uPage, $uBefore), $uAfter)
		$uDownloadURL = StringStripWS(StringMid($uPage, $uBefore, $uAfter), 3)

		$uMsgBox = MsgBox(0x04, __Lang_Get('UPDATE_MSGBOX_5', 'Update Available!'), StringReplace(__Lang_Get('UPDATE_MSGBOX_6', 'New version %NewVersion% of DropIt is available.  @LF  Do you want to update it now?'), '%NewVersion%', $uVersion), 0, __OnTop())
		If $uMsgBox <> 6 Then Return SetError(1, 1, 0)
		Local $uCancelRead = GUICtrlRead($uCancel)
		GUICtrlSetData($uCancel, "&" & __Lang_Get('CANCEL', 'Cancel'))
		$uDownloadFile = @ScriptDir & "\" & "DropIt_v" & StringReplace($uVersion, " ", "_") & "_" & $uPackage

		$uTimerBegin = TimerInit() ; Start Timer To Check How Long It Takes To Download.
		GUICtrlSetData($uHandle, "Calculating size for v" & $uVersion)
		$uSize = InetGetSize($uDownloadURL, 1) ; Get Download Size.
		$uDownload = InetGet($uDownloadURL, $uDownloadFile, 17, 1) ; Start Download.
		While Not InetGetInfo($uDownload, 2) ; Whilst Complete Is False.
			$uPercent = InetGetInfo($uDownload, 0) * 100 / $uSize ; Percentage Of Downloaded File.
			$uDownloaded = InetGetInfo($uDownload, 0) ; Bytes Downloaded So Far.
			$uText = Round($uPercent, 0) & "% Downloading " & __ByteSuffix($uDownloaded) & " of " & __ByteSuffix($uSize) ; Create A Text String.
			__SetProgress($aProgress, $uPercent, 3)
			If GUICtrlRead($uHandle) <> $uText Then GUICtrlSetData($uHandle, $uText)
			GUICtrlSetData($uHandle, $uText)

			If InetGetInfo($uDownload, 4) <> 0 Then
				InetClose($uDownload)
				FileDelete($uDownloadFile)
				GUICtrlSetData($uHandle, __Lang_Get('UPDATE_MSGBOX_7', 'An error occured during software download.'))
				Return SetError(1, 1, 0)
			EndIf

			Switch GUIGetMsg()
				Case -3, $uCancel
					$uCancelled = 1
					InetClose($uDownload)
					ExitLoop
			EndSwitch

			Sleep(105) ; Needed To Avoid Flickering!
		WEnd
		InetClose($uDownload)
		GUICtrlSetData($uCancel, $uCancelRead)

		If FileGetSize($uDownloadFile) = $uSize And $uCancelled = 0 Then ; Check If Download FileSize Is The Same As On The Server.
			__SetProgress($aProgress, 100, 3)
			GUICtrlSetData($uHandle, "100% Downloaded in " & __TimeSuffix(TimerDiff($uTimerBegin)))
		ElseIf $uCancelled = 1 Then
			__SetProgress($aProgress, 100, 3)
			GUICtrlSetData($uHandle, __Lang_Get('UPDATE_MSGBOX_7', 'An error occured during software download.'))
			If FileExists($uDownloadFile) Then FileDelete($uDownloadFile)
			Return SetError(1, 1, 0)
		EndIf

		__7ZipRun($uDownloadFile, __GetDefault(1) & "ZIP", 1, 0) ; __GetDefault(1) = Get The Default Settings Directory.
		If FileExists($uDownloadFile) Then FileDelete($uDownloadFile)
		_Update_Batch(@ScriptDir & "\" & "ZIP" & "\" & "DropIt_v" & StringReplace($uVersion, " ", "_") & "_" & StringTrimRight($uPackage, 4) & "\")
		IniWrite(__IsSettingsFile(), "General", "Update", "True")
		Run(@ScriptDir & "\" & "DropIt_Update.bat", @ScriptDir, @SW_HIDE)
		Exit
	EndIf

	If Not @error Then Return 1
	Return SetError(1, 1, 0)
EndFunc   ;==>_Update_Check

Func _Options($oHandle = -1)
	Local $oINI = __IsSettingsFile() ; Get Default Settings INI File.

	Local $oCheckItems[18] = [17], $oRadioItems[6] = [5], $oComboItems[5] = [4], $oGroup[5] = [4], $oCurrent[5] = [4]
	Local $oINI_TrueOrFalse_Array[18][3] = [ _
			[17, 3], _
			["General", "OnTop", 1], _
			["General", "LockPosition", 1], _
			["General", "MultipleInstances", 1], _
			["General", "UseSendTo", 1], _
			["General", "CreateLog", 1], _
			["General", "DirForFolders", 1], _
			["General", "IgnoreNew", 1], _
			["General", "AutoDup", 1], _
			["General", "ArchiveSelf", 1], _
			["General", "ArchiveEncrypt", 1], _
			["General", "ShowSorting", 1], _
			["General", "ProfileEncryption", 1], _
			["General", "CustomTrayIcon", 1], _
			["General", "StartAtStartup", 1], _
			["General", "IntegrityCheck", 1], _
			["General", "SafetyErase", 1], _
			["General", "SizeMessage", 1]]
	Local $oINI_Various_Array[9][3] = [ _
			[8, 3], _
			["General", "SendToMode", 2], _
			["General", "DupMode", 3], _
			["General", "ArchiveFormat", 2], _
			["General", "ArchiveLevel", 5], _
			["General", "ArchiveMethod", 4], _
			["General", "ArchiveEncryptMethod", 2], _
			["General", "ArchivePassword", 1], _
			["General", "MasterPassword", 1]]

	Local $oPW, $oPW_Code = $Global_Password_Key
	Local $oBackupDirectory = __GetDefault(32) ; Get Default Backup Directory.
	Local $oLogFile = __GetDefault(513) ; Get Default Directory & LogFile File Name.
	Local $oGUI, $oCreateTab, $oLog, $oWriteLog, $oBackup, $oRestore, $oRemove, $oState, $oPassword, $oShowPassword, $oMasterPassword, $oShowMasterPassword
	Local $oTab_1, $oTab_3, $oTab_4, $oOK, $oCancel, $oMsgBox, $oLanguage, $oLanguageCombo, $oImageList

	$oGUI = GUICreate(__Lang_Get('OPTIONS', 'Options'), 300, 330, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($oHandle))

	$oCreateTab = GUICtrlCreateTab(4, 3, 293, 290) ; Create Tab Menu.

	; Main Tab
	$oTab_1 = GUICtrlCreateTabItem(__Lang_Get('OPTIONS_TAB_0', 'Main'))
	GUICtrlSetState(-1, $GUI_SHOW) ; Show This Tab At Options Opening.

	; Group Of General Options
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_0', 'General'), 10, 30, 279, 85)
	$oCheckItems[1] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_0', 'Show target image always on top'), 25, 30 + 15)
	$oCheckItems[2] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_7', 'Lock target image position'), 25, 30 + 15 + 20)
	$oCheckItems[13] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_13', 'Use profile icon in traybar'), 25, 30 + 15 + 40)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Group Of Usage Options
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_3', 'Usage'), 10, 120, 279, 105)
	$oCheckItems[3] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_8', 'Enable multiple instances'), 25, 120 + 15)
	$oCheckItems[14] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_14', 'Start DropIt on system startup'), 25, 120 + 15 + 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_3', 'Note that this is a not portable feature.'))
	$oCheckItems[4] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_6', 'Integrate DropIt in SendTo menu'), 25, 120 + 15 + 40)
	$oRadioItems[1] = GUICtrlCreateRadio(__Lang_Get('OPTIONS_MODE_5', 'Permanent'), 25 + 25, 120 + 15 + 40 + 22, 90, 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_0', 'The integration remains also when DropIt is closed.'))
	$oRadioItems[2] = GUICtrlCreateRadio(__Lang_Get('OPTIONS_MODE_6', 'Portable'), 25 + 145, 120 + 15 + 40 + 22, 90, 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_1', 'The integration is created at DropIt startup and removed at the end.'))
	GUICtrlCreateGroup('', -99, -99, 1, 1)

	; Group Of Language Options
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_1', 'Language'), 10, 230, 279, 50)
	$oLanguageCombo = _GUICtrlComboBoxEx_Create($oGUI, "", 25, 230 + 15 + 3, 250, 200, 0x0003)
	$oImageList = _GUIImageList_Create(16, 16, 5, 3) ; Creates An ImageList.
	_GUICtrlComboBoxEx_SetImageList($oLanguageCombo, $oImageList)
	$Global_ImageList = $oImageList
	__Lang_Combo($oLanguageCombo)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Sorting Tab
	GUICtrlCreateTabItem(__Lang_Get('OPTIONS_TAB_1', 'Sorting'))

	; Group Of Association Options
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_0', 'General'), 10, 30, 279, 105)
	$oCheckItems[11] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_11', 'Show progress bar during process'), 25, 30 + 15)
	$oCheckItems[6] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_2', 'Enable association also for folders'), 25, 30 + 15 + 20)
	$oCheckItems[17] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_16', 'Enable alert for large processed files'), 25, 30 + 15 + 40)
	$oCheckItems[7] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_3', 'Ignore unassociated files/folders'), 25, 30 + 15 + 60)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Group Of Duplicates Options
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_5', 'Manage Duplicates'), 10, 140, 279, 65)
	$oCheckItems[8] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_5', 'Use automatic choice for duplicates'), 25, 140 + 15)
	$oRadioItems[3] = GUICtrlCreateRadio(__Lang_Get('OPTIONS_MODE_2', 'Overwrite'), 25, 140 + 15 + 22, 90, 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_MODE_2', 'Overwrite'))
	$oRadioItems[4] = GUICtrlCreateRadio(__Lang_Get('OPTIONS_MODE_3', 'Skip'), 25 + 92, 140 + 15 + 22, 80, 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_MODE_3', 'Skip'))
	$oRadioItems[5] = GUICtrlCreateRadio(__Lang_Get('OPTIONS_MODE_4', 'Rename'), 25 + 174, 140 + 15 + 22, 80, 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_MODE_4', 'Rename'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Group Of Log Options
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_7', 'Sorting Log'), 10, 210, 279, 50)
	$oCheckItems[5] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_1', 'Create sorting log file'), 25, 210 + 15 + 3)
	$oLog = GUICtrlCreateButton(__Lang_Get('OPTIONS_BUTTON_0', 'Read'), 25 + 177, 210 + 15 + 2, 73, 22)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Compression Tab
	$oTab_3 = GUICtrlCreateTabItem(__Lang_Get('OPTIONS_TAB_2', 'Compression'))

	; Group Of Settings Options
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_8', 'Modality'), 10, 30, 279, 135)
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_10', 'Format') & ":", 25, 30 + 15 + 6, 90, 20)
	$oComboItems[1] = GUICtrlCreateCombo("", 25 + 100, 30 + 15 + 3, 150, 20, 0x0003)
	GUICtrlSetData(-1, "", "")
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_11', 'Level') & ":", 25, 30 + 15 + 30 + 6, 90, 20)
	$oComboItems[2] = GUICtrlCreateCombo("", 25 + 100, 30 + 15 + 30 + 3, 150, 20, 0x0003)
	GUICtrlSetData(-1, "", "")
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_12', 'Method') & ":", 25, 30 + 15 + 60 + 6, 90, 20)
	$oComboItems[3] = GUICtrlCreateCombo("", 25 + 100, 30 + 15 + 60 + 3, 150, 20, 0x0003)
	GUICtrlSetData(-1, "", "")
	$oCheckItems[9] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_9', 'Create self-extracting archives'), 25, 30 + 15 + 90)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Group Of Extra Options
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_9', 'Encryption'), 10, 170, 279, 110)
	$oCheckItems[10] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_10', 'Encrypt compressed files/folders'), 25, 170 + 15 + 3)
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_13', 'Password') & ":", 25, 170 + 15 + 30 + 3, 90, 20)
	$oPassword = GUICtrlCreateInput("", 25 + 100, 170 + 15 + 30, 138, 20, 0x0020)
	$oShowPassword = GUICtrlCreateButton("", 25 + 100 + 138, 170 + 15 + 30, 12, 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_2', 'Show/Hide the password.'))
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_12', 'Method') & ":", 25, 170 + 15 + 60 + 3, 90, 20)
	$oComboItems[4] = GUICtrlCreateCombo("", 25 + 100, 170 + 15 + 60, 150, 20, 0x0003)
	GUICtrlSetData(-1, "", "")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Various Tab
	$oTab_4 = GUICtrlCreateTabItem(__Lang_Get('OPTIONS_TAB_3', 'Various'))

	; Group Of General Options
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_14', 'Security'), 10, 30, 279, 115)
	$oCheckItems[15] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_4', 'Check processed files integrity'), 25, 30 + 15)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_4', 'The activation of MD5 checking slows down sorting processes.'))
	$oCheckItems[16] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_15', 'Safety erase deleted files/folders'), 25, 30 + 15 + 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_5', 'Wipe files/folders removed with Delete action.'))
	$oCheckItems[12] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_12', 'Encrypt profiles at software closing'), 25, 30 + 15 + 40)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_6', 'Password will be requested at software startup.'))
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_13', 'Password') & ":", 25, 30 + 15 + 40 + 30, 90, 20)
	$oMasterPassword = GUICtrlCreateInput("", 25 + 100, 30 + 15 + 40 + 27, 138, 20, 0x0020)
	$oShowMasterPassword = GUICtrlCreateButton("", 25 + 100 + 138, 30 + 15 + 40 + 27, 12, 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_2', 'Show/Hide the password.'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Group Of Backup Options
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_2', 'Settings Backup'), 10, 150, 279, 50)
	$oBackup = GUICtrlCreateButton(__Lang_Get('OPTIONS_BUTTON_1', 'Backup'), 25, 150 + 15 + 3, 73, 22)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_BUTTON_1', 'Backup'))
	$oRestore = GUICtrlCreateButton(__Lang_Get('OPTIONS_BUTTON_2', 'Restore'), 25 + 88, 150 + 15 + 3, 73, 22)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_BUTTON_2', 'Restore'))
	$oRemove = GUICtrlCreateButton(__Lang_Get('OPTIONS_BUTTON_3', 'Remove'), 25 + 177, 150 + 15 + 3, 73, 22)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_BUTTON_3', 'Remove'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateTabItem("") ; Close Tab Menu.

	; Checkbox Settings
	For $A = 1 To $oINI_TrueOrFalse_Array[0][0]
		If $oINI_TrueOrFalse_Array[$A][0] = "" Or $oINI_TrueOrFalse_Array[$A][1] = "" Then ContinueLoop
		If __Is($oINI_TrueOrFalse_Array[$A][1], $oINI) Then GUICtrlSetState($oCheckItems[$A], $GUI_CHECKED)
	Next

	; Combo Settings
	$oGroup[1] = "7Z|ZIP"
	$oCurrent[1] = IniRead($oINI, "General", "ArchiveFormat", "ZIP")
	$oGroup[2] = "Fastest|Fast|Normal|Maximum|Ultra"
	$oCurrent[2] = IniRead($oINI, "General", "ArchiveLevel", "Normal")
	$oGroup[3] = "LZMA|LZMA2|PPMd|BZip2"
	If $oCurrent[1] = "ZIP" Then $oGroup[3] = "Deflate|LZMA|PPMd|BZip2"
	$oCurrent[3] = IniRead($oINI, "General", "ArchiveMethod", "LZMA")
	$oGroup[4] = "AES-256"
	If $oCurrent[1] = "ZIP" Then $oGroup[4] = "ZipCrypto|AES-256"
	$oCurrent[4] = IniRead($oINI, "General", "ArchiveEncryptMethod", "AES-256")
	For $A = 1 To 4
		GUICtrlSetData($oComboItems[$A], $oGroup[$A], $oCurrent[$A])
	Next

	; Integration Settings
	$oState = $GUI_DISABLE
	If GUICtrlRead($oCheckItems[4]) = 1 Then $oState = $GUI_ENABLE
	For $A = 1 To 2
		GUICtrlSetState($oRadioItems[$A], $oState)
	Next
	If IniRead($oINI, "General", "SendToMode", "Portable") = "Portable" Then
		GUICtrlSetState($oRadioItems[1], $GUI_UNCHECKED)
		GUICtrlSetState($oRadioItems[2], $GUI_CHECKED)
	Else
		GUICtrlSetState($oRadioItems[1], $GUI_CHECKED)
		GUICtrlSetState($oRadioItems[2], $GUI_UNCHECKED)
	EndIf

	; Backup Settings
	For $A = $oBackup To $oRestore ; Disable Buttons If 7-Zip Is Missing.
		If Not FileExists(@ScriptDir & "\Lib\7z\7z.exe") Then GUICtrlSetState($A, $GUI_DISABLE)
	Next
	If Not FileExists(__GetDefault(32)) Then GUICtrlSetState($oRemove, $GUI_DISABLE) ; __GetDefault(32) = Get Default Backup Directory.

	; Duplicate Mode Settings
	$oState = $GUI_DISABLE
	If GUICtrlRead($oCheckItems[8]) = 1 Then $oState = $GUI_ENABLE
	For $A = 3 To 5
		GUICtrlSetState($oRadioItems[$A], $oState)
	Next
	If IniRead($oINI, "General", "DupMode", "Overwrite") = "Overwrite" Then
		GUICtrlSetState($oRadioItems[3], $GUI_CHECKED)
		GUICtrlSetState($oRadioItems[4], $GUI_UNCHECKED)
		GUICtrlSetState($oRadioItems[5], $GUI_UNCHECKED)
	ElseIf IniRead($oINI, "General", "DupMode", "Overwrite") = "Skip" Then
		GUICtrlSetState($oRadioItems[3], $GUI_UNCHECKED)
		GUICtrlSetState($oRadioItems[4], $GUI_CHECKED)
		GUICtrlSetState($oRadioItems[5], $GUI_UNCHECKED)
	Else
		GUICtrlSetState($oRadioItems[3], $GUI_UNCHECKED)
		GUICtrlSetState($oRadioItems[4], $GUI_UNCHECKED)
		GUICtrlSetState($oRadioItems[5], $GUI_CHECKED)
	EndIf

	; Log Settings
	If GUICtrlRead($oCheckItems[5]) = 1 Then
		GUICtrlSetState($oLog, $GUI_ENABLE)
	Else
		GUICtrlSetState($oLog, $GUI_DISABLE)
	EndIf

	; Self-Extracting Settings
	If GUICtrlRead($oComboItems[1]) = "ZIP" Then GUICtrlSetState($oCheckItems[9], $GUI_DISABLE)

	; Encryption Settings
	$oState = $GUI_DISABLE
	If GUICtrlRead($oCheckItems[10]) = 1 Then $oState = $GUI_ENABLE
	GUICtrlSetState($oPassword, $oState)
	GUICtrlSetState($oShowPassword, $oState)
	GUICtrlSetState($oComboItems[4], $oState)
	$oPW = IniRead($oINI, "General", "ArchivePassword", "")
	If $oPW <> "" Then GUICtrlSetData($oPassword, _StringEncrypt(0, $oPW, $oPW_Code))

	; Security Settings
	$oState = $GUI_DISABLE
	If GUICtrlRead($oCheckItems[12]) = 1 Then $oState = $GUI_ENABLE
	GUICtrlSetState($oMasterPassword, $oState)
	GUICtrlSetState($oShowMasterPassword, $oState)
	$oPW = IniRead($oINI, "General", "MasterPassword", "")
	If $oPW <> "" Then GUICtrlSetData($oMasterPassword, _StringEncrypt(0, $oPW, $oPW_Code))

	$oOK = GUICtrlCreateButton("&" & __Lang_Get('OK', 'OK'), 150 - 20 - 76, 298, 76, 25)
	$oCancel = GUICtrlCreateButton("&" & __Lang_Get('CANCEL', 'Cancel'), 150 + 20, 298, 76, 25)
	GUICtrlSetState($oOK, $GUI_FOCUS)
	GUISetState(@SW_SHOW)

	While 1
		__ReduceMemory() ; Reduce Memory Usage Of DropIt.

		; Update Combo If Format Changes
		If GUICtrlRead($oComboItems[1]) <> $oCurrent[1] And Not _GUICtrlComboBox_GetDroppedState($oComboItems[2]) Then
			$oCurrent[1] = GUICtrlRead($oComboItems[1])
			Switch $oCurrent[1]
				Case "7Z"
					$oGroup[3] = "LZMA|LZMA2|PPMd|BZip2"
					$oGroup[4] = "AES-256"
					GUICtrlSetState($oCheckItems[9], $GUI_ENABLE)
				Case "ZIP"
					$oGroup[3] = "Deflate|LZMA|PPMd|BZip2"
					$oGroup[4] = "ZipCrypto|AES-256"
					GUICtrlSetState($oCheckItems[9], 4)
					GUICtrlSetState($oCheckItems[9], $GUI_DISABLE)
			EndSwitch
			$oCurrent[3] = GUICtrlRead($oComboItems[3])
			If Not StringInStr($oGroup[3], $oCurrent[3]) Then $oCurrent[3] = "LZMA"
			$oCurrent[4] = GUICtrlRead($oComboItems[4])
			If Not StringInStr($oGroup[4], $oCurrent[4]) Then $oCurrent[4] = "AES-256"
			For $A = 3 To 4
				_GUICtrlComboBox_ResetContent($oComboItems[$A])
				GUICtrlSetData($oComboItems[$A], $oGroup[$A], $oCurrent[$A])
			Next
		EndIf

		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $oCancel
				SetError(1, 1, 0)
				ExitLoop

			Case $oCreateTab ; Hide Combo When Switching Tabs.
				ControlHide($oLanguageCombo, "", "")
				Switch GUICtrlRead($oCreateTab, 1)
					Case $oTab_1
						ControlShow($oLanguageCombo, "", "")
				EndSwitch

			Case $oCheckItems[4] ; Integration Checkbox.
				$oState = $GUI_DISABLE
				If GUICtrlRead($oCheckItems[4]) = 1 Then $oState = $GUI_ENABLE
				For $A = 1 To 2
					GUICtrlSetState($oRadioItems[$A], $oState)
				Next

			Case $oCheckItems[5] ; Log Checkbox.
				$oState = $GUI_DISABLE
				If GUICtrlRead($oCheckItems[5]) = 1 Then $oState = $GUI_ENABLE
				GUICtrlSetState($oLog, $oState)

			Case $oCheckItems[8] ; Duplicate Mode Checkbox.
				$oState = $GUI_DISABLE
				If GUICtrlRead($oCheckItems[8]) = 1 Then $oState = $GUI_ENABLE
				For $A = 3 To 5
					GUICtrlSetState($oRadioItems[$A], $oState)
				Next

			Case $oCheckItems[10] ; Encryption Checkbox.
				$oState = $GUI_DISABLE
				If GUICtrlRead($oCheckItems[10]) = 1 Then $oState = $GUI_ENABLE
				GUICtrlSetState($oPassword, $oState)
				GUICtrlSetState($oShowPassword, $oState)
				GUICtrlSetState($oComboItems[4], $oState)

			Case $oCheckItems[12] ; Security Checkbox.
				$oState = $GUI_DISABLE
				If GUICtrlRead($oCheckItems[12]) = 1 Then $oState = $GUI_ENABLE
				GUICtrlSetState($oMasterPassword, $oState)
				GUICtrlSetState($oShowMasterPassword, $oState)

			Case $oLog
				If FileExists($oLogFile[1][0] & $oLogFile[2][0]) Then
					ShellExecute($oLogFile[1][0] & $oLogFile[2][0])
				Else
					GUICtrlSetState($oCheckItems[5], 4)
					GUICtrlSetState($oLog, $GUI_DISABLE)
				EndIf

			Case $oBackup
				__Backup_Restore($oGUI, 0) ; Backup The Settings INI File & Profiles.
				If Not @error Then GUICtrlSetState($oRemove, $GUI_ENABLE)

			Case $oRestore
				__Backup_Restore($oGUI, 1) ; Restore A Selected Backup File.
				If Not @error Then ExitLoop

			Case $oRemove
				__Backup_Restore($oGUI, 2) ; Remove Backups In The Default Backup Folder.
				If Not FileExists($oBackupDirectory) Then GUICtrlSetState($oRemove, $GUI_DISABLE)

			Case $oShowPassword
				$oPassword = __ShowPassword($oGUI, $oPassword, $oTab_3)

			Case $oShowMasterPassword
				$oMasterPassword = __ShowPassword($oGUI, $oMasterPassword, $oTab_4)

			Case $oOK
				_GUICtrlComboBoxEx_GetItemText($oLanguageCombo, _GUICtrlComboBoxEx_GetCurSel($oLanguageCombo), $oLanguage)
				__SetCurrentLanguage($oLanguage) ; Sets The Selected Language To The Settings INI File.
				If __Is("UseSendTo", $oINI) And GUICtrlRead($oCheckItems[4]) <> 1 Then __SendTo_Uninstall() ; Delete SendTo Shortcuts If SendTo Is Been Disabled Now.

				If __Is("CreateLog", $oINI) And GUICtrlRead($oCheckItems[5]) <> 1 Then __Log_Write(__Lang_Get('LOG_DISABLED', 'Log Disabled'), __Lang_Get('DATE', 'Date') & " " & @MDAY & "-" & @MON & "-" & @YEAR)
				If Not __Is("CreateLog", $oINI) And GUICtrlRead($oCheckItems[5]) = 1 Then $oWriteLog = 1 ; Needed To Write "Log Enabled" After Log Activation.

				For $A = 1 To $oINI_TrueOrFalse_Array[0][0]
					$oState = "False"
					If $oINI_TrueOrFalse_Array[$A][0] = "" Or $oINI_TrueOrFalse_Array[$A][1] = "" Then ContinueLoop
					If GUICtrlRead($oCheckItems[$A]) = 1 Then $oState = "True"
					IniWrite($oINI, $oINI_TrueOrFalse_Array[$A][0], $oINI_TrueOrFalse_Array[$A][1], $oState)
				Next

				If $oWriteLog = 1 Then __Log_Write(__Lang_Get('LOG_ENABLED', 'Log Enabled'), __Lang_Get('DATE', 'Date') & " " & @MDAY & "-" & @MON & "-" & @YEAR)

				If GUICtrlRead($oCheckItems[14]) = 1 Then
					__StartupFolder_Install("DropIt")
				Else
					__StartupFolder_Uninstall("DropIt")
				EndIf

				$oState = "Permanent"
				If GUICtrlRead($oRadioItems[2]) = 1 Then $oState = "Portable"
				IniWrite($oINI, $oINI_Various_Array[1][0], $oINI_Various_Array[1][1], $oState)

				If GUICtrlRead($oRadioItems[3]) = 1 Then
					$oState = "Overwrite"
				ElseIf GUICtrlRead($oRadioItems[4]) = 1 Then
					$oState = "Skip"
				Else
					$oState = "Rename"
				EndIf
				IniWrite($oINI, $oINI_Various_Array[2][0], $oINI_Various_Array[2][1], $oState)

				IniWrite($oINI, $oINI_Various_Array[3][0], $oINI_Various_Array[3][1], GUICtrlRead($oComboItems[1]))
				IniWrite($oINI, $oINI_Various_Array[4][0], $oINI_Various_Array[4][1], GUICtrlRead($oComboItems[2]))
				IniWrite($oINI, $oINI_Various_Array[5][0], $oINI_Various_Array[5][1], GUICtrlRead($oComboItems[3]))
				IniWrite($oINI, $oINI_Various_Array[6][0], $oINI_Various_Array[6][1], GUICtrlRead($oComboItems[4]))

				$oPW = ""
				If Not StringIsSpace(GUICtrlRead($oPassword)) And GUICtrlRead($oPassword) <> "" Then $oPW = _StringEncrypt(1, GUICtrlRead($oPassword), $oPW_Code)
				IniWrite($oINI, $oINI_Various_Array[7][0], $oINI_Various_Array[7][1], $oPW)
				If $oPW = "" And GUICtrlRead($oCheckItems[10]) = 1 Then
					$oMsgBox = MsgBox(0x04, __Lang_Get('OPTIONS_ENCRYPTION_MSGBOX_0', 'Encryption is enabled'), __Lang_Get('OPTIONS_ENCRYPTION_MSGBOX_1', 'It appears the Password for Encryption is Blank, do you wish to disable?'), 0, __OnTop($oGUI))
					If $oMsgBox = 6 Then
						IniWrite($oINI, $oINI_TrueOrFalse_Array[10][0], $oINI_TrueOrFalse_Array[10][1], "False") ; Disable Encryption If Password Is Blank.
						ExitLoop
					EndIf
					ContinueLoop
				EndIf

				$oPW = ""
				If Not StringIsSpace(GUICtrlRead($oMasterPassword)) And GUICtrlRead($oMasterPassword) <> "" Then $oPW = _StringEncrypt(1, GUICtrlRead($oMasterPassword), $oPW_Code)
				IniWrite($oINI, $oINI_Various_Array[8][0], $oINI_Various_Array[8][1], $oPW)
				If $oPW = "" And GUICtrlRead($oCheckItems[12]) = 1 Then
					$oMsgBox = MsgBox(0x04, __Lang_Get('OPTIONS_ENCRYPTION_MSGBOX_0', 'Encryption is enabled'), __Lang_Get('OPTIONS_ENCRYPTION_MSGBOX_1', 'It appears the Password for Encryption is Blank, do you wish to disable?'), 0, __OnTop($oGUI))
					If $oMsgBox = 6 Then
						IniWrite($oINI, $oINI_TrueOrFalse_Array[12][0], $oINI_TrueOrFalse_Array[12][1], "False") ; Disable Encryption If Password Is Blank.
						ExitLoop
					EndIf
					ContinueLoop
				EndIf
				ExitLoop

		EndSwitch
	WEnd
	GUIDelete($oGUI)
	_GUIImageList_Destroy($oImageList)

	__SetCurrentPosition() ; Set Current Coordinates/Position Of DropIt.
	__IsOnTop() ; Set GUI "OnTop" If True.

	If Not @error Then Return 1
	Return SetError(1, 1, 0)
EndFunc   ;==>_Options

Func _ExitEvent()
	Local $eGUI_1 = $Global_GUI_1
	GUISetState(@SW_HIDE, $eGUI_1)

	Local $eINI = __IsSettingsFile() ; Get Default Settings INI File.

	__SetCurrentPosition() ; Set Current Coordinates/Position Of DropIt.
	If $Global_MultipleInstance Then __SetMultipleInstances("-")
	__Log_Write(__Lang_Get('DROPIT_CLOSED', 'DropIt Closed'), __Lang_Get('DATE', 'Date') & " " & @MDAY & "-" & @MON & "-" & @YEAR)

	If __CheckMultipleInstances() = 0 Then ; Checks The Number Of Multiple Instances.
		If __Is("UseSendTo", $eINI) And IniRead($eINI, "General", "SendToMode", "Portable") = "Portable" Then __SendTo_Uninstall() ; Delete SendTo Shortcuts If In Portable Mode.
		If __Is("ProfileEncryption", $eINI) Then __EncryptionFolder(0) ; Encrypt Profiles.
	EndIf
	_GDIPlus_Shutdown()
	Exit
EndFunc   ;==>_ExitEvent
#Region End >>>>> Main Functions <<<<<

#Region Start >>>>> TrayMenu Functions <<<<<
Func _TrayMenu_Create()
	Local $tTrayMenu = _TrayMenu_Delete() ; Delete The Current TrayMenu Items.

	Local $tProfileList = __ProfileList() ; Get Array Of All Profiles.
	$tTrayMenu[1][0] = TrayCreateItem(__Lang_Get('PATTERNS', 'Patterns'))
	$tTrayMenu[2][0] = TrayCreateItem("")
	$tTrayMenu[3][0] = TrayCreateMenu(__Lang_Get('PROFILES', 'Profiles'))
	$tTrayMenu[4][0] = TrayCreateItem(__Lang_Get('OPTIONS', 'Options'))
	$tTrayMenu[5][0] = TrayCreateItem(__Lang_Get('SHOW', 'Show'))
	$tTrayMenu[6][0] = TrayCreateMenu(__Lang_Get('HELP', 'Help'))
	$tTrayMenu[7][0] = TrayCreateItem("")
	$tTrayMenu[8][0] = TrayCreateItem(__Lang_Get('EXIT', 'Exit'))

	$tTrayMenu[9][0] = TrayCreateItem(__Lang_Get('README', 'Readme'), $tTrayMenu[6][0])
	$tTrayMenu[9][1] = 'README'
	$tTrayMenu[10][0] = TrayCreateItem(__Lang_Get('HELP', 'Help'), $tTrayMenu[6][0])
	$tTrayMenu[10][1] = 'HELP'
	$tTrayMenu[11][0] = TrayCreateItem(__Lang_Get('ABOUT', 'About') & "...", $tTrayMenu[6][0])
	$tTrayMenu[11][1] = 'ABOUT'

	$tTrayMenu[12][0] = TrayCreateItem(__Lang_Get('CUSTOMIZE', 'Customize'), $tTrayMenu[3][0])
	$tTrayMenu[13][0] = TrayCreateItem("", $tTrayMenu[3][0])

	Local $B = $tTrayMenu[0][0] + 1
	For $A = 1 To $tProfileList[0]
		If UBound($tTrayMenu, 1) <= $tTrayMenu[0][0] + 1 Then ReDim $tTrayMenu[UBound($tTrayMenu, 1) * 2][$tTrayMenu[0][1]] ; ReDim's $tTrayMenu If More Items Are Required.
		$tTrayMenu[$B][0] = TrayCreateItem($tProfileList[$A], $tTrayMenu[3][0], $A + 1, 1)
		__SetItemImage(__IsProfile($tProfileList[$A], 2), $A + 1, $tTrayMenu[3][0], 0)
		$tTrayMenu[$B][1] = $tProfileList[$A]
		TrayItemSetOnEvent($tTrayMenu[$B][0], "_ProfileEvent")
		If $tProfileList[$A] = __GetCurrentProfile() Then TrayItemSetState($tTrayMenu[$B][0], 1) ; __GetCurrentProfile = Get Current Profile From The Settings INI File.
		$tTrayMenu[0][0] += 1
		$B += 1
	Next

	TrayItemSetOnEvent($tTrayMenu[1][0], "_ManageEvent")
	TrayItemSetOnEvent($tTrayMenu[4][0], "_OptionsEvent")
	TrayItemSetOnEvent($tTrayMenu[5][0], "_TrayMenu_ShowGUI")
	TrayItemSetOnEvent($tTrayMenu[8][0], "_ExitEvent")
	TrayItemSetOnEvent($tTrayMenu[9][0], "_HelpEvent")
	TrayItemSetOnEvent($tTrayMenu[10][0], "_HelpEvent")
	TrayItemSetOnEvent($tTrayMenu[11][0], "_HelpEvent")
	TrayItemSetOnEvent($tTrayMenu[12][0], "_CustomizeEvent")
	TraySetOnEvent(-13, "_TrayMenu_ShowGUI")

	ReDim $tTrayMenu[$tTrayMenu[0][0] + 1][$tTrayMenu[0][1]] ; Delete Empty Rows.
	$Global_TrayMenu = $tTrayMenu

	If Not @error Then Return 1
	Return SetError(1, 1, 0)
EndFunc   ;==>_TrayMenu_Create

Func _TrayMenu_Delete()
	Local $tTrayMenu = $Global_TrayMenu

	For $A = 1 To $tTrayMenu[0][0]
		TrayItemDelete($tTrayMenu[$A][0])
	Next
	Local $tReturn_TrayMenu[$tTrayMenu[0][0] + 1][$tTrayMenu[0][1]] = [[$tTrayMenu[0][0], $tTrayMenu[0][1]]]
	Return $tReturn_TrayMenu
EndFunc   ;==>_TrayMenu_Delete

Func _TrayMenu_Show()
	Local $sGUI_1 = $Global_GUI_1
	Local $sIcon_1 = GUICtrlGetHandle($Global_Icon_1)
	Local $sToolTip = "DropIt - " & __Lang_Get('TITLE_TOOLTIP', 'Sort your files with a drop!')

	If _WinAPI_GetFocus() <> $sIcon_1 Then Return SetError(1, 1, 0) ; Required Because HotKeys Automatically Minimise The GUI.
	GUISetState(@SW_HIDE, $sGUI_1)
	TraySetState(1)
	TraySetClick(8)
	TraySetToolTip($sToolTip)
	If __Is("CustomTrayIcon") Then __Tray_SetIcon(__IsProfile(-1, 2))

	If Not @error Then Return 1
	Return SetError(1, 1, 0)
EndFunc   ;==>_TrayMenu_Show

Func _TrayMenu_ShowGUI()
	Local $sGUI_1 = $Global_GUI_1
	Local $sIcon_1 = GUICtrlGetHandle($Global_Icon_1)

	If _WinAPI_GetFocus() = $sIcon_1 Then Return SetError(1, 1, 0) ; Required Because HotKeys Automatically Minimise The GUI.
	GUISetState(@SW_SHOW, $sGUI_1)
	TraySetState(2)

	If Not @error Then Return 1
	Return SetError(1, 1, 0)
EndFunc   ;==>_TrayMenu_ShowGUI

Func _CustomizeEvent()
	_Customize_GUI($Global_GUI_1) ; Open Customize GUI.
	_Refresh()

	If Not @error Then Return 1
	Return SetError(1, 1, 0)
EndFunc   ;==>_CustomizeEvent

Func _HelpEvent()
	Local $hTrayMenu = $Global_TrayMenu
	Switch @TRAY_ID
		Case $hTrayMenu[9][0]
			If FileExists(@ScriptDir & "\Readme.txt") Then ShellExecute(@ScriptDir & "\Readme.txt")

		Case $hTrayMenu[10][0]
			If FileExists(@ScriptDir & "\Help.chm") Then ShellExecute(@ScriptDir & "\Help.chm")

		Case $hTrayMenu[11][0]
			_About()

	EndSwitch

	If Not @error Then Return 1
	Return SetError(1, 1, 0)
EndFunc   ;==>_HelpEvent

Func _ManageEvent()
	_Manage_GUI() ; Open Manage GUI.
	_Refresh()

	If Not @error Then Return 1
	Return SetError(1, 1, 0)
EndFunc   ;==>_ManageEvent

Func _OptionsEvent()
	_Options() ; Open Options GUI.
	_Refresh()

	If Not @error Then Return 1
	Return SetError(1, 1, 0)
EndFunc   ;==>_OptionsEvent

Func _ProfileEvent()
	Local $pTrayMenu = $Global_TrayMenu
	For $A = 13 To $pTrayMenu[0][0]
		If @TRAY_ID = $pTrayMenu[$A][0] Then
			__Log_Write(__Lang_Get('MAIN_TIP_1', 'Changed Profile To'), $pTrayMenu[$A][1])
			__SetCurrentProfile($pTrayMenu[$A][1]) ; Write Selected Profile Name To The Settings INI File.
			ExitLoop
		EndIf
	Next
	__SetCurrentPosition() ; Set Current Coordinates/Position Of DropIt.
	_Refresh()

	If Not @error Then Return 1
	Return SetError(1, 1, 0)
EndFunc   ;==>_ProfileEvent
#Region End >>>>> TrayMenu Functions <<<<<

#Region Start >>>>> WM_MESSAGES Functions <<<<<
Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg
	Local $cWndFrom, $cIDFrom, $cCode, $cListViewRules_ComboBox = $Global_ListViewRules_ComboBox
	If Not IsHWnd($cListViewRules_ComboBox) Then $cListViewRules_ComboBox = GUICtrlGetHandle($cListViewRules_ComboBox)
	$cWndFrom = $ilParam
	$cIDFrom = BitAND($iwParam, 0xFFFF)
	$cCode = BitShift($iwParam, 16)
	Switch $cWndFrom
		Case $cListViewRules_ComboBox
			Switch $cCode
				Case $CBN_EDITCHANGE
					$Global_ListViewIndex = -1
					$Global_ListViewRules_ComboBoxChange = 1
					_Manage_Update($Global_ListViewRules, GUICtrlRead($cIDFrom))

				Case $CBN_SELCHANGE
					$Global_ListViewIndex = -1
					$Global_ListViewRules_ComboBoxChange = 1
					_Manage_Update($Global_ListViewRules, GUICtrlRead($cIDFrom))

			EndSwitch
	EndSwitch
	Return "GUI_RUNDEFMSG"
EndFunc   ;==>WM_COMMAND

Func WM_COPYDATA($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $cParm = DllStructCreate("ulong_ptr;dword;ptr", $ilParam)
	Local $TEMPcData = DllStructCreate("wchar[" & DllStructGetData($cParm, 2) / 2 & "]", DllStructGetData($cParm, 3))
	Local $cData = DllStructGetData($TEMPcData, 1)
	Local $cFiles = __CmdLineRaw($cData) ; Convert $CmdLineRaw To $CmdLine (Without The Index Value).
	__CMDLine($cFiles, 1) ; Pass Files As Though They Came From The CommandLine.
	Return 1
EndFunc   ;==>WM_COPYDATA

Func WM_COPYDATA_SENDDATA($sTitleID, $sString)
	Local $sIshWnd = WinWait($sTitleID, "", 5)
	If $sIshWnd Then
		If IsArray($sString) Then
			Local $TEMPsString = ""
			For $A = 1 To $sString[0]
				$TEMPsString &= $sString[$A] & "|"
			Next
			$sString = StringTrimRight($TEMPsString, 1)
		EndIf
		Local $sData = DllStructCreate("wchar[" & StringLen($sString) + 1 & "]")
		DllStructSetData($sData, 1, $sString)

		Local $sParm = DllStructCreate("ulong_ptr;dword;ptr")
		DllStructSetData($sParm, 1, 0)
		DllStructSetData($sParm, 2, DllStructGetSize($sData))
		DllStructSetData($sParm, 3, DllStructGetPtr($sData))
		Local $wm_Return = DllCall("user32.dll", "int", "SendMessageW", "hwnd", $sIshWnd, "uint", 0x004A, "hwnd", 0, "ptr", DllStructGetPtr($sParm))
		If @error Or $wm_Return[0] = -1 Then Return SetError(1, 1, 0)
		If StringLen($sString) > 0 Then Exit
		Return 1
	EndIf
	Return 0
EndFunc   ;==>WM_COPYDATA_SENDDATA

Func WM_DROPFILES_UNICODE($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $ilParam
	Local $dSize, $dFileName
	Local $dReturn = DllCall("shell32.dll", "int", "DragQueryFileW", "hwnd", $iwParam, "int", 0xFFFFFFFF, "ptr", 0, "int", 255)
	For $A = 0 To $dReturn[0] - 1
		$dSize = DllCall("shell32.dll", "int", "DragQueryFileW", "hwnd", $iwParam, "int", $A, "ptr", 0, "int", 0)
		$dSize = $dSize[0] + 1
		$dFileName = DllStructCreate("wchar[" & $dSize & "]")
		DllCall("shell32.dll", "int", "DragQueryFileW", "hwnd", $iwParam, "int", $A, "int", DllStructGetPtr($dFileName), "int", $dSize)
		ReDim $Global_DroppedFiles[$A + 1]
		$Global_DroppedFiles[$A] = DllStructGetData($dFileName, 1)
		$dFileName = 0
	Next
EndFunc   ;==>WM_DROPFILES_UNICODE

Func WM_HSCROLL($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $hSlider = $Global_Slider
	Local $hSliderLabel = $Global_SliderLabel
	Local $hSlider_Handle = GUICtrlGetHandle($hSlider)

	If $ilParam = $hSlider_Handle Then
		Local $hRead = GUICtrlRead($hSlider) & "%"
		GUICtrlSetData($hSliderLabel, $hRead)
	EndIf
	Return "GUI_RUNDEFMSG"
EndFunc   ;==>WM_HSCROLL

Func WM_LBUTTONDBLCLK($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $ilParam
	Local $lCode = BitShift($iwParam, 16)
	Switch $lCode
		Case 0 ; If A Single Click Is Detected.
		Case 1 ; If A Double Click Is Detected.
			_TrayMenu_Show() ; Show The TrayMenu.
	EndSwitch

	Return "GUI_RUNDEFMSG"
EndFunc   ;==>WM_LBUTTONDBLCLK

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $nListViewProfiles = $Global_ListViewProfiles
	Local $nListViewRules = $Global_ListViewRules

	If Not IsHWnd($nListViewProfiles) Then $nListViewProfiles = GUICtrlGetHandle($nListViewProfiles)
	If Not IsHWnd($nListViewRules) Then $nListViewRules = GUICtrlGetHandle($nListViewRules)

	Local $tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	Local $nWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	Local $nCode = DllStructGetData($tNMHDR, "Code")

	Local $nInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
	Local $nIndex = DllStructGetData($nInfo, "Index") ; The 'Row' Number  Selected E.G. Select The 1st Item Will Return 0
	Local $nSubItem = DllStructGetData($nInfo, "SubItem") ; The 'Column' Number  Selected E.G. Select The 2nd Item Will Return 1

	Switch $nWndFrom
		Case $nListViewProfiles
			Switch $nCode
				Case $NM_CLICK
					If $nIndex <> -1 And $nSubItem <> -1 Then
					EndIf
					$Global_ListViewIndex = $nIndex

				Case $NM_DBLCLK
					If $nIndex <> -1 And $nSubItem <> -1 Then
						$Global_ListViewIndex = $nIndex
						GUICtrlSendToDummy($Global_ListViewProfiles_Enter)
					EndIf

				Case $NM_RCLICK
					If $nIndex <> -1 And $nSubItem <> -1 Then
					EndIf
					_GUICtrlListView_ContextMenu_Customize($nListViewProfiles, $nIndex, $nSubItem) ; Show Customize GUI RightClick Menu.
					$Global_ListViewIndex = $nIndex

			EndSwitch

		Case $nListViewRules
			Switch $nCode
				Case $NM_CLICK
					If $nIndex <> -1 And $nSubItem <> -1 Then
					EndIf
					$Global_ListViewIndex = $nIndex

				Case $NM_DBLCLK
					If $nIndex <> -1 And $nSubItem <> -1 Then
						$Global_ListViewIndex = $nIndex
						GUICtrlSendToDummy($Global_ListViewRules_Enter)
					EndIf

				Case $NM_RCLICK
					If $nIndex <> -1 And $nSubItem <> -1 Then
						$Global_ListViewIndex = $nIndex
					EndIf
					_GUICtrlListView_ContextMenu_Manage($nListViewRules, $nIndex, $nSubItem) ; Show Manage GUI RightClick Menu.

			EndSwitch
	EndSwitch
	Return "GUI_RUNDEFMSG"
EndFunc   ;==>WM_NOTIFY

Func WM_SYSCOMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $ilParam
	If __Is("LockPosition") And $hWnd = $Global_GUI_1 And Not (_IsPressed(10) And _IsPressed(01)) Then
		If BitAND($iwParam, 0x0000FFF0) = $SC_MOVE Then Return 0
	EndIf
	Return "GUI_RUNDEFMSG"
EndFunc   ;==>WM_SYSCOMMAND
#Region End >>>>> WM_MESSAGES Functions <<<<<

#Region Start >>>>> Internal Functions <<<<<
Func __7ZipCommands($cType, $cDestinationFilePath, $cFlag = -1)
	#cs
		Description: Update 7-Zip Commands And Output Archive Format.
		Returns: $Array[2] - Array Contains Two Items.
		[0] - Updated Commands [a -tzip -mm=LZMA -mx5 -mem=AES256 -pPassword -sccUTF-8 -ssw]
		[1] - Updated Output Archive Name [C:\Example\Archive.7z]
		[2] - Type Of Compression [ZIP, 7Z, SFX]
	#ce
	; ZIP = "a -tzip -mm=LZMA -mx5 -mem=AES256 -pPassword -sccUTF-8 -ssw"
	; 7ZIP = "a -t7z -m0=LZMA -mx5 -pPassword -sccUTF-8 -ssw"
	; SFX = "a -sfx7z.sfx -m0=LZMA -mx5 -pPassword -sccUTF-8 -ssw "

	Local $c7ZipFormat = __7ZipCurrentFormat()
	Local $cCommands[11][3] = [ _
			[8, 3], _
			["-t", $c7ZipFormat, "ArchiveFormat"], _ ; Add Flag = 1
			["-mm=", "Deflate", "ArchiveMethod"], _ ; Add Flag = 2
			["-mx", "5", "ArchiveLevel"], _ ; Add Flag = 4
			["-mem=", "AES256", "ArchiveEncryptMethod"], _ ; Add Flag = 8
			["-p", "", "ArchivePassword"], _ ; Add Flag = 16
			["-scc", "UTF-8", -1], _ ; Add Flag = 32
			["-ss", "w", -1], _ ; Add Flag = 64
			["", "", -1], _ ; Add Flag = 128 - Not Used.
			["", "", -1]] ; Add Flag = 256 - Not Used.

	Local $cINI_Value, $c7Zip_Value, $cNewCommands[3], $cHex, $cCommand, $cDecrypt, $cPassword_Code = $Global_Password_Key
	Local $cINI = __IsSettingsFile() ; Get Default Settings INI File.
	If $cFlag = -1 Then $cFlag = 1 + 2 + 4 + 8 + 16 + 32 + 64 ; Default With Encryption (If Enabled).

	For $A = 2 To 5
		$cCommands[$A][1] = IniRead($cINI, "General", $cCommands[$A][2], $cCommands[$A][1])
	Next

	$cDecrypt = _StringEncrypt(0, $cCommands[5][1], $cPassword_Code)
	If @error Then $cDecrypt = ""
	If $cType = 1 Then Return "x -p" & $cDecrypt

	$cNewCommands[2] = $c7ZipFormat

	; Configure Method
	$cINI_Value = $cCommands[2][1]
	Switch $cINI_Value
		Case "Deflate"
			$c7Zip_Value = "Deflate"
		Case "LZMA2"
			$c7Zip_Value = "LZMA2"
		Case "PPMd"
			$c7Zip_Value = "PPMd"
		Case "BZip2"
			$c7Zip_Value = "BZip2"
		Case Else
			$c7Zip_Value = "LZMA"
	EndSwitch
	$cCommands[2][1] = $c7Zip_Value
	If $cCommands[1][1] = "7z" Then $cCommands[2][0] = "-m0=" ; 7ZIP Doesn't Use -mm but -m0=.

	; Configure Level
	$cINI_Value = $cCommands[3][1]
	Switch $cINI_Value
		Case "Fastest"
			$c7Zip_Value = "1"
		Case "Fast"
			$c7Zip_Value = "3"
		Case "Maximum"
			$c7Zip_Value = "7"
		Case "Ultra"
			$c7Zip_Value = "9"
		Case Else
			$c7Zip_Value = "5"
	EndSwitch
	$cCommands[3][1] = $c7Zip_Value

	; Configure Encrypt
	If __Is("ArchiveEncrypt") Then
		$cINI_Value = $cCommands[4][1]
		Switch $cINI_Value
			Case "ZipCrypto"
				$c7Zip_Value = "ZipCrypto"
			Case Else
				$c7Zip_Value = "AES256"
		EndSwitch
		$cCommands[4][1] = $c7Zip_Value
		$cCommands[5][1] = $cDecrypt
		If $cCommands[1][1] = "7z" Then $cCommands[4][1] = -1 ; 7ZIP Doesn't Use -mem.
	Else
		$cCommands[4][1] = -1
		$cCommands[5][1] = -1
	EndIf

	; Configure Self-Extracting
	If __Is("ArchiveSelf") Then
		$cCommands[1][0] = "-sfx"
		$cCommands[1][1] = "7z.sfx" ; SFX Module.
		$cCommands[2][0] = "-m0="
		$cCommands[4][1] = -1
		$cNewCommands[2] = "SFX"
	EndIf

	; Configure Format For SFX
	$cINI_Value = $cCommands[1][0]
	Switch $cINI_Value
		Case "-sfx"
			$cDestinationFilePath = StringTrimRight($cDestinationFilePath, 3) ; Removes.7z [Test.7z >> Test & Test.zip >> Test.]
			If StringRight($cDestinationFilePath, 1) = "." Then $cDestinationFilePath = StringTrimRight($cDestinationFilePath, 1) ; Removes The "."
	EndSwitch

	$cHex = 1
	$cCommand = "a "
	For $A = 1 To $cCommands[0][0]
		If BitAND($cFlag, $cHex) And $cCommands[$A][1] <> -1 Then
			$cCommand &= $cCommands[$A][0] & $cCommands[$A][1] & " "
		EndIf
		$cHex *= 2
	Next
	$cNewCommands[0] = $cCommand
	$cNewCommands[1] = $cDestinationFilePath
	Return $cNewCommands
EndFunc   ;==>__7ZipCommands

Func __7ZipCurrentFormat()
	#cs
		Description: Gets The Current 7-Zip Format.
		Returns: 7-Zip Format [zip]
	#ce
	Local $cINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $cINI_Value = IniRead($cINI, "General", "ArchiveFormat", "ZIP")
	Switch $cINI_Value
		Case "7Z"
			Return "7z"
		Case Else
			Return "zip"
	EndSwitch
EndFunc   ;==>__7ZipCurrentFormat

Func __7ZipRun($rSourceFilePath = "", $rDestinationFilePath = "", $rType = 0, $rDefault = 0, $rNotWait = 0)
	#cs
		Description: Compress/Decompress Using 7-Zip.
		Returns: Compressed FilePath [C:\Test.7z] Or $Array[2] - Array Contains Two Items.
		[0] - Process ID
		[1] - Compressed FilePath [C:\Test.7z]
	#ce
	Local $rCommand, $rNewCommands, $rReturnedArray[2]
	Local $7Zip = @ScriptDir & "\Lib\7z\7z.exe"
	If Not FileExists($7Zip) Or $rSourceFilePath = "" Or $rDestinationFilePath = "" Then Return SetError(1, 1, 0)
	Switch $rType
		Case 0 ; Compress Mode.
			$rCommand = "a -tzip -mm=Deflate -mx5 -mem=AES256 -sccUTF-8 -ssw"
			If $rDefault = 1 Then
				$rNewCommands = __7ZipCommands($rType, $rDestinationFilePath, -1)
				$rCommand = $rNewCommands[0]
				$rDestinationFilePath = $rNewCommands[1]
			EndIf
			$rCommand = '"' & $7Zip & '" ' & $rCommand & ' "' & $rDestinationFilePath & '" "' & $rSourceFilePath & '"'

		Case 1 ; Decompress Mode.
			$rCommand = '"' & $7Zip & '" ' & __7ZipCommands($rType, -1, -1) & ' "' & $rSourceFilePath & '" -y -o"' & $rDestinationFilePath & '"'

		Case Else ; Wrong Parameter.
			Return SetError(1, 1, 0)
	EndSwitch

	If $rNotWait = 1 Then
		$rReturnedArray[0] = Run($rCommand, "", @SW_HIDE)
	Else
		RunWait($rCommand, "", @SW_HIDE)
	EndIf

	If $rType = 0 And $rDefault = 1 Then
		If $rNewCommands[2] = "SFX" Then $rDestinationFilePath = $rDestinationFilePath & ".exe"
	EndIf
	$rReturnedArray[1] = $rDestinationFilePath

	If @error Then Return SetError(1, 1, $rReturnedArray[1])
	If $rNotWait = 1 Then Return $rReturnedArray
	If Not FileExists($rDestinationFilePath) Then Return SetError(1, 1, $rReturnedArray[1])
	Return $rReturnedArray[1]
EndFunc   ;==>__7ZipRun

Func __Backup_Restore($bHandle = -1, $bType = 0) ; 0 = Backup & 1 = Restore & 2 = Remove.
	#cs
		Description: Backups/Restores The Settings INI File & Profiles.
		Returns: 1
	#ce
	Local $bBackupDirectory = __GetDefault(32) ; Get Default Backup Directory.
	Local $bZipFile = "DropIt_Backup_" & @YEAR & "-" & @MON & "-" & @MDAY & "_(" & @HOUR & "-" & @MIN & "-" & @SEC & ")"
	Local $bBackup[3] = [2, __IsSettingsFile(), __GetDefault(2)] ; __GetDefault(2) = Get Default Profiles Directory.

	Switch $bType
		Case 0
			__7ZipRun($bBackup[1] & '" "' & $bBackup[2], $bBackupDirectory & $bZipFile, 0, 0)
			MsgBox(0, __Lang_Get('OPTIONS_BACKUP_MSGBOX_0', 'Backup created'), __Lang_Get('OPTIONS_BACKUP_MSGBOX_1', 'Successfully created a DropIt Backup.'), 0, __OnTop($bHandle))

		Case 1
			Local $bSettingsDirectory = __GetDefault(1) ; __GetDefault(1) = Get The Default Settings Directory.
			If Not FileExists($bBackupDirectory) Or DirGetSize($bBackupDirectory, 2) = 0 Then $bBackupDirectory = __GetDefault(1) ; __GetDefault(1) = Get The Default Settings Directory.
			$bZipFile = FileOpenDialog(__Lang_Get('OPTIONS_BACKUP_TIP_0', 'Select a DropIt Backup'), $bBackupDirectory, __Lang_Get('OPTIONS_BACKUP_TIP_1', 'DropIt Backup') & " (*.zip)", 1, "", __OnTop($bHandle))
			If @error Then Return SetError(1, 1, 0)

			For $A = 1 To $bBackup[0]
				If Not FileExists($bBackup[$A]) Then ContinueLoop
				If __IsFolder($bBackup[$A]) Then DirRemove($bBackup[$A], 1)
			Next

			__7ZipRun($bZipFile, $bSettingsDirectory, 1, 0)
			Sleep(100)
			MsgBox(0, __Lang_Get('OPTIONS_BACKUP_MSGBOX_2', 'Backup restored'), __Lang_Get('OPTIONS_BACKUP_MSGBOX_3', 'Successfully restored the selected DropIt Backup.'), 0, __OnTop($bHandle))

		Case 2
			If Not FileExists($bBackupDirectory) Or DirGetSize($bBackupDirectory, 2) = 0 Then $bBackupDirectory = __GetDefault(1) ; __GetDefault(1) = Get The Default Settings Directory.
			$bZipFile = FileOpenDialog(__Lang_Get('OPTIONS_BACKUP_TIP_0', 'Select a DropIt Backup'), $bBackupDirectory, __Lang_Get('OPTIONS_BACKUP_TIP_1', 'DropIt Backup') & " (*.zip)", 1, "", __OnTop($bHandle))
			If @error Then Return SetError(1, 1, 0)

			FileDelete($bZipFile)
			If DirGetSize($bBackupDirectory, 2) = 0 Then DirRemove($bBackupDirectory, 1) ; Remove Back Directory If Empty.
			MsgBox(0, __Lang_Get('OPTIONS_BACKUP_MSGBOX_4', 'Backup removed'), __Lang_Get('OPTIONS_BACKUP_MSGBOX_5', 'Successfully removed the selected DropIt Backup.'), 0, __OnTop($bHandle))

	EndSwitch
	Return 1
EndFunc   ;==>__Backup_Restore

Func __ByteSuffix($bBytes, $bPlaces = 2)
	#cs
		Description: Rounds A Value Of Bytes To Highest Value.
		Returns: [1024 Bytes = 1 KB]
	#ce
	Local $A, $bArray[6] = [" byte", " KB", " MB", " GB", " TB", " PB"]
	While $bBytes > 1023
		$A += 1
		$bBytes /= 1024
	WEnd
	Return Round($bBytes, $bPlaces) & $bArray[$A]
EndFunc   ;==>__ByteSuffix

Func __CheckMultipleInstances()
	#cs
		Description: Checks All Multiple Instances In The INI File Are Currently Running.
		Returns: Number Of Multiple Instances Running.
	#ce
	Local $cINI = __IsSettingsFile() ; Get Default Settings INI File.

	Local $cMultipleInstancesINI = __IniReadSection($cINI, "MultipleInstances")
	If @error Then Return SetError(1, 1, 0)
	Local $cRunning = 0
	For $A = 1 To $cMultipleInstancesINI[0][0]
		If $cMultipleInstancesINI[$A][0] = "Running" Then ContinueLoop
		$cRunning += 1
		If Not ProcessExists($cMultipleInstancesINI[$A][1]) Then
			IniDelete($cINI, $cMultipleInstancesINI[$A][0])
			IniDelete($cINI, "MultipleInstances", $cMultipleInstancesINI[$A][0])
			$cRunning -= 1
		EndIf
	Next
	IniWrite($cINI, "MultipleInstances", "Running", $cRunning)
	Return $cRunning
EndFunc   ;==>__CheckMultipleInstances

Func __CMDLine($cTemp_CmdLine, $WM_COPYDATA = 0) ; 0 = Normal CommandLine & 1 = WM_COPYDATA, Required Because The Normal CommandLine Array Shows The Number Of Items And WM_COPYDATA Doesn't.
	#cs
		Description: Checks If CommandLine Is Correct And Processes Accordingly.
		Returns: 1
	#ce
	Local $cCmdLine, $cProfile, $cDroppedFiles, $cTemp, $cIndex, $cMinus

	Switch $WM_COPYDATA
		Case 0
			$cCmdLine = $cTemp_CmdLine[0]
			$cIndex = 1

		Case 1
			$cCmdLine = UBound($cTemp_CmdLine, 1)
			$cIndex = 0

	EndSwitch

	If $cCmdLine > 0 Then
		If $cTemp_CmdLine[$cIndex] == "/Uninstall" Then __Uninstall()
		If StringLeft($cTemp_CmdLine[$cIndex], 1) = "-" Then
			$cProfile = StringTrimLeft($cTemp_CmdLine[$cIndex], 1)
			If FileExists(__GetDefault(2) & $cProfile & ".ini") Then ; __GetDefault(2) = Get Default Profile Directory.
				$cProfile = __ProfileList_GUI($cProfile)
				If @error Then Return SetError(1, 1, 0)
				Switch $WM_COPYDATA
					Case 0
						$cIndex += 1
						$cMinus = 2

					Case 1
						$cCmdLine -= 1
						$cIndex += 1
						$cMinus = 1

				EndSwitch
			Else
				$cProfile = __ProfileList_GUI() ; Show Profile Selection GUI To Select A Profile From The ProfileList.
				If @error Then Return SetError(1, 1, 0)
				Switch $WM_COPYDATA
					Case 0
						$cIndex += 1
						$cMinus = 2

					Case 1
						$cCmdLine -= 1
						$cIndex += 1
						$cMinus = 1

				EndSwitch

			EndIf
		Else
			$cProfile = __ProfileList_GUI() ; Show Profile Selection GUI To Select A Profile From The ProfileList.
			If @error Then Return SetError(1, 1, 0)
			Switch $WM_COPYDATA
				Case 0
					$cMinus = 1

				Case 1
					$cCmdLine -= 1
					$cIndex = 0
					$cMinus = 0

			EndSwitch
		EndIf
	ElseIf $cCmdLine = 0 Then
		Return SetError(1, 1, 0)
	EndIf

	Local $cCount
	Local $cDroppedFiles[$cCmdLine + 1 * 2]
	For $A = $cIndex To $cCmdLine
		$cTemp = $cTemp_CmdLine[$A]
		If UBound($cDroppedFiles, 1) <= $A + 1 Then ReDim $cDroppedFiles[UBound($cDroppedFiles, 1) * 2] ; ReDim's $cDroppedFiles If More Items Are Required.
		If StringInStr($cTemp, ":") Then
			$cDroppedFiles[$A - $cMinus] = $cTemp
		Else
			$cDroppedFiles[$A - $cMinus] = _PathFull(@ScriptDir & "..\" & $cTemp) ; It Needs This Additional "..\" To Work Correctly
		EndIf
		$cCount += 1
	Next
	ReDim $cDroppedFiles[$cCount] ; Delete Empty Rows.
	_DropEvent($cDroppedFiles, $cProfile) ; Send Files To Be Processed.
	Return 1
EndFunc   ;==>__CMDLine

Func __CmdLineRaw($cString)
	#cs
		Description: Converts $CmdLineRaw To $CmdLine Without The Index Value.
		Returns: Array[?]
		[0] - File Name 1 [C:\Test File.exe]
		[1] - File Name 2 [C:\Test File.exe]
	#ce
	If $cString = "" Then Return SetError(1, 1, 0)
	$cString = _WinAPI_ExpandEnvironmentStrings($cString)
	If @error Then Return SetError(1, 1, 0)
	Return StringRegExp($cString, '((?<=\s"|^")[^"]+(?=")|[^\s"]+)', 3)
EndFunc   ;==>__CmdLineRaw

Func __Column_Width($cColumn, $cSave = -1)
	#cs
		Description: Retrives Or Saves The Column Width.
		Returns: Array[?]
		[0] - Column 1 [90]
		[1] - Column 2 [165]
	#ce
	Local $cINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $cReturn

	Switch $cSave
		Case -1
			$cReturn = StringSplit(IniRead($cINI, "General", $cColumn, ""), ";")

		Case Else
			If Not IsArray($cSave) Then Return SetError(1, 1, 0)
			$cReturn = _ArrayToString($cSave, ";")
			IniWrite($cINI, "General", $cColumn, $cReturn)
	EndSwitch
	Return $cReturn
EndFunc   ;==>__Column_Width

Func __EncryptionFile($eFilePath, $eDecryptOnly = 0) ; $eDecryptOnly = 1, Is If The File Is An INI Then Don't Encrypt.
	#cs
		Description: Creates An Encrypted/Decrypted Of A Profile File. .dat Is The Extension Used For Encryption.
		Returns: Full Path Of Encrypted/Decrypted File [C:\Program Files\DropIt\Profiles\Default.dat]
	#ce
	Local $eEncryptionKey = $Global_Encryption_Key

	Local $eCryptFile
	Switch __GetFileNameExExt($eFilePath, 1)
		Case "ini"
			If $eDecryptOnly Or Not __Is("ProfileEncryption") Then Return $eFilePath
			$eCryptFile = __GetFileNameExExt($eFilePath) & ".ini"
			If Not FileExists($eFilePath) Then Return $eCryptFile
			_Crypt_EncryptFile($eFilePath, $eCryptFile, $eEncryptionKey, $CALG_AES_256)
		Case "dat"
			$eCryptFile = __GetFileNameExExt($eFilePath) & ".ini"
			If Not FileExists($eFilePath) Then Return $eCryptFile
			_Crypt_DecryptFile($eFilePath, $eCryptFile, $eEncryptionKey, $CALG_AES_256)
	EndSwitch
	FileDelete($eFilePath)
	Return $eCryptFile
EndFunc   ;==>__EncryptionFile

Func __EncryptionFolder($fDecrypt = -1) ; $fDecrypt = 0, Encrypt/Decrypt Profiles.
	#cs
		Description: Creates An Encrypted/Decrypted File Of The Profiles Folder. .dat Is The Extension Used For Encryption.
		Returns: Full Path Of Encrypted/Decrypted File [C:\Program Files\DropIt\Profiles.dat]
	#ce
	Local $7Zip = @ScriptDir & "\Lib\7z\7z.exe", $fPassword = $Global_Encryption_Key, $fCommand, $fFolder
	Local $fEncryptionFile = __GetDefault(1) & "Profiles.dat"
	Local $fProfileFolder = __GetDefault(2) ; Get Default Profile Directory.
	If Not FileExists($7Zip) Then Return SetError(1, 1, 0)
	If FileExists($fEncryptionFile) And $fDecrypt = -1 Then $fDecrypt = 1

	Switch $fDecrypt
		Case 0 ; Encrypt.
			$fFolder = $fProfileFolder
			$fCommand = '"' & $7Zip & '" a -m0=LZMA -mx5 -p' & $fPassword & ' -sccUTF-8 -ssw' & ' "' & $fEncryptionFile & '" "' & $fFolder & '"'
			RunWait($fCommand, "", @SW_HIDE)
			Sleep(100)
			If FileExists($fEncryptionFile) Then DirRemove($fFolder, 1)

		Case 1 ; Decrypt.
			$fFolder = __GetDefault(1)
			$fCommand = '"' & $7Zip & '" ' & 'x -p' & $fPassword & ' "' & $fEncryptionFile & '" -y -o"' & $fFolder & '"'
			RunWait($fCommand, "", @SW_HIDE)
			Sleep(100)
			If DirGetSize($fProfileFolder) <> 0 Then FileDelete($fEncryptionFile)

	EndSwitch
	Return $fEncryptionFile
EndFunc   ;==>__EncryptionFolder

Func __EnvironmentVariables()
	#cs
		Description: Sets The Standard & User Assigned Environment Variables.
		Returns: 1
	#ce
	Local $eEnvironmentArray[7][2] = [ _
			[6, 2], _
			["CurrentDate", @YEAR & "-" & @MON & "-" & @MDAY], _ ; Returns: Current Date YYYY-MM-DD [2011-04-12]
			["License", "Open Source GPL"], _ ; Returns: DropIt License [Open Source GPL]
			["PortableDrive", StringLeft(@AutoItExe, 2)], _ ; Returns: Drive Letter [C: Without The Trailing "\"]
			["Team", "Lupo PenSuite Team"], _ ; Returns: Team Name [Lupo PenSuite Team]
			["URL", "http://dropit.sourceforge.net/index.htm"], _ ; Returns: URL Hyperlink [http://dropit.sourceforge.net/index.htm]
			["VersionNo", $Global_CurrentVersion]] ; Returns: Version Number [1.0]

	For $A = 1 To $eEnvironmentArray[0][0]
		EnvSet($eEnvironmentArray[$A][0], $eEnvironmentArray[$A][1])
	Next

	Local $eINI = __IsSettingsFile() ; Get Default Settings INI File
	Local $eSection = __IniReadSection($eINI, "EnvironmentVariables") ; Sets Custom Environment Variables.
	If @error Or $eSection[0][0] = 0 Then Return 1
	For $A = 1 To $eSection[0][0]
		EnvSet($eSection[$A][0], $eSection[$A][1])
	Next
	Return 1
EndFunc   ;==>__EnvironmentVariables

Func __ExpandEnvStrings($eEnvStrings)
	#cs
		Description: Sets The Expansion Of Environment Variables.
		Returns: 0 = Disabled Or 1 = Enabled.
	#ce.
	Opt("ExpandEnvStrings", $eEnvStrings)
	Return $eEnvStrings
EndFunc   ;==>__ExpandEnvStrings

Func __ExpandEventMode($eEventMode)
	#cs
		Description: Sets The Expansion Of The GUIOnEventMode.
		Returns: 0 = Disabled Or 1 = Enabled.
	#ce.
	Opt("GUIOnEventMode", $eEventMode)
	Return $eEventMode
EndFunc   ;==>__ExpandEventMode

Func __FilePathIsValid($fPath, $fPattern = '*?|:<>"/')
	#cs
		Description: Checks If A String Is A Valid File Path And Doesn't Contain Invalid Characters.
		Returns:
		If String Is Valid File Path Return 1
		If String Is InValid File Path Return 0
	#ce
	If StringRegExp($fPath, '(?i)^[a-z]:([^\Q' & $fPattern & '\E]+)?(\\[^\Q' & $fPattern & '\E\\]+)?(\.[^\Q' & $fPattern & '\E\\\.]+|\\)?$') = 1 Then Return 1
	If __WinAPI_PathIsRelative($fPath) = 1 And __StringIsValid($fPath, $fPattern) Then Return 1
	Return 0
EndFunc   ;==>__FilePathIsValid

Func __GetCompactFilePath($gFilePath, $gMax = 50) ; Taken From WinAPIEx.au3 By Yashied - http://www.autoitscript.com/forum/index.php?showtopic=98712
	#cs
		Description: Gets The Compact Style Of A File Path.
		Returns: File Name [C:\Program Files\Dro...\FileName.txt]
	#ce
	Local $gData = DllStructCreate("wchar[1024]")
	Local $gReturn = DllCall("shlwapi.dll", "int", "PathCompactPathExW", "ptr", DllStructGetPtr($gData), "wstr", $gFilePath, "uint", $gMax + 1, "dword", 0)
	If (@error) Or (Not $gReturn[0]) Then Return SetError(1, 0, $gFilePath)
	Return DllStructGetData($gData, 1)
EndFunc   ;==>__GetCompactFilePath

Func __GetCurrentLanguage()
	#cs
		Description: Gets The Current Language From The Settings INI File.
		Return: Language [English]
	#ce
	Local $gINI = __IsSettingsFile() ; Get Default Settings INI File.

	Local $gINIRead, $gLanguageDefault
	$gLanguageDefault = __GetDefault(3072) ; Get Default Language Directory & Default Language.
	$gINIRead = IniRead($gINI, "General", "Language", $gLanguageDefault[2][0])
	If Not FileExists($gLanguageDefault[1][0] & $gINIRead & ".lng") Then
		$gINIRead = $gLanguageDefault[2][0]
		IniWrite($gINI, "General", "Language", $gINIRead) ; Ideally This Should Use __SetCurrentLanguage() But There Was An Error.
	EndIf
	Return $gINIRead
EndFunc   ;==>__GetCurrentLanguage

Func __GetCurrentPosition()
	#cs
		Description: Gets The Current Coordinates/Position From The Settings INI File.
		Returns: Array[2]
		[0] - X Coordinate/Position [100]
		[1] - Y Coordinate/Position [100]
	#ce
	Local $gINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $gReturn[2] = [100, 100]

	Local $gINISection = "General"
	If $Global_MultipleInstance Then $gINISection = $UniqueID
	$gReturn[0] = IniRead($gINI, $gINISection, "PosX", "-1")
	$gReturn[1] = IniRead($gINI, $gINISection, "PosY", "-1")
	Return $gReturn
EndFunc   ;==>__GetCurrentPosition

Func __GetCurrentProfile()
	#cs
		Description: Gets The Current Profile Name From The Settings INI File.
		Return: Profile Name [Profile Name]
	#ce
	Local $gINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $gINIRead = IniRead($gINI, "General", "Profile", "Default")
	If $Global_MultipleInstance Then $gINIRead = IniRead($gINI, $UniqueID, "Profile", $gINIRead)
	Return $gINIRead
EndFunc   ;==>__GetCurrentProfile

Func __GetDefault($gFlag = 1, $gSkipInstallationCheck = 0) ; 0 = Don't Skip Installation Check & 1 = Skip Installation Check.
	Local $gHex
	Local $gScriptDir = @ScriptDir & "\"
	If __IsInstalled() And $gSkipInstallationCheck = 0 Then $gScriptDir = @AppDataDir & "\DropIt\" ; __IsInstalled() = Checks If DropIt Is Installed.

	Local $gInitialArray[17][2] = [ _
			[14, 2], _
			[$gScriptDir, "Settings Directory"], _ ; Add Flag = 1
			[$gScriptDir & "Profiles\", "Profiles Directory"], _ ; Add Flag = 2
			[@ScriptDir & "\" & "Images\", "Images Directory"], _ ; Add Flag = 4
			["settings.ini", "Settings INI File"], _ ; Add Flag = 8
			["Default.png", "Default Image File"], _ ; Add Flag = 16
			[$gScriptDir & "Backup\", "Default Backup Folder"], _ ; Add Flag = 32
			[$gScriptDir & "settings.ini", "Settings FullPath"], _ ; Add Flag = 64
			[@ScriptDir & "\" & "Images\" & "Default.png", "Default Image FullPath"], _ ; Add Flag = 128
			[@ScriptDir & "\" & "Lib\img\" & "zz.png", "Working Image FullPath"], _ ; Add Flag = 256
			["LogFile.log", "Default Log File"], _ ; Add Flag = 512
			[@ScriptDir & "\" & "Languages\", "Language Directory"], _ ; Add Flag = 1024
			["English", "Default Language Name"], _ ; Add Flag = 2048
			[@ScriptDir & "\" & "Languages\" & "English.lng", "Default Language FullPath"], _ ; Add Flag = 4096
			["", ""], _ ; Add Flag = 8192 <= Not Used.
			["", ""], _ ; Add Flag = 16384 <= Not Used.
			["", ""]] ; Add Flag = 32768 <= Not Used.

	Local $gReturnArray[$gInitialArray[0][0] + 1][$gInitialArray[0][1]] = [[0, 2]]
	If Not FileExists(@ScriptDir & "\" & "Images\") Then DirCreate(@ScriptDir & "\" & "Images\")
	If Not FileExists($gScriptDir & "Profiles\") Then DirCreate($gScriptDir & "Profiles\")

	$gHex = 1
	For $A = 1 To $gInitialArray[0][0]
		If BitAND($gFlag, $gHex) Then
			$gReturnArray[$gReturnArray[0][0] + 1][0] = $gInitialArray[$A][0]
			For $B = 1 To $gInitialArray[0][1] - 1
				$gReturnArray[$gReturnArray[0][0] + 1][$B] = $gInitialArray[$A][$B]
			Next
			$gReturnArray[0][0] += 1
		EndIf
		$gHex *= 2
	Next

	ReDim $gReturnArray[$gReturnArray[0][0] + 1][$gReturnArray[0][1]] ; Delete Empty Rows.
	If $gReturnArray[0][0] = 1 Then Return $gReturnArray[1][0]
	Return $gReturnArray
EndFunc   ;==>__GetDefault

Func __GetFileNameExExt($gFilePath, $gGetExt = 0) ; Taken From WinAPIEx.au3 By Yashied - http://www.autoitscript.com/forum/index.php?showtopic=98712
	#cs
		Description: Gets The File Path Without Extension Or The File Extension.
		Returns: FileName Without The Extension [C:\Program Files\Test] Or File Extension [txt]
	#ce
	Local $gPath
	If $gGetExt = 0 Then ; Get FileName Without The Extension.
		$gPath = DllStructCreate("wchar[" & (StringLen($gFilePath) + 1) & "]")
		DllStructSetData($gPath, 1, $gFilePath)
		DllCall("shlwapi.dll", "none", "PathRemoveExtensionW", "ptr", DllStructGetPtr($gPath))
		If @error Then Return SetError(1, 1, 0)
		Return DllStructGetData($gPath, 1)
	ElseIf $gGetExt = 1 Then ; Get File Extension.
		$gPath = DllStructCreate("wchar[1024]")
		DllStructSetData($gPath, 1, $gFilePath)
		Local $gReturn = DllCall("shlwapi.dll", "int", "PathFindExtensionW", "ptr", DllStructGetPtr($gPath))
		If @error Then Return SetError(1, 1, 0)
		Return StringTrimLeft(DllStructGetData(DllStructCreate("wchar[1024]", $gReturn[0]), 1), 1)
	EndIf
	Return SetError(1, 1, 0)
EndFunc   ;==>__GetFileNameExExt

Func __GetFileName($gFilePath) ; Taken From WinAPIEx.au3 By Yashied - http://www.autoitscript.com/forum/index.php?showtopic=98712
	#cs
		Description: Gets The File Name From A File Path.
		Returns: File Name [FileName.txt]
	#ce
	Local $gPath = DllStructCreate("wchar[" & (StringLen($gFilePath) + 1) & "]")
	DllStructSetData($gPath, 1, $gFilePath)
	DllCall("shlwapi.dll", "none", "PathStripPathW", "ptr", DllStructGetPtr($gPath))
	If @error Then Return SetError(1, 1, 0)
	Return DllStructGetData($gPath, 1)
EndFunc   ;==>__GetFileName

Func __GetFileProperties($gFilePath, $gPropertyNumber = 0, $gUseGlobalNumeration = 0) ; Modified Version Of A Melba23's Script - http://www.autoitscript.com/forum/topic/109450-file-properties/
	#cs
		Description: Gets The Defined File Property.
		Returns: Defined Property E.G. File Name [FileName.txt]

		Supported Global Numeration:
		0 Name, 1 Size, 2 Type, 3 Date Modified, 4 Date Created, 5 Date Accessed, 6 Attributes, 7 Status, 8 Owner,
		9 Date Taken, 10 Dimensions, 11 Camera Model, 12 Authors, 13 Artists, 14 Title, 15 Album, 16 Genre,
		17 Year, 18 Track Number, 19 Subject, 20 Categories, 21 Comments, 22 Copyright, 23 Duration, 24 Bit Rate.
		This Numeration Is Automatically Converted For WinXP, WinVista And Win7.
		More Properties And Relative Numeration Are Reported At The AutoIt Webpage.
	#ce
	Local $gDir_Name = StringRegExpReplace($gFilePath, "(^.*\\)(.*)", "\1")
	Local $gFile_Name = StringRegExpReplace($gFilePath, "^.*\\", "")
	Local $gDOS_Dir = FileGetShortName($gDir_Name, 1)
	Local $gArrayWinXP[25] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 25, 26, 24, 9, 16, 10, 17, 20, 18, 19, 11, 12, 14, 15, 21, 22]
	Local $gArrayWinVista[25] = [0, 1, 2, 3, 4, 5, 6, 7, 10, 12, 31, 30, 20, 13, 21, 14, 16, 15, 26, 22, 23, 24, 25, 36, 28]

	If $gUseGlobalNumeration = 1 Then
		If @OSVersion == "WIN_XP" Or @OSVersion == "WIN_XPe" Then $gPropertyNumber = $gArrayWinXP[$gPropertyNumber]
		If @OSVersion == "WIN_VISTA" Or @OSVersion == "WIN_7" Then $gPropertyNumber = $gArrayWinVista[$gPropertyNumber]
	EndIf

	Local $gShellApp = ObjCreate("Shell.Application")
	If IsObj($gShellApp) Then
		Local $gObjectFolder = $gShellApp.NameSpace($gDOS_Dir)
		If IsObj($gObjectFolder) Then
			; Local $gFile = $gObjectFolder.Parsename($gFile_Name)
			; If IsObj($gFile) Then
			;	Local $gFile_Property = $gObjectFolder.GetDetailsOf($gFile, $gPropertyNumber)
			;	Return $gFile_Property
			; EndIf
			For $gObjectItem In $gObjectFolder.Items
				If $gObjectFolder.GetDetailsOf($gObjectItem, 0) = $gFile_Name Then
					Local $gFile_Property = $gObjectFolder.GetDetailsOf($gObjectItem, $gPropertyNumber)
					Return $gFile_Property
				EndIf
			Next
		EndIf
	EndIf

	Return SetError(1, 1, 0)
EndFunc   ;==>__GetFileProperties

Func __GetMultipleInstances()
	#cs
		Description: Gets The Number Of Additional DropIt Instances.
		Returns: 1
	#ce
	Local $gINI = __IsSettingsFile() ; Get Default Settings INI File.
	Return IniRead($gINI, "MultipleInstances", "Running", "0")
EndFunc   ;==>__GetMultipleInstances

Func __GetMultipleInstancesRunning()
	#cs
		Description: Proivides Details Of The Multiple Instances Running.
		Returns: @error Or $Array[?] - Array Contains Unlimited Number Of Items.
		[0][0] - Number Of Rows [3]
		[0][1] - Number Of Colums [3]

		[A][1] - Multiple Instance Name [1_DropIt_MultipleInstance]
		[A][2] - Multiple Instance Handle [0x123456]
		[A][3] - Multiple Instance PID [1234]
	#ce
	Local $gReturn[2][3] = [[0, 3]]
	Local $gWinList = WinList()
	For $A = 1 To $gWinList[0][0]
		If $gWinList[$A][0] <> "" And StringInStr($gWinList[$A][0], "_DropIt_MultipleInstance") Then
			If UBound($gReturn, 1) <= $gReturn[0][0] + 1 Then ReDim $gReturn[UBound($gReturn, 1) * 2][$gReturn[0][1]] ; ReDim's $gReturn If More Items Are Required.
			Local $ghWndProcess = WinGetProcess($gWinList[$A][0])
			$gReturn[0][0] += 1
			$gReturn[$gReturn[0][0]][0] = $gWinList[$A][0] ; Multiple Instance Name.
			$gReturn[$gReturn[0][0]][1] = WinGetHandle($gWinList[$A][0]) ; Multiple Instance Handle.
			$gReturn[$gReturn[0][0]][2] = $ghWndProcess ; PID Of Multiple Instance (Useful If You Want To End The Process.)
		EndIf
	Next
	ReDim $gReturn[$gReturn[0][0] + 1][$gReturn[0][1]] ; Delete Empty Spaces.
	If $gReturn[0][0] = 0 Then Return SetError(1, 1, 0)
	Return $gReturn
EndFunc   ;==>__GetMultipleInstancesRunning

Func __GetParentFolder($gFilePath) ; Taken From WinAPIEx.au3 By Yashied - http://www.autoitscript.com/forum/index.php?showtopic=98712
	#cs
		Description: Gets The Parent Folder. FileName Without The Extension [C:\Program Files\Test\Example.zip]
		Returns: Parent Folder FileName Without The Extension [C:\Program Files\Test\]
	#ce
	Local $gPath = DllStructCreate("wchar[" & (StringLen($gFilePath) + 1) & "]")
	DllStructSetData($gPath, 1, $gFilePath)
	DllCall("shlwapi.dll", "none", "PathRemoveFileSpecW", "ptr", DllStructGetPtr($gPath))
	If @error Then Return SetError(1, 1, 0)
	Return DllStructGetData($gPath, 1) & "\"
EndFunc   ;==>__GetParentFolder

Func __GetPatterns($gProfile = -1)
	#cs
		Description: Gets Patterns In The Current Profile [-1] Or Specified Profile Name [Valid Profile Name].
		Returns: Array[0][0] - Number Of Items [?]
		[0][1] - Number Of Columns [3]
		[0][2] - Profile Name [Profile Name]

		Array[A][0] - Pattern Name [*.EXE]
		[A][1] - Directory/Folder [C:\DropIt Files]
		[A][2] - Description Name [Executables]
	#ce
	$gProfile = __IsProfile($gProfile, 0) ; Get Array Of Selected Profile.
	Local $gReturn[1][3] = [[0, 3, $gProfile[1]]]

	Local $g_IniReadSection, $gStringSplit
	$g_IniReadSection = __IniReadSection($gProfile[0], "Patterns")
	If @error Then Return $gReturn
	Local $gReturn[$g_IniReadSection[0][0] + 1][3] = [[0, 3, $gProfile[1]]]

	For $A = 1 To $g_IniReadSection[0][0]
		If Not StringInStr($g_IniReadSection[$A][1], "|") Then $g_IniReadSection[$A][1] &= "|"
		$gStringSplit = StringSplit($g_IniReadSection[$A][1], "|")
		If @error Or $gStringSplit[0] < 2 Then
			IniDelete($gProfile[0], "Patterns", $g_IniReadSection[$A][0])
			ContinueLoop
		EndIf

		$gReturn[$A][0] = $g_IniReadSection[$A][0]
		$gReturn[$A][1] = $gStringSplit[1]
		$gReturn[$A][2] = $gStringSplit[2]
		$gReturn[0][0] += 1
	Next
	ReDim $gReturn[$gReturn[0][0] + 1][3] ; Delete Empty Rows.
	Return $gReturn
EndFunc   ;==>__GetPatterns

Func __GetProfile($gINI = -1, $gProfile = -1, $gProfileDirectory = -1, $gArray = 0)
	#cs
		Description: DO NOT USE, ONLY CALLED BY __IsProfile().
	#ce
	$gINI = __IsSettingsFile($gINI) ; Get Default Settings INI File.
	Local $gProfileDefault = __GetDefault(22) ; Get Default Profile & Default Image Directory & Default Image File.
	If $gProfileDirectory = -1 Or $gProfileDirectory = 0 Or $gProfileDirectory = "" Then $gProfileDirectory = __GetDefault(2) ; Get Default Profile Directory.

	Local $gReturn[9], $gSize

	If $gProfile == -1 Or $gProfile == 0 Or $gProfile == "" Then $gProfile = __GetCurrentProfile() ; If Profile Name Is Blank, Then Get Current Profile From The Settings INI File.
	If Not FileExists($gProfileDefault[1][0] & $gProfile & ".ini") And $gProfile <> "Default" Then ; Check If Profile Exists.
		If $CmdLine[0] = 0 Then MsgBox(0x30, __Lang_Get('CMDLINE_MSGBOX_0', 'Profile not found'), __Lang_Get('CMDLINE_MSGBOX_1', 'It appears DropIt is using an invalid Profile.  @LF  It will be started using "Default" profile.'), 0, __OnTop())
		$gProfile = "Default" ; Default Profile Name.
		__SetCurrentProfile($gProfile) ; Write Default Profile Name To The Settings INI File.
	EndIf

	$gReturn[0] = $gProfileDefault[1][0] & $gProfile & ".ini" ; Profile Directory And Profile Name.
	$gReturn[1] = $gProfile ; Profile Name.
	$gReturn[2] = $gProfileDefault[1][0] ; Profile Directory


	If Not FileExists($gReturn[0]) Then ; If The Profile Doesn't Exist, Create It.
		IniWriteSection($gReturn[0], "Target", "Image=" & $gProfileDefault[3][0] & @LF & "SizeX=64" & @LF & "SizeY=64" & @LF & "Transparency=100")
		IniWriteSection($gReturn[0], "Patterns", "")
	EndIf

	$gReturn[4] = IniRead($gReturn[0], "Target", "Image", "UUIDID.9CC09662-A476-4A7A-C40179A9D7DAD484.UUIDID") ; Image File.
	If Not FileExists($gProfileDefault[2][0] & $gReturn[4]) Then
		$gReturn[4] = $gProfileDefault[3][0]
		If Not FileExists($gProfileDefault[2][0] & $gReturn[4]) Then _ResourceSaveToFile(__GetDefault(128), "IMAGE")
		$gSize = __ImageSize($gProfileDefault[2][0] & $gReturn[4])
		IniWrite($gReturn[0], "Target", "Image", $gReturn[4])
		IniWrite($gReturn[0], "Target", "SizeX", $gSize[0])
		IniWrite($gReturn[0], "Target", "SizeY", $gSize[1])
		IniWrite($gReturn[0], "Target", "Transparency", 100)
	EndIf

	$gReturn[3] = $gProfileDefault[2][0] & $gReturn[4] ; Image File FullPath.
	$gReturn[5] = IniRead($gReturn[0], "Target", "SizeX", 64) ; Image SizeX
	$gReturn[6] = IniRead($gReturn[0], "Target", "SizeY", 64) ; Image SizeY
	$gReturn[7] = IniRead($gReturn[0], "Target", "Transparency", 100) ; Image Transparency
	$gReturn[8] = $gProfileDefault[2][0]

	If $gArray = 1 Then Return $gReturn[0] ; Profile Directory And Profile Name.
	If $gArray = 2 Then Return $gReturn[3] ; Image Directory And Image Name.
	Return $gReturn ; Array.
EndFunc   ;==>__GetProfile

Func __GUIInBounds($gGUI = $Global_GUI_1)
	#cs
		Description: Checks If The GUI Is Within View Of The Users Screen.
		Returns: Moves GUI If Out Of Bounds
	#ce
	Local $gDesktopWidth = _WinAPI_GetSystemMetrics(78), $gDesktopHeight = _WinAPI_GetSystemMetrics(79)
	Local $gGUIPos = WinGetPos($gGUI)
	If $gGUIPos[0] < 5 Then
		Local $gX = 5
	ElseIf ($gGUIPos[0] + $gGUIPos[2]) > $gDesktopWidth Then
		$gX = $gDesktopWidth - $gGUIPos[2] + 3
	Else
		$gX = $gGUIPos[0]
	EndIf
	If $gGUIPos[1] < 5 Then
		Local $gY = 5
	ElseIf ($gGUIPos[1] + $gGUIPos[3]) > $gDesktopHeight Then
		$gY = $gDesktopHeight - $gGUIPos[3] + 3
	Else
		$gY = $gGUIPos[1]
	EndIf
	WinMove($gGUI, "", $gX, $gY)
	__SetCurrentPosition() ; Set Current Coordinates/Position Of DropIt.
	Return 1
EndFunc   ;==>__GUIInBounds

Func __ImageConvert($iImage, $iSaveDirectory, $iConvertTo = "PNG")
	#cs
		Description: Converts The Image File To Another Valid Format.
		Returns: New Image [New Image.png]
	#ce
	Local $iCLSID = _GDIPlus_EncodersGetCLSID($iConvertTo)
	Local $iExtension = StringLower($iConvertTo)
	$iImage = _GDIPlus_ImageLoadFromFile($iImage)
	If StringRight($iSaveDirectory, 1) <> "\" Then $iSaveDirectory = $iSaveDirectory & "\"
	Local $iRandom = Int(Random(0, 5000))
	_GDIPlus_ImageSaveToFileEx($iImage, $iSaveDirectory & "Default_" & $iRandom & "." & $iExtension, $iCLSID)
	Return $iSaveDirectory & "Default_" & $iRandom & "." & $iExtension
EndFunc   ;==>__ImageConvert

Func __ImageResize($iImage, $iWidth, $iHeight, $iReturnImage = "")
	#cs
		Description: Resizes The Image File (In The Program Only) If Size Is Different To The Correct Size.
		Returns: New Image [Default New Size.png]
	#ce
	Local $iPreviousImage, $iGraphicsContent, $iNewImage, $iNewGraphicsContent

	$iPreviousImage = _GDIPlus_ImageLoadFromFile($iImage)
	$iGraphicsContent = _GDIPlus_ImageGetGraphicsContext($iPreviousImage)
	$iNewImage = _GDIPlus_BitmapCreateFromGraphics($iWidth, $iHeight, $iGraphicsContent)
	$iNewGraphicsContent = _GDIPlus_ImageGetGraphicsContext($iNewImage)
	_GDIPlus_GraphicsDrawImageRect($iNewGraphicsContent, $iPreviousImage, 0, 0, $iWidth, $iHeight)
	_GDIPlus_GraphicsDispose($iGraphicsContent)
	_GDIPlus_GraphicsDispose($iNewGraphicsContent)
	_GDIPlus_ImageDispose($iPreviousImage)
	If $iReturnImage = "" Then
		Return $iNewImage
	Else
		_GDIPlus_ImageSaveToFile($iNewImage, $iReturnImage)
		_GDIPlus_BitmapDispose($iNewImage)
		_GDIPlus_Shutdown()
		Return 1
	EndIf
EndFunc   ;==>__ImageResize

Func __ImageSize($iFileName) ; __ImageSize From: http://www.autoitscript.com/forum/topic/121275-how-to-get-size-of-pictures/page__view__findpost__p__842249
	#cs
		Description: Calculates The Correct Width And Height Of An Image.
		Returns:
		If FileExits Then Returns An Array[2]
		[0] - Width Of Image File [64]
		[1] - Height Of Image File [64]
		Or Returns An @error
	#ce
	If Not FileExists($iFileName) Then Return SetError(1, 1, 0)
	Local $iReturn[2]
	Local $iImage = _GDIPlus_ImageLoadFromFile($iFileName)
	$iReturn[0] = _GDIPlus_ImageGetWidth($iImage)
	$iReturn[1] = _GDIPlus_ImageGetHeight($iImage)
	_GDIPlus_ImageDispose($iImage)
	If @error Then Return SetError(1, 1, 0)
	Return $iReturn
EndFunc   ;==>__ImageSize

Func __ImageRelativeSize($iGUIWidth, $iGUIHeight, $iImageWidth, $iImageHeight)
	#cs
		Description: Calculates The Correct Width And Height Of An Image In A GUI.
		Returns: An Array[2]
		[0] - Width Of GUI [64]
		[1] - Height Of GUI [64]
	#ce
	If ($iImageWidth < 0) Or ($iImageHeight < 0) Then Return SetError(1, 1, 0)

	Local $iReturn[2] = [$iGUIWidth, $iGUIHeight]
	If $iImageWidth < $iImageHeight Then
		$iReturn[0] = Int($iGUIWidth * $iImageWidth / $iImageHeight)
		$iReturn[1] = Int($iGUIHeight)
	Else
		$iReturn[1] = Int($iGUIHeight * $iImageHeight / $iImageWidth)
		$iReturn[0] = Int($iGUIWidth)
	EndIf
	Return $iReturn
EndFunc   ;==>__ImageRelativeSize

Func __IniReadSection($iFile, $iSection) ; Taken From - http://www.autoitscript.com/forum/topic/32004-inireadsection-exceed-32kb-limit/page__p__229487#entry229487
	#cs
		Description: Reads all Key/Value pairs from a Section in a standard format INI File.
		Returns: @error Or $Array[?] - Array Contains Unlimited Number Of Items.
		[0][0] - Number Of Rows [3]

		[A][0] - Key [Example]
		[A][1] - Value [Test]
	#ce
	Local $iSize = FileGetSize($iFile) / 1024
	If $iSize <= 31 Then
		Local $iSectionRead = IniReadSection($iFile, $iSection)
		If @error Then Return SetError(@error, 0, "")
		Return $iSectionRead
	EndIf
	Local $iFileRead = @CRLF & FileRead($iFile) & @CRLF & '['
	$iSection = StringStripWS($iSection, 7)
	Local $iData = StringRegExp($iFileRead, '(?s)(?i)\n\s*\[\s*' & $iSection & '\s*\]\s*\r\n(.*?)\[', 3)
	If IsArray($iData) = 0 Then Return SetError(1, 0, 0)
	Local $iKey = StringRegExp(@LF & $iData[0], '\n\s*(.*?)\s*=', 3)
	Local $iValue = StringRegExp(@LF & $iData[0], '\n\s*.*?\s*=(.*?)\r', 3)
	Local $iUbound = UBound($iKey)
	Local $iSectionReturn[$iUbound + 1][2]
	$iSectionReturn[0][0] = $iUbound
	For $A = 0 To $iUbound - 1
		$iSectionReturn[$A + 1][0] = $iKey[$A]
		$iSectionReturn[$A + 1][1] = $iValue[$A]
	Next
	Return $iSectionReturn
EndFunc   ;==>__IniReadSection

Func __InstalledCheck()
	#cs
		Description: Configures DropIt If Installed.
		Returns: Profile Directory [C:\Program Files\DropIt\Profiles\]
	#ce

	If Not __IsInstalled() Then Return SetError(1, 1, 0) ; __IsInstalled() = Checks If DropIt Is Installed.
	Local $iPortable = __GetDefault(66, 1) ; Get Profile Directory & Settings INI File With Installed Checking Skipped.
	Local $iInstalled = __GetDefault(3, 0) ; Get Default Directories.

	If FileExists($iPortable[1][0]) Then ; Profiles Directory.
		DirCopy($iPortable[1][0], $iInstalled[2][0], 1)
		If Not @error Then DirRemove($iPortable[1][0], 1)
	EndIf
	If FileExists($iPortable[2][0]) Then ; Settings INI File.
		FileCopy($iPortable[2][0], $iInstalled[1][0], 9)
		If Not @error Then FileDelete($iPortable[2][0])
	EndIf

	If Not @error Then Return $iInstalled[1][0]
	Return $iPortable[1][0]
EndFunc   ;==>__InstalledCheck

Func __Is($iData, $iINI = -1, $iDefault = "True")
	#cs
		Description: For INI Parameters That Use True/False Results, Therefore It Can Be Called As If __Is("DropItOn") Then ... , Simply Means If DropItOn Is True.
		Returns: True/False
	#ce
	If $iINI = -1 Then $iINI = __IsSettingsFile() ; Get Default Settings INI File.
	Return IniRead($iINI, "General", $iData, $iDefault) = "True"
	Return "False"
EndFunc   ;==>__Is

Func __IsCurrentProfile($iProfile)
	#cs
		Description: Checks If A Profile Is The Current Profile.
		Returns: True/False
	#ce
	Local $iCurrentProfile = __GetCurrentProfile() ; Get Current Profile From The Settings INI File.
	Return StringCompare($iProfile, $iCurrentProfile) = 0
EndFunc   ;==>__IsCurrentProfile

Func __IsFolder($iFolder)
	#cs
		Description: Checks Whether A Path String Is A Directory/Folder.
		Returns:
		If Directory/Folder Returns 1
		If Not Directory/Folder Returns 0
	#ce
	If StringInStr(FileGetAttrib($iFolder), "D") Then Return 1
	Return 0
EndFunc   ;==>__IsFolder

Func __IsInstalled()
	#cs
		Description: Checks If DropIt Is Installed.
		Returns:
		If unins000.exe Exists Returns 1
		If Not unins000.exe Exists Returns 0
	#ce
	Return FileExists(@ScriptDir & "\unins000.exe") = 1
EndFunc   ;==>__IsInstalled

Func __IsHandle($iParentWindow = -1)
	#cs
		Description: Checks If GUI Handle Is A Valid Handle.
		Returns:
		If True Returns The Handle.
		If False Returns The AutoIt Hidden Handle.
	#ce
	If IsHWnd($iParentWindow) Then Return $iParentWindow
	Return WinGetHandle(AutoItWinGetTitle())
EndFunc   ;==>__IsHandle

Func __IsOnTop($iHandle = $Global_GUI_1)
	#cs
		Description: Sets A GUI Handle "OnTop" If True/False In The Settings INI File.
		Returns: GUI OnTop Or Not OnTop
	#ce
	$iHandle = __IsHandle($iHandle) ; Checks If GUI Handle Is A Valid Handle.

	Local $iState = 0
	If __Is("OnTop") Then $iState = 1
	WinSetOnTop($iHandle, "", $iState)
	Return $iState
EndFunc   ;==>__IsOnTop

Func __IsProfile($iProfile = -1, $iArray = 0)
	#cs
		Description: Proivides Details Of The Current Profile [-1] Or Specified Profile Name [Valid Profile Name].
		Returns:
		If $iArray = 0 Then Returns An Array[9]
		[0] - Profile Full Path [C:\Program Files\DropIt\Profiles\ProfileName.ini]
		[1] - Profile Name [ProfileName]
		[2] - Profile Directory [C:\Program Files\DropIt\Profiles\]
		[3] - Image Full Path [C:\Program Files\DropIt\Images\Default.png]
		[4] - Image Name [Default.png]
		[5] - Image Width Size [64]
		[6] - Image Height Size [64]
		[7] - Image Transparency [100] (Percentage)
		[8] - Image Directory [C:\Program Files\DropIt\Images\]
		If $iArray = 1 Then Returns Profile Full Path [C:\Program Files\DropIt\Profiles\ProfileName.ini]
		If $iArray = 2 Then Returns Image Full Path [C:\Program Files\DropIt\Images\Default.png]
	#ce
	Local $iINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $iProfileDirectory = __GetDefault(2) ; Get Default Profile Directory.

	Local $iUbound
	If Not IsArray($iProfile) And $iProfile <> -1 Or $iProfile <> 0 Or $iProfile <> "" Then
		If FileExists($iProfileDirectory & $iProfile & ".ini") Then Return __GetProfile($iINI, $iProfile, $iProfileDirectory, $iArray)
	EndIf

	$iUbound = UBound($iProfile)
	If $iUbound <> 9 Then Return __GetProfile($iINI, $iProfile, $iProfileDirectory, $iArray)
	Return __GetProfile($iINI, $iProfile[1], $iProfileDirectory, $iArray)
EndFunc   ;==>__IsProfile

Func __IsProfileUnique($iHandle, $iProfile)
	#cs
		Description: Checks If A Profile Name Is Unique.
		Returns: True = ProfileName & False = @error
	#ce
	Local $iProfileList = __ProfileList() ; Get Array Of All Profiles.
	$iProfile = StringReplace(StringStripWS($iProfile, 7), " ", "_")
	For $A = 1 To $iProfileList[0] ; Check If the Profile Name Already Exists.
		$iProfileList[$A] = StringReplace(StringStripWS($iProfileList[$A], 7), " ", "_")
		Local $iStringCompare = StringCompare($iProfileList[$A], $iProfile, 0)
		If $iStringCompare = 0 Then
			MsgBox(0x40, __Lang_Get('PROFILEUNIQUE_MSGBOX_0', 'Name not available'), __Lang_Get('PROFILEUNIQUE_MSGBOX_1', 'This profile name already exists.'), 0, __OnTop($iHandle))
			Return SetError(1, 1, $iProfile)
		EndIf
		If $A = $iProfileList[0] Then ExitLoop
	Next
	Return $iProfile
EndFunc   ;==>__IsProfileUnique

Func __IsReadOnly($iFilePath)
	#cs
		Description: Checks Whether A File Is Read-Only.
		Returns:
		If Read-Only Returns 1
		If Not Read-Only Returns 0
	#ce
	If StringInStr(FileGetAttrib($iFilePath), "R") Then Return 1
	Return 0
EndFunc   ;==>__IsReadOnly

Func __IsSettingsFile($iINI = -1, $iShowLang = 1)
	#cs
		Description: Provides A Valid Location Of The Settings INI File.
		Returns: Settings INI File [C:\Program Files\DropIt\Settings.ini]
	#ce
	Local $iFileExists, $iFileGetSize, $iINIData

	If $iINI = -1 Or $iINI = 0 Or $iINI = "" Then $iINI = __GetDefault(64) ; Get Default Settings FullPath.
	$iFileExists = FileExists($iINI)
	$iFileGetSize = FileGetSize($iINI)

	If $iFileExists And $iFileGetSize <> 0 Then Return $iINI

	If Not $iFileExists Or $iFileGetSize = 0 Then
		$iINIData = "Version=" & $Global_CurrentVersion & @LF & "Profile=Default" & @LF & "Language=English" & @LF & "PosX=-1" & @LF & "PosY=-1" & @LF & _
				"OnTop=True" & @LF & "LockPosition=False" & @LF & "CustomTrayIcon=False" & @LF & "MultipleInstances=False" & @LF & "StartAtStartup=False" & @LF & _
				"UseSendTo=False" & @LF & "SendToMode=Permanent" & @LF & "ShowSorting=True" & @LF & "ProfileEncryption=False" & @LF & "DirForFolders=False" & @LF & _
				"IgnoreNew=False" & @LF & "AutoDup=False" & @LF & "DupMode=Overwrite" & @LF & "CreateLog=False" & @LF & "IntegrityCheck=False" & @LF & "SafetyErase=False" & @LF & _
				"SizeMessage=True" & @LF & "ArchiveFormat=ZIP" & @LF & "ArchiveLevel=Normal" & @LF & "ArchiveMethod=LZMA" & @LF & "ArchiveSelf=False" & @LF & _
				"ArchiveEncrypt=False" & @LF & "ArchiveEncryptMethod=AES-256" & @LF & "ArchivePassword=" & @LF & "MasterPassword=" & @LF & "ColumnCustom=95;95;60;50" & @LF & "ColumnManage=115;85;190"
		IniWriteSection($iINI, "General", $iINIData)
		IniWriteSection($iINI, "EnvironmentVariables", "")
		If $iShowLang Then __Lang_GUI() ; Skip Language Selection If $iShowLang = 0
	EndIf
	Return $iINI
EndFunc   ;==>__IsSettingsFile

Func __IsSupported($iFileName, $iFormats = "exe")
	#cs
		Description: Checks If A File Is Supported.
		Returns: 1 = True Or 0 = False
	#ce
	If StringRight($iFileName, 1) <> "." Then $iFileName = "." & $iFileName
	If StringRegExp($iFormats, "\\|/|:|\<|\>|\|") Then Return SetError(1, 2, "")
	$iFormats = "*." & StringReplace(StringStripWS(StringRegExpReplace($iFormats, "\s*;\s*", ";"), 3), ";", "|*.")
	Local $iFormats_Mask = "(?i)^" & StringReplace(StringReplace(StringReplace($iFormats, ".", "\."), "*", ".*"), "?", ".") & "\z"
	Return StringRegExp($iFileName, $iFormats_Mask)
EndFunc   ;==>__IsSupported

Func __Lang_Combo($lComboBox)
	#cs
		Description: Gets Languages And Create String For Use In A Combo Box.
		Returns: String Of Languages.
	#ce
	Local $lCurrentLanguage = __GetCurrentLanguage()
	Local $lIndex
	Local $lImageList = $Global_ImageList
	Local $lLanguageDefault = __GetDefault(1024) ; Get Default Language Directory.

	Local $lLanguageList = __Lang_List()
	If $lLanguageList[0] = 0 Then Local $lLanguageList[2] = [1, $lCurrentLanguage] ; Show Default Language & NoFlag.
	For $A = 1 To $lLanguageList[0]
		$lIndex = _GUICtrlComboBoxEx_AddString($lComboBox, $lLanguageList[$A], $A - 1, $A - 1)
		__SetItemImageEx($lComboBox, $lIndex, $lImageList, $lLanguageDefault & $lLanguageList[$A] & ".gif", 2)
		If $lCurrentLanguage == $lLanguageList[$A] Then _GUICtrlComboBoxEx_SetCurSel($lComboBox, $lIndex)
	Next
	Return 1
EndFunc   ;==>__Lang_Combo

Func __Lang_Get($lData, $lDefault, $lNotExpand = 0)
	#cs
		Description: Get Translated String Of The Current Language.
		Returns: Translated String.
	#ce

	Local $lLanguage = __GetCurrentLanguage() ; Get Current Language Profile.

	$lData = IniRead(__GetDefault(1024) & $lLanguage & ".lng", $lLanguage, $lData, $lDefault) ; __GetDefault(1024) = Get Default Language Directory.
	If $lNotExpand = 0 Then
		$lData = _WinAPI_ExpandEnvironmentStrings($lData)
		If @error Then $lData = _WinAPI_ExpandEnvironmentStrings($lDefault)
	EndIf
	$lData = StringReplace($lData, "@CRLF", " @CRLF ")
	$lData = StringReplace($lData, "@CR", " @CR ")
	$lData = StringReplace($lData, "@LF", " @LF ")
	$lData = StringReplace($lData, "@TAB", " @TAB ")
	$lData = StringStripWS($lData, 4)
	$lData = StringReplace($lData, "@CRLF ", @CRLF)
	$lData = StringReplace($lData, "@CR ", @CR)
	$lData = StringReplace($lData, "@LF ", @LF)
	$lData = StringReplace($lData, "@TAB ", @TAB)
	Return $lData
EndFunc   ;==>__Lang_Get

Func __Lang_GUI()
	#cs
		Description: Select Language.
		Returns: Writes Selected Language To The Settings INI File.
	#ce
	Local $lLanguage
	Local $lGUI = GUICreate('Language Choice', 230, 70, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop())
	Local $lLanguageCombo = _GUICtrlComboBoxEx_Create($lGUI, "", 5, 10, 220, 200, 0x0003)

	Local $lImageList = _GUIImageList_Create(16, 16, 5, 3) ; Creates An ImageList.
	_GUICtrlComboBoxEx_SetImageList($lLanguageCombo, $lImageList)
	$Global_ImageList = $lImageList

	__Lang_Combo($lLanguageCombo)
	Local $lOK = GUICtrlCreateButton("&OK", 150, 40, 75, 25)
	GUICtrlSetState($lOK, 576)
	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case -3, $lOK
				ExitLoop

		EndSwitch
	WEnd
	_GUICtrlComboBoxEx_GetItemText($lLanguageCombo, _GUICtrlComboBoxEx_GetCurSel($lLanguageCombo), $lLanguage)
	__SetCurrentLanguage($lLanguage) ; Sets The Selected Language To The Settings INI File.

	GUIDelete($lGUI)
	_GUIImageList_Destroy($lImageList)
	Return $lLanguage
EndFunc   ;==>__Lang_GUI

Func __Lang_List()
	#cs
		Description: Proivides Details Of The Languages In The Languages Directory.
		Returns: $Array[?] - Array Contains Unlimited Number Of Items.
		[0] - Number Of Rows [3]
		[1] - Language 1 [First Language]
		[2] - Language 2 [Second Language]
		[3] - Language 3 [Third Language]
	#ce
	Local $lSearch, $lFile, $lLanguageList[2] = [0]
	Local $lLanguageDefault = __GetDefault(1024) ; Get Default Language Directory.

	$lSearch = FileFindFirstFile($lLanguageDefault & "*.lng")
	If $lSearch = -1 Then
		Return $lLanguageList
	EndIf
	While 1
		$lFile = FileFindNextFile($lSearch)
		If @error Then ExitLoop
		If UBound($lLanguageList, 1) <= $lLanguageList[0] + 1 Then ReDim $lLanguageList[UBound($lLanguageList, 1) * 2] ; ReDim's $lLanguageList If More Items Are Required.
		$lLanguageList[0] += 1
		$lLanguageList[$lLanguageList[0]] = StringRegExpReplace($lFile, "^.*\\|\..*$", "")
	WEnd
	FileClose($lSearch)

	ReDim $lLanguageList[$lLanguageList[0] + 1] ; Delete Empty Rows.
	Return $lLanguageList
EndFunc   ;==>__Lang_List

Func __Log_Reduce($lLogFile)
	#cs
		Description: Reduces The Size Of The LogFile.
		Returns: Nothing
	#ce
	Local $lFileGetSize, $lFileRead, $lStringInStr, $lFileOpen, $lFileWrite

	$lFileGetSize = FileGetSize($lLogFile)
	If $lFileGetSize > 3072 * 1024 Then ; 3072 KB Is The Same As 3 MB.
		$lFileRead = FileRead($lLogFile)
		If @error Then Return SetError(1, 1, 0)

		$lStringInStr = StringInStr($lFileRead, @CRLF, 0, -1, $lFileGetSize / 2)
		If Not $lStringInStr Then Return SetError(1, 1, 0)

		$lFileRead = StringTrimLeft($lFileRead, $lStringInStr + 3)
		$lFileOpen = FileOpen($lLogFile, 2)
		$lFileWrite = FileWrite($lFileOpen, $lFileRead)
		FileClose($lFileOpen)

		If Not $lFileWrite Then Return SetError(1, 1, 0)
	EndIf
EndFunc   ;==>__Log_Reduce

Func __Log_Write($lFunction = "", $lData = "")
	#cs
		Description: Writes Log Line To The Console In SciTE.
		Returns: A Log Line [__IsSettingsFile Check ==> C:\Program Files\DropIt\Settings.ini (00:00:00)]
	#ce
	If __Is("CreateLog") Then
		Local $lFileOpen, $lLogFile = __GetDefault(513) ; Get Default Directory & LogFile File Name.

		__Log_Reduce($lLogFile[1][0] & $lLogFile[2][0])
		$lFileOpen = FileOpen($lLogFile[1][0] & $lLogFile[2][0], 1)
		FileWriteLine($lFileOpen, $lFunction & " ==> " & $lData & " (" & @HOUR & ":" & @MIN & ":" & @SEC & ")")
		If StringInStr($lFunction, __Lang_Get('DROPIT_CLOSED', 'DropIt Closed')) Or StringInStr($lFunction, __Lang_Get('LOG_DISABLED', 'Log Disabled')) Then FileWriteLine($lFileOpen, "")
		FileClose($lFileOpen)
	EndIf
	Return 1
EndFunc   ;==>__Log_Write

Func __MD5ForFile($mFile, $mRead = 100) ; Taken From: http://www.autoitscript.com/forum/topic/95558-crc32-md4-md5-sha1-for-files/
	If $mRead > 100 Then $mRead = 100
	Local $mFileSize = FileGetSize($mFile)
	$mRead = ($mRead / 100) * $mFileSize

	Local $mResult = DllCall("kernel32.dll", "hwnd", "CreateFileW", "wstr", $mFile, "dword", 0x80000000, "dword", 1, "ptr", 0, "dword", 3, "dword", 0, "ptr", 0)
	If @error Or $mResult[0] = -1 Then Return SetError(1, 1, 0)
	Local $mFileOpen = $mResult[0]
	$mResult = DllCall("kernel32.dll", "ptr", "CreateFileMappingW", "hwnd", $mFileOpen, "dword", 0, "dword", 2, "dword", 0, "dword", 0, "ptr", 0)
	If @error Or Not $mResult[0] Then
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $mFileOpen)
		Return SetError(1, 2, 0)
	EndIf
	DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $mFileOpen)
	Local $mFileOpenMappingObject = $mResult[0]
	$mResult = DllCall("kernel32.dll", "ptr", "MapViewOfFile", "hwnd", $mFileOpenMappingObject, "dword", 4, "dword", 0, "dword", 0, "dword", $mRead)
	If @error Or Not $mResult[0] Then
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $mFileOpenMappingObject)
		Return SetError(1, 3, 0)
	EndIf
	Local $mTempFile = $mResult[0]
	Local $mBufferSize = $mRead
	Local $mTempResult = DllStructCreate("dword i[2];" & "dword buf[4];" & "ubyte in[64];" & "ubyte digest[16]")
	DllCall("advapi32.dll", "none", "MD5Init", "ptr", DllStructGetPtr($mTempResult))
	If @error Then
		DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $mTempFile)
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $mFileOpenMappingObject)
		Return SetError(1, 4, 0)
	EndIf
	DllCall("advapi32.dll", "none", "MD5Update", "ptr", DllStructGetPtr($mTempResult), "ptr", $mTempFile, "dword", $mBufferSize)
	If @error Then
		DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $mTempFile)
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $mFileOpenMappingObject)
		Return SetError(1, 5, 0)
	EndIf
	DllCall("advapi32.dll", "none", "MD5Final", "ptr", DllStructGetPtr($mTempResult))
	If @error Then
		DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $mTempFile)
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $mFileOpenMappingObject)
		Return SetError(1, 6, 0)
	EndIf
	DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $mTempFile)
	DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $mFileOpenMappingObject)
	Local $mCheckSum = Hex(DllStructGetData($mTempResult, "digest"))
	Return SetError(0, 0, $mCheckSum)
EndFunc   ;==>__MD5ForFile

Func __OnTop($iHandle = -1, $iState = 1)
	#cs
		Description: Sets A GUI Handle "OnTop".
		Returns: GUI OnTop
	#ce
	$iHandle = __IsHandle($iHandle) ; Checks If GUI Handle Is A Valid Handle.

	WinSetOnTop($iHandle, "", $iState)
	Return $iHandle
EndFunc   ;==>__OnTop

Func __Password_GUI()
	#cs
		Description: Enter Master Password.
		Returns: Allows To Start DropIt If Password Is Correct.
	#ce
	Local $pINI = __IsSettingsFile() ; Get Default Settings INI File.
	If Not __Is("ProfileEncryption", $pINI) Or Not FileExists(__GetDefault(1) & "Profiles.dat") Then Return 1

	Local $pPW, $pPW_Code = $Global_Password_Key
	Local $pMasterPassword, $pOK, $pCancel, $pStart = 1, $pPWFailedAttempts
	Local $pGUI = GUICreate(__Lang_Get('PASSWORD_MSGBOX_0', 'Enter Password'), 240, 80, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop())

	$pMasterPassword = GUICtrlCreateInput("", 15, 15, 210, 20, 0x0020)
	$pOK = GUICtrlCreateButton("&" & __Lang_Get('OK', 'OK'), 120 - 15 - 76, 45, 76, 25)
	GUICtrlSetState($pOK, 144) ; Disable OK Button Initially.
	$pCancel = GUICtrlCreateButton("&" & __Lang_Get('CANCEL', 'Cancel'), 120 + 15, 45, 76, 25)
	GUISetState(@SW_SHOW)
	ControlClick($pGUI, "", $pMasterPassword)

	While 1

		; Enable/Disable OK Button.
		If GUICtrlRead($pMasterPassword) <> "" And Not StringIsSpace(GUICtrlRead($pMasterPassword)) Then
			If GUICtrlGetState($pOK) > 80 Then GUICtrlSetState($pOK, 576) ; 80 = Normal; 144 = Disabled; 576 = Focused.
			If GUICtrlGetState($pCancel) = 512 Then GUICtrlSetState($pCancel, 80) ; 80 = Normal; 144 = Disabled; 576 = Focused.
		ElseIf GUICtrlRead($pMasterPassword) = "" Or StringIsSpace(GUICtrlRead($pMasterPassword)) Then
			If GUICtrlGetState($pOK) = 80 Then GUICtrlSetState($pOK, 144) ; 80 = Normal; 144 = Disabled; 576 = Focused.
			If GUICtrlGetState($pCancel) = 80 Then GUICtrlSetState($pCancel, 512) ; 80 = Normal; 144 = Disabled; 576 = Focused.
		EndIf

		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $pCancel
				$pStart = 0
				ExitLoop

			Case $pOK
				$pPW = IniRead($pINI, "General", "MasterPassword", "")
				$pPWFailedAttempts += 1
				If StringCompare(GUICtrlRead($pMasterPassword), _StringEncrypt(0, $pPW, $pPW_Code), 1) <> 0 Then
					MsgBox(0x30, __Lang_Get('PASSWORD_MSGBOX_1', 'Password Not Correct') & ' - ' & $pPWFailedAttempts, __Lang_Get('PASSWORD_MSGBOX_2', 'You have to enter the correct password to use DropIt.'), 0, __OnTop($pGUI))
					GUICtrlSetData($pMasterPassword, "")
					ControlClick($pGUI, "", $pMasterPassword)
					If $pPWFailedAttempts > 2 Then ; 3 Attempts At Entering The Password.
						$pStart = 0
						ExitLoop
					EndIf
				Else
					$pStart = 1
					ExitLoop
				EndIf

		EndSwitch
	WEnd

	GUIDelete($pGUI)
	If $pStart = 0 Then Exit ; Close DropIt If Password Is Wrong.

	__EncryptionFolder(1) ; Decrypt Profiles.
	Return 1
EndFunc   ;==>__Password_GUI

Func __PathGetDrive($pFilePath) ; Taken From: http://www.autoitscript.com/forum/topic/82954-securely-overwrite-files/
	#cs
		Description: Get The Drive Letter Of An Absolute Or Relative Path.
		Returns: Drive Letter.
	#ce
	If StringInStr($pFilePath, ":") Then Return StringRegExpReplace($pFilePath, "^.*([[:alpha:]]:).*$", "${1}\\") ; Full Or Unc Path
	Return StringRegExpReplace(@WorkingDir, "^([[:alpha:]]:).*$", "${1}\\") ; Relative Path, Use Current Drive
EndFunc   ;==>__PathGetDrive

Func __ProfileList($lLimit = 20, $lLimitCheck = 0) ; If -1 Is Declared It Will List All Profile INI Files E.G. $Profiles = __ProfileList(-1)
	#cs
		Description: Proivides Details Of The Profiles In The Profiles Directory.
		Returns: $Array[?] - Array Contains Unlimited Number Of Items.
		[0] - Number Of Rows [3]
		[1] - Profile Name 1 [First Profile Name]
		[2] - Profile Name 2 [Second Profile Name]
		[3] - Profile Name 3 [Third Profile Name]
	#ce
	Local $lSearch, $lFile, $lProfileList[2] = [0]

	$lSearch = FileFindFirstFile(__GetDefault(2) & "*.*") ; __GetDefault(2) = Get Default Profile Directory.
	If $lSearch = -1 Then Return $lProfileList
	While 1
		$lFile = FileFindNextFile($lSearch)
		If @error Then ExitLoop
		If $lLimit <> -1 And $lProfileList[0] = $lLimit Then ExitLoop
		If UBound($lProfileList, 1) <= $lProfileList[0] + 1 Then ReDim $lProfileList[UBound($lProfileList, 1) * 2] ; ReDim's $lProfileList If More Items Are Required.
		If StringRight($lFile, 3) = ("ini" Or "dat") Then
			$lProfileList[0] += 1
			$lProfileList[$lProfileList[0]] = StringRegExpReplace($lFile, "^.*\\|\..*$", "")
		EndIf
	WEnd
	FileClose($lSearch)

	ReDim $lProfileList[$lProfileList[0] + 1] ; Delete Empty Rows.
	If Not @error And $lLimit <> -1 And $lLimitCheck = 1 Then
		If $lProfileList[0] = $lLimit Then Return 1
		Return 0
	EndIf

	If Not @error And $lLimitCheck = 0 Then Return $lProfileList
	Return SetError(1, 1, 0)
EndFunc   ;==>__ProfileList

Func __ProfileList_Combo()
	#cs
		Description: Gets Profiles And Create String For Use In A Combo Box.
		Returns: String Of Profiles.
	#ce
	Local $pData
	Local $pProfileList = __ProfileList()
	For $A = 1 To $pProfileList[0]
		If @error Then ExitLoop
		$pData &= $pProfileList[$A] & "|"
	Next
	Return StringTrimRight($pData, 1)
EndFunc   ;==>__ProfileList_Combo

Func __ProfileList_GUI($cProfileName = -1)
	#cs
		Description: Select Profile From ProfileList.
		Returns: Nothing
	#ce
	Local $lFlicker = 1 ; Stop Flickering For XP & Vista
	Local $cProfileList[2] = [1, $cProfileName]
	If $cProfileList[1] = -1 Then
		$cProfileList = __ProfileList() ; Get Array Of All Profiles.
	EndIf

	Local $cProfile = __GetCurrentProfile() ; Get Current Profile From The Settings INI File.
	Local $lGUI = GUICreate(__Lang_Get('PROFILELIST_GUI_LABEL_0', 'Select A Profile'), 230, 70, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop())
	WinSetTrans($lGUI, "", 0)
	Local $lCombo = GUICtrlCreateCombo("", 5, 10, 220, 25, 0x0003)
	For $A = 1 To $cProfileList[0]
		GUICtrlSetData($lCombo, $cProfileList[$A], $cProfile)
	Next
	Local $lOK = GUICtrlCreateButton("&" & __Lang_Get('OK', 'OK'), 150, 40, 75, 25)
	GUICtrlSetState($lOK, 576)
	GUISetState(@SW_SHOW)

	While 1
		If $cProfileList[0] = 1 And $lFlicker = 1 Then ; If There Is Only 1 Profile Then Return This As A Selection.
			GUISetState(@SW_HIDE)
			GUIDelete($lGUI)
			Return $cProfileList[1]
		ElseIf $cProfileList[0] > 1 And $lFlicker = 1 Then
			WinSetTrans($lGUI, "", 255)
			$lFlicker = 0
		EndIf

		Switch GUIGetMsg()
			Case -3
				GUIDelete($lGUI)
				Return SetError(1, 1, 0)

			Case $lOK
				ExitLoop

		EndSwitch
	WEnd
	$cProfile = GUICtrlRead($lCombo)

	GUIDelete($lGUI)
	Return $cProfile
EndFunc   ;==>__ProfileList_GUI

Func __ReduceMemory($rPID = -1)
	#cs
		Description: Reduces Memory Of Current Process [-1] Or Another Process [DropIt.exe] If Specified.
		Returns: Reduces The Memory Of A Valid Process Or Returns An @error.
	#ce
	If $rPID <> -1 Then
		Local $rHandle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $rPID)
		Local $rReturn = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $rHandle[0])
		DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $rHandle[0])
	Else
		$rReturn = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
	EndIf
	Return $rReturn[0]
EndFunc   ;==>__ReduceMemory

Func __ScriptRestart($sExit = 1)
	#cs
		Description: Restarts The Running Process. [Not Used In DropIt! But Might Be Soon.]
		Returns: Nothing
	#ce
	If Not IsDeclared("Global_ScriptRestart") Then Global $Global_ScriptRestart = 0
	$CmdLineRaw = ""
	If Not $Global_ScriptRestart Then
		If @Compiled Then
			Local $sPid = Run(@ScriptFullPath & ' ' & $CmdLineRaw, @ScriptDir, Default, 1)
		Else
			$sPid = Run(@AutoItExe & ' "' & @ScriptFullPath & '" ' & $CmdLineRaw, @ScriptDir, Default, 1)
		EndIf
		If @error Then
			Return SetError(@error, 0, 0)
		EndIf
		StdinWrite($sPid, @AutoItPID)
	EndIf
	$Global_ScriptRestart = 1
	If $sExit Then
		Sleep(50)
		Exit
	EndIf
	Return 1
EndFunc   ;==>__ScriptRestart

Func __SecureFileDelete($sFile, $sRename = True, $sFileTime = True, $sDelete = True, $sPatterns = -1, $sBlock = 32768) ; Taken From: http://www.autoitscript.com/forum/topic/82954-securely-overwrite-files/
	#cs
		Description: Securely Delete A File.
		Returns: Deleted File.
	#ce
	If Not FileExists($sFile) Then Return SetError(1, 0, 0)
	If $sPatterns <> -1 And Not IsArray($sPatterns) Then Return SetError(2, 0, 0)
	If $sPatterns = -1 Then ; Default Patterns.
		Local $sPatterns[3] ; DoD 3-Pass Method:
		$sPatterns[0] = Random(0, 255, 1)
		$sPatterns[1] = BitAND(BitNOT($sPatterns[0]), 0xFF)
		$sPatterns[2] = Random(0, 255, 1)
	Else
		For $A = 0 To UBound($sPatterns) - 1
			If ($sPatterns[$A] < 0) Or ($sPatterns[$A] > 255) Then Return SetError(2, 0, 0)
		Next
	EndIf

	Local $sFileOpen = __SecureFileDelete_CreateFile($sFile, $GENERIC_WRITE, 0, $OPEN_EXISTING, 0xB0000000) ; FILE_FLAG_RANDOM_ACCESS | FILE_FLAG_NO_BUFFERING | FILE_FLAG_WRITE_THROUGH
	If Not $sFileOpen Then Return SetError(3, 0, 0)
	Local $sFileGetSize = _WinAPI_GetFileSizeEx($sFileOpen)

	Local $ClusterSize = __SecureFileDelete_GetDiskClusterSize($sFile)
	If @error Then $ClusterSize = 512

	$sBlock = Ceiling($sBlock / $ClusterSize) * $ClusterSize
	Local $sBuffer = _MemVirtualAlloc(0, $sBlock, $MEM_COMMIT, $PAGE_READWRITE)
	Local $sCycle = Ceiling($sFileGetSize / $sBlock)
	Local $sBytes, $sError = 0

	For $A = 0 To (UBound($sPatterns) - 1)
		DllCall("msvcrt.dll", "ptr:cdecl", "memset", "ptr", $sBuffer, "int", $sPatterns[$A], "ulong_ptr", $sBlock)
		For $B = 1 To $sCycle
			If Not _WinAPI_WriteFile($sFileOpen, $sBuffer, $sBlock, $sBytes) Then
				$sError = 1
				ExitLoop 2
			EndIf
		Next
		DllCall("kernel32.dll", "bool", "SetFilePointerEx", "handle", $sFileOpen, "int64", 0, "ptr", 0, "dword", 0)
	Next
	_MemVirtualFree($sBuffer, 0, $MEM_RELEASE)
	_WinAPI_CloseHandle($sFileOpen)
	If $sError Then Return SetError(4, 0, 0)
	If $sRename Then
		Local $sDir = StringRegExpReplace($sFile, "^(.*)\\.*?$", "${1}")
		Local $sTempFile
		For $A = 1 To 10 ; Rename The File 10 Times.
			$sTempFile = _TempFile($sDir)
			FileMove($sFile, $sTempFile)
			$sFile = $sTempFile
		Next
	EndIf
	If $sFileTime Then
		For $A = 0 To 2
			FileSetTime($sFile, "19800101000001", $A)
		Next
	EndIf
	If $sDelete Then FileDelete($sFile)
	Return $sFile
EndFunc   ;==>__SecureFileDelete

Func __SecureFolderDelete($sFolder, $sRename = True, $sFileTime = True, $sDelete = True, $sPatterns = -1, $sBlock = 32768)
	#cs
		Description: Securely Delete A Folder.
		Returns: 1
	#ce
	If Not __IsFolder($sFolder) Or Not FileExists($sFolder) Then Return SetError(1, 0, 0)
	Local $sSearch, $sFile

	$sSearch = FileFindFirstFile($sFolder & '\*.*')
	If $sSearch = -1 Then
		Switch @error
			Case 1 ; Folder Is Empty.
				DirRemove($sFolder, 1)
			Case Else
				Return SetError(-1, 0, 0)
		EndSwitch
	EndIf
	While 1
		$sFile = FileFindNextFile($sSearch)
		If @error Then ; No More Files/Folders Match The Search.
			FileClose($sSearch)
			DirRemove($sFolder, 1)
			Return 1
		EndIf
		If @extended Then ; If Selected Item Is A Folder.
			__SecureFolderDelete($sFile, $sRename, $sFileTime, $sDelete, $sPatterns, $sBlock)
			If @error Then ExitLoop
		Else
			__SecureFileDelete($sFile, $sRename, $sFileTime, $sDelete, $sPatterns, $sBlock)
			If @error Then ExitLoop
		EndIf
	WEnd
	FileClose($sSearch)

	Return SetError(1, 0, 0)
EndFunc   ;==>__SecureFolderDelete

Func __SendTo_Install()
	#cs
		Description: Creates Shortcuts In The SendTo Folder. [DropIt (Profile_Name).lnk]
		Returns: 1
	#ce
	Local $sSendTo_Directory = __WinAPI_ShellGetSpecialFolderPath(0x0009) ; 0x0009 = $sCSIDL_SENDTO
	Local $sFileListToArray = __ProfileList() ; Get Array Of All Profiles.
	For $A = 1 To $sFileListToArray[0]
		FileCreateShortcut(@AutoItExe, $sSendTo_Directory & "\DropIt (" & $sFileListToArray[$A] & ").lnk", @ScriptDir, "-" & $sFileListToArray[$A])
	Next
	Return 1
EndFunc   ;==>__SendTo_Install

Func __SendTo_Uninstall()
	#cs
		Description: Deletes Shortcuts In The SendTo Folder. [DropIt (Profile_Name).lnk]
		Returns: 1
	#ce
	Local $sSendTo_Directory = __WinAPI_ShellGetSpecialFolderPath(0x0009) ; 0x0009 = $sCSIDL_SENDTO
	Local $sFileListToArray = _FileListToArray($sSendTo_Directory)
	Local $FileGetShortcut
	For $A = 1 To $sFileListToArray[0]
		If StringLeft($sFileListToArray[$A], StringLen("DropIt")) == "DropIt" Then
			$FileGetShortcut = FileGetShortcut($sSendTo_Directory & "\" & $sFileListToArray[$A])
			If $FileGetShortcut[0] = @AutoItExe Then
				FileDelete($sSendTo_Directory & "\" & $sFileListToArray[$A])
			EndIf
		EndIf
	Next
	Return 1
EndFunc   ;==>__SendTo_Uninstall

Func __SetBitmap($sGUI, $sImage, $sOpacity, $sWidth, $sHeight)
	#cs
		Description: Sets An Image File To A GUI Handle.
		Returns: Image Name [Default.png]
	#ce
	Local $sGetDC, $sCompDC, $sBitmap, $sObject, $sTagSize, $sPtrSize, $sTagSource, $sPtrSource, $sTagBlend, $sPtrBlend, $sReturnImage

	$sImage = __ImageResize($sImage, $sWidth, $sHeight)
	$sReturnImage = $sImage

	$sGetDC = _WinAPI_GetDC(0)
	$sCompDC = _WinAPI_CreateCompatibleDC($sGetDC)
	$sBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($sImage)
	$sObject = _WinAPI_SelectObject($sCompDC, $sBitmap)
	$sTagSize = DllStructCreate($tagSIZE)
	$sPtrSize = DllStructGetPtr($sTagSize)
	DllStructSetData($sTagSize, "X", $sWidth)
	DllStructSetData($sTagSize, "Y", $sHeight)
	$sTagSource = DllStructCreate($tagPOINT)
	$sPtrSource = DllStructGetPtr($sTagSource)
	$sTagBlend = DllStructCreate($tagBLENDFUNCTION)
	$sPtrBlend = DllStructGetPtr($sTagBlend)
	DllStructSetData($sTagBlend, "Alpha", $sOpacity)
	DllStructSetData($sTagBlend, "Format", 1)
	_WinAPI_UpdateLayeredWindow($sGUI, $sGetDC, 0, $sPtrSize, $sCompDC, $sPtrSource, 0, $sPtrBlend, 0x02)
	_WinAPI_ReleaseDC(0, $sGetDC)
	_WinAPI_SelectObject($sCompDC, $sObject)
	_WinAPI_DeleteObject($sBitmap)
	_WinAPI_DeleteDC($sCompDC)
	Return $sReturnImage
EndFunc   ;==>__SetBitmap

Func __SetCurrentLanguage($sLanguage)
	#cs
		Description: Sets The Current Language To The Settings INI File.
		Return: Language [English]
	#ce
	Local $sINI = __IsSettingsFile() ; Get Default Settings INI File.

	If $sLanguage == "" Then $sLanguage = __GetDefault(2048) ; Get Default Language.
	IniWrite($sINI, "General", "Language", $sLanguage)
	Return $sLanguage
EndFunc   ;==>__SetCurrentLanguage

Func __SetCurrentPosition($sHandle = $Global_GUI_1)
	#cs
		Description: Sets The Current Coordinates/Position Of DropIt.
		Returns: 1
	#ce
	If $sHandle = "" Then Return SetError(1, 1, 0)
	Local $sINI = __IsSettingsFile() ; Get Default Settings INI File.

	Local $sWinGetPos = WinGetPos($sHandle)
	If @error Then Return SetError(1, 1, 0)

	Local $sINISection = "General"
	If $Global_MultipleInstance Then $sINISection = $UniqueID
	IniWrite($sINI, $sINISection, "PosX", $sWinGetPos[0])
	IniWrite($sINI, $sINISection, "PosY", $sWinGetPos[1])

	Return 1
EndFunc   ;==>__SetCurrentPosition

Func __SetCurrentProfile($sProfile)
	#cs
		Description: Sets The Current Profile Name To The Settings INI File.
		Return: Settings INI File [C:\Program Files\DropIt\Settings.ini]
	#ce
	Local $sINI = __IsSettingsFile() ; Get Default Settings INI File.
;~ 	If __GetMultipleInstances() = 0 Then __GetDefault(2) & __GetCurrentProfile() & ".ini" <<<<< Remove After Testing.

	Local $sINISection = "General"
	If $sProfile == -1 Or $sProfile == 0 Or $sProfile == "" Then $sProfile = "Default"
	If $Global_MultipleInstance Then $sINISection = $UniqueID
	IniWrite($sINI, $sINISection, "Profile", $sProfile)

	Return $sINI
EndFunc   ;==>__SetCurrentProfile

Func __SetHandle($sID)
	#cs
		Description: Sets Window Title For WM_COPYDATA.
		Returns: Handle ID
	#ce
	Local $sGUI = $Global_GUI_1
	AutoItWinSetTitle($sID)
	ControlSetText($sID, '', ControlGetHandle($sID, '', 'Edit1'), $sGUI)
	Return WinGetHandle($sID)
EndFunc   ;==>__SetHandle

Func __SetItemImage($gImageFile, $gIndex, $gHandle = 0, $gType = 1, $gWidth = 20, $gHeight = 20)
	#cs
		Description: Set Image To GUI/Tray Context Menu.
		Returns: Converted Image.
	#ce
	If StringLeft(FileGetVersion(@SystemDir & "\WinVer.exe"), 3) < 6.0 Then Return SetError(1, 1, 0)
	If $gType Then
		$gHandle = GUICtrlGetHandle($gHandle)
	Else
		$gHandle = TrayItemGetHandle($gHandle)
	EndIf
	Local $gImage = _GDIPlus_BitmapCreateFromFile($gImageFile)
	Local $gImageWidth = _GDIPlus_ImageGetWidth($gImage)
	Local $gImageHeight = _GDIPlus_ImageGetHeight($gImage)
	If ($gImageWidth < 0) Or ($gImageHeight < 0) Then Return SetError(1, 1, 0)
	If $gImageWidth < $gImageHeight Then
		$gImageWidth = $gWidth * $gImageWidth / $gImageHeight
		$gImageHeight = $gHeight
	Else
		$gImageHeight = $gHeight * $gImageHeight / $gImageWidth
		$gImageWidth = $gWidth
	EndIf
	Local $aResult = DllCall($ghGDIPDll, "uint", "GdipCreateBitmapFromScan0", "int", $gWidth, "int", $gHeight, "int", 0, "int", 0x0026200A, "ptr", 0, "int*", 0)
	Local $gBitmap = $aResult[6]
	Local $gContext = _GDIPlus_ImageGetGraphicsContext($gBitmap)
	_GDIPlus_GraphicsDrawImageRect($gContext, $gImage, 0, 0, $gWidth, $gHeight)
	Local $gIcon = _GDIPlus_BitmapCreateHBITMAPFromBitmap($gBitmap)
	_GUICtrlMenu_SetItemBmp($gHandle, $gIndex, $gIcon)
	_GDIPlus_GraphicsDispose($gContext)
	_GDIPlus_BitmapDispose($gBitmap)
	Return SetError(0, 0, $gIcon)
EndFunc   ;==>__SetItemImage

Func __SetItemImageEx($gHandle, $gIndex, ByRef $gImageList, $gImageFile, $gType) ; Taken From Code By Yashied - http://www.autoitscript.com/forum/topic/113827-thumbnail-of-a-file/page__view__findpost__p__799038
	#cs
		Description: Sets Image To Control Handle.
		Returns: 1
	#ce
	Local $gIconSize = _GUIImageList_GetIconSize($gImageList)
	If (Not $gIconSize[0]) Or (Not $gIconSize[1]) Then Return SetError(1, 1, 0)

	Local $gWidth, $gHeight, $gHeightGraphic, $gHeightPicture, $gHeightImage, $gHeightIcon

	$gHeightPicture = _ResourceGetAsImage($gImageFile)
	If @error Then
		$gHeightPicture = _ResourceGetAsImage("NoFlag")
		If FileExists($gImageFile) Then $gHeightPicture = _GDIPlus_ImageLoadFromFile($gImageFile)
	EndIf

	$gWidth = _GDIPlus_ImageGetWidth($gHeightPicture)
	$gHeight = _GDIPlus_ImageGetHeight($gHeightPicture)

	Local $gSize = __ImageRelativeSize($gIconSize[0], $gIconSize[1], $gWidth, $gHeight)
	If @error Then Return SetError(1, 1, 0)
	$gHeightImage = DllCall($ghGDIPDll, 'int', 'GdipGetImageThumbnail', 'ptr', $gHeightPicture, 'int', $gIconSize[0], 'int', $gIconSize[1], 'ptr*', 0, 'ptr', 0, 'ptr', 0)
	$gHeightGraphic = _GDIPlus_ImageGetGraphicsContext($gHeightImage[4])
	_GDIPlus_GraphicsClear($gHeightGraphic, 0)
	_GDIPlus_GraphicsDrawImageRect($gHeightGraphic, $gHeightPicture, ($gIconSize[0] - $gSize[0]) / 2, ($gIconSize[1] - $gSize[1]) / 2, $gSize[0], $gSize[1])
	$gHeightIcon = DllCall($ghGDIPDll, 'int', 'GdipCreateHICONFromBitmap', 'ptr', $gHeightImage[4], 'ptr*', 0)
	_GDIPlus_GraphicsDispose($gHeightGraphic)
	_GDIPlus_ImageDispose($gHeightImage[4])
	_GDIPlus_ImageDispose($gHeightPicture)
	If Not $gHeightIcon[2] Then Return SetError(1, 1, 0)
	_GUIImageList_ReplaceIcon($gImageList, -1, $gHeightIcon[2])
	Switch $gType
		Case 1 ; ListView
			_GUICtrlListView_SetItemImage($gHandle, $gIndex, _GUIImageList_GetImageCount($gImageList) - 1)
		Case 2 ; ComboBox
			_GUICtrlComboBoxEx_SetItemImage($gHandle, $gIndex, _GUIImageList_GetImageCount($gImageList) - 1)
	EndSwitch
	_WinAPI_DestroyIcon($gHeightIcon[2])
	Return 1
EndFunc   ;==>__SetItemImageEx

Func __SetMultipleInstances($sType = "+") ; Not Activated.
	#cs
		Description: Sets The Number Of Additional DropIt Instances & Lists The Multiple Instance Name With PID. [1_DropIt_MultipleInstance=8967]
		Returns: 1
	#ce
	Local $sRunning = __GetMultipleInstances()
	Local $sINI = __IsSettingsFile() ; Get Default Settings INI File.
	Switch $sType
		Case "+"
			$sRunning += 1
			IniWrite($sINI, "MultipleInstances", $UniqueID, @AutoItPID)

		Case "-"
			$sRunning -= 1
			IniDelete($sINI, $UniqueID)
			IniDelete($sINI, "MultipleInstances", $UniqueID)

	EndSwitch
	Return IniWrite($sINI, "MultipleInstances", "Running", $sRunning)
EndFunc   ;==>__SetMultipleInstances

Func __SetProgress($sHandle, $sPercentage, $sColor = 0, $sVertical = False) ; Taken From http://www.autoitscript.com/forum/topic/121883-progress-bar-without-animation-in-vista7/page__view__findpost__p__845958
	#cs
		Description: Sets A Custom Progress Bar.
		Return: Progress Data.
	#ce
	Local $sDC, $sMemDC, $sWinAPI_Object, $sObject, $sBitmap, $sTheme, $sRectangle, $sClip, $sStructure_1, $sStructure_2, $sRet, $sResult = 1
	If StringLeft(FileGetVersion(@SystemDir & "\WinVer.exe"), 3) < 6.0 Then
		GUICtrlSetState($sHandle, $GUI_SHOW)
		GUICtrlSetData($sHandle, $sPercentage)
		Return 1
	EndIf

	If Not IsHWnd($sHandle) Then
		$sHandle = GUICtrlGetHandle($sHandle)
		If Not $sHandle Then Return SetError(1, 1, 0)
	EndIf
	$sTheme = DllCall('uxtheme.dll', 'ptr', 'OpenThemeData', 'hwnd', $sHandle, 'wstr', 'Progress')
	If (@error) Or (Not $sTheme[0]) Then
		Return 0
	EndIf
	$sRectangle = _WinAPI_GetClientRect($sHandle)
	$sStructure_1 = DllStructGetData($sRectangle, 3) - DllStructGetData($sRectangle, 1)
	$sStructure_2 = DllStructGetData($sRectangle, 4) - DllStructGetData($sRectangle, 2)
	$sDC = _WinAPI_GetDC($sHandle)
	$sMemDC = _WinAPI_CreateCompatibleDC($sDC)
	$sBitmap = _WinAPI_CreateSolidBitmap(0, _WinAPI_GetSysColor(15), $sStructure_1, $sStructure_2, 0)
	$sWinAPI_Object = _WinAPI_SelectObject($sMemDC, $sBitmap)
	DllStructSetData($sRectangle, 1, 0)
	DllStructSetData($sRectangle, 2, 0)
	DllStructSetData($sRectangle, 3, $sStructure_1)
	DllStructSetData($sRectangle, 4, $sStructure_2)
	$sRet = DllCall('uxtheme.dll', 'uint', 'DrawThemeBackground', 'ptr', $sTheme[0], 'hwnd', $sMemDC, 'int', 2 - (Not $sVertical), 'int', 0, 'ptr', DllStructGetPtr($sRectangle), 'ptr', 0)
	If (@error) Or ($sRet[0]) Then
		$sResult = 0
	EndIf
	If $sVertical Then
		DllStructSetData($sRectangle, 2, $sStructure_2 * (1 - $sPercentage / 100))
	Else
		DllStructSetData($sRectangle, 3, $sStructure_1 * $sPercentage / 100)
	EndIf
	$sClip = DllStructCreate($tagRECT)
	DllStructSetData($sClip, 1, 1)
	DllStructSetData($sClip, 2, 1)
	DllStructSetData($sClip, 3, $sStructure_1 - 1)
	DllStructSetData($sClip, 4, $sStructure_2 - 1)
	DllCall('uxtheme.dll', 'uint', 'DrawThemeBackground', 'ptr', $sTheme[0], 'hwnd', $sMemDC, 'int', 6 - (Not $sVertical), 'int', 1 + $sColor, 'ptr', DllStructGetPtr($sRectangle), 'ptr', DllStructGetPtr($sClip))
	If (@error) Or ($sRet[0]) Then
		$sResult = 0
	EndIf
	_WinAPI_ReleaseDC($sHandle, $sDC)
	_WinAPI_SelectObject($sMemDC, $sWinAPI_Object)
	_WinAPI_DeleteDC($sMemDC)
	DllCall('uxtheme.dll', 'uint', 'CloseThemeData', 'ptr', $sTheme[0])
	If $sResult Then
		_WinAPI_DeleteObject(_SendMessage($sHandle, 0x0172, 0, $sBitmap))
		$sObject = _SendMessage($sHandle, 0x0173)
		If $sObject <> $sBitmap Then
			_WinAPI_DeleteObject($sBitmap)
		EndIf
	EndIf
	Return $sResult
EndFunc   ;==>__SetProgress

Func __ShowPassword($sHandle, $sInput, $sTab = -1)
	#cs
		Description: Shows/Hides Password Of An Input Password Field.
		Returns: Input ID.
	#ce
	If Not IsDeclared("Global_ShowPassword") Then Global $Global_ShowPassword[1][2] = [[0, 2]]
	Local $sType = 0, $sIndex = -1

	For $A = 1 To $Global_ShowPassword[0][0]
		If @error Then ExitLoop
		If $Global_ShowPassword[$A][0] = $sInput Then
			$sIndex = $A
			$sType = $Global_ShowPassword[$sIndex][1]
			ExitLoop
		EndIf
	Next

	If $sIndex = -1 Then
		If $Global_ShowPassword[0][0] <= UBound($Global_ShowPassword, 1) + 1 Then ReDim $Global_ShowPassword[($Global_ShowPassword[0][0] + 1) * 2][$Global_ShowPassword[0][1]]
		$Global_ShowPassword[0][0] += 1
		$sIndex = $Global_ShowPassword[0][0]
		$Global_ShowPassword[$sIndex][0] = $sInput
		$Global_ShowPassword[$sIndex][1] = $sType
	EndIf

	Local $sInputStyle = -1
	Switch $sType
		Case 0
			$Global_ShowPassword[$sIndex][1] = 1
		Case 1
			$sInputStyle = 0x0020
			$Global_ShowPassword[$sIndex][1] = 0
	EndSwitch

	Local $sInputRead = GUICtrlRead($sInput)
	Local $sInputGetPos = ControlGetPos($sHandle, "", $sInput)
	GUICtrlDelete($sInput)
	If $sTab <> -1 Then GUISwitch($sHandle, $sTab)
	$sInput = GUICtrlCreateInput($sInputRead, $sInputGetPos[0], $sInputGetPos[1], $sInputGetPos[2], $sInputGetPos[3], $sInputStyle)
	If $sTab <> -1 Then
		GUICtrlCreateTabItem("")
		GUISwitch($sHandle)
	EndIf
	Return $sInput
EndFunc   ;==>__ShowPassword

Func __SingletonEx($sID = "")
	#cs
		Description: Checks If DropIt Is Already Running.
		Returns: 1 Or Window Title.
	#ce
	If $sID = "" Then Return SetError(1, 1, 0)
	Local $hWnd = WinGetHandle($sID)
	If IsHWnd($hWnd) Then
		Local $hWnd_Target = ControlGetText($hWnd, '', ControlGetHandle($hWnd, '', 'Edit1'))
		WM_COPYDATA_SENDDATA(HWnd($hWnd_Target), $CmdLineRaw) ; Send $CmdLineRaw Files To The First Instance Of DropIt.
		If __Is("MultipleInstances") Then
			Local $sMultipleInstances = __GetMultipleInstances() + 1
			$UniqueID = $sMultipleInstances & "_DropIt_MultipleInstance"
			__SetMultipleInstances("+")
			$Global_MultipleInstance = 1
			Return 1
		Else
			Exit
		EndIf
	EndIf
	__CMDLine($CmdLine, 0) ; Check CMDLine And Process.
	If Not @error Then Exit ; If A Valid File/Folder It Will Exit, Otherwise It Will Open DropIt.
	Return __SetHandle($sID) ; Set Window Title For WM_COPYDATA.
EndFunc   ;==>__SingletonEx

Func __StartupFolder_Install($sProgramName = "Program_Name", $sProgramEXE = @AutoItExe)
	#cs
		Description: Creates A Shortcut In The 'Current Users' Startup Folder. [Program_Name.lnk]
		Returns: 1
	#ce
	__StartupFolder_Uninstall($sProgramName, $sProgramEXE) ; Deletes The Shortcut In The 'Current Users' Startup Folder.
	Local $sStartup_Directory = @StartupDir
	FileCreateShortcut($sProgramEXE, $sStartup_Directory & "\" & $sProgramName & ".lnk", @ScriptDir)
	Return 1
EndFunc   ;==>__StartupFolder_Install

Func __StartupFolder_Uninstall($sProgramName = "Program_Name", $sProgramEXE = @AutoItExe)
	#cs
		Description: Deletes The Shortcut In The 'Current Users' Startup Folder. [Program_Name.lnk]
		Returns: 1
	#ce
	Local $sStartup_Directory = @StartupDir
	Local $sFileListToArray = _FileListToArray($sStartup_Directory)
	Local $FileGetShortcut
	For $A = 1 To $sFileListToArray[0]
		If StringLeft($sFileListToArray[$A], StringLen($sProgramName)) == $sProgramName Then
			$FileGetShortcut = FileGetShortcut($sStartup_Directory & "\" & $sFileListToArray[$A])
			If $FileGetShortcut[0] = $sProgramEXE Then
				FileDelete($sStartup_Directory & "\" & $sFileListToArray[$A])
			EndIf
		EndIf
	Next
	Return 1
EndFunc   ;==>__StartupFolder_Uninstall

Func __StringIsValid($sString, $sPattern = '\/|:<>"')
	#cs
		Description: Checks If A String Contains Invalid Characters.
		Returns:
		If String Contains Invalid Characters Return 1
		If Not String Contains Invalid Characters Return 0
	#ce
	$sPattern = StringRegExpReplace($sPattern, "\\E", "E\")
	Return BitAND(Not StringRegExp($sString, '[\Q' & $sPattern & '\E]'), 1)
EndFunc   ;==>__StringIsValid

Func __TimeSuffix($tTime)
	#cs
		Description: Converts MilliSeconds (MS) Into 00:00:00 [10000 MS = 00:00:10].
		Returns: Converted Format.
	#ce
	Local $tTotal_Seconds = Int($tTime / 1000), $Hours = Int($tTotal_Seconds / 3600), $Minutes = Int(($tTotal_Seconds - ($Hours * 3600)) / 60)
	Local $Seconds = $tTotal_Seconds - (($Hours * 3600) + ($Minutes * 60))
	If $Hours < 10 Then $Hours = 0 & $Hours
	If $Minutes < 10 Then $Minutes = 0 & $Minutes
	If $Seconds < 10 Then $Seconds = 0 & $Seconds
	$tTime = $Hours & ":" & $Minutes & ":" & $Seconds
	Return $tTime
EndFunc   ;==>__TimeSuffix

Func __Uninstall()
	#cs
		Description: Uninstall Files Etc... If The Uninstall Commandline Parameter Is Called. [DropIt.exe /Uninstall]
		Returns: 1
	#ce
	If __Is("UseSendTo") Then __SendTo_Uninstall() ; SendTo Integration Is Removed If Was Used By The Installed Version.
	Exit
EndFunc   ;==>__Uninstall

Func __Upgrade()
	#cs
		Description: Upgrades Settings To New Version, If Needed.
		Returns: 1
	#ce
	Local $uINIRead, $uSearch, $uFileName, $uPatternsINI
	Local $uDropIt_Directory = __GetDefault(1) ; Get Default Settings Directory.
	Local $uINI = __IsSettingsFile() ; Get Default Settings INI File.
	If IniRead($uINI, "General", "Version", "None") == $Global_CurrentVersion Then Return SetError(1, 1, 0) ; Abort Upgrade If INI Version Is The Same Of Current Software Version.

	; Upgrade Folders Of Versions Older Than 1.0
	DirMove($uDropIt_Directory & "profiles", $uDropIt_Directory & "Profiles", 1)
	DirRemove($uDropIt_Directory & "img", 1)
	DirRemove(@ScriptDir & "\" & "docs", 1)

	; Decrypt Single Encrypted Profiles Of Versions Older Than 1.6
	Local $uProfilesDirectory = __GetDefault(2)
	Local $uProfileList = __ProfileList()
	For $A = 1 To $uProfileList[0]
		__EncryptionFile($uProfilesDirectory & $uProfileList[$A] & ".dat")
	Next

	; Upgrade Patterns Of Versions Older Than 1.5
	$uSearch = FileFindFirstFile($uDropIt_Directory & "Profiles\*.ini") ; Load Files.
	While 1
		$uFileName = FileFindNextFile($uSearch)
		If @error Then ExitLoop
		$uFileName = $uDropIt_Directory & "Profiles\" & $uFileName
		$uPatternsINI = __IniReadSection($uFileName, "Patterns")
		If @error Then ContinueLoop
		IniDelete($uFileName, "Patterns")
		For $A = 1 To $uPatternsINI[0][0]
			If StringRight($uPatternsINI[$A][0], 1) == "$" Then ; Exclude Pattern.
				$uPatternsINI[$A][0] = StringTrimRight($uPatternsINI[$A][0], 1) & "$2"
			ElseIf StringRight($uPatternsINI[$A][0], 1) == "&" Then ; Compress Pattern.
				$uPatternsINI[$A][0] = StringTrimRight($uPatternsINI[$A][0], 1) & "$3"
			ElseIf Not StringInStr($uPatternsINI[$A][0], "$") Then ; Normal Pattern.
				$uPatternsINI[$A][0] &= "$0"
			EndIf
			$uPatternsINI[$A][1] = StringReplace($uPatternsINI[$A][1], "Exclusion-Pattern", "Empty-Destination")
			IniWrite($uFileName, "Patterns", $uPatternsINI[$A][0], $uPatternsINI[$A][1])
		Next
	WEnd
	FileClose($uSearch)

	FileMove($uINI, $uINI & ".old", 1) ; Rename The Old INI.
	__IsSettingsFile(-1, 0) ; Create A New Upgraded INI, Skipping Language Selection.

	Local $uINI_Array[36][3] = [ _
			[35, 3], _
			["General", "Profile", 1], _ ; Unchanged.
			["General", "Language", 1], _ ; Unchanged.
			["General", "PosX", 1], _ ; Unchanged.
			["General", "PosY", 1], _ ; Unchanged.
			["General", "OnTop", 1], _ ; Unchanged.
			["General", "LockPosition", 1], _ ; Unchanged.
			["General", "LockPos", "LockPosition"], _ ; Or Changed To.
			["General", "CustomTrayIcon", 1], _ ; Unchanged.
			["General", "MultipleInstances", 1], _ ; Unchanged.
			["General", "MultipleInst", "MultipleInstances"], _ ; Or Changed To.
			["General", "StartAtStartup", 1], _ ; Unchanged.
			["General", "UseSendTo", 1], _ ; Unchanged.
			["General", "SendToMode", 1], _ ; Unchanged.
			["General", "ShowSorting", 1], _ ; Unchanged.
			["General", "ProfileEncryption", 1], _ ; Unchanged.
			["General", "DirForFolders", 1], _ ; Unchanged.
			["General", "IgnoreNew", 1], _ ; Unchanged.
			["General", "AutoDup", 1], _ ; Unchanged.
			["General", "AutoForDup", "AutoDup"], _ ; Or Changed To.
			["General", "DupMode", 1], _ ; Unchanged.
			["General", "Duplicates", "DupMode"], _ ; Or Changed To.
			["General", "CreateLog", 1], _ ; Unchanged.
			["General", "IntegrityCheck", 1], _ ; Unchanged.
			["General", "SafetyErase", 1], _ ; Unchanged.
			["General", "SizeMessage", 1], _ ; Unchanged.
			["General", "ArchiveFormat", 1], _ ; Unchanged.
			["General", "ArchiveLevel", 1], _ ; Unchanged.
			["General", "ArchiveMethod", 1], _ ; Unchanged.
			["General", "ArchiveSelf", 1], _ ; Unchanged.
			["General", "ArchiveEncrypt", 1], _ ; Unchanged.
			["General", "ArchiveEncryptMethod", 1], _ ; Unchanged.
			["General", "ArchivePassword", 1], _ ; Unchanged.
			["General", "MasterPassword", 1], _ ; Unchanged.
			["General", "ColumnCustom", "95;95;60;50"], _ ; Unchanged.
			["General", "ColumnManage", "115;85;190"]] ; Unchanged.

	For $A = 1 To $uINI_Array[0][0]
		$uINIRead = IniRead($uINI & ".old", $uINI_Array[$A][0], $uINI_Array[$A][1], "None")
		If $uINIRead = "None" Then ContinueLoop
		If $uINI_Array[$A][2] = 1 Then $uINI_Array[$A][2] = $uINI_Array[$A][1]
		IniWrite($uINI, $uINI_Array[$A][0], $uINI_Array[$A][2], $uINIRead)
	Next
	IniWriteSection($uINI, "EnvironmentVariables", "")
	FileDelete($uINI & ".old") ; Remove The Old INI.
	Return 1
EndFunc   ;==>__Upgrade

Func __WinAPI_PathIsRelative($pPath) ; Taken From WinAPIEx.au3 By Yashied - http://www.autoitscript.com/forum/index.php?showtopic=98712
	Local $pReturn = DllCall("shlwapi.dll", "int", "PathIsRelativeW", "wstr", $pPath)
	If @error Then Return SetError(1, 1, 0)
	Return $pReturn[0]
EndFunc   ;==>__WinAPI_PathIsRelative

Func __WinAPI_ShellGetSpecialFolderPath($sCSIDL, $sCreate = 0) ; Taken From WinAPIEx.au3 By Yashied - http://www.autoitscript.com/forum/index.php?showtopic=98712
	Local $sPath = DllStructCreate("wchar[1024]")
	Local $sReturn = DllCall("shell32.dll", "int", "SHGetSpecialFolderPathW", "hwnd", 0, "ptr", DllStructGetPtr($sPath), "int", $sCSIDL, "int", $sCreate)
	If (@error) Or (Not $sReturn[0]) Then Return SetError(1, 1, "")
	Return DllStructGetData($sPath, 1)
EndFunc   ;==>__WinAPI_ShellGetSpecialFolderPath
#Region End >>>>> Internal Functions <<<<<

#Region Start >>>>> 7Zip Functions <<<<< Taken From: http://www.autoitscript.com/forum/topic/91283-7zread-udf/
Func __7Zip_ClosePercent(ByRef $zHandle)
	If UBound($zHandle) <> 4 Then Return 0
	DllCall("Kernel32.dll", "int", "FreeConsole")
	$zHandle = 0
	Return 1
EndFunc   ;==>__7Zip_ClosePercent

Func __7Zip_OpenPercent($zPID)
	If __7Zip_AttachConsole($zPID) = 0 Then Return
	Local $zHandle[4]
	$zHandle[0] = __7Zip_GetHandle(-11)
	$zHandle[1] = DllStructCreate("short dwSizeX; short dwSizeY;short dwCursorPositionX; short dwCursorPositionY; short wAttributes;short Left; short Top; short Right; short Bottom; short dwMaximumWindowSizeX; short dwMaximumWindowSizeY")
	$zHandle[2] = DllStructCreate("dword[4]")
	$zHandle[3] = DllStructCreate("short Left; short Top; short Right; short Bottom")
	Return $zHandle
EndFunc   ;==>__7Zip_OpenPercent

Func __7Zip_ReadPercent(ByRef $zHandle)
	If UBound($zHandle) = 4 Then
		Local Const $zStdOut = $zHandle[0]
		Local Const $zGetConsoleInfo = $zHandle[1]
		Local Const $zBuffer = $zHandle[2]
		Local Const $zSmallRect = $zHandle[3]
		If __7Zip_GetConsoleInfo($zStdOut, $zGetConsoleInfo) Then
			DllStructSetData($zSmallRect, "Left", DllStructGetData($zGetConsoleInfo, "dwCursorPositionX") - 4)
			DllStructSetData($zSmallRect, "Top", DllStructGetData($zGetConsoleInfo, "dwCursorPositionY"))
			DllStructSetData($zSmallRect, "Right", DllStructGetData($zGetConsoleInfo, "dwCursorPositionX"))
			DllStructSetData($zSmallRect, "Bottom", DllStructGetData($zGetConsoleInfo, "dwCursorPositionY"))
			If __7Zip_ReadConsoleOutput($zStdOut, $zBuffer, $zSmallRect) Then
				Local $zPercent = ""
				For $i = 0 To 3
					Local $zCharInfo = DllStructCreate("wchar UnicodeChar; short Attributes", DllStructGetPtr($zBuffer) + ($i * 4))
					$zPercent &= DllStructGetData($zCharInfo, "UnicodeChar")
				Next
				If StringRight($zPercent, 1) = "%" Then Return Number($zPercent)
			EndIf
		EndIf
	EndIf
	Return -1
EndFunc   ;==>__7Zip_ReadPercent

Func __7Zip_AttachConsole($zPID)
	Local $zReturn = DllCall("Kernel32.dll", "int", "AttachConsole", "dword", $zPID)
	If @error Then Return SetError(1, 1, 0)
	Return $zReturn[0]
EndFunc   ;==>__7Zip_AttachConsole

Func __7Zip_GetConsoleInfo($zConsoleOutput, $zGetConsoleInfo)
	Local $zReturn = DllCall("Kernel32.dll", "int", "GetConsoleScreenBufferInfo", "hwnd", $zConsoleOutput, $Global_PTR, __7Zip_GetPointer($zGetConsoleInfo))
	If @error Then Return SetError(1, 1, 0)
	Return $zReturn[0]
EndFunc   ;==>__7Zip_GetConsoleInfo

Func __7Zip_GetHandle($zHandle)
	Local $zReturn = DllCall("Kernel32.dll", "hwnd", "GetStdHandle", "dword", $zHandle)
	If @error Then Return SetError(1, 1, 0)
	Return $zReturn[0]
EndFunc   ;==>__7Zip_GetHandle

Func __7Zip_GetPointer(Const ByRef $Global_PTR)
	Local $zPointer = DllStructGetPtr($Global_PTR)
	If @error Then $zPointer = $Global_PTR
	Return $zPointer
EndFunc   ;==>__7Zip_GetPointer

Func __7Zip_ReadConsoleOutput($zConsoleOutput, $zBuffer, $zSmallRect)
	Local $zReturn = DllCall("Kernel32.dll", "int", "ReadConsoleOutputW", $Global_PTR, $zConsoleOutput, "int", __7Zip_GetPointer($zBuffer), "int", 65540, "int", 0, $Global_PTR, __7Zip_GetPointer($zSmallRect))
	If @error Then SetError(1, 1, 0)
	Return $zReturn[0]
EndFunc   ;==>__7Zip_ReadConsoleOutput
#Region End >>>>> 7Zip Functions <<<<<

#Region Start >>>>> Secure Delete Functions <<<<< Taken From: http://www.autoitscript.com/forum/topic/82954-securely-overwrite-files/
Func __SecureFileDelete_CreateFile($sFilePath, $sAccess, $sShareMode, $sCreation, $sFlags)
	If $sCreation = $CREATE_ALWAYS Then ; Open The File With Existing Hidden Or System Attributes To Avoid Failure When Using Create_Always.
		Local $sFileGetAttribute = FileGetAttrib($sFilePath)
		If StringInStr($sFileGetAttribute, "H") Then $sFlags = BitOR($sFlags, $FILE_ATTRIBUTE_HIDDEN)
		If StringInStr($sFileGetAttribute, "S") Then $sFlags = BitOR($sFlags, $FILE_ATTRIBUTE_SYSTEM)
	EndIf
	Local $sFile = DllCall("kernel32.dll", "handle", "CreateFileW", "wstr", $sFilePath, "dword", $sAccess, "dword", $sShareMode, "ptr", 0, _
			"dword", $sCreation, "dword", $sFlags, "ptr", 0)
	If @error Or ($sFile[0] = Ptr(-1)) Then Return SetError(1, 0, 0)
	Return $sFile[0]
EndFunc   ;==>__SecureFileDelete_CreateFile

Func __SecureFileDelete_GetDiskClusterSize($sPath)
	Local $sReturn = DllCall("kernel32.dll", "bool", "GetDiskFreeSpaceW", "wstr", __PathGetDrive($sPath), "dword*", 0, "dword*", 0, "dword*", 0, "dword*", 0)
	If @error Or (Not $sReturn[0]) Then Return SetError(1, 0, 0)
	Return $sReturn[3]
EndFunc   ;==>__SecureFileDelete_GetDiskClusterSize
#Region End >>>>> Secure Delete Functions <<<<<

#Region Start >>>>> Tray Icon Functions <<<<<
Func __Tray_BitmapIcon($gb_Bitmap)
	Local $ts_Return = DllCall($ghGDIPDll, "int", "GdipCreateHICONFromBitmap", "hwnd", $gb_Bitmap, "int*", 0)
	If @error Or Not $ts_Return[0] Then Return SetError(@error, @extended, $ts_Return[2])
	Return $ts_Return[2]
EndFunc   ;==>__Tray_BitmapIcon

Func __Tray_ConvertIcon($ip_Image, $ip_XPixel = 5, $ip_YPixel = 5)
	Local $ip_ImageLoad, $ip_Width, $ip_Height, $ip_FirstPixel, $ip_TransparentPixel, $ip_ImageLoadData, $ip_Stride, $ip_Scan, $ip_Pixel
	Local $ip_Buffer, $ip_AllPixels, $ip_Result, $ip_Pix

	$ip_ImageLoad = _GDIPlus_ImageLoadFromFile($ip_Image)
	$ip_Width = _GDIPlus_ImageGetWidth($ip_ImageLoad)
	$ip_Height = _GDIPlus_ImageGetHeight($ip_ImageLoad)

	If StringInStr('"WIN_2003","WIN_XP","WIN_2000"', @OSVersion) Then
		Local $ip_Return, $ip_BMP, $ip_Bitmap, $ip_Graphic
		$ip_Return = _GDIPlus_ImageGetPixelFormat($ip_ImageLoad)
		If Int(StringRegExpReplace($ip_Return[1], "\D+", "")) < 24 Then
			$ip_BMP = _WinAPI_CreateBitmap($ip_Width, $ip_Height, 1, 32)
			$ip_Bitmap = _GDIPlus_BitmapCreateFromHBITMAP($ip_BMP)
			_WinAPI_DeleteObject($ip_BMP)
			$ip_Graphic = _GDIPlus_ImageGetGraphicsContext($ip_Bitmap)
			_GDIPlus_GraphicsDrawImage($ip_Graphic, $ip_ImageLoad, 0, 0)
			_GDIPlus_GraphicsDispose($ip_Graphic)
			_GDIPlus_ImageDispose($ip_ImageLoad)
			$ip_ImageLoad = _GDIPlus_BitmapCloneArea($ip_Bitmap, 0, 0, $ip_Width, $ip_Height, $GDIP_PXF32ARGB)
			_GDIPlus_BitmapDispose($ip_Bitmap)
		EndIf
	EndIf

	$ip_ImageLoadData = _GDIPlus_BitmapLockBits($ip_ImageLoad, 0, 0, $ip_Width, $ip_Height, $GDIP_ILMWRITE, $GDIP_PXF32ARGB)
	$ip_Stride = DllStructGetData($ip_ImageLoadData, "stride")
	$ip_Scan = DllStructGetData($ip_ImageLoadData, "Scan0")

	$ip_Pixel = DllStructCreate("int", $ip_Scan + ($ip_YPixel * $ip_Stride) + ($ip_XPixel * 4))
	$ip_FirstPixel = DllStructGetData($ip_Pixel, 1)
	$ip_TransparentPixel = BitAND($ip_FirstPixel, 0x00FFFFFF)

	$ip_FirstPixel = StringRegExpReplace(Hex($ip_FirstPixel, 8), "(.{2})(.{2})(.{2})(.{2})", "\4\3\2\1")
	$ip_TransparentPixel = StringTrimRight($ip_FirstPixel, 2) & "00"
	$ip_Buffer = DllStructCreate("byte[" & $ip_Height * $ip_Width * 4 & "]", $ip_Scan)
	$ip_AllPixels = DllStructGetData($ip_Buffer, 1)
	$ip_Result = StringRegExpReplace(StringTrimLeft($ip_AllPixels, 2), "(.{8})", "\1 ")
	$ip_Pix = "0x" & StringStripWS(StringRegExpReplace($ip_Result, "(" & $ip_FirstPixel & ")", $ip_TransparentPixel), 8)
	$ip_AllPixels = DllStructSetData($ip_Buffer, 1, $ip_Pix)

	_GDIPlus_BitmapUnlockBits($ip_ImageLoad, $ip_ImageLoadData)
	Return $ip_ImageLoad
EndFunc   ;==>__Tray_ConvertIcon

Func __Tray_SetIcon($ts_Icon)
	Local $ts_Bitmap = __Tray_ConvertIcon($ts_Icon)
	$ts_Icon = __Tray_BitmapIcon($ts_Bitmap)

	Local Const $tagNOTIFYICONDATA = "dword Size;hwnd Wnd;uint ID;uint Flags;uint CallbackMessage;ptr Icon;wchar Tip[128];dword State;dword StateMask;wchar Info[256];" & _
			"uint Timeout;wchar InfoTitle[64];dword InfoFlags;dword Data1;word Data2;word Data3;byte Data4[8];ptr BalloonIcon"
	Local $ts_Handle = WinGetHandle(AutoItWinGetTitle())

	Local $tNOTIFY = DllStructCreate($tagNOTIFYICONDATA)
	DllStructSetData($tNOTIFY, "Size", DllStructGetSize($tNOTIFY))
	DllStructSetData($tNOTIFY, "Wnd", $ts_Handle)
	DllStructSetData($tNOTIFY, "ID", 1)
	DllStructSetData($tNOTIFY, "Icon", $ts_Icon)
	DllStructSetData($tNOTIFY, "Flags", BitOR(2, 1))
	DllStructSetData($tNOTIFY, "CallbackMessage", 1025)

	Local $ts_Return = DllCall("shell32.dll", "int", "Shell_NotifyIconW", "dword", 1, "ptr", DllStructGetPtr($tNOTIFY))
	If (@error) Then Return SetError(1, 0, 0)
	_WinAPI_DestroyIcon($ts_Icon)
	Return $ts_Return[0] <> 0
EndFunc   ;==>__Tray_SetIcon
#Region End >>>>> Tray Icon Functions <<<<<