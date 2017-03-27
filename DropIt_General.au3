
; General funtions of DropIt

#include-once
#include <Array.au3>
#include <DropIt_Association.au3>
#include <DropIt_Duplicate.au3>
#include <DropIt_Global.au3>
#include <DropIt_ProfileList.au3>
#include <GUIComboBoxEx.au3>
#include <GUIConstantsEx.au3>
#include <GUIImageList.au3>
#include "Lib\udf\APIConstants.au3"
#include "Lib\udf\DropIt_LibFiles.au3"
#include "Lib\udf\DropIt_LibImages.au3"
#include "Lib\udf\DropIt_LibVarious.au3"
#include "Lib\udf\WinAPIEx.au3"

Global $G_General_Language

#Region >>>>> Main Functions <<<<<
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
		$iINIData = "Version=" & $G_Global_CurrentVersion & @LF & "Profile=Default" & @LF & "Language=" & __GetOSLanguage() & @LF & "PosX=-1" & @LF & "PosY=-1" & @LF & _
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
#EndRegion >>>>> Main Functions <<<<<

#Region >>>>> Language Functions <<<<<
Func __GetLang($sData, $sDefault, $iNotEnvironmentVariables = 0)
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
	$sData = StringReplace($sData, "@TAB", @TAB)
	$sData = StringStripWS($sData, 7)
	$sData = StringRegExpReplace($sData, "(\h*)@CRLF(\h*)|(\h*)@CR(\h*)|(\h*)@LF(\h*)", @CRLF)
	Return $sData
EndFunc   ;==>__GetLang

Func __GetCurrentLanguage()
	#cs
		Description: Get The Current Language From The Settings INI File.
		Return: Language [English]
	#ce
	Local $sINI, $sINIRead

	If $G_General_Language <> "" Then
		Return $G_General_Language ; To Speedup The Script.
	EndIf
	$sINI = __IsSettingsFile() ; Get Default Settings INI File.
	$sINIRead = IniRead($sINI, "General", "Language", __GetOSLanguage())
	If FileExists(__GetDefault(1024) & $sINIRead & ".lng") = 0 Then
		$sINIRead = __SetCurrentLanguage() ; Set Language With Default Language.
	EndIf
	$G_General_Language = $sINIRead
	Return $sINIRead
EndFunc   ;==>__GetCurrentLanguage

Func __SetCurrentLanguage($sLanguage = -1)
	#cs
		Description: Set The Current Language To The Settings INI File.
		Return: Language [English]
	#ce
	Local $sINI = __IsSettingsFile() ; Get Default Settings INI File.

	If $sLanguage == "" Or $sLanguage = -1 Then
		$sLanguage = __GetDefault(2048) ; Get Default Language.
	EndIf
	__IniWriteEx($sINI, "General", "Language", $sLanguage)
	$G_General_Language = $sLanguage
	Return $sLanguage
EndFunc   ;==>__SetCurrentLanguage

Func __LangList_Combo($lComboBox)
	#cs
		Description: Get Languages And Create String For Use In A Combo Box.
		Returns: String Of Languages.
	#ce
	Local $lIndex
	Local $lCurrentLanguage = __GetCurrentLanguage()
	Local $lImageList = $G_Global_ImageList
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
	$G_Global_ImageList = $hImageList
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
#EndRegion >>>>> Language Functions <<<<<

#Region >>>>> Profile Functions <<<<<
Func __GetCurrentProfile()
	#cs
		Description: Get The Current Profile Name From The Settings INI File.
		Return: Profile Name [Profile Name]
	#ce
	Local $sINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $sINIRead = IniRead($sINI, "General", "Profile", "Default")
	Local $sUniqueID = $G_Global_UniqueID
	If $G_Global_IsMultipleInstance Then
		$sINIRead = IniRead($sINI, $sUniqueID, "Profile", $sINIRead)
	EndIf
	Return $sINIRead
EndFunc   ;==>__GetCurrentProfile

Func __SetCurrentProfile($sProfile)
	#cs
		Description: Set The Current Profile Name To The Settings INI File.
		Return: Settings INI File [C:\Program Files\DropIt\Settings.ini]
	#ce
	Local $sINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $sINISection = "General"
	If $sProfile == -1 Or $sProfile == 0 Or $sProfile == "" Then
		$sProfile = "Default"
	EndIf
	If $G_Global_IsMultipleInstance Then
		$sINISection = $G_Global_UniqueID
	EndIf
	__IniWriteEx($sINI, $sINISection, "Profile", $sProfile)
	Return $sINI
