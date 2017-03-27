#cs ----------------------------------------------------------------------------
	Application Name: DropIt
	License: Open Source GPL
	Language: English
	AutoIt Version: 3.3.9.4
	Authors: Lupo73 and guinness
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
#AutoIt3Wrapper_Res_Fileversion=4.5.0.0
#AutoIt3Wrapper_Res_ProductVersion=4.5.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Lupo PenSuite Team
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_Field=Website|http://dropit.sourceforge.net
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
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\Remove.ico
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
#AutoIt3Wrapper_Res_File_Add=Lib\img\Import.png, 10, IMPORT
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
#AutoIt3Wrapper_Compile_Both=Y
#EndRegion ; **** Directives Created By AutoIt3Wrapper_GUI ****

#include <Date.au3>
#include <DateTimeConstants.au3>
#include <Excel.au3>
#include <FTPEx.au3>
#include <GUIButton.au3>
#include <GUIComboBoxEx.au3>
#include <GUIImageList.au3>
#include <GUIListBox.au3>
#include <GUIListView.au3>
#include <GUIMenu.au3>
#include <GUIToolTip.au3>
#include <Lib\udf\7ZipRead.au3>
#include <Lib\udf\APIConstants.au3>
#include <Lib\udf\Copy.au3>
#include <Lib\udf\HashForFile.au3>
#include <Lib\udf\Resources.au3>
#include <Lib\udf\SFTPEx.au3>
#include <Lib\udf\Startup.au3>
#include <Lib\udf\WinAPIEx.au3>
#include <Misc.au3>
#include <StaticConstants.au3>
#include <String.au3>
#include <WindowsConstants.au3>

Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1)

; <<<<< Variables >>>>>
Global $Global_CurrentVersion = "4.5"
Global $Global_ImageList, $Global_GUI_1, $Global_GUI_2, $Global_Icon_1, $Global_GUI_State = 1 ; ImageList & GUI Handles & Icons Handle & GUI State.
Global $Global_ContextMenu[15][2] = [[14, 2]], $Global_TrayMenu[14][2] = [[13, 2]], $Global_MenuDisable = 0 ; ContextMenu & TrayMenu.
Global $Global_ListViewIndex = -1, $Global_ListViewFolders, $Global_ListViewProfiles, $Global_ListViewRules ; ListView Variables.
Global $Global_ListViewProfiles_Enter, $Global_ListViewProfiles_New, $Global_ListViewProfiles_Delete, $Global_ListViewProfiles_Duplicate ; ListView Variables.
Global $Global_ListViewProfiles_Import, $Global_ListViewProfiles_Options, $Global_ListViewProfiles_Example[2], $Global_ListViewFolders_Enter, $Global_ListViewFolders_New ; ListView Variables.
Global $Global_ListViewRules_ComboBox, $Global_ListViewRules_ComboBoxChange = 0, $Global_ListViewRules_ItemChange = -1 ; ListView Variables.
Global $Global_ListViewRules_CopyTo, $Global_ListViewRules_Delete, $Global_ListViewRules_Enter, $Global_ListViewRules_New, $Global_ListViewFolders_ItemChange = -1 ; ListView Variables.
Global $Global_AbortButton, $Global_AbortSorting = 0, $Global_SortingCurrentSize, $Global_SortingGUI, $Global_SortingTotalSize ; Sorting GUI.
Global $Global_Timer, $Global_Action, $Global_Language, $Global_MainDir, $Global_DuplicateMode, $Global_Clipboard, $Global_Wheel, $Global_ScriptRefresh, $Global_ScriptRestart ; Misc.
Global $Global_DroppedFiles[1], $Global_OpenedArchives[1][2], $Global_OpenedLists[1][2], $Global_OpenedPlaylists[1][2], $Global_PriorityActions[1], $Global_NumberFields = 6 ; Misc.
Global $Global_ResizeWidth, $Global_ResizeHeight ; Windows Size For Resizing.
Global $Global_MultipleInstance = 0 ; Multiple Instances.
Global $Global_Slider, $Global_SliderLabel ; _Customize_GUI_Edit.
Global $Global_UniqueID = @ScriptFullPath ; WM_COPYDATA.
Global $Global_Encryption_Key = "profiles-password-fake" ; Key For Profiles Encryption.
Global $Global_Password_Key = "archives-password-fake" ; Key For Archives Encryption.
; <<<<< Variables >>>>>

__EnvironmentVariables() ; Set The Standard & User Assigned Environment Variables.
__ExpandEnvStrings(0) ; Disable The Expansion Of Environment Variables.

