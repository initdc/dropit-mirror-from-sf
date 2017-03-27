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
#AutoIt3Wrapper_Res_Fileversion=1.1.1.0
#AutoIt3Wrapper_Res_ProductVersion=1.1.1.0
#AutoIt3Wrapper_Res_LegalCopyright=Lupo PenSuite Team
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_Field=Website|http://www.lupopensuite.com
#AutoIt3Wrapper_Res_Field=E-Mail|comment at the website
#AutoIt3Wrapper_UseX64=N
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_Run_Obfuscator=Y
#Obfuscator_Parameters=/SF /SV /OM /CF=0 /CN=0 /CS=0 /CV=0
#AutoIt3Wrapper_Res_File_Add=Lib\img\zz.png, 10, ZZ
#AutoIt3Wrapper_Res_File_Add=Images\Default.png, 10, IMAGE
#EndRegion ; **** Directives Created By AutoIt3Wrapper_GUI ****

#include <File.au3>
#include <GDIPlus.au3>
#include <GUIComboBox.au3>
#include <GUIConstantsEx.au3>
#include <GUIListView.au3>
#include <GUIMenu.au3>
#include <GuiTab.au3>
#include <Lib\res\ExtMsgBox.au3>
#include <Lib\res\GIFAnimation.au3>
#include <Lib\res\Resources.au3>
#include <Misc.au3>
#include <StaticConstants.au3>
#include <String.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>

Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1)
OnAutoItExitRegister("_ExitEvent")

; <<<<< Environment Variables >>>>>
__EnvironmentVariables() ; Sets The Standard & User Assigned Environment Variables.
__ExpandEnvStrings(0)
; <<<<< Environment Variables >>>>>

; <<<<< Variables >>>>>
Global $Global_GUI_1, $Global_GUI_2 ; GUI Handles.
Global $Global_Icon_1 ; Icons Handle.
Global $Global_TrayMenu[14][2] = [[13, 2]] ; TrayMenu Array.
Global $Global_Customize, $Global_ListViewIndex = -1, $Global_ListViewRules, $Global_ListViewProfiles, $Global_Manage ; ListView Variables.
Global $Global_ListViewProfiles_Delete, $Global_ListViewProfiles_Enter, $Global_ListViewProfiles_New ; ContextMenu ListViewProfiles Variables.
Global $Global_ListViewRules_Delete, $Global_ListViewRules_Enter, $Global_ListViewRules_New ; ContextMenu ListViewManage Variables.
Global $Global_Slider, $Global_SliderLabel ; _Customize_GUI_Edit().
Global $Global_CompressionEnabled, $Global_DroppedFiles[1] ; Misc.
Global $UniqueID = "DropIt_E15FF08B-84AC-472A-89BF-5F92DB683165" ; WM_COPYDATA.
Global $Global_MultipleInstance = 0 ; Multiple Instances.
Global $oGlobal_PW_Code = "93fmj342c34cm9j5t" ; Master Password For Encryption (It Is An Example, The Compiled One Is Different).
; <<<<< Variables. >>>>>

; <<<<< ContextMenu. >>>>>
Global $Global_ContextMenu, $Global_ContextProfiles, $Global_ContextExit, $Global_ContextManage, $Global_ContextCustom, $Global_ContextOptions, $Global_ContextHide
Global $Global_ContextGuide, $Global_ContextReadme, $Global_ContextAbout, $Global_ContextHelp
; <<<<< ContextMenu. >>>>>

__Upgrade() ; Upgrades DropIt If Required.
__SingletonEx($UniqueID) ; WM_COPYDATA.
_Update_Check() ; Checks If DropIt Has Been Updated.

_GDIPlus_Startup()
_Main()

#Region Start >>>>> Manage Functions <<<<<
Func _Manage_GUI($mINI = -1, $mHandle = -1)
	$mINI = __IsSettingsFile($mINI) ; Get Default Settings INI File.
	Local $mGUI = $Global_Manage
	Local $mTips = __Lang_Get('MANAGE_GUI_MSGBOX_1', '- As destination folders are supported both absolute ("C:\Lupo\My Images") and relative ("..\My Images") paths.  @LF  @LF  - If you want to use different pattern groups, for example on different computers, you can click "Profiles" >> "Customize" to create and manage them.  @LF  @LF  - If you want to ignore files that match with a specified pattern, you can select "Exclude" association type and not insert a destination folder.  @LF  @LF  - If you want to compress files that match with a specified pattern, you can select "Compress" association type.')

	Local $mListView, $mListView_Handle, $mNew, $mDeleteDummy, $mHelp, $mClose, $mEnterDummy, $mText, $mType, $mStringSplit
	Local $mIndex_Selected, $mAssociate, $mNewDummy

	Local $mProfile = __IsProfile(-1, 0) ; Get Array Of Current Profile.

	$mGUI = GUICreate(__Lang_Get('MANAGE_GUI', 'Manage Patterns') & ' [' & __Lang_Get('PROFILE', 'Profile') & ': ' & $mProfile[1] & ']', 420, 275, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))
	$Global_Manage = $mGUI

	$mListView = GUICtrlCreateListView(__Lang_Get('PATTERN', 'Pattern') & "|" & __Lang_Get('TYPE', 'Type') & "|" & __Lang_Get('DESCRIPTION', 'Description'), 10, 10, 400, 220, BitOR($LVS_NOSORTHEADER, $LVS_REPORT, $LVS_SINGLESEL))
	$mListView_Handle = GUICtrlGetHandle($mListView)

	$Global_ListViewRules = $mListView_Handle

	_GUICtrlListView_SetExtendedListViewStyle($mListView_Handle, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES))
	_GUICtrlListView_SetColumnWidth($mListView_Handle, 0, 110)
	_GUICtrlListView_SetColumnWidth($mListView_Handle, 1, 70)
	_GUICtrlListView_SetColumnWidth($mListView_Handle, 2, 215)

	_Manage_Update($mListView_Handle, $mProfile[1]) ; Add/Update The ListView With The Custom Patterns.

	$mDeleteDummy = GUICtrlCreateDummy()
	$Global_ListViewRules_Delete = $mDeleteDummy
	$mEnterDummy = GUICtrlCreateDummy()
	$Global_ListViewRules_Enter = $mEnterDummy
	$mNewDummy = GUICtrlCreateDummy()
	$Global_ListViewRules_New = $mNewDummy

	$mNew = GUICtrlCreateButton("&" & __Lang_Get('NEW', 'New'), 210 - 90 - 78, 240, 78, 26)
	GUICtrlSetTip($mNew, __Lang_Get('MANAGE_GUI_TIP_0', 'Click to add a pattern or Right-click a pattern to manage it.'))
	$mHelp = GUICtrlCreateButton("&" & __Lang_Get('HELP', 'Help'), 210 - 38, 240, 76, 26)
	GUICtrlSetTip($mHelp, __Lang_Get('MANAGE_GUI_TIP_1', 'Read some simple advices to use this feature.'))
	$mClose = GUICtrlCreateButton("&" & __Lang_Get('CLOSE', 'Close'), 210 + 90, 240, 78, 26)
	GUICtrlSetTip($mClose, __Lang_Get('MANAGE_GUI_TIP_2', 'Save pattern changes and close the window.'))
	GUICtrlSetState($mClose, 576)

	$Global_ListViewIndex = -1 ; Set As No Item Selected.
	GUIRegisterMsg(0x004E, "WM_NOTIFY")
	GUISetState(@SW_SHOW)
	Local $cHotKeys[3][2] = [["^n", $mNewDummy],["{DELETE}", $mDeleteDummy],["{ENTER}", $mEnterDummy]]
	GUISetAccelerators($cHotKeys)

	While 1
		__ReduceMemory() ; Reduce Memory Of DropIt.

		$mIndex_Selected = $Global_ListViewIndex

		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $mClose
				ExitLoop

			Case $mNew, $mNewDummy
				$mAssociate = _Manage_Edit_GUI(-1, -1, -1, -1, -1, $mGUI, 1) ; Show Manage Edit GUI For New Pattern.
				If $mAssociate = 1 Then $mProfile = _Manage_Update($mListView_Handle, $mProfile) ; Add/Update The ListView With The Custom Patterns.

			Case $mHelp
				_ExtMsgBox(0, __Lang_Get('OK', 'OK'), __Lang_Get('MANAGE_GUI_MSGBOX_0', 'Tips and Tricks'), $mTips, 0, __OnTop())

			Case $mDeleteDummy
				_Manage_Delete($mListView_Handle, $mIndex_Selected, $mProfile[0]) ; Delete Selected Pattern From Current Profile & ListView.

			Case $mEnterDummy
				$mIndex_Selected = _GUICtrlListView_GetSelectionMark($mListView_Handle)
				If Not _GUICtrlListView_GetItemState($mListView_Handle, $mIndex_Selected, $LVIS_SELECTED) Then ContinueLoop

				$mText = _GUICtrlListView_GetItemText($mListView_Handle, $mIndex_Selected)
				$mType = _GUICtrlListView_GetItemText($mListView_Handle, $mIndex_Selected, 1)
				If $mType = "Exclude" Then
					$mType = $mText & "$"
				ElseIf $mType = "Compress" Then
					$mType = $mText & "&"
				Else
					$mType = $mText
				EndIf
				$mStringSplit = StringSplit(IniRead($mProfile[0], "Patterns", $mType, ""), "|") ; Seperate Directory & Description
				If $mStringSplit[0] = 1 Then Local $mStringSplit[3] = [2, $mStringSplit[1], ""]
				$mType = _Manage_GetType($mListView_Handle, $mIndex_Selected)
				_Manage_Edit_GUI(-1, $mStringSplit[2], $mText, $mType, $mStringSplit[1], $mGUI, 0) ; Show Manage Edit GUI For Selected Pattern.
				If @error Then ContinueLoop
				_Manage_Update($mListView_Handle, -1) ; Add/Update The ListView With The Custom Patterns.
				_GUICtrlListView_SetItemSelected($mListView_Handle, $mIndex_Selected, True, True)

		EndSwitch
	WEnd
	GUIDelete($mGUI)

	__SetCurrentPosition() ; Set Current Coordinates/Position Of DropIt.
	__IsOnTop() ; Set GUI "OnTop" If True.

	If Not @error Then Return 1
	Return SetError(1, 1, 0)
EndFunc   ;==>_Manage_GUI

