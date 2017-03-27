#cs ----------------------------------------------------------------------------
	Application Name: DropIt
	License: Open Source GPL
	Language: English
	AutoIt Version: 3.3.8.1
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
#AutoIt3Wrapper_Res_Fileversion=4.5.9.0
#AutoIt3Wrapper_Res_ProductVersion=4.5.9.0
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
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\Abbreviations.ico
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

#include <ComboConstants.au3>
#include <Date.au3>
#include <DateTimeConstants.au3>
#include <DropIt_Archive.au3>
#include <DropIt_Association.au3>
#include <DropIt_Duplicate.au3>
#include <DropIt_General.au3>
#include <DropIt_Global.au3>
#include <DropIt_Image.au3>
#include <DropIt_Instance.au3>
#include <DropIt_List.au3>
#include <DropIt_Modifier.au3>
#include <DropIt_Monitored.au3>
#include <DropIt_ProfileList.au3>
#include <DropIt_Update.au3>
#include <DropIt_Upload.au3>
#include <Excel.au3>
#include <FTPEx.au3>
#include <GUIButton.au3>
#include <GUIComboBoxEx.au3>
#include <GUIImageList.au3>
#include <GUIListBox.au3>
#include <GUIListView.au3>
#include <GUIMenu.au3>
#include <GUIToolTip.au3>
#include "Lib\udf\7ZipRead.au3"
#include "Lib\udf\APIConstants.au3"
#include "Lib\udf\Copy.au3"
#include "Lib\udf\DropIt_LibCSV.au3"
#include "Lib\udf\DropIt_LibFiles.au3"
#include "Lib\udf\DropIt_LibImages.au3"
#include "Lib\udf\DropIt_LibPlaylists.au3"
#include "Lib\udf\DropIt_LibSecureDelete.au3"
#include "Lib\udf\DropIt_LibTrayIcon.au3"
#include "Lib\udf\DropIt_LibVarious.au3"
#include "Lib\udf\HashForFile.au3"
#include "Lib\udf\ImageGetInfo.au3"
#include "Lib\udf\Resources.au3"
#include "Lib\udf\SFTPEx.au3"
#include "Lib\udf\Startup.au3"
#include "Lib\udf\WinAPIEx.au3"
#include <Misc.au3>
#include <StaticConstants.au3>
#include <String.au3>
#include <WindowsConstants.au3>

Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1)

Global $Global_GUI_1, $Global_GUI_2, $Global_Icon_1, $Global_GUI_State = 1 ; ImageList & GUI Handles & Icons Handle & GUI State.
Global $Global_ContextMenu[15][2] = [[14, 2]], $Global_TrayMenu[14][2] = [[13, 2]], $Global_MenuDisable = 0 ; ContextMenu & TrayMenu.
Global $Global_ListViewIndex = -1, $Global_ListViewFolders, $Global_ListViewProfiles, $Global_ListViewRules ; ListView Variables.
Global $Global_ListViewProfiles_Enter, $Global_ListViewProfiles_New, $Global_ListViewProfiles_Delete, $Global_ListViewProfiles_Duplicate ; ListView Variables.
Global $Global_ListViewProfiles_Import, $Global_ListViewProfiles_Options, $Global_ListViewProfiles_Example[2], $Global_ListViewFolders_Enter, $Global_ListViewFolders_New ; ListView Variables.
Global $Global_ListViewRules_ComboBox, $Global_ListViewRules_ComboBoxChange = 0, $Global_ListViewRules_ItemChange = -1 ; ListView Variables.
Global $Global_ListViewRules_CopyTo, $Global_ListViewRules_Delete, $Global_ListViewRules_Enter, $Global_ListViewRules_New, $Global_ListViewFolders_ItemChange = -1 ; ListView Variables.
Global $Global_Timer, $Global_Action, $Global_MainDir, $Global_Clipboard, $Global_Wheel, $Global_ScriptRefresh, $Global_ScriptRestart ; Misc.
Global $Global_DroppedFiles[1], $Global_OpenedArchives[1][2], $Global_OpenedLists[1][2], $Global_OpenedPlaylists[1][2], $Global_PriorityActions[1] ; Misc.
Global $Global_AbortButton ; Sorting GUI.
Global $Global_ResizeWidth, $Global_ResizeHeight ; Windows Size For Resizing.
Global $Global_Slider, $Global_SliderLabel ; _Customize_GUI_Edit.

__EnvironmentVariables() ; Set The Standard & User Assigned Environment Variables.
__ExpandEnvStrings(0) ; Disable The Expansion Of Environment Variables.

__Update_Complete() ; Message After DropIt Update.
__Password_GUI() ; Ask Password If In Encrypt Mode.
__Upgrade() ; Upgrade DropIt If Required.
__SingletonEx() ; WM_COPYDATA.
__Update_Check() ; Check If DropIt Has Been Updated.

OnAutoItExitRegister("_ExitEvent")

_GDIPlus_Startup()

_Main()

