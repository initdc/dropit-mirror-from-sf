#cs ----------------------------------------------------------------------------
	Application Name: DropIt
	License: Open Source GPL
	Language: English
	AutoIt Version: 3.3.6.1
	Authors: Lupo73 and Guinness
	Website: http://dropit.sourceforge.net/
	Contact: http://www.lupopensuite.com/contact.htm

	AutoIt3Wrapper Info:
	Icons Added To The Resources Can Be Used With TraySetIcon(@ScriptFullPath, -5) etc. And Are Stored With Numbers -5, -6, -7...
	The Reference Web Page Is http://www.autoitscript.com/autoit3/scite/docs/AutoIt3Wrapper.htm
#ce ----------------------------------------------------------------------------

#NoTrayIcon
#Region ; **** Directives Created By AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Lib\img\Logo.ico
#AutoIt3Wrapper_Outfile=DropIt.exe
#AutoIt3Wrapper_UseUpx=N
#AutoIt3Wrapper_Res_Description=DropIt - Sort your files with a drop
#AutoIt3Wrapper_Res_Fileversion=3.1.0.0
#AutoIt3Wrapper_Res_ProductVersion=3.1.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Lupo PenSuite Team
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_Field=Website|http://www.lupopensuite.com
#AutoIt3Wrapper_Res_Field=E-Mail|comment at the website
#AutoIt3Wrapper_UseX64=N
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\Custom.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\Info.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\Patterns.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\Search.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\NewAction.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\Filters.ico
#AutoIt3Wrapper_Res_File_Add=Examples\Archiver.ini, 10, ARCHIVER
#AutoIt3Wrapper_Res_File_Add=Examples\Eraser.ini, 10, ERASER
#AutoIt3Wrapper_Res_File_Add=Examples\Extractor.ini, 10, EXTRACTOR
#AutoIt3Wrapper_Res_File_Add=Images\Default.png, 10, IMAGE
#AutoIt3Wrapper_Res_File_Add=Lib\img\About.png, 10, ABOUT
#AutoIt3Wrapper_Res_File_Add=Lib\img\Close.png, 10, CLOSE
#AutoIt3Wrapper_Res_File_Add=Lib\img\Copy.png, 10, COPY
#AutoIt3Wrapper_Res_File_Add=Lib\img\Custom.png, 10, CUST
#AutoIt3Wrapper_Res_File_Add=Lib\img\Cut.png, 10, CUT
#AutoIt3Wrapper_Res_File_Add=Lib\img\Delete.png, 10, DEL
#AutoIt3Wrapper_Res_File_Add=Lib\img\Edit.png, 10, EDIT
#AutoIt3Wrapper_Res_File_Add=Lib\img\Example.png, 10, EXAMP
#AutoIt3Wrapper_Res_File_Add=Lib\img\Help.png, 10, HELP
#AutoIt3Wrapper_Res_File_Add=Lib\img\HelpFile.png, 10, HELPF
#AutoIt3Wrapper_Res_File_Add=Lib\img\Hide.png, 10, HIDE
#AutoIt3Wrapper_Res_File_Add=Lib\img\New.png, 10, NEW
#AutoIt3Wrapper_Res_File_Add=Lib\img\NoFlag.gif, 10, FLAG
#AutoIt3Wrapper_Res_File_Add=Lib\img\Options.png, 10, OPT
#AutoIt3Wrapper_Res_File_Add=Lib\img\Paste.png, 10, PASTE
#AutoIt3Wrapper_Res_File_Add=Lib\img\Patterns.png, 10, PAT
#AutoIt3Wrapper_Res_File_Add=Lib\img\Profiles.png, 10, PROF
#AutoIt3Wrapper_Res_File_Add=Lib\img\Progress.png, 10, PROG
#AutoIt3Wrapper_Res_File_Add=Lib\img\Readme.png, 10, READ
#AutoIt3Wrapper_Res_File_Add=Lib\img\Show.png, 10, SHOW
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_Run_Obfuscator=Y
#Obfuscator_Parameters=/SF /SV /OM /CF=0 /CN=0 /CS=0 /CV=0
#EndRegion ; **** Directives Created By AutoIt3Wrapper_GUI ****

#include <Crypt.au3>
#include <Date.au3>
#include <File.au3>
#include <GUIButton.au3>
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
Global $Global_CurrentVersion = "3.1"
Global $Global_ImageList ; ImageList.
__EnvironmentVariables() ; Sets The Standard & User Assigned Environment Variables.
__ExpandEnvStrings(0) ; Disables The Expansion Of Environment Variables.
; <<<<< Environment Variables >>>>>

; <<<<< Variables >>>>>
Global $Global_GUI_1, $Global_GUI_2 ; GUI Handles.
Global $Global_Icon_1 ; Icons Handle.
Global $Global_ContextMenu[15][2] = [[14, 2]] ; ContextMenu Array.
Global $Global_TrayMenu[14][2] = [[13, 2]] ; TrayMenu Array.
Global $Global_Clipboard[5] = [0] ; Manage Patterns Clipboard.
Global $Global_Customize, $Global_ListViewIndex = -1, $Global_ListViewProfiles, $Global_ListViewRules, $Global_Manage, $Global_ListViewRules_ItemChange = -1 ; ListView Variables.
Global $Global_ListViewProfiles_Delete, $Global_ListViewProfiles_Enter, $Global_ListViewProfiles_New, $Global_ListViewProfiles_Example[2] ; ContextMenu ListViewProfiles Variables.
Global $Global_ListViewRules_Delete, $Global_ListViewRules_ComboBox, $Global_ListViewRules_ComboBoxChange = 0 ; ContextMenu ListViewManage Variables.
Global $Global_ListViewRules_Copy, $Global_ListViewRules_Cut, $Global_ListViewRules_Paste, $Global_ListViewRules_Enter, $Global_ListViewRules_New ; ContextMenu ListViewManage Variables.
Global $Global_Slider, $Global_SliderLabel ; _Customize_GUI_Edit().
Global $Global_Timer, $Global_Action, $Global_MainDir, $Global_DuplicateMode, $Global_DroppedFiles[1], $Global_PTR = "ptr", $Global_GUI_State = 1 ; Misc.
Global $UniqueID = "DropIt_E15FF08B-84AC-472A-89BF-5F92DB683165" ; WM_COPYDATA.
Global $Global_ResizeWidth, $Global_ResizeHeight ; Windows Size For Resizing.
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

_Main()

#Region Start >>>>> Manage Functions <<<<<
Func _Manage_GUI($mINI = -1, $mHandle = -1)
	$mINI = __IsSettingsFile($mINI) ; Get Default Settings INI File.
	Local $mGUI = $Global_Manage

	Local $mListView, $mListView_Handle, $mMsg, $mNew, $mClose, $mProfileCombo, $mProfileCombo_Handle, $mName, $mText, $mType, $mState, $mDestination
	Local $mIndex_Selected, $mAssociate, $mCopyDummy, $mCutDummy, $mDeleteDummy, $mEnterDummy, $mNewDummy, $mPasteDummy

	Local $mProfile = __IsProfile(-1, 0) ; Get Array Of Current Profile.
	Local $mSize = __GetCurrentSize("SizeManage") ; 460 x 260.

	$mGUI = GUICreate(__Lang_Get('MANAGE_GUI', 'Manage Patterns'), $mSize[0], $mSize[1], -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX), -1, __OnTop($mHandle))
	GUISetIcon(@ScriptFullPath, -7, $mGUI) ; Use Patterns.ico
	$Global_Manage = $mGUI
	$Global_ResizeWidth = 400 ; Set Default Minimum Width.
	$Global_ResizeHeight = 200 ; Set Default Minimum Height.

	$mListView = GUICtrlCreateListView(__Lang_Get('NAME', 'Name') & "|" & __Lang_Get('RULES', 'Rules') & "|" & __Lang_Get('ACTION', 'Action') & "|" & __Lang_Get('DESTINATION', 'Destination'), 5, 5, $mSize[0] - 10, $mSize[1] - 40, BitOR($LVS_NOSORTHEADER, $LVS_REPORT, $LVS_SINGLESEL))
	$mListView_Handle = GUICtrlGetHandle($mListView)

	$Global_ListViewRules = $mListView_Handle
	GUICtrlSetResizing($mListView, $GUI_DOCKBORDERS)

	_GUICtrlListView_SetExtendedListViewStyle($mListView_Handle, BitOR($LVS_EX_CHECKBOXES, $LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_INFOTIP))
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
	$Global_Clipboard[4] = $mProfile[0] ; New Profile Of Selected Pattern [C:\Program Files\DropIt\Profiles\ProfileName.ini].

	$mCopyDummy = GUICtrlCreateDummy()
	$Global_ListViewRules_Copy = $mCopyDummy
	$mCutDummy = GUICtrlCreateDummy()
	$Global_ListViewRules_Cut = $mCutDummy
	$mDeleteDummy = GUICtrlCreateDummy()
	$Global_ListViewRules_Delete = $mDeleteDummy
	$mEnterDummy = GUICtrlCreateDummy()
	$Global_ListViewRules_Enter = $mEnterDummy
	$mNewDummy = GUICtrlCreateDummy()
	$Global_ListViewRules_New = $mNewDummy
	$mPasteDummy = GUICtrlCreateDummy()
	$Global_ListViewRules_Paste = $mPasteDummy

	$mNew = GUICtrlCreateButton("&" & __Lang_Get('NEW', 'New'), 35, $mSize[1] - 30, 78, 25)
	GUICtrlSetTip($mNew, __Lang_Get('MANAGE_GUI_TIP_0', 'Click to add a pattern or Right-click a pattern to manage it.'))
	GUICtrlSetResizing($mNew, $GUI_DOCKSIZE + $GUI_DOCKLEFT + $GUI_DOCKBOTTOM)

	$mProfileCombo = GUICtrlCreateCombo("", 155, $mSize[1] - 28, $mSize[0] - 310, 24, 0x0003)
	$mProfileCombo_Handle = GUICtrlGetHandle($mProfileCombo)

	$Global_ListViewRules_ComboBox = $mProfileCombo_Handle

	GUICtrlSetData($mProfileCombo, __ProfileList_Combo(), $mProfile[1])
	GUICtrlSetTip($mProfileCombo, __Lang_Get('MANAGE_GUI_TIP_1', 'Select a Profile to change its patterns.'))
	GUICtrlSetResizing($mProfileCombo, $GUI_DOCKSIZE + $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM)

	$mClose = GUICtrlCreateButton("&" & __Lang_Get('CLOSE', 'Close'), $mSize[0] - 35 - 78, $mSize[1] - 30, 78, 25)
	GUICtrlSetTip($mClose, __Lang_Get('MANAGE_GUI_TIP_2', 'Save pattern changes and close the window.'))
	GUICtrlSetResizing($mClose, $GUI_DOCKSIZE + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM)
	GUICtrlSetState($mClose, $GUI_DEFBUTTON)

	$Global_ListViewIndex = -1 ; Set As No Item Selected.
	GUIRegisterMsg(0x0111, "WM_COMMAND")
	GUIRegisterMsg(0x004E, "WM_NOTIFY")
	GUIRegisterMsg(0x0024, "WM_GETMINMAXINFO")
	GUISetState(@SW_SHOW)
	Local $cHotKeys[3][2] = [["^n", $mNewDummy],["{DELETE}", $mDeleteDummy],["{ENTER}", $mEnterDummy]]
	GUISetAccelerators($cHotKeys)

	While 1
		__ReduceMemory() ; Reduce Memory Usage Of DropIt.

		$mIndex_Selected = $Global_ListViewIndex

		If $Global_ListViewRules_ComboBoxChange Then
			$Global_ListViewRules_ComboBoxChange = 0
			$mProfile = __IsProfile(GUICtrlRead($mProfileCombo), 0) ; Get Array Of Selected Profile.
			$Global_Clipboard[4] = $mProfile[0] ; New Profile Of Selected Pattern [C:\Program Files\DropIt\Profiles\ProfileName.ini].
		EndIf

		If $Global_ListViewRules_ItemChange <> -1 Then
			$mText = _GUICtrlListView_GetItemText($mListView_Handle, $Global_ListViewRules_ItemChange, 1)
			$mType = _GUICtrlListView_GetItemText($mListView_Handle, $Global_ListViewRules_ItemChange, 2)
			$mState = _GUICtrlListView_GetItemChecked($mListView_Handle, $Global_ListViewRules_ItemChange)
			__SetPatternState($mProfile[0], __GetPatternString($mType, $mText), $mState)
			$Global_ListViewRules_ItemChange = -1
		EndIf

		$mMsg = GUIGetMsg()
		Switch $mMsg
			Case $GUI_EVENT_CLOSE, $mClose
				Local $mColumnSize[_GUICtrlListView_GetColumnCount($mListView_Handle)]
				For $A = 0 To UBound($mColumnSize) - 1
					$mColumnSize[$A] = _GUICtrlListView_GetColumnWidth($mListView_Handle, $A)
				Next
				__Column_Width("ColumnManage", $mColumnSize)
				ExitLoop

			Case $mNew, $mNewDummy
				$mAssociate = _Manage_Edit_GUI($mProfile[1], -1, -1, -1, -1, $mGUI, 1) ; Show Manage Edit GUI For New Pattern.
				If $mAssociate = 1 Then
					$mProfile = _Manage_Update($mListView_Handle, $mProfile) ; Add/Update The ListView With The Custom Patterns.
				EndIf

			Case $mDeleteDummy
				_Manage_Delete($mListView_Handle, $mIndex_Selected, $mProfile[0]) ; Delete Selected Pattern From Current Profile & ListView.

			Case $mEnterDummy, $mCutDummy, $mCopyDummy
				$mIndex_Selected = _GUICtrlListView_GetSelectionMark($mListView_Handle)
				If Not _GUICtrlListView_GetItemState($mListView_Handle, $mIndex_Selected, $LVIS_SELECTED) Then
					ContinueLoop
				EndIf

				$mName = _GUICtrlListView_GetItemText($mListView_Handle, $mIndex_Selected)
				$mText = _GUICtrlListView_GetItemText($mListView_Handle, $mIndex_Selected, 1)
				$mType = _GUICtrlListView_GetItemText($mListView_Handle, $mIndex_Selected, 2)
				$mDestination = _GUICtrlListView_GetItemText($mListView_Handle, $mIndex_Selected, 3)

				If $mMsg = $mEnterDummy Then
					_Manage_Edit_GUI($mProfile[1], $mName, $mText, $mType, $mDestination, $mGUI, 0) ; Show Manage Edit GUI For Selected Pattern.
					If @error Then
						ContinueLoop
					EndIf
					_Manage_Update($mListView_Handle, $mProfile) ; Add/Update The ListView With The Custom Patterns.
					_GUICtrlListView_SetItemSelected($mListView_Handle, $mIndex_Selected, True, True)
				Else
					$Global_Clipboard[1] = $mProfile[0] ; Original Profile Of Selected Pattern [C:\Program Files\DropIt\Profiles\ProfileName.ini].
					$Global_Clipboard[2] = __GetPatternString($mType, $mText) ; Pattern Rule + Action [*.txt$1].
					$Global_Clipboard[3] = IniRead($mProfile[0], "Patterns", $Global_Clipboard[2], "") ; Destination + Pattern Name + Filters + State [C:\Destination|Example|1<20MB|0>d|0>d|0>d|Disabled].
					If $mMsg = $mCutDummy Then
						$Global_Clipboard[0] = 1 ; Clipboard Cut Mode.
					Else
						$Global_Clipboard[0] = 2 ; Clipboard Copy Mode.
					EndIf
				EndIf

			Case $mPasteDummy
				_Manage_Paste() ; Paste Cut/Copied Pattern.

				_Manage_Update($mListView_Handle, $mProfile) ; Add/Update The ListView With The Custom Patterns.
				_GUICtrlListView_SetItemSelected($mListView_Handle, $mIndex_Selected, True, True)

		EndSwitch
	WEnd
	$Global_ListViewRules_ComboBoxChange = -1
	__SetCurrentSize($mGUI, "SizeManage")
	GUIDelete($mGUI)

	For $A = 0 To 4
		$Global_Clipboard[$A] = 0 ; Clean Clipboard.
	Next

	__SetCurrentPosition() ; Set Current Coordinates/Position Of DropIt.
	__IsOnTop() ; Set GUI "OnTop" If True.

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_Manage_GUI

