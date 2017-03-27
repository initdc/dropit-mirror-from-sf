[Setup]
AppName=DropIt
AppVerName=DropIt (v0.9.1)
AppPublisher=Lupo PenSuite Team
AppPublisherURL=https://sourceforge.net/projects/dropit/
AppSupportURL=http://www.lupopensuite.com/contact.htm
AppUpdatesURL=https://sourceforge.net/projects/dropit/
DefaultDirName={pf}\DropIt
DefaultGroupName=DropIt
AllowNoIcons=yes
UninstallDisplayIcon={app}\DropIt.exe
InfoBeforeFile=..\DropIt_v0.9.1_Portable\docs\Readme.txt
OutputDir=..\
OutputBaseFilename=DropIt_v0.9.1_Setup
Compression=lzma/Ultra
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "associate"; Description: "Add Open with DropIt in the ContextMenu of Folders"; GroupDescription: "Shell Integration:"; Flags: unchecked
Name: "sendto"; Description: "Add Open with DropIt in the SendTo Menu"; GroupDescription: "SendTo Icon:"; Flags: unchecked

[Files]
Source: "..\DropIt_v0.9.1_Portable\DropIt.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\DropIt_v0.9.1_Portable\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\DropIt"; Filename: "{app}\DropIt.exe";Comment: "Launch DropIt";
Name: "{group}\Readme"; Filename: "{app}\docs\Readme.txt";comment: "Open Readme file.";
Name: "{sendto}\Open with DropIt"; Filename: "{app}\DropIt.exe"; Tasks: sendto;
Name: "{group}\{cm:UninstallProgram,DropIt}"; Filename: "{uninstallexe}";Comment: "Remove DropIt";
Name: "{userdesktop}\DropIt"; Filename: "{app}\DropIt.exe";Comment: "Launch DropIt"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\DropIt"; Filename: "{app}\DropIt.exe";Comment: "Launch DropIt"; Tasks: quicklaunchicon

[Registry]
Root: HKCR; Subkey: "Directory\shell\Open with DropIt"; ValueType: string; ValueName: ""; ValueData: ""; Flags: uninsdeletekey; Tasks: associate
Root: HKCR; Subkey: "Directory\shell\Open with DropIt\command"; ValueType: string; ValueName: ""; ValueData: """{app}\DropIt.exe"" ""%1"""; Flags: uninsdeletekey; Tasks: associate

[Run]
Filename: "{app}\DropIt.exe"; Description: "{cm:LaunchProgram,DropIt}"; Flags: nowait postinstall skipifsilent unchecked

[UninstallDelete]
Type: files; Name: "{app}\settings.ini"



