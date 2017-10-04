
; General funtions of DropIt

#include-once
#include <Array.au3>
#include <GUIComboBoxEx.au3>
#include <GUIConstantsEx.au3>
#include <GUIImageList.au3>
#include <GUIListView.au3>
#include <WinAPIShPath.au3>

#include "DropIt_Association.au3"
#include "DropIt_Duplicate.au3"
#include "DropIt_Global.au3"
#include "DropIt_ProfileList.au3"
#include "Lib\udf\DropIt_LibFiles.au3"
#include "Lib\udf\DropIt_LibImages.au3"
#include "Lib\udf\DropIt_LibVarious.au3"
#include "Lib\udf\ResourcesEx.au3"

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
		If IniRead($iINI, $G_Global_GeneralSection, $iData, "Default") == "Default" Then
			$iINI = -1 ; Use Global Setting.
		EndIf
	EndIf
	If $iINI = -1 Then
		$iINI = __IsSettingsFile() ; Get Default Settings INI File.
	EndIf
	Return IniRead($iINI, $G_Global_GeneralSection, $iData, $iDefault) = "True"
EndFunc   ;==>__Is

Func __IsSettingsFile($iINI = -1)
	#cs
		Description: Provide A Valid Location Of The Settings INI File.
		Returns: Settings INI File [C:\Program Files\DropIt\Settings.ini]
	#ce
	If $iINI = -1 Or $iINI = 0 Or $iINI = "" Then
		$iINI = __GetDefault(64) ; Get Default Settings FullPath.
	EndIf
	If FileExists($iINI) And FileGetSize($iINI) <> 0 Then
		Return $iINI
	EndIf

	__IniWriteEx($iINI, $G_Global_GeneralSection, "", "Version=" & $G_Global_CurrentVersion & @LF & "Profile=Default" & @LF & "Language=" & __GetOSLanguage() & @LF & _
			"PosX=-1" & @LF & "PosY=-1" & @LF & "SizeCustom=320;200;-1;-1" & @LF & "SizeManage=460;260;-1;-1" & @LF & "SizeProcess=500;300;-1;-1" & @LF & _
			"ColumnCustom=100;100;60;50" & @LF & "ColumnManage=130;100;90;115" & @LF & "ColumnProcess=140;80;180;70" & @LF & "OnTop=True" & @LF & _
			"LockPosition=False" & @LF & "CustomTrayIcon=True" & @LF & "MultipleInstances=False" & @LF & "CheckUpdates=False" & @LF & "StartAtStartup=False" & @LF & _
			"Minimized=False" & @LF & "ShowSorting=True" & @LF & "ShowMonitored=False" & @LF & "MouseScroll=True" & @LF & "MonitoredFolderHotkeys=False" & @LF & _
			"UseSendTo=False" & @LF & "SendToMode=Permanent" & @LF & "SendToName=DropIt" & @LF & "SendToIcons=True" & @LF & "ProfileEncryption=False" & @LF & _
			"ScanSubfolders=False" & @LF & "FolderAsFile=False" & @LF & "AutoStart=False" & @LF & "AutoClose=True" & @LF & "PlaySound=False" & @LF & "AutoDup=False" & @LF & _
			"DupMode=Skip" & @LF & "DupManualRename=Rename1" & @LF & "CreateLog=False" & @LF & "AutoBackup=True" & @LF & "AmbiguitiesCheck=False" & @LF & _
			"IgnoreNew=False" & @LF & "IgnoreInUse=False" & @LF & "IgnoreAttributes=True" & @LF & "AlertSize=True" & @LF & "AlertDelete=False" & @LF & "AlertFailed=True" & @LF & _
			"AlertAmbiguity=False" & @LF & "AlertMail=True" & @LF & "FixOpenWithDestination=True" & @LF & "GroupOrder=Path" & @LF & "GraduallyHide=False" & @LF & _
			"GraduallyHideSpeed=5" & @LF & "GraduallyHideTime=0" & @LF & "GraduallyHideVisPx=8" & @LF & "Monitoring=False" & @LF & "MonitoringTime=60" & @LF & _
			"MonitoringSize=0" & @LF & "MonitoringFirstAtStartup=False" & @LF & "MasterPassword=" & @LF & "EndCommandLine=")
	__IniWriteEx($iINI, "MonitoredFolders", "", "")
	__IniWriteEx($iINI, "EnvironmentVariables", "", "")
	__IniWriteEx($iINI, "FileContentDates", "", "Day=(?<!\d)([1-9]|0[1-9]|[1-2][0-9]|3[0-1])(?!\d)(?:st|nd|rd|th)?" & @LF & "MonthNumeric=(?<!\d)[1-9]|0[1-9]|1[0-2](?!\d)" & @LF & "MonthJan=Jan[[:alpha:]]*" & @LF & "MonthFeb=Feb[[:alpha:]]*" & _
			@LF & "MonthMar=Mar[[:alpha:]]*|M..?rz" & @LF & "MonthApr=Apr[[:alpha:]]*" & @LF & "MonthMay=May|Mai" & @LF & "MonthJun=Jun[[:alpha:]]*" & @LF & "MonthJul=Jul[[:alpha:]]*" & @LF & _
			"MonthAug=Aug[[:alpha:]]*" & @LF & "MonthSep=Sep[[:alpha:]]*" & @LF & "MonthOct=O[kc]t[[:alpha:]]*" & @LF & "MonthNov=Nov[[:alpha:]]*" & @LF & "MonthDec=De[cz][[:alpha:]]*" & @LF & _
			"YearShort=(?<!\d)\d{2}(?!\d)" & @LF & "YearLong=(?<!\d)\d{4}(?!\d)" & @LF & _
			"DateFormats=%DAY% *\. *%MONTH_LITERAL% *%YEAR%|%MONTH_LITERAL% +%DAY% *, *%YEAR%|%DAY% *\. *%MONTH_NUMERIC% *\. *%YEAR%|%DAY% +%MONTH_LITERAL% +%YEAR%|%DAY% *- *%MONTH_NUMERIC% *- *%YEAR_LONG%|%YEAR_LONG% *- *%MONTH_NUMERIC% *- *%DAY%")
			;            3. Oct 11                          Oct 3, 2011                       03.10.11                               3 Oct 11                       03-10-2011                                2011-10-03

	If FileExists($iINI & ".old") = 0 Then ; Create Profile Examples Only If This Is The First DropIt Run And Not An Update.
		__CreateProfileExample(1) ; Archiver.
		__CreateProfileExample(2) ; Eraser.
		__CreateProfileExample(3) ; Extractor.
		__CreateProfileExample(4) ; List Maker.
		__CreateProfileExample(5) ; Playlist Maker.
		__CreateProfileExample(6) ; Gallery Maker.
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
	Return StringStripWS($sData, 7)
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
	$sINIRead = IniRead($sINI, $G_Global_GeneralSection, "Language", __GetOSLanguage())
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
	__IniWriteEx($sINI, $G_Global_GeneralSection, "Language", $sLanguage)
	$G_General_Language = $sLanguage
	Return $sLanguage