#Region >>>>> Manage Functions <<<<<
Func _Manage_GUI($mINI = -1, $mHandle = -1)
	Local $mGUI, $mListView, $mListView_Handle, $mMsg, $A, $mNew, $mClose, $mProfileCombo, $mProfileCombo_Handle, $mName, $mText, $mAction, $mState, $mDestination
	Local $mIndex_Selected, $mAssociate, $mUpdateList, $mNumber, $mProfileName, $mProfileString, $mProfileText, $mCopyToDummy, $mDeleteDummy, $mEnterDummy, $mNewDummy

	Local $mProfile = __IsProfile(-1, 0) ; Get Array Of Current Profile.
	Local $mSize = __GetCurrentSize("SizeManage") ; 460 x 260.
	$mINI = __IsSettingsFile($mINI) ; Get Default Settings INI File.

	$mGUI = GUICreate(__GetLang('MANAGE_GUI', 'Manage Associations'), $mSize[0], $mSize[1], -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX), -1, __OnTop($mHandle))
	GUISetIcon(@ScriptFullPath, -7, $mGUI) ; Use Associations.ico
	$Global_ResizeWidth = 400 ; Set Default Minimum Width.
	$Global_ResizeHeight = 200 ; Set Default Minimum Height.

	$mListView = GUICtrlCreateListView(__GetLang('NAME', 'Name') & "|" & __GetLang('RULES', 'Rules') & "|" & __GetLang('ACTION', 'Action') & "|" & __GetLang('DESTINATION', 'Destination'), 0, 0, $mSize[0], $mSize[1] - 35, BitOR($LVS_NOSORTHEADER, $LVS_REPORT, $LVS_SINGLESEL))
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

	$mNew = GUICtrlCreateButton(__GetLang('NEW', 'New'), 32, $mSize[1] - 31, 85, 25)
	GUICtrlSetTip($mNew, __GetLang('MANAGE_GUI_TIP_0', 'Click to add an association or Right-click associations to modify them.'))
	GUICtrlSetResizing($mNew, $GUI_DOCKSIZE + $GUI_DOCKLEFT + $GUI_DOCKBOTTOM)

	$mProfileCombo = GUICtrlCreateCombo("", 155, $mSize[1] - 29, $mSize[0] - 310, 24, $WS_VSCROLL + $CBS_DROPDOWNLIST)
	$mProfileCombo_Handle = GUICtrlGetHandle($mProfileCombo)

	$Global_ListViewRules_ComboBox = $mProfileCombo_Handle

	GUICtrlSetData($mProfileCombo, __ProfileList_Combo(), $mProfile[1])
	GUICtrlSetTip($mProfileCombo, __GetLang('MANAGE_GUI_TIP_1', 'Select a Profile to change its associations.'))
	GUICtrlSetResizing($mProfileCombo, $GUI_DOCKSIZE + $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM)

	$mClose = GUICtrlCreateButton(__GetLang('CLOSE', 'Close'), $mSize[0] - 32 - 85, $mSize[1] - 31, 85, 25)
	GUICtrlSetTip($mClose, __GetLang('MANAGE_GUI_TIP_2', 'Save associations and close the window.'))
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
					$mProfileText = IniRead($mProfile[0], "Associations", $mProfileString, "") ; Profile INI Value [C:\Destination|Example|1<20MB;0>d;0>d;0>d|Disabled|0;1;2;3;9;13|Host;Port;User;Password].

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
	Local $mGUI, $mMsgBox, $mFolder, $mAdd_Action, $mSave, $mCancel, $mCurrentActionString, $mAbbreviation, $mListType, $mFilters[4][4], $mChanged = 0
	Local $mInput_Name, $mInput_NameRead, $mInput_Rules, $mInput_RulesRead, $mButton_Rules, $mButton_Filters, $mButton_Abbreviations, $mCombo_Action, $mInput_Ignore
	Local $mLabel_Destination, $mInput_Destination, $mInput_DestinationRead, $mButton_Destination, $mCombo_Delete, $mCombo_Clipboard, $mRename, $mInput_Rename
	Local $mSite, $mInput_Site, $mButton_Site, $mList, $mInput_List, $mButton_List, $mListName, $mListProperties, $mFileProperties, $mInput_Current
	Local $mInput_Change, $mButton_Change, $mSiteSettings, $mStringSplit

	Local $mAssociationType = __GetLang('MANAGE_ASSOCIATION_NEW', 'New Association')
	Local $mLogAssociation = __GetLang('MANAGE_LOG_0', 'Association Created')
	Local $mRename_Default = "%FileName%.%FileExt%"
	Local $mProfile = __IsProfile($mProfileName, 0) ; Get Array Of Current Profile.

	If $mFileName = -1 Then
		$mFileName = ""
	EndIf
	If $mFileExtension = -1 Then
		$mFileExtension = ""
	EndIf
	If $mInitialAction = -1 Then
		$mInitialAction = __GetLang('ACTION_MOVE', 'Move')
	EndIf
	If $mDestination = -1 Then
		$mDestination = ""
	EndIf
	If $mState = -1 Then
		$mState = 1
	EndIf
	Local $mInput_RuleData = $mFileExtension, $mCurrentAction = $mInitialAction, $mCurrentDelete = __GetLang('DELETE_MODE_1', 'Directly Remove'), $mCurrentClipboard = __GetLang('CLIPBOARD_MODE_1', 'File Path')
	Local $mCombo_ActionData = __GetLang('ACTION_MOVE', 'Move') & '|' & __GetLang('ACTION_COPY', 'Copy') & '|' & __GetLang('ACTION_COMPRESS', 'Compress') & '|' & __GetLang('ACTION_EXTRACT', 'Extract') & '|' & __GetLang('ACTION_RENAME', 'Rename') & '|' & __GetLang('ACTION_DELETE', 'Delete') & '|' & __GetLang('ACTION_UPLOAD', 'Upload') & '|' & __GetLang('ACTION_OPEN_WITH', 'Open With') & '|' & __GetLang('ACTION_LIST', 'Create List') & '|' & __GetLang('ACTION_PLAYLIST', 'Create Playlist') & '|' & __GetLang('ACTION_SHORTCUT', 'Create Shortcut') & '|' & __GetLang('ACTION_CLIPBOARD', 'Copy to Clipboard') & '|' & __GetLang('ACTION_CHANGE_PROPERTIES', 'Change Properties') & '|' & __GetLang('ACTION_IGNORE', 'Ignore')
	Local $mCombo_DeleteData = __GetLang('DELETE_MODE_1', 'Directly Remove') & '|' & __GetLang('DELETE_MODE_2', 'Safely Erase') & '|' & __GetLang('DELETE_MODE_3', 'Send to Recycle Bin')
	Local $mCombo_ClipboardData = __GetLang('CLIPBOARD_MODE_1', 'Full Path') & '|' & __GetLang('CLIPBOARD_MODE_2', 'File Name') & '|' & __GetLang('LIST_LABEL_33', 'CRC Hash') & '|' & __GetLang('LIST_LABEL_34', 'MD4 Hash') & '|' & __GetLang('LIST_LABEL_7', 'MD5 Hash') & '|' & __GetLang('LIST_LABEL_8', 'SHA-1 Hash')

	Local $mDestination_Label[9] = [ _
			__GetLang('MANAGE_DESTINATION_FOLDER', 'Destination Folder') & ":", _
			__GetLang('MANAGE_DESTINATION_PROGRAM', 'Destination Program') & ":", _
			__GetLang('MANAGE_DESTINATION_FILE', 'Destination File') & ":", _
			__GetLang('MANAGE_DESTINATION_ARCHIVE', 'Destination Archive') & ":", _
			__GetLang('MANAGE_NEW_NAME', 'New Name') & ":", _
			__GetLang('MANAGE_DELETE_MODE', 'Deletion Mode') & ":", _
			__GetLang('MANAGE_CLIPBOARD_MODE', 'Clipboard Mode') & ":", _
			__GetLang('MANAGE_REMOTE_DESTINATION', 'Remote Destination') & ":", _
			__GetLang('MANAGE_NEW_PROPERTIES', 'New Properties') & ":"]

	If $mInitialAction == __GetLang('ACTION_RENAME', 'Rename') Then
		$mRename = $mDestination
		$mDestination = "-"
	Else
		$mRename = $mRename_Default
	EndIf
	If $mInitialAction == __GetLang('ACTION_CHANGE_PROPERTIES', 'Change Properties') Then
		$mFileProperties = __GetAssociationField($mProfile[0], $mInitialAction, $mInput_RuleData, 1)
		$mDestination = "-"
	Else
		$mFileProperties = "-"
	EndIf
	If $mInitialAction == __GetLang('ACTION_LIST', 'Create List') Then
		$mListProperties = __GetAssociationField($mProfile[0], $mInitialAction, $mInput_RuleData, 5)
		$mList = $mDestination
		$mDestination = "-"
	Else
		$mList = "-"
	EndIf
	If $mInitialAction == __GetLang('ACTION_UPLOAD', 'Upload') Then
		$mSiteSettings = __GetAssociationField($mProfile[0], $mInitialAction, $mInput_RuleData, 6)
		$mStringSplit = StringSplit($mSiteSettings, ";")
		$mSite = StringTrimLeft($mDestination, StringLen($mStringSplit[1]))
		$mDestination = "-"
	Else
		$mSite = "/"
	EndIf

	Select
		Case $mNewAssociation = 0 And $mDroppedEvent = 0
			$mAssociationType = __GetLang('MANAGE_ASSOCIATION_EDIT', 'Edit Association')
			$mLogAssociation = __GetLang('MANAGE_LOG_1', 'Association Modified')
			$mFilters = _Manage_ExtractFilters($mProfile[0], $mFileExtension, $mInitialAction)

		Case $mNewAssociation = 1 And $mDroppedEvent = 1
			$mInput_RuleData = "**"
			If $mFileExtension <> "" Then
				$mInput_RuleData = "*." & $mFileExtension ; $mFileExtension = "" If Loaded Item Is A Folder.
			EndIf
	EndSelect

	$mGUI = GUICreate($mAssociationType & " [" & __GetLang('PROFILE', 'Profile') & ": " & $mProfile[1] & "]", 500, 230, -1, -1, -1, BitOR($WS_EX_ACCEPTFILES, $WS_EX_TOOLWINDOW), __OnTop($mHandle))
	GUICtrlCreateLabel(__GetLang('NAME', 'Name') & ":", 15, 12, 260, 20)
	$mInput_Name = GUICtrlCreateInput($mFileName, 10, 31, 480, 22)
	GUICtrlSetTip($mInput_Name, __GetLang('MANAGE_EDIT_TIP_0', 'Choose a name for this association.'))

	GUICtrlCreateLabel(__GetLang('RULES', 'Rules') & ":", 15, 60 + 12, 260, 20)
	$mInput_Rules = GUICtrlCreateInput($mInput_RuleData, 10, 60 + 32, 398, 22)
	GUICtrlSetTip($mInput_Rules, __GetLang('MANAGE_EDIT_TIP_1', 'Write rules for this association.'))
	$mButton_Rules = GUICtrlCreateButton("i", 10 + 403, 60 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Rules, __GetLang('MANAGE_EDIT_MSGBOX_6', 'Supported Rules'))
	GUICtrlSetImage($mButton_Rules, @ScriptFullPath, -6, 0)
	$mButton_Filters = GUICtrlCreateButton("F", 10 + 444, 60 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Filters, __GetLang('ADDITIONAL_FILTERS', 'Additional Filters'))
	GUICtrlSetImage($mButton_Filters, @ScriptFullPath, -10, 0)

	GUICtrlCreateLabel(__GetLang('ACTION', 'Action') & ":", 15, 120 + 12, 135, 20)
	$mCombo_Action = GUICtrlCreateCombo("", 10, 120 + 32, 150, 22, $WS_VSCROLL + $CBS_DROPDOWNLIST)
	$mLabel_Destination = GUICtrlCreateLabel($mDestination_Label[0], 15 + 155, 120 + 12, 220, 20)
	$mInput_Destination = GUICtrlCreateInput($mDestination, 10 + 155, 120 + 32, 243, 22)
	GUICtrlSetTip($mInput_Destination, __GetLang('MANAGE_EDIT_TIP_2', 'As destination are supported absolute, relative and UNC paths.'))
	GUICtrlSetState($mInput_Destination, $GUI_DROPACCEPTED)
	$mButton_Destination = GUICtrlCreateButton("S", 10 + 155 + 248, 120 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Destination, __GetLang('SEARCH', 'Search'))
	GUICtrlSetImage($mButton_Destination, @ScriptFullPath, -8, 0)
	$mInput_Site = GUICtrlCreateInput($mSite, 10 + 155, 120 + 32, 243, 22)
	GUICtrlSetTip($mInput_Site, __GetLang('MANAGE_EDIT_TIP_6', 'Define the remote destination directory.'))
	$mButton_Site = GUICtrlCreateButton("C", 10 + 155 + 248, 120 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Site, __GetLang('MANAGE_EDIT_MSGBOX_12', 'Configure'))
	GUICtrlSetImage($mButton_Site, @ScriptFullPath, -12, 0)
	$mInput_Rename = GUICtrlCreateInput($mRename, 10 + 155, 120 + 32, 284, 22)
	GUICtrlSetTip($mInput_Rename, __GetLang('MANAGE_EDIT_TIP_4', 'Write output name and extension.'))
	$mInput_List = GUICtrlCreateInput($mList, 10 + 155 + 40, 120 + 32, 203, 22)
	GUICtrlSetTip($mInput_List, __GetLang('MANAGE_EDIT_TIP_2', 'As destination are supported absolute, relative and UNC paths.'))
	$mButton_List = GUICtrlCreateButton("C", 10 + 155, 120 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_List, __GetLang('MANAGE_EDIT_MSGBOX_12', 'Configure'))
	GUICtrlSetImage($mButton_List, @ScriptFullPath, -12, 0)
	$mCombo_Delete = GUICtrlCreateCombo("", 10 + 155, 120 + 32, 325, 22, $WS_VSCROLL + $CBS_DROPDOWNLIST)
	GUICtrlSetTip($mCombo_Delete, __GetLang('MANAGE_EDIT_TIP_5', 'Select the deletion mode for this association.'))
	$mCombo_Clipboard = GUICtrlCreateCombo("", 10 + 155, 120 + 32, 325, 22, $WS_VSCROLL + $CBS_DROPDOWNLIST)
	GUICtrlSetTip($mCombo_Clipboard, __GetLang('MANAGE_EDIT_TIP_3', 'Select what copy to the Clipboard for this association.'))
	$mButton_Abbreviations = GUICtrlCreateButton("A", 10 + 155 + 289, 120 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Abbreviations, __GetLang('MANAGE_EDIT_MSGBOX_8', 'Abbreviations'))
	GUICtrlSetImage($mButton_Abbreviations, @ScriptFullPath, -11, 0)
	$mInput_Change = GUICtrlCreateInput(__GetLang('MANAGE_EDIT_MSGBOX_14', 'Configure the new properties'), 10 + 155 + 40, 120 + 32, 284, 22)
	$mButton_Change = GUICtrlCreateButton("C", 10 + 155, 120 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Change, __GetLang('MANAGE_EDIT_MSGBOX_12', 'Configure'))
	GUICtrlSetImage($mButton_Change, @ScriptFullPath, -12, 0)
	$mInput_Ignore = GUICtrlCreateInput(__GetLang('MANAGE_EDIT_MSGBOX_15', 'Skip them during process'), 10 + 155, 120 + 32, 325, 22)

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
		Case __GetLang('ACTION_IGNORE', 'Ignore')
			GUICtrlSetState($mInput_Ignore, $GUI_SHOW)
			GUICtrlSetState($mInput_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Abbreviations, $GUI_HIDE)
			GUICtrlSetData($mInput_Destination, "-")
			GUICtrlSetData($mLabel_Destination, "")
		Case __GetLang('ACTION_CHANGE_PROPERTIES', 'Change Properties')
			GUICtrlSetState($mInput_Change, $GUI_SHOW)
			GUICtrlSetState($mButton_Change, $GUI_SHOW)
			GUICtrlSetState($mInput_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Abbreviations, $GUI_HIDE)
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[8])
		Case __GetLang('ACTION_OPEN_WITH', 'Open With')
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[1])
		Case __GetLang('ACTION_PLAYLIST', 'Create Playlist')
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[2])
		Case __GetLang('ACTION_COMPRESS', 'Compress')
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[3])
		Case __GetLang('ACTION_LIST', 'Create List')
			GUICtrlSetState($mInput_Destination, $GUI_HIDE)
			GUICtrlSetState($mInput_List, $GUI_SHOW)
			GUICtrlSetState($mButton_List, $GUI_SHOW)
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[2])
		Case __GetLang('ACTION_RENAME', 'Rename')
			GUICtrlSetState($mInput_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Destination, $GUI_HIDE)
			GUICtrlSetState($mInput_Rename, $GUI_SHOW)
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[4])
		Case __GetLang('ACTION_UPLOAD', 'Upload')
			GUICtrlSetState($mInput_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Destination, $GUI_HIDE)
			GUICtrlSetState($mInput_Site, $GUI_SHOW)
			GUICtrlSetState($mButton_Site, $GUI_SHOW)
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[7])
		Case __GetLang('ACTION_DELETE', 'Delete')
			GUICtrlSetState($mInput_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Abbreviations, $GUI_HIDE)
			GUICtrlSetState($mCombo_Delete, $GUI_SHOW)
			$mCurrentDelete = $mDestination
			GUICtrlSetData($mInput_Destination, "-")
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[5])
		Case __GetLang('ACTION_CLIPBOARD', 'Copy to Clipboard')
			GUICtrlSetState($mInput_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Abbreviations, $GUI_HIDE)
			GUICtrlSetState($mCombo_Clipboard, $GUI_SHOW)
			$mCurrentClipboard = $mDestination
			GUICtrlSetData($mInput_Destination, "-")
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[6])
	EndSwitch
	GUICtrlSetData($mCombo_Action, $mCombo_ActionData, $mCurrentAction)
	GUICtrlSetData($mCombo_Delete, $mCombo_DeleteData, $mCurrentDelete)
	GUICtrlSetData($mCombo_Clipboard, $mCombo_ClipboardData, $mCurrentClipboard)

	$mSave = GUICtrlCreateButton(__GetLang('SAVE', 'Save'), 250 - 70 - 85, 195, 85, 26)
	$mAdd_Action = GUICtrlCreateButton("+", 250 - 18, 196, 36, 24, $BS_ICON)
	GUICtrlSetTip($mAdd_Action, __GetLang('?????', 'Add another action'))
	GUICtrlSetImage($mAdd_Action, @ScriptFullPath, -9, 0)
	GUICtrlSetState($mAdd_Action, $GUI_HIDE) ; <<<<<<<<<<< Temporarily Disabled.
	$mCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 250 + 70, 195, 85, 26)
	GUICtrlSetState($mSave, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)
	ControlClick($mGUI, "", $mInput_Name)

	While 1
		; Enable/Disable Destination Input And Switch Folder/Program Label:
		If GUICtrlRead($mCombo_Action) <> $mCurrentAction And _GUICtrlComboBox_GetDroppedState($mCombo_Action) = False Then
			GUICtrlSetState($mInput_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Abbreviations, $GUI_HIDE)
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
				Case __GetLang('ACTION_DELETE', 'Delete')
					GUICtrlSetState($mCombo_Delete, $GUI_SHOW)
				Case __GetLang('ACTION_CLIPBOARD', 'Copy to Clipboard')
					GUICtrlSetState($mCombo_Clipboard, $GUI_SHOW)
				Case __GetLang('ACTION_IGNORE', 'Ignore')
					GUICtrlSetState($mInput_Ignore, $GUI_SHOW)
				Case __GetLang('ACTION_RENAME', 'Rename')
					GUICtrlSetState($mInput_Rename, $GUI_SHOW)
					GUICtrlSetState($mButton_Abbreviations, $GUI_SHOW)
				Case __GetLang('ACTION_UPLOAD', 'Upload')
					GUICtrlSetState($mInput_Site, $GUI_SHOW)
					GUICtrlSetState($mButton_Site, $GUI_SHOW)
					GUICtrlSetState($mButton_Abbreviations, $GUI_SHOW)
				Case __GetLang('ACTION_CHANGE_PROPERTIES', 'Change Properties')
					If $mFileProperties = "-" Then
						$mFileProperties = ""
					EndIf
					GUICtrlSetState($mInput_Change, $GUI_SHOW)
					GUICtrlSetState($mButton_Change, $GUI_SHOW)
				Case __GetLang('ACTION_LIST', 'Create List')
					If GUICtrlRead($mInput_List) == "-" Then
						GUICtrlSetData($mInput_List, "")
					EndIf
					GUICtrlSetState($mButton_Destination, $GUI_SHOW)
					GUICtrlSetState($mInput_List, $GUI_SHOW)
					GUICtrlSetState($mButton_List, $GUI_SHOW)
					GUICtrlSetState($mButton_Abbreviations, $GUI_SHOW)
				Case Else
					If GUICtrlRead($mInput_Destination) == "-" Then
						GUICtrlSetData($mInput_Destination, "")
					EndIf
					GUICtrlSetState($mInput_Destination, $GUI_SHOW)
					GUICtrlSetState($mButton_Destination, $GUI_SHOW)
					GUICtrlSetState($mButton_Abbreviations, $GUI_SHOW)
			EndSwitch
			Switch $mCurrentAction
				Case __GetLang('ACTION_IGNORE', 'Ignore')
					GUICtrlSetData($mLabel_Destination, "")
				Case __GetLang('ACTION_OPEN_WITH', 'Open With')
					GUICtrlSetData($mLabel_Destination, $mDestination_Label[1])
				Case __GetLang('ACTION_LIST', 'Create List'), __GetLang('ACTION_PLAYLIST', 'Create Playlist')
					GUICtrlSetData($mLabel_Destination, $mDestination_Label[2])
				Case __GetLang('ACTION_COMPRESS', 'Compress')
					GUICtrlSetData($mLabel_Destination, $mDestination_Label[3])
				Case __GetLang('ACTION_RENAME', 'Rename')
					GUICtrlSetData($mLabel_Destination, $mDestination_Label[4])
				Case __GetLang('ACTION_DELETE', 'Delete')
					GUICtrlSetData($mLabel_Destination, $mDestination_Label[5])
				Case __GetLang('ACTION_CLIPBOARD', 'Copy to Clipboard')
					GUICtrlSetData($mLabel_Destination, $mDestination_Label[6])
				Case __GetLang('ACTION_UPLOAD', 'Upload')
					GUICtrlSetData($mLabel_Destination, $mDestination_Label[7])
				Case __GetLang('ACTION_CHANGE_PROPERTIES', 'Change Properties')
					GUICtrlSetData($mLabel_Destination, $mDestination_Label[8])
				Case Else
					GUICtrlSetData($mLabel_Destination, $mDestination_Label[0])
			EndSwitch
		EndIf

		; Enable/Disable Save Button:
		If GUICtrlRead($mInput_Name) <> "" And GUICtrlRead($mInput_Rules) <> "" And $mFileProperties <> "" And __StringIsValid(GUICtrlRead($mInput_Destination), '|') And __StringIsValid(GUICtrlRead($mInput_Rename), '|') And __StringIsValid(GUICtrlRead($mInput_List), '|') And Not StringIsSpace(GUICtrlRead($mInput_Rules)) Then
			If GUICtrlGetState($mSave) > 80 Then
				GUICtrlSetState($mSave, 576) ; $GUI_ENABLE + $GUI_DEFBUTTON.
			EndIf
			If GUICtrlGetState($mCancel) = 512 Then
				GUICtrlSetState($mCancel, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
		ElseIf GUICtrlRead($mInput_Name) = "" Or GUICtrlRead($mInput_Rules) = "" Or $mFileProperties = "" Or __StringIsValid(GUICtrlRead($mInput_Destination), '|') = 0 Or __StringIsValid(GUICtrlRead($mInput_Rename), '|') = 0 Or __StringIsValid(GUICtrlRead($mInput_List), '|') = 0 Or StringIsSpace(GUICtrlRead($mInput_Rules)) Then
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
							MsgBox(0x30, __GetLang('MANAGE_EDIT_MSGBOX_4', 'Association Error'), __GetLang('MANAGE_EDIT_MSGBOX_11', 'You cannot use this action for folders.'), 0, __OnTop($mGUI))
							ContinueLoop
						EndIf
					Case "$5" ; Open With.
						If StringInStr($mInput_DestinationRead, "DropIt.exe") Then ; DropIt.exe Is Excluded To Avoid Loops.
							MsgBox(0x30, __GetLang('MANAGE_EDIT_MSGBOX_0', 'Destination Error'), __GetLang('MANAGE_EDIT_MSGBOX_1', 'You must specify a valid destination.'), 0, __OnTop($mGUI))
							ContinueLoop
						EndIf
					Case "$8" ; List.
						$mInput_DestinationRead = GUICtrlRead($mInput_List)
						If __IsValidFileType($mInput_DestinationRead, "html;htm;txt;csv;xml") = 0 Then
							MsgBox(0x30, __GetLang('MANAGE_EDIT_MSGBOX_0', 'Destination Error'), __GetLang('MANAGE_EDIT_MSGBOX_1', 'You must specify a valid destination.'), 0, __OnTop($mGUI))
							ContinueLoop
						EndIf
					Case "$3" ; Compress.
						If __IsValidFileType($mInput_DestinationRead, "zip;7z;exe") = 0 And StringInStr($mInput_DestinationRead, ".") Then
							MsgBox(0x30, __GetLang('MANAGE_EDIT_MSGBOX_0', 'Destination Error'), __GetLang('MANAGE_EDIT_MSGBOX_1', 'You must specify a valid destination.'), 0, __OnTop($mGUI))
							ContinueLoop
						EndIf
					Case "$9" ; Playlist.
						If StringInStr($mInput_RulesRead, "**") And __Is("UseRegEx") = 0 Then
							MsgBox(0x30, __GetLang('MANAGE_EDIT_MSGBOX_4', 'Association Error'), __GetLang('MANAGE_EDIT_MSGBOX_11', 'You cannot use this action for folders.'), 0, __OnTop($mGUI))
							ContinueLoop
						EndIf
						If __IsValidFileType($mInput_DestinationRead, "m3u;m3u8;pls;wpl") = 0 Then
							MsgBox(0x30, __GetLang('MANAGE_EDIT_MSGBOX_0', 'Destination Error'), __GetLang('MANAGE_EDIT_MSGBOX_1', 'You must specify a valid destination.'), 0, __OnTop($mGUI))
							ContinueLoop
						EndIf
					Case "$C" ; Upload.
						If $mSiteSettings = "" Then
							MsgBox(0x30, __GetLang('MANAGE_EDIT_MSGBOX_0', 'Destination Error'), __GetLang('MANAGE_EDIT_MSGBOX_13', 'You must configure the site destination.'), 0, __OnTop($mGUI))
							ContinueLoop
						EndIf
						$mInput_DestinationRead = GUICtrlRead($mInput_Site)
						If $mInput_DestinationRead = "" Or StringLeft($mInput_DestinationRead, 1) <> "/" Then
							$mInput_DestinationRead = "/" & $mInput_DestinationRead ; To Use Main Remote Directory As Destination.
						EndIf
					Case "$6" ; Delete.
						$mCurrentDelete = GUICtrlRead($mCombo_Delete)
						Switch $mCurrentDelete
							Case __GetLang('DELETE_MODE_2', 'Safely Erase')
								$mInput_DestinationRead = 2
							Case __GetLang('DELETE_MODE_3', 'Send to Recycle Bin')
								$mInput_DestinationRead = 3
							Case Else ; Directly Remove.
								$mInput_DestinationRead = 1
						EndSwitch
					Case "$B" ; Clipboard.
						$mCurrentClipboard = GUICtrlRead($mCombo_Clipboard)
						Switch $mCurrentClipboard
							Case __GetLang('CLIPBOARD_MODE_2', 'File Name')
								$mInput_DestinationRead = 2
							Case __GetLang('LIST_LABEL_7', 'MD5 Hash')
								$mInput_DestinationRead = 3
							Case __GetLang('LIST_LABEL_8', 'SHA-1 Hash')
								$mInput_DestinationRead = 4
							Case __GetLang('LIST_LABEL_33', 'CRC Hash')
								$mInput_DestinationRead = 5
							Case __GetLang('LIST_LABEL_34', 'MD4 Hash')
								$mInput_DestinationRead = 6
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
					MsgBox(0x30, __GetLang('MANAGE_EDIT_MSGBOX_4', 'Association Error'), __GetLang('MANAGE_EDIT_MSGBOX_5', 'You cannot use "=" character in rules or start rules with "[" character.'), 0, __OnTop($mGUI))
				Else
					$mMsgBox = 6
					If IniRead($mProfile[0], "Associations", $mInput_RulesRead & $mCurrentActionString, "") <> "" Then
						If $mInput_RulesRead <> $mInput_RuleData Then
							$mMsgBox = MsgBox(0x4, __GetLang('MANAGE_EDIT_MSGBOX_2', 'Replace association'), __GetLang('MANAGE_EDIT_MSGBOX_3', 'This association already exists. Do you want to replace it?'), 0, __OnTop($mGUI))
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
							$mListProperties = "0;1;2;3;9;13"
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
				MsgBox(0, __GetLang('MANAGE_EDIT_MSGBOX_6', 'Supported Rules'), _
						__GetLang('MANAGE_EDIT_MSGBOX_16', 'Examples of supported rules for files:') & @LF & _
						__GetLang('MANAGE_EDIT_MSGBOX_17', '*.jpg = all files with "jpg" extension') & @LF & _
						__GetLang('MANAGE_EDIT_MSGBOX_18', 'penguin*.* = all files that begin with "penguin"') & @LF & _
						__GetLang('MANAGE_EDIT_MSGBOX_19', '*penguin* = all files that contain "penguin"') & @LF & _
						__GetLang('MANAGE_EDIT_MSGBOX_20', 'C:\Folder\*.jpg = all "jpg" files from "Folder"') & @LF & @LF & _
						__GetLang('MANAGE_EDIT_MSGBOX_21', 'Examples of supported rules for folders:') & @LF & _
						__GetLang('MANAGE_EDIT_MSGBOX_22', 'robot** = all folders that begin with "robot"') & @LF & _
						__GetLang('MANAGE_EDIT_MSGBOX_23', '**robot** = all folders that contain "robot"') & @LF & _
						__GetLang('MANAGE_EDIT_MSGBOX_24', 'C:\**\robot = all "robot" folders from a "C:" subfolder') & @LF & @LF & _
						__GetLang('MANAGE_EDIT_MSGBOX_25', 'Examples of supported rules with special characters:') & @LF & _
						__GetLang('MANAGE_EDIT_MSGBOX_26', '*.jpg;*.png = with ";" or "|" to separate rules') & @LF & _
						__GetLang('MANAGE_EDIT_MSGBOX_27', '*.jpg/sea* = with "/" to exclude files that begin with "sea"'), 0, __OnTop($mGUI))

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
				If $mCurrentAction == __GetLang('ACTION_LIST', 'Create List') Then
					$mInput_Current = $mInput_List
				EndIf
				$mFolder = GUICtrlRead($mInput_Current)
				Switch $mCurrentAction
					Case __GetLang('ACTION_OPEN_WITH', 'Open With')
						$mFolder = FileOpenDialog(__GetLang('MANAGE_DESTINATION_PROGRAM_SELECT', 'Select a destination program:'), @DesktopDir, __GetLang('MANAGE_EDIT_MSGBOX_10', 'Executable or Script') & " (*.exe;*.bat;*.cmd;*.com;*.pif)", 1, "", $mGUI)
						If @error Then
							$mFolder = ""
						EndIf
					Case __GetLang('ACTION_LIST', 'Create List')
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
								$mListName = __GetLang('MANAGE_DESTINATION_FILE_NAME', 'DropIt List')
						EndSwitch
						$mListName = _WinAPI_GetSaveFileName(__GetLang('MANAGE_DESTINATION_FILE_SELECT', 'Choose a destination file:'), "HTML - " & __GetLang('MANAGE_DESTINATION_FORMAT_0', 'HyperText Markup Language file') & " (*.html;*.htm)|TXT - " & __GetLang('MANAGE_DESTINATION_FORMAT_1', 'Normal text file') & " (*.txt)|CSV - " & __GetLang('MANAGE_DESTINATION_FORMAT_2', 'Comma-Separated Values file') & " (*.csv)|XML - " & __GetLang('MANAGE_DESTINATION_FORMAT_3', 'eXtensible Markup Language file') & " (*.xml)", @DesktopDir, $mListName, "html", $mListType, 0, 0, $mGUI)
						If $mListName[0] = 2 Then
							If _WinAPI_PathIsDirectory($mListName[1]) Then
								$mFolder = $mListName[1] & "\" & $mListName[2]
							EndIf
						EndIf
					Case __GetLang('ACTION_COMPRESS', 'Compress')
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
								$mListName = __GetLang('ARCHIVE', 'Archive')
						EndSwitch
						$mListName = _WinAPI_GetSaveFileName(__GetLang('MANAGE_DESTINATION_ARCHIVE_SELECT', 'Choose a destination archive:'), "ZIP - " & __GetLang('MANAGE_DESTINATION_FORMAT_4', 'Standard mainstream archive') & " (*.zip)|7Z - " & __GetLang('MANAGE_DESTINATION_FORMAT_5', 'High compression ratio archive') & " (*.7z)|EXE - " & __GetLang('MANAGE_DESTINATION_FORMAT_6', 'Self-extracting archive') & " (*.exe)", @DesktopDir, $mListName, "zip", $mListType, 0, 0, $mGUI)
						If $mListName[0] = 2 Then
							If _WinAPI_PathIsDirectory($mListName[1]) Then
								$mFolder = $mListName[1] & "\" & $mListName[2]
							EndIf
						EndIf
					Case __GetLang('ACTION_PLAYLIST', 'Create Playlist')
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
								$mListName = __GetLang('PLAYLIST', 'Playlist')
						EndSwitch
						$mListName = _WinAPI_GetSaveFileName(__GetLang('MANAGE_DESTINATION_FILE_SELECT', 'Choose a destination file:'), "M3U - " & __GetLang('MANAGE_DESTINATION_FORMAT_7', 'M3U playlist file') & " (*.m3u)|M3U8 - " & __GetLang('MANAGE_DESTINATION_FORMAT_8', 'Unicode M3U playlist file') & " (*.m3u8)|PLS - " & __GetLang('MANAGE_DESTINATION_FORMAT_9', 'Standard playlist file') & " (*.pls)|WPL - " & __GetLang('MANAGE_DESTINATION_FORMAT_10', 'Windows playlist file') & " (*.wpl)", @DesktopDir, $mListName, "m3u", $mListType, 0, 0, $mGUI)
						If $mListName[0] = 2 Then
							If _WinAPI_PathIsDirectory($mListName[1]) Then
								$mFolder = $mListName[1] & "\" & $mListName[2]
							EndIf
						EndIf
					Case Else
						$mFolder = FileSelectFolder(__GetLang('MANAGE_DESTINATION_FOLDER_SELECT', 'Select a destination folder:'), "", 3, $mFolder, $mGUI)
						$mFolder = _WinAPI_PathRemoveBackslash($mFolder)
				EndSwitch
				If $mFolder <> "" Then
					GUICtrlSetData($mInput_Current, $mFolder)
				EndIf

			Case $mButton_Abbreviations
				$mAbbreviation = _Manage_ContextMenu_Abbreviations($mButton_Abbreviations, $mProfile[1], $mCurrentAction, $mGUI)
				If $mAbbreviation <> -1 Then
					Switch $mCurrentAction
						Case __GetLang('ACTION_RENAME', 'Rename')
							__InsertText($mInput_Rename, "%" & $mAbbreviation & "%")
						Case __GetLang('ACTION_UPLOAD', 'Upload')
							__InsertText($mInput_Site, "%" & $mAbbreviation & "%")
						Case __GetLang('ACTION_LIST', 'Create List')
							__InsertText($mInput_List, "%" & $mAbbreviation & "%")
						Case Else
							__InsertText($mInput_Destination, "%" & $mAbbreviation & "%")
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
		$mMsgBox = MsgBox(0x4, __GetLang('MANAGE_DELETE_MSGBOX_0', 'Delete association'), __GetLang('MANAGE_DELETE_MSGBOX_1', 'Selected association:') & "  " & $mAssociation & @LF & __GetLang('MANAGE_DELETE_MSGBOX_2', 'Are you sure to delete this association?'), 0, __OnTop($mHandle))
	EndIf
	If $mMsgBox <> 6 Then
		Return SetError(1, 0, 0)
	EndIf

	$mAssociation = __GetAssociationString($mCurrentAction, $mAssociation) ; Get Association String.
	IniDelete($mProfile, "Associations", $mAssociation)
	_GUICtrlListView_DeleteItem($mListView, $mIndex)
	__Log_Write(__GetLang('MANAGE_LOG_2', 'Association Removed'), $mName)

	$Global_ListViewIndex = -1
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_Manage_Delete

Func _Manage_Paste($mProfilePath, $mProfileString, $mProfileText, $mHandle = -1)
	Local $mMsgBox = 6

	If IniRead($mProfilePath, "Associations", $mProfileString, "") <> "" Then ; Association Already Exists.
		$mMsgBox = MsgBox(0x4, __GetLang('MANAGE_EDIT_MSGBOX_2', 'Replace association'), __GetLang('MANAGE_EDIT_MSGBOX_3', 'This association already exists. Do you want to replace it?'), 0, __OnTop($mHandle))
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
					$mAssociations[$A][1] = __GetLang('DELETE_MODE_2', 'Safely Erase')
				Case 3
					$mAssociations[$A][1] = __GetLang('DELETE_MODE_3', 'Send to Recycle Bin')
				Case Else
					$mAssociations[$A][1] = __GetLang('DELETE_MODE_1', 'Directly Remove')
			EndSwitch
		ElseIf $mAction == "$B" Then
			Switch $mAssociations[$A][1] ; Destination.
				Case 2
					$mAssociations[$A][1] = __GetLang('CLIPBOARD_MODE_2', 'File Name')
				Case 3
					$mAssociations[$A][1] = __GetLang('LIST_LABEL_7', 'MD5 Hash')
				Case 4
					$mAssociations[$A][1] = __GetLang('LIST_LABEL_8', 'SHA-1 Hash')
				Case 5
					$mAssociations[$A][1] = __GetLang('LIST_LABEL_33', 'CRC Hash')
				Case 6
					$mAssociations[$A][1] = __GetLang('LIST_LABEL_34', 'MD4 Hash')
				Case Else
					$mAssociations[$A][1] = __GetLang('CLIPBOARD_MODE_1', 'Full Path')
			EndSwitch
		ElseIf $mAction == "$C" Then
			$mStringSplit = StringSplit($mAssociations[$A][6], ";")
			$mAssociations[$A][1] = $mStringSplit[1] & $mAssociations[$A][1]
		ElseIf $mAction == "$D" Then
			$mAssociations[$A][1] = __GetLang('CHANGE_PROPERTIES_DEFINED', 'Defined Properties')
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
	Local $mAssociationSplit, $mStringSplit, $mFilters[4][4], $mNumberFields = $G_Global_NumberFields

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
	Local $mCheckText[4] = [__GetLang('SIZE', 'Size'), __GetLang('DATE_CREATED', 'Date Created'), __GetLang('DATE_MODIFIED', 'Date Modified'), __GetLang('DATE_OPENED', 'Date Opened')]

	$mGUI = GUICreate(__GetLang('ADDITIONAL_FILTERS', 'Additional Filters'), 370, 180, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	For $A = 0 To 3
		$mGUI_Items[$A][0] = GUICtrlCreateCheckbox($mCheckText[$A] & ":", 10, 16 + (30 * $A), 150, 20)
		If $mFilters[$A][0] = 1 Then
			GUICtrlSetState($mGUI_Items[$A][0], $GUI_CHECKED)
		EndIf

		$mGUI_Items[$A][1] = GUICtrlCreateCombo("", 10 + 150, 15 + (30 * $A), 30, 22, $WS_VSCROLL + $CBS_DROPDOWNLIST)
		If $mFilters[$A][1] = "" Then
			$mFilters[$A][1] = ">"
		EndIf
		GUICtrlSetData($mGUI_Items[$A][1], ">|=|<", $mFilters[$A][1])

		$mGUI_Items[$A][2] = GUICtrlCreateInput($mFilters[$A][2], 10 + 150 + 35, 15 + (30 * $A), 60, 22, 0x2000)

		$mGUI_Items[$A][3] = GUICtrlCreateCombo("", 10 + 150 + 35 + 65, 15 + (30 * $A), 100, 22, $WS_VSCROLL + $CBS_DROPDOWNLIST)
		If $A = 0 Then
			If $mFilters[$A][3] = "" Then
				$mFilters[$A][3] = "KB"
			EndIf
			GUICtrlSetData($mGUI_Items[$A][3], "bytes|KB|MB|GB", $mFilters[$A][3])
		Else
			Switch $mFilters[$A][3]
				Case "s"
					$mText = __GetLang('TIME_SECONDS', 'Seconds')
				Case "n"
					$mText = __GetLang('TIME_MINUTES', 'Minutes')
				Case "h"
					$mText = __GetLang('TIME_HOURS', 'Hours')
				Case "m"
					$mText = __GetLang('TIME_MONTHS', 'Months')
				Case "y"
					$mText = __GetLang('TIME_YEARS', 'Years')
				Case Else
					$mText = __GetLang('TIME_DAYS', 'Days')
			EndSwitch
			GUICtrlSetData($mGUI_Items[$A][3], __GetLang('TIME_SECONDS', 'Seconds') & "|" & __GetLang('TIME_MINUTES', 'Minutes') & "|" & __GetLang('TIME_HOURS', 'Hours') & "|" & __GetLang('TIME_DAYS', 'Days') & "|" & __GetLang('TIME_MONTHS', 'Months') & "|" & __GetLang('TIME_YEARS', 'Years'), $mText)
		EndIf

		$mState = $GUI_DISABLE
		If GUICtrlRead($mGUI_Items[$A][0]) = 1 Then
			$mState = $GUI_ENABLE
		EndIf
		For $B = 1 To 3
			GUICtrlSetState($mGUI_Items[$A][$B], $mState)
		Next
	Next

	$mSave = GUICtrlCreateButton(__GetLang('OK', 'OK'), 185 - 40 - 85, 145, 85, 24)
	$mCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 185 + 40, 145, 85, 24)
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
							Case __GetLang('TIME_SECONDS', 'Seconds')
								$mState = "s"
							Case __GetLang('TIME_MINUTES', 'Minutes')
								$mState = "n"
							Case __GetLang('TIME_HOURS', 'Hours')
								$mState = "h"
							Case __GetLang('TIME_MONTHS', 'Months')
								$mState = "m"
							Case __GetLang('TIME_YEARS', 'Years')
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
	Local $mGUI, $mAdd, $mRemove, $mUp, $mDown, $mSave, $mCancel
	Local $mList_Available, $mList_Listed, $mIndex, $mString, $mStringSplit, $mNewProperties
	Local $mNumberProperties = $G_List_NumberProperties

	$mGUI = GUICreate(__GetLang('LIST_SELECT_0', 'Select Properties'), 370, 240, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))
	GUICtrlCreateLabel(__GetLang('LIST_SELECT_1', 'Available Properties') & ":", 15, 10, 140, 20)
	GUICtrlCreateLabel(__GetLang('LIST_SELECT_2', 'Used Properties') & ":", 15 + 205, 10, 140, 20)
	$mList_Available = GUICtrlCreateList("", 10, 30, 150, 170, 0x00210000) ; $LBS_NOTIFY + $WS_VSCROLL.
	$mList_Listed = GUICtrlCreateList("", 10 + 200, 30, 150, 170, 0x00210000) ; $LBS_NOTIFY + $WS_VSCROLL.

	If $mProperties = "" Then
		$mStringSplit = StringSplit("0;1;2;3;9;13", ";")
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
	GUICtrlSetTip($mAdd, __GetLang('OPTIONS_BUTTON_4', 'Add'))
	GUICtrlSetImage($mAdd, @ScriptFullPath, -13, 0)
	$mRemove = GUICtrlCreateButton("-", 185 - 13, 40 + 36, 26, 26, $BS_ICON)
	GUICtrlSetTip($mRemove, __GetLang('OPTIONS_BUTTON_3', 'Remove'))
	GUICtrlSetImage($mRemove, @ScriptFullPath, -14, 0)
	$mUp = GUICtrlCreateButton("U", 185 - 13, 40 + 36 * 2, 26, 26, $BS_ICON)
	GUICtrlSetTip($mUp, __GetLang('OPTIONS_BUTTON_6', 'Up'))
	GUICtrlSetImage($mUp, @ScriptFullPath, -15, 0)
	$mDown = GUICtrlCreateButton("D", 185 - 13, 40 + 36 * 3, 26, 26, $BS_ICON)
	GUICtrlSetTip($mDown, __GetLang('OPTIONS_BUTTON_7', 'Down'))
	GUICtrlSetImage($mDown, @ScriptFullPath, -16, 0)

	$mSave = GUICtrlCreateButton(__GetLang('OK', 'OK'), 185 - 40 - 85, 205, 85, 24)
	$mCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 185 + 40, 205, 85, 24)
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
	Local $mTitles[8] = [__GetLang('ENV_VAR_TAB_6', 'Created'), __GetLang('ENV_VAR_TAB_7', 'Modified'), __GetLang('ENV_VAR_TAB_8', 'Opened'), __GetLang('CHANGE_PROPERTIES_ATTRIBUTE_0', 'Archive'), __GetLang('CHANGE_PROPERTIES_ATTRIBUTE_1', 'Hidden'), __GetLang('CHANGE_PROPERTIES_ATTRIBUTE_2', 'Read-Only'), __GetLang('CHANGE_PROPERTIES_ATTRIBUTE_3', 'System'), __GetLang('CHANGE_PROPERTIES_ATTRIBUTE_4', 'Temporary')]
	Local $mCombo[4] = [__GetLang('CHANGE_PROPERTIES_MODE_0', 'No Change'), __GetLang('CHANGE_PROPERTIES_MODE_1', 'Turn On'), __GetLang('CHANGE_PROPERTIES_MODE_2', 'Turn Off'), __GetLang('CHANGE_PROPERTIES_MODE_3', 'Switch')]

	$mStringSplit = StringSplit($mProperties, ";") ; {modified} YYYYMMDD;HHMMSS;0d; {created} YYYYMMDD;HHMMSS;0d; {opened} YYYYMMDD;HHMMSS;0d; {attributes} A0;H0;R0;S0;T0
	ReDim $mStringSplit[15] ; Number Of Settings.

	$mGUI = GUICreate(__GetLang('CHANGE_PROPERTIES', 'Configure Properties'), 600, 280, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	GUICtrlCreateGroup(__GetLang('CHANGE_PROPERTIES_LABEL_0', 'Date and Time'), 10, 10, 580, 110)
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
		$mDates[$A][5] = GUICtrlCreateCombo("", 110 + 255 + 20, 27 + (30 * $A), 30, 22, $WS_VSCROLL + $CBS_DROPDOWNLIST)
		$mText = "+"
		If StringInStr($mStringSplit[$B + 2], "-") Then
			$mText = "-"
		EndIf
		GUICtrlSetData($mDates[$A][5], "+|-", $mText)
		$mText = StringRegExpReplace($mStringSplit[$B + 2], "[^0-9]", "")
		$mDates[$A][6] = GUICtrlCreateInput($mText, 110 + 255 + 55, 27 + (30 * $A), 55, 22, 0x2000)
		$mDates[$A][7] = GUICtrlCreateCombo("", 110 + 255 + 115, 27 + (30 * $A), 100, 22, $WS_VSCROLL + $CBS_DROPDOWNLIST)
		Switch StringRight($mStringSplit[$B + 2], 1)
			Case "s"
				$mText = __GetLang('TIME_SECONDS', 'Seconds')
			Case "n"
				$mText = __GetLang('TIME_MINUTES', 'Minutes')
			Case "h"
				$mText = __GetLang('TIME_HOURS', 'Hours')
			Case "m"
				$mText = __GetLang('TIME_MONTHS', 'Months')
			Case "y"
				$mText = __GetLang('TIME_YEARS', 'Years')
			Case Else
				$mText = __GetLang('TIME_DAYS', 'Days')
		EndSwitch
		GUICtrlSetData($mDates[$A][7], __GetLang('TIME_SECONDS', 'Seconds') & "|" & __GetLang('TIME_MINUTES', 'Minutes') & "|" & __GetLang('TIME_HOURS', 'Hours') & "|" & __GetLang('TIME_DAYS', 'Days') & "|" & __GetLang('TIME_MONTHS', 'Months') & "|" & __GetLang('TIME_YEARS', 'Years'), $mText)
		If GUICtrlRead($mDates[$A][6]) <> "" Then
			GUICtrlSetState($mDates[$A][4], $GUI_CHECKED)
		Else
			GUICtrlSetState($mDates[$A][5], $GUI_DISABLE)
			GUICtrlSetState($mDates[$A][6], $GUI_DISABLE)
			GUICtrlSetState($mDates[$A][7], $GUI_DISABLE)
		EndIf
	Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__GetLang('CHANGE_PROPERTIES_LABEL_1', 'Attributes'), 10, 125, 580, 110)
	GUICtrlCreateLabel($mTitles[3] & ":", 19, 145, 90, 20)
	$mAttributes[0][0] = GUICtrlCreateCombo("", 110, 142, 130, 22, $WS_VSCROLL + $CBS_DROPDOWNLIST)
	$mAttributes[0][1] = "A"
	GUICtrlCreateLabel($mTitles[4] & ":", 19 + 300, 145, 90, 20)
	$mAttributes[1][0] = GUICtrlCreateCombo("", 110 + 300, 142, 130, 22, $WS_VSCROLL + $CBS_DROPDOWNLIST)
	$mAttributes[1][1] = "H"
	GUICtrlCreateLabel($mTitles[5] & ":", 19, 145 + 30, 90, 20)
	$mAttributes[2][0] = GUICtrlCreateCombo("", 110, 142 + 30, 130, 22, $WS_VSCROLL + $CBS_DROPDOWNLIST)
	$mAttributes[2][1] = "R"
	GUICtrlCreateLabel($mTitles[6] & ":", 19 + 300, 145 + 30, 90, 20)
	$mAttributes[3][0] = GUICtrlCreateCombo("", 110 + 300, 142 + 30, 130, 22, $WS_VSCROLL + $CBS_DROPDOWNLIST)
	$mAttributes[3][1] = "S"
	GUICtrlCreateLabel($mTitles[7] & ":", 19, 145 + 60, 90, 20)
	$mAttributes[4][0] = GUICtrlCreateCombo("", 110, 142 + 60, 130, 22, $WS_VSCROLL + $CBS_DROPDOWNLIST)
	$mAttributes[4][1] = "T"
	For $A = 0 To 4
		Switch Number(StringRight($mStringSplit[$A + 10], 1))
			Case 1
				$mText = __GetLang('CHANGE_PROPERTIES_MODE_1', 'Turn On')
			Case 2
				$mText = __GetLang('CHANGE_PROPERTIES_MODE_2', 'Turn Off')
			Case 3
				$mText = __GetLang('CHANGE_PROPERTIES_MODE_3', 'Switch')
			Case Else
				$mText = __GetLang('CHANGE_PROPERTIES_MODE_0', 'No Change')
		EndSwitch
		GUICtrlSetData($mAttributes[$A][0], $mCombo[0] & "|" & $mCombo[1] & "|" & $mCombo[2] & "|" & $mCombo[3], $mText)
	Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$mSave = GUICtrlCreateButton(__GetLang('OK', 'OK'), 300 - 70 - 85, 245, 85, 24)
	$mCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 300 + 70, 245, 85, 24)
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
							Case __GetLang('TIME_SECONDS', 'Seconds')
								$mState = "s"
							Case __GetLang('TIME_MINUTES', 'Minutes')
								$mState = "n"
							Case __GetLang('TIME_HOURS', 'Hours')
								$mState = "h"
							Case __GetLang('TIME_MONTHS', 'Months')
								$mState = "m"
							Case __GetLang('TIME_YEARS', 'Years')
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
						Case __GetLang('CHANGE_PROPERTIES_MODE_1', 'Turn On')
							$mText = 1
						Case __GetLang('CHANGE_PROPERTIES_MODE_2', 'Turn Off')
							$mText = 2
						Case __GetLang('CHANGE_PROPERTIES_MODE_3', 'Switch')
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
	Local $mGUI, $mSave, $mCancel, $mStringSplit, $mPassword, $mPassword_Code = $G_Global_PasswordKey
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

	$mGUI = GUICreate(__GetLang('SITE_CONFIGURE', 'Configure Site'), 360, 205, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	GUICtrlCreateLabel(__GetLang('SITE_LABEL_0', 'Host') & ":", 15, 12, 200, 20)
	$mInput_Host = GUICtrlCreateInput($mStringSplit[1], 10, 30, 250, 22)
	GUICtrlCreateLabel(__GetLang('SITE_LABEL_1', 'Port') & ":", 15 + 260, 12, 80, 20)
	$mInput_Port = GUICtrlCreateInput($mStringSplit[2], 10 + 260, 30, 80, 22, 0x2000)
	GUICtrlSetTip($mInput_Port, __GetLang('SITE_TIP_0', 'Leave empty to use the default port.'))
	GUICtrlCreateLabel(__GetLang('SITE_LABEL_2', 'User') & ":", 15, 12 + 50, 200, 20)
	$mInput_User = GUICtrlCreateInput($mStringSplit[3], 10, 30 + 50, 165, 22)
	GUICtrlSetTip($mInput_User, __GetLang('SITE_TIP_1', 'Leave empty to connect as anonymous.'))
	GUICtrlCreateLabel(__GetLang('SITE_LABEL_3', 'Password') & ":", 15 + 175, 12 + 50, 200, 20)
	$mInput_Password = GUICtrlCreateInput($mStringSplit[4], 10 + 175, 30 + 50, 165, 22, 0x0020)
	GUICtrlSetTip($mInput_Password, __GetLang('SITE_TIP_2', 'Leave empty if not required.'))
	GUICtrlCreateLabel(__GetLang('SITE_LABEL_4', 'Protocol') & ":", 15, 12 + 100, 200, 20)
	$mCombo_Protocol = GUICtrlCreateCombo("", 10, 30 + 100, 340, 22, $WS_VSCROLL + $CBS_DROPDOWNLIST)
	GUICtrlSetData($mCombo_Protocol, $mString_FTP & "|" & $mString_SFTP, $mCurrentProtocol)

	$mSave = GUICtrlCreateButton(__GetLang('OK', 'OK'), 180 - 40 - 85, 170, 85, 24)
	$mCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 180 + 40, 170, 85, 24)
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