Func _Manage_Edit_GUI($mProfileName = -1, $mFileName = -1, $mFileNameExt = -1, $mType = -1, $mDirectory = -1, $mHandle = -1, $mNewAssociation = 0, $mDroppedEvent = 0)
	Local $mPatterns = __Lang_Get('MANAGE_EDIT_MSGBOX_7', 'Examples of supported pattern rules for files:  @LF  *.jpg   = all files with "jpg" extension  @LF  penguin.*   = all files named "penguin"  @LF  penguin*.*   = all files that begin with "penguin"  @LF  *penguin*   = all files that contain "penguin"  @LF  @LF  Examples of supported pattern rules for folders:  @LF  robot**   = all folders that begin with "robot"  @LF  **robot   = all folders that end with "robot"  @LF  **robot**   = all folders that contain "robot"  @LF  @LF  Separate several rules in a pattern with ";" to  @LF  create multi-rule patterns (eg:  *.jpg;*.png ).')
	Local $mExclusionPatterns = "Exclusion-Pattern"

	Local $mGUI, $mInput_Name, $mInput_Rule, $mInput_RuleData, $mButton_Rule, $mRadio_Normal, $mRadio_Exclude, $mRadio_Compress, $mInput_Directory, $mButton_Directory, $mSave, $mCancel
	Local $mInput_NameRead, $mInput_DirectoryRead, $mMsgBox, $mFolder, $mTEMPFileNameExt, $mAssociationType, $mItem = "", $mChanged = 0

	Local $mProfile = __IsProfile($mProfileName, 0) ; Get Array Of Current Profile.

	If $mFileName = -1 Then $mFileName = ""
	If $mFileNameExt = -1 Then $mFileNameExt = ""
	If $mType = -1 Then $mType = "Normal"
	If $mDirectory = -1 Or $mDirectory = "" Then $mDirectory = @ScriptDir
	If $mType = "Normal" And $mDirectory = $mExclusionPatterns Then $mDirectory = @ScriptDir
	$mInput_RuleData = $mFileNameExt

	Select
		Case $mNewAssociation = 0 And $mDroppedEvent = 0
			$mAssociationType = __Lang_Get('MANAGE_ASSOCIATION_EDIT', 'Edit Association')

		Case $mNewAssociation = 1 And $mDroppedEvent = 0
			$mAssociationType = __Lang_Get('MANAGE_ASSOCIATION_NEW', 'New Association')

		Case $mNewAssociation = 1 And $mDroppedEvent = 1
			$mAssociationType = __Lang_Get('MANAGE_ASSOCIATION_NEW', 'New Association')
			$mItem = "[" & __Lang_Get('PROFILE', 'Profile') & ": " & $mProfile[1] & "]"
			$mInput_RuleData = "**"
			If $mFileNameExt <> "0" Then $mInput_RuleData = "*." & $mFileNameExt ; $mFileNameExt = "0" If Loaded Item Is A Folder.
	EndSelect

	$mGUI = GUICreate($mAssociationType & " " & $mItem, 300, 300, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))
	GUICtrlCreateLabel(__Lang_Get('DESCRIPTION', 'Description') & ":", 10, 10, 120, 20)
	$mInput_Name = GUICtrlCreateInput($mFileName, 10, 31, 278, 20)
	GUICtrlSetTip($mInput_Name, __Lang_Get('MANAGE_EDIT_TIP_0', 'Choose a descrition for this association.'))

	GUICtrlCreateLabel(__Lang_Get('MANAGE_PATTERN_RULE', 'Pattern Rule') & ":", 10, 60 + 10, 120, 20)
	$mInput_Rule = GUICtrlCreateInput($mInput_RuleData, 10, 60 + 31, 205, 20)
	GUICtrlSetTip($mInput_Rule, __Lang_Get('MANAGE_EDIT_TIP_1', 'Write a pattern rule for this association.'))
	$mButton_Rule = GUICtrlCreateButton(__Lang_Get('INFO', 'Info'), 10 + 208, 60 + 30, 70, 22)
	GUICtrlSetTip($mButton_Rule, __Lang_Get('INFO', 'Info'))

	GUICtrlCreateLabel(__Lang_Get('MANAGE_ASSOCIATION_TYPE', 'Association Type') & ":", 10, 120 + 10, 120, 20)
	GUICtrlCreateGroup("", 10, 120 + 24, 278, 40)
	$mRadio_Normal = GUICtrlCreateRadio(__Lang_Get('NORMAL', 'Normal'), 25, 120 + 37, 78, 20)
	GUICtrlSetTip($mRadio_Normal, __Lang_Get('MANAGE_EDIT_TIP_2', 'Copy/Move matching files in destination folder.'))
	$mRadio_Exclude = GUICtrlCreateRadio(__Lang_Get('EXCLUDE', 'Exclude'), 110, 120 + 37, 78, 20)
	GUICtrlSetTip($mRadio_Exclude, __Lang_Get('MANAGE_EDIT_TIP_3', 'Ignore files that match with this pattern.'))
	$mRadio_Compress = GUICtrlCreateRadio(__Lang_Get('COMPRESS', 'Compress'), 194, 120 + 37, 78, 20)
	GUICtrlSetTip($mRadio_Compress, __Lang_Get('MANAGE_EDIT_TIP_4', 'Compress matching files in destination folder.') & @LF & __Lang_Get('MANAGE_EDIT_TIP_5', '(and Delete source files in "Move" mode)'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateLabel(__Lang_Get('MANAGE_DESTINATION_FOLDER', 'Destination Folder') & ":", 10, 190 + 10, 120, 20)
	$mInput_Directory = GUICtrlCreateInput($mDirectory, 10, 190 + 31, 205, 20)
	GUICtrlSetTip($mInput_Directory, __Lang_Get("MANAGE_EDIT_TIP_6", 'Select a destination folder for this association.'))
	$mButton_Directory = GUICtrlCreateButton(__Lang_Get('SEARCH', 'Search'), 10 + 208, 190 + 30, 70, 22)
	GUICtrlSetTip($mButton_Directory, __Lang_Get('SEARCH', 'Search'))

	Switch $mType
		Case "Exclude"
			GUICtrlSetState($mRadio_Exclude, $GUI_CHECKED)
			GUICtrlSetState($mInput_Directory, $GUI_DISABLE)
			GUICtrlSetState($mButton_Directory, $GUI_DISABLE)
		Case "Compress"
			GUICtrlSetState($mRadio_Compress, $GUI_CHECKED)
		Case Else
			GUICtrlSetState($mRadio_Normal, $GUI_CHECKED)
	EndSwitch

	$mSave = GUICtrlCreateButton("&" & __Lang_Get('SAVE', 'Save'), 150 - 20 - 76, 260, 76, 26)
	GUICtrlSetState($mSave, 144) ; Disable Save Button Initially.
	$mCancel = GUICtrlCreateButton("&" & __Lang_Get('CANCEL', 'Cancel'), 150 + 20, 260, 76, 26)
	GUICtrlSetState($mCancel, 576)

	GUISetState(@SW_SHOW)
	GUICtrlSetState($mInput_Name, 576)

	While 1
		__ReduceMemory() ; Reduce Memory Of DropIt.

		; Disable/Enable Save Button.
		If GUICtrlRead($mInput_Rule) <> "" And __StringIsValid(GUICtrlRead($mInput_Directory), "$&|") _
				And Not StringIsSpace(GUICtrlRead($mInput_Rule)) Then
			If GUICtrlGetState($mSave) > 80 Then GUICtrlSetState($mSave, 576) ; Change To 80 For Normal Or 144 For Disabled Or 576 For Focused.
			If GUICtrlGetState($mCancel) = 512 Then GUICtrlSetState($mCancel, 80) ; Change To 80 For Normal Or 144 For Disabled Or 576 For Focused.
		ElseIf GUICtrlRead($mInput_Rule) = "" Or Not __StringIsValid(GUICtrlRead($mInput_Directory), "$&|") _
				Or StringIsSpace(GUICtrlRead($mInput_Rule)) Then
			If GUICtrlGetState($mSave) = 80 Then GUICtrlSetState($mSave, 144) ; Change To 80 For Normal Or 144 For Disabled Or 576 For Focused.
			If GUICtrlGetState($mCancel) = 80 Then GUICtrlSetState($mCancel, 512) ; Change To 80 For Normal Or 144 For Disabled Or 576 For Focused.
		EndIf

		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $mCancel
				SetError(1, 1, 0)
				ExitLoop

			Case $mSave
				$mInput_NameRead = GUICtrlRead($mInput_Name)
				$mInput_DirectoryRead = GUICtrlRead($mInput_Directory)
				$mFileNameExt = StringLower(GUICtrlRead($mInput_Rule))
				If GUICtrlRead($mRadio_Normal) = $GUI_CHECKED Or GUICtrlRead($mRadio_Compress) = $GUI_CHECKED And Not __FilePathIsValid(_WinAPI_ExpandEnvironmentStrings($mInput_DirectoryRead)) Then
					_ExtMsgBox(64, __Lang_Get('OK', 'OK'), __Lang_Get('MANAGE_EDIT_MSGBOX_0', 'Directory Error'), __Lang_Get('MANAGE_EDIT_MSGBOX_1', 'You must specify a valid directory.'), 0, __OnTop($mGUI))
					ContinueLoop
				EndIf
				If Not FileExists(_WinAPI_ExpandEnvironmentStrings($mInput_DirectoryRead)) Then DirCreate(_WinAPI_ExpandEnvironmentStrings($mInput_DirectoryRead))

				Select
					Case GUICtrlRead($mRadio_Exclude) = $GUI_CHECKED
						$mTEMPFileNameExt = $mFileNameExt & "$"
						$mInput_DirectoryRead = $mExclusionPatterns
					Case GUICtrlRead($mRadio_Compress) = $GUI_CHECKED
						$mTEMPFileNameExt = $mFileNameExt & "&"
					Case Else
						$mTEMPFileNameExt = $mFileNameExt
				EndSelect
				If StringInStr($mFileNameExt, "*") And StringRight($mFileNameExt, 1) <> "$" And StringRight($mFileNameExt, 1) <> "&" And Not (StringInStr($mFileNameExt, "|")) And Not (StringInStr($mInput_DirectoryRead, "|")) And Not (StringInStr($mInput_NameRead, "|")) Then
					If IniRead($mProfile[0], "Patterns", $mFileNameExt, "0") = "0" And IniRead($mProfile[0], "Patterns", $mFileNameExt & "$", "0") = "0" And IniRead($mProfile[0], "Patterns", $mFileNameExt & "&", "0") = "0" Then
						$mMsgBox = 1
					Else
						If $mFileNameExt = $mInput_RuleData Then
							$mMsgBox = 1
						Else
							$mMsgBox = _ExtMsgBox(0, __Lang_Get('YES', 'Yes') & "|" & __Lang_Get('NO', 'No'), __Lang_Get('MANAGE_EDIT_MSGBOX_2', 'Replace association'), __Lang_Get('MANAGE_EDIT_MSGBOX_3', 'This pattern rule already exists. Do you want to replace it?'), 0, __OnTop())
						EndIf
						If $mMsgBox = 1 Then
							IniDelete($mProfile[0], "Patterns", $mFileNameExt)
							IniDelete($mProfile[0], "Patterns", $mFileNameExt & "$")
							IniDelete($mProfile[0], "Patterns", $mFileNameExt & "&")
						EndIf
					EndIf

					If $mMsgBox = 1 Then
						If $mNewAssociation = 0 Then
							IniDelete($mProfile[0], "Patterns", $mInput_RuleData)
							IniDelete($mProfile[0], "Patterns", $mInput_RuleData & "$")
							IniDelete($mProfile[0], "Patterns", $mInput_RuleData & "&")
						EndIf
						If $mInput_NameRead = "" Then
							IniWrite($mProfile[0], "Patterns", $mTEMPFileNameExt, $mInput_DirectoryRead)
						Else
							IniWrite($mProfile[0], "Patterns", $mTEMPFileNameExt, $mInput_DirectoryRead & "|" & $mInput_NameRead)
						EndIf
						$mChanged = 1
						ExitLoop
					EndIf
				Else
					_ExtMsgBox(64, __Lang_Get('OK', 'OK'), __Lang_Get('MANAGE_EDIT_MSGBOX_4', 'Pattern Error'), __Lang_Get('MANAGE_EDIT_MSGBOX_5', 'You have to insert a correct pattern ("$", "&", "|" characters cannot be used)'), 0, __OnTop())
				EndIf

			Case $mButton_Rule
				_ExtMsgBox(0, __Lang_Get('OK', 'OK'), __Lang_Get('MANAGE_EDIT_MSGBOX_6', 'Supported pattern rules'), $mPatterns, 0, __OnTop())

			Case $mRadio_Normal, $mRadio_Compress
				GUICtrlSetState($mInput_Directory, $GUI_ENABLE)
				GUICtrlSetState($mButton_Directory, $GUI_ENABLE)
				If GUICtrlRead($mInput_Directory) = $mExclusionPatterns Then GUICtrlSetData($mInput_Directory, "")

			Case $mRadio_Exclude
				GUICtrlSetState($mInput_Directory, $GUI_DISABLE)
				GUICtrlSetState($mButton_Directory, $GUI_DISABLE)
				If GUICtrlRead($mInput_Directory) = "" Then GUICtrlSetData($mInput_Directory, $mExclusionPatterns)

			Case $mButton_Directory
				$mFolder = FileSelectFolder(__Lang_Get('MANAGE_DESTINATION_FOLDER_SELECT', 'Select a destination folder:'), "", 3, "", $mGUI)
				If StringRight($mFolder, 1) = "\" Then $mFolder = StringTrimRight($mFolder, 1)
				If $mFolder <> "" Then GUICtrlSetData($mInput_Directory, $mFolder)

		EndSwitch
	WEnd
	GUIDelete($mGUI)

	If $mChanged = 1 Then Return $mChanged
	Return SetError(1, 1, 0)
EndFunc   ;==>_Manage_Edit_GUI

Func _Manage_Delete($mListView, $mIndex, $mProfile)
	Local $mMsgBox, $mPattern

	$mPattern = _GUICtrlListView_GetItemText($mListView, $mIndex)
	If @error Then Return SetError(1, 1, 0)

	If $mIndex = -1 Then Return SetError(1, 1, 0)
	If $mProfile = "" Then $mProfile = __IsProfile(-1, 0) ; Get Array Of Current Profile.
	If $mIndex <> -1 Then $mMsgBox = _ExtMsgBox(0, __Lang_Get('YES', 'Yes') & "|" & __Lang_Get('NO', 'No'), __Lang_Get('MANAGE_DELETE_MSGBOX_0', 'Delete association'), __Lang_Get('MANAGE_DELETE_MSGBOX_1', 'Selected pattern:') & "  " & $mPattern & @LF & __Lang_Get('MANAGE_DELETE_MSGBOX_2', 'Are you sure to delete this association?'), 0, __OnTop())
	If $mMsgBox <> 1 Then Return SetError(1, 1, 0)

	IniDelete($mProfile, "Patterns", $mPattern)
	_GUICtrlListView_DeleteItem($mListView, $mIndex)

	$Global_ListViewIndex = -1
	If Not @error Then Return 1
	Return SetError(1, 1, 0)
EndFunc   ;==>_Manage_Delete

Func _Manage_GetType($mListView = -1, $mIndex = -1)
	Local $mPattern, $mType

	If $mIndex = -1 Then Return SetError(1, 1, 0)

	$mPattern = _GUICtrlListView_GetItemText($mListView, 0)
	$mType = _GUICtrlListView_GetItemText($mListView, $mIndex, 1)

	Switch $mType
		Case "Exclude"
			$mPattern = $mPattern & "$"
		Case "Compress"
			$mPattern = $mPattern & "&"
		Case Else
			$mPattern = $mPattern
	EndSwitch

	Return $mType
EndFunc   ;==>_Manage_GetType

Func _Manage_Update($mListView, $mProfile)
	Local $mPatterns, $mFileNameExt_Pattern, $mFileNameExt_Shown, $mState

	$mPatterns = __GetPatterns($mProfile) ; Gets Patterns Array For The Current Profile.

	_GUICtrlListView_BeginUpdate($mListView)
	_GUICtrlListView_DeleteAllItems($mListView)
	For $A = 1 To $mPatterns[0][0]
		$mFileNameExt_Pattern = $mPatterns[$A][0]
		$mFileNameExt_Shown = $mFileNameExt_Pattern

		If StringRight($mFileNameExt_Pattern, 1) = "$" Or StringRight($mFileNameExt_Pattern, 1) = "&" Then $mFileNameExt_Shown = StringTrimRight($mFileNameExt_Pattern, 1)

		Select
			Case $mFileNameExt_Pattern = $mFileNameExt_Shown
				$mState = "Normal"

			Case StringRight($mFileNameExt_Pattern, 1) = "$"
				$mState = "Exclude"

			Case Else
				$mState = "Compress"
		EndSelect

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

	$cListView = GUICtrlCreateListView(__Lang_Get('PROFILE', 'Profile') & "|" & __Lang_Get('IMAGE', 'Image') & "|" & __Lang_Get('SIZE', 'Size') & "|" & __Lang_Get('TRANSPARENCY', 'Transparency'), 10, 10, 300, 155, BitOR($LVS_NOSORTHEADER, $LVS_REPORT, $LVS_SINGLESEL))
	$cListView_Handle = GUICtrlGetHandle($cListView)

	$Global_ListViewProfiles = $cListView_Handle

	_GUICtrlListView_SetExtendedListViewStyle($cListView_Handle, BitOR($LVS_EX_DOUBLEBUFFER, $LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_INFOTIP))
	_GUICtrlListView_SetColumnWidth($cListView_Handle, 0, 80)
	_GUICtrlListView_SetColumnWidth($cListView_Handle, 1, 95)
	_GUICtrlListView_SetColumnWidth($cListView_Handle, 2, 60)
	_GUICtrlListView_SetColumnWidth($cListView_Handle, 3, 60)

	_Customize_Update($cListView_Handle, $cProfileDirectory, $cProfileList) ; Add/Update Customise GUI With List Of Profiles.
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
		__ReduceMemory() ; Reduce Memory Of DropIt.

		Switch GUIGetMsg()
			Case $cClose, $GUI_EVENT_CLOSE
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
	$cInput_Name = GUICtrlCreateInput($cProfile[1], 10, 31, 178, 20) ; Renaming Function Will Have To Be Re-Built.
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

	$cIcon_GUI = GUICreate("", 0, 0, 205, 24, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_MDICHILD), $cGUI)
	$cIcon_Label = GUICtrlCreateLabel("", 0, 0, 32, 32)
	GUICtrlSetCursor($cIcon_Label, 0)
	GUICtrlSetTip($cIcon_Label, __Lang_Get('CUSTOMIZE_EDIT_TIP_1', 'Select an image for this profile.'))
	__SetBitmap($cIcon_GUI, $cProfile[8] & $cImage, 255 / 100 * $cProfile[7], 32, 32) ; Set Image & Resize To The Image GUI.

	GUISetState(@SW_SHOW, $cGUI)
	GUISetState(@SW_SHOW, $cIcon_GUI)

	GUIRegisterMsg(0x0114, "WM_HSCROLL") ; Required For Changing The Label Next To The Slider.

	While 1
		__ReduceMemory() ; Reduce Memory Of DropIt.

		; Disable/Enable Save Button.
		If GUICtrlRead($cInput_Name) <> "" And GUICtrlRead($cInput_Image) <> "" And GUICtrlRead($cInput_SizeX) <> "" And GUICtrlRead($cInput_SizeY) <> "" _
				And GUICtrlRead($cInput_Transparency) <> "" And __FilePathIsValid($cProfileDirectory[2][0] & GUICtrlRead($cInput_Image)) And Not StringIsSpace(GUICtrlRead($cInput_Name)) Then
			If GUICtrlGetState($cSave) > 80 Then GUICtrlSetState($cSave, 576) ; Change To 80 For Normal Or 144 For Disabled Or 576 For Focused.
			If GUICtrlGetState($cCancel) = 512 Then GUICtrlSetState($cCancel, 80) ; Change To 80 For Normal Or 144 For Disabled Or 576 For Focused.
		ElseIf GUICtrlRead($cInput_Name) = "" Or GUICtrlRead($cInput_Image) = "" Or GUICtrlRead($cInput_SizeX) = "" Or GUICtrlRead($cInput_SizeY) = "" _
				Or GUICtrlRead($cInput_Transparency) = "" Or Not __FilePathIsValid($cProfileDirectory[2][0] & GUICtrlRead($cInput_Image)) Or StringIsSpace(GUICtrlRead($cInput_Name)) Then
			If GUICtrlGetState($cSave) = 80 Then GUICtrlSetState($cSave, 144) ; Change To 80 For Normal Or 144 For Disabled Or 576 For Focused.
			If GUICtrlGetState($cCancel) = 80 Then GUICtrlSetState($cCancel, 512) ; Change To 80 For Normal Or 144 For Disabled Or 576 For Focused.
		EndIf

		; Disable/Enable Search Button.
		If GUICtrlRead($cInput_Name) <> "" And Not StringIsSpace(GUICtrlRead($cInput_Name)) Then
			If GUICtrlGetState($cButton_Image) > 80 Then GUICtrlSetState($cButton_Image, 80) ; Change To 80 For Normal Or 144 For Disabled Or 576 For Focused.
			If GUICtrlGetState($cButton_Size) > 80 Then GUICtrlSetState($cButton_Size, 80) ; Change To 80 For Normal Or 144 For Disabled Or 576 For Focused.
			If GUICtrlGetState($cInput_Transparency) > 80 Then GUICtrlSetState($cInput_Transparency, 80) ; Change To 80 For Normal Or 144 For Disabled Or 576 For Focused.
			If GUICtrlGetState($cInput_SizeX) > 80 Then GUICtrlSetState($cInput_SizeX, 80) ; Change To 80 For Normal Or 144 For Disabled Or 576 For Focused.
			If GUICtrlGetState($cInput_SizeY) > 80 Then GUICtrlSetState($cInput_SizeY, 80) ; Change To 80 For Normal Or 144 For Disabled Or 576 For Focused.
			If GUICtrlGetState($cInput_Image) > 80 Then GUICtrlSetState($cInput_Image, 80) ; Change To 80 For Normal Or 144 For Disabled Or 576 For Focused.
		ElseIf GUICtrlRead($cInput_Name) = "" Or StringIsSpace(GUICtrlRead($cInput_Name)) Then
			If GUICtrlGetState($cButton_Image) = 80 Then GUICtrlSetState($cButton_Image, 144) ; Change To 80 For Normal Or 144 For Disabled Or 576 For Focused.
			If GUICtrlGetState($cButton_Size) = 80 Then GUICtrlSetState($cButton_Size, 144) ; Change To 80 For Normal Or 144 For Disabled Or 576 For Focused.
			If GUICtrlGetState($cInput_Transparency) = 80 Then GUICtrlSetState($cInput_Transparency, 144) ; Change To 80 For Normal Or 144 For Disabled Or 576 For Focused.
			If GUICtrlGetState($cInput_SizeX) = 80 Then GUICtrlSetState($cInput_SizeX, 144) ; Change To 80 For Normal Or 144 For Disabled Or 576 For Focused.
			If GUICtrlGetState($cInput_SizeY) = 80 Then GUICtrlSetState($cInput_SizeY, 144) ; Change To 80 For Normal Or 144 For Disabled Or 576 For Focused.
			If GUICtrlGetState($cInput_Image) = 80 Then GUICtrlSetState($cInput_Image, 144) ; Change To 80 For Normal Or 144 For Disabled Or 576 For Focused.
		EndIf

		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $cCancel
				If $cProfile[1] <> $cInitialProfileName And $cNewProfile = 0 And $cNewProfileCreated = 0 Then
					FileMove($cProfileDirectory[1][0] & $cInitialProfileName & ".ini", $cProfileDirectory[1][0] & $cProfile[1] & ".ini")
					If $cInitialProfileName == __GetCurrentProfile() Then
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
					GUICtrlSetData($cInput_Image, $cReturn[1])
					$cImage = $cReturn[1]
					$cSizeX = $cReturn[2]
					$cSizeY = $cReturn[3]
					$cTransparency = $cReturn[4]

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
					_Image_Write($cItemText, 2, $cImage, $cReturn[0], $cReturn[1], 100) ; Write Size To The Selected Profile.
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
		_ExtMsgBox(64, __Lang_Get('OK', 'OK'), __Lang_Get('CUSTOMIZE_DELETE_MSGBOX_0', 'Profile Error'), __Lang_Get('CUSTOMIZE_DELETE_MSGBOX_1', 'You must have at least 1 active profile.'), 0, __OnTop($cHandle))
		Return SetError(1, 1, 0)
	EndIf

	Local $cMsgBox = _ExtMsgBox(0, __Lang_Get('YES', 'Yes') & "|" & __Lang_Get('NO', 'No'), __Lang_Get('CUSTOMIZE_DELETE_MSGBOX_2', 'Delete selected profile'), __Lang_Get('CUSTOMIZE_DELETE_MSGBOX_3', 'Selected profile:') & "  " & $cFileName & @LF & __Lang_Get('CUSTOMIZE_DELETE_MSGBOX_4', 'Are you sure to delete this profile?'), 0, __OnTop($cHandle))
	If $cMsgBox = 1 Then
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

Func _Customize_Update($cListView, $cProfileDirectory, $cProfileList = -1)
	Local $cListViewItem, $cIniReadTransparency, $cIniRead, $cIniRead_Size[2]

	If $cProfileList = -1 Or $cProfileList = 0 Or $cProfileList = "" Then $cProfileList = __ProfileList() ; Get Array Of All Profiles.
	If Not IsArray($cProfileList) Then Return SetError(1, 1, 0)

	If Not __IsFolder($cProfileDirectory) Then Return SetError(1, 1, 0) ; If Selected Is Not A Directory Then Return @error.

	_GUICtrlListView_BeginUpdate($cListView)
	_GUICtrlListView_DeleteAllItems($cListView)
	For $A = 1 To $cProfileList[0]
		$cListViewItem = _GUICtrlListView_AddItem($cListView, $cProfileList[$A])

		$cIniRead = IniRead($cProfileDirectory & $cProfileList[$A] & ".ini", "Target", "Image", "")
		If $cIniRead = "" Then $cIniRead = __GetDefault(16) ; Get Default Image File.
		_GUICtrlListView_AddSubItem($cListView, $cListViewItem, $cIniRead, 1)

		$cIniRead_Size[0] = IniRead($cProfileDirectory & $cProfileList[$A] & ".ini", "Target", "SizeX", "")
		$cIniRead_Size[1] = IniRead($cProfileDirectory & $cProfileList[$A] & ".ini", "Target", "SizeY", "")
		$cIniReadTransparency = IniRead($cProfileDirectory & $cProfileList[$A] & ".ini", "Target", "Transparency", "")

		If $cIniRead_Size[0] = "" Or $cIniRead_Size[1] = "" Then $cIniRead_Size = __ImageSize(__GetDefault(4) & $cIniRead) ; If X & Y Empty Then Find The Size Of The Image Using Default Image Directory.
		If Not IsArray($cIniRead_Size) Then Return SetError(1, 1, 0)

		_GUICtrlListView_AddSubItem($cListView, $cListViewItem, $cIniRead_Size[0] & "x" & $cIniRead_Size[1], 2)
		_GUICtrlListView_AddSubItem($cListView, $cListViewItem, $cIniReadTransparency & "%", 3)
	Next
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

	If @OSVersion = "WIN_XP" And __GetFilenameExt($iFileOpenDialog) = "gif" Then $iFileOpenDialog = __ImageConvert($iFileOpenDialog, $iImageFile[8])

	If Not StringInStr($iFileOpenDialog, $iImageFile[8]) Then
		FileCopy($iFileOpenDialog, $iImageFile[8])
		$iFileOpenDialog = $iImageFile[8] & __GetFilename($iFileOpenDialog) ; Get The File Name Of The Selected [FileName.txt].
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

	If $iImageFile == -1 Or $iImageFile == 0 Or $iImageFile == "" Then $iImageFile = __GetDefault(16) ; Get Default Image File.
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
	__ExpandEnvStrings(1)
	Local $dINI = __IsSettingsFile() ; Get Default Settings INI File.

	Local $dMsgBox, $dSize, $dFullSize, $dFailedList[1] = [0]
	If Not IsArray($dFiles) Then SetError(1, 1, 0)

	If Not __Is("AutoSort") Then
		$dMsgBox = _ExtMsgBox(0, __Lang_Get('YES', 'Yes') & "|" & __Lang_Get('NO', 'No'), __Lang_Get('DROP_EVENT_MSGBOX_0', 'Choose the DropIt Mode'), __Lang_Get('DROP_EVENT_MSGBOX_1', 'Do you want to "Move" these files to destination folders?') & @LF & __Lang_Get('DROP_EVENT_MSGBOX_2', '(otherwise they will be "Copied" to destination folders)'), 0, __OnTop())
		IniWrite($dINI, "General", "SortMode", "Copy")
		If $dMsgBox = 1 Then IniWrite($dINI, "General", "SortMode", "Move")
	EndIf

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

	If $dFullSize > 2147483648 Then
		$dMsgBox = _ExtMsgBox(0, __Lang_Get('YES', 'Yes') & "|" & __Lang_Get('NO', 'No'), __Lang_Get('DROP_EVENT_MSGBOX_3', 'Estimated long processing time'), __Lang_Get('DROP_EVENT_MSGBOX_4', 'You are trying to process a large size of files') & " (" & __ByteSuffix($dFullSize) & ")" & @LF & __Lang_Get('DROP_EVENT_MSGBOX_5', 'It may take long time, do you wish to continue?'), 0, __OnTop())
		If $dMsgBox <> 1 Then
			__Log_Write(__Lang_Get('DROP_EVENT_TIP_1', 'Sorting Aborted'), __Lang_Get('DROP_EVENT_MSGBOX_3', 'Estimated long processing time'))
			Return SetError(1, 1, 0)
		EndIf
	EndIf

	For $A = 0 To UBound($dFiles) - 1
		If FileExists($dFiles[$A]) Then $dFailedList = _PositionCheck($dFiles[$A], $dProfile, $dFailedList)
	Next

	; Report A List Of Failed Sortings
	If $dFailedList[0] > 0 Then
		Local $dFailedString
		For $A = 1 To $dFailedList[0]
			$dFailedString &= ">> " & $dFailedList[$A] & @CRLF ; Notepad Needs @CRLF Instead Of @LF To Create A New Line.
		Next
		If $dFailedList[0] < 10 Then
			_ExtMsgBox(48, __Lang_Get('OK', 'OK'), __Lang_Get('DROP_EVENT_MSGBOX_6', 'Sorting Partially Failed'), __Lang_Get('DROP_EVENT_MSGBOX_7', 'For the following files/folders sorting operations are failed:') & @LF & $dFailedString, 0, __OnTop())
		Else
			$dMsgBox = _ExtMsgBox(48, __Lang_Get('OPTIONS_BUTTON_0', 'Read') & "|" & __Lang_Get('CANCEL', 'Cancel'), __Lang_Get('DROP_EVENT_MSGBOX_6', 'Sorting Partially Failed'), __Lang_Get('DROP_EVENT_MSGBOX_8', 'For some files/folders sorting operations are failed. You can read a list of them from here.'), 0, __OnTop())
			If $dMsgBox = 1 Then
				Local $dFileName = @ScriptDir & "\FailedList.txt"
				Local $dFile = FileOpen($dFileName, 2)
				FileWriteLine($dFile, "{NOTE: this file will be removed after closing}")
				FileWriteLine($dFile, "")
				FileWriteLine($dFile, __Lang_Get('DROP_EVENT_MSGBOX_7', 'For the following files/folders sorting operations are failed:'))
				FileWrite($dFile, $dFailedString)
				FileClose($dFile)
				ShellExecuteWait($dFileName)
				FileDelete($dFileName)
			EndIf
		EndIf
	EndIf

	If Not @error Then Return 1
	Return SetError(1, 1, 0)
	__ExpandEnvStrings(0)
EndFunc   ;==>_DropEvent

Func _CheckingMatches($cFileName, $cFileNameExt, $cProfile) ; Returns: Directory [C:\DropItFiles] Or To Associate [0] Or To Skip [-1]
	$cProfile = __IsProfile($cProfile, 0) ; Get Array Of Selected Profile.
	Local $cCompressionEnabled = 0
	Local $cMatch, $cPattern, $cPatternToSplit, $cPatterns, $cMatches[1][2] = [[0, 2]]

	$cPatterns = __GetPatterns($cProfile[1]) ; Gets Patterns Array For The Current Profile.
	If @error Then Return SetError(1, 1, -1)

	For $A = 1 To $cPatterns[0][0]
		$cMatch = 0
		$cPatternToSplit = $cPatterns[$A][0]

		If StringRight($cPatterns[$A][0], 1) = "$" Or StringRight($cPatterns[$A][0], 1) = "&" Then $cPatternToSplit = StringTrimRight($cPatterns[$A][0], 1)
		Local $cStringSplit = StringSplit($cPatternToSplit, ";")

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

		If $cMatch = 1 And $cMatches[0][0] < 7 Then
			If UBound($cMatches, 1) <= $cMatches[0][1] + 1 Then ReDim $cMatches[UBound($cMatches, 1) * 2][UBound($cMatches, 2)] ; ReSize Array If More Items Are Required.
			$cMatches[0][0] += 1
			$cMatches[$cMatches[0][0]][0] = $cPatterns[$A][0]
			$cMatches[$cMatches[0][0]][1] = $cPatterns[$A][1]
		EndIf
	Next

	If $cMatches[0][0] = 1 Then
		If StringRight($cMatches[1][0], 1) = "$" Then
			Return SetError(1, 1, -1)
		Else
			If StringRight($cMatches[1][0], 1) = "&" Then $cCompressionEnabled = 1
			$Global_CompressionEnabled = $cCompressionEnabled
			ReDim $cMatches[$cMatches[0][0] + 1][UBound($cMatches, 2)] ; Delete Empty Spaces.
			Return $cMatches[$cMatches[0][0]][1]
		EndIf
	ElseIf $cMatches[0][0] > 1 Then
		ReDim $cMatches[$cMatches[0][0] + 1][UBound($cMatches, 2)] ; Delete Empty Spaces.
		$cMatch = _MoreMatches($cMatches, $cFileName)
		Return $cMatch
	EndIf
	Return SetError(1, 1, 0)
EndFunc   ;==>_CheckingMatches

Func _MoreMatches($mMatches, $mFileName)
	Local $mHandle = $Global_GUI_1
	Local $mCompressionEnabled = 0, $mExclusionPatterns = "Exclusion-Pattern"

	Local $mGUI, $mAdditional, $mRadioButtons[$mMatches[0][0] + 1] = [0], $mOK, $mCancel, $mRead = -1
	If Not IsArray($mMatches) Then Return SetError(1, 1, 0) ; Exit Function If Not An Array.
	$mGUI = GUICreate(__Lang_Get('MOREMATCHES_GUI', 'Pattern Ambiguity'), 280, 115 + 21 * $mMatches[0][0], -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	GUICtrlCreateGroup(__Lang_Get('MOREMATCHES_LABEL_0', 'Item loaded:'), 8, 6, 264, 40)
	GUICtrlCreateLabel($mFileName, 26, 24, 230, 20)
	GUICtrlSetTip($mFileName, __Lang_Get('MOREMATCHES_TIP_0', 'This item fits with several patterns.'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__Lang_Get('MOREMATCHES_LABEL_1', 'Select what pattern apply:'), 8, 52, 264, 22 + 21 * $mMatches[0][0])

	For $A = 1 To $mMatches[0][0]
		If StringRight($mMatches[$A][0], 1) = "$" Then
			$mAdditional = StringTrimRight($mMatches[$A][0], 1) & " [" & __Lang_Get('EXCLUDE', 'Exclude') & "]"
		ElseIf StringRight($mMatches[$A][0], 1) = "&" Then
			$mAdditional = StringTrimRight($mMatches[$A][0], 1) & " [" & __Lang_Get('COMPRESS', 'Compress') & "]"
		Else
			$mAdditional = $mMatches[$A][0] & " [" & __Lang_Get('NORMAL', 'Normal') & "]"
		EndIf
		$mRadioButtons[$A] = GUICtrlCreateRadio(" " & $mAdditional, 26, 46 + ($A * 21), 220, 20)
		$mRadioButtons[0] += 1
	Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$mOK = GUICtrlCreateButton("&" & __Lang_Get('OK', 'OK'), 140 - 20 - 66, 82 + 21 * $mMatches[0][0], 66, 24)
	$mCancel = GUICtrlCreateButton("&" & __Lang_Get('CANCEL', 'Cancel'), 140 + 20, 82 + 21 * $mMatches[0][0], 66, 24)
	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $mCancel
				$mRead = -1
				ExitLoop

			Case $mOK
				For $A = 1 To $mMatches[0][0]
					If GUICtrlRead($mRadioButtons[$A]) = 1 Then
						If StringRight($mMatches[$A][0], 1) = "&" Then $mCompressionEnabled = 1 ; Needed To Support Compress Type.
						$mRead = $mMatches[$A][1]
						ExitLoop 2
					EndIf
				Next
				_ExtMsgBox(64, __Lang_Get('OK', 'OK'), __Lang_Get('MESSAGE', 'Message'), __Lang_Get('MOREMATCHES_MSGBOX_0', 'You have to select a Pattern or abort this operation.'), 0, __OnTop())

		EndSwitch
	WEnd
	GUIDelete($mGUI)

	$Global_CompressionEnabled = $mCompressionEnabled
	If $mRead = -1 Or $mRead = $mExclusionPatterns Then Return SetError(1, 1, -1)
	Return $mRead
EndFunc   ;==>_MoreMatches

Func _PositionCheck($pFilePath, $pProfile, ByRef $pFailedList)
	Local $pSearch, $pFileName, $pFailedFile

	If __IsFolder($pFilePath) Then ; Checks If Selected Is A Directory.
		If __Is("DirForFolders") Then
			$pFailedFile = _PositionProcess($pFilePath, $pProfile)
			If Not @error And $pFailedFile <> 1 Then
				$pFailedList[0] += 1
				ReDim $pFailedList[$pFailedList[0] + 1]
				$pFailedList[$pFailedList[0]] = $pFailedFile
			EndIf
		Else
			$pSearch = FileFindFirstFile($pFilePath & "\*.*") ; Load Files.
			While 1
				$pFileName = FileFindNextFile($pSearch)
				If @error Then ExitLoop
				If Not __IsFolder($pFilePath & "\" & $pFileName) Then
					$pFailedFile = _PositionProcess($pFilePath & "\" & $pFileName, $pProfile) ; If Selected Is Not A Directory Then Process The File.
					If Not @error And $pFailedFile <> 1 Then
						$pFailedList[0] += 1
						ReDim $pFailedList[$pFailedList[0] + 1]
						$pFailedList[$pFailedList[0]] = $pFailedFile
					EndIf
				EndIf
			WEnd
			FileClose($pSearch)
			$pSearch = FileFindFirstFile($pFilePath & "\*.*") ; Load Folders.
			While 1
				$pFileName = FileFindNextFile($pSearch)
				If @error Then ExitLoop
				If __IsFolder($pFilePath & "\" & $pFileName) Then $pFailedList = _PositionCheck($pFilePath & "\" & $pFileName, $pProfile, $pFailedList) ; If Selected Is A Directory Then Process The Directory.
			WEnd
			FileClose($pSearch)
		EndIf
	Else
		$pFailedFile = _PositionProcess($pFilePath, $pProfile)
		If Not @error And $pFailedFile <> 1 Then
			$pFailedList[0] += 1
			ReDim $pFailedList[$pFailedList[0] + 1]
			$pFailedList[$pFailedList[0]] = $pFailedFile
		EndIf
	EndIf

	If Not @error Then Return $pFailedList
	Return SetError(1, 1, $pFailedList)
EndFunc   ;==>_PositionCheck

Func _PositionProcess($pFilePath, $pProfile)
	__ReduceMemory() ; Reduce Memory Of DropIt.
	Local $pINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $pCompressionEnabled = 0
	Local $pCompressionFormat = __7ZipCurrentFormat()

	Local $pIsDirectory, $pFileName, $pFileNameExt = 0, $pSortFailed = 0, $pMsgBox = 1, $pDestinationDirectory, $pFileNameWoExt, $pNumberExtension
	Local $pIsMove, $pAssociate, $A, $pSyntax

	$pIsMove = IniRead($pINI, "General", "SortMode", "Move") ; Read Into A Variable To Enhance Speed, Because This Will Be Called More Than Once.

	If __IsFolder($pFilePath) Then $pIsDirectory = 1 ; Checks If Selected Is A Directory.
	If $pIsDirectory Then ; If $pIsDirectory = 1 Then It Is A Directory.
		If StringRight($pFilePath, 1) = "\" Then $pFilePath = StringTrimRight($pFilePath, 1) ; If FilePath Has "\" At The End Of The String Delete.
		$pSyntax = "Folder"
	Else ; If $pIsDirectory = 0 Then It Is A File.
		$pFileNameExt = StringRegExpReplace($pFilePath, "^.*\.", "") ; Returns E.G. ini
		$pSyntax = "File"
	EndIf
	__Log_Write($pSyntax & " " & __Lang_Get('POSITIONPROCESS_TIP_0', 'Loaded'), $pFilePath)
	$pFileName = StringRegExpReplace($pFilePath, "^.*\\", "") ; Returns E.G. Example.ini

	; Check If The Pattern Matches
	$pDestinationDirectory = _CheckingMatches($pFileName, $pFileNameExt, $pProfile) ; Destination If OK, 0 To Associate, -1 To Skip.
	If $pDestinationDirectory == 0 Then
		If __Is("IgnoreNew") Then
			Return SetError(1, 1, 0)
		Else
			$pMsgBox = _ExtMsgBox(0, __Lang_Get('YES', 'Yes') & "|" & __Lang_Get('NO', 'No'), __Lang_Get('POSITIONPROCESS_MSGBOX_0', 'Association needed'), __Lang_Get('POSITIONPROCESS_MSGBOX_1', 'No association found for:') & @LF & $pFilePath & @LF & @LF & __Lang_Get('POSITIONPROCESS_MSGBOX_2', 'Do you want to associate a destination folder for it?'), 0, __OnTop())
			If $pMsgBox = 1 Then
				$pAssociate = _Manage_Edit_GUI($pProfile, $pFileName, $pFileNameExt, -1, -1, -1, 1, 1) ; Show Manage Edit GUI Of Selected Pattern.
				If $pAssociate <> 0 Then $pDestinationDirectory = _CheckingMatches($pFileName, $pFileNameExt, $pProfile) ; Destination If OK, 0 To Associate, -1 To Skip.
			EndIf
		EndIf
	EndIf
	If $pDestinationDirectory == 0 Or $pDestinationDirectory == -1 Or $pDestinationDirectory = "" Then
		If $pDestinationDirectory = -1 Then
			__Log_Write($pSyntax & " " & __Lang_Get('POSITIONPROCESS_TIP_1', 'Not Sorted'), __Lang_Get('POSITIONPROCESS_TIP_2', 'Skipped'))
		Else
			__Log_Write($pSyntax & " " & __Lang_Get('POSITIONPROCESS_TIP_1', 'Not Sorted'), __Lang_Get('POSITIONPROCESS_TIP_3', 'Aborted'))
		EndIf
		Return SetError(1, 1, -1) ; Exits In Not Associated Cases.
	EndIf

	; File Positioning
	If Not FileExists($pDestinationDirectory) Then
		Local $pIsDirectoryCreated = DirCreate($pDestinationDirectory)
		If Not $pIsDirectoryCreated Then
			_ExtMsgBox(48, __Lang_Get('OK', 'OK'), __Lang_Get('POSITIONPROCESS_MSGBOX_3', 'Destination folder problem'), __Lang_Get('POSITIONPROCESS_MSGBOX_4', 'Sorting operation has been partially skipped. The following destination folder does not exist and cannot be created:') & @LF & $pDestinationDirectory, 0, __OnTop())
			Return SetError(1, 1, -1) ; Exits The Function If @error Occured With Creating Directory.
		EndIf
	EndIf

	$pCompressionEnabled = $Global_CompressionEnabled
	$pFileNameWoExt = $pFileName
	If $pCompressionEnabled And $pIsDirectory Then ; If Compression Is Enabled And A Directory Then Create A Variable Containing $pFileName + .zip E.G. Test.zip
		$pFileNameWoExt = $pFileName & "." & $pCompressionFormat
	ElseIf $pCompressionEnabled And Not $pIsDirectory Then ; If Compression Is Enabled And A File Then Strip The Extension And Create A Variable Containing $pFileName + .zip E.G. Test.zip
		$pFileNameWoExt = StringTrimRight($pFileName, StringLen($pFileNameExt) + 1) & "." & $pCompressionFormat
	EndIf

	If FileExists($pDestinationDirectory & "\" & $pFileNameWoExt) Then
		If Not __Is("AutoDup") Then
			$pMsgBox = _ExtMsgBox(0, __Lang_Get('YES', 'Yes') & "|" & __Lang_Get('NO', 'No'), $pSyntax & " " & __Lang_Get('POSITIONPROCESS_MSGBOX_5', 'already exists'), '"' & $pFileNameWoExt & '" ' & __Lang_Get('POSITIONPROCESS_MSGBOX_6', 'already exists in destination folder.') & @LF & __Lang_Get('POSITIONPROCESS_MSGBOX_7', 'Do you want to overwrite it? (otherwise it will be skipped)'), 0, __OnTop())
			If $pMsgBox <> 1 Then
				$pSyntax &= " " & __Lang_Get('POSITIONPROCESS_TIP_5', 'Not Copied')
				If $pIsMove = "Move" Then $pSyntax &= " " & __Lang_Get('POSITIONPROCESS_TIP_4', 'Not Moved')
				__Log_Write($pSyntax, $pDestinationDirectory & "\" & $pFileNameWoExt)
				Return SetError(1, 1, 0) ; Exits The Function If No Is Selected.
			EndIf
		Else
			If IniRead($pINI, "General", "DupMode", "Overwrite") = "Skip" Then Return 1 ; Skip The Function By Returning 1.
			If IniRead($pINI, "General", "DupMode", "Overwrite") = "Rename" Then
				; $pDestinationDirectory & "\" & $pFileNameWoExt = _WinAPI_PathYetAnotherMakeUniqueName($pDestinationDirectory & "\" & $pFileNameWoExt)
				$A = 1
				While 1
					If $A < 10 Then
						$pNumberExtension = 0 & $A ; Creates 01, 02, 03, 04, 05 Til 09.
					Else
						$pNumberExtension = $A ; Creates 10, 11, 12, 13, 14 Etc...
					EndIf

					If $pCompressionEnabled And $pIsDirectory Then ; If Compression Enabled And Directory Then Create Prefix E.G. Test_01.zip
						$pFileNameWoExt = $pFileName & "_" & $pNumberExtension & "." & $pCompressionFormat
					ElseIf $pCompressionEnabled And Not $pIsDirectory Then ; If Compression Enabled And Not Directory Then Create Prefix E.G. Test_01.zip
						$pFileNameWoExt = StringTrimRight($pFileName, StringLen($pFileNameExt) + 1) & "_" & $pNumberExtension & "." & $pCompressionFormat
					EndIf

					If Not $pCompressionEnabled And $pIsDirectory Then ; If Not Compression Enabled And Directory Then Create Prefix E.G. Test_01
						$pFileNameWoExt = $pFileName & "_" & $pNumberExtension
					ElseIf Not $pCompressionEnabled And Not $pIsDirectory Then ; If Not Compression Enabled And Not Directory Then Create Prefix E.G. Test_01.ini
						$pFileNameWoExt = StringTrimRight($pFileName, StringLen($pFileNameExt) + 1) & "_" & $pNumberExtension & "." & $pFileNameExt
					EndIf
					If Not FileExists($pDestinationDirectory & "\" & $pFileNameWoExt) Then ExitLoop ; Exit Loop If FileName Is Unique.
					$A += 1
				WEnd
			EndIf
		EndIf
	EndIf

	If $pCompressionEnabled Then
		If $pMsgBox = 1 Then
			__7ZipRun(0, 1, $pFilePath, $pDestinationDirectory & "\" & $pFileNameWoExt)
			If @error Then
				$pSyntax &= " " & __Lang_Get('POSITIONPROCESS_TIP_6', 'Not Compressed')
				$pSortFailed = 1
			ElseIf $pIsMove = "Move" Then
				FileDelete($pFilePath) ; Delete Source File/Folder If Correctly Compressed In Move Mode.
				$pSyntax &= " " & __Lang_Get('POSITIONPROCESS_TIP_7', 'Compressed & Moved')
			Else
				$pSyntax &= " " & __Lang_Get('POSITIONPROCESS_TIP_8', 'Compressed & Copied')
			EndIf
		Else
			$pSyntax &= " " & __Lang_Get('POSITIONPROCESS_TIP_6', 'Not Compressed')
			$pSortFailed = 1
		EndIf

	Else
		If $pIsMove = "Move" Then ; Move Mode.
			Switch $pIsDirectory
				Case 0 ; Is A File.
					FileMove($pFilePath, $pDestinationDirectory & "\" & $pFileNameWoExt, 1) ; Move The File.
				Case 1 ; Is A Folder.
					DirMove($pFilePath, $pDestinationDirectory & "\" & $pFileNameWoExt, 1) ; Move The Directory.
			EndSwitch
			If @error Or Not FileExists($pDestinationDirectory & "\" & $pFileNameWoExt) Then
				$pSyntax &= " " & __Lang_Get('POSITIONPROCESS_TIP_4', 'Not Moved')
				$pSortFailed = 1
			Else
				$pSyntax &= " " & __Lang_Get('POSITIONPROCESS_TIP_9', 'Moved')
			EndIf

		Else ; Copy Mode.
			Switch $pIsDirectory
				Case 0 ; Is A File.
					FileCopy($pFilePath, $pDestinationDirectory & "\" & $pFileNameWoExt, 1) ; Copy The File.
				Case 1 ; Is A Folder.
					DirCopy($pFilePath, $pDestinationDirectory & "\" & $pFileNameWoExt, 1) ; Copy The Directory.
			EndSwitch
			If @error Or Not FileExists($pDestinationDirectory & "\" & $pFileNameWoExt) Then
				$pSyntax &= " " & __Lang_Get('POSITIONPROCESS_TIP_5', 'Not Copied')
				$pSortFailed = 1
			Else
				$pSyntax &= " " & __Lang_Get('POSITIONPROCESS_TIP_10', 'Copied')
			EndIf
		EndIf
	EndIf

	$Global_CompressionEnabled = 0
	__Log_Write($pSyntax, $pDestinationDirectory & "\" & $pFileNameWoExt)

	If $pSortFailed Then Return $pFileNameWoExt
	If Not @error Then Return 1
	Return SetError(1, 1, 0)
EndFunc   ;==>_PositionProcess
#Region End >>>>> Processing Functions <<<<<

#Region Start >>>>> Main Functions <<<<<
Func _Main()
	Local $mINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $mProfileList, $mRefresh, $mMsg

	__InstalledCheck() ; Check To See If DropIt Is Installed.
	__IsProfile() ; Checks If A Default Profile Is Available.
	$mProfileList = __ProfileList() ; Get Array Of All Profiles.
	$mRefresh = _Refresh($mProfileList) ; Refresh The Main GUI & TrayMenu, Including Translation Strings & ContextMenu.

	GUIRegisterMsg(0x004A, "WM_COPYDATA") ; WM_COPYDATA
	GUIRegisterMsg(0x0233, "WM_DROPFILES_UNICODE")
	GUIRegisterMsg(0x0111, "WM_LBUTTONDBLCLK")
	GUIRegisterMsg(0x0112, "WM_SYSCOMMAND")

	__Log_Write(__Lang_Get('DROPIT_STARTED', 'DropIt Started'), __Lang_Get('DATE', 'Date') & " " & @MDAY & "-" & @MON & "-" & @YEAR)

	While 1
		__ReduceMemory() ; Reduce Memory Of DropIt.

		If _IsPressed(10) And _IsPressed(01) Then WM_MOVE() ; Move GUI If Shift & Left Mouse Button Are Pushed.

		$mMsg = GUIGetMsg()
		Switch $mMsg
			Case $GUI_EVENT_CLOSE, $Global_ContextExit ; Exit DropIt If An Exit Event Is Called.
				ExitLoop

			Case $GUI_EVENT_DROPPED
				GUISetState(@SW_SHOW, $Global_GUI_2) ; Show Small Working Icon.
				_DropEvent($Global_DroppedFiles, -1) ; Send Dropped Files To Be Processed.
				GUISetState(@SW_HIDE, $Global_GUI_2) ; Hide Small Working Icon.

			Case $Global_ContextManage
				GUICtrlSetState($Global_Icon_1, $GUI_DISABLE) ; Disable Main Icon.
				_Manage_GUI($mINI, $Global_GUI_1) ; Open Manage GUI.
				$mRefresh = _Refresh($mProfileList) ; Refresh The Main GUI & TrayMenu, Including Translation Strings & ContextMenu.
				GUICtrlSetState($Global_Icon_1, $GUI_ENABLE) ; Enable Main Icon.

			Case $Global_ContextCustom
				GUICtrlSetState($Global_Icon_1, $GUI_DISABLE)
				$mProfileList = _Customize_GUI($Global_GUI_1, $mProfileList) ; Open Customize GUI.
				$mRefresh = _Refresh($mProfileList) ; Refresh The Main GUI & TrayMenu, Including Translation Strings & ContextMenu.
				GUICtrlSetState($Global_Icon_1, $GUI_ENABLE)

			Case $Global_ContextOptions
				GUICtrlSetState($Global_Icon_1, $GUI_DISABLE)
				_Options($Global_GUI_1) ; Open Options GUI.
				$mRefresh = _Refresh($mProfileList) ; Refresh The Main GUI & TrayMenu, Including Translation Strings & ContextMenu.
				GUICtrlSetState($Global_Icon_1, $GUI_ENABLE)

			Case $Global_ContextHide
				_TrayMenu_Show() ; Show The TrayMenu.

			Case $Global_ContextGuide
				If FileExists(@ScriptDir & "\Guide.pdf") Then ShellExecute(@ScriptDir & "\Guide.pdf")

			Case $Global_ContextReadme
				If FileExists(@ScriptDir & "\Readme.txt") Then ShellExecute(@ScriptDir & "\Readme.txt")

			Case $Global_ContextAbout
				_About()

			Case Else
				If $mMsg >= $mRefresh[1] And $mMsg <= $mRefresh[$mProfileList[0]] Then
					For $A = 1 To $mProfileList[0]
						If $mMsg = $mRefresh[$A] Then
							__Log_Write(__Lang_Get('MAIN_TIP_2', 'Changed Profile To'), $mProfileList[$A])
							$mINI = __SetCurrentProfile($mProfileList[$A]) ; Write Selected Profile Name To The Settings INI File.
							ExitLoop
						EndIf
					Next
					__SetCurrentPosition() ; Set Current Coordinates/Position Of DropIt.
					$mRefresh = _Refresh($mProfileList) ; Refresh The Main GUI & TrayMenu, Including Translation Strings & ContextMenu.
				EndIf

		EndSwitch
	WEnd
EndFunc   ;==>_Main

Func _About($aHandle = -1)
	Local $aGUI, $aIcon_GUI, $aIcon_Label, $aUpdateText, $aUpdateProgress, $aUpdate, $aLicense, $aClose

	$aGUI = GUICreate(__Lang_Get('ABOUT', 'About'), 400, 155, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($aHandle))
	GUICtrlCreateLabel("DropIt", 80, 10, 310, 25)
	GUICtrlSetFont(-1, 18)
	GUICtrlCreateLabel("(v" & _WinAPI_ExpandEnvironmentStrings("%VersionNo%") & ")", 80, 40, 310, 17)
	GUICtrlCreateLabel("", 80, 60, 310, 1) ; Single Line.
	GUICtrlSetBkColor(-1, 0x000000)
	GUICtrlCreateLabel(__Lang_Get('MAIN_TIP_0', 'Software developed by %Team%. @LF Released under %License%.'), 80, 70, 310, 45)

	$aUpdateText = GUICtrlCreateLabel('', 80, 101, 310, 18)
	If @OSVersion = "WIN_XP" Then
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
				If FileExists(@ScriptDir & "\License.txt") Then ShellExecute(@ScriptDir & "\License.txt")

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
			[$uFromDirectory & "Guide.pdf", @ScriptDir & "\", "M"], _
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
	If __Is("Update", "False") Then
		_ExtMsgBox(0, __Lang_Get('OK', 'OK'), __Lang_Get('UPDATE_MSGBOX_0', 'Successfully Updated'), __Lang_Get('UPDATE_MSGBOX_1', 'New version %VersionNo% is now ready to be used.'), -1, __OnTop())
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
		_ExtMsgBox(64, __Lang_Get('OK', 'OK'), __Lang_Get('UPDATE_MSGBOX_2', 'Check Failed'), __Lang_Get('UPDATE_MSGBOX_3', 'An error occurs during check for updates.'), -1, __OnTop())
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

	If $uVersion == _WinAPI_ExpandEnvironmentStrings("%VersionNo%") Then ; Check If Current And Online Versions Are The Same Or Not.
		GUICtrlSetData($uHandle, __Lang_Get('UPDATE_MSGBOX_4', 'You have the latest release available.'))
	Else
		; Extract Download URL From Web Page
		$uBefore = '<!--<update>'
		$uAfter = '</update>-->'
		$uBefore = StringInStr($uPage, $uBefore) + StringLen($uBefore)
		$uAfter = StringInStr(StringTrimLeft($uPage, $uBefore), $uAfter)
		$uDownloadURL = StringStripWS(StringMid($uPage, $uBefore, $uAfter), 3)

		$uMsgBox = _ExtMsgBox(0, __Lang_Get('YES', 'Yes') & "|" & __Lang_Get('NO', 'No'), __Lang_Get('UPDATE_MSGBOX_5', 'Update Available!'), StringReplace(__Lang_Get('UPDATE_MSGBOX_6', 'New version %NewVersion% of DropIt is available. @LF Do you want to update it now?'), '%NewVersion%', $uVersion), 0, __OnTop())
		If $uMsgBox <> 1 Then Return SetError(1, 1, 0)
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

			Sleep(105) ; Needed To Stop Flickering!
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

		__7ZipRun(1, 0, $uDownloadFile, __GetDefault(1) & "ZIP") ; __GetDefault(1) = Get The Default Settings Directory.
		If FileExists($uDownloadFile) Then FileDelete($uDownloadFile)
		_Update_Batch(@ScriptDir & "\" & "ZIP" & "\" & "DropIt_v" & StringReplace($uVersion, " ", "_") & "_" & StringTrimRight($uPackage, 4) & "\")
		IniWrite(__IsSettingsFile(), "General", "Update", "True")
		Run(@ScriptDir & "\" & "DropIt_Update.bat", @ScriptDir, @SW_HIDE)
		Exit
	EndIf

	If Not @error Then Return 1
	Return SetError(1, 1, 0)
EndFunc   ;==>_Update_Check

Func _Refresh($rProfileList = -1, $rHideGUI_1 = 0) ; 0 = Show The Main GUI & 1 = Hide The Main GUI (For Use In TrayMenu Mode)
	Local $rGUI_1 = $Global_GUI_1
	Local $rGUI_2 = $Global_GUI_2
	Local $rIcon_1 = $Global_Icon_1

	GUIDelete($rGUI_1)
	GUIDelete($rGUI_2)

	If Not IsArray($rProfileList) Then $rProfileList = __ProfileList() ; Get Array Of All Profiles.
	Local $rProfile = __IsProfile(-1, 0) ; Get Array Of Current Profile.

	Local $rContextMenu__ProfileList[$rProfileList[0] + 1] = [$rProfileList[0]]
	Local $rPosition = __GetCurrentPosition() ; Get Current Coordinates/Position Of DropIt.

	$rGUI_1 = GUICreate("DropIt", $rProfile[5], $rProfile[6] + 100, $rPosition[0], $rPosition[1], $WS_POPUP, BitOR($WS_EX_ACCEPTFILES, $WS_EX_LAYERED, $WS_EX_TOOLWINDOW, $WS_EX_TOPMOST))
	$Global_GUI_1 = $rGUI_1

	__SetHandle($UniqueID) ; Set Window Title For WM_COPYDATA.
	$rIcon_1 = GUICtrlCreateLabel("", 0, 0, $rProfile[5], $rProfile[6], $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
	$Global_Icon_1 = $rIcon_1
	GUICtrlSetState($rIcon_1, $GUI_DROPACCEPTED)
	GUICtrlSetTip($rIcon_1, "DropIt - " & __Lang_Get('TITLE_TOOLTIP', 'Sort your files with a drop!'))

	If $rProfile[7] < 10 Then
		$rProfile[7] = 100
		_Image_Write(-1, 4, -1, -1, -1, $rProfile[7]) ; Write Transparency To The Current Profile.
	EndIf

	__SetBitmap($rGUI_1, $rProfile[3], 255 / 100 * $rProfile[7], $rProfile[5], $rProfile[6]) ; Set Image & Resize To The GUI.

	; Context Menu - These Have To Be Global Variables.
	$Global_ContextMenu = GUICtrlCreateContextMenu($rIcon_1)
	$Global_ContextManage = GUICtrlCreateMenuItem(__Lang_Get('PATTERNS', 'Patterns'), $Global_ContextMenu, 0)
	GUICtrlCreateMenuItem("", $Global_ContextMenu, 1)
	$Global_ContextProfiles = GUICtrlCreateMenu(__Lang_Get('PROFILES', 'Profiles'), $Global_ContextMenu, 2)
	$Global_ContextOptions = GUICtrlCreateMenuItem(__Lang_Get('OPTIONS', 'Options'), $Global_ContextMenu, 3)
	$Global_ContextHide = GUICtrlCreateMenuItem(__Lang_Get('HIDE', 'Hide'), $Global_ContextMenu, 4)
	$Global_ContextHelp = GUICtrlCreateMenu(__Lang_Get('HELP', 'Help'), $Global_ContextMenu, 5)
	GUICtrlCreateMenuItem("", $Global_ContextMenu, 6)
	$Global_ContextExit = GUICtrlCreateMenuItem(__Lang_Get('EXIT', 'Exit'), $Global_ContextMenu, 7)
	$Global_ContextCustom = GUICtrlCreateMenuItem(__Lang_Get('CUSTOMIZE', 'Customize'), $Global_ContextProfiles)
	GUICtrlCreateMenuItem("", $Global_ContextProfiles)

	For $A = 1 To $rProfileList[0]
		$rContextMenu__ProfileList[$A] = GUICtrlCreateMenuItem($rProfileList[$A], $Global_ContextProfiles, $A + 1, 1)
		If $rProfileList[$A] = __GetCurrentProfile() Then GUICtrlSetState($rContextMenu__ProfileList[$A], 1) ; __GetCurrentProfile = Get Current Profile From The Settings INI File.
	Next

	$Global_ContextReadme = GUICtrlCreateMenuItem(__Lang_Get('README', 'Readme'), $Global_ContextHelp)
	$Global_ContextGuide = GUICtrlCreateMenuItem(__Lang_Get('GUIDE', 'Guide'), $Global_ContextHelp)
	$Global_ContextAbout = GUICtrlCreateMenuItem(__Lang_Get('ABOUT', 'About') & "...", $Global_ContextHelp)

	__GUIInBounds($rGUI_1) ; Checks If The GUI Is Within View Of The Users Screen.

	$rGUI_2 = GUICreate("", 16, 16, $rProfile[5] / 5, $rProfile[6] / 5, $WS_POPUP, BitOR($WS_EX_MDICHILD, $WS_EX_LAYERED, $WS_EX_TOPMOST), $rGUI_1)
	$Global_GUI_2 = $rGUI_2

	GUISetBkColor(0x000001)
	_WinAPI_SetLayeredWindowAttributes($rGUI_2, 0x00000001, 0x00, 1, 0)
	Local $rLabelIconImage = GUICtrlCreateLabel("", 0, 0, 16, 16)
	_ResourceSetImageToCtrl($rLabelIconImage, "ZZ")

	#cs Will Be Used For The GIF Animation.
		_GUICtrlCreateGIF(@AutoItExe, "10;ZZ;1033", 0, 0, $rImage)
		GUISetBkColor(345) ; ; Make GUI Transparent & Create Some Random Color.
		_WinAPI_SetLayeredWindowAttributes($rGUI_2, 345, 255) ; Making The GUI Transparent.
		_WinAPI_SetParent($rGUI_2, 0)
	#ce

	If $rHideGUI_1 = 0 Then ;  This Is Required If The Options Dialogue Box Is Selected From The TrayMenu, Because The Strings Need To Be Refreshed If The Language Changes & The Main GUI Needs To Be Hidden If In TrayMenu Mode.
		GUISetState(@SW_SHOW, $rGUI_1)
	Else
		GUISetState(@SW_HIDE, $rGUI_1)
	EndIf
	GUISetState(@SW_HIDE, $rGUI_2)
	_WinAPI_SetFocus(GUICtrlGetHandle($rIcon_1)) ; Sets The $Global_Icon_1 Label As Having Focus, Used For The HotKeys.

	If __Is("UseSendTo") Then
		__SendTo_Uninstall() ; Delete SendTo Shortcuts.
		__SendTo_Install() ; Create SendTo Shortcuts.
	EndIf
	_TrayMenu_Create() ; Create A Hidden TrayMenu.
	Return $rContextMenu__ProfileList
EndFunc   ;==>_Refresh

Func _Options($oHandle = -1)
	Local $oINI = __IsSettingsFile() ; Get Default Settings INI File.

	Local $oCheckItems[12] = [11], $oRadioItems[8] = [7], $oComboItems[6] = [5], $oGroup[6] = [5], $oCurrent[6] = [5]
	Local $oINI_TrueOrFalse_Array[12][3] = [ _
			[11, 3], _
			["General", "OnTop", 1], _
			["General", "LockPosition", 1], _
			["General", "MultipleInstances", 1], _
			["General", "UseSendTo", 1], _
			["General", "CreateLog", 1], _
			["General", "DirForFolders", 1], _
			["General", "IgnoreNew", 1], _
			["General", "AutoSort", 1], _
			["General", "AutoDup", 1], _
			["General", "ArchiveSelf", 1], _
			["General", "ArchiveEncrypt", 1]]
	Local $oINI_Various_Array[9][3] = [ _
			[8, 3], _
			["General", "SendToMode", 2], _
			["General", "SortMode", 2], _
			["General", "DupMode", 3], _
			["General", "ArchiveFormat", 2], _
			["General", "ArchiveLevel", 5], _
			["General", "ArchiveMethod", 4], _
			["General", "ArchiveEncryptMethod", 2], _
			["General", "ArchivePassword", 1]]

	Local $oPW, $oPW_Code = $oGlobal_PW_Code
	Local $oLogFile = __GetDefault(513) ; Get Default Directory & LogFile File Name.
	Local $oGUI, $oLog, $oWriteLog, $oBackup, $oRestore, $oClear, $oState, $oPassword, $oShowPassword, $oTab, $oOK, $oCancel, $oMsgBox

	$oGUI = GUICreate(__Lang_Get('OPTIONS', 'Options'), 300, 345, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($oHandle))

	GUICtrlCreateTab(4, 3, 293, 305) ; Create Tab Menu.

	; Main Tab
	GUICtrlCreateTabItem(__Lang_Get('OPTIONS_TAB_0', 'Main'))
	GUICtrlSetState(-1, $GUI_SHOW) ; Show This Tab At Options Opening.

	; Group Of General Options
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_0', 'General'), 10, 30, 279, 85)
	$oCheckItems[1] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_0', 'Show target image always on top'), 25, 30 + 15)
	$oCheckItems[2] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_7', 'Lock target image position'), 25, 30 + 15 + 20)
	$oCheckItems[3] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_8', 'Enable multiple instances'), 25, 30 + 15 + 40)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Group Of Integration Options
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_6', 'Integration'), 10, 120, 279, 65)
	$oCheckItems[4] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_6', 'Integrate DropIt in SendTo menu'), 25, 120 + 15)
	$oRadioItems[1] = GUICtrlCreateRadio(__Lang_Get('OPTIONS_MODE_5', 'Permanent'), 25 + 25, 120 + 15 + 22, 90, 20)
	GUICtrlSetTip($oRadioItems[1], __Lang_Get('OPTIONS_TIP_0', 'The integration remains also when DropIt is closed.'))
	$oRadioItems[2] = GUICtrlCreateRadio(__Lang_Get('OPTIONS_MODE_6', 'Portable'), 25 + 145, 120 + 15 + 22, 90, 20)
	GUICtrlSetTip($oRadioItems[2], __Lang_Get('OPTIONS_TIP_1', 'The integration is created at DropIt startup and removed at the end.'))
	GUICtrlCreateGroup('', -99, -99, 1, 1)

	; Group Of Language Options
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_1', 'Language'), 10, 190, 279, 50)
	$oComboItems[1] = GUICtrlCreateCombo("", 25, 190 + 15 + 3, 250, 25, 0x0003)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Group Of Backup Options
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_2', 'Settings Backup'), 10, 245, 279, 50)
	$oBackup = GUICtrlCreateButton(__Lang_Get('OPTIONS_BUTTON_1', 'Backup'), 25, 245 + 15 + 3, 73, 22)
	GUICtrlSetTip($oBackup, __Lang_Get('OPTIONS_BUTTON_1', 'Backup'))
	$oRestore = GUICtrlCreateButton(__Lang_Get('OPTIONS_BUTTON_2', 'Restore'), 25 + 88, 245 + 15 + 3, 73, 22)
	GUICtrlSetTip($oRestore, __Lang_Get('OPTIONS_BUTTON_2', 'Restore'))
	$oClear = GUICtrlCreateButton(__Lang_Get('OPTIONS_BUTTON_3', 'Clear'), 25 + 177, 245 + 15 + 3, 73, 22)
	GUICtrlSetTip($oClear, __Lang_Get('OPTIONS_BUTTON_3', 'Clear'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Sorting Tab
	GUICtrlCreateTabItem(__Lang_Get('OPTIONS_TAB_1', 'Sorting'))

	; Group Of Association Options
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_3', 'Association'), 10, 30, 279, 65)
	$oCheckItems[6] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_2', 'Enable association also for folders'), 25, 30 + 15)
	$oCheckItems[7] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_3', 'Ignore unassociated files/folders'), 25, 30 + 15 + 20)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Group Of Positioning Options
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_4', 'Positioning Mode'), 10, 100, 279, 65)
	$oCheckItems[8] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_4', 'Use automatic positioning mode'), 25, 100 + 15)
	$oRadioItems[3] = GUICtrlCreateRadio(__Lang_Get('OPTIONS_MODE_0', 'Copy'), 25 + 25, 100 + 15 + 22, 90, 20)
	GUICtrlSetTip($oRadioItems[3], __Lang_Get('OPTIONS_MODE_0', 'Copy'))
	$oRadioItems[4] = GUICtrlCreateRadio(__Lang_Get('OPTIONS_MODE_1', 'Move'), 25 + 145, 100 + 15 + 22, 90, 20)
	GUICtrlSetTip($oRadioItems[4], __Lang_Get('OPTIONS_MODE_1', 'Move'))
	GUICtrlCreateGroup('', -99, -99, 1, 1)

	; Group Of Duplicates Options
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_5', 'Manage Duplicates'), 10, 170, 279, 65)
	$oCheckItems[9] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_5', 'Use automatic choice for duplicates'), 25, 170 + 15)
	$oRadioItems[5] = GUICtrlCreateRadio(__Lang_Get('OPTIONS_MODE_2', 'Overwrite'), 25, 170 + 15 + 22, 90, 20)
	GUICtrlSetTip($oRadioItems[5], __Lang_Get('OPTIONS_MODE_2', 'Overwrite'))
	$oRadioItems[6] = GUICtrlCreateRadio(__Lang_Get('OPTIONS_MODE_3', 'Skip'), 25 + 92, 170 + 15 + 22, 80, 20)
	GUICtrlSetTip($oRadioItems[6], __Lang_Get('OPTIONS_MODE_3', 'Skip'))
	$oRadioItems[7] = GUICtrlCreateRadio(__Lang_Get('OPTIONS_MODE_4', 'Rename'), 25 + 174, 170 + 15 + 22, 80, 20)
	GUICtrlSetTip($oRadioItems[7], __Lang_Get('OPTIONS_MODE_4', 'Rename'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Group Of Log Options
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_7', 'Sorting Log'), 10, 240, 279, 45)
	$oCheckItems[5] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_1', 'Create sorting log file'), 25, 240 + 15)
	$oLog = GUICtrlCreateButton(__Lang_Get('OPTIONS_BUTTON_0', 'Read'), 25 + 180, 240 + 15, 70, 22)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Compression Tab
	$oTab = GUICtrlCreateTabItem(__Lang_Get('OPTIONS_TAB_2', 'Compression'))

	; Group Of Settings Options
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_8', 'Modality'), 10, 30, 279, 135)
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_10', 'Format') & ":", 25, 30 + 15 + 6, 90, 20)
	$oComboItems[2] = GUICtrlCreateCombo("", 25 + 100, 30 + 15 + 3, 150, 20, 0x0003)
	GUICtrlSetData($oComboItems[2], "", "")
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_11', 'Level') & ":", 25, 30 + 15 + 30 + 6, 90, 20)
	$oComboItems[3] = GUICtrlCreateCombo("", 25 + 100, 30 + 15 + 30 + 3, 150, 20, 0x0003)
	GUICtrlSetData($oComboItems[3], "", "")
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_12', 'Method') & ":", 25, 30 + 15 + 60 + 6, 90, 20)
	$oComboItems[4] = GUICtrlCreateCombo("", 25 + 100, 30 + 15 + 60 + 3, 150, 20, 0x0003)
	GUICtrlSetData($oComboItems[4], "", "")
	$oCheckItems[10] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_9', 'Create self-extracting archives'), 25, 30 + 15 + 90)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Group Of Extra Options
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_9', 'Encryption'), 10, 170, 279, 110)
	$oCheckItems[11] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_10', 'Encrypt compressed files/folders'), 25, 170 + 15 + 3)
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_13', 'Password') & ":", 25, 170 + 15 + 30 + 3, 90, 20)
	$oPassword = GUICtrlCreateInput("", 25 + 100, 170 + 15 + 30, 140, 20, 0x0020)
	$oShowPassword = GUICtrlCreateButton("", 25 + 100 + 140, 170 + 15 + 30, 10, 20)
	GUICtrlSetTip($oShowPassword, __Lang_Get('OPTIONS_TIP_2', 'Show/Hide the password.'))
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_12', 'Method') & ":", 25, 170 + 15 + 60 + 3, 90, 20)
	$oComboItems[5] = GUICtrlCreateCombo("", 25 + 100, 170 + 15 + 60, 150, 20, 0x0003)
	GUICtrlSetData($oComboItems[5], "", "")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateTabItem("") ; Close Tab Menu.

	; Checkbox Settings
	For $A = 1 To 11
		If $oINI_TrueOrFalse_Array[$A][0] = "" Or $oINI_TrueOrFalse_Array[$A][1] = "" Then ContinueLoop
		If __Is($oINI_TrueOrFalse_Array[$A][1]) Then GUICtrlSetState($oCheckItems[$A], $GUI_CHECKED)
	Next

	; Combo Settings
	$oGroup[1] = __Lang_Combo()
	$oCurrent[1] = __GetCurrentLanguage()
	$oGroup[2] = "7Z|ZIP"
	$oCurrent[2] = IniRead($oINI, "General", "ArchiveFormat", "ZIP")
	$oGroup[3] = "Fastest|Fast|Normal|Maximum|Ultra"
	$oCurrent[3] = IniRead($oINI, "General", "ArchiveLevel", "Normal")
	$oGroup[4] = "LZMA|LZMA2|PPMd|BZip2"
	If $oCurrent[2] = "ZIP" Then $oGroup[4] = "Deflate|LZMA|PPMd|BZip2"
	$oCurrent[4] = IniRead($oINI, "General", "ArchiveMethod", "LZMA")
	$oGroup[5] = "AES-256"
	If $oCurrent[2] = "ZIP" Then $oGroup[5] = "ZipCrypto|AES-256"
	$oCurrent[5] = IniRead($oINI, "General", "ArchiveEncryptMethod", "AES-256")
	For $A = 1 To 5
		GUICtrlSetData($oComboItems[$A], $oGroup[$A], $oCurrent[$A])
	Next

	; Integration Settings
	$oState = $GUI_DISABLE
	If GUICtrlRead($oCheckItems[4]) = 1 Then $oState = $GUI_ENABLE
	For $A = 1 To 2
		GUICtrlSetState($oRadioItems[$A], $oState)
	Next
	If IniRead($oINI, "General", "SendToMode", "Portable") = "Portable" Then
		GUICtrlSetState($oRadioItems[1], 4)
		GUICtrlSetState($oRadioItems[2], 1)
	Else
		GUICtrlSetState($oRadioItems[1], 1)
		GUICtrlSetState($oRadioItems[2], 4)
	EndIf

	; Backup Settings
	For $A = $oBackup To $oRestore ; Disable Buttons If 7-Zip Is Missing.
		If Not FileExists(@ScriptDir & "\Lib\7z.exe") Then GUICtrlSetState($A, $GUI_DISABLE)
	Next
	If Not FileExists(__GetDefault(32)) Then GUICtrlSetState($oClear, $GUI_DISABLE) ; __GetDefault(32) = Get Default Backup Directory.

	; Positioning Mode Settings
	$oState = $GUI_DISABLE
	If GUICtrlRead($oCheckItems[8]) = 1 Then $oState = $GUI_ENABLE
	For $A = 3 To 4
		GUICtrlSetState($oRadioItems[$A], $oState)
	Next
	If IniRead($oINI, "General", "SortMode", "Move") = "Move" Then
		GUICtrlSetState($oRadioItems[3], 4)
		GUICtrlSetState($oRadioItems[4], 1)
	Else
		GUICtrlSetState($oRadioItems[3], 1)
		GUICtrlSetState($oRadioItems[4], 4)
	EndIf

	; Duplicate Mode Settings
	$oState = $GUI_DISABLE
	If GUICtrlRead($oCheckItems[9]) = 1 Then $oState = $GUI_ENABLE
	For $A = 5 To 7
		GUICtrlSetState($oRadioItems[$A], $oState)
	Next
	If IniRead($oINI, "General", "DupMode", "Overwrite") = "Overwrite" Then
		GUICtrlSetState($oRadioItems[5], 1)
		GUICtrlSetState($oRadioItems[6], 4)
		GUICtrlSetState($oRadioItems[7], 4)
	ElseIf IniRead($oINI, "General", "DupMode", "Overwrite") = "Skip" Then
		GUICtrlSetState($oRadioItems[5], 4)
		GUICtrlSetState($oRadioItems[6], 1)
		GUICtrlSetState($oRadioItems[7], 4)
	Else
		GUICtrlSetState($oRadioItems[5], 4)
		GUICtrlSetState($oRadioItems[6], 4)
		GUICtrlSetState($oRadioItems[7], 1)
	EndIf

	; Log Settings
	If GUICtrlRead($oCheckItems[5]) = 1 Then
		GUICtrlSetState($oLog, $GUI_ENABLE)
	Else
		GUICtrlSetState($oLog, $GUI_DISABLE)
	EndIf

	; Self-Extracting Settings
	If GUICtrlRead($oComboItems[2]) = "ZIP" Then GUICtrlSetState($oCheckItems[10], $GUI_DISABLE)

	; Encryption Settings
	$oState = $GUI_DISABLE
	If GUICtrlRead($oCheckItems[11]) = 1 Then $oState = $GUI_ENABLE
	GUICtrlSetState($oPassword, $oState)
	GUICtrlSetState($oShowPassword, $oState)
	GUICtrlSetState($oComboItems[5], $oState)
	$oPW = IniRead($oINI, "General", "ArchivePassword", "")
	If $oPW <> "" Then GUICtrlSetData($oPassword, _StringEncrypt(0, $oPW, $oPW_Code))

	$oOK = GUICtrlCreateButton("&" & __Lang_Get('OK', 'OK'), 150 - 20 - 76, 313, 76, 25)
	$oCancel = GUICtrlCreateButton("&" & __Lang_Get('CANCEL', 'Cancel'), 150 + 20, 313, 76, 25)
	GUICtrlSetState($oOK, $GUI_FOCUS)
	GUISetState(@SW_SHOW)

	While 1
		__ReduceMemory() ; Reduce Memory Of DropIt.

		; Update Combo If Format Changes
		If GUICtrlRead($oComboItems[2]) <> $oCurrent[2] And Not _GUICtrlComboBox_GetDroppedState($oComboItems[2]) Then
			$oCurrent[2] = GUICtrlRead($oComboItems[2])
			Switch $oCurrent[2]
				Case "7Z"
					$oGroup[4] = "LZMA|LZMA2|PPMd|BZip2"
					$oGroup[5] = "AES-256"
					GUICtrlSetState($oCheckItems[10], $GUI_ENABLE)
				Case "ZIP"
					$oGroup[4] = "Deflate|LZMA|PPMd|BZip2"
					$oGroup[5] = "ZipCrypto|AES-256"
					GUICtrlSetState($oCheckItems[10], 4)
					GUICtrlSetState($oCheckItems[10], $GUI_DISABLE)
			EndSwitch
			$oCurrent[4] = GUICtrlRead($oComboItems[4])
			If Not StringInStr($oGroup[4], $oCurrent[4]) Then $oCurrent[4] = "LZMA"
			$oCurrent[5] = GUICtrlRead($oComboItems[5])
			If Not StringInStr($oGroup[5], $oCurrent[5]) Then $oCurrent[5] = "AES-256"
			For $A = 4 To 5
				_GUICtrlComboBox_ResetContent($oComboItems[$A])
				GUICtrlSetData($oComboItems[$A], $oGroup[$A], $oCurrent[$A])
			Next
		EndIf

		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $oCancel
				SetError(1, 1, 0)
				ExitLoop

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

			Case $oCheckItems[8] ; Positioning Mode Checkbox.
				$oState = $GUI_DISABLE
				If GUICtrlRead($oCheckItems[8]) = 1 Then $oState = $GUI_ENABLE
				For $A = 3 To 4
					GUICtrlSetState($oRadioItems[$A], $oState)
				Next

			Case $oCheckItems[9] ; Duplicate Mode Checkbox.
				$oState = $GUI_DISABLE
				If GUICtrlRead($oCheckItems[9]) = 1 Then $oState = $GUI_ENABLE
				For $A = 5 To 7
					GUICtrlSetState($oRadioItems[$A], $oState)
				Next

			Case $oCheckItems[11] ; Encryption Checkbox.
				$oState = $GUI_DISABLE
				If GUICtrlRead($oCheckItems[11]) = 1 Then $oState = $GUI_ENABLE
				GUICtrlSetState($oPassword, $oState)
				GUICtrlSetState($oShowPassword, $oState)
				GUICtrlSetState($oComboItems[5], $oState)

			Case $oLog
				If FileExists($oLogFile[1][0] & $oLogFile[2][0]) Then
					ShellExecute($oLogFile[1][0] & $oLogFile[2][0])
				Else
					GUICtrlSetState($oCheckItems[5], 4)
					GUICtrlSetState($oLog, $GUI_DISABLE)
				EndIf

			Case $oBackup
				__Backup_Restore($oGUI, 0) ; Backup The Settings INI File & Profiles.
				GUICtrlSetState($oClear, $GUI_ENABLE)

			Case $oRestore
				__Backup_Restore($oGUI, 1) ; Restore A Selected Backup File.

			Case $oClear
				__Backup_Restore($oGUI, 2) ; Clear All Backups In The Default Backup Folder.
				If Not @error Then GUICtrlSetState($oClear, $GUI_DISABLE)

			Case $oShowPassword
				$oPassword = __ShowPassword($oGUI, $oPassword, $oTab)

			Case $oOK
				__SetCurrentLanguage(GUICtrlRead($oComboItems[1])) ; Sets The Selected Language To The Settings INI File.
				If GUICtrlRead($oCheckItems[4]) <> 1 And __Is("UseSendTo") Then __SendTo_Uninstall() ; Delete SendTo Shortcuts If SendTo Is Been Disabled Now.

				If __Is("CreateLog") And GUICtrlRead($oCheckItems[5]) <> 1 Then __Log_Write(__Lang_Get('LOG_DISABLED', 'Log Disabled'), __Lang_Get('DATE', 'Date') & " " & @MDAY & "-" & @MON & "-" & @YEAR)
				If Not __Is("CreateLog") And GUICtrlRead($oCheckItems[5]) = 1 Then $oWriteLog = 1 ; Needed To Write "Log Enabled" After Log Activation.

				For $A = 1 To 11
					$oState = "False"
					If $oINI_TrueOrFalse_Array[$A][0] = "" Or $oINI_TrueOrFalse_Array[$A][1] = "" Then ContinueLoop
					If GUICtrlRead($oCheckItems[$A]) = 1 Then $oState = "True"
					IniWrite($oINI, $oINI_TrueOrFalse_Array[$A][0], $oINI_TrueOrFalse_Array[$A][1], $oState)
				Next

				If $oWriteLog = 1 Then __Log_Write(__Lang_Get('LOG_ENABLED', 'Log Enabled'), __Lang_Get('DATE', 'Date') & " " & @MDAY & "-" & @MON & "-" & @YEAR)

				$oState = "Permanent"
				If GUICtrlRead($oRadioItems[2]) = 1 Then $oState = "Portable"
				IniWrite($oINI, $oINI_Various_Array[1][0], $oINI_Various_Array[1][1], $oState)

				$oState = "Copy"
				If GUICtrlRead($oRadioItems[4]) = 1 Then $oState = "Move"
				IniWrite($oINI, $oINI_Various_Array[2][0], $oINI_Various_Array[2][1], $oState)

				If GUICtrlRead($oRadioItems[5]) = 1 Then
					$oState = "Overwrite"
				ElseIf GUICtrlRead($oRadioItems[6]) = 1 Then
					$oState = "Skip"
				Else
					$oState = "Rename"
				EndIf
				IniWrite($oINI, $oINI_Various_Array[3][0], $oINI_Various_Array[3][1], $oState)

				IniWrite($oINI, $oINI_Various_Array[4][0], $oINI_Various_Array[4][1], GUICtrlRead($oComboItems[2]))
				IniWrite($oINI, $oINI_Various_Array[5][0], $oINI_Various_Array[5][1], GUICtrlRead($oComboItems[3]))
				IniWrite($oINI, $oINI_Various_Array[6][0], $oINI_Various_Array[6][1], GUICtrlRead($oComboItems[4]))
				IniWrite($oINI, $oINI_Various_Array[7][0], $oINI_Various_Array[7][1], GUICtrlRead($oComboItems[5]))

				$oPW = ""
				If Not StringIsSpace(GUICtrlRead($oPassword)) And GUICtrlRead($oPassword) <> "" Then $oPW = _StringEncrypt(1, GUICtrlRead($oPassword), $oPW_Code)
				IniWrite($oINI, $oINI_Various_Array[8][0], $oINI_Various_Array[8][1], $oPW)
				If $oPW = "" And GUICtrlRead($oCheckItems[11]) = 1 Then
					$oMsgBox = _ExtMsgBox(0, __Lang_Get('YES', 'Yes') & "|" & __Lang_Get('NO', 'No'), __Lang_Get('OPTIONS_ENCRYPTION_MSGBOX_0', 'Encryption is enabled'), __Lang_Get('OPTIONS_ENCRYPTION_MSGBOX_1', 'It appears the Password for Encryption is Blank, do you wish to disable?'), 0, __OnTop($oGUI))
					If $oMsgBox = 1 Then
						IniWrite($oINI, $oINI_TrueOrFalse_Array[11][0], $oINI_TrueOrFalse_Array[11][1], "False") ; Disable Encryption If Password Is Blank.
						ExitLoop
					EndIf
					ContinueLoop
				EndIf
				ExitLoop

		EndSwitch
	WEnd
	GUIDelete($oGUI)

	__SetCurrentPosition() ; Set Current Coordinates/Position Of DropIt.
	__IsOnTop() ; Set GUI "OnTop" If True.

	If Not @error Then Return 1
	Return SetError(1, 1, 0)
EndFunc   ;==>_Options

Func _ExitEvent()
	Local $eINI = __IsSettingsFile() ; Get Default Settings INI File.

	__SetCurrentPosition() ; Set Current Coordinates/Position Of DropIt.
	If $Global_MultipleInstance Then __SetMultipleInstances("-")
	__CheckMultipleInstances() ; Checks All Multiple Instances Are Running.
	If __Is("UseSendTo") And IniRead($eINI, "General", "SendToMode", "Portable") = "Portable" And __GetMultipleInstances() = 0 Then __SendTo_Uninstall() ; Delete SendTo Shortcuts If In Portable Mode.
	_GDIPlus_Shutdown()
	__Log_Write(__Lang_Get('DROPIT_CLOSED', 'DropIt Closed'), __Lang_Get('DATE', 'Date') & " " & @MDAY & "-" & @MON & "-" & @YEAR)
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

	$tTrayMenu[12][0] = TrayCreateItem(__Lang_Get('CUSTOMIZE', 'Customize'), $tTrayMenu[3][0])
	$tTrayMenu[13][0] = TrayCreateItem("", $tTrayMenu[3][0])

	Local $B = $tTrayMenu[0][0] + 1
	For $A = 1 To $tProfileList[0]
		If UBound($tTrayMenu, 1) <= $tTrayMenu[0][0] + 1 Then ReDim $tTrayMenu[UBound($tTrayMenu, 1) * 2][$tTrayMenu[0][1]] ; ReDim's $tTrayMenu If More Items Are Required.
		$tTrayMenu[$B][0] = TrayCreateItem($tProfileList[$A], $tTrayMenu[3][0], $A + 1, 1)
		$tTrayMenu[$B][1] = $tProfileList[$A]
		TrayItemSetOnEvent($tTrayMenu[$B][0], "_ProfileEvent")
		If $tProfileList[$A] = __GetCurrentProfile() Then TrayItemSetState($tTrayMenu[$B][0], 1) ; __GetCurrentProfile = Get Current Profile From The Settings INI File.
		$tTrayMenu[0][0] += 1
		$B += 1
	Next

	$tTrayMenu[9][0] = TrayCreateItem(__Lang_Get('README', 'Readme'), $tTrayMenu[6][0])
	$tTrayMenu[9][1] = 'README'
	$tTrayMenu[10][0] = TrayCreateItem(__Lang_Get('GUIDE', 'Guide'), $tTrayMenu[6][0])
	$tTrayMenu[10][1] = 'GUIDE'
	$tTrayMenu[11][0] = TrayCreateItem(__Lang_Get('ABOUT', 'About') & "...", $tTrayMenu[6][0])
	$tTrayMenu[11][1] = 'ABOUT'

	TrayItemSetOnEvent($tTrayMenu[1][0], "_ManageEvent")
	TrayItemSetOnEvent($tTrayMenu[4][0], "_OptionsEvent")
	TrayItemSetOnEvent($tTrayMenu[5][0], "_TrayMenu_ShowGUI")
	TrayItemSetOnEvent($tTrayMenu[6][0], "_TrayMenu_ShowGUI")
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
	Local $tTrayMenu[14][2] = [[13, 2]]
	Return $tTrayMenu
EndFunc   ;==>_TrayMenu_Delete

Func _TrayMenu_Show()
	Local $sGUI_1 = $Global_GUI_1
	Local $sIcon_1 = GUICtrlGetHandle($Global_Icon_1)
	Local $sToolTip = "DropIt - " & __Lang_Get('TITLE_TOOLTIP', 'Sort your files with a drop!')

	If _WinAPI_GetFocus() <> $sIcon_1 Then Return SetError(1, 1, 0) ; Required Because HotKeys Automatically Minimise The GUI.
	GUISetState(@SW_HIDE, $sGUI_1)
	TraySetState(1)
	TraySetClick(9)
	TraySetToolTip($sToolTip)

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
	_Refresh(-1, 1) ; Refresh The Main GUI & TrayMenu, Including Translation Strings & ContextMenu.

	If Not @error Then Return 1
	Return SetError(1, 1, 0)
EndFunc   ;==>_CustomizeEvent

Func _HelpEvent()
	Local $hTrayMenu = $Global_TrayMenu
	Switch @TRAY_ID
		Case $hTrayMenu[9][0]
			If FileExists(@ScriptDir & "\Guide.pdf") Then ShellExecute(@ScriptDir & "\Guide.pdf")

		Case $hTrayMenu[10][0]
			If FileExists(@ScriptDir & "\Readme.txt") Then ShellExecute(@ScriptDir & "\Readme.txt")

		Case $hTrayMenu[11][0]
			_About()

	EndSwitch

	If Not @error Then Return 1
	Return SetError(1, 1, 0)
EndFunc   ;==>_HelpEvent

Func _ManageEvent()
	_Manage_GUI() ; Open Manage GUI.
	_Refresh(-1, 1) ; Refresh The Main GUI & TrayMenu, Including Translation Strings & ContextMenu.

	If Not @error Then Return 1
	Return SetError(1, 1, 0)
EndFunc   ;==>_ManageEvent

Func _OptionsEvent()
	_Options() ; Open Options GUI.
	_Refresh(-1, 1) ; Refresh The Main GUI & TrayMenu, Including Translation Strings & ContextMenu.

	If Not @error Then Return 1
	Return SetError(1, 1, 0)
EndFunc   ;==>_OptionsEvent

Func _ProfileEvent()
	Local $pTrayMenu = $Global_TrayMenu
	For $A = 14 To $pTrayMenu[0][0]
		If @TRAY_ID = $pTrayMenu[$A][0] Then
			__Log_Write(__Lang_Get('MAIN_TIP_2', 'Changed Profile To'), $pTrayMenu[$A][1])
			__SetCurrentProfile($pTrayMenu[$A][1]) ; Write Selected Profile Name To The Settings INI File.
			ExitLoop
		EndIf
	Next
	__SetCurrentPosition() ; Set Current Coordinates/Position Of DropIt.
	_Refresh(-1, 1) ; Refresh The Main GUI & TrayMenu, Including Translation Strings & ContextMenu.

	If Not @error Then Return 1
	Return SetError(1, 1, 0)
EndFunc   ;==>_ProfileEvent
#Region End >>>>> TrayMenu Functions <<<<<

#Region Start >>>>> WM_MESSAGES Functions <<<<<
Func WM_COPYDATA($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $cParm = DllStructCreate("ulong_ptr;dword;ptr", $ilParam)
	Local $TEMPcData = DllStructCreate("wchar[" & DllStructGetData($cParm, 2) / 2 & "]", DllStructGetData($cParm, 3))
	Local $cData = DllStructGetData($TEMPcData, 1)
	Local $cFiles = __CmdLineRaw($cData) ; Convert $CmdLineRaw To $CmdLine (Without The Index Value.)
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

Func WM_MOVE($mGUI_1 = $Global_GUI_1) ; Thanks To wraithdu From EraserDrop Portable For The Idea.
	Local $mWinGetPos, $mMouseGetPos, $mXOffSet, $mYOffSet
	$mWinGetPos = WinGetPos($mGUI_1)
	$mMouseGetPos = MouseGetPos()
	$mXOffSet = $mMouseGetPos[0] - $mWinGetPos[0]
	$mYOffSet = $mMouseGetPos[1] - $mWinGetPos[1]
	While _IsPressed("01")
		Sleep(10)
		$mMouseGetPos = MouseGetPos()
		WinMove($mGUI_1, "", $mMouseGetPos[0] - $mXOffSet, $mMouseGetPos[1] - $mYOffSet)
	WEnd
	Return 1
EndFunc   ;==>WM_MOVE

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $nListViewProfiles = $Global_ListViewProfiles
	Local $nListViewRules = $Global_ListViewRules
	Local $nGUICustomize = $Global_Customize
	Local $nGUIManage = $Global_Manage
	Local $nText, $nImage, $nSizeText, $nTransparency, $nProfile, $nType, $nStringSplit, $nProfileDirectory

	$nProfileDirectory = __GetDefault(2) ; Get Default Profile Directory.

	If Not IsHWnd($nListViewProfiles) Then $nListViewProfiles = GUICtrlGetHandle($nListViewProfiles)
	If Not IsHWnd($nListViewRules) Then $nListViewRules = GUICtrlGetHandle($nListViewRules)

	Local $tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	Local $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	Local $nCode = DllStructGetData($tNMHDR, "Code")

	Local $nInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
	Local $nIndex = DllStructGetData($nInfo, "Index") ; The 'Row' Number  Selected E.G. Select The 1st Item Will Return 0
	Local $nSubItem = DllStructGetData($nInfo, "SubItem") ; The 'Column' Number  Selected E.G. Select The 2nd Item Will Return 1

	Switch $hWndFrom
		Case $nListViewProfiles
			Switch $nCode
				Case $NM_CLICK
					If $nIndex <> -1 And $nSubItem <> -1 Then
					EndIf
					$Global_ListViewIndex = $nIndex

				Case $NM_DBLCLK
					If $nIndex <> -1 And $nSubItem <> -1 Then
						$nText = _GUICtrlListView_GetItemText($nListViewProfiles, $nIndex)
						$nImage = _GUICtrlListView_GetItemText($nListViewProfiles, $nIndex, 1)
						$nSizeText = _GUICtrlListView_GetItemText($nListViewProfiles, $nIndex, 2)
						$nTransparency = _GUICtrlListView_GetItemText($nListViewProfiles, $nIndex, 3)
						_Customize_Edit_GUI($nGUICustomize, $nText, $nImage, $nSizeText, $nTransparency, 0) ; Show Customize Edit GUI Of Selected Profile.
						_Customize_Update($nListViewProfiles, $nProfileDirectory, -1) ; Add/Update Customise GUI With List Of Profiles.
						_GUICtrlListView_SetItemSelected($nListViewProfiles, $nIndex, True, True)
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
						$nProfile = __IsProfile(-1, 1) ; Get Profile Path Of Current Profile.
						$nText = _GUICtrlListView_GetItemText($nListViewRules, $nIndex)
						$nType = _GUICtrlListView_GetItemText($nListViewRules, $nIndex, 1)
						If $nType = "Exclude" Then
							$nType = $nText & "$"
						ElseIf $nType = "Compress" Then
							$nType = $nText & "&"
						Else
							$nType = $nText
						EndIf
						$nStringSplit = StringSplit(IniRead($nProfile, "Patterns", $nType, ""), "|") ; Seperate Directory & Description.
						If $nStringSplit[0] = 1 Then Local $nStringSplit[3] = [2, $nStringSplit[1], ""]
						$nType = _Manage_GetType($nListViewRules, $nIndex) ; Get Pattern Type [Normal, Compress, Exclude].
						_Manage_Edit_GUI(-1, $nStringSplit[2], $nText, $nType, $nStringSplit[1], $nGUIManage, 0) ; Show Manage Edit GUI Of Selected Pattern.
						If @error Then Return 1
						_Manage_Update($nListViewRules, -1) ; Add/Update The ListView With The Custom Patterns.
						_GUICtrlListView_SetItemSelected($nListViewRules, $nIndex, True, True)
						$Global_ListViewIndex = $nIndex
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
	If __Is("LockPosition") And $hWnd = $Global_GUI_1 Then
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

	Local $cINI_Value, $c7Zip_Value, $cNewCommands[3], $cHex, $cCommand, $cDecrypt, $cPW_Code = $oGlobal_PW_Code
	Local $cINI = __IsSettingsFile() ; Get Default Settings INI File.
	If $cFlag = -1 Then $cFlag = 1 + 2 + 4 + 8 + 16 + 32 + 64 ; Default With Encryption (If Enabled).

	For $A = 2 To 5
		$cCommands[$A][1] = IniRead($cINI, "General", $cCommands[$A][2], $cCommands[$A][1])
	Next

	$cDecrypt = _StringEncrypt(0, $cCommands[5][1], $cPW_Code)
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

Func __7ZipRun($rType = 0, $rDefault = 0, $rSourceFilePath = "", $rDestinationFilePath = "")
	#cs
		Description: Compress/Decompress Using 7-Zip.
		Returns: Compressed FileName [C:\Test.7z]
	#ce
	Local $rCommand, $rNewCommands
	Local $7Zip = @ScriptDir & "\Lib\7z.exe"
	If Not FileExists($7Zip) Or $rSourceFilePath = "" Or $rDestinationFilePath = "" Then Return SetError(1, 1, 0)
	Switch $rType
		Case 0 ; Compress Mode.
			$rCommand = "a -tzip -mm=Deflate -mx5 -mem=AES256 -sccUTF-8 -ssw"
			If $rDefault = 1 Then
				$rNewCommands = __7ZipCommands($rType, $rDestinationFilePath, -1)
				$rCommand = $rNewCommands[0]
				$rDestinationFilePath = $rNewCommands[1]
			EndIf
			RunWait('"' & $7Zip & '" ' & $rCommand & ' "' & $rDestinationFilePath & '" "' & $rSourceFilePath & '"', "", @SW_HIDE)
			If $rDefault = 1 Then
				If $rNewCommands[2] = "SFX" Then $rDestinationFilePath = $rDestinationFilePath & ".exe"
			EndIf

		Case 1 ; Decompress Mode.
			$rCommand = __7ZipCommands($rType, -1, -1)
			RunWait('"' & $7Zip & '" ' & $rCommand & ' "' & $rSourceFilePath & '" -o"' & $rDestinationFilePath & '"', "", @SW_HIDE)

	EndSwitch
	If @error Or Not FileExists($rDestinationFilePath) Then Return SetError(1, 1, $rDestinationFilePath)
	Return $rDestinationFilePath
EndFunc   ;==>__7ZipRun

Func __Backup_Restore($bHandle = -1, $bType = 0) ; 0 = Backup & 1 = Restore & 2 = Clear.
	#cs
		Description: Backups/Restores The Settings INI File & Profiles.
		Returns: 1
	#ce
	Local $bBackupDirectory = __GetDefault(32) ; Get Default Backup Directory.
	Local $bZipFile = "DropIt_Backup_" & @YEAR & "-" & @MON & "-" & @MDAY & "_(" & @HOUR & "-" & @MIN & "-" & @SEC & ")"
	Local $bMsgBox, $bBackup[3] = [2, __IsSettingsFile(), __GetDefault(2)] ; __GetDefault(2) = Get Default Profiles Directory.

	Switch $bType
		Case 0
			__7ZipRun(0, 0, $bBackup[1] & '" "' & $bBackup[2], $bBackupDirectory & $bZipFile)
			_ExtMsgBox(0, __Lang_Get('OK', 'OK'), __Lang_Get('OPTIONS_BACKUP_MSGBOX_0', 'Backup created'), __Lang_Get('OPTIONS_BACKUP_MSGBOX_1', 'Successfully created a DropIt Backup.'), 0, __OnTop($bHandle))

		Case 1
			If Not FileExists($bBackupDirectory) Or DirGetSize($bBackupDirectory, 2) = 0 Then $bBackupDirectory = __GetDefault(1) ; __GetDefault(1) = Get The Default Settings Directory.
			$bZipFile = FileOpenDialog(__Lang_Get('OPTIONS_BACKUP_TIP_0', 'Select a DropIt Backup'), $bBackupDirectory, __Lang_Get('OPTIONS_BACKUP_TIP_1', 'DropIt Backup') & " (*.zip)", 1, "", __OnTop($bHandle))
			If @error Then Return SetError(1, 1, 0)

			For $A = 1 To $bBackup[0]
				If Not FileExists($bBackup[$A]) Then ContinueLoop
				If __IsFolder($bBackup[$A]) Then
					DirRemove($bBackup[$A], 1)
				Else
					FileDelete($bBackup[$A])
				EndIf
			Next
			__7ZipRun(1, 0, $bZipFile, __GetDefault(1)) ; __GetDefault(1) = Get The Default Settings Directory.
			_ExtMsgBox(0, __Lang_Get('OK', 'OK'), __Lang_Get('OPTIONS_BACKUP_MSGBOX_2', 'Backup restored'), __Lang_Get('OPTIONS_BACKUP_MSGBOX_3', 'Successfully restored the DropIt Backup.'), 0, __OnTop($bHandle))

		Case 2
			$bMsgBox = _ExtMsgBox(0, __Lang_Get('YES', 'Yes') & "|" & __Lang_Get('NO', 'No'), __Lang_Get('OPTIONS_BACKUP_MSGBOX_4', 'Remove Backups'), __Lang_Get('OPTIONS_BACKUP_MSGBOX_5', 'Are you sure to remove DropIt Backups?'), 0, __OnTop($bHandle))
			If $bMsgBox <> 1 Then Return SetError(1, 1, 0)
			DirRemove($bBackupDirectory, 1)
			_ExtMsgBox(0, __Lang_Get('OK', 'OK'), __Lang_Get('OPTIONS_BACKUP_MSGBOX_6', 'Backups removed'), __Lang_Get('OPTIONS_BACKUP_MSGBOX_7', 'Successfully removed DropIt Backups.'), 0, __OnTop($bHandle))

	EndSwitch
	Return 1
EndFunc   ;==>__Backup_Restore

Func __ByteSuffix($bBytes, $bPlaces = 2)
	#cs
		Description: Rounds A Value Of Bytes To Highest Value.
		Returns: [1024 Bytes = 1 KB]
	#ce
	Local $A, $bArray[6] = [" Bytes", " KB", " MB", " GB", " TB", " PB"]
	While $bBytes > 1023
		$A += 1
		$bBytes /= 1024
	WEnd
	Return Round($bBytes, $bPlaces) & $bArray[$A]
EndFunc   ;==>__ByteSuffix

Func __CheckMultipleInstances()
	#cs
		Description: Checks All Multiple Instances In The INI File Are Currently Running.
		Returns: 1
	#ce
	Local $cINI = __IsSettingsFile() ; Get Default Settings INI File.

	Local $cMultipleInstancesINI = _IniReadSection($cINI, "MultipleInstances")
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
	Return IniWrite($cINI, "MultipleInstances", "Running", $cRunning)
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

Func __EnvironmentVariables()
	#cs
		Description: Sets The Standard & User Assigned Environment Variables.
		Returns: 1
	#ce.
	Local $eEnvironmentArray[6][2] = [ _
			[5, 2], _
			["License", "Open Source GPL"], _ ; Returns: DropIt License [Open Source GPL]
			["PortableDrive", StringLeft(@AutoItExe, 2)], _ ; Returns: Drive Letter [C: Without The Trailing "\"]
			["Team", "Lupo PenSuite Team"], _ ; Returns: Team Name [Lupo PenSuite Team]
			["URL", "http://www.lupopensuite.com/db/oth/dropit.htm"], _ ; Returns: URL Hyperlink [http://www.lupopensuite.com/db/oth/dropit.htm]
			["VersionNo", "1.1.1"]] ; Returns: Version Number [1.0]

	For $A = 1 To $eEnvironmentArray[0][0]
		EnvSet($eEnvironmentArray[$A][0], $eEnvironmentArray[$A][1])
	Next

	Local $eINI = __IsSettingsFile() ; Get Default Settings INI File
	Local $eSection = _IniReadSection($eINI, "EnvironmentVariables") ; Sets Custom Environment Variables.
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

Func __FilePathIsValid($fPath, $fPattern = '*?|:<>"/')
	#cs
		Description: Checks If A String Is A Valid File Path And Doesn't Contain Invalid Characters.
		Returns:
		If String Is Valid File Path Return 1
		If String Is InValid File PathReturn 0
	#ce
	Return StringRegExp($fPath, '(?i)^[a-z]:([^\Q' & $fPattern & '\E]+)?(\\[^\Q' & $fPattern & '\E\\]+)?(\.[^\Q' & $fPattern & '\E\\\.]+|\\)?$')
EndFunc   ;==>__FilePathIsValid

Func __GetCurrentLanguage()
	#cs
		Description: Gets The Current Language From The Settings INI File.
		Return: Language [English]
	#ce
	Local $gINI = __IsSettingsFile() ; Get Default Settings INI File.

	Local $gINIRead, $gLanguageDefault
	$gINIRead = IniRead($gINI, "General", "Language", "")
	$gLanguageDefault = __GetDefault(3072) ; Get Default Language Directory & Default Language.
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

	ReDim $gReturnArray[$gReturnArray[0][0] + 1][$gReturnArray[0][1]]
	If $gReturnArray[0][0] = 1 Then Return $gReturnArray[1][0]
	Return $gReturnArray
EndFunc   ;==>__GetDefault

Func __GetFilenameExt($gFilePath)
	#cs
		Description: Gets The File Name Extension From A File Path.
		Returns: File Name [txt]
	#ce
	Return StringLower(StringRegExpReplace($gFilePath, "^.*\.", ""))
EndFunc   ;==>__GetFilenameExt

Func __GetFilename($gFilePath)
	#cs
		Description: Gets The File Name From A File Path.
		Returns: File Name [FileName.txt]
	#ce
	Return StringRegExpReplace($gFilePath, "^.*\\", "")
EndFunc   ;==>__GetFilename

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
			If UBound($gReturn, 1) <= $gReturn[0][0] + 1 Then ReDim $gReturn[UBound($gReturn, 1) * 2][$gReturn[0][1]] ; ReSize Array If More Items Are Required.
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
		If $CmdLine[0] = 0 Then _ExtMsgBox(64, __Lang_Get('OK', 'OK'), __Lang_Get('CMDLINE_MSGBOX_0', 'Profile not found'), __Lang_Get('CMDLINE_MSGBOX_1', 'It appears DropIt is using an invalid Profile. @LF It will be started using "Default" profile.'), 0, __OnTop()) ; Show Error MsgBox.
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
	$g_IniReadSection = _IniReadSection($gProfile[0], "Patterns")
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

Func __GUIInBounds($gGUI = $Global_GUI_1)
	#cs
		Description: Checks If The GUI Is Within View Of The Users Screen.
		Returns: Moves GUI If Out Of Bounds
	#ce
	Local $gGUIPos = WinGetPos($gGUI)
	If $gGUIPos[0] < 5 Then
		Local $gX = 5
	ElseIf ($gGUIPos[0] + $gGUIPos[2]) > @DesktopWidth Then
		$gX = @DesktopWidth - $gGUIPos[2] + 3
	Else
		$gX = $gGUIPos[0]
	EndIf
	If $gGUIPos[1] < 5 Then
		Local $gY = 5
	ElseIf ($gGUIPos[1] + $gGUIPos[3]) > @DesktopHeight Then
		$gY = @DesktopHeight - $gGUIPos[3] + 3
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

Func __IsHandle($iParentWindow = -1)
	#cs
		Description: Checks If GUI Handle Is A Valid Handle.
		Returns:
		If True Returns The Handle.
		If False Returns The AutoIt Hidden Handle.
	#ce
	If Not IsHWnd($iParentWindow) Then
		Return WinGetHandle(AutoItWinGetTitle())
	EndIf
	Return $iParentWindow
EndFunc   ;==>__IsHandle

Func __Is($iData, $iDefault = "True")
	#cs
		Description: For INI Parameters That Use True/False Results, Therefore It Can Be Called As If __Is("DropItOn") Then ... , Simply Means If DropItOn Is True.
		Returns: True/False
	#ce
	Local $iINI = __IsSettingsFile() ; Get Default Settings INI File.
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

Func __IsOnTop($iHandle = $Global_GUI_1)
	#cs
		Description: Sets A GUI Handle "OnTop" If True/False In The Settings INI File.
		Returns: GUI OnTop Or Not OnTop
	#ce
	$iHandle = __IsHandle($iHandle) ; Checks If GUI Handle Is A Valid Handle.

	Local $iState = 0
	If __Is("OnTop") Then $iState = 1
	WinSetOnTop($iHandle, "", $iState)
	Return $iHandle
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
			_ExtMsgBox(64, __Lang_Get('OK', 'OK'), __Lang_Get('PROFILEUNIQUE_MSGBOX_0', 'Name not available'), __Lang_Get('PROFILEUNIQUE_MSGBOX_1', 'This profile name already exists.'), 0, __OnTop($iHandle))
			Return SetError(1, 1, $iProfile)
		EndIf
		If $A = $iProfileList[0] Then ExitLoop
	Next
	Return $iProfile
EndFunc   ;==>__IsProfileUnique

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
		$iINIData = "Profile=Default" & @LF & "Language=English" & @LF & "PosX=-1" & @LF & "PosY=-1" & @LF & "OnTop=True" & @LF & "LockPosition=False" & @LF & _
				"MultipleInstances=False" & @LF & "UseSendTo=False" & @LF & "SendToMode=Permanent" & @LF & "DirForFolders=False" & @LF & "IgnoreNew=False" & @LF & _
				"AutoSort=True" & @LF & "SortMode=Move" & @LF & "AutoDup=False" & @LF & "DupMode=Overwrite" & @LF & "CreateLog=False" & @LF & _
				"ArchiveFormat=ZIP" & @LF & "ArchiveLevel=Normal" & @LF & "ArchiveMethod=LZMA" & @LF & "ArchiveSelf=False" & @LF & _
				"ArchiveEncrypt=False" & @LF & "ArchiveEncryptMethod=AES-256" & @LF & "ArchivePassword="
		IniWriteSection($iINI, "General", $iINIData)
		IniWriteSection($iINI, "EnvironmentVariables", "")
		If $iShowLang Then __Lang_GUI() ; Skip Language Selection If $iShowLang = 0
	EndIf
	Return $iINI
EndFunc   ;==>__IsSettingsFile

Func __Lang_Combo()
	#cs
		Description: Gets Languages And Create String For Use In A Combo Box.
		Returns: String Of Profiles.
	#ce
	Local $lData
	Local $lLanguageList = __Lang_List()
	For $A = 1 To $lLanguageList[0]
		If @error Then ExitLoop
		$lData &= $lLanguageList[$A] & "|"
	Next
	If $lLanguageList[0] = 0 Then $lData = "English|"
	Return StringTrimRight($lData, 1)
EndFunc   ;==>__Lang_Combo

Func __Lang_Get($lData, $lDefault)
	#cs
		Description: Get Translated String Of The Current Language.
		Returns: Translated String.
	#ce

	Local $lLanguage = __GetCurrentLanguage() ; Get Current Language Profile.

	$lData = IniRead(__GetDefault(1024) & $lLanguage & ".lng", $lLanguage, $lData, $lDefault) ; __GetDefault(1024) = Get Default Language Directory.
	$lData = _WinAPI_ExpandEnvironmentStrings($lData)
	If @error Then $lData = _WinAPI_ExpandEnvironmentStrings($lDefault)
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
	Local $lGUI = GUICreate('Language Choice', 230, 70, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop())
	Local $lCombo = GUICtrlCreateCombo("", 5, 10, 220, 25, 0x0003)
	Local $lLanguage = "English"
	GUICtrlSetData($lCombo, __Lang_Combo(), $lLanguage)
	Local $lOK = GUICtrlCreateButton("&OK", 150, 40, 75, 25)
	GUICtrlSetState($lOK, 576)
	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case -3, $lOK
				ExitLoop

		EndSwitch
	WEnd
	$lLanguage = GUICtrlRead($lCombo)
	__SetCurrentLanguage($lLanguage) ; Sets The Selected Language To The Settings INI File.

	GUIDelete($lGUI)
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

	$lSearch = FileFindFirstFile(__GetDefault(2) & "*.ini") ; __GetDefault(2) = Get Default Profile Directory.
	If $lSearch = -1 Then Return $lProfileList
	While 1
		$lFile = FileFindNextFile($lSearch)
		If @error Then ExitLoop
		If $lLimit <> -1 And $lProfileList[0] = $lLimit Then ExitLoop
		If UBound($lProfileList, 1) <= $lProfileList[0] + 1 Then ReDim $lProfileList[UBound($lProfileList, 1) * 2] ; ReDim's $lLanguageList If More Items Are Required.
		$lProfileList[0] += 1
		$lProfileList[$lProfileList[0]] = StringRegExpReplace($lFile, "^.*\\|\..*$", "")
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

Func __ProfileList_GUI($cProfileName = -1)
	#cs
		Description: Select Profile From ProfileList.
		Returns: Nothing
	#ce
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
		If $cProfileList[0] = 1 Then ; If There Is Only 1 Profile Then Return This As A Selection.
			GUISetState(@SW_HIDE)
			GUIDelete($lGUI)
			Return $cProfileList[1]
		Else
			WinSetTrans($lGUI, "", 255)
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

Func __OnTop($iHandle = -1, $iState = 1)
	#cs
		Description: Sets A GUI Handle "OnTop".
		Returns: GUI OnTop
	#ce
	$iHandle = __IsHandle($iHandle) ; Checks If GUI Handle Is A Valid Handle.

	WinSetOnTop($iHandle, "", $iState)
	Return $iHandle
EndFunc   ;==>__OnTop

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

Func __SendTo_Install()
	#cs
		Description: Creates Shortcuts In The SendTo Folder. [DropIt (Profile_Name).lnk]
		Returns: 1
	#ce
	Local $sSendTo_Directory = _WinAPI_ShellGetSpecialFolderPath(0x0009) ; 0x0009 = $sCSIDL_SENDTO
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
	Local $sSendTo_Directory = _WinAPI_ShellGetSpecialFolderPath(0x0009) ; 0x0009 = $sCSIDL_SENDTO
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
	If @OSVersion = "WIN_XP" Then
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
	If @OSVersion = "WIN_XP" Then $sColor = 0
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
	If Not IsDeclared("Global_ShowPassword") Then Global $Global_ShowPassword = 0
	Local $sInputStyle = -1
	Switch $Global_ShowPassword
		Case 0
			$Global_ShowPassword = 1
		Case 1
			$sInputStyle = 0x0020
			$Global_ShowPassword = 0
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
	Local $uINIRead
	Local $uDropIt_Directory = __GetDefault(1) ; Get Default Settings Directory.
	Local $uINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $uIsOld = IniRead($uINI, "General", "Duplicates", "None")
	If $uIsOld = "None" Then Return SetError(1, 1, 0) ; Abort Upgrade If Duplicates Is Not In The INI, Given That It Is An Old Feature.

	DirMove($uDropIt_Directory & "profiles", $uDropIt_Directory & "Profiles", 1)
	DirRemove($uDropIt_Directory & "img", 1)
	DirRemove(@ScriptDir & "\" & "docs", 1)

	FileMove($uINI, $uINI & ".old", 1) ; Rename The Old INI.
	__IsSettingsFile(-1, 0) ; Create A New Upgraded INI, Skipping Language Selection.

	Local $uINI_Array[22][3] = [ _
			[21, 3], _
			["General", "Profile", 1], _ ; Unchanged.
			["General", "Language", 1], _ ; Unchanged.
			["General", "PosX", 1], _ ; Unchanged.
			["General", "PosY", 1], _ ; Unchanged.
			["General", "OnTop", 1], _ ; Unchanged.
			["General", "LockPosition", 1], _ ; Unchanged.
			["General", "LockPos", "LockPosition"], _ ; Or Changed To.
			["General", "MultipleInstances", 1], _ ; Unchanged.
			["General", "MultipleInst", "MultipleInstances"], _ ; Or Changed To.
			["General", "UseSendTo", 1], _ ; Unchanged.
			["General", "SendToMode", 1], _ ; Unchanged.
			["General", "DirForFolders", 1], _ ; Unchanged.
			["General", "IgnoreNew", 1], _ ; Unchanged.
			["General", "AutoSort", 1], _ ; Unchanged.
			["General", "AskMode", "AutoSort"], _ ; Or Changed To.
			["General", "AutoMode", "AutoSort"], _ ; Or Changed To.
			["General", "SortMode", 1], _ ; Unchanged.
			["General", "Mode", "SortMode"], _ ; Or Changed To.
			["General", "AutoDup", 1], _ ; Unchanged.
			["General", "AutoForDup", "AutoDup"], _ ; Or Changed To.
			["General", "DupMode", 1], _ ; Unchanged.
			["General", "Duplicates", "DupMode"], _ ; Or Changed To.
			["General", "CreateLog", 1], _ ; Unchanged.
			["General", "ArchiveFormat", 1], _ ; Unchanged.
			["General", "ArchiveLevel", 1], _ ; Unchanged.
			["General", "ArchiveMethod", 1], _ ; Unchanged.
			["General", "ArchiveSelf", 1], _ ; Unchanged.
			["General", "ArchiveEncrypt", 1], _ ; Unchanged.
			["General", "ArchiveEncryptMethod", 1], _ ; Unchanged.
			["General", "ArchivePassword", 1]] ; Unchanged.

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

Func _WinAPI_ShellGetSpecialFolderPath($sCSIDL, $sCreate = 0) ; Taken From The Incredible WinAPIEx.au3 By Yashied - http://www.autoitscript.com/forum/index.php?showtopic=98712
	Local $sPath = DllStructCreate('wchar[1024]')
	Local $sReturn = DllCall('shell32.dll', 'int', 'SHGetSpecialFolderPathW', 'hwnd', 0, 'ptr', DllStructGetPtr($sPath), 'int', $sCSIDL, 'int', $sCreate)
	If (@error) Or (Not $sReturn[0]) Then
		Return SetError(1, 0, '')
	EndIf
	Return DllStructGetData($sPath, 1)
EndFunc   ;==>_WinAPI_ShellGetSpecialFolderPath
#Region End >>>>> Internal Functions <<<<<

#Region Start >>>>> INI Functions <<<<<
Func _IniReadSection($iFile, $iSection) ; Taken From - http://www.autoitscript.com/forum/topic/32004-_IniReadSection-exceed-32kb-limit/page__view__findpost__p__229487
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
EndFunc   ;==>_IniReadSection
#Region End >>>>> INI Functions <<<<<