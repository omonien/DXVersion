program DXVersionRename;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Module.Rename in 'Module.Rename.pas';

begin
  try
    RenameFile;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
