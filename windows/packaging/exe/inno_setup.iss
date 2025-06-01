[Setup]
AppId=B9F6E402-0CAE-4045-BDE6-14BD6C39C4EA
AppVersion=1.12.0+25
AppName=Elythra
AppPublisher=fncshaolin
AppPublisherURL=https://github.com/fncshaolin/elythra
AppSupportURL=https://github.com/fncshaolin/elythra
AppUpdatesURL=https://github.com/fncshaolin/elythra
DefaultDirName={autopf}\elythra
DisableProgramGroupPage=yes
OutputDir=.
OutputBaseFilename=elythra-1.12.0
Compression=lzma
SolidCompression=yes
SetupIconFile=..\..\windows\runner\resources\app_icon.ico
WizardStyle=modern
PrivilegesRequired=lowest
LicenseFile=..\..\LICENSE
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "..\..\build\windows\x64\runner\Release\elythra.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{autoprograms}\Elythra"; Filename: "{app}\elythra.exe"
Name: "{autodesktop}\Elythra"; Filename: "{app}\elythra.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\elythra.exe"; Description: "{cm:LaunchProgram,{#StringChange('Elythra', '&', '&&')}}"; Flags: nowait postinstall skipifsilent