EndFunc   ;==>__SetCurrentProfile

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
			MsgBox(0x30, __GetLang('CMDLINE_MSGBOX_0', 'Profile not found'), __GetLang('CMDLINE_MSGBOX_1', 'It appears DropIt is using an invalid Profile.') & @LF & __GetLang('CMDLINE_MSGBOX_2', 'It will be started using "Default" profile.'), 0, __OnTop())
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
		$sProfileName = __GetFileNameOnly(__Duplicate_Rename($sProfileName & ".ini", $sProfileDirectory, 0, 2))
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
					Case "CRC Hash"
						$aArray[$A][4] = 5
					Case "MD4 Hash"
						$aArray[$A][4] = 6
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
				MsgBox(0x40, __GetLang('PROFILEUNIQUE_MSGBOX_0', 'Name not available'), __GetLang('PROFILEUNIQUE_MSGBOX_1', 'This profile name already exists.'), 0, __OnTop($hHandle))
			EndIf
			Return SetError(1, 1, $sProfile)
		EndIf
		If $A = $aProfileList[0] Then
			ExitLoop
		EndIf
	Next
	Return $sProfile
EndFunc   ;==>__IsProfileUnique
#EndRegion >>>>> Profile Functions <<<<<

#Region >>>>> Log Functions <<<<<
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
		If StringInStr($lFunction, __GetLang('DROPIT_CLOSED', 'DropIt Closed')) Or StringInStr($lFunction, __GetLang('LOG_DISABLED', 'Log Disabled')) Then
			FileWriteLine($lFileOpen, "")
		EndIf
		FileClose($lFileOpen)
	EndIf
	Return 1
EndFunc   ;==>__Log_Write
#EndRegion >>>>> Log Functions <<<<<

#Region >>>>> Size Functions <<<<<
Func __GetCurrentSize($gWindow = "")
	#cs
		Description: Get The Current Size From The Settings INI File.
		Returns: Array[2]
		[0] - Width Size [300]
		[1] - Height Size [200]
	#ce
	Local $gINI = __IsSettingsFile() ; Get Default Settings INI File.
	Return StringSplit(IniRead($gINI, "General", $gWindow, "400;200"), ";", 2)
EndFunc   ;==>__GetCurrentSize

Func __SetCurrentSize($hHandle = "", $hWindow = "")
	#cs
		Description: Set The Current Size Of DropIt Windows.
		Returns: 1
	#ce
	If $hHandle = "" Then
		Return SetError(1, 0, 0)
	EndIf
	Local $aWinGetClientSize = WinGetClientSize($hHandle)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Local $sINI = __IsSettingsFile() ; Get Default Settings INI File.
	__IniWriteEx($sINI, "General", $hWindow, $aWinGetClientSize[0] & ";" & $aWinGetClientSize[1])
	Return 1
EndFunc   ;==>__SetCurrentSize
#EndRegion >>>>> Size Functions <<<<<

#Region >>>>> Others Functions <<<<<
Func __ByteSuffix($iBytes)
	#cs
		Description: Round A Value Of Bytes To Highest Value.
		Returns: [1024 Bytes = 1 KB]
	#ce
	Local $A, $iPlaces = 1, $aArray[9] = [__GetLang('SIZE_B', 'bytes'), __GetLang('SIZE_KB', 'KB'), __GetLang('SIZE_MB', 'MB'), __GetLang('SIZE_GB', 'GB'), __GetLang('SIZE_TB', 'TB'), "PB", "EB", "ZB", "YB"]
	While $iBytes > 1023
		$A += 1
		$iBytes /= 1024
	WEnd
	If $iBytes < 100 Then
		$iPlaces += 1
	EndIf
	Return Round($iBytes, $iPlaces) & " " & $aArray[$A]
EndFunc   ;==>__ByteSuffix