Func _Manage_AddCustomAbbreviation($mMenuItem, $mCustomItem, $mNoCustom, $mINI, $mHandle = -1)
	Local $mGUI, $mAdd, $mCancel, $mMsgBox, $mInput_Abbreviation, $mAbbreviation, $mInput_Text, $mText

	$mGUI = GUICreate(__GetLang('ENV_VAR_MSGBOX_0', 'Add Abbreviation'), 360, 105, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	GUICtrlCreateLabel(__GetLang('ENV_VAR_MSGBOX_2', 'Variable') & ":", 15, 12, 110, 20)
	$mInput_Abbreviation = GUICtrlCreateInput("", 10, 31, 120, 22)
	GUICtrlCreateLabel(__GetLang('ENV_VAR_MSGBOX_3', 'String to abbreviate') & ":", 15 + 130, 12, 200, 20)
	$mInput_Text = GUICtrlCreateInput("", 10 + 130, 31, 210, 22)

	$mAdd = GUICtrlCreateButton(__GetLang('OPTIONS_BUTTON_4', 'Add'), 180 - 30 - 85, 70, 80, 24)
	$mCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 180 + 30, 70, 80, 24)
	GUICtrlSetState($mCancel, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $mCancel
				ExitLoop

			Case $mAdd
				$mAbbreviation = GUICtrlRead($mInput_Abbreviation)
				$mText = GUICtrlRead($mInput_Text)
				If StringIsSpace($mAbbreviation) <> 0 Or $mAbbreviation = "" Or $mText = "" Then
					ContinueLoop
				EndIf
				If StringInStr($mAbbreviation, "#") <> 0 Then
					MsgBox(0x30, __GetLang('ENV_VAR_MSGBOX_4', 'Abbreviation Error'), __GetLang('ENV_VAR_MSGBOX_8', 'The # is a special character for modifiers and cannot be used for the abbreviation variable.'), 0, __OnTop($mGUI))
					ContinueLoop
				EndIf
				For $A = 1 To $mMenuItem[0][0]
					If $mAbbreviation = $mMenuItem[$A][1] Then
						MsgBox(0x30, __GetLang('ENV_VAR_MSGBOX_4', 'Abbreviation Error'), __GetLang('ENV_VAR_MSGBOX_5', 'This variable already exists and cannot be replaced.'), 0, __OnTop($mGUI))
					EndIf
				Next
				If $mNoCustom <> 1 Then
					For $A = 1 To $mCustomItem[0][0]
						If $mAbbreviation = $mCustomItem[$A][0] Then
							$mMsgBox = MsgBox(0x4, __GetLang('ENV_VAR_MSGBOX_6', 'Replace Abbreviation'), __GetLang('ENV_VAR_MSGBOX_7', 'This variable already exists. Do you want to replace it?'), 0, __OnTop($mGUI))
							If $mMsgBox <> 6 Then
								ContinueLoop 2
							EndIf
						EndIf
					Next
				EndIf
				__IniWriteEx($mINI, "EnvironmentVariables", $mAbbreviation, $mText)
				EnvSet($mAbbreviation, $mText)
				ExitLoop

		EndSwitch
	WEnd
	GUIDelete($mGUI)

	Return 1
EndFunc   ;==>_Manage_AddCustomAbbreviation

Func _Manage_RemoveCustomAbbreviation($mCustomItem, $mINI, $mHandle = -1)
	Local $mGUI, $mRemove, $mClose, $mAbbreviation, $mCombo_Abbreviations, $mString_Abbreviations

	$mGUI = GUICreate(__GetLang('ENV_VAR_MSGBOX_1', 'Remove Abbreviation'), 300, 85, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	For $A = 1 To $mCustomItem[0][0]
		$mString_Abbreviations &= $mCustomItem[$A][0] & "|"
	Next
	$mCombo_Abbreviations = GUICtrlCreateCombo("", 10, 15, 280, 22, $WS_VSCROLL + $CBS_DROPDOWNLIST)
	GUICtrlSetData($mCombo_Abbreviations, StringTrimRight($mString_Abbreviations, 1), $mCustomItem[1][0])

	$mRemove = GUICtrlCreateButton(__GetLang('OPTIONS_BUTTON_3', 'Remove'), 150 - 25 - 85, 50, 80, 24)
	$mClose = GUICtrlCreateButton(__GetLang('CLOSE', 'Close'), 150 + 25, 50, 80, 24)
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
EndFunc   ;==>_Manage_RemoveCustomAbbreviation

Func _Manage_ContextMenu_Abbreviations($mButton_Abbreviations, $mProfile, $mCurrentAction, $mHandle = -1)
	Local $mEnvMenu, $mCustomMenu, $mCustomID[1], $mNoCustom, $mMsg, $mPos, $mSkipSome, $mValue = -1
	Local $mINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $mCustomItem = __IniReadSection($mINI, "EnvironmentVariables")
	If @error Or $mCustomItem[0][0] = 0 Then
		$mNoCustom = 1
	EndIf
	Local $mGroupPaths[8][3] = [ _
			[7, 0, 0], _
			["File", __GetLang('ENV_VAR_7', 'file full path') & ' ["C:\Docs\Text.txt"]'], _ ; Only By Open With.
			["FileExt", __GetLang('ENV_VAR_9', 'file extension') & ' ["txt"]'], _
			["FileName", __GetLang('ENV_VAR_10', 'file name without extension') & ' ["Text"]'], _
			["FileNameExt", __GetLang('ENV_VAR_11', 'file name with extension') & ' ["Text.txt"]'], _
			["ParentDir", __GetLang('ENV_VAR_13', 'directory of each loaded item') & ' ["C:\Docs"]'], _
			["ParentDirName", __GetLang('ENV_VAR_29', 'directory name of each loaded item') & ' ["Docs"]'], _
			["SubDir", __GetLang('ENV_VAR_21', 'recreate subdirectory structure') & ' ["\SubFolder"]']]
	Local $mGroupInfo[7][3] = [ _
			[6, 0, 0], _
			["Attributes", __GetLang('ENV_VAR_74', 'file attributes') & ' ["RA"]'], _
			["Authors", __GetLang('ENV_VAR_8', 'file authors') & ' ["Lupo Team"]'], _
			["Comments", __GetLang('ENV_VAR_75', 'file comments') & ' ["Comment example"]'], _
			["Copyright", __GetLang('ENV_VAR_76', 'file copyright') & ' ["Lupo PenSuite"]'], _
			["FileType", __GetLang('ENV_VAR_12', 'file type') & ' ["Text document"]'], _
			["Owner", __GetLang('ENV_VAR_77', 'file owner') & ' ["Lupo"]']]
	Local $mGroupMusic[7][3] = [ _
			[6, 0, 0], _
			["SongAlbum", __GetLang('ENV_VAR_15', 'song album') & ' ["The Wall"]'], _
			["SongArtist", __GetLang('ENV_VAR_16', 'song artist') & ' ["Pink Floyd"]'], _
			["SongGenre", __GetLang('ENV_VAR_17', 'song genre') & ' ["Rock"]'], _
			["SongNumber", __GetLang('ENV_VAR_18', 'song track number') & ' ["3"]'], _
			["SongTitle", __GetLang('ENV_VAR_19', 'song title') & ' ["Hey You"]'], _
			["SongYear", __GetLang('ENV_VAR_20', 'song year') & ' ["1979"]']]
	Local $mGroupMedia[6][3] = [ _
			[5, 0, 0], _
			["BitRate", __GetLang('ENV_VAR_68', 'audio bit rate') & ' ["192kbps"]'], _
			["CameraModel", __GetLang('ENV_VAR_63', 'image camera model') & ' ["u700"]'], _
			["Dimensions", __GetLang('ENV_VAR_64', 'image dimensions') & ' ["3072 x 2304"]'], _
			["Duration", __GetLang('ENV_VAR_69', 'file duration') & ' ["01.34.26"]'], _
			["Megapixels", __GetLang('ENV_VAR_67', 'image megapixels') & ' ["7"]']]
	Local $mGroupHash[5][3] = [ _
			[4, 0, 0], _
			["CRC", __GetLang('ENV_VAR_70', 'CRC Hash') & ' ["5E2860D3"]'], _
			["MD4", __GetLang('ENV_VAR_71', 'MD4 Hash') & ' ["CE8C45F356F121F88551150BC9C7DC54"]'], _
			["MD5", __GetLang('ENV_VAR_72', 'MD5 Hash') & ' ["1377F191017E95C55B45E6C42D48D1C0"]'], _
			["SHA1", __GetLang('ENV_VAR_73', 'SHA-1 Hash') & ' ["20A1E2D9D36CB8651A16879E0A354B9BE163E1CB"]']]
	Local $mGroupCurrent[9][3] = [ _
			[8, 0, 0], _
			["CurrentDate", __GetLang('ENV_VAR_0', 'current date') & ' ["' & @YEAR & "-" & @MON & "-" & @MDAY & '"]'], _
			["CurrentYear", __GetLang('ENV_VAR_30', 'current year') & ' ["' & @YEAR & '"]'], _
			["CurrentMonth", __GetLang('ENV_VAR_31', 'current month') & ' ["' & @MON & '"]'], _
			["CurrentDay", __GetLang('ENV_VAR_32', 'current day') & ' ["' & @MDAY & '"]'], _
			["CurrentTime", __GetLang('ENV_VAR_1', 'current time') & ' ["' & @HOUR & "." & @MIN & '"]'], _
			["CurrentHour", __GetLang('ENV_VAR_33', 'current hour') & ' ["' & @HOUR & '"]'], _
			["CurrentMinute", __GetLang('ENV_VAR_34', 'current minute') & ' ["' & @MIN & '"]'], _
			["CurrentSecond", __GetLang('ENV_VAR_35', 'current second') & ' ["' & @SEC & '"]']]
	Local $mGroupCreated[9][3] = [ _
			[8, 0, 0], _
			["DateCreated", __GetLang('ENV_VAR_2', 'date file creation') & ' ["2011-05-16"]'], _
			["YearCreated", __GetLang('ENV_VAR_36', 'year file creation') & ' ["2011"]'], _
			["MonthCreated", __GetLang('ENV_VAR_37', 'month file creation') & ' ["05"]'], _
			["DayCreated", __GetLang('ENV_VAR_38', 'day file creation') & ' ["16"]'], _
			["TimeCreated", __GetLang('ENV_VAR_39', 'time file creation') & ' ["19.40"]'], _
			["HourCreated", __GetLang('ENV_VAR_40', 'hour file creation') & ' ["19"]'], _
			["MinuteCreated", __GetLang('ENV_VAR_41', 'minute file creation') & ' ["40"]'], _
			["SecondCreated", __GetLang('ENV_VAR_42', 'second file creation') & ' ["37"]']]
	Local $mGroupModified[9][3] = [ _
			[8, 0, 0], _
			["DateModified", __GetLang('ENV_VAR_3', 'date file modification') & ' ["2011-05-16"]'], _
			["YearModified", __GetLang('ENV_VAR_43', 'year file modification') & ' ["2011"]'], _
			["MonthModified", __GetLang('ENV_VAR_44', 'month file modification') & ' ["05"]'], _
			["DayModified", __GetLang('ENV_VAR_45', 'day file modification') & ' ["16"]'], _
			["TimeModified", __GetLang('ENV_VAR_46', 'time file modification') & ' ["19.40"]'], _
			["HourModified", __GetLang('ENV_VAR_47', 'hour file modification') & ' ["19"]'], _
			["MinuteModified", __GetLang('ENV_VAR_48', 'minute file modification') & ' ["40"]'], _
			["SecondModified", __GetLang('ENV_VAR_49', 'second file modification') & ' ["37"]']]
	Local $mGroupOpened[9][3] = [ _
			[8, 0, 0], _
			["DateOpened", __GetLang('ENV_VAR_4', 'date file last access') & ' ["2011-05-16"]'], _
			["YearOpened", __GetLang('ENV_VAR_50', 'year file last access') & ' ["2011"]'], _
			["MonthOpened", __GetLang('ENV_VAR_51', 'month file last access') & ' ["05"]'], _
			["DayOpened", __GetLang('ENV_VAR_52', 'day file last access') & ' ["16"]'], _
			["TimeOpened", __GetLang('ENV_VAR_53', 'time file last access') & ' ["19.40"]'], _
			["HourOpened", __GetLang('ENV_VAR_54', 'hour file last access') & ' ["19"]'], _
			["MinuteOpened", __GetLang('ENV_VAR_55', 'minute file last access') & ' ["40"]'], _
			["SecondOpened", __GetLang('ENV_VAR_56', 'second file last access') & ' ["37"]']]
	Local $mGroupTaken[9][3] = [ _
			[8, 0, 0], _
			["DateTaken", __GetLang('ENV_VAR_5', 'date picture taken') & ' ["2011-05-16"]'], _
			["YearTaken", __GetLang('ENV_VAR_57', 'year picture taken') & ' ["2011"]'], _
			["MonthTaken", __GetLang('ENV_VAR_58', 'month picture taken') & ' ["05"]'], _
			["DayTaken", __GetLang('ENV_VAR_59', 'day picture taken') & ' ["16"]'], _
			["TimeTaken", __GetLang('ENV_VAR_60', 'time picture taken') & ' ["19.40"]'], _
			["HourTaken", __GetLang('ENV_VAR_61', 'hour picture taken') & ' ["19"]'], _
			["MinuteTaken", __GetLang('ENV_VAR_62', 'minute picture taken') & ' ["40"]'], _
			["SecondTaken", __GetLang('ENV_VAR_81', 'second picture taken') & ' ["37"]']]
	Local $mGroupFolders[10][3] = [ _
			[9, 0, 0], _
			["AppData", __GetLang('ENV_VAR_65', 'path to Application Data') & ' ["' & @AppDataDir & '"]'], _
			["AppDataPublic", __GetLang('ENV_VAR_66', 'path to Public Application Data') & ' ["' & @AppDataCommonDir & '"]'], _
			["Desktop", __GetLang('ENV_VAR_22', 'path to Desktop') & ' ["' & @DesktopDir & '"]'], _
			["DesktopPublic", __GetLang('ENV_VAR_25', 'path to Public Desktop') & ' ["' & @DesktopCommonDir & '"]'], _
			["Documents", __GetLang('ENV_VAR_23', 'path to Documents') & ' ["' & @MyDocumentsDir & '"]'], _
			["DocumentsPublic", __GetLang('ENV_VAR_26', 'path to Public Documents') & ' ["' & @DocumentsCommonDir & '"]'], _
			["Favorites", __GetLang('ENV_VAR_24', 'path to Favorites') & ' ["' & @FavoritesDir & '"]'], _
			["FavoritesPublic", __GetLang('ENV_VAR_27', 'path to Public Favorites') & ' ["' & @FavoritesCommonDir & '"]'], _
			["ProgramFiles", __GetLang('ENV_VAR_80', 'path to Program Files') & ' ["' & @ProgramFilesDir & '"]']]
	Local $mGroupSystem[6][3] = [ _
			[5, 0, 0], _
			["ComputerName", __GetLang('ENV_VAR_78', 'computer name') & ' ["' & @ComputerName & '"]'], _
			["DefaultProgram", __GetLang('ENV_VAR_6', 'system default program') & ' [Notepad]'], _ ; Only By Open With.
			["PortableDrive", __GetLang('ENV_VAR_14', 'drive letter of DropIt') & ' ["' & StringLeft(@AutoItExe, 2) & '"]'], _
			["ProfileName", __GetLang('ENV_VAR_28', 'current DropIt profile name') & ' ["' & $mProfile & '"]'], _
			["UserName", __GetLang('ENV_VAR_79', 'user name') & ' ["' & @UserName & '"]']]
	Local $mMenuGroup[15][3] = [ _
			[14, 0, 0], _
			[__GetLang('ENV_VAR_TAB_4', 'Paths'), $mGroupPaths], _
			[__GetLang('ENV_VAR_TAB_3', 'Info'), $mGroupInfo], _
			[__GetLang('ENV_VAR_TAB_2', 'Music'), $mGroupMusic], _
			[__GetLang('ENV_VAR_TAB_12', 'Media'), $mGroupMedia], _
			[__GetLang('ENV_VAR_TAB_13', 'Hash'), $mGroupHash], _
			[""], _ ; Separator.
			[__GetLang('ENV_VAR_TAB_5', 'Current'), $mGroupCurrent], _
			[__GetLang('ENV_VAR_TAB_6', 'Created'), $mGroupCreated], _
			[__GetLang('ENV_VAR_TAB_7', 'Modified'), $mGroupModified], _
			[__GetLang('ENV_VAR_TAB_8', 'Opened'), $mGroupOpened], _
			[__GetLang('ENV_VAR_TAB_9', 'Taken'), $mGroupTaken], _
			[""], _ ; Separator.
			[__GetLang('ENV_VAR_TAB_14', 'Folders'), $mGroupFolders], _
			[__GetLang('ENV_VAR_TAB_10', 'System'), $mGroupSystem]]

	Local $mNumberAbbreviations = $mGroupCurrent[0][0] + $mGroupCreated[0][0] + $mGroupModified[0][0] + $mGroupOpened[0][0] + $mGroupTaken[0][0] + _
			$mGroupPaths[0][0] + $mGroupFolders[0][0] + $mGroupSystem[0][0] + $mGroupMusic[0][0] + $mGroupMedia[0][0] + $mGroupHash[0][0] + $mGroupInfo[0][0]
	Local $mIndex, $mCurrentArray, $mMenuItem[$mNumberAbbreviations + 1][4] = [[$mNumberAbbreviations, 0, 0, 0]]
	For $A = 1 To $mMenuGroup[0][0] ; Create The Unique Array.
		If $mMenuGroup[$A][0] <> "" Then ; To Skip Separators.
			$mCurrentArray = $mMenuGroup[$A][1]
			For $B = 1 To $mCurrentArray[0][0]
				$mIndex += 1
				$mMenuItem[$mIndex][0] = $A ; Group Number.
				$mMenuItem[$mIndex][1] = $mCurrentArray[$B][0] ; Abbreviation String.
				$mMenuItem[$mIndex][2] = $mCurrentArray[$B][1] ; Abbreviation Description.
			Next
		EndIf
	Next

	If IsHWnd($mButton_Abbreviations) = 0 Then
		$mButton_Abbreviations = GUICtrlGetHandle($mButton_Abbreviations)
	EndIf

	If $mCurrentAction <> __GetLang('ACTION_OPEN_WITH', 'Open With') Then
		$mSkipSome = 1 ; To Hide Abbreviations If Not Supported By Current Action.
	EndIf

	$mEnvMenu = _GUICtrlMenu_CreatePopup()
	_GUICtrlMenu_SetMenuStyle($mEnvMenu, $MNS_NOCHECK)
	For $A = 1 To $mMenuGroup[0][0]
		If $mMenuGroup[$A][0] = "" Then ; Separator.
			_GUICtrlMenu_AddMenuItem($mEnvMenu, "")
		Else
			$mMenuGroup[$A][2] = _GUICtrlMenu_CreatePopup()
			_GUICtrlMenu_SetMenuStyle($mMenuGroup[$A][2], $MNS_NOCHECK)
			_GUICtrlMenu_AddMenuItem($mEnvMenu, $mMenuGroup[$A][0], 0, $mMenuGroup[$A][2])
		EndIf
	Next
	For $A = 1 To $mMenuItem[0][0]
		$mMenuItem[$A][3] = 1000 + $A
		If $mMenuItem[$A][1] = "" Then ; Separator.
			_GUICtrlMenu_AddMenuItem($mMenuGroup[$mMenuItem[$A][0]][2], "")
		Else
			_GUICtrlMenu_AddMenuItem($mMenuGroup[$mMenuItem[$A][0]][2], "%" & $mMenuItem[$A][1] & "% = " & $mMenuItem[$A][2], $mMenuItem[$A][3])
			If $mSkipSome And ($mMenuItem[$A][1] = "File" Or $mMenuItem[$A][1] = "DefaultProgram") Then
				_GUICtrlMenu_SetItemDisabled($mMenuGroup[$mMenuItem[$A][0]][2], $mMenuItem[$A][3], True, False) ; To Hide Abbreviations If Not Supported By Current Action.
			EndIf
		EndIf
	Next

	_GUICtrlMenu_AddMenuItem($mEnvMenu, "")
	$mCustomMenu = _GUICtrlMenu_CreatePopup()
	_GUICtrlMenu_SetMenuStyle($mCustomMenu, $MNS_NOCHECK)
	_GUICtrlMenu_AddMenuItem($mEnvMenu, __GetLang('ENV_VAR_TAB_11', 'Custom'), 0, $mCustomMenu)
	_GUICtrlMenu_AddMenuItem($mCustomMenu, __GetLang('ENV_VAR_MSGBOX_0', 'Add Abbreviation'), 1999)
	If $mNoCustom <> 1 Then
		_GUICtrlMenu_AddMenuItem($mCustomMenu, __GetLang('ENV_VAR_MSGBOX_1', 'Remove Abbreviation'), 2000)
		_GUICtrlMenu_AddMenuItem($mCustomMenu, "")
		$mCustomID[0] = $mCustomItem[0][0]
		ReDim $mCustomID[$mCustomID[0] + 1]
		For $A = 1 To $mCustomItem[0][0]
			$mCustomID[$A] = 2000 + $A
			_GUICtrlMenu_AddMenuItem($mCustomMenu, "%" & $mCustomItem[$A][0] & "% = " & $mCustomItem[$A][1], $mCustomID[$A])
		Next
	EndIf

	$mPos = WinGetPos($mButton_Abbreviations, "")
	$mMsg = _GUICtrlMenu_TrackPopupMenu($mEnvMenu, $mButton_Abbreviations, $mPos[0] + $mPos[2], $mPos[1] + $mPos[3], 2, 1, 2)
	Switch $mMsg
		Case 1999 ; Add Abbreviation.
			_Manage_AddCustomAbbreviation($mMenuItem, $mCustomItem, $mNoCustom, $mINI, $mHandle)
		Case 2000 ; Remove Abbreviation.
			_Manage_RemoveCustomAbbreviation($mCustomItem, $mINI, $mHandle)
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
		_GUICtrlMenu_DestroyMenu($mMenuGroup[$A][2])
	Next

	Return $mValue
EndFunc   ;==>_Manage_ContextMenu_Abbreviations

Func _Manage_ContextMenu_ListView($cmListView, $cmIndex, $cmSubItem)
	Local Enum $cmItem1 = 1000, $cmItem2, $cmItem3, $cmItem4

	If IsHWnd($cmListView) = 0 Then
		$cmListView = GUICtrlGetHandle($cmListView)
	EndIf

	Local $cmContextMenu = _GUICtrlMenu_CreatePopup()
	If $cmIndex <> -1 And $cmSubItem <> -1 Then ; Won't Show These MenuItem(s) Unless An Item Is Selected.
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu, __GetLang('EDIT', 'Edit'), $cmItem1)
		__SetItemImage("EDIT", $cmIndex, $cmContextMenu, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu, __GetLang('COPYTO', 'Copy to') & "...", $cmItem2)
		__SetItemImage("COPYTO", $cmIndex, $cmContextMenu, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu, "")
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu, __GetLang('ACTION_DELETE', 'Delete'), $cmItem3)
		__SetItemImage("DEL", $cmIndex, $cmContextMenu, 2, 1)
	EndIf
	If $cmIndex = -1 And $cmSubItem <> -1 Then ; Will Show These MenuItem(s) If No Item Is Selected.
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu, __GetLang('NEW', 'New'), $cmItem4) ; Will Show These MenuItem(s) Regardless.
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
EndFunc   ;==>_Manage_ContextMenu_ListView
#EndRegion >>>>> Manage Functions <<<<<