EndFunc   ;==>__SetCurrentLanguage

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
	If $aLanguageList[0] = 0 Then ; Show Default Language & NoFlag.
		ReDim $aLanguageList[2]
		$aLanguageList[0] = 1
		$aLanguageList[1] = __GetCurrentLanguage()
	EndIf
	Return $aLanguageList
EndFunc   ;==>__LangList_Get
#EndRegion >>>>> Language Functions <<<<<

#Region >>>>> Profile Functions <<<<<
Func __GetCurrentProfile()
	#cs
		Description: Get The Current Profile Name From The Settings INI File.
		Return: Profile Name [Profile Name]
	#ce
	Local $sINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $sINIRead = IniRead($sINI, $G_Global_GeneralSection, "Profile", "Default")
	If $G_Global_IsMultipleInstance Then
		Local $sUniqueID = __GetInstanceID() ; Get ID Only As Section Name.
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
	Local $sINISection = $G_Global_GeneralSection
	If $sProfile == -1 Or $sProfile == 0 Or $sProfile == "" Then
		$sProfile = "Default"
	EndIf
	If $G_Global_IsMultipleInstance Then
		$sINISection = __GetInstanceID() ; Get ID Only As Section Name.
	EndIf
	__IniWriteEx($sINI, $sINISection, "Profile", $sProfile)
	Return $sINI
EndFunc   ;==>__SetCurrentProfile

