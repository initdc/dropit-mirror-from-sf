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
#AutoIt3Wrapper_Res_Fileversion=3.8.0.0
#AutoIt3Wrapper_Res_ProductVersion=3.8.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Lupo PenSuite Team
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_Field=Website|http://www.lupopensuite.com
#AutoIt3Wrapper_Res_Field=E-Mail|comment at the website
#AutoIt3Wrapper_UseX64=N
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\Custom.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\Info.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\Associations.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\Search.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\NewAction.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\Filters.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\EnvVars.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\SetList.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\List1.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\List2.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\List3.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\List4.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\USB.ico
#AutoIt3Wrapper_Res_File_Add=Examples\Archiver.ini, 10, ARCHIVER
#AutoIt3Wrapper_Res_File_Add=Examples\Eraser.ini, 10, ERASER
#AutoIt3Wrapper_Res_File_Add=Examples\Extractor.ini, 10, EXTRACTOR
#AutoIt3Wrapper_Res_File_Add=Images\Default.png, 10, IMAGE
#AutoIt3Wrapper_Res_File_Add=Lib\img\Associations.png, 10, ASSO
#AutoIt3Wrapper_Res_File_Add=Lib\img\About.png, 10, ABOUT
#AutoIt3Wrapper_Res_File_Add=Lib\img\Close.png, 10, CLOSE
#AutoIt3Wrapper_Res_File_Add=Lib\img\CopyTo.png, 10, COPYTO
#AutoIt3Wrapper_Res_File_Add=Lib\img\Custom.png, 10, CUST
#AutoIt3Wrapper_Res_File_Add=Lib\img\Delete.png, 10, DEL
#AutoIt3Wrapper_Res_File_Add=Lib\img\Edit.png, 10, EDIT
#AutoIt3Wrapper_Res_File_Add=Lib\img\Example.png, 10, EXAMP
#AutoIt3Wrapper_Res_File_Add=Lib\img\Guide.png, 10, GUIDE
#AutoIt3Wrapper_Res_File_Add=Lib\img\Help.png, 10, HELP
#AutoIt3Wrapper_Res_File_Add=Lib\img\Hide.png, 10, HIDE
#AutoIt3Wrapper_Res_File_Add=Lib\img\New.png, 10, NEW
#AutoIt3Wrapper_Res_File_Add=Lib\img\NoFlag.gif, 10, FLAG
#AutoIt3Wrapper_Res_File_Add=Lib\img\Options.png, 10, OPT
#AutoIt3Wrapper_Res_File_Add=Lib\img\Profiles.png, 10, PROF
#AutoIt3Wrapper_Res_File_Add=Lib\img\Progress.png, 10, PROG
#AutoIt3Wrapper_Res_File_Add=Lib\img\Readme.png, 10, READ
#AutoIt3Wrapper_Res_File_Add=Lib\img\Show.png, 10, SHOW
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#AutoIt3Wrapper_Run_Obfuscator=Y
#Obfuscator_Parameters=/SF /SV /OM /CF=0 /CN=0 /CS=0 /CV=0
#AutoIt3Wrapper_res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Outfile_Type=exe
#AutoIt3Wrapper_Compile_Both=N
#EndRegion ; **** Directives Created By AutoIt3Wrapper_GUI ****

#include <Date.au3>
#include <GUIButton.au3>
#include <GUIComboBoxEx.au3>
#include <GUIImageList.au3>
#include <GUIListBox.au3>
#include <GUIListView.au3>
#include <GUIMenu.au3>
#include <GUIToolTip.au3>
#include <Lib\udf\APIConstants.au3>
#include <Lib\udf\Copy.au3>
#include <Lib\udf\Resources.au3>
#include <Lib\udf\ShellAll.au3>
#include <Lib\udf\Startup.au3>
#include <Lib\udf\WinAPIEx.au3>
#include <Misc.au3>
#include <StaticConstants.au3>
#include <String.au3>

Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1)

; <<<<< Variables >>>>>
Global $Global_CurrentVersion = "3.8"
Global $Global_ImageList, $Global_GUI_1, $Global_GUI_2, $Global_Icon_1, $Global_GUI_State = 1 ; ImageList & GUI Handles & Icons Handle & GUI State.
Global $Global_ContextMenu[15][2] = [[14, 2]], $Global_TrayMenu[14][2] = [[13, 2]], $Global_MenuDisable = 0 ; ContextMenu & TrayMenu.
Global $Global_ListViewIndex = -1, $Global_ListViewFolders, $Global_ListViewProfiles, $Global_ListViewRules ; ListView Variables.
Global $Global_ListViewProfiles_Enter, $Global_ListViewProfiles_New, $Global_ListViewProfiles_Delete, $Global_ListViewProfiles_Options, $Global_ListViewProfiles_Example[2] ; ListView Variables.
Global $Global_ListViewFolders_Enter, $Global_ListViewFolders_New, $Global_ListViewRules_ComboBox, $Global_ListViewRules_ComboBoxChange = 0, $Global_ListViewRules_ItemChange = -1 ; ListView Variables.
Global $Global_ListViewRules_CopyTo, $Global_ListViewRules_Delete, $Global_ListViewRules_Enter, $Global_ListViewRules_New ; ListView Variables.
Global $Global_AbortButton, $Global_AbortSorting = 0, $Global_SortingCurrentSize, $Global_SortingGUI, $Global_SortingTotalSize ; Sorting GUI.
Global $Global_Timer, $Global_Action, $Global_Language, $Global_MainDir, $Global_DuplicateMode, $Global_Key, $Global_Wheel ; Misc.
Global $Global_DroppedFiles[1], $Global_OpenedLists[1][2], $Global_PriorityActions[1], $Global_PTR = "ptr" ; Misc.
Global $Global_ResizeWidth, $Global_ResizeHeight ; Windows Size For Resizing.
Global $Global_MultipleInstance = 0 ; Multiple Instances.
Global $Global_Slider, $Global_SliderLabel ; _Customize_GUI_Edit.
Global $Global_UniqueID = "DropIt_E15FF08B-84AC-472A-89BF-5F92DB683165" ; WM_COPYDATA.
Global $Global_Encryption_Key = "profiles-password-fake" ; Key For Profiles Encryption.
Global $Global_Password_Key = "archives-password-fake" ; Key For Archives Encryption.
; <<<<< Variables >>>>>

__EnvironmentVariables() ; Set The Standard & User Assigned Environment Variables.
__ExpandEnvStrings(0) ; Disable The Expansion Of Environment Variables.

_Update_Check() ; Check If DropIt Has Been Updated.
__Password_GUI() ; Ask Password If In Encrypt Mode.
__Upgrade() ; Upgrade DropIt If Required.
__SingletonEx($Global_UniqueID) ; WM_COPYDATA.

OnAutoItExitRegister("_ExitEvent")

_GDIPlus_Startup()

_Main()

#Region >>>>> MAIN: Manage Functions <<<<<
Func _Manage_GUI($mINI = -1, $mHandle = -1)
	Local $mGUI, $mListView, $mListView_Handle, $mMsg, $A, $mNew, $mClose, $mProfileCombo, $mProfileCombo_Handle, $mName, $mText, $mAction, $mState, $mDestination
	Local $mIndex_Selected, $mAssociate, $mUpdateList, $mNumber, $mProfileName, $mProfileString, $mProfileText, $mCopyToDummy, $mDeleteDummy, $mEnterDummy, $mNewDummy

	Local $mProfile = __IsProfile(-1, 0) ; Get Array Of Current Profile.
	Local $mSize = __GetCurrentSize("SizeManage") ; 460 x 260.
	$mINI = __IsSettingsFile($mINI) ; Get Default Settings INI File.

	$mGUI = GUICreate(__Lang_Get('MANAGE_GUI', 'Manage Associations'), $mSize[0], $mSize[1], -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX), -1, __OnTop($mHandle))
	GUISetIcon(@ScriptFullPath, -7, $mGUI) ; Use Associations.ico
	$Global_ResizeWidth = 400 ; Set Default Minimum Width.
	$Global_ResizeHeight = 200 ; Set Default Minimum Height.

	$mListView = GUICtrlCreateListView(__Lang_Get('NAME', 'Name') & "|" & __Lang_Get('RULES', 'Rules') & "|" & __Lang_Get('ACTION', 'Action') & "|" & __Lang_Get('DESTINATION', 'Destination'), 0, 0, $mSize[0], $mSize[1] - 35, BitOR($LVS_NOSORTHEADER, $LVS_REPORT, $LVS_SINGLESEL))
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
		_GUIToolTip_SetDelayTime($mToolTip, 3, 60) ; Speed Up InfoTip Appearance.
	EndIf

	_Manage_Update($mListView_Handle, $mProfile[1]) ; Add/Update The ListView With The Custom Associations.

	$mCopyToDummy = GUICtrlCreateDummy()
	$Global_ListViewRules_CopyTo = $mCopyToDummy
	$mDeleteDummy = GUICtrlCreateDummy()
	$Global_ListViewRules_Delete = $mDeleteDummy
	$mEnterDummy = GUICtrlCreateDummy()
	$Global_ListViewRules_Enter = $mEnterDummy
	$mNewDummy = GUICtrlCreateDummy()
	$Global_ListViewRules_New = $mNewDummy

	$mNew = GUICtrlCreateButton("&" & __Lang_Get('NEW', 'New'), 32, $mSize[1] - 31, 85, 25)
	GUICtrlSetTip($mNew, __Lang_Get('MANAGE_GUI_TIP_0', 'Click to add an association or Right-click associations to modify them.'))
	GUICtrlSetResizing($mNew, $GUI_DOCKSIZE + $GUI_DOCKLEFT + $GUI_DOCKBOTTOM)

	$mProfileCombo = GUICtrlCreateCombo("", 155, $mSize[1] - 29, $mSize[0] - 310, 24, 0x0003)
	$mProfileCombo_Handle = GUICtrlGetHandle($mProfileCombo)

	$Global_ListViewRules_ComboBox = $mProfileCombo_Handle

	GUICtrlSetData($mProfileCombo, __ProfileList_Combo(), $mProfile[1])
	GUICtrlSetTip($mProfileCombo, __Lang_Get('MANAGE_GUI_TIP_1', 'Select a Profile to change its associations.'))
	GUICtrlSetResizing($mProfileCombo, $GUI_DOCKSIZE + $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM)

	$mClose = GUICtrlCreateButton("&" & __Lang_Get('CLOSE', 'Close'), $mSize[0] - 32 - 85, $mSize[1] - 31, 85, 25)
	GUICtrlSetTip($mClose, __Lang_Get('MANAGE_GUI_TIP_2', 'Save associations and close the window.'))
	GUICtrlSetResizing($mClose, $GUI_DOCKSIZE + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM)
	GUICtrlSetState($mClose, $GUI_DEFBUTTON)

	$Global_ListViewIndex = -1 ; Set As No Item Selected.
	GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
	GUIRegisterMsg($WM_GETMINMAXINFO, "WM_GETMINMAXINFO")
	GUISetState(@SW_SHOW)

	Local $mHotKeys[3][2] = [["^n", $mNewDummy],["{DELETE}", $mDeleteDummy],["{ENTER}", $mEnterDummy]]
	GUISetAccelerators($mHotKeys)

	_WinAPI_EmptyWorkingSet() ; Reduce Memory Usage Of DropIt.
	While 1
		$mIndex_Selected = $Global_ListViewIndex

		If $Global_ListViewRules_ComboBoxChange Then
			$Global_ListViewRules_ComboBoxChange = 0
			$mProfile = __IsProfile(GUICtrlRead($mProfileCombo), 0) ; Get Array Of Selected Profile.
		EndIf

		If $Global_ListViewRules_ItemChange <> -1 Then
			$mText = _GUICtrlListView_GetItemText($mListView_Handle, $Global_ListViewRules_ItemChange, 1)
			$mAction = _GUICtrlListView_GetItemText($mListView_Handle, $Global_ListViewRules_ItemChange, 2)
			$mState = _GUICtrlListView_GetItemChecked($mListView_Handle, $Global_ListViewRules_ItemChange)
			__SetAssociationState($mProfile[0], __GetAssociationString($mAction, $mText), $mState)
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
				$mAssociate = _Manage_Edit_GUI($mProfile[1], -1, -1, -1, -1, -1, $mGUI, 1) ; Show Manage Edit GUI For New Association.
				If $mAssociate = 1 Then
					$mProfile = _Manage_Update($mListView_Handle, $mProfile) ; Add/Update The ListView With The Custom Associations.
				EndIf

			Case $mDeleteDummy
				_Manage_Delete($mListView_Handle, $mIndex_Selected, $mProfile[0]) ; Delete Selected Association From Current Profile & ListView.

			Case $mEnterDummy, $mCopyToDummy
				$mIndex_Selected = _GUICtrlListView_GetSelectionMark($mListView_Handle)
				If Not _GUICtrlListView_GetItemState($mListView_Handle, $mIndex_Selected, $LVIS_SELECTED) Then
					ContinueLoop
				EndIf
				$mText = _GUICtrlListView_GetItemText($mListView_Handle, $mIndex_Selected, 1)
				$mAction = _GUICtrlListView_GetItemText($mListView_Handle, $mIndex_Selected, 2)
				$mUpdateList = 0

				If $mMsg = $mEnterDummy Then
					$mName = _GUICtrlListView_GetItemText($mListView_Handle, $mIndex_Selected)
					$mDestination = _GUICtrlListView_GetItemText($mListView_Handle, $mIndex_Selected, 3)
					$mState = _GUICtrlListView_GetItemChecked($mListView_Handle, $mIndex_Selected)
					_Manage_Edit_GUI($mProfile[1], $mName, $mText, $mAction, $mDestination, $mState, $mGUI, 0) ; Show Manage Edit GUI For Selected Association.
					If @error Then
						ContinueLoop
					EndIf
					$mUpdateList = 1
				Else
					$mProfileName = __ProfileList_GUI() ; Show Profile Selection GUI To Select A Profile From The Profile List.
					If @error Then
						ContinueLoop
					EndIf
					$mProfileString = __GetAssociationString($mAction, $mText) ; Profile INI Key [*.txt$1].
					$mProfileText = IniRead($mProfile[0], "Associations", $mProfileString, "") ; Profile INI Value [C:\Destination|Example|1<20MB;0>d;0>d;0>d|Disabled|0;1;2;3;11;13].

					; Support To Duplicate Associations In A Profile:
					If $mProfileName == $mProfile[1] Then
						$mState = "*"
						If StringInStr($mProfileString, "**") Then
							$mState = "*" & $mState
						EndIf
						$A = 1
						While 1
							If $A < 10 Then
								$mNumber = 0 & $A ; Create 01, 02, 03, 04, 05 Till 09.
							Else
								$mNumber = $A ; Create 10, 11, 12, 13, 14, Etc.
							EndIf
							If IniRead($mProfile[0], "Associations", StringTrimRight($mProfileString, 2) & ";" & $mState & $mNumber & StringRight($mProfileString, 2), "") == "" Then
								ExitLoop
							EndIf
							$A += 1
						WEnd
						$mProfileString = StringTrimRight($mProfileString, 2) & ";" & $mState & $mNumber & StringRight($mProfileString, 2)
						$mUpdateList = 1
					EndIf

					$mProfile = __IsProfile($mProfileName, 0) ; Get Array Of Selected Profile.
					_Manage_Paste($mProfile[0], $mProfileString, $mProfileText)
					$Global_ListViewRules_ComboBoxChange = 1 ; To Load $mProfile Array Of Currently Visible Profile.
				EndIf
				If $mUpdateList Then
					_Manage_Update($mListView_Handle, $mProfile) ; Add/Update The ListView With The Custom Associations.
					_GUICtrlListView_SetItemSelected($mListView_Handle, $mIndex_Selected, True, True)
				EndIf

		EndSwitch
	WEnd
	$Global_ListViewRules_ComboBoxChange = -1
	__SetCurrentSize($mGUI, "SizeManage")
	GUIDelete($mGUI)

	__SetCurrentPosition() ; Set Current Coordinates/Position Of DropIt.
	__IsOnTop() ; Set GUI "OnTop" If True.

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_Manage_GUI