#Region >>>>> Customize Functions <<<<<
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

	$cGUI = GUICreate(__GetLang('CUSTOMIZE_GUI', 'Customize Profiles'), $cSize[0], $cSize[1], -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX), -1, __OnTop($cHandle))
	GUISetIcon(@ScriptFullPath, -5, $cGUI) ; Use Custom.ico
	$Global_ResizeWidth = 300 ; Set Default Minimum Width.
	$Global_ResizeHeight = 190 ; Set Default Minimum Height.

	$cListView = GUICtrlCreateListView(__GetLang('PROFILE', 'Profile') & "|" & __GetLang('IMAGE', 'Image') & "|" & __GetLang('SIZE', 'Size') & "|" & __GetLang('OPACITY', 'Opacity'), 0, 0, $cSize[0], $cSize[1] - 35, BitOR($LVS_NOSORTHEADER, $LVS_REPORT, $LVS_SINGLESEL))
	$cListView_Handle = GUICtrlGetHandle($cListView)

	$Global_ListViewProfiles = $cListView_Handle
	GUICtrlSetResizing($cListView, $GUI_DOCKBORDERS)

	Local $cImageList = _GUIImageList_Create(20, 20, 5, 3) ; Create An ImageList.
	_GUICtrlListView_SetImageList($cListView, $cImageList, 1)
	$G_Global_ImageList = $cImageList

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

	$cNew = GUICtrlCreateButton(__GetLang('NEW', 'New'), 50, $cSize[1] - 31, 74, 25)
	GUICtrlSetTip($cNew, __GetLang('CUSTOMIZE_GUI_TIP_0', 'Click to add a profile or Right-click a profile to manage it.'))
	GUICtrlSetResizing($cNew, $GUI_DOCKSIZE + $GUI_DOCKLEFT + $GUI_DOCKBOTTOM)
	$cClose = GUICtrlCreateButton(__GetLang('CLOSE', 'Close'), $cSize[0] - 50 - 74, $cSize[1] - 31, 74, 25)
	GUICtrlSetTip($cClose, __GetLang('CUSTOMIZE_GUI_TIP_1', 'Save profiles and close the window.'))
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
				FileCopy($cProfileDirectory & $cText & ".ini", $cProfileDirectory & __Duplicate_Rename($cText & ".ini", $cProfileDirectory, 0, 2))
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
					MsgBox(0x30, __GetLang('CUSTOMIZE_MSGBOX_2', 'Importing Failed'), __GetLang('CUSTOMIZE_MSGBOX_3', 'Profile not imported. The source file might be not correctly structured.'), 0, __OnTop($cGUI))
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
					MsgBox(0x30, __GetLang('PROFILEUNIQUE_MSGBOX_0', 'Name not available'), __GetLang('PROFILEUNIQUE_MSGBOX_1', 'This profile name already exists.'), 0, __OnTop($cGUI))
					ContinueLoop
				EndIf
				Switch $Global_ListViewProfiles_Example[1]
					Case __GetLang('CUSTOMIZE_EXAMPLE_0', 'Archiver')
						__ArrayToProfile(_Customize_Examples(1), __GetLang('CUSTOMIZE_EXAMPLE_0', 'Archiver'), $cProfileDirectory, "Big_Box4.png", "80")
					Case __GetLang('CUSTOMIZE_EXAMPLE_1', 'Eraser')
						__ArrayToProfile(_Customize_Examples(2), __GetLang('CUSTOMIZE_EXAMPLE_1', 'Eraser'), $cProfileDirectory, "Big_Delete1.png", "80")
					Case __GetLang('CUSTOMIZE_EXAMPLE_2', 'Extractor')
						__ArrayToProfile(_Customize_Examples(3), __GetLang('CUSTOMIZE_EXAMPLE_2', 'Extractor'), $cProfileDirectory, "Big_Box6.png", "80")
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
			$cProfileType = __GetLang('CUSTOMIZE_PROFILE_NEW', 'New Profile')

		Case $cNewProfile = 0
			$cProfileType = __GetLang('CUSTOMIZE_PROFILE_EDIT', 'Edit Profile')
	EndSelect
	If __IsCurrentProfile($cProfile[1]) Then
		$cCurrentProfile = 1 ; __IsCurrentProfile() = Check If Selected Profile Is The Current Profile.
	EndIf
	$cInitialProfileName = $cProfile[1] ; For Renaming.

	$cGUI = GUICreate($cProfileType, 260, 290, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($cHandle))
	GUICtrlCreateLabel(__GetLang('NAME', 'Name') & ":", 10, 10, 120, 20)
	$cInput_Name = GUICtrlCreateInput($cProfile[1], 10, 31, 170, 20) ; Renaming Function Will Have To Be Re-Built.
	GUICtrlSetTip($cInput_Name, __GetLang('CUSTOMIZE_EDIT_TIP_0', 'Choose a name for this profile.'))

	GUICtrlCreateLabel(__GetLang('IMAGE', 'Image') & ":", 10, 60 + 10, 120, 20)
	$cInput_Image = GUICtrlCreateInput($cImage, 10, 60 + 31, 170, 20)
	GUICtrlSetTip($cInput_Image, __GetLang('CUSTOMIZE_EDIT_TIP_1', 'Select an image for this profile.'))
	$cButton_Image = GUICtrlCreateButton(__GetLang('SEARCH', 'Search'), 10 + 174, 60 + 30, 66, 22)
	GUICtrlSetTip($cButton_Image, __GetLang('SEARCH', 'Search'))

	GUICtrlCreateLabel(__GetLang('SIZE', 'Size') & ":", 10, 120 + 10, 120, 20)
	$cInput_SizeX = GUICtrlCreateInput($cSize[0], 10, 120 + 31, 50, 20, 0x2000)
	GUICtrlSetTip($cInput_SizeX, __GetLang('WIDTH', 'Width'))
	GUICtrlCreateLabel("X", 10 + 66, 120 + 34, 34, 20)
	$cInput_SizeY = GUICtrlCreateInput($cSize[1], 10 + 90, 120 + 31, 50, 20, 0x2000)
	GUICtrlSetTip($cInput_SizeY, __GetLang('HEIGHT', 'Height'))
	$cButton_Size = GUICtrlCreateButton(__GetLang('RESET', 'Reset'), 10 + 174, 120 + 30, 66, 22)
	GUICtrlSetTip($cButton_Size, __GetLang('CUSTOMIZE_EDIT_TIP_2', 'Reset target image to the original size.'))

	GUICtrlCreateLabel(__GetLang('OPACITY', 'Opacity') & ":", 10, 180 + 10, 120, 20)
	$cInput_Opacity = GUICtrlCreateSlider(10, 180 + 31, 200, 20)
	$Global_Slider = $cInput_Opacity
	GUICtrlSetLimit(-1, 100, 10)
	GUICtrlSetData(-1, $cOpacity)
	$cLabel_Opacity = GUICtrlCreateLabel($cOpacity & "%", 10 + 200, 180 + 31, 36, 20)
	$Global_SliderLabel = $cLabel_Opacity

	$cSave = GUICtrlCreateButton(__GetLang('SAVE', 'Save'), 130 - 20 - 76, 250, 76, 26)
	$cCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 130 + 20, 250, 76, 26)
	GUICtrlSetState($cSave, $GUI_DEFBUTTON)

	$cIcon_GUI = GUICreate("", 0, 0, 200, 24, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_MDICHILD), $cGUI)
	$cIcon_Label = GUICtrlCreateLabel("", 0, 0, 32, 32)
	GUICtrlSetCursor($cIcon_Label, 0)
	GUICtrlSetTip($cIcon_Label, __GetLang('CUSTOMIZE_EDIT_TIP_1', 'Select an image for this profile.'))
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
					If @error = 0 Then
						__SetCurrentPosition($cGUI_1)
					EndIf
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
		MsgBox(0x30, __GetLang('CUSTOMIZE_DELETE_MSGBOX_0', 'Profile Error'), __GetLang('CUSTOMIZE_DELETE_MSGBOX_1', 'You must have at least 1 active profile.'), 0, __OnTop($cHandle))
		Return SetError(1, 0, 0)
	EndIf

	Local $cMsgBox = MsgBox(0x4, __GetLang('CUSTOMIZE_DELETE_MSGBOX_2', 'Delete selected profile'), __GetLang('CUSTOMIZE_DELETE_MSGBOX_3', 'Selected profile:') & "  " & $cFileName & @LF & __GetLang('CUSTOMIZE_DELETE_MSGBOX_4', 'Are you sure to delete this profile?'), 0, __OnTop($cHandle))
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
			[0, __GetLang('CUSTOMIZE_EXAMPLE_0', 'Archiver'), "*;**", "Compress", "%Desktop%\" & __GetLang('ARCHIVE', 'Archive') & ".zip"]]

	Switch $cExample
		Case 2 ; Eraser.
			$cArray[2][1] = __GetLang('CUSTOMIZE_EXAMPLE_1', 'Eraser')
			$cArray[2][2] = "*;**"
			$cArray[2][3] = "Delete"
			$cArray[2][4] = "Safely Erase"
		Case 3 ; Extractor.
			$cArray[2][1] = __GetLang('CUSTOMIZE_EXAMPLE_2', 'Extractor')
			$cArray[2][2] = "*.*"
			$cArray[2][3] = "Extract"
			$cArray[2][4] = "%ParentDir%"
	EndSwitch

	Return $cArray
EndFunc   ;==>_Customize_Examples

Func _Customize_Import($cProfileDirectory, $cHandle = -1)
	Local $cListPath, $sProfileName, $cExcel, $cArray

	$cListPath = FileOpenDialog(__GetLang('CUSTOMIZE_MSGBOX_0', 'Select a file to import:'), @DesktopDir, __GetLang('CUSTOMIZE_MSGBOX_1', 'Supported files') & " (*.csv;*.xls;*.xlsx)", 1, "", $cHandle)
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
	__Log_Write(__GetLang('CUSTOMIZE_LOG_0', 'Profile Imported'), $sProfileName)

	Return 1
EndFunc   ;==>_Customize_Import

Func _Customize_Options($cProfileName, $cProfileDirectory, $cHandle = -1)
	Local $cGUI, $cSave, $cCancel, $cState, $cComboItems[5], $cCurrent[5]
	Local $cINI = $cProfileDirectory & $cProfileName & ".ini"
	Local $cOptions[4] = ["ShowSorting", "DirForFolders", "IgnoreNew", "AutoDup"]
	Local $cGroup = __GetLang('OPTIONS_PROFILE_MODE_0', 'Use global setting') & "|" & __GetLang('OPTIONS_PROFILE_MODE_1', 'Enable for this profile') & "|" & __GetLang('OPTIONS_PROFILE_MODE_2', 'Disable for this profile')

	$cGUI = GUICreate(__GetLang('OPTIONS_PROFILE', 'Profile Options'), 300, 296, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($cHandle))
	GUICtrlCreateLabel(__GetLang('OPTIONS_CHECKBOX_11', 'Show progress bar during process') & ":", 10, 10, 280, 20)
	$cComboItems[0] = GUICtrlCreateCombo("", 20, 10 + 20, 260, 20, 0x0003)
	GUICtrlCreateLabel(__GetLang('OPTIONS_CHECKBOX_2', 'Enable associations for folders') & ":", 10, 10 + 55, 280, 20)
	$cComboItems[1] = GUICtrlCreateCombo("", 20, 10 + 55 + 20, 260, 20, 0x0003)
	GUICtrlCreateLabel(__GetLang('OPTIONS_CHECKBOX_3', 'Ignore unassociated files/folders') & ":", 10, 10 + 110, 280, 20)
	$cComboItems[2] = GUICtrlCreateCombo("", 20, 10 + 110 + 20, 260, 20, 0x0003)
	GUICtrlCreateLabel(__GetLang('OPTIONS_CHECKBOX_5', 'Use automatic choice for duplicates') & ":", 10, 10 + 165, 280, 20)
	$cComboItems[3] = GUICtrlCreateCombo("", 20, 10 + 165 + 20, 260, 20, 0x0003)
	$cComboItems[4] = GUICtrlCreateCombo("", 20, 10 + 165 + 45, 260, 20, 0x0003)

	For $A = 0 To 3
		$cState = IniRead($cINI, "General", $cOptions[$A], "")
		Switch $cState
			Case "True"
				$cCurrent[$A] = __GetLang('OPTIONS_PROFILE_MODE_1', 'Enable for this profile')
			Case "False"
				$cCurrent[$A] = __GetLang('OPTIONS_PROFILE_MODE_2', 'Disable for this profile')
			Case Else
				$cCurrent[$A] = __GetLang('OPTIONS_PROFILE_MODE_0', 'Use global setting')
		EndSwitch
		GUICtrlSetData($cComboItems[$A], $cGroup, $cCurrent[$A])
	Next
	$cGroup = __GetLang('DUPLICATE_MODE_0', 'Overwrite') & "|" & __GetLang('DUPLICATE_MODE_1', 'Overwrite if newer') & "|" & _
			__GetLang('DUPLICATE_MODE_7', 'Overwrite if different size') & "|" & __GetLang('DUPLICATE_MODE_3', 'Rename as "Name 01"') & "|" & _
			__GetLang('DUPLICATE_MODE_4', 'Rename as "Name_01"') & "|" & __GetLang('DUPLICATE_MODE_5', 'Rename as "Name (01)"') & "|" & _
			__GetLang('DUPLICATE_MODE_6', 'Skip')
	$cCurrent[4] = __GetDuplicateMode(IniRead($cINI, "General", "DupMode", "Overwrite1"), 1)
	GUICtrlSetData($cComboItems[4], $cGroup, $cCurrent[4])

	$cState = $GUI_ENABLE
	If $cCurrent[3] <> __GetLang('OPTIONS_PROFILE_MODE_1', 'Enable for this profile') Then
		$cState = $GUI_DISABLE
	EndIf
	GUICtrlSetState($cComboItems[4], $cState)

	$cSave = GUICtrlCreateButton(__GetLang('SAVE', 'Save'), 150 - 25 - 80, 260, 80, 24)
	$cCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 150 + 25, 260, 80, 24)
	GUICtrlSetState($cSave, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)

	While 1
		If GUICtrlRead($cComboItems[3]) <> $cCurrent[3] And Not _GUICtrlComboBox_GetDroppedState($cComboItems[3]) Then
			$cCurrent[3] = GUICtrlRead($cComboItems[3])
			$cState = $GUI_ENABLE
			If $cCurrent[3] <> __GetLang('OPTIONS_PROFILE_MODE_1', 'Enable for this profile') Then
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
						Case __GetLang('OPTIONS_PROFILE_MODE_1', 'Enable for this profile')
							$cState = "True"
						Case __GetLang('OPTIONS_PROFILE_MODE_2', 'Disable for this profile')
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
	Local $cImageList = $G_Global_ImageList

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