Func __CreateProfileExample($cExample)
	Local $cName, $cImage, $cSize
	Local $cProfileDirectory = __GetDefault(2) ; Get Default Profile Directory.
	Local $cNumberFields = __GetAssociationKey(-1)
	Local $cArray[5][$cNumberFields + 1] = [[4, $cNumberFields]]
	For $A = 1 To $cNumberFields
		$cArray[1][$A] = __GetAssociationKey($A - 1, 1)
	Next

	Switch $cExample
		Case 1 ; Archiver.
			$cName = __GetLang('CUSTOMIZE_EXAMPLE_0', 'Archiver')
			$cImage = "Big_Box4.png"
			$cSize = "80"
			$cArray[2][1] = $cName
			$cArray[2][2] = $G_Global_StateEnabled
			$cArray[2][3] = "*;**"
			$cArray[2][4] = "Compress"
			$cArray[2][5] = "%Desktop%\" & __GetLang('ARCHIVE', 'Archive') & ".zip"
		Case 2 ; Eraser.
			$cName = __GetLang('CUSTOMIZE_EXAMPLE_1', 'Eraser')
			$cImage = "Big_Delete1.png"
			$cSize = "80"
			$cArray[2][1] = $cName
			$cArray[2][2] = $G_Global_StateEnabled
			$cArray[2][3] = "*;**"
			$cArray[2][4] = "Delete"
			$cArray[2][5] = "Safely Erase"
		Case 3 ; Extractor.
			$cName = __GetLang('CUSTOMIZE_EXAMPLE_2', 'Extractor')
			$cImage = "Big_Box6.png"
			$cSize = "80"
			$cArray[2][1] = $cName
			$cArray[2][2] = $G_Global_StateEnabled
			$cArray[2][3] = "*.*"
			$cArray[2][4] = "Extract"
			$cArray[2][5] = "%ParentDir%"
		Case 4 ; List Maker.
			$cName = __GetLang('CUSTOMIZE_EXAMPLE_3', 'List Maker')
			$cImage = "Big_List1.png"
			$cSize = "80"
			$cArray[2][1] = "HTML"
			$cArray[2][2] = $G_Global_StateEnabled
			$cArray[2][3] = "*"
			$cArray[2][4] = "Create List"
			$cArray[2][5] = "%Desktop%\" & __GetLang('MANAGE_DESTINATION_FILE_NAME', 'DropIt List') & ".html"
			$cArray[2][7] = "#;%Counter%;" & __GetLang('LIST_LABEL_1', 'Full Name') & ";%FileNameExt%;" & __GetLang('LIST_LABEL_2', 'Directory') & ";%ParentDir%;" & __GetLang('LIST_LABEL_3', 'Size') & ";%FileSize%;" & __GetLang('LIST_LABEL_9', 'Absolute Link') & ";%LinkAbsolute%;" & __GetLang('LIST_LABEL_13', 'Date Modified') & ";%DateModified%"
			$cArray[3][1] = "PDF"
			$cArray[3][2] = $G_Global_StateEnabled
			$cArray[3][3] = "*"
			$cArray[3][4] = $cArray[2][4]
			$cArray[3][5] = "%Desktop%\" & __GetLang('MANAGE_DESTINATION_FILE_NAME', 'DropIt List') & ".pdf"
			$cArray[3][7] = __GetLang('LIST_LABEL_1', 'Full Name') & ";%FileNameExt%;" & __GetLang('LIST_LABEL_2', 'Directory') & ";%ParentDir%;" & __GetLang('LIST_LABEL_3', 'Size') & ";%FileSize%;" & __GetLang('LIST_LABEL_7', 'MD5 Hash') & ";%MD5%"
			$cArray[4][1] = "XLS"
			$cArray[4][2] = $G_Global_StateEnabled
			$cArray[4][3] = "*"
			$cArray[4][4] = $cArray[2][4]
			$cArray[4][5] = "%Desktop%\" & __GetLang('MANAGE_DESTINATION_FILE_NAME', 'DropIt List') & ".xls"
			$cArray[4][7] = __GetLang('LIST_LABEL_1', 'Full Name') & ";%FileNameExt%;" & __GetLang('LIST_LABEL_2', 'Directory') & ";%ParentDir%;" & __GetLang('LIST_LABEL_3', 'Size') & ";%FileSize%;" & __GetLang('LIST_LABEL_33', 'CRC Hash') & ";%CRC%;" & __GetLang('LIST_LABEL_12', 'Date Created') & ";%DateCreated%"
		Case 5 ; Playlist Maker.
			$cName = __GetLang('CUSTOMIZE_EXAMPLE_4', 'Playlist Maker')
			$cImage = "Big_Playlist1.png"
			$cSize = "80"
			$cArray[2][1] = "M3U"
			$cArray[2][2] = $G_Global_StateEnabled
			$cArray[2][3] = "*.aac;*.flac;*.m4a;*.mp3;*.ogg;*.wma;*.wav"
			$cArray[2][4] = "Create Playlist"
			$cArray[2][5] = "%Desktop%\" & __GetLang('PLAYLIST', 'Playlist') & ".m3u"
			$cArray[3][1] = "PLS"
			$cArray[3][2] = $G_Global_StateEnabled
			$cArray[3][3] = $cArray[2][3]
			$cArray[3][4] = $cArray[2][4]
			$cArray[3][5] = "%Desktop%\" & __GetLang('PLAYLIST', 'Playlist') & ".pls"
			$cArray[4][1] = "WPL"
			$cArray[4][2] = $G_Global_StateEnabled
			$cArray[4][3] = $cArray[2][3]
			$cArray[4][4] = $cArray[2][4]
			$cArray[4][5] = "%Desktop%\" & __GetLang('PLAYLIST', 'Playlist') & ".wpl"
		Case 6 ; Extractor.
			$cName = __GetLang('CUSTOMIZE_EXAMPLE_5', 'Gallery Maker')
			$cImage = "Big_Gallery1.png"
			$cSize = "80"
			$cArray[2][1] = $cName
			$cArray[2][2] = $G_Global_StateEnabled
			$cArray[2][3] = "*.jpg;*.gif;*.png"
			$cArray[2][4] = "Create Gallery"
			$cArray[2][5] = "%Desktop%"
			$cArray[2][13] = "2;1;"
		Case Else
			Return SetError(1, 0, 0)
	EndSwitch
	__ArrayToProfile($cArray, $cName, $cProfileDirectory, $cImage, $cSize)

	Return 1
EndFunc   ;==>__CreateProfileExample

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
		If $iArray = 3 Then Return Profile Name [ProfileName]
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
			MsgBox(0x30, __GetLang('CMDLINE_MSGBOX_0', 'Profile not found'), __GetLang('CMDLINE_MSGBOX_1', 'It appears DropIt is using an invalid Profile.') & @LF & __GetLang('CMDLINE_MSGBOX_2', 'It will be started using "Default" profile.'), 10, __OnTop())
		EndIf
		$gProfile = "Default" ; Default Profile Name.
		__SetCurrentProfile($gProfile) ; Write Default Profile Name To The Settings INI File.
	EndIf

	$gReturn[0] = $gProfileDefault[1][0] & $gProfile & ".ini" ; Profile Directory And Profile Name.
	$gReturn[1] = $gProfile ; Profile Name.
	$gReturn[2] = $gProfileDefault[1][0] ; Profile Directory

	If FileExists($gReturn[0]) = 0 Then ; If The Profile Doesn't Exist, Create It.
		__IniWriteEx($gReturn[0], $G_Global_TargetSection, "", "Image=" & $gProfileDefault[3][0] & @LF & "SizeX=64" & @LF & "SizeY=64" & @LF & "Opacity=100")
		__IniWriteEx($gReturn[0], $G_Global_GeneralSection, "", "")
	EndIf

	$gReturn[4] = IniRead($gReturn[0], $G_Global_TargetSection, "Image", "UUIDID.9CC09662-A476-4A7A-C40179A9D7DAD484.UUIDID") ; Image File.
	If FileExists($gProfileDefault[2][0] & $gReturn[4]) = 0 Then
		$gReturn[4] = $gProfileDefault[3][0]
		If FileExists($gProfileDefault[2][0] & $gReturn[4]) = 0 Then
			_Resource_SaveToFile(__GetDefault(128), "IMAGE")
		EndIf
		$gSize = __ImageSize($gProfileDefault[2][0] & $gReturn[4])
		__IniWriteEx($gReturn[0], $G_Global_TargetSection, "Image", $gReturn[4])
		__IniWriteEx($gReturn[0], $G_Global_TargetSection, "SizeX", $gSize[0])
		__IniWriteEx($gReturn[0], $G_Global_TargetSection, "SizeY", $gSize[1])
		__IniWriteEx($gReturn[0], $G_Global_TargetSection, "Opacity", 100)
		IniDelete($gReturn[0], $G_Global_TargetSection, "Transparency")
	EndIf

	$gReturn[3] = $gProfileDefault[2][0] & $gReturn[4] ; Image File FullPath.
	$gReturn[5] = IniRead($gReturn[0], $G_Global_TargetSection, "SizeX", "64") ; Image SizeX
	$gReturn[6] = IniRead($gReturn[0], $G_Global_TargetSection, "SizeY", "64") ; Image SizeY
	$gReturn[7] = IniRead($gReturn[0], $G_Global_TargetSection, "Opacity", "100") ; Image Opacity
	$gReturn[8] = $gProfileDefault[2][0]

	If $gArray = 1 Then
		Return $gReturn[0] ; Profile Path.
	EndIf
	If $gArray = 2 Then
		Return $gReturn[3] ; Profile Image Path.
	EndIf
	If $gArray = 3 Then
		Return $gReturn[1] ; Profile Name.
	EndIf
	Return $gReturn ; Array.