_Update_Complete() ; Message After DropIt Update.
__Password_GUI() ; Ask Password If In Encrypt Mode.
__Upgrade() ; Upgrade DropIt If Required.
__SingletonEx($Global_UniqueID) ; WM_COPYDATA.
_Update_Check() ; Check If DropIt Has Been Updated.

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

	$mNew = GUICtrlCreateButton(__Lang_Get('NEW', 'New'), 32, $mSize[1] - 31, 85, 25)
	GUICtrlSetTip($mNew, __Lang_Get('MANAGE_GUI_TIP_0', 'Click to add an association or Right-click associations to modify them.'))
	GUICtrlSetResizing($mNew, $GUI_DOCKSIZE + $GUI_DOCKLEFT + $GUI_DOCKBOTTOM)

	$mProfileCombo = GUICtrlCreateCombo("", 155, $mSize[1] - 29, $mSize[0] - 310, 24, 0x0003)
	$mProfileCombo_Handle = GUICtrlGetHandle($mProfileCombo)

	$Global_ListViewRules_ComboBox = $mProfileCombo_Handle

	GUICtrlSetData($mProfileCombo, __ProfileList_Combo(), $mProfile[1])
	GUICtrlSetTip($mProfileCombo, __Lang_Get('MANAGE_GUI_TIP_1', 'Select a Profile to change its associations.'))
	GUICtrlSetResizing($mProfileCombo, $GUI_DOCKSIZE + $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM)

	$mClose = GUICtrlCreateButton(__Lang_Get('CLOSE', 'Close'), $mSize[0] - 32 - 85, $mSize[1] - 31, 85, 25)
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
				_Manage_Delete($mListView_Handle, $mIndex_Selected, $mProfile[0], $mGUI) ; Delete Selected Association From Current Profile & ListView.

			Case $mEnterDummy, $mCopyToDummy
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
					$mProfileText = IniRead($mProfile[0], "Associations", $mProfileString, "") ; Profile INI Value [C:\Destination|Example|1<20MB;0>d;0>d;0>d|Disabled|0;1;2;3;11;13|Host;Port;User;Password].

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
					_Manage_Paste($mProfile[0], $mProfileString, $mProfileText, $mGUI)
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
	Local $mInput_Name, $mInput_NameRead, $mInput_Rules, $mInput_RulesRead, $mButton_Rules, $mButton_Filters, $mButton_Env, $mCombo_Action, $mInput_Ignore
	Local $mLabel_Destination, $mInput_Destination, $mInput_DestinationRead, $mButton_Destination, $mCombo_Delete, $mCombo_Clipboard, $mRename, $mInput_Rename
	Local $mSite, $mInput_Site, $mButton_Site, $mList, $mInput_List, $mButton_List, $mListName, $mListProperties, $mFileProperties, $mInput_Current
	Local $mInput_Change, $mButton_Change, $mSiteSettings, $mStringSplit

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
	Local $mInput_RuleData = $mFileExtension, $mCurrentAction = $mInitialAction, $mCurrentDelete = __Lang_Get('DELETE_MODE_1', 'Directly Remove'), $mCurrentClipboard = __Lang_Get('CLIPBOARD_MODE_1', 'File Path')
	Local $mCombo_ActionData = __Lang_Get('ACTION_MOVE', 'Move') & '|' & __Lang_Get('ACTION_COPY', 'Copy') & '|' & __Lang_Get('ACTION_COMPRESS', 'Compress') & '|' & __Lang_Get('ACTION_EXTRACT', 'Extract') & '|' & __Lang_Get('ACTION_RENAME', 'Rename') & '|' & __Lang_Get('ACTION_DELETE', 'Delete') & '|' & __Lang_Get('ACTION_UPLOAD', 'Upload') & '|' & __Lang_Get('ACTION_OPEN_WITH', 'Open With') & '|' & __Lang_Get('ACTION_LIST', 'Create List') & '|' & __Lang_Get('ACTION_PLAYLIST', 'Create Playlist') & '|' & __Lang_Get('ACTION_SHORTCUT', 'Create Shortcut') & '|' & __Lang_Get('ACTION_CLIPBOARD', 'Copy to Clipboard') & '|' & __Lang_Get('ACTION_CHANGE_PROPERTIES', 'Change Properties') & '|' & __Lang_Get('ACTION_IGNORE', 'Ignore')
	Local $mCombo_DeleteData = __Lang_Get('DELETE_MODE_1', 'Directly Remove') & '|' & __Lang_Get('DELETE_MODE_2', 'Safely Erase') & '|' & __Lang_Get('DELETE_MODE_3', 'Send to Recycle Bin')
	Local $mCombo_ClipboardData = __Lang_Get('CLIPBOARD_MODE_1', 'Full Path') & '|' & __Lang_Get('CLIPBOARD_MODE_2', 'File Name') & '|' & __Lang_Get('LIST_LABEL_7', 'MD5 Hash') & '|' & __Lang_Get('LIST_LABEL_8', 'SHA-1 Hash')

	Local $mDestination_Label[9] = [ _
			__Lang_Get('MANAGE_DESTINATION_FOLDER', 'Destination Folder') & ":", _
			__Lang_Get('MANAGE_DESTINATION_PROGRAM', 'Destination Program') & ":", _
			__Lang_Get('MANAGE_DESTINATION_FILE', 'Destination File') & ":", _
			__Lang_Get('MANAGE_DESTINATION_ARCHIVE', 'Destination Archive') & ":", _
			__Lang_Get('MANAGE_NEW_NAME', 'New Name') & ":", _
			__Lang_Get('MANAGE_DELETE_MODE', 'Deletion Mode') & ":", _
			__Lang_Get('MANAGE_CLIPBOARD_MODE', 'Clipboard Mode') & ":", _
			__Lang_Get('MANAGE_REMOTE_DESTINATION', 'Remote Destination') & ":", _
			__Lang_Get('MANAGE_NEW_PROPERTIES', 'New Properties') & ":"]

	If $mInitialAction == __Lang_Get('ACTION_RENAME', 'Rename') Then
		$mRename = $mDestination
		$mDestination = "-"
	Else
		$mRename = $mRename_Default
	EndIf
	If $mInitialAction == __Lang_Get('ACTION_CHANGE_PROPERTIES', 'Change Properties') Then
		$mFileProperties = __GetAssociationField($mProfile[0], $mInitialAction, $mInput_RuleData, 1)
		$mDestination = "-"
	Else
		$mFileProperties = "-"
	EndIf
	If $mInitialAction == __Lang_Get('ACTION_LIST', 'Create List') Then
		$mListProperties = __GetAssociationField($mProfile[0], $mInitialAction, $mInput_RuleData, 5)
		$mList = $mDestination
		$mDestination = "-"
	Else
		$mList = "-"
	EndIf
	If $mInitialAction == __Lang_Get('ACTION_UPLOAD', 'Upload') Then
		$mSiteSettings = __GetAssociationField($mProfile[0], $mInitialAction, $mInput_RuleData, 6)
		$mStringSplit = StringSplit($mSiteSettings, ";")
		$mSite = StringTrimLeft($mDestination, StringLen($mStringSplit[1]))
		$mDestination = "-"
	Else
		$mSite = "/"
	EndIf

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

	$mGUI = GUICreate($mAssociationType & " [" & __Lang_Get('PROFILE', 'Profile') & ": " & $mProfile[1] & "]", 480, 230, -1, -1, -1, BitOr($WS_EX_ACCEPTFILES, $WS_EX_TOOLWINDOW), __OnTop($mHandle))
	GUICtrlCreateLabel(__Lang_Get('NAME', 'Name') & ":", 15, 12, 260, 20)
	$mInput_Name = GUICtrlCreateInput($mFileName, 10, 31, 460, 22)
	GUICtrlSetTip($mInput_Name, __Lang_Get('MANAGE_EDIT_TIP_0', 'Choose a name for this association.'))

	GUICtrlCreateLabel(__Lang_Get('RULES', 'Rules') & ":", 15, 60 + 12, 260, 20)
	$mInput_Rules = GUICtrlCreateInput($mInput_RuleData, 10, 60 + 32, 378, 22)
	GUICtrlSetTip($mInput_Rules, __Lang_Get('MANAGE_EDIT_TIP_1', 'Write rules for this association.'))
	$mButton_Rules = GUICtrlCreateButton("i", 10 + 383, 60 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Rules, __Lang_Get('MANAGE_EDIT_MSGBOX_6', 'Supported Rules'))
	GUICtrlSetImage($mButton_Rules, @ScriptFullPath, -6, 0)
	$mButton_Filters = GUICtrlCreateButton("F", 10 + 424, 60 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Filters, __Lang_Get('ADDITIONAL_FILTERS', 'Additional Filters'))
	GUICtrlSetImage($mButton_Filters, @ScriptFullPath, -10, 0)

	GUICtrlCreateLabel(__Lang_Get('ACTION', 'Action') & ":", 15, 120 + 12, 135, 20)
	$mCombo_Action = GUICtrlCreateCombo("", 10, 120 + 32, 140, 22, 0x0003)
	$mLabel_Destination = GUICtrlCreateLabel($mDestination_Label[0], 15 + 145, 120 + 12, 220, 20)
	$mInput_Destination = GUICtrlCreateInput($mDestination, 10 + 145, 120 + 32, 233, 22)
	GUICtrlSetTip($mInput_Destination, __Lang_Get('MANAGE_EDIT_TIP_2', 'As destination are supported absolute, relative and UNC paths.'))
	GUICtrlSetState($mInput_Destination, $GUI_DROPACCEPTED)
	$mButton_Destination = GUICtrlCreateButton("S", 10 + 145 + 238, 120 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Destination, __Lang_Get('SEARCH', 'Search'))
	GUICtrlSetImage($mButton_Destination, @ScriptFullPath, -8, 0)
	$mInput_Site = GUICtrlCreateInput($mSite, 10 + 145, 120 + 32, 233, 22)
	GUICtrlSetTip($mInput_Site, __Lang_Get('MANAGE_EDIT_TIP_6', 'Define the remote destination directory.'))
	$mButton_Site = GUICtrlCreateButton("C", 10 + 145 + 238, 120 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Site, __Lang_Get('MANAGE_EDIT_MSGBOX_12', 'Configure'))
	GUICtrlSetImage($mButton_Site, @ScriptFullPath, -12, 0)
	$mInput_Rename = GUICtrlCreateInput($mRename, 10 + 145, 120 + 32, 274, 22)
	GUICtrlSetTip($mInput_Rename, __Lang_Get('MANAGE_EDIT_TIP_4', 'Write output name and extension.'))
	$mInput_List = GUICtrlCreateInput($mList, 10 + 145 + 40, 120 + 32, 193, 22)
	GUICtrlSetTip($mInput_List, __Lang_Get('MANAGE_EDIT_TIP_2', 'As destination are supported absolute, relative and UNC paths.'))
	$mButton_List = GUICtrlCreateButton("C", 10 + 145, 120 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_List, __Lang_Get('MANAGE_EDIT_MSGBOX_12', 'Configure'))
	GUICtrlSetImage($mButton_List, @ScriptFullPath, -12, 0)
	$mCombo_Delete = GUICtrlCreateCombo("", 10 + 145, 120 + 32, 315, 22, 0x0003)
	GUICtrlSetTip($mCombo_Delete, __Lang_Get('MANAGE_EDIT_TIP_5', 'Select the deletion mode for this association.'))
	$mCombo_Clipboard = GUICtrlCreateCombo("", 10 + 145, 120 + 32, 315, 22, 0x0003)
	GUICtrlSetTip($mCombo_Clipboard, __Lang_Get('MANAGE_EDIT_TIP_3', 'Select what copy to the Clipboard for this association.'))
	$mButton_Env = GUICtrlCreateButton("A", 10 + 145 + 279, 120 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Env, __Lang_Get('MANAGE_EDIT_MSGBOX_8', 'Abbreviations'))
	GUICtrlSetImage($mButton_Env, @ScriptFullPath, -11, 0)
	$mInput_Change = GUICtrlCreateInput(__Lang_Get('MANAGE_EDIT_MSGBOX_14', 'Configure the new properties'), 10 + 145 + 40, 120 + 32, 274, 22)
	$mButton_Change = GUICtrlCreateButton("C", 10 + 145, 120 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Change, __Lang_Get('MANAGE_EDIT_MSGBOX_12', 'Configure'))
	GUICtrlSetImage($mButton_Change, @ScriptFullPath, -12, 0)
	$mInput_Ignore = GUICtrlCreateInput(__Lang_Get('MANAGE_EDIT_MSGBOX_15', 'Skip them during process'), 10 + 145, 120 + 32, 315, 22)

	GUICtrlSetState($mInput_Ignore, $GUI_DISABLE + $GUI_HIDE) ; Always Disabled In The Code.
	GUICtrlSetState($mInput_Change, $GUI_DISABLE + $GUI_HIDE) ; Always Disabled In The Code.
	GUICtrlSetState($mButton_Change, $GUI_HIDE)
	GUICtrlSetState($mInput_Rename, $GUI_HIDE)
	GUICtrlSetState($mInput_Site, $GUI_HIDE)
	GUICtrlSetState($mButton_Site, $GUI_HIDE)
	GUICtrlSetState($mInput_List, $GUI_HIDE)
	GUICtrlSetState($mButton_List, $GUI_HIDE)
	GUICtrlSetState($mCombo_Delete, $GUI_HIDE)
	GUICtrlSetState($mCombo_Clipboard, $GUI_HIDE)
	Switch $mCurrentAction
		Case __Lang_Get('ACTION_IGNORE', 'Ignore')
			GUICtrlSetState($mInput_Ignore, $GUI_SHOW)
			GUICtrlSetState($mInput_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Env, $GUI_HIDE)
			GUICtrlSetData($mInput_Destination, "-")
			GUICtrlSetData($mLabel_Destination, "")
		Case __Lang_Get('ACTION_CHANGE_PROPERTIES', 'Change Properties')
			GUICtrlSetState($mInput_Change, $GUI_SHOW)
			GUICtrlSetState($mButton_Change, $GUI_SHOW)
			GUICtrlSetState($mInput_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Env, $GUI_HIDE)
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[8])
		Case __Lang_Get('ACTION_OPEN_WITH', 'Open With')
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[1])
		Case __Lang_Get('ACTION_PLAYLIST', 'Create Playlist')
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[2])
		Case __Lang_Get('ACTION_COMPRESS', 'Compress')
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[3])
		Case __Lang_Get('ACTION_LIST', 'Create List')
			GUICtrlSetState($mInput_Destination, $GUI_HIDE)
			GUICtrlSetState($mInput_List, $GUI_SHOW)
			GUICtrlSetState($mButton_List, $GUI_SHOW)
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[2])
		Case __Lang_Get('ACTION_RENAME', 'Rename')
			GUICtrlSetState($mInput_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Destination, $GUI_HIDE)
			GUICtrlSetState($mInput_Rename, $GUI_SHOW)
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[4])
		Case __Lang_Get('ACTION_UPLOAD', 'Upload')
			GUICtrlSetState($mInput_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Destination, $GUI_HIDE)
			GUICtrlSetState($mInput_Site, $GUI_SHOW)
			GUICtrlSetState($mButton_Site, $GUI_SHOW)
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[7])
		Case __Lang_Get('ACTION_DELETE', 'Delete')
			GUICtrlSetState($mInput_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Env, $GUI_HIDE)
			GUICtrlSetState($mCombo_Delete, $GUI_SHOW)
			$mCurrentDelete = $mDestination
			GUICtrlSetData($mInput_Destination, "-")
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[5])
		Case __Lang_Get('ACTION_CLIPBOARD', 'Copy to Clipboard')
			GUICtrlSetState($mInput_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Env, $GUI_HIDE)
			GUICtrlSetState($mCombo_Clipboard, $GUI_SHOW)
			$mCurrentClipboard = $mDestination
			GUICtrlSetData($mInput_Destination, "-")
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[6])
	EndSwitch
	GUICtrlSetData($mCombo_Action, $mCombo_ActionData, $mCurrentAction)
	GUICtrlSetData($mCombo_Delete, $mCombo_DeleteData, $mCurrentDelete)
	GUICtrlSetData($mCombo_Clipboard, $mCombo_ClipboardData, $mCurrentClipboard)

	$mSave = GUICtrlCreateButton(__Lang_Get('SAVE', 'Save'), 240 - 70 - 85, 195, 85, 26)
	$mAdd_Action = GUICtrlCreateButton("+", 240 - 18, 196, 36, 24, $BS_ICON)
	GUICtrlSetTip($mAdd_Action, __Lang_Get('?????', 'Add another action'))
	GUICtrlSetImage($mAdd_Action, @ScriptFullPath, -9, 0)
	GUICtrlSetState($mAdd_Action, $GUI_HIDE) ; <<<<<<<<<<< Temporarily Disabled.
	$mCancel = GUICtrlCreateButton(__Lang_Get('CANCEL', 'Cancel'), 240 + 70, 195, 85, 26)
	GUICtrlSetState($mSave, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)
	ControlClick($mGUI, "", $mInput_Name)

	While 1
		; Enable/Disable Destination Input And Switch Folder/Program Label:
		If GUICtrlRead($mCombo_Action) <> $mCurrentAction And _GUICtrlComboBox_GetDroppedState($mCombo_Action) = False Then
			GUICtrlSetState($mInput_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Env, $GUI_HIDE)
			GUICtrlSetState($mInput_Rename, $GUI_HIDE)
			GUICtrlSetState($mInput_Change, $GUI_HIDE)
			GUICtrlSetState($mButton_Change, $GUI_HIDE)
			GUICtrlSetState($mInput_Ignore, $GUI_HIDE)
			GUICtrlSetState($mInput_Site, $GUI_HIDE)
			GUICtrlSetState($mButton_Site, $GUI_HIDE)
			GUICtrlSetState($mInput_List, $GUI_HIDE)
			GUICtrlSetState($mButton_List, $GUI_HIDE)
			GUICtrlSetState($mCombo_Delete, $GUI_HIDE)
			GUICtrlSetState($mCombo_Clipboard, $GUI_HIDE)
			If GUICtrlRead($mInput_Destination) == "" Then
				GUICtrlSetData($mInput_Destination, "-")
			EndIf
			If GUICtrlRead($mInput_Rename) == "" Then
				GUICtrlSetData($mInput_Rename, $mRename_Default)
			EndIf
			If GUICtrlRead($mInput_Site) == "" Then
				GUICtrlSetData($mInput_Site, "/")
			EndIf
			If GUICtrlRead($mInput_List) == "" Then
				GUICtrlSetData($mInput_List, "-")
			EndIf
			If $mFileProperties = "" Then
				$mFileProperties = "-"
			EndIf
			$mCurrentAction = GUICtrlRead($mCombo_Action)
			Switch $mCurrentAction
				Case __Lang_Get('ACTION_DELETE', 'Delete')
					GUICtrlSetState($mCombo_Delete, $GUI_SHOW)
				Case __Lang_Get('ACTION_CLIPBOARD', 'Copy to Clipboard')
					GUICtrlSetState($mCombo_Clipboard, $GUI_SHOW)
				Case __Lang_Get('ACTION_IGNORE', 'Ignore')
					GUICtrlSetState($mInput_Ignore, $GUI_SHOW)
				Case __Lang_Get('ACTION_RENAME', 'Rename')
					GUICtrlSetState($mInput_Rename, $GUI_SHOW)
					GUICtrlSetState($mButton_Env, $GUI_SHOW)
				Case __Lang_Get('ACTION_UPLOAD', 'Upload')
					GUICtrlSetState($mInput_Site, $GUI_SHOW)
					GUICtrlSetState($mButton_Site, $GUI_SHOW)
					GUICtrlSetState($mButton_Env, $GUI_SHOW)
				Case __Lang_Get('ACTION_CHANGE_PROPERTIES', 'Change Properties')
					If $mFileProperties = "-" Then
						$mFileProperties = ""
					EndIf
					GUICtrlSetState($mInput_Change, $GUI_SHOW)
					GUICtrlSetState($mButton_Change, $GUI_SHOW)
				Case __Lang_Get('ACTION_LIST', 'Create List')
					If GUICtrlRead($mInput_List) == "-" Then
						GUICtrlSetData($mInput_List, "")
					EndIf
					GUICtrlSetState($mButton_Destination, $GUI_SHOW)
					GUICtrlSetState($mInput_List, $GUI_SHOW)
					GUICtrlSetState($mButton_List, $GUI_SHOW)
					GUICtrlSetState($mButton_Env, $GUI_SHOW)
				Case Else
					If GUICtrlRead($mInput_Destination) == "-" Then
						GUICtrlSetData($mInput_Destination, "")
					EndIf
					GUICtrlSetState($mInput_Destination, $GUI_SHOW)
					GUICtrlSetState($mButton_Destination, $GUI_SHOW)
					GUICtrlSetState($mButton_Env, $GUI_SHOW)
			EndSwitch
			Switch $mCurrentAction
				Case __Lang_Get('ACTION_IGNORE', 'Ignore')
					GUICtrlSetData($mLabel_Destination, "")
				Case __Lang_Get('ACTION_OPEN_WITH', 'Open With')
					GUICtrlSetData($mLabel_Destination, $mDestination_Label[1])
				Case __Lang_Get('ACTION_LIST', 'Create List'), __Lang_Get('ACTION_PLAYLIST', 'Create Playlist')
					GUICtrlSetData($mLabel_Destination, $mDestination_Label[2])
				Case __Lang_Get('ACTION_COMPRESS', 'Compress')
					GUICtrlSetData($mLabel_Destination, $mDestination_Label[3])
				Case __Lang_Get('ACTION_RENAME', 'Rename')
					GUICtrlSetData($mLabel_Destination, $mDestination_Label[4])
				Case __Lang_Get('ACTION_DELETE', 'Delete')
					GUICtrlSetData($mLabel_Destination, $mDestination_Label[5])
				Case __Lang_Get('ACTION_CLIPBOARD', 'Copy to Clipboard')
					GUICtrlSetData($mLabel_Destination, $mDestination_Label[6])
				Case __Lang_Get('ACTION_UPLOAD', 'Upload')
					GUICtrlSetData($mLabel_Destination, $mDestination_Label[7])
				Case __Lang_Get('ACTION_CHANGE_PROPERTIES', 'Change Properties')
					GUICtrlSetData($mLabel_Destination, $mDestination_Label[8])
				Case Else
					GUICtrlSetData($mLabel_Destination, $mDestination_Label[0])
			EndSwitch
		EndIf

		; Enable/Disable Save Button:
		If GUICtrlRead($mInput_Name) <> "" And GUICtrlRead($mInput_Rules) <> "" And $mFileProperties <> "" And __StringIsValid(GUICtrlRead($mInput_Destination)) And __StringIsValid(GUICtrlRead($mInput_Rename)) And __StringIsValid(GUICtrlRead($mInput_List)) And Not StringIsSpace(GUICtrlRead($mInput_Rules)) Then
			If GUICtrlGetState($mSave) > 80 Then
				GUICtrlSetState($mSave, 576) ; $GUI_ENABLE + $GUI_DEFBUTTON.
			EndIf
			If GUICtrlGetState($mCancel) = 512 Then
				GUICtrlSetState($mCancel, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
		ElseIf GUICtrlRead($mInput_Name) = "" Or GUICtrlRead($mInput_Rules) = "" Or $mFileProperties = "" Or __StringIsValid(GUICtrlRead($mInput_Destination)) = 0 Or __StringIsValid(GUICtrlRead($mInput_Rename)) = 0 Or __StringIsValid(GUICtrlRead($mInput_List)) = 0 Or StringIsSpace(GUICtrlRead($mInput_Rules)) Then
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

				If StringInStr($mInput_RulesRead, "*") = 0 And __Is("UseRegEx") = 0 Then ; Fix Rules Without * Characters.
					$mInput_RulesRead = "*" & $mInput_RulesRead
				EndIf

				Switch $mCurrentActionString
					Case "$4" ; Extract.
						If StringInStr($mInput_RulesRead, "**") And __Is("UseRegEx") = 0 Then
							MsgBox(0x30, __Lang_Get('MANAGE_EDIT_MSGBOX_4', 'Association Error'), __Lang_Get('MANAGE_EDIT_MSGBOX_11', 'You cannot use this action for folders.'), 0, __OnTop($mGUI))
							ContinueLoop
						EndIf
					Case "$5" ; Open With.
						If StringInStr($mInput_DestinationRead, "DropIt.exe") Then ; DropIt.exe Is Excluded To Avoid Loops.
							MsgBox(0x30, __Lang_Get('MANAGE_EDIT_MSGBOX_0', 'Destination Error'), __Lang_Get('MANAGE_EDIT_MSGBOX_1', 'You must specify a valid destination.'), 0, __OnTop($mGUI))
							ContinueLoop
						EndIf
					Case "$8" ; List.
						$mInput_DestinationRead = GUICtrlRead($mInput_List)
						If __IsValidFileType($mInput_DestinationRead, "html;htm;txt;csv;xml") = 0 Then
							MsgBox(0x30, __Lang_Get('MANAGE_EDIT_MSGBOX_0', 'Destination Error'), __Lang_Get('MANAGE_EDIT_MSGBOX_1', 'You must specify a valid destination.'), 0, __OnTop($mGUI))
							ContinueLoop
						EndIf
					Case "$3" ; Compress.
						If __IsValidFileType($mInput_DestinationRead, "zip;7z;exe") = 0 And StringInStr($mInput_DestinationRead, ".") Then
							MsgBox(0x30, __Lang_Get('MANAGE_EDIT_MSGBOX_0', 'Destination Error'), __Lang_Get('MANAGE_EDIT_MSGBOX_1', 'You must specify a valid destination.'), 0, __OnTop($mGUI))
							ContinueLoop
						EndIf
					Case "$9" ; Playlist.
						If StringInStr($mInput_RulesRead, "**") And __Is("UseRegEx") = 0 Then
							MsgBox(0x30, __Lang_Get('MANAGE_EDIT_MSGBOX_4', 'Association Error'), __Lang_Get('MANAGE_EDIT_MSGBOX_11', 'You cannot use this action for folders.'), 0, __OnTop($mGUI))
							ContinueLoop
						EndIf
						If __IsValidFileType($mInput_DestinationRead, "m3u;m3u8;pls;wpl") = 0 Then
							MsgBox(0x30, __Lang_Get('MANAGE_EDIT_MSGBOX_0', 'Destination Error'), __Lang_Get('MANAGE_EDIT_MSGBOX_1', 'You must specify a valid destination.'), 0, __OnTop($mGUI))
							ContinueLoop
						EndIf
					Case "$C" ; Upload.
						If $mSiteSettings = "" Then
							MsgBox(0x30, __Lang_Get('MANAGE_EDIT_MSGBOX_0', 'Destination Error'), __Lang_Get('MANAGE_EDIT_MSGBOX_13', 'You must configure the site destination.'), 0, __OnTop($mGUI))
							ContinueLoop
						EndIf
						$mInput_DestinationRead = GUICtrlRead($mInput_Site)
						If $mInput_DestinationRead = "" Or StringLeft($mInput_DestinationRead, 1) <> "/" Then
							$mInput_DestinationRead = "/" & $mInput_DestinationRead ; To Use Main Remote Directory As Destination.
						EndIf
					Case "$6" ; Delete.
						$mCurrentDelete = GUICtrlRead($mCombo_Delete)
						Switch $mCurrentDelete
							Case __Lang_Get('DELETE_MODE_2', 'Safely Erase')
								$mInput_DestinationRead = 2
							Case __Lang_Get('DELETE_MODE_3', 'Send to Recycle Bin')
								$mInput_DestinationRead = 3
							Case Else ; Directly Remove.
								$mInput_DestinationRead = 1
						EndSwitch
					Case "$B" ; Clipboard.
						$mCurrentClipboard = GUICtrlRead($mCombo_Clipboard)
						Switch $mCurrentClipboard
							Case __Lang_Get('CLIPBOARD_MODE_2', 'File Name')
								$mInput_DestinationRead = 2
							Case __Lang_Get('LIST_LABEL_7', 'MD5 Hash')
								$mInput_DestinationRead = 3
							Case __Lang_Get('LIST_LABEL_8', 'SHA-1 Hash')
								$mInput_DestinationRead = 4
							Case Else ; Full Path.
								$mInput_DestinationRead = 1
						EndSwitch
					Case "$7" ; Rename.
						$mInput_DestinationRead = GUICtrlRead($mInput_Rename)
					Case "$D" ; Change Properties.
						$mInput_DestinationRead = $mFileProperties
					Case "$2" ; Ignore.
						$mInput_DestinationRead = "-"
				EndSwitch

				If StringLeft($mInput_RulesRead, 1) = "[" Or StringInStr($mInput_RulesRead, "=") Then
					MsgBox(0x30, __Lang_Get('MANAGE_EDIT_MSGBOX_4', 'Association Error'), __Lang_Get('MANAGE_EDIT_MSGBOX_5', 'You cannot use "=" character in rules or start rules with "[" character.'), 0, __OnTop($mGUI))
				Else
					$mMsgBox = 6
					If IniRead($mProfile[0], "Associations", $mInput_RulesRead & $mCurrentActionString, "") <> "" Then
						If $mInput_RulesRead <> $mInput_RuleData Then
							$mMsgBox = MsgBox(0x4, __Lang_Get('MANAGE_EDIT_MSGBOX_2', 'Replace association'), __Lang_Get('MANAGE_EDIT_MSGBOX_3', 'This association already exists. Do you want to replace it?'), 0, __OnTop($mGUI))
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
						If $mCurrentActionString <> "$8" Then
							$mListProperties = ""
						ElseIf $mListProperties = "" Then
							$mListProperties = "0;1;2;3;11;13"
						EndIf
						$mInput_DestinationRead &= "|" & $mListProperties
						If $mCurrentActionString <> "$C" Then
							$mSiteSettings = ""
						EndIf
						$mInput_DestinationRead &= "|" & $mSiteSettings
						__IniWriteEx($mProfile[0], "Associations", $mInput_RulesRead & $mCurrentActionString, $mInput_DestinationRead)
						__Log_Write($mLogAssociation, $mInput_NameRead)
						$mChanged = 1
						ExitLoop
					EndIf
				EndIf

			Case $mButton_Rules
				MsgBox(0, __Lang_Get('MANAGE_EDIT_MSGBOX_6', 'Supported Rules'), __Lang_Get('MANAGE_EDIT_MSGBOX_7', 'Examples of supported rules for files:  @LF  *.jpg   = all files with "jpg" extension  @LF  penguin*.*   = all files that begin with "penguin"  @LF  *penguin*   = all files that contain "penguin"  @LF  C:\Folder\*.jpg   = all "jpg" files from "Folder"  @LF  @LF  Examples of supported rules for folders:  @LF  robot**   = all folders that begin with "robot"  @LF  **robot**   = all folders that contain "robot"  @LF  C:\**\robot   = all "robot" folders from a "C:" subfolder  @LF  @LF  Separate several rules in an association with ";" or "|"  @LF  to create multi-rule associations (e.g. *.jpg;*.png).'), 0, __OnTop($mGUI))

			Case $mButton_Filters
				$mFilters = _Manage_Filters($mFilters, $mGUI)

			Case $mButton_List
				$mListProperties = _Manage_List($mListProperties, $mGUI)

			Case $mButton_Site
				$mSiteSettings = _Manage_Site($mSiteSettings, $mGUI)

			Case $mButton_Change
				$mFileProperties = _Manage_Properties($mFileProperties, $mGUI) 

			Case $mButton_Destination
				$mInput_Current = $mInput_Destination
				If $mCurrentAction == __Lang_Get('ACTION_LIST', 'Create List') Then
					$mInput_Current = $mInput_List
				EndIf
				$mFolder = GUICtrlRead($mInput_Current)
				Switch $mCurrentAction
					Case __Lang_Get('ACTION_OPEN_WITH', 'Open With')
						$mFolder = FileOpenDialog(__Lang_Get('MANAGE_DESTINATION_PROGRAM_SELECT', 'Select a destination program:'), @DesktopDir, __Lang_Get('MANAGE_EDIT_MSGBOX_10', 'Executable or Script') & " (*.exe;*.bat;*.cmd;*.com;*.pif)", 1, "", $mGUI)
						If @error Then
							$mFolder = ""
						EndIf
					Case __Lang_Get('ACTION_LIST', 'Create List')
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
						$mListName = _WinAPI_GetSaveFileName(__Lang_Get('MANAGE_DESTINATION_FILE_SELECT', 'Choose a destination file:'), "HTML - " & __Lang_Get('MANAGE_DESTINATION_FORMAT_0', 'HyperText Markup Language file') & " (*.html;*.htm)|TXT - " & __Lang_Get('MANAGE_DESTINATION_FORMAT_1', 'Normal text file') & " (*.txt)|CSV - " & __Lang_Get('MANAGE_DESTINATION_FORMAT_2', 'Comma-Separated Values file') & " (*.csv)|XML - " & __Lang_Get('MANAGE_DESTINATION_FORMAT_3', 'eXtensible Markup Language file') & " (*.xml)", @DesktopDir, $mListName, "html", $mListType, 0, 0, $mGUI)
						If $mListName[0] = 2 Then
							If _WinAPI_PathIsDirectory($mListName[1]) Then
								$mFolder = $mListName[1] & "\" & $mListName[2]
							EndIf
						EndIf
					Case __Lang_Get('ACTION_COMPRESS', 'Compress')
						$mListName = $mFolder
						Switch __GetFileExtension($mFolder)
							Case "zip"
								$mListType = 1
							Case "7z"
								$mListType = 2
							Case "exe"
								$mListType = 3
							Case Else
								$mListType = 1
								$mListName = __Lang_Get('ARCHIVE', 'Archive')
						EndSwitch
						$mListName = _WinAPI_GetSaveFileName(__Lang_Get('MANAGE_DESTINATION_ARCHIVE_SELECT', 'Choose a destination archive:'), "ZIP - " & __Lang_Get('MANAGE_DESTINATION_FORMAT_4', 'Standard mainstream archive') & " (*.zip)|7Z - " & __Lang_Get('MANAGE_DESTINATION_FORMAT_5', 'High compression ratio archive') & " (*.7z)|EXE - " & __Lang_Get('MANAGE_DESTINATION_FORMAT_6', 'Self-extracting archive') & " (*.exe)", @DesktopDir, $mListName, "zip", $mListType, 0, 0, $mGUI)
						If $mListName[0] = 2 Then
							If _WinAPI_PathIsDirectory($mListName[1]) Then
								$mFolder = $mListName[1] & "\" & $mListName[2]
							EndIf
						EndIf
					Case __Lang_Get('ACTION_PLAYLIST', 'Create Playlist')
						$mListName = $mFolder
						Switch __GetFileExtension($mFolder)
							Case "m3u"
								$mListType = 1
							Case "m3u8"
								$mListType = 2
							Case "pls"
								$mListType = 3
							Case "wpl"
								$mListType = 4
							Case Else
								$mListType = 1
								$mListName = __Lang_Get('PLAYLIST', 'Playlist')
						EndSwitch
						$mListName = _WinAPI_GetSaveFileName(__Lang_Get('MANAGE_DESTINATION_FILE_SELECT', 'Choose a destination file:'), "M3U - " & __Lang_Get('MANAGE_DESTINATION_FORMAT_7', 'M3U playlist file') & " (*.m3u)|M3U8 - " & __Lang_Get('MANAGE_DESTINATION_FORMAT_8', 'Unicode M3U playlist file') & " (*.m3u8)|PLS - " & __Lang_Get('MANAGE_DESTINATION_FORMAT_9', 'Standard playlist file') & " (*.pls)|WPL - " & __Lang_Get('MANAGE_DESTINATION_FORMAT_10', 'Windows playlist file') & " (*.wpl)", @DesktopDir, $mListName, "m3u", $mListType, 0, 0, $mGUI)
						If $mListName[0] = 2 Then
							If _WinAPI_PathIsDirectory($mListName[1]) Then
								$mFolder = $mListName[1] & "\" & $mListName[2]
							EndIf
						EndIf
					Case Else
						$mFolder = FileSelectFolder(__Lang_Get('MANAGE_DESTINATION_FOLDER_SELECT', 'Select a destination folder:'), "", 3, $mFolder, $mGUI)
						$mFolder = _WinAPI_PathRemoveBackslash($mFolder)
				EndSwitch
				If $mFolder <> "" Then
					GUICtrlSetData($mInput_Current, $mFolder)
				EndIf

			Case $mButton_Env
				$mEnvVar = _GUICtrlListView_ContextMenu_EnvVars($mButton_Env, $mProfile[1], $mCurrentAction, $mGUI)
				If $mEnvVar <> -1 Then
					Switch $mCurrentAction
						Case __Lang_Get('ACTION_RENAME', 'Rename')
							__InsertText($mInput_Rename, "%" & $mEnvVar & "%")
						Case __Lang_Get('ACTION_UPLOAD', 'Upload')
							__InsertText($mInput_Site, "%" & $mEnvVar & "%")
						Case __Lang_Get('ACTION_LIST', 'Create List')
							__InsertText($mInput_List, "%" & $mEnvVar & "%")
						Case Else
							__InsertText($mInput_Destination, "%" & $mEnvVar & "%")
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

Func _Manage_Delete($mListView, $mIndex, $mProfile, $mHandle = -1)
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
		$mMsgBox = MsgBox(0x4, __Lang_Get('MANAGE_DELETE_MSGBOX_0', 'Delete association'), __Lang_Get('MANAGE_DELETE_MSGBOX_1', 'Selected association:') & "  " & $mAssociation & @LF & __Lang_Get('MANAGE_DELETE_MSGBOX_2', 'Are you sure to delete this association?'), 0, __OnTop($mHandle))
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

Func _Manage_Paste($mProfilePath, $mProfileString, $mProfileText, $mHandle = -1)
	Local $mMsgBox = 6

	If IniRead($mProfilePath, "Associations", $mProfileString, "") <> "" Then ; Association Already Exists.
		$mMsgBox = MsgBox(0x4, __Lang_Get('MANAGE_EDIT_MSGBOX_2', 'Replace association'), __Lang_Get('MANAGE_EDIT_MSGBOX_3', 'This association already exists. Do you want to replace it?'), 0, __OnTop($mHandle))
	EndIf
	If $mMsgBox = 6 Then
		__IniWriteEx($mProfilePath, "Associations", $mProfileString, $mProfileText) ; Add Association To New Profile.
		Return 1
	EndIf

	Return 0
EndFunc   ;==>_Manage_Paste

Func _Manage_Update($mListView, $mProfileName)
	Local $mAssociations, $mFileRules_Association, $mFileRules_Shown, $mAction, $mStringSplit

	$mAssociations = __GetAssociations($mProfileName) ; Get Associations Array For The Current Profile.

	_GUICtrlListView_BeginUpdate($mListView)
	_GUICtrlListView_DeleteAllItems($mListView)
	For $A = 1 To $mAssociations[0][0]
		$mFileRules_Association = $mAssociations[$A][0]
		$mFileRules_Shown = StringTrimRight($mFileRules_Association, 2)
		$mAction = StringRight($mFileRules_Association, 2)

		If $mAction == "$6" Then
			Switch $mAssociations[$A][1] ; Destination.
				Case 2
					$mAssociations[$A][1] = __Lang_Get('DELETE_MODE_2', 'Safely Erase')
				Case 3
					$mAssociations[$A][1] = __Lang_Get('DELETE_MODE_3', 'Send to Recycle Bin')
				Case Else
					$mAssociations[$A][1] = __Lang_Get('DELETE_MODE_1', 'Directly Remove')
			EndSwitch
		ElseIf $mAction == "$B" Then
			Switch $mAssociations[$A][1] ; Destination.
				Case 2
					$mAssociations[$A][1] = __Lang_Get('CLIPBOARD_MODE_2', 'File Name')
				Case 3
					$mAssociations[$A][1] = __Lang_Get('LIST_LABEL_7', 'MD5 Hash')
				Case 4
					$mAssociations[$A][1] = __Lang_Get('LIST_LABEL_8', 'SHA-1 Hash')
				Case Else
					$mAssociations[$A][1] = __Lang_Get('CLIPBOARD_MODE_1', 'Full Path')
			EndSwitch
		ElseIf $mAction == "$C" Then
			$mStringSplit = StringSplit($mAssociations[$A][6], ";")
			$mAssociations[$A][1] = $mStringSplit[1] & $mAssociations[$A][1]
		ElseIf $mAction == "$D" Then
			$mAssociations[$A][1] = __Lang_Get('CHANGE_PROPERTIES_DEFINED', 'Defined Properties')
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

Func _Manage_ExtractFilters($mProfile, $mAssociation, $mAction)
	Local $mAssociationSplit, $mStringSplit, $mFilters[4][4], $mNumberFields = $Global_NumberFields

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

Func _Manage_Filters($mFilters, $mHandle = -1)
	Local $mGUI, $mSave, $mCancel, $mState, $mText, $mGUI_Items[4][4]
	Local $mCheckText[4] = [__Lang_Get('SIZE', 'Size'), __Lang_Get('DATE_CREATED', 'Date Created'), __Lang_Get('DATE_MODIFIED', 'Date Modified'), __Lang_Get('DATE_OPENED', 'Date Opened')]

	$mGUI = GUICreate(__Lang_Get('ADDITIONAL_FILTERS', 'Additional Filters'), 370, 180, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	For $A = 0 To 3
		$mGUI_Items[$A][0] = GUICtrlCreateCheckbox($mCheckText[$A] & ":", 10, 16 + (30 * $A), 150, 20)
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
					$mText = __Lang_Get('TIME_SECONDS', 'Seconds')
				Case "n"
					$mText = __Lang_Get('TIME_MINUTES', 'Minutes')
				Case "h"
					$mText = __Lang_Get('TIME_HOURS', 'Hours')
				Case "m"
					$mText = __Lang_Get('TIME_MONTHS', 'Months')
				Case "y"
					$mText = __Lang_Get('TIME_YEARS', 'Years')
				Case Else
					$mText = __Lang_Get('TIME_DAYS', 'Days')
			EndSwitch
			GUICtrlSetData($mGUI_Items[$A][3], __Lang_Get('TIME_SECONDS', 'Seconds') & "|" & __Lang_Get('TIME_MINUTES', 'Minutes') & "|" & __Lang_Get('TIME_HOURS', 'Hours') & "|" & __Lang_Get('TIME_DAYS', 'Days') & "|" & __Lang_Get('TIME_MONTHS', 'Months') & "|" & __Lang_Get('TIME_YEARS', 'Years'), $mText)
		EndIf

		$mState = $GUI_DISABLE
		If GUICtrlRead($mGUI_Items[$A][0]) = 1 Then
			$mState = $GUI_ENABLE
		EndIf
		For $B = 1 To 3
			GUICtrlSetState($mGUI_Items[$A][$B], $mState)
		Next
	Next

	$mSave = GUICtrlCreateButton(__Lang_Get('OK', 'OK'), 185 - 40 - 85, 145, 85, 24)
	$mCancel = GUICtrlCreateButton(__Lang_Get('CANCEL', 'Cancel'), 185 + 40, 145, 85, 24)
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
							Case __Lang_Get('TIME_SECONDS', 'Seconds')
								$mState = "s"
							Case __Lang_Get('TIME_MINUTES', 'Minutes')
								$mState = "n"
							Case __Lang_Get('TIME_HOURS', 'Hours')
								$mState = "h"
							Case __Lang_Get('TIME_MONTHS', 'Months')
								$mState = "m"
							Case __Lang_Get('TIME_YEARS', 'Years')
								$mState = "y"
							Case Else ; Days.
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

Func _Manage_List($mProperties, $mHandle = -1)
	Local $mGUI, $mAdd, $mRemove, $mUp, $mDown, $mSave, $mCancel, $mNumberProperties = 32
	Local $mList_Available, $mList_Listed, $mIndex, $mString, $mStringSplit, $mNewProperties

	$mGUI = GUICreate(__Lang_Get('LIST_SELECT_0', 'Select Properties'), 370, 240, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))
	GUICtrlCreateLabel(__Lang_Get('LIST_SELECT_1', 'Available Properties') & ":", 15, 10, 140, 20)
	GUICtrlCreateLabel(__Lang_Get('LIST_SELECT_2', 'Used Properties') & ":", 15 + 205, 10, 140, 20)
	$mList_Available = GUICtrlCreateList("", 10, 30, 150, 170, 0x00210000) ; $LBS_NOTIFY + $WS_VSCROLL.
	$mList_Listed = GUICtrlCreateList("", 10 + 200, 30, 150, 170, 0x00210000) ; $LBS_NOTIFY + $WS_VSCROLL.

	If $mProperties = "" Then
		$mStringSplit = StringSplit("0;1;2;3;11;13", ";")
	Else
		$mStringSplit = StringSplit($mProperties, ";")
	EndIf
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

	$mSave = GUICtrlCreateButton(__Lang_Get('OK', 'OK'), 185 - 40 - 85, 205, 85, 24)
	$mCancel = GUICtrlCreateButton(__Lang_Get('CANCEL', 'Cancel'), 185 + 40, 205, 85, 24)
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

Func _Manage_Properties($mProperties, $mHandle = -1)
	Local $mGUI, $mSave, $mCancel, $mStringSplit, $mState, $mText, $B, $mDates[3][8], $mAttributes[5][2]
	Local $mTitles[8] = [__Lang_Get('ENV_VAR_TAB_6', 'Created'), __Lang_Get('ENV_VAR_TAB_7', 'Modified'), __Lang_Get('ENV_VAR_TAB_8', 'Opened'), __Lang_Get('CHANGE_PROPERTIES_ATTRIBUTE_0', 'Archive'), __Lang_Get('CHANGE_PROPERTIES_ATTRIBUTE_1', 'Hidden'), __Lang_Get('CHANGE_PROPERTIES_ATTRIBUTE_2', 'Read-Only'), __Lang_Get('CHANGE_PROPERTIES_ATTRIBUTE_3', 'System'), __Lang_Get('CHANGE_PROPERTIES_ATTRIBUTE_4', 'Temporary')]
	Local $mCombo[4] = [__Lang_Get('CHANGE_PROPERTIES_MODE_0', 'No Change'), __Lang_Get('CHANGE_PROPERTIES_MODE_1', 'Turn On'), __Lang_Get('CHANGE_PROPERTIES_MODE_2', 'Turn Off'), __Lang_Get('CHANGE_PROPERTIES_MODE_3', 'Switch')]

	$mStringSplit = StringSplit($mProperties, ";") ; {modified} YYYYMMDD;HHMMSS;0d; {created} YYYYMMDD;HHMMSS;0d; {opened} YYYYMMDD;HHMMSS;0d; {attributes} A0;H0;R0;S0;T0
	ReDim $mStringSplit[15] ; Number Of Settings.

	$mGUI = GUICreate(__Lang_Get('CHANGE_PROPERTIES', 'Configure Properties'), 600, 280, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	GUICtrlCreateGroup(__Lang_Get('CHANGE_PROPERTIES_LABEL_0', 'Date and Time'), 10, 10, 580, 110)
	For $A = 0 To 2
		$B = 3 * $A + 1
		GUICtrlCreateLabel($mTitles[$A] & ":", 19, 30 + (30 * $A), 90, 20)
		$mDates[$A][0] = GUICtrlCreateCheckbox("", 110, 28 + (30 * $A), 18, 20)
		$mText = StringRegExpReplace($mStringSplit[$B], "(\d{4})(\d{2})(\d{2})", "$1/$2/$3")
		$mDates[$A][1] = GUICtrlCreateDate($mText, 110 + 20, 27 + (30 * $A), 100, 22, $DTS_SHORTDATEFORMAT)
		If $mText <> "" Then
			GUICtrlSetState($mDates[$A][0], $GUI_CHECKED)
		Else
			GUICtrlSetState($mDates[$A][1], $GUI_DISABLE)
		EndIf

		$mDates[$A][2] = GUICtrlCreateCheckbox("", 110 + 140, 28 + (30 * $A), 18, 20)
		$mText = StringRegExpReplace($mStringSplit[$B + 1], "(\d{2})(\d{2})(\d{2})", "$1:$2:$3")
		$mDates[$A][3] = GUICtrlCreateDate($mText, 110 + 140 + 20, 27 + (30 * $A), 75, 22, $DTS_TIMEFORMAT)
		If $mText <> "" Then
			GUICtrlSetState($mDates[$A][2], $GUI_CHECKED)
		Else
			GUICtrlSetState($mDates[$A][3], $GUI_DISABLE)
		EndIf

		$mDates[$A][4] = GUICtrlCreateCheckbox("", 110 + 255, 28 + (30 * $A), 18, 20)
		$mDates[$A][5] = GUICtrlCreateCombo("", 110 + 255 + 20, 27 + (30 * $A), 30, 22, 0x0003)
		$mText = "+"
		If StringInStr($mStringSplit[$B + 2], "-") Then
			$mText = "-"
		EndIf
		GUICtrlSetData($mDates[$A][5], "+|-", $mText)
		$mText = StringRegExpReplace($mStringSplit[$B + 2], "[^0-9]", "")
		$mDates[$A][6] = GUICtrlCreateInput($mText, 110 + 255 + 55, 27 + (30 * $A), 55, 22, 0x2000)
		$mDates[$A][7] = GUICtrlCreateCombo("", 110 + 255 + 115, 27 + (30 * $A), 100, 22, 0x0003)
		Switch StringRight($mStringSplit[$B + 2], 1)
			Case "s"
				$mText = __Lang_Get('TIME_SECONDS', 'Seconds')
			Case "n"
				$mText = __Lang_Get('TIME_MINUTES', 'Minutes')
			Case "h"
				$mText = __Lang_Get('TIME_HOURS', 'Hours')
			Case "m"
				$mText = __Lang_Get('TIME_MONTHS', 'Months')
			Case "y"
				$mText = __Lang_Get('TIME_YEARS', 'Years')
			Case Else
				$mText = __Lang_Get('TIME_DAYS', 'Days')
		EndSwitch
		GUICtrlSetData($mDates[$A][7], __Lang_Get('TIME_SECONDS', 'Seconds') & "|" & __Lang_Get('TIME_MINUTES', 'Minutes') & "|" & __Lang_Get('TIME_HOURS', 'Hours') & "|" & __Lang_Get('TIME_DAYS', 'Days') & "|" & __Lang_Get('TIME_MONTHS', 'Months') & "|" & __Lang_Get('TIME_YEARS', 'Years'), $mText)
		If GUICtrlRead($mDates[$A][6]) <> "" Then
			GUICtrlSetState($mDates[$A][4], $GUI_CHECKED)
		Else
			GUICtrlSetState($mDates[$A][5], $GUI_DISABLE)
			GUICtrlSetState($mDates[$A][6], $GUI_DISABLE)
			GUICtrlSetState($mDates[$A][7], $GUI_DISABLE)
		EndIf
	Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__Lang_Get('CHANGE_PROPERTIES_LABEL_1', 'Attributes'), 10, 125, 580, 110)
	GUICtrlCreateLabel($mTitles[3] & ":", 19, 145, 90, 20)
	$mAttributes[0][0] = GUICtrlCreateCombo("", 110, 142, 130, 22, 0x0003)
	$mAttributes[0][1] = "A"
	GUICtrlCreateLabel($mTitles[4] & ":", 19 + 300, 145, 90, 20)
	$mAttributes[1][0] = GUICtrlCreateCombo("", 110 + 300, 142, 130, 22, 0x0003)
	$mAttributes[1][1] = "H"
	GUICtrlCreateLabel($mTitles[5] & ":", 19, 145 + 30, 90, 20)
	$mAttributes[2][0] = GUICtrlCreateCombo("", 110, 142 + 30, 130, 22, 0x0003)
	$mAttributes[2][1] = "R"
	GUICtrlCreateLabel($mTitles[6] & ":", 19 + 300, 145 + 30, 90, 20)
	$mAttributes[3][0] = GUICtrlCreateCombo("", 110 + 300, 142 + 30, 130, 22, 0x0003)
	$mAttributes[3][1] = "S"
	GUICtrlCreateLabel($mTitles[7] & ":", 19, 145 + 60, 90, 20)
	$mAttributes[4][0] = GUICtrlCreateCombo("", 110, 142 + 60, 130, 22, 0x0003)
	$mAttributes[4][1] = "T"
	For $A = 0 To 4
		Switch Number(StringRight($mStringSplit[$A + 10], 1))
			Case 1
				$mText = __Lang_Get('CHANGE_PROPERTIES_MODE_1', 'Turn On')
			Case 2
				$mText = __Lang_Get('CHANGE_PROPERTIES_MODE_2', 'Turn Off')
			Case 3
				$mText = __Lang_Get('CHANGE_PROPERTIES_MODE_3', 'Switch')
			Case Else
				$mText = __Lang_Get('CHANGE_PROPERTIES_MODE_0', 'No Change')
		EndSwitch
		GUICtrlSetData($mAttributes[$A][0], $mCombo[0] & "|" & $mCombo[1] & "|" & $mCombo[2] & "|" & $mCombo[3], $mText)
	Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$mSave = GUICtrlCreateButton(__Lang_Get('OK', 'OK'), 300 - 70 - 85, 245, 85, 24)
	$mCancel = GUICtrlCreateButton(__Lang_Get('CANCEL', 'Cancel'), 300 + 70, 245, 85, 24)
	GUICtrlSetState($mSave, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $mCancel
				ExitLoop

			Case $mDates[0][0], $mDates[0][2], $mDates[0][4], $mDates[1][0], $mDates[1][2], $mDates[1][4], $mDates[2][0], $mDates[2][2], $mDates[2][4]
				For $A = 0 To 2
					$mState = $GUI_DISABLE
					If GUICtrlRead($mDates[$A][0]) = 1 Then
						$mState = $GUI_ENABLE
					EndIf
					GUICtrlSetState($mDates[$A][1], $mState)

					$mState = $GUI_DISABLE
					If GUICtrlRead($mDates[$A][2]) = 1 Then
						$mState = $GUI_ENABLE
					EndIf
					GUICtrlSetState($mDates[$A][3], $mState)

					$mState = $GUI_DISABLE
					If GUICtrlRead($mDates[$A][4]) = 1 Then
						$mState = $GUI_ENABLE
					EndIf
					GUICtrlSetState($mDates[$A][5], $mState)
					GUICtrlSetState($mDates[$A][6], $mState)
					GUICtrlSetState($mDates[$A][7], $mState)
				Next

			Case $mSave
				$mProperties = ""
				For $A = 0 To 2
					If GUICtrlRead($mDates[$A][0]) = 1 Then
						$mProperties &= StringRegExpReplace(GUICtrlRead($mDates[$A][1]), "(\d{2})/(\d{2})/(\d{4})", "$3$2$1")
					EndIf
					$mProperties &= ";"

					If GUICtrlRead($mDates[$A][2]) = 1 Then
						$mProperties &= StringRegExpReplace(GUICtrlRead($mDates[$A][3]), "[^0-9]", "")
					EndIf
					$mProperties &= ";"

					If GUICtrlRead($mDates[$A][4]) = 1 And GUICtrlRead($mDates[$A][6]) <> "" Then
						$mText = ""
						If GUICtrlRead($mDates[$A][5]) = "-" Then
							$mText = "-"
						EndIf
						Switch GUICtrlRead($mDates[$A][7])
							Case __Lang_Get('TIME_SECONDS', 'Seconds')
								$mState = "s"
							Case __Lang_Get('TIME_MINUTES', 'Minutes')
								$mState = "n"
							Case __Lang_Get('TIME_HOURS', 'Hours')
								$mState = "h"
							Case __Lang_Get('TIME_MONTHS', 'Months')
								$mState = "m"
							Case __Lang_Get('TIME_YEARS', 'Years')
								$mState = "y"
							Case Else ; Days.
								$mState = "d"
						EndSwitch
						$mProperties &= $mText & GUICtrlRead($mDates[$A][6]) & $mState
					EndIf
					$mProperties &= ";"
				Next

				For $A = 0 To 4
					Switch GUICtrlRead($mAttributes[$A][0])
						Case __Lang_Get('CHANGE_PROPERTIES_MODE_1', 'Turn On')
							$mText = 1
						Case __Lang_Get('CHANGE_PROPERTIES_MODE_2', 'Turn Off')
							$mText = 2
						Case __Lang_Get('CHANGE_PROPERTIES_MODE_3', 'Switch')
							$mText = 3
						Case Else ; No Change.
							$mText = 0
					EndSwitch
					$mProperties &= $mAttributes[$A][1] & $mText & ";"
				Next
				$mProperties = StringTrimRight($mProperties, 1)
				ExitLoop
		EndSwitch
	WEnd
	GUIDelete($mGUI)

	Return $mProperties
EndFunc   ;==>_Manage_Properties

Func _Manage_Site($mSettings, $mHandle = -1)
	Local $mGUI, $mSave, $mCancel, $mStringSplit, $mPassword, $mPassword_Code = $Global_Password_Key
	Local $mInput_Host, $mInput_Port, $mInput_User, $mInput_Password, $mCombo_Protocol, $mCurrentProtocol
	Local $mString_FTP = "FTP - File Transfer Protocol", $mString_SFTP = "SFTP - SSH File Transfer Protocol"

	$mStringSplit = StringSplit($mSettings, ";")
	ReDim $mStringSplit[6] ; Number Of Settings.
	If $mStringSplit[5] = "SFTP" Then
		$mCurrentProtocol = $mString_SFTP
		If $mStringSplit[2] = "" Then
			$mStringSplit[2] = 22
		EndIf
	Else
		$mCurrentProtocol = $mString_FTP
		If $mStringSplit[2] = "" Then
			$mStringSplit[2] = 21
		EndIf
	EndIf
	If $mStringSplit[4] <> "" Then
		$mStringSplit[4] = _StringEncrypt(0, $mStringSplit[4], $mPassword_Code)
	EndIf

	$mGUI = GUICreate(__Lang_Get('SITE_CONFIGURE', 'Configure Site'), 360, 205, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	GUICtrlCreateLabel(__Lang_Get('SITE_LABEL_0', 'Host') & ":", 15, 12, 200, 20)
	$mInput_Host = GUICtrlCreateInput($mStringSplit[1], 10, 30, 250, 22)
	GUICtrlCreateLabel(__Lang_Get('SITE_LABEL_1', 'Port') & ":", 15 + 260, 12, 80, 20)
	$mInput_Port = GUICtrlCreateInput($mStringSplit[2], 10 + 260, 30, 80, 22, 0x2000)
	GUICtrlSetTip($mInput_Port, __Lang_Get('SITE_TIP_0', 'Leave empty to use the default port.'))
	GUICtrlCreateLabel(__Lang_Get('SITE_LABEL_2', 'User') & ":", 15, 12 + 50, 200, 20)
	$mInput_User = GUICtrlCreateInput($mStringSplit[3], 10, 30 + 50, 165, 22)
	GUICtrlSetTip($mInput_User, __Lang_Get('SITE_TIP_1', 'Leave empty to connect as anonymous.'))
	GUICtrlCreateLabel(__Lang_Get('SITE_LABEL_3', 'Password') & ":", 15 + 175, 12 + 50, 200, 20)
	$mInput_Password = GUICtrlCreateInput($mStringSplit[4], 10 + 175, 30 + 50, 165, 22, 0x0020)
	GUICtrlSetTip($mInput_Password, __Lang_Get('SITE_TIP_2', 'Leave empty if not required.'))
	GUICtrlCreateLabel(__Lang_Get('SITE_LABEL_4', 'Protocol') & ":", 15, 12 + 100, 200, 20)
	$mCombo_Protocol = GUICtrlCreateCombo("", 10, 30 + 100, 340, 22, 0x0003)
	GUICtrlSetData($mCombo_Protocol, $mString_FTP & "|" & $mString_SFTP, $mCurrentProtocol)

	$mSave = GUICtrlCreateButton(__Lang_Get('OK', 'OK'), 180 - 40 - 85, 170, 85, 24)
	$mCancel = GUICtrlCreateButton(__Lang_Get('CANCEL', 'Cancel'), 180 + 40, 170, 85, 24)
	GUICtrlSetState($mSave, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)

	While 1
		; Enable/Disable Save Button:
		If GUICtrlRead($mInput_Host) <> "" Then
			If GUICtrlGetState($mSave) > 80 Then
				GUICtrlSetState($mSave, 576) ; $GUI_ENABLE + $GUI_DEFBUTTON.
			EndIf
			If GUICtrlGetState($mCancel) = 512 Then
				GUICtrlSetState($mCancel, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
		ElseIf GUICtrlRead($mInput_Host) = "" Then
			If GUICtrlGetState($mSave) = 80 Then
				GUICtrlSetState($mSave, 144) ; $GUI_DISABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($mCancel) = 80 Then
				GUICtrlSetState($mCancel, 512) ; $GUI_DEFBUTTON.
			EndIf
		EndIf

		; Update Default Port If Protocol Changes:
		If GUICtrlRead($mCombo_Protocol) <> $mCurrentProtocol And Not _GUICtrlComboBox_GetDroppedState($mCombo_Protocol) Then
			$mCurrentProtocol = GUICtrlRead($mCombo_Protocol)
			If $mCurrentProtocol = $mString_SFTP And GUICtrlRead($mInput_Port) = 21 Then
				GUICtrlSetData($mInput_Port, 22)
			ElseIf $mCurrentProtocol = $mString_FTP And GUICtrlRead($mInput_Port) = 22 Then
				GUICtrlSetData($mInput_Port, 21)
			EndIf
		EndIf

		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $mCancel
				ExitLoop

			Case $mSave
				If StringRight(GUICtrlRead($mInput_Host), 1) = "/" Then
					GUICtrlSetData($mInput_Host, StringTrimRight(GUICtrlRead($mInput_Host), 1))
				EndIf
				$mPassword = ""
				If StringIsSpace(GUICtrlRead($mInput_Password)) = 0 And GUICtrlRead($mInput_Password) <> "" Then
					$mPassword = _StringEncrypt(1, GUICtrlRead($mInput_Password), $mPassword_Code)
				EndIf
				$mSettings = GUICtrlRead($mInput_Host) & ";" & GUICtrlRead($mInput_Port) & ";" & GUICtrlRead($mInput_User) & ";" & $mPassword & ";"
				If GUICtrlRead($mCombo_Protocol) = $mString_SFTP Then
					$mSettings &= "SFTP"
				Else
					$mSettings &= "FTP"
				EndIf
				ExitLoop
		EndSwitch
	WEnd
	GUIDelete($mGUI)

	Return $mSettings
EndFunc   ;==>_Manage_Site

Func _Manage_AddCustomVar($mMenuItem, $mCustomItem, $mNoCustom, $mINI, $mHandle = -1)
	Local $mGUI, $mAdd, $mClose, $mMsgBox, $mInput_EnvVar, $mEnvVar, $mInput_Text, $mText

	$mGUI = GUICreate(__Lang_Get('ENV_VAR_MSGBOX_0', 'Add Abbreviation'), 360, 105, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	GUICtrlCreateLabel(__Lang_Get('ENV_VAR_MSGBOX_2', 'Variable') & ":", 15, 12, 110, 20)
	$mInput_EnvVar = GUICtrlCreateInput("", 10, 31, 120, 22)
	GUICtrlCreateLabel(__Lang_Get('ENV_VAR_MSGBOX_3', 'String to abbreviate') & ":", 15 + 130, 12, 200, 20)
	$mInput_Text = GUICtrlCreateInput("", 10 + 130, 31, 210, 22)

	$mAdd = GUICtrlCreateButton(__Lang_Get('OPTIONS_BUTTON_4', 'Add'), 180 - 30 - 85, 70, 80, 24)
	$mClose = GUICtrlCreateButton(__Lang_Get('CLOSE', 'Close'), 180 + 30, 70, 80, 24)
	GUICtrlSetState($mClose, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $mClose
				ExitLoop

			Case $mAdd
				$mEnvVar = GUICtrlRead($mInput_EnvVar)
				$mText = GUICtrlRead($mInput_Text)
				If StringIsSpace($mEnvVar) <> 0 Or $mEnvVar = "" Or $mText = "" Then
					ContinueLoop
				EndIf
				For $A = 1 To $mMenuItem[0][0]
					If $mEnvVar = $mMenuItem[$A][1] Then
						MsgBox(0x30, __Lang_Get('ENV_VAR_MSGBOX_4', 'Abbreviation Error'), __Lang_Get('ENV_VAR_MSGBOX_5', 'This variable already exists and cannot be replaced.'), 0, __OnTop($mGUI))
					EndIf
				Next
				If $mNoCustom <> 1 Then
					For $A = 1 To $mCustomItem[0][0]
						If $mEnvVar = $mCustomItem[$A][0] Then
							$mMsgBox = MsgBox(0x4, __Lang_Get('ENV_VAR_MSGBOX_6', 'Replace Abbreviation'), __Lang_Get('ENV_VAR_MSGBOX_7', 'This variable already exists. Do you want to replace it?'), 0, __OnTop($mGUI))
							If $mMsgBox <> 6 Then
								ContinueLoop 2
							EndIf
						EndIf
					Next
				EndIf
				__IniWriteEx($mINI, "EnvironmentVariables", $mEnvVar, $mText)
				EnvSet($mEnvVar, $mText)
				ExitLoop

		EndSwitch
	WEnd
	GUIDelete($mGUI)

	Return 1
EndFunc   ;==>_Manage_AddCustomVar

Func _Manage_RemoveCustomVar($mCustomItem, $mINI, $mHandle = -1)
	Local $mGUI, $mRemove, $mClose, $mAbbreviation, $mCombo_Abbreviations, $mString_Abbreviations

	$mGUI = GUICreate(__Lang_Get('ENV_VAR_MSGBOX_1', 'Remove Abbreviation'), 300, 85, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	For $A = 1 To $mCustomItem[0][0]
		$mString_Abbreviations &= $mCustomItem[$A][0] & "|"
	Next
	$mCombo_Abbreviations = GUICtrlCreateCombo("", 10, 15, 280, 22, 0x0003)
	GUICtrlSetData($mCombo_Abbreviations, StringTrimRight($mString_Abbreviations, 1), $mCustomItem[1][0])

	$mRemove = GUICtrlCreateButton(__Lang_Get('OPTIONS_BUTTON_3', 'Remove'), 150 - 25 - 85, 50, 80, 24)
	$mClose = GUICtrlCreateButton(__Lang_Get('CLOSE', 'Close'), 150 + 25, 50, 80, 24)
	GUICtrlSetState($mClose, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $mClose
				ExitLoop

			Case $mRemove
				$mAbbreviation = GUICtrlRead($mCombo_Abbreviations)
				IniDelete($mINI, "EnvironmentVariables", $mAbbreviation)
				EnvSet($mAbbreviation)
				ExitLoop

		EndSwitch
	WEnd
	GUIDelete($mGUI)

	Return 1
EndFunc   ;==>_Manage_RemoveCustomVar

Func _GUICtrlListView_ContextMenu_EnvVars($mButton_Env, $mProfile, $mCurrentAction, $mHandle = -1)
	Local $mEnvMenu, $mCustomMenu, $mCustomID[1], $mNoCustom, $mMsg, $mPos, $mSkipSome, $mValue = -1
	Local $mINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $mCustomItem = __IniReadSection($mINI, "EnvironmentVariables")
	If @error Or $mCustomItem[0][0] = 0 Then
		$mNoCustom = 1
	EndIf
	Local $mMenuGroup[10][2] = [ _
			[9, 0], _
			[__Lang_Get('ENV_VAR_TAB_4', 'Paths')], _
			[__Lang_Get('ENV_VAR_TAB_5', 'Current')], _
			[__Lang_Get('ENV_VAR_TAB_6', 'Created')], _
			[__Lang_Get('ENV_VAR_TAB_7', 'Modified')], _
			[__Lang_Get('ENV_VAR_TAB_8', 'Opened')], _
			[__Lang_Get('ENV_VAR_TAB_9', 'Taken')], _
			[__Lang_Get('ENV_VAR_TAB_2', 'Music')], _
			[__Lang_Get('ENV_VAR_TAB_10', 'System')], _
			[__Lang_Get('ENV_VAR_TAB_3', 'Others')]]
	Local $mString[68] = [ _ ; Needed To Support Obfuscation.
			67, _
			__Lang_Get('ENV_VAR_7', 'file full path'), _
			__Lang_Get('ENV_VAR_9', 'file extension'), _
			__Lang_Get('ENV_VAR_10', 'file name without extension'), _
			__Lang_Get('ENV_VAR_11', 'file name with extension'), _
			__Lang_Get('ENV_VAR_13', 'directory of each loaded item'), _
			__Lang_Get('ENV_VAR_29', 'directory name of each loaded item'), _
			__Lang_Get('ENV_VAR_14', 'drive letter of DropIt'), _
			__Lang_Get('ENV_VAR_21', 'recreate subdirectory structure'), _
			__Lang_Get('ENV_VAR_0', 'current date'), _
			__Lang_Get('ENV_VAR_30', 'current year'), _
			__Lang_Get('ENV_VAR_31', 'current month'), _
			__Lang_Get('ENV_VAR_32', 'current day'), _
			__Lang_Get('ENV_VAR_1', 'current time'), _
			__Lang_Get('ENV_VAR_33', 'current hour'), _
			__Lang_Get('ENV_VAR_34', 'current minute'), _
			__Lang_Get('ENV_VAR_35', 'current second'), _
			__Lang_Get('ENV_VAR_2', 'date file creation'), _
			__Lang_Get('ENV_VAR_36', 'year file creation'), _
			__Lang_Get('ENV_VAR_37', 'month file creation'), _
			__Lang_Get('ENV_VAR_38', 'day file creation'), _
			__Lang_Get('ENV_VAR_39', 'time file creation'), _
			__Lang_Get('ENV_VAR_40', 'hour file creation'), _
			__Lang_Get('ENV_VAR_41', 'minute file creation'), _
			__Lang_Get('ENV_VAR_42', 'second file creation'), _
			__Lang_Get('ENV_VAR_3', 'date file modification'), _
			__Lang_Get('ENV_VAR_43', 'year file modification'), _
			__Lang_Get('ENV_VAR_44', 'month file modification'), _
			__Lang_Get('ENV_VAR_45', 'day file modification'), _
			__Lang_Get('ENV_VAR_46', 'time file modification'), _
			__Lang_Get('ENV_VAR_47', 'hour file modification'), _
			__Lang_Get('ENV_VAR_48', 'minute file modification'), _
			__Lang_Get('ENV_VAR_49', 'second file modification'), _
			__Lang_Get('ENV_VAR_4', 'date file last access'), _
			__Lang_Get('ENV_VAR_50', 'year file last access'), _
			__Lang_Get('ENV_VAR_51', 'month file last access'), _
			__Lang_Get('ENV_VAR_52', 'day file last access'), _
			__Lang_Get('ENV_VAR_53', 'time file last access'), _
			__Lang_Get('ENV_VAR_54', 'hour file last access'), _
			__Lang_Get('ENV_VAR_55', 'minute file last access'), _
			__Lang_Get('ENV_VAR_56', 'second file last access'), _
			__Lang_Get('ENV_VAR_5', 'date picture taken'), _
			__Lang_Get('ENV_VAR_57', 'year picture taken'), _
			__Lang_Get('ENV_VAR_58', 'month picture taken'), _
			__Lang_Get('ENV_VAR_59', 'day picture taken'), _
			__Lang_Get('ENV_VAR_60', 'time picture taken'), _
			__Lang_Get('ENV_VAR_61', 'hour picture taken'), _
			__Lang_Get('ENV_VAR_62', 'minute picture taken'), _
			__Lang_Get('ENV_VAR_15', 'song album'), _
			__Lang_Get('ENV_VAR_16', 'song artist'), _
			__Lang_Get('ENV_VAR_17', 'song genre'), _
			__Lang_Get('ENV_VAR_18', 'song track number'), _
			__Lang_Get('ENV_VAR_19', 'song title'), _
			__Lang_Get('ENV_VAR_20', 'song year'), _
			__Lang_Get('ENV_VAR_65', 'AppData path'), _
			__Lang_Get('ENV_VAR_66', 'Public AppData path'), _
			__Lang_Get('ENV_VAR_22', 'Desktop path'), _
			__Lang_Get('ENV_VAR_25', 'Public Desktop path'), _
			__Lang_Get('ENV_VAR_23', 'Documents path'), _
			__Lang_Get('ENV_VAR_26', 'Public Documents path'), _
			__Lang_Get('ENV_VAR_24', 'Favorites path'), _
			__Lang_Get('ENV_VAR_27', 'Public Favorites path'), _
			__Lang_Get('ENV_VAR_63', 'image camera model'), _
			__Lang_Get('ENV_VAR_6', 'system default program'), _
			__Lang_Get('ENV_VAR_64', 'image dimensions'), _
			__Lang_Get('ENV_VAR_8', 'file author'), _
			__Lang_Get('ENV_VAR_12', 'file type'), _
			__Lang_Get('ENV_VAR_28', 'current DropIt profile name')]
	Local $mMenuItem[68][4] = [ _
			[67, 0], _
			[1, "File", $mString[1] & ' ["C:\Docs\Text.txt"]'], _ ; Only By Open With.
			[1, "FileExt", $mString[2] & ' ["txt"]'], _
			[1, "FileName", $mString[3] & ' ["Text"]'], _
			[1, "FileNameExt", $mString[4] & ' ["Text.txt"]'], _
			[1, "ParentDir", $mString[5] & ' ["C:\Docs"]'], _
			[1, "ParentDirName", $mString[6] & ' ["Docs"]'], _
			[1, "PortableDrive", $mString[7] & ' ["' & StringLeft(@AutoItExe, 2) & '"]'], _
			[1, "SubDir", $mString[8] & ' ["\SubFolder"]'], _
			[2, "CurrentDate", $mString[9] & ' ["' & @YEAR & "-" & @MON & "-" & @MDAY & '"]'], _
			[2, "CurrentYear", $mString[10] & ' ["' & @YEAR & '"]'], _
			[2, "CurrentMonth", $mString[11] & ' ["' & @MON & '"]'], _
			[2, "CurrentDay", $mString[12] & ' ["' & @MDAY & '"]'], _
			[2, "CurrentTime", $mString[13] & ' ["' & @HOUR & "." & @MIN & '"]'], _
			[2, "CurrentHour", $mString[14] & ' ["' & @HOUR & '"]'], _
			[2, "CurrentMinute", $mString[15] & ' ["' & @MIN & '"]'], _
			[2, "CurrentSecond", $mString[16] & ' ["' & @SEC & '"]'], _
			[3, "DateCreated", $mString[17] & ' ["2011-05-16"]'], _
			[3, "YearCreated", $mString[18] & ' ["2011"]'], _
			[3, "MonthCreated", $mString[19] & ' ["05"]'], _
			[3, "DayCreated", $mString[20] & ' ["16"]'], _
			[3, "TimeCreated", $mString[21] & ' ["19.40"]'], _
			[3, "HourCreated", $mString[22] & ' ["19"]'], _
			[3, "MinuteCreated", $mString[23] & ' ["40"]'], _
			[3, "SecondCreated", $mString[24] & ' ["37"]'], _
			[4, "DateModified", $mString[25] & ' ["2011-05-16"]'], _
			[4, "YearModified", $mString[26] & ' ["2011"]'], _
			[4, "MonthModified", $mString[27] & ' ["05"]'], _
			[4, "DayModified", $mString[28] & ' ["16"]'], _
			[4, "TimeModified", $mString[29] & ' ["19.40"]'], _
			[4, "HourModified", $mString[30] & ' ["19"]'], _
			[4, "MinuteModified", $mString[31] & ' ["40"]'], _
			[4, "SecondModified", $mString[32] & ' ["37"]'], _
			[5, "DateOpened", $mString[33] & ' ["2011-05-16"]'], _
			[5, "YearOpened", $mString[34] & ' ["2011"]'], _
			[5, "MonthOpened", $mString[35] & ' ["05"]'], _
			[5, "DayOpened", $mString[36] & ' ["16"]'], _
			[5, "TimeOpened", $mString[37] & ' ["19.40"]'], _
			[5, "HourOpened", $mString[38] & ' ["19"]'], _
			[5, "MinuteOpened", $mString[39] & ' ["40"]'], _
			[5, "SecondOpened", $mString[40] & ' ["37"]'], _
			[6, "DateTaken", $mString[41] & ' ["2011-05-16"]'], _
			[6, "YearTaken", $mString[42] & ' ["2011"]'], _
			[6, "MonthTaken", $mString[43] & ' ["05"]'], _
			[6, "DayTaken", $mString[44] & ' ["16"]'], _
			[6, "TimeTaken", $mString[45] & ' ["19.40"]'], _
			[6, "HourTaken", $mString[46] & ' ["19"]'], _
			[6, "MinuteTaken", $mString[47] & ' ["40"]'], _
			[7, "SongAlbum", $mString[48] & ' ["The Wall"]'], _
			[7, "SongArtist", $mString[49] & ' ["Pink Floyd"]'], _
			[7, "SongGenre", $mString[50] & ' ["Rock"]'], _
			[7, "SongNumber", $mString[51] & ' ["3"]'], _
			[7, "SongTitle", $mString[52] & ' ["Hey You"]'], _
			[7, "SongYear", $mString[53] & ' ["1979"]'], _
			[8, "AppData", $mString[54] & ' ["' & @AppDataDir & '"]'], _
			[8, "AppDataPublic", $mString[55] & ' ["' & @AppDataCommonDir & '"]'], _
			[8, "Desktop", $mString[56] & ' ["' & @DesktopDir & '"]'], _
			[8, "DesktopPublic", $mString[57] & ' ["' & @DesktopCommonDir & '"]'], _
			[8, "Documents", $mString[58] & ' ["' & @MyDocumentsDir & '"]'], _
			[8, "DocumentsPublic", $mString[59] & ' ["' & @DocumentsCommonDir & '"]'], _
			[8, "Favorites", $mString[60] & ' ["' & @FavoritesDir & '"]'], _
			[8, "FavoritesPublic", $mString[61] & ' ["' & @FavoritesCommonDir & '"]'], _
			[9, "CameraModel", $mString[62] & ' ["u700"]'], _
			[9, "DefaultProgram", $mString[63] & ' [Notepad]'], _ ; Only By Open With.
			[9, "Dimensions", $mString[64] & ' ["3072 x 2304"]'], _
			[9, "FileAuthor", $mString[65] & ' ["Lupo Team"]'], _
			[9, "FileType", $mString[66] & ' ["Text document"]'], _
			[9, "ProfileName", $mString[67] & ' ["' & $mProfile & '"]']]

	If IsHWnd($mButton_Env) = 0 Then
		$mButton_Env = GUICtrlGetHandle($mButton_Env)
	EndIf

	If $mCurrentAction <> __Lang_Get('ACTION_OPEN_WITH', 'Open With') Then
		$mSkipSome = 1 ; To Hide Abbreviations If Not Supported By Current Action.
	EndIf

	$mEnvMenu = _GUICtrlMenu_CreatePopup()
	_GUICtrlMenu_SetMenuStyle($mEnvMenu, $MNS_NOCHECK)
	For $A = 1 To $mMenuGroup[0][0]
		$mMenuGroup[$A][1] = _GUICtrlMenu_CreatePopup()
		_GUICtrlMenu_SetMenuStyle($mMenuGroup[$A][1], $MNS_NOCHECK)
		_GUICtrlMenu_AddMenuItem($mEnvMenu, $mMenuGroup[$A][0], 0, $mMenuGroup[$A][1])
	Next
	For $A = 1 To $mMenuItem[0][0]
		$mMenuItem[$A][3] = 1000 + $A
		_GUICtrlMenu_AddMenuItem($mMenuGroup[$mMenuItem[$A][0]][1], "%" & $mMenuItem[$A][1] & "% = " & $mMenuItem[$A][2], $mMenuItem[$A][3])
		If $mSkipSome And ($mMenuItem[$A][1] = "File" Or $mMenuItem[$A][1] = "DefaultProgram") Then
			_GUICtrlMenu_SetItemDisabled($mMenuGroup[$mMenuItem[$A][0]][1], $mMenuItem[$A][3], True, False) ; To Hide Abbreviations If Not Supported By Current Action.
		EndIf
	Next

	_GUICtrlMenu_AddMenuItem($mEnvMenu, "")
	$mCustomMenu = _GUICtrlMenu_CreatePopup()
	_GUICtrlMenu_SetMenuStyle($mCustomMenu, $MNS_NOCHECK)
	_GUICtrlMenu_AddMenuItem($mEnvMenu, __Lang_Get('ENV_VAR_TAB_11', 'Custom'), 0, $mCustomMenu)
	_GUICtrlMenu_AddMenuItem($mCustomMenu, __Lang_Get('ENV_VAR_MSGBOX_0', 'Add Abbreviation'), 1999)
	If $mNoCustom <> 1 Then
		_GUICtrlMenu_AddMenuItem($mCustomMenu, __Lang_Get('ENV_VAR_MSGBOX_1', 'Remove Abbreviation'), 2000)
		_GUICtrlMenu_AddMenuItem($mCustomMenu, "")
		$mCustomID[0] = $mCustomItem[0][0]
		ReDim $mCustomID[$mCustomID[0] + 1]
		For $A = 1 To $mCustomItem[0][0]
			$mCustomID[$A] = 2000 + $A
			_GUICtrlMenu_AddMenuItem($mCustomMenu, "%" & $mCustomItem[$A][0] & "% = " & $mCustomItem[$A][1], $mCustomID[$A])
		Next
	EndIf

	$mPos = WinGetPos($mButton_Env, "")
	$mMsg = _GUICtrlMenu_TrackPopupMenu($mEnvMenu, $mButton_Env, $mPos[0] + $mPos[2], $mPos[1] + $mPos[3], 2, 1, 2)
	Switch $mMsg
		Case 1999 ; Add Abbreviation.
			_Manage_AddCustomVar($mMenuItem, $mCustomItem, $mNoCustom, $mINI, $mHandle)
		Case 2000 ; Remove Abbreviation.
			_Manage_RemoveCustomVar($mCustomItem, $mINI, $mHandle)
		Case Else
			If $mMsg >= $mMenuItem[1][3] And $mMsg <= $mMenuItem[$mMenuItem[0][0]][3] Then
				For $A = 1 To $mMenuItem[0][0]
					If $mMsg = $mMenuItem[$A][3] Then
						$mValue = $mMenuItem[$A][1]
						ExitLoop
					EndIf
				Next
			ElseIf $mNoCustom <> 1 Then
				If $mMsg >= $mCustomID[1] And $mMsg <= $mCustomID[$mCustomID[0]] Then
					For $A = 1 To $mCustomID[0]
						If $mMsg = $mCustomID[$A] Then
							$mValue = $mCustomItem[$A][0]
							ExitLoop
						EndIf
					Next
				EndIf
			EndIf
	EndSwitch

	_GUICtrlMenu_DestroyMenu($mEnvMenu)
	For $A = 1 To $mMenuGroup[0][0]
		_GUICtrlMenu_DestroyMenu($mMenuGroup[$A][1])
	Next

	Return $mValue
EndFunc   ;==>_GUICtrlListView_ContextMenu_EnvVars

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
	Local $cGUI, $cProfileDirectory, $cListView, $cListView_Handle, $cNew, $cClose, $cIndex_Selected, $cText, $cImage, $cSizeText, $cOpacity
	Local $cDeleteDummy, $cDuplicateDummy, $cEnterDummy, $cNewDummy, $cImportDummy, $cOptionsDummy, $cExampleDummy

	$cProfileDirectory = __GetDefault(2) ; Get Default Profile Directory.
	Local $cSize = __GetCurrentSize("SizeCustom") ; 320 x 200.

	If $cProfileList = -1 Or $cProfileList = 0 Or $cProfileList = "" Then
		$cProfileList = __ProfileList_Get() ; Get Array Of All Profiles.
	EndIf
	If IsArray($cProfileList) = 0 Then
		Return SetError(1, 0, 0)
	EndIf

	$cGUI = GUICreate(__Lang_Get('CUSTOMIZE_GUI', 'Customize Profiles'), $cSize[0], $cSize[1], -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX), -1, __OnTop($cHandle))
	GUISetIcon(@ScriptFullPath, -5, $cGUI) ; Use Custom.ico
	$Global_ResizeWidth = 300 ; Set Default Minimum Width.
	$Global_ResizeHeight = 190 ; Set Default Minimum Height.

	$cListView = GUICtrlCreateListView(__Lang_Get('PROFILE', 'Profile') & "|" & __Lang_Get('IMAGE', 'Image') & "|" & __Lang_Get('SIZE', 'Size') & "|" & __Lang_Get('OPACITY', 'Opacity'), 0, 0, $cSize[0], $cSize[1] - 35, BitOR($LVS_NOSORTHEADER, $LVS_REPORT, $LVS_SINGLESEL))
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
	_GUICtrlListView_JustifyColumn($cListView_Handle, 2, 1)
	_GUICtrlListView_JustifyColumn($cListView_Handle, 3, 1)

	Local $cToolTip = _GUICtrlListView_GetToolTips($cListView_Handle)
	If IsHWnd($cToolTip) Then
		__OnTop($cToolTip, 1)
		_GUIToolTip_SetDelayTime($cToolTip, 3, 60) ; Speed Up InfoTip Appearance.
	EndIf

	_Customize_Update($cListView_Handle, $cProfileDirectory, $cProfileList) ; Add/Update Customise GUI With List Of Profiles.
	If @error Then
		SetError(1, 0, 0) ; Exit Function If No Profiles.
	EndIf

	$cNewDummy = GUICtrlCreateDummy()
	$Global_ListViewProfiles_New = $cNewDummy
	$cEnterDummy = GUICtrlCreateDummy()
	$Global_ListViewProfiles_Enter = $cEnterDummy
	$cDeleteDummy = GUICtrlCreateDummy()
	$Global_ListViewProfiles_Delete = $cDeleteDummy
	$cDuplicateDummy = GUICtrlCreateDummy()
	$Global_ListViewProfiles_Duplicate = $cDuplicateDummy
	$cImportDummy = GUICtrlCreateDummy()
	$Global_ListViewProfiles_Import = $cImportDummy
	$cOptionsDummy = GUICtrlCreateDummy()
	$Global_ListViewProfiles_Options = $cOptionsDummy
	$cExampleDummy = GUICtrlCreateDummy()
	$Global_ListViewProfiles_Example[0] = $cExampleDummy

	$cNew = GUICtrlCreateButton(__Lang_Get('NEW', 'New'), 50, $cSize[1] - 31, 74, 25)
	GUICtrlSetTip($cNew, __Lang_Get('CUSTOMIZE_GUI_TIP_0', 'Click to add a profile or Right-click a profile to manage it.'))
	GUICtrlSetResizing($cNew, $GUI_DOCKSIZE + $GUI_DOCKLEFT + $GUI_DOCKBOTTOM)
	$cClose = GUICtrlCreateButton(__Lang_Get('CLOSE', 'Close'), $cSize[0] - 50 - 74, $cSize[1] - 31, 74, 25)
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
		$cIndex_Selected = $Global_ListViewIndex

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

			Case $cDuplicateDummy
				$cText = _GUICtrlListView_GetItemText($cListView_Handle, $cIndex_Selected)
				FileCopy($cProfileDirectory & $cText & ".ini", $cProfileDirectory & _Duplicate_Rename($cText & ".ini", $cProfileDirectory, 0, 2))
				_Customize_Update($cListView_Handle, $cProfileDirectory, -1) ; Add/Update Customise GUI With List Of Profiles.

			Case $cDeleteDummy
				_Customize_Delete($cListView_Handle, $cIndex_Selected, $cProfileDirectory, -1, $cGUI) ; Delete Profile From The Default Profile Directory & ListView.
				$Global_ListViewIndex = -1 ; Set As No Item Selected.

			Case $cOptionsDummy
				$cText = _GUICtrlListView_GetItemText($cListView_Handle, $cIndex_Selected)
				_Customize_Options($cText, $cProfileDirectory, $cGUI) ; Show Profile Options GUI.

			Case $cImportDummy
				_Customize_Import($cProfileDirectory, $cGUI)
				If @error = 2 Then
					MsgBox(0x30, __Lang_Get('CUSTOMIZE_MSGBOX_2', 'Importing Failed'), __Lang_Get('CUSTOMIZE_MSGBOX_3', 'Profile not imported. The source file might be not correctly structured.'), 0, __OnTop($cGUI))
					ContinueLoop
				EndIf
				_Customize_Update($cListView_Handle, $cProfileDirectory, -1) ; Add/Update Customise GUI With List Of Profiles.

			Case $cEnterDummy
				If Not _GUICtrlListView_GetItemState($cListView_Handle, $cIndex_Selected, $LVIS_SELECTED) Then
					ContinueLoop
				EndIf

				$cText = _GUICtrlListView_GetItemText($cListView_Handle, $cIndex_Selected)
				$cImage = _GUICtrlListView_GetItemText($cListView_Handle, $cIndex_Selected, 1)
				$cSizeText = _GUICtrlListView_GetItemText($cListView_Handle, $cIndex_Selected, 2)
				$cOpacity = _GUICtrlListView_GetItemText($cListView_Handle, $cIndex_Selected, 3)
				_Customize_Edit_GUI($cGUI, $cText, $cImage, $cSizeText, $cOpacity, 0) ; Show Customize Edit GUI Of Selected Profile.
				_Customize_Update($cListView_Handle, $cProfileDirectory, -1) ; Add/Update Customise GUI With List Of Profiles.
				_GUICtrlListView_SetItemSelected($cListView_Handle, $cIndex_Selected, True, True)

			Case $cExampleDummy
				If FileExists($cProfileDirectory & $Global_ListViewProfiles_Example[1] & ".ini") Then
					MsgBox(0x30, __Lang_Get('PROFILEUNIQUE_MSGBOX_0', 'Name not available'), __Lang_Get('PROFILEUNIQUE_MSGBOX_1', 'This profile name already exists.'), 0, __OnTop($cGUI))
					ContinueLoop
				EndIf
				Switch $Global_ListViewProfiles_Example[1]
					Case __Lang_Get('CUSTOMIZE_EXAMPLE_0', 'Archiver')
						__ArrayToProfile(_Customize_Examples(1), __Lang_Get('CUSTOMIZE_EXAMPLE_0', 'Archiver'), $cProfileDirectory, "Big_Box4.png", "80")
					Case __Lang_Get('CUSTOMIZE_EXAMPLE_1', 'Eraser')
						__ArrayToProfile(_Customize_Examples(2), __Lang_Get('CUSTOMIZE_EXAMPLE_1', 'Eraser'), $cProfileDirectory, "Big_Delete1.png", "80")
					Case __Lang_Get('CUSTOMIZE_EXAMPLE_2', 'Extractor')
						__ArrayToProfile(_Customize_Examples(3), __Lang_Get('CUSTOMIZE_EXAMPLE_2', 'Extractor'), $cProfileDirectory, "Big_Box6.png", "80")
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
	If IsArray($cProfileList) = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	Return $cProfileList
EndFunc   ;==>_Customize_GUI

Func _Customize_Edit_GUI($cHandle = -1, $cProfile = -1, $cImage = -1, $cSizeText = -1, $cOpacity = -1, $cNewProfile = 0)
	Local $cGUI_1 = $Global_GUI_1

	Local $cStringSplit, $cProfileType, $cGUI, $cInput_Name, $cInput_Image, $cButton_Image, $cInput_SizeX, $cInput_SizeY, $cButton_Size, $cInput_Opacity
	Local $cSave, $cCancel, $cChanged = 0, $cProfileDirectory, $cReturn, $cSizeX, $cSizeY, $cIniWrite, $cItemText, $cLabel_Opacity, $cCurrentProfile = 0
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

	If $cOpacity == -1 Or $cOpacity == 0 Or $cOpacity == "" Or $cOpacity < 10 Or $cOpacity > 100 Then
		$cOpacity = 100
	EndIf
	$cOpacity = StringReplace($cOpacity, "%", "")

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
	$cButton_Size = GUICtrlCreateButton(__Lang_Get('RESET', 'Reset'), 10 + 174, 120 + 30, 66, 22)
	GUICtrlSetTip($cButton_Size, __Lang_Get('CUSTOMIZE_EDIT_TIP_2', 'Reset target image to the original size.'))

	GUICtrlCreateLabel(__Lang_Get('OPACITY', 'Opacity') & ":", 10, 180 + 10, 120, 20)
	$cInput_Opacity = GUICtrlCreateSlider(10, 180 + 31, 200, 20)
	$Global_Slider = $cInput_Opacity
	GUICtrlSetLimit(-1, 100, 10)
	GUICtrlSetData(-1, $cOpacity)
	$cLabel_Opacity = GUICtrlCreateLabel($cOpacity & "%", 10 + 200, 180 + 31, 36, 20)
	$Global_SliderLabel = $cLabel_Opacity

	$cSave = GUICtrlCreateButton(__Lang_Get('SAVE', 'Save'), 130 - 20 - 76, 250, 76, 26)
	$cCancel = GUICtrlCreateButton(__Lang_Get('CANCEL', 'Cancel'), 130 + 20, 250, 76, 26)
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
				And GUICtrlRead($cInput_Opacity) <> "" And FileExists($cProfileDirectory[2][0] & GUICtrlRead($cInput_Image)) And StringIsSpace(GUICtrlRead($cInput_Name)) = 0 Then
			If GUICtrlGetState($cSave) > 80 Then
				GUICtrlSetState($cSave, 576) ; $GUI_ENABLE + $GUI_DEFBUTTON.
			EndIf
			If GUICtrlGetState($cCancel) = 512 Then
				GUICtrlSetState($cCancel, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
		ElseIf GUICtrlRead($cInput_Name) = "" Or GUICtrlRead($cInput_Image) = "" Or GUICtrlRead($cInput_SizeX) = "" Or GUICtrlRead($cInput_SizeY) = "" _
				Or GUICtrlRead($cInput_Opacity) = "" Or FileExists($cProfileDirectory[2][0] & GUICtrlRead($cInput_Image)) = 0 Or StringIsSpace(GUICtrlRead($cInput_Name)) Then
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
			If GUICtrlGetState($cInput_Opacity) > 80 Then
				GUICtrlSetState($cInput_Opacity, 80) ; $GUI_ENABLE + $GUI_SHOW.
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
			If GUICtrlGetState($cIcon_Label) > 80 Then
				GUICtrlSetState($cIcon_Label, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
		ElseIf GUICtrlRead($cInput_Name) = "" Or StringIsSpace(GUICtrlRead($cInput_Name)) Then
			If GUICtrlGetState($cButton_Image) = 80 Then
				GUICtrlSetState($cButton_Image, 144) ; $GUI_DISABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($cButton_Size) = 80 Then
				GUICtrlSetState($cButton_Size, 144) ; $GUI_DISABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($cInput_Opacity) = 80 Then
				GUICtrlSetState($cInput_Opacity, 144) ; $GUI_DISABLE + $GUI_SHOW.
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
			If GUICtrlGetState($cIcon_Label) = 80 Then
				GUICtrlSetState($cIcon_Label, 144) ; $GUI_DISABLE + $GUI_SHOW.
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
					__ImageWrite($cProfile[1], 7, $cProfile[4], $cProfile[5], $cProfile[6], $cProfile[7]) ; Write Image File Name & Size & Opacity To The Selected Profile.
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
					$cItemText = __IsProfileUnique($cItemText, 1, $cGUI) ; Check If The Selected Profile Name Is Unique.
					If @error Then
						GUICtrlSetData($cInput_Name, "")
						ContinueLoop
					EndIf
				EndIf

				If $cNewProfile = 1 Then
					$cIniWrite = $cProfileDirectory[1][0] & $cItemText & ".ini"
					If FileExists($cIniWrite) = 0 Then
						__IniWriteEx($cIniWrite, "Target", "", "Image=" & $cProfileDirectory[3][0] & @LF & "SizeX=64" & @LF & "SizeY=64" & @LF & "Opacity=100")
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

				__ImageWrite($cItemText, 7, GUICtrlRead($cInput_Image), GUICtrlRead($cInput_SizeX), GUICtrlRead($cInput_SizeY), GUICtrlRead($cInput_Opacity)) ; Write Image File Name & Size & Opacity To The Selected Profile.

				$cChanged = 1
				ExitLoop

			Case $cButton_Image, $cIcon_Label
				If StringIsSpace(GUICtrlRead($cInput_Name)) Or GUICtrlRead($cInput_Name) = "" Then ContinueLoop
				$cItemText = StringReplace(StringStripWS(GUICtrlRead($cInput_Name), 7), " ", "_")

				If $cNewProfile = 1 Or $cInitialProfileName <> $cItemText Then
					$cItemText = __IsProfileUnique($cItemText, 1, $cGUI) ; Check If The Selected Profile Name Is Unique.
					If @error Then
						GUICtrlSetData($cInput_Name, $cProfile[1])
						ContinueLoop
					EndIf
				EndIf

				If $cNewProfile = 1 Then
					$cIniWrite = $cProfileDirectory[1][0] & $cItemText & ".ini"
					If FileExists($cIniWrite) = 0 Then
						__IniWriteEx($cIniWrite, "Target", "", "Image=" & $cProfileDirectory[3][0] & @LF & "SizeX=64" & @LF & "SizeY=64" & @LF & "Opacity=100")
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
				$cOpacity = GUICtrlRead($cInput_Opacity)
				$cReturn = __ImageGet($cGUI, $cItemText) ; Select Image From Default Image Directory Or Custom Directory, It Will Copy To The Default Image Directory If Selected In A Custom Directory.

				If @error = 0 Then
					$cImage = $cReturn[1]
					$cSizeX = $cReturn[2]
					$cSizeY = $cReturn[3]
					$cOpacity = $cReturn[4]
					GUICtrlSetData($cInput_Image, $cImage)
					GUICtrlSetData($cInput_SizeX, $cSizeX)
					GUICtrlSetData($cInput_SizeY, $cSizeY)
					__SetBitmap($cIcon_GUI, $cProfileDirectory[2][0] & $cImage, 255 / 100 * $cOpacity, 32, 32) ; Set Image & Resize To The Image GUI.
					If $cCurrentProfile = 1 Then
						__SetBitmap($cGUI_1, $cProfileDirectory[2][0] & $cImage, 255 / 100 * $cOpacity, $cSizeX, $cSizeY) ; Set Image & Resize To The GUI If Current Profile.
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
					GUICtrlSetData($cInput_Opacity, 100)
					GUICtrlSetData($cLabel_Opacity, 100 & "%")
					If $cNewProfile = 0 Then
						__ImageWrite($cItemText, 2, $cImage, $cReturn[0], $cReturn[1], 100) ; Write Size To The Selected Profile.
					EndIf
					__SetBitmap($cIcon_GUI, $cProfileDirectory[2][0] & $cImage, 255 / 100 * 100, 32, 32) ; Set Image & Resize To The Image GUI.
					If $cCurrentProfile = 1 Then
						__SetBitmap($cGUI_1, $cProfileDirectory[2][0] & $cImage, 255 / 100 * 100, $cReturn[0], $cReturn[1]) ; Set Image & Resize To The GUI If Current Profile.
					EndIf
				EndIf
				$cChanged = 1

			Case $cInput_Opacity ; Change The Opacity Of The Current Profile Image Only.
				$cImage = GUICtrlRead($cInput_Image)
				$cSizeX = GUICtrlRead($cInput_SizeX)
				$cSizeY = GUICtrlRead($cInput_SizeY)
				$cOpacity = GUICtrlRead($cInput_Opacity)
				__SetBitmap($cIcon_GUI, $cProfileDirectory[2][0] & $cImage, 255 / 100 * $cOpacity, 32, 32) ; Set Image & Resize To The Image GUI.
				If $cCurrentProfile = 1 Then
					__SetBitmap($cGUI_1, $cProfileDirectory[2][0] & $cImage, 255 / 100 * $cOpacity, $cSizeX, $cSizeY) ; Set Image & Resize To The GUI If Current Profile.
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

	Local $cMsgBox = MsgBox(0x4, __Lang_Get('CUSTOMIZE_DELETE_MSGBOX_2', 'Delete selected profile'), __Lang_Get('CUSTOMIZE_DELETE_MSGBOX_3', 'Selected profile:') & "  " & $cFileName & @LF & __Lang_Get('CUSTOMIZE_DELETE_MSGBOX_4', 'Are you sure to delete this profile?'), 0, __OnTop($cHandle))
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

Func _Customize_Examples($cExample)
	Local $cArray[3][5] = [ _
			[2, 4], _
			[0, "NAME", "RULES", "ACTION", "DESTINATION"], _
			[0, __Lang_Get('CUSTOMIZE_EXAMPLE_0', 'Archiver'), "*;**", "Compress", "%Desktop%\" & __Lang_Get('ARCHIVE', 'Archive') & ".zip"]]

	Switch $cExample
		Case 2 ; Eraser.
			$cArray[2][1] = __Lang_Get('CUSTOMIZE_EXAMPLE_1', 'Eraser')
			$cArray[2][2] = "*;**"
			$cArray[2][3] = "Delete"
			$cArray[2][4] = "Safely Erase"
		Case 3 ; Extractor.
			$cArray[2][1] = __Lang_Get('CUSTOMIZE_EXAMPLE_2', 'Extractor')
			$cArray[2][2] = "*.*"
			$cArray[2][3] = "Extract"
			$cArray[2][4] = "%ParentDir%"
	EndSwitch

	Return $cArray
EndFunc   ;==>_Customize_Examples

Func _Customize_Import($cProfileDirectory, $cHandle = -1)
	Local $cListPath, $sProfileName, $cExcel, $cArray

	$cListPath = FileOpenDialog(__Lang_Get('CUSTOMIZE_MSGBOX_0', 'Select a file to import:'), @DesktopDir, __Lang_Get('CUSTOMIZE_MSGBOX_1', 'Supported files') & " (*.csv;*.xls;*.xlsx)", 1, "", $cHandle)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Switch __GetFileExtension($cListPath)
		Case "csv"
			$cArray = __CSVSplit(FileRead($cListPath))
			If @error Then
				Return SetError(2, 0, 0)
			EndIf
		Case "xls", "xlsx"
			$cExcel = _ExcelBookOpen($cListPath, 0, True)
			$cArray = _ExcelReadSheetToArray($cExcel, 3, 2, 0, 4)
			If @error Then
				Return SetError(2, 0, 0)
			EndIf
			_ExcelBookClose($cExcel, 0, 0)
	EndSwitch
	If StringInStr($cArray[1][1] & $cArray[1][2] & $cArray[1][3] & $cArray[1][4], "NAMERULESACTIONDESTINATION") = 0 Then
		Return SetError(2, 0, 0)
	EndIf

	$sProfileName = __ArrayToProfile($cArray, __GetFileNameOnly($cListPath), $cProfileDirectory)
	__Log_Write(__Lang_Get('CUSTOMIZE_LOG_0', 'Profile Imported'), $sProfileName)

	Return 1
EndFunc   ;==>_Customize_Import

Func _Customize_Options($cProfileName, $cProfileDirectory, $cHandle = -1)
	Local $cGUI, $cSave, $cCancel, $cState, $cComboItems[5], $cCurrent[5]
	Local $cINI = $cProfileDirectory & $cProfileName & ".ini"
	Local $cOptions[4] = ["ShowSorting", "DirForFolders", "IgnoreNew", "AutoDup"]
	Local $cGroup = __Lang_Get('OPTIONS_PROFILE_MODE_0', 'Use global setting') & "|" & __Lang_Get('OPTIONS_PROFILE_MODE_1', 'Enable for this profile') & "|" & __Lang_Get('OPTIONS_PROFILE_MODE_2', 'Disable for this profile')

	$cGUI = GUICreate(__Lang_Get('OPTIONS_PROFILE', 'Profile Options'), 300, 296, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($cHandle))
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_CHECKBOX_11', 'Show progress bar during process') & ":", 10, 10, 280, 20)
	$cComboItems[0] = GUICtrlCreateCombo("", 20, 10 + 20, 260, 20, 0x0003)
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_CHECKBOX_2', 'Enable associations for folders') & ":", 10, 10 + 55, 280, 20)
	$cComboItems[1] = GUICtrlCreateCombo("", 20, 10 + 55 + 20, 260, 20, 0x0003)
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_CHECKBOX_3', 'Ignore unassociated files/folders') & ":", 10, 10 + 110, 280, 20)
	$cComboItems[2] = GUICtrlCreateCombo("", 20, 10 + 110 + 20, 260, 20, 0x0003)
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_CHECKBOX_5', 'Use automatic choice for duplicates') & ":", 10, 10 + 165, 280, 20)
	$cComboItems[3] = GUICtrlCreateCombo("", 20, 10 + 165 + 20, 260, 20, 0x0003)
	$cComboItems[4] = GUICtrlCreateCombo("", 20, 10 + 165 + 45, 260, 20, 0x0003)

	For $A = 0 To 3
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
	$cGroup = __Lang_Get('DUPLICATE_MODE_0', 'Overwrite') & "|" & __Lang_Get('DUPLICATE_MODE_1', 'Overwrite if newer') & "|" & _
			__Lang_Get('DUPLICATE_MODE_7', 'Overwrite if different size') & "|" & __Lang_Get('DUPLICATE_MODE_3', 'Rename as "Name 01"') & "|" & _
			__Lang_Get('DUPLICATE_MODE_4', 'Rename as "Name_01"') & "|" & __Lang_Get('DUPLICATE_MODE_5', 'Rename as "Name (01)"') & "|" & _
			__Lang_Get('DUPLICATE_MODE_6', 'Skip')
	$cCurrent[4] = __GetDuplicateMode(IniRead($cINI, "General", "DupMode", "Overwrite1"), 1)
	GUICtrlSetData($cComboItems[4], $cGroup, $cCurrent[4])

	$cState = $GUI_ENABLE
	If $cCurrent[3] <> __Lang_Get('OPTIONS_PROFILE_MODE_1', 'Enable for this profile') Then
		$cState = $GUI_DISABLE
	EndIf
	GUICtrlSetState($cComboItems[4], $cState)

	$cSave = GUICtrlCreateButton(__Lang_Get('SAVE', 'Save'), 150 - 25 - 80, 260, 80, 24)
	$cCancel = GUICtrlCreateButton(__Lang_Get('CANCEL', 'Cancel'), 150 + 25, 260, 80, 24)
	GUICtrlSetState($cSave, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)

	While 1
		If GUICtrlRead($cComboItems[3]) <> $cCurrent[3] And Not _GUICtrlComboBox_GetDroppedState($cComboItems[3]) Then
			$cCurrent[3] = GUICtrlRead($cComboItems[3])
			$cState = $GUI_ENABLE
			If $cCurrent[3] <> __Lang_Get('OPTIONS_PROFILE_MODE_1', 'Enable for this profile') Then
				$cState = $GUI_DISABLE
			EndIf
			GUICtrlSetState($cComboItems[4], $cState)
		EndIf

		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $cCancel
				ExitLoop

			Case $cSave
				For $A = 0 To 3
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
				__IniWriteEx($cINI, "General", "DupMode", __GetDuplicateMode(GUICtrlRead($cComboItems[4])))
				ExitLoop

		EndSwitch
	WEnd
	GUIDelete($cGUI)

	Return 1
EndFunc   ;==>_Customize_Options

Func _Customize_Update($cListView, $cProfileDirectory, $cProfileList = -1)
	Local $cListViewItem, $cIniReadOpacity, $cIniRead, $cIniRead_Size[2]
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
		$cIniReadOpacity = IniRead($cINI, "Target", "Opacity", "")

		If $cIniRead_Size[0] = "" Or $cIniRead_Size[1] = "" Then
			$cIniRead_Size = __ImageSize(__GetDefault(4) & $cIniRead) ; If X & Y Empty Then Find The Size Of The Image Using Default Image Directory.
		EndIf
		If IsArray($cIniRead_Size) = 0 Then
			Return SetError(1, 0, 0)
		EndIf
		If $cIniReadOpacity = "" Then
			$cIniReadOpacity = 100
		EndIf

		_GUICtrlListView_AddSubItem($cListView, $cListViewItem, $cIniRead_Size[0] & "x" & $cIniRead_Size[1], 2)
		_GUICtrlListView_AddSubItem($cListView, $cListViewItem, $cIniReadOpacity & "%", 3)

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
	Local Enum $cmItem1 = 1000, $cmItem2, $cmItem3, $cmItem4, $cmItem5, $cmItem6, $cmItem7, $cmItem8, $cmItem9, $cmItem10
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
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __Lang_Get('DUPLICATE', 'Duplicate'), $cmItem9)
		__SetItemImage("COPYTO", $cmIndex, $cmContextMenu_1, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, "")
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __Lang_Get('ACTION_DELETE', 'Delete'), $cmItem2)
		__SetItemImage("DEL", $cmIndex, $cmContextMenu_1, 2, 1)
	EndIf
	If $cmIndex = -1 And $cmSubItem <> -1 Then ; Will Show These MenuItem(s) If No Item Is Selected.
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __Lang_Get('NEW', 'New'), $cmItem3)
		__SetItemImage("NEW", $cmIndex, $cmContextMenu_1, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __Lang_Get('IMPORT', 'Import'), $cmItem10)
		__SetItemImage("IMPORT", $cmIndex, $cmContextMenu_1, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, "")

		$cmContextMenu_2 = _GUICtrlMenu_CreatePopup()
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __Lang_Get('EXAMPLES', 'Examples'), $cmItem4, $cmContextMenu_2)
		__SetItemImage("EXAMP", $cmIndex, $cmContextMenu_1, 2, 1)

		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_2, __Lang_Get('CUSTOMIZE_EXAMPLE_0', 'Archiver'), $cmItem5)
		__SetItemImage(__GetDefault(4) & "Big_Box4.png", $cmIndex, $cmContextMenu_2, 2, 0)

		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_2, __Lang_Get('CUSTOMIZE_EXAMPLE_1', 'Eraser'), $cmItem6)
		__SetItemImage(__GetDefault(4) & "Big_Delete1.png", $cmIndex, $cmContextMenu_2, 2, 0)

		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_2, __Lang_Get('CUSTOMIZE_EXAMPLE_2', 'Extractor'), $cmItem7)
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
		Case $cmItem9
			GUICtrlSendToDummy($Global_ListViewProfiles_Duplicate)
		Case $cmItem10
			GUICtrlSendToDummy($Global_ListViewProfiles_Import)
		Case $cmItem5
			$Global_ListViewProfiles_Example[1] = __Lang_Get('CUSTOMIZE_EXAMPLE_0', 'Archiver')
			GUICtrlSendToDummy($Global_ListViewProfiles_Example[0])
		Case $cmItem6
			$Global_ListViewProfiles_Example[1] = __Lang_Get('CUSTOMIZE_EXAMPLE_1', 'Eraser')
			GUICtrlSendToDummy($Global_ListViewProfiles_Example[0])
		Case $cmItem7
			$Global_ListViewProfiles_Example[1] = __Lang_Get('CUSTOMIZE_EXAMPLE_2', 'Extractor')
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
		$dMsgBox = MsgBox(0x4, __Lang_Get('DROP_EVENT_MSGBOX_3', 'Estimated long processing time'), __Lang_Get('DROP_EVENT_MSGBOX_4', 'You are trying to process a large size of files') & " (" & __ByteSuffix($dFullSize) & ")" & @LF & __Lang_Get('DROP_EVENT_MSGBOX_5', 'It may take a long time, do you wish to continue?'), 0, __OnTop())
		If $dMsgBox <> 6 Then
			__Log_Write(__Lang_Get('DROP_EVENT_TIP_1', 'Sorting Aborted'), __Lang_Get('DROP_EVENT_MSGBOX_3', 'Estimated long processing time'))
			Return SetError(1, 0, 0)
		EndIf
	EndIf

	$dElementsGUI = _Sorting_CreateGUI($dFullSize, $dProfile) ; Create The Sorting GUI & Show It If Option Is Enabled.
	For $A = 1 To $dFiles[0]
		If FileExists($dFiles[$A]) Then
			$Global_MainDir = $dFiles[$A] ; Used Only To Detect Main Folders For %SubDir%.
			$dFailedList = _Position_Check($dFiles[$A], $dProfile, $dFailedList, $dElementsGUI, $dMonitored)
		EndIf
		If @error Then ; _Position_Check() Returns Error Only If Aborted.
			$dFailedList[0] = 0 ; Do Not Show Failed Items If The User Aborts Sorting (The List Results Incomplete).
			ExitLoop
		EndIf
	Next
	_Sorting_DeleteGUI() ; Delete The Sorting GUI.

	; Reset Various Parameters:
	ReDim $Global_OpenedArchives[1][2]
	$Global_OpenedArchives[0][0] = 0
	$Global_OpenedArchives[0][1] = 0
	ReDim $Global_OpenedLists[1][2]
	$Global_OpenedLists[0][0] = 0
	$Global_OpenedLists[0][1] = 0
	ReDim $Global_OpenedPlaylists[1][2]
	$Global_OpenedPlaylists[0][0] = 0
	$Global_OpenedPlaylists[0][1] = 0
	ReDim $Global_PriorityActions[1]
	$Global_PriorityActions[0] = 0
	$Global_Clipboard = ""

	; Report A List Of Failed Sortings:
	If $dFailedList[0] > 0 Then
		Local $dFailedString
		For $A = 1 To $dFailedList[0]
			$dFailedString &= ">> " & $dFailedList[$A] & @CRLF ; Notepad Needs @CRLF Instead Of @LF To Create A New Line.
		Next
		If $dFailedList[0] < 8 Then
			MsgBox(0x40, __Lang_Get('DROP_EVENT_MSGBOX_6', 'Sorting Partially Failed'), __Lang_Get('DROP_EVENT_MSGBOX_7', 'Sorting failed for the following files/folders:') & @LF & $dFailedString, 0, __OnTop())
		Else
			$dMsgBox = MsgBox(0x4, __Lang_Get('DROP_EVENT_MSGBOX_6', 'Sorting Partially Failed'), __Lang_Get('DROP_EVENT_MSGBOX_8', 'Sorting failed for some files/folders.  @LF  Do you want to read a list of them?'), 0, __OnTop())
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

Func _Matches_Checking($cFileName, $cFilePath, $cIsDirectory, $cProfile) ; Returns: Directory [C:\DropItFiles] Or To Associate [0] Or To Skip [-1]
	Local $cMatch, $cCheck, $cAssociation, $cStringSplit, $cAssociations, $cMatches[1][5] = [[0, 5]]

	$cProfile = __IsProfile($cProfile, 0) ; Get Array Of Selected Profile.
	$cAssociations = __GetAssociations($cProfile[1]) ; Get Associations Array For The Current Profile.
	If @error Then
		Return SetError(1, 1, -1)
	EndIf

	For $A = 1 To $cAssociations[0][0]
		$cMatch = 0
		$cAssociation = StringTrimRight($cAssociations[$A][0], 2)

		If $cAssociations[$A][4] <> "Disabled" Then ; Skip Association If It Is Disabled.
			If __Is("UseRegEx") Then
				If StringLeft($cAssociation, 1) <> "^" Then ; ^ = Start String.
					$cAssociation = "^" & $cAssociation
				EndIf
				If StringRight($cAssociation, 1) <> "$" Then ; $ = End String.
					$cAssociation = $cAssociation & "$"
				EndIf
				$cMatch = StringRegExp($cFilePath, $cAssociation)
				If $cMatch = 1 Then
					$cMatch = _Matches_Filter($cFilePath, $cAssociations[$A][3])
				EndIf
			Else
				$cAssociation = StringReplace($cAssociation, "|", ";") ; To Support Both "|" And ";" As Separators.
				$cAssociation = StringReplace($cAssociation, "; ", ";") ; To Support Rules Also If Separated By A Space After Separators.
				$cStringSplit = StringSplit($cAssociation, ";")

				For $B = 1 To $cStringSplit[0]
					$cCheck = ""
					If StringInStr($cStringSplit[$B], "**") Then ; Rule For Folders.
						If $cIsDirectory Then
							$cCheck = "**"
						EndIf
					ElseIf StringInStr($cStringSplit[$B], "*") Then ; Rule For Files.
						If $cIsDirectory = 0 Then
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
							$cMatch = _Matches_Filter($cFilePath, $cAssociations[$A][3])
						EndIf
						If $cMatch = 1 Then
							ExitLoop
						EndIf
					EndIf
				Next
			EndIf

			If $cMatch = 1 And $cMatches[0][0] < 40 Then
				If UBound($cMatches, 1) <= $cMatches[0][0] + 1 Then
					ReDim $cMatches[UBound($cMatches, 1) + 1][5] ; ReSize Array If More Items Are Required.
				EndIf
				$cMatches[0][0] += 1
				$cMatches[$cMatches[0][0]][0] = $cAssociations[$A][0] ; Rule.
				$cMatches[$cMatches[0][0]][1] = $cAssociations[$A][1] ; Destination.
				$cMatches[$cMatches[0][0]][2] = $cAssociations[$A][5] ; List Properties.
				$cMatches[$cMatches[0][0]][3] = $cAssociations[$A][2] ; Association Name.
				$cMatches[$cMatches[0][0]][4] = $cAssociations[$A][6] ; FTP Settings.
			EndIf
		EndIf
	Next

	$cMatch = 0
	If $cMatches[0][0] = 1 Then
		$cMatch = 1
	ElseIf $cMatches[0][0] > 1 Then
		If $Global_PriorityActions[0] > 0 Then ; Automatically Use Priority Action If File Matches With One Of Them.
			If $Global_PriorityActions[1] = "###" Then ; Skip Item If User Selected "Cancel" In Select Action Window.
				$cMatch = 1
				$cMatches[$cMatch][0] = "$2"
			Else
				For $A = 1 To $Global_PriorityActions[0]
					For $B = 1 To $cMatches[0][0]
						If $Global_PriorityActions[$A] == $cMatches[$B][0] Then
							$cMatch = $B
						EndIf
					Next
				Next
			EndIf
		EndIf
		If $cMatch = 0 Then
			$cMatch = _Matches_Select($cMatches, $cFileName)
		EndIf
	EndIf

	If $cMatch > 0 Then
		$Global_Action = StringRight($cMatches[$cMatch][0], 2) ; Set Action For This File/Folder.
		If $Global_Action == "$2" Then ; Ignore Action.
			Return SetError(1, 0, -1)
		ElseIf $Global_Action == "$8" Then ; Create List Action.
			$cMatches[$cMatch][1] &= "|" & $cMatches[$cMatch][2] & "|" & $cProfile[1] & "|" & StringTrimRight($cMatches[$cMatch][0], 2) & "|" & $cMatches[$cMatch][3] ; Add List Properties At The End Of The String.
		ElseIf $Global_Action == "$C" Then ; Upload Action.
			$cMatches[$cMatch][1] &= "|" & $cMatches[$cMatch][4] ; Add FTP Settings At The End Of The String.
		EndIf
		Return $cMatches[$cMatch][1]
	Else
		Return SetError(1, 0, $cMatch)
	EndIf
EndFunc   ;==>_Matches_Checking

Func _Matches_Filter($dFilePath, $dFilters)
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
EndFunc   ;==>_Matches_Filter

Func _Matches_Select($mMatches, $mFileName)
	If IsArray($mMatches) = 0 Then
		Return SetError(1, 0, 0) ; Exit Function If Not An Array.
	EndIf
	Local $mHandle = $Global_GUI_1
	Local $mGUI, $mAction, $mDestination, $mMsg, $mCancel, $mPriority, $mTwoColumns, $mString, $mStringSplit, $mButtons[$mMatches[0][0] + 1] = [0], $mRead = -1
	If $mMatches[0][0] > 14 Then
		$mTwoColumns = 1
	EndIf
	Local $mWidth = 28 + 10 * $mTwoColumns + 300 * ($mTwoColumns + 1)
	Local $mRows = Int(($mMatches[0][0] + $mTwoColumns) / ($mTwoColumns + 1))

	$mGUI = GUICreate(__Lang_Get('MOREMATCHES_GUI', 'Select Action'), $mWidth, 150 + 23 * $mRows, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))
	GUICtrlCreateGraphic(0, 0, $mWidth, 56)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlSetColor(-1, 0xffffff)

	GUICtrlCreateLabel(__Lang_Get('MOREMATCHES_LABEL_0', 'Loaded item:'), 14, 12, 300, 18)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlCreateLabel($mFileName, 16, 12 + 18, 296, 20)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlSetFont(-1, -1, 800)

	GUICtrlCreateLabel(__Lang_Get('MOREMATCHES_LABEL_1', 'Select the action to use:'), 14, 62, 300, 18)
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
					$mDestination = __Lang_Get('DELETE_MODE_1', 'Directly Remove')
			EndSwitch
		ElseIf $mAction == "$B" Then
			Switch $mMatches[$A][1] ; Destination.
				Case 2
					$mDestination = __Lang_Get('CLIPBOARD_MODE_2', 'File Name')
				Case 3
					$mDestination = __Lang_Get('LIST_LABEL_7', 'MD5 Hash')
				Case 4
					$mDestination = __Lang_Get('LIST_LABEL_8', 'SHA-1 Hash')
				Case Else
					$mDestination = __Lang_Get('CLIPBOARD_MODE_1', 'Full Path')
			EndSwitch
		ElseIf $mAction == "$C" Then
			$mStringSplit = StringSplit($mMatches[$A][4], ";")
			$mDestination = $mStringSplit[1] & $mMatches[$A][1]
		EndIf
		$mString = $mMatches[$A][3] & " (" & __GetAssociationString($mAction) & ")" ; __GetAssociationString() = Convert Action Code To Action Name.
		$mString = " " & _WinAPI_PathCompactPathEx($mString, 48)
		$mButtons[$A] = GUICtrlCreateButton($mString, 14 + (300 + 10) * Int($A / ($mRows + 1)), 56 + 23 * $A - (23 * $mRows) * Int($A / ($mRows + 1)), 300, 22, 0x0100)
		GUICtrlSetTip($mButtons[$A], __Lang_Get('NAME', 'Name') & ": " & $mMatches[$A][3] & @LF & _
				__Lang_Get('ACTION', 'Action') & ": " & __GetAssociationString($mAction) & @LF & _
				__Lang_Get('DESTINATION', 'Destination') & ": " & $mDestination)
		$mButtons[0] += 1
	Next

	$mCancel = GUICtrlCreateButton(__Lang_Get('CANCEL', 'Cancel'), ($mWidth / 2) - 50, 90 + 23 * $mRows, 100, 25)
	$mPriority = GUICtrlCreateCheckbox(__Lang_Get('MOREMATCHES_LABEL_2', 'Apply to all ambiguities of this drop'), 14, 125 + 23 * $mRows, 318, 20)
	If __Is("AmbiguitiesCheck") Then
		GUICtrlSetState($mPriority, $GUI_CHECKED)
	EndIf
	GUISetState(@SW_SHOW)

	;msgbox(0, "test", "test") ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< why it solve the issue ??
	While 1
		$mMsg = GUIGetMsg()
		Switch $mMsg
			Case $GUI_EVENT_CLOSE, $mCancel
				$mRead = -1
				If GUICtrlRead($mPriority) = 1 And $mMsg = $mCancel Then ; Save Priority Action If Selected.
					$Global_PriorityActions[0] = 1
					ReDim $Global_PriorityActions[2]
					$Global_PriorityActions[1] = "###"
				EndIf
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
EndFunc   ;==>_Matches_Select

Func _Position_Check($pFilePath, $pProfile, $pFailedList, $pElementsGUI, $pMonitored = 0)
	Local $pSearch, $pFileName, $pFailedFile, $pMultiplePosition = 0, $pWildcards = ""

	If _WinAPI_PathIsDirectory($pFilePath) Then
		If __Is("DirForFolders", -1, "False", $pProfile) = 0 Then
			$pMultiplePosition = 1
			$pWildcards = "*.*"
		ElseIf $pMonitored Then
			$pMultiplePosition = 2
			$pWildcards = "*.*"
		EndIf
	Else
		$pFileName = __GetFileName($pFilePath) ; File Or Folder Name.
		If StringInStr($pFileName, "*") Then
			$pMultiplePosition = 1
			$pWildcards = $pFileName
			$pFilePath = __GetParentFolder($pFilePath) ; Parent Path.
		EndIf
	EndIf

	If $pMultiplePosition > 0 Then
		$pSearch = FileFindFirstFile($pFilePath & "\" & $pWildcards) ; Load Files.
		While 1
			$pFileName = FileFindNextFile($pSearch)
			If @error Then
				ExitLoop
			EndIf
			If _WinAPI_PathIsDirectory($pFilePath & "\" & $pFileName) = 0 Or $pMultiplePosition = 2 Then
				$pFailedFile = _Position_Process($pFilePath & "\" & $pFileName, $pProfile, $pElementsGUI) ; If Selected Is Not A Directory Then Process The File.
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
					$pFailedList = _Position_Check($pFilePath & "\" & $pFileName, $pProfile, $pFailedList, $pElementsGUI) ; If Selected Is A Directory Then Process The Directory.
					If @error Then ; _Position_Check() Returns Error Only If Aborted.
						FileClose($pSearch)
						Return SetError(1, 0, $pFailedList) ; Immediately Return If Sorting Aborted.
					EndIf
				EndIf
			WEnd
			FileClose($pSearch)
		EndIf
	Else
		$pFailedFile = _Position_Process($pFilePath, $pProfile, $pElementsGUI)
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
EndFunc   ;==>_Position_Check

Func _Position_EnvVars($pDestination, $pFilePath, $pProfile)
	Local $pLoadedProperty, $pTimeArray[6]
	Local $pProfileArray = __IsProfile($pProfile, 0) ; Get Array Of Selected Profile.
	Local $pEnvArray[57][3] = [ _
			[56, 0, 0], _
			["FileExt", 0, __GetFileExtension($pFilePath)], _
			["FileName", 0, __GetFileNameOnly($pFilePath)], _
			["FileNameExt", 0, __GetFileName($pFilePath)], _
			["ParentDir", 0, __GetParentFolder($pFilePath)], _
			["ParentDirName", 0, __GetFileName(__GetParentFolder($pFilePath))], _
			["SubDir", 0, StringTrimLeft(__GetParentFolder($pFilePath), StringLen($Global_MainDir))], _
			["ProfileName", 0, $pProfileArray[1]], _
			["FileAuthor", 1, 12], _
			["FileType", 1, 2], _
			["CameraModel", 1, 11], _
			["Dimensions", 1, 10], _
			["SongAlbum", 1, 15], _
			["SongArtist", 1, 13], _
			["SongGenre", 1, 16], _
			["SongNumber", 1, 18], _
			["SongTitle", 1, 14], _
			["SongYear", 1, 17], _
			["CurrentDate", 0, @YEAR & "-" & @MON & "-" & @MDAY], _
			["CurrentYear", 0, @YEAR], _
			["CurrentMonth", 0, @MON], _
			["CurrentDay", 0, @MDAY], _
			["CurrentTime", 0, @HOUR & "." & @MIN], _
			["CurrentHour", 0, @HOUR], _
			["CurrentMinute", 0, @MIN], _
			["CurrentSecond", 0, @SEC], _
			["DateCreated", 2, 1], _
			["YearCreated", 2, 1], _
			["MonthCreated", 2, 1], _
			["DayCreated", 2, 1], _
			["TimeCreated", 2, 1], _
			["HourCreated", 2, 1], _
			["MinuteCreated", 2, 1], _
			["SecondCreated", 2, 1], _
			["DateModified", 2, 0], _
			["YearModified", 2, 0], _
			["MonthModified", 2, 0], _
			["DayModified", 2, 0], _
			["TimeModified", 2, 0], _
			["HourModified", 2, 0], _
			["MinuteModified", 2, 0], _
			["SecondModified", 2, 0], _
			["DateOpened", 2, 2], _
			["YearOpened", 2, 2], _
			["MonthOpened", 2, 2], _
			["DayOpened", 2, 2], _
			["TimeOpened", 2, 2], _
			["HourOpened", 2, 2], _
			["MinuteOpened", 2, 2], _
			["SecondOpened", 2, 2], _
			["DateTaken", 2, 9], _
			["YearTaken", 2, 9], _
			["MonthTaken", 2, 9], _
			["DayTaken", 2, 9], _
			["TimeTaken", 2, 9], _
			["HourTaken", 2, 9], _
			["MinuteTaken", 2, 9]]

	For $A = 1 To $pEnvArray[0][0]
		If StringInStr($pDestination, "%" & $pEnvArray[$A][0] & "%") Then ; Do It Only If Current Environment Variable Is Used.
			Switch $pEnvArray[$A][1]
				Case 0
					$pLoadedProperty = $pEnvArray[$A][2]
				Case 1
					$pLoadedProperty = __GetFileProperties($pFilePath, $pEnvArray[$A][2])
				Case 2
					$pLoadedProperty = ""
					If $pEnvArray[$A][2] = 9 Then
						$pTimeArray = __DateTimeStandard(__GetFileProperties($pFilePath, $pEnvArray[$A][2]))
					Else
						$pTimeArray = FileGetTime($pFilePath, $pEnvArray[$A][2])
					EndIf
					If IsArray($pTimeArray) Then
						If StringInStr($pEnvArray[$A][0], "Date") Then
							$pLoadedProperty = $pTimeArray[0] & "-" & $pTimeArray[1] & "-" & $pTimeArray[2] ; YYYY-MM-DD.
						ElseIf StringInStr($pEnvArray[$A][0], "Time") Then
							$pLoadedProperty = $pTimeArray[3] & "." & $pTimeArray[4] ; HH.MM.
						ElseIf StringInStr($pEnvArray[$A][0], "Year") Then
							$pLoadedProperty = $pTimeArray[0] ; YYYY.
						ElseIf StringInStr($pEnvArray[$A][0], "Month") Then
							$pLoadedProperty = $pTimeArray[1] ; MM.
						ElseIf StringInStr($pEnvArray[$A][0], "Day") Then
							$pLoadedProperty = $pTimeArray[2] ; DD.
						ElseIf StringInStr($pEnvArray[$A][0], "Hour") Then
							$pLoadedProperty = $pTimeArray[3] ; HH.
						ElseIf StringInStr($pEnvArray[$A][0], "Minute") Then
							$pLoadedProperty = $pTimeArray[4] ; MM.
						ElseIf StringInStr($pEnvArray[$A][0], "Second") Then
							$pLoadedProperty = $pTimeArray[5] ; SS.
						EndIf
					EndIf
			EndSwitch
			If $pLoadedProperty == "" And $pEnvArray[$A][0] <> "SubDir" Then
				$pLoadedProperty = $pEnvArray[$A][0]
			EndIf
			$pDestination = StringReplace($pDestination, "%" & $pEnvArray[$A][0] & "%", $pLoadedProperty)
		EndIf
	Next

	Return $pDestination
EndFunc   ;==>_Position_EnvVars

Func _Position_Process($pFilePath, $pProfile, $pElementsGUI)
	Local $pFileName, $pFileExtension, $pCurrentSize, $pIsDirectory, $pDestination, $pSortFailed

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

	; Check If An Association Matches:
	$pDestination = _Matches_Checking($pFileName, $pFilePath, $pIsDirectory, $pProfile) ; Destination If OK, 0 To Associate, -1 To Skip.
	If $pDestination == 0 Then
		If __Is("IgnoreNew", -1, "False", $pProfile) Then
			GUICtrlSetData($pElementsGUI[2], __GetPercent($pCurrentSize)) ; Force Update Progress Bar.
			__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_2', 'Not Sorted'), __Lang_Get('POSITIONPROCESS_LOGMSG_0', 'Skipped'))
			Return SetError(1, 0, 1) ; 1 = Skipped.
		Else
			Switch MsgBox(0x03, __Lang_Get('POSITIONPROCESS_MSGBOX_0', 'Association Needed'), __Lang_Get('POSITIONPROCESS_MSGBOX_1', 'No association found for:') & @LF & $pFilePath & @LF & @LF & __Lang_Get('POSITIONPROCESS_MSGBOX_2', 'Do you want to create an association for it?'), 0, __OnTop())
				Case 6 ; Yes.
					If _Manage_Edit_GUI($pProfile, __GetFileNameOnly($pFileName), $pFileExtension, -1, -1, -1, -1, 1, 1) <> 0 Then ; _Manage_Edit_GUI() = Show Manage Edit GUI Of Selected Association.
						$pDestination = _Matches_Checking($pFileName, $pFilePath, $pIsDirectory, $pProfile) ; Destination If OK, 0 To Abort, -1 To Skip.
					EndIf
				Case 7 ; No.
					$pDestination = -1
				Case Else ; Abort.
					$pDestination = 0
			EndSwitch
		EndIf
	EndIf
	If $pDestination == 0 Or $pDestination == -1 Or $pDestination = "" Then
		GUICtrlSetData($pElementsGUI[2], __GetPercent($pCurrentSize)) ; Force Update Progress Bar.
		If $pDestination == -1 Then
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
			$pDestination = StringReplace($pDestination, ".%FileExt%", "") ; Remove File Extension Environment Variable.
			$pDestination = StringReplace($pDestination, "%FileExt%", "") ; Remove File Extension Environment Variable.
			$pDestination = StringReplace($pDestination, "%FileName%", "%FileNameExt%") ; To Correctly Load Name.
		ElseIf StringInStr($pDestination, ".") = 0 Then
			$pDestination &= ".%FileExt%" ; Add File Extension If Not Defined.
		EndIf
	EndIf

	; Substitute Abbreviations:
	If StringInStr($pDestination, "%") Then
		$pDestination = _Position_EnvVars($pDestination, $pFilePath, $pProfile)
	EndIf

	; Update Destination For Rename Action:
	If $Global_Action == "$7" Then
		$pFileName = $pDestination
		$pDestination = __GetParentFolder($pFilePath)
	EndIf

	; Update Relative Destination For Compress, Create List And Create Playlist Actions:
	If StringInStr("$3" & "$8" & "$9", $Global_Action) And StringInStr($pDestination, "\") = 0 Then
		$pDestination = _WinAPI_GetFullPathName(__GetParentFolder($pFilePath) & "\" & $pDestination)
	EndIf

	; Destination Folder Creation:
	If StringInStr("$0" & "$1" & "$4" & "$7" & "$A", $Global_Action) And FileExists($pDestination) = 0 Then
		Local $pIsDirectoryCreated = DirCreate($pDestination)
		If $pIsDirectoryCreated = 0 Then
			MsgBox(0x40, __Lang_Get('POSITIONPROCESS_MSGBOX_3', 'Destination Folder Problem'), __Lang_Get('POSITIONPROCESS_MSGBOX_4', 'Sorting operation has been partially skipped.  @LF  The following destination folder does not exist and cannot be created:') & @LF & _WinAPI_PathCompactPathEx($pDestination, 65), 0, __OnTop())
			GUICtrlSetData($pElementsGUI[2], __GetPercent($pCurrentSize)) ; Force Update Progress Bar.
			__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_2', 'Not Sorted'), __Lang_Get('POSITIONPROCESS_LOGMSG_2', 'Failed'))
			Return SetError(1, 0, $pFileName)
		EndIf
	EndIf

	; Update File Name For Compress, Extract And Create Shortcut Actions:
	If $Global_Action == "$3" And _WinAPI_PathIsDirectory($pDestination) Then
		$pDestination &= "\" & __GetFileNameOnly($pFileName) & ".zip" ; To Work Also If Destination Is A Directory.
	ElseIf $Global_Action == "$4" Then
		$pFileName = __GetFileNameOnly($pFileName) ; Save The Name Of The Extraction Output Folder.
		$pIsDirectory = 1 ; Needed To Correctly Rename Eventual Duplicates.
	ElseIf $Global_Action == "$A" Then
		$pFileName &= " - " & __Lang_Get('SHORTCUT', 'shortcut') & ".lnk"
	EndIf

	; Manage Duplicates:
	If StringInStr("$0" & "$1" & "$4" & "$7" & "$A", $Global_Action) Then
		If FileExists($pDestination & "\" & $pFileName) Then
			$pFileName = _Duplicate_Process($pFilePath, $pProfile, $pDestination, $pFileName)
			If @error = 1 Then ; Skip.
				__ExpandEventMode(0) ; Disable The Abort Button.
				GUICtrlSetData($pElementsGUI[2], __GetPercent($pCurrentSize)) ; Force Update Progress Bar.
				__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_2', 'Not Sorted'), __Lang_Get('POSITIONPROCESS_LOGMSG_0', 'Skipped'))
				Return SetError(1, 0, 1) ; 1 = Skipped.
			EndIf
		EndIf
		$pDestination &= "\" & $pFileName
	EndIf

	__ExpandEventMode(1) ; Enable The Abort Button.
	$pDestination = _Sorting_Process($pFilePath, $pDestination, $pElementsGUI, $pProfile)
	$pSortFailed = @error
	__ExpandEventMode(0) ; Disable The Abort Button.

	; Process Log For This Item:
	If $pSortFailed > 0 Then
		GUICtrlSetData($pElementsGUI[2], __GetPercent($pCurrentSize)) ; Force Update Progress Bar.
		If $pSortFailed = 2 Then
			__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_2', 'Not Sorted'), __Lang_Get('POSITIONPROCESS_LOGMSG_0', 'Skipped'))
			Return SetError(1, 0, 1) ; 1 = Skipped.
		ElseIf $Global_AbortSorting Then
			__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_2', 'Not Sorted'), __Lang_Get('POSITIONPROCESS_LOGMSG_1', 'Aborted'))
			Return SetError(1, 0, 0) ; 0 = Aborted.
		Else
			__Log_Write(__Lang_Get('POSITIONPROCESS_LOG_2', 'Not Sorted'), __Lang_Get('POSITIONPROCESS_LOGMSG_2', 'Failed'))
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
				$pSyntaxMode = __Lang_Get('POSITIONPROCESS_LOG_10', 'Added to List')
			Case "$9"
				$pSyntaxMode = __Lang_Get('POSITIONPROCESS_LOG_13', 'Added to Playlist')
			Case "$A"
				$pSyntaxMode = __Lang_Get('POSITIONPROCESS_LOG_11', 'Shortcut Created')
			Case "$B"
				$pSyntaxMode = __Lang_Get('POSITIONPROCESS_LOG_12', 'Copied to Clipboard')
			Case Else
				$pSyntaxMode = __Lang_Get('POSITIONPROCESS_LOG_5', 'Moved')
		EndSwitch
		__Log_Write($pSyntaxMode, $pDestination)
	EndIf

	Return 1
EndFunc   ;==>_Position_Process

Func _Duplicate_Alert($dItem)
	Local $dGUI, $dButtonOverwrite, $dButtonRename, $dButtonSkip, $dCheckForAll, $dValue

	$dGUI = GUICreate(__Lang_Get('POSITIONPROCESS_DUPLICATE_0', 'Item Already Exists'), 360, 135, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($Global_SortingGUI))
	GUICtrlCreateGraphic(0, 0, 360, 68)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlSetColor(-1, 0xffffff)

	GUICtrlCreateLabel(__Lang_Get('POSITIONPROCESS_DUPLICATE_1', 'This item already exists in destination folder:'), 14, 12, 328, 18)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlCreateLabel($dItem, 16, 12 + 18, 324, 36)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlSetFont(-1, -1, 800)

	$dButtonOverwrite = GUICtrlCreateButton(__Lang_Get('DUPLICATE_MODE_0', 'Overwrite'), 180 - 65 - 84, 76, 88, 25)
	$dButtonRename = GUICtrlCreateButton(__Lang_Get('DUPLICATE_MODE_2', 'Rename'), 180 - 42, 76, 88, 25)
	$dButtonSkip = GUICtrlCreateButton(__Lang_Get('DUPLICATE_MODE_6', 'Skip'), 180 + 65, 76, 88, 25)
	GUICtrlSetState($dButtonSkip, $GUI_DEFBUTTON)
	$dCheckForAll = GUICtrlCreateCheckbox(__Lang_Get('POSITIONPROCESS_DUPLICATE_2', 'Apply to all duplicates of this drop'), 14, 110, 328, 20)
	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $dButtonSkip
				$dValue = "Skip"
				ExitLoop

			Case $dButtonOverwrite
				$dValue = "Overwrite1"
				ExitLoop

			Case $dButtonRename
				$dValue = "Rename1"
				ExitLoop

		EndSwitch
	WEnd
	If GUICtrlRead($dCheckForAll) = 1 Then
		$Global_DuplicateMode = $dValue
	EndIf
	GUIDelete($dGUI)

	Return $dValue
EndFunc   ;==>_Duplicate_Alert

Func _Duplicate_Process($dFilePath, $dProfile, $dDestination = -1, $dFileName = -1)
	Local $dINI, $dIsDirectory, $dDupMode = "Skip"

	If _WinAPI_PathIsDirectory($dFilePath) Then
		$dIsDirectory = 1
	EndIf
	If $dDestination = -1 Then ; New Output Creation.
		$dDestination = __GetParentFolder($dFilePath)
		$dFileName = __GetFileName($dFilePath)
	EndIf

	If __Is("AutoDup", -1, "False", $dProfile) Then
		$dINI = __IsProfile($dProfile, 1) ; Get Profile Path Of Selected Profile.
		If IniRead($dINI, "General", "AutoDup", "Default") == "Default" Then
			$dINI = __IsSettingsFile() ; Get Default Settings INI File.
		EndIf
		$dDupMode = IniRead($dINI, "General", "DupMode", "Skip")
	Else
		If $Global_DuplicateMode <> "" Then
			$dDupMode = $Global_DuplicateMode
		Else
			__ExpandEventMode(0) ; Disable The Abort Button.
			$dDupMode = _Duplicate_Alert($dFileName)
			__ExpandEventMode(1) ; Enable The Abort Button.
		EndIf
	EndIf
	If StringInStr($dDupMode, 'Skip') Or (StringInStr($dDupMode, 'Overwrite2') And __FileCompareDate($dFilePath, $dDestination & "\" & $dFileName) <> 1) Or (StringInStr($dDupMode, 'Overwrite3') And __FileCompareSize($dFilePath, $dDestination & "\" & $dFileName) = 0) Then
		Return SetError(1, 0, $dFileName) ; Error Needed To Skip.
	EndIf
	If StringInStr($dDupMode, 'Overwrite') Then
		Return SetError(2, 0, $dFileName) ; Error Needed To Overwrite.
	EndIf
	If StringInStr($dDupMode, 'Rename') Then
		$dFileName = _Duplicate_Rename($dFileName, $dDestination, $dIsDirectory, StringRight($dDupMode, 1))
	EndIf

	Return $dFileName
EndFunc   ;==>_Duplicate_Process

Func _Duplicate_ProcessOnline($dFilePath, $dProfile, $dRemoteDate, $dRemoteSize, $dListArray, $dProtocol = "FTP")
	Local $dINI, $dFileName, $dIsDirectory, $dDupMode = ""

	If _WinAPI_PathIsDirectory($dFilePath) Then
		$dIsDirectory = 1
	EndIf
	$dFileName = __GetFileName($dFilePath)

	If __Is("AutoDup", -1, "False", $dProfile) Then
		$dINI = __IsProfile($dProfile, 1) ; Get Profile Path Of Selected Profile.
		If IniRead($dINI, "General", "AutoDup", "Default") == "Default" Then
			$dINI = __IsSettingsFile() ; Get Default Settings INI File.
		EndIf
		$dDupMode = IniRead($dINI, "General", "DupMode", "Skip")
	EndIf
	If StringInStr($dDupMode, 'Overwrite2') And $dProtocol = "SFTP" Then
		MsgBox(0x40, __Lang_Get('DUPLICATE_MSGBOX_0', 'Manual selection needed'), __Lang_Get('DUPLICATE_MSGBOX_1', 'SFTP protocol currently does not support "Overwrite if newer".  @LF  You need to manually select how to manage this duplicate.'), 0, __OnTop())
		$dDupMode = ""
	EndIf
	If $dDupMode = "" Then
		If $Global_DuplicateMode <> "" Then
			$dDupMode = $Global_DuplicateMode
		Else
			__ExpandEventMode(0) ; Disable The Abort Button.
			$dDupMode = _Duplicate_Alert($dFileName)
			__ExpandEventMode(1) ; Enable The Abort Button.
		EndIf
	EndIf

	If StringInStr($dDupMode, 'Skip') Or (StringInStr($dDupMode, 'Overwrite2') And __FileCompareDate($dFilePath, $dRemoteDate, 1) <> 1) Or (StringInStr($dDupMode, 'Overwrite3') And __FileCompareSize($dFilePath, $dRemoteSize, 1) = 0) Then
		Return SetError(1, 0, $dFileName) ; Error Needed To Skip.
	EndIf
	If StringInStr($dDupMode, 'Rename') Then
		$dFileName = _Duplicate_Rename($dFileName, $dListArray, $dIsDirectory, StringRight($dDupMode, 1))
	EndIf

	Return $dFileName
EndFunc   ;==>_Duplicate_ProcessOnline

Func _Duplicate_Rename($dFileName, $dDestination, $dIsDirectory = 0, $dStyle = 1)
	Local $dNumber, $dFileExt, $dExists, $dIsArray = 0, $A = 1
	Local $sFileString = $dFileName

	If IsArray($dDestination) Then
		$dIsArray = 1
	Else
		If $dDestination <> "" Then
			$dDestination &= "\"
		EndIf
	EndIf

	If $dIsDirectory = 0 Then ; If Is A File.
		$dFileExt = __GetFileExtension($sFileString)
		If $dFileExt <> "" Then
			$dFileExt = "." & $dFileExt ; To Add It Only If Is A File With Extension.
		EndIf
		$sFileString = StringTrimRight($sFileString, StringLen($dFileExt))
	EndIf

	While 1
		If $A < 10 Then
			$dNumber = 0 & $A ; Create 01, 02, 03, 04, 05 Till 09.
		Else
			$dNumber = $A ; Create 10, 11, 12, 13, 14, Etc.
		EndIf
		Switch $dStyle
			Case 2
				$dFileName = $sFileString & "_" & $dNumber
			Case 3
				$dFileName = $sFileString & " (" & $dNumber & ")"
			Case Else
				$dFileName = $sFileString & " " & $dNumber
		EndSwitch
		If $dIsDirectory = 0 Then ; If Is A File.
			$dFileName &= $dFileExt
		EndIf

		If $dIsArray Then
			$dExists = 0
			For $B = 1 To $dDestination[0][0]
				If $dFileName = $dDestination[$B][0] Then
					$dExists = 1
				EndIf
			Next
			If $dExists = 0 Then
				ExitLoop
			EndIf
		Else
			If FileExists($dDestination & $dFileName) = 0 Then
				ExitLoop
			EndIf
		EndIf
		$A += 1
	WEnd

	Return $dFileName
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
	$Global_AbortButton = GUICtrlCreateButton(__Lang_Get('POSITIONPROCESS_2', 'Abort'), 200 - 45, 106, 90, 25)
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

Func _Sorting_ArchiveFile($sSource, $sArchiveFile, $sElementsGUI, $sProfile, $sSize, $sType)
	Local $sLabel_2 = $sElementsGUI[1], $sProgress_1 = $sElementsGUI[2], $sProgress_2 = $sElementsGUI[3]
	Local $sPercent, $sProcess, $sDecrypt_Password = "", $sNewArchiveFile = ""

	GUICtrlSetData($sLabel_2, _WinAPI_PathCompactPathEx($sArchiveFile, 68))
	GUICtrlSetData($sProgress_2, 0)

	If $sType = 1 Then ; Extract Mode.
		$sProcess = __7ZipRun($sSource, $sArchiveFile, 2) ; Check If Archive Is Encrypted.
		Switch @error
			Case 1 ; Failed.
				Return SetError(1, 0, 0)
			Case 2 ; Password Needed.
				__ExpandEventMode(0) ; Disable The Abort Button.
				$sDecrypt_Password = __InsertPassword(_WinAPI_PathCompactPathEx(__GetFileName($sSource), 68))
				__ExpandEventMode(1) ; Enable The Abort Button.
				If $sDecrypt_Password = -1 Then
					Return SetError(1, 0, 0)
				EndIf
		EndSwitch
	ElseIf $sType = 3 Then ; Compress Action (With Update Archive Support).
		If $Global_OpenedArchives[0][0] > 0 Then ; Some Archives Are Already Opened In This Drop.
			For $A = 1 To $Global_OpenedArchives[0][0]
				If $sArchiveFile = $Global_OpenedArchives[$A][0] Then
					$sNewArchiveFile = $Global_OpenedArchives[$A][1] ; Load Archive Name Of This Drop.
					ExitLoop
				EndIf
			Next
		EndIf
		If $sNewArchiveFile = "" Then ; Archive Is Opening Now.
			$Global_OpenedArchives[0][0] += 1
			ReDim $Global_OpenedArchives[$Global_OpenedArchives[0][0] + 1][2]
			$Global_OpenedArchives[$Global_OpenedArchives[0][0]][0] = $sArchiveFile ; Original Archive Name.
			$sNewArchiveFile = $sArchiveFile
			If FileExists($sNewArchiveFile) Then
				$sNewArchiveFile = __GetParentFolder($sArchiveFile) & "\" & _Duplicate_Process($sArchiveFile, $sProfile)
				Switch @error
					Case 1 ; To Skip Also All Next Files.
						$sNewArchiveFile = "###"
					Case 2 ; To Overwrite Destination File.
						If _WinAPI_PathIsDirectory($sArchiveFile) Then
							DirRemove($sArchiveFile, 1)
						Else
							FileDelete($sArchiveFile)
						EndIf
				EndSwitch
			EndIf
			$Global_OpenedArchives[$Global_OpenedArchives[0][0]][1] = $sNewArchiveFile
		EndIf
		If $sNewArchiveFile = "###" Then
			Return SetError(2, 0, 0) ; Skipped.
		EndIf
		$sArchiveFile = $sNewArchiveFile
		GUICtrlSetData($sLabel_2, _WinAPI_PathCompactPathEx($sArchiveFile, 68)) ; Update Destination.
	EndIf

	$sProcess = __7ZipRun($sSource, $sArchiveFile, $sType, 1, 1, $sDecrypt_Password)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	Sleep(50) ; Needed, Otherwise Progress Bar Could Be Not Updated.
	If $sDecrypt_Password <> "" Then
		Sleep(400) ; Needed, Otherwise Process Could Be Not Ends.
	EndIf

	Local $sPercentHandle = __7Zip_OpenPercent($sProcess), $sPreviousPercent = -1
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
			ProcessClose($sProcess)
			ProcessWaitClose($sProcess)
			FileDelete($sArchiveFile)
			Return SetError(1, 0, 0)
		EndIf

		If ProcessExists($sProcess) = 0 Then
			__7Zip_ClosePercent($sPercentHandle)
			GUICtrlSetData($sProgress_2, 100)
			ExitLoop
		EndIf
	WEnd
	GUICtrlSetData($sProgress_1, __GetPercent($sSize))

	If FileExists($sArchiveFile) = 0 Or ($sType = 1 And $sSize > 0 And DirGetSize($sArchiveFile) < 1) Then
		DirRemove($sArchiveFile, 1) ; Remove If File Is Corrupted Because Extracted With Not Correct Password.
		If $sDecrypt_Password <> "" Then
			MsgBox(0x30, __Lang_Get('PASSWORD_MSGBOX_1', 'Password Not Correct'), __Lang_Get('PASSWORD_MSGBOX_3', 'You have to enter the correct password to extract this archive.'), 0, __OnTop())
		EndIf
		Return SetError(1, 0, 0)
	EndIf

	Return $sArchiveFile
EndFunc   ;==>_Sorting_ArchiveFile

Func _Sorting_ChangeFile($sSource, $sProperties, $sElementsGUI, $sSize)
	Local $sLabel_2 = $sElementsGUI[1], $sProgress_1 = $sElementsGUI[2], $sProgress_2 = $sElementsGUI[3]
	Local $B, $sStringSplit, $sAttributes, $sNewAttribute, $sReadOnly, $sFileTime[3]

	$sAttributes = FileGetAttrib($sSource)
	$sStringSplit = StringSplit($sProperties, ";") ; {modified} YYYYMMDD;HHMMSS;0d; {created} YYYYMMDD;HHMMSS;0d; {opened} YYYYMMDD;HHMMSS;0d; {attributes} A0;H0;R0;S0;T0
	GUICtrlSetData($sLabel_2, __Lang_Get('ACTION_CHANGE_PROPERTIES', 'Change Properties'))
	GUICtrlSetData($sProgress_2, 0)

	If __IsReadOnly($sSource) Then
		$sReadOnly = 1
		FileSetAttrib($sSource, '-R')
	EndIf

	For $A = 0 To 2 ; Modified, Created, Opened.
		$B = 3 * $A + 1

		$sFileTime[$A] = FileGetTime($sSource, $A, 1)
		If StringLen($sStringSplit[$B]) <> 0 Then ; Date [YYYYMMDD].
			$sFileTime[$A] = $sStringSplit[$B] & StringRight($sFileTime[$A], 6)
		EndIf
		If StringLen($sStringSplit[$B + 1]) <> 0 Then ; Time [HHMMSS].
			$sFileTime[$A] = StringLeft($sFileTime[$A], 8) & $sStringSplit[$B + 1]
		EndIf
		If StringLen($sStringSplit[$B + 2]) <> 0 Then ; Add [-3d].
			$sFileTime[$A] = StringRegExpReplace($sFileTime[$A], "(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})", "$1/$2/$3 $4:$5:$6")
			$sFileTime[$A] = _DateAdd(StringRight($sStringSplit[$B + 2], 1), StringTrimRight($sStringSplit[$B + 2], 1), $sFileTime[$A])
			$sFileTime[$A] = StringRegExpReplace($sFileTime[$A], "[^0-9]", "")
		EndIf

		If FileSetTime($sSource, $sFileTime[$A], $A) = 0 Then
			Return SetError(1, 0, 0)
		EndIf
	Next

	If $sReadOnly = 1 Then
		FileSetAttrib($sSource, '+R')
	EndIf

	For $A = 1 To 5 ; Archive, Hidden, Read-Only, System, Temporary.
		$sNewAttribute = StringLeft($sStringSplit[$A + 9], 1)

		Switch Number(StringRight($sStringSplit[$A + 9], 1))
			Case 1 ; Turn On.
				$sNewAttribute = "+" & $sNewAttribute
			Case 2 ; Turn Off.
				$sNewAttribute = "-" & $sNewAttribute
			Case 3 ; Switch.
				If StringInStr($sAttributes, $sNewAttribute) Then
					$sNewAttribute = "-" & $sNewAttribute
				Else
					$sNewAttribute = "+" & $sNewAttribute
				EndIf
			Case Else ; No Change.
				ContinueLoop
		EndSwitch

		If FileSetAttrib($sSource, $sNewAttribute) = 0 Then
			Return SetError(1, 0, 0)
		EndIf
	Next

	GUICtrlSetData($sProgress_2, 100)
	GUICtrlSetData($sProgress_1, __GetPercent($sSize))

	Return 1
EndFunc   ;==>_Sorting_ChangeFile

Func _Sorting_ClipboardFile($sSource, $sClipboardMode, $sElementsGUI, $sSize)
	Local $sLabel_2 = $sElementsGUI[1], $sProgress_1 = $sElementsGUI[2], $sProgress_2 = $sElementsGUI[3]
	Local $sToCopy, $sClipboardText

	Switch $sClipboardMode
		Case 2
			$sClipboardText = __Lang_Get('CLIPBOARD_MODE_2', 'File Name')
			$sToCopy = __GetFileName($sSource)
		Case 3
			$sClipboardText = __Lang_Get('LIST_LABEL_7', 'MD5 Hash')
			$sToCopy = __MD5ForFile($sSource) & " = " & __GetFileName($sSource)
		Case 4
			$sClipboardText = __Lang_Get('LIST_LABEL_8', 'SHA-1 Hash')
			$sToCopy = __SHA1ForFile($sSource) & " = " & __GetFileName($sSource)
		Case Else
			$sClipboardText = __Lang_Get('CLIPBOARD_MODE_1', 'Full Path')
			$sToCopy = $sSource
	EndSwitch
	GUICtrlSetData($sLabel_2, __Lang_Get('ACTION_CLIPBOARD', 'Copy to Clipboard') & ": " & $sClipboardText)
	GUICtrlSetData($sProgress_2, 0)

	If $Global_Clipboard <> "" Then
		$Global_Clipboard &= @CRLF
	EndIf
	$Global_Clipboard &= $sToCopy
	ClipPut($Global_Clipboard)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	GUICtrlSetData($sProgress_2, 100)
	GUICtrlSetData($sProgress_1, __GetPercent($sSize))

	Return $sClipboardText
EndFunc   ;==>_Sorting_ClipboardFile

Func _Sorting_CopyFile($sSource, $sDestination, $sElementsGUI)
	Local $sLabel_2 = $sElementsGUI[1], $sProgress_1 = $sElementsGUI[2], $sProgress_2 = $sElementsGUI[3]
	Local $sPercent, $sState, $sMD5_Before, $sMD5_After

	If FileExists($sDestination) Then
		FileSetAttrib($sDestination, '-RH') ; Needed To Overwrite Hidden And Read-Only Files/Folders.
	EndIf
	If __Is("IntegrityCheck") Then
		$sMD5_Before = __MD5ForFile($sSource)
	EndIf

	GUICtrlSetData($sLabel_2, _WinAPI_PathCompactPathEx(__GetParentFolder($sDestination), 68))
	GUICtrlSetData($sProgress_2, 0)

	Do
		If $Global_Action == "$0" Then
			If _Copy_MoveFile($sSource, $sDestination, 0x0003) = 0 Then ; 0x0003 = $MOVE_FILE_COPY_ALLOWED + $MOVE_FILE_REPLACE_EXISTING.
				Return SetError(1, 0, 0)
			EndIf
		Else
			If _Copy_CopyFile($sSource, $sDestination) = 0 Then
				Return SetError(1, 0, 0)
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
				If $sState[5] <> 0 Then
					Return SetError(1, 0, 0)
				EndIf
				GUICtrlSetData($sProgress_2, 100)
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

Func _Sorting_DeleteFile($sSource, $sDeletionMode, $sElementsGUI, $sSize)
	Local $sLabel_2 = $sElementsGUI[1], $sProgress_1 = $sElementsGUI[2], $sProgress_2 = $sElementsGUI[3]
	Local $sDeleteText

	If __IsReadOnly($sSource) Then
		FileSetAttrib($sSource, '-R')
	EndIf

	Switch $sDeletionMode
		Case 2
			$sDeleteText = __Lang_Get('DELETE_MODE_2', 'Safely Erase')
		Case 3
			$sDeleteText = __Lang_Get('DELETE_MODE_3', 'Send to Recycle Bin')
		Case Else
			$sDeleteText = __Lang_Get('DELETE_MODE_1', 'Directly Remove')
	EndSwitch
	GUICtrlSetData($sLabel_2, __Lang_Get('ACTION_DELETE', 'Delete') & ": " & $sDeleteText)
	GUICtrlSetData($sProgress_2, 0)

	If __Is("AlertDelete") Then
		Local $sMsgBox = MsgBox(0x4, __Lang_Get('DROP_EVENT_MSGBOX_10', 'Delete item'), __Lang_Get('MOREMATCHES_LABEL_0', 'Loaded item:') & @LF & __GetFileName($sSource) & @LF & @LF & __Lang_Get('DROP_EVENT_MSGBOX_11', 'Are you sure to delete this item?'), 0, __OnTop())
		If $sMsgBox <> 6 Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf
	If _WinAPI_PathIsDirectory($sSource) Then
		Switch $sDeletionMode
			Case 2
				__SecureFolderDelete($sSource)
			Case 3
				FileRecycle($sSource)
			Case Else
				DirRemove($sSource, 1)
		EndSwitch
	Else
		Switch $sDeletionMode
			Case 2
				__SecureFileDelete($sSource)
			Case 3
				FileRecycle($sSource)
			Case Else
				FileDelete($sSource)
		EndSwitch
	EndIf
	If @error Or FileExists($sSource) Then
		Return SetError(1, 0, 0)
	EndIf

	GUICtrlSetData($sProgress_2, 100)
	GUICtrlSetData($sProgress_1, __GetPercent($sSize))

	Return $sDeleteText
EndFunc   ;==>_Sorting_DeleteFile

Func _Sorting_ListFile($sSource, $sListFile, $sElementsGUI, $sProfile, $sSize)
	Local $sLabel_2 = $sElementsGUI[1], $sProgress_1 = $sElementsGUI[2], $sProgress_2 = $sElementsGUI[3]
	Local $sStringSplit, $sNewListFile = ""

	$sStringSplit = StringSplit($sListFile, "|") ; Remove List Properties From The End Of The String.
	GUICtrlSetData($sLabel_2, _WinAPI_PathCompactPathEx($sStringSplit[1], 68))
	GUICtrlSetData($sProgress_2, 0)

	If $Global_OpenedLists[0][0] > 0 Then ; Some Lists Are Already Opened In This Drop.
		For $A = 1 To $Global_OpenedLists[0][0]
			If $sStringSplit[1] = $Global_OpenedLists[$A][0] Then
				$sNewListFile = $Global_OpenedLists[$A][1] ; Load List Name Of This Drop.
				ExitLoop
			EndIf
		Next
	EndIf
	If $sNewListFile = "" Then ; List Is Opening Now.
		$Global_OpenedLists[0][0] += 1
		ReDim $Global_OpenedLists[$Global_OpenedLists[0][0] + 1][2]
		$Global_OpenedLists[$Global_OpenedLists[0][0]][0] = $sStringSplit[1] ; Original List Name.
		$sNewListFile = $sStringSplit[1]
		If FileExists($sNewListFile) Then
			$sNewListFile = __GetParentFolder($sStringSplit[1]) & "\" & _Duplicate_Process($sStringSplit[1], $sProfile)
			Switch @error
				Case 1 ; To Skip Also All Next Files.
					$sNewListFile = "###"
				Case 2 ; To Overwrite Destination File.
					FileDelete($sStringSplit[1])
			EndSwitch
		EndIf
		$Global_OpenedLists[$Global_OpenedLists[0][0]][1] = $sNewListFile
	EndIf
	If $sNewListFile = "###" Then
		Return SetError(2, 0, 0) ; Skipped.
	EndIf
	$sListFile = StringReplace($sListFile, $sStringSplit[1], $sNewListFile)
	GUICtrlSetData($sLabel_2, _WinAPI_PathCompactPathEx($sNewListFile, 68)) ; Update Destination.

	__List_Write($sSource, $sListFile, $sSize)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	GUICtrlSetData($sProgress_2, 100)
	GUICtrlSetData($sProgress_1, __GetPercent($sSize))

	Return $sNewListFile
EndFunc   ;==>_Sorting_ListFile

Func _Sorting_OpenFile($sSource, $sDestination, $sElementsGUI, $sSize)
	Local $sLabel_2 = $sElementsGUI[1], $sProgress_1 = $sElementsGUI[2], $sProgress_2 = $sElementsGUI[3]

	GUICtrlSetData($sLabel_2, _WinAPI_PathCompactPathEx($sDestination, 68))
	GUICtrlSetData($sProgress_2, 0)

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

Func _Sorting_PlaylistFile($sSource, $sPlaylistFile, $sElementsGUI, $sProfile, $sSize)
	Local $sLabel_2 = $sElementsGUI[1], $sProgress_1 = $sElementsGUI[2], $sProgress_2 = $sElementsGUI[3]
	Local $sNewPlaylistFile = ""

	GUICtrlSetData($sLabel_2, _WinAPI_PathCompactPathEx($sPlaylistFile, 68))
	GUICtrlSetData($sProgress_2, 0)

	If $Global_OpenedPlaylists[0][0] > 0 Then ; Some Playlists Are Already Opened In This Drop.
		For $A = 1 To $Global_OpenedPlaylists[0][0]
			If $sPlaylistFile = $Global_OpenedPlaylists[$A][0] Then
				$sNewPlaylistFile = $Global_OpenedPlaylists[$A][1] ; Load Playlist Name Of This Drop.
				ExitLoop
			EndIf
		Next
	EndIf
	If $sNewPlaylistFile = "" Then ; Playlist Is Opening Now.
		$Global_OpenedPlaylists[0][0] += 1
		ReDim $Global_OpenedPlaylists[$Global_OpenedPlaylists[0][0] + 1][2]
		$Global_OpenedPlaylists[$Global_OpenedPlaylists[0][0]][0] = $sPlaylistFile ; Original Playlist Name.
		$sNewPlaylistFile = $sPlaylistFile
		If FileExists($sNewPlaylistFile) Then
			$sNewPlaylistFile = __GetParentFolder($sPlaylistFile) & "\" & _Duplicate_Process($sPlaylistFile, $sProfile)
			Switch @error
				Case 1 ; To Skip Also All Next Files.
					$sNewPlaylistFile = "###"
				Case 2 ; To Overwrite Destination File.
					FileDelete($sPlaylistFile)
			EndSwitch
		EndIf
		$Global_OpenedPlaylists[$Global_OpenedPlaylists[0][0]][1] = $sNewPlaylistFile
	EndIf
	If $sNewPlaylistFile = "###" Then
		Return SetError(2, 0, 0) ; Skipped.
	EndIf
	GUICtrlSetData($sLabel_2, _WinAPI_PathCompactPathEx($sNewPlaylistFile, 68)) ; Update Destination.

	__Playlist_Write($sSource, $sNewPlaylistFile)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	GUICtrlSetData($sProgress_2, 100)
	GUICtrlSetData($sProgress_1, __GetPercent($sSize))

	Return $sNewPlaylistFile
EndFunc   ;==>_Sorting_PlaylistFile

Func _Sorting_RenameFile($sSource, $sNewName, $sElementsGUI, $sSize)
	Local $sLabel_2 = $sElementsGUI[1], $sProgress_1 = $sElementsGUI[2], $sProgress_2 = $sElementsGUI[3], $sReadOnly

	GUICtrlSetData($sLabel_2, _WinAPI_PathCompactPathEx(__GetFileName($sNewName), 68))
	GUICtrlSetData($sProgress_2, 0)

	If __IsReadOnly($sSource) Then
		$sReadOnly = 1
		FileSetAttrib($sSource, '-R')
	EndIf

	If _WinAPI_PathIsDirectory($sSource) Then
		DirMove($sSource, $sNewName)
	Else
		FileMove($sSource, $sNewName, 1)
	EndIf
	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	If $sReadOnly = 1 Then
		FileSetAttrib($sSource, '+R')
	EndIf

	GUICtrlSetData($sProgress_2, 100)
	GUICtrlSetData($sProgress_1, __GetPercent($sSize))

	Return 1
EndFunc   ;==>_Sorting_RenameFile

Func _Sorting_ShortcutFile($sSource, $sDestination, $sElementsGUI, $sSize)
	Local $sLabel_2 = $sElementsGUI[1], $sProgress_1 = $sElementsGUI[2], $sProgress_2 = $sElementsGUI[3]

	GUICtrlSetData($sLabel_2, _WinAPI_PathCompactPathEx($sDestination, 68))
	GUICtrlSetData($sProgress_2, 0)

	FileCreateShortcut($sSource, $sDestination)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	GUICtrlSetData($sProgress_2, 100)
	GUICtrlSetData($sProgress_1, __GetPercent($sSize))

	Return 1
EndFunc   ;==>_Sorting_ShortcutFile

Func _Sorting_UploadFile($sSource, $sDestination, $sElementsGUI, $sProfile, $sSize)
	Local $sLabel_2 = $sElementsGUI[1], $sProgress_1 = $sElementsGUI[2], $sProgress_2 = $sElementsGUI[3]
	Local $sFileName, $sStringSplit, $sDirectory, $sOpen, $sConn, $sListArray, $sPassword_Code = $Global_Password_Key

	$sStringSplit = StringSplit($sDestination, "|") ; Remove FTP Settings From The End Of The String.
	$sDirectory = $sStringSplit[1]
	$sStringSplit = StringSplit($sStringSplit[2], ";") ; 1 = Host; 2 = Port; 3 = User; 4 = Password; 5 = Protocol.
	ReDim $sStringSplit[6]
	If StringRight($sDirectory, 1) = "/" Then
		$sDirectory = StringTrimRight($sDirectory, 1)
	EndIf
	$sFileName = __GetFileName($sSource)
	$sDestination = $sDirectory & "/" & $sFileName
	If $sStringSplit[4] <> "" Then
		$sStringSplit[4] = _StringEncrypt(0, $sStringSplit[4], $sPassword_Code)
	EndIf

	GUICtrlSetData($sLabel_2, _WinAPI_PathCompactPathEx($sStringSplit[1] & $sDestination, 68))
	GUICtrlSetData($sProgress_2, 0)

	If $sStringSplit[5] = "SFTP" Then
		$sOpen = _SFTP_Open(@ScriptDir & '\Lib\psftp\psftp.exe')
		$sConn = _SFTP_Connect($sOpen, $sStringSplit[1], $sStringSplit[3], $sStringSplit[4], $sStringSplit[2])
		$sListArray = _SFTP_ListToArrayEx($sConn, $sDirectory)
		If @error Then
			_SFTP_Close($sOpen)
			Return SetError(1, 0, 0)
		EndIf
		If $sListArray[0][0] > 0 Then
			For $A = 1 To $sListArray[0][0]
				If $sFileName = $sListArray[$A][0] Then
					$sDestination = $sDirectory & "/" & _Duplicate_ProcessOnline($sSource, $sProfile, $sListArray[$A][3], $sListArray[$A][1], $sListArray, $sStringSplit[5])
					If @error Then
						_SFTP_Close($sOpen)
						Return SetError(2, 0, 0) ; Skipped.
					EndIf
					GUICtrlSetData($sLabel_2, _WinAPI_PathCompactPathEx($sStringSplit[1] & $sDestination, 68)) ; Update Destination.
					ExitLoop
				EndIf
			Next
		EndIf
		__SFTP_ProgressUpload($sConn, $sSource, $sDestination, $sProgress_1, $sProgress_2, $sSize)
		_SFTP_Close($sOpen)
	Else ; FTP.
		If $sStringSplit[2] = "" Then
			$sStringSplit[2] = 0
		EndIf
		$sOpen = _FTP_Open('DropIt Upload')
		$sConn = _FTP_Connect($sOpen, $sStringSplit[1], $sStringSplit[3], $sStringSplit[4], 0, $sStringSplit[2])
		$sListArray = __FTP_ListToArrayEx($sConn, $sDirectory, 0, 0x84000000) ; $INTERNET_FLAG_NO_CACHE_WRITE + $INTERNET_FLAG_RELOAD.
		If @error Then
			_FTP_Close($sOpen)
			Return SetError(1, 0, 0)
		EndIf
		If $sListArray[0][0] > 0 Then
			For $A = 1 To $sListArray[0][0]
				If $sFileName = $sListArray[$A][0] Then
					$sDestination = $sDirectory & "/" & _Duplicate_ProcessOnline($sSource, $sProfile, $sListArray[$A][3], $sListArray[$A][1], $sListArray, $sStringSplit[5])
					If @error Then
						_FTP_Close($sOpen)
						Return SetError(2, 0, 0) ; Skipped.
					EndIf
					GUICtrlSetData($sLabel_2, _WinAPI_PathCompactPathEx($sStringSplit[1] & $sDestination, 68)) ; Update Destination.
					ExitLoop
				EndIf
			Next
		EndIf
		If _WinAPI_PathIsDirectory($sSource) Then
			_FTP_DirPutContents($sConn, $sSource, $sDestination, 1)
		Else
			__FTP_ProgressUpload($sConn, $sSource, $sDestination, $sProgress_1, $sProgress_2, $sSize)
		EndIf
		_FTP_Close($sOpen)
	EndIf
	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	GUICtrlSetData($sProgress_2, 100)
	GUICtrlSetData($sProgress_1, __GetPercent($sSize))

	Return $sStringSplit[1] & $sDestination
EndFunc   ;==>_Sorting_UploadFile

Func _Sorting_Process($sSource, $sDestination, $sElementsGUI, $sProfile, $sRoot = '')
	Local $sPath, $sFile, $sSearch, $sSize
	Local $sLabel_1 = $sElementsGUI[0]

	If $Global_AbortSorting Then
		Return SetError(1, 0, 0) ; Needed To Do Not Start A New Operation If Sorting Is Aborted.
	EndIf
	GUICtrlSetData($sLabel_1, _WinAPI_PathCompactPathEx($sSource, 68))

	If _WinAPI_PathIsDirectory($sSource) Then
		$sSize = DirGetSize($sSource)
	Else
		$sSize = FileGetSize($sSource)
	EndIf

	Switch $Global_Action
		Case "$3" ; Compress Action.
			$sDestination = _Sorting_ArchiveFile($sSource, $sDestination, $sElementsGUI, $sProfile, $sSize, 3)

		Case "$4" ; Extract Action.
			$sDestination = _Sorting_ArchiveFile($sSource, $sDestination, $sElementsGUI, $sProfile, $sSize, 1)

		Case "$5" ; Open With Action.
			_Sorting_OpenFile($sSource, $sDestination, $sElementsGUI, $sSize)

		Case "$6" ; Delete Action.
			$sDestination = _Sorting_DeleteFile($sSource, $sDestination, $sElementsGUI, $sSize)

		Case "$7" ; Rename Action.
			_Sorting_RenameFile($sSource, $sDestination, $sElementsGUI, $sSize)

		Case "$8" ; Create List Action.
			$sDestination = _Sorting_ListFile($sSource, $sDestination, $sElementsGUI, $sProfile, $sSize)

		Case "$9" ; Create Playlist Action.
			$sDestination = _Sorting_PlaylistFile($sSource, $sDestination, $sElementsGUI, $sProfile, $sSize)

		Case "$A" ; Create Shortcut Action.
			_Sorting_ShortcutFile($sSource, $sDestination, $sElementsGUI, $sSize)

		Case "$B" ; Copy To Clipboard Action.
			$sDestination = _Sorting_ClipboardFile($sSource, $sDestination, $sElementsGUI, $sSize)

		Case "$C" ; Upload Action.
			$sDestination = _Sorting_UploadFile($sSource, $sDestination, $sElementsGUI, $sProfile, $sSize)

		Case "$D" ; Change Properties Action.
			_Sorting_ChangeFile($sSource, $sDestination, $sElementsGUI, $sSize)

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
						Return $sDestination
					EndIf
					$sPath = $sRoot & '\' & $sFile
					If @extended Then ; Loaded A Directory.
						If FileExists($sDestination & $sPath) = 0 Then
							If DirCreate($sDestination & $sPath) = 0 Then
								ExitLoop
							EndIf
							FileSetAttrib($sDestination & $sPath, '+' & StringReplace(FileGetAttrib($sSource & $sPath), 'D', ''))
						EndIf
						_Sorting_Process($sSource, $sDestination, $sElementsGUI, $sProfile, $sPath)
						If @error Then
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
		Return SetError(@error, 0, 0)
	EndIf
	Return $sDestination
EndFunc   ;==>_Sorting_Process
#EndRegion >>>>> MAIN: Processing Functions <<<<<

#Region >>>>> MAIN: General Functions <<<<<
Func _Main()
	Local $mINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $mProfileList, $mCurrentProfile, $mMsg, $mStringSplit, $mLoadedFolder[2] = [1, 0]
	Local $mWinTitle, $mMonitored, $mTime_Diff, $mTime_Now = TimerInit()

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
						$mStringSplit = StringSplit($mMonitored[$A][1], "|")
						ReDim $mStringSplit[3]
						If $mStringSplit[2] == "Disabled" Then
							ContinueLoop ; Skip Folder If It Is Disabled.
						EndIf
						__Log_Write(__Lang_Get('MONITORED_FOLDER', 'Monitored Folder'), $mLoadedFolder[1])
						If $Global_GUI_State = 1 Then ; GUI Is Visible.
							$mWinTitle = WinGetTitle("[active]")
							GUISetState(@SW_SHOW, $Global_GUI_2) ; Show Small Working Icon.
							WinActivate($mWinTitle) ; Restore Focus Of Previously Active Window.
						EndIf
						_DropEvent($mLoadedFolder, $mStringSplit[1], 1)
						GUISetState(@SW_HIDE, $Global_GUI_2) ; Hide Small Working Icon.
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
				_Options($Global_GUI_1) ; Open Options.
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
		__ImageWrite(-1, 4, -1, -1, -1, $rProfile[7]) ; Write Opacity To The Current Profile.
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
		_Refresh_Image() ; Refresh Target Image.
	EndIf
	_ContextMenu_Create() ; Create A ContextMenu.
	_TrayMenu_Create() ; Create A Hidden TrayMenu.
	If __Is("CustomTrayIcon") Then
		__Tray_SetIcon(__IsProfile(-1, 2))
	EndIf
	If __Is("UseSendTo") Then
		__SendTo_Uninstall() ; Remove SendTo Integration.
		__SendTo_Install() ; Create SendTo Integration.
	EndIf
	GUIRegisterMsg($WM_COMMAND, "WM_LBUTTONDBLCLK") ; $WM_LBUTTONDBLCLK As Command Doesn't Work.
	Return 1
EndFunc   ;==>_Refresh

Func _Refresh_Image()
	Local $rGUI_1 = $Global_GUI_1
	Local $rProfile = __IsProfile(-1, 0) ; Get Array Of Current Profile.
	Local $rWinGetPos = WinGetPos($rGUI_1)
	WinMove($rGUI_1, "", $rWinGetPos[0], $rWinGetPos[1], $rProfile[5], $rProfile[6] + 100)
	__SetBitmap($rGUI_1, $rProfile[3], 255 / 100 * $rProfile[7], $rProfile[5], $rProfile[6]) ; Set Image & Resize To The GUI.
	Return 1
EndFunc   ;==>_Refresh_Image

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
	$aLicense = GUICtrlCreateButton(__Lang_Get('LICENSE', 'License'), 250, 120, 65, 25)
	If FileExists(@ScriptDir & "\License.txt") = 0 Then
		GUICtrlSetState($aLicense, $GUI_HIDE)
	EndIf
	$aClose = GUICtrlCreateButton(__Lang_Get('CLOSE', 'Close'), 325, 120, 65, 25)

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
				_Update_Check($aUpdateText, $aUpdateProgress, $aUpdate, $aGUI)

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

Func _Update_Check($uLabel = -1, $uProgress = -1, $uCancel = -1, $uHandle = -1)
	Local $uBackground_GUI

	If $uLabel = -1 Then
		If __Is("CheckUpdates") Then ; Create A Hidden Update GUI.
			$uBackground_GUI = GUICreate(__Lang_Get('UPDATE_MSGBOX_10', 'DropIt Updating'), 330, 95, -1, -1, -1, $WS_EX_TOOLWINDOW)
			$uLabel = GUICtrlCreateLabel("", 10, 12, 310, 18)
			If __IsWindowsVersion() = 0 Then
				$uProgress = GUICtrlCreateProgress(10, 12 + 25, 310, 14, 0x01)
			Else
				$uProgress = GUICtrlCreatePic("", 10, 12 + 25, 310, 14)
			EndIf
			$uCancel = GUICtrlCreateButton(__Lang_Get('CANCEL', 'Cancel'), 165 - 40, 12 + 50, 80, 25)
		Else
			Return SetError(1, 0, 0)
		EndIf
	EndIf

	Local $uMsgBox, $uDownload, $uVersion, $uPage, $uCancelRead, $uCancelled = 0, $uPercent = 0, $uBefore = "<!--<version>", $uAfter = "</version>-->"
	Local $uSize, $uCurrentPercent, $uDownloaded, $uText, $uDownloadURL, $uDownloadFile, $uDownloadName

	HttpSetProxy(0) ; Load System Proxy Settings.
	$uPage = BinaryToString(InetRead(_WinAPI_ExpandEnvironmentStrings("%URL%"), 17)) ; Load Web Page.

	If @error Or StringInStr($uPage, $uBefore) = 0 Then
		MsgBox(0x30, __Lang_Get('UPDATE_MSGBOX_2', 'Check Failed'), __Lang_Get('UPDATE_MSGBOX_3', 'An error occurs during check for updates.'), 10, __OnTop($uHandle))
		Return SetError(1, 0, 0)
	EndIf

	; Extract Last Version Available From Web Page:
	$uBefore = StringInStr($uPage, $uBefore) + StringLen($uBefore)
	$uAfter = StringInStr(StringTrimLeft($uPage, $uBefore), $uAfter)
	$uVersion = StringStripWS(StringMid($uPage, $uBefore, $uAfter), 3)

	If @error Or $uVersion == "" Then
		GUICtrlSetData($uLabel, __Lang_Get('UPDATE_MSGBOX_3', 'An error occurs during check for updates.'))
		Return SetError(1, 0, 0)
	EndIf

	If $uVersion > $Global_CurrentVersion Then
		$uBefore = '<!--<update>'
		$uAfter = '</update>-->'
		If StringInStr($uPage, $uBefore) = 0 Then
			GUICtrlSetData($uLabel, __Lang_Get('UPDATE_MSGBOX_3', 'An error occurs during check for updates.'))
			Return SetError(1, 0, 0)
		EndIf

		; Extract Download URL From Web Page:
		$uBefore = StringInStr($uPage, $uBefore) + StringLen($uBefore)
		$uAfter = StringInStr(StringTrimLeft($uPage, $uBefore), $uAfter)
		$uDownloadURL = StringStripWS(StringMid($uPage, $uBefore, $uAfter), 3)

		$uMsgBox = MsgBox(0x4, __Lang_Get('UPDATE_MSGBOX_5', 'Update Available!'), StringReplace(__Lang_Get('UPDATE_MSGBOX_6', 'New version %NewVersion% of DropIt is available.  @LF  Do you want to update it now?'), '%NewVersion%', $uVersion), 0, __OnTop($uHandle))
		If $uMsgBox <> 6 Then
			Return SetError(1, 0, 0)
		EndIf
		__SetProgress($uProgress, 0, 3)

		GUISetState(@SW_SHOW, $uBackground_GUI) ; Show The Background GUI If It Exists.
		$uCancelRead = GUICtrlRead($uCancel)
		GUICtrlSetData($uCancel, __Lang_Get('CANCEL', 'Cancel'))
		$uDownloadName = "DropIt_v" & StringReplace($uVersion, " ", "_") & "_Portable"
		$uDownloadFile = @ScriptDir & "\" & $uDownloadName & ".zip"

		GUICtrlSetData($uLabel, StringReplace(__Lang_Get('UPDATE_MSGBOX_8', 'Calculating size for version %NewVersion%'), '%NewVersion%', $uVersion))
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
				GUICtrlSetData($uLabel, $uCurrentPercent & "% " & $uText)
			EndIf

			If InetGetInfo($uDownload, 4) <> 0 Then
				InetClose($uDownload)
				FileDelete($uDownloadFile)
				GUICtrlSetData($uLabel, __Lang_Get('UPDATE_MSGBOX_7', 'An error occured during software download.'))
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
			GUICtrlSetData($uLabel, __Lang_Get('UPDATE_MSGBOX_7', 'An error occured during software download.'))
			If FileExists($uDownloadFile) Then
				FileDelete($uDownloadFile)
			EndIf
			GUIDelete($uBackground_GUI) ; Delete The Background GUI If It Exists.
			Return SetError(1, 0, 0)
		EndIf

		If _Update_Run($uDownloadFile, $uDownloadName, @ScriptDir & "\ZIP\") Then
			__IniWriteEx(__IsSettingsFile(), "General", "Update", "True")
			Run(@ScriptName)
			Exit
		EndIf
	Else
		GUICtrlSetData($uLabel, __Lang_Get('UPDATE_MSGBOX_4', 'You have the latest release available.'))
	EndIf

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_Update_Check

Func _Update_Complete()
	Local $uINI = __IsSettingsFile()

	If __Is("Update", -1, "False") Then
		IniDelete($uINI, "General", "Update")
		FileDelete(@ScriptDir & "\DropIt_OLD.exe")
		MsgBox(0x40000, __Lang_Get('UPDATE_MSGBOX_0', 'Successfully Updated'), __Lang_Get('UPDATE_MSGBOX_1', 'New version %VersionNo% is now ready to be used.'), 10)
	EndIf

	Return 1
EndFunc   ;==>_Update_Complete

Func _Update_Run($uDownloadFile, $uDownloadName, $uNewFolder)
	Local $uNewDirectory = $uNewFolder & $uDownloadName
	Local $uArray[6] = [5, "Languages", "Lib", "Guide.pdf", "License.txt", "Readme.txt"]

	__7ZipRun($uDownloadFile, __GetDefault(1) & "ZIP", 1, 0) ; __GetDefault(1) = Get The Default Settings Directory.
	FileDelete($uDownloadFile)
	If FileExists($uNewDirectory & "\" & @ScriptName) = 0 Then
		Return SetError(1, 0, 0)
	EndIf

	For $A = 1 To $uArray[0]
		If FileExists($uNewDirectory & "\" & $uArray[$A]) = 0 Then
			ContinueLoop
		EndIf
		If _WinAPI_PathIsDirectory($uNewDirectory & "\" & $uArray[$A]) Then
			DirRemove(@ScriptDir & "\" & $uArray[$A], 1)
			DirMove($uNewDirectory & "\" & $uArray[$A], @ScriptDir & "\" & $uArray[$A])
		Else
			FileSetAttrib(@ScriptDir & "\" & $uArray[$A], '-R')
			FileMove($uNewDirectory & "\" & $uArray[$A], @ScriptDir & "\" & $uArray[$A], 1)
		EndIf
	Next
	FileMove($uNewDirectory & "\Images\*.*", @ScriptDir & "\Images\", 9)
	FileMove(@ScriptFullPath, @ScriptDir & "\DropIt_OLD.exe") ; Trick To Update DropIt Executable.
	FileMove($uNewDirectory & "\DropIt.exe", @ScriptFullPath)
	DirRemove($uNewFolder, 1)

	Return 1
EndFunc   ;==>_Update_Run

Func _Monitored_Edit_GUI($mHandle, $mINI, $mListView, $mIndex = -1, $mFolder = -1)
	Local $mGUI, $mInput_Folder, $mButton_Folder, $mCombo_Profile, $mCurrent_Folder, $mSave, $mCancel
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

	$mSave = GUICtrlCreateButton(__Lang_Get('SAVE', 'Save'), 150 - 20 - 75, 90, 75, 24)
	$mCancel = GUICtrlCreateButton(__Lang_Get('CANCEL', 'Cancel'), 150 + 20, 90, 75, 24)
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
					MsgBox(0x30, __Lang_Get('MONITORED_FOLDER_MSGBOX_0', 'Folder Error'), __Lang_Get('MONITORED_FOLDER_MSGBOX_1', 'You must specify a valid directory.'), 0, __OnTop($mGUI))
					ContinueLoop
				EndIf
				If $mIndex <> -1 Then
					IniDelete($mINI, "MonitoredFolders", $mFolder)
				EndIf
				__IniWriteEx($mINI, "MonitoredFolders", $mCurrent_Folder, GUICtrlRead($mCombo_Profile) & "|Enabled")
				ExitLoop

			Case $mButton_Folder
				$mCurrent_Folder = FileSelectFolder(__Lang_Get('MONITORED_FOLDER_MSGBOX_2', 'Select a monitored folder:'), "", 3, "", $mGUI)
				$mCurrent_Folder = _WinAPI_PathRemoveBackslash($mCurrent_Folder)
				If $mCurrent_Folder <> "" Then
					GUICtrlSetData($mInput_Folder, $mCurrent_Folder)
				EndIf

		EndSwitch
	WEnd
	GUIDelete($mGUI)

	Return 1
EndFunc   ;==>_Monitored_Edit_GUI

Func _Monitored_Update($mListView, $mINI)
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
		If $mStringSplit[2] <> "Disabled" Then
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
EndFunc   ;==>_Monitored_Update

Func _Options($oHandle = -1)
	Local $oINI = __IsSettingsFile() ; Get Default Settings INI File.

	Local $oCheckItems[27] = [26], $oCheckModeItems[3] = [2], $oComboItems[9] = [8], $oGroup[9] = [8], $oCurrent[9] = [8]
	Local $oINI_TrueOrFalse_Array[27][3] = [ _
			[26, 3], _
			["General", "OnTop", 1], _
			["General", "LockPosition", 1], _
			["General", "MultipleInstances", 1], _
			["General", "UseSendTo", 1], _
			["General", "CreateLog", 1], _
			["General", "DirForFolders", 1], _
			["General", "IgnoreNew", 1], _
			["General", "AutoDup", 1], _
			["General", "ShowSorting", 1], _
			["General", "ProfileEncryption", 1], _
			["General", "CustomTrayIcon", 1], _
			["General", "StartAtStartup", 1], _
			["General", "IntegrityCheck", 1], _
			["General", "AlertSize", 1], _
			["General", "AlertDelete", 1], _
			["General", "WaitOpened", 1], _
			["General", "Monitoring", 1], _
			["General", "CheckUpdates", 1], _
			["General", "Minimized", 1], _
			["General", "ScanSubfolders", 1], _
			["General", "ListSortable", 1], _
			["General", "ListFilter", 1], _
			["General", "ListHeader", 1], _
			["General", "ListLightbox", 1], _
			["General", "AmbiguitiesCheck", 1], _
			["General", "UseRegEx", 1]]
	Local $oINI_Various_Array[14][2] = [ _
			[13, 2], _
			["General", "SendToMode"], _
			["General", "DupMode"], _
			["General", "MasterPassword"], _
			["General", "MonitoringTime"], _
			["General", "ListTheme"], _
			["General", "ZIPLevel"], _
			["General", "ZIPMethod"], _
			["General", "ZIPEncryption"], _
			["General", "ZIPPassword"], _
			["General", "7ZLevel"], _
			["General", "7ZMethod"], _
			["General", "7ZEncryption"], _
			["General", "7ZPassword"]]

	Local $oPW, $oPW_Code = $Global_Password_Key
	Local $oBackupDirectory = __GetDefault(32) ; Get Default Backup Directory.
	Local $oLogFile = __GetDefault(513) ; Get Default Directory & LogFile File Name.
	Local $oThemeFolder = @ScriptDir & "\Lib\list\themes\"
	Local $oGUI, $oOK, $oCancel, $oMsg, $oMsgBox, $oLanguage, $oLanguageCombo, $oImageList, $oLogRemove, $oLogView, $oLogWrite, $oTab_1, $oCreateTab
	Local $oZIPPassword, $oShowZIPPassword, $o7ZPassword, $oShow7ZPassword, $oMasterPassword, $oShowMasterPassword, $oDisablePassword
	Local $oState, $oBk_Backup, $oBk_Restore, $oBk_Remove, $oNewDummy, $oEnterDummy, $oThemePreview, $oNoPreview
	Local $oListView, $oListView_Handle, $oIndex_Selected, $oFolder_Selected, $oMn_Add, $oMn_Edit, $oMn_Remove, $oScanTime

	$oGUI = GUICreate(__Lang_Get('OPTIONS', 'Options'), 380, 350, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($oHandle))

	$oCreateTab = GUICtrlCreateTab(0, 0, 380, 313) ; Create Tab Menu.

	; MAIN Tab:
	$oTab_1 = GUICtrlCreateTabItem(__Lang_Get('OPTIONS_TAB_0', 'Main'))
	GUICtrlSetState(-1, $GUI_SHOW) ; Show This Tab At Options Opening.

	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_16', 'Interface'), 10, 30, 359, 105)
	$oCheckItems[1] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_0', 'Show target image always on top'), 25, 30 + 15)
	$oCheckItems[2] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_7', 'Lock target image position'), 25, 30 + 15 + 20)
	$oCheckItems[11] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_13', 'Use profile icon in traybar'), 25, 30 + 15 + 40)
	$oCheckItems[9] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_11', 'Show progress bar during process'), 25, 30 + 15 + 60)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_3', 'Usage'), 10, 140, 359, 85)
	$oCheckItems[12] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_14', 'Start on system startup'), 25, 140 + 15)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_3', 'Note that this is a not portable feature.'))
	$oCheckItems[19] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_21', 'Start minimized to system tray'), 25, 140 + 15 + 20)
	$oCheckItems[4] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_6', 'Integrate in SendTo menu'), 25, 140 + 15 + 40, 290, 20)
	$oCheckModeItems[1] = GUICtrlCreateCheckbox("", 25 + 295, 140 + 15 + 40, 20, 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_1', 'This integration is created at DropIt startup and removed at closing.'), __Lang_Get('OPTIONS_PORTABLE_MODE', 'Portable Mode'), 0)
	$oCheckModeItems[2] = GUICtrlCreateIcon(@ScriptFullPath, -17, 25 + 315, 140 + 15 + 40 + 1, 16, 16)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_1', 'This integration is created at DropIt startup and removed at closing.'), __Lang_Get('OPTIONS_PORTABLE_MODE', 'Portable Mode'), 0)
	GUICtrlCreateGroup('', -99, -99, 1, 1)

	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_1', 'Language'), 10, 230, 359, 52)
	$oLanguageCombo = _GUICtrlComboBoxEx_Create($oGUI, "", 25, 230 + 15 + 3, 330, 260, 0x0003)
	$oImageList = _GUIImageList_Create(16, 16, 5, 3) ; Create An ImageList.
	_GUICtrlComboBoxEx_SetImageList($oLanguageCombo, $oImageList)
	$Global_ImageList = $oImageList
	__LangList_Combo($oLanguageCombo)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; MONITORING Tab:
	GUICtrlCreateTabItem(__Lang_Get('OPTIONS_TAB_4', 'Monitoring'))

	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_15', 'Folder Monitoring'), 10, 30, 359, 270)
	$oCheckItems[17] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_19', 'Scan every') & ":", 25, 30 + 15 + 2, 230, 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_10', 'Schedule a scan of selected folders with a defined time interval.'))
	$oScanTime = GUICtrlCreateInput("", 25 + 240, 30 + 15, 90, 20, 0x2000)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_9', 'Time interval in seconds'))
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

	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_0', 'General'), 10, 30, 359, 185)
	$oCheckItems[6] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_2', 'Enable associations for folders'), 25, 30 + 15)
	$oCheckItems[20] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_22', 'Scan also subfolders'), 25, 30 + 15 + 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_11', 'It does not work if folders association is enabled.'))
	$oCheckItems[7] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_3', 'Ignore unassociated files/folders'), 25, 30 + 15 + 40)
	$oCheckItems[25] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_28', 'Select ambiguities checkbox by default'), 25, 30 + 15 + 60)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_18', 'Checkbox that apply selection to all ambiguities of a drop is selected by default.'))
	$oCheckItems[14] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_16', 'Confirm for large loaded files'), 25, 30 + 15 + 80)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_15', 'It requires a confirmation if more than 2 GB of files are loaded.'))
	$oCheckItems[15] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_23', 'Confirm for Delete actions'), 25, 30 + 15 + 100)
	$oCheckItems[13] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_4', 'Check moved/copied files integrity'), 25, 30 + 15 + 120)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_4', 'Activating MD5 check will slow down the sorting process.'))
	$oCheckItems[16] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_18', 'Pause until opened file is closed'), 25, 30 + 15 + 140)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_8', 'Pause the sorting process at each "Open With" action.'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_5', 'Manage Duplicates'), 10, 220, 359, 72)
	$oCheckItems[8] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_5', 'Use automatic choice for duplicates'), 25, 220 + 15)
	$oComboItems[1] = GUICtrlCreateCombo("", 25, 220 + 15 + 20 + 3, 330, 20, 0x0003)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; COMPRESSION Tab:
	GUICtrlCreateTabItem(__Lang_Get('OPTIONS_TAB_2', 'Compression'))

	GUICtrlCreateGroup("ZIP", 10, 30, 359, 135)
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_11', 'Level') & ":", 25, 30 + 15 + 4, 110, 20)
	$oComboItems[2] = GUICtrlCreateCombo("", 25 + 120, 30 + 15, 210, 20, 0x0003)
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_12', 'Method') & ":", 25, 30 + 15 + 30 + 4, 110, 20)
	$oComboItems[3] = GUICtrlCreateCombo("", 25 + 120, 30 + 15 + 30, 210, 20, 0x0003)
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_9', 'Encryption') & ":", 25, 30 + 15 + 60 + 4, 110, 20)
	$oComboItems[4] = GUICtrlCreateCombo("", 25 + 120, 30 + 15 + 60, 210, 20, 0x0003)
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_13', 'Password') & ":", 25, 30 + 15 + 90 + 4, 110, 20)
	$oZIPPassword = GUICtrlCreateInput("", 25 + 120, 30 + 15 + 90, 196, 20, 0x0020)
	$oShowZIPPassword = GUICtrlCreateButton("", 25 + 120 + 196, 30 + 15 + 90, 14, 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_2', 'Show/Hide the password'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup("7Z / EXE", 10, 170, 359, 135)
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_11', 'Level') & ":", 25, 170 + 15 + 4, 110, 20)
	$oComboItems[5] = GUICtrlCreateCombo("", 25 + 120, 170 + 15, 210, 20, 0x0003)
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_12', 'Method') & ":", 25, 170 + 15 + 30 + 4, 110, 20)
	$oComboItems[6] = GUICtrlCreateCombo("", 25 + 120, 170 + 15 + 30, 210, 20, 0x0003)
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_9', 'Encryption') & ":", 25, 170 + 15 + 60 + 4, 110, 20)
	$oComboItems[7] = GUICtrlCreateCombo("", 25 + 120, 170 + 15 + 60, 210, 20, 0x0003)
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_13', 'Password') & ":", 25, 170 + 15 + 90 + 4, 110, 20)
	$o7ZPassword = GUICtrlCreateInput("", 25 + 120, 170 + 15 + 90, 196, 20, 0x0020)
	$oShow7ZPassword = GUICtrlCreateButton("", 25 + 120 + 196, 170 + 15 + 90, 14, 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_2', 'Show/Hide the password'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; LISTS Tab:
	GUICtrlCreateTabItem(__Lang_Get('OPTIONS_TAB_5', 'Lists'))
	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_0', 'General'), 10, 30, 359, 105)
	$oCheckItems[21] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_24', 'Create sortable HTML lists'), 25, 30 + 15)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_12', 'Allow to sort table content when you click the column header fields.'))
	$oCheckItems[22] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_25', 'Add filter to HTML lists'), 25, 30 + 15 + 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_13', 'Add a box where you can type words to filter table content.'))
	$oCheckItems[24] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_27', 'Add lightbox to HTML lists'), 25, 30 + 15 + 40)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_14', 'Open images from Absolute and Relative Links in an overlapped preview.'))
	$oCheckItems[23] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_26', 'Add header to TXT and CSV lists'), 25, 30 + 15 + 60)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_17', 'HTML Theme'), 10, 140, 359, 162)
	$oComboItems[8] = GUICtrlCreateCombo("", 25, 140 + 15 + 3, 330, 20, 0x0003)
	$oThemePreview = GUICtrlCreatePic($oThemeFolder & "Default.jpg", 25, 140 + 15 + 35, 330, 100)
	$oNoPreview = GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_18', 'Preview Not Available'), 25 + 85, 140 + 15 + 75, 130, 40)
	GUICtrlSetState($oNoPreview, $GUI_HIDE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; VARIOUS Tab:
	GUICtrlCreateTabItem(__Lang_Get('OPTIONS_TAB_3', 'Various'))

	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_0', 'General'), 10, 30, 359, 85)
	$oCheckItems[3] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_8', 'Enable multiple instances'), 25, 30 + 15)
	$oCheckItems[18] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_20', 'Check for updates at DropIt startup'), 25, 30 + 15 + 20)
	$oCheckItems[26] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_29', 'Consider rules as Regular Expressions'), 25, 30 + 15 + 40)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_16', 'Pay attention because rules created with normal syntax will not work.'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_14', 'Security'), 10, 120, 359, 75)
	$oCheckItems[10] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_12', 'Encrypt profiles at DropIt closing'), 25, 120 + 15)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_6', 'Password will be requested at DropIt startup.'))
	GUICtrlCreateLabel(__Lang_Get('OPTIONS_LABEL_13', 'Password') & ":", 25, 120 + 15 + 30, 110, 20)
	$oMasterPassword = GUICtrlCreateInput("", 25 + 120, 120 + 15 + 27, 196, 20, 0x0020)
	$oShowMasterPassword = GUICtrlCreateButton("", 25 + 120 + 196, 120 + 15 + 27, 14, 20)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_2', 'Show/Hide the password'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_7', 'Activity Log'), 10, 200, 359, 50)
	$oCheckItems[5] = GUICtrlCreateCheckbox(__Lang_Get('OPTIONS_CHECKBOX_1', 'Write log file'), 25, 200 + 15 + 3, 190, 20)
	$oLogRemove = GUICtrlCreateIcon(@ScriptFullPath, -18, 25 + 216, 200 + 15 + 4, 16, 16)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_TIP_17', 'Remove log file'))
	$oLogView = GUICtrlCreateButton(__Lang_Get('OPTIONS_BUTTON_0', 'View'), 25 + 240, 200 + 15 + 2, 90, 22)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__Lang_Get('OPTIONS_LABEL_2', 'Settings Backup'), 10, 255, 359, 50)
	$oBk_Backup = GUICtrlCreateButton(__Lang_Get('OPTIONS_BUTTON_1', 'Back up'), 25, 255 + 15 + 3, 90, 22)
	GUICtrlSetTip(-1, __Lang_Get('OPTIONS_BUTTON_1', 'Back up'))
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
	$oGroup[1] = __Lang_Get('DUPLICATE_MODE_0', 'Overwrite') & "|" & __Lang_Get('DUPLICATE_MODE_1', 'Overwrite if newer') & "|" & _
			__Lang_Get('DUPLICATE_MODE_7', 'Overwrite if different size') & "|" & __Lang_Get('DUPLICATE_MODE_3', 'Rename as "Name 01"') & "|" & _
			__Lang_Get('DUPLICATE_MODE_4', 'Rename as "Name_01"') & "|" & __Lang_Get('DUPLICATE_MODE_5', 'Rename as "Name (01)"') & "|" & _
			__Lang_Get('DUPLICATE_MODE_6', 'Skip')
	$oCurrent[1] = __GetDuplicateMode(IniRead($oINI, "General", "DupMode", "Overwrite1"), 1)

	$oGroup[2] = __Lang_Get('COMPRESS_LEVEL_0', 'Fastest') & "|" & __Lang_Get('COMPRESS_LEVEL_1', 'Fast') & "|" & __Lang_Get('COMPRESS_LEVEL_2', 'Normal') & "|" & _
			__Lang_Get('COMPRESS_LEVEL_3', 'Maximum') & "|" & __Lang_Get('COMPRESS_LEVEL_4', 'Ultra')
	$oCurrent[2] = __GetCompressionLevel(IniRead($oINI, "General", "ZIPLevel", "5"))

	$oGroup[3] = "Deflate|LZMA|PPMd|BZip2"
	$oCurrent[3] = IniRead($oINI, "General", "ZIPMethod", "Deflate")
	If StringInStr($oGroup[3], $oCurrent[3]) = 0 Then
		$oCurrent[3] = "Deflate"
	EndIf

	$oGroup[4] = __Lang_Get('COMPRESS_ENCRYPT', 'None') & "|ZipCrypto|AES-256"
	$oCurrent[4] = IniRead($oINI, "General", "ZIPEncryption", "None")
	If StringInStr($oGroup[4], $oCurrent[4]) = 0 Then
		$oCurrent[4] = __Lang_Get('COMPRESS_ENCRYPT', 'None')
	EndIf

	$oGroup[5] = $oGroup[2]
	$oCurrent[5] = __GetCompressionLevel(IniRead($oINI, "General", "7ZLevel", "5"))

	$oGroup[6] = "LZMA|LZMA2|PPMd|BZip2"
	$oCurrent[6] = IniRead($oINI, "General", "7ZMethod", "LZMA")
	If StringInStr($oGroup[6], $oCurrent[6]) = 0 Then
		$oCurrent[6] = "LZMA"
	EndIf

	$oGroup[7] = __Lang_Get('COMPRESS_ENCRYPT', 'None') & "|AES-256"
	$oCurrent[7] = IniRead($oINI, "General", "7ZEncryption", "None")
	If StringInStr($oGroup[7], $oCurrent[7]) = 0 Then
		$oCurrent[7] = __Lang_Get('COMPRESS_ENCRYPT', 'None')
	EndIf

	$oGroup[8] = __ThemeList_Combo()
	$oCurrent[8] = IniRead($oINI, "General", "ListTheme", "Default")
	If StringInStr($oGroup[8], $oCurrent[8]) = 0 Then
		$oCurrent[8] = "Default"
	EndIf
	If FileExists($oThemeFolder & $oCurrent[8] & ".jpg") Then
		GUICtrlSetImage($oThemePreview, $oThemeFolder & $oCurrent[8] & ".jpg")
		GUICtrlSetState($oThemePreview, $GUI_SHOW)
		GUICtrlSetState($oNoPreview, $GUI_HIDE)
	Else
		GUICtrlSetState($oThemePreview, $GUI_HIDE)
		GUICtrlSetState($oNoPreview, $GUI_SHOW)
	EndIf

	For $A = 1 To 8
		GUICtrlSetData($oComboItems[$A], $oGroup[$A], $oCurrent[$A])
	Next

	; SendTo Integration Settings:
	$oState = $GUI_DISABLE
	If GUICtrlRead($oCheckItems[4]) = 1 Then
		$oState = $GUI_ENABLE
	EndIf
	For $A = 1 To 2
		GUICtrlSetState($oCheckModeItems[$A], $oState)
	Next
	If IniRead($oINI, "General", "SendToMode", "Portable") = "Portable" Then
		GUICtrlSetState($oCheckModeItems[1], $GUI_CHECKED)
	Else
		GUICtrlSetState($oCheckModeItems[1], $GUI_UNCHECKED)
	EndIf

	; Log Settings:
	If FileExists($oLogFile[1][0] & $oLogFile[2][0]) = 0 Then
		GUICtrlSetState($oLogRemove, $GUI_DISABLE)
		GUICtrlSetState($oLogView, $GUI_DISABLE)
	EndIf

	; Folder Association Settings:
	$oState = $GUI_ENABLE
	If GUICtrlRead($oCheckItems[6]) = 1 Then
		$oState = $GUI_DISABLE
	EndIf
	GUICtrlSetState($oCheckItems[20], $oState)

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
	GUICtrlSetState($oComboItems[1], $oState)

	; ZIP Encryption Settings:
	$oState = $GUI_DISABLE
	If $oCurrent[4] <> __Lang_Get('COMPRESS_ENCRYPT', 'None') Then
		$oState = $GUI_ENABLE
	EndIf
	GUICtrlSetState($oZIPPassword, $oState)
	GUICtrlSetState($oShowZIPPassword, $oState)
	$oPW = IniRead($oINI, "General", "ZIPPassword", "")
	If $oPW <> "" Then
		GUICtrlSetData($oZIPPassword, _StringEncrypt(0, $oPW, $oPW_Code))
	EndIf

	; 7Z / EXE Encryption Settings:
	$oState = $GUI_DISABLE
	If $oCurrent[7] <> __Lang_Get('COMPRESS_ENCRYPT', 'None') Then
		$oState = $GUI_ENABLE
	EndIf
	GUICtrlSetState($o7ZPassword, $oState)
	GUICtrlSetState($oShow7ZPassword, $oState)
	$oPW = IniRead($oINI, "General", "7ZPassword", "")
	If $oPW <> "" Then
		GUICtrlSetData($o7ZPassword, _StringEncrypt(0, $oPW, $oPW_Code))
	EndIf

	; Security Settings:
	$oState = $GUI_DISABLE
	If GUICtrlRead($oCheckItems[10]) = 1 Then
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
	If GUICtrlRead($oCheckItems[17]) = 1 Then
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
	_GUICtrlListView_SetExtendedListViewStyle($oListView_Handle, BitOR($LVS_EX_CHECKBOXES, $LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_INFOTIP))
	_GUICtrlListView_SetColumnWidth($oListView_Handle, 0, 185)
	_GUICtrlListView_SetColumnWidth($oListView_Handle, 1, 125)
	Local $oToolTip = _GUICtrlListView_GetToolTips($oListView_Handle)
	If IsHWnd($oToolTip) Then
		__OnTop($oToolTip, 1)
		_GUIToolTip_SetDelayTime($oToolTip, 3, 60) ; Speed Up InfoTip Appearance.
	EndIf
	_Monitored_Update($oListView_Handle, $oINI)
	$oNewDummy = GUICtrlCreateDummy()
	$Global_ListViewFolders_New = $oNewDummy
	$oEnterDummy = GUICtrlCreateDummy()
	$Global_ListViewFolders_Enter = $oEnterDummy

	$oOK = GUICtrlCreateButton(__Lang_Get('OK', 'OK'), 190 - 30 - 90, 318, 90, 26)
	$oCancel = GUICtrlCreateButton(__Lang_Get('CANCEL', 'Cancel'), 190 + 30, 318, 90, 26)
	GUICtrlSetState($oOK, $GUI_DEFBUTTON)

	$Global_ListViewIndex = -1 ; Set As No Item Selected.
	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
	GUISetState(@SW_SHOW)

	Local $oHotKeys[3][2] = [["^n", $oMn_Add],["^r", $oMn_Remove],["{ENTER}", $oMn_Edit]]
	GUISetAccelerators($oHotKeys)

	_WinAPI_EmptyWorkingSet() ; Reduce Memory Usage Of DropIt.
	While 1
		$oIndex_Selected = $Global_ListViewIndex

		If $Global_ListViewFolders_ItemChange <> -1 Then
			__SetMonitoredFolderState($oINI, _GUICtrlListView_GetItemText($oListView_Handle, $Global_ListViewFolders_ItemChange), _GUICtrlListView_GetItemText($oListView_Handle, $Global_ListViewFolders_ItemChange, 1), _GUICtrlListView_GetItemChecked($oListView_Handle, $Global_ListViewFolders_ItemChange))
			$Global_ListViewFolders_ItemChange = -1
		EndIf

		; Update Compression Combo If Encryption Changes:
		If GUICtrlRead($oComboItems[4]) <> $oCurrent[4] And Not _GUICtrlComboBox_GetDroppedState($oComboItems[4]) Then
			$oCurrent[4] = GUICtrlRead($oComboItems[4])
			$oState = $GUI_DISABLE
			If $oCurrent[4] <> __Lang_Get('COMPRESS_ENCRYPT', 'None') Then
				$oState = $GUI_ENABLE
			EndIf
			GUICtrlSetState($oZIPPassword, $oState)
			GUICtrlSetState($oShowZIPPassword, $oState)
		EndIf
		If GUICtrlRead($oComboItems[7]) <> $oCurrent[7] And Not _GUICtrlComboBox_GetDroppedState($oComboItems[7]) Then
			$oCurrent[7] = GUICtrlRead($oComboItems[7])
			$oState = $GUI_DISABLE
			If $oCurrent[7] <> __Lang_Get('COMPRESS_ENCRYPT', 'None') Then
				$oState = $GUI_ENABLE
			EndIf
			GUICtrlSetState($o7ZPassword, $oState)
			GUICtrlSetState($oShow7ZPassword, $oState)
		EndIf

		; Update Image Preview If Theme Changes:
		If GUICtrlRead($oComboItems[8]) <> $oCurrent[8] And Not _GUICtrlComboBox_GetDroppedState($oComboItems[8]) Then
			$oCurrent[8] = GUICtrlRead($oComboItems[8])
			If FileExists($oThemeFolder & $oCurrent[8] & ".jpg") Then
				GUICtrlSetImage($oThemePreview, $oThemeFolder & $oCurrent[8] & ".jpg")
				GUICtrlSetState($oThemePreview, $GUI_SHOW)
				GUICtrlSetState($oNoPreview, $GUI_HIDE)
			Else
				GUICtrlSetState($oThemePreview, $GUI_HIDE)
				GUICtrlSetState($oNoPreview, $GUI_SHOW)
			EndIf
		EndIf

		; Update Monitoring Buttons State:
		If $oIndex_Selected = -1 Then ; Nothing Selected.
			If GUICtrlGetState($oMn_Edit) = 80 Then
				GUICtrlSetState($oMn_Edit, 144) ; $GUI_DISABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($oMn_Remove) = 80 Then
				GUICtrlSetState($oMn_Remove, 144) ; $GUI_DISABLE + $GUI_SHOW.
			EndIf
		ElseIf GUICtrlRead($oCheckItems[17]) = 1 Then ; Monitoring Enabled.
			If GUICtrlGetState($oMn_Edit) > 80 Then
				GUICtrlSetState($oMn_Edit, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($oMn_Remove) > 80 Then
				GUICtrlSetState($oMn_Remove, 80) ; $GUI_ENABLE + $GUI_SHOW.
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
						ControlMove($oGUI, "", $oLanguageCombo, 25, 230 + 15 + 3)
					Case Else
						If $oLanguageCombo Then
							ControlMove($oGUI, "", $oLanguageCombo, -99, -99)
						EndIf
				EndSwitch

			Case $oCheckModeItems[2]
				$oState = $GUI_CHECKED
				If GUICtrlRead($oCheckModeItems[1]) = 1 Then
					$oState = $GUI_UNCHECKED
				EndIf
				GUICtrlSetState($oCheckModeItems[1], $oState)

			Case $oCheckItems[4] ; SendTo Integration Checkbox.
				$oState = $GUI_DISABLE
				If GUICtrlRead($oCheckItems[4]) = 1 Then
					$oState = $GUI_ENABLE
				EndIf
				For $A = 1 To 2
					GUICtrlSetState($oCheckModeItems[$A], $oState)
				Next

			Case $oCheckItems[6] ; Folder Association Checkbox.
				$oState = $GUI_ENABLE
				If GUICtrlRead($oCheckItems[6]) = 1 Then
					$oState = $GUI_DISABLE
					GUICtrlSetState($oCheckItems[20], $GUI_UNCHECKED)
				EndIf
				GUICtrlSetState($oCheckItems[20], $oState)

			Case $oCheckItems[8] ; Duplicate Mode Checkbox.
				$oState = $GUI_DISABLE
				If GUICtrlRead($oCheckItems[8]) = 1 Then
					$oState = $GUI_ENABLE
				EndIf
				GUICtrlSetState($oComboItems[1], $oState)

			Case $oCheckItems[10] ; Security Checkbox.
				$oState = $GUI_DISABLE
				If GUICtrlRead($oCheckItems[10]) = 1 Then
					$oState = $GUI_ENABLE
				EndIf
				GUICtrlSetState($oMasterPassword, $oState)
				GUICtrlSetState($oShowMasterPassword, $oState)

			Case $oCheckItems[17] ; Monitoring Checkbox.
				$oState = $GUI_DISABLE
				If GUICtrlRead($oCheckItems[17]) = 1 Then
					$oState = $GUI_ENABLE
				EndIf
				GUICtrlSetState($oScanTime, $oState)
				GUICtrlSetState($oListView, $oState)
				GUICtrlSetState($oMn_Add, $oState)
				GUICtrlSetState($oMn_Edit, $oState)
				GUICtrlSetState($oMn_Remove, $oState)

			Case $oLogRemove
				FileDelete($oLogFile[1][0] & $oLogFile[2][0])
				GUICtrlSetState($oLogRemove, $GUI_DISABLE)
				GUICtrlSetState($oLogView, $GUI_DISABLE)

			Case $oLogView
				ShellExecute($oLogFile[1][0] & $oLogFile[2][0])

			Case $oNewDummy, $oMn_Add
				_Monitored_Edit_GUI($oGUI, $oINI, $oListView_Handle, -1, -1)
				_Monitored_Update($oListView_Handle, $oINI)

			Case $oEnterDummy, $oMn_Edit, $oMn_Remove
				If Not _GUICtrlListView_GetItemState($oListView_Handle, $oIndex_Selected, $LVIS_SELECTED) Or $oIndex_Selected = -1 Then
					ContinueLoop
				EndIf
				$oFolder_Selected = _GUICtrlListView_GetItemText($oListView_Handle, $oIndex_Selected)

				If $oMsg = $oMn_Remove Then
					$oMsgBox = MsgBox(0x4, __Lang_Get('OPTIONS_MONITORED_MSGBOX_0', 'Delete monitored folder'), __Lang_Get('OPTIONS_MONITORED_MSGBOX_1', 'Are you sure to remove this monitored folder from the list?'), 0, __OnTop($oGUI))
					If $oMsgBox = 6 Then
						IniDelete($oINI, "MonitoredFolders", $oFolder_Selected)
						_GUICtrlListView_DeleteItem($oListView_Handle, $oIndex_Selected)
						$Global_ListViewIndex = -1 ; Set As No Item Selected.
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

			Case $oShowZIPPassword
				__ShowPassword($oZIPPassword)

			Case $oShow7ZPassword
				__ShowPassword($o7ZPassword)

			Case $oShowMasterPassword
				__ShowPassword($oMasterPassword)

			Case $oOK
				__IniWriteEx($oINI, $oINI_Various_Array[2][0], $oINI_Various_Array[2][1], __GetDuplicateMode(GUICtrlRead($oComboItems[1])))
				__IniWriteEx($oINI, $oINI_Various_Array[6][0], $oINI_Various_Array[6][1], __GetCompressionLevel(GUICtrlRead($oComboItems[2])))
				__IniWriteEx($oINI, $oINI_Various_Array[10][0], $oINI_Various_Array[10][1], __GetCompressionLevel(GUICtrlRead($oComboItems[5])))
				__IniWriteEx($oINI, $oINI_Various_Array[5][0], $oINI_Various_Array[5][1], GUICtrlRead($oComboItems[8]))
				__IniWriteEx($oINI, $oINI_Various_Array[7][0], $oINI_Various_Array[7][1], GUICtrlRead($oComboItems[3]))
				__IniWriteEx($oINI, $oINI_Various_Array[11][0], $oINI_Various_Array[11][1], GUICtrlRead($oComboItems[6]))

				$oState = GUICtrlRead($oComboItems[4])
				If $oState = __Lang_Get('COMPRESS_ENCRYPT', 'None') Then
					$oState = "None"
				EndIf
				__IniWriteEx($oINI, $oINI_Various_Array[8][0], $oINI_Various_Array[8][1], $oState)

				$oState = GUICtrlRead($oComboItems[7])
				If $oState = __Lang_Get('COMPRESS_ENCRYPT', 'None') Then
					$oState = "None"
				EndIf
				__IniWriteEx($oINI, $oINI_Various_Array[12][0], $oINI_Various_Array[12][1], $oState)

				_GUICtrlComboBoxEx_GetItemText($oLanguageCombo, _GUICtrlComboBoxEx_GetCurSel($oLanguageCombo), $oLanguage)
				__SetCurrentLanguage($oLanguage) ; Set The Selected Language To The Settings INI File.

				If __Is("UseSendTo", $oINI) And GUICtrlRead($oCheckItems[4]) <> 1 Then
					__SendTo_Uninstall() ; Remove SendTo Integration If It Is Been Disabled Now.
				EndIf

				If __Is("CreateLog", $oINI) And GUICtrlRead($oCheckItems[5]) <> 1 And FileExists($oLogFile[1][0] & $oLogFile[2][0]) Then
					__Log_Write("===== " & __Lang_Get('LOG_DISABLED', 'Log Disabled') & " =====")
				EndIf
				If __Is("CreateLog", $oINI) = 0 And GUICtrlRead($oCheckItems[5]) = 1 Then
					$oLogWrite = 1 ; Needed To Write "Log Enabled" After Log Activation.
				EndIf

				If _GUICtrlListView_GetItemCount($oListView_Handle) = 0 Then
					GUICtrlSetState($oCheckItems[17], $GUI_UNCHECKED) ; Disable Monitoring If ListView Is Empty.
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

				If $oLogWrite = 1 Then
					__Log_Write("===== " & __Lang_Get('LOG_ENABLED', 'Log Enabled') & " =====")
				EndIf

				If GUICtrlRead($oCheckItems[12]) = 1 Then
					_StartupFolder_Install("DropIt")
				Else
					_StartupFolder_Uninstall("DropIt")
				EndIf

				$oState = "Permanent"
				If GUICtrlRead($oCheckModeItems[1]) = 1 Then
					$oState = "Portable"
				EndIf
				__IniWriteEx($oINI, $oINI_Various_Array[1][0], $oINI_Various_Array[1][1], $oState)

				$Global_Timer = GUICtrlRead($oScanTime)
				__IniWriteEx($oINI, $oINI_Various_Array[4][0], $oINI_Various_Array[4][1], $Global_Timer)
				If GUICtrlRead($oCheckItems[17]) <> 1 Then
					$Global_Timer = 0 ; Monitoring Disabled.
				EndIf

				$oPW = ""
				If StringIsSpace(GUICtrlRead($oZIPPassword)) = 0 And GUICtrlRead($oZIPPassword) <> "" Then
					$oPW = _StringEncrypt(1, GUICtrlRead($oZIPPassword), $oPW_Code)
				EndIf
				__IniWriteEx($oINI, $oINI_Various_Array[9][0], $oINI_Various_Array[9][1], $oPW)
				If $oPW = "" And BitAND(GUICtrlGetState($oZIPPassword), $GUI_ENABLE) Then
					$oDisablePassword = 1
				EndIf

				$oPW = ""
				If StringIsSpace(GUICtrlRead($o7ZPassword)) = 0 And GUICtrlRead($o7ZPassword) <> "" Then
					$oPW = _StringEncrypt(1, GUICtrlRead($o7ZPassword), $oPW_Code)
				EndIf
				__IniWriteEx($oINI, $oINI_Various_Array[13][0], $oINI_Various_Array[13][1], $oPW)
				If $oPW = "" And BitAND(GUICtrlGetState($o7ZPassword), $GUI_ENABLE) Then
					$oDisablePassword = 1
				EndIf

				$oPW = ""
				If StringIsSpace(GUICtrlRead($oMasterPassword)) = 0 And GUICtrlRead($oMasterPassword) <> "" Then
					$oPW = _StringEncrypt(1, GUICtrlRead($oMasterPassword), $oPW_Code)
				EndIf
				__IniWriteEx($oINI, $oINI_Various_Array[3][0], $oINI_Various_Array[3][1], $oPW)
				If $oPW = "" And GUICtrlRead($oCheckItems[10]) = 1 Then
					$oDisablePassword = 1
				EndIf

				If $oDisablePassword Then
					$oMsgBox = MsgBox(0x4, __Lang_Get('OPTIONS_ENCRYPTION_MSGBOX_0', 'Encryption Problem'), __Lang_Get('OPTIONS_ENCRYPTION_MSGBOX_1', 'Encryption features need a password to be used, do you wish to disable them?'), 0, __OnTop($oGUI))
					If $oMsgBox <> 6 Then
						$oDisablePassword = 0
						ContinueLoop
					EndIf
					If GUICtrlRead($oZIPPassword) = "" Then
						__IniWriteEx($oINI, $oINI_Various_Array[8][0], $oINI_Various_Array[8][1], "None")
					EndIf
					If GUICtrlRead($o7ZPassword) = "" Then
						__IniWriteEx($oINI, $oINI_Various_Array[12][0], $oINI_Various_Array[12][1], "None")
					EndIf
					If GUICtrlRead($oMasterPassword) = "" Then
						__IniWriteEx($oINI, $oINI_TrueOrFalse_Array[10][0], $oINI_TrueOrFalse_Array[10][1], "False")
					EndIf
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

	If $Global_ScriptRefresh = 0 Then ; To Restart DropIt With A Possible Changed Position.
		__SetCurrentPosition() ; Set Current Coordinates/Position Of DropIt.
	EndIf
	If $Global_MultipleInstance Then
		__SetMultipleInstances("-")
	EndIf
	__Log_Write("===== " & __Lang_Get('DROPIT_CLOSED', 'DropIt Closed') & " =====")

	If __CheckMultipleInstances() = 0 Then ; Check The Number Of Multiple Instances.
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

	If _WinAPI_GetFocus() <> $sIcon_1 Then
		Return SetError(1, 0, 0) ; Required Because HotKeys Automatically Minimise The GUI.
	EndIf
	GUISetState(@SW_HIDE, $sGUI_1)
	$Global_GUI_State = 0
	TraySetState(1)
	TraySetClick(8)
	TraySetToolTip("DropIt [" & $sCurrentProfile & "]")
	If __Is("CustomTrayIcon") Then
		__Tray_SetIcon(__IsProfile(-1, 2))
	EndIf
	OnAutoItExitUnRegister("_ExitEvent") ; Required To Perform Exit Event Only Once.

	Return 1
EndFunc   ;==>_TrayMenu_ShowTray

Func _TrayMenu_ShowGUI()
	Local $sGUI_1 = $Global_GUI_1
	Local $sIcon_1 = GUICtrlGetHandle($Global_Icon_1)

	If _WinAPI_GetFocus() = $sIcon_1 Then
		Return SetError(1, 0, 0) ; Required Because HotKeys Automatically Minimise The GUI.
	EndIf
	_Refresh_Image() ; Refresh Target Image.
	GUISetState(@SW_SHOW, $sGUI_1)
	$Global_GUI_State = 1
	TraySetState(2)
	OnAutoItExitRegister("_ExitEvent") ; Required To Perform Exit Event Only Once.

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
			TraySetToolTip("DropIt [" & $pTrayMenu[$A][1] & "]")
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
	$cIDFrom = _WinAPI_LoWord($iwParam)
	Switch $cWndFrom
		Case $cListViewRules_ComboBox
			Switch _WinAPI_HiWord($iwParam)
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
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND

Func WM_CONTEXTMENU($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam, $ilParam
	If $Global_MenuDisable Then
		Return 0
	EndIf
	Return $GUI_RUNDEFMSG
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
		Return SetError(2, 0, 0) ; String Is Blank.
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
	Return $GUI_RUNDEFMSG
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
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_HSCROLL

Func WM_LBUTTONDBLCLK($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $ilParam
	If _WinAPI_HiWord($iwParam) = 1 Then ; If A Double Click Is Detected.
		_TrayMenu_ShowTray() ; Show The TrayMenu.
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_LBUTTONDBLCLK

Func WM_MOUSEWHEEL($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $ilParam
	Local $mWheel = 1 ; Down.
	If _WinAPI_HiWord($iwParam) > 0 Then
		$mWheel = 2 ; Up.
	EndIf
	$Global_Wheel = $mWheel
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_MOUSEWHEEL

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $tNMLISTVIEW
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
						$tNMLISTVIEW = DllStructCreate($tagNMLISTVIEW, $ilParam)
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
				Case $LVN_ITEMCHANGED
					$tNMLISTVIEW = DllStructCreate($tagNMLISTVIEW, $ilParam)
					If BitAND(DllStructGetData($tNMLISTVIEW, "Changed"), $LVIF_STATE) = $LVIF_STATE Then
						Switch DllStructGetData($tNMLISTVIEW, "NewState")
							Case 8192 ; Item Checked.
								$Global_ListViewFolders_ItemChange = $nIndex
							Case 4096 ; Item Unchecked.
								$Global_ListViewFolders_ItemChange = $nIndex
						EndSwitch
					EndIf
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func WM_SYSCOMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $ilParam
	If __Is("LockPosition") And $hWnd = $Global_GUI_1 And (_IsPressed(10) And _IsPressed(01)) = 0 Then
		If BitAND($iwParam, 0x0000FFF0) = $SC_MOVE Then
			Return 0
		EndIf
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_SYSCOMMAND
#EndRegion >>>>> MAIN: WM_MESSAGES Functions <<<<<

#Region >>>>> INTERNAL: 7Zip Functions <<<<<
Func __7ZipCommands($cType, $cDestinationFilePath = -1, $cCustom = 0, $cPassword = "")
	#cs
		Description: Update 7-Zip Commands And Output Archive Format.
		Returns: Needed Commands
	#ce
	Local $cCommand = "a "
	If FileExists($cDestinationFilePath) Then
		If $cType = 3 Then ; Update Archive.
			$cCommand = "u "
		Else ; Create New Archive.
			FileDelete($cDestinationFilePath)
		EndIf
	EndIf

	If ($cType = 0 Or $cType = 3) And $cCustom = 0 Then ; Compress With Default Parameters.
		$cCommand &= '-tzip -mm=Deflate -mx5 -mem=AES256 -sccUTF-8 -ssw '
		Return $cCommand & '"' & $cDestinationFilePath & '"'
	EndIf

	Local $cINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $c7ZipFormat = __GetFileExtension($cDestinationFilePath)
	Local $cEncryption, $cINI_Password, $cPassword_Code = $Global_Password_Key
	If $c7ZipFormat = "7z" Or $c7ZipFormat = "exe" Then
		$cINI_Password = IniRead($cINI, "General", "7ZPassword", "")
	Else
		$cINI_Password = IniRead($cINI, "General", "ZIPPassword", "")
	EndIf
	$cINI_Password = _StringEncrypt(0, $cINI_Password, $cPassword_Code)
	If @error Then
		$cINI_Password = ""
	EndIf
	If $cPassword <> "" Then
		$cINI_Password = $cPassword
	EndIf
	If $cType = 1 Then
		Return "x -p" & $cINI_Password
	EndIf

	Switch $c7ZipFormat
		Case "7z", "exe"
			If $c7ZipFormat = "7z" Then
				$cCommand &= '-t7z '
			Else
				$cCommand &= '-sfx7z.sfx '
			EndIf
			$cCommand &= '-m0=' & IniRead($cINI, "General", "7ZMethod", "LZMA") & ' '
			$cCommand &= '-mx' & IniRead($cINI, "General", "7ZLevel", "5") & ' -mhe '
			$cEncryption = StringReplace(IniRead($cINI, "General", "7ZEncryption", "None"), "-", "")
		Case Else ; zip.
			$cCommand &= '-tzip '
			$cCommand &= '-mm=' & IniRead($cINI, "General", "ZIPMethod", "Deflate") & ' '
			$cCommand &= '-mx' & IniRead($cINI, "General", "ZIPLevel", "5") & ' '
			$cEncryption = StringReplace(IniRead($cINI, "General", "ZIPEncryption", "None"), "-", "")
	EndSwitch
	If $cEncryption <> "None" Then
		$cCommand &= '-mem=' & $cEncryption & ' '
		$cCommand &= '-p' & $cINI_Password & ' '
	EndIf
	$cCommand &= '-sccUTF-8 -ssw '

	Return $cCommand & '"' & $cDestinationFilePath & '"'
EndFunc   ;==>__7ZipCommands

Func __7ZipRun($rSourceFilePath, $rDestinationFilePath, $rType = 0, $rCustom = 0, $rNotWait = 0, $rPassword = "")
	#cs
		Description: Compress/Extract/Check Using 7-Zip.
		Returns: Output FilePath [C:\Test.7z]
	#ce
	Local $rCommand, $rProcess, $7Zip = @ScriptDir & "\Lib\7z\7z.exe"
	If FileExists($7Zip) = 0 Or $rSourceFilePath = "" Or $rDestinationFilePath = "" Then
		Return SetError(1, 0, 0)
	EndIf

	Switch $rType
		Case 0, 3 ; Compress Modes (0 = Create, 3 = Update).
			$rCommand = '"' & $7Zip & '" ' & __7ZipCommands($rType, $rDestinationFilePath, $rCustom) & ' -- "' & $rSourceFilePath & '"'

		Case 1 ; Extract Mode.
			$rCommand = '"' & $7Zip & '" ' & __7ZipCommands($rType, -1, $rCustom, $rPassword) & ' -y -o"' & $rDestinationFilePath & '" -- "' & $rSourceFilePath & '"'

		Case 2 ; Check Mode.
			$rCommand = '"' & $7Zip & '" l -slt -- "' & $rSourceFilePath & '"'
			$rNotWait = 1

		Case Else
			Return SetError(1, 0, 0)
	EndSwitch

	If $rNotWait = 1 Then
		$rProcess = Run($rCommand, "", @SW_HIDE, $STDOUT_CHILD)
		If @error Then
			Return SetError(1, 0, 0)
		EndIf
	Else
		$rProcess = RunWait($rCommand, "", @SW_HIDE)
		If FileExists($rDestinationFilePath) = 0 Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf

	If $rType = 2 Then
		Local $rLineRead
		While 1
			$rLineRead &= StdoutRead($rProcess)
			If @error Then
				ExitLoop
			EndIf
		WEnd
		If StringInStr($rLineRead, "encrypted archive") Or StringInStr($rLineRead, "Encrypted = +") Then ; Archive Encrypted.
			Return SetError(2, 0, 0) ; Password Needed.
		ElseIf StringInStr($rLineRead, "Encrypted = -") = 0 Then ; Not Archive.
			Return SetError(1, 0, 0)
		EndIf
	EndIf

	Return $rProcess
EndFunc   ;==>__7ZipRun
#EndRegion >>>>> INTERNAL: 7Zip Functions <<<<<

#Region >>>>> INTERNAL: FTP Functions <<<<<
Func __FTP_ListToArrayEx($sSession, $sRemoteDir = "", $ReturnType = 0, $iFlags = 0, $fTimeFormat = 1)
	If $sSession = 0 Then
		Return SetError(1, 0, 0)
	EndIf

	Local $aFileList, $sPreviousDir, $iError = 0
	$sPreviousDir = _FTP_DirGetCurrent($sSession)
	_FTP_DirSetCurrent($sSession, $sRemoteDir)
	$aFileList = _FTP_ListToArrayEx($sSession, $ReturnType, $iFlags, $fTimeFormat)
	$iError = @error
	_FTP_DirSetCurrent($sSession, $sPreviousDir)
	If $iError Then
		Return SetError($iError, 0, $aFileList)
	EndIf

	Return $aFileList
EndFunc   ;==>__FTP_ListToArrayEx

Func __FTP_ProgressUpload($l_FTPSession, $s_LocalFile, $s_RemoteFile, $l_Progress1, $l_Progress2, $fSize) ; Modified From: http://www.autoitscript.com/forum/topic/113542-ftp-upload-issue/
	#cs
		Description: Uploads A File In Binary Mode And Update Progress Bars.
		Returns: 1
	#ce
	If $__ghWinInet_FTP = -1 Then
		Return SetError(2, 0, 0)
	EndIf

	Local $fHandle = FileOpen($s_LocalFile, 16)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	Local $ai_FTPOpenFile = DllCall($__ghWinInet_FTP, 'handle', 'FtpOpenFileW', 'handle', $l_FTPSession, 'wstr', $s_RemoteFile, 'dword', $GENERIC_WRITE, 'dword', $FTP_TRANSFER_TYPE_BINARY, 'dword_ptr', 0)
	If @error Or $ai_FTPOpenFile[0] = 0 Then
		Return SetError(3, 0, 0)
	EndIf

	Local Const $ChunkSize = 256 * 1024
	Local $fLast = Mod($fSize, $ChunkSize)
	Local $fParts = Ceiling($fSize / $ChunkSize)
	Local $fBuffer = DllStructCreate("byte[" & $ChunkSize & "]")
	Local $ai_InternetCloseHandle, $ai_FTPWrite, $fOut, $fPercent
	Local $X = $ChunkSize
	Local $fDone = 0

	For $A = 1 To $fParts
		If $A = $fParts And $fLast > 0 Then
			$X = $fLast
		EndIf
		DllStructSetData($fBuffer, 1, FileRead($fHandle, $X))

		$ai_FTPWrite = DllCall($__ghWinInet_FTP, 'bool', 'InternetWriteFile', 'handle', $ai_FTPOpenFile[0], 'ptr', DllStructGetPtr($fBuffer), 'dword', $X, 'dword*', $fOut)
		If @error Or $ai_FTPWrite[0] = 0 Then
			$ai_InternetCloseHandle = DllCall($__ghWinInet_FTP, 'bool', 'InternetCloseHandle', 'handle', $ai_FTPOpenFile[0])
			FileClose($fHandle)
			Return SetError(4, 0, 0)
		EndIf
		$fDone += $X

		$fPercent = Round($fDone / $fSize * 100)
		If GUICtrlRead($l_Progress2) <> $fPercent Then
			GUICtrlSetData($l_Progress2, $fPercent)
			$fPercent = __GetPercent($fDone, 0)
			If GUICtrlRead($l_Progress1) <> $fPercent Then
				GUICtrlSetData($l_Progress1, $fPercent)
			EndIf
		EndIf

		If $Global_AbortSorting Then
			$ai_InternetCloseHandle = DllCall($__ghWinInet_FTP, 'bool', 'InternetCloseHandle', 'handle', $ai_FTPOpenFile[0])
			DllCall($__ghWinInet_FTP, 'bool', 'FtpDeleteFileW', 'handle', $l_FTPSession, 'wstr', $s_RemoteFile)
			FileClose($fHandle)
			Return SetError(6, 0, 0)
		EndIf
		Sleep(10)
	Next
	FileClose($fHandle)

	$ai_InternetCloseHandle = DllCall($__ghWinInet_FTP, 'bool', 'InternetCloseHandle', 'handle', $ai_FTPOpenFile[0])
	If @error Or $ai_InternetCloseHandle[0] = 0 Then
		Return SetError(5, 0, 0)
	EndIf

	Return 1
EndFunc   ;==>__FTP_ProgressUpload

Func __SFTP_ProgressUpload($sSession, $sLocalFile, $sRemoteFile, $sProgress_1, $sProgress_2, $sSize)
	#cs
		Description: Uploads A File With SFTP Protocol And Update Progress Bars.
		Returns: 1
	#ce
	If ProcessExists($sSession) = 0 Then
		Return SetError(1, 0, 0)
	EndIf

	If $sRemoteFile <> "" Then
		$sRemoteFile = ' "' & $sRemoteFile & '"'
	EndIf
	Local $sLine, $sInitialBytes, $sReadBytes, $sPercent, $sError
	If _WinAPI_PathIsDirectory($sLocalFile) Then
		$sLine = '-r '
	EndIf

	StdinWrite($sSession, 'put ' & $sLine & '-- "' & $sLocalFile & '"' & $sRemoteFile & @CRLF)
	$sReadBytes = ProcessGetStats($sSession, 1)
	$sInitialBytes = $sReadBytes[3]
	While 1
		$sLine = StdoutRead($sSession)
		If ProcessExists($sSession) = 0 Then
			$sError = 1
			ExitLoop
		ElseIf StringInStr($sLine, "psftp>") Then
			ExitLoop
		ElseIf StringInStr($sLine, "=> remote:") Then
			ContinueLoop
		ElseIf StringInStr($sLine, "unable to open") Then
			$sError = 2
			ExitLoop
		ElseIf StringInStr($sLine, "Cannot create directory") Then
			$sError = 3
			ExitLoop
		ElseIf $sLine <> "" Then
			$sError = 5
			ExitLoop
		EndIf

		$sReadBytes = ProcessGetStats($sSession, 1)
		$sPercent = Round(($sReadBytes[3] - $sInitialBytes) / $sSize * 100)
		If GUICtrlRead($sProgress_2) <> $sPercent Then
			GUICtrlSetData($sProgress_2, $sPercent)
			$sPercent = __GetPercent($sReadBytes[3] - $sInitialBytes, 0)
			If GUICtrlRead($sProgress_1) <> $sPercent Then
				GUICtrlSetData($sProgress_1, $sPercent)
			EndIf
		EndIf

		If $Global_AbortSorting Then
			ProcessClose($sSession)
			$sError = 4
			ExitLoop
		EndIf
		Sleep(10)
	WEnd

	If $sError Then
		Return SetError($sError, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>__SFTP_ProgressUpload
#EndRegion >>>>> INTERNAL: FTP Functions <<<<<

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
	$aReturn[4] = 100 ; Opacity.
	$aReturn[5] = $sImagePath[8] ; FilePath.

	__ImageWrite($sProfile, 7, $aReturn[1], $aReturn[2], $aReturn[3], $aReturn[4]) ; Write Image File Name & Size & Opacity To The Selected Profile.
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

Func __ImageWrite($sProfile = -1, $iFlag = 1, $sImagePath = -1, $iSize_X = 64, $iSize_Y = 64, $iOpacity = 100)
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
	If BitAND($iFlag, 4) Then ; 4 = Add Opacity.
		__IniWriteEx($sProfile, "Target", "Opacity", StringReplace($iOpacity, "%", ""))
		IniDelete($sProfile, "Target", "Transparency")
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
	$sData = StringStripWS($sData, 7)
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
	$iOK = GUICtrlCreateButton("OK", 115 - 38, 40, 76, 24)
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

Func __List_Write($lFilePath, $lListPath, $lSize)
	#cs
		Description: Write Properties Of A File In The Defined List.
		Returns: 1
	#ce
	Local $lStringSplit = StringSplit($lListPath, "|") ; Separate List File Path, List Properties, Profile, Rules And Association Name.
	$lListPath = $lStringSplit[1]
	Local $lListType = __GetFileExtension($lListPath)

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
		Local $lStyle, $lLoadCSS, $lArrayCSS[4] = [3, "base.css", "lighterbox2.css", "themes\" & $lTheme & ".css"]
		For $A = 1 To $lArrayCSS[0]
			If $A = 2 And __Is("ListLightbox") = 0 Then ; Lightbox Disabled.
				ContinueLoop
			EndIf
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
				'<div id="dropitList">' & @CRLF & @CRLF & _
				'<div id="di-bg-header"></div>' & @CRLF & @CRLF & _
				'<div id="di-container">' & @CRLF & @CRLF & _
				'<div id="di-main-wrap">' & @CRLF & @CRLF & _
				'<div id="di-header-wrap">' & @CRLF & @CRLF & _
				'<div id="di-header">' & @CRLF & _
				@TAB & '<h1>' & $lListName & '</h1>' & @CRLF & _
				@TAB & '<ul id="di-infoline">' & @CRLF & _
				@TAB & @TAB & '<li><strong>' & __Lang_Get('LIST_HTML_CREATED', 'Created') & '</strong>: ' & @MDAY & '/' & @MON & '/' & @YEAR & ' ' & @HOUR & ':' & @MIN & '</li>' & @CRLF & _
				@TAB & @TAB & '<li><strong>' & __Lang_Get('PROFILE', 'Profile') & '</strong>: ' & $lProfile & '</li>' & @CRLF & _
				@TAB & @TAB & '<li><strong>' & __Lang_Get('RULES', 'Rules') & '</strong>: ' & $lRules & '</li>' & @CRLF & _
				@TAB & @TAB & '<li class="di-last"><strong>' & __Lang_Get('LIST_HTML_TOTAL', 'Total') & '</strong>: <span id="di-count">0</span></li>' & @CRLF & _
				@TAB & '</ul>' & @CRLF & _
				'</div><!-- #di-header -->' & @CRLF & _
				'</div><!-- #di-header-wrap -->' & @CRLF & @CRLF

		Local $lColumns = '<div id="di-table">' & @CRLF & _
				'<table id="di-mainTable" cellpadding="0" cellspacing="0">' & @CRLF & _
				'<thead>' & @CRLF & '<tr>' & @CRLF
		For $A = 1 To $lStringSplit[0]
			Switch $lStringSplit[$A]
				Case "#"
					$lColumns &= @TAB & '<th class="di-right">&nbsp;</th>' & @CRLF
				Case Else
					$lColumns &= @TAB & '<th>' & $lStringSplit[$A] & '</th>' & @CRLF
			EndSwitch
		Next
		$lColumns &= '</tr>' & @CRLF & '</thead>' & @CRLF

		Local $lJavaScript, $lLoadJS, $lArrayJS[4][2] = [[3, 3],["ListSortable", "sortable.js"],["ListFilter", "filter.js"],["ListLightbox", "lighterbox2.js"]]
		For $A = 1 To $lArrayJS[0][0]
			If __Is($lArrayJS[$A][0]) Then
				Switch $A
					Case 2 ; ListFilter Translation.
						$lJavaScript = 'var clearFilterText = "' & __Lang_Get('LIST_HTML_CLEARFILTER', 'clear filter') & '";' & @CRLF & _
								'var noResultsText = "' & __Lang_Get('LIST_HTML_NORESULTS', 'No results for this term') & ':";' & @CRLF & _
								'var searchFieldText = "' & __Lang_Get('LIST_HTML_FILTER', 'filter') & '...";' & @CRLF & @CRLF
					Case 3 ; ListLightbox Translation.
						$lJavaScript = 'var viewText = "' & __Lang_Get('VIEW', 'View') & '";' & @CRLF & @CRLF
				EndSwitch
				$lJavaScript &= FileRead(@ScriptDir & "\Lib\list\" & $lArrayJS[$A][1])
				If @error = 0 Then
					$lLoadJS &= '<script type="text/javascript" charset="utf-8">' & @CRLF & '//<![CDATA[' & @CRLF & $lJavaScript & @CRLF & '//]]>' & @CRLF & '</script>' & @CRLF
				EndIf
				$lJavaScript = ""
			EndIf
		Next
		If $lLoadJS <> "" Then ; Add Code To Correctly Load JavaScript.
			$lLoadJS = '<script type="text/javascript" charset="utf-8">' & @CRLF & _
					'function addLoadEvent(func) {' & @CRLF & _
					@TAB & 'var oldonload = window.onload;' & @CRLF & _
					@TAB & @TAB & 'if (typeof window.onload != "function") {' & @CRLF & _
					@TAB & @TAB & @TAB & 'window.onload = func' & @CRLF & _
					@TAB & @TAB & '} else {' & @CRLF & _
					@TAB & @TAB & @TAB & 'window.onload = function() {' & @CRLF & _
					@TAB & @TAB & @TAB & @TAB & 'if (oldonload) {' & @CRLF & _
					@TAB & @TAB & @TAB & @TAB & @TAB & 'oldonload()' & @CRLF & _
					@TAB & @TAB & @TAB & @TAB & '}' & @CRLF & _
					@TAB & @TAB & @TAB & 'func()' & @CRLF & _
					@TAB & @TAB & '}' & @CRLF & _
					@TAB & '}' & @CRLF & _
					'}' & @CRLF & _
					'</script>' & @CRLF & $lLoadJS
		EndIf

		Local $lFooter = '<tbody>' & @CRLF & $lCurrentEnd & @CRLF & '</tbody>' & @CRLF & '</table>' & @CRLF & '</div><!-- #table -->' & @CRLF & @CRLF & _
				'</div><!-- #di-main-wrap -->' & @CRLF & @CRLF & _
				'<div id="di-footer-wrap">' & @CRLF & _
				@TAB & '<div id="di-footer">' & @CRLF & _
				@TAB & '<p>' & @CRLF & _
				@TAB & @TAB & 'Generated with <a id="di-homeLink" href="%URL%" title="Visit DropIt website" target="_blank">DropIt</a> <span>- Sort your files with a drop!</span>' & @CRLF & _
				@TAB & '</p>' & @CRLF & _
				@TAB & '<a id="di-top" href="#" title="Go to top">top</a>' & @CRLF & _
				@TAB & '</div><!-- #di-footer -->' & @CRLF & _
				'</div><!-- #di-footer-wrap -->' & @CRLF & @CRLF & _
				'</div><!-- #di-container -->' & @CRLF & @CRLF & _
				'</div><!-- #dropitList -->' & @CRLF & @CRLF

		$lFileRead = $lHeader & $lColumns & $lFooter & $lLoadJS & @CRLF & '</body>' & @CRLF & '</html>'
	EndIf

	$lNumber = StringRegExp($lFileRead, '<span id="di-count">(.*?)</span>', 3)
	$lFileRead = StringReplace($lFileRead, '<span id="di-count">' & $lNumber[0] & '</span>', '<span id="di-count">' & $lNumber[0] + 1 & '</span>', 0, 1)

	For $A = 1 To $lStringSplit[0]
		If $lArray[$A] = "" Then
			$lArray[$A] = "-"
		EndIf
		Switch $lStringSplit[$A]
			Case __Lang_Get('LIST_LABEL_9', 'Absolute Link')
				$lString &= @TAB & '<td class="di-center"><a href="file:///' & $lArray[$A] & '" target="_blank">' & __Lang_Get('LINK', 'Link') & '</a></td>' & @CRLF
			Case __Lang_Get('LIST_LABEL_10', 'Relative Link')
				$lString &= @TAB & '<td class="di-center"><a href="' & StringReplace($lArray[$A], "\", "/") & '" target="_blank">' & __Lang_Get('LINK', 'Link') & '</a></td>' & @CRLF
			Case __Lang_Get('LIST_LABEL_3', 'Size')
				$lString &= @TAB & '<td class="di-right">' & $lArray[$A] & '</td>' & @CRLF
			Case "#"
				$lString &= @TAB & '<td class="di-right">' & $lNumber[0] + 1 & '</td>' & @CRLF
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
Func __ArrayToProfile($aArray, $sProfileName, $sProfileDirectory = -1, $sImage = -1, $sSize = "64")
	#cs
		Description: Create A Profile From An Array.
		Return: Profile Name
	#ce
	Local $sString, $sIniWrite
	If $sProfileDirectory = -1 Then
		$sProfileDirectory = __GetDefault(2) ; Get Default Profile Directory.
	EndIf
	If $sImage = -1 Then
		$sImage = __GetDefault(16) ; Get Default Image File.
	EndIf
	$sProfileName = __IsProfileUnique($sProfileName) ; Check If The Selected Profile Name Is Unique.
	If @error Then
		$sProfileName = __GetFileNameOnly(_Duplicate_Rename($sProfileName & ".ini", $sProfileDirectory, 0, 2))
	EndIf

	For $A = 2 To $aArray[0][0]
		If ($aArray[$A][2] & $aArray[$A][3]) = "" Or StringLeft($aArray[$A][2], 1) = "[" Then
			ContinueLoop
		EndIf
		$aArray[$A][1] = StringReplace($aArray[$A][1], "|", "")
		$aArray[$A][2] = StringReplace($aArray[$A][2], "=", "")
		$aArray[$A][4] = StringReplace($aArray[$A][4], "|", "")
		If StringInStr($aArray[$A][2], "*") = 0 And __Is("UseRegEx") = 0 Then ; Fix Rules Without * Characters.
			$aArray[$A][2] = "*" & $aArray[$A][2]
		EndIf

		Switch $aArray[$A][3]
			Case "Extract"
				If StringInStr($aArray[$A][2], "**") Then
					ContinueLoop
				EndIf
			Case "Open With"
				If StringInStr($aArray[$A][4], "%DefaultProgram%") = 0 And (__IsValidFileType($aArray[$A][4], "bat;cmd;com;exe;pif") = 0 Or StringInStr($aArray[$A][4], "DropIt.exe")) Then ; DropIt.exe Is Excluded To Avoid Loops.
					ContinueLoop
				EndIf
			Case "Create List"
				If __IsValidFileType($aArray[$A][4], "html;htm;txt;csv;xml") = 0 Then
					ContinueLoop
				EndIf
			Case "Compress"
				If __IsValidFileType($aArray[$A][4], "zip;7z;exe") = 0 And StringInStr($aArray[$A][4], ".") Then
					ContinueLoop
				EndIf
			Case "Create Playlist"
				If StringInStr($aArray[$A][2], "**") Then
					ContinueLoop
				EndIf
				If __IsValidFileType($aArray[$A][4], "m3u;m3u8;pls;wpl") = 0 Then
					ContinueLoop
				EndIf
			Case "Delete"
				Switch $aArray[$A][4]
					Case "Safely Erase"
						$aArray[$A][4] = 2
					Case "Send to Recycle Bin"
						$aArray[$A][4] = 3
					Case Else ; Directly Remove.
						$aArray[$A][4] = 1
				EndSwitch
			Case "Copy to Clipboard"
				Switch $aArray[$A][4]
					Case "File Name"
						$aArray[$A][4] = 2
					Case "MD5 Hash"
						$aArray[$A][4] = 3
					Case "SHA-1 Hash"
						$aArray[$A][4] = 4
					Case Else ; Full Path.
						$aArray[$A][4] = 1
				EndSwitch
			Case "Ignore"
				$aArray[$A][4] = "-"
		EndSwitch

		$sString &= __GetAssociationString($aArray[$A][3], $aArray[$A][2]) & "=" & $aArray[$A][4] & "|" & $aArray[$A][1] & "||Enabled||" & @LF
	Next

	$sIniWrite = $sProfileDirectory & $sProfileName & ".ini"
	__IniWriteEx($sIniWrite, "Target", "", "Image=" & $sImage & @LF & "SizeX=" & $sSize & @LF & "SizeY=" & $sSize & @LF & "Opacity=100")
	__IniWriteEx($sIniWrite, "General", "", "")
	__IniWriteEx($sIniWrite, "Associations", "", $sString)

	Return $sProfileName
EndFunc   ;==>__ArrayToProfile

Func __GetCurrentProfile()
	#cs
		Description: Get The Current Profile Name From The Settings INI File.
		Return: Profile Name [Profile Name]
	#ce
	Local $sINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $sINIRead = IniRead($sINI, "General", "Profile", "Default")
	If $Global_MultipleInstance Then
		$sINIRead = IniRead($sINI, $Global_UniqueID, "Profile", $sINIRead)
	EndIf
	Return $sINIRead
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
		__IniWriteEx($gReturn[0], "Target", "", "Image=" & $gProfileDefault[3][0] & @LF & "SizeX=64" & @LF & "SizeY=64" & @LF & "Opacity=100")
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
		__IniWriteEx($gReturn[0], "Target", "Opacity", 100)
		IniDelete($gReturn[0], "Target", "Transparency")
	EndIf

	$gReturn[3] = $gProfileDefault[2][0] & $gReturn[4] ; Image File FullPath.
	$gReturn[5] = IniRead($gReturn[0], "Target", "SizeX", "64") ; Image SizeX
	$gReturn[6] = IniRead($gReturn[0], "Target", "SizeY", "64") ; Image SizeY
	$gReturn[7] = IniRead($gReturn[0], "Target", "Opacity", "100") ; Image Opacity
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
		[7] - Image Opacity [100] (Percentage)
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

Func __IsProfileUnique($sProfile, $sShowMessage = 0, $hHandle = -1)
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
			If $sShowMessage Then
				MsgBox(0x40, __Lang_Get('PROFILEUNIQUE_MSGBOX_0', 'Name not available'), __Lang_Get('PROFILEUNIQUE_MSGBOX_1', 'This profile name already exists.'), 0, __OnTop($hHandle))
			EndIf
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
	$iOK = GUICtrlCreateButton(__Lang_Get('OK', 'OK'), 115 - 76 - 15, 40, 76, 24)
	$iCancel = GUICtrlCreateButton(__Lang_Get('CANCEL', 'Cancel'), 115 + 15, 40, 76, 24)
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
		Returns: Number Of Multiple Instances Running
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

Func __CloseAll()
	#cs
		Description: Close All Instances Of DropIt.
		Returns: Nothing
	#ce
	If __CheckMultipleInstances() > 0 Then
		Local $aArray = __GetMultipleInstancesRunning()
		For $A = 1 To $aArray[0][0]
			ProcessClose($aArray[$A][2])
			$Global_UniqueID = $aArray[$A][0]
			__SetMultipleInstances("-")
		Next
		__IniWriteEx(__IsSettingsFile(), "General", "SwitchCommand", "True")
	EndIf
	Exit
EndFunc   ;==>__CloseAll

Func __CMDLine($aCmdLine)
	#cs
		Description: Check If CommandLine Is Correct And Processes Accordingly.
		Returns: 1
	#ce
	Local $aDroppedFiles[$aCmdLine[0] + 1] = [$aCmdLine[0]], $iIndex = 0, $sProfile

	If $aDroppedFiles[0] = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	Switch $aCmdLine[1]
		Case "/Close"
			__CloseAll()
		Case "/Refresh"
			$Global_ScriptRefresh = 1
			__ScriptRestart()
		Case "/Restart"
			__ScriptRestart()
		Case "/Uninstall"
			__Uninstall()
	EndSwitch

	For $A = 1 To $aDroppedFiles[0]
		Switch StringLeft($aCmdLine[$A], 1)
			Case "-" ; Profile Parameter.
				$sProfile = StringTrimLeft($aCmdLine[$A], 1)
				If FileExists(__GetDefault(2) & $sProfile & ".ini") = 0 Then ; __GetDefault(2) = Get Default Profile Directory.
					$sProfile = __ProfileList_GUI() ; Show Profile Selection GUI To Select A Profile From The Profile List.
					If @error Then
						Exit ; Close DropIt If Profile Selection Is Aborted.
					EndIf
				EndIf
				$iIndex += 1

			Case Else ; Item Parameter.
				$aDroppedFiles[$A - $iIndex] = _WinAPI_GetFullPathName($aCmdLine[$A])
		EndSwitch
	Next
	ReDim $aDroppedFiles[$aCmdLine[0] + 1 - $iIndex]
	$aDroppedFiles[0] = $aCmdLine[0] - $iIndex

	If $sProfile <> "" Then
		If $aDroppedFiles[0] = 0 Then ; Start DropIt With Defined Profile If Is The Only Parameter.
			__SetCurrentProfile($sProfile) ; Write Default Profile Name To The Settings INI File.
			Return SetError(2, 0, 0) ; Start DropIt With Defined Profile.
		EndIf
	Else
		$sProfile = __GetCurrentProfile() ; Get Current Profile From The Settings INI File.
	EndIf
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
	Local $eEnvironmentArray[14][2] = [ _
			[13, 2], _
			["License", "Open Source GPL"], _ ; Returns: DropIt License [Open Source GPL]
			["PortableDrive", StringLeft(@AutoItExe, 2)], _ ; Returns: Drive Letter [C: Without The Trailing "\"]
			["AppData", @AppDataDir], _ ; Returns: AppData Path [C:\Users\{username}\AppData\Roaming]
			["AppDataPublic", @AppDataCommonDir], _ ; Returns: Public AppData Path [C:\ProgramData]
			["Desktop", @DesktopDir], _ ; Returns: Desktop Path [C:\Users\{username}\Desktop]
			["DesktopPublic", @DesktopCommonDir], _ ; Returns: Public Desktop Path [C:\Users\Public\Desktop]
			["Documents", @MyDocumentsDir], _ ; Returns: Documents Path [C:\Users\{username}\Documents]
			["DocumentsPublic", @DocumentsCommonDir], _ ; Returns: Public Documents Path [C:\Users\Public\Documents]
			["Favorites", @FavoritesDir], _ ; Returns: Favorites Path [C:\Users\{username}\Favorites]
			["FavoritesPublic", @FavoritesCommonDir], _ ; Returns: Public Favorites Path [C:\Users\Public\Favorites]
			["Team", "Lupo PenSuite Team"], _ ; Returns: Team Name [Lupo PenSuite Team]
			["URL", "http://dropit.sourceforge.net/index.htm"], _ ; Returns: URL Hyperlink [http://dropit.sourceforge.net/index.htm]
			["VersionNo", $Global_CurrentVersion]] ; Returns: Version Number [1.0]

	For $A = 1 To $eEnvironmentArray[0][0]
		EnvSet($eEnvironmentArray[$A][0], $eEnvironmentArray[$A][1])
	Next

	Local $eINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $eSection = __IniReadSection($eINI, "EnvironmentVariables")
	If @error Or $eSection[0][0] = 0 Then
		Return 1
	EndIf
	For $A = 1 To $eSection[0][0]
		EnvSet($eSection[$A][0], $eSection[$A][1])
	Next
	Return 1
EndFunc   ;==>__EnvironmentVariables

Func __GetAssociationField($gProfile, $gAction, $gAssociation, $gField)
	#cs
		Description: Get String Of The Defined Association Field.
		Returns: String [0;1;2;3;11;13]
	#ce
	Local $gStringSplit, $gNumberFields = $Global_NumberFields

	$gAssociation = __GetAssociationString($gAction, $gAssociation) ; Get Association String.
	$gStringSplit = StringSplit(IniRead($gProfile, "Associations", $gAssociation, ""), "|")
	If @error Then
		Return ""
	EndIf
	ReDim $gStringSplit[$gNumberFields + 1]

	Return $gStringSplit[$gField]
EndFunc   ;==>__GetAssociationField

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
		[0][0] - Number Of Rows [?]
		[0][1] - Number Of Colums [3]

		[A][0] - Multiple Instance Name [1_DropIt_MultipleInstance]
		[A][1] - Multiple Instance Handle [0x123456]
		[A][2] - Multiple Instance PID [1234]
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

Func __GetAssociations($gProfile = -1, $gNumberFields = $Global_NumberFields)
	#cs
		Description: Get Associations In The Current Profile [-1] Or Specified Profile Name [Valid Profile Name].
		Returns: Array[0][0] - Number Of Items [?]
		[0][1] - Number Of Fields [6]
		[0][2] - Profile Name [Profile Name]

		Array[A][0] - Rule [*.exe$2]
		[A][1] - Destination [C:\DropIt Files]
		[A][2] - Association Name [Executables]
		[A][3] - Filters [1<20MB;1<20d;1<20d;1<20d]
		[A][4] - Association Enabled/Disabled [Enabled]
		[A][5] - List Properties [0;1;2;3;11;13]
		[A][6] - FTP Settings [Host;Port;User;Password]
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
				$gAssociationString = __Lang_Get('ACTION_LIST', 'Create List')
			Case "$9"
				$gAssociationString = __Lang_Get('ACTION_PLAYLIST', 'Create Playlist')
			Case "$A"
				$gAssociationString = __Lang_Get('ACTION_SHORTCUT', 'Create Shortcut')
			Case "$B"
				$gAssociationString = __Lang_Get('ACTION_CLIPBOARD', 'Copy to Clipboard')
			Case "$C"
				$gAssociationString = __Lang_Get('ACTION_UPLOAD', 'Upload')
			Case "$D"
				$gAssociationString = __Lang_Get('ACTION_CHANGE_PROPERTIES', 'Change Properties')
			Case Else ; Move.
				$gAssociationString = __Lang_Get('ACTION_MOVE', 'Move')
		EndSwitch
	Else
		Switch $gAction
			Case __Lang_Get('ACTION_COPY', 'Copy'), 'Copy'
				$gAssociationString = $gRule & "$1"
			Case __Lang_Get('ACTION_IGNORE', 'Ignore'), 'Ignore'
				$gAssociationString = $gRule & "$2"
			Case __Lang_Get('ACTION_COMPRESS', 'Compress'), 'Compress'
				$gAssociationString = $gRule & "$3"
			Case __Lang_Get('ACTION_EXTRACT', 'Extract'), 'Extract'
				$gAssociationString = $gRule & "$4"
			Case __Lang_Get('ACTION_OPEN_WITH', 'Open With'), 'Open With'
				$gAssociationString = $gRule & "$5"
			Case __Lang_Get('ACTION_DELETE', 'Delete'), 'Delete'
				$gAssociationString = $gRule & "$6"
			Case __Lang_Get('ACTION_RENAME', 'Rename'), 'Rename'
				$gAssociationString = $gRule & "$7"
			Case __Lang_Get('ACTION_LIST', 'Create List'), 'Create List'
				$gAssociationString = $gRule & "$8"
			Case __Lang_Get('ACTION_PLAYLIST', 'Create Playlist'), 'Create Playlist'
				$gAssociationString = $gRule & "$9"
			Case __Lang_Get('ACTION_SHORTCUT', 'Create Shortcut'), 'Create Shortcut'
				$gAssociationString = $gRule & "$A"
			Case __Lang_Get('ACTION_CLIPBOARD', 'Copy to Clipboard'), 'Copy to Clipboard'
				$gAssociationString = $gRule & "$B"
			Case __Lang_Get('ACTION_UPLOAD', 'Upload'), 'Upload'
				$gAssociationString = $gRule & "$C"
			Case __Lang_Get('ACTION_CHANGE_PROPERTIES', 'Change Properties'), 'Change Properties'
				$gAssociationString = $gRule & "$D"
			Case Else ; __Lang_Get('ACTION_MOVE', 'Move').
				$gAssociationString = $gRule & "$0"
		EndSwitch
	EndIf

	Return $gAssociationString
EndFunc   ;==>__GetAssociationString

Func __GetCompressionLevel($gLevel)
	#cs
		Description: Get Compression Level Code [3] Or Compression Level String [Normal].
	#ce
	Local $gCompressionString

	If StringIsDigit($gLevel) Then
		Switch $gLevel
			Case "1"
				$gCompressionString = __Lang_Get('COMPRESS_LEVEL_0', 'Fastest')
			Case "3"
				$gCompressionString = __Lang_Get('COMPRESS_LEVEL_1', 'Fast')
			Case "7"
				$gCompressionString = __Lang_Get('COMPRESS_LEVEL_3', 'Maximum')
			Case "9"
				$gCompressionString = __Lang_Get('COMPRESS_LEVEL_4', 'Ultra')
			Case Else ; 5.
				$gCompressionString = __Lang_Get('COMPRESS_LEVEL_2', 'Normal')
		EndSwitch
	Else
		Switch $gLevel
			Case __Lang_Get('COMPRESS_LEVEL_0', 'Fastest')
				$gCompressionString = "1"
			Case __Lang_Get('COMPRESS_LEVEL_1', 'Fast')
				$gCompressionString = "3"
			Case __Lang_Get('COMPRESS_LEVEL_3', 'Maximum')
				$gCompressionString = "7"
			Case __Lang_Get('COMPRESS_LEVEL_4', 'Ultra')
				$gCompressionString = "9"
			Case Else ; __Lang_Get('COMPRESS_LEVEL_2', 'Normal').
				$gCompressionString = "5"
		EndSwitch
	EndIf

	Return $gCompressionString
EndFunc   ;==>__GetCompressionLevel

Func __GetDuplicateMode($gMode, $gForCombo = 0)
	#cs
		Description: Get Duplicate Mode Code [Overwrite2] Or Duplicate Mode String [Overwrite if newer].
	#ce
	Local $gDuplicateString

	If $gForCombo Then
		Switch $gMode
			Case "Overwrite1"
				$gDuplicateString = __Lang_Get('DUPLICATE_MODE_0', 'Overwrite')
			Case "Overwrite2"
				$gDuplicateString = __Lang_Get('DUPLICATE_MODE_1', 'Overwrite if newer')
			Case "Overwrite3"
				$gDuplicateString = __Lang_Get('DUPLICATE_MODE_7', 'Overwrite if different size')
			Case "Rename1"
				$gDuplicateString = __Lang_Get('DUPLICATE_MODE_3', 'Rename as "Name 01"')
			Case "Rename2"
				$gDuplicateString = __Lang_Get('DUPLICATE_MODE_4', 'Rename as "Name_01"')
			Case "Rename3"
				$gDuplicateString = __Lang_Get('DUPLICATE_MODE_5', 'Rename as "Name (01)"')
			Case Else ; Skip.
				$gDuplicateString = __Lang_Get('DUPLICATE_MODE_6', 'Skip')
		EndSwitch
	Else
		Switch $gMode
			Case __Lang_Get('DUPLICATE_MODE_0', 'Overwrite')
				$gDuplicateString = "Overwrite1"
			Case __Lang_Get('DUPLICATE_MODE_1', 'Overwrite if newer')
				$gDuplicateString = "Overwrite2"
			Case __Lang_Get('DUPLICATE_MODE_7', 'Overwrite if different size')
				$gDuplicateString = "Overwrite3"
			Case __Lang_Get('DUPLICATE_MODE_3', 'Rename as "Name 01"')
				$gDuplicateString = "Rename1"
			Case __Lang_Get('DUPLICATE_MODE_4', 'Rename as "Name_01"')
				$gDuplicateString = "Rename2"
			Case __Lang_Get('DUPLICATE_MODE_5', 'Rename as "Name (01)"')
				$gDuplicateString = "Rename3"
			Case Else ; __Lang_Get('DUPLICATE_MODE_6', 'Skip').
				$gDuplicateString = "Skip"
		EndSwitch
	EndIf

	Return $gDuplicateString
EndFunc   ;==>__GetDuplicateMode

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

Func __GUIInBounds($hHandle = $Global_GUI_1) ; Original Idea By wraithdu, Modified By guinness.
	#cs
		Description: Check If The GUI Is Within View Of The Users Screen.
		Returns: Move GUI If Out Of Bounds
	#ce
	Local $iXPos = 5, $iYPos = 5, $tWorkArea = DllStructCreate($tagRECT)
	_WinAPI_SystemParametersInfo($SPI_GETWORKAREA, 0, DllStructGetPtr($tWorkArea))

	Local $iLeft = DllStructGetData($tWorkArea, "Left"), $iTop = DllStructGetData($tWorkArea, "Top")
	Local $iWidth = DllStructGetData($tWorkArea, "Right") - $iLeft
	If _WinAPI_GetSystemMetrics($SM_CYVIRTUALSCREEN) > $iWidth Then
		$iWidth = _WinAPI_GetSystemMetrics($SM_CYVIRTUALSCREEN)
	EndIf
	$iWidth -= $iLeft
	Local $iHeight = DllStructGetData($tWorkArea, "Bottom") - $iTop
	Local $aWinGetPos = WinGetPos($hHandle)
	If @error Then
		Return SetError(1, 0, WinMove($hHandle, "", $iXPos, $iYPos))
	EndIf

	If $aWinGetPos[0] < $iLeft Then
		$iXPos = $iLeft
	ElseIf ($aWinGetPos[0] + $aWinGetPos[2]) > $iWidth Then
		$iXPos = $iWidth - $aWinGetPos[2]
	Else
		$iXPos = $aWinGetPos[0]
	EndIf

	If $aWinGetPos[1] < $iTop Then
		$iYPos = $iTop
	ElseIf ($aWinGetPos[1] + $aWinGetPos[3]) > $iHeight Then
		$iYPos = $iHeight - $aWinGetPos[3]
	Else
		$iYPos = $aWinGetPos[1]
	EndIf
	WinMove($hHandle, "", $iXPos, $iYPos)
	Return __SetCurrentPosition($hHandle)
EndFunc   ;==>__GUIInBounds

Func __InsertPassword($iFileName)
	Local $iCancel, $iGUI, $iInput, $iOK, $iPassword

	$iGUI = GUICreate(__Lang_Get('PASSWORD_MSGBOX_0', 'Enter Password'), 320, 150, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($Global_SortingGUI))
	GUICtrlCreateGraphic(0, 0, 320, 60)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlSetColor(-1, 0xffffff)

	GUICtrlCreateLabel(__Lang_Get('PASSWORD_MSGBOX_4', 'Loaded archive:'), 14, 12, 292, 18)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlCreateLabel($iFileName, 16, 12 + 18, 288, 30)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlSetFont(-1, -1, 800)

	GUICtrlCreateLabel(__Lang_Get('PASSWORD_MSGBOX_5', 'Password for decryption:'), 14, 66, 292, 18)
	$iInput = GUICtrlCreateInput("", 14, 83, 292, 20)

	$iOK = GUICtrlCreateButton(__Lang_Get('OK', 'OK'), 160 - 80 - 30, 116, 80, 24)
	$iCancel = GUICtrlCreateButton(__Lang_Get('CANCEL', 'Cancel'), 160 + 30, 116, 80, 24)
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

Func __Is($iData, $iINI = -1, $iDefault = "False", $iProfile = -2)
	#cs
		Description: For INI Parameters That Use True/False Results, Therefore It Can Be Called As If __Is("DropItOn") Then ... , Simply Means If DropItOn Is True.
		Returns: True/False
	#ce
	If $iProfile <> -2 Then ; Try To Load It As A Profile Setting.
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
				"StartAtStartup=False" & @LF & "Minimized=False" & @LF & "ShowSorting=True" & @LF & "UseSendTo=False" & @LF & "SendToMode=Permanent" & @LF & _
				"ProfileEncryption=False" & @LF & "WaitOpened=False" & @LF & "ScanSubfolders=True" & @LF & "DirForFolders=False" & @LF & "IgnoreNew=False" & @LF & _
				"AutoDup=False" & @LF & "DupMode=Skip" & @LF & "UseRegEx=False" & @LF & "CreateLog=False" & @LF & "IntegrityCheck=False" & @LF & "AmbiguitiesCheck=False" & @LF & _
				"AlertSize=True" & @LF & "AlertDelete=False" & @LF & "ListHeader=True" & @LF & "ListSortable=True" & @LF & "ListFilter=True" & @LF & "ListLightbox=True" & @LF & _
				"ListTheme=Default" & @LF & "Monitoring=False" & @LF & "MonitoringTime=60" & @LF & "ZIPLevel=5" & @LF & "ZIPMethod=Deflate" & @LF & _
				"ZIPEncryption=None" & @LF & "ZIPPassword=" & @LF & "7ZLevel=5" & @LF & "7ZMethod=LZMA" & @LF & "7ZEncryption=None" & @LF & _
				"7ZPassword=" & @LF & "MasterPassword="

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
	$pOK = GUICtrlCreateButton(__Lang_Get('OK', 'OK'), 120 - 15 - 76, 46, 76, 25)
	$pCancel = GUICtrlCreateButton(__Lang_Get('CANCEL', 'Cancel'), 120 + 15, 46, 76, 25)
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

Func __ScriptRestart($sExit = 1) ; Modified From: http://www.autoitscript.com/forum/topic/111215-restart-udf/
	#cs
		Description: Restarts The Running Process.
		Returns: Nothing
	#ce
	If WinGetHandle($Global_UniqueID) = "" Then
		Exit ; To Not Start If It Is Closed.
	EndIf
	$CmdLineRaw = ""
	If $Global_ScriptRestart = 0 Then
		Local $sPid
		If @Compiled Then
			$sPid = Run(@ScriptFullPath & ' ' & $CmdLineRaw, @ScriptDir, Default, 1)
		Else
			$sPid = Run(@AutoItExe & ' "' & @ScriptFullPath & '" ' & $CmdLineRaw, @ScriptDir, Default, 1)
		EndIf
		If @error Then
			Return SetError(@error, 0, 0)
		EndIf
		StdinWrite($sPid, @AutoItPID)
	EndIf
	$Global_ScriptRestart = 1
	__IniWriteEx(__IsSettingsFile(), "General", "SwitchCommand", "True")
	If $sExit Then
		Sleep(50)
		Exit
	EndIf
	Return 1
EndFunc   ;==>__ScriptRestart

Func __SendTo_Install() ; Taken From: http://www.autoitscript.com/forum/topic/129818-sendto-create-a-shortcut-in-the-sendto-folder/
	#cs
		Description: Create Shortcuts In The SendTo Folder. [DropIt (Profile_Name).lnk]
		Returns: 1
	#ce
	Local $aFileListToArray

	$aFileListToArray = __ProfileList_Get() ; Get Array Of All Profiles.
	If IsArray($aFileListToArray) = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	For $A = 1 To $aFileListToArray[0]
		FileCreateShortcut(@AutoItExe, _WinAPI_ShellGetSpecialFolderPath($CSIDL_SENDTO) & "\DropIt (" & $aFileListToArray[$A] & ").lnk", @ScriptDir, "-" & $aFileListToArray[$A])
	Next
	Return 1
EndFunc   ;==>__SendTo_Install

Func __SendTo_Uninstall() ; Taken From: http://www.autoitscript.com/forum/topic/129818-sendto-create-a-shortcut-in-the-sendto-folder/
	#cs
		Description: Delete Shortcuts In The SendTo Folder. [DropIt (Profile_Name).lnk]
		Returns: 1
	#ce
	Local $aFileGetShortcut, $aFileListToArray, $sSendTo_Directory

	$sSendTo_Directory = _WinAPI_ShellGetSpecialFolderPath($CSIDL_SENDTO) & "\"
	$aFileListToArray = __FileListToArrayEx($sSendTo_Directory, "*")
	If @error Then
		Return SetError(2, 0, 0)
	EndIf

	For $A = 1 To $aFileListToArray[0]
		If StringInStr($aFileListToArray[$A], "DropIt") Then
			$aFileGetShortcut = FileGetShortcut($aFileListToArray[$A])
			If IsArray($aFileGetShortcut) = 0 Then
				ContinueLoop
			EndIf
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
	Local $sNewString, $sStringSplit, $sNumberFields = $Global_NumberFields

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

Func __SetMonitoredFolderState($sINI, $sFolder, $sProfile, $sState)
	#cs
		Description: Enable/Disable The Monitored Folder.
		Return: 1
	#ce
	If $sState Then
		$sState = "Enabled"
	Else
		$sState = "Disabled"
	EndIf
	__IniWriteEx($sINI, "MonitoredFolders", $sFolder, $sProfile & "|" & $sState)

	Return 1
EndFunc   ;==>__SetMonitoredFolderState

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
			If __Is("SwitchCommand", -1, "False") Then
				IniDelete(__IsSettingsFile(), "General", "SwitchCommand")
				Exit
			EndIf
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
	If __Is("UseSendTo") Then
		__SendTo_Uninstall() ; SendTo Integration Is Removed If Was Used By The Installed Version.
	EndIf
	If __IsInstalled() And FileExists(@AppDataDir & "\DropIt") Then
		Local $uMsgBox = MsgBox(0x4, __Lang_Get('UNINSTALL_MSGBOX_0', 'Remove settings'), __Lang_Get('UNINSTALL_MSGBOX_1', 'Do you want to remove also your settings and profiles?'))
		If $uMsgBox = 6 Then
			DirRemove(@AppDataDir & "\DropIt", 1)
		EndIf
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

	Local $uINI_Array[49][3] = [ _
			[48, 3], _
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
			["General", "WaitOpened", 1], _
			["General", "UseSendTo", 1], _
			["General", "SendToMode", 1], _
			["General", "ShowSorting", 1], _
			["General", "ProfileEncryption", 1], _
			["General", "ScanSubfolders", 1], _
			["General", "DirForFolders", 1], _
			["General", "IgnoreNew", 1], _
			["General", "AutoDup", 1], _
			["General", "DupMode", 1], _
			["General", "UseRegEx", 1], _
			["General", "CreateLog", 1], _
			["General", "IntegrityCheck", 1], _
			["General", "AmbiguitiesCheck", 1], _
			["General", "SizeMessage", "AlertSize"], _
			["General", "AlertSize", 1], _
			["General", "AlertDelete", 1], _
			["General", "ListHeader", 1], _
			["General", "ListSortable", 1], _
			["General", "ListFilter", 1], _
			["General", "ListLightbox", 1], _
			["General", "ListTheme", 1], _
			["General", "CheckUpdates", 1], _
			["General", "Monitoring", 1], _
			["General", "MonitoringTime", 1], _
			["General", "ZIPLevel", 1], _
			["General", "ZIPMethod", 1], _
			["General", "ZIPEncryption", 1], _
			["General", "ZIPPassword", 1], _
			["General", "7ZLevel", 1], _
			["General", "7ZMethod", 1], _
			["General", "7ZEncryption", 1], _
			["General", "7ZPassword", 1], _
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

	$uINIRead = ""
	Local $uReadMonitoredFolders = __IniReadSection($uINI & ".old", "MonitoredFolders")
	If IsArray($uReadMonitoredFolders) Then
		For $A = 1 To $uReadMonitoredFolders[0][0]
			$uINIRead &= $uReadMonitoredFolders[$A][0] & "=" & $uReadMonitoredFolders[$A][1] & @LF
		Next
	EndIf
	__IniWriteEx($uINI, "MonitoredFolders", "", $uINIRead)

	$uINIRead = ""
	Local $uReadEnvironmentVariables = __IniReadSection($uINI & ".old", "EnvironmentVariables")
	If IsArray($uReadEnvironmentVariables) Then
		For $A = 1 To $uReadEnvironmentVariables[0][0]
			$uINIRead &= $uReadEnvironmentVariables[$A][0] & "=" & $uReadEnvironmentVariables[$A][1] & @LF
		Next
	EndIf
	__IniWriteEx($uINI, "EnvironmentVariables", "", $uINIRead)

	FileDelete($uINI & ".old") ; Remove The Old INI.

	If $uOldVersion < "3.7" Then
		Local $uFileRead, $uFileOpen, $uAssociations, $uNumberFields = $Global_NumberFields
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

#Region >>>>> LIBRARY: CSV Split Functions <<<<< Taken From: http://www.autoitscript.com/forum/topic/123398-snippet-dump/page__view__findpost__p__934152
Func __CSVSplit($sString, $sDelim = ",")
	If IsString($sString) = 0 Or $sString = "" Or IsString($sDelim) = 0 Or $sDelim = "" Then
		Return SetError(1, 0, 0)
	EndIf

	Local $iOverride = 255, $asDelim[3] ; Replacements For Delimiters.
	For $A = 0 To 2
		$asDelim[$A] = __CSVGetSubstitute($sString, $iOverride, $sDelim) ; Choose A Suitable Substitution Character.
		If @error Then
			Return SetError(1, 0, 0)
		EndIf
	Next
	$iOverride = 0

	Local $aArray = StringRegExp($sString, '\A[^"]+|("+[^"]+)|"+\z', 3) ; Split String Using Double Quotes Delimiter.
	$sString = ""

	For $A = 0 To UBound($aArray) - 1
		$iOverride += StringInStr($aArray[$A], '"', 0, -1)
		If Mod($iOverride + 2, 2) = 0 Then
			$aArray[$A] = StringReplace($aArray[$A], $sDelim, $asDelim[0])
			$aArray[$A] = StringRegExpReplace($aArray[$A], "(\r\n)|[\r\n]", $asDelim[1])
		EndIf
		$aArray[$A] = StringReplace($aArray[$A], '""', $asDelim[2])
		$aArray[$A] = StringReplace($aArray[$A], '"', '')
		$aArray[$A] = StringReplace($aArray[$A], $asDelim[2], '"')
		$sString &= $aArray[$A]
	Next
	$iOverride = 0

	$aArray = StringSplit($sString, $asDelim[1], 2) ; Split To Get Rows.
	Local $iBound = UBound($aArray)
	Local $aCSV[$iBound + 1][2], $aTemp
	For $A = 1 To $iBound
		$aTemp = StringSplit($aArray[$A - 1], $asDelim[0]) ; Split To Get Row Items.
		If @error = 0 Then
			If $aTemp[0] > $iOverride Then
				$iOverride = $aTemp[0]
				ReDim $aCSV[$iBound + 1][$iOverride + 1]
			EndIf
		EndIf
		For $B = 1 To $aTemp[0]
			If StringLen($aTemp[$B]) Then
				If StringRegExp($aTemp[$B], '[^"]') = 0 Then ; Field Only Contains Double Quotes.
					$aTemp[$B] = StringTrimLeft($aTemp[$B], 1) ; Delete Enclosing Double Quote Single Char.
				EndIf
				$aCSV[$A][$B] = $aTemp[$B] ; Populate Each Row.
			EndIf
		Next
	Next
	$aCSV[0][0] = $iBound ; Number Of Rows.
	$aCSV[0][1] = $iOverride + 1 ; Number Of Columns.

	Return $aCSV
EndFunc   ;==>__CSVSplit

Func __CSVGetSubstitute($sString, ByRef $iCountdown, $sAvoid = "")
	If $iCountdown < 1 Then
		Return SetError(1, 0, "")
	EndIf
	Local $sTestChar
	For $A = $iCountdown To 1 Step -1
		$sTestChar = Chr($A)
		$iCountdown -= 1
		If StringInStr($sString, $sTestChar, 2) = 0 Then
			If $A = 34 Or $A = 13 Or $A = 10 Or StringInStr($sAvoid, $sTestChar) Then ; Some Characters May Interfere With Parsing.
				ContinueLoop
			EndIf
			Return $sTestChar
		EndIf
	Next
	Return SetError(1, 0, "")
EndFunc   ;==>__CSVGetSubstitute
#EndRegion >>>>> LIBRARY: CSV Split Functions <<<<< Taken From: http://www.autoitscript.com/forum/topic/123398-snippet-dump/page__view__findpost__p__934152

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
		For $A = 1 To 3 ; Rename The File 3 Times.
			$sTempFile = _WinAPI_GetTempFileName($sDir)
			FileMove($sFile, $sTempFile, 1)
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
	Local $A, $iPlaces = 1, $aArray[9] = ["bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
	While $iBytes > 1023
		$A += 1
		$iBytes /= 1024
	WEnd
	If $iBytes < 100 Then
		$iPlaces += 1
	EndIf
	Return Round($iBytes, $iPlaces) & " " & $aArray[$A]
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

Func __DateTimeStandard($sInputDateTime, $fAsString = 0, $sDateFormat = "", $sTimeFormat = "") ; Modified Version Of A GreenCan's Function - http://www.autoitscript.com/forum/topic/98597-universal-date-format-conversion/
	#cs
		Description: Convert A Datetime From System Current User Format Or Specified Format To YYYY/MM/DD[ HH:MM:SS]
		Returns: Array Of Values Or Formatted Datetime [2012/03/18 16:30:25]
	#ce
	Local $sReturnString, $aReturnArray[6], $sInputDate, $sInputTime, $sYear, $sMonth, $sDay, $sHour, $sMin, $sSec
	Local $sDateSep, $sTimeSep, $sAM, $sPM, $isPM, $sTestDate, $aStringSplit1[9], $aStringSplit2[9]

	If $sDateFormat = "" Then
		$sDateFormat = RegRead("HKEY_CURRENT_USER\Control Panel\International", "sShortDate")
		$sDateSep = RegRead("HKEY_CURRENT_USER\Control Panel\International", "sDate")
	Else
		For $A = 1 To StringLen($sDateFormat)
			If Not (StringMid($sDateFormat, $A, 1) = "y") And Not (StringMid($sDateFormat, $A, 1) = "m") And Not (StringMid($sDateFormat, $A, 1) = "d") Then
				$sDateSep = StringMid($sDateFormat, $A, 1)
				ExitLoop
			EndIf
		Next
	EndIf
	If $sTimeFormat = "" Then
		$sTimeFormat = RegRead("HKEY_CURRENT_USER\Control Panel\International", "sTimeFormat")
		$sTimeSep = RegRead("HKEY_CURRENT_USER\Control Panel\International", "sTime")
		$sAM = RegRead("HKEY_CURRENT_USER\Control Panel\International", "s1159")
		$sPM = RegRead("HKEY_CURRENT_USER\Control Panel\International", "s2359")
	Else
		For $A = 1 To StringLen($sTimeFormat)
			If Not (StringMid($sTimeFormat, $A, 1) = "h") Then
				$sTimeSep = StringMid($sTimeFormat, $A, 1)
				ExitLoop
			EndIf
		Next
		$sAM = "AM"
		$sPM = "PM"
	EndIf

	If StringInStr($sInputDateTime, "T") Then $sInputDateTime = StringReplace($sInputDateTime, "T", " ")
	If StringInStr($sInputDateTime, " ") Then
		$sInputDate = StringLeft($sInputDateTime, StringInStr($sInputDateTime, " ") - 1)
		$sInputTime = StringStripWS(StringReplace($sInputDateTime, $sInputDate, ""), 7)
	Else
		$sInputDate = $sInputDateTime
		$sInputTime = ""
	EndIf

	$sTestDate = StringReplace($sInputDate, $sDateSep, "")
	If StringRegExpReplace($sTestDate, "[0-9]", "") <> "" Then Return SetError(1, 0, "")
	If StringInStr($sInputDate, $sDateSep) = 0 And $sDateSep <> "" Then Return SetError(1, 0, "")
	If $sInputTime <> "" Then
		$sTestDate = StringReplace($sInputTime, $sTimeSep, "")
		$sTestDate = StringReplace($sTestDate, $sAM, "")
		$sTestDate = StringReplace($sTestDate, $sPM, "")
		$sTestDate = StringReplace($sTestDate, " ", "")
		If StringRegExpReplace($sTestDate, "[0-9]", "") <> "" Then Return SetError(2, 0, "")
		If StringInStr($sInputTime, $sTimeSep) = 0 And $sTimeSep <> "" Then Return SetError(2, 0, "")
	EndIf

	If $sDateFormat = "YYYYMMDD" Then
		$sYear = StringMid($sInputDate, 1, 4)
		$sMonth = StringMid($sInputDate, 5, 2)
		$sDay = StringMid($sInputDate, 7, 2)
	Else
		$aStringSplit1 = StringSplit($sDateFormat, $sDateSep)
		$aStringSplit2 = StringSplit($sInputDate, $sDateSep)
		For $A = 1 To $aStringSplit1[0]
			If StringInStr($aStringSplit1[$A], "m") Then $sMonth = $aStringSplit2[$A]
			If StringInStr($aStringSplit1[$A], "d") Then $sDay = $aStringSplit2[$A]
			If StringInStr($aStringSplit1[$A], "y") Then $sYear = $aStringSplit2[$A]
		Next
	EndIf

	If StringLen($sMonth) = 1 Then $sMonth = "0" & $sMonth
	If StringLen($sDay) = 1 Then $sDay = "0" & $sDay
	If StringLen($sYear) = 2 Then
		If $sYear > 70 Then
			$sYear = "19" & $sYear
		Else
			$sYear = "20" & $sYear
		EndIf
	EndIf

	$sReturnString = $sYear & "/" & $sMonth & "/" & $sDay
	$aReturnArray[0] = $sYear
	$aReturnArray[1] = $sMonth
	$aReturnArray[2] = $sDay
	$aReturnArray[3] = "00"
	$aReturnArray[4] = "00"
	$aReturnArray[5] = "00"

	If $sInputTime <> "" Then
		$isPM = 0
		If StringInStr($sInputTime, $sAM) Then
			$sInputTime = StringReplace($sInputTime, " " & $sAM, "")
			$isPM = 1
		ElseIf StringInStr($sInputTime, $sPM) Then
			$sInputTime = StringReplace($sInputTime, " " & $sPM, "")
			$isPM = 2
		EndIf
		$aStringSplit1 = StringSplit($sTimeFormat, $sTimeSep)
		$aStringSplit2 = StringSplit($sInputTime, $sTimeSep)
		$sSec = "00"
		For $A = 1 To $aStringSplit2[0]
			If StringInStr($aStringSplit1[$A], "h") Then $sHour = $aStringSplit2[$A]
			If StringInStr($aStringSplit1[$A], "m") Then $sMin = $aStringSplit2[$A]
			If StringInStr($aStringSplit1[$A], "s") Then $sSec = $aStringSplit2[$A]
		Next

		If $isPM = 1 And $sHour = 12 Then $sHour = "00"
		If $isPM = 2 And $sHour < 12 Then $sHour = $sHour + 12
		If StringLen($sHour) = 1 Then $sHour = "0" & $sHour
		If StringLen($sMin) = 1 Then $sMin = "0" & $sMin
		If StringLen($sSec) = 1 Then $sSec = "0" & $sSec

		$sReturnString &= " " & $sHour & ":" & $sMin & ":" & $sSec
		$aReturnArray[3] = $sHour
		$aReturnArray[4] = $sMin
		$aReturnArray[5] = $sSec
	EndIf

	If $fAsString = 0 Then
		Return $aReturnArray
	Else
		Return $sReturnString
	EndIf
EndFunc   ;==>__DateTimeStandard

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

Func __FileCompareDate($sSource, $sDestination, $fDestinationIsDate = 0, $iMethod = 0) ; Modified From: http://www.autoitscript.com/forum/topic/125127-compare-file-datetime-stamps/page__p__868705#entry868705
	#cs
		Description: Check If Source File Is Newer Than Destination File [Or Given Date].
		Returns: 1 If Newer Or 0 If Equal Or -1 If Older
	#ce
	Local $iDate1, $iDate2, $iDateDiff
	$iDate1 = StringRegExpReplace(FileGetTime($sSource, $iMethod, 1), "(.{4})(.{2})(.{2})(.{2})(.{2})(.{2})", "\1/\2/\3 \4:\5:\6")
	If $fDestinationIsDate Then
		$iDate2 = $sDestination
	Else
		$iDate2 = StringRegExpReplace(FileGetTime($sDestination, $iMethod, 1), "(.{4})(.{2})(.{2})(.{2})(.{2})(.{2})", "\1/\2/\3 \4:\5:\6")
	EndIf
	$iDateDiff = _DateDiff("s", $iDate2, $iDate1)
	Select
		Case $iDateDiff > 0
			Return 1
		Case $iDateDiff = 0
			Return 0
		Case Else
			Return -1
	EndSelect
EndFunc   ;==>__FileCompareDate

Func __FileCompareSize($sSource, $sDestination, $fDestinationIsSize = 0)
	#cs
		Description: Check If Source File Is Bigger Than Destination File [Or Given Size].
		Returns: 1 If Bigger Or 0 If Equal Or -1 If Smaller
	#ce
	Local $iSize1, $iSize2, $iSizeDiff
	If _WinAPI_PathIsDirectory($sSource) Then
		$iSize1 = DirGetSize($sSource)
	Else
		$iSize1 = FileGetSize($sSource)
	EndIf
	If $fDestinationIsSize Then
		$iSize2 = $sDestination
	Else
		If _WinAPI_PathIsDirectory($sDestination) Then
			$iSize2 = DirGetSize($sDestination)
		Else
			$iSize2 = FileGetSize($sDestination)
		EndIf
	EndIf
	$iSizeDiff = $iSize1 - $iSize2
	Select
		Case $iSizeDiff > 0
			Return -1
		Case $iSizeDiff = 0
			Return 0
		Case Else
			Return 1
	EndSelect
EndFunc   ;==>__FileCompareSize

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
			"040b", "040c 080c 0c0c 100c 140c 180c", "0407 0807 0c07 1007 1407", "040e", "0410 0810", "0411", "0414 0814", "0415", "0416 0816", "0418", _
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

Func __InsertText(ByRef $hEdit, $sString) ; Modified From: http://www.autoitscript.com/forum/topic/34326-get-selected-text-and-replace/
	#cs
		Description: Insert A Text In A Control.
		Returns: Nothing
	#ce
	Local $iSelected = GUICtrlRecvMsg($hEdit, 0x00B0) ; $EM_GETSEL.
	If (IsArray($iSelected)) And ($iSelected[0] <= $iSelected[1]) Then
		GUICtrlSetData($hEdit, StringLeft(GUICtrlRead($hEdit), $iSelected[0]) & $sString & StringTrimLeft(GUICtrlRead($hEdit), $iSelected[1]))
	Else
		GUICtrlSetData($hEdit, GUICtrlRead($hEdit) & $sString)
	EndIf
EndFunc   ;==>__InsertText

Func __IsClassicTheme() ; By guinness 2011.
	#cs
		Description: Check If Windows Uses Classic Theme.
		Returns:
		If Yes Return 1
		If No Return 0
	#ce
	_WinAPI_GetCurrentThemeName()
	Return @error
EndFunc   ;==>__IsClassicTheme

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

Func __IsValidFileType($sFilePath, $sList = "bat;cmd;exe") ; Taken From: http://www.autoitscript.com/forum/topic/123674-isvalidtype/
	#cs
		Description: Check If A File Is Supported.
		Returns: 1 = True Or 0 = False
	#ce
	If StringRegExp($sList, "[\\/:<>|]") Then
		Return SetError(1, 0, -1)
	EndIf
	Return StringRegExp($sFilePath, "\.(?i:\Q" & StringReplace($sList, ";", "\E|\Q") & "\E)\z")
EndFunc   ;==>__IsValidFileType

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
	If __IsWindowsVersion() = 0 Or __IsClassicTheme() Then
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
	If $sString = "" Then
		Return 0
	EndIf
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