Func _Manage_Edit_GUI($mProfileName = -1, $mFileName = -1, $mFileExtension = -1, $mInitialAction = -1, $mDestination = -1, $mState = -1, $mHandle = -1, $mNewAssociation = 0, $mDroppedEvent = 0)
	Local $mGUI, $mMsgBox, $mFolder, $mAdd_Action, $mSave, $mCancel, $mCurrentActionString, $mEnvVar, $mListType, $mFilters[4][4], $mChanged = 0
	Local $mInput_Name, $mInput_NameRead, $mInput_Rules, $mInput_RulesRead, $mInput_RuleData, $mButton_Rules, $mButton_Filters
	Local $mCombo_Action, $mCombo_ActionData, $mInput_Destination, $mInput_DestinationRead, $mButton_Destination, $mButton_Env
	Local $mCombo_Delete, $mCombo_DeleteData, $mRename, $mInput_Rename, $mList, $mInput_List, $mButton_List, $mListName, $mInput_Current

	Local $mAssociationType = __Lang_Get('MANAGE_ASSOCIATION_NEW', 'New Association')
	Local $mLogAssociation = __Lang_Get('MANAGE_LOG_0', 'Association Created')
	Local $mRename_Default = "%FileName%.%FileExt%"
	Local $mProfile = __IsProfile($mProfileName, 0) ; Get Array Of Current Profile.

	If $mFileName = -1 Then
		$mFileName = ""
	EndIf
	If $mFileExtension = -1 Then
		$mFileExtension = ""
	EndIf
	If $mInitialAction = -1 Then
		$mInitialAction = __Lang_Get('ACTION_MOVE', 'Move')
	EndIf
	If $mDestination = -1 Then
		$mDestination = ""
	EndIf
	If $mState = -1 Then
		$mState = 1
	EndIf
	If $mInitialAction == __Lang_Get('ACTION_RENAME', 'Rename') Then
		$mRename = $mDestination
		$mDestination = "-"
	Else
		$mRename = $mRename_Default
	EndIf
	If $mInitialAction == __Lang_Get('ACTION_LIST', 'List') Then
		$mList = $mDestination
		$mDestination = "-"
	Else
		$mList = "-"
	EndIf

	Local $mDestination_Label[4] = [ _
			__Lang_Get('MANAGE_DESTINATION_FOLDER', 'Destination Folder'), _
			__Lang_Get('MANAGE_DESTINATION_PROGRAM', 'Destination Program'), _
			__Lang_Get('MANAGE_DESTINATION_FILE', 'Destination File'), _
			__Lang_Get('MANAGE_EDIT_TIP_2', 'As destination are supported both absolute and relative paths.')]

	$mInput_RuleData = $mFileExtension
	Local $mCurrentAction = $mInitialAction
	Local $mCurrentDelete = __Lang_Get('DELETE_MODE_1', 'Normally Delete')
	$mCombo_ActionData = __Lang_Get('ACTION_MOVE', 'Move') & '|' & __Lang_Get('ACTION_COPY', 'Copy') & '|' & __Lang_Get('ACTION_COMPRESS', 'Compress') & '|' & __Lang_Get('ACTION_EXTRACT', 'Extract') & '|' & __Lang_Get('ACTION_RENAME', 'Rename') & '|' & __Lang_Get('ACTION_OPEN_WITH', 'Open With') & '|' & __Lang_Get('ACTION_LIST', 'List') & '|' & __Lang_Get('ACTION_DELETE', 'Delete') & '|' & __Lang_Get('ACTION_IGNORE', 'Ignore')
	$mCombo_DeleteData = __Lang_Get('DELETE_MODE_1', 'Normally Delete') & '|' & __Lang_Get('DELETE_MODE_2', 'Safely Erase') & '|' & __Lang_Get('DELETE_MODE_3', 'Send to Recycle Bin')
	Local $mListProperties = __List_GetProperties($mProfile[0], $mInitialAction, $mInput_RuleData) ; Get String Of List Properties.

	Select
		Case $mNewAssociation = 0 And $mDroppedEvent = 0
			$mAssociationType = __Lang_Get('MANAGE_ASSOCIATION_EDIT', 'Edit Association')
			$mLogAssociation = __Lang_Get('MANAGE_LOG_1', 'Association Modified')
			$mFilters = _Manage_ExtractFilters($mProfile[0], $mFileExtension, $mInitialAction)

		Case $mNewAssociation = 1 And $mDroppedEvent = 1
			$mInput_RuleData = "**"
			If $mFileExtension <> "" Then
				$mInput_RuleData = "*." & $mFileExtension ; $mFileExtension = "" If Loaded Item Is A Folder.
			EndIf
	EndSelect

	$mGUI = GUICreate($mAssociationType & " [" & __Lang_Get('PROFILE', 'Profile') & ": " & $mProfile[1] & "]", 460, 230, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))
	GUICtrlCreateLabel(__Lang_Get('NAME', 'Name') & ":", 15, 12, 200, 20)
	$mInput_Name = GUICtrlCreateInput($mFileName, 10, 31, 440, 22)
	GUICtrlSetTip($mInput_Name, __Lang_Get('MANAGE_EDIT_TIP_0', 'Choose a name for this association.'))

	GUICtrlCreateLabel(__Lang_Get('RULES', 'Rules') & ":", 15, 60 + 12, 200, 20)
	$mInput_Rules = GUICtrlCreateInput($mInput_RuleData, 10, 60 + 32, 358, 22)
	GUICtrlSetTip($mInput_Rules, __Lang_Get('MANAGE_EDIT_TIP_1', 'Write rules for this association.'))
	$mButton_Rules = GUICtrlCreateButton("i", 10 + 363, 60 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Rules, __Lang_Get('MANAGE_EDIT_MSGBOX_6', 'Supported Rules'))
	GUICtrlSetImage($mButton_Rules, @ScriptFullPath, -6, 0)
	$mButton_Filters = GUICtrlCreateButton("F", 10 + 404, 60 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Filters, __Lang_Get('ADDITIONAL_FILTERS', 'Additional Filters'))
	GUICtrlSetImage($mButton_Filters, @ScriptFullPath, -10, 0)

	GUICtrlCreateLabel(__Lang_Get('ACTION', 'Action') & ":", 15, 120 + 12, 120, 20)
	$mCombo_Action = GUICtrlCreateCombo("", 10, 120 + 32, 125, 22, 0x0003)
	$mInput_Destination = GUICtrlCreateInput($mDestination, 10 + 130, 120 + 32, 228, 22)
	GUICtrlSetTip($mInput_Destination, $mDestination_Label[3], $mDestination_Label[0], 0)
	$mButton_Destination = GUICtrlCreateButton("S", 10 + 130 + 233, 120 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Destination, __Lang_Get('SEARCH', 'Search'))
	GUICtrlSetImage($mButton_Destination, @ScriptFullPath, -8, 0)
	$mInput_Rename = GUICtrlCreateInput($mRename, 10 + 130, 120 + 32, 269, 22)
	GUICtrlSetTip($mInput_Rename, __Lang_Get('MANAGE_EDIT_TIP_4', 'Write output name and extension.'), __Lang_Get('MANAGE_NEW_NAME', 'New Name'), 0)
	$mInput_List = GUICtrlCreateInput($mList, 10 + 130 + 40, 120 + 32, 188, 22)
	GUICtrlSetTip($mInput_List, $mDestination_Label[3], $mDestination_Label[2], 0)
	$mButton_List = GUICtrlCreateButton("L", 10 + 130, 120 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_List, __Lang_Get('MANAGE_EDIT_MSGBOX_12', 'Configure'))
	GUICtrlSetImage($mButton_List, @ScriptFullPath, -12, 0)
	$mCombo_Delete = GUICtrlCreateCombo("", 10 + 130, 120 + 32, 310, 22, 0x0003)
	GUICtrlSetTip($mCombo_Delete, __Lang_Get('MANAGE_EDIT_TIP_5', 'Select the deletion mode for this association.'), __Lang_Get('MANAGE_DELETE_MODE', 'Deletion Mode'), 0)
	$mButton_Env = GUICtrlCreateButton("E", 10 + 130 + 274, 120 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Env, __Lang_Get('MANAGE_EDIT_MSGBOX_8', 'Internal Environment Variables'))
	GUICtrlSetImage($mButton_Env, @ScriptFullPath, -11, 0)

	GUICtrlSetState($mInput_Rename, $GUI_HIDE)
	GUICtrlSetState($mInput_List, $GUI_HIDE)
	GUICtrlSetState($mButton_List, $GUI_HIDE)
	GUICtrlSetState($mCombo_Delete, $GUI_HIDE)
	Switch $mCurrentAction
		Case __Lang_Get('ACTION_IGNORE', 'Ignore')
			GUICtrlSetData($mInput_Destination, "-")
			GUICtrlSetState($mInput_Destination, $GUI_DISABLE)
			GUICtrlSetState($mButton_Destination, $GUI_DISABLE)
			GUICtrlSetState($mButton_Env, $GUI_DISABLE)
		Case __Lang_Get('ACTION_OPEN_WITH', 'Open With')
			GUICtrlSetTip($mInput_Destination, $mDestination_Label[3], $mDestination_Label[1], 0)
		Case __Lang_Get('ACTION_LIST', 'List')
			GUICtrlSetState($mInput_Destination, $GUI_HIDE)
			GUICtrlSetState($mInput_List, $GUI_SHOW)
			GUICtrlSetState($mButton_List, $GUI_SHOW)
		Case __Lang_Get('ACTION_RENAME', 'Rename')
			GUICtrlSetState($mInput_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Destination, $GUI_HIDE)
			GUICtrlSetState($mInput_Rename, $GUI_SHOW)
		Case __Lang_Get('ACTION_DELETE', 'Delete')
			GUICtrlSetData($mInput_Destination, "-")
			GUICtrlSetState($mInput_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Env, $GUI_HIDE)
			GUICtrlSetState($mCombo_Delete, $GUI_SHOW)
			$mCurrentDelete = $mDestination
	EndSwitch
	GUICtrlSetData($mCombo_Action, $mCombo_ActionData, $mCurrentAction)
	GUICtrlSetData($mCombo_Delete, $mCombo_DeleteData, $mCurrentDelete)

	$mSave = GUICtrlCreateButton("&" & __Lang_Get('SAVE', 'Save'), 230 - 70 - 85, 195, 85, 26)
	$mAdd_Action = GUICtrlCreateButton("+", 230 - 18, 196, 36, 24, $BS_ICON)
	GUICtrlSetTip($mAdd_Action, __Lang_Get('?????', 'Add another action'))
	GUICtrlSetImage($mAdd_Action, @ScriptFullPath, -9, 0)
	GUICtrlSetState($mAdd_Action, $GUI_HIDE) ; <<<<<<<<<<< Temporarily Disabled.
	$mCancel = GUICtrlCreateButton("&" & __Lang_Get('CANCEL', 'Cancel'), 230 + 70, 195, 85, 26)
	GUICtrlSetState($mSave, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)
	ControlClick($mGUI, "", $mInput_Name)

	While 1
		; Enable/Disable Destination Input And Switch Folder/Program Label:
		If GUICtrlRead($mCombo_Action) <> $mCurrentAction And _GUICtrlComboBox_GetDroppedState($mCombo_Action) = False Then
			$mCurrentAction = GUICtrlRead($mCombo_Action)
			Switch $mCurrentAction
				Case __Lang_Get('ACTION_DELETE', 'Delete')
					GUICtrlSetState($mInput_Destination, $GUI_HIDE)
					GUICtrlSetState($mButton_Destination, $GUI_HIDE)
					GUICtrlSetState($mButton_Env, $GUI_HIDE)
					GUICtrlSetState($mInput_Rename, $GUI_HIDE)
					GUICtrlSetState($mInput_List, $GUI_HIDE)
					GUICtrlSetState($mButton_List, $GUI_HIDE)
					GUICtrlSetState($mCombo_Delete, $GUI_SHOW)
					If GUICtrlRead($mInput_Destination) == "" Then
						GUICtrlSetData($mInput_Destination, "-")
					EndIf
					If GUICtrlRead($mInput_Rename) == "" Then
						GUICtrlSetData($mInput_Rename, $mRename_Default)
					EndIf
					If GUICtrlRead($mInput_List) == "" Then
						GUICtrlSetData($mInput_List, "-")
					EndIf
				Case __Lang_Get('ACTION_IGNORE', 'Ignore')
					GUICtrlSetState($mInput_Destination, $GUI_DISABLE + $GUI_SHOW)
					GUICtrlSetState($mButton_Destination, $GUI_DISABLE + $GUI_SHOW)
					GUICtrlSetState($mButton_Env, $GUI_DISABLE + $GUI_SHOW)
					GUICtrlSetState($mInput_Rename, $GUI_HIDE)
					GUICtrlSetState($mInput_List, $GUI_HIDE)
					GUICtrlSetState($mButton_List, $GUI_HIDE)
					GUICtrlSetState($mCombo_Delete, $GUI_HIDE)
					If GUICtrlRead($mInput_Destination) == "" Then
						GUICtrlSetData($mInput_Destination, "-")
					EndIf
					If GUICtrlRead($mInput_Rename) == "" Then
						GUICtrlSetData($mInput_Rename, $mRename_Default)
					EndIf
					If GUICtrlRead($mInput_List) == "" Then
						GUICtrlSetData($mInput_List, "-")
					EndIf
				Case __Lang_Get('ACTION_RENAME', 'Rename')
					GUICtrlSetState($mInput_Destination, $GUI_HIDE)
					GUICtrlSetState($mButton_Destination, $GUI_HIDE)
					GUICtrlSetState($mButton_Env, $GUI_ENABLE + $GUI_SHOW)
					GUICtrlSetState($mInput_Rename, $GUI_SHOW)
					GUICtrlSetState($mInput_List, $GUI_HIDE)
					GUICtrlSetState($mButton_List, $GUI_HIDE)
					GUICtrlSetState($mCombo_Delete, $GUI_HIDE)
					If GUICtrlRead($mInput_Destination) == "" Then
						GUICtrlSetData($mInput_Destination, "-")
					EndIf
					If GUICtrlRead($mInput_List) == "" Then
						GUICtrlSetData($mInput_List, "-")
					EndIf
				Case __Lang_Get('ACTION_LIST', 'List')
					GUICtrlSetState($mInput_Destination, $GUI_HIDE)
					GUICtrlSetState($mButton_Destination, $GUI_ENABLE + $GUI_SHOW)
					GUICtrlSetState($mButton_Env, $GUI_ENABLE + $GUI_SHOW)
					GUICtrlSetState($mInput_Rename, $GUI_HIDE)
					GUICtrlSetState($mInput_List, $GUI_SHOW)
					GUICtrlSetState($mButton_List, $GUI_SHOW)
					GUICtrlSetState($mCombo_Delete, $GUI_HIDE)
					If GUICtrlRead($mInput_Destination) == "" Then
						GUICtrlSetData($mInput_Destination, "-")
					EndIf
					If GUICtrlRead($mInput_List) == "-" Then
						GUICtrlSetData($mInput_List, "")
					EndIf
				Case Else
					GUICtrlSetState($mInput_Destination, $GUI_ENABLE + $GUI_SHOW)
					GUICtrlSetState($mButton_Destination, $GUI_ENABLE + $GUI_SHOW)
					GUICtrlSetState($mButton_Env, $GUI_ENABLE + $GUI_SHOW)
					GUICtrlSetState($mInput_Rename, $GUI_HIDE)
					GUICtrlSetState($mInput_List, $GUI_HIDE)
					GUICtrlSetState($mButton_List, $GUI_HIDE)
					GUICtrlSetState($mCombo_Delete, $GUI_HIDE)
					If GUICtrlRead($mInput_Destination) == "-" Then
						GUICtrlSetData($mInput_Destination, "")
					EndIf
					If GUICtrlRead($mInput_Rename) == "" Then
						GUICtrlSetData($mInput_Rename, $mRename_Default)
					EndIf
					If GUICtrlRead($mInput_List) == "" Then
						GUICtrlSetData($mInput_List, "-")
					EndIf
			EndSwitch
			Switch $mCurrentAction
				Case __Lang_Get('ACTION_OPEN_WITH', 'Open With')
					GUICtrlSetTip($mInput_Destination, $mDestination_Label[3], $mDestination_Label[1], 0)
				Case Else
					GUICtrlSetTip($mInput_Destination, $mDestination_Label[3], $mDestination_Label[0], 0)
			EndSwitch
		EndIf

		; Enable/Disable Save Button:
		If GUICtrlRead($mInput_Name) <> "" And GUICtrlRead($mInput_Rules) <> "" And GUICtrlRead($mInput_Destination) <> "" And GUICtrlRead($mInput_Rename) <> "" And GUICtrlRead($mInput_List) <> "" And __StringIsValid(GUICtrlRead($mInput_Destination)) And __StringIsValid(GUICtrlRead($mInput_Rename)) And __StringIsValid(GUICtrlRead($mInput_List)) And Not StringIsSpace(GUICtrlRead($mInput_Rules)) Then
			If GUICtrlGetState($mSave) > 80 Then
				GUICtrlSetState($mSave, 576) ; $GUI_ENABLE + $GUI_DEFBUTTON.
			EndIf
			If GUICtrlGetState($mCancel) = 512 Then
				GUICtrlSetState($mCancel, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
		ElseIf GUICtrlRead($mInput_Name) = "" Or GUICtrlRead($mInput_Rules) = "" Or GUICtrlRead($mInput_Destination) = "" Or GUICtrlRead($mInput_Rename) = "" Or GUICtrlRead($mInput_List) = "" Or __StringIsValid(GUICtrlRead($mInput_Destination)) = 0 Or __StringIsValid(GUICtrlRead($mInput_Rename)) = 0 Or __StringIsValid(GUICtrlRead($mInput_List)) = 0 Or StringIsSpace(GUICtrlRead($mInput_Rules)) Then
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
				$mInput_DestinationRead = GUICtrlRead($mInput_Destination)
				$mInput_RulesRead = GUICtrlRead($mInput_Rules)
				$mCurrentActionString = __GetAssociationString($mCurrentAction) ; Convert Action Name To Action Code.

				If StringLeft($mInput_RulesRead, 1) = "[" Then ; Fix Rules That Start With [ Character.
					$mInput_RulesRead = "*" & $mInput_RulesRead
					If StringInStr($mInput_RulesRead, "**") Then
						$mInput_RulesRead = "*" & $mInput_RulesRead
					EndIf
				EndIf

				If StringInStr($mInput_RulesRead, "*") = 0 Then ; Fix Rules Without * Characters.
					$mInput_RulesRead = "*" & $mInput_RulesRead
					If StringInStr($mInput_RulesRead, ".") = 0 Then
						$mInput_RulesRead = "*" & $mInput_RulesRead
					EndIf
				EndIf

				Switch $mCurrentActionString
					Case "$4" ; Extract.
						If StringInStr($mInput_RulesRead, "**") Then
							MsgBox(0x30, __Lang_Get('MANAGE_EDIT_MSGBOX_4', 'Association Error'), __Lang_Get('MANAGE_EDIT_MSGBOX_11', 'You cannot use this action for folders.'), 0, __OnTop($mGUI))
							ContinueLoop
						EndIf
					Case "$5" ; Open With.
						If __IsSupported($mInput_DestinationRead, "bat;cmd;com;exe;pif") = 0 Or StringInStr($mInput_DestinationRead, "DropIt.exe") Then ; DropIt.exe Is Excluded To Avoid Loops.
							If StringInStr($mInput_DestinationRead, "%DefaultProgram%") = 0 Then
								MsgBox(0x30, __Lang_Get('MANAGE_EDIT_MSGBOX_0', 'Destination Error'), __Lang_Get('MANAGE_EDIT_MSGBOX_1', 'You must specify a valid destination.'), 0, __OnTop($mGUI))
								ContinueLoop
							EndIf
						EndIf
					Case "$8" ; List.
						$mInput_DestinationRead = GUICtrlRead($mInput_List)
						If __IsSupported($mInput_DestinationRead, "html;htm;txt;csv;xml") = 0 Then
							MsgBox(0x30, __Lang_Get('MANAGE_EDIT_MSGBOX_0', 'Destination Error'), __Lang_Get('MANAGE_EDIT_MSGBOX_1', 'You must specify a valid destination.'), 0, __OnTop($mGUI))
							ContinueLoop
						EndIf
					Case "$6" ; Delete.
						$mCurrentDelete = GUICtrlRead($mCombo_Delete)
						Switch $mCurrentDelete
							Case __Lang_Get('DELETE_MODE_2', 'Safely Erase')
								$mInput_DestinationRead = 2
							Case __Lang_Get('DELETE_MODE_3', 'Send to Recycle Bin')
								$mInput_DestinationRead = 3
							Case Else ; Normally Delete.
								$mInput_DestinationRead = 1
						EndSwitch
					Case "$7" ; Rename.
						$mInput_DestinationRead = GUICtrlRead($mInput_Rename)
					Case "$2" ; Ignore.
						$mInput_DestinationRead = "-"
				EndSwitch

				If StringInStr($mInput_RulesRead, "*") And StringInStr(StringRight($mInput_RulesRead, 2), "$") = 0 And StringInStr($mInput_RulesRead, "|") = 0 And StringInStr($mInput_DestinationRead, "|") = 0 And StringInStr($mInput_NameRead, "|") = 0 Then
					$mMsgBox = 6
					If IniRead($mProfile[0], "Associations", $mInput_RulesRead & $mCurrentActionString, "") <> "" Then
						If $mInput_RulesRead <> $mInput_RuleData Then
							$mMsgBox = MsgBox(0x04, __Lang_Get('MANAGE_EDIT_MSGBOX_2', 'Replace association'), __Lang_Get('MANAGE_EDIT_MSGBOX_3', 'This association already exists. Do you want to replace it?'), 0, __OnTop())
						EndIf
						If $mMsgBox = 6 Then
							IniDelete($mProfile[0], "Associations", $mInput_RulesRead & $mCurrentActionString)
						EndIf
					EndIf

					If $mMsgBox = 6 Then
						If $mNewAssociation = 0 Then
							$mInput_RuleData = __GetAssociationString($mInitialAction, $mInput_RuleData) ; Get Association String.
							IniDelete($mProfile[0], "Associations", $mInput_RuleData)
						EndIf
						$mInput_DestinationRead &= "|" & $mInput_NameRead & "|"
						If $mFilters[0][1] <> "" Then ; Filters Defined.
							For $A = 0 To 3
								If $A <> 0 Then
									$mInput_DestinationRead &= ";"
								EndIf
								$mInput_DestinationRead &= $mFilters[$A][0] & $mFilters[$A][1] & $mFilters[$A][2] & $mFilters[$A][3]
							Next
						EndIf
						If $mState Then
							$mInput_DestinationRead &= "|Enabled"
						Else
							$mInput_DestinationRead &= "|Disabled"
						EndIf
						$mInput_DestinationRead &= "|" & $mListProperties
						__IniWriteEx($mProfile[0], "Associations", $mInput_RulesRead & $mCurrentActionString, $mInput_DestinationRead)
						__Log_Write($mLogAssociation, $mInput_NameRead)
						$mChanged = 1
						ExitLoop
					EndIf
				Else
					MsgBox(0x30, __Lang_Get('MANAGE_EDIT_MSGBOX_4', 'Association Error'), __Lang_Get('MANAGE_EDIT_MSGBOX_5', 'You have to insert correct rules for this association ("$", "?", "|" characters cannot be used)'), 0, __OnTop())
				EndIf

			Case $mButton_Rules
				MsgBox(0, __Lang_Get('MANAGE_EDIT_MSGBOX_6', 'Supported Rules'), __Lang_Get('MANAGE_EDIT_MSGBOX_7', 'Examples of supported rules for files:  @LF  *.jpg   = all files with "jpg" extension  @LF  penguin*.*   = all files that begin with "penguin"  @LF  *penguin*   = all files that contain "penguin"  @LF  C:\Desktop\*.jpg   = all "jpg" files from "Desktop"  @LF  @LF  Examples of supported rules for folders:  @LF  robot**   = all folders that begin with "robot"  @LF  **robot**   = all folders that contain "robot"  @LF  C:\**\robot   = all "robot" folders from a "C:" subfolder  @LF  @LF  Separate several rules in an association with ";" to  @LF  create multi-rule associations (eg:  *.jpg;*.png ).'), 0, __OnTop())

			Case $mButton_Filters
				$mFilters = _Manage_Filters($mGUI, $mFilters)

			Case $mButton_List
				$mListProperties = _Manage_List($mGUI, $mListProperties)

			Case $mButton_Destination
				$mInput_Current = $mInput_Destination
				If $mCurrentAction == __Lang_Get('ACTION_LIST', 'List') Then
					$mInput_Current = $mInput_List
				EndIf
				$mFolder = GUICtrlRead($mInput_Current)
				Switch $mCurrentAction
					Case __Lang_Get('ACTION_OPEN_WITH', 'Open With')
						$mFolder = FileOpenDialog(__Lang_Get('MANAGE_DESTINATION_PROGRAM_SELECT', 'Select a destination program:'), @ScriptDir, __Lang_Get('MANAGE_EDIT_MSGBOX_10', 'Executable or Script') & " (*.exe;*.bat;*.cmd;*.com;*.pif)", 1, $mFolder, $mGUI)
						If @error Then
							$mFolder = ""
						EndIf
					Case __Lang_Get('ACTION_LIST', 'List')
						$mListName = $mFolder
						Switch __GetFileExtension($mFolder)
							Case "html", "htm"
								$mListType = 1
							Case "txt"
								$mListType = 2
							Case "csv"
								$mListType = 3
							Case "xml"
								$mListType = 4
							Case Else
								$mListType = 1
								$mListName = __Lang_Get('MANAGE_DESTINATION_FILE_NAME', 'DropIt List')
						EndSwitch
						$mListName = _WinAPI_GetSaveFileName(__Lang_Get('MANAGE_DESTINATION_FILE_SELECT', 'Choose a destination file:'), "HTML (*.html;*.htm)|TXT (*.txt)|CSV (*.csv)|XML (*.xml)", @DesktopDir, $mListName, "html", $mListType, 0, 0, $mGUI)
						If $mListName[0] = 2 Then
							If _WinAPI_PathIsDirectory($mListName[1]) Then
								$mFolder = $mListName[1] & "\" & $mListName[2]
							EndIf
						EndIf
					Case Else
						$mFolder = FileSelectFolder(__Lang_Get('MANAGE_DESTINATION_FOLDER_SELECT', 'Select a destination folder:'), "", 3, $mFolder, $mGUI)
						$mFolder = _WinAPI_PathRemoveBackslash($mFolder)
				EndSwitch
				If __Is("ConvertPath") Then
					Local $mRelative = __GetRelativePath($mFolder)
					$mFolder = $mRelative
				EndIf
				If $mFolder <> "" Then
					GUICtrlSetData($mInput_Current, $mFolder)
				EndIf

			Case $mButton_Env
				$mEnvVar = _Manage_EnvVars($mGUI)
				If $mEnvVar <> -1 Then
					Switch $mCurrentAction
						Case __Lang_Get('ACTION_RENAME', 'Rename')
							GUICtrlSetData($mInput_Rename, GUICtrlRead($mInput_Rename) & "%" & $mEnvVar & "%")
						Case __Lang_Get('ACTION_LIST', 'List')
							GUICtrlSetData($mInput_List, GUICtrlRead($mInput_List) & "%" & $mEnvVar & "%")
						Case Else
							GUICtrlSetData($mInput_Destination, GUICtrlRead($mInput_Destination) & "%" & $mEnvVar & "%")
					EndSwitch
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
	Local $mMsgBox, $mName, $mAssociation, $mCurrentAction

	$mName = _GUICtrlListView_GetItemText($mListView, $mIndex)
	$mAssociation = _GUICtrlListView_GetItemText($mListView, $mIndex, 1)
	$mCurrentAction = _GUICtrlListView_GetItemText($mListView, $mIndex, 2)
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
		$mMsgBox = MsgBox(0x04, __Lang_Get('MANAGE_DELETE_MSGBOX_0', 'Delete association'), __Lang_Get('MANAGE_DELETE_MSGBOX_1', 'Selected association:') & "  " & $mAssociation & @LF & __Lang_Get('MANAGE_DELETE_MSGBOX_2', 'Are you sure to delete this association?'), 0, __OnTop())
	EndIf
	If $mMsgBox <> 6 Then
		Return SetError(1, 0, 0)
	EndIf

	$mAssociation = __GetAssociationString($mCurrentAction, $mAssociation) ; Get Association String.
	IniDelete($mProfile, "Associations", $mAssociation)
	_GUICtrlListView_DeleteItem($mListView, $mIndex)
	__Log_Write(__Lang_Get('MANAGE_LOG_2', 'Association Removed'), $mName)

	$Global_ListViewIndex = -1
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_Manage_Delete

Func _Manage_EnvVars($mHandle = -1)
	Local $mGUI, $mClose, $mMsg, $mValue
	Local $mOnly = __Lang_Get('ENV_VAR_LABEL_1', '° supported only by Open With action')
	Local $mEV_File[7][4] = [ _
			[6, 4], _
			["File", __Lang_Get('ENV_VAR_7', 'file full path ° ["C:\Docs\Text.txt"]'), 1], _
			["FileAuthor", __Lang_Get('ENV_VAR_8', 'file author ["Lupo Team"]'), 0], _
			["FileExt", __Lang_Get('ENV_VAR_9', 'file extension ["txt"]'), 0], _
			["FileName", __Lang_Get('ENV_VAR_10', 'file name without extension ["Text"]'), 0], _
			["FileNameExt", __Lang_Get('ENV_VAR_11', 'file name with extension ["Text.txt"]'), 0], _
			["FileType", __Lang_Get('ENV_VAR_12', 'file type ["Text document"]'), 0]]
	Local $mEV_Date[7][4] = [ _
			[6, 4], _
			["CurrentDate", __Lang_Get('ENV_VAR_0', 'current date ["2011-05-16"]'), 0], _
			["CurrentTime", __Lang_Get('ENV_VAR_1', 'current time ["19.40.32"]'), 0], _
			["DateCreated", __Lang_Get('ENV_VAR_2', 'date file creation ["2011-05-16"]'), 0], _
			["DateModified", __Lang_Get('ENV_VAR_3', 'date file modification ["2011-05-16"]'), 0], _
			["DateOpened", __Lang_Get('ENV_VAR_4', 'date file last access ["2011-05-16"]'), 0], _
			["DateTaken", __Lang_Get('ENV_VAR_5', 'date picture taken ["2011-05-16"]'), 0]]
	Local $mEV_Music[7][4] = [ _
			[6, 4], _
			["SongAlbum", __Lang_Get('ENV_VAR_15', 'song album ["The Wall"]'), 0], _
			["SongArtist", __Lang_Get('ENV_VAR_16', 'song artist ["Pink Floyd"]'), 0], _
			["SongGenre", __Lang_Get('ENV_VAR_17', 'song genre ["Rock"]'), 0], _
			["SongNumber", __Lang_Get('ENV_VAR_18', 'song track number ["3"]'), 0], _
			["SongTitle", __Lang_Get('ENV_VAR_19', 'song title ["Hey You"]'), 0], _
			["SongYear", __Lang_Get('ENV_VAR_20', 'song year ["1979"]'), 0]]
	Local $mEV_Other[7][4] = [ _
			[6, 4], _
			["DefaultProgram", __Lang_Get('ENV_VAR_6', 'system default program ° [Notepad]'), 1], _
			["Desktop", __Lang_Get('ENV_VAR_22', 'Desktop path ["C:\Users\Name\Desktop"]'), 0], _
			["Documents", __Lang_Get('ENV_VAR_23', 'Documents path ["C:\Users\Name\Documents"]'), 0], _
			["ParentDir", __Lang_Get('ENV_VAR_13', 'directory of each loaded item ["C:\Docs"]'), 0], _
			["PortableDrive", __Lang_Get('ENV_VAR_14', 'drive letter of DropIt ["E:"]'), 0], _
			["SubDir", __Lang_Get('ENV_VAR_21', 'recreate subdirectory structure ["\SubFolder"]'), 0]]

	$mGUI = GUICreate(__Lang_Get('MANAGE_EDIT_MSGBOX_8', 'Internal Environment Variables'), 420, 195, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	GUICtrlCreateTab(0, 0, 420, 160) ; Create Tab Menu.

	; File Tab:
	GUICtrlCreateTabItem(__Lang_Get('ENV_VAR_TAB_0', 'File'))
	GUICtrlSetState(-1, $GUI_SHOW) ; Show This Tab At Options Opening.
	For $A = 1 To $mEV_File[0][0]
		$mEV_File[$A][3] = GUICtrlCreateLabel("%" & $mEV_File[$A][0] & "%", 10, 12 + 20 * $A, 100, 20)
		GUICtrlSetFont($mEV_File[$A][3], 8.5, 400, 4)
		GUICtrlSetCursor($mEV_File[$A][3], 0)
		GUICtrlCreateLabel("= " & $mEV_File[$A][1], 10 + 110, 12 + 20 * $A, 300, 20)
		If $mEV_File[$A][2] Then
			GUICtrlSetTip(-1, $mOnly)
		EndIf
	Next

	; Date Tab:
	GUICtrlCreateTabItem(__Lang_Get('ENV_VAR_TAB_1', 'Date'))
	For $A = 1 To $mEV_Date[0][0]
		$mEV_Date[$A][3] = GUICtrlCreateLabel("%" & $mEV_Date[$A][0] & "%", 10, 12 + 20 * $A, 100, 20)
		GUICtrlSetFont($mEV_Date[$A][3], 8.5, 400, 4)
		GUICtrlSetCursor($mEV_Date[$A][3], 0)
		GUICtrlCreateLabel("= " & $mEV_Date[$A][1], 10 + 110, 12 + 20 * $A, 300, 20)
		If $mEV_Date[$A][2] Then
			GUICtrlSetTip(-1, $mOnly)
		EndIf
	Next

	; Music Tab:
	GUICtrlCreateTabItem(__Lang_Get('ENV_VAR_TAB_2', 'Music'))
	For $A = 1 To $mEV_Music[0][0]
		$mEV_Music[$A][3] = GUICtrlCreateLabel("%" & $mEV_Music[$A][0] & "%", 10, 12 + 20 * $A, 100, 20)
		GUICtrlSetFont($mEV_Music[$A][3], 8.5, 400, 4)
		GUICtrlSetCursor($mEV_Music[$A][3], 0)
		GUICtrlCreateLabel("= " & $mEV_Music[$A][1], 10 + 110, 12 + 20 * $A, 300, 20)
		If $mEV_Music[$A][2] Then
			GUICtrlSetTip(-1, $mOnly)
		EndIf
	Next

	; Other Tab:
	GUICtrlCreateTabItem(__Lang_Get('ENV_VAR_TAB_3', 'Other'))
	For $A = 1 To $mEV_Other[0][0]
		$mEV_Other[$A][3] = GUICtrlCreateLabel("%" & $mEV_Other[$A][0] & "%", 10, 12 + 20 * $A, 100, 20)
		GUICtrlSetFont($mEV_Other[$A][3], 8.5, 400, 4)
		GUICtrlSetCursor($mEV_Other[$A][3], 0)
		GUICtrlCreateLabel("= " & $mEV_Other[$A][1], 10 + 110, 12 + 20 * $A, 300, 20)
		If $mEV_Other[$A][2] Then
			GUICtrlSetTip(-1, $mOnly)
		EndIf
	Next

	GUICtrlCreateTabItem("") ; Close Tab Menu.

	$mClose = GUICtrlCreateButton("&" & __Lang_Get('CLOSE', 'Close'), 210 - 45, 164, 90, 26)
	GUICtrlSetState($mClose, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)

	While 1
		$mMsg = GUIGetMsg()
		Switch $mMsg
			Case $GUI_EVENT_CLOSE, $mClose
				$mValue = -1
				ExitLoop

			Case Else
				If $mMsg >= $mEV_File[1][3] And $mMsg <= $mEV_File[$mEV_File[0][0]][3] Then
					For $A = 1 To $mEV_File[0][0]
						If $mMsg = $mEV_File[$A][3] Then
							$mValue = $mEV_File[$A][0]
							ExitLoop 2
						EndIf
					Next
				ElseIf $mMsg >= $mEV_Date[1][3] And $mMsg <= $mEV_Date[$mEV_Date[0][0]][3] Then
					For $A = 1 To $mEV_Date[0][0]
						If $mMsg = $mEV_Date[$A][3] Then
							$mValue = $mEV_Date[$A][0]
							ExitLoop 2
						EndIf
					Next
				ElseIf $mMsg >= $mEV_Music[1][3] And $mMsg <= $mEV_Music[$mEV_Music[0][0]][3] Then
					For $A = 1 To $mEV_Music[0][0]
						If $mMsg = $mEV_Music[$A][3] Then
							$mValue = $mEV_Music[$A][0]
							ExitLoop 2
						EndIf
					Next
				ElseIf $mMsg >= $mEV_Other[1][3] And $mMsg <= $mEV_Other[$mEV_Other[0][0]][3] Then
					For $A = 1 To $mEV_Other[0][0]
						If $mMsg = $mEV_Other[$A][3] Then
							$mValue = $mEV_Other[$A][0]
							ExitLoop 2
						EndIf
					Next
				EndIf

		EndSwitch
	WEnd
	GUIDelete($mGUI)

	Return $mValue
EndFunc   ;==>_Manage_EnvVars

Func _Manage_ExtractFilters($mProfile, $mAssociation, $mAction)
	Local $mAssociationSplit, $mStringSplit, $mFilters[4][4], $mNumberFields = 5

	$mAssociation = __GetAssociationString($mAction, $mAssociation) ; Get Association String.
	$mAssociationSplit = StringSplit(IniRead($mProfile, "Associations", $mAssociation, ""), "|")
	ReDim $mAssociationSplit[$mNumberFields + 1]
	$mStringSplit = StringSplit($mAssociationSplit[3], ";")
	If @error Then
		Return SetError(1, 0, $mFilters)
	EndIf
	ReDim $mStringSplit[5] ; Number Of Filters.

	For $A = 0 To 3
		$mFilters[$A][0] = StringLeft($mStringSplit[$A + 1], 1)
		$mFilters[$A][1] = StringLeft(StringTrimLeft($mStringSplit[$A + 1], 1), 1)
		$mFilters[$A][2] = StringRegExpReplace(StringTrimLeft($mStringSplit[$A + 1], 2), "[^0-9]", "")
		$mFilters[$A][3] = StringTrimLeft($mStringSplit[$A + 1], 2 + StringLen($mFilters[$A][2]))
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
			GUICtrlSetData($mGUI_Items[$A][3], "bytes|KB|MB|GB", $mFilters[$A][3])
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

	$mSave = GUICtrlCreateButton("&" & __Lang_Get('OK', 'OK'), 185 - 40 - 85, 145, 85, 24)
	$mCancel = GUICtrlCreateButton("&" & __Lang_Get('CANCEL', 'Cancel'), 185 + 40, 145, 85, 24)
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

Func _Manage_List($mHandle, $mProperties)
	Local $mGUI, $mAdd, $mRemove, $mUp, $mDown, $mSave, $mCancel, $mNumberProperties = 32
	Local $mList_Available, $mList_Listed, $mIndex, $mString, $mStringSplit, $mNewProperties

	$mGUI = GUICreate(__Lang_Get('LIST_SELECT_0', 'Select Properties'), 370, 240, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))
	GUICtrlCreateLabel(__Lang_Get('LIST_SELECT_1', 'Available Properties') & ":", 15, 10, 140, 20)
	GUICtrlCreateLabel(__Lang_Get('LIST_SELECT_2', 'Used Properties') & ":", 15 + 205, 10, 140, 20)
	$mList_Available = GUICtrlCreateList("", 10, 30, 150, 170, 0x00210000) ; $LBS_NOTIFY + $WS_VSCROLL.
	$mList_Listed = GUICtrlCreateList("", 10 + 200, 30, 150, 170, 0x00210000) ; $LBS_NOTIFY + $WS_VSCROLL.

	$mStringSplit = StringSplit($mProperties, ";")
	For $A = 1 To $mStringSplit[0]
		$mString = __List_GetProperty($mStringSplit[$A])
		If @error = 0 Then ; Supported Number.
			$mIndex = _GUICtrlListBox_InsertString($mList_Listed, $mString)
		EndIf
	Next

	For $A = 0 To $mNumberProperties
		$mString = __List_GetProperty($A)
		If @error = 0 Then ; Supported Number.
			$mIndex = _GUICtrlListBox_FindString($mList_Listed, $mString, True)
			If $mIndex = -1 Then
				_GUICtrlListBox_InsertString($mList_Available, $mString)
			EndIf
		EndIf
	Next

	$mAdd = GUICtrlCreateButton("+", 185 - 13, 40, 26, 26, $BS_ICON)
	GUICtrlSetTip($mAdd, __Lang_Get('OPTIONS_BUTTON_4', 'Add'))
	GUICtrlSetImage($mAdd, @ScriptFullPath, -13, 0)
	$mRemove = GUICtrlCreateButton("-", 185 - 13, 40 + 36, 26, 26, $BS_ICON)
	GUICtrlSetTip($mRemove, __Lang_Get('OPTIONS_BUTTON_3', 'Remove'))
	GUICtrlSetImage($mRemove, @ScriptFullPath, -14, 0)
	$mUp = GUICtrlCreateButton("U", 185 - 13, 40 + 36 * 2, 26, 26, $BS_ICON)
	GUICtrlSetTip($mUp, __Lang_Get('OPTIONS_BUTTON_6', 'Up'))
	GUICtrlSetImage($mUp, @ScriptFullPath, -15, 0)
	$mDown = GUICtrlCreateButton("D", 185 - 13, 40 + 36 * 3, 26, 26, $BS_ICON)
	GUICtrlSetTip($mDown, __Lang_Get('OPTIONS_BUTTON_7', 'Down'))
	GUICtrlSetImage($mDown, @ScriptFullPath, -16, 0)

	$mSave = GUICtrlCreateButton("&" & __Lang_Get('SAVE', 'Save'), 185 - 40 - 85, 205, 85, 24)
	$mCancel = GUICtrlCreateButton("&" & __Lang_Get('CANCEL', 'Cancel'), 185 + 40, 205, 85, 24)
	GUICtrlSetState($mSave, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)

	Local $mHotKeys[5][2] = [["{RIGHT}", $mAdd],["{LEFT}", $mRemove],["{UP}", $mUp],["{DOWN}", $mDown],["{DELETE}", $mRemove]]
	GUISetAccelerators($mHotKeys)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $mCancel
				ExitLoop

			Case $mAdd
				$mIndex = _GUICtrlListBox_GetCurSel($mList_Available)
				If $mIndex <> -1 Then
					$mString = _GUICtrlListBox_GetText($mList_Available, $mIndex)
					_GUICtrlListBox_DeleteString($mList_Available, $mIndex)
					_GUICtrlListBox_InsertString($mList_Listed, $mString)
					If $mIndex = _GUICtrlListBox_GetCount($mList_Available) Then
						$mIndex -= 1
					EndIf
					_GUICtrlListBox_SetCurSel($mList_Available, $mIndex)
				EndIf

			Case $mRemove
				$mIndex = _GUICtrlListBox_GetCurSel($mList_Listed)
				If $mIndex <> -1 Then
					$mString = _GUICtrlListBox_GetText($mList_Listed, $mIndex)
					_GUICtrlListBox_DeleteString($mList_Listed, $mIndex)
					_GUICtrlListBox_InsertString($mList_Available, $mString)
					If $mIndex = _GUICtrlListBox_GetCount($mList_Listed) Then
						$mIndex -= 1
					EndIf
					_GUICtrlListBox_SetCurSel($mList_Listed, $mIndex)
				EndIf

			Case $mUp
				$mIndex = _GUICtrlListBox_GetCurSel($mList_Listed)
				If $mIndex > 0 Then
					$mString = _GUICtrlListBox_GetText($mList_Listed, $mIndex)
					_GUICtrlListBox_DeleteString($mList_Listed, $mIndex)
					_GUICtrlListBox_InsertString($mList_Listed, $mString, $mIndex - 1)
					_GUICtrlListBox_SetCurSel($mList_Listed, $mIndex - 1)
				EndIf

			Case $mDown
				$mIndex = _GUICtrlListBox_GetCurSel($mList_Listed)
				If $mIndex <> -1 And $mIndex < _GUICtrlListBox_GetCount($mList_Listed) - 1 Then
					$mString = _GUICtrlListBox_GetText($mList_Listed, $mIndex)
					_GUICtrlListBox_DeleteString($mList_Listed, $mIndex)
					_GUICtrlListBox_InsertString($mList_Listed, $mString, $mIndex + 1)
					_GUICtrlListBox_SetCurSel($mList_Listed, $mIndex + 1)
				EndIf

			Case $mSave
				For $A = 0 To _GUICtrlListBox_GetCount($mList_Listed) - 1
					$mString = _GUICtrlListBox_GetText($mList_Listed, $A)
					For $B = 0 To $mNumberProperties
						If $mString == __List_GetProperty($B) Then
							$mNewProperties &= $B & ";"
						EndIf
					Next
				Next
				$mNewProperties = StringTrimRight($mNewProperties, 1) ; To Remove The Last ";" Character.
				If $mNewProperties <> "" Then
					$mProperties = $mNewProperties
				EndIf
				ExitLoop

		EndSwitch
	WEnd
	GUIDelete($mGUI)

	Return $mProperties
EndFunc   ;==>_Manage_List

Func _Manage_Paste($mProfilePath, $mProfileString, $mProfileText)
	Local $mMsgBox = 6

	If IniRead($mProfilePath, "Associations", $mProfileString, "") <> "" Then ; Association Already Exists.
		$mMsgBox = MsgBox(0x04, __Lang_Get('MANAGE_EDIT_MSGBOX_2', 'Replace association'), __Lang_Get('MANAGE_EDIT_MSGBOX_3', 'This association already exists. Do you want to replace it?'), 0, __OnTop())
	EndIf
	If $mMsgBox = 6 Then
		__IniWriteEx($mProfilePath, "Associations", $mProfileString, $mProfileText) ; Add Association To New Profile.
		Return 1
	EndIf

	Return 0
EndFunc   ;==>_Manage_Paste

Func _Manage_Update($mListView, $mProfileName)
	Local $mAssociations, $mFileRules_Association, $mFileRules_Shown, $mAction

	$mAssociations = __GetAssociations($mProfileName) ; Get Associations Array For The Current Profile.

	_GUICtrlListView_BeginUpdate($mListView)
	_GUICtrlListView_DeleteAllItems($mListView)
	For $A = 1 To $mAssociations[0][0]
		$mFileRules_Association = $mAssociations[$A][0]
		$mFileRules_Shown = StringTrimRight($mFileRules_Association, 2)
		$mAction = StringRight($mFileRules_Association, 2)

		If $mAction = "$6" Then
			Switch $mAssociations[$A][1] ; Destination.
				Case 2
					$mAssociations[$A][1] = __Lang_Get('DELETE_MODE_2', 'Safely Erase')
				Case 3
					$mAssociations[$A][1] = __Lang_Get('DELETE_MODE_3', 'Send to Recycle Bin')
				Case Else
					$mAssociations[$A][1] = __Lang_Get('DELETE_MODE_1', 'Normally Delete')
			EndSwitch
		EndIf
		$mAction = __GetAssociationString($mAction) ; Convert Action Code To Action Name.

		_GUICtrlListView_AddItem($mListView, $mAssociations[$A][2], -1, _GUICtrlListView_GetItemCount($mListView) + 9999)
		_GUICtrlListView_AddSubItem($mListView, $A - 1, $mFileRules_Shown, 1)
		_GUICtrlListView_AddSubItem($mListView, $A - 1, $mAction, 2)
		_GUICtrlListView_AddSubItem($mListView, $A - 1, $mAssociations[$A][1], 3)

		If $mAssociations[$A][4] <> "Disabled" Then
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
	Return $mProfileName
EndFunc   ;==>_Manage_Update

Func _GUICtrlListView_ContextMenu_Manage($cmListView, $cmIndex, $cmSubItem)
	Local Enum $cmItem1 = 1000, $cmItem2, $cmItem3, $cmItem4

	If IsHWnd($cmListView) = 0 Then
		$cmListView = GUICtrlGetHandle($cmListView)
	EndIf

	Local $cmContextMenu = _GUICtrlMenu_CreatePopup()
	If $cmIndex <> -1 And $cmSubItem <> -1 Then ; Won't Show These MenuItem(s) Unless An Item Is Selected.
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu, __Lang_Get('EDIT', 'Edit'), $cmItem1)
		__SetItemImage("EDIT", $cmIndex, $cmContextMenu, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu, __Lang_Get('COPYTO', 'Copy to') & "...", $cmItem2)
		__SetItemImage("COPYTO", $cmIndex, $cmContextMenu, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu, "")
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu, __Lang_Get('ACTION_DELETE', 'Delete'), $cmItem3)
		__SetItemImage("DEL", $cmIndex, $cmContextMenu, 2, 1)
	EndIf
	If $cmIndex = -1 And $cmSubItem <> -1 Then ; Will Show These MenuItem(s) If No Item Is Selected.
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu, __Lang_Get('NEW', 'New'), $cmItem4) ; Will Show These MenuItem(s) Regardless.
		__SetItemImage("NEW", $cmIndex, $cmContextMenu, 2, 1)
	EndIf

	Switch _GUICtrlMenu_TrackPopupMenu($cmContextMenu, $cmListView, -1, -1, 1, 1, 2)
		Case $cmItem1
			GUICtrlSendToDummy($Global_ListViewRules_Enter)
		Case $cmItem2
			GUICtrlSendToDummy($Global_ListViewRules_CopyTo)
		Case $cmItem3
			GUICtrlSendToDummy($Global_ListViewRules_Delete)
		Case $cmItem4
			GUICtrlSendToDummy($Global_ListViewRules_New)
	EndSwitch
	_GUICtrlMenu_DestroyMenu($cmContextMenu)
	Return 1
EndFunc   ;==>_GUICtrlListView_ContextMenu_Manage
#EndRegion >>>>> MAIN: Manage Functions <<<<<

#Region >>>>> MAIN: Customize Functions <<<<<
Func _Customize_GUI($cHandle = -1, $cProfileList = -1)
	Local $cGUI, $cProfileDirectory, $cListView, $cListView_Handle, $cNew, $cClose, $cIndex_Selected, $cText, $cImage, $cSizeText, $cTransparency
	Local $cDeleteDummy, $cEnterDummy, $cNewDummy, $cOptionsDummy, $cExampleDummy

	$cProfileDirectory = __GetDefault(2) ; Get Default Profile Directory.
	Local $cSize = __GetCurrentSize("SizeCustom") ; 320 x 200.

	If $cProfileList = -1 Or $cProfileList = 0 Or $cProfileList = "" Then
		$cProfileList = __ProfileList_Get() ; Get Array Of All Profiles.
	EndIf
	If IsArray($cProfileList) = 0 Then
		Return SetError(1, 0, 0) ; Exit Function If No ProfileList.
	EndIf

	$cGUI = GUICreate(__Lang_Get('CUSTOMIZE_GUI', 'Customize Profiles'), $cSize[0], $cSize[1], -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX), -1, __OnTop($cHandle))
	GUISetIcon(@ScriptFullPath, -5, $cGUI) ; Use Custom.ico
	$Global_ResizeWidth = 300 ; Set Default Minimum Width.
	$Global_ResizeHeight = 190 ; Set Default Minimum Height.

	$cListView = GUICtrlCreateListView(__Lang_Get('PROFILE', 'Profile') & "|" & __Lang_Get('IMAGE', 'Image') & "|" & __Lang_Get('SIZE', 'Size') & "|" & __Lang_Get('TRANSPARENCY', 'Transparency'), 0, 0, $cSize[0], $cSize[1] - 35, BitOR($LVS_NOSORTHEADER, $LVS_REPORT, $LVS_SINGLESEL))
	$cListView_Handle = GUICtrlGetHandle($cListView)

	$Global_ListViewProfiles = $cListView_Handle
	GUICtrlSetResizing($cListView, $GUI_DOCKBORDERS)

	Local $cImageList = _GUIImageList_Create(20, 20, 5, 3) ; Create An ImageList.
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
		_GUIToolTip_SetDelayTime($cToolTip, 3, 60) ; Speed Up InfoTip Appearance.
	EndIf

	_Customize_Update($cListView_Handle, $cProfileDirectory, $cProfileList) ; Add/Update Customise GUI With List Of Profiles.
	If @error Then
		SetError(1, 0, 0) ; Exit Function If No Profiles.
	EndIf

	$cDeleteDummy = GUICtrlCreateDummy()
	$Global_ListViewProfiles_Delete = $cDeleteDummy
	$cEnterDummy = GUICtrlCreateDummy()
	$Global_ListViewProfiles_Enter = $cEnterDummy
	$cNewDummy = GUICtrlCreateDummy()
	$Global_ListViewProfiles_New = $cNewDummy
	$cOptionsDummy = GUICtrlCreateDummy()
	$Global_ListViewProfiles_Options = $cOptionsDummy
	$cExampleDummy = GUICtrlCreateDummy()
	$Global_ListViewProfiles_Example[0] = $cExampleDummy

	$cNew = GUICtrlCreateButton("&" & __Lang_Get('NEW', 'New'), 50, $cSize[1] - 31, 74, 25)
	GUICtrlSetTip($cNew, __Lang_Get('CUSTOMIZE_GUI_TIP_0', 'Click to add a profile or Right-click a profile to manage it.'))
	GUICtrlSetResizing($cNew, $GUI_DOCKSIZE + $GUI_DOCKLEFT + $GUI_DOCKBOTTOM)
	$cClose = GUICtrlCreateButton("&" & __Lang_Get('CLOSE', 'Close'), $cSize[0] - 50 - 74, $cSize[1] - 31, 74, 25)
	GUICtrlSetTip($cClose, __Lang_Get('CUSTOMIZE_GUI_TIP_1', 'Save profiles and close the window.'))
	GUICtrlSetResizing($cClose, $GUI_DOCKSIZE + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM)
	GUICtrlSetState($cClose, $GUI_DEFBUTTON)

	$Global_ListViewIndex = -1 ; Set As No Item Selected.
	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
	GUIRegisterMsg($WM_GETMINMAXINFO, "WM_GETMINMAXINFO")
	GUISetState(@SW_SHOW)

	Local $cHotKeys[3][2] = [["^n", $cNewDummy],["{DELETE}", $cDeleteDummy],["{ENTER}", $cEnterDummy]]
	GUISetAccelerators($cHotKeys)

	_WinAPI_EmptyWorkingSet() ; Reduce Memory Usage Of DropIt.
	While 1
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
				$cIndex_Selected = _GUICtrlListView_GetSelectionMark($cListView_Handle)
				_Customize_Delete($cListView_Handle, $cIndex_Selected, $cProfileDirectory, -1, $cGUI) ; Delete Profile From The Default Profile Directory & ListView.

			Case $cOptionsDummy
				$cIndex_Selected = _GUICtrlListView_GetSelectionMark($cListView_Handle)
				$cText = _GUICtrlListView_GetItemText($cListView_Handle, $cIndex_Selected)
				_Customize_Options($cText, $cProfileDirectory, $cGUI) ; Show Profile Options GUI.

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
				If FileExists($cProfileDirectory & $Global_ListViewProfiles_Example[1] & ".ini") Then
					MsgBox(0x30, __Lang_Get('PROFILEUNIQUE_MSGBOX_0', 'Name not available'), __Lang_Get('PROFILEUNIQUE_MSGBOX_1', 'This profile name already exists.'), 0, __OnTop())
					ContinueLoop
				EndIf
				Switch $Global_ListViewProfiles_Example[1]
					Case "Archiver"
						_ResourceSaveToFile($cProfileDirectory & "Archiver.ini", "ARCHIVER")
					Case "Eraser"
						_ResourceSaveToFile($cProfileDirectory & "Eraser.ini", "ERASER")
					Case "Extractor"
						_ResourceSaveToFile($cProfileDirectory & "Extractor.ini", "EXTRACTOR")
				EndSwitch
				_Customize_Update($cListView_Handle, $cProfileDirectory, -1) ; Add/Update Customise GUI With List Of Profiles.

		EndSwitch
	WEnd
	__SetCurrentSize($cGUI, "SizeCustom")
	GUIDelete($cGUI)
	_GUIImageList_Destroy($cImageList)

	__SetCurrentPosition() ; Set Current Coordinates/Position Of DropIt.
	__IsOnTop() ; Set GUI "OnTop" If True.

	$cProfileList = __ProfileList_Get() ; Get Array Of All Profiles.
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
		$cCurrentProfile = 1 ; __IsCurrentProfile() = Check If Selected Profile Is The Current Profile.
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
	GUICtrlSetState($cSave, $GUI_DEFBUTTON)

	$cIcon_GUI = GUICreate("", 0, 0, 200, 24, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_MDICHILD), $cGUI)
	$cIcon_Label = GUICtrlCreateLabel("", 0, 0, 32, 32)
	GUICtrlSetCursor($cIcon_Label, 0)
	GUICtrlSetTip($cIcon_Label, __Lang_Get('CUSTOMIZE_EDIT_TIP_1', 'Select an image for this profile.'))
	Local $cGUISize = __ImageSize($cProfile[8] & $cImage)
	$cGUISize = __ImageRelativeSize(32, 32, $cGUISize[0], $cGUISize[1])
	__SetBitmap($cIcon_GUI, $cProfile[8] & $cImage, 255 / 100 * $cProfile[7], $cGUISize[0], $cGUISize[1]) ; Set Image & Resize To The Image GUI.

	GUISetState(@SW_SHOW, $cGUI)
	GUISetState(@SW_SHOW, $cIcon_GUI)

	GUIRegisterMsg($WM_HSCROLL, "WM_HSCROLL") ; Required For Changing The Label Next To The Slider.
	ControlClick($cGUI, "", $cInput_Name)

	While 1
		; Disable/Enable Save Button:
		If GUICtrlRead($cInput_Name) <> "" And GUICtrlRead($cInput_Image) <> "" And GUICtrlRead($cInput_SizeX) <> "" And GUICtrlRead($cInput_SizeY) <> "" _
				And GUICtrlRead($cInput_Transparency) <> "" And FileExists($cProfileDirectory[2][0] & GUICtrlRead($cInput_Image)) And StringIsSpace(GUICtrlRead($cInput_Name)) = 0 Then
			If GUICtrlGetState($cSave) > 80 Then
				GUICtrlSetState($cSave, 576) ; $GUI_ENABLE + $GUI_DEFBUTTON.
			EndIf
			If GUICtrlGetState($cCancel) = 512 Then
				GUICtrlSetState($cCancel, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
		ElseIf GUICtrlRead($cInput_Name) = "" Or GUICtrlRead($cInput_Image) = "" Or GUICtrlRead($cInput_SizeX) = "" Or GUICtrlRead($cInput_SizeY) = "" _
				Or GUICtrlRead($cInput_Transparency) = "" Or FileExists($cProfileDirectory[2][0] & GUICtrlRead($cInput_Image)) = 0 Or StringIsSpace(GUICtrlRead($cInput_Name)) Then
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
					__ImageWrite($cProfile[1], 7, $cProfile[4], $cProfile[5], $cProfile[6], $cProfile[7]) ; Write Image File Name & Size & Transparency To The Selected Profile.
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
					$cItemText = __IsProfileUnique($cGUI, $cItemText) ; Check If The Selected Profile Name Is Unique.
					If @error Then
						GUICtrlSetData($cInput_Name, "")
						ContinueLoop
					EndIf
				EndIf

				If $cNewProfile = 1 Then
					$cIniWrite = $cProfileDirectory[1][0] & $cItemText & ".ini"
					If FileExists($cIniWrite) = 0 Then
						__IniWriteEx($cIniWrite, "Target", "", "Image=" & $cProfileDirectory[3][0] & @LF & "SizeX=64" & @LF & "SizeY=64" & @LF & "Transparency=100")
						__IniWriteEx($cIniWrite, "General", "", "")
						__IniWriteEx($cIniWrite, "Associations", "", "")
					EndIf
				EndIf

				If $cInitialProfileName <> $cItemText Then
					FileMove($cProfileDirectory[1][0] & $cInitialProfileName & ".ini", $cProfileDirectory[1][0] & $cItemText & ".ini")
					If $cInitialProfileName == __GetCurrentProfile() Then ; Get Current Profile From The Settings INI File.
						__SetCurrentProfile($cItemText) ; Write Selected Profile Name To The Settings INI File.
					EndIf
					$cInitialProfileName = $cItemText
				EndIf

				__ImageWrite($cItemText, 7, GUICtrlRead($cInput_Image), GUICtrlRead($cInput_SizeX), GUICtrlRead($cInput_SizeY), GUICtrlRead($cInput_Transparency)) ; Write Image File Name & Size & Transparency To The Selected Profile.

				$cChanged = 1
				ExitLoop

			Case $cButton_Image, $cIcon_Label
				If StringIsSpace(GUICtrlRead($cInput_Name)) Or GUICtrlRead($cInput_Name) = "" Then ContinueLoop
				$cItemText = StringReplace(StringStripWS(GUICtrlRead($cInput_Name), 7), " ", "_")

				If $cNewProfile = 1 Or $cInitialProfileName <> $cItemText Then
					$cItemText = __IsProfileUnique($cGUI, $cItemText) ; Check If The Selected Profile Name Is Unique.
					If @error Then
						GUICtrlSetData($cInput_Name, $cProfile[1])
						ContinueLoop
					EndIf
				EndIf

				If $cNewProfile = 1 Then
					$cIniWrite = $cProfileDirectory[1][0] & $cItemText & ".ini"
					If FileExists($cIniWrite) = 0 Then
						__IniWriteEx($cIniWrite, "Target", "", "Image=" & $cProfileDirectory[3][0] & @LF & "SizeX=64" & @LF & "SizeY=64" & @LF & "Transparency=100")
						__IniWriteEx($cIniWrite, "General", "", "")
						__IniWriteEx($cIniWrite, "Associations", "", "")
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
				$cReturn = __ImageGet($cGUI, $cItemText) ; Select Image From Default Image Directory Or Custom Directory, It Will Copy To The Default Image Directory If Selected In A Custom Directory.

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
					__GUIInBounds($cGUI_1) ; Check If The GUI Is Within View Of The Users Screen.
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
						__ImageWrite($cItemText, 2, $cImage, $cReturn[0], $cReturn[1], 100) ; Write Size To The Selected Profile.
					EndIf
					__SetBitmap($cIcon_GUI, $cProfileDirectory[2][0] & $cImage, 255 / 100 * 100, 32, 32) ; Set Image & Resize To The Image GUI.
					If $cCurrentProfile = 1 Then
						__SetBitmap($cGUI_1, $cProfileDirectory[2][0] & $cImage, 255 / 100 * 100, $cReturn[0], $cReturn[1]) ; Set Image & Resize To The GUI If Current Profile.
					EndIf
				EndIf
				$cChanged = 1

			Case $cInput_Transparency ; Change The Transparency Of The Current Profile Image Only.
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

Func _Customize_Options($cProfileName, $cProfileDirectory, $cHandle = -1)
	Local $cGUI, $cSave, $cCancel, $cState, $cComboItems[3], $cCurrent[3]
	Local $cINI = $cProfileDirectory & $cProfileName & ".ini"
	Local $cOptions[3] = ["ShowSorting", "DirForFolders", "IgnoreNew"]
	Local $cGroup = __Lang_Get('OPTIONS_PROFILE_MODE_0', 'Use global setting') & "|" & __Lang_Get('OPTIONS_PROFILE_MODE_1', 'Enable for this profile') & "|" & __Lang_Get('OPTIONS_PROFILE_MODE_2', 'Disable for this profile')

	$cGUI = GUICreate(__Lang_Get('OPTIONS_PROFILE', 'Profile Options'), 320, 220, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($cHandle))
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_CHECKBOX_11', 'Show progress bar during process') & ":", 10, 10, 300, 20)
	$cComboItems[0] = GUICtrlCreateCombo("", 20, 10 + 20, 280, 20, 0x0003)
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_CHECKBOX_2', 'Enable associations for folders') & ":", 10, 10 + 60, 300, 20)
	$cComboItems[1] = GUICtrlCreateCombo("", 20, 10 + 60 + 20, 280, 20, 0x0003)
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_CHECKBOX_3', 'Ignore unassociated files/folders') & ":", 10, 10 + 120, 300, 20)
	$cComboItems[2] = GUICtrlCreateCombo("", 20, 10 + 120 + 20, 280, 20, 0x0003)

	For $A = 0 To 2
		$cState = IniRead($cINI, "General", $cOptions[$A], "")
		Switch $cState
			Case "True"
				$cCurrent[$A] = __Lang_Get('OPTIONS_PROFILE_MODE_1', 'Enable for this profile')
			Case "False"
				$cCurrent[$A] = __Lang_Get('OPTIONS_PROFILE_MODE_2', 'Disable for this profile')
			Case Else
				$cCurrent[$A] = __Lang_Get('OPTIONS_PROFILE_MODE_0', 'Use global setting')
		EndSwitch
		GUICtrlSetData($cComboItems[$A], $cGroup, $cCurrent[$A])
	Next

	$cSave = GUICtrlCreateButton("&" & __Lang_Get('SAVE', 'Save'), 160 - 25 - 80, 190, 80, 24)
	$cCancel = GUICtrlCreateButton("&" & __Lang_Get('CANCEL', 'Cancel'), 160 + 25, 190, 80, 24)
	GUICtrlSetState($cSave, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $cCancel
				ExitLoop

			Case $cSave
				For $A = 0 To 2
					$cState = GUICtrlRead($cComboItems[$A])
					Switch $cState
						Case __Lang_Get('OPTIONS_PROFILE_MODE_1', 'Enable for this profile')
							$cState = "True"
						Case __Lang_Get('OPTIONS_PROFILE_MODE_2', 'Disable for this profile')
							$cState = "False"
						Case Else
							$cState = "Default"
					EndSwitch
					__IniWriteEx($cINI, "General", $cOptions[$A], $cState)
				Next
				ExitLoop

		EndSwitch
	WEnd
	GUIDelete($cGUI)

	Return 1
EndFunc   ;==>_Customize_Options

Func _Customize_Update($cListView, $cProfileDirectory, $cProfileList = -1)
	Local $cListViewItem, $cIniReadTransparency, $cIniRead, $cIniRead_Size[2]
	Local $cImageList = $Global_ImageList

	If $cProfileList = -1 Or $cProfileList = 0 Or $cProfileList = "" Then
		$cProfileList = __ProfileList_Get() ; Get Array Of All Profiles.
	EndIf
	If IsArray($cProfileList) = 0 Then
		Return SetError(1, 0, 0)
	EndIf

	If _WinAPI_PathIsDirectory($cProfileDirectory) = 0 Then
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
	Local Enum $cmItem1 = 1000, $cmItem2, $cmItem3, $cmItem4, $cmItem5, $cmItem6, $cmItem7, $cmItem8
	Local $cmContextMenu_1, $cmContextMenu_2

	If IsHWnd($cmListView) = 0 Then
		$cmListView = GUICtrlGetHandle($cmListView)
	EndIf

	$cmContextMenu_1 = _GUICtrlMenu_CreatePopup()
	If $cmIndex <> -1 And $cmSubItem <> -1 Then ; Won't Show These MenuItem(s) Unless An Item Is Selected.
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __Lang_Get('EDIT', 'Edit'), $cmItem1)
		__SetItemImage("EDIT", $cmIndex, $cmContextMenu_1, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __Lang_Get('OPTIONS', 'Options'), $cmItem8)
		__SetItemImage("OPT", $cmIndex, $cmContextMenu_1, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, "")
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __Lang_Get('ACTION_DELETE', 'Delete'), $cmItem2)
		__SetItemImage("DEL", $cmIndex, $cmContextMenu_1, 2, 1)
	EndIf
	If $cmIndex = -1 And $cmSubItem <> -1 Then ; Will Show These MenuItem(s) If No Item Is Selected.
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __Lang_Get('NEW', 'New'), $cmItem3)
		__SetItemImage("NEW", $cmIndex, $cmContextMenu_1, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, "")

		$cmContextMenu_2 = _GUICtrlMenu_CreatePopup()
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __Lang_Get('EXAMPLES', 'Examples'), $cmItem4, $cmContextMenu_2)
		__SetItemImage("EXAMP", $cmIndex, $cmContextMenu_1, 2, 1)

		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_2, "Archiver", $cmItem5)
		__SetItemImage(__GetDefault(4) & "Big_Box4.png", $cmIndex, $cmContextMenu_2, 2, 0)

		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_2, "Eraser", $cmItem6)
		__SetItemImage(__GetDefault(4) & "Big_Delete1.png", $cmIndex, $cmContextMenu_2, 2, 0)

		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_2, "Extractor", $cmItem7)
		__SetItemImage(__GetDefault(4) & "Big_Box6.png", $cmIndex, $cmContextMenu_2, 2, 0)
	EndIf

	Switch _GUICtrlMenu_TrackPopupMenu($cmContextMenu_1, $cmListView, -1, -1, 1, 1, 2)
		Case $cmItem1
			GUICtrlSendToDummy($Global_ListViewProfiles_Enter)
		Case $cmItem2
			GUICtrlSendToDummy($Global_ListViewProfiles_Delete)
		Case $cmItem3
			GUICtrlSendToDummy($Global_ListViewProfiles_New)
		Case $cmItem8
			GUICtrlSendToDummy($Global_ListViewProfiles_Options)
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
#EndRegion >>>>> MAIN: Customize Functions <<<<<

