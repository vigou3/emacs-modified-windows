; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

[Setup]
AppName=GNU Emacs
AppVerName=GNU Emacs 22.1 Modified
AppPublisher=Vincent Goulet
AppPublisherURL=http://vgoulet.act.ulaval.ca/emacs
AppSupportURL=http://vgoulet.act.ulaval.ca/emacs
AppUpdatesURL=http://vgoulet.act.ulaval.ca/emacs
DefaultDirName={pf}\GNU Emacs
DefaultGroupName=GNU Emacs
LicenseFile=C:\Documents and Settings\Vincent\Mes documents\Emacs setup\emacs-22.1\etc\COPYING
OutputDir=C:\Documents and Settings\Vincent\Mes documents\Emacs setup
OutputBaseFilename=emacs-22.1-modified-2
UninstallDisplayIcon={app}\bin\runemacs.exe
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"; InfoBeforeFile: "C:\Documents and Settings\Vincent\Mes documents\Emacs setup\InfoBefore-en.txt"; InfoAfterFile: "C:\Documents and Settings\Vincent\Mes documents\Emacs setup\InfoAfter-en.txt"
Name: "basque"; MessagesFile: "compiler:Languages\Basque.isl"
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "catalan"; MessagesFile: "compiler:Languages\Catalan.isl"
Name: "czech"; MessagesFile: "compiler:Languages\Czech.isl"
Name: "danish"; MessagesFile: "compiler:Languages\Danish.isl"
Name: "dutch"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "finnish"; MessagesFile: "compiler:Languages\Finnish.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"; InfoBeforeFile: "C:\Documents and Settings\Vincent\Mes documents\Emacs setup\InfoBefore-fr.txt"; InfoAfterFile: "C:\Documents and Settings\Vincent\Mes documents\Emacs setup\InfoAfter-fr.txt"
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
Source: "C:\Documents and Settings\Vincent\Mes documents\Emacs setup\emacs-22.1\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "C:\Documents and Settings\Vincent\Mes documents\Emacs setup\ess-5.3.6\*"; DestDir: "{app}\site-lisp\ess-5.3.6"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "C:\Documents and Settings\Vincent\Mes documents\Emacs setup\htmlize.el"; DestDir: "{app}\site-lisp"; Flags: ignoreversion
Source: "C:\Documents and Settings\Vincent\Mes documents\Emacs setup\w32-winprint.el"; DestDir: "{app}\site-lisp"; Flags: ignoreversion
Source: "C:\Documents and Settings\Vincent\Mes documents\Emacs setup\site-start.el"; DestDir: "{app}\site-lisp"; AfterInstall: AppendAspellPath('{app}/aspell/bin/aspell.exe'); Flags: ignoreversion
Source: "C:\Documents and Settings\Vincent\Mes documents\Emacs setup\InfoAfter-en.txt"; DestDir: "{app}"; DestName: "Updates-en.txt"; Flags: ignoreversion
Source: "C:\Documents and Settings\Vincent\Mes documents\Emacs setup\InfoAfter-fr.txt"; DestDir: "{app}"; DestName: "Updates-fr.txt"; Flags: ignoreversion
Source: "C:\Documents and Settings\Vincent\Mes documents\Emacs setup\InfoBefore-en.txt"; DestDir: "{app}"; DestName: "Modifications-en.txt"; Flags: ignoreversion
Source: "C:\Documents and Settings\Vincent\Mes documents\Emacs setup\NEWS"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Documents and Settings\Vincent\Mes documents\Emacs setup\aspell\*"; DestDir: "{app}\aspell"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

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

