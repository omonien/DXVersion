program DXVersionRename;

{$APPTYPE CONSOLE}

{$R *.res}


uses
  System.SysUtils,
  Classes.Rename in 'Classes.Rename.pas';

begin
  try
    var
    LFileToRename := ParamStr(1).Trim;
    if LFileToRename = '' then
    begin
      Writeln('Usage:');
      Writeln('DXVersion.exe {File to rename} [-copy]');
      Writeln('If -copy option is present, then the file will be copied instead of renamed.');
      Writeln('That leaves the original file unchanged.');
    end
    else
    begin
      var
      LCopy := ParamStr(2).ToLower.Trim = '-copy';
      var
      LNewFilename := TRename.RenameToVersion(LFileToRename, LCopy);
      Writeln(Format('%s renamed to %s', [LFileToRename, LNewFilename]));
    end;
  except
    on E: Exception do
      Writeln('Error: ', E.Message);
  end;

end.