#Region >>>>> MAIN: Processing Functions <<<<<
Func _DropEvent($dFiles, $dProfile, $dMonitored = 0)
	__ExpandEnvStrings(1) ; Enable The Expansion Of Environment Variables.
	_WinAPI_EmptyWorkingSet() ; Reduce Memory Usage Of DropIt.
	FileChangeDir(@ScriptDir) ; Ensure To Use DropIt.exe Directory As Working Directory.

	Local $dMsgBox, $dSize, $dFullSize, $dElementsGUI, $dFailedList[1] = [0]
	If IsArray($dFiles) = 0 Then
		Return SetError(1, 0, 0)
	EndIf

	For $A = 1 To $dFiles[0]
		If FileExists($dFiles[$A]) = 0 Then
			ContinueLoop
		EndIf
		If _WinAPI_PathIsDirectory($dFiles[$A]) Then
			$dSize = DirGetSize($dFiles[$A])
		Else
			$dSize = FileGetSize($dFiles[$A])
		EndIf
		$dFullSize += $dSize
	Next
	__Log_Write(__Lang_Get('DROP_EVENT_TIP_0', 'Total Size Loaded'), __ByteSuffix($dFullSize)) ; __ByteSuffix() = Round A Value Of Bytes To Highest Value.

	If $dFullSize > 2 * 1024 * 1024 * 1024 And __Is("AlertSize") Then
		$dMsgBox = MsgBox(0x04, __Lang_Get('DROP_EVENT_MSGBOX_3', 'Estimated long processing time'), __Lang_Get('DROP_EVENT_MSGBOX_4', 'You are trying to process a large size of files') & " (" & __ByteSuffix($dFullSize) & ")" & @LF & __Lang_Get('DROP_EVENT_MSGBOX_5', 'It may take a long time, do you wish to continue?'), 0, __OnTop())
		If $dMsgBox <> 6 Then
			__Log_Write(__Lang_Get('DROP_EVENT_TIP_1', 'Sorting Aborted'), __Lang_Get('DROP_EVENT_MSGBOX_3', 'Estimated long processing time'))
			Return SetError(1, 0, 0)
		EndIf
	EndIf

	$Global_Key = ""
	Local $dDll = DllOpen("user32.dll")
	If _IsPressed("12", $dDll) Then ; "Alt" Key = Special Action.
		If _IsPressed("58", $dDll) Then ; "X" Key = Browse To Move Files.
			$Global_Key = "X|0"
		ElseIf _IsPressed("43", $dDll) Then ; "C" Key = Browse To Copy Files.
			$Global_Key = "C|0"
		ElseIf _IsPressed("50", $dDll) Then ; "P" Key = Copy Path To Clipboard.
			$Global_Key = "P|0"
		ElseIf _IsPressed("53", $dDll) Then ; "S" Key = Browse To Create Shortcuts.
			$Global_Key = "S|0"
		ElseIf _IsPressed("4C", $dDll) Then ; "L" Key = Browse To Create Playlist.
			$Global_Key = "L|0"
		EndIf
	EndIf
	DllClose($dDll)

	$dElementsGUI = _Sorting_CreateGUI($dFullSize, $dProfile) ; Create The Sorting GUI & Show It If Option Is Enabled.
	For $A = 1 To $dFiles[0]
		If FileExists($dFiles[$A]) Then
			$Global_MainDir = $dFiles[$A] ; Used Only To Detect Main Folders For %SubDir%.
			$dFailedList = _PositionCheck($dFiles[$A], $dProfile, $dFailedList, $dElementsGUI, $dMonitored)
		EndIf
		If $Global_AbortSorting Then
			$dFailedList[0] = 0 ; Do Not Show Failed Items If The User Aborts Sorting (The List Results Incomplete).
			ExitLoop
		EndIf
	Next
	_Sorting_DeleteGUI() ; Delete The Sorting GUI.

	; Reset The Array Of Opened Lists:
	ReDim $Global_OpenedLists[1][2]
	$Global_OpenedLists[0][0] = 0
	$Global_OpenedLists[0][1] = 0

	; Reset The Array Of Priority Actions:
	ReDim $Global_PriorityActions[1]
	$Global_PriorityActions[0] = 0

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
				Local $dFile = FileOpen($dFileName, 2 + 32)
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

	__ExpandEnvStrings(0) ; Disable The Expansion Of Environment Variables.
	$Global_AbortSorting = 0
	$Global_DuplicateMode = ""
	Return 1
EndFunc   ;==>_DropEvent

Func _CheckingMatches($cFileName, $cFileExtension, $cFilePath, $cProfile) ; Returns: Directory [C:\DropItFiles] Or To Associate [0] Or To Skip [-1]
	$cProfile = __IsProfile($cProfile, 0) ; Get Array Of Selected Profile.
	Local $cMatch, $cCheck, $cAssociation, $cAssociationToSplit, $cStringSplit, $cAssociations, $cMatches[1][4] = [[0, 4]]

	$cAssociations = __GetAssociations($cProfile[1]) ; Get Associations Array For The Current Profile.
	If @error Then
		Return SetError(1, 1, -1)
	EndIf

	For $A = 1 To $cAssociations[0][0]
		$cMatch = 0
		$cAssociationToSplit = StringTrimRight($cAssociations[$A][0], 2)

		If $cAssociations[$A][4] <> "Disabled" Then ; Skip Association If It Is Disabled.
			$cAssociationToSplit = StringReplace($cAssociationToSplit, "; ", ";") ; To Support Rules Also If Separated By A Space After Semicolon.
			$cStringSplit = StringSplit($cAssociationToSplit, ";")

			For $B = 1 To $cStringSplit[0]
				$cCheck = ""
				If StringInStr($cStringSplit[$B], "**") Then ; Rule For Folders.
					If $cFileExtension = "" Then
						$cCheck = "**"
					EndIf
				Else ; Rule For Files.
					If $cFileExtension <> "" Then
						$cCheck = "*"
					EndIf
				EndIf
				If $cCheck <> "" Then
					$cAssociation = StringRegExpReplace($cStringSplit[$B], "(\.|\?|\+|\(|\)|\{|\}|\[|\]|\^|\$|\\)", "\\$1")
					$cAssociation = StringReplace($cAssociation, $cCheck, "(.*?)") ; (.*?) = Match Any String Of Characters.
					If StringInStr($cAssociation, "\\") Then ; Rule Formatted As Path.
						$cMatch = StringRegExp($cFilePath, "^(?i)" & $cAssociation & "$") ; ^ = Start String; (?i) = Case Insensitive; $ = End String.
					Else ; Rule Formatted As File.
						$cMatch = StringRegExp($cFileName, "^(?i)" & $cAssociation & "$") ; ^ = Start String; (?i) = Case Insensitive; $ = End String.
					EndIf
					If $cMatch = 1 Then
						$cMatch = _FilterMatches($cFilePath, $cAssociations[$A][3])
					EndIf
					If $cMatch = 1 Then
						ExitLoop
					EndIf
				EndIf
			Next

			If $cMatch = 1 And $cMatches[0][0] < 16 Then
				If UBound($cMatches, 1) <= $cMatches[0][0] + 1 Then
					ReDim $cMatches[UBound($cMatches, 1) + 1][4] ; ReSize Array If More Items Are Required.
				EndIf
				$cMatches[0][0] += 1
				$cMatches[$cMatches[0][0]][0] = $cAssociations[$A][0] ; Rule.
				$cMatches[$cMatches[0][0]][1] = $cAssociations[$A][1] ; Destination.
				$cMatches[$cMatches[0][0]][2] = $cAssociations[$A][5] ; List Properties.
				$cMatches[$cMatches[0][0]][3] = $cAssociations[$A][2] ; Association Name.
			EndIf
		EndIf
	Next

	$cMatch = 0
	If $cMatches[0][0] = 1 Then
		$cMatch = 1
	ElseIf $cMatches[0][0] > 1 Then
		If $Global_PriorityActions[0] > 0 Then ; Automatically Use Priority Action If File Matches With One Of Them.
			For $A = 1 To $Global_PriorityActions[0]
				For $B = 1 To $cMatches[0][0]
					If $Global_PriorityActions[$A] == $cMatches[$B][0] Then
						$cMatch = $B
					EndIf
				Next
			Next
		EndIf
		If $cMatch = 0 Then
			$cMatch = _MoreMatches($cMatches, $cFileName)
		EndIf
	EndIf

	If $cMatch > 0 Then
		$Global_Action = StringRight($cMatches[$cMatch][0], 2) ; Set Action For This File/Folder.
		If $Global_Action == "$2" Then ; Ignore Action.
			Return SetError(1, 0, -1)
		ElseIf $Global_Action == "$8" Then ; List Action.
			$cMatches[$cMatch][1] &= "|" & $cMatches[$cMatch][2] & "|" & $cProfile[1] & "|" & StringTrimRight($cMatches[$cMatch][0], 2) & "|" & $cMatches[$cMatch][3] ; Add List Properties At The End Of The String.
		EndIf
		Return $cMatches[$cMatch][1]
	Else
		Return SetError(1, 0, $cMatch)
	EndIf
EndFunc   ;==>_CheckingMatches

Func _FilterMatches($dFilePath, $dFilters)
	Local $dText[3], $dFileDate[6], $dTemp

	Local $dStringSplit = StringSplit($dFilters, ";")
	ReDim $dStringSplit[5] ; Number Of Filters.
	Local $dArray[4][2] = [ _
			[$dStringSplit[1], 0], _
			[$dStringSplit[2], 1], _
			[$dStringSplit[3], 0], _
			[$dStringSplit[4], 2]]

	For $A = 0 To 3
		If StringLeft($dArray[$A][0], 1) = "1" Then
			$dText[0] = StringLeft(StringTrimLeft($dArray[$A][0], 1), 1)
			$dText[1] = StringRegExpReplace(StringTrimLeft($dArray[$A][0], 2), "[^0-9]", "")
			$dText[2] = StringTrimLeft($dArray[$A][0], 2 + StringLen($dText[1]))

			If $A = 0 Then ; Size.
				If _WinAPI_PathIsDirectory($dFilePath) Then
					$dTemp = DirGetSize($dFilePath)
				Else
					$dTemp = FileGetSize($dFilePath)
				EndIf
				Switch $dText[2]
					Case "bytes"
						$dTemp = Round($dTemp)
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
	If IsArray($mMatches) = 0 Then
		Return SetError(1, 0, 0) ; Exit Function If Not An Array.
	EndIf
	Local $mHandle = $Global_GUI_1
	Local $mGUI, $mAction, $mDestination, $mMsg, $mCancel, $mPriority, $mButtons[$mMatches[0][0] + 1] = [0], $mRead = -1

	$mGUI = GUICreate(__Lang_Get('MOREMATCHES_GUI', 'Select Action'), 340, 150 + 23 * $mMatches[0][0], -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))
	GUICtrlCreateGraphic(0, 0, 340, 52)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlSetColor(-1, 0xffffff)

	GUICtrlCreateLabel(__Lang_Get('MOREMATCHES_LABEL_0', 'Loaded item:'), 14, 12, 312, 18)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlCreateLabel($mFileName, 16, 12 + 18, 308, 20)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlSetFont(-1, -1, 800)

	GUICtrlCreateLabel(__Lang_Get('MOREMATCHES_LABEL_1', 'Select the action to use:'), 14, 58, 312, 18)
	For $A = 1 To $mMatches[0][0]
		$mAction = StringRight($mMatches[$A][0], 2)
		$mDestination = $mMatches[$A][1]
		If $mAction == "$6" Then
			Switch $mMatches[$A][1] ; Destination.
				Case 2
					$mDestination = __Lang_Get('DELETE_MODE_2', 'Safely Erase')
				Case 3
					$mDestination = __Lang_Get('DELETE_MODE_3', 'Send to Recycle Bin')
				Case Else
					$mDestination = __Lang_Get('DELETE_MODE_1', 'Normally Delete')
			EndSwitch
		EndIf
		$mAction = __GetAssociationString($mAction) & " (" & $mDestination & ")" ; __GetAssociationString() = Convert Action Code To Action Name.
		$mButtons[$A] = GUICtrlCreateButton(" " & _WinAPI_PathCompactPathEx($mAction, 55), 14, 52 + $A * 23, 312, 22, 0x0100)
		$mButtons[0] += 1
	Next

	$mPriority = GUICtrlCreateCheckbox(__Lang_Get('MOREMATCHES_LABEL_2', 'Apply to all ambiguities of this drop'), 14, 86 + 23 * $mMatches[0][0], 318, 20)
	$mCancel = GUICtrlCreateButton("&" & __Lang_Get('CANCEL', 'Cancel'), 170 - 45, 116 + 23 * $mMatches[0][0], 90, 25)
	GUISetState(@SW_SHOW)

	While 1
		$mMsg = GUIGetMsg()
		Switch $mMsg
			Case $GUI_EVENT_CLOSE, $mCancel
				$mRead = -1
				ExitLoop

			Case Else
				If $mMsg >= $mButtons[1] And $mMsg <= $mButtons[$mButtons[0]] Then
					For $A = 1 To $mButtons[0]
						If $mMsg = $mButtons[$A] Then
							$mRead = $A
							If GUICtrlRead($mPriority) = 1 Then ; Save Priority Action If Selected.
								$Global_PriorityActions[0] += 1
								ReDim $Global_PriorityActions[$Global_PriorityActions[0] + 1]
								$Global_PriorityActions[$Global_PriorityActions[0]] = $mMatches[$A][0]
							EndIf
							ExitLoop 2
						EndIf
					Next
					ExitLoop
				EndIf

		EndSwitch
	WEnd
	GUIDelete($mGUI)

	Return $mRead
EndFunc   ;==>_MoreMatches