Func _Manage_Edit_GUI($mProfileName = -1, $mFileName = -1, $mFileNameExt = -1, $mInitialType = -1, $mDestination = -1, $mHandle = -1, $mNewAssociation = 0, $mDroppedEvent = 0)
	Local $mInput_Name, $mInput_NameRead, $mInput_Rule, $mInput_RuleData, $mRule_Info, $mCombo_Type, $mCombo_TypeData, $mType_Info, $mFilters[4][4]
	Local $mInput_Directory, $mButton_Directory, $mInput_DirectoryRead, $mCombo_Delete, $mCombo_DeleteData, $mButton_Filters, $mRename, $mInput_Rename
	Local $mGUI, $mMsgBox, $mFolder, $mDestination_Label, $mAdd_Action, $mSave, $mCancel, $mTEMPFileNameExt, $mChanged = 0

	Local $mAssociationType = __Lang_Get('MANAGE_ASSOCIATION_NEW', 'New Association')
	Local $mRename_Default = "%FileName%.%FileExt%"
	Local $mProfile = __IsProfile($mProfileName, 0) ; Get Array Of Current Profile.

	If $mFileName = -1 Then
		$mFileName = ""
	EndIf
	If $mFileNameExt = -1 Then
		$mFileNameExt = ""
	EndIf
	If $mInitialType = -1 Then
		$mInitialType = __Lang_Get('MOVE', 'Move')
	EndIf
	If $mDestination = -1 Then
		$mDestination = ""
	EndIf
	If $mInitialType == __Lang_Get('RENAME', 'Rename') Then
		$mRename = $mDestination
		$mDestination = "-"
	EndIf
	If $mRename = "" Then
		$mRename = $mRename_Default
	EndIf

	$mInput_RuleData = $mFileNameExt
	Local $mCurrentType = $mInitialType
	Local $mCurrentDelete = __Lang_Get('DELETE_MODE_1', 'Normally Delete')
	$mCombo_TypeData = __Lang_Get('MOVE', 'Move') & '|' & __Lang_Get('COPY', 'Copy') & '|' & __Lang_Get('COMPRESS', 'Compress') & '|' & __Lang_Get('EXTRACT', 'Extract') & '|' & __Lang_Get('RENAME', 'Rename') & '|' & __Lang_Get('OPEN_WITH', 'Open With') & '|' & __Lang_Get('DELETE', 'Delete') & '|' & __Lang_Get('EXCLUDE', 'Exclude')
	$mCombo_DeleteData = __Lang_Get('DELETE_MODE_1', 'Normally Delete') & '|' & __Lang_Get('DELETE_MODE_2', 'Safely Erase') & '|' & __Lang_Get('DELETE_MODE_3', 'Send to Recycle Bin')

	Select
		Case $mNewAssociation = 0 And $mDroppedEvent = 0
			$mAssociationType = __Lang_Get('MANAGE_ASSOCIATION_EDIT', 'Edit Association')
			$mFilters = _Manage_ExtractFilters($mProfile[0], $mFileNameExt, $mInitialType)

		Case $mNewAssociation = 1 And $mDroppedEvent = 1
			$mInput_RuleData = "**"
			If $mFileNameExt <> "0" Then
				$mInput_RuleData = "*." & $mFileNameExt ; $mFileNameExt = "0" If Loaded Item Is A Folder.
			EndIf
	EndSelect

	$mGUI = GUICreate($mAssociationType & " [" & __Lang_Get('PROFILE', 'Profile') & ": " & $mProfile[1] & "]", 460, 230, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))
	GUICtrlCreateLabel(__Lang_Get('NAME', 'Name') & ":", 15, 12, 200, 20)
	$mInput_Name = GUICtrlCreateInput($mFileName, 10, 31, 440, 22)
	GUICtrlSetTip($mInput_Name, __Lang_Get('MANAGE_EDIT_TIP_0', 'Choose a name for this association.'))

	GUICtrlCreateLabel(__Lang_Get('RULES', 'Rules') & ":", 15, 60 + 12, 200, 20)
	$mInput_Rule = GUICtrlCreateInput($mInput_RuleData, 10, 60 + 32, 358, 22)
	GUICtrlSetTip($mInput_Rule, __Lang_Get('MANAGE_EDIT_TIP_1', 'Write rules for this association.'))
	$mButton_Filters = GUICtrlCreateButton("F", 10 + 363, 60 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Filters, __Lang_Get('ADDITIONAL_FILTERS', 'Additional Filters'))
	GUICtrlSetImage($mButton_Filters, @ScriptFullPath, -10, 0)
	$mRule_Info = GUICtrlCreateButton("i", 10 + 404, 60 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mRule_Info, __Lang_Get('INFO', 'Info'))
	GUICtrlSetImage($mRule_Info, @ScriptFullPath, -6, 0)

	GUICtrlCreateLabel(__Lang_Get('ACTION', 'Action') & ":", 15, 120 + 12, 120, 20)
	$mCombo_Type = GUICtrlCreateCombo("", 10, 120 + 32, 135, 22, 0x0003)
	$mDestination_Label = GUICtrlCreateLabel(__Lang_Get('MANAGE_DESTINATION_FOLDER', 'Destination Folder') & ":", 15 + 140, 120 + 12, 160, 20)
	$mInput_Directory = GUICtrlCreateInput($mDestination, 10 + 140, 120 + 32, 218, 22)
	GUICtrlSetTip($mInput_Directory, __Lang_Get('MANAGE_EDIT_TIP_2', 'As destination are supported both absolute and relative paths.'))
	$mButton_Directory = GUICtrlCreateButton("S", 10 + 363, 120 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Directory, __Lang_Get('SEARCH', 'Search'))
	GUICtrlSetImage($mButton_Directory, @ScriptFullPath, -8, 0)
	$mInput_Rename = GUICtrlCreateInput($mRename, 10 + 140, 120 + 32, 259, 22)
	GUICtrlSetTip($mInput_Rename, __Lang_Get('MANAGE_EDIT_TIP_4', 'Write output name and extension.'))
	$mCombo_Delete = GUICtrlCreateCombo("", 10 + 140, 120 + 32, 259, 22, 0x0003)
	$mType_Info = GUICtrlCreateButton("i", 10 + 404, 120 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mType_Info, __Lang_Get('INFO', 'Info'))
	GUICtrlSetImage($mType_Info, @ScriptFullPath, -6, 0)

	GUICtrlSetState($mInput_Rename, $GUI_HIDE)
	GUICtrlSetState($mCombo_Delete, $GUI_HIDE)
	Switch $mCurrentType
		Case __Lang_Get('EXCLUDE', 'Exclude')
			GUICtrlSetData($mDestination_Label, "")
			GUICtrlSetData($mInput_Directory, "-")
			GUICtrlSetState($mInput_Directory, $GUI_DISABLE)
			GUICtrlSetState($mButton_Directory, $GUI_DISABLE)
		Case __Lang_Get('OPEN_WITH', 'Open With')
			GUICtrlSetData($mDestination_Label, __Lang_Get('MANAGE_DESTINATION_PROGRAM', 'Destination Program') & ":")
		Case __Lang_Get('RENAME', 'Rename')
			GUICtrlSetData($mDestination_Label, __Lang_Get('MANAGE_NEW_NAME', 'New Name') & ":")
			GUICtrlSetState($mInput_Directory, $GUI_HIDE)
			GUICtrlSetState($mButton_Directory, $GUI_HIDE)
			GUICtrlSetState($mInput_Rename, $GUI_SHOW)
		Case __Lang_Get('DELETE', 'Delete')
			GUICtrlSetData($mDestination_Label, __Lang_Get('MANAGE_DELETE_MODE', 'Deletion Mode') & ":")
			GUICtrlSetData($mInput_Directory, "-")
			GUICtrlSetState($mInput_Directory, $GUI_HIDE)
			GUICtrlSetState($mButton_Directory, $GUI_HIDE)
			GUICtrlSetState($mCombo_Delete, $GUI_SHOW)
			$mCurrentDelete = $mDestination
	EndSwitch
	GUICtrlSetData($mCombo_Type, $mCombo_TypeData, $mCurrentType)
	GUICtrlSetData($mCombo_Delete, $mCombo_DeleteData, $mCurrentDelete)

	$mSave = GUICtrlCreateButton("&" & __Lang_Get('SAVE', 'Save'), 230 - 80 - 85, 195, 85, 26)
	$mAdd_Action = GUICtrlCreateButton("+", 230 - 18, 196, 36, 24, $BS_ICON)
	GUICtrlSetTip($mAdd_Action, __Lang_Get('?????', 'Add another action'))
	GUICtrlSetImage($mAdd_Action, @ScriptFullPath, -9, 0)
	GUICtrlSetState($mAdd_Action, $GUI_HIDE) ; <<<<<<<<<<<<<<< Temporarily Disabled.
	$mCancel = GUICtrlCreateButton("&" & __Lang_Get('CANCEL', 'Cancel'), 230 + 80, 195, 85, 26)
	GUICtrlSetState($mCancel, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)
	ControlClick($mGUI, "", $mInput_Name)

	While 1
		__ReduceMemory() ; Reduce Memory Usage Of DropIt.

		; Enable/Disable Destination Input And Switch Folder/Program Label:
		If GUICtrlRead($mCombo_Type) <> $mCurrentType And _GUICtrlComboBox_GetDroppedState($mCombo_Type) = False Then
			$mCurrentType = GUICtrlRead($mCombo_Type)
			Switch $mCurrentType
				Case __Lang_Get('DELETE', 'Delete')
					GUICtrlSetState($mInput_Directory, $GUI_HIDE)
					GUICtrlSetState($mButton_Directory, $GUI_HIDE)
					GUICtrlSetState($mInput_Rename, $GUI_HIDE)
					GUICtrlSetState($mCombo_Delete, $GUI_SHOW)
					If GUICtrlRead($mInput_Directory) == "" Then
						GUICtrlSetData($mInput_Directory, "-")
					EndIf
					If GUICtrlRead($mInput_Rename) == "" Then
						GUICtrlSetData($mInput_Rename, $mRename_Default)
					EndIf
				Case __Lang_Get('EXCLUDE', 'Exclude')
					GUICtrlSetState($mInput_Directory, $GUI_DISABLE + $GUI_SHOW)
					GUICtrlSetState($mButton_Directory, $GUI_DISABLE + $GUI_SHOW)
					GUICtrlSetState($mInput_Rename, $GUI_HIDE)
					GUICtrlSetState($mCombo_Delete, $GUI_HIDE)
					If GUICtrlRead($mInput_Directory) == "" Then
						GUICtrlSetData($mInput_Directory, "-")
					EndIf
					If GUICtrlRead($mInput_Rename) == "" Then
						GUICtrlSetData($mInput_Rename, $mRename_Default)
					EndIf
				Case __Lang_Get('RENAME', 'Rename')
					GUICtrlSetState($mInput_Directory, $GUI_HIDE)
					GUICtrlSetState($mButton_Directory, $GUI_HIDE)
					GUICtrlSetState($mInput_Rename, $GUI_SHOW)
					GUICtrlSetState($mCombo_Delete, $GUI_HIDE)
					If GUICtrlRead($mInput_Directory) == "" Then
						GUICtrlSetData($mInput_Directory, "-")
					EndIf
				Case Else
					GUICtrlSetState($mInput_Directory, $GUI_ENABLE + $GUI_SHOW)
					GUICtrlSetState($mButton_Directory, $GUI_ENABLE + $GUI_SHOW)
					GUICtrlSetState($mInput_Rename, $GUI_HIDE)
					GUICtrlSetState($mCombo_Delete, $GUI_HIDE)
					If GUICtrlRead($mInput_Directory) == "-" Then
						GUICtrlSetData($mInput_Directory, "")
					EndIf
					If GUICtrlRead($mInput_Rename) == "" Then
						GUICtrlSetData($mInput_Rename, $mRename_Default)
					EndIf
			EndSwitch
			Switch $mCurrentType
				Case __Lang_Get('DELETE', 'Delete')
					GUICtrlSetData($mDestination_Label, __Lang_Get('MANAGE_DELETE_MODE', 'Deletion Mode') & ":")
				Case __Lang_Get('EXCLUDE', 'Exclude')
					GUICtrlSetData($mDestination_Label, "")
				Case __Lang_Get('RENAME', 'Rename')
					GUICtrlSetData($mDestination_Label, __Lang_Get('MANAGE_NEW_NAME', 'New Name') & ":")
				Case __Lang_Get('OPEN_WITH', 'Open With')
					GUICtrlSetData($mDestination_Label, __Lang_Get('MANAGE_DESTINATION_PROGRAM', 'Destination Program') & ":")
				Case Else
					GUICtrlSetData($mDestination_Label, __Lang_Get('MANAGE_DESTINATION_FOLDER', 'Destination Folder') & ":")
			EndSwitch
		EndIf

		; Enable/Disable Save Button:
		If GUICtrlRead($mInput_Name) <> "" And GUICtrlRead($mInput_Rule) <> "" And GUICtrlRead($mInput_Directory) <> "" And GUICtrlRead($mInput_Rename) <> "" And __StringIsValid(GUICtrlRead($mInput_Directory), "$|") And Not StringIsSpace(GUICtrlRead($mInput_Rule)) Then
			If GUICtrlGetState($mSave) > 80 Then
				GUICtrlSetState($mSave, 576) ; $GUI_ENABLE + $GUI_DEFBUTTON.
			EndIf
			If GUICtrlGetState($mCancel) = 512 Then
				GUICtrlSetState($mCancel, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
		ElseIf GUICtrlRead($mInput_Name) = "" Or GUICtrlRead($mInput_Rule) = "" Or GUICtrlRead($mInput_Directory) = "" Or GUICtrlRead($mInput_Rename) = "" Or Not __StringIsValid(GUICtrlRead($mInput_Directory), "$|") Or StringIsSpace(GUICtrlRead($mInput_Rule)) Then
			If GUICtrlGetState($mSave) = 80 Then
				GUICtrlSetState($mSave, 144) ; $GUI_DISABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($mCancel) = 80 Then
				GUICtrlSetState($mCancel, 512) ; $GUI_DEFBUTTON.
			EndIf
		EndIf

		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $mCancel
				SetError(1, 0, 0)
				ExitLoop

			Case $mSave
				$mInput_NameRead = GUICtrlRead($mInput_Name)
				$mInput_DirectoryRead = GUICtrlRead($mInput_Directory)
				$mFileNameExt = GUICtrlRead($mInput_Rule)
				If $mCurrentType <> __Lang_Get('EXCLUDE', 'Exclude') And $mCurrentType <> __Lang_Get('DELETE', 'Delete') And $mCurrentType <> __Lang_Get('RENAME', 'Rename') And __FilePathIsValid(_WinAPI_ExpandEnvironmentStrings($mInput_DirectoryRead)) = 0 And StringInStr($mInput_DirectoryRead, "%File%") = 0 And StringInStr($mInput_DirectoryRead, "%DefaultProgram%") = 0 Then
					MsgBox(0x30, __Lang_Get('MANAGE_EDIT_MSGBOX_0', 'Destination Error'), __Lang_Get('MANAGE_EDIT_MSGBOX_1', 'You must specify a valid destination.'), 0, __OnTop($mGUI))
					ContinueLoop
				EndIf

				Switch $mCurrentType
					Case __Lang_Get('EXCLUDE', 'Exclude')
						$mInput_DirectoryRead = "-"
					Case __Lang_Get('EXTRACT', 'Extract')
						If StringInStr($mFileNameExt, "**") Then
							MsgBox(0x30, __Lang_Get('MANAGE_EDIT_MSGBOX_4', 'Pattern Error'), __Lang_Get('MANAGE_EDIT_MSGBOX_11', 'You cannot use this action for folders.'), 0, __OnTop($mGUI))
							ContinueLoop
						EndIf
					Case __Lang_Get('OPEN_WITH', 'Open With')
						If __IsSupported($mInput_DirectoryRead, "bat;cmd;com;exe;pif") = 0 Or StringInStr($mInput_DirectoryRead, "DropIt.exe") Then ; DropIt.exe Is Excluded To Avoid A Loop.
							If StringInStr($mInput_DirectoryRead, "%DefaultProgram%") = 0 Then
								MsgBox(0x30, __Lang_Get('MANAGE_EDIT_MSGBOX_0', 'Destination Error'), __Lang_Get('MANAGE_EDIT_MSGBOX_1', 'You must specify a valid destination.'), 0, __OnTop($mGUI))
								ContinueLoop
							EndIf
						EndIf
					Case __Lang_Get('DELETE', 'Delete')
						$mCurrentDelete = GUICtrlRead($mCombo_Delete)
						Switch $mCurrentDelete
							Case __Lang_Get('DELETE_MODE_2', 'Safely Erase')
								$mInput_DirectoryRead = 2
							Case __Lang_Get('DELETE_MODE_3', 'Send to Recycle Bin')
								$mInput_DirectoryRead = 3
							Case Else ; Normally Delete.
								$mInput_DirectoryRead = 1
						EndSwitch
					Case __Lang_Get('RENAME', 'Rename')
						$mInput_DirectoryRead = GUICtrlRead($mInput_Rename)
				EndSwitch
				$mTEMPFileNameExt = __GetPatternString($mCurrentType, $mFileNameExt) ; Get Pattern String.

				If StringInStr($mFileNameExt, "*") And StringInStr(StringRight($mFileNameExt, 2), "$") = 0 And StringInStr($mFileNameExt, "|") = 0 And StringInStr($mInput_DirectoryRead, "|") = 0 And StringInStr($mInput_NameRead, "|") = 0 Then
					$mMsgBox = 6
					If IniRead($mProfile[0], "Patterns", $mTEMPFileNameExt, "") <> "" Then
						If $mFileNameExt <> $mInput_RuleData Then
							$mMsgBox = MsgBox(0x04, __Lang_Get('MANAGE_EDIT_MSGBOX_2', 'Replace association'), __Lang_Get('MANAGE_EDIT_MSGBOX_3', 'This pattern rule already exists. Do you want to replace it?'), 0, __OnTop())
						EndIf
						If $mMsgBox = 6 Then
							IniDelete($mProfile[0], "Patterns", $mTEMPFileNameExt)
						EndIf
					EndIf

					If $mMsgBox = 6 Then
						If $mNewAssociation = 0 Then
							$mInput_RuleData = __GetPatternString($mInitialType, $mInput_RuleData) ; Get Pattern String.
							IniDelete($mProfile[0], "Patterns", $mInput_RuleData)
						EndIf
						$mInput_DirectoryRead &= "|" & $mInput_NameRead
						For $A = 0 To 3
							$mInput_DirectoryRead &= "|" & $mFilters[$A][0] & $mFilters[$A][1] & $mFilters[$A][2] & $mFilters[$A][3]
						Next
						IniWrite($mProfile[0], "Patterns", $mTEMPFileNameExt, $mInput_DirectoryRead)
						$mChanged = 1
						ExitLoop
					EndIf
				Else
					MsgBox(0x30, __Lang_Get('MANAGE_EDIT_MSGBOX_4', 'Pattern Error'), __Lang_Get('MANAGE_EDIT_MSGBOX_5', 'You have to insert correct rules for this pattern ("$", "?", "|" characters cannot be used)'), 0, __OnTop())
				EndIf

			Case $mButton_Filters
				$mFilters = _Manage_Filters($mGUI, $mFilters)

			Case $mRule_Info
				MsgBox(0, __Lang_Get('MANAGE_EDIT_MSGBOX_6', 'Supported Rules'), __Lang_Get('MANAGE_EDIT_MSGBOX_7', 'Examples of supported rules for files:  @LF  *.jpg   = all files with "jpg" extension  @LF  penguin*.*   = all files that begin with "penguin"  @LF  *penguin*   = all files that contain "penguin"  @LF  C:\Desktop\*.jpg   = all "jpg" files from "Desktop"  @LF  @LF  Examples of supported rules for folders:  @LF  robot**   = all folders that begin with "robot"  @LF  **robot**   = all folders that contain "robot"  @LF  C:\**\robot   = all "robot" folders from a "C:" subfolder  @LF  @LF  Separate several rules in a pattern with ";" to  @LF  create multi-rule patterns (eg:  *.jpg;*.png ).'), 0, __OnTop())

			Case $mType_Info
				__ExpandEnvStrings(0)
				MsgBox(0, __Lang_Get('MANAGE_EDIT_MSGBOX_8', 'Internal Environment Variables'), __Lang_Get('ENV_VAR_LABEL_0', 'List of supported internal environment variables:') & @LF & _
						'%CurrentDate% = ' & __Lang_Get('ENV_VAR_0', 'current date ["2011-05-16"]') & @LF & _
						'%CurrentTime% = ' & __Lang_Get('ENV_VAR_1', 'current time ["19.40.32"]') & @LF & _
						'%DateCreated% = ' & __Lang_Get('ENV_VAR_2', 'date file creation ["2011-05-16"]') & @LF & _
						'%DateModified% = ' & __Lang_Get('ENV_VAR_3', 'date file modification ["2011-05-16"]') & @LF & _
						'%DateOpened% = ' & __Lang_Get('ENV_VAR_4', 'date file last access ["2011-05-16"]') & @LF & _
						'%DateTaken% = ' & __Lang_Get('ENV_VAR_5', 'date picture taken ["2011-05-16"]') & @LF & _
						'%DefaultProgram% = ' & __Lang_Get('ENV_VAR_6', 'system default program ° [Notepad]') & @LF & _
						'%File% = ' & __Lang_Get('ENV_VAR_7', 'file full path ° ["C:\Docs\Text.txt"]') & @LF & _
						'%FileAuthor% = ' & __Lang_Get('ENV_VAR_8', 'file author ["Lupo Team"]') & @LF & _
						'%FileExt% = ' & __Lang_Get('ENV_VAR_9', 'file extension ["txt"]') & @LF & _
						'%FileName% = ' & __Lang_Get('ENV_VAR_10', 'file name without extension ["Text"]') & @LF & _
						'%FileNameExt% = ' & __Lang_Get('ENV_VAR_11', 'file name with extension ["Text.txt"]') & @LF & _
						'%FileSubDir% = ' & __Lang_Get('ENV_VAR_21', 'subdirectory structure ["\SubFolder"]') & @LF & _
						'%FileType% = ' & __Lang_Get('ENV_VAR_12', 'file type ["Text document"]') & @LF & _
						'%ParentDir% = ' & __Lang_Get('ENV_VAR_13', 'directory of each file ["C:\Docs"]') & @LF & _
						'%PortableDrive% = ' & __Lang_Get('ENV_VAR_14', 'current drive letter ["C:"]') & @LF & _
						'%SongAlbum% = ' & __Lang_Get('ENV_VAR_15', 'song album ["The Wall"]') & @LF & _
						'%SongArtist% = ' & __Lang_Get('ENV_VAR_16', 'song artist ["Pink Floyd"]') & @LF & _
						'%SongGenre% = ' & __Lang_Get('ENV_VAR_17', 'song genre ["Rock"]') & @LF & _
						'%SongNumber% = ' & __Lang_Get('ENV_VAR_18', 'song track number ["3"]') & @LF & _
						'%SongTitle% = ' & __Lang_Get('ENV_VAR_19', 'song title ["Hey You"]') & @LF & _
						'%SongYear% = ' & __Lang_Get('ENV_VAR_20', 'song year ["1979"]') & @LF & _
						@LF & __Lang_Get('ENV_VAR_LABEL_1', '° supported only by Open With action'), 0, __OnTop())
				__ExpandEnvStrings(1)

			Case $mButton_Directory
				If $mCurrentType <> __Lang_Get('OPEN_WITH', 'Open With') Then
					$mFolder = FileSelectFolder(__Lang_Get('MANAGE_DESTINATION_FOLDER_SELECT', 'Select a destination folder:'), "", 3, "", $mGUI)
					If StringRight($mFolder, 1) = "\" Then
						$mFolder = StringTrimRight($mFolder, 1)
					EndIf
				Else
					$mFolder = FileOpenDialog(__Lang_Get('MANAGE_DESTINATION_PROGRAM_SELECT', 'Select a destination program:'), @ScriptDir, __Lang_Get('MANAGE_EDIT_MSGBOX_10', 'Executable or Script') & " (*.bat;*.cmd;*.com;*.exe;*.pif)", 1, "", $mGUI)
					If @error Then
						$mFolder = ""
					EndIf
				EndIf
				If __Is("ConvertPath") Then
					Local $mRelative = _PathGetRelative(@ScriptDir, $mFolder)
					$mFolder = $mRelative
				EndIf
				If $mFolder <> "" Then
					GUICtrlSetData($mInput_Directory, $mFolder)
				EndIf

		EndSwitch
	WEnd
	GUIDelete($mGUI)

	If $mChanged = 1 Then
		Return $mChanged
	EndIf
	Return SetError(1, 0, 0)
EndFunc   ;==>_Manage_Edit_GUI

Func _Manage_Delete($mListView, $mIndex, $mProfile)
	Local $mMsgBox, $mPattern, $mCurrentType

	$mPattern = _GUICtrlListView_GetItemText($mListView, $mIndex, 1)
	$mCurrentType = _GUICtrlListView_GetItemText($mListView, $mIndex, 2)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	If $mIndex = -1 Then
		Return SetError(1, 0, 0)
	EndIf
	If $mProfile = "" Then
		$mProfile = __IsProfile(-1, 0) ; Get Array Of Current Profile.
	EndIf
	If $mIndex <> -1 Then
		$mMsgBox = MsgBox(0x04, __Lang_Get('MANAGE_DELETE_MSGBOX_0', 'Delete association'), __Lang_Get('MANAGE_DELETE_MSGBOX_1', 'Selected pattern:') & "  " & $mPattern & @LF & __Lang_Get('MANAGE_DELETE_MSGBOX_2', 'Are you sure to delete this association?'), 0, __OnTop())
	EndIf
	If $mMsgBox <> 6 Then
		Return SetError(1, 0, 0)
	EndIf

	$mPattern = __GetPatternString($mCurrentType, $mPattern) ; Get Pattern String.
	IniDelete($mProfile, "Patterns", $mPattern)
	_GUICtrlListView_DeleteItem($mListView, $mIndex)

	$Global_ListViewIndex = -1
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_Manage_Delete

Func _Manage_ExtractFilters($mProfile, $mPattern, $mType)
	Local $mStringSplit, $mFilters[4][4], $mNumberFields = 8

	$mPattern = __GetPatternString($mType, $mPattern) ; Get Pattern String.
	$mStringSplit = StringSplit(IniRead($mProfile, "Patterns", $mPattern, ""), "|")
	If @error Then
		Return SetError(1, 0, $mFilters)
	EndIf
	ReDim $mStringSplit[$mNumberFields]

	For $A = 3 To 6
		$mFilters[$A - 3][0] = StringLeft($mStringSplit[$A], 1)
		$mFilters[$A - 3][1] = StringLeft(StringTrimLeft($mStringSplit[$A], 1), 1)
		$mFilters[$A - 3][2] = StringRegExpReplace(StringTrimLeft($mStringSplit[$A], 2), "[^0-9]", "")
		$mFilters[$A - 3][3] = StringTrimLeft($mStringSplit[$A], 2 + StringLen($mFilters[$A - 3][2]))
	Next

	Return $mFilters
EndFunc   ;==>_Manage_ExtractFilters

Func _Manage_Filters($mHandle, $mFilters)
	Local $mGUI, $mSave, $mCancel, $mState, $mText, $mGUI_Items[4][4]
	Local $mCheckText[4] = [__Lang_Get('SIZE', 'Size'), __Lang_Get('DATE_CREATED', 'Date Created'), __Lang_Get('DATE_MODIFIED', 'Date Modified'), __Lang_Get('DATE_OPENED', 'Date Opened')]

	$mGUI = GUICreate(__Lang_Get('ADDITIONAL_FILTERS', 'Additional Filters'), 370, 180, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	For $A = 0 To 3
		$mGUI_Items[$A][0] = GUICtrlCreateCheckbox($mCheckText[$A], 10, 16 + (30 * $A), 150, 20)
		If $mFilters[$A][0] = 1 Then
			GUICtrlSetState($mGUI_Items[$A][0], $GUI_CHECKED)
		EndIf

		$mGUI_Items[$A][1] = GUICtrlCreateCombo("", 10 + 150, 15 + (30 * $A), 30, 22, 0x0003)
		If $mFilters[$A][1] = "" Then
			$mFilters[$A][1] = ">"
		EndIf
		GUICtrlSetData($mGUI_Items[$A][1], ">|=|<", $mFilters[$A][1])

		$mGUI_Items[$A][2] = GUICtrlCreateInput($mFilters[$A][2], 10 + 150 + 35, 15 + (30 * $A), 60, 22, 0x2000)

		$mGUI_Items[$A][3] = GUICtrlCreateCombo("", 10 + 150 + 35 + 65, 15 + (30 * $A), 100, 22, 0x0003)
		If $A = 0 Then
			If $mFilters[$A][3] = "" Then
				$mFilters[$A][3] = "KB"
			EndIf
			GUICtrlSetData($mGUI_Items[$A][3], "KB|MB|GB", $mFilters[$A][3])
		Else
			Switch $mFilters[$A][3]
				Case "s"
					$mText = __Lang_Get('TIME_SECONDS', 'seconds')
				Case "n"
					$mText = __Lang_Get('TIME_MINUTES', 'minutes')
				Case "h"
					$mText = __Lang_Get('TIME_HOURS', 'hours')
				Case "m"
					$mText = __Lang_Get('TIME_MONTHS', 'months')
				Case "y"
					$mText = __Lang_Get('TIME_YEARS', 'years')
				Case Else
					$mText = __Lang_Get('TIME_DAYS', 'days')
			EndSwitch
			GUICtrlSetData($mGUI_Items[$A][3], __Lang_Get('TIME_SECONDS', 'seconds') & "|" & __Lang_Get('TIME_MINUTES', 'minutes') & "|" & __Lang_Get('TIME_HOURS', 'hours') & "|" & __Lang_Get('TIME_DAYS', 'days') & "|" & __Lang_Get('TIME_MONTHS', 'months') & "|" & __Lang_Get('TIME_YEARS', 'years'), $mText)
		EndIf

		$mState = $GUI_DISABLE
		If GUICtrlRead($mGUI_Items[$A][0]) = 1 Then
			$mState = $GUI_ENABLE
		EndIf
		For $B = 1 To 3
			GUICtrlSetState($mGUI_Items[$A][$B], $mState)
		Next
	Next

	$mSave = GUICtrlCreateButton("&" & __Lang_Get('OK', 'OK'), 185 - 40 - 85, 145, 80, 24)
	$mCancel = GUICtrlCreateButton("&" & __Lang_Get('CANCEL', 'Cancel'), 185 + 40, 145, 80, 24)
	GUICtrlSetState($mSave, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $mCancel
				SetError(1, 0, 0)
				ExitLoop

			Case $mGUI_Items[0][0], $mGUI_Items[1][0], $mGUI_Items[2][0], $mGUI_Items[3][0]
				For $A = 0 To 3
					$mState = $GUI_DISABLE
					If GUICtrlRead($mGUI_Items[$A][0]) = 1 Then
						$mState = $GUI_ENABLE
					EndIf
					For $B = 1 To 3
						GUICtrlSetState($mGUI_Items[$A][$B], $mState)
					Next
				Next

			Case $mSave
				For $A = 0 To 3
					$mState = 0
					If GUICtrlRead($mGUI_Items[$A][0]) = 1 Then
						$mState = 1
					EndIf
					If GUICtrlRead($mGUI_Items[$A][2]) = 0 Or GUICtrlRead($mGUI_Items[$A][2]) = "" Then ; Reset Filter If Not Defined.
						$mState = 0
						GUICtrlSetData($mGUI_Items[$A][2], "")
					EndIf
					$mFilters[$A][0] = $mState

					$mFilters[$A][1] = GUICtrlRead($mGUI_Items[$A][1])

					$mFilters[$A][2] = GUICtrlRead($mGUI_Items[$A][2])

					$mText = GUICtrlRead($mGUI_Items[$A][3])
					If $A = 0 Then
						$mFilters[$A][3] = $mText
					Else
						Switch $mText
							Case __Lang_Get('TIME_SECONDS', 'seconds')
								$mState = "s"
							Case __Lang_Get('TIME_MINUTES', 'minutes')
								$mState = "n"
							Case __Lang_Get('TIME_HOURS', 'hours')
								$mState = "h"
							Case __Lang_Get('TIME_MONTHS', 'months')
								$mState = "m"
							Case __Lang_Get('TIME_YEARS', 'years')
								$mState = "y"
							Case Else ; days.
								$mState = "d"
						EndSwitch
						$mFilters[$A][3] = $mState
					EndIf
				Next
				ExitLoop

		EndSwitch
	WEnd
	GUIDelete($mGUI)

	Return $mFilters
EndFunc   ;==>_Manage_Filters

Func _Manage_Paste()
	Local $mMsgBox = 6

	If IniRead($Global_Clipboard[4], "Patterns", $Global_Clipboard[2], "") <> "" Then ; Pattern Already Exists.
		$mMsgBox = MsgBox(0x04, __Lang_Get('MANAGE_EDIT_MSGBOX_2', 'Replace association'), __Lang_Get('MANAGE_EDIT_MSGBOX_3', 'This pattern rule already exists. Do you want to replace it?'), 0, __OnTop())
	EndIf
	If $mMsgBox = 6 Then
		If $Global_Clipboard[0] = 1 Then ; Cut Mode.
			IniDelete($Global_Clipboard[1], "Patterns", $Global_Clipboard[2]) ; Remove Pattern From Old Profile.
		EndIf
		IniWrite($Global_Clipboard[4], "Patterns", $Global_Clipboard[2], $Global_Clipboard[3]) ; Add Pattern To New Profile.
	EndIf

	For $A = 0 To 4
		$Global_Clipboard[$A] = 0 ; Clean Clipboard.
	Next
	Return 1
EndFunc   ;==>_Manage_Paste

Func _Manage_Update($mListView, $mProfile)
	Local $mPatterns, $mFileNameExt_Pattern, $mFileNameExt_Shown, $mType

	$mPatterns = __GetPatterns($mProfile) ; Gets Patterns Array For The Current Profile.

	_GUICtrlListView_BeginUpdate($mListView)
	_GUICtrlListView_DeleteAllItems($mListView)
	For $A = 1 To $mPatterns[0][0]
		$mPatterns[$A][1] = StringReplace($mPatterns[$A][1], "Empty-Destination", "-") ; Fix Destination Created In Old Releases.
		$mFileNameExt_Pattern = $mPatterns[$A][0]
		$mFileNameExt_Shown = StringTrimRight($mFileNameExt_Pattern, 2)
		$mType = StringRight($mFileNameExt_Pattern, 2)

		If $mType = "$6" Then
			Switch $mPatterns[$A][1] ; Destination.
				Case 2
					$mPatterns[$A][1] = __Lang_Get('DELETE_MODE_2', 'Safely Erase')
				Case 3
					$mPatterns[$A][1] = __Lang_Get('DELETE_MODE_3', 'Send to Recycle Bin')
				Case Else
					$mPatterns[$A][1] = __Lang_Get('DELETE_MODE_1', 'Normally Delete')
			EndSwitch
		EndIf
		$mType = __GetPatternString($mType) ; Convert String Type To Action Type.

		_GUICtrlListView_AddItem($mListView, $mPatterns[$A][2], -1, _GUICtrlListView_GetItemCount($mListView) + 9999)
		_GUICtrlListView_AddSubItem($mListView, $A - 1, $mFileNameExt_Shown, 1)
		_GUICtrlListView_AddSubItem($mListView, $A - 1, $mType, 2)
		_GUICtrlListView_AddSubItem($mListView, $A - 1, $mPatterns[$A][1], 3)

		If $mPatterns[$A][7] <> "Disabled" Then
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
	Return $mProfile
EndFunc   ;==>_Manage_Update

Func _GUICtrlListView_ContextMenu_Manage($cmListView, $cmIndex, $cmSubItem)
	Local Enum $cmItem1 = 1000, $cmItem2, $cmItem3, $cmItem4, $cmItem5, $cmItem6

	If IsHWnd($cmListView) = 0 Then
		$cmListView = GUICtrlGetHandle($cmListView)
	EndIf

	Local $cmContextMenu = _GUICtrlMenu_CreatePopup()
	If $cmIndex <> -1 And $cmSubItem <> -1 Then ; Won't Show These MenuItem(s) Unless An Item Is Selected.
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu, __Lang_Get('EDIT', 'Edit'), $cmItem1)
		__SetItemImage("EDIT", $cmIndex, $cmContextMenu, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu, "")
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu, __Lang_Get('CUT', 'Cut'), $cmItem2)
		__SetItemImage("CUT", $cmIndex, $cmContextMenu, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu, __Lang_Get('COPY', 'Copy'), $cmItem3)
		__SetItemImage("COPY", $cmIndex, $cmContextMenu, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu, __Lang_Get('PASTE', 'Paste'), $cmItem4)
		__SetItemImage("PASTE", $cmIndex, $cmContextMenu, 2, 1)
		If $Global_Clipboard[0] = 0 Or $Global_Clipboard[1] == $Global_Clipboard[4] Then ; If Clipboard Is Empty Or Original Profile = Current Profile.
			_GUICtrlMenu_SetItemState($cmContextMenu, $cmIndex, $MFS_DISABLED)
		EndIf
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu, "")
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu, __Lang_Get('DELETE', 'Delete'), $cmItem5)
		__SetItemImage("DEL", $cmIndex, $cmContextMenu, 2, 1)
	EndIf
	If $cmIndex = -1 And $cmSubItem <> -1 Then ; Will Show These MenuItem(s) If No Item Is Selected.
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu, __Lang_Get('NEW', 'New'), $cmItem6) ; Will Show These MenuItem(s) Regardless.
		__SetItemImage("NEW", $cmIndex, $cmContextMenu, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu, "")
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu, __Lang_Get('PASTE', 'Paste'), $cmItem4)
		__SetItemImage("PASTE", $cmIndex, $cmContextMenu, 2, 1)
		If $Global_Clipboard[0] = 0 Or $Global_Clipboard[1] == $Global_Clipboard[4] Then ; If Clipboard Is Empty Or Original Profile = Current Profile.
			_GUICtrlMenu_SetItemState($cmContextMenu, $cmIndex, $MFS_DISABLED)
		EndIf
	EndIf

	Switch _GUICtrlMenu_TrackPopupMenu($cmContextMenu, $cmListView, -1, -1, 1, 1, 2)
		Case $cmItem1
			GUICtrlSendToDummy($Global_ListViewRules_Enter)
		Case $cmItem2
			GUICtrlSendToDummy($Global_ListViewRules_Cut)
		Case $cmItem3
			GUICtrlSendToDummy($Global_ListViewRules_Copy)
		Case $cmItem4
			GUICtrlSendToDummy($Global_ListViewRules_Paste)
		Case $cmItem5
			GUICtrlSendToDummy($Global_ListViewRules_Delete)
		Case $cmItem6
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
	Local $cDeleteDummy, $cEnterDummy, $cNewDummy, $cExampleDummy

	$cProfileDirectory = __GetDefault(2) ; Get Default Profile Directory.
	Local $cSize = __GetCurrentSize("SizeCustom") ; 320 x 200.

	If $cProfileList = -1 Or $cProfileList = 0 Or $cProfileList = "" Then
		$cProfileList = __ProfileList() ; Get Array Of All Profiles.
	EndIf
	If IsArray($cProfileList) = 0 Then
		Return SetError(1, 0, 0) ; Exit Function If No ProfileList.
	EndIf

	$cGUI = GUICreate(__Lang_Get('CUSTOMIZE_GUI', 'Customize Profiles'), $cSize[0], $cSize[1], -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX), -1, __OnTop($cHandle))
	GUISetIcon(@ScriptFullPath, -5, $cGUI) ; Use Custom.ico
	$Global_Customize = $cGUI
	$Global_ResizeWidth = 300 ; Set Default Minimum Width.
	$Global_ResizeHeight = 190 ; Set Default Minimum Height.

	$cListView = GUICtrlCreateListView(__Lang_Get('PROFILE', 'Profile') & "|" & __Lang_Get('IMAGE', 'Image') & "|" & __Lang_Get('SIZE', 'Size') & "|" & __Lang_Get('TRANSPARENCY', 'Transparency'), 5, 5, $cSize[0] - 10, $cSize[1] - 40, BitOR($LVS_NOSORTHEADER, $LVS_REPORT, $LVS_SINGLESEL))
	$cListView_Handle = GUICtrlGetHandle($cListView)

	$Global_ListViewProfiles = $cListView_Handle
	GUICtrlSetResizing($cListView, $GUI_DOCKBORDERS)

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
	If @error Then
		SetError(1, 0, 0) ; Exit Function If No Profiles.
	EndIf

	$cDeleteDummy = GUICtrlCreateDummy()
	$Global_ListViewProfiles_Delete = $cDeleteDummy
	$cEnterDummy = GUICtrlCreateDummy()
	$Global_ListViewProfiles_Enter = $cEnterDummy
	$cNewDummy = GUICtrlCreateDummy()
	$Global_ListViewProfiles_New = $cNewDummy
	$cExampleDummy = GUICtrlCreateDummy()
	$Global_ListViewProfiles_Example[0] = $cExampleDummy

	$cNew = GUICtrlCreateButton("&" & __Lang_Get('NEW', 'New'), 50, $cSize[1] - 30, 74, 25)
	GUICtrlSetTip($cNew, __Lang_Get('CUSTOMIZE_GUI_TIP_0', 'Click to add a profile or Right-click a profile to manage it.'))
	GUICtrlSetResizing($cNew, $GUI_DOCKSIZE + $GUI_DOCKLEFT + $GUI_DOCKBOTTOM)
	$cClose = GUICtrlCreateButton("&" & __Lang_Get('CLOSE', 'Close'), $cSize[0] - 50 - 74, $cSize[1] - 30, 74, 25)
	GUICtrlSetTip($cClose, __Lang_Get('CUSTOMIZE_GUI_TIP_1', 'Save profile changes and close the window.'))
	GUICtrlSetResizing($cClose, $GUI_DOCKSIZE + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM)
	GUICtrlSetState($cClose, $GUI_DEFBUTTON)

	$Global_ListViewIndex = -1 ; Set As No Item Selected.
	GUIRegisterMsg(0x004E, "WM_NOTIFY")
	GUIRegisterMsg(0x0024, "WM_GETMINMAXINFO")
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
				If Not _GUICtrlListView_GetItemState($cListView_Handle, $cIndex_Selected, $LVIS_SELECTED) Then
					ContinueLoop
				EndIf

				$cText = _GUICtrlListView_GetItemText($cListView_Handle, $cIndex_Selected)
				$cImage = _GUICtrlListView_GetItemText($cListView_Handle, $cIndex_Selected, 1)
				$cSizeText = _GUICtrlListView_GetItemText($cListView_Handle, $cIndex_Selected, 2)
				$cTransparency = _GUICtrlListView_GetItemText($cListView_Handle, $cIndex_Selected, 3)
				_Customize_Edit_GUI($cGUI, $cText, $cImage, $cSizeText, $cTransparency, 0) ; Show Customize Edit GUI Of Selected Profile.
				_Customize_Update($cListView_Handle, $cProfileDirectory, -1) ; Add/Update Customise GUI With List Of Profiles.
				_GUICtrlListView_SetItemSelected($cListView_Handle, $cIndex_Selected, True, True)

			Case $cExampleDummy
				If FileExists(__GetDefault(2) & $Global_ListViewProfiles_Example[1] & ".ini") Then
					MsgBox(0x30, __Lang_Get('PROFILEUNIQUE_MSGBOX_0', 'Name not available'), __Lang_Get('PROFILEUNIQUE_MSGBOX_1', 'This profile name already exists.'), 0, __OnTop())
					ContinueLoop
				EndIf
				Switch $Global_ListViewProfiles_Example[1]
					Case "Archiver"
						_ResourceSaveToFile(__GetDefault(2) & "Archiver.ini", "ARCHIVER")
					Case "Eraser"
						_ResourceSaveToFile(__GetDefault(2) & "Eraser.ini", "ERASER")
					Case "Extractor"
						_ResourceSaveToFile(__GetDefault(2) & "Extractor.ini", "EXTRACTOR")
				EndSwitch
				_Customize_Update($cListView_Handle, $cProfileDirectory, -1) ; Add/Update Customise GUI With List Of Profiles.

		EndSwitch
	WEnd
	__SetCurrentSize($cGUI, "SizeCustom")
	GUIDelete($cGUI)
	_GUIImageList_Destroy($cImageList)

	__SetCurrentPosition() ; Set Current Coordinates/Position Of DropIt.
	__IsOnTop() ; Set GUI "OnTop" If True.

	$cProfileList = __ProfileList() ; Get Array Of All Profiles.
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return $cProfileList
EndFunc   ;==>_Customize_GUI

