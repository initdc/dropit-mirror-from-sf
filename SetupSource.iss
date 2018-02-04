#define MyAppVer "8.5.1"

[Setup]
AppName=DropIt
AppVersion={#MyAppVer}
AppVerName=DropIt (v{#MyAppVer})
AppPublisher=Lupo PenSuite Team
AppPublisherURL=http://www.dropitproject.com/
AppSupportURL=http://www.lupopensuite.com/contact.htm
AppUpdatesURL=http://www.dropitproject.com/
DefaultDirName={pf}\DropIt
DefaultGroupName=DropIt
AllowNoIcons=yes
UninstallDisplayIcon={app}\DropIt.exe
InfoBeforeFile=..\DropIt_v{#MyAppVer}_Portable\Readme.txt
OutputDir=..\
OutputBaseFilename=DropIt_v{#MyAppVer}_Setup
Compression=lzma2/max
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64
VersionInfoVersion={#MyAppVer}
WizardImageFile=Lib\img\WizModernImage-IS.bmp
WizardSmallImageFile=Lib\img\WizModernSmallImage-IS.bmp

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "br"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "da"; MessagesFile: "compiler:Languages\Danish.isl"
Name: "nl"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "fr"; MessagesFile: "compiler:Languages\French.isl"
Name: "de"; MessagesFile: "compiler:Languages\German.isl"
Name: "el"; MessagesFile: "compiler:Languages\Greek.isl"
Name: "hu"; MessagesFile: "compiler:Languages\Hungarian.isl"
Name: "it"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "ru"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "sr"; MessagesFile: "compiler:Languages\SerbianCyrillic.isl"
Name: "es"; MessagesFile: "compiler:Languages\Spanish.isl"

[CustomMessages]
en.CreateStartMenu=Create Start Menu icons
br.CreateStartMenu=Criar ícones no Menu Iniciar
da.CreateStartMenu=Opret Start Menuikoner
nl.CreateStartMenu=Maak Start Menu iconen
fr.CreateStartMenu=Créer Commencez icônes de menu
de.CreateStartMenu=Neues Startmenü Icons
el.CreateStartMenu=Create Start Menu icons
hu.CreateStartMenu=Create Start Menu icons
it.CreateStartMenu=Crea icone nel menu Start
ru.CreateStartMenu=Create Start Menu icons
sr.CreateStartMenu=Create Start Menu icons
es.CreateStartMenu=Crear iconos en el menú Inicio

[Tasks]
Name: "starmenuticon"; Description: "{cm:CreateStartMenu}"; GroupDescription: "{cm:AdditionalIcons}"
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "..\DropIt_v{#MyAppVer}_Portable\DropIt.exe"; DestDir: "{app}"
Source: "..\DropIt_v{#MyAppVer}_Portable\*"; DestDir: "{app}"; Excludes: "\*.exe"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\DropIt"; Filename: "{app}\DropIt.exe"; Comment: "Launch DropIt"; Tasks:starmenuticon
Name: "{group}\Readme"; Filename: "{app}\Readme.txt"; Comment: "Open Readme"; Tasks:starmenuticon
Name: "{group}\{cm:UninstallProgram,DropIt}"; Filename: "{uninstallexe}"; Comment: "Remove DropIt"; Tasks:starmenuticon
Name: "{userdesktop}\DropIt"; Filename: "{app}\DropIt.exe"; Comment: "Launch DropIt"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\DropIt"; Filename: "{app}\DropIt.exe"; Comment: "Launch DropIt"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\DropIt.exe"; Description: "{cm:LaunchProgram,DropIt}"; Flags: nowait postinstall skipifsilent unchecked

[UninstallRun]
Filename: "{app}\DropIt.exe"; Parameters: "/Uninstall"

[UninstallDelete]
Type: filesandordirs; Name: "{app}\Profiles"