EndFunc   ;==>__GetProfile

Func __ArrayToProfile($aArray, $sProfileName, $sProfileDirectory = -1, $sImage = -1, $sSize = "64")
	#cs
		Description: Create A Profile From An Array.
		Return: Profile Name
	#ce
	Local $sProfilePath, $sAssociationField, $iNumberFields = __GetAssociationKey(-1)
	Local $sFields[$iNumberFields] = [$iNumberFields - 1]
	For $A = 1 To $iNumberFields - 1
		$sFields[$A] = __GetAssociationKey($A)
	Next
	ReDim $aArray[$aArray[0][0] + 1][$sFields[0] + 2]

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

	$sProfilePath = $sProfileDirectory & $sProfileName & ".ini"
	__IniWriteEx($sProfilePath, $G_Global_TargetSection, "", "Image=" & $sImage & @LF & "SizeX=" & $sSize & @LF & "SizeY=" & $sSize & @LF & "Opacity=100")
	__IniWriteEx($sProfilePath, $G_Global_GeneralSection, "", "")

	For $A = 2 To $aArray[0][0]
		$aArray[$A][1] = StringRegExpReplace($aArray[$A][1], '[;#|\[\]]', "")
		If $aArray[$A][1] = "" Then
			ContinueLoop
		EndIf
		If $aArray[$A][2] = "" Then
			$aArray[$A][2] = $G_Global_StateEnabled
		EndIf
		Switch $aArray[$A][4]
			Case __GetLang('ACTION_EXTRACT', 'Extract'), 'Extract'
				If StringInStr($aArray[$A][3], "**") Then
					ContinueLoop
				EndIf
			Case __GetLang('ACTION_OPEN_WITH', 'Open With'), 'Open With'
				If StringInStr($aArray[$A][5], "%DefaultProgram%") = 0 And (__IsValidFileType($aArray[$A][5], "bat;cmd;com;exe;pif") = 0 Or StringInStr($aArray[$A][5], "DropIt.exe")) Then ; DropIt.exe Is Excluded To Avoid Loops.
					ContinueLoop
				EndIf
			Case __GetLang('ACTION_LIST', 'Create List'), 'Create List'
				If __IsValidFileType($aArray[$A][5], "html;htm;pdf;xls;txt;csv;xml") = 0 Then
					ContinueLoop
				EndIf
			Case __GetLang('ACTION_COMPRESS', 'Compress'), 'Compress'
				If __IsValidFileType($aArray[$A][5], "zip;7z;exe") = 0 And StringInStr($aArray[$A][5], ".") Then
					ContinueLoop
				EndIf
			Case __GetLang('ACTION_PLAYLIST', 'Create Playlist'), 'Create Playlist'
				If StringInStr($aArray[$A][3], "**") Then
					ContinueLoop
				EndIf
				If __IsValidFileType($aArray[$A][5], "m3u;m3u8;pls;wpl") = 0 Then
					ContinueLoop
				EndIf
			Case __GetLang('ACTION_DELETE', 'Delete'), 'Delete'
				$aArray[$A][5] = __GetDeleteString($aArray[$A][5])
			Case __GetLang('ACTION_IGNORE', 'Ignore'), 'Ignore'
				$aArray[$A][5] = "-"
		EndSwitch
		$aArray[$A][4] = __GetActionString($aArray[$A][4])

		$sAssociationField = ""
		For $B = 1 To $sFields[0]
			If $aArray[$A][$B + 1] <> "" Then ; To Write Only Needed Fields.
				If $B > 1 Then
					$sAssociationField &= @LF
				EndIf
				$sAssociationField &= $sFields[$B] & "=" & $aArray[$A][$B + 1]
			EndIf
		Next
		__PasteAssociation($sProfilePath, $aArray[$A][1], $sAssociationField)
	Next

	Return $sProfileName
EndFunc   ;==>__ArrayToProfile

