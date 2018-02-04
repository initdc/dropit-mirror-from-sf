#cs ----------------------------------------------------------------------------
	Application Name: DropIt
	License: Open Source GPL
	Language: English
	AutoIt Version: 3.3.14.2
	Authors: Lupo73, divinity666, guinness
	Website: http://www.dropitproject.com/
	Contact: http://www.lupopensuite.com/contact.htm

	AutoIt3Wrapper Info:
	Icons Added To The Resources Can Be Used With TraySetIcon(@ScriptFullPath, -3) etc. And Are Stored With Numbers -3, -4, -5...
	The Reference Web Page Is http://www.autoitscript.com/autoit3/scite/docs/AutoIt3Wrapper.htm
#ce ----------------------------------------------------------------------------

#NoTrayIcon
#Region ; **** Directives Created By AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Lib\img\Logo.ico
#AutoIt3Wrapper_Outfile=DropIt.exe
#AutoIt3Wrapper_UseUpx=N
#AutoIt3Wrapper_Res_Description=DropIt: Personal Assistant to Automatically Manage Your Files
#AutoIt3Wrapper_Res_Fileversion=8.5.1.0
#AutoIt3Wrapper_Res_ProductVersion=8.5.1.0
#AutoIt3Wrapper_Res_LegalCopyright=Andrea Luparia
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_Field=Website|http://www.dropitproject.com
#AutoIt3Wrapper_Res_Field=E-Mail|comment at the website
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\Custom.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\Info.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\Associations.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\Search.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\Filters.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\Abbreviations.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\Configure.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\List1.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\List2.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\List3.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\List4.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\USB.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\Remove.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\Stop.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\Pause.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\Resume.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\Server.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\Done.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\New.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\Images.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\Favourite.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\Favourite2.ico
#AutoIt3Wrapper_Res_Icon_Add=Lib\img\Open.ico
#AutoIt3Wrapper_Res_File_Add=Images\Default.png, 10, IMAGE
#AutoIt3Wrapper_Res_File_Add=Lib\img\Associations.png, 10, ASSO
#AutoIt3Wrapper_Res_File_Add=Lib\img\Close.png, 10, CLOSE
#AutoIt3Wrapper_Res_File_Add=Lib\img\CopyTo.png, 10, COPYTO
#AutoIt3Wrapper_Res_File_Add=Lib\img\Custom.png, 10, CUST
#AutoIt3Wrapper_Res_File_Add=Lib\img\Delete.png, 10, DEL
#AutoIt3Wrapper_Res_File_Add=Lib\img\Duplicate.png, 10, DUPLICATE
#AutoIt3Wrapper_Res_File_Add=Lib\img\Edit.png, 10, EDIT
#AutoIt3Wrapper_Res_File_Add=Lib\img\Example.png, 10, EXAMP
#AutoIt3Wrapper_Res_File_Add=Lib\img\Export.png, 10, EXPORT
#AutoIt3Wrapper_Res_File_Add=Lib\img\Flags.png, 10, FLAGS
#AutoIt3Wrapper_Res_File_Add=Lib\img\Guide.png, 10, GUIDE
#AutoIt3Wrapper_Res_File_Add=Lib\img\Hide.png, 10, HIDE
#AutoIt3Wrapper_Res_File_Add=Lib\img\Import.png, 10, IMPORT
#AutoIt3Wrapper_Res_File_Add=Lib\img\Info.png, 10, INFO
#AutoIt3Wrapper_Res_File_Add=Lib\img\New.png, 10, NEW
#AutoIt3Wrapper_Res_File_Add=Lib\img\NoFlag.gif, 10, FLAG
#AutoIt3Wrapper_Res_File_Add=Lib\img\Options.png, 10, OPT
#AutoIt3Wrapper_Res_File_Add=Lib\img\Profiles.png, 10, PROF
#AutoIt3Wrapper_Res_File_Add=Lib\img\Progress.png, 10, PROG
#AutoIt3Wrapper_Res_File_Add=Lib\img\Show.png, 10, SHOW
#AutoIt3Wrapper_Res_File_Add=Lib\img\Skip.png, 10, SKIP
#AutoIt3Wrapper_Res_File_Add=Lib\img\Open.png, 10, OPEN
#AutoIt3Wrapper_Run_Au3Stripper=n
#AutoIt3Wrapper_res_requestedExecutionLevel=asInvoker
#EndRegion ; **** Directives Created By AutoIt3Wrapper_GUI ****

#include <Array.au3>
#include <ComboConstants.au3>
#include <Crypt.au3>
#include <Date.au3>
#include <DateTimeConstants.au3>
#include <EditConstants.au3>
#include <Excel.au3>
#include <File.au3>
#include <FTPEx.au3>
#include <GUIButton.au3>
#include <GUIComboBoxEx.au3>
#include <GUIImageList.au3>
#include <GUIListBox.au3>
#include <GUIListView.au3>
#include <GUIMenu.au3>
#include <GUIToolTip.au3>
#include <Misc.au3>
#include <StaticConstants.au3>
#include <String.au3>
#include <WinAPIFiles.au3>
#include <WinAPIProc.au3>
#include <WinAPIShellEx.au3>
#include <WinAPIShPath.au3>
#include <WinAPISys.au3>
#include <WindowsConstants.au3>

#include "DropIt_Abbreviation.au3"
#include "DropIt_Archive.au3"
#include "DropIt_Association.au3"
#include "DropIt_Duplicate.au3"
#include "DropIt_Gallery.au3"
#include "DropIt_General.au3"
#include "DropIt_Global.au3"
#include "DropIt_Image.au3"
#include "DropIt_Instance.au3"
#include "DropIt_List.au3"
#include "DropIt_ProfileList.au3"
#include "DropIt_Update.au3"
#include "DropIt_Upload.au3"
#include "Lib\udf\7ZipRead.au3"
#include "Lib\udf\Copy.au3"
#Include "Lib\udf\DragDropEvent.au3"
#include "Lib\udf\DropIt_LibBounds.au3"
#include "Lib\udf\DropIt_LibCSV.au3"
#include "Lib\udf\DropIt_LibFiles.au3"
#include "Lib\udf\DropIt_LibImages.au3"
#include "Lib\udf\DropIt_LibPlaylist.au3"
#include "Lib\udf\DropIt_LibTrayIcon.au3"
#include "Lib\udf\DropIt_LibVarious.au3"
#include "Lib\udf\HashForFile.au3"
#include "Lib\udf\IconImage.au3"
#include "Lib\udf\ResourcesEx.au3"
#include "Lib\udf\SecureDelete.au3"
#include "Lib\udf\SFTPEx.au3"
#include "Lib\udf\SMTPMailer.au3"
#include "Lib\udf\Startup.au3"
#include "Lib\udf\WM_COPYDATA.au3"
#include "Lib\udf\RDC.au3"

Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1)

Global $Global_GUI_1, $Global_GUI_2, $Global_Icon_1, $Global_GUI_State = 1 ; ImageList & GUI Handles & Icons Handle & GUI State.
Global $Global_ContextMenu[14][2] = [[13, 2]], $Global_TrayMenu[13][2] = [[12, 2]], $Global_MenuDisable = 0 ; ContextMenu & TrayMenu.
Global $Global_ListViewIndex = -1, $Global_ListViewFolders, $Global_ListViewProfiles, $Global_ListViewRules, $Global_ListViewProcess ; ListView Variables.
Global $Global_ListViewProfiles_Enter, $Global_ListViewProfiles_New, $Global_ListViewProfiles_Delete, $Global_ListViewProfiles_Duplicate ; ListView Variables.
Global $Global_ListViewProfiles_Import, $Global_ListViewProfiles_Export, $Global_ListViewProfiles_ImportAll, $Global_ListViewProfiles_ExportAll ; ListView Variables.
Global $Global_ListViewProfiles_Options, $Global_ListViewProfiles_Example[2], $Global_ListViewFolders_Enter, $Global_ListViewFolders_New ; ListView Variables.
Global $Global_ListViewRules_ComboBox, $Global_ListViewRules_ComboBoxChange = 0, $Global_ListViewRules_ItemChange = -1, $Global_ListViewProcess_Open, $Global_ListViewProcess_Info, $Global_ListViewProcess_Skip ; ListView Variables.
Global $Global_ListViewRules_CopyTo, $Global_ListViewRules_Duplicate, $Global_ListViewRules_Delete, $Global_ListViewRules_Enter, $Global_ListViewRules_New, $Global_ListViewFolders_ItemChange = -1 ; ListView Variables.
Global $Global_Monitoring, $Global_MonitoringTimer, $Global_MonitoringSizer, $Global_MonitoringChanges[1], $Global_MonitoringPreviousChanges = "", $Global_GraduallyHide, $Global_GraduallyHideTimer, $Global_GraduallyHideSpeed, $Global_GraduallyHideVisPx ; Misc.
Global $Global_Clipboard, $Global_Wheel, $Global_ScriptRefresh, $Global_ScriptRestart, $Global_ListViewCreateGallery, $Global_ListViewCreateList ; Misc.
Global $Global_NewDroppedFiles, $Global_DroppedFiles[1], $Global_PriorityActions[1], $Global_SendTo_ControlID ; Misc.
Global $Global_AbortButton, $Global_PauseButton ; Process GUI.
Global $Global_ResizeMinWidth, $Global_ResizeMinHeight, $Global_ResizeMaxWidth, $Global_ResizeMaxHeight ; Windows Size For Resizing.
Global $Global_Slider, $Global_SliderLabel ; _Customize_GUI_Edit.
Global $Global_File_Content[1][2]

_WinAPI_EmptyWorkingSet() ; Reduce Memory Usage Of DropIt.
__EnvironmentVariables() ; Set The Standard & User Assigned Environment Variables.
__ExpandEnvStrings(0) ; Disable The Expansion Of Environment Variables.

__Update_Complete() ; Message After DropIt Update.
__Password_GUI() ; Ask Password If In Encrypt Mode.
__Upgrade() ; Upgrade DropIt If Required.
__Update_Check() ; Check If DropIt Has Been Updated.
If __Is("AutoBackup") Then
	__Backup_Restore(-1, 3) ; Create Automatic Backup Of Settings INI File & Profiles Every 3 Days.
EndIf

OnAutoItExitRegister("_ExitEvent")

_GDIPlus_Startup()

_Main()

#Region >>>>> Manage Functions <<<<<
Func _Manage_GUI($mHandle = -1, $mINI = -1)
	Local $mGUI, $mListView, $mListView_Handle, $mMsg, $mNew, $mClose, $mProfileCombo, $mProfileCombo_Handle, $mAssociationName, $mRules, $mAction, $mState, $mDestination
	Local $mIndex_Selected, $mSelectedProfilePath, $mCopyToDummy, $mDuplicateDummy, $mDeleteDummy, $mEnterDummy, $mNewDummy
	Local $mProfilePath = __IsProfile(-1, 1) ; Get Current Profile Path.
	Local $mProfileName = __GetFileNameOnly($mProfilePath)
	Local $mSize = __GetCurrentSize("SizeManage", "460;260;-1;-1") ; Window Width/Height.
	$mINI = __IsSettingsFile($mINI) ; Get Default Settings INI File.

	$mGUI = GUICreate(__GetLang('MANAGE_GUI', 'Manage Associations'), $mSize[1], $mSize[2], $mSize[3], $mSize[4], BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX), -1, __OnTop($mHandle))
	GUISetIcon(@ScriptFullPath, -5, $mGUI) ; Use Associations.ico
	$Global_ResizeMinWidth = 400 ; Set Default Min Width.
	$Global_ResizeMaxWidth = @DesktopWidth ; Set Default Max Width.
	$Global_ResizeMinHeight = 200 ; Set Default Min Height.
	$Global_ResizeMaxHeight = @DesktopHeight ; Set Default Max Height.

	$mListView = GUICtrlCreateListView(__GetLang('NAME', 'Name') & "|" & __GetLang('RULES', 'Rules') & "|" & __GetLang('ACTION', 'Action') & "|" & __GetLang('DESTINATION', 'Destination'), 0, 0, $mSize[1], $mSize[2] - 35, BitOR($LVS_NOSORTHEADER, $LVS_REPORT, $LVS_SINGLESEL))
	$mListView_Handle = GUICtrlGetHandle($mListView)
	$Global_ListViewRules = $mListView_Handle
	GUICtrlSetResizing($mListView, $GUI_DOCKBORDERS)

	_GUICtrlListView_SetExtendedListViewStyle($mListView_Handle, BitOR($LVS_EX_CHECKBOXES, $LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_INFOTIP))
	Local $mColumnSize = __GetCurrentSize("ColumnManage", "130;100;90;115") ; Column Widths.
	For $A = 1 To $mColumnSize[0]
		_GUICtrlListView_SetColumnWidth($mListView_Handle, $A - 1, $mColumnSize[$A])
	Next

	Local $mToolTip = _GUICtrlListView_GetToolTips($mListView_Handle)
	If IsHWnd($mToolTip) Then
		__OnTop($mToolTip, 1)
		_GUIToolTip_SetDelayTime($mToolTip, 3, 60) ; Speed Up InfoTip Appearance.
	EndIf

	_Manage_Populate($mListView_Handle, $mProfileName) ; Add/Update The ListView With The Custom Associations.

	$mCopyToDummy = GUICtrlCreateDummy()
	$Global_ListViewRules_CopyTo = $mCopyToDummy
	$mDuplicateDummy = GUICtrlCreateDummy()
	$Global_ListViewRules_Duplicate = $mDuplicateDummy
	$mDeleteDummy = GUICtrlCreateDummy()
	$Global_ListViewRules_Delete = $mDeleteDummy
	$mEnterDummy = GUICtrlCreateDummy()
	$Global_ListViewRules_Enter = $mEnterDummy
	$mNewDummy = GUICtrlCreateDummy()
	$Global_ListViewRules_New = $mNewDummy

	$mNew = GUICtrlCreateButton("N", 15, $mSize[2] - 31, 70, 25, $BS_ICON)
	GUICtrlSetImage($mNew, @ScriptFullPath, -21, 0)
	GUICtrlSetTip($mNew, __GetLang('NEW', 'New'))
	GUICtrlSetResizing($mNew, $GUI_DOCKSIZE + $GUI_DOCKLEFT + $GUI_DOCKBOTTOM)

	$mProfileCombo = GUICtrlCreateCombo("", 120, $mSize[2] - 29, $mSize[1] - 240, 24, $WS_VSCROLL + $CBS_DROPDOWNLIST)
	$mProfileCombo_Handle = GUICtrlGetHandle($mProfileCombo)
	$Global_ListViewRules_ComboBox = $mProfileCombo_Handle
	GUICtrlSetData($mProfileCombo, __ProfileList_Combo(), $mProfileName)
	GUICtrlSetTip($mProfileCombo, __GetLang('MANAGE_GUI_TIP_1', 'Select a Profile to manage its associations.'))
	GUICtrlSetResizing($mProfileCombo, $GUI_DOCKSIZE + $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM)

	$mClose = GUICtrlCreateButton("C", $mSize[1] - 15 - 70, $mSize[2] - 31, 70, 25, $BS_ICON)
	GUICtrlSetImage($mClose, @ScriptFullPath, -20, 0)
	GUICtrlSetTip($mClose, __GetLang('CLOSE', 'Close'))
	GUICtrlSetResizing($mClose, $GUI_DOCKSIZE + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM)
	GUICtrlSetState($mClose, $GUI_DEFBUTTON)

	$Global_ListViewIndex = -1 ; Set As No Item Selected.
	GUIRegisterMsg($WM_COMMAND, "_WM_COMMAND")
	GUIRegisterMsg($WM_NOTIFY, "_WM_NOTIFY")
	GUIRegisterMsg($WM_GETMINMAXINFO, "_WM_GETMINMAXINFO")
	GUISetState(@SW_SHOW)

	Local $mHotKeys[3][2] = [["^n", $mNewDummy],["{DELETE}", $mDeleteDummy],["{ENTER}", $mEnterDummy]]
	GUISetAccelerators($mHotKeys)

	_WinAPI_EmptyWorkingSet() ; Reduce Memory Usage Of DropIt.
	While 1
		$mIndex_Selected = $Global_ListViewIndex

		If $Global_ListViewRules_ComboBoxChange Then
			$Global_ListViewRules_ComboBoxChange = 0
			$mProfilePath = __IsProfile(GUICtrlRead($mProfileCombo), 1) ; Get Selected Profile Path.
			$mProfileName = __GetFileNameOnly($mProfilePath)
		EndIf

		If $Global_ListViewRules_ItemChange <> -1 Then
			$mAssociationName = _GUICtrlListView_GetItemText($mListView_Handle, $mIndex_Selected)
			$mState = _GUICtrlListView_GetItemChecked($mListView_Handle, $Global_ListViewRules_ItemChange)
			__SetAssociationState($mProfilePath, $mAssociationName, $mState)
			$Global_ListViewRules_ItemChange = -1
		EndIf

		$mMsg = GUIGetMsg()
		Switch $mMsg
			Case $GUI_EVENT_CLOSE, $mClose
				__SetCurrentSize("ColumnManage", $mListView_Handle, 1) ; Column Widths.
				ExitLoop

			Case $mNew, $mNewDummy
				If _Manage_Edit_GUI($mProfileName, -1, -1, -1, -1, -1, $mGUI, 1) = 1 Then ; Show Manage Edit GUI For New Association.
					_Manage_Populate($mListView_Handle, $mProfileName) ; Add/Update The ListView With The Custom Associations.
				EndIf

			Case $mDeleteDummy
				If Not _GUICtrlListView_GetItemState($mListView_Handle, $mIndex_Selected, $LVIS_SELECTED) Then
					ContinueLoop
				EndIf
				$mAssociationName = _GUICtrlListView_GetItemText($mListView_Handle, $mIndex_Selected)
				_Manage_Delete($mProfilePath, $mAssociationName, $mGUI)
				If @error = 0 Then
					_GUICtrlListView_DeleteItem($mListView_Handle, $mIndex_Selected)
				EndIf

			Case $mEnterDummy, $mCopyToDummy, $mDuplicateDummy
				If Not _GUICtrlListView_GetItemState($mListView_Handle, $mIndex_Selected, $LVIS_SELECTED) Then
					ContinueLoop
				EndIf
				$mAssociationName = _GUICtrlListView_GetItemText($mListView_Handle, $mIndex_Selected)
				If $mMsg = $mEnterDummy Then
					$mRules = _GUICtrlListView_GetItemText($mListView_Handle, $mIndex_Selected, 1)
					$mAction = _GUICtrlListView_GetItemText($mListView_Handle, $mIndex_Selected, 2)
					$mDestination = _GUICtrlListView_GetItemText($mListView_Handle, $mIndex_Selected, 3)
					$mState = _GUICtrlListView_GetItemChecked($mListView_Handle, $mIndex_Selected)
					_Manage_Edit_GUI($mProfileName, $mAssociationName, $mRules, $mAction, $mDestination, $mState, $mGUI, 0) ; Show Manage Edit GUI For Selected Association.
					If @error Then
						ContinueLoop
					EndIf
				Else
					$mSelectedProfilePath = $mProfilePath
					If $mMsg = $mCopyToDummy Then
						$mSelectedProfilePath = __ProfileList_GUI() ; Show Profile Selection GUI To Select A Profile From The Profile List.
						If @error Then
							ContinueLoop
						EndIf
						$mSelectedProfilePath = __IsProfile($mSelectedProfilePath, 1) ; Get Selected Profile Path.
					EndIf
					__PasteAssociation($mSelectedProfilePath, $mAssociationName, __IniReadSection($mProfilePath, $mAssociationName))
				EndIf
				_Manage_Populate($mListView_Handle, $mProfileName) ; Add/Update The ListView With The Custom Associations.
				_GUICtrlListView_SetItemSelected($mListView_Handle, $mIndex_Selected, True, True)

		EndSwitch
	WEnd
	$Global_ListViewRules_ComboBoxChange = -1
	__SetCurrentSize("SizeManage", $mGUI) ; Window Width/Height.
	GUIDelete($mGUI)

	__SetCurrentPosition() ; Set Current Coordinates/Position Of DropIt.
	__OnTop($Global_GUI_1) ; Set GUI "OnTop" If True.

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_Manage_GUI

Func _Manage_Edit_GUI($mProfileName = -1, $mAssociationName = -1, $mFileExtension = -1, $mInitialAction = -1, $mDestination = -1, $mState = -1, $mHandle = -1, $mNewAssociation = 0, $mDroppedEvent = 0)
	Local $mGUI, $mFolder, $mSave, $mCancel, $mCurrentActionString, $mAbbreviation, $mListType, $mFilters[$STATIC_FILTERS_NUMBER][3], $mStringFilters, $mChanged = 0
	Local $mInput_Name, $mInput_NameRead, $mInput_Rules, $mInput_RulesRead, $mButton_Rules, $mButton_Filters, $mButton_Abbreviations, $mCombo_Action, $mTempString
	Local $mLabel_Destination, $mInput_Destination, $mInput_DestinationRead, $mButton_Destination, $mCombo_Delete, $mRename, $mInput_Rename, $mClipboard, $mInput_Clipboard
	Local $mSite, $mInput_Site, $mButton_Site, $mSiteSettings, $mList, $mInput_List, $mButton_List, $mListName, $mListProperties, $mHTMLTheme, $mListSettings, $mInput_Current
	Local $mCrypt, $mInput_Crypt, $mButton_Crypt, $mCryptSettings, $mButton_Change, $mFileProperties, $mButton_Mail, $mMailSettings, $mStringSplit, $mNoOthers, $mCheck_Favourite
	Local $mCompress, $mInput_Compress, $mButton_Compress, $mCompressSettings, $mCompressFormat, $mCompressFormatBis
	Local $mExtract, $mInput_Extract, $mButton_Extract, $mExtractSettings, $mJoin, $mInput_Join, $mButton_Join, $mJoinSettings
	Local $mOpenWith, $mInput_OpenWith, $mButton_OpenWith, $mOpenWithSettings, $mSplit, $mInput_Split, $mButton_Split, $mSplitSettings = "10;MB;False"
	Local $mInput_Ignore, $mGallery, $mInput_Gallery, $mButton_Gallery, $mGalleryProperties, $mGalleryTheme, $mGallerySettings = "2;1;", $mInput_Print

	Local $mAssociationType = __GetLang('MANAGE_ASSOCIATION_NEW', 'New Association')
	Local $mLogAssociation = __GetLang('MANAGE_LOG_0', 'Association Created')
	Local $mDestinationString = __GetLang('MANAGE_EDIT_TIP_2', 'As destination are supported absolute, relative and UNC paths.')
	Local $mConfigString = __GetLang('MANAGE_EDIT_MSGBOX_12', 'Configure')
	Local $mRename_Default = "%FileName%.%FileExt%", $mClipboard_Default = "%FileNameExt%"
	Local $mProfile = __IsProfile($mProfileName, 0) ; Get Array Of Current Profile.

	If $mAssociationName = -1 Then
		$mAssociationName = ""
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
	Local $mFavouriteAssociation = __GetAssociationField($mProfile[0], $mAssociationName, "FavouriteAssociation")
	Local $mUseRegEx =  __GetAssociationField($mProfile[0], $mAssociationName, "UseRegEx")
	Local $mInput_RuleData = $mFileExtension, $mCurrentAction = $mInitialAction, $mCurrentDelete = __GetLang('DELETE_MODE_1', 'Directly Remove')
	Local $mCombo_ActionData = __GetLang('ACTION_MOVE', 'Move') & '|' & __GetLang('ACTION_COPY', 'Copy') & '|' & __GetLang('ACTION_COMPRESS', 'Compress') & '|' & _
			__GetLang('ACTION_EXTRACT', 'Extract') & '|' & __GetLang('ACTION_RENAME', 'Rename') & '|' & __GetLang('ACTION_DELETE', 'Delete') & '|' & _
			__GetLang('ACTION_SPLIT', 'Split') & '|' & __GetLang('ACTION_JOIN', 'Join') & '|' & __GetLang('ACTION_ENCRYPT', 'Encrypt') & '|' & __GetLang('ACTION_DECRYPT', 'Decrypt') & '|' & _
			__GetLang('ACTION_OPEN_WITH', 'Open With') & '|' & __GetLang('ACTION_PRINT', 'Print') & "|" & __GetLang('ACTION_UPLOAD', 'Upload') & '|' & __GetLang('ACTION_SEND_MAIL', 'Send by Mail') & '|' & _
			__GetLang('ACTION_GALLERY', 'Create Gallery') & '|' & __GetLang('ACTION_LIST', 'Create List') & '|' & __GetLang('ACTION_PLAYLIST', 'Create Playlist') & '|' & _
			__GetLang('ACTION_SHORTCUT', 'Create Shortcut') & '|' & __GetLang('ACTION_CLIPBOARD', 'Copy to Clipboard') & '|' & _
			__GetLang('ACTION_CHANGE_PROPERTIES', 'Change Properties') & '|' & __GetLang('ACTION_IGNORE', 'Ignore')
	Local $mCombo_DeleteData = __GetLang('DELETE_MODE_1', 'Directly Remove') & '|' & __GetLang('DELETE_MODE_2', 'Safely Erase') & '|' & __GetLang('DELETE_MODE_3', 'Send to Recycle Bin')
	Local $mDestination_Label[11] = [ _
			__GetLang('MANAGE_DESTINATION_FOLDER', 'Destination Folder'), _
			__GetLang('MANAGE_DESTINATION_PROGRAM', 'Destination Program'), _
			__GetLang('MANAGE_DESTINATION_FILE', 'Destination File'), _
			__GetLang('MANAGE_DESTINATION_ARCHIVE', 'Destination Archive'), _
			__GetLang('MANAGE_NEW_NAME', 'New Name'), _
			__GetLang('MANAGE_DELETE_MODE', 'Deletion Mode'), _
			__GetLang('MANAGE_CLIPBOARD_TEXT', 'Clipboard Text'), _
			__GetLang('MANAGE_REMOTE_DESTINATION', 'Remote Destination'), _
			__GetLang('MANAGE_NEW_PROPERTIES', 'New Properties'), _
			__GetLang('MANAGE_MAIL_SETTINGS', 'Mail Settings'), _
			__GetLang('DESTINATION', 'Destination')]
	For $A = 0 To 10
		$mDestination_Label[$A] = "4. " & $mDestination_Label[$A] & ":"
	Next

	If $mInitialAction == __GetLang('ACTION_COMPRESS', 'Compress') Then
		$mCompressSettings = __GetAssociationField($mProfile[0], $mAssociationName, "CompressSettings")
		$mCompressSettings = __GetDefaultCompressSettings($mCompressSettings, $mDestination)
		$mStringSplit = StringSplit($mCompressSettings, ";") ; Only To Get 2 = Compress Format.
		$mCompressFormat = $mStringSplit[2]
		$mCompress = $mDestination
		$mDestination = "-"
	Else
		$mCompressSettings = __GetDefaultCompressSettings()
		$mCompressFormat = "zip"
		$mCompress = "-"
	EndIf
	If $mInitialAction == __GetLang('ACTION_EXTRACT', 'Extract') Then
		$mExtractSettings = __GetAssociationField($mProfile[0], $mAssociationName, "ExtractSettings")
		$mExtract = $mDestination
		$mDestination = "-"
	Else
		$mExtract = "-"
	EndIf
	If $mInitialAction == __GetLang('ACTION_OPEN_WITH', 'Open With') Then
		$mOpenWithSettings = __GetAssociationField($mProfile[0], $mAssociationName, "OpenWithSettings")
		$mOpenWith = $mDestination
		$mDestination = "-"
	Else
		$mOpenWith = "%DefaultProgram%"
	EndIf
	If $mInitialAction == __GetLang('ACTION_RENAME', 'Rename') Then
		$mRename = $mDestination
		$mDestination = "-"
	Else
		$mRename = $mRename_Default
	EndIf
	If $mInitialAction == __GetLang('ACTION_CLIPBOARD', 'Copy to Clipboard') Then
		$mClipboard = $mDestination
		$mDestination = "-"
	Else
		$mClipboard = $mClipboard_Default
	EndIf
	If $mInitialAction == __GetLang('ACTION_ENCRYPT', 'Encrypt') Or $mInitialAction == __GetLang('ACTION_DECRYPT', 'Decrypt') Then
		$mCryptSettings = __GetAssociationField($mProfile[0], $mAssociationName, "CryptSettings")
		$mCrypt = $mDestination
		$mDestination = "-"
	Else
		$mCryptSettings = "-"
		$mCrypt = "%ParentDir%"
	EndIf
	If $mInitialAction == __GetLang('ACTION_CHANGE_PROPERTIES', 'Change Properties') Then
		$mFileProperties = __GetAssociationField($mProfile[0], $mAssociationName, "Destination")
		$mDestination = "-"
	Else
		$mFileProperties = "-"
	EndIf
	If $mInitialAction == __GetLang('ACTION_SEND_MAIL', 'Send by Mail') Then
		$mMailSettings = __GetAssociationField($mProfile[0], $mAssociationName, "Destination")
		$mDestination = "-"
	Else
		$mMailSettings = "-"
	EndIf
	If $mInitialAction == __GetLang('ACTION_GALLERY', 'Create Gallery') Then
		$mGalleryProperties = __GetAssociationField($mProfile[0], $mAssociationName, "GalleryProperties")
		$mGalleryTheme = __GetAssociationField($mProfile[0], $mAssociationName, "GalleryTheme")
		$mGallerySettings = __GetAssociationField($mProfile[0], $mAssociationName, "GallerySettings")
		$mGallery = $mDestination
		$mDestination = "-"
	Else
		$mGallery = "-"
	EndIf
	If $mInitialAction == __GetLang('ACTION_LIST', 'Create List') Then
		$mListProperties = __GetAssociationField($mProfile[0], $mAssociationName, "ListProperties")
		$mHTMLTheme = __GetAssociationField($mProfile[0], $mAssociationName, "HTMLTheme")
		$mListSettings = __GetAssociationField($mProfile[0], $mAssociationName, "ListSettings")
		$mList = $mDestination
		$mDestination = "-"
		If StringIsDigit(StringReplace($mListProperties, ";", "")) Then
			$mListProperties = __ConvertListProperties($mListProperties, $mProfile[1], $mAssociationName)
		EndIf
	Else
		$mList = "-"
	EndIf
	If $mInitialAction == __GetLang('ACTION_SPLIT', 'Split') Then
		$mSplitSettings = __GetAssociationField($mProfile[0], $mAssociationName, "SplitSettings")
		$mSplit = $mDestination
		$mDestination = "-"
	Else
		$mSplit = "-"
	EndIf
	If $mInitialAction == __GetLang('ACTION_JOIN', 'Join') Then
		$mJoinSettings = __GetAssociationField($mProfile[0], $mAssociationName, "JoinSettings")
		$mJoin = $mDestination
		$mDestination = "-"
	Else
		$mJoin = "-"
	EndIf
	If $mInitialAction == __GetLang('ACTION_UPLOAD', 'Upload') Then
		$mSiteSettings = __GetAssociationField($mProfile[0], $mAssociationName, "SiteSettings")
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
			$mFilters = _Manage_ExtractFilters($mProfile[0], $mAssociationName, $mFilters)
		Case $mNewAssociation = 1 And $mDroppedEvent = 1
			$mInput_RuleData = "**"
			If $mFileExtension <> "" Then
				$mInput_RuleData = "*." & $mFileExtension ; $mFileExtension = "" If Loaded Item Is A Folder.
			EndIf
	EndSelect

	$mGUI = GUICreate($mAssociationType & " [" & __GetLang('PROFILE', 'Profile') & ": " & $mProfile[1] & "]", 460, 320, -1, -1, -1, BitOR($WS_EX_ACCEPTFILES, $WS_EX_TOOLWINDOW), __OnTop($mHandle))

	; Section 1:
	GUICtrlCreateLabel("1. " & __GetLang('NAME', 'Name') & ":", 15, 12, 360, 20)
	$mInput_Name = GUICtrlCreateInput($mAssociationName, 10, 32, 399, 22)
	GUICtrlSetTip($mInput_Name, __GetLang('MANAGE_EDIT_TIP_0', 'Choose a name for this association.'))
	$mCheck_Favourite = GUICtrlCreateIcon(@ScriptFullPath, -24, 10 + 414, 34, 16, 16)
	GUICtrlSetTip($mCheck_Favourite, __GetLang('MANAGE_EDIT_TIP_8', 'To give priority to this association in case of multiple matches.'), __GetLang('MANAGE_EDIT_TIP_7', 'Favourite Association'), 0)
	GUICtrlSetCursor($mCheck_Favourite, 0)

	; Section 2:
	GUICtrlCreateLabel("2. " & __GetLang('RULES', 'Rules') & ":", 15, 65 + 12, 360, 20)
	$mInput_Rules = GUICtrlCreateInput($mInput_RuleData, 10, 65 + 32, 358, 22)
	GUICtrlSetTip($mInput_Rules, __GetLang('MANAGE_EDIT_TIP_1', 'Write rules to define what process by name, extension and path.'))
	$mButton_Rules = GUICtrlCreateButton("i", 10 + 363, 65 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Rules, __GetLang('MANAGE_EDIT_MSGBOX_28', 'Rule Settings'))
	GUICtrlSetImage($mButton_Rules, @ScriptFullPath, -4, 0)
	$mButton_Filters = GUICtrlCreateButton("F", 10 + 404, 65 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Filters, __GetLang('ADDITIONAL_FILTERS', 'Additional Filters'))
	GUICtrlSetImage($mButton_Filters, @ScriptFullPath, -7, 0)

	; Section 3:
	GUICtrlCreateLabel("3. " & __GetLang('ACTION', 'Action') & ":", 15, 65 * 2 + 12, 360, 20)
	$mCombo_Action = GUICtrlCreateCombo("", 10, 65 * 2 + 32, 440, 22, $WS_VSCROLL + $CBS_DROPDOWNLIST)

	; Section 4:
	$mLabel_Destination = GUICtrlCreateLabel($mDestination_Label[0], 15, 65 * 3 + 12, 360, 20)
	$mInput_Destination = GUICtrlCreateInput($mDestination, 10, 65 * 3 + 32, 358, 22)
	GUICtrlSetTip($mInput_Destination, $mDestinationString)
	GUICtrlSetState($mInput_Destination, $GUI_DROPACCEPTED)
	$mButton_Destination = GUICtrlCreateButton("S", 10 + 363, 65 * 3 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Destination, __GetLang('SEARCH', 'Search'))
	GUICtrlSetImage($mButton_Destination, @ScriptFullPath, -6, 0)
	$mInput_Compress = GUICtrlCreateInput($mCompress, 10 + 40, 65 * 3 + 32, 318, 22)
	GUICtrlSetTip($mInput_Compress, $mDestinationString)
	$mButton_Compress = GUICtrlCreateButton("C", 10, 65 * 3 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Compress, $mConfigString)
	GUICtrlSetImage($mButton_Compress, @ScriptFullPath, -9, 0)
	$mInput_Extract = GUICtrlCreateInput($mExtract, 10 + 40, 65 * 3 + 32, 318, 22)
	GUICtrlSetTip($mInput_Extract, $mDestinationString)
	$mButton_Extract = GUICtrlCreateButton("C", 10, 65 * 3 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Extract, $mConfigString)
	GUICtrlSetImage($mButton_Extract, @ScriptFullPath, -9, 0)
	$mInput_Split = GUICtrlCreateInput($mSplit, 10 + 40, 65 * 3 + 32, 318, 22)
	GUICtrlSetTip($mInput_Split, $mDestinationString)
	$mButton_Split = GUICtrlCreateButton("C", 10, 65 * 3 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Split, $mConfigString)
	GUICtrlSetImage($mButton_Split, @ScriptFullPath, -9, 0)
	$mInput_Join = GUICtrlCreateInput($mJoin, 10 + 40, 65 * 3 + 32, 318, 22)
	GUICtrlSetTip($mInput_Join, $mDestinationString)
	$mButton_Join = GUICtrlCreateButton("C", 10, 65 * 3 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Join, $mConfigString)
	GUICtrlSetImage($mButton_Join, @ScriptFullPath, -9, 0)
	$mInput_OpenWith = GUICtrlCreateInput($mOpenWith, 10 + 40, 65 * 3 + 32, 318, 22)
	GUICtrlSetTip($mInput_OpenWith, $mDestinationString)
	$mButton_OpenWith = GUICtrlCreateButton("C", 10, 65 * 3 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_OpenWith, $mConfigString)
	GUICtrlSetImage($mButton_OpenWith, @ScriptFullPath, -9, 0)
	$mInput_Site = GUICtrlCreateInput($mSite, 10 + 40, 65 * 3 + 32, 358, 22)
	GUICtrlSetTip($mInput_Site, __GetLang('MANAGE_EDIT_TIP_6', 'Define the remote destination directory.'))
	$mButton_Site = GUICtrlCreateButton("C", 10, 65 * 3 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Site, $mConfigString)
	GUICtrlSetImage($mButton_Site, @ScriptFullPath, -9, 0)
	$mInput_Rename = GUICtrlCreateInput($mRename, 10, 65 * 3 + 32, 399, 22)
	GUICtrlSetTip($mInput_Rename, __GetLang('MANAGE_EDIT_TIP_4', 'Define the new filename and also a directory if you want to move it.'))
	$mInput_Clipboard = GUICtrlCreateInput($mClipboard, 10, 65 * 3 + 32, 399, 22)
	GUICtrlSetTip($mInput_Clipboard, __GetLang('MANAGE_EDIT_TIP_3', 'Define what copy to the Clipboard for this association.'))
	$mInput_Gallery = GUICtrlCreateInput($mGallery, 10 + 40, 65 * 3 + 32, 318, 22)
	GUICtrlSetTip($mInput_Gallery, $mDestinationString)
	$mButton_Gallery = GUICtrlCreateButton("C", 10, 65 * 3 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Gallery, $mConfigString)
	GUICtrlSetImage($mButton_Gallery, @ScriptFullPath, -9, 0)
	$mInput_List = GUICtrlCreateInput($mList, 10 + 40, 65 * 3 + 32, 318, 22)
	GUICtrlSetTip($mInput_List, $mDestinationString)
	$mButton_List = GUICtrlCreateButton("C", 10, 65 * 3 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_List, $mConfigString)
	GUICtrlSetImage($mButton_List, @ScriptFullPath, -9, 0)
	$mInput_Crypt = GUICtrlCreateInput($mCrypt, 10 + 40, 65 * 3 + 32, 318, 22)
	GUICtrlSetTip($mInput_Crypt, $mDestinationString)
	$mButton_Crypt = GUICtrlCreateButton("C", 10, 65 * 3 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Crypt, $mConfigString)
	GUICtrlSetImage($mButton_Crypt, @ScriptFullPath, -9, 0)
	$mCombo_Delete = GUICtrlCreateCombo("", 10, 65 * 3 + 32, 440, 22, $WS_VSCROLL + $CBS_DROPDOWNLIST)
	GUICtrlSetTip($mCombo_Delete, __GetLang('MANAGE_EDIT_TIP_5', 'Select the deletion mode for this association.'))
	$mButton_Abbreviations = GUICtrlCreateButton("A", 10 + 404, 65 * 3 + 30, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Abbreviations, __GetLang('MANAGE_EDIT_MSGBOX_8', 'Abbreviations'))
	GUICtrlSetImage($mButton_Abbreviations, @ScriptFullPath, -8, 0)
	$mButton_Change = GUICtrlCreateButton(__GetLang('MANAGE_EDIT_CONFIGURE', 'Configure this action'), 10, 65 * 3 + 30, 440, 25)
	$mButton_Mail = GUICtrlCreateButton(__GetLang('MANAGE_EDIT_CONFIGURE', 'Configure this action'), 10, 65 * 3 + 30, 440, 25)
	$mInput_Ignore = GUICtrlCreateInput(__GetLang('MANAGE_EDIT_MSGBOX_15', 'Skip them during process'), 10, 65 * 3 + 32, 440, 22)
	$mInput_Print = GUICtrlCreateInput(__GetLang('MANAGE_EDIT_MSGBOX_55', 'This action does not provide a destination.'), 10, 65 * 3 + 32, 440, 22)

	GUICtrlSetState($mInput_Print, $GUI_DISABLE + $GUI_HIDE) ; Always Disabled In The Code.
	GUICtrlSetState($mInput_Ignore, $GUI_DISABLE + $GUI_HIDE) ; Always Disabled In The Code.
	GUICtrlSetState($mInput_Destination, $GUI_HIDE)
	GUICtrlSetState($mInput_Compress, $GUI_HIDE)
	GUICtrlSetState($mButton_Compress, $GUI_HIDE)
	GUICtrlSetState($mInput_Extract, $GUI_HIDE)
	GUICtrlSetState($mButton_Extract, $GUI_HIDE)
	GUICtrlSetState($mInput_Split, $GUI_HIDE)
	GUICtrlSetState($mButton_Split, $GUI_HIDE)
	GUICtrlSetState($mInput_Join, $GUI_HIDE)
	GUICtrlSetState($mButton_Join, $GUI_HIDE)
	GUICtrlSetState($mInput_OpenWith, $GUI_HIDE)
	GUICtrlSetState($mButton_OpenWith, $GUI_HIDE)
	GUICtrlSetState($mButton_Change, $GUI_HIDE)
	GUICtrlSetState($mButton_Mail, $GUI_HIDE)
	GUICtrlSetState($mInput_Rename, $GUI_HIDE)
	GUICtrlSetState($mInput_Clipboard, $GUI_HIDE)
	GUICtrlSetState($mInput_Site, $GUI_HIDE)
	GUICtrlSetState($mButton_Site, $GUI_HIDE)
	GUICtrlSetState($mInput_Crypt, $GUI_HIDE)
	GUICtrlSetState($mButton_Crypt, $GUI_HIDE)
	GUICtrlSetState($mInput_Gallery, $GUI_HIDE)
	GUICtrlSetState($mButton_Gallery, $GUI_HIDE)
	GUICtrlSetState($mInput_List, $GUI_HIDE)
	GUICtrlSetState($mButton_List, $GUI_HIDE)
	GUICtrlSetState($mCombo_Delete, $GUI_HIDE)
	Switch $mCurrentAction
		Case __GetLang('ACTION_IGNORE', 'Ignore')
			GUICtrlSetState($mInput_Ignore, $GUI_SHOW)
			GUICtrlSetState($mButton_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Abbreviations, $GUI_HIDE)
			GUICtrlSetData($mInput_Destination, "-")
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[10])
		Case __GetLang('ACTION_CHANGE_PROPERTIES', 'Change Properties')
			GUICtrlSetState($mButton_Change, $GUI_SHOW)
			GUICtrlSetState($mButton_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Abbreviations, $GUI_HIDE)
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[8])
		Case __GetLang('ACTION_SEND_MAIL', 'Send by Mail')
			GUICtrlSetState($mButton_Mail, $GUI_SHOW)
			GUICtrlSetState($mButton_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Abbreviations, $GUI_HIDE)
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[9])
		Case __GetLang('ACTION_OPEN_WITH', 'Open With')
			GUICtrlSetState($mInput_OpenWith, $GUI_SHOW)
			GUICtrlSetState($mButton_OpenWith, $GUI_SHOW)
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[1])
		Case __GetLang('ACTION_PLAYLIST', 'Create Playlist')
			GUICtrlSetState($mInput_Destination, $GUI_SHOW)
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[2])
		Case __GetLang('ACTION_COMPRESS', 'Compress')
			GUICtrlSetState($mInput_Compress, $GUI_SHOW)
			GUICtrlSetState($mButton_Compress, $GUI_SHOW)
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[3])
		Case __GetLang('ACTION_EXTRACT', 'Extract')
			GUICtrlSetState($mInput_Extract, $GUI_SHOW)
			GUICtrlSetState($mButton_Extract, $GUI_SHOW)
		Case __GetLang('ACTION_SPLIT', 'Split')
			GUICtrlSetState($mInput_Split, $GUI_SHOW)
			GUICtrlSetState($mButton_Split, $GUI_SHOW)
		Case __GetLang('ACTION_JOIN', 'Join')
			GUICtrlSetState($mInput_Join, $GUI_SHOW)
			GUICtrlSetState($mButton_Join, $GUI_SHOW)
		Case __GetLang('ACTION_ENCRYPT', 'Encrypt'), __GetLang('ACTION_DECRYPT', 'Decrypt')
			GUICtrlSetState($mInput_Crypt, $GUI_SHOW)
			GUICtrlSetState($mButton_Crypt, $GUI_SHOW)
		Case __GetLang('ACTION_GALLERY', 'Create Gallery')
			GUICtrlSetState($mInput_Gallery, $GUI_SHOW)
			GUICtrlSetState($mButton_Gallery, $GUI_SHOW)
		Case __GetLang('ACTION_LIST', 'Create List')
			GUICtrlSetState($mInput_List, $GUI_SHOW)
			GUICtrlSetState($mButton_List, $GUI_SHOW)
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[2])
		Case __GetLang('ACTION_RENAME', 'Rename')
			GUICtrlSetState($mButton_Destination, $GUI_HIDE)
			GUICtrlSetState($mInput_Rename, $GUI_SHOW)
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[4])
		Case __GetLang('ACTION_PRINT', 'Print')
			GUICtrlSetState($mInput_Print, $GUI_SHOW)
			GUICtrlSetState($mButton_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Abbreviations, $GUI_HIDE)
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[10])
		Case __GetLang('ACTION_CLIPBOARD', 'Copy to Clipboard')
			GUICtrlSetState($mButton_Destination, $GUI_HIDE)
			GUICtrlSetState($mInput_Clipboard, $GUI_SHOW)
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[6])
		Case __GetLang('ACTION_UPLOAD', 'Upload')
			GUICtrlSetState($mButton_Destination, $GUI_HIDE)
			GUICtrlSetState($mInput_Site, $GUI_SHOW)
			GUICtrlSetState($mButton_Site, $GUI_SHOW)
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[7])
		Case __GetLang('ACTION_DELETE', 'Delete')
			GUICtrlSetState($mButton_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Abbreviations, $GUI_HIDE)
			GUICtrlSetState($mCombo_Delete, $GUI_SHOW)
			$mCurrentDelete = $mDestination
			GUICtrlSetData($mInput_Destination, "-")
			GUICtrlSetData($mLabel_Destination, $mDestination_Label[5])
		Case Else
			GUICtrlSetState($mInput_Destination, $GUI_SHOW)
	EndSwitch
	GUICtrlSetData($mCombo_Action, $mCombo_ActionData, $mCurrentAction)
	GUICtrlSetData($mCombo_Delete, $mCombo_DeleteData, $mCurrentDelete)
	If $mFavouriteAssociation == "True" Then
		GUICtrlSetImage($mCheck_Favourite, @ScriptFullPath, -23) ; Favourite.
	EndIf

	$mSave = GUICtrlCreateButton(__GetLang('SAVE', 'Save'), 230 - 60 - 90, 280, 90, 26)
	$mCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 230 + 60, 280, 90, 26)
	GUICtrlSetState($mSave, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)
	ControlClick($mGUI, "", $mInput_Name)

	While 1
		; Enable/Disable Destination Input And Switch Folder/Program Label:
		If GUICtrlRead($mCombo_Action) <> $mCurrentAction And _GUICtrlComboBox_GetDroppedState($mCombo_Action) = False Then
			GUICtrlSetState($mInput_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Destination, $GUI_HIDE)
			GUICtrlSetState($mButton_Abbreviations, $GUI_HIDE)
			GUICtrlSetState($mInput_Compress, $GUI_HIDE)
			GUICtrlSetState($mButton_Compress, $GUI_HIDE)
			GUICtrlSetState($mInput_Extract, $GUI_HIDE)
			GUICtrlSetState($mButton_Extract, $GUI_HIDE)
			GUICtrlSetState($mInput_Split, $GUI_HIDE)
			GUICtrlSetState($mButton_Split, $GUI_HIDE)
			GUICtrlSetState($mInput_Join, $GUI_HIDE)
			GUICtrlSetState($mButton_Join, $GUI_HIDE)
			GUICtrlSetState($mInput_OpenWith, $GUI_HIDE)
			GUICtrlSetState($mButton_OpenWith, $GUI_HIDE)
			GUICtrlSetState($mInput_Rename, $GUI_HIDE)
			GUICtrlSetState($mInput_Clipboard, $GUI_HIDE)
			GUICtrlSetState($mButton_Change, $GUI_HIDE)
			GUICtrlSetState($mButton_Mail, $GUI_HIDE)
			GUICtrlSetState($mInput_Print, $GUI_HIDE)
			GUICtrlSetState($mInput_Ignore, $GUI_HIDE)
			GUICtrlSetState($mInput_Site, $GUI_HIDE)
			GUICtrlSetState($mButton_Site, $GUI_HIDE)
			GUICtrlSetState($mInput_Crypt, $GUI_HIDE)
			GUICtrlSetState($mButton_Crypt, $GUI_HIDE)
			GUICtrlSetState($mInput_Gallery, $GUI_HIDE)
			GUICtrlSetState($mButton_Gallery, $GUI_HIDE)
			GUICtrlSetState($mInput_List, $GUI_HIDE)
			GUICtrlSetState($mButton_List, $GUI_HIDE)
			GUICtrlSetState($mCombo_Delete, $GUI_HIDE)
			If GUICtrlRead($mInput_Destination) == "" Then
				GUICtrlSetData($mInput_Destination, "-")
			EndIf
			If GUICtrlRead($mInput_Compress) == "" Then
				GUICtrlSetData($mInput_Compress, "-")
			EndIf
			If GUICtrlRead($mInput_Extract) == "" Then
				GUICtrlSetData($mInput_Extract, "-")
			EndIf
			If GUICtrlRead($mInput_Split) == "" Then
				GUICtrlSetData($mInput_Split, "-")
			EndIf
			If GUICtrlRead($mInput_Join) == "" Then
				GUICtrlSetData($mInput_Join, "-")
			EndIf
			If GUICtrlRead($mInput_OpenWith) == "" Then
				GUICtrlSetData($mInput_OpenWith, "-")
			EndIf
			If GUICtrlRead($mInput_Rename) == "" Then
				GUICtrlSetData($mInput_Rename, $mRename_Default)
			EndIf
			If GUICtrlRead($mInput_Clipboard) == "" Then
				GUICtrlSetData($mInput_Clipboard, $mClipboard_Default)
			EndIf
			If GUICtrlRead($mInput_Site) == "" Then
				GUICtrlSetData($mInput_Site, "/")
			EndIf
			If GUICtrlRead($mInput_Crypt) == "" Then
				GUICtrlSetData($mInput_Crypt, "-")
			EndIf
			If GUICtrlRead($mInput_Gallery) == "" Then
				GUICtrlSetData($mInput_Gallery, "-")
			EndIf
			If GUICtrlRead($mInput_List) == "" Then
				GUICtrlSetData($mInput_List, "-")
			EndIf
			If $mFileProperties = "" Then
				$mFileProperties = "-"
			EndIf
			If $mCryptSettings = "" Then
				$mCryptSettings = "-"
			EndIf
			If $mMailSettings = "" Then
				$mMailSettings = "-"
			EndIf
			$mCurrentAction = GUICtrlRead($mCombo_Action)
			Switch $mCurrentAction
				Case __GetLang('ACTION_DELETE', 'Delete')
					GUICtrlSetState($mCombo_Delete, $GUI_SHOW)
				Case __GetLang('ACTION_IGNORE', 'Ignore')
					GUICtrlSetState($mInput_Ignore, $GUI_SHOW)
				Case __GetLang('ACTION_RENAME', 'Rename')
					GUICtrlSetState($mInput_Rename, $GUI_SHOW)
					GUICtrlSetState($mButton_Abbreviations, $GUI_SHOW)
				Case __GetLang('ACTION_PRINT', 'Print')
					GUICtrlSetState($mInput_Print, $GUI_SHOW)
				Case __GetLang('ACTION_CLIPBOARD', 'Copy to Clipboard')
					GUICtrlSetState($mInput_Clipboard, $GUI_SHOW)
					GUICtrlSetState($mButton_Abbreviations, $GUI_SHOW)
				Case __GetLang('ACTION_UPLOAD', 'Upload')
					GUICtrlSetState($mInput_Site, $GUI_SHOW)
					GUICtrlSetState($mButton_Site, $GUI_SHOW)
					GUICtrlSetState($mButton_Abbreviations, $GUI_SHOW)
				Case __GetLang('ACTION_CHANGE_PROPERTIES', 'Change Properties')
					If $mFileProperties = "-" Then
						$mFileProperties = ""
					EndIf
					GUICtrlSetState($mButton_Change, $GUI_SHOW)
				Case __GetLang('ACTION_SEND_MAIL', 'Send by Mail')
					If $mMailSettings = "-" Then
						$mMailSettings = ""
					EndIf
					GUICtrlSetState($mButton_Mail, $GUI_SHOW)
				Case __GetLang('ACTION_COMPRESS', 'Compress')
					If GUICtrlRead($mInput_Compress) == "-" Then
						GUICtrlSetData($mInput_Compress, "")
					EndIf
					GUICtrlSetState($mButton_Destination, $GUI_SHOW)
					GUICtrlSetState($mInput_Compress, $GUI_SHOW)
					GUICtrlSetState($mButton_Compress, $GUI_SHOW)
					GUICtrlSetState($mButton_Abbreviations, $GUI_SHOW)
				Case __GetLang('ACTION_EXTRACT', 'Extract')
					If GUICtrlRead($mInput_Extract) == "-" Then
						GUICtrlSetData($mInput_Extract, "")
					EndIf
					GUICtrlSetState($mButton_Destination, $GUI_SHOW)
					GUICtrlSetState($mInput_Extract, $GUI_SHOW)
					GUICtrlSetState($mButton_Extract, $GUI_SHOW)
					GUICtrlSetState($mButton_Abbreviations, $GUI_SHOW)
				Case __GetLang('ACTION_SPLIT', 'Split')
					If GUICtrlRead($mInput_Split) == "-" Then
						GUICtrlSetData($mInput_Split, "")
					EndIf
					GUICtrlSetState($mButton_Destination, $GUI_SHOW)
					GUICtrlSetState($mInput_Split, $GUI_SHOW)
					GUICtrlSetState($mButton_Split, $GUI_SHOW)
					GUICtrlSetState($mButton_Abbreviations, $GUI_SHOW)
				Case __GetLang('ACTION_JOIN', 'Join')
					If GUICtrlRead($mInput_Join) == "-" Then
						GUICtrlSetData($mInput_Join, "")
					EndIf
					GUICtrlSetState($mButton_Destination, $GUI_SHOW)
					GUICtrlSetState($mInput_Join, $GUI_SHOW)
					GUICtrlSetState($mButton_Join, $GUI_SHOW)
					GUICtrlSetState($mButton_Abbreviations, $GUI_SHOW)
				Case __GetLang('ACTION_OPEN_WITH', 'Open With')
					If GUICtrlRead($mInput_OpenWith) == "-" Then
						GUICtrlSetData($mInput_OpenWith, "")
					EndIf
					GUICtrlSetState($mButton_Destination, $GUI_SHOW)
					GUICtrlSetState($mInput_OpenWith, $GUI_SHOW)
					GUICtrlSetState($mButton_OpenWith, $GUI_SHOW)
					GUICtrlSetState($mButton_Abbreviations, $GUI_SHOW)
				Case __GetLang('ACTION_ENCRYPT', 'Encrypt'), __GetLang('ACTION_DECRYPT', 'Decrypt')
					If $mCryptSettings = "-" Then
						$mCryptSettings = ""
					EndIf
					If GUICtrlRead($mInput_Crypt) == "-" Then
						GUICtrlSetData($mInput_Crypt, "")
					EndIf
					GUICtrlSetState($mButton_Destination, $GUI_SHOW)
					GUICtrlSetState($mInput_Crypt, $GUI_SHOW)
					GUICtrlSetState($mButton_Crypt, $GUI_SHOW)
					GUICtrlSetState($mButton_Abbreviations, $GUI_SHOW)
				Case __GetLang('ACTION_GALLERY', 'Create Gallery')
					If GUICtrlRead($mInput_Gallery) == "-" Then
						GUICtrlSetData($mInput_Gallery, "")
					EndIf
					GUICtrlSetState($mButton_Destination, $GUI_SHOW)
					GUICtrlSetState($mInput_Gallery, $GUI_SHOW)
					GUICtrlSetState($mButton_Gallery, $GUI_SHOW)
					GUICtrlSetState($mButton_Abbreviations, $GUI_SHOW)
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
					GUICtrlSetData($mLabel_Destination, $mDestination_Label[10])
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
				Case __GetLang('ACTION_SEND_MAIL', 'Send by Mail')
					GUICtrlSetData($mLabel_Destination, $mDestination_Label[9])
				Case Else
					GUICtrlSetData($mLabel_Destination, $mDestination_Label[0])
			EndSwitch
		EndIf

		; Enable/Disable Save Button:
		$mTempString = GUICtrlRead($mInput_Destination) & GUICtrlRead($mInput_Rename) & GUICtrlRead($mInput_Compress) & GUICtrlRead($mInput_Extract) & GUICtrlRead($mInput_Split) & GUICtrlRead($mInput_Join) & GUICtrlRead($mInput_OpenWith) & GUICtrlRead($mInput_Crypt) & GUICtrlRead($mInput_Gallery) & GUICtrlRead($mInput_List)
		If (GUICtrlRead($mInput_Name) <> "" And GUICtrlRead($mInput_Rules) <> "" And $mFileProperties <> "" And $mCryptSettings <> "" And $mMailSettings <> "" And __StringIsValid($mTempString, '|') And Not StringIsSpace(GUICtrlRead($mInput_Rules))) Or $mCurrentAction = __GetLang('ACTION_PRINT', 'Print') Then
			If GUICtrlGetState($mSave) > 80 Then
				GUICtrlSetState($mSave, 576) ; $GUI_ENABLE + $GUI_DEFBUTTON.
			EndIf
			If GUICtrlGetState($mCancel) = 512 Then
				GUICtrlSetState($mCancel, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
		ElseIf GUICtrlRead($mInput_Name) = "" Or GUICtrlRead($mInput_Rules) = "" Or $mFileProperties = "" Or $mCryptSettings = "" Or $mMailSettings = "" Or __StringIsValid($mTempString, '|') = 0 Or StringIsSpace(GUICtrlRead($mInput_Rules)) Then
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
				$mInput_DestinationRead = GUICtrlRead($mInput_Destination)
				$mInput_RulesRead = GUICtrlRead($mInput_Rules)
				$mCurrentActionString = __GetActionString($mCurrentAction)
				$mNoOthers = 0
				If $mInput_RulesRead == "#" Or $mInput_RulesRead == "##" Or $mInput_RulesRead == "#;##" Or $mInput_RulesRead == "##;#" Or $mInput_RulesRead == "#|##" Or $mInput_RulesRead == "##|#" Then
					$mInput_RulesRead = StringReplace($mInput_RulesRead, "#", "*")
					$mNoOthers = 1 ; It Is A "No Others" Association.
				EndIf
				If StringInStr($mInput_RulesRead, "*") = 0 And $mUseRegEx <> "True" Then ; Fix Rules Without * Characters.
					$mInput_RulesRead = "*" & $mInput_RulesRead
				EndIf

				Switch $mCurrentActionString
					Case "$4" ; Extract.
						$mInput_DestinationRead = GUICtrlRead($mInput_Extract)
						If StringInStr($mInput_RulesRead, "**") And $mUseRegEx <> "True" Then
							MsgBox(0x30, __GetLang('MANAGE_EDIT_MSGBOX_4', 'Association Error'), __GetLang('MANAGE_EDIT_MSGBOX_11', 'You cannot use this action for folders.'), 0, __OnTop($mGUI))
							ContinueLoop
						EndIf
					Case "$M" ; Print.
						$mInput_DestinationRead = "-"
						If StringInStr($mInput_RulesRead, "**") And $mUseRegEx <> "True" Then
							MsgBox(0x30, __GetLang('MANAGE_EDIT_MSGBOX_4', 'Association Error'), __GetLang('MANAGE_EDIT_MSGBOX_11', 'You cannot use this action for folders.'), 0, __OnTop($mGUI))
							ContinueLoop
						EndIf
					Case "$J" ; Join.
						$mInput_DestinationRead = GUICtrlRead($mInput_Join)
						If StringInStr($mInput_RulesRead, "**") And $mUseRegEx <> "True" Then
							MsgBox(0x30, __GetLang('MANAGE_EDIT_MSGBOX_4', 'Association Error'), __GetLang('MANAGE_EDIT_MSGBOX_11', 'You cannot use this action for folders.'), 0, __OnTop($mGUI))
							ContinueLoop
						EndIf
					;Case "$K" ; Convert Image.
					;	$mInput_DestinationRead = GUICtrlRead($mInput_Convert) ;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
					;	If StringInStr($mInput_RulesRead, "**") And $mUseRegEx <> "True" Then
					;		MsgBox(0x30, __GetLang('MANAGE_EDIT_MSGBOX_4', 'Association Error'), __GetLang('MANAGE_EDIT_MSGBOX_11', 'You cannot use this action for folders.'), 0, __OnTop($mGUI))
					;		ContinueLoop
					;	EndIf
					Case "$8" ; List.
						$mInput_DestinationRead = GUICtrlRead($mInput_List)
						If __IsValidFileType($mInput_DestinationRead, "html;htm;pdf;xls;csv;txt;xml") = 0 Then
							MsgBox(0x30, __GetLang('MANAGE_EDIT_MSGBOX_0', 'Destination Error'), __GetLang('MANAGE_EDIT_MSGBOX_1', 'You must specify a valid destination.'), 0, __OnTop($mGUI))
							ContinueLoop
						EndIf
					Case "$9" ; Playlist.
						If StringInStr($mInput_RulesRead, "**") And $mUseRegEx <> "True" Then
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
					Case "$3" ; Compress.
						$mInput_DestinationRead = GUICtrlRead($mInput_Compress)
					Case "$6" ; Delete.
						$mInput_DestinationRead = __GetDeleteString(GUICtrlRead($mCombo_Delete))
					Case "$5" ; Open With.
						$mInput_DestinationRead = GUICtrlRead($mInput_OpenWith)
					Case "$7" ; Rename.
						$mInput_DestinationRead = GUICtrlRead($mInput_Rename)
					Case "$B" ; Clipboard.
						$mInput_DestinationRead = GUICtrlRead($mInput_Clipboard)
					Case "$F", "$G" ; Encrypt Or Decrypt.
						$mInput_DestinationRead = GUICtrlRead($mInput_Crypt)
					Case "$H" ; Gallery.
						$mInput_DestinationRead = GUICtrlRead($mInput_Gallery)
					Case "$I" ; Split.
						$mInput_DestinationRead = GUICtrlRead($mInput_Split)
					Case "$D" ; Change Properties.
						$mInput_DestinationRead = $mFileProperties
					Case "$E" ; Send by Mail.
						$mInput_DestinationRead = $mMailSettings
					Case "$2" ; Ignore.
						$mInput_DestinationRead = "-"
				EndSwitch

				$mInput_NameRead = __SetAssociationName(GUICtrlRead($mInput_Name), $mAssociationName, $mProfile[0], $mNewAssociation, $mGUI)
				If @error Then
					ContinueLoop
				EndIf
				If $mState Then
					$mState = $G_Global_StateEnabled
				Else
					$mState = $G_Global_StateDisabled
				EndIf
				If $mNoOthers Then
					$mInput_RulesRead = StringReplace($mInput_RulesRead, "*", "#") ; To Restore The Correct "No Others" Association Format.
				EndIf
				If $mFilters[0][1] <> "" Then ; Filters Defined.
					$mStringFilters = ""
					For $A = 0 To $STATIC_FILTERS_NUMBER - 1
						$mStringFilters &= $mFilters[$A][0] & $mFilters[$A][1] & $mFilters[$A][2]
						If $A < $STATIC_FILTERS_NUMBER - 1 Then
							$mStringFilters &= $STATIC_FILTERS_DIVIDER
						EndIf
					Next
					If StringLen($mStringFilters) < 40 Then ; To Avoid Empty Filters.
						$mStringFilters = ""
					EndIf
				EndIf
				If $mCurrentActionString <> "$8" Then
					$mListProperties = ""
					$mHTMLTheme = ""
					$mListSettings = ""
				ElseIf $mListProperties = "" Then
					$mListProperties = __DefaultListProperties()
				EndIf
				If $mCurrentActionString <> "$C" Then
					$mSiteSettings = ""
				EndIf
				If $mCurrentActionString <> "$F" And $mCurrentActionString <> "$G" Then
					$mCryptSettings = ""
				EndIf
				If $mCurrentActionString <> "$3" Then
					$mCompressSettings = ""
				EndIf
				If $mCurrentActionString <> "$4" Then
					$mExtractSettings = ""
				EndIf
				If $mCurrentActionString <> "$I" Then
					$mSplitSettings = ""
				EndIf
				If $mCurrentActionString <> "$J" Then
					$mJoinSettings = ""
				EndIf
				If $mCurrentActionString <> "$5" Then
					$mOpenWithSettings = ""
				EndIf
				If $mCurrentActionString <> "$H" Then
					$mGalleryProperties = ""
					$mGalleryTheme = ""
					$mGallerySettings = ""
				EndIf
				__IniWriteEx($mProfile[0], $mInput_NameRead, "", "State=" & $mState & @LF & "Rules=" & $mInput_RulesRead & @LF & "Action=" & $mCurrentActionString & @LF & "Destination=" & $mInput_DestinationRead & _
						__ComposeLineINI("Filters", $mStringFilters) & _
						__ComposeLineINI("FavouriteAssociation", $mFavouriteAssociation) & _
						__ComposeLineINI("UseRegEx", $mUseRegEx) & _
						__ComposeLineINI("CompressSettings", $mCompressSettings) & _
						__ComposeLineINI("ExtractSettings", $mExtractSettings) & _
						__ComposeLineINI("OpenWithSettings", $mOpenWithSettings) & _
						__ComposeLineINI("GalleryProperties", $mGalleryProperties) & _
						__ComposeLineINI("GalleryTheme", $mGalleryTheme) & _
						__ComposeLineINI("GallerySettings", $mGallerySettings) & _
						__ComposeLineINI("ListProperties", $mListProperties) & _
						__ComposeLineINI("HTMLTheme", $mHTMLTheme) & _
						__ComposeLineINI("ListSettings", $mListSettings) & _
						__ComposeLineINI("SiteSettings", $mSiteSettings) & _
						__ComposeLineINI("CryptSettings", $mCryptSettings) & _
						__ComposeLineINI("SplitSettings", $mSplitSettings) & _
						__ComposeLineINI("JoinSettings", $mJoinSettings))
				__Log_Write($mLogAssociation, $mInput_NameRead)
				$mChanged = 1
				ExitLoop

			Case $mCheck_Favourite
				If $mFavouriteAssociation == "True" Then
					GUICtrlSetImage($mCheck_Favourite, @ScriptFullPath, -24) ; Not Favourite.
					$mFavouriteAssociation = "False"
				Else
					GUICtrlSetImage($mCheck_Favourite, @ScriptFullPath, -23) ; Favourite.
					$mFavouriteAssociation = "True"
				EndIf

			Case $mButton_Rules
				$mAbbreviation = _Manage_ContextMenu_Rules($mButton_Rules, $mUseRegEx) ; ByRef: $mUseRegEx.
				If $mAbbreviation <> -1 Then
					__InsertText($mInput_Rules, $mAbbreviation)
				EndIf

			Case $mButton_Compress
				_Manage_Compress($mCompressSettings, $mGUI) ; ByRef: $mCompressSettings.
				$mStringSplit = StringSplit($mCompressSettings, ";") ; Only To Get 2 = Compress Format.
				ReDim $mStringSplit[3]
				If $mStringSplit[2] <> "" Then
					$mCompressFormat = $mStringSplit[2]
					If GUICtrlRead($mInput_Compress) <> "" Then
						$mCompressFormatBis = __GetFileExtension(GUICtrlRead($mInput_Compress))
						If $mCompressFormatBis = "" Then
							GUICtrlSetData($mInput_Compress, GUICtrlRead($mInput_Compress) & "." & $mCompressFormat)
						ElseIf $mCompressFormat <> $mCompressFormatBis Then
							GUICtrlSetData($mInput_Compress, StringTrimRight(GUICtrlRead($mInput_Compress), StringLen($mCompressFormatBis)) & $mCompressFormat)
						EndIf
					EndIf
				EndIf

			Case $mButton_Extract
				_Manage_RemoveSource($mExtractSettings, $mGUI) ; ByRef: $mExtractSettings.

			Case $mButton_Split
				_Manage_Split($mSplitSettings, $mGUI) ; ByRef: $mSplitSettings.

			Case $mButton_Join
				_Manage_RemoveSource($mJoinSettings, $mGUI) ; ByRef: $mJoinSettings.

			Case $mButton_OpenWith
				_Manage_OpenWith($mOpenWithSettings, $mGUI) ; ByRef: $mOpenWithSettings.

			Case $mButton_Crypt
				_Manage_Crypt($mCryptSettings, $mGUI) ; ByRef: $mCryptSettings.

			Case $mButton_Filters
				_Manage_Filters($mFilters, $mGUI) ; ByRef: $mFilters.

			Case $mButton_Gallery
				_Manage_Gallery($mGalleryProperties, $mGalleryTheme, $mGallerySettings, $mProfile[1], $mGUI) ; ByRef: $mGalleryProperties, $mGalleryTheme, $mGallerySettings.

			Case $mButton_List
				_Manage_List($mListProperties, $mHTMLTheme, $mListSettings, $mProfile[1], $mGUI) ; ByRef: $mListProperties, $mHTMLTheme, $mListSettings.

			Case $mButton_Site
				_Manage_Site($mSiteSettings, $mGUI) ; ByRef: $mSiteSettings.

			Case $mButton_Change
				_Manage_Properties($mFileProperties, $mGUI) ; ByRef: $mFileProperties.

			Case $mButton_Mail
				_Manage_Mail($mMailSettings, $mGUI) ; ByRef: $mMailSettings.

			Case $mButton_Destination
				Switch $mCurrentAction
					Case __GetLang('ACTION_COMPRESS', 'Compress')
						$mInput_Current = $mInput_Compress
					Case __GetLang('ACTION_EXTRACT', 'Extract')
						$mInput_Current = $mInput_Extract
					Case __GetLang('ACTION_SPLIT', 'Split')
						$mInput_Current = $mInput_Split
					Case __GetLang('ACTION_JOIN', 'Join')
						$mInput_Current = $mInput_Join
					Case __GetLang('ACTION_OPEN_WITH', 'Open With')
						$mInput_Current = $mInput_OpenWith
					Case __GetLang('ACTION_ENCRYPT', 'Encrypt'), __GetLang('ACTION_DECRYPT', 'Decrypt')
						$mInput_Current = $mInput_Crypt
					Case __GetLang('ACTION_GALLERY', 'Create Gallery')
						$mInput_Current = $mInput_Gallery
					Case __GetLang('ACTION_LIST', 'Create List')
						$mInput_Current = $mInput_List
					Case Else
						$mInput_Current = $mInput_Destination
				EndSwitch
				$mFolder = GUICtrlRead($mInput_Current)
				Switch $mCurrentAction
					Case __GetLang('ACTION_OPEN_WITH', 'Open With')
						$mFolder = FileOpenDialog(__GetLang('MANAGE_DESTINATION_PROGRAM_SELECT', 'Select a destination program:'), @DesktopDir, __GetLang('MANAGE_EDIT_MSGBOX_10', 'Executable or Script') & " (*.exe;*.bat;*.cmd;*.com;*.pif)", 1, "", $mGUI)
						If @error Then
							$mFolder = ""
						EndIf
					Case __GetLang('ACTION_LIST', 'Create List')
						$mListName = $mFolder
						$mListType = __GetListCode($mCurrentAction, $mFolder)
						If @error Then
							$mListName = __GetLang('MANAGE_DESTINATION_FILE_NAME', 'DropIt List')
						EndIf
						$mListName = _WinAPI_GetSaveFileName(__GetLang('MANAGE_DESTINATION_FILE_SELECT', 'Choose a destination file:'), "HTML - " & __GetLang('MANAGE_DESTINATION_FORMAT_0', 'HyperText Markup Language file') & " (*.html;*.htm)|PDF - " & __GetLang('MANAGE_DESTINATION_FORMAT_11', 'Portable Document Format file') & " (*.pdf)|XLS - " & __GetLang('MANAGE_DESTINATION_FORMAT_12', 'Microsoft Excel file') & " (*.xls)|CSV - " & __GetLang('MANAGE_DESTINATION_FORMAT_2', 'Comma-Separated Values file') & " (*.csv)|TXT - " & __GetLang('MANAGE_DESTINATION_FORMAT_1', 'Normal text file') & " (*.txt)|XML - " & __GetLang('MANAGE_DESTINATION_FORMAT_3', 'eXtensible Markup Language file') & " (*.xml)", @DesktopDir, $mListName, "html", $mListType, 0, 0, $mGUI)
						If $mListName[0] = 2 Then
							If _WinAPI_PathIsDirectory($mListName[1]) Then
								$mFolder = $mListName[1] & "\" & $mListName[2]
							EndIf
						EndIf
					Case __GetLang('ACTION_COMPRESS', 'Compress')
						$mListName = $mFolder
						$mListType = __GetListCode($mCurrentAction, $mListName)
						If @error Then
							$mListName = __GetLang('ARCHIVE', 'Archive') & "." & $mCompressFormat
							$mListType = __GetListCode($mCurrentAction, $mListName)
						EndIf
						$mListName = _WinAPI_GetSaveFileName(__GetLang('MANAGE_DESTINATION_ARCHIVE_SELECT', 'Choose a destination archive:'), "ZIP - " & __GetLang('MANAGE_DESTINATION_FORMAT_4', 'Standard mainstream archive') & " (*.zip)|7Z - " & __GetLang('MANAGE_DESTINATION_FORMAT_5', 'High compression ratio archive') & " (*.7z)|EXE - " & __GetLang('MANAGE_DESTINATION_FORMAT_6', 'Self-extracting archive') & " (*.exe)", @DesktopDir, $mListName, $mCompressFormat, $mListType, 0, 0, $mGUI)
						If $mListName[0] = 2 Then
							If _WinAPI_PathIsDirectory($mListName[1]) Then
								$mFolder = $mListName[1] & "\" & $mListName[2]
								$mCompressFormatBis = __GetFileExtension($mListName[2])
								If $mCompressFormat <> $mCompressFormatBis Then
									$mStringSplit = StringSplit($mCompressSettings, ";") ; 1 = Remove Source, 2 = Compress Format, 3 = Level, 4 = Method, 5 = Encryption, 6 = Password.
									ReDim $mStringSplit[7] ; Number Of Settings.
									If $mCompressFormatBis <> "zip" Then
										$mCompressSettings = $mStringSplit[1] & ";" & $mCompressFormatBis & ";" & $mStringSplit[3] & ";LZMA;None;"
									Else
										$mCompressSettings = $mStringSplit[1] & ";" & $mCompressFormatBis & ";" & $mStringSplit[3] & ";Deflate;None;"
									EndIf
								EndIf
							EndIf
						EndIf
					Case __GetLang('ACTION_PLAYLIST', 'Create Playlist')
						$mListName = $mFolder
						$mListType = __GetListCode($mCurrentAction, $mFolder)
						If @error Then
							$mListName = __GetLang('PLAYLIST', 'Playlist')
						EndIf
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
							$mInput_Current = $mInput_Rename
						Case __GetLang('ACTION_CLIPBOARD', 'Copy to Clipboard')
							$mInput_Current = $mInput_Clipboard
						Case __GetLang('ACTION_UPLOAD', 'Upload')
							$mInput_Current = $mInput_Site
						Case __GetLang('ACTION_COMPRESS', 'Compress')
							$mInput_Current = $mInput_Compress
						Case __GetLang('ACTION_EXTRACT', 'Extract')
							$mInput_Current = $mInput_Extract
						Case __GetLang('ACTION_SPLIT', 'Split')
							$mInput_Current = $mInput_Split
						Case __GetLang('ACTION_JOIN', 'Join')
							$mInput_Current = $mInput_Join
						Case __GetLang('ACTION_OPEN_WITH', 'Open With')
							$mInput_Current = $mInput_OpenWith
						Case __GetLang('ACTION_ENCRYPT', 'Encrypt'), __GetLang('ACTION_DECRYPT', 'Decrypt')
							$mInput_Current = $mInput_Crypt
						Case __GetLang('ACTION_GALLERY', 'Create Gallery')
							$mInput_Current = $mInput_Gallery
						Case __GetLang('ACTION_LIST', 'Create List')
							$mInput_Current = $mInput_List
						Case Else
							$mInput_Current = $mInput_Destination
					EndSwitch
					__InsertText($mInput_Current, "%" & $mAbbreviation & "%")
				EndIf
				GUIRegisterMsg($WM_COMMAND, "_WM_COMMAND") ; Needed To Restore _WM_COMMAND().
				_WinAPI_SetFocus(GUICtrlGetHandle($mInput_Current))

		EndSwitch
	WEnd
	GUIDelete($mGUI)

	If $mChanged = 1 Then
		Return 1
	EndIf
	Return SetError(1, 0, 0)
EndFunc   ;==>_Manage_Edit_GUI

Func _Manage_Delete($mProfilePath, $mAssociationName, $mHandle = -1)
	Local $mMsgBox = MsgBox(0x4, __GetLang('MANAGE_DELETE_MSGBOX_0', 'Delete association'), __GetLang('MANAGE_DELETE_MSGBOX_1', 'Selected association:') & "  " & $mAssociationName & @LF & __GetLang('MANAGE_DELETE_MSGBOX_2', 'Are you sure to delete this association?'), 0, __OnTop($mHandle))

	If $mMsgBox <> 6 Then
		Return SetError(1, 0, 0)
	EndIf
	If $mProfilePath = "" Then
		$mProfilePath = __IsProfile(-1, 1) ; Get Current Profile Path.
	EndIf
	IniDelete($mProfilePath, $mAssociationName)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	__Log_Write(__GetLang('MANAGE_LOG_2', 'Association Removed'), $mAssociationName)
	$Global_ListViewIndex = -1

	Return 1
EndFunc   ;==>_Manage_Delete

Func _Manage_Populate($mListView, $mProfileName)
	Local $mAssociationName, $mState, $mRules, $mAction, $mDestination
	Local $mAssociations = __GetAssociations($mProfileName) ; Get Associations Array For The Current Profile.

	_GUICtrlListView_BeginUpdate($mListView)
	_GUICtrlListView_DeleteAllItems($mListView)
	For $A = 1 To $mAssociations[0][0]
		$mAssociationName = $mAssociations[$A][0]
		$mState = $mAssociations[$A][1]
		$mRules = $mAssociations[$A][2]
		$mAction = $mAssociations[$A][3]
		$mDestination = __GetDestinationString($mAction, $mAssociations[$A][4], $mAssociations[$A][8]) ; Action, Destination, Site Settings.
		$mAction = __GetActionString($mAction)

		_GUICtrlListView_AddItem($mListView, $mAssociationName, -1, _GUICtrlListView_GetItemCount($mListView) + 9999)
		_GUICtrlListView_AddSubItem($mListView, $A - 1, $mRules, 1)
		_GUICtrlListView_AddSubItem($mListView, $A - 1, $mAction, 2)
		_GUICtrlListView_AddSubItem($mListView, $A - 1, $mDestination, 3) ; Destination.

		If $mState <> $G_Global_StateDisabled Then
			_GUICtrlListView_SetItemChecked($mListView, $A - 1)
		EndIf
	Next
	_GUICtrlListView_RegisterSortCallBack($mListView, True, False)
	_GUICtrlListView_SortItems($mListView, 0)
	_GUICtrlListView_UnRegisterSortCallBack($mListView)
	_GUICtrlListView_SetItemSelected($mListView, 0, False, False)
	_GUICtrlListView_EndUpdate($mListView)
	$Global_ListViewRules_ItemChange = -1

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_Manage_Populate

Func _Manage_ExtractFilters($mProfile, $mAssociationName, $mFilters)
	Local $aMatch
	Local $mStringFilters = __GetAssociationField($mProfile, $mAssociationName, "Filters")
	Local $mStringSplit = StringSplit($mStringFilters, $STATIC_FILTERS_DIVIDER, 2)
	If @error Then
		Return SetError(1, 0, $mFilters)
	EndIf

	;Make sure the last filter is always kept as is, without splitting at $STATIC_FILTERS_DIVIDER (necessary for regex file content matches)
	If UBound($mStringSplit) >= $STATIC_FILTERS_NUMBER Then
		$aMatch = StringRegExp($mStringFilters, "(?:[^|]+\|){10}(.*)$", $STR_REGEXPARRAYMATCH)
		If @error = 0 Then
			$mStringSplit[$STATIC_FILTERS_NUMBER - 1] = $aMatch[0]
		EndIf
	EndIf

	ReDim $mStringSplit[$STATIC_FILTERS_NUMBER] ; Number Of Filters.

	For $A = 0 To $STATIC_FILTERS_NUMBER - 1
		$mFilters[$A][0] = StringLeft($mStringSplit[$A], 1) ; First Character.
		$mFilters[$A][1] = StringLeft(StringTrimLeft($mStringSplit[$A], 1), 1) ; Second Character.
		$mFilters[$A][2] = StringTrimLeft($mStringSplit[$A], 2) ; All Other Characters.
	Next

	Return $mFilters
EndFunc   ;==>_Manage_ExtractFilters

Func _Manage_Compress(ByRef $mSettings, $mHandle = -1)
	Local $mGUI, $mSave, $mCancel, $mStringSplit, $mComboItems[7], $mGroup[7], $mCurrent[7], $mCheckbox_Remove, $mRemove
	Local $mState, $mPassword, $mPW, $mPW_Code = $G_Global_PasswordKey

	If $mSettings = "" Then
		$mSettings = __GetDefaultCompressSettings()
	EndIf
	$mStringSplit = StringSplit($mSettings, ";") ; 1 = Remove Source, 2 = Compress Format, 3 = Level, 4 = Method, 5 = Encryption, 6 = Password.
	ReDim $mStringSplit[7] ; Number Of Settings.

	$mGUI = GUICreate(__GetLang('MANAGE_EDIT_MSGBOX_12', 'Configure'), 360, 235, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	GUICtrlCreateLabel(__GetLang('OPTIONS_TAB_2', 'Compression') & ":", 15, 12 + 4, 110, 20)
	$mComboItems[1] = GUICtrlCreateCombo("", 15 + 124, 12, 205, 20, 0x0003)
	GUICtrlCreateLabel(__GetLang('OPTIONS_LABEL_11', 'Level') & ":", 15, 12 + 30 + 4, 110, 20)
	$mComboItems[2] = GUICtrlCreateCombo("", 15 + 124, 12 + 30, 205, 20, 0x0003)
	GUICtrlCreateLabel(__GetLang('OPTIONS_LABEL_12', 'Method') & ":", 15, 12 + 60 + 4, 110, 20)
	$mComboItems[3] = GUICtrlCreateCombo("", 15 + 124, 12 + 60, 205, 20, 0x0003)
	$mComboItems[5] = GUICtrlCreateCombo("", 15 + 124, 12 + 60, 205, 20, 0x0003)
	GUICtrlCreateLabel(__GetLang('OPTIONS_LABEL_9', 'Encryption') & ":", 15, 12 + 90 + 4, 110, 20)
	$mComboItems[4] = GUICtrlCreateCombo("", 15 + 124, 12 + 90, 205, 20, 0x0003)
	$mComboItems[6] = GUICtrlCreateCombo("", 15 + 124, 12 + 90, 205, 20, 0x0003)
	GUICtrlCreateLabel(__GetLang('OPTIONS_LABEL_13', 'Password') & ":", 15, 12 + 120 + 4, 110, 20)
	$mPassword = GUICtrlCreateInput("", 15 + 124, 12 + 120, 205, 20, BitOR(0x0020, 0x0080))
	$mCheckbox_Remove = GUICtrlCreateCheckbox(__GetLang('MANAGE_REMOVE_SOURCE', 'Remove source after processing it'), 15, 12 + 150, 320, 20)

	If $mStringSplit[1] == "True" Then
		GUICtrlSetState($mCheckbox_Remove, $GUI_CHECKED)
	EndIf

	$mGroup[1] = "ZIP|7Z|EXE"
	$mCurrent[1] = StringUpper($mStringSplit[2])

	$mGroup[2] = __GetLang('COMPRESS_LEVEL_5', 'Store') & "|" & __GetLang('COMPRESS_LEVEL_0', 'Fastest') & "|" & __GetLang('COMPRESS_LEVEL_1', 'Fast') & "|" & _
			__GetLang('COMPRESS_LEVEL_2', 'Normal') & "|" & __GetLang('COMPRESS_LEVEL_3', 'Maximum') & "|" & __GetLang('COMPRESS_LEVEL_4', 'Ultra')
	$mCurrent[2] = __GetCompressionLevel($mStringSplit[3])

	$mGroup[3] = "Deflate|LZMA|PPMd|BZip2"
	$mCurrent[3] = $mStringSplit[4]
	If StringInStr($mGroup[3], $mCurrent[3]) = 0 Then
		$mCurrent[3] = "Deflate"
	EndIf

	$mGroup[4] = __GetLang('NONE', 'None') & "|ZipCrypto|AES-256"
	$mCurrent[4] = $mStringSplit[5]
	If StringInStr($mGroup[4], $mCurrent[4]) = 0 Then
		$mCurrent[4] = __GetLang('NONE', 'None')
	EndIf

	$mGroup[5] = "LZMA|LZMA2|PPMd|BZip2"
	$mCurrent[5] = $mStringSplit[4]
	If StringInStr($mGroup[5], $mCurrent[5]) = 0 Then
		$mCurrent[5] = "LZMA"
	EndIf

	$mGroup[6] = __GetLang('NONE', 'None') & "|AES-256"
	$mCurrent[6] = $mStringSplit[5]
	If StringInStr($mGroup[6], $mCurrent[6]) = 0 Then
		$mCurrent[6] = __GetLang('NONE', 'None')
	EndIf

	For $A = 1 To 6
		GUICtrlSetData($mComboItems[$A], $mGroup[$A], $mCurrent[$A])
	Next

	$mState = $GUI_DISABLE
	If $mCurrent[1] <> "ZIP" Then
		GUICtrlSetState($mComboItems[3], $GUI_HIDE)
		GUICtrlSetState($mComboItems[4], $GUI_HIDE)
		GUICtrlSetState($mComboItems[5], $GUI_SHOW)
		GUICtrlSetState($mComboItems[6], $GUI_SHOW)
		If $mCurrent[6] <> __GetLang('NONE', 'None') Then
			$mState = $GUI_ENABLE
		EndIf
	Else
		GUICtrlSetState($mComboItems[3], $GUI_SHOW)
		GUICtrlSetState($mComboItems[4], $GUI_SHOW)
		GUICtrlSetState($mComboItems[5], $GUI_HIDE)
		GUICtrlSetState($mComboItems[6], $GUI_HIDE)
		If $mCurrent[4] <> __GetLang('NONE', 'None') Then
			$mState = $GUI_ENABLE
		EndIf
	EndIf
	GUICtrlSetState($mPassword, $mState)
	$mPW = $mStringSplit[6]
	If $mPW <> "" Then
		GUICtrlSetData($mPassword, __StringEncrypt(0, $mPW, $mPW_Code))
	EndIf

	$mSave = GUICtrlCreateButton(__GetLang('OK', 'OK'), 180 - 40 - 90, 200, 90, 24)
	$mCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 180 + 40, 200, 90, 24)
	GUICtrlSetState($mSave, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)

	While 1
		If GUICtrlRead($mComboItems[1]) <> $mCurrent[1] And Not _GUICtrlComboBox_GetDroppedState($mComboItems[1]) Then
			$mCurrent[1] = GUICtrlRead($mComboItems[1])
			$mState = $GUI_DISABLE
			If $mCurrent[1] <> "ZIP" Then
				GUICtrlSetState($mComboItems[3], $GUI_HIDE)
				GUICtrlSetState($mComboItems[4], $GUI_HIDE)
				GUICtrlSetState($mComboItems[5], $GUI_SHOW)
				GUICtrlSetState($mComboItems[6], $GUI_SHOW)
				If $mCurrent[6] <> __GetLang('NONE', 'None') Then
					$mState = $GUI_ENABLE
				EndIf
			Else
				GUICtrlSetState($mComboItems[3], $GUI_SHOW)
				GUICtrlSetState($mComboItems[4], $GUI_SHOW)
				GUICtrlSetState($mComboItems[5], $GUI_HIDE)
				GUICtrlSetState($mComboItems[6], $GUI_HIDE)
				If $mCurrent[4] <> __GetLang('NONE', 'None') Then
					$mState = $GUI_ENABLE
				EndIf
			EndIf
			GUICtrlSetState($mPassword, $mState)
		EndIf
		If GUICtrlRead($mComboItems[4]) <> $mCurrent[4] And Not _GUICtrlComboBox_GetDroppedState($mComboItems[4]) Then
			$mCurrent[4] = GUICtrlRead($mComboItems[4])
			$mState = $GUI_DISABLE
			If $mCurrent[4] <> __GetLang('NONE', 'None') Then
				$mState = $GUI_ENABLE
			EndIf
			GUICtrlSetState($mPassword, $mState)
		EndIf
		If GUICtrlRead($mComboItems[6]) <> $mCurrent[6] And Not _GUICtrlComboBox_GetDroppedState($mComboItems[6]) Then
			$mCurrent[6] = GUICtrlRead($mComboItems[6])
			$mState = $GUI_DISABLE
			If $mCurrent[6] <> __GetLang('NONE', 'None') Then
				$mState = $GUI_ENABLE
			EndIf
			GUICtrlSetState($mPassword, $mState)
		EndIf

		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $mCancel
				ExitLoop

			Case $mSave
				$mRemove = "False"
				If GUICtrlRead($mCheckbox_Remove) = 1 Then
					$mRemove = "True"
				EndIf
				$mSettings = $mRemove & ";" & StringLower($mCurrent[1]) & ";" & __GetCompressionLevel(GUICtrlRead($mComboItems[2])) & ";"
				If $mCurrent[1] <> "ZIP" Then
					$mSettings &= GUICtrlRead($mComboItems[5]) & ";"
					$mState = GUICtrlRead($mComboItems[6])
				Else
					$mSettings &= GUICtrlRead($mComboItems[3]) & ";"
					$mState = GUICtrlRead($mComboItems[4])
				EndIf
				$mPW = ""
				If StringIsSpace(GUICtrlRead($mPassword)) = 0 And GUICtrlRead($mPassword) <> "" Then
					$mPW = __StringEncrypt(1, GUICtrlRead($mPassword), $mPW_Code)
				EndIf
				If $mPW = "" And BitAND(GUICtrlGetState($mPassword), $GUI_ENABLE) Then
					$mState = __GetLang('NONE', 'None')
				EndIf
				If $mState = __GetLang('NONE', 'None') Then
					$mState = "None"
					$mPW = ""
				EndIf
				$mSettings &= $mState & ";" & $mPW
				ExitLoop

		EndSwitch
	WEnd
	GUIDelete($mGUI)

	Return 1 ; ByRef: $mSettings.
EndFunc   ;==>_Manage_Compress

Func _Manage_Crypt(ByRef $mSettings, $mHandle = -1)
	Local $mGUI, $mSave, $mCancel, $mStringSplit, $mCombo_Algorithm, $mCheckbox_Remove, $mRemove, $mInput_Password, $mPassword_Code = $G_Global_PasswordKey

	$mStringSplit = StringSplit($mSettings, "|") ; 1 = Algorithm, 2 = Password, 3 = Remove Source.
	ReDim $mStringSplit[4] ; Number Of Settings.
	If $mStringSplit[1] = "" Then
		$mStringSplit[1] = "7ZIP"
	EndIf
	If $mStringSplit[2] <> "" Then
		$mStringSplit[2] = __StringEncrypt(0, $mStringSplit[2], $mPassword_Code)
	EndIf

	$mGUI = GUICreate(__GetLang('MANAGE_EDIT_MSGBOX_12', 'Configure'), 340, 185, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	GUICtrlCreateLabel(__GetLang('MANAGE_CRYPT_LABEL_0', 'Algorithm') & ":", 15, 12, 200, 20)
	$mCombo_Algorithm = GUICtrlCreateCombo("", 10, 30, 320, 22, $WS_VSCROLL + $CBS_DROPDOWNLIST)
	GUICtrlSetData($mCombo_Algorithm, "7ZIP|3DES|AES (128bit)|AES (192bit)|AES (256bit)|DES|RC2|RC4", $mStringSplit[1])
	GUICtrlCreateLabel(__GetLang('SITE_LABEL_3', 'Password') & ":", 15, 12 + 50, 200, 20)
	$mInput_Password = GUICtrlCreateInput($mStringSplit[2], 10, 30 + 50, 320, 22, 0x0020)
	$mCheckbox_Remove = GUICtrlCreateCheckbox(__GetLang('MANAGE_REMOVE_SOURCE', 'Remove source after processing it'), 15, 12 + 100, 310, 20)
	If $mStringSplit[3] == "True" Then
		GUICtrlSetState($mCheckbox_Remove, $GUI_CHECKED)
	EndIf

	$mSave = GUICtrlCreateButton(__GetLang('OK', 'OK'), 170 - 40 - 90, 150, 90, 24)
	$mCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 170 + 40, 150, 90, 24)
	GUICtrlSetState($mSave, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)

	While 1
		; Enable/Disable Save Button:
		If GUICtrlRead($mInput_Password) <> "" And StringIsSpace(GUICtrlRead($mInput_Password)) = 0 Then
			If GUICtrlGetState($mSave) > 80 Then
				GUICtrlSetState($mSave, 576) ; $GUI_ENABLE + $GUI_DEFBUTTON.
			EndIf
			If GUICtrlGetState($mCancel) = 512 Then
				GUICtrlSetState($mCancel, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
		ElseIf GUICtrlRead($mInput_Password) = "" Or StringIsSpace(GUICtrlRead($mInput_Password)) Then
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
				$mRemove = "False"
				If GUICtrlRead($mCheckbox_Remove) = 1 Then
					$mRemove = "True"
				EndIf
				$mSettings = GUICtrlRead($mCombo_Algorithm) & "|" & __StringEncrypt(1, GUICtrlRead($mInput_Password), $mPassword_Code) & "|" & $mRemove
				ExitLoop

		EndSwitch
	WEnd
	GUIDelete($mGUI)

	Return 1 ; ByRef: $mSettings.
EndFunc   ;==>_Manage_Crypt

Func _Manage_RemoveSource(ByRef $mSettings, $mHandle = -1)
	Local $mGUI, $mSave, $mCancel, $mCheckbox_Remove, $mRemove

	$mGUI = GUICreate(__GetLang('MANAGE_EDIT_MSGBOX_12', 'Configure'), 340, 85, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	$mCheckbox_Remove = GUICtrlCreateCheckbox(__GetLang('MANAGE_REMOVE_SOURCE', 'Remove source after processing it'), 15, 12, 310, 20)
	If $mSettings == "True" Then
		GUICtrlSetState($mCheckbox_Remove, $GUI_CHECKED)
	EndIf

	$mSave = GUICtrlCreateButton(__GetLang('OK', 'OK'), 170 - 40 - 90, 50, 90, 24)
	$mCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 170 + 40, 50, 90, 24)
	GUICtrlSetState($mSave, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $mCancel
				ExitLoop

			Case $mSave
				$mRemove = "False"
				If GUICtrlRead($mCheckbox_Remove) = 1 Then
					$mRemove = "True"
				EndIf
				$mSettings = $mRemove
				ExitLoop

		EndSwitch
	WEnd
	GUIDelete($mGUI)

	Return 1 ; ByRef: $mSettings.
EndFunc   ;==>_Manage_RemoveSource

Func _Manage_Filters(ByRef $mFilters, $mHandle = -1)
	Local $mGUI, $mSave, $mCancel, $mState, $mText, $mNumbers, $mStringSplit, $mGUI_Items[$STATIC_FILTERS_NUMBER][5], $mCurrentCombo[4]
	Local $mCheckText[$STATIC_FILTERS_NUMBER] = [ _
			__GetLang('FILE_SIZE', 'Size'), _
			__GetLang('DATE_CREATED', 'Date Created'), _
			__GetLang('DATE_MODIFIED', 'Date Modified'), _
			__GetLang('DATE_OPENED', 'Date Opened'), _
			__GetLang('CHANGE_PROPERTIES_ATTRIBUTE_0', 'Archive'), _
			__GetLang('CHANGE_PROPERTIES_ATTRIBUTE_1', 'Hidden'), _
			__GetLang('CHANGE_PROPERTIES_ATTRIBUTE_2', 'Read-Only'), _
			__GetLang('CHANGE_PROPERTIES_ATTRIBUTE_3', 'System'), _
			__GetLang('CHANGE_PROPERTIES_ATTRIBUTE_4', 'Temporary'), _
			__GetLang('INCLUDED_FILES', 'Included Files'), _
			__GetLang('FILE_CONTENT', 'File Content')]

	$mGUI = GUICreate(__GetLang('ADDITIONAL_FILTERS', 'Additional Filters'), 480, 485, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	GUICtrlCreateGroup(__GetLang('ADDITIONAL_FILTERS_LABEL_0', 'Properties'), 10, 10, 459, 140)
	For $A = 0 To 3 ; Size, Dates.
		$mGUI_Items[$A][0] = GUICtrlCreateCheckbox($mCheckText[$A] & ":", 20, 30 + (30 * $A), 170, 20)
		If $mFilters[$A][0] = 1 Then
			GUICtrlSetState($mGUI_Items[$A][0], $GUI_CHECKED)
		EndIf
		$mNumbers = StringRegExpReplace($mFilters[$A][2], "[^0-9\-]", "")
		$mText = StringRegExpReplace($mFilters[$A][2], "[0-9\-]", "")
		$mGUI_Items[$A][1] = GUICtrlCreateCombo("", 20 + 170, 30 - 1 + (30 * $A), 30, 22, $WS_VSCROLL + $CBS_DROPDOWNLIST)
		If $mFilters[$A][1] = "" Then
			$mFilters[$A][1] = ">"
		EndIf
		$mCurrentCombo[$A] = $mFilters[$A][1] ; To Show/Hide Input Fields.
		GUICtrlSetData($mGUI_Items[$A][1], ">|=|<", $mFilters[$A][1])
		If $mFilters[$A][1] = "=" Then
			$mStringSplit = StringSplit($mNumbers, "-")
			ReDim $mStringSplit[3]
			If $mStringSplit[1] <> "" And $mStringSplit[2] = "" Then
				$mStringSplit[2] = $mStringSplit[1] ; Set Equal If Max Not Defined.
			EndIf
			$mGUI_Items[$A][2] = GUICtrlCreateInput($mStringSplit[1], 20 + 170 + 35, 30 - 1 + (30 * $A), 53, 21, 0x2000)
			GUICtrlSetTip($mGUI_Items[$A][2], __GetLang('VALUE_MIN', 'Min'))
			$mGUI_Items[$A][4] = GUICtrlCreateInput($mStringSplit[2], 20 + 170 + 35 + 53 + 4, 30 - 1 + (30 * $A), 53, 21, 0x2000)
			GUICtrlSetTip($mGUI_Items[$A][4], __GetLang('VALUE_MAX', 'Max'))
		Else
			$mGUI_Items[$A][2] = GUICtrlCreateInput($mNumbers, 20 + 170 + 35, 30 - 1 + (30 * $A), 110, 21, 0x2000)
			GUICtrlSetTip($mGUI_Items[$A][2], __GetLang('VALUE', 'Value'))
			$mGUI_Items[$A][4] = GUICtrlCreateInput("", 20 + 170 + 35 + 53 + 4, 30 - 1 + (30 * $A), 53, 21, 0x2000)
			GUICtrlSetTip($mGUI_Items[$A][4], __GetLang('VALUE_MAX', 'Max'))
			GUICtrlSetState($mGUI_Items[$A][4], $GUI_HIDE)
		EndIf
		$mGUI_Items[$A][3] = GUICtrlCreateCombo("", 20 + 170 + 35 + 115, 30 - 1 + (30 * $A), 120, 22, $WS_VSCROLL + $CBS_DROPDOWNLIST)
		If $A = 0 Then ; Size.
			$mText = __GetSizeStringCode($mText, 0)
			GUICtrlSetData($mGUI_Items[$A][3], __GetLang('SIZE_B', 'bytes') & "|" & __GetLang('SIZE_KB', 'KB') & "|" & __GetLang('SIZE_MB', 'MB') & "|" & __GetLang('SIZE_GB', 'GB'), $mText)
		Else ; Dates.
			$mText = __GetTimeStringCode($mText, 0)
			GUICtrlSetData($mGUI_Items[$A][3], __GetLang('TIME_SECONDS', 'Seconds') & "|" & __GetLang('TIME_MINUTES', 'Minutes') & "|" & __GetLang('TIME_HOURS', 'Hours') & "|" & __GetLang('TIME_DAYS', 'Days') & "|" & __GetLang('TIME_MONTHS', 'Months') & "|" & __GetLang('TIME_YEARS', 'Years'), $mText)
		EndIf
	Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__GetLang('ADDITIONAL_FILTERS_LABEL_1', 'Attributes'), 10, 10 + 145, 459, 170)
	For $A = 4 To 8 ; Attributes.
		$mGUI_Items[$A][0] = GUICtrlCreateCheckbox($mCheckText[$A] & ":", 20, 55 + (30 * $A), 170, 20)
		If $mFilters[$A][0] = 1 Then
			GUICtrlSetState($mGUI_Items[$A][0], $GUI_CHECKED)
		EndIf
		$mGUI_Items[$A][1] = GUICtrlCreateCombo("", 20 + 170, 55 - 1 + (30 * $A), 270, 22, $WS_VSCROLL + $CBS_DROPDOWNLIST)
		Switch $mFilters[$A][2]
			Case "on"
				$mText = __GetLang('ATTRIBUTE_ON', 'Attribute On')
			Case Else
				$mText = __GetLang('ATTRIBUTE_OFF', 'Attribute Off')
		EndSwitch
		GUICtrlSetData($mGUI_Items[$A][1], __GetLang('ATTRIBUTE_ON', 'Attribute On') & "|" & __GetLang('ATTRIBUTE_OFF', 'Attribute Off'), $mText)
	Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__GetLang('ADDITIONAL_FILTERS_LABEL_2', 'Others'), 10, 10 + 320, 459, 110)
	For $A = 9 To $STATIC_FILTERS_NUMBER - 1
		$mGUI_Items[$A][0] = GUICtrlCreateCheckbox($mCheckText[$A] & ":", 20, 80 + (30 * $A), 170, 20)
		If $mFilters[$A][0] = 1 Then
			GUICtrlSetState($mGUI_Items[$A][0], $GUI_CHECKED)
		EndIf
		If $A < 10 Then ; Included Files/Folders.
			$mGUI_Items[$A][2] = GUICtrlCreateInput($mFilters[$A][2], 20 + 170, 80 - 1 + (30 * $A), 270, 21)
			GUICtrlSetTip($mGUI_Items[$A][2], __GetLang('INCLUDED_FILES_LABEL_0', 'To consider only the folders that contain defined items (eg. *.jpg;*.png).'))
		Else ; File Content.
			$mGUI_Items[$A][1] = GUICtrlCreateCombo("", 20 + 170, 80 - 1 + (30 * $A), 270, 22, $WS_VSCROLL + $CBS_DROPDOWNLIST)
			Switch $mFilters[$A][1]
				Case "-"
					$mText = __GetLang('MANAGE_FILTER_LABEL_0', 'At least one of the words')
				Case ">"
					$mText = __GetLang('MANAGE_FILTER_LABEL_1', 'At least one of the words (case sensitive)')
				Case "x"
					$mText = __GetLang('MANAGE_FILTER_LABEL_2', 'All words in casual order')
				Case "+"
					$mText = __GetLang('MANAGE_FILTER_LABEL_3', 'All words in casual order (case sensitive)')
				Case "~"
					$mText = __GetLang('MANAGE_FILTER_LABEL_6', 'Regular expression')
				Case "="
					$mText = __GetLang('MANAGE_FILTER_LABEL_4', 'Literal string')
				Case Else
					$mText = __GetLang('MANAGE_FILTER_LABEL_5', 'Literal string (case sensitive)')
			EndSwitch
			GUICtrlSetData($mGUI_Items[$A][1], __GetLang('MANAGE_FILTER_LABEL_0', 'At least one of the words') & "|" & _
					__GetLang('MANAGE_FILTER_LABEL_1', 'At least one of the words (case sensitive)') & "|" & _
					__GetLang('MANAGE_FILTER_LABEL_2', 'All words in casual order') & "|" & _
					__GetLang('MANAGE_FILTER_LABEL_3', 'All words in casual order (case sensitive)') & "|" & _
					__GetLang('MANAGE_FILTER_LABEL_6', 'Regular expression') & "|" & _
					__GetLang('MANAGE_FILTER_LABEL_4', 'Literal string') & "|" & _
					__GetLang('MANAGE_FILTER_LABEL_5', 'Literal string (case sensitive)'), $mText)
			$mGUI_Items[$A][2] = GUICtrlCreateInput($mFilters[$A][2], 20, 80 - 1 + (30 * $A) + 30, 440, 21)
			GUICtrlSetTip($mGUI_Items[$A][2], __GetLang('MANAGE_FILTER_TIP_0', 'Separate words with a whitespace.'))
		EndIf
	Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	For $A = 0 To $STATIC_FILTERS_NUMBER - 1
		$mState = $GUI_DISABLE
		If GUICtrlRead($mGUI_Items[$A][0]) = 1 Then
			$mState = $GUI_ENABLE
		EndIf
		GUICtrlSetState($mGUI_Items[$A][1], $mState)
		GUICtrlSetState($mGUI_Items[$A][2], $mState)
		GUICtrlSetState($mGUI_Items[$A][3], $mState)
	Next

	$mSave = GUICtrlCreateButton(__GetLang('OK', 'OK'), 240 - 50 - 100, 450, 100, 24)
	$mCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 240 + 50, 450, 100, 24)
	GUICtrlSetState($mSave, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)

	While 1
		Sleep(25)
		If StringInStr(GUICtrlRead($mGUI_Items[9][2]), $STATIC_FILTERS_DIVIDER) Then
			MsgBox(0x30, __GetLang('MANAGE_EDIT_MSGBOX_34', 'Character restrictions'), __GetLang('MANAGE_EDIT_MSGBOX_37', 'You cannot use "|" character in this field.'), 0, __OnTop($mGUI))
			GUICtrlSetData($mGUI_Items[9][2], StringReplace(GUICtrlRead($mGUI_Items[9][2]), $STATIC_FILTERS_DIVIDER, ""))
		EndIf
		;check for | only if regular expression is not selected
		If StringInStr(GUICtrlRead($mGUI_Items[10][2]), $STATIC_FILTERS_DIVIDER) And Not (GUICtrlRead($mGUI_Items[10][1]) == __GetLang('MANAGE_FILTER_LABEL_5', 'Literal string (case sensitive)')) _
			And Not (GUICtrlRead($mGUI_Items[10][1]) == __GetLang('MANAGE_FILTER_LABEL_4', 'Literal string')) And Not (GUICtrlRead($mGUI_Items[10][1]) == __GetLang('MANAGE_FILTER_LABEL_6', 'Regular expression')) Then
			MsgBox(0x30, __GetLang('MANAGE_EDIT_MSGBOX_34', 'Character restrictions'), __GetLang('MANAGE_EDIT_MSGBOX_44', 'You cannot use "|" character in this field, unless literal string or regular expression is selected.'), 0, __OnTop($mGUI))
			GUICtrlSetData($mGUI_Items[10][2], StringReplace(GUICtrlRead($mGUI_Items[10][2]), $STATIC_FILTERS_DIVIDER, ""))
		EndIf

		For $A = 0 To 3
			If GUICtrlRead($mGUI_Items[$A][1]) <> $mCurrentCombo[$A] And Not _GUICtrlComboBox_GetDroppedState($mGUI_Items[$A][1]) Then
				$mCurrentCombo[$A] = GUICtrlRead($mGUI_Items[$A][1])
				If $mCurrentCombo[$A] = "=" Then
					GUICtrlSetPos($mGUI_Items[$A][2], 20 + 170 + 35, 30 - 1 + (30 * $A), 53, 22)
					GUICtrlSetTip($mGUI_Items[$A][2], __GetLang('VALUE_MIN', 'Min'))
					GUICtrlSetState($mGUI_Items[$A][4], $GUI_SHOW)
				Else
					GUICtrlSetPos($mGUI_Items[$A][2], 20 + 170 + 35, 30 - 1 + (30 * $A), 110, 22)
					GUICtrlSetTip($mGUI_Items[$A][2], __GetLang('VALUE', 'Value'))
					GUICtrlSetState($mGUI_Items[$A][4], $GUI_HIDE)
				EndIf
			EndIf
		Next

		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $mCancel
				SetError(1, 0, 0)
				ExitLoop

			Case $mGUI_Items[0][0], $mGUI_Items[1][0], $mGUI_Items[2][0], $mGUI_Items[3][0], $mGUI_Items[4][0], $mGUI_Items[5][0], $mGUI_Items[6][0], $mGUI_Items[7][0], $mGUI_Items[8][0], $mGUI_Items[9][0], $mGUI_Items[10][0]
				For $A = 0 To $STATIC_FILTERS_NUMBER - 1
					$mState = $GUI_DISABLE
					If GUICtrlRead($mGUI_Items[$A][0]) = 1 Then
						$mState = $GUI_ENABLE
					EndIf
					GUICtrlSetState($mGUI_Items[$A][1], $mState)
					GUICtrlSetState($mGUI_Items[$A][2], $mState)
					GUICtrlSetState($mGUI_Items[$A][3], $mState)
					GUICtrlSetState($mGUI_Items[$A][4], $mState)
				Next

			Case $mSave
				For $A = 0 To $STATIC_FILTERS_NUMBER - 1
					$mFilters[$A][0] = 0
					If GUICtrlRead($mGUI_Items[$A][0]) = 1 Then
						$mFilters[$A][0] = 1
					EndIf

					If $A < 4 Then ; Size, Dates.
						$mFilters[$A][1] = GUICtrlRead($mGUI_Items[$A][1])
						$mFilters[$A][2] = GUICtrlRead($mGUI_Items[$A][2])
						If $mFilters[$A][1] = "=" And $mFilters[$A][2] <> "" And Number(GUICtrlRead($mGUI_Items[$A][4])) > Number($mFilters[$A][2]) Then ; Add Range [100-300].
							$mFilters[$A][2] &= "-" & GUICtrlRead($mGUI_Items[$A][4])
						ElseIf $mFilters[$A][2] = 0 Or $mFilters[$A][2] = "" Then ; Reset Filter If Not Defined.
							$mFilters[$A][0] = 0
							$mFilters[$A][1] = ">"
							$mFilters[$A][2] = ""
						EndIf
						$mText = GUICtrlRead($mGUI_Items[$A][3])
						If $A = 0 Then
							$mText = __GetSizeStringCode($mText, 1)
						Else
							$mText = __GetTimeStringCode($mText, 1)
						EndIf
						$mFilters[$A][2] &= $mText

					ElseIf $A < 9 Then ; Attributes.
						$mFilters[$A][1] = "="
						Switch GUICtrlRead($mGUI_Items[$A][1])
							Case __GetLang('ATTRIBUTE_ON', 'Attribute On')
								$mText = "on"
							Case Else ; Attribute Off.
								$mText = "off"
						EndSwitch
						$mFilters[$A][2] = $mText

					ElseIf $A < 10 Then ; Included Files/Folders.
						$mFilters[$A][1] = "="
						$mFilters[$A][2] = GUICtrlRead($mGUI_Items[$A][2])
						If StringStripWS($mFilters[$A][2], 8) = "" Then ; Reset Filter If Not Defined.
							$mFilters[$A][0] = 0
							$mFilters[$A][2] = ""
						EndIf

					Else ; File Content.
						Switch GUICtrlRead($mGUI_Items[$A][1])
							Case __GetLang('MANAGE_FILTER_LABEL_0', 'At least one of the words')
								$mText = "-"
							Case __GetLang('MANAGE_FILTER_LABEL_1', 'At least one of the words (case sensitive)')
								$mText = ">"
							Case __GetLang('MANAGE_FILTER_LABEL_2', 'All words in casual order')
								$mText = "x"
							Case __GetLang('MANAGE_FILTER_LABEL_3', 'All words in casual order (case sensitive)')
								$mText = "+"
							Case __GetLang('MANAGE_FILTER_LABEL_6', 'Regular expression')
								$mText = "~"
							Case __GetLang('MANAGE_FILTER_LABEL_4', 'Literal string')
								$mText = "="
							Case Else ; Literal string (case sensitive).
								$mText = "<"
						EndSwitch
						$mFilters[$A][1] = $mText
						$mFilters[$A][2] = GUICtrlRead($mGUI_Items[$A][2])
						If StringStripWS($mFilters[$A][2], 8) = "" Then ; Reset Filter If Not Defined.
							$mFilters[$A][0] = 0
							$mFilters[$A][2] = ""
						EndIf
					EndIf
				Next
				ExitLoop

		EndSwitch
	WEnd
	GUIDelete($mGUI)

	Return 1
EndFunc   ;==>_Manage_Filters

Func _Manage_Gallery(ByRef $mProperties, ByRef $mThemeName, ByRef $mSettings, $mProfileName, $mHandle = -1)
	Local $mGUI, $mMsg, $mAdd, $mRemove, $mUp, $mDown, $mSave, $mCancel, $mTitle, $mValue, $mAbbreviation, $mStringSplit, $mQualityCombo, $mQualityCurrent, $mQuality = 2
	Local $mInput_Title, $mInput_Field, $mInput_Value, $mButton_TitleAbbreviations, $mButton_Abbreviations, $mListView, $mListView_Handle, $mIndex, $mIndex_Selected, $mNewProperties, $mCheck_LightThumbs
	Local $mThemeCombo, $mThemePreview, $mNoPreview, $mThemeArray, $mThemeGroup, $mThemeCurrent, $mPreviewCurrent, $mThemeFolder = @ScriptDir & "\Lib\gallery\themes"
	Local $mQualityGroup = __GetLang('GALLERY_QUALITY_1', 'Resize for low quality') & '|' & __GetLang('GALLERY_QUALITY_2', 'Resize for medium quality') & '|' & __GetLang('GALLERY_QUALITY_3', 'Resize for high quality') & '|' & __GetLang('GALLERY_QUALITY_4', 'Copy for best quality') & '|' & __GetLang('GALLERY_QUALITY_5', 'Link original files')

	$mGUI = GUICreate(__GetLang('MANAGE_EDIT_MSGBOX_12', 'Configure'), 420, 360, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	GUICtrlCreateTab(0, 0, 420, 323) ; Create Tab Menu.

	; GALLERY STYLE Tab:
	GUICtrlCreateTabItem(__GetLang('OPTIONS_TAB_7', 'Gallery Style'))
	GUICtrlSetState(-1, $GUI_SHOW)

	GUICtrlCreateLabel(__GetLang('OPTIONS_LABEL_22', 'Gallery Theme') & ":", 15, 10 + 22, 300, 20)
	$mThemeCombo = GUICtrlCreateCombo("", 15, 10 + 41, 390, 20, $WS_VSCROLL + $CBS_DROPDOWNLIST)
	$mThemePreview = GUICtrlCreatePic("", 15 + 30, 10 + 41 + 34, 330, 130)
	$mNoPreview = GUICtrlCreateLabel(__GetLang('OPTIONS_LABEL_18', 'Preview Not Available'), 15 + 85, 10 + 41 + 90, 130, 40)
	GUICtrlSetState($mNoPreview, $GUI_HIDE)
	GUICtrlCreateLabel(__GetLang('OPTIONS_LABEL_23', 'Image Quality') & ":", 15, 10 + 200 + 22, 300, 20)
	$mQualityCombo = GUICtrlCreateCombo("", 15, 10 + 200 + 41, 390, 20, $WS_VSCROLL + $CBS_DROPDOWNLIST)
	$mCheck_LightThumbs = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_37', 'Show previews at the bottom of the lightbox'), 15, 10 + 235 + 41, 390, 20)

	; GALLERY CONTENTS Tab:
	GUICtrlCreateTabItem(__GetLang('OPTIONS_TAB_8', 'Gallery Contents'))

	GUICtrlCreateLabel(__GetLang('OPTIONS_LABEL_24', 'Image Titles') & ":", 15, 10 + 22, 120, 20)
	$mInput_Title = GUICtrlCreateInput("%FileName%", 15, 10 + 41, 345, 22) ; %FileName% As Default Value.
	$mButton_TitleAbbreviations = GUICtrlCreateButton("A", 15 + 355, 10 + 39, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_TitleAbbreviations, __GetLang('MANAGE_EDIT_MSGBOX_8', 'Abbreviations'))
	GUICtrlSetImage($mButton_TitleAbbreviations, @ScriptFullPath, -8, 0)
	GUICtrlCreateLabel(__GetLang('FIELD', 'Field') & ":", 15, 10 + 60 + 22, 120, 20)
	$mInput_Field = GUICtrlCreateInput("", 15, 10 + 60 + 41, 130, 22)
	GUICtrlCreateLabel(__GetLang('VALUE', 'Value') & ":", 15 + 140, 10 + 60 + 22, 190, 20)
	$mInput_Value = GUICtrlCreateInput("", 15 + 140, 10 + 60 + 41, 205, 22)
	$mButton_Abbreviations = GUICtrlCreateButton("A", 15 + 355, 10 + 60 + 39, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Abbreviations, __GetLang('MANAGE_EDIT_MSGBOX_8', 'Abbreviations'))
	GUICtrlSetImage($mButton_Abbreviations, @ScriptFullPath, -8, 0)

	$mListView = GUICtrlCreateListView(__GetLang('FIELD', 'Field') & "|" & __GetLang('VALUE', 'Value'), 15, 10 + 60 + 75, 345, 160, BitOR($LVS_NOSORTHEADER, $LVS_REPORT, $LVS_SINGLESEL, $LVS_SHOWSELALWAYS))
	$mListView_Handle = GUICtrlGetHandle($mListView)
	$Global_ListViewCreateList = $mListView_Handle

	_GUICtrlListView_SetExtendedListViewStyle($mListView_Handle, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_INFOTIP))
	_GUICtrlListView_SetColumnWidth($mListView_Handle, 0, 140)
	_GUICtrlListView_SetColumnWidth($mListView_Handle, 1, 170)

	Local $mToolTip = _GUICtrlListView_GetToolTips($mListView_Handle)
	If IsHWnd($mToolTip) Then
		__OnTop($mToolTip, 1)
		_GUIToolTip_SetDelayTime($mToolTip, 3, 60) ; Speed Up InfoTip Appearance.
	EndIf

	$mAdd = GUICtrlCreateButton("+", 15 + 355, 109 + 40, 36, 25, $BS_ICON)
	GUICtrlSetTip($mAdd, __GetLang('OPTIONS_BUTTON_4', 'Add'))
	GUICtrlSetImage($mAdd, @ScriptFullPath, -10, 0)
	$mRemove = GUICtrlCreateButton("-", 15 + 355, 109 + 40 * 2, 36, 25, $BS_ICON)
	GUICtrlSetTip($mRemove, __GetLang('OPTIONS_BUTTON_3', 'Remove'))
	GUICtrlSetImage($mRemove, @ScriptFullPath, -11, 0)
	$mUp = GUICtrlCreateButton("U", 15 + 355, 109 + 40 * 3, 36, 25, $BS_ICON)
	GUICtrlSetTip($mUp, __GetLang('OPTIONS_BUTTON_6', 'Up'))
	GUICtrlSetImage($mUp, @ScriptFullPath, -12, 0)
	$mDown = GUICtrlCreateButton("D", 15 + 355, 109 + 40 * 4, 36, 25, $BS_ICON)
	GUICtrlSetTip($mDown, __GetLang('OPTIONS_BUTTON_7', 'Down'))
	GUICtrlSetImage($mDown, @ScriptFullPath, -13, 0)

	GUICtrlCreateTabItem("") ; Close Tab Menu.

	$mSave = GUICtrlCreateButton(__GetLang('OK', 'OK'), 210 - 50 - 90, 329, 90, 24)
	$mCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 210 + 50, 329, 90, 24)
	GUICtrlSetState($mSave, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)
	$Global_ListViewIndex = -1 ; Set As No Item Selected.
	GUIRegisterMsg($WM_NOTIFY, "_WM_NOTIFY")

	If $mProperties <> "" Then
		$mStringSplit = StringSplit($mProperties, ";")
		For $A = 1 To $mStringSplit[0] Step 2
			$mIndex = _GUICtrlListView_AddItem($mListView_Handle, $mStringSplit[$A])
			_GUICtrlListView_AddSubItem($mListView_Handle, $mIndex, $mStringSplit[$A + 1], 1)
		Next
	EndIf

	If $mSettings <> "" Then
		$mStringSplit = StringSplit($mSettings, ";")
		ReDim $mStringSplit[4]
		$mQuality = Number($mStringSplit[1])
		If Number($mStringSplit[2]) <> 0 Then
			GUICtrlSetState($mCheck_LightThumbs, $GUI_CHECKED)
		EndIf
		GUICtrlSetData($mInput_Title, $mStringSplit[3])
	EndIf

	$mThemeArray = __ThemeGallery_Array($mThemeFolder, 1)
	$mThemeGroup = $mThemeArray[0][1] ; [Dark|Default|Red].
	$mThemeCurrent = $mThemeName ; [Default].
	If $mThemeCurrent = "" Or StringInStr($mThemeGroup, $mThemeCurrent) = 0 Then
		$mThemeCurrent = "Default"
	EndIf

	$mPreviewCurrent = __ThemeGallery_Current($mThemeArray, $mThemeCurrent, 0) ; [theme-default].
	If FileExists($mThemeFolder & "\" & $mPreviewCurrent & ".jpg") Then
		GUICtrlSetImage($mThemePreview, $mThemeFolder & "\" & $mPreviewCurrent & ".jpg")
		GUICtrlSetState($mThemePreview, $GUI_SHOW)
		GUICtrlSetState($mNoPreview, $GUI_HIDE)
	Else
		GUICtrlSetState($mThemePreview, $GUI_HIDE)
		GUICtrlSetState($mNoPreview, $GUI_SHOW)
	EndIf
	GUICtrlSetData($mThemeCombo, $mThemeGroup, $mThemeCurrent)

	Switch $mQuality
		Case 5
			$mQualityCurrent = __GetLang('GALLERY_QUALITY_5', 'Link original files')
		Case 4
			$mQualityCurrent = __GetLang('GALLERY_QUALITY_4', 'Copy for best quality')
		Case 3
			$mQualityCurrent = __GetLang('GALLERY_QUALITY_3', 'Resize for high quality')
		Case 1
			$mQualityCurrent = __GetLang('GALLERY_QUALITY_1', 'Resize for low quality')
		Case Else
			$mQualityCurrent = __GetLang('GALLERY_QUALITY_2', 'Resize for medium quality')
	EndSwitch
	GUICtrlSetData($mQualityCombo, $mQualityGroup, $mQualityCurrent)

	Local $mHotKeys[3][2] = [["{UP}", $mUp],["{DOWN}", $mDown],["{DELETE}", $mRemove]]
	GUISetAccelerators($mHotKeys)

	_WinAPI_SetFocus(GUICtrlGetHandle($mInput_Title))
	_WinAPI_EmptyWorkingSet() ; Reduce Memory Usage Of DropIt.
	While 1
		Sleep(25)
		If StringRegExp(GUICtrlRead($mInput_Title) & GUICtrlRead($mInput_Field) & GUICtrlRead($mInput_Value), "[|;]") Then
			MsgBox(0x30, __GetLang('MANAGE_EDIT_MSGBOX_34', 'Character restrictions'), __GetLang('MANAGE_EDIT_MSGBOX_35', 'You cannot use "|" and ";" characters in this field.'), 0, __OnTop($mGUI))
			GUICtrlSetData($mInput_Title, StringRegExpReplace(GUICtrlRead($mInput_Title), "[|;]", ""))
			GUICtrlSetData($mInput_Field, StringRegExpReplace(GUICtrlRead($mInput_Field), "[|;]", ""))
			GUICtrlSetData($mInput_Value, StringRegExpReplace(GUICtrlRead($mInput_Value), "[|;]", ""))
		EndIf

		; Update Selected Item:
		If $mIndex_Selected <> $Global_ListViewIndex Then
			If $Global_ListViewIndex = -1 Then
				_GUICtrlListView_SetItemFocused($mListView_Handle, $mIndex_Selected, False)
			EndIf
			$mIndex_Selected = $Global_ListViewIndex
			$mTitle = ""
			$mValue = ""
			If $mIndex_Selected <> -1 Then
				$mTitle = _GUICtrlListView_GetItemText($mListView_Handle, $mIndex_Selected)
				$mValue = _GUICtrlListView_GetItemText($mListView_Handle, $mIndex_Selected, 1)
			EndIf
			GUICtrlSetData($mInput_Field, $mTitle)
			GUICtrlSetData($mInput_Value, $mValue)
		EndIf

		; Update Buttons State:
		If $mIndex_Selected = -1 Then
			If GUICtrlGetState($mRemove) = 80 Then
				GUICtrlSetState($mRemove, 144) ; $GUI_DISABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($mUp) = 80 Then
				GUICtrlSetState($mUp, 144) ; $GUI_DISABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($mDown) = 80 Then
				GUICtrlSetState($mDown, 144) ; $GUI_DISABLE + $GUI_SHOW.
			EndIf
		Else
			If GUICtrlGetState($mRemove) > 80 Then
				GUICtrlSetState($mRemove, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($mUp) > 80 Then
				GUICtrlSetState($mUp, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($mDown) > 80 Then
				GUICtrlSetState($mDown, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
		EndIf

		; Update Image Preview If Theme Changes:
		If GUICtrlRead($mThemeCombo) <> $mThemeCurrent And Not _GUICtrlComboBox_GetDroppedState($mThemeCombo) Then
			$mThemeCurrent = GUICtrlRead($mThemeCombo)
			$mPreviewCurrent = __ThemeGallery_Current($mThemeArray, $mThemeCurrent, 0) ; [theme-default].
			If FileExists($mThemeFolder & "\" & $mPreviewCurrent & ".jpg") Then
				GUICtrlSetImage($mThemePreview, $mThemeFolder & "\" & $mPreviewCurrent & ".jpg")
				GUICtrlSetState($mThemePreview, $GUI_SHOW)
				GUICtrlSetState($mNoPreview, $GUI_HIDE)
			Else
				GUICtrlSetState($mThemePreview, $GUI_HIDE)
				GUICtrlSetState($mNoPreview, $GUI_SHOW)
			EndIf
		EndIf

		; Enable/Disable Add Button:
		If GUICtrlRead($mInput_Value) <> "" Then
			If GUICtrlGetState($mAdd) > 80 Then
				GUICtrlSetState($mAdd, 576) ; $GUI_ENABLE + $GUI_DEFBUTTON.
			EndIf
			If GUICtrlGetState($mInput_Field) = 512 Then
				GUICtrlSetState($mInput_Field, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
		ElseIf GUICtrlRead($mInput_Value) = "" Then
			If GUICtrlGetState($mAdd) = 80 Then
				GUICtrlSetState($mAdd, 144) ; $GUI_DISABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($mInput_Field) = 80 Then
				GUICtrlSetState($mInput_Field, 512) ; $GUI_DEFBUTTON.
			EndIf
		EndIf

		$mMsg = GUIGetMsg()
		Switch $mMsg
			Case $GUI_EVENT_CLOSE, $mCancel
				ExitLoop

			Case $mSave
				If _GUICtrlListView_GetItemCount($mListView_Handle) > 0 Then
					For $A = 0 To _GUICtrlListView_GetItemCount($mListView_Handle) - 1
						$mTitle = _GUICtrlListView_GetItemText($mListView_Handle, $A)
						$mValue = _GUICtrlListView_GetItemText($mListView_Handle, $A, 1)
						$mNewProperties &= $mTitle & ";" & $mValue & ";"
					Next
				EndIf
				$mProperties = StringTrimRight($mNewProperties, 1) ; To Remove The Last ";" Character.
				$mThemeName = $mThemeCurrent
				Switch GUICtrlRead($mQualityCombo)
					Case __GetLang('GALLERY_QUALITY_5', 'Link original files')
						$mSettings = "5;"
					Case __GetLang('GALLERY_QUALITY_4', 'Copy for best quality')
						$mSettings = "4;"
					Case __GetLang('GALLERY_QUALITY_3', 'Resize for high quality')
						$mSettings = "3;"
					Case __GetLang('GALLERY_QUALITY_1', 'Resize for low quality')
						$mSettings = "1;"
					Case Else ; Resize for medium quality.
						$mSettings = "2;"
				EndSwitch
				If GUICtrlRead($mCheck_LightThumbs) = 1 Then
					$mSettings &= "1;"
				Else
					$mSettings &= "0;"
				EndIf
				$mSettings &= GUICtrlRead($mInput_Title)
				ExitLoop

			Case $mAdd
				$mTitle = GUICtrlRead($mInput_Field)
				$mValue = GUICtrlRead($mInput_Value)
				If _GUICtrlListView_GetItemState($mListView_Handle, $mIndex_Selected, $LVIS_SELECTED) Then
					_GUICtrlListView_SetItemText($mListView_Handle, $mIndex_Selected, $mTitle)
					_GUICtrlListView_SetItemText($mListView_Handle, $mIndex_Selected, $mValue, 1)
				Else
					$mIndex = _GUICtrlListView_AddItem($mListView_Handle, $mTitle)
					_GUICtrlListView_AddSubItem($mListView_Handle, $mIndex, $mValue, 1)
					GUICtrlSetData($mInput_Field, "")
					GUICtrlSetData($mInput_Value, "")
				EndIf
				_WinAPI_SetFocus(GUICtrlGetHandle($mInput_Field))

			Case $mRemove, $mUp, $mDown
				$mTitle = _GUICtrlListView_GetItemText($mListView_Handle, $mIndex_Selected)
				$mValue = _GUICtrlListView_GetItemText($mListView_Handle, $mIndex_Selected, 1)
				If $mMsg = $mRemove Then
					$Global_ListViewIndex = -1 ; Set As No Item Selected.
					_GUICtrlListView_DeleteItem($mListView_Handle, $mIndex_Selected)
					_GUICtrlListView_SetItemFocused($mListView_Handle, $mIndex_Selected - 1, False)
				ElseIf $mMsg = $mUp And $mIndex_Selected > 0 Then
					$Global_ListViewIndex = $mIndex_Selected - 1
					_GUICtrlListView_SetItemText($mListView_Handle, $mIndex_Selected, _GUICtrlListView_GetItemText($mListView_Handle, $Global_ListViewIndex))
					_GUICtrlListView_SetItemText($mListView_Handle, $mIndex_Selected, _GUICtrlListView_GetItemText($mListView_Handle, $Global_ListViewIndex, 1), 1)
					_GUICtrlListView_SetItemText($mListView_Handle, $Global_ListViewIndex, $mTitle)
					_GUICtrlListView_SetItemText($mListView_Handle, $Global_ListViewIndex, $mValue, 1)
					_GUICtrlListView_SetItemSelected($mListView_Handle, $Global_ListViewIndex, True, True)
				ElseIf $mMsg = $mDown And $mIndex_Selected < _GUICtrlListView_GetItemCount($mListView_Handle) - 1 Then
					$Global_ListViewIndex = $mIndex_Selected + 1
					_GUICtrlListView_SetItemText($mListView_Handle, $mIndex_Selected, _GUICtrlListView_GetItemText($mListView_Handle, $Global_ListViewIndex))
					_GUICtrlListView_SetItemText($mListView_Handle, $mIndex_Selected, _GUICtrlListView_GetItemText($mListView_Handle, $Global_ListViewIndex, 1), 1)
					_GUICtrlListView_SetItemText($mListView_Handle, $Global_ListViewIndex, $mTitle)
					_GUICtrlListView_SetItemText($mListView_Handle, $Global_ListViewIndex, $mValue, 1)
					_GUICtrlListView_SetItemSelected($mListView_Handle, $Global_ListViewIndex, True, True)
				EndIf

			Case $mButton_TitleAbbreviations
				$mAbbreviation = _Manage_ContextMenu_Abbreviations($mButton_TitleAbbreviations, $mProfileName, "ManageList", $mGUI) ; ManageList Also For Gallery.
				If $mAbbreviation <> -1 Then
					__InsertText($mInput_Title, "%" & $mAbbreviation & "%")
				EndIf
				GUIRegisterMsg($WM_COMMAND, "_WM_COMMAND") ; Needed To Restore _WM_COMMAND().
				_WinAPI_SetFocus(GUICtrlGetHandle($mInput_Title))

			Case $mButton_Abbreviations
				$mAbbreviation = _Manage_ContextMenu_Abbreviations($mButton_Abbreviations, $mProfileName, "ManageList", $mGUI) ; ManageList Also For Gallery.
				If $mAbbreviation <> -1 Then
					__InsertText($mInput_Value, "%" & $mAbbreviation & "%")
				EndIf
				GUIRegisterMsg($WM_COMMAND, "_WM_COMMAND") ; Needed To Restore _WM_COMMAND().
				_WinAPI_SetFocus(GUICtrlGetHandle($mInput_Value))

		EndSwitch
	WEnd
	GUIDelete($mGUI)

	Return 1 ; ByRef: $mProperties, $mThemeName, $mSettings.
EndFunc   ;==>_Manage_Gallery

Func _Manage_List(ByRef $mProperties, ByRef $mThemeName, ByRef $mSettings, $mProfileName, $mHandle = -1)
	Local $mGUI, $mMsg, $mAdd, $mRemove, $mUp, $mDown, $mSave, $mCancel, $mTitle, $mValue, $mAbbreviation, $mStringSplit, $mCheckItems[5]
	Local $mInput_Field, $mInput_Value, $mButton_Abbreviations, $mListView, $mListView_Handle, $mIndex, $mIndex_Selected, $mState
	Local $mThemeCombo, $mThemePreview, $mNoPreview, $mThemeGroup, $mThemeCurrent, $mThemeFolder = @ScriptDir & "\Lib\list\themes"

	$mGUI = GUICreate(__GetLang('MANAGE_EDIT_MSGBOX_12', 'Configure'), 420, 350, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	GUICtrlCreateTab(0, 0, 420, 313) ; Create Tab Menu.

	; LIST CONTENTS Tab:
	GUICtrlCreateTabItem(__GetLang('OPTIONS_TAB_9', 'List Contents'))
	GUICtrlSetState(-1, $GUI_SHOW)

	GUICtrlCreateLabel(__GetLang('FIELD', 'Field') & ":", 15, 10 + 22, 120, 20)
	$mInput_Field = GUICtrlCreateInput("", 15, 10 + 41, 130, 22)
	GUICtrlCreateLabel(__GetLang('VALUE', 'Value') & ":", 15 + 140, 10 + 22, 190, 20)
	$mInput_Value = GUICtrlCreateInput("", 15 + 140, 10 + 41, 205, 22)
	$mButton_Abbreviations = GUICtrlCreateButton("A", 15 + 355, 10 + 39, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Abbreviations, __GetLang('MANAGE_EDIT_MSGBOX_8', 'Abbreviations'))
	GUICtrlSetImage($mButton_Abbreviations, @ScriptFullPath, -8, 0)

	$mListView = GUICtrlCreateListView(__GetLang('FIELD', 'Field') & "|" & __GetLang('VALUE', 'Value'), 15, 10 + 75, 345, 200, BitOR($LVS_NOSORTHEADER, $LVS_REPORT, $LVS_SINGLESEL, $LVS_SHOWSELALWAYS))
	$mListView_Handle = GUICtrlGetHandle($mListView)
	$Global_ListViewCreateList = $mListView_Handle

	_GUICtrlListView_SetExtendedListViewStyle($mListView_Handle, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_INFOTIP))
	_GUICtrlListView_SetColumnWidth($mListView_Handle, 0, 140)
	_GUICtrlListView_SetColumnWidth($mListView_Handle, 1, 170)

	Local $mToolTip = _GUICtrlListView_GetToolTips($mListView_Handle)
	If IsHWnd($mToolTip) Then
		__OnTop($mToolTip, 1)
		_GUIToolTip_SetDelayTime($mToolTip, 3, 60) ; Speed Up InfoTip Appearance.
	EndIf

	$mAdd = GUICtrlCreateButton("+", 15 + 355, 49 + 50, 36, 25, $BS_ICON)
	GUICtrlSetTip($mAdd, __GetLang('OPTIONS_BUTTON_4', 'Add'))
	GUICtrlSetImage($mAdd, @ScriptFullPath, -10, 0)
	$mRemove = GUICtrlCreateButton("-", 15 + 355, 49 + 50 * 2, 36, 25, $BS_ICON)
	GUICtrlSetTip($mRemove, __GetLang('OPTIONS_BUTTON_3', 'Remove'))
	GUICtrlSetImage($mRemove, @ScriptFullPath, -11, 0)
	$mUp = GUICtrlCreateButton("U", 15 + 355, 49 + 50 * 3, 36, 25, $BS_ICON)
	GUICtrlSetTip($mUp, __GetLang('OPTIONS_BUTTON_6', 'Up'))
	GUICtrlSetImage($mUp, @ScriptFullPath, -12, 0)
	$mDown = GUICtrlCreateButton("D", 15 + 355, 49 + 50 * 4, 36, 25, $BS_ICON)
	GUICtrlSetTip($mDown, __GetLang('OPTIONS_BUTTON_7', 'Down'))
	GUICtrlSetImage($mDown, @ScriptFullPath, -13, 0)

	; LIST STYLE Tab:
	GUICtrlCreateTabItem(__GetLang('OPTIONS_TAB_10', 'List Style'))

	GUICtrlCreateLabel(__GetLang('OPTIONS_LABEL_17', 'HTML Theme') & ":", 15, 10 + 22, 300, 20)
	$mThemeCombo = GUICtrlCreateCombo("", 15, 10 + 41, 390, 20, $WS_VSCROLL + $CBS_DROPDOWNLIST)
	$mThemePreview = GUICtrlCreatePic("", 15 + 30, 10 + 41 + 34, 330, 120)
	$mNoPreview = GUICtrlCreateLabel(__GetLang('OPTIONS_LABEL_18', 'Preview Not Available'), 15 + 85, 10 + 41 + 84, 130, 40)
	GUICtrlSetState($mNoPreview, $GUI_HIDE)

	$mCheckItems[1] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_24', 'Create sortable HTML lists'), 15, 10 + 190 + 22)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_12', 'Allow to sort table content when you click the column header fields.'))
	$mCheckItems[2] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_25', 'Add filter to HTML lists'), 15, 10 + 190 + 22 + 20)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_13', 'Add a box where you can type words to filter table content.'))
	$mCheckItems[3] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_27', 'Add lightbox to HTML lists'), 15, 10 + 190 + 22 + 40)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_14', 'Open images from Absolute and Relative Links in an overlapped preview.'))
	$mCheckItems[4] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_26', 'Add the column titles to the lists'), 15, 10 + 190 + 22 + 60)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_22', 'It works for all list formats.'))

	GUICtrlCreateTabItem("") ; Close Tab Menu.

	$mSave = GUICtrlCreateButton(__GetLang('OK', 'OK'), 210 - 50 - 90, 319, 90, 24)
	$mCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 210 + 50, 319, 90, 24)
	GUICtrlSetState($mSave, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)
	$Global_ListViewIndex = -1 ; Set As No Item Selected.
	GUIRegisterMsg($WM_NOTIFY, "_WM_NOTIFY")

	If $mProperties = "" Then
		$mProperties = __DefaultListProperties()
	EndIf
	$mStringSplit = StringSplit($mProperties, ";")
	For $A = 1 To $mStringSplit[0] Step 2
		$mIndex = _GUICtrlListView_AddItem($mListView_Handle, $mStringSplit[$A])
		_GUICtrlListView_AddSubItem($mListView_Handle, $mIndex, $mStringSplit[$A + 1], 1)
	Next

	If $mSettings = "" Then
		$mSettings = __GetDefaultListSettings()
	EndIf
	$mStringSplit = StringSplit($mSettings, ";")
	ReDim $mStringSplit[5]
	For $A = 1 To 4
		If $mStringSplit[$A] == "True" Then
			GUICtrlSetState($mCheckItems[$A], $GUI_CHECKED)
		EndIf
	Next

	$mThemeGroup = __ThemeList_Combo($mThemeFolder)
	$mThemeCurrent = $mThemeName
	If $mThemeCurrent = "" Or StringInStr($mThemeGroup, $mThemeCurrent) = 0 Then
		$mThemeCurrent = "Default"
	EndIf

	If FileExists($mThemeFolder & "\" & $mThemeCurrent & ".jpg") Then
		GUICtrlSetImage($mThemePreview, $mThemeFolder & "\" & $mThemeCurrent & ".jpg")
		GUICtrlSetState($mThemePreview, $GUI_SHOW)
		GUICtrlSetState($mNoPreview, $GUI_HIDE)
	Else
		GUICtrlSetState($mThemePreview, $GUI_HIDE)
		GUICtrlSetState($mNoPreview, $GUI_SHOW)
	EndIf
	GUICtrlSetData($mThemeCombo, $mThemeGroup, $mThemeCurrent)

	Local $mHotKeys[3][2] = [["{UP}", $mUp],["{DOWN}", $mDown],["{DELETE}", $mRemove]]
	GUISetAccelerators($mHotKeys)

	_WinAPI_SetFocus(GUICtrlGetHandle($mInput_Field))
	_WinAPI_EmptyWorkingSet() ; Reduce Memory Usage Of DropIt.
	While 1
		Sleep(25)
		If StringRegExp(GUICtrlRead($mInput_Field) & GUICtrlRead($mInput_Value), "[|;]") Then
			MsgBox(0x30, __GetLang('MANAGE_EDIT_MSGBOX_34', 'Character restrictions'), __GetLang('MANAGE_EDIT_MSGBOX_35', 'You cannot use "|" and ";" characters in this field.'), 0, __OnTop($mGUI))
			GUICtrlSetData($mInput_Field, StringRegExpReplace(GUICtrlRead($mInput_Field), "[|;]", ""))
			GUICtrlSetData($mInput_Value, StringRegExpReplace(GUICtrlRead($mInput_Value), "[|;]", ""))
		EndIf

		; Update Selected Item:
		If $mIndex_Selected <> $Global_ListViewIndex Then
			If $Global_ListViewIndex = -1 Then
				_GUICtrlListView_SetItemFocused($mListView_Handle, $mIndex_Selected, False)
			EndIf
			$mIndex_Selected = $Global_ListViewIndex
			$mTitle = ""
			$mValue = ""
			If $mIndex_Selected <> -1 Then
				$mTitle = _GUICtrlListView_GetItemText($mListView_Handle, $mIndex_Selected)
				$mValue = _GUICtrlListView_GetItemText($mListView_Handle, $mIndex_Selected, 1)
			EndIf
			GUICtrlSetData($mInput_Field, $mTitle)
			GUICtrlSetData($mInput_Value, $mValue)
		EndIf

		; Update Buttons State:
		If $mIndex_Selected = -1 Then
			If GUICtrlGetState($mRemove) = 80 Then
				GUICtrlSetState($mRemove, 144) ; $GUI_DISABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($mUp) = 80 Then
				GUICtrlSetState($mUp, 144) ; $GUI_DISABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($mDown) = 80 Then
				GUICtrlSetState($mDown, 144) ; $GUI_DISABLE + $GUI_SHOW.
			EndIf
		Else
			If GUICtrlGetState($mRemove) > 80 Then
				GUICtrlSetState($mRemove, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($mUp) > 80 Then
				GUICtrlSetState($mUp, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($mDown) > 80 Then
				GUICtrlSetState($mDown, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
		EndIf

		; Update Image Preview If Theme Changes:
		If GUICtrlRead($mThemeCombo) <> $mThemeCurrent And Not _GUICtrlComboBox_GetDroppedState($mThemeCombo) Then
			$mThemeCurrent = GUICtrlRead($mThemeCombo)
			If FileExists($mThemeFolder & "\" & $mThemeCurrent & ".jpg") Then
				GUICtrlSetImage($mThemePreview, $mThemeFolder & "\" & $mThemeCurrent & ".jpg")
				GUICtrlSetState($mThemePreview, $GUI_SHOW)
				GUICtrlSetState($mNoPreview, $GUI_HIDE)
			Else
				GUICtrlSetState($mThemePreview, $GUI_HIDE)
				GUICtrlSetState($mNoPreview, $GUI_SHOW)
			EndIf
		EndIf

		; Enable/Disable Add Button:
		If StringStripWS(GUICtrlRead($mInput_Field), 8) <> "" And GUICtrlRead($mInput_Value) <> "" Then
			If GUICtrlGetState($mAdd) > 80 Then
				GUICtrlSetState($mAdd, 576) ; $GUI_ENABLE + $GUI_DEFBUTTON.
			EndIf
			If GUICtrlGetState($mInput_Field) = 512 Then
				GUICtrlSetState($mInput_Field, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
		ElseIf StringStripWS(GUICtrlRead($mInput_Field), 8) = "" Or GUICtrlRead($mInput_Value) = "" Then
			If GUICtrlGetState($mAdd) = 80 Then
				GUICtrlSetState($mAdd, 144) ; $GUI_DISABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($mInput_Field) = 80 Then
				GUICtrlSetState($mInput_Field, 512) ; $GUI_DEFBUTTON.
			EndIf
		EndIf

		$mMsg = GUIGetMsg()
		Switch $mMsg
			Case $GUI_EVENT_CLOSE, $mCancel
				ExitLoop

			Case $mSave
				If _GUICtrlListView_GetItemCount($mListView_Handle) < 1 Then
					ContinueLoop
				EndIf
				$mProperties = ""
				$mSettings = ""
				For $A = 0 To _GUICtrlListView_GetItemCount($mListView_Handle) - 1
					$mTitle = _GUICtrlListView_GetItemText($mListView_Handle, $A)
					$mValue = _GUICtrlListView_GetItemText($mListView_Handle, $A, 1)
					$mProperties &= $mTitle & ";" & $mValue & ";"
				Next
				For $A = 1 To 4
					$mState = "False"
					If GUICtrlRead($mCheckItems[$A]) = 1 Then
						$mState = "True"
					EndIf
					$mSettings &= $mState & ";"
				Next
				$mProperties = StringTrimRight($mProperties, 1) ; To Remove The Last ";" Character.
				$mSettings = StringTrimRight($mSettings, 1) ; To Remove The Last ";" Character.
				$mThemeName = $mThemeCurrent
				ExitLoop

			Case $mAdd
				$mTitle = GUICtrlRead($mInput_Field)
				$mValue = GUICtrlRead($mInput_Value)
				If _GUICtrlListView_GetItemState($mListView_Handle, $mIndex_Selected, $LVIS_SELECTED) Then
					_GUICtrlListView_SetItemText($mListView_Handle, $mIndex_Selected, $mTitle)
					_GUICtrlListView_SetItemText($mListView_Handle, $mIndex_Selected, $mValue, 1)
				Else
					$mIndex = _GUICtrlListView_AddItem($mListView_Handle, $mTitle)
					_GUICtrlListView_AddSubItem($mListView_Handle, $mIndex, $mValue, 1)
					GUICtrlSetData($mInput_Field, "")
					GUICtrlSetData($mInput_Value, "")
				EndIf
				_WinAPI_SetFocus(GUICtrlGetHandle($mInput_Field))

			Case $mRemove, $mUp, $mDown
				$mTitle = _GUICtrlListView_GetItemText($mListView_Handle, $mIndex_Selected)
				$mValue = _GUICtrlListView_GetItemText($mListView_Handle, $mIndex_Selected, 1)
				If $mMsg = $mRemove Then
					$Global_ListViewIndex = -1 ; Set As No Item Selected.
					_GUICtrlListView_DeleteItem($mListView_Handle, $mIndex_Selected)
					_GUICtrlListView_SetItemFocused($mListView_Handle, $mIndex_Selected - 1, False)
				ElseIf $mMsg = $mUp And $mIndex_Selected > 0 Then
					$Global_ListViewIndex = $mIndex_Selected - 1
					_GUICtrlListView_SetItemText($mListView_Handle, $mIndex_Selected, _GUICtrlListView_GetItemText($mListView_Handle, $Global_ListViewIndex))
					_GUICtrlListView_SetItemText($mListView_Handle, $mIndex_Selected, _GUICtrlListView_GetItemText($mListView_Handle, $Global_ListViewIndex, 1), 1)
					_GUICtrlListView_SetItemText($mListView_Handle, $Global_ListViewIndex, $mTitle)
					_GUICtrlListView_SetItemText($mListView_Handle, $Global_ListViewIndex, $mValue, 1)
					_GUICtrlListView_SetItemSelected($mListView_Handle, $Global_ListViewIndex, True, True)
				ElseIf $mMsg = $mDown And $mIndex_Selected < _GUICtrlListView_GetItemCount($mListView_Handle) - 1 Then
					$Global_ListViewIndex = $mIndex_Selected + 1
					_GUICtrlListView_SetItemText($mListView_Handle, $mIndex_Selected, _GUICtrlListView_GetItemText($mListView_Handle, $Global_ListViewIndex))
					_GUICtrlListView_SetItemText($mListView_Handle, $mIndex_Selected, _GUICtrlListView_GetItemText($mListView_Handle, $Global_ListViewIndex, 1), 1)
					_GUICtrlListView_SetItemText($mListView_Handle, $Global_ListViewIndex, $mTitle)
					_GUICtrlListView_SetItemText($mListView_Handle, $Global_ListViewIndex, $mValue, 1)
					_GUICtrlListView_SetItemSelected($mListView_Handle, $Global_ListViewIndex, True, True)
				EndIf

			Case $mButton_Abbreviations
				$mAbbreviation = _Manage_ContextMenu_Abbreviations($mButton_Abbreviations, $mProfileName, "ManageList", $mGUI)
				If $mAbbreviation <> -1 Then
					__InsertText($mInput_Value, "%" & $mAbbreviation & "%")
				EndIf
				GUIRegisterMsg($WM_COMMAND, "_WM_COMMAND") ; Needed To Restore _WM_COMMAND().
				_WinAPI_SetFocus(GUICtrlGetHandle($mInput_Value))

		EndSwitch
	WEnd
	GUIDelete($mGUI)

	Return 1 ; ByRef: $mProperties, $mThemeName.
EndFunc   ;==>_Manage_List

Func _Manage_Mail(ByRef $mSettings, $mHandle = -1)
	Local $mGUI, $mSave, $mCancel, $mStringSplit, $mText, $mCheckbox_Remove, $mButton_Servers, $mSelected[6], $mInput_Array[14], $mPassword_Code = $G_Global_PasswordKey

	$mStringSplit = StringSplit($mSettings, ";") ; 1 = Server, 2 = Port, 3 = SSL, 4 = Name, 5 = FromEmail, 6 = User, 7 = Password, 8 = ToEmail, 9 = Cc, 10 = Bcc, 11 = Subject, 12 = Body, 13 = SizeLimit, 14 = Remove Source.
	ReDim $mStringSplit[15] ; Number Of Settings.
	If $mStringSplit[2] = "" Then
		$mStringSplit[2] = 25
	EndIf
	If $mStringSplit[13] = "" Then
		$mStringSplit[13] = 10
	EndIf
	If $mStringSplit[7] <> "" Then
		$mStringSplit[7] = __StringEncrypt(0, $mStringSplit[7], $mPassword_Code)
	EndIf
	For $A = 8 To 12
		$mStringSplit[$A] = __ConvertMailText($mStringSplit[$A], 1)
	Next

	$mGUI = GUICreate(__GetLang('MANAGE_EDIT_MSGBOX_12', 'Configure'), 410, 310, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	GUICtrlCreateTab(0, 0, 410, 273) ; Create Tab Menu.

	; ACCOUNT Tab:
	GUICtrlCreateTabItem(__GetLang('MANAGE_MAIL_ACCOUNT', 'Account'))
	GUICtrlSetState(-1, $GUI_SHOW)
	$mButton_Servers = GUICtrlCreateButton("E", 15, 10 + 20, 30, 42, $BS_ICON)
	GUICtrlSetTip($mButton_Servers, __GetLang('MANAGE_MAIL_EXAMPLES', 'Server Examples'))
	GUICtrlSetImage($mButton_Servers, @ScriptFullPath, -19, 0)
	GUICtrlCreateLabel(__GetLang('MANAGE_MAIL_LABEL_0', 'SMTP Server') & ":", 15 + 40, 10 + 22, 200, 20)
	$mInput_Array[1] = GUICtrlCreateInput($mStringSplit[1], 15 + 40, 10 + 40, 200, 22)
	GUICtrlCreateLabel(__GetLang('SITE_LABEL_1', 'Port') & ":", 15 + 250, 10 + 22, 80, 20)
	$mInput_Array[2] = GUICtrlCreateInput($mStringSplit[2], 15 + 250, 10 + 40, 80, 22, 0x2000)
	$mInput_Array[3] = GUICtrlCreateCheckbox("SSL", 15 + 340, 10 + 41, 40, 20)
	If StringInStr($mStringSplit[3], "ssl") Then
		GUICtrlSetState($mInput_Array[3], $GUI_CHECKED)
	EndIf
	GUICtrlCreateLabel(__GetLang('MANAGE_MAIL_LABEL_1', 'Your name') & ":", 15, 10 + 22 + 50, 190, 20)
	$mInput_Array[4] = GUICtrlCreateInput($mStringSplit[4], 15, 10 + 40 + 50, 185, 22)
	GUICtrlCreateLabel(__GetLang('MANAGE_MAIL_LABEL_2', 'Email address') & ":", 15 + 195, 10 + 22 + 50, 190, 20)
	$mInput_Array[5] = GUICtrlCreateInput($mStringSplit[5], 15 + 195, 10 + 40 + 50, 185, 22)
	GUICtrlCreateLabel(__GetLang('SITE_LABEL_2', 'Username') & ":", 15, 10 + 22 + 100, 190, 20)
	$mInput_Array[6] = GUICtrlCreateInput($mStringSplit[6], 15, 10 + 40 + 100, 185, 22)
	GUICtrlSetTip($mInput_Array[6], __GetLang('MANAGE_MAIL_TIP_0', 'Generally as the email address or only the first part.'))
	GUICtrlCreateLabel(__GetLang('SITE_LABEL_3', 'Password') & ":", 15 + 195, 10 + 22 + 100, 190, 20)
	$mInput_Array[7] = GUICtrlCreateInput($mStringSplit[7], 15 + 195, 10 + 40 + 100, 185, 22, 0x0020)
	GUICtrlCreateLabel(__GetLang('MANAGE_MAIL_LABEL_7', 'Attachment size limit (MB)') & ":", 15, 10 + 22 + 150, 300, 20)
	$mInput_Array[13] = GUICtrlCreateInput($mStringSplit[13], 15, 10 + 40 + 150, 380, 22, 0x2000)
	GUICtrlSetTip($mInput_Array[13], __GetLang('MANAGE_MAIL_TIP_1', 'To send several files with a single mail, up to the defined size limit.'))
	$mCheckbox_Remove = GUICtrlCreateCheckbox(__GetLang('MANAGE_REMOVE_SOURCE', 'Remove source after processing it'), 15, 10 + 40 + 185, 380, 20)
	If $mStringSplit[14] == "True" Then
		GUICtrlSetState($mCheckbox_Remove, $GUI_CHECKED)
	EndIf

	; MESSAGE Tab:
	GUICtrlCreateTabItem(__GetLang('MANAGE_MAIL_MESSAGE', 'Predefined Message (Optional)'))
	GUICtrlCreateLabel(__GetLang('MAIL_TO', 'To') & ":", 15, 10 + 22, 300, 20)
	$mInput_Array[8] = GUICtrlCreateInput($mStringSplit[8], 15, 10 + 40, 380, 22)
	GUICtrlCreateLabel(__GetLang('MANAGE_MAIL_LABEL_3', 'Cc') & ":", 15, 10 + 22 + 50, 190, 20)
	$mInput_Array[9] = GUICtrlCreateInput($mStringSplit[9], 15, 10 + 40 + 50, 185, 22)
	GUICtrlCreateLabel(__GetLang('MANAGE_MAIL_LABEL_4', 'Bcc') & ":", 15 + 195, 10 + 22 + 50, 190, 20)
	$mInput_Array[10] = GUICtrlCreateInput($mStringSplit[10], 15 + 195, 10 + 40 + 50, 185, 22)
	GUICtrlCreateLabel(__GetLang('MANAGE_MAIL_LABEL_5', 'Subject') & ":", 15, 10 + 22 + 100, 300, 20)
	$mInput_Array[11] = GUICtrlCreateInput($mStringSplit[11], 15, 10 + 40 + 100, 380, 22)
	GUICtrlCreateLabel(__GetLang('MANAGE_MAIL_LABEL_6', 'Body') & ":", 15, 10 + 22 + 150, 300, 20)
	$mInput_Array[12] = GUICtrlCreateEdit($mStringSplit[12], 15, 10 + 40 + 150, 380, 60, BitOR($WS_VSCROLL, $ES_AUTOVSCROLL, $ES_WANTRETURN))

	GUICtrlCreateTabItem("") ; Close Tab Menu.

	$mSave = GUICtrlCreateButton(__GetLang('OK', 'OK'), 205 - 65 - 90, 279, 90, 24)
	$mCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 205 + 65, 279, 90, 24)
	GUICtrlSetState($mSave, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)

	While 1
		Sleep(50)
		For $A = 1 To 7
			If StringRegExp(GUICtrlRead($mInput_Array[$A]), "[|;]") Then
				MsgBox(0x30, __GetLang('MANAGE_EDIT_MSGBOX_34', 'Character restrictions'), __GetLang('MANAGE_EDIT_MSGBOX_35', 'You cannot use "|" and ";" characters in this field.'), 0, __OnTop($mGUI))
				GUICtrlSetData($mInput_Array[$A], StringRegExpReplace(GUICtrlRead($mInput_Array[$A]), "[|;]", ""))
			EndIf
		Next

		; Enable/Disable Save Button:
		If GUICtrlRead($mInput_Array[1]) <> "" And GUICtrlRead($mInput_Array[2]) <> "" And GUICtrlRead($mInput_Array[5]) <> "" And GUICtrlRead($mInput_Array[6]) <> "" And GUICtrlRead($mInput_Array[7]) <> "" And GUICtrlRead($mInput_Array[13]) <> "" Then
			If GUICtrlGetState($mSave) > 80 Then
				GUICtrlSetState($mSave, 576) ; $GUI_ENABLE + $GUI_DEFBUTTON.
			EndIf
			If GUICtrlGetState($mCancel) = 512 Then
				GUICtrlSetState($mCancel, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
		ElseIf GUICtrlRead($mInput_Array[1]) = "" Or GUICtrlRead($mInput_Array[2]) = "" Or GUICtrlRead($mInput_Array[5]) = "" Or GUICtrlRead($mInput_Array[6]) = "" Or GUICtrlRead($mInput_Array[7]) = "" Or GUICtrlRead($mInput_Array[13]) = "" Then
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
				$mSettings = ""
				For $A = 1 To 13
					$mText = GUICtrlRead($mInput_Array[$A])
					If $A = 3 Then ; SSL Checkbox.
						If $mText = 1 Then
							$mText = "ssl"
						Else
							$mText = ""
						EndIf
					ElseIf $A = 7 Then ; Password.
						If StringIsSpace($mText) = 0 And $mText <> "" Then
							$mText = __StringEncrypt(1, $mText, $mPassword_Code)
						EndIf
					ElseIf $A >= 8 And $A <= 12 Then ; Predefined Message.
						$mText = __ConvertMailText($mText, 0)
					ElseIf $A = 13 Then ; Size Limit.
						If $mText < 0 Then
							$mText = 0 ; Set 0 Force To Send One File Per Mail.
						EndIf
					EndIf
					$mSettings &= $mText & ";"
				Next
				$mText = "False"
				If GUICtrlRead($mCheckbox_Remove) = 1 Then
					$mText = "True"
				EndIf
				$mSettings &= $mText
				ExitLoop

			Case $mButton_Servers
				$mSelected = _Manage_ContextMenu_Servers($mButton_Servers)
				If @error = 0 Then
					GUICtrlSetData($mInput_Array[1], $mSelected[1])
					GUICtrlSetData($mInput_Array[2], $mSelected[2])
					If $mSelected[3] = 1 Then
						GUICtrlSetState($mInput_Array[3], $GUI_CHECKED)
					Else
						GUICtrlSetState($mInput_Array[3], $GUI_UNCHECKED)
					EndIf
					GUICtrlSetData($mInput_Array[5], $mSelected[4])
					GUICtrlSetData($mInput_Array[6], $mSelected[5])
					GUICtrlSetData($mInput_Array[13], $mSelected[6])
				EndIf

		EndSwitch
	WEnd
	GUIDelete($mGUI)

	Return 1 ; ByRef: $mSettings.
EndFunc   ;==>_Manage_Mail

Func _Manage_OpenWith(ByRef $mSettings, $mHandle = -1)
	Local $mGUI, $mSave, $mCancel, $mStringSplit, $mCheckbox_Wait, $mWait, $mCheckbox_Remove, $mRemove

	$mStringSplit = StringSplit($mSettings, "|") ; 1 = Wait Opened, 2 = Remove Source.
	ReDim $mStringSplit[3] ; Number Of Settings.

	$mGUI = GUICreate(__GetLang('MANAGE_EDIT_MSGBOX_12', 'Configure'), 340, 105, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	$mCheckbox_Wait = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_18', 'Pause until opened file is closed'), 15, 12, 310, 20)
	$mCheckbox_Remove = GUICtrlCreateCheckbox(__GetLang('MANAGE_REMOVE_SOURCE', 'Remove source after processing it'), 15, 12 + 20, 310, 20)
	If $mStringSplit[1] == "True" Then
		GUICtrlSetState($mCheckbox_Wait, $GUI_CHECKED)
		If $mStringSplit[2] == "True" Then
			GUICtrlSetState($mCheckbox_Remove, $GUI_CHECKED)
		EndIf
	Else
		GUICtrlSetState($mCheckbox_Remove, $GUI_DISABLE)
	EndIf

	$mSave = GUICtrlCreateButton(__GetLang('OK', 'OK'), 170 - 40 - 90, 70, 90, 24)
	$mCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 170 + 40, 70, 90, 24)
	GUICtrlSetState($mSave, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $mCancel
				ExitLoop

			Case $mCheckbox_Wait
				If GUICtrlRead($mCheckbox_Wait) = 1 Then
					GUICtrlSetState($mCheckbox_Remove, $GUI_ENABLE)
				Else
					GUICtrlSetState($mCheckbox_Remove, $GUI_UNCHECKED)
					GUICtrlSetState($mCheckbox_Remove, $GUI_DISABLE)
				EndIf

			Case $mSave
				$mWait = "False"
				$mRemove = "False"
				If GUICtrlRead($mCheckbox_Wait) = 1 Then
					$mWait = "True"
					If GUICtrlRead($mCheckbox_Remove) = 1 Then
						$mRemove = "True"
					EndIf
				EndIf
				$mSettings = $mWait & "|" & $mRemove
				ExitLoop

		EndSwitch
	WEnd
	GUIDelete($mGUI)

	Return 1 ; ByRef: $mSettings.
EndFunc   ;==>_Manage_OpenWith

Func _Manage_Properties(ByRef $mProperties, $mHandle = -1)
	Local $mGUI, $mSave, $mCancel, $mStringSplit, $mState, $mText, $B, $mDates[3][8], $mAttributes[5][2]
	Local $DTM_SETFORMAT_ = 0x1032 ; $DTM_SETFORMATW
	Local $mTitles[8] = [ _
			__GetLang('ENV_VAR_TAB_6', 'Created'), _
			__GetLang('ENV_VAR_TAB_7', 'Modified'), _
			__GetLang('ENV_VAR_TAB_8', 'Opened'), _
			__GetLang('CHANGE_PROPERTIES_ATTRIBUTE_0', 'Archive'), _
			__GetLang('CHANGE_PROPERTIES_ATTRIBUTE_1', 'Hidden'), _
			__GetLang('CHANGE_PROPERTIES_ATTRIBUTE_2', 'Read-Only'), _
			__GetLang('CHANGE_PROPERTIES_ATTRIBUTE_3', 'System'), _
			__GetLang('CHANGE_PROPERTIES_ATTRIBUTE_4', 'Temporary')]
	Local $mCombo[4] = [ _
			__GetLang('CHANGE_PROPERTIES_MODE_0', 'No Change'), _
			__GetLang('CHANGE_PROPERTIES_MODE_1', 'Turn On'), _
			__GetLang('CHANGE_PROPERTIES_MODE_2', 'Turn Off'), _
			__GetLang('CHANGE_PROPERTIES_MODE_3', 'Switch')]

	$mStringSplit = StringSplit($mProperties, ";") ; {modified} YYYYMMDD;HHMMSS;0h; {created} YYYYMMDD;HHMMSS;0h; {opened} YYYYMMDD;HHMMSS;0h; {attributes} A0;H0;R0;S0;T0
	ReDim $mStringSplit[15] ; Number Of Settings.

	$mGUI = GUICreate(__GetLang('MANAGE_EDIT_MSGBOX_12', 'Configure'), 600, 280, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

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
		$mText = __GetTimeStringCode(StringRight($mStringSplit[$B + 2], 1), 0)
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
		$mText = __GetPropertyStringCode(Number(StringRight($mStringSplit[$A + 10], 1)), 0)
		GUICtrlSetData($mAttributes[$A][0], $mCombo[0] & "|" & $mCombo[1] & "|" & $mCombo[2] & "|" & $mCombo[3], $mText)
	Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$mSave = GUICtrlCreateButton(__GetLang('OK', 'OK'), 300 - 70 - 90, 245, 90, 24)
	$mCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 300 + 70, 245, 90, 24)
	GUICtrlSetState($mSave, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $mCancel
				ExitLoop

			Case $mDates[0][0], $mDates[0][2], $mDates[0][4], $mDates[1][0], $mDates[1][2], $mDates[1][4], $mDates[2][0], $mDates[2][2], $mDates[2][4]
				For $A = 0 To 2
					For $B = 0 To 4 Step 2
						$mState = $GUI_DISABLE
						If GUICtrlRead($mDates[$A][$B]) = 1 Then
							$mState = $GUI_ENABLE
						EndIf
						GUICtrlSetState($mDates[$A][$B + 1], $mState)
					Next
					GUICtrlSetState($mDates[$A][6], $mState)
					GUICtrlSetState($mDates[$A][7], $mState)
				Next

			Case $mSave
				$mProperties = ""
				For $A = 0 To 2
					If GUICtrlRead($mDates[$A][0]) = 1 Then
						GUICtrlSendMsg($mDates[$A][1], $DTM_SETFORMAT_, 0, "yyyy/MM/dd") ; To Set Standard Date Format.
						$mProperties &= StringRegExpReplace(GUICtrlRead($mDates[$A][1]), "[^0-9]", "")
					EndIf
					$mProperties &= ";"

					If GUICtrlRead($mDates[$A][2]) = 1 Then
						GUICtrlSendMsg($mDates[$A][3], $DTM_SETFORMAT_, 0, "HH:mm:ss") ; To Set Standard Time Format.
						$mProperties &= StringRegExpReplace(GUICtrlRead($mDates[$A][3]), "[^0-9]", "")
					EndIf
					$mProperties &= ";"

					If GUICtrlRead($mDates[$A][4]) = 1 And GUICtrlRead($mDates[$A][6]) <> "" Then
						$mText = ""
						If GUICtrlRead($mDates[$A][5]) = "-" Then
							$mText = "-"
						EndIf
						$mState = __GetTimeStringCode(GUICtrlRead($mDates[$A][7]), 1)
						$mProperties &= $mText & GUICtrlRead($mDates[$A][6]) & $mState
					EndIf
					$mProperties &= ";"
				Next

				For $A = 0 To 4
					$mText = __GetPropertyStringCode(GUICtrlRead($mAttributes[$A][0]), 1)
					$mProperties &= $mAttributes[$A][1] & $mText & ";"
				Next
				$mProperties = StringTrimRight($mProperties, 1)
				ExitLoop

		EndSwitch
	WEnd
	GUIDelete($mGUI)

	Return 1 ; ByRef: $mProperties.
EndFunc   ;==>_Manage_Properties

Func _Manage_Site(ByRef $mSettings, $mHandle = -1)
	Local $mGUI, $mSave, $mCancel, $mStringSplit, $mCheckbox_Remove, $mRemove, $mHost, $mPassword, $mPassword_Code = $G_Global_PasswordKey
	Local $mInput_Host, $mInput_Port, $mInput_User, $mInput_Password, $mCombo_Protocol, $mCurrentProtocol
	Local $mString_FTP = "FTP - File Transfer Protocol", $mString_FTPP = "FTP - File Transfer Protocol (Passive Mode)", $mString_SFTP = "SFTP - SSH File Transfer Protocol"

	$mStringSplit = StringSplit($mSettings, ";") ; 1 = Host, 2 = Port, 3 = User, 4 = Password, 5 = Protocol, 6 = Remove Source.
	ReDim $mStringSplit[7] ; Number Of Settings.
	If $mStringSplit[5] = "SFTP" Then
		$mCurrentProtocol = $mString_SFTP
		If $mStringSplit[2] = "" Then
			$mStringSplit[2] = 22
		EndIf
	Else
		If $mStringSplit[5] = "FTPP" Then
			$mCurrentProtocol = $mString_FTPP
		Else
			$mCurrentProtocol = $mString_FTP
		EndIf
		If $mStringSplit[2] = "" Then
			$mStringSplit[2] = 21
		EndIf
	EndIf
	If $mStringSplit[4] <> "" Then
		$mStringSplit[4] = __StringEncrypt(0, $mStringSplit[4], $mPassword_Code)
	EndIf

	$mGUI = GUICreate(__GetLang('MANAGE_EDIT_MSGBOX_12', 'Configure'), 360, 235, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	GUICtrlCreateLabel(__GetLang('SITE_LABEL_0', 'Host') & ":", 15, 12, 200, 20)
	$mInput_Host = GUICtrlCreateInput($mStringSplit[1], 10, 30, 250, 22)
	GUICtrlCreateLabel(__GetLang('SITE_LABEL_1', 'Port') & ":", 15 + 260, 12, 80, 20)
	$mInput_Port = GUICtrlCreateInput($mStringSplit[2], 10 + 260, 30, 80, 22, 0x2000)
	GUICtrlSetTip($mInput_Port, __GetLang('SITE_TIP_0', 'Leave empty to use the default port.'))
	GUICtrlCreateLabel(__GetLang('SITE_LABEL_2', 'Username') & ":", 15, 12 + 50, 200, 20)
	$mInput_User = GUICtrlCreateInput($mStringSplit[3], 10, 30 + 50, 165, 22)
	GUICtrlSetTip($mInput_User, __GetLang('SITE_TIP_1', 'Leave empty to connect as anonymous.'))
	GUICtrlCreateLabel(__GetLang('SITE_LABEL_3', 'Password') & ":", 15 + 175, 12 + 50, 200, 20)
	$mInput_Password = GUICtrlCreateInput($mStringSplit[4], 10 + 175, 30 + 50, 165, 22, 0x0020)
	GUICtrlSetTip($mInput_Password, __GetLang('SITE_TIP_2', 'Leave empty if not required.'))
	GUICtrlCreateLabel(__GetLang('SITE_LABEL_4', 'Protocol') & ":", 15, 12 + 100, 200, 20)
	$mCombo_Protocol = GUICtrlCreateCombo("", 10, 30 + 100, 340, 22, $WS_VSCROLL + $CBS_DROPDOWNLIST)
	GUICtrlSetData($mCombo_Protocol, $mString_FTP & "|" & $mString_FTPP & "|" & $mString_SFTP, $mCurrentProtocol)
	$mCheckbox_Remove = GUICtrlCreateCheckbox(__GetLang('MANAGE_REMOVE_SOURCE', 'Remove source after processing it'), 15, 12 + 150, 330, 20)
	If $mStringSplit[6] == "True" Then
		GUICtrlSetState($mCheckbox_Remove, $GUI_CHECKED)
	EndIf

	$mSave = GUICtrlCreateButton(__GetLang('OK', 'OK'), 180 - 40 - 90, 200, 90, 24)
	$mCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 180 + 40, 200, 90, 24)
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
			ElseIf $mCurrentProtocol <> $mString_SFTP And GUICtrlRead($mInput_Port) = 22 Then
				GUICtrlSetData($mInput_Port, 21)
			EndIf
		EndIf

		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $mCancel
				ExitLoop

			Case $mSave
				$mHost = StringReplace(GUICtrlRead($mInput_Host), "ftp:\\", "ftp.") ; To Fix A Possible User Wrong Setting.
				If StringRight($mHost, 1) = "/" Then
					$mHost = StringTrimRight($mHost, 1)
				EndIf
				$mPassword = GUICtrlRead($mInput_Password)
				If StringIsSpace($mPassword) = 0 And $mPassword <> "" Then
					$mPassword = __StringEncrypt(1, $mPassword, $mPassword_Code)
				Else
					$mPassword = ""
				EndIf
				$mSettings = $mHost & ";" & GUICtrlRead($mInput_Port) & ";" & GUICtrlRead($mInput_User) & ";" & $mPassword & ";"
				If GUICtrlRead($mCombo_Protocol) = $mString_SFTP Then
					$mSettings &= "SFTP;"
				ElseIf GUICtrlRead($mCombo_Protocol) = $mString_FTPP Then
					$mSettings &= "FTPP;"
				Else
					$mSettings &= "FTP;"
				EndIf
				$mRemove = "False"
				If GUICtrlRead($mCheckbox_Remove) = 1 Then
					$mRemove = "True"
				EndIf
				$mSettings &= $mRemove
				ExitLoop

		EndSwitch
	WEnd
	GUIDelete($mGUI)

	Return 1 ; ByRef: $mSettings.
EndFunc   ;==>_Manage_Site

Func _Manage_Split(ByRef $mSettings, $mHandle = -1)
	Local $mGUI, $mSave, $mCancel, $mStringSplit, $mInput_Size, $mCombo_Size, $mCheckbox_Remove, $mRemove

	$mStringSplit = StringSplit($mSettings, ";") ; 1 = Size Number, 2 = Size Text, 3 = Remove Source.
	ReDim $mStringSplit[4] ; Number Of Settings.
	If $mStringSplit[1] = "" Then
		$mStringSplit[1] = "10"
	EndIf
	If $mStringSplit[2] = "" Then
		$mStringSplit[2] = "MB"
	EndIf

	$mGUI = GUICreate(__GetLang('MANAGE_EDIT_MSGBOX_12', 'Configure'), 340, 135, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	GUICtrlCreateLabel(__GetLang('MANAGE_SPLIT_LABEL_0', 'Split file size') & ":", 15, 12, 200, 20)
	$mInput_Size = GUICtrlCreateInput($mStringSplit[1], 10, 30, 210, 22, 0x2000)
	$mCombo_Size = GUICtrlCreateCombo("", 10 + 220, 30, 100, 22, $WS_VSCROLL + $CBS_DROPDOWNLIST)
	GUICtrlSetData($mCombo_Size, __GetLang('SIZE_B', 'bytes') & "|" & __GetLang('SIZE_KB', 'KB') & "|" & __GetLang('SIZE_MB', 'MB'), __GetSizeStringCode($mStringSplit[2], 0))

	$mCheckbox_Remove = GUICtrlCreateCheckbox(__GetLang('MANAGE_REMOVE_SOURCE', 'Remove source after processing it'), 15, 12 + 50, 310, 20)
	If $mStringSplit[3] == "True" Then
		GUICtrlSetState($mCheckbox_Remove, $GUI_CHECKED)
	EndIf

	$mSave = GUICtrlCreateButton(__GetLang('OK', 'OK'), 170 - 40 - 90, 100, 90, 24)
	$mCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 170 + 40, 100, 90, 24)
	GUICtrlSetState($mSave, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)

	While 1
		; Enable/Disable Save Button:
		If GUICtrlRead($mInput_Size) <> "" And StringIsSpace(GUICtrlRead($mInput_Size)) = 0 Then
			If GUICtrlGetState($mSave) > 80 Then
				GUICtrlSetState($mSave, 576) ; $GUI_ENABLE + $GUI_DEFBUTTON.
			EndIf
			If GUICtrlGetState($mCancel) = 512 Then
				GUICtrlSetState($mCancel, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
		ElseIf GUICtrlRead($mInput_Size) = "" Or StringIsSpace(GUICtrlRead($mInput_Size)) Then
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
				$mRemove = "False"
				If GUICtrlRead($mCheckbox_Remove) = 1 Then
					$mRemove = "True"
				EndIf
				$mSettings = GUICtrlRead($mInput_Size) & ";" & __GetSizeStringCode(GUICtrlRead($mCombo_Size), 1) & ";" & $mRemove
				ExitLoop

		EndSwitch
	WEnd
	GUIDelete($mGUI)

	Return 1 ; ByRef: $mSettings.
EndFunc   ;==>_Manage_Split

Func _Manage_ContextMenu_Abbreviations($mButton_Abbreviations, $mProfile, $mCurrentAction, $mHandle = -1)
	Local $mGroupPaths[14][3] = [ _
			[13, 0, 0], _
			["FileNameExt", __GetLang('ENV_VAR_11', 'file name with extension') & ' ["Text.txt"]'], _
			["FileName", __GetLang('ENV_VAR_10', 'file name without extension') & ' ["Text"]'], _
			["FileExt", __GetLang('ENV_VAR_9', 'file extension') & ' ["txt"]'], _
			["FileDrive", __GetLang('ENV_VAR_102', 'file drive') & ' ["C:"]'], _
			["ParentDir", __GetLang('ENV_VAR_13', 'directory of loaded file') & ' ["C:\Docs"]'], _
			["ParentDirName", __GetLang('ENV_VAR_29', 'directory name of loaded file') & ' ["Docs"]'], _
			["DroppedDir", __GetLang('ENV_VAR_127', 'dropped directory of loaded file') & ' ["C:\Folder"]'], _
			["DroppedDirName", __GetLang('ENV_VAR_128', 'dropped directory name of loaded file') & ' ["Folder"]'], _
			["SubDir", __GetLang('ENV_VAR_21', 'recreate subdirectory structure') & ' ["\SubFolder"]'], _
			[""], _ ; Separator.
			["File", __GetLang('ENV_VAR_7', 'file full path') & ' ["C:\Docs\Text.txt"]'], _ ; Only By Open With.
			["LinkAbsolute", __GetLang('ENV_VAR_103', 'file absolute link') & ' ["C:\Docs\Text.txt"]'], _
			["LinkRelative", __GetLang('ENV_VAR_104', 'file relative link') & ' ["..\Text.txt"]']]
	Local $mGroupInfo[17][3] = [ _
			[16, 0, 0], _
			["Attributes", __GetLang('ENV_VAR_74', 'file attributes') & ' ["RA"]'], _
			["Authors", __GetLang('ENV_VAR_8', 'file authors') & ' ["Lupo Team"]'], _
			["Category", __GetLang('ENV_VAR_84', 'file category') & ' ["Personal"]'], _
			["Comments", __GetLang('ENV_VAR_75', 'file comments') & ' ["Comment example"]'], _
			["Company", __GetLang('ENV_VAR_85', 'file company') & ' ["Sourceforge"]'], _
			["Copyright", __GetLang('ENV_VAR_76', 'file copyright') & ' ["Lupo PenSuite"]'], _
			["FileBytes", __GetLang('ENV_VAR_100', 'file bytes') & ' ["' & __GetFileSize(@ScriptFullPath) & '"]'], _
			["FileVersion", __GetLang('ENV_VAR_109', 'file version') & ' ["' & FileGetVersion(@ScriptFullPath) & '"]'], _
			["FileSize", __GetLang('ENV_VAR_101', 'file size') & ' ["' & __ByteSuffix(__GetFileSize(@ScriptFullPath)) & '"]'], _
			["FileType", __GetLang('ENV_VAR_12', 'file type') & ' ["Text document"]'], _
			["Keywords", __GetLang('ENV_VAR_134', 'file keywords') & ' ["Alternate,Bill"]'], _
			["Owner", __GetLang('ENV_VAR_77', 'file owner') & ' ["Lupo73"]'], _
			["ProductName", __GetLang('ENV_VAR_130', 'file product name') & ' ["DropIt"]'], _
			["Rating", __GetLang('ENV_VAR_129', 'file rating') & ' ["4"]'], _
			["Subject", __GetLang('ENV_VAR_86', 'file subject') & ' ["Examples"]'], _
			["Pages", __GetLang('ENV_VAR_144', 'number of pages') & ' ["5"]']]
	Local $mGroupImage[35][3] = [ _
			[34, 0, 0], _
			["Dimensions", __GetLang('ENV_VAR_64', 'image dimensions') & ' ["4912 x 3264"]'], _
			["Megapixels", __GetLang('ENV_VAR_67', 'image megapixels') & ' ["16"]'], _
			["ImageWidth", __GetLang('ENV_VAR_110', 'image width') & ' ["4912"]'], _
			["ImageHeight", __GetLang('ENV_VAR_111', 'image height') & ' ["3264"]'], _
			["XResolution", __GetLang('ENV_VAR_112', 'image horizontal resolution') & ' ["350"]'], _
			["YResolution", __GetLang('ENV_VAR_113', 'image vertical resolution') & ' ["350"]'], _
			["ResolutionUnit", __GetLang('ENV_VAR_114', 'image resolution unit') & ' ["Inch"]'], _
			[""], _ ; Separator.
			["CameraMaker", __GetLang('ENV_VAR_88', 'image camera maker') & ' ["SONY"]'], _
			["CameraModel", __GetLang('ENV_VAR_63', 'image camera model') & ' ["NEX-5N"]'], _
			["ExposureTime", __GetLang('ENV_VAR_90', 'exposure time') & ' ["0.00625"]'], _
			["ExposureTimeFraction", __GetLang('ENV_VAR_91', 'exposure time fraction') & ' ["160"]'], _
			["FNumber", __GetLang('ENV_VAR_92', 'camera aperture') & ' ["5.6"]'], _
			["MaxApertureValue", __GetLang('ENV_VAR_116', 'camera max aperture') & ' ["4"]'], _
			["FocalLength", __GetLang('ENV_VAR_93', 'camera focal length') & ' ["35"]'], _
			["ImageComments", __GetLang('ENV_VAR_107', 'image comments') & ' ["funny"]'], _
			["ImageDescription", __GetLang('ENV_VAR_108', 'image description') & ' ["moon"]'], _
			["ImageOrientation", __GetLang('ENV_VAR_115', 'image orientation') & ' ["90° left"]'], _
			["ISO", __GetLang('ENV_VAR_94', 'image ISO') & ' ["400"]'], _
			[""], _ ; Separator.
			["Brightness", __GetLang('ENV_VAR_87', 'image brightness') & ' ["1.24"]'], _
			["ContrastLevel", __GetLang('ENV_VAR_117', 'image contrast level') & ' ["Normal"]'], _
			["SaturationLevel", __GetLang('ENV_VAR_118', 'image saturation level') & ' ["Normal"]'], _
			["SharpnessLevel", __GetLang('ENV_VAR_119', 'image sharpness level') & ' ["Normal"]'], _
			["ExposureBias", __GetLang('ENV_VAR_89', 'exposure value') & ' ["0.5"]'], _
			["ExposureMode", __GetLang('ENV_VAR_120', 'exposure mode') & ' ["Manual"]'], _
			["ExposureProgram", __GetLang('ENV_VAR_105', 'exposure program') & ' ["Normal"]'], _
			["FlashMode", __GetLang('ENV_VAR_106', 'flash mode') & ' ["Not fired, Auto"]'], _
			["LightSource", __GetLang('ENV_VAR_121', 'light source') & ' ["Daylight"]'], _
			["MeteringMode", __GetLang('ENV_VAR_122', 'metering mode') & ' ["Average"]'], _
			["SceneCaptureType", __GetLang('ENV_VAR_123', 'scene capture type') & ' ["Landscape"]'], _
			["SubjectDistance", __GetLang('ENV_VAR_124', 'subject distance') & ' ["2.8"]'], _
			["DigitalZoomRatio", __GetLang('ENV_VAR_125', 'digital zoom ratio') & ' ["2"]'], _
			["WhiteBalance", __GetLang('ENV_VAR_126', 'white balance') & ' ["Auto"]']]
	Local $mGroupMedia[9][3] = [ _
			[8, 0, 0], _
			["BitRate", __GetLang('ENV_VAR_68', 'audio bit rate') & ' ["192kbps"]'], _
			["Duration", __GetLang('ENV_VAR_69', 'file duration') & ' ["01.34.26"]'], _
			["SongAlbum", __GetLang('ENV_VAR_15', 'song album') & ' ["The Wall"]'], _
			["SongArtist", __GetLang('ENV_VAR_16', 'song artist') & ' ["Pink Floyd"]'], _
			["SongGenre", __GetLang('ENV_VAR_17', 'song genre') & ' ["Rock"]'], _
			["SongTitle", __GetLang('ENV_VAR_19', 'song title') & ' ["Hey You"]'], _
			["SongTrack", __GetLang('ENV_VAR_18', 'song track number') & ' ["3"]'], _
			["SongYear", __GetLang('ENV_VAR_20', 'song year') & ' ["1979"]']]
	Local $mGroupHash[5][3] = [ _
			[4, 0, 0], _
			["CRC", __GetLang('ENV_VAR_70', 'CRC Hash') & ' ["5E2860D3"]'], _
			["MD4", __GetLang('ENV_VAR_71', 'MD4 Hash') & ' ["CE8C45F356F121F88551150BC9C7DC54"]'], _
			["MD5", __GetLang('ENV_VAR_72', 'MD5 Hash') & ' ["1377F191017E95C55B45E6C42D48D1C0"]'], _
			["SHA1", __GetLang('ENV_VAR_73', 'SHA-1 Hash') & ' ["20A1E2D9D36CB8651A16879E0A354B9BE163E1CB"]']]
	Local $mGroupCurrent[16][3] = [ _
			[15, 0, 0], _
			["CurrentDate", __GetLang('ENV_VAR_0', 'current date') & ' ["' & @YEAR & "-" & @MON & "-" & @MDAY & '"]'], _
			["CurrentYear", __GetLang('ENV_VAR_30', 'current year') & ' ["' & @YEAR & '"]'], _
			["CurrentMonth", __GetLang('ENV_VAR_31', 'current month') & ' ["' & @MON & '"]'], _
			["CurrentWeek", __GetLang('ENV_VAR_95', 'current week') & ' ["' & _WeekNumberISO() & '"]'], _
			["CurrentDay", __GetLang('ENV_VAR_32', 'current day') & ' ["' & @MDAY & '"]'], _
			[""], _ ; Separator.
			["CurrentTime", __GetLang('ENV_VAR_1', 'current time') & ' ["' & @HOUR & "." & @MIN & '"]'], _
			["CurrentHour", __GetLang('ENV_VAR_33', 'current hour') & ' ["' & @HOUR & '"]'], _
			["CurrentMinute", __GetLang('ENV_VAR_34', 'current minute') & ' ["' & @MIN & '"]'], _
			["CurrentSecond", __GetLang('ENV_VAR_35', 'current second') & ' ["' & @SEC & '"]'], _
			[""], _ ; Separator.
			["CurrentMonthName", __GetLang('ENV_VAR_31', 'current month') & ' ["' & __Locale_MonthName(@MON, 0) & '"]'], _
			["CurrentMonthShort", __GetLang('ENV_VAR_31', 'current month') & ' ["' & __Locale_MonthName(@MON, 1) & '"]'], _
			["CurrentDayName", __GetLang('ENV_VAR_32', 'current day') & ' ["' & __Locale_DayName(_DateToDayOfWeekISO(@YEAR, @MON, @MDAY), 0) & '"]'], _
			["CurrentDayShort", __GetLang('ENV_VAR_32', 'current day') & ' ["' & __Locale_DayName(_DateToDayOfWeekISO(@YEAR, @MON, @MDAY), 1) & '"]']]
	Local $mGroupCreated[17][3] = [ _
			[16, 0, 0], _
			["DateCreated", __GetLang('ENV_VAR_2', 'date file creation') & ' ["' & @YEAR & "-" & @MON & "-" & @MDAY & '"]'], _
			["YearCreated", __GetLang('ENV_VAR_36', 'year file creation') & ' ["' & @YEAR & '"]'], _
			["MonthCreated", __GetLang('ENV_VAR_37', 'month file creation') & ' ["' & @MON & '"]'], _
			["YearWeekCreated", __GetLang('ENV_VAR_145', 'year and week file creation') & ' ["' & @YEAR & " " & _WeekNumberISO() & '"]'], _
			["WeekCreated", __GetLang('ENV_VAR_96', 'week file creation') & ' ["' & _WeekNumberISO() & '"]'], _
			["DayCreated", __GetLang('ENV_VAR_38', 'day file creation') & ' ["' & @MDAY & '"]'], _
			[""], _ ; Separator.
			["TimeCreated", __GetLang('ENV_VAR_39', 'time file creation') & ' ["' & @HOUR & "." & @MIN & '"]'], _
			["HourCreated", __GetLang('ENV_VAR_40', 'hour file creation') & ' ["' & @HOUR & '"]'], _
			["MinuteCreated", __GetLang('ENV_VAR_41', 'minute file creation') & ' ["' & @MIN & '"]'], _
			["SecondCreated", __GetLang('ENV_VAR_42', 'second file creation') & ' ["' & @SEC & '"]'], _
			[""], _ ; Separator.
			["MonthNameCreated", __GetLang('ENV_VAR_37', 'month file creation') & ' ["' & __Locale_MonthName(@MON, 0) & '"]'], _
			["MonthShortCreated", __GetLang('ENV_VAR_37', 'month file creation') & ' ["' & __Locale_MonthName(@MON, 1) & '"]'], _
			["DayNameCreated", __GetLang('ENV_VAR_38', 'day file creation') & ' ["' & __Locale_DayName(_DateToDayOfWeekISO(@YEAR, @MON, @MDAY), 0) & '"]'], _
			["DayShortCreated", __GetLang('ENV_VAR_38', 'day file creation') & ' ["' & __Locale_DayName(_DateToDayOfWeekISO(@YEAR, @MON, @MDAY), 1) & '"]']]
	Local $mGroupModified[17][3] = [ _
			[16, 0, 0], _
			["DateModified", __GetLang('ENV_VAR_3', 'date file modification') & ' ["' & @YEAR & "-" & @MON & "-" & @MDAY & '"]'], _
			["YearModified", __GetLang('ENV_VAR_43', 'year file modification') & ' ["' & @YEAR & '"]'], _
			["MonthModified", __GetLang('ENV_VAR_44', 'month file modification') & ' ["' & @MON & '"]'], _
			["YearWeekModified", __GetLang('ENV_VAR_146', 'year and week file modification') & ' ["' & @YEAR & " " & _WeekNumberISO() & '"]'], _
			["WeekModified", __GetLang('ENV_VAR_97', 'week file modification') & ' ["' & _WeekNumberISO() & '"]'], _
			["DayModified", __GetLang('ENV_VAR_45', 'day file modification') & ' ["' & @MDAY & '"]'], _
			[""], _ ; Separator.
			["TimeModified", __GetLang('ENV_VAR_46', 'time file modification') & ' ["' & @HOUR & "." & @MIN & '"]'], _
			["HourModified", __GetLang('ENV_VAR_47', 'hour file modification') & ' ["' & @HOUR & '"]'], _
			["MinuteModified", __GetLang('ENV_VAR_48', 'minute file modification') & ' ["' & @MIN & '"]'], _
			["SecondModified", __GetLang('ENV_VAR_49', 'second file modification') & ' ["' & @SEC & '"]'], _
			[""], _ ; Separator.
			["MonthNameModified", __GetLang('ENV_VAR_44', 'month file modification') & ' ["' & __Locale_MonthName(@MON, 0) & '"]'], _
			["MonthShortModified", __GetLang('ENV_VAR_44', 'month file modification') & ' ["' & __Locale_MonthName(@MON, 1) & '"]'], _
			["DayNameModified", __GetLang('ENV_VAR_45', 'day file modification') & ' ["' & __Locale_DayName(_DateToDayOfWeekISO(@YEAR, @MON, @MDAY), 0) & '"]'], _
			["DayShortModified", __GetLang('ENV_VAR_45', 'day file modification') & ' ["' & __Locale_DayName(_DateToDayOfWeekISO(@YEAR, @MON, @MDAY), 1) & '"]']]
	Local $mGroupOpened[17][3] = [ _
			[16, 0, 0], _
			["DateOpened", __GetLang('ENV_VAR_4', 'date file last access') & ' ["' & @YEAR & "-" & @MON & "-" & @MDAY & '"]'], _
			["YearOpened", __GetLang('ENV_VAR_50', 'year file last access') & ' ["' & @YEAR & '"]'], _
			["MonthOpened", __GetLang('ENV_VAR_51', 'month file last access') & ' ["' & @MON & '"]'], _
			["YearWeekOpened", __GetLang('ENV_VAR_147', 'year and week file last access') & ' ["' & @YEAR & " " & _WeekNumberISO() & '"]'], _
			["WeekOpened", __GetLang('ENV_VAR_98', 'week file last access') & ' ["' & _WeekNumberISO() & '"]'], _
			["DayOpened", __GetLang('ENV_VAR_52', 'day file last access') & ' ["' & @MDAY & '"]'], _
			[""], _ ; Separator.
			["TimeOpened", __GetLang('ENV_VAR_53', 'time file last access') & ' ["' & @HOUR & "." & @MIN & '"]'], _
			["HourOpened", __GetLang('ENV_VAR_54', 'hour file last access') & ' ["' & @HOUR & '"]'], _
			["MinuteOpened", __GetLang('ENV_VAR_55', 'minute file last access') & ' ["' & @MIN & '"]'], _
			["SecondOpened", __GetLang('ENV_VAR_56', 'second file last access') & ' ["' & @SEC & '"]'], _
			[""], _ ; Separator.
			["MonthNameOpened", __GetLang('ENV_VAR_51', 'month file last access') & ' ["' & __Locale_MonthName(@MON, 0) & '"]'], _
			["MonthShortOpened", __GetLang('ENV_VAR_51', 'month file last access') & ' ["' & __Locale_MonthName(@MON, 1) & '"]'], _
			["DayNameOpened", __GetLang('ENV_VAR_52', 'day file last access') & ' ["' & __Locale_DayName(_DateToDayOfWeekISO(@YEAR, @MON, @MDAY), 0) & '"]'], _
			["DayShortOpened", __GetLang('ENV_VAR_52', 'day file last access') & ' ["' & __Locale_DayName(_DateToDayOfWeekISO(@YEAR, @MON, @MDAY), 1) & '"]']]
	Local $mGroupTaken[17][3] = [ _
			[16, 0, 0], _
			["DateTaken", __GetLang('ENV_VAR_5', 'date picture taken') & ' ["' & @YEAR & "-" & @MON & "-" & @MDAY & '"]'], _
			["YearTaken", __GetLang('ENV_VAR_57', 'year picture taken') & ' ["' & @YEAR & '"]'], _
			["MonthTaken", __GetLang('ENV_VAR_58', 'month picture taken') & ' ["' & @MON & '"]'], _
			["YearWeekTaken", __GetLang('ENV_VAR_148', 'year and week picture taken') & ' ["' & @YEAR & " " & _WeekNumberISO() & '"]'], _
			["WeekTaken", __GetLang('ENV_VAR_99', 'week picture taken') & ' ["' & _WeekNumberISO() & '"]'], _
			["DayTaken", __GetLang('ENV_VAR_59', 'day picture taken') & ' ["' & @MDAY & '"]'], _
			[""], _ ; Separator.
			["TimeTaken", __GetLang('ENV_VAR_60', 'time picture taken') & ' ["' & @HOUR & "." & @MIN & '"]'], _
			["HourTaken", __GetLang('ENV_VAR_61', 'hour picture taken') & ' ["' & @HOUR & '"]'], _
			["MinuteTaken", __GetLang('ENV_VAR_62', 'minute picture taken') & ' ["' & @MIN & '"]'], _
			["SecondTaken", __GetLang('ENV_VAR_81', 'second picture taken') & ' ["' & @SEC & '"]'], _
			[""], _ ; Separator.
			["MonthNameTaken", __GetLang('ENV_VAR_58', 'month picture taken') & ' ["' & __Locale_MonthName(@MON, 0) & '"]'], _
			["MonthShortTaken", __GetLang('ENV_VAR_58', 'month picture taken') & ' ["' & __Locale_MonthName(@MON, 1) & '"]'], _
			["DayNameTaken", __GetLang('ENV_VAR_59', 'day picture taken') & ' ["' & __Locale_DayName(_DateToDayOfWeekISO(@YEAR, @MON, @MDAY), 0) & '"]'], _
			["DayShortTaken", __GetLang('ENV_VAR_59', 'day picture taken') & ' ["' & __Locale_DayName(_DateToDayOfWeekISO(@YEAR, @MON, @MDAY), 1) & '"]']]
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
	Local $mGroupOthers[9][3] = [ _
			[8, 0, 0], _
			["ComputerName", __GetLang('ENV_VAR_78', 'computer name') & ' ["' & @ComputerName & '"]'], _
			["Counter", __GetLang('ENV_VAR_83', 'counter to enumerate files') & ' ["07"]'], _
			["DefaultProgram", __GetLang('ENV_VAR_6', 'system default program') & ' [Notepad]'], _ ; Only By Open With.
			["DropItDir", __GetLang('ENV_VAR_131', 'path to DropIt directory') & ' ["' & @ScriptDir & '"]'], _
			["PortableDrive", __GetLang('ENV_VAR_14', 'drive letter of DropIt') & ' ["' & StringLeft(@ScriptFullPath, 2) & '"]'], _
			["ProfileName", __GetLang('ENV_VAR_28', 'current DropIt profile name') & ' ["' & $mProfile & '"]'], _
			["UserInput", __GetLang('ENV_VAR_82', 'custom input during process') & ' ["My photos"]'], _
			["UserName", __GetLang('ENV_VAR_79', 'system user name') & ' ["' & @UserName & '"]']]
	Local $mGroupTextContent[12][3] = [ _
			[11, 0, 0], _
			["FirstFileContentDate", __GetLang('ENV_VAR_133', 'first date from file content in unchanged format') & ' ["' & @MDAY & "." & @MON & "." & (@YEAR - 2000) & '"]'], _
			["FirstFileContentDateNormalized", __GetLang('ENV_VAR_132', 'first date from file content normalized') & ' ["' & @YEAR & @MON & @MDAY & '"]'], _
			["FileContentMatch1", __GetLang('ENV_VAR_135', '1st match from file content filter') & ' ["Bill"]'], _
			["FileContentMatch2", __GetLang('ENV_VAR_136', '2nd match from file content filter') & ' ["Bill"]'], _
			["FileContentMatch3", __GetLang('ENV_VAR_137', '3rd match from file content filter') & ' ["Bill"]'], _
			["FileContentMatch4", __GetLang('ENV_VAR_138', '4th match from file content filter') & ' ["Bill"]'], _
			["FileContentMatch5", __GetLang('ENV_VAR_139', '5th match from file content filter') & ' ["Bill"]'], _
			["FileContentMatch6", __GetLang('ENV_VAR_140', '6th match from file content filter') & ' ["Bill"]'], _
			["FileContentMatch7", __GetLang('ENV_VAR_141', '7th match from file content filter') & ' ["Bill"]'], _
			["FileContentMatch8", __GetLang('ENV_VAR_142', '8th match from file content filter') & ' ["Bill"]'], _
			["FileContentMatch9", __GetLang('ENV_VAR_143', '9th match from file content filter') & ' ["Bill"]']]
	Local $mMenuGroup[16][3] = [ _
			[15, 0, 0], _
			[__GetLang('ENV_VAR_TAB_4', 'Paths'), $mGroupPaths], _
			[__GetLang('ENV_VAR_TAB_3', 'Info'), $mGroupInfo], _
			[__GetLang('ENV_VAR_TAB_16', 'Images'), $mGroupImage], _
			[__GetLang('ENV_VAR_TAB_17', 'Content'), $mGroupTextContent], _
			[__GetLang('ENV_VAR_TAB_12', 'Media'), $mGroupMedia], _
			[__GetLang('ENV_VAR_TAB_13', 'Hash'), $mGroupHash], _
			[""], _ ; Separator.
			[__GetLang('ENV_VAR_TAB_5', 'Current'), $mGroupCurrent], _
			[__GetLang('ENV_VAR_TAB_6', 'Created'), $mGroupCreated], _
			[__GetLang('ENV_VAR_TAB_7', 'Modified'), $mGroupModified], _
			[__GetLang('ENV_VAR_TAB_8', 'Opened'), $mGroupOpened], _
			[__GetLang('ENV_VAR_TAB_9', 'Taken'), $mGroupTaken], _
			[""], _ ; Separator.
			[__GetLang('ENV_VAR_TAB_14', 'System'), $mGroupFolders], _
			[__GetLang('ENV_VAR_TAB_15', 'Others'), $mGroupOthers]]

	Local $mNumberAbbreviations = $mGroupCurrent[0][0] + $mGroupCreated[0][0] + $mGroupModified[0][0] + $mGroupOpened[0][0] + $mGroupTaken[0][0] + _
			$mGroupPaths[0][0] + $mGroupFolders[0][0] + $mGroupOthers[0][0] + $mGroupImage[0][0] + $mGroupMedia[0][0] + $mGroupHash[0][0] + $mGroupInfo[0][0] + $mGroupTextContent[0][0]

	Return _ContextMenuAbbreviations($mButton_Abbreviations, $mMenuGroup, $mNumberAbbreviations, $mCurrentAction, $mHandle)
EndFunc   ;==>_Manage_ContextMenu_Abbreviations

Func _Manage_ContextMenu_Rules($mButton_Rules, ByRef $mUseRegEx)
	Local $mEnvMenu, $mMsg, $mPos, $mValue = -1
	Local $mGroupFiles[17][3] = [ _
			[16, 0, 0], _
			["*", __GetLang('MANAGE_EDIT_MSGBOX_32', 'all files')], _
			["#", __GetLang('MANAGE_EDIT_MSGBOX_29', 'all files without other matches')], _
			[""], _
			["*.jpg", __GetLang('MANAGE_EDIT_MSGBOX_17', 'all files with "jpg" extension')], _
			["penguin*", __GetLang('MANAGE_EDIT_MSGBOX_18', 'all files that begin with "penguin"')], _
			["*penguin*", __GetLang('MANAGE_EDIT_MSGBOX_19', 'all files that contain "penguin"')], _
			["C:\Folder\*.jpg", __GetLang('MANAGE_EDIT_MSGBOX_20', 'all "jpg" files from "Folder"')], _
			["*.jpg;*.png", __GetLang('MANAGE_EDIT_MSGBOX_26', 'with ";" or "|" to separate rules')], _
			["*.jpg/sea*", __GetLang('MANAGE_EDIT_MSGBOX_27', 'with "/" to exclude files that begin with "sea"')], _
			[""], _
			["*.7z;*.bz2;*.gz;*.iso;*.rar;*.xz;*.z;*.zip", __GetLang('MANAGE_EDIT_MSGBOX_38', 'common archives')], _
			["*.djvu;*.doc;*.docx;*.epub;*.odt;*.pdf;*.rtf;*.tex;*.txt", __GetLang('MANAGE_EDIT_MSGBOX_39', 'common documents')], _
			["*.bmp;*.gif;*.ico;*.jpg;*.jpeg;*.png;*.psd;*.tif;*.tiff", __GetLang('MANAGE_EDIT_MSGBOX_40', 'common images')], _
			["*.aac;*.flac;*.m4a;*.mp3;*.ogg;*.wma;*.wav", __GetLang('MANAGE_EDIT_MSGBOX_41', 'common music')], _
			["*.csv;*.odp;*.ods;*.pps;*.ppt;*.pptx;*.xls;*.xlsx", __GetLang('MANAGE_EDIT_MSGBOX_42', 'common presentations and spreadsheets')], _
			["*.avi;*.flv;*.m4v;*.mkv;*.mov;*.mp4;*.mpeg;*.mpg;*.wmv", __GetLang('MANAGE_EDIT_MSGBOX_43', 'common videos')]]
	Local $mGroupFolders[9][3] = [ _
			[8, 0, 0], _
			["**", __GetLang('MANAGE_EDIT_MSGBOX_33', 'all folders')], _
			["##", __GetLang('MANAGE_EDIT_MSGBOX_30', 'all folders without other matches')], _
			[""], _
			["robot**", __GetLang('MANAGE_EDIT_MSGBOX_22', 'all folders that begin with "robot"')], _
			["**robot**", __GetLang('MANAGE_EDIT_MSGBOX_23', 'all folders that contain "robot"')], _
			["C:\**\robot", __GetLang('MANAGE_EDIT_MSGBOX_24', 'all "robot" folders from a "C:" subfolder')], _
			["image**|photo**", __GetLang('MANAGE_EDIT_MSGBOX_26', 'with ";" or "|" to separate rules')], _
			["**/my**", __GetLang('MANAGE_EDIT_MSGBOX_31', 'with "/" to exclude folders that begin with "my"')]]
	Local $mMenuGroup[3][3] = [ _
			[2, 0, 0], _
			[__GetLang('MANAGE_TAB_0', 'Rule examples for files'), $mGroupFiles], _
			[__GetLang('MANAGE_TAB_1', 'Rule examples for folders'), $mGroupFolders]]

	Local $mNumberExamples = $mGroupFiles[0][0] + $mGroupFolders[0][0]
	Local $mIndex, $mCurrentArray, $mMenuItem[$mNumberExamples + 1][4] = [[$mNumberExamples, 0, 0, 0]]
	For $A = 1 To $mMenuGroup[0][0] ; Create The Unique Array.
		If $mMenuGroup[$A][0] <> "" Then ; To Skip Separators.
			$mCurrentArray = $mMenuGroup[$A][1]
			For $B = 1 To $mCurrentArray[0][0]
				$mIndex += 1
				$mMenuItem[$mIndex][0] = $A ; Group Number.
				$mMenuItem[$mIndex][1] = $mCurrentArray[$B][0] ; Rule String.
				$mMenuItem[$mIndex][2] = $mCurrentArray[$B][1] ; Rule Description.
			Next
		EndIf
	Next

	If IsHWnd($mButton_Rules) = 0 Then
		$mButton_Rules = GUICtrlGetHandle($mButton_Rules)
	EndIf

	$mEnvMenu = _GUICtrlMenu_CreatePopup()
	;_GUICtrlMenu_SetMenuStyle($mEnvMenu, $MNS_NOCHECK)
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
			_GUICtrlMenu_AddMenuItem($mMenuGroup[$mMenuItem[$A][0]][2], $mMenuItem[$A][1] & " = " & $mMenuItem[$A][2], $mMenuItem[$A][3])
		EndIf
	Next
	_GUICtrlMenu_AddMenuItem($mEnvMenu, "")
	_GUICtrlMenu_AddMenuItem($mEnvMenu, __GetLang('MANAGE_TAB_2', 'Consider as Regular Expressions'), 2000)
	If $mUseRegEx == "True" Then
		_GUICtrlMenu_CheckMenuItem($mEnvMenu, 3)
	EndIf

	$mPos = WinGetPos($mButton_Rules, "")
	$mMsg = _GUICtrlMenu_TrackPopupMenu($mEnvMenu, $mButton_Rules, $mPos[0] + $mPos[2], $mPos[1] + $mPos[3], 2, 1, 2)
	If $mMsg >= $mMenuItem[1][3] And $mMsg <= $mMenuItem[$mMenuItem[0][0]][3] Then
		For $A = 1 To $mMenuItem[0][0]
			If $mMsg = $mMenuItem[$A][3] Then
				$mValue = $mMenuItem[$A][1]
				ExitLoop
			EndIf
		Next
	ElseIf $mMsg = 2000 Then ; Regular Expression Item Selected.
		If $mUseRegEx <> "True" Then
			$mUseRegEx = "True"
		Else
			$mUseRegEx = ""
		EndIf
	EndIf

	_GUICtrlMenu_DestroyMenu($mEnvMenu)
	For $A = 1 To $mMenuGroup[0][0]
		_GUICtrlMenu_DestroyMenu($mMenuGroup[$A][2])
	Next

	Return $mValue
EndFunc   ;==>_Manage_ContextMenu_Rules

Func _Manage_ContextMenu_Servers($mButton_Servers)
	Local $mEnvMenu, $mMsg, $mPos, $mArray[7] = [6]
	Local $mServers[8][8] = [ _
			[7, 0, 0], _ ; Index, Company, Server, Port, SSL, Email, User, SizeLimit.
			[0, "AIM Mail", "smtp.aim.com", 587, 1, "example@aim.com", "example@aim.com", 25], _
			[0, "AOL Mail", "smtp.aol.com", 587, 1, "example@aim.com", "example", 25], _
			[0, "Gmail", "smtp.gmail.com", 465, 1, "example@gmail.com", "example@gmail.com", 25], _
			[0, "Hotmail", "smtp.live.com", 25, 1, "example@hotmail.com", "example@hotmail.com", 25], _
			[0, "Outlook", "smtp.live.com", 587, 1, "example@outlook.com", "example@outlook.com", 20], _
			[0, "Yahoo Mail", "smtp.mail.yahoo.com", 465, 1, "example@yahoo.com", "example@yahoo.com", 25], _
			[0, "Zoho Mail", "smtp.zoho.com", 465, 1, "example@zoho.com", "example@zoho.com", 10]]

	If IsHWnd($mButton_Servers) = 0 Then
		$mButton_Servers = GUICtrlGetHandle($mButton_Servers)
	EndIf

	$mEnvMenu = _GUICtrlMenu_CreatePopup()
	_GUICtrlMenu_SetMenuStyle($mEnvMenu, $MNS_NOCHECK)
	For $A = 1 To $mServers[0][0]
		$mServers[$A][0] = 1000 + $A
		_GUICtrlMenu_AddMenuItem($mEnvMenu, $mServers[$A][1], $mServers[$A][0])
	Next

	$mPos = WinGetPos($mButton_Servers, "")
	$mMsg = _GUICtrlMenu_TrackPopupMenu($mEnvMenu, $mButton_Servers, $mPos[0] + $mPos[2], $mPos[1] + $mPos[3], 2, 1, 2)
	If $mMsg >= $mServers[1][0] And $mMsg <= $mServers[$mServers[0][0]][0] Then
		For $A = 1 To $mServers[0][0]
			If $mMsg = $mServers[$A][0] Then
				For $B = 1 To $mArray[0]
					$mArray[$B] = $mServers[$A][$B + 1]
				Next
				_GUICtrlMenu_DestroyMenu($mEnvMenu)
				Return $mArray
			EndIf
		Next
	EndIf

	_GUICtrlMenu_DestroyMenu($mEnvMenu)
	Return SetError(1, 0, 0)
EndFunc   ;==>_Manage_ContextMenu_Servers

Func _Manage_ContextMenu_ListView($cmListView, $cmIndex, $cmSubItem)
	Local Enum $cmItem1 = 1000, $cmItem2, $cmItem3, $cmItem4, $cmItem5

	If IsHWnd($cmListView) = 0 Then
		$cmListView = GUICtrlGetHandle($cmListView)
	EndIf

	Local $cmContextMenu = _GUICtrlMenu_CreatePopup()
	If $cmIndex <> -1 And $cmSubItem <> -1 Then ; Won't Show These MenuItem(s) Unless An Item Is Selected.
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu, __GetLang('EDIT', 'Edit'), $cmItem1)
		__SetItemImage("EDIT", $cmIndex, $cmContextMenu, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu, "")
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu, __GetLang('DUPLICATE', 'Duplicate'), $cmItem5)
		__SetItemImage("DUPLICATE", $cmIndex, $cmContextMenu, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu, __GetLang('COPYTO', 'Copy to') & "...", $cmItem2)
		__SetItemImage("COPYTO", $cmIndex, $cmContextMenu, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu, "")
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu, __GetLang('ACTION_DELETE', 'Delete'), $cmItem3)
		__SetItemImage("DEL", $cmIndex, $cmContextMenu, 2, 1)
	ElseIf $cmIndex = -1 And $cmSubItem <> -1 Then ; Will Show These MenuItem(s) If No Item Is Selected.
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
		Case $cmItem5
			GUICtrlSendToDummy($Global_ListViewRules_Duplicate)
	EndSwitch
	_GUICtrlMenu_DestroyMenu($cmContextMenu)
	Return 1
EndFunc   ;==>_Manage_ContextMenu_ListView
#EndRegion >>>>> Manage Functions <<<<<

#Region >>>>> Customize Functions <<<<<
Func _Customize_GUI($cHandle = -1, $cProfileList = -1)
	Local $cGUI, $cListView, $cListView_Handle, $cNew, $cClose, $cIndex_Selected, $cText, $cImage, $cGetImages, $cSizeText, $cOpacity
	Local $cDeleteDummy, $cDuplicateDummy, $cEnterDummy, $cNewDummy, $cImportDummy, $cExportDummy, $cImportAllDummy, $cExportAllDummy, $cOptionsDummy, $cExampleDummy

	;Local $cSettingsPath = __IsSettingsFile()
	Local $cDirectories = __GetDefault(35) ; 1 = Settings Directory, 2 = Profiles Directory, 3 = Backup Directory.
	Local $cSize = __GetCurrentSize("SizeCustom", "320;200;-1;-1") ; Window Width/Height.

	If $cProfileList = -1 Or $cProfileList = 0 Or $cProfileList = "" Then
		$cProfileList = __ProfileList_Get() ; Get Array Of All Profiles.
	EndIf
	If IsArray($cProfileList) = 0 Then
		Return SetError(1, 0, 0)
	EndIf

	$cGUI = GUICreate(__GetLang('CUSTOMIZE_GUI', 'Customize Profiles'), $cSize[1], $cSize[2], $cSize[3], $cSize[4], BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX), -1, __OnTop($cHandle))
	GUISetIcon(@ScriptFullPath, -3, $cGUI) ; Use Custom.ico
	$Global_ResizeMinWidth = 320 ; Set Default Min Width.
	$Global_ResizeMaxWidth = @DesktopWidth ; Set Default Max Width.
	$Global_ResizeMinHeight = 200 ; Set Default Min Height.
	$Global_ResizeMaxHeight = @DesktopHeight ; Set Default Max Height.

	$cListView = GUICtrlCreateListView(__GetLang('PROFILE', 'Profile') & "|" & __GetLang('IMAGE', 'Image') & "|" & __GetLang('IMAGE_DIMENSIONS', 'Dimensions') & "|" & __GetLang('OPACITY', 'Opacity'), 0, 0, $cSize[1], $cSize[2] - 35, BitOR($LVS_NOSORTHEADER, $LVS_REPORT, $LVS_SINGLESEL))
	$cListView_Handle = GUICtrlGetHandle($cListView)
	$Global_ListViewProfiles = $cListView_Handle
	GUICtrlSetResizing($cListView, $GUI_DOCKBORDERS)

	Local $cImageList = _GUIImageList_Create(20, 20, 5, 3) ; Create An ImageList.
	_GUICtrlListView_SetImageList($cListView, $cImageList, 1)
	$G_Global_ImageList = $cImageList

	_GUICtrlListView_SetExtendedListViewStyle($cListView_Handle, BitOR($LVS_EX_DOUBLEBUFFER, $LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_INFOTIP))
	Local $cColumnSize = __GetCurrentSize("ColumnCustom", "100;100;60;50") ; Column Widths.
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

	_Customize_Populate($cListView_Handle, $cDirectories[2][0], $cProfileList) ; Add/Update Customise GUI With List Of Profiles.
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
	$cExportDummy = GUICtrlCreateDummy()
	$Global_ListViewProfiles_Export = $cExportDummy
	$cImportAllDummy = GUICtrlCreateDummy()
	$Global_ListViewProfiles_ImportAll = $cImportAllDummy
	$cExportAllDummy = GUICtrlCreateDummy()
	$Global_ListViewProfiles_ExportAll = $cExportAllDummy
	$cOptionsDummy = GUICtrlCreateDummy()
	$Global_ListViewProfiles_Options = $cOptionsDummy
	$cExampleDummy = GUICtrlCreateDummy()
	$Global_ListViewProfiles_Example[0] = $cExampleDummy

	$cNew = GUICtrlCreateButton("N", 15, $cSize[2] - 31, 70, 25, $BS_ICON)
	GUICtrlSetImage($cNew, @ScriptFullPath, -21, 0)
	GUICtrlSetTip($cNew, __GetLang('NEW', 'New'))
	GUICtrlSetResizing($cNew, $GUI_DOCKSIZE + $GUI_DOCKLEFT + $GUI_DOCKBOTTOM)

	$cGetImages = GUICtrlCreateButton("I", ($cSize[1] - 70) / 2, $cSize[2] - 31, 70, 25, $BS_ICON)
	GUICtrlSetImage($cGetImages, @ScriptFullPath, -22, 0)
	GUICtrlSetTip($cGetImages, __GetLang('IMAGE_GET_LABEL_0', 'Get more target images online'))
	GUICtrlSetResizing($cGetImages, $GUI_DOCKSIZE + $GUI_DOCKHCENTER + $GUI_DOCKBOTTOM)

	$cClose = GUICtrlCreateButton("C", $cSize[1] - 15 - 70, $cSize[2] - 31, 70, 25, $BS_ICON)
	GUICtrlSetImage($cClose, @ScriptFullPath, -20, 0)
	GUICtrlSetTip($cClose, __GetLang('CLOSE', 'Close'))
	GUICtrlSetResizing($cClose, $GUI_DOCKSIZE + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM)
	GUICtrlSetState($cClose, $GUI_DEFBUTTON)

	$Global_ListViewIndex = -1 ; Set As No Item Selected.
	GUIRegisterMsg($WM_NOTIFY, "_WM_NOTIFY")
	GUIRegisterMsg($WM_GETMINMAXINFO, "_WM_GETMINMAXINFO")
	GUISetState(@SW_SHOW)

	Local $cHotKeys[3][2] = [["^n", $cNewDummy],["{DELETE}", $cDeleteDummy],["{ENTER}", $cEnterDummy]]
	GUISetAccelerators($cHotKeys)

	_WinAPI_EmptyWorkingSet() ; Reduce Memory Usage Of DropIt.
	While 1
		$cIndex_Selected = $Global_ListViewIndex

		Switch GUIGetMsg()
			Case $cClose, $GUI_EVENT_CLOSE
				__SetCurrentSize("ColumnCustom", $cListView_Handle, 1) ; Column Widths.
				ExitLoop

			Case $cNew, $cNewDummy
				_Customize_Edit_GUI($cGUI, -1, -1, -1, -1, 1) ; Show Customize Edit GUI For New Profile.
				_Customize_Populate($cListView_Handle, $cDirectories[2][0], -1) ; Add/Update Customise GUI With List Of Profiles.

			Case $cGetImages
				ShellExecute(_WinAPI_ExpandEnvironmentStrings("%DropItTargetURL%"))

			Case $cDuplicateDummy
				$cText = _GUICtrlListView_GetItemText($cListView_Handle, $cIndex_Selected)
				FileCopy($cDirectories[2][0] & $cText & ".ini", $cDirectories[2][0] & __Duplicate_Rename($cText & ".ini", $cDirectories[2][0], 0, 2))
				_Customize_Populate($cListView_Handle, $cDirectories[2][0], -1) ; Add/Update Customise GUI With List Of Profiles.

			Case $cDeleteDummy
				_Customize_Delete($cListView_Handle, $cIndex_Selected, $cDirectories[2][0], -1, $cGUI) ; Delete Profile From The Default Profile Directory & ListView.
				$Global_ListViewIndex = -1 ; Set As No Item Selected.

			Case $cOptionsDummy
				$cText = _GUICtrlListView_GetItemText($cListView_Handle, $cIndex_Selected)
				_Customize_Options($cText, $cDirectories[2][0], $cGUI) ; Show Profile Options GUI.

			Case $cImportDummy
				_Customize_Import($cDirectories[2][0], $cGUI)
				If @error = 2 Then
					MsgBox(0x30, __GetLang('CUSTOMIZE_MSGBOX_2', 'Importing Failed'), __GetLang('CUSTOMIZE_MSGBOX_3', 'Profile not imported. The source file might be not correctly structured.'), 0, __OnTop($cGUI))
					ContinueLoop
				EndIf
				_Customize_Populate($cListView_Handle, $cDirectories[2][0], -1) ; Add/Update Customise GUI With List Of Profiles.

			Case $cImportAllDummy
				_Customize_ImportAll($cDirectories[2][0], $cGUI)
				If @error = 2 Then
					MsgBox(0x30, __GetLang('CUSTOMIZE_MSGBOX_2', 'Importing Failed'), __GetLang('CUSTOMIZE_MSGBOX_3', 'Profile not imported. The source file might be not correctly structured.'), 0, __OnTop($cGUI))
					ContinueLoop
				EndIf
				_Customize_Populate($cListView_Handle, $cDirectories[2][0], -1) ; Add/Update Customise GUI With List Of Profiles.

			Case $cExportDummy
				If Not _GUICtrlListView_GetItemState($cListView_Handle, $cIndex_Selected, $LVIS_SELECTED) Then
					ContinueLoop
				EndIf
				$cText = _GUICtrlListView_GetItemText($cListView_Handle, $cIndex_Selected)
				_Customize_Export($cDirectories[2][0], $cText, $cGUI)
				If @error = 2 Then
					MsgBox(0x30, __GetLang('CUSTOMIZE_MSGBOX_4', 'Exporting Failed'), __GetLang('CUSTOMIZE_MSGBOX_5', 'Profile not exported. An error occurs during this procedure.'), 0, __OnTop($cGUI))
				EndIf

			Case $cExportAllDummy
				_Customize_ExportAll($cDirectories[2][0], $cProfileList, $cGUI)
				If @error = 2 Then
					MsgBox(0x30, __GetLang('CUSTOMIZE_MSGBOX_4', 'Exporting Failed'), __GetLang('CUSTOMIZE_MSGBOX_5', 'Profile not exported. An error occurs during this procedure.'), 0, __OnTop($cGUI))
				EndIf

			Case $cEnterDummy
				If Not _GUICtrlListView_GetItemState($cListView_Handle, $cIndex_Selected, $LVIS_SELECTED) Then
					ContinueLoop
				EndIf

				$cText = _GUICtrlListView_GetItemText($cListView_Handle, $cIndex_Selected)
				$cImage = _GUICtrlListView_GetItemText($cListView_Handle, $cIndex_Selected, 1)
				$cSizeText = _GUICtrlListView_GetItemText($cListView_Handle, $cIndex_Selected, 2)
				$cOpacity = _GUICtrlListView_GetItemText($cListView_Handle, $cIndex_Selected, 3)
				_Customize_Edit_GUI($cGUI, $cText, $cImage, $cSizeText, $cOpacity, 0) ; Show Customize Edit GUI Of Selected Profile.
				_Customize_Populate($cListView_Handle, $cDirectories[2][0], -1) ; Add/Update Customise GUI With List Of Profiles.
				_GUICtrlListView_SetItemSelected($cListView_Handle, $cIndex_Selected, True, True)

			Case $cExampleDummy
				If FileExists($cDirectories[2][0] & $Global_ListViewProfiles_Example[1] & ".ini") Then
					MsgBox(0x30, __GetLang('PROFILEUNIQUE_MSGBOX_0', 'Name not available'), __GetLang('PROFILEUNIQUE_MSGBOX_1', 'This profile name already exists.'), 0, __OnTop($cGUI))
					ContinueLoop
				EndIf
				Switch $Global_ListViewProfiles_Example[1]
					Case __GetLang('CUSTOMIZE_EXAMPLE_0', 'Archiver')
						__CreateProfileExample(1) ; Archiver.
					Case __GetLang('CUSTOMIZE_EXAMPLE_1', 'Eraser')
						__CreateProfileExample(2) ; Eraser.
					Case __GetLang('CUSTOMIZE_EXAMPLE_2', 'Extractor')
						__CreateProfileExample(3) ; Extractor.
					Case __GetLang('CUSTOMIZE_EXAMPLE_3', 'List Maker')
						__CreateProfileExample(4) ; List Maker.
					Case __GetLang('CUSTOMIZE_EXAMPLE_4', 'Playlist Maker')
						__CreateProfileExample(5) ; Playlist Maker.
					Case __GetLang('CUSTOMIZE_EXAMPLE_5', 'Gallery Maker')
						__CreateProfileExample(6) ; Gallery Maker.
				EndSwitch
				_Customize_Populate($cListView_Handle, $cDirectories[2][0], -1) ; Add/Update Customise GUI With List Of Profiles.

		EndSwitch
	WEnd
	__SetCurrentSize("SizeCustom", $cGUI) ; Window Width/Height.
	GUIDelete($cGUI)
	_GUIImageList_Destroy($cImageList)

	__SetCurrentPosition() ; Set Current Coordinates/Position Of DropIt.
	__OnTop($Global_GUI_1) ; Set GUI "OnTop" If True.

	$cProfileList = __ProfileList_Get() ; Get Array Of All Profiles.
	If IsArray($cProfileList) = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	Return $cProfileList
EndFunc   ;==>_Customize_GUI

Func _Customize_Edit_GUI($cHandle = -1, $cProfile = -1, $cImage = -1, $cSizeText = -1, $cOpacity = -1, $cNewProfile = 0)
	Local $cGUI_1 = $Global_GUI_1

	Local $cStringSplit, $cProfileType, $cGUI, $cInput_Name, $cInput_Image, $cButton_Image, $cAspectRatio, $cCurrent_SizeX, $cInput_SizeX, $cInput_SizeY, $cButton_Size
	Local $cSave, $cCancel, $cChanged = 0, $cProfileDirectory, $cReturn, $cSizeX, $cSizeY, $cIniWrite, $cItemText, $cLabel_Opacity, $cInput_Opacity, $cCurrentProfile = 0
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
		$cSizeX = $cStringSplit[1]
		$cSizeY = $cStringSplit[2]
	Else
		$cSizeX = 64
		$cSizeY = 64
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

	$cGUI = GUICreate($cProfileType, 260, 310, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($cHandle))
	GUICtrlCreateLabel(__GetLang('NAME', 'Name') & ":", 10, 10, 120, 20)
	$cInput_Name = GUICtrlCreateInput($cProfile[1], 10, 31, 170, 20) ; Renaming Function Will Have To Be Re-Built.
	GUICtrlSetTip($cInput_Name, __GetLang('CUSTOMIZE_EDIT_TIP_0', 'Choose a name for this profile.'))

	GUICtrlCreateLabel(__GetLang('IMAGE', 'Image') & ":", 10, 65 + 10, 120, 20)
	$cInput_Image = GUICtrlCreateInput($cImage, 10, 65 + 31, 170, 20)
	GUICtrlSetTip($cInput_Image, __GetLang('CUSTOMIZE_EDIT_TIP_1', 'Select an image for this profile.'))
	$cButton_Image = GUICtrlCreateButton(__GetLang('SEARCH', 'Search'), 10 + 174, 65 + 30, 66, 22)
	GUICtrlSetTip($cButton_Image, __GetLang('SEARCH', 'Search'))

	GUICtrlCreateLabel(__GetLang('IMAGE_DIMENSIONS', 'Dimensions') & ":", 10, 65 * 2 + 10, 120, 20)
	$cInput_SizeX = GUICtrlCreateInput($cSizeX, 10, 65 * 2 + 31, 50, 20, 0x2000)
	GUICtrlSetTip($cInput_SizeX, __GetLang('WIDTH', 'Width'))
	GUICtrlCreateLabel("X", 10 + 66, 65 * 2 + 34, 34, 20)
	$cInput_SizeY = GUICtrlCreateInput($cSizeY, 10 + 90, 65 * 2 + 31, 50, 20, 0x2000)
	GUICtrlSetTip($cInput_SizeY, __GetLang('HEIGHT', 'Height'))
	$cButton_Size = GUICtrlCreateButton(__GetLang('RESET', 'Reset'), 10 + 174, 65 * 2 + 30, 66, 22)
	GUICtrlSetTip($cButton_Size, __GetLang('CUSTOMIZE_EDIT_TIP_2', 'Reset target image to the original dimensions.'))

	GUICtrlCreateLabel(__GetLang('OPACITY', 'Opacity') & ":", 10, 65 * 3 + 10, 120, 20)
	$cInput_Opacity = GUICtrlCreateSlider(10, 65 * 3 + 31, 200, 20)
	$Global_Slider = $cInput_Opacity
	GUICtrlSetLimit(-1, 100, 10)
	GUICtrlSetData(-1, $cOpacity)
	$cLabel_Opacity = GUICtrlCreateLabel($cOpacity & "%", 10 + 200, 65 * 3 + 31, 36, 20)
	$Global_SliderLabel = $cLabel_Opacity

	$cSave = GUICtrlCreateButton(__GetLang('SAVE', 'Save'), 130 - 25 - 80, 270, 80, 26)
	$cCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 130 + 25, 270, 80, 26)
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

	GUIRegisterMsg($WM_HSCROLL, "_WM_HSCROLL") ; Required For Changing The Label Next To The Slider.
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

		; Keep Aspect Ratio When Size X Is Changed:
		If GUICtrlRead($cInput_SizeX) <> $cCurrent_SizeX Then
			$cCurrent_SizeX = GUICtrlRead($cInput_SizeX)
			$cAspectRatio = $cSizeY / $cSizeX
			GUICtrlSetData($cInput_SizeX, $cCurrent_SizeX)
			GUICtrlSetData($cInput_SizeY, Round($cCurrent_SizeX * $cAspectRatio))
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
						__IniWriteEx($cIniWrite, $G_Global_TargetSection, "", "Image=" & $cProfileDirectory[3][0] & @LF & "SizeX=64" & @LF & "SizeY=64" & @LF & "Opacity=100")
						__IniWriteEx($cIniWrite, $G_Global_GeneralSection, "", "")
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
						__IniWriteEx($cIniWrite, $G_Global_TargetSection, "", "Image=" & $cProfileDirectory[3][0] & @LF & "SizeX=64" & @LF & "SizeY=64" & @LF & "Opacity=100")
						__IniWriteEx($cIniWrite, $G_Global_GeneralSection, "", "")
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

Func _Customize_Export($cProfileDirectory, $cProfileName, $cHandle = -1)
	Local $cListPath, $cListName, $cFileOpen, $cArray

	$cListName = _WinAPI_GetSaveFileName(__GetLang('MANAGE_DESTINATION_FILE_SELECT', 'Choose a destination file:'), "INI - " & __GetLang('MANAGE_DESTINATION_FORMAT_13', 'Copy of Profile file') & " (*.ini)|CSV - " & __GetLang('MANAGE_DESTINATION_FORMAT_2', 'Comma-Separated Values file') & " (*.csv)|XLS - " & __GetLang('MANAGE_DESTINATION_FORMAT_12', 'Microsoft Excel file') & " (*.xls)", @DesktopDir, $cProfileName, "ini", 1, $OFN_OVERWRITEPROMPT, 0, $cHandle)
	If $cListName[0] = 2 Then
		If _WinAPI_PathIsDirectory($cListName[1]) Then
			$cListPath = $cListName[1] & "\" & $cListName[2]
		EndIf
	EndIf
	If $cListPath = "" Then
		Return SetError(1, 0, 0)
	EndIf
	Switch __GetFileExtension($cListPath)
		Case "ini"
			FileCopy($cProfileDirectory & $cProfileName & ".ini", $cListPath)
			If @error Then
				Return SetError(2, 0, 0)
			EndIf

		Case "csv"
			$cArray = __ProfileToArray($cProfileName)
			__ArrayToCSV($cArray, $cListPath)
			If @error Then
				Return SetError(2, 0, 0)
			EndIf

		Case "xls"
			Local $oAppl = _Excel_Open(False, False, False, False, True)
			If @error Then
				Return SetError(2, 0, 0)
			EndIf
			Local $oWorkbook = _Excel_BookNew($oAppl)
			If @error Then
				_Excel_Close($oAppl, False)
				Return SetError(2, 0, 0)
			EndIf
			$cFileOpen = _Excel_BookOpen($oAppl, @ScriptDir & "\Lib\XLS Import Example.xls", True, False)
			If @error Then
				_Excel_Close($oAppl, False)
				Return SetError(2, 0, 0)
			EndIf
			_Excel_RangeCopyPaste($oWorkbook.Worksheets(1), $cFileOpen.Worksheets(1).Range("1:3"), "A1")
			If @error Then
				_Excel_Close($oAppl, False)
				Return SetError(2, 0, 0)
			EndIf
			$cArray = __ProfileToArray($cProfileName)
			_Excel_RangeWrite($oWorkbook, $oWorkbook.Activesheet, $cArray, "B4")
			If @error Then
				_Excel_Close($oAppl, False)
				Return SetError(2, 0, 0)
			EndIf
			_Excel_BookSaveAs($oWorkbook, $cListPath, $xlWorkbookNormal, True)
			If @error Then
				_Excel_Close($oAppl, False)
				Return SetError(2, 0, 0)
			EndIf
			_Excel_Close($oAppl, False)

	EndSwitch
	__Log_Write(__GetLang('CUSTOMIZE_LOG_1', 'Profile Exported'), $cProfileName)
	MsgBox(0x40, __GetLang('CUSTOMIZE_LOG_1', 'Profile Exported'), __GetLang('CUSTOMIZE_MSGBOX_8', 'Profile correctly exported.'), 0, __OnTop($cHandle))

	Return 1
EndFunc   ;==>_Customize_Export

Func _Customize_ExportAll($cProfileDirectory, $cProfileList, $cHandle = -1)
	Local $cListPath, $cListName, $cProfilePath

	$cListName = _WinAPI_GetSaveFileName(__GetLang('MANAGE_DESTINATION_FILE_SELECT', 'Choose a destination file:'), "ZIP (*.zip)", @DesktopDir, __GetLang('MANAGE_DESTINATION_PROFILES', 'DropIt Profiles') & " " & @YEAR & "-" & @MON & "-" & @MDAY & "[" & @HOUR & "." & @MIN & "." & @SEC & "]", "zip", 1, $OFN_OVERWRITEPROMPT, 0, $cHandle)
	If $cListName[0] = 2 Then
		If _WinAPI_PathIsDirectory($cListName[1]) Then
			$cListPath = $cListName[1] & "\" & $cListName[2]
		EndIf
	EndIf
	If $cListPath = "" Then
		Return SetError(1, 0, 0)
	EndIf
	For $A = 1 To $cProfileList[0]
		$cProfilePath = $cProfileDirectory & $cProfileList[$A] & ".ini"
		If FileExists($cProfilePath) Then
			__7ZipRun($cProfilePath, $cListPath, 4)
			If @error Then
				Return SetError(2, 0, 0)
			EndIf
			__Log_Write(__GetLang('CUSTOMIZE_LOG_1', 'Profile Exported'), $cProfileList[$A])
		EndIf
	Next
	MsgBox(0x40, __GetLang('CUSTOMIZE_LOG_3', 'Profiles Exported'), __GetLang('CUSTOMIZE_MSGBOX_9', 'Profiles correctly exported.'), 0, __OnTop($cHandle))

	Return 1
EndFunc   ;==>_Customize_ExportAll

Func _Customize_Import($cProfileDirectory, $cHandle = -1)
	Local $cListPath, $cProfileName, $cFileOpen, $cArray, $cOldProfile

	$cListPath = FileOpenDialog(__GetLang('CUSTOMIZE_MSGBOX_0', 'Select a file to import:'), @DesktopDir, __GetLang('CUSTOMIZE_MSGBOX_1', 'Supported files') & " (*.ini;*.csv;*.xls;*.xlsx)", 1, "", $cHandle)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Switch __GetFileExtension($cListPath)
		Case "ini"
			__IniReadSection($cListPath, $G_Global_TargetSection) ; To Verify If It Is A DropIt INI File.
			If @error Then
				__IniReadSection($cListPath, "Target")
				If @error Then
					Return SetError(2, 0, 0)
				EndIf
				$cOldProfile = 1 ; To Upgrade Old Profiles.
			EndIf
			$cProfileName = __IsProfileUnique(__GetFileNameOnly($cListPath)) ; Check If The Selected Profile Name Is Unique.
			If @error Then
				$cProfileName = __GetFileNameOnly(__Duplicate_Rename($cProfileName & ".ini", $cProfileDirectory, 0, 2))
			EndIf
			FileCopy($cListPath, $cProfileDirectory & $cProfileName & ".ini")
			If @error Then
				Return SetError(2, 0, 0)
			EndIf
			If $cOldProfile Then
				__UpgradeProfile($cProfileDirectory & $cProfileName & ".ini")
			EndIf

		Case "csv"
			$cFileOpen = StringReplace(FileRead($cListPath), ', ', ',')
			$cArray = __CSVSplit($cFileOpen, ',')
			If @error Or UBound($cArray, 2) < 5 Then
				Return SetError(2, 0, 0)
			EndIf

		Case "xls", "xlsx"
			Local $oAppl = _Excel_Open(False, False, False, False, True)
			$cFileOpen = _Excel_BookOpen($oAppl, $cListPath, True, False)
			Local $cTempArray = _Excel_RangeRead($cFileOpen, Default, Default)
			If @error Or UBound($cTempArray, 2) < 5 Then
				_Excel_Close($oAppl, False)
				Return SetError(2, 0, 0)
			EndIf
			_Excel_Close($oAppl, False)
			$cArray = _ArrayExtract($cTempArray, 1, UBound($cTempArray, 1) - 1, 0, UBound($cTempArray, 2) - 1)
			If @error Then
				Return SetError(2, 0, 0)
			EndIf
			$cArray[0][0] = UBound($cArray, 1) - 1
			$cArray[0][1] = UBound($cArray, 2) - 1

	EndSwitch
	If __GetFileExtension($cListPath) <> "ini" Then
		If StringInStr($cArray[1][1] & $cArray[1][2] & $cArray[1][3] & $cArray[1][4] & $cArray[1][5], "NAMESTATERULESACTIONDESTINATION") = 0 Then
			Return SetError(2, 0, 0)
		EndIf
		$cProfileName = __ArrayToProfile($cArray, __GetFileNameOnly($cListPath), $cProfileDirectory)
	EndIf
	__Log_Write(__GetLang('CUSTOMIZE_LOG_0', 'Profile Imported'), $cProfileName)
	MsgBox(0x40, __GetLang('CUSTOMIZE_LOG_2', 'Profile Imported'), __GetLang('CUSTOMIZE_MSGBOX_6', 'Profile correctly imported.'), 0, __OnTop($cHandle))

	Return 1
EndFunc   ;==>_Customize_Import

Func _Customize_ImportAll($cProfileDirectory, $cHandle = -1)
	Local $cSource, $cArrayFiles, $cProfileName, $cImportFolder = "IMPORTING"

	$cSource = FileOpenDialog(__GetLang('CUSTOMIZE_MSGBOX_0', 'Select a file to import:'), @DesktopDir, "ZIP (*.zip)", 1, "", __OnTop($cHandle))
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	__7ZipRun($cSource, $cProfileDirectory & $cImportFolder, 1, 1)
	If @error Then
		DirRemove($cProfileDirectory & $cImportFolder, 1)
		Return SetError(2, 0, 0)
	EndIf
	$cArrayFiles = _FileListToArray($cProfileDirectory & $cImportFolder, "*", $FLTA_FILES, True)
	For $A = 1 To $cArrayFiles[0]
		__IniReadSection($cArrayFiles[$A], $G_Global_TargetSection) ; To Verify If It Is A DropIt INI File.
		If @error Then
			ContinueLoop
		EndIf
		$cProfileName = __IsProfileUnique(__GetFileNameOnly($cArrayFiles[$A])) ; Check If The Selected Profile Name Is Unique.
		If @error Then
			$cProfileName = __GetFileNameOnly(__Duplicate_Rename($cProfileName & ".ini", $cProfileDirectory, 0, 2))
		EndIf
		FileCopy($cArrayFiles[$A], $cProfileDirectory & $cProfileName & ".ini")
		If @error Then
			ContinueLoop
		EndIf
		__Log_Write(__GetLang('CUSTOMIZE_LOG_0', 'Profile Imported'), $cProfileName)
	Next
	DirRemove($cProfileDirectory & $cImportFolder, 1)
	MsgBox(0x40, __GetLang('CUSTOMIZE_LOG_2', 'Profiles Imported'), __GetLang('CUSTOMIZE_MSGBOX_7', 'Profiles correctly imported.'), 0, __OnTop($cHandle))

	Return 1
EndFunc   ;==>_Customize_ImportAll

Func _Customize_Options($cProfileName, $cProfileDirectory, $cHandle = -1)
	Local $cGUI, $cSave, $cCancel, $cState, $cComboItems[7], $cCurrent[7]
	Local $cINI = $cProfileDirectory & $cProfileName & ".ini"
	Local $cOptions[6] = ["ShowSorting", "UseSendTo", "FolderAsFile", "AutoStart", "IgnoreNew", "AutoDup"]
	Local $cGroup = __GetLang('OPTIONS_PROFILE_MODE_0', 'Use global setting') & "|" & __GetLang('OPTIONS_PROFILE_MODE_1', 'Enable for this profile') & "|" & __GetLang('OPTIONS_PROFILE_MODE_2', 'Disable for this profile')

	$cGUI = GUICreate(__GetLang('OPTIONS_PROFILE', 'Profile Options'), 320, 406, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($cHandle))
	GUICtrlCreateLabel(__GetLang('OPTIONS_CHECKBOX_11', 'Show progress window during process') & ":", 10, 10, 300, 20)
	$cComboItems[0] = GUICtrlCreateCombo("", 10, 10 + 20, 300, 20, 0x0003)
	GUICtrlCreateLabel(__GetLang('OPTIONS_CHECKBOX_6', 'Integrate in SendTo menu') & ":", 10, 10 + 55, 300, 20)
	$cComboItems[1] = GUICtrlCreateCombo("", 10, 10 + 55 + 20, 300, 20, 0x0003)
	GUICtrlCreateLabel(__GetLang('OPTIONS_CHECKBOX_32', 'Process folders and not scan them') & ":", 10, 10 + 55 * 2, 300, 20)
	$cComboItems[2] = GUICtrlCreateCombo("", 10, 10 + 55 * 2 + 20, 300, 20, 0x0003)
	GUICtrlCreateLabel(__GetLang('OPTIONS_CHECKBOX_33', 'Start the process after loading') & ":", 10, 10 + 55 * 3, 300, 20)
	$cComboItems[3] = GUICtrlCreateCombo("", 10, 10 + 55 * 3 + 20, 300, 20, 0x0003)
	GUICtrlCreateLabel(__GetLang('OPTIONS_CHECKBOX_3', 'Ignore unassociated files/folders') & ":", 10, 10 + 55 * 4, 300, 20)
	$cComboItems[4] = GUICtrlCreateCombo("", 10, 10 + 55 * 4 + 20, 300, 20, 0x0003)
	GUICtrlCreateLabel(__GetLang('OPTIONS_CHECKBOX_5', 'Use automatic choice for duplicates') & ":", 10, 10 + 55 * 5, 300, 20)
	$cComboItems[5] = GUICtrlCreateCombo("", 10, 10 + 55 * 5 + 20, 300, 20, 0x0003)
	$cComboItems[6] = GUICtrlCreateCombo("", 10, 10 + 55 * 5 + 45, 300, 20, 0x0003)

	For $A = 0 To 5
		$cState = IniRead($cINI, $G_Global_GeneralSection, $cOptions[$A], "")
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
	$cCurrent[6] = __GetDuplicateMode(IniRead($cINI, $G_Global_GeneralSection, "DupMode", "Overwrite1"), 1)
	GUICtrlSetData($cComboItems[6], $cGroup, $cCurrent[6])

	$cState = $GUI_ENABLE
	If $cCurrent[5] <> __GetLang('OPTIONS_PROFILE_MODE_1', 'Enable for this profile') Then
		$cState = $GUI_DISABLE
	EndIf
	GUICtrlSetState($cComboItems[6], $cState)

	$cSave = GUICtrlCreateButton(__GetLang('SAVE', 'Save'), 160 - 25 - 80, 370, 80, 24)
	$cCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 160 + 25, 370, 80, 24)
	GUICtrlSetState($cSave, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)

	While 1
		If GUICtrlRead($cComboItems[5]) <> $cCurrent[5] And Not _GUICtrlComboBox_GetDroppedState($cComboItems[5]) Then
			$cCurrent[5] = GUICtrlRead($cComboItems[5])
			$cState = $GUI_ENABLE
			If $cCurrent[5] <> __GetLang('OPTIONS_PROFILE_MODE_1', 'Enable for this profile') Then
				$cState = $GUI_DISABLE
			EndIf
			GUICtrlSetState($cComboItems[6], $cState)
		EndIf

		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $cCancel
				ExitLoop

			Case $cSave
				For $A = 0 To 5
					$cState = GUICtrlRead($cComboItems[$A])
					Switch $cState
						Case __GetLang('OPTIONS_PROFILE_MODE_1', 'Enable for this profile')
							$cState = "True"
						Case __GetLang('OPTIONS_PROFILE_MODE_2', 'Disable for this profile')
							$cState = "False"
						Case Else
							$cState = "Default"
					EndSwitch
					__IniWriteEx($cINI, $G_Global_GeneralSection, $cOptions[$A], $cState)
				Next
				__IniWriteEx($cINI, $G_Global_GeneralSection, "DupMode", __GetDuplicateMode(GUICtrlRead($cComboItems[6])))
				ExitLoop

		EndSwitch
	WEnd
	GUIDelete($cGUI)

	Return 1
EndFunc   ;==>_Customize_Options

Func _Customize_Populate($cListView, $cProfileDirectory, $cProfileList = -1)
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

		$cIniRead = IniRead($cINI, $G_Global_TargetSection, "Image", "")
		If $cIniRead = "" Then
			$cIniRead = __GetDefault(16) ; Default Image File.
		EndIf
		_GUICtrlListView_AddSubItem($cListView, $cListViewItem, $cIniRead, 1)

		$cIniRead_Size[0] = IniRead($cINI, $G_Global_TargetSection, "SizeX", "")
		$cIniRead_Size[1] = IniRead($cINI, $G_Global_TargetSection, "SizeY", "")
		$cIniReadOpacity = IniRead($cINI, $G_Global_TargetSection, "Opacity", "")

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
EndFunc   ;==>_Customize_Populate

Func _Customize_ContextMenu_ListView($cmListView, $cmIndex, $cmSubItem)
	Local Enum $cmItem1 = 1000, $cmItem2, $cmItem3, $cmItem4, $cmItem5, $cmItem6, $cmItem7, $cmItem8, $cmItem9, $cmItem10, $cmItem11, $cmItem12, $cmItem13, $cmItem14, $cmItem15, $cmItem16
	Local $cmContextMenu_1, $cmContextMenu_2

	If IsHWnd($cmListView) = 0 Then
		$cmListView = GUICtrlGetHandle($cmListView)
	EndIf

	$cmContextMenu_1 = _GUICtrlMenu_CreatePopup()
	If $cmIndex <> -1 And $cmSubItem <> -1 Then ; Won't Show These MenuItem(s) Unless An Item Is Selected.
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __GetLang('EDIT', 'Edit'), $cmItem1)
		__SetItemImage("EDIT", $cmIndex, $cmContextMenu_1, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, "")
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __GetLang('OPTIONS', 'Options'), $cmItem8)
		__SetItemImage("OPT", $cmIndex, $cmContextMenu_1, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __GetLang('DUPLICATE', 'Duplicate'), $cmItem9)
		__SetItemImage("COPYTO", $cmIndex, $cmContextMenu_1, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __GetLang('EXPORT', 'Export'), $cmItem11)
		__SetItemImage("EXPORT", $cmIndex, $cmContextMenu_1, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, "")
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __GetLang('ACTION_DELETE', 'Delete'), $cmItem2)
		__SetItemImage("DEL", $cmIndex, $cmContextMenu_1, 2, 1)
	EndIf
	If $cmIndex = -1 And $cmSubItem <> -1 Then ; Will Show These MenuItem(s) If No Item Is Selected.
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __GetLang('NEW', 'New'), $cmItem3)
		__SetItemImage("NEW", $cmIndex, $cmContextMenu_1, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, "")
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __GetLang('IMPORT', 'Import'), $cmItem10)
		__SetItemImage("IMPORT", $cmIndex, $cmContextMenu_1, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __GetLang('IMPORT_ALL', 'Import all'), $cmItem15)
		__SetItemImage("IMPORT", $cmIndex, $cmContextMenu_1, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __GetLang('EXPORT_ALL', 'Export all'), $cmItem16)
		__SetItemImage("EXPORT", $cmIndex, $cmContextMenu_1, 2, 1)
		$cmContextMenu_2 = _GUICtrlMenu_CreatePopup()
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_1, __GetLang('EXAMPLES', 'Examples'), $cmItem4, $cmContextMenu_2)
		__SetItemImage("EXAMP", $cmIndex, $cmContextMenu_1, 2, 1)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_2, __GetLang('CUSTOMIZE_EXAMPLE_0', 'Archiver'), $cmItem5)
		__SetItemImage(__GetDefault(4) & "Big_Box4.png", $cmIndex, $cmContextMenu_2, 2, 0)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_2, __GetLang('CUSTOMIZE_EXAMPLE_1', 'Eraser'), $cmItem6)
		__SetItemImage(__GetDefault(4) & "Big_Delete1.png", $cmIndex, $cmContextMenu_2, 2, 0)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_2, __GetLang('CUSTOMIZE_EXAMPLE_2', 'Extractor'), $cmItem7)
		__SetItemImage(__GetDefault(4) & "Big_Box6.png", $cmIndex, $cmContextMenu_2, 2, 0)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_2, __GetLang('CUSTOMIZE_EXAMPLE_5', 'Gallery Maker'), $cmItem14)
		__SetItemImage(__GetDefault(4) & "Big_Gallery1.png", $cmIndex, $cmContextMenu_2, 2, 0)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_2, __GetLang('CUSTOMIZE_EXAMPLE_3', 'List Maker'), $cmItem12)
		__SetItemImage(__GetDefault(4) & "Big_List1.png", $cmIndex, $cmContextMenu_2, 2, 0)
		$cmIndex = _GUICtrlMenu_AddMenuItem($cmContextMenu_2, __GetLang('CUSTOMIZE_EXAMPLE_4', 'Playlist Maker'), $cmItem13)
		__SetItemImage(__GetDefault(4) & "Big_Playlist1.png", $cmIndex, $cmContextMenu_2, 2, 0)
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
		Case $cmItem11
			GUICtrlSendToDummy($Global_ListViewProfiles_Export)
		Case $cmItem15
			GUICtrlSendToDummy($Global_ListViewProfiles_ImportAll)
		Case $cmItem16
			GUICtrlSendToDummy($Global_ListViewProfiles_ExportAll)
		Case $cmItem5
			$Global_ListViewProfiles_Example[1] = __GetLang('CUSTOMIZE_EXAMPLE_0', 'Archiver')
			GUICtrlSendToDummy($Global_ListViewProfiles_Example[0])
		Case $cmItem6
			$Global_ListViewProfiles_Example[1] = __GetLang('CUSTOMIZE_EXAMPLE_1', 'Eraser')
			GUICtrlSendToDummy($Global_ListViewProfiles_Example[0])
		Case $cmItem7
			$Global_ListViewProfiles_Example[1] = __GetLang('CUSTOMIZE_EXAMPLE_2', 'Extractor')
			GUICtrlSendToDummy($Global_ListViewProfiles_Example[0])
		Case $cmItem14
			$Global_ListViewProfiles_Example[1] = __GetLang('CUSTOMIZE_EXAMPLE_5', 'Gallery Maker')
			GUICtrlSendToDummy($Global_ListViewProfiles_Example[0])
		Case $cmItem12
			$Global_ListViewProfiles_Example[1] = __GetLang('CUSTOMIZE_EXAMPLE_3', 'List Maker')
			GUICtrlSendToDummy($Global_ListViewProfiles_Example[0])
		Case $cmItem13
			$Global_ListViewProfiles_Example[1] = __GetLang('CUSTOMIZE_EXAMPLE_4', 'Playlist Maker')
			GUICtrlSendToDummy($Global_ListViewProfiles_Example[0])
	EndSwitch
	_GUICtrlMenu_DestroyMenu($cmContextMenu_1)
	_GUICtrlMenu_DestroyMenu($cmContextMenu_2)
	Return 1
EndFunc   ;==>_Customize_ContextMenu_ListView
#EndRegion >>>>> Customize Functions <<<<<

#Region >>>>> Processing Functions <<<<<
Func _DropEvent($dFiles, $dProfile, $dMonitored = 0)
	Local $dFailed, $dEndCommandLine, $dMainArray[10][7]

	Global $Global_File_Content[1][2]

	; Start Process:
	If IsArray($dFiles) = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	FileChangeDir(@ScriptDir) ; Ensure To Use DropIt.exe Directory As Working Directory.
	Local $dElementsGUI = _Sorting_CreateGUI($dProfile, $dMonitored) ; Create The Process GUI & Show It If Option Is Enabled.
	__ExpandEventMode(1) ; Enable Event Buttons.
	__ExpandEnvStrings(1) ; Enable The Expansion Of Environment Variables.
	_WinAPI_EmptyWorkingSet() ; Reduce Memory Usage Of DropIt.

	; Create The Array Of Dropped Items:
	GUICtrlSetData($dElementsGUI[0], __GetLang('POSITIONPROCESS_1', 'Loading files') & '...')
	$dMainArray = _Position_MainArray($dMainArray, $dFiles, $dElementsGUI)
	If @error Then ; Error Only If Aborted.
		_DropStop(1)
		Return SetError(1, 0, 0)
	EndIf
	If $dMainArray[0][0] == "" Or $dMainArray[0][0] = 0 Then ; Skip Monitored Folder If Empty.
		_DropStop()
		Return 1
	EndIf
	$dMainArray[0][2] = _DropCreateMainDirArray($dMainArray) ; Create Array Of Main Folders (It Will Be Used For %SubDir% Abbreviation).

	; Load And Check Total Size:
	__SetProgressStatus($dElementsGUI, 3, $dMainArray[0][1]) ; Reset General Progress Bar.
	__Log_Write(__GetLang('DROP_EVENT_TIP_0', 'Total Size Loaded'), __ByteSuffix($dMainArray[0][1])) ; __ByteSuffix() = Round A Value Of Bytes To Highest Value.
	_DropCheckSize($dMainArray[0][1])
	If @error Then ; Error Only If Aborted.
		_DropStop(1)
		Return SetError(1, 0, 0)
	EndIf

	; Update The Array Before Process Items:
	GUICtrlSetData($dElementsGUI[0], __GetLang('POSITIONPROCESS_11', 'Checking association matches') & '...')
	$dMainArray = _Position_Load($dMainArray, $dProfile, $dElementsGUI)
	If @error Then ; Error Only If Aborted.
		_DropStop(1)
		Return SetError(1, 0, 0)
	EndIf

	; Sort The Array And Populate The ListView:
	GUICtrlSetData($dElementsGUI[0], __GetLang('POSITIONPROCESS_12', 'Optimizing list of files') & '...')
	$dMainArray = _DropSortMainArray($dMainArray)
	_Position_Populate($Global_ListViewProcess, $dMainArray) ; Create The ListView.
	GUICtrlSetData($dElementsGUI[6], $dMainArray[0][0]) ; Update Counter.
	__SetProgressStatus($dElementsGUI, 3, $dMainArray[0][1]) ; Reset General Progress Bar.
	GUICtrlSetData($dElementsGUI[0], __GetLang('POSITIONPROCESS_13', 'Ready to start'))

	; Wait To Start If AutoStart Is Off:
	If __Is("AutoStart", -1, "False", $dProfile) = 0 And ($dMonitored = 0 Or (__Is("ShowMonitored") And $dMonitored)) Then
		_Sorting_Pause($dMainArray, 1)
		If $G_Global_AbortSorting Then
			_DropStop(1)
			Return SetError(1, 0, 0)
		EndIf
	EndIf

	; Process Items:
	$dFailed = _Position_Process($dMainArray, $dProfile, $dElementsGUI)
	If @error Then ; _Position_Process() Returns Error Only If Aborted.
		_DropStop(1)
		Return SetError(1, 0, 0)
	EndIf

	; End Process:
	If __Is("PlaySound") Then
		SoundPlay(@ScriptDir & '\Lib\sounds\complete.mp3')
	EndIf
	GUICtrlSetData($dElementsGUI[0], __GetLang('POSITIONPROCESS_14', 'Process complete!'))
	If $dFailed And __Is("AlertFailed") Then
		MsgBox(0x40, __GetLang('DROP_EVENT_MSGBOX_6', 'Process partially failed'), __GetLang('DROP_EVENT_MSGBOX_12', 'Process failed for some files/folders.') & @LF & __GetLang('DROP_EVENT_MSGBOX_13', 'You can find the report in "Status" column.'), 0, __OnTop($G_Global_SortingGUI))
		GUISetState(@SW_SHOWNOACTIVATE, $G_Global_SortingGUI)
		Local $dPos = WinGetPos($G_Global_SortingGUI)
		If $dPos[3] < 220 Then ; Force To Show The ListView.
			WinMove($G_Global_SortingGUI, "", $dPos[0], $dPos[1], $dPos[2], 320)
		EndIf
		_Sorting_Pause($dMainArray, 2)
	ElseIf __Is("AutoClose") = 0 And __Is("ShowSorting", -1, "True", $dProfile) And ($dMonitored = 0 Or (__Is("ShowMonitored") And $dMonitored)) Then
		_Sorting_Pause($dMainArray, 2)
	EndIf
	_DropStop()

	$dEndCommandLine = IniRead(__IsSettingsFile(), $G_Global_GeneralSection, "EndCommandLine", "")
	If $dEndCommandLine <> "" Then ; Advanced Feature To Run A Command Line At The End Of The Process.
		Run($dEndCommandLine, @ScriptDir)
	EndIf

	Return 1
EndFunc   ;==>_DropEvent

Func _DropCheckSize($dSize)
	If $dSize > 2 * 1024 * 1024 * 1024 And __Is("AlertSize") Then
		Local $dMsgBox = MsgBox(0x4, __GetLang('DROP_EVENT_MSGBOX_3', 'Estimated long processing time'), __GetLang('DROP_EVENT_MSGBOX_4', 'You are trying to process a large size of files') & " (" & __ByteSuffix($dSize) & ")" & @LF & __GetLang('DROP_EVENT_MSGBOX_5', 'It may take a long time, do you wish to continue?'), 0, __OnTop($G_Global_SortingGUI))
		If $dMsgBox <> 6 Then
			Return SetError(1, 0, 0) ; Process Aborted.
		EndIf
	EndIf
	Return 1
EndFunc   ;==>_DropCheckSize

Func _DropCreateMainDirArray($dMainArray)
	Local $dMainDirArray[$dMainArray[0][0] + 1] = [0]
	For $A = 1 To $dMainArray[0][0]
		If _WinAPI_PathIsDirectory($dMainArray[$A][0]) Then
			$dMainDirArray[0] += 1
			$dMainDirArray[$dMainDirArray[0]] = $dMainArray[$A][0]
		EndIf
	Next
	ReDim $dMainDirArray[$dMainDirArray[0] + 1]
	Return $dMainDirArray
EndFunc   ;==>_DropCreateMainDirArray

Func _DropSortMainArray($dMainArray)
	ReDim $dMainArray[$dMainArray[0][0] + 1][7] ; Remove Empty Fields.
	_ArraySortEx($dMainArray, 1, 0, 2, 3, 5) ; Sort By Action, Then By Destination, Then By Defined Parameter.
	Return $dMainArray
EndFunc   ;==>_DropSortMainArray

Func _DropStop($dAborted = 0)
	__ExpandEventMode(0) ; Disable Event Buttons.
	__ExpandEnvStrings(0) ; Disable The Expansion Of Environment Variables.
	__SetCurrentSize("ColumnProcess", $Global_ListViewProcess, 1) ; Column Widths.
	__SetCurrentSize("SizeProcess", $G_Global_SortingGUI) ; Window Width/Height.
	GUIDelete($G_Global_SortingGUI) ; Delete The Process GUI.
	$G_Global_AbortSorting = 0
	$G_Global_DuplicateMode = ""
	$G_Global_UserInput = ""
	ReDim $Global_PriorityActions[1]
	$Global_PriorityActions[0] = 0
	$Global_ListViewProcess_Open = 0
	$Global_ListViewProcess_Info = 0
	$Global_ListViewProcess_Skip = 0
	$Global_Wheel = 0
	$Global_Clipboard = ""
	If $dAborted Then
		__Log_Write(__GetLang('DROP_EVENT_TIP_1', 'Process stopped'), __GetLang('DROP_EVENT_TIP_2', 'Process interrupted by the user'))
	EndIf
EndFunc   ;==>_DropStop

Func _Matches_Filter($mFilePath, $mFilters)
	Local $mText[4], $mFileDate[6], $mAttributes, $mTemp, $mStringSplit, $mAllWords, $mCaseSensitive, $aMatches, $aMatch
	Local $mParamArray[$STATIC_FILTERS_NUMBER] = [0, 1, 0, 2, "A", "H", "R", "S", "T", 0, 0]
	Local $mFilterArray = StringSplit($mFilters, $STATIC_FILTERS_DIVIDER, 2)

	;Make sure the last filter is always kept as is, without splitting at $STATIC_FILTERS_DIVIDER (necessary for regex file content matches)
	If UBound($mFilterArray) >= $STATIC_FILTERS_NUMBER Then
		$aMatch = StringRegExp($mFilters, "(?:[^|]+\|){10}(.*)$", $STR_REGEXPARRAYMATCH)
		If @error = 0 Then
			$mFilterArray[$STATIC_FILTERS_NUMBER - 1] = $aMatch[0]
		EndIf
	EndIf

	ReDim $mFilterArray[$STATIC_FILTERS_NUMBER] ; Number Of Filters.

	For $A = 0 To $STATIC_FILTERS_NUMBER - 1
		If Number(StringLeft($mFilterArray[$A], 1)) <> 1 Then ; Filter Not Active.
			ContinueLoop
		EndIf
		$mText[0] = StringLeft(StringTrimLeft($mFilterArray[$A], 1), 1) ; Mode Character (<, >, =).
		$mText[1] = StringTrimLeft($mFilterArray[$A], 2) ; Full Next String.

		If $A < 4 Then ; Size, Dates.
			$mText[2] = StringRegExpReplace($mText[1], "[^0123456789\-]", "")
			$mText[3] = StringRegExpReplace($mText[1], "[0123456789\-]", "")
			If $A = 0 Then ; Size.
				$mTemp = __GetFileSize($mFilePath)
				Switch $mText[3]
					Case "bytes"
						$mTemp = Round($mTemp)
					Case "KB"
						$mTemp = Round($mTemp / 1024)
					Case "MB"
						$mTemp = Round($mTemp / (1024 * 1024))
					Case Else ; "GB".
						$mTemp = Round($mTemp / (1024 * 1024 * 1024))
				EndSwitch
			Else ; Dates.
				$mFileDate = FileGetTime($mFilePath, $mParamArray[$A])
				If @error = 0 Then
					$mTemp = _DateDiff($mText[3], $mFileDate[0] & "/" & $mFileDate[1] & "/" & $mFileDate[2] & " " & $mFileDate[3] & ":" & $mFileDate[4] & ":" & $mFileDate[5], _NowCalc())
				EndIf
			EndIf
			If @error = 0 Then
				Switch $mText[0]
					Case ">"
						If Not ($mTemp > $mText[2]) Then
							Return 0
						EndIf
					Case "<"
						If Not ($mTemp < $mText[2]) Then
							Return 0
						EndIf
					Case Else ; "=".
						$mStringSplit = StringSplit($mText[2], "-") ; To Support Number Range [100-300].
						ReDim $mStringSplit[3]
						If StringInStr($mText[2], "-") = 0 Then
							$mStringSplit[2] = $mStringSplit[1]
						EndIf
						If Not ($mTemp >= $mStringSplit[1] And $mTemp <= $mStringSplit[2]) Then
							Return 0
						EndIf
				EndSwitch
			EndIf

		ElseIf $A < 9 Then ; Attributes.
			$mAttributes = FileGetAttrib($mFilePath)
			If @error = 0 Then
				Switch $mText[1]
					Case "off"
						If StringInStr($mAttributes, $mParamArray[$A]) Then
							Return 0
						EndIf
					Case Else ; "on".
						If StringInStr($mAttributes, $mParamArray[$A]) = 0 Then
							Return 0
						EndIf
				EndSwitch
			EndIf

		ElseIf $A < 10 Then ; Included Files/Folders.
			If _WinAPI_PathIsDirectory($mFilePath) = 0 Then
				Return 0
			Else
				$mText[1] = StringReplace($mText[1], "|", ";") ; Because "|" Has Another Purpose In _FileListToArrayRec().
				_FileListToArrayRec($mFilePath, $mText[1], 0, 1, 0, 0)
				If @error Then
					Return 0
				EndIf
			EndIf

		Else ; File Content.
			Switch $mText[0]
				Case "-" ; At Least One Of The Words.
					$mAllWords = 0
					$mCaseSensitive = 0
				Case ">" ; At Least One Of The Words (Case Sensitive).
					$mAllWords = 0
					$mCaseSensitive = 1
				Case "x" ; All Words In Casual Order.
					$mAllWords = 1
					$mCaseSensitive = 0
				Case "+" ; All Words In Casual Order (Case Sensitive).
					$mAllWords = 1
					$mCaseSensitive = 1
				Case "~" ; Regular expression.
					$mAllWords = 3
					$mCaseSensitive = 1
				Case "=" ; Literal String.
					$mAllWords = 2
					$mCaseSensitive = 0
				Case Else ; Literal String (Case Sensitive).
					$mAllWords = 2
					$mCaseSensitive = 1
			EndSwitch
			If _WinAPI_PathIsDirectory($mFilePath) Then
				$aMatches = __FindInFolder($mFilePath, $mText[1], $mAllWords, $mCaseSensitive)
			Else
				$aMatches = __FindInFile($mFilePath, $mText[1], $mAllWords, $mCaseSensitive)
			EndIf
			If @error Then
				Return 0
			EndIf
			Return $aMatches
		EndIf
	Next

	Return 1
EndFunc   ;==>_Matches_Filter

Func _Matches_Select($mMatches, $mFilePath)
	If IsArray($mMatches) = 0 Then
		Return SetError(1, 0, 0) ; Exit Function If Not An Array.
	EndIf
	Local $mGUI, $mMsg, $mCancel, $mPriority, $mTwoColumns, $mString
	Local $mFromLeft, $mFromTop, $mHandle = $Global_GUI_1, $mRead = -1, $mButtons[$mMatches[0][0] + 1] = [0]
	If $mMatches[0][0] > 14 Then
		$mTwoColumns = 1
	EndIf
	Local $mWidth = 20 + 10 * $mTwoColumns + 300 * ($mTwoColumns + 1)
	Local $mRows = Int(($mMatches[0][0] + $mTwoColumns) / ($mTwoColumns + 1))

	$mGUI = GUICreate(__GetLang('MOREMATCHES_GUI', 'Select Action'), $mWidth, 165 + 23 * $mRows, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	If _WinAPI_PathIsDirectory($mFilePath) = 0 Then
		$mString = __GetLang('MOREMATCHES_LABEL_0', 'Loaded file:')
	Else
		$mString = __GetLang('MOREMATCHES_LABEL_3', 'Loaded folder:')
	EndIf
	GUICtrlCreateLabel($mString, 10, 10, $mWidth - 20, 20)
	GUICtrlCreateInput(__GetFileName($mFilePath), 10, 30, $mWidth - 20, 22, BitOR($ES_READONLY, $ES_AUTOHSCROLL, $ES_LEFT))
	GUICtrlCreateLabel(__GetLang('MOREMATCHES_LABEL_1', 'Select the action to use:'), 10, 60 + 10, $mWidth - 20, 20)

	For $A = 1 To $mMatches[0][0]
		$mMatches[$A][3] = __GetDestinationString($mMatches[$A][2], $mMatches[$A][3], $mMatches[$A][6]) ; Action, Destination, Site Settings.
		$mString = " " & _WinAPI_PathCompactPathEx($mMatches[$A][0], 35) & " (" & __GetActionString($mMatches[$A][2]) & ")"
		$mFromLeft = 10 + (300 + 10) * Int($A / ($mRows + 1))
		$mFromTop = 64 + 23 * $A - (23 * $mRows) * Int($A / ($mRows + 1))
		$mButtons[$A] = GUICtrlCreateButton($mString, $mFromLeft, $mFromTop, 300, 22, 0x0100)
		GUICtrlSetTip($mButtons[$A], $mMatches[$A][3], __GetLang('DESTINATION', 'Destination') & ":", 0, 2)
		$mButtons[0] += 1
	Next

	$mCancel = GUICtrlCreateButton(__GetLang('ACTION_IGNORE', 'Ignore'), ($mWidth / 2) - 50, 105 + 23 * $mRows, 100, 25)
	$mPriority = GUICtrlCreateCheckbox(__GetLang('MOREMATCHES_LABEL_2', 'Apply to all ambiguities of this drop'), 10, 140 + 23 * $mRows, $mWidth - 20, 20)
	If __Is("AmbiguitiesCheck") Then
		GUICtrlSetState($mPriority, $GUI_CHECKED)
	EndIf
	GUISetState(@SW_SHOWNOACTIVATE)

	While 1
		$mMsg = GUIGetMsg()
		Switch $mMsg
			Case $GUI_EVENT_CLOSE
				$mRead = -1
				ExitLoop

			Case $mCancel
				$mRead = -1
				If GUICtrlRead($mPriority) = 1 Then ; Save Priority Action If Selected.
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

Func _Position_Checking($pMainArray, $pIndex, $pAssociations, $pProfileName)
	Local $pMatch, $pCheck, $pAssociation, $pAssociationSplit, $pStringSplit, $pString, $pNoOthers, $pSomeFavourites, $pNumberMatchFields = 17, $aMatches
	Local $pFilePath = $pMainArray[$pIndex][0], $pMatches[1][$pNumberMatchFields + 1] = [[0, $pNumberMatchFields]]
	$pNoOthers = 0 ; For Special Associations That Match All Files That Have Not Other Matches.

	For $A = 1 To $pAssociations[0][0]
		$pMatch = 0
		$pAssociation = $pAssociations[$A][2]

		If $pAssociations[$A][1] <> $G_Global_StateDisabled Then ; Skip Association If It Is Disabled.
			If $pAssociations[$A][18] == "True" Then ; Consider Rules As Regular Expressions.
				$pMatch = StringRegExp($pFilePath, $pAssociation)
				If $pMatch = 1 Then
					$aMatches = _Matches_Filter($pFilePath, $pAssociations[$A][5])
					If IsArray($aMatches) Then
						$pMatch = 1
						$pMainArray[$pIndex][6] = $aMatches
					Else
						$pMatch = $aMatches
					EndIf
				EndIf
			Else
				$pAssociation = _ReplaceAbbreviation($pAssociation, 1, $pFilePath, $pProfileName, $pAssociations[$A][3], $pMainArray[0][2]) ; To Support Abbreviations In Rules.
				If @error Then
					ContinueLoop ; Skip Association If %UserInput% Value Is Not Defined.
				EndIf
				$pAssociation = StringReplace($pAssociation, "|", ";") ; To Support Both "|" And ";" As Separators.
				$pAssociation = StringReplace($pAssociation, "; ", ";") ; To Support Rules Also If Separated By A Space After Separators.
				$pAssociationSplit = StringSplit($pAssociation, ";")

				For $B = 1 To $pAssociationSplit[0]
					$pCheck = 0
					If ($pAssociationSplit[$B] == "#" Or $pAssociationSplit[$B] == "##") And $pNoOthers = 0 Then
						$pAssociationSplit[$B] = StringReplace($pAssociationSplit[$B], "#", "*")
						$pNoOthers = -1 ; It Means That This Will Be Used As "No Others" Association.
					EndIf

					If _WinAPI_PathIsDirectory($pFilePath) Then
						If StringInStr($pAssociationSplit[$B], "**") Then ; Rule For Folders.
							$pAssociationSplit[$B] = StringReplace($pAssociationSplit[$B], "**", "*")
							$pCheck = 1
						EndIf
					Else
						If StringInStr($pAssociationSplit[$B], "*") And StringInStr($pAssociationSplit[$B], "**") = 0 Then ; Rule For Files.
							$pCheck = 1
						EndIf
					EndIf

					If $pCheck Then
						$pAssociation = StringRegExpReplace($pAssociationSplit[$B], "(\.|\?|\+|\(|\)|\{|\}|\[|\]|\^|\$|\\)", "\\$1")
						$pAssociation = StringReplace($pAssociation, "*", "(.*?)") ; (.*?) = Match Any String Of Characters.
						$pStringSplit = StringSplit($pAssociation, "/") ; To Separate Exclusion Rules If Defined.

						For $C = 1 To $pStringSplit[0]
							If StringInStr($pStringSplit[$C], "\\") Then ; Rule Formatted As Path.
								$pString = $pFilePath
							Else ; Rule Formatted As File.
								$pString = __GetFileName($pFilePath)
							EndIf
							$pCheck = StringRegExp($pString, "^(?i)" & $pStringSplit[$C] & "$") ; ^ = Start String; (?i) = Case Insensitive; $ = End String.
							If $pCheck = 1 Then
								If $C = 1 Then ; It Match With Main Rule.
									$pMatch = 1
								Else ; It Match With Exclusion Rule.
									$pMatch = 0
									ExitLoop
								EndIf
							EndIf
						Next

						If $pMatch = 1 Then
							$aMatches = _Matches_Filter($pFilePath, $pAssociations[$A][5])
							If IsArray($aMatches) Then
								$pMatch = 1
								$pMainArray[$pIndex][6] = $aMatches
							Else
								$pMatch = $aMatches
							EndIf
						EndIf
						If $pMatch = 1 Then
							ExitLoop
						EndIf
						If $pNoOthers < 0 Then
							$pNoOthers = 0 ; If Does Not Match With A "No Others" Association.
						EndIf
					EndIf
				Next
			EndIf

			If $pMatch = 1 And $pMatches[0][0] < 40 Then
				$pMatches[0][0] += 1
				If UBound($pMatches) <= $pMatches[0][0] Then
					ReDim $pMatches[UBound($pMatches) * 2][$pNumberMatchFields + 1]
				EndIf
				$pMatches[$pMatches[0][0]][0] = $pAssociations[$A][0] ; Association Name.
				$pMatches[$pMatches[0][0]][1] = $pAssociations[$A][2] ; Rules.
				$pMatches[$pMatches[0][0]][2] = $pAssociations[$A][3] ; Action.
				$pMatches[$pMatches[0][0]][3] = $pAssociations[$A][4] ; Destination.
				$pMatches[$pMatches[0][0]][4] = $pAssociations[$A][6] ; List Properties.
				$pMatches[$pMatches[0][0]][5] = $pAssociations[$A][7] ; HTML Theme.
				$pMatches[$pMatches[0][0]][6] = $pAssociations[$A][8] ; Site Settings.
				$pMatches[$pMatches[0][0]][7] = $pAssociations[$A][9] ; Crypt Settings.
				$pMatches[$pMatches[0][0]][8] = $pAssociations[$A][10] ; Gallery Properties.
				$pMatches[$pMatches[0][0]][9] = $pAssociations[$A][11] ; Gallery Theme.
				$pMatches[$pMatches[0][0]][10] = $pAssociations[$A][12] ; Gallery Settings.
				$pMatches[$pMatches[0][0]][11] = $pAssociations[$A][13] ; Compress Settings.
				$pMatches[$pMatches[0][0]][12] = $pAssociations[$A][14] ; Extract Settings.
				$pMatches[$pMatches[0][0]][13] = $pAssociations[$A][15] ; Open With Settings.
				$pMatches[$pMatches[0][0]][14] = $pAssociations[$A][16] ; List Settings.
				$pMatches[$pMatches[0][0]][15] = $pAssociations[$A][17] ; Favourite Association.
				$pMatches[$pMatches[0][0]][16] = $pAssociations[$A][19] ; Split Settings.
				$pMatches[$pMatches[0][0]][17] = $pAssociations[$A][20] ; Join Settings.
				If $pNoOthers < 0 Then
					$pNoOthers = $pMatches[0][0] ; It Saves The Index Of The First "No Others" Association In $pMatches Array (More "No Others" Are Ignored).
				ElseIf $pMatches[$pMatches[0][0]][15] == "True" Then
					$pSomeFavourites = 1 ; There Is A Favourite Association.
				EndIf
			EndIf
		EndIf
	Next

	If $pMatches[0][0] > 1 And $pNoOthers > 0 Then
		_ArrayDelete($pMatches, $pNoOthers) ; If Item Matches With More Associations, Remove The "No Others" Association.
		$pMatches[0][0] -= 1
	EndIf
	If $pMatches[0][0] > 1 And $pSomeFavourites = 1 Then ; In This Case All Not Favourite Associations Are Removed From Matches.
		For $A = 1 To $pMatches[0][0]
			If $pMatches[0][0] < $A Then ; To Avoid Overflow Error.
				ExitLoop
			EndIf
			If $pMatches[$A][15] <> "True" Then
				_ArrayDelete($pMatches, $A) ; This Is A Not Favourite Association.
				$pMatches[0][0] -= 1
				$A -= 1
			EndIf
		Next
	EndIf

	$pMatch = 0
	If $pMatches[0][0] = 1 Then
		$pMatch = 1
	ElseIf $pMatches[0][0] > 1 Then
		If $Global_PriorityActions[0] > 0 Then ; Automatically Use Priority Action If File Matches With One Of Them.
			If $Global_PriorityActions[1] = "###" Then ; Skip Item If User Selected "Cancel" In Select Action Window.
				$pMatch = -1
			Else
				For $A = 1 To $Global_PriorityActions[0]
					For $B = 1 To $pMatches[0][0]
						If $Global_PriorityActions[$A] == $pMatches[$B][0] Then
							$pMatch = $B
						EndIf
					Next
				Next
			EndIf
		EndIf
		If $pMatch = 0 Then
			__ExpandEventMode(0) ; Disable Event Buttons.
			_ArraySort($pMatches, 0, 1, $pMatches[0][0], 0)
			If __Is("AlertAmbiguity") Then
				SoundPlay(@ScriptDir & '\Lib\sounds\ambiguity.mp3')
			EndIf
			$pMatch = _Matches_Select($pMatches, $pFilePath)
			__ExpandEventMode(1) ; Enable Event Buttons.
		EndIf
	EndIf

	If $pMatch > 0 Then
		$pMainArray[$pIndex][2] = $pMatches[$pMatch][2] ; Action.
		If $pMainArray[$pIndex][2] == "$2" Then ; Ignore Action.
			$pMainArray[$pIndex][4] = -1 ; To Skip.
		Else
			Switch $pMainArray[$pIndex][2]
				Case "$8" ; Create List Action.
					If $pMatches[$pMatch][5] == "" Then
						$pMatches[$pMatch][5] = "Default" ; Use Default Theme If Not Defined.
					EndIf
					If StringIsDigit(StringReplace($pMatches[$pMatch][4], ";", "")) Then
						$pMatches[$pMatch][4] = __ConvertListProperties($pMatches[$pMatch][4], $pProfileName, $pMatches[$pMatch][0])
					EndIf
					$pMatches[$pMatch][3] &= "|" & $pMatches[$pMatch][4] & "|" & $pProfileName & "|" & $pMatches[$pMatch][1] & "|" & $pMatches[$pMatch][0] & "|" & $pMatches[$pMatch][5] & "|" & $pMatches[$pMatch][14]
				Case "$3" ; Compress Action.
					$pMatches[$pMatch][3] &= "|" & $pMatches[$pMatch][11]
				Case "$4" ; Extract Action.
					$pMatches[$pMatch][3] &= "|" & $pMatches[$pMatch][12]
				Case "$5" ; Open With Action.
					$pMatches[$pMatch][3] &= "|" & $pMatches[$pMatch][13]
				Case "$C" ; Upload Action.
					$pMatches[$pMatch][3] &= "|" & $pMatches[$pMatch][6]
				Case "$F", "$G" ; Encrypt Or Decrypt Action.
					$pMatches[$pMatch][3] &= "|" & $pMatches[$pMatch][7]
				Case "$H" ; Create Gallery Action.
					$pMatches[$pMatch][3] &=  "\" & __GetLang('MANAGE_DESTINATION_GALLERY_FOLDER', 'DropIt Gallery') & "|" & $pMatches[$pMatch][8] & "|" & $pProfileName & "|" & $pMatches[$pMatch][0] & "|" & $pMatches[$pMatch][9] & "|" & $pMatches[$pMatch][10]
				Case "$I" ; Split Action.
					$pMatches[$pMatch][3] &= "|" & $pMatches[$pMatch][16]
				Case "$J" ; Join Action.
					$pMatches[$pMatch][3] &= "|" & $pMatches[$pMatch][17]
			EndSwitch
			$pMainArray[$pIndex][3] = $pMatches[$pMatch][3] ; Destination And Parameters.
			$pMainArray[$pIndex][4] = 0 ; OK.
		EndIf
	ElseIf $pMatch = 0 Then
		If _WinAPI_PathIsDirectory($pFilePath) And __Is("FolderAsFile", -1, "False", $pProfileName) = 0 Then
			$pMainArray[$pIndex][4] = -2 ; To Scan.
		Else
			$pMainArray[$pIndex][4] = -3 ; To Associate.
		EndIf
	Else ; $pMatch = -1 If User Selected "Cancel" In Select Action Window.
		$pMainArray[$pIndex][4] = -1 ; To Skip.
	EndIf

	Return $pMainArray
EndFunc   ;==>_Position_Checking

Func _Position_GetSortParam($pFilePath)
	Local $pParam
	Local $pINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $pOrderBy = IniRead($pINI, $G_Global_GeneralSection, "GroupOrder", "Path")

	Switch $pOrderBy
		Case "Name"
			$pParam = __GetFileName($pFilePath)
		Case "Extension"
			$pParam = __GetFileExtension($pFilePath)
		Case "Size"
			$pParam = __GetFileSize($pFilePath)
		Case "Created"
			$pParam = FileGetTime($pFilePath, 1, 1)
		Case "Modified"
			$pParam = FileGetTime($pFilePath, 0, 1)
		Case "Opened"
			$pParam = FileGetTime($pFilePath, 2, 1)
		Case Else ; Path.
			$pParam = $pFilePath
	EndSwitch

	Return $pParam
EndFunc   ;==>_Position_GetSortParam

Func _Position_MainArray($pMainArray, $pFiles, $pElementsGUI, $pScanLevel = 0)
	Local $pFileName, $pFilePath, $pSearch, $pSearchPath, $pFolderList[10] = [1, 0]

	For $A = 1 To $pFiles[0]
		_Sorting_CheckButtons($pMainArray)
		If @error Then
			Return SetError(1, 0, $pMainArray) ; Process Aborted.
		EndIf

		If $pScanLevel > 0 And _WinAPI_PathIsDirectory($pFiles[$A]) Then
			$pFiles[$A] = $pFiles[$A] & "\*.*"
		EndIf
		If StringInStr(__GetFileName($pFiles[$A]), "*") Then ; Load With Wildcards Input.
			$pSearchPath = $pFiles[$A]
			While $pFolderList[0] > 0
				$pSearch = FileFindFirstFile($pSearchPath)
				If $pSearch <> -1 Then
					While 1
						_Sorting_CheckButtons($pMainArray)
						If @error Then
							FileClose($pSearch)
							Return SetError(1, 0, $pMainArray) ; Process Aborted.
						EndIf

						$pFileName = FileFindNextFile($pSearch)
						If @error Then
							ExitLoop
						EndIf
						If @extended And $pScanLevel = 2 Then
							$pFolderList[0] += 1
							If UBound($pFolderList) <= $pFolderList[0] Then
								ReDim $pFolderList[UBound($pFolderList) * 2]
							EndIf
							$pFolderList[$pFolderList[0]] = __GetParentFolder($pSearchPath) & '\' & $pFileName
						Else
							$pFilePath = __GetParentFolder($pSearchPath) & '\' & $pFileName
							$pMainArray = _Position_MainArrayAdd($pMainArray, $pFilePath, $pElementsGUI)
						EndIf
					WEnd
					FileClose($pSearch)
				EndIf
				$pSearchPath = $pFolderList[$pFolderList[0]] & "\*.*"
				$pFolderList[0] -= 1
			WEnd
		ElseIf FileExists($pFiles[$A]) Then
			$pMainArray = _Position_MainArrayAdd($pMainArray, $pFiles[$A], $pElementsGUI)
		EndIf
	Next
	__SetProgressStatus($pElementsGUI, 1, '') ; Reset Single Progress Bar And Show Second Line.

	Return $pMainArray
EndFunc   ;==>_Position_MainArray

Func _Position_MainArrayAdd($pMainArray, $pFilePath, $pElementsGUI)
	Local $pSize

	$pMainArray[0][0] += 1 ; [0][0] Counter, [0][1] Full Size, [0][2] Main Dirs Array, [$A][0] File Path, [$A][1] File Size, [$A][2] Action, [$A][3] Destination, [$A][4] Result.
	If UBound($pMainArray) <= $pMainArray[0][0] Then
		ReDim $pMainArray[UBound($pMainArray) * 2][7]
	EndIf

	$pFilePath = _WinAPI_PathRemoveBackslash($pFilePath)
	$pMainArray[$pMainArray[0][0]][0] = $pFilePath
	$pSize = __GetFileSize($pFilePath)
	$pMainArray[0][1] += $pSize
	$pMainArray[$pMainArray[0][0]][1] = $pSize
	$pMainArray[$pMainArray[0][0]][5] = _Position_GetSortParam($pFilePath) ; Sort Files In Each Group By This Parameter.
	__SetProgressStatus($pElementsGUI, 1, $pFilePath) ; Reset Single Progress Bar And Show Second Line.
	GUICtrlSetData($pElementsGUI[6], $pMainArray[0][0]) ; Update Counter.

	Return $pMainArray
EndFunc   ;==>_Position_MainArrayAdd

Func _Position_Load($pMainArray, $pProfile, $pElementsGUI)
	Local $A, $pScanLevel = 1, $pFiles[2] = [1, 0]
	Local $pProfileName = __IsProfile($pProfile, 3) ; Get Current Profile Name.
	Local $pAssociations = __GetAssociations($pProfileName) ; Get Associations Array.
	If __Is("ScanSubfolders") Then
		$pScanLevel = 2
	EndIf

	While 1
		_Sorting_CheckButtons($pMainArray)
		If @error Then
			Return SetError(1, 0, $pMainArray) ; Process Aborted.
		EndIf

		$A += 1
		If FileExists($pMainArray[$A][0]) Then
			$pMainArray = _Position_Checking($pMainArray, $A, $pAssociations, $pProfileName) ; $pMainArray[$A][4] = OK [0], To Skip [-1], To Scan [-2], To Associate [-3].
		Else ; If No Longer Exists.
			$pMainArray[$A][4] = -1 ; To Skip.
		EndIf
		If $pMainArray[$A][4] == -3 Then ; To Associate.
			$pMainArray[$A][4] = -1 ; To Skip.
			If __Is("IgnoreNew", -1, "False", $pProfile) = 0 Then
				Switch MsgBox(0x03, __GetLang('POSITIONPROCESS_MSGBOX_0', 'Association Needed'), __GetLang('POSITIONPROCESS_MSGBOX_1', 'No association found for:') & @LF & $pMainArray[$A][0] & @LF & @LF & __GetLang('POSITIONPROCESS_MSGBOX_2', 'Do you want to create an association for it?'), 0, __OnTop($G_Global_SortingGUI))
					Case 6 ; Yes.
						__ExpandEventMode(0) ; Disable Event Buttons.
						If _Manage_Edit_GUI($pProfile, __GetFileNameOnly($pMainArray[$A][0]), __GetFileExtension($pMainArray[$A][0]), -1, -1, -1, -1, 1, 1) <> 0 Then ; _Manage_Edit_GUI() = Show Manage Edit GUI Of Selected Association.
							$pAssociations = __GetAssociations($pProfileName) ; Get Updated Associations Array.
							$pMainArray = _Position_Checking($pMainArray, $A, $pAssociations, $pProfileName) ; $pMainArray[$A][4] = OK [0], To Skip [-1], To Scan [-2], To Associate [-3].
						EndIf
						__ExpandEventMode(1) ; Enable Event Buttons.
					Case 7 ; No.
						$pMainArray[$A][4] = -1
					Case Else ; Abort.
						$pMainArray[$A][4] = -3
				EndSwitch
			EndIf
		EndIf

		Switch $pMainArray[$A][4]
			Case -3 ; Aborted.
				Return SetError(1, 0, $pMainArray)
			Case -2 ; To Scan.
				$pFiles[1] = $pMainArray[$A][0]
				$pMainArray = _Position_MainArray($pMainArray, $pFiles, $pElementsGUI, $pScanLevel)
				If @error Then ; _Position_MainArray() Returns Error Only If Aborted.
					Return SetError(1, 0, $pMainArray) ; Process Aborted.
				EndIf
				$pMainArray[0][1] -= $pMainArray[$A][1] ; Remove Folder Size Because Added Size Of Its Files.
				_ArrayDelete($pMainArray, $A) ; Remove Folder From The List.
				$pMainArray[0][0] -= 1
				$A -= 1
				GUICtrlSetData($pElementsGUI[6], $pMainArray[0][0]) ; Update Counter.
			Case Else
				$pMainArray[$A][3] = _Destination_Fix($pMainArray[$A][0], $pMainArray[$A][3], $pMainArray[$A][2], $pMainArray[$A][6], $pMainArray[0][2], $pProfile)
				If @error Then
					$pMainArray[$A][4] = -1 ; Skip Item If %UserInput% Value Is Not Defined.
				EndIf
				__SetProgressStatus($pElementsGUI, 4, $pMainArray[$A][1]) ; Update General Progress Bar.
				GUICtrlSetData($pElementsGUI[6], $A & " / " & $pMainArray[0][0]) ; Update Counter.
		EndSwitch

		If $A = $pMainArray[0][0] Then
			ExitLoop ; Needed Because $pMainArray[0][0] Is Updated During The Loop.
		EndIf
	WEnd

	Return $pMainArray
EndFunc   ;==>_Position_Load

Func _Position_Populate($pListView, $pMainArray)
	Local $pName, $pAction, $pDestination

	_GUICtrlListView_BeginUpdate($pListView)
	For $A = 1 To $pMainArray[0][0]
		$pName = __GetFileName($pMainArray[$A][0])
		$pAction = "-" ; Because The Item Is Skipped If The User Does Not Define An Association With _Manage_Edit_GUI().
		$pDestination = "-"
		If $pMainArray[$A][2] <> "" Then
			$pAction = __GetActionString($pMainArray[$A][2])
		EndIf
		If $pMainArray[$A][3] <> "" Then
			$pDestination = __GetDestinationString($pMainArray[$A][2], $pMainArray[$A][3]) ; Action, Destination.
		EndIf
		_GUICtrlListView_AddItem($pListView, $pName)
		_GUICtrlListView_AddSubItem($pListView, $A - 1, $pAction, 1)
		_GUICtrlListView_AddSubItem($pListView, $A - 1, $pDestination, 2)
	Next
	_GUICtrlListView_SetItemSelected($pListView, 0, False, False)
	_GUICtrlListView_EndUpdate($pListView)

	Return $pMainArray
EndFunc   ;==>_Position_Populate

Func _Position_Process($pMainArray, $pProfile, $pElementsGUI)
	Local $pFailed, $pFrom, $pTo, $pStringSplit, $pCounter, $pCurrentGroup, $pPreviousGroup = ""

	If _Copy_OpenDll(@ScriptDir & '\Lib\copy\Copy.dll') = 0 Then
		Return SetError(1, 0, 0) ; Process Aborted.
	EndIf

	For $A = 1 To $pMainArray[0][0] + 1
		_Sorting_CheckButtons($pMainArray)
		If @error Then
			_Copy_CloseDll()
			Return SetError(1, 0, 0) ; Process Aborted.
		EndIf

		$pCurrentGroup = "end" ; To Process Also The Last Item.
		If $A <= $pMainArray[0][0] Then
			If $pMainArray[$A][2] == "$2" Then
				$pMainArray[$A][4] = -1
				GUICtrlSetData($pElementsGUI[0], __GetLang('ACTION_IGNORE', 'Ignore'))
				__SetProgressStatus($pElementsGUI, 1, $pMainArray[$A][0]) ; Reset Single Progress Bar And Show Second Line.
			ElseIf _GUICtrlListView_GetItemText($Global_ListViewProcess, $A - 1, 3) <> "" Then ; Item Skipped By The User.
				$pMainArray[$A][4] = -1
			ElseIf __Is("IgnoreInUse") And $pMainArray[$A][2] <> "$5" And (__FileCompareSize($pMainArray[$A][0], $pMainArray[$A][1], 1) <> 0 Or __FileOrFolderInUse($pMainArray[$A][0]) <> 0) Then ; File Size Is Changed Or File Is In Use (Like During Download).
				$pMainArray[$A][4] = -1
			EndIf
			If $pMainArray[$A][4] == -1 Then
				If $pMainArray[$A][3] = "" Then
					$pMainArray[$A][3] = "-"
				EndIf
				__SetPositionResult($pMainArray, $A, $A, $Global_ListViewProcess, $pElementsGUI, -1)
				$pMainArray[$A][4] = -9 ; To Do Not Process It Again In Group.
				ContinueLoop
			EndIf
			$pCurrentGroup = $pMainArray[$A][2] & $pMainArray[$A][3] ; Unique String For Group = Action + Destination.
			If $pMainArray[$A][2] == "$7" Then
				$pCurrentGroup = $pMainArray[$A][2] & __GetParentFolder($pMainArray[$A][3]) ; To Support %Counter%.
			EndIf
		EndIf

		If $pPreviousGroup <> $pCurrentGroup Then
			$pTo = $A - 1 ; Last Item Of The Group.
			If $pPreviousGroup <> "" Then ; Process Previous Group If Not Empty.
				If _Position_ProcessGroup($pMainArray, $pFrom, $pTo, $pProfile, $pElementsGUI) = 1 Then ; 0 = OK, 1 = Failed.
					$pFailed = 1 ; At Least One Item Failed.
				EndIf
				If @error Then
					_Copy_CloseDll()
					Return SetError(1, 0, 0) ; Process Aborted.
				EndIf
			EndIf
			If $pCurrentGroup == "end" Then
				ExitLoop ; Exit If The Previous Was The Last Item.
			EndIf
			$pPreviousGroup = $pCurrentGroup ; Start A New Group.
			$pFrom = $A ; First Item Of The Group.
			$pCounter = 0 ; Used For %Counter% Abbreviation.
			GUICtrlSetData($pElementsGUI[0], __GetActionString($pMainArray[$A][2]))
			__SetProgressStatus($pElementsGUI, 1, '') ; Reset Single Progress Bar And Show Second Line.
		EndIf

		_GUICtrlListView_AddSubItem($Global_ListViewProcess, $A - 1, __GetLang('POSITIONPROCESS_LOG_1', 'Loaded'), 3) ; Set ListView State To "Loaded".
		__Log_Write(__GetLang('POSITIONPROCESS_LOG_1', 'Loaded'), $pMainArray[$A][0])
		$pCounter += 1 ; Used For %Counter% Abbreviation.
		$pStringSplit = StringSplit($pMainArray[$A][3], "|")
		If StringInStr($pStringSplit[1], "%") And StringInStr("$C" & "$D" & "$E", $pMainArray[$A][2]) = 0 Then
			$pStringSplit[1] = StringReplace($pStringSplit[1], "%Counter%", StringFormat("%02d", $pCounter))
			$pMainArray[$A][3] = _ArrayToString($pStringSplit, "|", 1)
		EndIf
	Next
	GUICtrlSetData($pElementsGUI[1], "")
	_Copy_CloseDll()

	Return $pFailed
EndFunc   ;==>_Position_Process

Func _Position_ProcessGroup($pMainArray, $pFrom, $pTo, $pProfile, $pElementsGUI)
	Local $pFailed, $pResult

	Switch $pMainArray[$pFrom][2]
		Case "$3" ; Compress Action.
			$pMainArray = _Sorting_CompressFile($pMainArray, $pFrom, $pTo, $pElementsGUI, $pProfile)

		Case "$7" ; Rename Action.
			$pMainArray = _Sorting_RenameFile($pMainArray, $pFrom, $pTo, $pElementsGUI, $pProfile)

		Case "$8" ; Create List Action.
			$pMainArray = _Sorting_ListFile($pMainArray, $pFrom, $pTo, $pElementsGUI, $pProfile)

		Case "$9" ; Create Playlist Action.
			$pMainArray = _Sorting_PlaylistFile($pMainArray, $pFrom, $pTo, $pElementsGUI, $pProfile)

		Case "$C" ; Upload Action.
			$pMainArray = _Sorting_UploadFile($pMainArray, $pFrom, $pTo, $pElementsGUI, $pProfile)

		Case "$E" ; Send by Mail Action.
			$pMainArray = _Sorting_MailFile($pMainArray, $pFrom, $pTo, $pElementsGUI)

		Case "$H" ; Create Gallery Action.
			$pMainArray = _Sorting_GalleryFile($pMainArray, $pFrom, $pTo, $pElementsGUI, $pProfile)

		Case "$J" ; Join Action.
			$pMainArray = _Sorting_JoinFile($pMainArray, $pFrom, $pTo, $pElementsGUI, $pProfile)

		Case Else ; Single Process Actions.
			For $A = $pFrom To $pTo
				If $pMainArray[$A][4] == -9 Then ; Skip Already Processed Item.
					ContinueLoop
				EndIf
				Switch $pMainArray[$pFrom][2]
					Case "$4" ; Extract Action.
						$pMainArray = _Sorting_ExtractFile($pMainArray, $A, $pElementsGUI, $pProfile)

					Case "$5" ; Open With Action.
						$pMainArray = _Sorting_OpenFile($pMainArray, $A, $pElementsGUI)

					Case "$6" ; Delete Action.
						$pMainArray = _Sorting_DeleteFile($pMainArray, $A, $pElementsGUI)

					Case "$A" ; Create Shortcut Action.
						$pMainArray = _Sorting_ShortcutFile($pMainArray, $A, $pElementsGUI, $pProfile)

					Case "$B" ; Copy To Clipboard Action.
						$pMainArray = _Sorting_ClipboardFile($pMainArray, $A, $pElementsGUI)

					Case "$D" ; Change Properties Action.
						$pMainArray = _Sorting_ChangeFile($pMainArray, $A, $pElementsGUI)

					Case "$F" ; Encrypt Action.
						$pMainArray = _Sorting_EncryptFile($pMainArray, $A, $pElementsGUI, $pProfile)

					Case "$G" ; Decrypt Action.
						$pMainArray = _Sorting_DecryptFile($pMainArray, $A, $pElementsGUI, $pProfile)

					Case "$I" ; Split Action.
						$pMainArray = _Sorting_SplitFile($pMainArray, $A, $pElementsGUI, $pProfile)

					Case "$K" ; Convert Image Action.
						$pMainArray = _Sorting_ConvertFile($pMainArray, $A, $pElementsGUI, $pProfile)

					Case "$M" ; Print Action.
						$pMainArray = _Sorting_PrintFile($pMainArray, $A, $pElementsGUI)

					Case Else ; Move Or Copy Action.
						$pMainArray = _Sorting_CopyFile($pMainArray, $A, $pElementsGUI, $pProfile)

				EndSwitch
				If @extended = 1 Then ; Aborted.
					Return SetError(1, 0, 0)
				ElseIf @error = 1 Then ; Skipped.
					$pResult = -1
				ElseIf @error = 2 Then ; Failed.
					$pResult = -2
					$pFailed = 1 ; At Least One Item Failed.
				Else ; OK.
					$pResult = 0
				EndIf
				__SetPositionResult($pMainArray, $A, $A, $Global_ListViewProcess, $pElementsGUI, $pResult)
			Next
			Return $pFailed

	EndSwitch

	If @extended = 1 Then ; Aborted.
		Return SetError(1, 0, 0)
	ElseIf @error = 1 Then ; All Skipped.
		$pResult = -1
	ElseIf @error = 2 Then ; All Failed.
		$pResult = -2
		$pFailed = 1 ; At Least One Item Failed.
	ElseIf @error = 3 Then ; Some Failed (Already Reported).
		$pResult = 0
		$pFailed = 1 ; At Least One Item Failed.
	Else ; OK.
		$pResult = 0
	EndIf
	__SetPositionResult($pMainArray, $pFrom, $pTo, $Global_ListViewProcess, $pElementsGUI, $pResult)
	Return $pFailed
EndFunc   ;==>_Position_ProcessGroup

Func _Destination_Fix($dFilePath, $dDestination, $dAction, $aFileContentMatches, $dMainDirs, $dProfile)
	Local $dStringSplit = StringSplit($dDestination, "|")

	; Substitute Abbreviations In Destination Only:
	If StringInStr($dStringSplit[1], "%") And StringInStr("$D" & "$E", $dAction) = 0 Then
		$dStringSplit[1] = _ReplaceAbbreviation($dStringSplit[1], 1, $dFilePath, $dProfile, $dAction, $dMainDirs, $aFileContentMatches)
		If @error Then
			Return SetError(1, 0, $dDestination) ; Skip Item If %UserInput% Value Is Not Defined.
		EndIf
	EndIf

	; Update Destination For Compress, Create Shortcut, Split, Join, Open With Actions:
	If $dAction == "$3" And __GetFileExtension($dStringSplit[1]) == "" Then
		$dStringSplit[1] &= "\" & __GetFileNameOnly(__GetFileName($dFilePath)) & ".zip" ; To Work Also If Destination Is A Directory.
	ElseIf $dAction == "$A" Then
		$dStringSplit[1] &= "\" & __GetFileName($dFilePath) & " - " & __GetLang('SHORTCUT', 'shortcut') & ".lnk"
	ElseIf $dAction == "$I" Or $dAction == "$J" Then
		$dStringSplit[1] &= "\" & __GetFileNameOnly($dFilePath)
	ElseIf $dAction == "$5" Then
		If StringInStr($dStringSplit[1], "%DefaultProgram%") Then
			$dStringSplit[1] = StringReplace($dStringSplit[1], '"%File%"', '')
			$dStringSplit[1] = StringReplace($dStringSplit[1], '%File%', '')
		ElseIf __Is("FixOpenWithDestination") And StringInStr($dStringSplit[1], "%File%") = 0 Then
			$dStringSplit[1] &= ' "%File%"'
		EndIf
		$dStringSplit[1] = StringReplace($dStringSplit[1], '%File%', $dFilePath)
	EndIf

	; Fix Relative Destination If Needed:
	If StringInStr("$5" & "$6" & "$B" & "$C" & "$D" & "$E" & "$M", $dAction) = 0 And StringInStr(StringLeft($dStringSplit[1], 2), "\\") = 0 And StringInStr(StringLeft($dStringSplit[1], 2), ":") = 0 Then
		$dStringSplit[1] = _WinAPI_GetFullPathName(__GetParentFolder($dFilePath) & "\" & $dStringSplit[1])
	EndIf

	$dDestination = _ArrayToString($dStringSplit, "|", 1)
	Return $dDestination
EndFunc   ;==>_Destination_Fix

Func _Destination_MailMessage($dFileNames, $dStringSplit)
	Local $dGUI, $dSave, $dCancel, $dInput_Array[6], $dError = 0

	__ExpandEventMode(0) ; Disable Event Buttons.
	$dGUI = GUICreate(__GetLang('ACTION_SEND_MAIL', 'Send by Mail') & " - " & $dStringSplit[5], 400, 410, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($G_Global_SortingGUI))

	GUICtrlCreateLabel(__GetLang('MOREMATCHES_LABEL_0', 'Loaded item:'), 10, 10, 380, 20)
	GUICtrlCreateEdit($dFileNames, 10, 30, 380, 52, $ES_MULTILINE + $ES_READONLY + $WS_VSCROLL)
	GUICtrlCreateLabel(__GetLang('MAIL_TO', 'To') & ":", 10, 90 + 10, 380, 20)
	$dInput_Array[1] = GUICtrlCreateInput($dStringSplit[8], 10, 90 + 30, 380, 22)
	GUICtrlCreateLabel(__GetLang('MANAGE_MAIL_LABEL_3', 'Cc') & ":", 10, 90 + 60 + 10, 190, 20)
	$dInput_Array[2] = GUICtrlCreateInput($dStringSplit[9], 10, 90 + 60 + 30, 185, 22)
	GUICtrlCreateLabel(__GetLang('MANAGE_MAIL_LABEL_4', 'Bcc') & ":", 10 + 195, 90 + 60 + 10, 190, 20)
	$dInput_Array[3] = GUICtrlCreateInput($dStringSplit[10], 10 + 195, 90 + 60 + 30, 185, 22)
	GUICtrlCreateLabel(__GetLang('MANAGE_MAIL_LABEL_5', 'Subject') & ":", 10, 90 + 120 + 10, 300, 20)
	$dInput_Array[4] = GUICtrlCreateInput($dStringSplit[11], 10, 90 + 120 + 30, 380, 22)
	GUICtrlCreateLabel(__GetLang('MANAGE_MAIL_LABEL_6', 'Body') & ":", 10, 90 + 180 + 10, 300, 20)
	$dInput_Array[5] = GUICtrlCreateEdit($dStringSplit[12], 10, 90 + 180 + 30, 380, 60, BitOR($WS_VSCROLL, $ES_AUTOVSCROLL, $ES_WANTRETURN))

	$dSave = GUICtrlCreateButton(__GetLang('OK', 'OK'), 200 - 60 - 85, 375, 85, 24)
	$dCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 200 + 60, 375, 85, 24)
	GUICtrlSetState($dSave, $GUI_DEFBUTTON)
	GUISetState(@SW_SHOW)

	While 1
		; Enable/Disable Save Button:
		If GUICtrlRead($dInput_Array[1]) <> "" Then
			If GUICtrlGetState($dSave) > 80 Then
				GUICtrlSetState($dSave, 576) ; $GUI_ENABLE + $GUI_DEFBUTTON.
			EndIf
			If GUICtrlGetState($dCancel) = 512 Then
				GUICtrlSetState($dCancel, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
		ElseIf GUICtrlRead($dInput_Array[1]) = "" Then
			If GUICtrlGetState($dSave) = 80 Then
				GUICtrlSetState($dSave, 144) ; $GUI_DISABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($dCancel) = 80 Then
				GUICtrlSetState($dCancel, 512) ; $GUI_DEFBUTTON.
			EndIf
		EndIf

		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $dCancel
				$dError = 1
				ExitLoop

			Case $dSave
				$dStringSplit[8] = GUICtrlRead($dInput_Array[1])
				$dStringSplit[9] = GUICtrlRead($dInput_Array[2])
				$dStringSplit[10] = GUICtrlRead($dInput_Array[3])
				$dStringSplit[11] = GUICtrlRead($dInput_Array[4])
				$dStringSplit[12] = GUICtrlRead($dInput_Array[5])
				ExitLoop

		EndSwitch
	WEnd
	GUIDelete($dGUI)
	__ExpandEventMode(1) ; Enable Event Buttons.

	Return SetError($dError, 0, $dStringSplit)
EndFunc   ;==>_Destination_MailMessage

Func _Sorting_CheckButtons($sMainArray, $sIsCopying = 0)
	If $G_Global_PauseSorting Then
		If $sIsCopying Then
			_Copy_Pause(True)
		EndIf
		_Sorting_Pause($sMainArray)
		If $sIsCopying Then
			_Copy_Pause(False)
		EndIf
	EndIf
	If $G_Global_AbortSorting Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_Sorting_CheckButtons

Func _Sorting_EventButtons()
	Switch @GUI_CtrlId
		Case $GUI_EVENT_CLOSE, $Global_AbortButton
			$G_Global_PauseSorting = 0
			$G_Global_AbortSorting = 1
			GUICtrlSetState($Global_PauseButton, $GUI_DISABLE)
			GUICtrlSetState($Global_AbortButton, $GUI_DISABLE)
		Case $Global_PauseButton
			$G_Global_PauseSorting = 1
			GUICtrlSetState($Global_PauseButton, $GUI_DISABLE)
			GUICtrlSetState($Global_AbortButton, $GUI_DISABLE)
	EndSwitch
EndFunc   ;==>_Sorting_EventButtons

Func _Sorting_Pause($sMainArray, $sMode = 0)
	Local $sIndices_Selected, $sStatus, $sOpenDummy = -1, $sInfoDummy = -1, $sSkipDummy = -1

	$G_Global_PauseSorting = 2 ; To Define That The Process Is In This Function.
	GUICtrlSetState($Global_PauseButton, $GUI_ENABLE)
	GUICtrlSetState($Global_AbortButton, $GUI_ENABLE)
	If $sMainArray[0][0] = 0 Then ; Disable Start Button If 0 Items.
		GUICtrlSetState($Global_PauseButton, $GUI_DISABLE)
	EndIf
	If $Global_ListViewProcess_Open <> 0 Then
		GUIRegisterMsg($WM_NOTIFY, "_WM_NOTIFY")
		$sOpenDummy = $Global_ListViewProcess_Open
		$sInfoDummy = $Global_ListViewProcess_Info
		$sSkipDummy = $Global_ListViewProcess_Skip
	Else
		GUIRegisterMsg($WM_NOTIFY, "")
	EndIf
	$Global_ListViewIndex = -1 ; Set As No Item Selected.

	If $sMode = 1 Then
		GUICtrlSetTip($Global_PauseButton, __GetLang('POSITIONPROCESS_7', 'Start'))
		GUICtrlSetImage($Global_PauseButton, @ScriptFullPath, -18, 0)
	ElseIf $sMode = 2 Then
		GUICtrlSetTip($Global_PauseButton, __GetLang('POSITIONPROCESS_8', 'Done'))
		GUICtrlSetImage($Global_PauseButton, @ScriptFullPath, -20, 0)
		GUICtrlSetState($Global_AbortButton, $GUI_DISABLE)
	Else
		GUICtrlSetTip($Global_PauseButton, __GetLang('POSITIONPROCESS_4', 'Resume'))
		GUICtrlSetImage($Global_PauseButton, @ScriptFullPath, -18, 0)
	EndIf

	__ExpandEventMode(0) ; Disable Event Buttons.
	While $G_Global_PauseSorting
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $Global_AbortButton
				$G_Global_PauseSorting = 0
				$G_Global_AbortSorting = 1
				GUICtrlSetState($Global_PauseButton, $GUI_DISABLE)
				GUICtrlSetState($Global_AbortButton, $GUI_DISABLE)
			Case $Global_PauseButton
				$G_Global_PauseSorting = 0
				GUICtrlSetTip($Global_PauseButton, __GetLang('POSITIONPROCESS_3', 'Pause'))
				GUICtrlSetImage($Global_PauseButton, @ScriptFullPath, -17, 0)
			Case $sOpenDummy
				$sIndices_Selected = _GUICtrlListView_GetSelectedIndices($Global_ListViewProcess, True)
				For $A = 1 To $sIndices_Selected[0]
					__ShellExecuteOnTop($sMainArray[$sIndices_Selected[$A] + 1][0])
				Next
			Case $sInfoDummy
				$sIndices_Selected = _GUICtrlListView_GetSelectedIndices($Global_ListViewProcess, True)
				For $A = 1 To $sIndices_Selected[0]
					_Sorting_Pause_Info($sMainArray[$sIndices_Selected[$A] + 1][0])
				Next
			Case $sSkipDummy
				$sIndices_Selected = _GUICtrlListView_GetSelectedIndices($Global_ListViewProcess, True)
				For $A = 1 To $sIndices_Selected[0]
					$sStatus = _GUICtrlListView_GetItemText($Global_ListViewProcess, $sIndices_Selected[$A], 3)
					If $sStatus == "" Then
						$sStatus = __GetLang('DUPLICATE_MODE_6', 'Skip')
					ElseIf $sStatus == __GetLang('DUPLICATE_MODE_6', 'Skip') Then
						$sStatus = ""
					EndIf
					_GUICtrlListView_AddSubItem($Global_ListViewProcess, $sIndices_Selected[$A], $sStatus, 3)
				Next
		EndSwitch
	WEnd
	__ExpandEventMode(1) ; Enable Event Buttons.
EndFunc   ;==>_Sorting_Pause

Func _Sorting_Pause_ContextMenu($sListView, $sIndex, $sSubItem)
	Local Enum $sItem1 = 1000, $sItem2, $sItem3

	If IsHWnd($sListView) = 0 Then
		$sListView = GUICtrlGetHandle($sListView)
	EndIf

	Local $sStatus = _GUICtrlListView_GetItemText($sListView, $sIndex, 3)
	Local $sContextMenu = _GUICtrlMenu_CreatePopup()
	If $sIndex <> -1 And $sSubItem <> -1 Then
		$sIndex = _GUICtrlMenu_AddMenuItem($sContextMenu, __GetLang('OPEN', 'Open'), $sItem1)
		__SetItemImage("OPEN", $sIndex, $sContextMenu, 2, 1)
		$sIndex = _GUICtrlMenu_AddMenuItem($sContextMenu, __GetLang('ENV_VAR_TAB_3', 'Info'), $sItem2)
		__SetItemImage("INFO", $sIndex, $sContextMenu, 2, 1)
		If $sStatus == "" Then
			$sIndex = _GUICtrlMenu_AddMenuItem($sContextMenu, __GetLang('DUPLICATE_MODE_6', 'Skip'), $sItem3)
			__SetItemImage("SKIP", $sIndex, $sContextMenu, 2, 1)
		ElseIf $sStatus == __GetLang('DUPLICATE_MODE_6', 'Skip') Then
			$sIndex = _GUICtrlMenu_AddMenuItem($sContextMenu, __GetLang('OPTIONS_BUTTON_2', 'Restore'), $sItem3)
			__SetItemImage("NEW", $sIndex, $sContextMenu, 2, 1)
		EndIf
	EndIf

	Switch _GUICtrlMenu_TrackPopupMenu($sContextMenu, $sListView, -1, -1, 1, 1, 2)
		Case $sItem1
			GUICtrlSendToDummy($Global_ListViewProcess_Open)
		Case $sItem2
			GUICtrlSendToDummy($Global_ListViewProcess_Info)
		Case $sItem3
			GUICtrlSendToDummy($Global_ListViewProcess_Skip)
	EndSwitch
	_GUICtrlMenu_DestroyMenu($sContextMenu)
	Return 1
EndFunc   ;==>_Sorting_Pause_ContextMenu

Func _Sorting_Pause_Info($sFilePath)
	Local $sGUI, $sClose, $sListView, $sListView_Handle, $sToolTip, $sProperty, $sIndex

	If FileExists($sFilePath) = 0 Then
		MsgBox(0x30, __GetLang('POSITIONPROCESS_MSGBOX_6', 'Info Error'), __GetLang('POSITIONPROCESS_MSGBOX_7', 'Selected file/folder does not exist.'), 0, __OnTop($G_Global_SortingGUI))
		Return 1
	EndIf

	$sGUI = GUICreate(__GetLang('ENV_VAR_TAB_3', 'Info'), 440, 500, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($G_Global_SortingGUI))

	$sListView = GUICtrlCreateListView(__GetLang('PROPERTY', 'Property') & "|" & __GetLang('VALUE', 'Value'), 0, 0, 440, 460, BitOR($LVS_NOSORTHEADER, $LVS_REPORT, $LVS_SINGLESEL))
	$sListView_Handle = GUICtrlGetHandle($sListView)
	_GUICtrlListView_SetExtendedListViewStyle($sListView_Handle, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_INFOTIP))
	_GUICtrlListView_SetColumnWidth($sListView_Handle, 0, 160)
	_GUICtrlListView_SetColumnWidth($sListView_Handle, 1, 250)

	$sToolTip = _GUICtrlListView_GetToolTips($sListView_Handle)
	If IsHWnd($sToolTip) Then
		__OnTop($sToolTip, 1)
		_GUIToolTip_SetDelayTime($sToolTip, 3, 60) ; Speed Up InfoTip Appearance.
	EndIf

	$sClose = GUICtrlCreateButton(__GetLang('CLOSE', 'Close'), 220 - 50, 467, 100, 26)
	GUICtrlSetState($sClose, $GUI_DEFBUTTON + $GUI_DISABLE)
	GUISetState(@SW_SHOW)

	For $A = 0 To 300
		$sProperty = __GetFileProperties($sFilePath, $A, 2)
		If StringStripWS($sProperty[1], 8) <> "" Then
			$sIndex = _GUICtrlListView_AddItem($sListView, $sProperty[0])
			_GUICtrlListView_AddSubItem($sListView, $sIndex, $sProperty[1], 1)
		EndIf
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $sClose
				GUIDelete($sGUI)
				Return 1
		EndSwitch
	Next
	GUICtrlSetState($sClose, $GUI_ENABLE)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $sClose
				GUIDelete($sGUI)
				Return 1
		EndSwitch
	WEnd
EndFunc   ;==>_Sorting_Pause_Info

Func _Sorting_CreateGUI($sProfile, $sMonitored)
	Local $sLabel_1, $sLabel_2, $sProgress_1, $sProgress_2, $sPercent_1, $sPercent_2
	Local $sListView, $sListView_Handle, $sToolTip, $sCounter
	Local $sSize = __GetCurrentSize("SizeProcess", "500;300;-1;-1") ; Window Width/Height.
	Local $sProfileName = __IsProfile($sProfile, 3) ; Get Current Profile Name.

	$G_Global_SortingGUI = GUICreate(__GetLang('POSITIONPROCESS_0', 'Processing with DropIt') & " [" & $sProfileName & "]", $sSize[1], $sSize[2], $sSize[3], $sSize[4], BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX), -1, __OnTop($Global_GUI_1))
	GUISetOnEvent($GUI_EVENT_CLOSE, '_Sorting_EventButtons')
	$sLabel_1 = GUICtrlCreateLabel('', 12, 14, $sSize[1] - 124, 16, $STATIC_COMPACT_END)
	GUICtrlSetResizing($sLabel_1, $GUI_DOCKHEIGHT + $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP)
	$sCounter = GUICtrlCreateLabel('', 12 + $sSize[1] - 124, 14, 100, 16, $SS_RIGHT)
	GUICtrlSetResizing($sCounter, $GUI_DOCKSIZE + $GUI_DOCKRIGHT + $GUI_DOCKTOP)
	$sLabel_2 = GUICtrlCreateLabel('', 12, 14 + 20, $sSize[1] - 24, 16, $STATIC_COMPACT_PATH)
	GUICtrlSetResizing($sLabel_2, $GUI_DOCKHEIGHT + $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP)
	$sProgress_2 = GUICtrlCreateProgress(12, 14 + 43, $sSize[1] - 60, 12)
	GUICtrlSetResizing($sProgress_2, $GUI_DOCKHEIGHT + $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP)
	$sPercent_2 = GUICtrlCreateLabel('0 %', 12 + $sSize[1] - 58, 14 + 43, 34, 16, $SS_RIGHT)
	GUICtrlSetResizing($sPercent_2, $GUI_DOCKSIZE + $GUI_DOCKRIGHT + $GUI_DOCKTOP)
	$sProgress_1 = GUICtrlCreateProgress(12, 14 + 64, $sSize[1] - 60, 18)
	GUICtrlSetResizing($sProgress_1, $GUI_DOCKHEIGHT + $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP)
	$sPercent_1 = GUICtrlCreateLabel('0 %', 12 + $sSize[1] - 58, 14 + 67, 34, 16, $SS_RIGHT)
	GUICtrlSetResizing($sPercent_1, $GUI_DOCKSIZE + $GUI_DOCKRIGHT + $GUI_DOCKTOP)

	$Global_PauseButton = GUICtrlCreateButton("P", 70, 110, 68, 26, $BS_ICON)
	GUICtrlSetTip($Global_PauseButton, __GetLang('POSITIONPROCESS_3', 'Pause'))
	GUICtrlSetOnEvent($Global_PauseButton, '_Sorting_EventButtons')
	GUICtrlSetImage($Global_PauseButton, @ScriptFullPath, -17, 0)
	GUICtrlSetResizing($Global_PauseButton, $GUI_DOCKSIZE + $GUI_DOCKLEFT + $GUI_DOCKTOP)

	$Global_AbortButton = GUICtrlCreateButton("X", $sSize[1] - 70 - 68, 110, 68, 26, $BS_ICON)
	GUICtrlSetTip($Global_AbortButton, __GetLang('POSITIONPROCESS_2', 'Stop'))
	GUICtrlSetOnEvent($Global_AbortButton, '_Sorting_EventButtons')
	GUICtrlSetImage($Global_AbortButton, @ScriptFullPath, -16, 0)
	GUICtrlSetResizing($Global_AbortButton, $GUI_DOCKSIZE + $GUI_DOCKRIGHT + $GUI_DOCKTOP)

	$sListView = GUICtrlCreateListView(__GetLang('NAME', 'Name') & "|" & __GetLang('ACTION', 'Action') & "|" & __GetLang('DESTINATION', 'Destination') & "|" & __GetLang('STATUS', 'Status'), 0, 150, $sSize[1], $sSize[2] - 150, BitOR($LVS_NOSORTHEADER, $LVS_REPORT))
	$sListView_Handle = GUICtrlGetHandle($sListView)
	$Global_ListViewProcess = $sListView_Handle
	GUICtrlSetResizing($sListView, $GUI_DOCKBORDERS)
	_GUICtrlListView_SetExtendedListViewStyle($sListView_Handle, BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_INFOTIP))
	Local $sColumnSize = __GetCurrentSize("ColumnProcess", "140;80;180;70") ; Column Widths.
	For $A = 1 To $sColumnSize[0]
		_GUICtrlListView_SetColumnWidth($sListView_Handle, $A - 1, $sColumnSize[$A])
	Next

	$sToolTip = _GUICtrlListView_GetToolTips($sListView_Handle)
	If IsHWnd($sToolTip) Then
		__OnTop($sToolTip, 1)
		_GUIToolTip_SetDelayTime($sToolTip, 3, 60) ; Speed Up InfoTip Appearance.
	EndIf

	$Global_ListViewProcess_Open = GUICtrlCreateDummy()
	$Global_ListViewProcess_Info = GUICtrlCreateDummy()
	$Global_ListViewProcess_Skip = GUICtrlCreateDummy()
	$Global_ResizeMinWidth = 420 ; Set Default Min Width.
	$Global_ResizeMaxWidth = @DesktopWidth ; Set Default Max Width.
	$Global_ResizeMinHeight = 186 ; Set Default Min Height.
	$Global_ResizeMaxHeight = @DesktopHeight ; Set Default Max Height.
	GUIRegisterMsg($WM_GETMINMAXINFO, "_WM_GETMINMAXINFO")

	Local $sElementsGUI[7] = [$sLabel_1, $sLabel_2, $sProgress_1, $sProgress_2, $sPercent_1, $sPercent_2, $sCounter] ; Populate Elements GUI.

	If __Is("ShowSorting", -1, "True", $sProfile) And $sMonitored = 0 Then
		GUISetState(@SW_SHOW, $G_Global_SortingGUI)
	ElseIf __Is("ShowMonitored") And $sMonitored Then
		GUISetState(@SW_SHOWNOACTIVATE, $G_Global_SortingGUI)
	EndIf

	Return $sElementsGUI
EndFunc   ;==>_Sorting_CreateGUI

Func _Sorting_ChangeFile($sMainArray, $sIndex, $sElementsGUI)
	Local $B, $sStringSplit, $sAttributes, $sNewAttribute, $sReadOnly, $sFileTimes[3], $sSource = $sMainArray[$sIndex][0]

	$sAttributes = FileGetAttrib($sSource)
	$sStringSplit = StringSplit($sMainArray[$sIndex][3], ";") ; {modified} YYYYMMDD;HHMMSS;0h; {created} YYYYMMDD;HHMMSS;0h; {opened} YYYYMMDD;HHMMSS;0h; {attributes} A0;H0;R0;S0;T0
	__SetProgressStatus($sElementsGUI, 1, $sSource) ; Reset Single Progress Bar And Show Second Line.

	If __IsReadOnly($sSource) Then
		If __Is("IgnoreAttributes") Then
			FileSetAttrib($sSource, '-R')
			$sReadOnly = 1
		Else
			Return SetError(2, 0, $sMainArray) ; Failed.
		EndIf
	EndIf

	For $A = 0 To 2 ; Modified, Created, Opened.
		$B = 3 * $A + 1

		$sFileTimes[$A] = FileGetTime($sSource, $A, 1)
		If StringLen($sStringSplit[$B]) <> 0 Then ; Date [YYYYMMDD].
			$sFileTimes[$A] = $sStringSplit[$B] & StringTrimLeft($sFileTimes[$A], 8)
		EndIf
		If StringLen($sStringSplit[$B + 1]) <> 0 Then ; Time [HHMMSS].
			$sFileTimes[$A] = StringTrimRight($sFileTimes[$A], 6) & $sStringSplit[$B + 1]
		EndIf
		If StringLen($sStringSplit[$B + 2]) <> 0 Then ; Add [-3h].
			$sFileTimes[$A] = StringRegExpReplace($sFileTimes[$A], "(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})", "$1/$2/$3 $4:$5:$6")
			$sFileTimes[$A] = _DateAdd(StringRight($sStringSplit[$B + 2], 1), Number(StringTrimRight($sStringSplit[$B + 2], 1)), $sFileTimes[$A])
			If @error Then
				Return SetError(2, 0, $sMainArray) ; Failed.
			EndIf
			$sFileTimes[$A] = StringRegExpReplace($sFileTimes[$A], "[^0-9]", "")
		EndIf

		If FileSetTime($sSource, $sFileTimes[$A], $A) = 0 Then
			Return SetError(2, 0, $sMainArray) ; Failed.
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
			Return SetError(2, 0, $sMainArray) ; Failed.
		EndIf
	Next

	Return $sMainArray ; OK.
EndFunc   ;==>_Sorting_ChangeFile

Func _Sorting_ClipboardFile($sMainArray, $sIndex, $sElementsGUI)
	Local $sClipboardText = $sMainArray[$sIndex][3]

	__SetProgressStatus($sElementsGUI, 1, $sClipboardText) ; Reset Single Progress Bar And Show Second Line.

	If $Global_Clipboard <> "" Then
		$Global_Clipboard &= @CRLF
	EndIf
	$Global_Clipboard &= $sClipboardText
	ClipPut($Global_Clipboard)
	If @error Then
		Return SetError(2, 0, $sMainArray) ; Failed.
	EndIf

	Return $sMainArray ; OK.
EndFunc   ;==>_Sorting_ClipboardFile

Func _Sorting_CompressFile($sMainArray, $sFrom, $sTo, $sElementsGUI, $sProfile)
	Local $sError, $sFile, $sString, $sStringSplit, $sStringContent, $sArchiveContent, $sNewPath, $sTempMoved, $sSize, $sDestination = $sMainArray[$sFrom][3]
	Local $sSourceList = $G_Global_TempDir & "\DropItArchiveList.dat"

	$sStringSplit = StringSplit($sDestination, "|") ; 1 = Destination Archive, 2 = Other Settings.
	ReDim $sStringSplit[3]
	$sDestination = $sStringSplit[1]
	$sStringSplit = StringSplit(__GetDefaultCompressSettings($sStringSplit[2], $sDestination), ";") ; 1 = Remove Source, 2 = Compress Format, 3 = Level, 4 = Method, 5 = Encryption, 6 = Password.
	ReDim $sStringSplit[7]

	If FileExists($sDestination) Then
		$sDestination = __Duplicate_Process($sProfile, -1, $sDestination, 1) ; Support To Merge Archives Instead Of Overwrite Them.
		If @error = 1 Then
			$sStringSplit[6] = __7ZipGetPassword($sDestination, $sStringSplit[6]) ; Password.
			Switch @error
				Case 1
					Return SetError(2, 0, $sMainArray) ; Failed.
				Case 2
					Return SetError(1, 0, $sMainArray) ; Skipped.
			EndSwitch
		ElseIf @error = 2 Then
			Return SetError(1, 0, $sMainArray) ; All Skipped.
		EndIf
		$sMainArray[$sFrom][3] = $sDestination
		$sArchiveContent = __GetContentArchiveArray($sDestination, $sStringSplit[6])
		If @error = 0 Then
			For $A = 1 To $sArchiveContent[0]
				$sStringContent &= "\" & $sArchiveContent[$A] & @CRLF
			Next
		EndIf
	EndIf

	__EnsureDirExists(__GetParentFolder($sDestination))
	If @error Then
		Return SetError(2, 0, $sMainArray) ; All Failed.
	EndIf
	__SetProgressStatus($sElementsGUI, 1, $sDestination) ; Reset Single Progress Bar And Show Second Line.

	For $A = $sFrom To $sTo
		If $sMainArray[$A][4] == -9 Then ; Skip Already Processed Item.
			ContinueLoop
		EndIf
		$sNewPath = __RenameToCompress($sMainArray[$A][0], $sStringContent, $sTempMoved) ; ByRef: $sTempMoved = 1 If At Least One File/Folder Is Renamed.
		$sString &= $sNewPath & @CRLF
		$sStringContent &= $sNewPath & @CRLF
		$sSize += $sMainArray[$A][1]
	Next
	DirCreate($G_Global_TempDir)
	$sFile = FileOpen($sSourceList, 2 + 128)
	FileWrite($sFile, $sString)
	FileClose($sFile)

	Local $sProcess = __7ZipRun($sSourceList, $sDestination, 3, 0, 1, $sStringSplit) ; $sStringSplit Sent As $Password.
	If @error Then
		$sError = 2
	Else
		_Sorting_ProgressArchive($sProcess, $sSize, $sElementsGUI)
		If @error Then
			$sError = 1
		EndIf
	EndIf

	If $sTempMoved Then ; Some Files/Folders Was Moved In Temporarily Subdirectory.
		__RestoreCompressedItems($sString, $sMainArray, $sFrom, $sTo)
	EndIf
	DirRemove($G_Global_TempDir, 1)
	If $sError = 1 Then
		FileDelete($sDestination)
		Return SetExtended(1, $sMainArray) ; Aborted.
	ElseIf $sError = 2 Or FileExists($sDestination) = 0 Then
		Return SetError(2, 0, $sMainArray) ; All Failed.
	EndIf
	If $sStringSplit[1] == "True" Then
		For $A = $sFrom To $sTo
			If $sMainArray[$A][4] == -9 Then ; Skip Already Processed Item.
				ContinueLoop
			EndIf
			_Sorting_RunDelete($sMainArray[$A][0]) ; Remove Source After Processing It.
		Next
	EndIf

	Return $sMainArray ; OK.
EndFunc   ;==>_Sorting_CompressFile

Func _Sorting_ConvertFile($sMainArray, $sIndex, $sElementsGUI, $sProfile) ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< NOT USED YET
	Local $sStringSplit, $sSource = $sMainArray[$sIndex][0], $sDestination = $sMainArray[$sIndex][3]

	$sStringSplit = StringSplit($sDestination, "|") ; 1 = Destination Folder, 2 = Remove Source.
	ReDim $sStringSplit[3]
	$sDestination = $sStringSplit[1]

	If _WinAPI_PathIsDirectory($sSource) Or _WinAPI_PathIsDirectory($sDestination) Then
		Return SetError(2, 0, $sMainArray) ; Failed.
	ElseIf FileExists($sDestination) Then
		$sDestination = __Duplicate_Process($sProfile, $sSource, $sDestination)
		If @error = 2 Then
			Return SetError(1, 0, $sMainArray) ; Skipped.
		ElseIf $sSource = $sDestination Then
			Return SetError(2, 0, $sMainArray) ; Failed.
		EndIf
		$sMainArray[$sIndex][3] = $sDestination
		If __IsReadOnly($sDestination) Then
			If __Is("IgnoreAttributes") Then
				FileSetAttrib($sDestination, '-RH') ; Needed To Overwrite Hidden And Read-Only Files/Folders.
			Else
				Return SetError(2, 0, $sMainArray) ; Failed.
			EndIf
		EndIf
	EndIf

	__EnsureDirExists(__GetParentFolder($sDestination))
	If @error Then
		Return SetError(2, 0, $sMainArray) ; Failed.
	EndIf

	__SetProgressStatus($sElementsGUI, 1, $sDestination) ; Reset Single Progress Bar And Show Second Line.

	Switch __GetFileExtension($sDestination)
		Case 'bmp'
			__ImageConvert($sSource, $sDestination, "BMP")
		Case 'gif'
			__ImageConvert($sSource, $sDestination, "GIF")
		Case 'jpg', 'jpeg'
			__ImageConvert($sSource, $sDestination, "JPG")
		Case 'ico'
			_IconImage_ToIcoFile(_IconImage_FromImageFile($sSource), $sDestination)
		Case 'pdf'
			__ImagesToPDF($sSource, $sDestination)
		Case 'png'
			__ImageConvert($sSource, $sDestination, "PNG")
		Case 'tif', 'tiff'
			__ImageConvert($sSource, $sDestination, "TIF")
		Case Else
			Return SetError(2, 0, $sMainArray) ; Failed.
	EndSwitch
	If @error Then
		Return SetError(2, 0, $sMainArray) ; Failed.
	EndIf

	If $sStringSplit[2] == "True" Then
		_Sorting_RunDelete($sSource) ; Remove Source After Processing It.
	EndIf

	Return $sMainArray ; OK.
EndFunc   ;==>_Sorting_ConvertFile

Func _Sorting_CopyFile($sMainArray, $sIndex, $sElementsGUI, $sProfile)
	Local $sSource = $sMainArray[$sIndex][0], $sAction = $sMainArray[$sIndex][2], $sDestination = $sMainArray[$sIndex][3] & "\" & __GetFileName($sMainArray[$sIndex][0])

	If FileExists($sDestination) Then
		$sDestination = __Duplicate_Process($sProfile, $sSource, $sDestination)
		If @error = 2 Then
			Return SetError(1, 0, $sMainArray) ; Skipped.
		EndIf
		$sMainArray[$sIndex][3] = $sDestination
		If __IsReadOnly($sDestination) Then
			If __Is("IgnoreAttributes") Then
				FileSetAttrib($sDestination, '-RH') ; Needed To Overwrite Hidden And Read-Only Files/Folders.
			Else
				Return SetError(2, 0, $sMainArray) ; Failed.
			EndIf
		EndIf
	EndIf

	__EnsureDirExists(__GetParentFolder($sDestination))
	If @error Then
		Return SetError(2, 0, $sMainArray) ; Failed.
	EndIf

	_Sorting_StartProgressCopy($sSource, $sDestination, $sAction)
	If @error Then
		If $sAction == "$0" Then ; Move.
			If __SureMove($sSource, $sDestination) = 0 Then
				Return SetError(2, 0, $sMainArray) ; Failed.
			EndIf
		Else ; Copy.
			If __SureCopy($sSource, $sDestination) = 0 Then
				Return SetError(2, 0, $sMainArray) ; Failed.
			EndIf
		EndIf
	EndIf
	__SetProgressStatus($sElementsGUI, 1, $sDestination) ; Reset Single Progress Bar And Show Second Line.

	_Sorting_ProgressCopy($sMainArray, $sElementsGUI)
	If @error = 1 Then
		Return SetExtended(1, $sMainArray) ; Aborted.
	ElseIf @error = 2 Then
		If $sAction == "$0" Then ; Move.
			If __SureMove($sSource, $sDestination) = 0 Then
				Return SetError(2, 0, $sMainArray) ; Failed.
			EndIf
		Else ; Copy.
			If __SureCopy($sSource, $sDestination) = 0 Then
				Return SetError(2, 0, $sMainArray) ; Failed.
			EndIf
		EndIf
	EndIf

	Return $sMainArray ; OK.
EndFunc   ;==>_Sorting_CopyFile

Func _Sorting_DecryptFile($sMainArray, $sIndex, $sElementsGUI, $sProfile, $sPassword = "")
	Local $sStringSplit, $sMsgBox, $sIsFolder, $sCryptDestination, $sAlgorithm, $sPassword_Code = $G_Global_PasswordKey
	Local $sSource = $sMainArray[$sIndex][0], $sDestination = $sMainArray[$sIndex][3]

	$sStringSplit = StringSplit($sDestination, "|") ; 1 = Destination Folder, 2 = Algorithm, 3 = Password, 4 = Remove Source.
	ReDim $sStringSplit[5]
	If @OSVersion = "WIN_2000" And StringInStr($sStringSplit[2], "AES") Then
		MsgBox(0x30, __GetLang('DROP_EVENT_MSGBOX_15', 'Decryption Failed'), __GetLang('DROP_EVENT_MSGBOX_16', 'The selected algorithm is not supported on Windows 2000.'), 10, __OnTop($G_Global_SortingGUI))
		Return SetError(2, 0, $sMainArray) ; Failed.
	EndIf
	$sAlgorithm = __GetAlgorithmString($sStringSplit[2], 1) ; Get Algorithm Code.
	If $sPassword = "" Then
		$sPassword = __StringEncrypt(0, $sStringSplit[3], $sPassword_Code)
	EndIf

	If $sStringSplit[2] == "7ZIP" Then
			$sMainArray[$sIndex][3] = $sStringSplit[1] & "|" & $sStringSplit[4]
			Return _Sorting_ExtractFile($sMainArray, $sIndex, $sElementsGUI, $sProfile, $sPassword)
	EndIf

	$sDestination = $sStringSplit[1] & "\" & __GetFileName($sSource)
	$sCryptDestination = $sDestination
	If StringRight($sSource, 5) == $STATIC_CRYPT_FILE_EXT Then
		$sDestination = StringTrimRight($sDestination, 5)
		$sCryptDestination = $sDestination
	ElseIf StringRight($sSource, 5) == $STATIC_CRYPT_FOLDER_EXT Then
		$sDestination = StringTrimRight($sDestination, 5)
		$sCryptDestination = $G_Global_TempDir & "\" & __GetFileName($sDestination) & ".zip"
		DirCreate($G_Global_TempDir)
		$sIsFolder = 1
	EndIf
	If FileExists($sDestination) Then
		$sDestination = __Duplicate_Process($sProfile, -1, $sDestination)
		If @error = 2 Then
			Return SetError(1, 0, $sMainArray) ; Skipped.
		EndIf
	EndIf

	__EnsureDirExists(__GetParentFolder($sDestination))
	If @error Then
		Return SetError(2, 0, $sMainArray) ; Failed.
	EndIf
	__SetProgressStatus($sElementsGUI, 1, $sDestination) ; Reset Single Progress Bar And Show Second Line.
	GUICtrlSetData($sElementsGUI[3], 30)
	GUICtrlSetData($sElementsGUI[5], '30 %')

	_Crypt_DecryptFile($sSource, $sCryptDestination, $sPassword, $sAlgorithm)

	If @error Then
		FileDelete($sDestination)
		DirRemove($G_Global_TempDir, 1)
		$sMsgBox = MsgBox(0x4, __GetLang('PASSWORD_MSGBOX_1', 'Password Not Correct'), __GetLang('PASSWORD_MSGBOX_6', 'Wrong algorithm or password to decrypt this file.') & @LF & __GetLang('PASSWORD_MSGBOX_7', 'Do you want to try with a different password?'), 10, __OnTop($G_Global_SortingGUI))
		If $sMsgBox <> 6 Then
			Return SetError(2, 0, $sMainArray) ; Failed.
		EndIf
		__ExpandEventMode(0) ; Disable Event Buttons.
		$sPassword = __InsertPassword_GUI($sSource)
		__ExpandEventMode(1) ; Enable Event Buttons.
		If $sPassword = -1 Then
			Return SetError(1, 0, $sMainArray) ; Skipped.
		EndIf
		$sMainArray = _Sorting_DecryptFile($sMainArray, $sIndex, $sElementsGUI, $sProfile, $sPassword)
		Return SetError(@error, 0, $sMainArray)
	EndIf

	If $sIsFolder Then
		__7ZipRun($sCryptDestination, $sDestination, 1, 1) ; Extract Temp Archive.
		If @error Then
			DirRemove($G_Global_TempDir, 1)
			Return SetError(2, 0, $sMainArray) ; Failed.
		EndIf
		DirRemove($G_Global_TempDir, 1)
	EndIf

	If $sStringSplit[4] == "True" Then
		_Sorting_RunDelete($sSource) ; Remove Source After Processing It.
	EndIf

	$sMainArray[$sIndex][3] = $sDestination
	Return $sMainArray ; OK.
EndFunc   ;==>_Sorting_DecryptFile

Func _Sorting_DeleteFile($sMainArray, $sIndex, $sElementsGUI)
	Local $sDeleteText, $sSource = $sMainArray[$sIndex][0], $sDeletionMode = $sMainArray[$sIndex][3]

	$sDeleteText = __GetDeleteString($sDeletionMode)
	__SetProgressStatus($sElementsGUI, 1, $sDeleteText) ; Reset Single Progress Bar And Show Second Line.

	If __Is("AlertDelete") Then
		Local $sMsgBox = MsgBox(0x4, __GetLang('DROP_EVENT_MSGBOX_10', 'Delete item'), __GetLang('MOREMATCHES_LABEL_0', 'Loaded item:') & @LF & __GetFileName($sSource) & @LF & @LF & __GetLang('DROP_EVENT_MSGBOX_11', 'Are you sure to delete this item?'), 0, __OnTop($G_Global_SortingGUI))
		If $sMsgBox <> 6 Then
			Return SetError(1, 0, $sMainArray) ; Skipped.
		EndIf
	EndIf

	_Sorting_RunDelete($sSource, $sDeletionMode)

	If @error Or FileExists($sSource) Then
		Return SetError(2, 0, $sMainArray) ; Failed.
	EndIf
	Return $sMainArray ; OK.
EndFunc   ;==>_Sorting_DeleteFile

Func _Sorting_EncryptFile($sMainArray, $sIndex, $sElementsGUI, $sProfile)
	Local $sStringSplit, $sNewDestination, $sIsFolder, $sAlgorithm, $sPassword, $sPassword_Code = $G_Global_PasswordKey
	Local $sSource = $sMainArray[$sIndex][0], $sDestination = $sMainArray[$sIndex][3]

	$sStringSplit = StringSplit($sDestination, "|") ; 1 = Destination Folder, 2 = Algorithm, 3 = Password, 4 = Remove Source.
	ReDim $sStringSplit[5]
	If @OSVersion = "WIN_2000" And StringInStr($sStringSplit[2], "AES") Then
		MsgBox(0x30, __GetLang('DROP_EVENT_MSGBOX_14', 'Encryption Failed'), __GetLang('DROP_EVENT_MSGBOX_16', 'The selected algorithm is not supported on Windows 2000.'), 10, __OnTop($G_Global_SortingGUI))
		Return SetError(2, 0, $sMainArray) ; Failed.
	EndIf
	$sDestination = $sStringSplit[1]
	$sAlgorithm = __GetAlgorithmString($sStringSplit[2], 1) ; Get Algorithm Code.
	$sPassword = __StringEncrypt(0, $sStringSplit[3], $sPassword_Code)

	If $sStringSplit[2] == "7ZIP" Then
		$sMainArray[$sIndex][3] = $sStringSplit[1] & "|" & $sStringSplit[4] & ";7z;5;LZMA;AES-256;" & $sStringSplit[3]
		Return _Sorting_CompressFile($sMainArray, $sIndex, $sIndex, $sElementsGUI, $sProfile)
	EndIf

	__EnsureDirExists($sDestination)
	If @error Then
		Return SetError(2, 0, $sMainArray) ; Failed.
	EndIf
	__SetProgressStatus($sElementsGUI, 1, $sDestination) ; Reset Single Progress Bar And Show Second Line.
	GUICtrlSetData($sElementsGUI[3], 30)
	GUICtrlSetData($sElementsGUI[5], '30 %')

	If _WinAPI_PathIsDirectory($sSource) Then ; Compress Folders To Encrypt Them As Single Archive.
		$sNewDestination = $G_Global_TempDir & "\" & __GetFileName($sSource) & ".zip"
		DirCreate($G_Global_TempDir)
		If FileExists($sNewDestination) Then
			$sNewDestination = $G_Global_TempDir & "\" & __Duplicate_Rename(__GetFileName($sSource) & ".zip", $G_Global_TempDir, 0, 2)
		EndIf
		__7ZipRun($sSource & "\*", $sNewDestination, 0)
		If @error Then
			DirRemove($G_Global_TempDir, 1)
			Return SetError(2, 0, $sMainArray) ; Failed.
		EndIf
		$sSource = $sNewDestination
		$sIsFolder = 1
		GUICtrlSetData($sElementsGUI[3], 50)
		GUICtrlSetData($sElementsGUI[5], '50 %')
		$sDestination = $sStringSplit[1] & "\" & __GetFileNameOnly($sSource) & $STATIC_CRYPT_FOLDER_EXT
	Else
		$sDestination = $sStringSplit[1] & "\" & __GetFileName($sSource) & $STATIC_CRYPT_FILE_EXT
	EndIf

	If FileExists($sDestination) Then
		$sNewDestination = __Duplicate_Process($sProfile, -1, $sDestination)
		If @error = 2 Then
			DirRemove($G_Global_TempDir, 1)
			Return SetError(1, 0, $sMainArray) ; Skipped.
		EndIf
		If $sNewDestination <> $sDestination Then ; Fix Renamed File.
			$sNewDestination = StringTrimLeft(__GetFileNameOnly($sNewDestination), StringLen(__GetFileName($sSource))) ; The Added Number.
			$sDestination = $sStringSplit[1] & "\" & __GetFileNameOnly($sSource) & $sNewDestination & "." & __GetFileExtension($sSource)
			If $sIsFolder Then
				$sDestination &= $STATIC_CRYPT_FOLDER_EXT
			Else
				$sDestination &= $STATIC_CRYPT_FILE_EXT
			EndIf
		EndIf
		$sMainArray[$sIndex][3] = $sDestination
	EndIf

	_Crypt_EncryptFile($sSource, $sDestination, $sPassword, $sAlgorithm)

	If @error Then
		FileDelete($sDestination)
		DirRemove($G_Global_TempDir, 1)
		Return SetError(2, 0, $sMainArray) ; Failed.
	EndIf
	DirRemove($G_Global_TempDir, 1)

	If $sStringSplit[4] == "True" Then
		_Sorting_RunDelete($sMainArray[$sIndex][0]) ; Remove Source After Processing It.
	EndIf

	Return $sMainArray ; OK.
EndFunc   ;==>_Sorting_EncryptFile

Func _Sorting_ExtractFile($sMainArray, $sIndex, $sElementsGUI, $sProfile, $sPassword = "")
	Local $sProcess, $sMsgBox, $sStringSplit, $sDuplicateMode, $sTempName = $G_Global_TempName
	Local $sSource = $sMainArray[$sIndex][0], $sSize = $sMainArray[$sIndex][1], $sDestination = $sMainArray[$sIndex][3]

	If $sPassword = "" Then
		$sPassword = __7ZipGetPassword($sSource)
		Switch @error
			Case 1
				Return SetError(2, 0, $sMainArray) ; Failed.
			Case 2
				Return SetError(1, 0, $sMainArray) ; Skipped.
		EndSwitch
	EndIf

	$sStringSplit = StringSplit($sDestination, "|") ; 1 = Destination Folder, 2 = Remove Source.
	ReDim $sStringSplit[3]
	$sDestination = $sStringSplit[1]

	$sDuplicateMode = __Duplicate_GetMode($sProfile)
	Switch $sDuplicateMode
		Case "Overwrite1", "Overwrite2", "Overwrite3"
			$sDuplicateMode = 1
		Case "Skip"
			$sDuplicateMode = 2
		Case "Rename1", "Rename2", "Rename3"
			$sDuplicateMode = 3
		Case Else
			$sDuplicateMode = 0
			$sTempName = __GetFileNameOnly($sSource) & $sTempName
			If FileExists($sDestination & "\" & $sTempName) Then
				$sTempName = __Duplicate_Rename($sTempName, $sDestination, 1, 2)
			EndIf
			$sDestination &= "\" & $sTempName
	EndSwitch

	__EnsureDirExists($sDestination)
	If @error Then
		Return SetError(2, 0, $sMainArray) ; Failed.
	EndIf
	__SetProgressStatus($sElementsGUI, 1, $sDestination) ; Reset Single Progress Bar And Show Second Line.

	$sProcess = __7ZipRun($sSource, $sDestination, 1, $sDuplicateMode, 1, $sPassword)
	If @error Then
		Return SetError(2, 0, $sMainArray) ; Failed.
	EndIf

	_Sorting_ProgressArchive($sProcess, $sSize, $sElementsGUI)
	If @error Then
		FileDelete($sDestination)
		Return SetExtended(1, $sMainArray) ; Aborted.
	EndIf

	If FileExists($sDestination) = 0 Or ($sSize > 0 And DirGetSize($sDestination) < 1) Then
		DirRemove($sDestination, 1) ; Remove If File Is Corrupted Because Extracted With Not Correct Password.
		If $sPassword = "" Then
			Return SetError(2, 0, $sMainArray) ; Failed.
		EndIf
		$sMsgBox = MsgBox(0x4, __GetLang('PASSWORD_MSGBOX_1', 'Password Not Correct'), __GetLang('PASSWORD_MSGBOX_8', 'Wrong password to extract this archive.') & @LF & __GetLang('PASSWORD_MSGBOX_7', 'Do you want to try with a different password?'), 10, __OnTop($G_Global_SortingGUI))
		If $sMsgBox <> 6 Then
			Return SetError(2, 0, $sMainArray) ; Failed.
		EndIf
		__ExpandEventMode(0) ; Disable Event Buttons.
		$sPassword = __InsertPassword_GUI($sSource)
		__ExpandEventMode(1) ; Enable Event Buttons.
		If $sPassword = -1 Then
			Return SetError(1, 0, $sMainArray) ; Skipped.
		EndIf
		$sMainArray = _Sorting_ExtractFile($sMainArray, $sIndex, $sElementsGUI, $sProfile, $sPassword)
		Return SetError(@error, 0, $sMainArray)
	EndIf

	If $sDuplicateMode = 0 Then ; Move File To The Correct Destination And Manage Duplicates.
		Local $sFileListToArray = __FileListToArrayEx($sDestination, "*")
		If @error Then
			Return SetError(2, 0, $sMainArray) ; Failed.
		EndIf
		For $A = 1 To $sFileListToArray[0]
			$sTempName = $sStringSplit[1] & "\" & __GetFileName($sFileListToArray[$A])
			If FileExists($sTempName) Then
				$sTempName = __Duplicate_Process($sProfile, -1, $sTempName)
				If @error = 2 Then
					ContinueLoop
				EndIf
			EndIf
			__SureMove($sFileListToArray[$A], $sTempName)
		Next
		_Sorting_RunDelete($sDestination)
	EndIf

	If $sStringSplit[2] == "True" Then
		_Sorting_RunDelete($sSource) ; Remove Source After Processing It.
	EndIf

	$sMainArray[$sIndex][3] = $sDestination
	Return $sMainArray ; OK.
EndFunc   ;==>_Sorting_ExtractFile

Func _Sorting_GalleryFile($sMainArray, $sFrom, $sTo, $sElementsGUI, $sProfile)
	Local $sStringSplit, $sSkipped, $sDestination, $sSubArray[$sTo - $sFrom + 2]
	$sSubArray[0] = $sTo - $sFrom + 1

	$sStringSplit = StringSplit($sMainArray[$sFrom][3], "|")
	$sDestination = $sStringSplit[1]
	If FileExists($sDestination) Then
		$sDestination = __Duplicate_Process($sProfile, -1, $sDestination)
		If @error = 1 Then
			FileDelete($sDestination) ; To Overwrite.
		ElseIf @error = 2 Then
			Return SetError(1, 0, $sMainArray) ; All Skipped.
		EndIf
		$sMainArray[$sFrom][3] = $sDestination
	EndIf

	__EnsureDirExists($sDestination)
	If @error Then
		Return SetError(2, 0, $sMainArray) ; All Failed.
	EndIf
	__SetProgressStatus($sElementsGUI, 1, $sDestination) ; Reset Single Progress Bar And Show Second Line.

	For $A = $sFrom To $sTo
		If $sMainArray[$A][4] == -9 Then ; Skip Already Processed Item.
			$sSkipped += 1
			$sSubArray[0] -= 1
			ContinueLoop
		EndIf
		$sSubArray[$A - $sFrom + 1 - $sSkipped] = $sMainArray[$A][0] ; File Path.
		$sMainArray[$A][4] = -8 ; Force Progress Bar And Counter To Be Not Overwritten.
	Next

	__Gallery_WriteHTML($sSubArray, $sDestination, $sElementsGUI, $sStringSplit[2], $sStringSplit[3], $sStringSplit[4], $sStringSplit[5], $sStringSplit[6])
	If @error Then
		Return SetError(2, 0, $sMainArray) ; All Failed.
	EndIf
	Return $sMainArray ; OK.
EndFunc   ;==>_Sorting_GalleryFile

Func _Sorting_JoinFile($sMainArray, $sFrom, $sTo, $sElementsGUI, $sProfile)
	Local $sStringSplit, $B, $sNumber, $sOpenFile, $sOpenCurrFile, $sCurrPath, $sDestination, $sSubArray[1]
	Local $sChunkSize, $sRemaining, $sPercent, $sLoadedSize, $sFullSize, $sDone = 0

	$sStringSplit = StringSplit($sMainArray[$sFrom][3], "|") ; 1 = Destination File, 2 = Remove Source.
	ReDim $sStringSplit[3]
	$sDestination = $sStringSplit[1]

	For $A = $sTo To $sFrom Step -1 ; Fill The Array.
		$sNumber = Number(__GetFileExtension($sMainArray[$A][0]))
		If $sNumber < 1 Then
			ContinueLoop
		EndIf
		If $sNumber > $sSubArray[0] Then
			ReDim $sSubArray[$sNumber + 1]
			$sSubArray[0] = $sNumber
		EndIf
		$sSubArray[$sNumber] = $sMainArray[$A][0]
		$sLoadedSize += $sMainArray[$A][1]
		$sFullSize += $sMainArray[$A][1]
		$B = 0
		While 1
			$B += 1
			$sCurrPath = StringTrimRight($sMainArray[$A][0], 3) & _StringM_AddLeadingZeros($B, 3)
			If FileExists($sCurrPath) Then
				If $B > $sSubArray[0] Then
					ReDim $sSubArray[$B + 1]
					$sSubArray[0] = $B
				EndIf
				If $sSubArray[$B] <> "" Then
					ContinueLoop
				EndIf
				$sSubArray[$B] = $sCurrPath
				$sFullSize += FileGetSize($sSubArray[$B])
			ElseIf $B > $A Then
				ExitLoop
			EndIf
		WEnd
	Next
	If $sSubArray[0] < 2 Then
		Return SetError(2, 0, $sMainArray) ; Failed.
	EndIf
	For $A = 1 To $sSubArray[0] ; Check If Array Is Complete.
		If $sSubArray[$A] = "" Then
			Return SetError(2, 0, $sMainArray) ; Failed.
		EndIf
	Next

	If FileExists($sDestination) Then
		$sDestination = __Duplicate_Process($sProfile, -1, $sDestination)
		If @error = 2 Then
			Return SetError(1, 0, $sMainArray) ; Skipped.
		EndIf
		$sMainArray[$sFrom][3] = $sDestination
	EndIf

	__EnsureDirExists($sDestination)
	If @error Then
		Return SetError(2, 0, $sMainArray) ; Failed.
	EndIf
	__SetProgressStatus($sElementsGUI, 1, $sDestination) ; Reset Single Progress Bar And Show Second Line.

	If StringInStr(__GetFileName($sDestination), ".") = 0 Then ; Add Temporary Extension For Folders.
		$sDestination &= $STATIC_TEMP_ZIP_EXT
	EndIf

	$sOpenFile = FileOpen($sDestination, 2 + 8)
    If $sOpenFile = -1 Then
		Return SetError(2, 0, $sMainArray) ; Failed.
	EndIf

	For $A = 1 To $sSubArray[0]
		$sOpenCurrFile = FileOpen($sSubArray[$A], 0)
		If $sOpenCurrFile = -1 Then
			FileClose($sOpenFile)
			FileDelete($sDestination)
			Return SetError(2, 0, $sMainArray) ; Failed.
		EndIf
		$sRemaining = FileGetSize($sSubArray[$A])
		$sChunkSize = 20000 ; Recommended Chunk Value.

		While 1
			If $sRemaining < $sChunkSize Then
				$sChunkSize = $sRemaining
			EndIf
			FileWrite($sOpenFile, FileRead($sOpenCurrFile, $sChunkSize))

			$sDone += $sChunkSize
			$sPercent = Round($sDone / $sFullSize * 100)
			If GUICtrlRead($sElementsGUI[3]) <> $sPercent Then
				GUICtrlSetData($sElementsGUI[3], $sPercent)
				GUICtrlSetData($sElementsGUI[5], $sPercent & ' %')
				$sPercent = __GetPercent($sDone * $sLoadedSize / $sFullSize, 0)
				If GUICtrlRead($sElementsGUI[2]) <> $sPercent Then
					GUICtrlSetData($sElementsGUI[2], $sPercent)
					GUICtrlSetData($sElementsGUI[4], $sPercent & ' %')
				EndIf
			EndIf

			If $G_Global_AbortSorting Then
				FileClose($sOpenCurrFile)
				FileClose($sOpenFile)
				FileDelete($sDestination)
				Return SetError(1, 0, 0) ; Aborted.
			EndIf

			$sRemaining -= $sChunkSize
			If $sRemaining <= 0 Then
				ExitLoop
			EndIf
		WEnd
		FileClose($sOpenCurrFile)
	Next
	FileClose($sOpenFile)

	If StringInStr(__GetFileName($sDestination), $STATIC_TEMP_ZIP_EXT) Then ; Extract If Needed.
		$sCurrPath = StringTrimRight($sDestination, StringLen($STATIC_TEMP_ZIP_EXT))
		__7ZipRun($sDestination, $sCurrPath, 1, 1)
		If @error Or DirGetSize($sCurrPath) = 0 Then
			DirRemove($sCurrPath, 1)
			FileMove($sDestination, $sCurrPath, 1)
		Else
			FileDelete($sDestination)
		EndIf
	EndIf

	If $sStringSplit[2] == "True" Then
		For $A = 1 To $sSubArray[0]
			_Sorting_RunDelete($sSubArray[$A]) ; Remove Source After Processing It.
		Next
	EndIf

	Return $sMainArray ; OK.
EndFunc   ;==>_Sorting_JoinFile

Func _Sorting_ListFile($sMainArray, $sFrom, $sTo, $sElementsGUI, $sProfile)
	Local $sStringSplit, $sSkipped, $sDestination, $sSettings, $sSubArray[$sTo - $sFrom + 2]
	$sSubArray[0] = $sTo - $sFrom + 1

	$sStringSplit = StringSplit($sMainArray[$sFrom][3], "|") ; 1 = Destination Archive, 2 = List Properties, 3 = Profile Name, 4 = Rules, 5 = Association Name, 6 = HTML Theme, 7 = List Settings.
	ReDim $sStringSplit[8]
	$sDestination = $sStringSplit[1]
	If $sStringSplit[7] = "" Then
		$sStringSplit[7] = __GetDefaultListSettings()
	EndIf
	$sSettings = StringSplit($sStringSplit[7], ";") ; 1 = HTML Sortable, 2 = HTML Filter, 3 = HTML Lightbox, 4 = List Header.
	ReDim $sSettings[5]

	If FileExists($sDestination) Then
		$sDestination = __Duplicate_Process($sProfile, -1, $sDestination)
		If @error = 1 Then
			FileDelete($sDestination) ; To Overwrite.
		ElseIf @error = 2 Then
			Return SetError(1, 0, $sMainArray) ; All Skipped.
		EndIf
		$sMainArray[$sFrom][3] = $sDestination
	EndIf

	__EnsureDirExists($sDestination)
	If @error Then
		Return SetError(2, 0, $sMainArray) ; All Failed.
	EndIf
	__SetProgressStatus($sElementsGUI, 1, $sDestination) ; Reset Single Progress Bar And Show Second Line.

	For $A = $sFrom To $sTo
		If $sMainArray[$A][4] == -9 Then ; Skip Already Processed Item.
			$sSkipped += 1
			$sSubArray[0] -= 1
			ContinueLoop
		EndIf
		$sSubArray[$A - $sFrom + 1 - $sSkipped] = $sMainArray[$A][0] ; File Path.
		$sMainArray[$A][4] = -8 ; Force Progress Bar And Counter To Be Not Overwritten.
	Next

	Switch __GetFileExtension($sDestination)
		Case "html", "htm"
			__List_WriteHTML($sSubArray, $sDestination, $sElementsGUI, $sSettings, $sStringSplit[2], $sStringSplit[3], $sStringSplit[4], $sStringSplit[5], $sStringSplit[6])
		Case "pdf"
			__List_WritePDF($sSubArray, $sDestination, $sElementsGUI, $sSettings, $sStringSplit[2], $sStringSplit[3], $sStringSplit[5])
		Case "xls"
			__List_WriteXLS($sSubArray, $sDestination, $sElementsGUI, $sSettings, $sStringSplit[2], $sStringSplit[3])
		Case "csv"
			__List_WriteTEXT($sSubArray, $sDestination, $sElementsGUI, $sSettings, $sStringSplit[2], $sStringSplit[3], ',', '"')
		Case "txt"
			__List_WriteTEXT($sSubArray, $sDestination, $sElementsGUI, $sSettings, $sStringSplit[2], $sStringSplit[3], '|', '')
		Case "xml"
			__List_WriteXML($sSubArray, $sDestination, $sElementsGUI, $sSettings, $sStringSplit[2], $sStringSplit[3])
		Case Else
			SetError(1, 0, 0)
	EndSwitch
	If @error Then
		Return SetError(2, 0, $sMainArray) ; All Failed.
	EndIf
	Return $sMainArray ; OK.
EndFunc   ;==>_Sorting_ListFile

Func _Sorting_MailFile($sMainArray, $sFrom, $sTo, $sElementsGUI)
	Local $sFailed, $sStringSplit, $sFilePath, $sFileNames, $sSource, $sError, $sTotalSource, $sTotalSize = 1, $sCurrentSize, $sInternalFrom = $sFrom, $sInternalTo = $sFrom
	Local $sPassword_Code = $G_Global_PasswordKey, $sDestination = $sMainArray[$sFrom][3]

	$sStringSplit = StringSplit($sDestination, ";") ; 1 = Server, 2 = Port, 3 = SSL, 4 = Name, 5 = FromEmail, 6 = User, 7 = Password, 8 = ToEmail, 9 = Cc, 10 = Bcc, 11 = Subject, 12 = Body, 13 = SizeLimit, 14 = Remove Source.
	ReDim $sStringSplit[15]
	If $sStringSplit[2] = "" Then
		$sStringSplit[2] = 25
	EndIf
	If $sStringSplit[13] = "" Then
		$sStringSplit[13] = 10
	EndIf
	If $sStringSplit[7] <> "" Then
		$sStringSplit[7] = __StringEncrypt(0, $sStringSplit[7], $sPassword_Code)
	EndIf
	For $A = 8 To 12
		$sStringSplit[$A] = __ConvertMailText($sStringSplit[$A], 1)
	Next

	For $A = $sFrom To $sTo
		If $sMainArray[$A][4] == -9 Then ; Skip Already Processed Item.
			ContinueLoop
		EndIf
		$sFileNames &= __GetFileName($sMainArray[$A][0])
		If $A < $sTo Then
			$sFileNames &= @CRLF
		EndIf
	Next
	If $sFileNames = "" Then
		Return SetError(1, 0, $sMainArray) ; All Skipped.
	EndIf
	If $sStringSplit[8] = "" Or __Is("AlertMail") Then
		$sStringSplit = _Destination_MailMessage($sFileNames, $sStringSplit)
		If @error Then
			Return SetError(1, 0, $sMainArray) ; All Skipped.
		EndIf
	EndIf

	For $A = $sFrom To $sTo + 1
		_Sorting_CheckButtons($sMainArray)
		If @error Then
			Return SetExtended(1, $sMainArray) ; Aborted.
		EndIf

		If $A <= $sTo Then
			If $sMainArray[$A][4] == -9 Then ; Skip Already Processed Item.
				ContinueLoop
			EndIf
			$sSource = $sMainArray[$A][0]

			If _WinAPI_PathIsDirectory($sSource) Then
				$sFilePath = __CreateTempZIP($sSource) ; Compress Folders To Send Them As Single Archive.
				If @error Then
					__SetPositionResult($sMainArray, $A, $A, $Global_ListViewProcess, $sElementsGUI, -2)
					$sMainArray[$A][4] = -9 ; Force Result To Be Not Overwritten.
					$sFailed = 1 ; At Least One Item Failed.
					ContinueLoop
				EndIf
				GUICtrlSetData($sElementsGUI[3], 70)
				GUICtrlSetData($sElementsGUI[5], '70 %')
			Else
				$sFilePath = $sSource
			EndIf
			$sCurrentSize = FileGetSize($sFilePath)
		EndIf

		If $A <> 1 And ($A = $sTo + 1 Or ($sTotalSize + $sCurrentSize) / (1024 * 1024) >= $sStringSplit[13]) Then
			$sTotalSource = StringTrimRight($sTotalSource, 1) ; To Remove The Last ";".
			__INetSmtpMailCom($sStringSplit[1], $sStringSplit[4], $sStringSplit[5], $sStringSplit[8], $sStringSplit[11], $sStringSplit[12], $sTotalSource, $sStringSplit[9], $sStringSplit[10], "Normal", $sStringSplit[6], $sStringSplit[7], $sStringSplit[2], $sStringSplit[3])
			$sError = @error
			DirRemove($G_Global_TempDir, 1)
			$sTotalSource = ""
			$sTotalSize = 1
			If $sError Then
				$sFailed = 1 ; At Least One Item Failed.
				$sError = -2
			EndIf
			__SetPositionResult($sMainArray, $sInternalFrom, $sInternalTo, $Global_ListViewProcess, $sElementsGUI, $sError)
			For $B = $sInternalFrom To $sInternalTo
				If $sError = 0 And $sStringSplit[14] == "True" Then
					If $sMainArray[$B][4] == -9 Then ; Skip Already Processed Item.
						ContinueLoop
					EndIf
					_Sorting_RunDelete($sMainArray[$B][0]) ; Remove Source After Processing It.
				EndIf
				$sMainArray[$B][4] = -9 ; Force Result To Be Not Overwritten.
			Next
			$sInternalFrom = $A
		EndIf

		__SetProgressStatus($sElementsGUI, 1, $sSource) ; Reset Single Progress Bar And Show Second Line.
		GUICtrlSetData($sElementsGUI[3], 50)
		GUICtrlSetData($sElementsGUI[5], '50 %')
		$sTotalSize += $sCurrentSize
		$sInternalTo = $A
		$sTotalSource &= $sFilePath & ";"
	Next

	If $sFailed Then
		Return SetError(3, 0, $sMainArray) ; Some Failed.
	EndIf
	Return $sMainArray
EndFunc   ;==>_Sorting_MailFile

Func _Sorting_OpenFile($sMainArray, $sIndex, $sElementsGUI)
	Local $sStringSplit, $sSource = $sMainArray[$sIndex][0], $sDestination = $sMainArray[$sIndex][3]

	__SetProgressStatus($sElementsGUI, 1, $sSource) ; Reset Single Progress Bar And Show Second Line.

	$sStringSplit = StringSplit($sDestination, "|") ; 1 = Destination Program, 2 = Wait Opened, 3 = Remove Source.
	ReDim $sStringSplit[4]
	$sDestination = $sStringSplit[1]

	If StringInStr($sDestination, "%DefaultProgram%") Then
		$sDestination = StringReplace($sDestination, '"%DefaultProgram%"', '')
		$sDestination = StringReplace($sDestination, '%DefaultProgram%', '')
		If $sStringSplit[2] == "True" Then
			ShellExecuteWait($sSource, $sDestination)
		Else
			ShellExecute($sSource, $sDestination)
		EndIf
	Else
		If $sStringSplit[2] == "True" Then
			RunWait($sDestination, @ScriptDir)
		Else
			Run($sDestination, @ScriptDir)
		EndIf
	EndIf
	If @error Then
		Return SetError(2, 0, $sMainArray) ; Failed.
	EndIf

	If $sStringSplit[2] == "True" And $sStringSplit[3] == "True" Then
		_Sorting_RunDelete($sSource) ; Remove Source After Processing It.
	EndIf

	Return $sMainArray ; OK.
EndFunc   ;==>_Sorting_OpenFile

Func _Sorting_PrintFile($sMainArray, $sIndex, $sElementsGUI)
	Local $sSource = $sMainArray[$sIndex][0], $sFileExtension, $sAppName, $sAppCommand

	$sFileExtension = __GetFileExtension($sSource)

	$sAppName = RegRead("HKCR\\." & $sFileExtension, "")
	If @error Or $sAppName = "" Then
		Return SetError(2, 0, $sMainArray) ; Failed.
	EndIf

	$sAppCommand = RegRead("HKCR\\" & $sAppName & "\\shell\\print\\command", "")
	If @error Or $sAppCommand = "" Then
		Return SetError(2, 0, $sMainArray) ; Failed.
	EndIf
	$sDestination = StringReplace($sAppCommand, "%1", $sSource)

	Run($sDestination, @ScriptDir)
	If @error Then
		Return SetError(2, 0, $sMainArray) ; Failed.
	EndIf

	Return $sMainArray ; OK.
EndFunc   ;==>_Sorting_PrintFile

Func _Sorting_PlaylistFile($sMainArray, $sFrom, $sTo, $sElementsGUI, $sProfile)
	Local $sSkipped, $sSubArray[$sTo - $sFrom + 2], $sPlaylistFile = $sMainArray[$sFrom][3]
	$sSubArray[0] = $sTo - $sFrom + 1

	If FileExists($sPlaylistFile) Then
		$sPlaylistFile = __Duplicate_Process($sProfile, -1, $sPlaylistFile)
		If @error = 1 Then
			FileDelete($sPlaylistFile) ; To Overwrite.
		ElseIf @error = 2 Then
			Return SetError(1, 0, $sMainArray) ; All Skipped.
		EndIf
		$sMainArray[$sFrom][3] = $sPlaylistFile
	EndIf

	__EnsureDirExists($sPlaylistFile)
	If @error Then
		Return SetError(2, 0, $sMainArray) ; All Failed.
	EndIf
	__SetProgressStatus($sElementsGUI, 1, $sPlaylistFile) ; Reset Single Progress Bar And Show Second Line.

	For $A = $sFrom To $sTo
		If $sMainArray[$A][4] == -9 Then ; Skip Already Processed Item.
			$sSkipped += 1
			$sSubArray[0] -= 1
			ContinueLoop
		EndIf
		$sSubArray[$A - $sFrom + 1 - $sSkipped] = $sMainArray[$A][0] ; File Path.
	Next

	Switch __GetFileExtension($sPlaylistFile)
		Case "m3u"
			__Playlist_WriteM3U($sSubArray, $sPlaylistFile)
		Case "m3u8"
			__Playlist_WriteM3U($sSubArray, $sPlaylistFile, 1)
		Case "pls"
			__Playlist_WritePLS($sSubArray, $sPlaylistFile)
		Case "wpl"
			__Playlist_WriteWPL($sSubArray, $sPlaylistFile)
		Case Else
			SetError(1, 0, 0)
	EndSwitch
	If @error Then
		Return SetError(2, 0, $sMainArray) ; All Failed.
	EndIf
	Return $sMainArray ; OK.
EndFunc   ;==>_Sorting_PlaylistFile

Func _Sorting_RenameFile($sMainArray, $sFrom, $sTo, $sElementsGUI, $sProfile)
	Local $sFailed, $sSource, $sDestination, $sTempName = $G_Global_TempName

	For $A = $sFrom To $sTo ; To Be Sure To Do Not Wrongly Overwrite During Process.
		If $sMainArray[$A][4] == -9 Then ; Skip Already Processed Item.
			ContinueLoop
		EndIf
		$sSource = $sMainArray[$A][0]
		__SureMove($sSource, $sSource & $sTempName)
		If @error Then
			__SetPositionResult($sMainArray, $A, $A, $Global_ListViewProcess, $sElementsGUI, -2)
			$sMainArray[$A][4] = -9 ; Force Result To Be Not Overwritten.
			$sFailed = 1 ; At Least One Item Failed.
			ContinueLoop
		EndIf
	Next

	For $A = $sFrom To $sTo
		If $sMainArray[$A][4] == -9 Then ; Skip Already Processed Item.
			ContinueLoop
		EndIf
		$sSource = $sMainArray[$A][0]
		$sDestination = $sMainArray[$A][3]

		If FileExists($sDestination) And $sSource <> $sDestination Then
			__SureMove($sSource & $sTempName, $sSource)
			$sDestination = __Duplicate_Process($sProfile, $sSource, $sDestination)
			If @error = 2 Then
				__SetPositionResult($sMainArray, $A, $A, $Global_ListViewProcess, $sElementsGUI, -1)
				$sMainArray[$A][4] = -9 ; Force Result To Be Not Overwritten.
				ContinueLoop ; Skipped.
			EndIf
			$sMainArray[$A][3] = $sDestination
			If __IsReadOnly($sDestination) Then
				If __Is("IgnoreAttributes") Then
					FileSetAttrib($sDestination, '-RH') ; Needed To Overwrite Hidden And Read-Only Files/Folders.
				Else
					__SetPositionResult($sMainArray, $A, $A, $Global_ListViewProcess, $sElementsGUI, -2)
					$sMainArray[$A][4] = -9 ; Force Result To Be Not Overwritten.
					$sFailed = 1 ; At Least One Item Failed.
					ContinueLoop ; Skipped.
				EndIf
			EndIf
		Else
			$sSource &= $sTempName
		EndIf
		__SetProgressStatus($sElementsGUI, 1, $sDestination) ; Reset Single Progress Bar And Show Second Line.

		__SureMove($sSource, $sDestination)
		If @error Then
			__SetPositionResult($sMainArray, $A, $A, $Global_ListViewProcess, $sElementsGUI, -2)
			$sMainArray[$A][4] = -9 ; Force Result To Be Not Overwritten.
			$sFailed = 1 ; At Least One Item Failed.
			ContinueLoop
		EndIf
		__SetPositionResult($sMainArray, $A, $A, $Global_ListViewProcess, $sElementsGUI, 0)
		$sMainArray[$A][4] = -9 ; Force Result To Be Not Overwritten.
	Next

	If $sFailed Then
		Return SetError(3, 0, $sMainArray) ; Some Failed.
	EndIf
	Return $sMainArray
EndFunc   ;==>_Sorting_RenameFile

Func _Sorting_ShortcutFile($sMainArray, $sIndex, $sElementsGUI, $sProfile)
	Local $sSource = $sMainArray[$sIndex][0], $sShortcut = $sMainArray[$sIndex][3]

	If FileExists($sShortcut) Then
		$sShortcut = __Duplicate_Process($sProfile, -1, $sShortcut)
		If @error = 2 Then
			Return SetError(1, 0, $sMainArray) ; Skipped.
		EndIf
		$sMainArray[$sIndex][3] = $sShortcut
	EndIf

	__EnsureDirExists($sShortcut)
	If @error Then
		Return SetError(2, 0, $sMainArray) ; Failed.
	EndIf
	__SetProgressStatus($sElementsGUI, 1, $sShortcut) ; Reset Single Progress Bar And Show Second Line.

	FileCreateShortcut($sSource, $sShortcut)
	If @error Then
		Return SetError(2, 0, $sMainArray) ; Failed.
	EndIf

	Return $sMainArray ; OK.
EndFunc   ;==>_Sorting_ShortcutFile

Func _Sorting_SplitFile($sMainArray, $sIndex, $sElementsGUI, $sProfile)
	Local $sStringSplit, $sSettings, $sOpenFile, $sOpenCurrFile, $sCurrPath, $sFileName, $sLast, $sParts, $sChunkSize, $sRemaining, $sPercent, $sRealSize, $sDone = 0
	Local $sSource = $sMainArray[$sIndex][0], $sFullSize = $sMainArray[$sIndex][1], $sDestination = $sMainArray[$sIndex][3]

	$sStringSplit = StringSplit($sDestination, "|") ; 1 = Destination Folder, 2 = Other Settings.
	ReDim $sStringSplit[3]
	$sDestination = $sStringSplit[1]
	$sSettings = StringSplit($sStringSplit[2], ";") ; 1 = Part Size Number, 2 = Part Size Text, 3 = Remove Source.
	ReDim $sSettings[4]
	Switch $sSettings[2]
		Case "KB"
			$sSettings[1] = $sSettings[1] * 1024
		Case "MB"
			$sSettings[1] = $sSettings[1] * 1024 * 1024
	EndSwitch
	If $sFullSize <= $sSettings[1] Then
		Return SetError(1, 0, $sMainArray) ; Skipped.
	EndIf
	$sFileName =  __GetFileName($sSource)
	$sRealSize = $sFullSize
	If _WinAPI_PathIsDirectory($sSource) Then
		$sSource = __CreateTempZIP($sSource) ; Compress Folders To Split Them As Single File.
		If @error Then
			DirRemove($G_Global_TempDir, 1)
			Return SetError(2, 0, $sMainArray) ; Failed.
		EndIf
		$sRealSize = FileGetSize($sSource)
	EndIf
	$sLast = Mod($sRealSize, $sSettings[1])
	$sParts = Ceiling($sRealSize / $sSettings[1])

	If FileExists($sDestination) Then
		$sDestination = __Duplicate_Process($sProfile, -1, $sDestination)
		If @error = 1 Then
			FileDelete($sDestination) ; To Overwrite.
		ElseIf @error = 2 Then
			Return SetError(1, 0, $sMainArray) ; Skipped.
		EndIf
		$sMainArray[$sIndex][3] = $sDestination
	EndIf

	__EnsureDirExists($sDestination)
	If @error Then
		Return SetError(2, 0, $sMainArray) ; Failed.
	EndIf
	__SetProgressStatus($sElementsGUI, 1, $sDestination) ; Reset Single Progress Bar And Show Second Line.

	$sOpenFile = FileOpen($sSource, 0)
    If $sOpenFile = -1 Then
		DirRemove($sDestination, 1)
		DirRemove($G_Global_TempDir, 1)
		Return SetError(2, 0, $sMainArray) ; Failed.
	EndIf

	For $A = 1 To $sParts
		$sCurrPath = $sDestination & "\" & $sFileName & "." & _StringM_AddLeadingZeros($A, 3)
		$sOpenCurrFile = FileOpen($sCurrPath, 2 + 8)
		If $sOpenCurrFile = -1 Then
			FileClose($sOpenFile)
			DirRemove($sDestination, 1)
			DirRemove($G_Global_TempDir, 1)
			Return SetError(2, 0, $sMainArray) ; Failed.
		EndIf
		GUICtrlSetData($sElementsGUI[1], $sCurrPath)

		If $A = $sParts And $sLast > 0 Then
			$sSettings[1] = $sLast
		EndIf
		$sRemaining = $sSettings[1]
		$sChunkSize = 20000 ; Recommended Chunk Value.

		While 1
			If $sRemaining < $sChunkSize Then
				$sChunkSize = $sRemaining
			EndIf
			FileWrite($sOpenCurrFile, FileRead($sOpenFile, $sChunkSize))

			$sDone += $sChunkSize
			$sPercent = Round($sDone / $sRealSize * 100)
			If GUICtrlRead($sElementsGUI[3]) <> $sPercent Then
				GUICtrlSetData($sElementsGUI[3], $sPercent)
				GUICtrlSetData($sElementsGUI[5], $sPercent & ' %')
				$sPercent = __GetPercent($sDone * $sFullSize / $sRealSize, 0)
				If GUICtrlRead($sElementsGUI[2]) <> $sPercent Then
					GUICtrlSetData($sElementsGUI[2], $sPercent)
					GUICtrlSetData($sElementsGUI[4], $sPercent & ' %')
				EndIf
			EndIf

			If $G_Global_AbortSorting Then
				FileClose($sOpenCurrFile)
				FileClose($sOpenFile)
				DirRemove($sDestination, 1)
				DirRemove($G_Global_TempDir, 1)
				Return SetError(1, 0, 0) ; Aborted.
			EndIf

			$sRemaining -= $sChunkSize
			If $sRemaining <= 0 Then
				ExitLoop
			EndIf
		WEnd
		FileClose($sOpenCurrFile)
	Next
	DirRemove($G_Global_TempDir, 1)
	FileClose($sOpenFile)

	If $sSettings[3] == "True" Then
		_Sorting_RunDelete($sMainArray[$sIndex][0]) ; Remove Source After Processing It.
	EndIf

	__SetPositionResult($sMainArray, $sIndex, $sIndex, $Global_ListViewProcess, $sElementsGUI, 0)
	$sMainArray[$sIndex][4] = -9 ; Force Result To Be Not Overwritten.
	$sMainArray[$sIndex][3] = $sDestination
	Return $sMainArray ; OK.
EndFunc   ;==>_Sorting_SplitFile

Func _Sorting_UploadFile($sMainArray, $sFrom, $sTo, $sElementsGUI, $sProfile)
	Local $sFailed, $sFileName, $sSource, $sSize, $sDate, $sStringSplit, $sDirectory, $sOpen, $sConn, $sListArray
	Local $sPassiveMode = 0, $sPassword_Code = $G_Global_PasswordKey, $sDestination = $sMainArray[$sFrom][3]
	;Local $ERR, $MESS ; <<<<< Debug.

	$sStringSplit = StringSplit($sDestination, "|") ; Remove Site Settings From The End Of The String.
	$sDirectory = $sStringSplit[1]
	$sStringSplit = StringSplit($sStringSplit[2], ";") ; 1 = Host, 2 = Port, 3 = User, 4 = Password, 5 = Protocol, 6 = Remove Source.
	ReDim $sStringSplit[7]
	If StringRight($sDirectory, 1) = "/" Then
		$sDirectory = StringTrimRight($sDirectory, 1)
	EndIf
	If $sStringSplit[4] <> "" Then
		$sStringSplit[4] = __StringEncrypt(0, $sStringSplit[4], $sPassword_Code)
	EndIf

	If $sStringSplit[5] = "SFTP" Then
		$sOpen = _SFTP_Open(@ScriptDir & '\Lib\psftp\psftp.exe')
		$sConn = _SFTP_Connect($sOpen, $sStringSplit[1], $sStringSplit[3], $sStringSplit[4], $sStringSplit[2])
		If @error Then
			_SFTP_Close($sOpen)
			Return SetError(2, 0, $sMainArray) ; All Failed.
		EndIf
		$sListArray = _SFTP_ListToArrayEx($sConn, $sDirectory)
	Else
		If $sStringSplit[2] = "" Then
			$sStringSplit[2] = 0
		EndIf
		If $sStringSplit[5] = "FTPP" Then
			$sPassiveMode = 1
		EndIf
		$sOpen = _FTP_Open('DropIt Upload')
		$sConn = _FTP_Connect($sOpen, $sStringSplit[1], $sStringSplit[3], $sStringSplit[4], $sPassiveMode, $sStringSplit[2])
		If @error Then
			_FTP_Close($sOpen)
			Return SetError(2, 0, $sMainArray) ; All Failed.
		EndIf
		$sListArray = __FTP_ListToArrayEx($sConn, $sDirectory, 0, 0x84000000) ; $INTERNET_FLAG_NO_CACHE_WRITE + $INTERNET_FLAG_RELOAD.
	EndIf
	ReDim $sListArray[$sListArray[0][0] + $sTo - $sFrom + 2][4]

	For $A = $sFrom To $sTo
		_Sorting_CheckButtons($sMainArray)
		If @error Then
			If $sStringSplit[5] = "SFTP" Then
				_SFTP_Close($sOpen)
			Else
				_FTP_Close($sOpen)
			EndIf
			Return SetExtended(1, $sMainArray) ; Aborted.
		EndIf

		If $sMainArray[$A][4] == -9 Then ; Skip Already Processed Item.
			ContinueLoop
		EndIf
		$sSource = $sMainArray[$A][0]
		$sSize = $sMainArray[$A][1]
		$sFileName = __GetFileName($sSource)
		$sDestination = $sDirectory & "/" & $sFileName
		__SetProgressStatus($sElementsGUI, 1, $sStringSplit[1] & $sDestination) ; Reset Single Progress Bar And Show Second Line.

		If $sListArray[0][0] > 0 Then
			For $B = 1 To $sListArray[0][0]
				If $sFileName = $sListArray[$B][0] Then
					$sDestination = __Duplicate_ProcessOnline($sProfile, $sSource, $sStringSplit[1], $sDirectory, $sListArray[$B][3], $sListArray[$B][1], $sListArray, $sStringSplit[5])
					If @error = 2 Then
						__SetPositionResult($sMainArray, $A, $A, $Global_ListViewProcess, $sElementsGUI, -1)
						$sMainArray[$A][4] = -9 ; Force Result To Be Not Overwritten.
						ContinueLoop 2 ; Skipped.
					EndIf
					__SetProgressStatus($sElementsGUI, 1, $sStringSplit[1] & $sDestination) ; Reset Single Progress Bar And Show Second Line.
					ExitLoop
				EndIf
			Next
		EndIf

		If $sStringSplit[5] = "SFTP" Then
			__SFTP_DirCreateEx($sConn, $sDirectory) ; Create Remote Directory If Does Not Exist.
			__SFTP_ProgressUpload($sConn, $sSource, $sDestination, $sElementsGUI[2], $sElementsGUI[3], $sElementsGUI[4], $sElementsGUI[5], $sSize)
		Else
			__FTP_DirCreateEx($sConn, $sDirectory) ; Create Remote Directory If Does Not Exist.
			If _WinAPI_PathIsDirectory($sSource) Then
				_FTP_DirPutContents($sConn, $sSource, $sDestination, 1)
			Else
				__FTP_ProgressUpload($sConn, $sSource, $sDestination, $sElementsGUI[2], $sElementsGUI[3], $sElementsGUI[4], $sElementsGUI[5], $sSize)
			EndIf
		EndIf
		If @error Then
			;_FTP_GetLastResponseInfo($ERR, $MESS) ; <<<<< Debug.
			;msgbox(0, "test", $ERR & @LF & $MESS) ; <<<<< Debug.
			__SetPositionResult($sMainArray, $A, $A, $Global_ListViewProcess, $sElementsGUI, -2)
			$sMainArray[$A][4] = -9 ; Force Result To Be Not Overwritten.
			$sFailed = 1 ; At Least One Item Failed.
			ContinueLoop
		EndIf
		__SetPositionResult($sMainArray, $A, $A, $Global_ListViewProcess, $sElementsGUI, 0)
		$sMainArray[$A][4] = -9 ; Force Result To Be Not Overwritten.

		$sListArray[0][0] += 1
		$sListArray[$sListArray[0][0]][0] = __GetFileName($sDestination)
		$sListArray[$sListArray[0][0]][1] = $sSize
		$sDate = FileGetTime($sSource)
		$sListArray[$sListArray[0][0]][3] = $sDate[0] & "/" & $sDate[1] & "/" & $sDate[2] & " " & $sDate[3] & ":" & $sDate[4] ; YYYY/MM/DD[ HH:MM]

		If $sStringSplit[6] == "True" Then
			_Sorting_RunDelete($sSource) ; Remove Source After Processing It.
		EndIf
	Next
	If $sStringSplit[5] = "SFTP" Then
		_SFTP_Close($sOpen)
	Else
		_FTP_Close($sOpen)
	EndIf

	If $sFailed Then
		Return SetError(3, 0, $sMainArray) ; Some Failed.
	EndIf
	Return $sMainArray
EndFunc   ;==>_Sorting_UploadFile

Func _Sorting_ProgressArchive($sProcess, $sSize, $sElementsGUI)
	Local $sProgress_1 = $sElementsGUI[2], $sProgress_2 = $sElementsGUI[3], $sPercent_1 = $sElementsGUI[4], $sPercent_2 = $sElementsGUI[5]
	Local $sPercent, $sPreviousPercent = -1
	Local $sPercentHandle = __7Zip_OpenPercent($sProcess)

	While 1
		$sPercent = __7Zip_ReadPercent($sPercentHandle)
		If $sPercent > 0 And $sPreviousPercent <> $sPercent Then
			GUICtrlSetData($sProgress_2, $sPercent)
			GUICtrlSetData($sPercent_2, $sPercent & ' %')
			$sPreviousPercent = $sPercent
			$sPercent = __GetPercent($sSize * $sPercent / 100, 0)
			If GUICtrlRead($sProgress_1) <> $sPercent Then
				GUICtrlSetData($sProgress_1, $sPercent)
				GUICtrlSetData($sPercent_1, $sPercent & ' %')
			EndIf
		Else
			Sleep(50)
		EndIf

		If $G_Global_AbortSorting Then
			ProcessClose($sProcess)
			ProcessWaitClose($sProcess)
			Return SetError(1, 0, 0) ; Aborted.
		EndIf

		If ProcessExists($sProcess) = 0 Then
			__7Zip_ClosePercent($sPercentHandle)
			ExitLoop
		EndIf
	WEnd

	Return 1
EndFunc   ;==>_Sorting_ProgressArchive

Func _Sorting_ProgressCopy($sMainArray, $sElementsGUI)
	Local $sProgress_1 = $sElementsGUI[2], $sProgress_2 = $sElementsGUI[3], $sPercent_1 = $sElementsGUI[4], $sPercent_2 = $sElementsGUI[5]
	Local $sData, $sState

	While 1
		_Sorting_CheckButtons($sMainArray, 1)
		If @error Then
			_Copy_Abort()
			Return SetError(1, 0, 0) ; Aborted.
		EndIf

		$sState = _Copy_GetState()
		If $sState[0] Then
			If $sState[0] = -1 Then
                ; Preparing.
            Else
				$sData = Round($sState[1] / $sState[2] * 100)
				If GUICtrlRead($sProgress_2) <> $sData Then
					GUICtrlSetData($sProgress_2, $sData)
					GUICtrlSetData($sPercent_2, $sData & ' %')
					$sData = __GetPercent($sState[1], 0)
					If GUICtrlRead($sProgress_1) <> $sData Then
						GUICtrlSetData($sProgress_1, $sData)
						GUICtrlSetData($sPercent_1, $sData & ' %')
					EndIf
				Else
					Sleep(50)
				EndIf
				$sData = StringRegExpReplace($sState[6], '^.*', '')
				If $sData <> "" And GUICtrlRead($sElementsGUI[1]) <> $sData Then
					__SetProgressStatus($sElementsGUI, 1, $sData) ; Reset Single Progress Bar And Show Second Line.
				EndIf
			EndIf
		Else
			If $sState[5] <> 0 Then
				Return SetError(2, 0, 0) ; Failed.
			EndIf
			GUICtrlSetData($sProgress_2, 100)
			GUICtrlSetData($sPercent_2, '100 %')
			ExitLoop
		EndIf
	WEnd

	Return 1
EndFunc   ;==>_Sorting_ProgressCopy

Func _Sorting_StartProgressCopy($sSource, $sDestination, $sAction)
	Local $sError

	If $sAction == "$0" Then ; Move.
		If _WinAPI_PathIsDirectory($sSource) And StringLeft($sSource, 2) <> StringLeft($sDestination, 2) Then ; Move Folder On Different Drive.
			If _Copy_MoveDir($sSource, $sDestination, BitOR($MOVE_FILE_COPY_ALLOWED, $MOVE_FILE_REPLACE_EXISTING), $COPY_OVERWRITE_YES) = 0 Then
				$sError = 1
			EndIf
		Else
			If _Copy_MoveFile($sSource, $sDestination, BitOR($MOVE_FILE_COPY_ALLOWED, $MOVE_FILE_REPLACE_EXISTING)) = 0 Then
				$sError = 1
			EndIf
		EndIf
	Else ; Copy.
		If _WinAPI_PathIsDirectory($sSource) Then
			If _Copy_CopyDir($sSource, $sDestination, $COPY_FILE_ALLOW_DECRYPTED_DESTINATION, $COPY_OVERWRITE_YES) = 0 Then
				$sError = 1
			EndIf
		Else
			If _Copy_CopyFile($sSource, $sDestination, $COPY_FILE_ALLOW_DECRYPTED_DESTINATION) = 0 Then
				$sError = 1
			EndIf
		EndIf
	EndIf

	If $sError Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_Sorting_StartProgressCopy

Func _Sorting_RunDelete($sSource, $sMode = 1)
	If _WinAPI_PathIsDirectory($sSource) Then
		If __IsReadOnly($sSource) Then
			If __Is("IgnoreAttributes") Then
				FileSetAttrib($sSource, '-R', 1)
			Else
				Return SetError(2, 0, 0) ; Failed.
			EndIf
		EndIf
		Switch $sMode
			Case 2
				_SecureDirectoryDelete($sSource)
			Case 3
				FileRecycle($sSource)
			Case Else
				DirRemove($sSource, 1)
		EndSwitch
	Else
		If __IsReadOnly($sSource) Then
			If __Is("IgnoreAttributes") Then
				FileSetAttrib($sSource, '-R')
			Else
				Return SetError(2, 0, 0) ; Failed.
			EndIf
		EndIf
		Switch $sMode
			Case 2
				_SecureFileDelete($sSource)
			Case 3
				FileRecycle($sSource)
			Case Else
				FileDelete($sSource)
		EndSwitch
	EndIf

	If @error Then
		Return SetError(@error, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_Sorting_RunDelete
#EndRegion >>>>> Processing Functions <<<<<

#Region >>>>> General Functions <<<<<
Func _Main()
	Local $mProfileList, $mCurrentProfile, $mMsg
	Local $mINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $mMonitoringTime_Now = TimerInit(), $mImmediateMonitoringFiles[1] = [0], $mImmediateMonitoring_DelayTimer = 0
	Local $mHidingTime_Now = $mMonitoringTime_Now

	DragDropEvent_Startup() ; Enable Drag & Drop.
	_RDC_OpenDll(@ScriptDir & '\Lib\rdc\RDC.dll')
	_SetFeaturesWithTimer($mINI) ; Load Global Monitoring Configuration.
	__InstalledCheck() ; Check To See If DropIt Is Installed.
	__IsProfile() ; Check If A Default Profile Is Available.
	_Main_Create() ; Create The Main GUI, ContextMenu & TrayMenu.

	GUIRegisterMsg($WM_CONTEXTMENU, "_WM_CONTEXTMENU")
	GUIRegisterMsg($WM_MOUSEWHEEL, "_WM_MOUSEWHEEL")
	GUIRegisterMsg($WM_SYSCOMMAND, "_WM_SYSCOMMAND")
	GUIRegisterMsg($WM_POWERBROADCAST, "_WM_SLEEPMODE")

	GUIRegisterMsg($WM_DRAGENTER, "_WM_ONDRAGDROP")
	GUIRegisterMsg($WM_DRAGOVER, "_WM_ONDRAGDROP")
	GUIRegisterMsg($WM_DROP, "_WM_ONDRAGDROP")

	__Log_Write(@LF & "===== " & __GetLang('DROPIT_STARTED', 'DropIt Started') & " =====")

	_WinAPI_EmptyWorkingSet() ; Reduce Memory Usage Of DropIt.

	If $Global_Monitoring <> 0 And __Is("MonitoringFirstAtStartup") Then
		$mMonitoringTime_Now = _MonitoringFolders($mINI, $mMonitoringTime_Now) ; Do A First Monitoring Scan At Startup.
	EndIf

	While 1
		If $Global_GraduallyHide <> 0 Then
			$mHidingTime_Now = _HidingTargetImage($mHidingTime_Now)
		EndIf
		If $Global_Monitoring <> 0 Then

			; Realize Immediate Monitoring
			If $Global_Monitoring >= 2 Then
				_MonitoringChanges($mImmediateMonitoringFiles)
				If $mImmediateMonitoringFiles[0] > 0 Then
					If $mImmediateMonitoring_DelayTimer = 0 Then
						$mImmediateMonitoring_DelayTimer = TimerInit()
					ElseIf TimerDiff($mImmediateMonitoring_DelayTimer) > 2000 Then
						$mImmediateMonitoring_DelayTimer = -1
					EndIf
				EndIf
			EndIf

			If $mImmediateMonitoring_DelayTimer = -1 Then
				$mMonitoringTime_Now = _MonitoringFolders($mINI, $mMonitoringTime_Now, $mImmediateMonitoringFiles)
				$mImmediateMonitoring_DelayTimer = 0
				Dim $mImmediateMonitoringFiles[1] = [0]
			Else
				$mMonitoringTime_Now = _MonitoringFolders($mINI, $mMonitoringTime_Now)
			EndIf
		EndIf
		If $Global_Wheel <> 0 Then ; Switch Profiles With Mouse Scroll Wheel.
			If __Is("MouseScroll") Then
				$mProfileList = __ProfileList_Get() ; Get Array Of All Profiles.
				$mCurrentProfile = __GetCurrentProfile() ; Get Current Profile From The Settings INI File.
				_SwitchProfiles($mProfileList, $mCurrentProfile)
				_Refresh(0, 1)
			EndIf
		EndIf
		If $G_Global_WM_COPY <> 0 Then ; $G_Global_WM_COPY Is Defined In "Lib\udf\WM_COPYDATA.au3" File.
			$G_Global_WM_COPY = 0 ; Used To Work With Both Visible And Minimized Interface (Dummy Does Not Work With Minimized Interface).
			__CMDLine(__CmdLineRaw(_WM_COPYDATA_GetData())) ; __CmdLineRaw() Convert $CmdLineRaw To $CmdLine.
		EndIf
		If $Global_NewDroppedFiles <> 0 Then
			$Global_NewDroppedFiles = 0
			If __Is("MonitoredFolderHotkeys") Then
				If _IsPressed("11") Then ; Add Monitored Folder.
					_Monitored_AddRemoveDropped($Global_DroppedFiles, $mINI)
					ContinueLoop
				ElseIf _IsPressed("12") Then ; Remove Monitored Folder.
					_Monitored_AddRemoveDropped($Global_DroppedFiles, $mINI, 1)
					ContinueLoop
				EndIf
			EndIf
			If $Global_GUI_State = 1 Then ; GUI Is Visible.
				GUISetState(@SW_SHOW, $Global_GUI_2) ; Show Small Working Icon.
			EndIf
			_DropEvent($Global_DroppedFiles, -1) ; Send Dropped Files To Be Processed.
			GUISetState(@SW_HIDE, $Global_GUI_2) ; Hide Small Working Icon.
		EndIf

		$mMsg = GUIGetMsg()
		Switch $mMsg
			Case $GUI_EVENT_CLOSE, $Global_ContextMenu[11][0] ; Exit DropIt If An Exit Event Is Called.
				ExitLoop

			Case $Global_ContextMenu[2][0]
				GUICtrlSetState($Global_Icon_1, $GUI_DISABLE) ; Disable Main Icon.
				_Manage_GUI($Global_GUI_1, $mINI) ; Open Manage GUI.
				_Refresh() ; Refresh The Main GUI & TrayMenu, Including Translation Strings & ContextMenu.
				GUICtrlSetState($Global_Icon_1, $GUI_ENABLE) ; Enable Main Icon.

			Case $Global_ContextMenu[12][0]
				GUICtrlSetState($Global_Icon_1, $GUI_DISABLE)
				$mProfileList = _Customize_GUI($Global_GUI_1, $mProfileList) ; Open Customize GUI.
				_Refresh(1, 1) ; Refresh The Main GUI Icon & TrayMenu, Including Translation Strings & ContextMenu.
				GUICtrlSetState($Global_Icon_1, $GUI_ENABLE)

			Case $Global_ContextMenu[6][0]
				GUICtrlSetState($Global_Icon_1, $GUI_DISABLE)
				_Options($Global_GUI_1) ; Open Options.
				_Refresh(1) ; Refresh The Main GUI & TrayMenu, Including Translation Strings & ContextMenu.
				GUICtrlSetState($Global_Icon_1, $GUI_ENABLE)

			Case $Global_ContextMenu[7][0]
				_TrayMenu_ShowTray() ; Show The TrayMenu.

			Case $Global_ContextMenu[8][0]
				If FileExists($G_Global_GuidePath) Then
					__ShellExecuteOnTop($G_Global_GuidePath)
				EndIf

			Case $Global_ContextMenu[9][0]
				_About()

			Case Else
				If $mMsg >= $Global_ContextMenu[13][0] And $mMsg <= $Global_ContextMenu[13 + $Global_ContextMenu[4][1]][0] Then
					For $A = 13 To 13 + $Global_ContextMenu[4][1]
						If $mMsg = $Global_ContextMenu[$A][0] Then
							__Log_Write(__GetLang('MAIN_TIP_1', 'Changed profile to'), $Global_ContextMenu[$A][1])
							__SetCurrentProfile($Global_ContextMenu[$A][1]) ; Write Selected Profile Name To The Settings INI File.
							ExitLoop
						EndIf
					Next
					__SetCurrentPosition() ; Set Current Coordinates/Position Of DropIt.
					_Refresh(0, 1)
				ElseIf $mMsg > $Global_ContextMenu[13 + $Global_ContextMenu[4][1]][0] And $mMsg <= $Global_ContextMenu[13 + $Global_ContextMenu[4][1] + $Global_ContextMenu[5][1]][0] Then
					For $A = 13 + $Global_ContextMenu[4][1] + 1 To 13 + $Global_ContextMenu[4][1] + $Global_ContextMenu[5][1]
						If $mMsg = $Global_ContextMenu[$A][0] Then
							__SetCurrentLanguage($Global_ContextMenu[$A][1]) ; Set The Selected Language To The Settings INI File.
							ExitLoop
						EndIf
					Next
					_Refresh()
				EndIf

		EndSwitch
	WEnd

	_RDC_Destroy()
	_RDC_CloseDll()
EndFunc   ;==>_Main

Func _Main_Create()
	Local $rGUI_1 = $Global_GUI_1
	Local $rGUI_2 = $Global_GUI_2
	Local $rIcon_1 = $Global_Icon_1

	Local $rProfile = __IsProfile(-1, 0) ; Get Array Of Current Profile.
	Local $rPosition = __GetCurrentPosition() ; Get Current Coordinates/Position Of DropIt.

	$rGUI_1 = GUICreate("DropIt", $rProfile[5], $rProfile[6] + 100, $rPosition[0], $rPosition[1], $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_TOOLWINDOW))
	$Global_GUI_1 = $rGUI_1
	__OnTop($Global_GUI_1) ; Set GUI "OnTop" If True.
	__SingletonEx() ; _WM_COPYDATA.

	If $rProfile[7] < 10 Then
		$rProfile[7] = 100
		__ImageWrite(-1, 4, -1, -1, -1, $rProfile[7]) ; Write Opacity To The Current Profile.
	EndIf
	__SetBitmap($rGUI_1, $rProfile[3], 255 / 100 * $rProfile[7], $rProfile[5], $rProfile[6]) ; Set Image & Resize To The GUI.
	__GUIInBounds($rGUI_1) ; Check If The GUI Is Within View Of The Users Screen.
	If @error = 0 Then
		__SetCurrentPosition($rGUI_1)
	EndIf

	DragDropEvent_Register($rGUI_1) ; Activate Drag & Drop.
	_ContextMenu_Create($rIcon_1) ; Create The ContextMenu.

	$rGUI_2 = GUICreate("", 16, 16, $rProfile[5] / 5, $rProfile[6] / 5, $WS_POPUP, BitOR($WS_EX_MDICHILD, $WS_EX_LAYERED, $WS_EX_TOPMOST), $rGUI_1)
	$Global_GUI_2 = $rGUI_2

	GUISetBkColor(0x000001)
	_WinAPI_SetLayeredWindowAttributes($rGUI_2, 0x00000001, 0x00, 1, 0)
	Local $rLabelIconImage = GUICtrlCreateLabel("", 0, 0, 16, 16)
	_Resource_SetToCtrlID($rLabelIconImage, "PROG")
	GUISetState(@SW_HIDE, $rGUI_2)

	_Refresh()

	If __Is("Minimized") Then
		_TrayMenu_ShowTray()
	Else
		GUISetState(@SW_SHOW, $rGUI_1)
	EndIf
	__SendTo_Install()

	Return 1
EndFunc   ;==>_Main_Create

Func _SetFeaturesWithTimer($mINI)
	Local $mMonitored, $iId, $mStringSplit

	$Global_GraduallyHide = 0
	If __Is("GraduallyHide") Then
		$Global_GraduallyHide = 1
		$Global_GraduallyHideTimer = Number(IniRead($mINI, $G_Global_GeneralSection, "GraduallyHideTime", ""))
		If $Global_GraduallyHideTimer < 0 Then
			$Global_GraduallyHideTimer = 1 ; Seconds.
		EndIf
		$Global_GraduallyHideSpeed = Number(IniRead($mINI, $G_Global_GeneralSection, "GraduallyHideSpeed", ""))
		If $Global_GraduallyHideSpeed < 1 Or $Global_GraduallyHideSpeed > 100 Then
			$Global_GraduallyHideSpeed = 5 ; Speed From 1 To 100.
		EndIf
		$Global_GraduallyHideVisPx = Number(IniRead($mINI, $G_Global_GeneralSection, "GraduallyHideVisPx", ""))
		If $Global_GraduallyHideVisPx < 0 Or $Global_GraduallyHideVisPx > 50 Then
			$Global_GraduallyHideVisPx = 8 ; Visible Margin From 0 To 50.
		EndIf
	EndIf
	$Global_Monitoring = 0
	If Number(IniRead($mINI, $G_Global_GeneralSection, "Monitoring", 1)) > 0 Then
		$Global_Monitoring = Number(IniRead($mINI, $G_Global_GeneralSection, "Monitoring", 1))
		$Global_MonitoringTimer = Number(IniRead($mINI, $G_Global_GeneralSection, "MonitoringTime", 30))
		If $Global_MonitoringTimer < 1 Then
			$Global_MonitoringTimer = 30 ; Seconds.
		EndIf
		$Global_MonitoringSizer = Number(IniRead($mINI, $G_Global_GeneralSection, "MonitoringSize", 0))
		If $Global_MonitoringSizer < 0 Then
			$Global_MonitoringSizer = 0 ; KB.
		EndIf
		If $Global_Monitoring >= 2 Then
			$mMonitored = __IniReadSection($mINI, "MonitoredFolders") ; Get Associations Array For The Current Profile.
			If @error = 0 Then
				_RDC_Destroy()
				Dim $Global_MonitoringChanges[1]
				For $A = 1 To $mMonitored[0][0]
					$mStringSplit = StringSplit($mMonitored[$A][1], "|")
					ReDim $mStringSplit[3]
					If $mStringSplit[2] == $G_Global_StateDisabled Then
						ContinueLoop
					EndIf

					If $Global_Monitoring >= 2 Then
						$iId = _RDC_Create($mMonitored[$A][0], True, BitOR($FILE_NOTIFY_CHANGE_FILE_NAME, $FILE_NOTIFY_CHANGE_DIR_NAME, $FILE_NOTIFY_CHANGE_SIZE))
					EndIf
					If @error = 0 Then
						_ArrayAdd($Global_MonitoringChanges, $iId)
					EndIf
				Next
			EndIf
		EndIf
	EndIf
EndFunc   ;==>_SetFeaturesWithTimer

Func _MonitoringChanges(ByRef $aInitialData)
	Local $iId, $i, $j, $aData, $sResult = ""

	For $i = 1 to UBound($Global_MonitoringChanges) - 1
		$iId = $Global_MonitoringChanges[$i]
		$aData = _RDC_GetData($iId)
		If @error Then
			_RDC_Delete($iId)
			_ArrayDelete($Global_MonitoringChanges, _ArraySearch($Global_MonitoringChanges, $iId))
			ContinueLoop
		EndIf

		For $j = 1 to $aData[0][0]
			If $aData[$j][0] = $FILE_ACTION_ADDED Or $aData[$j][0] = $FILE_ACTION_MODIFIED Or $aData[$j][0] = $FILE_ACTION_RENAMED_NEW_NAME Or $aData[$j][0] = $FILE_NOTIFY_CHANGE_SIZE Then
				If Not StringInStr($sResult, _RDC_GetDirectory($iId) & "\" & $aData[$j][1]) And Not StringInStr($Global_MonitoringPreviousChanges, _RDC_GetDirectory($iId) & "\" & $aData[$j][1]) Then
					If $sResult <> "" Then
						$sResult &= "|"
					EndIf
					$sResult &= _RDC_GetDirectory($iId) & "\" & $aData[$j][1]
				EndIf
			EndIf
		Next
	Next

	$Global_MonitoringPreviousChanges = $sResult

	If $sResult = "" Then Return
	_ArrayAdd($aInitialData, $sResult, 0, "|")
	$aInitialData[0] = UBound($aInitialData) - 1

EndFunc   ;==>_MonitoringChanges

Func _HidingTargetImage($mTime_Now)
	Switch $Global_GraduallyHide
		Case 1 ; GraduallyHide Enabled.
			If TimerDiff($mTime_Now) > ($Global_GraduallyHideTimer * 1000) Then ; Start Hiding.
				$Global_GraduallyHide = 2
			EndIf
			__GUIGraduallyHide($Global_GUI_1, __Is("OnTop"), $Global_GraduallyHideSpeed, $Global_GraduallyHideVisPx, 0, 1) ; Gradually Reveal-Only Target Icon On The Nearest Side Of The Screen.
		Case 2 ; Is Hiding/Revealing.
			__GUIGraduallyHide($Global_GUI_1, __Is("OnTop"), $Global_GraduallyHideSpeed, $Global_GraduallyHideVisPx, 0) ; Gradually Hide/Reveal Target Icon On The Nearest Side Of The Screen.
			If @error Then ; Completely Hidden/Revealed.
				$Global_GraduallyHide = 1
				$mTime_Now = TimerInit()
			EndIf
	EndSwitch

	Return $mTime_Now
EndFunc   ;==>_HidingTargetImage

Func _MonitoringFolders($mINI, $mTime_Now, $mForceExecutionOn = "")
	Local $mMonitored, $mStringSplit, $mLoadedFolder[2] = [1, 0], $mChangedFiles[1] = [0]

	If (($Global_Monitoring = 1 Or $Global_Monitoring = 3) And TimerDiff($mTime_Now) > ($Global_MonitoringTimer * 1000)) Or IsArray($mForceExecutionOn) Then
		$mMonitored = __IniReadSection($mINI, "MonitoredFolders") ; Get Associations Array For The Current Profile.
		If @error = 0 Then
			$Global_MenuDisable = 1
			TraySetClick(0)
			For $A = 1 To $mMonitored[0][0]
				$mLoadedFolder[1] = $mMonitored[$A][0]
				$mStringSplit = StringSplit($mMonitored[$A][1], "|")
				ReDim $mStringSplit[3]
				If $mStringSplit[2] == $G_Global_StateDisabled Then
					ContinueLoop ; Skip Folder If It Is Disabled.
				EndIf
				If StringInStr($mLoadedFolder[1], "%") Then
					$mLoadedFolder[1] = _ReplaceAbbreviation($mLoadedFolder[1], 1, "", $mStringSplit[1]) ; To Support File-Independent Abbreviations In Monitored Folders.
					If @error Then
						ContinueLoop ; Skip Folder If %UserInput% Value Is Not Defined.
					EndIf
				EndIf
				If FileExists($mLoadedFolder[1]) = 0 Then
					ContinueLoop ; Skip Folder If Does Not Exist.
				EndIf
				If DirGetSize($mLoadedFolder[1]) / 1024 < $Global_MonitoringSizer And Not IsArray($mForceExecutionOn) Then
					ContinueLoop ; Skip Folder If Is Smaller Than Defined Size And Timer Is Used.
				EndIf
				If IsArray($mForceExecutionOn) Then
					; ExecuteForceExecutionOn Items Always First, To Remove Duplicate File Appearance.
					For $B = 1 to $mForceExecutionOn[0]
						If StringInStr($mForceExecutionOn[$B], $mLoadedFolder[1]) > 0 Then
							__Log_Write(__GetLang('MONITORED_FOLDER', 'Monitored Folder'), $mLoadedFolder[1] & " -> " & $mForceExecutionOn[$B])
							$mChangedFiles[0] += 1
							ReDim $mChangedFiles[$mChangedFiles[0] + 1]
							$mChangedFiles[$mChangedFiles[0]] = $mForceExecutionOn[$B]
						EndIf
					Next
					If $mChangedFiles[0] > 0 Then
						If $Global_GUI_State = 1 Then ; GUI Is Visible.
							GUISetState(@SW_SHOWNOACTIVATE, $Global_GUI_2) ; Show Small Working Icon.
						EndIf
						_DropEvent($mChangedFiles, $mStringSplit[1], 1)
					EndIf
				ElseIf ($Global_Monitoring = 1 Or $Global_Monitoring = 3) And TimerDiff($mTime_Now) > ($Global_MonitoringTimer * 1000) Then
					; Finally Execute Regular Timer Drop Event
					__Log_Write(__GetLang('MONITORED_FOLDER', 'Monitored Folder'), $mLoadedFolder[1])
					If $Global_GUI_State = 1 Then ; GUI Is Visible.
						GUISetState(@SW_SHOWNOACTIVATE, $Global_GUI_2) ; Show Small Working Icon.
					EndIf
					_DropEvent($mLoadedFolder, $mStringSplit[1], 1)
				EndIf
				GUISetState(@SW_HIDE, $Global_GUI_2) ; Hide Small Working Icon.
			Next
			TraySetClick(8)
			$Global_MenuDisable = 0
		EndIf
		$mTime_Now = TimerInit()
	EndIf

	Return $mTime_Now
EndFunc   ;==>_MonitoringFolders

Func _SwitchProfiles($mProfileList, $mCurrentProfile)
	For $A = 1 To $mProfileList[0]
		If $mProfileList[$A] = $mCurrentProfile Then
			If $Global_Wheel = 1 Then ; Down.
				If $A = $mProfileList[0] Then ; If Current Is The Last.
					$A = 0
				EndIf
				$mCurrentProfile = $mProfileList[$A + 1]
			Else ; 2 = Up.
				If $A = 1 Then ; If Current Is The First.
					$A = $mProfileList[0] + 1
				EndIf
				$mCurrentProfile = $mProfileList[$A - 1]
			EndIf
			ExitLoop
		EndIf
	Next
	__SetCurrentProfile($mCurrentProfile)
	Return 1
EndFunc   ;==>_SwitchProfiles

Func _Refresh($rSendTo = 0, $rImage = 0)
	If $rImage = 1 Then
		_Refresh_Image() ; Refresh Target Image.
	EndIf
	_ContextMenu_Create() ; Create A ContextMenu.
	_TrayMenu_Create() ; Create A Hidden TrayMenu.
	If __Is("CustomTrayIcon") Then
		__Tray_SetIcon(__IsProfile(-1, 2))
	EndIf
	If $rSendTo = 1 Then
		__SendTo_Install()
	EndIf
	GUIRegisterMsg($WM_COMMAND, "_WM_LBUTTONDBLCLK") ; $WM_LBUTTONDBLCLK As Command Doesn't Work.
	_WinAPI_EmptyWorkingSet() ; Reduce Memory Usage Of DropIt.
	$Global_Wheel = 0
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
	Local $cCurrentLanguage = __GetCurrentLanguage() ; Get Current Language From The Settings INI File.
	Local $cLanguageDir = __GetDefault(1024) ; Get Default Language Directory.
	Local $cContextMenu = _ContextMenu_Delete($cHandle, $cCurrentProfile) ; Delete The Current ContextMenu Items.
	Local $cProfileList = __ProfileList_Get() ; Get Array Of All Profiles.
	Local $cLanguageList = __LangList_Get() ; Get Array Of All Profiles.

	$cHandle = $Global_Icon_1
	$cContextMenu[1][0] = GUICtrlCreateContextMenu($cHandle)
	$cContextMenu[2][0] = GUICtrlCreateMenuItem(__GetLang('ASSOCIATIONS', 'Associations'), $cContextMenu[1][0], 0)
	$cContextMenu[3][0] = GUICtrlCreateMenuItem("", $cContextMenu[1][0], 1)
	$cContextMenu[4][0] = GUICtrlCreateMenu(__GetLang('PROFILES', 'Profiles'), $cContextMenu[1][0], 2)
	$cContextMenu[4][1] = $cProfileList[0] ; Save Number Of Profiles.
	$cContextMenu[5][0] = GUICtrlCreateMenu(__GetLang('LANGUAGES', 'Languages'), $cContextMenu[1][0], 3)
	$cContextMenu[5][1] = $cLanguageList[0] ; Save Number Of Language Files.
	$cContextMenu[6][0] = GUICtrlCreateMenuItem(__GetLang('OPTIONS', 'Options'), $cContextMenu[1][0], 4)
	$cContextMenu[7][0] = GUICtrlCreateMenuItem(__GetLang('HIDE', 'Hide'), $cContextMenu[1][0], 5)
	$cContextMenu[8][0] = GUICtrlCreateMenuItem(__GetLang('GUIDE', 'Guide'), $cContextMenu[1][0], 6)
	If FileExists($G_Global_GuidePath) = 0 Then
		GUICtrlSetState($cContextMenu[8][0], $GUI_DISABLE)
	EndIf
	$cContextMenu[9][0] = GUICtrlCreateMenuItem(__GetLang('ABOUT', 'About') & "...", $cContextMenu[1][0], 7)
	$cContextMenu[10][0] = GUICtrlCreateMenuItem("", $cContextMenu[1][0], 8)
	$cContextMenu[11][0] = GUICtrlCreateMenuItem(__GetLang('EXIT', 'Exit'), $cContextMenu[1][0], 9)

	$cContextMenu[12][0] = GUICtrlCreateMenuItem(__GetLang('CUSTOMIZE', 'Customize'), $cContextMenu[4][0], 0)
	$cContextMenu[13][0] = GUICtrlCreateMenuItem("", $cContextMenu[4][0], 1)

	__SetItemImage("ASSO", 0, $cContextMenu[1][0], 0, 1)
	__SetItemImage("PROF", 2, $cContextMenu[1][0], 0, 1)
	__SetItemImage("FLAGS", 3, $cContextMenu[1][0], 0, 1)
	__SetItemImage("OPT", 4, $cContextMenu[1][0], 0, 1)
	__SetItemImage("HIDE", 5, $cContextMenu[1][0], 0, 1)
	__SetItemImage("GUIDE", 6, $cContextMenu[1][0], 0, 1)
	__SetItemImage("INFO", 7, $cContextMenu[1][0], 0, 1)
	__SetItemImage("CLOSE", 9, $cContextMenu[1][0], 0, 1)
	__SetItemImage("CUST", 0, $cContextMenu[4][0], 0, 1)

	$cContextMenu[0][0] = 13 ; To Correctly Restore Counter Of Only Main Items.
	ReDim $cContextMenu[$cContextMenu[0][0] + $cContextMenu[4][1] + 1][$cContextMenu[0][1]]
	For $A = 1 To $cProfileList[0]
		$cContextMenu[0][0] += 1
		$cContextMenu[$cContextMenu[0][0]][0] = GUICtrlCreateMenuItem($cProfileList[$A], $cContextMenu[4][0], $A + 1, 1)
		__SetItemImage(__IsProfile($cProfileList[$A], 2), $A + 1, $cContextMenu[4][0], 0, 0, 20, 20)
		$cContextMenu[$cContextMenu[0][0]][1] = $cProfileList[$A]
		If $cProfileList[$A] = $cCurrentProfile Then
			GUICtrlSetState($cContextMenu[$cContextMenu[0][0]][0], 1)
		EndIf
	Next
	ReDim $cContextMenu[$cContextMenu[0][0] + $cContextMenu[5][1] + 1][$cContextMenu[0][1]]
	For $A = 1 To $cLanguageList[0]
		$cContextMenu[0][0] += 1
		$cContextMenu[$cContextMenu[0][0]][0] = GUICtrlCreateMenuItem($cLanguageList[$A], $cContextMenu[5][0], $A - 1, 1)
		__SetItemImage($cLanguageDir & $cLanguageList[$A] & ".gif", $A - 1, $cContextMenu[5][0], 0, 0, 18, 12)
		$cContextMenu[$cContextMenu[0][0]][1] = $cLanguageList[$A]
		If $cLanguageList[$A] = $cCurrentLanguage Then
			GUICtrlSetState($cContextMenu[$cContextMenu[0][0]][0], 1)
		EndIf
	Next

	$Global_ContextMenu = $cContextMenu

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
	GUICtrlSetTip($cHandle, __GetLang('TITLE_TOOLTIP', 'Personal Assistant to Automatically Manage Your Files'), "DropIt [" & $cCurrentProfile & "]")
	_WinAPI_SetFocus(GUICtrlGetHandle($cHandle)) ; Set The $Global_Icon_1 Label As Having Focus, Used For The HotKeys.
	Local $cContextMenu = $Global_ContextMenu
	Local $cReturn_ContextMenu[$cContextMenu[0][0] + 1][$cContextMenu[0][1]] = [[$cContextMenu[0][0], $cContextMenu[0][1]]]
	Return $cReturn_ContextMenu
EndFunc   ;==>_ContextMenu_Delete

Func _About($aHandle = -1)
	Local $aGUI, $aIcon_GUI, $aIcon_Label, $aClose, $aReadme, $aLicense, $aUpdate, $aUpdateProgress, $aUpdateText, $aTranslator

	$aTranslator = StringTrimLeft(FileReadLine(__GetDefault(1024) & __GetCurrentLanguage() & ".lng", 2), StringLen(";TranslatorName"))
	If StringLeft($aTranslator, 1) = "=" Then
		$aTranslator = StringTrimLeft($aTranslator, 1)
	Else
		$aTranslator = "-"
	EndIf

	$aGUI = GUICreate(__GetLang('ABOUT', 'About') & "...", 440, 190, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($aHandle))
	GUICtrlCreateLabel("DropIt", 80, 10, 350, 25)
	GUICtrlSetFont(-1, 18)
	GUICtrlCreateLabel("v" & $G_Global_CurrentVersion, 80, 40, 350, 17)
	GUICtrlCreateLabel("", 80, 60, 350, 1) ; Single Line.
	GUICtrlSetBkColor(-1, 0x000000)
	GUICtrlCreateLabel(__GetLang('MAIN_TIP_0', 'Software developed by %DropItTeam%.'), 80, 70, 350, 18)
	GUICtrlCreateLabel(__GetLang('MAIN_TIP_2', 'Released under %DropItLicense%.'), 80, 70 + 19, 350, 18)
	GUICtrlCreateLabel(__GetLang('MAIN_TIP_3', 'Current translation by') & ": " & $aTranslator, 80, 70 + 19 + 19, 350, 18)

	$aUpdate = GUICtrlCreateButton(__GetLang('CHECK_UPDATE', 'Check Update'), 10, 155, 120, 25)
	$aLicense = GUICtrlCreateButton(__GetLang('LICENSE', 'License'), 155, 155, 85, 25)
	If FileExists($G_Global_LicensePath) = 0 Then
		GUICtrlSetState($aLicense, $GUI_DISABLE)
	EndIf
	$aReadme = GUICtrlCreateButton(__GetLang('README', 'Readme'), 250, 155, 85, 25)
	If FileExists($G_Global_ReadmePath) = 0 Then
		GUICtrlSetState($aReadme, $GUI_DISABLE)
	EndIf
	$aClose = GUICtrlCreateButton(__GetLang('CLOSE', 'Close'), 345, 155, 85, 25)

	$aUpdateText = GUICtrlCreateLabel("", 80, 133, 350, 18)
	If __IsWindowsVersion() = 0 Then
		$aUpdateProgress = GUICtrlCreateProgress(200, 16, 190, 14, 0x01)
		GUICtrlSetState($aUpdateProgress, $GUI_HIDE)
	Else
		$aUpdateProgress = GUICtrlCreatePic("", 200, 16, 190, 14)
	EndIf

	$aIcon_GUI = GUICreate("", 64, 64, 10, 10, $WS_POPUP, BitOR($WS_EX_MDICHILD, $WS_EX_LAYERED), $aGUI)
	GUISetBkColor(0x000001)
	_WinAPI_SetLayeredWindowAttributes($aIcon_GUI, 0x00000001, 0x00, 1, 0)
	$aIcon_Label = GUICtrlCreateLabel("", 0, 0, 64, 64)
	_Resource_SetToCtrlID($aIcon_Label, "IMAGE")
	GUICtrlSetTip($aIcon_Label, __GetLang('VISIT_WEBSITE', 'Visit Website'))
	GUICtrlSetCursor($aIcon_Label, 0)

	GUISetState(@SW_SHOW, $aIcon_GUI)
	GUISetState(@SW_SHOW, $aGUI)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $aClose
				ExitLoop

			Case $aUpdate
				__Update_Check($aUpdateText, $aUpdateProgress, $aUpdate, $aGUI)
				GUICtrlSetState($aUpdate, $GUI_DISABLE)

			Case $aLicense
				If FileExists($G_Global_LicensePath) Then
					__ShellExecuteOnTop($G_Global_LicensePath)
				EndIf

			Case $aReadme
				If FileExists($G_Global_ReadmePath) Then
					__ShellExecuteOnTop($G_Global_ReadmePath)
				EndIf

			Case $aIcon_Label
				ShellExecute(_WinAPI_ExpandEnvironmentStrings("%DropItURL%"))

		EndSwitch
	WEnd

	GUIDelete($aGUI)

	__SetCurrentPosition() ; Set Current Coordinates/Position Of DropIt.
	__OnTop($Global_GUI_1) ; Set GUI "OnTop" If True.

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_About

Func _Options($oHandle = -1)
	Local $oINI = __IsSettingsFile() ; Get Default Settings INI File.

	Local $oCheckItems[29] = [28], $oCheckModeItems[3] = [2], $oComboItems[4] = [3], $oGroup[4] = [3], $oCurrent[4] = [3]
	Local $oINI_TrueOrFalse_Array[29] = [28, "OnTop", "LockPosition", "MultipleInstances", "UseSendTo", "CreateLog", "FolderAsFile", "IgnoreNew", "AutoDup", "ShowSorting", _
			"ProfileEncryption", "CustomTrayIcon", "StartAtStartup", "AlertSize", "AlertDelete", "Monitoring", "CheckUpdates", "Minimized", "ScanSubfolders", "AmbiguitiesCheck", _
			"PlaySound", "AutoStart", "AutoClose", "ShowMonitored", "AlertFailed", "GraduallyHide", "IgnoreInUse", "AutoBackup", "MouseScroll"]
	Local $oINI_Various_Array[7] = [6, "SendToMode", "DupMode", "MasterPassword", "MonitoringTime", "MonitoringSize", "GroupOrder"]
	Local $oPW, $oPW_Code = $G_Global_PasswordKey
	Local $oBackupDirectory = __GetDefault(32) ; Get Default Backup Directory.
	Local $oLogFile = __GetDefault(513) ; Get Default Directory & LogFile File Name.
	Local $oGUI, $oOK, $oCancel, $oMsg, $oMsgBox, $oLogRemove, $oLogView, $oLogWrite, $oMasterPassword, $oShowMasterPassword
	Local $oListView, $oListView_Handle, $oIndex_Selected, $oFolder_Selected, $oMn_Add, $oMn_Edit, $oMn_Remove, $oScanTime, $oScanSize
	Local $oState, $oBk_Backup, $oBk_Restore, $oBk_Remove, $oNewDummy, $oEnterDummy

	$oGUI = GUICreate(__GetLang('OPTIONS', 'Options'), 420, 530, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($oHandle))

	GUICtrlCreateTab(0, 0, 420, 493) ; Create Tab Menu.

	; MAIN Tab:
	GUICtrlCreateTabItem(__GetLang('OPTIONS_TAB_0', 'Main'))
	GUICtrlSetState(-1, $GUI_SHOW) ; Show This Tab At Options Opening.

	GUICtrlCreateGroup(__GetLang('OPTIONS_LABEL_16', 'Interface'), 10, 30, 399, 205)
	$oCheckItems[1] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_0', 'Show target image always on top'), 20, 30 + 15)
	$oCheckItems[2] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_7', 'Lock target image position'), 20, 30 + 15 + 20)
	$oCheckItems[25] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_42', 'Auto-hide target image on the nearest side of the screen'), 20, 30 + 15 + 40)
	$oCheckItems[28] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_43', 'Scroll the mouse wheel to switch profiles'), 20, 30 + 15 + 60)
	$oCheckItems[9] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_11', 'Show progress window during process'), 20, 30 + 15 + 80)
	$oCheckItems[21] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_33', 'Start the process after loading'), 20, 30 + 15 + 100)
	$oCheckItems[22] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_34', 'Close progress window when process is complete'), 20, 30 + 15 + 120)
	$oCheckItems[20] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_30', 'Play sound when process is complete'), 20, 30 + 15 + 140)
	$oCheckItems[24] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_38', 'Show message if process partially fails'), 20, 30 + 15 + 160)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__GetLang('OPTIONS_TAB_1', 'Processing'), 10, 240, 399, 165)
	$oCheckItems[6] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_32', 'Process folders and not scan them'), 20, 240 + 15)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_20', 'Consider folders as files to be processed instead of scan them.'))
	$oCheckItems[18] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_22', 'Scan subfolders and not try to process them'), 20, 240 + 15 + 20)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_11', 'It does not work if main folders are processed and not scanned.'))
	$oCheckItems[7] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_3', 'Ignore unassociated files/folders'), 20, 240 + 15 + 40)
	$oCheckItems[26] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_40', 'Ignore files if in use by other programs'), 20, 240 + 15 + 60)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_23', 'For example to skip files during download or editing.'))
	$oCheckItems[13] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_16', 'Confirm for large loaded files'), 20, 240 + 15 + 80)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_15', 'It requires a confirmation if more than 2 GB of files are loaded.'))
	$oCheckItems[14] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_23', 'Confirm for Delete actions'), 20, 240 + 15 + 100)
	$oCheckItems[19] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_28', 'Select ambiguities checkbox by default'), 20, 240 + 15 + 120)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_18', 'Checkbox that apply selection to all ambiguities of a drop is selected by default.'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__GetLang('OPTIONS_LABEL_5', 'Manage Duplicates'), 10, 410, 399, 72)
	$oCheckItems[8] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_5', 'Use automatic choice for duplicates'), 20, 410 + 15)
	$oComboItems[1] = GUICtrlCreateCombo("", 20, 410 + 15 + 20 + 3, 380, 20, 0x0003)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; MONITORING Tab:
	GUICtrlCreateTabItem(__GetLang('OPTIONS_TAB_4', 'Monitoring'))

	GUICtrlCreateGroup(__GetLang('OPTIONS_LABEL_15', 'Folder Monitoring'), 10, 30, 399, 455)
	$oCheckItems[15] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_36', 'Enable scan of monitored folders'), 20, 30 + 15 + 2, 270, 20)
	GUICtrlCreateLabel(__GetLang('OPTIONS_LABEL_25', 'Monitor folders based on:'), 20, 30 + 15 + 25 + 2, 270, 20)
	$oComboItems[3] = GUICtrlCreateCombo("", 20, 30 + 15 + 45 + 1, 380, 20, 0x0003)
	$oScanTime = GUICtrlCreateInput("", 20, 30 + 15 + 75, 70, 20, 0x2002)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_10', 'Scan monitored folders with a defined time interval.'))
	GUICtrlCreateLabel(__GetLang('OPTIONS_LABEL_19', 'Time interval in seconds'), 20 + 80, 30 + 15 + 75 + 3, 270, 20)
	$oScanSize = GUICtrlCreateInput("", 20, 30 + 15 + 100, 70, 20, 0x2002)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_21', 'Scan monitored folders if bigger than defined size.'))
	GUICtrlCreateLabel(__GetLang('OPTIONS_LABEL_20', 'Minimum size in KB'), 20 + 80, 30 + 15 + 100 + 3, 270, 20)
	$oCheckItems[23] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_35', 'Show progress window for monitored folders'), 20, 30 + 15 + 125 + 1)
	$oListView = GUICtrlCreateListView(__GetLang('MONITORED_FOLDER', 'Monitored Folder') & "|" & __GetLang('ASSOCIATED_PROFILE', 'Associated Profile'), 20, 30 + 15 + 160, 380, 235, BitOR($LVS_NOSORTHEADER, $LVS_REPORT, $LVS_SINGLESEL))
	$oMn_Add = GUICtrlCreateButton(__GetLang('OPTIONS_BUTTON_4', 'Add'), 20, 430 + 15 + 3, 110, 22)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_BUTTON_4', 'Add'))
	$oMn_Edit = GUICtrlCreateButton(__GetLang('OPTIONS_BUTTON_5', 'Edit'), 210 - 55, 430 + 15 + 3, 110, 22)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_BUTTON_5', 'Edit'))
	$oMn_Remove = GUICtrlCreateButton(__GetLang('OPTIONS_BUTTON_3', 'Remove'), 420 - 20 - 110, 430 + 15 + 3, 110, 22)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_BUTTON_3', 'Remove'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; VARIOUS Tab:
	GUICtrlCreateTabItem(__GetLang('OPTIONS_TAB_3', 'Various'))

	GUICtrlCreateGroup(__GetLang('OPTIONS_LABEL_3', 'Usage'), 10, 30, 399, 195)
	$oCheckItems[12] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_14', 'Start on system startup'), 20, 30 + 15)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_3', 'Note that this is a not portable feature.'))
	$oCheckItems[17] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_21', 'Start minimized to system tray'), 20, 30 + 15 + 20)
	$oCheckItems[11] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_13', 'Use profile icon in traybar'), 20, 30 + 15 + 40)
	$oCheckItems[4] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_6', 'Integrate in SendTo menu'), 20, 30 + 15 + 60, 335, 20)
	$oCheckModeItems[1] = GUICtrlCreateCheckbox("", 20 + 340, 30 + 15 + 60, 20, 20)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_1', 'This integration is created at DropIt startup and removed at closing.'), __GetLang('OPTIONS_PORTABLE_MODE', 'Portable Mode'), 0)
	$oCheckModeItems[2] = GUICtrlCreateIcon(@ScriptFullPath, -14, 20 + 360, 30 + 15 + 60 + 1, 16, 16)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_1', 'This integration is created at DropIt startup and removed at closing.'), __GetLang('OPTIONS_PORTABLE_MODE', 'Portable Mode'), 0)
	$oCheckItems[3] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_8', 'Enable multiple instances'), 20, 30 + 15 + 80)
	$oCheckItems[16] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_20', 'Check for updates at DropIt startup'), 20, 30 + 15 + 100)
	GUICtrlCreateLabel(__GetLang('OPTIONS_LABEL_21', 'Process files in groups ordered by') & ":", 20, 30 + 15 + 120 + 6)
	$oComboItems[2] = GUICtrlCreateCombo("", 20, 30 + 15 + 140 + 5, 380, 20, 0x0003)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__GetLang('OPTIONS_LABEL_14', 'Security'), 10, 230, 399, 75)
	$oCheckItems[10] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_12', 'Encrypt profiles at DropIt closing'), 20, 230 + 15)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_6', 'Password will be requested at DropIt startup.'))
	$oMasterPassword = GUICtrlCreateInput("", 20, 230 + 15 + 27, 364, 20, 0x0020)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_LABEL_13', 'Password'))
	$oShowMasterPassword = GUICtrlCreateButton("*", 20 + 364, 230 + 15 + 27, 16, 20)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_2', 'Show/Hide the password'))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__GetLang('OPTIONS_LABEL_2', 'Settings Backup'), 10, 310, 399, 75)
	$oBk_Backup = GUICtrlCreateButton(__GetLang('OPTIONS_BUTTON_1', 'Back up'), 20, 310 + 15 + 3, 110, 22)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_BUTTON_1', 'Back up'))
	$oBk_Restore = GUICtrlCreateButton(__GetLang('OPTIONS_BUTTON_2', 'Restore'), 210 - 55, 310 + 15 + 3, 110, 22)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_BUTTON_2', 'Restore'))
	$oBk_Remove = GUICtrlCreateButton(__GetLang('OPTIONS_BUTTON_3', 'Remove'), 420 - 20 - 110, 310 + 15 + 3, 110, 22)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_BUTTON_3', 'Remove'))
	$oCheckItems[27] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_41', 'Create the automatic backup every 3 days'), 20, 310 + 15 + 29)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(__GetLang('OPTIONS_LABEL_7', 'Activity Log'), 10, 390, 399, 50)
	$oCheckItems[5] = GUICtrlCreateCheckbox(__GetLang('OPTIONS_CHECKBOX_1', 'Write log file'), 20, 390 + 15 + 3, 220, 20)
	$oLogRemove = GUICtrlCreateIcon(@ScriptFullPath, -15, 20 + 246, 390 + 15 + 5, 16, 16)
	GUICtrlSetTip(-1, __GetLang('OPTIONS_TIP_17', 'Remove log file'))
	$oLogView = GUICtrlCreateButton(__GetLang('OPTIONS_BUTTON_0', 'View'), 420 - 20 - 110, 390 + 15 + 2, 110, 22)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateTabItem("") ; Close Tab Menu.

	; Checkbox Settings:
	For $A = 1 To $oINI_TrueOrFalse_Array[0]
		If $oINI_TrueOrFalse_Array[$A] = "" Then
			ContinueLoop
		EndIf
		If __Is($oINI_TrueOrFalse_Array[$A], $oINI) Then
			GUICtrlSetState($oCheckItems[$A], $GUI_CHECKED)
		EndIf
	Next

	; Combo Settings:
	$oGroup[1] = __GetLang('DUPLICATE_MODE_0', 'Overwrite') & "|" & __GetLang('DUPLICATE_MODE_1', 'Overwrite if newer') & "|" & _
			__GetLang('DUPLICATE_MODE_7', 'Overwrite if different size') & "|" & __GetLang('DUPLICATE_MODE_3', 'Rename as "Name 01"') & "|" & _
			__GetLang('DUPLICATE_MODE_4', 'Rename as "Name_01"') & "|" & __GetLang('DUPLICATE_MODE_5', 'Rename as "Name (01)"') & "|" & _
			__GetLang('DUPLICATE_MODE_6', 'Skip')
	$oCurrent[1] = __GetDuplicateMode(IniRead($oINI, $G_Global_GeneralSection, "DupMode", "Overwrite1"), 1)

	$oGroup[2] = __GetLang('FILE_PATH', 'File Path') & "|" & __GetLang('FILE_NAME', 'File Name') & "|" & __GetLang('FILE_EXT', 'Extension') & "|" & __GetLang('FILE_SIZE', 'Size') & "|" & _
			__GetLang('DATE_CREATED', 'Date Created') & "|" & __GetLang('DATE_MODIFIED', 'Date Modified') & "|" & __GetLang('DATE_OPENED', 'Date Opened')
	$oCurrent[2] = __GetOrderMode(IniRead($oINI, $G_Global_GeneralSection, "GroupOrder", "Path"), 1)

	$oGroup[3] = __GetLang('MONITOR_MODE_1', 'Time interval') & "|" & __GetLang('MONITOR_MODE_2', 'Immediate on-change') & "|" & __GetLang('MONITOR_MODE_3', 'Time interval + Immediate on-change')
	$oCurrent[3] = __GetMonitorMode(IniRead($oINI, $G_Global_GeneralSection, "Monitoring", 0), 1)

	For $A = 1 To $oComboItems[0]
		GUICtrlSetData($oComboItems[$A], $oGroup[$A], $oCurrent[$A])
	Next

	; Lock Target Image Settings:
	$oState = $GUI_ENABLE
	If GUICtrlRead($oCheckItems[2]) = 1 Then
		$oState = $GUI_DISABLE
	EndIf
	GUICtrlSetState($oCheckItems[25], $oState)

	; SendTo Integration Settings:
	$oState = $GUI_DISABLE
	If GUICtrlRead($oCheckItems[4]) = 1 Then
		$oState = $GUI_ENABLE
	EndIf
	For $A = 1 To 2
		GUICtrlSetState($oCheckModeItems[$A], $oState)
	Next
	If IniRead($oINI, $G_Global_GeneralSection, "SendToMode", "Portable") = "Portable" Then
		GUICtrlSetState($oCheckModeItems[1], $GUI_CHECKED)
	Else
		GUICtrlSetState($oCheckModeItems[1], $GUI_UNCHECKED)
	EndIf

	; Log Settings:
	If FileExists($oLogFile[1][0] & $oLogFile[2][0]) = 0 Then
		GUICtrlSetState($oLogRemove, $GUI_DISABLE)
		GUICtrlSetState($oLogView, $GUI_DISABLE)
	EndIf

	; Process Settings:
	$oState = $GUI_DISABLE
	If GUICtrlRead($oCheckItems[9]) = 1 Then
		$oState = $GUI_ENABLE
	EndIf
	GUICtrlSetState($oCheckItems[21], $oState)
	GUICtrlSetState($oCheckItems[22], $oState)

	; Folder Association Settings:
	$oState = $GUI_ENABLE
	If GUICtrlRead($oCheckItems[6]) = 1 Then
		$oState = $GUI_DISABLE
	EndIf
	GUICtrlSetState($oCheckItems[18], $oState)

	; Backup Settings:
	For $A = $oBk_Backup To $oBk_Restore ; Disable Buttons If 7-Zip Is Missing.
		If FileExists($G_Global_7ZipPath) = 0 Then
			GUICtrlSetState($A, $GUI_DISABLE)
		EndIf
	Next
	If FileExists($oBackupDirectory) = 0 Then
		GUICtrlSetState($oBk_Remove, $GUI_DISABLE)
	EndIf

	; Duplicate Mode Settings:
	$oState = $GUI_DISABLE
	If GUICtrlRead($oCheckItems[8]) = 1 Then
		$oState = $GUI_ENABLE
	EndIf
	GUICtrlSetState($oComboItems[1], $oState)

	; Security Settings:
	$oState = $GUI_DISABLE
	If GUICtrlRead($oCheckItems[10]) = 1 Then
		$oState = $GUI_ENABLE
	EndIf
	GUICtrlSetState($oMasterPassword, $oState)
	GUICtrlSetState($oShowMasterPassword, $oState)
	$oPW = IniRead($oINI, $G_Global_GeneralSection, "MasterPassword", "")
	If $oPW <> "" Then
		GUICtrlSetData($oMasterPassword, __StringEncrypt(0, $oPW, $oPW_Code))
	EndIf

	; Monitoring Settings:
	$oState = $GUI_DISABLE
	If Number(IniRead($oINI, $G_Global_GeneralSection, "Monitoring", 0)) > 0 Then
		GUICtrlSetState($oCheckItems[15], $GUI_CHECKED)
		$oState = $GUI_ENABLE
	EndIf
	GUICtrlSetState($oComboItems[3], $oState)
	GUICtrlSetState($oScanTime, $oState)
	GUICtrlSetState($oCheckItems[23], $oState)
	GUICtrlSetState($oListView, $oState)
	GUICtrlSetState($oMn_Add, $oState)
	GUICtrlSetState($oMn_Edit, $oState)
	GUICtrlSetState($oMn_Remove, $oState)
	$oState = IniRead($oINI, $G_Global_GeneralSection, "MonitoringTime", "")
	If $oState = "" Then
		$oState = 30
	EndIf
	GUICtrlSetData($oScanTime, $oState)
	$oState = IniRead($oINI, $G_Global_GeneralSection, "MonitoringSize", "")
	If $oState = "" Then
		$oState = 0
	EndIf
	GUICtrlSetData($oScanSize, $oState)

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

	$oOK = GUICtrlCreateButton(__GetLang('OK', 'OK'), 210 - 30 - 120, 498, 120, 26)
	$oCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 210 + 30, 498, 120, 26)
	GUICtrlSetState($oOK, $GUI_DEFBUTTON)

	$Global_ListViewIndex = -1 ; Set As No Item Selected.
	GUIRegisterMsg($WM_NOTIFY, "_WM_NOTIFY")
	GUISetState(@SW_SHOW)

	Local $oHotKeys[3][2] = [["^n", $oMn_Add],["^r", $oMn_Remove],["{ENTER}", $oMn_Edit]]
	GUISetAccelerators($oHotKeys)

	_WinAPI_EmptyWorkingSet() ; Reduce Memory Usage Of DropIt.
	While 1
		$oIndex_Selected = $Global_ListViewIndex

		If $Global_ListViewFolders_ItemChange <> -1 Then
			_Monitored_SetState($oINI, _GUICtrlListView_GetItemText($oListView_Handle, $Global_ListViewFolders_ItemChange), _GUICtrlListView_GetItemText($oListView_Handle, $Global_ListViewFolders_ItemChange, 1), _GUICtrlListView_GetItemChecked($oListView_Handle, $Global_ListViewFolders_ItemChange))
			$Global_ListViewFolders_ItemChange = -1
		EndIf

		; Update Monitoring Buttons State:
		If $oIndex_Selected = -1 Then ; Nothing Selected.
			If GUICtrlGetState($oMn_Edit) = 80 Then
				GUICtrlSetState($oMn_Edit, 144) ; $GUI_DISABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($oMn_Remove) = 80 Then
				GUICtrlSetState($oMn_Remove, 144) ; $GUI_DISABLE + $GUI_SHOW.
			EndIf
		ElseIf GUICtrlRead($oCheckItems[15]) = $GUI_CHECKED Then ; Monitoring Enabled.
			If GUICtrlGetState($oMn_Edit) > 80 Then
				GUICtrlSetState($oMn_Edit, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
			If GUICtrlGetState($oMn_Remove) > 80 Then
				GUICtrlSetState($oMn_Remove, 80) ; $GUI_ENABLE + $GUI_SHOW.
			EndIf
		EndIf
		$oState = $GUI_DISABLE
		If GUICtrlRead($oCheckItems[15]) = $GUI_CHECKED And (GUICtrlRead($oComboItems[3]) = __GetLang('MONITOR_MODE_1', 'Time interval') Or GUICtrlRead($oComboItems[3]) = __GetLang('MONITOR_MODE_3', 'Time interval + Immediate on-change')) Then
			$oState = $GUI_ENABLE
		EndIf
		If BitAND(GUICtrlGetState($oScanSize), $oState) <> $oState Then
			GUICtrlSetState($oScanTime, $oState)
			GUICtrlSetState($oScanSize, $oState)
		EndIf


		$oMsg = GUIGetMsg()

		Switch $oMsg
			Case $GUI_EVENT_CLOSE, $oCancel
				SetError(1, 0, 0)
				ExitLoop

			Case $oCheckModeItems[2]
				$oState = $GUI_CHECKED
				If GUICtrlRead($oCheckModeItems[1]) = 1 Then
					$oState = $GUI_UNCHECKED
				EndIf
				GUICtrlSetState($oCheckModeItems[1], $oState)

			Case $oCheckItems[2] ; Lock Target Image Checkbox.
				$oState = $GUI_ENABLE
				If GUICtrlRead($oCheckItems[2]) = 1 Then
					$oState = $GUI_DISABLE
					GUICtrlSetState($oCheckItems[25], $GUI_UNCHECKED)
				EndIf
				GUICtrlSetState($oCheckItems[25], $oState)

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
					GUICtrlSetState($oCheckItems[18], $GUI_UNCHECKED)
				EndIf
				GUICtrlSetState($oCheckItems[18], $oState)

			Case $oCheckItems[8] ; Duplicate Mode Checkbox.
				$oState = $GUI_DISABLE
				If GUICtrlRead($oCheckItems[8]) = 1 Then
					$oState = $GUI_ENABLE
				EndIf
				GUICtrlSetState($oComboItems[1], $oState)

			Case $oCheckItems[9] ; Process Checkbox.
				$oState = $GUI_ENABLE
				If GUICtrlRead($oCheckItems[9]) <> 1 Then
					$oState = $GUI_DISABLE
					GUICtrlSetState($oCheckItems[21], $GUI_CHECKED)
					GUICtrlSetState($oCheckItems[22], $GUI_CHECKED)
				EndIf
				GUICtrlSetState($oCheckItems[21], $oState)
				GUICtrlSetState($oCheckItems[22], $oState)

			Case $oCheckItems[10] ; Security Checkbox.
				$oState = $GUI_DISABLE
				If GUICtrlRead($oCheckItems[10]) = 1 Then
					$oState = $GUI_ENABLE
				EndIf
				GUICtrlSetState($oMasterPassword, $oState)
				GUICtrlSetState($oShowMasterPassword, $oState)

			Case $oCheckItems[15] ; Monitoring Checkbox.
				$oState = $GUI_DISABLE
				If GUICtrlRead($oCheckItems[15]) = $GUI_CHECKED Then
					$oState = $GUI_ENABLE
				EndIf
				GUICtrlSetState($oComboItems[3], $oState)
				GUICtrlSetState($oCheckItems[23], $oState)
				GUICtrlSetState($oListView, $oState)
				GUICtrlSetState($oMn_Add, $oState)
				GUICtrlSetState($oMn_Edit, $oState)
				GUICtrlSetState($oMn_Remove, $oState)
				If $oState = $GUI_ENABLE And Not (GUICtrlRead($oComboItems[3]) = __GetLang('MONITOR_MODE_1', 'Time interval') Or GUICtrlRead($oComboItems[3]) = __GetLang('MONITOR_MODE_3', 'Time interval + Immediate on-change')) Then
					$oState = $GUI_DISABLE
				EndIf
				GUICtrlSetState($oScanTime, $oState)
				GUICtrlSetState($oScanSize, $oState)

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
					$oMsgBox = MsgBox(0x4, __GetLang('OPTIONS_MONITORED_MSGBOX_0', 'Delete monitored folder'), __GetLang('OPTIONS_MONITORED_MSGBOX_1', 'Are you sure to remove this monitored folder from the list?') & @LF & @LF & $oFolder_Selected, 0, __OnTop($oGUI))
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

			Case $oShowMasterPassword
				__ShowPassword($oMasterPassword)

			Case $oOK
				__IniWriteEx($oINI, $G_Global_GeneralSection, $oINI_Various_Array[2], __GetDuplicateMode(GUICtrlRead($oComboItems[1])))
				__IniWriteEx($oINI, $G_Global_GeneralSection, $oINI_Various_Array[6], __GetOrderMode(GUICtrlRead($oComboItems[2])))

				If __Is("CreateLog", $oINI) And GUICtrlRead($oCheckItems[5]) <> 1 And FileExists($oLogFile[1][0] & $oLogFile[2][0]) Then
					__Log_Write("===== " & __GetLang('LOG_DISABLED', 'Log Disabled') & " =====")
				EndIf
				If __Is("CreateLog", $oINI) = 0 And GUICtrlRead($oCheckItems[5]) = 1 Then
					$oLogWrite = 1 ; Needed To Write "Log Enabled" After Log Activation.
				EndIf

				If _GUICtrlListView_GetItemCount($oListView_Handle) = 0 Then
					GUICtrlSetState($oCheckItems[15], $GUI_UNCHECKED) ; Disable Monitoring If ListView Is Empty.
				EndIf

				For $A = 1 To $oINI_TrueOrFalse_Array[0]
					$oState = "False"
					If $oINI_TrueOrFalse_Array[$A] = "" Then
						ContinueLoop
					EndIf
					If GUICtrlRead($oCheckItems[$A]) = 1 Then
						$oState = "True"
					EndIf
					__IniWriteEx($oINI, $G_Global_GeneralSection, $oINI_TrueOrFalse_Array[$A], $oState)
				Next

				If GUICtrlRead($oCheckItems[15]) = $GUI_CHECKED Then
					__IniWriteEx($oINI, $G_Global_GeneralSection, 'Monitoring', __GetMonitorMode(GUICtrlRead($oComboItems[3])))
				Else
					__IniWriteEx($oINI, $G_Global_GeneralSection, 'Monitoring', 0)
				EndIf

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
				__IniWriteEx($oINI, $G_Global_GeneralSection, $oINI_Various_Array[1], $oState)

				__IniWriteEx($oINI, $G_Global_GeneralSection, $oINI_Various_Array[4], GUICtrlRead($oScanTime))
				__IniWriteEx($oINI, $G_Global_GeneralSection, $oINI_Various_Array[5], GUICtrlRead($oScanSize))
				_SetFeaturesWithTimer($oINI) ; Load Global Monitoring Configuration.

				$oPW = ""
				If StringIsSpace(GUICtrlRead($oMasterPassword)) = 0 And GUICtrlRead($oMasterPassword) <> "" Then
					$oPW = __StringEncrypt(1, GUICtrlRead($oMasterPassword), $oPW_Code)
				EndIf
				__IniWriteEx($oINI, $G_Global_GeneralSection, $oINI_Various_Array[3], $oPW)
				If $oPW = "" And GUICtrlRead($oCheckItems[10]) = 1 Then
					$oMsgBox = MsgBox(0x4, __GetLang('OPTIONS_ENCRYPTION_MSGBOX_0', 'Encryption Problem'), __GetLang('OPTIONS_ENCRYPTION_MSGBOX_1', 'Profile encryption needs a password. Do you wish to disable it?'), 0, __OnTop($oGUI))
					If $oMsgBox <> 6 Then
						ContinueLoop
					EndIf
					If GUICtrlRead($oMasterPassword) = "" Then
						__IniWriteEx($oINI, $G_Global_GeneralSection, $oINI_TrueOrFalse_Array[10], "False")
					EndIf
				EndIf
				ExitLoop

		EndSwitch
	WEnd
	GUIDelete($oGUI)

	__SetCurrentPosition() ; Set Current Coordinates/Position Of DropIt.
	__OnTop($Global_GUI_1) ; Set GUI "OnTop" If True.
	__GUIInBounds($Global_GUI_1) ; Move In Screen Bounds If Needed.

	Return 1
EndFunc   ;==>_Options

Func _ExitEvent()
	GUISetState(@SW_HIDE, $Global_GUI_1)
	Local $eINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $eNumberInstances = __GetNumberInstances()

	If $Global_ScriptRefresh = 0 Then ; To Restart DropIt With A Possible Changed Position.
		__SetCurrentPosition() ; Set Current Coordinates/Position Of DropIt.
	EndIf
	If $G_Global_IsMultipleInstance Then
		__SetMultipleInstances("-")
	EndIf
	__Log_Write("===== " & __GetLang('DROPIT_CLOSED', 'DropIt Closed') & " =====")

	If $eNumberInstances <= 1 Then ; Check The Number Of Instances And Perform If This Is The Last One.
		If IniRead($eINI, $G_Global_GeneralSection, "SendToMode", "Portable") = "Portable" Then
			__SendTo_Uninstall()
		EndIf
		If __Is("ProfileEncryption", $eINI) Then
			__EncryptionFolder(0)
		EndIf
		_WM_COPYDATA_Shutdown()
	EndIf

	_GDIPlus_Shutdown()
	Exit
EndFunc   ;==>_ExitEvent
#EndRegion >>>>> General Functions <<<<<

#Region >>>>> Monitored Functions <<<<<
Func _Monitored_Edit_GUI($mHandle, $mINI, $mListView, $mIndex = -1, $mFolder = -1)
	Local $mGUI, $mSave, $mCancel, $mInput_Folder, $mButton_Folder, $mButton_Abbreviations, $mCombo_Profile, $mCurrent_Folder, $mAbbreviation
	Local $mProfileName = __IsProfile(-1, 3) ; Get Current Profile Name.

	If $mIndex <> -1 Then
		$mProfileName = _GUICtrlListView_GetItemText($mListView, $mIndex, 1)
	EndIf
	If $mFolder = -1 Then
		$mFolder = ""
	EndIf

	$mGUI = GUICreate(__GetLang('MONITORED_FOLDER', 'Monitored Folder'), 340, 125, -1, -1, -1, $WS_EX_TOOLWINDOW, __OnTop($mHandle))

	$mInput_Folder = GUICtrlCreateInput($mFolder, 10, 15 + 2, 239, 22)
	GUICtrlSetTip($mInput_Folder, __GetLang('MONITORED_FOLDER_TIP_0', 'Drag and drop the folder that will be monitored.'))
	GUICtrlSetState($mInput_Folder, $GUI_DROPACCEPTED)
	$mButton_Folder = GUICtrlCreateButton("S", 10 + 243, 15, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Folder, __GetLang('SEARCH', 'Search'))
	GUICtrlSetImage($mButton_Folder, @ScriptFullPath, -6, 0)
	$mButton_Abbreviations = GUICtrlCreateButton("A", 10 + 284, 15, 36, 25, $BS_ICON)
	GUICtrlSetTip($mButton_Abbreviations, __GetLang('MANAGE_EDIT_MSGBOX_8', 'Abbreviations'))
	GUICtrlSetImage($mButton_Abbreviations, @ScriptFullPath, -8, 0)
	$mCombo_Profile = GUICtrlCreateCombo("", 10, 15 + 35, 320, 22, 0x0003)
	GUICtrlSetTip($mCombo_Profile, __GetLang('MONITORED_FOLDER_TIP_1', 'Select the group of associations to use on this folder.'))
	GUICtrlSetData($mCombo_Profile, __ProfileList_Combo(), $mProfileName)

	$mSave = GUICtrlCreateButton(__GetLang('SAVE', 'Save'), 170 - 35 - 75, 90, 75, 24)
	$mCancel = GUICtrlCreateButton(__GetLang('CANCEL', 'Cancel'), 170 + 35, 90, 75, 24)
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
				If __StringIsValid($mCurrent_Folder, '|<>=') = 0 Then
					MsgBox(0x30, __GetLang('MONITORED_FOLDER_MSGBOX_0', 'Folder Error'), __GetLang('MONITORED_FOLDER_MSGBOX_1', 'You must specify a valid directory.') & @LF & __GetLang('MONITORED_FOLDER_MSGBOX_3', 'The path cannot includes "<", ">", "|", "=" characters.'), 0, __OnTop($mGUI))
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

			Case $mButton_Abbreviations
				$mAbbreviation = _Monitored_ContextMenu_Abbreviations($mButton_Abbreviations, $mProfileName, $mGUI)
				If $mAbbreviation <> -1 Then
					__InsertText($mInput_Folder, "%" & $mAbbreviation & "%")
				EndIf
				_WinAPI_SetFocus(GUICtrlGetHandle($mInput_Folder))

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
EndFunc   ;==>_Monitored_Update

Func _Monitored_ContextMenu_Abbreviations($mButton_Abbreviations, $mProfile, $mHandle = -1)
	Local $mGroupCurrent[14][3] = [ _
			[13, 0, 0], _
			["CurrentDate", __GetLang('ENV_VAR_0', 'current date') & ' ["' & @YEAR & "-" & @MON & "-" & @MDAY & '"]'], _
			["CurrentYear", __GetLang('ENV_VAR_30', 'current year') & ' ["' & @YEAR & '"]'], _
			["CurrentMonth", __GetLang('ENV_VAR_31', 'current month') & ' ["' & @MON & '"]'], _
			["CurrentMonthName", __GetLang('ENV_VAR_31', 'current month') & ' ["' & __Locale_MonthName(@MON, 0) & '"]'], _
			["CurrentMonthShort", __GetLang('ENV_VAR_31', 'current month') & ' ["' & __Locale_MonthName(@MON, 1) & '"]'], _
			["CurrentWeek", __GetLang('ENV_VAR_95', 'current week') & ' ["' & _WeekNumberISO() & '"]'], _
			["CurrentDay", __GetLang('ENV_VAR_32', 'current day') & ' ["' & @MDAY & '"]'], _
			["CurrentDayName", __GetLang('ENV_VAR_32', 'current day') & ' ["' & __Locale_DayName(_DateToDayOfWeekISO(@YEAR, @MON, @MDAY), 0) & '"]'], _
			["CurrentDayShort", __GetLang('ENV_VAR_32', 'current day') & ' ["' & __Locale_DayName(_DateToDayOfWeekISO(@YEAR, @MON, @MDAY), 1) & '"]'], _
			["CurrentTime", __GetLang('ENV_VAR_1', 'current time') & ' ["' & @HOUR & "." & @MIN & '"]'], _
			["CurrentHour", __GetLang('ENV_VAR_33', 'current hour') & ' ["' & @HOUR & '"]'], _
			["CurrentMinute", __GetLang('ENV_VAR_34', 'current minute') & ' ["' & @MIN & '"]'], _
			["CurrentSecond", __GetLang('ENV_VAR_35', 'current second') & ' ["' & @SEC & '"]']]
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
	Local $mGroupOthers[5][3] = [ _
			[4, 0, 0], _
			["ComputerName", __GetLang('ENV_VAR_78', 'computer name') & ' ["' & @ComputerName & '"]'], _
			["PortableDrive", __GetLang('ENV_VAR_14', 'drive letter of DropIt') & ' ["' & StringLeft(@ScriptFullPath, 2) & '"]'], _
			["ProfileName", __GetLang('ENV_VAR_28', 'current DropIt profile name') & ' ["' & $mProfile & '"]'], _
			["UserName", __GetLang('ENV_VAR_79', 'system user name') & ' ["' & @UserName & '"]']]
	Local $mMenuGroup[4][3] = [ _
			[3, 0, 0], _
			[__GetLang('ENV_VAR_TAB_5', 'Current'), $mGroupCurrent], _
			[__GetLang('ENV_VAR_TAB_14', 'System'), $mGroupFolders], _
			[__GetLang('ENV_VAR_TAB_15', 'Others'), $mGroupOthers]]

	Local $mNumberAbbreviations = $mGroupCurrent[0][0] + $mGroupFolders[0][0] + $mGroupOthers[0][0]

	Return _ContextMenuAbbreviations($mButton_Abbreviations, $mMenuGroup, $mNumberAbbreviations, "Monitored", $mHandle)
EndFunc   ;==>_Monitored_ContextMenu_Abbreviations

Func _Monitored_AddRemoveDropped($mFolders, $mINI, $mRemove = 0)
	#cs
		Description: Add Or Remove Dropped Monitored Folders.
		Return: 1
	#ce
	If IsArray($mFolders) = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	Local $mCurrentProfile = __IsProfile(-1, 3) ; Get Current Profile Name.
	For $A = 1 To $mFolders[0]
		If _WinAPI_PathIsDirectory($mFolders[$A]) Then
			If $mRemove Then ; Remove Monitored Folder.
				If MsgBox(0x4, __GetLang('OPTIONS_MONITORED_MSGBOX_0', 'Delete monitored folder'), __GetLang('OPTIONS_MONITORED_MSGBOX_1', 'Are you sure to remove this monitored folder from the list?') & @LF & @LF & $mFolders[$A], 0, __OnTop($Global_GUI_1)) = 6 Then
					IniDelete($mINI, "MonitoredFolders", $mFolders[$A])
				EndIf
			Else ; Add Monitored Folder.
				If __StringIsValid($mFolders[$A], '|<>=') = 0 Then
					MsgBox(0x30, __GetLang('MONITORED_FOLDER_MSGBOX_0', 'Folder Error'), __GetLang('MONITORED_FOLDER_MSGBOX_1', 'You must specify a valid directory.') & @LF & __GetLang('MONITORED_FOLDER_MSGBOX_3', 'The path cannot includes "<", ">", "|", "=" characters.'), 0, __OnTop($Global_GUI_1))
					ContinueLoop
				EndIf
				__IniWriteEx($mINI, "MonitoredFolders", $mFolders[$A], $mCurrentProfile & "|Enabled")
				MsgBox(0x40, __GetLang('MONITORED_FOLDER_MSGBOX_4', 'Added Monitored Folder'), __GetLang('MONITORED_FOLDER_MSGBOX_5', 'This is a new Monitored Folder:') & @LF & $mFolders[$A], 0, __OnTop($Global_GUI_1))
			EndIf
		EndIf
	Next

	Return 1
EndFunc   ;==>_Monitored_AddRemoveDropped

Func _Monitored_SetState($mINI, $mFolder, $mProfile, $mState)
	#cs
		Description: Enable/Disable The Monitored Folder.
		Return: 1
	#ce
	If $mState Then
		$mState = $G_Global_StateEnabled
	Else
		$mState = $G_Global_StateDisabled
	EndIf
	__IniWriteEx($mINI, "MonitoredFolders", $mFolder, $mProfile & "|" & $mState)

	Return 1
EndFunc   ;==>_Monitored_SetState
#EndRegion >>>>> Monitored Functions <<<<<

#Region >>>>> TrayMenu Functions <<<<<
Func _TrayMenu_Create()
	Local $tCurrentProfile = __GetCurrentProfile() ; Get Current Profile From The Settings INI File.
	Local $tCurrentLanguage = __GetCurrentLanguage() ; Get Current Language From The Settings INI File.
	Local $tLanguageDir = __GetDefault(1024) ; Get Default Language Directory.
	Local $tTrayMenu = _TrayMenu_Delete() ; Delete The Current TrayMenu Items.
	Local $tProfileList = __ProfileList_Get() ; Get Array Of All Profiles.
	Local $tLanguageList = __LangList_Get() ; Get Array Of All Profiles.

	$tTrayMenu[1][0] = TrayCreateItem(__GetLang('ASSOCIATIONS', 'Associations'), -1, 0)
	$tTrayMenu[2][0] = TrayCreateItem("", -1, 1)
	$tTrayMenu[3][0] = TrayCreateMenu(__GetLang('PROFILES', 'Profiles'), -1, 2)
	$tTrayMenu[3][1] = $tProfileList[0] ; Save Number Of Profiles.
	$tTrayMenu[4][0] = TrayCreateMenu(__GetLang('LANGUAGES', 'Languages'), -1, 3)
	$tTrayMenu[4][1] = $tLanguageList[0] ; Save Number Of Language Files.
	$tTrayMenu[5][0] = TrayCreateItem(__GetLang('OPTIONS', 'Options'), -1, 4)
	$tTrayMenu[6][0] = TrayCreateItem(__GetLang('SHOW', 'Show'), -1, 5)
	$tTrayMenu[7][0] = TrayCreateItem(__GetLang('GUIDE', 'Guide'), -1, 6)
	If FileExists($G_Global_GuidePath) = 0 Then
		TrayItemSetState($tTrayMenu[7][0], $TRAY_DISABLE)
	EndIf
	$tTrayMenu[8][0] = TrayCreateItem(__GetLang('ABOUT', 'About') & "...", -1, 7)
	$tTrayMenu[9][0] = TrayCreateItem("", -1, 8)
	$tTrayMenu[10][0] = TrayCreateItem(__GetLang('EXIT', 'Exit'), -1, 9)

	$tTrayMenu[11][0] = TrayCreateItem(__GetLang('CUSTOMIZE', 'Customize'), $tTrayMenu[3][0], 0)
	$tTrayMenu[12][0] = TrayCreateItem("", $tTrayMenu[3][0], 1)

	Local $tMenuHandle = TrayItemGetHandle(0) ; Get Main Menu Handle.
	__SetItemImage("ASSO", 0, $tMenuHandle, 2, 1)
	__SetItemImage("PROF", 2, $tMenuHandle, 2, 1)
	__SetItemImage("FLAGS", 3, $tMenuHandle, 2, 1)
	__SetItemImage("OPT", 4, $tMenuHandle, 2, 1)
	__SetItemImage("SHOW", 5, $tMenuHandle, 2, 1)
	__SetItemImage("GUIDE", 6, $tMenuHandle, 2, 1)
	__SetItemImage("INFO", 7, $tMenuHandle, 2, 1)
	__SetItemImage("CLOSE", 9, $tMenuHandle, 2, 1)
	__SetItemImage("CUST", 0, $tTrayMenu[3][0], 1, 1)

	$tTrayMenu[0][0] = 12 ; To Correctly Restore Counter Of Only Main Items.
	ReDim $tTrayMenu[$tTrayMenu[0][0] + $tTrayMenu[3][1] + 1][$tTrayMenu[0][1]]
	For $A = 1 To $tProfileList[0]
		$tTrayMenu[0][0] += 1
		$tTrayMenu[$tTrayMenu[0][0]][0] = TrayCreateItem($tProfileList[$A], $tTrayMenu[3][0], $A + 1, 1)
		__SetItemImage(__IsProfile($tProfileList[$A], 2), $A + 1, $tTrayMenu[3][0], 1, 0, 20, 20)
		$tTrayMenu[$tTrayMenu[0][0]][1] = $tProfileList[$A]
		TrayItemSetOnEvent($tTrayMenu[$tTrayMenu[0][0]][0], "_ProfileEvent")
		If $tProfileList[$A] = $tCurrentProfile Then
			TrayItemSetState($tTrayMenu[$tTrayMenu[0][0]][0], 1)
		EndIf
	Next
	ReDim $tTrayMenu[$tTrayMenu[0][0] + $tTrayMenu[4][1] + 1][$tTrayMenu[0][1]]
	For $A = 1 To $tLanguageList[0]
		$tTrayMenu[0][0] += 1
		$tTrayMenu[$tTrayMenu[0][0]][0] = TrayCreateItem($tLanguageList[$A], $tTrayMenu[4][0], $A - 1, 1)
		__SetItemImage($tLanguageDir & $tLanguageList[$A] & ".gif", $A - 1, $tTrayMenu[4][0], 1, 0, 18, 12)
		$tTrayMenu[$tTrayMenu[0][0]][1] = $tLanguageList[$A]
		TrayItemSetOnEvent($tTrayMenu[$tTrayMenu[0][0]][0], "_LanguageEvent")
		If $tLanguageList[$A] = $tCurrentLanguage Then
			TrayItemSetState($tTrayMenu[$tTrayMenu[0][0]][0], 1)
		EndIf
	Next

	TrayItemSetOnEvent($tTrayMenu[1][0], "_ManageEvent")
	TrayItemSetOnEvent($tTrayMenu[5][0], "_OptionsEvent")
	TrayItemSetOnEvent($tTrayMenu[6][0], "_TrayMenu_ShowGUI")
	TrayItemSetOnEvent($tTrayMenu[7][0], "_HelpEvent")
	TrayItemSetOnEvent($tTrayMenu[8][0], "_HelpEvent")
	TrayItemSetOnEvent($tTrayMenu[10][0], "_ExitEvent")
	TrayItemSetOnEvent($tTrayMenu[11][0], "_CustomizeEvent")
	TraySetOnEvent(-13, "_TrayMenu_ShowGUI")

	$Global_TrayMenu = $tTrayMenu

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
	_Refresh(1)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_CustomizeEvent

Func _HelpEvent()
	Local $hTrayMenu = $Global_TrayMenu
	Switch @TRAY_ID
		Case $hTrayMenu[7][0]
			If FileExists($G_Global_GuidePath) Then
				__ShellExecuteOnTop($G_Global_GuidePath)
			EndIf

		Case $hTrayMenu[8][0]
			_About()

	EndSwitch

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_HelpEvent

Func _LanguageEvent()
	Local $pTrayMenu = $Global_TrayMenu
	For $A = 12 + $Global_TrayMenu[3][1] To 12 + $Global_TrayMenu[3][1] + $pTrayMenu[4][1]
		If @TRAY_ID = $pTrayMenu[$A][0] Then
			__SetCurrentLanguage($pTrayMenu[$A][1]) ; Set The Selected Language To The Settings INI File.
			ExitLoop
		EndIf
	Next
	_Refresh()

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_LanguageEvent

Func _ManageEvent()
	_Manage_GUI($Global_GUI_1) ; Open Manage GUI.
	_Refresh()

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_ManageEvent

Func _OptionsEvent()
	_Options($Global_GUI_1) ; Open Options GUI.
	_Refresh(1)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_OptionsEvent

Func _ProfileEvent()
	Local $pTrayMenu = $Global_TrayMenu
	For $A = 12 To 12 + $pTrayMenu[3][1]
		If @TRAY_ID = $pTrayMenu[$A][0] Then
			__Log_Write(__GetLang('MAIN_TIP_1', 'Changed profile to'), $pTrayMenu[$A][1])
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
Func _WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
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
					_Manage_Populate($Global_ListViewRules, GUICtrlRead($cIDFrom))
				Case $CBN_SELCHANGE
					$Global_ListViewIndex = -1
					$Global_ListViewRules_ComboBoxChange = 1
					_Manage_Populate($Global_ListViewRules, GUICtrlRead($cIDFrom))
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_COMMAND

Func _WM_CONTEXTMENU($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam, $ilParam
	If $Global_MenuDisable Then
		Return 0
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_CONTEXTMENU

Func _WM_GETMINMAXINFO($hWnd, $iMsg, $iwParam, $ilParam) ; Enable The GUI From Being Dragged To A Certain Size.
	#forceref $hWnd, $iMsg, $iwParam
	Local $gStructure = DllStructCreate("int;int;int;int;int;int;int;int;int;int", $ilParam)
	DllStructSetData($gStructure, 7, $Global_ResizeMinWidth) ; Min Width.
	DllStructSetData($gStructure, 8, $Global_ResizeMinHeight) ; Min Height.
	DllStructSetData($gStructure, 9, $Global_ResizeMaxWidth) ; Max Width.
	DllStructSetData($gStructure, 10, $Global_ResizeMaxHeight) ; Max Height.
	Return 0
EndFunc   ;==>_WM_GETMINMAXINFO

Func _WM_HSCROLL($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $hSlider = $Global_Slider
	Local $hSliderLabel = $Global_SliderLabel
	Local $hSlider_Handle = GUICtrlGetHandle($hSlider)
	If $ilParam = $hSlider_Handle Then
		Local $hRead = GUICtrlRead($hSlider) & "%"
		GUICtrlSetData($hSliderLabel, $hRead)
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_HSCROLL

Func _WM_LBUTTONDBLCLK($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $ilParam
	If _WinAPI_HiWord($iwParam) = 1 Then ; If A Double Click Is Detected.
		_TrayMenu_ShowTray() ; Show The TrayMenu.
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_LBUTTONDBLCLK

Func _WM_MOUSEWHEEL($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $ilParam
	Local $mWheel = 1 ; Down.
	If _WinAPI_HiWord($iwParam) > 0 Then
		$mWheel = 2 ; Up.
	EndIf
	$Global_Wheel = $mWheel
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_MOUSEWHEEL

Func _WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $tNMLISTVIEW
	Local $nListViewProfiles = $Global_ListViewProfiles
	Local $nListViewRules = $Global_ListViewRules
	Local $nListViewFolders = $Global_ListViewFolders
	Local $nListViewProcess = $Global_ListViewProcess
	Local $nListViewCreateGallery = $Global_ListViewCreateGallery
	Local $nListViewCreateList = $Global_ListViewCreateList

	If IsHWnd($nListViewProfiles) = 0 Then
		$nListViewProfiles = GUICtrlGetHandle($nListViewProfiles)
	EndIf
	If IsHWnd($nListViewRules) = 0 Then
		$nListViewRules = GUICtrlGetHandle($nListViewRules)
	EndIf
	If IsHWnd($nListViewFolders) = 0 Then
		$nListViewFolders = GUICtrlGetHandle($nListViewFolders)
	EndIf
	If IsHWnd($nListViewProcess) = 0 Then
		$nListViewProcess = GUICtrlGetHandle($nListViewProcess)
	EndIf
	If IsHWnd($nListViewCreateGallery) = 0 Then
		$nListViewCreateGallery = GUICtrlGetHandle($nListViewCreateGallery)
	EndIf
	If IsHWnd($nListViewCreateList) = 0 Then
		$nListViewCreateList = GUICtrlGetHandle($nListViewCreateList)
	EndIf

	Local $tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	Local $nWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	Local $nCode = DllStructGetData($tNMHDR, "Code")

	Local $nInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
	Local $nIndex = DllStructGetData($nInfo, "Index") ; The 'Row' Number Selected E.G. Select The 1st Item Will Return 0
	Local $nSubItem = DllStructGetData($nInfo, "SubItem") ; The 'Column' Number Selected E.G. Select The 2nd Item Will Return 1

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
					If $nIndex <> -1 And $nSubItem <> -1 And _IsPressed(11) Then
						_GUICtrlListView_SetItemChecked($nListViewRules, $nIndex, Not _GUICtrlListView_GetItemChecked($nListViewRules, $nIndex))
						$Global_ListViewRules_ItemChange = $nIndex
					EndIf
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

		Case $nListViewProcess
			Switch $nCode
				Case $NM_RCLICK
					If $G_Global_PauseSorting = 2 Then ; To Allow Show RightClick Menu Only If In Pause.
						$Global_ListViewIndex = $nIndex
						_Sorting_Pause_ContextMenu($nListViewProcess, $nIndex, $nSubItem) ; Show Process GUI RightClick Menu.
					EndIf
			EndSwitch

		Case $nListViewCreateGallery
			Switch $nCode
				Case $NM_CLICK, $NM_RCLICK
					$Global_ListViewIndex = $nIndex
			EndSwitch

		Case $nListViewCreateList
			Switch $nCode
				Case $NM_CLICK, $NM_RCLICK
					$Global_ListViewIndex = $nIndex
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_NOTIFY

Func _WM_ONDRAGDROP($hWnd, $Msg, $wParam, $lParam)
	Static $DropAccept
	Switch $Msg
		Case $WM_DRAGENTER, $WM_DROP
			Select
				Case DragDropEvent_IsFile($wParam)
					If $Msg = $WM_DROP Then
						Local $FileList = StringSplit(DragDropEvent_GetFile($wParam), "|")
						If IsArray($FileList) Then
							$Global_DroppedFiles = $FileList
							$Global_NewDroppedFiles = 1
						Else
							Local Const $aError[1] = [0]
							$Global_DroppedFiles = $aError
						EndIf
					EndIf
					$DropAccept = $DROPEFFECT_COPY
				Case DragDropEvent_IsText($wParam)
					If $Msg = $WM_DROP Then
						Local $FileList = DragDropEvent_GetText($wParam)
						;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< add support to receive text
					EndIf
					$DropAccept = $DROPEFFECT_COPY
				Case Else
					$DropAccept = $DROPEFFECT_NONE
			EndSelect
			Return $DropAccept
		Case $WM_DRAGOVER
			Return $DropAccept
	EndSwitch
EndFunc   ;==>_WM_ONDRAGDROP

Func _WM_SLEEPMODE($hWnd, $iMsg, $iwParam, $ilParam) ; Taken From: http://www.autoitscript.com/forum/topic/147311-get-notification-when-going-into-hibernatesleep-mode/
	#forceref $hWnd, $iMsg, $ilParam
	Switch $iwParam
		Case 0x0004, 0x0005 ; $PBT_APMSUSPEND, $PBT_APMSTANDBY.
			If $Global_GUI_State = 1 Then ; GUI Is Visible.
				_TrayMenu_ShowTray() ; Show The TrayMenu.
				$Global_GUI_State = 2
			EndIf
		Case 0x0007, 0x0008, 0x0012 ; $PBT_APMRESUMESUSPEND, $PBT_APMRESUMESTANDBY, $PBT_APMRESUMEAUTOMATIC.
			If $Global_GUI_State = 2 Then ; GUI Was Visible Before SleepMode.
				_TrayMenu_ShowGUI() ; Show The Target Image.
			EndIf
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_SLEEPMODE

Func _WM_SYSCOMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $ilParam
	If __Is("LockPosition") And $hWnd = $Global_GUI_1 And (_IsPressed(10) And _IsPressed(01)) = 0 Then
		If BitAND($iwParam, 0x0000FFF0) = $SC_MOVE Then
			Return 0
		EndIf
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_SYSCOMMAND
#EndRegion >>>>> WM_MESSAGES Functions <<<<<

#Region >>>>> INTERNAL: Various Functions <<<<<
Func __CMDLine($aCmdLine)
	#cs
		Description: Process CommandLine Parameters.
		Returns: 1
	#ce
	Local $aDroppedFiles[$aCmdLine[0] + 1] = [$aCmdLine[0]], $iIndex = 0
	Local $sProfile = __GetCurrentProfile() ; Get Current Profile From The Settings INI File.

	Switch $aCmdLine[1]
		Case "/Close"
			__CloseInstances()
			Exit ; Force To Close This Instance Calling _ExitEvent().
		Case "/Refresh"
			$Global_ScriptRefresh = 1
			__ScriptRestart()
		Case "/Restart"
			__ScriptRestart()
		Case "/Uninstall"
			__SendTo_Uninstall()
			__Uninstall()
			Exit ; Force To Close This Instance Calling _ExitEvent().
	EndSwitch

	For $A = 1 To $aDroppedFiles[0]
		Switch StringLeft($aCmdLine[$A], 1)
			Case "-" ; Profile Parameter.
				$sProfile = __CMDLineProfileParam($aCmdLine[$A])
				$iIndex += 1

			Case Else ; Item Parameter.
				$aDroppedFiles[$A - $iIndex] = _WinAPI_GetFullPathName($aCmdLine[$A])
		EndSwitch
	Next
	ReDim $aDroppedFiles[$aCmdLine[0] + 1 - $iIndex]
	$aDroppedFiles[0] = $aCmdLine[0] - $iIndex

	Return _DropEvent($aDroppedFiles, $sProfile) ; Send Files To Be Processed.
EndFunc   ;==>__CMDLine

Func __CMDLineProfileParam($sParameter)
	#cs
		Description: Get Profile Parameter.
		Returns: Profile
	#ce
	Local $sProfile = StringTrimLeft($sParameter, 1)
	If FileExists(__GetDefault(2) & $sProfile & ".ini") = 0 Then ; __GetDefault(2) = Get Default Profile Directory.
		$sProfile = __ProfileList_GUI() ; Show Profile Selection GUI To Select A Profile From The Profile List.
		If @error Then
			Exit ; Close DropIt If Profile Selection Is Aborted.
		EndIf
	EndIf
	Return $sProfile
EndFunc   ;==>__CMDLineProfileParam

Func __SingletonEx() ; Modified From: http://www.autoitscript.com/forum/topic/119502-solved-wm-copydata-x64-issue/
	#cs
		Description: Check If DropIt Is Already Running.
		Returns: 1 Or Window Title.
	#ce
	Local $sProfile, $iInstanceAlreadyRunning, $iStartNewInstance

	_WM_COPYDATA_SetID($G_Global_UniqueID)
	$Global_SendTo_ControlID = _WM_COPYDATA_Start($Global_GUI_1)
	$iInstanceAlreadyRunning = @error

	If $CmdLine[0] = 0 Then
		$iStartNewInstance = 1
	ElseIf $CmdLine[0] = 1 And StringLeft($CmdLine[1], 1) == "-" Then
		$sProfile = __CMDLineProfileParam($CmdLine[1])
		__SetCurrentProfile($sProfile) ; Write Default Profile Name To The Settings INI File.
		$iStartNewInstance = 1
	ElseIf $iInstanceAlreadyRunning Then
		_WM_COPYDATA_Send($CmdLineRaw) ; Send $CmdLineRaw Files To The First Instance Of DropIt.
		$iStartNewInstance = @error
	EndIf

	If $iInstanceAlreadyRunning Then
		If __Is("MultipleInstances") And $iStartNewInstance Then
			$G_Global_UniqueID &= __GetNewInstanceNumber() & "_DropIt_MultipleInstance" ; Instance Unique ID [C:\Folder\DropIt.exe12_DropIt_MultipleInstance].
			__SetMultipleInstances("+")
			$G_Global_IsMultipleInstance = 1
			Return 1
		EndIf
		OnAutoItExitUnRegister("_ExitEvent") ; Required To Correctly Close The Instance.
		_GDIPlus_Shutdown()
	Else
		If $iStartNewInstance Then
			Return 1
		EndIf
		__CMDLine($CmdLine)
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

	Local $gINISection = $G_Global_GeneralSection
	If $G_Global_IsMultipleInstance Then
		$gINISection = __GetInstanceID() ; Get ID Only As Section Name.
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

	$sINISection = $G_Global_GeneralSection
	If $G_Global_IsMultipleInstance Then
		$sINISection = __GetInstanceID() ; Get ID Only As Section Name.
	EndIf
	__IniWriteEx($sINI, $sINISection, "PosX", $aWinGetPos[0])
	__IniWriteEx($sINI, $sINISection, "PosY", $aWinGetPos[1])

	Return 1
EndFunc   ;==>__SetCurrentPosition

Func __ScriptRestart($sExit = 1) ; Modified From: http://www.autoitscript.com/forum/topic/111215-restart-udf/
	#cs
		Description: Restarts The Running Process.
		Returns: Nothing
	#ce
	Local $sUniqueID = __GetInstanceID() ; Get ID Only As Section Name.
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
	If $sExit Then
		Sleep(50)
		Exit
	EndIf
	Return 1
EndFunc   ;==>__ScriptRestart

Func __SendTo_Install() ; Modified From: http://www.autoitscript.com/forum/topic/129818-sendto-create-a-shortcut-in-the-sendto-folder/
	#cs
		Description: Create Shortcuts In The SendTo Folder. [DropIt (Profile_Name).lnk]
		Returns: 1
	#ce
	__SendTo_Uninstall()
	Local $aFileListToArray = __ProfileList_Get() ; Get Array Of All Profiles.
	If IsArray($aFileListToArray) = 0 Then
		Return SetError(1, 0, 0)
	EndIf

	Local $sLinkPath, $sIconPath, $sUseProfileIcons = __Is("SendToIcons")
	Local $sSendToDir = _WinAPI_ShellGetSpecialFolderPath($CSIDL_SENDTO)
	Local $sINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $sSendToName = IniRead($sINI, $G_Global_GeneralSection, "SendToName", "")
	If $sSendToName == "" Then
		$sSendToName = "DropIt"
	EndIf

	For $A = 1 To $aFileListToArray[0]
		If __Is("UseSendTo", -1, "False", $aFileListToArray[$A]) = 0 Then
			ContinueLoop
		EndIf
		$sLinkPath = $sSendToDir & "\" & $sSendToName & " (" & $aFileListToArray[$A] & ").lnk"
		$sIconPath = ""
		If $sUseProfileIcons Then
			$sIconPath = $sSendToDir & "\" & $sSendToName & " (" & $aFileListToArray[$A] & ").ico"
			_IconImage_ToIcoFile(_IconImage_FromImageFile(__IsProfile($aFileListToArray[$A], 2)), $sIconPath)
			;_IconImage_ToIcoFile(_IconImage_ConvertToBMPIcon(_IconImage_Scale(_IconImage_FromImageFile(__IsProfile($aFileListToArray[$A], 2)), 16, 16, $GDIP_ModeHighQuality)), $sIconPath) ; Alternative With Icon Resize.
			If @error Or FileExists($sIconPath) = 0 Then
				$sIconPath = ""
			EndIf
		EndIf
		FileCreateShortcut(@AutoItExe, $sLinkPath, @ScriptDir, "-" & $aFileListToArray[$A], "", $sIconPath)
	Next
	Return 1
EndFunc   ;==>__SendTo_Install

Func __SendTo_Uninstall() ; Modified From: http://www.autoitscript.com/forum/topic/129818-sendto-create-a-shortcut-in-the-sendto-folder/
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

	Local $sINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $sSendToName = IniRead($sINI, $G_Global_GeneralSection, "SendToName", "")
	If $sSendToName == "" Then
		$sSendToName = "DropIt"
	EndIf

	For $A = 1 To $aFileListToArray[0]
		If StringInStr($aFileListToArray[$A], $sSendToName) Then
			$aFileGetShortcut = FileGetShortcut($aFileListToArray[$A])
			If IsArray($aFileGetShortcut) = 0 Then
				ContinueLoop
			EndIf
			If $aFileGetShortcut[0] = @AutoItExe Then
				FileDelete($aFileListToArray[$A]) ; Delete Link.
				FileDelete($aFileGetShortcut[4]) ; Delete Icon.
			EndIf
		EndIf
	Next
	Return 1
EndFunc   ;==>__SendTo_Uninstall

Func __Upgrade()
	#cs
		Description: Upgrade Settings To New Version If Needed.
		Returns: 1
	#ce
	Local $uINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $uOldVersion = IniRead($uINI, $G_Global_GeneralSection, "Version", "None")
	If $uOldVersion == "None" Then
		$uOldVersion = IniRead($uINI, "General", "Version", "None") ; Get Version From Old Version (<5.1).
		__IniWriteEx($uINI, $G_Global_GeneralSection, "", __IniReadSection($uINI, "General"))
		IniDelete($uINI, "General") ; Remove Old Section.
	EndIf
	If $uOldVersion == $G_Global_CurrentVersion Then
		Return SetError(1, 0, 0) ; Abort Upgrade If INI Version Is The Same Of Current Software Version.
	EndIf

	Local $uINI_Array[60][2] = [ _
			[59, 2], _
			["Profile", 1], _
			["Language", 1], _
			["PosX", 1], _
			["PosY", 1], _
			["SizeCustom", 1], _
			["SizeManage", 1], _
			["SizeProcess", 1], _
			["ColumnCustom", 1], _
			["ColumnManage", 1], _
			["ColumnProcess", 1], _
			["OnTop", 1], _
			["LockPosition", 1], _
			["CustomTrayIcon", 1], _
			["MultipleInstances", 1], _
			["StartAtStartup", 1], _
			["Minimized", 1], _
			["PlaySound", 1], _
			["MouseScroll", 1], _ ; INI Setting Only (Not In Options).
			["MonitoredFolderHotkeys", 1], _ ; INI Setting Only (Not In Options).
			["UseSendTo", 1], _
			["SendToMode", 1], _
			["SendToIcons", 1], _ ; INI Setting Only (Not In Options).
			["SendToName", 1], _ ; INI Setting Only (Not In Options).
			["ShowSorting", 1], _
			["ShowMonitored", 1], _
			["AutoStart", 1], _
			["AutoClose", 1], _
			["ProfileEncryption", 1], _
			["ScanSubfolders", 1], _
			["FolderAsFile", 1], _
			["IgnoreNew", 1], _
			["ChangedSize", "IgnoreInUse"], _
			["IgnoreInUse", 1], _
			["IgnoreAttributes", 1], _ ; INI Setting Only (Not In Options).
			["AutoBackup", 1], _
			["AutoDup", 1], _
			["DupMode", 1], _
			["DupManualRename", 1], _ ; INI Setting Only (Not In Options).
			["CreateLog", 1], _
			["AmbiguitiesCheck", 1], _
			["SizeMessage", "AlertSize"], _
			["AlertSize", 1], _
			["AlertDelete", 1], _
			["AlertFailed", 1], _
			["AlertAmbiguity", 1], _ ; INI Setting Only (Not In Options).
			["AlertMail", 1], _ ; INI Setting Only (Not In Options).
			["FixOpenWithDestination", 1], _ ; INI Setting Only (Not In Options).
			["GraduallyHide", 1], _
			["GraduallyHideVisPx", 1], _ ; INI Setting Only (Not In Options).
			["GraduallyHideSpeed", 1], _ ; INI Setting Only (Not In Options).
			["GraduallyHideTime", 1], _ ; INI Setting Only (Not In Options).
			["GroupOrder", 1], _
			["CheckUpdates", 1], _
			["Monitoring", 1], _
			["MonitoringTime", 1], _
			["MonitoringSize", 1], _
			["MonitoringFirstAtStartup", 1], _ ; INI Setting Only (Not In Options).
			["MasterPassword", 1], _
			["EndCommandLine", 1]] ; INI Setting Only (Not In Options).

	Local $uINIRead
	FileMove($uINI, $uINI & ".old", 1) ; Rename The Old INI.
	__IsSettingsFile(-1) ; Create A New Upgraded INI.
	For $A = 1 To $uINI_Array[0][0]
		$uINIRead = IniRead($uINI & ".old", $G_Global_GeneralSection, $uINI_Array[$A][0], "None")
		If $uINIRead <> "None" Then
			If $uINI_Array[$A][1] = 1 Then
				$uINI_Array[$A][1] = $uINI_Array[$A][0]
			EndIf
			__IniWriteEx($uINI, $G_Global_GeneralSection, $uINI_Array[$A][1], $uINIRead)
		EndIf
	Next
	__IniWriteEx($uINI, "MonitoredFolders", "", __IniReadSection($uINI & ".old", "MonitoredFolders"))
	__IniWriteEx($uINI, "EnvironmentVariables", "", __IniReadSection($uINI & ".old", "EnvironmentVariables"))

	__IniReadSection($uINI & ".old", "FileContentDates")
	If @error Then
		__IniWriteEx($uINI, "FileContentDates", "", "Day=(?<!\d)([1-9]|0[1-9]|[1-2][0-9]|3[0-1])(?!\d)(?:st|nd|rd|th)?" & @LF & "MonthNumeric=(?<!\d)[1-9]|0[1-9]|1[0-2](?!\d)" & @LF & "MonthJan=Jan[[:alpha:]]*" & @LF & "MonthFeb=Feb[[:alpha:]]*" & _
			@LF & "MonthMar=Mar[[:alpha:]]*|M..?rz" & @LF & "MonthApr=Apr[[:alpha:]]*" & @LF & "MonthMay=May|Mai" & @LF & "MonthJun=Jun[[:alpha:]]*" & @LF & "MonthJul=Jul[[:alpha:]]*" & @LF & _
			"MonthAug=Aug[[:alpha:]]*" & @LF & "MonthSep=Sep[[:alpha:]]*" & @LF & "MonthOct=O[kc]t[[:alpha:]]*" & @LF & "MonthNov=Nov[[:alpha:]]*" & @LF & "MonthDec=De[cz][[:alpha:]]*" & @LF & _
			"YearShort=(?<!\d)\d{2}(?!\d)" & @LF & "YearLong=(?<!\d)\d{4}(?!\d)" & @LF & _
			"DateFormats=%DAY% *\. *%MONTH_LITERAL% *%YEAR%|%MONTH_LITERAL% +%DAY% *, *%YEAR%|%DAY% *\. *%MONTH_NUMERIC% *\. *%YEAR%|%DAY% +%MONTH_LITERAL% +%YEAR%|%DAY% *- *%MONTH_NUMERIC% *- *%YEAR_LONG%|%YEAR_LONG% *- *%MONTH_NUMERIC% *- *%DAY%")
			;            3. Oct 11                          Oct 3, 2011                       03.10.11                               3 Oct 11                       03-10-2011                                2011-10-03
	Else
		__IniWriteEx($uINI, "FileContentDates", "", __IniReadSection($uINI & ".old", "FileContentDates"))
	EndIf
	FileDelete($uINI & ".old") ; Remove The Old INI.

	If $uOldVersion < "5.1" Then
		Local $uProfileList = __ProfileList_Get(1) ; Get Array Of All Profile Paths.
		For $A = 1 To $uProfileList[0]
			__UpgradeProfile($uProfileList[$A])
		Next
	EndIf

	Return 1
EndFunc   ;==>__Upgrade

Func __UpgradeProfile($uProfile)
	#cs
		Description: Upgrade Settings Of The Defined Profile.
		Returns: 1
	#ce
	__IniWriteEx($uProfile, $G_Global_TargetSection, "", __IniReadSection($uProfile, "Target"))
	IniDelete($uProfile, "Target") ; Remove Old Section.
	__IniWriteEx($uProfile, $G_Global_GeneralSection, "", __IniReadSection($uProfile, "General"))
	IniDelete($uProfile, "General") ; Remove Old Section.
	__UpgradeAssociations($uProfile)
	IniDelete($uProfile, "Associations") ; Remove Old Section.
	Return 1
EndFunc   ;==>__UpgradeProfile
#EndRegion >>>>> INTERNAL: Various Functions <<<<<
