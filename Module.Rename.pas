unit Module.Rename;

interface

uses
  System.Classes, System.SysUtils, System.IOUtils;

type
  TRename = class(TObject)
  public
    class procedure RenameToVersion(const AFilename: string);
  end;

implementation

{ TRename }

class procedure TRename.RenameToVersion(const AFilename: string);
var
  LBuild: string;
  LRelease: string;
begin
  if not TFile.Exists(AFilename) then
    raise EFileNotFoundException.CreateFmt('%s not found!', [AFilename])
  else
  begin
    LBuild := '';
    LRelease := '';
  end;
end;

end.