Func __ProfileToArray($sProfileName)
	#cs
		Description: Populate An Array From A Profile.
		Return: Array
	#ce
	Local $aAssociations = __GetAssociations($sProfileName) ; Get Associations Array For The Current Profile.
	Local $aArray[$aAssociations[0][0]][$aAssociations[0][1]]

	For $A = 0 To $aAssociations[0][0] - 1
		For $B = 0 To $aAssociations[0][1] - 1
			If $B = 3 Then ; Convert Action.
				$aArray[$A][$B] = __GetActionString($aAssociations[$A + 1][$B])
			ElseIf $B = 4 And $aAssociations[$A + 1][3] == "$6" Then ; Destination For Delete Action.
				$aArray[$A][$B] = __GetDeleteString($aAssociations[$A + 1][$B])
			Else
				$aArray[$A][$B] = $aAssociations[$A + 1][$B]
			EndIf
		Next
	Next

	Return $aArray
EndFunc   ;==>__ProfileToArray

Func __ArrayToCSV($aArray, $sDestination)
	#cs
		Description: Write An Array Of Associations To CSV File.
		Returns: 1
	#ce
	Local $hFileOpen, $sString, $iNumberFields = __GetAssociationKey(-1)
	Local $iRows = UBound($aArray, 1), $iCols = UBound($aArray, 2)

	For $A = 1 To $iNumberFields
		$sString &= '"' & __GetAssociationKey($A - 1, 1) & '"'
		If $A <> $iNumberFields Then
			$sString &= ', '
		Else
			$sString &= @CRLF
		EndIf
	Next

	For $A = 0 To $iRows - 1
		For $B = 0 To $iCols - 1
			$sString &= '"' & $aArray[$A][$B] & '"'
			If $B < $iCols - 1 Then
				$sString &= ', '
			EndIf
		Next
		$sString &= @CRLF
	Next

	DirCreate(__GetParentFolder($sDestination))
	$hFileOpen = FileOpen($sDestination, 2 + 8 + 128)
	FileWrite($hFileOpen, $sString)
	FileClose($hFileOpen)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	Return 1
EndFunc   ;==>__ArrayToCSV

Func __IsProfileUnique($sProfile, $sShowMessage = 0, $hHandle = -1)
	#cs
		Description: Check If A Profile Name Is Unique.
		Returns: True = ProfileName & False = @error
	#ce
	Local $aProfileList = __ProfileList_Get() ; Get Array Of All Profiles.
	$sProfile = StringReplace(StringStripWS($sProfile, 7), " ", "_")

	For $A = 1 To $aProfileList[0] ; Check If the Profile Name Already Exists.
		$aProfileList[$A] = StringReplace(StringStripWS($aProfileList[$A], 7), " ", "_")
		If StringCompare($aProfileList[$A], $sProfile, 0) = 0 Then
			If $sShowMessage Then
				MsgBox(0x40, __GetLang('PROFILEUNIQUE_MSGBOX_0', 'Name not available'), __GetLang('PROFILEUNIQUE_MSGBOX_1', 'This profile name already exists.'), 10, __OnTop($hHandle))
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

#Region >>>>> Process Functions <<<<<
Func __EnsureDirExists($sDestination)
	#cs
		Description: Ensure That Directory Exists And Create If Does Not Exist.
		Returns: Nothing.
	#ce
	If __GetFileExtension($sDestination) <> "" Then
		$sDestination = __GetParentFolder($sDestination)
	EndIf
	If FileExists($sDestination) = 0 And $sDestination <> "" Then
		If DirCreate($sDestination) = 0 Then
			MsgBox(0x40, __GetLang('POSITIONPROCESS_MSGBOX_3', 'Destination Folder Problem'), __GetLang('POSITIONPROCESS_MSGBOX_5', 'The following destination folder does not exist and cannot be created:') & @LF & _WinAPI_PathCompactPathEx($sDestination, 70), 10, __OnTop($G_Global_SortingGUI))
			Return SetError(1, 0, 0)
		EndIf
	EndIf
	Return 1
EndFunc   ;==>__EnsureDirExists

Func __SetPositionResult($sMainArray, $sFrom, $sTo, $sListView, $sElementsGUI, $sResult)
	#cs
		Description: Set The Position Result In The ListView.
		Returns: Nothing.
	#ce
	Local $sText, $sDestination, $sAction = $sMainArray[$sFrom][2]
	$sDestination = __GetDestinationString($sAction, $sMainArray[$sFrom][3])

	If $sResult == 0 Then
		$sText = __GetLang('OK', 'OK')
		__Log_Write(__GetActionResult($sAction), $sDestination)
	EndIf

	For $A = $sFrom To $sTo
		If $sMainArray[$A][4] <> -9 Then ; If Not Previously Processed.
			If $sResult <> 0 Then
				If $sResult == -1 Then
					$sText = __GetLang('POSITIONPROCESS_LOGMSG_0', 'Skipped')
				Else
					$sText = __GetLang('POSITIONPROCESS_LOGMSG_2', 'Failed')
				EndIf
				__Log_Write($sText, $sMainArray[$A][0])
			EndIf
			If $sMainArray[$A][4] <> -8 Then ; If Not Previously Virtually Processed.
				__SetProgressResult($sElementsGUI, $sMainArray[$A][1], $sMainArray[0][0], $A)
			EndIf
			_GUICtrlListView_AddSubItem($sListView, $A - 1, $sDestination, 2)
			_GUICtrlListView_AddSubItem($sListView, $A - 1, $sText, 3)
			_GUICtrlListView_EnsureVisible($sListView, $A)
		EndIf
	Next

	Return 1
EndFunc   ;==>__SetPositionResult