Func __EnvironmentVariables()
	#cs
		Description: Set The Standard & User Assigned Environment Variables.
		Returns: 1
	#ce
	Local $eEnvironmentArray[5][2] = [ _
			[4, 2], _
			["DropItLicense", "Open Source GPL"], _ ; Returns: DropIt License [Open Source GPL]
			["DropItTeam", "Lupo PenSuite Team"], _ ; Returns: Team Name [Lupo PenSuite Team]
			["DropItURL", "http://dropit.sourceforge.net/index.php"], _ ; Returns: URL Hyperlink [http://dropit.sourceforge.net/index.php]
			["DropItVersionNo", $G_Global_CurrentVersion]] ; Returns: Version Number [1.0]

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

Func __GetCompressionLevel($gLevel)
	#cs
		Description: Get Compression Level Code [3] Or Compression Level String [Normal].
	#ce
	Local $gCompressionString

	If StringIsDigit($gLevel) Then
		Switch $gLevel
			Case "1"
				$gCompressionString = __GetLang('COMPRESS_LEVEL_0', 'Fastest')
			Case "3"
				$gCompressionString = __GetLang('COMPRESS_LEVEL_1', 'Fast')
			Case "7"
				$gCompressionString = __GetLang('COMPRESS_LEVEL_3', 'Maximum')
			Case "9"
				$gCompressionString = __GetLang('COMPRESS_LEVEL_4', 'Ultra')
			Case Else ; 5.
				$gCompressionString = __GetLang('COMPRESS_LEVEL_2', 'Normal')
		EndSwitch
	Else
		Switch $gLevel
			Case __GetLang('COMPRESS_LEVEL_0', 'Fastest')
				$gCompressionString = "1"
			Case __GetLang('COMPRESS_LEVEL_1', 'Fast')
				$gCompressionString = "3"
			Case __GetLang('COMPRESS_LEVEL_3', 'Maximum')
				$gCompressionString = "7"
			Case __GetLang('COMPRESS_LEVEL_4', 'Ultra')
				$gCompressionString = "9"
			Case Else ; __GetLang('COMPRESS_LEVEL_2', 'Normal').
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
				$gDuplicateString = __GetLang('DUPLICATE_MODE_0', 'Overwrite')
			Case "Overwrite2"
				$gDuplicateString = __GetLang('DUPLICATE_MODE_1', 'Overwrite if newer')
			Case "Overwrite3"
				$gDuplicateString = __GetLang('DUPLICATE_MODE_7', 'Overwrite if different size')
			Case "Rename1"
				$gDuplicateString = __GetLang('DUPLICATE_MODE_3', 'Rename as "Name 01"')
			Case "Rename2"
				$gDuplicateString = __GetLang('DUPLICATE_MODE_4', 'Rename as "Name_01"')
			Case "Rename3"
				$gDuplicateString = __GetLang('DUPLICATE_MODE_5', 'Rename as "Name (01)"')
			Case Else ; Skip.
				$gDuplicateString = __GetLang('DUPLICATE_MODE_6', 'Skip')
		EndSwitch
	Else
		Switch $gMode
			Case __GetLang('DUPLICATE_MODE_0', 'Overwrite')
				$gDuplicateString = "Overwrite1"
			Case __GetLang('DUPLICATE_MODE_1', 'Overwrite if newer')
				$gDuplicateString = "Overwrite2"
			Case __GetLang('DUPLICATE_MODE_7', 'Overwrite if different size')
				$gDuplicateString = "Overwrite3"
			Case __GetLang('DUPLICATE_MODE_3', 'Rename as "Name 01"')
				$gDuplicateString = "Rename1"
			Case __GetLang('DUPLICATE_MODE_4', 'Rename as "Name_01"')
				$gDuplicateString = "Rename2"
			Case __GetLang('DUPLICATE_MODE_5', 'Rename as "Name (01)"')
				$gDuplicateString = "Rename3"
			Case Else ; __GetLang('DUPLICATE_MODE_6', 'Skip').
				$gDuplicateString = "Skip"
		EndSwitch
	EndIf

	Return $gDuplicateString
EndFunc   ;==>__GetDuplicateMode

Func __GetPercent($gSize, $gUpdateCurrent = 1)
	#cs
		Description: Get Current Percent Adding Defined Size.
	#ce
	Local $gCurrentSize = $G_Global_SortingCurrentSize + $gSize
	If $gUpdateCurrent = 1 Then
		$G_Global_SortingCurrentSize = $gCurrentSize
	EndIf
	Return Round($gCurrentSize / $G_Global_SortingTotalSize * 100)
EndFunc   ;==>__GetPercent

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
#EndRegion >>>>> Others Functions <<<<<