Func _PositionCheck($pFilePath, $pProfile, ByRef $pFailedList, $pElementsGUI, $pMonitored = 0)
	Local $pSearch, $pFileName, $pFailedFile, $pMultiplePosition = 0, $pWildcards = ""

	If _WinAPI_PathIsDirectory($pFilePath) Then
		If __Is("DirForFolders", -1, "False", $pProfile) = 0 Or $pMonitored Then
			$pMultiplePosition = 1
			$pWildcards = "*.*"
			$pMonitored = 0 ; To Scan Only Main Monitored Folders And Process Eventual Subfolders With Current Mode.
		EndIf
	Else
		$pFileName = __GetFileName($pFilePath) ; File Or Folder Name.
		If StringInStr($pFileName, "*") Then
			$pMultiplePosition = 1
			$pWildcards = $pFileName
			$pFilePath = __GetParentFolder($pFilePath) ; Parent Path.
		EndIf
	EndIf

	If $pMultiplePosition = 1 Then
		$pSearch = FileFindFirstFile($pFilePath & "\" & $pWildcards) ; Load Files.
		While 1
			$pFileName = FileFindNextFile($pSearch)
			If @error Then
				ExitLoop
			EndIf
			If _WinAPI_PathIsDirectory($pFilePath & "\" & $pFileName) = 0 Then
				$pFailedFile = _PositionProcess($pFilePath & "\" & $pFileName, $pProfile, $pElementsGUI) ; If Selected Is Not A Directory Then Process The File.
				If @error Then
					Switch $pFailedFile
						Case 1 ; Skipped.
						Case 0 ; Aborted.
							FileClose($pSearch)
							Return SetError(1, 0, $pFailedList) ; Immediately Return If Sorting Aborted.
						Case Else ; Failed.
							$pFailedList[0] += 1
							ReDim $pFailedList[$pFailedList[0] + 1]
							$pFailedList[$pFailedList[0]] = $pFailedFile
					EndSwitch
				EndIf
			EndIf
		WEnd
		FileClose($pSearch)
		If __Is("ScanSubfolders") Then
			$pSearch = FileFindFirstFile($pFilePath & "\" & $pWildcards) ; Load Folders.
			While 1
				$pFileName = FileFindNextFile($pSearch)
				If @error Then
					ExitLoop
				EndIf
				If _WinAPI_PathIsDirectory($pFilePath & "\" & $pFileName) Then
					$pFailedList = _PositionCheck($pFilePath & "\" & $pFileName, $pProfile, $pFailedList, $pElementsGUI) ; If Selected Is A Directory Then Process The Directory.
					If @error Then ; _PositionCheck() Returns Error Only If Aborted.
						FileClose($pSearch)
						Return SetError(1, 0, $pFailedList) ; Immediately Return If Sorting Aborted.
					EndIf
				EndIf
			WEnd
			FileClose($pSearch)
		EndIf
	Else
		$pFailedFile = _PositionProcess($pFilePath, $pProfile, $pElementsGUI)
		If @error Then
			Switch $pFailedFile
				Case 1 ; Skipped.
				Case 0 ; Aborted.
					Return SetError(1, 0, $pFailedList) ; Immediately Return If Sorting Aborted.
				Case Else ; Failed.
					$pFailedList[0] += 1
					ReDim $pFailedList[$pFailedList[0] + 1]
					$pFailedList[$pFailedList[0]] = $pFailedFile
			EndSwitch
		EndIf
	EndIf

	Return $pFailedList
EndFunc   ;==>_PositionCheck

Func _PositionProcess($pFilePath, $pProfile, $pElementsGUI)
	Local $pFileName, $pDestinationDirectory, $pStringSplit, $pCurrentSize, $pIsDirectory, $pSortFailed, $pFileExtension

	$pFilePath = _WinAPI_PathRemoveBackslash($pFilePath)
	If _WinAPI_PathIsDirectory($pFilePath) Then
		$pIsDirectory = 1
	EndIf
	If $pIsDirectory Then
		$pCurrentSize = DirGetSize($pFilePath)
		__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_0', 'Folder Loaded'), $pFilePath)
	Else
		$pFileExtension = __GetFileExtension($pFilePath)
		$pCurrentSize = FileGetSize($pFilePath)
		__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_1', 'File Loaded'), $pFilePath)
	EndIf
	$pFileName = __GetFileName($pFilePath)

	; Use Special Actions In Case Of Special Hotkeys:
	If $Global_Key <> "" Then
		__ExpandEventMode(1) ; Enable The Abort Button.
		_Sorting_Special($pFilePath, $pCurrentSize, $pElementsGUI)
		__ExpandEventMode(0) ; Disable The Abort Button.
		If @error Then
			If $Global_AbortSorting Then
				__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_2', 'Not Sorted'), __Lang_Get('POSITIONPROCESS_LOGMSG_1', 'Aborted'))
				Return SetError(1, 0, 0) ; 0 = Aborted.
			Else
				GUICtrlSetData($pElementsGUI[1], __Lang_Get('POSITIONPROCESS_LOGMSG_0', 'Skipped'))
				__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_2', 'Not Sorted'), __Lang_Get('POSITIONPROCESS_LOGMSG_0', 'Skipped'))
				Return SetError(1, 0, 1) ; 1 = Skipped.
			EndIf
		EndIf
		Return 1
	EndIf

	; Check If An Association Matches:
	$pDestinationDirectory = _CheckingMatches($pFileName, $pFileExtension, $pFilePath, $pProfile) ; Destination If OK, 0 To Associate, -1 To Skip.
	If $pDestinationDirectory == 0 Then
		If __Is("IgnoreNew", -1, "False", $pProfile) Then
			__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_2', 'Not Sorted'), __Lang_Get('POSITIONPROCESS_LOGMSG_0', 'Skipped'))
			GUICtrlSetData($pElementsGUI[2], __GetPercent($pCurrentSize)) ; Force Update Progress Bar.
			Return SetError(1, 0, 1) ; 1 = Skipped.
		Else
			Switch MsgBox(0x03, __Lang_Get('POSITIONPROCESS_MSGBOX_0', 'Association Needed'), __Lang_Get('POSITIONPROCESS_MSGBOX_1', 'No association found for:') & @LF & $pFilePath & @LF & @LF & __Lang_Get('POSITIONPROCESS_MSGBOX_2', 'Do you want to create an association for it?'), 0, __OnTop())
				Case 6
					If _Manage_Edit_GUI($pProfile, __GetFileNameOnly($pFileName), $pFileExtension, -1, -1, -1, -1, 1, 1) <> 0 Then ; _Manage_Edit_GUI() = Show Manage Edit GUI Of Selected Association.
						$pDestinationDirectory = _CheckingMatches($pFileName, $pFileExtension, $pFilePath, $pProfile) ; Destination If OK, 0 To Abort, -1 To Skip.
					EndIf
				Case 7
					$pDestinationDirectory = -1
				Case Else
					$pDestinationDirectory = 0
			EndSwitch
		EndIf
	EndIf
	If $pDestinationDirectory == 0 Or $pDestinationDirectory == -1 Or $pDestinationDirectory = "" Then
		GUICtrlSetData($pElementsGUI[2], __GetPercent($pCurrentSize)) ; Force Update Progress Bar.
		If $pDestinationDirectory == -1 Then
			__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_2', 'Not Sorted'), __Lang_Get('POSITIONPROCESS_LOGMSG_0', 'Skipped'))
			Return SetError(1, 0, 1) ; 1 = Skipped.
		Else
			__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_2', 'Not Sorted'), __Lang_Get('POSITIONPROCESS_LOGMSG_1', 'Aborted'))
			Return SetError(1, 0, 0) ; 0 = Aborted.
		EndIf
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
		Local $pEnvArray[21][3] = [ _
				[20, 0, 0], _
				["FileExt", 3, __GetFileExtension($pFilePath)], _
				["FileName", 3, __GetFileNameOnly($pFilePath)], _
				["FileNameExt", 3, __GetFileName($pFilePath)], _
				["ParentDir", 3, __GetParentFolder($pFilePath)], _
				["SubDir", 3, StringTrimLeft(__GetParentFolder($pFilePath), StringLen($Global_MainDir))], _
				["ProfileName", 3, $pProfile], _
				["CurrentDate", 3, @YEAR & "-" & @MON & "-" & @MDAY], _
				["CurrentTime", 3, @HOUR & "." & @MIN & "." & @SEC], _
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
			If StringInStr($pDestinationDirectory, "%" & $pEnvArray[$A][0] & "%") Then ; Do It Only If Current Environment Variable Is Used.
				Switch $pEnvArray[$A][1]
					Case 0
						$pLoadedProperty = __GetFileProperties($pFilePath, $pEnvArray[$A][2])
					Case 1
						$pLoadedProperty = StringRegExpReplace(__GetFileProperties($pFilePath, $pEnvArray[$A][2]), "[^0-9]", "") ; Remove All Non-Digit Characters.
						$pLoadedProperty = StringRegExpReplace($pLoadedProperty, "(\d{2})(\d{2})(\d{4})(\d{2})(\d{2})", "$3-$2-$1") ; Convert To YYYY-MM-DD.
					Case 2
						$pLoadedProperty = FileGetTime($pFilePath, $pEnvArray[$A][2], 1)
						$pLoadedProperty = StringRegExpReplace($pLoadedProperty, "(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})", "$1-$2-$3") ; Convert To YYYY-MM-DD.
					Case 3
						$pLoadedProperty = $pEnvArray[$A][2]
				EndSwitch
				If $pLoadedProperty == "" And $pEnvArray[$A][0] <> "SubDir" Then
					$pLoadedProperty = $pEnvArray[$A][0]
				EndIf
				$pDestinationDirectory = StringReplace($pDestinationDirectory, "%" & $pEnvArray[$A][0] & "%", $pLoadedProperty)
			EndIf
		Next
	EndIf

	; Update Destination For Rename Action:
	If $Global_Action == "$7" Then
		$pFileName = $pDestinationDirectory
		$pDestinationDirectory = __GetParentFolder($pFilePath)
	EndIf

	; Destination Folder Creation:
	If $Global_Action <> "$5" And $Global_Action <> "$6" And $Global_Action <> "$8" And FileExists($pDestinationDirectory) = 0 Then
		Local $pIsDirectoryCreated = DirCreate($pDestinationDirectory)
		If $pIsDirectoryCreated = 0 Then
			MsgBox(0x40, __Lang_Get('POSITIONPROCESS_MSGBOX_3', 'Destination Folder Problem'), __Lang_Get('POSITIONPROCESS_MSGBOX_4', 'Sorting operation has been partially skipped.  @LF  The following destination folder does not exist and cannot be created:') & @LF & _WinAPI_PathCompactPathEx($pDestinationDirectory, 65), 0, __OnTop())
			__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_2', 'Not Sorted'), __Lang_Get('POSITIONPROCESS_LOGMSG_2', 'Failed'))
			GUICtrlSetData($pElementsGUI[2], __GetPercent($pCurrentSize)) ; Force Update Progress Bar.
			Return SetError(1, 0, 2) ; 2 = Failed Destination Folder Creation.
		EndIf
	EndIf

	; Define Extension If File Has It:
	If $pFileExtension <> "" Then
		$pFileExtension = "." & $pFileExtension
	EndIf

	; Update File Name For Compress And Extract Actions:
	If $Global_Action == "$3" Then
		Local $pCompressionFormat = __7ZipCurrentFormat()
		If __Is("ArchiveSelf") And $pCompressionFormat = "7z" Then
			$pCompressionFormat = "exe"
		EndIf
		If $pIsDirectory = 0 Then
			$pFileName = StringTrimRight($pFileName, StringLen($pFileExtension)) ; Remove Original Extension If Needed.
		EndIf
		$pFileName &= "." & $pCompressionFormat
		$pIsDirectory = 0 ; Needed To Correctly Rename Eventual Duplicates.
	ElseIf $Global_Action == "$4" Then
		$pFileName = StringTrimRight($pFileName, StringLen($pFileExtension)) ; Save The Name Of The Extraction Output Folder.
		$pIsDirectory = 1 ; Needed To Correctly Rename Eventual Duplicates.
	EndIf

	; Manage Duplicates:
	If FileExists($pDestinationDirectory & "\" & $pFileName) Then
		Local $pDupMode = "Skip"
		If __Is("AutoDup") Then
			$pDupMode = IniRead(__IsSettingsFile(), "General", "DupMode", "Overwrite") ; __IsSettingsFile() = Get Default Settings INI File.
		Else
			If $Global_DuplicateMode <> "" Then
				$pDupMode = $Global_DuplicateMode
			Else
				$pDupMode = _Duplicate_Alert($pFileName)
			EndIf
		EndIf
		Switch $pDupMode
			Case "Rename"
				$pFileName = _Duplicate_Rename($pFileName, $pDestinationDirectory, $pIsDirectory)
			Case "Skip"
				__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_2', 'Not Sorted'), __Lang_Get('POSITIONPROCESS_LOGMSG_0', 'Skipped'))
				GUICtrlSetData($pElementsGUI[2], __GetPercent($pCurrentSize)) ; Force Update Progress Bar.
				Return SetError(1, 0, 1) ; 1 = Skipped.
		EndSwitch
	EndIf

	__ExpandEventMode(1) ; Enable The Abort Button.
	If $Global_Action <> "$5" And $Global_Action <> "$6" And $Global_Action <> "$8" Then
		$pDestinationDirectory &= "\" & $pFileName
	EndIf
	_Sorting_Process($pFilePath, $pDestinationDirectory, $pElementsGUI)
	If @error Then
		$pSortFailed = 1
	EndIf
	If $Global_Action <> "$5" And $Global_Action <> "$6" And $Global_Action <> "$8" And FileExists($pDestinationDirectory) = 0 Then
		$pSortFailed = 1
	EndIf
	If $Global_Action == "$6" And FileExists($pFilePath) Then
		$pSortFailed = 1
	EndIf
	__ExpandEventMode(0) ; Disable The Abort Button.

	; Process Log For This Item:
	If $pSortFailed Then
		If $Global_AbortSorting Then
			__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_2', 'Not Sorted'), __Lang_Get('POSITIONPROCESS_LOGMSG_1', 'Aborted'))
			Return SetError(1, 0, 0) ; 0 = Aborted.
		Else
			__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_2', 'Not Sorted'), __Lang_Get('POSITIONPROCESS_LOGMSG_2', 'Failed'))
			GUICtrlSetData($pElementsGUI[2], __GetPercent($pCurrentSize)) ; Force Update Progress Bar.
			Return SetError(1, 0, $pFileName) ; $pFileName = Failed.
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
			Case "$8"
				$pSyntaxMode = __Lang_Get('POSITIONPROCESS_LOG_10', 'Listed')
				$pStringSplit = StringSplit($pDestinationDirectory, "|") ; Remove List Properties From The End Of The String.
				$pDestinationDirectory = $pStringSplit[1]
			Case Else
				$pSyntaxMode = __Lang_Get('POSITIONPROCESS_LOG_5', 'Moved')
		EndSwitch
		__Log_Write($pSyntaxMode, $pDestinationDirectory)
	EndIf

	Return 1
EndFunc   ;==>_PositionProcess

Func _Duplicate_Alert($dItem)
	Local $dGUI, $dButtonOverwrite, $dButtonRename, $dButtonSkip, $dCheckForAll, $dValue

	$dGUI = GUICreate(__Lang_Get('POSITIONPROCESS_DUPLICATE_0', 'Item Already Exists'), 360, 135, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop())
	GUICtrlCreateGraphic(0, 0, 360, 68)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlSetColor(-1, 0xffffff)

	GUICtrlCreateLabel(__Lang_Get('POSITIONPROCESS_DUPLICATE_1', 'This item already exists in destination folder:'), 14, 12, 328, 18)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlCreateLabel($dItem, 16, 12 + 18, 324, 36)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlSetFont(-1, -1, 800)

	$dButtonOverwrite = GUICtrlCreateButton("&" & __Lang_Get('OPTIONS_MODE_2', 'Overwrite'), 180 - 65 - 84, 76, 88, 25)
	$dButtonSkip = GUICtrlCreateButton("&" & __Lang_Get('OPTIONS_MODE_3', 'Skip'), 180 - 42, 76, 88, 25)
	$dButtonRename = GUICtrlCreateButton("&" & __Lang_Get('OPTIONS_MODE_4', 'Rename'), 180 + 65, 76, 88, 25)
	GUICtrlSetState($dButtonRename, $GUI_DEFBUTTON)
	$dCheckForAll = GUICtrlCreateCheckbox(__Lang_Get('POSITIONPROCESS_DUPLICATE_2', 'Apply to all duplicates of this drop'), 14, 110, 328, 20)
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

Func _Duplicate_Rename($dItem, $dDestinationDirectory, $dIsDirectory = 0, $dStyle = 0)
	Local $dNumber, $dFileExtension, $A = 1
	Local $dFileName = $dItem

	If $dIsDirectory = 0 Then ; If Is A File.
		$dFileExtension = __GetFileExtension($dFileName)
		If $dFileExtension <> "" Then
			$dFileExtension = "." & $dFileExtension ; To Add It Only If Is A File With Extension.
		EndIf
		$dFileName = StringTrimRight($dFileName, StringLen($dFileExtension))
	EndIf

	If $dDestinationDirectory <> "" Then
		$dDestinationDirectory &= "\"
	EndIf

	While 1
		If $A < 10 Then
			$dNumber = 0 & $A ; Create 01, 02, 03, 04, 05 Till 09.
		Else
			$dNumber = $A ; Create 10, 11, 12, 13, 14, Etc.
		EndIf

		If $dStyle = 1 Then
			$dItem = $dFileName & " (" & $dNumber & ")"
		Else
			$dItem = $dFileName & "_" & $dNumber
		EndIf
		If $dIsDirectory = 0 Then ; If Is A File.
			$dItem &= $dFileExtension
		EndIf

		If FileExists($dDestinationDirectory & $dItem) = 0 Then
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

Func _Sorting_CreateGUI($sTotalSize, $sProfile)
	Local $sLabel1, $sLabel2, $sProgress_1, $sProgress_2, $sLoadDll

	$Global_SortingTotalSize = $sTotalSize
	$Global_SortingCurrentSize = 0

	If @AutoItX64 Then
		$sLoadDll = @ScriptDir & '\Lib\copy\Copy_x64.dll'
	Else
		$sLoadDll = @ScriptDir & '\Lib\copy\Copy.dll'
	EndIf
	If _Copy_OpenDll($sLoadDll) = 0 Then
		Return SetError(1, 0, 0)
	EndIf

	$Global_SortingGUI = GUICreate(__Lang_Get('POSITIONPROCESS_0', 'Sorting'), 400, 142, -1, -1, -1, -1, __OnTop())
	GUISetOnEvent($GUI_EVENT_CLOSE, '_Sorting_Abort')
	$sLabel1 = GUICtrlCreateLabel(__Lang_Get('POSITIONPROCESS_1', 'Loading') & '...', 16, 14, 368, 16)
	$sProgress_1 = GUICtrlCreateProgress(16, 14 + 16, 368, 16)
	$sLabel2 = GUICtrlCreateLabel('', 16, 60, 368, 16)
	$sProgress_2 = GUICtrlCreateProgress(16, 60 + 16, 368, 16)
	$Global_AbortButton = GUICtrlCreateButton("&" & __Lang_Get('POSITIONPROCESS_2', 'Abort'), 200 - 45, 106, 90, 25)
	GUICtrlSetOnEvent(-1, '_Sorting_Abort')

	If __Is("ShowSorting", -1, "True", $sProfile) Then
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
	Local $sPercent, $sSize, $sArray, $sDecrypt_Password
	Local $sLabel_2 = $sElementsGUI[1], $sProgress_1 = $sElementsGUI[2], $sProgress_2 = $sElementsGUI[3]

	GUICtrlSetData($sLabel_2, _WinAPI_PathCompactPathEx(__GetParentFolder($sDestination), 68))
	GUICtrlSetData($sProgress_2, 0)
	If _WinAPI_PathIsDirectory($sSource) Then
		$sSize = DirGetSize($sSource)
	Else
		$sSize = FileGetSize($sSource)
	EndIf
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	If __Is("ArchiveSelf") And $sType = 0 Then ; Compress Mode.
		$sDestination = StringTrimRight($sDestination, 4) & ".7z" ; Replace ".exe" With ".7z" If Needed.
	EndIf

	If $sType = 1 Then ; Extract Mode.
		$sArray = __7ZipRun($sSource, $sDestination, 2, 0, 0) ; Test If Archive Is Encrypted.
		If IsArray($sArray) Then
			If $sArray[0] <> 0 Then ; Archive Is Encrypted.
				__ExpandEventMode(0) ; Disable The Abort Button.
				$sDecrypt_Password = __InsertPassword(_WinAPI_PathCompactPathEx(__GetFileName($sSource), 68))
				__ExpandEventMode(1) ; Enable The Abort Button.
				If $sDecrypt_Password = -1 Then
					Return SetError(1, 0, 0)
				Else
					$sArray = __7ZipRun($sSource, $sDestination, 2, 0, 0, $sDecrypt_Password) ; Test If Password Is Correct.
					If IsArray($sArray) Then
						If $sArray[0] <> 0 Then ; Password Not Correct.
							MsgBox(0x30, __Lang_Get('PASSWORD_MSGBOX_1', 'Password Not Correct'), __Lang_Get('PASSWORD_MSGBOX_3', 'You have to enter the correct password to extract this archive.'), 0, __OnTop())
							Return SetError(1, 0, 0)
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

	$sArray = __7ZipRun($sSource, $sDestination, $sType, 1, 1, $sDecrypt_Password)
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
			$sPercent = __GetPercent($sSize * $sPercent / 100, 0)
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
	GUICtrlSetData($sProgress_1, __GetPercent($sSize))

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

	GUICtrlSetData($sLabel_2, _WinAPI_PathCompactPathEx(__GetParentFolder($sDestination), 68))
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
					$sPercent = __GetPercent($sState[1], 0)
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
	GUICtrlSetData($sProgress_1, __GetPercent($sState[2]))

	If __Is("IntegrityCheck") Then
		$sMD5_After = __MD5ForFile($sDestination)
		If $sMD5_Before <> $sMD5_After Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf

	Return 1
EndFunc   ;==>_Sorting_CopyFile

Func _Sorting_DeleteFile($sSource, $sDeletionMode, $sElementsGUI)
	Local $sSize, $sDeleteText
	Local $sLabel_2 = $sElementsGUI[1], $sProgress_1 = $sElementsGUI[2], $sProgress_2 = $sElementsGUI[3]

	If __IsReadOnly($sSource) Then
		FileSetAttrib($sSource, '-R') ; Needed To Delete Read-Only Files/Folders.
	EndIf

	Switch $sDeletionMode
		Case 2
			$sDeleteText = __Lang_Get('DELETE_MODE_2', 'Safely Erase')
		Case 3
			$sDeleteText = __Lang_Get('DELETE_MODE_3', 'Send to Recycle Bin')
		Case Else
			$sDeleteText = __Lang_Get('DELETE_MODE_1', 'Normally Delete')
	EndSwitch
	GUICtrlSetData($sLabel_2, $sDeleteText)
	GUICtrlSetData($sProgress_2, 0)
	If __Is("AlertDelete") Then
		Local $sMsgBox = MsgBox(0x04, __Lang_Get('DROP_EVENT_MSGBOX_10', 'Delete item'), __Lang_Get('MOREMATCHES_LABEL_0', 'Loaded item:') & @LF & __GetFileName($sSource) & @LF & @LF & __Lang_Get('DROP_EVENT_MSGBOX_11', 'Are you sure to delete this item?'), 0, __OnTop())
		If $sMsgBox <> 6 Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf
	If _WinAPI_PathIsDirectory($sSource) Then
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
	GUICtrlSetData($sProgress_1, __GetPercent($sSize))

	Return 1
EndFunc   ;==>_Sorting_DeleteFile

Func _Sorting_ListFile($sSource, $sListFile, $sElementsGUI)
	Local $sSize, $sPath
	Local $sLabel_2 = $sElementsGUI[1], $sProgress_1 = $sElementsGUI[2], $sProgress_2 = $sElementsGUI[3]

	$sPath = StringSplit($sListFile, "|") ; Remove List Properties From The End Of The String.
	If $Global_OpenedLists[0][0] > 0 Then ; Some Lists Are Already Opened In This Drop.
		For $A = 1 To $Global_OpenedLists[0][0]
			If $sPath[1] = $Global_OpenedLists[$A][0] Then
				$sPath[1] = $Global_OpenedLists[$A][1] ; Load List Name Of This Drop.
				ExitLoop
			EndIf
		Next
	EndIf
	GUICtrlSetData($sLabel_2, _WinAPI_PathCompactPathEx($sPath[1], 68))
	GUICtrlSetData($sProgress_2, 0)
	If _WinAPI_PathIsDirectory($sSource) Then
		$sSize = DirGetSize($sSource)
	Else
		$sSize = FileGetSize($sSource)
	EndIf
	__List_Write($sListFile, $sSource, $sSize)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	GUICtrlSetData($sProgress_2, 100)
	GUICtrlSetData($sProgress_1, __GetPercent($sSize))

	Return 1
EndFunc   ;==>_Sorting_ListFile

Func _Sorting_OpenFile($sSource, $sDestination, $sElementsGUI)
	Local $sSize
	Local $sLabel_2 = $sElementsGUI[1], $sProgress_1 = $sElementsGUI[2], $sProgress_2 = $sElementsGUI[3]

	GUICtrlSetData($sLabel_2, _WinAPI_PathCompactPathEx($sDestination, 68))
	GUICtrlSetData($sProgress_2, 0)
	$sSize = FileGetSize($sSource)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	If StringInStr($sDestination, "%DefaultProgram%") Then
		$sDestination = StringReplace($sDestination, "%DefaultProgram%", "")
		$sDestination = StringReplace($sDestination, '""', '"') ; Fix Double Quotes If Needed.
		If __Is("WaitOpened") Then
			ShellExecuteWait($sSource, $sDestination)
		Else
			ShellExecute($sSource, $sDestination)
		EndIf
	Else
		If StringInStr($sDestination, "%File%") = 0 Then
			$sDestination &= ' "' & $sSource & '"'
		EndIf
		$sDestination = StringReplace($sDestination, "%File%", '"' & $sSource & '"')
		$sDestination = StringReplace($sDestination, '""', '"') ; Fix Double Quotes If Needed.
		If __Is("WaitOpened") Then
			RunWait($sDestination, @ScriptDir)
		Else
			Run($sDestination, @ScriptDir)
		EndIf
	EndIf
	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	GUICtrlSetData($sProgress_2, 100)
	GUICtrlSetData($sProgress_1, __GetPercent($sSize))

	Return 1
EndFunc   ;==>_Sorting_OpenFile

Func _Sorting_RenameFile($sSource, $sNewName, $sElementsGUI)
	Local $sSize
	Local $sLabel_2 = $sElementsGUI[1], $sProgress_1 = $sElementsGUI[2], $sProgress_2 = $sElementsGUI[3]

	If __IsReadOnly($sSource) Then
		FileSetAttrib($sSource, '-R') ; Needed To Rename Read-Only Files/Folders.
	EndIf

	GUICtrlSetData($sLabel_2, _WinAPI_PathCompactPathEx(__GetFileName($sNewName), 68))
	GUICtrlSetData($sProgress_2, 0)
	If _WinAPI_PathIsDirectory($sSource) Then
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
	GUICtrlSetData($sProgress_1, __GetPercent($sSize))

	Return 1
EndFunc   ;==>_Sorting_RenameFile

Func _Sorting_Process($sSource, $sDestination, $sElementsGUI, $sRoot = '')
	Local $sPath, $sFile, $sSearch
	Local $sLabel_1 = $sElementsGUI[0]

	If $Global_AbortSorting Then
		Return SetError(1, 0, 0) ; Needed To Do Not Start A New Operation If Sorting Is Aborted.
	EndIf
	GUICtrlSetData($sLabel_1, _WinAPI_PathCompactPathEx($sSource, 68))

	Switch $Global_Action
		Case "$3" ; Compress Action.
			_Sorting_ArchiveFile($sSource, $sDestination, $sElementsGUI, 0)

		Case "$4" ; Extract Action.
			_Sorting_ArchiveFile($sSource, $sDestination, $sElementsGUI, 1)

		Case "$5" ; Open With Action.
			_Sorting_OpenFile($sSource, $sDestination, $sElementsGUI)

		Case "$6" ; Delete Action.
			_Sorting_DeleteFile($sSource, $sDestination, $sElementsGUI)

		Case "$7" ; Rename Action.
			_Sorting_RenameFile($sSource, $sDestination, $sElementsGUI)

		Case "$8" ; List Action.
			_Sorting_ListFile($sSource, $sDestination, $sElementsGUI)

		Case Else ; Move Or Copy Action.
			If _WinAPI_PathIsDirectory($sSource) Then
				If FileExists($sDestination) = 0 Then
					If DirCreate($sDestination) = 0 Then
						Return SetError(1, 0, 0)
					EndIf
				EndIf
				$sSearch = FileFindFirstFile($sSource & $sRoot & '\*.*')
				If $sSearch = -1 Then
					Switch @error
						Case 1 ; Folder Is Empty.
						Case Else
							Return SetError(1, 0, 0)
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
					If @extended Then ; Loaded A Directory.
						If FileExists($sDestination & $sPath) = 0 Then
							If DirCreate($sDestination & $sPath) = 0 Then
								ExitLoop
							EndIf
							FileSetAttrib($sDestination & $sPath, '+' & StringReplace(FileGetAttrib($sSource & $sPath), 'D', ''))
						EndIf
						If _Sorting_Process($sSource, $sDestination, $sElementsGUI, $sPath) = 0 Then
							ExitLoop
						EndIf
					Else ; Loaded A File.
						If _Sorting_CopyFile($sSource & $sPath, $sDestination & $sPath, $sElementsGUI) = 0 Then
							ExitLoop
						EndIf
					EndIf
				WEnd
				FileClose($sSearch)
			Else
				_Sorting_CopyFile($sSource, $sDestination, $sElementsGUI)
			EndIf
	EndSwitch

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_Sorting_Process

Func _Sorting_Special($sFilePath, $sCurrentSize, $sElementsGUI)
	Local $sData = StringSplit($Global_Key, "|", 2)

	If $Global_AbortSorting Then
		Return SetError(-1, 0, 0) ; Needed To Do Not Start A New Operation If Sorting Is Aborted.
	EndIf
	GUICtrlSetData($sElementsGUI[0], _WinAPI_PathCompactPathEx($sFilePath, 68))

	Switch $sData[0]
		Case "X", "C"
			If $sData[1] = "0" Then
				If $sData[0] = "X" Then
					$sData[1] = __Lang_Get('POSITIONPROCESS_MSGBOX_5', 'Select where to move files:')
					$Global_Action = "$0"
				Else
					$sData[1] = __Lang_Get('POSITIONPROCESS_MSGBOX_6', 'Select where to copy files:')
					$Global_Action = "$1"
				EndIf
				$sData[1] = FileSelectFolder($sData[1], "", 3, "", __OnTop())
				$Global_Key = $sData[0] & "|" & $sData[1]
			EndIf
			If $sData[1] <> "" Then
				_Sorting_CopyFile($sFilePath, $sData[1] & "\" & __GetFileName($sFilePath), $sElementsGUI)
				If @error = 0 Then
					If $sData[0] = "X" Then
						__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_5', 'Moved'), $sData[1])
					Else
						__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_6', 'Copied'), $sData[1])
					EndIf
					Return 1
				EndIf
			EndIf

		Case "P", "S", "L"
			GUICtrlSetData($sElementsGUI[2], __GetPercent($sCurrentSize)) ; Force Update Progress Bar.
			If $sData[1] = "0" Then
				If $sData[0] = "P" Then
					$sData[1] = __Lang_Get('POSITIONPROCESS_LOG_12', 'Path copied to Clipboard')
					ClipPut("")
				ElseIf $sData[0] = "S" Then
					$sData[1] = FileSelectFolder(__Lang_Get('POSITIONPROCESS_MSGBOX_7', 'Select where to save shortcuts:'), "", 3, "", __OnTop())
				Else
					$sData[1] = ""
					Local $sOutput = _WinAPI_GetSaveFileName(__Lang_Get('POSITIONPROCESS_MSGBOX_8', 'Select where to save playlist:'), "M3U (*.m3u)|M3U8 (*.m3u8)|PLS (*.pls)|WPL (*.wpl)", @DesktopDir, __Lang_Get('PLAYLIST', 'Playlist'), "m3u", 1, 0, 0, __OnTop())
					If $sOutput[0] = 2 Then
						If _WinAPI_PathIsDirectory($sOutput[1]) Then
							$sData[1] = $sOutput[1] & "\" & $sOutput[2]
							If FileExists($sData[1]) Then
								Local $sMsgBox = MsgBox(0x04, __Lang_Get('POSITIONPROCESS_MSGBOX_9', 'Replace playlist'), __Lang_Get('POSITIONPROCESS_MSGBOX_10', 'This playlist already exists. Do you want to replace it?'), 0, __OnTop())
								If $sMsgBox = 6 Then
									FileDelete($sData[1])
								Else
									$sData[1] = ""
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
				$Global_Key = $sData[0] & "|" & $sData[1]
			EndIf
			If $sData[1] <> "" Then
				GUICtrlSetData($sElementsGUI[1], _WinAPI_PathCompactPathEx($sData[1], 68))
				If $sData[0] = "P" Then
					$sData[1] = ClipGet()
					If $sData[1] <> "" Then
						$sData[1] &= @CRLF
					EndIf
					If ClipPut($sData[1] & $sFilePath) Then
						__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_12', 'Path copied to Clipboard'))
						Return 1
					EndIf
				ElseIf $sData[0] = "S" Then
					If FileCreateShortcut($sFilePath, $sData[1] & "\" & __GetFileNameOnly($sFilePath) & ".lnk") Then
						__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_11', 'Shortcut Created'))
						Return 1
					EndIf
				Else
					If __Playlist_Write($sFilePath, $sData[1]) Then
						__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_13', 'File added to Playlist'))
						Return 1
					EndIf
				EndIf
			EndIf

	EndSwitch
	$Global_AbortSorting = 1
	Return SetError(1, 0, 0)
EndFunc   ;==>_Sorting_Special
#EndRegion >>>>> MAIN: Processing Functions <<<<<

#Region >>>>> MAIN: General Functions <<<<<
Func _Main()
	Local $mINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $mProfileList, $mCurrentProfile, $mMsg, $mMonitored, $mLoadedFolder[2] = [1, 0]
	Local $mTime_Diff, $mTime_Now = TimerInit()

	$Global_Timer = 0 ; Monitoring Disabled.
	If __Is("Monitoring") Then
		$Global_Timer = IniRead($mINI, "General", "MonitoringTime", "60")
	EndIf

	__InstalledCheck() ; Check To See If DropIt Is Installed.
	__IsProfile() ; Check If A Default Profile Is Available.
	_Main_Create() ; Create The Main GUI, ContextMenu & TrayMenu.

	GUIRegisterMsg($WM_CONTEXTMENU, "WM_CONTEXTMENU")
	GUIRegisterMsg($WM_COPYDATA, "WM_COPYDATA")
	GUIRegisterMsg($WM_DROPFILES, "WM_DROPFILES")
	GUIRegisterMsg($WM_MOUSEWHEEL, "WM_MOUSEWHEEL")
	GUIRegisterMsg($WM_SYSCOMMAND, "WM_SYSCOMMAND")

	__Log_Write(@LF & "===== " & __Lang_Get('DROPIT_STARTED', 'DropIt Started') & " =====")

	_WinAPI_EmptyWorkingSet() ; Reduce Memory Usage Of DropIt.
	While 1
		; Monitored Folders Scanning:
		If $Global_Timer <> 0 Then
			$mTime_Diff = TimerDiff($mTime_Now)
			If $mTime_Diff > ($Global_Timer * 1000) Then
				$mMonitored = __IniReadSection($mINI, "MonitoredFolders") ; Get Associations Array For The Current Profile.
				If @error = 0 Then
					$Global_MenuDisable = 1
					TraySetClick(0)
					For $A = 1 To $mMonitored[0][0]
						$mLoadedFolder[1] = $mMonitored[$A][0]
						__Log_Write(__Lang_Get('MONITORED_FOLDER', 'Monitored Folder'), $mLoadedFolder[1])
						If DirGetSize($mLoadedFolder[1]) > 0 Then
							If $Global_GUI_State = 1 Then ; GUI Is Visible.
								GUISetState(@SW_SHOW, $Global_GUI_2) ; Show Small Working Icon.
							EndIf
							_DropEvent($mLoadedFolder, $mMonitored[$A][1], 1)
							GUISetState(@SW_HIDE, $Global_GUI_2) ; Hide Small Working Icon.
						EndIf
					Next
					TraySetClick(8)
					$Global_MenuDisable = 0
				EndIf
				$mTime_Now = TimerInit()
			EndIf
		EndIf

		; Switch Profiles With Mouse Scroll Wheel:
		If $Global_Wheel <> 0 Then
			$mProfileList = __ProfileList_Get() ; Get Array Of All Profiles.
			$mCurrentProfile = __GetCurrentProfile() ; Get Current Profile From The Settings INI File.
			For $A = 1 To $mProfileList[0]
				If $mProfileList[$A] = $mCurrentProfile Then
					If $Global_Wheel = 1 Then ; Down.
						If $A = $mProfileList[0] Then ; If Current Is The Last.
							$A = 0
						EndIf
						$mCurrentProfile = $mProfileList[$A + 1]
					Else ; Up.
						If $A = 1 Then ; If Current Is The First.
							$A = $mProfileList[0] + 1
						EndIf
						$mCurrentProfile = $mProfileList[$A - 1]
					EndIf
					ExitLoop
				EndIf
			Next
			__SetCurrentProfile($mCurrentProfile)
			_Refresh(1)
			$Global_Wheel = 0
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
				_TrayMenu_ShowTray() ; Show The TrayMenu.

			Case $Global_ContextMenu[10][0]
				If FileExists(@ScriptDir & "\Guide.pdf") Then
					ShellExecute(@ScriptDir & "\Guide.pdf")
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
	__SetHandle($Global_UniqueID) ; Set Window Title For WM_COPYDATA.
	If $rProfile[7] < 10 Then
		$rProfile[7] = 100
		__ImageWrite(-1, 4, -1, -1, -1, $rProfile[7]) ; Write Transparency To The Current Profile.
	EndIf
	__SetBitmap($rGUI_1, $rProfile[3], 255 / 100 * $rProfile[7], $rProfile[5], $rProfile[6]) ; Set Image & Resize To The GUI.
	__GUIInBounds($rGUI_1) ; Check If The GUI Is Within View Of The Users Screen.

	_ContextMenu_Create($rIcon_1) ; Create The ContextMenu.

	$rGUI_2 = GUICreate("", 16, 16, $rProfile[5] / 5, $rProfile[6] / 5, $WS_POPUP, BitOR($WS_EX_MDICHILD, $WS_EX_LAYERED, $WS_EX_TOPMOST), $rGUI_1)
	$Global_GUI_2 = $rGUI_2

	GUISetBkColor(0x000001)
	_WinAPI_SetLayeredWindowAttributes($rGUI_2, 0x00000001, 0x00, 1, 0)
	Local $rLabelIconImage = GUICtrlCreateLabel("", 0, 0, 16, 16)
	_ResourceSetImageToCtrl($rLabelIconImage, "PROG")
	GUISetState(@SW_HIDE, $rGUI_2)

	_Refresh()

	If __Is("Minimized") Then
		_TrayMenu_ShowTray()
	Else
		GUISetState(@SW_SHOW, $rGUI_1)
	EndIf

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
	If __Is("UseShell") Then
		_ShellAll_Uninstall() ; Remove Context Menu Integration.
		_ShellAll_Install("Sort with DropIt") ; Create Context Menu Integration.
	EndIf
	If __Is("UseSendTo") Then
		__SendTo_Uninstall() ; Remove SendTo Integration.
		__SendTo_Install() ; Create SendTo Integration.
	EndIf
	GUIRegisterMsg($WM_COMMAND, "WM_LBUTTONDBLCLK") ; $WM_LBUTTONDBLCLK As Command Doesn't Work.
	Return 1
EndFunc   ;==>_Refresh

Func _ContextMenu_Create($cHandle = $Global_Icon_1)
	Local $cCurrentProfile = __GetCurrentProfile() ; Get Current Profile From The Settings INI File.
	Local $cContextMenu = _ContextMenu_Delete($cHandle, $cCurrentProfile) ; Delete The Current ContextMenu Items.

	$cHandle = $Global_Icon_1
	Local $cProfileList = __ProfileList_Get() ; Get Array Of All Profiles.
	$cContextMenu[1][0] = GUICtrlCreateContextMenu($cHandle)
	$cContextMenu[2][0] = GUICtrlCreateMenuItem(__Lang_Get('ASSOCIATIONS', 'Associations'), $cContextMenu[1][0], 0)
	$cContextMenu[3][0] = GUICtrlCreateMenuItem("", $cContextMenu[1][0], 1)
	$cContextMenu[4][0] = GUICtrlCreateMenu(__Lang_Get('PROFILES', 'Profiles'), $cContextMenu[1][0], 2)
	$cContextMenu[5][0] = GUICtrlCreateMenuItem(__Lang_Get('OPTIONS', 'Options'), $cContextMenu[1][0], 3)
	$cContextMenu[6][0] = GUICtrlCreateMenuItem(__Lang_Get('HIDE', 'Hide'), $cContextMenu[1][0], 4)
	$cContextMenu[7][0] = GUICtrlCreateMenu(__Lang_Get('HELP', 'Help'), $cContextMenu[1][0], 5)
	$cContextMenu[8][0] = GUICtrlCreateMenuItem("", $cContextMenu[1][0], 6)
	$cContextMenu[9][0] = GUICtrlCreateMenuItem(__Lang_Get('EXIT', 'Exit'), $cContextMenu[1][0], 7)

	$cContextMenu[10][0] = GUICtrlCreateMenuItem(__Lang_Get('GUIDE', 'Guide'), $cContextMenu[7][0], 0)
	$cContextMenu[10][1] = 'GUIDE'
	$cContextMenu[11][0] = GUICtrlCreateMenuItem(__Lang_Get('README', 'Readme'), $cContextMenu[7][0], 1)
	$cContextMenu[11][1] = 'README'
	$cContextMenu[12][0] = GUICtrlCreateMenuItem(__Lang_Get('ABOUT', 'About') & "...", $cContextMenu[7][0], 2)
	$cContextMenu[12][1] = 'ABOUT'

	$cContextMenu[13][0] = GUICtrlCreateMenuItem(__Lang_Get('CUSTOMIZE', 'Customize'), $cContextMenu[4][0], 0)
	$cContextMenu[14][0] = GUICtrlCreateMenuItem("", $cContextMenu[4][0], 1)

	__SetItemImage("ASSO", 0, $cContextMenu[1][0], 0, 1)
	__SetItemImage("PROF", 2, $cContextMenu[1][0], 0, 1)
	__SetItemImage("OPT", 3, $cContextMenu[1][0], 0, 1)
	__SetItemImage("HIDE", 4, $cContextMenu[1][0], 0, 1)
	__SetItemImage("HELP", 5, $cContextMenu[1][0], 0, 1)
	__SetItemImage("CLOSE", 7, $cContextMenu[1][0], 0, 1)
	__SetItemImage("GUIDE", 0, $cContextMenu[7][0], 0, 1)
	__SetItemImage("READ", 1, $cContextMenu[7][0], 0, 1)
	__SetItemImage("ABOUT", 2, $cContextMenu[7][0], 0, 1)
	__SetItemImage("CUST", 0, $cContextMenu[4][0], 0, 1)

	Local $B = $cContextMenu[0][0] + 1
	For $A = 1 To $cProfileList[0]
		If UBound($cContextMenu, 1) <= $cContextMenu[0][0] + 1 Then
			ReDim $cContextMenu[UBound($cContextMenu, 1) * 2][$cContextMenu[0][1]] ; ReDim $cContextMenu If More Items Are Required.
		EndIf
		$cContextMenu[$B][0] = GUICtrlCreateMenuItem($cProfileList[$A], $cContextMenu[4][0], $A + 1, 1)
		__SetItemImage(__IsProfile($cProfileList[$A], 2), $A + 1, $cContextMenu[4][0], 0, 0, 20, 20)
		$cContextMenu[$B][1] = $cProfileList[$A]
		If $cProfileList[$A] = $cCurrentProfile Then
			GUICtrlSetState($cContextMenu[$B][0], 1)
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

Func _ContextMenu_Delete($cHandle, $cCurrentProfile)
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
	GUICtrlSetTip($cHandle, __Lang_Get('TITLE_TOOLTIP', 'Sort your files with a drop!'), "DropIt [" & $cCurrentProfile & "]")
	_WinAPI_SetFocus(GUICtrlGetHandle($cHandle)) ; Set The $Global_Icon_1 Label As Having Focus, Used For The HotKeys.
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

	$aUpdateText = GUICtrlCreateLabel("", 80, 101, 310, 18)
	If __IsWindowsVersion() = 0 Then
		$aUpdateProgress = GUICtrlCreateProgress(200, 16, 190, 14, 0x01)
		GUICtrlSetState($aUpdateProgress, $GUI_HIDE)
	Else
		$aUpdateProgress = GUICtrlCreatePic("", 200, 16, 190, 14)
	EndIf

	$aUpdate = GUICtrlCreateButton(__Lang_Get('CHECK_UPDATE', 'Check Update'), 10, 120, 120, 25)
	$aLicense = GUICtrlCreateButton("&" & __Lang_Get('LICENSE', 'License'), 250, 120, 65, 25)
	If FileExists(@ScriptDir & "\License.txt") = 0 Then
		GUICtrlSetState($aLicense, $GUI_HIDE)
	EndIf
	$aClose = GUICtrlCreateButton("&" & __Lang_Get('CLOSE', 'Close'), 325, 120, 65, 25)

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
			Case $GUI_EVENT_CLOSE, $aClose
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
				If _WinAPI_PathIsDirectory($uArray[$A][0]) Then
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

Func _Update_Check($uHandle = -1, $uProgress = -1, $uCancel = -1)
	Local $uBackground_GUI
	Local $uINI = __IsSettingsFile()

	If __Is("Update", -1, "False") Then
		MsgBox(0, __Lang_Get('UPDATE_MSGBOX_0', 'Successfully Updated'), __Lang_Get('UPDATE_MSGBOX_1', 'New version %VersionNo% is now ready to be used.'), 10, __OnTop())
		IniDelete($uINI, "General", "Update")
		Return 1
	EndIf
	If $uHandle = -1 Then
		If __Is("CheckUpdates") Then ; Create A Hidden Update GUI.
			$uBackground_GUI = GUICreate(__Lang_Get('UPDATE_MSGBOX_10', 'DropIt Updating'), 330, 95, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop())
			$uHandle = GUICtrlCreateLabel("", 10, 12, 310, 18)
			If __IsWindowsVersion() = 0 Then
				$uProgress = GUICtrlCreateProgress(10, 12 + 25, 310, 14, 0x01)
			Else
				$uProgress = GUICtrlCreatePic("", 10, 12 + 25, 310, 14)
			EndIf
			$uCancel = GUICtrlCreateButton("&" & __Lang_Get('CANCEL', 'Cancel'), 165 - 40, 12 + 50, 80, 25)
		Else
			Return SetError(1, 0, 0)
		EndIf
	EndIf

	Local $uMsgBox, $uDownload, $uVersion, $uPage, $uCancelRead, $uCancelled = 0, $uPercent = 0, $uBefore = ">DropIt Installer ", $uAfter = "<"
	Local $uSize, $uCurrentPercent, $uDownloaded, $uText, $uDownloadURL, $uDownloadFile, $uDownloadName

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
		__SetProgress($uProgress, 0, 3)

		GUISetState(@SW_SHOW, $uBackground_GUI) ; Show The Background GUI If It Exists.
		$uCancelRead = GUICtrlRead($uCancel)
		GUICtrlSetData($uCancel, "&" & __Lang_Get('CANCEL', 'Cancel'))
		$uDownloadName = "DropIt_v" & StringReplace($uVersion, " ", "_") & "_Portable"
		$uDownloadFile = @ScriptDir & "\" & $uDownloadName & ".zip"

		GUICtrlSetData($uHandle, StringReplace(__Lang_Get('UPDATE_MSGBOX_8', 'Calculating size for version %NewVersion%'), '%NewVersion%', $uVersion))
		$uSize = InetGetSize($uDownloadURL, 1) ; Get Download Size.
		$uDownload = InetGet($uDownloadURL, $uDownloadFile, 17, 1) ; Start Download.
		While InetGetInfo($uDownload, 2) = 0 ; Whilst Complete Is False.
			$uDownloaded = InetGetInfo($uDownload, 0) ; Bytes Downloaded So Far.
			$uCurrentPercent = Round($uDownloaded * 100 / $uSize, 0) ; Percentage Of Downloaded File.

			If $uCurrentPercent > $uPercent Then
				__SetProgress($uProgress, $uCurrentPercent, 3)
				$uPercent = $uCurrentPercent
				$uText = __Lang_Get('UPDATE_MSGBOX_9', 'Downloading %CurrentSize% of %TotalSize%')
				$uText = StringReplace($uText, '%CurrentSize%', __ByteSuffix($uDownloaded))
				$uText = StringReplace($uText, '%TotalSize%', __ByteSuffix($uSize))
				GUICtrlSetData($uHandle, $uCurrentPercent & "% " & $uText)
			EndIf

			If InetGetInfo($uDownload, 4) <> 0 Then
				InetClose($uDownload)
				FileDelete($uDownloadFile)
				GUICtrlSetData($uHandle, __Lang_Get('UPDATE_MSGBOX_7', 'An error occured during software download.'))
				Return SetError(1, 0, 0)
			EndIf

			Switch GUIGetMsg()
				Case $GUI_EVENT_CLOSE, $uCancel
					$uCancelled = 1
					InetClose($uDownload)
					ExitLoop
			EndSwitch
		WEnd
		InetClose($uDownload)
		GUICtrlSetData($uCancel, $uCancelRead)
		__SetProgress($uProgress, 100, 3)

		If FileGetSize($uDownloadFile) <> $uSize Or $uCancelled = 1 Then ; Check If Download FileSize Is The Same As On The Server.
			GUICtrlSetData($uHandle, __Lang_Get('UPDATE_MSGBOX_7', 'An error occured during software download.'))
			If FileExists($uDownloadFile) Then
				FileDelete($uDownloadFile)
			EndIf
			GUIDelete($uBackground_GUI) ; Delete The Background GUI If It Exists.
			Return SetError(1, 0, 0)
		EndIf

		__7ZipRun($uDownloadFile, __GetDefault(1) & "ZIP", 1, 0) ; __GetDefault(1) = Get The Default Settings Directory.
		FileDelete($uDownloadFile)
		_Update_Batch(@ScriptDir & "\" & "ZIP" & "\" & $uDownloadName & "\")
		__IniWriteEx(__IsSettingsFile(), "General", "Update", "True")
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
	GUICtrlSetTip($mCombo_Profile, __Lang_Get('MONITORED_FOLDER_TIP_1', 'Select the group of associations to use on this folder.'))
	GUICtrlSetData($mCombo_Profile, __ProfileList_Combo(), $mProfile[1])

	$mSave = GUICtrlCreateButton("&" & __Lang_Get('SAVE', 'Save'), 150 - 20 - 75, 90, 75, 24)
	$mCancel = GUICtrlCreateButton("&" & __Lang_Get('CANCEL', 'Cancel'), 150 + 20, 90, 75, 24)
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
				$mFolder = GUICtrlRead($mInput_Folder)
				If __StringIsValid($mFolder) = 0 Then
					MsgBox(0x30, __Lang_Get('MONITORED_FOLDER_MSGBOX_0', 'Folder Error'), __Lang_Get('MONITORED_FOLDER_MSGBOX_1', 'You must specify a valid directory.'), 0, __OnTop($mGUI))
					ContinueLoop
				EndIf
				__IniWriteEx($mINI, "MonitoredFolders", $mFolder, GUICtrlRead($mCombo_Profile))
				ExitLoop

			Case $mButton_Folder
				$mFolder = FileSelectFolder(__Lang_Get('MONITORED_FOLDER_MSGBOX_2', 'Select a monitored folder:'), "", 3, "", $mGUI)
				$mFolder = _WinAPI_PathRemoveBackslash($mFolder)
				If __Is("ConvertPath") Then
					Local $mRelative = __GetRelativePath($mFolder)
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
	Local $mMonitored = __IniReadSection($mINI, "MonitoredFolders") ; Get Associations Array For The Current Profile.
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

	Local $oCheckItems[28] = [27], $oCheckModeItems[5] = [4], $oRadioItems[4] = [3], $oComboItems[6] = [5], $oGroup[6] = [5], $oCurrent[6] = [5]
	Local $oINI_TrueOrFalse_Array[28][3] = [ _
			[27, 3], _
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
			["General", "AlertSize", 1], _
			["General", "AlertDelete", 1], _
			["General", "ConvertPath", 1], _
			["General", "WaitOpened", 1], _
			["General", "Monitoring", 1], _
			["General", "CheckUpdates", 1], _
			["General", "Minimized", 1], _
			["General", "ScanSubfolders", 1], _
			["General", "ListSortable", 1], _
			["General", "ListFilter", 1], _
			["General", "ListHeader", 1], _
			["General", "UseShell", 1]]
	Local $oINI_Various_Array[12][2] = [ _
			[11, 2], _
			["General", "SendToMode"], _
			["General", "DupMode"], _
			["General", "ArchiveFormat"], _
			["General", "ArchiveLevel"], _
			["General", "ArchiveMethod"], _
			["General", "ArchiveEncryptMethod"], _
			["General", "ArchivePassword"], _
			["General", "MasterPassword"], _
			["General", "MonitoringTime"], _
			["General", "ListTheme"], _
			["General", "ShellMode"]]

	Local $oPW, $oPW_Code = $Global_Password_Key
	Local $oBackupDirectory = __GetDefault(32) ; Get Default Backup Directory.
	Local $oLogFile = __GetDefault(513) ; Get Default Directory & LogFile File Name.
	Local $oThemeFolder = @ScriptDir & "\Lib\list\themes\"
	Local $oGUI, $oOK, $oCancel, $oMsg, $oMsgBox, $oLanguage, $oLanguageCombo, $oImageList, $oLog, $oWriteLog, $oState, $oTab_1, $oCreateTab
	Local $oPassword, $oShowPassword, $oMasterPassword, $oShowMasterPassword, $oBk_Backup, $oBk_Restore, $oBk_Remove, $oNewDummy, $oEnterDummy
	Local $oListView, $oListView_Handle, $oIndex_Selected, $oFolder_Selected, $oMn_Add, $oMn_Edit, $oMn_Remove, $oScanTime, $oThemePreview, $oNoPreview

	$oGUI = GUICreate(__Lang_Get('OPTIONS', 'Options'), 380, 350, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($oHandle))

	$oCreateTab = GUICtrlCreateTab(0, 0, 380, 313) ; Create Tab Menu.

	; MAIN Tab:
	$oTab_1 = GUICtrlCreateTabItem(__Lang_Get('OPTIONS_TAB_0', 'Main'))
	GUICtrlSetState(-1, $GUI_SHOW) ; Show This Tab At Options Opening.

	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_16', 'Interface'), 10, 30, 359, 105)
	$oCheckItems[1] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_0', 'Show target image always on top'), 25, 30 + 15)
	$oCheckItems[2] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_7', 'Lock target image position'), 25, 30 + 15 + 20)
	$oCheckItems[13] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_13', 'Use profile icon in traybar'), 25, 30 + 15 + 40)
	$oCheckItems[11] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_11', 'Show progress bar during process'), 25, 30 + 15 + 60)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_3', 'Usage'), 10, 140, 359, 105)
	$oCheckItems[14] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_14', 'Start on system startup'), 25, 140 + 15)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_3', 'Note that this is a not portable feature.'))
	$oCheckItems[22] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_21', 'Start minimized to system tray'), 25, 140 + 15 + 20)
	$oCheckItems[27] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_27', 'Integrate in Context menu'), 25, 140 + 15 + 40, 290, 20)
	$oCheckModeItems[1] = GUICtrlCreateCheckbox("", 25 + 295, 140 + 15 + 40, 20, 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_1', 'This integration is created at DropIt startup and removed at closing.'), __Lang_Get('OPTIONS_MODE_6', 'Portable Mode'), 0)
	$oCheckModeItems[2] = GUICtrlCreateIcon(@ScriptFullPath, -17, 25 + 315, 140 + 15 + 40 + 1, 16, 16)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_1', 'This integration is created at DropIt startup and removed at closing.'), __Lang_Get('OPTIONS_MODE_6', 'Portable Mode'), 0)
	$oCheckItems[4] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_6', 'Integrate in SendTo menu'), 25, 140 + 15 + 60, 290, 20)
	$oCheckModeItems[3] = GUICtrlCreateCheckbox("", 25 + 295, 140 + 15 + 60, 20, 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_1', 'This integration is created at DropIt startup and removed at closing.'), __Lang_Get('OPTIONS_MODE_6', 'Portable Mode'), 0)
	$oCheckModeItems[4] = GUICtrlCreateIcon(@ScriptFullPath, -17, 25 + 315, 140 + 15 + 60 + 1, 16, 16)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_1', 'This integration is created at DropIt startup and removed at closing.'), __Lang_Get('OPTIONS_MODE_6', 'Portable Mode'), 0)
	GUICtrlCreateGroup('', -99, -99, 1, 1)

	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_1', 'Language'), 10, 250, 359, 50)
	$oLanguageCombo = _GUICtrlComboBoxEx_Create($oGUI, "", 25, 250 + 15 + 3, 330, 260, 0x0003)
	$oImageList = _GUIImageList_Create(16, 16, 5, 3) ; Create An ImageList.
	_GUICtrlComboBoxEx_SetImageList($oLanguageCombo, $oImageList)
	$Global_ImageList = $oImageList
	__LangList_Combo($oLanguageCombo)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; MONITORING Tab:
	GUICtrlCreateTabItem(__Lang_Get('OPTIONS_TAB_4', 'Monitoring'))

	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_15', 'Folders Monitoring'), 10, 30, 359, 270)
	$oCheckItems[20] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_19', 'Temporized scan'), 25, 30 + 15 + 2, 250, 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_10', 'Schedule a temporized scan of defined folders.'))
	$oScanTime = GUICtrlCreateInput("", 25 + 270, 30 + 15, 60, 20, 0x2000)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_9', 'Time interval in seconds.'))
	$oListView = GUICtrlCreateListView(__Lang_Get('MONITORED_FOLDER', 'Monitored Folder') & "|" & __Lang_Get('ASSOCIATED_PROFILE', 'Associated Profile'), 20, 30 + 15 + 30, 340, 185, BitOR($LVS_NOSORTHEADER, $LVS_REPORT, $LVS_SINGLESEL))
	$oMn_Add = GUICtrlCreateButton(__Lang_Get('OPTIONS_BUTTON_4', 'Add'), 25, 250 + 15 + 3, 90, 22)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_BUTTON_4', 'Add'))
	$oMn_Edit = GUICtrlCreateButton(__Lang_Get('OPTIONS_BUTTON_5', 'Edit'), 25 + 120, 250 + 15 + 3, 90, 22)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_BUTTON_5', 'Edit'))
	$oMn_Remove = GUICtrlCreateButton(__Lang_Get('OPTIONS_BUTTON_3', 'Remove'), 25 + 240, 250 + 15 + 3, 90, 22)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_BUTTON_3', 'Remove'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; SORTING Tab:
	GUICtrlCreateTabItem(__Lang_Get('OPTIONS_TAB_1', 'Sorting'))

	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_0', 'General'), 10, 30, 359, 165)
	$oCheckItems[6] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_2', 'Enable associations for folders'), 25, 30 + 15)
	$oCheckItems[23] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_22', 'Scan also subfolders'), 25, 30 + 15 + 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_11', 'It does not work if folders association is enabled.'))
	$oCheckItems[7] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_3', 'Ignore unassociated files/folders'), 25, 30 + 15 + 40)
	$oCheckItems[16] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_16', 'Alert for large loaded files'), 25, 30 + 15 + 60)
	$oCheckItems[17] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_23', 'Alert for Delete actions'), 25, 30 + 15 + 80)
	$oCheckItems[15] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_4', 'Check moved/copied files integrity'), 25, 30 + 15 + 100)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_4', 'Activating MD5 check could slow down sorting processes.'))
	$oCheckItems[19] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_18', 'Wait closing of opened files'), 25, 30 + 15 + 120)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_8', 'Pause sorting process at each "Open With" action.'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_5', 'Manage Duplicates'), 10, 200, 359, 65)
	$oCheckItems[8] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_5', 'Use automatic choice for duplicates'), 25, 200 + 15)
	$oRadioItems[1] = GUICtrlCreateRadio(__Lang_Get('OPTIONS_MODE_2', 'Overwrite'), 25, 200 + 15 + 22, 100, 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_MODE_2', 'Overwrite'))
	$oRadioItems[2] = GUICtrlCreateRadio(__Lang_Get('OPTIONS_MODE_3', 'Skip'), 25 + 120, 200 + 15 + 22, 100, 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_MODE_3', 'Skip'))
	$oRadioItems[3] = GUICtrlCreateRadio(__Lang_Get('OPTIONS_MODE_4', 'Rename'), 25 + 230, 200 + 15 + 22, 100, 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_MODE_4', 'Rename'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; COMPRESSION Tab:
	GUICtrlCreateTabItem(__Lang_Get('OPTIONS_TAB_2', 'Compression'))

	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_8', 'Modality'), 10, 30, 359, 135)
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_10', 'Format') & ":", 25, 30 + 15 + 6, 110, 20)
	$oComboItems[1] = GUICtrlCreateCombo("", 25 + 120, 30 + 15 + 3, 210, 20, 0x0003)
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_11', 'Level') & ":", 25, 30 + 15 + 30 + 6, 110, 20)
	$oComboItems[2] = GUICtrlCreateCombo("", 25 + 120, 30 + 15 + 30 + 3, 210, 20, 0x0003)
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_12', 'Method') & ":", 25, 30 + 15 + 60 + 6, 110, 20)
	$oComboItems[3] = GUICtrlCreateCombo("", 25 + 120, 30 + 15 + 60 + 3, 210, 20, 0x0003)
	$oCheckItems[9] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_9', 'Create self-extracting archives'), 25, 30 + 15 + 90)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_9', 'Encryption'), 10, 170, 359, 110)
	$oCheckItems[10] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_10', 'Encrypt compressed files/folders'), 25, 170 + 15 + 3)
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_13', 'Password') & ":", 25, 170 + 15 + 30 + 3, 110, 20)
	$oPassword = GUICtrlCreateInput("", 25 + 120, 170 + 15 + 30, 196, 20, 0x0020)
	$oShowPassword = GUICtrlCreateButton("", 25 + 120 + 196, 170 + 15 + 30, 14, 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_2', 'Show/Hide the password.'))
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_12', 'Method') & ":", 25, 170 + 15 + 60 + 3, 110, 20)
	$oComboItems[4] = GUICtrlCreateCombo("", 25 + 120, 170 + 15 + 60, 210, 20, 0x0003)
	GUICtrlSetData(-1, "", "")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; LISTS Tab:
	GUICtrlCreateTabItem(__Lang_Get('OPTIONS_TAB_5', 'Lists'))
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_0', 'General'), 10, 30, 359, 85)
	$oCheckItems[24] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_24', 'Create sortable HTML lists'), 25, 30 + 15)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_12', 'Add a JavaScript code to make sortable each HTML list.'))
	$oCheckItems[25] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_25', 'Add box to filter HTML lists'), 25, 30 + 15 + 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_13', 'Add a JavaScript code to filter items of each HTML list.'))
	$oCheckItems[26] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_26', 'Add header to TXT and CSV lists'), 25, 30 + 15 + 40)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_17', 'HTML Theme'), 10, 120, 359, 182)
	$oComboItems[5] = GUICtrlCreateCombo("", 25, 120 + 15 + 3, 330, 20, 0x0003)
	$oThemePreview = GUICtrlCreatePic($oThemeFolder & "Default.jpg", 25, 120 + 15 + 35, 330, 120)
	$oNoPreview = GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_18', 'Preview Not Available'), 25 + 85, 120 + 15 + 85, 130, 40)
	GUICtrlSetState($oNoPreview, $GUI_HIDE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; VARIOUS Tab:
	GUICtrlCreateTabItem(__Lang_Get('OPTIONS_TAB_3', 'Various'))

	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_0', 'General'), 10, 30, 359, 85)
	$oCheckItems[3] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_8', 'Enable multiple instances'), 25, 30 + 15)
	$oCheckItems[21] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_20', 'Check for updates at DropIt startup'), 25, 30 + 15 + 20)
	$oCheckItems[18] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_17', 'Convert to relative path if possible'), 25, 30 + 15 + 40)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_7', 'Convert destination folder to relative path at association editing.'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_14', 'Security'), 10, 120, 359, 75)
	$oCheckItems[12] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_12', 'Encrypt profiles at DropIt closing'), 25, 120 + 15)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_6', 'Password will be requested at DropIt startup.'))
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_13', 'Password') & ":", 25, 120 + 15 + 30, 110, 20)
	$oMasterPassword = GUICtrlCreateInput("", 25 + 120, 120 + 15 + 27, 196, 20, 0x0020)
	$oShowMasterPassword = GUICtrlCreateButton("", 25 + 120 + 196, 120 + 15 + 27, 14, 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_2', 'Show/Hide the password.'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_7', 'Activity Log'), 10, 200, 359, 50)
	$oCheckItems[5] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_1', 'Write log file'), 25, 200 + 15 + 3, 190, 20)
	$oLog = GUICtrlCreateButton(__Lang_Get('OPTIONS_BUTTON_0', 'Read'), 25 + 240, 200 + 15 + 2, 90, 22)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_2', 'Settings Backup'), 10, 255, 359, 50)
	$oBk_Backup = GUICtrlCreateButton(__Lang_Get('OPTIONS_BUTTON_1', 'Backup'), 25, 255 + 15 + 3, 90, 22)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_BUTTON_1', 'Backup'))
	$oBk_Restore = GUICtrlCreateButton(__Lang_Get('OPTIONS_BUTTON_2', 'Restore'), 25 + 120, 255 + 15 + 3, 90, 22)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_BUTTON_2', 'Restore'))
	$oBk_Remove = GUICtrlCreateButton(__Lang_Get('OPTIONS_BUTTON_3', 'Remove'), 25 + 240, 255 + 15 + 3, 90, 22)
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
	$oGroup[5] = __ThemeList_Combo()
	$oCurrent[5] = IniRead($oINI, "General", "ListTheme", "Default")
	If StringInStr($oGroup[5], $oCurrent[5]) = 0 Then
		$oCurrent[5] = "Default"
	EndIf
	If FileExists($oThemeFolder & $oCurrent[5] & ".jpg") Then
		GUICtrlSetImage($oThemePreview, $oThemeFolder & $oCurrent[5] & ".jpg")
		GUICtrlSetState($oThemePreview, $GUI_SHOW)
		GUICtrlSetState($oNoPreview, $GUI_HIDE)
	Else
		GUICtrlSetState($oThemePreview, $GUI_HIDE)
		GUICtrlSetState($oNoPreview, $GUI_SHOW)
	EndIf
	For $A = 1 To 5
		GUICtrlSetData($oComboItems[$A], $oGroup[$A], $oCurrent[$A])
	Next

	; Context Menu Integration Settings:
	$oState = $GUI_DISABLE
	If GUICtrlRead($oCheckItems[27]) = 1 Then
		$oState = $GUI_ENABLE
	EndIf
	For $A = 1 To 2
		GUICtrlSetState($oCheckModeItems[$A], $oState)
	Next
	If IniRead($oINI, "General", "ShellMode", "Portable") = "Portable" Then
		GUICtrlSetState($oCheckModeItems[1], $GUI_CHECKED)
	Else
		GUICtrlSetState($oCheckModeItems[1], $GUI_UNCHECKED)
	EndIf

	; SendTo Integration Settings:
	$oState = $GUI_DISABLE
	If GUICtrlRead($oCheckItems[4]) = 1 Then
		$oState = $GUI_ENABLE
	EndIf
	For $A = 3 To 4
		GUICtrlSetState($oCheckModeItems[$A], $oState)
	Next
	If IniRead($oINI, "General", "SendToMode", "Portable") = "Portable" Then
		GUICtrlSetState($oCheckModeItems[3], $GUI_CHECKED)
	Else
		GUICtrlSetState($oCheckModeItems[3], $GUI_UNCHECKED)
	EndIf

	; Log Settings:
	$oState = $GUI_DISABLE
	If GUICtrlRead($oCheckItems[5]) = 1 Then
		$oState = $GUI_ENABLE
	EndIf
	GUICtrlSetState($oLog, $oState)

	; Folder Association Settings:
	$oState = $GUI_ENABLE
	If GUICtrlRead($oCheckItems[6]) = 1 Then
		$oState = $GUI_DISABLE
	EndIf
	GUICtrlSetState($oCheckItems[23], $oState)

	; Backup Settings:
	For $A = $oBk_Backup To $oBk_Restore ; Disable Buttons If 7-Zip Is Missing.
		If FileExists(@ScriptDir & "\Lib\7z\7z.exe") = 0 Then
			GUICtrlSetState($A, $GUI_DISABLE)
		EndIf
	Next
	If FileExists(__GetDefault(32)) = 0 Then ; __GetDefault(32) = Get Default Backup Directory.
		GUICtrlSetState($oBk_Remove, $GUI_DISABLE)
	EndIf

	; Duplicate Mode Settings:
	$oState = $GUI_DISABLE
	If GUICtrlRead($oCheckItems[8]) = 1 Then
		$oState = $GUI_ENABLE
	EndIf
	For $A = 1 To 3
		GUICtrlSetState($oRadioItems[$A], $oState)
	Next
	If IniRead($oINI, "General", "DupMode", "Overwrite") = "Overwrite" Then
		GUICtrlSetState($oRadioItems[1], $GUI_CHECKED)
		GUICtrlSetState($oRadioItems[2], $GUI_UNCHECKED)
		GUICtrlSetState($oRadioItems[3], $GUI_UNCHECKED)
	ElseIf IniRead($oINI, "General", "DupMode", "Overwrite") = "Skip" Then
		GUICtrlSetState($oRadioItems[1], $GUI_UNCHECKED)
		GUICtrlSetState($oRadioItems[2], $GUI_CHECKED)
		GUICtrlSetState($oRadioItems[3], $GUI_UNCHECKED)
	Else
		GUICtrlSetState($oRadioItems[1], $GUI_UNCHECKED)
		GUICtrlSetState($oRadioItems[2], $GUI_UNCHECKED)
		GUICtrlSetState($oRadioItems[3], $GUI_CHECKED)
	EndIf

	; Self-Extracting Settings:
	If GUICtrlRead($oComboItems[1]) = "ZIP" Then
		GUICtrlSetState($oCheckItems[9], $GUI_DISABLE)
	EndIf

	; Encryption Settings:
	$oState = $GUI_DISABLE
	If GUICtrlRead($oCheckItems[10]) = 1 Then
		$oState = $GUI_ENABLE
	EndIf
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
	If GUICtrlRead($oCheckItems[20]) = 1 Then
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
	$Global_ListViewFolders = $oListView_Handle
	_GUICtrlListView_SetExtendedListViewStyle($oListView_Handle, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_INFOTIP))
	_GUICtrlListView_SetColumnWidth($oListView_Handle, 0, 175)
	_GUICtrlListView_SetColumnWidth($oListView_Handle, 1, 135)
	Local $oToolTip = _GUICtrlListView_GetToolTips($oListView_Handle)
	If IsHWnd($oToolTip) Then
		__OnTop($oToolTip, 1)
		_GUIToolTip_SetDelayTime($oToolTip, 3, 60) ; Speed Up InfoTip Appearance.
	EndIf
	$oNewDummy = GUICtrlCreateDummy()
	$Global_ListViewFolders_New = $oNewDummy
	$oEnterDummy = GUICtrlCreateDummy()
	$Global_ListViewFolders_Enter = $oEnterDummy
	_Monitored_Update($oListView_Handle, $oINI)

	$oOK = GUICtrlCreateButton("&" & __Lang_Get('OK', 'OK'), 190 - 25 - 85, 318, 85, 26)
	$oCancel = GUICtrlCreateButton("&" & __Lang_Get('CANCEL', 'Cancel'), 190 + 25, 318, 85, 26)
	GUICtrlSetState($oOK, $GUI_DEFBUTTON)

	$Global_ListViewIndex = -1 ; Set As No Item Selected.
	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
	GUISetState(@SW_SHOW)

	Local $oHotKeys[3][2] = [["^n", $oMn_Add],["{DELETE}", $oMn_Remove],["{ENTER}", $oMn_Edit]]
	GUISetAccelerators($oHotKeys)

	_WinAPI_EmptyWorkingSet() ; Reduce Memory Usage Of DropIt.
	While 1
		$oIndex_Selected = $Global_ListViewIndex

		; Update Compression Combo If Format Changes:
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

		; Update Image Preview If Theme Changes:
		If GUICtrlRead($oComboItems[5]) <> $oCurrent[5] And Not _GUICtrlComboBox_GetDroppedState($oComboItems[5]) Then
			$oCurrent[5] = GUICtrlRead($oComboItems[5])
			If FileExists($oThemeFolder & $oCurrent[5] & ".jpg") Then
				GUICtrlSetImage($oThemePreview, $oThemeFolder & $oCurrent[5] & ".jpg")
				GUICtrlSetState($oThemePreview, $GUI_SHOW)
				GUICtrlSetState($oNoPreview, $GUI_HIDE)
			Else
				GUICtrlSetState($oThemePreview, $GUI_HIDE)
				GUICtrlSetState($oNoPreview, $GUI_SHOW)
			EndIf
		EndIf

		$oMsg = GUIGetMsg()
		Switch $oMsg
			Case $GUI_EVENT_CLOSE, $oCancel
				SetError(1, 0, 0)
				ExitLoop

			Case $oCreateTab ; Move Combo When Switching Tabs.
				Switch GUICtrlRead($oCreateTab, 1)
					Case $oTab_1
						ControlMove($oGUI, "", $oLanguageCombo, 25, 250 + 15 + 3)

					Case Else
						If $oLanguageCombo Then
							ControlMove($oGUI, "", $oLanguageCombo, -99, -99)
						EndIf

				EndSwitch

			Case $oCheckItems[4] ; SendTo Integration Checkbox.
				$oState = $GUI_DISABLE
				If GUICtrlRead($oCheckItems[4]) = 1 Then
					$oState = $GUI_ENABLE
				EndIf
				For $A = 3 To 4
					GUICtrlSetState($oCheckModeItems[$A], $oState)
				Next

			Case $oCheckItems[5] ; Log Checkbox.
				$oState = $GUI_DISABLE
				If GUICtrlRead($oCheckItems[5]) = 1 Then
					$oState = $GUI_ENABLE
				EndIf
				GUICtrlSetState($oLog, $oState)

			Case $oCheckItems[6] ; Folder Association Checkbox.
				$oState = $GUI_ENABLE
				If GUICtrlRead($oCheckItems[6]) = 1 Then
					$oState = $GUI_DISABLE
					GUICtrlSetState($oCheckItems[23], $GUI_UNCHECKED)
				EndIf
				GUICtrlSetState($oCheckItems[23], $oState)

			Case $oCheckItems[8] ; Duplicate Mode Checkbox.
				$oState = $GUI_DISABLE
				If GUICtrlRead($oCheckItems[8]) = 1 Then
					$oState = $GUI_ENABLE
				EndIf
				For $A = 1 To 3
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

			Case $oCheckItems[20] ; Monitoring Checkbox.
				$oState = $GUI_DISABLE
				If GUICtrlRead($oCheckItems[20]) = 1 Then
					$oState = $GUI_ENABLE
				EndIf
				GUICtrlSetState($oScanTime, $oState)
				GUICtrlSetState($oListView, $oState)
				GUICtrlSetState($oMn_Add, $oState)
				GUICtrlSetState($oMn_Edit, $oState)
				GUICtrlSetState($oMn_Remove, $oState)

			Case $oCheckItems[27] ; Context Menu Integration Checkbox.
				$oState = $GUI_DISABLE
				If GUICtrlRead($oCheckItems[27]) = 1 Then
					$oState = $GUI_ENABLE
				EndIf
				For $A = 1 To 2
					GUICtrlSetState($oCheckModeItems[$A], $oState)
				Next

			Case $oLog
				If FileExists($oLogFile[1][0] & $oLogFile[2][0]) Then
					ShellExecute($oLogFile[1][0] & $oLogFile[2][0])
				Else
					GUICtrlSetState($oCheckItems[5], 4)
					GUICtrlSetState($oLog, $GUI_DISABLE)
				EndIf

			Case $oNewDummy, $oMn_Add
				_Monitored_Edit_GUI($oGUI, $oINI, $oListView_Handle, -1, -1)
				_Monitored_Update($oListView_Handle, $oINI)

			Case $oEnterDummy, $oMn_Edit, $oMn_Remove
				$oIndex_Selected = _GUICtrlListView_GetSelectionMark($oListView_Handle)
				If Not _GUICtrlListView_GetItemState($oListView_Handle, $oIndex_Selected, $LVIS_SELECTED) Or $oIndex_Selected = -1 Then
					ContinueLoop
				EndIf
				$oFolder_Selected = _GUICtrlListView_GetItemText($oListView_Handle, $oIndex_Selected)

				If $oMsg = $oMn_Remove Then
					$oMsgBox = MsgBox(0x04, __Lang_Get('OPTIONS_MONITORED_MSGBOX_0', 'Delete monitored folder'), __Lang_Get('OPTIONS_MONITORED_MSGBOX_1', 'Are you sure to stop monitoring this folder?'), 0, __OnTop($oGUI))
					If $oMsgBox = 6 Then
						IniDelete($oINI, "MonitoredFolders", $oFolder_Selected)
						_GUICtrlListView_DeleteItem($oListView_Handle, $oIndex_Selected)
					EndIf
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
				__SetCurrentLanguage($oLanguage) ; Set The Selected Language To The Settings INI File.

				If __Is("UseShell", $oINI) And GUICtrlRead($oCheckItems[27]) <> 1 Then
					_ShellAll_Uninstall() ; Remove Context Menu Integration If It Is Been Disabled Now.
				EndIf

				If __Is("UseSendTo", $oINI) And GUICtrlRead($oCheckItems[4]) <> 1 Then
					__SendTo_Uninstall() ; Remove SendTo Integration If It Is Been Disabled Now.
				EndIf

				If __Is("CreateLog", $oINI) And GUICtrlRead($oCheckItems[5]) <> 1 Then
					__Log_Write("===== " & __Lang_Get('LOG_DISABLED', 'Log Disabled') & " =====")
				EndIf
				If __Is("CreateLog", $oINI) = 0 And GUICtrlRead($oCheckItems[5]) = 1 Then
					$oWriteLog = 1 ; Needed To Write "Log Enabled" After Log Activation.
				EndIf

				If _GUICtrlListView_GetItemCount($oListView_Handle) = 0 Then
					GUICtrlSetState($oCheckItems[20], $GUI_UNCHECKED) ; Disable Monitoring If ListView Is Empty.
				EndIf

				For $A = 1 To $oINI_TrueOrFalse_Array[0][0]
					$oState = "False"
					If $oINI_TrueOrFalse_Array[$A][0] = "" Or $oINI_TrueOrFalse_Array[$A][1] = "" Then
						ContinueLoop
					EndIf
					If GUICtrlRead($oCheckItems[$A]) = 1 Then
						$oState = "True"
					EndIf
					__IniWriteEx($oINI, $oINI_TrueOrFalse_Array[$A][0], $oINI_TrueOrFalse_Array[$A][1], $oState)
				Next

				If $oWriteLog = 1 Then
					__Log_Write("===== " & __Lang_Get('LOG_ENABLED', 'Log Enabled') & " =====")
				EndIf

				If GUICtrlRead($oCheckItems[14]) = 1 Then
					_StartupFolder_Install("DropIt")
				Else
					_StartupFolder_Uninstall("DropIt")
				EndIf

				$oState = "Permanent"
				If GUICtrlRead($oCheckModeItems[1]) = 1 Then
					$oState = "Portable"
				EndIf
				__IniWriteEx($oINI, $oINI_Various_Array[11][0], $oINI_Various_Array[11][1], $oState)

				$oState = "Permanent"
				If GUICtrlRead($oCheckModeItems[3]) = 1 Then
					$oState = "Portable"
				EndIf
				__IniWriteEx($oINI, $oINI_Various_Array[1][0], $oINI_Various_Array[1][1], $oState)

				If GUICtrlRead($oRadioItems[1]) = 1 Then
					$oState = "Overwrite"
				ElseIf GUICtrlRead($oRadioItems[2]) = 1 Then
					$oState = "Skip"
				Else
					$oState = "Rename"
				EndIf
				__IniWriteEx($oINI, $oINI_Various_Array[2][0], $oINI_Various_Array[2][1], $oState)

				__IniWriteEx($oINI, $oINI_Various_Array[3][0], $oINI_Various_Array[3][1], GUICtrlRead($oComboItems[1]))
				__IniWriteEx($oINI, $oINI_Various_Array[4][0], $oINI_Various_Array[4][1], GUICtrlRead($oComboItems[2]))
				__IniWriteEx($oINI, $oINI_Various_Array[5][0], $oINI_Various_Array[5][1], GUICtrlRead($oComboItems[3]))
				__IniWriteEx($oINI, $oINI_Various_Array[6][0], $oINI_Various_Array[6][1], GUICtrlRead($oComboItems[4]))
				__IniWriteEx($oINI, $oINI_Various_Array[10][0], $oINI_Various_Array[10][1], GUICtrlRead($oComboItems[5]))

				$Global_Timer = GUICtrlRead($oScanTime)
				__IniWriteEx($oINI, $oINI_Various_Array[9][0], $oINI_Various_Array[9][1], $Global_Timer)
				If GUICtrlRead($oCheckItems[20]) <> 1 Then
					$Global_Timer = 0 ; Monitoring Disabled.
				EndIf

				$oPW = ""
				If StringIsSpace(GUICtrlRead($oPassword)) = 0 And GUICtrlRead($oPassword) <> "" Then
					$oPW = _StringEncrypt(1, GUICtrlRead($oPassword), $oPW_Code)
				EndIf
				__IniWriteEx($oINI, $oINI_Various_Array[7][0], $oINI_Various_Array[7][1], $oPW)
				If $oPW = "" And GUICtrlRead($oCheckItems[10]) = 1 Then
					$oMsgBox = MsgBox(0x04, __Lang_Get('OPTIONS_ENCRYPTION_MSGBOX_0', 'Encryption is enabled'), __Lang_Get('OPTIONS_ENCRYPTION_MSGBOX_1', 'It appears the Password for Encryption is Blank, do you wish to disable?'), 0, __OnTop($oGUI))
					If $oMsgBox = 6 Then
						__IniWriteEx($oINI, $oINI_TrueOrFalse_Array[10][0], $oINI_TrueOrFalse_Array[10][1], "False") ; Disable Encryption If Password Is Blank.
						ExitLoop
					EndIf
					ContinueLoop
				EndIf

				$oPW = ""
				If StringIsSpace(GUICtrlRead($oMasterPassword)) = 0 And GUICtrlRead($oMasterPassword) <> "" Then
					$oPW = _StringEncrypt(1, GUICtrlRead($oMasterPassword), $oPW_Code)
				EndIf
				__IniWriteEx($oINI, $oINI_Various_Array[8][0], $oINI_Various_Array[8][1], $oPW)
				If $oPW = "" And GUICtrlRead($oCheckItems[12]) = 1 Then
					$oMsgBox = MsgBox(0x04, __Lang_Get('OPTIONS_ENCRYPTION_MSGBOX_0', 'Encryption is enabled'), __Lang_Get('OPTIONS_ENCRYPTION_MSGBOX_1', 'It appears the Password for Encryption is Blank, do you wish to disable?'), 0, __OnTop($oGUI))
					If $oMsgBox = 6 Then
						__IniWriteEx($oINI, $oINI_TrueOrFalse_Array[12][0], $oINI_TrueOrFalse_Array[12][1], "False") ; Disable Encryption If Password Is Blank.
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
	__Log_Write("===== " & __Lang_Get('DROPIT_CLOSED', 'DropIt Closed') & " =====")

	If __CheckMultipleInstances() = 0 Then ; Check The Number Of Multiple Instances.
		If __Is("UseShell", $eINI) And IniRead($eINI, "General", "ShellMode", "Portable") = "Portable" Then
			_ShellAll_Uninstall() ; Remove Context Menu Integration If In Portable Mode.
		EndIf
		If __Is("UseSendTo", $eINI) And IniRead($eINI, "General", "SendToMode", "Portable") = "Portable" Then
			__SendTo_Uninstall() ; Remove SendTo Integration If In Portable Mode.
		EndIf
		If __Is("ProfileEncryption", $eINI) Then
			__EncryptionFolder(0) ; Encrypt Profiles.
		EndIf
	EndIf
	_GDIPlus_Shutdown()
	Exit