Func __SetProgressResult($sElementsGUI, $sSize, $sTotal = -1, $sIndex = -1)
	#cs
		Description: Set The Progress Result Of An Item.
		Returns: Nothing.
	#ce
	__SetProgressStatus($sElementsGUI, 2) ; Complete Single Progress Bar.
	__SetProgressStatus($sElementsGUI, 4, $sSize) ; Update General Progress Bar.
	If $sTotal = -1 Then
		Local $sStringSplit = StringSplit(StringReplace(GUICtrlRead($sElementsGUI[6]), " ", ""), "/")
		If $sStringSplit[0] > 1 Then
			$sIndex = Number($sStringSplit[1]) + 1
			$sTotal = $sStringSplit[2]
		Else ; For The First Item The Label Is Only Total Number.
			$sIndex = 1
			$sTotal = $sStringSplit[1]
		EndIf
	EndIf
	GUICtrlSetData($sElementsGUI[6], $sIndex & " / " & $sTotal) ; Update Counter.
EndFunc   ;==>__SetProgressResult

Func __SetProgressStatus($sElementsGUI, $sType, $sParam = 0)
	#cs
		Description: Set The Progress Status Of The Process.
		Returns: Nothing.
	#ce
	Switch $sType
		Case 1 ; Reset Single Progress Bar And Show Second Line With $sParam.
			GUICtrlSetData($sElementsGUI[1], $sParam)
			GUICtrlSetData($sElementsGUI[3], 0)
			GUICtrlSetData($sElementsGUI[5], '0 %')
		Case 2 ; Complete Single Progress Bar.
			GUICtrlSetData($sElementsGUI[3], 100)
			GUICtrlSetData($sElementsGUI[5], '100 %')
		Case 3 ; Reset General Progress Bar After Loading.
			GUICtrlSetData($sElementsGUI[2], 0)
			GUICtrlSetData($sElementsGUI[4], '0 %')
			$G_Global_SortingTotalSize = $sParam
			$G_Global_SortingCurrentSize = 0
		Case 4 ; Update General Progress Bar With $sParam = Size.
			Local $sPercent = __GetPercent($sParam)
			GUICtrlSetData($sElementsGUI[2], $sPercent)
			GUICtrlSetData($sElementsGUI[4], $sPercent & ' %')
		Case Else
			Return SetError(1, 0, 0)
	EndSwitch

	Return 1
EndFunc   ;==>__SetProgressStatus
#EndRegion >>>>> Process Functions <<<<<

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
Func __GetCurrentSize($sElement, $sDefault)
	#cs
		Description: Get The Current Size Of An Element (Window Width/Height/Left/Top Or ListView Column Widths) From The Settings INI File.
		Returns: Array[?]
		[0] - Counter [2]
		[1] - Size 1 [300]
		[2] - Size 2 [200]
	#ce
	Local $sINI = __IsSettingsFile() ; Get Default Settings INI File.
	Local $aLoad = StringSplit($sDefault, ";")
	Local $aReturn = StringSplit(IniRead($sINI, $G_Global_GeneralSection, $sElement, ""), ";")
	If $aReturn[0] <> $aLoad[0] Then
		ReDim $aReturn[$aLoad[0] + 1]
		$aReturn[0] = $aLoad[0]
		For $A = 1 To $aReturn[0]
			If $aReturn[$A] = "" Then
				$aReturn[$A] = $aLoad[$A]
			EndIf
		Next
	EndIf
	Return $aReturn
EndFunc   ;==>__GetCurrentSize

Func __SetCurrentSize($sElement, $hHandle, $iType = 0)
	#cs
		Description: Set The Current Size Of DropIt Element (Window Width/Height/Left/Top Or ListView Column Widths).
		Returns: 1
	#ce
	Local $sReturn
	Local $sINI = __IsSettingsFile() ; Get Default Settings INI File.
	If $iType = 0 Then ; Is Window.
		Local $aLoadSize = WinGetClientSize($hHandle)
		If @error Then
			Return SetError(1, 0, 0)
		EndIf
		If $aLoadSize[0] = 0 Then ; Keep Old Size If Window Is Minimized.
			Return SetError(1, 0, 0)
		EndIf
		Local $aLoadPos = WinGetPos($hHandle)
		If @error Then
			Return SetError(1, 0, 0)
		EndIf
		$sReturn = $aLoadSize[0] & ";" & $aLoadSize[1] & ";" & $aLoadPos[0] & ";" & $aLoadPos[1]
	ElseIf $iType = 1 Then ; Is ListView.
		For $A = 0 To _GUICtrlListView_GetColumnCount($hHandle) - 1
			$sReturn &= _GUICtrlListView_GetColumnWidth($hHandle, $A) & ";"
		Next
		$sReturn = StringTrimRight($sReturn, 1)
	Else
		Return SetError(1, 0, 0)
	EndIf
	__IniWriteEx($sINI, $G_Global_GeneralSection, $sElement, $sReturn)
	Return 1
EndFunc   ;==>__SetCurrentSize
#EndRegion >>>>> Size Functions <<<<<