Func _Customize_ContextMenu_ListView($cmListView, $cmIndex, $cmSubItem)
	Local Enum $cmItem1 = 1000, $cmItem2, $cmItem3, $cmItem4, $cmItem5, $cmItem6, $cmItem7, $cmItem8, $cmItem9, $cmItem10
	Local $cmContextMenu_1, $cmContextMenu_2

	If IsHWnd($cmListView) = 0 Then
		$cmListView = GUICtrlGetHandle($cmListView)
	EndIf

	$cmContextMenu_1 = _GUICtrlMenu_CreatePopup()
	If $cmIndex <> -1 And $cmSubItem <> -1 Then ; Won't Show These MenuItem(s) Unless An Item Is Selected.
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __GetLang('EDIT', 'Edit'), $cmItem1)
		__SetItemImage("EDIT", $cmIndex, $cmContextMenu_1, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __GetLang('OPTIONS', 'Options'), $cmItem8)
		__SetItemImage("OPT", $cmIndex, $cmContextMenu_1, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __GetLang('DUPLICATE', 'Duplicate'), $cmItem9)
		__SetItemImage("COPYTO", $cmIndex, $cmContextMenu_1, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, "")
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __GetLang('ACTION_DELETE', 'Delete'), $cmItem2)
		__SetItemImage("DEL", $cmIndex, $cmContextMenu_1, 2, 1)
	EndIf
	If $cmIndex = -1 And $cmSubItem <> -1 Then ; Will Show These MenuItem(s) If No Item Is Selected.
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __GetLang('NEW', 'New'), $cmItem3)
		__SetItemImage("NEW", $cmIndex, $cmContextMenu_1, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __GetLang('IMPORT', 'Import'), $cmItem10)
		__SetItemImage("IMPORT", $cmIndex, $cmContextMenu_1, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, "")

		$cmContextMenu_2 = _GUICtrlMenu_CreatePopup()
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __GetLang('EXAMPLES', 'Examples'), $cmItem4, $cmContextMenu_2)
		__SetItemImage("EXAMP", $cmIndex, $cmContextMenu_1, 2, 1)

		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_2, __GetLang('CUSTOMIZE_EXAMPLE_0', 'Archiver'), $cmItem5)
		__SetItemImage(__GetDefault(4) & "Big_Box4.png", $cmIndex, $cmContextMenu_2, 2, 0)

		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_2, __GetLang('CUSTOMIZE_EXAMPLE_1', 'Eraser'), $cmItem6)
		__SetItemImage(__GetDefault(4) & "Big_Delete1.png", $cmIndex, $cmContextMenu_2, 2, 0)

		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_2, __GetLang('CUSTOMIZE_EXAMPLE_2', 'Extractor'), $cmItem7)
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
			$Global_ListViewProfiles_Example[1] = __GetLang('CUSTOMIZE_EXAMPLE_0', 'Archiver')
			GUICtrlSendToDummy($Global_ListViewProfiles_Example[0])
		Case $cmItem6
			$Global_ListViewProfiles_Example[1] = __GetLang('CUSTOMIZE_EXAMPLE_1', 'Eraser')
			GUICtrlSendToDummy($Global_ListViewProfiles_Example[0])
		Case $cmItem7
			$Global_ListViewProfiles_Example[1] = __GetLang('CUSTOMIZE_EXAMPLE_2', 'Extractor')
			GUICtrlSendToDummy($Global_ListViewProfiles_Example[0])
	EndSwitch
	_GUICtrlMenu_DestroyMenu($cmContextMenu_1)
	_GUICtrlMenu_DestroyMenu($cmContextMenu_2)
	Return 1
EndFunc   ;==>_Customize_ContextMenu_ListView
#EndRegion >>>>> Customize Functions <<<<<

#Region >>>>> Processing Functions <<<<<
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
	__Log_Write(__GetLang('DROP_EVENT_TIP_0', 'Total Size Loaded'), __ByteSuffix($dFullSize)) ; __ByteSuffix() = Round A Value Of Bytes To Highest Value.

	If $dFullSize > 2 * 1024 * 1024 * 1024 And __Is("AlertSize") Then
		$dMsgBox = MsgBox(0x4, __GetLang('DROP_EVENT_MSGBOX_3', 'Estimated long processing time'), __GetLang('DROP_EVENT_MSGBOX_4', 'You are trying to process a large size of files') & " (" & __ByteSuffix($dFullSize) & ")" & @LF & __GetLang('DROP_EVENT_MSGBOX_5', 'It may take a long time, do you wish to continue?'), 0, __OnTop())
		If $dMsgBox <> 6 Then
			__Log_Write(__GetLang('DROP_EVENT_TIP_1', 'Sorting Aborted'), __GetLang('DROP_EVENT_MSGBOX_3', 'Estimated long processing time'))
			Return SetError(1, 0, 0)
		EndIf
	EndIf

	$dElementsGUI = _Sorting_CreateGUI($dFullSize) ; Create The Sorting GUI & Show It If Option Is Enabled.
	For $A = 1 To $dFiles[0]
		If FileExists($dFiles[$A]) Then
			$Global_MainDir = $dFiles[$A] ; Used Only To Detect Main Folders For %SubDir%.
			$dFailedList = _Position_Load($dFiles[$A], $dProfile, $dFailedList, $dElementsGUI, $dMonitored)
		EndIf
		If @error Then ; _Position_Load() Returns Error Only If Aborted.
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
			MsgBox(0x40, __GetLang('DROP_EVENT_MSGBOX_6', 'Sorting Partially Failed'), __GetLang('DROP_EVENT_MSGBOX_7', 'Sorting failed for the following files/folders:') & @LF & $dFailedString, 0, __OnTop())
		Else
			$dMsgBox = MsgBox(0x4, __GetLang('DROP_EVENT_MSGBOX_6', 'Sorting Partially Failed'), __GetLang('DROP_EVENT_MSGBOX_8', 'Sorting failed for some files/folders. Do you want to read a list of them?'), 0, __OnTop())
			If $dMsgBox = 6 Then
				Local $dFileName = @ScriptDir & "\FailedList.txt"
				Local $dFile = FileOpen($dFileName, 2 + 32)
				FileWriteLine($dFile, "{" & __GetLang('DROP_EVENT_MSGBOX_9', 'NOTE: this file will be removed after closing') & "}")
				FileWriteLine($dFile, "")
				FileWriteLine($dFile, __GetLang('DROP_EVENT_MSGBOX_7', 'Sorting failed for the following files/folders:'))
				FileWrite($dFile, $dFailedString)
				FileClose($dFile)
				ShellExecuteWait($dFileName)
				FileDelete($dFileName)
			EndIf
		EndIf
	EndIf

	__ExpandEnvStrings(0) ; Disable The Expansion Of Environment Variables.
	$G_Global_AbortSorting = 0
	$G_Global_DuplicateMode = ""
	Return 1
EndFunc   ;==>_DropEvent

Func _Matches_Checking($cFileName, $cFilePath, $cIsDirectory, $cProfile) ; Returns: Directory [C:\DropItFiles] Or To Associate [0] Or To Skip [-1]
	Local $cMatch, $cCheck, $cAssociation, $cAssociationSplit, $cStringSplit, $cString, $cAssociations, $cMatches[1][5] = [[0, 5]]

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
				$cAssociationSplit = StringSplit($cAssociation, ";")

				For $B = 1 To $cAssociationSplit[0]
					$cCheck = 0
					If StringInStr($cAssociationSplit[$B], "**") Then ; Rule For Folders.
						If $cIsDirectory Then
							$cAssociationSplit[$B] = StringReplace($cAssociationSplit[$B], "**", "*")
							$cCheck = 1
						EndIf
					ElseIf StringInStr($cAssociationSplit[$B], "*") Then ; Rule For Files.
						If $cIsDirectory = 0 Then
							$cCheck = 1
						EndIf
					EndIf

					If $cCheck Then
						$cAssociation = StringRegExpReplace($cAssociationSplit[$B], "(\.|\?|\+|\(|\)|\{|\}|\[|\]|\^|\$|\\)", "\\$1")
						$cAssociation = StringReplace($cAssociation, "*", "(.*?)") ; (.*?) = Match Any String Of Characters.
						$cStringSplit = StringSplit($cAssociation, "/") ; To Separate Exclusion Rules If Defined.
						For $C = 1 To $cStringSplit[0]
							If StringInStr($cStringSplit[$C], "\\") Then ; Rule Formatted As Path.
								$cString = $cFilePath
							Else ; Rule Formatted As File.
								$cString = $cFileName
							EndIf
							$cCheck = StringRegExp($cString, "^(?i)" & $cStringSplit[$C] & "$") ; ^ = Start String; (?i) = Case Insensitive; $ = End String.
							If $cCheck = 1 Then
								If $C = 1 Then ; It Match With Main Rule.
									$cMatch = 1
								Else ; It Match With Exclusion Rule.
									$cMatch = 0
									ExitLoop
								EndIf
							EndIf
						Next

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

	$mGUI = GUICreate(__GetLang('MOREMATCHES_GUI', 'Select Action'), $mWidth, 150 + 23 * $mRows, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))
	GUICtrlCreateGraphic(0, 0, $mWidth, 56)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlSetColor(-1, 0xffffff)

	GUICtrlCreateLabel(__GetLang('MOREMATCHES_LABEL_0', 'Loaded item:'), 14, 12, 300, 18)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlCreateLabel($mFileName, 16, 12 + 18, 296, 20)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlSetFont(-1, -1, 800)

	GUICtrlCreateLabel(__GetLang('MOREMATCHES_LABEL_1', 'Select the action to use:'), 14, 62, 300, 18)
	For $A = 1 To $mMatches[0][0]
		$mAction = StringRight($mMatches[$A][0], 2)
		$mDestination = $mMatches[$A][1]
		If $mAction == "$6" Then
			Switch $mMatches[$A][1] ; Destination.
				Case 2
					$mDestination = __GetLang('DELETE_MODE_2', 'Safely Erase')
				Case 3
					$mDestination = __GetLang('DELETE_MODE_3', 'Send to Recycle Bin')
				Case Else
					$mDestination = __GetLang('DELETE_MODE_1', 'Directly Remove')
			EndSwitch
		ElseIf $mAction == "$B" Then
			Switch $mMatches[$A][1] ; Destination.
				Case 2
					$mDestination = __GetLang('CLIPBOARD_MODE_2', 'File Name')
				Case 3
					$mDestination = __GetLang('LIST_LABEL_7', 'MD5 Hash')
				Case 4
					$mDestination = __GetLang('LIST_LABEL_8', 'SHA-1 Hash')
				Case 5
					$mDestination = __GetLang('LIST_LABEL_33', 'CRC Hash')
				Case 6
					$mDestination = __GetLang('LIST_LABEL_34', 'MD4 Hash')
				Case Else
					$mDestination = __GetLang('CLIPBOARD_MODE_1', 'Full Path')
			EndSwitch
		ElseIf $mAction == "$C" Then
			$mStringSplit = StringSplit($mMatches[$A][4], ";")
			$mDestination = $mStringSplit[1] & $mMatches[$A][1]
		EndIf
		$mString = $mMatches[$A][3] & " (" & __GetAssociationString($mAction) & ")" ; __GetAssociationString() = Convert Action Code To Action Name.
		$mString = " " & _WinAPI_PathCompactPathEx($mString, 48)
		$mButtons[$A] = GUICtrlCreateButton($mString, 14 + (300 + 10) * Int($A / ($mRows + 1)), 56 + 23 * $A - (23 * $mRows) * Int($A / ($mRows + 1)), 300, 22, 0x0100)
		GUICtrlSetTip($mButtons[$A], __GetLang('NAME', 'Name') & ": " & $mMatches[$A][3] & @LF & _
				__GetLang('ACTION', 'Action') & ": " & __GetAssociationString($mAction) & @LF & _
				__GetLang('DESTINATION', 'Destination') & ": " & $mDestination)
		$mButtons[0] += 1
	Next

	$mCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), ($mWidth / 2) - 50, 90 + 23 * $mRows, 100, 25)
	$mPriority = GUICtrlCreateCheckbox(__GetLang('MOREMATCHES_LABEL_2', 'Apply to all ambiguities of this drop'), 14, 125 + 23 * $mRows, 318, 20)
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