EndFunc   ;==>_ExitEvent
#EndRegion >>>>> MAIN: General Functions <<<<<

#Region >>>>> MAIN: TrayMenu Functions <<<<<
Func _TrayMenu_Create()
	Local $tTrayMenu = _TrayMenu_Delete() ; Delete The Current TrayMenu Items.
	Local $tProfileList = __ProfileList_Get() ; Get Array Of All Profiles.

	$tTrayMenu[1][0] = TrayCreateItem(__Lang_Get('ASSOCIATIONS', 'Associations'), -1, 0)
	$tTrayMenu[2][0] = TrayCreateItem("", -1, 1)
	$tTrayMenu[3][0] = TrayCreateMenu(__Lang_Get('PROFILES', 'Profiles'), -1, 2)
	$tTrayMenu[4][0] = TrayCreateItem(__Lang_Get('OPTIONS', 'Options'), -1, 3)
	$tTrayMenu[5][0] = TrayCreateItem(__Lang_Get('SHOW', 'Show'), -1, 4)
	$tTrayMenu[6][0] = TrayCreateMenu(__Lang_Get('HELP', 'Help'), -1, 5)
	$tTrayMenu[7][0] = TrayCreateItem("", -1, 6)
	$tTrayMenu[8][0] = TrayCreateItem(__Lang_Get('EXIT', 'Exit'), -1, 7)

	$tTrayMenu[9][0] = TrayCreateItem(__Lang_Get('GUIDE', 'Guide'), $tTrayMenu[6][0], 0)
	$tTrayMenu[9][1] = 'GUIDE'
	$tTrayMenu[10][0] = TrayCreateItem(__Lang_Get('README', 'Readme'), $tTrayMenu[6][0], 1)
	$tTrayMenu[10][1] = 'README'
	$tTrayMenu[11][0] = TrayCreateItem(__Lang_Get('ABOUT', 'About') & "...", $tTrayMenu[6][0], 2)
	$tTrayMenu[11][1] = 'ABOUT'

	$tTrayMenu[12][0] = TrayCreateItem(__Lang_Get('CUSTOMIZE', 'Customize'), $tTrayMenu[3][0], 0)
	$tTrayMenu[13][0] = TrayCreateItem("", $tTrayMenu[3][0], 1)

	Local $tMenuHandle = TrayItemGetHandle(0) ; Get Main Menu Handle.
	__SetItemImage("ASSO", 0, $tMenuHandle, 2, 1)
	__SetItemImage("PROF", 2, $tMenuHandle, 2, 1)
	__SetItemImage("OPT", 3, $tMenuHandle, 2, 1)
	__SetItemImage("SHOW", 4, $tMenuHandle, 2, 1)
	__SetItemImage("HELP", 5, $tMenuHandle, 2, 1)
	__SetItemImage("CLOSE", 7, $tMenuHandle, 2, 1)
	__SetItemImage("GUIDE", 0, $tTrayMenu[6][0], 1, 1)
	__SetItemImage("READ", 1, $tTrayMenu[6][0], 1, 1)
	__SetItemImage("ABOUT", 2, $tTrayMenu[6][0], 1, 1)
	__SetItemImage("CUST", 0, $tTrayMenu[3][0], 1, 1)

	Local $B = $tTrayMenu[0][0] + 1
	For $A = 1 To $tProfileList[0]
		If UBound($tTrayMenu, 1) <= $tTrayMenu[0][0] + 1 Then
			ReDim $tTrayMenu[UBound($tTrayMenu, 1) * 2][$tTrayMenu[0][1]] ; ReDim $tTrayMenu If More Items Are Required.
		EndIf
		$tTrayMenu[$B][0] = TrayCreateItem($tProfileList[$A], $tTrayMenu[3][0], $A + 1, 1)
		__SetItemImage(__IsProfile($tProfileList[$A], 2), $A + 1, $tTrayMenu[3][0], 1, 0, 20, 20)
		$tTrayMenu[$B][1] = $tProfileList[$A]
		TrayItemSetOnEvent($tTrayMenu[$B][0], "_ProfileEvent")
		If $tProfileList[$A] = __GetCurrentProfile() Then ; Get Current Profile From The Settings INI File.
			TrayItemSetState($tTrayMenu[$B][0], 1)
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

Func _TrayMenu_ShowTray()
	Local $sGUI_1 = $Global_GUI_1
	Local $sIcon_1 = GUICtrlGetHandle($Global_Icon_1)
	Local $sCurrentProfile = __GetCurrentProfile() ; Get Current Profile From The Settings INI File.
	Local $sToolTip = "DropIt [" & $sCurrentProfile & "]"

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
EndFunc   ;==>_TrayMenu_ShowTray

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
			If FileExists(@ScriptDir & "\Guide.pdf") Then
				ShellExecute(@ScriptDir & "\Guide.pdf")
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
#EndRegion >>>>> MAIN: TrayMenu Functions <<<<<

#Region >>>>> MAIN: WM_MESSAGES Functions <<<<<
Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg
	Local $cWndFrom, $cIDFrom, $cListViewRules_ComboBox = $Global_ListViewRules_ComboBox
	If IsHWnd($cListViewRules_ComboBox) = 0 Then
		$cListViewRules_ComboBox = GUICtrlGetHandle($cListViewRules_ComboBox)
	EndIf
	$cWndFrom = $ilParam
	$cIDFrom = BitAND($iwParam, 0xFFFF)
	Switch $cWndFrom
		Case $cListViewRules_ComboBox
			Switch BitShift($iwParam, 16)
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

