[Setup]
AppName=GNU Emacs
AppVerName=GNU Emacs 22.1 Modified
AppPublisher=Vincent Goulet
AppPublisherURL=http://vgoulet.act.ulaval.ca/emacs
AppSupportURL=http://vgoulet.act.ulaval.ca/emacs
AppUpdatesURL=http://vgoulet.act.ulaval.ca/emacs
DefaultDirName={pf}\GNU Emacs
DefaultGroupName=GNU Emacs
LicenseFile=emacs-22.1\etc\COPYING
OutputDir=..
OutputBaseFilename=emacs-22.1-modified-5
UninstallDisplayIcon={app}\bin\runemacs.exe
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"; InfoBeforeFile: "InfoBefore-en.txt"; InfoAfterFile: "InfoAfter-en.txt"
Name: "basque"; MessagesFile: "compiler:Languages\Basque.isl"
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "catalan"; MessagesFile: "compiler:Languages\Catalan.isl"
Name: "czech"; MessagesFile: "compiler:Languages\Czech.isl"
Name: "danish"; MessagesFile: "compiler:Languages\Danish.isl"
Name: "dutch"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "finnish"; MessagesFile: "compiler:Languages\Finnish.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"; InfoBeforeFile: "InfoBefore-fr.txt"; InfoAfterFile: "InfoAfter-fr.txt"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "hungarian"; MessagesFile: "compiler:Languages\Hungarian.isl"
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "norwegian"; MessagesFile: "compiler:Languages\Norwegian.isl"
Name: "polish"; MessagesFile: "compiler:Languages\Polish.isl"
Name: "portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "slovak"; MessagesFile: "compiler:Languages\Slovak.isl"
Name: "slovenian"; MessagesFile: "compiler:Languages\Slovenian.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"

[CustomMessages]
UpdateSiteStart=Update Site Configuration
french.UpdateSiteStart=Modifier la configuration syst�me

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "emacs-22.1\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "lib\*"; DestDir: "{app}\bin"; Flags: ignoreversion
Source: "ess-5.3.6\*"; DestDir: "{app}\site-lisp\ess-5.3.6"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "htmlize.el"; DestDir: "{app}\site-lisp"; Flags: ignoreversion
Source: "htmlize-view.el"; DestDir: "{app}\site-lisp"; Flags: ignoreversion
Source: "w32-winprint.el"; DestDir: "{app}\site-lisp"; Flags: ignoreversion
Source: "site-start.el"; DestDir: "{app}\site-lisp"; AfterInstall: AppendAspellPath('{app}/aspell/bin/aspell.exe'); Flags: ignoreversion
Source: "InfoAfter-en.txt"; DestDir: "{app}"; DestName: "Updates-en.txt"; Flags: ignoreversion
Source: "InfoAfter-fr.txt"; DestDir: "{app}"; DestName: "Updates-fr.txt"; Flags: ignoreversion
Source: "InfoBefore-en.txt"; DestDir: "{app}"; DestName: "Modifications-en.txt"; Flags: ignoreversion
Source: "NEWS"; DestDir: "{app}"; Flags: ignoreversion
Source: "aspell\*"; DestDir: "{app}\aspell"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\GNU Emacs"; Filename: "{app}\bin\runemacs.exe"; WorkingDir: "%HOME%"
Name: "{group}\{cm:UpdateSiteStart}"; Filename: "{app}\bin\runemacs.exe"; Parameters: "--no-splash ""{app}\site-lisp\site-start.el"""; WorkingDir: "%HOME%"
Name: "{group}\{cm:UninstallProgram,GNU Emacs}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\GNU Emacs"; Filename: "{app}\bin\runemacs.exe"; WorkingDir: "%HOME%"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\GNU Emacs"; Filename: "{app}\bin\runemacs.exe"; WorkingDir: "%HOME%"; Tasks: quicklaunchicon

[Registry]
Root: HKCU; Subkey: "Environment"; ValueType: expandsz; ValueName: "HOME"; ValueData: "%USERPROFILE%"; Flags: createvalueifdoesntexist

[Code]
procedure AppendAspellPath(S: String);
begin
  S := ExpandConstant(S);
  StringChangeEx(S, '\', '/', True);
  SaveStringToFile(ExpandConstant(CurrentFileName), '(setq-default ispell-program-name "' + S + '")', True);
end;