Func _Customize_Edit_GUI($cHandle = -1, $cProfile = -1, $cImage = -1, $cSizeText = -1, $cTransparency = -1, $cNewProfile = 0)
	Local $cGUI_1 = $Global_GUI_1

	Local $cStringSplit, $cProfileType, $cGUI, $cInput_Name, $cInput_Image, $cButton_Image, $cInput_SizeX, $cInput_SizeY, $cButton_Size, $cInput_Transparency
	Local $cSave, $cCancel, $cChanged = 0, $cProfileDirectory, $cReturn, $cSizeX, $cSizeY, $cIniWrite, $cItemText, $cLabel_Transparency, $cCurrentProfile = 0
	Local $cNewProfileCreated = 0, $cIcon_GUI, $cInitialProfileName, $cIcon_Label

	$cProfile = __IsProfile($cProfile, 0) ; Get Array Of Selected Profile.
	$cProfileDirectory = __GetDefault(22) ; Get Default Profile & Default Image Directory & Default Image File.

	If $cNewProfile = 1 Then
		$cProfile[1] = ""
	EndIf
	If $cImage == -1 Or $cImage == 0 Or $cImage == "" Then
		$cImage = $cProfileDirectory[3][0] ; Default Image Directory & Default Image File.
	EndIf

	If IsArray($cSizeText) = 0 Then
		$cStringSplit = StringSplit($cSizeText, "x")
	EndIf
	If IsArray($cStringSplit) And $cSizeText <> -1 Then
		Local $cSize[2] = [$cStringSplit[1], $cStringSplit[2]]
	Else
		Local $cSize[2] = [64, 64]
	EndIf

	If $cTransparency == -1 Or $cTransparency == 0 Or $cTransparency == "" Or $cTransparency < 10 Or $cTransparency > 100 Then
		$cTransparency = 100
	EndIf
	$cTransparency = StringReplace($cTransparency, "%", "")

	Select
		Case $cNewProfile = 1
			$cProfileType = __Lang_Get('CUSTOMIZE_PROFILE_NEW', 'New Profile')

		Case $cNewProfile = 0
			$cProfileType = __Lang_Get('CUSTOMIZE_PROFILE_EDIT', 'Edit Profile')
	EndSelect
	If __IsCurrentProfile($cProfile[1]) Then
		$cCurrentProfile = 1 ; __IsCurrentProfile() = Checks If Selected Profile Is The Current Profile.
	EndIf
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
	$cCancel = GUICtrlCreateButton("&" & __Lang_Get('CANCEL', 'Cancel'), 130 + 20, 250, 76, 26)
	GUICtrlSetState($cCancel, $GUI_DEFBUTTON)

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

		; Disable/Enable Save Button:
		If GUICtrlRead($cInput_Name) <> "" And GUICtrlRead($cInput_Image) <> "" And GUICtrlRead($cInput_SizeX) <> "" And GUICtrlRead($cInput_SizeY) <> "" _
				And GUICtrlRead($cInput_Transparency) <> "" And __FilePathIsValid($cProfileDirectory[2][0] & GUICtrlRead($cInput_Image)) And StringIsSpace(GUICtrlRead($cInput_Name)) = 0 Then
			If GUICtrlGetState($cSave) > 80 Then
				GUICtrlSetState($cSave, 576) ; $GUI_ENABLE + $GUI_DEFBUTTON.
			EndIf
			If GUICtrlGetState($cCancel) = 512 Then
				GUICtrlSetState($cCancel, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
		ElseIf GUICtrlRead($cInput_Name) = "" Or GUICtrlRead($cInput_Image) = "" Or GUICtrlRead($cInput_SizeX) = "" Or GUICtrlRead($cInput_SizeY) = "" _
				Or GUICtrlRead($cInput_Transparency) = "" Or __FilePathIsValid($cProfileDirectory[2][0] & GUICtrlRead($cInput_Image)) = 0 Or StringIsSpace(GUICtrlRead($cInput_Name)) Then
			If GUICtrlGetState($cSave) = 80 Then
				GUICtrlSetState($cSave, 144) ; $GUI_DISABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($cCancel) = 80 Then
				GUICtrlSetState($cCancel, 512) ; $GUI_DEFBUTTON.
			EndIf
		EndIf

		; Disable/Enable Some Buttons:
		If GUICtrlRead($cInput_Name) <> "" And StringIsSpace(GUICtrlRead($cInput_Name)) = 0 Then
			If GUICtrlGetState($cButton_Image) > 80 Then
				GUICtrlSetState($cButton_Image, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($cButton_Size) > 80 Then
				GUICtrlSetState($cButton_Size, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($cInput_Transparency) > 80 Then
				GUICtrlSetState($cInput_Transparency, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($cInput_SizeX) > 80 Then
				GUICtrlSetState($cInput_SizeX, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($cInput_SizeY) > 80 Then
				GUICtrlSetState($cInput_SizeY, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($cInput_Image) > 80 Then
				GUICtrlSetState($cInput_Image, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
		ElseIf GUICtrlRead($cInput_Name) = "" Or StringIsSpace(GUICtrlRead($cInput_Name)) Then
			If GUICtrlGetState($cButton_Image) = 80 Then
				GUICtrlSetState($cButton_Image, 144) ; $GUI_DISABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($cButton_Size) = 80 Then
				GUICtrlSetState($cButton_Size, 144) ; $GUI_DISABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($cInput_Transparency) = 80 Then
				GUICtrlSetState($cInput_Transparency, 144) ; $GUI_DISABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($cInput_SizeX) = 80 Then
				GUICtrlSetState($cInput_SizeX, 144) ; $GUI_DISABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($cInput_SizeY) = 80 Then
				GUICtrlSetState($cInput_SizeY, 144) ; $GUI_DISABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($cInput_Image) = 80 Then
				GUICtrlSetState($cInput_Image, 144) ; $GUI_DISABLE + $GUI_SHOW.
			EndIf
		EndIf

		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $cCancel
				If $cProfile[1] <> $cInitialProfileName And $cNewProfile = 0 And $cNewProfileCreated = 0 Then
					FileMove($cProfileDirectory[1][0] & $cInitialProfileName & ".ini", $cProfileDirectory[1][0] & $cProfile[1] & ".ini")
					If $cInitialProfileName == __GetCurrentProfile() Then ; Get Current Profile From The Settings INI File.
						__SetCurrentProfile($cProfile[1]) ; Write Selected Profile Name To The Settings INI File.
					EndIf
				EndIf

				If $cNewProfile = 0 Then
					_Image_Write($cProfile[1], 7, $cProfile[4], $cProfile[5], $cProfile[6], $cProfile[7]) ; Write Image File Name & Size & Transparency To The Selected Profile.
				EndIf
				$cItemText = StringReplace(StringStripWS(GUICtrlRead($cInput_Name), 7), " ", "_")
				If $cNewProfile = 1 Or $cNewProfileCreated = 1 Then
					FileDelete($cProfileDirectory[1][0] & $cItemText & ".ini")
				EndIf

				SetError(1, 0, 0)
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
					If FileExists($cIniWrite) = 0 Then
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
					If FileExists($cIniWrite) = 0 Then
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

				If @error = 0 Then
					$cImage = $cReturn[1]
					$cSizeX = $cReturn[2]
					$cSizeY = $cReturn[3]
					$cTransparency = $cReturn[4]
					GUICtrlSetData($cInput_Image, $cImage)
					GUICtrlSetData($cInput_SizeX, $cSizeX)
					GUICtrlSetData($cInput_SizeY, $cSizeY)
					__SetBitmap($cIcon_GUI, $cProfileDirectory[2][0] & $cImage, 255 / 100 * $cTransparency, 32, 32) ; Set Image & Resize To The Image GUI.
					If $cCurrentProfile = 1 Then
						__SetBitmap($cGUI_1, $cProfileDirectory[2][0] & $cImage, 255 / 100 * $cTransparency, $cSizeX, $cSizeY) ; Set Image & Resize To The GUI If Current Profile.
					EndIf
					__GUIInBounds($cGUI_1) ; Checks If The GUI Is Within View Of The Users Screen.
				EndIf
				$cChanged = 1

			Case $cButton_Size
				$cItemText = StringReplace(StringStripWS(GUICtrlRead($cInput_Name), 7), " ", "_")
				$cImage = GUICtrlRead($cInput_Image)
				$cReturn = __ImageSize($cProfileDirectory[2][0] & $cImage)
				If @error = 0 Then
					GUICtrlSetData($cInput_SizeX, $cReturn[0])
					GUICtrlSetData($cInput_SizeY, $cReturn[1])
					GUICtrlSetData($cInput_Transparency, 100)
					GUICtrlSetData($cLabel_Transparency, 100 & "%")
					If $cNewProfile = 0 Then
						_Image_Write($cItemText, 2, $cImage, $cReturn[0], $cReturn[1], 100) ; Write Size To The Selected Profile.
					EndIf
					__SetBitmap($cIcon_GUI, $cProfileDirectory[2][0] & $cImage, 255 / 100 * 100, 32, 32) ; Set Image & Resize To The Image GUI.
					If $cCurrentProfile = 1 Then
						__SetBitmap($cGUI_1, $cProfileDirectory[2][0] & $cImage, 255 / 100 * 100, $cReturn[0], $cReturn[1]) ; Set Image & Resize To The GUI If Current Profile.
					EndIf
				EndIf
				$cChanged = 1

			Case $cInput_Transparency ; Changes The Transparency Of The Current Profile Image Only.
				$cImage = GUICtrlRead($cInput_Image)
				$cSizeX = GUICtrlRead($cInput_SizeX)
				$cSizeY = GUICtrlRead($cInput_SizeY)
				$cTransparency = GUICtrlRead($cInput_Transparency)
				__SetBitmap($cIcon_GUI, $cProfileDirectory[2][0] & $cImage, 255 / 100 * $cTransparency, 32, 32) ; Set Image & Resize To The Image GUI.
				If $cCurrentProfile = 1 Then
					__SetBitmap($cGUI_1, $cProfileDirectory[2][0] & $cImage, 255 / 100 * $cTransparency, $cSizeX, $cSizeY) ; Set Image & Resize To The GUI If Current Profile.
				EndIf

		EndSwitch
	WEnd
	GUIDelete($cGUI)

	__SetCurrentPosition() ; Set Current Coordinates/Position Of DropIt.
	$cProfile = __IsProfile(-1, 0) ; Get Array Of Current Profile.
	__SetBitmap($cGUI_1, $cProfile[3], 255 / 100 * $cProfile[7], $cProfile[5], $cProfile[6]) ; Set Image & Resize To The GUI.

	If $cChanged = 1 Then
		Return $cChanged
	EndIf
	Return SetError(1, 0, 0)
EndFunc   ;==>_Customize_Edit_GUI

Func _Customize_Delete($cListView, $cIndexItem, $cProfileDirectory, $cFileName = -1, $cHandle = -1)
	If $cIndexItem = -1 Then
		Return SetError(1, 0, 0)
	EndIf
	If $cFileName = -1 Or $cFileName = 0 Or $cFileName = "" Then
		$cFileName = _GUICtrlListView_GetItemText($cListView, $cIndexItem, 0)
	EndIf
	If $cFileName = "" Then
		Return SetError(1, 0, 0)
	EndIf

	If _GUICtrlListView_GetItemCount($cListView) = 1 Then
		MsgBox(0x30, __Lang_Get('CUSTOMIZE_DELETE_MSGBOX_0', 'Profile Error'), __Lang_Get('CUSTOMIZE_DELETE_MSGBOX_1', 'You must have at least 1 active profile.'), 0, __OnTop($cHandle))
		Return SetError(1, 0, 0)
	EndIf

	Local $cMsgBox = MsgBox(0x04, __Lang_Get('CUSTOMIZE_DELETE_MSGBOX_2', 'Delete selected profile'), __Lang_Get('CUSTOMIZE_DELETE_MSGBOX_3', 'Selected profile:') & "  " & $cFileName & @LF & __Lang_Get('CUSTOMIZE_DELETE_MSGBOX_4', 'Are you sure to delete this profile?'), 0, __OnTop($cHandle))
	If $cMsgBox = 6 Then
		FileDelete($cProfileDirectory & $cFileName & ".ini")
		_GUICtrlListView_DeleteItem($cListView, $cIndexItem)

		__SetCurrentProfile(_GUICtrlListView_GetItemText($cListView, 0, 0)) ; Write Selected Profile Name To The Settings INI File.

		$cIndexItem -= 1
		If $cIndexItem = -1 Then
			$cIndexItem = 0
		EndIf
		_GUICtrlListView_SetItemSelected($cListView, $cIndexItem, True)
		If Not @error Then
			Return 1
		EndIf
	EndIf

	_GUICtrlListView_SetItemSelected($cListView, $cIndexItem, True)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_Customize_Delete

Func _Customize_Update($cListView, $cProfileDirectory, $cProfileList = -1, $cImageList = $Global_ImageList)
	Local $cListViewItem, $cIniReadTransparency, $cIniRead, $cIniRead_Size[2]

	If $cProfileList = -1 Or $cProfileList = 0 Or $cProfileList = "" Then
		$cProfileList = __ProfileList() ; Get Array Of All Profiles.
	EndIf
	If IsArray($cProfileList) = 0 Then
		Return SetError(1, 0, 0)
	EndIf

	If __IsFolder($cProfileDirectory) = 0 Then
		Return SetError(1, 0, 0) ; If Selected Is Not A Directory Then Return @error.
	EndIf

	Local $cImageDirectory = __GetDefault(4) ; Default Image Directory.

	_GUICtrlListView_BeginUpdate($cListView)
	_GUICtrlListView_DeleteAllItems($cListView)

	For $A = 1 To $cProfileList[0]
		Local $cINI = $cProfileDirectory & $cProfileList[$A] & ".ini"
		$cListViewItem = _GUICtrlListView_AddItem($cListView, $cProfileList[$A])

		$cIniRead = IniRead($cINI, "Target", "Image", "")
		If $cIniRead = "" Then
			$cIniRead = __GetDefault(16) ; Default Image File.
		EndIf
		_GUICtrlListView_AddSubItem($cListView, $cListViewItem, $cIniRead, 1)

		$cIniRead_Size[0] = IniRead($cINI, "Target", "SizeX", "")
		$cIniRead_Size[1] = IniRead($cINI, "Target", "SizeY", "")
		$cIniReadTransparency = IniRead($cINI, "Target", "Transparency", "")

		If $cIniRead_Size[0] = "" Or $cIniRead_Size[1] = "" Then
			$cIniRead_Size = __ImageSize(__GetDefault(4) & $cIniRead) ; If X & Y Empty Then Find The Size Of The Image Using Default Image Directory.
		EndIf
		If IsArray($cIniRead_Size) = 0 Then
			Return SetError(1, 0, 0)
		EndIf

		_GUICtrlListView_AddSubItem($cListView, $cListViewItem, $cIniRead_Size[0] & "x" & $cIniRead_Size[1], 2)
		_GUICtrlListView_AddSubItem($cListView, $cListViewItem, $cIniReadTransparency & "%", 3)

		__SetItemImageEx($cListView, $cListViewItem, $cImageList, $cImageDirectory & $cIniRead, 1)
	Next
	_GUICtrlListView_SetIconSpacing($cListView, 32, 32)
	_GUICtrlListView_SetItemSelected($cListView, 0, True)
	_GUICtrlListView_EndUpdate($cListView)

	If @error Then
		Return 1
	EndIf
	Return SetError(1, 0, 0)
EndFunc   ;==>_Customize_Update

Func _GUICtrlListView_ContextMenu_Customize($cmListView, $cmIndex, $cmSubItem)
	Local Enum $cmItem1 = 1000, $cmItem2, $cmItem3, $cmItem4, $cmItem5, $cmItem6, $cmItem7

	If IsHWnd($cmListView) = 0 Then
		$cmListView = GUICtrlGetHandle($cmListView)
	EndIf

	Local $cmContextMenu_1 = _GUICtrlMenu_CreatePopup()
	If $cmIndex <> -1 And $cmSubItem <> -1 Then ; Won't Show These MenuItem(s) Unless An Item Is Selected.
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __Lang_Get('EDIT', 'Edit'), $cmItem1)
		__SetItemImage("EDIT", $cmIndex, $cmContextMenu_1, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, "")
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __Lang_Get('DELETE', 'Delete'), $cmItem2)
		__SetItemImage("DEL", $cmIndex, $cmContextMenu_1, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, "")
	EndIf
	If $cmIndex = -1 And $cmSubItem <> -1 Then ; Will Show These MenuItem(s) If No Item Is Selected.
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __Lang_Get('NEW', 'New'), $cmItem3)
		__SetItemImage("NEW", $cmIndex, $cmContextMenu_1, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, "")
	EndIf

	Local $cmContextMenu_2 = _GUICtrlMenu_CreatePopup()
	$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __Lang_Get('EXAMPLES', 'Examples'), $cmItem4, $cmContextMenu_2)
	__SetItemImage("EXAMP", $cmIndex, $cmContextMenu_1, 2, 1)

	$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_2, "Archiver", $cmItem5)
	__SetItemImage(__GetDefault(4) & "Big_Box4.png", $cmIndex, $cmContextMenu_2, 2, 0)

	$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_2, "Eraser", $cmItem6)
	__SetItemImage(__GetDefault(4) & "Big_Delete1.png", $cmIndex, $cmContextMenu_2, 2, 0)

	$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_2, "Extractor", $cmItem7)
	__SetItemImage(__GetDefault(4) & "Big_Box6.png", $cmIndex, $cmContextMenu_2, 2, 0)

	Switch _GUICtrlMenu_TrackPopupMenu($cmContextMenu_1, $cmListView, -1, -1, 1, 1, 2)
		Case $cmItem1
			GUICtrlSendToDummy($Global_ListViewProfiles_Enter)
		Case $cmItem2
			GUICtrlSendToDummy($Global_ListViewProfiles_Delete)
		Case $cmItem3
			GUICtrlSendToDummy($Global_ListViewProfiles_New)
		Case $cmItem5
			$Global_ListViewProfiles_Example[1] = "Archiver"
			GUICtrlSendToDummy($Global_ListViewProfiles_Example[0])
		Case $cmItem6
			$Global_ListViewProfiles_Example[1] = "Eraser"
			GUICtrlSendToDummy($Global_ListViewProfiles_Example[0])
		Case $cmItem7
			$Global_ListViewProfiles_Example[1] = "Extractor"
			GUICtrlSendToDummy($Global_ListViewProfiles_Example[0])
	EndSwitch
	_GUICtrlMenu_DestroyMenu($cmContextMenu_1)
	_GUICtrlMenu_DestroyMenu($cmContextMenu_2)
	Return 1
EndFunc   ;==>_GUICtrlListView_ContextMenu_Customize
#Region End >>>>> Customize Functions <<<<<

#Region Start >>>>> Image Functions <<<<<
Func _Image_Get($iHandle = -1, $iProfile = -1)
	Local $iImageFile, $iSize, $iFileName

	Local $iReturn[6]

	$iImageFile = __IsProfile($iProfile, 0) ; Get Array Of Selected Profile.
	Local $iFileOpenDialog = FileOpenDialog(__Lang_Get('IMAGE_GET_TIP_0', 'Select target image for this Profile'), $iImageFile[8], __Lang_Get('IMAGE_GET', 'Images') & " (*.gif;*.jpg;*.png)", 1, "", __OnTop($iHandle))
	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	If StringLeft(FileGetVersion(@SystemDir & "\WinVer.exe"), 3) < 6.0 And __GetFileNameExExt($iFileOpenDialog, 1) == "gif" Then
		$iFileOpenDialog = __ImageConvert($iFileOpenDialog, $iImageFile[8])
	EndIf

	If StringInStr($iFileOpenDialog, $iImageFile[8]) = 0 Then
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

	If $iImageFile == -1 Or $iImageFile == 0 Or $iImageFile == "" Then
		$iImageFile = __GetDefault(16) ; Default Image File.
	EndIf
	$iTransparency = StringReplace($iTransparency, "%", "")

	If BitAND($iFlag, 1) Then
		IniWrite($iProfile, "Target", "Image", $iImageFile) ; 1 = Add Image File.
	EndIf
	If BitAND($iFlag, 2) Then ; 2 = Add Image Size.
		IniWrite($iProfile, "Target", "SizeX", $iSize_X)
		IniWrite($iProfile, "Target", "SizeY", $iSize_Y)
	EndIf
	If BitAND($iFlag, 4) Then
		IniWrite($iProfile, "Target", "Transparency", $iTransparency) ; 4 = Add Transparency.
	EndIf

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_Image_Write
#Region End >>>>> Image Functions <<<<<

#Region Start >>>>> Processing Functions <<<<<
Func _DropEvent($dFiles, $dProfile, $dMonitored = 0)
	__ExpandEnvStrings(1) ; Enables The Expansion Of Environment Variables.
	FileChangeDir(@ScriptDir) ; Ensures To Use DropIt.exe Directory As Working Directory.

	Local $dMsgBox, $dSize, $dFullSize, $dElementsGUI, $dFailedList[1] = [0]
	If IsArray($dFiles) = 0 Then
		Return SetError(1, 0, 0)
	EndIf

	For $A = 0 To UBound($dFiles) - 1
		If FileExists($dFiles[$A]) = 0 Then
			ContinueLoop
		EndIf
		If __IsFolder($dFiles[$A]) Then ; Checks If Selected Is A Directory.
			$dSize = DirGetSize($dFiles[$A])
		Else
			$dSize = FileGetSize($dFiles[$A])
		EndIf
		$dFullSize += $dSize
	Next
	__Log_Write(__Lang_Get('DROP_EVENT_TIP_0', 'Total Size Loaded'), __ByteSuffix($dFullSize)) ; __ByteSuffix() = Rounds A Value Of Bytes To Highest Value.

	If $dFullSize > 2 * 1024 * 1024 * 1024 And __Is("SizeMessage") Then
		$dMsgBox = MsgBox(0x04, __Lang_Get('DROP_EVENT_MSGBOX_3', 'Estimated long processing time'), __Lang_Get('DROP_EVENT_MSGBOX_4', 'You are trying to process a large size of files') & " (" & __ByteSuffix($dFullSize) & ")" & @LF & __Lang_Get('DROP_EVENT_MSGBOX_5', 'It may take a long time, do you wish to continue?'), 0, __OnTop())
		If $dMsgBox <> 6 Then
			__Log_Write(__Lang_Get('DROP_EVENT_TIP_1', 'Sorting Aborted'), __Lang_Get('DROP_EVENT_MSGBOX_3', 'Estimated long processing time'))
			Return SetError(1, 0, 0)
		EndIf
	EndIf

	$dElementsGUI = _Sorting_CreateGUI($dFullSize) ; Create The Sorting GUI & Show It If Option Is Enabled.
	For $A = 0 To UBound($dFiles) - 1
		If FileExists($dFiles[$A]) Then
			$Global_MainDir = $dFiles[$A] ; Used Only To Detect Main Folders For %FileSubDir%.
			$dFailedList = _PositionCheck($dFiles[$A], $dProfile, $dFailedList, $dElementsGUI, $dMonitored)
		EndIf
		If $Global_AbortSorting Then
			$dFailedList[0] = 0 ; Do Not Show Failed Items If The User Aborts Sorting (The List Results Incomplete).
			ExitLoop
		EndIf
	Next
	_Sorting_DeleteGUI() ; Delete The Sorting GUI.

	; Report A List Of Failed Sortings:
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
				FileWriteLine($dFile, "{" & __Lang_Get('DROP_EVENT_MSGBOX_9', 'NOTE: this file will be removed after closing') & "}")
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
	$Global_DuplicateMode = ""
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_DropEvent