Func _Position_Abbreviations($pDestination, $pFilePath, $pProfile)
	Local $pLoadedProperty, $pStringSplit, $pTimeArray[6]
	Local $pProfileArray = __IsProfile($pProfile, 0) ; Get Array Of Selected Profile.
	Local $pEnvArray[82][3] = [ _
			[81, 0, 0], _
			["FileExt", 0, 1], _
			["FileName", 0, 2], _
			["FileNameExt", 0, 3], _
			["ParentDir", 0, 4], _
			["ParentDirName", 0, 5], _
			["PortableDrive", 0, 6], _
			["SubDir", 0, 7], _
			["ProfileName", 0, 8], _
			["ComputerName", 0, @ComputerName], _
			["UserName", 0, @UserName], _
			["AppData", 0, @AppDataDir], _
			["AppDataPublic", 0, @AppDataCommonDir], _
			["Desktop", 0, @DesktopDir], _
			["DesktopPublic", 0, @DesktopCommonDir], _
			["Documents", 0, @MyDocumentsDir], _
			["DocumentsPublic", 0, @DocumentsCommonDir], _
			["Favorites", 0, @FavoritesDir], _
			["FavoritesPublic", 0, @FavoritesCommonDir], _
			["ProgramFiles", 0, @ProgramFilesDir], _
			["Owner", 1, 8], _
			["Authors", 1, 12], _
			["FileType", 1, 2], _
			["Attributes", 1, 6], _
			["Comments", 1, 21], _
			["Copyright", 1, 22], _
			["Duration", 5, 23], _
			["BitRate", 1, 24], _
			["CameraModel", 1, 11], _
			["Dimensions", 1, 10], _
			["Megapixels", 4, 10], _
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
			["DateTaken", 2, 3], _
			["YearTaken", 2, 3], _
			["MonthTaken", 2, 3], _
			["DayTaken", 2, 3], _
			["TimeTaken", 2, 3], _
			["HourTaken", 2, 3], _
			["MinuteTaken", 2, 3], _
			["SecondTaken", 2, 3], _
			["CRC", 3, 1], _
			["MD4", 3, 2], _
			["MD5", 3, 3], _
			["SHA-1", 3, 4], _
			["SHA1", 3, 4]]

	For $A = 1 To $pEnvArray[0][0]
		If StringRegExp($pDestination, "%" & $pEnvArray[$A][0] & "%|%" & $pEnvArray[$A][0] & "#(.*?)%") Then
			Switch $pEnvArray[$A][1]
				Case 0
					Switch $pEnvArray[$A][2]
						Case 1
							$pLoadedProperty = __GetFileExtension($pFilePath)
						Case 2
							$pLoadedProperty = __GetFileNameOnly($pFilePath)
						Case 3
							$pLoadedProperty = __GetFileName($pFilePath)
						Case 4
							$pLoadedProperty = __GetParentFolder($pFilePath)
						Case 5
							$pLoadedProperty = __GetFileName(__GetParentFolder($pFilePath))
						Case 6
							$pLoadedProperty = StringLeft(@AutoItExe, 2) ; Drive Letter Without The Trailing "\".
						Case 7
							$pLoadedProperty = StringTrimLeft(__GetParentFolder($pFilePath), StringLen($Global_MainDir))
						Case 8
							$pLoadedProperty = $pProfileArray[1]
						Case Else
							$pLoadedProperty = $pEnvArray[$A][2]
					EndSwitch
				Case 1
					$pLoadedProperty = __GetFileProperties($pFilePath, $pEnvArray[$A][2])
				Case 2
					If $pEnvArray[$A][2] = 3 Then
						$pLoadedProperty = StringRegExpReplace(_ImageGetParam(_ImageGetInfo($pFilePath), "DateTime"), "[^0-9]", "")
						If StringIsDigit($pLoadedProperty) Then
							$pTimeArray[0] = StringLeft($pLoadedProperty, 4)
							$pTimeArray[1] = StringRight(StringLeft($pLoadedProperty, 6), 2)
							$pTimeArray[2] = StringRight(StringLeft($pLoadedProperty, 8), 2)
							$pTimeArray[3] = StringLeft(StringRight($pLoadedProperty, 6), 2)
							$pTimeArray[4] = StringLeft(StringRight($pLoadedProperty, 4), 2)
							$pTimeArray[5] = StringRight($pLoadedProperty, 2)
						Else
							SetError(1, 0, 0)
						EndIf
					Else
						$pTimeArray = FileGetTime($pFilePath, $pEnvArray[$A][2])
					EndIf
					$pLoadedProperty = ""
					If @error = 0 Then
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
				Case 3
					Switch $pEnvArray[$A][2]
						Case 1
							$pLoadedProperty = __CRC32ForFile($pFilePath)
						Case 2
							$pLoadedProperty = __MD4ForFile($pFilePath)
						Case 3
							$pLoadedProperty = __MD5ForFile($pFilePath)
						Case 4
							$pLoadedProperty = __SHA1ForFile($pFilePath)
					EndSwitch
				Case 4 ; Only Megapixels.
					$pLoadedProperty = StringRegExpReplace(__GetFileProperties($pFilePath, $pEnvArray[$A][2]), "[^[:alnum:]]", "")
					$pStringSplit = StringSplit($pLoadedProperty, "x")
					$pLoadedProperty = ""
					If $pStringSplit[0] = 2 Then
						$pLoadedProperty = Round($pStringSplit[1] * $pStringSplit[2] / 1000000, 1)
					EndIf
				Case 5 ; Only Duration.
					$pLoadedProperty = StringReplace(__GetFileProperties($pFilePath, $pEnvArray[$A][2]), ":", ".")
			EndSwitch
			If $pLoadedProperty == "" And $pEnvArray[$A][0] <> "SubDir" Then
				$pLoadedProperty = $pEnvArray[$A][0]
			EndIf
			$pDestination = _Modifier_StringReplaceModifier($pDestination, $pEnvArray[$A][0], $pLoadedProperty)
		EndIf
	Next

	Return $pDestination
EndFunc   ;==>_Position_Abbreviations

