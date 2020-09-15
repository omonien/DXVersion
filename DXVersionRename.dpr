program DXVersionRename;

{$APPTYPE CONSOLE}

{$R *.res}


uses
  System.SysUtils,
  Module.Rename in 'Module.Rename.pas';

begin
  try
    var
    LFileToRename := ParamStr(1).Trim;
    if LFileToRename = '' then
    begin
      Writeln('Usage:');
      Writeln('DXVersion.exe {File to rename}');
    end
    else
    begin
      var
      LNewFilename := TRename.RenameToVersion(LFileToRename);
      Writeln(Format('%s renamed to %s', [LFileToRename, LNewFilename]));
    end;
  except
    on E: Exception do
      Writeln('Error: ', E.Message);
  end;

end.
