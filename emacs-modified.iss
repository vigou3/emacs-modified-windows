;;; Inno Setup script to build Emacs Modified for Windows
;;
;; Copyright (C) 2014-2018 Vincent Goulet
;;
;; Author: Vincent Goulet
;;
;; This file is part of Emacs Modified for Windows
;; https://gitlab.com/vigou3/emacs-modified-windows

[Setup]
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
AppName=GNU Emacs
AppVerName=GNU Emacs 26.2-modified-1
AppId=GNUEmacs-26.2-modified-1
AppPublisher=Vincent Goulet
AppPublisherURL=https://vigou3.gitlab.io/emacs-modified-windows
AppSupportURL=https://gitlab.com/vigou3/emacs-modified-windows
AppUpdatesURL=https://gitlab.com/vigou3/emacs-modified-windows
DefaultDirName={pf}\GNU Emacs 26.2
DefaultGroupName=GNU Emacs 26.2
LicenseFile=emacs\share\emacs\26.2\etc\COPYING
OutputDir=..
OutputBaseFilename=emacs-26.2-modified-1
UninstallDisplayIcon={app}\bin\runemacs.exe
Compression=lzma
SolidCompression=yes
PrivilegesRequired=none

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl";
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "catalan"; MessagesFile: "compiler:Languages\Catalan.isl"
Name: "czech"; MessagesFile: "compiler:Languages\Czech.isl"
Name: "danish"; MessagesFile: "compiler:Languages\Danish.isl"
Name: "dutch"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "finnish"; MessagesFile: "compiler:Languages\Finnish.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl";
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "hungarian"; MessagesFile: "compiler:Languages\Hungarian.isl"
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "norwegian"; MessagesFile: "compiler:Languages\Norwegian.isl"
Name: "polish"; MessagesFile: "compiler:Languages\Polish.isl"
Name: "portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "slovenian"; MessagesFile: "compiler:Languages\Slovenian.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"

[CustomMessages]
UpdateDefault=Update Default Configuration
french.UpdateDefault=Modifier la configuration par défaut
ReadMe=View the README file for this modified distribution of GNU Emacs
french.ReadMe=Consulter le fichier README de cette version modifiée de GNU Emacs (en anglais)
CPCaption=Emacs Configuration for TeX and LaTeX
french.CPCaption=Configuration de Emacs pour TeX et LaTeX
CPDescription=Are you using the MIKTeX distribution?
french.CPDescription=Utilisez-vous la distribution MIKTeX?
CPSubCaption=Emacs can be configured to better work with the MIKTeX distribution.
french.CPSubCaption=Emacs peut être configuré pour mieux fonctionner avec la distribution MIKTeX.
CPOption0=Yes, configure Emacs for MIKTeX
french.CPOption0=Oui, configurer Emacs pour MIKTeX
CPOption1=No, use the standard configuration (compatible with TeX Live)
french.CPOption1=Non, utiliser la configuration standard (compatible avec TeX Live)

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Run]
Filename: "{app}\share\emacs\26.2\README-Modified.txt"; Description: "{cm:ReadMe}"; Flags: postinstall shellexec skipifsilent

[Files]
Source: "emacs\*"; DestDir: "{app}"; Excludes: ".svn"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "site-start.el"; DestDir: "{app}\share\emacs\site-lisp"; AfterInstall: DefaultConfig('{app}'); Flags: ignoreversion
Source: "README-Modified.txt"; DestDir: "{app}\share\emacs\26.2"; Flags: ignoreversion
Source: "NEWS"; DestDir: "{app}\share\emacs\26.2"; Flags: ignoreversion

[Dirs]
Name: "{app}\share\emacs\site-lisp\site-start.d"

[Icons]
Name: "{group}\GNU Emacs"; Filename: "{app}\bin\runemacs.exe"; WorkingDir: "%HOME%"
Name: "{group}\{cm:UninstallProgram,GNU Emacs}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\GNU Emacs"; Filename: "{app}\bin\runemacs.exe"; WorkingDir: "%HOME%"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\GNU Emacs"; Filename: "{app}\bin\runemacs.exe"; WorkingDir: "%HOME%"; Tasks: quicklaunchicon

[Registry]
Root: HKCU; Subkey: "Environment"; ValueType: expandsz; ValueName: "HOME"; ValueData: "%USERPROFILE%"; Flags: createvalueifdoesntexist

[Code]
var
  ConfigPage: TInputOptionWizardPage;

procedure InitializeWizard;
begin
  ConfigPage := CreateInputOptionPage(wpLicense,
    ExpandConstant('{cm:CPCaption}'), ExpandConstant('{cm:CPDescription}'),
    ExpandConstant('{cm:CPSubCaption}'),
    True, False);
  ConfigPage.Add(ExpandConstant('{cm:CPOption0}'));
  ConfigPage.Add(ExpandConstant('{cm:CPOption1}'));

  case GetPreviousData('Distribution', '') of
    'miktex': ConfigPage.SelectedValueIndex := 0;
    'other': ConfigPage.SelectedValueIndex := 1;
  else
    ConfigPage.SelectedValueIndex := 1;
  end;
end;

procedure RegisterPreviousData(PreviousDataKey: Integer);
var
  Distribution: String;
begin
  case ConfigPage.SelectedValueIndex of
    0: Distribution := 'miktex';
    1: Distribution := 'other';
  end;
  SetPreviousData(PreviousDataKey, 'Distribution', Distribution);
end;

function ReplaceStringInFile(const FileName: String; const FromStr, ToStr: String; const Append: Boolean): Boolean;
var
  I: Integer;
  Line: String;
  StrPos: Integer;
  FileLines: TStringList;
begin
  Result := False;
  FileLines := TStringList.Create;
  if Append then
    ToStr := FromStr + #13#10 + ToStr;
  try
    FileLines.LoadFromFile(FileName);
    for I := 0 to FileLines.Count - 1 do
    begin
      Line := FileLines[I];
      StrPos := Pos(FromStr, Line);
      if StrPos > 0 then
      begin
        StringChangeEx(Line, FromStr, ToStr, True);
        FileLines[I] := Line;
        FileLines.SaveToFile(FileName);
      end;
    end;
  finally
    FileLines.Free;
  end;
end;

procedure DefaultConfig(S: String);
var
  File: String;
begin
  S := ExpandConstant(S);
  File := ExpandConstant(CurrentFileName);

  StringChangeEx(S, '\', '/', True);

  if (ConfigPage.SelectedValueIndex = 0) then
      ReplaceStringInFile(File, '(load "preview-latex.el" nil t t)', '(require ''tex-mik)', True);

  ReplaceStringInFile(File, '<EMACSDIR>', S, False);
end;