Func _Position_Load($pFilePath, $pProfile, $pFailedList, $pElementsGUI, $pMonitored = 0)
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
					$pFailedList = _Position_Load($pFilePath & "\" & $pFileName, $pProfile, $pFailedList, $pElementsGUI) ; If Selected Is A Directory Then Process The Directory.
					If @error Then ; _Position_Load() Returns Error Only If Aborted.
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
EndFunc   ;==>_Position_Load

Func _Position_Process($pFilePath, $pProfile, $pElementsGUI)
	Local $pFileName, $pFileExtension, $pCurrentSize, $pIsDirectory, $pDestination, $pSortFailed

	$pFilePath = _WinAPI_PathRemoveBackslash($pFilePath)
	If _WinAPI_PathIsDirectory($pFilePath) Then
		$pIsDirectory = 1
	EndIf
	If $pIsDirectory Then
		$pCurrentSize = DirGetSize($pFilePath)
		__Log_Write(__GetLang('POSITIONPROCESS_LOG_0', 'Folder Loaded'), $pFilePath)
	Else
		$pFileExtension = __GetFileExtension($pFilePath)
		$pCurrentSize = FileGetSize($pFilePath)
		__Log_Write(__GetLang('POSITIONPROCESS_LOG_1', 'File Loaded'), $pFilePath)
	EndIf
	$pFileName = __GetFileName($pFilePath)

	; Check Association Matches:
	$pDestination = _Matches_Checking($pFileName, $pFilePath, $pIsDirectory, $pProfile) ; Destination If OK, 0 To Associate, -1 To Skip.
	If $pDestination == 0 Then
		If __Is("IgnoreNew", -1, "False", $pProfile) Then
			GUICtrlSetData($pElementsGUI[2], __GetPercent($pCurrentSize)) ; Force Update Progress Bar.
			__Log_Write(__GetLang('POSITIONPROCESS_LOG_2', 'Not Sorted'), __GetLang('POSITIONPROCESS_LOGMSG_0', 'Skipped'))
			Return SetError(1, 0, 1) ; 1 = Skipped.
		Else
			Switch MsgBox(0x03, __GetLang('POSITIONPROCESS_MSGBOX_0', 'Association Needed'), __GetLang('POSITIONPROCESS_MSGBOX_1', 'No association found for:') & @LF & $pFilePath & @LF & @LF & __GetLang('POSITIONPROCESS_MSGBOX_2', 'Do you want to create an association for it?'), 0, __OnTop())
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
			__Log_Write(__GetLang('POSITIONPROCESS_LOG_2', 'Not Sorted'), __GetLang('POSITIONPROCESS_LOGMSG_0', 'Skipped'))
			Return SetError(1, 0, 1) ; 1 = Skipped.
		Else
			__Log_Write(__GetLang('POSITIONPROCESS_LOG_2', 'Not Sorted'), __GetLang('POSITIONPROCESS_LOGMSG_1', 'Aborted'))
			Return SetError(1, 0, 0) ; 0 = Aborted.
		EndIf
	EndIf

	; Show Sorting GUI Only If Needed:
	If __Is("ShowSorting", -1, "True", $pProfile) Then
		GUISetState(@SW_SHOW, $G_Global_SortingGUI)
	EndIf

	; Fix Destination For Rename Action:
	If $Global_Action == "$7" And $pIsDirectory Then
		$pDestination = StringReplace($pDestination, ".%FileExt%", "") ; Remove File Extension Environment Variable.
		$pDestination = StringReplace($pDestination, "%FileExt%", "") ; Remove File Extension Environment Variable.
		$pDestination = StringReplace($pDestination, "%FileName%", "%FileNameExt%") ; To Correctly Load Name.
	EndIf

	; Substitute Abbreviations:
	If StringInStr($pDestination, "%") Then
		$pDestination = _Position_Abbreviations($pDestination, $pFilePath, $pProfile)
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
			MsgBox(0x40, __GetLang('POSITIONPROCESS_MSGBOX_3', 'Destination Folder Problem'), __GetLang('POSITIONPROCESS_MSGBOX_4', 'Sorting operation has been partially skipped.') & @LF & __GetLang('POSITIONPROCESS_MSGBOX_5', 'The following destination folder does not exist and cannot be created:') & @LF & _WinAPI_PathCompactPathEx($pDestination, 65), 0, __OnTop())
			GUICtrlSetData($pElementsGUI[2], __GetPercent($pCurrentSize)) ; Force Update Progress Bar.
			__Log_Write(__GetLang('POSITIONPROCESS_LOG_2', 'Not Sorted'), __GetLang('POSITIONPROCESS_LOGMSG_2', 'Failed'))
			Return SetError(1, 0, $pFileName)
		EndIf
	EndIf

	; Update File Name For Compress, Extract And Create Shortcut Actions:
	If $Global_Action == "$3" And _WinAPI_PathIsDirectory($pDestination) Then
		$pDestination &= "\" & __GetFileNameOnly($pFileName) & ".zip" ; To Work Also If Destination Is A Directory.
	ElseIf $Global_Action == "$A" Then
		$pFileName &= " - " & __GetLang('SHORTCUT', 'shortcut') & ".lnk"
	EndIf

	; Manage Duplicates:
	If StringInStr("$0" & "$1" & "$7" & "$A", $Global_Action) Then
		If FileExists($pDestination & "\" & $pFileName) Then
			$pFileName = __Duplicate_Process($pFilePath, $pProfile, $pDestination, $pFileName)
			If @error = 1 Then ; Skip.
				__ExpandEventMode(0) ; Disable The Abort Button.
				GUICtrlSetData($pElementsGUI[2], __GetPercent($pCurrentSize)) ; Force Update Progress Bar.
				__Log_Write(__GetLang('POSITIONPROCESS_LOG_2', 'Not Sorted'), __GetLang('POSITIONPROCESS_LOGMSG_0', 'Skipped'))
				Return SetError(1, 0, 1) ; 1 = Skipped.
			EndIf
		EndIf
		$pDestination &= "\" & $pFileName
	EndIf

	__ExpandEventMode(1) ; Enable The Abort Button.
	$pDestination = _Sorting_Process($pFilePath, $pDestination, $pElementsGUI, $pProfile)
	$pSortFailed = @error
	__ExpandEventMode(0) ; Disable The Abort Button.

	; Process Log For This File/Folder:
	If $pSortFailed > 0 Then
		GUICtrlSetData($pElementsGUI[2], __GetPercent($pCurrentSize)) ; Force Update Progress Bar.
		If $pSortFailed = 2 Then
			__Log_Write(__GetLang('POSITIONPROCESS_LOG_2', 'Not Sorted'), __GetLang('POSITIONPROCESS_LOGMSG_0', 'Skipped'))
			Return SetError(1, 0, 1) ; 1 = Skipped.
		ElseIf $G_Global_AbortSorting Then
			__Log_Write(__GetLang('POSITIONPROCESS_LOG_2', 'Not Sorted'), __GetLang('POSITIONPROCESS_LOGMSG_1', 'Aborted'))
			Return SetError(1, 0, 0) ; 0 = Aborted.
		Else
			__Log_Write(__GetLang('POSITIONPROCESS_LOG_2', 'Not Sorted'), __GetLang('POSITIONPROCESS_LOGMSG_2', 'Failed'))
			Return SetError(1, 0, $pFileName) ; $pFileName = Failed.
		EndIf
	Else
		Local $pSyntaxMode
		Switch $Global_Action
			Case "$1"
				$pSyntaxMode = __GetLang('POSITIONPROCESS_LOG_6', 'Copied')
			Case "$3"
				$pSyntaxMode = __GetLang('POSITIONPROCESS_LOG_3', 'Compressed')
			Case "$4"
				$pSyntaxMode = __GetLang('POSITIONPROCESS_LOG_4', 'Extracted')
			Case "$5"
				$pSyntaxMode = __GetLang('POSITIONPROCESS_LOG_7', 'Opened')
			Case "$6"
				$pSyntaxMode = __GetLang('POSITIONPROCESS_LOG_8', 'Deleted')
			Case "$7"
				$pSyntaxMode = __GetLang('POSITIONPROCESS_LOG_9', 'Renamed')
			Case "$8"
				$pSyntaxMode = __GetLang('POSITIONPROCESS_LOG_10', 'Added to List')
			Case "$9"
				$pSyntaxMode = __GetLang('POSITIONPROCESS_LOG_13', 'Added to Playlist')
			Case "$A"
				$pSyntaxMode = __GetLang('POSITIONPROCESS_LOG_11', 'Shortcut Created')
			Case "$B"
				$pSyntaxMode = __GetLang('POSITIONPROCESS_LOG_12', 'Copied to Clipboard')
			Case Else
				$pSyntaxMode = __GetLang('POSITIONPROCESS_LOG_5', 'Moved')
		EndSwitch
		__Log_Write($pSyntaxMode, $pDestination)
	EndIf

	Return 1
EndFunc   ;==>_Position_Process

Func _Sorting_Abort()
	Switch @GUI_CtrlId
		Case $GUI_EVENT_CLOSE, $Global_AbortButton
			$G_Global_AbortSorting = 1
	EndSwitch
EndFunc   ;==>_Sorting_Abort

Func _Sorting_CreateGUI($sTotalSize)
	Local $sLabel1, $sLabel2, $sProgress_1, $sProgress_2, $sLoadDll

	$G_Global_SortingTotalSize = $sTotalSize
	$G_Global_SortingCurrentSize = 0

	If @AutoItX64 Then
		$sLoadDll = @ScriptDir & '\Lib\copy\Copy_x64.dll'
	Else
		$sLoadDll = @ScriptDir & '\Lib\copy\Copy.dll'
	EndIf
	If _Copy_OpenDll($sLoadDll) = 0 Then
		Return SetError(1, 0, 0)
	EndIf

	$G_Global_SortingGUI = GUICreate(__GetLang('POSITIONPROCESS_0', 'Sorting'), 400, 142, -1, -1, -1, -1, __OnTop())
	GUISetOnEvent($GUI_EVENT_CLOSE, '_Sorting_Abort')
	$sLabel1 = GUICtrlCreateLabel(__GetLang('POSITIONPROCESS_1', 'Loading') & '...', 16, 14, 368, 16)
	$sProgress_1 = GUICtrlCreateProgress(16, 14 + 16, 368, 16)
	$sLabel2 = GUICtrlCreateLabel('', 16, 60, 368, 16)
	$sProgress_2 = GUICtrlCreateProgress(16, 60 + 16, 368, 16)
	$Global_AbortButton = GUICtrlCreateButton(__GetLang('POSITIONPROCESS_2', 'Abort'), 200 - 45, 106, 90, 25)
	GUICtrlSetOnEvent(-1, '_Sorting_Abort')

	Local $sElementsGUI[4] = [$sLabel1, $sLabel2, $sProgress_1, $sProgress_2] ; Populate Elements GUI.

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return $sElementsGUI
EndFunc   ;==>_Sorting_CreateGUI

Func _Sorting_DeleteGUI()
	GUIDelete($G_Global_SortingGUI)
	_Copy_CloseDll()

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_Sorting_DeleteGUI

Func _Sorting_ArchiveFile($sSource, $sArchiveFile, $sElementsGUI, $sProfile, $sSize, $sType)
	Local $sLabel_2 = $sElementsGUI[1], $sProgress_1 = $sElementsGUI[2], $sProgress_2 = $sElementsGUI[3]
	Local $sPercent, $sProcess, $sDecrypt_Password = "", $sNewArchiveFile = "", $sINI, $sDuplicateMode = 0

	GUICtrlSetData($sLabel_2, _WinAPI_PathCompactPathEx($sArchiveFile, 68))
	GUICtrlSetData($sProgress_2, 0)

	Switch $sType
		Case 1 ; Extract Mode.
			$sProcess = __7ZipRun($sSource, $sArchiveFile, 2) ; Check If Archive Is Encrypted.
			Switch @error
				Case 1 ; Failed.
					Return SetError(1, 0, 0)
				Case 2 ; Password Needed.
					__ExpandEventMode(0) ; Disable The Abort Button.
					$sDecrypt_Password = __InsertPassword_GUI(_WinAPI_PathCompactPathEx(__GetFileName($sSource), 68))
					__ExpandEventMode(1) ; Enable The Abort Button.
					If $sDecrypt_Password = -1 Then
						Return SetError(1, 0, 0)
					EndIf
			EndSwitch
			$sDuplicateMode = "None" ; Needed To Match Else Case.
			If __Is("AutoDup", -1, "False", $sProfile) Then
				$sINI = __IsProfile($sProfile, 1) ; Get Profile Path Of Selected Profile.
				If IniRead($sINI, "General", "AutoDup", "Default") == "Default" Then
					$sINI = __IsSettingsFile() ; Get Default Settings INI File.
				EndIf
				$sDuplicateMode = IniRead($sINI, "General", "DupMode", "Skip")
			Else
				If $G_Global_DuplicateMode <> "" Then
					$sDuplicateMode = $G_Global_DuplicateMode
				EndIf
			EndIf
			Switch $sDuplicateMode
					Case "Overwrite1"
						$sDuplicateMode = 1
					Case "Skip"
						$sDuplicateMode = 2
					Case "Rename1", "Rename2", "Rename3"
						$sDuplicateMode = 3
					Case Else
						$sNewArchiveFile = $sArchiveFile & "\" & __GetFileNameOnly($sSource)
						If FileExists($sNewArchiveFile) Then
							$sNewArchiveFile = __Duplicate_Process($sArchiveFile & "\" & __GetFileNameOnly($sSource), $sProfile)
							If @error Then
								Return SetError(2, 0, 0) ; Skipped.
							EndIf
						EndIf
						$sArchiveFile = $sNewArchiveFile
						$sDuplicateMode = 0
			EndSwitch

		Case 3 ; Compress Action (With Update Archive Support).
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
					$sNewArchiveFile = __GetParentFolder($sArchiveFile) & "\" & __Duplicate_Process($sArchiveFile, $sProfile)
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
	EndSwitch

	$sProcess = __7ZipRun($sSource, $sArchiveFile, $sType, 0, $sDuplicateMode, 1, $sDecrypt_Password)
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

		If $G_Global_AbortSorting Then
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
			MsgBox(0x30, __GetLang('PASSWORD_MSGBOX_1', 'Password Not Correct'), __GetLang('PASSWORD_MSGBOX_3', 'You have to enter the correct password to extract this archive.'), 0, __OnTop())
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
	GUICtrlSetData($sLabel_2, __GetLang('ACTION_CHANGE_PROPERTIES', 'Change Properties'))
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
			$sClipboardText = __GetLang('CLIPBOARD_MODE_2', 'File Name')
			$sToCopy = __GetFileName($sSource)
		Case 3
			$sClipboardText = __GetLang('LIST_LABEL_7', 'MD5 Hash')
			$sToCopy = __MD5ForFile($sSource) & " = " & __GetFileName($sSource)
		Case 4
			$sClipboardText = __GetLang('LIST_LABEL_8', 'SHA-1 Hash')
			$sToCopy = __SHA1ForFile($sSource) & " = " & __GetFileName($sSource)
		Case 5
			$sClipboardText = __GetLang('LIST_LABEL_33', 'CRC Hash')
			$sToCopy = __CRC32ForFile($sSource) & " = " & __GetFileName($sSource)
		Case 6
			$sClipboardText = __GetLang('LIST_LABEL_34', 'MD4 Hash')
			$sToCopy = __MD4ForFile($sSource) & " = " & __GetFileName($sSource)
		Case Else
			$sClipboardText = __GetLang('CLIPBOARD_MODE_1', 'Full Path')
			$sToCopy = $sSource
	EndSwitch
	GUICtrlSetData($sLabel_2, __GetLang('ACTION_CLIPBOARD', 'Copy to Clipboard') & ": " & $sClipboardText)
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
			If $G_Global_AbortSorting Then
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
			$sDeleteText = __GetLang('DELETE_MODE_2', 'Safely Erase')
		Case 3
			$sDeleteText = __GetLang('DELETE_MODE_3', 'Send to Recycle Bin')
		Case Else
			$sDeleteText = __GetLang('DELETE_MODE_1', 'Directly Remove')
	EndSwitch
	GUICtrlSetData($sLabel_2, __GetLang('ACTION_DELETE', 'Delete') & ": " & $sDeleteText)
	GUICtrlSetData($sProgress_2, 0)

	If __Is("AlertDelete") Then
		Local $sMsgBox = MsgBox(0x4, __GetLang('DROP_EVENT_MSGBOX_10', 'Delete item'), __GetLang('MOREMATCHES_LABEL_0', 'Loaded item:') & @LF & __GetFileName($sSource) & @LF & @LF & __GetLang('DROP_EVENT_MSGBOX_11', 'Are you sure to delete this item?'), 0, __OnTop())
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
			$sNewListFile = __GetParentFolder($sStringSplit[1]) & "\" & __Duplicate_Process($sStringSplit[1], $sProfile)
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
			$sNewPlaylistFile = __GetParentFolder($sPlaylistFile) & "\" & __Duplicate_Process($sPlaylistFile, $sProfile)
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
	Local $sFileName, $sStringSplit, $sDirectory, $sOpen, $sConn, $sListArray, $sPassword_Code = $G_Global_PasswordKey

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
					$sDestination = $sDirectory & "/" & __Duplicate_ProcessOnline($sSource, $sProfile, $sListArray[$A][3], $sListArray[$A][1], $sListArray, $sStringSplit[5])
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
					$sDestination = $sDirectory & "/" & __Duplicate_ProcessOnline($sSource, $sProfile, $sListArray[$A][3], $sListArray[$A][1], $sListArray, $sStringSplit[5])
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

	If $G_Global_AbortSorting Then
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
#EndRegion >>>>> Processing Functions <<<<<

#Region >>>>> General Functions <<<<<
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

	__Log_Write(@LF & "===== " & __GetLang('DROPIT_STARTED', 'DropIt Started') & " =====")

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
						__Log_Write(__GetLang('MONITORED_FOLDER', 'Monitored Folder'), $mLoadedFolder[1])
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
							__Log_Write(__GetLang('MAIN_TIP_1', 'Changed Profile To'), $Global_ContextMenu[$A][1])
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
	Local $rUniqueID = $G_Global_UniqueID

	Local $rProfile = __IsProfile(-1, 0) ; Get Array Of Current Profile.
	Local $rPosition = __GetCurrentPosition() ; Get Current Coordinates/Position Of DropIt.

	$rGUI_1 = GUICreate("DropIt", $rProfile[5], $rProfile[6] + 100, $rPosition[0], $rPosition[1], $WS_POPUP, BitOR($WS_EX_ACCEPTFILES, $WS_EX_LAYERED, $WS_EX_TOOLWINDOW))
	$Global_GUI_1 = $rGUI_1
	__IsOnTop() ; Set GUI "OnTop" If True.
	__SetHandle($rUniqueID, $Global_GUI_1) ; Set Window Title For WM_COPYDATA.
	If $rProfile[7] < 10 Then
		$rProfile[7] = 100
		__ImageWrite(-1, 4, -1, -1, -1, $rProfile[7]) ; Write Opacity To The Current Profile.
	EndIf
	__SetBitmap($rGUI_1, $rProfile[3], 255 / 100 * $rProfile[7], $rProfile[5], $rProfile[6]) ; Set Image & Resize To The GUI.
	__GUIInBounds($rGUI_1) ; Check If The GUI Is Within View Of The Users Screen.
	If @error = 0 Then
		__SetCurrentPosition($rGUI_1)
	EndIf

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
	Local $rWinGetSize = WinGetClientSize($rGUI_1)
	WinMove($rGUI_1, "", $rWinGetPos[0] + $rWinGetSize[0] / 2 - $rProfile[5] / 2, $rWinGetPos[1] + $rWinGetSize[1] / 2 - $rProfile[6] / 2, $rProfile[5], $rProfile[6] + 100)
	__SetBitmap($rGUI_1, $rProfile[3], 255 / 100 * $rProfile[7], $rProfile[5], $rProfile[6]) ; Set Image & Resize To The GUI.
	Return 1
EndFunc   ;==>_Refresh_Image

Func _ContextMenu_Create($cHandle = $Global_Icon_1)
	Local $cCurrentProfile = __GetCurrentProfile() ; Get Current Profile From The Settings INI File.
	Local $cContextMenu = _ContextMenu_Delete($cHandle, $cCurrentProfile) ; Delete The Current ContextMenu Items.

	$cHandle = $Global_Icon_1
	Local $cProfileList = __ProfileList_Get() ; Get Array Of All Profiles.
	$cContextMenu[1][0] = GUICtrlCreateContextMenu($cHandle)
	$cContextMenu[2][0] = GUICtrlCreateMenuItem(__GetLang('ASSOCIATIONS', 'Associations'), $cContextMenu[1][0], 0)
	$cContextMenu[3][0] = GUICtrlCreateMenuItem("", $cContextMenu[1][0], 1)
	$cContextMenu[4][0] = GUICtrlCreateMenu(__GetLang('PROFILES', 'Profiles'), $cContextMenu[1][0], 2)
	$cContextMenu[5][0] = GUICtrlCreateMenuItem(__GetLang('OPTIONS', 'Options'), $cContextMenu[1][0], 3)
	$cContextMenu[6][0] = GUICtrlCreateMenuItem(__GetLang('HIDE', 'Hide'), $cContextMenu[1][0], 4)
	$cContextMenu[7][0] = GUICtrlCreateMenu(__GetLang('HELP', 'Help'), $cContextMenu[1][0], 5)
	$cContextMenu[8][0] = GUICtrlCreateMenuItem("", $cContextMenu[1][0], 6)
	$cContextMenu[9][0] = GUICtrlCreateMenuItem(__GetLang('EXIT', 'Exit'), $cContextMenu[1][0], 7)

	$cContextMenu[10][0] = GUICtrlCreateMenuItem(__GetLang('GUIDE', 'Guide'), $cContextMenu[7][0], 0)
	$cContextMenu[10][1] = 'GUIDE'
	$cContextMenu[11][0] = GUICtrlCreateMenuItem(__GetLang('README', 'Readme'), $cContextMenu[7][0], 1)
	$cContextMenu[11][1] = 'README'
	$cContextMenu[12][0] = GUICtrlCreateMenuItem(__GetLang('ABOUT', 'About') & "...", $cContextMenu[7][0], 2)
	$cContextMenu[12][1] = 'ABOUT'

	$cContextMenu[13][0] = GUICtrlCreateMenuItem(__GetLang('CUSTOMIZE', 'Customize'), $cContextMenu[4][0], 0)
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
	GUICtrlSetTip($cHandle, __GetLang('TITLE_TOOLTIP', 'Sort your files with a drop!'), "DropIt [" & $cCurrentProfile & "]")
	_WinAPI_SetFocus(GUICtrlGetHandle($cHandle)) ; Set The $Global_Icon_1 Label As Having Focus, Used For The HotKeys.
	Local $cContextMenu = $Global_ContextMenu
	Local $cReturn_ContextMenu[$cContextMenu[0][0] + 1][$cContextMenu[0][1]] = [[$cContextMenu[0][0], $cContextMenu[0][1]]]
	Return $cReturn_ContextMenu
EndFunc   ;==>_ContextMenu_Delete

Func _About($aHandle = -1)
	Local $aClose, $aGUI, $aIcon_GUI, $aIcon_Label, $aLicense, $aUpdate, $aUpdateProgress, $aUpdateText

	$aGUI = GUICreate(__GetLang('ABOUT', 'About'), 400, 155, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($aHandle))
	GUICtrlCreateLabel("DropIt", 80, 10, 310, 25)
	GUICtrlSetFont(-1, 18)
	GUICtrlCreateLabel("(v" & $G_Global_CurrentVersion & ")", 80, 40, 310, 17)
	GUICtrlCreateLabel("", 80, 60, 310, 1) ; Single Line.
	GUICtrlSetBkColor(-1, 0x000000)
	GUICtrlCreateLabel(__GetLang('MAIN_TIP_0', 'Software developed by %DropItTeam%.') & @LF & __GetLang('MAIN_TIP_2', 'Released under %DropItLicense%.'), 80, 70, 310, 45)

	$aUpdateText = GUICtrlCreateLabel("", 80, 101, 310, 18)
	If __IsWindowsVersion() = 0 Then
		$aUpdateProgress = GUICtrlCreateProgress(200, 16, 190, 14, 0x01)
		GUICtrlSetState($aUpdateProgress, $GUI_HIDE)
	Else
		$aUpdateProgress = GUICtrlCreatePic("", 200, 16, 190, 14)
	EndIf

	$aUpdate = GUICtrlCreateButton(__GetLang('CHECK_UPDATE', 'Check Update'), 10, 120, 120, 25)
	$aLicense = GUICtrlCreateButton(__GetLang('LICENSE', 'License'), 250, 120, 65, 25)
	If FileExists(@ScriptDir & "\License.txt") = 0 Then
		GUICtrlSetState($aLicense, $GUI_HIDE)
	EndIf
	$aClose = GUICtrlCreateButton(__GetLang('CLOSE', 'Close'), 325, 120, 65, 25)

	$aIcon_GUI = GUICreate("", 64, 64, 10, 10, $WS_POPUP, BitOR($WS_EX_MDICHILD, $WS_EX_LAYERED, $WS_EX_TOPMOST), $aGUI)
	GUISetBkColor(0x000001)
	_WinAPI_SetLayeredWindowAttributes($aIcon_GUI, 0x00000001, 0x00, 1, 0)
	$aIcon_Label = GUICtrlCreateLabel("", 0, 0, 64, 64)
	_ResourceSetImageToCtrl($aIcon_Label, "IMAGE")
	GUICtrlSetTip($aIcon_Label, __GetLang('VISIT_WEBSITE', 'Visit Website'))
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
				__Update_Check($aUpdateText, $aUpdateProgress, $aUpdate, $aGUI)

			Case $aIcon_Label
				ShellExecute(_WinAPI_ExpandEnvironmentStrings("%DropItURL%"))

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

	Local $oPW, $oPW_Code = $G_Global_PasswordKey
	Local $oBackupDirectory = __GetDefault(32) ; Get Default Backup Directory.
	Local $oLogFile = __GetDefault(513) ; Get Default Directory & LogFile File Name.
	Local $oThemeFolder = @ScriptDir & "\Lib\list\themes\"
	Local $oGUI, $oOK, $oCancel, $oMsg, $oMsgBox, $oLanguage, $oLanguageCombo, $oImageList, $oLogRemove, $oLogView, $oLogWrite, $oTab_1, $oCreateTab
	Local $oZIPPassword, $oShowZIPPassword, $o7ZPassword, $oShow7ZPassword, $oMasterPassword, $oShowMasterPassword, $oDisablePassword
	Local $oState, $oBk_Backup, $oBk_Restore, $oBk_Remove, $oNewDummy, $oEnterDummy, $oThemePreview, $oNoPreview
	Local $oListView, $oListView_Handle, $oIndex_Selected, $oFolder_Selected, $oMn_Add, $oMn_Edit, $oMn_Remove, $oScanTime

	$oGUI = GUICreate(__GetLang('OPTIONS', 'Options'), 380, 350, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($oHandle))

	$oCreateTab = GUICtrlCreateTab(0, 0, 380, 313) ; Create Tab Menu.

	; MAIN Tab:
	$oTab_1 = GUICtrlCreateTabItem(__GetLang('OPTIONS_TAB_0', 'Main'))
	GUICtrlSetState(-1, $GUI_SHOW) ; Show This Tab At Options Opening.

	GUICtrlCreateGroup(__GetLang('OPTIONS_LABEL_16', 'Interface'), 10, 30, 359, 105)
	$oCheckItems[1] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_0', 'Show target image always on top'), 25, 30 + 15)
	$oCheckItems[2] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_7', 'Lock target image position'), 25, 30 + 15 + 20)
	$oCheckItems[11] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_13', 'Use profile icon in traybar'), 25, 30 + 15 + 40)
	$oCheckItems[9] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_11', 'Show progress bar during process'), 25, 30 + 15 + 60)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__GetLang('OPTIONS_LABEL_3', 'Usage'), 10, 140, 359, 85)
	$oCheckItems[12] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_14', 'Start on system startup'), 25, 140 + 15)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_3', 'Note that this is a not portable feature.'))
	$oCheckItems[19] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_21', 'Start minimized to system tray'), 25, 140 + 15 + 20)
	$oCheckItems[4] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_6', 'Integrate in SendTo menu'), 25, 140 + 15 + 40, 290, 20)
	$oCheckModeItems[1] = GUICtrlCreateCheckbox("", 25 + 295, 140 + 15 + 40, 20, 20)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_1', 'This integration is created at DropIt startup and removed at closing.'), __GetLang('OPTIONS_PORTABLE_MODE', 'Portable Mode'), 0)
	$oCheckModeItems[2] = GUICtrlCreateIcon(@ScriptFullPath, -17, 25 + 315, 140 + 15 + 40 + 1, 16, 16)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_1', 'This integration is created at DropIt startup and removed at closing.'), __GetLang('OPTIONS_PORTABLE_MODE', 'Portable Mode'), 0)
	GUICtrlCreateGroup('', -99, -99, 1, 1)

	GUICtrlCreateGroup(__GetLang('OPTIONS_LABEL_1', 'Language'), 10, 230, 359, 52)
	$oLanguageCombo = _GUICtrlComboBoxEx_Create($oGUI, "", 25, 230 + 15 + 3, 330, 260, 0x0003)
	$oImageList = _GUIImageList_Create(16, 16, 5, 3) ; Create An ImageList.
	_GUICtrlComboBoxEx_SetImageList($oLanguageCombo, $oImageList)
	$G_Global_ImageList = $oImageList
	__LangList_Combo($oLanguageCombo)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; MONITORING Tab:
	GUICtrlCreateTabItem(__GetLang('OPTIONS_TAB_4', 'Monitoring'))

	GUICtrlCreateGroup(__GetLang('OPTIONS_LABEL_15', 'Folder Monitoring'), 10, 30, 359, 270)
	$oCheckItems[17] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_19', 'Scan every') & ":", 25, 30 + 15 + 2, 230, 20)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_10', 'Schedule a scan of selected folders with a defined time interval.'))
	$oScanTime = GUICtrlCreateInput("", 25 + 240, 30 + 15, 90, 20, 0x2000)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_9', 'Time interval in seconds'))
	$oListView = GUICtrlCreateListView(__GetLang('MONITORED_FOLDER', 'Monitored Folder') & "|" & __GetLang('ASSOCIATED_PROFILE', 'Associated Profile'), 20, 30 + 15 + 30, 340, 185, BitOR($LVS_NOSORTHEADER, $LVS_REPORT, $LVS_SINGLESEL))
	$oMn_Add = GUICtrlCreateButton(__GetLang('OPTIONS_BUTTON_4', 'Add'), 25, 250 + 15 + 3, 90, 22)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_BUTTON_4', 'Add'))
	$oMn_Edit = GUICtrlCreateButton(__GetLang('OPTIONS_BUTTON_5', 'Edit'), 25 + 120, 250 + 15 + 3, 90, 22)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_BUTTON_5', 'Edit'))
	$oMn_Remove = GUICtrlCreateButton(__GetLang('OPTIONS_BUTTON_3', 'Remove'), 25 + 240, 250 + 15 + 3, 90, 22)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_BUTTON_3', 'Remove'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; SORTING Tab:
	GUICtrlCreateTabItem(__GetLang('OPTIONS_TAB_1', 'Sorting'))

	GUICtrlCreateGroup(__GetLang('OPTIONS_LABEL_0', 'General'), 10, 30, 359, 185)
	$oCheckItems[6] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_2', 'Enable associations for folders'), 25, 30 + 15)
	$oCheckItems[20] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_22', 'Scan also subfolders'), 25, 30 + 15 + 20)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_11', 'It does not work if folders association is enabled.'))
	$oCheckItems[7] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_3', 'Ignore unassociated files/folders'), 25, 30 + 15 + 40)
	$oCheckItems[25] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_28', 'Select ambiguities checkbox by default'), 25, 30 + 15 + 60)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_18', 'Checkbox that apply selection to all ambiguities of a drop is selected by default.'))
	$oCheckItems[14] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_16', 'Confirm for large loaded files'), 25, 30 + 15 + 80)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_15', 'It requires a confirmation if more than 2 GB of files are loaded.'))
	$oCheckItems[15] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_23', 'Confirm for Delete actions'), 25, 30 + 15 + 100)
	$oCheckItems[13] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_4', 'Check moved/copied files integrity'), 25, 30 + 15 + 120)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_4', 'Activating MD5 check will slow down the sorting process.'))
	$oCheckItems[16] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_18', 'Pause until opened file is closed'), 25, 30 + 15 + 140)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_8', 'Pause the sorting process at each "Open With" action.'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__GetLang('OPTIONS_LABEL_5', 'Manage Duplicates'), 10, 220, 359, 72)
	$oCheckItems[8] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_5', 'Use automatic choice for duplicates'), 25, 220 + 15)
	$oComboItems[1] = GUICtrlCreateCombo("", 25, 220 + 15 + 20 + 3, 330, 20, 0x0003)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; COMPRESSION Tab:
	GUICtrlCreateTabItem(__GetLang('OPTIONS_TAB_2', 'Compression'))

	GUICtrlCreateGroup("ZIP", 10, 30, 359, 135)
	GUICtrlCreateLabel(__GetLang('OPTIONS_LABEL_11', 'Level') & ":", 25, 30 + 15 + 4, 110, 20)
	$oComboItems[2] = GUICtrlCreateCombo("", 25 + 120, 30 + 15, 210, 20, 0x0003)
	GUICtrlCreateLabel(__GetLang('OPTIONS_LABEL_12', 'Method') & ":", 25, 30 + 15 + 30 + 4, 110, 20)
	$oComboItems[3] = GUICtrlCreateCombo("", 25 + 120, 30 + 15 + 30, 210, 20, 0x0003)
	GUICtrlCreateLabel(__GetLang('OPTIONS_LABEL_9', 'Encryption') & ":", 25, 30 + 15 + 60 + 4, 110, 20)
	$oComboItems[4] = GUICtrlCreateCombo("", 25 + 120, 30 + 15 + 60, 210, 20, 0x0003)
	GUICtrlCreateLabel(__GetLang('OPTIONS_LABEL_13', 'Password') & ":", 25, 30 + 15 + 90 + 4, 110, 20)
	$oZIPPassword = GUICtrlCreateInput("", 25 + 120, 30 + 15 + 90, 196, 20, 0x0020)
	$oShowZIPPassword = GUICtrlCreateButton("", 25 + 120 + 196, 30 + 15 + 90, 14, 20)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_2', 'Show/Hide the password'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup("7Z / EXE", 10, 170, 359, 135)
	GUICtrlCreateLabel(__GetLang('OPTIONS_LABEL_11', 'Level') & ":", 25, 170 + 15 + 4, 110, 20)
	$oComboItems[5] = GUICtrlCreateCombo("", 25 + 120, 170 + 15, 210, 20, 0x0003)
	GUICtrlCreateLabel(__GetLang('OPTIONS_LABEL_12', 'Method') & ":", 25, 170 + 15 + 30 + 4, 110, 20)
	$oComboItems[6] = GUICtrlCreateCombo("", 25 + 120, 170 + 15 + 30, 210, 20, 0x0003)
	GUICtrlCreateLabel(__GetLang('OPTIONS_LABEL_9', 'Encryption') & ":", 25, 170 + 15 + 60 + 4, 110, 20)
	$oComboItems[7] = GUICtrlCreateCombo("", 25 + 120, 170 + 15 + 60, 210, 20, 0x0003)
	GUICtrlCreateLabel(__GetLang('OPTIONS_LABEL_13', 'Password') & ":", 25, 170 + 15 + 90 + 4, 110, 20)
	$o7ZPassword = GUICtrlCreateInput("", 25 + 120, 170 + 15 + 90, 196, 20, 0x0020)
	$oShow7ZPassword = GUICtrlCreateButton("", 25 + 120 + 196, 170 + 15 + 90, 14, 20)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_2', 'Show/Hide the password'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; LISTS Tab:
	GUICtrlCreateTabItem(__GetLang('OPTIONS_TAB_5', 'Lists'))
	GUICtrlCreateGroup(__GetLang('OPTIONS_LABEL_0', 'General'), 10, 30, 359, 105)
	$oCheckItems[21] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_24', 'Create sortable HTML lists'), 25, 30 + 15)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_12', 'Allow to sort table content when you click the column header fields.'))
	$oCheckItems[22] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_25', 'Add filter to HTML lists'), 25, 30 + 15 + 20)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_13', 'Add a box where you can type words to filter table content.'))
	$oCheckItems[24] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_27', 'Add lightbox to HTML lists'), 25, 30 + 15 + 40)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_14', 'Open images from Absolute and Relative Links in an overlapped preview.'))
	$oCheckItems[23] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_26', 'Add header to TXT and CSV lists'), 25, 30 + 15 + 60)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__GetLang('OPTIONS_LABEL_17', 'HTML Theme'), 10, 140, 359, 162)
	$oComboItems[8] = GUICtrlCreateCombo("", 25, 140 + 15 + 3, 330, 20, $WS_VSCROLL + $CBS_DROPDOWNLIST)
	$oThemePreview = GUICtrlCreatePic($oThemeFolder & "Default.jpg", 25, 140 + 15 + 35, 330, 100)
	$oNoPreview = GUICtrlCreateLabel(__GetLang('OPTIONS_LABEL_18', 'Preview Not Available'), 25 + 85, 140 + 15 + 75, 130, 40)
	GUICtrlSetState($oNoPreview, $GUI_HIDE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; VARIOUS Tab:
	GUICtrlCreateTabItem(__GetLang('OPTIONS_TAB_3', 'Various'))

	GUICtrlCreateGroup(__GetLang('OPTIONS_LABEL_0', 'General'), 10, 30, 359, 85)
	$oCheckItems[3] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_8', 'Enable multiple instances'), 25, 30 + 15)
	$oCheckItems[18] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_20', 'Check for updates at DropIt startup'), 25, 30 + 15 + 20)
	$oCheckItems[26] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_29', 'Consider rules as Regular Expressions'), 25, 30 + 15 + 40)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_16', 'Pay attention because rules created with normal syntax will not work.'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__GetLang('OPTIONS_LABEL_14', 'Security'), 10, 120, 359, 75)
	$oCheckItems[10] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_12', 'Encrypt profiles at DropIt closing'), 25, 120 + 15)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_6', 'Password will be requested at DropIt startup.'))
	GUICtrlCreateLabel(__GetLang('OPTIONS_LABEL_13', 'Password') & ":", 25, 120 + 15 + 30, 110, 20)
	$oMasterPassword = GUICtrlCreateInput("", 25 + 120, 120 + 15 + 27, 196, 20, 0x0020)
	$oShowMasterPassword = GUICtrlCreateButton("", 25 + 120 + 196, 120 + 15 + 27, 14, 20)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_2', 'Show/Hide the password'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__GetLang('OPTIONS_LABEL_7', 'Activity Log'), 10, 200, 359, 50)
	$oCheckItems[5] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_1', 'Write log file'), 25, 200 + 15 + 3, 190, 20)
	$oLogRemove = GUICtrlCreateIcon(@ScriptFullPath, -18, 25 + 216, 200 + 15 + 4, 16, 16)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_17', 'Remove log file'))
	$oLogView = GUICtrlCreateButton(__GetLang('OPTIONS_BUTTON_0', 'View'), 25 + 240, 200 + 15 + 2, 90, 22)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__GetLang('OPTIONS_LABEL_2', 'Settings Backup'), 10, 255, 359, 50)
	$oBk_Backup = GUICtrlCreateButton(__GetLang('OPTIONS_BUTTON_1', 'Back up'), 25, 255 + 15 + 3, 90, 22)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_BUTTON_1', 'Back up'))
	$oBk_Restore = GUICtrlCreateButton(__GetLang('OPTIONS_BUTTON_2', 'Restore'), 25 + 120, 255 + 15 + 3, 90, 22)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_BUTTON_2', 'Restore'))
	$oBk_Remove = GUICtrlCreateButton(__GetLang('OPTIONS_BUTTON_3', 'Remove'), 25 + 240, 255 + 15 + 3, 90, 22)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_BUTTON_3', 'Remove'))
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
	$oGroup[1] = __GetLang('DUPLICATE_MODE_0', 'Overwrite') & "|" & __GetLang('DUPLICATE_MODE_1', 'Overwrite if newer') & "|" & _
			__GetLang('DUPLICATE_MODE_7', 'Overwrite if different size') & "|" & __GetLang('DUPLICATE_MODE_3', 'Rename as "Name 01"') & "|" & _
			__GetLang('DUPLICATE_MODE_4', 'Rename as "Name_01"') & "|" & __GetLang('DUPLICATE_MODE_5', 'Rename as "Name (01)"') & "|" & _
			__GetLang('DUPLICATE_MODE_6', 'Skip')
	$oCurrent[1] = __GetDuplicateMode(IniRead($oINI, "General", "DupMode", "Overwrite1"), 1)

	$oGroup[2] = __GetLang('COMPRESS_LEVEL_0', 'Fastest') & "|" & __GetLang('COMPRESS_LEVEL_1', 'Fast') & "|" & __GetLang('COMPRESS_LEVEL_2', 'Normal') & "|" & _
			__GetLang('COMPRESS_LEVEL_3', 'Maximum') & "|" & __GetLang('COMPRESS_LEVEL_4', 'Ultra')
	$oCurrent[2] = __GetCompressionLevel(IniRead($oINI, "General", "ZIPLevel", "5"))

	$oGroup[3] = "Deflate|LZMA|PPMd|BZip2"
	$oCurrent[3] = IniRead($oINI, "General", "ZIPMethod", "Deflate")
	If StringInStr($oGroup[3], $oCurrent[3]) = 0 Then
		$oCurrent[3] = "Deflate"
	EndIf

	$oGroup[4] = __GetLang('COMPRESS_ENCRYPT', 'None') & "|ZipCrypto|AES-256"
	$oCurrent[4] = IniRead($oINI, "General", "ZIPEncryption", "None")
	If StringInStr($oGroup[4], $oCurrent[4]) = 0 Then
		$oCurrent[4] = __GetLang('COMPRESS_ENCRYPT', 'None')
	EndIf

	$oGroup[5] = $oGroup[2]
	$oCurrent[5] = __GetCompressionLevel(IniRead($oINI, "General", "7ZLevel", "5"))

	$oGroup[6] = "LZMA|LZMA2|PPMd|BZip2"
	$oCurrent[6] = IniRead($oINI, "General", "7ZMethod", "LZMA")
	If StringInStr($oGroup[6], $oCurrent[6]) = 0 Then
		$oCurrent[6] = "LZMA"
	EndIf

	$oGroup[7] = __GetLang('COMPRESS_ENCRYPT', 'None') & "|AES-256"
	$oCurrent[7] = IniRead($oINI, "General", "7ZEncryption", "None")
	If StringInStr($oGroup[7], $oCurrent[7]) = 0 Then
		$oCurrent[7] = __GetLang('COMPRESS_ENCRYPT', 'None')
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
	If $oCurrent[4] <> __GetLang('COMPRESS_ENCRYPT', 'None') Then
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
	If $oCurrent[7] <> __GetLang('COMPRESS_ENCRYPT', 'None') Then
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
	__Monitored_Update($oListView_Handle, $oINI)
	$oNewDummy = GUICtrlCreateDummy()
	$Global_ListViewFolders_New = $oNewDummy
	$oEnterDummy = GUICtrlCreateDummy()
	$Global_ListViewFolders_Enter = $oEnterDummy

	$oOK = GUICtrlCreateButton(__GetLang('OK', 'OK'), 190 - 30 - 90, 318, 90, 26)
	$oCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 190 + 30, 318, 90, 26)
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
			__Monitored_SetState($oINI, _GUICtrlListView_GetItemText($oListView_Handle, $Global_ListViewFolders_ItemChange), _GUICtrlListView_GetItemText($oListView_Handle, $Global_ListViewFolders_ItemChange, 1), _GUICtrlListView_GetItemChecked($oListView_Handle, $Global_ListViewFolders_ItemChange))
			$Global_ListViewFolders_ItemChange = -1
		EndIf

		; Update Compression Combo If Encryption Changes:
		If GUICtrlRead($oComboItems[4]) <> $oCurrent[4] And Not _GUICtrlComboBox_GetDroppedState($oComboItems[4]) Then
			$oCurrent[4] = GUICtrlRead($oComboItems[4])
			$oState = $GUI_DISABLE
			If $oCurrent[4] <> __GetLang('COMPRESS_ENCRYPT', 'None') Then
				$oState = $GUI_ENABLE
			EndIf
			GUICtrlSetState($oZIPPassword, $oState)
			GUICtrlSetState($oShowZIPPassword, $oState)
		EndIf
		If GUICtrlRead($oComboItems[7]) <> $oCurrent[7] And Not _GUICtrlComboBox_GetDroppedState($oComboItems[7]) Then
			$oCurrent[7] = GUICtrlRead($oComboItems[7])
			$oState = $GUI_DISABLE
			If $oCurrent[7] <> __GetLang('COMPRESS_ENCRYPT', 'None') Then
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
				__Monitored_Edit_GUI($oGUI, $oINI, $oListView_Handle, -1, -1)
				__Monitored_Update($oListView_Handle, $oINI)

			Case $oEnterDummy, $oMn_Edit, $oMn_Remove
				If Not _GUICtrlListView_GetItemState($oListView_Handle, $oIndex_Selected, $LVIS_SELECTED) Or $oIndex_Selected = -1 Then
					ContinueLoop
				EndIf
				$oFolder_Selected = _GUICtrlListView_GetItemText($oListView_Handle, $oIndex_Selected)

				If $oMsg = $oMn_Remove Then
					$oMsgBox = MsgBox(0x4, __GetLang('OPTIONS_MONITORED_MSGBOX_0', 'Delete monitored folder'), __GetLang('OPTIONS_MONITORED_MSGBOX_1', 'Are you sure to remove this monitored folder from the list?'), 0, __OnTop($oGUI))
					If $oMsgBox = 6 Then
						IniDelete($oINI, "MonitoredFolders", $oFolder_Selected)
						_GUICtrlListView_DeleteItem($oListView_Handle, $oIndex_Selected)
						$Global_ListViewIndex = -1 ; Set As No Item Selected.
					EndIf
				Else
					__Monitored_Edit_GUI($oGUI, $oINI, $oListView_Handle, $oIndex_Selected, $oFolder_Selected)
					__Monitored_Update($oListView_Handle, $oINI)
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
				If $oState = __GetLang('COMPRESS_ENCRYPT', 'None') Then
					$oState = "None"
				EndIf
				__IniWriteEx($oINI, $oINI_Various_Array[8][0], $oINI_Various_Array[8][1], $oState)

				$oState = GUICtrlRead($oComboItems[7])
				If $oState = __GetLang('COMPRESS_ENCRYPT', 'None') Then
					$oState = "None"
				EndIf
				__IniWriteEx($oINI, $oINI_Various_Array[12][0], $oINI_Various_Array[12][1], $oState)

				_GUICtrlComboBoxEx_GetItemText($oLanguageCombo, _GUICtrlComboBoxEx_GetCurSel($oLanguageCombo), $oLanguage)
				__SetCurrentLanguage($oLanguage) ; Set The Selected Language To The Settings INI File.

				If __Is("UseSendTo", $oINI) And GUICtrlRead($oCheckItems[4]) <> 1 Then
					__SendTo_Uninstall() ; Remove SendTo Integration If It Is Been Disabled Now.
				EndIf

				If __Is("CreateLog", $oINI) And GUICtrlRead($oCheckItems[5]) <> 1 And FileExists($oLogFile[1][0] & $oLogFile[2][0]) Then
					__Log_Write("===== " & __GetLang('LOG_DISABLED', 'Log Disabled') & " =====")
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
					__Log_Write("===== " & __GetLang('LOG_ENABLED', 'Log Enabled') & " =====")
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
					$oMsgBox = MsgBox(0x4, __GetLang('OPTIONS_ENCRYPTION_MSGBOX_0', 'Encryption Problem'), __GetLang('OPTIONS_ENCRYPTION_MSGBOX_1', 'Encryption features need a password to be used, do you wish to disable them?'), 0, __OnTop($oGUI))
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
	If $G_Global_IsMultipleInstance Then
		__SetMultipleInstances("-")
	EndIf
	__Log_Write("===== " & __GetLang('DROPIT_CLOSED', 'DropIt Closed') & " =====")

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
#EndRegion >>>>> General Functions <<<<<