Func WM_CONTEXTMENU($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam, $ilParam
	If $Global_MenuDisable Then
		Return 0
	EndIf
	Return "GUI_RUNDEFMSG"
EndFunc   ;==>WM_CONTEXTMENU

Func WM_COPYDATA($hWnd, $iMsg, $iwParam, $ilParam) ; Taken From: http://www.autoitscript.com/forum/topic/119502-solved-wm-copydata-x64-issue/
	#forceref $hWnd, $iMsg, $iwParam
	Local $aArray, $tData, $tParam, $tString
	$tParam = DllStructCreate("ulong_ptr;dword;ptr", $ilParam)
	$tData = DllStructCreate("wchar[" & DllStructGetData($tParam, 2) / 2 & "]", DllStructGetData($tParam, 3))
	$tString = DllStructGetData($tData, 1)
	$aArray = __CmdLineRaw($tString) ; Convert $CmdLineRaw To $CmdLine.
	__CMDLine($aArray)
EndFunc   ;==>WM_COPYDATA

Func WM_COPYDATA_SENDDATA($sTitleID, $sString) ; Taken From: http://www.autoitscript.com/forum/topic/119502-solved-wm-copydata-x64-issue/
	Local $hHandle, $ilParam, $sReturn = "", $tData

	$hHandle = WinGetHandle($sTitleID)
	If $hHandle = -1 Then
		Return SetError(1, 0, 0)
	EndIf

	If IsArray($sString) Then
		For $A = 1 To $sString[0]
			$sReturn &= $sString[$A] & "|"
		Next
		$sString = StringTrimRight($sReturn, 1)
	EndIf

	If StringStripWS($sString, 8) = "" Then
		Return SetError(2, 0, 0) ; String is blank.
	EndIf

	If $hHandle Then
		$tData = DllStructCreate("wchar[" & StringLen($sString) + 1 & "]")
		DllStructSetData($tData, 1, $sString)

		$ilParam = DllStructCreate("ulong_ptr;dword;ptr")
		DllStructSetData($ilParam, 1, 0)
		DllStructSetData($ilParam, 2, DllStructGetSize($tData))
		DllStructSetData($ilParam, 3, DllStructGetPtr($tData))
		_SendMessage($hHandle, $WM_COPYDATA, 0, DllStructGetPtr($ilParam))
		Return Number(Not @error)
	EndIf
EndFunc   ;==>WM_COPYDATA_SENDDATA

Func WM_DROPFILES($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $ilParam
	Local $aReturn
	Switch $iMsg
		Case $WM_DROPFILES
			$aReturn = _WinAPI_DragQueryFileEx($iwParam)
			If IsArray($aReturn) Then
				$Global_DroppedFiles = $aReturn
			EndIf
	EndSwitch
	Return "GUI_RUNDEFMSG"
EndFunc   ;==>WM_DROPFILES

Func WM_GETMINMAXINFO($hWnd, $iMsg, $iwParam, $ilParam) ; Enable The GUI From Being Dragged To A Certain Size.
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
	Switch BitShift($iwParam, 16)
		Case 0 ; If A Single Click Is Detected.
		Case 1 ; If A Double Click Is Detected.
			_TrayMenu_ShowTray() ; Show The TrayMenu.
	EndSwitch
	Return "GUI_RUNDEFMSG"
EndFunc   ;==>WM_LBUTTONDBLCLK

Func WM_MOUSEWHEEL($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $ilParam
	Local $mWheel = 1 ; Down.
	If BitShift($iwParam, 16) > 0 Then
		$mWheel = 2 ; Up.
	EndIf
	$Global_Wheel = $mWheel
	Return "GUI_RUNDEFMSG"
EndFunc   ;==>WM_MOUSEWHEEL

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $nListViewProfiles = $Global_ListViewProfiles
	Local $nListViewRules = $Global_ListViewRules
	Local $nListViewFolders = $Global_ListViewFolders

	If IsHWnd($nListViewProfiles) = 0 Then
		$nListViewProfiles = GUICtrlGetHandle($nListViewProfiles)
	EndIf
	If IsHWnd($nListViewRules) = 0 Then
		$nListViewRules = GUICtrlGetHandle($nListViewRules)
	EndIf
	If IsHWnd($nListViewFolders) = 0 Then
		$nListViewFolders = GUICtrlGetHandle($nListViewFolders)
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
					$Global_ListViewIndex = $nIndex
					If $nIndex <> -1 And $nSubItem <> -1 Then
						GUICtrlSendToDummy($Global_ListViewProfiles_Enter)
					Else
						GUICtrlSendToDummy($Global_ListViewProfiles_New)
					EndIf
				Case $NM_RCLICK
					$Global_ListViewIndex = $nIndex
					_GUICtrlListView_ContextMenu_Customize($nListViewProfiles, $nIndex, $nSubItem) ; Show Customize GUI RightClick Menu.
			EndSwitch

		Case $nListViewRules
			Switch $nCode
				Case $NM_CLICK
					$Global_ListViewIndex = $nIndex
				Case $NM_DBLCLK
					$Global_ListViewIndex = $nIndex
					If $nIndex <> -1 And $nSubItem <> -1 Then
						GUICtrlSendToDummy($Global_ListViewRules_Enter)
					Else
						GUICtrlSendToDummy($Global_ListViewRules_New)
					EndIf
				Case $NM_RCLICK
					$Global_ListViewIndex = $nIndex
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

		Case $nListViewFolders
			Switch $nCode
				Case $NM_CLICK, $NM_RCLICK
					$Global_ListViewIndex = $nIndex
				Case $NM_DBLCLK
					$Global_ListViewIndex = $nIndex
					If $nIndex <> -1 And $nSubItem <> -1 Then
						GUICtrlSendToDummy($Global_ListViewFolders_Enter)
					Else
						GUICtrlSendToDummy($Global_ListViewFolders_New)
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
#EndRegion >>>>> MAIN: WM_MESSAGES Functions <<<<<

#Region >>>>> INTERNAL: 7Zip Functions <<<<<
Func __7ZipCommands($cType, $cDestinationFilePath = -1, $cFlag = -1, $cPassword = "")
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
	If $cPassword <> "" Then
		$cDecrypt = $cPassword
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
			$cDestinationFilePath = StringTrimRight($cDestinationFilePath, 3) ; Remove .7z [Test.7z >> Test & Test.zip >> Test.]
			If StringRight($cDestinationFilePath, 1) = "." Then
				$cDestinationFilePath = StringTrimRight($cDestinationFilePath, 1) ; Remove The "."
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
		Description: Get The Current 7-Zip Format.
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

Func __7ZipRun($rSourceFilePath = "", $rDestinationFilePath = "", $rType = 0, $rCustom = 0, $rNotWait = 0, $rPassword = "")
	#cs
		Description: Compress/Extract/Test Using 7-Zip.
		Returns: Output FilePath [C:\Test.7z] Or $Array[2] - Array Contains Two Items.
		[0] - Process ID
		[1] - Output FilePath [C:\Test.7z]
	#ce
	Local $rCommand, $rNewCommands, $rReturnedArray[2]
	Local $7Zip = @ScriptDir & "\Lib\7z\7z.exe"
	If FileExists($7Zip) = 0 Or $rSourceFilePath = "" Or $rDestinationFilePath = "" Then
		Return SetError(1, 0, 0)
	EndIf

	Switch $rType
		Case 0 ; Compress Mode.
			$rCommand = "a -tzip -mm=Deflate -mx5 -mem=AES256 -sccUTF-8 -ssw"
			If $rCustom = 1 Then
				$rNewCommands = __7ZipCommands($rType, $rDestinationFilePath, -1)
				$rCommand = $rNewCommands[0]
				$rDestinationFilePath = $rNewCommands[1]
			EndIf
			$rCommand = '"' & $7Zip & '" ' & $rCommand & ' "' & $rDestinationFilePath & '" "' & $rSourceFilePath & '"'

		Case 1 ; Extract Mode.
			$rCommand = '"' & $7Zip & '" ' & __7ZipCommands($rType, -1, -1, $rPassword) & ' "' & $rSourceFilePath & '" -y -o"' & $rDestinationFilePath & '"'

		Case 2 ; Test Mode.
			$rCommand = '"' & $7Zip & '" t -p' & $rPassword & ' "' & $rSourceFilePath & '"'

		Case Else ; Wrong Parameter.
			Return SetError(1, 0, 0)
	EndSwitch

	If $rNotWait = 1 Then
		$rReturnedArray[0] = Run($rCommand, "", @SW_HIDE)
	Else
		$rReturnedArray[0] = RunWait($rCommand, "", @SW_HIDE)
	EndIf

	If $rType = 0 And $rCustom = 1 Then
		If $rNewCommands[2] = "SFX" Then
			$rDestinationFilePath = $rDestinationFilePath & ".exe"
		EndIf
	EndIf
	$rReturnedArray[1] = $rDestinationFilePath

	If @error Then
		Return SetError(1, 1, $rReturnedArray[1])
	EndIf
	If $rNotWait = 0 And FileExists($rDestinationFilePath) = 0 And $rType <> 2 Then
		Return SetError(1, 0, $rReturnedArray[1])
	EndIf
	Return $rReturnedArray
EndFunc   ;==>__7ZipRun
#EndRegion >>>>> INTERNAL: 7Zip Functions <<<<<

#Region >>>>> INTERNAL: Image Functions <<<<<
Func __ImageGet($hHandle = -1, $sProfile = -1)
	Local $aReturn[6], $sFileName, $sFileOpenDialog, $sImagePath, $iSize

	$sImagePath = __IsProfile($sProfile, 0) ; Get Array Of Selected Profile.
	$sFileOpenDialog = FileOpenDialog(__Lang_Get('IMAGE_GET_TIP_0', 'Select target image for this Profile'), $sImagePath[8], __Lang_Get('IMAGE_GET', 'Images') & " (*.gif;*.jpg;*.png)", 1, "", __OnTop($hHandle))
	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	If __IsWindowsVersion() = 0 And __GetFileExtension($sFileOpenDialog) = "gif" Then
		$sFileOpenDialog = __ImageConvert($sFileOpenDialog, $sImagePath[8], "PNG")
	EndIf

	If StringInStr($sFileOpenDialog, $sImagePath[8]) = 0 Then
		FileCopy($sFileOpenDialog, $sImagePath[8])
		$sFileOpenDialog = $sImagePath[8] & __GetFileName($sFileOpenDialog) ; Get The File Name Of The Selected [FileName.txt].
	EndIf

	$iSize = __ImageSize($sFileOpenDialog)
	$sFileName = StringTrimLeft($sFileOpenDialog, StringLen($sImagePath[8]))
	$aReturn[0] = $sFileOpenDialog ; FilePath + FileName.
	$aReturn[1] = $sFileName ; FileName.
	$aReturn[2] = $iSize[0] ; FileSize Width.
	$aReturn[3] = $iSize[1] ; FileSize Height.
	$aReturn[4] = 100 ; Transparency.
	$aReturn[5] = $sImagePath[8] ; FilePath.

	__ImageWrite($sProfile, 7, $aReturn[1], $aReturn[2], $aReturn[3], $aReturn[4]) ; Write Image File Name & Size & Transparency To The Selected Profile.
	Return $aReturn
EndFunc   ;==>__ImageGet

Func __ImageConvert($sImagePath, $sSaveDirectory, $sFileExtension = "PNG")
	#cs
		Description: Convert The Image File To Another Valid Format.
		Returns: New Image [New Image.png]
	#ce
	Local $hImagePath, $sCLSID, $sFilePath

	$sCLSID = _GDIPlus_EncodersGetCLSID($sFileExtension)

	$sFileExtension = StringLower($sFileExtension)
	$sSaveDirectory = _WinAPI_PathAddBackslash($sSaveDirectory)

	$sFilePath = _WinAPI_PathYetAnotherMakeUniqueName($sSaveDirectory & __GetFileNameOnly($sImagePath) & "." & $sFileExtension)
	$hImagePath = _GDIPlus_ImageLoadFromFile($sImagePath)

	_GDIPlus_ImageSaveToFileEx($hImagePath, $sFilePath, $sCLSID)
	Return $sFilePath
EndFunc   ;==>__ImageConvert

Func __ImageWrite($sProfile = -1, $iFlag = 1, $sImagePath = -1, $iSize_X = 64, $iSize_Y = 64, $iTransparency = 100)
	$sProfile = __IsProfile($sProfile, 1) ; Get Profile Path Of Selected Profile.

	If $sImagePath == -1 Or $sImagePath == 0 Or $sImagePath == "" Then
		$sImagePath = __GetDefault(16) ; Default Image File.
	EndIf

	If BitAND($iFlag, 1) Then ; 1 = Add Image File.
		__IniWriteEx($sProfile, "Target", "Image", $sImagePath)
	EndIf
	If BitAND($iFlag, 2) Then ; 2 = Add Image Size.
		__IniWriteEx($sProfile, "Target", "SizeX", $iSize_X)
		__IniWriteEx($sProfile, "Target", "SizeY", $iSize_Y)
	EndIf
	If BitAND($iFlag, 4) Then ; 4 = Add Transparency.
		__IniWriteEx($sProfile, "Target", "Transparency", StringReplace($iTransparency, "%", ""))
	EndIf

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__ImageWrite
#EndRegion >>>>> INTERNAL: Image Functions <<<<<

#Region >>>>> INTERNAL: Language Functions <<<<<
Func __GetCurrentLanguage()
	#cs
		Description: Get The Current Language From The Settings INI File.
		Return: Language [English]
	#ce
	Local $aLanguageDefault, $sINI, $sINIRead

	If $Global_Language <> "" Then
		Return $Global_Language ; To Speedup The Script.
	EndIf
	$sINI = __IsSettingsFile() ; Get Default Settings INI File.
	$aLanguageDefault = __GetDefault(3072) ; Get Default Language Directory & Default Language.
	$sINIRead = IniRead($sINI, "General", "Language", __GetOSLanguage())
	If FileExists($aLanguageDefault[1][0] & $sINIRead & ".lng") = 0 Then
		$sINIRead = __SetCurrentLanguage() ; Set Language With Default Language.
	EndIf
	$Global_Language = $sINIRead
	Return $sINIRead
EndFunc   ;==>__GetCurrentLanguage

Func __Lang_Get($sData, $sDefault, $iNotEnvironmentVariables = 0)
	#cs
		Description: Get Translated String Of The Current Language.
		Returns: Translated String.
	#ce
	Local $sCurrentLanguage = __GetCurrentLanguage()

	$sData = IniRead(__GetDefault(1024) & $sCurrentLanguage & ".lng", $sCurrentLanguage, $sData, $sDefault) ; __GetDefault(1024) = Get Default Language Directory.
	If $iNotEnvironmentVariables = 0 Then
		$sData = _WinAPI_ExpandEnvironmentStrings($sData)
		If @error Then
			$sData = _WinAPI_ExpandEnvironmentStrings($sDefault)
		EndIf
	EndIf
	If StringInStr($sData, "@") Then
		$sData = StringReplace($sData, "@CRLF", " @CRLF ")
		$sData = StringReplace($sData, "@CR", " @CR ")
		$sData = StringReplace($sData, "@LF", " @LF ")
		$sData = StringReplace($sData, "@TAB", " @TAB ")
	EndIf
	$sData = StringStripWS($sData, 4)
	If StringInStr($sData, "@") Then
		$sData = StringReplace($sData, "@CRLF ", @CRLF)
		$sData = StringReplace($sData, "@CR ", @CR)
		$sData = StringReplace($sData, "@LF ", @LF)
		$sData = StringReplace($sData, "@TAB ", @TAB)
	EndIf
	Return $sData
EndFunc   ;==>__Lang_Get

Func __LangList_Combo($lComboBox)
	#cs
		Description: Get Languages And Create String For Use In A Combo Box.
		Returns: String Of Languages.
	#ce
	Local $lCurrentLanguage = __GetCurrentLanguage()
	Local $lIndex
	Local $lImageList = $Global_ImageList
	Local $lLanguageDefault = __GetDefault(1024) ; Get Default Language Directory.
	Local $lLanguageList = __LangList_Get()
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
EndFunc   ;==>__LangList_Combo

Func __LangList_Get()
	#cs
		Description: Proivide Details Of The Languages In The Languages Directory.
		Returns: $Array[?] - Array Contains Unlimited Number Of Items.
		[0] - Number Of Rows [3]
		[1] - Language 1 [First Language]
		[2] - Language 2 [Second Language]
		[3] - Language 3 [Third Language]
	#ce
	Local $aLanguageDefault, $aLanguageList[2] = [0]

	$aLanguageDefault = __GetDefault(1024) ; Get Default Language Directory.
	$aLanguageList = __FileListToArrayEx($aLanguageDefault, "*.lng")
	For $A = 1 To $aLanguageList[0]
		$aLanguageList[$A] = __GetFileNameOnly($aLanguageList[$A])
	Next
	Return $aLanguageList
EndFunc   ;==>__LangList_Get

Func __LangList_GUI()
	#cs
		Description: Select Language.
		Returns: Write Selected Language To The Settings INI File.
	#ce
	Local $hCombo, $hGUI, $hImageList, $iOK, $sLanguage

	$hGUI = GUICreate('Language Choice', 230, 70, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop())
	$hCombo = _GUICtrlComboBoxEx_Create($hGUI, "", 5, 10, 220, 200, 0x0003)
	$hImageList = _GUIImageList_Create(16, 16, 5, 3) ; Create An ImageList.
	_GUICtrlComboBoxEx_SetImageList($hCombo, $hImageList)
	$Global_ImageList = $hImageList

	__LangList_Combo($hCombo)
	$iOK = GUICtrlCreateButton("&OK", 115 - 38, 40, 76, 24)
	GUICtrlSetState($iOK, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $iOK
				ExitLoop

		EndSwitch
	WEnd
	_GUICtrlComboBoxEx_GetItemText($hCombo, _GUICtrlComboBoxEx_GetCurSel($hCombo), $sLanguage)
	__SetCurrentLanguage($sLanguage) ; Set The Selected Language To The Settings INI File.

	GUIDelete($hGUI)
	_GUIImageList_Destroy($hImageList)
	Return $sLanguage
EndFunc   ;==>__LangList_GUI

Func __SetCurrentLanguage($sLanguage = -1)
	#cs
		Description: Set The Current Language To The Settings INI File.
		Return: Language [English]
	#ce
	Local $sINI

	$sINI = __IsSettingsFile() ; Get Default Settings INI File.
	If $sLanguage == "" Or $sLanguage = -1 Then
		$sLanguage = __GetDefault(2048) ; Get Default Language.
	EndIf
	__IniWriteEx($sINI, "General", "Language", $sLanguage)
	$Global_Language = $sLanguage
	Return $sLanguage
EndFunc   ;==>__SetCurrentLanguage
#EndRegion >>>>> INTERNAL: Language Functions <<<<<

#Region >>>>> INTERNAL: List Functions <<<<<
Func __List_GetProperties($lProfile, $lAction, $lAssociation)
	#cs
		Description: Get String Of List Properties For This Association.
		Returns: String Of List Properties [0;1;2;3;11;13]
	#ce
	Local $lStringSplit, $lNumberFields = 5, $lDefaultProperties = "0;1;2;3;11;13"

	$lAssociation = __GetAssociationString($lAction, $lAssociation) ; Get Association String.
	$lStringSplit = StringSplit(IniRead($lProfile, "Associations", $lAssociation, ""), "|")
	If @error Then
		Return $lDefaultProperties
	EndIf
	ReDim $lStringSplit[$lNumberFields + 1]
	If $lStringSplit[5] = "" Then
		Return $lDefaultProperties
	EndIf

	Return $lStringSplit[5]
EndFunc   ;==>__List_GetProperties

Func __List_GetProperty($lNumber, $lTranslated = 1)
	#cs
		Description: Get Property Name Associated To The Property Number.
		Returns: Property [Full Name]
	#ce
	Local $lProperty, $lError = 0

	Switch $lNumber
		Case 0
			$lProperty = '#'
		Case 1
			$lProperty = 'Full Name'
		Case 2
			$lProperty = 'Directory'
		Case 3
			$lProperty = 'Size'
		Case 4
			$lProperty = 'Name'
		Case 5
			$lProperty = 'Extension'
		Case 6
			$lProperty = 'Drive'
		Case 7
			$lProperty = 'MD5 Hash'
		Case 8
			$lProperty = 'SHA-1 Hash'
		Case 9
			$lProperty = "Absolute Link"
		Case 10
			$lProperty = "Relative Link"
		Case 11
			$lProperty = 'Type'
		Case 12
			$lProperty = 'Date Created'
		Case 13
			$lProperty = 'Date Modified'
		Case 14
			$lProperty = 'Date Opened'
		Case 15
			$lProperty = 'Date Taken'
		Case 16
			$lProperty = 'Attributes'
		Case 17
			$lProperty = 'Owner'
		Case 18
			$lProperty = 'Dimensions'
		Case 19
			$lProperty = 'Camera Model'
		Case 20
			$lProperty = 'Authors'
		Case 21
			$lProperty = 'Artists'
		Case 22
			$lProperty = 'Title'
		Case 23
			$lProperty = 'Album'
		Case 24
			$lProperty = 'Genre'
		Case 25
			$lProperty = 'Year'
		Case 26
			$lProperty = 'Track'
		Case 27
			$lProperty = 'Subject'
		Case 28
			$lProperty = 'Categories'
		Case 29
			$lProperty = 'Comments'
		Case 30
			$lProperty = 'Copyright'
		Case 31
			$lProperty = 'Duration'
		Case 32
			$lProperty = 'Bit Rate'
		Case Else
			$lProperty = ''
			$lError = 1
	EndSwitch

	If $lProperty <> "" And $lNumber > 0 And $lTranslated Then
		$lProperty = __Lang_Get('LIST_LABEL_' & $lNumber, $lProperty)
	EndIf

	Return SetError($lError, 0, $lProperty)
EndFunc   ;==>__List_GetProperty

Func __List_Properties($lFilePath, $lSize, $lListPath, $lStringProperties, $lTranslated = 1)
	#cs
		Description: Get Properties Of The File/Folder.
		Returns: $Array[?] - Array Contains Some Of The Supported Properties.
		[0] - Row Names [Full Name|Directory|Size]
		[1] - Full Name [Text.txt]
		[2] - Directory [C:\Folder]
		[3] - Size [20 MB]
	#ce
	Local $lMoreProperties[23] = [22, 2, 4, 3, 5, 9, 6, 8, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24] ; Properties From 11 To 32.
	Local $lProperties = StringSplit($lStringProperties, ";")
	Local $lString, $lCount = $lProperties[0]
	$lProperties[0] = ""
	For $A = 1 To $lCount
		$lString = __List_GetProperty($lProperties[$A], $lTranslated)
		If @error = 0 Then ; Supported Number.
			$lProperties[0] &= $lString & ";"
			Switch $lProperties[$A]
				Case 0
					$lProperties[$A] = "#"
				Case 1
					$lProperties[$A] = __GetFileName($lFilePath)
				Case 2
					$lProperties[$A] = __GetParentFolder($lFilePath)
				Case 3
					$lProperties[$A] = __ByteSuffix($lSize)
				Case 4
					$lProperties[$A] = __GetFileNameOnly($lFilePath)
				Case 5
					$lProperties[$A] = __GetFileExtension($lFilePath)
				Case 6
					$lProperties[$A] = __GetDrive($lFilePath)
				Case 7
					$lProperties[$A] = __MD5ForFile($lFilePath)
				Case 8
					$lProperties[$A] = __SHA1ForFile($lFilePath)
				Case 9
					$lProperties[$A] = $lFilePath
				Case 10
					$lProperties[$A] = __GetRelativePath($lFilePath, $lListPath)
					If @error Then
						$lProperties[$A] = ""
					EndIf
				Case Else
					$lString = $lProperties[$A]
					$lProperties[$A] = __GetFileProperties($lFilePath, $lMoreProperties[$lString - 10])
			EndSwitch
		EndIf
	Next
	$lProperties[0] = StringTrimRight($lProperties[0], 1) ; To Remove The Last ";" Character.

	Return $lProperties
EndFunc   ;==>__List_Properties

Func __List_Write($lListPath, $lFilePath, $lSize)
	#cs
		Description: Write Properties Of A File In The Defined List.
		Returns: 1
	#ce
	Local $lStringSplit = StringSplit($lListPath, "|") ; Separate List File Path, List Properties, Profile, Rules And Association Name.
	$lListPath = $lStringSplit[1]
	Local $lListType = __GetFileExtension($lListPath)

	Local $lNewListPath = ""
	If $Global_OpenedLists[0][0] > 0 Then ; Some Lists Are Already Opened In This Drop.
		For $A = 1 To $Global_OpenedLists[0][0]
			If $lListPath = $Global_OpenedLists[$A][0] Then
				$lNewListPath = $Global_OpenedLists[$A][1] ; Load List Name Of This Drop.
				ExitLoop
			EndIf
		Next
	EndIf
	If $lNewListPath = "" Then ; List Is Opening Now.
		$Global_OpenedLists[0][0] += 1
		ReDim $Global_OpenedLists[$Global_OpenedLists[0][0] + 1][2]
		$Global_OpenedLists[$Global_OpenedLists[0][0]][0] = $lListPath ; Original List Name.
		$lNewListPath = $lListPath
		If FileExists($lListPath) Then
			$lNewListPath = __GetParentFolder($lListPath)
			If $lNewListPath <> "" Then
				$lNewListPath &= "\"
			EndIf
			$lNewListPath &= _Duplicate_Rename(__GetFileName($lListPath), __GetParentFolder($lListPath)) ; List Name For This Drop.
		EndIf
		$Global_OpenedLists[$Global_OpenedLists[0][0]][1] = $lNewListPath
	EndIf
	$lListPath = $lNewListPath

	Switch $lListType
		Case "html", "htm"
			__List_WriteHTML($lListPath, __List_Properties($lFilePath, $lSize, $lListPath, $lStringSplit[2]), $lStringSplit[3], $lStringSplit[4], $lStringSplit[5])
		Case "txt"
			__List_WriteTEXT($lListPath, __List_Properties($lFilePath, $lSize, $lListPath, $lStringSplit[2]), '|', '')
		Case "csv"
			__List_WriteTEXT($lListPath, __List_Properties($lFilePath, $lSize, $lListPath, $lStringSplit[2]), ',', '"')
		Case "xml"
			__List_WriteXML($lListPath, __List_Properties($lFilePath, $lSize, $lListPath, $lStringSplit[2], 0))
		Case Else
			Return SetError(1, 0, 0)
	EndSwitch

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__List_Write

Func __List_WriteHTML($lListPath, $lArray, $lProfile, $lRules, $lListName) ; Inspired By: http://www.autoitscript.com/forum/topic/124516-guictrllistview-savehtml-exports-the-details-of-a-listview-to-a-html-file/
	#cs
		Description: Write An Array To HTML File.
		Returns: 1
	#ce
	Local $lFileOpen, $lFileRead, $lString, $lNumber[1] = [0], $lCurrentEnd = '<!-- Current List End -->'
	Local $lStringSplit = StringSplit($lArray[0], ";")

	If FileExists($lListPath) Then
		$lFileRead = FileRead($lListPath)
	Else
		Local $lTheme = IniRead(__IsSettingsFile(), "General", "ListTheme", "Default") ; __IsSettingsFile() = Get Default Settings INI File.
		If FileExists(@ScriptDir & "\Lib\list\themes\" & $lTheme & ".css") = 0 Then
			$lTheme = "Default"
		EndIf
		Local $lStyle, $lLoadCSS, $lArrayCSS[2] = ["base.css", "themes\" & $lTheme & ".css"]
		For $A = 0 To 1
			$lStyle = FileRead(@ScriptDir & "\Lib\list\" & $lArrayCSS[$A])
			If @error Then
				Return SetError(1, 0, 0)
			EndIf
			$lLoadCSS &= @CRLF & $lStyle & @CRLF
		Next

		Local $lHeader = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' & @CRLF & _
				'<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en"><head>' & @CRLF & _
				'<meta http-equiv="content-type" content="text/html; charset=UTF-8" />' & @CRLF & _
				'<title>' & $lListName & '</title>' & @CRLF & @CRLF & _
				'<style type="text/css"> ' & $lLoadCSS & '</style>' & @CRLF & _
				'</head>' & @CRLF & @CRLF & _
				'<body>' & @CRLF & _
				'<div id="container">' & @CRLF & @CRLF & _
				'<div id="main-wrap">' & @CRLF & @CRLF & _
				'<div id="header-wrap">' & @CRLF & @CRLF & _
				'<div id="header">' & @CRLF & _
				@TAB & '<h1>' & $lListName & '</h1>' & @CRLF & _
				@TAB & '<ul id="infoline">' & @CRLF & _
				@TAB & @TAB & '<li><strong>' & __Lang_Get('LIST_HTML_CREATED', 'Created') & '</strong>: ' & @MDAY & '/' & @MON & '/' & @YEAR & ' ' & @HOUR & ':' & @MIN & '</li>' & @CRLF & _
				@TAB & @TAB & '<li><strong>' & __Lang_Get('PROFILE', 'Profile') & '</strong>: ' & $lProfile & '</li>' & @CRLF & _
				@TAB & @TAB & '<li><strong>' & __Lang_Get('RULES', 'Rules') & '</strong>: ' & $lRules & '</li>' & @CRLF & _
				@TAB & @TAB & '<li class="last"><strong>' & __Lang_Get('LIST_HTML_TOTAL', 'Total') & '</strong>: <span id="count">0</span></li>' & @CRLF & _
				@TAB & '</ul>' & @CRLF & _
				'</div><!-- #header -->' & @CRLF & _
				'</div><!-- #header-wrap -->' & @CRLF & @CRLF

		Local $lColumns = '<div id="table">' & @CRLF & _
				'<table id="mainTable" cellpadding="0" cellspacing="0">' & @CRLF & _
				'<thead>' & @CRLF & '<tr>' & @CRLF
		For $A = 1 To $lStringSplit[0]
			Switch $lStringSplit[$A]
				Case "#"
					$lColumns &= @TAB & '<th class="right">&nbsp;</th>' & @CRLF
				Case Else
					$lColumns &= @TAB & '<th>' & $lStringSplit[$A] & '</th>' & @CRLF
			EndSwitch
		Next
		$lColumns &= '</tr>' & @CRLF & '</thead>' & @CRLF

		Local $lJavaScript, $lLoadJS, $lArrayJS[2][2] = [["ListSortable", "sortable.js"], ["ListFilter", "filter.js"]]
		For $A = 0 To 1
			If __Is($lArrayJS[$A][0]) Then
				$lJavaScript = FileRead(@ScriptDir & "\Lib\list\" & $lArrayJS[$A][1])
				If @error = 0 Then
					$lLoadJS &= '<script type="text/javascript" charset="utf-8">' & @CRLF & '//<![CDATA[' & @CRLF & $lJavaScript & @CRLF & '//]]>' & @CRLF & '</script>' & @CRLF
				EndIf
			EndIf
		Next

		Local $lFooter = '<tbody>' & @CRLF & $lCurrentEnd & @CRLF & '</tbody>' & @CRLF & '</table>' & @CRLF & '</div><!-- #table -->' & @CRLF & @CRLF & _
				'</div><!-- #main-wrap -->' & @CRLF & @CRLF & _
				'<div id="footer-wrap">' & @CRLF & _
				@TAB & '<p id="footer">' & @CRLF & _
				@TAB & @TAB & 'Generated with <a id="dropit" href="%URL%" title="Visit DropIt website" target="_blank">DropIt</a> <span>- Sort your files with a drop!</span>' & @CRLF & _
				@TAB & @TAB & '<a id="top" href="#" title="Go to top">top</a>' & @CRLF & _
				@TAB & '</p>' & @CRLF & _
				'</div><!-- #footer-wrap -->' & @CRLF & @CRLF & _
				'</div><!-- #container -->' & @CRLF & @CRLF & _
				'<script type="text/javascript" charset="utf-8">' & @CRLF & _
				'//<![CDATA[' & @CRLF & _
				@TAB & 'var clearFilterText = "' & __Lang_Get('LIST_HTML_CLEARFILTER', 'clear filter') & '";' & @CRLF & _
				@TAB & 'var noResultsText = "' & __Lang_Get('LIST_HTML_NORESULTS', 'No results for this term') & ':";' & @CRLF & _
				@TAB & 'var searchFieldText = "' & __Lang_Get('LIST_HTML_FILTER', 'filter') & '...";' & @CRLF & _
				'//]]>' & @CRLF & _
				'</script>' & @CRLF & _
				$lLoadJS & @CRLF & '</body>' & @CRLF & '</html>'

		$lFileRead = $lHeader & $lColumns & $lFooter
	EndIf

	$lNumber = StringRegExp($lFileRead, '<span id="count">(.*?)</span>', 3)
	$lFileRead = StringReplace($lFileRead, '<span id="count">' & $lNumber[0] & '</span>', '<span id="count">' & $lNumber[0] + 1 & '</span>', 0, 1)

	For $A = 1 To $lStringSplit[0]
		If $lArray[$A] = "" Then
			$lArray[$A] = "-"
		EndIf
		Switch $lStringSplit[$A]
			Case __Lang_Get('LIST_LABEL_9', 'Absolute Link')
				$lString &= @TAB & '<td class="center"><a href="file:///' & $lArray[$A] & '" target="_blank">' & __Lang_Get('LINK', 'Link') & '</a></td>' & @CRLF
			Case __Lang_Get('LIST_LABEL_10', 'Relative Link')
				$lString &= @TAB & '<td class="center"><a href="' & StringReplace($lArray[$A], "\", "/") & '" target="_blank">' & __Lang_Get('LINK', 'Link') & '</a></td>' & @CRLF
			Case __Lang_Get('LIST_LABEL_3', 'Size')
				$lString &= @TAB & '<td class="right">' & $lArray[$A] & '</td>' & @CRLF
			Case "#"
				$lString &= @TAB & '<td class="right">' & $lNumber[0] + 1 & '</td>' & @CRLF
			Case Else
				$lString &= @TAB & '<td>' & $lArray[$A] & '</td>' & @CRLF
		EndSwitch
	Next
	$lString = '<tr>' & @CRLF & $lString & '</tr>' & @CRLF & $lCurrentEnd
	$lFileRead = StringReplace($lFileRead, $lCurrentEnd, $lString)

	$lFileOpen = FileOpen($lListPath, 2 + 8 + 128)
	FileWrite($lFileOpen, $lFileRead)
	FileClose($lFileOpen)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__List_WriteHTML

Func __List_WriteTEXT($lListPath, $lArray, $lDelimiter = ',', $lQuote = '"') ; Inspired By: http://www.autoitscript.com/forum/topic/129250-guictrllistview-savecsv-exports-the-details-of-a-listview-to-a-csv-file/
	#cs
		Description: Write An Array To TXT Or CSV File.
		Returns: 1
	#ce
	Local $lFileOpen, $lString
	Local $lStringSplit = StringSplit($lArray[0], ";")

	If FileExists($lListPath) = 0 And __Is("ListHeader") Then
		For $A = 1 To $lStringSplit[0]
			If $lStringSplit[$A] == "#" Then
				ContinueLoop
			EndIf
			If $lQuote <> '' Then
				$lStringSplit[$A] = StringReplace($lStringSplit[$A], $lQuote, $lQuote & $lQuote, 0, 1)
			EndIf
			$lString &= $lQuote & $lStringSplit[$A] & $lQuote
			If $A < $lStringSplit[0] Then
				$lString &= $lDelimiter
			EndIf
		Next
		$lString &= @CRLF & @CRLF
	EndIf

	For $A = 1 To $lStringSplit[0]
		If $lArray[$A] == "#" Then
			ContinueLoop
		EndIf
		If $lQuote <> '' Then
			$lArray[$A] = StringReplace($lArray[$A], $lQuote, $lQuote & $lQuote, 0, 1)
		EndIf
		$lString &= $lQuote & $lArray[$A] & $lQuote
		If $A < $lStringSplit[0] Then
			$lString &= $lDelimiter
		EndIf
	Next

	$lFileOpen = FileOpen($lListPath, 1 + 8 + 128)
	FileWrite($lFileOpen, $lString & @CRLF)
	FileClose($lFileOpen)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__List_WriteTEXT

Func __List_WriteXML($lListPath, $lArray) ; Inspired By: http://www.autoitscript.com/forum/topic/129432-guictrllistview-savexml-exports-the-details-of-a-listview-to-a-xml-file/
	#cs
		Description: Write An Array To XML File.
		Returns: 1
	#ce
	Local $lFileOpen, $lFileRead, $lString, $lNumber[2] = [1], $lCurrentEnd = '</listview>'
	Local $lStringSplit = StringSplit($lArray[0], ";")

	If FileExists($lListPath) Then
		$lFileRead = FileRead($lListPath)
	Else
		$lFileRead = '<?xml version="1.0" encoding="UTF-8" ?>' & @CRLF & '<listview rows="0" cols="' & $lStringSplit[0] & '">' & @CRLF & $lCurrentEnd
	EndIf

	$lNumber = StringRegExp($lFileRead, 'rows="(.*?)"', 3)
	$lFileRead = StringReplace($lFileRead, 'rows="' & $lNumber[0] & '"', 'rows="' & $lNumber[0] + 1 & '"', 0, 1)
	$lString = @TAB & '<item>' & @CRLF
	For $A = 1 To $lStringSplit[0]
		If $lArray[$A] = "" Then
			$lArray[$A] = "-"
		EndIf
		If $lStringSplit[$A] == "#" Then
			$lStringSplit[$A] = "n"
			$lArray[$A] = $lNumber[0] + 1
		EndIf
		$lStringSplit[$A] = StringReplace(StringLower($lStringSplit[$A]), " ", "_")
		$lString &= @TAB & @TAB & '<' & $lStringSplit[$A] & '>' & $lArray[$A] & '</' & $lStringSplit[$A] & '>' & @CRLF
	Next
	$lString &= @TAB & '</item>' & @CRLF & $lCurrentEnd
	$lFileRead = StringReplace($lFileRead, $lCurrentEnd, $lString)

	$lFileOpen = FileOpen($lListPath, 2 + 8 + 128)
	FileWrite($lFileOpen, $lFileRead)
	FileClose($lFileOpen)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__List_WriteXML
#EndRegion >>>>> INTERNAL: List Functions <<<<<

#Region >>>>> INTERNAL: Playlist Functions <<<<<
Func __Playlist_Write($pFilePath, $pPlaylistPath)
	#cs
		Description: Write A File In A Defined Playlist.
		Returns: 1
	#ce
	Local $pListType = __GetFileExtension($pPlaylistPath)

	Switch $pListType
		Case "m3u"
			__Playlist_WriteM3U($pFilePath, $pPlaylistPath)
		Case "m3u8"
			__Playlist_WriteM3U($pFilePath, $pPlaylistPath, 1)
		Case "pls"
			__Playlist_WritePLS($pFilePath, $pPlaylistPath)
		Case "wpl"
			__Playlist_WriteWPL($pFilePath, $pPlaylistPath)
		Case Else
			Return SetError(1, 0, 0)
	EndSwitch

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__Playlist_Write

Func __Playlist_WriteM3U($pFilePath, $pPlaylistPath, $pUnicode = 0)
	#cs
		Description: Write A File In A M3U Or M3U8 Playlist.
		Returns: 1
	#ce
	Local $pFileOpen

	If $pUnicode <> 0 Then
		$pUnicode = 128 ; UTF-8 For M3U8 Playlists.
	EndIf
	$pFileOpen = FileOpen($pPlaylistPath, 1 + 8 + $pUnicode)
	FileWrite($pFileOpen, $pFilePath & @CRLF)
	FileClose($pFileOpen)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__Playlist_WriteM3U

Func __Playlist_WritePLS($pFilePath, $pPlaylistPath)
	#cs
		Description: Write A File In A PLS Playlist.
		Returns: 1
	#ce
	Local $pFileOpen, $pFileRead, $pNumber, $pNewFile

	If FileExists($pPlaylistPath) Then
		$pFileRead = FileRead($pPlaylistPath)
	Else
		$pFileRead = '[playlist]' & @CRLF & 'NumberOfEntries=0' & @CRLF & 'Version=2' & @CRLF
	EndIf
	$pNumber = StringRegExp($pFileRead, 'NumberOfEntries=(.*?)' & @CRLF, 3)
	$pNewFile = 'File' & $pNumber[0] + 1 & '=' & $pFilePath & @CRLF & 'Length' & $pNumber[0] + 1 & '=-1' & @CRLF
	$pFileRead = StringReplace($pFileRead, 'NumberOfEntries=' & $pNumber[0], $pNewFile & 'NumberOfEntries=' & $pNumber[0] + 1, 0, 1)

	$pFileOpen = FileOpen($pPlaylistPath, 2 + 8)
	FileWrite($pFileOpen, $pFileRead)
	FileClose($pFileOpen)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__Playlist_WritePLS

Func __Playlist_WriteWPL($pFilePath, $pPlaylistPath)
	#cs
		Description: Write A File In A WPL Playlist.
		Returns: 1
	#ce
	Local $pFileOpen, $pFileRead, $pNumber, $pNewFile

	If FileExists($pPlaylistPath) Then
		$pFileRead = FileRead($pPlaylistPath)
	Else
		$pFileRead = '<?wpl version="1.0"?>' & @CRLF & _
				'<smil>' & @CRLF & _
				@TAB & '<head>' & @CRLF & _
				@TAB & @TAB & '<meta name="Generator" content="DropIt"/>' & @CRLF & _
				@TAB & @TAB & '<meta name="ItemCount" content="0"/>' & @CRLF & _
				@TAB & @TAB & '<author />' & @CRLF & _
				@TAB & @TAB & '<title />' & @CRLF & _
				@TAB & '</head>' & @CRLF & _
				@TAB & '<body>' & @CRLF & _
				@TAB & @TAB & '<seq>' & @CRLF & _
				@TAB & @TAB & '</seq>' & @CRLF & _
				@TAB & '</body>' & @CRLF & _
				'</smil>'
	EndIf
	$pNumber = StringRegExp($pFileRead, 'name="ItemCount" content="(.*?)"', 3)
	$pFileRead = StringReplace($pFileRead, 'name="ItemCount" content="' & $pNumber[0] & '"', 'name="ItemCount" content="' & $pNumber[0] + 1 & '"', 0, 1)
	$pNewFile = @TAB & @TAB & @TAB & '<media src="' & $pFilePath & '"/>' & @CRLF
	$pFileRead = StringReplace($pFileRead, @TAB & @TAB & '</seq>', $pNewFile & @TAB & @TAB & '</seq>', 0, 1)

	$pFileOpen = FileOpen($pPlaylistPath, 2 + 8)
	FileWrite($pFileOpen, $pFileRead)
	FileClose($pFileOpen)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__Playlist_WriteWPL
#EndRegion >>>>> INTERNAL: Playlist Functions <<<<<

#Region >>>>> INTERNAL: Profile Functions <<<<<
Func __GetCurrentProfile()
	#cs
		Description: Get The Current Profile Name From The Settings INI File.
		Return: Profile Name [Profile Name]
	#ce
	Local $gINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $gINIRead = IniRead($gINI, "General", "Profile", "Default")
	If $Global_MultipleInstance Then
		$gINIRead = IniRead($gINI, $Global_UniqueID, "Profile", $gINIRead)
	EndIf
	Return $gINIRead
EndFunc   ;==>__GetCurrentProfile

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
		__IniWriteEx($gReturn[0], "Target", "", "Image=" & $gProfileDefault[3][0] & @LF & "SizeX=64" & @LF & "SizeY=64" & @LF & "Transparency=100")
		__IniWriteEx($gReturn[0], "General", "", "")
		__IniWriteEx($gReturn[0], "Associations", "", "")
	EndIf

	$gReturn[4] = IniRead($gReturn[0], "Target", "Image", "UUIDID.9CC09662-A476-4A7A-C40179A9D7DAD484.UUIDID") ; Image File.
	If FileExists($gProfileDefault[2][0] & $gReturn[4]) = 0 Then
		$gReturn[4] = $gProfileDefault[3][0]
		If FileExists($gProfileDefault[2][0] & $gReturn[4]) = 0 Then
			_ResourceSaveToFile(__GetDefault(128), "IMAGE")
		EndIf
		$gSize = __ImageSize($gProfileDefault[2][0] & $gReturn[4])
		__IniWriteEx($gReturn[0], "Target", "Image", $gReturn[4])
		__IniWriteEx($gReturn[0], "Target", "SizeX", $gSize[0])
		__IniWriteEx($gReturn[0], "Target", "SizeY", $gSize[1])
		__IniWriteEx($gReturn[0], "Target", "Transparency", 100)
	EndIf

	$gReturn[3] = $gProfileDefault[2][0] & $gReturn[4] ; Image File FullPath.
	$gReturn[5] = IniRead($gReturn[0], "Target", "SizeX", "64") ; Image SizeX
	$gReturn[6] = IniRead($gReturn[0], "Target", "SizeY", "64") ; Image SizeY
	$gReturn[7] = IniRead($gReturn[0], "Target", "Transparency", "100") ; Image Transparency
	$gReturn[8] = $gProfileDefault[2][0]

	If $gArray = 1 Then
		Return $gReturn[0] ; Profile Directory And Profile Name.
	EndIf
	If $gArray = 2 Then
		Return $gReturn[3] ; Image Directory And Image Name.
	EndIf
	Return $gReturn ; Array.
EndFunc   ;==>__GetProfile

Func __IsCurrentProfile($sProfile)
	#cs
		Description: Check If A Profile Is The Current Profile.
		Returns: True/False
	#ce
	Return StringCompare($sProfile, __GetCurrentProfile()) = 0 ; Get Current Profile From The Settings INI File.
EndFunc   ;==>__IsCurrentProfile

Func __IsProfile($iProfile = -1, $iArray = 0)
	#cs
		Description: Proivide Details Of The Current Profile [-1] Or Specified Profile Name [Valid Profile Name].
		Returns:
		If $iArray = 0 Then Return An Array[9]
		[0] - Profile Full Path [C:\Program Files\DropIt\Profiles\ProfileName.ini]
		[1] - Profile Name [ProfileName]
		[2] - Profile Directory [C:\Program Files\DropIt\Profiles\]
		[3] - Image Full Path [C:\Program Files\DropIt\Images\Default.png]
		[4] - Image Name [Default.png]
		[5] - Image Width Size [64]
		[6] - Image Height Size [64]
		[7] - Image Transparency [100] (Percentage)
		[8] - Image Directory [C:\Program Files\DropIt\Images\]
		If $iArray = 1 Then Return Profile Full Path [C:\Program Files\DropIt\Profiles\ProfileName.ini]
		If $iArray = 2 Then Return Image Full Path [C:\Program Files\DropIt\Images\Default.png]
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

Func __IsProfileUnique($hHandle, $sProfile)
	#cs
		Description: Check If A Profile Name Is Unique.
		Returns: True = ProfileName & False = @error
	#ce
	Local $aProfileList = __ProfileList_Get() ; Get Array Of All Profiles.
	Local $iStringCompare
	$sProfile = StringReplace(StringStripWS($sProfile, 7), " ", "_")

	For $A = 1 To $aProfileList[0] ; Check If the Profile Name Already Exists.
		$aProfileList[$A] = StringReplace(StringStripWS($aProfileList[$A], 7), " ", "_")
		$iStringCompare = StringCompare($aProfileList[$A], $sProfile, 0)
		If $iStringCompare = 0 Then
			MsgBox(0x40, __Lang_Get('PROFILEUNIQUE_MSGBOX_0', 'Name not available'), __Lang_Get('PROFILEUNIQUE_MSGBOX_1', 'This profile name already exists.'), 0, __OnTop($hHandle))
			Return SetError(1, 1, $sProfile)
		EndIf
		If $A = $aProfileList[0] Then
			ExitLoop
		EndIf
	Next
	Return $sProfile
EndFunc   ;==>__IsProfileUnique

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
	$hGUI = GUICreate(__Lang_Get('PROFILELIST_GUI_LABEL_0', 'Select a Profile'), 230, 70, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop())
	$iProfileCombo = GUICtrlCreateCombo("", 5, 10, 220, 25, 0x0003)

	GUICtrlSetData($iProfileCombo, __ProfileList_Combo(), $sProfile)
	$iOK = GUICtrlCreateButton("&" & __Lang_Get('OK', 'OK'), 115 - 76 - 15, 40, 76, 24)
	$iCancel = GUICtrlCreateButton("&" & __Lang_Get('CANCEL', 'Cancel'), 115 + 15, 40, 76, 24)
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

Func __SetCurrentProfile($sProfile)
	#cs
		Description: Set The Current Profile Name To The Settings INI File.
		Return: Settings INI File [C:\Program Files\DropIt\Settings.ini]
	#ce
	Local $sINI, $sINISection

	$sINI = __IsSettingsFile() ; Get Default Settings INI File.

	$sINISection = "General"
	If $sProfile == -1 Or $sProfile == 0 Or $sProfile == "" Then
		$sProfile = "Default"
	EndIf
	If $Global_MultipleInstance Then
		$sINISection = $Global_UniqueID
	EndIf
	__IniWriteEx($sINI, $sINISection, "Profile", $sProfile)

	Return $sINI
EndFunc   ;==>__SetCurrentProfile
#EndRegion >>>>> INTERNAL: Profile Functions <<<<<

#Region >>>>> INTERNAL: Various Functions <<<<<
Func __Backup_Restore($bHandle = -1, $bType = 0, $bZipFile = -1) ; 0 = Backup & 1 = Restore & 2 = Remove.
	#cs
		Description: Backup/Restore The Settings INI File & Profiles.
		Returns: 1
	#ce
	Local $bBackupDirectory = __GetDefault(32) ; Get Default Backup Directory.
	Local $bBackup[3] = [2, __IsSettingsFile(), __GetDefault(2)] ; __GetDefault(2) = Get Default Profiles Directory.

	If FileExists($bBackupDirectory & $bZipFile) Or $bZipFile = -1 Then
		$bZipFile = "DropIt_Backup_" & @YEAR & "-" & @MON & "-" & @MDAY & "[" & @HOUR & "." & @MIN & "." & @SEC & "].zip"
	EndIf

	Switch $bType
		Case 0
			__7ZipRun($bBackup[1] & '" "' & $bBackup[2], $bBackupDirectory & $bZipFile, 0, 0)
			MsgBox(0, __Lang_Get('OPTIONS_BACKUP_MSGBOX_0', 'Backup Created'), __Lang_Get('OPTIONS_BACKUP_MSGBOX_1', 'Successfully created a DropIt Backup.'), 0, __OnTop($bHandle))

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
				If _WinAPI_PathIsDirectory($bBackup[$A]) Then
					DirRemove($bBackup[$A], 1)
				EndIf
			Next

			__7ZipRun($bZipFile, $bSettingsDirectory, 1, 0)
			Sleep(100)
			MsgBox(0, __Lang_Get('OPTIONS_BACKUP_MSGBOX_2', 'Backup Restored'), __Lang_Get('OPTIONS_BACKUP_MSGBOX_3', 'Successfully restored the selected DropIt Backup.'), 0, __OnTop($bHandle))

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
			MsgBox(0, __Lang_Get('OPTIONS_BACKUP_MSGBOX_4', 'Backup Removed'), __Lang_Get('OPTIONS_BACKUP_MSGBOX_5', 'Successfully removed the selected DropIt Backup.'), 0, __OnTop($bHandle))

	EndSwitch
	Return 1
EndFunc   ;==>__Backup_Restore

Func __CheckMultipleInstances()
	#cs
		Description: Check All Multiple Instances In The INI File Are Currently Running.
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
	__IniWriteEx($cINI, "MultipleInstances", "Running", $cRunning)
	Return $cRunning
EndFunc   ;==>__CheckMultipleInstances

Func __CMDLine($aCmdLine)
	#cs
		Description: Check If CommandLine Is Correct And Processes Accordingly.
		Returns: 1
	#ce
	Local $aDroppedFiles[$aCmdLine[0] + 1] = [$aCmdLine[0]], $iIndex = 0, $sProfile

	If $aDroppedFiles[0] = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	If $aCmdLine[1] == "/Uninstall" Then
		__Uninstall()
	EndIf
	If StringLeft($aCmdLine[1], 1) = "-" Then
		$aDroppedFiles[0] -= 1
		$iIndex += 1
		$sProfile = StringTrimLeft($aCmdLine[1], 1)
		If FileExists(__GetDefault(2) & $sProfile & ".ini") = 0 Then ; __GetDefault(2) = Get Default Profile Directory.
			$sProfile = __ProfileList_GUI() ; Show Profile Selection GUI To Select A Profile From The Profile List.
			If @error Then
				Exit ; Close DropIt If Profile Selection Is Aborted.
			EndIf
		EndIf
		If $aDroppedFiles[0] = 0 Then ; Start DropIt With Defined Profile If Is The Only Parameter.
			__SetCurrentProfile($sProfile) ; Write Default Profile Name To The Settings INI File.
			Return SetError(2, 0, 0) ; Start DropIt With Defined Profile.
		EndIf
	Else
		$sProfile = __GetCurrentProfile() ; Get Current Profile From The Settings INI File.
	EndIf

	For $A = 1 To $aDroppedFiles[0]
		$aDroppedFiles[$A] = _WinAPI_GetFullPathName($aCmdLine[$A + $iIndex])
	Next
	Return _DropEvent($aDroppedFiles, $sProfile) ; Send Files To Be Processed.
EndFunc   ;==>__CMDLine

Func __Column_Width($sColumn, $aString = -1)
	#cs
		Description: Retrive Or Save The Column Width.
		Returns: Array[?]
		[0] - Column 1 [90]
		[1] - Column 2 [165]
	#ce
	Local $aReturn, $sReturn

	$sReturn = __IsSettingsFile() ; Get Default Settings INI File.
	Switch $aString
		Case -1
			$aReturn = StringSplit(IniRead($sReturn, "General", $sColumn, ""), ";")

		Case Else
			If IsArray($aString) = 0 Then
				Return SetError(1, 0, 0)
			EndIf
			$aReturn = _ArrayToString($aString, ";")
			__IniWriteEx($sReturn, "General", $sColumn, $aReturn)
	EndSwitch
	Return $aReturn
EndFunc   ;==>__Column_Width

Func __EncryptionFolder($fDecrypt = -1) ; $fDecrypt = 0, Encrypt/Decrypt Profiles.
	#cs
		Description: Create An Encrypted/Decrypted File Of The Profiles Folder. .dat Is The Extension Used For Encryption.
		Returns: Full Path Of Encrypted/Decrypted File [C:\Program Files\DropIt\Profiles.dat]
	#ce
	Local $7Zip = @ScriptDir & "\Lib\7z\7z.exe", $fPassword = $Global_Encryption_Key, $fCommand, $fFolder
	Local $fEncryptionFile = __GetDefault(1) & "Profiles.dat" ; Get Default Settings Directory.
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
			$fFolder = __GetDefault(1) ; Get Default Settings Directory.
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
		Description: Set The Standard & User Assigned Environment Variables.
		Returns: 1
	#ce
	Local $eEnvironmentArray[8][2] = [ _
			[7, 2], _
			["License", "Open Source GPL"], _ ; Returns: DropIt License [Open Source GPL]
			["PortableDrive", StringLeft(@AutoItExe, 2)], _ ; Returns: Drive Letter [C: Without The Trailing "\"]
			["Desktop", @DesktopDir], _ ; Returns: Desktop Directory [C:\Users\Name\Desktop]
			["Documents", @MyDocumentsDir], _ ; Returns: Documents Directory [C:\Users\Name\Documents]
			["Team", "Lupo PenSuite Team"], _ ; Returns: Team Name [Lupo PenSuite Team]
			["URL", "http://dropit.sourceforge.net/index.htm"], _ ; Returns: URL Hyperlink [http://dropit.sourceforge.net/index.htm]
			["VersionNo", $Global_CurrentVersion]] ; Returns: Version Number [1.0]

	For $A = 1 To $eEnvironmentArray[0][0]
		EnvSet($eEnvironmentArray[$A][0], $eEnvironmentArray[$A][1])
	Next

	Local $eINI = __IsSettingsFile() ; Get Default Settings INI File
	Local $eSection = __IniReadSection($eINI, "EnvironmentVariables") ; Set Custom Environment Variables.
	If @error Or $eSection[0][0] = 0 Then
		Return 1
	EndIf
	For $A = 1 To $eSection[0][0]
		EnvSet($eSection[$A][0], $eSection[$A][1])
	Next
	Return 1
EndFunc   ;==>__EnvironmentVariables

Func __GetCurrentPosition()
	#cs
		Description: Get The Current Coordinates/Position From The Settings INI File.
		Returns: Array[2]
		[0] - X Coordinate/Position [100]
		[1] - Y Coordinate/Position [100]
	#ce
	Local $gINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $gReturn[2] = [100, 100]

	Local $gINISection = "General"
	If $Global_MultipleInstance Then
		$gINISection = $Global_UniqueID
	EndIf
	$gReturn[0] = IniRead($gINI, $gINISection, "PosX", "-1")
	$gReturn[1] = IniRead($gINI, $gINISection, "PosY", "-1")
	Return $gReturn
EndFunc   ;==>__GetCurrentPosition

Func __GetCurrentSize($gWindow = "")
	#cs
		Description: Get The Current Size From The Settings INI File.
		Returns: Array[2]
		[0] - Width Size [300]
		[1] - Height Size [200]
	#ce
	Local $gINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $gReturn = StringSplit(IniRead($gINI, "General", $gWindow, "400;200"), ";", 2)

	Return $gReturn
EndFunc   ;==>__GetCurrentSize

Func __GetDefault($gFlag = 1, $gSkipInstallationCheck = 0) ; 0 = Don't Skip It; 1 = Skip It.
	Local $gHex
	Local $gScriptDir = @ScriptDir & "\"
	If __IsInstalled() And $gSkipInstallationCheck = 0 Then ; __IsInstalled() = Check If DropIt Is Installed.
		$gScriptDir = @AppDataDir & "\DropIt\"
	EndIf

	Local $gInitialArray[15][2] = [ _
			[13, 2], _
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
			["", ""]] ; Add Flag = 8192 <= Not Used.

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

Func __GetFileProperties($gFilePath, $gPropertyNumber = 0, $gLocalNumeration = 0) ; Modified Version Of A Melba23's Function - http://www.autoitscript.com/forum/topic/109450-file-properties/
	#cs
		Description: Get The Defined File Property.
		Returns: Defined Property E.G. File Name [FileName.txt]

		Supported Global Numeration:
		0 Name, 1 Size, 2 Type, 3 Date Modified, 4 Date Created, 5 Date Opened, 6 Attributes, 7 Status, 8 Owner,
		9 Date Taken, 10 Dimensions, 11 Camera Model, 12 Authors, 13 Artists, 14 Title, 15 Album, 16 Genre,
		17 Year, 18 Track Number, 19 Subject, 20 Categories, 21 Comments, 22 Copyright, 23 Duration, 24 Bit Rate.
		This Numeration Is Automatically Converted For WinXP, WinVista And Win7.
		More Properties And Relative Numeration Are Reported At The AutoIt Webpage.
	#ce
	Local $gDir_Name = StringRegExpReplace($gFilePath, "(^.*\\)(.*)", "\1")
	Local $gFile_Name = StringRegExpReplace($gFilePath, "^.*\\", "")
	Local $gDOS_Dir = FileGetShortName($gDir_Name, 1)
	Local $gArrayWinXP[25] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 25, 26, 24, 9, 16, 10, 17, 20, 18, 19, 11, 12, 14, 15, 21, 22]
	Local $gArrayWinVista[25] = [0, 1, 2, 3, 4, 5, 6, 7, 10, 12, 31, 30, 20, 13, 21, 14, 16, 15, 26, 22, 23, 24, 25, 27, 28]

	If $gLocalNumeration = 0 Then
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
		Description: Get The Number Of Additional DropIt Instances.
		Returns: 1
	#ce
	Local $gINI = __IsSettingsFile() ; Get Default Settings INI File.
	Return IniRead($gINI, "MultipleInstances", "Running", "0")
EndFunc   ;==>__GetMultipleInstances

Func __GetMultipleInstancesRunning()
	#cs
		Description: Proivide Details Of The Multiple Instances Running.
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
				ReDim $gReturn[UBound($gReturn, 1) * 2][$gReturn[0][1]] ; ReDim $gReturn If More Items Are Required.
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

Func __GetAssociations($gProfile = -1, $gNumberFields = 5)
	#cs
		Description: Get Associations In The Current Profile [-1] Or Specified Profile Name [Valid Profile Name].
		Returns: Array[0][0] - Number Of Items [?]
		[0][1] - Number Of Fields [5]
		[0][2] - Profile Name [Profile Name]

		Array[A][0] - Rule [*.exe$2]
		[A][1] - Destination [C:\DropIt Files]
		[A][2] - Association Name [Executables]
		[A][3] - Filters [1<20MB;1<20d;1<20d;1<20d]
		[A][4] - Association Enabled/Disabled [Enabled]
		[A][5] - List Properties [0;1;2;3;11;13]
	#ce
	$gProfile = __IsProfile($gProfile, 0) ; Get Array Of Selected Profile.

	Local $g_IniReadSection = __IniReadSection($gProfile[0], "Associations")
	If @error Then
		Local $gReturn[1][$gNumberFields + 1] = [[0, $gNumberFields, $gProfile[1]]]
		Return $gReturn
	EndIf

	Local $gStringSplit
	Local $gReturn[$g_IniReadSection[0][0] + 1][$gNumberFields + 1] = [[0, $gNumberFields, $gProfile[1]]]

	For $A = 1 To $g_IniReadSection[0][0]
		$gStringSplit = StringSplit($g_IniReadSection[$A][1], "|")
		If @error Then
			IniDelete($gProfile[0], "Associations", $g_IniReadSection[$A][0])
			ContinueLoop
		EndIf
		ReDim $gStringSplit[$gNumberFields + 1]

		$gReturn[$A][0] = $g_IniReadSection[$A][0]
		For $B = 1 To $gNumberFields
			$gReturn[$A][$B] = $gStringSplit[$B]
		Next
		$gReturn[0][0] += 1
	Next
	ReDim $gReturn[$gReturn[0][0] + 1][$gNumberFields + 1] ; Delete Empty Rows.
	Return $gReturn
EndFunc   ;==>__GetAssociations

Func __GetAssociationString($gAction, $gRule = "")
	#cs
		Description: Get Association String [*.txt$1] Or Action Name [Copy] Or Action Code [$1].
	#ce
	Local $gAssociationString

	If StringLeft($gAction, 1) = "$" Then
		Switch $gAction
			Case "$1"
				$gAssociationString = __Lang_Get('ACTION_COPY', 'Copy')
			Case "$2"
				$gAssociationString = __Lang_Get('ACTION_IGNORE', 'Ignore')
			Case "$3"
				$gAssociationString = __Lang_Get('ACTION_COMPRESS', 'Compress')
			Case "$4"
				$gAssociationString = __Lang_Get('ACTION_EXTRACT', 'Extract')
			Case "$5"
				$gAssociationString = __Lang_Get('ACTION_OPEN_WITH', 'Open With')
			Case "$6"
				$gAssociationString = __Lang_Get('ACTION_DELETE', 'Delete')
			Case "$7"
				$gAssociationString = __Lang_Get('ACTION_RENAME', 'Rename')
			Case "$8"
				$gAssociationString = __Lang_Get('ACTION_LIST', 'List')
			Case Else ; Move.
				$gAssociationString = __Lang_Get('ACTION_MOVE', 'Move')
		EndSwitch
	Else
		Switch $gAction
			Case __Lang_Get('ACTION_COPY', 'Copy')
				$gAssociationString = $gRule & "$1"
			Case __Lang_Get('ACTION_IGNORE', 'Ignore')
				$gAssociationString = $gRule & "$2"
			Case __Lang_Get('ACTION_COMPRESS', 'Compress')
				$gAssociationString = $gRule & "$3"
			Case __Lang_Get('ACTION_EXTRACT', 'Extract')
				$gAssociationString = $gRule & "$4"
			Case __Lang_Get('ACTION_OPEN_WITH', 'Open With')
				$gAssociationString = $gRule & "$5"
			Case __Lang_Get('ACTION_DELETE', 'Delete')
				$gAssociationString = $gRule & "$6"
			Case __Lang_Get('ACTION_RENAME', 'Rename')
				$gAssociationString = $gRule & "$7"
			Case __Lang_Get('ACTION_LIST', 'List')
				$gAssociationString = $gRule & "$8"
			Case Else ; Move.
				$gAssociationString = $gRule & "$0"
		EndSwitch
	EndIf

	Return $gAssociationString
EndFunc   ;==>__GetAssociationString

Func __GetPercent($gSize, $gUpdateCurrent = 1)
	#cs
		Description: Get Current Percent Adding Defined Size.
	#ce
	Local $gCurrentSize = $Global_SortingCurrentSize + $gSize
	If $gUpdateCurrent = 1 Then
		$Global_SortingCurrentSize = $gCurrentSize
	EndIf
	Return Round($gCurrentSize / $Global_SortingTotalSize * 100)
EndFunc   ;==>__GetPercent

Func __GUIInBounds($hHandle = $Global_GUI_1) ; Original Idea By wraithdu.
	#cs
		Description: Check If The GUI Is Within View Of The Users Screen.
		Returns: Move GUI If Out Of Bounds
	#ce
	Local $aWinGetPos, $iHeight, $iWidth, $iXPos, $iYPos

	$iHeight = _WinAPI_GetSystemMetrics(79)
	$iWidth = _WinAPI_GetSystemMetrics(78)
	$aWinGetPos = WinGetPos($hHandle)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	If $aWinGetPos[0] < 5 Then
		$iXPos = 5
	ElseIf ($aWinGetPos[0] + $aWinGetPos[2]) > $iWidth Then
		$iXPos = $iWidth - $aWinGetPos[2] + 3
	Else
		$iXPos = $aWinGetPos[0]
	EndIf

	If $aWinGetPos[1] < 5 Then
		$iYPos = 5
	ElseIf ($aWinGetPos[1] + $aWinGetPos[3]) > $iHeight Then
		$iYPos = $iHeight - $aWinGetPos[3] + 3
	Else
		$iYPos = $aWinGetPos[1]
	EndIf
	WinMove($hHandle, "", $iXPos, $iYPos)
	Return __SetCurrentPosition($hHandle)
EndFunc   ;==>__GUIInBounds

Func __InsertPassword($iFileName)
	Local $iCancel, $iGUI, $iInput, $iOK, $iPassword

	$iGUI = GUICreate(__Lang_Get('PASSWORD_MSGBOX_0', 'Enter Password'), 320, 140, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop())
	GUICtrlCreateLabel(__Lang_Get('PASSWORD_MSGBOX_4', 'Loaded archive:'), 14, 12, 292, 18)
	GUICtrlCreateLabel($iFileName, 16, 12 + 18, 288, 36)
	GUICtrlSetFont(-1, -1, 800)

	GUICtrlCreateLabel(__Lang_Get('PASSWORD_MSGBOX_5', 'Password for decryption:'), 14, 58, 292, 18)
	$iInput = GUICtrlCreateInput("", 14, 75, 292, 20)

	$iOK = GUICtrlCreateButton("&" & __Lang_Get('OK', 'OK'), 160 - 80 - 30, 110, 80, 24)
	$iCancel = GUICtrlCreateButton("&" & __Lang_Get('CANCEL', 'Cancel'), 160 + 30, 110, 80, 24)
	GUICtrlSetState($iOK, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $iCancel
				$iPassword = -1
				ExitLoop

			Case $iOK
				$iPassword = GUICtrlRead($iInput)
				ExitLoop

		EndSwitch
	WEnd

	GUIDelete($iGUI)
	Return $iPassword
EndFunc   ;==>__InsertPassword

Func __InstalledCheck()
	#cs
		Description: Configure DropIt If Installed.
		Returns: Nothing
	#ce

	If __IsInstalled() = 0 Then ; Check If DropIt Is Installed.
		Return SetError(1, 0, 0)
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

	Return 1
EndFunc   ;==>__InstalledCheck

Func __Is($iData, $iINI = -1, $iDefault = "False", $iProfile = 0)
	#cs
		Description: For INI Parameters That Use True/False Results, Therefore It Can Be Called As If __Is("DropItOn") Then ... , Simply Means If DropItOn Is True.
		Returns: True/False
	#ce
	If $iProfile <> 0 Then ; Try To Load It As A Profile Setting.
		$iINI = __IsProfile($iProfile, 1) ; Get Profile Path Of Selected Profile.
		If IniRead($iINI, "General", $iData, "Default") == "Default" Then
			$iINI = -1 ; Use Global Setting.
		EndIf
	EndIf
	If $iINI = -1 Then
		$iINI = __IsSettingsFile() ; Get Default Settings INI File.
	EndIf
	Return IniRead($iINI, "General", $iData, $iDefault) = "True"
EndFunc   ;==>__Is

Func __IsInstalled()
	#cs
		Description: Check If DropIt Is Installed.
		Returns:
		If unins000.exe Exists Return 1
		If Not unins000.exe Exists Return 0
	#ce
	Return FileExists(@ScriptDir & "\unins000.exe")
EndFunc   ;==>__IsInstalled

Func __IsOnTop($hHandle = $Global_GUI_1)
	#cs
		Description: Set A GUI Handle "OnTop" If True/False In The Settings INI File.
		Returns: GUI OnTop Or Not OnTop
	#ce
	Local $iState = __Is("OnTop")
	$hHandle = __IsHandle($hHandle) ; Check If GUI Handle Is A Valid Handle.

	WinSetOnTop($hHandle, "", $iState)
	Return $iState
EndFunc   ;==>__IsOnTop

Func __IsSettingsFile($iINI = -1, $iShowLang = 1)
	#cs
		Description: Provide A Valid Location Of The Settings INI File.
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
		$iINIData = "Version=" & $Global_CurrentVersion & @LF & "Profile=Default" & @LF & "Language=" & __GetOSLanguage() & @LF & "PosX=-1" & @LF & "PosY=-1" & @LF & _
				"SizeCustom=320;200" & @LF & "SizeManage=460;260" & @LF & "ColumnCustom=100;100;60;50" & @LF & "ColumnManage=130;100;90;115" & @LF & _
				"OnTop=True" & @LF & "LockPosition=False" & @LF & "CustomTrayIcon=True" & @LF & "MultipleInstances=False" & @LF & "CheckUpdates=False" & @LF & _
				"StartAtStartup=False" & @LF & "Minimized=False" & @LF & "ShowSorting=True" & @LF & "UseShell=False" & @LF & "ShellMode=Permanent" & @LF & _
				"UseSendTo=False" & @LF & "SendToMode=Permanent" & @LF & "ProfileEncryption=False" & @LF & "ConvertPath=False" & @LF & "WaitOpened=False" & @LF & _
				"ScanSubfolders=True" & @LF & "DirForFolders=False" & @LF & "IgnoreNew=False" & @LF & "AutoDup=False" & @LF & "DupMode=Overwrite" & @LF & _
				"CreateLog=False" & @LF & "IntegrityCheck=False" & @LF & "AlertSize=True" & @LF & "AlertDelete=False" & @LF & "ListHeader=True" & @LF & _
				"ListSortable=False" & @LF & "ListFilter=False" & @LF & "ListTheme=Default" & @LF & "Monitoring=False" & @LF & "MonitoringTime=60" & @LF & _
				"ArchiveFormat=ZIP" & @LF & "ArchiveLevel=Normal" & @LF & "ArchiveMethod=LZMA" & @LF & "ArchiveSelf=False" & @LF & "ArchiveEncrypt=False" & @LF & _
				"ArchiveEncryptMethod=AES-256" & @LF & "ArchivePassword=" & @LF & "MasterPassword="

		__IniWriteEx($iINI, "General", "", $iINIData)
		__IniWriteEx($iINI, "MonitoredFolders", "", "")
		__IniWriteEx($iINI, "EnvironmentVariables", "", "")
		If $iShowLang Then
			__LangList_GUI() ; Skip Language Selection If $iShowLang = 0
		EndIf
	EndIf
	Return $iINI
EndFunc   ;==>__IsSettingsFile

Func __Log_Reduce($lLogFile)
	#cs
		Description: Reduce The Size Of The LogFile.
		Returns: Nothing.
	#ce
	Local $lFileGetSize, $lFileRead, $lStringInStr, $lFileOpen, $lFileWrite

	$lFileGetSize = FileGetSize($lLogFile)
	If $lFileGetSize > 3 * 1024 * 1024 Then ; Log File > 3 MB.
		$lFileRead = FileRead($lLogFile)
		If @error Then
			Return SetError(1, 0, 0)
		EndIf

		$lStringInStr = StringInStr($lFileRead, @CRLF, 0, -1, $lFileGetSize / 2)
		If $lStringInStr = 0 Then
			Return SetError(1, 0, 0)
		EndIf
		$lFileRead = StringTrimLeft($lFileRead, $lStringInStr + 3)
		$lFileOpen = FileOpen($lLogFile, 2 + 32)
		$lFileWrite = FileWrite($lFileOpen, $lFileRead)
		FileClose($lFileOpen)

		If $lFileWrite = 0 Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf
EndFunc   ;==>__Log_Reduce

Func __Log_Write($lFunction = "", $lData = "")
	#cs
		Description: Write Log Line To The Console In SciTE.
		Returns: A Log Line [DropIt Closed ==> C:\Program Files\DropIt\Settings.ini (00:00:00)]
	#ce
	If __Is("CreateLog") Then
		Local $lFileOpen, $lLogFile = __GetDefault(513) ; Get Default Directory & LogFile File Name.

		__Log_Reduce($lLogFile[1][0] & $lLogFile[2][0])
		If $lData <> "" Then
			$lData = ": " & $lData
		EndIf
		$lFileOpen = FileOpen($lLogFile[1][0] & $lLogFile[2][0], 1 + 32)
		FileWriteLine($lFileOpen, @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & " " & $lFunction & $lData)
		If StringInStr($lFunction, __Lang_Get('DROPIT_CLOSED', 'DropIt Closed')) Or StringInStr($lFunction, __Lang_Get('LOG_DISABLED', 'Log Disabled')) Then
			FileWriteLine($lFileOpen, "")
		EndIf
		FileClose($lFileOpen)
	EndIf
	Return 1
EndFunc   ;==>__Log_Write

Func __Password_GUI()
	#cs
		Description: Enter Master Password.
		Returns: Start DropIt If Password Is Correct.
	#ce
	Local $pINI = __IsSettingsFile() ; Get Default Settings INI File.
	If __Is("ProfileEncryption", $pINI) = 0 Or FileExists(__GetDefault(1) & "Profiles.dat") = 0 Then
		Return 1
	EndIf

	Local $pPW, $pPW_Code = $Global_Password_Key
	Local $pMasterPassword, $pOK, $pCancel, $pStart = 1, $pPWFailedAttempts
	Local $pGUI = GUICreate(__Lang_Get('PASSWORD_MSGBOX_0', 'Enter Password'), 240, 80, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop())

	$pMasterPassword = GUICtrlCreateInput("", 15, 15, 210, 20, 0x0020)
	$pOK = GUICtrlCreateButton("&" & __Lang_Get('OK', 'OK'), 120 - 15 - 76, 46, 76, 25)
	$pCancel = GUICtrlCreateButton("&" & __Lang_Get('CANCEL', 'Cancel'), 120 + 15, 46, 76, 25)
	GUICtrlSetState($pOK, $GUI_DEFBUTTON)
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

Func __SendTo_Install() ; Taken From: http://www.autoitscript.com/forum/topic/129818-sendto-create-a-shortcut-in-the-sendto-folder/
	#cs
		Description: Create Shortcuts In The SendTo Folder. [DropIt (Profile_Name).lnk]
		Returns: 1
	#ce
	Local $aFileListToArray

	$aFileListToArray = __ProfileList_Get() ; Get Array Of All Profiles.
	For $A = 1 To $aFileListToArray[0]
		FileCreateShortcut(@AutoItExe, _WinAPI_ShellGetSpecialFolderPath(0x0009) & "\DropIt (" & $aFileListToArray[$A] & ").lnk", @ScriptDir, "-" & $aFileListToArray[$A])
	Next
	Return 1
EndFunc   ;==>__SendTo_Install

Func __SendTo_Uninstall() ; Taken From: http://www.autoitscript.com/forum/topic/129818-sendto-create-a-shortcut-in-the-sendto-folder/
	#cs
		Description: Delete Shortcuts In The SendTo Folder. [DropIt (Profile_Name).lnk]
		Returns: 1
	#ce
	Local $aFileGetShortcut, $aFileListToArray, $sSendTo_Directory

	$sSendTo_Directory = _WinAPI_ShellGetSpecialFolderPath(0x0009) & "\" ; 0x0009 = $sCSIDL_SENDTO
	$aFileListToArray = __FileListToArrayEx($sSendTo_Directory, "*")
	If @error Then
		Return SetError(2, 0, 0)
	EndIf

	For $A = 1 To $aFileListToArray[0]
		If StringInStr($aFileListToArray[$A], "DropIt") Then
			$aFileGetShortcut = FileGetShortcut($aFileListToArray[$A])
			If $aFileGetShortcut[0] = @AutoItExe Then
				FileDelete($aFileListToArray[$A])
			EndIf
		EndIf
	Next
	Return 1
EndFunc   ;==>__SendTo_Uninstall

Func __SetCurrentPosition($hHandle = $Global_GUI_1)
	#cs
		Description: Set The Current Coordinates/Position Of DropIt.
		Returns: 1
	#ce
	Local $aWinGetPos, $sINI, $sINISection

	If $hHandle = "" Then
		Return SetError(1, 0, 0)
	EndIf
	$sINI = __IsSettingsFile() ; Get Default Settings INI File.

	$aWinGetPos = WinGetPos($hHandle)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	$sINISection = "General"
	If $Global_MultipleInstance Then
		$sINISection = $Global_UniqueID
	EndIf
	__IniWriteEx($sINI, $sINISection, "PosX", $aWinGetPos[0])
	__IniWriteEx($sINI, $sINISection, "PosY", $aWinGetPos[1])

	Return 1
EndFunc   ;==>__SetCurrentPosition

Func __SetCurrentSize($hHandle = "", $hWindow = "")
	#cs
		Description: Set The Current Size Of DropIt Windows.
		Returns: 1
	#ce
	Local $aWinGetClientSize, $sINI

	If $hHandle = "" Then
		Return SetError(1, 0, 0)
	EndIf
	$sINI = __IsSettingsFile() ; Get Default Settings INI File.

	$aWinGetClientSize = WinGetClientSize($hHandle)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	__IniWriteEx($sINI, "General", $hWindow, $aWinGetClientSize[0] & ";" & $aWinGetClientSize[1])

	Return 1
EndFunc   ;==>__SetCurrentSize

Func __SetHandle($sID)
	#cs
		Description: Set Window Title For WM_COPYDATA.
		Returns: Handle ID
	#ce
	Local $sGUI = $Global_GUI_1
	AutoItWinSetTitle($sID)
	ControlSetText($sID, '', ControlGetHandle($sID, '', 'Edit1'), $sGUI)
	Return WinGetHandle($sID)
EndFunc   ;==>__SetHandle

Func __SetMultipleInstances($sType = "+")
	#cs
		Description: Set The Number Of Additional DropIt Instances & List The Multiple Instance Name With PID. [1_DropIt_MultipleInstance=8967]
		Returns: 1
	#ce
	Local $iRunning, $sINI

	$iRunning = __GetMultipleInstances()
	$sINI = __IsSettingsFile() ; Get Default Settings INI File.
	Switch $sType
		Case "+"
			$iRunning += 1
			__IniWriteEx($sINI, "MultipleInstances", $Global_UniqueID, @AutoItPID)

		Case "-"
			$iRunning -= 1
			IniDelete($sINI, $Global_UniqueID)
			IniDelete($sINI, "MultipleInstances", $Global_UniqueID)

	EndSwitch
	Return __IniWriteEx($sINI, "MultipleInstances", "Running", $iRunning)
EndFunc   ;==>__SetMultipleInstances

Func __SetAssociationState($sProfile, $sAssociation, $sState)
	#cs
		Description: Enable/Disable The Association.
		Return: 1
	#ce
	Local $sNewString, $sStringSplit, $sNumberFields = 5

	$sStringSplit = StringSplit(IniRead($sProfile, "Associations", $sAssociation, ""), "|")
	ReDim $sStringSplit[$sNumberFields + 1]
	If $sState Then
		$sStringSplit[4] = "Enabled"
	Else
		$sStringSplit[4] = "Disabled"
	EndIf

	For $A = 1 To $sNumberFields
		If $A <> 1 Then
			$sNewString &= "|"
		EndIf
		$sNewString &= $sStringSplit[$A]
	Next
	__IniWriteEx($sProfile, "Associations", $sAssociation, $sNewString)

	Return 1
EndFunc   ;==>__SetAssociationState

Func __ShowPassword($iControlID)
	#cs
		Description: Show/Hide Password Of An Input Password Field.
		Returns: Input State.
	#ce
	Local Const $EM_GETPASSWORDCHAR = 0xD2, $EM_SETPASSWORDCHAR = 0xCC
	Local $sPasswordCharacter
	Switch GUICtrlSendMsg($iControlID, $EM_GETPASSWORDCHAR, 0, 0)
		Case 0
			$sPasswordCharacter = 9679
		Case Else
			$sPasswordCharacter = 0
	EndSwitch
	GUICtrlSendMsg($iControlID, $EM_SETPASSWORDCHAR, $sPasswordCharacter, 0)
	GUICtrlSetState($iControlID, $GUI_FOCUS)
	Return $sPasswordCharacter = 0
EndFunc   ;==>__ShowPassword

Func __SingletonEx($sData = "") ; Taken From: http://www.autoitscript.com/forum/topic/119502-solved-wm-copydata-x64-issue/
	#cs
		Description: Check If DropIt Is Already Running.
		Returns: 1 Or Window Title.
	#ce
	Local $hHandle, $iMultipleInstances

	$hHandle = WinGetHandle($sData)
	If @error Then ; No Instance Is Currently Running.
		__CMDLine($CmdLine) ; Parse Commandline.
		If @error Then ; No Commandline To Parse.
			Return __SetHandle($sData) ; Set Window Title For WM_COPYDATA.
		EndIf
	Else ; Instance Is Currently Running.
		$hHandle = HWnd(ControlGetText($hHandle, '', ControlGetHandle($hHandle, '', 'Edit1')))
		WM_COPYDATA_SENDDATA($hHandle, $CmdLineRaw) ; Send $CmdLineRaw Files To The First Instance Of DropIt.
		If __Is("MultipleInstances") Then
			$iMultipleInstances = __GetMultipleInstances() + 1
			$Global_UniqueID = $iMultipleInstances & "_DropIt_MultipleInstance"
			__SetMultipleInstances("+")
			$Global_MultipleInstance = 1
			Return 1
		EndIf
	EndIf
	Exit
EndFunc   ;==>__SingletonEx

Func __ThemeList_Combo()
	#cs
		Description: Get Themes And Create String For Use In A Combo Box.
		Returns: String Of Themes.
	#ce
	Local $iSearch, $sFileName, $sData

	$iSearch = FileFindFirstFile(@ScriptDir & "\Lib\list\themes\*.css")
	While 1
		$sFileName = FileFindNextFile($iSearch)
		If @error Then
			ExitLoop
		EndIf
		$sData &= StringTrimRight($sFileName, 4) & "|"
	WEnd
	FileClose($iSearch)

	Return StringTrimRight($sData, 1)
EndFunc   ;==>__ThemeList_Combo

Func __Uninstall()
	#cs
		Description: Uninstall Files Etc... If The Uninstall Commandline Parameter Is Called. [DropIt.exe /Uninstall]
		Returns: 1
	#ce
	If __Is("UseShell") Then
		_ShellAll_Uninstall() ; Context Menu Integration Is Removed If Was Used By The Installed Version.
	EndIf
	If __Is("UseSendTo") Then
		__SendTo_Uninstall() ; SendTo Integration Is Removed If Was Used By The Installed Version.
	EndIf
	Exit
EndFunc   ;==>__Uninstall

Func __Upgrade()
	#cs
		Description: Upgrade Settings To New Version, If Needed.
		Returns: 1
	#ce
	Local $uINIRead
	Local $uINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $uOldVersion = IniRead($uINI, "General", "Version", "None")
	If $uOldVersion == $Global_CurrentVersion Then
		Return SetError(1, 0, 0) ; Abort Upgrade If INI Version Is The Same Of Current Software Version.
	EndIf

	FileMove($uINI, $uINI & ".old", 1) ; Rename The Old INI.
	__IsSettingsFile(-1, 0) ; Create A New Upgraded INI, Skipping Language Selection.

	Local $uINI_Array[48][3] = [ _
			[47, 3], _
			["General", "Profile", 1], _
			["General", "Language", 1], _
			["General", "PosX", 1], _
			["General", "PosY", 1], _
			["General", "SizeCustom", 1], _
			["General", "SizeManage", 1], _
			["General", "ColumnCustom", 1], _
			["General", "ColumnManage", 1], _
			["General", "OnTop", 1], _
			["General", "LockPosition", 1], _
			["General", "CustomTrayIcon", 1], _
			["General", "MultipleInstances", 1], _
			["General", "StartAtStartup", 1], _
			["General", "Minimized", 1], _
			["General", "ConvertPath", 1], _
			["General", "WaitOpened", 1], _
			["General", "UseShell", 1], _
			["General", "ShellMode", 1], _
			["General", "UseSendTo", 1], _
			["General", "SendToMode", 1], _
			["General", "ShowSorting", 1], _
			["General", "ProfileEncryption", 1], _
			["General", "ScanSubfolders", 1], _
			["General", "DirForFolders", 1], _
			["General", "IgnoreNew", 1], _
			["General", "AutoDup", 1], _
			["General", "DupMode", 1], _
			["General", "CreateLog", 1], _
			["General", "IntegrityCheck", 1], _
			["General", "SizeMessage", "AlertSize"], _
			["General", "AlertSize", 1], _
			["General", "AlertDelete", 1], _
			["General", "ListHeader", 1], _
			["General", "ListSortable", 1], _
			["General", "ListTheme", 1], _
			["General", "ListFilter", 1], _
			["General", "CheckUpdates", 1], _
			["General", "Monitoring", 1], _
			["General", "MonitoringTime", 1], _
			["General", "ArchiveFormat", 1], _
			["General", "ArchiveLevel", 1], _
			["General", "ArchiveMethod", 1], _
			["General", "ArchiveSelf", 1], _
			["General", "ArchiveEncrypt", 1], _
			["General", "ArchiveEncryptMethod", 1], _
			["General", "ArchivePassword", 1], _
			["General", "MasterPassword", 1]]
	; ["General", "OldKey", "NewKey"], _ ; Example Of Changed Item.

	For $A = 1 To $uINI_Array[0][0]
		$uINIRead = IniRead($uINI & ".old", $uINI_Array[$A][0], $uINI_Array[$A][1], "None")
		If $uINIRead <> "None" Then
			If $uINI_Array[$A][2] = 1 Then
				$uINI_Array[$A][2] = $uINI_Array[$A][1]
			EndIf
			__IniWriteEx($uINI, $uINI_Array[$A][0], $uINI_Array[$A][2], $uINIRead)
		EndIf
	Next
	__IniWriteEx($uINI, "EnvironmentVariables", "", "")
	FileDelete($uINI & ".old") ; Remove The Old INI.

	If $uOldVersion < "3.7" Then
		Local $uFileRead, $uFileOpen, $uAssociations, $uNumberFields = 5
		Local $uProfileList = __ProfileList_Get(1) ; Get Array Of All Profile Paths.
		For $A = 1 To $uProfileList[0]
			$uFileRead = StringReplace(FileRead($uProfileList[$A]), "[Patterns]", "[Associations]")
			$uFileOpen = FileOpen($uProfileList[$A], 2 + 32)
			FileWrite($uFileOpen, $uFileRead)
			FileClose($uFileOpen)
			If $uOldVersion < "3.6" Then
				$uAssociations = __GetAssociations(__GetFileNameOnly($uProfileList[$A]), 9) ; Get Associations Array For The Selected Profile.
				For $B = 1 To $uAssociations[0][0]
					$uAssociations[$B][1] = StringReplace($uAssociations[$B][1], "Empty-Destination", "-") ; Fix Destination Created In Old Releases.
					If $uAssociations[$B][6] <> "" Then
						$uAssociations[$B][3] = $uAssociations[$B][3] & ";" & $uAssociations[$B][4] & ";" & $uAssociations[$B][5] & ";" & $uAssociations[$B][6]
					EndIf
					$uAssociations[$B][4] = $uAssociations[$B][7]
					$uAssociations[$B][5] = $uAssociations[$B][8]
					$uINIRead = ""
					For $C = 1 To $uNumberFields
						If $C <> 1 Then
							$uINIRead &= "|"
						EndIf
						$uINIRead &= $uAssociations[$B][$C]
					Next
					__IniWriteEx($uProfileList[$A], "Associations", $uAssociations[$B][0], $uINIRead)
				Next
			EndIf
		Next
	EndIf

	Return 1
EndFunc   ;==>__Upgrade
#EndRegion >>>>> INTERNAL: Various Functions <<<<<

#Region >>>>> LIBRARY: 7Zip Functions <<<<< Taken From: http://www.autoitscript.com/forum/topic/91283-7zread-udf/
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
#EndRegion >>>>> LIBRARY: 7Zip Functions <<<<< Taken From: http://www.autoitscript.com/forum/topic/91283-7zread-udf/

#Region >>>>> LIBRARY: Hash Functions <<<<< Taken From: http://www.autoitscript.com/forum/topic/95558-crc32-md4-md5-sha1-for-files/
Func __MD5ForFile($mFile, $mRead = 100)
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

Func __SHA1ForFile($sFile)
	Local $a_hCall = DllCall("kernel32.dll", "hwnd", "CreateFileW", "wstr", $sFile, "dword", 0x80000000, "dword", 3, "ptr", 0, "dword", 3, "dword", 0, "ptr", 0)
	If @error Or $a_hCall[0] = -1 Then
		Return SetError(1, 0, "")
	EndIf
	Local $hFile = $a_hCall[0]
	$a_hCall = DllCall("kernel32.dll", "ptr", "CreateFileMappingW", "hwnd", $hFile, "dword", 0, "dword", 2, "dword", 0, "dword", 0, "ptr", 0)
	If @error Or Not $a_hCall[0] Then
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFile)
		Return SetError(2, 0, "")
	EndIf
	DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFile)
	Local $hFileMappingObject = $a_hCall[0]
	$a_hCall = DllCall("kernel32.dll", "ptr", "MapViewOfFile", "hwnd", $hFileMappingObject, "dword", 4, "dword", 0, "dword", 0, "dword", 0)
	If @error Or Not $a_hCall[0] Then
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
		Return SetError(3, 0, "")
	EndIf
	Local $pFile = $a_hCall[0]
	Local $iBufferSize = FileGetSize($sFile)
	Local $a_iCall = DllCall("advapi32.dll", "int", "CryptAcquireContext", "ptr*", 0, "ptr", 0, "ptr", 0, "dword", 1, "dword", 0xF0000000)
	If @error Or Not $a_iCall[0] Then
		DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
		Return SetError(4, 0, "")
	EndIf
	Local $hContext = $a_iCall[1]
	$a_iCall = DllCall("advapi32.dll", "int", "CryptCreateHash", "ptr", $hContext, "dword", 0x00008004, "ptr", 0, "dword", 0, "ptr*", 0)
	If @error Or Not $a_iCall[0] Then
		DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
		DllCall("advapi32.dll", "int", "CryptReleaseContext", "ptr", $hContext, "dword", 0)
		Return SetError(5, 0, "")
	EndIf
	Local $hHashSHA1 = $a_iCall[5]
	$a_iCall = DllCall("advapi32.dll", "int", "CryptHashData", "ptr", $hHashSHA1, "ptr", $pFile, "dword", $iBufferSize, "dword", 0)
	If @error Or Not $a_iCall[0] Then
		DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
		DllCall("advapi32.dll", "int", "CryptDestroyHash", "ptr", $hHashSHA1)
		DllCall("advapi32.dll", "int", "CryptReleaseContext", "ptr", $hContext, "dword", 0)
		Return SetError(6, 0, "")
	EndIf
	Local $tOutSHA1 = DllStructCreate("byte[20]")
	$a_iCall = DllCall("advapi32.dll", "int", "CryptGetHashParam", "ptr", $hHashSHA1, "dword", 2, "ptr", DllStructGetPtr($tOutSHA1), "dword*", 20, "dword", 0)
	If @error Or Not $a_iCall[0] Then
		DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
		DllCall("advapi32.dll", "int", "CryptDestroyHash", "ptr", $hHashSHA1)
		DllCall("advapi32.dll", "int", "CryptReleaseContext", "ptr", $hContext, "dword", 0)
		Return SetError(7, 0, "")
	EndIf
	DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
	DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
	DllCall("advapi32.dll", "int", "CryptDestroyHash", "ptr", $hHashSHA1)
	Local $sSHA1 = Hex(DllStructGetData($tOutSHA1, 1))
	DllCall("advapi32.dll", "int", "CryptReleaseContext", "ptr", $hContext, "dword", 0)
	Return SetError(0, 0, $sSHA1)
EndFunc   ;==>__SHA1ForFile
#EndRegion >>>>> LIBRARY: Hash Functions <<<<< Taken From: http://www.autoitscript.com/forum/topic/95558-crc32-md4-md5-sha1-for-files/

#Region >>>>> LIBRARY: Secure Delete Functions <<<<< Taken From: http://www.autoitscript.com/forum/topic/82954-securely-overwrite-files/
Func __SecureFileDelete($sFile, $sRename = True, $sFileTime = True, $sDelete = True, $sInputPatterns = -1, $sBlock = 32768)
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
			$sTempFile = _WinAPI_GetTempFileName($sDir)
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
	Local $sReturn = DllCall("kernel32.dll", "bool", "GetDiskFreeSpaceW", "wstr", __GetDrive($sPath), "dword*", 0, "dword*", 0, "dword*", 0, "dword*", 0)
	If @error Or (Not $sReturn[0]) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $sReturn[3]
EndFunc   ;==>__SecureFileDelete_GetDiskClusterSize

Func __SecureFolderDelete($sFolder, $sRename = True, $sFileTime = True, $sDelete = True, $sPatterns = -1, $sBlock = 32768)
	#cs
		Description: Securely Delete A Folder.
		Returns: 1
	#ce
	If _WinAPI_PathIsDirectory($sFolder) = 0 Or FileExists($sFolder) = 0 Then
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
#EndRegion >>>>> LIBRARY: Secure Delete Functions <<<<< Taken From: http://www.autoitscript.com/forum/topic/82954-securely-overwrite-files/

#Region >>>>> LIBRARY: TrayIcon Functions <<<<<
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

	If __IsWindowsVersion() = 0 Then
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
	_GDIPlus_BitmapDispose($ts_Bitmap)
	_WinAPI_DestroyIcon($ts_Icon)
	Return $ts_Return[0] <> 0
EndFunc   ;==>__Tray_SetIcon
#EndRegion >>>>> LIBRARY: TrayIcon Functions <<<<<

#Region >>>>> LIBRARY: Various Functions <<<<<
Func __ByteSuffix($iBytes)
	#cs
		Description: Round A Value Of Bytes To Highest Value.
		Returns: [1024 Bytes = 1 KB]
	#ce
	Local $A, $iPlaces = 1, $aArray[9] = [" bytes", " KB", " MB", " GB", " TB", " PB", " EB", " ZB", " YB"]
	While $iBytes > 1023
		$A += 1
		$iBytes /= 1024
	WEnd
	If $iBytes < 100 Then
		$iPlaces += 1
	EndIf
	Return Round($iBytes, $iPlaces) & $aArray[$A]
EndFunc   ;==>__ByteSuffix

Func __CmdLineRaw($sString) ; Taken From: http://www.autoitscript.com/forum/topic/121034-stringsplit-cmdlineraw/page__p__840768#entry840768
	Local $aError[2] = [1, $sString]

	If StringStripWS($sString, 8) = "" Then
		Return SetError(1, 0, $aError)
	EndIf
	Local $aReturn = StringRegExp('"' & @ScriptFullPath & '"' & ' ' & _WinAPI_ExpandEnvironmentStrings($sString), '((?<=\s"|^")[^"]+(?=")|[^\s"]+)', 3)
	If @error Then
		Return SetError(1, 0, $aError)
	EndIf
	$aReturn[0] = UBound($aReturn, 1) - 1
	Return $aReturn
EndFunc   ;==>__CmdLineRaw

Func __ExpandEnvStrings($iEnvStrings)
	#cs
		Description: Set The Expansion Of Environment Variables.
		Returns: 0 = Disabled Or 1 = Enabled
	#ce.
	Opt("ExpandEnvStrings", $iEnvStrings)
	Return $iEnvStrings
EndFunc   ;==>__ExpandEnvStrings

Func __ExpandEventMode($iEventMode)
	#cs
		Description: Set The Expansion Of The GUIOnEventMode.
		Returns: 0 = Disabled Or 1 = Enabled.
	#ce.
	Opt("GUIOnEventMode", $iEventMode)
	Return $iEventMode
EndFunc   ;==>__ExpandEventMode

Func __FileListToArrayEx($sFilePath, $sFilter = "*") ; Taken From: _FileListToArray() & Optimised By guinness For Increase In Speed (Reduction Of 0.50ms.)
	Local $aError[1] = [0], $hSearch, $sFile, $sReturn = ""

	If FileExists($sFilePath) = 0 Then
		Return SetError(1, 0, $aError)
	EndIf
	$sFilePath = _WinAPI_PathAddBackslash($sFilePath)

	$hSearch = FileFindFirstFile($sFilePath & $sFilter)
	If $hSearch = -1 Then
		Return SetError(2, 0, $aError)
	EndIf

	While 1
		$sFile = FileFindNextFile($hSearch)
		If @error Then
			ExitLoop
		EndIf
		$sReturn &= $sFilePath & $sFile & "*"
	WEnd
	FileClose($hSearch)
	If $sReturn = "" Then
		Return SetError(3, 0, $aError)
	EndIf
	Return StringSplit(StringTrimRight($sReturn, 1), "*")
EndFunc   ;==>__FileListToArrayEx

Func __GetDrive($sFilePath) ; Taken From: http://www.autoitscript.com/forum/topic/82954-securely-overwrite-files/
	#cs
		Description: Get The Drive Letter Of An Absolute Or Relative Path.
		Returns: Drive Letter [C]
	#ce
	If StringInStr($sFilePath, ":") Then
		Return StringRegExpReplace($sFilePath, "^.*([[:alpha:]]:).*$", "${1}\\") ; Full Or UNC Path.
	EndIf
	Return StringRegExpReplace(@WorkingDir, "^([[:alpha:]]:).*$", "${1}\\") ; Relative Path, Use Current Drive.
EndFunc   ;==>__GetDrive

Func __GetFileExtension($sFilePath)
	#cs
		Description: Get The File Extension.
		Returns: File Extension [txt]
	#ce
	Return StringTrimLeft(_WinAPI_PathFindExtension($sFilePath), 1)
EndFunc   ;==>__GetFileExtension

Func __GetFileName($sFilePath)
	#cs
		Description: Get The File Name From A File Path.
		Returns: File Name [FileName.txt] Or Empty String If @error
	#ce
	Return _WinAPI_PathStripPath($sFilePath)
EndFunc   ;==>__GetFileName

Func __GetFileNameOnly($sFilePath)
	#cs
		Description: Get The File Name Only From A File Path.
		Returns: File Name [FileName]
	#ce
	Return _WinAPI_PathStripPath(_WinAPI_PathRemoveExtension($sFilePath))
EndFunc   ;==>__GetFileNameOnly

Func __GetOSLanguage()
	#cs
		Description: Get The OS Language.
		Returns: Language [Italian]
	#ce
	Local $aString[20] = [19, "0409 0809 0c09 1009 1409 1809 1c09 2009 2409 2809 2c09 3009 3409", "0404 0804 0c04 1004 0406", "0406", "0413 0813", "0425", _
			"040b", "040c 080c 0c0c 100c 140c 180c", "0407 0807 0c07 1007 1407", "040e", "0410 0810", _
			"0411", "0414 0814", "0415", "0416 0816", "0418", _
			"0419", "081a 0c1a", "040a 080a 0c0a 100a 140a 180a 1c0a 200a 240a 280a 2c0a 300a 340a 380a 3c0a 400a 440a 480a 4c0a 500a", "041d 081d"]

	Local $aLanguage[20] = [19, "English", "Chinese", "Danish", "Dutch", "Estonian", "Finnish", "French", "German", "Hungarian", "Italian", _
			"Japanese", "Norwegian", "Polish", "Portuguese", "Romanian", "Russian", "Serbian", "Spanish", "Swedish"]
	For $A = 1 To $aString[0]
		If StringInStr($aString[$A], @OSLang) Then
			Return $aLanguage[$A]
		EndIf
	Next
	Return $aLanguage[1]
EndFunc   ;==>__GetOSLanguage

Func __GetParentFolder($sFilePath)
	#cs
		Description: Get The Parent Folder.
		Returns: Parent Folder [C:\Program Files\Test] Or Empty String If @error
	#ce
	Return _WinAPI_PathRemoveFileSpec($sFilePath)
EndFunc   ;==>__GetParentFolder

Func __GetRelativePath($sFilePath, $sFilePathRef = @ScriptDir)
	#cs
		Description: Get The Path Relative To The Reference Path.
		Returns: Relative Path [..\Path\Test] Or Original Path If @error
	#ce
	Local $aArray[2][2] = [[$sFilePath, 0],[$sFilePathRef, 0]], $sFilePathNew

	For $A = 0 To 1
		If _WinAPI_PathIsRelative($aArray[$A][0]) Then
			$aArray[$A][0] = _WinAPI_GetFullPathName(@ScriptDir & "\" & $aArray[$A][0])
		EndIf

		If _WinAPI_PathIsDirectory($aArray[$A][0]) Then
			$aArray[$A][0] = _WinAPI_PathAddBackslash($aArray[$A][0])
			$aArray[$A][1] = 1
		EndIf
	Next

	$sFilePathNew = _WinAPI_PathRelativePathTo($aArray[1][0], $aArray[1][1], $aArray[0][0], $aArray[0][1])
	If @error Then
		Return SetError(1, 0, $sFilePath)
	EndIf

	If $sFilePathNew == "." Then
		$sFilePathNew &= "\"
	EndIf
	Return $sFilePathNew
EndFunc   ;==>__GetRelativePath

Func __ImageResize($sFilePath, $iWidth, $iHeight)
	#cs
		Description: Resize The Image File (In The Program Only) If Size Is Different To The Correct Size.
		Returns: New Image [Default New Size.png]
	#ce
	Local $hImage, $hGraphicsContent, $hImageNew, $iNewGraphicsContent

	$hImage = _GDIPlus_ImageLoadFromFile($sFilePath)
	$hGraphicsContent = _GDIPlus_ImageGetGraphicsContext($hImage)
	$hImageNew = _GDIPlus_BitmapCreateFromGraphics($iWidth, $iHeight, $hGraphicsContent)
	$iNewGraphicsContent = _GDIPlus_ImageGetGraphicsContext($hImageNew)
	_GDIPlus_GraphicsDrawImageRect($iNewGraphicsContent, $hImage, 0, 0, $iWidth, $iHeight)
	_GDIPlus_GraphicsDispose($hGraphicsContent)
	_GDIPlus_GraphicsDispose($iNewGraphicsContent)
	_GDIPlus_ImageDispose($hImage)
	Return $hImageNew
EndFunc   ;==>__ImageResize

Func __ImageRelativeSize($iGUIWidth, $iGUIHeight, $iImageWidth, $iImageHeight)
	#cs
		Description: Calculate The Correct Width And Height Of An Image In A GUI.
		Returns: An Array[2]
		[0] - Width Of GUI [64]
		[1] - Height Of GUI [64]
	#ce
	Local $aReturn[2] = [$iGUIWidth, $iGUIHeight]

	If ($iImageWidth < 0) Or ($iImageHeight < 0) Then
		Return SetError(1, 0, $aReturn)
	EndIf

	If $iImageWidth < $iImageHeight Then
		$aReturn[0] = Int($iGUIWidth * $iImageWidth / $iImageHeight)
		$aReturn[1] = Int($iGUIHeight)
	Else
		$aReturn[1] = Int($iGUIHeight * $iImageHeight / $iImageWidth)
		$aReturn[0] = Int($iGUIWidth)
	EndIf
	Return $aReturn
EndFunc   ;==>__ImageRelativeSize

Func __ImageSize($sFilePath) ; Taken From: http://www.autoitscript.com/forum/topic/121275-how-to-get-size-of-pictures/page__view__findpost__p__842249
	#cs
		Description: Calculate The Correct Width And Height Of An Image.
		Returns: An Array[2] Or @error
		[0] - Width Of Image File [64]
		[1] - Height Of Image File [64]
	#ce
	Local $aReturn[2] = [0, 0], $hImage

	If FileExists($sFilePath) = 0 Then
		Return SetError(1, 0, $aReturn)
	EndIf
	$hImage = _GDIPlus_ImageLoadFromFile($sFilePath)
	$aReturn[0] = _GDIPlus_ImageGetWidth($hImage)
	$aReturn[1] = _GDIPlus_ImageGetHeight($hImage)
	_GDIPlus_ImageDispose($hImage)
	If @error Then
		Return SetError(1, 0, $aReturn)
	EndIf
	Return $aReturn
EndFunc   ;==>__ImageSize

Func __IniReadSection($iFile, $iSection) ; Modified From: http://www.autoitscript.com/forum/topic/32004-iniex-functions-exceed-32kb-limit/page__view__findpost__p__229487
	#cs
		Description: Read A Section From A Standard Format INI File.
		Returns: $Array[?] - Array Contains Unlimited Number Of Items.
		[0][0] - Number Of Rows [3]

		[A][0] - Key [Example]
		[A][1] - Value [Test]
	#ce
	Local $iSize = FileGetSize($iFile) / 1024
	If $iSize <= 31 Then
		Local $iRead = IniReadSection($iFile, $iSection)
		If @error Then
			Return SetError(@error, 0, 0)
		EndIf
		If IsArray($iRead) = 0 Then
			Return SetError(-2, 0, 0)
		EndIf
		Return $iRead
	EndIf

	Local $iSplitKeyValue
	Local $iFileRead = FileRead($iFile)
	Local $iData = StringRegExp($iFileRead, "(?is)(?:^|\v)(?!;|#)\h*\[\h*\Q" & $iSection & "\E\h*\]\h*\v+(.*?)(?:\z|\v\h*\[)", 1)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Local $iLines = StringSplit(StringStripCR($iData[0]), @LF)
	Local $iLeft, $iAdded = 0, $iSectionReturn[$iLines[0] + 1][2]
	For $A = 1 To $iLines[0]
		$iSplitKeyValue = StringSplit($iLines[$A], "=")
		$iLeft = StringLeft(StringStripWS($iLines[$A], 8), 1)
		If $iSplitKeyValue[0] = 2 And $iLeft <> ";" And $iLeft <> "#" Then
			$iAdded += 1
			$iSectionReturn[$iAdded][0] = $iSplitKeyValue[1]
			$iSectionReturn[$iAdded][1] = $iSplitKeyValue[2]
		EndIf
	Next
	ReDim $iSectionReturn[$iAdded + 1][2]
	$iSectionReturn[0][0] = $iAdded
	Return $iSectionReturn
EndFunc   ;==>__IniReadSection

Func __IniWriteEx($iFile, $iSection, $iKey = "", $iValue = "")
	#cs
		Description: Write A Key Or A Section From A Standard Format INI File With Unicode Support.
		Returns: 1
	#ce
	Local $iWrite

	If FileGetEncoding($iFile) <> 32 Then
		Local $iFileRead = FileRead($iFile)
		If @error And FileExists($iFile) Then
			Return SetError(1, 0, 0)
		EndIf
		Local $iFileOpen = FileOpen($iFile, 2 + 8 + 32)
		If $iFileOpen = -1 Then
			Return SetError(1, 0, 0)
		EndIf
		$iWrite = FileWrite($iFileOpen, $iFileRead)
		FileClose($iFileOpen)
		If $iWrite = 0 Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf

	If $iKey = "" Then ; Write Section.
		$iWrite = IniWriteSection($iFile, $iSection, $iValue)
	Else ; Write Key.
		$iWrite = IniWrite($iFile, $iSection, $iKey, $iValue)
	EndIf
	If $iWrite = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__IniWriteEx

Func __IsHandle($hHandle = -1)
	#cs
		Description: Check If GUI Handle Is A Valid Handle.
		Returns:
		If True Return The Handle.
		If False Return The AutoIt Hidden Handle.
	#ce
	If IsHWnd($hHandle) Then
		Return $hHandle
	EndIf
	Return WinGetHandle(AutoItWinGetTitle())
EndFunc   ;==>__IsHandle

Func __IsReadOnly($sFilePath)
	#cs
		Description: Check Whether A File Is Read-Only.
		Returns:
		If Read-Only Return 1
		If Not Read-Only Return 0
	#ce
	Return StringInStr(FileGetAttrib($sFilePath), "R") > 0
EndFunc   ;==>__IsReadOnly

Func __IsSupported($sFilePath, $sFormats = "exe")
	#cs
		Description: Check If A File Is Supported.
		Returns: 1 = True Or 0 = False
	#ce
	If StringLeft($sFilePath, 1) <> "." Then
		$sFilePath = "." & $sFilePath
	EndIf
	If StringRegExp($sFormats, "\\|/|:|\<|\>|\|") Then
		Return SetError(1, 2, "")
	EndIf
	$sFormats = "*." & StringReplace(StringStripWS(StringRegExpReplace($sFormats, "\s*;\s*", ";"), 3), ";", "|*.")
	Return StringRegExp($sFilePath, "(?i)^" & StringReplace(StringReplace(StringReplace($sFormats, ".", "\."), "*", ".*"), "?", ".") & "\z")
EndFunc   ;==>__IsSupported

Func __IsWindowsVersion()
	#cs
		Description: Check If The Windows Version Is Supported.
		Returns: 1 = Is Supported Or 0 = Not Supported.
	#ce
	Return RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\", "CurrentVersion") >= 6.0
EndFunc   ;==>__IsWindowsVersion

Func __OnTop($hHandle = -1, $iState = 1)
	#cs
		Description: Set A GUI Handle "OnTop".
		Returns: GUI OnTop
	#ce
	$hHandle = __IsHandle($hHandle) ; Check If GUI Handle Is A Valid Handle.

	WinSetOnTop($hHandle, "", $iState)
	Return $hHandle
EndFunc   ;==>__OnTop

Func __SetBitmap($hGUI, $sImagePath, $iOpacity, $iWidth, $iHeight)
	#cs
		Description: Set An Image File To A GUI Handle.
		Returns: Image Name [Default.png]
	#ce
	Local $hBitmap, $hGetDC, $hImage, $hMemDC, $hPreviousImage, $hReturn, $pBlend, $pSize, $pSource, $tBlend, $tSize, $tSource

	$hImage = __ImageResize($sImagePath, $iWidth, $iHeight)
	$hReturn = $hImage

	$hGetDC = _WinAPI_GetDC(0)
	$hMemDC = _WinAPI_CreateCompatibleDC($hGetDC)
	$hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
	$hPreviousImage = _WinAPI_SelectObject($hMemDC, $hBitmap)
	$tSize = DllStructCreate($tagSIZE)
	$pSize = DllStructGetPtr($tSize)
	DllStructSetData($tSize, "X", _GDIPlus_ImageGetWidth($hImage))
	DllStructSetData($tSize, "Y", _GDIPlus_ImageGetHeight($hImage))
	$tSource = DllStructCreate($tagPOINT)
	$pSource = DllStructGetPtr($tSource)
	$tBlend = DllStructCreate($tagBLENDFUNCTION)
	$pBlend = DllStructGetPtr($tBlend)
	DllStructSetData($tBlend, "Alpha", $iOpacity)
	DllStructSetData($tBlend, "Format", 1)
	_WinAPI_UpdateLayeredWindow($hGUI, $hGetDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
	_WinAPI_ReleaseDC(0, $hGetDC)
	_WinAPI_SelectObject($hMemDC, $hPreviousImage)
	_WinAPI_DeleteObject($hBitmap)
	_WinAPI_DeleteDC($hMemDC)
	Return $hReturn
EndFunc   ;==>__SetBitmap

Func __SetItemImage($gImageFile, $gIndex, $gHandle = 0, $gType = 1, $gResource = 1, $gWidth = 20, $gHeight = 20)
	#cs
		Description: Set Image To GUI/Tray Context Menu.
		Returns: Converted Image.
	#ce
	If __IsWindowsVersion() = 0 Then
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
			_GDIPlus_BitmapDispose($gImage)
			Return SetError(0, 0, $gIcon)
	EndSwitch
EndFunc   ;==>__SetItemImage

Func __SetItemImageEx($gHandle, $gIndex, ByRef $gImageList, $gImageFile, $gType) ; Taken From: http://www.autoitscript.com/forum/topic/113827-thumbnail-of-a-file/page__p__799038#entry799038
	#cs
		Description: Set Image To Control Handle.
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

Func __SetProgress($sHandle, $sPercentage, $sColor = 0, $sVertical = False) ; Taken From: http://www.autoitscript.com/forum/topic/121883-progress-bar-without-animation-in-vista7/page__p__845958#entry845958
	#cs
		Description: Set A Custom Progress Bar.
		Return: Progress Data.
	#ce
	Local $sBitmap, $sClip, $sDC, $sMemDC, $sObject, $sRectangle, $sResult = 1, $sRet, $sStructure_1, $sStructure_2, $sTheme, $sWinAPI_Object
	If __IsWindowsVersion() = 0 Then
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

Func __StringIsValid($sString, $sPattern = '|<>')
	#cs
		Description: Check If A String Contains Invalid Characters.
		Returns:
		If String Contains Invalid Characters Return 1
		If Not String Contains Invalid Characters Return 0
	#ce
	Return BitAND(StringRegExp($sString, '[\Q' & StringRegExpReplace($sPattern, "\\E", "E\") & '\E]') = 0, 1)
EndFunc   ;==>__StringIsValid

Func __TimeSuffix($iTime)
	#cs
		Description: Convert MilliSeconds (MS) Into 00:00:00 [10000 MS = 00:00:10].
		Returns: Converted Format.
	#ce
	Local $iTotalSeconds = Int($iTime / 1000)
	Local $iHours = Int($iTotalSeconds / 3600), $iMinutes = Int(($iTotalSeconds - ($iHours * 3600)) / 60), $iSeconds = $iTotalSeconds - (($iHours * 3600) + ($iMinutes * 60))
	If $iHours < 10 Then
		$iHours = 0 & $iHours
	EndIf
	If $iMinutes < 10 Then
		$iMinutes = 0 & $iMinutes
	EndIf
	If $iSeconds < 10 Then
		$iSeconds = 0 & $iSeconds
	EndIf
	Return $iHours & ":" & $iMinutes & ":" & $iSeconds
EndFunc   ;==>__TimeSuffix
#EndRegion >>>>> LIBRARY: Various Functions <<<<<