#Region >>>>> String Functions <<<<<
Func __GetCompressionLevel($gLevel)
	#cs
		Description: Get Compression Level Code [3] Or Compression Level String [Normal].
	#ce
	Local $gReturnValue

	If StringIsDigit($gLevel) Then
		Switch $gLevel
			Case "0"
				$gReturnValue = __GetLang('COMPRESS_LEVEL_5', 'Store')
			Case "1"
				$gReturnValue = __GetLang('COMPRESS_LEVEL_0', 'Fastest')
			Case "3"
				$gReturnValue = __GetLang('COMPRESS_LEVEL_1', 'Fast')
			Case "7"
				$gReturnValue = __GetLang('COMPRESS_LEVEL_3', 'Maximum')
			Case "9"
				$gReturnValue = __GetLang('COMPRESS_LEVEL_4', 'Ultra')
			Case Else ; 5.
				$gReturnValue = __GetLang('COMPRESS_LEVEL_2', 'Normal')
		EndSwitch
	Else
		Switch $gLevel
			Case __GetLang('COMPRESS_LEVEL_5', 'Store')
				$gReturnValue = "0"
			Case __GetLang('COMPRESS_LEVEL_0', 'Fastest')
				$gReturnValue = "1"
			Case __GetLang('COMPRESS_LEVEL_1', 'Fast')
				$gReturnValue = "3"
			Case __GetLang('COMPRESS_LEVEL_3', 'Maximum')
				$gReturnValue = "7"
			Case __GetLang('COMPRESS_LEVEL_4', 'Ultra')
				$gReturnValue = "9"
			Case Else ; __GetLang('COMPRESS_LEVEL_2', 'Normal').
				$gReturnValue = "5"
		EndSwitch
	EndIf

	Return $gReturnValue
EndFunc   ;==>__GetCompressionLevel

Func __GetDuplicateMode($gMode, $gForCombo = 0)
	#cs
		Description: Get Duplicate Mode Code [Overwrite2] Or Duplicate Mode String [Overwrite if newer].
	#ce
	Local $gReturnValue

	If $gForCombo Then
		Switch $gMode
			Case "Overwrite1"
				$gReturnValue = __GetLang('DUPLICATE_MODE_0', 'Overwrite')
			Case "Overwrite2"
				$gReturnValue = __GetLang('DUPLICATE_MODE_1', 'Overwrite if newer')
			Case "Overwrite3"
				$gReturnValue = __GetLang('DUPLICATE_MODE_7', 'Overwrite if different size')
			Case "Rename1"
				$gReturnValue = __GetLang('DUPLICATE_MODE_3', 'Rename as "Name 01"')
			Case "Rename2"
				$gReturnValue = __GetLang('DUPLICATE_MODE_4', 'Rename as "Name_01"')
			Case "Rename3"
				$gReturnValue = __GetLang('DUPLICATE_MODE_5', 'Rename as "Name (01)"')
			Case Else ; Skip.
				$gReturnValue = __GetLang('DUPLICATE_MODE_6', 'Skip')
		EndSwitch
	Else
		Switch $gMode
			Case __GetLang('DUPLICATE_MODE_0', 'Overwrite')
				$gReturnValue = "Overwrite1"
			Case __GetLang('DUPLICATE_MODE_1', 'Overwrite if newer')
				$gReturnValue = "Overwrite2"
			Case __GetLang('DUPLICATE_MODE_7', 'Overwrite if different size')
				$gReturnValue = "Overwrite3"
			Case __GetLang('DUPLICATE_MODE_3', 'Rename as "Name 01"')
				$gReturnValue = "Rename1"
			Case __GetLang('DUPLICATE_MODE_4', 'Rename as "Name_01"')
				$gReturnValue = "Rename2"
			Case __GetLang('DUPLICATE_MODE_5', 'Rename as "Name (01)"')
				$gReturnValue = "Rename3"
			Case Else ; __GetLang('DUPLICATE_MODE_6', 'Skip').
				$gReturnValue = "Skip"
		EndSwitch
	EndIf

	Return $gReturnValue
EndFunc   ;==>__GetDuplicateMode

Func __GetMonitorMode($gMode, $gForCombo = 0)
	Local $gReturnValue

	If $gForCombo Then
		Switch $gMode
			Case 2
				$gReturnValue = __GetLang('MONITOR_MODE_2', 'Immediate on-change')
			Case 3
				$gReturnValue = __GetLang('MONITOR_MODE_3', 'Time interval + Immediate on-change')
			Case Else ; Time Interval.
				$gReturnValue = __GetLang('MONITOR_MODE_1', 'Time interval')
		EndSwitch
	Else
		Switch $gMode
			Case __GetLang('MONITOR_MODE_2', 'Immediate on-change')
				$gReturnValue = 2
			Case __GetLang('MONITOR_MODE_3', 'Time interval + Immediate on-change')
				$gReturnValue = 3
			Case Else ; Time Interval.
				$gReturnValue = 1
		EndSwitch
	EndIf

	Return $gReturnValue
EndFunc   ;==>__GetMonitorMode

Func __GetOrderMode($gMode, $gForCombo = 0)
	#cs
		Description: Get Group Mode Code [Name] Or Group Mode String [File Name].
	#ce
	Local $gReturnValue

	If $gForCombo Then
		Switch $gMode
			Case "Name"
				$gReturnValue = __GetLang('FILE_NAME', 'File Name')
			Case "Extension"
				$gReturnValue = __GetLang('FILE_EXT', 'Extension')
			Case "Size"
				$gReturnValue = __GetLang('FILE_SIZE', 'Size')
			Case "Created"
				$gReturnValue = __GetLang('DATE_CREATED', 'Date Created')
			Case "Modified"
				$gReturnValue = __GetLang('DATE_MODIFIED', 'Date Modified')
			Case "Opened"
				$gReturnValue = __GetLang('DATE_OPENED', 'Date Opened')
			Case Else ; Path.
				$gReturnValue = __GetLang('FILE_PATH', 'File Path')
		EndSwitch
	Else
		Switch $gMode
			Case __GetLang('FILE_NAME', 'File Name')
				$gReturnValue = "Name"
			Case __GetLang('FILE_EXT', 'Extension')
				$gReturnValue = "Extension"
			Case __GetLang('FILE_SIZE', 'Size')
				$gReturnValue = "Size"
			Case __GetLang('DATE_CREATED', 'Date Created')
				$gReturnValue = "Created"
			Case __GetLang('DATE_MODIFIED', 'Date Modified')
				$gReturnValue = "Modified"
			Case __GetLang('DATE_OPENED', 'Date Opened')
				$gReturnValue = "Opened"
			Case Else ; __GetLang('FILE_PATH', 'File Path').
				$gReturnValue = "Path"
		EndSwitch
	EndIf

	Return $gReturnValue
