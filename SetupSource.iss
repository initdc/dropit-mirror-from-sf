#define MyAppVer "0.9.4"

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
InfoBeforeFile=..\DropIt_v{#MyAppVer}_Portable\docs\Readme.txt
OutputDir=..\
OutputBaseFilename=DropIt_v{#MyAppVer}_Setup
Compression=lzma/Ultra
SolidCompression=yes
VersionInfoVersion={#MyAppVer}
WizardImageFile=img\WizModernImage-IS.bmp
WizardSmallImageFile=img\WizModernSmallImage-IS.bmp

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "associate"; Description: "Add ""Sort with DropIt"" in the ContextMenu"; GroupDescription: "Shell integration:"; Flags: unchecked
Name: "sendto"; Description: "Add ""DropIt"" in the SendTo menu"; GroupDescription: "SendTo icon:"; Flags: unchecked

[Files]
Source: "..\DropIt_v{#MyAppVer}_Portable\DropIt.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\DropIt_v{#MyAppVer}_Portable\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\DropIt"; Filename: "{app}\DropIt.exe"; Comment: "Launch DropIt";
Name: "{group}\Readme"; Filename: "{app}\docs\Readme.txt"; Comment: "Open Readme file";
Name: "{sendto}\DropIt"; Filename: "{app}\DropIt.exe"; Tasks: sendto;
Name: "{group}\{cm:UninstallProgram,DropIt}"; Filename: "{uninstallexe}"; Comment: "Remove DropIt";
Name: "{userdesktop}\DropIt"; Filename: "{app}\DropIt.exe"; Comment: "Launch DropIt"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\DropIt"; Filename: "{app}\DropIt.exe"; Comment: "Launch DropIt"; Tasks: quicklaunchicon

[Registry]
Root: HKCR; Subkey: "*\Shell"; ValueType: string; ValueName: ""; ValueData: ""; Flags: uninsdeletekey; Tasks: associate
Root: HKCR; Subkey: "*\Shell\Sort with DropIt"; ValueType: string; ValueName: ""; ValueData: "Sort with DropIt"; Flags: uninsdeletekey; Tasks: associate
Root: HKCR; Subkey: "*\Shell\Sort with DropIt\command"; ValueType: string; ValueName: ""; ValueData: """{app}\DropIt.exe"" ""%1"""; Flags: uninsdeletekey; Tasks: associate
Root: HKCR; Subkey: "Directory\Shell\Sort with DropIt"; ValueType: string; ValueName: ""; ValueData: ""; Flags: uninsdeletekey; Tasks: associate
Root: HKCR; Subkey: "Directory\Shell\Sort with DropIt\command"; ValueType: string; ValueName: ""; ValueData: """{app}\DropIt.exe"" ""%1"""; Flags: uninsdeletekey; Tasks: associate

[Run]
Filename: "{app}\DropIt.exe"; Description: "{cm:LaunchProgram,DropIt}"; Flags: nowait postinstall skipifsilent unchecked

[UninstallDelete]
Type: filesandordirs; Name: "{userappdata}\DropIt"