Func _CheckingMatches($cFileName, $cFileNameExt, $cFilePath, $cProfile) ; Returns: Directory [C:\DropItFiles] Or To Associate [0] Or To Skip [-1]
	$cProfile = __IsProfile($cProfile, 0) ; Get Array Of Selected Profile.
	Local $cMatch, $cCheck, $cPattern, $cPatternToSplit, $cStringSplit, $cPatterns, $cMatches[1][2] = [[0, 2]]

	$cPatterns = __GetPatterns($cProfile[1]) ; Gets Patterns Array For The Current Profile.
	If @error Then
		Return SetError(1, 1, -1)
	EndIf

	For $A = 1 To $cPatterns[0][0]
		$cMatch = 0
		$cPatternToSplit = StringTrimRight($cPatterns[$A][0], 2)

		If $cPatterns[$A][7] <> "Disabled" Then ; Skip Pattern If It Is Disabled.
			$cPatternToSplit = StringReplace($cPatternToSplit, "; ", ";") ; To Support Rules Also If Separated By A Space After Semicolon.
			$cStringSplit = StringSplit($cPatternToSplit, ";")

			For $B = 1 To $cStringSplit[0]
				$cCheck = ""
				If StringInStr($cStringSplit[$B], "**") Then ; Rule For Folders.
					If $cFileNameExt = "0" Then
						$cCheck = "**"
					EndIf
				Else ; Rule For Files.
					If $cFileNameExt <> "0" Then
						$cCheck = "*"
					EndIf
				EndIf
				If $cCheck <> "" Then
					$cPattern = StringReplace($cStringSplit[$B], $cCheck, "(.*?)") ; (.*?) = Match Any String Of Characters.
					If StringInStr($cPattern, "\") Then ; Rule Formatted As Path.
						; $cPattern = StringReplace($cPattern, "(.*?)", "([^/]*?)") ; [^/] = Match Any Character Except /.
						$cMatch = StringRegExp(StringReplace($cFilePath, "\", "/"), "^(?i)" & StringReplace($cPattern, "\", "/") & "$") ; ^ = Start String; (?i) = Case Insensitive; $ = End String.
					Else ; Rule Formatted As File.
						$cMatch = StringRegExp($cFileName, "^(?i)" & $cPattern & "$") ; ^ = Start String; (?i) = Case Insensitive; $ = End String.
					EndIf
					If $cMatch = 1 Then
						$cMatch = _FilterMatches($cFilePath, $cPatterns[$A][3], $cPatterns[$A][4], $cPatterns[$A][5], $cPatterns[$A][6])
					EndIf
					If $cMatch = 1 Then
						ExitLoop
					EndIf
				EndIf
			Next

			If $cMatch = 1 And $cMatches[0][0] < 16 Then
				If UBound($cMatches, 1) <= $cMatches[0][0] + 1 Then
					ReDim $cMatches[UBound($cMatches, 1) + 1][2] ; ReSize Array If More Items Are Required.
				EndIf
				$cMatches[0][0] += 1
				$cMatches[$cMatches[0][0]][0] = $cPatterns[$A][0]
				$cMatches[$cMatches[0][0]][1] = $cPatterns[$A][1]
			EndIf
		EndIf
	Next

	If $cMatches[0][0] = 1 Then
		$Global_Action = StringRight($cMatches[1][0], 2) ; Set Action For This File/Folder.
		If $Global_Action == "$2" Then ; $2 = Exclude.
			Return SetError(1, 1, -1)
		Else
			Return $cMatches[$cMatches[0][0]][1]
		EndIf
	ElseIf $cMatches[0][0] > 1 Then
		$cMatch = _MoreMatches($cMatches, $cFileName)
		Return $cMatch
	EndIf
	Return SetError(1, 0, 0)
EndFunc   ;==>_CheckingMatches

Func _FilterMatches($dFilePath, $dFilterSize, $dFilterCreated, $dFilterModified, $dFilterOpened)
	Local $dText[3], $dFileDate[6], $dTemp
	Local $dArray[4][2] = [ _
			[$dFilterSize, 0], _
			[$dFilterCreated, 1], _
			[$dFilterModified, 0], _
			[$dFilterOpened, 2]]

	For $A = 0 To 3
		If StringLeft($dArray[$A][0], 1) = "1" Then
			$dText[0] = StringLeft(StringTrimLeft($dArray[$A][0], 1), 1)
			$dText[1] = StringRegExpReplace(StringTrimLeft($dArray[$A][0], 2), "[^0-9]", "")
			$dText[2] = StringTrimLeft($dArray[$A][0], 2 + StringLen($dText[1]))

			If $A = 0 Then ; Size.
				If __IsFolder($dFilePath) Then
					$dTemp = DirGetSize($dFilePath)
				Else
					$dTemp = FileGetSize($dFilePath)
				EndIf
				Switch $dText[2]
					Case "KB"
						$dTemp = Round($dTemp / 1024)
					Case "MB"
						$dTemp = Round($dTemp / (1024 * 1024))
					Case Else ; "GB".
						$dTemp = Round($dTemp / (1024 * 1024 * 1024))
				EndSwitch
			Else ; Date.
				$dFileDate = FileGetTime($dFilePath, $dArray[$A][1])
				$dTemp = _DateDiff($dText[2], $dFileDate[0] & "/" & $dFileDate[1] & "/" & $dFileDate[2] & " " & $dFileDate[3] & ":" & $dFileDate[4] & ":" & $dFileDate[5], _NowCalc())
			EndIf

			If @error = 0 Then
				Switch $dText[0]
					Case ">"
						If Not ($dTemp > $dText[1]) Then
							Return 0
						EndIf
					Case "<"
						If Not ($dTemp < $dText[1]) Then
							Return 0
						EndIf
					Case Else ; "=".
						If Not ($dTemp = $dText[1]) Then
							Return 0
						EndIf
				EndSwitch
			EndIf
		EndIf
	Next

	Return 1
EndFunc   ;==>_FilterMatches

Func _MoreMatches($mMatches, $mFileName)
	Local $mHandle = $Global_GUI_1

	Local $mGUI, $mType, $mDestination, $mMsg, $mCancel, $mButtons[$mMatches[0][0] + 1] = [0], $mRead = -1
	If IsArray($mMatches) = 0 Then
		Return SetError(1, 0, 0) ; Exit Function If Not An Array.
	EndIf
	$mGUI = GUICreate(__Lang_Get('MOREMATCHES_GUI', 'Select Action'), 320, 115 + 23 * $mMatches[0][0], -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	GUICtrlCreateGroup(__Lang_Get('MOREMATCHES_LABEL_0', 'Loaded item:'), 8, 6, 304, 40)
	GUICtrlCreateLabel($mFileName, 20, 24, 280, 20)
	GUICtrlSetTip($mFileName, __Lang_Get('MOREMATCHES_TIP_0', 'This item fits with several patterns.'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__Lang_Get('MOREMATCHES_LABEL_1', 'Select the action to use:'), 8, 52, 304, 24 + 23 * $mMatches[0][0])
	For $A = 1 To $mMatches[0][0]
		$mType = StringRight($mMatches[$A][0], 2)
		$mDestination = $mMatches[$A][1]
		If $mType = "$6" Then
			Switch $mMatches[$A][1] ; Destination.
				Case 2
					$mDestination = __Lang_Get('DELETE_MODE_2', 'Safely Erase')
				Case 3
					$mDestination = __Lang_Get('DELETE_MODE_3', 'Send to Recycle Bin')
				Case Else
					$mDestination = __Lang_Get('DELETE_MODE_1', 'Normally Delete')
			EndSwitch
		EndIf
		$mType = __GetPatternString($mType) & " (" & $mDestination & ")" ; __GetPatternString() = Convert String Type To Action Type.
		$mButtons[$A] = GUICtrlCreateButton(" " & __GetCompactFilePath($mType, 50), 20, 46 + ($A * 23), 280, 22, 0x0100)
		$mButtons[0] += 1
	Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$mCancel = GUICtrlCreateButton("&" & __Lang_Get('CANCEL', 'Cancel'), 160 - 45, 83 + 23 * $mMatches[0][0], 90, 24)
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

	If $mRead = -1 Or $Global_Action == "$2" Then
		Return SetError(1, 1, -1)
	EndIf
	Return $mRead
EndFunc   ;==>_MoreMatches

Func _PositionCheck($pFilePath, $pProfile, ByRef $pFailedList, $pElementsGUI, $pMonitored = 0)
	Local $pSearch, $pFileName, $pFailedFile, $pMultiplePosition = 0, $pWildcards = ""

	If __IsFolder($pFilePath) Then
		If __Is("DirForFolders") = 0 Or $pMonitored Then
			$pMultiplePosition = 1
			$pWildcards = "*.*"
			$pMonitored = 0 ; To Scan Only Main Monitored Folders And Consider Eventual Subfolders As Normal Items.
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
			If @error Then
				ExitLoop
			EndIf
			If __IsFolder($pFilePath & "\" & $pFileName) = 0 Then
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
			If @error Then
				ExitLoop
			EndIf
			If __IsFolder($pFilePath & "\" & $pFileName) Then
				$pFailedList = _PositionCheck($pFilePath & "\" & $pFileName, $pProfile, $pFailedList, $pElementsGUI) ; If Selected Is A Directory Then Process The Directory.
			EndIf
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

	If @error Then
		SetError(1, 1, $pFailedList)
	EndIf
	Return $pFailedList
EndFunc   ;==>_PositionCheck

Func _PositionProcess($pFilePath, $pProfile, $pElementsGUI)
	__ReduceMemory() ; Reduce Memory Usage Of DropIt.
	Local $pINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $pCompressionFormat = __7ZipCurrentFormat()

	Local $pFileName, $pFileNameExt = 0, $pIsDirectory = 0, $pSortFailed = 0, $pMsgBox = 1, $pDestinationDirectory
	Local $pAssociate, $A, $pFileNameWoExt, $pSyntaxDir, $pCurrentSize

	If StringRight($pFilePath, 1) = "\" Then
		$pFilePath = StringTrimRight($pFilePath, 1) ; Delete Eventual "\" At The End Of The String.
	EndIf
	If __IsFolder($pFilePath) Then
		$pIsDirectory = 1
	EndIf
	If $pIsDirectory Then
		$pCurrentSize = DirGetSize($pFilePath)
		__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_0', 'Folder Loaded'), $pFilePath)
	Else
		$pFileNameExt = __GetFileNameExExt($pFilePath, 1) ; Returns E.G. ini
		$pCurrentSize = FileGetSize($pFilePath)
		__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_1', 'File Loaded'), $pFilePath)
	EndIf
	$pFileName = __GetFileName($pFilePath) ; Returns E.G. Example.ini

	; Check If The Pattern Matches:
	$pDestinationDirectory = _CheckingMatches($pFileName, $pFileNameExt, $pFilePath, $pProfile) ; Destination If OK, 0 To Associate, -1 To Skip.
	If $pDestinationDirectory == 0 Then
		If __Is("IgnoreNew", $pINI) Then
			__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_2', 'Not Sorted'), __Lang_Get('POSITIONPROCESS_LOGMSG_0', 'Skipped'))
			$Global_SortingCurrentSize += $pCurrentSize
			GUICtrlSetData($pElementsGUI[2], Round($Global_SortingCurrentSize / $Global_SortingTotalSize * 100)) ; Force Update Progress Bar.
			Return 1 ; Skip The Function By Returning 1.
		Else
			$pMsgBox = MsgBox(0x04, __Lang_Get('POSITIONPROCESS_MSGBOX_0', 'Association Needed'), __Lang_Get('POSITIONPROCESS_MSGBOX_1', 'No association found for:') & @LF & $pFilePath & @LF & @LF & __Lang_Get('POSITIONPROCESS_MSGBOX_2', 'Do you want to create an association for it?'), 0, __OnTop())
			If $pMsgBox = 6 Then
				$pAssociate = _Manage_Edit_GUI($pProfile, $pFileName, $pFileNameExt, -1, -1, -1, 1, 1) ; Show Manage Edit GUI Of Selected Pattern.
				If $pAssociate <> 0 Then
					$pDestinationDirectory = _CheckingMatches($pFileName, $pFileNameExt, $pFilePath, $pProfile) ; Destination If OK, 0 To Associate, -1 To Skip.
				EndIf
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

	; Set Destination For Rename Action:
	If $Global_Action == "$7" Then
		If $pIsDirectory Then
			$pDestinationDirectory = StringReplace($pDestinationDirectory, ".%FileExt%", "") ; Remove File Extension Environment Variable.
			$pDestinationDirectory = StringReplace($pDestinationDirectory, "%FileExt%", "") ; Remove File Extension Environment Variable.
			$pDestinationDirectory = StringReplace($pDestinationDirectory, "%FileName%", "%FileNameExt%") ; To Correctly Load Name.
		ElseIf StringInStr($pDestinationDirectory, ".") = 0 Then
			$pDestinationDirectory &= ".%FileExt%" ; Add File Extension If Not Defined.
		EndIf
	EndIf

	; Internal Environment Variables:
	If StringInStr($pDestinationDirectory, "%") Then
		Local $pLoadedProperty
		Local $pEnvArray[18][3] = [ _
				[17, 0, 0], _
				["FileExt", 3, __GetFileNameExExt($pFilePath, 1)], _
				["FileName", 3, StringTrimRight(__GetFileName($pFilePath), StringLen(__GetFileNameExExt($pFilePath, 1)) + 1)], _
				["FileNameExt", 3, __GetFileName($pFilePath)], _
				["ParentDir", 3, StringTrimRight(__GetParentFolder($pFilePath), 1)], _
				["FileSubDir", 3, StringTrimLeft(StringTrimRight(__GetParentFolder($pFilePath), 1), StringLen($Global_MainDir))], _
				["DateOpened", 2, 2], _
				["DateCreated", 2, 1], _
				["DateModified", 2, 0], _
				["DateTaken", 1, 9], _
				["FileAuthor", 0, 12], _
				["FileType", 0, 2], _
				["SongAlbum", 0, 15], _
				["SongArtist", 0, 13], _
				["SongGenre", 0, 16], _
				["SongNumber", 0, 18], _
				["SongTitle", 0, 14], _
				["SongYear", 0, 17]]

		For $A = 1 To $pEnvArray[0][0]
			If StringInStr($pDestinationDirectory, "%" & $pEnvArray[$A][0] & "%") Then ; Do It Only If Current Env. Var. Is Used.
				Switch $pEnvArray[$A][1]
					Case 0
						$pLoadedProperty = __GetFileProperties($pFilePath, $pEnvArray[$A][2], 1)
					Case 1
						$pLoadedProperty = StringRegExpReplace(__GetFileProperties($pFilePath, $pEnvArray[$A][2], 1), "[^0-9]", "") ; Remove All Non-Digit Characters.
						$pLoadedProperty = StringRegExpReplace($pLoadedProperty, "(\d{2})(\d{2})(\d{4})(\d{2})(\d{2})", "$3-$2-$1") ; Convert To YYYY-MM-DD.
					Case 2
						$pLoadedProperty = FileGetTime($pFilePath, $pEnvArray[$A][2], 1)
						$pLoadedProperty = StringRegExpReplace($pLoadedProperty, "(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})", "$1-$2-$3") ; Convert To YYYY-MM-DD.
					Case 3
						$pLoadedProperty = $pEnvArray[$A][2]
				EndSwitch
				If $pLoadedProperty == "" Then
					$pLoadedProperty = $pEnvArray[$A][0]
				EndIf
				$pDestinationDirectory = StringReplace($pDestinationDirectory, "%" & $pEnvArray[$A][0] & "%", $pLoadedProperty)
			EndIf
		Next
	EndIf

	; Update Destination For Rename Action:
	If $Global_Action == "$7" Then
		$pFileName = $pDestinationDirectory
		$pDestinationDirectory = StringTrimRight(__GetParentFolder($pFilePath), 1)
	EndIf

	; Destination Folder Creation:
	If $Global_Action <> "$5" And $Global_Action <> "$6" And FileExists($pDestinationDirectory) = 0 Then
		Local $pIsDirectoryCreated = DirCreate($pDestinationDirectory)
		If $pIsDirectoryCreated = 0 Then
			MsgBox(0x40, __Lang_Get('POSITIONPROCESS_MSGBOX_3', 'Destination Folder Problem'), __Lang_Get('POSITIONPROCESS_MSGBOX_4', 'Sorting operation has been partially skipped.  @LF  The following destination folder does not exist and cannot be created:') & @LF & __GetCompactFilePath($pDestinationDirectory, 65), 0, __OnTop())
			__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_2', 'Not Sorted'), __Lang_Get('POSITIONPROCESS_LOGMSG_2', 'Failed'))
			$Global_SortingCurrentSize += $pCurrentSize
			GUICtrlSetData($pElementsGUI[2], Round($Global_SortingCurrentSize / $Global_SortingTotalSize * 100)) ; Force Update Progress Bar.
			Return SetError(1, 1, 1) ; Exits If @error Occured With Creating Directory.
		EndIf
	EndIf

	; Update File Name:
	$pFileNameWoExt = $pFileName
	If $Global_Action == "$3" Then ; Compress Action.
		If __Is("ArchiveSelf") And $pCompressionFormat == "7z" Then
			$pCompressionFormat = "exe"
		EndIf
		If $pIsDirectory = 0 Then
			$pFileName = StringTrimRight($pFileName, StringLen($pFileNameExt) + 1) ; Remove Original Extension If Needed.
		EndIf
		$pFileNameWoExt = $pFileName & "." & $pCompressionFormat
		$pIsDirectory = 0 ; Needed To Correctly Rename Eventual Duplicates.
	ElseIf $Global_Action == "$4" Then ; Extract Action.
		$pFileNameWoExt = StringTrimRight($pFileName, StringLen($pFileNameExt) + 1) ; Save The Name Of The Extraction Output Folder.
		$pIsDirectory = 1 ; Needed To Correctly Rename Eventual Duplicates.
	EndIf

	; Manage Duplicates:
	If FileExists($pDestinationDirectory & "\" & $pFileNameWoExt) Then
		Local $pDupMode = "Skip"
		If __Is("AutoDup", $pINI) Then
			$pDupMode = IniRead($pINI, "General", "DupMode", "Overwrite")
		Else
			If $Global_DuplicateMode <> "" Then
				$pDupMode = $Global_DuplicateMode
			Else
				$pDupMode = _Duplicate_Alert($pFileNameWoExt)
			EndIf
		EndIf

		Switch $pDupMode
			Case "Rename"
				$pFileNameWoExt = _Duplicate_Rename($pFileNameWoExt, $pDestinationDirectory, $pIsDirectory)

			Case "Skip"
				__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_2', 'Not Sorted'), __Lang_Get('POSITIONPROCESS_LOGMSG_0', 'Skipped'))
				$Global_SortingCurrentSize += $pCurrentSize
				GUICtrlSetData($pElementsGUI[2], Round($Global_SortingCurrentSize / $Global_SortingTotalSize * 100)) ; Force Update Progress Bar.
				Return 1 ; Skip The Function By Returning 1.
		EndSwitch
	EndIf

	__ExpandEventMode(1) ; Enable The Abort Button.
	$pSyntaxDir = $pDestinationDirectory
	If $Global_Action <> "$5" And $Global_Action <> "$6" Then
		$pSyntaxDir &= "\" & $pFileNameWoExt
	EndIf
	_Sorting_Process($pFilePath, $pSyntaxDir, $pElementsGUI)
	If @error Then
		$pSortFailed = 1
	EndIf
	__ExpandEventMode(0) ; Disable The Abort Button.

	If $Global_Action <> "$5" And $Global_Action <> "$6" And FileExists($pSyntaxDir) = 0 Then
		$pSortFailed = 1
	EndIf
	If $Global_Action == "$6" And FileExists($pFilePath) Then
		$pSortFailed = 1
	EndIf

	If $pSortFailed Then
		If $Global_AbortSorting Then
			__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_2', 'Not Sorted'), __Lang_Get('POSITIONPROCESS_LOGMSG_1', 'Aborted'))
			Return SetError(1, 0, 0) ; 0 = Aborted Sorting.
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
			Case "$7"
				$pSyntaxMode = __Lang_Get('POSITIONPROCESS_LOG_9', 'Renamed')
			Case Else
				$pSyntaxMode = __Lang_Get('POSITIONPROCESS_LOG_5', 'Moved')
		EndSwitch
		__Log_Write($pSyntaxMode, $pSyntaxDir)
	EndIf

	Return 1
EndFunc   ;==>_PositionProcess

Func _Duplicate_Alert($dItem)
	Local $dGUI, $dButtonOverwrite, $dButtonRename, $dButtonSkip, $dCheckForAll, $dValue

	$dGUI = GUICreate(__Lang_Get('POSITIONPROCESS_DUPLICATE_0', 'Item Already Exists'), 360, 134, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop())
	GUICtrlCreateLabel(__Lang_Get('POSITIONPROCESS_DUPLICATE_1', 'This item already exists in destination folder:'), 16, 14, 328, 18)
	GUICtrlCreateLabel($dItem, 16, 14 + 18, 328, 40)
	GUICtrlSetFont(-1, -1, 800)

	$dButtonOverwrite = GUICtrlCreateButton("&" & __Lang_Get('OPTIONS_MODE_2', 'Overwrite'), 180 - 65 - 84, 70, 84, 26)
	$dButtonSkip = GUICtrlCreateButton("&" & __Lang_Get('OPTIONS_MODE_3', 'Skip'), 180 - 42, 70, 84, 26)
	$dButtonRename = GUICtrlCreateButton("&" & __Lang_Get('OPTIONS_MODE_4', 'Rename'), 180 + 65, 70, 84, 26)
	GUICtrlSetState($dButtonRename, $GUI_DEFBUTTON)

	$dCheckForAll = GUICtrlCreateCheckbox(__Lang_Get('POSITIONPROCESS_DUPLICATE_2', 'Apply to all items of this drop'), 16, 106, 328, 20)
	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $dButtonSkip
				$dValue = "Skip"
				ExitLoop

			Case $dButtonOverwrite
				$dValue = "Overwrite"
				ExitLoop

			Case $dButtonRename
				$dValue = "Rename"
				ExitLoop

		EndSwitch
	WEnd
	If GUICtrlRead($dCheckForAll) = 1 Then
		$Global_DuplicateMode = $dValue
	EndIf
	GUIDelete($dGUI)

	Return $dValue
EndFunc   ;==>_Duplicate_Alert

Func _Duplicate_Rename($dItem, $dDestinationDirectory, $dIsDirectory)
	Local $dNumber, $dFileNameExt = 0, $A = 1
	Local $dFileName = $dItem

	If $dIsDirectory = 0 Then ; If Is A File.
		$dFileNameExt = __GetFileNameExExt($dFileName, 1) ; Returns E.G. ini
		$dFileName = StringTrimRight($dFileName, StringLen($dFileNameExt) + 1)
	EndIf

	While 1
		If $A < 10 Then
			$dNumber = 0 & $A ; Creates 01, 02, 03, 04, 05 Till 09.
		Else
			$dNumber = $A ; Creates 10, 11, 12, 13, 14, Etc.
		EndIf
		If $dIsDirectory Then ; If Is A Directory.
			$dItem = $dFileName & "_" & $dNumber ; Create Prefix E.G. Test_01
		Else ; If Is A File.
			$dItem = $dFileName & "_" & $dNumber & "." & $dFileNameExt ; Create Prefix E.G. Test_01.ini
		EndIf

		If FileExists($dDestinationDirectory & "\" & $dItem) = 0 Then
			ExitLoop ; Exit Loop If FileName Is Unique.
		EndIf
		$A += 1
	WEnd

	Return $dItem
EndFunc   ;==>_Duplicate_Rename

Func _Sorting_Abort()
	Switch @GUI_CtrlId
		Case $GUI_EVENT_CLOSE, $Global_AbortButton
			$Global_AbortSorting = 1
	EndSwitch
EndFunc   ;==>_Sorting_Abort

Func _Sorting_CreateGUI($sTotalSize)
	Local $sLabel1, $sLabel2, $sProgress_1, $sProgress_2

	$Global_SortingTotalSize = $sTotalSize
	$Global_SortingCurrentSize = 0

	If _Copy_OpenDll() = 0 Then
		Return SetError(1, 0, 0)
	EndIf

	$Global_SortingGUI = GUICreate(__Lang_Get('POSITIONPROCESS_0', 'Sorting'), 400, 142, -1, -1, -1, -1, __OnTop())
	GUISetOnEvent($GUI_EVENT_CLOSE, '_Sorting_Abort')
	$sLabel1 = GUICtrlCreateLabel(__Lang_Get('POSITIONPROCESS_1', 'Loading') & '...', 16, 14, 368, 16)
	$sProgress_1 = GUICtrlCreateProgress(16, 14 + 16, 368, 16)
	$sLabel2 = GUICtrlCreateLabel('', 16, 60, 368, 16)
	$sProgress_2 = GUICtrlCreateProgress(16, 60 + 16, 368, 16)
	$Global_AbortButton = GUICtrlCreateButton(__Lang_Get('POSITIONPROCESS_2', 'Abort'), 200 - 45, 106, 90, 25)
	GUICtrlSetState(-1, $GUI_DEFBUTTON)
	GUICtrlSetOnEvent(-1, '_Sorting_Abort')

	If __Is("ShowSorting") Then
		GUISetState(@SW_SHOW)
	EndIf

	Local $sElementsGUI[4] = [$sLabel1, $sLabel2, $sProgress_1, $sProgress_2] ; Populate Elements GUI.

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return $sElementsGUI
EndFunc   ;==>_Sorting_CreateGUI

Func _Sorting_DeleteGUI()
	GUIDelete($Global_SortingGUI)
	_Copy_CloseDll()

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_Sorting_DeleteGUI

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
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	If __Is("ArchiveSelf") And $sType = 0 Then
		$sDestination = StringTrimRight($sDestination, 4) & ".7z" ; Replace ".exe" With ".7z" If Needed.
	EndIf

	$sArray = __7ZipRun($sSource, $sDestination, $sType, 1, 1) ; $sType = 0 To Compress or $sType = 1 To Extract.
	If @error Or IsArray($sArray) = 0 Then
		Return SetError(1, 0, 0)
	EndIf

	Sleep(50) ; Needed, Otherwise Progress Bar Could Be Not Updated.
	Local $sPercentHandle = __7Zip_OpenPercent($sArray[0]), $sPreviousPercent = -1
	While 1
		$sPercent = __7Zip_ReadPercent($sPercentHandle)
		If $sPercent > 0 And $sPreviousPercent <> $sPercent Then
			GUICtrlSetData($sProgress_2, $sPercent)
			$sPreviousPercent = $sPercent
			$sPercent = Round(($Global_SortingCurrentSize + ($sSize * $sPercent / 100)) / $Global_SortingTotalSize * 100)
			If GUICtrlRead($sProgress_1) <> $sPercent Then
				GUICtrlSetData($sProgress_1, $sPercent)
			EndIf
		Else
			Sleep(50)
		EndIf

		If $Global_AbortSorting Then
			ProcessClose($sArray[0])
			ProcessWaitClose($sArray[0])
			FileDelete($sArray[1])
			Return SetError(1, 0, 0)
		EndIf

		If ProcessExists($sArray[0]) = 0 Then
			__7Zip_ClosePercent($sPercentHandle)
			GUICtrlSetData($sProgress_2, 100)
			ExitLoop
		EndIf
	WEnd

	$Global_SortingCurrentSize += $sSize
	$sPercent = Round($Global_SortingCurrentSize / $Global_SortingTotalSize * 100)
	If GUICtrlRead($sProgress_1) <> $sPercent Then
		GUICtrlSetData($sProgress_1, $sPercent)
	EndIf

	Return 1
EndFunc   ;==>_Sorting_ArchiveFile

Func _Sorting_CopyFile($sSource, $sDestination, $sElementsGUI)
	Local $sPercent, $sState, $sError = -1, $sMD5_Before, $sMD5_After
	Local $sLabel_2 = $sElementsGUI[1], $sProgress_1 = $sElementsGUI[2], $sProgress_2 = $sElementsGUI[3]

	If FileExists($sDestination) Then
		FileSetAttrib($sDestination, '-RH') ; Needed To Overwrite Hidden And Read-Only Files/Folders.
	EndIf
	If __Is("IntegrityCheck") Then
		$sMD5_Before = __MD5ForFile($sSource)
	EndIf

	GUICtrlSetData($sLabel_2, __GetCompactFilePath(__GetFileName($sSource), 68))
	GUICtrlSetData($sProgress_2, 0)
	If @error Then
		Return SetError($sError, 0, 0)
	EndIf
	Do
		If $Global_Action == "$0" Then
			If _Copy_MoveFile($sSource, $sDestination, 0x0003) = 0 Then ; 0x0003 = $MOVE_FILE_COPY_ALLOWED + $MOVE_FILE_REPLACE_EXISTING.
				Return SetError($sError, 0, 0)
			EndIf
		Else
			If _Copy_CopyFile($sSource, $sDestination) = 0 Then
				Return SetError($sError, 0, 0)
			EndIf
		EndIf
		While 1
			If $Global_AbortSorting Then
				_Copy_Abort()
			EndIf
			$sState = _Copy_GetState()
			If $sState[0] Then
				$sPercent = Round($sState[1] / $sState[2] * 100)
				If GUICtrlRead($sProgress_2) <> $sPercent Then
					GUICtrlSetData($sProgress_2, $sPercent)
					$sPercent = Round(($Global_SortingCurrentSize + $sState[1]) / $Global_SortingTotalSize * 100)
					If GUICtrlRead($sProgress_1) <> $sPercent Then
						GUICtrlSetData($sProgress_1, $sPercent)
					EndIf
				Else
					Sleep(50)
				EndIf
			Else
				If $sState[5] = 0 Then
					GUICtrlSetData($sProgress_2, 100)
				Else
					$sError = $sState[5]
					Return SetError($sError, 0, 0)
				EndIf
				ExitLoop 2
			EndIf
		WEnd
		If StringInStr(FileGetAttrib($sSource), 'A') = 0 Then
			FileSetAttrib($sDestination, '-A')
		EndIf
	Until 1
	$Global_SortingCurrentSize += $sState[2]
	$sPercent = Round($Global_SortingCurrentSize / $Global_SortingTotalSize * 100)
	If GUICtrlRead($sProgress_1) <> $sPercent Then
		GUICtrlSetData($sProgress_1, $sPercent)
	EndIf

	If __Is("IntegrityCheck") Then
		$sMD5_After = __MD5ForFile($sDestination)
		If $sMD5_Before <> $sMD5_After Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf

	Return 1
EndFunc   ;==>_Sorting_CopyFile

Func _Sorting_DeleteFile($sSource, $sDeletionMode, $sElementsGUI)
	Local $sPercent, $sSize
	Local $sLabel_2 = $sElementsGUI[1], $sProgress_1 = $sElementsGUI[2], $sProgress_2 = $sElementsGUI[3]

	If __IsReadOnly($sSource) Then
		FileSetAttrib($sSource, '-R') ; Needed To Delete Read-Only Files/Folders.
	EndIf

	GUICtrlSetData($sLabel_2, __GetCompactFilePath(__GetFileName($sSource), 68))
	GUICtrlSetData($sProgress_2, 0)
	If __IsFolder($sSource) Then
		$sSize = DirGetSize($sSource)
		Switch $sDeletionMode
			Case 2
				__SecureFolderDelete($sSource)
			Case 3
				FileRecycle($sSource)
			Case Else
				DirRemove($sSource, 1)
		EndSwitch
	Else
		$sSize = FileGetSize($sSource)
		Switch $sDeletionMode
			Case 2
				__SecureFileDelete($sSource)
			Case 3
				FileRecycle($sSource)
			Case Else
				FileDelete($sSource)
		EndSwitch
	EndIf
	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	GUICtrlSetData($sProgress_2, 100)
	$Global_SortingCurrentSize += $sSize
	$sPercent = Round($Global_SortingCurrentSize / $Global_SortingTotalSize * 100)
	If GUICtrlRead($sProgress_1) <> $sPercent Then
		GUICtrlSetData($sProgress_1, $sPercent)
	EndIf

	Return 1
EndFunc   ;==>_Sorting_DeleteFile

Func _Sorting_OpenFile($sSource, $sDestination, $sElementsGUI)
	Local $sPercent, $sSize, $sError = -1
	Local $sLabel_2 = $sElementsGUI[1], $sProgress_1 = $sElementsGUI[2], $sProgress_2 = $sElementsGUI[3]

	GUICtrlSetData($sLabel_2, __GetCompactFilePath(__GetFileName($sSource), 68))
	GUICtrlSetData($sProgress_2, 0)
	$sSize = FileGetSize($sSource)
	If @error Then
		Return SetError($sError, 0, 0)
	EndIf

	If StringInStr($sDestination, "%") Then
		If StringInStr($sDestination, "%DefaultProgram%") Then
			$sDestination = StringReplace($sDestination, "%DefaultProgram%", "") ; Load Parameters.
			If __Is("WaitOpened") Then
				ShellExecuteWait($sSource, $sDestination)
			Else
				ShellExecute($sSource, $sDestination)
			EndIf
		Else
			$sDestination = StringReplace($sDestination, "%File%", '"' & $sSource & '"')
			$sDestination = StringReplace($sDestination, '""', '"') ; Fix Double Quotes If Needed.
			If __Is("WaitOpened") Then
				RunWait($sDestination, @ScriptDir)
			Else
				Run($sDestination, @ScriptDir)
			EndIf
		EndIf
	Else
		If __Is("WaitOpened") Then
			RunWait($sDestination & ' "' & $sSource & '"', @ScriptDir)
		Else
			Run($sDestination & ' "' & $sSource & '"', @ScriptDir)
		EndIf
	EndIf
	If @error Then
		Return SetError($sError, 0, 0)
	EndIf

	GUICtrlSetData($sProgress_2, 100)
	$Global_SortingCurrentSize += $sSize
	$sPercent = Round($Global_SortingCurrentSize / $Global_SortingTotalSize * 100)
	If GUICtrlRead($sProgress_1) <> $sPercent Then
		GUICtrlSetData($sProgress_1, $sPercent)
	EndIf

	Return 1
EndFunc   ;==>_Sorting_OpenFile

Func _Sorting_RenameFile($sSource, $sNewName, $sElementsGUI)
	Local $sPercent, $sSize
	Local $sLabel_2 = $sElementsGUI[1], $sProgress_1 = $sElementsGUI[2], $sProgress_2 = $sElementsGUI[3]

	If __IsReadOnly($sSource) Then
		FileSetAttrib($sSource, '-R') ; Needed To Rename Read-Only Files/Folders.
	EndIf

	GUICtrlSetData($sLabel_2, __GetCompactFilePath(__GetFileName($sSource), 68))
	GUICtrlSetData($sProgress_2, 0)
	If __IsFolder($sSource) Then
		$sSize = DirGetSize($sSource)
		DirMove($sSource, $sNewName)
	Else
		$sSize = FileGetSize($sSource)
		FileMove($sSource, $sNewName, 1)
	EndIf
	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	GUICtrlSetData($sProgress_2, 100)
	$Global_SortingCurrentSize += $sSize
	$sPercent = Round($Global_SortingCurrentSize / $Global_SortingTotalSize * 100)
	If GUICtrlRead($sProgress_1) <> $sPercent Then
		GUICtrlSetData($sProgress_1, $sPercent)
	EndIf

	Return 1
EndFunc   ;==>_Sorting_RenameFile

Func _Sorting_Process($sSource, $sDestination, $sElementsGUI, $sRoot = '')
	Local $sPath, $sFile, $sSearch, $sError = -1
	Local $sLabel_1 = $sElementsGUI[0]

	If $Global_AbortSorting Then
		SetError($sError, 0, 0) ; Needed To Do Not Start A New Operation If Sorting Is Aborted.
	EndIf

	Switch $Global_Action
		Case "$3" ; Compress Action.
			GUICtrlSetData($sLabel_1, __GetCompactFilePath(StringTrimRight(__GetParentFolder($sDestination), 1), 68))
			_Sorting_ArchiveFile($sSource, $sDestination, $sElementsGUI, 0)
			If @error = 0 Then
				Return 1
			EndIf

		Case "$4" ; Extract Action.
			GUICtrlSetData($sLabel_1, __GetCompactFilePath(StringTrimRight(__GetParentFolder($sDestination), 1), 68))
			_Sorting_ArchiveFile($sSource, $sDestination, $sElementsGUI, 1)
			If @error = 0 Then
				Return 1
			EndIf

		Case "$5" ; Open With Action.
			GUICtrlSetData($sLabel_1, __GetCompactFilePath($sDestination, 68))
			_Sorting_OpenFile($sSource, $sDestination, $sElementsGUI)
			If @error = 0 Then
				Return 1
			EndIf

		Case "$6" ; Delete Action.
			GUICtrlSetData($sLabel_1, __GetCompactFilePath($sSource, 68))
			_Sorting_DeleteFile($sSource, $sDestination, $sElementsGUI)
			If @error = 0 Then
				Return 1
			EndIf

		Case "$7" ; Rename Action.
			GUICtrlSetData($sLabel_1, __GetCompactFilePath($sSource, 68))
			_Sorting_RenameFile($sSource, $sDestination, $sElementsGUI)
			If @error = 0 Then
				Return 1
			EndIf

		Case Else ; Move Or Copy Action.
			If __IsFolder($sSource) Then
				If FileExists($sDestination) = 0 Then
					If DirCreate($sDestination) = 0 Then
						Return SetError($sError, 0, 0)
					EndIf
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
						If $Global_Action == "$0" And DirGetSize($sSource & $sRoot) = 0 Then ; Move Action And Source Folder Is Empty.
							DirRemove($sSource & $sRoot)
						EndIf
						Return 1
					EndIf
					$sPath = $sRoot & '\' & $sFile
					If @extended Then
						GUICtrlSetData($sLabel_1, __GetCompactFilePath($sDestination & $sPath, 68))
						If FileExists($sDestination & $sPath) = 0 Then
							If DirCreate($sDestination & $sPath) = 0 Then
								ExitLoop
							EndIf
							FileSetAttrib($sDestination & $sPath, '+' & StringReplace(FileGetAttrib($sSource & $sPath), 'D', ''))
						EndIf
						If _Sorting_Process($sSource, $sDestination, $sElementsGUI, $sPath) = 0 Then
							$sError = @error
							ExitLoop
						EndIf
					Else
						If _Sorting_CopyFile($sSource & $sPath, $sDestination & $sPath, $sElementsGUI) = 0 Then
							$sError = @error
							ExitLoop
						EndIf
					EndIf
				WEnd
				FileClose($sSearch)
			Else
				GUICtrlSetData($sLabel_1, __GetCompactFilePath(StringTrimRight(__GetParentFolder($sDestination), 1), 68))
				_Sorting_CopyFile($sSource, $sDestination, $sElementsGUI)
				If @error = 0 Then
					Return 1
				EndIf
			EndIf
	EndSwitch

	Return SetError($sError, 0, 0)
EndFunc   ;==>_Sorting_Process
#Region End >>>>> Processing Functions <<<<<

#Region Start >>>>> Main Functions <<<<<
Func _Main()
	Local $mINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $mProfileList, $mMsg, $mMonitored, $mLoadedFolder[1], $mTime_Diff
	Local $mTime_Now = TimerInit()

	$Global_Timer = IniRead($mINI, "General", "MonitoringTime", "60")

	__InstalledCheck() ; Check To See If DropIt Is Installed.
	__IsProfile() ; Checks If A Default Profile Is Available.
	_Main_Create() ; Refresh The Main GUI & TrayMenu, Including Translation Strings & ContextMenu.

	GUIRegisterMsg(0x004A, "WM_COPYDATA")
	GUIRegisterMsg(0x0233, "WM_DROPFILES_UNICODE")
	GUIRegisterMsg(0x0112, "WM_SYSCOMMAND")

	__Log_Write(@LF & __Lang_Get('DROPIT_STARTED', 'DropIt Started'), __Lang_Get('DATE', 'Date') & " " & @MDAY & "-" & @MON & "-" & @YEAR)

	While 1
		__ReduceMemory() ; Reduce Memory Usage Of DropIt.
		Sleep(15) ; Needed To Limit CPU Usage.

		; Scheduled Folder Scanning:
		If __Is("Monitoring") Then
			$mTime_Diff = TimerDiff($mTime_Now)
			If $mTime_Diff > ($Global_Timer * 1000) Then
				$mMonitored = __IniReadSection($mINI, "MonitoredFolders") ; Gets Patterns Array For The Current Profile.
				If @error = 0 Then
					For $A = 1 To $mMonitored[0][0]
						$mLoadedFolder[0] = $mMonitored[$A][0]
						If $Global_GUI_State = 1 Then ; GUI Is Visible.
							GUISetState(@SW_SHOW, $Global_GUI_2) ; Show Small Working Icon.
						EndIf
						_DropEvent($mLoadedFolder, $mMonitored[$A][1], 1)
						GUISetState(@SW_HIDE, $Global_GUI_2) ; Hide Small Working Icon.
					Next
				EndIf
				$mTime_Now = TimerInit()
			EndIf
		EndIf

		$mMsg = GUIGetMsg()
		Switch $mMsg
			Case $GUI_EVENT_CLOSE, $Global_ContextMenu[9][0] ; Exit DropIt If An Exit Event Is Called.
				ExitLoop

			Case $GUI_EVENT_DROPPED
				If $Global_GUI_State = 1 Then ; GUI Is Visible.
					GUISetState(@SW_SHOW, $Global_GUI_2) ; Show Small Working Icon.
				EndIf
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
				If FileExists(@ScriptDir & "\Help.chm") Then
					ShellExecute(@ScriptDir & "\Help.chm")
				EndIf

			Case $Global_ContextMenu[11][0]
				If FileExists(@ScriptDir & "\Readme.txt") Then
					ShellExecute(@ScriptDir & "\Readme.txt")
				EndIf

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

	$rGUI_1 = GUICreate("DropIt", $rProfile[5], $rProfile[6] + 100, $rPosition[0], $rPosition[1], $WS_POPUP, BitOR($WS_EX_ACCEPTFILES, $WS_EX_LAYERED, $WS_EX_TOOLWINDOW))
	$Global_GUI_1 = $rGUI_1
	__IsOnTop() ; Set GUI "OnTop" If True.
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
	_ResourceSetImageToCtrl($rLabelIconImage, "PROG")

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
	If __Is("CustomTrayIcon") Then
		__Tray_SetIcon(__IsProfile(-1, 2))
	EndIf
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

	$cContextMenu[10][0] = GUICtrlCreateMenuItem(__Lang_Get('HELP', 'Help'), $cContextMenu[7][0], 0)
	$cContextMenu[10][1] = 'HELP'
	$cContextMenu[11][0] = GUICtrlCreateMenuItem(__Lang_Get('README', 'Readme'), $cContextMenu[7][0], 1)
	$cContextMenu[11][1] = 'README'
	$cContextMenu[12][0] = GUICtrlCreateMenuItem(__Lang_Get('ABOUT', 'About') & "...", $cContextMenu[7][0], 2)
	$cContextMenu[12][1] = 'ABOUT'

	$cContextMenu[13][0] = GUICtrlCreateMenuItem(__Lang_Get('CUSTOMIZE', 'Customize'), $cContextMenu[4][0], 0)
	$cContextMenu[14][0] = GUICtrlCreateMenuItem("", $cContextMenu[4][0], 1)

	__SetItemImage("PAT", 0, $cContextMenu[1][0], 0, 1)
	__SetItemImage("PROF", 2, $cContextMenu[1][0], 0, 1)
	__SetItemImage("OPT", 3, $cContextMenu[1][0], 0, 1)
	__SetItemImage("HIDE", 4, $cContextMenu[1][0], 0, 1)
	__SetItemImage("HELP", 5, $cContextMenu[1][0], 0, 1)
	__SetItemImage("CLOSE", 7, $cContextMenu[1][0], 0, 1)
	__SetItemImage("HELPF", 0, $cContextMenu[7][0], 0, 1)
	__SetItemImage("READ", 1, $cContextMenu[7][0], 0, 1)
	__SetItemImage("ABOUT", 2, $cContextMenu[7][0], 0, 1)
	__SetItemImage("CUST", 0, $cContextMenu[4][0], 0, 1)

	Local $B = $cContextMenu[0][0] + 1
	For $A = 1 To $cProfileList[0]
		If UBound($cContextMenu, 1) <= $cContextMenu[0][0] + 1 Then
			ReDim $cContextMenu[UBound($cContextMenu, 1) * 2][$cContextMenu[0][1]] ; ReDim's $cContextMenu If More Items Are Required.
		EndIf
		$cContextMenu[$B][0] = GUICtrlCreateMenuItem($cProfileList[$A], $cContextMenu[4][0], $A + 1, 1)
		__SetItemImage(__IsProfile($cProfileList[$A], 2), $A + 1, $cContextMenu[4][0], 0, 0, 20, 20)
		$cContextMenu[$B][1] = $cProfileList[$A]
		If $cProfileList[$A] = __GetCurrentProfile() Then
			GUICtrlSetState($cContextMenu[$B][0], 1) ; __GetCurrentProfile = Get Current Profile From The Settings INI File.
		EndIf
		$cContextMenu[0][0] += 1
		$B += 1
	Next

	ReDim $cContextMenu[$cContextMenu[0][0] + 1][$cContextMenu[0][1]] ; Delete Empty Rows.
	$Global_ContextMenu = $cContextMenu

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_ContextMenu_Create

Func _ContextMenu_Delete($cHandle)
	Local $cGUI_1 = $Global_GUI_1
	Local $cControlGetPos = ControlGetPos($cGUI_1, "", $cHandle)

	If @error Then
		Local $cControlGetPos[2] = [0, 0, 64, 64]
	EndIf
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
	Local $aClose, $aGUI, $aIcon_GUI, $aIcon_Label, $aLicense, $aUpdate, $aUpdateProgress, $aUpdateText

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
	If FileExists(@ScriptDir & "\License.txt") = 0 Then
		GUICtrlSetState($aLicense, $GUI_HIDE)
	EndIf
	$aClose = GUICtrlCreateButton("&" & __Lang_Get('CLOSE', 'Close'), 325, 120, 65, 25)
	GUICtrlSetState($aClose, $GUI_DEFBUTTON)

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

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
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
				If __IsFolder($uArray[$A][0]) Then
					$uCmd = " /I /S /Y"
				EndIf
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
	If $uHandle = -1 Then
		Return SetError(1, 0, 0)
	EndIf

	Local $uMsgBox, $uDownload, $uVersion, $uPage, $uCancelled = 0, $uBefore = ">DropIt Installer ", $uAfter = "<"
	Local $uSize, $uPercent, $uDownloaded, $uText, $uDownloadURL, $uDownloadFile, $uTimerBegin, $uPackage = "Portable.zip"

	HttpSetProxy(0) ; Load System Proxy Settings.
	$uPage = BinaryToString(InetRead(_WinAPI_ExpandEnvironmentStrings("%URL%"), 17)) ; Load Web Page.

	If @error Then
		MsgBox(0x30, __Lang_Get('UPDATE_MSGBOX_2', 'Check Failed'), __Lang_Get('UPDATE_MSGBOX_3', 'An error occurs during check for updates.'), 10, __OnTop())
		Return SetError(1, 0, 0)
	EndIf

	; Extract Last Version Available From Web Page:
	$uBefore = StringInStr($uPage, $uBefore) + StringLen($uBefore)
	$uAfter = StringInStr(StringTrimLeft($uPage, $uBefore), $uAfter)
	$uVersion = StringStripWS(StringMid($uPage, $uBefore, $uAfter), 3)

	If @error Or $uVersion == "" Then
		GUICtrlSetData($uHandle, __Lang_Get('UPDATE_MSGBOX_3', 'An error occurs during check for updates.'))
		Return SetError(1, 0, 0)
	EndIf

	If $uVersion == $Global_CurrentVersion Then ; Check If Current And Online Versions Are The Same Or Not.
		GUICtrlSetData($uHandle, __Lang_Get('UPDATE_MSGBOX_4', 'You have the latest release available.'))
	Else
		; Extract Download URL From Web Page:
		$uBefore = '<!--<update>'
		$uAfter = '</update>-->'
		$uBefore = StringInStr($uPage, $uBefore) + StringLen($uBefore)
		$uAfter = StringInStr(StringTrimLeft($uPage, $uBefore), $uAfter)
		$uDownloadURL = StringStripWS(StringMid($uPage, $uBefore, $uAfter), 3)

		$uMsgBox = MsgBox(0x04, __Lang_Get('UPDATE_MSGBOX_5', 'Update Available!'), StringReplace(__Lang_Get('UPDATE_MSGBOX_6', 'New version %NewVersion% of DropIt is available.  @LF  Do you want to update it now?'), '%NewVersion%', $uVersion), 0, __OnTop())
		If $uMsgBox <> 6 Then
			Return SetError(1, 0, 0)
		EndIf
		Local $uCancelRead = GUICtrlRead($uCancel)
		GUICtrlSetData($uCancel, "&" & __Lang_Get('CANCEL', 'Cancel'))
		$uDownloadFile = @ScriptDir & "\" & "DropIt_v" & StringReplace($uVersion, " ", "_") & "_" & $uPackage

		$uTimerBegin = TimerInit() ; Start Timer To Check How Long It Takes To Download.
		GUICtrlSetData($uHandle, "Calculating size for v" & $uVersion)
		$uSize = InetGetSize($uDownloadURL, 1) ; Get Download Size.
		$uDownload = InetGet($uDownloadURL, $uDownloadFile, 17, 1) ; Start Download.
		While InetGetInfo($uDownload, 2) = 0 ; Whilst Complete Is False.
			$uPercent = InetGetInfo($uDownload, 0) * 100 / $uSize ; Percentage Of Downloaded File.
			$uDownloaded = InetGetInfo($uDownload, 0) ; Bytes Downloaded So Far.
			$uText = Round($uPercent, 0) & "% Downloading " & __ByteSuffix($uDownloaded) & " of " & __ByteSuffix($uSize) ; Create A Text String.
			__SetProgress($aProgress, $uPercent, 3)
			If GUICtrlRead($uHandle) <> $uText Then
				GUICtrlSetData($uHandle, $uText)
			EndIf
			GUICtrlSetData($uHandle, $uText)

			If InetGetInfo($uDownload, 4) <> 0 Then
				InetClose($uDownload)
				FileDelete($uDownloadFile)
				GUICtrlSetData($uHandle, __Lang_Get('UPDATE_MSGBOX_7', 'An error occured during software download.'))
				Return SetError(1, 0, 0)
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
			If FileExists($uDownloadFile) Then
				FileDelete($uDownloadFile)
			EndIf
			Return SetError(1, 0, 0)
		EndIf

		__7ZipRun($uDownloadFile, __GetDefault(1) & "ZIP", 1, 0) ; __GetDefault(1) = Get The Default Settings Directory.
		If FileExists($uDownloadFile) Then
			FileDelete($uDownloadFile)
		EndIf
		_Update_Batch(@ScriptDir & "\" & "ZIP" & "\" & "DropIt_v" & StringReplace($uVersion, " ", "_") & "_" & StringTrimRight($uPackage, 4) & "\")
		IniWrite(__IsSettingsFile(), "General", "Update", "True")
		Run(@ScriptDir & "\" & "DropIt_Update.bat", @ScriptDir, @SW_HIDE)
		Exit
	EndIf

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_Update_Check

Func _Monitored_Edit_GUI($mHandle, $mINI, $mListView, $mIndex = -1, $mFolder = -1)
	Local $mGUI, $mInput_Folder, $mButton_Folder, $mCombo_Profile, $mSave, $mCancel
	Local $mProfile = __IsProfile(-1, 0) ; Get Array Of Current Profile.

	If $mIndex <> -1 Then
		$mProfile[1] = _GUICtrlListView_GetItemText($mListView, $mIndex, 1)
	EndIf
	If $mFolder = -1 Then
		$mFolder = ""
	EndIf

	$mGUI = GUICreate(__Lang_Get('MONITORED_FOLDER', 'Monitored Folder'), 300, 125, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	$mInput_Folder = GUICtrlCreateInput($mFolder, 10, 15 + 2, 240, 22)
	GUICtrlSetTip($mInput_Folder, __Lang_Get('MONITORED_FOLDER_TIP_0', 'Select the folder that will be monitored.'))
	$mButton_Folder = GUICtrlCreateButton("S", 10 + 244, 15, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Folder, __Lang_Get('SEARCH', 'Search'))
	GUICtrlSetImage($mButton_Folder, @ScriptFullPath, -8, 0)
	$mCombo_Profile = GUICtrlCreateCombo("", 10, 15 + 35, 280, 22, 0x0003)
	GUICtrlSetTip($mCombo_Profile, __Lang_Get('MONITORED_FOLDER_TIP_1', 'Select the group of patterns to use on this folder.'))
	GUICtrlSetData($mCombo_Profile, __ProfileList_Combo(), $mProfile[1])

	$mSave = GUICtrlCreateButton("&" & __Lang_Get('SAVE', 'Save'), 150 - 20 - 75, 90, 75, 24)
	$mCancel = GUICtrlCreateButton("&" & __Lang_Get('CANCEL', 'Cancel'), 150 + 20, 90, 75, 24)
	GUICtrlSetState($mCancel, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)

	While 1
		__ReduceMemory() ; Reduce Memory Usage Of DropIt.

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
				$mFolder = GUICtrlRead($mInput_Folder)
				If __IsFolder($mFolder) = 0 Or FileExists($mFolder) = 0 Then
					MsgBox(0x30, __Lang_Get('MONITORED_FOLDER_MSGBOX_0', 'Folder Error'), __Lang_Get('MONITORED_FOLDER_MSGBOX_1', 'You must specify a valid directory.'), 0, __OnTop($mGUI))
					ContinueLoop
				EndIf
				IniWrite($mINI, "MonitoredFolders", $mFolder, GUICtrlRead($mCombo_Profile))
				ExitLoop

			Case $mButton_Folder
				$mFolder = FileSelectFolder(__Lang_Get('MONITORED_FOLDER_MSGBOX_2', 'Select a monitored folder:'), "", 3, "", $mGUI)
				If StringRight($mFolder, 1) = "\" Then
					$mFolder = StringTrimRight($mFolder, 1)
				EndIf
				If __Is("ConvertPath") Then
					Local $mRelative = _PathGetRelative(@ScriptDir, $mFolder)
					$mFolder = $mRelative
				EndIf
				If $mFolder <> "" Then
					GUICtrlSetData($mInput_Folder, $mFolder)
				EndIf

		EndSwitch
	WEnd
	GUIDelete($mGUI)

	Return 1
EndFunc   ;==>_Monitored_Edit_GUI

Func _Monitored_Update($mListView, $mINI)
	Local $mMonitored = __IniReadSection($mINI, "MonitoredFolders") ; Gets Patterns Array For The Current Profile.
	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	_GUICtrlListView_BeginUpdate($mListView)
	_GUICtrlListView_DeleteAllItems($mListView)
	For $A = 1 To $mMonitored[0][0]
		_GUICtrlListView_AddItem($mListView, $mMonitored[$A][0])
		_GUICtrlListView_AddSubItem($mListView, $A - 1, $mMonitored[$A][1], 1)
	Next

	Local $B_DESCENDING[_GUICtrlListView_GetColumnCount($mListView)]
	_GUICtrlListView_SimpleSort($mListView, $B_DESCENDING, 0)
	_GUICtrlListView_SetItemSelected($mListView, 0, False, False)
	_GUICtrlListView_EndUpdate($mListView)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_Monitored_Update

Func _Options($oHandle = -1)
	Local $oINI = __IsSettingsFile() ; Get Default Settings INI File.

	Local $oCheckItems[20] = [19], $oRadioItems[6] = [5], $oComboItems[5] = [4], $oGroup[5] = [4], $oCurrent[5] = [4]
	Local $oINI_TrueOrFalse_Array[20][3] = [ _
			[19, 3], _
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
			["General", "SizeMessage", 1], _
			["General", "ConvertPath", 1], _
			["General", "WaitOpened", 1], _
			["General", "Monitoring", 1]]
	Local $oINI_Various_Array[10][3] = [ _
			[9, 3], _
			["General", "SendToMode", 2], _
			["General", "DupMode", 3], _
			["General", "ArchiveFormat", 2], _
			["General", "ArchiveLevel", 5], _
			["General", "ArchiveMethod", 4], _
			["General", "ArchiveEncryptMethod", 2], _
			["General", "ArchivePassword", 1], _
			["General", "MasterPassword", 1], _
			["General", "MonitoringTime", 1]]

	Local $oPW, $oPW_Code = $Global_Password_Key
	Local $oBackupDirectory = __GetDefault(32) ; Get Default Backup Directory.
	Local $oLogFile = __GetDefault(513) ; Get Default Directory & LogFile File Name.
	Local $oGUI, $oOK, $oCancel, $oMsg, $oMsgBox, $oLanguage, $oLanguageCombo, $oImageList, $oLog, $oWriteLog, $oState, $oTab_1, $oCreateTab
	Local $oPassword, $oShowPassword, $oMasterPassword, $oShowMasterPassword, $oBk_Backup, $oBk_Restore, $oBk_Remove
	Local $oListView, $oListView_Handle, $oIndex_Selected, $oFolder_Selected, $oMn_Add, $oMn_Edit, $oMn_Remove, $oScanTime

	$oGUI = GUICreate(__Lang_Get('OPTIONS', 'Options'), 320, 330, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($oHandle))

	$oCreateTab = GUICtrlCreateTab(4, 3, 313, 290) ; Create Tab Menu.

	; Main Tab:
	$oTab_1 = GUICtrlCreateTabItem(__Lang_Get('OPTIONS_TAB_0', 'Main'))
	GUICtrlSetState(-1, $GUI_SHOW) ; Show This Tab At Options Opening.

	; Group Of General Options:
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_0', 'General'), 10, 30, 299, 85)
	$oCheckItems[1] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_0', 'Show target image always on top'), 25, 30 + 15)
	$oCheckItems[2] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_7', 'Lock target image position'), 25, 30 + 15 + 20)
	$oCheckItems[13] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_13', 'Use profile icon in traybar'), 25, 30 + 15 + 40)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Group Of Usage Options:
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_3', 'Usage'), 10, 120, 299, 105)
	$oCheckItems[3] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_8', 'Enable multiple instances'), 25, 120 + 15)
	$oCheckItems[14] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_14', 'Start DropIt on system startup'), 25, 120 + 15 + 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_3', 'Note that this is a not portable feature.'))
	$oCheckItems[4] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_6', 'Integrate DropIt in SendTo menu'), 25, 120 + 15 + 40)
	$oRadioItems[1] = GUICtrlCreateRadio(__Lang_Get('OPTIONS_MODE_5', 'Permanent'), 25 + 25, 120 + 15 + 40 + 22, 95, 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_0', 'The integration remains also when DropIt is closed.'))
	$oRadioItems[2] = GUICtrlCreateRadio(__Lang_Get('OPTIONS_MODE_6', 'Portable'), 25 + 156, 120 + 15 + 40 + 22, 95, 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_1', 'The integration is created at DropIt startup and removed at the end.'))
	GUICtrlCreateGroup('', -99, -99, 1, 1)

	; Group Of Language Options:
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_1', 'Language'), 10, 230, 299, 50)
	$oLanguageCombo = _GUICtrlComboBoxEx_Create($oGUI, "", 25, 230 + 15 + 3, 270, 260, 0x0003)
	$oImageList = _GUIImageList_Create(16, 16, 5, 3) ; Creates An ImageList.
	_GUICtrlComboBoxEx_SetImageList($oLanguageCombo, $oImageList)
	$Global_ImageList = $oImageList
	__Lang_Combo($oLanguageCombo)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Sorting Tab:
	GUICtrlCreateTabItem(__Lang_Get('OPTIONS_TAB_1', 'Sorting'))

	; Group Of Association Options:
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_0', 'General'), 10, 30, 299, 105)
	$oCheckItems[11] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_11', 'Show progress bar during process'), 25, 30 + 15)
	$oCheckItems[6] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_2', 'Enable association also for folders'), 25, 30 + 15 + 20)
	$oCheckItems[16] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_16', 'Enable alert for large processed files'), 25, 30 + 15 + 40)
	$oCheckItems[7] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_3', 'Ignore unassociated files/folders'), 25, 30 + 15 + 60)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Group Of Duplicates Options:
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_5', 'Manage Duplicates'), 10, 140, 299, 65)
	$oCheckItems[8] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_5', 'Use automatic choice for duplicates'), 25, 140 + 15)
	$oRadioItems[3] = GUICtrlCreateRadio(__Lang_Get('OPTIONS_MODE_2', 'Overwrite'), 25, 140 + 15 + 22, 90, 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_MODE_2', 'Overwrite'))
	$oRadioItems[4] = GUICtrlCreateRadio(__Lang_Get('OPTIONS_MODE_3', 'Skip'), 25 + 97, 140 + 15 + 22, 85, 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_MODE_3', 'Skip'))
	$oRadioItems[5] = GUICtrlCreateRadio(__Lang_Get('OPTIONS_MODE_4', 'Rename'), 25 + 189, 140 + 15 + 22, 85, 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_MODE_4', 'Rename'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Group Of Log Options:
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_7', 'Sorting Log'), 10, 210, 299, 50)
	$oCheckItems[5] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_1', 'Create sorting log file'), 25, 210 + 15 + 3)
	$oLog = GUICtrlCreateButton(__Lang_Get('OPTIONS_BUTTON_0', 'Read'), 25 + 190, 210 + 15 + 2, 80, 22)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Monitoring Tab:
	GUICtrlCreateTabItem(__Lang_Get('OPTIONS_TAB_4', 'Monitoring'))

	; Group Of Association Options:
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_0', 'General'), 10, 30, 299, 250)
	$oCheckItems[19] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_19', 'Temporized scan'), 25, 30 + 15 + 2, 205, 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_10', 'Schedule a temporized scan of defined folders.'))
	$oScanTime = GUICtrlCreateInput("", 25 + 210, 30 + 15, 60, 20, 0x2000)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_9', 'Time interval in seconds.'))
	$oListView = GUICtrlCreateListView(__Lang_Get('MONITORED_FOLDER', 'Monitored Folder') & "|" & __Lang_Get('ASSOCIATED_PROFILE', 'Associated Profile'), 20, 30 + 15 + 30, 280, 165, BitOR($LVS_NOSORTHEADER, $LVS_REPORT, $LVS_SINGLESEL))
	$oMn_Add = GUICtrlCreateButton(__Lang_Get('OPTIONS_BUTTON_4', 'Add'), 25, 230 + 15 + 3, 80, 22)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_BUTTON_4', 'Add'))
	$oMn_Edit = GUICtrlCreateButton(__Lang_Get('OPTIONS_BUTTON_5', 'Edit'), 25 + 96, 230 + 15 + 3, 80, 22)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_BUTTON_5', 'Edit'))
	$oMn_Remove = GUICtrlCreateButton(__Lang_Get('OPTIONS_BUTTON_3', 'Remove'), 25 + 191, 230 + 15 + 3, 80, 22)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_BUTTON_3', 'Remove'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Compression Tab:
	GUICtrlCreateTabItem(__Lang_Get('OPTIONS_TAB_2', 'Compression'))

	; Group Of Settings Options:
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_8', 'Modality'), 10, 30, 299, 135)
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_10', 'Format') & ":", 25, 30 + 15 + 6, 90, 20)
	$oComboItems[1] = GUICtrlCreateCombo("", 25 + 100, 30 + 15 + 3, 170, 20, 0x0003)
	GUICtrlSetData(-1, "", "")
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_11', 'Level') & ":", 25, 30 + 15 + 30 + 6, 90, 20)
	$oComboItems[2] = GUICtrlCreateCombo("", 25 + 100, 30 + 15 + 30 + 3, 170, 20, 0x0003)
	GUICtrlSetData(-1, "", "")
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_12', 'Method') & ":", 25, 30 + 15 + 60 + 6, 90, 20)
	$oComboItems[3] = GUICtrlCreateCombo("", 25 + 100, 30 + 15 + 60 + 3, 170, 20, 0x0003)
	GUICtrlSetData(-1, "", "")
	$oCheckItems[9] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_9', 'Create self-extracting archives'), 25, 30 + 15 + 90)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Group Of Extra Options:
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_9', 'Encryption'), 10, 170, 299, 110)
	$oCheckItems[10] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_10', 'Encrypt compressed files/folders'), 25, 170 + 15 + 3)
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_13', 'Password') & ":", 25, 170 + 15 + 30 + 3, 90, 20)
	$oPassword = GUICtrlCreateInput("", 25 + 100, 170 + 15 + 30, 158, 20, 0x0020)
	$oShowPassword = GUICtrlCreateButton("", 25 + 100 + 158, 170 + 15 + 30, 12, 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_2', 'Show/Hide the password.'))
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_12', 'Method') & ":", 25, 170 + 15 + 60 + 3, 90, 20)
	$oComboItems[4] = GUICtrlCreateCombo("", 25 + 100, 170 + 15 + 60, 170, 20, 0x0003)
	GUICtrlSetData(-1, "", "")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Various Tab:
	GUICtrlCreateTabItem(__Lang_Get('OPTIONS_TAB_3', 'Various'))

	; Group Of General Options:
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_0', 'General'), 10, 30, 299, 85)
	$oCheckItems[17] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_17', 'Convert to relative path if possible'), 25, 30 + 15)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_7', 'Convert destination folder to relative path at pattern editing.'))
	$oCheckItems[15] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_4', 'Check processed files integrity'), 25, 30 + 15 + 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_4', 'The activation of MD5 checking slows down sorting processes.'))
	$oCheckItems[18] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_18', 'Wait closing of opened files'), 25, 30 + 15 + 40)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_8', 'Pause sorting process at each "Open With" action.'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_14', 'Security'), 10, 120, 299, 75)
	$oCheckItems[12] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_12', 'Encrypt profiles at software closing'), 25, 120 + 15)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_6', 'Password will be requested at software startup.'))
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_13', 'Password') & ":", 25, 120 + 15 + 30, 90, 20)
	$oMasterPassword = GUICtrlCreateInput("", 25 + 100, 120 + 15 + 27, 158, 20, 0x0020)
	$oShowMasterPassword = GUICtrlCreateButton("", 25 + 100 + 158, 120 + 15 + 27, 12, 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_2', 'Show/Hide the password.'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Group Of Backup Options:
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_2', 'Settings Backup'), 10, 200, 299, 50)
	$oBk_Backup = GUICtrlCreateButton(__Lang_Get('OPTIONS_BUTTON_1', 'Backup'), 25, 200 + 15 + 3, 80, 22)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_BUTTON_1', 'Backup'))
	$oBk_Restore = GUICtrlCreateButton(__Lang_Get('OPTIONS_BUTTON_2', 'Restore'), 25 + 95, 200 + 15 + 3, 80, 22)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_BUTTON_2', 'Restore'))
	$oBk_Remove = GUICtrlCreateButton(__Lang_Get('OPTIONS_BUTTON_3', 'Remove'), 25 + 190, 200 + 15 + 3, 80, 22)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_BUTTON_3', 'Remove'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateTabItem("") ; Close Tab Menu.

	; Checkbox Settings:
	For $A = 1 To $oINI_TrueOrFalse_Array[0][0]
		If $oINI_TrueOrFalse_Array[$A][0] = "" Or $oINI_TrueOrFalse_Array[$A][1] = "" Then
			ContinueLoop
		EndIf
		If __Is($oINI_TrueOrFalse_Array[$A][1], $oINI) Then
			GUICtrlSetState($oCheckItems[$A], $GUI_CHECKED)
		EndIf
	Next

	; Combo Settings:
	$oGroup[1] = "7Z|ZIP"
	$oCurrent[1] = IniRead($oINI, "General", "ArchiveFormat", "ZIP")
	$oGroup[2] = "Fastest|Fast|Normal|Maximum|Ultra"
	$oCurrent[2] = IniRead($oINI, "General", "ArchiveLevel", "Normal")
	$oGroup[3] = "LZMA|LZMA2|PPMd|BZip2"
	If $oCurrent[1] = "ZIP" Then
		$oGroup[3] = "Deflate|LZMA|PPMd|BZip2"
	EndIf
	$oCurrent[3] = IniRead($oINI, "General", "ArchiveMethod", "LZMA")
	$oGroup[4] = "AES-256"
	If $oCurrent[1] = "ZIP" Then
		$oGroup[4] = "ZipCrypto|AES-256"
	EndIf
	$oCurrent[4] = IniRead($oINI, "General", "ArchiveEncryptMethod", "AES-256")
	For $A = 1 To 4
		GUICtrlSetData($oComboItems[$A], $oGroup[$A], $oCurrent[$A])
	Next

	; Integration Settings:
	$oState = $GUI_DISABLE
	If GUICtrlRead($oCheckItems[4]) = 1 Then
		$oState = $GUI_ENABLE
	EndIf
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

	; Backup Settings:
	For $A = $oBk_Backup To $oBk_Restore ; Disable Buttons If 7-Zip Is Missing.
		If FileExists(@ScriptDir & "\Lib\7z\7z.exe") = 0 Then
			GUICtrlSetState($A, $GUI_DISABLE)
		EndIf
	Next
	If FileExists(__GetDefault(32)) = 0 Then
		GUICtrlSetState($oBk_Remove, $GUI_DISABLE) ; __GetDefault(32) = Get Default Backup Directory.
	EndIf

	; Duplicate Mode Settings:
	$oState = $GUI_DISABLE
	If GUICtrlRead($oCheckItems[8]) = 1 Then
		$oState = $GUI_ENABLE
	EndIf
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

	; Log Settings:
	If GUICtrlRead($oCheckItems[5]) = 1 Then
		GUICtrlSetState($oLog, $GUI_ENABLE)
	Else
		GUICtrlSetState($oLog, $GUI_DISABLE)
	EndIf

	; Self-Extracting Settings:
	If GUICtrlRead($oComboItems[1]) = "ZIP" Then
		GUICtrlSetState($oCheckItems[9], $GUI_DISABLE)
	EndIf

	; Encryption Settings:
	$oState = $GUI_DISABLE
	If GUICtrlRead($oCheckItems[10]) = 1 Then $oState = $GUI_ENABLE
	GUICtrlSetState($oPassword, $oState)
	GUICtrlSetState($oShowPassword, $oState)
	GUICtrlSetState($oComboItems[4], $oState)
	$oPW = IniRead($oINI, "General", "ArchivePassword", "")
	If $oPW <> "" Then
		GUICtrlSetData($oPassword, _StringEncrypt(0, $oPW, $oPW_Code))
	EndIf

	; Security Settings:
	$oState = $GUI_DISABLE
	If GUICtrlRead($oCheckItems[12]) = 1 Then
		$oState = $GUI_ENABLE
	EndIf
	GUICtrlSetState($oMasterPassword, $oState)
	GUICtrlSetState($oShowMasterPassword, $oState)
	$oPW = IniRead($oINI, "General", "MasterPassword", "")
	If $oPW <> "" Then
		GUICtrlSetData($oMasterPassword, _StringEncrypt(0, $oPW, $oPW_Code))
	EndIf

	; Monitoring Settings:
	$oState = $GUI_DISABLE
	If GUICtrlRead($oCheckItems[19]) = 1 Then
		$oState = $GUI_ENABLE
	EndIf
	GUICtrlSetState($oScanTime, $oState)
	GUICtrlSetState($oListView, $oState)
	GUICtrlSetState($oMn_Add, $oState)
	GUICtrlSetState($oMn_Edit, $oState)
	GUICtrlSetState($oMn_Remove, $oState)
	$oState = IniRead($oINI, "General", "MonitoringTime", "")
	If $oState <> "" Then
		GUICtrlSetData($oScanTime, $oState)
	EndIf

	; ListView Settings:
	$oListView_Handle = GUICtrlGetHandle($oListView)
	_GUICtrlListView_SetExtendedListViewStyle($oListView_Handle, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_INFOTIP))
	_GUICtrlListView_SetColumnWidth($oListView_Handle, 0, 140)
	_GUICtrlListView_SetColumnWidth($oListView_Handle, 1, 120)
	Local $oToolTip = _GUICtrlListView_GetToolTips($oListView_Handle)
	If IsHWnd($oToolTip) Then
		__OnTop($oToolTip, 1)
		_GUIToolTip_SetDelayTime($oToolTip, 3, 60) ; Speeds Up InfoTip Appearance.
	EndIf
	_Monitored_Update($oListView_Handle, $oINI)

	$oOK = GUICtrlCreateButton("&" & __Lang_Get('OK', 'OK'), 160 - 20 - 80, 298, 80, 25)
	$oCancel = GUICtrlCreateButton("&" & __Lang_Get('CANCEL', 'Cancel'), 160 + 20, 298, 80, 25)
	GUICtrlSetState($oOK, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)

	While 1
		__ReduceMemory() ; Reduce Memory Usage Of DropIt.

		; Update Combo If Format Changes:
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
			If StringInStr($oGroup[3], $oCurrent[3]) = 0 Then
				$oCurrent[3] = "LZMA"
			EndIf
			$oCurrent[4] = GUICtrlRead($oComboItems[4])
			If StringInStr($oGroup[4], $oCurrent[4]) = 0 Then
				$oCurrent[4] = "AES-256"
			EndIf
			For $A = 3 To 4
				_GUICtrlComboBox_ResetContent($oComboItems[$A])
				GUICtrlSetData($oComboItems[$A], $oGroup[$A], $oCurrent[$A])
			Next
		EndIf

		$oMsg = GUIGetMsg()
		Switch $oMsg
			Case $GUI_EVENT_CLOSE, $oCancel
				SetError(1, 0, 0)
				ExitLoop

			Case $oCreateTab ; Hide Combo When Switching Tabs.
				ControlHide($oLanguageCombo, "", "")
				Switch GUICtrlRead($oCreateTab, 1)
					Case $oTab_1
						ControlShow($oLanguageCombo, "", "")
				EndSwitch

			Case $oCheckItems[4] ; Integration Checkbox.
				$oState = $GUI_DISABLE
				If GUICtrlRead($oCheckItems[4]) = 1 Then
					$oState = $GUI_ENABLE
				EndIf
				For $A = 1 To 2
					GUICtrlSetState($oRadioItems[$A], $oState)
				Next

			Case $oCheckItems[5] ; Log Checkbox.
				$oState = $GUI_DISABLE
				If GUICtrlRead($oCheckItems[5]) = 1 Then
					$oState = $GUI_ENABLE
				EndIf
				GUICtrlSetState($oLog, $oState)

			Case $oCheckItems[8] ; Duplicate Mode Checkbox.
				$oState = $GUI_DISABLE
				If GUICtrlRead($oCheckItems[8]) = 1 Then
					$oState = $GUI_ENABLE
				EndIf
				For $A = 3 To 5
					GUICtrlSetState($oRadioItems[$A], $oState)
				Next

			Case $oCheckItems[10] ; Encryption Checkbox.
				$oState = $GUI_DISABLE
				If GUICtrlRead($oCheckItems[10]) = 1 Then
					$oState = $GUI_ENABLE
				EndIf
				GUICtrlSetState($oPassword, $oState)
				GUICtrlSetState($oShowPassword, $oState)
				GUICtrlSetState($oComboItems[4], $oState)

			Case $oCheckItems[12] ; Security Checkbox.
				$oState = $GUI_DISABLE
				If GUICtrlRead($oCheckItems[12]) = 1 Then
					$oState = $GUI_ENABLE
				EndIf
				GUICtrlSetState($oMasterPassword, $oState)
				GUICtrlSetState($oShowMasterPassword, $oState)

			Case $oCheckItems[19] ; Monitoring Checkbox.
				$oState = $GUI_DISABLE
				If GUICtrlRead($oCheckItems[19]) = 1 Then
					$oState = $GUI_ENABLE
				EndIf
				GUICtrlSetState($oScanTime, $oState)
				GUICtrlSetState($oListView, $oState)
				GUICtrlSetState($oMn_Add, $oState)
				GUICtrlSetState($oMn_Edit, $oState)
				GUICtrlSetState($oMn_Remove, $oState)

			Case $oLog
				If FileExists($oLogFile[1][0] & $oLogFile[2][0]) Then
					ShellExecute($oLogFile[1][0] & $oLogFile[2][0])
				Else
					GUICtrlSetState($oCheckItems[5], 4)
					GUICtrlSetState($oLog, $GUI_DISABLE)
				EndIf

			Case $oMn_Add
				_Monitored_Edit_GUI($oGUI, $oINI, $oListView_Handle, -1, -1)
				_Monitored_Update($oListView_Handle, $oINI)

			Case $oMn_Edit, $oMn_Remove
				$oIndex_Selected = _GUICtrlListView_GetSelectionMark($oListView_Handle)
				If Not _GUICtrlListView_GetItemState($oListView_Handle, $oIndex_Selected, $LVIS_SELECTED) Or $oIndex_Selected = -1 Then
					ContinueLoop
				EndIf
				$oFolder_Selected = _GUICtrlListView_GetItemText($oListView_Handle, $oIndex_Selected)

				If $oMsg = $oMn_Remove Then
					IniDelete($oINI, "MonitoredFolders", $oFolder_Selected)
					_GUICtrlListView_DeleteItem($oListView_Handle, $oIndex_Selected)
				Else
					_Monitored_Edit_GUI($oGUI, $oINI, $oListView_Handle, $oIndex_Selected, $oFolder_Selected)
					_Monitored_Update($oListView_Handle, $oINI)
				EndIf

			Case $oBk_Backup
				__Backup_Restore($oGUI, 0) ; Backup The Settings INI File & Profiles.
				If @error = 0 Then
					GUICtrlSetState($oBk_Remove, $GUI_ENABLE)
				EndIf

			Case $oBk_Restore
				__Backup_Restore($oGUI, 1) ; Restore A Selected Backup File.
				If @error = 0 Then
					ExitLoop
				EndIf

			Case $oBk_Remove
				__Backup_Restore($oGUI, 2) ; Remove Backups In The Default Backup Folder.
				If FileExists($oBackupDirectory) = 0 Then
					GUICtrlSetState($oBk_Remove, $GUI_DISABLE)
				EndIf

			Case $oShowPassword
				__ShowPassword($oPassword)

			Case $oShowMasterPassword
				__ShowPassword($oMasterPassword)

			Case $oOK
				_GUICtrlComboBoxEx_GetItemText($oLanguageCombo, _GUICtrlComboBoxEx_GetCurSel($oLanguageCombo), $oLanguage)
				__SetCurrentLanguage($oLanguage) ; Sets The Selected Language To The Settings INI File.

				If __Is("UseSendTo", $oINI) And GUICtrlRead($oCheckItems[4]) <> 1 Then
					__SendTo_Uninstall() ; Delete SendTo Shortcuts If SendTo Is Been Disabled Now.
				EndIf

				If __Is("CreateLog", $oINI) And GUICtrlRead($oCheckItems[5]) <> 1 Then
					__Log_Write(__Lang_Get('LOG_DISABLED', 'Log Disabled'), __Lang_Get('DATE', 'Date') & " " & @MDAY & "-" & @MON & "-" & @YEAR)
				EndIf
				If __Is("CreateLog", $oINI) = 0 And GUICtrlRead($oCheckItems[5]) = 1 Then
					$oWriteLog = 1 ; Needed To Write "Log Enabled" After Log Activation.
				EndIf

				If _GUICtrlListView_GetItemCount($oListView_Handle) = 0 Then
					GUICtrlSetState($oCheckItems[19], $GUI_UNCHECKED) ; Disable Monitoring If ListView Is Empty.
				EndIf

				For $A = 1 To $oINI_TrueOrFalse_Array[0][0]
					$oState = "False"
					If $oINI_TrueOrFalse_Array[$A][0] = "" Or $oINI_TrueOrFalse_Array[$A][1] = "" Then
						ContinueLoop
					EndIf
					If GUICtrlRead($oCheckItems[$A]) = 1 Then
						$oState = "True"
					EndIf
					IniWrite($oINI, $oINI_TrueOrFalse_Array[$A][0], $oINI_TrueOrFalse_Array[$A][1], $oState)
				Next

				If $oWriteLog = 1 Then
					__Log_Write(__Lang_Get('LOG_ENABLED', 'Log Enabled'), __Lang_Get('DATE', 'Date') & " " & @MDAY & "-" & @MON & "-" & @YEAR)
				EndIf

				If GUICtrlRead($oCheckItems[14]) = 1 Then
					__StartupFolder_Install("DropIt")
				Else
					__StartupFolder_Uninstall("DropIt")
				EndIf

				$oState = "Permanent"
				If GUICtrlRead($oRadioItems[2]) = 1 Then
					$oState = "Portable"
				EndIf
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

				$Global_Timer = GUICtrlRead($oScanTime)
				IniWrite($oINI, $oINI_Various_Array[9][0], $oINI_Various_Array[9][1], $Global_Timer)

				$oPW = ""
				If StringIsSpace(GUICtrlRead($oPassword)) = 0 And GUICtrlRead($oPassword) <> "" Then
					$oPW = _StringEncrypt(1, GUICtrlRead($oPassword), $oPW_Code)
				EndIf
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
				If StringIsSpace(GUICtrlRead($oMasterPassword)) = 0 And GUICtrlRead($oMasterPassword) <> "" Then
					$oPW = _StringEncrypt(1, GUICtrlRead($oMasterPassword), $oPW_Code)
				EndIf
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

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_Options

Func _ExitEvent()
	Local $eGUI_1 = $Global_GUI_1
	GUISetState(@SW_HIDE, $eGUI_1)

	Local $eINI = __IsSettingsFile() ; Get Default Settings INI File.

	__SetCurrentPosition() ; Set Current Coordinates/Position Of DropIt.
	If $Global_MultipleInstance Then
		__SetMultipleInstances("-")
	EndIf
	__Log_Write(__Lang_Get('DROPIT_CLOSED', 'DropIt Closed'), __Lang_Get('DATE', 'Date') & " " & @MDAY & "-" & @MON & "-" & @YEAR)

	If __CheckMultipleInstances() = 0 Then ; Checks The Number Of Multiple Instances.
		If __Is("UseSendTo", $eINI) And IniRead($eINI, "General", "SendToMode", "Portable") = "Portable" Then
			__SendTo_Uninstall() ; Delete SendTo Shortcuts If In Portable Mode.
		EndIf
		If __Is("ProfileEncryption", $eINI) Then
			__EncryptionFolder(0) ; Encrypt Profiles.
		EndIf
	EndIf
	_GDIPlus_Shutdown()
	Exit
EndFunc   ;==>_ExitEvent
#Region End >>>>> Main Functions <<<<<

#Region Start >>>>> TrayMenu Functions <<<<<
Func _TrayMenu_Create()
	Local $tTrayMenu = _TrayMenu_Delete() ; Delete The Current TrayMenu Items.
	Local $tProfileList = __ProfileList() ; Get Array Of All Profiles.

	$tTrayMenu[1][0] = TrayCreateItem(__Lang_Get('PATTERNS', 'Patterns'), -1, 0)
	$tTrayMenu[2][0] = TrayCreateItem("", -1, 1)
	$tTrayMenu[3][0] = TrayCreateMenu(__Lang_Get('PROFILES', 'Profiles'), -1, 2)
	$tTrayMenu[4][0] = TrayCreateItem(__Lang_Get('OPTIONS', 'Options'), -1, 3)
	$tTrayMenu[5][0] = TrayCreateItem(__Lang_Get('SHOW', 'Show'), -1, 4)
	$tTrayMenu[6][0] = TrayCreateMenu(__Lang_Get('HELP', 'Help'), -1, 5)
	$tTrayMenu[7][0] = TrayCreateItem("", -1, 6)
	$tTrayMenu[8][0] = TrayCreateItem(__Lang_Get('EXIT', 'Exit'), -1, 7)

	$tTrayMenu[9][0] = TrayCreateItem(__Lang_Get('HELP', 'Help'), $tTrayMenu[6][0], 0)
	$tTrayMenu[9][1] = 'HELP'
	$tTrayMenu[10][0] = TrayCreateItem(__Lang_Get('README', 'Readme'), $tTrayMenu[6][0], 1)
	$tTrayMenu[10][1] = 'README'
	$tTrayMenu[11][0] = TrayCreateItem(__Lang_Get('ABOUT', 'About') & "...", $tTrayMenu[6][0], 2)
	$tTrayMenu[11][1] = 'ABOUT'

	$tTrayMenu[12][0] = TrayCreateItem(__Lang_Get('CUSTOMIZE', 'Customize'), $tTrayMenu[3][0], 0)
	$tTrayMenu[13][0] = TrayCreateItem("", $tTrayMenu[3][0], 1)

	Local $tMenuHandle = TrayItemGetHandle(0) ; Get Main Menu Handle.
	__SetItemImage("PAT", 0, $tMenuHandle, 2, 1)
	__SetItemImage("PROF", 2, $tMenuHandle, 2, 1)
	__SetItemImage("OPT", 3, $tMenuHandle, 2, 1)
	__SetItemImage("SHOW", 4, $tMenuHandle, 2, 1)
	__SetItemImage("HELP", 5, $tMenuHandle, 2, 1)
	__SetItemImage("CLOSE", 7, $tMenuHandle, 2, 1)
	__SetItemImage("HELPF", 0, $tTrayMenu[6][0], 1, 1)
	__SetItemImage("READ", 1, $tTrayMenu[6][0], 1, 1)
	__SetItemImage("ABOUT", 2, $tTrayMenu[6][0], 1, 1)
	__SetItemImage("CUST", 0, $tTrayMenu[3][0], 1, 1)

	Local $B = $tTrayMenu[0][0] + 1
	For $A = 1 To $tProfileList[0]
		If UBound($tTrayMenu, 1) <= $tTrayMenu[0][0] + 1 Then
			ReDim $tTrayMenu[UBound($tTrayMenu, 1) * 2][$tTrayMenu[0][1]] ; ReDim's $tTrayMenu If More Items Are Required.
		EndIf
		$tTrayMenu[$B][0] = TrayCreateItem($tProfileList[$A], $tTrayMenu[3][0], $A + 1, 1)
		__SetItemImage(__IsProfile($tProfileList[$A], 2), $A + 1, $tTrayMenu[3][0], 1, 0, 20, 20)
		$tTrayMenu[$B][1] = $tProfileList[$A]
		TrayItemSetOnEvent($tTrayMenu[$B][0], "_ProfileEvent")
		If $tProfileList[$A] = __GetCurrentProfile() Then
			TrayItemSetState($tTrayMenu[$B][0], 1) ; __GetCurrentProfile = Get Current Profile From The Settings INI File.
		EndIf
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

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
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

	If _WinAPI_GetFocus() <> $sIcon_1 Then
		Return SetError(1, 0, 0) ; Required Because HotKeys Automatically Minimise The GUI.
	EndIf
	GUISetState(@SW_HIDE, $sGUI_1)
	$Global_GUI_State = 0
	TraySetState(1)
	TraySetClick(8)
	TraySetToolTip($sToolTip)
	If __Is("CustomTrayIcon") Then
		__Tray_SetIcon(__IsProfile(-1, 2))
	EndIf

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_TrayMenu_Show

Func _TrayMenu_ShowGUI()
	Local $sGUI_1 = $Global_GUI_1
	Local $sIcon_1 = GUICtrlGetHandle($Global_Icon_1)

	If _WinAPI_GetFocus() = $sIcon_1 Then
		Return SetError(1, 0, 0) ; Required Because HotKeys Automatically Minimise The GUI.
	EndIf
	GUISetState(@SW_SHOW, $sGUI_1)
	$Global_GUI_State = 1
	TraySetState(2)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_TrayMenu_ShowGUI

Func _CustomizeEvent()
	_Customize_GUI($Global_GUI_1) ; Open Customize GUI.
	_Refresh()

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_CustomizeEvent

Func _HelpEvent()
	Local $hTrayMenu = $Global_TrayMenu
	Switch @TRAY_ID
		Case $hTrayMenu[9][0]
			If FileExists(@ScriptDir & "\Help.chm") Then
				ShellExecute(@ScriptDir & "\Help.chm")
			EndIf

		Case $hTrayMenu[10][0]
			If FileExists(@ScriptDir & "\Readme.txt") Then
				ShellExecute(@ScriptDir & "\Readme.txt")
			EndIf

		Case $hTrayMenu[11][0]
			_About()

	EndSwitch

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_HelpEvent

Func _ManageEvent()
	_Manage_GUI() ; Open Manage GUI.
	_Refresh()

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_ManageEvent

Func _OptionsEvent()
	_Options() ; Open Options GUI.
	_Refresh()

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
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

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_ProfileEvent
#Region End >>>>> TrayMenu Functions <<<<<

#Region Start >>>>> WM_MESSAGES Functions <<<<<
Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg
	Local $cWndFrom, $cIDFrom, $cCode, $cListViewRules_ComboBox = $Global_ListViewRules_ComboBox
	If IsHWnd($cListViewRules_ComboBox) = 0 Then
		$cListViewRules_ComboBox = GUICtrlGetHandle($cListViewRules_ComboBox)
	EndIf
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
		If @error Or $wm_Return[0] = -1 Then
			Return SetError(1, 0, 0)
		EndIf
		If StringLen($sString) > 0 Then
			Exit
		EndIf
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

Func WM_GETMINMAXINFO($hWnd, $iMsg, $iwParam, $ilParam) ; It Enables The GUI From Being Dragged To A Certain Size.
	#forceref $hWnd, $iMsg, $iwParam
	Local $gStructure = DllStructCreate("int;int;int;int;int;int;int;int;int;int", $ilParam)
	DllStructSetData($gStructure, 7, $Global_ResizeWidth) ; Min Width.
	DllStructSetData($gStructure, 8, $Global_ResizeHeight) ; Min Height.
	DllStructSetData($gStructure, 9, @DesktopWidth) ; Max Width.
	DllStructSetData($gStructure, 10, @DesktopHeight) ; Max Height.
	Return 0
EndFunc   ;==>WM_GETMINMAXINFO

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

	If IsHWnd($nListViewProfiles) = 0 Then
		$nListViewProfiles = GUICtrlGetHandle($nListViewProfiles)
	EndIf
	If IsHWnd($nListViewRules) = 0 Then
		$nListViewRules = GUICtrlGetHandle($nListViewRules)
	EndIf

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
					$Global_ListViewIndex = $nIndex

				Case $NM_DBLCLK
					If $nIndex <> -1 And $nSubItem <> -1 Then
						$Global_ListViewIndex = $nIndex
						GUICtrlSendToDummy($Global_ListViewProfiles_Enter)
					EndIf

				Case $NM_RCLICK
					_GUICtrlListView_ContextMenu_Customize($nListViewProfiles, $nIndex, $nSubItem) ; Show Customize GUI RightClick Menu.
					$Global_ListViewIndex = $nIndex

			EndSwitch

		Case $nListViewRules
			Switch $nCode
				Case $NM_CLICK
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

				Case $LVN_ITEMCHANGED
					If $Global_ListViewRules_ComboBoxChange = 0 Then
						Local $tNMLISTVIEW = DllStructCreate($tagNMLISTVIEW, $ilParam)
						If BitAND(DllStructGetData($tNMLISTVIEW, "Changed"), $LVIF_STATE) = $LVIF_STATE Then
							Switch DllStructGetData($tNMLISTVIEW, "NewState")
								Case 8192 ; Item Checked.
									$Global_ListViewRules_ItemChange = $nIndex
								Case 4096 ; Item Unchecked.
									$Global_ListViewRules_ItemChange = $nIndex
							EndSwitch
						EndIf
					EndIf

			EndSwitch
	EndSwitch
	Return "GUI_RUNDEFMSG"
EndFunc   ;==>WM_NOTIFY

Func WM_SYSCOMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $ilParam
	If __Is("LockPosition") And $hWnd = $Global_GUI_1 And (_IsPressed(10) And _IsPressed(01)) = 0 Then
		If BitAND($iwParam, 0x0000FFF0) = $SC_MOVE Then
			Return 0
		EndIf
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
	Local $cCommands[8][3] = [ _
			[7, 3], _
			["-t", $c7ZipFormat, "ArchiveFormat"], _ ; Add Flag = 1
			["-mm=", "Deflate", "ArchiveMethod"], _ ; Add Flag = 2
			["-mx", "5", "ArchiveLevel"], _ ; Add Flag = 4
			["-mem=", "AES256", "ArchiveEncryptMethod"], _ ; Add Flag = 8
			["-p", "", "ArchivePassword"], _ ; Add Flag = 16
			["-scc", "UTF-8", -1], _ ; Add Flag = 32
			["-ss", "w", -1]] ; Add Flag = 64

	Local $c7Zip_Value, $cCommand, $cDecrypt, $cHex, $cINI_Value, $cNewCommands[3], $cPassword_Code = $Global_Password_Key
	Local $cINI = __IsSettingsFile() ; Get Default Settings INI File.
	If $cFlag = -1 Then
		$cFlag = 1 + 2 + 4 + 8 + 16 + 32 + 64 ; Default With Encryption (If Enabled).
	EndIf
	For $A = 2 To 5
		$cCommands[$A][1] = IniRead($cINI, "General", $cCommands[$A][2], $cCommands[$A][1])
	Next

	$cDecrypt = _StringEncrypt(0, $cCommands[5][1], $cPassword_Code)
	If @error Then
		$cDecrypt = ""
	EndIf
	If $cType = 1 Then
		Return "x -p" & $cDecrypt
	EndIf

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
	If $cCommands[1][1] = "7z" Then
		$cCommands[2][0] = "-m0=" ; 7ZIP Doesn't Use -mm but -m0=.
	EndIf

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
		If $cCommands[1][1] = "7z" Then
			$cCommands[4][1] = -1 ; 7ZIP Doesn't Use -mem.
		EndIf
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
			If StringRight($cDestinationFilePath, 1) = "." Then
				$cDestinationFilePath = StringTrimRight($cDestinationFilePath, 1) ; Removes The "."
			EndIf
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
	If FileExists($7Zip) = 0 Or $rSourceFilePath = "" Or $rDestinationFilePath = "" Then
		Return SetError(1, 0, 0)
	EndIf
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
			Return SetError(1, 0, 0)
	EndSwitch

	If $rNotWait = 1 Then
		$rReturnedArray[0] = Run($rCommand, "", @SW_HIDE)
	Else
		RunWait($rCommand, "", @SW_HIDE)
	EndIf

	If $rType = 0 And $rDefault = 1 Then
		If $rNewCommands[2] = "SFX" Then
			$rDestinationFilePath = $rDestinationFilePath & ".exe"
		EndIf
	EndIf
	$rReturnedArray[1] = $rDestinationFilePath

	If @error Then
		Return SetError(1, 1, $rReturnedArray[1])
	EndIf
	If $rNotWait = 1 Then
		Return $rReturnedArray
	EndIf
	If FileExists($rDestinationFilePath) = 0 Then
		Return SetError(1, 0, $rReturnedArray[1])
	EndIf
	Return $rReturnedArray[1]
EndFunc   ;==>__7ZipRun

Func __Backup_Restore($bHandle = -1, $bType = 0, $bZipFile = -1) ; 0 = Backup & 1 = Restore & 2 = Remove.
	#cs
		Description: Backup/Restore The Settings INI File & Profiles.
		Returns: 1
	#ce
	Local $bBackupDirectory = __GetDefault(32) ; Get Default Backup Directory.
	Local $bBackup[3] = [2, __IsSettingsFile(), __GetDefault(2)] ; __GetDefault(2) = Get Default Profiles Directory.

	If FileExists($bBackupDirectory & $bZipFile) Or $bZipFile = -1 Then
		$bZipFile = "DropIt_Backup_" & @YEAR & "-" & @MON & "-" & @MDAY & "_[" & @HOUR & "." & @MIN & "." & @SEC & "].zip"
	EndIf

	Switch $bType
		Case 0
			__7ZipRun($bBackup[1] & '" "' & $bBackup[2], $bBackupDirectory & $bZipFile, 0, 0)
			MsgBox(0, __Lang_Get('OPTIONS_BACKUP_MSGBOX_0', 'Backup created'), __Lang_Get('OPTIONS_BACKUP_MSGBOX_1', 'Successfully created a DropIt Backup.'), 0, __OnTop($bHandle))

		Case 1
			Local $bSettingsDirectory = __GetDefault(1) ; __GetDefault(1) = Get The Default Settings Directory.
			If FileExists($bBackupDirectory) = 0 Or DirGetSize($bBackupDirectory, 2) = 0 Then
				$bBackupDirectory = __GetDefault(1) ; __GetDefault(1) = Get The Default Settings Directory.
			EndIf
			$bZipFile = FileOpenDialog(__Lang_Get('OPTIONS_BACKUP_TIP_0', 'Select a DropIt Backup'), $bBackupDirectory, __Lang_Get('OPTIONS_BACKUP_TIP_1', 'DropIt Backup') & " (*.zip)", 1, "", __OnTop($bHandle))
			If @error Then
				Return SetError(1, 0, 0)
			EndIf

			For $A = 1 To $bBackup[0]
				If FileExists($bBackup[$A]) = 0 Then
					ContinueLoop
				EndIf
				If __IsFolder($bBackup[$A]) Then
					DirRemove($bBackup[$A], 1)
				EndIf
			Next

			__7ZipRun($bZipFile, $bSettingsDirectory, 1, 0)
			Sleep(100)
			MsgBox(0, __Lang_Get('OPTIONS_BACKUP_MSGBOX_2', 'Backup restored'), __Lang_Get('OPTIONS_BACKUP_MSGBOX_3', 'Successfully restored the selected DropIt Backup.'), 0, __OnTop($bHandle))

		Case 2
			If FileExists($bBackupDirectory) = 0 Or DirGetSize($bBackupDirectory, 2) = 0 Then
				$bBackupDirectory = __GetDefault(1) ; __GetDefault(1) = Get The Default Settings Directory.
			EndIf
			$bZipFile = FileOpenDialog(__Lang_Get('OPTIONS_BACKUP_TIP_0', 'Select a DropIt Backup'), $bBackupDirectory, __Lang_Get('OPTIONS_BACKUP_TIP_1', 'DropIt Backup') & " (*.zip)", 1, "", __OnTop($bHandle))
			If @error Then
				Return SetError(1, 0, 0)
			EndIf

			FileDelete($bZipFile)
			If DirGetSize($bBackupDirectory, 2) = 0 Then
				DirRemove($bBackupDirectory, 1) ; Remove Back Directory If Empty.
			EndIf
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
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Local $cRunning = 0
	For $A = 1 To $cMultipleInstancesINI[0][0]
		If $cMultipleInstancesINI[$A][0] = "Running" Then
			ContinueLoop
		EndIf
		$cRunning += 1
		If ProcessExists($cMultipleInstancesINI[$A][1]) = 0 Then
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
		If $cTemp_CmdLine[$cIndex] == "/Uninstall" Then
			__Uninstall()
		EndIf
		If StringLeft($cTemp_CmdLine[$cIndex], 1) = "-" Then
			$cProfile = StringTrimLeft($cTemp_CmdLine[$cIndex], 1)
			If FileExists(__GetDefault(2) & $cProfile & ".ini") Then ; __GetDefault(2) = Get Default Profile Directory.
				$cProfile = __ProfileList_GUI($cProfile)
				If @error Then
					Return SetError(1, 0, 0)
				EndIf
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
				If @error Then
					Return SetError(1, 0, 0)
				EndIf
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
			If @error Then
				Return SetError(1, 0, 0)
			EndIf
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
		Return SetError(1, 0, 0)
	EndIf

	Local $cCount
	Local $cDroppedFiles[$cCmdLine + 1 * 2]
	For $A = $cIndex To $cCmdLine
		$cTemp = $cTemp_CmdLine[$A]
		If UBound($cDroppedFiles, 1) <= $A + 1 Then
			ReDim $cDroppedFiles[UBound($cDroppedFiles, 1) * 2] ; ReDim's $cDroppedFiles If More Items Are Required.
		EndIf
		If StringInStr($cTemp, ":") Then
			$cDroppedFiles[$A - $cMinus] = $cTemp
		Else
			$cDroppedFiles[$A - $cMinus] = _PathFull(@ScriptDir & "..\" & $cTemp) ; It Needs This Additional "..\" To Work Correctly.
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
	If $cString = "" Then
		Return SetError(1, 0, 0)
	EndIf
	$cString = _WinAPI_ExpandEnvironmentStrings($cString)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
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
			If IsArray($cSave) = 0 Then
				Return SetError(1, 0, 0)
			EndIf
			$cReturn = _ArrayToString($cSave, ";")
			IniWrite($cINI, "General", $cColumn, $cReturn)
	EndSwitch
	Return $cReturn
EndFunc   ;==>__Column_Width

Func __EncryptionFolder($fDecrypt = -1) ; $fDecrypt = 0, Encrypt/Decrypt Profiles.
	#cs
		Description: Creates An Encrypted/Decrypted File Of The Profiles Folder. .dat Is The Extension Used For Encryption.
		Returns: Full Path Of Encrypted/Decrypted File [C:\Program Files\DropIt\Profiles.dat]
	#ce
	Local $7Zip = @ScriptDir & "\Lib\7z\7z.exe", $fPassword = $Global_Encryption_Key, $fCommand, $fFolder
	Local $fEncryptionFile = __GetDefault(1) & "Profiles.dat"
	Local $fProfileFolder = __GetDefault(2) ; Get Default Profile Directory.
	If FileExists($7Zip) = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	If FileExists($fEncryptionFile) And $fDecrypt = -1 Then
		$fDecrypt = 1
	EndIf
	Switch $fDecrypt
		Case 0 ; Encrypt.
			$fFolder = $fProfileFolder
			$fCommand = '"' & $7Zip & '" a -m0=LZMA -mx5 -p' & $fPassword & ' -sccUTF-8 -ssw' & ' "' & $fEncryptionFile & '" "' & $fFolder & '"'
			RunWait($fCommand, "", @SW_HIDE)
			Sleep(100)
			If FileExists($fEncryptionFile) Then
				DirRemove($fFolder, 1)
			EndIf

		Case 1 ; Decrypt.
			$fFolder = __GetDefault(1)
			$fCommand = '"' & $7Zip & '" ' & 'x -p' & $fPassword & ' "' & $fEncryptionFile & '" -y -o"' & $fFolder & '"'
			RunWait($fCommand, "", @SW_HIDE)
			Sleep(100)
			If DirGetSize($fProfileFolder) <> 0 Then
				FileDelete($fEncryptionFile)
			EndIf

	EndSwitch
	Return $fEncryptionFile
EndFunc   ;==>__EncryptionFolder

Func __EnvironmentVariables()
	#cs
		Description: Sets The Standard & User Assigned Environment Variables.
		Returns: 1
	#ce
	Local $eEnvironmentArray[8][2] = [ _
			[7, 2], _
			["CurrentDate", @YEAR & "-" & @MON & "-" & @MDAY], _ ; Returns: Current Date YYYY-MM-DD [2011-04-12]
			["CurrentTime", @HOUR & "." & @MIN & "." & @SEC], _ ; Returns: Current Date HH.MM.SS [19.40.32]
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
	If @error Or $eSection[0][0] = 0 Then
		Return 1
	EndIf
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
	If StringRegExp($fPath, '(?i)^[a-z]:([^\Q' & $fPattern & '\E]+)?(\\[^\Q' & $fPattern & '\E\\]+)?(\.[^\Q' & $fPattern & '\E\\\.]+|\\)?$') = 1 Then
		Return 1
	EndIf
	If __WinAPI_PathIsRelative($fPath) = 1 And __StringIsValid($fPath, $fPattern) Then
		Return 1
	EndIf
	Return 0
EndFunc   ;==>__FilePathIsValid

Func __GetCompactFilePath($gFilePath, $gMax = 50) ; Taken From WinAPIEx.au3 By Yashied - http://www.autoitscript.com/forum/index.php?showtopic=98712
	#cs
		Description: Gets The Compact Style Of A File Path.
		Returns: File Name [C:\Program Files\Dro...\FileName.txt]
	#ce
	Local $gData = DllStructCreate("wchar[1024]")
	Local $gReturn = DllCall("shlwapi.dll", "int", "PathCompactPathExW", "ptr", DllStructGetPtr($gData), "wstr", $gFilePath, "uint", $gMax + 1, "dword", 0)
	If (@error) Or (Not $gReturn[0]) Then
		Return SetError(1, 0, $gFilePath)
	EndIf
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
	If FileExists($gLanguageDefault[1][0] & $gINIRead & ".lng") = 0 Then
		$gINIRead = __SetCurrentLanguage() ; Set Language With Default Language.
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
	If $Global_MultipleInstance Then
		$gINISection = $UniqueID
	EndIf
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
	If $Global_MultipleInstance Then
		$gINIRead = IniRead($gINI, $UniqueID, "Profile", $gINIRead)
	EndIf
	Return $gINIRead
EndFunc   ;==>__GetCurrentProfile

Func __GetCurrentSize($gWindow = "")
	#cs
		Description: Gets The Current Size From The Settings INI File.
		Returns: Array[2]
		[0] - Width Size [300]
		[1] - Height Size [200]
	#ce
	Local $gINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $gReturn = StringSplit(IniRead($gINI, "General", $gWindow, "400;200"), ";", 2)

	Return $gReturn
EndFunc   ;==>__GetCurrentSize

Func __GetDefault($gFlag = 1, $gSkipInstallationCheck = 0) ; 0 = Don't Skip Installation Check & 1 = Skip Installation Check.
	Local $gHex
	Local $gScriptDir = @ScriptDir & "\"
	If __IsInstalled() And $gSkipInstallationCheck = 0 Then
		$gScriptDir = @AppDataDir & "\DropIt\" ; __IsInstalled() = Checks If DropIt Is Installed.
	EndIf

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
			[@ScriptDir & "\" & "Lib\img\" & "Progress.png", "Working Image FullPath"], _ ; Add Flag = 256
			["LogFile.log", "Default Log File"], _ ; Add Flag = 512
			[@ScriptDir & "\" & "Languages\", "Language Directory"], _ ; Add Flag = 1024
			["English", "Default Language Name"], _ ; Add Flag = 2048
			[@ScriptDir & "\" & "Languages\" & "English.lng", "Default Language FullPath"], _ ; Add Flag = 4096
			["", ""], _ ; Add Flag = 8192 <= Not Used.
			["", ""], _ ; Add Flag = 16384 <= Not Used.
			["", ""]] ; Add Flag = 32768 <= Not Used.

	Local $gReturnArray[$gInitialArray[0][0] + 1][$gInitialArray[0][1]] = [[0, 2]]
	If FileExists(@ScriptDir & "\" & "Images\") = 0 Then
		DirCreate(@ScriptDir & "\" & "Images\")
	EndIf
	If FileExists($gScriptDir & "Profiles\") = 0 Then
		DirCreate($gScriptDir & "Profiles\")
	EndIf

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
	If $gReturnArray[0][0] = 1 Then
		Return $gReturnArray[1][0]
	EndIf
	Return $gReturnArray
EndFunc   ;==>__GetDefault

Func __GetFileName($gFilePath) ; Taken From WinAPIEx.au3 By Yashied - http://www.autoitscript.com/forum/index.php?showtopic=98712
	#cs
		Description: Gets The File Name From A File Path.
		Returns: File Name [FileName.txt]
	#ce
	Local $gPath = DllStructCreate("wchar[" & (StringLen($gFilePath) + 1) & "]")
	DllStructSetData($gPath, 1, $gFilePath)
	DllCall("shlwapi.dll", "none", "PathStripPathW", "ptr", DllStructGetPtr($gPath))
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return DllStructGetData($gPath, 1)
EndFunc   ;==>__GetFileName

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
		If @error Then
			Return SetError(1, 0, 0)
		EndIf
		Return DllStructGetData($gPath, 1)
	ElseIf $gGetExt = 1 Then ; Get File Extension.
		$gPath = DllStructCreate("wchar[1024]")
		DllStructSetData($gPath, 1, $gFilePath)
		Local $gReturn = DllCall("shlwapi.dll", "int", "PathFindExtensionW", "ptr", DllStructGetPtr($gPath))
		If @error Then
			Return SetError(1, 0, 0)
		EndIf
		Return StringTrimLeft(DllStructGetData(DllStructCreate("wchar[1024]", $gReturn[0]), 1), 1)
	EndIf
	Return SetError(1, 0, 0)
EndFunc   ;==>__GetFileNameExExt

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
		If @OSVersion == "WIN_XP" Or @OSVersion == "WIN_XPe" Then
			$gPropertyNumber = $gArrayWinXP[$gPropertyNumber]
		EndIf
		If @OSVersion == "WIN_VISTA" Or @OSVersion == "WIN_7" Then
			$gPropertyNumber = $gArrayWinVista[$gPropertyNumber]
		EndIf
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

	Return SetError(1, 0, 0)
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
			If UBound($gReturn, 1) <= $gReturn[0][0] + 1 Then
				ReDim $gReturn[UBound($gReturn, 1) * 2][$gReturn[0][1]] ; ReDim's $gReturn If More Items Are Required.
			EndIf
			Local $ghWndProcess = WinGetProcess($gWinList[$A][0])
			$gReturn[0][0] += 1
			$gReturn[$gReturn[0][0]][0] = $gWinList[$A][0] ; Multiple Instance Name.
			$gReturn[$gReturn[0][0]][1] = WinGetHandle($gWinList[$A][0]) ; Multiple Instance Handle.
			$gReturn[$gReturn[0][0]][2] = $ghWndProcess ; PID Of Multiple Instance (Useful If You Want To End The Process.)
		EndIf
	Next
	ReDim $gReturn[$gReturn[0][0] + 1][$gReturn[0][1]] ; Delete Empty Spaces.
	If $gReturn[0][0] = 0 Then
		Return SetError(1, 0, 0)
	EndIf
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
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return DllStructGetData($gPath, 1) & "\"
EndFunc   ;==>__GetParentFolder

Func __GetPatterns($gProfile = -1)
	#cs
		Description: Gets Patterns In The Current Profile [-1] Or Specified Profile Name [Valid Profile Name].
		Returns: Array[0][0] - Number Of Items [?]
		[0][1] - Number Of Columns [3]
		[0][2] - Profile Name [Profile Name]

		Array[A][0] - Pattern Rule [*.EXE]
		[A][1] - Destination [C:\DropIt Files]
		[A][2] - Pattern Name [Executables]
		[A][3] - Size Filter [1<20MB]
		[A][4] - Date Created Filter [1<20d]
		[A][5] - Date Modified Filter [1<20d]
		[A][6] - Date Opened Filter [1<20d]
		[A][7] - Pattern Enabled/Disabled [Enabled]
	#ce
	$gProfile = __IsProfile($gProfile, 0) ; Get Array Of Selected Profile.
	Local $gStringSplit, $gNumberFields = 8

	Local $g_IniReadSection = __IniReadSection($gProfile[0], "Patterns")
	If @error Then
		Local $gReturn[1][$gNumberFields] = [[0, $gNumberFields, $gProfile[1]]]
		Return $gReturn
	EndIf

	Local $gReturn[$g_IniReadSection[0][0] + 1][$gNumberFields] = [[0, $gNumberFields, $gProfile[1]]]

	For $A = 1 To $g_IniReadSection[0][0]
		$gStringSplit = StringSplit($g_IniReadSection[$A][1], "|")
		If @error Then
			IniDelete($gProfile[0], "Patterns", $g_IniReadSection[$A][0])
			ContinueLoop
		EndIf
		ReDim $gStringSplit[$gNumberFields]

		$gReturn[$A][0] = $g_IniReadSection[$A][0]
		For $B = 1 To $gNumberFields - 1
			$gReturn[$A][$B] = $gStringSplit[$B]
		Next
		$gReturn[0][0] += 1
	Next
	ReDim $gReturn[$gReturn[0][0] + 1][$gNumberFields] ; Delete Empty Rows.
	Return $gReturn
EndFunc   ;==>__GetPatterns

Func __GetPatternString($gType, $gRule = "")
	#cs
		Description: Gets Pattern String [*.txt$1] Or Action Type [Copy] Or String Type [$1].
	#ce
	Local $gPatternString

	If StringLeft($gType, 1) = "$" Then
		Switch $gType
			Case "$1"
				$gPatternString = __Lang_Get('COPY', 'Copy')
			Case "$2"
				$gPatternString = __Lang_Get('EXCLUDE', 'Exclude')
			Case "$3"
				$gPatternString = __Lang_Get('COMPRESS', 'Compress')
			Case "$4"
				$gPatternString = __Lang_Get('EXTRACT', 'Extract')
			Case "$5"
				$gPatternString = __Lang_Get('OPEN_WITH', 'Open With')
			Case "$6"
				$gPatternString = __Lang_Get('DELETE', 'Delete')
			Case "$7"
				$gPatternString = __Lang_Get('RENAME', 'Rename')
			Case Else ; Move.
				$gPatternString = __Lang_Get('MOVE', 'Move')
		EndSwitch
	Else
		Switch $gType
			Case __Lang_Get('COPY', 'Copy')
				$gPatternString = $gRule & "$1"
			Case __Lang_Get('EXCLUDE', 'Exclude')
				$gPatternString = $gRule & "$2"
			Case __Lang_Get('COMPRESS', 'Compress')
				$gPatternString = $gRule & "$3"
			Case __Lang_Get('EXTRACT', 'Extract')
				$gPatternString = $gRule & "$4"
			Case __Lang_Get('OPEN_WITH', 'Open With')
				$gPatternString = $gRule & "$5"
			Case __Lang_Get('DELETE', 'Delete')
				$gPatternString = $gRule & "$6"
			Case __Lang_Get('RENAME', 'Rename')
				$gPatternString = $gRule & "$7"
			Case Else ; Move.
				$gPatternString = $gRule & "$0"
		EndSwitch
	EndIf

	Return $gPatternString
EndFunc   ;==>__GetPatternString

Func __GetProfile($gINI = -1, $gProfile = -1, $gProfileDirectory = -1, $gArray = 0)
	#cs
		Description: DO NOT USE, ONLY CALLED BY __IsProfile().
	#ce
	$gINI = __IsSettingsFile($gINI) ; Get Default Settings INI File.
	Local $gProfileDefault = __GetDefault(22) ; Get Default Profile & Default Image Directory & Default Image File.
	If $gProfileDirectory = -1 Or $gProfileDirectory = 0 Or $gProfileDirectory = "" Then
		$gProfileDirectory = __GetDefault(2) ; Get Default Profile Directory.
	EndIf

	Local $gReturn[9], $gSize

	If $gProfile == -1 Or $gProfile == 0 Or $gProfile == "" Then
		$gProfile = __GetCurrentProfile() ; If Profile Name Is Blank, Then Get Current Profile From The Settings INI File.
	EndIf
	If FileExists($gProfileDefault[1][0] & $gProfile & ".ini") = 0 And $gProfile <> "Default" Then ; Check If Profile Exists.
		If $CmdLine[0] = 0 Then
			MsgBox(0x30, __Lang_Get('CMDLINE_MSGBOX_0', 'Profile not found'), __Lang_Get('CMDLINE_MSGBOX_1', 'It appears DropIt is using an invalid Profile.  @LF  It will be started using "Default" profile.'), 0, __OnTop())
		EndIf
		$gProfile = "Default" ; Default Profile Name.
		__SetCurrentProfile($gProfile) ; Write Default Profile Name To The Settings INI File.
	EndIf

	$gReturn[0] = $gProfileDefault[1][0] & $gProfile & ".ini" ; Profile Directory And Profile Name.
	$gReturn[1] = $gProfile ; Profile Name.
	$gReturn[2] = $gProfileDefault[1][0] ; Profile Directory


	If FileExists($gReturn[0]) = 0 Then ; If The Profile Doesn't Exist, Create It.
		IniWriteSection($gReturn[0], "Target", "Image=" & $gProfileDefault[3][0] & @LF & "SizeX=64" & @LF & "SizeY=64" & @LF & "Transparency=100")
		IniWriteSection($gReturn[0], "Patterns", "")
	EndIf

	$gReturn[4] = IniRead($gReturn[0], "Target", "Image", "UUIDID.9CC09662-A476-4A7A-C40179A9D7DAD484.UUIDID") ; Image File.
	If FileExists($gProfileDefault[2][0] & $gReturn[4]) = 0 Then
		$gReturn[4] = $gProfileDefault[3][0]
		If FileExists($gProfileDefault[2][0] & $gReturn[4]) = 0 Then
			_ResourceSaveToFile(__GetDefault(128), "IMAGE")
		EndIf
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

	If $gArray = 1 Then
		Return $gReturn[0] ; Profile Directory And Profile Name.
	EndIf
	If $gArray = 2 Then
		Return $gReturn[3] ; Image Directory And Image Name.
	EndIf
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
	If StringRight($iSaveDirectory, 1) <> "\" Then
		$iSaveDirectory = $iSaveDirectory & "\"
	EndIf
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
	If FileExists($iFileName) = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	Local $iReturn[2]
	Local $iImage = _GDIPlus_ImageLoadFromFile($iFileName)
	$iReturn[0] = _GDIPlus_ImageGetWidth($iImage)
	$iReturn[1] = _GDIPlus_ImageGetHeight($iImage)
	_GDIPlus_ImageDispose($iImage)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return $iReturn
EndFunc   ;==>__ImageSize

Func __ImageRelativeSize($iGUIWidth, $iGUIHeight, $iImageWidth, $iImageHeight)
	#cs
		Description: Calculates The Correct Width And Height Of An Image In A GUI.
		Returns: An Array[2]
		[0] - Width Of GUI [64]
		[1] - Height Of GUI [64]
	#ce
	If ($iImageWidth < 0) Or ($iImageHeight < 0) Then
		Return SetError(1, 0, 0)
	EndIf

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
		If @error Then
			Return SetError(@error, 0, "")
		EndIf
		Return $iSectionRead
	EndIf
	Local $iFileRead = @CRLF & FileRead($iFile) & @CRLF & '['
	$iSection = StringStripWS($iSection, 7)
	Local $iData = StringRegExp($iFileRead, '(?s)(?i)\n\s*\[\s*' & $iSection & '\s*\]\s*\r\n(.*?)\[', 3)
	If IsArray($iData) = 0 Then
		Return SetError(1, 0, 0)
	EndIf
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

	If __IsInstalled() = 0 Then
		Return SetError(1, 0, 0) ; __IsInstalled() = Checks If DropIt Is Installed.
	EndIf
	Local $iPortable = __GetDefault(66, 1) ; Get Profile Directory & Settings INI File With Installed Checking Skipped.
	Local $iInstalled = __GetDefault(3, 0) ; Get Default Directories.

	If FileExists($iPortable[1][0]) Then ; Profiles Directory.
		DirCopy($iPortable[1][0], $iInstalled[2][0], 1)
		If @error = 0 Then
			DirRemove($iPortable[1][0], 1)
		EndIf
	EndIf
	If FileExists($iPortable[2][0]) Then ; Settings INI File.
		FileCopy($iPortable[2][0], $iInstalled[1][0], 9)
		If @error = 0 Then
			FileDelete($iPortable[2][0])
		EndIf
	EndIf

	If @error Then
		Return $iPortable[1][0]
	EndIf
	Return $iInstalled[1][0]
EndFunc   ;==>__InstalledCheck

Func __Is($iData, $iINI = -1, $iDefault = "True")
	#cs
		Description: For INI Parameters That Use True/False Results, Therefore It Can Be Called As If __Is("DropItOn") Then ... , Simply Means If DropItOn Is True.
		Returns: True/False
	#ce
	If $iINI = -1 Then
		$iINI = __IsSettingsFile() ; Get Default Settings INI File.
	EndIf
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
	Return StringInStr(FileGetAttrib($iFolder), "D")
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
	If IsHWnd($iParentWindow) Then
		Return $iParentWindow
	EndIf
	Return WinGetHandle(AutoItWinGetTitle())
EndFunc   ;==>__IsHandle

Func __IsOnTop($iHandle = $Global_GUI_1)
	#cs
		Description: Sets A GUI Handle "OnTop" If True/False In The Settings INI File.
		Returns: GUI OnTop Or Not OnTop
	#ce
	$iHandle = __IsHandle($iHandle) ; Checks If GUI Handle Is A Valid Handle.

	Local $iState = 0
	If __Is("OnTop") Then
		$iState = 1
	EndIf
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
	If IsArray($iProfile) = 0 And $iProfile <> -1 Or $iProfile <> 0 Or $iProfile <> "" Then
		If FileExists($iProfileDirectory & $iProfile & ".ini") Then
			Return __GetProfile($iINI, $iProfile, $iProfileDirectory, $iArray)
		EndIf
	EndIf

	$iUbound = UBound($iProfile)
	If $iUbound <> 9 Then
		Return __GetProfile($iINI, $iProfile, $iProfileDirectory, $iArray)
	EndIf
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
		If $A = $iProfileList[0] Then
			ExitLoop
		EndIf
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
	If StringInStr(FileGetAttrib($iFilePath), "R") Then
		Return 1
	EndIf
EndFunc   ;==>__IsReadOnly

Func __IsSettingsFile($iINI = -1, $iShowLang = 1)
	#cs
		Description: Provides A Valid Location Of The Settings INI File.
		Returns: Settings INI File [C:\Program Files\DropIt\Settings.ini]
	#ce
	Local $iFileExists, $iFileGetSize, $iINIData

	If $iINI = -1 Or $iINI = 0 Or $iINI = "" Then
		$iINI = __GetDefault(64) ; Get Default Settings FullPath.
	EndIf
	$iFileExists = FileExists($iINI)
	$iFileGetSize = FileGetSize($iINI)

	If $iFileExists And $iFileGetSize <> 0 Then
		Return $iINI
	EndIf

	If $iFileExists = 0 Or $iFileGetSize = 0 Then
		$iINIData = "Version=" & $Global_CurrentVersion & @LF & "Profile=Default" & @LF & "Language=English" & @LF & "PosX=-1" & @LF & "PosY=-1" & @LF & _
				"SizeCustom=320;200" & @LF & "SizeManage=460;260" & @LF & "ColumnCustom=95;95;60;50" & @LF & "ColumnManage=130;100;85;110" & @LF & "OnTop=True" & @LF & _
				"LockPosition=False" & @LF & "CustomTrayIcon=True" & @LF & "MultipleInstances=False" & @LF & "StartAtStartup=False" & @LF & "ConvertPath=False" & @LF & _
				"WaitOpened=False" & @LF & "UseSendTo=False" & @LF & "SendToMode=Permanent" & @LF & "ShowSorting=True" & @LF & "ProfileEncryption=False" & @LF & _
				"DirForFolders=False" & @LF & "IgnoreNew=False" & @LF & "AutoDup=False" & @LF & "DupMode=Overwrite" & @LF & "CreateLog=False" & @LF & _
				"IntegrityCheck=False" & @LF & "SizeMessage=True" & @LF & "Monitoring=False" & @LF & "MonitoringTime=60" & @LF & "ArchiveFormat=ZIP" & @LF & _
				"ArchiveLevel=Normal" & @LF & "ArchiveMethod=LZMA" & @LF & "ArchiveSelf=False" & @LF & "ArchiveEncrypt=False" & @LF & "ArchiveEncryptMethod=AES-256" & @LF & _
				"ArchivePassword=" & @LF & "MasterPassword="

		IniWriteSection($iINI, "General", $iINIData)
		IniWriteSection($iINI, "MonitoredFolders", "")
		IniWriteSection($iINI, "EnvironmentVariables", "")
		If $iShowLang Then
			__Lang_GUI() ; Skip Language Selection If $iShowLang = 0
		EndIf
	EndIf
	Return $iINI
EndFunc   ;==>__IsSettingsFile

Func __IsSupported($iFileName, $iFormats = "exe")
	#cs
		Description: Checks If A File Is Supported.
		Returns: 1 = True Or 0 = False
	#ce
	If StringRight($iFileName, 1) <> "." Then
		$iFileName = "." & $iFileName
	EndIf
	If StringRegExp($iFormats, "\\|/|:|\<|\>|\|") Then
		Return SetError(1, 2, "")
	EndIf
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
	If $lLanguageList[0] = 0 Then
		Local $lLanguageList[2] = [1, $lCurrentLanguage] ; Show Default Language & NoFlag.
	EndIf
	For $A = 1 To $lLanguageList[0]
		$lIndex = _GUICtrlComboBoxEx_AddString($lComboBox, $lLanguageList[$A], $A - 1, $A - 1)
		__SetItemImageEx($lComboBox, $lIndex, $lImageList, $lLanguageDefault & $lLanguageList[$A] & ".gif", 2)
		If $lCurrentLanguage == $lLanguageList[$A] Then
			_GUICtrlComboBoxEx_SetCurSel($lComboBox, $lIndex)
		EndIf
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
		If @error Then
			$lData = _WinAPI_ExpandEnvironmentStrings($lDefault)
		EndIf
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
	GUICtrlSetState($lOK, $GUI_DEFBUTTON)
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
		If @error Then
			ExitLoop
		EndIf
		If UBound($lLanguageList, 1) <= $lLanguageList[0] + 1 Then
			ReDim $lLanguageList[UBound($lLanguageList, 1) * 2] ; ReDim's $lLanguageList If More Items Are Required.
		EndIf
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
		If @error Then
			Return SetError(1, 0, 0)
		EndIf

		$lStringInStr = StringInStr($lFileRead, @CRLF, 0, -1, $lFileGetSize / 2)
		If $lStringInStr = 0 Then
			Return SetError(1, 0, 0)
		EndIf
		$lFileRead = StringTrimLeft($lFileRead, $lStringInStr + 3)
		$lFileOpen = FileOpen($lLogFile, 2)
		$lFileWrite = FileWrite($lFileOpen, $lFileRead)
		FileClose($lFileOpen)

		If $lFileWrite = 0 Then
			Return SetError(1, 0, 0)
		EndIf
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
		If StringInStr($lFunction, __Lang_Get('DROPIT_CLOSED', 'DropIt Closed')) Or StringInStr($lFunction, __Lang_Get('LOG_DISABLED', 'Log Disabled')) Then
			FileWriteLine($lFileOpen, "")
		EndIf
		FileClose($lFileOpen)
	EndIf
	Return 1
EndFunc   ;==>__Log_Write

Func __MD5ForFile($mFile, $mRead = 100) ; Taken From: http://www.autoitscript.com/forum/topic/95558-crc32-md4-md5-sha1-for-files/
	If $mRead > 100 Then
		$mRead = 100
	EndIf
	Local $mFileSize = FileGetSize($mFile)
	$mRead = ($mRead / 100) * $mFileSize

	Local $mResult = DllCall("kernel32.dll", "hwnd", "CreateFileW", "wstr", $mFile, "dword", 0x80000000, "dword", 1, "ptr", 0, "dword", 3, "dword", 0, "ptr", 0)
	If @error Or $mResult[0] = -1 Then
		Return SetError(1, 0, 0)
	EndIf
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
	If __Is("ProfileEncryption", $pINI) = 0 Or FileExists(__GetDefault(1) & "Profiles.dat") = 0 Then
		Return 1
	EndIf

	Local $pPW, $pPW_Code = $Global_Password_Key
	Local $pMasterPassword, $pOK, $pCancel, $pStart = 1, $pPWFailedAttempts
	Local $pGUI = GUICreate(__Lang_Get('PASSWORD_MSGBOX_0', 'Enter Password'), 240, 80, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop())

	$pMasterPassword = GUICtrlCreateInput("", 15, 15, 210, 20, 0x0020)
	$pOK = GUICtrlCreateButton("&" & __Lang_Get('OK', 'OK'), 120 - 15 - 76, 45, 76, 25)
	$pCancel = GUICtrlCreateButton("&" & __Lang_Get('CANCEL', 'Cancel'), 120 + 15, 45, 76, 25)
	GUICtrlSetState($pCancel, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)
	ControlClick($pGUI, "", $pMasterPassword)

	While 1

		; Enable/Disable OK Button.
		If GUICtrlRead($pMasterPassword) <> "" And StringIsSpace(GUICtrlRead($pMasterPassword)) = 0 Then
			If GUICtrlGetState($pOK) > 80 Then
				GUICtrlSetState($pOK, 576) ; $GUI_ENABLE + $GUI_DEFBUTTON.
			EndIf
			If GUICtrlGetState($pCancel) = 512 Then
				GUICtrlSetState($pCancel, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
		ElseIf GUICtrlRead($pMasterPassword) = "" Or StringIsSpace(GUICtrlRead($pMasterPassword)) Then
			If GUICtrlGetState($pOK) = 80 Then
				GUICtrlSetState($pOK, 144) ; $GUI_DISABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($pCancel) = 80 Then
				GUICtrlSetState($pCancel, 512) ; $GUI_DEFBUTTON.
			EndIf
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
	If $pStart = 0 Then
		Exit ; Close DropIt If Password Is Wrong.
	EndIf

	__EncryptionFolder(1) ; Decrypt Profiles.
	Return 1
EndFunc   ;==>__Password_GUI

Func __PathGetDrive($pFilePath) ; Taken From: http://www.autoitscript.com/forum/topic/82954-securely-overwrite-files/
	#cs
		Description: Get The Drive Letter Of An Absolute Or Relative Path.
		Returns: Drive Letter.
	#ce
	If StringInStr($pFilePath, ":") Then
		Return StringRegExpReplace($pFilePath, "^.*([[:alpha:]]:).*$", "${1}\\") ; Full Or UNC Path.
	EndIf
	Return StringRegExpReplace(@WorkingDir, "^([[:alpha:]]:).*$", "${1}\\") ; Relative Path, Use Current Drive.
EndFunc   ;==>__PathGetDrive

Func __ProfileList($lLimit = -1, $lLimitCheck = 0) ; If -1 Is Declared It Will List All Profile INI Files E.G. $Profiles = __ProfileList(-1)
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
	If $lSearch = -1 Then
		Return $lProfileList
	EndIf
	While 1
		$lFile = FileFindNextFile($lSearch)
		If @error Then
			ExitLoop
		EndIf
		If $lLimit <> -1 And $lProfileList[0] = $lLimit Then
			ExitLoop
		EndIf
		If StringRight($lFile, 3) = "ini" Then
			If UBound($lProfileList, 1) = $lProfileList[0] + 1 Then
				ReDim $lProfileList[UBound($lProfileList, 1) + 1] ; ReDim's $lProfileList If More Items Are Required.
			EndIf
			$lProfileList[0] += 1
			$lProfileList[$lProfileList[0]] = StringRegExpReplace($lFile, "^.*\\|\..*$", "")
		EndIf
	WEnd
	FileClose($lSearch)

	ReDim $lProfileList[$lProfileList[0] + 1] ; Delete Empty Rows.
	If @error = 0 And $lLimit <> -1 And $lLimitCheck = 1 Then
		If $lProfileList[0] = $lLimit Then
			Return 1
		EndIf
		Return 0
	EndIf

	If @error = 0 And $lLimitCheck = 0 Then
		Return $lProfileList
	EndIf
	Return SetError(1, 0, 0)
EndFunc   ;==>__ProfileList

Func __ProfileList_Combo()
	#cs
		Description: Gets Profiles And Create String For Use In A Combo Box.
		Returns: String Of Profiles.
	#ce
	Local $pData
	Local $pProfileList = __ProfileList()
	For $A = 1 To $pProfileList[0]
		If @error Then
			ExitLoop
		EndIf
		$pData &= $pProfileList[$A] & "|"
	Next
	Return StringTrimRight($pData, 1)
EndFunc   ;==>__ProfileList_Combo

Func __ProfileList_GUI($cProfileName = -1)
	#cs
		Description: Select Profile From ProfileList.
		Returns: Nothing
	#ce
	Local $lFlicker = 1 ; Stop Flickering For XP & Vista.
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
	GUICtrlSetState($lOK, $GUI_DEFBUTTON)
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
				Return SetError(1, 0, 0)

			Case $lOK
				ExitLoop

		EndSwitch
	WEnd
	$cProfile = GUICtrlRead($lCombo)

	GUIDelete($lGUI)
	Return $cProfile
EndFunc   ;==>__ProfileList_GUI

Func __ReduceMemory()
	#cs
		Description: Reduces Memory Of Current Process [-1] Or Another Process [DropIt.exe] If Specified.
		Returns: Reduces The Memory Of A Valid Process Or Returns An @error.
	#ce
	Local $rReturn = DllCall("psapi.dll", "int", "EmptyWorkingSet", "long", -1)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return $rReturn[0]
EndFunc   ;==>__ReduceMemory

Func __SecureFileDelete($sFile, $sRename = True, $sFileTime = True, $sDelete = True, $sInputPatterns = -1, $sBlock = 32768) ; Taken From: http://www.autoitscript.com/forum/topic/82954-securely-overwrite-files/
	#cs
		Description: Securely Delete A File.
		Returns: Deleted File.
	#ce
	Local $sPatterns[3]
	If FileExists($sFile) = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	If $sInputPatterns = -1 Then ; Default DoD 3-Pass Method.
		$sPatterns[0] = Random(0, 255, 1)
		$sPatterns[1] = BitAND(BitNOT($sPatterns[0]), 0xFF)
		$sPatterns[2] = Random(0, 255, 1)
	Else ; Custom Method.
		If IsArray($sInputPatterns) = 0 Then
			Return SetError(2, 0, 0)
		EndIf
		ReDim $sPatterns[UBound($sInputPatterns) + 1]
		For $A = 0 To UBound($sInputPatterns) - 1
			$sPatterns[$A] = $sInputPatterns[$A]
			If ($sPatterns[$A] < 0) Or ($sPatterns[$A] > 255) Then
				Return SetError(2, 0, 0)
			EndIf
		Next
	EndIf

	Local $sFileOpen = __SecureFileDelete_CreateFile($sFile, $GENERIC_WRITE, 0, $OPEN_EXISTING, 0xB0000000) ; FILE_FLAG_RANDOM_ACCESS | FILE_FLAG_NO_BUFFERING | FILE_FLAG_WRITE_THROUGH
	If $sFileOpen = 0 Then
		Return SetError(3, 0, 0)
	EndIf
	Local $sFileGetSize = _WinAPI_GetFileSizeEx($sFileOpen)

	Local $ClusterSize = __SecureFileDelete_GetDiskClusterSize($sFile)
	If @error Then
		$ClusterSize = 512
	EndIf

	$sBlock = Ceiling($sBlock / $ClusterSize) * $ClusterSize
	Local $sBuffer = _MemVirtualAlloc(0, $sBlock, $MEM_COMMIT, $PAGE_READWRITE)
	Local $sCycle = Ceiling($sFileGetSize / $sBlock)
	Local $sBytes, $sError = 0

	For $A = 0 To (UBound($sPatterns) - 1)
		DllCall("msvcrt.dll", "ptr:cdecl", "memset", "ptr", $sBuffer, "int", $sPatterns[$A], "ulong_ptr", $sBlock)
		For $B = 1 To $sCycle
			If _WinAPI_WriteFile($sFileOpen, $sBuffer, $sBlock, $sBytes) = False Then
				$sError = 1
				ExitLoop 2
			EndIf
		Next
		DllCall("kernel32.dll", "bool", "SetFilePointerEx", "handle", $sFileOpen, "int64", 0, "ptr", 0, "dword", 0)
	Next
	_MemVirtualFree($sBuffer, 0, $MEM_RELEASE)
	_WinAPI_CloseHandle($sFileOpen)
	If $sError Then
		Return SetError(4, 0, 0)
	EndIf
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
	If $sDelete Then
		FileDelete($sFile)
	EndIf
	Return $sFile
EndFunc   ;==>__SecureFileDelete

Func __SecureFolderDelete($sFolder, $sRename = True, $sFileTime = True, $sDelete = True, $sPatterns = -1, $sBlock = 32768)
	#cs
		Description: Securely Delete A Folder.
		Returns: 1
	#ce
	If __IsFolder($sFolder) = 0 Or FileExists($sFolder) = 0 Then
		Return SetError(1, 0, 0)
	EndIf
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
			If @error Then
				ExitLoop
			EndIf
		Else
			__SecureFileDelete($sFile, $sRename, $sFileTime, $sDelete, $sPatterns, $sBlock)
			If @error Then
				ExitLoop
			EndIf
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
	Local $sFileGetShortcut
	For $A = 1 To $sFileListToArray[0]
		If StringLeft($sFileListToArray[$A], StringLen("DropIt")) == "DropIt" Then
			$sFileGetShortcut = FileGetShortcut($sSendTo_Directory & "\" & $sFileListToArray[$A])
			If $sFileGetShortcut[0] = @AutoItExe Then
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

Func __SetCurrentLanguage($sLanguage = -1)
	#cs
		Description: Sets The Current Language To The Settings INI File.
		Return: Language [English]
	#ce
	Local $sINI = __IsSettingsFile() ; Get Default Settings INI File.

	If $sLanguage == "" Or $sLanguage = -1 Then
		$sLanguage = __GetDefault(2048) ; Get Default Language.
	EndIf
	IniWrite($sINI, "General", "Language", $sLanguage)
	Return $sLanguage
EndFunc   ;==>__SetCurrentLanguage

Func __SetCurrentPosition($sHandle = $Global_GUI_1)
	#cs
		Description: Sets The Current Coordinates/Position Of DropIt.
		Returns: 1
	#ce
	If $sHandle = "" Then
		Return SetError(1, 0, 0)
	EndIf
	Local $sINI = __IsSettingsFile() ; Get Default Settings INI File.

	Local $sWinGetPos = WinGetPos($sHandle)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	Local $sINISection = "General"
	If $Global_MultipleInstance Then
		$sINISection = $UniqueID
	EndIf
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
	If $sProfile == -1 Or $sProfile == 0 Or $sProfile == "" Then
		$sProfile = "Default"
	EndIf
	If $Global_MultipleInstance Then
		$sINISection = $UniqueID
	EndIf
	IniWrite($sINI, $sINISection, "Profile", $sProfile)

	Return $sINI
EndFunc   ;==>__SetCurrentProfile

Func __SetCurrentSize($sHandle = "", $sWindow = "")
	#cs
		Description: Sets The Current Size Of DropIt Windows.
		Returns: 1
	#ce
	If $sHandle = "" Then
		Return SetError(1, 0, 0)
	EndIf
	Local $sINI = __IsSettingsFile() ; Get Default Settings INI File.

	Local $sWinGetClientSize = WinGetClientSize($sHandle)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	IniWrite($sINI, "General", $sWindow, $sWinGetClientSize[0] & ";" & $sWinGetClientSize[1])

	Return 1
EndFunc   ;==>__SetCurrentSize

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

Func __SetItemImage($gImageFile, $gIndex, $gHandle = 0, $gType = 1, $gResource = 1, $gWidth = 20, $gHeight = 20)
	#cs
		Description: Set Image To GUI/Tray Context Menu.
		Returns: Converted Image.
	#ce
	If StringLeft(FileGetVersion(@SystemDir & "\WinVer.exe"), 3) < 6.0 Then
		Return SetError(1, 0, 0)
	EndIf
	Local $gImage
	Switch $gType
		Case 0 ; Native GUI ContextMenu.
			$gHandle = GUICtrlGetHandle($gHandle)
		Case 1 ; Native TrayMenu ContextMenu.
			$gHandle = TrayItemGetHandle($gHandle)
		Case 2
			$gHandle = $gHandle ; UDF Functions.
	EndSwitch
	Switch $gResource
		Case 1
			$gImage = _ResourceGetAsBitmap($gImageFile)
			_GUICtrlMenu_SetItemBmp($gHandle, $gIndex, $gImage)
			Return SetError(0, 0, $gImage)
		Case Else
			Local $gBitmap, $gContext, $gIcon, $gImageHeight, $gImageWidth, $gResult
			$gImage = _GDIPlus_BitmapCreateFromFile($gImageFile)
			$gImageWidth = _GDIPlus_ImageGetWidth($gImage)
			$gImageHeight = _GDIPlus_ImageGetHeight($gImage)
			If $gImageWidth < 0 Or $gImageHeight < 0 Then
				Return SetError(1, 0, 0)
			EndIf
			If $gImageWidth < $gImageHeight Then
				$gImageWidth = $gWidth * $gImageWidth / $gImageHeight
				$gImageHeight = $gHeight
			Else
				$gImageHeight = $gHeight * $gImageHeight / $gImageWidth
				$gImageWidth = $gWidth
			EndIf
			$gResult = DllCall($ghGDIPDll, "uint", "GdipCreateBitmapFromScan0", "int", $gWidth, "int", $gHeight, "int", 0, "int", 0x0026200A, "ptr", 0, "int*", 0)
			$gBitmap = $gResult[6]
			$gContext = _GDIPlus_ImageGetGraphicsContext($gBitmap)
			_GDIPlus_GraphicsDrawImageRect($gContext, $gImage, 0, 0, $gWidth, $gHeight)
			$gIcon = _GDIPlus_BitmapCreateHBITMAPFromBitmap($gBitmap)
			_GUICtrlMenu_SetItemBmp($gHandle, $gIndex, $gIcon)
			_GDIPlus_GraphicsDispose($gContext)
			_GDIPlus_BitmapDispose($gBitmap)
			Return SetError(0, 0, $gIcon)
	EndSwitch
EndFunc   ;==>__SetItemImage

Func __SetItemImageEx($gHandle, $gIndex, ByRef $gImageList, $gImageFile, $gType) ; Taken From Code By Yashied - http://www.autoitscript.com/forum/topic/113827-thumbnail-of-a-file/page__view__findpost__p__799038
	#cs
		Description: Sets Image To Control Handle.
		Returns: 1
	#ce
	Local $gIconSize = _GUIImageList_GetIconSize($gImageList)
	If (Not $gIconSize[0]) Or (Not $gIconSize[1]) Then
		Return SetError(1, 0, 0)
	EndIf

	Local $gWidth, $gHeight, $gHeightGraphic, $gHeightPicture, $gHeightImage, $gHeightIcon

	$gHeightPicture = _ResourceGetAsImage($gImageFile)
	If @error Then
		$gHeightPicture = _ResourceGetAsImage("FLAG")
		If FileExists($gImageFile) Then
			$gHeightPicture = _GDIPlus_ImageLoadFromFile($gImageFile)
		EndIf
	EndIf

	$gWidth = _GDIPlus_ImageGetWidth($gHeightPicture)
	$gHeight = _GDIPlus_ImageGetHeight($gHeightPicture)

	Local $gSize = __ImageRelativeSize($gIconSize[0], $gIconSize[1], $gWidth, $gHeight)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	$gHeightImage = DllCall($ghGDIPDll, 'int', 'GdipGetImageThumbnail', 'ptr', $gHeightPicture, 'int', $gIconSize[0], 'int', $gIconSize[1], 'ptr*', 0, 'ptr', 0, 'ptr', 0)
	$gHeightGraphic = _GDIPlus_ImageGetGraphicsContext($gHeightImage[4])
	_GDIPlus_GraphicsClear($gHeightGraphic, 0)
	_GDIPlus_GraphicsDrawImageRect($gHeightGraphic, $gHeightPicture, ($gIconSize[0] - $gSize[0]) / 2, ($gIconSize[1] - $gSize[1]) / 2, $gSize[0], $gSize[1])
	$gHeightIcon = DllCall($ghGDIPDll, 'int', 'GdipCreateHICONFromBitmap', 'ptr', $gHeightImage[4], 'ptr*', 0)
	_GDIPlus_GraphicsDispose($gHeightGraphic)
	_GDIPlus_ImageDispose($gHeightImage[4])
	_GDIPlus_ImageDispose($gHeightPicture)
	If Not $gHeightIcon[2] Then
		Return SetError(1, 0, 0)
	EndIf
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

Func __SetPatternState($sProfile, $sPattern, $sState)
	#cs
		Description: Enable/Disable The Pattern.
		Return: 1
	#ce
	Local $sNewString, $sStringSplit, $sNumberFields = 8

	$sStringSplit = StringSplit(IniRead($sProfile, "Patterns", $sPattern, ""), "|")
	ReDim $sStringSplit[$sNumberFields]
	If $sState Then
		$sStringSplit[7] = "Enabled"
	Else
		$sStringSplit[7] = "Disabled"
	EndIf

	For $A = 1 To $sNumberFields - 1
		$sNewString &= "|" & $sStringSplit[$A]
	Next
	IniWrite($sProfile, "Patterns", $sPattern, StringTrimLeft($sNewString, 1)) ; StringTrimLeft To Remove The First "|".

	Return 1
EndFunc   ;==>__SetPatternState

Func __SetProgress($sHandle, $sPercentage, $sColor = 0, $sVertical = False) ; Taken From http://www.autoitscript.com/forum/topic/121883-progress-bar-without-animation-in-vista7/page__view__findpost__p__845958
	#cs
		Description: Sets A Custom Progress Bar.
		Return: Progress Data.
	#ce
	Local $sBitmap, $sClip, $sDC, $sMemDC, $sObject, $sRectangle, $sResult = 1, $sRet, $sStructure_1, $sStructure_2, $sTheme, $sWinAPI_Object
	If StringLeft(FileGetVersion(@SystemDir & "\WinVer.exe"), 3) < 6.0 Then
		GUICtrlSetState($sHandle, $GUI_SHOW)
		GUICtrlSetData($sHandle, $sPercentage)
		Return 1
	EndIf

	If IsHWnd($sHandle) = 0 Then
		$sHandle = GUICtrlGetHandle($sHandle)
		If $sHandle = 0 Then
			Return SetError(1, 0, 0)
		EndIf
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

Func __ShowPassword($sControlID)
	#cs
		Description: Shows/Hides Password Of An Input Password Field.
		Returns: Input State.
	#ce
	Local Const $EM_GETPASSWORDCHAR = 0xD2, $EM_SETPASSWORDCHAR = 0xCC
	Local $sPasswordCharacter
	Switch GUICtrlSendMsg($sControlID, $EM_GETPASSWORDCHAR, 0, 0)
		Case 0
			$sPasswordCharacter = 9679
		Case Else
			$sPasswordCharacter = 0
	EndSwitch
	GUICtrlSendMsg($sControlID, $EM_SETPASSWORDCHAR, $sPasswordCharacter, 0)
	GUICtrlSetState($sControlID, $GUI_FOCUS)
	If $sPasswordCharacter = 0 Then
		Return 1
	EndIf
	Return 0
EndFunc   ;==>__ShowPassword

Func __SingletonEx($sID = "")
	#cs
		Description: Checks If DropIt Is Already Running.
		Returns: 1 Or Window Title.
	#ce
	If $sID = "" Then
		Return SetError(1, 0, 0)
	EndIf
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
	If @error Then
		Return __SetHandle($sID) ; Set Window Title For WM_COPYDATA.
	EndIf
	Exit ; If A Valid File/Folder It Will Exit, Otherwise It Will Open DropIt.
EndFunc   ;==>__SingletonEx

Func __StartupFolder_Install($sName = @ScriptName, $sFilePath = @ScriptFullPath, $sAllUsers = 0)
	#cs
		Description: Creates A Shortcut In The 'Current Users' Startup Folder. [Program_Name.lnk]
		Returns: 1
	#ce
	Local $sStartup_Directory = @StartupDir
	If $sName = "" Or $sFilePath = "" Then
		Return SetError(1, 0, 0)
	EndIf
	__StartupFolder_Uninstall($sName, $sFilePath, $sAllUsers) ; Deletes The Shortcut In The 'All Users/Current Users' Startup Folder.
	If $sAllUsers = 1 Then
		$sStartup_Directory = @StartupCommonDir
	EndIf
	Return FileCreateShortcut($sFilePath, $sStartup_Directory & "\" & $sName & ".lnk", @ScriptDir)
EndFunc   ;==>__StartupFolder_Install

Func __StartupFolder_Uninstall($sName = @ScriptName, $sFilePath = @ScriptFullPath, $sAllUsers = 0)
	#cs
		Description: Deletes The Shortcut In The 'Current Users' Startup Folder. [Program_Name.lnk]
		Returns: 1
	#ce
	Local $sFileListToArray, $sFileGetShortcut, $sStartup_Directory = @StartupDir
	If $sName = "" Or $sFilePath = "" Then
		Return SetError(1, 0, 0)
	EndIf
	If $sAllUsers = 1 Then
		$sStartup_Directory = @StartupCommonDir
	EndIf
	$sFileListToArray = _FileListToArray($sStartup_Directory)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	For $A = 1 To $sFileListToArray[0]
		If StringLeft($sFileListToArray[$A], StringLen($sName)) == $sName Then
			$sFileGetShortcut = FileGetShortcut($sStartup_Directory & "\" & $sFileListToArray[$A])
			If $sFileGetShortcut[0] = $sFilePath Then
				FileDelete($sStartup_Directory & "\" & $sFileListToArray[$A])
			EndIf
		EndIf
	Next
	Return $sFileListToArray
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
	Local $tTotal_Seconds = Int($tTime / 1000), $tHours = Int($tTotal_Seconds / 3600), $tMinutes = Int(($tTotal_Seconds - ($tHours * 3600)) / 60)
	Local $tSeconds = $tTotal_Seconds - (($tHours * 3600) + ($tMinutes * 60))
	If $tHours < 10 Then
		$tHours = 0 & $tHours
	EndIf
	If $tMinutes < 10 Then
		$tMinutes = 0 & $tMinutes
	EndIf
	If $tSeconds < 10 Then
		$tSeconds = 0 & $tSeconds
	EndIf
	$tTime = $tHours & ":" & $tMinutes & ":" & $tSeconds
	Return $tTime
EndFunc   ;==>__TimeSuffix

Func __Uninstall()
	#cs
		Description: Uninstall Files Etc... If The Uninstall Commandline Parameter Is Called. [DropIt.exe /Uninstall]
		Returns: 1
	#ce
	If __Is("UseSendTo") Then
		__SendTo_Uninstall() ; SendTo Integration Is Removed If Was Used By The Installed Version.
	EndIf
	Exit
EndFunc   ;==>__Uninstall

Func __Upgrade()
	#cs
		Description: Upgrades Settings To New Version, If Needed.
		Returns: 1
	#ce
	Local $uINIRead
	Local $uINI = __IsSettingsFile() ; Get Default Settings INI File.
	If IniRead($uINI, "General", "Version", "None") == $Global_CurrentVersion Then
		Return SetError(1, 0, 0) ; Abort Upgrade If INI Version Is The Same Of Current Software Version.
	EndIf

	FileMove($uINI, $uINI & ".old", 1) ; Rename The Old INI.
	__IsSettingsFile(-1, 0) ; Create A New Upgraded INI, Skipping Language Selection.

	Local $uINI_Array[37][3] = [ _
			[36, 3], _
			["General", "Profile", 1], _ ; Unchanged.
			["General", "Language", 1], _ ; Unchanged.
			["General", "PosX", 1], _ ; Unchanged.
			["General", "PosY", 1], _ ; Unchanged.
			["General", "SizeCustom", 1], _ ; Unchanged.
			["General", "SizeManage", 1], _ ; Unchanged.
			["General", "ColumnCustom", 1], _ ; Unchanged.
			["General", "ColumnManage", 1], _ ; Unchanged.
			["General", "OnTop", 1], _ ; Unchanged.
			["General", "LockPosition", 1], _ ; Unchanged.
			["General", "CustomTrayIcon", 1], _ ; Unchanged.
			["General", "MultipleInstances", 1], _ ; Unchanged.
			["General", "StartAtStartup", 1], _ ; Unchanged.
			["General", "ConvertPath", 1], _ ; Unchanged.
			["General", "WaitOpened", 1], _ ; Unchanged.
			["General", "UseSendTo", 1], _ ; Unchanged.
			["General", "SendToMode", 1], _ ; Unchanged.
			["General", "ShowSorting", 1], _ ; Unchanged.
			["General", "ProfileEncryption", 1], _ ; Unchanged.
			["General", "DirForFolders", 1], _ ; Unchanged.
			["General", "IgnoreNew", 1], _ ; Unchanged.
			["General", "AutoDup", 1], _ ; Unchanged.
			["General", "DupMode", 1], _ ; Unchanged.
			["General", "CreateLog", 1], _ ; Unchanged.
			["General", "IntegrityCheck", 1], _ ; Unchanged.
			["General", "SizeMessage", 1], _ ; Unchanged.
			["General", "Monitoring", 1], _ ; Unchanged.
			["General", "MonitoringTime", 1], _ ; Unchanged.
			["General", "ArchiveFormat", 1], _ ; Unchanged.
			["General", "ArchiveLevel", 1], _ ; Unchanged.
			["General", "ArchiveMethod", 1], _ ; Unchanged.
			["General", "ArchiveSelf", 1], _ ; Unchanged.
			["General", "ArchiveEncrypt", 1], _ ; Unchanged.
			["General", "ArchiveEncryptMethod", 1], _ ; Unchanged.
			["General", "ArchivePassword", 1], _ ; Unchanged.
			["General", "MasterPassword", 1]] ; Unchanged.
	; ["General", "Duplicates", "DupMode"], _ ; Example Of Changed Item.

	For $A = 1 To $uINI_Array[0][0]
		$uINIRead = IniRead($uINI & ".old", $uINI_Array[$A][0], $uINI_Array[$A][1], "None")
		If $uINIRead <> "None" Then
			If $uINI_Array[$A][2] = 1 Then
				$uINI_Array[$A][2] = $uINI_Array[$A][1]
			EndIf
			IniWrite($uINI, $uINI_Array[$A][0], $uINI_Array[$A][2], $uINIRead)
		EndIf
	Next
	IniWriteSection($uINI, "EnvironmentVariables", "")
	FileDelete($uINI & ".old") ; Remove The Old INI.
	Return 1
EndFunc   ;==>__Upgrade

Func __WinAPI_PathIsRelative($pPath) ; Taken From WinAPIEx.au3 By Yashied - http://www.autoitscript.com/forum/index.php?showtopic=98712
	Local $pReturn = DllCall("shlwapi.dll", "int", "PathIsRelativeW", "wstr", $pPath)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return $pReturn[0]
EndFunc   ;==>__WinAPI_PathIsRelative

Func __WinAPI_ShellGetSpecialFolderPath($sCSIDL, $sCreate = 0) ; Taken From WinAPIEx.au3 By Yashied - http://www.autoitscript.com/forum/index.php?showtopic=98712
	Local $sPath = DllStructCreate("wchar[1024]")
	Local $sReturn = DllCall("shell32.dll", "int", "SHGetSpecialFolderPathW", "hwnd", 0, "ptr", DllStructGetPtr($sPath), "int", $sCSIDL, "int", $sCreate)
	If (@error) Or (Not $sReturn[0]) Then
		Return SetError(1, 1, "")
	EndIf
	Return DllStructGetData($sPath, 1)
EndFunc   ;==>__WinAPI_ShellGetSpecialFolderPath
#Region End >>>>> Internal Functions <<<<<

#Region Start >>>>> 7Zip Functions <<<<< Taken From: http://www.autoitscript.com/forum/topic/91283-7zread-udf/
Func __7Zip_ClosePercent(ByRef $zHandle)
	If UBound($zHandle) <> 4 Then
		Return 0
	EndIf
	DllCall("Kernel32.dll", "int", "FreeConsole")
	$zHandle = 0
	Return 1
EndFunc   ;==>__7Zip_ClosePercent

Func __7Zip_OpenPercent($zPID)
	If __7Zip_AttachConsole($zPID) = 0 Then
		Return
	EndIf
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
				If StringRight($zPercent, 1) = "%" Then
					Return Number($zPercent)
				EndIf
			EndIf
		EndIf
	EndIf
	Return -1
EndFunc   ;==>__7Zip_ReadPercent

Func __7Zip_AttachConsole($zPID)
	Local $zReturn = DllCall("Kernel32.dll", "int", "AttachConsole", "dword", $zPID)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return $zReturn[0]
EndFunc   ;==>__7Zip_AttachConsole

Func __7Zip_GetConsoleInfo($zConsoleOutput, $zGetConsoleInfo)
	Local $zReturn = DllCall("Kernel32.dll", "int", "GetConsoleScreenBufferInfo", "hwnd", $zConsoleOutput, $Global_PTR, __7Zip_GetPointer($zGetConsoleInfo))
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return $zReturn[0]
EndFunc   ;==>__7Zip_GetConsoleInfo

Func __7Zip_GetHandle($zHandle)
	Local $zReturn = DllCall("Kernel32.dll", "hwnd", "GetStdHandle", "dword", $zHandle)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return $zReturn[0]
EndFunc   ;==>__7Zip_GetHandle

Func __7Zip_GetPointer(Const ByRef $Global_PTR)
	Local $zPointer = DllStructGetPtr($Global_PTR)
	If @error Then
		$zPointer = $Global_PTR
	EndIf
	Return $zPointer
EndFunc   ;==>__7Zip_GetPointer

Func __7Zip_ReadConsoleOutput($zConsoleOutput, $zBuffer, $zSmallRect)
	Local $zReturn = DllCall("Kernel32.dll", "int", "ReadConsoleOutputW", $Global_PTR, $zConsoleOutput, "int", __7Zip_GetPointer($zBuffer), "int", 65540, "int", 0, $Global_PTR, __7Zip_GetPointer($zSmallRect))
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return $zReturn[0]
EndFunc   ;==>__7Zip_ReadConsoleOutput
#Region End >>>>> 7Zip Functions <<<<<

#Region Start >>>>> Secure Delete Functions <<<<< Taken From: http://www.autoitscript.com/forum/topic/82954-securely-overwrite-files/
Func __SecureFileDelete_CreateFile($sFilePath, $sAccess, $sShareMode, $sCreation, $sFlags)
	If $sCreation = $CREATE_ALWAYS Then ; Open The File With Existing Hidden Or System Attributes To Avoid Failure When Using Create_Always.
		Local $sFileGetAttribute = FileGetAttrib($sFilePath)
		If StringInStr($sFileGetAttribute, "H") Then
			$sFlags = BitOR($sFlags, $FILE_ATTRIBUTE_HIDDEN)
		EndIf
		If StringInStr($sFileGetAttribute, "S") Then
			$sFlags = BitOR($sFlags, $FILE_ATTRIBUTE_SYSTEM)
		EndIf
	EndIf
	Local $sFile = DllCall("kernel32.dll", "handle", "CreateFileW", "wstr", $sFilePath, "dword", $sAccess, "dword", $sShareMode, "ptr", 0, _
			"dword", $sCreation, "dword", $sFlags, "ptr", 0)
	If @error Or ($sFile[0] = Ptr(-1)) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $sFile[0]
EndFunc   ;==>__SecureFileDelete_CreateFile

Func __SecureFileDelete_GetDiskClusterSize($sPath)
	Local $sReturn = DllCall("kernel32.dll", "bool", "GetDiskFreeSpaceW", "wstr", __PathGetDrive($sPath), "dword*", 0, "dword*", 0, "dword*", 0, "dword*", 0)
	If @error Or (Not $sReturn[0]) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $sReturn[3]
EndFunc   ;==>__SecureFileDelete_GetDiskClusterSize
#Region End >>>>> Secure Delete Functions <<<<<

#Region Start >>>>> Tray Icon Functions <<<<<
Func __Tray_BitmapIcon($gb_Bitmap)
	Local $ts_Return = DllCall($ghGDIPDll, "int", "GdipCreateHICONFromBitmap", "hwnd", $gb_Bitmap, "int*", 0)
	If @error Or Not $ts_Return[0] Then
		Return SetError(@error, @extended, $ts_Return[2])
	EndIf
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
	If (@error) Then
		Return SetError(1, 0, 0)
	EndIf
	_WinAPI_DestroyIcon($ts_Icon)
	Return $ts_Return[0] <> 0
EndFunc   ;==>__Tray_SetIcon
#Region End >>>>> Tray Icon Functions <<<<<