EndFunc   ;==>__GetOrderMode
#EndRegion >>>>> String Functions <<<<<

#Region >>>>> Others Functions <<<<<
Func __ByteSuffix($iBytes)
	#cs
		Description: Round A Value Of Bytes To Highest Value.
		Returns: [1024 Bytes = 1 KB]
	#ce
	Local $A, $iPlaces = 0, $aArray[9] = [__GetLang('SIZE_B', 'bytes'), __GetLang('SIZE_KB', 'KB'), __GetLang('SIZE_MB', 'MB'), __GetLang('SIZE_GB', 'GB'), __GetLang('SIZE_TB', 'TB'), "PB", "EB", "ZB", "YB"]
	While $iBytes > 1023
		$A += 1
		$iBytes /= 1024
	WEnd
	If $iBytes < 100 Then
		$iPlaces += 1
	EndIf
	If $iBytes < 10 Then
		$iPlaces += 1
	EndIf
	Return Round($iBytes, $iPlaces) & " " & $aArray[$A]
EndFunc   ;==>__ByteSuffix

Func __ComposeLineINI($sKey, $sValue)
	#cs
		Description: Add Key Part Only If Needed.
		Returns: INI Line
	#ce
	Local $sReturn = ""

	If $sValue <> "" Then
		$sReturn = @LF & $sKey & "=" & $sValue
	EndIf
	Return $sReturn
EndFunc   ;==>__ComposeLineINI

Func __ConvertMailText($sText, $sVisible = 0)
	#cs
		Description: Convert Mail Text.
		Returns: Text
	#ce
	If $sText <> "" Then
		If $sVisible Then
			$sText = StringReplace($sText, "/n>>", @CRLF)
			$sText = StringReplace($sText, "/d>>", ";")
			$sText = StringReplace($sText, "/b>>", "|")
		Else
			$sText = StringReplace($sText, @CRLF, "/n>>")
			$sText = StringReplace($sText, ";", "/d>>")
			$sText = StringReplace($sText, "|", "/b>>")
		EndIf
	EndIf
	Return $sText
EndFunc   ;==>__ConvertMailText

Func __EnvironmentVariables()
	#cs
		Description: Set The Standard & User Assigned Environment Variables.
		Returns: 1
	#ce
	Local $eEnvironmentArray[6][2] = [ _
			[5, 2], _
			["DropItLicense", "Open Source GPL"], _ ; Returns: DropIt License [Open Source GPL]
			["DropItTeam", "Lupo PenSuite Team"], _ ; Returns: Team Name [Lupo PenSuite Team]
			["DropItURL", "http://www.dropitproject.com/index.php"], _ ; Returns: URL Hyperlink [http://www.dropitproject.com/index.php]
			["DropItTargetURL", "http://www.dropitproject.com/targets.php"], _ ; Returns: URL Hyperlink [http://www.dropitproject.com/targets.php]
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

Func __GetInstanceID($sID = $G_Global_UniqueID)
	#cs
		Description: Get The ID Only To Use In Settings INI File For Multiple Instances.
		Returns: 1
	#ce
	Return StringTrimLeft($sID, StringLen(@ScriptFullPath)) ; Remove Path From UniqueID [C:\Folder\DropIt.exe12_DropIt_MultipleInstance].
EndFunc   ;==>__GetInstanceID

Func __GetPercent($gSize, $gUpdateCurrent = 1)
	#cs
		Description: Get Current Percent Adding Defined Size.
	#ce
	Local $gCurrentSize = $G_Global_SortingCurrentSize + $gSize
	If $gUpdateCurrent = 1 Then
		$G_Global_SortingCurrentSize = $gCurrentSize
	EndIf
	If $G_Global_SortingTotalSize = 0 Then
		Return 0
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

Func __OnTop($hHandle = -1, $iState = -1)
	#cs
		Description: Set A GUI Handle "OnTop" If True/False In The Settings INI File.
		Returns: GUI OnTop Or Not OnTop
	#ce
	If $iState = -1 Then
		$iState = __Is("OnTop")
	EndIf
	$hHandle = __IsHandle($hHandle) ; Check If GUI Handle Is A Valid Handle.

	WinSetOnTop($hHandle, "", $iState)
	Return $hHandle
EndFunc   ;==>__OnTop

Func __Uninstall()
	#cs
		Description: Uninstall Files Etc... If The Uninstall Commandline Parameter Is Called. [DropIt.exe /Uninstall]
		Returns: 1
	#ce
	If __IsInstalled() And FileExists(@AppDataDir & "\DropIt") Then
		Local $uMsgBox = MsgBox(0x4, __GetLang('UNINSTALL_MSGBOX_0', 'Remove settings'), __GetLang('UNINSTALL_MSGBOX_1', 'Do you want to remove also your settings and profiles?'))
		If $uMsgBox = 6 Then
			DirRemove(@AppDataDir & "\DropIt", 1)
		EndIf
	EndIf
	Return 1
EndFunc   ;==>__Uninstall
#EndRegion >>>>> Others Functions <<<<<
