#define MyAppVer "4.7"

[Setup]
AppName=DropIt
AppVerName=DropIt (v{#MyAppVer})
AppPublisher=Lupo PenSuite Team
AppPublisherURL=https://sourceforge.net/projects/dropit/
AppSupportURL=http://www.lupopensuite.com/contact.htm
AppUpdatesURL=https://sourceforge.net/projects/dropit/
DefaultDirName={pf}\DropIt
DefaultGroupName=DropIt
AllowNoIcons=yes
UninstallDisplayIcon={app}\DropIt.exe
InfoBeforeFile=..\DropIt_v{#MyAppVer}_Portable_x64\Readme.txt
OutputDir=..\
OutputBaseFilename=DropIt_v{#MyAppVer}_Setup_x64
Compression=lzma2/Ultra
SolidCompression=yes
VersionInfoVersion={#MyAppVer}
WizardImageFile=Lib\img\WizModernImage-IS.bmp
WizardSmallImageFile=Lib\img\WizModernSmallImage-IS.bmp

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "..\DropIt_v{#MyAppVer}_Portable_x64\DropIt.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\DropIt_v{#MyAppVer}_Portable_x64\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\DropIt"; Filename: "{app}\DropIt.exe"; Comment: "Launch DropIt";
Name: "{group}\Readme"; Filename: "{app}\Readme.txt"; Comment: "Open Readme file";
Name: "{group}\{cm:UninstallProgram,DropIt}"; Filename: "{uninstallexe}"; Comment: "Remove DropIt";
Name: "{userdesktop}\DropIt"; Filename: "{app}\DropIt.exe"; Comment: "Launch DropIt"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\DropIt"; Filename: "{app}\DropIt.exe"; Comment: "Launch DropIt"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\DropIt.exe"; Description: "{cm:LaunchProgram,DropIt}"; Flags: nowait postinstall skipifsilent unchecked

[UninstallRun]
Filename: "{app}\DropIt.exe"; Parameters: "/Uninstall"

[UninstallDelete]
; Type: filesandordirs; Name: "{userappdata}\DropIt"
Type: filesandordirs; Name: "{app}\Profiles"