#Region >>>>> TrayMenu Functions <<<<<
Func _TrayMenu_Create()
	Local $tTrayMenu = _TrayMenu_Delete() ; Delete The Current TrayMenu Items.
	Local $tProfileList = __ProfileList_Get() ; Get Array Of All Profiles.

	$tTrayMenu[1][0] = TrayCreateItem(__GetLang('ASSOCIATIONS', 'Associations'), -1, 0)
	$tTrayMenu[2][0] = TrayCreateItem("", -1, 1)
	$tTrayMenu[3][0] = TrayCreateMenu(__GetLang('PROFILES', 'Profiles'), -1, 2)
	$tTrayMenu[4][0] = TrayCreateItem(__GetLang('OPTIONS', 'Options'), -1, 3)
	$tTrayMenu[5][0] = TrayCreateItem(__GetLang('SHOW', 'Show'), -1, 4)
	$tTrayMenu[6][0] = TrayCreateMenu(__GetLang('HELP', 'Help'), -1, 5)
	$tTrayMenu[7][0] = TrayCreateItem("", -1, 6)
	$tTrayMenu[8][0] = TrayCreateItem(__GetLang('EXIT', 'Exit'), -1, 7)

	$tTrayMenu[9][0] = TrayCreateItem(__GetLang('GUIDE', 'Guide'), $tTrayMenu[6][0], 0)
	$tTrayMenu[9][1] = 'GUIDE'
	$tTrayMenu[10][0] = TrayCreateItem(__GetLang('README', 'Readme'), $tTrayMenu[6][0], 1)
	$tTrayMenu[10][1] = 'README'
	$tTrayMenu[11][0] = TrayCreateItem(__GetLang('ABOUT', 'About') & "...", $tTrayMenu[6][0], 2)
	$tTrayMenu[11][1] = 'ABOUT'

	$tTrayMenu[12][0] = TrayCreateItem(__GetLang('CUSTOMIZE', 'Customize'), $tTrayMenu[3][0], 0)
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
			__Log_Write(__GetLang('MAIN_TIP_1', 'Changed Profile To'), $pTrayMenu[$A][1])
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
#EndRegion >>>>> TrayMenu Functions <<<<<

#Region >>>>> WM_MESSAGES Functions <<<<<
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
	Local $hHandle = WinGetHandle($sTitleID), $sReturn = ""
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
		Local $tData = DllStructCreate("wchar[" & StringLen($sString) + 1 & "]")
		DllStructSetData($tData, 1, $sString)

		Local $ilParam = DllStructCreate("ulong_ptr;dword;ptr")
		DllStructSetData($ilParam, 1, 0)
		DllStructSetData($ilParam, 2, DllStructGetSize($tData))
		DllStructSetData($ilParam, 3, DllStructGetPtr($tData))
		_SendMessage($hHandle, $WM_COPYDATA, 0, DllStructGetPtr($ilParam))
		Return Number(Not @error)
	EndIf
EndFunc   ;==>WM_COPYDATA_SENDDATA

Func WM_DROPFILES($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $ilParam
	Local $aError[1] = [0]
	Switch $iMsg
		Case $WM_DROPFILES
			Local $aReturn = _WinAPI_DragQueryFileEx($iwParam)
			If IsArray($aReturn) Then
				$Global_DroppedFiles = $aReturn
			Else
				$Global_DroppedFiles = $aError
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
					_Customize_ContextMenu_ListView($nListViewProfiles, $nIndex, $nSubItem) ; Show Customize GUI RightClick Menu.
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
					_Manage_ContextMenu_ListView($nListViewRules, $nIndex, $nSubItem) ; Show Manage GUI RightClick Menu.
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
#EndRegion >>>>> WM_MESSAGES Functions <<<<<

#Region >>>>> INTERNAL: Installation Functions <<<<<
Func __SendTo_Install() ; Taken From: http://www.autoitscript.com/forum/topic/129818-sendto-create-a-shortcut-in-the-sendto-folder/
	#cs
		Description: Create Shortcuts In The SendTo Folder. [DropIt (Profile_Name).lnk]
		Returns: 1
	#ce
	Local $aFileListToArray = __ProfileList_Get() ; Get Array Of All Profiles.
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
	Local $aFileGetShortcut = ""

	Local $sSendTo_Directory = _WinAPI_ShellGetSpecialFolderPath($CSIDL_SENDTO) & "\"
	Local $aFileListToArray = __FileListToArrayEx($sSendTo_Directory, "*")
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

Func __Uninstall()
	#cs
		Description: Uninstall Files Etc... If The Uninstall Commandline Parameter Is Called. [DropIt.exe /Uninstall]
		Returns: 1
	#ce
	If __Is("UseSendTo") Then
		__SendTo_Uninstall() ; SendTo Integration Is Removed If Was Used By The Installed Version.
	EndIf
	If __IsInstalled() And FileExists(@AppDataDir & "\DropIt") Then
		Local $uMsgBox = MsgBox(0x4, __GetLang('UNINSTALL_MSGBOX_0', 'Remove settings'), __GetLang('UNINSTALL_MSGBOX_1', 'Do you want to remove also your settings and profiles?'))
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
	If $uOldVersion == $G_Global_CurrentVersion Then
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
		Local $uFileRead, $uFileOpen, $uAssociations, $uNumberFields = $G_Global_NumberFields
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
#EndRegion >>>>> INTERNAL: Installation Functions <<<<<

#Region >>>>> INTERNAL: Various Functions <<<<<
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
			__CloseInstances()
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

Func __SingletonEx() ; Modified From: http://www.autoitscript.com/forum/topic/119502-solved-wm-copydata-x64-issue/
	#cs
		Description: Check If DropIt Is Already Running.
		Returns: 1 Or Window Title.
	#ce
	Local $hHandle, $iMultipleInstances
	Local $sData = $G_Global_UniqueID

	$hHandle = WinGetHandle($sData)
	If @error Then ; No Instance Is Currently Running.
		__CMDLine($CmdLine) ; Parse Commandline.
		If @error Then ; No Commandline To Parse.
			Return __SetHandle($sData, $Global_GUI_1) ; Set Window Title For WM_COPYDATA.
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
			$G_Global_UniqueID = $iMultipleInstances & "_DropIt_MultipleInstance"
			__SetMultipleInstances("+")
			$G_Global_IsMultipleInstance = 1
			Return 1
		EndIf
	EndIf
	Exit
EndFunc   ;==>__SingletonEx

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
	If $G_Global_IsMultipleInstance Then
		$gINISection = $G_Global_UniqueID
	EndIf
	$gReturn[0] = IniRead($gINI, $gINISection, "PosX", "-1")
	$gReturn[1] = IniRead($gINI, $gINISection, "PosY", "-1")
	Return $gReturn
EndFunc   ;==>__GetCurrentPosition

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
	If $G_Global_IsMultipleInstance Then
		$sINISection = $G_Global_UniqueID
	EndIf
	__IniWriteEx($sINI, $sINISection, "PosX", $aWinGetPos[0])
	__IniWriteEx($sINI, $sINISection, "PosY", $aWinGetPos[1])

	Return 1
EndFunc   ;==>__SetCurrentPosition

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

Func __ScriptRestart($sExit = 1) ; Modified From: http://www.autoitscript.com/forum/topic/111215-restart-udf/
	#cs
		Description: Restarts The Running Process.
		Returns: Nothing
	#ce
	Local $sUniqueID = $G_Global_UniqueID
	If WinGetHandle($sUniqueID) = "" Then
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
#EndRegion >>>>> INTERNAL: Various Functions <<<<<
