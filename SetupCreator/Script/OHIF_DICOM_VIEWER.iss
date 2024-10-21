; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "CadavizDicomViewer"
#define MyAppVersion "1.0.1"
#define MyAppPublisher "Immersivevision Technology Pvt Ltd"
#define MyAppURL "https://immersivelabz.com/"
#define MyAppExeName "CadavizDicomViewer.exe"

[Setup]
AppId={{23E26EA7-CAFD-495A-B60F-BCD28315F0F2}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
OutputDir="..\Build"
OutputBaseFilename={#MyAppName}
Compression=none
SolidCompression=yes
WizardStyle=modern
DiskSpanning=yes
AlwaysRestart=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "Start_{#MyAppName}"; Description: "Start my app when Windows starts"; GroupDescription: "Windows Startup";

[Registry]
Root: HKLM; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "Open{#MyAppName}"; ValueData: "{app}\Open{#MyAppName}.bat"; Tasks: Start_{#MyAppName}

[Files]
Source: "\\?\Volume{7c5fa8d9-e7c8-4c95-9f55-78700830c27f}\OHIF_DICOM_VIEWER\ohif-dicom\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "\\?\Volume{7c5fa8d9-e7c8-4c95-9f55-78700830c27f}\OHIF_DICOM_VIEWER\SetupCreator\Files\Docker Desktop Installer.exe"; DestDir: "{tmp}";
Source: "\\?\Volume{7c5fa8d9-e7c8-4c95-9f55-78700830c27f}\OHIF_DICOM_VIEWER\SetupCreator\Files\installdockersilent.bat"; DestDir: "{tmp}";
Source: "\\?\Volume{7c5fa8d9-e7c8-4c95-9f55-78700830c27f}\OHIF_DICOM_VIEWER\SetupCreator\Files\OpenCadavizDicomViewer.bat"; DestDir: "{app}";

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"

[CustomMessages]
InstallingDocker=Installing docker

[Run]
Filename: "{tmp}\installdockersilent.bat"; StatusMsg: "{cm:InstallingDocker}"; Check: DOCKER; Flags: shellexec waituntilterminated runascurrentuser

[Code]
function CheckDocker(var Message: string): Boolean;
var
  DockerFileName: string;
  DockerMS, DockerLS: Cardinal;
  DockerMajorVersion, DockerMinorVersion: Cardinal;
  ExecResult: Boolean;
  ResultCode: Integer;
  ServePackagePath: string;
begin
  DockerFileName := FileSearch('docker.exe', GetEnv('PATH'));
  Result := (DockerFileName <> '');
  if not Result then
  begin
    Message := 'Docker not installed.';
  end
  else
  begin
    Log(Format('Found Docker path %s', [DockerFileName]));
    Result := GetVersionNumbers(DockerFileName, DockerMS, DockerLS);
    if not Result then
    begin
      Message := Format('Cannot read Docker version from %s', [DockerFileName]);
    end
    else
    begin
      DockerMajorVersion := DockerMS shr 16; 
      DockerMinorVersion := DockerMS and $FFFF;
      Log(Format('Docker version is %d.%d', [DockerMajorVersion, DockerMinorVersion]));
      Result := (DockerMajorVersion >= 4) and (DockerMinorVersion >= 34);
      if not Result then
      begin
        Message := 'Docker version is too old';
      end
      else
      begin
        Log('Docker is up to date');
      end;
    end;
  end;
end;

function DOCKER(): Boolean;
var
  Message: string;
  ResultCode: Integer;
begin
  Result := True;
  if not CheckDocker(Message) then
  begin
    ExtractTemporaryFile('installdockersilent.bat');
    Result := True;
  end
  else
    Result := False;
end;


